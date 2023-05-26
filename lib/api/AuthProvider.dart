import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:today_clothes/models/User.dart';

import 'ApiClient.dart';

enum LoginState {
  signedOut,
  signedIn,
}

enum ActiveState {
  active,
  inActive,
}

class AuthProvider extends ChangeNotifier {

  // 1. LoginState, CurrentUser 초기값 설정
  LoginState _loginState = LoginState.signedOut;
  ActiveState _activeState = ActiveState.inActive;
  User _currentUser = User(
    name: "",
    email: "",
    gender: "",
    region: "",
    userStatus: "",
  );

  // 2. LoginState, CurrentUSer Getter
  LoginState get loginState => _loginState;
  ActiveState get activeState => _activeState;
  User get currentUser => _currentUser;

  // ==================== Method ===================== //

  // 1. CheckLoginStatus ( 로그인 상태 확인 )
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      _loginState = LoginState.signedIn;
      print('Token found. Logging in...'); // Add logging here
      try {
        _currentUser = await APIClient.getUserInfo();
        if(_currentUser.userStatus == 'ACTIVE'){
          _activeState = ActiveState.active;
        }
        print('User info retrieved successfully: $_currentUser'); // Add logging here
      } catch (e) {
        print('Failed to get user info: $e');
        // 로그인 화면으로 이동하도록 처리
        _loginState = LoginState.signedOut;
        print('User is signed out. No token found.'); // Add logging here
        // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        // 예시에서는 주석 처리하여 로그인 화면으로 이동하는 코드를 작성하지 않았습니다.
        // 로그인 화면으로 이동하도록 코드를 추가해야 합니다.
      }
    } else {
      _loginState = LoginState.signedOut;
      print('No token found. User is signed out.'); // Add logging here
    }

    notifyListeners();
  }

  // 2. Login ( CurrentUser, LoginState 변경 및 API 호출 )
  Future<bool> login(String email, String password) async {
    try {
      final loggedIn = await APIClient.login(email, password);

      if (loggedIn) {
        _loginState = LoginState.signedIn;
        _activeState = ActiveState.active;
        _currentUser = await APIClient.getUserInfo();
      } else {
        _loginState = LoginState.signedOut;
        _currentUser = User(
          name: "",
          email: "",
          gender: "",
          region: "",
          userStatus: "",
        );
      }

      notifyListeners();

      return loggedIn; // loggedIn 값을 반환
    } catch (e) {
      _loginState = LoginState.signedOut;
      _currentUser = User(
        name: "",
        email: "",
        gender: "",
        region: "",
        userStatus: "",
      );

      notifyListeners();

      return false; // 로그인 실패 시 false 반환
    }
  }


  // 3. Shared
  Future<User> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    final email = prefs.getString('email') ?? '';
    final gender = prefs.getString('gender') ?? '';
    final region = prefs.getString('region') ?? '';
    final userStatus = prefs.getString('userStatus') ?? '';

    return User(name: name, email: email, gender: gender, region: region,userStatus:userStatus);
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();

    // 로그아웃 처리
    await prefs.clear();
    _loginState = LoginState.signedOut;
    _currentUser = User(
      name: "",
      email: "",
      gender: "",
      region: "",
      userStatus: "",
    );

    notifyListeners();
  }

}
