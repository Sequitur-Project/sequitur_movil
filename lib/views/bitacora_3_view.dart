import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/components/custom_paragraph_field.dart';
import 'package:sequitur_movil/views/bitacora_4_view.dart';

import 'package:sequitur_movil/models/current_user_model.dart';
import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/resources/app_dimens.dart';

import 'package:intl/intl.dart';

class Bitacora3View extends StatefulWidget {
  final String emoji;
  final String feeling;
  final String binnacleId;

  Bitacora3View(this.emoji, this.feeling, this.binnacleId);

  @override
  _Bitacora3ViewState createState() => _Bitacora3ViewState();
}

class _Bitacora3ViewState extends State<Bitacora3View> {
  final _reasonController = TextEditingController();
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUserModel>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: AppDimensions.APPBAR_HEIGHT,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: SafeArea(
          child: Center(
            child: Container(
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.APPBAR_TEXT,
                    ),
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
                        Text(
                          "Bitácora",
                          style: TextStyle(
                            color: AppColors.APPBAR_TEXT,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "Realiza tu seguimiento",
                          style: TextStyle(
                            color: AppColors.APPBAR_TEXT,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
          margin:
              EdgeInsets.only(top: AppDimensions.APPBAR_HEIGHT + 20, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                child: Text(
                  "HOY • " +
                      capitalize(
                          "${DateFormat.EEEE('es_ES').format(DateTime.now())}") +
                      " ${DateFormat('d • M • y').format(DateTime.now())}",
                  style: TextStyle(color: AppColors.APPBAR_TEXT, fontSize: 15),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  color: Colors.white,
                  child: ListView(
                    padding: EdgeInsets.all(16.0),
                    children: [
                      CustomParagraphField(
                        icon: Icons.question_mark,
                        controller: _reasonController,
                        labelText: '¿Por qué te sientes así?',
                        labelHint: 'Ej. problemas familiares',
                      ),
                      if (_showError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Por favor, escribe por qué te sientes así.',
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 14),
                          ),
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
                    if (_reasonController.text.trim().isEmpty) {
                      setState(() {
                        _showError = true;
                      });
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Bitacora4View(
                            widget.emoji,
                            widget.feeling,
                            _reasonController.text.trim(),
                            widget.binnacleId),
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

  String capitalize(String s) {
    return s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;
  }
}
