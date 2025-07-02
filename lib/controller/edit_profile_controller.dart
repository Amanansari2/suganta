import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tytil_realty/controller/profile_controller.dart';

import '../api_service/get_service.dart';
import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';
import '../model/city_model.dart';
import '../model/login_model.dart';
import '../model/state_model.dart';
import '../repository/edit_profile_repository.dart';
import 'fetch_state_list_controller.dart';

class EditProfileController extends GetxController {
  final PostService postService = Get.find<PostService>();
  EditProfileRepository repository = Get.find<EditProfileRepository>();
  ProfileController profileController = Get.find<ProfileController>();

  // Full Name
  RxBool hasFullNameFocus = false.obs;
  RxBool hasFullNameInput = false.obs;
  FocusNode fullNameFocusNode = FocusNode();
  TextEditingController fullNameController = TextEditingController();

  //  Deals On
  RxBool hasDealsOnFocus = false.obs;
  RxBool hasDealsOnInput = false.obs;
  FocusNode dealsOnFocusNode = FocusNode();
  TextEditingController dealsOnController = TextEditingController();

  //  Alternate Number
  RxBool hasAlternateNumberFocus = false.obs;
  RxBool hasAlternateNumberInput = false.obs;
  FocusNode alternateNumberFocusNode = FocusNode();
  TextEditingController alternateNumberController = TextEditingController();

  //  Office Name
  RxBool hasOfficeNameFocus = false.obs;
  RxBool hasOfficeNameInput = false.obs;
  FocusNode officeNameFocusNode = FocusNode();
  TextEditingController officeNameController = TextEditingController();

  // //  Address
  // RxBool hasAddressFocus = false.obs;
  // RxBool hasAddressInput = false.obs;
  // FocusNode addressFocusNode = FocusNode();
  // TextEditingController addressController = TextEditingController();

  // Country
  RxBool hasCountryFocus = false.obs;
  RxBool hasCountryInput = false.obs;
  FocusNode countryFocusNode = FocusNode();
  TextEditingController countryController = TextEditingController();

  // Area
  RxBool hasAreaFocus = false.obs;
  RxBool hasAreaInput = false.obs;
  FocusNode areaFocusNode = FocusNode();
  TextEditingController areaController = TextEditingController();

  // PinCode
  RxBool hasZipFocus = false.obs;
  RxBool hasZipInput = false.obs;
  FocusNode zipFocusNode = FocusNode();
  TextEditingController zipController = TextEditingController();

  TextEditingController aboutMeController = TextEditingController();

  TextEditingController stateSearchController = TextEditingController();
  TextEditingController citySearchController = TextEditingController();

  List<AppState> stateOptions = [];
  AppState? selectedState;

  Future<void> loadStateList() async {
    final stateListController = Get.find<StateList>();
    stateOptions.clear();
    stateOptions.addAll(stateListController.stateList);
    AppLogger.log("State Count: ${stateOptions.length} State");
  }

  void updateSelectedState(String? stateName) {
    final selectedSearchState =
        stateOptions.firstWhereOrNull((state) => state.name == stateName);
    if (selectedSearchState != null) {
      selectedState = selectedSearchState;
      cityOptions.clear();
      selectedCity = null;
      citySearchController.clear();
      fetchCityList(selectedSearchState.id);
      update();
      AppLogger.log("✅ State Selected: ${selectedState!.name}");
    } else {
      selectedState = null;
      cityOptions.clear();
      selectedCity = null;
      citySearchController.clear();
      update();
      AppLogger.log("❌ State not found in list");
    }
  }

  RxList<City> cityOptions = <City>[].obs;
  City? selectedCity;

  Future<void> fetchCityList(int id) async {
    AppLogger.log("Resetting City  list ...");
    cityOptions.clear();
    selectedCity = null;
    citySearchController.clear();
    update(['city_field']);
    try {
      final response = await postService.postRequest(
          url: getStateCityListUrl,
          body: {"state_id": id},
          requiresAuth: false);

      if (response["success"] == true && response["data"] != null) {
        final List<dynamic> data = response["data"]["data"];
        cityOptions.assignAll(data.map((e) => City.fromJson(e)).toList());
        citySearchController.clear();
        selectedCity = null;
        update(['city_field']);
        AppLogger.log("Cities loaded for $id : ${cityOptions.length}");
      } else {
        cityOptions.clear();
        selectedCity = null;
        update(['city_field']);
        AppLogger.log(
            " City load failed: ${response["message"] ?? "Unknown error"}");
      }
    } catch (e) {
      cityOptions.clear();
      selectedCity = null;
      update(['city_field']);
      AppLogger.log("Exception in City load: $e");
    }
  }

