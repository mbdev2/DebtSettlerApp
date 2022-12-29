import "package:debtsettler_v4/Gospodinjstvo/Models/Uporabnik_model.dart";
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Helpers/ThemeHelper.dart';
import 'AddGospodinjstvo_dialog.dart';

class AddGospodinjstvoWidget extends StatelessWidget {
  const AddGospodinjstvoWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment(-0.6, -2),
                end: Alignment(1.2, 2),
                colors: [
                  Colors.white,
                  Colors.white
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
            child: ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  hasIcon: false,
                ),
                header: Container(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade800,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(25),
                    height: 90,
                    child: SvgPicture.asset(
                      'assets/Icons/house-circle-add-solid.svg',
                      color: Colors.white,
                    ),
                  )
                ),
                collapsed: const SizedBox(),

                expanded: const AddGospodinjstvoForm(),
                builder: (_, collapsed, expanded) {
                  return Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(crossFadePoint: 0),
                  );
                },
              ),
            ),
          ),
        ));
  }
}


