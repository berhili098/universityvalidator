import 'dart:convert';
import 'dart:developer';
 
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:universityvalidator/screens/home.dart'; 
import 'package:get/get.dart';
import 'package:universityvalidator/utils/constants.dart';

import '../styles/app_colors.dart';

class AuthController extends GetxController {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isObscure=true.obs;
  RxBool isLoading=false.obs;


  static AuthController instance = Get.find();
 

  @override
  void onInit() {
    super.onInit();

   
  }

  // _setInitialScreen() {
    


  // }

  // void register(String email, password) async {
   
  // }

  void login(  context) async {
 
    if(emailController.text == '' || passwordController.text == ''){
       showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Erreur",style: TextStyle(color: Colors.red, fontSize: 23, fontWeight: FontWeight.w500)),
          content: Text("Remplir tous les champs"),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text("OK"))
          ],
        );
      }); 
    }else{

if(!EmailValidator.validate(emailController.text.trim())){
     showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Erreur",style: TextStyle(color: Colors.red, fontSize: 23, fontWeight: FontWeight.w500)),
          content: Text("Email invalide"),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text("OK"))
          ],
        );
      }); 
}else{
  
       isLoading.toggle();
       update();
        var response = await http.post(Uri.parse(link+"login"), headers:{
        "accept":"application/json"
      }, body:{
        "email":emailController.text.trim(),
        "password":passwordController.text
      });
      if(response.statusCode == 200){
        await GetStorage().write('token', jsonDecode(response.body)['token']);
         isLoading.toggle();
          update();
          await GetStorage().write('isLogged', true);
       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyHome(),),(Route<dynamic> route) => false);
          
      }
      else{
         isLoading.toggle();
       update(); 
          showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Erreur",style: TextStyle(color: Colors.red, fontSize: 23, fontWeight: FontWeight.w500)),
          content: Text("Email ou mot de passe invalide"),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text("OK"))
          ],
        );
      }); 
      }
}

    }
    } 
  


}
