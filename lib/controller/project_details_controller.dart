import 'package:get/get.dart';

import '../api_service/app_config.dart';
import '../api_service/print_logger.dart';
import '../configs/app_string.dart';
import '../gen/assets.gen.dart';
import '../model/map_model.dart';
import '../model/project_dropdown_model.dart';
import '../model/project_post_property_model.dart';
import '../repository/address_repo.dart';
import '../routes/app_routes.dart';

class ProjectDetailsController extends GetxController {
  final AddressRepository addressRepository = Get.find<AddressRepository>();
  Rx<ProjectPostModel?> selectedProject = Rx<ProjectPostModel?>(null);
  RxInt selectProject = 0.obs;

  RxList<bool> isSimilarProjectLiked = <bool>[].obs;

  RxList<String> searchImageList = [
    Assets.images.alexaneFranecki.path,
    Assets.images.searchProperty5.path,
  ].obs;

  RxList<String> projectList = [
    AppString.overview,
    AppString.photos,
    AppString.contactDeveloper,
  ].obs;

  void updateProject(int index) {
    selectProject.value = index;
    if (index == 1) {
      Get.toNamed(AppRoutes.galleryView, arguments: {
        "images": selectedProject.value!.projectImages
            .map((img) => "${AppConfigs.mediaUrl}${img.images}?path=project")
            .toList(),
      })?.then((_) {
        selectProject.value = 0;
      });
    } else if (index == 2) {
      Get.toNamed(AppRoutes.contactDeveloperView, arguments: {
        "name": selectedProject.value!.developerName,
        "phone": selectedProject.value!.developerPhNo1,
        "phone2": selectedProject.value!.developerPhNo2,
        "email": selectedProject.value!.developerEmail1,
        "email2": selectedProject.value!.developerEmail2,
        "projectId": selectedProject.value!.id,
      })?.then((_) {
        selectProject.value = 0;
      });
    }
  }

  void setProject(ProjectPostModel project) {
    // if(selectedProject.value?.id != null){
    selectedProject.value = project;
    AppLogger.log("Slug -->>> ${project.slug}");
    submitSimilarProjectSlug();
    loadProjectMapData();
    // }
  }

  Rxn<MapModel> projectMapData = Rxn<MapModel>();
  RxBool isProjectMapLoading = false.obs;

