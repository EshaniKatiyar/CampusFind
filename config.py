# ─── MySQL connection config ─────────────────────────────────────────────────
# Edit these values to match your MySQL setup.
# Then never commit this file to git (add config.py to .gitignore).

import os

DB_CONFIG = {
    'host':     os.environ.get('MYSQL_HOST', 'localhost'),
    'port':     int(os.environ.get('MYSQL_PORT', 3306)),
    'user':     os.environ.get('MYSQL_USER', 'root'),
    'password': os.environ.get('MYSQL_PASSWORD', 'tiger'),
    'database': os.environ.get('MYSQL_DATABASE', 'Lost_And_Found_Management_System'),
    'charset':  'utf8mb4',
    'autocommit': False,
}