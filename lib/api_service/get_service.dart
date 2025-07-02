//
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:suganta_international/api_service/internet_conectivity.dart';
// import 'package:suganta_international/api_service/logging_service.dart';
//
// import 'api_exception.dart';
//
// class GetService extends GetConnect{
//
//
//
//   static Future<Map<String, dynamic>> getRequest ({
//     required String url,
//     bool requiresAuth = false,
//     Map<String, String>? customHeaders,
//
//   }) async{
//     if(!await InternetConnectivity.isConnected()){
//       LoggerService.logWarning("No internet connected. request aborted");
//       return {"success": false, "message":"No internet connection"};
//     }
//
//     try {
//       Map<String, String> headers = {'Content-Type': 'application/json'};
//
//       if (requiresAuth) {
//         String? token = GetStorage().read("auth_token");
//
//         if (token == null) {
//           LoggerService.logWarning("Missing Authentication token");
//           return {"success": false, "message": "Authentication required"};
//         }
//         headers["Authorization"] = "Bearer $token";
//       }
//
//       if (customHeaders != null) {
//         headers.addAll(customHeaders);
//       }
//       LoggerService.logRequest(url: url, body: {}, headers: headers);
//
//       final Response<dynamic> response = await GetConnect().get(url, headers: headers);
//
//      // LoggerService.logResponse(response);
//
//
//       if (response.body == null) {
//         LoggerService.logWarning(" API Response is NULL. Possible issues: Server down, URL incorrect, or token expired.");
//       }
//
//         if (response.statusCode == 200 ||  response.statusCode == 201) {
//           return {"success": true, "data": response.body};
//         }
//
//         return ApiException.handleError(response);
//
//
//     } catch(e){
//     LoggerService.logWarning("Unexpected Error --->>> $e");
//     return {"success":false, "message":"Unexpected Error -->> $e"};
//     }
//   }
// }

import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tytil_realty/api_service/token.dart';

import 'api_Client.dart';
import 'api_exception.dart';
import 'internet_conectivity.dart';
import 'logging_service.dart';

class GetService extends GetxService {

  static final ApiClient _apiClient = ApiClient();

  static Future<Map<String, dynamic>> getRequest({
    required String url,
    bool requiresAuth = false,
    Map<String, String>? customHeaders,
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


      // AppLogger.log("X-Api-Token -->>> $xToken");
      // AppLogger.log("X-Token -->>> $xApiToken");
      // AppLogger.log("UrlPath -->>> $xurlToken");




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

      LoggerService.logRequest(url: url, body: {}, headers: headers);

      final response = await _apiClient.get(
        url,
        headers: headers,
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
