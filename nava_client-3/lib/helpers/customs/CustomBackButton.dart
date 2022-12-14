import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/MyColors.dart';

class CustomBackButton extends StatelessWidget {
  CustomBackButton(
      { @required this.ctx, this.isFromAuth = false});

  BuildContext ctx;
  bool isFromAuth;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(ctx).pop();
      },
      icon: Icon(
        isFromAuth
            ? EasyLocalization.of(context).currentLocale.toString() == "ar_EG"
                ? Icons.arrow_circle_right_outlined 
                : Icons.arrow_circle_left_outlined
            : EasyLocalization.of(context).currentLocale.toString() == "ar_EG"
                ? Icons.arrow_circle_right 
                : Icons.arrow_circle_left,
        size: 30,
        color: isFromAuth ? MyColors.secondary : MyColors.primary,
      ),
    );
  }
}
