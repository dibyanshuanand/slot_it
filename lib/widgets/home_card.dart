import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final IconData headIcon;
  final String headText;
  final Color cardColor;
  final void Function() onTapReceived;

  const HomeCard(
    this.headIcon,
    this.headText,
    this.cardColor,
    this.onTapReceived,
  );

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        // color: cardColor,
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: InkWell(
          onTap: onTapReceived,
          child: Container(
            height: 55.0,
            width: screen.width * 0.75,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.5, 0.8],
                colors: <Color>[
                  const Color(0xFFAED581),
                  const Color(0xFFC5E1A5),
                  const Color(0xFFDCEDC8),
                  // Colors.lightGreen[400],
                ],
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Icon(
                    headIcon,
                    size: 30,
                    color: Color(0xFF43A047),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      headText,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green[900],
                      ),
                      // GoogleFonts.overlock(
                      //   textStyle: TextStyle(
                      //     fontSize: 18,
                      //     color: Colors.green[900],
                      //   ),
                      // ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
