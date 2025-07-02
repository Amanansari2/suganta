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
import '../repository/pg_post_property_repo.dart';
import '../repository/residential_post_property_repo.dart';
import '../routes/app_routes.dart';
import 'fetch_city_list_controller.dart';

class ResidentialPostPropertyController extends GetxController {
  final PGPostPropertyRepository pgPostPropertyRepository =
      Get.find<PGPostPropertyRepository>();

  ResidentialPostPropertyRepo residentialPostPropertyRepository =
      Get.find<ResidentialPostPropertyRepo>();
  final storage = GetStorage();

  RxInt residentialCurrentStep = 1.obs;

  void saveResidentialCurrentStep(int step) {
    storage.write("residential_step", step);
    residentialCurrentStep.value = step;
  }

  void residentialRestoreLastStep() {
    residentialCurrentStep.value = storage.read("residential_step") ?? 1;
  }

  void residentialResetStepProgress() {
    storage.remove("residential_step");
    residentialCurrentStep.value = 1;
  }

  void residentialRedirectToSavedStep() {
    int savedStep = storage.read("residential_step") ?? 1;
    residentialCurrentStep.value = savedStep;
  }

  //--------------------- residential first step-----------

  //---Type
  RxMap<String, String> residentialTypeCategories = {
    "SELL": "SELL",
    "RENT": "RENT",
    "RENT/LEASE": "RENT/LEASE",
    "LEASE": "LEASE",
  }.obs;

  RxString selectedResidentialTypeCategory = "".obs;

  void updateSelectedResidentialTypeCategory(String displayValue) {
    selectedResidentialTypeCategory.value =
        residentialTypeCategories[displayValue] ?? "";
  }

  //---SubType
  RxMap<String, String> residentialSubTypeCategories = {
    "Flat / Apartment": "2",
    "Independent / Villa": "3",
    "Builder Floors": "4",
    "Farmhouse": "5",
    "Plot / Land": "6",
  }.obs;
  RxString selectedResidentialSubTypeCategory = "".obs;

  void updateSelectedResidentialSubTypeCategory(String displayValue) {
    selectedResidentialSubTypeCategory.value =
        residentialSubTypeCategories[displayValue] ?? "";
  }

  //---BHK

  RxBool hasResidentialBhkFocus = false.obs;
  RxBool hasResidentialBhkInput = false.obs;
  FocusNode residentialBhkFocusNode = FocusNode();
  TextEditingController residentialBhkController = TextEditingController();

  //---No. of BedRooms

  RxBool hasResidentialBedRoomsFocus = false.obs;
  RxBool hasResidentialBedRoomsInput = false.obs;
  FocusNode residentialBedRoomsFocusNode = FocusNode();
  TextEditingController residentialBedRoomsController = TextEditingController();

  //---No. of Bathrooms

  RxBool hasResidentialBathroomsFocus = false.obs;
  RxBool hasResidentialBathroomsInput = false.obs;
  FocusNode residentialBathroomsFocusNode = FocusNode();
  TextEditingController residentialBathroomsController =
      TextEditingController();

  //---No. of Balconies

  RxBool hasResidentialBalconiesFocus = false.obs;
  RxBool hasResidentialBalconiesInput = false.obs;
  FocusNode residentialBalconiesFocusNode = FocusNode();
  TextEditingController residentialBalconiesController =
      TextEditingController();

  //---Carpet Area

  RxBool hasResidentialCarpetAreaFocus = false.obs;
  RxBool hasResidentialCarpetAreaInput = false.obs;
  FocusNode residentialCarpetAreaFocusNode = FocusNode();
  TextEditingController residentialCarpetAreaController =
      TextEditingController();

  //---Plot Area

  RxBool hasResidentialPlotAreaFocus = false.obs;
  RxBool hasResidentialPlotAreaInput = false.obs;
  FocusNode residentialPlotAreaFocusNode = FocusNode();
  TextEditingController residentialPlotAreaController = TextEditingController();

  //---BuildUp Area

  RxBool hasResidentialBuildUpAreaFocus = false.obs;
  RxBool hasResidentialBuildUpAreaInput = false.obs;
  FocusNode residentialBuildUpAreaFocusNode = FocusNode();
  TextEditingController residentialBuildUpAreaController =
      TextEditingController();

  //---Total Floors

  RxMap<String, String> totalFloorOptions = {
    "-10": "-10",
    "-9": "-9",
    "-8": "-8",
    "-7": "-7",
    "-6": "-6",
    "-5": "-5",
    "-4": "-4",
    "-3": "-3",
    "-2": "-2",
    "Basement": "-1",
    "Ground Floor": "0",
    "1": "1",
    "2": "2",
    "3": "3",
    "4": "4",
    "5": "5",
    "6": "6",
    "7": "7",
    "8": "8",
    "9": "9",
    "10": "10",
    "11": "11",
    "12": "12",
    "13": "13",
    "14": "14",
    "15": "15",
    "16": "16",
    "17": "17",
    "18": "18",
    "19": "19",
    "20": "20",
    "21": "21",
    "22": "22",
    "23": "23",
    "24": "24",
    "25": "25",
    "26": "26",
    "27": "27",
    "28": "28",
    "29": "29",
    "30": "30",
    "31": "31",
    "32": "32",
    "33": "33",
    "34": "34",
    "35": "35",
    "36": "36",
    "37": "37",
    "38": "38",
    "39": "39",
    "40": "40",
    "41": "41",
    "42": "42",
    "43": "43",
    "44": "44",
    "45": "45",
    "46": "46",
    "47": "47",
    "48": "48",
    "49": "49",
    "50": "50",
    "51": "51",
    "52": "52",
    "53": "53",
    "54": "54",
    "55": "55",
    "56": "56",
    "57": "57",
    "58": "58",
    "59": "59",
    "60": "60",
  }.obs;

