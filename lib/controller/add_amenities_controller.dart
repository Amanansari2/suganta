import 'package:get/get.dart';

import '../configs/app_string.dart';

class AddAmenitiesController extends GetxController {
  RxInt selectAmenities = 0.obs;
  RxInt selectWaterSource = 0.obs;
  RxInt selectOtherFeatures = 0.obs;
  RxInt selectLocationAdvantages = 0.obs;

  void updateAmenities(int index) {
    selectAmenities.value = index;
  }

  void updateWaterSource(int index) {
    selectWaterSource.value = index;
  }

  void updateOtherFeatures(int index) {
    selectOtherFeatures.value = index;
  }

  void updateLocationAdvantages(int index) {
    selectLocationAdvantages.value = index;
  }

  RxList<String> amenitiesList = [
    AppString.maintenanceStaff,
    AppString.waterStorage,
    AppString.security,
    AppString.visitorParking,
    AppString.fengVaastuCompliant,
    AppString.park,
    AppString.intercomFacility,
    AppString.lifts,
  ].obs;

  RxList<String> waterSourceList = [
    AppString.addMunicipalCorporation,
    AppString.water247,
    AppString.borwellTank,
  ].obs;

  RxList<String> otherFeaturesList = [
    AppString.inAGatedSociety,
    AppString.cornerProperty,
  ].obs;

  RxList<String> locationAdvantagesList = [
    AppString.closeToSchool,
    AppString.closeToMarket,
    AppString.closeToMetroStations,
    AppString.closeToHospital,
    AppString.showMore,
  ].obs;
}