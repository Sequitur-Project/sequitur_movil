import 'package:flutter/foundation.dart';
import 'package:sequitur_movil/models/user_model.dart';

class CurrentUserModel extends ChangeNotifier {
  UserModel _myCurrentUser = UserModel(email: '', firstName: '', id: 0, lastName: '', telephone: '', universityId: 0, gender:'');

  UserModel get myCurrentUser => _myCurrentUser;

  void setMyValue(UserModel newValue) {
    _myCurrentUser = newValue;
    notifyListeners();
  }
}

  // CurrentUserModel() : super(UserModel(email: '', firstName: '', id: 0, lastName: '', telephone: '', universityId: 0));

  // void setMyValue(UserModel newValue) {
  //   state = newValue;
  // }

  // final currentUserProvider = StateNotifierProvider<CurrentUserModel, UserModel>((ref) => CurrentUserModel());