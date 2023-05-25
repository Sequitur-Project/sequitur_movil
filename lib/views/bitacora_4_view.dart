import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/views/bitacora_view.dart';
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

import '../components/custom_paragraph_field.dart';

class Bitacora4View extends StatefulWidget {
  final String emoji;
  final String feeling;
  final String reason;
  Bitacora4View(this.emoji, this.feeling, this.reason);

  @override
  _Bitacora4ViewState createState() => _Bitacora4ViewState(emoji, feeling, reason);
}

class _Bitacora4ViewState extends State<Bitacora4View> {
   final String emoji;
  final String feeling;
  final String reason;
  _Bitacora4ViewState(this.emoji, this.feeling, this.reason);
  String url = "https://back-sequitur-production.up.railway.app/api/";

  String bitacoraId = '';

  Map newEntry = new Map();
  final _myMessageController = TextEditingController();

  final _reasonController = TextEditingController();
  final _extraController = TextEditingController();

  final _controller = ScrollController();
  int score = 0;
  List dataResults = [];

  final DateTime startDate = DateTime(2023, 5, 1);
  final DateTime endDate = DateTime(2023, 5, 4);
  int _selectedValue = 0; // Initially no radio button is selected

final List<Map<String, dynamic>> _buttonData = [
  {'text': 'Miedo', 'image': 'assets/images/miedo.png'},
  {'text': 'Enojo', 'image': 'assets/images/enojo.png'},
  {'text': 'Aversión', 'image': 'assets/images/aversion.png'},
  {'text': 'Tristeza', 'image': 'assets/images/tristeza.png'},
  {'text': 'Felicidad', 'image': 'assets/images/felicidad.png'},
  {'text': 'Sorpresa', 'image': 'assets/images/sorpresa.png'},
];

List<Widget> _buildRadioButtons() {
  List<Widget> list = [];
  for (int i = 0; i < _buttonData.length; i++) {
    list.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal:20, vertical: 4.0),
        child: TextButton(
          child: Container(
            width:double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [             
                Text(
                  _buttonData[i]['text'],
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
                borderRadius: BorderRadius.circular(18.0),
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
            print('Selected value is: ${_buttonData[_selectedValue]['text']}');
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
                            
                            CustomParagraphField(
                              icon: Icons.plus_one,
                              controller: _extraController,
                              labelText: '¿Hay algo más que nos quieras contar?',
                              labelHint: 'Extra'
                            ),
                          ],
                        ),
                  ),
                
                )),
                 Consumer<CurrentUserModel>(
                        builder: (context, currentUserModel, child) {
                    return Align(
                        alignment: Alignment.bottomCenter,
                        child: BottomButton(
                            isWhiteButton: false,
                            text: "REGISTRAR",
                            tap: () async {

                                  newEntry = {
                                      'emoji': emoji,
                                      'feeling': feeling,
                                      'reason': reason,
                                      'extraText': _extraController.text.toString()                             
                                  };                          
                                  var body = json.encode(newEntry);  

                                  var responseResults = await http.get(
                                    Uri.parse(url + "students/"+  currentUserModel.myCurrentUser.id.toString() +"/binnacles"),
                                    headers: headers());

                                   setState(() {
                                      var extractdataBitacora = json.decode(responseResults.body);
                                      bitacoraId = extractdataBitacora['id'].toString();
                                  });

                                  http.Response response = await http.post(Uri.parse(url + "binnacles/"+ bitacoraId +"/binnacleEntries"), headers: headers(), body: body);

                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => BitacoraView(currentUserModel.myCurrentUser.id.toString())),
                                    );  

                            })
                        );
                  }
                ),
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