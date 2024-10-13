import 'package:auth/constants/app_strings.dart';
import 'package:auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 3), () async {
      await authController.autoLogin();

      if (authController.email.text.isNotEmpty &&
          authController.password.text.isNotEmpty) {
        Get.offNamed(AppStrings.homeRoute);
      } else {
        Get.offNamed(AppStrings.registerRoute);
      }
    });
  }
}
