import 'package:get/get.dart';

import '../api_service/print_logger.dart';
import '../model/property_model.dart';
import '../repository/plot_property_repo.dart';

class PlotPropertyController extends GetxController {
  final PlotPropertyRepository repository = Get.find<PlotPropertyRepository>();

  //============================================//
  // 🔄 PAGINATED PLOT INVESTMENT PROPERTY
  RxBool isPlotInvestmentPaginating = false.obs;
  RxInt plotInvestmentCurrentPage = 1.obs;
  RxInt plotInvestmentLastPage = 1.obs;
  RxList<BuyProperty> paginatedPlotInvestmentProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedPlotInvestmentProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore &&
        plotInvestmentCurrentPage.value >= plotInvestmentLastPage.value) {
      AppLogger.log("No more plot investment pages to load.");
      return;
    }

    isPlotInvestmentPaginating(true);
    try {
      final nextPage = isLoadMore ? plotInvestmentCurrentPage.value + 1 : 1;
      final response =
          await repository.plotInvestmentPropertyList(page: nextPage);

      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        plotInvestmentCurrentPage.value = data.pagination.currentPage;
        plotInvestmentLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedPlotInvestmentProperties.addAll(data.properties);
        } else {
          paginatedPlotInvestmentProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar("Error",
            response["message"] ?? "Failed to load plot investment properties");
      }
    } finally {
      isPlotInvestmentPaginating(false);
    }
  }

  //============================================//
  // 🔄 PAGINATED PLOT FEATURE PROPERTY
  RxBool isPlotFeaturePaginating = false.obs;
  RxInt plotFeatureCurrentPage = 1.obs;
  RxInt plotFeatureLastPage = 1.obs;
  RxList<BuyProperty> paginatedPlotFeatureProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedPlotFeatureProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore &&
        plotFeatureCurrentPage.value >= plotFeatureLastPage.value) {
      AppLogger.log("No more plot feature pages to load.");
      return;
    }

    isPlotFeaturePaginating(true);
    try {
      final nextPage = isLoadMore ? plotFeatureCurrentPage.value + 1 : 1;
      final response = await repository.plotFeaturePropertyList(page: nextPage);

      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        plotFeatureCurrentPage.value = data.pagination.currentPage;
        plotFeatureLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedPlotFeatureProperties.addAll(data.properties);
        } else {
          paginatedPlotFeatureProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar("Error",
            response["message"] ?? "Failed to load plot feature properties");
      }
    } finally {
      isPlotFeaturePaginating(false);
    }
  }

  //============================================//
  // 🔄 PAGINATED PLOT OWNER PROPERTY
  RxBool isPlotOwnerPaginating = false.obs;
  RxInt plotOwnerCurrentPage = 1.obs;
  RxInt plotOwnerLastPage = 1.obs;
  RxList<BuyProperty> paginatedPlotOwnerProperties = <BuyProperty>[].obs;

  Future<void> fetchPaginatedPlotOwnerProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore && plotOwnerCurrentPage.value >= plotOwnerLastPage.value) {
      AppLogger.log("No more plot owner pages to load.");
      return;
    }

    isPlotOwnerPaginating(true);
    try {
      final nextPage = isLoadMore ? plotOwnerCurrentPage.value + 1 : 1;
      final response = await repository.plotOwnerPropertyList(page: nextPage);

      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        plotOwnerCurrentPage.value = data.pagination.currentPage;
        plotOwnerLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedPlotOwnerProperties.addAll(data.properties);
        } else {
          paginatedPlotOwnerProperties.assignAll(data.properties);
        }
      } else {
        Get.snackbar("Error",
            response["message"] ?? "Failed to load plot owner properties");
      }
    } finally {
      isPlotOwnerPaginating(false);
    }
  }

  //============================================//
  void loadAllPlotPropertyData() {
    if (paginatedPlotInvestmentProperties.isEmpty) {
      fetchPaginatedPlotInvestmentProperties();
    }
    if (paginatedPlotFeatureProperties.isEmpty) {
      fetchPaginatedPlotFeatureProperties();
    }
    if (paginatedPlotOwnerProperties.isEmpty) {
      fetchPaginatedPlotOwnerProperties();
    }
  }
}
