import "package:debtsettler_v4/Gospodinjstvo/Models/Izdelek_model.dart";
import 'package:flutter/material.dart';

class IzdelekWidget extends StatefulWidget {
  const IzdelekWidget({
    Key? key,
    required this.izdelek,
  }) : super(key: key);

  final Izdelek izdelek;

  @override
  State<IzdelekWidget> createState() => IzdelekWidgetState();

}

class IzdelekWidgetState extends State<IzdelekWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            gradient: LinearGradient(
              begin: const Alignment(-0.6, 0),
              end: const Alignment(1, 0),
              colors: [
                Colors.white,
                if (widget.izdelek.isSelected) Colors.green.withOpacity(0.4) else Colors.white,
              ],
            )
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              const Expanded(
                  flex: 1,
                  child: SizedBox.expand()
              ),
              Expanded(
                flex: 1,
                child: Text(
                  widget.izdelek.izdelekKolicina.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 21),
                  textAlign: TextAlign.center,
                ),
              ),
              const Expanded(
                  flex: 1,
                  child: SizedBox.expand()
              ),
              const VerticalDivider(
                width: 2,
                thickness: 1,
                indent: 6,
                endIndent: 6,
                color: Colors.grey,
              ),
              const Expanded(
                  flex: 1,
                  child: SizedBox.expand()
              ),
              Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.izdelek.izdelekIme,
                          style: const TextStyle(color: Colors.black, fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          widget.izdelek.izdelekOpis,
                          style: const TextStyle(color: Colors.black54, fontSize: 15),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )
                  ),
              ),
              Expanded(
                  flex: 2,
                  child: Icon(widget.izdelek.isSelected ? Icons.check : null, color: Colors.green.shade900,)
              ),
            ],
          ),
        )
    );
  }
}