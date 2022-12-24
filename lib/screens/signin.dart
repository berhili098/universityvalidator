import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:universityvalidator/styles/app_colors.dart'; 
import 'package:universityvalidator/widgets/custom_button.dart';
import 'package:universityvalidator/widgets/custom_formfield.dart';
import 'package:universityvalidator/widgets/custom_header.dart';
import 'package:universityvalidator/widgets/custom_richtext.dart';

import '../controllers/auth_controller.dart';

class Signin extends StatelessWidget {
    Signin({Key? key}) : super(key: key);


 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GetBuilder<AuthController>(
        init: AuthController(),
            builder: (controller) {
              return LoadingOverlay(
                isLoading: controller.isLoading.value,
                child: Stack(
                      children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.blue,
                ),
                CustomHeader(
                  text: 'Se Connecter',
                  onTap: () {
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => const SignUp()));
                  },
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.08,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: AppColors.whiteshade,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.09),
                          child: Image.asset("assets/images/login.png"),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        CustomFormField(
                          headingText: "Email",
                          hintText: "Email",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          controller: controller.emailController,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          headingText: "Mot de passe",
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          hintText: "At least 8 Character",
                          obsecureText: controller.isObscure.value,
                          suffixIcon: IconButton(
                              icon: Icon(!controller.isObscure.value ? Icons.visibility_off : Icons.visibility), onPressed: () {
                                  controller.isObscure.toggle();
              controller.update();
                              

                              }),
                          controller: controller.passwordController,
                        ),
                       
                        const SizedBox(
                          height: 16,
                        ),

                        AuthButton(
                          onTap: () {
                            
                           controller.login(context);            
                          },
                          text: 'Connexion',
                        ),
                       
                      ],
                    ),
                  ),
                ),
                      ],
                    ),
              );
            }
          )),
    );
  }
}
