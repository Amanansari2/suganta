import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tytil_realty/views/home/widget/list_project_card.dart';

import '../../api_service/app_config.dart';
import '../../api_service/print_logger.dart';
import '../../common/common_button.dart';
import '../../common/price_format_utils.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_style.dart';
import '../../routes/app_routes.dart';

class ProjectViewAll extends StatefulWidget {
  final List<dynamic> projectViewAll;
  final String title;
  final Future<List<dynamic>> Function()? onLoadMore;
  final String? errorMessage;

  const ProjectViewAll(
      {super.key,
      required this.projectViewAll,
      this.onLoadMore,
      this.errorMessage,
      required this.title});

  @override
  State<ProjectViewAll> createState() => _ProjectViewAllState();
}

class _ProjectViewAllState extends State<ProjectViewAll> {
  List<dynamic> _localList = [];
  List<dynamic> _originalList = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  String _selectedFilter = 'None';

  @override
  void initState() {
    super.initState();
    _originalList = List.from(widget.projectViewAll);
    _localList = List.from(_originalList);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !_isLoadingMore &&
          widget.onLoadMore != null) {
        _loadMore();
      }
    });
  }

  void _applyFilter(String filter, {bool shouldScrollTop = true}) {
    DateTime now = DateTime.now();

    num getComparablePrice(dynamic project) {
      final priceRange = project.priceRange;
      if (priceRange != null && priceRange > 0) return priceRange;
      return 0;
    }

    DateTime? getUpdateDate(dynamic project) {
      try {
        final formatter = DateFormat("dd-MMM-yyy HH:mm:ss");
        final parsedDate = formatter.parse(project.createdAt);
        AppLogger.log(
            "Parsed CreatedAt -->>> ${project.createdAt} => $parsedDate");
        return parsedDate;
      } catch (e) {
        AppLogger.log("Date parsing Error -->>> ${project.createdAt} => $e");
        return null;
      }
    }

    List<dynamic> filterList = List.from(_originalList);

    switch (filter) {
      case 'Low to High':
        filterList.sort(
            (a, b) => getComparablePrice(a).compareTo(getComparablePrice(b)));
        break;

      case 'High to Low':
        filterList.sort(
            (a, b) => getComparablePrice(b).compareTo(getComparablePrice(a)));
        break;

      case 'Yesterday':
        filterList = filterList.where((proj) {
          final updated = getUpdateDate(proj);
          AppLogger.log("Filter Check (yesterday) -->>> ${updated.toString()}");
          return updated?.isAfter(now.subtract(const Duration(days: 1))) ??
              false;
        }).toList();
        break;

      case 'Last 3 Days':
        filterList = filterList.where((proj) {
          final update = getUpdateDate(proj);
          AppLogger.log(
              'Filter Check (Last 3 Days)---->> ${update.toString()}');
          return update?.isAfter(now.subtract(const Duration(days: 3))) ??
              false;
        }).toList();
        break;

      case 'Last 7 Days':
        filterList = filterList.where((proj) {
          final update = getUpdateDate(proj);
          AppLogger.log(
              'Filter Check (Last 7 Days)---->> ${update.toString()}');
          return update?.isAfter(now.subtract(const Duration(days: 7))) ??
              false;
        }).toList();
        break;

      case 'Last 1 Month':
        filterList = filterList.where((proj) {
          final update = getUpdateDate(proj);
          AppLogger.log(
              'Filter Check (Last 1 Month)---->> ${update.toString()}');
          return update?.isAfter(now.subtract(const Duration(days: 30))) ??
              false;
        }).toList();
        break;

      case 'Last 3 Month':
        filterList = filterList.where((proj) {
          final update = getUpdateDate(proj);
          AppLogger.log(
              'Filter Check (Last 3 Month)---->> ${update.toString()}');
          return update?.isAfter(now.subtract(const Duration(days: 90))) ??
              false;
        }).toList();
        break;

      case 'Last 6 Month':
        final cutoff = DateTime(now.year, now.month - 6, now.day);
        AppLogger.log('Current Time: $now, Cutoff: $cutoff');
        filterList = filterList.where((proj) {
          final update = getUpdateDate(proj);
          AppLogger.log(
              '6M Filter |Property: ${proj.id} | Created: $update | Show? ${update?.isAfter(cutoff)}');
          AppLogger.log(
              'Filter Check (Last 6 Month)---->> ${update.toString()}');
          return update?.isAfter(now.subtract(const Duration(days: 180))) ??
              false;
        }).toList();
        break;

      case 'Last 1 Year':
        final cutoff = now.subtract(const Duration(days: 365));
        AppLogger.log('Current Time: $now, Cutoff: $cutoff');

        filterList = filterList.where((proj) {
          final update = getUpdateDate(proj);
          AppLogger.log(
              '1Y Filter |Property: ${proj.id} | Created: $update | Show? ${update?.isAfter(cutoff)}');
          AppLogger.log(
              'Filter Check (Last 1 year)---->> ${update.toString()}');
          return update?.isAfter(cutoff) ?? false;
        }).toList();
        break;
    }

    setState(() {
      _selectedFilter = filter;
      _localList = filterList;
    });
    if (shouldScrollTop) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(0.0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });

    final moreData = await widget.onLoadMore!();
    if (moreData.isNotEmpty) {
      setState(() {
        _originalList.addAll(moreData);
        if (_selectedFilter == 'None') {
          _localList.addAll(moreData);
        } else {
          _applyFilter(_selectedFilter, shouldScrollTop: false);
        }
      });
    }

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColor.whiteColor,
        scrolledUnderElevation: 0.0,
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(top: 10, left: 16),
          //   child:

          // Row(
          //   children: [
          //     Text(
          //       "Sort by:",
          //       style: AppStyle.heading4Medium(color: AppColor.black),
          //     ),
          //     const SizedBox(
          //       width: 10,
          //     ),
          //     DropdownButton<String>(
          //         value: _selectedFilter,
          //         items: <String>[
          //           'None',
          //           'Low to High',
          //           'High to Low',
          //           'Yesterday',
          //           'Last 3 Days',
          //           'Last 7 Days',
          //           'Last 1 Month',
          //           'Last 3 Month',
          //           'Last 6 Month',
          //           'Last 1 Year',
          //         ].map((String value) {
          //           return DropdownMenuItem(
          //             value: value,
          //             child: Text(value),
          //           );
          //         }).toList(),
          //         onChanged: (val) {
          //           if (val != null) {
          //             _applyFilter(val);
          //           }
          //         })
          //   ],
          // ),
          //  ),
          Expanded(
              child: _localList.isEmpty
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            _selectedFilter == 'None'
                                ? (widget.errorMessage ??
                                    "No Projects available")
                                : "No Project Match Your Selected Filter",
                            textAlign: TextAlign.center,
                            style: AppStyle.heading2(color: AppColor.black),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          if (_selectedFilter == 'None')
                            CommonButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                "Back",
                                style: AppStyle.heading5Medium(
                                    color: AppColor.black),
                              ),
                            ).paddingOnly(
                                top: AppSize.appSize40,
                                right: AppSize.appSize40,
                                left: AppSize.appSize40)
                        ],
                      ),
                    ).paddingAll(AppSize.appSize40)
                  : Column(
                      children: [
                        Expanded(
                            child: Scrollbar(
                                controller: _scrollController,
                                thumbVisibility: true,
                                trackVisibility: true,
                                interactive: true,
                                thickness: 10,
                                radius: const Radius.circular(8),
                                child: ListView.builder(
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: _localList.length +
                                        (_isLoadingMore ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index >= _localList.length) {
                                        return const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        );
                                      }
                                      final project = _localList[index];
                                      final String imageUrl = project
                                              .projectImages.isNotEmpty
                                          ? "${AppConfigs.mediaUrl}${project.projectImages.first.images}?path=project"
                                          : "assets/images/default_image.png";

                                      return ListProjectCard(
                                        imageUrl: imageUrl,
                                        projectName: project.projectName,
                                        developerName: project.developerName,
                                        location: [
                                          project.city,
                                          project.area,
                                          project.zipCode
                                        ]
                                            .where((e) =>
                                                e != null &&
                                                e.toString().trim().isNotEmpty)
                                            .join(', '),
                                        price: (() {
                                          final cleaned = project.priceRange
                                              .replaceAll(
                                                  RegExp(r'\s*to\s*'), '-');
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
                                              ? PriceFormatUtils
                                                  .formatIndianAmount(single,
                                                      withRupee: false)
                                              : cleaned;
                                        })(),
                                        bhk: "${project.noOfBhk ?? "--"} ",
                                        project:
                                            project.project.toString() == '1'
                                                ? 'Commercial'
                                                : 'Residential',
                                        squareFt:
                                            "${project.totalArea ?? "--"} sq.FT",
                                        date: DateFormat('dd MMM yyyy').format(
                                            DateTime.parse(project.createdAt)
                                                .toLocal()),
                                        onTap: () {
                                          Get.toNamed(
                                              AppRoutes.projectDetailsView,
                                              arguments: {'project': project});
                                        },
                                        projectId: project.id,
                                      );
                                    })))
                      ],
                    ))
        ],
      ),
    );
  }
}
