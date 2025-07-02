import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api_service/print_logger.dart';
import '../configs/app_color.dart';
import '../model/city_model.dart';
import '../model/project_dropdown_model.dart';
import '../repository/project_post_property_repo.dart';
import '../routes/app_routes.dart';
import 'fetch_city_list_controller.dart';

class ProjectPostPropertyController extends GetxController {
  final ProjectPostPropertyRepo projectPostPropertyRepo =
      Get.find<ProjectPostPropertyRepo>();


  final storage = GetStorage();

  RxInt projectCurrentStep = 1.obs;

  void saveProjectCurrentStep(int step) {
    storage.write("project_step", step);
    projectCurrentStep.value = step;
  }

  void projectRestoreLastStep() {
    projectCurrentStep.value = storage.read("project_step") ?? 1;
  }

  void projectResetStepProgress() {
    storage.remove("project_step");
    projectCurrentStep.value = 1;
  }

  void projectRedirectToSavedStep() {
    int savedStep = storage.read("project_step") ?? 1;
    projectCurrentStep.value = savedStep;
  }

  // ///------------------------------------

  RxList<ProjectDropdownItemModel> reraStatusList = <ProjectDropdownItemModel>[].obs;
  RxList<ProjectDropdownItemModel> propertyTypeCommercialList = <ProjectDropdownItemModel>[].obs;
  RxList<ProjectDropdownItemModel> projectStatusList = <ProjectDropdownItemModel>[].obs;
  RxList<ProjectDropdownItemModel> possessionStatusList = <ProjectDropdownItemModel>[].obs;
  RxList<ProjectDropdownItemModel> developmentStageList = <ProjectDropdownItemModel>[].obs;
  RxList<ProjectDropdownItemModel> zoningStatusList = <ProjectDropdownItemModel>[].obs;
  RxList<ProjectDropdownItemModel> permitStatusList = <ProjectDropdownItemModel>[].obs;
  RxList<ProjectDropdownItemModel> propertyTypeResidentialList = <ProjectDropdownItemModel>[].obs;
  RxList<ProjectDropdownItemModel> environmentClearanceList = <ProjectDropdownItemModel>[].obs;


  Rx<ProjectDropdownItemModel?> selectedReraStatus = Rx<ProjectDropdownItemModel?>(null);
  Rx<ProjectDropdownItemModel?> selectedPropertyTypeCommercialList = Rx<ProjectDropdownItemModel?>(null);
  Rx<ProjectDropdownItemModel?> selectedProjectStatusList = Rx<ProjectDropdownItemModel?>(null);
  Rx<ProjectDropdownItemModel?> selectedPossessionStatusList = Rx<ProjectDropdownItemModel?>(null);
  Rx<ProjectDropdownItemModel?> selectedDevelopmentStageList = Rx<ProjectDropdownItemModel?>(null);
  Rx<ProjectDropdownItemModel?> selectedZoningStatusList = Rx<ProjectDropdownItemModel?>(null);
  Rx<ProjectDropdownItemModel?> selectedPermitStatusList = Rx<ProjectDropdownItemModel?>(null);
  Rx<ProjectDropdownItemModel?> selectedPropertyTypeResidentialList = Rx<ProjectDropdownItemModel?>(null);
  Rx<ProjectDropdownItemModel?> selectedEnvironmentClearanceList = Rx<ProjectDropdownItemModel?>(null);


  RxBool isLoadingDropDown = false.obs;
  Future<void> loadProjectDropdowns() async {
    isLoadingDropDown.value = true;

    final result = await projectPostPropertyRepo.fetchProjectDropDownList();

    AppLogger.log("Print DropdownList Result --$result");


    if (result["success"] == true) {
      final List data = result["data"] ?? [];

      AppLogger.log("Print DropdownList --$data");

      final List<ProjectDropdownItemModel> allItems = data.map((e) => ProjectDropdownItemModel.fromJson(e)).toList();

      // Assign to correct category by type
      reraStatusList.assignAll(allItems.where((e) => e.type == 1));
      propertyTypeCommercialList.assignAll(allItems.where((e) => e.type == 2));
      projectStatusList.assignAll(allItems.where((e) => e.type == 3));
      possessionStatusList.assignAll(allItems.where((e) => e.type == 4));
      developmentStageList.assignAll(allItems.where((e) => e.type == 5));
      zoningStatusList.assignAll(allItems.where((e) => e.type == 6));
      permitStatusList.assignAll(allItems.where((e) => e.type == 7));
      propertyTypeResidentialList.assignAll(allItems.where((e) => e.type == 8));
      environmentClearanceList.assignAll(allItems.where((e) => e.type == 9));
    } else {
      Get.snackbar("Error", result["message"] ?? "Failed to load dropdown data");
    }

    isLoadingDropDown.value = false;
  }


//--project
  RxMap<String, String> projectSubTypeCategories = {
    "Commercial": "1",
    "Residential": "2",
  }.obs;
  RxString selectedProjectSubTypeCategory = "".obs;

  void updateSelectedProjectSubTypeCategory(String displayValue) {
    selectedProjectSubTypeCategory.value =
        projectSubTypeCategories[displayValue] ?? "";
  }

  //--project Name

  RxBool hasProjectNameFocus = false.obs;
  RxBool hasProjectNameInput = false.obs;
  FocusNode projectNameFocusNode = FocusNode();
  TextEditingController projectNameController = TextEditingController();

  //----RERA Register

  RxBool hasProjectReraFocus = false.obs;
  RxBool hasProjectReraInput = false.obs;
  FocusNode projectReraFocusNode = FocusNode();
  TextEditingController projectReraController = TextEditingController();



  //--City

  List<City> projectCityOptions = [];
  City? selectedProjectCity;
  TextEditingController citySearchController = TextEditingController();

  Future<void> loadCityList() async {
    final cityListController = Get.find<CityList>();
    projectCityOptions.clear();
    projectCityOptions.addAll(cityListController.cityList);
  }

  void updateSelectedProjectCity(String? cityName) {
    final selectedCity =
        projectCityOptions.firstWhereOrNull((city) => city.name == cityName);
    if (selectedCity != null) {
      selectedProjectCity = selectedCity;
      update();
    }
  }

