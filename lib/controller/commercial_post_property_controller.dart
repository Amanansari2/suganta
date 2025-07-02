import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:collection/collection.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api_service/print_logger.dart';
import '../configs/app_color.dart';
import '../model/city_model.dart';
import '../repository/commercial_post_property_repo.dart';
import '../repository/pg_post_property_repo.dart';
import '../routes/app_routes.dart';
import 'fetch_city_list_controller.dart';

class CommercialPostPropertyController extends GetxController {
  final CommercialPostPropertyRepo commercialPostPropertyRepository =
      Get.find<CommercialPostPropertyRepo>();
  final PGPostPropertyRepository pgPostPropertyRepository =
      Get.find<PGPostPropertyRepository>();

  final storage = GetStorage();

  RxInt commercialCurrentStep = 1.obs;

  void saveCommercialCurrentStep(int step) {
    storage.write("commercial_step", step);
    commercialCurrentStep.value = step;
  }

  void commercialRestoreLastStep() {
    commercialCurrentStep.value = storage.read("commercial_step") ?? 1;
  }

  void commercialResetStepProgress() {
    storage.remove("commercial_step");
    commercialCurrentStep.value = 1;
  }

  void commercialRedirectToSavedStep() {
    int savedStep = storage.read("commercial_step") ?? 1;
    commercialCurrentStep.value = savedStep;
  }

//--------------------- commercial first step-----------
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
    selectedCommercialPantryTypeCategory.value =
        commercialPantryTypeCategories[displayValue] ?? "";
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
      Get.snackbar("Error", "Please saelect Property Type");
      return false;
    }

    String subtypeKey = commercialSubTypeCategories.entries
            .firstWhereOrNull((entry) =>
                entry.value == selectedCommercialSubTypeCategory.value)
            ?.key ??
        "";

    if (subtypeKey.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select Property Subtype",
      );
      return false;
    }

    if (shouldShowField("SEAT") &&
        (commercialSeatController.text.isEmpty ||
            double.parse(commercialSeatController.text) <= 0)) {
      Get.snackbar(
        "Error",
        "Please enter number of seats",
      );
      return false;
    }

    if (shouldShowField("CABIN") && commercialCabinController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter number of cabins",
      );
      return false;
    }

    if (shouldShowField("MEETING") &&
        commercialMeetingRoomController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter number of meeting rooms",
      );
      return false;
    }

    if (shouldShowField("CONFERENCE") &&
        commercialConferenceRoomController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter number of conference rooms",
      );
      return false;
    }

    if (shouldShowField("WASHROOM") &&
        (commercialWashroomController.text.isEmpty ||
            double.parse(commercialWashroomController.text) <= 0)) {
      Get.snackbar(
        "Error",
        "Please enter number of washrooms",
      );
      return false;
    }

    if (shouldShowField("RECEPTION") &&
        selectedCommercialReceptionAreaCategory.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select reception area",
      );
      return false;
    }

    if (shouldShowField("TYPEOFSPACES") &&
        selectedCommercialTypeOfSpace.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select type of space",
      );
      return false;
    }

    if (shouldShowField("SHOPLOCATEDINSIDE") &&
        selectedCommercialShopLocatedInside.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select where the shop is located",
      );
      return false;
    }

    if (shouldShowField("PLOTLANDTYPE") &&
        selectedCommercialTypeOfPlotLand.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select plot/land type",
      );
      return false;
    }

    if (shouldShowField("TYPEOFSTORAGE") &&
        selectedCommercialTypeOfStorage.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select type of storage",
      );
      return false;
    }

    if (shouldShowField("PLOTAREA") &&
        (commercialPlotAreaController.text.isEmpty ||
            double.parse(commercialPlotAreaController.text) <= 0)) {
      Get.snackbar(
        "Error",
        "Please enter plot area",
      );
      return false;
    }

    if (shouldShowField("BUILDUP") &&
        (commercialBuildUpAreaController.text.isEmpty ||
            double.parse(commercialBuildUpAreaController.text) <= 0)) {
      Get.snackbar(
        "Error",
        "Please enter buildup area",
      );
      return false;
    }

    if (shouldShowField("CARPET") &&
        (commercialCarpetAreaController.text.isEmpty ||
            double.parse(commercialCarpetAreaController.text) <= 0)) {
      Get.snackbar(
        "Error",
        "Please enter carpet area",
      );
      return false;
    }

    if (shouldShowField("WIDTHOFFACINGROAD") &&
        (commercialWidthOfFacingRoadController.text.isEmpty ||
            double.parse(commercialWidthOfFacingRoadController.text) <= 0)) {
      Get.snackbar(
        "Error",
        "Please enter width of facing road",
      );
      return false;
    }

    if (shouldShowField("TOTALFLOOR") && selectedTotalFloor.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select total floors",
      );
      return false;
    }

    if (shouldShowField("PROPERTYFLOOR") &&
        selectedPropertyFloor.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select property floor",
      );
      return false;
    }

    if (shouldShowField("FACILITY") && furnishing.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select furnishing status",
      );
      return false;
    }

    if (shouldShowField("FIRESAFETY") && fireExtension.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select fire extension option",
      );
      return false;
    }

    if (shouldShowField("FIRESAFETY") && fireSprinklers.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select fire sprinklers option",
      );
      return false;
    }

    if (shouldShowField("FIRESAFETY") && fireSensors.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select fire sensors option",
      );
      return false;
    }

    if (shouldShowField("FIRESAFETY") && fireHose.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select fire hose option",
      );
      return false;
    }

    if (shouldShowField("AVAILABILITY") &&
        selectedCommercialAvailability.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select availability",
      );
      return false;
    }

    if (shouldShowField("PARKING") &&
        selectedCommercialParkingStatus.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select parking availability",
      );
      return false;
    }

    if (shouldShowField("PANTRY") &&
        selectedCommercialPantryTypeCategory.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select pantry type",
      );
      return false;
    }

    if (shouldShowField("STAIRCASE") &&
        commercialStairCaseController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter number of staircases",
      );
      return false;
    }

    if (shouldShowField("LIFT") && commercialLiftController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter number of lifts",
      );
      return false;
    }

    if (shouldShowField("PLOTFACING") &&
        selectedCommercialPlotFacing.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select plot facing direction",
      );
      return false;
    }

    if (shouldShowField("AGEOFPROPERTY") &&
        commercialAgeOfPropertyController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter age of property",
      );
      return false;
    }

    return true;
  }

  RxBool isLoading = false.obs;
  bool isCommercialDetailSubmitted = false;
  RxInt commercialId = 0.obs;

  Future<void> submitCommercialDetailStep1() async {
    if (!validateCommercialStep1Fields()) return;
    isCommercialDetailSubmitted = false;

    isLoading(true);
    try {
      final response =
          await commercialPostPropertyRepository.submitStep1CommercialDetail();
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
        isCommercialDetailSubmitted = true;

        int? commercialId = response["data"]?["data"]?["id"] as int?;
        if (commercialId != null && commercialId != 0) {
          storage.write("commercial_id", commercialId);
          AppLogger.log("Commercial Id Stored -->> $commercialId");
        }
        saveCommercialCurrentStep(2);

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
    );
  }

  void hideFullscreenLoader() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }


  /////////////////////// Commercial section step 2--------------------------------------------------------------------------

  List<City> commercialCityOptions = [];
  City? selectedCommercialCity;
  TextEditingController citySearchController = TextEditingController();

  Future<void> loadCityList() async {
    final cityListController = Get.find<CityList>(); // shared controller
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

  Future<void> submitCommercialDetailsStep2() async {
    isCommercialDetailSubmittedStep2 = false;
    if (selectedCommercialCity == null) {
      Get.snackbar(
        "Error",
        "Please select a City",
      );
      return;
    }
    if (commercialAreaController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter an Area",
      );
      return;
    }
    if (commercialSubLocalityController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a Sub Locality",
      );
      return;
    }
    if (commercialHouseNoController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a House No.",
      );
      return;
    }
    if (commercialZipCodeController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a Pin Code",
      );
      return;
    }

    if (commercialZipCodeController.text.length != 6) {
      Get.snackbar(
        "Error",
        "The Pin Field mus be 6 Character",
      );
      return;
    }

    isLoadingStep2(true);
    final response =
        await commercialPostPropertyRepository.submitStep2CommercialDetail(
            city: selectedCommercialCity?.name ?? "",
            area: commercialAreaController.text,
            subLocality: commercialSubLocalityController.text,
            houseNo: commercialHouseNoController.text,
            pin: commercialZipCodeController.text);

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
      isCommercialDetailSubmittedStep2 = true;
      String successMessage = response["data"]?["message"] ?? "";
      saveCommercialCurrentStep(3);
      AppLogger.log("success message -->>> $successMessage");
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isCommercialDetailSubmittedStep2 = false;
      String errorMessage =
          response["data"]?["message"] ?? "Something went wrong!";
      Get.snackbar(
        "Error",
        errorMessage,
      );
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
    selectedCommercialOwnerShipCategory.value =
        commercialOwnerShipCategories[displayValue] ?? "";
  }

  //////////////////-----Describe Property
  RxBool hasCommercialDescribePropertyFocus = false.obs;
  RxBool hasCommercialDescribePropertyInput = false.obs;
  FocusNode commercialDescribePropertyFocusNode = FocusNode();
  TextEditingController commercialDescribePropertyController =
      TextEditingController();

  RxBool isLoadingStep3 = false.obs;
  bool isCommercialDetailSubmittedStep3 = false;

  Future<void> submitCommercialDetailsStep3() async {
    isCommercialDetailSubmittedStep3 = false;

    if (commercialRentAmountController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter Rent Amount",
      );
      return;
    }
    if (selectedCommercialOwnerShipCategory.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select Owner Ship",
      );
      return;
    }
    if (commercialDescribePropertyController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please describe the property",
      );
      return;
    }

    isLoadingStep3(true);
    final response =
        await commercialPostPropertyRepository.submitStep3CommercialDetail(
            rentAmount: int.tryParse(commercialRentAmountController.text) ?? 0,
            uniquePropertyDescription:
                commercialDescribePropertyController.text,
            allInclusivePrice: boolToInt(allInclusivePrice.value),
            taxAndGovtChargesExcluded:
                boolToInt(taxAndGovtChargesExcluded.value),
            priceNegotiable: boolToInt(priceNegotiable.value),
            ownerShip: selectedCommercialOwnerShipCategory.value.toUpperCase());
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
      isCommercialDetailSubmittedStep3 = true;
      saveCommercialCurrentStep(4);
      int? commercialPropertyId = response["data"]?["data"]?["property_id"];
      if (commercialPropertyId != null) {
        storage.write("commercial_property_id", commercialPropertyId);
        AppLogger.log(
            "Stored Commercial property id -->>> $commercialPropertyId");
      }
      String successMessage = response["data"]?["message"] ??
          "PG Step 3 details submitted successfully!";
      AppLogger.log("Success message -->>> $successMessage");
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isCommercialDetailSubmittedStep3 = false;
      String errorMessage =
          response["data"]?["message"] ?? "Something went wrong!";
      Get.snackbar(
        "Error",
        errorMessage,
      );
    }
  }

  /////////////////////// Commercial section step 4--------------------------------------------------------------------------

  RxBool isLoadingStep4 = false.obs;
  bool isCommercialDetailSubmittedStep4 = false;

  Future<void> submitCommercialDetailsStep4Images(List<File> images) async {
    isCommercialDetailSubmittedStep4 = false;
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

    int? commercialPropertyId = storage.read("commercial_property_id");
    AppLogger.log(
        "📦 Read commercial_property_id from storage: $commercialPropertyId");
    if (commercialPropertyId == null || commercialPropertyId == 0) {
      AppLogger.log("❌ Invalid or missing property ID.");
      isLoadingStep4(false);
      Get.snackbar(
        "Error",
        "Invalid property ID. Please try again.",
      );
      return;
    }
    AppLogger.log(
        "🚀 Initiating Commercial image upload for Property ID: $commercialPropertyId with ${images.length} images.");
    final response =
        await commercialPostPropertyRepository.submitStep4CommercialImages(
      commercialPropertyId: 0,
      imageFiles: images,
    );

    AppLogger.log("📥 Received response from image upload: $response");

    isLoadingStep4(false);

    if (response["success"] == true) {
      isCommercialDetailSubmittedStep4 = true;
      storage.remove("commercial_id");
      storage.remove("commercial_property_id");
      AppLogger.log(
          " Cleared commercial_id and commercial_property_id from GetStorage");
      String successMessage =
          response["data"]?["message"] ?? "Images uploaded successfully!";
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);

      commercialResetStepProgress();
      Get.offNamed(AppRoutes.bottomBarView);
    } else {
      isCommercialDetailSubmittedStep4 = true;
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
    commercialRestoreLastStep();
    Future.delayed(const Duration(milliseconds: 500), () {
      commercialRedirectToSavedStep();
    });

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

    //////////////////////////step3

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
