import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Screenbackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _buildSignUpForm(textTheme),
        ),
      ),
    );
  }

  Widget _buildSignUpForm(TextTheme textTheme) => _buildSignInForm(textTheme);

  Widget _buildSignInForm(TextTheme textTheme) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 100),
          Text(
            'Join With Us',
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
          const SizedBox(height: 8),
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(hintText: 'First Name'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(hintText: 'Last Name'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: 'Mobile Number'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Mobile number';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(hintText: 'Password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onTapNextButton,
            child: const Icon(Icons.arrow_forward_ios),
          ),

          const SizedBox(height: 20),
          _buildHaveAccountSection(),
        ],
      ),
    );
  }

  Widget _buildHaveAccountSection() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        text: " Have an account? ",
        children: [
          TextSpan(
            text: 'Sign in',
            style: TextStyle(color: AppColors.themeColor),
            recognizer: TapGestureRecognizer()..onTap = _onTapSignIn,
          ),
        ],
      ),
    );
  }

  void _onTapNextButton() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Succesfully  sign up')));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = 'Faild to sign up';
      if (e.code == 'email-already-in-use') {
        message = 'This email are already used';
      } else if (e.code == 'weak-password') {
        message = 'weak password';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _onTapSignIn() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
