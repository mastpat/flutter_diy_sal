import '../services/api_client.dart';
import '../models/nominee_details_model.dart';
import '../app_config.dart';

class NomineeDetailsService {
  final ApiClient api;
  NomineeDetailsService({ApiClient? client}) : api = client ?? ApiClient();

  Future<Map<String, dynamic>> saveNomineeDetails(NomineeDetailsModel model) async {
    // Client-side validation for total share
    if (!model.validateTotalPercentage()) {
      return {'success': false, 'message': 'Total share percentage must equal 100'};
    }
    final path = endpoints['save_nominee'] ?? '/save_nominee_details.php';
    return await api.post(path, model.toJson());
  }
}
