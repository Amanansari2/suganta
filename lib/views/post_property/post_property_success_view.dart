import 'package:flutter/cupertino.dart';

import '../../configs/app_size.dart';
import '../../gen/assets.gen.dart';

postPropertySuccessDialogue() {
  return buildPostPropertySuccessLoader();
}

Widget buildPostPropertySuccessLoader() {
  return Center(
  child: Image.asset(
    Assets.images.loader.path,
    width: AppSize.appSize150,
  ),
);
}