import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api_service/app_config.dart';
import '../../../common/price_format_utils.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';
import '../../../controller/project_property_controller.dart';
import '../../../routes/app_routes.dart';
import '../project_list_view_all.dart';
import '../widget/feature_project_card.dart';

class ProjectFeatureProperty extends StatelessWidget {
  const ProjectFeatureProperty(
      {super.key, required this.projectPropertyController});

  final ProjectPropertyController projectPropertyController;

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
                "Feature Projects",
                style: AppStyle.heading3SemiBold(color: AppColor.black),
              ),
              GestureDetector(
                onTap: () async {
                  if (projectPropertyController
                      .paginatedProjectFeatureProperties.isEmpty) {
                    await projectPropertyController
                        .fetchPaginatedProjectFeatureProperties();
                  }

                  final List<dynamic> initialData = projectPropertyController
                      .paginatedProjectFeatureProperties;

                  if (initialData.isNotEmpty) {
                    Get.to(() => ProjectViewAll(
                          projectViewAll: List.from(initialData),
                          title: "Feature Projects",
                          onLoadMore: () async {
                            final prevCount = projectPropertyController
                                .paginatedProjectFeatureProperties.length;
                            await projectPropertyController
                                .fetchPaginatedProjectFeatureProperties(
                                    isLoadMore: true);
                            final newCount = projectPropertyController
                                .paginatedProjectFeatureProperties.length;
                            return projectPropertyController
                                .paginatedProjectFeatureProperties
                                .sublist(prevCount, newCount);
                          },
                        ));
                  } else {
                    Get.snackbar("No Data", "No Project available to display");
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
          if (projectPropertyController
                  .paginatedProjectFeatureProperties.isEmpty &&
              projectPropertyController.isProjectFeaturePaginating.isFalse) {
            projectPropertyController.fetchPaginatedProjectFeatureProperties();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (projectPropertyController.isProjectFeaturePaginating.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (projectPropertyController
              .paginatedProjectFeatureProperties.isEmpty) {
            return const Center(
              child: Text("No Project Available"),
            );
          }
          return SizedBox(
            height: 480,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: projectPropertyController
                    .paginatedProjectFeatureProperties.length,
                itemBuilder: (context, index) {
                  final project = projectPropertyController
                      .paginatedProjectFeatureProperties[index];
                  final String imageUrl = project.projectImages.isNotEmpty
                      ? "${AppConfigs.mediaUrl}${project.projectImages.first.images}?path=project"
                      : "assets/images/default_image.png";
                  // AppLogger.log("Featured Project images ---->> $imageUrl");
                  return FeatureProjectCard(
                    imageUrl: imageUrl,
                    projectName: project.projectName,
                    location: "${project.city} - ${project.zipCode}",
                    bhk: "${project.noOfBhk ?? "--"} BHK",
                    squareFT: "${project.totalArea ?? "--"} sq.FT",
                    priceRange: (() {
                      final cleaned = project.priceRange
                          .replaceAll(RegExp(r'\s*to\s*'), '-');
                      final parts = cleaned.split('-');
                      if (parts.length == 2) {
                        final min = num.tryParse(parts[0].trim());
                        final max = num.tryParse(parts[1].trim());
                        if (min != null && max != null) {
                          return "${PriceFormatUtils.formatIndianAmount(min, withRupee: false)} - ${PriceFormatUtils.formatIndianAmount(max, withRupee: false)}";
                        }
                      }
                      final single = num.tryParse(cleaned.trim());
                      return single != null
                          ? PriceFormatUtils.formatIndianAmount(single,
                              withRupee: false)
                          : cleaned;
                    })(),
                    onViewDetails: () {
                      Get.toNamed(AppRoutes.projectDetailsView,
                          arguments: {'project': project});
                    },
                    projectId: project.id,
                  );
                }),
          );
        })
      ],
    );
  }
}
