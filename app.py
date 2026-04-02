from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector
from mysql.connector import Error
from config import DB_CONFIG

app = Flask(__name__, static_folder='static', template_folder='templates')
CORS(app, origins=[
    'http://localhost:5000',
    'https://eshanikatiyar.github.io'
])


def get_db():
    """Open a fresh DB connection for each request."""
    return mysql.connector.connect(**DB_CONFIG)


# ─────────────────────────────────────────────────────────────────────────────
# GET /api/items  →  union of lost_items + found_items + claim status overlay
# ─────────────────────────────────────────────────────────────────────────────
@app.route('/api/items', methods=['GET'])
def get_items():
    try:
        db = get_db()
        cur = db.cursor(dictionary=True)

        # Pull lost items; mark as 'claimed' if their claim is approved
        cur.execute("""
            SELECT
                CONCAT('lost-', l.lost_id)   AS id,
                'lost'                        AS source_table,
                l.lost_id                     AS source_id,
                u.name                        AS reporter,
                (l.user_id = 1)               AS reporter_is_default,
                l.item_name                   AS name,
                l.category                    AS cat,
                l.description                 AS description,
                l.location                    AS loc,
                l.date_lost                   AS date,
                CASE
                    WHEN c.claim_status = 'approved' THEN 'claimed'
                    ELSE l.status
                END                           AS type
            FROM lost_items l
            LEFT JOIN users u ON l.user_id = u.user_id
            LEFT JOIN claims c ON c.lost_id = l.lost_id AND c.claim_status = 'approved'
        """)
        lost = cur.fetchall()

        # Pull found items; mark as 'claimed' if their claim is approved
        cur.execute("""
            SELECT
                CONCAT('found-', f.found_id)  AS id,
                'found'                        AS source_table,
                f.found_id                     AS source_id,
                u.name                         AS reporter,
                (f.user_id = 1)                AS reporter_is_default,
                f.item_name                    AS name,
                f.category                     AS cat,
                f.description                  AS description,
                f.location_found               AS loc,
                f.date_found                   AS date,
                CASE
                    WHEN c.claim_status = 'approved' THEN 'claimed'
                    ELSE f.status
                END                            AS type
            FROM found_items f
            LEFT JOIN users u ON f.user_id = u.user_id
            LEFT JOIN claims c ON c.found_id = f.found_id AND c.claim_status = 'approved'
        """)
        found = cur.fetchall()

        cur.close()
        db.close()

        # Serialize dates; user_id=1 is the true anonymous fallback
        all_items = []
        for row in lost + found:
            row['date'] = str(row['date']) if row['date'] else ''
            if row.get('reporter_is_default') or not row.get('reporter'):
                row['reporter'] = 'Anonymous'
            row.pop('reporter_is_default', None)
            all_items.append(row)

        return jsonify(all_items), 200

    except Error as e:
        return jsonify({'error': str(e)}), 500


# ─────────────────────────────────────────────────────────────────────────────
# POST /api/items  →  insert into lost_items OR found_items
# Body: { type, name, cat, description, loc, date, reporter_name }
# ─────────────────────────────────────────────────────────────────────────────
@app.route('/api/items', methods=['POST'])
def add_item():
    data = request.get_json()
    item_type   = data.get('type', 'lost')       # 'lost' or 'found'
    name        = data.get('name', '').strip()
    cat         = data.get('cat', 'Other')
    desc        = data.get('description', '')
    loc         = data.get('loc', '')
    date        = data.get('date')
    reporter    = data.get('reporter', 'Anonymous').strip() or 'Anonymous'

    if not name:
        return jsonify({'error': 'Item name is required'}), 400

    try:
        db = get_db()
        cur = db.cursor()

        # Try to find existing user; if not found, insert a new user record so the
        # reporter name is preserved properly instead of falling back to user_id=1.
        cur.execute("SELECT user_id FROM users WHERE name = %s LIMIT 1", (reporter,))
        row = cur.fetchone()
        if row:
            user_id = row[0]
        else:
            # Insert a new user row for this reporter so the name is stored properly
            fake_email = reporter.lower().replace(' ', '_') + '_auto@campusfind.local'
            cur.execute(
                "INSERT IGNORE INTO users (name, email, password, role) VALUES (%s, %s, 'auto', 'user')",
                (reporter, fake_email)
            )
            db.commit()
            cur.execute("SELECT user_id FROM users WHERE name = %s LIMIT 1", (reporter,))
            row = cur.fetchone()
            user_id = row[0] if row else 1

        if item_type == 'lost':
            cur.execute("""
                INSERT INTO lost_items (user_id, item_name, category, description, location, date_lost, status)
                VALUES (%s, %s, %s, %s, %s, %s, 'lost')
            """, (user_id, name, cat, desc, loc, date))
            new_id = f"lost-{cur.lastrowid}"
        else:
            cur.execute("""
                INSERT INTO found_items (user_id, item_name, category, description, location_found, date_found, status)
                VALUES (%s, %s, %s, %s, %s, %s, 'found')
            """, (user_id, name, cat, desc, loc, date))
            new_id = f"found-{cur.lastrowid}"

        db.commit()
        cur.close()
        db.close()

        return jsonify({'id': new_id, 'message': 'Item added successfully'}), 201

    except Error as e:
        return jsonify({'error': str(e)}), 500


