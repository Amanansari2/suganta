import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api_service/app_config.dart';
import '../../../common/price_format_utils.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';
import '../../../controller/pg_property_controller.dart';
import '../../../routes/app_routes.dart';
import '../property_list_view_all.dart';
import '../widget/PropertyCard.dart';

class PGTopRatedProperties extends StatelessWidget {
  const PGTopRatedProperties({
    super.key,
    required this.pgTopRatedPropertyController,
  });

  final PGPropertyController pgTopRatedPropertyController;

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
                "Top-Rated Properties",
                style: AppStyle.heading3SemiBold(color: AppColor.black),
              ),
              GestureDetector(
                onTap: () async {
                  if (pgTopRatedPropertyController
                      .paginatedPGTopRatedProperties.isEmpty) {
                    await pgTopRatedPropertyController
                        .fetchPaginatedPGTopRatedProperties();
                  }

                  final List<dynamic> initialData = pgTopRatedPropertyController
                      .paginatedPGTopRatedProperties;

                  if (initialData.isNotEmpty) {
                    Get.to(() => PropertyViewAll(
                          propertyViewAll: List.from(initialData),
                          title: "Top-Rated Properties",
                          onLoadMore: () async {
                            final prevCount = pgTopRatedPropertyController
                                .paginatedPGTopRatedProperties.length;
                            await pgTopRatedPropertyController
                                .fetchPaginatedPGTopRatedProperties(
                                    isLoadMore: true);
                            final newCount = pgTopRatedPropertyController
                                .paginatedPGTopRatedProperties.length;
                            return pgTopRatedPropertyController
                                .paginatedPGTopRatedProperties
                                .sublist(prevCount, newCount);
                          },
                        ));
                  } else {
                    Get.snackbar(
                        "No Data", "No Properties available to display");
                  }
                },
                child: Text(
                  "View All",
                  style: AppStyle.heading3SemiBold(color: AppColor.black),
                ),
              )
            ],
          ),
        ),
        Obx(() {
          if (pgTopRatedPropertyController
                  .paginatedPGTopRatedProperties.isEmpty &&
              pgTopRatedPropertyController.isPGTopRatedPaginating.isFalse) {
            pgTopRatedPropertyController.fetchPaginatedPGTopRatedProperties();
            return const Center(child: CircularProgressIndicator());
          }
          if (pgTopRatedPropertyController.isPGTopRatedPaginating.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (pgTopRatedPropertyController
              .paginatedPGTopRatedProperties.isEmpty) {
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
              itemCount: pgTopRatedPropertyController
                  .paginatedPGTopRatedProperties.length,
              itemBuilder: (context, index) {
                final property = pgTopRatedPropertyController
                    .paginatedPGTopRatedProperties[index];

                final String imageUrl = property.firstImage != null
                    ? "${AppConfigs.mediaUrl}${property.firstImage!.imageUrl}?path=properties"
                    : "assets/images/default_image.png";

                // print("Owner Property ID: ${property.id}, Owner Image URL-->>>: $imageUrl");

                return PropertyCard(
                  imageUrl: imageUrl,
                  type: property.wantTo,
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
              },
            ),
          );
        })
      ],
    );
  }
}
