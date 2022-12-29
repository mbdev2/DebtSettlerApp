
import 'package:debtsettler_v4/Gospodinjstvo/Services/Gospodinjstvo_services.dart';
import 'package:debtsettler_v4/Helpers/PrijavljenUporabnikNaVrhHelper.dart';
import 'package:debtsettler_v4/Home/Models/AddGospodinjstvoData_model.dart';
import 'package:debtsettler_v4/Home/Models/GospodinjstvoSStanjem_model.dart';
import 'package:debtsettler_v4/Home/Models/Gospodinjstvo_model.dart';
import 'package:debtsettler_v4/LandingPages/Models/LoginUporabnik_model.dart';
import 'package:debtsettler_v4/Storage/StorageItem_model.dart';
import 'package:debtsettler_v4/Storage/Storage_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async' show Future;
import 'package:debtsettler_v4/constants.dart' as Constants;


import '../../Gospodinjstvo/Models/Uporabnik_model.dart';
import '../Widgets/GospodinjstvoListItemWidget.dart';

// INICIALZIZACIJA SAFE STORAGE-a
final storage = StorageService();


// API KLIC ZA PRIDOBITEV VSEH GOSPODINJSTEV PRIJAVLJENEGA UPORABNIKA
Future<List<GospodinjstvoNoToken>> getGospodinjstva() async {

  String? storageData = await storage.readSecureData('prijavljenUporabnik');
  LoginUporabnik prijavljenUporabnik = LoginUporabnik.fromJson(json.decode(storageData!));

  var headers = {
    'Authorization': 'Bearer ${prijavljenUporabnik.DStoken}',
  };


  var request = http.Request('GET', Uri.parse('${Constants.apiBaseURL}/gospodinjstvo/tokeniUporabnikGospodinjstev'));


  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {

    Map<String, dynamic> body = jsonDecode(await response.stream.bytesToString());
    List<dynamic> data = body["tokens"];

    List<GospodinjstvoModel> posts = data
        .map((dynamic item) => GospodinjstvoModel.fromJson(item),)
        .toList();


    for (var item in posts) {
      StorageItem newItem = StorageItem(item.imeGospodinjstva, jsonEncode(item));
      await storage.writeSecureData(newItem);
    }

    List<GospodinjstvoNoToken> info = posts.map((dynamic item) => GospodinjstvoNoToken.fromGospodinjstvo(item)).toList();

    return info;

  } else {
    throw "Unable to retrieve posts because: ${response.reasonPhrase}";
  }

}



// ISKANJE STANJA PRIJAVLJENEGA UPORABNIKA ZA PRIKAZ OB VSAKEM GOSPODINJSTVU
Future<List<GospodinjstvoSStanjemModel>> getStanjaPrijavljenega() async {
  List<GospodinjstvoNoToken> gospodinjstva = await getGospodinjstva();
  LoginUporabnik prijavljen = await getPrijavljenUporabnik();
  List<GospodinjstvoSStanjemModel> posts = [];

  for (GospodinjstvoNoToken gospodinjstvo in gospodinjstva) {
    List<Uporabnik> uporabniki = await getClaniGospodinjstva(gospodinjstvo.imeGospodinjstva);
    int indeksPrijavljenega = uporabniki.indexWhere((uporabnik) => uporabnik.uporabnikId == prijavljen.uporabnikGlobalId);
    double stanjePrijavljenega = uporabniki[indeksPrijavljenega].stanje;

    posts.add(GospodinjstvoSStanjemModel(
        imeGospodinjstva: gospodinjstvo.imeGospodinjstva,
        stanjePrijavljenega: stanjePrijavljenega)
    );
  }

  return posts;
}

// GRAJENJE SEZNAMA GOSPODINJSTEV
FutureBuilder<List<GospodinjstvoSStanjemModel>> buildGospodinjstvoList(BuildContext context, Future<List<GospodinjstvoNoToken>> gospodinjstva) {

  return FutureBuilder<List<GospodinjstvoSStanjemModel>>(
    future: getStanjaPrijavljenega(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
        final List<GospodinjstvoSStanjemModel>? posts = snapshot.data;
        return buildGospodinjstvaItemList(context, posts!);
      } else {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            child: const Center(
              child: CircularProgressIndicator(),
            ),
            height: MediaQuery.of(context).size.height*0.5,
          ),
        );
      }
    }
  );
}

ListView buildGospodinjstvaItemList(BuildContext context, List<GospodinjstvoSStanjemModel> list) {

  return ListView.builder(
    itemCount: list.length,
    padding: const EdgeInsets.all(8),
    itemBuilder: (context, index) {
      return GospodinjstvoListItemWidget(gospodinjstvo: list[index]);
    }
  );
}



// FUNKCIJA ZA DODAJANJE NOVEGA GOSPODINJSTVA:
Future<GospodinjstvoModel> createGospodinjstvo(AddGospodinjstvoData gospodinjstvo) async {

    String? storageData = await storage.readSecureData('prijavljenUporabnik');
    LoginUporabnik prijavljenUporabnik = LoginUporabnik.fromJson(json.decode(storageData!));

    var headers = {
      'Authorization': 'Bearer ${prijavljenUporabnik.DStoken}',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('POST', Uri.parse('${Constants.apiBaseURL}/gospodinjstvo/ustvari'));
    request.bodyFields = {
      'imeGospodinjstva': gospodinjstvo.imeGospodinjstva,
      'geslo': gospodinjstvo.geslo
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print("Gospodinjstvo uspešno ustvarjeno: ${response.statusCode} => ${response.reasonPhrase}");

      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      GospodinjstvoModel dodanoGospodinjstvo = GospodinjstvoModel.fromJson(data);

      StorageItem newItem = StorageItem(dodanoGospodinjstvo.imeGospodinjstva, jsonEncode(dodanoGospodinjstvo));
      await storage.writeSecureData(newItem);

      return dodanoGospodinjstvo;
    }
    else {
      print(response.reasonPhrase);
      throw "Ustvrajanje gospodinjstva neuspešno: ${response.statusCode} => ${response.reasonPhrase}";
    }
}