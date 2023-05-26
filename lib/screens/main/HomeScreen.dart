import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:today_clothes/api/ApiClient.dart';
import 'package:today_clothes/models/Clothes.dart';
import 'package:today_clothes/models/Schedule.dart';
import 'package:today_clothes/screens/clothes/WardrobeScreen.dart';

import '../user/info/MyPageScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0; // 선택된 인덱스를 저장하는 변수
  int scheduleCurrentIndex = 0; // 현재 슬라이드 인덱스
  int topCurrentIndex = 0; // 현재 슬라이드 인덱스
  int bottomCurrentIndex = 0; // 현재 슬라이드 인덱스
  int dayIndex = 0;
  bool isSaving = false;

  String title = ''; // 입력된 일정 제목을 저장할 변수

  final List<String> days = ['오늘', '내일', '모레']; // 날짜 리스트

  List<int> minTemps = [0, 0, 0]; // 최저 기온 데이터
  List<int> maxTemps = [0, 0, 0]; // 최고 기온 데이터

  List<ClothesItem> morningTopList = [];
  List<ClothesItem> afternoonTopList = [];
  List<ClothesItem> nightTopList = [];
  List<ClothesItem> morningBottomList = [];
  List<ClothesItem> afternoonBottomList = [];
  List<ClothesItem> nightBottomList = [];
  List<ScheduleDetail> filteredScheduleDetailList = []; // 상태 변수로 선언
  List<ScheduleDetail?> scheduleDetailList =
      List<ScheduleDetail?>.generate(3, (_) => null);

  List<ClothesItem> getSelectedTopList(int dayIndex) {
    switch (dayIndex) {
      case 0:
        return morningTopList;
      case 1:
        return afternoonTopList;
      case 2:
        return nightTopList;
      default:
        return []; // 선택된 리스트가 없는 경우 빈 리스트 반환 또는 다른 처리를 수행할 수 있습니다.
    }
  }

  List<ClothesItem> getSelectedBottomList(int dayIndex) {
    switch (dayIndex) {
      case 0:
        return morningBottomList;
      case 1:
        return afternoonBottomList;
      case 2:
        return nightBottomList;
      default:
        return []; // 선택된 리스트가 없는 경우 빈 리스트 반환 또는 다른 처리를 수행할 수 있습니다.
    }
  }

  List<DateTime> dates = [
    DateTime.now(), // 오늘 날짜
    DateTime.now().add(Duration(days: 1)), // 내일 날짜
    DateTime.now().add(Duration(days: 2)), // 모레 날짜
  ];

  @override
  void initState() {
    super.initState();
    fetchWeather(DateTime.now());
    fetchClothes(DateTime.now());
  }

  void handleDateSelection(int index) {
    setState(() {
      selectedIndex = index; // 선택된 인덱스 업데이트
    });

    // API 요청
    fetchWeather(dates[index]);
    fetchClothes(dates[index]);
  }

  String getScheduleTimeOfDayEmoji(int index) {
    switch (index) {
      case 0:
        return '☀️'; // 아침 이모티콘
      case 1:
        return '🌞'; // 낮 이모티콘
      case 2:
        return '🌙'; // 저녁 이모티콘
      default:
        return '';
    }
  }

  Future<void> fetchWeather(DateTime date) async {
    try {
      List<dynamic> jsonData = await APIClient.getWeatherData(date);

      setState(() {
        minTemps[0] = jsonData[0]['lowestTemp'].toInt();
        minTemps[1] = jsonData[1]['lowestTemp'].toInt();
        minTemps[2] = jsonData[2]['lowestTemp'].toInt();

        maxTemps[0] = jsonData[0]['highestTemp'].toInt();
        maxTemps[1] = jsonData[1]['highestTemp'].toInt();
        maxTemps[2] = jsonData[2]['highestTemp'].toInt();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchClothes(DateTime date) async {
    try {
      Map<String, dynamic> jsonData =
          await APIClient.getClothesAndSchedule(date);
      Clothes clothes = parseClothesData(jsonData);
      Schedule schedule = parseScheduleData(jsonData);

      setState(() {
        morningTopList = clothes.morningTop;
        afternoonTopList = clothes.afternoonTop;
        nightTopList = clothes.nightTop;
        morningBottomList = clothes.morningBottom;
        afternoonBottomList = clothes.afternoonBottom;
        nightBottomList = clothes.nightBottom;
        scheduleDetailList = [
          schedule.morning,
          schedule.afternoon,
          schedule.night
        ];
      });
    } catch (e) {
      // 요청 실패 또는 데이터 처리 오류 발생 시 처리할 내용
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body 부분
      body: Column(
        children: [
          SizedBox(height: 70),

          // 1. 제목 부분
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '    오늘뭐입지? ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 28,
              ),
            ),
          ),
          SizedBox(height: 25),

          // 2. 온도 부분
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 2-1. 오늘 내일 모레 작성 부분
              Row(
                children: [
                  for (int i = 0; i < days.length; i++)
                    GestureDetector(
                      onTap: () => handleDateSelection(i),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          days[i],
                          style: TextStyle(
                            fontWeight: selectedIndex == i
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 26,
                            color: selectedIndex == i
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // 최저 기온, 최고 기온 부분
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Min',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${minTemps[selectedIndex]}°C',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 25),
                  Column(
                    children: [
                      Text(
                        'Max',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${maxTemps[selectedIndex]}°C',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 25),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),

          // 3. 일정 작성 부분
          Text(
            '오늘의 일정',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          CarouselSlider(
            items: scheduleDetailList.map((scheduleDetail) {
              if (scheduleDetail?.id != 0) {
                return Row(
                  children: [
                    Text(
                      getScheduleTimeOfDayEmoji(
                          scheduleDetailList.indexOf(scheduleDetail)),
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        scheduleDetail?.title ?? '',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String editedTitle = scheduleDetail?.title ?? '';
                            return AlertDialog(
                              title: Text('일정 수정'),
                              content: TextFormField(
                                initialValue: editedTitle,
                                onChanged: (value) {
                                  editedTitle = value;
                                },
                              ),
                              actions: [
                                TextButton(
                                  child: Text('취소'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text('저장'),
                                  onPressed: () async {
                                    setState(() {
                                      isSaving = true; // 저장 요청 중임을 표시
                                    });
                                    // 수정된 일정을 서버로 요청하여 업데이트
                                    if (scheduleDetail != null) {
                                      await APIClient.createSchedule(
                                        dates[selectedIndex],
                                        editedTitle,
                                        scheduleCurrentIndex,
                                      );
                                    }
                                    setState(() {
                                      isSaving = false; // 저장 요청 완료 표시
                                      // 화면을 다시 그리기 위한 상태 변경
                                      handleDateSelection(selectedIndex);
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              } else {
                return TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Text(
                      getScheduleTimeOfDayEmoji(
                          scheduleDetailList.indexOf(scheduleDetail)),
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    labelText: '일정을 입력하세요',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () async {
                        setState(() {
                          isSaving = true; // 저장 요청 중임을 표시
                        });
                        await APIClient.createSchedule(
                          dates[selectedIndex],
                          title,
                          scheduleCurrentIndex,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('저장이 완료되었습니다.'),
                          ),
                        );
                        setState(() {
                          isSaving = false; // 저장 요청 완료 표시
                          handleDateSelection(selectedIndex);
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                );
              }
            }).toList(),
            options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {
                  scheduleCurrentIndex = index;
                  dayIndex = index;
                });
              },
              height: 70,
              enableInfiniteScroll: true,
              initialPage: 0,
              viewportFraction: 0.8,
              enlargeCenterPage: true,
            ),
          ),
          SizedBox(height: 13),

          // 4. 상의 슬라이드
          CarouselSlider(
            items: getSelectedTopList(dayIndex).map((clothesItem) {
              return Container(
                width: 250,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(clothesItem.imgUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  // child: Text(
                  //   'Slide ${clothesItem.id}',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {
                  topCurrentIndex = getSelectedTopList(dayIndex)[index]
                      .id; // 현재 슬라이드에 해당하는 clothesItem.id로 업데이트
                  // 슬라이드 변경 시 원하는 액션 수행
                  // 예: 해당 슬라이드에 맞는 데이터 처리, UI 업데이트 등
                });
              },
              height: 200,
              enableInfiniteScroll: true,
              initialPage: 0,
              viewportFraction: 0.8,
              enlargeCenterPage: true,
            ),
          ),
          SizedBox(height: 40),

          // 5. 하의 슬라이드
          CarouselSlider(
            items: getSelectedBottomList(dayIndex).map((clothesItem) {
              return Container(
                width: 250,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(clothesItem.imgUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  // child: Text(
                  //   'Slide ${clothesItem.id}',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {
                  bottomCurrentIndex = getSelectedBottomList(dayIndex)[index]
                      .id; // 현재 슬라이드에 해당하는 clothesItem.id로 업데이트
                  // 슬라이드 변경 시 원하는 액션 수행
                  // 예: 해당 슬라이드에 맞는 데이터 처리, UI 업데이트 등
                });
              },
              height: 200,
              enableInfiniteScroll: true,
              initialPage: 0,
              viewportFraction: 0.8,
              enlargeCenterPage: true,
            ),
          ),
          SizedBox(height: 40),

          // 6. 저장하기 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (isSaving) {
                    return; // 이미 저장 작업이 진행 중인 경우, 중복 클릭 방지
                  }

                  setState(() {
                    isSaving = true; // 저장 작업 시작 전에 변수를 true로 설정하여 중복 클릭 방지
                  });

                  try {
                    // 저장 작업 실행
                    await APIClient.createChoiceClothes(
                        topCurrentIndex,
                        bottomCurrentIndex,
                        scheduleDetailList[scheduleCurrentIndex]!.id);

                    // 저장 완료 알림 메시지
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('저장되었습니다.'),
                      ),
                    );
                  } catch (e) {
                    print('Error: $e');
                  } finally {
                    setState(() {
                      isSaving =
                          false; // 저장 작업 완료 후 변수를 false로 설정하여 다음 저장 가능하도록 설정
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  '저장하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      // NavBar
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
