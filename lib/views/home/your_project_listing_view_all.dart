import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:tytil_realty/configs/app_string.dart';
import 'package:tytil_realty/views/home/widget/list_your_project_card.dart';
import 'package:tytil_realty/views/home/widget/manage_project_bottom_sheet.dart';

import '../../api_service/app_config.dart';
import '../../common/common_button.dart';
import '../../common/price_format_utils.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_style.dart';

class YourProjectListingViewAll extends StatefulWidget {
  final List<dynamic> projectViewAll;
  final String title;
  final Future<List<dynamic>> Function()? onLoadMore;
  final String? errorMessage;
  const YourProjectListingViewAll({
    super.key,
    required this.projectViewAll,
    this.onLoadMore,
    this.errorMessage,
    required this.title
  });

  @override
  State<YourProjectListingViewAll> createState() => _YourProjectListingViewAllState();
}

class _YourProjectListingViewAllState extends State<YourProjectListingViewAll> {

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

                                return ListYourProjectCard(
                                    imageUrl: imageUrl,
                                    projectName: project.projectName,
                                    developerName: project.developerName,
                                    location:
                                    [
                                      project.city,
                                      project.area,
                                      project.zipCode
                                    ].where((e) => e != null && e.toString().trim().isNotEmpty).join(', '),
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
                                    date: DateFormat('dd MMM yyyy')
                                        .format(DateTime.parse(
                                        project.createdAt)
                                        .toLocal()),
                                   projectId: project.id,
                                buttonText: AppString.manageProject,
                                onButtonPressed: (){
                                      manageProjectBottomSheet(context, project);
                                },
                                showWishlistIcon: false,
                                );
                              })))
                ],
              ))
        ],
      ),
    );
  }
}
