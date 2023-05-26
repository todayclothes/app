import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  late String userStatus;
  late String name;
  late String email;
  late String gender;
  late String region;

  User(
      {required this.name,
      required this.email,
      required this.gender,
      required this.region,
      required this.userStatus});

  bool _isLoggedIn = false; // 로그인 상태를 나타내는 변수

  bool get isLoggedIn => _isLoggedIn;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        email: json['email'],
        gender: json['gender'],
        region: json['region'],
        userStatus: json['userStatus']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'region': region,
    };
  }

  void updateName(String newName) {
    name = newName;
  }

  void updateEmail(String newEmail) {
    email = newEmail;
  }

  void updateGender(String newGender) {
    gender = newGender;
  }

  void updateRegion(String newRegion) {
    region = newRegion;
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
