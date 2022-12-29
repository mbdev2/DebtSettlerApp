import 'package:debtsettler_v4/Helpers/ThemeHelper.dart';
import 'package:debtsettler_v4/Home/Models/Gospodinjstvo_model.dart';
import 'package:debtsettler_v4/LandingPages/Models/LoginData_model.dart';
import 'package:debtsettler_v4/LandingPages/Services/Login_services.dart';
import 'package:debtsettler_v4/LandingPages/Widgets/CustomButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Gospodinjstvo/Screens/Gospodinjstvo.dart';
import '../Models/AddGospodinjstvoData_model.dart';
import '../Services/Home_services.dart';

class AddGospodinjstvoForm extends StatefulWidget{
  const AddGospodinjstvoForm({Key? key}) : super(key: key);

  @override
  _AddGospodinjstvoFormState createState() => _AddGospodinjstvoFormState();

}

class _AddGospodinjstvoFormState extends State<AddGospodinjstvoForm>{

  final _createFormKey = GlobalKey<FormState>();


  final FocusNode _imeFocusNode = FocusNode();
  final FocusNode _gesloFocusNode = FocusNode();

  final TextEditingController _imeController = TextEditingController();
  final TextEditingController _gesloController = TextEditingController();

  _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  _submitForm() async {
    if(_createFormKey.currentState!.validate()) {
      AddGospodinjstvoData createData = AddGospodinjstvoData(imeGospodinjstva: _imeController.text, geslo: _gesloController.text);

      GospodinjstvoModel dodanoGospodinjstvo = await createGospodinjstvo(createData);

      _createFormKey.currentState!.reset();

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PageViewGospodinjstvo(gospodinjstvoKey: dodanoGospodinjstvo.imeGospodinjstva,))
      );

    }

  }

  @override
  void dispose() {
    _imeFocusNode.dispose();
    _gesloFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 30, left: 30),
          child: Form(
              key: _createFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: size.height*0.03,),
                  Container(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: ThemeHelper().textInputDecoration(lableText: 'Ime Gospodinjstva', hintText: 'Vnesite svoj e-mail', labelColor: Colors.black, hintColor: Colors.black, borderColor: Colors.black),
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
                        _nextFocus(_gesloFocusNode);
                      },
                    ),
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                  ),
                  SizedBox(height: size.height*0.02),
                  Container(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: true,
                      decoration: ThemeHelper().textInputDecoration(lableText: 'Geslo', hintText: 'Vnesite svoje geslo', labelColor: Colors.black, hintColor: Colors.black, borderColor: Colors.black, ),
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
                  CustomButton(
                      label: 'Ustvari',
                      margin: false,
                      color: Colors.grey.shade800,
                      labelColor: Colors.white,
                      onClick: () {
                        _submitForm();
                      }
                  ),
                  SizedBox(height: size.height*0.02),
                ],
              )
          ),
        )
    );
  }

}