import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:string_similarity/string_similarity.dart';

import '../api_service/print_logger.dart';
import '../configs/app_color.dart';
import '../configs/app_string.dart';
import '../model/city_model.dart';
import '../model/post_property_model.dart';
import '../repository/pg_post_edit_property_repo.dart';

class PGPostEditPropertyController extends GetxController {
  final PGPostEditPropertyRepository pgPostEditPropertyRepository =
      Get.find<PGPostEditPropertyRepository>();
  RxList<String> editPropertyTitleList = [
    AppString.basicDetails,
    AppString.propertyDetails,
    AppString.priceDetails,
    AppString.amenities,
  ].obs;

  RxList<String> editPropertySubtitleList = [
    AppString.basicDetailsString,
    AppString.propertyDetailsString,
    AppString.priceDetailsString,
    AppString.amenitiesString,
  ].obs;

  RxInt currentStep = 1.obs;

  ///////////////////////////////////------Pg Edit Section
  int? propertyLogId;
  int? propertyImageId;

  RxList<PropertyImage> alreadyUploadedImageUrls = <PropertyImage>[].obs;

  RxBool isSelecting = false.obs;
  RxSet<int> selectedImageIds = <int>{}.obs;

  RxBool hasEditPgNameFocus = false.obs;
  RxBool hasEditPgNameInput = false.obs;
  FocusNode editPgNameFocusNode = FocusNode();
  TextEditingController editPgNameController = TextEditingController();

  RxList<String> pgRoomOptions = ["Single", "Double", "Triple"].obs;

  Map<String, String> roomCodeToLabel = {
    "1": "Single",
    "2": "Double",
    "3": "Triple",
  };

  final Map<String, String> roomLabelToCode = {
    "Single": "1",
    "Double": "2",
    "Triple": "3",
  };

  RxString selectedPgRoom = "".obs;

  void updateSelectedPgRoom(String? value) {
    selectedPgRoom.value = value!;
  }

