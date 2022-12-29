
import 'package:debtsettler_v4/Gospodinjstvo/Models/AddNakupData_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Models/Uporabnik_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Screens/Gospodinjstvo.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/AddNakup_services.dart';
import 'package:debtsettler_v4/Helpers/DecimalTextInputFormatter.dart';
import 'package:debtsettler_v4/Helpers/PrijavljenUporabnikNaVrhHelper.dart';
import 'package:debtsettler_v4/Helpers/ThemeHelper.dart';
import 'package:debtsettler_v4/LandingPages/Models/LoginUporabnik_model.dart';
import 'package:debtsettler_v4/LandingPages/Widgets/CustomButton.dart';
import 'package:debtsettler_v4/Storage/Storage_services.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// INICIALZIZACIJA SAFE STORAGE-a
final storage = StorageService();

class AddNakup extends StatefulWidget {
  const AddNakup({Key? key, required this.uporabniki, required this.gospodinjstvoKey}) : super(key: key);

  final List<Uporabnik> uporabniki;
  final String gospodinjstvoKey;

  @override
  _AddNakupState createState() => _AddNakupState();

}

class _AddNakupState extends State<AddNakup>{

  late List<Uporabnik> uporabniki = widget.uporabniki;
  late final String gospodinjstvoKey = widget.gospodinjstvoKey;


  // INICIALIZACIJA SPREMENLJIVK ZA KONTROLIRANJE FORM-a
  final _nakupFormKey = GlobalKey<FormState>();

  final FocusNode _trgovinaFocusNode = FocusNode();
  final FocusNode _opisFocusNode = FocusNode();
  final FocusNode _znesekFocusNode = FocusNode();

  final TextEditingController _trgovinaController = TextEditingController();
  final TextEditingController _opisController = TextEditingController();
  final TextEditingController _znesekController = TextEditingController();
  String? _kategorijaController = 'Trgovina';
  bool _usersSwitchController = true;
  late List<bool> _usersCheckboxController;


  // INICIALIZACIJA STANJA
  @override
  void initState() {
    _usersCheckboxController = List.generate(uporabniki.length, (index) => true, growable: false);

    super.initState();
  }

  // FUNKCIJE ZA UPRAVLJANJE FORMA
  _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  _submitForm() async {
    if(_nakupFormKey.currentState!.validate()) {

      // FORMATIRANJE PODATKOV
      String kategorija = 'Trgovina';
      if (_kategorijaController != null) {
        kategorija = _kategorijaController!;
      }

      String opis = '/';
      if (_opisController.text.isNotEmpty) {
        opis = _opisController.text;
      }

      double znesek = double.parse(_znesekController.text);

      List<String> idTabela = [];
      if (_usersSwitchController) {
        for (final uporabnik in uporabniki.sublist(1, uporabniki.length)) {
          idTabela.add(uporabnik.upVGosID);
        }
      } else {
        for (var index = 0; index<uporabniki.length;index++) {
          _usersCheckboxController[index] ? idTabela.add(uporabniki.sublist(1, uporabniki.length)[index].upVGosID) : null;
        }
      }

      AddNakupData novNakup = AddNakupData(
          kategorijaNakupa: kategorije.indexOf(kategorija),
          imeTrgovine: _trgovinaController.text,
          opisNakupa: opis,
          znesekNakupa: znesek,
          tabelaUpVGos: idTabela,
      );

      bool response = await vnesiNakup(novNakup, gospodinjstvoKey);

      if(response) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageViewGospodinjstvo(gospodinjstvoKey: gospodinjstvoKey,))
        );
      } else {
        _nakupFormKey.currentState!.reset();
      }
    }
  }

  @override
  void dispose() {
    _opisFocusNode.dispose();
    _trgovinaFocusNode.dispose();
    _znesekFocusNode.dispose();
    super.dispose();
  }

  // KATEGORIJE NAKUPOV:
  final kategorije = ['Trgovina', 'Restavracija & Cafe', 'Pijača', 'Prevozi', 'Najemnina', 'Zabava', 'Aktivnosti', 'Računi', 'Ostalo'];


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
        leading: Hero(
          tag: 'shoppingIcon',
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
                        icon: const Icon(Icons.shopping_cart_outlined),
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
            key: _nakupFormKey,
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
                      'Dodajte nakup',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height*0.04,),

