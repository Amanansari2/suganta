import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../common/project_wishlist_icon.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';

class ListYourProjectCard extends StatelessWidget {
  final String imageUrl;
  final String projectName;
  final String developerName;
  final String location;
  final String price;
  final String bhk;
  final String project;
  final String squareFt;
  final String date;
  final int projectId;
  final bool showWishlistIcon;
  final VoidCallback onButtonPressed;
  final String buttonText;
  const ListYourProjectCard({
    super.key,
    required this.imageUrl,
    required this.projectName,
    required this.developerName,
    required this.location,
    required this.price,
    required this.bhk,
    required this.project,
    required this.squareFt,
    required this.date,
    required this.projectId,
    this.showWishlistIcon = true,
    required this.onButtonPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: AppColor.black.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 1)
              ]),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: AppColor.black.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 1)
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl,
                          height: 230,
                          width: 130,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 130,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.primaryColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                      null
                                      ? loadingProgress
                                      .cumulativeBytesLoaded /
                                      (loadingProgress
                                          .expectedTotalBytes ??
                                          1)
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return SizedBox(
                              height: 230,
                              width: 130,
                              child: Image.asset(
                                "assets/myImg/no_preview_available.png",
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            projectName,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppStyle.heading3SemiBold(
                                color: AppColor.black),
                          ).paddingOnly(right: 40),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.user,
                                size: 17,
                                color: AppColor.primaryColor,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                  developerName,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppStyle.heading4SemiBold(
                                      color: AppColor.black),
                                ).paddingOnly(right: 40),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.locationDot,
                                size: 17,
                                color: AppColor.primaryColor,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                  location,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: AppStyle.heading5SemiBold(
                                      color: AppColor.black),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                FontAwesomeIcons.indianRupeeSign,
                                size: 17,
                                color: AppColor.primaryColor,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                  child: Text(
                                    price,
                                    style: AppStyle.heading5SemiBold(
                                        color: AppColor.black),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                FontAwesomeIcons.home,
                                size: 17,
                                color: AppColor.primaryColor,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Text(
                                  "$bhk BHK || $project ",
                                  style: AppStyle.heading5SemiBold(
                                      color: AppColor.black),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                FontAwesomeIcons.rulerCombined,
                                size: 17,
                                color: AppColor.primaryColor,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                squareFt,
                                style: AppStyle.heading5SemiBold(
                                    color: AppColor.black),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                FontAwesomeIcons.calendar,
                                size: 17,
                                color: AppColor.primaryColor,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                date,
                                style: AppStyle.heading5SemiBold(
                                    color: AppColor.black),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: onButtonPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  buttonText,
                                  style: AppStyle.heading5SemiBold(
                                      color: AppColor.whiteColor),
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        //---------------------- wishList Project
        ...[
          if (showWishlistIcon)
            Positioned(
                top: 8,
                right: 8,
                child: ProjectWishlistIcon(
                  projectId: projectId,
                  emptyProjectHeartColor: AppColor.black,
                ))
        ]
      ],
    );
  }
}
