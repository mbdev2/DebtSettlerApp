import 'package:http/http.dart' as http;
import 'package:debtsettler_v4/Gospodinjstvo/Models/AddIzdelekData_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/Gospodinjstvo_services.dart';
import 'package:debtsettler_v4/constants.dart' as Constants;


Future<bool> vnesiIzdelek(AddIzdelekData novIzdelek, String gospodinjstvoKey) async {

  // PRIDOBIVANJE TOKENA ZA IZBRANO GOSPODINJSTVO
  String gsToken = await pridobiTokenGospodinjstva(gospodinjstvoKey);
  String token = 'Bearer $gsToken';

  var headers = {
    'Authorization': token,
    'Content-Type': 'application/x-www-form-urlencoded'
  };


  var request = http.Request('POST', Uri.parse('${Constants.apiBaseURL}/seznam/novo'));


  request.bodyFields = {
    'naslov': novIzdelek.izdelekIme,
    'opis': novIzdelek.izdelekOpis,
    'kolicina': novIzdelek.izdelekKolicina.toString(),
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