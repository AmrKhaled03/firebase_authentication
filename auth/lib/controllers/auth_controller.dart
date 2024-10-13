import 'package:auth/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;


Future<void> signUp() async {
    isLoading = true;
    update();
    try {

      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email.text)) {
        Get.snackbar("Invalid Email", "Please enter a valid email address.");
        return;
      }
      
      UserModel model = UserModel(email: email.text, password: password.text);
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: model.email, password: model.password);
      debugPrint("Registered ${userCredential.user!.email}");
      Get.snackbar(
        "Registration Success!",
        "${userCredential.user!.email}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {

      switch (e.code) {
        case 'email-already-in-use':
          Get.snackbar("Registration Failed", "This email is already in use.", snackPosition: SnackPosition.BOTTOM);
          break;
        case 'invalid-email':
          Get.snackbar("Registration Failed", "The email address is not valid.", snackPosition: SnackPosition.BOTTOM);
          break;
        case 'operation-not-allowed':
          Get.snackbar("Registration Failed", "Email/Password accounts are not enabled.", snackPosition: SnackPosition.BOTTOM);
          break;
        case 'weak-password':
          Get.snackbar("Registration Failed", "The password is too weak.", snackPosition: SnackPosition.BOTTOM);
          break;
        default:
          Get.snackbar("Registration Failed", e.message ?? "An unknown error occurred.", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Registration Failed", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update();
    }
}


  Future<void> login() async {
    isLoading = true;
    update();
    try {
      UserModel model = UserModel(email: email.text, password: password.text);
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: model.email, password: model.password);
      debugPrint("Login  ${userCredential.user!.email}");
      Get.snackbar(
        "Login Success!",
        "${userCredential.user!.email}",
        snackPosition: SnackPosition.BOTTOM,
      );
      await addShared(model.email, model.password);
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar(
        "Login Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> logout() async {
    isLoading = true;
    update();
    try {
      await _auth.signOut();
      debugPrint("User logged out");
      Get.snackbar(
        "Logout Successful",
        "You have been logged out.",
        snackPosition: SnackPosition.BOTTOM,
      );
      await removeShared();

    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar(
        "Logout Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('user_email');
    String? storedPassword = prefs.getString('user_password');

    if (storedEmail != null && storedPassword != null) {
      email.text = storedEmail;
      password.text = storedPassword;

      await login();
    } else {
      debugPrint("No credentials found in SharedPreferences.");
    }
  }

  Future<void> addShared(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    await prefs.setString('user_password', password);
    debugPrint("Data added successfully!");
  }

  Future<void> removeShared() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');   // Remove only the email
  await prefs.remove('user_password'); // Remove only the password
    debugPrint("Email removed from shared preferences");
  }

  Future<void> loadEmailFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    email.text = prefs.getString('user_email') ?? '';
    password.text = prefs.getString('user_password') ?? '';
    debugPrint(
        "Loaded data from shared preferences: ${email.text} ${password.text}");
  }
}
