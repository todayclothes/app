import 'package:flutter/material.dart';
import 'package:today_clothes/api/ApiClient.dart';
import 'package:today_clothes/screens/User/auth/LoginScreen.dart';

import 'AdditionalInfoScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _email = '';
  String _password = '';
  String _name = '';
  String _authCode = ''; // 추가: 이메일 인증 코드
  String _passwordConfirmation = ''; // 추가: 패스워드 확인 변수
  bool _isCodeVerified = false; // 인증 코드 확인 여부를 나타내는 변수


  Future<bool> _verifyAuthCode() async {
    if (_email.isEmpty || _authCode.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('이메일과 인증 코드를 입력해주세요.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
      return false;
    }

    try {
      bool isVerified = await APIClient.verifyAuthCode(_email, _authCode); // 인증 코드 확인 API 호출

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('인증 코드 확인이 완료되었습니다.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );

      return isVerified;
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('인증 코드 확인에 실패했습니다. 다시 시도해주세요.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );

      return false;
    }
  }

  void _signUp() async {
    try {
      await APIClient.signUp(_email, _password, _name);
      await APIClient.login(_email, _password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdditionalInfoScreen()),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('회원가입에 실패했습니다. 다시 시도해주세요.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  bool _isEmailValid(String email) {
    // 이메일 유효성 검사를 수행하는 코드를 작성합니다.
    // 여기서는 간단한 정규식을 사용하여 이메일 형식을 검사합니다.
    final emailRegex = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }

  bool _isPasswordMatch() {
    return _password == _passwordConfirmation;
  }

  bool _isSignUpButtonEnabled() {
    return _email.isNotEmpty &&
        _password.isNotEmpty &&
        _passwordConfirmation.isNotEmpty &&
        _name.isNotEmpty &&
        _authCode.isNotEmpty &&
        _isPasswordMatch();
  }

  void _sendEmail() async {
    if (_email.isEmpty || !_isEmailValid(_email)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('유효한 이메일을 입력해주세요.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
      return;
    }

    try {
      await APIClient.sendEmail(_email); // 이메일 전송 API 호출

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('이메일 전송이 완료되었습니다. 인증 코드를 입력하세요.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('이메일 전송에 실패했습니다. 다시 시도해주세요.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 배경색을 투명으로 설정
        elevation: 0, // 그림자 효과 제거
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.grey, // 버튼 아이콘 색상을 회색으로 설정
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '환영합니다!',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left, // 왼쪽 정렬
            ),
            SizedBox(height: 40),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: '이름'), // 이름 입력 필드
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: '이메일'), // 이메일 입력 필드
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    primary: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                  child: Text(
                    '전송하기',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    _sendEmail(); // 이메일 전송 메서드 호출
                  },
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: '인증 코드'),
                    onChanged: (value) {
                      setState(() {
                        _authCode = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    primary: _isCodeVerified ? Colors.blue : Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                  child: Text(
                    '확인',
                    style: TextStyle(
                      color: _isCodeVerified ? Colors.white : Colors.blue,
                    ),
                  ),
                  onPressed: _isCodeVerified ? null : () {
                    _verifyAuthCode().then((bool isVerified) {
                      setState(() {
                        _isCodeVerified = isVerified;
                      });
                      if (!isVerified) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text('인증 코드가 맞지 않습니다.'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    });
                  },
                ),
              ],
            ),

            TextFormField(
              decoration: InputDecoration(
                labelText: '패스워드',
              ),
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              obscureText: true,
            ),

            TextFormField(
              decoration: InputDecoration(
                labelText: '패스워드 확인',
                suffixIcon: _passwordConfirmation.isNotEmpty && _password == _passwordConfirmation
                    ? Icon(Icons.check, color: Colors.green)
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _passwordConfirmation = value;
                });
              },
              obscureText: true,
              validator: (value) {
                if (value != _password) {
                  return '패스워드가 일치하지 않습니다.';
                }
                return null;
              },
            ),
            SizedBox(height: 30),

            ElevatedButton(
              child: Text('회원가입'),
              onPressed: _isSignUpButtonEnabled() ? _signUp : null,
            ),
          ],
        ),
      ),
    );
  }

}
