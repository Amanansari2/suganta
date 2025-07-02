import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api_service/app_config.dart';
import '../../../common/price_format_utils.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';
import '../../../controller/residential_property_controller.dart';
import '../../../routes/app_routes.dart';
import '../property_list_view_all.dart';
import '../widget/PropertyCard.dart';

class ResidentialTopPremiumProperties extends StatelessWidget {
  ResidentialTopPremiumProperties(
      {super.key, required this.residentialTopPremiumPropertyController});

  final ResidentialPropertyController residentialTopPremiumPropertyController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Top-Premium Properties",
                style: AppStyle.heading3SemiBold(color: AppColor.black),
              ),
              GestureDetector(
                onTap: () async {
                  if (residentialTopPremiumPropertyController
                      .paginatedResidentialTopPremiumProperties.isEmpty) {
                    await residentialTopPremiumPropertyController
                        .fetchPaginatedResidentialTopPremiumProperties();
                  }

                  final List<dynamic> initialData =
                      residentialTopPremiumPropertyController
                          .paginatedResidentialTopPremiumProperties;

                  if (initialData.isNotEmpty) {
                    Get.to(() => PropertyViewAll(
                          propertyViewAll: List.from(initialData),
                          title: "Top-Premium Properties",
                          onLoadMore: () async {
                            final prevCount =
                                residentialTopPremiumPropertyController
                                    .paginatedResidentialTopPremiumProperties
                                    .length;
                            await residentialTopPremiumPropertyController
                                .fetchPaginatedResidentialTopPremiumProperties(
                                    isLoadMore: true);
                            final newCount =
                                residentialTopPremiumPropertyController
                                    .paginatedResidentialTopPremiumProperties
                                    .length;
                            return residentialTopPremiumPropertyController
                                .paginatedResidentialTopPremiumProperties
                                .sublist(prevCount, newCount);
                          },
                        ));
                  } else {
                    Get.snackbar(
                        "No Data", "No Properties available to display");
                  }
                },
                child: Text(
                  "view All",
                  style: AppStyle.heading3SemiBold(color: AppColor.black),
                ),
              )
            ],
          ),
        ),
        Obx(() {
          if (residentialTopPremiumPropertyController
                  .paginatedResidentialTopPremiumProperties.isEmpty &&
              residentialTopPremiumPropertyController
                  .isResidentialTopPremiumPaginating.isFalse) {
            residentialTopPremiumPropertyController
                .fetchPaginatedResidentialTopPremiumProperties();
            return const Center(child: CircularProgressIndicator());
          }

          if (residentialTopPremiumPropertyController
              .isResidentialTopPremiumPaginating.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (residentialTopPremiumPropertyController
              .paginatedResidentialTopPremiumProperties.isEmpty) {
            return const Center(
              child: Text("No Property available"),
            );
          }

          return SizedBox(
            height: 440,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: residentialTopPremiumPropertyController
                    .paginatedResidentialTopPremiumProperties.length,
                itemBuilder: (context, index) {
                  final property = residentialTopPremiumPropertyController
                      .paginatedResidentialTopPremiumProperties[index];

                  final String imageUrl = property.firstImage != null
                      ? "${AppConfigs.mediaUrl}${property.firstImage!.imageUrl}?path=properties"
                      : "assets/images/default_image.png";

                  //  ("Premium Property Url --->>> ${property.id}, Premium IMage Url -->>>> $imageUrl ");

                  return PropertyCard(
                    imageUrl: imageUrl,
                    type: property.type,
                    city: property.address.city,
                    amount: property.feature.rentAmount != null &&
                            property.feature.rentAmount! > 0
                        ? PriceFormatUtils.formatIndianAmount(
                            property.feature.rentAmount ?? 0)
                        : PriceFormatUtils.formatIndianAmount(
                            property.feature.pricePerSquareFt ?? 0),
                    isPriceNegotiable: property.feature.isNegotiable == 1,
                    includesElectricCharges:
                        property.feature.electricityExcluded == 0,
                    ownerName: property.user.name,
                    onViewDetails: () {
                      Get.toNamed(
                        AppRoutes.propertyDetailsView,
                        arguments: {'property': property},
                      );
                    },
                    propertyId: property.id,
                    showRibbon: true,
                    ribbonText: "Premium Property",
                  );
                }),
          );
        })
      ],
    );
  }
}
