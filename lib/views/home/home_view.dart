import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tytil_realty/views/home/pg/pg_feature_property.dart';
import 'package:tytil_realty/views/home/pg/pg_top_rated_property.dart';
import 'package:tytil_realty/views/home/plot/plot_feature_properties.dart';
import 'package:tytil_realty/views/home/plot/plot_investment_properties.dart';
import 'package:tytil_realty/views/home/plot/plot_owner_properties.dart';
import 'package:tytil_realty/views/home/project/project_dream.dart';
import 'package:tytil_realty/views/home/project/project_featured.dart';
import 'package:tytil_realty/views/home/rent/rent_owner_property.dart';
import 'package:tytil_realty/views/home/rent/rent_top_property.dart';
import 'package:tytil_realty/views/home/residential/residential_owner_properties.dart';
import 'package:tytil_realty/views/home/residential/residential_top_premium_properties.dart';
import 'package:tytil_realty/views/home/widget/manage_project_bottom_sheet.dart';
import 'package:tytil_realty/views/home/widget/manage_property_bottom_sheet.dart';
import 'package:tytil_realty/views/home/your_project_listing_view_all.dart';

import '../../api_service/app_config.dart';
import '../../api_service/print_logger.dart';
import '../../common/common_status_bar.dart';
import '../../common/price_format_utils.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/bottom_bar_controller.dart';
import '../../controller/buy_property_controller.dart';
import '../../controller/commercial_property_controller.dart';
import '../../controller/home_controller.dart';
import '../../controller/pg_property_controller.dart';
import '../../controller/plot_Property_controller.dart';
import '../../controller/profile_controller.dart';
import '../../controller/project_property_controller.dart';
import '../../controller/rent_property_controller.dart';
import '../../controller/residential_property_controller.dart';
import '../../gen/assets.gen.dart';
import '../../routes/app_routes.dart';
import 'buy/buy_delhi_properties.dart';
import 'buy/buy_owner_property.dart';
import 'buy/buy_premium_property.dart';
import 'buy/buy_recent_properties.dart';
import 'commercial/commercial_office_space_properties.dart';
import 'commercial/commercial_owner_properties.dart';
import 'commercial/commercial_show_room_properties.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final token = GetStorage().read("auth_token");

  HomeController homeController = Get.find<HomeController>();
  ProfileController profileController = Get.find<ProfileController>();
  BuyPropertyController buyPropertyController =
      Get.find<BuyPropertyController>();
  RentPropertyController rentPropertyController =
      Get.find<RentPropertyController>();
  PGPropertyController pgPropertyController = Get.find<PGPropertyController>();
  PlotPropertyController plotPropertyController =
      Get.find<PlotPropertyController>();
  CommercialPropertyController commercialPropertyController =
      Get.find<CommercialPropertyController>();
  ResidentialPropertyController residentialPropertyController =
      Get.find<ResidentialPropertyController>();

  ProjectPropertyController projectPropertyController =
      Get.find<ProjectPropertyController>();

  @override
  Widget build(BuildContext context) {
    homeController.isTrendPropertyLiked.value = List<bool>.generate(
        homeController.searchImageList.length, (index) => false);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: buildHome(context),
        ),
        const CommonStatusBar(),
      ],
    );
  }

  Widget buildHome(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Image.asset(
                      Assets.images.drawer.path,
                      width: AppSize.appSize40,
                      height: AppSize.appSize40,
                    ).paddingOnly(right: AppSize.appSize16),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome 👋",
                        style: AppStyle.heading3Medium(
                            color: AppColor.primaryColor),
                      ).paddingOnly(top: AppSize.appSize5),
                      if (token != null && token.isNotEmpty)
                        Obx(
                          () => Text(
                            profileController.user.value?.name ?? "",
                            style: AppStyle.heading5Medium(
                                color: AppColor.descriptionColor),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              // GestureDetector(
              //   onTap: () {
              //     Get.toNamed(AppRoutes.notificationView);
              //   },
              //   child: Image.asset(
              //     Assets.images.notification.path,
              //     width: AppSize.appSize40,
              //     height: AppSize.appSize40,
              //   ),
              // )
            ],
          ).paddingOnly(
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(left: AppSize.appSize16),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(homeController.propertyOptionList.length,
                  (index) {
                final isPostPropertyTab =
                    homeController.propertyOptionList[index] ==
                        AppString.postAProperty;
                if (isPostPropertyTab && (token == null || token.isEmpty)) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: () {
                    homeController.updateProperty(index);

                    switch (index) {
                      case 0:
                        buyPropertyController.loadAllBuyPropertyData();
                        break;

                      case 1:
                        rentPropertyController.loadAllRentPropertyData();
                        break;

                      case 2:
                        pgPropertyController.loadAllPgPropertyData();
                        break;

                      case 3:
                        plotPropertyController.loadAllPlotPropertyData();
                        break;

                      case 4:
                        commercialPropertyController
                            .loadAllCommercialPropertyData();
                        break;

                      case 5:
                        residentialPropertyController
                            .loadAllResidentialPropertyData();
                        break;

                      case 6:
                        projectPropertyController.loadAllProjectData();
                        break;

                      case 7:
                        Get.toNamed(AppRoutes.postPropertyView);

                        break;
                    }
                  },
                  child: Obx(() => Container(
                        height: AppSize.appSize37,
                        margin: const EdgeInsets.only(right: AppSize.appSize16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.appSize14),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSize.appSize12),
                          color: homeController.selectProperty.value == index
                              ? AppColor.primaryColor
                              : AppColor.backgroundColor,
                        ),
                        child: Center(
                          child: Text(
                            homeController.propertyOptionList[index],
                            style: AppStyle.heading5Regular(
                              color:
                                  homeController.selectProperty.value == index
                                      ? AppColor.whiteColor
                                      : AppColor.descriptionColor,
                            ),
                          ),
                        ),
                      )),
                );
              }),
            ).paddingOnly(top: AppSize.appSize26),
          ),

          //---------------------------search bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.appSize12),
              color: AppColor.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withOpacity(0.4),
                  offset: const Offset(0, 2),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            child: TextFormField(
              controller: homeController.searchController,
              cursorColor: AppColor.primaryColor,
              style: AppStyle.heading4Regular(color: AppColor.textColor),
              readOnly: true,
              onTap: () {
                Get.toNamed(AppRoutes.searchView);
              },
              decoration: InputDecoration(
                hintText: AppString.searchCity,
                hintStyle:
                    AppStyle.heading4Regular(color: AppColor.descriptionColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                    left: AppSize.appSize16,
                    right: AppSize.appSize16,
                  ),
                  child: Image.asset(
                    Assets.images.search.path,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  maxWidth: AppSize.appSize51,
                ),
              ),
            ),
          ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),

          Obx(() {
            return homeController.selectedTabIndex.value == 0
                ? Column(
                    children: [
                      BuyRecentProperties(
                          buyFeaturePropertyController: buyPropertyController),
                      BuyOwnerProperties(
                        buyOwnerPropertyController: buyPropertyController,
                      ),
                      BuyPremiumProperties(
                          buyPremiumPropertyController: buyPropertyController),
                      BuyDelhiProperties(
                          buyDelhiPropertyController: buyPropertyController),
                    ],
                  )
                : const SizedBox.shrink();
          }),

          Obx(() {
            return homeController.selectedTabIndex == 1
                ? Column(
                    children: [
                      RentTopProperties(
                          rentTopPropertyController: rentPropertyController),
                      RentOwnerProperties(
                          rentOwnerPropertyController: rentPropertyController)
                    ],
                  )
                : const SizedBox.shrink();
          }),

          Obx(() {
            return homeController.selectedTabIndex == 2
                ? Column(
                    children: [
                      PGFeaturedProperties(
                          pgFeaturePropertyController: pgPropertyController),
                      PGTopRatedProperties(
                          pgTopRatedPropertyController: pgPropertyController),
                    ],
                  )
                : const SizedBox.shrink();
          }),

          Obx(() {
            return homeController.selectedTabIndex == 3
                ? Column(
                    children: [
                      PlotFeatureProperties(
                          plotFeaturePropertyController:
                              plotPropertyController),
                      PlotInvestmentProperties(
                          plotInvestmentPropertyController:
                              plotPropertyController),
                      PlotOwnerProperties(
                          plotOwnerPropertyController: plotPropertyController)
                    ],
                  )
                : const SizedBox.shrink();
          }),

          Obx(() {
            return homeController.selectedTabIndex == 4
                ? Column(
                    children: [
                      CommercialOfficeSpaceProperties(
                          commercialOfficeSpacePropertyController:
                              commercialPropertyController),
                      CommercialOwnerProperties(
                          commercialOwnerPropertyController:
                              commercialPropertyController),
                      CommercialShopShowRoomProperties(
                          commercialShopShowRoomPropertyController:
                              commercialPropertyController)
                    ],
                  )
                : const SizedBox.shrink();
          }),

          Obx(() {
            return homeController.selectedTabIndex == 5
                ? Column(
                    children: [
                      ResidentialTopPremiumProperties(
                          residentialTopPremiumPropertyController:
                              residentialPropertyController),
                      ResidentialOwnerProperties(
                          residentialOwnerPropertyController:
                              residentialPropertyController),
                    ],
                  )
                : const SizedBox.shrink();
          }),

          Obx(() {
            return homeController.selectedTabIndex == 6
                ? Column(
                    children: [
                      ProjectFeatureProperty(
                          projectPropertyController: projectPropertyController),
                      ProjectDreamProperty(
                          projectPropertyController: projectPropertyController)
                    ],
                  )
                : const SizedBox.shrink();
          }),

          GetBuilder<HomeController>(
            builder: (homeController) {
              if (homeController.isLoading == true) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColor.primaryColor,
                ));
              }

              if (homeController.postPropertyList.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppString.yourListing,
                        style: AppStyle.heading3SemiBold(
                            color: AppColor.textColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          BottomBarController bottomBarController =
                              Get.put(BottomBarController());
                          bottomBarController.pageController
                              .jumpToPage(AppSize.size1);
                        },
                        child: Text(
                          AppString.viewAll,
                          style:
                              AppStyle.heading3SemiBold(color: AppColor.black),
                        ),
                      ),
                    ],
                  ).paddingOnly(
                    top: AppSize.appSize26,
                    left: AppSize.appSize16,
                    right: AppSize.appSize16,
                  ),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.appSize16),
                      itemCount: homeController.postPropertyList.length > 10
                          ? 10
                          : homeController.postPropertyList.length,
                      itemBuilder: (context, index) {
                        final pgItem = homeController.postPropertyList[index];
                        final imageUrl = pgItem.firstImage?.image != null
                            ? "${AppConfigs.mediaUrl}${pgItem.firstImage!.image}?path=properties"
                            : null;
                        AppLogger.log("Your Property listing Image URL: $imageUrl");

                        return SizedBox(
                          width: 370,
                          child: buildListingCard(
                            title: pgItem.feature?.pgName ?? 'N/A',
                            suitableFor: pgItem.feature?.suitableFor ?? '',
                            address: "${pgItem.address.city}"
                                "${pgItem.address.area.isNotEmpty ? ', ${pgItem.address.area}' : ''}"
                                "${(pgItem.address.subLocality ?? '').isNotEmpty ? ', ${pgItem.address.subLocality}' : ''}"
                                "${pgItem.address.pin != 0 ? ', PIN: ${pgItem.address.pin}' : ''}",
                            price:
                                pgItem.feature?.rentAmount.toString() ?? "N/A",
                            onManageTap: () =>
                                managePropertyBottomSheet(context, pgItem),
                            imagePath: imageUrl ?? Assets.images.property1.path,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),

          ///---------------------------------------------------------   project section
          ///

          Obx(
            () {
              if (homeController.isPostProjectPaginating.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                );
              }
              if (homeController.paginatedPostProject.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Project Listing",
                        style: AppStyle.heading3SemiBold(
                            color: AppColor.textColor),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (homeController.paginatedPostProject.isEmpty) {
                            await homeController.fetchPostProjectListing();
                          }
                          final List<dynamic> initialData =
                              homeController.paginatedPostProject;

                          if (initialData.isNotEmpty) {
                            Get.to(() => YourProjectListingViewAll(
                                  projectViewAll: List.from(initialData),
                                  title: "Your Project Listing",
                                  onLoadMore: () async {
                                    final prevCount = homeController
                                        .paginatedPostProject.length;

                                    await homeController
                                        .fetchPostProjectListing(
                                            isLoadMore: true);
                                    final newCount = homeController
                                        .paginatedPostProject.length;

                                    return homeController.paginatedPostProject
                                        .sublist(prevCount, newCount);
                                  },
                                ));
                          } else {
                            Get.snackbar(
                                "No Data", "No Project available to display");
                          }
                        },
                        child: Text(
                          "View All",
                          style:
                              AppStyle.heading3SemiBold(color: AppColor.black),
                        ),
                      ),
                    ],
                  ).paddingOnly(
                    top: AppSize.appSize26,
                    left: AppSize.appSize16,
                    right: AppSize.appSize16,
                  ),
                  SizedBox(
                    height: AppSize.appSize355,
                    child: ListView.separated(
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppSize.appSize16),
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.appSize16),
                      itemCount: homeController.paginatedPostProject.length,
                      itemBuilder: (context, index) {
                        final project =
                            homeController.paginatedPostProject[index];
                        final imageUrl = project.projectImages.isNotEmpty
                            ? "${AppConfigs.mediaUrl}${project.projectImages.first.images}?path=project"
                            : null;
                        AppLogger.log("Project Images --->>> $imageUrl");

                        return Stack(clipBehavior: Clip.none, children: [
                          Container(
                            width: AppSize.appSize211,
                            padding: const EdgeInsets.all(AppSize.appSize6),
                            margin:
                                const EdgeInsets.only(right: AppSize.appSize16),
                            decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius:
                                    BorderRadius.circular(AppSize.appSize12),
                                border: Border.all(
                                    color: AppColor.black.withOpacity(0.3)),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColor.black.withOpacity(0.3),
                                      blurRadius: 1,
                                      spreadRadius: 1)
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      borderRadius: BorderRadius.circular(
                                          AppSize.appSize12),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                AppColor.black.withOpacity(0.3),
                                            blurRadius: 1,
                                            spreadRadius: 1)
                                      ]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        AppSize.appSize12),
                                    child: imageUrl != null
                                        ? Image.network(
                                            imageUrl,
                                            height: AppSize.appSize130,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/myImg/please_upload_image.png',
                                                height: AppSize.appSize130,
                                                width: double.infinity,
                                                fit: BoxFit.fill,
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            "assets/myImg/please_upload_image.png",
                                            height: AppSize.appSize130,
                                            width: double.infinity,
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.all(AppSize.appSize6),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColor.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppSize.appSize12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (() {
                                        final cleaned = project.priceRange
                                            .replaceAll(
                                            RegExp(r'\s*to\s*'), '-');
                                        final parts = cleaned.split('-');
                                        if (parts.length == 2) {
                                          final min =
                                          num.tryParse(parts[0].trim());
                                          final max =
                                          num.tryParse(parts[1].trim());
                                          if (min != null && max != null) {
                                            return "${PriceFormatUtils.formatIndianAmount(min, withRupee: false)} - ${PriceFormatUtils.formatIndianAmount(max, withRupee: false)}";
                                          }
                                        }
                                        final single =
                                        num.tryParse(cleaned.trim());
                                        return single != null
                                            ? PriceFormatUtils
                                            .formatIndianAmount(single,
                                            withRupee: false)
                                            : cleaned;
                                      })(),
                                      style: AppStyle.heading5Medium(
                                          color: AppColor.primaryColor),
                                    ),
                                  ),
                                ).paddingOnly(top: AppSize.appSize10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          project.projectName,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: AppStyle.heading5SemiBold(
                                              color: AppColor.black),
                                        ).paddingOnly(top: AppSize.appSize6),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.user,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: AppSize.appSize10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              project.developerName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: AppStyle.heading5Regular(
                                                  color: AppColor
                                                      .descriptionColor),
                                            ),
                                          ),
                                        ],
                                      ).paddingOnly(top: AppSize.appSize10),
                                      Row(
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.directions,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: AppSize.appSize10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${project.city ?? ''} -${project.zipCode ?? ''}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: AppStyle.heading5Regular(
                                                  color: AppColor
                                                      .descriptionColor),
                                            ),
                                          ),
                                        ],
                                      ).paddingOnly(top: AppSize.appSize5),
                                      if (project.noOfBhk != null &&
                                          project.noOfBhk!.isNotEmpty)
                                        Row(
                                          children: [
                                            const Icon(
                                              FontAwesomeIcons.bed,
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: AppSize.appSize10,
                                            ),
                                            Text(
                                              "${project.noOfBhk.toString()} BHK",
                                              style: AppStyle.heading5Regular(
                                                  color: AppColor
                                                      .descriptionColor),
                                            ),
                                          ],
                                        ).paddingOnly(top: AppSize.appSize5),
                                      if (project.superArea != null &&
                                          project.superArea!.isNotEmpty)
                                        Row(
                                          children: [
                                            const Icon(
                                              FontAwesomeIcons.square,
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: AppSize.appSize10,
                                            ),
                                            Text(
                                              "${project.superArea.toString()} sq.FT",
                                              style: AppStyle.heading5Regular(
                                                  color: AppColor
                                                      .descriptionColor),
                                            ),
                                          ],
                                        ).paddingOnly(top: AppSize.appSize5),
                                    ],
                                  ).paddingOnly(top: AppSize.appSize10),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -20,
                            left: 20,
                            right: 20,
                            child: ElevatedButton(
                              onPressed: () {
                                manageProjectBottomSheet(context, project);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                AppString.manageProject,
                                style: AppStyle.heading5SemiBold(
                                    color: AppColor.whiteColor),
                              ),
                            ).paddingOnly(
                                left: AppSize.appSize16,
                                right: AppSize.appSize16),
                          ),
                        ]);
                      },
                    ),
                  ).paddingOnly(top: AppSize.appSize16),
                ],
              ).paddingOnly(bottom: AppSize.appSize40);
            },
          ),

          ///---------------------------------------------------------   project section Closed

          ///-------   recent response

          // Text(
          //   AppString.recentResponse,
          //   style: AppStyle.heading3SemiBold(color: AppColor.textColor),
          // ).paddingOnly(
          //   top: AppSize.appSize26,
          //   left: AppSize.appSize16, right: AppSize.appSize16,
          // ),
          // SizedBox(
          //   height: AppSize.appSize150,
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     scrollDirection: Axis.horizontal,
          //     physics: const ClampingScrollPhysics(),
          //     padding: const EdgeInsets.only(left: AppSize.appSize16),
          //     itemCount: homeController.responseImageList.length,
          //     itemBuilder: (context, index) {
          //       return Container(
          //         padding: const EdgeInsets.all(AppSize.appSize10),
          //         margin: const EdgeInsets.only(right: AppSize.appSize16),
          //         decoration: BoxDecoration(
          //           border: Border.all(
          //             color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint50),
          //           ),
          //           borderRadius: BorderRadius.circular(AppSize.appSize12),
          //         ),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Container(
          //               padding: const EdgeInsets.all(AppSize.appSize10),
          //               decoration: BoxDecoration(
          //                 color: AppColor.backgroundColor,
          //                 borderRadius: BorderRadius.circular(AppSize.appSize16),
          //               ),
          //               child: Row(
          //                 children: [
          //                   Image.asset(
          //                     homeController.responseImageList[index],
          //                     width: AppSize.appSize50,
          //                     height: AppSize.appSize50,
          //                   ).paddingOnly(right: AppSize.appSize10),
          //                   Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Text(
          //                         homeController.responseNameList[index],
          //                         style: AppStyle.heading4Medium(color: AppColor.textColor),
          //                       ).paddingOnly(bottom: AppSize.appSize4),
          //                       IntrinsicHeight(
          //                         child: Row(
          //                           children: [
          //                             Text(
          //                               AppString.buyer,
          //                               style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
          //                             ),
          //                             const VerticalDivider(
          //                               color: AppColor.borderColor,
          //                               width: AppSize.appSize20,
          //                               indent: AppSize.appSize2,
          //                               endIndent: AppSize.appSize2,
          //                             ),
          //                             Text(
          //                               homeController.responseTimingList[index],
          //                               style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Row(
          //                   children: [
          //                     Image.asset(
          //                       Assets.images.call.path,
          //                       width: AppSize.appSize14,
          //                     ).paddingOnly(right: AppSize.appSize6),
          //                     Text(
          //                       AppString.number1,
          //                       style: AppStyle.heading6Regular(color: AppColor.primaryColor),
          //                     ),
          //                   ],
          //                 ),
          //                 Row(
          //                   children: [
          //                     Image.asset(
          //                       Assets.images.email.path,
          //                       width: AppSize.appSize14,
          //                     ).paddingOnly(right: AppSize.appSize6),
          //                     Text(
          //                       homeController.responseEmailList[index],
          //                       style: AppStyle.heading6Regular(color: AppColor.primaryColor),
          //                     ),
          //                   ],
          //                 ).paddingOnly(top: AppSize.appSize8),
          //               ],
          //             ),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ).paddingOnly(top: AppSize.appSize16),

          // Row(
          //   children: [
          //     Text(
          //       AppString.popularBuilders,
          //       style: AppStyle.heading3SemiBold(color: AppColor.textColor),
          //     ),
          //     Text(
          //       AppString.inWesternMumbai,
          //       style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
          //     ),
          //   ],
          // ).paddingOnly(
          //   top: AppSize.appSize26,
          //   left: AppSize.appSize16, right: AppSize.appSize16,
          // ),
          // SizedBox(
          //   height: AppSize.appSize95,
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     scrollDirection: Axis.horizontal,
          //     physics: const ClampingScrollPhysics(),
          //     padding: const EdgeInsets.only(left: AppSize.appSize16),
          //     itemCount: homeController.popularBuilderImageList.length,
          //     itemBuilder: (context, index) {
          //       return GestureDetector(
          //         onTap: () {
          //           if(index == AppSize.size0) {
          //             Get.toNamed(AppRoutes.popularBuildersView);
          //           }
          //         },
          //         child: Container(
          //           width: AppSize.appSize160,
          //           padding: const EdgeInsets.symmetric(
          //             vertical: AppSize.appSize16, horizontal: AppSize.appSize10,
          //           ),
          //           margin: const EdgeInsets.only(right: AppSize.appSize16),
          //           decoration: BoxDecoration(
          //             color: AppColor.secondaryColor,
          //             borderRadius: BorderRadius.circular(AppSize.appSize12),
          //           ),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Center(
          //                 child: Image.asset(
          //                   homeController.popularBuilderImageList[index],
          //                   width: AppSize.appSize30,
          //                   height: AppSize.appSize30,
          //                 ),
          //               ),
          //               Center(
          //                 child: Text(
          //                   homeController.popularBuilderTitleList[index],
          //                   style: AppStyle.heading5Medium(color: AppColor.textColor),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ).paddingOnly(top: AppSize.appSize16),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       AppString.upcomingProject,
          //       style: AppStyle.heading3SemiBold(color: AppColor.textColor),
          //     ),
          //     Text(
          //       AppString.viewAll,
          //       style: AppStyle.heading5Medium(color: AppColor.descriptionColor),
          //     ),
          //   ],
          // ).paddingOnly(
          //   top: AppSize.appSize26,
          //   left: AppSize.appSize16, right: AppSize.appSize16,
          // ),
          // SizedBox(
          //   height: AppSize.appSize320,
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     physics: const ClampingScrollPhysics(),
          //     padding: const EdgeInsets.only(left: AppSize.appSize16),
          //     scrollDirection: Axis.horizontal,
          //     itemCount: homeController.upcomingProjectImageList.length,
          //     itemBuilder: (context, index) {
          //       return Container(
          //         width: AppSize.appSize343,
          //         margin: const EdgeInsets.only(right: AppSize.appSize16),
          //         padding: const EdgeInsets.all(AppSize.appSize10),
          //         decoration: BoxDecoration(
          //           color: AppColor.whiteColor,
          //           borderRadius: BorderRadius.circular(AppSize.appSize12),
          //           image: DecorationImage(
          //             image: AssetImage(homeController.upcomingProjectImageList[index]),
          //           ),
          //         ),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.end,
          //           children: [
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Text(
          //                   homeController.upcomingProjectTitleList[index],
          //                   style: AppStyle.heading3(color: AppColor.whiteColor),
          //                 ),
          //                 Text(
          //                   homeController.upcomingProjectPriceList[index],
          //                   style: AppStyle.heading5(color: AppColor.whiteColor),
          //                 ),
          //               ],
          //             ),
          //             Text(
          //               homeController.upcomingProjectAddressList[index],
          //               style: AppStyle.heading5Regular(color: AppColor.whiteColor),
          //             ).paddingOnly(top: AppSize.appSize6),
          //             Text(
          //               homeController.upcomingProjectFlatSizeList[index],
          //               style: AppStyle.heading6Medium(color: AppColor.whiteColor),
          //             ).paddingOnly(top: AppSize.appSize6),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ).paddingOnly(top: AppSize.appSize16),
        ],
      ).paddingOnly(top: AppSize.appSize50, bottom: AppSize.appSize20),
    );
  }
}

