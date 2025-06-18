import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:sequitur_movil/components/bottom_button.dart';

import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/resources/app_dimens.dart';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:sequitur_movil/views/bitacora_view.dart';

import '../components/custom_paragraph_field.dart';

class Bitacora4View extends StatefulWidget {
  final String emoji;
  final String feeling;
  final String reason;
  final String binnacleId;
  final String userId;

  Bitacora4View(
      this.emoji, this.feeling, this.reason, this.binnacleId, this.userId);

  @override
  _Bitacora4ViewState createState() => _Bitacora4ViewState();
}

class _Bitacora4ViewState extends State<Bitacora4View> {
  final _extraController = TextEditingController();
  final String url =
      "https://sequitur-backend-2025-production.up.railway.app/api/";

  void _submitEntry() async {
    final String extraText = _extraController.text.trim().isEmpty
        ? "NO"
        : _extraController.text.trim();

    final newEntry = {
      'emoji': widget.emoji,
      'feeling': widget.feeling,
      'reason': widget.reason,
      'extraText': extraText,
    };

    http.Response response;

    try {
      response = await http.post(
        Uri.parse("${url}binnacles/${widget.binnacleId}/binnacleEntries"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(newEntry),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error de conexión al registrar.")),
      );
      return;
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error al registrar la entrada.")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ Entrada registrada con éxito."),
        duration: Duration(seconds: 2),
      ),
    );

    await Future.delayed(Duration(seconds: 2));

    if (!mounted) return;

    try {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BitacoraView(widget.userId)),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error al redirigir.")),
      );
    }
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
          child: Center(
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: AppColors.APPBAR_TEXT),
                ),
                SizedBox(width: 2),
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
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Bitácora",
                          style: TextStyle(
                              color: AppColors.APPBAR_TEXT,
                              fontSize: 20,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 1),
                      Text("Realiza tu seguimiento",
                          style: TextStyle(
                              color: AppColors.APPBAR_TEXT, fontSize: 15)),
                    ],
                  ),
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
        child: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: AppDimensions.APPBAR_HEIGHT + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                child: Text(
                  "HOY • " +
                      capitalize(
                          DateFormat.EEEE('es_ES').format(DateTime.now())) +
                      " ${DateFormat('d • M • y').format(DateTime.now())}",
                  style: TextStyle(color: AppColors.APPBAR_TEXT, fontSize: 15),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    children: [
                      CustomParagraphField(
                        icon: Icons.edit,
                        controller: _extraController,
                        labelText: '¿Deseas añadir algo más sobre tu día?',
                        labelHint: 'Opcional',
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomButton(
                  isWhiteButton: false,
                  text: "FINALIZAR",
                  tap: _submitEntry,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
