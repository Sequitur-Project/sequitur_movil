import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/models/appointment_model.dart';
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

class AppointmentView extends StatefulWidget {
  @override
  _AppointmentViewState createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> {
  String url = "https://back-sequitur-production.up.railway.app/api/";

  Map newMessage = new Map();
  final _myMessageController = TextEditingController();

  final _controller = ScrollController();
  int score = 0;
  List dataRecs = [];

  List<Appointment> appointments = [];
  bool _isLoading = true;

  Future<String> getRecs() async {
    _isLoading = true;

    var responseRecs = await http
        .get(Uri.parse(url + "students/1/appointments"), headers: headers());

    setState(() {
      var extractdataBitacora =
          json.decode(utf8.decode(responseRecs.bodyBytes));

      dataRecs = extractdataBitacora['content'];
      print(dataRecs);

      for (var info in dataRecs) {
        appointments.add(Appointment(
            appointmentDate: DateTime.parse(info['appointmentDate']),
            appointmentTime: info['appointmentTime'],
            appointmentLocation: info['appointmentLocation'],
            reason: info['reason'],
            accepted: info['accepted']));
      }
    });

    _isLoading = false;
    return responseRecs.body.toString();
  }

  @override
  void initState() {
    super.initState();
    getRecs();
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
                          "Citas",
                          style: TextStyle(
                              color: AppColors.APPBAR_TEXT,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          "con nuestros psicólogos",
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
          child: _isLoading
              ? Center(
                  child: LoadingAnimationWidget.beat(
                      color: AppColors.WHITE, size: 50),
                )
              : Container(
                  padding: EdgeInsets.zero,
                  child: ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (BuildContext context, int index) {
                      String date = DateFormat('yMd').format(appointments[index].appointmentDate);
                      String time = appointments[index].appointmentTime;
                      String location = appointments[index].appointmentLocation;
                      String reason = appointments[index].reason;
                      return Container(
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.WHITE,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0) , topRight: Radius.circular(8.0), )
                              ),
                              child: Text(
                                "Dia: ${date}\nHora: ${time}\nDonde: ${location}\nRazon: ${reason}",
                                style: TextStyle(
                                  color: AppColors.BUTTON_TEXT_COLOR_WHITE,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // code for accepting
                                      },
                                      child: Text(
                                        'ACEPTAR',
                                        style: TextStyle(
                                            fontSize: 12, letterSpacing: 1),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.BUTTON_COLOR,
                                        foregroundColor:
                                            AppColors.WHITE,
                                        padding: EdgeInsets.all(20),
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // code for editing
                                      },
                                      child: Text('EDITAR',
                                          style: TextStyle(
                                              fontSize: 12, letterSpacing: 1)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.GRIS,
                                        foregroundColor:
                                            AppColors.TEXT_COLOR_GRAY,
                                        padding: EdgeInsets.all(20),
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ))),
    );
  }
}

String capitalize(String s) {
  if (s == null || s.isEmpty) {
    return s;
  }
  return s[0].toUpperCase() + s.substring(1);
}
