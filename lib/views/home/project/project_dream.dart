import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../api_service/app_config.dart';
import '../../../common/price_format_utils.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';
import '../../../controller/project_property_controller.dart';
import '../../../routes/app_routes.dart';
import '../project_list_view_all.dart';
import '../widget/dream_project_card.dart';

class ProjectDreamProperty extends StatelessWidget {
  const ProjectDreamProperty(
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
                "Dream Projects",
                style: AppStyle.heading3SemiBold(color: AppColor.black),
              ),
              GestureDetector(
                onTap: () async {
                  if (projectPropertyController
                      .paginatedProjectDreamProperties.isEmpty) {
                    await projectPropertyController
                        .fetchPaginatedProjectDreamProperties();
                  }
                  final List<dynamic> initialData =
                      projectPropertyController.paginatedProjectDreamProperties;

                  if (initialData.isNotEmpty) {
                    Get.to(
                      () => ProjectViewAll(
                        projectViewAll: List.from(initialData),
                        title: "Dream Projects",
                        onLoadMore: () async {
                          final prevCount = projectPropertyController
                              .paginatedProjectDreamProperties.length;
                          await projectPropertyController
                              .fetchPaginatedProjectDreamProperties(
                                  isLoadMore: true);
                          final newCount = projectPropertyController
                              .paginatedProjectDreamProperties.length;
                          return projectPropertyController
                              .paginatedProjectDreamProperties
                              .sublist(prevCount, newCount);
                        },
                      ),
                    );
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
                  .paginatedProjectDreamProperties.isEmpty &&
              projectPropertyController.isProjectDreamPaginating.isFalse) {
            projectPropertyController.fetchPaginatedProjectDreamProperties();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (projectPropertyController.isProjectDreamPaginating.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (projectPropertyController
              .paginatedProjectDreamProperties.isEmpty) {
            return const Center(
              child: Text("No Project Available"),
            );
          }
          return SizedBox(
            height: 535,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: projectPropertyController
                    .paginatedProjectDreamProperties.length,
                itemBuilder: (context, index) {
                  final project = projectPropertyController
                      .paginatedProjectDreamProperties[index];
                  final String imageUrl = project.projectImages.isNotEmpty
                      ? "${AppConfigs.mediaUrl}${project.projectImages.first.images}?path=project"
                      : "assets/images/default_image.png";
                  return DreamProjectCard(
                    imageUrl: imageUrl,
                    projectName: project.projectName,
                    developerName: project.developerName,
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
                    createdAt: DateFormat('dd MMM yyyy')
                        .format(DateTime.parse(project.createdAt).toLocal()),
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
