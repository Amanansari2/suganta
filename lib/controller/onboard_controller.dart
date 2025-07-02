import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../configs/app_size.dart';
import '../configs/app_string.dart';
import '../routes/app_routes.dart';

class OnboardController extends GetxController {
  RxInt currentIndex = 0.obs;
  final storage = GetStorage();

  List<String> images = [
    "assets/myImg/onboard1.png",
    "assets/myImg/onboard2.png",
    "assets/myImg/onboard3.png",
  ];

  List<String> titles = [
    AppString.onboardTitle1,
    AppString.onboardTitle2,
    AppString.onboardTitle3,
  ];

  List<String> subtitles = [
    AppString.onboardSubTitle1,
    AppString.onboardSubTitle2,
    AppString.onboardSubTitle3,
  ];

  void nextPage() {

    if (currentIndex < images.length - AppSize.size1) {
      currentIndex++;
    } else {

      Get.offAllNamed(AppRoutes.loginView);


    }
  }

  String get nextButtonText {
    return currentIndex.value == images.length - AppSize.size1 ? AppString.getStartButton : AppString.nextButton;
  }
}