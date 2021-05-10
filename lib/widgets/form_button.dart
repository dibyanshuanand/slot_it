import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final Function tapCallback;
  final String btnLabel;
  final IconData btnIcon;
  final double width;

  const FormButton(
      {@required this.tapCallback,
      @required this.btnLabel,
      @required this.btnIcon,
      this.width = 128});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: MaterialButton(
        onPressed: tapCallback,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        color: Colors.green[300],
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              btnLabel,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(width: 8),
            Icon(btnIcon),
          ],
        ),
      ),
    );
  }
}
