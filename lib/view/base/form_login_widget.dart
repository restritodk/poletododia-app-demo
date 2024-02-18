// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import 'cw_text_form_field_password.dart';
import 'cw_text_form_fild.dart';

class FormLoginWidget extends StatelessWidget {
  final AuthController controller;
  const FormLoginWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: CwTextFormField(
                  labelText: 'Email', controller: controller.emailController),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: CwTextFormFieldPassword(
                  labelText: 'Senha',
                  controller: controller.passwordController),
            ),
          ),
        ],
      ),
    );
  }
}
