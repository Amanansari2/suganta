import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/app_string.dart';

class AddPhotoAndPricingController extends GetxController {
  TextEditingController expectedPriceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  RxInt selectOwnership = 0.obs;
  RxInt selectPriceDetails = 0.obs;

  void updateOwnership(int index) {
    selectOwnership.value = index;
  }

  void updatePriceDetails(int index) {
    selectPriceDetails.value = index;
  }

  RxList<String> ownershipList = [
    AppString.freehold,
    AppString.coOperativeSociety,
    AppString.powerOfAttorney,
    AppString.leasehold,
  ].obs;

  RxList<String> priceDetailsList = [
    AppString.allInclusivePrice,
    AppString.priceNegotiable,
    AppString.taxAndGovtCharges,
  ].obs;

  @override
  void dispose() {
    super.dispose();
    expectedPriceController.clear();
    descriptionController.clear();
  }
}