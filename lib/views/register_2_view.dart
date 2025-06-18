import 'dart:convert';

import 'package:provider/provider.dart';

import 'package:sequitur_movil/models/current_user_model.dart';

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/components/custom_text_field.dart';
import 'package:sequitur_movil/components/title_desc.dart';
import 'package:sequitur_movil/endpoints/endpoints.dart';
import 'package:sequitur_movil/models/gender_model.dart';
import 'package:sequitur_movil/models/university_model.dart';
import 'package:sequitur_movil/models/user_model.dart';

import 'package:sequitur_movil/views/home_view.dart';
import 'package:http/http.dart' as http;

class Register2View extends StatefulWidget {
  final int universityId;
  Register2View(this.universityId);

  @override
  _Register2ViewState createState() => _Register2ViewState(universityId);
}

class _Register2ViewState extends State<Register2View> {
  final int universityId;
  _Register2ViewState(this.universityId);

  String url = "https://sequitur-backend-2025-production.up.railway.app/api/";

  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _emailConfController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfController = TextEditingController();

  String? _nameError;
  String? _lastNameError;
  String? _birthdayError;
  String? _genderError;
  String? _phoneError;
  String? _emailError;
  String? _emailConfError;
  String? _passwordError;
  String? _passwordConfError;

  bool nameValid = false;
  bool lastNameValid = false;
  bool birthdayValid = false;
  bool genderValid = false;
  bool phoneValid = false;
  bool emailValid = false;
  bool emailConfValid = false;
  bool passwordValid = false;
  bool passwordConfValid = false;

  List<GenderModel> myGenders = [];

  List<UniversityModel> myUniversities = [];
  List dataUnis = [];

  String _selectedGender = '';
  String _birthdayDate = '';

  Map newRegister = new Map();

  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  int _selectedOption = 0;

  UserModel userInfo = UserModel(
      email: '',
      firstName: '',
      id: 0,
      lastName: '',
      telephone: '',
      universityId: 0,
      gender: '');