  RxString selectedTotalFloor = "".obs;

  void updateSelectedTotalFloor(String? value) {
    if (value != null && totalFloorOptions.containsKey(value)) {
      selectedTotalFloor.value = value;
    }
  }

  RxMap<String, String> propertyFloorOptions = {
    "-10": "-10",
    "-9": "-9",
    "-8": "-8",
    "-7": "-7",
    "-6": "-6",
    "-5": "-5",
    "-4": "-4",
    "-3": "-3",
    "-2": "-2",
    "Basement": "-1",
    "Ground Floor": "0",
    "1": "1",
    "2": "2",
    "3": "3",
    "4": "4",
    "5": "5",
    "6": "6",
    "7": "7",
    "8": "8",
    "9": "9",
    "10": "10",
    "11": "11",
    "12": "12",
    "13": "13",
    "14": "14",
    "15": "15",
    "16": "16",
    "17": "17",
    "18": "18",
    "19": "19",
    "20": "20",
    "21": "21",
    "22": "22",
    "23": "23",
    "24": "24",
    "25": "25",
    "26": "26",
    "27": "27",
    "28": "28",
    "29": "29",
    "30": "30",
    "31": "31",
    "32": "32",
    "33": "33",
    "34": "34",
    "35": "35",
    "36": "36",
    "37": "37",
    "38": "38",
    "39": "39",
    "40": "40",
    "41": "41",
    "42": "42",
    "43": "43",
    "44": "44",
    "45": "45",
    "46": "46",
    "47": "47",
    "48": "48",
    "49": "49",
    "50": "50",
    "51": "51",
    "52": "52",
    "53": "53",
    "54": "54",
    "55": "55",
    "56": "56",
    "57": "57",
    "58": "58",
    "59": "59",
    "60": "60",
  }.obs;

  RxString selectedPropertyFloor = "".obs;

  void updateSelectedPropertyFloor(String? value) {
    if (value != null && propertyFloorOptions.containsKey(value)) {
      selectedPropertyFloor.value = value;
    }
  }

  //---ageOfProperty

  RxBool hasResidentialAgeOfPropertyFocus = false.obs;
  RxBool hasResidentialAgeOfPropertyInput = false.obs;
  FocusNode residentialAgeOfPropertyFocusNode = FocusNode();
  TextEditingController residentialAgeOfPropertyController =
      TextEditingController();

  //---availability
  RxMap<String, String> residentialAvailabilityCategories = {
    "Ready to Move": "1",
    "Under Construction": "0",
  }.obs;
  RxString selectedResidentialAvailabilityCategory = "".obs;

  void updateSelectedResidentialAvailabilityCategory(String displayValue) {
    selectedResidentialAvailabilityCategory.value =
        residentialAvailabilityCategories[displayValue] ?? "";
  }

  //---furnishedTypeStatus
  RxMap<String, String> residentialFurnishedTypeStatusCategories = {
    "Full Furnished": "FULL-FURNISHED",
    "Semi-Furnished": "SEMI-FURNISHED",
    "Unfurnished": "UNFURNISHED",
  }.obs;
  RxString selectedResidentialFurnishedTypeStatusCategory = "".obs;

  void updateSelectedResidentialFurnishedTypeStatusCategory(
      String displayValue) {
    selectedResidentialFurnishedTypeStatusCategory.value =
        residentialFurnishedTypeStatusCategories[displayValue] ?? "";
  }

  //---parkingStatus
  RxMap<String, String> residentialParkingStatusCategories = {
    "Available": "1",
    "Not Available": "0",
  }.obs;
  RxString selectedResidentialParkingStatusCategory = "".obs;

  void updateSelectedResidentialParkingStatusCategory(String displayValue) {
    selectedResidentialParkingStatusCategory.value =
        residentialParkingStatusCategories[displayValue] ?? "";
  }

  //---PropertyLength

  RxBool hasResidentialPropertyLengthFocus = false.obs;
  RxBool hasResidentialPropertyLengthInput = false.obs;
  FocusNode residentialPropertyLengthFocusNode = FocusNode();
  TextEditingController residentialPropertyLengthController =
      TextEditingController();

  //---PropertyBreadth

  RxBool hasResidentialPropertyBreadthFocus = false.obs;
  RxBool hasResidentialPropertyBreadthInput = false.obs;
  FocusNode residentialPropertyBreadthFocusNode = FocusNode();
  TextEditingController residentialPropertyBreadthController =
      TextEditingController();

  //---Plot Land Type
  RxMap<String, String> residentialPlotLandTypeCategories = {
    "Gated Community": "GATED COMMUNITY",
    "East Facing Plots": "EAST FACING PLOTS",
    "Commercial Land": "COMMERCIAL LAND",
    "Agriculture Land": "AGGRICULTURE LAND",
  }.obs;

  RxString selectedResidentialPlotLandTypeCategory = "".obs;