  Future<void> loadProjectMapData() async {
    final project = selectedProject.value;
    if (project == null) return;
    isProjectMapLoading(true);
    try {
      final result = await addressRepository.fetchProjectMapData(project.id);
      if (result != null) {
        projectMapData.value = result;
      } else {
        AppLogger.log("Failed to load Project Map Data");
      }
    } catch (e) {
      AppLogger.log("Error fetching project map data $e");
    } finally {
      isProjectMapLoading(false);
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--------------------------------------------------------------------------------------------------------------------------

  Rx<StatusResponseModel?> statusResponse = Rx<StatusResponseModel?>(null);
  RxBool isStatusLoading = false.obs;
  RxString statusErrorMessage = ''.obs;

  Future<void> fetchProjectStatuses() async {
    if (statusResponse.value != null) {
      AppLogger.log("Status data already loaded. Skipping API call.");
      return;
    }
    isStatusLoading.value = true;
    final result = await addressRepository.fetchStatusList();
    isStatusLoading.value = false;

    if (result["success"]) {
      statusResponse.value = result["data"];
      AppLogger.log(
          "Statuses loaded successfully: ${statusResponse.value?.data}");
    } else {
      statusErrorMessage.value = result["message"];
      AppLogger.log("Failed to load statuses: ${result["message"]}");
    }
  }

  String getStatusLabelByKey(String? key) {
    AppLogger.log("Looking up status key: $key");

    int? intKey = int.tryParse(key ?? "");
    if (intKey == null) {
      AppLogger.log("Failed to parse key: $key as an integer");
      return "N/A";
    }

    AppLogger.log("Parsed integer key: $intKey");

    // String keyAsString = intKey.toString();
    final map = statusResponse.value?.data;
    if (map == null) return "Loading....";

    // String? statusLabel = statusResponse.value?.data[keyAsString];
    String? statusLabel = map[intKey.toString()] ?? map[intKey];

    AppLogger.log("Status Map Value for key $intKey: $statusLabel");

    return statusLabel ?? "Loading....";
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--------------------------------------------------------------------------------------------------------------------------

  Rx<AmenitiesResponseModel?> amenitiesResponse =
      Rx<AmenitiesResponseModel?>(null);
  RxBool isAmenitiesLoading = false.obs;
  RxString amenitiesErrorMessage = ''.obs;

  Future<void> fetchAmenitiesStatus() async {
    if (amenitiesResponse.value != null) {
      AppLogger.log("Status Data Already Loaded, Skipping Api Call");
      return;
    }

    isAmenitiesLoading.value = true;
    final result = await addressRepository.fetchAmenitiesList();
    isAmenitiesLoading.value = false;

    if (result["success"]) {
      amenitiesResponse.value = result["data"];
      AppLogger.log(
          "Amenities loaded successfully -->>> ${amenitiesResponse.value?.data}");
    } else {
      amenitiesErrorMessage.value = result["message"];
      AppLogger.log("Failed to load Amenities -->> ${result["message"]}");
    }
  }

  List<String> getAmenitiesLabelByKey(String? amenitiesKeysString) {
    AppLogger.log("Looking up Amenities key -->>> $amenitiesKeysString");

    if (amenitiesKeysString == null || amenitiesKeysString.isEmpty) {
      AppLogger.log("Amenities keys string is null or empty");
      return [];
    }

    final keysList = amenitiesKeysString.split(',');

    List<String> amenitiesLabels = [];
    for (var key in keysList) {
      final trimmedKey = key.trim(); // remove extra spaces
      final label = amenitiesResponse.value?.data[trimmedKey];
      if (label != null) {
        amenitiesLabels.add(label);
      } else {
        amenitiesLabels.add("Unknown Amenity ($trimmedKey)");
      }
    }
    AppLogger.log("Amenities Labels fetched: $amenitiesLabels");
    return amenitiesLabels;
  }

  //===================================================
  // 🔄 Slug Similar PROJECT Data

  RxBool isSimilarPaginating = false.obs;
  RxInt similarCurrentPage = 1.obs;
  RxInt similarLastPage = 1.obs;
  RxList<ProjectPostModel> similarProject = <ProjectPostModel>[].obs;

  Future<void> submitSimilarProjectSlug({bool isLoadMore = false}) async {
    if (selectedProject.value == null) {
      AppLogger.log("❗ No selected project found, skipping slug fetch");
      return;
    }

    if (isLoadMore && similarCurrentPage.value >= similarLastPage.value) {
      AppLogger.log("No more similar project pages to load.");
      return;
    }
    isSimilarPaginating(true);

    try {
      final slug = selectedProject.value?.slug ?? "";
      final nextPage = isLoadMore ? similarCurrentPage.value + 1 : 1;

      final response = await addressRepository.submitSimilarProjectSlug(
          slug: slug, page: nextPage);

      AppLogger.log("Response received: $response");
      if (response["success"] == true && response["data"] != null) {
        final message = response["data"]["message"] ?? "";
        final paginatedData = response["data"]["data"] ?? {};

        final fullResponse = {
          "message": message,
          "status": 200,
          "data": paginatedData,
        };

        final model = ProjectModel.fromJson(fullResponse);
        similarCurrentPage.value = model.projectPagination.currentPage;
        similarLastPage.value = model.projectPagination.lastPage;

        if (isLoadMore) {
          similarProject.addAll(model.project);
        } else {
          similarProject.assignAll(model.project);
        }
        update();
      } else {
        AppLogger.log("Slug Submission failed $response");
      }
    } catch (e) {
      AppLogger.log("Error while submitting slug -->> $e");
    } finally {
      isSimilarPaginating(false);
    }
  }

  Future<List<ProjectPostModel>> fetchMoreSimilarProject() async {
    if (similarCurrentPage.value >= similarLastPage.value) {
      AppLogger.log("No more similar projects to load");
      return [];
    }
    await submitSimilarProjectSlug(isLoadMore: true);
    return similarProject;
  }

  @override
  void onReady() {
    super.onReady();

    AppLogger.log("On Ready Triggred");
    final args = Get.arguments;
    if (args != null &&
        args['project'] != null &&
        args['project'] is ProjectPostModel) {
      final ProjectPostModel proj = args['project'];
      setProject(proj);
    } else {
      AppLogger.log("Project nut found in arguments");
    }

    fetchProjectStatuses();
    fetchAmenitiesStatus();
  }
}
