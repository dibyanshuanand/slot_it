import 'loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class LoadingDialog extends StatelessWidget {
  final message;
  LoadingDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      children: [
        Container(
          child: Row(
            children: [
              Spacer(),
              Text('$message'),
              SizedBox(width: 10),
              LoadingIndicator(const Color(0xFF66BB6A)),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
