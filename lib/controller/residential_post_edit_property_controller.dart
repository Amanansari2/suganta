import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../api_service/print_logger.dart';
import '../configs/app_color.dart';
import '../model/city_model.dart';
import '../model/post_property_model.dart';
import '../repository/residental_post_edit_property_repo.dart';
import 'fetch_city_list_controller.dart';

class ResidentialPostEditPropertyController extends GetxController {
  final ResidentialPostEditPropertyRepository
      residentialPostEditPropertyRepository =
      Get.find<ResidentialPostEditPropertyRepository>();

  RxInt residentialCurrentStep = 1.obs;

  int? propertyLogId;
  int? propertyImageId;

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

  bool validateResidentialStep1Fields() {
    if (selectedResidentialTypeCategory.value.isEmpty) {
      Get.snackbar("Error", "Please select Property Type ",
          backgroundColor: AppColor.red);
      return false;
    }

    String subtypeKey = residentialSubTypeCategories.entries
            .firstWhereOrNull((entry) =>
                entry.value == selectedResidentialSubTypeCategory.value)
            ?.key ??
        "";

    if (subtypeKey.isEmpty) {
      Get.snackbar("Error", "Please select Property Subtype",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("BHK")) {
      final text = residentialBhkController.text.trim();

      if (text.isEmpty) {
        Get.snackbar("Error", "Please enter number of BHK",
            backgroundColor: AppColor.red);
        return false;
      }

      final value = int.tryParse(text);
      if (value == null) {
        Get.snackbar("Error", "BHK must be a numeric value",
            backgroundColor: AppColor.red);
        return false;
      }

      if (value < 0 || value > 126) {
        Get.snackbar("Error", "BHK must be between 0 and 127",
            backgroundColor: AppColor.red);
        return false;
      }
    }

    if (shouldShowField("Bedrooms")) {
      final text = residentialBedRoomsController.text.trim();

      if (text.isEmpty) {
        Get.snackbar("Error", "Please enter number of bedrooms",
            backgroundColor: AppColor.red);
        return false;
      }

      final value = int.tryParse(text);
      if (value == null) {
        Get.snackbar("Error", "Number of bedrooms must be a numeric value",
            backgroundColor: AppColor.red);
        return false;
      }

      if (value < 0 || value > 126) {
        Get.snackbar("Error", "Number of bedrooms must be between 0 and 127",
            backgroundColor: AppColor.red);
        return false;
      }
    }

    if (shouldShowField("Bathrooms")) {
      final text = residentialBathroomsController.text.trim();

      if (text.isEmpty) {
        Get.snackbar("Error", "Please enter number of bathrooms",
            backgroundColor: AppColor.red);
        return false;
      }

      final value = int.tryParse(text);
      if (value == null) {
        Get.snackbar("Error", "Number of bathrooms must be a numeric value",
            backgroundColor: AppColor.red);
        return false;
      }

      if (value < 0 || value > 126) {
        Get.snackbar("Error", "Number of bathrooms must be between 0 and 127",
            backgroundColor: AppColor.red);
        return false;
      }
    }

    if (shouldShowField("Balconies")) {
      final text = residentialBalconiesController.text.trim();

      if (text.isEmpty) {
        Get.snackbar("Error", "Please enter number of balconies",
            backgroundColor: AppColor.red);
        return false;
      }

      final value = int.tryParse(text);
      if (value == null) {
        Get.snackbar("Error", "Number of balconies must be a numeric value",
            backgroundColor: AppColor.red);
        return false;
      }

      if (value < 0 || value > 126) {
        Get.snackbar("Error", "Number of balconies must be between 0 and 127",
            backgroundColor: AppColor.red);
        return false;
      }
    }

    if (shouldShowField("CarpetArea") &&
        residentialCarpetAreaController.text.isEmpty) {
      Get.snackbar("Error", "Please enter carpet area",
          backgroundColor: AppColor.red);
      return false;
    }
    if (shouldShowField("PlotArea") &&
        residentialPlotAreaController.text.isEmpty) {
      Get.snackbar("Error", "Please enter plot area",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("BuildUpArea") &&
        residentialBuildUpAreaController.text.isEmpty) {
      Get.snackbar("Error", "Please enter buildup area",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("TotalFloors") && selectedTotalFloor.value.isEmpty) {
      Get.snackbar("Error", "Please select total floors",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("PropertyFloors") &&
        selectedPropertyFloor.value.isEmpty) {
      Get.snackbar("Error", "Please select property on floor",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("AgeOfProperty")) {
      final text = residentialAgeOfPropertyController.text.trim();

      if (text.isEmpty) {
        Get.snackbar("Error", "Please enter age of property",
            backgroundColor: AppColor.red);
        return false;
      }

      final value = int.tryParse(text);
      if (value == null) {
        Get.snackbar("Error", "Age of property must be a numeric value",
            backgroundColor: AppColor.red);
        return false;
      }

      if (value < 0 || value > 254) {
        Get.snackbar("Error", "Age of property must be between 0 and 127",
            backgroundColor: AppColor.red);
        return false;
      }
    }

    if (shouldShowField("FurnishedStatus") &&
        selectedResidentialFurnishedTypeStatusCategory.value.isEmpty) {
      Get.snackbar("Error", "Please select furnished status",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("ParkingStatus") &&
        selectedResidentialParkingStatusCategory.value.isEmpty) {
      Get.snackbar("Error", "Please select parking status",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("PropertyLength") &&
        residentialPropertyLengthController.text.isEmpty) {
      Get.snackbar("Error", "Please enter property length",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("PropertyBreadth") &&
        residentialPropertyBreadthController.text.isEmpty) {
      Get.snackbar("Error", "Please enter property breadth",
          backgroundColor: AppColor.red);
      return false;
    }

    return true;
  }

  String cleanDecimal(num? value) {
    if (value == null) return '';
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }

  void setEditResidentialData(PostPropertyData property) {
    final feature = property.feature;
    final address = property.address;
    if (feature == null || address == null) return;

    // Type & Subtype
    selectedResidentialTypeCategory.value = property.wantTo;
    selectedResidentialSubTypeCategory.value =
        property.typeOptionsId?.toString() ?? "";

    // BHK, Bedrooms, Bathrooms, Balconies
    residentialBhkController.text = feature.bhk?.toString() ?? '';
    residentialBedRoomsController.text = feature.bedrooms.toString();
    residentialBathroomsController.text = feature.bathrooms.toString();
    residentialBalconiesController.text = feature.balconies.toString();

    // Areas
    residentialCarpetAreaController.text = cleanDecimal(feature.carpetArea);
    residentialPlotAreaController.text = cleanDecimal(feature.plotArea);
    residentialBuildUpAreaController.text = cleanDecimal(feature.buildArea);
    Get.log("📅 Build Up Area: ${feature.buildArea}");

    // Floors
    selectedTotalFloor.value = totalFloorOptions.entries
            .firstWhereOrNull(
                (entry) => entry.value == feature.noOfFloors.toString())
            ?.key ??
        "";
    selectedPropertyFloor.value = propertyFloorOptions.entries
            .firstWhereOrNull(
                (entry) => entry.value == feature.propertyOnFloor.toString())
            ?.key ??
        "";

    // Age of Property
    residentialAgeOfPropertyController.text = feature.ageOfProperty.toString();
    Get.log("📅 Age of Property: ${feature.ageOfProperty}");

    // Availability
    selectedResidentialAvailabilityCategory.value =
        feature.isUnderConstruction == 0 ? "0" : "1";

    // Furnishing
    selectedResidentialFurnishedTypeStatusCategory.value =
        feature.furnishedType ?? '';

    // Parking
    selectedResidentialParkingStatusCategory.value =
        feature.parking == 1 ? "1" : "0";

    // Plot Details
    residentialPropertyLengthController.text = cleanDecimal(feature.plotLength);
    residentialPropertyBreadthController.text =
        cleanDecimal(feature.plotBreadth);
    selectedResidentialPlotLandTypeCategory.value = feature.typeOfLand ?? '';

    propertyLogId = property.propertyLogId;
    propertyImageId = property.id;

    // 📍 Step 2 Address
    selectedResidentialCity = residentialCityOptions.firstWhereOrNull(
      (city) => city.name == address.city,
    );

    residentialAreaController.text = address.area;
    residentialSubLocalityController.text = address.subLocality ?? '';
    residentialHouseNoController.text = address.houseNo!;
    residentialZipCodeController.text = address.pin.toString();

    // Step 3
    residentialRentAmountController.text = feature.rentAmount.toString();
    selectedResidentialOwnerShipCategory.value = feature.ownership ?? '';
    allInclusivePrice.value = feature.isAllInclusionPrice == 1;
    taxAndGovtChargesExcluded.value = feature.isTaxAndChargesExcluded == 1;
    priceNegotiable.value = feature.isNegotiable == 1;
    residentialDescribePropertyController.text = property.description ?? "";

    propertyLogId = property.propertyLogId;
    propertyImageId = property.id;

    Get.log(
        "Residential Property Log Id--->>>$propertyLogId , Image ID -->>>> $propertyImageId ");
    Get.log("📋 Residential Edit Data Set Complete");
  }

  Map<String, dynamic> buildEditResidentialPayload() {
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

  RxBool isLoading = false.obs;
  bool isResidentialDetailSubmitted = false;

  Future<bool> submitEditResidentialDetailsStep1() async {
    if (!validateResidentialStep1Fields()) return false;

    isLoading(true);

    try {
      final response = await residentialPostEditPropertyRepository
          .submitEditStep1ResidentialDetails();
      isLoading(false);
      if (response["success"] == true) {
        isResidentialDetailSubmitted = true;

        String msg =
            response["data"]?["message"] ?? "Residential details submitted";
        Get.snackbar("Success", msg, backgroundColor: AppColor.green);
        return true;
      } else {
        String msg = response["data"]?["message"] ?? "Something went wrong!";
        Get.snackbar("Error", msg, backgroundColor: AppColor.red);
        return false;
      }
    } catch (e) {
      isLoading(false);

      Get.snackbar("Error", "API Error: $e", backgroundColor: AppColor.red);
      return false;
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
      Get.snackbar("Error", "Please select a City",
          backgroundColor: AppColor.red);
      return;
    }
    if (residentialAreaController.text.isEmpty) {
      Get.snackbar("Error", "Please enter an Area",
          backgroundColor: AppColor.red);
      return;
    }
    if (residentialSubLocalityController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a Sub Locality",
          backgroundColor: AppColor.red);
      return;
    }
    if (residentialHouseNoController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a House No.",
          backgroundColor: AppColor.red);
      return;
    }
    if (residentialZipCodeController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a Pin Code",
          backgroundColor: AppColor.red);
      return;
    }

    if (residentialZipCodeController.text.length != 6) {
      Get.snackbar("Error", "The Pin Field mus be 6 Character",
          backgroundColor: AppColor.red);
      return;
    }
    isLoadingStep2(true);
    final response = await residentialPostEditPropertyRepository
        .submitEditStep2ResidentialDetails(
      propertyLogId: propertyLogId!,
      city: selectedResidentialCity?.name ?? '',
      area: residentialAreaController.text,
      subLocality: residentialSubLocalityController.text,
      houseNo: residentialHouseNoController.text,
      pin: residentialZipCodeController.text,
    );
    isLoadingStep2(false);

    if (response["success"] == true) {
      isResidentialDetailSubmittedStep2 = true;
      String successMessage = response["data"]?["message"] ?? "";
      AppLogger.log("success message -->>> $successMessage");
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isResidentialDetailSubmittedStep2 = false;
      String errorMessage =
          response["data"]?["message"] ?? "Something went wrong!";
      Get.snackbar("Error", errorMessage, backgroundColor: AppColor.red);
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

  Future<void> submitEditResidentialDetailsStep3() async {
    isResidentialDetailSubmittedStep3 = false;

    if (residentialRentAmountController.text.isEmpty) {
      Get.snackbar("Error", "Please enter Rent Amount",
          backgroundColor: AppColor.red);
      return;
    }
    if (selectedResidentialOwnerShipCategory.value.isEmpty) {
      Get.snackbar("Error", "Please select Owner Ship",
          backgroundColor: AppColor.red);
      return;
    }
    if (residentialDescribePropertyController.text.isEmpty) {
      Get.snackbar("Error", "Please describe the property",
          backgroundColor: AppColor.red);
      return;
    }

    isLoadingStep3(true);
    final response = await residentialPostEditPropertyRepository
        .submitEditStep3ResidentialDetails(
            propertyLogId: propertyLogId!,
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
    if (response["data"]?["status"] == 200) {
      isResidentialDetailSubmittedStep3 = true;

      String successMessage = response["data"]?["message"] ??
          "PG Step 3 details submitted successfully!";
      AppLogger.log("Success message -->>> $successMessage");
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isResidentialDetailSubmittedStep3 = false;
      String errorMessage =
          response["data"]?["message"] ?? "Something went wrong!";
      Get.snackbar("Error", errorMessage, backgroundColor: AppColor.red);
    }
  }

  /////////////////////// Residential section step 4--------------------------------------------------------------------------

  RxBool isLoadingStep4 = false.obs;
  bool isResidentialDetailSubmittedStep4 = false;

  Future<void> submitEditStep4UploadImagesResidentialDetails(
      List<File> images) async {
    isResidentialDetailSubmittedStep4 = false;
    isLoadingStep4(true);

    if (images.isEmpty) {
      isLoadingStep4(false);
      Get.snackbar("Error", "Please select at least one image to upload.",
          backgroundColor: AppColor.red);
      return;
    }
    final response =
        await residentialPostEditPropertyRepository.uploadEditStep4Images(
      imageFiles: images,
      propertyImageId: propertyImageId!,
    );
    isLoadingStep4(false);
    if (response["success"] == true) {
      isResidentialDetailSubmittedStep4 = true;
      String successMessage =
          response["data"]?["message"] ?? "Images uploaded successfully!";
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isResidentialDetailSubmittedStep4 = true;
      String errorMessage =
          response["message"] ?? "Something went wrong during image upload.";
      Get.snackbar("Error", errorMessage, backgroundColor: AppColor.red);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadCityList();

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

    residentialBhkFocusNode.dispose();
    residentialBhkController.dispose();

    residentialBedRoomsFocusNode.dispose();
    residentialBedRoomsController.dispose();

    residentialBathroomsFocusNode.dispose();
    residentialBathroomsController.dispose();

    residentialBalconiesFocusNode.dispose();
    residentialBalconiesController.dispose();

    residentialCarpetAreaFocusNode.dispose();
    residentialCarpetAreaController.dispose();

    residentialPlotAreaFocusNode.dispose();
    residentialPlotAreaController.dispose();

    residentialBuildUpAreaFocusNode.dispose();
    residentialBuildUpAreaController.dispose();

    residentialAgeOfPropertyFocusNode.dispose();
    residentialAgeOfPropertyController.dispose();

    residentialPropertyLengthFocusNode.dispose();
    residentialPropertyLengthController.dispose();

    residentialPropertyBreadthFocusNode.dispose();
    residentialPropertyBreadthController.dispose();

    citySearchController.dispose();

    /////////////////////step2///////

    residentialAreaFocusNode.dispose();
    residentialAreaController.dispose();

    residentialSubLocalityFocusNode.dispose();
    residentialSubLocalityController.dispose();

    residentialHouseNoFocusNode.dispose();
    residentialHouseNoController.dispose();

    residentialZipCodeFocusNode.dispose();
    residentialZipCodeController.dispose();

    /////////////////////step3///////

    residentialRentAmountFocusNode.dispose();
    residentialRentAmountController.dispose();

    residentialDescribePropertyFocusNode.dispose();
    residentialDescribePropertyController.dispose();
  }
}
