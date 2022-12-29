import 'package:debtsettler_v4/Home/Widgets/AddGospodinjstvo_widget.dart';
import 'package:debtsettler_v4/Storage/StorageItem_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/Uporabnik_services.dart';
import 'package:debtsettler_v4/Home/Models/Gospodinjstvo_model.dart';
import 'package:debtsettler_v4/Home/Widgets/HomeAppBar.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/Gospodinjstvo_services.dart';

import '../../Gospodinjstvo/Models/Uporabnik_model.dart';
import '../Services/Home_services.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {

  late Future<List<GospodinjstvoNoToken>> _gospodinjstva;


  @override
  void initState(){
    super.initState();
    initList();

  }

  void initList() async {
    _gospodinjstva = getGospodinjstva();
  }

  Future<void> _refreshList() async {
    // reload
    setState(() {
      _gospodinjstva = getGospodinjstva();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const HomeAppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            const AddGospodinjstvoWidget(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _refreshList(),
                child: buildGospodinjstvoList(context, _gospodinjstva),
              ),
            )
          ],
        ),
      )
    );
  }

}
