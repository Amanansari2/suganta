import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:collection/collection.dart';

import '../api_service/print_logger.dart';
import '../configs/app_color.dart';
import '../model/city_model.dart';
import '../model/post_property_model.dart';
import '../repository/commercial_post_edit_property_repo.dart';
import 'fetch_city_list_controller.dart';

class CommercialPostEditPropertyController extends GetxController {
  final CommercialPostEditPropertyRepository
      commercialPostEditPropertyRepository =
      Get.find<CommercialPostEditPropertyRepository>();

  RxInt commercialCurrentStep = 1.obs;
  int? propertyLogId;
  int? propertyImageId;

  //---Type
  RxMap<String, String> commercialTypeCategories = {
    "SELL": "SELL",
    "RENT": "RENT",
    "RENT/LEASE": "RENT/LEASE",
    "LEASE": "LEASE",
  }.obs;

  RxString selectedCommercialTypeCategory = "".obs;

  void updateSelectedCommercialTypeCategory(String displayValue) {
    selectedCommercialTypeCategory.value =
        commercialTypeCategories[displayValue] ?? "";
  }

  //---SubType
  RxMap<String, String> commercialSubTypeCategories = {
    "Office": "1",
    "Retail": "8",
    "Plot / Land": "9",
    "Storage": "11",
  }.obs;
  RxString selectedCommercialSubTypeCategory = "".obs;

  void updateSelectedCommercialSubTypeCategory(String displayValue) {
    selectedCommercialSubTypeCategory.value =
        commercialSubTypeCategories[displayValue] ?? "";
  }

//---No. of Seats

  RxBool hasCommercialSeatFocus = false.obs;
  RxBool hasCommercialSeatInput = false.obs;
  FocusNode commercialSeatFocusNode = FocusNode();
  TextEditingController commercialSeatController = TextEditingController();

  //---No. of Cabins

  RxBool hasCommercialCabinFocus = false.obs;
  RxBool hasCommercialCabinInput = false.obs;
  FocusNode commercialCabinFocusNode = FocusNode();
  TextEditingController commercialCabinController = TextEditingController();

  //---No. of Meeting Rooms

  RxBool hasCommercialMeetingRoomFocus = false.obs;
  RxBool hasCommercialMeetingRoomInput = false.obs;
  FocusNode commercialMeetingRoomFocusNode = FocusNode();
  TextEditingController commercialMeetingRoomController =
      TextEditingController();

  //---No. of Conference Rooms

  RxBool hasCommercialConferenceRoomFocus = false.obs;
  RxBool hasCommercialConferenceRoomInput = false.obs;
  FocusNode commercialConferenceRoomFocusNode = FocusNode();
  TextEditingController commercialConferenceRoomController =
      TextEditingController();

  //---No. of Washroom

  RxBool hasCommercialWashroomFocus = false.obs;
  RxBool hasCommercialWashroomInput = false.obs;
  FocusNode commercialWashroomFocusNode = FocusNode();
  TextEditingController commercialWashroomController = TextEditingController();

  //---Reception Area
  RxMap<String, String> commercialReceptionAreaCategories = {
    "Available": "1",
    "Not Available": "0",
  }.obs;
  RxString selectedCommercialReceptionAreaCategory = "".obs;

  void updateSelectedCommercialReceptionAreaCategory(String displayValue) {
    selectedCommercialReceptionAreaCategory.value =
        commercialReceptionAreaCategories[displayValue] ?? "";
  }

  //---Type of spaces
  RxMap<String, String> commercialTypeOfSpace = {
    "COMMERCIAL SHOPS": "COMMERCIAL SHOPS",
    "COMMERCIAL SHOWROOMS": "COMMERCIAL SHOWROOMS",
    "SHOPPING CENTER": "SHOPPING CENTER",
    "INDUSTRIAL SPACE": "INDUSTRIAL SPACE",
    "OTHERS": "OTHERS",
  }.obs;
  RxString selectedCommercialTypeOfSpace = "".obs;

  void updateSelectedCommercialTypeOfSpace(String displayValue) {
    selectedCommercialTypeOfSpace.value =
        commercialTypeOfSpace[displayValue] ?? "";
  }

//---Shop Located Inside
  RxMap<String, String> commercialShopLocatedInside = {
    "MALL": "MALL",
    "COMMERCIAL PROJECT": "COMMERCIAL PROJECT",
    "RESIDENTIAL PROJECT": "RESIDENTIAL PROJECT",
    "RETAIL COMPLEX": "RETAIL COMPLEX",
    "MARKET/HIGH STREET": "MARKET/HIGH STREET",
    "OTHER": "OTHER",
  }.obs;
  RxString selectedCommercialShopLocatedInside = "".obs;

  void updateSelectedCommercialShopLocatedInside(String displayValue) {
    selectedCommercialShopLocatedInside.value =
        commercialShopLocatedInside[displayValue] ?? "";
  }

  //---TYPE Of PLOT/Land
  RxMap<String, String> commercialTypeOfPlotLand = {
    "COMMERCIAL LAND": "COMMERCIAL LAND",
    "AGRICULTURE LAND": "AGRICULTURE LAND",
    "EAST FACING PLOTS": "EAST FACING PLOTS",
    "GATED COMMUNITY": "GATED COMMUNITY",
  }.obs;
  RxString selectedCommercialTypeOfPlotLand = "".obs;

  void updateSelectedCommercialTypeOfPlotLand(String displayValue) {
    selectedCommercialTypeOfPlotLand.value =
        commercialTypeOfPlotLand[displayValue] ?? "";
  }

