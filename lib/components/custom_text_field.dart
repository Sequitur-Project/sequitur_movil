import 'package:flutter/material.dart';
import 'package:sequitur_movil/resources/app_colors.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
    {required this.controller,
     required this.labelText,
     required this.labelHint,
     required this.icon,
     this.isPassword = false,
    }
    );

  final TextEditingController controller;
  final String labelText;  
  final String labelHint;  
  final IconData icon;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  child: SizedBox(
  height: 73.0,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:[
      Container(
      margin: EdgeInsets.only(bottom: 10),
      child:  Text(
        labelText,
        style: const TextStyle(
          fontSize: 14,
              fontWeight: FontWeight.normal,
              letterSpacing: 2
        ),
        textAlign: TextAlign.left,
      )), 
  Expanded(
        child: TextField(
           obscureText: isPassword ? true : false,
      controller: controller,
      decoration: InputDecoration(        
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(10.0),
        hintText: labelHint,
        filled: true,
        fillColor: AppColors.TEXTFIELD_BACKGROUND,
        suffixIcon: Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppColors.BUTTON_COLOR,
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: EdgeInsets.all(10.0),
      child: Icon(
        icon,
        color: AppColors.BUTTON_TEXT_COLOR,
      ),
    ),
      ),
  ))])));  
  }
}