import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/app_color.dart';
import '../controller/wishlist_controller.dart';

class ProjectWishlistIcon extends StatelessWidget {
  final int projectId;
  final Color? emptyProjectHeartColor;

  const ProjectWishlistIcon(
      {super.key, required this.projectId, this.emptyProjectHeartColor});

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController =
        Get.find<WishlistController>();

    return Obx(() {
      final isProjectWishlisted =
          wishlistController.isProjectWishListed(projectId);
      final isLoading = wishlistController.isProjectLoading(projectId);
      final isAuth = wishlistController.isAuthenticated.value;

      return IconButton(
          padding: EdgeInsets.zero,
          iconSize: 28,
          onPressed: isLoading
              ? null
              : () {
                  if (!isAuth) {
                    Get.snackbar(
                      "Login Required",
                      "Please login first to wishlist any project",
                    );
                    return;
                  }

                  wishlistController.projectToggleWishList(projectId);
                },
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  isProjectWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isProjectWishlisted
                      ? AppColor.red
                      : emptyProjectHeartColor ?? AppColor.whiteColor,
                ));
    });
  }
}