  Rxn<DateTime> selectedDate = Rxn<DateTime>();

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(), // Default: Today
      firstDate: DateTime(2000), // Minimum date
      lastDate: DateTime(2100), // Maximum date
    );

    if (pickedDate != null) {
      selectedDate.value = pickedDate;
    }
  }

  RxMap<String, String> pgCategories = {
    "Girls": "GIRLS",
    "Boys": "BOYS",
    "Coliving": "COLIVING",
    "Working Women": "WORKINGWOMEN",
    "Student": "STUDENT",
    "Any": "ANY"
  }.obs;

  RxString selectedPgCategory = "".obs;

  void updateSelectedPgCategory(String displayValue) {
    selectedPgCategory.value = pgCategories[displayValue] ?? "";
  }

  RxMap<String, String> houseRules = {
    "Visitor Entry": "16",
    "Non-Veg Food": "17",
    "Opposite Gender": "18",
    "Smoking": "19",
    "Drinking": "20",
    "Loud Music": "21",
    "Party": "22"
  }.obs;

  RxList<String> selectedHouseRulesValues = <String>[].obs;

  void toggleHouseRule(String rule) {
    if (selectedHouseRulesValues.contains(houseRules[rule])) {
      selectedHouseRulesValues.remove(houseRules[rule]);
    } else {
      selectedHouseRulesValues.add(houseRules[rule]!);
    }
  }

  RxMap<String, String> commonAmenities = {
    "Wifi": "1",
    "Power Backup": "2",
    "Room Cleaning Service": "3",
    "Parking": "4",
    "TV": "5",
    "Lift": "6",
    "Laundry": "7",
    "Gym": "8",
    "Fridge": "9",
    "Water Cooler RO": "10",
    "Warden": "11",
    "Microwave": "12",
    "Food Available": "13",
    "Meals Provided": "14",
    "Other": "15"
  }.obs;

  RxList<String> selectedCommonAmenitiesValues = <String>[].obs;

  void toggleCommonAmenities(String amenity) {
    if (selectedCommonAmenitiesValues.contains(commonAmenities[amenity])) {
      selectedCommonAmenitiesValues.remove(commonAmenities[amenity]);
    } else {
      selectedCommonAmenitiesValues.add(commonAmenities[amenity]!);
    }
  }

  RxMap<String, String> totalFloorOptions = {
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
    "25": "25"
  }.obs;

  RxString selectedTotalFloor = "".obs;

  void updateSelectedTotalFloor(String? value) {
    if (value != null && totalFloorOptions.containsKey(value)) {
      selectedTotalFloor.value = value;
    }
  }

  RxMap<String, String> propertyFloorOptions = {
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
    "25": "25"
  }.obs;

  RxString selectedPropertyFloor = "".obs;

  void updateSelectedPropertyFloor(String? value) {
    if (value != null && propertyFloorOptions.containsKey(value)) {
      selectedPropertyFloor.value = value;
    }
  }

  String? getBestMatchedCity(String inputCity, List<String> cityList) {
    final result = inputCity.bestMatch(cityList);
    final best = result.bestMatch;
    if (best.rating! > 0.7) {
      return best.target;
    }
    return null;
  }

  void setEditData(pgItem) {
    alreadyUploadedImageUrls.clear();
    alreadyUploadedImageUrls.addAll(pgItem.images);

    // for (var img in alreadyUploadedImageUrls) {
    //   AppLogger.log("Image ID Set edit : ${img.id}, ${img.propertyId}");
    // }

    editPgNameController.text = pgItem.feature?.pgName ?? '';
    selectedPgRoom.value =
        roomCodeToLabel[pgItem.feature?.roomSharing ?? ""] ?? "";
    if (pgItem.feature?.availabilityDate != null) {
      selectedDate.value = DateTime.tryParse(pgItem.feature!.availabilityDate!);
    }

    selectedPgCategory.value = pgItem.feature?.suitableFor ?? '';

    selectedHouseRulesValues.clear();
    selectedCommonAmenitiesValues.clear();
    final pgAmenities = pgItem.feature?.pgAmenities ?? '';
    final amentyIds = pgAmenities.split('|');
    for (var id in amentyIds) {
      if (houseRules.containsValue(id)) {
        selectedHouseRulesValues.add(id);
      } else if (commonAmenities.containsValue(id)) {
        selectedCommonAmenitiesValues.add(id);
      }
    }

    selectedTotalFloor.value = pgItem.feature?.noOfFloors.toString() ?? '';
    selectedPropertyFloor.value =
        pgItem.feature?.propertyOnFloor.toString() ?? '';
    propertyLogId = pgItem.propertyLogId;
    propertyImageId = pgItem.id;
    AppLogger.log("Property Image Id --->>>$propertyImageId");
    //////////////step 2
    final matchedCityName = getBestMatchedCity(
      pgItem.address.city.trim().toLowerCase() ?? '',
      pgCityOptions.map((e) => e.name.toLowerCase()).toList(),
    );
    selectedPgCity = pgCityOptions.firstWhereOrNull(
      (city) => city.name.toLowerCase() == matchedCityName,
    );
    AppLogger.log(
        "📌 Original: ${pgItem.address.city}, Matched: ${selectedPgCity?.name}");
    editPgSubLocalityController.text =
        pgItem.address.subLocality.toString() ?? '';
    editPgZipCodeController.text = pgItem.address.pin.toString() ?? '';
    editPgAreaController.text = pgItem.address.area.toString();
    editPgHouseNoController.text = pgItem.address.houseNo.toString() ?? '';

    // ✅ Step 3 data:
    editPgRentAmountController.text =
        pgItem.feature?.rentAmount.toString() ?? '';
    editPgDescribePropertyController.text = pgItem.description ?? '';

    electricityExcluded.value = pgItem.feature?.electricityExcluded == 1;
    waterExcluded.value = pgItem.feature?.waterExcluded == 1;
    priceNegotiable.value = pgItem.feature?.isNegotiable == 1;
  }

  RxBool isLoading = false.obs;
  bool isPgDetailSubmitted = false;
  RxInt pgId = 0.obs;

  Future<void> submitEditPgDetailsStep1() async {
    isPgDetailSubmitted = false;
    if (editPgNameController.text.isEmpty) {
      Get.snackbar("Error", "Please Enter Pg Name",
          backgroundColor: AppColor.red);
      return;
    }
    if (selectedPgRoom.value.isEmpty) {
      Get.snackbar("Error", "Please Select Room Type",
          backgroundColor: AppColor.red);
      return;
    }
    if (selectedDate.value == null) {
      Get.snackbar("Error", "Please select an Availability Date",
          backgroundColor: AppColor.red);
      return;
    }

    if (selectedPgCategory.value.isEmpty) {
      Get.snackbar("Error", "Please select suitable for",
          backgroundColor: AppColor.red);
      return;
    }
    if (selectedHouseRulesValues.isEmpty) {
      Get.snackbar("Error", "Please select at least one House Rule",
          backgroundColor: AppColor.red);
      return;
    }
    if (selectedCommonAmenitiesValues.isEmpty) {
      Get.snackbar("Error", "Please select at least one Common Amenity",
          backgroundColor: AppColor.red);
      return;
    }

    if (selectedTotalFloor.value.isEmpty) {
      Get.snackbar("Error", "Please select the Total Floors",
          backgroundColor: AppColor.red);
      return;
    }
    if (selectedPropertyFloor.value.isEmpty) {
      Get.snackbar("Error", "Please select the Property Floor",
          backgroundColor: AppColor.red);
      return;
    }

    isLoading(true);
    String formattedDate = selectedDate.value != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate.value!)
        : "";

    final response =
        await pgPostEditPropertyRepository.submitEditStep1PgDetails(
      roomType: pgRoomOptions.indexOf(selectedPgRoom.value) + 1,
      availabilityDate: formattedDate,
      suitableFor: selectedPgCategory.value.toUpperCase(),
      houseRules: selectedHouseRulesValues.map((e) => int.parse(e)).toList(),
      commonAmenities:
          selectedCommonAmenitiesValues.map((e) => int.parse(e)).toList(),
      totalFloors:
          int.parse(totalFloorOptions[selectedTotalFloor.value] ?? '0'),
      propertyFloors:
          int.parse(propertyFloorOptions[selectedPropertyFloor.value] ?? '0'),
      pgName: editPgNameController.text,
      propertyLogId: propertyLogId!,
    );
    isLoading(false);

    if (response["data"]?["status"] == 200) {
      isPgDetailSubmitted = true;
      AppLogger.log(" Full API Response: $response");
      String successMessage = response["data"]?["message"] ?? "PG details";

      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isPgDetailSubmitted = false;
      String errorMessage =
          response["data"]?["message"] ?? "Something went wrong!";
      Get.snackbar("Error", errorMessage, backgroundColor: AppColor.red);
    }
  }

  ///////////////////////////////////////----step2----------------------------
  List<City> pgCityOptions = [];
  City? selectedPgCity;

  Future<void> loadCityList() async {
    try {
      final response = await pgPostEditPropertyRepository.fetchEditCityList();
      AppLogger.log("🔍 API Response: $response");
      if (response["success"] == true && response["data"] != null) {
        List<dynamic> cityData = response["data"];
        pgCityOptions.clear();
        pgCityOptions
            .addAll((cityData.map((json) => City.fromJson(json)).toList()));
        AppLogger.log(
            "✅ City List Updated: ${pgCityOptions.length} cities loaded");
      } else {
        Get.snackbar("Error", response["message"] ?? "Unable to fetch cities");
      }
    } catch (e) {
      AppLogger.log("❌ Exception while fetching cities: $e");
      Get.snackbar("Error", "Failed to load city list");
    }
  }

  void updateSelectedPgCity(String? cityName) {
    final selectedCity =
        pgCityOptions.firstWhereOrNull((city) => city.name == cityName);
    if (selectedCity != null) {
      selectedPgCity = selectedCity;
      update();
      AppLogger.log("✅ City Selected: ${selectedPgCity!.name}");
    } else {
      AppLogger.log("❌ City not found in list");
    }
  }

  //////////////////-----Area
  RxBool hasEditPgAreaFocus = false.obs;
  RxBool hasEditPgAreaInput = false.obs;
  FocusNode editPgAreaFocusNode = FocusNode();
  TextEditingController editPgAreaController = TextEditingController();

  //////////////////-----SubLocality

  RxBool hasEditPgSubLocalityFocus = false.obs;
  RxBool hasEditPgSubLocalityInput = false.obs;
  FocusNode editPgSubLocalityFocusNode = FocusNode();
  TextEditingController editPgSubLocalityController = TextEditingController();

  //////////////////-----HouseNo

  RxBool hasEditPgHouseNoFocus = false.obs;
  RxBool hasEditPgHouseNoInput = false.obs;
  FocusNode editPgHouseNoFocusNode = FocusNode();
  TextEditingController editPgHouseNoController = TextEditingController();

