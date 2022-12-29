

import 'dart:convert';

import 'package:debtsettler_v4/Helpers/PrijavljenUporabnikNaVrhHelper.dart';
import 'package:flutter/material.dart';

import '../../Helpers/ThemeHelper.dart';
import '../../LandingPages/Models/LoginUporabnik_model.dart';
import '../../LandingPages/Widgets/CustomButton.dart';
import '../../Storage/StorageItem_model.dart';
import '../../Storage/Storage_services.dart';
import '../Services/AccountForm_services.dart';

// INICIALZIZACIJA SAFE STORAGE-a
final storage = StorageService();

class AccountForm extends StatefulWidget {
  AccountForm({
    Key? key,
    required this.prijavljenUporabnik,
  }) : super(key: key);

  LoginUporabnik prijavljenUporabnik;

  @override
  State<AccountForm> createState() => _AccountFormState();

}

class _AccountFormState extends State<AccountForm> {

  // INICIALIZACIJA SPREMENLJIVK ZA CONTROLLER
  final _posodobiImeFormKey = GlobalKey<FormState>();
  final TextEditingController _imeController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();

  final _posodobiGesloFormKey = GlobalKey<FormState>();
  final TextEditingController _staroGesloController = TextEditingController();
  final TextEditingController _novoGesloController = TextEditingController();
  final TextEditingController _repeatGesloController = TextEditingController();
  final FocusNode _novoGesloFocusNode = FocusNode();
  final FocusNode _staroGesloFocusNode = FocusNode();
  final FocusNode _repeatGesloFocusNode = FocusNode();

  late LoginUporabnik prijavljenUporabnik = widget.prijavljenUporabnik;

  var pravilnoGeslo = true;



  @override
  void initState() {
    super.initState();

    _imeController.text = prijavljenUporabnik.imeUporabnika;
    _mailController.text = prijavljenUporabnik.mail;
  }

  _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  _submitImeForm() async {
    if (_posodobiImeFormKey.currentState!.validate()) {
      bool response = await PosodobiImeUporabnika(_imeController.text);

      if(response) {

        prijavljenUporabnik.imeUporabnika = _imeController.text;

        storage.deleteSecureData('prijavljenUporabnik');

        StorageItem newItem = StorageItem('prijavljenUporabnik', jsonEncode(prijavljenUporabnik.toJson()));
        await storage.writeSecureData(newItem);


        const snackBarIme = SnackBar(content: Text("Ime uspešno posodobjeno."),);
        ScaffoldMessenger.of(context).showSnackBar(snackBarIme);


      } else {
        print("Posodabljanje imena uporabnika neuspešno");
        //_nakupFormKey.currentState!.reset();
      }

    }
  }

  _submitGesloForm() async {
    if (_posodobiGesloFormKey.currentState!.validate()) {


      bool response = await PosodobiGesloUporabnika(_staroGesloController.text, _novoGesloController.text);

      if(response) {
        _posodobiGesloFormKey.currentState!.reset();

        const snackBarGeslo = SnackBar(content: Text("Geslo uspešno posodobljeno."),);
        ScaffoldMessenger.of(context).showSnackBar(snackBarGeslo);
        _posodobiGesloFormKey.currentState!.reset();

        print("Geslo uspešno posodobljeno.");
      } else {
        pravilnoGeslo = false;
        _posodobiGesloFormKey.currentState!.validate();
        print("Posodabljanje gesla uporabnika neuspešno");

      }

    }
  }

  @override
  void dispose() {
    _novoGesloFocusNode.dispose();
    _staroGesloFocusNode.dispose();
    _mailController.dispose();
    _imeController.dispose();
    _novoGesloController.dispose();
    _staroGesloController.dispose();
    _repeatGesloController.dispose();
    _repeatGesloFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
//======================= FORM ZA POSODOBITEV IMENA ===========================================================================
        Form(
          key: _posodobiImeFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
//======================= IME ===========================================================================
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                child: Text(
                    "Ime",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: ThemeHelper().textInputDecoration(
                          borderColor: Colors.black,
                        ),
                        style: const TextStyle(color: Colors.black),
                        textInputAction: TextInputAction.next,
                        controller: _imeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Prosimo izpolnite polje';
                          }
                          return null;
                        },
                        onFieldSubmitted: (String value) {
                          _submitImeForm();
                        },
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                  ),

                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Container(
                          decoration: ThemeHelper().customButtonContainerShadow(),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Material(
                                color: Colors.white,
                                child: InkWell(
                                  splashColor: Colors.black.withOpacity(0.2),
                                  highlightColor: Colors.black.withOpacity(0.2),
                                  onTap: () {
                                    _submitImeForm();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Colors.black,
                                            width: 3)
                                    ),
                                    child: Text(
                                        "Shrani".toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)
                                    ),
                                  ),
                                ),
                              )
                          ),
                        ),
                      )
                  )
                ],
              ),

              SizedBox(height: size.height*0.01),

