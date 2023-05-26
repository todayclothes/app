import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final Function(String) onUpdateName;
  final String currentGender;
  final Function(String) onUpdateGender;
  final String currentRegion;
  final Function(String) onUpdateRegion;
  final String currentPhoneNumber;
  final Function(String) onUpdatePhoneNumber;

  EditProfileScreen({
    required this.currentName,
    required this.onUpdateName,
    required this.currentGender,
    required this.onUpdateGender,
    required this.currentRegion,
    required this.onUpdateRegion,
    required this.currentPhoneNumber,
    required this.onUpdatePhoneNumber,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    nameController.text = widget.currentName;
    genderController.text = widget.currentGender;
    regionController.text = widget.currentRegion;
    phoneNumberController.text = widget.currentPhoneNumber;
  }

  void validateAndSave() {
    setState(() {
      errorMessage = '';

      final name = nameController.text.trim();
      final gender = genderController.text.trim();
      final region = regionController.text.trim();
      final phoneNumber = phoneNumberController.text.trim();

      if (name.isEmpty || gender.isEmpty || region.isEmpty || phoneNumber.isEmpty) {
        errorMessage = '모든 필드를 입력해주세요.';
      } else {
        widget.onUpdateName(name);
        widget.onUpdateGender(gender);
        widget.onUpdateRegion(region);
        widget.onUpdatePhoneNumber(phoneNumber);
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정보 수정'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '이름',
              ),
            ),
            TextField(
              controller: genderController,
              decoration: InputDecoration(
                labelText: '성별',
              ),
            ),
            TextField(
              controller: regionController,
              decoration: InputDecoration(
                labelText: '지역',
              ),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: '전화번호',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: validateAndSave,
              child: Text('저장'),
            ),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
