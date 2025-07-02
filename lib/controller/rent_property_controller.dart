import 'package:get/get.dart';

import '../model/property_model.dart';
import '../repository/rent_property_repository.dart';

class RentPropertyController extends GetxController {
  final RentPropertyRepository repository = Get.find<RentPropertyRepository>();

//////------------------------pagination Rent Top Properties -------------
  RxBool isRentTopPaginating = false.obs;

  RxInt topCurrentPage = 1.obs;
  RxInt topLastPage = 1.obs;

  RxList<BuyProperty> paginatedRentTopProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedRentTopProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore && topCurrentPage.value >= topLastPage.value) {
      return;
    }

    isRentTopPaginating(true);
    try {
      final nextPage = isLoadMore ? topCurrentPage.value + 1 : 1;

      final response = await repository.rentTopPropertyList(page: nextPage);

      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);

        topCurrentPage.value = data.pagination.currentPage;
        topLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedRentTopProperties.addAll(data.properties);
        } else {
          paginatedRentTopProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar(
            "Error", response["message"] ?? "Failed to load top properties");
      }
    } finally {
      isRentTopPaginating(false);
    }
  }

//////------------------------pagination Rent Owner -------------

  RxBool isRentOwnerPaginating = false.obs;

  // Pagination state
  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;
  RxList<BuyProperty> paginatedRentOwnerProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedRentOwnerProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore && currentPage.value >= lastPage.value) {
      return;
    }

    isRentOwnerPaginating(true);
    try {
      final nextPage = isLoadMore ? currentPage.value + 1 : 1;
      final response = await repository.rentOwnerPropertyList(page: nextPage);

      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);

        currentPage.value = data.pagination.currentPage;
        lastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedRentOwnerProperties.addAll(data.properties);
        } else {
          paginatedRentOwnerProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar("Error", response["message"] ?? "Failed to load data");
      }
    } finally {
      isRentOwnerPaginating(false);
    }
  }

  //============================================================//

  void loadAllRentPropertyData() {
    if (paginatedRentTopProperties.isEmpty) {
      fetchPaginatedRentTopProperties();
    }

    if (paginatedRentOwnerProperties.isEmpty) {
      fetchPaginatedRentOwnerProperties();
    }
  }
}
