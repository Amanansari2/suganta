import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api_service/print_logger.dart';
import '../configs/app_color.dart';
import '../configs/app_string.dart';
import '../model/city_model.dart';
import '../repository/pg_post_property_repo.dart';
import '../routes/app_routes.dart';
import 'fetch_city_list_controller.dart';

class PGPostPropertyController extends GetxController {

  final PGPostPropertyRepository pgPostRepository = Get.find<PGPostPropertyRepository>();

  RxInt currentStep = 1.obs;
  void saveCurrentStep(int step) {
    storage.write("pg_step", step);
    currentStep.value = step;
  }

  void restoreLastStep() {
    currentStep.value = storage.read("pg_step") ?? 1;
  }

  void resetStepProgress() {
    storage.remove("pg_step");
    currentStep.value = 1;
  }


  RxInt selectPropertyLooking = 0.obs;
  RxInt selectCategories = 0.obs;
  RxInt selectPropertyType = 0.obs;



  ////////////////////////////////////// TABS VALUE ----
  bool get isBuySelected => selectPropertyLooking.value == 0;
  bool get isRentSelected => selectPropertyLooking.value == 1;
  bool get isPGSelected => selectPropertyLooking.value == 2;



  /////////////////////// pg section step 1--------------------------------------------------------------------------
  RxBool hasPgNameFocus = false.obs;
  RxBool hasPgNameInput = false.obs;
  FocusNode pgNameFocusNode = FocusNode();
  TextEditingController pgNameController = TextEditingController();

  /////--dropdown for select room type----

  RxList<String> pgRoomOptions = ["Single", "Double", "Triple"].obs;

  RxString selectedPgRoom = "".obs;

  void updateSelectedPgRoom(String? value){
    selectedPgRoom.value = value!;
  }



  /////--calender----
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

  ///----suitable for radio button
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

  RxString selectedTotalFloor = "".obs;


  void updateSelectedTotalFloor(String? value) {
    if (value != null && totalFloorOptions.containsKey(value)) {
      selectedTotalFloor.value = value;
    }

  }

  ////property floors
  RxMap<String, String> propertyFloorOptions = {
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
    "25": "25"}.obs;

  RxString selectedPropertyFloor = "".obs;

  void updateSelectedPropertyFloor(String? value){
    if (value != null && propertyFloorOptions.containsKey(value)) {
      selectedPropertyFloor.value = value;
    }
  }

  ////step1 PG Section
  RxBool isLoading = false.obs;
  bool isPgDetailSubmitted = false;
  RxInt pgId = 0.obs;
  final storage = GetStorage();

  Future<void> submitPgDetailsStep1() async {
    isPgDetailSubmitted = false;
    if(pgNameController.text.isEmpty){
      Get.snackbar("Error", "Please Enter Pg Name", backgroundColor: AppColor.red);
      return;
    }
    if(selectedPgRoom.value.isEmpty){
      Get.snackbar("Error", "Please Select Room Type", backgroundColor: AppColor.red);
      return;
    }
    if (selectedDate.value == null) {
      Get.snackbar("Error", "Please select an Availability Date", backgroundColor: AppColor.red);
      return;
    }

    if (selectedPgCategory.value.isEmpty) {
      Get.snackbar("Error", "Please select suitable for", backgroundColor: AppColor.red);
      return;
    }
    if (selectedHouseRulesValues.isEmpty) {
      Get.snackbar("Error", "Please select at least one House Rule", backgroundColor: AppColor.red);
      return;
    }
    if (selectedCommonAmenitiesValues.isEmpty) {
      Get.snackbar("Error", "Please select at least one Common Amenity", backgroundColor: AppColor.red);
      return;
    }

    if (selectedTotalFloor.value.isEmpty) {
      Get.snackbar("Error", "Please select the Total Floors", backgroundColor: AppColor.red);
      return;
    }
    if (selectedPropertyFloor.value.isEmpty) {
      Get.snackbar("Error", "Please select the Property Floor", backgroundColor: AppColor.red);
      return;
    }




    isLoading(true);
    String formattedDate = selectedDate.value != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate.value!)
        : "";



    final response = await pgPostRepository.submitStep1PgDetails(
      roomType: pgRoomOptions.indexOf(selectedPgRoom.value) + 1,
      availabilityDate:  formattedDate,
      suitableFor: selectedPgCategory.value.toUpperCase(),
      houseRules: selectedHouseRulesValues.map((e) => int.parse(e)).toList(),
      commonAmenities: selectedCommonAmenitiesValues.map((e)=> int.parse(e)).toList(),
      totalFloors: int.parse(totalFloorOptions[selectedTotalFloor.value] ?? '0'),
      propertyFloors: int.parse(propertyFloorOptions[selectedPropertyFloor.value] ?? '0'),
      pgName: pgNameController.text,
    );
    isLoading(false);


