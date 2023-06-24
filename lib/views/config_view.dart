import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/models/bitacora_entry_model.dart';
import 'package:sequitur_movil/models/user_model.dart';
import 'package:sequitur_movil/views/bitacora_1_view.dart';
import 'package:sequitur_movil/views/home_view.dart';
import 'package:sequitur_movil/views/profile_view.dart';
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

class ConfigView extends StatefulWidget {
  final int userId;
  ConfigView(this.userId);

  @override
  _ConfigViewState createState() => _ConfigViewState(userId);
}

class _ConfigViewState extends State<ConfigView> {
  final int userId;
  _ConfigViewState(this.userId);

  String url = "https://back-sequitur-production.up.railway.app/api/";

  List dataUser = [];

  UserModel currentUseri = UserModel(
      id: 0,
      firstName: '',
      lastName: '',
      email: '',
      telephone: '',
      universityId: 0,
      gender: '',
      password: '',
      );
  bool _isLoading = true;

  Future<String> getUser() async {
    print(userId);
    //print(currentUserId);
    var response =
        await http.get(Uri.parse("${url}students/$userId"), headers: headers());

    setState(() {
      var extractdata = json.decode(response.body);
      currentUseri = UserModel(
          id: extractdata['id'],
          firstName: extractdata['firstName'],
          lastName: extractdata['lastName'],
          email: extractdata['email'],
          telephone: extractdata['telephone'],
          universityId: extractdata['universityId'],
          gender: extractdata['genre'],
          birthday: DateTime.parse(extractdata['birthDate']));
    });
    print(currentUseri.firstName);
    _isLoading = false;
    return dataUser.toString();
  }

  @override
  void initState() {
    super.initState();
    getUser();
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeView(widget.userId)),
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
                          "Configuración",
                          style: TextStyle(
                              color: AppColors.APPBAR_TEXT,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          '${currentUseri.firstName} ${currentUseri.lastName}',
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
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(
                      top: AppDimensions.APPBAR_HEIGHT + 40, bottom: 0),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.all(25),
                              alignment: Alignment.topCenter,
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Icon(Icons.person, color: AppColors.BUTTON_COLOR),
                                  SizedBox(
                                    width: 13,
                                  ),
                                  Text('CUENTA',
                                  style:
                                  TextStyle(
                                  color: AppColors.TEXT_COLOR_GRAY, letterSpacing: 1),),
                                ],
                              )),
                           GestureDetector(
                            onTap: () {
                              Navigator.push(
                                      context,
                                      SlidePageRoute(page: ProfileView(currentUseri)),
                                    );                              
                            },
                             child: Container(
                                padding: EdgeInsets.only(top:0,bottom:25,left:25,right:25),
                                alignment: Alignment.topCenter,
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 38,
                                    ),
                                    Text('Ver información personal',
                                    style:
                                    TextStyle(
                                    color: AppColors.TEXT_COLOR_GRAY, letterSpacing: 1),),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    Icon(Icons.keyboard_arrow_right_outlined, color: AppColors.BUTTON_COLOR),
                           
                                  ],
                                )),
                           ),   
                        ],
                      ),
                      GestureDetector(

                        onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                          },                    
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height:4
                            ),
                            Container(
                                padding: EdgeInsets.all(25),
                                alignment: Alignment.topCenter,
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Icon(Icons.logout, color: AppColors.BUTTON_COLOR),
                                    SizedBox(
                                      width: 13,
                                    ),
                                    Text('CERRAR SESIÓN',
                                    style:
                                    TextStyle(
                                    color: AppColors.TEXT_COLOR_GRAY, letterSpacing: 1),),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
}


class SlidePageRoute extends PageRouteBuilder {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}