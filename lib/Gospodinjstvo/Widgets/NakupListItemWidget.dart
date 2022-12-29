import "package:debtsettler_v4/Gospodinjstvo/Models/Nakup_model.dart";
import 'package:debtsettler_v4/Helpers/MonthToStringHelper.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import "package:debtsettler_v4/Gospodinjstvo/Services/Zgodovina_services.dart";

import '../Models/Uporabnik_model.dart';



class NakupListItemWidget extends StatelessWidget {
  const NakupListItemWidget({
    Key? key,
    required this.nakup,
    required this.uporabnik
  }) : super(key: key);

  final Nakup nakup;
  final Uporabnik uporabnik;

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: NakupGlavniPodatkiWidget(nakup: nakup, uporabnik: uporabnik),
                collapsed: const SizedBox(height: 1,),
                expanded: Padding(
                  padding: const EdgeInsets.only(
                      right: 10,
                      left: 10,
                      top: 5
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(0),
                        width: 41,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3),
                                child: Icon(Icons.access_time, color: Colors.grey.shade700, size: 15,),
                              ),
                              Text(
                                "${nakup.datumNakupa.hour}:${nakup.datumNakupa.minute}",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            nakup.opisNakupa,
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              )
          )
        ),
      ),
    );
  }


}

class NakupGlavniPodatkiWidget extends StatelessWidget {

  const NakupGlavniPodatkiWidget({
    Key? key,
    required this.nakup,
    required this.uporabnik,
  }) : super (key: key);

  final Nakup nakup;
  final Uporabnik uporabnik;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Text(
                  "${nakup.datumNakupa.day}",
                  style: const TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  monthToStringHelper(nakup.datumNakupa.month),
                  style: const TextStyle(color: Colors.black, fontSize: 15, height: 0.8),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5,),
                Text(
                  nakup.imeTrgovine,
                  style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold,),
                  textAlign: TextAlign.left,
                ),
                const Divider(color: Colors.black54, height: 10, endIndent: 10,),
                Text(
                  uporabnik.ime,
                  style: const TextStyle(color: Colors.black54, fontSize: 15),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 5,),
              ],
            )
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 7),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "${nakup.znesekNakupa}",
                  style: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              )
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }

}


