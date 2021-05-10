import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(22),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.info_outline),
            ),
            Expanded(
              // width: 200,
              child: Text(
                'You need to pay \u20B9 100 as advance payment to book appointment at the time slot of your choice',
                maxLines: 7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