  Future<String> getUniversities() async {
    var response =
        await http.get(Uri.parse(url + "universities"), headers: headers());

    setState(() {
      var extractdata = json.decode(utf8.decode(response.bodyBytes));
      dataUnis = extractdata;
      print(dataUnis);

      myGenders.add(GenderModel(abr: 'F', gender: 'Femenino'));
      myGenders.add(GenderModel(abr: 'M', gender: 'Masculino'));

      for (var info in dataUnis) {
        myUniversities.add(UniversityModel(
            id: info['id'],
            name: info['name'],
            country: info['country'],
            city: info['city'],
            adress: info['address'],
            zipCode: info['zipCode'],
            ruc: info['ruc']));
      }
    });

    return response.body.toString();
  }

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
        child: null,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUniversities();
    showMenu();
  }

  showMenu() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          transitionAnimationController: AnimationController(
            duration: const Duration(milliseconds: 0),
            vsync: Navigator.of(context),
          ),
          isDismissible: false,
          enableDrag: false,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleDesc(
                                    title: 'REGISTRAR',
                                    description:
                                        'Completa tus datos personales.'),
                                CustomTextField(
                                    icon: Icons.person,
                                    controller: _nameController,
                                    error: _nameError,
                                    labelText: 'NOMBRES',
                                    labelHint: 'Ex. Akira'),
                                CustomTextField(
                                    icon: Icons.person,
                                    controller: _lastNameController,
                                    error: _lastNameError,
                                    labelText: 'APELLIDOS',
                                    labelHint: 'Ex. Nishikiyama'),
                                CustomTextField(
                                    icon: Icons.calendar_month,
                                    controller: _birthdayController,
                                    error: _birthdayError,
                                    labelText: 'FECHA NACIMIENTO',
                                    labelHint: 'DD/MM/AAAA',
                                    tap: () {}),
                                CustomTextField(
                                    icon: Icons.person,
                                    controller: _genderController,
                                    labelText: 'GENERO',
                                    labelHint: 'Femenino o Masculino',
                                    error: _genderError,
                                    isReadOnly: true,
                                    tap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                            children: myGenders
                                                .map(
                                                  (option) => ListTile(
                                                    title: Text(option.gender),
                                                    onTap: () {
                                                      setState(() {
                                                        _genderController.text =
                                                            option.gender;
                                                        _selectedGender =
                                                            option.abr;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                )
                                                .toList(),
                                          );
                                        },
                                      );
                                    }),
                                CustomTextField(
                                    icon: Icons.phone,
                                    controller: _phoneController,
                                    error: _phoneError,
                                    labelText: 'TELEFONO',
                                    labelHint: 'Ex. 945871154'),
                                CustomTextField(
                                    icon: Icons.email,
                                    controller: _emailController,
                                    labelText: 'CORREO INSTITUCIONAL',
                                    error: _emailError,
                                    labelHint: 'correo@edu.pe'),
                                CustomTextField(
                                    icon: Icons.email,
                                    controller: _emailConfController,
                                    error: _emailConfError,
                                    labelText: 'COMFIRMAR CORREO',
                                    labelHint: 'correo@edu.pe'),
                                CustomTextField(
                                  icon: Icons.lock,
                                  controller: _passwordController,
                                  labelText: 'CONTRASEÑA',
                                  error: _passwordError,
                                  labelHint: 'contraseña',
                                  isPassword: true,
                                ),
                                CustomTextField(
                                  icon: Icons.lock,
                                  error: _passwordConfError,
                                  controller: _passwordConfController,
                                  labelText: 'CONFIRMAR CONTRASEÑA',
                                  labelHint: 'contraseña',
                                  isPassword: true,
                                ),
                              ]),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: BottomButton(
                            isWhiteButton: true,
                            text: "REGRESAR",
                            tap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            })),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: BottomButton(
                            isWhiteButton: false,
                            text: "REGISTRAR",
                            tap: () async {
                              if (_nameController.text == '') {
                                setModalState(() {
                                  _nameError = 'Ingresa tu nombre.';
                                  nameValid = false;
                                });
                              } else {
                                setModalState(() {
                                  _nameError = null;
                                  nameValid = true;
                                });
                              }

                              if (_lastNameController.text == '') {
                                setModalState(() {
                                  _lastNameError = 'Ingresa tus apellidos.';
                                  lastNameValid = false;
                                });
                              } else {
                                setModalState(() {
                                  _lastNameError = null;
                                  lastNameValid = true;
                                });
                              }

                              if (_birthdayController.text == '') {
                                setModalState(() {
                                  _birthdayError =
                                      'Ingresa tu fecha de nacimiento';
                                  birthdayValid = false;
                                });
                              } else {
                                final RegExp dayRegex =
                                    RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$');
                                if (dayRegex.hasMatch(
                                    _birthdayController.text.toString())) {
                                  setModalState(() {
                                    _birthdayError = null;
                                    birthdayValid = true;
                                  });
                                } else {
                                  setModalState(() {
                                    _birthdayError =
                                        'Fecha no valida. Debe ser DD/MM/AAAA';
                                    birthdayValid = false;
                                  });
                                }
                              }

                              if (_genderController.text == '') {
                                setModalState(() {
                                  _genderError = 'Selecciona tu genero.';
                                  genderValid = false;
                                });
                              } else {
                                setModalState(() {
                                  _genderError = null;
                                  genderValid = true;
                                });
                              }

                              if (_phoneController.text == '') {
                                setModalState(() {
                                  _phoneError = 'Ingresa tu telefono.';
                                  phoneValid = false;
                                });
                              } else {
                                final RegExp phoneRegex = RegExp(r'^\d+$');
                                if (phoneRegex.hasMatch(
                                    _phoneController.text.toString())) {
                                  setModalState(() {
                                    _phoneError = null;
                                    phoneValid = true;
                                  });
                                } else {
                                  setModalState(() {
                                    _phoneError =
                                        'Formato de telefono no valido.';
                                    phoneValid = false;
                                  });
                                }
                              }

                              if (_emailController.text == '') {
                                setModalState(() {
                                  _emailError =
                                      'Ingresa tu correo institucional.';
                                  emailValid = false;
                                });
                              } else {
                                final RegExp emailRegex =
                                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (emailRegex.hasMatch(
                                    _emailController.text.toString())) {
                                  setModalState(() {
                                    _emailError = null;
                                    emailValid = true;
                                  });
                                } else {
                                  setModalState(() {
                                    _emailError =
                                        'Formato de correo no valido.';
                                    emailValid = false;
                                  });
                                }
                              }

                              if (_emailConfController.text == '') {
                                setModalState(() {
                                  _emailConfError =
                                      'Ingresa tu correo institucional.';
                                  emailConfValid = false;
                                });
                              } else {
                                if (_emailConfController.text ==
                                    _emailController.text) {
                                  setModalState(() {
                                    _emailConfError = null;
                                    emailConfValid = true;
                                  });
                                } else {
                                  setModalState(() {
                                    _emailConfError = 'El correo no coincide.';
                                    emailConfValid = false;
                                  });
                                }
                              }

                              if (_passwordController.text == '') {
                                setModalState(() {
                                  _passwordError = 'Ingresa tu contraseña.';
                                  passwordValid = false;
                                });
                              } else {
                                if (_passwordController.text.length < 6) {
                                  setModalState(() {
                                    _passwordError =
                                        'La contraseña debe tener almenos 6 caracteres.';
                                    passwordValid = false;
                                  });
                                } else {
                                  setModalState(() {
                                    _passwordError = null;
                                    passwordValid = true;
                                  });
                                }
                              }

                              if (_passwordConfController.text == '') {
                                setModalState(() {
                                  _passwordConfError = 'Ingresa tu contraseña.';
                                  passwordConfValid = false;
                                });
                              } else {
                                if (_passwordConfController.text ==
                                    _passwordController.text) {
                                  setModalState(() {
                                    _passwordConfError = null;
                                    passwordConfValid = true;
                                  });
                                } else {
                                  setModalState(() {
                                    _passwordConfError =
                                        'La contraseña no coincide.';
                                    passwordConfValid = false;
                                  });
                                }
                              }

                              if (nameValid &&
                                  lastNameValid &&
                                  birthdayValid &&
                                  genderValid &&
                                  phoneValid &&
                                  emailValid &&
                                  emailConfValid &&
                                  passwordValid &&
                                  passwordConfValid) {
                                DateTime _birthday = dateFormat
                                    .parse(_birthdayController.text.toString());
                                String _outputBirth =
                                    DateFormat('yyyy-MM-ddTHH:mm:ss.sssZ')
                                        .format(_birthday.toUtc());

                                newRegister = {
                                  'firstName': _nameController.text.toString(),
                                  'lastName':
                                      _lastNameController.text.toString(),
                                  'email': _emailController.text.toString(),
                                  'password':
                                      _passwordController.text.toString(),
                                  'telephone': _phoneController.text.toString(),
                                  'genre': _selectedGender,
                                  'birthDate': _outputBirth.toString(),
                                };
                                var body = json.encode(newRegister);
                                http.Response response = await http.post(
                                    Uri.parse(url +
                                        "universities/" +
                                        universityId.toString() +
                                        "/students"),
                                    headers: headers(),
                                    body: body);

                                var extractdata = json
                                    .decode(utf8.decode(response.bodyBytes));
                                print(extractdata);

                                if (extractdata['id'] > 0) {
                                  userInfo = UserModel(
                                      id: extractdata['id'],
                                      firstName: extractdata['firstName'],
                                      lastName: extractdata['lastName'],
                                      email: extractdata['email'],
                                      telephone: extractdata['telephone'],
                                      gender: extractdata['genre'],
                                      universityId:
                                          extractdata['universityId']);

                                  final currentUser =
                                      Provider.of<CurrentUserModel>(context,
                                          listen: false);
                                  currentUser.setMyValue(userInfo);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomeView(userInfo.id)),
                                  );
                                }
                              }
                            })),
                  ],
                ),
              );
            });
          });
    });
  }
}
