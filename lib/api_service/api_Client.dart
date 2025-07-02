// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
//
// class ApiClient extends GetConnect{
//   final box = GetStorage();
//
//   @override
//   void onInit() {
//     httpClient.timeout = const Duration(seconds: 30);
//     super.onInit();
//   }
//
//   Future<Response> postRequest (String url, dynamic body, {bool requiresAuth = false}) async {
//
//     Map<String, String> headers = {
//       'Content-Type' : 'application/json',
//       'Accept': 'application/json'
//     };
//
//     if(requiresAuth){
//       String? token = box.read("auth_token");
//
//       if(token !=  null ){
//         headers["Authorization"] = "Bearer $token";
//       } else {
//         return const Response(statusCode: 401, body: {"success":false, "message":"Authentication required"});
//       }
//     }
//
//     return await post(url, body, headers: headers);
//   }
//
// }



import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class ApiClient {
  final http.Client _client = http.Client();
  final box = GetStorage();
  bool _hasLoggedOut = false;

  Future<http.Response> get(String url, {Map<String, String>? headers, bool requiresAuth = false}) async {
    final reqHeaders = await _buildHeaders(headers, requiresAuth);
    final response = await _client.get(Uri.parse(url), headers: reqHeaders);
    _checkUnauthorized(response);
    return response;
  }

  Future<http.Response> post(String url, dynamic body, {Map<String, String>? headers, bool requiresAuth = false}) async {
    final reqHeaders = await _buildHeaders(headers, requiresAuth);
    final response = await _client.post(Uri.parse(url), headers: reqHeaders, body: jsonEncode(body));
    _checkUnauthorized(response);
    return response;
  }

  Future<http.Response> put(String url, dynamic body, {Map<String, String>? headers, bool requiresAuth = false}) async {
    final reqHeaders = await _buildHeaders(headers, requiresAuth);
    final response = await _client.put(Uri.parse(url), headers: reqHeaders, body: jsonEncode(body));
    _checkUnauthorized(response);
    return response;
  }

  Future<http.Response> delete(String url, {Map<String, String>? headers, bool requiresAuth = false}) async {
    final reqHeaders = await _buildHeaders(headers, requiresAuth);
    final response = await _client.delete(Uri.parse(url), headers: reqHeaders);
    _checkUnauthorized(response);
    return response;
  }

  Future<http.Response> sendMultipartRequest(http.MultipartRequest request) async {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    _checkUnauthorized(response);
    return response;
  }


  Future<Map<String, String>> _buildHeaders(Map<String, String>? customHeaders, bool requiresAuth) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      String? token = box.read('auth_token');
      if (token == null) {
        _handleUnauthorized();
        throw Exception('Authentication required');
      }
      headers['Authorization'] = 'Bearer $token';
    }

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  void _checkUnauthorized(http.Response response) {
    if (response.statusCode == 401) {
      _handleUnauthorized();
    }
  }



  void _handleUnauthorized() {
    if (_hasLoggedOut) return;
    _hasLoggedOut = true;

    box.remove('auth_token');
    Get.offAllNamed(AppRoutes.loginView);
  }

  void dispose() {
    _client.close();
  }
}
