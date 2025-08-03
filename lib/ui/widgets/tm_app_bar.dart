import 'package:flutter/material.dart';

import '../screen/profile_screen.dart';
import '../screen/sign_in_screen.dart';
import '../utils/app_colors.dart';


class TM_Appbar extends StatelessWidget implements PreferredSizeWidget {
  const TM_Appbar({super.key, this.isProfileScreenOpen = false});
  final bool isProfileScreenOpen;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isProfileScreenOpen) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Foysal Islam Didar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'mdfoysalislam0895@gmail.com',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (route) => false,
                );
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
