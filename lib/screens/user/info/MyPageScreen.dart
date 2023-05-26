import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:today_clothes/api/AuthProvider.dart';
import 'package:today_clothes/models/User.dart';
import 'package:today_clothes/screens/clothes/WardrobeScreen.dart';
import 'package:today_clothes/screens/main/HomeScreen.dart';
import 'package:today_clothes/screens/user/info/ChangePasswordScreen.dart';

import '../../User/auth/LoginScreen.dart';

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    User currentUser = authProvider.currentUser;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 70),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '   내 정보 ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 28,
              ),
            ),
          ),
          SizedBox(height: 140),
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.person,
              size: 80,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Text(
            currentUser.name, // User 모델에서 이름 가져오기
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            currentUser.email, // User 모델에서 이메일 가져오기
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          if (currentUser.isLoggedIn) // 로그인 상태에 따른 UI 조작
            ElevatedButton(
              onPressed: () {
                // 정보 수정 화면으로 이동
              },
              child: Text('정보 수정'),
            ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(),
                ),
              );
            },
            child: Text('비밀번호 변경'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              authProvider.logout(); // 로그아웃 버튼을 눌렀을 때 logout() 메서드 호출
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(), // 로그인 화면으로 이동
                ),
              );
            },
            child: Text('로그아웃'),
          ),

        ],
      ),

      // 3. Bottom NavBar
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Icon(
                Icons.home,
                color: Colors.black,
                size: 32,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WardrobeScreen()),
                );
              },
              child: Icon(
                Icons.access_time_filled,
                color: Colors.black,
                size: 32,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPageScreen()),
                );
              },
              child: Icon(
                Icons.person,
                color: Colors.black,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
