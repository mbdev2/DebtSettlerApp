import 'dart:io';
import 'package:debtsettler_v4/LandingPages/Models/RegistrationData_model.dart';
import 'package:debtsettler_v4/Storage/StorageItem_model.dart';
import 'package:debtsettler_v4/Storage/Storage_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async' show Future;
import 'package:debtsettler_v4/constants.dart' as Constants;

// INICIALZIZACIJA SAFE STORAGE-a
final storage = StorageService();

// API KLIC ZA PRIJAVO UPORABNIKA:
Future<bool> registrirajUporabnika(RegistrationData uporabnik) async {

  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded'
  };


  var request = http.Request('POST', Uri.parse('${Constants.apiBaseURL}/registracija'));


  request.bodyFields = {
    'ime': uporabnik.ime,
    'email': uporabnik.mail,
    'barvaUporabnika': uporabnik.barva,
    'geslo': uporabnik.geslo,
  };
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
    data["mail"] = uporabnik.mail;

    StorageItem newItem = StorageItem('prijavljenUporabnik', jsonEncode(data));
    await storage.writeSecureData(newItem);

    return true;
  }
  else {
    print("Registracija neuspešna: ${response.statusCode} => ${response.reasonPhrase}");
    return false;
    //throw "Prijava neuspešna: ${response.statusCode} => ${response.reasonPhrase}";
  }

}