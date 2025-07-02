import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tytil_realty/views/wallet/wallet.dart';

import '../../api_service/app_config.dart';
import '../../api_service/print_logger.dart';
import '../../common/auth_helper.dart';
import '../../common/common_rich_text.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/bottom_bar_controller.dart';
import '../../controller/drawer_controller.dart';
import '../../controller/home_controller.dart';
import '../../controller/logout_controller.dart';
import '../../controller/profile_controller.dart';
import '../../controller/wishlist_controller.dart';
import '../../gen/assets.gen.dart';
import '../../model/project_post_property_model.dart';
import '../../model/text_segment_model.dart';
import '../../routes/app_routes.dart';
import '../home/widget/wishlist_project_view_all.dart';
import '../home/widget/wishlist_property_view_all.dart';
import '../home/your_project_listing_view_all.dart';
import '../profile/widgets/finding_us_helpful_bottom_sheet.dart';
import '../profile/widgets/logout_bottom_sheet.dart';

class DrawerView extends StatelessWidget {
  DrawerView({super.key});

  SlideDrawerController drawerController = Get.put(SlideDrawerController());
  final WishlistController wishlistController = Get.find<WishlistController>();
  LogoutController logoutController = Get.find<LogoutController>();
  ProfileController profileController = Get.find<ProfileController>();

  final String? token = GetStorage().read("auth_token");

  @override
  Widget build(BuildContext context) {
    return buildDrawer();
  }

