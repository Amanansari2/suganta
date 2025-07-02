import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';
import '../configs/app_string.dart';
import '../model/area_model.dart';
import '../model/city_model.dart';
import '../model/project_dropdown_model.dart';
import '../model/project_post_property_model.dart';
import '../model/property_model.dart';
import '../repository/search_property_repo.dart';
import 'fetch_city_list_controller.dart';

class SearchFilterController extends GetxController {
  final PostService postService = Get.find<PostService>();

  final SearchPropertyRepository searchPropertyRepository =
      Get.find<SearchPropertyRepository>();
  TextEditingController residentialSearchController = TextEditingController();
  TextEditingController residentialAreaSearchController =
      TextEditingController();

  TextEditingController commercialSearchController = TextEditingController();
  TextEditingController commercialAreaSearchController =
      TextEditingController();

  TextEditingController pgSearchController = TextEditingController();
  TextEditingController pgAreaSearchController = TextEditingController();

  TextEditingController projectSearchController = TextEditingController();
  TextEditingController projectAreaSearchController = TextEditingController();

  RxInt selectProperty = 0.obs;

  void updateProperty(int index) {
    selectProperty.value = index;
    AppLogger.log("Selected Tab --->>> $selectProperty");

    String? selectedPropertyKey;
    switch (index) {
      case 0:
        selectedPropertyKey = "PG";
        break;
      case 1:
        selectedPropertyKey = "RESIDENTIAL";
        break;
      case 2:
        selectedPropertyKey = "COMMERCIAL";
        break;

      case 3:
        selectedPropertyKey = "PROJECT";
        break;
    }
    AppLogger.log("Selected Tab Index --->>> $index");
    AppLogger.log("📦 Selected Property Key --->>> $selectedPropertyKey");
  }

  RxList<String> propertyList = [
    AppString.pg,
    AppString.residential,
    AppString.commercial,
    AppString.project
  ].obs;

  Future<void> loadCityList() async {
    final cityListController = Get.find<CityList>();
    residentialCityOptions.clear();
    residentialCityOptions.addAll(cityListController.cityList);

    commercialCityOptions.clear();
    commercialCityOptions.addAll(cityListController.cityList);

    pgCityOptions.clear();
    pgCityOptions.addAll(cityListController.cityList);

    projectCityOptions.clear();
    projectCityOptions.addAll(cityListController.cityList);
    AppLogger.log("Pg CIty Count: ${pgCityOptions.length} cities");
    AppLogger.log(
        "Residential City Count: ${residentialCityOptions.length} cities");
    AppLogger.log(
        "Commercial City Count: ${commercialCityOptions.length} cities");
    AppLogger.log("Project City Count: ${projectCityOptions.length} cities");
  }

  ///----------------  PG  ----------------------------------///

  List<City> pgCityOptions = [];
  City? selectedPgCity;

  void updatePgSelectedCity(String? cityName) {
    final selectedPgSearchCity =
        pgCityOptions.firstWhereOrNull((city) => city.name == cityName);
    if (selectedPgSearchCity != null) {
      selectedPgCity = selectedPgSearchCity;
      update();
      AppLogger.log("✅ City Selected: ${selectedPgCity!.name}");
    } else {
      AppLogger.log("❌ City not found in list");
    }
  }

  RxList<Area> pgAreaOptions = <Area>[].obs;
  Area? selectedPgArea;

  Future<void> fetchPgAreaList(String cityName) async {
    AppLogger.log("🔄 Resetting PG Area state...");
    pgAreaOptions.clear();
    selectedPgArea = null;
    pgAreaSearchController.clear();
    update();

    try {
      final response = await postService.postRequest(
        url: getAreaListUrl,
        body: {"city": cityName},
        requiresAuth: false,
      );

      if (response["success"] == true && response["data"] != null) {
        final List<dynamic> data = response["data"]["data"];
        pgAreaOptions.assignAll(data.map((e) => Area.fromJson(e)).toList());
        pgAreaSearchController.clear();
        selectedPgArea = null;
        update();
        AppLogger.log(
            "✅ PG Areas loaded for $cityName: ${pgAreaOptions.length}");
      } else {
        pgAreaOptions.clear();
        selectedPgArea = null;
        update();
        Get.log(
            " PG Area load failed: ${response["message"] ?? "Unknown error"}");
      }
    } catch (e) {
      pgAreaOptions.clear();
      selectedPgArea = null;
      update();
      Get.log(" Exception in PG area load: $e");
    }
  }

