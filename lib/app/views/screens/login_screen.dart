import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/login_controller.dart';
import '../custom/password_text_field.dart';

class LoginScreen extends GetView<LoginController> {
  LoginScreen({Key? key}) : super(key: key);

  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Obx(
                  () => controller.loading
                  ? const Center(child: CircularProgressIndicator())
                  : _loginScreen(false, 300, 300, 300, context),
            );
          } else {
            return Obx(
                    () => controller.loading
                    ? const Center(child: CircularProgressIndicator())
                    : _loginScreen(false, 300, 300, 300, context),
            );
          }
        },
      ),
    );
  }

  Widget _loginScreen(
    bool mobile,
    double userTextFieldWidth,
    double passwordTextFieldWidth,
    double buttonWidth,
    BuildContext context,
  ) {
    final snackBar = SnackBar(
      content: Text(controller.errorMsg),
    );
    Future.delayed(Duration.zero, () {
      if(controller.error) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*ColorFiltered(
                  colorFilter:
                  ColorFilter.mode((Colors.grey[400])!, BlendMode.modulate),
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/mural_epcc.png'),
                          fit: BoxFit.cover,
                        )),
                    height: mobile ? 280 : 320,
                  ),
                ),*/
                SizedBox(
                    width: userTextFieldWidth,
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'email'.tr),
                      style: GoogleFonts.montserrat(fontSize: 16.0),
                    )),
                const SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  width: passwordTextFieldWidth,
                  child: PasswordTextField(
                    title: 'password'.tr,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                SizedBox(
                    width: buttonWidth,
                    height: 45,
                    child: ElevatedButton(
                        child: Text('login'.tr),
                        onPressed: () {
                          controller.login("username", "password");
                        })),
                const SizedBox(
                  height: 20.0,
                ),
                TextButton(
                    onPressed: () {
                      //Get.toNamed(Routes.recoverPassword);
                    },
                    child: Text('forgottenPassword'.tr)),
                const SizedBox(
                  height: 20.0,
                ),
                TextButton(
                    onPressed: () {
                      //Get.toNamed(Routes.recoverPassword);
                    },
                    child: Text('register'.tr)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
