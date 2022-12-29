import 'dart:async' show Future;
import 'dart:io';
import 'package:debtsettler_v4/Home/Models/Gospodinjstvo_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:debtsettler_v4/Gospodinjstvo/Models/Nakup_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Widgets/NakupListItemWidget.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Widgets/UporabnikListItemWidget.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/Gospodinjstvo_services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:debtsettler_v4/constants.dart' as Constants;


import '../Models/Uporabnik_model.dart';

FutureBuilder<List<dynamic>> buildZgodovinaList(BuildContext context, Future<List<Uporabnik>> uporabniki, String gospodinjstvoKey) {

  Size size = MediaQuery.of(context).size;

  return FutureBuilder(

    future: Future.wait([_getNakupiGospodinjstvo(gospodinjstvoKey), uporabniki]),
    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
      if(snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
        final List<Nakup>? nakupiPosts = snapshot.data![0];
        final List<Uporabnik>? uporabnikiPosts = snapshot.data![1];
        if (nakupiPosts!.isEmpty) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/Icons/wind-solid.svg', color: Colors.grey, width: size.width*0.1,),
                    const SizedBox(height: 20,),
                    const Text(
                      "Trenutnno še nimate opravljeih nakupov.",
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    )
                  ],
                )
              ),
              height: size.height*0.6,
            ),
          );
        } else {
          return buildZgodovinaItemList(context, nakupiPosts, uporabnikiPosts!);
        }

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
    },
  );
}

ListView buildZgodovinaItemList(BuildContext context, List<Nakup> posts, List<Uporabnik> uporabniki) {
  return ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: posts.length,
    padding: const EdgeInsets.all(8),
    itemBuilder: (context, index) {
      var up = uporabniki.where((element) => element.upVGosID == posts[index].upVGosID).toList();
      return NakupListItemWidget(nakup: posts[index], uporabnik: up[0],);
    },
  );
}

// API KLIC ZA PRIDOBIVANJE VSEH NAKUPOV:
Future<List<Nakup>> _getNakupiGospodinjstvo(String key) async {

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


  var request = http.Request('GET', Uri.parse('${Constants.apiBaseURL}/nakupi/gospodinjstvo'));


  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {

    List<dynamic> data = jsonDecode(await response.stream.bytesToString());

    var reversedData = List.from(data.reversed);

    List<Nakup> posts = reversedData
      .map((dynamic item) => Nakup.fromJson(item), )
      .toList();

    return posts;

  } else {
    throw "Unable to retrieve history because: ${response.reasonPhrase}";
  }

}

// API KLIC ZA PRIDOBIVANJE IMENA UPORABNIKA:
Future<String> getImeUporabnika() async {
  var headers = {
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZFVwb3JhYm5pa2EiOiI2MjhkMDhhNWM2NTk2MTBmODMyNWNhNDEiLCJlbWFpbCI6ImJsYXpAZ21haWwuY29tIiwiaW1lIjoiQmxheiIsImV4cCI6MzE3MTI1NTk4MDcxLCJpYXQiOjE2NTM0MTAyMjN9.JDZpnNGSWITz7glDjlu9BdzqGt5ddoITPGir9YdYGQk'
  };
  var request = http.Request('GET', Uri.parse('${Constants.apiBaseURL}/users/podatkiUporabnika'));
  request.bodyFields = {};
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    dynamic uporabnik = await response.stream.bytesToString();
    return uporabnik["imeUporabnika"];
  }
  else {
    throw "Unable to retrieve User name becauese: ${response.reasonPhrase}";
  }
}