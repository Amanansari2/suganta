// import 'dart:io';
//
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:suganta_international/api_service/internet_conectivity.dart';
//
// import 'api_exception.dart';
// import 'logging_service.dart';
//
// class PutService extends GetConnect {
//   final box = GetStorage();
//
//   Future<Map<String, dynamic>> putRequest({
//     required String url,
//     required Map<String, dynamic> body,
//     bool requiresAuth = false,
//     Map<String, String>? customHeaders,
//   }) async {
//     if (!await InternetConnectivity.isConnected()) {
//       LoggerService.logWarning("NO internet connection.. Request aborted");
//       return {"success": false, "message": "No internet Connection"};
//     }
//     try {
//       Map<String, String> headers = {'Content-Type': 'application/json'};
//
//       if (requiresAuth) {
//         final storage = GetStorage();
//         String? token = storage.read("auth_token");
//         if (token == null) {
//           return {"success": false, "message": "Authentication Required"};
//         }
//         headers["Authorization"] = "Bearer $token";
//       }
//
//       if (customHeaders != null) {
//         headers.addAll(customHeaders);
//       }
//
//       LoggerService.logRequest(url: url, body: body, headers: headers);
//
//       final Response<dynamic> response = await put(url, body, headers: headers);
//
//      // LoggerService.logResponse(response);
//
//       if (response.body == null) {
//         LoggerService.logWarning(
//             " API Response is NULL. Possible issues: Server down, URL incorrect, or token expired.");
//       }
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return {"success": true, "data": response.body};
//       }
//
//       return ApiException.handleError(response);
//     } catch (e) {
//       LoggerService.logWarning("Unexpected error ---->>> $e");
//       return {"success": false, "message": "Unexpected Error : $e"};
//     }
//   }
//
//   Future<Map<String, dynamic>> putImageRequest({
//     required String url,
//     required Map<String, dynamic> body,
//     bool requiresAuth = false,
//     Map<String, String>? customHeaders,
//     String? filePath,
//   }) async {
//     if (!await InternetConnectivity.isConnected()) {
//       LoggerService.logWarning("NO internet connection.. Request aborted");
//       return {"success": false, "message": "No internet Connection"};
//     }
//
//     try {
//       Map<String, String> headers = {};
//
//       if (requiresAuth) {
//         final storage = GetStorage();
//         String? token = storage.read("auth_token");
//         if (token == null) {
//           return {"success": false, "message": "Authentication Required"};
//         }
//         headers["Authorization"] = "Bearer $token";
//       }
//
//       if (customHeaders != null) {
//         headers.addAll(customHeaders);
//       }
//
//       LoggerService.logRequest(url: url, body: body, headers: headers);
//
//       var formData = FormData({});
//
//       body.forEach((key, value) {
//         formData.fields.add(MapEntry(key, value.toString()));
//       });
//
//       if (filePath != null && filePath.isNotEmpty) {
//         File imageFile = File(filePath);
//         if (await imageFile.exists()) {
//           formData.files.add(
//             MapEntry(
//               "image",
//               MultipartFile(imageFile, filename: filePath.split('/').last),
//             ),
//           );
//         } else {
//           return {"success": false, "message": "Image file not found"};
//         }
//       }
//
//       Response response = await put(url, formData, headers: headers);
//
//     //  LoggerService.logResponse(response);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return {"success": true, "data": response.body};
//       }
//
//       return ApiException.handleError(response);
//     } catch (e) {
//       LoggerService.logWarning("Unexpected error ---->>> $e");
//       return {"success": false, "message": "Unexpected Error: $e"};
//     }
//   }
//
//   Future<Map<String, dynamic>> putMultipleImagesRequest({
//     required String url,
//     required List<File> imageFiles,
//     bool requiresAuth = false,
//     Map<String, String>? customHeaders,
//   }) async {
//     if (!await InternetConnectivity.isConnected()) {
//       LoggerService.logWarning("NO internet connection.. Request aborted");
//       return {"success": false, "message": "No internet Connection"};
//     }
//
//     try {
//       Map<String, String> headers = {};
//
//       if (requiresAuth) {
//         final storage = GetStorage();
//         String? token = storage.read("auth_token");
//         if (token == null) {
//           return {"success": false, "message": "Authentication Required"};
//         }
//         headers["Authorization"] = "Bearer $token";
//       }
//
//       if (customHeaders != null) {
//         headers.addAll(customHeaders);
//       }
//
//       var formData = FormData({});
//
//       for (File file in imageFiles) {
//         if (await file.exists()) {
//           formData.files.add(
//             MapEntry(
//               "file",
//               MultipartFile(file, filename: file.path.split('/').last),
//             ),
//           );
//         }
//       }
//
//       LoggerService.logRequest(url: url, body: {}, headers: headers);
//
//       Response response = await put(url, formData, headers: headers);
//
//     //  LoggerService.logResponse(response);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return {"success": true, "data": response.body};
//       }
//
//       return ApiException.handleError(response);
//     } catch (e) {
//       LoggerService.logWarning("Unexpected error ---->>> $e");
//       return {"success": false, "message": "Unexpected Error: $e"};
//     }
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:tytil_realty/api_service/token.dart';

