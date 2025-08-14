# DIY Journey

Overview
--------
DIY Journey is a Flutter onboarding application that saves form data locally and can optionally be integrated with a PHP/MySQL backend. Per project instructions, all pre-launch checks (code validation, location, expiry checks) have been removed and the app launches directly to the Main Screen for faster access.

Architecture
------------
- Flutter frontend (lib/)
- PHP backend endpoints (backend/)
- MySQL initialization script (backend/db_init.sql)
- Local persistence via SharedPreferences

Run the Flutter app
-------------------
Requirements:
- Flutter SDK 3.x or later
- An emulator or a connected device

Steps:
1. Clone the repository.
2. Update lib/app_config.dart and set `API_BASE_URL` to your backend root URL (e.g., `https://example.com/backend`) if you plan to enable server sync.
3. From project root run:
   - flutter pub get
   - flutter run

Notes:
- The app by default saves forms locally using SharedPreferences. To enable server calls, call the service methods found in lib/services/*.dart (they are implemented but not called automatically).
- The app's initial route is '/main' to load the MainScreen directly. To revert to showing the splash screen first, edit lib/main.dart and change initialRoute to '/'.

Backend setup
-------------
Requirements:
- PHP 7.4+ with PDO enabled
- MySQL 5.7+ / 8.0+
- Apache or Nginx

Steps:
1. Place files from backend/ into your web root or a subdirectory (e.g., /var/www/html/backend).
2. Edit backend/config.php and set DB_HOST, DB_NAME, DB_USER, DB_PASS to match your MySQL configuration.
3. Import the SQL schema:
   - mysql -u root -p < backend/db_init.sql
4. Ensure PHP files are readable by the web server and that your webserver can execute them.

API contract
------------
All API endpoints return JSON with the following structure:
{
  "success": true|false,
  "message": "Some message",
  "data": { ... }
}

Endpoints:
- validate_code.php
  - Request: { "code": "EMP001", "expiry_iso": "2025-12-31T..." }
  - Response (this build): returns success=true (validation bypassed)
- save_personal_details.php
  - Request: { employee_code, first_name, last_name, dob, gender, email, phone }
  - Response: { success: true, message: 'Personal details saved', data: { id: ... } }
- save_address_details.php
  - Request: { employee_code, address1, address2, city, state, district, pincode, landmark }
  - Response: { success: true, data: { id: ... } }
- save_family_details.php
  - Request: { employee_code, members: [ { name, relation, age, occupation }, ... ] }
  - Response: { success: true, data: { inserted_count: N } }
- save_nominee_details.php
  - Request: { employee_code, nominees: [ { name, relation, age, share_percentage }, ... ] }
  - Response: { success: true, data: { inserted_count: N } }
- finalize_onboarding.php
  - Request: { employee_code }
  - Response: { success: true, data: { membership_id, completed_at } }
- get_summary.php
  - Request: { employee_code }
  - Response: { success: true, data: { personal: {...}, address: {...}, family: [...], nominees: [...], onboarding: {...} } }

Testing the app
---------------
- Run `flutter run` and navigate through the onboarding flow.
- The app saves locally; to reset, you can clear SharedPreferences or reinstall the app.

Re-enabling checks
------------------
This deliverable intentionally removes code/location/expiry checks. To re-enable:
- Use geolocator/geocoding packages and add checks in SplashScreen or main before navigating.
- Call the validate_code endpoint in SplashScreen or before allowing onboarding to continue.

Backend README
--------------
See backend/README.md for detailed backend deployment and sample cURL commands.

Troubleshooting
---------------
- Ensure PHP PDO MySQL extension is enabled.
- Check file permissions for backend PHP files.
- If endpoints return errors, inspect server logs for PDO exceptions.

License
-------
This project is licensed under the MIT License - see LICENSE file for details.

Contact
-------
For help, modify code in lib/ and backend/ and test locally. This project was generated to run locally and to be extended to production by the developer.
