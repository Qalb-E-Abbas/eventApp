import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  CustomText(
      {Key? key,
      required this.text,
      this.color,
      this.textAlign,
        this.height,
      this.fontSize = 12,
      this.fontWeight = FontWeight.w500,
      this.letterSpacing})
      : super(key: key);
  String text;
  double ?height;
  FontWeight fontWeight;
  double fontSize;
  Color ?color ;
  double? letterSpacing;
  TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      text,
      style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          height:height,
          color: color ?? const Color(0xff828282),
          letterSpacing: letterSpacing),
    );
  }
}
