import 'package:flutter/material.dart';

final List<String> podcastList = [
  'joerogan',
  'the daily',
  'chawg',
  '1619',
  'Ted Radio Hour'
];

List<BoxShadow> neumDarkShadow({double blurRadius: 8, double offset: 4.0}) {
  return [
    BoxShadow(
      color: const Color(0xFF1e1e1e),
      offset: Offset(offset, offset),
      blurRadius: blurRadius,
    ),
    BoxShadow(
      color: const Color(0xFF444444),
      offset: Offset(-offset, -offset),
      blurRadius: blurRadius,
    )
  ];
}

LinearGradient neumStandardGradient() {
  return LinearGradient(
      colors: [
        const Color(0xFF3c3c3c),
        const Color(0xFF323232),
      ],
      tileMode: TileMode.clamp,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
}