  RxList<double> pgAmountOptions = <double>[
    2000,
    3000,
    4000,
    5000,
    7000,
    8000,
    9000,
    10000,
    12000,
    14000,
    16000,
    18000,
    20000,
    25000,
    30000,
    35000,
    40000,
    45000,
    50000,
  ].obs;

  RxnDouble selectedPgMinAmount = RxnDouble();
  RxnDouble selectedPgMaxAmount = RxnDouble();

  String? get pgMinimumAmount => selectedPgMinAmount.value?.toStringAsFixed(0);

  String? get pgMaximumAmount => selectedPgMaxAmount.value?.toStringAsFixed(0);

  void updateSelectedPgMinAmount(double? value) {
    selectedPgMinAmount.value = value;
    AppLogger.log("Pg Minimum Amount field value--->>>> $pgMinimumAmount");
  }

  void updateSelectedPgMaxAmount(double? value) {
    selectedPgMaxAmount.value = value;
    AppLogger.log("Pg Maximum Amount field value--->>>> $pgMaximumAmount");
  }

  final RxMap<String, String> pgPostedByMap = {
    "5": AppString.owners,
    "6": AppString.brokers,
    "7": AppString.builders,
  }.obs;

  final RxString selectedPgPostedByKey = ''.obs;

  void updatePgPostedByKey(String key) {
    selectedPgPostedByKey.value = key;
    AppLogger.log("✅ Pg Posted By: $key");
  }

  final RxMap<String, String> pgOccupancyList = {
    "1": AppString.single,
    "2": AppString.double,
    "3": AppString.triple,
  }.obs;

  final RxString selectPgOccupancy = ''.obs;

  void updatePgOccupancy(String key) {
    selectPgOccupancy.value = key;
    AppLogger.log("✅ Pg Occupancy Selected: $key");
  }

  final RxMap<String, String> pgSuitableForList = {
    "GIRLS": AppString.girls,
    "BOYS": AppString.boys,
    "COLIVING": AppString.coLiving,
    "WORKINGWOMAN": AppString.workingWoman,
    "STUDENT": AppString.student,
    "ANY": AppString.any,
  }.obs;

  final RxString selectPgSuitableFor = ''.obs;

  void updatePgSuitableFor(String key) {
    selectPgSuitableFor.value = key;
    AppLogger.log("✅ Pg Suitable For Selected: $key");
  }

  //===================================================//
  // 🔄 PAGINATED Pg Search PROPERTY

  RxBool isPgPaginating = false.obs;
  RxInt pgCurrentPage = 1.obs;
  RxInt pgLastPage = 1.obs;
  RxList<BuyProperty> paginatedPgSearchProperty = <BuyProperty>[].obs;

