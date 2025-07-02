import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../api_service/app_config.dart';
import '../../api_service/print_logger.dart';
import '../../common/common_button.dart';
import '../../common/common_rich_text.dart';
import '../../common/price_format_utils.dart';
import '../../common/wishlist_icon.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/property_details_controller.dart';
import '../../gen/assets.gen.dart';
import '../../model/map_model.dart';
import '../../model/property_model.dart';
import '../../model/text_segment_model.dart';
import '../../routes/app_routes.dart';
import '../home/widget/similar/similar_properties.dart';

class PropertyDetailsView extends StatefulWidget {

  final RxBool showNavigateButton = false.obs;

  PropertyDetailsView({
    super.key,
  });

  @override
  State<PropertyDetailsView> createState() => _PropertyDetailsViewState();
}

//final  PropertyDetailsController propertyDetailsController = Get.find<PropertyDetailsController>();
class _PropertyDetailsViewState extends State<PropertyDetailsView> {
  late double latitude;
  late double longitude;
  late GoogleMapController _mapController;
  LatLng _currentTarget = const LatLng(0.0, 0.0);
  bool _showArrows = false;
  MapType _currentMapType = MapType.normal;
  Set<Marker> _markers = {};
  List<BitmapDescriptor> customIcons = [];
  bool _iconsLoaded = false;
  bool _mapReady = false;

  Future<void> _loadCustomIcons() async {
    customIcons = await Future.wait([
      BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/markers/hospital.png'),
      BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/markers/market.png'),
      BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/markers/school.png'),
      BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/markers/metro.png'),
    ]);
    _iconsLoaded = true;
    _updateMarkersIfReady();
  }

  void _updateMarkersIfReady() {
    if(_mapReady && _iconsLoaded){
      setState(() {
        _markers = _buildMapMarker();
      });
    }
  }

  void _onMapCreated(GoogleMapController controller){
    _mapController = controller;
    _mapReady = true;
    _currentTarget = LatLng(longitude, longitude);
    _updateMarkersIfReady();
  }


