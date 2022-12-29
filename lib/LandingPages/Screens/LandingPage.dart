import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:debtsettler_v4/LandingPages/Widgets/CustomButton.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: size.height*0.24,),
                  Image.asset('assets/Icons/HouseLogo.png', height: size.height*0.3,),
                  SizedBox(height: size.height*0.26,),
                  SizedBox(
                    height: size.height*0.10,
                    child: CustomButton(
                      label: 'Prijava',
                      labelColor: Colors.white,
                      color: Colors.black,
                      borderColor: Colors.black,
                      onClick: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height*0.10,
                    child: CustomButton(
                      label: 'Registracija',
                      labelColor: Colors.white,
                      color: Colors.black,
                      borderColor: Colors.black,
                      onClick: () {
                        Navigator.pushNamed(context, '/registration');
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}