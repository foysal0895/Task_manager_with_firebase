import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:untitled1/ui/screen/reset_password_screen.dart';
import 'package:untitled1/ui/screen/sign_in_screen.dart';

import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';

class PinVerificationScreen extends StatefulWidget {
  final String verificationId; // Fix: Store verificationId

  const PinVerificationScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _otpController = TextEditingController(); // Removed @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Screenbackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _buildEmailInputForm(Theme.of(context).textTheme),
        ),
      ),
    );
  }

  Widget _buildEmailInputForm(TextTheme textTheme) {
    return Column(
      children: [
        const SizedBox(height: 100),
        Text(
          'Pin Verification',
          style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'A 6 digit pin has been sent to your email address',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w100),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        PinCodeTextField(
          controller: _otpController,
          length: 6,
          obscureText: false,
          animationType: AnimationType.fade,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
            inactiveFillColor: Colors.white,
            selectedFillColor: Colors.white,
          ),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          enableActiveFill: true,
          appContext: context,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _onTapNextButton,
          child: const Icon(Icons.arrow_forward_ios),
        ),
        const SizedBox(height: 20),
        _buildHaveAccountSection(),
      ],
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
    String smsCode = _otpController.text.trim();

    if (smsCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your 6 digit OTP')),
      );
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wrong code. Login failed: ${e.message}')),
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
