# Backend Instructions for DIY Journey

Requirements
------------
- PHP 7.4+ with PDO MySQL extension enabled
- MySQL 5.7+ or 8.0+
- Apache or Nginx hosting PHP files

Setup
-----
1. Copy all files in the `backend/` folder to your web server directory (for example, `/var/www/html/backend`).
2. Edit `backend/config.php` and set the DB_* constants with your database credentials.
3. Import the database schema:
   - mysql -u root -p < db_init.sql
4. Ensure PHP files are readable by the web server and that PHP can connect to MySQL.

Security
--------
- For production, restrict CORS and never allow Access-Control-Allow-Origin: *.
- Move config.php outside of the webroot if possible and use environment variables for DB credentials.

Sample cURL requests
--------------------
Save personal details:
curl -X POST -H "Content-Type: application/json" -d '{"employee_code":"EMP002","first_name":"John","dob":"1990-01-01","gender":"Male","phone":"9999999999"}' https://your-server.com/backend/save_personal_details.php

Get summary:
curl -X POST -H "Content-Type: application/json" -d '{"employee_code":"EMP001"}' https://your-server.com/backend/get_summary.php

Notes
-----
- validate_code.php in this build always returns success (checks removed). Re-enable logic as needed in production.
- Endpoints use prepared statements and transactions where appropriate.
- If you encounter PDO exceptions, check DB credentials, database existence, and user privileges.

Troubleshooting
---------------
- PDOException on connection: ensure DB_HOST, DB_NAME, DB_USER, DB_PASS are correct.
- Permission errors: ensure web server user has read access to PHP files.
- HTTP 500: check PHP error logs for stack traces and fix code or DB issues.
