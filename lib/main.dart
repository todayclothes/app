import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:today_clothes/models/User.dart';
import 'package:today_clothes/screens/User/auth/LoginScreen.dart';
import 'package:today_clothes/screens/main/AppIntroScreen.dart';
import 'package:today_clothes/screens/main/HomeScreen.dart';
import 'package:today_clothes/screens/user/auth/AdditionalInfoScreen.dart';
import 'package:today_clothes/screens/user/info/MyPageScreen.dart';

import 'api/AuthProvider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<User>(
      create: (_) => User(
        name: "",
        email: "",
        gender: "", // 초기값을 제공해야하는 매개변수들
        region: "",
        userStatus: ""
      ),
      child: MaterialApp(
        title: 'Today Clothes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/intro': (context) => AppIntroScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeWrapper(),
          '/mypage': (context) => MyPageScreen(),
          '/home': (context) => HomeScreen(), // 수정: '/home' 경로 등록
          '/intro': (context) => AppIntroScreen(),
          '/addInfo':(context) => AdditionalInfoScreen(),// 수정: '/intro' 경로 등록
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(Duration(seconds: 2)); // 2초 딜레이

    AuthProvider authProvider = Provider.of<AuthProvider>(
        context, listen: false);
    await authProvider.checkLoginStatus();
    LoginState loginState = authProvider.loginState;
    ActiveState activeState = authProvider.activeState;

    if (loginState == LoginState.signedIn &&
        activeState == ActiveState.active) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (loginState == LoginState.signedIn &&
        activeState == ActiveState.inActive) {
      Navigator.pushReplacementNamed(context, '/addInfo');
    }
    else {
      Navigator.pushReplacementNamed(context, '/intro');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('lib/assets/images/logo.jpeg'),
              width: 350, // 로고의 가로 크기를 조정합니다
              height: 350, // 로고의 세로 크기를 조정합니다
            ),
            SizedBox(height: 16), // 이 줄에 세미콜론(;)을 추가합니다
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class HomeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<AuthProvider>(context).loginState;

    if (loginState == LoginState.signedIn) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
