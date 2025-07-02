import 'package:get/get.dart';

import '../configs/app_string.dart';

class SlideDrawerController extends GetxController {
  RxList<String> drawerList = [
    AppString.notification,
    AppString.searchProperty,
    AppString.postProperty,
    AppString.editProperty,
    AppString.editProject,
  ].obs;
  RxList<bool> drawerListVisibility = [
    false,   // Notification
    true,   // Search Property
    true,   // Post Property
    true,  // Edit Property (hidden for now)
    true,   // View Responses
  ].obs;

  RxList<String> drawer2List = [
    AppString.recentActivity,
    AppString.viewedProperties,
    AppString.savedProperties,
    AppString.contactedProperties,
  ].obs;
  RxList<bool> drawer2ListVisibility = [
    false,   // recentActivity
    false,   // viewedProperties
    false,   // savedProperties
    false,  // contactedProperties

  ].obs;

  RxList<String> searchPropertyNumberList = [
    AppString.number35,
    AppString.number25,
    AppString.number3,
    AppString.number10,
  ].obs;

  RxList<String> drawer3List = [
    AppString.homeScreen,
    AppString.wishlistProperty,
    AppString.wishlistProject,
  ].obs;
  RxList<bool> drawer3ListVisibility = [
    true,   // homeScreen
    true,   // agentsList
    true,   // interestingReads
  ].obs;

  RxList<String> drawer4List = [
    AppString.termsOfUse,
    AppString.privacyPolicy,
    AppString.contactUs,
    AppString.wallet,
    AppString.logout,
  ].obs;
  RxList<bool> drawer4ListVisibility = [
    true,   // termsOfUse
    true,   // privacyPolicy
    true,   // contactUs
    true,   // rateOurApp
    true,   // logout

  ].obs;
}