import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sequitur_movil/components/custom_button_small.dart';
import 'package:sequitur_movil/models/appointment_model.dart';
import 'package:sequitur_movil/models/bitacora_entry_model.dart';
import 'package:sequitur_movil/models/current_user_model.dart';
import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/resources/app_dimens.dart';
import 'package:sequitur_movil/views/appointment_view.dart';
import 'package:sequitur_movil/views/bitacora_1_view.dart';
import 'package:sequitur_movil/views/bitacora_view.dart';
import 'package:sequitur_movil/views/chat_view.dart';
import 'package:sequitur_movil/endpoints/endpoints.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:sequitur_movil/views/config_view.dart';
import 'package:sequitur_movil/views/recs_view.dart';

class HomeView extends StatefulWidget {
  final int userId;
  HomeView(this.userId);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String url = "https://sequitur-backend-2025-production.up.railway.app/api";
  List<dynamic> dataConversation = [];
  final currentUser = Provider.of<CurrentUserModel>;
  String dataConvoId = '0';

  List<dynamic> dataAppoints = [];
  List<dynamic> dataBitacora = [];

  String bitacoraId = '0';

  int numberAppoints = 0;

  List<Appointment> appointments = [];
  List<BitacoraEntry> entries = [];

  String convoId = '';

  bool _isLoading = true;
  bool _hasEntryToday = false;

  Future<String> getConversation(currentUserId) async {
    var response = await http.get(
      Uri.parse("$url/students/$currentUserId/conversations"),
      headers: headers(),
    );

    setState(() {
      var extractdata = json.decode(response.body);
      dataConvoId = extractdata['id'].toString();
    });

    return dataConvoId;
  }

  Future<String> getAppoints() async {
    numberAppoints = 0;
    try {
      final response = await http.get(
        Uri.parse("$url/students/${widget.userId}/appointments"),
        headers: headers(),
      );

      if (response.statusCode == 200) {
        setState(() {
          final extractdata = json.decode(utf8.decode(response.bodyBytes));
          dataAppoints = extractdata['content'] ?? [];

          for (var info in dataAppoints) {
            if (info['accepted'] == false) numberAppoints++;

            appointments.add(Appointment(
              id: info['id'],
              psychologistId: info['psychologistId'],
              appointmentDate: DateTime.parse(info['appointmentDate']),
              appointmentTime: info['appointmentTime'],
              appointmentLocation: info['appointmentLocation'],
              reason: info['reason'],
              accepted: info['accepted'],
            ));
          }
        });
      } else if (response.statusCode == 404) {
        print("No hay citas creadas todavía.");
        setState(() {
          dataAppoints = [];
          numberAppoints = 0;
        });
      } else {
        print("Error al obtener citas: ${response.statusCode}");
      }
    } catch (e) {
      print("Excepción al obtener citas: $e");
    }

    return '';
  }

  Future<void> ensureBitacoraExists() async {
    try {
      final response = await http.get(
        Uri.parse("$url/students/${widget.userId}/binnacles"),
        headers: headers(),
      );

      if (response.statusCode == 404 || response.body.isEmpty) {
        print("No existe bitácora, creando...");

        final creationResponse = await http.post(
          Uri.parse("$url/students/${widget.userId}/binnacles"),
          headers: headers(),
          body: json.encode({}),
        );

        if (creationResponse.statusCode == 201) {
          print("Bitácora creada exitosamente. Actualizando datos...");

          final newBitacoraResponse = await http.get(
            Uri.parse("$url/students/${widget.userId}/binnacles"),
            headers: headers(),
          );

          if (newBitacoraResponse.statusCode == 200) {
            final extractdata = json.decode(newBitacoraResponse.body);
            setState(() {
              bitacoraId = extractdata['id']?.toString() ?? '0';

              final entries = extractdata['binnacleEntries'];
              if (entries != null && entries is List) {
                dataBitacora = entries;
                _hasEntryToday = entries.any((entry) =>
                    DateFormat('d/M/y')
                        .format(DateTime.parse(entry['createdAt'])) ==
                    DateFormat('d/M/y').format(DateTime.now()));
              } else {
                dataBitacora = [];
                _hasEntryToday = false;
              }
            });
          } else {
            print(
                "Error al obtener la bitácora recién creada: ${newBitacoraResponse.statusCode}");
          }
        } else {
          print(
              "Error al crear bitácora: ${creationResponse.statusCode} - ${creationResponse.body}");
        }
      } else {
        print("Bitácora ya existe.");
      }
    } catch (e) {
      print("Excepción al verificar o crear bitácora: $e");
    }
  }

