
import 'dart:convert';

import 'package:debtsettler_v4/Gospodinjstvo/Models/Uporabnik_model.dart';
import 'package:debtsettler_v4/LandingPages/Models/LoginUporabnik_model.dart';
import 'package:debtsettler_v4/Storage/Storage_services.dart';

// INICIALZIZACIJA SAFE STORAGE-a
final storage = StorageService();


Future<LoginUporabnik> getPrijavljenUporabnik() async {
  String? storageData;
  late LoginUporabnik prijavljenUporabnik;
  storageData = await storage.readSecureData('prijavljenUporabnik');
  prijavljenUporabnik = LoginUporabnik.fromJson(json.decode(storageData!));
  return prijavljenUporabnik;
}


Future<List<Uporabnik>> prijavljenUporabnikNaZacetek(List<Uporabnik> uporabniki) async {
  LoginUporabnik prijavljenUporabnik = await getPrijavljenUporabnik();
  int indeksPrijavljenega = uporabniki.indexWhere((uporabnik) => uporabnik.uporabnikId == prijavljenUporabnik.uporabnikGlobalId);
  if (indeksPrijavljenega == 0) {
    // do nothing
  } else {
    Uporabnik prijavljen = uporabniki.removeAt(indeksPrijavljenega);
    uporabniki.insert(0, prijavljen);
  }

  return uporabniki;
}

Future<List<Uporabnik>> prijavljenFutureUporabnikNaZacetek(Future<List<Uporabnik>> futureUporabniki) async {
  LoginUporabnik prijavljenUporabnik = await getPrijavljenUporabnik();
  List<Uporabnik> uporabniki = await futureUporabniki;
  int indeksPrijavljenega = uporabniki.indexWhere((uporabnik) => uporabnik.uporabnikId == prijavljenUporabnik.uporabnikGlobalId);
  if (indeksPrijavljenega == 0) {
    // do nothing
  } else {
    Uporabnik prijavljen = uporabniki.removeAt(indeksPrijavljenega);
    uporabniki.insert(0, prijavljen);
  }

  return uporabniki;
}