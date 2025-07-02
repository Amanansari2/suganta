import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api_service/app_config.dart';
import '../../../common/price_format_utils.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';
import '../../../controller/buy_property_controller.dart';
import '../../../routes/app_routes.dart';
import '../property_list_view_all.dart';
import '../widget/feature_property_card.dart';

class BuyRecentProperties extends StatelessWidget {
  const BuyRecentProperties({
    super.key,
    required this.buyFeaturePropertyController,
  });

  final BuyPropertyController buyFeaturePropertyController;

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
                  if (buyFeaturePropertyController
                      .paginatedBuyFeatureProperties.isEmpty) {
                    await buyFeaturePropertyController
                        .fetchPaginatedBuyFeatureProperties();
                  }

                  final List<dynamic> initialData = buyFeaturePropertyController
                      .paginatedBuyFeatureProperties;

                  if (initialData.isNotEmpty) {
                    Get.to(() => PropertyViewAll(
                          propertyViewAll: List.from(initialData),
                          title: "Featured Properties",
                          onLoadMore: () async {
                            final prevCount = buyFeaturePropertyController
                                .paginatedBuyFeatureProperties.length;
                            await buyFeaturePropertyController
                                .fetchPaginatedBuyFeatureProperties(
                                    isLoadMore: true);
                            final newCount = buyFeaturePropertyController
                                .paginatedBuyFeatureProperties.length;
                            return buyFeaturePropertyController
                                .paginatedBuyFeatureProperties
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
          if (buyFeaturePropertyController
                  .paginatedBuyFeatureProperties.isEmpty &&
              buyFeaturePropertyController.isBuyFeaturePaginating.isFalse) {
            buyFeaturePropertyController.fetchPaginatedBuyFeatureProperties();
            return const Center(child: CircularProgressIndicator());
          }
          if (buyFeaturePropertyController.isBuyFeaturePaginating.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (buyFeaturePropertyController
              .paginatedBuyFeatureProperties.isEmpty) {
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
              itemCount: buyFeaturePropertyController
                  .paginatedBuyFeatureProperties.length,
              itemBuilder: (context, index) {
                final property = buyFeaturePropertyController
                    .paginatedBuyFeatureProperties[index];

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
