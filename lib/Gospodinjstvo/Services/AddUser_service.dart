import 'package:http/http.dart' as http;
import 'package:debtsettler_v4/Gospodinjstvo/Models/AddIzdelekData_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/Gospodinjstvo_services.dart';
import 'package:debtsettler_v4/constants.dart' as Constants;


Future<bool> dodajUporabnika(String mail, String gospodinjstvoKey) async {

  // PRIDOBIVANJE TOKENA ZA IZBRANO GOSPODINJSTVO
  String gsToken = await pridobiTokenGospodinjstva(gospodinjstvoKey);
  String token = 'Bearer $gsToken';

  var headers = {
    'Authorization': token,
    'Content-Type': 'application/x-www-form-urlencoded'
  };


  var request = http.Request('POST', Uri.parse('${Constants.apiBaseURL}/gospodinjstvo/dodajClana'));

  request.bodyFields = {
    'email': mail
  };
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 201) {
    return true;
  }
  else {
    print("Dodajanje uporabnika neuspešno: ${response.statusCode} => ${response.reasonPhrase}");
    return false;
    //throw "Prijava neuspešna: ${response.statusCode} => ${response.reasonPhrase}";
  }
}