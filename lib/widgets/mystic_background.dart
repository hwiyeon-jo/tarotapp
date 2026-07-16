import 'package:flutter/material.dart';

class MysticBackground extends StatelessWidget {
  final Widget child;
  const MysticBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF07020D),
        image: DecorationImage(
          image: AssetImage('assets/images/bg_input_info.png'), // 배경 이미지 명확한 경로 매칭
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}