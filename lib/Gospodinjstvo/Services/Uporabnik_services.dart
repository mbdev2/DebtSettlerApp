import 'dart:async' show Future;
import 'dart:io';
import 'package:debtsettler_v4/Helpers/PrijavljenUporabnikNaVrhHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:debtsettler_v4/Gospodinjstvo/Models/Uporabnik_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Widgets/UporabnikListItemWidget.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/Gospodinjstvo_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:debtsettler_v4/constants.dart' as Constants;



FutureBuilder<List<Uporabnik>> buildUporabnikList(BuildContext context, Future<List<Uporabnik>> uporabniki, String gospodinjstvoKey) {

  return FutureBuilder<List<Uporabnik>>(

    future: prijavljenFutureUporabnikNaZacetek(uporabniki),
    builder: (context, snapshot) {
      if (snapshot.data != null) {
        final List<Uporabnik>? posts = snapshot.data;
        return buildUporabnikiItemList(context, posts!, gospodinjstvoKey);
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

ListView buildUporabnikiItemList(BuildContext context, List<Uporabnik> posts, String gospodinjstvoKey) {
  return ListView.builder(
      itemCount: posts.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return UporabnikListItemWidget(uporabnik: posts[index], prijavljen: index==0, gospodinjstvoKey: gospodinjstvoKey);
      }
  );
}