    final responseMessage = response["data"]?["message"]?.toString().trim() ?? "";

    if (responseMessage == "Your free listing limit has been completed. Please top up your wallet.") {
      Get.snackbar("Notice", responseMessage,);
      showFullscreenLoader();
      await Future.delayed(const Duration(seconds: 4));

      await launchUrl(
        Uri.parse("https://www.tytil.com/payment/topup"),
        mode: LaunchMode.externalApplication,
      );
      hideFullscreenLoader();
      return;
    }


    if (response["data"]?["status"] == 200) {
      isPgDetailSubmitted = true;
      AppLogger.log("🔍 Full API Response: $response");

       int? pgId = response["data"]?["data"]?["id"] as int?;
      AppLogger.log("🔍 Manually Extracted PG ID: $pgId");
      if(pgId != null && pgId != 0 ){
        storage.write("pg_id", pgId);
        AppLogger.log(" PG ID Stored in GetStorage: ${storage.read("pg_id")}");
      }
      saveCurrentStep(2);

      String successMessage = response["data"]?["message"] ?? "PG details";
      
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isPgDetailSubmitted = false;
      String errorMessage = response["data"]?["message"] ?? "Something went wrong!";
      Get.snackbar("Error", errorMessage, backgroundColor: AppColor.red);
    }
  }




  void updatePropertyLooking(int index) {
    selectPropertyLooking.value = index;
    update();
  }



  RxList<String> propertyLookingList = [
    AppString.residential,
    AppString.commercial,
    AppString.pg,
    AppString.project
  ].obs;





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




      /////////////////////// pg section step 2--------------------------------------------------------------------------


  List<City> pgCityOptions = [];
  City? selectedPgCity;



  Future<void> loadCityList() async {
    final cityListController = Get.find<CityList>();
    pgCityOptions.clear();
    pgCityOptions.addAll(cityListController.cityList);
    AppLogger.log(" PG City List Loaded from Shared Controller: ${pgCityOptions.length} cities");
  }


  void updateSelectedPgCity(String? cityName) {
    final selectedCity = pgCityOptions.firstWhereOrNull((city) => city.name == cityName);
    if (selectedCity != null) {
      selectedPgCity = selectedCity;
      update();
      AppLogger.log("✅ City Selected: ${selectedPgCity!.name}");
    } else {
      AppLogger.log("❌ City not found in list");
    }
  }




//////////////////-----Area
  RxBool hasPgAreaFocus = false.obs;
  RxBool hasPgAreaInput = false.obs;
  FocusNode pgAreaFocusNode = FocusNode();
  TextEditingController pgAreaController = TextEditingController();


  //////////////////-----SubLocality

  RxBool hasPgSubLocalityFocus = false.obs;
  RxBool hasPgSubLocalityInput = false.obs;
  FocusNode pgSubLocalityFocusNode = FocusNode();
  TextEditingController pgSubLocalityController = TextEditingController();


  //////////////////-----HouseNo

  RxBool hasPgHouseNoFocus = false.obs;
  RxBool hasPgHouseNoInput = false.obs;
  FocusNode pgHouseNoFocusNode = FocusNode();
  TextEditingController pgHouseNoController = TextEditingController();