  Future<String> getBitacora() async {
    _isLoading = true;

    try {
      final response = await http.get(
        Uri.parse("$url/students/${widget.userId}/binnacles"),
        headers: headers(),
      );

      if (response.statusCode == 200) {
        final extractdata = json.decode(response.body);
        setState(() {
          bitacoraId = extractdata['id']?.toString() ?? '0';

          final entries = extractdata['binnacleEntries'];
          if (entries != null && entries is List) {
            dataBitacora = entries;
            _hasEntryToday = entries.any((entry) =>
                DateFormat('d/M/y')
                    .format(DateTime.parse(entry['createdAt'])) ==
                DateFormat('d/M/y').format(DateTime.now()));
          } else {
            dataBitacora = [];
            _hasEntryToday = false;
          }
        });
      } else if (response.statusCode == 404) {
        print("No hay bitácora creada todavía.");
        setState(() {
          dataBitacora = [];
          _hasEntryToday = false;
        });
      } else {
        print("Error al obtener bitácora: ${response.statusCode}");
      }
    } catch (e) {
      print("Excepción al obtener bitácora: $e");
    }

    return '';
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getAppoints();
    await ensureBitacoraExists();
    await getBitacora();
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
                SizedBox(width: 20),
                Container(
                  width: 50,
                  height: 50,
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
                      Text(
                        "Home",
                        style: TextStyle(
                          color: AppColors.APPBAR_TEXT,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1),
                      Consumer<CurrentUserModel>(
                        builder: (context, currentUserModel, child) {
                          return Text(
                            'Hola ${currentUserModel.myCurrentUser.firstName}',
                            style: TextStyle(
                              color: AppColors.APPBAR_TEXT,
                              fontSize: 15,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Consumer<CurrentUserModel>(
                  builder: (context, currentUserModel, child) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ConfigView(currentUserModel.myCurrentUser.id),
                          ),
                        );
                      },
                      child: Icon(Icons.settings, color: AppColors.APPBAR_TEXT),
                    );
                  },
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
        child: Consumer<CurrentUserModel>(
          builder: (context, currentUserModel, child) {
            return Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: AppDimensions.APPBAR_HEIGHT + 40, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      CustomButtonSmall(
                        height: 300,
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                        hasNotification: false,
                        isWhiteButton: true,
                        image: DecorationImage(
                          image: AssetImage('assets/images/chat-back.png'),
                          fit: BoxFit.cover,
                        ),
                        text: "CHAT",
                        tap: () async {
                          final currentUser = Provider.of<CurrentUserModel>(
                              context,
                              listen: false);
                          convoId = await getConversation(
                              currentUser.myCurrentUser.id);
                          if (convoId.isNotEmpty && convoId != '0') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatView(
                                  convoId,
                                  currentUserModel.myCurrentUser.id.toString(),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButtonSmall(
                                height: 160,
                                margin: EdgeInsets.only(left: 15, top: 2),
                                isWhiteButton: true,
                                text: "BITÁCORA",
                                hasNotification: !_hasEntryToday,
                                notificationNumber: '+',
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/bitacora-back.png'),
                                  fit: BoxFit.cover,
                                ),
                                tap: () async {
                                  final currentUser =
                                      Provider.of<CurrentUserModel>(context,
                                          listen: false);
                                  final userId =
                                      currentUser.myCurrentUser.id.toString();

                                  final response = await http.get(
                                    Uri.parse(
                                        "https://sequitur-backend-2025-production.up.railway.app/api/students/$userId/binnacles"),
                                    headers: headers(),
                                  );

                                  if (response.statusCode == 200) {
                                    final data = json.decode(response.body);
                                    final binnacleId = data['id'].toString();

                                    final entriesResponse = await http.get(
                                      Uri.parse(
                                          "https://sequitur-backend-2025-production.up.railway.app/api/binnacles/$binnacleId/binnacleEntries"),
                                      headers: headers(),
                                    );

                                    if (entriesResponse.statusCode == 200) {
                                      final entries = json.decode(
                                              entriesResponse.body)['content']
                                          as List;

                                      bool isSameDate(DateTime a, DateTime b) {
                                        return a.year == b.year &&
                                            a.month == b.month &&
                                            a.day == b.day;
                                      }

                                      final now = DateTime.now();
                                      final hasToday = entries.any((entry) {
                                        final createdAt =
                                            DateTime.parse(entry['createdAt'])
                                                .toLocal();
                                        return isSameDate(createdAt, now);
                                      });

                                      print(
                                          "¿Redirigiendo a BitacoraView?: $hasToday");

                                      if (hasToday) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  BitacoraView(userId)),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Bitacora1View(
                                                  binnacleId: binnacleId,
                                                  userId: userId)),
                                        );
                                      }
                                    } else {
                                      print(
                                          "Error al obtener entries: ${entriesResponse.statusCode}");
                                    }
                                  } else {
                                    print(
                                        "Error al obtener binnacle: ${response.statusCode}");
                                  }
                                }),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: CustomButtonSmall(
                              height: 160,
                              hasNotification: true,
                              margin: EdgeInsets.only(right: 15, top: 2),
                              isWhiteButton: true,
                              notificationNumber: numberAppoints.toString(),
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/cita-back.png'),
                                fit: BoxFit.cover,
                              ),
                              text: "CITAS",
                              tap: () {
                                final currentUser =
                                    Provider.of<CurrentUserModel>(context,
                                        listen: false);
                                getConversation(currentUser.myCurrentUser.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppointmentView(
                                        currentUser.myCurrentUser.id),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      CustomButtonSmall(
                        height: 100,
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                        isWhiteButton: true,
                        hasNotification: false,
                        text: "RECOMENDACIONES",
                        tap: () {
                          final currentUser = Provider.of<CurrentUserModel>(
                              context,
                              listen: false);
                          getConversation(currentUser.myCurrentUser.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecsView(currentUserModel.myCurrentUser.id),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