  //////////////////-----Area
  RxBool hasProjectAreaFocus = false.obs;
  RxBool hasProjectAreaInput = false.obs;
  FocusNode projectAreaFocusNode = FocusNode();
  TextEditingController projectAreaController = TextEditingController();

  //////////////////-----ZipCode
  RxBool hasProjectZipCodeFocus = false.obs;
  RxBool hasProjectZipCodeInput = false.obs;
  FocusNode projectZipCodeFocusNode = FocusNode();
  TextEditingController projectZipCodeController = TextEditingController();

  //////////////////-----Country name
  RxBool hasProjectCountryNameFocus = false.obs;
  RxBool hasProjectCountryNameInput = false.obs;
  FocusNode projectCountryNameFocusNode = FocusNode();
  TextEditingController projectCountryNameController = TextEditingController();

  //////////////////-----Total Area
  RxBool hasProjectTotalAreaFocus = false.obs;
  RxBool hasProjectTotalAreaInput = false.obs;
  FocusNode projectTotalAreaFocusNode = FocusNode();
  TextEditingController projectTotalAreaController = TextEditingController();



  //////////////////-----Total Towers
  RxBool hasProjectTotalTowersFocus = false.obs;
  RxBool hasProjectTotalTowersInput = false.obs;
  FocusNode projectTotalTowersFocusNode = FocusNode();
  TextEditingController projectTotalTowersController = TextEditingController();

  //////////////////-----Total Floors
  RxBool hasProjectTotalFloorsFocus = false.obs;
  RxBool hasProjectTotalFloorsInput = false.obs;
  FocusNode projectTotalFloorsFocusNode = FocusNode();
  TextEditingController projectTotalFloorsController = TextEditingController();

  //////////////////-----Conference Rooms
  RxBool hasProjectConferenceRoomFocus = false.obs;
  RxBool hasProjectConferenceRoomInput = false.obs;
  FocusNode projectConferenceRoomFocusNode = FocusNode();
  TextEditingController projectConferenceRoomController =
      TextEditingController();

  //////////////////-----Seats
  RxBool hasProjectSeatsFocus = false.obs;
  RxBool hasProjectSeatsInput = false.obs;
  FocusNode projectSeatsFocusNode = FocusNode();
  TextEditingController projectSeatsController = TextEditingController();

  //////////////////-----Bathrooms
  RxBool hasProjectBathRoomsFocus = false.obs;
  RxBool hasProjectBathRoomsInput = false.obs;
  FocusNode projectBathRoomsFocusNode = FocusNode();
  TextEditingController projectBathRoomsController = TextEditingController();

  //////////////////-----Parking Spaces
  RxBool hasProjectParkingSpacesFocus = false.obs;
  RxBool hasProjectParkingSpacesInput = false.obs;
  FocusNode projectParkingSpacesFocusNode = FocusNode();
  TextEditingController projectParkingSpacesController =
      TextEditingController();

  //////////////////-----AMENITIES Commercial

  RxMap<String, String> commercialAmenities = {
    "Internet Connectivity": "112",
    "24/7 Security": "113",
    "Elevator": "114",
    "Cafeteria / Food Court": "115",
    "Lobby Area": "116",
    "Break Room": "117",
    "Outdoor Sitting Area": "118",
    "Electric Vehicle Charging Station": "119",
    "janitorial services": "120",
    "Backup Power Service": "121",
    "Vending Machine": "122",
    "ATMs": "123",
    "Flexible Work Options": "124",
    "On-Site Tech Support": "125",
    "Helipad": "142",
    "Visitor Parking": "148",
    "Reserved Parking": "149",
  }.obs;

  RxList<String> selectedCommercialAmenitiesValues = <String>[].obs;

  void toggleCommercialAmenities(String amenity) {
    if (selectedCommercialAmenitiesValues
        .contains(commercialAmenities[amenity])) {
      selectedCommercialAmenitiesValues.remove(commercialAmenities[amenity]);
    } else {
      selectedCommercialAmenitiesValues.add(commercialAmenities[amenity]!);
    }
  }

//-- Description
  RxBool hasProjectDescriptionFocus = false.obs;
  RxBool hasProjectDescriptionInput = false.obs;
  FocusNode projectDescriptionFocusNode = FocusNode();
  TextEditingController projectDescriptionController = TextEditingController();

//-- Super Build-Up Area
  RxBool hasProjectSuperBuildUpAreaFocus = false.obs;
  RxBool hasProjectSuperBuildUpAreaInput = false.obs;
  FocusNode projectSuperBuildUpAreaFocusNode = FocusNode();
  TextEditingController projectSuperBuildUpAreaController =
      TextEditingController();

  //-- Lift
  RxBool hasProjectLiftFocus = false.obs;
  RxBool hasProjectLiftInput = false.obs;
  FocusNode projectLiftFocusNode = FocusNode();
  TextEditingController projectLiftController = TextEditingController();

  //-- Total unit
  RxBool hasProjectTotalUnitFocus = false.obs;
  RxBool hasProjectTotalUnitInput = false.obs;
  FocusNode projectTotalUnitFocusNode = FocusNode();
  TextEditingController projectTotalUnitController = TextEditingController();

  //-- project Size
  RxBool hasProjectSizeFocus = false.obs;
  RxBool hasProjectSizeInput = false.obs;
  FocusNode projectSizeFocusNode = FocusNode();
  TextEditingController projectSizeController = TextEditingController();

  //-- Project Facing

  RxMap<String, String> projectFacingOptions = {
    "NORTH": "NORTH",
    "SOUTH": "SOUTH",
    "EAST": "EAST",
    "WEST": "WEST",
    "NORTH-EAST": "NORTH-EAST",
    "NORTH-WEST": "NORTH-WEST",
    "SOUTH-EAST": "SOUTH-EAST",
    "SOUTH-WEST": "SOUTH-WEST",
  }.obs;

  RxString selectedProjectFacing = "".obs;

  void updateSelectedProjectFacing(String? value) {
    if (value != null && projectFacingOptions.containsKey(value)) {
      selectedProjectFacing.value = value;
    }
  }

  //////////////////-----AMENITIES Residential

