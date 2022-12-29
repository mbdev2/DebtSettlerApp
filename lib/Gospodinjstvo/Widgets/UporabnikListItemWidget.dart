import "package:debtsettler_v4/Gospodinjstvo/Models/Uporabnik_model.dart";
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Helpers/DecimalTextInputFormatter.dart';
import '../../Helpers/ThemeHelper.dart';
import '../Screens/Gospodinjstvo.dart';
import '../Services/Poravnava_services.dart';

class UporabnikListItemWidget extends StatelessWidget {
  const UporabnikListItemWidget({
    Key? key,
    required this.uporabnik,
    required this.prijavljen,
    required this.gospodinjstvoKey,
  }) : super(key: key);

  final Uporabnik uporabnik;
  final bool prijavljen;
  final String gospodinjstvoKey;
  //final String barvaUporabnika;


  @override
  Widget build(BuildContext context) {

    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            clipBehavior: Clip.antiAlias,
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
            child: ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  hasIcon: false,
                ),
                header: UporabnikStanjeWidget(uporabnik: uporabnik),
                collapsed: const SizedBox(),
                /*Center(
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.black,
                    )
                ),
                 */
                expanded: prijavljen ? const SizedBox() : PoravnavaForm(uporabnik: uporabnik,gospodinjstvoKey: gospodinjstvoKey),
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
              ),
            ),
          ),
        ));
  }
}

// PRIKAZ IMENA IN STANJA
class UporabnikStanjeWidget extends StatelessWidget {

  const UporabnikStanjeWidget({
    Key? key,
    required this.uporabnik,
  }) : super(key: key);

  final Uporabnik uporabnik;

  // Preveri ce ima uporabnik pozitivno ali negativno stanje in primerno
  // spremeni barvo stanja
  Color getColor() {
    if (uporabnik.stanje >= 0) {
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
        left: 20,
        right: 20,
        top: 20,
        bottom: 10,
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: ClipOval(
              child: Container(
                  height: 60,
                  width: 60,
                  color: HexColor(uporabnik.barvaUporabnika),
                  padding: const EdgeInsets.fromLTRB(5,10,5,0),
                  child: SvgPicture.asset('assets/Icons/user-astronaut-solid.svg', color: Colors.white)
              ),
            ),
          ),
          Expanded(
              child: Text(
                uporabnik.ime,
                style: const TextStyle(color: Colors.black, fontSize: 25),
                textAlign: TextAlign.left,
              )
          ),
          Expanded(
              child: Text(
                double.parse((uporabnik.stanje).toStringAsFixed(2)).toString(),
                style: TextStyle(color: getColor(), fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Icon(Icons.euro, color: getColor(),),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }
}


// WIDGET ZA PRIKAZ GUMBOV
class PoravnavaForm extends StatefulWidget{
  const PoravnavaForm({
    Key? key,
    required this.uporabnik,
    required this.gospodinjstvoKey
  }) : super(key: key);

  final Uporabnik uporabnik;
  final String gospodinjstvoKey;

  @override
  _PoravnavaFormState createState() => _PoravnavaFormState();

}

class _PoravnavaFormState extends State<PoravnavaForm>{

  final _poravnavaFormKey = GlobalKey<FormState>();

  final TextEditingController _znesekController = TextEditingController();

  _submitForm(bool prejmem) async {
    if(_poravnavaFormKey.currentState!.validate()) {
      String znesek = _znesekController.text;
      if(prejmem){
        znesek='-$znesek';
      }
      bool response = await vnesiPoravnavo(widget.gospodinjstvoKey, widget.uporabnik.upVGosID, znesek);
      if(response){
        String text="Uspešno ste nakazili denar.";
        if(prejmem){
          text="Uspešno ste prejeli denar.";
        }
        var popupPoravnava = SnackBar(content: Text(text),);
        ScaffoldMessenger.of(context).showSnackBar(popupPoravnava);
      }
      else{
        String text="Poravava ni bila uspešna";
        var popupPoravnava = SnackBar(content: Text(text),);
        ScaffoldMessenger.of(context).showSnackBar(popupPoravnava);
      }
      _poravnavaFormKey.currentState!.reset();
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PageViewGospodinjstvo(gospodinjstvoKey: widget.gospodinjstvoKey,))
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Form(
              key: _poravnavaFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 20, 5),
                    child: Text("Poravnava:"),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            scrollPadding: EdgeInsets.only(bottom: 40),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: ThemeHelper().textInputDecoration(
                              lableText: 'Znesek',
                              hintText: '123',
                              labelColor: Colors.black,
                              borderColor: Colors.black,
                            ),
                            style: const TextStyle(color: Colors.black),
                            inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            // keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            controller: _znesekController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Izpolnite';
                              }
                              return null;
                            },
                            onFieldSubmitted: (String value) {

                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: ButtonBar(
                          children: [
                            IconButton(
                              onPressed: () {
                                _submitForm(false);
                              },
                              icon: Image.asset("assets/Icons/money-pay.png"),
                              iconSize: 40,
                            ),
                            IconButton(
                              onPressed: () {
                                _submitForm(true);
                              },
                              icon: Image.asset("assets/Icons/money-receive.png"),
                              iconSize: 40,
                            )
                          ],
                          alignment: MainAxisAlignment.spaceEvenly,
                        ),
                      )
                    ],
                  )
                ],
              )
          ),
        )
    );
  }

}