//////////////////-----ZipCode

  RxBool hasEditPgZipCodeFocus = false.obs;
  RxBool hasEditPgZipCodeInput = false.obs;
  FocusNode editPgZipCodeFocusNode = FocusNode();
  TextEditingController editPgZipCodeController = TextEditingController();

  RxBool isLoadingStep2 = false.obs;
  bool isPgDetailSubmittedStep2 = false;

  Future<void> submitEditPgDetailsStep2() async {
    isPgDetailSubmittedStep2 = false;

    if (selectedPgCity == null) {
      Get.snackbar("Error", "Please select a City",
          backgroundColor: AppColor.red);
      return;
    }
    if (editPgAreaController.text.isEmpty) {
      Get.snackbar("Error", "Please enter an Area",
          backgroundColor: AppColor.red);
      return;
    }
    if (editPgSubLocalityController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a Sub Locality",
          backgroundColor: AppColor.red);
      return;
    }
    if (editPgHouseNoController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a House No.",
          backgroundColor: AppColor.red);
      return;
    }
    if (editPgZipCodeController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a Pin Code",
          backgroundColor: AppColor.red);
      return;
    }

    if (editPgZipCodeController.text.length != 6) {
      Get.snackbar("Error", "The Pin Field mus be 6 Character",
          backgroundColor: AppColor.red);
      return;
    }
    isLoadingStep2(true);
    final response =
        await pgPostEditPropertyRepository.submitEditStep2PgDetails(
            city: selectedPgCity?.name ?? '',
            area: editPgAreaController.text,
            subLocality: editPgSubLocalityController.text,
            houseNo: editPgHouseNoController.text,
            pin: editPgZipCodeController.text,
            propertyLogId: propertyLogId!);

    isLoadingStep2(false);
    AppLogger.log("🔍 Complete API Response --> $response");
    if (response["success"] == true) {
      isPgDetailSubmittedStep2 = true;
      String successMessage = response["data"]?["message"] ?? "";
      AppLogger.log("success message -->>> $successMessage");
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isPgDetailSubmittedStep2 = false;
      String errorMessage =
          response["data"]?["message"] ?? "Something went wrong!";
      Get.snackbar("Error", errorMessage, backgroundColor: AppColor.red);
    }
  }

  /////////////////////// pg section step 3--------------------------------------------------------------------------

