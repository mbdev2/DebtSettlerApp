import 'dart:async';

import 'package:debtsettler_v4/Gospodinjstvo/Widgets/IzdelekWidget.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Widgets/TitleWidget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:debtsettler_v4/Gospodinjstvo/Services/NakupovalnaLista_services.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Models/Izdelek_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Widgets/IzdelekWidget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:math';



class NakupovalnaLista extends StatefulWidget {
  const NakupovalnaLista({
    Key? key,
    required this.gospodinjstvoKey
  }) : super(key: key);

  final String gospodinjstvoKey;

  @override
  State<NakupovalnaLista> createState() => _NakupovalnaListaState();

}

class _NakupovalnaListaState extends State<NakupovalnaLista> {

  late Future<List<Izdelek>> izdelki;
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  late final String gospodinjstvoKey = widget.gospodinjstvoKey;

  @override
  void initState() {
    super.initState();

    // initial load
    izdelki = loadIzdelki(gospodinjstvoKey);
  }

  Future<void> _refreshList() async {
    // reload
    setState(() {
      izdelki = loadIzdelki(gospodinjstvoKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(

          future: izdelki,
          builder: (BuildContext context, AsyncSnapshot<List<Izdelek>> snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              final List<Izdelek>? list = snapshot.data;
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  children: [
                    Container(
                      height:20,
                      color: Colors.white,
                    ),
                    const TitleWidget(imagePath: 'assets/Icons/ShoppingList.png', widgetHeight: 120, title: 'Nakupovalna lista', scale: 10),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 7,
                          bottom: 7,
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: SizedBox.expand(),
                              ),
                              const Expanded(
                                flex: 1,
                                child: Text("#", textAlign: TextAlign.center,),
                              ),
                              const Expanded(
                                flex: 1,
                                child: SizedBox.expand(),
                              ),
                              const VerticalDivider(
                                width: 2,
                                thickness: 1,
                                indent: 1,
                                endIndent: 1,
                                color: Colors.grey,
                              ),
                              const Expanded(
                                flex: 1,
                                child: SizedBox.expand(),
                              ),
                              const Expanded(
                                  flex: 8,
                                  child: Text("Izdelki", textAlign: TextAlign.left,)
                              ),
                              Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 27,
                                    child: IconButton(
                                      onPressed: list!.any((item) => item.isSelected) ? () {
                                        late List<Izdelek> deletedItems = [];
                                        late List<int> deletedIndex = [];

                                        setState(() {
                                          for(int i = list.length - 1; i >= 0; i--) {
                                            if (list[i].isSelected) {
                                              deletedItems.add(list[i]);
                                              deletedIndex.add(list.indexOf(list[i]));
                                              _key.currentState!.removeItem(i, (_, __) => Container());
                                            }
                                          }
                                          list.removeWhere((item) => item.isSelected);
                                        });

                                        final timer = Timer(
                                            const Duration(seconds: 3),
                                            () {
                                              izbrisiIzdelke(deletedItems, gospodinjstvoKey);
                                            }
                                        );

                                        ScaffoldMessenger.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              duration: const Duration(
                                                milliseconds: 2500,
                                              ),
                                              content: const Text("Izbrani izdelki izbrisani"),
                                              action: SnackBarAction(
                                                label: "UNDO",
                                                onPressed: () {
                                                  timer.cancel();

                                                  setState(() {
                                                    for(int i = deletedItems.length - 1; i >= 0; i--) {
                                                      list.insert(deletedIndex[i], deletedItems[i]);
                                                      _key.currentState!.insertItem(deletedIndex[i]);
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                      } : null,
                                      padding: const EdgeInsets.all(0),
                                      icon: const Icon(Icons.highlight_remove_outlined,),
                                      iconSize: 27,
                                      splashRadius: 10,
                                      color: Colors.red.shade900,
                                      disabledColor: Colors.grey,
                                      alignment: Alignment.centerRight,
                                    ),
                                  )
                              ),
                              Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 27,
                                    child: IconButton(
                                      onPressed: () {
                                        if (list.any((item) => item.isSelected)) {
                                          setState(() {
                                            list.map((izdelek) {
                                              izdelek.isSelected = false;
                                            }).toList();
                                          });
                                        } else {
                                          setState(() {
                                            list.map((izdelek) {
                                              izdelek.isSelected = true;
                                            }).toList();
                                          });
                                        }
                                      },
                                      padding: const EdgeInsets.all(0),
                                      icon: Icon(Icons.check_circle_outline, color: Colors.green.shade900,),
                                      iconSize: 27,
                                      splashRadius: 10,
                                    ),
                                  )
                              ),
                            ],
                          ),
                        )
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        child: AnimatedList(
                            key: _key,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            initialItemCount: list.length,
                            itemBuilder: (context, index, animation) {
                              return Dismissible(
                                key: ObjectKey(list[index].izdelekId),
                                child: GestureDetector(
                                    onTap: () {
                                      if (list.any((item) => item.isSelected)) {
                                        setState(() {
                                          list[index].isSelected = !list[index].isSelected;
                                        });
                                      }
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        list[index].isSelected = true;
                                      });
                                    },
                                    child: SizeTransition(
                                        sizeFactor: animation,
                                        child: IzdelekWidget(izdelek: list[index])
                                    )
                                ),
                                dismissThresholds: const {
                                  DismissDirection.startToEnd: 0.3,
                                  //DismissDirection.endToStart: 1
                                },
                                direction: DismissDirection.startToEnd,
                                background: swipeDelete,
                                onDismissed: (direction) {
                                  late List<Izdelek> deletedItem = [];

                                  setState(() {
                                    deletedItem.add(list.removeAt(index));
                                    _key.currentState!.removeItem(index, (_, __) => Container());
                                  });

                                  final timer = Timer(
                                      const Duration(seconds: 3),
                                      () {
                                        izbrisiIzdelke(deletedItem, gospodinjstvoKey);
                                      }
                                  );

                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        duration: const Duration(
                                          milliseconds: 2500,
                                        ),
                                        content: Text("Izdelek \"${deletedItem[0].izdelekIme}\" izbrisan"),
                                        action: SnackBarAction(
                                          label: "UNDO",
                                          onPressed: () {
                                            timer.cancel();
                                            setState(() => list.insert(index, deletedItem[0]));
                                            _key.currentState!.insertItem(index);
                                          },
                                        ),
                                      ),
                                    );
                                },
                              );
                            }
                        ),
                        onRefresh: _refreshList,
                      )

                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
    );
  }

}


