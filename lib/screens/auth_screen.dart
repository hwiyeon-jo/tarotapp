import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 👈 로컬 저장을 위한 패키지 임포트
import '../widgets/mystic_background.dart';
import 'main_tab_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  bool _isSignUpMode = false; // 현재 화면이 회원가입 모드인지 여부
  bool _isLoading = false;     // 서버 통신 중 로딩 상태 관리

  @override
  void initState() {
    super.initState();
    _checkAutoLogin(); // 👈 앱 시작 시 기기에 저장된 로그인 세션(자동 로그인) 확인
  }

  // 🛠️ 자동 로그인 및 저장된 데이터 확인 함수
  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('saved_username');
    final savedBirthday = prefs.getString('saved_birthday');

    // 이미 로그인 성공 이력이 로컬에 남아있다면 폼을 거치지 않고 바로 메인 화면으로 진입
    if (savedUsername != null && savedBirthday != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainTab(birthday: savedBirthday),
          ),
        );
      }
    }
  }

  // 비동기 로그인 / 회원가입 기능
  Future<void> _submitAuth() async {
    // 1. 유효성 검사를 통과하지 못하면 함수 실행을 즉각 중단 (그냥 넘어가는 현상 원천 차단)
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();
      String birthday = _birthController.text.trim();

      final prefs = await SharedPreferences.getInstance();

      if (_isSignUpMode) {
        // ========================================================
        // [1] 회원가입(Sign Up) 모드 흐름
        // ========================================================
        await Future.delayed(const Duration(milliseconds: 1500)); // 서버 가상 딜레이

        // 로컬 가상 DB 역할로 회원가입 정보 임시 저장
        await prefs.setString('reg_user_$username', password);
        await prefs.setString('reg_birth_$username', birthday);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✨ 아르카나 우주 등록 완료! 이제 로그인을 진행해 주세요.")),
          );
        }

        // 회원가입 성공 후 텍스트 필드를 비우고 로그인 모드로 확실히 전환
        _passwordController.clear();
        setState(() {
          _isSignUpMode = false;
        });

      } else {
        // ========================================================
        // [2] 로그인(Sign In) 모드 흐름
        // ========================================================
        await Future.delayed(const Duration(milliseconds: 1200)); // 서버 가상 딜레이

        // 가상 회원가입 검증 (회원가입 때 저장했던 데이터가 있는지 대조)
        final registeredPassword = prefs.getString('reg_user_$username');
        final registeredBirth = prefs.getString('reg_birth_$username');

        // 가입된 정보가 없거나 비밀번호가 틀린 경우 철저히 차단
        if (registeredPassword == null || registeredPassword != password) {
          throw Exception("아이디 또는 비밀번호가 일치하지 않습니다.");
        }

        // 🛠️ 로그인 성공 시 기기에 아이디와 생년월일 세션 영구 저장 (재실행 시 자동 로그인용)
        await prefs.setString('saved_username', username);
        await prefs.setString('saved_birthday', registeredBirth ?? birthday);

        if (mounted) {
          // 최종 검증 완료된 생년월일을 들고 메인 화면으로 진입
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainTab(birthday: registeredBirth ?? birthday),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFD32F2F),
            content: Text(e.toString().replaceAll("Exception: ", "")),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MysticBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Form(
                key: _formKey, // 👈 검증 및 차단을 위한 필수 키 바인딩
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5C158).withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE5C158).withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.all_inclusive_rounded, color: Color(0xFFFFE082), size: 44),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _isSignUpMode ? "새로운 영혼 등록" : "아르카나 포탈 접속",
                      style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isSignUpMode ? "운명의 지도를 열기 위해 계정을 생성합니다" : "당신의 영혼 각인을 확인하기 위한 여정",
                      style: const TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    const SizedBox(height: 35),

                    // 1. 아이디 입력 필드
                    _buildInputField(
                      controller: _usernameController,
                      hint: "아이디 (4자리 이상)",
                      icon: Icons.person_rounded,
                      validator: (val) => (val == null || val.trim().length < 4) ? "아이디를 4자리 이상 입력해 주세요." : null,
                    ),
                    const SizedBox(height: 14),

                    // 2. 비밀번호 입력 필드
                    _buildInputField(
                      controller: _passwordController,
                      hint: "비밀번호 (6자리 이상)",
                      icon: Icons.lock_rounded,
                      isObscure: true,
                      validator: (val) => (val == null || val.length < 6) ? "비밀번호를 6자리 이상 입력해 주세요." : null,
                    ),
                    const SizedBox(height: 14),

                    // 3. 생년월일 입력 필드
                    _buildInputField(
                      controller: _birthController,
                      hint: "생년월일 8자리 (예: 19950825)",
                      icon: Icons.cake_rounded,
                      keyboardType: TextInputType.number,
                      letterSpacing: 2.0,
                      validator: (val) {
                        if (val == null || val.isEmpty) return "생년월일을 입력해 주세요.";
                        if (val.length != 8 || int.tryParse(val) == null) return "정확한 숫자 8자리여야 합니다.";
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // 4. 메인 제출 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE5C158),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 4,
                        ),
                        onPressed: _isLoading ? null : _submitAuth, // 👈 중복 클릭 및 예외 무시 전면 방지
                        child: _isLoading
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5))
                            : Text(_isSignUpMode ? "회원가입 및 우주 동기화" : "아르카나 로그인", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 5. 모드 스위칭 버튼
                    TextButton(
                      onPressed: _isLoading ? null : () {
                        _formKey.currentState?.reset(); // 모드 전환 시 이전 에러 표시 초기화
                        setState(() {
                          _isSignUpMode = !_isSignUpMode;
                        });
                      },
                      child: Text(
                        _isSignUpMode ? "이미 운명의 계정이 있으신가요? 로그인하기" : "아직 계정이 없으신가요? 회원가입하기",
                        style: const TextStyle(color: Color(0xFFFFE082), fontSize: 13, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isObscure = false,
    TextInputType keyboardType = TextInputType.text,
    double letterSpacing = 0.0,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF290B4E).withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5C158).withOpacity(0.4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: keyboardType,
        enabled: !_isLoading,
        style: TextStyle(color: Colors.white, fontSize: 15, letterSpacing: letterSpacing),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white30, fontSize: 14, letterSpacing: 0.0),
          border: InputBorder.none,
          icon: Icon(icon, color: const Color(0xFFFFE082), size: 20),
        ),
        validator: validator,
      ),
    );
  }
}