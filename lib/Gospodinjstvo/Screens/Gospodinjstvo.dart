import 'package:debtsettler_v4/Gospodinjstvo/Screens/AddNakup.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Screens/NakupovalnaLista.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Screens/Zgodovina.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/Gospodinjstvo_services.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Widgets/GospodinjstvoAppBar.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Widgets/GospodinjstvoButtons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/Uporabnik_services.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Models/Uporabnik_model.dart';
import '../../Storage/StorageItem_model.dart';
import '../../Storage/Storage_services.dart';
import '../Widgets/TitleWidget.dart';

// INICIALZIZACIJA SAFE STORAGE-a
final storage = StorageService();

// INICIALIZACIJA PAGEVIEW FUNKCIJE
class PageViewGospodinjstvo extends StatefulWidget {
  const PageViewGospodinjstvo({
    Key? key,
    required this.gospodinjstvoKey,
  }) : super(key: key);

  final String gospodinjstvoKey;

  @override
  _PageViewGospodinjstvoState createState() => _PageViewGospodinjstvoState();
}

class _PageViewGospodinjstvoState extends State<PageViewGospodinjstvo> {

  // PRIDOBIVANJE PODATKOV:
  late final Future<List<Uporabnik>> uporabniki;

  @override
  void initState() {
    uporabniki = getClaniGospodinjstva(widget.gospodinjstvoKey);
    super.initState();
  }


  final PageController _controller = PageController(
    initialPage: 1,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar:
        const GospodinjstvoAppBar(),
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top ),
          child: PageView(
            controller: _controller,
            children: [
              NakupovalnaLista(gospodinjstvoKey: widget.gospodinjstvoKey,),
              Gospodinjstvo(uporabniki: uporabniki, gospodinjstvoKey: widget.gospodinjstvoKey,),
              Zgodovina(uporabniki: uporabniki, gospodinjstvoKey: widget.gospodinjstvoKey,),
            ],
          ),
        )
    );
  }
}


// ZAČETNA TOČKA PAGE VIEW-a => PRIKAZ UPORABNIKOV
class Gospodinjstvo extends StatefulWidget {
  const Gospodinjstvo({Key? key, required this.uporabniki, required this.gospodinjstvoKey}) : super(key: key);
  final Future<List<Uporabnik>> uporabniki;
  final String gospodinjstvoKey;

  @override
  State<Gospodinjstvo> createState() => _GospodinjstvoState();
}

class _GospodinjstvoState extends State<Gospodinjstvo> {

  late Future<List<Uporabnik>> uporabniki = widget.uporabniki;
  late final String gospodinjstvoKey;

  @override
  void initState() {
    uporabniki = widget.uporabniki;
    gospodinjstvoKey = widget.gospodinjstvoKey;
    super.initState();
  }

  Future<void> _refreshList() async {
    // reload
    setState(() {
      uporabniki = getClaniGospodinjstva(gospodinjstvoKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height:20,
            color: Colors.white,
          ),
          TitleWidget(imagePath: 'assets/Icons/House.png', widgetHeight: 140, title: gospodinjstvoKey, scale: 15),
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyShoppingButton(uporabniki: uporabniki, gospodinjstvoKey: gospodinjstvoKey,),
                MyListButton(gospodinjstvoKey: gospodinjstvoKey),
                MyAddUserButton(gospodinjstvoKey: gospodinjstvoKey)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              top: 10,
              bottom: 10,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                alignment: Alignment.centerLeft,
                height: 30,
                width: (MediaQuery.of(context).size.width),
                child: const FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    "Stanje:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                    textScaleFactor: 5,
                  ),
                ),
              ),
            )
          ),
          Expanded(
            child: RefreshIndicator(
              child: buildUporabnikList(context, uporabniki, gospodinjstvoKey),
              onRefresh: _refreshList,
            )
          )
        ],
      ),
    );
  }

}

