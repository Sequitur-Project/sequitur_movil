import 'package:flutter/material.dart';
import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/resources/app_dimens.dart';

class BottomButtonDot extends StatelessWidget {
  const BottomButtonDot(
      {Key? key,
      required this.tap,
      required this.text,
      required this.isWhiteButton,  
      required this.circleText,
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
  final String circleText;

  


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        width: double.infinity,
        height: AppDimensions.BOTTOM_BUTTON_DIMENSIONS_HEIGHT,
        padding: this.padding,
        margin: this.margin,
        decoration: BoxDecoration(
          color: isWhiteButton ? AppColors.BUTTON_COLOR_WHITE : AppColors.BUTTON_COLOR,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [            
            Text(
              text,
              style: TextStyle(
                  color:  isWhiteButton ? AppColors.BUTTON_TEXT_COLOR_WHITE : AppColors.BUTTON_TEXT_COLOR,
                  fontSize: 14,
                  fontWeight: fontWeight,
                  letterSpacing: 2),
            ),
            SizedBox( width: 20),
            Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: AppColors.WHITE,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      circleText,
                      style: TextStyle(
                        color: AppColors.TEXT_COLOR_GRAY,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}