import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api_service/app_config.dart';
import '../api_service/print_logger.dart';
import '../configs/app_string.dart';
import '../gen/assets.gen.dart';
import '../model/map_model.dart';
import '../model/property_model.dart';
import '../repository/address_repo.dart';
import '../routes/app_routes.dart';

class PropertyDetailsController extends GetxController {
  final AddressRepository repository = Get.find<AddressRepository>();

  Rx<BuyProperty?> selectedProperty = Rx<BuyProperty?>(null);
  RxString finalAddress = "Fetching Address...".obs;

  RxBool isExpanded = false.obs;

  RxInt selectProperty = 0.obs;
  String truncatedText = AppString.aboutPropertyString.substring(0, 200);

  RxList<bool> isSimilarPropertyLiked = <bool>[].obs;

  ScrollController scrollController = ScrollController();
  RxDouble selectedOffset = 0.0.obs;
  RxBool showBottomProperty = false.obs;

  void updateProperty(int index) {
    selectProperty.value = index;
    if (index == 1) {
      Get.toNamed(AppRoutes.galleryView, arguments: {
        "images": selectedProperty.value!.images
            .map((img) =>
                "${AppConfigs.mediaUrl}${img.imageUrl}?path=properties")
            .toList(),
      })?.then((_) {
        selectProperty.value = 0;
      });
    } else if (index == 2) {
      Get.toNamed(AppRoutes.contactOwnerView, arguments: {
        "name": selectedProperty.value!.user.name,
        "phone": selectedProperty.value!.user.phone,
        "email": selectedProperty.value!.user.email,
        "propertyId": selectedProperty.value!.id,
      })?.then((_) {
        selectProperty.value = 0;
      });
    }
  }

  void setProperty(BuyProperty property) {
    if (selectedProperty.value?.id != property.id) {
      selectedProperty.value = property;
      AppLogger.log("Slug-->> ${property.slug}");
      // fetchAddress(property.address);
      submitSimilarPropertySlug();
      loadMapData();
    }
  }

  Rxn<MapModel> mapData = Rxn<MapModel>();
  RxBool isMapLoading = false.obs;

  Future<void> loadMapData() async {
    final property = selectedProperty.value;
    if (property == null) return;

    isMapLoading(true);
    try {
      final result = await repository.fetchMapData(property.id);
      if (result != null) {
        mapData.value = result;
      } else {
        AppLogger.log("Failed to fetch Map Data");
      }
    } catch (e) {
      AppLogger.log("Error fetching map data $e");
    } finally {
      isMapLoading(false);
    }
  }

  // void fetchAddress(PropertyAddress address) async {
  //   if (address.latitude != null && address.longitude != null) {
  //     AppLogger.log("Fetching address for: Lat = ${address.latitude}, Lng = ${address
  //         .longitude}");
  //
  //     try {
  //       String location = await repository.getAddressFromCoordinates(
  //         double.parse(address.latitude!),
  //         double.parse(address.longitude!),
  //       );
  //       finalAddress.value = location;
  //       AppLogger.log("Address Fetched: $location");
  //     } catch (e) {
  //       finalAddress.value = "Address fetch failed";
  //       AppLogger.log("Error fetching address: $e");
  //     }
  //   } else {
  //     finalAddress.value = "Location not available";
  //        AppLogger.log("Latitude & Longitude are null");
  //   }
  // }

  //===================================================
  // 🔄 Slug Similar PROPERTY Data

  RxBool isSimilarPropertyLoading = true.obs;
  RxBool isSimilarPaginating = false.obs;
  RxInt similarCurrentPage = 1.obs;
  RxInt similarLastPage = 1.obs;
  RxList<BuyProperty> similarProperties = <BuyProperty>[].obs;

  Future<void> submitSimilarPropertySlug({bool isLoadMore = false}) async {
    if (selectedProperty.value == null) {
      AppLogger.log("❗ No selected property found, skipping slug fetch");
      return;
    }

    if (isLoadMore && similarCurrentPage.value >= similarLastPage.value) {
      AppLogger.log("No more similar property pages to load.");
      return;
    }

    if (!isLoadMore) {
      isSimilarPropertyLoading(true);
    }

    isSimilarPaginating(true);

    try {
      final slug = selectedProperty.value?.slug ?? "";
      final nextPage = isLoadMore ? similarCurrentPage.value + 1 : 1;

      final response = await repository.submitSimilarPropertySlug(
          slug: slug, page: nextPage);

      if (response["success"] == true && response["data"] != null) {
        final message = response["data"]["message"] ?? "";
        final paginatedData = response["data"]["data"] ?? {};

        final fullResponse = {
          "message": message,
          "status": 200,
          "data": paginatedData,
        };

        final model = PropertyModel.fromJson(fullResponse);
        similarCurrentPage.value = model.pagination.currentPage;
        similarLastPage.value = model.pagination.lastPage;

        if (isLoadMore) {
          similarProperties.addAll(model.properties);
        } else {
          similarProperties.assignAll(model.properties);
        }
        update();
      } else {
        AppLogger.log("Slug Submission failed $response");
      }
    } catch (e) {
      AppLogger.log("Error while submitting slug -->> $e");
    } finally {
      if (!isLoadMore) {
        isSimilarPropertyLoading(false);
      }
      isSimilarPaginating(false);
    }
  }

  Future<List<BuyProperty>> fetchMoreSimilarProperties() async {
    if (similarCurrentPage.value >= similarLastPage.value) {
      AppLogger.log("No more similar properties to load.");
      return [];
    }

    await submitSimilarPropertySlug(isLoadMore: true);
    return similarProperties;
  }

  RxList<String> searchImageList = [
    Assets.images.alexaneFranecki.path,
    Assets.images.searchProperty5.path,
  ].obs;

  RxList<String> propertyList = [
    AppString.overview,
    AppString.photos,
    AppString.contactOwner,
  ].obs;

  @override
  void onReady() {
    AppLogger.log("📦 onReady() triggered");
    final args = Get.arguments;
    if (args != null &&
        args['property'] != null &&
        args['property'] is BuyProperty) {
      final BuyProperty prop = args['property'];
      setProperty(prop);
    } else {
      AppLogger.log("❗ Property not found in arguments");
    }
    super.onReady();
  }
}
