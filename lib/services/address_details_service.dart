import '../services/api_client.dart';
import '../models/address_details_model.dart';
import '../app_config.dart';

class AddressDetailsService {
  final ApiClient api;
  AddressDetailsService({ApiClient? client}) : api = client ?? ApiClient();

  Future<Map<String, dynamic>> saveAddress(AddressDetailsModel model) async {
    final path = endpoints['save_address'] ?? '/save_address_details.php';
    return await api.post(path, model.toJson());
  }

  Future<Map<String, dynamic>> lookupPincode(String pincode) async {
    // Example: backend may expose a pincode lookup endpoint; not implemented server-side in this deliverable.
    final path = '/pincode_lookup.php';
    return await api.post(path, {'pincode': pincode});
  }
}
