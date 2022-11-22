import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zeus/utility/constants.dart';

class Validation {
  static bool emailValidation(String value) {
    final validEmail =
        RegExp(r'\S+@\S+\.\S+'); //RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$");
    return validEmail.hasMatch(value);
  }

  static String? emailValidate(String value) {
    if (value.isNotEmpty) {
      if (Validation.emailValidation(value.trim())) {
        return null;
      } else {
        return Constants.invalidEmail;
      }
    } else {
      return Constants.enterEmail;
    }
  }
}
