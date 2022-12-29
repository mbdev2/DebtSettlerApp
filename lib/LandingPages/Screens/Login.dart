import 'package:debtsettler_v4/Helpers/ThemeHelper.dart';
import 'package:debtsettler_v4/LandingPages/Models/LoginData_model.dart';
import 'package:debtsettler_v4/LandingPages/Services/Login_services.dart';
import 'package:debtsettler_v4/LandingPages/Widgets/CustomButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Login extends StatefulWidget{
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login>{

  final _loginFormKey = GlobalKey<FormState>();

  final FocusNode _mailFocusNode = FocusNode();
  final FocusNode _gesloFocusNode = FocusNode();

  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _gesloController = TextEditingController();

  _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  _submitForm() async {
    if(_loginFormKey.currentState!.validate()) {
      LoginData loginData = LoginData(mail: _mailController.text, geslo: _gesloController.text);
      //print(loginData);

      bool response = await prijaviUporabnika(loginData);

      if(response) {
        Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false);
      } else {
        _loginFormKey.currentState!.reset();
      }

    }

  }

  @override
  void dispose() {
    _mailFocusNode.dispose();
    _gesloFocusNode.dispose();
    _mailController.dispose();
    _gesloController.dispose();
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
                    key: _loginFormKey,
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
                                return 'Prosimo izpolnite polje';
                              }
                              return null;
                            },
                            onFieldSubmitted: (String value) {
                              _submitForm();
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: size.height*0.02),
                        SizedBox(height: size.height*0.07),
                        CustomButton(
                            label: 'Prijava',
                            margin: false,
                            labelColor: Colors.white,
                            color: Colors.black,
                            borderColor: Colors.black,
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
                                      text: "Še nimate računa? ",
                                      style: TextStyle(color: Colors.black.withOpacity(0.85))
                                    ),
                                    TextSpan(
                                      text: 'Ustvari',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = (){
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '/registration',
                                              ModalRoute.withName('/landingPage'));
                                        },
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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