  Future<void> fetchPgPaginatedProperties({bool isLoadMore = false}) async {
    if (isLoadMore && pgCurrentPage.value >= pgLastPage.value) {
      AppLogger.log("No more Pg Search page to load");
      return;
    }
    isPgPaginating(true);

    final pgPayload = {
      "type": "PG",
      "city": selectedPgCity?.name,
      "area": selectedPgArea?.area,
      "min": selectedPgMinAmount.value?.toInt(),
      "max": selectedPgMaxAmount.value?.toInt(),
      "posted_by": int.tryParse(selectedPgPostedByKey.value),
      "suitable_for": selectPgSuitableFor.value,
      "room_sharing": selectPgOccupancy.value
    };

    AppLogger.log("Final Pg Payload -->>> ${pgPayload}");

    try {
      final nextPage = isLoadMore ? pgCurrentPage.value + 1 : 1;
      final response = await searchPropertyRepository.getSearchList(
          page: nextPage, payload: pgPayload);

      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        pgCurrentPage.value = data.pagination.currentPage;
        pgLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedPgSearchProperty.addAll(data.properties);
        } else {
          paginatedPgSearchProperty.assignAll(data.properties);
        }
      } else {
        Get.snackbar(
            "EError", response["message"] ?? "Failed to load Properties");
      }
    } finally {
      isPgPaginating(false);
    }
  }

  ///----------------  Residential  ----------------------------------///
  List<City> residentialCityOptions = [];
  City? selectedResidentialCity;

  void updateResidentialSelectedCity(String? cityName) {
    final selectedSearchCity = residentialCityOptions
        .firstWhereOrNull((city) => city.name == cityName);
    if (selectedSearchCity != null) {
      selectedResidentialCity = selectedSearchCity;
      update();
      AppLogger.log("✅ City Selected: ${selectedResidentialCity!.name}");
    } else {
      AppLogger.log("❌ City not found in list");
    }
  }

  RxList<Area> residentialAreaOptions = <Area>[].obs;
  Area? selectedResidentialArea;

  Future<void> fetchResidentialAreaList(String cityName) async {
    AppLogger.log("🔄 Resetting Residential Area state...");
    residentialAreaOptions.clear();
    selectedResidentialArea = null;
    residentialAreaSearchController.clear();
    update();

    try {
      final response = await postService.postRequest(
        url: getAreaListUrl,
        body: {"city": cityName},
        requiresAuth: false,
      );

      if (response["success"] == true && response["data"] != null) {
        final List<dynamic> data = response["data"]["data"];
        residentialAreaOptions
            .assignAll(data.map((e) => Area.fromJson(e)).toList());
        residentialAreaSearchController.clear();
        selectedResidentialArea = null;
        update();
        Get.log(
            "Residential Area Loaded for $cityName: ${residentialAreaOptions.length}");
      } else {
        residentialAreaOptions.clear();
        selectedResidentialArea = null;
        update();
        Get.log(
            "Residential Area loaded fail ${response["message"] ?? "Unknown Error"}");
      }
    } catch (e) {
      residentialAreaOptions.clear();
      selectedResidentialArea = null;
      update();
      Get.log("Exception in residential area load -->> $e");
    }
  }

  RxList<String> residentialPropertyTypeList = [
    AppString.residentialFlatApartment,
    AppString.residentialIndependentVilla,
    AppString.residentialIndependentBuilder,
    AppString.residentialFarmHouse,
    AppString.residentialPlotLand
  ].obs;

  final RxString selectResidentialTypesOfProperty = ''.obs;

  final Map<String, List<String>> residentialTypeValueMap = {
    AppString.residentialFlatApartment: ["2", "23", "31", "14"],
    AppString.residentialIndependentVilla: ["3", "24", "32", "15"],
    AppString.residentialIndependentBuilder: ["4", "25", "33", "16"],
    AppString.residentialFarmHouse: ["5", "26", "34", "17"],
    AppString.residentialPlotLand: ["6"],
  };

  RxList<double> residentialAmountOptions = <double>[
    10000,
    20000,
    30000,
    40000,
    50000,
    100000,
    500000,
    1000000,
    2000000,
    3000000,
    4000000,
    5000000,
    6000000,
    7000000,
    8000000,
    9000000,
    10000000,
    20000000,
    30000000,
    40000000,
    50000000,
    60000000,
    70000000,
    80000000,
    90000000,
    100000000,
    200000000,
    200000001,
  ].obs;

  String formatCurrency(double value) {
    if (value >= 10000000) {
      if (value == 200000001) return "> 20 Cr";
      return '${(value / 10000000).toStringAsFixed(0)} Cr';
    } else if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(0)} Lakh';
    } else {
      return '${(value / 1000).toStringAsFixed(0)} K';
    }
  }

  RxnDouble selectedResidentialMinAmount = RxnDouble();
  RxnDouble selectedResidentialMaxAmount = RxnDouble();

  String? get residentialMinimumAmount =>
      selectedResidentialMinAmount.value?.toStringAsFixed(0);

  String? get residentialMaximumAmount =>
      selectedResidentialMaxAmount.value?.toStringAsFixed(0);

  void updateSelectedResidentialMinAmount(double? value) {
    selectedResidentialMinAmount.value = value;
    AppLogger.log(
        "Residential Minimum Amount field value--->>>> $residentialMinimumAmount");
  }

  void updateSelectedResidentialMaxAmount(double? value) {
    selectedResidentialMaxAmount.value = value;
    AppLogger.log(
        "Residential Maximum Amount field value--->>>> $residentialMaximumAmount");
  }

  final RxMap<String, String> residentialBhkList = {
    "1": AppString.add1BHK,
    "2": AppString.add2BHK,
    "3": AppString.add3BHK,
    "4": AppString.add4BHK,
    "5": AppString.add5BHK,
    "5+": AppString.add5PlusBHK,
  }.obs;

  final RxString selectResidentialBhk = ''.obs;

  void updateResidentialBhk(String key) {
    selectResidentialBhk.value = key;
    AppLogger.log("✅Residential BHK Selected: $key");
  }

  final RxMap<String, String> residentialPostedByMap = {
    "5": AppString.owners,
    "6": AppString.brokers,
    "7": AppString.builders,
  }.obs;

  final RxString selectedResidentialPostedByKey = ''.obs;

  void updateResidentialPostedByKey(String key) {
    selectedResidentialPostedByKey.value = key;
    AppLogger.log("✅ Residential Posted By: $key");
  }

  //===================================================//
  // 🔄 PAGINATED Residential Search PROPERTY

  RxBool isResidentialPaginating = false.obs;
  RxInt residentialCurrentPage = 1.obs;
  RxInt residentialLastPage = 1.obs;
  RxList<BuyProperty> paginatedResidentialSearchProperty = <BuyProperty>[].obs;

  Future<void> fetchResidentialPaginatedProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore &&
        residentialCurrentPage.value >= residentialLastPage.value) {
      AppLogger.log("No more Residential Search Page  to Load");
      return;
    }

    isResidentialPaginating(true);

    final residentialPayload = {
      "type": "RESIDENTIAL",
      "city": selectedResidentialCity?.name,
      "area": selectedResidentialArea?.area,
      "type_options_id":
          residentialTypeValueMap[selectResidentialTypesOfProperty.value],
      "min": selectedResidentialMinAmount.value?.toInt(),
      "max": selectedResidentialMaxAmount.value?.toInt(),
      "posted_by": int.tryParse(selectedResidentialPostedByKey.value),
      "bhk": selectResidentialBhk.value,
    };

    AppLogger.log("🔥 Final Payload --> ${residentialPayload}");

    try {
      final nextPage = isLoadMore ? residentialCurrentPage.value + 1 : 1;
      final response = await searchPropertyRepository.getSearchList(
          page: nextPage, payload: residentialPayload);
      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        residentialCurrentPage.value = data.pagination.currentPage;
        residentialLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedResidentialSearchProperty.addAll(data.properties);
        } else {
          paginatedResidentialSearchProperty.assignAll(data.properties);
        }
      } else {
        Get.snackbar(
            "Error", response["message"] ?? "Failed to load Properties");
      }
    } finally {
      isResidentialPaginating(false);
    }
  }

  ///----------------  Commercial  ----------------------------------///

  List<City> commercialCityOptions = [];
  City? selectedCommercialCity;

  void updateCommercialSelectedCity(String? cityName) {
    final selectedCommercialSearchCity =
        commercialCityOptions.firstWhereOrNull((city) => city.name == cityName);
    if (selectedCommercialSearchCity != null) {
      selectedCommercialCity = selectedCommercialSearchCity;
      update();
      AppLogger.log("✅ City Selected: ${selectedCommercialCity!.name}");
    } else {
      AppLogger.log("❌ City not found in list");
    }
  }

  RxList<Area> commercialAreaOptions = <Area>[].obs;
  Area? selectedCommercialArea;

  Future<void> fetchCommercialAreaList(String cityName) async {
    AppLogger.log("Resetting Commercial Area State.....");
    commercialAreaOptions.clear();
    selectedCommercialArea = null;
    commercialAreaSearchController.clear();
    update();

    try {
      final response = await postService.postRequest(
        url: getAreaListUrl,
        body: {"city": cityName},
        requiresAuth: false,
      );
      if (response["success"] == true && response["data"] != null) {
        final List<dynamic> data = response["data"]["data"];
        commercialAreaOptions
            .assignAll(data.map((e) => Area.fromJson(e)).toList());
        commercialAreaSearchController.clear();
        selectedCommercialArea = null;
        update();
        Get.log(
            "✅ Commercial Area Loaded for $cityName: ${commercialAreaOptions.length}");
      } else {
        commercialAreaOptions.clear();
        selectedCommercialArea = null;
        update();
        Get.log(
            " Commercial Area load failed: ${response["message"] ?? "Unknown error"}");
      }
    } catch (e) {
      commercialAreaOptions.clear();
      selectedCommercialArea = null;
      update();
      Get.log("Exception in Commercial area load -->> $e");
    }
  }

  RxList<String> commercialPropertyTypeList = [
    AppString.office,
    AppString.retail,
    AppString.plotLand,
    AppString.storage,
  ].obs;

  final RxString selectCommercialTypesOfProperty = ''.obs;

  final Map<String, List<String>> commercialTypeValueMap = {
    AppString.office: ["1", "27", "35", "18"],
    AppString.retail: ["8", "28", "36", "19"],
    AppString.plotLand: ["9", "29", "37", "20"],
    AppString.storage: ["11", "30", "38", "22"],
  };

  RxList<double> commercialAmountOptions = <double>[
    10000,
    20000,
    30000,
    40000,
    50000,
    100000,
    500000,
    1000000,
    2000000,
    3000000,
    4000000,
    5000000,
    6000000,
    7000000,
    8000000,
    9000000,
    10000000,
    20000000,
    30000000,
    40000000,
    50000000,
    60000000,
    70000000,
    80000000,
    90000000,
    100000000,
    200000000,
    200000001,
  ].obs;

  RxnDouble selectedCommercialMinAmount = RxnDouble();
  RxnDouble selectedCommercialMaxAmount = RxnDouble();

  String? get commercialMinimumAmount =>
      selectedCommercialMinAmount.value?.toStringAsFixed(0);

  String? get commercialMaximumAmount =>
      selectedCommercialMaxAmount.value?.toStringAsFixed(0);

  void updateSelectedCommercialMinAmount(double? value) {
    selectedCommercialMinAmount.value = value;
    AppLogger.log(
        "Commercial Minimum Amount field value--->>>> $commercialMinimumAmount");
  }

  void updateSelectedCommercialMaxAmount(double? value) {
    selectedCommercialMaxAmount.value = value;
    AppLogger.log(
        "Commercial Maximum Amount field value--->>>> $commercialMaximumAmount");
  }

  final RxMap<String, String> commercialBhkList = {
    "1": AppString.add1BHK,
    "2": AppString.add2BHK,
    "3": AppString.add3BHK,
    "4": AppString.add4BHK,
    "5": AppString.add5BHK,
    "5+": AppString.add5PlusBHK,
  }.obs;

  final RxString selectCommercialBhk = ''.obs;

  void updateCommercialBhk(String key) {
    selectCommercialBhk.value = key;
    AppLogger.log("✅ Commercial BHK Selected: $key");
  }

  final RxMap<String, String> commercialPostedByMap = {
    "5": AppString.owners,
    "6": AppString.brokers,
    "7": AppString.builders,
  }.obs;

  final RxString selectedCommercialPostedByKey = ''.obs;

  void updateCommercialPostedByKey(String key) {
    selectedCommercialPostedByKey.value = key;
    AppLogger.log("✅ Commercial Posted By: $key");
  }

  //===================================================//
  // 🔄 PAGINATED Commercial Search PROPERTY

  RxBool isCommercialPaginating = false.obs;
  RxInt commercialCurrentPage = 1.obs;
  RxInt commercialLastPage = 1.obs;
  RxList<BuyProperty> paginatedCommercialSearchProperty = <BuyProperty>[].obs;

  Future<void> fetchCommercialPaginatedProperties(
      {bool isLoadMore = false}) async {
    if (isLoadMore && commercialCurrentPage.value >= commercialLastPage.value) {
      AppLogger.log("No more Commercial Search Page to load");
      return;
    }
    isCommercialPaginating(true);

    final commercialPayload = {
      "type": "COMMERCIAL",
      "city": selectedCommercialCity?.name,
      "area": selectedCommercialArea?.area,
      "type_options_id":
          commercialTypeValueMap[selectCommercialTypesOfProperty.value],
      "min": selectedCommercialMinAmount.value?.toInt(),
      "max": selectedCommercialMaxAmount.value?.toInt(),
      "posted_by": int.tryParse(selectedCommercialPostedByKey.value),
      "bhk": selectCommercialBhk.value
    };
    AppLogger.log("Final Commercial payload -->> ${commercialPayload}");

    try {
      final nextPage = isLoadMore ? commercialCurrentPage.value + 1 : 1;
      final response = await searchPropertyRepository.getSearchList(
          page: nextPage, payload: commercialPayload);

      if (response["success"] == true) {
        final data = PropertyModel.fromJson(response["data"]);
        commercialCurrentPage.value = data.pagination.currentPage;
        commercialLastPage.value = data.pagination.lastPage;

        if (isLoadMore) {
          paginatedCommercialSearchProperty.addAll(data.properties);
        } else {
          paginatedCommercialSearchProperty.assignAll(data.properties);
        }
      } else {
        Get.snackbar(
            "Error", response["message"] ?? "Failed to load Properties");
      }
    } finally {
      isCommercialPaginating(false);
    }
  }

  ///----------------  Project  ----------------------------------///

  //--project

  RxList<ProjectDropdownItemModel> projectTypeCommercialList =
      <ProjectDropdownItemModel>[].obs;
  RxList<ProjectDropdownItemModel> projectTypeResidentialList =
      <ProjectDropdownItemModel>[].obs;

  Rx<ProjectDropdownItemModel?> selectedProjectTypeCommercialList =
      Rx<ProjectDropdownItemModel?>(null);
  Rx<ProjectDropdownItemModel?> selectedProjectTypeResidentialList =
      Rx<ProjectDropdownItemModel?>(null);

  RxBool isLoadingDropDown = false.obs;

  Future<void> loadSearchProjectDropdowns() async {
    isLoadingDropDown.value = true;
    final result = await searchPropertyRepository.fetchSearchDropDownList();
    AppLogger.log("Print DropDownList reslut -->> $result");

    if (result["success"] == true) {
      final List data = result["data"] ?? [];

      AppLogger.log("Print DropDownList -->> $data");

      final List<ProjectDropdownItemModel> allItems =
          data.map((e) => ProjectDropdownItemModel.fromJson(e)).toList();
      projectTypeCommercialList.assignAll(allItems.where((e) => e.type == 2));
      projectTypeResidentialList.assignAll(allItems.where((e) => e.type == 8));
    } else {
      Get.snackbar(
          "Error", result["message"] ?? "Failed to load dropdown data");
    }
    isLoadingDropDown.value = false;
  }

  //-----------------
  List<City> projectCityOptions = [];
  City? selectedProjectCity;

  void updateProjectSelectedCity(String? cityName) {
    final selectedProjectSearchCity =
        projectCityOptions.firstWhereOrNull((city) => city.name == cityName);
    if (selectedProjectSearchCity != null) {
      selectedProjectCity = selectedProjectSearchCity;
      update();
      AppLogger.log("✅Project  City Selected: ${selectedCommercialCity!.name}");
    } else {
      AppLogger.log("❌ City not found in list");
    }
  }

  RxList<Area> projectAreaOptions = <Area>[].obs;
  Area? selectedProjectArea;

  Future<void> fetchProjectAreaList(String cityName) async {
    AppLogger.log("Resetting Project Area State.....");
    projectAreaOptions.clear();
    selectedProjectArea = null;
    projectAreaSearchController.clear();
    update();

    try {
      final response = await postService.postRequest(
        url: getAreaListUrl,
        body: {"city": cityName},
        requiresAuth: false,
      );
      if (response["success"] == true && response["data"] != null) {
        final List<dynamic> data = response["data"]["data"];
        projectAreaOptions
            .assignAll(data.map((e) => Area.fromJson(e)).toList());
        projectAreaSearchController.clear();
        selectedProjectArea = null;
        update();
        AppLogger.log(
            "✅ Project Area Loaded for $cityName: ${projectAreaOptions.length}");
      } else {
        projectAreaOptions.clear();
        selectedProjectArea = null;
        update();
        AppLogger.log(
            " Project Area load failed: ${response["message"] ?? "Unknown error"}");
      }
    } catch (e) {
      projectAreaOptions.clear();
      selectedProjectArea = null;
      update();
      AppLogger.log("Exception in Project area load -->> $e");
    }
  }

  ProjectDropdownItemModel? get selectedProjectType {
    return selectedProjectTypeResidentialList.value ??
        selectedProjectTypeCommercialList.value;
  }

  //===================================================//
  // 🔄 PAGINATED Project Search PROPERTY

  RxBool isProjectPaginating = false.obs;
  RxInt projectCurrentPage = 1.obs;
  RxInt projectLastPage = 1.obs;
  RxList<ProjectPostModel> paginatedProjectSearchProject =
      <ProjectPostModel>[].obs;

  Future<void> fetchProjectPaginatedProject({bool isLoadMore = false}) async {
    if (isLoadMore && projectCurrentPage.value >= projectLastPage.value) {
      AppLogger.log("No More project search page to load");
      return;
    }

    isProjectPaginating(true);

    final projectPayload = {
      "type": "PROJECT",
      "project_type": selectedProjectType!.id,
      "city": selectedProjectCity?.id,
      "area": selectedProjectArea?.area,
    };

    AppLogger.log("Final Search Project Payload -->> $projectPayload");

    try {
      final nextPage = isLoadMore ? projectCurrentPage.value + 1 : 1;
      final response = await searchPropertyRepository.getProjectSearchList(
          payload: projectPayload, page: nextPage);

      if (response["success"] == true) {
        final data = ProjectModel.fromJson(response["data"]);
        projectCurrentPage.value = data.projectPagination.currentPage;
        projectLastPage.value = data.projectPagination.lastPage;
        if (isLoadMore) {
          paginatedProjectSearchProject.addAll(data.project);
        } else {
          paginatedProjectSearchProject.assignAll(data.project);
        }
      } else {
        Get.snackbar("Error", response["message"] ?? "Failed to load projects");
      }
    } finally {
      isProjectPaginating(false);
    }
  }