  //Gender
  RxInt selectedGender = 1.obs;

  void selectGender(int index) {
    if (index == 1 || index == 2 || index == 3) {
      selectedGender.value = index;
    }
  }

  //Images
  RxString profileImagePath = ''.obs;
  Rx<Uint8List?> webImage = Rx<Uint8List?>(null);
  RxString profileImage = "".obs;

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> updateProfileImage() async {
    try {
      PermissionStatus permissionStatus = PermissionStatus.denied;
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          permissionStatus = await Permission.storage.request();
        } else {
          permissionStatus = await Permission.photos.request();
        }
      } else {
        permissionStatus = await Permission.photos.request();
      }
      if (permissionStatus.isGranted) {
        final image = await _imagePicker.pickImage(source: ImageSource.gallery);
        if (image == null) return;
        profileImage.value = image.path;
      } else if (permissionStatus.isDenied) {
        Get.defaultDialog(
          title: "Permission Denied",
          middleText: "Permission denied. Please allow access in settings.",
          textConfirm: "OK",
          onConfirm: () => Get.back(),
        );
      } else if (permissionStatus.isPermanentlyDenied) {
        Get.defaultDialog(
          title: "Permission Required",
          middleText:
              "Permission permanently denied. Please enable it from app settings.",
          textConfirm: "Open Settings",
          textCancel: "Cancel",
          onConfirm: () {
            openAppSettings();
            Get.back();
          },
        );
      }
    } on PlatformException catch (e) {
      Get.defaultDialog(
        title: "Error",
        middleText: "${"failed_to_pick".tr}:\n$e",
        textConfirm: "OK",
        onConfirm: () => Get.back(),
      );
    }
  }

  void setEditProfileData(LoginModel user) {
    AppLogger.log("⚠️ Prefill Triggered with: ${user.toJson()}");
    fullNameController.text = user.name;
    alternateNumberController.text = user.alternateMno ?? '';
    dealsOnController.text = user.dealsOn ?? '';
    officeNameController.text = user.officeName ?? '';
    // addressController.text = user.address ?? '';
    aboutMeController.text = user.aboutUs ?? '';

    // Image
    profileImagePath.value = user.image ?? '';

    // Gender
    int genderValue = int.tryParse(user.gender ?? '1') ?? 1;
    selectedGender.value = genderValue;

    areaController.text = user.area ?? '';
    zipController.text = user.pinCode.toString() ?? '';

    if (user.stateId != null) {
      final matechedState =
          stateOptions.firstWhereOrNull((s) => s.id == user.stateId);
      if (matechedState != null) {
        selectedState = matechedState;
        stateSearchController.text = matechedState.name;
        fetchCityList(matechedState.id).then((_) {
          if (user.cityId != null) {
            final matchedCity =
                cityOptions.firstWhereOrNull((c) => c.id == user.cityId);
            if (matchedCity != null) {
              selectedCity = matchedCity;
              citySearchController.text = matchedCity.name;
            }
          }
          update();
        });
      }
    }

    update();
  }

  Future<void> updateProfile() async {
    if (!validateInputs()) return;

    String? imagePath =
        profileImage.value.isNotEmpty ? profileImage.value : null;

    final response = await repository.updateProfile(
        name: fullNameController.text.trim(),
        alternateNumber: alternateNumberController.text.trim(),
        gender: selectedGender.value.toString(),
        dealsOn: dealsOnController.text.trim(),
        officeName: officeNameController.text.trim(),
        aboutUs: aboutMeController.text.trim(),
        // address: addressController.text.trim(),
        imagePath: imagePath,
        country: 'india',
        area: areaController.text,
        city: selectedCity!.id.toInt(),
        pinCode: zipController.text.trim(),
        state: selectedState!.id.toInt());
    if (response["success"] == true) {
      Get.rawSnackbar(
          title: "Success",
          message: response["message"],
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP);

      await fetchAndUpdateProfile();
    } else {
      Get.rawSnackbar(
          title: "Error",
          message: response["message"],
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> fetchAndUpdateProfile() async {
    final response =
        await GetService.getRequest(url: getUserProfileUrl, requiresAuth: true);

    if (response["success"] == true && response.containsKey("data")) {
      final userData = response["data"];
      profileController.storage.write("user_data", userData);
      profileController.user.value = LoginModel.fromJson(userData);
      AppLogger.log("Profile Update in Get Storage : $userData");
    } else {
      AppLogger.log(
          " Failed to update GetStorage with latest profile. Response -->> $response");
    }
  }

  bool validateInputs() {
    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Full Name is required!");
      return false;
    }

    if (alternateNumberController.text.trim().isEmpty ||
        alternateNumberController.text.trim().length < 10 ||
        alternateNumberController.text.trim().length > 15) {
      Get.snackbar(
          "Error", "Alternate Number must be between 10 to 15 digits!");
      return false;
    }

    if (dealsOnController.text.trim().isEmpty) {
      Get.snackbar("Error", "Deals On is required!");
      return false;
    }

    if (officeNameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Office Name is required!");
      return false;
    }
    if (selectedState == null) {
      Get.snackbar("Error", "Please select a State!");
      return false;
    }
    if (selectedCity == null) {
      Get.snackbar("Error", "Please select a City!");
      return false;
    }
    if (areaController.text.trim().isEmpty) {
      Get.snackbar("Error", "Area is required!");
      return false;
    }

    final zip = zipController.text.trim();
    if (zip.isEmpty ||
        zip.length != 6 ||
        !RegExp(r'^[0-9]{6}$').hasMatch(zip)) {
      Get.snackbar("Error", "Zip Code must be exactly 6 digits!");
      return false;
    }

    // if (addressController.text.trim().isEmpty) {
    //   Get.snackbar("Error", "Address is required!");
    //   return false;
    // }

    return true;
  }

  @override
  void onInit() {
    super.onInit();

    loadStateList().then((_) {
      final user = profileController.user.value;
      if (user != null) {
        AppLogger.log("✅ user is already available, setting profile data...");
        setEditProfileData(user);
      } else {
        AppLogger.log("🕒 user is not ready yet, waiting...");
        ever(profileController.user, (LoginModel? user) {
          if (user != null) {
            AppLogger.log("✅ user updated — calling setEditProfileData...");
            setEditProfileData(user);
          }
        });
      }
    });

    // Full Name
    fullNameFocusNode.addListener(() {
      hasFullNameFocus.value = fullNameFocusNode.hasFocus;
    });
    fullNameController.addListener(() {
      hasFullNameInput.value = fullNameController.text.isNotEmpty;
    });

    // Deals On
    dealsOnFocusNode.addListener(() {
      hasDealsOnFocus.value = dealsOnFocusNode.hasFocus;
    });
    dealsOnController.addListener(() {
      hasDealsOnInput.value = dealsOnController.text.isNotEmpty;
    });

    // Alternate Number
    alternateNumberFocusNode.addListener(() {
      hasAlternateNumberFocus.value = alternateNumberFocusNode.hasFocus;
    });
    alternateNumberController.addListener(() {
      hasAlternateNumberInput.value = alternateNumberController.text.isNotEmpty;
    });

    // Office Name
    officeNameFocusNode.addListener(() {
      hasOfficeNameFocus.value = officeNameFocusNode.hasFocus;
    });
    officeNameController.addListener(() {
      hasOfficeNameInput.value = officeNameController.text.isNotEmpty;
    });

    // Address
    // addressFocusNode.addListener(() {
    //   hasAddressFocus.value = addressFocusNode.hasFocus;
    // });
    // addressController.addListener(() {
    //   hasAddressInput.value = addressController.text.isNotEmpty;
    // });

    // Area
    areaFocusNode.addListener(() {
      hasAreaFocus.value = areaFocusNode.hasFocus;
    });
    areaController.addListener(() {
      hasAreaInput.value = areaController.text.isNotEmpty;
    });

    // Zip
    zipFocusNode.addListener(() {
      hasZipFocus.value = zipFocusNode.hasFocus;
    });
    zipController.addListener(() {
      hasZipInput.value = zipController.text.isNotEmpty;
    });
  }

  @override
  void onClose() {
    fullNameFocusNode.dispose();
    dealsOnFocusNode.dispose();
    alternateNumberFocusNode.dispose();
    officeNameFocusNode.dispose();
    // addressFocusNode.dispose();
    areaFocusNode.dispose();
    zipFocusNode.dispose();

    fullNameController.dispose();
    dealsOnController.dispose();
    alternateNumberController.dispose();
    officeNameController.dispose();
    // addressController.dispose();
    areaController.dispose();
    zipController.dispose();
    aboutMeController.dispose();
    stateSearchController.dispose();
    citySearchController.dispose();

    super.onClose();
  }
}
