import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webeasy/pages/mainpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.camera.request();
  await Permission.microphone.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Webeasy',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MainController(
        title: 'Webeasy',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
