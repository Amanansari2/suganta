import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../api_service/app_config.dart';
import '../../../api_service/print_logger.dart';
import '../../../common/common_button.dart';
import '../../../common/price_format_utils.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';
import '../../../configs/app_style.dart';
import '../../../routes/app_routes.dart';
import 'list_view_card.dart';

class WishListViewAll extends StatefulWidget {
  final List<dynamic> wishlistViewAll;
  final String title;
  final Future<List<dynamic>> Function()? onLoadMore;
  final String? errorMessage;

  const WishListViewAll(
      {Key? key,
        required this.wishlistViewAll,
        required this.title,
        this.onLoadMore,
        this.errorMessage})
      : super(key: key);

  @override
  State<WishListViewAll> createState() => _WishListViewAllState();
}

class _WishListViewAllState extends State<WishListViewAll> {
  List<dynamic> _localList = [];
  List<dynamic> _originalList = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  String _selectedFilter = 'None';
  bool _isFiltering = false;

  @override
  void initState() {
    super.initState();
    _originalList = List.from(widget.wishlistViewAll);
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

  void _applyFilter(String filter, {bool shouldScrollTop = true}) async {
    setState(() {
      _isFiltering = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));

    DateTime now = DateTime.now();

    num getComparablePrice(dynamic property) {
      final rent = property.feature?.rentAmount;
      final priceSqFt = property.feature?.pricePerSquareFt;

      if (rent != null && rent > 0) return rent;
      if (priceSqFt != null) return priceSqFt;
      return 0;
    }

    DateTime? getUpdatedDate(dynamic property) {
      try {
        final formatter = DateFormat("dd-MMM-yyyy HH:mm:ss");
        final parsedDate = formatter.parse(property.createdAt);
        AppLogger.log('Parsed CreatedAt: ${property.createdAt} => $parsedDate');
        return parsedDate;
      } catch (e) {
        AppLogger.log('Date parsing error: ${property.createdAt} => $e');
        return null;
      }
    }




    List<dynamic> filteredList = List.from(_originalList);

    switch (filter) {
      case 'Low to High':
        filteredList.sort(
                (a, b) => getComparablePrice(a).compareTo(getComparablePrice(b)));
        break;

      case 'High to Low':
        filteredList.sort(
                (a, b) => getComparablePrice(b).compareTo(getComparablePrice(a)));
        break;

      case 'Yesterday':
        filteredList = filteredList
            .where((prop) {
          final updated =  getUpdatedDate(prop);
          AppLogger.log('Filter Check (Yesterday)---->> ${updated.toString()}');
          return updated?.isAfter(now.subtract(const Duration(days: 1))) ?? false;
        }).toList();
        break;

      case 'Last 3 Days':
        filteredList = filteredList
            .where((prop) {
          final update = getUpdatedDate(prop);
          AppLogger.log('Filter Check (Last 3 Days)---->> ${update.toString()}');
          return update?.isAfter(now.subtract(const Duration(days: 3))) ?? false;
        }).toList();
        break;

      case 'Last 7 Days':
        filteredList = filteredList
            .where((prop) {
          final update = getUpdatedDate(prop);
          AppLogger.log('Filter Check (Last 7 Days)---->> ${update.toString()}');
          return update?.isAfter(now.subtract(const Duration(days: 7))) ?? false;
        }).toList();
        break;

      case 'Last 1 Month':
        filteredList = filteredList
            .where((prop) {
          final update = getUpdatedDate(prop);
          AppLogger.log('Filter Check (Last 1 Month)---->> ${update.toString()}');
          return update?.isAfter(now.subtract(const Duration(days: 30))) ?? false;
        }).toList();
        break;

      case 'Last 3 Month':
        filteredList = filteredList
            .where((prop){
          final update = getUpdatedDate(prop);
          AppLogger.log('Filter Check (Last 3 Month)---->> ${update.toString()}');
          return update?.isAfter(now.subtract(const Duration(days: 90))) ??false;
        })
            .toList();
        break;

      case 'Last 6 Month':
        final cutoff = DateTime(now.year, now.month - 6, now.day);
        AppLogger.log('Current Time: $now, Cutoff: $cutoff');
        filteredList = filteredList
            .where((prop) {
          final update = getUpdatedDate(prop);
          AppLogger.log('6M Filter |Property: ${prop.id} | Created: $update | Show? ${update?.isAfter(cutoff)}');
          AppLogger.log('Filter Check (Last 6 Month)---->> ${update.toString()}');
          return update?.isAfter(now.subtract(const Duration(days: 180))) ??false;
        }).toList();
        break;

      case 'Last 1 Year':
        final cutoff = now.subtract(const Duration(days: 365));
        AppLogger.log('Current Time: $now, Cutoff: $cutoff');


        filteredList = filteredList
            .where((prop) {
          final update = getUpdatedDate(prop);
          AppLogger.log('1Y Filter |Property: ${prop.id} | Created: $update | Show? ${update?.isAfter(cutoff)}');
          AppLogger.log('Filter Check (Last 1 year)---->> ${update.toString()}');
          return update?.isAfter(cutoff) ?? false;
        }).toList();
        break;
    }

    setState(() {
      _selectedFilter = filter;
      _localList = filteredList;
      _isFiltering = false;

    });
    if (shouldScrollTop) {
      WidgetsBinding.instance.addPostFrameCallback((_){
        _scrollController.animateTo(0.0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    }
  }

  bool isNonZero(dynamic value) {
    if (value == null) return false;
    final numVal = double.tryParse(value.toString());
    return numVal != null && numVal > 0;
  }

  String formatFloor(dynamic floor) {
    if (floor == null) return 'N/A';
    final int? val = int.tryParse(floor.toString());
    if (val == null) return 'N/A';
    return val == 0 ? 'Ground' : val.toString();
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });

    final moreData = await widget.onLoadMore!();

    if (moreData.isNotEmpty) {
      setState(() {
        _originalList.addAll(moreData);
        if(_selectedFilter == 'None'){
          _localList.addAll(moreData);
        }else {
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
      appBar: AppBar(title: Text(widget.title),
        backgroundColor: AppColor.whiteColor,
        scrolledUnderElevation: 0.0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 16),
            child: Row(
              children: [
                Text("Sort by: ", style:AppStyle.heading4Medium(color: AppColor.black),),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: <String>[
                    'None',
                    'Low to High',
                    'High to Low',
                    'Yesterday',
                    'Last 3 Days',
                    'Last 7 Days',
                    'Last 1 Month',
                    'Last 3 Month',
                    'Last 6 Month',
                    'Last 1 Year',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      _applyFilter(val);
                    }
                  },
                ),
              ],
            ),
          ),
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
                          ?(widget.errorMessage ?? "No Properties available")
                          :"No Property Match Your Selected Filter ",
                      textAlign: TextAlign.center,
                      style: AppStyle.heading2(color: AppColor.black)),
                  const SizedBox(
                    height: 50,
                  ),
                  if (_selectedFilter == 'None')
                    CommonButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "Back" ,
                        style:
                        AppStyle.heading5Medium(color: AppColor.whiteColor),
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
                  child: Stack(
                    children:[
                      Scrollbar(
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
                        itemCount: _localList.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < _localList.length) {
                            final property = _localList[index];

                            final String imageUrl = property.firstImage != null
                                ? "${AppConfigs.mediaUrl}${property.firstImage!.imageUrl}?path=properties"
                                : "assets/images/default_image.png";

                            return ListPropertyCard(
                              imageUrl: imageUrl,
                              name: property.user.name,
                              title: (property.type.trim().isEmpty)
                                  ? "PG"
                                  : property.type,
                              location:
                              [
                                property.address.subLocality,
                                property.address.area,
                                property.address.city,
                                property.address.pinCode
                              ].where((e) => e != null && e.toString().trim().isNotEmpty).join(', '),
                              availability: property.wantTo == "PG"
                                  ? ""
                                  : (property.feature.isUnderConstruction == 1
                                  ? "Ready to Move"
                                  : "Under Construction"),
                              floor:
                              "Floor ${formatFloor(property.feature.propertyOnFloor)} out of ${formatFloor(property.feature.noOfFloors)}",
                              carpetArea: isNonZero(property.feature.carpetArea)
                                  ? "${property.feature.carpetArea} ${property.feature.carpetAreaUnit}"
                                  : "",
                              buildUpArea: isNonZero(property.feature.buildArea)
                                  ? "${property.feature.buildArea} ${property.feature.buildAreaUnit}"
                                  : "",
                              plotArea: isNonZero(property.feature.plotArea)
                                  ? "${property.feature.plotArea} ${property.feature.plotAreaUnit}"
                                  : "",
                              price: property.feature.rentAmount != null &&
                                  property.feature.rentAmount! > 0
                                  ? PriceFormatUtils.formatIndianAmount(
                                  property.feature.rentAmount ?? 0)
                                  : PriceFormatUtils.formatIndianAmount(
                                  property.feature.pricePerSquareFt ?? 0),
                              onContact: () =>
                                  AppLogger.log("Contact Owner button clicked"),
                              onGetPhone: () =>
                                  AppLogger.log("Get Phone Number button clicked"),
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.propertyDetailsView,
                                  arguments: {'property': property},
                                );
                              },
                              propertyId: property.id,
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                                child: SpinKitSpinningLines(
                                  color: AppColor.primaryColor,
                                )),
                          );
                        },
                      ),
                    ),

                      if (_isFiltering)
                        const Center(
                          child: SpinKitSpinningLines(
                            size: 200,
                            color: AppColor.primaryColor,
                          ),
                        )
                 ] ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
