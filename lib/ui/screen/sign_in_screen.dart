import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';
import 'forgot_password_email.dart';
import 'main_bottom_nav_bar_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Screenbackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _buildSignInForm(textTheme),
        ),
      ),
    );
  }

  Widget _buildSignInForm(TextTheme textTheme) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          const SizedBox(height: 100),
          Text(
            'Get Start With',
            style: textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter email';
              }
              if (!value.contains('@')) {
                return 'enter valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(hintText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please Enter password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _onTapNextButton(); // <-- call the method here
            },
            child: const Icon(Icons.arrow_forward_ios),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _onTapForgotPasswordButton, // <-- call the method here
            child: const Text('Forgot Password?'),
          ),
          const SizedBox(height: 20),
          _buildSignUpSection(),
        ],
      ),
    );
  }

  Widget _buildSignUpSection() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        text: "Don't have an account? ",
        children: [
          TextSpan(
            text: 'Sign Up',
            style: TextStyle(color: AppColors.themeColor),
            recognizer: TapGestureRecognizer()..onTap = _onTapSignUp,
          ),
        ],
      ),
    );
  }

  void _onTapForgotPasswordButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmailScreen()),
    );
  }

  void _onTapNextButton() async {
    if (_formkey.currentState?.validate() != true) {
      return;
    }
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainBottomNavBarScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Login faild';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _onTapSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
