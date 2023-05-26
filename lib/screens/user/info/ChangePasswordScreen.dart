import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 변경'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '현재 비밀번호',
              ),
              obscureText: true,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: '새로운 비밀번호',
              ),
              obscureText: true,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: '비밀번호 확인',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
// 비밀번호 변경 기능 구현
              },
              child: Text('변경'),
            ),
          ],
        ),
      ),
    );
  }
}

