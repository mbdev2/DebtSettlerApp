import 'package:debtsettler_v4/Helpers/PrijavljenUporabnikNaVrhHelper.dart';
import 'package:debtsettler_v4/LandingPages/Models/LoginUporabnik_model.dart';
import 'package:http/http.dart' as http;
import 'package:debtsettler_v4/Gospodinjstvo/Models/AddIzdelekData_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/Gospodinjstvo_services.dart';
import 'package:debtsettler_v4/constants.dart' as Constants;


Future<bool> PosodobiImeUporabnika(String ime) async {

  // PRIDOBIVANJE TOKENA PRIJAVLJENEGA UPORABNIKA
  LoginUporabnik uporabnik = await getPrijavljenUporabnik();
  String token = 'Bearer ${uporabnik.DStoken}';

  var headers = {
    'Authorization': token,
    'Content-Type': 'application/x-www-form-urlencoded'
  };


  var request = http.Request('POST', Uri.parse('${Constants.apiBaseURL}/users/posodobiUporabnika'));

  request.bodyFields = {
    'imeUp': ime,
    'emailUp': uporabnik.mail,
    'barvaUp': uporabnik.barvaUporabnika
  };
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    return true;
  }
  else {
    print("Posodabljanje imena uporabnika neuspešno: ${response.statusCode} => ${response.reasonPhrase}");
    return false;
    //throw "Prijava neuspešna: ${response.statusCode} => ${response.reasonPhrase}";
  }
}

Future<bool> PosodobiGesloUporabnika(String staroGeslo, String novoGeslo) async {

  // PRIDOBIVANJE TOKENA PRIJAVLJENEGA UPORABNIKA
  LoginUporabnik uporabnik = await getPrijavljenUporabnik();
  String token = 'Bearer ${uporabnik.DStoken}';

  var headers = {
    'Authorization': token,
    'Content-Type': 'application/x-www-form-urlencoded'
  };


  var request = http.Request('POST', Uri.parse('${Constants.apiBaseURL}/users/menjavaGesla'));

  request.bodyFields = {
    'geslo': staroGeslo,
    'novoGeslo': novoGeslo
  };
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    return true;
  }
  else {
    print("Posodabljanje imena uporabnika neuspešno: ${response.statusCode} => ${response.reasonPhrase}");
    return false;
    //throw "Prijava neuspešna: ${response.statusCode} => ${response.reasonPhrase}";
  }
}