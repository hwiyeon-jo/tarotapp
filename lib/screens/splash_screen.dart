import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/mystic_background.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 은은하게 이미지가 나타나는 페이드인 애니메이션 설정 (1.5초)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    // 3초 후 인증 화면(AuthScreen)으로 자동 전환
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MysticBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent, // 배경 위에 이미지가 자연스럽게 얹어지도록 투명 설정
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SizedBox.expand(
            // 💡 SizedBox.expand를 통해 기기 크기와 상관없이 가로/세로 전체 사이즈로 확장합니다.
            child: Image.asset(
              'assets/images/img.png',
              fit: BoxFit.cover,
              // 💡 BoxFit.cover 설정을 통해 이미지가 비율을 유지하면서 화면 전체(Full Screen)를 여백 없이 가득 채웁니다.
              alignment: Alignment.center, // 이미지가 화면 정중앙을 기준으로 확대/배치되도록 함
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF110226),
                  child: const Center(
                    child: Icon(
                      Icons.all_inclusive_rounded,
                      color: Color(0xFFE5C158),
                      size: 80,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}