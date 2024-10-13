import 'package:auth/controllers/auth_controller.dart';

import 'package:auth/controllers/splash_controller.dart';
import 'package:get/instance_manager.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => SplashController(), fenix: true);



  }
}
