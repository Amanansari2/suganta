import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';
import '../../../configs/app_string.dart';
import '../../../configs/app_style.dart';
import '../../../controller/term_condition_controller.dart';
import '../../../gen/assets.gen.dart';

class TermsOfUseView extends StatefulWidget {
  const TermsOfUseView({super.key});

  @override
  State<TermsOfUseView> createState() => _TermsOfUseViewState();
}

class _TermsOfUseViewState extends State<TermsOfUseView> {
  final TermConditionController termConditionController =
      Get.find<TermConditionController>();

  @override
  void initState() {
    super.initState();
    if (!termConditionController.hasFetched.value) {
      termConditionController.termCondition().then((_) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildTermsOfUse(),
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
        AppString.termsOfUse,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildTermsOfUse() {
    if (termConditionController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSize.appSize16),
      child: HtmlWidget(
        termConditionController.termsText.value,
      ),
    );
  }
}