  RxMap<String, String> residentialAmenities = {
    "power backup": "1",
    "Security": "17",
    "Laundry Service": "28",
    "Swimming Pool": "101",
    "Gym": "126",
    "Parking": "127",
    "Intercom Facility": "128",
    "Walking Tracks": "129",
    "Landscaped Gardens": "130",
    "Elevator": "131",
    "Concierge Service": "132",
    "Rooftop Terrace": "133",
    "Sauna": "134",
    "Convenience store": "135",
    "Pet Park": "136",
    "Barbecue Area": "137",
    "Clubhouse": "138",
    "Children's playground": "139",
    "Community Hall": "140",
    "Helipad": "141",
    "Multi Purpose Hall": "143",
    "Banquet Hall": "145",
    "Maintenance  Staff": "146",
    "Visitor Parking": "147",
    "Reserved Parking": "150",
  }.obs;

  RxList<String> selectedResidentialAmenitiesValues = <String>[].obs;

  void toggleResidentialAmenities(String amenity) {
    if (selectedResidentialAmenitiesValues
        .contains(residentialAmenities[amenity])) {
      selectedResidentialAmenitiesValues.remove(residentialAmenities[amenity]);
    } else {
      selectedResidentialAmenitiesValues.add(residentialAmenities[amenity]!);
    }
  }

  //-- Number of BedRooms
  RxBool hasProjectBedRoomsFocus = false.obs;
  RxBool hasProjectBedRoomsInput = false.obs;
  FocusNode projectBedRoomsFocusNode = FocusNode();
  TextEditingController projectBedRoomsController = TextEditingController();

  //-- Number of Balcony
  RxBool hasProjectBalconyFocus = false.obs;
  RxBool hasProjectBalconyInput = false.obs;
  FocusNode projectBalconyFocusNode = FocusNode();
  TextEditingController projectBalconyController = TextEditingController();

  //-- Room Configuration in bhk
  RxBool hasProjectRoomConfigurationFocus = false.obs;
  RxBool hasProjectRoomConfigurationInput = false.obs;
  FocusNode projectRoomConfigurationFocusNode = FocusNode();
  TextEditingController projectRoomConfigurationController =
      TextEditingController();

  bool shouldShowField(String fieldName) {
    final subtypeKey = projectSubTypeCategories.entries
            .firstWhereOrNull(
                (entry) => entry.value == selectedProjectSubTypeCategory.value)
            ?.key ??
        "";

    final visibilityMap = {
      "Commercial": [
        "PROPERTYCOMMERCIAL",
        "ZONINGSTATUSCOMMERCIAL",
        "TOWERS",
        "FLOORS",
        "CONFERENCEROOM",
        "SEATS",
        "AMENITIESCOMMERCIAL",
        "Next"
      ],
      "Residential": [
        "PROPERTYRESIDENTIAL",
        "SUPERBUILDUPAREA",
        "TOWERS",
        "FLOORS",
        "LIFT",
        "TOTALUNIT",
        "PROJECTSIZE",
        "PLOLTFACING",
        "AMENITIESRESIDENTIAL",
        "BEDROOMS",
        "BALCONY",
        "ROOMCONFIGURATION",
        "Next"
      ]
    };
    final isVisible = visibilityMap[subtypeKey]?.contains(fieldName) ?? false;

    return isVisible;
  }

  Map<String, dynamic> buildProjectPayload() {
    String subtypeKey = projectSubTypeCategories.entries
        .firstWhere(
          (entry) => entry.value == selectedProjectSubTypeCategory.value,
          orElse: () => const MapEntry("", ""),
        )
        .key;

    final project = selectedProjectSubTypeCategory.value;

    Map<String, dynamic> payload = {
      "project": project,
      "project_name": projectNameController.text..trim(),
      "rera_register": projectReraController.text.trim(),
      "rera_status":selectedReraStatus.value?.id.toString(),
      "city": selectedProjectCity?.id.toString() ?? "",
      "area": projectAreaController.text.trim(),
      "zip_code": projectZipCodeController.text.trim(),
      "country": projectCountryNameController.text.trim(),
      "total_area": projectTotalAreaController.text.trim(),
      "project_status":selectedProjectStatusList.value?.id.toString(),
      "Possession_status":
      selectedPossessionStatusList.value?.id.toString(),
      "development_stage":
      selectedDevelopmentStageList.value?.id.toString(),
      "permit_status":selectedPermitStatusList.value?.id.toString(),
      "total_towers": projectTotalTowersController.text.trim(),
      "total_floors": projectTotalFloorsController.text.trim(),
      "environmental_clearance":  selectedEnvironmentClearanceList.value?.id.toString(),
      "no_of_bathroom": projectBathRoomsController.text.trim(),
      "parking_space": projectParkingSpacesController.text.trim(),
      "project_description": projectDescriptionController.text.trim(),
    };

    switch (subtypeKey) {
      case "Commercial":
        payload.addAll({
          "project_type": selectedPropertyTypeCommercialList.value?.id.toString(),
          "zoning_status":selectedZoningStatusList.value?.id.toString(),
          "no_of_conferenceRoom": projectConferenceRoomController.text.trim(),
          "no_of_seats": projectSeatsController.text.trim(),
          "amenities": selectedCommercialAmenitiesValues,
        });
        break;

      case "Residential":
        payload.addAll({
          "project_type": selectedPropertyTypeResidentialList.value?.id.toString(),
          "amenities": selectedResidentialAmenitiesValues,
          "no_of_bhk": projectRoomConfigurationController.text.trim(),
          "no_of_bedroom": projectBedRoomsController.text.trim(),
          "no_of_balcony": projectBalconyController.text.trim(),
          "super_area": projectSuperBuildUpAreaController.text.trim(),
          "lift": projectLiftController.text.trim(),
          "facing": projectFacingOptions[selectedProjectFacing.value],
          "total_unit": projectTotalUnitController.text.trim(),
          "project_size": projectSizeController.text.trim(),
        });
    }
    return payload;
  }

