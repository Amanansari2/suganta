import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../api_service/app_config.dart';
import '../../../common/price_format_utils.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';
import '../../../controller/rent_property_controller.dart';
import '../../../routes/app_routes.dart';
import '../property_list_view_all.dart';
import '../widget/PropertyCard.dart';

class RentTopProperties extends StatelessWidget {
  const RentTopProperties({
    super.key,
    required this.rentTopPropertyController,
  });

  final RentPropertyController rentTopPropertyController;

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
                "Top Properties",
                style: AppStyle.heading3SemiBold(color: AppColor.black),
              ),
              GestureDetector(
                onTap: () async {
                  if (rentTopPropertyController
                      .paginatedRentTopProperties.isEmpty) {
                    await rentTopPropertyController
                        .fetchPaginatedRentTopProperties();
                  }
                  final List<dynamic> initialTopData =
                      rentTopPropertyController.paginatedRentTopProperties;
                  if (initialTopData.isNotEmpty) {
                    Get.to(
                      () => PropertyViewAll(
                        propertyViewAll: List.from(initialTopData),
                        title: "Top Properties",
                        onLoadMore: () async {
                          final prevCount = rentTopPropertyController
                              .paginatedRentTopProperties.length;
                          await rentTopPropertyController
                              .fetchPaginatedRentTopProperties(
                                  isLoadMore: true);
                          final newCount = rentTopPropertyController
                              .paginatedRentTopProperties.length;
                          return rentTopPropertyController
                              .paginatedRentTopProperties
                              .sublist(prevCount, newCount);
                        },
                      ),
                    );
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
          if (rentTopPropertyController.paginatedRentTopProperties.isEmpty &&
              rentTopPropertyController.isRentTopPaginating.isFalse) {
            rentTopPropertyController.fetchPaginatedRentTopProperties();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (rentTopPropertyController.isRentTopPaginating.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (rentTopPropertyController.paginatedRentTopProperties.isEmpty) {
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
              itemCount:
                  rentTopPropertyController.paginatedRentTopProperties.length,
              itemBuilder: (context, index) {
                final property =
                    rentTopPropertyController.paginatedRentTopProperties[index];

                final String imageUrl = property.firstImage != null
                    ? "${AppConfigs.mediaUrl}${property.firstImage!.imageUrl}?path=properties"
                    : "assets/images/default_image.png";

                //  print("Owner Property ID: ${property.id}, Owner Image URL-->>>: $imageUrl");

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