  Widget buildDrawer() {
    return Drawer(
      backgroundColor: AppColor.whiteColor,
      width: AppSize.appSize285,
      elevation: AppSize.appSize0,
      shape: const OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppSize.appSize12),
          bottomRight: Radius.circular(AppSize.appSize12),
        ),
        borderSide: BorderSide.none,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Image.asset(
              //   Assets.images.francisProfile.path,
              //   width: AppSize.appSize44,
              //   height: AppSize.appSize44,
              // ).paddingOnly(right: AppSize.appSize14),

              Obx(() {
                final image = profileController.user.value?.image;
                final token = GetStorage().read("auth_token");
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.appSize34),
                  child: (token != null &&
                          token.isNotEmpty &&
                          image != null &&
                          image.isNotEmpty)
                      ? Image.network(
                          "${AppConfigs.mediaUrl}$image?path=Profile",
                          width: AppSize.appSize44,
                          height: AppSize.appSize44,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Image.asset(
                              "assets/myImg/unknown_user.png",
                              width: AppSize.appSize44,
                              height: AppSize.appSize44,
                            );
                          },
                        )
                      : Image.asset(
                          "assets/myImg/unknown_user.png",
                          width: AppSize.appSize44,
                          height: AppSize.appSize44,
                        ),
                );
              }).paddingOnly(right: AppSize.appSize14),
              Expanded(
                child: Obx(() {
                  final user = profileController.user.value;
                  if (AuthHelper.isLoggedIn() && user != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            profileController.user.value?.name ?? "",
                            style: AppStyle.heading3Medium(
                                color: AppColor.textColor),
                          ),
                        ),
                        CommonRichText(
                          segments: [
                            TextSegment(
                              text: profileController.user.value?.roleName ??
                                  "User",
                              style: AppStyle.heading6Regular(
                                  color: AppColor.descriptionColor),
                            ),
                            TextSegment(
                              text: AppString.lining,
                              style: AppStyle.heading6Regular(
                                  color: AppColor.descriptionColor),
                            ),
                            TextSegment(
                              text: AppString.manageProfile,
                              style: AppStyle.heading6Regular(
                                  color: AppColor.primaryColor),
                              onTap: () {
                                Get.back();
                                Get.toNamed(AppRoutes.editProfileView);
                              },
                            ),
                          ],
                        ).paddingOnly(top: AppSize.appSize4),
                      ],
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        Get.back();
                        Get.toNamed(AppRoutes.loginView);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome 👋",
                            style: AppStyle.heading3Medium(
                                color: AppColor.textColor),
                          ),
                          Text(
                            "Please login to manage your profile",
                            style: AppStyle.heading6Regular(
                                color: AppColor.primaryColor),
                          ).paddingOnly(top: AppSize.appSize4),
                        ],
                      ),
                    );
                  }
                }),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  Assets.images.close.path,
                  width: AppSize.appSize24,
                  height: AppSize.appSize24,
                ),
              )
            ],
          ).paddingOnly(
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Divider(
            color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint3),
            height: AppSize.appSize0,
            thickness: AppSize.appSizePoint7,
          ).paddingOnly(top: AppSize.appSize26),
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(
                top: AppSize.appSize36,
                bottom: AppSize.appSize10,
              ),
              children: [
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(left: AppSize.appSize16),
                    itemCount: drawerController.drawerList.length,
                    itemBuilder: (context, index) {
                      if (!drawerController.drawerListVisibility[index]) {
                        return const SizedBox.shrink();
                      }
                      if (index == AppSize.size2 &&
                          (token == null || token!.isEmpty)) {
                        return const SizedBox.shrink();
                      }
                      if (index == AppSize.size3 &&
                          (token == null || token!.isEmpty)) {
                        return const SizedBox.shrink();
                      }
                      if (index == AppSize.size4 &&
                          (token == null || token!.isEmpty)) {
                        return const SizedBox.shrink();
                      }
                      return GestureDetector(
                        onTap: () async {
                          if (index == AppSize.size0) {
                            Get.back();
                            Get.toNamed(AppRoutes.notificationView);
                          } else if (index == AppSize.size1) {
                            Get.back();
                            Get.toNamed(AppRoutes.searchView);
                          } else if (index == AppSize.size2) {
                            Get.back();
                            Get.toNamed(AppRoutes.postPropertyView);
                          } else if (index == AppSize.size3) {
                            Get.back();
                            BottomBarController bottomBarController =
                                Get.put(BottomBarController());
                            bottomBarController.pageController
                                .jumpToPage(AppSize.size1);
                          } else if (index == AppSize.size4) {
                            Get.back();
                            final HomeController homeController =
                                Get.isRegistered<HomeController>()
                                    ? Get.find<HomeController>()
                                    : Get.put(HomeController());

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
                                  }));
                            } else {
                              Get.snackbar(
                                  "No Data", "No Project available to Display");
                            }
                          }
                        },
                        child: Text(
                          drawerController.drawerList[index],
                          style: AppStyle.heading5Medium(
                              color: AppColor.textColor),
                        ).paddingOnly(bottom: AppSize.appSize26),
                      );
                    },
                  ),
                ),
                Builder(
                  builder: (_) {
                    if (!AuthHelper.isLoggedIn() ||
                        !isSectionVisible(
                            drawerController.drawer2ListVisibility)) {
                      return const SizedBox.shrink();
                    }
                    return Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.yourPropertySearch,
                            style: AppStyle.heading6Bold(
                                color: AppColor.primaryColor),
                          ).paddingOnly(
                              top: AppSize.appSize10, left: AppSize.appSize16),
                          Divider(
                            color: AppColor.primaryColor
                                .withOpacity(AppSize.appSizePoint50),
                            height: AppSize.appSize0,
                            thickness: AppSize.appSizePoint7,
                          ).paddingOnly(
                              top: AppSize.appSize16,
                              bottom: AppSize.appSize16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                              top: AppSize.appSize10,
                              left: AppSize.appSize16,
                              right: AppSize.appSize16,
                            ),
                            itemCount: drawerController.drawer2List.length,
                            itemBuilder: (context, index) {
                              if (!drawerController
                                  .drawer2ListVisibility[index])
                                return const SizedBox.shrink();

                              return GestureDetector(
                                onTap: () {
                                  // Your tap logic
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      drawerController.drawer2List[index],
                                      style: AppStyle.heading5Medium(
                                          color: AppColor.textColor),
                                    ),
                                    Text(
                                      drawerController
                                          .searchPropertyNumberList[index],
                                      style: AppStyle.heading5Medium(
                                          color: AppColor.primaryColor),
                                    ),
                                  ],
                                ).paddingOnly(bottom: AppSize.appSize26),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),

                Divider(
                  color:
                      AppColor.primaryColor.withOpacity(AppSize.appSizePoint50),
                  height: AppSize.appSize0,
                  thickness: AppSize.appSizePoint7,
                ).paddingOnly(
                    top: AppSize.appSize10, bottom: AppSize.appSize16),
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(left: AppSize.appSize16),
                    itemCount: drawerController.drawer3List.length,
                    itemBuilder: (context, index) {
                      if (!drawerController.drawer3ListVisibility[index]) {
                        return const SizedBox.shrink();
                      }
                      if (index == AppSize.size1 &&
                          (token == null || token!.isEmpty)) {
                        return const SizedBox.shrink();
                      }

                      if (index == AppSize.size2 &&
                          (token == null || token!.isEmpty)) {
                        return const SizedBox.shrink();
                      }
                      return GestureDetector(
                        onTap: () async {
                          if (index == AppSize.size0) {
                            Get.back();
                          } else if (index == AppSize.size1) {
                            Get.back();

                            await wishlistController
                                .fetchPaginatedWishlistProperty();

                            final List<dynamic> initialWishlist =
                                wishlistController.paginatedWishlistProperties;

                            Get.to(() => WishListViewAll(
                                  wishlistViewAll: List.from(initialWishlist),
                                  title: "Wishlist Properties",
                                  onLoadMore: () async {
                                    final prevCount = wishlistController
                                        .paginatedWishlistProperties.length;
                                    await wishlistController
                                        .fetchPaginatedWishlistProperty(
                                            isLoadMore: true);
                                    final newCount = wishlistController
                                        .paginatedWishlistProperties.length;
                                    return wishlistController
                                        .paginatedWishlistProperties
                                        .sublist(prevCount, newCount);
                                  },
                                  errorMessage: wishlistController
                                      .wishlistEmptyMessage.value,
                                ));
                          } else if (index == AppSize.size2) {
                            Get.back();
                            await wishlistController
                                .fetchPaginatedWishlistProject();
                            if (wishlistController
                                .paginatedWishlistProjects.isNotEmpty) {
                              AppLogger.log(
                                  "🚨 Type Check: ${wishlistController.paginatedWishlistProjects.first.runtimeType}");
                            } else {
                              AppLogger.log(
                                  "🚨 paginatedWishlistProjects is empty");
                            }
                            AppLogger.log(
                                "📦 Total Projects: ${wishlistController.paginatedWishlistProjects.length}");
                            final List<dynamic> initialProjectWishlist =
                                wishlistController.paginatedWishlistProjects;
                            final List<ProjectPostModel> modelList =
                                wishlistController.paginatedWishlistProjects
                                    .map((e) => e is ProjectPostModel
                                        ? e
                                        : ProjectPostModel.fromJson(
                                            e as Map<String, dynamic>))
                                    .toList();

                            Get.to(() => WishListProjectViewAll(
                                  wishlistProjectViewAll:
                                      initialProjectWishlist,
                                  title: "Wishlist Projects",
                                  onLoadMore: () async {
                                    final prevCount = wishlistController
                                        .paginatedWishlistProjects.length;
                                    await wishlistController
                                        .fetchPaginatedWishlistProject(
                                            isLoadMore: true);
                                    final newCount = wishlistController
                                        .paginatedWishlistProjects.length;

                                    return wishlistController
                                        .paginatedWishlistProjects
                                        .sublist(prevCount, newCount);
                                  },
                                  errorMessage: wishlistController
                                      .projectWishlistEmptyMessage.value,
                                ));
                          }
                        },
                        child: Text(
                          drawerController.drawer3List[index],
                          style: AppStyle.heading5Medium(
                              color: AppColor.textColor),
                        ).paddingOnly(bottom: AppSize.appSize16),
                      );
                    },
                  ),
                ),
                // Text(
                //   AppString.exploreProperties,
                //   style: AppStyle.heading6Bold(color: AppColor.primaryColor),
                // ).paddingOnly(top: AppSize.appSize10, left: AppSize.appSize16),
                Divider(
                  color:
                      AppColor.primaryColor.withOpacity(AppSize.appSizePoint50),
                  height: AppSize.appSize0,
                  thickness: AppSize.appSizePoint7,
                ).paddingOnly(
                    top: AppSize.appSize16, bottom: AppSize.appSize10),
                // Row(
                //   children: [
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {
                //           Get.back();
                //           Get.toNamed(AppRoutes.searchView);
                //         },
                //         child: Container(
                //           padding: const EdgeInsets.all(AppSize.appSize16),
                //           decoration: BoxDecoration(
                //             color: AppColor.secondaryColor,
                //             borderRadius: BorderRadius.circular(AppSize.appSize6),
                //           ),
                //           child: Column(
                //             children: [
                //               Center(
                //                 child: Image.asset(
                //                   Assets.images.residential.path,
                //                   width: AppSize.appSize20,
                //                 ),
                //               ),
                //               Center(
                //                 child: Text(
                //                   AppString.residentialProperties,
                //                   textAlign: TextAlign.center,
                //                   style: AppStyle.heading5Medium(color: AppColor.textColor),
                //                 ),
                //               ).paddingOnly(top: AppSize.appSize6),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: AppSize.appSize6),
                //     Expanded(
                //       child: Container(
                //         padding: const EdgeInsets.all(AppSize.appSize16),
                //         decoration: BoxDecoration(
                //           color: AppColor.secondaryColor,
                //           borderRadius: BorderRadius.circular(AppSize.appSize6),
                //         ),
                //         child: Column(
                //           children: [
                //             Center(
                //               child: Image.asset(
                //                 Assets.images.buildings.path,
                //                 width: AppSize.appSize20,
                //               ),
                //             ),
                //             Center(
                //               child: Text(
                //                 AppString.commercialProperties,
                //                 textAlign: TextAlign.center,
                //                 style: AppStyle.heading5Medium(color: AppColor.textColor),
                //               ),
                //             ).paddingOnly(top: AppSize.appSize6),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: AppSize.appSize16,
                      top: AppSize.appSize6,
                    ),
                    itemCount: drawerController.drawer4List.length,
                    itemBuilder: (context, index) {
                      if (index == AppSize.size3 &&
                          (token == null || token!.isEmpty)) {
                        return const SizedBox.shrink();
                      }
                      if (index == AppSize.size4 &&
                          (token == null || token!.isEmpty)) {
                        return const SizedBox.shrink();
                      }
                      if (!drawerController.drawer4ListVisibility[index]) {
                        return const SizedBox.shrink();
                      }
                      return GestureDetector(
                        onTap: () {
                          if (index == AppSize.size0) {
                            Get.back();
                            Get.toNamed(AppRoutes.termsOfUseView);
                          } else if (index == AppSize.size1) {
                            Get.back();
                            Get.toNamed(AppRoutes.privacyPolicyView);
                          } else if (index == AppSize.size2) {
                            Get.back();
                            Get.toNamed(AppRoutes.contactUsView);
                          } else if (index == AppSize.size3) {
                            Get.back();
                             Get.toNamed(AppRoutes.wallet);
                          } else if (index == AppSize.size4) {
                            Get.back();
                            logoutBottomSheet(context);
                          }
                        },
                        child: Text(
                          drawerController.drawer4List[index],
                          style: AppStyle.heading5Medium(
                              color: AppColor.textColor),
                        ).paddingOnly(bottom: AppSize.appSize26),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ).paddingOnly(top: AppSize.appSize60),
    );
  }
}

bool isSectionVisible(List<bool> visibilityList) {
  return visibilityList.any((e) => e == true);
}