//////////////////-----ZipCode

  RxBool hasPgZipCodeFocus = false.obs;
  RxBool hasPgZipCodeInput = false.obs;
  FocusNode pgZipCodeFocusNode = FocusNode();
  TextEditingController pgZipCodeController = TextEditingController();


  RxBool isLoadingStep2 = false.obs;
  bool isPgDetailSubmittedStep2 = false;


  Future<void> submitPgDetailsStep2() async {
    isPgDetailSubmittedStep2 = false;

    if (selectedPgCity == null) {
      Get.snackbar("Error", "Please select a City", backgroundColor: AppColor.red);
      return;
    }
    if (pgAreaController.text.isEmpty) {
      Get.snackbar("Error", "Please enter an Area", backgroundColor: AppColor.red);
      return;
    }
    if (pgSubLocalityController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a Sub Locality", backgroundColor: AppColor.red);
      return;
    }
    if (pgHouseNoController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a House No.", backgroundColor: AppColor.red);
      return;
    }
    if (pgZipCodeController.text.isEmpty ) {
      Get.snackbar("Error", "Please enter a Pin Code", backgroundColor: AppColor.red);
      return;
    }

    if( pgZipCodeController.text.length != 6){
      Get.snackbar("Error", "The Pin Field mus be 6 Character", backgroundColor: AppColor.red);
      return;
    }
    isLoadingStep2(true);
    final response = await pgPostRepository.submitStep2PgDetails(
      city: selectedPgCity?.name ?? '',
      area: pgAreaController.text,
      subLocality: pgSubLocalityController.text,
      houseNo: pgHouseNoController.text,
      pin: pgZipCodeController.text,
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
    if (response  ["success"] == true){//["data"]?["status"] == 200) {
      isPgDetailSubmittedStep2 = true;
      String successMessage = response["data"]?["message"]?? "";
      saveCurrentStep(3);
      AppLogger.log("success message -->>> $successMessage");
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isPgDetailSubmittedStep2 = false;
      String errorMessage = response["data"]?["message"] ?? "Something went wrong!";
      Get.snackbar("Error", errorMessage, backgroundColor: AppColor.red);
    }
  }



  /////////////////////// pg section step 3--------------------------------------------------------------------------

//////////////////-----rentAmount
  RxBool hasPgRentAmountFocus = false.obs;
  RxBool hasPgRentAmountInput = false.obs;
  FocusNode pgRentAmountFocusNode = FocusNode();
  TextEditingController pgRentAmountController = TextEditingController();


  //////////////////-----describeProperty
  RxBool hasPgDescribePropertyFocus = false.obs;
  RxBool hasPgDescribePropertyInput = false.obs;
  FocusNode pgDescribePropertyFocusNode = FocusNode();
  TextEditingController pgDescribePropertyController = TextEditingController();

  RxBool electricityExcluded = false.obs;
  RxBool waterExcluded = false.obs;
  RxBool priceNegotiable = false.obs;

  int boolToInt(bool value) => value ? 1 : 0;

  RxBool isLoadingStep3 = false.obs;
  bool isPgDetailSubmittedStep3 = false;

  Future<void> submitPgDetailsStep3() async {
    isPgDetailSubmittedStep3 = false;

    if (pgRentAmountController.text.isEmpty) {
      Get.snackbar("Error", "Please enter Rent Amount", backgroundColor: AppColor.red);
      return;
    }
    if (pgDescribePropertyController.text.isEmpty) {
      Get.snackbar("Error", "Please describe the property", backgroundColor: AppColor.red);
      return;
    }

    isLoadingStep3(true);
    final response = await pgPostRepository.submitStep3PgDetails(
      rentAmount: int.parse(pgRentAmountController.text),
      uniquePropertyDescription: pgDescribePropertyController.text,
      electricityExcluded: boolToInt(electricityExcluded.value),
      waterExcluded: boolToInt(waterExcluded.value),
      isNegotiable: boolToInt(priceNegotiable.value),
    );

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
    AppLogger.log("🔍 Step 3 API Response --> $response");

    if (response["success"] == true) {
      isPgDetailSubmittedStep3 = true;

      saveCurrentStep(4);
      int? propertyId = response["data"]?["data"]?["property_id"];
      if(propertyId!= null){
        storage.write("property_id", propertyId);
        AppLogger.log("Stored property_id--->>>  $propertyId");
      }
      // resetStepProgress();
      // print("Data reset for step in get storage--->>>> ");
      String successMessage = response["data"]?["message"] ?? "PG Step 3 details submitted successfully!";
      AppLogger.log("Success message -->>> $successMessage");
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);
    } else {
      isPgDetailSubmittedStep3 = false;
      String errorMessage = response["data"]?["message"] ?? "Something went wrong!";
      Get.snackbar("Error", errorMessage, backgroundColor: AppColor.red);
    }
  }


  /////////////////////// pg section step 4--------------------------------------------------------------------------


  RxBool isUploadingStep4 = false.obs;
  bool isPgDetailSubmittedStep4 = false;

  Future<void> submitStep4UploadImagesPgDetails(List<File> images) async {
    isPgDetailSubmittedStep4 = false;
    isUploadingStep4(true);

    if (images.isEmpty) {
      isUploadingStep4(false);
      Get.snackbar("Error", "Please select at least one image to upload.", backgroundColor: AppColor.red);
      return;
    }

    final response = await pgPostRepository.uploadStep4Images(
      propertyId: 0, // dummy, actual ID is fetched from storage in repo
      imageFiles: images,
    );

    isUploadingStep4(false);

    if (response["success"] == true) {
      isPgDetailSubmittedStep4 = true;
      storage.remove("pg_id");
      storage.remove("property_id");
      AppLogger.log("🧹 Cleared pg_id and property_id from GetStorage");
      String successMessage = response["data"]?["message"] ?? "Images uploaded successfully!";
      Get.snackbar("Success", successMessage, backgroundColor: AppColor.green);

      resetStepProgress();
      Get.offNamed(AppRoutes.bottomBarView);
    } else {
      isPgDetailSubmittedStep4 = true;
      String errorMessage = response["message"] ?? "Something went wrong during image upload.";
      Get.snackbar("Error", errorMessage, backgroundColor: AppColor.red);
    }
  }



  void redirectToSavedStep() {
    int savedStep = storage.read("pg_step") ?? 1;
    currentStep.value = savedStep;
  }

  @override
  void onInit() {
    super.onInit();
    loadCityList();
    restoreLastStep();
    Future.delayed(const Duration(milliseconds: 500), () {
      redirectToSavedStep();
    });



    selectedHouseRulesValues.clear();
    selectedCommonAmenitiesValues.clear();


    pgNameController.addListener((){
      hasPgNameInput.value = pgNameController.text.isNotEmpty;
    });

    pgNameFocusNode.addListener((){
      hasPgNameFocus.value= pgNameFocusNode.hasFocus;
    });

//////////////////////////step2

    pgAreaController.addListener((){
      hasPgAreaInput.value = pgAreaController.text.isNotEmpty;
    });

    pgAreaFocusNode.addListener((){
      hasPgAreaFocus.value= pgAreaFocusNode.hasFocus;
    });


    pgSubLocalityController.addListener((){
      hasPgSubLocalityInput.value = pgSubLocalityController.text.isNotEmpty;
    });

    pgSubLocalityFocusNode.addListener((){
      hasPgSubLocalityFocus.value= pgSubLocalityFocusNode.hasFocus;
    });


    pgHouseNoController.addListener((){
      hasPgHouseNoInput.value = pgHouseNoController.text.isNotEmpty;
    });

    pgHouseNoFocusNode.addListener((){
      hasPgHouseNoFocus.value= pgHouseNoFocusNode.hasFocus;
    });

    pgZipCodeController.addListener((){
      hasPgZipCodeInput.value = pgZipCodeController.text.isNotEmpty;
    });

    pgZipCodeFocusNode.addListener((){
      hasPgZipCodeFocus.value= pgZipCodeFocusNode.hasFocus;
    });

    //////////////////////////step3

    pgRentAmountController.addListener((){
      hasPgRentAmountInput.value = pgRentAmountController.text.isNotEmpty;
    });

    pgRentAmountFocusNode.addListener((){
      hasPgRentAmountFocus.value= pgRentAmountFocusNode.hasFocus;
    });

    pgDescribePropertyController.addListener((){
      hasPgDescribePropertyInput.value = pgDescribePropertyController.text.isNotEmpty;
    });

    pgDescribePropertyFocusNode.addListener((){
      hasPgDescribePropertyFocus.value= pgDescribePropertyFocusNode.hasFocus;
    });
  }




  @override
  void onClose() {


    // pgNameFocusNode.removeListener((){});
    // pgNameController.removeListener((){});
    pgNameFocusNode.dispose();
    pgNameController.dispose();
    /////////////////////step2///////


      // pgAreaFocusNode.removeListener(() {});
      // pgAreaController.removeListener(() {});
      pgAreaFocusNode.dispose();
      pgAreaController.dispose();





      // pgSubLocalityFocusNode.removeListener(() {});
      // pgSubLocalityController.removeListener(() {});
      pgSubLocalityFocusNode.dispose();
      pgSubLocalityController.dispose();

    // pgHouseNoFocusNode.removeListener((){});
    // pgHouseNoController.removeListener((){});
    pgHouseNoFocusNode.dispose();
    pgHouseNoController.dispose();

    // pgZipCodeFocusNode.removeListener((){});
    // pgZipCodeController.removeListener((){});
    pgZipCodeFocusNode.dispose();
    pgZipCodeController.dispose();

    /////////////////////step3///////
    // pgRentAmountFocusNode.removeListener((){});
    // pgRentAmountController.removeListener((){});
    pgRentAmountFocusNode.dispose();
    pgRentAmountController.dispose();

    // pgDescribePropertyFocusNode.removeListener((){});
    // pgDescribePropertyController.removeListener((){});
    pgDescribePropertyFocusNode.dispose();
    pgDescribePropertyController.dispose();
    super.onClose();
  }
}


