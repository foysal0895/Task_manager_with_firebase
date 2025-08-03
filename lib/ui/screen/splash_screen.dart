import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../utils/assets_path.dart';
import '../widgets/screen_background.dart';
import 'sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screenbackground(
        child: Center(child: SvgPicture.asset(AssetsPath.logosvg, width: 150)),
      ),
    );
  }
}
