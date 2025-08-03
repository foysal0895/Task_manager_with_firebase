import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/ui/screen/pin_verification_screen.dart';

import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _phoneController = TextEditingController(); // Removed @override
  final _formkey = GlobalKey<FormState>();

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
    return Form(
      key: _formkey,
      child: Column(
        children: [
          const SizedBox(height: 100),
          Text(
            'Your phone Number',
            style: textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'A 6 digit code will be sent to your Number',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w100),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: 'Number'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter number';
              }
              return null; // Fix: ensure a return value
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
        text: " Have account? ",
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
    if (_formkey.currentState?.validate() != true) return;

    String phoneNumber = _phoneController.text.trim();
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+88$phoneNumber'; // Assumes BD country code
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Success (auto verified)')),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ভেরিফিকেশন ব্যর্থ: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PinVerificationScreen(
              verificationId: verificationId, // ✅ only this is needed
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void _onTapSignIn() {
    Navigator.pop(context);
  }
}
