import 'package:debtsettler_v4/Helpers/ThemeHelper.dart';
import 'package:debtsettler_v4/LandingPages/Models/RegistrationData_model.dart';
import 'package:debtsettler_v4/LandingPages/Services/Registration_services.dart';
import 'package:debtsettler_v4/LandingPages/Widgets/CustomButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Registration extends StatefulWidget{
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();

}

class _RegistrationState extends State<Registration>{

  final _registrationFormKey = GlobalKey<FormState>();

  final FocusNode _imeFocusNode = FocusNode();
  final FocusNode _mailFocusNode = FocusNode();
  final FocusNode _gesloFocusNode = FocusNode();
  //final FocusNode _barvaFocusNode = FocusNode();

  final TextEditingController _imeController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _gesloController = TextEditingController();
  //final TextEditingController _gesloController = TextEditingController();

  _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  _submitForm() async {
    if(_registrationFormKey.currentState!.validate()) {
      RegistrationData registrationData = RegistrationData(ime: _imeController.text, mail: _mailController.text, geslo: _gesloController.text, barva: '333444');

      bool response = await registrirajUporabnika(registrationData);

      if(response) {
        Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false);
      } else {
        _registrationFormKey.currentState!.reset();
      }

    }

  }

  @override
  void dispose() {
    _imeFocusNode.dispose();
    _mailFocusNode.dispose();
    _gesloFocusNode.dispose();
    _imeController.dispose();
    _gesloController.dispose();
    _mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: Form(
                      key: _registrationFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: size.height*0.05,),
                          Image.asset('assets/Icons/Logo.png', height: size.height*0.2, scale: 9),
                          SizedBox(height: size.height*0.02,),
                          Container(
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: ThemeHelper().textInputDecoration(
                                  lableText: 'Ime',
                                  hintText: 'Vnesite svoje ime ali vzdevek',
                                  labelColor: Colors.black,
                                  borderColor: Colors.black,
                                  hintColor: Colors.black
                              ),
                              style: const TextStyle(color: Colors.black),
                              textInputAction: TextInputAction.next,
                              controller: _imeController,
                              focusNode: _imeFocusNode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Prosimo izpolnite polje';
                                }
                                return null;
                              },
                              onFieldSubmitted: (String value) {
                                _nextFocus(_mailFocusNode);
                              },
                            ),
                            decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: size.height*0.04),
                          Container(
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: ThemeHelper().textInputDecoration(
                                  lableText: 'E-mail',
                                  hintText: 'Vnesite svoj e-mail',
                                  labelColor: Colors.black,
                                  borderColor: Colors.black,
                                  hintColor: Colors.black
                              ),
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              controller: _mailController,
                              focusNode: _mailFocusNode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Prosimo izpolnite polje';
                                } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                                  return 'Prosimo vnesite veljaven email naslov.';
                                }
                                return null;
                              },
                              onFieldSubmitted: (String value) {
                                _nextFocus(_gesloFocusNode);
                              },
                            ),
                            decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: size.height*0.04),
                          Container(
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              obscureText: true,
                              decoration: ThemeHelper().textInputDecoration(
                                  lableText: 'Geslo',
                                  hintText: 'Vnesite svoje geslo',
                                  labelColor: Colors.black,
                                  borderColor: Colors.black,
                                  hintColor: Colors.black
                              ),
                              style: const TextStyle(color: Colors.black),
                              textInputAction: TextInputAction.done,
                              controller: _gesloController,
                              focusNode: _gesloFocusNode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Prosim izpolnite polje';
                                }
                                return null;
                              },
                              onFieldSubmitted: (String value) {
                                _submitForm();
                              },
                            ),
                            decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: size.height*0.05),
                          CustomButton(
                              label: 'Registracija',
                              labelColor: Colors.white,
                              color: Colors.black,
                              borderColor: Colors.black,
                              margin: false,
                              onClick: () {
                                _submitForm();
                              }
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(10,20,10,20),
                            //child: Text('Don\'t have an account? Create'),
                            child: Text.rich(
                                TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Že imate račun? ",
                                          style: TextStyle(color: Colors.black.withOpacity(0.85))
                                      ),
                                      TextSpan(
                                        text: 'Prijavite se',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = (){
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/login',
                                                ModalRoute.withName('/landingPage'));
                                          },
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,)
                                      ),
                                    ]
                                )
                            ),
                          ),
                        ],
                      )
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

}