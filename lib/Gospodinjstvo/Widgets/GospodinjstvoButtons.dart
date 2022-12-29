import 'package:debtsettler_v4/Gospodinjstvo/Models/Uporabnik_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Screens/AddIzdelek.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Screens/AddNakup.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Screens/AddUser.dart';
import 'package:debtsettler_v4/Helpers/PrijavljenUporabnikNaVrhHelper.dart';
import 'package:debtsettler_v4/LandingPages/Models/LoginUporabnik_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyShoppingButton extends StatelessWidget {

  const MyShoppingButton({
    Key? key,
    required this.uporabniki,
    required this.gospodinjstvoKey
  }) : super(key: key);

  final Future<List<Uporabnik>> uporabniki;
  final String gospodinjstvoKey;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'shoppingIcon',
      child: Material(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.grey.shade800,
              child: FutureBuilder(
                future: prijavljenFutureUporabnikNaZacetek(uporabniki),
                builder: (BuildContext context, AsyncSnapshot<List<Uporabnik>> snapshot) {
                  return IconButton(
                    onPressed: () {
                      (snapshot.connectionState == ConnectionState.done && snapshot.data != null) ?
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddNakup(uporabniki: snapshot.data!, gospodinjstvoKey: gospodinjstvoKey,))
                        ) :
                        null;
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                    iconSize: 45,
                    padding: const EdgeInsets.all(15),
                    color: Colors.white
                  );
                },
              )
            )
        ),
      ),
    );
  }
}

class MyListButton extends StatelessWidget {

  const MyListButton({
    Key? key,
    required this.gospodinjstvoKey
  }) : super(key: key);

  final String gospodinjstvoKey;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'listIcon',
      child: Material(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
                color: Colors.grey.shade800,
                child: FutureBuilder(
                  future: getPrijavljenUporabnik(),
                  builder: (BuildContext context, AsyncSnapshot<LoginUporabnik> snapshot) {
                    return IconButton(
                        onPressed: () {
                          (snapshot.connectionState == ConnectionState.done && snapshot.data != null) ?
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddIzdelek(prijavljenUporabnik: snapshot.data!, gospodinjstvoKey: gospodinjstvoKey,))
                          ) :
                          null;
                        },
                        icon: const Icon(Icons.checklist),
                        iconSize: 45,
                        padding: const EdgeInsets.all(15),
                        color: Colors.white
                    );
                  },
                )
            )
        ),
      ),
    );
  }
}


class MyAddUserButton extends StatelessWidget {

  const MyAddUserButton({
    Key? key,
    required this.gospodinjstvoKey
  }) : super(key: key);

  final String gospodinjstvoKey;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'addUserIcon',
      child: Material(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
                color: Colors.grey.shade800,
                child: FutureBuilder(
                  future: getPrijavljenUporabnik(),
                  builder: (BuildContext context, AsyncSnapshot<LoginUporabnik> snapshot) {
                    return IconButton(
                        onPressed: () {
                          (snapshot.connectionState == ConnectionState.done && snapshot.data != null) ?
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddUser(gospodinjstvoKey: gospodinjstvoKey,))
                          ) :
                          null;
                        },
                        icon: SvgPicture.asset(
                          'assets/Icons/user-plus-solid.svg',
                          color: Colors.white,
                        ),
                        iconSize: 45,
                        padding: const EdgeInsets.all(15),
                        color: Colors.white
                    );
                  },
                )
            )
        ),
      ),
    );
  }
}