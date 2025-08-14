import '../services/api_client.dart';
import '../models/family_details_model.dart';
import '../app_config.dart';

class FamilyDetailsService {
  final ApiClient api;
  FamilyDetailsService({ApiClient? client}) : api = client ?? ApiClient();

  Future<Map<String, dynamic>> saveFamilyDetails(FamilyDetailsModel model) async {
    final path = endpoints['save_family'] ?? '/save_family_details.php';
    return await api.post(path, model.toJson());
  }
}
