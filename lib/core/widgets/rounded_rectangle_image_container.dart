import 'package:ev_app/core/utils/size_config.dart';
import 'package:flutter/material.dart';

class RoundedRectangleImageContainer extends StatelessWidget {
  const RoundedRectangleImageContainer({
    super.key,
    this.image,
    this.height,
    this.width,
  });
  final String? image;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height:
            height != null
                ? (SizeConfig.defaultSize! * height!)
                : (SizeConfig.defaultSize! * 11),
        width:
            width != null
                ? (SizeConfig.defaultSize! * width!)
                : (SizeConfig.defaultSize! * 20),
        constraints: BoxConstraints(),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.primary),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            image!,
            fit: BoxFit.cover,
            width:
                width != null
                    ? (SizeConfig.defaultSize! * width!)
                    : (SizeConfig.defaultSize! * 20),
            height:
                height != null
                    ? (SizeConfig.defaultSize! * height!)
                    : (SizeConfig.defaultSize! * 11),
          ),
        ),
      ),
    );
  }
}
