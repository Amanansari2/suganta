import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get_connect/http/src/response/response.dart';

class ApiException{
  static Map<String, dynamic> handleError(Response<dynamic> response){
    Map<String, dynamic> errorResponse = {};

    try{
      errorResponse= jsonDecode(response.bodyString ?? '{}');
    }catch(e){
      return {"success":false, "message":"invalid server response"};
    }

    switch (response.statusCode){
      case 400:
        return _errorResponse("Bad Request", response);

    case 403:
    return _errorResponse("Forbidden", response);

    case 404:
    return {"success": false, "message": "API Not Found"};

      case 422:
        return _extractValidationErrors(errorResponse);

      case 401:
        return _extractValidationErrors(errorResponse);

    case 500:
    return _errorResponse("Server Error", response);

    default:
    return {"success": false, "message": "Unexpected Error: ${response.statusCode}"};

  }
}

  static Map<String, dynamic> _errorResponse(String message, Response<dynamic> response) {
    return {
      "success": false,
      "message": message,
      "error": response.body
    };
  }

  static Map<String, dynamic> _extractValidationErrors(Map<String, dynamic> errorResponse) {
    List<String> errors = [];

    if (errorResponse.containsKey("message") && errorResponse["message"] != null) {
      errors.add(errorResponse["message"].toString());
    }

    // if (errorResponse.containsKey("message") && errorResponse["message"] != null) {
    //   return {"success": false, "message": errorResponse["message"].toString()};
    // }

    if (errorResponse.containsKey("error")) {
      final errorMap = errorResponse["error"];
      if (errorMap is Map<String, dynamic>) {
        errorMap.forEach((key, value) {
          if (value is List) {
            errors.addAll(value.map((e) => e.toString()));
          }
        });
      }
    }

    if (errorResponse.containsKey("messages")) {
      Map<String, dynamic> messages = errorResponse["messages"];
      messages.forEach((key, value) {
        if (value is List) {
          errors.addAll(value.map((e) => e.toString()));
        }
      });

      return {"success": false, "message": errors.join("\n")};
    }

    return {"success": false, "message": errors.isNotEmpty ? errors.join("\n") : "Validation failed"};
  }


  // static Map<String, dynamic> handleHttpError(http.Response response) {
  //   try {
  //     final body = jsonDecode(response.body);
  //     return {
  //       "success": false,
  //       "message": body["message"] ?? "Server error",
  //       "errors": body["errors"],
  //     };
  //   } catch (e) {
  //     return {
  //       "success": false,
  //       "message": "Invalid server response",
  //     };
  //   }
  // }



  static Map<String, dynamic> handleHttpError(http.Response response) {
    try {
      final Map<String, dynamic> body = jsonDecode(response.body);

      List<String> errorMessages = [];

      // Include top-level "message" or "error" string
      if (body.containsKey("message") && body["message"] is String) {
        errorMessages.add(body["message"]);
      }
      if (body.containsKey("error") && body["error"] is String) {
        errorMessages.add(body["error"]);
      }

      // Include validation-style "messages" if available
      if (body.containsKey("messages")) {
        final messages = body["messages"];
        if (messages is Map<String, dynamic>) {
          messages.forEach((key, value) {
            if (value is List) {
              errorMessages.addAll(value.map((e) => "$key: $e"));
            }
          });
        }
      }

      return {
        "success": false,
        "message": errorMessages.isNotEmpty
            ? errorMessages.join("\n")
            : "Server error",
        "errors": body,
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Invalid server response",
      };
    }
  }


}