//======================= TRGOVINA & ZNESEK ===========================================================================
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: ThemeHelper().textInputDecoration(
                            lableText: 'Trgovina',
                            hintText: 'Vnesite ime trgovine',
                            labelColor: Colors.black,
                            borderColor: Colors.black,
                          ),
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          controller: _trgovinaController,
                          focusNode: _trgovinaFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Prosim izpolnite polje';
                            }
                            return null;
                          },
                          onFieldSubmitted: (String value) {
                            _nextFocus(_znesekFocusNode);
                          },
                        ),
                        decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      ),
                    ),

//======================= ZNESEK ===========================================================================
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: ThemeHelper().textInputDecoration(
                            lableText: 'Znesek',
                            hintText: '123',
                            labelColor: Colors.black,
                            borderColor: Colors.black,
                          ),
                          style: const TextStyle(color: Colors.black),
                          inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          // keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: _znesekController,
                          focusNode: _znesekFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Izpolnite';
                            }
                            return null;
                          },
                          onFieldSubmitted: (String value) {
                            _nextFocus(_opisFocusNode);
                          },
                        ),
                        decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height*0.02),

//======================= OPIS NAKUPA ===========================================================================
                Container(
                  child: TextFormField(
                    decoration: ThemeHelper().textInputDecoration(
                      lableText: 'Opis',
                      hintText: 'Po želji vnesite opis nakupa',
                      labelColor: Colors.black,
                      borderColor: Colors.black,
                    ),
                    style: const TextStyle(color: Colors.black),
                    textInputAction: TextInputAction.done,
                    controller: _opisController,
                    focusNode: _opisFocusNode,
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

//======================= KATEGORIJA ===========================================================================
                Container(
                  child: DropdownButtonFormField<String>(
                    decoration: ThemeHelper().textInputDecoration(
                      lableText: 'Kategorija',
                      hintText: 'Izberite kategorijo nakupa',
                      labelColor: Colors.black,
                      borderColor: Colors.black,
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      return null;
                    },
                    items: kategorije.map(buildKategorijaListItem).toList(),
                    onChanged: (value) {
                      _kategorijaController = value;
                    },
                  ),
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),

                SizedBox(height: size.height*0.03),

//======================= POZARDELITEV MED ČLANE ===========================================================================
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  height: size.height*0.03,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const FittedBox(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Člani:',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Switch(
                        value: _usersSwitchController,
                        activeTrackColor: Colors.green.withOpacity(0.4),
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() {
                            _usersSwitchController = value;
                          });
                        }
                      ),
                    ],
                  )
                ),
                SizedBox(height: size.height*0.01,),

                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: (uporabniki.length>6) ? size.width/2 : size.width,
                      mainAxisExtent: size.height*0.08,
                    ),

                    itemCount: uporabniki.length,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        child: Opacity(
                          opacity: (index==0) ? 0.4 : 1.0,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: const BorderSide(color: Colors.black, width: 1),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CheckboxListTile(
                                activeColor: Colors.black,
                                selected: _usersCheckboxController[index] || _usersSwitchController,
                                selectedTileColor: Colors.green.withOpacity(0.5),
                                title: Text(uporabniki[index].ime),
                                controlAffinity: ListTileControlAffinity.trailing,
                                value: _usersCheckboxController[index] || _usersSwitchController,
                                onChanged: (value) {
                                  setState(() {
                                    (index==0) ?
                                    null :
                                    _usersSwitchController ?
                                    _usersCheckboxController[index] = true :
                                    _usersCheckboxController[index] = value!;
                                  });
                                }
                            ),
                          ),
                        )
                      );
                    }
                  ),
                ),





//======================= GUMB ZA ODDAJO ===========================================================================
                Container(
                  decoration: ThemeHelper().customButtonContainerShadow(),
                  child: CustomButton(
                      label: 'Vnesi nakup'.toUpperCase(),
                      margin: false,
                      onClick: () {
                        _submitForm();
                      }
                  ),
                ),

                SizedBox(height: size.height*0.03,),
              ],
            )
        ),
      )
    );
  }

}
