import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../api_service/print_logger.dart';
import '../configs/app_string.dart';
import '../gen/assets.gen.dart';
import '../model/post_property_model.dart';
import '../model/project_post_property_model.dart';
import '../repository/address_repo.dart';
import '../repository/home_your_listing_repository.dart';

class HomeController extends GetxController {
  //search
  TextEditingController searchController = TextEditingController();
  HomeYourListingRepository homeYourListingRepository =
      Get.find<HomeYourListingRepository>();
  final AddressRepository addressRepository = Get.find<AddressRepository>();

  RxInt selectProperty = 0.obs;
  RxInt selectCountry = 0.obs;
  RxInt selectedTabIndex = 0.obs;

  RxList<String> propertyList = [
    AppString.overview,
    // AppString.photos,
  ].obs;

  RxList<bool> isTrendPropertyLiked = <bool>[].obs;

  void updateProperty(int index) {
    selectProperty.value = index;
    selectedTabIndex.value = index;
  }

  void updateCountry(int index) {
    selectCountry.value = index;
  }

  RxList<String> propertyOptionList = [
    AppString.buy,
    AppString.rent,
    AppString.pg,
    AppString.plotLand,
    AppString.commercial,
    AppString.residential,
    AppString.project,
    AppString.postAProperty,
  ].obs;

///////////////////////--------- your listing------------------

//pg-----------------

  int currentPropertyIndex = 0;

  bool isLoading = false;

  //List<PostPropertyData> postPropertyList = [];
  RxList<PostPropertyData> postPropertyList = <PostPropertyData>[].obs;
  RxList<PostPropertyData> allPropertyList = <PostPropertyData>[].obs;

  String errorMessage = '';

  Future<void> fetchPostPropertyList() async {
    try {
      isLoading = true;
      update();
       AppLogger.log("🔄 Fetching post property list...");

      final response =
          await homeYourListingRepository.fetchPostPropertyListing();
       AppLogger.log("Full API Response:$response");

      if (response["success"]) {
        final rawData = response["data"];
        // final propertyList = rawData is Map && rawData["data"] is List
        //     ? rawData["data"]
        //     : rawData;

        // AppLogger.log("📦 Raw Data Extracted: ${propertyList.length} items");

        // PropertyPostResponse propertyResponse = PropertyPostResponse.fromJson({
        //   "data": propertyList ?? [],
        //   "message": response["message"] ?? "Success",
        //   "status": 200
        // });


        if (rawData is List) {

          PropertyPostResponse propertyResponse = PropertyPostResponse.fromJson({
            "data": rawData,
            "message": response["message"] ?? "Success",
            "status": 200
          });

         AppLogger.log("Decoded Property Count: ${propertyResponse.data.length}");
             // postPropertyList= propertyResponse.data;
        postPropertyList.value = propertyResponse.data;
        allPropertyList.value = propertyResponse.data;

         AppLogger.log("🎯 Decoded Property Count: ${propertyResponse.data.length}");
        for (var i = 0; i < propertyResponse.data.length; i++) {
          final item = propertyResponse.data[i];
           AppLogger.log("🔹 ${i + 1}: ${item.type} | ${item.slug} | ${item.feature?.pgName ?? '-'}");
        }
        } else {
          AppLogger.log("⚠️ Unexpected data format. Expected a list.");
          postPropertyList.clear();
          allPropertyList.clear();
        }

        errorMessage = "";
      } else {
        errorMessage = response["message"] ?? "Something went wrong";
        postPropertyList.clear();
        allPropertyList.clear();
         AppLogger.log("❌ API Failure: $errorMessage");
      }
    } catch (e, stackTrace) {
      errorMessage = "Error fetching data: $e";
      postPropertyList.clear();
      allPropertyList.clear();

       AppLogger.log("🔥 Exception in fetchPostPropertyList: $e");
       debugPrintStack(stackTrace: stackTrace);
    } finally {
      isLoading = false;
      update();
       AppLogger.log("✅ fetchPostPropertyList completed.");
    }
  }

  //===================================================//
  // 🔄 PAGINATED Project PROPERTY
  RxBool isPostProjectPaginating = false.obs;
  RxInt postProjectCurrentPage = 1.obs;
  RxInt postProjectLastPage = 1.obs;
  RxList<ProjectPostModel> paginatedPostProject = <ProjectPostModel>[].obs;
  bool _isPaginationInProgress = false;

  Future<void> fetchPostProjectListing({bool isLoadMore = false}) async {
    if (_isPaginationInProgress) return;
    if (isLoadMore &&
        postProjectCurrentPage.value >= postProjectLastPage.value) {
      AppLogger.log("No more project pages to load");
      return;
    }
    _isPaginationInProgress = true;

    // isPostProjectPaginating(true);
    if (isLoadMore) isPostProjectPaginating.value = true;
    try {
      final nextPage = isLoadMore ? postProjectCurrentPage.value + 1 : 1;
      final response = await homeYourListingRepository.fetchPostProjectListing(
          page: nextPage);
      if (response["success"] == true) {
        // AppLogger.log("User project Listing -->> $response");
        final data = ProjectModel.fromJson(response["data"]);
        postProjectCurrentPage.value = data.projectPagination.currentPage;
        postProjectLastPage.value = data.projectPagination.lastPage;
        if (isLoadMore) {
          paginatedPostProject.addAll(data.project);
        } else {
          paginatedPostProject.assignAll(data.project);
        }
      } else {
        Get.snackbar("Error", response["message"] ?? "Failed to load Project");
      }
    } finally {
      if (isLoadMore) isPostProjectPaginating.value = false;
      // isPostProjectPaginating(false);
      _isPaginationInProgress = false;
    }
  }

  RxList<String> searchImageList = [
    Assets.images.searchProperty1.path,
    Assets.images.searchProperty2.path,
  ].obs;

  RxList<String> upcomingProjectImageList = [
    Assets.images.upcomingProject1.path,
    Assets.images.upcomingProject2.path,
    Assets.images.upcomingProject3.path,
  ].obs;

  RxList<String> upcomingProjectTitleList = [
    AppString.luxuryVilla,
    AppString.shreenathjiResidency,
    AppString.pramukhDevelopersSurat,
  ].obs;

  RxList<String> upcomingProjectAddressList = [
    AppString.address8,
    AppString.address9,
    AppString.address10,
  ].obs;

  RxList<String> upcomingProjectFlatSizeList = [
    AppString.bhk3Apartment,
    AppString.bhk4Apartment,
    AppString.bhk5Apartment,
  ].obs;

  RxList<String> upcomingProjectPriceList = [
    AppString.lakh45,
    AppString.lakh85,
    AppString.lakh85,
  ].obs;

  ///////////////////////////////////////////////////////////////////////

  Future<void> loadDataSequence() async {
    await fetchPostPropertyList();
    await fetchPostProjectListing();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    final token = GetStorage().read("auth_token");

    AppLogger.log("Auth Token: $token");

    if (token != null && token.toString().isNotEmpty) {
      loadDataSequence();
    } else {
      // AppLogger.log(" No token found. Skipping fetchPgPostPropertyList.");
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}
