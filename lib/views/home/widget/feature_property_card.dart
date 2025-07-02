import 'package:flutter/material.dart';

import '../../../api_service/app_config.dart';
import '../../../common/wishlist_icon.dart';
import '../../../configs/app_color.dart';

class FeaturePropertyCard extends StatelessWidget {
  final String imageUrl;
  final String wantTo;
  final String type;
  final String ownership;
  final String? parking;
  final String price;
  final VoidCallback  onViewDetails;
  final int propertyId;
  final String? suitableFor;


  const FeaturePropertyCard({
    Key? key,
    required this.imageUrl,
    required this.wantTo,
    required this.type,
    required this.ownership,
     this.parking,
    required this.price,
    required this.onViewDetails,
    required this.propertyId,
    this.suitableFor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   // bool isNetworkImage = imageUrl.startsWith("http") || imageUrl.startsWith("https");
    String fullImageUrl = imageUrl.startsWith("http") ? imageUrl : "${AppConfigs.mediaUrl}$imageUrl";
    return Container(
      width: 250, // Set card width
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow:  const [
          BoxShadow(
            color: AppColor.whiteColor,
            blurRadius: 1,
            spreadRadius: 3
        )],
      ),
      child: Stack(
        children:[
          GestureDetector(
          onTap: onViewDetails,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                const Center(
                  child: CircularProgressIndicator(color: AppColor.primaryColor,),
                ),
                // Property Image


                  Image.network(
                  fullImageUrl,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
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
                    },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/myImg/no_preview_available.png",
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    );
                  },
                ),




                // Overlay Gradient
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ),


                // Property Details
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Want To: $wantTo",
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      if(type!= null && type.isNotEmpty)
                      Text(
                        "Type: $type",
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),

                      if(ownership!= null && ownership.isNotEmpty)
                      Text(
                        "Ownership: $ownership",
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      if(suitableFor!= null && suitableFor!.isNotEmpty)
                      Text(
                        "Suitable For: $suitableFor",
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),

                      // const SizedBox(height: 6),
                      Text(
                        "Price: $price",
                        style: const TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
          Positioned(
            top: 10,
            right: 10,
            child:  Container(
                decoration: BoxDecoration(
                    color: AppColor.black.withOpacity(0.3),
                    shape: BoxShape.circle
                ),
                width: 35,
                height: 35,
              child:
              WishlistIcon(propertyId: propertyId),
               ),
          ),
      ]
      ),
    );
  }
}
