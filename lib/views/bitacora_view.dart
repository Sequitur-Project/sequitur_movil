import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/models/bitacora_entry_model.dart';
import 'package:sequitur_movil/views/bitacora_1_view.dart';
import 'package:sequitur_movil/views/home_view.dart';
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
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:http/http.dart' as http;

class BitacoraView extends StatefulWidget {
  final String userId;
  BitacoraView(this.userId);

  @override
  _BitacoraViewState createState() => _BitacoraViewState();
}

class _BitacoraViewState extends State<BitacoraView> {
  String url = "https://back-sequitur-production.up.railway.app/api/";

  Map newMessage = new Map();
  final _myMessageController = TextEditingController();

  final _controller = ScrollController();
  int score = 0;
  List dataEmojis = [];

  DateTime startDate = DateTime(2023, 5, 1);
  DateTime endDate = DateTime(2023, 5, 7);
  DateTime currentDate = DateTime.now();
  bool _hasEntryToday = false;

  final List<Map<String, dynamic>> _emojiData = [
    {'text': 'Miedo', 'image': 'assets/images/miedo.png'},
    {'text': 'Enojo', 'image': 'assets/images/enojo.png'},
    {'text': 'Aversión', 'image': 'assets/images/aversion.png'},
    {'text': 'Tristeza', 'image': 'assets/images/tristeza.png'},
    {'text': 'Felicidad', 'image': 'assets/images/felicidad.png'},
    {'text': 'Sorpresa', 'image': 'assets/images/sorpresa.png'},
  ];

  List<BitacoraEntry> entries = [];
  bool _isLoading = true;

  Future<String> getResults() async {
    _isLoading = true;

    var responseResults = await http.get(
        Uri.parse(url + "binnacles/"+ widget.userId+"/binnacleEntries"),
        headers: headers());

    setState(() {
      var extractdataBitacora = json.decode(responseResults.body);
      dataEmojis = extractdataBitacora['content'];
      print(dataEmojis);

      for (var info in dataEmojis) {
        entries.add(BitacoraEntry(
            createdAt: DateTime.parse(info['createdAt']),
            emoji: info['emoji'],
            feeling: info['feeling'],
            reason: info['reason']));
        if ( DateFormat('d/M/y').format(DateTime.parse(info['createdAt'])) == DateFormat('d/M/y').format(DateTime.now())) {
            _hasEntryToday = true;
        }     
      }

      if (entries.isNotEmpty) {
          entries.sort((b, a) => b.createdAt.compareTo(a.createdAt));  
          startDate = entries.first.createdAt;
          endDate = currentDate.add(Duration(days: 2));  
      } else {
        startDate = currentDate.add(Duration(days: -2));  
        endDate = currentDate.add(Duration(days: 1));  
      }

      

    });

    _isLoading = false;
    return responseResults.body.toString();
  }

  @override
  void initState() {
    super.initState();
    getResults();
  }