import 'api_Client.dart';
import 'api_exception.dart';
import 'internet_conectivity.dart';
import 'logging_service.dart';

class PutService extends GetxService {
  final box = GetStorage();
  static final ApiClient _apiClient = ApiClient();


  Future<Map<String, dynamic>> putRequest({
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



      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Api-Token' : xApiToken,
        'X-Token' : xToken,
        'X-Url-Token': xurlToken
      };

      if (requiresAuth) {
        final storage = GetStorage();
        String? token = storage.read("auth_token");
        if (token == null) {
          return {"success": false, "message": "Authentication Required"};
        }
        headers["Authorization"] = "Bearer $token";
      }

      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }

      LoggerService.logRequest(url: url, body: body, headers: headers);

      final response = await _apiClient.put(
        url,
        headers: headers,
        body,
      );

      LoggerService.logHttpResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "data": jsonDecode(response.body)};
      }

      return ApiException.handleHttpError(response);
    } catch (e) {
      LoggerService.logWarning("Unexpected error ---->>> $e");
      return {"success": false, "message": "Unexpected Error : $e"};
    }
  }

  Future<Map<String, dynamic>> putImageRequest({
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
        'X-Api-Token' : xApiToken,
        'X-Token' : xToken,
        'X-Url-Token': xurlToken
      };

      if (requiresAuth) {
        final storage = GetStorage();
        String? token = storage.read("auth_token");
        if (token == null) {
          return {"success": false, "message": "Authentication Required"};
        }
        headers["Authorization"] = "Bearer $token";
      }

      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }

      var request = http.MultipartRequest('PUT', Uri.parse(url));
      request.headers.addAll(headers);

      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (filePath != null && filePath.isNotEmpty) {
        File imageFile = File(filePath);
        if (await imageFile.exists()) {
          request.files.add(await http.MultipartFile.fromPath(
            "image",
            filePath,
            filename: basename(filePath),
            contentType: MediaType('image', 'jpeg'),
          ));
        } else {
          return {"success": false, "message": "Image file not found"};
        }
      }

      LoggerService.logRequest(url: url, body: body, headers: headers);

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

  Future<Map<String, dynamic>> putMultipleImagesRequest({
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
        'X-Api-Token' : xApiToken,
        'X-Token' : xToken,
        'X-Url-Token': xurlToken
      };

      if (requiresAuth) {
        final storage = GetStorage();
        String? token = storage.read("auth_token");
        if (token == null) {
          return {"success": false, "message": "Authentication Required"};
        }
        headers["Authorization"] = "Bearer $token";
      }

      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }

      var request = http.MultipartRequest('PUT', Uri.parse(url));
      request.headers.addAll(headers);

      for (File file in imageFiles) {
        if (await file.exists()) {
          request.files.add(await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: basename(file.path),
            contentType: MediaType('image', 'jpeg'),
          ));
        }
      }

      LoggerService.logRequest(url: url, body: {}, headers: headers);

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