  bool validateStep1Fields() {
    if (selectedProjectSubTypeCategory.value.isEmpty) {
      Get.snackbar("Error", "Please select property type");
      return false;
    }

    if (projectNameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please Enter Project Name");
      return false;
    }

    if (shouldShowField("PROPERTYCOMMERCIAL") &&
       selectedPropertyTypeCommercialList.value== null) {
      Get.snackbar("Error", "Please select Property Type");
      return false;
    }

    if (shouldShowField("PROPERTYRESIDENTIAL") &&
        selectedPropertyTypeResidentialList.value == null) {
      Get.snackbar("Error", "Please select property Type ");
      return false;
    }

    if (citySearchController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please Select City From List ");
      return false;
    }

    if (projectZipCodeController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please Enter Your Zip Code");
      return false;
    }
    if (projectZipCodeController.text.length != 6) {
      Get.snackbar("Error", "Please Enter 6 Digit Zip Code");
      return false;
    }

    return true;
  }

  RxBool isLoading = false.obs;
  bool isProjectDetailSubmitted = false;
  RxInt projectId = 0.obs;

  Future<void> submitProjectDetailStep1() async {
    if (!validateStep1Fields()) return;
    isProjectDetailSubmitted = false;

    isLoading(true);

    try {
      final response = await projectPostPropertyRepo.submitStep1ProjectDetail();
      isLoading(false);


      final responseMessage = response["data"]?["message"]?.toString().trim() ?? "";

      if(responseMessage == "Your free listing limit has been completed. Please top up your wallet."){
        Get.snackbar("Notice", responseMessage);
        showFullscreenLoader();
        await Future.delayed(const Duration(seconds: 4));
        await launchUrl(
          Uri.parse("https://www.tytil.com/payment/topup"),
          mode: LaunchMode.externalApplication
        );

        hideFullscreenLoader();
        return;
      }


      if (response["success"] == true) {
        isProjectDetailSubmitted = true;

        int? projectId = response["data"]?["data"]?["id"] as int?;
        if (projectId != null && projectId != 0) {
          storage.write("project_id", projectId);
          AppLogger.log("Project Id Stored -->> $projectId");
        }
        saveProjectCurrentStep(2);
        String msg =
            response["data"]?["message"] ?? "Commercial Details Submitted";
        AppLogger.log(" Project Step1 Success message -->>> $msg");
        Get.snackbar("Success", msg, backgroundColor: AppColor.green);
      } else {
        isProjectDetailSubmitted = false;
        String errMsg = response["data"]?["message"] ??
            "Something Went Wrong! Please try again later. ";
        AppLogger.log("Project Step1 Error message");
        Get.snackbar(
          "Error",
          errMsg,
        );
      }
    } catch (e) {
      isLoading(false);
      isProjectDetailSubmitted = false;
      Get.snackbar(
        "Error",
        "API Error: $e",
      );
    }
  }