  //---TYPE Of Storage
  RxMap<String, String> commercialTypeOfStorage = {
    "WARE HOUSE": "WARE HOUSE",
    "COLD STORAGE": "COLD STORAGE",
    "SELF STORAGE": "SELF STORAGE",
    "PUBLIC STORAGE": "PUBLIC STORAGE",
  }.obs;
  RxString selectedCommercialTypeOfStorage = "".obs;

  void updateSelectedCommercialTypeOfStorage(String displayValue) {
    selectedCommercialTypeOfStorage.value =
        commercialTypeOfStorage[displayValue] ?? "";
  }

  //---Plot Area in Sq.ft

  RxBool hasCommercialPlotAreaFocus = false.obs;
  RxBool hasCommercialPlotAreaInput = false.obs;
  FocusNode commercialPlotAreaFocusNode = FocusNode();
  TextEditingController commercialPlotAreaController = TextEditingController();

  //---Build Up Area

  RxBool hasCommercialBuildUpAreaFocus = false.obs;
  RxBool hasCommercialBuildUpAreaInput = false.obs;
  FocusNode commercialBuildUpAreaFocusNode = FocusNode();
  TextEditingController commercialBuildUpAreaController =
      TextEditingController();

//---Carpet Area

  RxBool hasCommercialCarpetAreaFocus = false.obs;
  RxBool hasCommercialCarpetAreaInput = false.obs;
  FocusNode commercialCarpetAreaFocusNode = FocusNode();
  TextEditingController commercialCarpetAreaController =
      TextEditingController();

  //---Width of Facing Road (Feet)

  RxBool hasCommercialWidthOfFacingRoadFocus = false.obs;
  RxBool hasCommercialWidthOfFacingRoadInput = false.obs;
  FocusNode commercialWidthOfFacingRoadFocusNode = FocusNode();
  TextEditingController commercialWidthOfFacingRoadController =
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

  //---Property Floor

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

  //---Facility & FireOption

  final facilityOptions = {"Yes": "1", "Not Available": "0"};

  void updateFacility(RxString field, String displayValue) {
    field.value = facilityOptions[displayValue] ?? "";
  }

  //---facility
  RxString furnishing = "".obs;
  RxString centralAC = "".obs;
  RxString oxygenDuct = "".obs;
  RxString ups = "".obs;

//--fire safety
  RxString fireExtension = "".obs;
  RxString fireSprinklers = "".obs;
  RxString fireSensors = "".obs;
  RxString fireHose = "".obs;

  //---Availability Area
  RxMap<String, String> commercialAvailability = {
    "Ready to Move": "1",
    "Under Construction": "0",
  }.obs;
  RxString selectedCommercialAvailability = "".obs;

  void updateSelectedCommercialAvailability(String displayValue) {
    selectedCommercialAvailability.value =
        commercialAvailability[displayValue] ?? "";
  }

  //---Parking Status
  RxMap<String, String> commercialParkingStatus = {
    "Available": "1",
    "Not Available": "0",
  }.obs;
  RxString selectedCommercialParkingStatus = "".obs;

  void updateSelectedCommercialParkingStatus(String displayValue) {
    selectedCommercialParkingStatus.value =
        commercialParkingStatus[displayValue] ?? "";
  }

  //---Pantry Type
  RxMap<String, String> commercialPantryTypeCategories = {
    "Public": "PUBLIC",
    "Private": "PRIVATE",
    "Not Available": "NOT AVAILABLE",
  }.obs;

  RxString selectedCommercialPantryTypeCategory = "".obs;

  void updateSelectedCommercialPantryTypeCategory(String displayValue) {
    selectedCommercialPantryTypeCategory.value = displayValue;
  }

  //---STAIRCASE

  RxBool hasCommercialStairCaseFocus = false.obs;
  RxBool hasCommercialStairCaseInput = false.obs;
  FocusNode commercialStairCaseFocusNode = FocusNode();
  TextEditingController commercialStairCaseController = TextEditingController();

  //---Lifts

  RxBool hasCommercialLiftFocus = false.obs;
  RxBool hasCommercialLiftInput = false.obs;
  FocusNode commercialLiftFocusNode = FocusNode();
  TextEditingController commercialLiftController = TextEditingController();

  //---Plot Facing
  RxMap<String, String> commercialPlotFacing = {
    "NORTH": "NORTH",
    "SOUTH": "SOUTH",
    "EAST": "EAST",
    "WEST": "WEST",
    "NORTH-EAST": "NORTH-EAST",
    "NORTH-WEST": "NORTH-WEST",
    "SOUTH-EAST": "SOUTH-EAST",
    "SOUTH-WEST": "SOUTH-WEST",
  }.obs;
  RxString selectedCommercialPlotFacing = "".obs;

  void updateSelectedCommercialPlotFacing(String displayValue) {
    selectedCommercialPlotFacing.value =
        commercialPlotFacing[displayValue] ?? "";
  }

  //---Age Of Property

  RxBool hasCommercialAgeOfPropertyFocus = false.obs;
  RxBool hasCommercialAgeOfPropertyInput = false.obs;
  FocusNode commercialAgeOfPropertyFocusNode = FocusNode();
  TextEditingController commercialAgeOfPropertyController =
      TextEditingController();

