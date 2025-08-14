import '../services/api_client.dart';
import '../models/personal_details_model.dart';
import '../app_config.dart';

class PersonalDetailsService {
  final ApiClient api;
  PersonalDetailsService({ApiClient? client}) : api = client ?? ApiClient();

  /// Sends personal details to backend.
  /// Returns the server response map.
  Future<Map<String, dynamic>> savePersonalDetails(PersonalDetailsModel model) async {
    final path = endpoints['save_personal'] ?? '/save_personal_details.php';
    return await api.post(path, model.toJson());
  }
}
