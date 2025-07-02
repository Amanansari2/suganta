import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../api_service/app_config.dart';
import '../../api_service/print_logger.dart';
import '../../common/common_button.dart';
import '../../common/price_format_utils.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/project_details_controller.dart';
import '../../gen/assets.gen.dart';
import '../../model/map_model.dart';
import '../../model/project_post_property_model.dart';
import '../../routes/app_routes.dart';
import '../home/widget/similar/similar_project.dart';

class ProjectDetailsView extends StatefulWidget {
  final RxBool showNavigateButton = false.obs;

  ProjectDetailsView({super.key});

  @override
  State<ProjectDetailsView> createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends State<ProjectDetailsView> {
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
    if (_mapReady && _iconsLoaded) {
      setState(() {
        _markers = _buildMapMarker();
      });
    }
  }


  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapReady = true;
    _currentTarget = LatLng(latitude, longitude);
    _updateMarkersIfReady();
  }


  Set<Marker> _buildMapMarker() {
    final markers = <Marker>{};
    final data = projectDetailsController.projectMapData.value?.data;

    if (data == null) return markers;

    // Always add Project Location marker
    final lat = double.tryParse(data.latitude) ?? 0.0;
    final lng = double.tryParse(data.longitude) ?? 0.0;

    markers.add(
      Marker(
        markerId: const MarkerId("Project Location"),
        position: LatLng(lat, lng),
        infoWindow: const InfoWindow(title: "Project Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    );

    if (customIcons.length == 4) {
      final icon = customIcons[_selectedPlaceTab];
      List<List<PlaceItem>> allItems = [
        data.places.hospitals,
        data.places.markets,
        data.places.schools,
        data.places.metro,
      ];
      final selectedList = allItems[_selectedPlaceTab];

      markers.addAll(selectedList.map((item) => Marker(
        markerId: MarkerId(item.placeId),
        position: LatLng(item.location.lat, item.location.lng),
        infoWindow: InfoWindow(title: item.name, snippet: item.vicinity),
        icon: icon,
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
        args['project'] != null &&
        args['project'] is ProjectPostModel) {
      final ProjectPostModel newProject = args['project'];
      projectDetailsController.setProject(newProject);
      final mapData = projectDetailsController.projectMapData.value?.data;
      latitude = double.tryParse(mapData?.latitude ?? '') ?? 0.0;
      longitude = double.tryParse(mapData?.longitude ?? '') ?? 0.0;
      // _markers = _buildMapMarker(latitude, longitude);
      _loadCustomIcons().then((_) {
        _markers = _buildMapMarker();
        setState(() {});
      });
    }
  }

  final ProjectDetailsController projectDetailsController =
      Get.isRegistered<ProjectDetailsController>()
          ? Get.find<ProjectDetailsController>()
          : Get.put(ProjectDetailsController());

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
    if (customIcons.length < 4) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    projectDetailsController.isSimilarProjectLiked.value = List<bool>.generate(
        projectDetailsController.searchImageList.length, (index) => false);
    return Obx(() {
      final ProjectPostModel? project =
          projectDetailsController.selectedProject.value;

      if (project == null) {
        return const Scaffold(
          body: Center(
            child: Text("No Project Found"),
          ),
        );
      }
      return Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: buildAppBar(),
        body: buildProjectDetails(context, project),
      );
    });
  }

  AppBar buildAppBar() {
    final project = projectDetailsController.selectedProject.value;
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
        "Project Details",
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
                color: AppColor.descriptionColor,
              ).paddingOnly(right: AppSize.appSize26),
            ),
            GestureDetector(
              onTap: () {
                if (project == null) return;
                final String projectSlug =
                    project.slug ?? project.id.toString();
                AppLogger.log("Share projectSlug Print -->> $projectSlug");
                final String shareUrl = "${AppConfigs.shareUrl}$projectSlug";
                AppLogger.log("Share project slug Url -->> $shareUrl");
                Share.share("Checkout this Project : $shareUrl");
              },
              child: Image.asset(
                Assets.images.share.path,
                width: AppSize.appSize24,
              ),
            )
          ],
        ).paddingOnly(right: AppSize.appSize16)
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
                      projectDetailsController.projectList.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        projectDetailsController.updateProject(index);
                      },
                      child: Obx(() => Container(
                            height: AppSize.appSize25,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.appSize14),
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  color: projectDetailsController
                                              .selectProject.value ==
                                          index
                                      ? AppColor.primaryColor
                                      : AppColor.borderColor,
                                  width: AppSize.appSize1),
                              right: BorderSide(
                                color: index == AppSize.size6
                                    ? Colors.transparent
                                    : AppColor.borderColor,
                                width: AppSize.appSize1,
                              ),
                            )),
                            child: Center(
                              child: Text(
                                projectDetailsController.projectList[index],
                                style: AppStyle.heading5Medium(
                                    color: projectDetailsController
                                                .selectProject.value ==
                                            index
                                        ? AppColor.primaryColor
                                        : AppColor.textColor),
                              ),
                            ),
                          )),
                    );
                  }),
                ).paddingOnly(
                  top: AppSize.appSize10,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                )
              ],
            ),
          )),
    );
  }

  Widget buildProjectDetails(BuildContext context, ProjectPostModel project) {
    // double latitude =
    //     double.tryParse(projectDetailsController.projectMapData.value?.data.latitude ?? "0.0") ?? 0.0;
    // double longitude =
    //     double.tryParse(projectDetailsController.projectMapData.value?.data.longitude ?? "0.0") ?? 0.0;
    //
    // final rawLat = projectDetailsController.projectMapData.value?.data.latitude;
    // final rawLng = projectDetailsController.projectMapData.value?.data.longitude;
    //
    // AppLogger.log("Raw Lat: $rawLat, Raw Lng: $rawLng");
    // AppLogger.log("Latitude--->> $latitude");
    // AppLogger.log("Longitude--->> $longitude");

    final mapData = projectDetailsController.projectMapData.value?.data;

    double latitude = 0.0;
    double longitude = 0.0;

    if (mapData != null) {
      final Object? rawLat = mapData.latitude;
      final Object? rawLng = mapData.longitude;

      AppLogger.log("Raw Lat: $rawLat, Raw Lng: $rawLng");

      if (rawLat is double) {
        latitude = rawLat;
      } else if (rawLat is String) {
        latitude = double.tryParse(rawLat) ?? 0.0;
      }

      if (rawLng is double) {
        longitude = rawLng;
      } else if (rawLng is String) {
        longitude = double.tryParse(rawLng) ?? 0.0;
      }

      AppLogger.log("Parsed Latitude: $latitude");
      AppLogger.log("Parsed Longitude: $longitude");
    }

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
                    project.projectImages.isNotEmpty
                        ? "${AppConfigs.mediaUrl}${project.projectImages.first.images}?path=project"
                        : "",
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
            ),
          ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),
          Text(
            (() {
              final cleaned =
                  project.priceRange.replaceAll(RegExp(r'\s*to\s*'), '-');
              final parts = cleaned.split('-');
              if (parts.length == 2) {
                final min = num.tryParse(parts[0].trim());
                final max = num.tryParse(parts[1].trim());
                if (min != null && max != null) {
                  return "${PriceFormatUtils.formatIndianAmount(min, withRupee: false)} - ${PriceFormatUtils.formatIndianAmount(max, withRupee: false)}";
                }
              }
              final single = num.tryParse(cleaned.trim());
              return single != null
                  ? PriceFormatUtils.formatIndianAmount(single,
                      withRupee: false)
                  : cleaned;
            })(),
            style: AppStyle.heading2(color: AppColor.primaryColor),
          ).paddingOnly(
            top: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Text(
            "Location",
            style: AppStyle.heading3SemiBold(color: AppColor.textColor),
          ).paddingOnly(
            top: AppSize.appSize8,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Text(
            [
              project.area,
              project.city,
              project.zipCode,
              project.country,
            ]
                .where((e) => e != null && e.toString().trim().isNotEmpty)
                .join(', '),
            style: AppStyle.heading4Regular(color: AppColor.black),
          ).paddingOnly(
            top: AppSize.appSize4,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          const Divider(
            thickness: 1,
            color: AppColor.descriptionColor,
          ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Project Highlights",
                style: AppStyle.heading2(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize8,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(AppSize.appSize20),
                    boxShadow: [
                      BoxShadow(
                          color: AppColor.black.withOpacity(0.4),
                          blurRadius: 1,
                          spreadRadius: 2,
                          offset: const Offset(0, 2))
                    ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Project Type : ",
                          style:
                              AppStyle.heading4SemiBold(color: AppColor.black),
                        ).paddingOnly(right: AppSize.appSize10),
                        Text(
                          project.project.toString() == '1'
                              ? 'Commercial'
                              : 'Residential',
                          style:
                              AppStyle.heading4SemiBold(color: AppColor.black),
                        ).paddingOnly(right: AppSize.appSize10),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: AppColor.descriptionColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Construction Status : ",
                          style:
                              AppStyle.heading4SemiBold(color: AppColor.black),
                        ).paddingOnly(right: AppSize.appSize10),
                        Text(
                          projectDetailsController
                              .getStatusLabelByKey(project.projectStatus),
                          style:
                              AppStyle.heading4SemiBold(color: AppColor.black),
                        ).paddingOnly(right: AppSize.appSize10),
                      ],
                    ).paddingOnly(top: AppSize.appSize10),
                    const Divider(
                      thickness: 1,
                      color: AppColor.descriptionColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Possession Date : ",
                          style:
                              AppStyle.heading4SemiBold(color: AppColor.black),
                        ).paddingOnly(right: AppSize.appSize10),
                        Text(
                          DateFormat('dd MMM yyyy').format(
                              DateTime.parse(project.createdAt).toLocal()),
                          style:
                              AppStyle.heading4SemiBold(color: AppColor.black),
                        ).paddingOnly(right: AppSize.appSize10),
                      ],
                    ).paddingOnly(top: AppSize.appSize10),
                    const Divider(
                      thickness: 1,
                      color: AppColor.descriptionColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rera Number : ",
                          style:
                              AppStyle.heading4SemiBold(color: AppColor.black),
                        ).paddingOnly(right: AppSize.appSize10),
                        Text(
                          project.reraRegister ?? "N/A",
                          style:
                              AppStyle.heading4SemiBold(color: AppColor.black),
                        ).paddingOnly(right: AppSize.appSize10),
                      ],
                    ).paddingOnly(top: AppSize.appSize10),
                    const Divider(
                      thickness: 1,
                      color: AppColor.descriptionColor,
                    ),
                  ],
                ).paddingAll(AppSize.appSize20),
              ).paddingAll(
                AppSize.appSize20,
              )
            ],
          ),
          const Divider(
            thickness: 1,
            color: AppColor.descriptionColor,
          ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Project Status",
                style: AppStyle.heading2(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize8,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              buildProjectStatusGrid(project),
            ],
          ),
          const Divider(
            thickness: 1,
            color: AppColor.descriptionColor,
          ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Financial Details",
                style: AppStyle.heading2(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize16,
              ),
              buildProjectBigStatus(
                  label: "Payment Schedule",
                  value: PriceFormatUtils.formatIndianAmount(
                      num.tryParse(project.paymentSchedule ?? "0") ?? 0)),
              buildProjectBigStatus(
                  label: "Property Tax (Annual)",
                  value: PriceFormatUtils.formatIndianAmount(
                      project.propertyTaxAnnual ?? 0)),
              buildProjectBigStatus(
                  label: "Maintenance Fees",
                  value: PriceFormatUtils.formatIndianAmount(
                      project.maintenanceFees ?? 0)),
              buildProjectBigStatus(
                  label: "Additional Fees",
                  value: PriceFormatUtils.formatIndianAmount(
                      num.tryParse(project.additionalFees ?? "0") ?? 0)),
              buildProjectBigStatus(
                  label: "Occupancy Rate",
                  value:
                      "${PriceFormatUtils.formatIndianAmount(project.accupancyRate ?? 0, withRupee: false)} %"),
              buildProjectBigStatus(
                  label: "Annual Rental Income",
                  value: PriceFormatUtils.formatIndianAmount(
                      project.annualRentalIncome ?? 0)),
              buildProjectBigStatus(
                  label: "Current Valuation",
                  value: PriceFormatUtils.formatIndianAmount(
                      project.currentValuation ?? 0)),
            ],
          ).paddingOnly(left: AppSize.appSize20, right: AppSize.appSize30),
          const Divider(
            thickness: 1,
            color: AppColor.descriptionColor,
          ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Amenities",
                style: AppStyle.heading2(color: AppColor.textColor),
              ).paddingOnly(
                  top: AppSize.appSize8,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                  bottom: AppSize.appSize16),
              Obx(() {
                final labels = projectDetailsController
                    .getAmenitiesLabelByKey(project.amenities);
                if (projectDetailsController.isAmenitiesLoading.value) {
                  return const CircularProgressIndicator();
                }
                if (labels.isEmpty) {
                  return Text(
                    "No Amenities Available",
                    style: AppStyle.heading3(color: AppColor.black),
                  ).paddingOnly(left: AppSize.appSize20);
                }
                return Wrap(
                  runSpacing: 10,
                  children: projectDetailsController
                      .getAmenitiesLabelByKey(project.amenities)
                      .map((label) => Container(
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    offset: const Offset(0, 2),
                                    blurRadius: 1,
                                    spreadRadius: 1),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Text(
                              label,
                              style: AppStyle.heading3(color: Colors.white),
                            ),
                          ).paddingOnly(
                              left: AppSize.appSize10,
                              right: AppSize.appSize10))
                      .toList(),
                );
              }),
            ],
          ),
          if (project.projectImages.isNotEmpty)
            const Divider(
              thickness: 1,
              color: AppColor.descriptionColor,
            ).paddingOnly(
              top: AppSize.appSize20,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
          if (project.projectImages.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.projectMediaGallery,
                  style: AppStyle.heading2(color: AppColor.textColor),
                ).paddingOnly(
                    top: AppSize.appSize8,
                    left: AppSize.appSize16,
                    right: AppSize.appSize16,
                    bottom: AppSize.appSize16),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.galleryView, arguments: {
                      "images": project.projectImages
                          .map((img) =>
                              "${AppConfigs.mediaUrl}${img.images}?path=project")
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
                          project.projectImages.isNotEmpty
                              ? Image.network(
                                  "${AppConfigs.mediaUrl}${project.projectImages.first.images}?path=project",
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
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                  ).paddingOnly(
                      left: AppSize.appSize16, right: AppSize.appSize16),
                ),
                project.projectImages.isNotEmpty
                    ? Row(
                        children: [
                          if (project.projectImages.length > 1)
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.galleryView, arguments: {
                                  "images": project.projectImages
                                      .map((img) =>
                                          "${AppConfigs.mediaUrl}${img.images}?path=project")
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
                                        "${AppConfigs.mediaUrl}${project.projectImages[1].images}?path=project",
                                        width: double.infinity,
                                        height: AppSize.appSize285,
                                        fit: BoxFit.fill,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
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
                            )),
                          const SizedBox(
                            width: AppSize.appSize16,
                          ),
                          if (project.projectImages.length > 2)
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.galleryView, arguments: {
                                  "images": project.projectImages
                                      .map((img) =>
                                          "${AppConfigs.mediaUrl}${img.images}?path=project")
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
                                        "${AppConfigs.mediaUrl}${project.projectImages[2].images}?path=project",
                                        width: double.infinity,
                                        height: AppSize.appSize285,
                                        fit: BoxFit.fill,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
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
                            )),
                        ],
                      ).paddingOnly(
                        top: AppSize.appSize16,
                        left: AppSize.appSize16,
                        right: AppSize.appSize16,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          const Divider(
            thickness: 1,
            color: AppColor.descriptionColor,
          ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Project Description :",
                style: AppStyle.heading2(color: AppColor.textColor),
              ).paddingOnly(
                  top: AppSize.appSize8,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                  bottom: AppSize.appSize16),
              Text(
                project.projectDescription ?? "N/A",
                style: AppStyle.heading5Medium(color: AppColor.black),
              ).paddingOnly(right: AppSize.appSize16, left: AppSize.appSize16),
              const Divider(
                thickness: 1,
                color: AppColor.descriptionColor,
              ).paddingOnly(
                top: AppSize.appSize20,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Text(
                AppString.viewDeveloper,
                style: AppStyle.heading2(color: AppColor.textColor),
              ).paddingOnly(
                  top: AppSize.appSize8,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                  bottom: AppSize.appSize16),
              Container(
                padding: const EdgeInsets.all(AppSize.appSize10),
                margin: const EdgeInsets.only(
                  top: AppSize.appSize16,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                ),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  boxShadow: [
                    BoxShadow(
                        color: AppColor.black.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 1)
                  ],
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              project.developerName,
                              style:
                                  AppStyle.heading2(color: AppColor.textColor),
                            ).paddingOnly(bottom: AppSize.appSize3),
                          ),
                          const Divider().paddingOnly(
                              left: AppSize.appSize60,
                              right: AppSize.appSize60),
                          Row(
                            children: [
                              Text(
                                AppString.phone,
                                style: AppStyle.heading4Medium(
                                    color: AppColor.black),
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
                                maskPhoneNumber(project.developerPhNo1),
                                //"${property.user.phone}",
                                style: AppStyle.heading4Medium(
                                    color: AppColor.black),
                              ),
                            ],
                          ).paddingOnly(bottom: AppSize.appSize7),
                          if (project.developerPhNo2 != null)
                            Row(
                              children: [
                                Text(
                                  AppString.alternate,
                                  style: AppStyle.heading4Medium(
                                      color: AppColor.black),
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
                                  maskPhoneNumber(
                                      project.developerPhNo2.toString()),
                                  //"${property.user.phone}",
                                  style: AppStyle.heading4Medium(
                                      color: AppColor.black),
                                ),
                              ],
                            ).paddingOnly(bottom: AppSize.appSize7),
                          Row(
                            children: [
                              Text(
                                AppString.email,
                                style: AppStyle.heading4Medium(
                                    color: AppColor.black),
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
                                  maskEmail(project.developerEmail1),
                                  style: AppStyle.heading4Medium(
                                      color: AppColor.black),
                                ),
                              ),
                            ],
                          ).paddingOnly(bottom: AppSize.appSize7),
                          if (project.developerEmail2 != null)
                            Row(
                              children: [
                                Text(
                                  AppString.alternateEmail,
                                  style: AppStyle.heading4Medium(
                                      color: AppColor.black),
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
                                    maskEmail(
                                        project.developerEmail2.toString()),
                                    style: AppStyle.heading4Medium(
                                        color: AppColor.black),
                                  ),
                                ),
                              ],
                            ).paddingOnly(bottom: AppSize.appSize7),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              CommonButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.contactDeveloperView, arguments: {
                    "name": project.developerName,
                    "phone": project.developerPhNo1,
                    "phone2": project.developerPhNo2,
                    "email": project.developerEmail1,
                    "email2": project.developerEmail2,
                    "projectId": project.id,
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
                const Divider(
                  thickness: 1,
                  color: AppColor.descriptionColor,
                ).paddingOnly(
                  top: AppSize.appSize20,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                ),
                Text(
                  AppString.exploreMap,
                  style: AppStyle.heading2(color: AppColor.textColor),
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
                            //   // setState(() {
                            //   //   // _markers = _buildMapMarker(latitude, longitude);
                            //   //   _markers = _buildMapMarker();
                            //   // });
                            //
                            //   _loadCustomIcons().then((_) {
                            //     setState(() {
                            //       _markers = _buildMapMarker();
                            //     });
                            //   });
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
                            initialCameraPosition: CameraPosition(
                                target: LatLng(latitude, longitude),
                                zoom: AppSize.appSize15)),
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
                        child:
                            Icon(_showArrows ? Icons.close : Icons.open_with),
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
                            _currentMapType == MapType.normal
                                ? "Satellite"
                                : "Map",
                            style: AppStyle.heading5Medium(
                                color: AppColor.whiteColor),
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
                              onPressed: () =>
                                  _recenterCamera(latitude, longitude),
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
                      )
                  ],
                ).paddingOnly(
                  top: AppSize.appSize16,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                ),
                const Divider(
                  thickness: 1,
                  color: AppColor.descriptionColor,
                ).paddingOnly(
                  top: AppSize.appSize10,
                  left: AppSize.appSize26,
                  right: AppSize.appSize26,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: _buildPlaceTabs(),
                )
              ],
              const Divider(
                thickness: 1,
                color: AppColor.descriptionColor,
              ).paddingOnly(
                top: AppSize.appSize20,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),





              if (projectDetailsController.similarProject.isNotEmpty)
                Obx(() => projectDetailsController.similarProject.isEmpty
                    ? Center(
                        child: const CircularProgressIndicator(
                                color: AppColor.primaryColor)
                            .paddingOnly(top: AppSize.appSize20),
                      )
                    : SimilarProjectHorizontalList(
                        title: AppString.similarProjectsForYou,
                        initialProject:
                            projectDetailsController.similarProject.toList(),
                        onLoadMore:
                            projectDetailsController.fetchMoreSimilarProject,
                      ))
            ],
          ),
        ],
      ),
    );
  }

  Widget buildProjectStatusGrid(ProjectPostModel project) {
    final items = [
      buildProjectStatus(
          label: "Total Towers", value: project.totalTowers?.toString()),
      buildProjectStatus(
          label: "Total Floors", value: project.totalFloors?.toString()),
      buildProjectStatus(
          label: "BedRooms", value: project.noOfBedroom?.toString()),
      buildProjectStatus(label: "BHK", value: project.noOfBhk?.toString()),
      buildProjectStatus(
          label: "BathRooms", value: project.noOfBathroom?.toString()),
      buildProjectStatus(
          label: "Balconies", value: project.noOfBalcony?.toString()),
      buildProjectStatus(label: "Lift", value: project.lift?.toString()),
      buildProjectStatus(
          label: "Parking Space", value: project.parkingSpace?.toString()),
      buildProjectStatus(label: "Facing", value: project.facing?.toString()),
    ];
    final visibleItems = items.where((item) => item is! SizedBox).toList();
    if (visibleItems.length.isOdd) visibleItems.add(const SizedBox.shrink());

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSize.appSize10,
      crossAxisSpacing: AppSize.appSize20,
      childAspectRatio: 2,
      padding: const EdgeInsets.symmetric(horizontal: AppSize.appSize16),
      children: visibleItems,
    );
  }

  Widget buildProjectBigStatus({
    required String label,
    required String? value,
    bool hideIfEmpty = true,
    String? suffix,
  }) {
    final shouldHide = hideIfEmpty &&
        (value == null || value.trim().isEmpty || value.trim() == '0');
    if (shouldHide) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.only(
          top: AppSize.appSize15,
          bottom: AppSize.appSize15,
          left: AppSize.appSize10,
          right: AppSize.appSize15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: AppColor.black.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 2)),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label : ",
            style: AppStyle.heading4SemiBold(color: AppColor.black),
          ).paddingOnly(right: AppSize.appSize10),
          Text(
            suffix != null ? "$value $suffix" : value!,
            overflow: TextOverflow.ellipsis,
            // maxLines: 1,
            style: AppStyle.heading4SemiBold(color: AppColor.black),
          ),
        ],
      ),
    ).paddingOnly(top: AppSize.appSize16);
  }

  Widget buildProjectStatus({
    required String label,
    required String? value,
    bool hideIfEmpty = true,
    String? suffix,
  }) {
    final shouldHide = hideIfEmpty &&
        (value == null || value.trim().isEmpty || value.trim() == '0');
    if (shouldHide) return const SizedBox.shrink();

    final double itemWidth = (Get.width / 2) - AppSize.appSize40;

    return Container(
      width: itemWidth,
      padding: const EdgeInsets.only(
          top: AppSize.appSize15,
          bottom: AppSize.appSize15,
          left: AppSize.appSize10,
          right: AppSize.appSize10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: AppColor.black.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 2)),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            "$label :",
            style: AppStyle.heading4SemiBold(color: AppColor.black),
          ).paddingOnly(right: AppSize.appSize10),
          Flexible(
            child: Text(
              suffix != null ? "$value $suffix" : value!,
              overflow: TextOverflow.ellipsis,
              // maxLines: 1,
              style: AppStyle.heading4SemiBold(color: AppColor.black),
            ),
          ),
        ],
      ),
    ).paddingOnly(top: AppSize.appSize16);
  }

  int _selectedPlaceTab = 0;

  Widget _buildPlaceTabs() {
    final data = projectDetailsController.projectMapData.value?.data;
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
          spacing: 20,
          runSpacing: 10,
          children: List.generate(titles.length, (index) {
            return GestureDetector(
              onTap: () {
                if (customIcons.length < 4) return;
                setState(() {
                  _selectedPlaceTab = index;
                  // _markers = _buildMapMarker(latitude, longitude);
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
