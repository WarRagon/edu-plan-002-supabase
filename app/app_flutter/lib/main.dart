import 'package:app_flutter/config.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPasswordCheckVisible = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> signupRequest() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordCheckController.text.isEmpty) {
      _showSnackBar("이메일, 패스워드, 패스워드확인란을 입력해주세요.");
      return;
    }

    if (_passwordController.text != _passwordCheckController.text) {
      _showSnackBar("패스워드가 일치하지 않습니다.");
      return;
    }

    if (_passwordController.text.length < 6) {
      _showSnackBar("패스워드는 6자리 이상이어야 합니다.");
      return;
    }

    if (!EmailValidator.validate(_emailController.text)) {
      _showSnackBar("이메일형식으로 입력해주세요.");
      return;
    }

    try {
      final response = await supabase.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );
      _showSnackBar("${response.user!.email} 회원가입에 성공하였습니다.");
    } catch (e) {
      debugPrint("$e");
      _showSnackBar("오류 발생: $e");
    }
  }

  Future<void> signinRequest() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar("이메일, 패스워드를 입력해주세요.");
      return;
    }

    if (_passwordController.text.length < 6) {
      _showSnackBar("패스워드는 6자리 이상이어야 합니다.");
      return;
    }

    if (!EmailValidator.validate(_emailController.text)) {
      _showSnackBar("이메일형식으로 입력해주세요.");
      return;
    }

    try {
      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      _showSnackBar("${response.user!.email} 로그인에 성공하였습니다.");
    } catch (e) {
      debugPrint("$e");
      _showSnackBar("오류 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("이메일"),
            TextField(
              controller: _emailController,
            ),
            const Text("패스워드"),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const Text("패스워드확인"),
            TextField(
              controller: _passwordCheckController,
              obscureText: !_isPasswordCheckVisible,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordCheckVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordCheckVisible = !_isPasswordCheckVisible;
                    });
                  },
                ),
              ),
            ),
            TextButton(
              onPressed: signupRequest,
              child: const Text("회원가입"),
            ),
            TextButton(
              onPressed: signinRequest,
              child: const Text("로그인"),
            ),
          ],
        ),
      ),
    );
  }
}
