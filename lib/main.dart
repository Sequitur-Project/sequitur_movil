import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequitur_movil/models/current_user_model.dart';
import 'package:sequitur_movil/views/login_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CurrentUserModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: LoginView(),
    );
  }
}
