import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  String? label;
  Function onClick;
  Color color;
  Color? highlight;
  Widget? icon;
  Color borderColor;
  Color labelColor;
  double borderWidth;
  bool margin;

  CustomButton({
    this.label,
    this.labelColor = Colors.black,
    this.color = Colors.white,
    this.highlight = Colors.grey,
    this.icon,
    this.borderColor = Colors.transparent,
    this.borderWidth = 4,
    this.margin = true,
    required this.onClick });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ? const EdgeInsets.only(left: 20, right: 20, bottom: 20) : null,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Material(
            color: this.color,
            child: InkWell(
              splashColor: this.highlight!.withOpacity(0.2),
              highlightColor: this.highlight!.withOpacity(0.2),
              onTap: () {
                this.onClick();
              },
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: this.borderColor,
                          width: this.borderWidth)
                  ),
                  child: this.icon == null ?
                  Text(this.label!,
                      style: TextStyle(
                          fontSize: 16,
                          color: this.labelColor,
                          fontWeight: FontWeight.bold)) :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      this.icon!,
                      SizedBox(width: 10),
                      Text(this.label!,
                          style: TextStyle(
                              fontSize: 16,
                              color: this.labelColor,
                              fontWeight: FontWeight.bold)),
                    ],
                  )
              ),
            ),
          )),
    );
  }
}