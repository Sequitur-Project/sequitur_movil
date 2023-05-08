import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/components/bottom_button_dot.dart';
import 'package:sequitur_movil/views/recs_view.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:sequitur_movil/components/custom_button.dart';
import 'package:sequitur_movil/components/custom_text_field.dart';
import 'package:sequitur_movil/components/title_desc.dart';
import 'package:sequitur_movil/models/chat_message_model.dart';
import 'package:sequitur_movil/models/current_user_model.dart';
import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/resources/app_dimens.dart';
import 'package:sequitur_movil/endpoints/endpoints.dart';

import 'package:http/http.dart' as http;

class ResultsView extends StatefulWidget {
  @override
  _ResultsViewState createState() => _ResultsViewState();
}

// List<ChatMessage> messages = [
//   ChatMessage(message: "¡Hola!", sender: "bot"),
//   ChatMessage(message: "¿Como te encuentras el dia de hoy?", sender: "bot"),
//   ChatMessage(message: "bien", sender: "student"),
//   ChatMessage(message: "Mas mensajes", sender: "bot"),
// ];

class _ResultsViewState extends State<ResultsView> {
  String url = "https://back-sequitur-production.up.railway.app/api/";

  Map newMessage = new Map();
  final _myMessageController = TextEditingController();

  final _controller = ScrollController();
  int score = 0;
  String depresion = "";
  String description = "";
  List dataResults = [];

    List dataRecs = [];
  
  List<String> recs = [];

  Future<String> getResults() async {
    var responseResults = await http.get(
        Uri.parse(url + "students/1/results"),
        headers: headers());    

    setState(() {
      var extractdataResults = json.decode(responseResults.body);
      dataResults = extractdataResults['content'];
      score = dataResults.last['score'] - dataResults[dataResults.length - 2]['score'];
      print(dataResults.last);
    });

    return responseResults.body.toString();
  }


  Future<String> getRecs() async {
    var responseRecs = await http.get(
        Uri.parse(url + "students/1/recommendations"),
        headers: headers());

    setState(() {
      var extractdataBitacora = json.decode(utf8.decode(responseRecs.bodyBytes));

      dataRecs = extractdataBitacora['content'];
      print(dataRecs); 

      for (var info in dataRecs) {
        recs.add(info['text']);
      }

    });
    return responseRecs.body.toString();
  }

  @override
  void initState() {
    super.initState();
    getResults();
    getRecs();
  }

  @override
  Widget build(BuildContext context) {
    if (score == 0) {
      depresion = 'No Depresión';
      description = 'No es necesario tratamiento para la depresión.';
    } else if (score >= 1 && score <= 4) {
      depresion = 'Depresión Leve';
      description = 'Uno de nuestros psicologos se pondrá en contacto contigo para determinar el curso del tratamiento. .';
    } else if (score >= 5 && score <= 9) {
      depresion = 'Depresión Moderada';
      description = 'Uno de nuestros psicologos se pondrá en contacto contigo para determinar el curso del tratamiento.';
    } else if (score >= 10 && score <= 14) {
      depresion = 'Depresión Mínima';
      description = 'Es posible no necesitar tratamiento para la depresión.';
    } else if (score >= 15 && score <= 19) {
      depresion = 'Depresión Moderadamente Severa';
      description = 'Uno de nuestros psicologos se pondrá en contacto contigo para determinar el curso del tratamiento. Es posible se necesite medicamentos, terapia o una combinación de ambos.';
    } else if (score >= 20 && score <= 27) {
      depresion = 'Depresión Severa';
      description = 'Uno de nuestros psicologos se pondrá en contacto contigo para determinar el curso del tratamiento. Será necesario el tratamiento de la depresión con medicamentos, terapia o una combinación de ambos.';
    }

    final List<ChartData> chartData = [
      ChartData('David', 11, Color.fromRGBO(9, 0, 136, 1)),
      ChartData('David', 27, Color.fromRGBO(235, 235, 235, 1)),
    ];
    final currentUser = Provider.of<CurrentUserModel>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: AppDimensions.APPBAR_HEIGHT,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
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
                        "Resultados",
                        style: TextStyle(
                            color: AppColors.APPBAR_TEXT,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        "Mira tus resultados aqui",
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
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(
                  top: AppDimensions.APPBAR_HEIGHT + 40, bottom: 0),
            child: Column(
              
              children: [
                Expanded(
                    child: Container(
                       
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 0),
                        child: Center(
                          child: SfRadialGauge(axes: <RadialAxis>[
                                        RadialAxis(
                            startAngle: 180, endAngle: 0, showTicks: false, showLabels: false,
                            minimum: 0,
                            maximum: 27,
                            axisLineStyle: const AxisLineStyle(
                              thickness: 0.2,
                              thicknessUnit: GaugeSizeUnit.factor,
                              color: AppColors.BUTTON_TEXT_COLOR
                            ),
                            pointers: <GaugePointer>[                      
                            RangePointer(value: score.toDouble(), sizeUnit:GaugeSizeUnit.factor, width:0.2, enableAnimation: true, color: AppColors.PRIMARY_COLOR)
                                         ],
                            annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(angle: 90, positionFactor: 2,
                                      widget: Column(
                                        children: [
                                          Text(score.toString(), style:
                                          TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
                                          Text('Posible', style:
                                          TextStyle(fontSize: 15),),
                                          Text(
                                                depresion,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color.fromARGB(255, 31, 0, 0),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                          Text(
                                                description,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color.fromARGB(255, 31, 0, 0),
                                                    fontSize: 16,),
                                              ),    
                                        ],
                                      ),
                                      )]             
                            ),
                                      ]),
                        ),
                      ),
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomButtonDot(
                      isWhiteButton: false,
                      text: "RECOMENDACIONES",
                      circleText: recs.length.toString(),
                      tap: () {                        
                        setState(() {
                             Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RecsView()),
                          );
                        });                        
                      })),
              ],
            ),
          )),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
