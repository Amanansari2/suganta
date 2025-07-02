
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/auth_helper.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_style.dart';
import '../../controller/bottom_bar_controller.dart';
import '../../gen/assets.gen.dart';
import '../../routes/app_routes.dart';
import '../activity/activity_view.dart';
import '../drawer/drawer_view.dart';
import '../home/home_view.dart';
import '../profile/profile_view.dart';



import 'package:flutter/cupertino.dart';

class BottomBarView extends StatelessWidget {
  BottomBarView({super.key});

  final BottomBarController bottomBarController = Get.find<BottomBarController>();

  @override
  Widget build(BuildContext context) {
    bottomBarController.initPageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(!bottomBarController.isInitialized) {
        bottomBarController.pageController.jumpToPage(0);
        bottomBarController.updateIndex(0);
        bottomBarController.isInitialized = true;
      }
    });

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      drawer: DrawerView(),
      body: buildPageView(),
      bottomNavigationBar: buildBottomNavBar(context),
    );
  }

  Widget buildPageView() {
    return PageView(
      controller: bottomBarController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          bottomBarController.updateIndex(index);
        });
      },
      children: [
        HomeView(),
        ActivityView(),
        Container(), // Add Button tab (not used)
        ProfileView(),
      ],
    );
  }

  Widget buildBottomNavBar(BuildContext context) {
    return Container(
      height: AppSize.appSize72,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: AppColor.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: AppSize.appSize1,
            blurRadius: AppSize.appSize3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(bottomBarController.bottomBarImageList.length, (index) {
          final isAddButton = bottomBarController.bottomBarImageList[index] == '';

          return GestureDetector(
            onTap: () {
              if (isAddButton) {
                bool isAuthenticated = AuthHelper.checkAuthAndProceed(context);
                if (isAuthenticated) {
                  Get.toNamed(AppRoutes.postPropertyView);
                }
              } else {
                if (index == 3) {
                  bool isAuthenticated = AuthHelper.checkAuthAndProceed(context);
                  if (!isAuthenticated) return;
                }
                if (bottomBarController.pageController.hasClients) {
                  bottomBarController.pageController.jumpToPage(index);
                }
              }
            },
            child: Obx(() {
              final isSelected = bottomBarController.selectIndex.value == index;

              if (isAddButton) {
                return Image.asset(
                  Assets.images.add.path,
                  width: AppSize.appSize40,
                  height: AppSize.appSize40,
                );
              }

              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSize.appSize8,
                  horizontal: AppSize.appSize12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSize.appSize100),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      bottomBarController.bottomBarImageList[index],
                      width: AppSize.appSize20,
                      height: AppSize.appSize20,
                      color: isSelected ? AppColor.whiteColor : AppColor.textColor,
                    ).paddingOnly(right: isSelected ? AppSize.appSize6 : AppSize.appSize0),
                    isSelected
                        ? Text(
                      bottomBarController.bottomBarMenuNameList[index],
                      style: AppStyle.heading6Medium(color: AppColor.whiteColor),
                    )
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
