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
   final int userId;
    AppointmentView(this.userId);

  @override
  _AppointmentViewState createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> {
  String url = "https://back-sequitur-production.up.railway.app/api/";
  String aceptado = 'ACEPTAR';

  Map newMessage = new Map();
  final _myMessageController = TextEditingController();

  final _controller = ScrollController();
  int score = 0;
  List dataAppoints = [];

  List<Appointment> appointments = [];
  bool _isLoading = true;

  Future<String> getAppoints() async {
    dataAppoints = [];
 appointments = [];
    _isLoading = true;

    var responseRecs = await http
        .get(Uri.parse(url + "students/"+ widget.userId.toString() +"/appointments"), headers: headers());

    setState(() {
      var extractdataBitacora =
          json.decode(utf8.decode(responseRecs.bodyBytes));

      dataAppoints = extractdataBitacora['content'];
      print(dataAppoints);

      for (var info in dataAppoints) {
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
    getAppoints();
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
                                          setState(() {
                                            if (appointments[index].accepted == false){
                                              appointments[index].accepted = true;
                                            } else {
                                              appointments[index].accepted = false;
                                            }
                                          });
                                        // code for accepting
                                      },
                                      child: Text(
                                        (appointments[index].accepted == false) ? 'ACEPTAR' : 'ACEPTADO',
                                        style: TextStyle(
                                            fontSize: 12, letterSpacing: 1),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: (appointments[index].accepted == false) ? AppColors.BUTTON_COLOR : AppColors.GRIS, 
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
                                        _showEditModal(context, appointments[0]);
                                         getAppoints();
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


  void _showEditModal(BuildContext context, Appointment appointment) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EditAppointmentModal(appointment: appointment);
      },
    );
  }
}

class EditAppointmentModal extends StatefulWidget {
  final Appointment appointment;

  const EditAppointmentModal({required this.appointment});

  @override
  _EditAppointmentModalState createState() => _EditAppointmentModalState();
}

class _EditAppointmentModalState extends State<EditAppointmentModal> {
  late DateTime appointmentDateTime;

  @override
  void initState() {
    super.initState();
    appointmentDateTime = widget.appointment.appointmentDate;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding:EdgeInsets.all(30),
            child: Column(
              children: [
                Text(
                  'Edit Appointment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                ListTile(
  title: Text("Cambiar fecha"),
  subtitle: Text(DateFormat('d • M • y').format(appointmentDateTime)),
  trailing: IconButton(
    icon: Icon(Icons.edit),
    onPressed: () {
      _selectDate(context);
    },
  ),
  tileColor: Colors.white, // Optional: Set a background color for the ListTile
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
    side: BorderSide(color: Colors.grey, width: 1.0), // Specify the border color and width
  ),
),
 SizedBox(height: 8),
                ListTile(
  title: Text("Cambiar hora"),
  
  subtitle: Text(DateFormat('HH:mm').format(appointmentDateTime)),
  trailing: IconButton(
    icon: Icon(Icons.edit),
    onPressed: () {
      _selectTime(context);
    },
  ),
  tileColor: Colors.white, // Optional: Set a background color for the ListTile
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
    side: BorderSide(color: Colors.grey, width: 1.0), // Specify the border color and width
  ),
),
          
          SizedBox(height: 16),
              ],
            ),
          ),          
          Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomButton(
                      isWhiteButton: false,
                      text: "ACTUALIZAR",
                      tap: () {                        
                        setState(() {
                           widget.appointment.appointmentDate = appointmentDateTime;
                            Navigator.pop(context);
                        }); 
                       
                      })),
        ],
      ),
    );
  }

   Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: appointmentDateTime,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.BUTTON_COLOR, // Set your desired color here
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        appointmentDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          appointmentDateTime.hour,
          appointmentDateTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(appointmentDateTime),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.BUTTON_COLOR, // Set your desired color here
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        appointmentDateTime = DateTime(
          appointmentDateTime.year,
          appointmentDateTime.month,
          appointmentDateTime.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      });
    }
  }
}






String capitalize(String s) {
  if (s == null || s.isEmpty) {
    return s;
  }
  return s[0].toUpperCase() + s.substring(1);
}
