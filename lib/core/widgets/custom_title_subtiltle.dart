import 'package:flutter/material.dart';

class CustomTitleSubtitle extends StatelessWidget {
  const CustomTitleSubtitle({
    super.key,
    this.title,
    this.subTitle,
    this.titleColor,
    this.subTitleColor,
    this.titleFontSize = 16,
    this.subTitleFontSize = 14,
  });

  final String? title;
  final String? subTitle;
  final Color? titleColor;
  final Color? subTitleColor;
  final double? titleFontSize;
  final double? subTitleFontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: TextStyle(
              color: titleColor,
              fontSize: titleFontSize,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.left,
            maxLines: 2,
          ),
          Text(
            subTitle!,
            style: TextStyle(
              color: subTitleColor,
              fontSize: subTitleFontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
