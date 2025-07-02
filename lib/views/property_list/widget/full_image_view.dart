import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';

class FullImageView extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullImageView({super.key, required this.images, required this.initialIndex});

  @override
  _FullImageViewState createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "${currentIndex + 1} / ${widget.images.length}",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(), // Smooth scrolling
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Center(
            child: Image.network(
              widget.images[index],
              fit: BoxFit.contain,
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

                    fit: BoxFit.contain,
                  );
                }
            ),
          );
        },
      ),
    );
  }
}