//////////////////////////////////=================================================================
  void resetAllFilters() {
    residentialSearchController.clear();
    selectedResidentialCity = null;

    residentialAreaSearchController.clear();
    selectedResidentialArea = null;

    selectResidentialTypesOfProperty.value = '';
    selectedResidentialMinAmount.value = null;
    selectedResidentialMaxAmount.value = null;
    selectResidentialBhk.value = '';
    selectedResidentialPostedByKey.value = '';
    ////////////////============================================

    commercialSearchController.clear();
    selectedCommercialCity = null;
    commercialAreaSearchController.clear();
    selectedCommercialArea = null;

    selectCommercialTypesOfProperty.value = '';
    selectedCommercialMinAmount.value = null;
    selectedCommercialMaxAmount.value = null;
    selectCommercialBhk.value = '';
    selectedCommercialPostedByKey.value = '';

    ////////////////============================================
    pgSearchController.clear();
    pgAreaSearchController.clear();
    selectedPgCity = null;
    selectedPgArea = null;

    selectedPgMinAmount.value = null;
    selectedPgMaxAmount.value = null;
    selectPgOccupancy.value = '';
    selectPgSuitableFor.value = '';
    selectedPgPostedByKey.value = '';

    ////////////////============================================
    projectSearchController.clear();
    projectAreaSearchController.clear();
    selectedProjectCity = null;
    selectedProjectArea = null;
    selectedProjectTypeCommercialList.value = null;
    selectedProjectTypeResidentialList.value = null;

    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadCityList();
    loadSearchProjectDropdowns();
  }

  @override
  void dispose() {
    super.dispose();
    residentialSearchController.dispose();
    commercialSearchController.dispose();
    pgSearchController.dispose();
    pgAreaSearchController.dispose();
    residentialAreaSearchController.dispose();
    commercialAreaSearchController.dispose();
    projectSearchController.dispose();
    projectAreaSearchController.dispose();
  }
}
