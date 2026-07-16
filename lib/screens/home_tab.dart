import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/mystic_background.dart';
import 'auth_screen.dart';

class HomeTab extends StatelessWidget {
  final String username;
  final String birthday;
  final VoidCallback onNavigateToDraw;

  const HomeTab({
    Key? key,
    required this.username,
    required this.birthday,
    required this.onNavigateToDraw,
  }) : super(key: key);

  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_username');
    await prefs.remove('saved_birthday');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🌌 아르카나 포탈과의 동기화가 해제되었습니다.")),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int luckyScore = 85;
    if (birthday.isNotEmpty) {
      int sum = birthday.codeUnits.fold(0, (prev, element) => prev + element);
      luckyScore = 80 + (sum % 21);
    }

    return MysticBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "신비로운 우주의 흐름",
                        style: TextStyle(color: Colors.white60, fontSize: 14, letterSpacing: 1.0),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$username 님의 아르카나",
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, color: Color(0xFFFFE082), size: 24),
                    tooltip: '포탈 로그아웃',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF220A3E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: Color(0xFFE5C158), width: 1),
                          ),
                          title: const Text("포탈 탈출", style: TextStyle(color: Color(0xFFFFE082), fontWeight: FontWeight.bold)),
                          content: const Text("우주 주파수 동기화를 해제하고 로그아웃하시겠습니까?", style: TextStyle(color: Colors.white70)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("취소", style: TextStyle(color: Colors.white38)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _handleLogout(context);
                              },
                              child: const Text("로그아웃", style: TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5C158).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5C158).withOpacity(0.5), width: 1),
                ),
                child: Text(
                  "오늘의 영혼 싱크율 $luckyScore%",
                  style: const TextStyle(color: Color(0xFFFFE082), fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),

              const SizedBox(height: 25),

              // 🛠️ 복구된 카드 고정 디자인 영역
              Center(
                child: Container(
                  width: double.infinity,
                  height: 340,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF290B4E).withOpacity(0.4),
                        const Color(0xFF110226).withOpacity(0.7),
                      ],
                    ),
                    border: Border.all(color: const Color(0xFFE5C158).withOpacity(0.4), width: 1.5),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF6A1B9A).withOpacity(0.2), blurRadius: 30, spreadRadius: 5),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Icon(Icons.brightness_3, size: 120, color: Colors.white.withOpacity(0.03)),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 130,
                            height: 210,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.25), blurRadius: 20, spreadRadius: 2)
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                'assets/images/card_back_design.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            "오늘 당신을 기다리는 운명의 카드가 있습니다",
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "하단의 메뉴나 바로가기를 눌러 오픈하세요",
                            style: TextStyle(color: Colors.white38, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: onNavigateToDraw,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3D0C73), Color(0xFF1A0533)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE5C158), width: 1.2),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5C158).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_awesome, color: Color(0xFFFFE082), size: 26),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "오늘의 운세 & 소울카드 확인",
                              style: TextStyle(color: Color(0xFFFFE082), fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "우주의 주파수 동기화 및 타로 셔플하기",
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Color(0xFFE5C158), size: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.wb_twighlight, color: Colors.amber, size: 16),
                        SizedBox(width: 6),
                        Text("오늘의 연금술 가이드", style: TextStyle(color: Color(0xFFFFE082), fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "\"외부의 소음이 커질 때일수록 내면의 침묵 속으로 들어가 등불을 켜십시오. 오늘 일어나는 모든 인연의 파동은 당신이 도약하기 위한 필연적 궤도 위에 있습니다.\"",
                      style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}