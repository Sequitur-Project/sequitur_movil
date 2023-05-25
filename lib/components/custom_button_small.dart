import 'package:flutter/material.dart';
import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/resources/app_dimens.dart';

class CustomButtonSmall extends StatelessWidget {
  const CustomButtonSmall(
      {Key? key,
      required this.tap,
      required this.text,
      required this.isWhiteButton,  
      required this.hasNotification,  
      required this.height,
      this.notificationNumber,
      this.fontWeight,
      this.padding,
      this.margin,  
      this.image,        
     })
      : super(key: key);

  final GestureTapCallback tap;
  final String text;
  final double height;
  final bool isWhiteButton;
  final bool hasNotification;
  final int? notificationNumber;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final FontWeight? fontWeight;
  final DecorationImage? image;
  


  @override
  Widget build(BuildContext context) {
    bool _hasNotif = hasNotification;
    if (notificationNumber == 0|| notificationNumber == null) {
        _hasNotif = false;
    }

    return GestureDetector(
      onTap: tap,
      child: Container(
        height: this.height,
        //height: AppDimensions.SMALL_BUTTON_DIMENSIONS_HEIGHT,
        padding: this.padding,
        margin: this.margin,
        
        decoration: BoxDecoration(
          color: isWhiteButton ? AppColors.BUTTON_COLOR_WHITE : AppColors.BUTTON_COLOR,
          borderRadius: BorderRadius.circular(8.0),
          image: image,
        ),
        alignment: Alignment.center,
        child: _hasNotif ? 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                  color:  isWhiteButton ? AppColors.BUTTON_TEXT_COLOR_WHITE : AppColors.BUTTON_TEXT_COLOR,
                  fontSize: 13,
                  fontWeight: fontWeight,
                  letterSpacing: 2),
            ),
            SizedBox( width: 20),
            Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: AppColors.BUTTON_COLOR,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      notificationNumber.toString(),
                      style: TextStyle(
                        color: AppColors.BUTTON_TEXT_COLOR,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          ],
        )        
         : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                  color:  isWhiteButton ? AppColors.BUTTON_TEXT_COLOR_WHITE : AppColors.BUTTON_TEXT_COLOR,
                  fontSize: 13,
                  fontWeight: fontWeight,
                  letterSpacing: 2),
            )            
          ],
        ),
      ),
    );
  }
}