//======================= MAIL ===========================================================================
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                child: Text(
                    "E-mail",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)
                ),
              ),

              Container(
                child: TextField(
                  readOnly: true,
                  decoration: ThemeHelper().textInputDecoration(
                    borderColor: Colors.grey.shade600,
                  ),
                  style: TextStyle(color: Colors.grey.shade600),
                  controller: _mailController,
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),

              SizedBox(height: size.height*0.01),
              Divider(),
              SizedBox(height: size.height*0.01),
            ],
          ),
        ),

//======================= FORM ZA MENJAVO GESLA ===========================================================================
        Form(
          key: _posodobiGesloFormKey,
          child: Column(
            children: [
              SizedBox(
                height: size.height*0.03,
                child: const FittedBox(
                  child: Text(
                    'Menjava Gesla',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: size.height*0.02),
  //======================= STARO GESLO ===========================================================================
              Container(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  decoration: ThemeHelper().textInputDecoration(
                      lableText: 'Staro Geslo',
                      hintText: 'Vnesite svoje staro geslo',
                      labelColor: Colors.black,
                      hintColor: Colors.black,
                      borderColor: Colors.black
                  ),
                  style: const TextStyle(color: Colors.black),
                  textInputAction: TextInputAction.next,
                  controller: _staroGesloController,
                  focusNode: _staroGesloFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Prosimo izpolnite polje';
                    } if (!pravilnoGeslo) {

                      return 'Nepravilno geslo';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    pravilnoGeslo = true;
                  },
                  onFieldSubmitted: (String value) {
                    _nextFocus(_novoGesloFocusNode);
                  },
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),

              SizedBox(height: size.height*0.02),
  //======================= NOVO GESLO ===========================================================================

              Container(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  decoration: ThemeHelper().textInputDecoration(
                      lableText: 'Novo Geslo',
                      hintText: 'Vnesite novo geslo',
                      labelColor: Colors.black,
                      hintColor: Colors.black,
                      borderColor: Colors.black
                  ),
                  style: const TextStyle(color: Colors.black),
                  textInputAction: TextInputAction.next,
                  controller: _novoGesloController,
                  focusNode: _novoGesloFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Prosimo izpolnite polje';
                    }
                    return null;
                  },
                  onFieldSubmitted: (String value) {
                    _nextFocus(_repeatGesloFocusNode);
                  },
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),

              SizedBox(height: size.height*0.02),

  //======================= REPEAT NOVO GESLO ===========================================================================

              Container(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.disabled,
                  obscureText: true,
                  decoration: ThemeHelper().textInputDecoration(
                      lableText: 'Ponovite novo geslo',
                      hintText: 'Ponovite novo geslo',
                      labelColor: Colors.black,
                      hintColor: Colors.black,
                      borderColor: Colors.black
                  ),
                  style: const TextStyle(color: Colors.black),
                  textInputAction: TextInputAction.done,
                  controller: _repeatGesloController,
                  focusNode: _repeatGesloFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Prosimo izpolnite polje';
                    } else if (_novoGesloController.text != value) {
                      return 'Ponovljeno geslo se ne sklada';
                    }
                    return null;
                  },
                  onFieldSubmitted: (String value) {
                    _submitImeForm();
                  },
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),

              SizedBox(height: size.height*0.02),

              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 35, 0),
                child: Container(
                  decoration: ThemeHelper().customButtonContainerShadow(),
                  child: CustomButton(
                      label: 'Posodobi Geslo'.toUpperCase(),
                      margin: false,
                      borderColor: Colors.black,
                      borderWidth: 3,
                      onClick: () {
                        if (_posodobiGesloFormKey.currentState!.validate()) {
                          _submitGesloForm();
                        }

                      }
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

}