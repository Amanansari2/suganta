import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/app_string.dart';

class AddPropertyDetailsController extends GetxController {
  TextEditingController cityController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController subLocalityController = TextEditingController();
  TextEditingController plotAreaController = TextEditingController();
  TextEditingController totalFloorsController = TextEditingController();

  RxInt selectRoom1 = 0.obs;
  RxInt selectRoom2 = 0.obs;
  RxInt selectBedRoom = 0.obs;
  RxInt selectBathRoom = 0.obs;
  RxInt selectBalconies = 0.obs;
  RxInt selectStatus = 0.obs;
  RxInt count = 1.obs;
  RxInt countOpen = 1.obs;
  RxString selectedButton = ''.obs;
  RxString selectedOpenButton = ''.obs;
  RxBool isCityFilled = false.obs;

  void onCityChanged(String value) {
    isCityFilled.value = value.isNotEmpty;
  }

  void updateRoom1(int index) {
    selectRoom1.value = index;
  }

  void updateRoom2(int index) {
    selectRoom2.value = index;
  }

  void updateBedRoom(int index) {
    selectBedRoom.value = index;
  }

  void updateBathRoom(int index) {
    selectBathRoom.value = index;
  }

  void updateBalconies(int index) {
    selectBalconies.value = index;
  }

  void updateStatus(int index) {
    selectStatus.value = index;
  }

  void increment() {
    count++;
    selectedButton.value = AppString.plusText;
  }

  void decrement() {
    if (count > 0) {
      count--;
      selectedButton.value = AppString.minusText;
    }
  }

  void incrementOpen() {
    countOpen++;
    selectedOpenButton.value = AppString.plusText;
  }

  void decrementOpen() {
    if (countOpen > 0) {
      countOpen--;
      selectedOpenButton.value = AppString.minusText;
    }
  }

  RxList<String> otherRoomList1 = [
    AppString.addPoojaRooms,
    AppString.addStudyRooms,
  ].obs;

  RxList<String> otherRoomList2 = [
    AppString.addServantRooms,
    AppString.addOthers,
  ].obs;

  RxList<String> bedRoomList = [
    AppString.numeric1,
    AppString.numeric2,
    AppString.numeric3,
    AppString.numeric4,
    AppString.numeric5,
    AppString.numeric6,
    AppString.more,
  ].obs;

  RxList<String> bathRoomsList = [
    AppString.numeric1,
    AppString.numeric2,
    AppString.numeric3,
    AppString.numeric4,
    AppString.more,
  ].obs;

  RxList<String> balconiesList = [
    AppString.numeric0,
    AppString.numeric1,
    AppString.numeric2,
    AppString.numeric3,
    AppString.numeric4,
    AppString.more,
  ].obs;

  RxList<String> availabilityStatusList = [
    AppString.readyToMove,
    AppString.underConstruction,
  ].obs;

  @override
  void dispose() {
    super.dispose();
    cityController.clear();
    localityController.clear();
    subLocalityController.clear();
    plotAreaController.clear();
    totalFloorsController.clear();
  }
}