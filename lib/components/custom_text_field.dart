import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sequitur_movil/resources/app_colors.dart';

class CustomTextField extends StatefulWidget  {
  CustomTextField({
    required this.controller,
    required this.labelText,
    required this.labelHint,
    required this.icon,
    this.isPassword = false,
    this.tap,
    this.isReadOnly = false,
    this.hasError = false,
    required this.error,
    this.inputFormatters,
  });

  final GestureTapCallback? tap;
  final TextEditingController controller;
  final String labelText;
  final String labelHint;
  final IconData icon;
  final bool isPassword;
  final bool isReadOnly;
  final bool hasError;
  final String? error;
  final List<TextInputFormatter>? inputFormatters;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();

  }

  class _CustomTextFieldState extends State<CustomTextField> {
    String? _error;

      @override
  void initState() {
    super.initState();
    _error = widget.error;
  }   
    
  @override
  Widget build(BuildContext context) {
    _error = widget.error;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: SizedBox(
            height: (_error == null) ? 72.0 : 94.0,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    widget.labelText,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 2),
                    textAlign: TextAlign.left,
                  )),
              Expanded(
                  child: TextField(                   
                onTap: widget.tap,
                readOnly: widget.isReadOnly,
                obscureText: widget.isPassword ? true : false,
                controller: widget.controller, 
                inputFormatters: widget.inputFormatters,               
                decoration: InputDecoration(
                  
                  errorText: _error,
                  errorStyle: TextStyle(letterSpacing: 1),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(top: 5, bottom: 0),
                       prefix: const Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 15, bottom: 10)),
                  hintText: widget.labelHint,
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
                      widget.icon,
                      color: AppColors.BUTTON_TEXT_COLOR,
                    ),
                  ),
                ),
              )), 
            ])));
  }
}