Widget buildListingCard({
  String? title,
  String? address,
  String? suitableFor,
  String? price,
  required VoidCallback onManageTap,
  String? imagePath,
}) {
  return Container(
    padding: const EdgeInsets.all(AppSize.appSize10),
    margin: const EdgeInsets.only(
        top: AppSize.appSize16,
        left: AppSize.appSize16,
        right: AppSize.appSize16,
        bottom: AppSize.appSize16),
    decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(AppSize.appSize12),
        boxShadow: [
          BoxShadow(
              color: AppColor.black.withOpacity(0.4),
              blurRadius: 1,
              spreadRadius: 1)
        ]),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: AppColor.black.withOpacity(0.4),
                    blurRadius: 1,
                    spreadRadius: 1)
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.appSize8),
            child: imagePath != null && imagePath.isNotEmpty
                ? Image.network(
                    imagePath,
                    width: AppSize.appSize112,
                    height: AppSize.appSize200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/myImg/please_upload_image.png",
                        width: AppSize.appSize112,
                        height: AppSize.appSize200,
                        fit: BoxFit.cover,
                      );
                    },
                  ).paddingOnly(right: AppSize.appSize5)
                : Image.asset(
                    "assets/myImg/please_upload_image.png",
                    width: AppSize.appSize112,
                    height: AppSize.appSize112,
                    fit: BoxFit.cover,
                  ),
          ).paddingOnly(right: AppSize.appSize5),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (suitableFor != null && suitableFor.isNotEmpty)
                Center(
                        child: Text("Suitable For $suitableFor",
                            style: AppStyle.heading5SemiBold(
                                color: AppColor.black)))
                    .paddingOnly(bottom: AppSize.appSize5),
              if (title != null && title.trim().isNotEmpty)
                Text("Pg Name :  $title",
                        style: AppStyle.heading5Medium(color: AppColor.black))
                    .paddingOnly(bottom: AppSize.appSize3),
              if (price != null && price.isNotEmpty)
                Text("Price:  ₹ $price",
                        style: AppStyle.heading5Medium(color: AppColor.black))
                    .paddingOnly(bottom: AppSize.appSize3),
              if (address != null && address.isNotEmpty)
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSize.appSize10),
                  child: Text("Address :  $address",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: AppStyle.heading5Regular(
                        color: AppColor.black,
                      )),
                )),
              GestureDetector(
                onTap: onManageTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppString.manageProperty,
                        style: AppStyle.heading5Medium(
                            color: AppColor.primaryColor)),
                    Container(
                      margin: const EdgeInsets.only(top: AppSize.appSize3),
                      height: AppSize.appSize1,
                      color: AppColor.primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ).paddingOnly(left: AppSize.appSize10),
        ),
      ],
    ),
  );
}

Widget buildDotIndicator({
  required int count,
  required int currentIndex,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      count,
      (index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: index == currentIndex ? Colors.white : Colors.white54,
            width: 1.5,
            style: BorderStyle.solid,
          ),
          color: index == currentIndex ? Colors.white : Colors.transparent,
        ),
      ),
    ),
  );
}
