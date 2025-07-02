import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../configs/app_string.dart';
import '../gen/assets.gen.dart';
import '../model/post_property_model.dart';
import 'home_controller.dart';

class ActivityController extends GetxController {
  TextEditingController searchListController = TextEditingController();

  RxInt selectListing = 0.obs;
  RxInt selectSorting = 0.obs;
  RxBool deleteShowing = false.obs;

  void updateListing(int index) {
    selectListing.value = index;
  }

  void updateSorting(int index) {
    selectSorting.value = index;
  }
////////////////////////////////////////////////////
  final HomeController homeController = Get.find<HomeController>();
  List<PostPropertyData> get allPostedProperties => homeController.postPropertyList;
////////////////////////////////////////////////////////
  RxList<String> sortListingList = [
    AppString.newestFirst,
    AppString.oldestFirst,
    AppString.expiringFirst,
    AppString.expiringLast,
  ].obs;

  RxList<String> propertyListImage = [
    Assets.images.listing1.path,
    Assets.images.listing2.path,
    Assets.images.listing3.path,
    Assets.images.listing4.path,
  ].obs;

  RxList<String> propertyListRupee = [
    AppString.rupee50Lac,
    AppString.rupee50Lac,
    AppString.rupee45Lac,
    AppString.rupee45Lac,
  ].obs;

  RxList<String> propertyListTitle = [
    AppString.sellFlat,
    AppString.sellIndependentHouse,
    AppString.successClub,
    AppString.theWriteClub,
  ].obs;

  RxList<String> propertyListAddress = [
    AppString.northBombaySociety,
    AppString.roslynWalks,
    AppString.akshyaNagar,
    AppString.rammurthyNagar,
  ].obs;


  void filterSearchResults(String query) {
    final allList = homeController.allPropertyList;

    if (query.isEmpty) {
      homeController.postPropertyList.value = allList;
    } else {
      final filtered = allList.where((property) {
        final name = property.feature?.pgName?.toLowerCase() ?? '';
        final city = property.address.city.toLowerCase();
        final area = property.address.area.toLowerCase();
        final subLocality = property.address.subLocality?.toLowerCase() ?? '';

        return name.contains(query.toLowerCase()) ||
            city.contains(query.toLowerCase()) ||
            area.contains(query.toLowerCase()) ||
            subLocality.contains(query.toLowerCase());
      }).toList();

      homeController.postPropertyList.value = filtered;
    }

    homeController.update();
  }

  @override
  void dispose() {
    searchListController.dispose();
    super.dispose();
   // searchListController.clear();
  }
}