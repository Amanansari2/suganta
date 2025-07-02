import 'package:get/get.dart';

import '../api_service/print_logger.dart';
import '../model/project_post_property_model.dart';
import '../repository/project_property_repo.dart';

class ProjectPropertyController extends GetxController {
  final ProjectPropertyRepository projectPropertyRepository =
      Get.find<ProjectPropertyRepository>();

//===================================================//
// 🔄 PAGINATED FEATURE PROPERTY
  RxBool isProjectFeaturePaginating = false.obs;
  RxInt featureCurrentPage = 1.obs;
  RxInt featureLastPage = 1.obs;
  RxList<ProjectPostModel> paginatedProjectFeatureProperties =
      <ProjectPostModel>[].obs;

  Future<void> fetchPaginatedProjectFeatureProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore && featureCurrentPage.value >= featureLastPage.value) {
      AppLogger.log("No more feature Project to load");
      return;
    }

    isProjectFeaturePaginating(true);
    try {
      final nextPage = isLoadMore ? featureCurrentPage.value + 1 : 1;
      final response = await projectPropertyRepository
          .projectFeaturePropertyList(page: nextPage);
      if (response["success"] == true) {
        final data = ProjectModel.fromJson(response["data"]);
        featureCurrentPage.value = data.projectPagination.currentPage;
        featureLastPage.value = data.projectPagination.lastPage;

        if (isLoadMore) {
          paginatedProjectFeatureProperties.addAll(data.project);
        } else {
          paginatedProjectFeatureProperties.assignAll(data.project);
        }
      } else {
        Get.snackbar("Error", response["message"] ?? "Failed to load Projects");
      }
    } finally {
      isProjectFeaturePaginating(false);
    }
  }

//===================================================//
// 🔄 PAGINATED Dream PROPERTY

  RxBool isProjectDreamPaginating = false.obs;
  RxInt dreamCurrentPage = 1.obs;
  RxInt dreamLastPage = 1.obs;
  RxList<ProjectPostModel> paginatedProjectDreamProperties =
      <ProjectPostModel>[].obs;

  Future<void> fetchPaginatedProjectDreamProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore && dreamCurrentPage.value >= dreamLastPage.value) {
      AppLogger.log("No More Dream Project to load");
      return;
    }

    isProjectDreamPaginating(true);
    try {
      final nextPage = isLoadMore ? dreamCurrentPage.value + 1 : 1;
      final response = await projectPropertyRepository.projectDreamPropertyList(
          page: nextPage);
      if (response["success"] == true) {
        final data = ProjectModel.fromJson(response["data"]);
        dreamCurrentPage.value = data.projectPagination.currentPage;
        dreamLastPage.value = data.projectPagination.lastPage;
        if (isLoadMore) {
          paginatedProjectDreamProperties.addAll(data.project);
        } else {
          paginatedProjectDreamProperties.assignAll(data.project);
        }
      } else {
        Get.snackbar("Error",
            response["message"] ?? "Failed to load project Properties");
      }
    } finally {
      isProjectDreamPaginating(false);
    }
  }

  void loadAllProjectData() {
    if (paginatedProjectFeatureProperties.isEmpty) {
      fetchPaginatedProjectFeatureProperties();
    }
    if (paginatedProjectDreamProperties.isEmpty) {
      fetchPaginatedProjectDreamProperties();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    AppLogger.log("Initializing ProjectController...");
    loadAllProjectData();
  }
}