  Set<Marker> _buildMapMarker() {
    final markers = <Marker>{};
    final data = propertyDetailsController.mapData.value?.data;
    if(data == null) return markers;

    final lat = double.tryParse(data.latitude) ?? 0.0;
    final lng = double.tryParse(data.longitude) ?? 0.0;

    markers.add(
      Marker(
          markerId: const MarkerId("Project Location"),
          position: LatLng(lat, lng),
          infoWindow: const InfoWindow(title: "Project Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
      )
    );

    if(customIcons.length == 4){
      final icon = customIcons[_selectedPlaceTab];
      List<List<PlaceItem>> allItems = [
        data.places.hospitals,
        data.places.markets,
        data.places.schools,
        data.places.metro
      ];

      final selectedList = allItems[_selectedPlaceTab];

      markers.addAll(selectedList.map((item) => Marker(
          markerId: MarkerId(item.placeId),
          position: LatLng(item.location.lat, item.location.lng),
          infoWindow: InfoWindow(title: item.name, snippet:  item.vicinity),
          icon: icon
      )));
    }
    return markers;
  }


  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _moveCamera(double latOffset, double lngOffset) {
    final newTarget = LatLng(
      _currentTarget.latitude + latOffset,
      _currentTarget.longitude + lngOffset,
    );
    AppLogger.log("Moving to : $newTarget");
    _mapController.animateCamera(CameraUpdate.newLatLng(newTarget));
    _currentTarget = newTarget;
  }

  void _zoomCamera(bool zoomIn) async {
    final currentZoom = await _mapController.getZoomLevel();
    final newZoom = zoomIn ? currentZoom + 1 : currentZoom - 1;
    _mapController.animateCamera(CameraUpdate.zoomTo(newZoom));
  }

  void _recenterCamera(double latitude, double longitude) {
    final target = LatLng(latitude, longitude);
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(target, 15));
    _currentTarget = target;
  }

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args != null &&
        args['property'] != null &&
        args['property'] is BuyProperty) {
      final BuyProperty newProperty = args['property'];
      propertyDetailsController.setProperty(newProperty);

      final mapData = propertyDetailsController.mapData.value?.data;
      latitude = double.tryParse(mapData?.latitude ?? '') ?? 0.0;
      longitude = double.tryParse(mapData?.longitude ?? '') ?? 0.0;

      _loadCustomIcons().then((_) {
        _markers = _buildMapMarker();
        setState(() {});

      });
    }

    propertyDetailsController.mapData.listen((_) {
      if (mounted) setState(() {});
    });
  }

  final PropertyDetailsController propertyDetailsController =
      Get.isRegistered<PropertyDetailsController>()
          ? Get.find()
          : Get.put(PropertyDetailsController());

  String maskPhoneNumber(String phone) {
    if (phone.length < 4) {
      return "XXXX";
    }
    return "${phone.substring(0, 2)}XXXXXX${phone.substring(phone.length - 2)}";
  }

  String maskEmail(String email) {
    List<String> parts = email.split("@");
    if (parts.length != 2) return "Invalid Email";

    String username = parts[0];
    String domain = parts[1];

    if (username.length <= 2) {
      return "${username[0]}X@${domain}";
    }

    int maskLength = username.length - 2;
    String maskedPart = "X" * maskLength;

    return "${username[0]}$maskedPart${username[username.length - 1]}@$domain";
  }

  @override
  Widget build(BuildContext context) {

    if(customIcons.length < 4){
      return const Scaffold(
        body:  Center(
        child: CircularProgressIndicator(),
        ),
      );
    }

    propertyDetailsController.isSimilarPropertyLiked.value =
        List<bool>.generate(
            propertyDetailsController.searchImageList.length, (index) => false);
    return Obx(() {
      final BuyProperty? property =
          propertyDetailsController.selectedProperty.value;

      if (property == null) {
        return const Scaffold(
          body: Center(child: Text("Property not found")),
        );
      }

      return Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: buildAppBar(),
        body: buildPropertyDetails(context, property),
      );
    });
  }

  AppBar buildAppBar() {
    final property = propertyDetailsController.selectedProperty.value;
    return AppBar(
      backgroundColor: AppColor.whiteColor,
      scrolledUnderElevation: AppSize.appSize0,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSize.appSize16),
        child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Image.asset(
            Assets.images.backArrow.path,
          ),
        ),
      ),
      leadingWidth: AppSize.appSize40,
      title: Text(
        "Property Details",
        style: AppStyle.heading3(color: AppColor.black),
      ),
      actions: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.searchView);
              },
              child: Image.asset(
                Assets.images.search.path,
                width: AppSize.appSize24,
                color: AppColor.black,
              ).paddingOnly(right: AppSize.appSize10),
            ),
            WishlistIcon(
              propertyId:
                  propertyDetailsController.selectedProperty.value?.id ?? 0,
              emptyHeartColor: AppColor.black,
            ),
            GestureDetector(
              onTap: () {
                if (property == null) return;
                final String propertySlug =
                    property.slug ?? property.id.toString();
                AppLogger.log("Share Slug Print-->>>> $propertySlug");
                final String shareUrl = "${AppConfigs.shareUrl}$propertySlug";
                AppLogger.log("Share Slug Print-->>>> $shareUrl");

                Share.share("Check out this property: $shareUrl");

                // Share.share(AppString.appName);
              },
              child: Image.asset(
                color: AppColor.black,
                Assets.images.share.path,
                width: AppSize.appSize24,
              ),
            ),
          ],
        ).paddingOnly(right: AppSize.appSize16),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(AppSize.appSize40),
        child: SizedBox(
          height: AppSize.appSize40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Row(
                children: List.generate(
                    propertyDetailsController.propertyList.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      propertyDetailsController.updateProperty(index);
                    },
                    child: Obx(() => Container(
                          height: AppSize.appSize25,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.appSize14),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: propertyDetailsController
                                            .selectProperty.value ==
                                        index
                                    ? AppColor.primaryColor
                                    : AppColor.borderColor,
                                width: AppSize.appSize1,
                              ),
                              right: BorderSide(
                                color: index == AppSize.size6
                                    ? Colors.transparent
                                    : AppColor.borderColor,
                                width: AppSize.appSize1,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              propertyDetailsController.propertyList[index],
                              style: AppStyle.heading5Medium(
                                color: propertyDetailsController
                                            .selectProperty.value ==
                                        index
                                    ? AppColor.primaryColor
                                    : AppColor.textColor,
                              ),
                            ),
                          ),
                        )),
                  );
                }),
              ).paddingOnly(
                top: AppSize.appSize10,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPropertyDetails(BuildContext context, BuyProperty property) {
    double latitude = double.tryParse(
            propertyDetailsController.mapData.value?.data.latitude ?? "0.0") ??
        0.0;
    double longitude = double.tryParse(
            propertyDetailsController.mapData.value?.data.longitude ?? "0.0") ??
        0.0;

    AppLogger.log("Latitude--->> $latitude");
    AppLogger.log("Longitude--->> $longitude");

    AppLogger.log(
        " Address -->>>>${property.address.subLocality} ${property.address.area} ${property.address.city} ${property.address.pinCode}");

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSize.appSize30),
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: AppSize.appSize200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      ),
                    ),
                    Image.network(
                      "${AppConfigs.mediaUrl}${property.firstImage!.imageUrl}?path=properties",
                      fit: BoxFit.fill,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                            color: AppColor.primaryColor,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/myImg/no_preview_available.png",
                          width: double.infinity,
                          fit: BoxFit.fill,
                        );
                      },
                    )
                  ],
                ),
              )).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),

          Text(
            property.feature.rentAmount != null &&
                    property.feature.rentAmount! > 0
                ? PriceFormatUtils.formatIndianAmount(
                    property.feature.rentAmount ?? 0)
                : PriceFormatUtils.formatIndianAmount(
                    property.feature.pricePerSquareFt ?? 0),
            style: AppStyle.heading4Medium(color: AppColor.primaryColor),
          ).paddingOnly(
            top: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Text(
                  property.wantTo == "PG"
                      ? ""
                      : (property.feature.isUnderConstruction == 1
                          ? "Ready to Move"
                          : "Under Construction"),
                  // "Ready to move",
                  style: AppStyle.heading6Regular(
                      color: AppColor.descriptionColor),
                ),
                if (property.wantTo != "PG")
                  VerticalDivider(
                    color: AppColor.descriptionColor
                        .withOpacity(AppSize.appSizePoint4),
                    thickness: AppSize.appSizePoint7,
                    width: AppSize.appSize22,
                    indent: AppSize.appSize2,
                    endIndent: AppSize.appSize2,
                  ),
                Text(
                  property.feature.furnishedType ?? "",
                  style: AppStyle.heading6Regular(
                      color: AppColor.descriptionColor),
                ),
              ],
            ),
          ).paddingOnly(
            top: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Text(
            "Location",
            style: AppStyle.heading5SemiBold(color: AppColor.textColor),
          ).paddingOnly(
            top: AppSize.appSize8,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Text(
            [
              property.address.subLocality,
              property.address.area,
              property.address.city,
              property.address.pinCode
            ]
                .where((e) => e != null && e.toString().trim().isNotEmpty)
                .join(', '),
            style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
          ).paddingOnly(
            top: AppSize.appSize4,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),

          Divider(
            color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint4),
            thickness: AppSize.appSizePoint7,
            height: AppSize.appSize0,
          ).paddingOnly(
            top: AppSize.appSize16,
            bottom: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),

//////////////////////////////////////////////////Icons Section-----------

          Wrap(
            spacing: AppSize.appSize16,
            runSpacing: AppSize.appSize10,
            children: [
              if (property.feature.bedrooms != null &&
                  property.feature.bedrooms != 0)
                _buildIconWithTextBox(
                  iconPath: Assets.images.bed.path,
                  label: "Bed Rooms",
                  value: "${property.feature.bedrooms}",
                ),
              if (property.feature.bathrooms != null &&
                  property.feature.bathrooms != 0)
                _buildIconWithTextBox(
                  iconPath: Assets.images.bath.path,
                  label: "Bath Rooms",
                  value: "${property.feature.bathrooms}",
                ),
              if (property.feature.balconies != null &&
                  property.feature.balconies != 0)
                _buildIconWithTextBox(
                  iconPath: "assets/myImg/balcony.png",
                  label: "Balcony",
                  value: "${property.feature.balconies}",
                ),
              if (property.feature.carpetArea != null &&
                  property.feature.carpetArea != 0)
                _buildAreaBox(
                    "Carpet Area", "${property.feature.carpetArea} sq. ft."),
              if (property.feature.buildArea != null &&
                  property.feature.buildArea != 0)
                _buildAreaBox(
                    "Build Area", "${property.feature.buildArea} sq. ft."),
              if (property.feature.plotArea != null &&
                  property.feature.plotArea != 0)
                _buildAreaBox(
                    "Plot Area", "${property.feature.plotArea} sq. ft."),
            ],
          ).paddingOnly(left: AppSize.appSize16),

//////////////////////////////property Details -------------
          Container(
            margin: const EdgeInsets.only(
              top: AppSize.appSize36,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.appSize12),
              color: AppColor.secondaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.propertyDetails,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                buildPropertyRow(label: "Listing Type", value: property.wantTo),
                buildPropertyRow(label: "Building Type", value: property.type),
                buildPropertyRow(
                    label: "Property Type", value: property.typeOption?.option),
                buildPropertyRow(
                    label: "Sub Locality", value: property.address.subLocality),
                buildPropertyRow(label: "Area", value: property.address.area),
                buildPropertyRow(label: "City", value: property.address.city),
                buildPropertyRow(
                    label: "PinCode",
                    value: property.address.pinCode?.toString()),
                buildPropertyRow(
                    label: "BHK Flats",
                    value: property.feature.bhk?.toString()),
                buildPropertyRow(
                    label: "Furnishing Status",
                    value: property.feature.furnishedType),
                buildPropertyRow(
                    label: "Age Of Property",
                    value: property.feature.ageOfProperty?.toString(),
                    suffix: "Years"),
                buildPropertyRow(
                    label: "Pantry", value: property.feature.pantry),
                buildPropertyRow(
                    label: "Plot Facing",
                    value: property.feature.plotFacingDirection),
              ],
            ).paddingOnly(
              left: AppSize.appSize16,
              right: AppSize.appSize16,
              top: AppSize.appSize16,
              bottom: AppSize.appSize16,
            ),
          ),

          //////////Images ---------

          Text(
            AppString.takeATourOfOurProperty,
            style: AppStyle.heading4SemiBold(color: AppColor.textColor),
          ).paddingOnly(
            top: AppSize.appSize36,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.galleryView, arguments: {
                "images": property.images
                    .map((img) =>
                        "${AppConfigs.mediaUrl}${img.imageUrl}?path=properties")
                    .toList(),
              });
            },
            child: Container(
              height: AppSize.appSize285,
              margin: const EdgeInsets.only(top: AppSize.appSize16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      ),
                    ),
                    Image.network(
                      "${AppConfigs.mediaUrl}${property.firstImage!.imageUrl}?path=properties",
                      width: double.infinity,
                      height: AppSize.appSize285,
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                            color: AppColor.primaryColor,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/myImg/no_preview_available.png",
                          height: AppSize.appSize285,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        );
                      },
                    )
                  ],
                ),
              ),
            ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),
          ),

          property.images.isNotEmpty
              ? Row(
                  children: [
                    if (property.images.length > 1)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.galleryView, arguments: {
                              "images": property.images
                                  .map((img) =>
                                      "${AppConfigs.mediaUrl}${img.imageUrl}?path=properties")
                                  .toList(),
                            });
                          },
                          child: Container(
                            height: AppSize.appSize150,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppSize.appSize12),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppSize.appSize12),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                  Image.network(
                                    "${AppConfigs.mediaUrl}${property.images[1].imageUrl}?path=properties",
                                    width: double.infinity,
                                    height: AppSize.appSize285,
                                    fit: BoxFit.fill,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                          color: AppColor.primaryColor,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/myImg/no_preview_available.png",
                                        height: AppSize.appSize285,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: AppSize.appSize16),
                    if (property.images.length > 2)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.galleryView, arguments: {
                              "images": property.images
                                  .map((img) =>
                                      "${AppConfigs.mediaUrl}${img.imageUrl}?path=properties")
                                  .toList(),
                            });
                          },
                          child: Container(
                            height: AppSize.appSize150,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppSize.appSize12),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppSize.appSize12),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                  Image.network(
                                    "${AppConfigs.mediaUrl}${property.images[2].imageUrl}?path=properties",
                                    height: AppSize.appSize285,
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                          color: AppColor.primaryColor,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/myImg/no_preview_available.png",
                                        height: AppSize.appSize285,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ).paddingOnly(
                  top: AppSize.appSize16,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                )
              : const SizedBox.shrink(),

          Text(
            AppString.aboutProperty,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ).paddingOnly(
              top: AppSize.appSize36,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
              bottom: AppSize.appSize10),

          CommonRichText(
            segments: [
              TextSegment(
                text: property.description ?? "No description available",
                style:
                    AppStyle.heading5Regular(color: AppColor.descriptionColor),
              ),
            ],
          ).paddingOnly(
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),

          Text(
            AppString.viewOwner,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ).paddingOnly(
            top: AppSize.appSize36,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Container(
            padding: const EdgeInsets.all(AppSize.appSize10),
            margin: const EdgeInsets.only(
              top: AppSize.appSize16,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            decoration: BoxDecoration(
              color: AppColor.secondaryColor,
              borderRadius: BorderRadius.circular(AppSize.appSize12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${property.user.name}",
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ).paddingOnly(bottom: AppSize.appSize4),
                      Row(
                        children: [
                          Text(
                            AppString.phone,
                            style: AppStyle.heading5Medium(
                                color: AppColor.descriptionColor),
                          ),
                          VerticalDivider(
                            color: AppColor.descriptionColor
                                .withOpacity(AppSize.appSizePoint4),
                            thickness: AppSize.appSizePoint7,
                            width: AppSize.appSize20,
                            indent: AppSize.appSize2,
                            endIndent: AppSize.appSize2,
                          ),
                          Text(
                            maskPhoneNumber(property.user.phone),
                            //"${property.user.phone}",
                            style: AppStyle.heading5Medium(
                                color: AppColor.descriptionColor),
                          ),
                        ],
                      ).paddingOnly(bottom: AppSize.appSize4),
                      Row(
                        children: [
                          Text(
                            AppString.email,
                            style: AppStyle.heading5Medium(
                                color: AppColor.descriptionColor),
                          ),
                          VerticalDivider(
                            color: AppColor.descriptionColor
                                .withOpacity(AppSize.appSizePoint4),
                            thickness: AppSize.appSizePoint7,
                            width: AppSize.appSize20,
                            indent: AppSize.appSize2,
                            endIndent: AppSize.appSize2,
                          ),
                          Expanded(
                            child: Text(
                              maskEmail(property.user.email),
                              style: AppStyle.heading5Medium(
                                  color: AppColor.descriptionColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          CommonButton(
            onPressed: () {
              Get.toNamed(AppRoutes.contactOwnerView, arguments: {
                "name": property.user.name,
                //"phone": maskPhoneNumber(property.user.phone),
                "phone": property.user.phone,
                //  "email": maskEmail(property.user.email),
                "email": property.user.email,
                "propertyId": property.id,
              });
            },
            backgroundColor: AppColor.primaryColor,
            child: Text(
              AppString.viewPhoneNumberButton,
              style: AppStyle.heading5Medium(color: AppColor.whiteColor),
            ),
          ).paddingOnly(
            left: AppSize.appSize16,
            right: AppSize.appSize16,
            top: AppSize.appSize26,
          ),

          if (latitude != 0.0 && longitude != 0.0) ...[
            Text(
              AppString.exploreMap,
              style: AppStyle.heading4Medium(color: AppColor.textColor),
            ).paddingOnly(
              top: AppSize.appSize36,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  child: SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      //     (ctr) {
                      //   _mapController = ctr;
                      //   _currentTarget = LatLng(latitude, longitude);
                      // },
                      onCameraMove: (position) {
                        _currentTarget = position.target;
                      },
                      mapType: _currentMapType,
                      myLocationEnabled: false,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                      markers: _markers,
                      // {
                      //   Marker(
                      //     markerId: const MarkerId("Property Location"),
                      //     position: LatLng(latitude, longitude),
                      //     infoWindow: InfoWindow(
                      //         title: property.address.area,
                      //         snippet: property.address.city),
                      //   )
                      // },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude),
                        zoom: AppSize.appSize15,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 150,
                  right: 20,
                  child: FloatingActionButton(
                    mini: true,
                    heroTag: 'toggle',
                    backgroundColor: AppColor.whiteColor,
                    onPressed: () {
                      setState(() {
                        _showArrows = !_showArrows;
                      });
                    },
                    child: Icon(_showArrows ? Icons.close : Icons.open_with),
                  ),
                ),
                if (_showArrows)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: FloatingActionButton.extended(
                      heroTag: 'toggleMapType',
                      backgroundColor: AppColor.primaryColor,
                      onPressed: _toggleMapType,
                      label: Text(
                        _currentMapType == MapType.normal ? "Satellite" : "Map",
                        style:
                            AppStyle.heading5Medium(color: AppColor.whiteColor),
                      ),
                    ),
                  ),
                if (_showArrows)
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Row(
                      children: [
                        FloatingActionButton(
                          mini: true,
                          heroTag: 'recenter',
                          backgroundColor: AppColor.whiteColor,
                          onPressed: () => _recenterCamera(latitude, longitude),
                          child: const Icon(Icons.my_location),
                        ),
                        const SizedBox(width: 15),
                        FloatingActionButton(
                          mini: true,
                          heroTag: 'zoomIn',
                          backgroundColor: AppColor.whiteColor,
                          onPressed: () => _zoomCamera(true),
                          child: const Icon(Icons.zoom_in),
                        ),
                        const SizedBox(width: 15),
                        FloatingActionButton(
                          mini: true,
                          heroTag: 'zoomOut',
                          backgroundColor: AppColor.whiteColor,
                          onPressed: () => _zoomCamera(false),
                          child: const Icon(Icons.zoom_out),
                        ),
                      ],
                    ),
                  ),
                if (_showArrows)
                  Positioned(
                    bottom: 90,
                    right: 50,
                    child: FloatingActionButton(
                      mini: true,
                      heroTag: 'up',
                      backgroundColor: AppColor.whiteColor,
                      onPressed: () => _moveCamera(0.001, 0),
                      child: const Icon(Icons.arrow_upward),
                    ),
                  ),
                if (_showArrows)
                  Positioned(
                    bottom: 10,
                    right: 50,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: AppColor.whiteColor,
                      heroTag: 'down',
                      onPressed: () => _moveCamera(-0.001, 0),
                      child: const Icon(Icons.arrow_downward),
                    ),
                  ),
                if (_showArrows)
                  Positioned(
                    bottom: 50,
                    right: 90,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: AppColor.whiteColor,
                      heroTag: 'left',
                      onPressed: () => _moveCamera(0, -0.001),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                if (_showArrows)
                  Positioned(
                    bottom: 50,
                    right: 10,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: AppColor.whiteColor,
                      heroTag: 'right',
                      onPressed: () => _moveCamera(0, 0.001),
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ),
              ],
            ).paddingOnly(
              top: AppSize.appSize16,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            const Divider(
              height: 1,
            ).paddingOnly(
                top: AppSize.appSize20,
                bottom: AppSize.appSize20,
                left: AppSize.appSize20,
                right: AppSize.appSize20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildPlaceTabs(),
            )
          ],

          Obx(() {
            final controller = propertyDetailsController;

            if (controller.isSimilarPropertyLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColor.primaryColor),
              ).paddingOnly(top: AppSize.appSize20);
            }

            if (controller.similarProperties.isEmpty) {
              return const SizedBox.shrink();
            }

            return SimilarPropertyHorizontalList(
              title: AppString.similarHomesForYou,
              initialProperties: controller.similarProperties.toList(),
              onLoadMore: controller.fetchMoreSimilarProperties,
            );
          })
        ],
      ).paddingOnly(top: AppSize.appSize10),
    );
  }

  Widget _buildIconWithTextBox({
    required String iconPath,
    required String label,
    required String value,
  }) {
    if (value.isEmpty || value == "0") return const SizedBox.shrink();

    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.appSize8,
        horizontal: AppSize.appSize10,
      ),
      margin: const EdgeInsets.only(right: AppSize.appSize12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.appSize12),
        border: Border.all(
          color: AppColor.primaryColor,
          width: AppSize.appSizePoint50,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                width: AppSize.appSize16,
                height: AppSize.appSize16,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppStyle.heading6Regular(color: AppColor.textColor),
              ),
            ],
          ),
          const Divider(
            color: AppColor.primaryColor,
            thickness: 0.5,
            height: AppSize.appSize12,
          ),
          Text(
            value,
            style: AppStyle.heading5Medium(color: AppColor.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.appSize6,
        horizontal: AppSize.appSize14,
      ),
      margin: const EdgeInsets.only(right: AppSize.appSize16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.appSize12),
        border: Border.all(
          color: AppColor.primaryColor,
          width: AppSize.appSizePoint50,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AppStyle.heading5Medium(color: AppColor.textColor),
          ),
          Text(
            value,
            style: AppStyle.heading5Medium(color: AppColor.textColor),
          ),
        ],
      ),
    );
  }

  Widget buildPropertyRow({
    required String label,
    required String? value,
    bool hideIfEmpty = true,
    bool isNumber = false,
    String? suffix,
  }) {
    final shouldHide = hideIfEmpty &&
        (value == null || value.trim().isEmpty || value.trim() == "0");

    if (shouldHide) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 150,
              child: Text(
                label,
                style:
                    AppStyle.heading5Regular(color: AppColor.descriptionColor),
              ).paddingOnly(right: AppSize.appSize10),
            ),
            const SizedBox(width: 25),
            Expanded(
              child: Text(
                suffix != null ? "$value $suffix" : value!,
                style: AppStyle.heading5Regular(color: AppColor.textColor),
              ),
            ),
          ],
        ).paddingOnly(top: AppSize.appSize16),
        Divider(
          color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint4),
          thickness: AppSize.appSizePoint7,
          height: AppSize.appSize0,
        ).paddingOnly(top: AppSize.appSize16, bottom: AppSize.appSize16),
      ],
    );
  }

  int _selectedPlaceTab = 0;

  Widget _buildPlaceTabs() {
    final data = propertyDetailsController.mapData.value?.data;
    if (data == null) return const SizedBox.shrink();

    List<String> titles = ["Hospitals", "Markets", "Schools", "Metro"];
    List<List<PlaceItem>> allItems = [
      data.places.hospitals,
      data.places.markets,
      data.places.schools,
      data.places.metro,
    ];

    List<PlaceItem> selectedList = allItems[_selectedPlaceTab];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(titles.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                _selectedPlaceTab = index;
                _markers = _buildMapMarker();
                    });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                    color: _selectedPlaceTab == index
                        ? AppColor.primaryColor
                        : AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: AppColor.black.withOpacity(0.4),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: const Offset(0, 3))
                    ]),
                child: Text(
                  titles[index],
                  style: AppStyle.heading4SemiBold(
                    color: _selectedPlaceTab == index
                        ? AppColor.whiteColor
                        : AppColor.textColor,
                  ),
                ),
              ),
            );
          }),
        ).paddingOnly(bottom: AppSize.appSize20),
        ...selectedList.map((place) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name,
                      style:
                          AppStyle.heading4Medium(color: AppColor.textColor)),
                  Text(place.vicinity,
                      style: AppStyle.heading5Regular(
                          color: AppColor.descriptionColor)),
                  const Divider()
                ],
              ),
            )),
        if (selectedList.isEmpty)
          Text("No data available",
              style: AppStyle.heading3(color: AppColor.black)),
      ],
    );
  }
}
