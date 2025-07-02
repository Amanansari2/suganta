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

class ResidentialOwnerProperties extends StatelessWidget {
  ResidentialOwnerProperties(
      {super.key, required this.residentialOwnerPropertyController});

  final ResidentialPropertyController residentialOwnerPropertyController;

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
                "Owner Properties",
                style: AppStyle.heading3SemiBold(color: AppColor.black),
              ),
              GestureDetector(
                onTap: () async {
                  if (residentialOwnerPropertyController
                      .paginatedResidentialOwnerProperties.isEmpty) {
                    await residentialOwnerPropertyController
                        .fetchPaginatedResidentialOwnerProperties();
                  }

                  final List<dynamic> initialData =
                      residentialOwnerPropertyController
                          .paginatedResidentialOwnerProperties;

                  if (initialData.isNotEmpty) {
                    Get.to(() => PropertyViewAll(
                          propertyViewAll: List.from(initialData),
                          title: "Owner Properties",
                          onLoadMore: () async {
                            final prevCount = residentialOwnerPropertyController
                                .paginatedResidentialOwnerProperties.length;
                            await residentialOwnerPropertyController
                                .fetchPaginatedResidentialOwnerProperties(
                                    isLoadMore: true);
                            final newCount = residentialOwnerPropertyController
                                .paginatedResidentialOwnerProperties.length;
                            return residentialOwnerPropertyController
                                .paginatedResidentialOwnerProperties
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
          if (residentialOwnerPropertyController
                  .paginatedResidentialOwnerProperties.isEmpty &&
              residentialOwnerPropertyController
                  .isResidentialOwnerPaginating.isFalse) {
            residentialOwnerPropertyController
                .fetchPaginatedResidentialOwnerProperties();
            return const Center(child: CircularProgressIndicator());
          }

          if (residentialOwnerPropertyController
              .isResidentialOwnerPaginating.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (residentialOwnerPropertyController
              .paginatedResidentialOwnerProperties.isEmpty) {
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
                itemCount: residentialOwnerPropertyController
                    .paginatedResidentialOwnerProperties.length,
                itemBuilder: (context, index) {
                  final property = residentialOwnerPropertyController
                      .paginatedResidentialOwnerProperties[index];

                  final String imageUrl = property.firstImage != null
                      ? "${AppConfigs.mediaUrl}${property.firstImage!.imageUrl}?path=properties"
                      : "assets/images/default_image.png";

                  // print("Premium Property Url --->>> ${property.id}, Premium IMage Url -->>>> $imageUrl ");

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
                  );
                }),
          );
        })
      ],
    );
  }
}
