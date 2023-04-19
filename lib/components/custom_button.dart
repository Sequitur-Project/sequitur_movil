import 'package:flutter/material.dart';
import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/resources/app_dimens.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.tap,
      required this.text,
      required this.isWhiteButton,  
      this.fontWeight,
      this.padding,
      this.margin,          
     })
      : super(key: key);

  final GestureTapCallback tap;
  final String text;
  final bool isWhiteButton;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final FontWeight? fontWeight;
  


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        width: double.infinity,
        height: AppDimensions.BUTTON_DIMENSIONS_HEIGHT,
        padding: this.padding,
        margin: this.margin,
        decoration: BoxDecoration(
          color: isWhiteButton ? AppColors.BUTTON_COLOR_WHITE : AppColors.BUTTON_COLOR,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              color:  isWhiteButton ? AppColors.BUTTON_TEXT_COLOR_WHITE : AppColors.BUTTON_TEXT_COLOR,
              fontSize: 14,
              fontWeight: fontWeight,
              letterSpacing: 2),
        ),
      ),
    );
  }
}