import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../api_service/app_config.dart';
import '../../../common/project_wishlist_icon.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';
import '../../../configs/app_style.dart';

class FeatureProjectCard extends StatelessWidget {
  final String imageUrl;
  final String projectName;
  final String location;
  final String bhk;
  final String squareFT;
  final String priceRange;
  final VoidCallback onViewDetails;
  final int projectId;

  const FeatureProjectCard(
      {super.key,
      required this.imageUrl,
      required this.projectName,
      required this.location,
      required this.bhk,
      required this.squareFT,
      required this.priceRange,
      required this.onViewDetails,
      required this.projectId});

  @override
  Widget build(BuildContext context) {
    String fullImageUrl = imageUrl.startsWith("http")
        ? imageUrl
        : "${AppConfigs.mediaUrl}$imageUrl";

    return Container(
        width: 250,
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: AppColor.black.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 1)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: AppColor.black.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 1)
                      ]),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10), bottom: Radius.circular(10)),
                    child: Image.network(
                      imageUrl,
                      height: 200,
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
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/myImg/no_preview_available.png",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                ),

                ///////-------------wishlist

                Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                        decoration: BoxDecoration(
                            color: AppColor.black.withOpacity(0.3),
                            shape: BoxShape.circle),
                        width: 35,
                        height: 35,
                        child: ProjectWishlistIcon(
                          projectId: projectId,
                        )))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      projectName,
                      style: AppStyle.heading3SemiBold(color: AppColor.black),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        FontAwesomeIcons.locationDot,
                        color: AppColor.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        location,
                        style: AppStyle.heading5Medium(color: AppColor.black),
                      )
                    ],
                  ).paddingOnly(top: AppSize.appSize15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        FontAwesomeIcons.indianRupeeSign,
                        size: 15,
                        color: AppColor.primaryColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        priceRange,
                        style: AppStyle.heading5Medium(color: AppColor.black),
                      )
                    ],
                  ).paddingOnly(top: AppSize.appSize15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            FontAwesomeIcons.landmark,
                            size: 15,
                            color: AppColor.primaryColor,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            bhk,
                            style:
                                AppStyle.heading5Medium(color: AppColor.black),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            FontAwesomeIcons.square,
                            size: 15,
                            color: AppColor.primaryColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            squareFT,
                            style:
                                AppStyle.heading5Medium(color: AppColor.black),
                          )
                        ],
                      ),
                    ],
                  ).paddingOnly(top: AppSize.appSize15),
                  Center(
                    child: ElevatedButton(
                        onPressed: onViewDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "View Details",
                          style: AppStyle.heading4Medium(
                              color: AppColor.whiteColor),
                        )),
                  ).paddingOnly(top: AppSize.appSize15)
                ],
              ),
            )
          ],
        ));
  }
}
