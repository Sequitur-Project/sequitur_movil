import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sequitur_movil/components/custom_button_small.dart';
import 'package:sequitur_movil/models/appointment_model.dart';
import 'package:sequitur_movil/models/current_user_model.dart';
import 'package:sequitur_movil/models/user_model.dart';

import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/components/custom_button.dart';
import 'package:sequitur_movil/components/custom_text_field.dart';
import 'package:sequitur_movil/components/title_desc.dart';
import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/resources/app_dimens.dart';
import 'package:sequitur_movil/views/appointment_view.dart';
import 'package:sequitur_movil/views/bitacora_view.dart';
import 'package:sequitur_movil/views/chat_view.dart';
import 'package:sequitur_movil/endpoints/endpoints.dart';

import 'package:http/http.dart' as http;
import 'package:sequitur_movil/views/config_view.dart';
import 'package:sequitur_movil/views/results_view.dart';

class HomeView extends StatefulWidget {
  final int userId;

  HomeView(this.userId);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String url = "https://back-sequitur-production.up.railway.app/api/";
  List dataConversation = [];
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final currentUser = Provider.of<CurrentUserModel>;

  List dataAppoints = [];
  int numberAppoints = 0;

  List<Appointment> appointments = [];

  String convoId = '';

  bool _isHomeForm = true;
  bool _isLoading = true;


  Future<String> getConversation(currentUserId) async {
    //print(currentUserId);
    var response = await http.get(
        Uri.parse(
            url + "students/" + currentUserId.toString() + "/conversations"),
        headers: headers());

    setState(() {
      var extractdata = json.decode(response.body);
      dataConversation = extractdata['content'];
    });
    //print(dataConversation);
    return dataConversation[0]['id'].toString();
  }

  
  Future<String> getAppoints() async {
    numberAppoints = 0;
    var responseRecs = await http
        .get(Uri.parse(url + "students/"+ widget.userId.toString() +"/appointments"), headers: headers());

    setState(() {
      var extractdataBitacora =
          json.decode(utf8.decode(responseRecs.bodyBytes));

      dataAppoints = extractdataBitacora['content'];
      print(dataAppoints);

      for (var info in dataAppoints) {
        if (info['accepted'] == false){
            numberAppoints = numberAppoints + 1;
        }

        appointments.add(Appointment(
            appointmentDate: DateTime.parse(info['appointmentDate']),
            appointmentTime: info['appointmentTime'],
            appointmentLocation: info['appointmentLocation'],
            reason: info['reason'],
            accepted: info['accepted']));
      }
    });
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
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
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
                        "Home",
                        style: TextStyle(
                            color: AppColors.APPBAR_TEXT,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Consumer<CurrentUserModel>(
                        builder: (context, currentUserModel, child) {
                          return Text(
                            'Hola ${currentUserModel.myCurrentUser.firstName}',
                            style: TextStyle(
                                color: AppColors.APPBAR_TEXT, fontSize: 15),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Consumer<CurrentUserModel>(
                  builder: (context, currentUserModel, child) {
                  return GestureDetector(
                    onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConfigView(currentUserModel.myCurrentUser.id)),
                        );
                      },
                      child: Icon(Icons.settings, color: AppColors.APPBAR_TEXT));
  },
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
        child: Consumer<CurrentUserModel>(
          builder: (context, currentUserModel, child) {
            return Stack(children: <Widget>[
              Container(
                  padding: EdgeInsets.only(
                      top: AppDimensions.APPBAR_HEIGHT + 40, bottom: 10),
                  child: Column(children: <Widget>[
                    CustomButton(
                        isWhiteButton: true,
                        text: "CHAT",
                        tap: () async {
                          final currentUser =
                              Provider.of<CurrentUserModel>(context, listen: false);
                          convoId =
                              await getConversation(currentUser.myCurrentUser.id);
                          if (convoId != '' || convoId != ' ' || convoId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatView(convoId,currentUserModel.myCurrentUser.id.toString())),
                            );
                          }
                        }),
                    SizedBox(
                      height: 13,
                    ),
                    CustomButtonSmall(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                        isWhiteButton: true,
                        hasNotification: false,
                        text: "RESULTADOS",
                        tap: () {
                          final currentUser =
                              Provider.of<CurrentUserModel>(context, listen: false);
                          getConversation(currentUser.myCurrentUser.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ResultsView(currentUserModel.myCurrentUser.id)),
                          );
                        }),
                    SizedBox(
                      height: 4,
                    ),
                    CustomButtonSmall(
                        hasNotification: false,
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                        isWhiteButton: true,
                        text: "BITACORA",
                        tap: () {
                          final currentUser =
                              Provider.of<CurrentUserModel>(context, listen: false);
                          getConversation(currentUser.myCurrentUser.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BitacoraView(currentUserModel.myCurrentUser.id.toString())),
                          );
                        }),
                    SizedBox(
                      height: 4,
                    ),
                    CustomButtonSmall(
                        hasNotification: true,
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                        isWhiteButton: true,
                        notificationNumber: numberAppoints,
                        text: "CITAS",
                        tap: () {
                          final currentUser =
                              Provider.of<CurrentUserModel>(context, listen: false);
                          getConversation(currentUser.myCurrentUser.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppointmentView(currentUser.myCurrentUser.id)),
                          );
                        }),
                  ])),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  margin: EdgeInsets.all(20),
                  height: 60,
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ]);
          }
        ) /* add child content here */,
      ),
    );
  }
}

