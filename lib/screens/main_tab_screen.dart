import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 👈 아이디를 꺼내오기 위해 패키지 임포트
import 'home_tab.dart';
import 'draw_tab.dart';
import 'dictionary_tab.dart';

class MainTab extends StatefulWidget {
  final String birthday;

  const MainTab({Key? key, required this.birthday}) : super(key: key);

  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  int _selectedIndex = 0; // 현재 선택된 탭 인덱스
  String _username = "여행자"; // 👈 아이디를 담을 변수 (기본값 세팅)

  @override
  void initState() {
    super.initState();
    _loadUsername(); // 👈 화면이 켜질 때 로컬에 저장된 아이디를 불러옵니다.
  }

  // 🛠️ SharedPreferences에서 저장된 아이디를 가져오는 함수
  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // AuthScreen에서 로그인 성공 시 저장했던 'saved_username' 키값을 꺼내옵니다.
      _username = prefs.getString('saved_username') ?? "여행자";
    });
  }

  // 탭을 전환하는 함수
  void _navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 탭별로 보여줄 화면 리스트
    final List<Widget> _screens = [
      // 1. 홈 탭: 생년월일 외에 불러온 'username'을 함께 넘겨줍니다.
      HomeTab(
        username: _username, // 👈 추가된 아이디 데이터 전달
        birthday: widget.birthday,
        onNavigateToDraw: () => _navigateToTab(1), // 인덱스 1번(DrawTab)으로 이동하도록 설정
      ),
      // 2. 카드 뽑기 탭
      DrawTab(
        birthday: widget.birthday,
      ),
      // 3. 도감 탭
      const DictionaryTab(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens, // 탭 전환 시 기존 화면 상태 유지를 위해 IndexedStack 사용
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateToTab,
        backgroundColor: const Color(0xFF110226), // 앱 테마와 어울리는 깊은 밤하늘색
        selectedItemColor: const Color(0xFFE5C158), // 선택된 탭: 골드
        unselectedItemColor: Colors.white38, // 선택되지 않은 탭: 흐린 화이트
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        type: BottomNavigationBarType.fixed, // 탭 고정
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: '카드 뽑기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: '영혼 도감',
          ),
        ],
      ),
    );
  }
}