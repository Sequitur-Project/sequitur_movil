import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequitur_movil/components/bottom_button.dart';
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
  List dataResults = [];

  Future<String> getResults() async {
    var responseResults = await http.get(
        Uri.parse(url + "students/1/results"),
        headers: headers());    

    setState(() {
      var extractdataResults = json.decode(responseResults.body);
      dataResults = extractdataResults['content'];
      score = dataResults.last['score'] - dataResults[dataResults.length - 2]['score'];
      print(dataResults.last['score']);
    });

    return responseResults.body.toString();
  }

  @override
  void initState() {
    super.initState();
    getResults();
  }

  @override
  Widget build(BuildContext context) {
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
                    color: Color.fromARGB(255, 98, 184, 255),
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
                  top: AppDimensions.APPBAR_HEIGHT + 20, bottom: 0),
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
                                                "Depresion severa",
                                                style: TextStyle(
                                                    color: Color.fromARGB(255, 31, 0, 0),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600),
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
                  child: BottomButton(
                      isWhiteButton: false,
                      text: "RECOMENDACIONES",
                      tap: () {                        
                        setState(() {
                          
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
