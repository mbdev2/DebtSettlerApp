import 'dart:async' show Future;
import 'package:debtsettler_v4/Home/Models/Gospodinjstvo_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:debtsettler_v4/Gospodinjstvo/Models/Izdelek_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Widgets/IzdelekWidget.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/Gospodinjstvo_services.dart';
import 'package:http/http.dart' as http;
import 'package:debtsettler_v4/constants.dart' as Constants;




Future<String> _loadIzdelekAsset() async {
  return await rootBundle.loadString('assets/Json/Izdelek.json');
}

Future<List<Izdelek>> loadIzdelki(String key) async {

  // PRIDOBIVANJE TOKENA ZA IZBRANO GOSPODINJSTVO
  GospodinjstvoModel gospodinjstvo;
  String? storageData = await storage.readSecureData(key);

  if (storageData == null) {
    throw "To Gospodinjstvo ne obstaja";
  } else {
    gospodinjstvo = GospodinjstvoModel.fromJson(jsonDecode(storageData));
  }

  String token = 'Bearer ${gospodinjstvo.gsToken}';

  var headers = {
    'Authorization': token,
  };

  var request = http.Request('GET', Uri.parse('${Constants.apiBaseURL}/seznam/gospodinjstvo'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {

    List<dynamic> data = jsonDecode(await response.stream.bytesToString());

    List<Izdelek> posts = data
        .map((dynamic item) => Izdelek.fromJson(item), )
        .toList();

    return posts;

  }
  else {
    throw "Unable to retrieve SHOPPING LIST because: ${response.reasonPhrase}";
  }
}

Future<bool> izbrisiIzdelke(List<Izdelek> izdelki, String key) async {
  // PRIDOBIVANJE TOKENA ZA IZBRANO GOSPODINJSTVO
  GospodinjstvoModel gospodinjstvo;
  String? storageData = await storage.readSecureData(key);

  if (storageData == null) {
    throw "To Gospodinjstvo ne obstaja";
  } else {
    gospodinjstvo = GospodinjstvoModel.fromJson(jsonDecode(storageData));
  }

  String token = 'Bearer ${gospodinjstvo.gsToken}';

  var headers = {
    'Authorization': token,
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  // ZBIRANJE ID-jev IZDELKOV ZA IZBRIS
  List<String> idList = izdelki.map((izdelek) => izdelek.izdelekId).toList();

  var request = http.Request('DELETE', Uri.parse('${Constants.apiBaseURL}/seznam'));
  request.bodyFields = {
    'idArtikla': idList.join(","),
  };
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    //print(await response.stream.bytesToString());
    return true;
  }
  else {
    //print(response.reasonPhrase);
    return false;
  }
}
