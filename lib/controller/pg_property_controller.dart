import 'package:get/get.dart';

import '../api_service/print_logger.dart';
import '../model/property_model.dart';
import '../repository/pg_property_repo.dart';

class PGPropertyController extends GetxController {
  final PGPropertyRepository pgCountRepository =
      Get.find<PGPropertyRepository>();

  final PGPropertyRepository repository = Get.find<PGPropertyRepository>();

  RxBool isPGCountLoading = false.obs;

  Rx<PropertyModel?> pgCountProperty = Rx<PropertyModel?>(null);

  void loadAllPgPropertyData() {
    if (pgCountProperty.value == null) {
      fetchPGCountPropertyList();
    }
    if (paginatedPGFeatureProperties.isEmpty) {
      fetchPaginatedPGFeatureProperties();
    }
    if (paginatedPGTopRatedProperties.isEmpty) {
      fetchPaginatedPGTopRatedProperties();
    }
  }

  Future<void> fetchPGCountPropertyList() async {
    isPGCountLoading(true);

    final response = await pgCountRepository.pgCountPropertyList();

    isPGCountLoading(false);

    if (response["success"] == true) {
      pgCountProperty.value = PropertyModel.fromJson(response["data"]);
    } else {
      Get.snackbar("Error", response["message"] ?? "Failed to load properties");
    }
  }

  //===================================================//
  // 🔄 PAGINATED PG FEATURE PROPERTY
  RxBool isPGFeaturePaginating = false.obs;
  RxInt pgFeatureCurrentPage = 1.obs;
  RxInt pgFeatureLastPage = 1.obs;
  RxList<BuyProperty> paginatedPGFeatureProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedPGFeatureProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore && pgFeatureCurrentPage.value >= pgFeatureLastPage.value) {
      AppLogger.log("No more PG Feature pages to load.");
      return;
    }

    isPGFeaturePaginating(true);
    try {
      final nextPage = isLoadMore ? pgFeatureCurrentPage.value + 1 : 1;
      final response = await repository.pgFeaturePropertyList(page: nextPage);
      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        pgFeatureCurrentPage.value = data.pagination.currentPage;
        pgFeatureLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedPGFeatureProperties.addAll(data.properties);
        } else {
          paginatedPGFeatureProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar("Error",
            response["message"] ?? "Failed to load PG Feature properties");
      }
    } finally {
      isPGFeaturePaginating(false);
    }
  }

  //===================================================//
  // 🔄 PAGINATED PG TOP RATED PROPERTY
  RxBool isPGTopRatedPaginating = false.obs;
  RxInt pgTopRatedCurrentPage = 1.obs;
  RxInt pgTopRatedLastPage = 1.obs;
  RxList<BuyProperty> paginatedPGTopRatedProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedPGTopRatedProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore && pgTopRatedCurrentPage.value >= pgTopRatedLastPage.value) {
      AppLogger.log("No more PG Top Rated pages to load.");
      return;
    }

    isPGTopRatedPaginating(true);
    try {
      final nextPage = isLoadMore ? pgTopRatedCurrentPage.value + 1 : 1;
      final response = await repository.pgTopRatedPropertyList(page: nextPage);
      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        pgTopRatedCurrentPage.value = data.pagination.currentPage;
        pgTopRatedLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedPGTopRatedProperties.addAll(data.properties);
        } else {
          paginatedPGTopRatedProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar("Error",
            response["message"] ?? "Failed to load PG Top Rated properties");
      }
    } finally {
      isPGTopRatedPaginating(false);
    }
  }
}
