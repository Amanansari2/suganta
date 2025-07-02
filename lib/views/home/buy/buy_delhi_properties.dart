import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api_service/app_config.dart';
import '../../../common/price_format_utils.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';
import '../../../controller/buy_property_controller.dart';
import '../../../routes/app_routes.dart';
import '../property_list_view_all.dart';
import '../widget/PropertyCard.dart';

class BuyDelhiProperties extends StatelessWidget {
  const BuyDelhiProperties({
    super.key,
    required this.buyDelhiPropertyController,
  });

  final BuyPropertyController buyDelhiPropertyController;

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
                "Delhi Properties",
                style: AppStyle.heading3SemiBold(color: AppColor.black),
              ),
              GestureDetector(
                onTap: () async {
                  if (buyDelhiPropertyController
                      .paginatedBuyDelhiProperties.isEmpty) {
                    await buyDelhiPropertyController
                        .fetchPaginatedBuyDelhiProperties();
                  }

                  final List<dynamic> initialData =
                      buyDelhiPropertyController.paginatedBuyDelhiProperties;

                  if (initialData.isNotEmpty) {
                    Get.to(() => PropertyViewAll(
                          propertyViewAll: List.from(initialData),
                          title: "Delhi Properties",
                          onLoadMore: () async {
                            final prevCount = buyDelhiPropertyController
                                .paginatedBuyDelhiProperties.length;
                            await buyDelhiPropertyController
                                .fetchPaginatedBuyDelhiProperties(
                                    isLoadMore: true);
                            final newCount = buyDelhiPropertyController
                                .paginatedBuyDelhiProperties.length;
                            return buyDelhiPropertyController
                                .paginatedBuyDelhiProperties
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
          if (buyDelhiPropertyController.paginatedBuyDelhiProperties.isEmpty &&
              buyDelhiPropertyController.isBuyDelhiPaginating.isFalse) {
            buyDelhiPropertyController.fetchPaginatedBuyDelhiProperties();
            return const Center(child: CircularProgressIndicator());
          }
          if (buyDelhiPropertyController.isBuyDelhiPaginating.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (buyDelhiPropertyController.paginatedBuyDelhiProperties.isEmpty) {
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
              itemCount:
                  buyDelhiPropertyController.paginatedBuyDelhiProperties.length,
              itemBuilder: (context, index) {
                final property = buyDelhiPropertyController
                    .paginatedBuyDelhiProperties[index];

                final String imageUrl = property.firstImage != null
                    ? "${AppConfigs.mediaUrl}${property.firstImage!.imageUrl}?path=properties"
                    : "assets/images/default_image.png";

                // print("Owner Property ID: ${property.id}, Owner Image URL-->>>: $imageUrl");

                return PropertyCard(
                  imageUrl: imageUrl,
                  type: "${property.type} / ${property.wantTo}",
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
