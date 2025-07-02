import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../api_service/app_config.dart';
import '../../../common/price_format_utils.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';
import '../../../controller/pg_property_controller.dart';
import '../../../routes/app_routes.dart';
import '../property_list_view_all.dart';
import '../widget/feature_property_card.dart';

class PGFeaturedProperties extends StatelessWidget {
  const PGFeaturedProperties({
    super.key,
    required this.pgFeaturePropertyController,
  });

  final PGPropertyController pgFeaturePropertyController;

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
                "Feature Properties",
                style: AppStyle.heading3SemiBold(color: AppColor.black),
              ),
              GestureDetector(
                onTap: () async {
                  if (pgFeaturePropertyController
                      .paginatedPGFeatureProperties.isEmpty) {
                    await pgFeaturePropertyController
                        .fetchPaginatedPGFeatureProperties();
                  }

                  final List<dynamic> initialData =
                      pgFeaturePropertyController.paginatedPGFeatureProperties;

                  if (initialData.isNotEmpty) {
                    Get.to(() => PropertyViewAll(
                          propertyViewAll: List.from(initialData),
                          title: "Feature Properties",
                          onLoadMore: () async {
                            final prevCount = pgFeaturePropertyController
                                .paginatedPGFeatureProperties.length;
                            await pgFeaturePropertyController
                                .fetchPaginatedPGFeatureProperties(
                                    isLoadMore: true);
                            final newCount = pgFeaturePropertyController
                                .paginatedPGFeatureProperties.length;
                            return pgFeaturePropertyController
                                .paginatedPGFeatureProperties
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
          if (pgFeaturePropertyController
                  .paginatedPGFeatureProperties.isEmpty &&
              pgFeaturePropertyController.isPGFeaturePaginating.isFalse) {
            pgFeaturePropertyController.fetchPaginatedPGFeatureProperties();
            return const Center(child: CircularProgressIndicator());
          }

          if (pgFeaturePropertyController.isPGFeaturePaginating.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (pgFeaturePropertyController
              .paginatedPGFeatureProperties.isEmpty) {
            return const Center(
              child: Text("No Property available"),
            );
          }

          return SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: pgFeaturePropertyController
                  .paginatedPGFeatureProperties.length,
              itemBuilder: (context, index) {
                final property = pgFeaturePropertyController
                    .paginatedPGFeatureProperties[index];

                final String imageUrl = property.firstImage != null
                    ? "${AppConfigs.mediaUrl}${property.firstImage!.imageUrl}?path=properties"
                    : "assets/images/default_image.png";

                //print("Property ID: ${property.id}, Image URL-->>>: $imageUrl");

                return FeaturePropertyCard(
                  imageUrl: imageUrl,
                  price: property.feature.rentAmount != null &&
                          property.feature.rentAmount! > 0
                      ? PriceFormatUtils.formatIndianAmount(
                          property.feature.rentAmount ?? 0)
                      : PriceFormatUtils.formatIndianAmount(
                          property.feature.pricePerSquareFt ?? 0),
                  wantTo: property.wantTo,
                  type: property.type,
                  ownership: property.feature.ownership,
                  parking: property.feature.parking.toString(),
                  suitableFor: property.feature.suitableFor,
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
