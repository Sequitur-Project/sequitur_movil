import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sequitur_movil/models/chat_message_model.dart';
import 'package:sequitur_movil/models/current_user_model.dart';
import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/resources/app_dimens.dart';
import 'package:sequitur_movil/endpoints/endpoints.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:http/http.dart' as http;

class ChatView extends StatefulWidget {
  final String userId;
  final String convoId;
  ChatView(this.convoId, this.userId);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  String? convoId;
  String url = "https://sequitur-backend-2025-production.up.railway.app/api";

  Map newMessage = new Map();
  final _myMessageController = TextEditingController();

  final _controller = ScrollController();

  List<ChatMessage> messages = [];

  bool _isSurveyTime = false;
  bool _isLoading = true;

  Future<void> ensureConversationExists() async {
    if (convoId == null || convoId == 'null') {
      // 1. Intentar obtener conversación existente
      var response = await http.get(
        Uri.parse("$url/students/${widget.userId}/conversations"),
        headers: headers(),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data != null && data['id'] != null) {
          setState(() {
            convoId = data['id'].toString();
          });
          return;
        }
      }

      // 2. Si no hay, crearla
      var createResponse = await http.post(
        Uri.parse("$url/students/${widget.userId}/conversations"),
        headers: headers(),
        body: json.encode({}),
      );

      if (createResponse.statusCode == 200 ||
          createResponse.statusCode == 201) {
        var data = json.decode(createResponse.body);
        setState(() {
          convoId = data['id'].toString();
        });
      } else {
        print("No se pudo crear la conversación: ${createResponse.statusCode}");
        print("Respuesta: ${createResponse.body}");
      }
    }
  }

  Future<String> getHistory() async {
    if (convoId == null || convoId == 'null') return 'Sin conversación aún';

    _isLoading = true;
    messages.clear();

    var responseUser = await http.get(
      Uri.parse(
          "$url/conversations/$convoId/studentMessages?page=0&size=99999"),
      headers: headers(),
    );

    var responseBot = await http.get(
      Uri.parse("$url/conversations/$convoId/botMessages?page=0&size=99999"),
      headers: headers(),
    );

    setState(() {
      print(
          "Status User: ${responseUser.statusCode}, body: ${responseUser.body}");
      print("Status Bot: ${responseBot.statusCode}, body: ${responseBot.body}");

      dynamic extractdataUser =
          json.decode(utf8.decode(responseUser.bodyBytes));
      dynamic extractdataBot = json.decode(utf8.decode(responseBot.bodyBytes));

      extractdataUser = extractdataUser['content'];
      extractdataBot = extractdataBot['content'];

      print(extractdataUser);
      print(extractdataBot);

      if (extractdataUser != null && extractdataUser is List) {
        for (var info in extractdataUser) {
          messages.add(ChatMessage(
            message: info['message'],
            date: DateTime.parse(info['createdAt']),
            sender: 'student',
          ));
        }
      }

      if (extractdataBot != null && extractdataBot is List) {
        for (var info in extractdataBot) {
          messages.add(ChatMessage(
            message: info['message'],
            date: DateTime.parse(info['createdAt']),
            sender: 'bot',
          ));
        }
      }

      messages.sort((b, a) => b.date.compareTo(a.date));

      for (var obj in messages) {
        switch (obj.message) {
          case '0':
            obj.message = 'Ningún día';
            break;
          case '1':
            obj.message = 'Varios días';
            break;
          case '2':
            obj.message = 'Más de la mitad de los días';
            break;
          case '3':
            obj.message = 'Casi todos los días';
            break;
        }
      }

      _isSurveyTime = messages.isNotEmpty &&
          (messages.last.message
                  .toLowerCase()
                  .contains('se ha sentido decaído') ||
              messages.last.message
                  .toLowerCase()
                  .contains('sentir poco interés o placer') ||
              messages.last.message
                  .toLowerCase()
                  .contains('problemas para conciliar el sueño') ||
              messages.last.message
                  .toLowerCase()
                  .contains('sentirse cansado') ||
              messages.last.message
                  .toLowerCase()
                  .contains('falta de apetito') ||
              messages.last.message
                  .toLowerCase()
                  .contains('sentirse mal consigo mismo') ||
              messages.last.message
                  .toLowerCase()
                  .contains('problemas para concentrarse') ||
              messages.last.message
                  .toLowerCase()
                  .contains('moverse o hablar tan despacio') ||
              messages.last.message
                  .toLowerCase()
                  .contains('pensamientos de que estaría mejor muerto'));

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (_controller.hasClients) {
          _controller.jumpTo(_controller.position.maxScrollExtent);
        }
      });
    });

    _isLoading = false;
    return messages.toString();
  }

  @override
  void initState() {
    super.initState();
    convoId = widget.convoId;
    ensureConversationExists().then((_) => getHistory());
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUserModel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.APPBAR_TEXT,
                  ),
                ),
                SizedBox(
                  width: 2,
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
                        "Chat",
                        style: TextStyle(
                            color: AppColors.APPBAR_TEXT,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        "¿Como te encuentras?",
                        style: TextStyle(
                            color: AppColors.APPBAR_TEXT, fontSize: 15),
                      ),
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
          child: _isLoading
              ? Center(
                  child: LoadingAnimationWidget.beat(
                      color: AppColors.WHITE, size: 50),
                )
              : Column(
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                      controller: _controller,
                      child: Stack(
                        children: <Widget>[
                          ListView.builder(
                            itemCount: messages.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                                top: AppDimensions.APPBAR_HEIGHT + 20,
                                bottom: 10),
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: Align(
                                  alignment: (messages[index].sender == "bot"
                                      ? Alignment.topLeft
                                      : Alignment.topRight),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color:
                                          (messages[index].sender == "student"
                                              ? AppColors.MESSAGE_STUDENT_COLOR
                                              : AppColors.MESSAGE_BOT_COLOR),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.BOX_SHADOW
                                              .withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      messages[index].message,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: (messages[index].sender == "bot"
                                            ? AppColors.MESSAGE_STUDENT_COLOR
                                            : AppColors.MESSAGE_BOT_COLOR),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: _isSurveyTime
                          ? Container(
                              child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    8), // Set the border radius
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    AppColors.BUTTON_COLOR),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              messages.add(ChatMessage(
                                                  message: 'Ningún dia',
                                                  sender: 'student',
                                                  date: DateTime.now()));
                                            });

                                            newMessage = {
                                              'message': '0',
                                            };
                                            var body = json.encode(newMessage);
                                            _myMessageController.clear();
                                            http.Response response =
                                                await http.post(
                                                    Uri.parse(
                                                        "${url}/conversations/$convoId/studentMessages"),
                                                    headers: headers(),
                                                    body: body);
                                            getHistory();

                                            WidgetsBinding.instance
                                                ?.addPostFrameCallback((_) {
                                              _controller.jumpTo(_controller
                                                  .position.maxScrollExtent);
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              'Ningún\ndia',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    8), // Set the border radius
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    AppColors.BUTTON_COLOR),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              messages.add(ChatMessage(
                                                  message: 'Varios dias',
                                                  sender: 'student',
                                                  date: DateTime.now()));
                                            });

                                            newMessage = {
                                              'message': '1',
                                            };
                                            var body = json.encode(newMessage);
                                            _myMessageController.clear();
                                            http.Response response =
                                                await http.post(
                                                    Uri.parse(
                                                        "${url}/conversations/$convoId/studentMessages"),
                                                    headers: headers(),
                                                    body: body);
                                            getHistory();

                                            WidgetsBinding.instance
                                                ?.addPostFrameCallback((_) {
                                              _controller.jumpTo(_controller
                                                  .position.maxScrollExtent);
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              'Varios\ndias',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    8), // Set the border radius
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    AppColors.BUTTON_COLOR),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              messages.add(ChatMessage(
                                                  message:
                                                      'Más de la mitad de los dias',
                                                  sender: 'student',
                                                  date: DateTime.now()));
                                            });

                                            newMessage = {
                                              'message': '2',
                                            };
                                            var body = json.encode(newMessage);
                                            _myMessageController.clear();
                                            http.Response response =
                                                await http.post(
                                                    Uri.parse(
                                                        "${url}/conversations/$convoId/studentMessages"),
                                                    headers: headers(),
                                                    body: body);
                                            getHistory();

                                            WidgetsBinding.instance
                                                ?.addPostFrameCallback((_) {
                                              _controller.jumpTo(_controller
                                                  .position.maxScrollExtent);
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              'Más de la mitad\nde los dias',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    8), // Set the border radius
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    AppColors.BUTTON_COLOR),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              messages.add(ChatMessage(
                                                  message:
                                                      'Casi todos los dias',
                                                  sender: 'student',
                                                  date: DateTime.now()));
                                            });

                                            newMessage = {
                                              'message': '3',
                                            };
                                            var body = json.encode(newMessage);
                                            _myMessageController.clear();
                                            http.Response response =
                                                await http.post(
                                                    Uri.parse(
                                                        "${url}/conversations/$convoId/studentMessages"),
                                                    headers: headers(),
                                                    body: body);
                                            getHistory();

                                            WidgetsBinding.instance
                                                ?.addPostFrameCallback((_) {
                                              _controller.jumpTo(_controller
                                                  .position.maxScrollExtent);
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              'Casi todos\nlos dias',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ))
                          : Container(
                              padding: EdgeInsets.only(
                                  left: 10, bottom: 10, top: 10),
                              margin: EdgeInsets.all(20),
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _myMessageController,
                                      decoration: InputDecoration(
                                          hintText: "Mensaje...",
                                          hintStyle:
                                              TextStyle(color: Colors.black54),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  FloatingActionButton(
                                    onPressed: () async {
                                      setState(() {
                                        messages.add(ChatMessage(
                                            message: _myMessageController.text
                                                .toString(),
                                            sender: 'student',
                                            date: DateTime.now()));
                                      });

                                      newMessage = {
                                        'message': _myMessageController.text
                                            .toString(),
                                      };
                                      var body = json.encode(newMessage);
                                      _myMessageController.clear();
                                      http.Response response = await http.post(
                                          Uri.parse(
                                              "${url}/conversations/$convoId/studentMessages"),
                                          headers: headers(),
                                          body: body);
                                      getHistory();

                                      WidgetsBinding.instance
                                          ?.addPostFrameCallback((_) {
                                        _controller.jumpTo(_controller
                                            .position.maxScrollExtent);
                                      });
                                    },
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    backgroundColor: AppColors.BUTTON_COLOR,
                                    elevation: 0,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                )),
    );
  }
}