//////////////////-----rentAmount
  RxBool hasEditPgRentAmountFocus = false.obs;
  RxBool hasEditPgRentAmountInput = false.obs;
  FocusNode editPgRentAmountFocusNode = FocusNode();
  TextEditingController editPgRentAmountController = TextEditingController();

  //////////////////-----describeProperty
  RxBool hasEditPgDescribePropertyFocus = false.obs;
  RxBool hasEditPgDescribePropertyInput = false.obs;
  FocusNode editPgDescribePropertyFocusNode = FocusNode();
  TextEditingController editPgDescribePropertyController =
      TextEditingController();

  RxBool electricityExcluded = false.obs;
  RxBool waterExcluded = false.obs;
  RxBool priceNegotiable = false.obs;

  int boolToInt(bool value) => value ? 1 : 0;
  RxBool isLoadingStep3 = false.obs;
  bool isPgDetailSubmittedStep3 = false;

  Future<void> submitEditPgDetailsStep3() async {
    isPgDetailSubmittedStep3 = false;

    if (editPgRentAmountController.text.isEmpty) {
      Get.snackbar("Error", "Please enter Rent Amount",
          backgroundColor: AppColor.red);
      return;
    }
    if (editPgDescribePropertyController.text.isEmpty) {
      Get.snackbar("Error", "Please describe the property",
          backgroundColor: AppColor.red);
      return;
    }

    isLoadingStep3(true);
    final response =
        await pgPostEditPropertyRepository.submitEditStep3PgDetails(
      rentAmount: int.parse(editPgRentAmountController.text),
      uniquePropertyDescription: editPgDescribePropertyController.text,
      electricityExcluded: boolToInt(electricityExcluded.value),
      waterExcluded: boolToInt(waterExcluded.value),
      isNegotiable: boolToInt(priceNegotiable.value),
      propertyLogId: propertyLogId!,
    );

    isLoadingStep3(false);
    AppLogger.log("🔍 Step 3 API Response --> $response");

    if (response["success"] == true) {
      isPgDetailSubmittedStep3 = true;
      String successMessage = response["data"]?["message"] ??
          "PG Step 3 details submitted successfully!";
      AppLogger.log("Success message -->>> $successMessage");
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isPgDetailSubmittedStep3 = false;
      String errorMessage =
          response["data"]?["message"] ?? "Something went wrong!";
      Get.snackbar("Error", errorMessage, backgroundColor: AppColor.red);
    }
  }

  /////////////////////// pg section step 4--------------------------------------------------------------------------

  RxBool isUploadingStep4 = false.obs;
  bool isPgDetailSubmittedStep4 = false;

  Future<void> submitEditStep4UploadImagesPgDetails(List<File> images) async {
    isPgDetailSubmittedStep4 = false;
    isUploadingStep4(true);

    if (images.isEmpty) {
      isUploadingStep4(false);
      Get.snackbar("Error", "Please select at least one image to upload.",
          backgroundColor: AppColor.red);
      return;
    }

    final response = await pgPostEditPropertyRepository.uploadEditStep4Images(
      propertyId: 0,
      imageFiles: images,
      propertyImageId: propertyImageId!,
    );

    isUploadingStep4(false);

    if (response["success"] == true) {
      isPgDetailSubmittedStep4 = true;
      String successMessage =
          response["data"]?["message"] ?? "Images uploaded successfully!";
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isPgDetailSubmittedStep4 = true;
      String errorMessage =
          response["message"] ?? "Something went wrong during image upload.";
      Get.snackbar("Error", errorMessage, backgroundColor: AppColor.red);
    }
  }

  //////----------------------------------delete images
  Future<void> deleteSelectedImages() async {
    if (selectedImageIds.isEmpty) {
      Get.snackbar(
        "Error",
        "No images selected for deletion.",
      );
      return;
    }

    if (propertyImageId == null) {
      Get.snackbar(
        "Error",
        "Missing property image ID.",
      );
      return;
    }

    final response =
        await pgPostEditPropertyRepository.deleteMultiplePropertyImages(
      propertyId: propertyImageId!,
      imageIds: selectedImageIds.toList(),
    );

    if (response["success"] == true) {
      Get.snackbar("Success", "Images deleted successfully.",
          backgroundColor: AppColor.green);

      alreadyUploadedImageUrls
          .removeWhere((img) => selectedImageIds.contains(img.id));
      selectedImageIds.clear();
      isSelecting.value = false;
    } else {
      Get.snackbar(
        "Error",
        response["message"] ?? "Failed to delete images.",
      );
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadCityList();

    editPgNameController.addListener(() {
      hasEditPgNameInput.value = editPgNameController.text.isNotEmpty;
    });

    editPgNameFocusNode.addListener(() {
      hasEditPgNameFocus.value = editPgNameFocusNode.hasFocus;
    });
    //////////////////////-----------------------step 2
    editPgAreaController.addListener(() {
      hasEditPgAreaInput.value = editPgAreaController.text.isNotEmpty;
    });

    editPgAreaFocusNode.addListener(() {
      hasEditPgAreaFocus.value = editPgAreaFocusNode.hasFocus;
    });

    editPgSubLocalityController.addListener(() {
      hasEditPgSubLocalityInput.value =
          editPgSubLocalityController.text.isNotEmpty;
    });

    editPgSubLocalityFocusNode.addListener(() {
      hasEditPgSubLocalityFocus.value = editPgSubLocalityFocusNode.hasFocus;
    });

    editPgHouseNoController.addListener(() {
      hasEditPgHouseNoInput.value = editPgHouseNoController.text.isNotEmpty;
    });

    editPgHouseNoFocusNode.addListener(() {
      hasEditPgHouseNoFocus.value = editPgHouseNoFocusNode.hasFocus;
    });

    editPgZipCodeController.addListener(() {
      hasEditPgZipCodeInput.value = editPgZipCodeController.text.isNotEmpty;
    });

    editPgZipCodeFocusNode.addListener(() {
      hasEditPgZipCodeFocus.value = editPgZipCodeFocusNode.hasFocus;
    });

    //////////////////////////step3

    editPgRentAmountController.addListener(() {
      hasEditPgRentAmountInput.value =
          editPgRentAmountController.text.isNotEmpty;
    });

    editPgRentAmountFocusNode.addListener(() {
      hasEditPgRentAmountFocus.value = editPgRentAmountFocusNode.hasFocus;
    });

    editPgDescribePropertyController.addListener(() {
      hasEditPgDescribePropertyInput.value =
          editPgDescribePropertyController.text.isNotEmpty;
    });

    editPgDescribePropertyFocusNode.addListener(() {
      hasEditPgDescribePropertyFocus.value =
          editPgDescribePropertyFocusNode.hasFocus;
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    editPgNameFocusNode.removeListener(() {});
    editPgNameController.removeListener(() {});
    editPgNameFocusNode.dispose();
    editPgNameController.dispose();

    /////////////////////step2///////

    editPgAreaFocusNode.removeListener(() {});
    editPgAreaController.removeListener(() {});
    editPgAreaFocusNode.dispose();
    editPgAreaController.dispose();

    editPgSubLocalityFocusNode.removeListener(() {});
    editPgSubLocalityController.removeListener(() {});
    editPgSubLocalityFocusNode.dispose();
    editPgSubLocalityController.dispose();

    editPgHouseNoFocusNode.removeListener(() {});
    editPgHouseNoController.removeListener(() {});
    editPgHouseNoFocusNode.dispose();
    editPgHouseNoController.dispose();

    editPgZipCodeFocusNode.removeListener(() {});
    editPgZipCodeController.removeListener(() {});
    editPgZipCodeFocusNode.dispose();
    editPgZipCodeController.dispose();

    /////////////////////step3///////
    editPgRentAmountFocusNode.removeListener(() {});
    editPgRentAmountController.removeListener(() {});
    editPgRentAmountFocusNode.dispose();
    editPgRentAmountController.dispose();

    editPgDescribePropertyFocusNode.removeListener(() {});
    editPgDescribePropertyController.removeListener(() {});
    editPgDescribePropertyFocusNode.dispose();
    editPgDescribePropertyController.dispose();
  }
}
