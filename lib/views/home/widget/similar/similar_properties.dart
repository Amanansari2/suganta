import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../api_service/app_config.dart';
import '../../../../api_service/print_logger.dart';
import '../../../../common/price_format_utils.dart';
import '../../../../configs/app_color.dart';
import '../../../../configs/app_size.dart';
import '../../../../configs/app_style.dart';
import '../../../../model/property_model.dart';
import '../../../../routes/app_routes.dart';

class SimilarPropertyHorizontalList extends StatefulWidget {
  final String title;
  final List<BuyProperty> initialProperties;
  final Future<List<BuyProperty>> Function()? onLoadMore;

  const SimilarPropertyHorizontalList({
    super.key,
    required this.title,
    required this.initialProperties,
    this.onLoadMore,
  });

  @override
  State<SimilarPropertyHorizontalList> createState() =>
      _SimilarPropertyHorizontalListState();
}

class _SimilarPropertyHorizontalListState
    extends State<SimilarPropertyHorizontalList> {
  final ScrollController _scrollController = ScrollController();
  List<BuyProperty> _properties = [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _properties = List.from(widget.initialProperties);

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
  void didUpdateWidget(covariant SimilarPropertyHorizontalList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset properties when the initial properties change
    if (widget.initialProperties != oldWidget.initialProperties) {
      setState(() {
        _properties =
            List.from(widget.initialProperties); // Reset the properties
      });
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    final moreData = await widget.onLoadMore?.call() ?? [];
    if (moreData.isNotEmpty) {
      setState(() {
        _properties.addAll(moreData);
      });
    }
    setState(() => _isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.log("_properties inside build: ${_properties.length}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppStyle.heading4Medium(color: AppColor.textColor),
        ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16),
        SizedBox(
          height: AppSize.appSize355,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: AppSize.appSize16),
            itemCount: _properties.length + (_isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _properties.length) {
                final property = _properties[index];
                return GestureDetector(
                  onTap: () async {
                    await Get.offNamedUntil(
                        AppRoutes.propertyDetailsView, (route) => route.isFirst,
                        arguments: {
                          'property': property,
                        });
                  },
                  child: Container(
                    width: AppSize.appSize180,
                    padding: const EdgeInsets.all(AppSize.appSize10),
                    margin: const EdgeInsets.only(right: AppSize.appSize16),
                    decoration: BoxDecoration(
                      color: AppColor.secondaryColor,
                      borderRadius: BorderRadius.circular(AppSize.appSize12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              "${AppConfigs.mediaUrl}${property.firstImage?.imageUrl}?path=properties",
                              height: AppSize.appSize200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/myImg/no_preview_available",
                                  height: AppSize.appSize200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.typeOption?.option ?? "",
                              style: AppStyle.heading5SemiBold(
                                  color: AppColor.textColor),
                            ),
                            Text(
                              property.address.area,
                              style: AppStyle.heading5Regular(
                                  color: AppColor.descriptionColor),
                            ).paddingOnly(top: AppSize.appSize6),
                          ],
                        ).paddingOnly(top: AppSize.appSize16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  property.feature.rentAmount != null &&
                                          property.feature.rentAmount! > 0
                                      ? PriceFormatUtils.formatIndianAmount(
                                          property.feature.rentAmount ?? 0)
                                      : PriceFormatUtils.formatIndianAmount(
                                          property.feature.pricePerSquareFt ??
                                              0),
                                  style: AppStyle.heading5Medium(
                                      color: AppColor.primaryColor),
                                ),
                              ),
                              Text(
                                "★ ${property.feature.bhk} BHK",
                                style: AppStyle.heading5Medium(
                                    color: AppColor.primaryColor),
                              ).paddingOnly(right: AppSize.appSize6),
                            ],
                          ).paddingOnly(top: AppSize.appSize16),
                        ),
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
            },
          ),
        ).paddingOnly(top: AppSize.appSize16, bottom: AppSize.appSize16),
      ],
    );
  }
}
