import '../services/api_client.dart';
import '../app_config.dart';

class SummaryService {
  final ApiClient api;
  SummaryService({ApiClient? client}) : api = client ?? ApiClient();

  Future<Map<String, dynamic>> finalizeOnboarding(String employeeCode) async {
    final path = endpoints['finalize'] ?? '/finalize_onboarding.php';
    return await api.post(path, {'employee_code': employeeCode});
  }

  Future<Map<String, dynamic>> getSummary(String employeeCode) async {
    final path = endpoints['get_summary'] ?? '/get_summary.php';
    return await api.post(path, {'employee_code': employeeCode});
  }
}
