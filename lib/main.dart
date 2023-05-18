import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequitur_movil/models/current_user_model.dart';
import 'package:sequitur_movil/views/bitacora_view.dart';
import 'package:sequitur_movil/views/config_view.dart';
import 'package:sequitur_movil/views/login_view.dart';
import 'package:intl/date_symbol_data_local.dart';



void main() async {
  await initializeDateFormatting('es_ES', null);

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
      routes: {
        '/login': (context) => LoginView(),
      }
    );
  }
}


