import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Helpers/SlideRightRoute.dart';
import '../../Home/Screens/Home.dart';
import '../../Storage/Storage_services.dart';

// INICIALZIZACIJA SAFE STORAGE-a
final storage = StorageService();

class GospodinjstvoAppBar extends StatelessWidget with PreferredSizeWidget {
  const GospodinjstvoAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: SvgPicture.asset(
            'assets/Icons/Group 6.svg',
            semanticsLabel: 'Debtsettler logo'
        ),
        tooltip: 'Click to Home Screen',
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              SlideRightRoute(page: const Home()),
              (route) => false
          );
        },
        padding: const EdgeInsets.all(15),
      ),
      leadingWidth: 120,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.account_circle,
            color: Colors.black,
            size: 30,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
                  .copyWith(topRight: Radius.circular(0))),
          padding: const EdgeInsets.all(10),
          elevation: 10,
          color: Colors.grey.shade100,
          onSelected: (value) {
            // if value 1 show dialog
            if (value == 'Odjava') {
              storage.deleteSecureData('prijavljenUporabnik');
              Navigator.pushNamedAndRemoveUntil(context, '/landingPage', (route) => false);
            } else if (value == 'account') {
              Navigator.pushNamed(context, '/userInfo');
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
                padding: const EdgeInsets.only(right: 50, left: 20),
                value: 'Odjava',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.logout,
                          size: 20,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Odjava',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                )
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
                padding: const EdgeInsets.only(right: 50, left: 20),
                value: 'account',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.settings,
                          size: 20,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Moj Račun',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                )
            ),
          ]
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}