import 'package:http/http.dart' as http;
import 'package:tytil_realty/api_service/print_logger.dart';

class LoggerService {
  static void logRequest({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> headers,
  }) {
    AppLogger.log("Post Data----->>>> $url");
    AppLogger.log("Headers----->>>> $headers");
    AppLogger.log("Post Body----->>>> $body");
  }

  static void logHttpResponse(http.Response response) {
    AppLogger.log(
        "Api Response ---->>> Status code [${response.statusCode}]: url-->>> ${response.request?.url}");
    AppLogger.log(
      "Api Response Body --->>>> ${response.body}",
    );
  }

  static void logWarning(String message) {
    AppLogger.log("Warning---->>> $message");
  }
}
