import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sequitur_movil/models/user_model.dart';

import 'package:sequitur_movil/models/current_user_model.dart';
import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/resources/app_dimens.dart';

import 'package:intl/intl.dart';

class ProfileView extends StatefulWidget {
  final UserModel? user;
  ProfileView(this.user);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? cumple = widget.user!.birthday;
    String birth = DateFormat('d/M/y').format(cumple!);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: AppDimensions.APPBAR_HEIGHT + 20,
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
                  Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, right: 50),
                    width: 100.0,
                    height: 100.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Stack(
                        children: [
                          Container(
                            color: AppColors.GRIS,
                          ),
                          Center(
                            child: Image.asset(
                              ('assets/images/icon.png'),
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
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
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            top: 0, bottom: 25, left: 25, right: 25),
                        alignment: Alignment.topCenter,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Icon(Icons.person, color: AppColors.BUTTON_COLOR),
                            SizedBox(
                              width: 13,
                            ),
                            Text(
                              '${widget.user!.firstName}',
                              style: TextStyle(
                                  color: AppColors.TEXT_COLOR_GRAY,
                                  letterSpacing: 1),
                            ),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.only(
                            top: 0, bottom: 25, left: 25, right: 25),
                        alignment: Alignment.topCenter,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Icon(Icons.person, color: AppColors.BUTTON_COLOR),
                            SizedBox(
                              width: 13,
                            ),
                            Text(
                              '${widget.user!.lastName}',
                              style: TextStyle(
                                  color: AppColors.TEXT_COLOR_GRAY,
                                  letterSpacing: 1),
                            ),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.only(
                            top: 0, bottom: 25, left: 25, right: 25),
                        alignment: Alignment.topCenter,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Icon(Icons.email, color: AppColors.BUTTON_COLOR),
                            SizedBox(
                              width: 13,
                            ),
                            Text(
                              '${widget.user!.email}',
                              style: TextStyle(
                                  color: AppColors.TEXT_COLOR_GRAY,
                                  letterSpacing: 1),
                            ),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.only(
                            top: 0, bottom: 25, left: 25, right: 25),
                        alignment: Alignment.topCenter,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Icon(Icons.phone, color: AppColors.BUTTON_COLOR),
                            SizedBox(
                              width: 13,
                            ),
                            Text(
                              '${widget.user!.telephone}',
                              style: TextStyle(
                                  color: AppColors.TEXT_COLOR_GRAY,
                                  letterSpacing: 1),
                            ),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.only(
                            top: 0, bottom: 45, left: 25, right: 25),
                        alignment: Alignment.topCenter,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Icon(Icons.cake, color: AppColors.BUTTON_COLOR),
                            SizedBox(
                              width: 13,
                            ),
                            Text(
                              '${birth}',
                              style: TextStyle(
                                  color: AppColors.TEXT_COLOR_GRAY,
                                  letterSpacing: 1),
                            ),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