  void updateSelectedResidentialPlotLandTypeCategory(String displayValue) {
    selectedResidentialPlotLandTypeCategory.value =
        residentialPlotLandTypeCategories[displayValue] ?? "";
  }

  bool shouldShowField(String fieldName) {
    final subtypeKey = residentialSubTypeCategories.entries
            .firstWhereOrNull((entry) =>
                entry.value == selectedResidentialSubTypeCategory.value)
            ?.key ??
        "";

    final visibilityMap = {
      "Flat / Apartment": [
        "DETAILS",
        "BHK",
        "Bedrooms",
        "Bathrooms",
        "Balconies",
        "CarpetArea",
        "BuildUpArea",
        "TotalFloors",
        "PropertyFloors",
        "Availability",
        "AgeOfProperty",
        "FurnishedStatus",
        "ParkingStatus",
        "Next",
      ],
      "Independent / Villa": [
        "DETAILS",
        "BHK",
        "Bedrooms",
        "Bathrooms",
        "Balconies",
        "CarpetArea",
        "BuildUpArea",
        "TotalFloors",
        "PropertyFloors",
        "Availability",
        "AgeOfProperty",
        "FurnishedStatus",
        "ParkingStatus",
        "Next",
      ],
      "Builder Floors": [
        "DETAILS",
        "BHK",
        "Bedrooms",
        "Bathrooms",
        "Balconies",
        "CarpetArea",
        "BuildUpArea",
        "TotalFloors",
        "PropertyFloors",
        "Availability",
        "FurnishedStatus",
        "ParkingStatus",
        "Next",
      ],
      "Farmhouse": [
        "DETAILS",
        "BHK",
        "Bedrooms",
        "Bathrooms",
        "Balconies",
        "CarpetArea",
        "PlotArea",
        "BuildUpArea",
        "TotalFloors",
        "PropertyFloors",
        "Availability",
        "FurnishedStatus",
        "Next",
      ],
      "Plot / Land": [
        "DETAILS",
        "PlotArea",
        "BuildUpArea",
        "PropertyLength",
        "PropertyBreadth",
        "PlotLandType",
        "Next",
      ],
    };

    return visibilityMap[subtypeKey]?.contains(fieldName) ?? false;
  }

  Map<String, dynamic> buildResidentialPayload() {
    String subtypeKey = residentialSubTypeCategories.entries
        .firstWhere(
          (entry) => entry.value == selectedResidentialSubTypeCategory.value,
          orElse: () => const MapEntry("", ""),
        )
        .key;

    final wantTo = selectedResidentialTypeCategory.value;
    const type = "RESIDENTIAL";
    final typeOptionsId =
        int.tryParse(selectedResidentialSubTypeCategory.value) ?? 0;

    Map<String, dynamic> payload = {
      "want_to": wantTo,
      "type": type,
      "type_options_id": typeOptionsId,
    };

    switch (subtypeKey) {
      case "Flat / Apartment":
      case "Independent / Villa":
        payload.addAll({
          "bhk": int.tryParse(residentialBhkController.text) ?? 0,
          "bedrooms": int.tryParse(residentialBedRoomsController.text) ?? 0,
          "bathrooms": int.tryParse(residentialBathroomsController.text) ?? 0,
          "balconies": int.tryParse(residentialBalconiesController.text) ?? 0,
          "carpet_area":
              int.tryParse(residentialCarpetAreaController.text) ?? 0,
          "build_area":
              int.tryParse(residentialBuildUpAreaController.text) ?? 0,
          "no_of_floors": int.tryParse(
                  totalFloorOptions[selectedTotalFloor.value] ?? "0") ??
              0,
          "property_on_floor": int.tryParse(
                  propertyFloorOptions[selectedPropertyFloor.value] ?? "0") ??
              0,
          "is_under_construction":
              int.tryParse(selectedResidentialAvailabilityCategory.value) ?? 0,
          "furnished_type":
              selectedResidentialFurnishedTypeStatusCategory.value,
          "age_of_property":
              int.tryParse(residentialAgeOfPropertyController.text) ?? 0,
          "parking":
              int.tryParse(selectedResidentialParkingStatusCategory.value) ?? 0,
        });
        break;

      case "Builder Floors":
        payload.addAll({
          "bhk": int.tryParse(residentialBhkController.text) ?? 0,
          "bedrooms": int.tryParse(residentialBedRoomsController.text) ?? 0,
          "bathrooms": int.tryParse(residentialBathroomsController.text) ?? 0,
          "balconies": int.tryParse(residentialBalconiesController.text) ?? 0,
          "carpet_area":
              int.tryParse(residentialCarpetAreaController.text) ?? 0,
          "build_area":
              int.tryParse(residentialBuildUpAreaController.text) ?? 0,
          "no_of_floors": int.tryParse(
                  totalFloorOptions[selectedTotalFloor.value] ?? "0") ??
              0,
          "property_on_floor": int.tryParse(
                  propertyFloorOptions[selectedPropertyFloor.value] ?? "0") ??
              0,
          "is_under_construction":
              int.tryParse(selectedResidentialAvailabilityCategory.value) ?? 0,
          "furnished_type":
              selectedResidentialFurnishedTypeStatusCategory.value,
          "parking":
              int.tryParse(selectedResidentialParkingStatusCategory.value) ?? 0,
        });
        break;

      case "Farmhouse":
        payload.addAll({
          "bhk": int.tryParse(residentialBhkController.text) ?? 0,
          "bedrooms": int.tryParse(residentialBedRoomsController.text) ?? 0,
          "bathrooms": int.tryParse(residentialBathroomsController.text) ?? 0,
          "balconies": int.tryParse(residentialBalconiesController.text) ?? 0,
          "carpet_area":
              int.tryParse(residentialCarpetAreaController.text) ?? 0,
          "build_area":
              int.tryParse(residentialBuildUpAreaController.text) ?? 0,
          "plot_area": int.tryParse(residentialPlotAreaController.text) ?? 0,
          "no_of_floors": int.tryParse(
                  totalFloorOptions[selectedTotalFloor.value] ?? "0") ??
              0,
          "property_on_floor": int.tryParse(
                  propertyFloorOptions[selectedPropertyFloor.value] ?? "0") ??
              0,
          "is_under_construction":
              int.tryParse(selectedResidentialAvailabilityCategory.value) ?? 0,
          "furnished_type":
              selectedResidentialFurnishedTypeStatusCategory.value,
        });
        break;

      case "Plot / Land":
        payload.addAll({
          "plot_area": int.tryParse(residentialPlotAreaController.text) ?? 0,
          "build_area":
              int.tryParse(residentialBuildUpAreaController.text) ?? 0,
          "plot_breadth":
              int.tryParse(residentialPropertyBreadthController.text) ?? 0,
          "plot_length":
              int.tryParse(residentialPropertyLengthController.text) ?? 0,
          "type_of_land": selectedResidentialPlotLandTypeCategory.value
        });
        break;

      default:
        break;
    }

    return payload;
  }

