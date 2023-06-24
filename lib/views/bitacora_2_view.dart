import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/views/bitacora_3_view.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:sequitur_movil/components/custom_button.dart';
import 'package:sequitur_movil/components/custom_text_field.dart';
import 'package:sequitur_movil/components/title_desc.dart';
import 'package:sequitur_movil/models/chat_message_model.dart';
import 'package:sequitur_movil/models/current_user_model.dart';
import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/resources/app_dimens.dart';
import 'package:sequitur_movil/endpoints/endpoints.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

class Bitacora2View extends StatefulWidget {

  final String emoji;
  Bitacora2View(this.emoji);

  @override
  _Bitacora2ViewState createState() => _Bitacora2ViewState(emoji);
}

class _Bitacora2ViewState extends State<Bitacora2View> {
  final String emoji;
  _Bitacora2ViewState(this.emoji);

  String url = "https://back-sequitur-production.up.railway.app/api/";

  Map newMessage = new Map();
  final _myMessageController = TextEditingController();

  final _controller = ScrollController();
  int score = 0;
  List dataResults = [];
  int _selectedValue = 0; // Initially no radio button is selected
  String feeling = '';

List<String> emociones = [];

final List<String> miedo = [
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
];

final List<String> enojo = [
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
    "enfurecido",
    "irritado",
    "distante",
    "retirado",
    "sospechoso",
    "crítico",
    "escéptico",
    "sarcástico"    
];

final List<String> aversion = [
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
    "aversión",
    "vacilante"   
];

final List<String> tristeza = [
    "humillado",
    "ridiculizado",
    "desaprovechado",
    "rechazado",
    "alienado",
    "inadecuado",
    "sumiso",
    "insignificante",
    "sin valor",
    "inseguro",
    "inferior",
    "inadecuado",
    "ansioso",
    "preocupado",
    "abrumado",
    "asustado",
    "aterrorizado"

];

final List<String> felicidad = [
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
];

final List<String> sorpresa = [
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
];

List<Widget> _buildRadioButtons() {
  List<Widget> list = [];
  for (int i = 0; i < emociones.length; i++) {
    list.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal:4, vertical: 4.0),
        child: TextButton(
          child: Container(
            width:double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [             
                Text(
                  emociones[i],
                  style: TextStyle(
                    fontSize: 16.0,
                    color: _selectedValue == i ?  AppColors.BUTTON_TEXT_COLOR : AppColors.TEXT_COLOR_GRAY,
                  ),
                ),
              ],
            ),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              _selectedValue == i ? AppColors.BUTTON_COLOR : AppColors.BUTTON_TEXT_COLOR,
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              _selectedValue == i ? AppColors.BUTTON_TEXT_COLOR : AppColors.TEXT_COLOR_GRAY,
            ),
          ),
          onPressed: () {
            setState(() {
              _selectedValue = i;
            });
            feeling = emociones[_selectedValue];
            print('Selected value is: ${emociones[_selectedValue]}');
          },
        ),
      ),
    );
  }
  return list;
}


  @override
  void initState() {
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {


    if (emoji == "miedo") {
        emociones = miedo;
    } else if (emoji == "enojo") {
        emociones = enojo;
    } else if (emoji == "aversion") {
        emociones = aversion;
    } else if (emoji == "tristeza") {
        emociones = tristeza;
    } else if (emoji == "felicidad") {
        emociones = felicidad;
    } else if (emoji == "sorpresa") {
        emociones = sorpresa;
    };

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
                  SizedBox(
                    width: 2,
                  ),
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
                  SizedBox(
                    width: 12,
                  ),
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
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          "Realiza tu seguimiento",
                          style: TextStyle(
                              color: AppColors.APPBAR_TEXT, fontSize: 15),
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
            margin: EdgeInsets.only(
                top: AppDimensions.APPBAR_HEIGHT + 20, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,              
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20, vertical:8.0),
                  child: Text(
                              "HOY • " + capitalize("${DateFormat.EEEE('es_ES').format(DateTime.now())}") + " ${DateFormat('d • M • y').format(DateTime.now())}",
                          style: TextStyle(
                              color: AppColors.APPBAR_TEXT, fontSize: 15),
                        ),
                ),
                Expanded(
                    child: Container(
                       alignment: Alignment.topCenter,
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:25.0, vertical: 0),
                              child: Text(
                              'Escoge una emoción.',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: AppColors.BUTTON_TEXT_COLOR_WHITE
                              ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(18),
                              child: GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                childAspectRatio: 3.5,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 0,
                                children: _buildRadioButtons(),
                              ),
                            ),
                          ],
                        ),
                  ),
                
                )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: BottomButton(
                        isWhiteButton: false,
                        text: "SIGUIENTE",
                        tap: () {
                          Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Bitacora3View(emoji,feeling)),
                          );                          
                        })),
              ],
            ),
         
         
          )),
          

    );
  }
}


String capitalize(String s) {
  if (s == null || s.isEmpty) {
    return s;
  }
  return s[0].toUpperCase() + s.substring(1);
}