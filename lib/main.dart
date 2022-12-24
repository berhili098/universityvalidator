import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:universityvalidator/controllers/auth_controller.dart';
import 'package:universityvalidator/screens/signin.dart';
import 'package:universityvalidator/utils/constants.dart';
import 'package:universityvalidator/utils/initPage.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Widget? main;
  await initWidget().then((value) {
    main = value;
  
  });
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'MYI validator',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: main,
  ));
}
