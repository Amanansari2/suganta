import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../api_service/authorization_checker.dart';
import '../api_service/print_logger.dart';
import '../configs/app_size.dart';
import '../routes/app_routes.dart';

class SplashController extends GetxController {
  final deviceStorage = GetStorage();

  @override
  void onInit() async {
    super.onInit();
    // await GetStorage.init();
    await Future.delayed(const Duration(seconds: AppSize.size4));
    _checkFirstTime();
  }

  void _checkFirstTime() async {
    bool isFirstTime = deviceStorage.read('isFirstTime') ?? true;
    String? token = deviceStorage.read('auth_token');

    AppLogger.log("🟡 Read token after restart: $token");

    if (isFirstTime) {
      AppLogger.log("Navigating to onboardView");
      Get.offAllNamed(AppRoutes.onboardView);
    } else if (token != null && token.isNotEmpty) {
      AppLogger.log("Validating token...");
      final isValid = await AuthorizationChecker.validateTokenOnStartup(token);
      if (isValid) {
        AppLogger.log("Token valid, navigating to bottomBarView");
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.bottomBarView);
      } else {
        AppLogger.log("Invalid token, clearing and going to login");
        deviceStorage.remove("auth_token");
        deviceStorage.remove("user_data");
        Get.offAllNamed(AppRoutes.loginView);
      }
    } else {
      Get.offAllNamed(AppRoutes.loginView);
    }
  }
}
