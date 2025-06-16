import 'dart:convert';

import 'package:provider/provider.dart';

import 'package:sequitur_movil/models/current_user_model.dart';

import 'package:flutter/material.dart';
import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/components/custom_text_field.dart';
import 'package:sequitur_movil/components/title_desc.dart';
import 'package:sequitur_movil/endpoints/endpoints.dart';
import 'package:sequitur_movil/models/university_model.dart';
import 'package:sequitur_movil/models/user_model.dart';

import 'package:sequitur_movil/views/home_view.dart';
import 'package:http/http.dart' as http;
import 'package:sequitur_movil/views/register_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String url = "https://sequitur-backend-2025-production.up.railway.app/api/";

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var userId;

  String? _emailError;
  String? _passwordError;

  bool hasEmailError = false;
  bool hasPasswordError = false;

  List<UniversityModel> myItems = [];
  List dataUsers = [];
  bool userExists = false;
  bool userValid = true;
  bool passValid = true;
  UserModel userInfo = UserModel(
      email: '',
      firstName: '',
      id: 0,
      lastName: '',
      telephone: '',
      gender: '',
      universityId: 0);

  bool _isLoginForm = true;

  int _selectedOption = 0;

  Future<String> getUser() async {
    var response =
        await http.get(Uri.parse(url + "students"), headers: headers());

    setState(() {
      var extractdata = json.decode(response.body);
      dataUsers = extractdata['content'];
    });

    myItems.add(UniversityModel(
        id: 1,
        name: 'name1',
        country: 'country1',
        city: 'city1',
        adress: 'adress1',
        zipCode: 'zipCode1',
        ruc: 'ruc1'));

    //print(dataUsers);
    return response.body.toString();
  }

  void validate() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            child: Center(
              child: Image.asset(
                ('assets/images/IMAGOTIPO.png'),
                fit: BoxFit.cover,
                width: 288 / 1.5,
                height: 180 / 1.5,
              ),
            ),
          ), /* add child content here */
        ),
        bottomNavigationBar: BottomButton(
            isWhiteButton: true,
            text: "INICIAR SESIÓN",
            tap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder:
                        (BuildContext context, StateSetter setModalState) {
                      return ChangeNotifierProvider(
                          create: (_) => CurrentUserModel(),
                          child: Container(
                            height: MediaQuery.of(context).size.height *
                                0.8, // 80% of screen height
                            child: Column(
                              children: [
                                // Top text widget
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TitleDesc(
                                              title: 'INICIAR SESIÓN',
                                              description:
                                                  'Inicia sesión utilizando tu correo institucional.'),
                                          CustomTextField(
                                              icon: Icons.email,
                                              controller: _emailController,
                                              labelText: 'CORREO INSTITUCIONAL',
                                              error: _emailError,
                                              labelHint:
                                                  'ejemplo@correo.edu.pe'),
                                          CustomTextField(
                                            icon: Icons.lock,
                                            controller: _passwordController,
                                            labelText: 'CONTRASEÑA',
                                            labelHint: 'contraseña',
                                            isPassword: true,
                                            error: _passwordError,
                                          ),
                                        ]),
                                  ),
                                ),
                                // Bottom text widget
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: BottomButton(
                                        isWhiteButton: true,
                                        text: "NO TENGO CUENTA",
                                        tap: () {
                                          Navigator.push(
                                            context,
                                            FadePageRoute(
                                                builder: (context) =>
                                                    RegisterView()),
                                          );
                                        })),

                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: BottomButton(
                                        isWhiteButton: false,
                                        text: "INICIAR SESIÓN",
                                        tap: () {
                                          getUser();
                                          userInfo = UserModel(
                                              email: '',
                                              password: '',
                                              firstName: '',
                                              id: 0,
                                              lastName: '',
                                              telephone: '',
                                              gender: '',
                                              universityId: 0);
                                          final RegExp emailRegex = RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                                          setModalState(() {
                                            _emailError = null;
                                          });

                                          if (_passwordController
                                              .text.isNotEmpty) {
                                          } else {
                                            setModalState(() {
                                              passValid = false;
                                              _passwordError =
                                                  'Ingrese su contraseña.';
                                            });
                                          }

                                          if (_emailController.text == '') {
                                            userValid = false;
                                            setModalState(() {
                                              _emailError =
                                                  'Ingrese su correo institucional.';
                                            });
                                          } else if (emailRegex.hasMatch(
                                              _emailController.text
                                                  .toString())) {
                                            setModalState(() {
                                              _emailError = null;
                                            });

                                            for (var cosa in dataUsers) {
                                              if (cosa['email'] ==
                                                  _emailController.text) {
                                                userExists = true;
                                                userInfo = UserModel(
                                                    id: cosa['id'],
                                                    password: cosa['password'],
                                                    firstName:
                                                        cosa['firstName'],
                                                    lastName: cosa['lastName'],
                                                    email: cosa['email'],
                                                    telephone:
                                                        cosa['telephone'],
                                                    gender: cosa['genre'],
                                                    universityId:
                                                        cosa['universityId']);
                                                userId = cosa['id'];
                                              }
                                            }
                                            setModalState(() {
                                              if (userExists) {
                                                userValid = true;
                                                setModalState(() {
                                                  _emailError = null;
                                                });
                                              } else {
                                                userValid = false;
                                                setModalState(() {
                                                  _emailError =
                                                      'Correo no registrado.';
                                                });
                                              }

                                              if (_passwordController
                                                      .text.isNotEmpty &&
                                                  userValid) {
                                                if (userInfo.password ==
                                                    _passwordController.text) {
                                                  passValid = true;
                                                  setModalState(() {
                                                    _passwordError = null;
                                                  });
                                                } else {
                                                  passValid = false;
                                                  setModalState(() {
                                                    _passwordError =
                                                        'Contraseña incorrecta.';
                                                  });
                                                }
                                              } else {
                                                setModalState(() {
                                                  _passwordError =
                                                      'Ingrese su contraseña.';
                                                });
                                              }
                                            });
                                            if (userValid && passValid) {
                                              final currentUser =
                                                  Provider.of<CurrentUserModel>(
                                                      context,
                                                      listen: false);
                                              currentUser.setMyValue(userInfo);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeView(userInfo.id)),
                                              );
                                            }
                                          } else {
                                            setModalState(() {
                                              _emailError =
                                                  'Formato de correo no valido.';
                                            });
                                          }
                                        })),
                              ],
                            ),
                          ));
                    });
                  });
            }));
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }
}

class FadePageRoute<T> extends MaterialPageRoute<T> {
  FadePageRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
