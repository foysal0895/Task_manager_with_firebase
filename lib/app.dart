import 'package:flutter/material.dart';
import 'package:untitled1/ui/screen/splash_screen.dart';
import 'package:untitled1/ui/utils/app_colors.dart';



class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        textTheme: const TextTheme(),
        inputDecorationTheme: _inputDecorationTheme(),
        elevatedButtonTheme: _elevatedButtonThemeData(),
      ),

      home: const SplashScreen(),
    );
  }
    ElevatedButtonThemeData _elevatedButtonThemeData(){
      return ElevatedButtonThemeData( style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.themeColor,
                  foregroundColor: Colors.white,
                  fixedSize: const Size.fromWidth(double.maxFinite),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                );
}
  InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
     fillColor: Colors.white,
      filled: true,
      hintStyle: const TextStyle(fontWeight: FontWeight.w300),
      border: _inputBorder(),
      focusedBorder: _inputBorder(),
      enabledBorder: _inputBorder(),
      errorBorder: _inputBorder(),
      focusedErrorBorder: _inputBorder(),
    );
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide.none,
    );
  }
}
