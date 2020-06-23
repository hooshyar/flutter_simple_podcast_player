import 'package:Simple_Podcast_Player/src/podcast_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.grey[900],
      title: 'Simple Flutter podcast',
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.grey[800],
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PodcastPage(),
    );
  }
}
