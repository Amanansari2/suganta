import 'package:get/get.dart';

import '../api_service/print_logger.dart';
import '../model/property_model.dart';
import '../repository/residental_property_repo.dart';

class ResidentialPropertyController extends GetxController {
  final ResidentialPropertyRepository repository =
      Get.find<ResidentialPropertyRepository>();

  //=======================================================//
  // 🔄 PAGINATED RESIDENTIAL TOP PREMIUM
  RxBool isResidentialTopPremiumPaginating = false.obs;
  RxInt residentialTopPremiumCurrentPage = 1.obs;
  RxInt residentialTopPremiumLastPage = 1.obs;
  RxList<BuyProperty> paginatedResidentialTopPremiumProperties =
      <BuyProperty>[].obs;

  Future<void> fetchPaginatedResidentialTopPremiumProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore &&
        residentialTopPremiumCurrentPage.value >=
            residentialTopPremiumLastPage.value) {
      AppLogger.log("No more residential top premium pages to load.");
      return;
    }

    isResidentialTopPremiumPaginating(true);
    try {
      final nextPage =
          isLoadMore ? residentialTopPremiumCurrentPage.value + 1 : 1;
      final response =
          await repository.residentialTopPremiumPropertyList(page: nextPage);

      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        residentialTopPremiumCurrentPage.value = data.pagination.currentPage;
        residentialTopPremiumLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedResidentialTopPremiumProperties.addAll(data.properties);
        } else {
          paginatedResidentialTopPremiumProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar("Error",
            response["message"] ?? "Failed to load top premium properties");
      }
    } finally {
      isResidentialTopPremiumPaginating(false);
    }
  }

  //=======================================================//
  // 🔄 PAGINATED RESIDENTIAL OWNER
  RxBool isResidentialOwnerPaginating = false.obs;
  RxInt residentialOwnerCurrentPage = 1.obs;
  RxInt residentialOwnerLastPage = 1.obs;
  RxList<BuyProperty> paginatedResidentialOwnerProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedResidentialOwnerProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore &&
        residentialOwnerCurrentPage.value >= residentialOwnerLastPage.value) {
      AppLogger.log("No more residential owner pages to load.");
      return;
    }

    isResidentialOwnerPaginating(true);
    try {
      final nextPage = isLoadMore ? residentialOwnerCurrentPage.value + 1 : 1;
      final response =
          await repository.residentialOwnerPropertyList(page: nextPage);

      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        residentialOwnerCurrentPage.value = data.pagination.currentPage;
        residentialOwnerLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedResidentialOwnerProperties.addAll(data.properties);
        } else {
          paginatedResidentialOwnerProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar(
            "Error",
            response["message"] ??
                "Failed to load residential owner properties");
      }
    } finally {
      isResidentialOwnerPaginating(false);
    }
  }

  //=======================================================//
  void loadAllResidentialPropertyData() {
    if (paginatedResidentialTopPremiumProperties.isEmpty) {
      fetchPaginatedResidentialTopPremiumProperties();
    }
    if (paginatedResidentialOwnerProperties.isEmpty) {
      fetchPaginatedResidentialOwnerProperties();
    }
  }
}