  bool validateResidentialStep1Fields() {
    if (selectedResidentialTypeCategory.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select Property Type ",
      );
      return false;
    }

    String subtypeKey = residentialSubTypeCategories.entries
            .firstWhereOrNull((entry) =>
                entry.value == selectedResidentialSubTypeCategory.value)
            ?.key ??
        "";

    if (subtypeKey.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select Property Subtype",
      );
      return false;
    }

    if (shouldShowField("BHK")) {
      final text = residentialBhkController.text.trim();

      if (text.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter number of BHK",
        );
        return false;
      }

      final value = int.tryParse(text);
      if (value == null) {
        Get.snackbar(
          "Error",
          "BHK must be a numeric value",
        );
        return false;
      }

      if (value <= 0) {
        Get.snackbar(
          "Error",
          "BHK must be greater than zero",
        );
        return false;
      }
      if (value > 126) {
        Get.snackbar(
          "Error",
          "BHK must be between 1 and 126",
        );
        return false;
      }
    }

    if (shouldShowField("Bedrooms")) {
      final text = residentialBedRoomsController.text.trim();

      if (text.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter number of bedrooms",
        );
        return false;
      }

      final value = int.tryParse(text);
      if (value == null) {
        Get.snackbar(
          "Error",
          "Number of bedrooms must be a numeric value",
        );
        return false;
      }

      if (value <= 0) {
        Get.snackbar(
          "Error",
          "Number of bedrooms must be greater than zero",
        );
        return false;
      }

      if (value > 126) {
        Get.snackbar(
          "Error",
          "Number of bedrooms must be between 1 and 126",
        );
        return false;
      }
    }

    if (shouldShowField("Bathrooms")) {
      final text = residentialBathroomsController.text.trim();

      if (text.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter number of bathrooms",
        );
        return false;
      }

      final value = int.tryParse(text);
      if (value == null) {
        Get.snackbar(
          "Error",
          "Number of bathrooms must be a numeric value",
        );
        return false;
      }

      if (value <= 0) {
        Get.snackbar(
          "Error",
          "Number of bathrooms must be greater than zero",
        );
        return false;
      }

      if (value > 126) {
        Get.snackbar(
          "Error",
          "Number of bathrooms must be between 1 and 126",
        );
        return false;
      }
    }

    if (shouldShowField("Balconies")) {
      final text = residentialBalconiesController.text.trim();

      if (text.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter number of balconies",
        );
        return false;
      }

      final value = int.tryParse(text);
      if (value == null) {
        Get.snackbar(
          "Error",
          "Number of balconies must be a numeric value",
        );
        return false;
      }

      if (value < 0 || value > 126) {
        Get.snackbar(
          "Error",
          "Number of balconies must be between 0 and 127",
        );
        return false;
      }
    }

    if (shouldShowField("CarpetArea") &&
        (residentialCarpetAreaController.text.isEmpty ||
            double.parse(residentialCarpetAreaController.text) <= 0)) {
      Get.snackbar(
        "Error",
        "Please enter carpet area",
      );
      return false;
    }
    if (shouldShowField("PlotArea") &&
        (residentialPlotAreaController.text.isEmpty ||
            double.parse(residentialPlotAreaController.text) <= 0)) {
      Get.snackbar(
        "Error",
        "Please enter plot area",
      );
      return false;
    }

    if (shouldShowField("BuildUpArea") &&
        (residentialBuildUpAreaController.text.isEmpty ||
            double.parse(residentialBuildUpAreaController.text) <= 0)) {
      Get.snackbar(
        "Error",
        "Please enter buildup area",
      );
      return false;
    }

    if (shouldShowField("TotalFloors") && selectedTotalFloor.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select total floors",
      );
      return false;
    }

    if (shouldShowField("PropertyFloors") &&
        selectedPropertyFloor.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select property on floor",
      );
      return false;
    }

    if (shouldShowField("AgeOfProperty")) {
      final text = residentialAgeOfPropertyController.text.trim();

      if (text.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter age of property",
        );
        return false;
      }

      final value = int.tryParse(text);
      if (value == null) {
        Get.snackbar(
          "Error",
          "Age of property must be a numeric value",
        );
        return false;
      }

      if (value < 0 || value > 254) {
        Get.snackbar(
          "Error",
          "Age of property must be between 0 and 127",
        );
        return false;
      }
    }

    if (shouldShowField("FurnishedStatus") &&
        selectedResidentialFurnishedTypeStatusCategory.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select furnished status",
      );
      return false;
    }

    if (shouldShowField("ParkingStatus") &&
        selectedResidentialParkingStatusCategory.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select parking status",
      );
      return false;
    }

    if (shouldShowField("PropertyLength") &&
        (residentialPropertyLengthController.text.isEmpty ||
            double.parse(residentialPropertyLengthController.text) <= 0)) {
      Get.snackbar(
        "Error",
        "Please enter property length",
      );
      return false;
    }

    if (shouldShowField("PropertyBreadth") &&
        (residentialPropertyBreadthController.text.isEmpty ||
            double.parse(residentialPropertyBreadthController.text) <= 0)) {
      Get.snackbar(
        "Error",
        "Please enter property breadth",
      );
      return false;
    }

    return true;
  }

  RxBool isLoading = false.obs;
  bool isResidentialDetailSubmitted = false;
  RxInt residentialId = 0.obs;

  Future<bool> submitResidentialDetailsStep1() async {
    if (!validateResidentialStep1Fields()) return false;
    // isResidentialDetailSubmitted = false;

    isLoading(true);
    try {
      final response = await residentialPostPropertyRepository
          .submitStep1ResidentialDetails();
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
        return false;

      }

      if (response["success"] == true) {
        //["data"]?["status"] == 200) {
        isResidentialDetailSubmitted = true;

        int? residentialId = response["data"]?["data"]?["id"] as int?; //
        if (residentialId != null && residentialId != 0) {
          storage.write("res_id", residentialId);
          AppLogger.log("Residential ID Stored: $residentialId");
        }

        // saveResidentialCurrentStep(2);

        String msg =
            response["data"]?["message"] ?? "Residential details submitted";
        Get.snackbar("Success", msg, backgroundColor: AppColor.green);
        return true;
      } else {
        // isResidentialDetailSubmitted = false;
        String msg = response["data"]?["message"] ?? "Something went wrong!";
        Get.snackbar(
          "Error",
          msg,
        );
        return false;
      }
    } catch (e) {
      isLoading(false);
      //isResidentialDetailSubmitted = false;
      Get.snackbar(
        "Error",
        "API Error: $e",
      );
      return false;
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
    );
  }

  void hideFullscreenLoader() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }






  /////////////////////// Residential section step 2--------------------------------------------------------------------------

  List<City> residentialCityOptions = [];
  City? selectedResidentialCity;
  TextEditingController citySearchController = TextEditingController();

  Future<void> loadCityList() async {
    final cityListController = Get.find<CityList>();
    residentialCityOptions.clear();
    residentialCityOptions.addAll(cityListController.cityList);
    Get.log(
        "Residential City List Loaded from Shared Controller: ${residentialCityOptions.length} cities");
  }

  // Future<void> loadCityList() async {
  //   try{
  //     final response = await pgPostPropertyRepository.fetchCityList();
  //     if (response["success"] == true && response["data"] != null) {
  //       List<dynamic> cityData = response["data"];
  //       residentialCityOptions.clear();
  //       residentialCityOptions.addAll((cityData.map((json) => City.fromJson(json)).toList()));
  //     } else {
  //       Get.snackbar("Error", response["message"] ?? "Unable to fetch cities");
  //     }
  //   } catch(e){
  //     Get.snackbar("Error", "Failed to load city list");
  //   }
  // }

  void updateSelectedResidentialCity(String? cityName) {
    final selectedCity = residentialCityOptions
        .firstWhereOrNull((city) => city.name == cityName);
    if (selectedCity != null) {
      selectedResidentialCity = selectedCity;
      update();
    }
  }

  //////////////////-----Area
  RxBool hasResidentialAreaFocus = false.obs;
  RxBool hasResidentialAreaInput = false.obs;
  FocusNode residentialAreaFocusNode = FocusNode();
  TextEditingController residentialAreaController = TextEditingController();

  //////////////////-----SubLocality
  RxBool hasResidentialSubLocalityFocus = false.obs;
  RxBool hasResidentialSubLocalityInput = false.obs;
  FocusNode residentialSubLocalityFocusNode = FocusNode();
  TextEditingController residentialSubLocalityController =
      TextEditingController();

  //////////////////-----HouseNo
  RxBool hasResidentialHouseNoFocus = false.obs;
  RxBool hasResidentialHouseNoInput = false.obs;
  FocusNode residentialHouseNoFocusNode = FocusNode();
  TextEditingController residentialHouseNoController = TextEditingController();

  //////////////////-----ZipCode
  RxBool hasResidentialZipCodeFocus = false.obs;
  RxBool hasResidentialZipCodeInput = false.obs;
  FocusNode residentialZipCodeFocusNode = FocusNode();
  TextEditingController residentialZipCodeController = TextEditingController();

  RxBool isLoadingStep2 = false.obs;
  bool isResidentialDetailSubmittedStep2 = false;

  Future<void> submitResidentialDetailsStep2() async {
    isResidentialDetailSubmittedStep2 = false;

    if (selectedResidentialCity == null) {
      Get.snackbar(
        "Error",
        "Please select a City",
      );
      return;
    }
    if (residentialAreaController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter an Area",
      );
      return;
    }
    if (residentialSubLocalityController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a Sub Locality",
      );
      return;
    }
    if (residentialHouseNoController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a House No.",
      );
      return;
    }
    if (residentialZipCodeController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a Pin Code",
      );
      return;
    }

    if (residentialZipCodeController.text.length != 6) {
      Get.snackbar(
        "Error",
        "The Pin Field mus be 6 Character",
      );
      return;
    }
    isLoadingStep2(true);
    final response =
        await residentialPostPropertyRepository.submitStep2ResidentialDetails(
      city: selectedResidentialCity?.name ?? '',
      area: residentialAreaController.text,
      subLocality: residentialSubLocalityController.text,
      houseNo: residentialHouseNoController.text,
      pin: residentialZipCodeController.text,
    );

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
    AppLogger.log("🔍 Complete API Response --> $response");
    if (response["success"] == true) {
      //["data"]?["status"] == 200) {
      isResidentialDetailSubmittedStep2 = true;
      String successMessage = response["data"]?["message"] ?? "";
      saveResidentialCurrentStep(3);
      AppLogger.log("success message -->>> $successMessage");
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isResidentialDetailSubmittedStep2 = false;
      String errorMessage =
          response["data"]?["message"] ?? "Something went wrong!";
      Get.snackbar(
        "Error",
        errorMessage,
      );
    }
  }

  /////////////////////// Residential section step 3--------------------------------------------------------------------------
  //////////////////-----Area
  RxBool hasResidentialRentAmountFocus = false.obs;
  RxBool hasResidentialRentAmountInput = false.obs;
  FocusNode residentialRentAmountFocusNode = FocusNode();
  TextEditingController residentialRentAmountController =
      TextEditingController();

  //////////////////-----Pricing Option
  int boolToInt(bool value) => value ? 1 : 0;

  RxBool allInclusivePrice = false.obs;
  RxBool taxAndGovtChargesExcluded = false.obs;
  RxBool priceNegotiable = false.obs;

  //////////////////-----Ownership

  //---Type
  RxMap<String, String> residentialOwnerShipCategories = {
    "Freehold": "FREEHOLD",
    "Leasehold": "LEASHOLD",
    "Co-operative Society": "CO-OPERATIVE SOCIETY",
    "Power of Attorney": "POWER OF ATTORNEY",
  }.obs;

  RxString selectedResidentialOwnerShipCategory = "".obs;

  void updateSelectedResidentialOwnerShipCategory(String displayValue) {
    selectedResidentialOwnerShipCategory.value =
        residentialOwnerShipCategories[displayValue] ?? "";
  }

  //////////////////-----Describe Property
  RxBool hasResidentialDescribePropertyFocus = false.obs;
  RxBool hasResidentialDescribePropertyInput = false.obs;
  FocusNode residentialDescribePropertyFocusNode = FocusNode();
  TextEditingController residentialDescribePropertyController =
      TextEditingController();

  RxBool isLoadingStep3 = false.obs;
  bool isResidentialDetailSubmittedStep3 = false;

  Future<void> submitResidentialDetailsStep3() async {
    isResidentialDetailSubmittedStep3 = false;

    if (residentialRentAmountController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter Rent Amount",
      );
      return;
    }
    if (selectedResidentialOwnerShipCategory.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select Owner Ship",
      );
      return;
    }
    if (residentialDescribePropertyController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please describe the property",
      );
      return;
    }

    isLoadingStep3(true);
    final response =
        await residentialPostPropertyRepository.submitStep3ResidentialDetails(
            rentAmount: int.parse(residentialRentAmountController.text),
            uniquePropertyDescription:
                residentialDescribePropertyController.text,
            allInclusivePrice: boolToInt(allInclusivePrice.value),
            taxAndGovtChargesExcluded:
                boolToInt(taxAndGovtChargesExcluded.value),
            priceNegotiable: boolToInt(priceNegotiable.value),
            ownerShip:
                selectedResidentialOwnerShipCategory.value.toUpperCase());

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
    if (response["data"]?["status"] == 200) {
      isResidentialDetailSubmittedStep3 = true;
      saveResidentialCurrentStep(4);
      int? residentialPropertyId = response["data"]?["data"]?["property_id"];
      if (residentialPropertyId != null) {
        storage.write("residential_property_id", residentialPropertyId);
        AppLogger.log(
            "Stored Residential property id -->>> $residentialPropertyId");
      }
      String successMessage = response["data"]?["message"] ??
          "PG Step 3 details submitted successfully!";
      AppLogger.log("Success message -->>> $successMessage");
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isResidentialDetailSubmittedStep3 = false;
      String errorMessage =
          response["data"]?["message"] ?? "Something went wrong!";
      Get.snackbar(
        "Error",
        errorMessage,
      );
    }
  }

  /////////////////////// Residential section step 4--------------------------------------------------------------------------

  RxBool isLoadingStep4 = false.obs;
  bool isResidentialDetailSubmittedStep4 = false;

  Future<void> submitResidentialDetailsStep4Images(List<File> images) async {
    isResidentialDetailSubmittedStep4 = false;
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

    int? residentialPropertyId = storage.read("residential_property_id");
    AppLogger.log(
        "📦 Read residential_property_id from storage: $residentialPropertyId");
    if (residentialPropertyId == null || residentialPropertyId == 0) {
      AppLogger.log("❌ Invalid or missing property ID.");
      isLoadingStep4(false);
      Get.snackbar(
        "Error",
        "Invalid property ID. Please try again.",
      );
      return;
    }
    AppLogger.log(
        "🚀 Initiating Residential image upload for Property ID: $residentialPropertyId with ${images.length} images.");
    final response =
        await residentialPostPropertyRepository.submitStep4ResidentialImages(
      residentialPropertyId: 0,
      imageFiles: images,
    );

    AppLogger.log("📥 Received response from image upload: $response");

    isLoadingStep4(false);

    if (response["success"] == true) {
      isResidentialDetailSubmittedStep4 = true;
      storage.remove("res_id");
      storage.remove("residential_property_id");
      AppLogger.log(
          " Cleared res_id and residential_property_id from GetStorage");
      String successMessage =
          response["data"]?["message"] ?? "Images uploaded successfully!";
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);

      residentialResetStepProgress();
      Get.offNamed(AppRoutes.bottomBarView);
    } else {
      isResidentialDetailSubmittedStep4 = true;
      String errorMessage =
          response["message"] ?? "Something went wrong during image upload.";
      Get.snackbar(
        "Error",
        errorMessage,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadCityList();
    residentialRestoreLastStep();
    Future.delayed(const Duration(milliseconds: 500), () {
      residentialRedirectToSavedStep();
    });

    residentialBhkController.addListener(() {
      hasResidentialBhkInput.value = residentialBhkController.text.isNotEmpty;
    });

    residentialBhkFocusNode.addListener(() {
      hasResidentialBhkFocus.value = residentialBhkFocusNode.hasFocus;
    });
//-----
    residentialBedRoomsController.addListener(() {
      hasResidentialBedRoomsInput.value =
          residentialBedRoomsController.text.isNotEmpty;
    });

    residentialBedRoomsFocusNode.addListener(() {
      hasResidentialBedRoomsFocus.value = residentialBedRoomsFocusNode.hasFocus;
    });
//-----
    residentialBathroomsController.addListener(() {
      hasResidentialBathroomsInput.value =
          residentialBathroomsController.text.isNotEmpty;
    });

    residentialBathroomsFocusNode.addListener(() {
      hasResidentialBathroomsFocus.value =
          residentialBathroomsFocusNode.hasFocus;
    });

    //-----
    residentialBalconiesController.addListener(() {
      hasResidentialBalconiesInput.value =
          residentialBalconiesController.text.isNotEmpty;
    });

    residentialBalconiesFocusNode.addListener(() {
      hasResidentialBalconiesFocus.value =
          residentialBalconiesFocusNode.hasFocus;
    });

    //-----
    residentialCarpetAreaController.addListener(() {
      hasResidentialCarpetAreaInput.value =
          residentialCarpetAreaController.text.isNotEmpty;
    });

    residentialCarpetAreaFocusNode.addListener(() {
      hasResidentialCarpetAreaFocus.value =
          residentialCarpetAreaFocusNode.hasFocus;
    });

    //-----
    residentialPlotAreaController.addListener(() {
      hasResidentialPlotAreaInput.value =
          residentialPlotAreaController.text.isNotEmpty;
    });

    residentialPlotAreaFocusNode.addListener(() {
      hasResidentialPlotAreaFocus.value = residentialPlotAreaFocusNode.hasFocus;
    });

    //-----
    residentialBuildUpAreaController.addListener(() {
      hasResidentialBuildUpAreaInput.value =
          residentialBuildUpAreaController.text.isNotEmpty;
    });

    residentialBuildUpAreaFocusNode.addListener(() {
      hasResidentialBuildUpAreaFocus.value =
          residentialBuildUpAreaFocusNode.hasFocus;
    });

    //-----
    residentialAgeOfPropertyController.addListener(() {
      hasResidentialAgeOfPropertyInput.value =
          residentialAgeOfPropertyController.text.isNotEmpty;
    });

    residentialAgeOfPropertyFocusNode.addListener(() {
      hasResidentialAgeOfPropertyFocus.value =
          residentialAgeOfPropertyFocusNode.hasFocus;
    });

    //-----
    residentialPropertyLengthController.addListener(() {
      hasResidentialPropertyLengthInput.value =
          residentialPropertyLengthController.text.isNotEmpty;
    });

    residentialPropertyLengthFocusNode.addListener(() {
      hasResidentialPropertyLengthFocus.value =
          residentialPropertyLengthFocusNode.hasFocus;
    });

    //-----
    residentialPropertyBreadthController.addListener(() {
      hasResidentialPropertyLengthInput.value =
          residentialPropertyLengthController.text.isNotEmpty;
    });

    residentialPropertyBreadthFocusNode.addListener(() {
      hasResidentialPropertyBreadthFocus.value =
          residentialPropertyBreadthFocusNode.hasFocus;
    });

    //////////////////////////step2

    residentialAreaController.addListener(() {
      hasResidentialAreaInput.value = residentialAreaController.text.isNotEmpty;
    });

    residentialAreaFocusNode.addListener(() {
      hasResidentialAreaFocus.value = residentialAreaFocusNode.hasFocus;
    });

    //-----
    residentialSubLocalityController.addListener(() {
      hasResidentialSubLocalityInput.value =
          residentialSubLocalityController.text.isNotEmpty;
    });

    residentialSubLocalityFocusNode.addListener(() {
      hasResidentialSubLocalityFocus.value =
          residentialSubLocalityFocusNode.hasFocus;
    });

    //-----
    residentialHouseNoController.addListener(() {
      hasResidentialHouseNoInput.value =
          residentialHouseNoController.text.isNotEmpty;
    });

    residentialHouseNoFocusNode.addListener(() {
      hasResidentialHouseNoFocus.value = residentialHouseNoFocusNode.hasFocus;
    });

    //-----
    residentialZipCodeController.addListener(() {
      hasResidentialZipCodeInput.value =
          residentialZipCodeController.text.isNotEmpty;
    });

    residentialZipCodeFocusNode.addListener(() {
      hasResidentialZipCodeFocus.value = residentialZipCodeFocusNode.hasFocus;
    });

    //////////////////////////step3

    residentialRentAmountController.addListener(() {
      hasResidentialRentAmountInput.value =
          residentialRentAmountController.text.isNotEmpty;
    });

    residentialRentAmountFocusNode.addListener(() {
      hasResidentialRentAmountFocus.value =
          residentialRentAmountFocusNode.hasFocus;
    });

    //-----
    residentialDescribePropertyController.addListener(() {
      hasResidentialDescribePropertyInput.value =
          residentialDescribePropertyController.text.isNotEmpty;
    });

    residentialDescribePropertyFocusNode.addListener(() {
      hasResidentialDescribePropertyFocus.value =
          residentialDescribePropertyFocusNode.hasFocus;
    });
  }

  @override
  void onClose() {
    super.onClose();
    // residentialBhkFocusNode.removeListener(() {});
    // residentialBhkController.removeListener(() {});
    residentialBhkFocusNode.dispose();
    residentialBhkController.dispose();

    // residentialBedRoomsFocusNode.removeListener(() {});
    // residentialBedRoomsController.removeListener(() {});
    residentialBedRoomsFocusNode.dispose();
    residentialBedRoomsController.dispose();

    // residentialBathroomsFocusNode.removeListener(() {});
    // residentialBathroomsController.removeListener(() {});
    residentialBathroomsFocusNode.dispose();
    residentialBathroomsController.dispose();

    // residentialBalconiesFocusNode.removeListener(() {});
    // residentialBalconiesController.removeListener(() {});
    residentialBalconiesFocusNode.dispose();
    residentialBalconiesController.dispose();

    // residentialCarpetAreaFocusNode.removeListener(() {});
    // residentialCarpetAreaController.removeListener(() {});
    residentialCarpetAreaFocusNode.dispose();
    residentialCarpetAreaController.dispose();

    // residentialPlotAreaFocusNode.removeListener(() {});
    // residentialPlotAreaController.removeListener(() {});
    residentialPlotAreaFocusNode.dispose();
    residentialPlotAreaController.dispose();

    // residentialBuildUpAreaFocusNode.removeListener(() {});
    // residentialBuildUpAreaController.removeListener(() {});
    residentialBuildUpAreaFocusNode.dispose();
    residentialBuildUpAreaController.dispose();

    // residentialAgeOfPropertyFocusNode.removeListener(() {});
    // residentialAgeOfPropertyController.removeListener(() {});
    residentialAgeOfPropertyFocusNode.dispose();
    residentialAgeOfPropertyController.dispose();

    // residentialPropertyLengthFocusNode.removeListener(() {});
    // residentialPropertyLengthController.removeListener(() {});
    residentialPropertyLengthFocusNode.dispose();
    residentialPropertyLengthController.dispose();

    // residentialPropertyBreadthFocusNode.removeListener(() {});
    // residentialPropertyBreadthController.removeListener(() {});
    residentialPropertyBreadthFocusNode.dispose();
    residentialPropertyBreadthController.dispose();

    citySearchController.dispose();

    /////////////////////step2///////

    // residentialAreaFocusNode.removeListener(() {});
    // residentialAreaController.removeListener(() {});
    residentialAreaFocusNode.dispose();
    residentialAreaController.dispose();

    // residentialSubLocalityFocusNode.removeListener(() {});
    // residentialSubLocalityController.removeListener(() {});
    residentialSubLocalityFocusNode.dispose();
    residentialSubLocalityController.dispose();

    // residentialHouseNoFocusNode.removeListener(() {});
    // residentialHouseNoController.removeListener(() {});
    residentialHouseNoFocusNode.dispose();
    residentialHouseNoController.dispose();

    // residentialZipCodeFocusNode.removeListener(() {});
    // residentialZipCodeController.removeListener(() {});
    residentialZipCodeFocusNode.dispose();
    residentialZipCodeController.dispose();

    /////////////////////step3///////

    // residentialRentAmountFocusNode.removeListener(() {});
    // residentialRentAmountController.removeListener(() {});
    residentialRentAmountFocusNode.dispose();
    residentialRentAmountController.dispose();

    // residentialDescribePropertyFocusNode.removeListener(() {});
    // residentialDescribePropertyController.removeListener(() {});
    residentialDescribePropertyFocusNode.dispose();
    residentialDescribePropertyController.dispose();
  }
}
