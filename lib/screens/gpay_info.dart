import 'dart:developer';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:platform/platform.dart';
import 'package:slot_it/widgets/form_button.dart';

class GPayInfoScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _vidController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final String GOOGLE_PAY_PACKAGE_NAME =
      'com.google.android.apps.nbu.paisa.user';
  final int GOOGLE_PAY_REQUEST_CODE = 123;
  final String UPI_ID = '7008287632@okbizaxis';
  final String MERCHANT_NAME = 'DEEPALI+ULTRASOUND+C';
  final String MERCHANT_ID = 'BCR2DN6TV7CM523L';
  final String TX_REF = DateTime.now().millisecondsSinceEpoch.toString();

  Widget GPayField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Enter GPay Information',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GPayField(_nameController, 'Name'),
              GPayField(_vidController, 'Virtual ID'),
              GPayField(_amountController, 'Payment Amount'),
              GPayField(_noteController, 'Notes'),
              SizedBox(height: 16),
              FormButton(
                tapCallback: () async {
                  // Do not use this constructor to create URIs for payment, does
                  // not work
                  /*Uri uri = Uri(
                    scheme: 'upi',
                    userInfo: 'pay',
                    queryParameters: {
                      'pa': 'dkdehuri@oksbi',
                      'pn': 'Dilip Kumar',
                      'tn': 'test',
                      'am': '2',
                      'cu': 'INR'
                    },
                  );*/

                  // This is the URI obatined from tested Java implementation,
                  // useful for matching with while creating URIs
                  // String matchUri = Uri.encodeFull(
                  //     'upi://pay?pa=dkdehuri%40oksbi&pn=Dilip%20Dehuri&tn=Test%20UPI%20Payment&am=5&cu=INR');

                  String newUri = Uri.encodeFull(
                      'upi://pay?pa=$UPI_ID&pn=$MERCHANT_NAME&mc=$MERCHANT_ID&tr=$TX_REF&tn=test&am=1&cu=INR');

                  log('URI: $newUri', name: 'GPayInfoScreen');
                  if (const LocalPlatform().isAndroid) {
                    AndroidIntent upiIntent = AndroidIntent(
                      action: 'action_view',
                      data: newUri,
                      // package: GOOGLE_PAY_PACKAGE_NAME,
                    );

                    // To create a chooser for user to choose among all installed
                    // UPI apps
                    await upiIntent.launchChooser('Pay with');

                    // To directly launch intent by setting package parameter
                    // await upiIntent.launch();
                  }
                },
                btnLabel: 'Pay',
                btnIcon: Icons.monetization_on,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
