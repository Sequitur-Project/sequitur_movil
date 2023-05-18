class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String? password;
  final String email;
  final String telephone;
  final int universityId;
  final String gender;
  final DateTime? birthday;

  
  UserModel({required this.id, required this.firstName, required this.lastName, required this.email, required this.telephone, required this.universityId, required this.gender, this.password, this.birthday});
}