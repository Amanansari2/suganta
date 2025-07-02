import 'dart:convert';

import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tytil_realty/api_service/token.dart';

import 'api_exception.dart';
import 'internet_conectivity.dart';
import 'logging_service.dart';
import 'package:http/http.dart' as http;


class DeleteService extends GetxService {

  static Future<Map<String, dynamic>> deleteRequest({
    required String url,
    bool requiresAuth = false,
    Map<String, String>? customHeaders,
    Map<String, dynamic>? body,
  }) async {
    if (!await InternetConnectivity.isConnected()) {
      LoggerService.logWarning("No internet connected. request aborted");
      return {"success": false, "message": "No internet connection"};
    }

    try {

      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final path = Uri.parse(url).path;
      final xurlToken = Sha256Token.urlPath(path);
      final xApiToken = Sha256Token.generateTokenTimeStamp(timestamp);
      final xToken = Sha256Token.token(encodedUrl: path, timestamp: timestamp);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Api-Token' : xApiToken,
        'X-Token' : xToken,
        'X-Url-Token': xurlToken
      };

      if (requiresAuth) {
        String? token = GetStorage().read("auth_token");

        if (token == null) {
          LoggerService.logWarning("Missing Authentication token");
          return {"success": false, "message": "Authentication required"};
        }
        headers["Authorization"] = "Bearer $token";
      }

      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }

      LoggerService.logRequest(url: url, body: body ??{}, headers: headers);

      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      LoggerService.logHttpResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "data": jsonDecode(response.body)};
      }

      return ApiException.handleHttpError(response);

    } catch (e) {
      LoggerService.logWarning("Unexpected Error --->>> $e");
      return {"success": false, "message": "Unexpected Error -->> $e"};
    }
  }
}
