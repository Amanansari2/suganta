import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';

import '../api_service/print_logger.dart';
import '../repository/term_condition_repo.dart';

class TermConditionController extends GetxController {
  final TermConditionRepository termConditionRepository =
      Get.find<TermConditionRepository>();

  RxBool isLoading = false.obs;
  RxString termsText = ''.obs;
  RxBool hasFetched = false.obs;
  bool _fetching = false;

  Future<void> termCondition() async {
    if (hasFetched.value || _fetching) return;
    _fetching = true;
    isLoading(true);
    final response = await termConditionRepository.termCondition();
    _fetching = false;
    isLoading(false);

    if (response["success"] == true) {
      final cleanedHtml = HtmlUnescape()
          .convert(response["data"]["page_data"])
          .replaceAllMapped(
            RegExp(r'</?ol[^>]*>', caseSensitive: false),
            (_) => '',
          );

      AppLogger.log("Cleaned HTML: $cleanedHtml");
      termsText.value = cleanedHtml ?? "No content available";
      hasFetched.value = true;
    } else {
      Get.snackbar("Error", response["message"] ?? "Failed to load properties");
    }
  }
}
