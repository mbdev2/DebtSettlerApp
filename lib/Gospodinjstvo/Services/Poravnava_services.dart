import 'package:http/http.dart' as http;
import 'package:debtsettler_v4/Gospodinjstvo/Models/AddIzdelekData_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/Gospodinjstvo_services.dart';
import 'package:debtsettler_v4/constants.dart' as Constants;


Future<bool> vnesiPoravnavo(String gospodinjstvoKey, String idPrejemnikaVgos, String znesek) async {

  String gsToken = await pridobiTokenGospodinjstva(gospodinjstvoKey);
  String token = 'Bearer $gsToken';
  print(znesek);
  var headers = {
    'Authorization': token,
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  var request = http.Request('POST', Uri.parse('${Constants.apiBaseURL}/nakupi/poravnavaDolga'));
  request.bodyFields = {
    'znesek': znesek,
    'prejemnikIdUpvGos': idPrejemnikaVgos
  };
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 201) {
    print('Poravnava dolga je bila uspesna');
    return true;
  }
  else {
    print("Poravnava dolga ni bila uspesna");
    return false;
  }
}