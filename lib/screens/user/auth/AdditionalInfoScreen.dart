import 'package:flutter/material.dart';
import 'package:today_clothes/api/ApiClient.dart';
import 'package:today_clothes/screens/user/auth/LoginScreen.dart';

class AdditionalInfoScreen extends StatefulWidget {
  @override
  _AdditionalInfoScreenState createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  int _currentPage = 0;
  String _selectedRegion = '';
  String _selectedGender = '';
  int _selectedRegionId = 0;


  final List<Map<String, dynamic>> regions = [
    {"regionId": 1, "regionName": "강남구"},
    {"regionId": 2, "regionName": "강동구"},
    //... (region data here)
    {"regionId": 41, "regionName": "충청남도"},
    {"regionId": 42, "regionName": "충청북도"}
  ];

  final List<String> genders = [
    "남성",
    "여성",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage == 0
          ? _buildGenderSelectionPage()
          : _buildRegionSelectionPage(),
    );
  }

  Widget _buildGenderSelectionPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '성별 선택',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          '당신의 성별을 선택해주세요.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGender = genders[0];
                });
              },
              child: CircleAvatar(
                backgroundColor: _selectedGender == genders[0]
                    ? Colors.blueGrey
                    : Colors.white,
                radius: 20.0,
                child: Text(
                  '🧑‍💼',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            SizedBox(width: 24.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGender = genders[1];
                });
              },
              child: CircleAvatar(
                backgroundColor: _selectedGender == genders[1]
                    ? Colors.blueGrey
                    : Colors.white,
                radius: 20.0,
                child: Text(
                  '👩‍💼',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 32.0),
        TextButton(
          onPressed: () {
            setState(() {
              _currentPage = 1;
            });
          },
          child: Text('다음'),
        ),
      ],
    );
  }

  Widget _buildRegionSelectionPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '지역 선택',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          '사는 지역을 선택해주세요.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.0),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: regions.map((region) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRegionId = region['regionId'];
                });
              },
              child: Chip(
                label: Text(region['regionName']),
                backgroundColor: _selectedRegionId == region['regionId'] ? Colors.blue : Colors.white,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: regions.map((region) {
            int index = regions.indexOf(region);
            return Container(
              width: 10.0,
              height: 10.0,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _currentPage = 0;
                });
              },
              child: Text(
                '이전',
              ),
            ),
            TextButton(
              onPressed: _isInfoComplete() ? _completeSignUp : null,
              child: Text(
                '회원가입 완료',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool _isInfoComplete() {
    return _selectedRegion!=0 && _selectedGender.isNotEmpty;
  }

  Future<void> _completeSignUp() async {
    if (!_isInfoComplete()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('지역명과 성별을 선택해주세요.'),
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

    // Call the API to submit additional info
    bool success = await APIClient.submitAdditionalInfo(
      _selectedRegionId,
      _selectedGender,
    );

    if (success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('회원가입이 완료되었습니다.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('회원가입을 완료하는 데 실패했습니다.'),
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



}
