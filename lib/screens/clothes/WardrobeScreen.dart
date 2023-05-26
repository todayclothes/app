import 'package:flutter/material.dart';
import 'package:today_clothes/api/ApiClient.dart';
import 'package:today_clothes/models/ClothesChoice.dart';
import 'package:today_clothes/screens/main/HomeScreen.dart';
import 'package:today_clothes/screens/user/info/MyPageScreen.dart';

class WardrobeScreen extends StatefulWidget {
  @override
  _WardrobeScreenState createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  int _selectedTabIndex = 0;
  List<List<ClothesChoice>> _tabItems = [];

  @override
  void initState() {
    _tabItems = [
      [], // Tab 0 - My Clothes
      [], // Tab 1 - Other People's Clothes
      [], // Tab 2 - Liked Clothes
    ];
    _fetchClothesChoices();
    super.initState();
  }

  Future<void> _fetchClothesChoices() async {
    try {
      List<ClothesChoice> newChoices = [];

      if (_selectedTabIndex == 1) {
        final jsonData = await APIClient.getClothesOtherChoices(
          size: 20,
          lastClothesChoiceId: _tabItems[1].isNotEmpty ? _tabItems[1].last.id : 0,
        );

        newChoices = (jsonData['content'] as List)
            .map((data) => ClothesChoice.fromJson(data))
            .toList();
      } else if (_selectedTabIndex == 2) {
        // Fetch liked clothes
        // Add your code here to fetch liked clothes choices
      } else {
        final jsonData = await APIClient.getClothesMyChoices(
          size: 20,
          lastClothesChoiceId: _tabItems[0].isNotEmpty ? _tabItems[0].last.id : 0,
        );

        newChoices = (jsonData['content'] as List)
            .map((data) => ClothesChoice.fromJson(data))
            .toList();
      }

      setState(() {
        _tabItems[_selectedTabIndex] = newChoices; // 선택한 탭에 대한 데이터 업데이트
      });
    } catch (e) {
      print('Failed to fetch clothes choices: $e');
    }
  }



  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index; // _selectedTabIndex 업데이트
    });
    _fetchClothesChoices(); // 탭 변경 시 새로운 데이터 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 70),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '   옷장 ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 28,
              ),
            ),
          ),
          SizedBox(height: 15),

          _buildTabBar(),
          Expanded(
            child: ListView.builder(
              itemCount: _tabItems[_selectedTabIndex].length,
              itemBuilder: (context, index) {
                ClothesChoice clothing = _tabItems[_selectedTabIndex][index];
                return _buildClothingItem(clothing);
              },
            ),
          ),
        ],
      ),

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

  Widget _buildTabBar() {
    return Container(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabItems.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => _onTabChanged(index), // 탭 클릭 시 _onTabChanged 호출
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              color:
              index == _selectedTabIndex ? Colors.blue : Colors.transparent,
              child: Center(
                child: Text(
                  _getTabTitle(index),
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getTabTitle(int index) {
    switch (index) {
      case 0:
        return '내 옷장';
      case 1:
        return '다른 사람의 옷장';
      case 2:
        return '좋아요 누른 옷';
      default:
        return '';
    }
  }

  Widget _buildClothingItem(ClothesChoice clothing) {
    return ListTile(
      leading: GestureDetector(
        child: Image.network(
          clothing.topChoice.imgUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(clothing.plan),
      subtitle: Text('Temperature: ${clothing.tempAvg.toStringAsFixed(1)}°C'),
      trailing: IconButton(
        icon: Icon(
          clothing.isLiked ? Icons.favorite : Icons.favorite_border,
          color: clothing.isLiked ? Colors.red : null,
        ),
        onPressed: () {
          setState(() {
            clothing.isLiked = !clothing.isLiked;
          });
          // Add your code here to handle the like functionality
        },
      ),
      onTap: () {
        _showImageDialog(clothing.topChoice.imgUrl, clothing.bottomChoice.imgUrl);
      },
    );
  }



  void _showImageDialog(String topImageUrl, String bottomImageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(topImageUrl),
                SizedBox(height: 16),
                Image.network(bottomImageUrl),
              ],
            ),
          ),
        );
      },
    );
  }



}
