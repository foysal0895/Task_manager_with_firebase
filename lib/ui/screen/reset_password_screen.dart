import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/ui/screen/sign_in_screen.dart';

import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController(); // ✅ Removed @override
  final TextEditingController _confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Screenbackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _resetPasswordForm(Theme.of(context).textTheme),
        ),
      ),
    );
  }

  Widget _resetPasswordForm(TextTheme textTheme) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 100),
          Text(
            'Set New Password',
            style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Minimum 8 characters, at least one uppercase letter,\n'
            'one lowercase letter, one number and one special character.',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w100),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: _passwordController,
            obscureText: true, // ✅ Hide password
            decoration: const InputDecoration(hintText: 'Password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter password';
              }
             
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _confirmPassController,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Confirm Password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirm your password';
              } else if (value != _passwordController.text) {
                return 'Passwords do not match';
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
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        text: "Have an account? ",
        children: [
          TextSpan(
            text: 'Sign In',
            style: const TextStyle(color: AppColors.themeColor),
            recognizer: TapGestureRecognizer()..onTap = _onTapSignIn,
          ),
        ],
      ),
    );
  }

  void _onTapNextButton() async {
    if (_formKey.currentState?.validate() != true) return;

    try {
      await FirebaseAuth.instance.currentUser
          ?.updatePassword(_passwordController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update password: ${e.message}')),
      );
    }
  }

  void _onTapSignIn() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }
}
