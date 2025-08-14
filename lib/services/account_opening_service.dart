import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/account_opening_request.dart';

class AccountOpeningService {
  final String apiUrl = "https://your-backend.com/api/open-account";

  Future<bool> submitRequest(AccountOpeningRequest request) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    return response.statusCode == 200;
  }
}
