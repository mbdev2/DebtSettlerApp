import 'dart:convert';
import 'dart:ui';

import 'package:debtsettler_v4/Gospodinjstvo/Models/AddIzdelekData_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/AddIzdelek_services.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Widgets/AccountForm.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Widgets/UserInfoAppBar.dart';
import 'package:debtsettler_v4/Helpers/PrijavljenUporabnikNaVrhHelper.dart';
import 'package:debtsettler_v4/Helpers/ThemeHelper.dart';
import 'package:debtsettler_v4/LandingPages/Models/LoginUporabnik_model.dart';
import 'package:debtsettler_v4/LandingPages/Widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../Storage/StorageItem_model.dart';
import '../../Storage/Storage_services.dart';
import '../Services/AccountForm_services.dart';
import '../Services/AddUser_service.dart';
import '../Widgets/GospodinjstvoAppBar.dart';

// INICIALZIZACIJA SAFE STORAGE-a
final storage = StorageService();

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();

}

class _UserInfoState extends State<UserInfo>{


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: const UserInfoAppBar(),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          reverse: true,
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
              padding: EdgeInsets.only(right: 30, left: 30, bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: size.height*0.01,),

//======================= NASLOV IN IKONA ===========================================================================
                  SizedBox(
                      height: size.height*0.1,
                      child: const FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.black,
                        ),
                      )
                  ),

                  SizedBox(
                    height: size.height*0.05,
                    child: const FittedBox(
                      child: Text(
                        'Moj Račun',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(height: size.height*0.02,),

                  FutureBuilder(
                    future: getPrijavljenUporabnik(),
                    builder: (BuildContext context, AsyncSnapshot<LoginUporabnik> snapshot) {
                      if (snapshot.data != null) {
                        return AccountForm(prijavljenUporabnik: snapshot.data!);
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
                  )
                ],
              )
          ),
        )
    );
  }

}



