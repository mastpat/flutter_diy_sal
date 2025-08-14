// Central configuration for API endpoints and helpers.
// IMPORTANT: Replace API_BASE_URL with your running backend URL, e.g.:
// const String API_BASE_URL = "https://example.com/backend";
const String API_BASE_URL = "https://your-server.com/backend";
const Duration apiTimeout = Duration(seconds: 15);

// Small India bounding box kept for reference (not used in current UI).
const Map<String, double> INDIA_BBOX = {
  'min_lat': 6.5546079,
  'min_lon': 68.1113787,
  'max_lat': 35.6745457,
  'max_lon': 97.395561,
};

final Map<String, String> endpoints = {
  'validate_code': '/validate_code.php',
  'save_personal': '/save_personal_details.php',
  'save_address': '/save_address_details.php',
  'save_family': '/save_family_details.php',
  'save_nominee': '/save_nominee_details.php',
  'finalize': '/finalize_onboarding.php',
  'get_summary': '/get_summary.php',
};

String buildUrl(String path) => '$API_BASE_URL$path';

// Expected server response format (example):
// {
//   "success": true,
//   "message": "Saved",
//   "data": { ... }
// }
