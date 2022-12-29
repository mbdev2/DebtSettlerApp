import 'package:debtsettler_v4/Gospodinjstvo/Services/Gospodinjstvo_services.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Widgets/TitleWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:debtsettler_v4/Gospodinjstvo/Services/Zgodovina_services.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Models/Uporabnik_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Zgodovina extends StatefulWidget{

  const Zgodovina({Key? key, required this.uporabniki, required this.gospodinjstvoKey}) : super(key: key);
  final Future<List<Uporabnik>> uporabniki;
  final String gospodinjstvoKey;

  @override
  State<Zgodovina> createState() => _ZgodovinaState();
}

class _ZgodovinaState extends State<Zgodovina> {

  late Future<List<Uporabnik>> uporabniki = widget.uporabniki;
  late final String gospodinjstvoKey;

  @override
  void initState() {
    uporabniki = widget.uporabniki;
    gospodinjstvoKey = widget.gospodinjstvoKey;
    super.initState();
  }

  Future<void> _refreshList() async {
    // reload
    setState(() {
      uporabniki = getClaniGospodinjstva(widget.gospodinjstvoKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height:20,
            color: Colors.white,
          ),
          const TitleWidget(imagePath: 'assets/Icons/History2.png', widgetHeight: 120, title: 'Zgodovina', scale: 12,),
          Expanded(
            child: RefreshIndicator(
              child: buildZgodovinaList(context, widget.uporabniki, widget.gospodinjstvoKey),
              onRefresh: _refreshList,
            )
          )
        ],
      )
    );
  }
}