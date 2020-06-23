import 'package:flutter/material.dart';

import '../../config.dart';

Widget circleBtnDark({onPressed, IconData icon, double iconSize}) {
  return Container(
    height: 120,
    width: 120,
    decoration: BoxDecoration(
//                  gradient: neumStandardGradient(),
      color: Colors.grey[850],
      shape: BoxShape.circle,
      boxShadow: neumDarkShadow(),
    ),
    child: FlatButton(
        shape: CircleBorder(),
        splashColor: Colors.black26,
        highlightColor: Colors.black12,
        focusColor: Colors.black87,
        child: Icon(
          icon,
          size: iconSize,
        ),
        onPressed: onPressed),
  );
}
