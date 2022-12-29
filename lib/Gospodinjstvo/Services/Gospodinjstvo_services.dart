import 'dart:async' show Future;
import 'package:debtsettler_v4/Gospodinjstvo/Screens/Gospodinjstvo.dart';
import 'package:debtsettler_v4/Home/Models/Gospodinjstvo_model.dart';
import 'package:debtsettler_v4/Storage/StorageItem_model.dart';
import 'package:debtsettler_v4/Storage/Storage_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:debtsettler_v4/Gospodinjstvo/Models/Uporabnik_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Widgets/UporabnikListItemWidget.dart';
import 'package:http/http.dart' as http;
import 'package:debtsettler_v4/constants.dart' as Constants;


// INICIALZIZACIJA SAFE STORAGE-a
final storage = StorageService();


// API KLIC ZA PRIDOBITEV UPORABNIKOV GOSPODINJSTVA:
Future<List<Uporabnik>> getClaniGospodinjstva(String key) async {

  // PRIDOBIVANJE TOKENA ZA IZBRANO GOSPODINJSTVO
  String gsToken = await pridobiTokenGospodinjstva(key);
  String token = 'Bearer $gsToken';

  var headers = {
    'Authorization': token,
  };


  var request = http.Request('GET', Uri.parse('${Constants.apiBaseURL}/gospodinjstvo/claniGospodinjstva'));


  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {

    Map<String, dynamic> body = jsonDecode(await response.stream.bytesToString());
    List<dynamic> data = body["uporabniki"];

    List<Uporabnik> posts = data
        .map((dynamic item) => Uporabnik.fromJson(item),)
        .toList();

    return posts;

  } else {
    throw "Unable to retrieve posts because: ${response.reasonPhrase}";
  }

}

Future<String> pridobiTokenGospodinjstva(String key) async {
  GospodinjstvoModel gospodinjstvo;
  String? storageData = await storage.readSecureData(key);

  if (storageData == null) {
    throw "To Gospodinjstvo ne obstaja";
  } else {
    gospodinjstvo = GospodinjstvoModel.fromJson(jsonDecode(storageData));
  }

  return gospodinjstvo.gsToken;
}

