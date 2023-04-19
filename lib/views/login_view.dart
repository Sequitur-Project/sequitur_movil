import 'package:flutter/material.dart';
import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/components/custom_text_field.dart';
import 'package:sequitur_movil/components/title_desc.dart';
import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/views/home_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoginForm = true;

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
    return Container(
      height: MediaQuery.of(context).size.height * 0.8, // 80% of screen height
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeView()),
                    );
                  })),
        ],
      ),
    );
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
