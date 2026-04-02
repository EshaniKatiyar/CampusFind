# ─── MySQL connection config ─────────────────────────────────────────────────
# Edit these values to match your MySQL setup.
# Then never commit this file to git (add config.py to .gitignore).

DB_CONFIG = {
    'host':     'localhost',      # or '127.0.0.1'
    'port':     3306,             # default MySQL port
    'user':     'root',           # your MySQL username
    'password': 'tiger',   # your MySQL password  ← CHANGE THIS
    'database': 'Lost_And_Found_Management_System',
    'charset':  'utf8mb4',
    'autocommit': False,
}
