import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../api_service/app_config.dart';
import '../../../../api_service/print_logger.dart';
import '../../../../common/price_format_utils.dart';
import '../../../../configs/app_color.dart';
import '../../../../configs/app_size.dart';
import '../../../../configs/app_style.dart';
import '../../../../model/project_post_property_model.dart';
import '../../../../routes/app_routes.dart';

class SimilarProjectHorizontalList extends StatefulWidget {
  final String title;
  final List<ProjectPostModel> initialProject;
  final Future<List<ProjectPostModel>> Function()? onLoadMore;

  const SimilarProjectHorizontalList(
      {super.key,
      required this.title,
      required this.initialProject,
      this.onLoadMore});

  @override
  State<SimilarProjectHorizontalList> createState() =>
      _SimilarProjectHorizontalListState();
}

class _SimilarProjectHorizontalListState
    extends State<SimilarProjectHorizontalList> {
  final ScrollController _scrollController = ScrollController();
  List<ProjectPostModel> _projects = [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _projects = List.from(widget.initialProject);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          widget.onLoadMore != null) {
        _loadMore();
      }
    });
  }

  @override
  void didUpdateWidget(covariant SimilarProjectHorizontalList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialProject != oldWidget.initialProject) {
      setState(() {
        _projects = List.from(widget.initialProject);
      });
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    final moreData = await widget.onLoadMore?.call() ?? [];
    if (moreData.isNotEmpty) {
      setState(() {
        _projects.addAll(moreData);
      });
    }
    setState(() => _isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.log("_projects inside build -->> ${_projects.length}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppStyle.heading2(color: AppColor.textColor),
        ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
            bottom: AppSize.appSize16),
        SizedBox(
          height: 440,
          child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: AppSize.appSize16),
              itemCount: _projects.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _projects.length) {
                  final project = _projects[index];
                  return GestureDetector(
                    onTap: () async {
                      await Get.offNamedUntil(AppRoutes.projectDetailsView,
                          (route) => route.isFirst,
                          arguments: {
                            'project': project,
                          });
                    },
                    child: Container(
                      width: AppSize.appSize250,
                      padding: const EdgeInsets.all(AppSize.appSize10),
                      margin: const EdgeInsets.all(AppSize.appSize16),
                      decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius:
                              BorderRadius.circular(AppSize.appSize12),
                          boxShadow: [
                            BoxShadow(
                                color: AppColor.black.withOpacity(0.4),
                                blurRadius: 1,
                                spreadRadius: 1)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              project.projectImages.isNotEmpty
                                  ? Image.network(
                                      "${AppConfigs.mediaUrl}${project.projectImages.first.images}?path=project",
                                      height: AppSize.appSize200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          "assets/myImg/no_preview_available.png",
                                          height: AppSize.appSize200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      "assets/myImg/no_preview_available.png",
                                      height: AppSize.appSize200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Text(
                                project.projectName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: AppStyle.heading3SemiBold(
                                    color: AppColor.black),
                              ).paddingOnly(top: AppSize.appSize10)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.user,
                                    color: AppColor.primaryColor,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    project.developerName,
                                    style: AppStyle.heading4Medium(
                                        color: AppColor.black),
                                  )
                                ],
                              ).paddingOnly(top: AppSize.appSize10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.locationDot,
                                    color: AppColor.primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Text(
                                    "${project.area != null ? "${project.area}," : ""} ${project.city} -${project.zipCode}, ${project.country}",
                                    style: AppStyle.heading5Medium(
                                        color: AppColor.black),
                                  ))
                                ],
                              ).paddingOnly(top: AppSize.appSize10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.indianRupeeSign,
                                    size: 15,
                                    color: AppColor.primaryColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    (() {
                                      final cleaned = project.priceRange
                                          .replaceAll(RegExp(r'\s*to\s*'), '-');
                                      final parts = cleaned.split('-');
                                      if (parts.length == 2) {
                                        final min =
                                            num.tryParse(parts[0].trim());
                                        final max =
                                            num.tryParse(parts[1].trim());
                                        if (min != null && max != null) {
                                          return "${PriceFormatUtils.formatIndianAmount(min, withRupee: false)} - ${PriceFormatUtils.formatIndianAmount(max, withRupee: false)}";
                                        }
                                      }
                                      final single =
                                          num.tryParse(cleaned.trim());
                                      return single != null
                                          ? PriceFormatUtils.formatIndianAmount(
                                              single,
                                              withRupee: false)
                                          : cleaned;
                                    })(),
                                    style: AppStyle.heading5Medium(
                                        color: AppColor.black),
                                  )
                                ],
                              ).paddingOnly(top: AppSize.appSize10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.landmark,
                                        size: 15,
                                        color: AppColor.primaryColor,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${project.noOfBhk ?? "--"} BHK",
                                        style: AppStyle.heading5Medium(
                                            color: AppColor.black),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.square,
                                        size: 15,
                                        color: AppColor.primaryColor,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${project.totalArea ?? "--"} sq.FT",
                                        style: AppStyle.heading5Medium(
                                            color: AppColor.black),
                                      )
                                    ],
                                  ),
                                ],
                              ).paddingOnly(top: AppSize.appSize15),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }

                return const Padding(
                  padding: EdgeInsets.all(AppSize.appSize16),
                  child: Center(
                      child: CircularProgressIndicator(
                          color: AppColor.primaryColor)),
                );
              }),
        )
      ],
    );
  }
}
