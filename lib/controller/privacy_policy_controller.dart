import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';

import '../api_service/print_logger.dart';
import '../repository/privacy_policy_repo.dart';

class PrivacyPolicyController extends GetxController {
  final PrivacyPolicyRepository privacyPolicyRepository =
      Get.find<PrivacyPolicyRepository>();

  RxBool isLoading = false.obs;
  RxString policyText = ''.obs;
  RxBool hasFetched = false.obs;
  bool _fetching = false;

  Future<void> privacyPolicy() async {
    if (hasFetched.value || _fetching) return;
    _fetching = true;
    isLoading(true);
    final response = await privacyPolicyRepository.privacyPolicy();
    _fetching = false;
    isLoading(false);
    if (response["success"] == true) {
      final rawHtml = response["data"]["page_data"];
      final unescapedHtml = HtmlUnescape().convert(rawHtml);
      final cleanedHtml = unescapedHtml.replaceAllMapped(
        RegExp(r'(<li[^>]*>)(\s*[•\-–—]+\s*)', caseSensitive: false),
        (match) => '${match.group(1)}',
      );

      AppLogger.log("Cleaned HTML: $cleanedHtml");
      policyText.value = cleanedHtml ?? "No content available";
      hasFetched.value = true;
    } else {
      Get.snackbar("Error", response["message"] ?? "Failed to load properties");
    }
  }
}
