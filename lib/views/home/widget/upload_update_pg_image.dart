import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../api_service/app_config.dart';
import '../../../api_service/print_logger.dart';
import '../../../common/common_button.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';
import '../../../configs/app_string.dart';
import '../../../configs/app_style.dart';
import '../../../controller/home_controller.dart';
import '../../../controller/pg_post_edit_property_controller.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/post_property_model.dart';
import '../../../routes/app_routes.dart';

class PostPgPropertyEditImage extends StatelessWidget {
  final PGPostEditPropertyController pgEditImagePropertyController =
      Get.find<PGPostEditPropertyController>();

  PostPgPropertyEditImage({super.key}) {
    final PostPropertyData? pgItem = Get.arguments;

    if (pgItem != null) {
      pgEditImagePropertyController.loadCityList().then((_) {
        pgEditImagePropertyController.setEditData(pgItem!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildUploadUpdateImages(context).paddingOnly(
        top: AppSize.appSize10,
        left: AppSize.appSize16,
        right: AppSize.appSize16,
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
        AppString.updateUploadImage,
        style: AppStyle.heading3Medium(color: AppColor.textColor),
      ),
    );
  }

  List<File> selectedImages = [];

  Widget buildUploadUpdateImages(BuildContext context) {
    // return GetBuilder<PGPostPropertyController>(
    //     builder: (pgPostPropertyImage){
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: AppColor.descriptionColor)),
            child: Column(
              children: [
                Text(
                  'Upload Images',
                  style: AppStyle.heading3SemiBold(color: AppColor.textColor),
                ).paddingOnly(
                    top: AppSize.appSize10,
                    right: AppSize.appSize10,
                    left: AppSize.appSize10),
                Divider(
                  thickness: 1,
                  color: AppColor.descriptionColor.withOpacity(0.5),
                ).paddingOnly(
                    left: AppSize.appSize10,
                    right: AppSize.appSize10,
                    bottom: AppSize.appSize10),
                Container(
                  width: double.infinity,
                  height: AppSize.appSize250,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: InkWell(
                    onTap: () async {
                      AppLogger.log("Upload clicked");
                      selectedImages = await pickMultipleImages();
                      (context as Element).markNeedsBuild();
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload, size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Click to upload.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).paddingOnly(
                    top: AppSize.appSize10,
                    bottom: AppSize.appSize10,
                    left: AppSize.appSize10,
                    right: AppSize.appSize10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Selected Images :",
                    style: AppStyle.heading3Medium(color: AppColor.black),
                  ),
                ).paddingAll(AppSize.appSize10),
                if (selectedImages.isNotEmpty)
                  Wrap(
                    spacing: 25,
                    runSpacing: 20,
                    children: List.generate(selectedImages.length, (index) {
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.black.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                selectedImages[index],
                                width: 150,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                selectedImages.removeAt(index);
                                (context as Element).markNeedsBuild();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ).paddingOnly(left: 10, right: 10, bottom: 10),
                Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: CommonButton(
                            onPressed: () async {
                              await pgEditImagePropertyController
                                  .submitEditStep4UploadImagesPgDetails(
                                      selectedImages);
                              if (pgEditImagePropertyController
                                  .isPgDetailSubmittedStep4) {
                                Get.find<HomeController>()
                                    .fetchPostPropertyList();
                                Get.find<HomeController>()
                                    .fetchPostProjectListing();
                                Get.offNamed(AppRoutes.bottomBarView);
                              }
                            },
                            backgroundColor: AppColor.primaryColor,
                            child: pgEditImagePropertyController
                                    .isUploadingStep4.value
                                ? const CupertinoActivityIndicator(
                                    radius: 10,
                                    color: AppColor.whiteColor,
                                  )
                                : Text(
                                    AppString.submitButton,
                                    style: AppStyle.heading5Medium(
                                        color: AppColor.whiteColor),
                                  ),
                          ).paddingOnly(
                            left: AppSize.appSize16,
                            right: AppSize.appSize16,
                            bottom: AppSize.appSize26,
                            top: AppSize.appSize10,
                          ),
                        ))
                    .paddingOnly(
                        left: AppSize.appSize10,
                        right: AppSize.appSize10,
                        top: AppSize.appSize10,
                        bottom: AppSize.appSize10),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: AppColor.descriptionColor)),
            child: Column(
              children: [
                Text(
                  'Already Uploaded Images',
                  style: AppStyle.heading3SemiBold(color: AppColor.textColor),
                ).paddingOnly(
                    top: AppSize.appSize10,
                    right: AppSize.appSize10,
                    left: AppSize.appSize10),
                Divider(
                  thickness: 1,
                  color: AppColor.descriptionColor.withOpacity(0.5),
                ).paddingOnly(
                    left: AppSize.appSize10,
                    right: AppSize.appSize10,
                    bottom: AppSize.appSize10),
                Obx(() {
                  final validImages = pgEditImagePropertyController
                      .alreadyUploadedImageUrls
                      .where((img) => img.image.isNotEmpty)
                      .toList();

                  // for (var img in validImages) {
                  //   AppLogger.log("Image ID: ${img.id}, Path: ${img.image} property Id : ${img.propertyId}");
                  // }

                  if (validImages.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "Oops! No images uploaded. Please add some images first.",
                        style:
                            AppStyle.heading2(color: AppColor.descriptionColor),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Wrap(
                        spacing: 25,
                        runSpacing: 20,
                        children: pgEditImagePropertyController
                            .alreadyUploadedImageUrls
                            .map((img) {
                          final fullImagePath =
                              "${AppConfigs.mediaUrl}${img.image}?path=properties";
                          // AppLogger.log("🖼️ Image Path: $fullImagePath");

                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.black.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                    )
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    fullImagePath,
                                    width: 150,
                                    height: 250,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                          color: AppColor.primaryColor,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/myImg/no_preview_available.png",
                                        width: 150,
                                        height: 250,
                                        fit: BoxFit.fill,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Obx(() => pgEditImagePropertyController
                                      .isSelecting.value
                                  ? Positioned(
                                      top: 1,
                                      right: 1,
                                      child: Transform.scale(
                                        scale: 1.5,
                                        child: Checkbox(
                                          value: pgEditImagePropertyController
                                              .selectedImageIds
                                              .contains(img.id),
                                          onChanged: (value) {
                                            if (value == true) {
                                              pgEditImagePropertyController
                                                  .selectedImageIds
                                                  .add(img.id);
                                            } else {
                                              pgEditImagePropertyController
                                                  .selectedImageIds
                                                  .remove(img.id);
                                            }
                                          },
                                          activeColor: AppColor.primaryColor,
                                          checkColor: AppColor.whiteColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink()),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  );
                }).paddingOnly(left: 10, right: 10, bottom: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(() => ElevatedButton(
                          onPressed: () {
                            pgEditImagePropertyController.isSelecting.value =
                                !pgEditImagePropertyController
                                    .isSelecting.value;
                            if (!pgEditImagePropertyController
                                .isSelecting.value) {
                              pgEditImagePropertyController.selectedImageIds
                                  .clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                pgEditImagePropertyController.isSelecting.value
                                    ? AppColor.red
                                    : AppColor.primaryColor,
                          ),
                          child: Text(
                            pgEditImagePropertyController.isSelecting.value
                                ? "Cancel Selection"
                                : "Select Images to Delete",
                            style: AppStyle.heading4SemiBold(
                                color: AppColor.whiteColor),
                          ),
                        )),
                    Obx(() => pgEditImagePropertyController.isSelecting.value
                        ? ElevatedButton(
                            onPressed: pgEditImagePropertyController
                                    .selectedImageIds.isNotEmpty
                                ? () async {
                                    AppLogger.log(
                                        "Deleting images with IDs: $pgEditImagePropertyController.selectedImageIds");
                                    await pgEditImagePropertyController
                                        .deleteSelectedImages();

                                    if (pgEditImagePropertyController
                                        .selectedImageIds.isEmpty) {
                                      Get.find<HomeController>()
                                          .fetchPostPropertyList();
                                      Get.find<HomeController>()
                                          .fetchPostProjectListing();
                                      Get.offNamed(AppRoutes.bottomBarView);
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryColor,
                            ),
                            child: Text(
                              "Delete Images",
                              style: AppStyle.heading4SemiBold(
                                  color: AppColor.whiteColor),
                            ),
                          )
                        : const SizedBox.shrink()),
                  ],
                ).paddingOnly(
                  top: AppSize.appSize20,
                  bottom: AppSize.appSize20,
                ),
              ],
            ),
          ).paddingOnly(top: AppSize.appSize40)
        ],
      ),
    );
  }

  Future<List<File>> pickMultipleImages() async {
    try {
      PermissionStatus permissionStatus = PermissionStatus.denied;

      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          permissionStatus = await Permission.storage.request();
        } else {
          permissionStatus = await Permission.photos.request();
        }
      } else {
        permissionStatus = await Permission.photos.request();
      }
      if (permissionStatus.isGranted) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: true,
        );

        if (result != null && result.files.isNotEmpty) {
          return result.paths
              .whereType<String>()
              .map((path) => File(path))
              .toList();
        } else {
          return [];
        }
      } else if (permissionStatus.isDenied) {
        Get.defaultDialog(
          title: "Permission Denied",
          middleText: "Permission denied. Please allow access in settings.",
          textConfirm: "OK",
          onConfirm: () => Get.back(),
        );
        return [];
      } else if (permissionStatus.isPermanentlyDenied) {
        Get.defaultDialog(
          title: "Permission Required",
          middleText:
              "Permission permanently denied. Please enable it from app settings.",
          textConfirm: "Open Settings",
          textCancel: "Cancel",
          onConfirm: () {
            openAppSettings();
            Get.back();
          },
        );
        return [];
      } else {
        return [];
      }
    } catch (e) {
      AppLogger.log('Error picking images: $e');
      return [];
    }
  }
}
