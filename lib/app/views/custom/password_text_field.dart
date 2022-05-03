
import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final String title;
  final TextEditingController passwordController;

  const PasswordTextField({Key? key, required this.title, required this.passwordController})
      : super(key: key);

  @override
  State<PasswordTextField> createState() =>
      _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        controller: widget.passwordController,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: widget.title,
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
          ),
        ),
      ),
    );
  }
}