# ─────────────────────────────────────────────────────────────────────────────
# PATCH /api/items/<id>/claim  →  update status + insert into claims table
# id format: "lost-3" or "found-7"
# Body: { claimant_id (optional), note (optional) }
# ─────────────────────────────────────────────────────────────────────────────
@app.route('/api/items/<item_id>/claim', methods=['PATCH'])
def claim_item(item_id):
    data         = request.get_json() or {}
    claimant_id  = data.get('claimant_id', 1)
    note         = data.get('note', 'Marked claimed via UI')

    try:
        table, source_id = item_id.split('-', 1)
        source_id = int(source_id)
    except ValueError:
        return jsonify({'error': 'Invalid item id format'}), 400

    try:
        db = get_db()
        cur = db.cursor()

        if table == 'lost':
            cur.execute("UPDATE lost_items SET status = 'claimed' WHERE lost_id = %s", (source_id,))
            cur.execute("""
                INSERT INTO claims (lost_id, found_id, claimant_id, claim_status, verification_note)
                VALUES (%s, NULL, %s, 'approved', %s)
            """, (source_id, claimant_id, note))
        else:
            cur.execute("UPDATE found_items SET status = 'claimed' WHERE found_id = %s", (source_id,))
            cur.execute("""
                INSERT INTO claims (lost_id, found_id, claimant_id, claim_status, verification_note)
                VALUES (NULL, %s, %s, 'approved', %s)
            """, (source_id, claimant_id, note))

        db.commit()
        cur.close()
        db.close()

        return jsonify({'message': 'Item marked as claimed'}), 200

    except Error as e:
        return jsonify({'error': str(e)}), 500


# ─────────────────────────────────────────────────────────────────────────────
# DELETE /api/items/<id>  →  delete from lost_items or found_items (+ claims)
# ─────────────────────────────────────────────────────────────────────────────
@app.route('/api/items/<item_id>', methods=['DELETE'])
def delete_item(item_id):
    try:
        table, source_id = item_id.split('-', 1)
        source_id = int(source_id)
    except ValueError:
        return jsonify({'error': 'Invalid item id format'}), 400

    try:
        db = get_db()
        cur = db.cursor()

        # Delete related claims first (FK constraint)
        if table == 'lost':
            cur.execute("DELETE FROM claims WHERE lost_id = %s", (source_id,))
            cur.execute("DELETE FROM lost_items WHERE lost_id = %s", (source_id,))
        else:
            cur.execute("DELETE FROM claims WHERE found_id = %s", (source_id,))
            cur.execute("DELETE FROM found_items WHERE found_id = %s", (source_id,))

        db.commit()
        cur.close()
        db.close()

        return jsonify({'message': 'Item deleted'}), 200

    except Error as e:
        return jsonify({'error': str(e)}), 500


# ─────────────────────────────────────────────────────────────────────────────
# Serve frontend
# ─────────────────────────────────────────────────────────────────────────────
from flask import send_from_directory

@app.route('/')
def index():
    return send_from_directory('templates', 'index.html')


if __name__ == '__main__':
    app.run(debug=True, port=5000)