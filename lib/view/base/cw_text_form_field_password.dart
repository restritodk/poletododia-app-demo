// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CwTextFormFieldPassword extends StatefulWidget {
  final String labelText;
  final double width;
  final TextEditingController? controller;

  const CwTextFormFieldPassword({
    Key? key,
    required this.labelText,
    this.width = 300,
    this.controller,
  }) : super(key: key);

  @override
  State<CwTextFormFieldPassword> createState() =>
      _CwTextFormFieldPasswordState();
}

class _CwTextFormFieldPasswordState extends State<CwTextFormFieldPassword> {
  bool obscureText = false;

  void obscuresText() {
    if (obscureText) {
      obscureText = false;
    } else {
      obscureText = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextFormField(
        controller: widget.controller,
        cursorColor: Colors.black,
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(obscureText
                    ? Icons.lock_outlined
                    : Icons.remove_red_eye_outlined
                //color: Colors.black,
                ),
            onPressed: () {
              setState(() {
                if (obscureText) {
                  obscureText = false;
                } else {
                  obscureText = true;
                }
              });
            },
          ),
          labelText: widget.labelText,
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
