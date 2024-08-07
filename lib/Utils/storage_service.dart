// lib/services/storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';

// Store token after login
Future<void> storeToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwt_token', token);
}

// Retrieve token when needed
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token');
}
