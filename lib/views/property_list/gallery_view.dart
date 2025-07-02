import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tytil_realty/views/property_list/widget/full_image_view.dart';

import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../gen/assets.gen.dart';

class GalleryView extends StatelessWidget {
  GalleryView({super.key});

  final List<String> images = (Get.arguments?["images"] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList() ??
      [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildGallery(),
    );
  }

  AppBar buildAppBar() {
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
        AppString.gallery,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  SingleChildScrollView buildGallery() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSize.appSize10),
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => FullImageView(
                        images: images,
                        initialIndex: index,
                      ));
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: AppSize.appSize8,
                        horizontal: AppSize.appSize16),
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.appSize12),
                      child: Image.network(images[index],
                          height: AppSize.appSize200,
                          width: double.infinity,
                          fit: BoxFit.cover,
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
                      }, errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/myImg/no_preview_available.png",
                          height: AppSize.appSize285,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        );
                      }).paddingOnly(bottom: AppSize.appSize4),
                    )),
              );
            },
          ).paddingOnly(top: AppSize.appSize10),
        ],
      ).paddingOnly(
        top: AppSize.appSize10,
        left: AppSize.appSize16,
        right: AppSize.appSize16,
      ),
    );
  }
}
