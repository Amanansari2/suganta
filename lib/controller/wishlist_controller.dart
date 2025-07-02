import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../api_service/print_logger.dart';
import '../configs/app_color.dart';
import '../model/project_post_property_model.dart';
import '../model/property_model.dart';
import '../repository/wishlist_repo.dart';

class WishlistController extends GetxController {
  final WishlistRepository wishlistRepository = Get.find<WishlistRepository>();

  final box = GetStorage();
  final RxBool isAuthenticated = false.obs;

  void checkAuth() {
    final token = box.read("auth_token");
    AppLogger.log("Retrieved token: $token");

    isAuthenticated.value = token != null && token.toString().isNotEmpty;
  }

  @override
  void onInit() {
    super.onInit();
    checkAuth();
    if (isAuthenticated.value) {
      fetchWishlistAfterLogin();
      fetchProjectWishlistAfterLogin();
    }
    ever(isAuthenticated, (bool authStatus) {
      if (authStatus) {
        fetchWishlistAfterLogin();
        fetchProjectWishlistAfterLogin();
      } else {
        wishlistIds.clear();
        projectWishlistIds.clear();
      }
    });

    box.listenKey('auth_token', (token) {
      checkAuth();
    });
  }

  Future<void> fetchWishlistAfterLogin() async {
    final response = await wishlistRepository.fetchWishList();
    AppLogger.log("Wishlist Raw Response from controller -->> $response");
    if (response["success"] == true) {
      final List<int> ids = response["data"]["ids"];
      wishlistIds.clear();
      wishlistIds.addAll(ids);
      AppLogger.log("Fetched Wishlist IDs: $ids");
    } else {
      AppLogger.log("Wishlist fetch failed: ${response["message"]}");
    }
  }

  final RxSet<int> wishlistIds = <int>{}.obs;
  final RxSet<int> loadingIds = <int>{}.obs;

  bool isWishlisted(int propertyId) => wishlistIds.contains(propertyId);

  bool isLoading(int propertyId) => loadingIds.contains(propertyId);

  Future<void> toggleWishlist(int propertyId) async {
    if (loadingIds.contains(propertyId)) return;

    loadingIds.add(propertyId);
    try {
      final response = await wishlistRepository.toggleWishlist(propertyId);
      final bool success = response["success"] == true;
      final String message = response["message"] ?? "Something happened";

      if (success) {
        final bool wishlisted = response["wishlisted"] == true;

        if (wishlisted) {
          wishlistIds.add(propertyId);
        } else {
          wishlistIds.remove(propertyId);
          paginatedWishlistProperties
              .removeWhere((property) => property.id == propertyId);
        }

        Get.snackbar("Success", message,
            duration: const Duration(milliseconds: 800));
      } else {
        _showSnackbar("Error", message, AppColor.red);
      }
    } catch (e) {
      _showSnackbar("Error", "An unexpected error occurred", AppColor.red);
    } finally {
      loadingIds.remove(propertyId);
    }
  }

  //===================================================//
  // 🔄 PAGINATED WishList PROPERTY

  RxBool isWishlistPropertyPaginating = false.obs;
  RxInt wishlistPropertyCurrentPage = 1.obs;
  RxInt wishlistPropertyLastPage = 1.obs;
  RxList<BuyProperty> paginatedWishlistProperties = <BuyProperty>[].obs;
  RxString wishlistEmptyMessage = ''.obs;

