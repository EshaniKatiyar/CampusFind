import os

DB_CONFIG = {
    'host':     os.environ.get('MYSQLHOST', 'localhost'),
    'port':     int(os.environ.get('MYSQLPORT', 3306)),
    'user':     os.environ.get('MYSQLUSER', 'root'),
    'password': os.environ.get('MYSQLPASSWORD', 'tiger'),
    'database': os.environ.get('MYSQLDATABASE', 'Lost_And_Found_Management_System'),
    'charset':  'utf8mb4',
    'autocommit': False,
}