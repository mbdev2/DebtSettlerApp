import 'package:debtsettler_v4/Gospodinjstvo/Models/AddIzdelekData_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/AddIzdelek_services.dart';
import 'package:debtsettler_v4/Helpers/ThemeHelper.dart';
import 'package:debtsettler_v4/LandingPages/Models/LoginUporabnik_model.dart';
import 'package:debtsettler_v4/LandingPages/Widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

// INICIALZIZACIJA SAFE STORAGE-a
// final storage = StorageService();

class AddIzdelek extends StatefulWidget {
  const AddIzdelek({
    Key? key,
    required this.prijavljenUporabnik,
    required this.gospodinjstvoKey,
  }) : super(key: key);

  final LoginUporabnik prijavljenUporabnik;
  final String gospodinjstvoKey;

  @override
  _AddIzdelekState createState() => _AddIzdelekState();

}

class _AddIzdelekState extends State<AddIzdelek>{

  // INICIALIZACIJA SPREMENLJIVK ZA CONTROLLER
  final _artikelFormKey = GlobalKey<FormState>();

  final FocusNode _artikelFocusNode = FocusNode();
  final FocusNode _opisArtiklaFocusNode = FocusNode();

  final TextEditingController _artikelController = TextEditingController();
  final TextEditingController _opisArtiklaController = TextEditingController();
  int _kolicinaController = 1;

  // FUNKCIJE ZA UPRAVLJANJE FORMA
  _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  _submitForm() async {
    if (_artikelFormKey.currentState!.validate()) {

      String opis = '/';
      if (_opisArtiklaController.text.isNotEmpty) {
        opis = _opisArtiklaController.text;
      }

      AddIzdelekData novIzdelek = AddIzdelekData(
        idAvtorja: widget.prijavljenUporabnik.uporabnikGlobalId,
        izdelekIme: _artikelController.text,
        izdelekOpis: opis,
        izdelekKolicina: _kolicinaController,
      );

      bool response = await vnesiIzdelek(novIzdelek, widget.gospodinjstvoKey);

      if(response) {
        _artikelFormKey.currentState!.reset();
        _kolicinaController = 1;
        print("NAKUP VNESEN: ime = ${_artikelController.text},  kolicina = $_kolicinaController,  opis = ${_opisArtiklaController.text}");
      } else {
        //_nakupFormKey.currentState!.reset();
      }

    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: 'listIcon',
          child: Material(
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Container(
                    color: Colors.grey.shade800,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.checklist),
                        padding: const EdgeInsets.all(0),
                        color: Colors.white
                    ),
                  )
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.only(right: 30, left: 30),
        child: Form(
          key: _artikelFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: size.height*0.01,),

//======================= NASLOV ===========================================================================
              SizedBox(
                height: size.height*0.05,
                child: const FittedBox(
                  child: Text(
                    'Dodajte artikle',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: size.height*0.04,),

              Row(
                children: [
//======================= IME ARTIKLA ===========================================================================
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: ThemeHelper().textInputDecoration(
                          lableText: 'Izdelek',
                          hintText: 'Vnesite ime izdelka',
                          labelColor: Colors.black,
                          borderColor: Colors.black,
                        ),
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        controller: _artikelController,
                        focusNode: _artikelFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Prosim izpolnite polje';
                          }
                          return null;
                        },
                        onFieldSubmitted: (String value) {
                          _nextFocus(_opisArtiklaFocusNode);
                        },
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                  ),

//======================= KOLICINA ===========================================================================
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      width: size.width*0.33,
                      height: size.height *0.061,
                      child: InputDecorator(
                        decoration: ThemeHelper().textInputDecoration(
                          lableText: 'Kolicina',
                          labelColor: Colors.black,
                          borderColor: Colors.black
                        ),
                        child: WheelChooser.integer(
                          onValueChanged: (value) => {
                            _kolicinaController = value,
                          },
                          maxValue: 99,
                          minValue: 1,
                          initValue: 1,
                          horizontal: true,
                          unSelectTextStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                  ),
                ],
              ),

              SizedBox(height: size.height*0.02),

//======================= OPIS IZDELKA ===========================================================================
              Container(
                child: TextFormField(
                  decoration: ThemeHelper().textInputDecoration(
                    lableText: 'Opis',
                    hintText: 'Po želji vnesite opis izdelka',
                    labelColor: Colors.black,
                    borderColor: Colors.black,
                  ),
                  style: const TextStyle(color: Colors.black),
                  textInputAction: TextInputAction.done,
                  controller: _opisArtiklaController,
                  focusNode: _opisArtiklaFocusNode,
                  validator: (value) {
                    return null;
                  },
                  onFieldSubmitted: (String value) {
                    //_submitForm();
                  },
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),

              SizedBox(height: size.height*0.02),

//======================= GUMB ZA ODDAJO ===========================================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Container(
                  decoration: ThemeHelper().customButtonContainerShadow(),
                  child: CustomButton(
                      label: 'Vnesi izdelek'.toUpperCase(),
                      margin: false,
                      onClick: () {
                        _submitForm();
                      }
                  ),
                ),
              )

            ],
          ),
        ),
      )
    );
  }

}