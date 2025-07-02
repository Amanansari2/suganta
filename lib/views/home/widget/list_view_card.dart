import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../common/wishlist_icon.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';

class ListPropertyCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String title;
  final String location;
  final String availability;
  final String floor;
  final String carpetArea;
  final String buildUpArea;
  final String plotArea;
  final String price;
  final VoidCallback onContact;
  final VoidCallback onGetPhone;
  final VoidCallback onTap;
  final int propertyId;

  const ListPropertyCard(
      {Key? key,
      required this.imageUrl,
      required this.name,
      required this.title,
      required this.location,
      required this.availability,
      required this.floor,
      required this.carpetArea,
      required this.buildUpArea,
      required this.plotArea,
      required this.price,
      required this.onContact,
      required this.onGetPhone,
      required this.onTap,
      required this.propertyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: AppColor.black.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 1)
              ]),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
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
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl,
                          height: 100,
                          width: 130,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              height: 100,
                              width: 130,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.primaryColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return SizedBox(
                              height: 100,
                              width: 130,
                              child: Image.asset(
                                "assets/myImg/no_preview_available.png",
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ).paddingOnly(left: AppSize.appSize5),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 25, // Height of the divider
                                child: VerticalDivider(
                                  thickness: 1,
                                  width: 15, // Space between items
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    price,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            location,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                ),

                const SizedBox(height: 5),

                _buildDynamicRow([
                  if (availability.trim().isNotEmpty)
                    _buildIconText(FontAwesomeIcons.mapMarkerAlt, availability),
                  if (availability.trim().isNotEmpty && floor.trim().isNotEmpty)
                    const SizedBox(
                      height: 25,
                      child: VerticalDivider(thickness: 1, width: 10),
                    ),
                  if (floor.trim().isNotEmpty)
                    _buildIconText(FontAwesomeIcons.building, floor),
                ]),

                const SizedBox(height: 5),

                /// Second Row (Carpet, BuildUp, Plot)
                _buildDynamicRow([
                  if (carpetArea.trim().isNotEmpty)
                    _buildIconText(FontAwesomeIcons.ruler, carpetArea),
                  if (carpetArea.trim().isNotEmpty &&
                      buildUpArea.trim().isNotEmpty)
                    const SizedBox(
                        height: 25, child: VerticalDivider(thickness: 1)),
                  if (buildUpArea.trim().isNotEmpty)
                    _buildIconText(FontAwesomeIcons.borderAll, buildUpArea),
                  if (buildUpArea.trim().isNotEmpty &&
                      plotArea.trim().isNotEmpty)
                    const SizedBox(
                        height: 25, child: VerticalDivider(thickness: 1)),
                  if (plotArea.trim().isNotEmpty)
                    _buildIconText(FontAwesomeIcons.tree, plotArea),
                ]),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 8,
        right: 8,
        child: WishlistIcon(
          propertyId: propertyId,
          emptyHeartColor: AppColor.black,
        ),
      ),
    ]);
  }

  Widget _buildIconText(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColor.primaryColor),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDynamicRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
