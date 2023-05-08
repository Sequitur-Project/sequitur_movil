import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sequitur_movil/components/custom_button_small.dart';
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
import 'package:sequitur_movil/views/results_view.dart';


class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String url = "https://back-sequitur-production.up.railway.app/api/"; 
    List dataConversation = [];
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
      final currentUser = Provider.of<CurrentUserModel>;  

  String convoId = '';  

  
  bool _isHomeForm = true;

    Future<String> getConversation(currentUserId) async {
      //print(currentUserId);
    var response =
        await http.get(Uri.parse(url + "students/"+ currentUserId.toString() +"/conversations"), headers: headers());

    setState(() {
      var extractdata = json.decode(response.body);
      dataConversation = extractdata['content'];
    });
    //print(dataConversation);
    return dataConversation[0]['id'].toString();
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
                Icon(Icons.settings, color: AppColors.APPBAR_TEXT),
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
        child: Stack(children: <Widget>[
          Container(
              padding: EdgeInsets.only(
                  top: AppDimensions.APPBAR_HEIGHT + 40, bottom: 10),
              child: Column( children: <Widget>[ CustomButton(
                  isWhiteButton: true,
                  text: "CHAT",
                  tap: () async {
                    final currentUser = Provider.of<CurrentUserModel>(context,listen: false);     
                    convoId = await getConversation(currentUser.myCurrentUser.id);
                    if (convoId != '' || convoId != ' ' || convoId != null) {
                    Navigator.push(                        
                      context,
                      MaterialPageRoute(builder: (context) => ChatView(convoId)),
                    ); }
                  }),
                   SizedBox(
                  height: 13,
                 ),
                  CustomButtonSmall(
                  margin: EdgeInsets.symmetric(horizontal:15, vertical:2),
                  isWhiteButton: true,
                  hasNotification: false,
                  text: "RESULTADOS",
                  tap: () {
                    final currentUser = Provider.of<CurrentUserModel>(context,listen: false);     
                    getConversation(currentUser.myCurrentUser.id);
                    Navigator.push(
                        
                      context,
                      MaterialPageRoute(builder: (context) => ResultsView()),
                    );
                  }),
                   SizedBox(
                  height: 4,
                 ),
                  CustomButtonSmall(
                    hasNotification: false,
                  margin: EdgeInsets.symmetric(horizontal:15, vertical:2),
                  isWhiteButton: true,
                  text: "BITACORA",
                  tap: () {
                    final currentUser = Provider.of<CurrentUserModel>(context,listen: false);     
                    getConversation(currentUser.myCurrentUser.id);
                    Navigator.push(
                        
                      context,
                      MaterialPageRoute(builder: (context) => BitacoraView()),
                    );
                  }),
                  SizedBox(
                  height: 4,
                 ),
                  CustomButtonSmall(
                    hasNotification: true,
                  margin: EdgeInsets.symmetric(horizontal:15, vertical:2),
                  isWhiteButton: true,
                  text: "CITAS",
                  tap: () {
                    final currentUser = Provider.of<CurrentUserModel>(context,listen: false);     
                    getConversation(currentUser.myCurrentUser.id);
                    Navigator.push(
                        
                      context,
                      MaterialPageRoute(builder: (context) => AppointmentView()),
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
        ]) /* add child content here */,
      ),
    );
  }
}
