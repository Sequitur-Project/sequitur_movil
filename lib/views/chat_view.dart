import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequitur_movil/components/bottom_button.dart';
import 'package:sequitur_movil/components/custom_button.dart';
import 'package:sequitur_movil/components/custom_text_field.dart';
import 'package:sequitur_movil/components/title_desc.dart';
import 'package:sequitur_movil/models/chat_message_model.dart';
import 'package:sequitur_movil/models/current_user_model.dart';
import 'package:sequitur_movil/resources/app_colors.dart';
import 'package:sequitur_movil/resources/app_dimens.dart';
import 'package:sequitur_movil/endpoints/endpoints.dart';

import 'package:http/http.dart' as http;

class ChatView extends StatefulWidget {

  final String convoId;
  ChatView(this.convoId);

  @override
  _ChatViewState createState() => _ChatViewState(convoId);

  
}

// List<ChatMessage> messages = [
//   ChatMessage(message: "¡Hola!", sender: "bot"),
//   ChatMessage(message: "¿Como te encuentras el dia de hoy?", sender: "bot"),
//   ChatMessage(message: "bien", sender: "student"),
//   ChatMessage(message: "Mas mensajes", sender: "bot"),
// ];

class _ChatViewState extends State<ChatView> {
  final String convoId;
  _ChatViewState(this.convoId);


  String url = "https://back-sequitur-production.up.railway.app/api/";

  Map newMessage = new Map();
  final _myMessageController = TextEditingController();

 final _controller = ScrollController();

  List<ChatMessage> messages = [];

  bool _isSurveyTime = false;

