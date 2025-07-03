import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/app_color.dart';
import '../../configs/app_font.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/onboard_controller.dart';
import '../../routes/app_routes.dart';

class OnboardView extends StatelessWidget {
  OnboardView({super.key});

  OnboardController onboardController = Get.put(OnboardController());
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: AppSize.appSize80,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/myImg/tyilcom.png",
                width: AppSize.appSize250 ,
                height: AppSize.appSize116,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {

                    onboardController.currentIndex.value = index;
                  },
                  itemCount: onboardController.titles.length,
                  itemBuilder: (context, index) {
                    return Obx(() => AnimatedSwitcher(
                      duration: const Duration(milliseconds: AppSize.size500),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: buildPage(index, key: ValueKey<int>(onboardController.currentIndex.value)),
                    ));
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Obx(() => buildBottomSection()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(int index, {required Key key}) {
    return Column(
      key: key,
      children: [
        Container(
          height: 300,
          margin: const EdgeInsets.only(top: AppSize.appSize10, bottom: AppSize.appSize10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSize.appSize16),
              topRight: Radius.circular(AppSize.appSize16),
            ),
            image: DecorationImage(
              image: AssetImage(onboardController.images[index]),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSize.appSize16),
          margin: const EdgeInsets.only(top: AppSize.appSize16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                onboardController.titles[index],
                style: const TextStyle(
                  fontSize: AppSize.appSize25,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFont.interBold,
                  color: AppColor.textColor,
                ),
              ),
              Text(
                onboardController.subtitles[index],
                style: AppStyle.heading3Medium(color: AppColor.descriptionColor),
              ).paddingOnly(top: AppSize.appSize14),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBottomSection() {
    return  GestureDetector(
        onTap: (){
          if (onboardController.currentIndex.value < onboardController.titles.length - 1) {
            pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            onboardController.storage.write('isFirstTime', false);
            Get.offAllNamed(AppRoutes.loginView);
          }
        },
        child:  Container(
          margin: const EdgeInsets.only(bottom: 80, left: AppSize.appSize70, right: AppSize.appSize70),
          padding: const EdgeInsets.all(AppSize.appSize6),
          height: AppSize.appSize50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.appSize50),
              color: AppColor.primaryColor
          ),
          child:Center(
            child:  Text(
              onboardController.currentIndex.value == onboardController.titles.length - 1
                  ? AppString.getStartButton
                  : AppString.nextButton,
              style: AppStyle.heading3Medium(color: AppColor.whiteColor),
            ),
          ),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       onboardController.currentIndex.value == onboardController.titles.length - 1
          //           ? AppString.getStartButton
          //           : AppString.nextButton,
          //       style: AppStyle.heading3Medium(color: AppColor.whiteColor),
          //     ).paddingOnly(
          //       left: AppSize.appSize10,
          //       right: onboardController.currentIndex.value == onboardController.titles.length - 1
          //           ? AppSize.appSize22
          //           : AppSize.appSize60,
          //     ),
          //     GestureDetector(
          //       onTap: () {
          //         if (onboardController.currentIndex.value < onboardController.titles.length - 1) {
          //           pageController.nextPage(
          //             duration: const Duration(milliseconds: 300),
          //             curve: Curves.easeInOut,
          //           );
          //         } else {
          //
          //           onboardController.storage.write('isFirstTime', false);
          //
          //           Get.offAllNamed(AppRoutes.loginView);
          //         }
          //       },
          //       child: Container(
          //         padding: const EdgeInsets.all(AppSize.appSize1),
          //         decoration: const BoxDecoration(
          //           color: AppColor.primaryColor,
          //           shape: BoxShape.circle,
          //         ),
          //         child: Center(
          //           child: Image.asset(
          //             //Assets.images.nextButton.path,
          //             "assets/myImg/arrow.png",
          //             width: AppSize.appSize24,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),



        )
    );




  }
}
