import 'package:flutter/material.dart';
import 'package:sequitur_movil/resources/app_colors.dart';

class TitleDesc extends StatelessWidget {
  TitleDesc({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
        margin: EdgeInsets.only(left: 20, right:20, bottom:10, top:50),       
            child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.BUTTON_COLOR,
                        letterSpacing: 2),
                    textAlign: TextAlign.left,
                  )),
               Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    description,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1),
                    textAlign: TextAlign.left,
                  )),             
            ]
            )
            );
  }
}
