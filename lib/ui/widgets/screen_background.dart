import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/assets_path.dart';


class Screenbackground extends StatelessWidget {
  const Screenbackground({super.key, required this.child});
 final Widget  child ;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: SvgPicture.asset(AssetsPath.backgroundsvg, fit: BoxFit.cover),
        ),
      SafeArea(child: child),
      ],
    );
  }
}