  void showFullscreenLoader() {
    Get.dialog(
      const Center(
        child: SpinKitCircle(
            size: 100,
            color: AppColor.primaryColor),
      ),
      barrierDismissible: false,
      // barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  void hideFullscreenLoader() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }



  /////////////////////// Project section step 2--------------------------------------------------------------------------

  //-- Developer Name
  RxBool hasProjectDeveloperNameFocus = false.obs;
  RxBool hasProjectDeveloperNameInput = false.obs;
  FocusNode projectDeveloperNameFocusNode = FocusNode();
  TextEditingController projectDeveloperNameController =
      TextEditingController();

  //-- Developer Phone Number 1
  RxBool hasProjectDeveloperPhoneNumber1Focus = false.obs;
  RxBool hasProjectDeveloperPhoneNumber1Input = false.obs;
  FocusNode projectDeveloperPhoneNumber1FocusNode = FocusNode();
  TextEditingController projectDeveloperPhoneNumber1Controller =
      TextEditingController();

  //-- Developer Phone Number 2
  RxBool hasProjectDeveloperPhoneNumber2Focus = false.obs;
  RxBool hasProjectDeveloperPhoneNumber2Input = false.obs;
  FocusNode projectDeveloperPhoneNumber2FocusNode = FocusNode();
  TextEditingController projectDeveloperPhoneNumber2Controller =
      TextEditingController();

  //-- Developer Email Address 1
  RxBool hasProjectDeveloperEmailAddress1Focus = false.obs;
  RxBool hasProjectDeveloperEmailAddress1Input = false.obs;
  FocusNode projectDeveloperEmailAddress1FocusNode = FocusNode();
  TextEditingController projectDeveloperEmailAddress1Controller =
      TextEditingController();

  //-- Developer Email Address 2
  RxBool hasProjectDeveloperEmailAddress2Focus = false.obs;
  RxBool hasProjectDeveloperEmailAddress2Input = false.obs;
  FocusNode projectDeveloperEmailAddress2FocusNode = FocusNode();
  TextEditingController projectDeveloperEmailAddress2Controller =
      TextEditingController();

  //-- Contact Person Name
  RxBool hasProjectContactPersonNameFocus = false.obs;
  RxBool hasProjectContactPersonNameInput = false.obs;
  FocusNode projectContactPersonNameFocusNode = FocusNode();
  TextEditingController projectContactPersonNameController =
      TextEditingController();

  //-- Contact Person Phone Number
  RxBool hasProjectContactPersonPhoneNumberFocus = false.obs;
  RxBool hasProjectContactPersonPhoneNumberInput = false.obs;
  FocusNode projectContactPersonPhoneNumberFocusNode = FocusNode();
  TextEditingController projectContactPersonPhoneNumberController =
      TextEditingController();

  //-- Contact Person Email Id
  RxBool hasProjectContactPersonEmailFocus = false.obs;
  RxBool hasProjectContactPersonEmailInput = false.obs;
  FocusNode projectContactPersonEmailFocusNode = FocusNode();
  TextEditingController projectContactPersonEmailController =
      TextEditingController();

  RxBool isLoadingStep2 = false.obs;
  bool isProjectDetailSubmittedStep2 = false;

  Future<void> submitProjectDetailsStep2() async {
    isProjectDetailSubmittedStep2 = false;
    if (projectDeveloperNameController.text.isEmpty) {
      Get.snackbar("Error", "Please Enter Developer Name");
      return;
    }

    if (projectDeveloperPhoneNumber1Controller.text.isEmpty) {
      Get.snackbar("Error", "Please Enter Developer Phone Number");
      return;
    }

    if (projectDeveloperPhoneNumber1Controller.text.length < 10 ||
        projectDeveloperPhoneNumber1Controller.text.length > 15) {
      Get.snackbar("Error", "Phone number must be between 10 to 15 digits");
      return;
    }

    if (projectDeveloperEmailAddress1Controller.text.isEmpty) {
      Get.snackbar("Error", "Please Enter Developer Email Address");
      return;
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex
        .hasMatch(projectDeveloperEmailAddress1Controller.text.trim())) {
      Get.snackbar("Error", "Please enter a valid email address");
      return;
    }

    if (projectContactPersonNameController.text.isEmpty) {
      Get.snackbar("Error", "Please Enter Contact person Name");
      return;
    }

    isLoadingStep2(true);
    final response = await projectPostPropertyRepo.submitStep2ProjectDetail(
        developerName: projectDeveloperNameController.text,
        developerPhoneNumber1:
            projectDeveloperPhoneNumber1Controller.text.trim(),
        developerPhoneNumber2: projectDeveloperPhoneNumber2Controller.text,
        developerEmail1: projectDeveloperEmailAddress1Controller.text,
        developerEmail2: projectDeveloperEmailAddress2Controller.text,
        contactPersonName: projectContactPersonNameController.text,
        contactPersonPhoneNumber:
            projectContactPersonPhoneNumberController.text,
        contactPersonEmail: projectContactPersonEmailController.text);

    isLoadingStep2(false);

    final responseMessage = response["data"]?["message"]?.toString().trim() ?? "";

    if(responseMessage == "Your free listing limit has been completed. Please top up your wallet."){
      Get.snackbar("Notice", responseMessage);
      showFullscreenLoader();
      await Future.delayed(const Duration(seconds: 4));
      await launchUrl(
          Uri.parse("https://www.tytil.com/payment/topup"),
          mode: LaunchMode.externalApplication
      );

      hideFullscreenLoader();
      return;
    }

    if (response["success"] == true) {
      isProjectDetailSubmittedStep2 = true;
      String successMessage = response["data"]?["message"] ?? "";
      saveProjectCurrentStep(3);

      AppLogger.log("Project success message step 2 -->>>> $successMessage");
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isProjectDetailSubmittedStep2 = false;
      String errorMessage = response["data"]?["message"] ??
          "Something Went wrong! Please try again later";
      Get.snackbar("Error", errorMessage);
    }
  }

  /////////////////////// Project section step 3--------------------------------------------------------------------------

//-- Token Amount
  RxBool hasProjectTokenAmountFocus = false.obs;
  RxBool hasProjectTokenAmountInput = false.obs;
  FocusNode projectTokenAmountFocusNode = FocusNode();
  TextEditingController projectTokenAmountController = TextEditingController();

//-- Property tax
  RxBool hasProjectPropertyTaxFocus = false.obs;
  RxBool hasProjectPropertyTaxInput = false.obs;
  FocusNode projectPropertyTaxFocusNode = FocusNode();
  TextEditingController projectPropertyTaxController = TextEditingController();

//-- Maintenance Fees
  RxBool hasProjectMaintenanceFeeFocus = false.obs;
  RxBool hasProjectMaintenanceFeeInput = false.obs;
  FocusNode projectMaintenanceFeeFocusNode = FocusNode();
  TextEditingController projectMaintenanceFeeController =
      TextEditingController();

//-- Additional Fees
  RxBool hasProjectAdditionalFeeFocus = false.obs;
  RxBool hasProjectAdditionalFeeInput = false.obs;
  FocusNode projectAdditionalFeeFocusNode = FocusNode();
  TextEditingController projectAdditionalFeeController =
      TextEditingController();

//-- Price Range
  RxBool hasProjectPriceRangeFocus = false.obs;
  RxBool hasProjectPriceRangeInput = false.obs;
  FocusNode projectPriceRangeFocusNode = FocusNode();
  TextEditingController projectPriceRangeController = TextEditingController();

  //-- Occupancy Rate
  RxBool hasProjectOccupancyRateFocus = false.obs;
  RxBool hasProjectOccupancyRateInput = false.obs;
  FocusNode projectOccupancyRateFocusNode = FocusNode();
  TextEditingController projectOccupancyRateController =
      TextEditingController();

//-- Annual Rental Income
  RxBool hasProjectAnnualRentalIncomeFocus = false.obs;
  RxBool hasProjectAnnualRentalIncomeInput = false.obs;
  FocusNode projectAnnualRentalIncomeFocusNode = FocusNode();
  TextEditingController projectAnnualRentalIncomeController =
      TextEditingController();

//-- Current Valuation
  RxBool hasProjectCurrentValuationFocus = false.obs;
  RxBool hasProjectCurrentValuationInput = false.obs;
  FocusNode projectCurrentValuationFocusNode = FocusNode();
  TextEditingController projectCurrentValuationController =
      TextEditingController();

  RxBool isLoadingStep3 = false.obs;
  bool isProjectDetailSubmittedStep3 = false;

  Future<void> submitProjectDetailsStep3() async {
    isProjectDetailSubmittedStep3 = false;
    if (projectPriceRangeController.text.isEmpty) {
      Get.snackbar("Error", "Please Enter Project Price Range");
      return;
    }

    isLoadingStep3(true);
    final response = await projectPostPropertyRepo.submitStep3ProjectDetail(
        tokenAmount: projectTokenAmountController.text,
        propertyTax: projectPropertyTaxController.text,
        maintenanceFee: projectMaintenanceFeeController.text,
        additionalFee: projectAdditionalFeeController.text,
        priceRange: projectPriceRangeController.text,
        occupancyRate: projectOccupancyRateController.text,
        annualRentalIncome: projectAnnualRentalIncomeController.text,
        currentValuation: projectCurrentValuationController.text);
    isLoadingStep3(false);

    final responseMessage = response["data"]?["message"]?.toString().trim() ?? "";

    if(responseMessage == "Your free listing limit has been completed. Please top up your wallet."){
      Get.snackbar("Notice", responseMessage);
      showFullscreenLoader();
      await Future.delayed(const Duration(seconds: 4));
      await launchUrl(
          Uri.parse("https://www.tytil.com/payment/topup"),
          mode: LaunchMode.externalApplication
      );

      hideFullscreenLoader();
      return;
    }

    if (response["success"] == true) {
      isProjectDetailSubmittedStep3 = true;
      saveProjectCurrentStep(4);
      int? projectPropertyId = response["data"]?["data"]?["id"];

      if (projectPropertyId != null) {
        storage.write("project_property_id", projectPropertyId);
        AppLogger.log("Project property id for Image ->> $projectPropertyId");
      }
      String successMessage =
          response["message"] ?? "Project Saved Successfully";
      AppLogger.log("Success Message Step 3---->>> $successMessage");
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isProjectDetailSubmittedStep3 = false;
      String errorMessage = response["message"] ??
          " Something Went Wrong! Please try again after sometime ";
      AppLogger.log("Project Step 3 Error message -->> $errorMessage");
      Get.snackbar("Error", errorMessage);
    }
  }

  /////////////////////// Project section step 4--------------------------------------------------------------------------

  RxBool isLoadingStep4 = false.obs;
  bool isProjectDetailSubmittedStep4 = false;

  Future<void> submitProjectDetailsStep4Images(List<File> images) async {
    isProjectDetailSubmittedStep4 = false;
    isLoadingStep4(true);
    if (images.isEmpty) {
      AppLogger.log("❌ No images selected by user.");
      isLoadingStep4(false);
      Get.snackbar(
        "Error",
        "Please select at least one image to upload.",
      );
      return;
    }

    int? projectPropertyId = storage.read("project_property_id");
    AppLogger.log("📦 Read project_property_id from storage: $projectPropertyId");
    if (projectPropertyId == null || projectPropertyId == 0) {
      AppLogger.log(" Invalid or missing property ID.");
      isLoadingStep4(false);
      Get.snackbar(
        "Error",
        "Invalid property ID. Please try again.",
      );
      return;
    }
    AppLogger.log(
        "🚀 Initiating Project image upload for Property ID: $projectPropertyId with ${images.length} images.");
    final response = await projectPostPropertyRepo.submitStep4ProjectImages(
      projectPropertyId: 0,
      imageFiles: images,
    );

    AppLogger.log("📥 Received response from image upload: $response");
    isLoadingStep4(false);
    if (response["success"] == true) {
      isProjectDetailSubmittedStep4 = true;
      storage.remove("project_id");
      storage.remove("project_property_id");
      AppLogger.log(" Cleared project_id and project_property_id from GetStorage");
      String successMessage =
          response["data"]?["message"] ?? "Images uploaded successfully!";
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
      projectResetStepProgress();
      Get.offNamed(AppRoutes.bottomBarView);
    } else {
      isProjectDetailSubmittedStep4 = true;
      String errorMessage = response["data"]?["errors"] ??
          "Something Went wrong during Image upload! Please try again later";
      Get.snackbar(
        "Error",
        errorMessage,
      );
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    loadCityList();
    loadProjectDropdowns();
    projectRestoreLastStep();
    Future.delayed(const Duration(milliseconds: 500), () {
      projectRedirectToSavedStep();
    });

    //--
    projectNameController.addListener(() {
      hasProjectNameInput.value = projectNameController.text.isNotEmpty;
    });

    projectNameFocusNode.addListener(() {
      hasProjectNameFocus.value = projectNameFocusNode.hasFocus;
    });

    //--
    projectReraController.addListener(() {
      hasProjectReraInput.value = projectReraController.text.isNotEmpty;
    });

    projectReraFocusNode.addListener(() {
      hasProjectReraFocus.value = projectReraFocusNode.hasFocus;
    });

    //--
    projectAreaController.addListener(() {
      hasProjectAreaInput.value = projectAreaController.text.isNotEmpty;
    });

    projectAreaFocusNode.addListener(() {
      hasProjectAreaFocus.value = projectAreaFocusNode.hasFocus;
    });

    //--
    projectZipCodeController.addListener(() {
      hasProjectZipCodeInput.value = projectZipCodeController.text.isNotEmpty;
    });

    projectZipCodeFocusNode.addListener(() {
      hasProjectZipCodeFocus.value = projectZipCodeFocusNode.hasFocus;
    });

    //--
    projectCountryNameController.addListener(() {
      hasProjectCountryNameInput.value =
          projectCountryNameController.text.isNotEmpty;
    });

    projectCountryNameFocusNode.addListener(() {
      hasProjectCountryNameFocus.value = projectCountryNameFocusNode.hasFocus;
    });

    //--
    projectTotalAreaController.addListener(() {
      hasProjectTotalAreaInput.value =
          projectTotalAreaController.text.isNotEmpty;
    });

    projectTotalAreaFocusNode.addListener(() {
      hasProjectTotalAreaFocus.value = projectTotalAreaFocusNode.hasFocus;
    });

    //--
    projectTotalTowersController.addListener(() {
      hasProjectTotalTowersInput.value =
          projectTotalTowersController.text.isNotEmpty;
    });

    projectTotalTowersFocusNode.addListener(() {
      hasProjectTotalTowersFocus.value = projectTotalTowersFocusNode.hasFocus;
    });

    //--
    projectTotalFloorsController.addListener(() {
      hasProjectTotalFloorsInput.value =
          projectTotalFloorsController.text.isNotEmpty;
    });

    projectTotalFloorsFocusNode.addListener(() {
      hasProjectTotalFloorsFocus.value = projectTotalFloorsFocusNode.hasFocus;
    });

    //--
    projectConferenceRoomController.addListener(() {
      hasProjectConferenceRoomInput.value =
          projectConferenceRoomController.text.isNotEmpty;
    });

    projectConferenceRoomFocusNode.addListener(() {
      hasProjectConferenceRoomFocus.value =
          projectConferenceRoomFocusNode.hasFocus;
    });

    //--
    projectSeatsController.addListener(() {
      hasProjectSeatsInput.value = projectSeatsController.text.isNotEmpty;
    });

    projectSeatsFocusNode.addListener(() {
      hasProjectSeatsFocus.value = projectSeatsFocusNode.hasFocus;
    });

    //--
    projectBathRoomsController.addListener(() {
      hasProjectBathRoomsInput.value =
          projectBathRoomsController.text.isNotEmpty;
    });

    projectBathRoomsFocusNode.addListener(() {
      hasProjectBathRoomsFocus.value = projectBathRoomsFocusNode.hasFocus;
    });

    //--
    projectParkingSpacesController.addListener(() {
      hasProjectParkingSpacesInput.value =
          projectParkingSpacesController.text.isNotEmpty;
    });

    projectParkingSpacesFocusNode.addListener(() {
      hasProjectParkingSpacesFocus.value =
          projectParkingSpacesFocusNode.hasFocus;
    });

    //--
    projectDescriptionController.addListener(() {
      hasProjectDescriptionInput.value =
          projectDescriptionController.text.isNotEmpty;
    });

    projectDescriptionFocusNode.addListener(() {
      hasProjectDescriptionFocus.value = projectDescriptionFocusNode.hasFocus;
    });

    //--
    projectSuperBuildUpAreaController.addListener(() {
      hasProjectSuperBuildUpAreaInput.value =
          projectSuperBuildUpAreaController.text.isNotEmpty;
    });

    projectSuperBuildUpAreaFocusNode.addListener(() {
      hasProjectSuperBuildUpAreaFocus.value =
          projectSuperBuildUpAreaFocusNode.hasFocus;
    });

    //--
    projectLiftController.addListener(() {
      hasProjectLiftInput.value = projectLiftController.text.isNotEmpty;
    });

    projectLiftFocusNode.addListener(() {
      hasProjectLiftFocus.value = projectLiftFocusNode.hasFocus;
    });

    //--
    projectTotalUnitController.addListener(() {
      hasProjectTotalUnitInput.value =
          projectTotalUnitController.text.isNotEmpty;
    });

    projectTotalUnitFocusNode.addListener(() {
      hasProjectTotalUnitFocus.value = projectTotalUnitFocusNode.hasFocus;
    });

    //--
    projectSizeController.addListener(() {
      hasProjectSizeInput.value = projectSizeController.text.isNotEmpty;
    });

    projectSizeFocusNode.addListener(() {
      hasProjectSizeFocus.value = projectSizeFocusNode.hasFocus;
    });

    //--
    projectBedRoomsController.addListener(() {
      hasProjectBedRoomsInput.value = projectBedRoomsController.text.isNotEmpty;
    });

    projectBedRoomsFocusNode.addListener(() {
      hasProjectBedRoomsFocus.value = projectBedRoomsFocusNode.hasFocus;
    });

    //--
    projectBalconyController.addListener(() {
      hasProjectBalconyInput.value = projectBalconyController.text.isNotEmpty;
    });

    projectBalconyFocusNode.addListener(() {
      hasProjectBalconyFocus.value = projectBalconyFocusNode.hasFocus;
    });

    //--
    projectRoomConfigurationController.addListener(() {
      hasProjectRoomConfigurationInput.value =
          projectRoomConfigurationController.text.isNotEmpty;
    });

    projectRoomConfigurationFocusNode.addListener(() {
      hasProjectRoomConfigurationFocus.value =
          projectRoomConfigurationFocusNode.hasFocus;
    });

    //////////////////////////step2

    //--
    projectDeveloperNameController.addListener(() {
      hasProjectDeveloperNameInput.value =
          projectDeveloperNameController.text.isNotEmpty;
    });

    projectDeveloperNameFocusNode.addListener(() {
      hasProjectDeveloperNameFocus.value =
          projectDeveloperNameFocusNode.hasFocus;
    });

    //--
    projectDeveloperPhoneNumber1Controller.addListener(() {
      hasProjectDeveloperPhoneNumber1Input.value =
          projectDeveloperPhoneNumber1Controller.text.isNotEmpty;
    });

    projectDeveloperPhoneNumber1FocusNode.addListener(() {
      hasProjectDeveloperPhoneNumber1Focus.value =
          projectDeveloperPhoneNumber1FocusNode.hasFocus;
    });

    //--
    projectDeveloperPhoneNumber2Controller.addListener(() {
      hasProjectDeveloperPhoneNumber2Input.value =
          projectDeveloperPhoneNumber2Controller.text.isNotEmpty;
    });

    projectDeveloperPhoneNumber2FocusNode.addListener(() {
      hasProjectDeveloperPhoneNumber2Focus.value =
          projectDeveloperPhoneNumber2FocusNode.hasFocus;
    });

    //--
    projectDeveloperEmailAddress1Controller.addListener(() {
      hasProjectDeveloperEmailAddress1Input.value =
          projectDeveloperEmailAddress1Controller.text.isNotEmpty;
    });

    projectDeveloperEmailAddress1FocusNode.addListener(() {
      hasProjectDeveloperEmailAddress1Focus.value =
          projectDeveloperEmailAddress1FocusNode.hasFocus;
    });

    //--
    projectDeveloperEmailAddress2Controller.addListener(() {
      hasProjectDeveloperEmailAddress2Input.value =
          projectDeveloperEmailAddress2Controller.text.isNotEmpty;
    });

    projectDeveloperEmailAddress2FocusNode.addListener(() {
      hasProjectDeveloperEmailAddress2Focus.value =
          projectDeveloperEmailAddress2FocusNode.hasFocus;
    });

    //--
    projectContactPersonNameController.addListener(() {
      hasProjectContactPersonNameInput.value =
          projectContactPersonNameController.text.isNotEmpty;
    });

    projectContactPersonNameFocusNode.addListener(() {
      hasProjectContactPersonNameFocus.value =
          projectContactPersonNameFocusNode.hasFocus;
    });

    //--
    projectContactPersonPhoneNumberController.addListener(() {
      hasProjectContactPersonPhoneNumberInput.value =
          projectContactPersonPhoneNumberController.text.isNotEmpty;
    });

    projectContactPersonPhoneNumberFocusNode.addListener(() {
      hasProjectContactPersonPhoneNumberFocus.value =
          projectContactPersonPhoneNumberFocusNode.hasFocus;
    });

    //--
    projectContactPersonEmailController.addListener(() {
      hasProjectContactPersonEmailInput.value =
          projectContactPersonEmailController.text.isNotEmpty;
    });

    projectContactPersonEmailFocusNode.addListener(() {
      hasProjectContactPersonEmailFocus.value =
          projectContactPersonEmailFocusNode.hasFocus;
    });

    //////////////////////////step3

//--
    projectTokenAmountController.addListener(() {
      hasProjectTokenAmountInput.value =
          projectTokenAmountController.text.isNotEmpty;
    });

    projectTokenAmountFocusNode.addListener(() {
      hasProjectTokenAmountFocus.value = projectTokenAmountFocusNode.hasFocus;
    });

    //--
    projectPropertyTaxController.addListener(() {
      hasProjectPropertyTaxInput.value =
          projectPropertyTaxController.text.isNotEmpty;
    });

    projectPropertyTaxFocusNode.addListener(() {
      hasProjectPropertyTaxFocus.value = projectPropertyTaxFocusNode.hasFocus;
    });

//--
    projectMaintenanceFeeController.addListener(() {
      hasProjectMaintenanceFeeInput.value =
          projectMaintenanceFeeController.text.isNotEmpty;
    });

    projectMaintenanceFeeFocusNode.addListener(() {
      hasProjectMaintenanceFeeFocus.value =
          projectMaintenanceFeeFocusNode.hasFocus;
    });

    //--
    projectAdditionalFeeController.addListener(() {
      hasProjectAdditionalFeeInput.value =
          projectAdditionalFeeController.text.isNotEmpty;
    });

    projectAdditionalFeeFocusNode.addListener(() {
      hasProjectAdditionalFeeFocus.value =
          projectAdditionalFeeFocusNode.hasFocus;
    });

    //--
    projectPriceRangeController.addListener(() {
      hasProjectPriceRangeInput.value =
          projectPriceRangeController.text.isNotEmpty;
    });

    projectPriceRangeFocusNode.addListener(() {
      hasProjectPriceRangeFocus.value = projectPriceRangeFocusNode.hasFocus;
    });

    //--
    projectOccupancyRateController.addListener(() {
      hasProjectOccupancyRateInput.value =
          projectOccupancyRateController.text.isNotEmpty;
    });

    projectOccupancyRateFocusNode.addListener(() {
      hasProjectOccupancyRateFocus.value =
          projectOccupancyRateFocusNode.hasFocus;
    });

    //--
    projectAnnualRentalIncomeController.addListener(() {
      hasProjectAnnualRentalIncomeInput.value =
          projectAnnualRentalIncomeController.text.isNotEmpty;
    });

    projectAnnualRentalIncomeFocusNode.addListener(() {
      hasProjectAnnualRentalIncomeFocus.value =
          projectAnnualRentalIncomeFocusNode.hasFocus;
    });

    //--
    projectCurrentValuationController.addListener(() {
      hasProjectCurrentValuationInput.value =
          projectCurrentValuationController.text.isNotEmpty;
    });

    projectCurrentValuationFocusNode.addListener(() {
      hasProjectCurrentValuationFocus.value =
          projectCurrentValuationFocusNode.hasFocus;
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    projectNameFocusNode.dispose();
    projectNameController.dispose();

    projectReraFocusNode.dispose();
    projectReraController.dispose();

    projectAreaFocusNode.dispose();
    projectAreaController.dispose();

    projectZipCodeFocusNode.dispose();
    projectZipCodeController.dispose();

    projectCountryNameFocusNode.dispose();
    projectCountryNameController.dispose();

    projectTotalAreaFocusNode.dispose();
    projectTotalAreaController.dispose();

    projectTotalTowersFocusNode.dispose();
    projectTotalTowersController.dispose();

    projectTotalFloorsFocusNode.dispose();
    projectTotalFloorsController.dispose();

    projectConferenceRoomFocusNode.dispose();
    projectConferenceRoomController.dispose();

    projectSeatsFocusNode.dispose();
    projectSeatsController.dispose();

    projectBathRoomsFocusNode.dispose();
    projectBathRoomsController.dispose();

    projectParkingSpacesFocusNode.dispose();
    projectParkingSpacesController.dispose();

    projectDescriptionFocusNode.dispose();
    projectDescriptionController.dispose();

    projectSuperBuildUpAreaFocusNode.dispose();
    projectSuperBuildUpAreaController.dispose();

    projectLiftFocusNode.dispose();
    projectLiftController.dispose();

    projectTotalUnitFocusNode.dispose();
    projectTotalUnitController.dispose();

    projectSizeFocusNode.dispose();
    projectSizeController.dispose();

    projectBedRoomsFocusNode.dispose();
    projectBedRoomsController.dispose();

    projectBalconyFocusNode.dispose();
    projectBalconyController.dispose();

    projectRoomConfigurationFocusNode.dispose();
    projectRoomConfigurationController.dispose();

    //////////////////////////step2

    projectDeveloperNameFocusNode.dispose();
    projectDeveloperNameController.dispose();

    projectDeveloperPhoneNumber1FocusNode.dispose();
    projectDeveloperPhoneNumber1Controller.dispose();

    projectDeveloperPhoneNumber2FocusNode.dispose();
    projectDeveloperPhoneNumber2Controller.dispose();

    projectDeveloperEmailAddress1FocusNode.dispose();
    projectDeveloperEmailAddress1Controller.dispose();

    projectDeveloperEmailAddress2FocusNode.dispose();
    projectDeveloperEmailAddress2Controller.dispose();

    projectContactPersonNameFocusNode.dispose();
    projectContactPersonNameController.dispose();

    projectContactPersonPhoneNumberFocusNode.dispose();
    projectContactPersonPhoneNumberController.dispose();

    projectContactPersonEmailFocusNode.dispose();
    projectContactPersonEmailController.dispose();

    //////////////////////////step3

    projectTokenAmountFocusNode.dispose();
    projectTokenAmountController.dispose();

    projectPropertyTaxFocusNode.dispose();
    projectPropertyTaxController.dispose();

    projectMaintenanceFeeFocusNode.dispose();
    projectMaintenanceFeeController.dispose();

    projectAdditionalFeeFocusNode.dispose();
    projectAdditionalFeeController.dispose();

    projectPriceRangeFocusNode.dispose();
    projectPriceRangeController.dispose();

    projectOccupancyRateFocusNode.dispose();
    projectOccupancyRateController.dispose();

    projectAnnualRentalIncomeFocusNode.dispose();
    projectAnnualRentalIncomeController.dispose();

    projectCurrentValuationFocusNode.dispose();
    projectCurrentValuationController.dispose();
  }
}
