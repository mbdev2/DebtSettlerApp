import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key? key,
    required this.imagePath,
    required this.widgetHeight,
    required this.title,
    required this.scale,
  }) : super(key: key);

  final String imagePath;
  final double widgetHeight;
  final String title;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widgetHeight,
          color: Colors.white,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                  child: Image.asset(imagePath, fit: BoxFit.none, scale: scale,)
              ),
              Positioned(
                  bottom: -20,
                  left: 15,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(100)
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),
                              )
                            ],
                          )
                        )
                      )
                  )
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

}
