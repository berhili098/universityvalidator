import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:universityvalidator/screens/home.dart';

import '../screens/signin.dart';

Future<Widget> initWidget() async{
  final isLogged = await GetStorage().read('isLogged');
  if(isLogged == null || isLogged == false){
    return Signin();
  }else{
    return MyHome();
  }}