  bool shouldShowField(String fieldName) {
    final subtypeKey = commercialSubTypeCategories.entries
            .firstWhereOrNull((entry) =>
                entry.value == selectedCommercialSubTypeCategory.value)
            ?.key ??
        "";
    //print("Field: $fieldName, SubtypeKey: $subtypeKey");
    final visibilityMap = {
      "Office": [
        "DETAILS",
        "SEAT",
        "CABIN",
        "MEETING",
        "CONFERENCE",
        "WASHROOM",
        "RECEPTION",
        "BUILDUP",
        "CARPET",
        "TOTALFLOOR",
        "PROPERTYFLOOR",
        "FACILITY",
        "FIRESAFETY",
        "AVAILABILITY",
        "PARKING",
        "PANTRY",
        "STAIRCASE",
        "LIFT",
        "Next"
      ],
      "Retail": [
        "DETAILS",
        "TYPEOFSPACES",
        "SHOPLOCATEDINSIDE",
        "BUILDUP",
        "CARPET",
        "TOTALFLOOR",
        "PROPERTYFLOOR",
        "AVAILABILITY",
        "PARKING",
        "PANTRY",
        "Next",
      ],
      "Plot / Land": [
        "DETAILS",
        "PLOTLANDTYPE",
        "PLOTAREA",
        "BUILDUP",
        "WIDTHOFFACINGROAD",
        "PLOTFACING",
        "Next",
      ],
      "Storage": [
        "DETAILS",
        "WASHROOM",
        "BUILDUP",
        "CARPET",
        "AVAILABILITY",
        "TYPEOFSTORAGE",
        "AGEOFPROPERTY",
        "Next",
      ],
    };
    final isVisible = visibilityMap[subtypeKey]?.contains(fieldName) ?? false;
    //  print("shouldShowField('$fieldName') → $isVisible");
    return visibilityMap[subtypeKey]?.contains(fieldName) ?? false;
  }

  Map<String, dynamic> buildCommercialPayload() {
    String subtypeKey = commercialSubTypeCategories.entries
        .firstWhere(
          (entry) => entry.value == selectedCommercialSubTypeCategory.value,
          orElse: () => const MapEntry("", ""),
        )
        .key;

    final wantTo = selectedCommercialTypeCategory.value;
    const type = "COMMERCIAL";
    final typeOptionsId =
        int.parse(selectedCommercialSubTypeCategory.value) ?? 0;

    Map<String, dynamic> payload = {
      "want_to": wantTo,
      "type": type,
      "type_options_id": typeOptionsId,
    };

    switch (subtypeKey) {
      case "Office":
        payload.addAll({
          "no_of_seats": int.tryParse(commercialSeatController.text) ?? 0,
          "no_of_cabins": int.tryParse(commercialCabinController.text) ?? 0,
          "no_of_meeting_rooms":
              int.tryParse(commercialMeetingRoomController.text) ?? 0,
          "no_of_confrence_rooms":
              int.tryParse(commercialConferenceRoomController.text) ?? 0,
          "no_of_washrooms":
              int.tryParse(commercialWashroomController.text) ?? 0,
          "reception_area":
              int.tryParse(selectedCommercialReceptionAreaCategory.value) ?? 0,
          "carpet_area": int.tryParse(commercialCarpetAreaController.text) ?? 0,
          "build_area": int.tryParse(commercialBuildUpAreaController.text) ?? 0,
          "no_of_floors": int.tryParse(
                  totalFloorOptions[selectedTotalFloor.value] ?? "0") ??
              0,
          "property_on_floor": int.tryParse(
                  propertyFloorOptions[selectedPropertyFloor.value] ?? "0") ??
              0,
          "furnishing": int.tryParse(furnishing.value) ?? 0,
          "central_ac": int.tryParse(centralAC.value) ?? 0,
          "oxygen_duct": int.tryParse(oxygenDuct.value) ?? 0,
          "ups": int.tryParse(ups.value) ?? 0,
          "fire_extension": int.tryParse(fireExtension.value) ?? 0,
          "fire_sprinklers": int.tryParse(fireSprinklers.value) ?? 0,
          "fire_sensors": int.tryParse(fireSensors.value) ?? 0,
          "fire_hose": int.tryParse(fireHose.value) ?? 0,
          "is_under_construction":
              int.tryParse(selectedCommercialAvailability.value) ?? 0,
          "parking": int.tryParse(selectedCommercialParkingStatus.value) ?? 0,
          "pantry": selectedCommercialPantryTypeCategory.value,
          "no_of_staircases":
              int.tryParse(commercialStairCaseController.text) ?? 0,
          "no_of_lifts": int.tryParse(commercialLiftController.text) ?? 0
        });
        break;

      case "Retail":
        payload.addAll({
          "type_of_retail_space": selectedCommercialTypeOfSpace.value,
          "shop_located_inside": selectedCommercialShopLocatedInside.value,
          "carpet_area": int.tryParse(commercialCarpetAreaController.text) ?? 0,
          "build_area": int.tryParse(commercialBuildUpAreaController.text) ?? 0,
          "no_of_floors": int.tryParse(
                  totalFloorOptions[selectedTotalFloor.value] ?? "0") ??
              0,
          "property_on_floor": int.tryParse(
                  propertyFloorOptions[selectedPropertyFloor.value] ?? "0") ??
              0,
          "parking": int.tryParse(selectedCommercialParkingStatus.value) ?? 0,
          "type_of_washroom": selectedCommercialPantryTypeCategory.value,
          "is_under_construction":
              int.tryParse(selectedCommercialAvailability.value) ?? 0
        });
        break;
      case "Plot / Land":
        payload.addAll({
          "type_of_land": selectedCommercialTypeOfPlotLand.value,
          "build_area": int.tryParse(commercialBuildUpAreaController.text) ?? 0,
          "plot_area": int.tryParse(commercialPlotAreaController.text) ?? 0,
          "road_facing_width":
              int.tryParse(commercialWidthOfFacingRoadController.text) ?? 0,
          "plot_facing_direction": selectedCommercialPlotFacing.value
        });
        break;
      case "Storage":
        payload.addAll({
          "type_of_storage": selectedCommercialTypeOfStorage.value,
          "carpet_area": int.tryParse(commercialCarpetAreaController.text) ?? 0,
          "build_area": int.tryParse(commercialBuildUpAreaController.text) ?? 0,
          "age_of_property":
              int.tryParse(commercialAgeOfPropertyController.text) ?? 0,
          "no_of_washrooms":
              int.tryParse(commercialWashroomController.text) ?? 0,
          "is_under_construction":
              int.tryParse(selectedCommercialAvailability.value) ?? 0
        });
        break;

      default:
        break;
    }
    return payload;
  }