  Future<String> getHistory() async {
        messages.clear();        

        var responseUser = await http.get(Uri.parse(url + "conversations/"+ convoId +"/studentMessages?page=0&size=99999"), headers: headers());
        var responseBot = await http.get(Uri.parse(url + "conversations/"+ convoId +"/botMessages?page=0&size=99999"), headers: headers());

        setState(() {
          var extractdataUser = json.decode(utf8.decode(responseUser.bodyBytes));
          var extractdataBot = json.decode(utf8.decode(responseBot.bodyBytes));
          extractdataUser = extractdataUser['content'];
          extractdataBot = extractdataBot['content'];

          //print(extractdataUser);
          //print(extractdataBot);

          for (var info in extractdataUser) {
             messages.add(ChatMessage(message: info['message'], date:DateTime.parse(info['createdAt']), sender: 'student')); 
          }

          for (var info in extractdataBot) {
             messages.add(ChatMessage(message: info['message'], date:DateTime.parse(info['createdAt']), sender: 'bot')); 
          }

          messages.sort((b, a) => b.date.compareTo(a.date));   
          messages.forEach((obj) async {
            if (obj.message == '0') {
              obj.message = 'Ningún dia';
            } else if(obj.message == '1'){
              obj.message = 'Varios dias';
            } else if(obj.message == '2'){
              obj.message = 'Más de la mitad de los dias';
            } else if(obj.message == '3'){
              obj.message = 'Casi todos los dias';
            } 

            if (obj.message == 'Gracias por responder las preguntas. Tu puntaje es:'){

              var responseResults = await http.get(
                  Uri.parse(url + "students/1/results"),
                  headers: headers());    

                var extractdataResults = json.decode(responseResults.body);
                var scored = extractdataResults['content'].last['score'] - extractdataResults['content'][extractdataResults['content'].length - 2]['score'];

                setState(() {
                    obj.message = 'Gracias por responder las preguntas. Tu puntaje es: ${scored}.';
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                            _controller.jumpTo(_controller.position.maxScrollExtent);
              });
                 });

            }
          });   
          //messages = messages.map((obj) => obj.message == '0' ? ChatMessage(message: 'Ningún dia', sender:obj.sender, date:obj.date) : obj).toList();
          if (
            messages.last.message.toLowerCase().contains('se ha sentido decaído, deprimido o sin esperanzas') ||
            messages.last.message.toLowerCase().contains('sentir poco interés o placer en hacer las cosas') ||
            messages.last.message.toLowerCase().contains('problemas para conciliar el sueño o permanecer dormido, o dormir demasiado') ||
            messages.last.message.toLowerCase().contains('sentirse cansado o tener poca energía') ||
            messages.last.message.toLowerCase().contains('falta de apetito o comer en exceso') ||
            messages.last.message.toLowerCase().contains('sentirse mal consigo mismo, o que es un fracaso') ||
            messages.last.message.toLowerCase().contains('problemas para concentrarse en cosas, como leer el periódico o mirar televisión') ||
            messages.last.message.toLowerCase().contains('moverse o hablar tan despacio que otras personas podrían haberlo observado') ||
            messages.last.message.toLowerCase().contains('pensamientos de que estaría mejor muerto o de lastimarse a sí mismo de alguna manera')

            ){
              _isSurveyTime = true;
          } else {  _isSurveyTime = false; }

              WidgetsBinding.instance?.addPostFrameCallback((_) {
                            _controller.jumpTo(_controller.position.maxScrollExtent);
              });


        });
          
        return messages.toString();
  }

  @override
  void initState() {
    super.initState();
    getHistory();
    
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
                    color: Color.fromARGB(255, 98, 184, 255),
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
                        "¡Conversemos!",
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
        child: Column(children:[
        Expanded(
      child: SingleChildScrollView(
        
        controller: _controller,
        child: 
        Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: messages.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top:  AppDimensions.APPBAR_HEIGHT + 20, bottom: 10),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (messages[index].sender == "bot"
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: (messages[index].sender == "student"
                            ? AppColors.MESSAGE_STUDENT_COLOR
                            : AppColors.MESSAGE_BOT_COLOR),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF183D8D).withOpacity(0.2),
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
        ),)),
      Align(
              alignment: Alignment.bottomLeft,
              child: _isSurveyTime ? Container (
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: TextButton (
                              style: ButtonStyle(                                                                 
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // Set the border radius
                                    ),
                                  ),   
                                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.BUTTON_COLOR),                                
                              ),
                              onPressed: () async {

                                 setState(() {
                             messages.add(ChatMessage(message: 'Ningún dia', sender: 'student', date: DateTime.now()));
                          });

                          newMessage = {
                            'message': '0',
                          };                          
                          var body = json.encode(newMessage); 
                          _myMessageController.clear();
                          http.Response response = await http.post(Uri.parse(url + "conversations/"+ convoId+"/studentMessages"), headers: headers(), body: body);
                          getHistory();

                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            _controller.jumpTo(_controller.position.maxScrollExtent);
                          });




                              },
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                child: Text('Ningún\ndia', textAlign: TextAlign.center,),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextButton (
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // Set the border radius
                                    ),
                                  ),   
                                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.BUTTON_COLOR),                                
                              ),
                              onPressed: () async {

                                 setState(() {
                             messages.add(ChatMessage(message: 'Varios dias', sender: 'student', date: DateTime.now()));
                          });

newMessage = {
                            'message': '1',
                          };                          
                          var body = json.encode(newMessage); 
                          _myMessageController.clear();
                          http.Response response = await http.post(Uri.parse(url + "conversations/"+ convoId+"/studentMessages"), headers: headers(), body: body);
                          getHistory();

                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            _controller.jumpTo(_controller.position.maxScrollExtent);
                          });

                              },
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                child: Text('Varios\ndias', textAlign: TextAlign.center,),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: TextButton (
                              style: ButtonStyle(                                                                 
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // Set the border radius
                                    ),
                                  ),   
                                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.BUTTON_COLOR),                                
                              ),
                              onPressed: () async {

                                 setState(() {
                             messages.add(ChatMessage(message: 'Más de la mitad de los dias', sender: 'student', date: DateTime.now()));
                          });

newMessage = {
                            'message': '2',
                          };                          
                          var body = json.encode(newMessage); 
                          _myMessageController.clear();
                          http.Response response = await http.post(Uri.parse(url + "conversations/"+ convoId+"/studentMessages"), headers: headers(), body: body);
                          getHistory();

                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            _controller.jumpTo(_controller.position.maxScrollExtent);
                          });


                              },
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                child: Text('Más de la mitad\nde los dias', textAlign: TextAlign.center,),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextButton (
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // Set the border radius
                                    ),
                                  ),   
                                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.BUTTON_COLOR),                                
                              ),
                              onPressed: () async {

                          setState(() {
                             messages.add(ChatMessage(message: 'Casi todos los dias', sender: 'student', date: DateTime.now()));
                          });

                          newMessage = {
                            'message': '3',
                          };                          
                          var body = json.encode(newMessage); 
                          _myMessageController.clear();
                          http.Response response = await http.post(Uri.parse(url + "conversations/"+ convoId+"/studentMessages"), headers: headers(), body: body);
                          getHistory();

                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            _controller.jumpTo(_controller.position.maxScrollExtent);
                          });

                              },
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                child: Text('Casi todos\nlos dias', textAlign: TextAlign.center,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  )


              )
              : 
              Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
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
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () async {

                          setState(() {
                             messages.add(ChatMessage(message: _myMessageController.text.toString(), sender: 'student', date: DateTime.now()));
                          });

                          newMessage = {
                            'message': _myMessageController.text.toString(),
                          };                          
                          var body = json.encode(newMessage); 
                          _myMessageController.clear();
                          http.Response response = await http.post(Uri.parse(url + "conversations/"+ convoId+"/studentMessages"), headers: headers(), body: body);
                          getHistory();

                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            _controller.jumpTo(_controller.position.maxScrollExtent);
                          });

                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.blue,
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
