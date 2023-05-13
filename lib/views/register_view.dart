import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:sequitur_movil/components/custom_dropdown.dart';
import 'package:sequitur_movil/models/current_user_model.dart';

import 'package:flutter/material.dart';
import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/components/custom_text_field.dart';
import 'package:sequitur_movil/components/title_desc.dart';
import 'package:sequitur_movil/endpoints/endpoints.dart';
import 'package:sequitur_movil/models/university_model.dart';
import 'package:sequitur_movil/models/user_model.dart';
import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/views/home_view.dart';
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String url = "https://back-sequitur-production.up.railway.app/api/";

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
    myItems.add(UniversityModel(
        id: 2,
        name: 'name2',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 3,
        name: 'name3',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 4,
        name: 'name4',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 5,
        name: 'name5',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 6,
        name: 'name6',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 7,
        name: 'name7',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 8,
        name: 'name8',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 9,
        name: 'name9',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 10,
        name: 'name10',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 11,
        name: 'name11',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 12,
        name: 'name12',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 13,
        name: 'name13',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 14,
        name: 'name14',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 15,
        name: 'name15',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 16,
        name: 'name16',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));myItems.add(UniversityModel(
        id: 17,
        name: 'name17',
        country: 'country2',
        city: 'city2',
        adress: 'adress2',
        zipCode: 'zipCode2',
        ruc: 'ruc2'));

    //print(dataUsers);
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
          child: null /* add child content here */,
        ),
        bottomNavigationBar: BottomButton(
            isWhiteButton: true,
            text: "INICIAR SESIÓN",
            tap: () {
              showMenu();
            }));
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  showMenu() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return _isLoginForm ? buildLoginForm() : buildRegisterForm();
          });
        });
  }

  Widget buildLoginForm() {
    var userId;
    return ChangeNotifierProvider(
        create: (_) => CurrentUserModel(),
        child: Container(
          height:
              MediaQuery.of(context).size.height * 0.8, // 80% of screen height
          child: Column(
            children: [
              // Top text widget
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleDesc(
                            title: 'INICIAR SESIÓN',
                            description:
                                'Inicia sesión utilizando tu correo institucional.'),
                        CustomTextField(
                            icon: Icons.email,
                            controller: _emailController,
                            labelText: 'CORREO INSTITUCIONAL',
                            labelHint: 'ejemplo@correo.edu.pe'),
                        CustomTextField(
                          icon: Icons.lock,
                          controller: _passwordController,
                          labelText: 'CONTRASEÑA',
                          labelHint: 'contraseña',
                          isPassword: true,
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: GestureDetector(
                              child: Text(
                                "Olvidé mi contraseña",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.TEXT_COLOR_GRAY,
                                    fontSize: 12,
                                    letterSpacing: 1),
                                textAlign: TextAlign.left,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginView()),
                                );
                              },
                            ))
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
                        setState(() {
                          _isLoginForm = !_isLoginForm;
                        });
                      })),

              Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomButton(
                      isWhiteButton: false,
                      text: "INICIAR SESIÓN",
                      tap: () {
                        for (var cosa in dataUsers) {
                          if (cosa['email'] == _emailController.text) {
                            userExists = true;
                            userInfo = UserModel(
                                id: cosa['id'],
                                firstName: cosa['firstName'],
                                lastName: cosa['lastName'],
                                email: cosa['email'],
                                telephone: cosa['telephone'],
                                universityId: cosa['universityId']);
                            userId = cosa['id'];
                          }
                        }
                        setState(() {
                          userExists ? userValid = true : userValid = false;
                          _passwordController.text.isNotEmpty
                              ? passValid = true
                              : passValid = false;
                        });
                        if (userValid && passValid) {
                          final currentUser = Provider.of<CurrentUserModel>(
                              context,
                              listen: false);
                          currentUser.setMyValue(userInfo);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeView()),
                          );
                        }
                      })),
            ],
          ),
        ));
  }

  Widget buildRegisterForm() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8, // 80% of screen height
      child: Column(
        children: [
          // Top text widget
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleDesc(
                          title: 'REGISTRAR',
                          description: 'Completa tus datos personales.'),
                      CustomTextField(
                          icon: Icons.email,
                          controller: _emailController,
                          labelText: 'NOMBRES',
                          labelHint: 'Ex. Akira'),
                      CustomTextField(
                          icon: Icons.lock,
                          controller: _passwordController,
                          labelText: 'APELLIDOS',
                          labelHint: 'Ex. Nishikiyama'),
                      CustomTextField(
                          icon: Icons.email,
                          controller: _emailController,
                          labelText: 'TELEPHONE',
                          labelHint: 'Ex. 945871154'),
                      CustomTextField(
                        icon: Icons.email,
                        controller: _emailController,
                        labelText: 'CONTRASEÑA',
                        labelHint: 'contraseña',
                        isPassword: true,
                      ),
                      CustomTextField(
                        icon: Icons.email,
                        controller: _emailController,
                        labelText: 'CONFIRMAR CONTRASEÑA',
                        labelHint: 'contraseña',
                        tap: () {
                          showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: myItems
                  .map(
                    (option) => ListTile(
                      title: Text(option.name),
                      onTap: () {
                        setState(() {
                          _selectedOption = option.id;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),
            );
          },
        );

                        }
                      ),
                      // CustomDropdownWidget<UniversityModel>(
                      //   items: myItems,
                      //   hintText: 'Select an item',
                      //   onChanged: (value) {
                      //     // Do something with the selected item
                      //   },
                      //   displayTextBuilder: (item) => item.name,
                      // ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: GestureDetector(
                            child: Text(
                              "Olvidé mi contraseña",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.TEXT_COLOR_GRAY,
                                  fontSize: 12,
                                  letterSpacing: 1),
                              textAlign: TextAlign.left,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginView()),
                              );
                            },
                          ))
                    ]),
              ),
            ),
          ),
          // Bottom text widget
          Align(
              alignment: Alignment.bottomCenter,
              child: BottomButton(
                  isWhiteButton: true,
                  text: "YA TENGO CUENTA",
                  tap: () {
                    setState(() {
                      _isLoginForm = !_isLoginForm;
                    });
                  })),

          Align(
              alignment: Alignment.bottomCenter,
              child: BottomButton(
                  isWhiteButton: false,
                  text: "CONTINUAR",
                  tap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  })),
        ],
      ),
    );
  }
}
