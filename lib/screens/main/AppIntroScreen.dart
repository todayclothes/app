import 'package:flutter/material.dart';
import 'package:today_clothes/screens/user/auth/LoginScreen.dart';

class AppIntroScreen extends StatefulWidget {
  @override
  _AppIntroScreenState createState() => _AppIntroScreenState();
}

class _AppIntroScreenState extends State<AppIntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Widget> _pages = [
    IntroPage(
      title: '오늘 뭐입지?',
      description: '매일 옷을 고르는데 머리가 아프지 않나요?\n저희가 도와드릴게요!',
      emoji: '🤔',
    ),
    IntroPage(
      title: '이날 뭐입지?',
      description: '일정을 기록하고 옷 추천을 받아보세요!',
      emoji: '📅',
    ),
    IntroPage(
      title: '다른 사람들은 뭐입지?',
      description: '다른 사용자들의 스타일을 참고해 보세요!',
      emoji: '👗',
      isLastPage: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: _pages,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
            SizedBox(height: 16),
            if (_currentPage == _pages.length - 1) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('시작하기'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];

    for (int i = 0; i < _pages.length; i++) {
      indicators.add(
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: 8,
          width: (i == _currentPage) ? 24 : 8,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: (i == _currentPage) ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }

    return indicators;
  }
}

class IntroPage extends StatelessWidget {
  final String title;
  final String description;
  final String emoji;
  final bool isLastPage;

  IntroPage({
    required this.title,
    required this.description,
    required this.emoji,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 24),
        Text(
          emoji,
          style: TextStyle(
            fontSize: 40,
          ),
        ),
      ],
    );
  }
}
