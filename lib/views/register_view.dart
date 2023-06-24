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
import 'package:sequitur_movil/views/login_view.dart';
import 'package:sequitur_movil/views/register_2_view.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String url = "https://back-sequitur-production.up.railway.app/api/";

  final _universityController = TextEditingController();
  List<UniversityModel> myUniversities = [];
  List dataUnis = [];

  int _selectedOption = 0;
  String? _universityError;

  Future<String> getUniversities() async {
    var response =
        await http.get(Uri.parse(url + "universities"), headers: headers());

    setState(() {
      var extractdata = json.decode(utf8.decode(response.bodyBytes));
      dataUnis = extractdata;
      print(dataUnis);

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
        child: null /* add child content here */,
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
            duration: const Duration(milliseconds: 0), // set the duration here
            vsync: Navigator.of(context),
          ),
          isDismissible: false,
          enableDrag: false,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
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
                          description: 'Selecciona tu universidad.'),
                      CustomTextField(
                          icon: Icons.school,
                          controller: _universityController,
                          labelText: 'UNIVERSIDAD',
                          labelHint: 'Selecciona tu universidad',
                          error: _universityError,
                          isReadOnly: true,
                          tap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                  children: myUniversities
                                      .map(
                                        (option) => ListTile(
                                          title: Text(option.name),
                                          onTap: () {
                                            setState(() {
                                              _universityController.text =
                                                  option.name;
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
                          }),
                      // CustomDropdownWidget<UniversityModel>(
                      //   items: myItems,
                      //   hintText: 'Select an item',
                      //   onChanged: (value) {
                      //     // Do something with the selected item
                      //   },
                      //   displayTextBuilder: (item) => item.name,
                      // ),
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
                    Navigator.pop(context);
                    Navigator.pop(context);
                  })),

          Align(
              alignment: Alignment.bottomCenter,
              child: BottomButton(
                  isWhiteButton: false,
                  text: "CONTINUAR",
                  tap: () {
                    if (_selectedOption == 0) {
                      setModalState(() {
                        _universityError = 'Selecciona tu universidad.';
                      });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Register2View(_selectedOption)),
                      );
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