  bool validateCommercialStep1Fields() {
    if (selectedCommercialTypeCategory.value.isEmpty) {
      Get.snackbar("Error", "Please select Property Type",
          backgroundColor: AppColor.red);
      return false;
    }

    String subtypeKey = commercialSubTypeCategories.entries
            .firstWhereOrNull((entry) =>
                entry.value == selectedCommercialSubTypeCategory.value)
            ?.key ??
        "";

    if (subtypeKey.isEmpty) {
      Get.snackbar("Error", "Please select Property Subtype",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("SEAT") && commercialSeatController.text.isEmpty) {
      Get.snackbar("Error", "Please enter number of seats",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("CABIN") && commercialCabinController.text.isEmpty) {
      Get.snackbar("Error", "Please enter number of cabins",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("MEETING") &&
        commercialMeetingRoomController.text.isEmpty) {
      Get.snackbar("Error", "Please enter number of meeting rooms",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("CONFERENCE") &&
        commercialConferenceRoomController.text.isEmpty) {
      Get.snackbar("Error", "Please enter number of conference rooms",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("WASHROOM") &&
        commercialWashroomController.text.isEmpty) {
      Get.snackbar("Error", "Please enter number of washrooms",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("RECEPTION") &&
        selectedCommercialReceptionAreaCategory.value.isEmpty) {
      Get.snackbar("Error", "Please select reception area",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("TYPEOFSPACES") &&
        selectedCommercialTypeOfSpace.value.isEmpty) {
      Get.snackbar("Error", "Please select type of space",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("SHOPLOCATEDINSIDE") &&
        selectedCommercialShopLocatedInside.value.isEmpty) {
      Get.snackbar("Error", "Please select where the shop is located",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("PLOTLANDTYPE") &&
        selectedCommercialTypeOfPlotLand.value.isEmpty) {
      Get.snackbar("Error", "Please select plot/land type",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("TYPEOFSTORAGE") &&
        selectedCommercialTypeOfStorage.value.isEmpty) {
      Get.snackbar("Error", "Please select type of storage",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("PLOTAREA") &&
        commercialPlotAreaController.text.isEmpty) {
      Get.snackbar("Error", "Please enter plot area",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("BUILDUP") &&
        commercialBuildUpAreaController.text.isEmpty) {
      Get.snackbar("Error", "Please enter buildup area",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("CARPET") &&
        commercialCarpetAreaController.text.isEmpty) {
      Get.snackbar("Error", "Please enter carpet area",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("WIDTHOFFACINGROAD") &&
        commercialWidthOfFacingRoadController.text.isEmpty) {
      Get.snackbar("Error", "Please enter width of facing road",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("TOTALFLOOR") && selectedTotalFloor.value.isEmpty) {
      Get.snackbar("Error", "Please select total floors",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("PROPERTYFLOOR") &&
        selectedPropertyFloor.value.isEmpty) {
      Get.snackbar("Error", "Please select property floor",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("FACILITY") && furnishing.value.isEmpty) {
      Get.snackbar("Error", "Please select furnishing status",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("FIRESAFETY") && fireExtension.value.isEmpty) {
      Get.snackbar("Error", "Please select fire extension option",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("FIRESAFETY") && fireSprinklers.value.isEmpty) {
      Get.snackbar("Error", "Please select fire sprinklers option",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("FIRESAFETY") && fireSensors.value.isEmpty) {
      Get.snackbar("Error", "Please select fire sensors option",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("FIRESAFETY") && fireHose.value.isEmpty) {
      Get.snackbar("Error", "Please select fire hose option",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("AVAILABILITY") &&
        selectedCommercialAvailability.value.isEmpty) {
      Get.snackbar("Error", "Please select availability",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("PARKING") &&
        selectedCommercialParkingStatus.value.isEmpty) {
      Get.snackbar("Error", "Please select parking availability",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("PANTRY") &&
        selectedCommercialPantryTypeCategory.value.isEmpty) {
      Get.snackbar("Error", "Please select pantry type",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("STAIRCASE") &&
        commercialStairCaseController.text.isEmpty) {
      Get.snackbar("Error", "Please enter number of staircases",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("LIFT") && commercialLiftController.text.isEmpty) {
      Get.snackbar("Error", "Please enter number of lifts",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("PLOTFACING") &&
        selectedCommercialPlotFacing.value.isEmpty) {
      Get.snackbar("Error", "Please select plot facing direction",
          backgroundColor: AppColor.red);
      return false;
    }

    if (shouldShowField("AGEOFPROPERTY") &&
        commercialAgeOfPropertyController.text.isEmpty) {
      Get.snackbar("Error", "Please enter age of property",
          backgroundColor: AppColor.red);
      return false;
    }

    return true;
  }

  String cleanDecimal(num? value) {
    if (value == null) return '';
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }

  void setEditCommercialData(PostPropertyData property) {
    final feature = property.feature;
    if (feature == null) return;

    selectedCommercialTypeCategory.value = property.wantTo;
    selectedCommercialSubTypeCategory.value =
        property.typeOptionsId?.toString() ?? "";

    final subtypeKey = commercialSubTypeCategories.entries
            .firstWhereOrNull((entry) =>
                entry.value == selectedCommercialSubTypeCategory.value)
            ?.key ??
        "";

    selectedCommercialTypeCategory.value = property.wantTo;
    selectedCommercialSubTypeCategory.value =
        property.typeOptionsId?.toString() ?? "";

    commercialSeatController.text = feature.noOfSeats?.toString() ?? '';
    commercialCabinController.text = feature.noOfCabins?.toString() ?? '';
    commercialMeetingRoomController.text =
        feature.noOfMeetingRooms?.toString() ?? '';
    commercialConferenceRoomController.text =
        feature.noOfConferenceRooms?.toString() ?? '';
    commercialWashroomController.text = feature.noOfWashrooms?.toString() ?? '';

    selectedCommercialReceptionAreaCategory.value =
        feature.receptionArea.toString();

    commercialCarpetAreaController.text = feature.carpetArea.toInt().toString();
    commercialBuildUpAreaController.text = feature.buildArea.toInt().toString();
    commercialPlotAreaController.text = feature.plotArea.toInt().toString();
    commercialWidthOfFacingRoadController.text =
        cleanDecimal(feature.roadFacingWidth);

    selectedTotalFloor.value = totalFloorOptions.entries
            .firstWhereOrNull((e) => e.value == feature.noOfFloors.toString())
            ?.key ??
        "";

    selectedPropertyFloor.value = propertyFloorOptions.entries
            .firstWhereOrNull(
                (e) => e.value == feature.propertyOnFloor.toString())
            ?.key ??
        "";

    furnishing.value = feature.furnishing.toString();
    centralAC.value = feature.centralAC.toString();
    oxygenDuct.value = feature.oxygenDuct.toString();
    ups.value = feature.ups.toString();

    fireExtension.value = feature.fireExtension.toString();
    fireSprinklers.value = feature.fireSprinklers.toString();
    fireSensors.value = feature.fireSensors.toString();
    fireHose.value = feature.fireHose.toString();

    Get.log("Fire house -->>> ${feature.fireHose.toString()}");

    selectedCommercialAvailability.value =
        feature.isUnderConstruction.toString();
    selectedCommercialParkingStatus.value = feature.parking.toString();

// Pantry / Washroom Type Mapping
    if (subtypeKey == "Office") {
      final pantryKey = commercialPantryTypeCategories.entries
          .firstWhereOrNull(
              (e) => e.value.toLowerCase() == feature.pantry?.toLowerCase())
          ?.key;

      selectedCommercialPantryTypeCategory.value = pantryKey ?? '';
      Get.log("🧃 Pantry feature value: ${feature.pantry}");
      Get.log("🎯 Pantry key set: $pantryKey");
      update(); // Force UI refresh
    } else if (subtypeKey == "Retail") {
      final washroomKey = commercialPantryTypeCategories.entries
          .firstWhereOrNull((e) =>
              e.value.toLowerCase() == feature.typeOfWashroom?.toLowerCase())
          ?.key;

      selectedCommercialPantryTypeCategory.value = washroomKey ?? '';
      Get.log("🛁 Washroom feature value: ${feature.typeOfWashroom}");
      Get.log("🎯 Washroom key set: $washroomKey");
      update(); // Force UI refresh
    }

    commercialStairCaseController.text =
        feature.noOfStaircases?.toString() ?? '';
    commercialLiftController.text = feature.noOfLifts?.toString() ?? '';

    selectedCommercialPlotFacing.value = feature.plotFacingDirection ?? '';

    commercialAgeOfPropertyController.text = feature.ageOfProperty.toString();

    selectedCommercialTypeOfPlotLand.value = feature.typeOfLand ?? '';
    selectedCommercialTypeOfStorage.value = feature.typeOfStorage ?? '';
    selectedCommercialTypeOfSpace.value = feature.typeOfRetailSpace ?? '';
    selectedCommercialShopLocatedInside.value = feature.shopLocatedInside ?? '';
    Get.log("🛁 Type Of space value: ${feature.typeOfRetailSpace}");
    Get.log("🛁 Shop Located value: ${feature.shopLocatedInside}");

    // ⬇️ Step 2: Prefill Location
    final address = property.address;
    selectedCommercialCity = commercialCityOptions.firstWhereOrNull(
      (city) => city.name.toLowerCase() == address.city.toLowerCase(),
    );
    commercialAreaController.text = address.area;
    commercialSubLocalityController.text = address.subLocality ?? '';
    commercialHouseNoController.text = address.houseNo ?? '';
    commercialZipCodeController.text = address.pin.toString();

// ⬇️ Step 3: Prefill Pricing, Ownership, Flags
    if (feature != null) {
      commercialRentAmountController.text = feature.rentAmount.toString();
      allInclusivePrice.value = feature.isAllInclusionPrice == 1;
      taxAndGovtChargesExcluded.value = feature.isTaxAndChargesExcluded == 1;
      priceNegotiable.value = feature.isNegotiable == 1;

      commercialDescribePropertyController.text = property.description ?? '';

      final ownershipKey = commercialOwnerShipCategories.entries
          .firstWhereOrNull(
              (e) => e.value.toLowerCase() == feature.ownership?.toLowerCase())
          ?.key;
      selectedCommercialOwnerShipCategory.value = ownershipKey ?? '';

      Get.log("🏷️ Ownership feature value: ${feature.ownership}");
      Get.log("🎯 Ownership key set: $ownershipKey");
    }

    propertyLogId = property.propertyLogId;
    propertyImageId = property.id;

    Get.log(
        "Commercial Property Log Id--->>>$propertyLogId , Image ID -->>>> $propertyImageId ");
    Get.log("🏢 Commercial Edit Data Set Successfully");
  }

  RxBool isLoading = false.obs;
  bool isCommercialDetailSubmitted = false;

  Future<void> submitEditCommercialDetailStep1() async {
    if (!validateCommercialStep1Fields()) return;
    isCommercialDetailSubmitted = false;

    isLoading(true);

    try {
      final response = await commercialPostEditPropertyRepository
          .submitEditStep1CommercialDetail();
      isLoading(false);
      if (response["success"] == true) {
        isCommercialDetailSubmitted = true;
        String msg =
            response["data"]?["message"] ?? "Commercial details submitted";
        Get.snackbar("Success", msg, backgroundColor: AppColor.green);
      } else {
        isCommercialDetailSubmitted = false;
        String errMsg = response["data"]?["message"] ?? "Something went wrong!";
        Get.snackbar(
          "Error",
          errMsg,
        );
      }
    } catch (e) {
      isLoading(false);
      isCommercialDetailSubmitted = false;
      Get.snackbar(
        "Error",
        "Something Went Wrong Please try Again after sometime",
      );
    }
  }

  /////////////////////// Commercial section step 2--------------------------------------------------------------------------

  List<City> commercialCityOptions = [];
  City? selectedCommercialCity;
  TextEditingController citySearchController = TextEditingController();

  Future<void> loadCityList() async {
    final cityListController = Get.find<CityList>();
    commercialCityOptions.clear();
    commercialCityOptions.addAll(cityListController.cityList);

    Get.log(
        "Commercial City List Loaded from Shared Controller: ${commercialCityOptions.length} cities");
  }

  void updateSelectedCommercialCity(String? cityName) {
    final selectedCity =
        commercialCityOptions.firstWhereOrNull((city) => city.name == cityName);
    if (selectedCity != null) {
      selectedCommercialCity = selectedCity;
      update();
    }
  }

  //////////////////-----Area
  RxBool hasCommercialAreaFocus = false.obs;
  RxBool hasCommercialAreaInput = false.obs;
  FocusNode commercialAreaFocusNode = FocusNode();
  TextEditingController commercialAreaController = TextEditingController();

  //////////////////-----SubLocality
  RxBool hasCommercialSubLocalityFocus = false.obs;
  RxBool hasCommercialSubLocalityInput = false.obs;
  FocusNode commercialSubLocalityFocusNode = FocusNode();
  TextEditingController commercialSubLocalityController =
      TextEditingController();

  //////////////////-----HouseNo
  RxBool hasCommercialHouseNoFocus = false.obs;
  RxBool hasCommercialHouseNoInput = false.obs;
  FocusNode commercialHouseNoFocusNode = FocusNode();
  TextEditingController commercialHouseNoController = TextEditingController();

  //////////////////-----ZipCode
  RxBool hasCommercialZipCodeFocus = false.obs;
  RxBool hasCommercialZipCodeInput = false.obs;
  FocusNode commercialZipCodeFocusNode = FocusNode();
  TextEditingController commercialZipCodeController = TextEditingController();

  RxBool isLoadingStep2 = false.obs;
  bool isCommercialDetailSubmittedStep2 = false;

  Future<void> submitEditCommercialDetailsStep2() async {
    isCommercialDetailSubmittedStep2 = false;
    if (selectedCommercialCity == null) {
      Get.snackbar("Error", "Please select a City",
          backgroundColor: AppColor.red);
      return;
    }
    if (commercialAreaController.text.isEmpty) {
      Get.snackbar("Error", "Please enter an Area",
          backgroundColor: AppColor.red);
      return;
    }
    if (commercialSubLocalityController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a Sub Locality",
          backgroundColor: AppColor.red);
      return;
    }
    if (commercialHouseNoController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a House No.",
          backgroundColor: AppColor.red);
      return;
    }
    if (commercialZipCodeController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a Pin Code",
          backgroundColor: AppColor.red);
      return;
    }

    if (commercialZipCodeController.text.length != 6) {
      Get.snackbar("Error", "The Pin Field mus be 6 Character",
          backgroundColor: AppColor.red);
      return;
    }

    isLoadingStep2(true);
    final response = await commercialPostEditPropertyRepository
        .submitEditStep2CommercialDetail(
            propertyLogId: propertyLogId!,
            city: selectedCommercialCity?.name ?? "",
            area: commercialAreaController.text,
            subLocality: commercialSubLocalityController.text,
            houseNo: commercialHouseNoController.text,
            pin: commercialZipCodeController.text);

    isLoadingStep2(false);
    if (response["success"] == true) {
      isCommercialDetailSubmittedStep2 = true;
      String successMessage = response["data"]?["message"] ?? "";
      AppLogger.log("success message -->>> $successMessage");
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isCommercialDetailSubmittedStep2 = false;
      String errorMessage =
          response["data"]?["message"] ?? "Something went wrong!";
      Get.snackbar("Error", errorMessage, backgroundColor: AppColor.red);
    }
  }

  /////////////////////// Commercial section step 3--------------------------------------------------------------------------
  //////////////////-----Area
  RxBool hasCommercialRentAmountFocus = false.obs;
  RxBool hasCommercialRentAmountInput = false.obs;
  FocusNode commercialRentAmountFocusNode = FocusNode();
  TextEditingController commercialRentAmountController =
      TextEditingController();

  //////////////////-----Pricing Option
  int boolToInt(bool value) => value ? 1 : 0;

  RxBool allInclusivePrice = false.obs;
  RxBool taxAndGovtChargesExcluded = false.obs;
  RxBool priceNegotiable = false.obs;

  //////////////////-----Ownership

  //---Type
  RxMap<String, String> commercialOwnerShipCategories = {
    "Freehold": "FREEHOLD",
    "Leasehold": "LEASHOLD",
    "Co-operative Society": "CO-OPERATIVE SOCIETY",
    "Power of Attorney": "POWER OF ATTORNEY",
  }.obs;

  RxString selectedCommercialOwnerShipCategory = "".obs;

  void updateSelectedCommercialOwnerShipCategory(String displayValue) {
    selectedCommercialOwnerShipCategory.value = displayValue;
  }

  //////////////////-----Describe Property
  RxBool hasCommercialDescribePropertyFocus = false.obs;
  RxBool hasCommercialDescribePropertyInput = false.obs;
  FocusNode commercialDescribePropertyFocusNode = FocusNode();
  TextEditingController commercialDescribePropertyController =
      TextEditingController();

  RxBool isLoadingStep3 = false.obs;
  bool isCommercialDetailSubmittedStep3 = false;

  Future<void> submitEditCommercialDetailsStep3() async {
    isCommercialDetailSubmittedStep3 = false;

    if (commercialRentAmountController.text.isEmpty) {
      Get.snackbar("Error", "Please enter Rent Amount",
          backgroundColor: AppColor.red);
      return;
    }
    if (selectedCommercialOwnerShipCategory.value.isEmpty) {
      Get.snackbar("Error", "Please select Owner Ship",
          backgroundColor: AppColor.red);
      return;
    }
    if (commercialDescribePropertyController.text.isEmpty) {
      Get.snackbar("Error", "Please describe the property",
          backgroundColor: AppColor.red);
      return;
    }
    isLoadingStep3(true);
    final response = await commercialPostEditPropertyRepository
        .submitEditStep3CommercialDetail(
            propertyLogId: propertyLogId!,
            rentAmount: int.tryParse(commercialRentAmountController.text) ?? 0,
            uniquePropertyDescription:
                commercialDescribePropertyController.text,
            allInclusivePrice: boolToInt(allInclusivePrice.value),
            taxAndGovtChargesExcluded:
                boolToInt(taxAndGovtChargesExcluded.value),
            priceNegotiable: boolToInt(priceNegotiable.value),
            ownerShip: selectedCommercialOwnerShipCategory.value.toUpperCase());

    isLoadingStep3(false);
    if (response["data"]?["status"] == 200) {
      isCommercialDetailSubmittedStep3 = true;
      String successMessage = response["data"]?["message"] ??
          "PG Step 3 details submitted successfully!";
      AppLogger.log("Success message -->>> $successMessage");
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isCommercialDetailSubmittedStep3 = false;
      String errorMessage =
          response["data"]?["message"] ?? "Something went wrong!";
      Get.snackbar("Error", errorMessage, backgroundColor: AppColor.red);
    }
  }

  /////////////////////// Commercial section step 4--------------------------------------------------------------------------
  RxBool isLoadingStep4 = false.obs;
  bool isCommercialDetailSubmittedStep4 = false;

  Future<void> submitEditCommercialDetailsStep4Images(List<File> images) async {
    isCommercialDetailSubmittedStep4 = false;
    isLoadingStep4(true);

    if (images.isEmpty) {
      AppLogger.log("❌ No images selected by user.");
      isLoadingStep4(false);
      Get.snackbar("Error", "Please select at least one image to upload.",
          backgroundColor: AppColor.red);
      return;
    }

    final response =
        await commercialPostEditPropertyRepository.uploadEditStep4Images(
            propertyImageId: propertyImageId!, imageFiles: images);

    isLoadingStep4(false);
    if (response["success"] == true) {
      isCommercialDetailSubmittedStep4 = true;
      String successMessage =
          response["data"]?["message"] ?? "Images uploaded successfully!";
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isCommercialDetailSubmittedStep4 = true;
      String errorMessage =
          response["message"] ?? "Something went wrong during image upload.";
      Get.snackbar("Error", errorMessage, backgroundColor: AppColor.red);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadCityList();
    //----
    commercialSeatController.addListener(() {
      hasCommercialSeatInput.value = commercialSeatController.text.isNotEmpty;
    });

    commercialSeatFocusNode.addListener(() {
      hasCommercialSeatFocus.value = commercialSeatFocusNode.hasFocus;
    });

    //----
    commercialCabinController.addListener(() {
      hasCommercialCabinInput.value = commercialCabinController.text.isNotEmpty;
    });

    commercialCabinFocusNode.addListener(() {
      hasCommercialCabinFocus.value = commercialCabinFocusNode.hasFocus;
    });

    //----
    commercialMeetingRoomController.addListener(() {
      hasCommercialMeetingRoomInput.value =
          commercialMeetingRoomController.text.isNotEmpty;
    });

    commercialMeetingRoomFocusNode.addListener(() {
      hasCommercialMeetingRoomFocus.value =
          commercialMeetingRoomFocusNode.hasFocus;
    });

    //----
    commercialConferenceRoomController.addListener(() {
      hasCommercialConferenceRoomInput.value =
          commercialConferenceRoomController.text.isNotEmpty;
    });

    commercialConferenceRoomFocusNode.addListener(() {
      hasCommercialConferenceRoomFocus.value =
          commercialConferenceRoomFocusNode.hasFocus;
    });

    //----
    commercialWashroomController.addListener(() {
      hasCommercialWashroomInput.value =
          commercialWashroomController.text.isNotEmpty;
    });

    commercialWashroomFocusNode.addListener(() {
      hasCommercialWashroomFocus.value = commercialWashroomFocusNode.hasFocus;
    });

    //----
    commercialPlotAreaController.addListener(() {
      hasCommercialPlotAreaInput.value =
          commercialPlotAreaController.text.isNotEmpty;
    });

    commercialPlotAreaFocusNode.addListener(() {
      hasCommercialPlotAreaFocus.value = commercialPlotAreaFocusNode.hasFocus;
    });

    //----
    commercialBuildUpAreaController.addListener(() {
      hasCommercialBuildUpAreaInput.value =
          commercialBuildUpAreaController.text.isNotEmpty;
    });

    commercialBuildUpAreaFocusNode.addListener(() {
      hasCommercialBuildUpAreaFocus.value =
          commercialBuildUpAreaFocusNode.hasFocus;
    });

    //----
    commercialCarpetAreaController.addListener(() {
      hasCommercialCarpetAreaInput.value =
          commercialCarpetAreaController.text.isNotEmpty;
    });

    commercialCarpetAreaFocusNode.addListener(() {
      hasCommercialCarpetAreaFocus.value =
          commercialCarpetAreaFocusNode.hasFocus;
    });

    //----
    commercialWidthOfFacingRoadController.addListener(() {
      hasCommercialWidthOfFacingRoadInput.value =
          commercialWidthOfFacingRoadController.text.isNotEmpty;
    });

    commercialWidthOfFacingRoadFocusNode.addListener(() {
      hasCommercialWidthOfFacingRoadFocus.value =
          commercialWidthOfFacingRoadFocusNode.hasFocus;
    });

    //----
    commercialStairCaseController.addListener(() {
      hasCommercialStairCaseInput.value =
          commercialStairCaseController.text.isNotEmpty;
    });

    commercialStairCaseFocusNode.addListener(() {
      hasCommercialStairCaseFocus.value = commercialStairCaseFocusNode.hasFocus;
    });

    //----
    commercialLiftController.addListener(() {
      hasCommercialLiftInput.value = commercialLiftController.text.isNotEmpty;
    });

    commercialLiftFocusNode.addListener(() {
      hasCommercialLiftFocus.value = commercialLiftFocusNode.hasFocus;
    });

    //----
    commercialAgeOfPropertyController.addListener(() {
      hasCommercialAgeOfPropertyInput.value =
          commercialAgeOfPropertyController.text.isNotEmpty;
    });

    commercialAgeOfPropertyFocusNode.addListener(() {
      hasCommercialAgeOfPropertyFocus.value =
          commercialAgeOfPropertyFocusNode.hasFocus;
    });

    //////////////////////////step2

    commercialAreaController.addListener(() {
      hasCommercialAreaInput.value = commercialAreaController.text.isNotEmpty;
    });

    commercialAreaFocusNode.addListener(() {
      hasCommercialAreaFocus.value = commercialAreaFocusNode.hasFocus;
    });

    //-------

    commercialSubLocalityController.addListener(() {
      hasCommercialSubLocalityInput.value =
          commercialSubLocalityController.text.isNotEmpty;
    });

    commercialSubLocalityFocusNode.addListener(() {
      hasCommercialSubLocalityFocus.value =
          commercialSubLocalityFocusNode.hasFocus;
    });

    //-------

    commercialHouseNoController.addListener(() {
      hasCommercialHouseNoInput.value =
          commercialHouseNoController.text.isNotEmpty;
    });

    commercialHouseNoFocusNode.addListener(() {
      hasCommercialHouseNoFocus.value = commercialHouseNoFocusNode.hasFocus;
    });

    //-------

    commercialZipCodeController.addListener(() {
      hasCommercialZipCodeInput.value =
          commercialZipCodeController.text.isNotEmpty;
    });

    commercialZipCodeFocusNode.addListener(() {
      hasCommercialZipCodeFocus.value = commercialZipCodeFocusNode.hasFocus;
    });

    /////////////////////////step3

    commercialRentAmountController.addListener(() {
      hasCommercialRentAmountInput.value =
          commercialRentAmountController.text.isNotEmpty;
    });

    commercialRentAmountFocusNode.addListener(() {
      hasCommercialRentAmountFocus.value =
          commercialRentAmountFocusNode.hasFocus;
    });

    //-----
    commercialDescribePropertyController.addListener(() {
      hasCommercialDescribePropertyInput.value =
          commercialDescribePropertyController.text.isNotEmpty;
    });

    commercialDescribePropertyFocusNode.addListener(() {
      hasCommercialDescribePropertyFocus.value =
          commercialDescribePropertyFocusNode.hasFocus;
    });
  }

  @override
  void onClose() {
    super.onClose();
    commercialSeatFocusNode.dispose();
    commercialSeatController.dispose();

    commercialCabinFocusNode.dispose();
    commercialCabinController.dispose();

    commercialMeetingRoomFocusNode.dispose();
    commercialMeetingRoomController.dispose();

    commercialConferenceRoomFocusNode.dispose();
    commercialConferenceRoomController.dispose();

    commercialWashroomFocusNode.dispose();
    commercialWashroomController.dispose();

    commercialPlotAreaFocusNode.dispose();
    commercialPlotAreaController.dispose();

    commercialBuildUpAreaFocusNode.dispose();
    commercialBuildUpAreaController.dispose();

    commercialCarpetAreaFocusNode.dispose();
    commercialCarpetAreaController.dispose();

    commercialWidthOfFacingRoadFocusNode.dispose();
    commercialWidthOfFacingRoadController.dispose();

    commercialStairCaseFocusNode.dispose();
    commercialStairCaseController.dispose();

    commercialLiftFocusNode.dispose();
    commercialLiftController.dispose();

    /////////////////////step2///////

    commercialAreaFocusNode.dispose();
    commercialAreaController.dispose();

    commercialSubLocalityFocusNode.dispose();
    commercialSubLocalityController.dispose();

    commercialHouseNoFocusNode.dispose();
    commercialHouseNoController.dispose();

    commercialZipCodeFocusNode.dispose();
    commercialZipCodeController.dispose();

    /////////////////////step3///////

    commercialRentAmountFocusNode.dispose();
    commercialRentAmountController.dispose();

    commercialDescribePropertyFocusNode.dispose();
    commercialDescribePropertyController.dispose();
  }
}