// OZZADJA ZA SWIPE
final swipeDelete = Container(
  color: Colors.red,
  child: const Padding(
    padding: EdgeInsets.only(
        left:15,
        right: 15
    ),
    child: FractionallySizedBox(
      heightFactor: 0.5,
      child: FittedBox(
        child: Icon(Icons.delete),
        alignment: Alignment.centerLeft,
      ),
    )
  ),
  alignment: Alignment.centerLeft,
);


/*
Dismissible(
  key: ObjectKey(list[index].izdelekId),
  child: GestureDetector(
      onTap: () {
        if (list.any((item) => item.isSelected)) {
          setState(() {
            list[index].isSelected = !list[index].isSelected;
          });
        }
      },
      onLongPress: () {
        setState(() {
          list[index].isSelected = true;
        });
      },
      child: SizeTransition(
          sizeFactor: animation,
          child: IzdelekWidget(izdelek: list[index])
      )
  ),
  dismissThresholds: const {
    DismissDirection.startToEnd: 0.3,
    //DismissDirection.endToStart: 1
  },
  direction: DismissDirection.startToEnd,
  background: swipeDelete,
  onDismissed: (direction) {
    late Izdelek deletedItem;

    setState(() {
      deletedItem = list.removeAt(index);
      _key.currentState!.removeItem(index, (_, __) => Container());
    });

    final timer = Timer(
        const Duration(seconds: 3),
            () {/* KLICI API DA ZBRISE  */}
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(
            milliseconds: 2500,
          ),
          content: Text("Izdelek \"${deletedItem.izdelekIme}\" izbrisan"),
          action: SnackBarAction(
            label: "UNDO",
            onPressed: () {
              timer.cancel();
              setState(() => list.insert(index, deletedItem));
              _key.currentState!.insertItem(index);
            },
          ),
        ),
      );
  },
);
 */
