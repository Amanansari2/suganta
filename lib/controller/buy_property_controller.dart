import 'package:get/get.dart';

import '../api_service/print_logger.dart';
import '../model/property_model.dart';
import '../repository/buy_property_repo.dart';

class BuyPropertyController extends GetxController {
  final BuyPropertyRepository repository = Get.find<BuyPropertyRepository>();

  //===================================================//
  // 🔄 PAGINATED FEATURE PROPERTY
  RxBool isBuyFeaturePaginating = false.obs;
  RxInt featureCurrentPage = 1.obs;
  RxInt featureLastPage = 1.obs;
  RxList<BuyProperty> paginatedBuyFeatureProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedBuyFeatureProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore && featureCurrentPage.value >= featureLastPage.value) {
      AppLogger.log("No more feature pages to load.");
      return;
    }

    isBuyFeaturePaginating(true);
    try {
      final nextPage = isLoadMore ? featureCurrentPage.value + 1 : 1;
      final response = await repository.buyFeaturePropertyList(page: nextPage);
      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        featureCurrentPage.value = data.pagination.currentPage;
        featureLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedBuyFeatureProperties.addAll(data.properties);
        } else {
          paginatedBuyFeatureProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar("Error",
            response["message"] ?? "Failed to load feature properties");
      }
    } finally {
      isBuyFeaturePaginating(false);
    }
  }

  //===================================================//
  // 🔄 PAGINATED OWNER PROPERTY
  RxBool isBuyOwnerPaginating = false.obs;
  RxInt ownerCurrentPage = 1.obs;
  RxInt ownerLastPage = 1.obs;
  RxList<BuyProperty> paginatedBuyOwnerProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedBuyOwnerProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore && ownerCurrentPage.value >= ownerLastPage.value) {
      AppLogger.log("No more owner pages to load.");
      return;
    }

    isBuyOwnerPaginating(true);
    try {
      final nextPage = isLoadMore ? ownerCurrentPage.value + 1 : 1;
      final response = await repository.buyOwnerPropertyList(page: nextPage);
      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        ownerCurrentPage.value = data.pagination.currentPage;
        ownerLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedBuyOwnerProperties.addAll(data.properties);
        } else {
          paginatedBuyOwnerProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar(
            "Error", response["message"] ?? "Failed to load owner properties");
      }
    } finally {
      isBuyOwnerPaginating(false);
    }
  }

  //===================================================//
  // 🔄 PAGINATED PREMIUM PROPERTY
  RxBool isBuyPremiumPaginating = false.obs;
  RxInt premiumCurrentPage = 1.obs;
  RxInt premiumLastPage = 1.obs;
  RxList<BuyProperty> paginatedBuyPremiumProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedBuyPremiumProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore && premiumCurrentPage.value >= premiumLastPage.value) {
      AppLogger.log("No more premium pages to load.");
      return;
    }

    isBuyPremiumPaginating(true);
    try {
      final nextPage = isLoadMore ? premiumCurrentPage.value + 1 : 1;
      final response = await repository.buyPremiumPropertyList(page: nextPage);
      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        premiumCurrentPage.value = data.pagination.currentPage;
        premiumLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedBuyPremiumProperties.addAll(data.properties);
        } else {
          paginatedBuyPremiumProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar("Error",
            response["message"] ?? "Failed to load premium properties");
      }
    } finally {
      isBuyPremiumPaginating(false);
    }
  }

  //===================================================//
  // 🔄 PAGINATED DELHI PROPERTY
  RxBool isBuyDelhiPaginating = false.obs;
  RxInt delhiCurrentPage = 1.obs;
  RxInt delhiLastPage = 1.obs;
  RxList<BuyProperty> paginatedBuyDelhiProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedBuyDelhiProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore && delhiCurrentPage.value >= delhiLastPage.value) {
      AppLogger.log("No more delhi pages to load.");
      return;
    }

    isBuyDelhiPaginating(true);
    try {
      final nextPage = isLoadMore ? delhiCurrentPage.value + 1 : 1;
      final response = await repository.buyDelhiPropertyList(page: nextPage);
      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        delhiCurrentPage.value = data.pagination.currentPage;
        delhiLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedBuyDelhiProperties.addAll(data.properties);
        } else {
          paginatedBuyDelhiProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar(
            "Error", response["message"] ?? "Failed to load Delhi properties");
      }
    } finally {
      isBuyDelhiPaginating(false);
    }
  }

  //===================================================//
  void loadAllBuyPropertyData() {
    if (paginatedBuyFeatureProperties.isEmpty) {
      fetchPaginatedBuyFeatureProperties();
    }
    if (paginatedBuyOwnerProperties.isEmpty) {
      fetchPaginatedBuyOwnerProperties();
    }
    if (paginatedBuyPremiumProperties.isEmpty) {
      fetchPaginatedBuyPremiumProperties();
    }
    if (paginatedBuyDelhiProperties.isEmpty) {
      fetchPaginatedBuyDelhiProperties();
    }
  }

  @override
  void onInit() {
    super.onInit();
    AppLogger.log("Initializing BuyPropertyController...");
    loadAllBuyPropertyData();
  }
}
