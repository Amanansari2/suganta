import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../api_service/app_config.dart';
import '../../../common/price_format_utils.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';
import '../../../controller/plot_Property_controller.dart';
import '../../../routes/app_routes.dart';
import '../property_list_view_all.dart';
import '../widget/feature_property_card.dart';

class PlotFeatureProperties extends StatelessWidget {
  const PlotFeatureProperties({
    super.key,
    required this.plotFeaturePropertyController,
  });

  final PlotPropertyController plotFeaturePropertyController;

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
                  if (plotFeaturePropertyController
                      .paginatedPlotFeatureProperties.isEmpty) {
                    await plotFeaturePropertyController
                        .fetchPaginatedPlotFeatureProperties();
                  }

                  final List<dynamic> initialData =
                      plotFeaturePropertyController
                          .paginatedPlotFeatureProperties;

                  if (initialData.isNotEmpty) {
                    Get.to(() => PropertyViewAll(
                          propertyViewAll: List.from(initialData),
                          title: "Feature Properties",
                          onLoadMore: () async {
                            final prevCount = plotFeaturePropertyController
                                .paginatedPlotFeatureProperties.length;
                            await plotFeaturePropertyController
                                .fetchPaginatedPlotFeatureProperties(
                                    isLoadMore: true);
                            final newCount = plotFeaturePropertyController
                                .paginatedPlotFeatureProperties.length;
                            return plotFeaturePropertyController
                                .paginatedPlotFeatureProperties
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
          if (plotFeaturePropertyController
                  .paginatedPlotFeatureProperties.isEmpty &&
              plotFeaturePropertyController.isPlotFeaturePaginating.isFalse) {
            plotFeaturePropertyController.fetchPaginatedPlotFeatureProperties();
            return const Center(child: CircularProgressIndicator());
          }

          if (plotFeaturePropertyController.isPlotFeaturePaginating.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (plotFeaturePropertyController
              .paginatedPlotFeatureProperties.isEmpty) {
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
              itemCount: plotFeaturePropertyController
                  .paginatedPlotFeatureProperties.length,
              itemBuilder: (context, index) {
                final property = plotFeaturePropertyController
                    .paginatedPlotFeatureProperties[index];

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
