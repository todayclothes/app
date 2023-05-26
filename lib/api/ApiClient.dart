import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:today_clothes/models/User.dart';

class APIClient {
  static const String baseURL = 'https://todayclothes.site';

  // ================ User Method =================== //

  static Future<bool> signUp(String email, String password, String name) async {
    print('============ Start submit signUp data ==============');

    final url = Uri.parse('$baseURL/api/auth/sign-up');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
      'password': password,
      'name': name,
      'emailAuthResult': 'true',
    });

    print(body);

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
      print('회원가입 성공');

    } else {
      print('회원가입 실패: 오류 코드 -> ${response.statusCode} ');
      return false; // 로그인 실패
    }
  }

  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseURL/api/auth/sign-in');

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    String? extractAccessTokenFromCookie(String? setCookie) {
      if (setCookie != null) {
        final cookies = setCookie.split(';');
        for (final cookie in cookies) {
          final parts = cookie.trim().split('=');
          final key = parts[0].toLowerCase();
          final value = parts[1];
          if (key.contains('accesstoken')) {
            print(value);
            return value;
          } else {
            print("잘못됨");
          }
        }
      } else {
        print("잘못됨2");
      }
      return null;
    }

    print('${response.statusCode}');
    print(response.headers);

    if (response.statusCode == 200) {
      final headers = response.headers;
      final setCookie = headers['set-cookie'];

      // Parse the cookies and extract the access token
      final accessToken = extractAccessTokenFromCookie(setCookie!);
      print('Token 의 값은 : ${accessToken}');

      if (accessToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', accessToken);
        print('로그인에 성공하였습니다!');
        return true; // 로그인 성공
      } else {
        print('쿠키에서 토큰을 가져오는데 실패했습니다. (AccessToken 값이 null 값입니다.');
        return false; // 로그인 실패
      }
    } else {
      print('로그인 실패: 오류 코드 -> ${response.statusCode} ');
      return false; // 로그인 실패
    }
  }

  static Future<User> getUserInfo() async {
    print('============ Start Get User Info ==============');

    final url = Uri.parse('$baseURL/api/members/profile');
    final headers = {'Content-Type': 'application/json'};
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    print(token);

    if (token != null) {
      headers['Cookie'] = 'accessToken=$token';
      print("Token is Checked!");
    }

    final response = await http.get(url, headers: headers);

    final bytes = response.bodyBytes;
    final utf8Body = utf8.decode(bytes);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(utf8Body);
      print(jsonBody);
      final user = User.fromJson(jsonBody);
      print('User info retrieved successfully: $user'); // Add logging here
      return user;
    } else {
      // Add logging here
      print('Failed to get user info: ${response.statusCode}');
      throw Exception('Failed to get user info: ${response.statusCode}');
    }
  }

  static Future<void> sendEmail(String email) async {
    print('============ Start Sending Email ==============');

    final headers = {'Content-Type': 'application/json'};
    final url = Uri.parse('$baseURL/api/auth/email/auth-key');
    final body = jsonEncode({
      'email': email,
    });
    print(body);

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );


    if (response.statusCode == 200) {
      print('이메일 전송 완료');
    } else {
      print('이메일 전송 실패: ${response.statusCode}');
    }
  }

  static Future<bool> verifyAuthCode(String email, String key) async {
    print('============ Start AuthKey Check ==============');

    final url = Uri.parse('$baseURL/api/auth/email/auth-key/check');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
      'authKey': key
    });

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('이메일 인증 완료');
      return true;
    } else {
      print('이메일 인증 실패: ${response.statusCode}');
      return false;
    }
  }

  static Future<bool> submitAdditionalInfo (int regionNum, String gender) async {

    print('============ Start submit Additional Info==============');

    if(gender == "여성"){
      gender = "FEMALE";
    }
    else{
      gender = "MALE";
    }

    final url = Uri.parse('$baseURL/api/members/active-info');
    final headers = {'Content-Type': 'application/json'};
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    print(regionNum);
    print(gender);
    print(token);

    if (token != null) {
      headers['Cookie'] = 'accessToken=$token';
      print("Token is Checked!");
    }

    final body = jsonEncode({
      'regionId': regionNum,
      'gender': gender,
    });

    final response = await http.put(url, headers: headers, body: body);

    print(response.statusCode);

    if (response.statusCode == 200) {
      print('success!');
      return true;
    } else {
      print('fail!');
      print('실패: 오류 코드 -> ${response.statusCode} ');
      throw Exception('Failed to fetch Clothes data');
    }
  }


  // ================ Weather Method =================== //

  static Future<List<dynamic>> getWeatherData(DateTime now) async {
    print('============ Start Get Weather Data ==============');

    String dateString = now.toString();
    String dateOnly = dateString.substring(0, 10);

    final url = Uri.parse('$baseURL/api/weather/daily/app?now=$dateOnly');
    final headers = {'Content-Type': 'application/json'};
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      headers['Cookie'] = 'accessToken=$token';
      print("Token is Checked!");
    }

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      return jsonData;
    } else {
      print('실패: 오류 코드 -> ${response.statusCode} ');
      throw Exception('Failed to fetch weather data');
    }
  }

  // ================ Clothes Method =================== //

  static Future<Map<String, dynamic>> getClothesAndSchedule(
      DateTime now) async {
    print('============ Start Get Clothes Data ==============');
    String dateString = now.toString();
    String dateOnly = dateString.substring(0, 10);

    final url = Uri.parse('$baseURL/api/clothes/recommend?date=$dateOnly');
    final headers = {'Content-Type': 'application/json'};
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      headers['Cookie'] = 'accessToken=$token';
      print("Token is Checked!");
    }

    final response = await http.get(url, headers: headers);

    final bytes = response.bodyBytes;
    final utf8Body = utf8.decode(bytes);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8Body);
      return jsonData;
    } else {
      print('실패: 오류 코드 -> ${response.statusCode} ');
      throw Exception('Failed to fetch Clothes data');
    }
  }

  static Future<void> createChoiceClothes(
      int topId, int bottomId, int scheduleDetailId) async {
    print('============ Start save selectClothes Data ==============');
    print(topId);
    print(bottomId);
    print(scheduleDetailId);

    final url = Uri.parse('$baseURL/api/clothes/choice');
    final headers = {'Content-Type': 'application/json'};
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      headers['Cookie'] = 'accessToken=$token';
      print("Token is Checked!");
    }

    final body = jsonEncode({
      'topId': topId,
      'bottomId': bottomId,
      'scheduleDetailId': scheduleDetailId,
    });

    print(body);

    final response = await http.post(url, headers: headers, body: body);

    print(response.statusCode);

    if (response.statusCode == 200) {
      print('success!');
    } else {
      print('fail!');
      print('실패: 오류 코드 -> ${response.statusCode} ');
      throw Exception('Failed to fetch Clothes data');
    }
  }

  static Future<Map<String, dynamic>> getClothesMyChoices({
    int size = 20,
    required int lastClothesChoiceId,
  }) async {
    final url = Uri.parse('$baseURL/api/clothes/choice/mine');
    final headers = {'Content-Type': 'application/json'};
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      headers['Cookie'] = 'accessToken=$token';
      print("Token is Checked!");
    }

    final queryParams = {
      'size': size.toString(),
      // if (lastClothesChoiceId != null)
      // 'lastClothesChoiceId': lastClothesChoiceId.toString(),
    };

    final response = await http.get(url.replace(queryParameters: queryParams),
        headers: headers);
    final bytes = response.bodyBytes;
    final utf8Body = utf8.decode(bytes);

    print(response.statusCode);
    print(utf8Body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8Body);
      return jsonData;
    } else {
      print('실패: 오류 코드 -> ${response.statusCode} ');
      throw Exception('Failed to fetch Clothes Choice data');
    }
  }

  static Future<Map<String, dynamic>> getClothesOtherChoices({
    int size = 20,
    required int lastClothesChoiceId,
  }) async {
    final url = Uri.parse('$baseURL/api/clothes/choice/others');
    final headers = {'Content-Type': 'application/json'};
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      headers['Cookie'] = 'accessToken=$token';
      print("Token is Checked!");
    }

    final queryParams = {
      'size': size.toString(),
      // if (lastClothesChoiceId != null)
      // 'lastClothesChoiceId': lastClothesChoiceId.toString(),
    };

    final response = await http.get(url.replace(queryParameters: queryParams),
        headers: headers);
    final bytes = response.bodyBytes;
    final utf8Body = utf8.decode(bytes);

    print(response.statusCode);
    print(utf8Body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8Body);
      return jsonData;
    } else {
      print('실패: 오류 코드 -> ${response.statusCode} ');
      throw Exception('Failed to fetch Clothes Choice data');
    }
  }

  static Future<Map<String, dynamic>> getClothesLike({
    int size = 20,
    required int lastClothesChoiceId,
  }) async {
    final url = Uri.parse('$baseURL/api/clothes/choice/like');
    final headers = {'Content-Type': 'application/json'};
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      headers['Cookie'] = 'accessToken=$token';
      print("Token is Checked!");
    }

    final queryParams = {
      'size': size.toString(),
      // if (lastClothesChoiceId != null)
      // 'lastClothesChoiceId': lastClothesChoiceId.toString(),
    };

    final response = await http.get(url.replace(queryParameters: queryParams),
        headers: headers);
    final bytes = response.bodyBytes;
    final utf8Body = utf8.decode(bytes);

    print(response.statusCode);
    print(utf8Body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8Body);
      return jsonData;
    } else {
      print('실패: 오류 코드 -> ${response.statusCode} ');
      throw Exception('Failed to fetch Clothes Choice data');
    }
  }

  // ================ Schedule Method =================== //

  static Future<void> createSchedule(
      DateTime now, String title, int timeOfDay) async {
    print('============ Start Create Schedule Data ==============');

    String dateString = now.toString();
    String dateOnly = dateString.substring(0, 10);

    String getTimeOfDayString(int timeOfDay) {
      String timeOfDayString = '';

      if (timeOfDay == 0) {
        timeOfDayString = 'MORNING';
      } else if (timeOfDay == 1) {
        timeOfDayString = 'AFTERNOON';
      } else if (timeOfDay == 2) {
        timeOfDayString = 'NIGHT';
      }
      return timeOfDayString;
    }

    final url = Uri.parse('$baseURL/api/schedules');
    final headers = {'Content-Type': 'application/json'};
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      headers['Cookie'] = 'accessToken=$token';
      print("Token is Checked!");
    }

    final body = jsonEncode({
      'date': dateOnly,
      'title': title,
      'timeOfDay': getTimeOfDayString(timeOfDay),
      'regionName': null
    });

    print(body);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Schedule Data Saved!');
    } else {
      print('실패: 오류 코드 -> ${response.statusCode} ');
      throw Exception('Failed to fetch Clothes data');
    }
  }

  // ================ Like Method =================== //
}