  @override
  Widget build(BuildContext context) {    
    List<DateTime> dates = List.generate(
      endDate.difference(startDate).inDays + 1,
      (index) => startDate.add(Duration(days: index)),
    );

    if (entries.isNotEmpty) {
      dates = [];
      for (var entry in entries) {
        dates.add(entry.createdAt);
      }
      if (_hasEntryToday){} else{
          dates.add(DateTime.now());
      }      
      dates.add(DateTime.now().add(Duration(days: 1)));
    } 

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
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeView(1)),
                          );
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
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: _isLoading
              ? Center(
                  child: LoadingAnimationWidget.beat(
                      color: AppColors.WHITE, size: 50),
                )
              : Container(
                  child: ListView.builder(
                  itemCount: dates.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DateTime date = dates[index];
                    final List<BitacoraEntry> dateEntries = [];

                    entries.forEach((obj) async {
                      if (DateFormat('yMd').format(date) ==
                          DateFormat('yMd').format(obj.createdAt)) {
                        dateEntries.add(obj);
                      }
                    });

                    if (DateFormat('yMd').format(date) ==
                        DateFormat('yMd').format(DateTime.now())) {
                      return DateRectangle(
                          date: date, isToday: true, entryData: dateEntries);
                    } else {
                      final DateTime date = dates[index];
                      return DateRectangle(
                          date: date, isToday: false, entryData: dateEntries);
                    }
                  },
                ))),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class DateRectangle extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final List<BitacoraEntry> entryData;

  const DateRectangle(
      {Key? key,
      required this.date,
      required this.isToday,
      required this.entryData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entryData.isEmpty) {
      return Opacity(
        opacity: (isToday ? 1 : 0.5),
        child: Container(
          margin: EdgeInsets.only(top: 10, bottom: 15, right: 20, left: 20),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (isToday ? "HOY • " : "") + "${capitalize(DateFormat.EEEE('es_ES').format(date))} ${DateFormat('d').format(date)} de ${DateFormat.MMMM('es_ES').format(date)} del ${DateFormat('y').format(date)}" ,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(color: AppColors.APPBAR_TEXT, fontSize: 15),
                  )),
              Container(
                width: double.infinity,
                height: (isToday ? 150 : 100),
                margin: EdgeInsets.only(top: 5, bottom: 0, right: 0, left: 0),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: (isToday
                      ? AppColors.BUTTON_COLOR_WHITE
                      : AppColors.BUTTON_TEXT_COLOR),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: isToday
                      ? Container(
                          child: Row(
                          children: [
                            SizedBox(
                              width: 75,
                            ),
                            Expanded(
                                child: Text(
                                    "¿Cómo te encuentras el dia de hoy? ¿Como te sientes?")),
                            SizedBox(
                              width: 15,
                            ),
                            FloatingActionButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Bitacora1View()),
                                );
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                              backgroundColor: AppColors.BUTTON_COLOR,
                              elevation: 0,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                          ],
                        ))
                      : Container(
                          child: Row(
                          children: [
                            Text("No hay registro"),
                          ],
                        )),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Opacity(
        opacity: (isToday ? 1 : 0.9),
        child: Container(
          margin: EdgeInsets.only(top: 10, bottom: 15, right: 20, left: 20),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (isToday ? "HOY • " : "") + "${capitalize(DateFormat.EEEE('es_ES').format(date))} ${DateFormat('d').format(date)} de ${DateFormat.MMMM('es_ES').format(date)} del ${DateFormat('y').format(date)}" ,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(color: AppColors.APPBAR_TEXT, fontSize: 15),
                  )),
              Container(
                width: double.infinity,
                height: (isToday ? 150 : 100),
                margin: EdgeInsets.only(top: 5, bottom: 0, right: 0, left: 0),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: (isToday ? AppColors.GRIS : AppColors.GRIS),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: isToday
                      ? Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: entryData.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            child: Image.asset(
                                              'assets/images/${entryData[index].emoji}.png',
                                              width: 58,
                                              height: 58,
                                            ),
                                            onTap: () {
                                              _showModal(
                                                  context,
                                                  DateFormat('d • M • y')
                                                      .format(date)
                                                      .toString(),
                                                  entryData[index]
                                                      .emoji
                                                      .toString(),
                                                  entryData[index]
                                                      .feeling
                                                      .toString(),
                                                  entryData[index]
                                                      .reason
                                                      .toString());
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              FloatingActionButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Bitacora1View()),
                                  );
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                backgroundColor: AppColors.BUTTON_COLOR,
                                elevation: 0,
                              ),
                              SizedBox(
                                width: 25,
                              ),
                            ],
                          ),

                          //  Row(
                          //   children: [
                          //     SizedBox(
                          //         width: 75,
                          //       ),
                          //     Expanded(child: Text( "¿Cómo te encuentras el dia de hoy? ¿Como te sientes?")),
                          //     SizedBox(
                          //         width: 15,
                          //       ),
                          //     FloatingActionButton(
                          //         onPressed: () async {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(builder: (context) => Bitacora1View()),
                          //     );

                          //         },
                          //         child: Icon(
                          //           Icons.add,
                          //           color: Colors.white,
                          //           size: 18,
                          //         ),
                          //         backgroundColor: AppColors.BUTTON_COLOR,
                          //         elevation: 0,
                          //       ),
                          //       SizedBox(
                          //         width: 25,
                          //       ),
                          //   ],
                          // )
                        )
                      : Container(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: entryData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      child: Image.asset(
                                        'assets/images/${entryData[index].emoji}.png',
                                        width: 48,
                                        height: 48,
                                      ),
                                      onTap: () {
                                        _showModal(
                                            context,
                                            DateFormat('d • M • y')
                                                .format(date)
                                                .toString(),
                                            entryData[index].emoji.toString(),
                                            entryData[index].feeling.toString(),
                                            entryData[index].reason.toString());
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showModal(BuildContext context, String date, String emoji,
      String feeling, String reason) {
    double screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 400,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/${emoji}.png',
                  width: 58,
                  height: 58,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  date,
                  style: TextStyle(color: AppColors.APPBAR_TEXT, fontSize: 17),
                ),
                AlertDialog(
                  content: Column(
                    children: [
                      Text('hoy me sentí',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: AppColors.GRIS, fontSize: 15)),
                      Text(feeling.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.BUTTON_TEXT_COLOR_WHITE,
                            fontSize: 20,
                            letterSpacing: 2.0,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Text('porque',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: AppColors.GRIS, fontSize: 15)),
                      Text(
                        reason,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    BottomButton(
                        isWhiteButton: false,
                        text: "OK",
                        tap: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String capitalize(String s) {
  if (s == null || s.isEmpty) {
    return s;
  }
  return s[0].toUpperCase() + s.substring(1);
}
