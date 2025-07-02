import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/wishlist_icon.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';

class PropertyCard extends StatelessWidget {
  final String imageUrl;
  final String type;
  final String city;
  final String amount;
  final bool isPriceNegotiable;
  final bool includesElectricCharges;
  final String ownerName;
  final VoidCallback onViewDetails;
  final int propertyId;
  final bool showRibbon;
  final String ribbonText;

  const PropertyCard({
    Key? key,
    required this.imageUrl,
    required this.type,
    required this.city,
    required this.amount,
    required this.isPriceNegotiable,
    required this.includesElectricCharges,
    required this.ownerName,
    required this.onViewDetails,
    required this.propertyId,
    this.showRibbon = false,
    this.ribbonText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: AppColor.black.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 1)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: AppColor.black.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 1)
                  ]),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10), bottom: Radius.circular(10)),
                child: Image.network(imageUrl,
                    height: 150, width: double.infinity, fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                      color: AppColor.primaryColor,
                    ),
                  );
                }, errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/myImg/no_preview_available.png",
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  );
                }),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                    color: AppColor.black.withOpacity(0.3),
                    shape: BoxShape.circle),
                width: 35,
                height: 35,
                child: WishlistIcon(propertyId: propertyId),
              ),
            ),
            if (showRibbon)
              Positioned(
                  top: 20,
                  left: -60,
                  child: Transform.rotate(
                    angle: -0.872665,
                    child: Container(
                      width: 250,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF6547), // Start Color
                              Color(0xFFFFB144), // Middle Color
                              Color(0xFFFF7053),
                            ],
                            stops: [0.0, 0.51, 1.0], // Same stops as CSS
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: AppColor.black.withOpacity(0.4),
                                blurRadius: 2,
                                spreadRadius: 1,
                                offset: Offset(2, 2))
                          ]),
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        ribbonText,
                        style: AppStyle.heading5SemiBold(
                            color: AppColor.whiteColor),
                      ).paddingOnly(left: 40),
                    ),
                  ))
          ]),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    type,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "City : ",
                      style: AppStyle.heading5Medium(color: AppColor.black),
                    ),
                    Flexible(
                      child: Text(
                        city,
                        style: AppStyle.heading5Medium(color: AppColor.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Amount : ",
                      style: AppStyle.heading5Medium(color: AppColor.black),
                    ),
                    Text(
                      amount,
                      style: AppStyle.heading5Medium(color: AppColor.black),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price Negotiable : ",
                      style: AppStyle.heading5Medium(color: AppColor.black),
                    ),
                    Text(
                      isPriceNegotiable ? 'Yes' : 'No',
                      style: AppStyle.heading5Medium(color: AppColor.black),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Electric charges Include : ",
                      style: AppStyle.heading5Medium(color: AppColor.black),
                    ),
                    Text(
                      includesElectricCharges ? 'Yes' : 'No',
                      style: AppStyle.heading5Medium(color: AppColor.black),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Owner Name : ",
                      style: AppStyle.heading5Medium(color: AppColor.black),
                    ),
                    Flexible(
                      child: Text(
                        ownerName,
                        style: AppStyle.heading5Medium(color: AppColor.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                // Text("City: $city"),
                // Text("Amount: $amount"),
                // Text("Price Negotiable: ${isPriceNegotiable ? 'Yes' : 'No'}"),
                // Text(
                // "Electric Charges Included: ${includesElectricCharges ? 'Yes' : 'No'}"),
                // Text("Owner: $ownerName"),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: onViewDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "View Details",
                      style:
                          AppStyle.heading4Medium(color: AppColor.whiteColor),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
