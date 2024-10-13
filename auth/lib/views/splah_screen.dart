import 'package:auth/constants/app_strings.dart';
import 'package:auth/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplahScreen extends GetWidget<SplashController> {
  const SplahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                AppStrings.appTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        )),
      ),
    ));
  }
}
