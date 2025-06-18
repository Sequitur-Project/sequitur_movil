import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/views/bitacora_3_view.dart';

import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/resources/app_dimens.dart';

import 'package:intl/intl.dart';

class Bitacora2View extends StatefulWidget {
  final String emoji;
  final String binnacleId;
  final String userId;

  Bitacora2View(this.emoji, this.binnacleId, this.userId);

  @override
  _Bitacora2ViewState createState() => _Bitacora2ViewState();
}

class _Bitacora2ViewState extends State<Bitacora2View> {
  int _selectedValue = -1;
  String feeling = '';
  List<String> emociones = [];
  bool _showError = false;

  final Map<String, List<String>> emocionesPorEmoji = {
    "miedo": [
      "culpable",
      "arrepentido",
      "avergonzado",
      "ignorado",
      "victimizado",
      "desesperación",
      "impotente",
      "vulnerable",
      "deprimido",
      "inferior",
      "vacío",
      "abandonado",
      "aislado",
      "solitario",
      "apático",
      "indiferente",
      "aburrido"
    ],
    "enojo": [
      "herido",
      "avergonzado",
      "devastado",
      "amenazado",
      "inseguro",
      "celoso",
      "odioso",
      "resentido",
      "violado",
      "enojado",
      "furioso",
      "enfurecido",
      "agresivo",
      "provocado",
      "hostil",
      "frustrado",
      "irritado",
      "distante",
      "retirado",
      "sospechoso",
      "crítico",
      "escéptico",
      "sarcástico"
    ],
    "aversion": [
      "desaprobación",
      "crítico",
      "aversión",
      "decepcionado",
      "repugnante",
      "rebelde",
      "horrible",
      "repugnancia",
      "detestable",
      "evitación",
      "vacilante"
    ],
    "tristeza": [
      "humillado",
      "ridiculizado",
      "desaprovechado",
      "rechazado",
      "alienado",
      "inadecuado",
      "sumiso",
      "insignificante",
      "sin valor",
      "ansioso",
      "preocupado",
      "abrumado",
      "asustado",
      "aterrorizado"
    ],
    "felicidad": [
      "alegre",
      "liberado",
      "estático",
      "interesado",
      "divertido",
      "inquisitivo",
      "orgulloso",
      "importante",
      "seguro",
      "aceptado",
      "respetado",
      "satisfecho",
      "poderoso",
      "provoactivo",
      "valiente",
      "pacífico",
      "esperanzado",
      "cariñoso",
      "íntimo",
      "juguetón",
      "sensible",
      "optimista",
      "inspirado",
      "abierto"
    ],
    "sorpresa": [
      "sorprendido",
      "conmocionado",
      "consternado",
      "confundido",
      "desilusionado",
      "perplejo",
      "asombrado",
      "temeroso",
      "entusiasmado",
      "ansioso",
      "energético"
    ]
  };

  @override
  void initState() {
    super.initState();
    emociones = emocionesPorEmoji[widget.emoji] ?? [];
  }

  List<Widget> _buildRadioButtons() {
    return List<Widget>.generate(emociones.length, (i) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4.0),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              _selectedValue == i
                  ? AppColors.BUTTON_COLOR
                  : AppColors.BUTTON_TEXT_COLOR,
            ),
          ),
          onPressed: () {
            setState(() {
              _selectedValue = i;
              feeling = emociones[i];
              _showError = false;
            });
          },
          child: Container(
            width: double.infinity,
            child: Center(
              child: Text(
                emociones[i],
                style: TextStyle(
                  fontSize: 16.0,
                  color: _selectedValue == i
                      ? AppColors.BUTTON_TEXT_COLOR
                      : AppColors.TEXT_COLOR_GRAY,
                ),
              ),
            ),
          ),
        ),
      );
    });
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
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.APPBAR_TEXT),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(width: 2),
              Container(
                width: 50,
                height: 50,
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
                  children: [
                    Text("Bitácora",
                        style: TextStyle(
                            color: AppColors.APPBAR_TEXT,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                    Text("Realiza tu seguimiento",
                        style: TextStyle(
                            color: AppColors.APPBAR_TEXT, fontSize: 15)),
                  ],
                ),
              )
            ],
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
                  color: Colors.white,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Escoge una emoción.',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: AppColors.BUTTON_TEXT_COLOR_WHITE),
                            ),
                            if (_showError)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'Por favor, selecciona una emoción.',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 3.5,
                          children: _buildRadioButtons(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BottomButton(
                isWhiteButton: false,
                text: "SIGUIENTE",
                tap: () {
                  if (_selectedValue == -1) {
                    setState(() {
                      _showError = true;
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Bitacora3View(widget.emoji,
                            feeling, widget.binnacleId, widget.userId),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

String capitalize(String s) {
  if (s == null || s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}