  Future<void> fetchPaginatedWishlistProperty({bool isLoadMore = false}) async {
    if (isLoadMore &&
        wishlistPropertyCurrentPage.value >= wishlistPropertyLastPage.value) {
      AppLogger.log("No more properties to load");
      return;
    }

    isWishlistPropertyPaginating(true);
    try {
      final nextPage = isLoadMore ? wishlistPropertyCurrentPage.value + 1 : 1;
      final response =
          await wishlistRepository.fetchWishListPropertyData(page: nextPage);
      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);

        wishlistPropertyCurrentPage.value = data.pagination.currentPage;
        wishlistPropertyLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedWishlistProperties.addAll(data.properties);
        } else {
          paginatedWishlistProperties.assignAll(data.properties);
        }
        wishlistEmptyMessage.value =
            response["data"]["message"] ?? "No wishlist properties found";
      } else {
        Get.snackbar(
            "Error", response["message"] ?? "Failed to load properties");
      }
    } finally {
      isWishlistPropertyPaginating(false);
    }
  }

  //----------------------------------------------------------------------------------------------------------------------------------------------
  //------------------------- Project WishList -------------------------------------------
  //--------------------------------------------------------------------------------------
  Future<void> fetchProjectWishlistAfterLogin() async {
    final response = await wishlistRepository.fetchProjectWishList();
    AppLogger.log(
        "Project Wishlist Raw Response from controller -->> $response");
    if (response["success"] == true) {
      final List<int> projectIds = response["data"]["ids"];
      projectWishlistIds.clear();
      projectWishlistIds.addAll(projectIds);
      AppLogger.log("Project Fetched Wishlist IDs: $projectIds");
    } else {
      AppLogger.log("Project Wishlist fetch failed: ${response["message"]}");
    }
  }

  final RxSet<int> projectWishlistIds = <int>{}.obs;
  final RxSet<int> projectLoadingIds = <int>{}.obs;

  bool isProjectWishListed(int projectId) =>
      projectWishlistIds.contains(projectId);

  bool isProjectLoading(int projectId) => projectLoadingIds.contains(projectId);

  Future<void> projectToggleWishList(int projectId) async {
    AppLogger.log("📌 Toggling project wishlist for projectId: $projectId");
    if (projectLoadingIds.contains(projectId)) return;

    projectLoadingIds.add(projectId);
    try {
      final response =
          await wishlistRepository.toggleProjectWishList(projectId);
      final bool success = response["success"] == true;
      final String message = response["message"] ?? "Something happened";

      if (success) {
        final bool projectWishListed = response["wishlisted"] == true;

        if (projectWishListed) {
          projectWishlistIds.add(projectId);
        } else {
          projectWishlistIds.remove((projectId));
          paginatedWishlistProjects
              .removeWhere((project) => project.id == projectId);
        }

        Get.snackbar("Success", message,
            duration: const Duration(milliseconds: 800));
      } else {
        _showSnackbar("Error", message, AppColor.red);
      }
    } catch (e) {
      _showSnackbar("Error", "An unexpected error occurred", AppColor.red);
    } finally {
      projectLoadingIds.remove(projectId);
    }
  }

  //===================================================//
  // 🔄 PAGINATED WishList Project

  RxBool isWishlistProjectPaginating = false.obs;
  RxInt wishlistProjectCurrentPage = 1.obs;
  RxInt wishlistProjectLastPage = 1.obs;
  RxList<ProjectPostModel> paginatedWishlistProjects = <ProjectPostModel>[].obs;
  RxString projectWishlistEmptyMessage = ''.obs;

  Future<void> fetchPaginatedWishlistProject({bool isLoadMore = false}) async {
    if (isLoadMore &&
        wishlistProjectCurrentPage.value >= wishlistProjectLastPage.value) {
      AppLogger.log("No more project to load");
      return;
    }

    isWishlistProjectPaginating(true);

    try {
      final nextPage = isLoadMore ? wishlistProjectCurrentPage.value + 1 : 1;
      final response =
          await wishlistRepository.fetchWishListProjectData(page: nextPage);
      if (response["success"] == true) {
        final data = ProjectModel.fromJson(response["data"]);

        wishlistProjectCurrentPage.value = data.projectPagination.currentPage;
        wishlistProjectLastPage.value = data.projectPagination.lastPage;

        if (isLoadMore) {
          paginatedWishlistProjects.addAll(data.project);
        } else {
          paginatedWishlistProjects.assignAll(data.project);
        }
        projectWishlistEmptyMessage.value = response["data"]["message"] ??
            "No Project wishlist properties found";
      } else {
        Get.snackbar(
            "Error", response["message"] ?? "Failed to load properties");
      }
    } finally {
      isWishlistProjectPaginating(false);
    }
  }

  ///-------------------------------------------------------------------------------------------////////////////////////////////////////////////////

  void _showSnackbar(String title, String message, dynamic backgroundColor) {
    Get.rawSnackbar(
      title: title,
      message: message,
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }
}
