//
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:suganta_international/api_service/internet_conectivity.dart';
//
// import 'api_exception.dart';
// import 'logging_service.dart';
//
// class PostService extends GetConnect {
//
// final box = GetStorage();
//
//    Future<Map<String, dynamic>> postRequest({
//     required String url,
//     required Map<String, dynamic> body,
//     bool requiresAuth = false,
//     Map<String, String>? customHeaders,
//
// }) async {
//     if(!await InternetConnectivity.isConnected()){
//       LoggerService.logWarning("NO internet connection.. Request aborted");
//       return{"success": false, "message": "No internet Connection"};
//     }
//     try{
//
//
//       //Map<String, String> headers = {'Content-Type': 'application/json'};
//
//       Map<String, String> headers = {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       };
//
//       if(requiresAuth){
//         final storage = GetStorage();
//         String? token = storage.read("auth_token");
//         if(token == null){
//           return {"success":false, "message":"Authentication Required"};
//         }
//         headers["Authorization"] = "Bearer $token";
//       }
//
//       if(customHeaders != null){
//         headers.addAll(customHeaders);
//       }
//       LoggerService.logRequest(url:url, body:body, headers:headers);
//
//
//     final Response<dynamic>  response = await post(
//         url,
//         body,
//         headers: headers);
//             LoggerService.logResponse(response);
//
//
//       if (response.body == null) {
//         LoggerService.logWarning(" API Response is NULL. Possible issues: Server down, URL incorrect, or token expired.");
//       }
//
//         if(response.statusCode == 200 || response.statusCode ==201){
//           try{
//             return {"success": true, "data":response.body};
//           } catch(e){
//             LoggerService.logWarning("Invalid Json response Received");
//             return {"success": false, "message": "Invalid JSON response"};
//           }
//
//       }
//       return ApiException.handleError(response);
//     } catch(e){
//       LoggerService.logWarning("Unexpected error ---->>> $e");
//       return{"success":false, "message":"Unexpected Error : $e"};
//     }
//   }
//
//
//
//
// Future<Map<String, dynamic>> postImageRequest({
//   required String url,
//   required Map<String, dynamic> body,
//   bool requiresAuth = false,
//   Map<String, String>? customHeaders,
//   String? filePath,
// }) async {
//   if (!await InternetConnectivity.isConnected()) {
//     LoggerService.logWarning("NO internet connection.. Request aborted");
//     return {"success": false, "message": "No internet Connection"};
//   }
//
//   try {
//     Map<String, String> headers = {};
//
//     if (requiresAuth) {
//       final storage = GetStorage();
//       String? token = storage.read("auth_token");
//       if (token == null) {
//         return {"success": false, "message": "Authentication Required"};
//       }
//       headers["Authorization"] = "Bearer $token";
//     }
//
//     if (customHeaders != null) {
//       headers.addAll(customHeaders);
//     }
//     LoggerService.logRequest(url:url, body:body, headers:headers);
//
//     var formData = FormData({});
//
//     // Add text fields
//     body.forEach((key, value) {
//       formData.fields.add(MapEntry(key, value.toString()));
//     });
//
//     // Attach images
//     if (filePath != null && filePath.isNotEmpty) {
//       File imageFile = File(filePath);
//       if (await imageFile.exists()) {
//         formData.files.add(
//           MapEntry(
//             "file",
//             MultipartFile(imageFile, filename: filePath.split('/').last),
//           ),
//         );
//       } else {
//         print(" ERROR: Image file not found at $filePath");
//         return {"success": false, "message": "Image file not found"};
//       }
//     }
//
//
//     // Debugging logs
//     print(" DEBUG: Preparing API Request...");
//     print(" URL: $url, Headers: $headers,  Body Data: ${formData.fields}");
//
//     if (filePath != null) {
//       print("🖼 Image Path: $filePath");
//     }
//
//     // Send Request
//     Response response = await post(url, formData, headers: headers);
//
//     LoggerService.logResponse(response);
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       return {"success": true, "data": response.body};
//     }
//
//     return ApiException.handleError(response);
//   } catch (e) {
//     LoggerService.logWarning("Unexpected error ---->>> $e");
//     return {"success": false, "message": "Unexpected Error: $e"};
//   }
// }
//
// Future<Map<String, dynamic>> postMultipleImagesRequest({
//   required String url,
//   required List<File> imageFiles,
//   bool requiresAuth = false,
//   Map<String, String>? customHeaders,
// }) async {
//   if (!await InternetConnectivity.isConnected()) {
//     LoggerService.logWarning("NO internet connection.. Request aborted");
//     return {"success": false, "message": "No internet Connection"};
//   }
//
//   try {
//     Map<String, String> headers = {};
//
//     if (requiresAuth) {
//       final storage = GetStorage();
//       String? token = storage.read("auth_token");
//       if (token == null) {
//         return {"success": false, "message": "Authentication Required"};
//       }
//       headers["Authorization"] = "Bearer $token";
//     }
//
//     if (customHeaders != null) {
//       headers.addAll(customHeaders);
//     }
//
//     var formData = FormData({});
//
//     for (File file in imageFiles) {
//       if (await file.exists()) {
//         formData.files.add(
//           MapEntry(
//             "file[]",
//             MultipartFile(
//                 file,
//                 filename: file.path.split('/').last),
//           ),
//         );
//       }
//     }
//
//     LoggerService.logRequest(url: url, body: {}, headers: headers);
//     print("🖼 Uploading ${imageFiles.length} images to: $url");
//
//     Response response = await post(url, formData, headers: headers);
//
//     LoggerService.logResponse(response);
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       return {"success": true, "data": response.body};
//     }
//
//     return ApiException.handleError(response);
//   } catch (e) {
//     LoggerService.logWarning("Unexpected error ---->>> $e");
//     return {"success": false, "message": "Unexpected Error: $e"};
//   }
// }
//
//
//
// }
//
//
//
//
//

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:tytil_realty/api_service/print_logger.dart';
import 'package:tytil_realty/api_service/token.dart';

