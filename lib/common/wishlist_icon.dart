import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../configs/app_color.dart';
import '../controller/wishlist_controller.dart';

class WishlistIcon extends StatelessWidget {
  final int propertyId;
  final Color? emptyHeartColor;

  const WishlistIcon({super.key, required this.propertyId, this.emptyHeartColor});



  @override
  Widget build(BuildContext context) {
    final WishlistController controller = Get.find<WishlistController>();

    return Obx(() {
      final isWishlisted = controller.isWishlisted(propertyId);
      final isLoading = controller.isLoading(propertyId);
      final isAuth = controller.isAuthenticated.value;

      return IconButton(
      padding: EdgeInsets.zero,
      iconSize: 28,
      onPressed: isLoading
          ? null
          : () {
        if (!isAuth) {
          Get.snackbar(
         "Login Required",
           "Please login first to wishlist any property",
          );
          return;
        }

        controller.toggleWishlist(propertyId);
      },
      icon: isLoading
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          : Icon(
        isWishlisted ? Icons.favorite : Icons.favorite_border,
        color: isWishlisted ? AppColor.red : emptyHeartColor ?? AppColor.whiteColor,
      ),
              );
    });
  }
}
