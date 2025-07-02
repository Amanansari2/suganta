import 'package:get/get.dart';

import '../api_service/print_logger.dart';
import '../model/property_model.dart';
import '../repository/commercial_property_repo.dart';

class CommercialPropertyController extends GetxController {
  final CommercialPropertyRepository repository =
      Get.find<CommercialPropertyRepository>();
  final CommercialPropertyRepository commercialOneStopCountRepository =
      Get.find<CommercialPropertyRepository>();

  //=======================================================//
  // 🔄 COMMERCIAL ONE STOP COUNT
  RxBool isCommercialOneStopCountLoading = false.obs;
  RxBool isCommercialShopShowRoomLoading = false.obs;
  RxBool isCommercialOwnerLoading = false.obs;
  RxBool isCommercialOfficeSpaceLoading = false.obs;

  Rx<PropertyModel?> commercialOneStopCountProperty = Rx<PropertyModel?>(null);

  Future<void> fetchCommercialOneStopCountPropertyList() async {
    isCommercialOneStopCountLoading(true);

    final response = await commercialOneStopCountRepository
        .commercialOneStopCountPropertyList();

    isCommercialOneStopCountLoading(false);

    if (response["success"] == true) {
      commercialOneStopCountProperty.value =
          PropertyModel.fromJson(response["data"]);
    } else {
      Get.snackbar("Error", response["message"] ?? "Failed to load properties");
    }
  }

  //=======================================================//
  // 🔄 COMMERCIAL SHOP SHOWROOM
  RxBool isCommercialShopPaginating = false.obs;
  RxInt commercialShopCurrentPage = 1.obs;
  RxInt commercialShopLastPage = 1.obs;
  RxList<BuyProperty> paginatedCommercialShopProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedCommercialShopProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore &&
        commercialShopCurrentPage.value >= commercialShopLastPage.value) {
      AppLogger.log("No more Commercial Shop pages to load.");
      return;
    }

    isCommercialShopPaginating(true);
    try {
      final nextPage = isLoadMore ? commercialShopCurrentPage.value + 1 : 1;
      final response =
          await repository.commercialShopShowRoomPropertyList(page: nextPage);

      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        commercialShopCurrentPage.value = data.pagination.currentPage;
        commercialShopLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedCommercialShopProperties.addAll(data.properties);
        } else {
          paginatedCommercialShopProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar("Error",
            response["message"] ?? "Failed to load Shop/Showroom properties");
      }
    } finally {
      isCommercialShopPaginating(false);
    }
  }

  //=======================================================//
  // 🔄 COMMERCIAL OWNER
  RxBool isCommercialOwnerPaginating = false.obs;
  RxInt commercialOwnerCurrentPage = 1.obs;
  RxInt commercialOwnerLastPage = 1.obs;
  RxList<BuyProperty> paginatedCommercialOwnerProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedCommercialOwnerProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore &&
        commercialOwnerCurrentPage.value >= commercialOwnerLastPage.value) {
      AppLogger.log("No more Commercial Owner pages to load.");
      return;
    }

    isCommercialOwnerPaginating(true);
    try {
      final nextPage = isLoadMore ? commercialOwnerCurrentPage.value + 1 : 1;
      final response =
          await repository.commercialOwnerPropertyList(page: nextPage);

      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        commercialOwnerCurrentPage.value = data.pagination.currentPage;
        commercialOwnerLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedCommercialOwnerProperties.addAll(data.properties);
        } else {
          paginatedCommercialOwnerProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar(
            "Error",
            response["message"] ??
                "Failed to load Commercial Owner properties");
      }
    } finally {
      isCommercialOwnerPaginating(false);
    }
  }

  //=======================================================//
  // 🔄 COMMERCIAL OFFICE SPACE
  RxBool isCommercialOfficePaginating = false.obs;
  RxInt commercialOfficeCurrentPage = 1.obs;
  RxInt commercialOfficeLastPage = 1.obs;
  RxList<BuyProperty> paginatedCommercialOfficeProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedCommercialOfficeProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore &&
        commercialOfficeCurrentPage.value >= commercialOfficeLastPage.value) {
      AppLogger.log("No more Office Space pages to load.");
      return;
    }

    isCommercialOfficePaginating(true);
    try {
      final nextPage = isLoadMore ? commercialOfficeCurrentPage.value + 1 : 1;
      final response =
          await repository.commercialOfficeSpacePropertyList(page: nextPage);

      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        commercialOfficeCurrentPage.value = data.pagination.currentPage;
        commercialOfficeLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedCommercialOfficeProperties.addAll(data.properties);
        } else {
          paginatedCommercialOfficeProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar("Error",
            response["message"] ?? "Failed to load Office Space properties");
      }
    } finally {
      isCommercialOfficePaginating(false);
    }
  }

  //=======================================================//
  void loadAllCommercialPropertyData() {
    if (commercialOneStopCountProperty.value == null) {
      fetchCommercialOneStopCountPropertyList();
    }
    if (paginatedCommercialShopProperties.isEmpty) {
      fetchPaginatedCommercialShopProperties();
    }
    if (paginatedCommercialOwnerProperties.isEmpty) {
      fetchPaginatedCommercialOwnerProperties();
    }
    if (paginatedCommercialOfficeProperties.isEmpty) {
      fetchPaginatedCommercialOfficeProperties();
    }
  }
}