import 'api_Client.dart';
import 'api_exception.dart';
import 'internet_conectivity.dart';
import 'logging_service.dart';

class PostService extends GetxService {
  final box = GetStorage();
  static final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> postRequest({
    required String url,
    required Map<String, dynamic> body,
    bool requiresAuth = false,
    Map<String, String>? customHeaders,
  }) async {
    if (!await InternetConnectivity.isConnected()) {
      LoggerService.logWarning("NO internet connection.. Request aborted");
      return {"success": false, "message": "No internet Connection"};
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
        'X-Api-Token': xApiToken,
        'X-Token': xToken,
        'X-Url-Token': xurlToken
      };

      if (requiresAuth) {
        String? token = box.read("auth_token");
        if (token == null) {
          return {"success": false, "message": "Authentication Required"};
        }
        headers["Authorization"] = "Bearer $token";
      }

      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }

      LoggerService.logRequest(url: url, body: body, headers: headers);

      final response = await _apiClient.post(
        url,
        headers: headers,
        body,
      );

      LoggerService.logHttpResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return {"success": true, "data": jsonDecode(response.body)};
        } catch (e) {
          LoggerService.logWarning("Invalid Json response Received");
          return {"success": false, "message": "Invalid JSON response"};
        }
      }

      return ApiException.handleHttpError(response);
    } catch (e) {
      LoggerService.logWarning("Unexpected error ---->>> $e");
      return {"success": false, "message": "Unexpected Error : $e"};
    }
  }

  Future<Map<String, dynamic>> postImageRequest({
    required String url,
    required Map<String, dynamic> body,
    bool requiresAuth = false,
    Map<String, String>? customHeaders,
    String? filePath,
  }) async {
    if (!await InternetConnectivity.isConnected()) {
      LoggerService.logWarning("NO internet connection.. Request aborted");
      return {"success": false, "message": "No internet Connection"};
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
        'X-Api-Token': xApiToken,
        'X-Token': xToken,
        'X-Url-Token': xurlToken
      };

      if (requiresAuth) {
        String? token = box.read("auth_token");
        if (token == null) {
          return {"success": false, "message": "Authentication Required"};
        }
        headers["Authorization"] = "Bearer $token";
      }

      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);

      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (filePath != null && filePath.isNotEmpty) {
        File imageFile = File(filePath);
        if (await imageFile.exists()) {
          request.files.add(await http.MultipartFile.fromPath(
            'file',
            filePath,
            filename: basename(filePath),
          ));
        } else {
          AppLogger.log(" ERROR: Image file not found at $filePath");
          return {"success": false, "message": "Image file not found"};
        }
      }

      LoggerService.logRequest(url: url, body: body, headers: headers);
      AppLogger.log("🖼 Image Path: $filePath");

      // final streamedResponse = await request.send();
      final response = await _apiClient.sendMultipartRequest(request);

      LoggerService.logHttpResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "data": jsonDecode(response.body)};
      }

      return ApiException.handleHttpError(response);
    } catch (e) {
      LoggerService.logWarning("Unexpected error ---->>> $e");
      return {"success": false, "message": "Unexpected Error: $e"};
    }
  }

  Future<Map<String, dynamic>> postMultipleImagesRequest({
    required String url,
    required List<File> imageFiles,
    bool requiresAuth = false,
    Map<String, String>? customHeaders,
  }) async {
    if (!await InternetConnectivity.isConnected()) {
      LoggerService.logWarning("NO internet connection.. Request aborted");
      return {"success": false, "message": "No internet Connection"};
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
        'X-Api-Token': xApiToken,
        'X-Token': xToken,
        'X-Url-Token': xurlToken
      };

      if (requiresAuth) {
        String? token = box.read("auth_token");
        if (token == null) {
          return {"success": false, "message": "Authentication Required"};
        }
        headers["Authorization"] = "Bearer $token";
      }

      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);

      for (File file in imageFiles) {
        if (await file.exists()) {
          request.files.add(await http.MultipartFile.fromPath(
            'file[]',
            file.path,
            filename: basename(file.path),
          ));
        }
      }

      LoggerService.logRequest(url: url, body: {}, headers: headers);
      AppLogger.log("🖼 Uploading ${imageFiles.length} images to: $url");

      // final streamedResponse = await request.send();
      final response = await _apiClient.sendMultipartRequest(request);

      LoggerService.logHttpResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "data": jsonDecode(response.body)};
      }

      return ApiException.handleHttpError(response);
    } catch (e) {
      LoggerService.logWarning("Unexpected error ---->>> $e");
      return {"success": false, "message": "Unexpected Error: $e"};
    }
  }
}
