import 'package:debtsettler_v4/Gospodinjstvo/Models/AddNakupData_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/Gospodinjstvo_services.dart';
import 'package:debtsettler_v4/Home/Models/Gospodinjstvo_model.dart';
import 'package:debtsettler_v4/Storage/Storage_services.dart';
import 'package:flutter/material.dart';
import 'package:debtsettler_v4/Storage/StorageItem_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async' show Future;
import 'package:debtsettler_v4/constants.dart' as Constants;


// INICIALZIZACIJA SAFE STORAGE-a
final storage = StorageService();

DropdownMenuItem<String> buildKategorijaListItem(String kategorija) {
  return DropdownMenuItem(
    value: kategorija,
    child: Text(
        kategorija
    ),
  );
}

Future<bool> vnesiNakup(AddNakupData novNakup, String gospodinjstvoKey) async {

  // PRIDOBIVANJE TOKENA ZA IZBRANO GOSPODINJSTVO
  String gsToken = await pridobiTokenGospodinjstva(gospodinjstvoKey);
  String token = 'Bearer $gsToken';

  var headers = {
    'Authorization': token,
    'Content-Type': 'application/x-www-form-urlencoded'
  };


  var request = http.Request('POST', Uri.parse('${Constants.apiBaseURL}/nakupi/dodajNakup'));


  request.bodyFields = {
    'kategorijaNakupa': novNakup.kategorijaNakupa.toString(),
    'imeTrgovine': novNakup.imeTrgovine,
    'opisNakupa': novNakup.opisNakupa,
    'znesekNakupa': novNakup.znesekNakupa.toString(),
    'tabelaUpVGos': novNakup.tabelaUpVGos.join(','),
  };
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 201) {
    return true;
  }
  else {
    print("Vnos nakupa neuspešen: ${response.statusCode} => ${response.reasonPhrase}");
    return false;
    //throw "Prijava neuspešna: ${response.statusCode} => ${response.reasonPhrase}";
  }
}

