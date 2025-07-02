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

class RentOwnerProperties extends StatelessWidget {
  const RentOwnerProperties({
    super.key,
    required this.rentOwnerPropertyController,
  });

  final RentPropertyController rentOwnerPropertyController;

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
                  if (rentOwnerPropertyController
                      .paginatedRentOwnerProperties.isEmpty) {
                    await rentOwnerPropertyController
                        .fetchPaginatedRentOwnerProperties();
                  }

                  final List<dynamic> initialData =
                      rentOwnerPropertyController.paginatedRentOwnerProperties;

                  if (initialData.isNotEmpty) {
                    Get.to(() => PropertyViewAll(
                          propertyViewAll: List.from(initialData),
                          title: "Owner Properties",
                          onLoadMore: () async {
                            final prevCount = rentOwnerPropertyController
                                .paginatedRentOwnerProperties.length;
                            await rentOwnerPropertyController
                                .fetchPaginatedRentOwnerProperties(
                                    isLoadMore: true);
                            final newCount = rentOwnerPropertyController
                                .paginatedRentOwnerProperties.length;
                            return rentOwnerPropertyController
                                .paginatedRentOwnerProperties
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
          if (rentOwnerPropertyController
                  .paginatedRentOwnerProperties.isEmpty &&
              rentOwnerPropertyController.isRentOwnerPaginating.isFalse) {
            rentOwnerPropertyController.fetchPaginatedRentOwnerProperties();
            return const Center(child: CircularProgressIndicator());
          }

          if (rentOwnerPropertyController.isRentOwnerPaginating.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (rentOwnerPropertyController
              .paginatedRentOwnerProperties.isEmpty) {
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
              itemCount: rentOwnerPropertyController
                  .paginatedRentOwnerProperties.length,
              itemBuilder: (context, index) {
                final property = rentOwnerPropertyController
                    .paginatedRentOwnerProperties[index];

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
