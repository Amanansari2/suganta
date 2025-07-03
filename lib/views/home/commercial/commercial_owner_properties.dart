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

class CommercialOwnerProperties extends StatelessWidget {
  CommercialOwnerProperties(
      {super.key, required this.commercialOwnerPropertyController});

  final CommercialPropertyController commercialOwnerPropertyController;

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
                  if (commercialOwnerPropertyController
                      .paginatedCommercialOwnerProperties.isEmpty) {
                    await commercialOwnerPropertyController
                        .fetchPaginatedCommercialOwnerProperties();
                  }

                  final List<dynamic> initialData =
                      commercialOwnerPropertyController
                          .paginatedCommercialOwnerProperties;

                  if (initialData.isNotEmpty) {
                    Get.to(() => PropertyViewAll(
                          propertyViewAll: List.from(initialData),
                          title: "Owner Properties",
                          onLoadMore: () async {
                            final prevCount = commercialOwnerPropertyController
                                .paginatedCommercialOwnerProperties.length;
                            await commercialOwnerPropertyController
                                .fetchPaginatedCommercialOwnerProperties(
                                    isLoadMore: true);
                            final newCount = commercialOwnerPropertyController
                                .paginatedCommercialOwnerProperties.length;
                            return commercialOwnerPropertyController
                                .paginatedCommercialOwnerProperties
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
          if (commercialOwnerPropertyController
                  .paginatedCommercialOwnerProperties.isEmpty &&
              commercialOwnerPropertyController
                  .isCommercialOwnerLoading.isFalse) {
            commercialOwnerPropertyController
                .fetchPaginatedCommercialOwnerProperties();
            return const Center(child: CircularProgressIndicator());
          }

          if (commercialOwnerPropertyController
              .isCommercialOwnerLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (commercialOwnerPropertyController
              .paginatedCommercialOwnerProperties.isEmpty) {
            return const Center(
              child: Text("No Property available"),
            );
          }

          return SizedBox(
            height: 460,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: commercialOwnerPropertyController
                    .paginatedCommercialOwnerProperties.length,
                itemBuilder: (context, index) {
                  final property = commercialOwnerPropertyController
                      .paginatedCommercialOwnerProperties[index];

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
