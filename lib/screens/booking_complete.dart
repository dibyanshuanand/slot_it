import 'package:flutter/material.dart';
import 'package:slot_it/widgets/form_button.dart';

class BookComplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Spacer(),
              Image.asset(
                'assets/complete_tick_once.gif',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 15),
              Text(
                'Your appointment is booked',
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              FormButton(
                btnLabel: 'Done',
                btnIcon: Icons.navigate_next,
                tapCallback: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
