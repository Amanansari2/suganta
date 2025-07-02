import 'package:flutter/material.dart';

import '../configs/app_color.dart';
import '../configs/app_style.dart';
import 'common_button.dart';

class CustomDialog extends StatelessWidget {
  final String? title, description, buttonText, image;
  final Color? titleColor;
  final VoidCallback? onConfirm;

  const CustomDialog({
    super.key,
    this.title,
    required this.description,
    required this.buttonText,
    this.image,
    this.titleColor,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 5,
      backgroundColor: AppColor.transparent,
      child: _contentBox(context),
    );
  }

  Widget _contentBox(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avtarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: const EdgeInsets.only(top: Constants.avtarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: const [
                BoxShadow(
                    color: AppColor.black,
                    offset: Offset(0, 4),
                    blurRadius: 10,
                    spreadRadius: 4)
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              title != null
                  ? Text(
                      title!,
                      style: AppStyle.heading8Bold(color: AppColor.black),
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 10,
              ),
              Text(
                description!,
                style: AppStyle.bodyTextStyle1(color: AppColor.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CommonButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onConfirm != null) onConfirm!();
                  },
                  child: Text(
                    "Ok",
                    style:
                        AppStyle.buttonTextStyle1(color: AppColor.whiteColor),
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
            top: 0,
            child: CircleAvatar(
              backgroundColor: AppColor.whiteColor,
              radius: Constants.avtarRadius,
              child: image != null
                  ? ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Constants.avtarRadius),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          image!,
                          height: 50,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.info,
                      size: 50,
                      color: Colors.blueAccent,
                    ),
            ))
      ],
    );
  }
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avtarRadius = 45;
}
