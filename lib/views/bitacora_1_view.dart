import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/views/bitacora_2_view.dart';

import 'package:sequitur_movil/models/current_user_model.dart';
import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/resources/app_dimens.dart';

import 'package:intl/intl.dart';

class Bitacora1View extends StatefulWidget {
  final String binnacleId;
  final String userId;
  Bitacora1View({required this.binnacleId, required this.userId});

  @override
  _Bitacora1ViewState createState() => _Bitacora1ViewState();
}

class _Bitacora1ViewState extends State<Bitacora1View> {
  String url = "https://sequitur-backend-2025-production.up.railway.app/api/";

  int _selectedValue = -1;
  String emoji = '';
  bool _showValidationMessage = false;

  final List<Map<String, dynamic>> _buttonData = [
    {'text': 'Miedo', 'image': 'assets/images/miedo.png'},
    {'text': 'Enojo', 'image': 'assets/images/enojo.png'},
    {'text': 'Aversion', 'image': 'assets/images/aversion.png'},
    {'text': 'Tristeza', 'image': 'assets/images/tristeza.png'},
    {'text': 'Felicidad', 'image': 'assets/images/felicidad.png'},
    {'text': 'Sorpresa', 'image': 'assets/images/sorpresa.png'},
  ];

  List<Widget> _buildRadioButtons() {
    List<Widget> list = [];
    for (int i = 0; i < _buttonData.length; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _buttonData[i]['image'],
                  width: 48,
                  height: 48,
                ),
              ],
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                _selectedValue == i
                    ? AppColors.BUTTON_COLOR
                    : AppColors.BUTTON_TEXT_COLOR,
              ),
              foregroundColor: MaterialStateProperty.all<Color>(
                _selectedValue == i
                    ? AppColors.BUTTON_TEXT_COLOR
                    : AppColors.TEXT_COLOR_GRAY,
              ),
            ),
            onPressed: () {
              setState(() {
                _selectedValue = i;
                emoji = _buttonData[i]['text'];
                _showValidationMessage = false;
              });
            },
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: AppDimensions.APPBAR_HEIGHT,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: SafeArea(
          child: Center(
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: AppColors.APPBAR_TEXT),
                ),
                SizedBox(width: 2),
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/icon.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Bitácora",
                          style: TextStyle(
                              color: AppColors.APPBAR_TEXT,
                              fontSize: 20,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 1),
                      Text("Realiza tu seguimiento",
                          style: TextStyle(
                              color: AppColors.APPBAR_TEXT, fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: AppDimensions.APPBAR_HEIGHT + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                child: Text(
                  "HOY • ${capitalize(DateFormat.EEEE('es_ES').format(DateTime.now()))} ${DateFormat('d • M • y').format(DateTime.now())}",
                  style: TextStyle(color: AppColors.APPBAR_TEXT, fontSize: 15),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.topCenter,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Escoge el emoji que represente mejor como te sientes actualmente. Recuerda puedes agregar más cuando lo necesites.',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: AppColors.BUTTON_TEXT_COLOR_WHITE,
                              ),
                            ),
                            if (_showValidationMessage)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '⚠️ Por favor selecciona un emoji antes de continuar.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(16.0),
                        children: _buildRadioButtons(),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomButton(
                  isWhiteButton: false,
                  text: "SIGUIENTE",
                  tap: () {
                    if (emoji.isEmpty) {
                      setState(() {
                        _showValidationMessage = true;
                      });
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Bitacora2View(emoji.toLowerCase(),
                            widget.binnacleId, widget.userId),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}
