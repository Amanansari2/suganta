import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api_service/app_config.dart';
import '../../../common/price_format_utils.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';
import '../../../controller/plot_Property_controller.dart';
import '../../../routes/app_routes.dart';
import '../property_list_view_all.dart';
import '../widget/PropertyCard.dart';

class PlotInvestmentProperties extends StatelessWidget {
  PlotInvestmentProperties(
      {super.key, required this.plotInvestmentPropertyController});

  final PlotPropertyController plotInvestmentPropertyController;

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
                "Investment Properties",
                style: AppStyle.heading3SemiBold(color: AppColor.black),
              ),
              GestureDetector(
                onTap: () async {
                  if (plotInvestmentPropertyController
                      .paginatedPlotInvestmentProperties.isEmpty) {
                    await plotInvestmentPropertyController
                        .fetchPaginatedPlotInvestmentProperties();
                  }

                  final List<dynamic> initialData =
                      plotInvestmentPropertyController
                          .paginatedPlotInvestmentProperties;

                  if (initialData.isNotEmpty) {
                    Get.to(() => PropertyViewAll(
                          propertyViewAll: List.from(initialData),
                          title: "Investment Properties",
                          onLoadMore: () async {
                            final prevCount = plotInvestmentPropertyController
                                .paginatedPlotInvestmentProperties.length;
                            await plotInvestmentPropertyController
                                .fetchPaginatedPlotInvestmentProperties(
                                    isLoadMore: true);
                            final newCount = plotInvestmentPropertyController
                                .paginatedPlotInvestmentProperties.length;
                            return plotInvestmentPropertyController
                                .paginatedPlotInvestmentProperties
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
          if (plotInvestmentPropertyController
                  .paginatedPlotInvestmentProperties.isEmpty &&
              plotInvestmentPropertyController
                  .isPlotInvestmentPaginating.isFalse) {
            plotInvestmentPropertyController
                .fetchPaginatedPlotInvestmentProperties();
            return const Center(child: CircularProgressIndicator());
          }

          if (plotInvestmentPropertyController
              .isPlotInvestmentPaginating.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (plotInvestmentPropertyController
              .paginatedPlotInvestmentProperties.isEmpty) {
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
                itemCount: plotInvestmentPropertyController
                    .paginatedPlotInvestmentProperties.length,
                itemBuilder: (context, index) {
                  final property = plotInvestmentPropertyController
                      .paginatedPlotInvestmentProperties[index];

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
