import 'package:debtsettler_v4/Gospodinjstvo/Models/AddIzdelekData_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/AddIzdelek_services.dart';
import 'package:debtsettler_v4/Helpers/ThemeHelper.dart';
import 'package:debtsettler_v4/LandingPages/Models/LoginUporabnik_model.dart';
import 'package:debtsettler_v4/LandingPages/Widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../Services/AddUser_service.dart';


class AddUser extends StatefulWidget {
  const AddUser({
    Key? key,
    required this.gospodinjstvoKey,
  }) : super(key: key);

  final String gospodinjstvoKey;

  @override
  _AddUserState createState() => _AddUserState();

}

class _AddUserState extends State<AddUser>{

  // INICIALIZACIJA SPREMENLJIVK ZA CONTROLLER
  final _artikelFormKey = GlobalKey<FormState>();

  final TextEditingController _mailController = TextEditingController();



  _submitForm() async {
    if (_artikelFormKey.currentState!.validate()) {


      bool response = await dodajUporabnika(_mailController.text, widget.gospodinjstvoKey);

      if(response) {
        _artikelFormKey.currentState!.reset();
        print("Uporabnik z mailom ${_mailController.text} uspešno dodan");
      } else {
        print("Dodajanje uporabnika neuspešno");
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
            tag: 'addUserIcon',
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
                          icon: SvgPicture.asset(
                            'assets/Icons/user-plus-solid.svg',
                            color: Colors.white,
                          ),
                          iconSize: 5,
                          padding: const EdgeInsets.all(8),
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
                      'Dodajte uporabnike',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                SizedBox(height: size.height*0.04,),


//======================= MAIL ===========================================================================
                Container(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: ThemeHelper().textInputDecoration(
                        lableText: 'E-mail',
                        hintText: 'Vnesite e-mail uporabnika',
                        labelColor: Colors.black,
                        borderColor: Colors.black,
                    ),
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: _mailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Prosim izpolnite polje';
                      } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                        return 'Prosim vnesite veljaven email naslov.';
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

//======================= GUMB ZA ODDAJO ===========================================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Container(
                    decoration: ThemeHelper().customButtonContainerShadow(),
                    child: CustomButton(
                        label: 'Dodaj uporabnika'.toUpperCase(),
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