import 'package:debtsettler_v4/Gospodinjstvo/Screens/Gospodinjstvo.dart';
import 'package:debtsettler_v4/Helpers/ThemeHelper.dart';
import 'package:debtsettler_v4/Home/Models/GospodinjstvoSStanjem_model.dart';
import 'package:debtsettler_v4/Home/Models/Gospodinjstvo_model.dart';
import 'package:debtsettler_v4/Storage/Storage_services.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Gospodinjstvo/Models/Uporabnik_model.dart';
import '../../Gospodinjstvo/Services/Gospodinjstvo_services.dart';

class GospodinjstvoListItemWidget extends StatelessWidget {
  const GospodinjstvoListItemWidget({
    Key? key,
    required this.gospodinjstvo,
  }) : super(key: key);

  final GospodinjstvoSStanjemModel gospodinjstvo;

  // Preveri ce ima uporabnik pozitivno ali negativno stanje in primerno
  // spremeni barvo stanja
  Color getColor() {
    if (gospodinjstvo.stanjePrijavljenega >= 0) {
      return Colors.green;
    }
    else {
      return Colors.red;
    }
  }


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 20
      ),
      child: InkWell(
        child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment(-0.6, -2),
                  end: Alignment(1.2, 2),
                  colors: [
                    Colors.white,
                    Colors.white,

                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 80,
                        child: SvgPicture.asset('assets/Icons/users-solid.svg'),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            gospodinjstvo.imeGospodinjstva,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8,),
                          RichText(
                              text: TextSpan(
                                  text: 'Stanje: ',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w200
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: double.parse((gospodinjstvo.stanjePrijavljenega).toStringAsFixed(2)).toString(),
                                      style: TextStyle(
                                          color: getColor(),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500
                                      ),
                                    )
                                  ]
                              )
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
          ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PageViewGospodinjstvo(gospodinjstvoKey: gospodinjstvo.imeGospodinjstva,))
          );
        }
      )
    );
  }}