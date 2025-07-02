import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api_service/app_config.dart';
import '../../../common/price_format_utils.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';
import '../../../controller/commercial_property_controller.dart';
import '../../../routes/app_routes.dart';
import '../property_list_view_all.dart';
import '../widget/PropertyCard.dart';

class CommercialOfficeSpaceProperties extends StatelessWidget {
  CommercialOfficeSpaceProperties(
      {super.key, required this.commercialOfficeSpacePropertyController});

  final CommercialPropertyController commercialOfficeSpacePropertyController;

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
                "Office-Space Properties",
                style: AppStyle.heading3SemiBold(color: AppColor.black),
              ),
              GestureDetector(
                onTap: () async {
                  if (commercialOfficeSpacePropertyController
                      .paginatedCommercialOfficeProperties.isEmpty) {
                    await commercialOfficeSpacePropertyController
                        .fetchPaginatedCommercialOfficeProperties();
                  }

                  final List<dynamic> initialData =
                      commercialOfficeSpacePropertyController
                          .paginatedCommercialOfficeProperties;

                  if (initialData.isNotEmpty) {
                    Get.to(() => PropertyViewAll(
                          propertyViewAll: List.from(initialData),
                          title: "Office-Space Properties",
                          onLoadMore: () async {
                            final prevCount =
                                commercialOfficeSpacePropertyController
                                    .paginatedCommercialOfficeProperties.length;
                            await commercialOfficeSpacePropertyController
                                .fetchPaginatedCommercialOfficeProperties(
                                    isLoadMore: true);
                            final newCount =
                                commercialOfficeSpacePropertyController
                                    .paginatedCommercialOfficeProperties.length;
                            return commercialOfficeSpacePropertyController
                                .paginatedCommercialOfficeProperties
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
          if (commercialOfficeSpacePropertyController
                  .paginatedCommercialOfficeProperties.isEmpty &&
              commercialOfficeSpacePropertyController
                  .isCommercialOfficeSpaceLoading.isFalse) {
            commercialOfficeSpacePropertyController
                .fetchPaginatedCommercialOfficeProperties();
            return const Center(child: CircularProgressIndicator());
          }

          if (commercialOfficeSpacePropertyController
              .isCommercialOfficeSpaceLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (commercialOfficeSpacePropertyController
              .paginatedCommercialOfficeProperties.isEmpty) {
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
                itemCount: commercialOfficeSpacePropertyController
                    .paginatedCommercialOfficeProperties.length,
                itemBuilder: (context, index) {
                  final property = commercialOfficeSpacePropertyController
                      .paginatedCommercialOfficeProperties[index];

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
