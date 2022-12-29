import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ThemeHelper {

  final Color _errorColor = HexColor('#FF7A7A');

  InputDecoration textInputDecoration({String lableText = "", String hintText = "", Color labelColor = Colors.white, Color borderColor = Colors.white, Color hintColor = Colors.grey,}) {
    return InputDecoration(

      labelText: lableText,
      hintText: hintText,
      labelStyle: TextStyle(color: labelColor),
      hintStyle: const TextStyle(color: Colors.grey),
      errorStyle: TextStyle(color: _errorColor),
      fillColor: Colors.transparent,
      focusColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(color: borderColor)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(color: borderColor==Colors.grey ? Colors.grey.shade400 : borderColor)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(color: _errorColor, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(color: _errorColor, width: 2.0)),
    );
  }

  BoxDecoration inputBoxDecorationShaddow() {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 5),
        )
      ]
    );
  }

  BoxDecoration customButtonContainerShadow() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(0, 5),
          )
        ]
    );
  }

}