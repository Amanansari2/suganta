import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../api_service/print_logger.dart';
import '../configs/app_string.dart';
import '../gen/assets.gen.dart';
import '../model/login_model.dart';

class ProfileController extends GetxController {
  RxInt selectEmoji = 0.obs;

  final storage = GetStorage();
  Rx<LoginModel?> user = Rx<LoginModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUserdata();

    storage.listenKey("user_data", (value) {
      if (value != null) {
        try {
          user.value = LoginModel.fromJson(value);
          AppLogger.log("Profile update from get Storage -->> ${user.value}");
        } catch (e) {
          AppLogger.log("Error parsing data $e");
        }
      }
    });
  }

  void fetchUserdata() async {
    var userData = storage.read("user_data");
    if (userData != null) {
      try {
        user.value = LoginModel.fromJson(userData);
        AppLogger.log("✅ Loaded Profile from Storage: ${user.value}");
      } catch (e) {
        AppLogger.log("Error parsing user data $e");
      }
    } else {
      AppLogger.log("No user data found in storage ");
    }
  }

  void updateUserProfile(Map<String, dynamic> updateData) {
    storage.write("user_data", updateData);
    user.value = LoginModel.fromJson(updateData);
    AppLogger.log("Profile update and Ui refreshed ${user.value}");
  }

  void updateEmoji(int index) {
    selectEmoji.value = index;
  }

  RxList<String> profileOptionImageList = [
    'assets/myImg/post_property.png',
    Assets.images.profileOption1.path,
    Assets.images.profileOption2.path,
    Assets.images.profileOption3.path,
    'assets/myImg/privacy_policy.png',
    'assets/myImg/term_condition.png',
    'assets/myImg/contact_us.png',
    Assets.images.profileOption5.path,
    Assets.images.profileOption6.path,
    Assets.images.profileOption6.path,
  ].obs;

  RxList<String> profileOptionTitleList = [
    AppString.postProperty,
    AppString.viewResponses,
    AppString.languages,
    AppString.communicationSettings,
    AppString.privacyPolicy,
    AppString.termsOfUse,
    AppString.contactUs,
    AppString.areYouFindingUsHelpful,
    AppString.logout,
    AppString.deleteAccount,
  ].obs;

  RxList<bool> profileOptionTitle = [
    true, //postAProperty
    false, // viewResponses
    false, // languages
    false, // communicationSettings
    true, // privacyPolicy
    true, // termsOfUse
    true, // shareFeedback
    false, // areYouFindingUsHelpful
    true, // logout
    false, // deleteAccount
  ].obs;

  RxList<String> findingUsImageList = [
    Assets.images.poor.path,
    Assets.images.neutral.path,
    Assets.images.good.path,
    Assets.images.excellent.path,
  ].obs;

  RxList<String> findingUsTitleList = [
    AppString.poor,
    AppString.neutral,
    AppString.good,
    AppString.excellent,
  ].obs;
}
