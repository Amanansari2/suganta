import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../api_service/print_logger.dart';
import '../../common/common_button.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/search_filter_controller.dart';
import '../../gen/assets.gen.dart';
import '../../model/area_model.dart';
import '../../model/city_model.dart';
import '../../model/project_dropdown_model.dart';
import '../home/project_list_view_all.dart';
import '../home/property_list_view_all.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  SearchFilterController searchFilterController =
      Get.find<SearchFilterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: Column(
        children: [
          Row(
            children: List.generate(searchFilterController.propertyList.length,
                (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    searchFilterController.updateProperty(index);
                    searchFilterController.resetAllFilters();
                  },
                  child: Obx(() => Container(
                        height: AppSize.appSize25,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.appSize14),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color:
                                  searchFilterController.selectProperty.value ==
                                          index
                                      ? AppColor.primaryColor
                                      : AppColor.borderColor,
                              width: AppSize.appSize1,
                            ),
                            right: BorderSide(
                              color: index == AppSize.size1
                                  ? Colors.transparent
                                  : AppColor.borderColor,
                              width: AppSize.appSize1,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            searchFilterController.propertyList[index],
                            style: AppStyle.heading5Medium(
                              color:
                                  searchFilterController.selectProperty.value ==
                                          index
                                      ? AppColor.primaryColor
                                      : AppColor.textColor,
                            ),
                          ),
                        ),
                      )),
                ),
              );
            }),
          ).paddingOnly(
            top: AppSize.appSize10,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Expanded(child: buildSearchData(context))
        ],
      ).paddingOnly(
        top: AppSize.appSize10,
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.whiteColor,
      scrolledUnderElevation: AppSize.appSize0,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSize.appSize16),
        child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Image.asset(
            Assets.images.backArrow.path,
          ),
        ),
      ),
      leadingWidth: AppSize.appSize40,
      title: Text(
        AppString.search,
        style: AppStyle.heading3Medium(color: AppColor.textColor),
      ),
      actions: [
        TextButton(
          onPressed: () {
            searchFilterController.resetAllFilters();
          },
          child: Text(
            'Reset All Filters',
            style: AppStyle.heading4SemiBold(color: AppColor.red),
          ),
        ).paddingOnly(right: AppSize.appSize16),
      ],
    );
  }

  Widget buildSearchData(BuildContext context) {
    return Obx(() {
      switch (searchFilterController.selectProperty.value) {
        case 0:
          return pgSearchData(context);

        case 1:
          return residentialSearchData(context);

        case 2:
          return commercialSearchData(context);

        case 3:
          return projectSearchData(context);

        default:
          return commercialSearchData(context);
      }
    });
  }

  Widget pgSearchData(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppString.city,
                    style: AppStyle.heading4Medium(color: AppColor.textColor))
                .paddingOnly(
              top: 10,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.primaryColor, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TypeAheadField<City>(
                key: const ValueKey("pg_city_typeahead"),
                controller: searchFilterController.pgSearchController,
                builder: (context, pgSearchController, focusNode) {
                  return TextField(
                    controller: pgSearchController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: "Type to search city...",
                      hintStyle: TextStyle(color: AppColor.descriptionColor),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                  );
                },
                suggestionsCallback: (String pattern) async {
                  return searchFilterController.pgCityOptions
                      .where((city) => city.name
                          .toLowerCase()
                          .contains(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, City suggestion) {
                  return ListTile(
                    title: Text(suggestion.name),
                  );
                },
                onSelected: (City selectedCity) {
                  searchFilterController.selectedPgCity = selectedCity;
                  searchFilterController.pgSearchController.text =
                      selectedCity.name;
                  searchFilterController.update();
                  searchFilterController.fetchPgAreaList(selectedCity.name);
                },
              ),
            ).paddingOnly(top: 10),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppString.area,
                    style: AppStyle.heading4Medium(color: AppColor.textColor))
                .paddingOnly(
              top: 10,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.primaryColor, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TypeAheadField<Area>(
                // key: const ValueKey("pg_area_typeahead"),
                key: ValueKey(
                    '${searchFilterController.pgAreaOptions.length}-${searchFilterController.selectProperty.value}'),
                controller: searchFilterController.pgAreaSearchController,
                builder: (context, pgAreaSearchController, focusNode) {
                  return TextField(
                    controller: pgAreaSearchController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: "Type to search Area...",
                      hintStyle: TextStyle(color: AppColor.descriptionColor),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                  );
                },
                suggestionsCallback: (String pattern) async {
                  AppLogger.log("🧪 Pattern received: $pattern");
                  AppLogger.log("📦 Available Area Options:");
                  for (var area in searchFilterController.pgAreaOptions) {
                    AppLogger.log("➡️ ${area.area}");
                  }

                  return searchFilterController.pgAreaOptions.where((area) {
                    final areaText = area.area.toLowerCase().trim();
                    final searchText = pattern.toLowerCase().trim();
                    return areaText.contains(searchText);
                  }).toList();
                },
                itemBuilder: (context, Area suggestion) {
                  return ListTile(
                    title: Text(suggestion.area),
                  );
                },
                onSelected: (Area selectedArea) {
                  searchFilterController.selectedPgArea = selectedArea;
                  searchFilterController.pgAreaSearchController.text =
                      selectedArea.area;
                  searchFilterController.update();
                },
                emptyBuilder: (context) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No area found',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                },
              ),
            ).paddingOnly(top: 10),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppString.selectBudget,
              style: AppStyle.heading4Medium(color: AppColor.textColor),
            ).paddingOnly(
              top: AppSize.appSize10,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: AppColor.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: AppColor.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: Obx(() => Row(
                    children: [
                      // 🔶 Min Price
                      Expanded(
                        child: DropdownButtonFormField2<double>(
                          isExpanded: true,
                          value:
                              searchFilterController.selectedPgMinAmount.value,
                          hint: const Text("Select Min Price"),
                          decoration: const InputDecoration(
                            labelText: "Minimum Price",
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          items: searchFilterController.pgAmountOptions
                              .map((amount) {
                            return DropdownMenuItem<double>(
                              value: amount,
                              child: Text(searchFilterController
                                  .formatCurrency(amount)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            searchFilterController
                                .updateSelectedPgMinAmount(value);
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      // 🔶 Max Price
                      Expanded(
                        child: DropdownButtonFormField2<double>(
                          isExpanded: true,
                          value:
                              searchFilterController.selectedPgMaxAmount.value,
                          hint: const Text("Select Max Price"),
                          decoration: const InputDecoration(
                            labelText: "Maximum Price",
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          items: searchFilterController.pgAmountOptions
                              .map((amount) {
                            return DropdownMenuItem<double>(
                              value: amount,
                              child: Text(searchFilterController
                                  .formatCurrency(amount)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            searchFilterController
                                .updateSelectedPgMaxAmount(value);
                          },
                        ),
                      ),
                    ],
                  )).paddingOnly(
                top: AppSize.appSize16,
              ),
            ),
          ],
        ).paddingOnly(top: AppSize.appSize10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppString.postedBy,
              style: AppStyle.heading4Medium(color: AppColor.textColor),
            ).paddingOnly(
              top: AppSize.appSize10,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            Obx(() {
              return Row(
                children:
                    searchFilterController.pgPostedByMap.entries.map((entry) {
                  final key = entry.key;
                  final label = entry.value;

                  return GestureDetector(
                    onTap: () {
                      searchFilterController.updatePgPostedByKey(key);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: searchFilterController
                                      .selectedPgPostedByKey.value ==
                                  key
                              ? AppColor.primaryColor
                              : AppColor.borderColor,
                        ),
                      ),
                      child: Text(
                        label,
                        style: AppStyle.heading5Medium(
                          color: searchFilterController
                                      .selectedPgPostedByKey.value ==
                                  key
                              ? AppColor.primaryColor
                              : AppColor.descriptionColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }).paddingOnly(
              top: AppSize.appSize16,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
          ],
        ).paddingOnly(top: AppSize.appSize15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppString.occupancy,
              style: AppStyle.heading4Medium(color: AppColor.textColor),
            ).paddingOnly(
              top: AppSize.appSize15,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            Obx(() => Wrap(
                  spacing: AppSize.appSize20,
                  runSpacing: AppSize.appSize1,
                  children: searchFilterController.pgOccupancyList.entries
                      .map((entry) {
                    final key = entry.key;
                    final label = entry.value;

                    return GestureDetector(
                      onTap: () {
                        searchFilterController.updatePgOccupancy(key);
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(bottom: AppSize.appSize10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.appSize16,
                            vertical: AppSize.appSize10),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSize.appSize12),
                          border: Border.all(
                            color: searchFilterController
                                        .selectPgOccupancy.value ==
                                    key
                                ? AppColor.primaryColor
                                : AppColor.borderColor,
                            width: AppSize.appSize1,
                          ),
                        ),
                        child: Text(
                          label,
                          style: AppStyle.heading5Medium(
                            color: searchFilterController
                                        .selectPgOccupancy.value ==
                                    key
                                ? AppColor.primaryColor
                                : AppColor.descriptionColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )).paddingOnly(
              top: AppSize.appSize10,
            ),
          ],
        ).paddingOnly(top: AppSize.appSize10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppString.suitableFor,
              style: AppStyle.heading4Medium(color: AppColor.textColor),
            ).paddingOnly(
              top: AppSize.appSize15,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            Obx(() => Wrap(
                  spacing: AppSize.appSize20,
                  runSpacing: AppSize.appSize1,
                  children: searchFilterController.pgSuitableForList.entries
                      .map((entry) {
                    final key = entry.key;
                    final label = entry.value;

                    return GestureDetector(
                      onTap: () {
                        searchFilterController.updatePgSuitableFor(key);
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(bottom: AppSize.appSize10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.appSize16,
                            vertical: AppSize.appSize10),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSize.appSize12),
                          border: Border.all(
                            color: searchFilterController
                                        .selectPgSuitableFor.value ==
                                    key
                                ? AppColor.primaryColor
                                : AppColor.borderColor,
                            width: AppSize.appSize1,
                          ),
                        ),
                        child: Text(
                          label,
                          style: AppStyle.heading5Medium(
                            color: searchFilterController
                                        .selectPgSuitableFor.value ==
                                    key
                                ? AppColor.primaryColor
                                : AppColor.descriptionColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )).paddingOnly(
              top: AppSize.appSize10,
            ),
          ],
        ).paddingOnly(top: AppSize.appSize10),
        searchFilterController.isPgPaginating.value
            ? const Center(
                child: CircularProgressIndicator(color: AppColor.primaryColor),
              ).paddingOnly(top: AppSize.appSize36, bottom: AppSize.appSize36)
            : CommonButton(
                onPressed: () async {
                  final pgCityName =
                      searchFilterController.selectedPgCity?.name;
                  if (pgCityName == null || pgCityName.trim().isEmpty) {
                    Get.snackbar("Error", "Please select a valid city");
                    return;
                  }

                  final pgMinAmount =
                      searchFilterController.selectedPgMinAmount.value?.toInt();
                  final pgMaxAmount =
                      searchFilterController.selectedPgMaxAmount.value?.toInt();

                  if (pgMinAmount != null &&
                      pgMaxAmount != null &&
                      pgMinAmount > pgMaxAmount!) {
                    Get.snackbar("Error",
                        "Minimum amount must be less than or equal to maximum amount.");
                    return;
                  }

                  searchFilterController.paginatedPgSearchProperty.clear();
                  await searchFilterController.fetchPgPaginatedProperties(
                      isLoadMore: false);

                  final List<dynamic> pgInitialData =
                      searchFilterController.paginatedPgSearchProperty;
                  Get.to(() => PropertyViewAll(
                        propertyViewAll: List.from(pgInitialData),
                        title: "Pg Properties",
                        onLoadMore: () async {
                          final prevCount = searchFilterController
                              .paginatedPgSearchProperty.length;
                          await searchFilterController
                              .fetchPgPaginatedProperties(isLoadMore: true);
                          final newCount = searchFilterController
                              .paginatedPgSearchProperty.length;
                          return searchFilterController
                              .paginatedPgSearchProperty
                              .sublist(prevCount, newCount);
                        },
                        errorMessage: pgInitialData.isEmpty
                            ? "Oops! We couldn't find any properties matching your filters. Try adjusting them to discover more!"
                            : null,
                      ))?.whenComplete(() {
                    searchFilterController.resetAllFilters();
                  });
                },
                child: Text(
                  AppString.search,
                  style: AppStyle.heading5Medium(color: AppColor.whiteColor),
                ),
              ).paddingOnly(
                top: AppSize.appSize36,
                bottom: AppSize.appSize36,
                right: AppSize.appSize36,
                left: AppSize.appSize36),
      ],
    ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16));
  }

  Widget residentialSearchData(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.city,
                      style: AppStyle.heading4Medium(color: AppColor.textColor))
                  .paddingOnly(
                top: 10,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TypeAheadField<City>(
                  key: const ValueKey("residential_city_typeahead"),
                  controller:
                      searchFilterController.residentialSearchController,
                  builder: (context, textEditingController, focusNode) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        hintText: "Type to search city...",
                        hintStyle: TextStyle(color: AppColor.descriptionColor),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                    );
                  },
                  suggestionsCallback: (String pattern) async {
                    return searchFilterController.residentialCityOptions
                        .where((city) => city.name
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, City suggestion) {
                    return ListTile(
                      title: Text(suggestion.name),
                    );
                  },
                  onSelected: (City selectedCity) {
                    searchFilterController.selectedResidentialCity =
                        selectedCity;
                    searchFilterController.residentialSearchController.text =
                        selectedCity.name;
                    searchFilterController.update();
                    searchFilterController
                        .fetchResidentialAreaList(selectedCity.name);
                  },
                ),
              ).paddingOnly(top: 10),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.area,
                      style: AppStyle.heading4Medium(color: AppColor.textColor))
                  .paddingOnly(
                top: 10,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TypeAheadField<Area>(
                    // key: const ValueKey("residential_area_typeahead"),
                    key: ValueKey(
                        '${searchFilterController.residentialAreaOptions.length}-${searchFilterController.selectProperty.value}'),
                    controller:
                        searchFilterController.residentialAreaSearchController,
                    builder:
                        (context, residentialAreaSearchController, focusNode) {
                      return TextField(
                        controller: residentialAreaSearchController,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          hintText: "Type to search Area...",
                          hintStyle:
                              TextStyle(color: AppColor.descriptionColor),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                        ),
                      );
                    },
                    suggestionsCallback: (String pattern) async {
                      AppLogger.log(
                          "🧪 Residential Pattern received: $pattern");
                      AppLogger.log("📦 Residential Available Area Options:");
                      for (var area
                          in searchFilterController.residentialAreaOptions) {
                        AppLogger.log("➡️ ${area.area}");
                      }
                      return searchFilterController.residentialAreaOptions
                          .where((area) {
                        final areaText = area.area.toLowerCase().trim();
                        final searchText = pattern.toLowerCase().trim();
                        return areaText.contains(searchText);
                      }).toList();
                    },
                    itemBuilder: (context, Area suggestion) {
                      return ListTile(
                        title: Text(suggestion.area),
                      );
                    },
                    onSelected: (Area selectedArea) {
                      searchFilterController.selectedResidentialArea =
                          selectedArea;
                      searchFilterController.residentialAreaSearchController
                          .text = selectedArea.area;
                      searchFilterController.update();
                    },
                    emptyBuilder: (context) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No area found',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      );
                    }),
              ).paddingOnly(top: 10),
            ],
          ),
          Obx(() {
            final filteredList =
                searchFilterController.residentialPropertyTypeList;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.typesOfProperty,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ).paddingOnly(
                  top: AppSize.appSize10,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                ),
                Wrap(
                  spacing: AppSize.appSize10,
                  runSpacing: AppSize.appSize1,
                  children: List.generate(filteredList.length, (i) {
                    final label = filteredList[i];

                    return GestureDetector(
                      onTap: () {
                        searchFilterController
                            .selectResidentialTypesOfProperty.value = label;
                      },
                      child: Obx(() => Container(
                            margin: const EdgeInsets.only(
                                bottom: AppSize.appSize10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.appSize16,
                              vertical: AppSize.appSize10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppSize.appSize12),
                              border: Border.all(
                                color: searchFilterController
                                            .selectResidentialTypesOfProperty
                                            .value ==
                                        label
                                    ? AppColor.primaryColor
                                    : AppColor.borderColor,
                                width: AppSize.appSize1,
                              ),
                            ),
                            child: Text(
                              label,
                              style: AppStyle.heading5Medium(
                                color: searchFilterController
                                            .selectResidentialTypesOfProperty
                                            .value ==
                                        label
                                    ? AppColor.primaryColor
                                    : AppColor.descriptionColor,
                              ),
                            ),
                          )),
                    );
                  }),
                ).paddingOnly(top: AppSize.appSize10),
              ],
            ).paddingOnly(top: AppSize.appSize15);
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.selectBudget,
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize10,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: InputDecorationTheme(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColor.primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColor.primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Obx(() => Row(
                      children: [
                        // 🔶 Min Price
                        Expanded(
                          child: DropdownButtonFormField2<double>(
                            isExpanded: true,
                            value: searchFilterController
                                .selectedResidentialMinAmount.value,
                            hint: const Text("Select Min Price"),
                            decoration: const InputDecoration(
                              labelText: "Minimum Price",
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            items: searchFilterController
                                .residentialAmountOptions
                                .map((amount) {
                              return DropdownMenuItem<double>(
                                value: amount,
                                child: Text(searchFilterController
                                    .formatCurrency(amount)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              searchFilterController
                                  .updateSelectedResidentialMinAmount(value);
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        // 🔶 Max Price
                        Expanded(
                          child: DropdownButtonFormField2<double>(
                            isExpanded: true,
                            value: searchFilterController
                                .selectedResidentialMaxAmount.value,
                            hint: const Text("Select Max Price"),
                            decoration: const InputDecoration(
                              labelText: "Maximum Price",
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            items: searchFilterController
                                .residentialAmountOptions
                                .map((amount) {
                              return DropdownMenuItem<double>(
                                value: amount,
                                child: Text(searchFilterController
                                    .formatCurrency(amount)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              searchFilterController
                                  .updateSelectedResidentialMaxAmount(value);
                            },
                          ),
                        ),
                      ],
                    )).paddingOnly(
                  top: AppSize.appSize16,
                ),
              ),
            ],
          ).paddingOnly(top: AppSize.appSize10),
          Obx(() {
            final selectedType =
                searchFilterController.selectResidentialTypesOfProperty.value;
            if (selectedType == AppString.residentialPlotLand) {
              return const SizedBox();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.bhkOptions,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ).paddingOnly(
                  top: AppSize.appSize15,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                ),
                Wrap(
                  spacing: AppSize.appSize20,
                  runSpacing: AppSize.appSize1,
                  children: searchFilterController.residentialBhkList.entries
                      .map((entry) {
                    final key = entry.key;
                    final label = entry.value;

                    return GestureDetector(
                      onTap: () {
                        searchFilterController.updateResidentialBhk(key);
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(bottom: AppSize.appSize10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.appSize16,
                            vertical: AppSize.appSize10),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSize.appSize12),
                          border: Border.all(
                            color: searchFilterController
                                        .selectResidentialBhk.value ==
                                    key
                                ? AppColor.primaryColor
                                : AppColor.borderColor,
                            width: AppSize.appSize1,
                          ),
                        ),
                        child: Text(
                          label,
                          style: AppStyle.heading5Medium(
                            color: searchFilterController
                                        .selectResidentialBhk.value ==
                                    key
                                ? AppColor.primaryColor
                                : AppColor.descriptionColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ).paddingOnly(
                  top: AppSize.appSize10,
                ),
              ],
            ).paddingOnly(top: AppSize.appSize10);
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.postedBy,
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize10,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Obx(() {
                return Row(
                  children: searchFilterController
                      .residentialPostedByMap.entries
                      .map((entry) {
                    final key = entry.key;
                    final label = entry.value;

                    return GestureDetector(
                      onTap: () {
                        searchFilterController
                            .updateResidentialPostedByKey(key);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: searchFilterController
                                        .selectedResidentialPostedByKey.value ==
                                    key
                                ? AppColor.primaryColor
                                : AppColor.borderColor,
                          ),
                        ),
                        child: Text(
                          label,
                          style: AppStyle.heading5Medium(
                            color: searchFilterController
                                        .selectedResidentialPostedByKey.value ==
                                    key
                                ? AppColor.primaryColor
                                : AppColor.descriptionColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).paddingOnly(
                top: AppSize.appSize16,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
            ],
          ).paddingOnly(top: AppSize.appSize15),
          searchFilterController.isResidentialPaginating.value
              ? const Center(
                  child:
                      CircularProgressIndicator(color: AppColor.primaryColor),
                ).paddingOnly(top: AppSize.appSize36, bottom: AppSize.appSize36)
              : CommonButton(
                  onPressed: () async {
                    final residentialCityName =
                        searchFilterController.selectedResidentialCity?.name;
                    if (residentialCityName == null ||
                        residentialCityName.trim().isEmpty) {
                      Get.snackbar("Error", "Please select a valid city");
                      return;
                    }

                    final residentialMinAmount = searchFilterController
                        .selectedResidentialMinAmount.value
                        ?.toInt();
                    final residentialMaxAmount = searchFilterController
                        .selectedResidentialMaxAmount.value
                        ?.toInt();

                    if (residentialMinAmount != null &&
                        residentialMaxAmount != null &&
                        residentialMinAmount > residentialMaxAmount!) {
                      Get.snackbar("Error",
                          "Minimum amount must be less than or equal to maximum amount.");
                      return;
                    }

                    searchFilterController.paginatedResidentialSearchProperty
                        .clear();

                    await searchFilterController
                        .fetchResidentialPaginatedProperties(isLoadMore: false);

                    final List<dynamic> residentialInitialData =
                        searchFilterController
                            .paginatedResidentialSearchProperty;

                    Get.to(() => PropertyViewAll(
                          propertyViewAll: List.from(residentialInitialData),
                          title: "Residential Properties",
                          onLoadMore: () async {
                            final prevCount = searchFilterController
                                .paginatedResidentialSearchProperty.length;
                            await searchFilterController
                                .fetchResidentialPaginatedProperties(
                                    isLoadMore: true);
                            final newCount = searchFilterController
                                .paginatedResidentialSearchProperty.length;
                            return searchFilterController
                                .paginatedResidentialSearchProperty
                                .sublist(prevCount, newCount);
                          },
                          errorMessage: residentialInitialData.isEmpty
                              ? "Oops! We couldn't find any properties matching your filters. Try adjusting them to discover more!"
                              : null,
                        ))?.whenComplete(() {
                      searchFilterController.resetAllFilters();
                    });
                  },
                  child: Text(
                    AppString.search,
                    style: AppStyle.heading5Medium(color: AppColor.whiteColor),
                  ),
                ).paddingOnly(
                  top: AppSize.appSize36,
                  bottom: AppSize.appSize36,
                  right: AppSize.appSize36,
                  left: AppSize.appSize36),
        ],
      ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),
    );
  }

  Widget commercialSearchData(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.city,
                      style: AppStyle.heading4Medium(color: AppColor.textColor))
                  .paddingOnly(
                top: 10,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TypeAheadField<City>(
                  key: const ValueKey("commercial_city_typeahead"),
                  controller: searchFilterController.commercialSearchController,
                  builder:
                      (context, commercialTextEditingController, focusNode) {
                    return TextField(
                      controller: commercialTextEditingController,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        hintText: "Type to search city...",
                        hintStyle: TextStyle(color: AppColor.descriptionColor),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                    );
                  },
                  suggestionsCallback: (String pattern) async {
                    return searchFilterController.commercialCityOptions
                        .where((city) => city.name
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, City suggestion) {
                    return ListTile(
                      title: Text(suggestion.name),
                    );
                  },
                  onSelected: (City selectedCity) {
                    searchFilterController.selectedCommercialCity =
                        selectedCity;
                    searchFilterController.commercialSearchController.text =
                        selectedCity.name;
                    searchFilterController.update();
                    searchFilterController
                        .fetchCommercialAreaList(selectedCity.name);
                  },
                ),
              ).paddingOnly(top: 10),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.area,
                      style: AppStyle.heading4Medium(color: AppColor.textColor))
                  .paddingOnly(
                top: 10,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TypeAheadField<Area>(
                  // key: const ValueKey("commercial_area_typeahead"),
                  key: ValueKey(
                      '${searchFilterController.commercialAreaOptions.length}-${searchFilterController.selectProperty.value}'),
                  controller:
                      searchFilterController.commercialAreaSearchController,
                  builder:
                      (context, commercialAreaSearchController, focusNode) {
                    return TextField(
                      controller: commercialAreaSearchController,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        hintText: "Type to search Area...",
                        hintStyle: TextStyle(color: AppColor.descriptionColor),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                    );
                  },
                  suggestionsCallback: (String pattern) async {
                    final searchText = pattern.toLowerCase().trim();

                    AppLogger.log("🔍 User Typed: $searchText");
                    AppLogger.log("📦 List:");
                    AppLogger.log("🧪 Pattern received: $pattern");
                    AppLogger.log("📦 Available Area Options:");
                    for (var area
                        in searchFilterController.commercialAreaOptions) {
                      AppLogger.log("➡️ ${area.area}");
                    }
                    if (searchText.isEmpty) {
                      return searchFilterController.commercialAreaOptions;
                    }

                    // final searchText = pattern.toLowerCase().trim();
                    //
                    // if (searchText.isEmpty) {
                    //   return searchFilterController.commercialAreaOptions;
                    // }

                    return searchFilterController.commercialAreaOptions
                        .where((area) {
                      final areaText = area.area.toLowerCase().trim();
                      final searchText = pattern.toLowerCase().trim();
                      return areaText.contains(searchText);
                    }).toList();
                  },
                  itemBuilder: (context, Area suggestion) {
                    return ListTile(
                      title: Text(suggestion.area),
                    );
                  },
                  onSelected: (Area selectedArea) {
                    searchFilterController.selectedCommercialArea =
                        selectedArea;
                    searchFilterController.commercialAreaSearchController.text =
                        selectedArea.area;
                    searchFilterController.update();
                  },
                  emptyBuilder: (context) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No area found',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ).paddingOnly(top: 10),
            ],
          ),
          Obx(() {
            final filteredList =
                searchFilterController.commercialPropertyTypeList;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.typesOfProperty,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ).paddingOnly(
                  top: AppSize.appSize10,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                ),
                Wrap(
                  spacing: AppSize.appSize10,
                  runSpacing: AppSize.appSize1,
                  children: List.generate(filteredList.length, (i) {
                    final label = filteredList[i];

                    return GestureDetector(
                      onTap: () {
                        searchFilterController
                            .selectCommercialTypesOfProperty.value = label;
                      },
                      child: Obx(() => Container(
                            margin: const EdgeInsets.only(
                                bottom: AppSize.appSize10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.appSize16,
                              vertical: AppSize.appSize10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppSize.appSize12),
                              border: Border.all(
                                color: searchFilterController
                                            .selectCommercialTypesOfProperty
                                            .value ==
                                        label
                                    ? AppColor.primaryColor
                                    : AppColor.borderColor,
                                width: AppSize.appSize1,
                              ),
                            ),
                            child: Text(
                              label,
                              style: AppStyle.heading5Medium(
                                color: searchFilterController
                                            .selectCommercialTypesOfProperty
                                            .value ==
                                        label
                                    ? AppColor.primaryColor
                                    : AppColor.descriptionColor,
                              ),
                            ),
                          )),
                    );
                  }),
                ).paddingOnly(top: AppSize.appSize10),
              ],
            ).paddingOnly(top: AppSize.appSize15);
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.selectBudget,
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize10,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: InputDecorationTheme(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColor.primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColor.primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Obx(() => Row(
                      children: [
                        // 🔶 Min Price
                        Expanded(
                          child: DropdownButtonFormField2<double>(
                            isExpanded: true,
                            value: searchFilterController
                                .selectedCommercialMinAmount.value,
                            hint: const Text("Select Min Price"),
                            decoration: const InputDecoration(
                              labelText: "Minimum Price",
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            items: searchFilterController
                                .commercialAmountOptions
                                .map((amount) {
                              return DropdownMenuItem<double>(
                                value: amount,
                                child: Text(searchFilterController
                                    .formatCurrency(amount)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              searchFilterController
                                  .updateSelectedCommercialMinAmount(value);
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        // 🔶 Max Price
                        Expanded(
                          child: DropdownButtonFormField2<double>(
                            isExpanded: true,
                            value: searchFilterController
                                .selectedCommercialMaxAmount.value,
                            hint: const Text("Select Max Price"),
                            decoration: const InputDecoration(
                              labelText: "Maximum Price",
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            items: searchFilterController
                                .commercialAmountOptions
                                .map((amount) {
                              return DropdownMenuItem<double>(
                                value: amount,
                                child: Text(searchFilterController
                                    .formatCurrency(amount)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              searchFilterController
                                  .updateSelectedCommercialMaxAmount(value);
                            },
                          ),
                        ),
                      ],
                    )).paddingOnly(
                  top: AppSize.appSize16,
                ),
              ),
            ],
          ).paddingOnly(top: AppSize.appSize10),
          Obx(() {
            final selectedCommercialType =
                searchFilterController.selectCommercialTypesOfProperty.value;
            if (selectedCommercialType == AppString.residentialPlotLand) {
              return const SizedBox();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.bhkOptions,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ).paddingOnly(
                  top: AppSize.appSize15,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                ),
                Wrap(
                  spacing: AppSize.appSize20,
                  runSpacing: AppSize.appSize1,
                  children: searchFilterController.commercialBhkList.entries
                      .map((entry) {
                    final key = entry.key;
                    final label = entry.value;

                    return GestureDetector(
                      onTap: () {
                        searchFilterController.updateCommercialBhk(key);
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(bottom: AppSize.appSize10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.appSize16,
                            vertical: AppSize.appSize10),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSize.appSize12),
                          border: Border.all(
                            color: searchFilterController
                                        .selectCommercialBhk.value ==
                                    key
                                ? AppColor.primaryColor
                                : AppColor.borderColor,
                            width: AppSize.appSize1,
                          ),
                        ),
                        child: Text(
                          label,
                          style: AppStyle.heading5Medium(
                            color: searchFilterController
                                        .selectCommercialBhk.value ==
                                    key
                                ? AppColor.primaryColor
                                : AppColor.descriptionColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ).paddingOnly(
                  top: AppSize.appSize10,
                ),
              ],
            ).paddingOnly(top: AppSize.appSize10);
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.postedBy,
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize10,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Obx(() {
                return Row(
                  children: searchFilterController.commercialPostedByMap.entries
                      .map((entry) {
                    final key = entry.key;
                    final label = entry.value;

                    return GestureDetector(
                      onTap: () {
                        searchFilterController.updateCommercialPostedByKey(key);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: searchFilterController
                                        .selectedCommercialPostedByKey.value ==
                                    key
                                ? AppColor.primaryColor
                                : AppColor.borderColor,
                          ),
                        ),
                        child: Text(
                          label,
                          style: AppStyle.heading5Medium(
                            color: searchFilterController
                                        .selectedCommercialPostedByKey.value ==
                                    key
                                ? AppColor.primaryColor
                                : AppColor.descriptionColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).paddingOnly(
                top: AppSize.appSize16,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
            ],
          ).paddingOnly(top: AppSize.appSize15),
          searchFilterController.isCommercialPaginating.value
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                ).paddingOnly(top: AppSize.appSize36, bottom: AppSize.appSize36)
              : CommonButton(
                  onPressed: () async {
                    final commercialCityName =
                        searchFilterController.selectedCommercialCity?.name;
                    if (commercialCityName == null ||
                        commercialCityName.trim().isEmpty) {
                      Get.snackbar("Error", "Please select a valid city");
                      return;
                    }

                    final commercialMinAmount = searchFilterController
                        .selectedCommercialMinAmount.value
                        ?.toInt();
                    final commercialMaxAmount = searchFilterController
                        .selectedCommercialMaxAmount.value
                        ?.toInt();

                    if (commercialMinAmount != null &&
                        commercialMaxAmount != null &&
                        commercialMinAmount > commercialMaxAmount!) {
                      Get.snackbar("Error",
                          "Minimum amount must be less than or equal to maximum amount.");
                      return;
                    }

                    searchFilterController.paginatedCommercialSearchProperty
                        .clear();
                    await searchFilterController
                        .fetchCommercialPaginatedProperties(isLoadMore: false);

                    final List<dynamic> commercialInitialData =
                        searchFilterController
                            .paginatedCommercialSearchProperty;

                    Get.to(() => PropertyViewAll(
                          propertyViewAll: List.from(commercialInitialData),
                          title: "Commercial Properties",
                          onLoadMore: () async {
                            final prevCount = searchFilterController
                                .paginatedCommercialSearchProperty.length;
                            await searchFilterController
                                .fetchCommercialPaginatedProperties(
                                    isLoadMore: true);
                            final newCount = searchFilterController
                                .paginatedCommercialSearchProperty.length;
                            return searchFilterController
                                .paginatedCommercialSearchProperty
                                .sublist(prevCount, newCount);
                          },
                          errorMessage: commercialInitialData.isEmpty
                              ? "Oops! We couldn't find any properties matching your filters. Try adjusting them to discover more!"
                              : null,
                        ))?.whenComplete(() {
                      searchFilterController.resetAllFilters();
                    });
                  },
                  child: Text(
                    AppString.search,
                    style: AppStyle.heading5Medium(color: AppColor.whiteColor),
                  ),
                ).paddingOnly(
                  top: AppSize.appSize36,
                  bottom: AppSize.appSize36,
                  right: AppSize.appSize36,
                  left: AppSize.appSize36),
        ],
      ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),
    );
  }

  Widget projectSearchData(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() {
            final combinedList = <Map<String, dynamic>>[];

            if (searchFilterController.projectTypeResidentialList.isNotEmpty) {
              combinedList.add({"isHeader": true, "label": "Residential"});
              combinedList.addAll(searchFilterController
                  .projectTypeResidentialList
                  .map((e) => {"isHeader": false, "item": e}));
            }

            if (searchFilterController.projectTypeCommercialList.isNotEmpty) {
              combinedList.add({"isHeader": true, "label": "Commercial"});
              combinedList.addAll(searchFilterController
                  .projectTypeCommercialList
                  .map((e) => {"isHeader": false, "item": e}));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Project Type",
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ).paddingOnly(
                  top: AppSize.appSize20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<ProjectDropdownItemModel>(
                      isExpanded: true,
                      hint: const Text("Select Project Type"),
                      value: searchFilterController
                              .selectedProjectTypeResidentialList.value ??
                          searchFilterController
                              .selectedProjectTypeCommercialList.value,
                      items: combinedList.map((entry) {
                        if (entry["isHeader"] == true) {
                          return DropdownMenuItem<ProjectDropdownItemModel>(
                            enabled: false,
                            child: Text(
                              entry["label"],
                              style: AppStyle.heading5Medium(
                                color: AppColor.descriptionColor,
                              ),
                            ),
                          );
                        } else {
                          final item =
                              entry["item"] as ProjectDropdownItemModel;
                          return DropdownMenuItem<ProjectDropdownItemModel>(
                            value: item,
                            child: Text(item.name ?? ""),
                          );
                        }
                      }).toList(),
                      onChanged: (value) {
                        if (value?.type == 2) {
                          searchFilterController
                              .selectedProjectTypeCommercialList.value = value;
                          searchFilterController
                              .selectedProjectTypeResidentialList.value = null;
                        } else if (value?.type == 8) {
                          searchFilterController
                              .selectedProjectTypeResidentialList.value = value;
                          searchFilterController
                              .selectedProjectTypeCommercialList.value = null;
                        }
                      },
                    ),
                  ),
                ).paddingOnly(top: AppSize.appSize10),
              ],
            );
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.city,
                      style: AppStyle.heading4Medium(color: AppColor.textColor))
                  .paddingOnly(
                top: 10,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TypeAheadField<City>(
                  key: const ValueKey("project_city_typeahead"),
                  controller: searchFilterController.projectSearchController,
                  builder: (context, projectSearchController, focusNode) {
                    return TextField(
                      controller:
                          searchFilterController.projectSearchController,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        hintText: "Type to search city...",
                        hintStyle: TextStyle(color: AppColor.descriptionColor),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                    );
                  },
                  suggestionsCallback: (String pattern) async {
                    return searchFilterController.projectCityOptions
                        .where((city) => city.name
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, City suggestion) {
                    return ListTile(
                      title: Text(suggestion.name),
                    );
                  },
                  onSelected: (City selectedCity) {
                    searchFilterController.selectedProjectCity = selectedCity;
                    searchFilterController.projectSearchController.text =
                        selectedCity.name;
                    searchFilterController.update();
                    searchFilterController
                        .fetchProjectAreaList(selectedCity.name);
                  },
                ),
              ).paddingOnly(top: 10),
            ],
          ).paddingOnly(top: AppSize.appSize10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.area,
                      style: AppStyle.heading4Medium(color: AppColor.textColor))
                  .paddingOnly(
                top: 10,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TypeAheadField<Area>(
                  // key: const ValueKey("project_area_typeahead"),
                  key: ValueKey(
                      '${searchFilterController.projectAreaOptions.length}-${searchFilterController.selectProperty.value}'),
                  controller:
                      searchFilterController.projectAreaSearchController,
                  builder: (context, projectAreaSearchController, focusNode) {
                    return TextField(
                      controller: projectAreaSearchController,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        hintText: "Type to search Area...",
                        hintStyle: TextStyle(color: AppColor.descriptionColor),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                    );
                  },
                  suggestionsCallback: (String pattern) async {
                    AppLogger.log("🧪 Pattern received: $pattern");
                    AppLogger.log("📦 Available Area Options:");
                    for (var area
                        in searchFilterController.projectAreaOptions) {
                      AppLogger.log("➡️ ${area.area}");
                    }

                    return searchFilterController.projectAreaOptions
                        .where((area) {
                      final areaText = area.area.toLowerCase().trim();
                      final searchText = pattern.toLowerCase().trim();
                      return areaText.contains(searchText);
                    }).toList();
                  },
                  itemBuilder: (context, Area suggestion) {
                    return ListTile(
                      title: Text(suggestion.area),
                    );
                  },
                  onSelected: (Area selectedArea) {
                    searchFilterController.selectedProjectArea = selectedArea;
                    searchFilterController.projectAreaSearchController.text =
                        selectedArea.area;
                    searchFilterController.update();
                  },
                  emptyBuilder: (context) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No area found',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ).paddingOnly(top: 10),
            ],
          ),
          searchFilterController.isProjectPaginating.value
              ? const Center(
                  child:
                      CircularProgressIndicator(color: AppColor.primaryColor),
                ).paddingOnly(top: AppSize.appSize36, bottom: AppSize.appSize36)
              : CommonButton(
                  onPressed: () async {
                    final selectedProject =
                        searchFilterController.selectedProjectType;
                    if (selectedProject == null) {
                      Get.snackbar("Error", "Please select a project type");
                      return;
                    }

                    searchFilterController.paginatedProjectSearchProject
                        .clear();
                    await searchFilterController.fetchProjectPaginatedProject(
                        isLoadMore: false);

                    final List<dynamic> projectInitialData =
                        searchFilterController.paginatedProjectSearchProject;
                    Get.to(() => ProjectViewAll(
                          projectViewAll: List.from(projectInitialData),
                          title: "Projects",
                          onLoadMore: () async {
                            final prevCount = searchFilterController
                                .paginatedProjectSearchProject.length;
                            await searchFilterController
                                .fetchProjectPaginatedProject(isLoadMore: true);
                            final newCount = searchFilterController
                                .paginatedProjectSearchProject.length;
                            return searchFilterController
                                .paginatedProjectSearchProject
                                .sublist(prevCount, newCount);
                          },
                          errorMessage: projectInitialData.isEmpty
                              ? "Oops! We couldn't find any Projects matching your filters. Try adjusting them to discover more!"
                              : null,
                        ))?.whenComplete(() {
                      searchFilterController.resetAllFilters();
                    });
                  },
                  child: Text(
                    AppString.search,
                    style: AppStyle.heading5Medium(color: AppColor.whiteColor),
                  ),
                ).paddingOnly(
                  top: AppSize.appSize36,
                  bottom: AppSize.appSize36,
                  right: AppSize.appSize36),
        ],
      ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),
    );
  }
}
