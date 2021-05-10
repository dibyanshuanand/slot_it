import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slot_it/models/appointment.dart';
import 'package:slot_it/router/router.dart';
import 'package:slot_it/widgets/form_button.dart';

class ConfirmDetailsScreen extends StatelessWidget {
  Map<String, String> details;

  void onConfirmPressed(BuildContext context) async {
    // DocumentReference freeSlotRef =
    //     FirebaseFirestore.instance.collection('20-03-2021').doc('free');

    // await FirebaseFirestore.instance
    //     .collection('26-04-2021')
    //     .doc('free')
    //     .set({'avail': true}).then((_) {
    //   log('Record created', name: 'ConfirmDetailsScreen -> onBookPressed');
    // });

    // showDialog(
    //   context: context,
    //   builder: (context) => LoadingDialog('Fetching from Firebase'),
    //   barrierDismissible: false,
    // );

    // await freeSlotRef.get().then((res) {
    //   log('Document received: ${res.data()}',
    //       name: 'ConfirmDetailsScreen -> onBookPressed');
    // });

    // Navigator.pop(context);

    // Navigator.pushNamed(context, Routes.TimeSlotPage); // Final Line

    Navigator.pushNamed(context, Routes.PaymentPage);
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    details = Provider.of<Appointment>(context).getCompleteData();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text(
          'Confirm your details',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        // height: screen.height,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Field('Patient Name : ', 'name'),
            Field('Phone : ', 'phone'),
            Field('Date of Birth : ', 'dob'),
            Field('Address : ', 'address'),
            SizedBox(height: 16),
            Field('Visit Type : ', 'type'),
            SizedBox(height: 16),
            Field('Appointment Date : ', 'appoint_date'),
            SizedBox(height: 42),
            FormButton(
              tapCallback: () => onConfirmPressed(context),
              btnLabel: 'Confirm',
              btnIcon: Icons.check,
              width: 145,
            ),
          ],
        ),
      ),
    );
  }

  Row Field(String labelText, String mapKey) {
    return Row(
      children: <Widget>[
        SizedBox(
          child: Text(
            labelText,
            style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF66BB6A),
            ),
          ),
          height: 40,
          width: 140,
        ),
        SizedBox(
          child: SingleChildScrollView(
            child: Text(
              details[mapKey],
              maxLines: 5,
              style: TextStyle(fontSize: 15, color: const Color(0xFF388E3C)),
            ),
          ),
          height: (labelText.contains('Add')) //&&
              // (details[mapKey].allMatches('\n').length >= 2))
              ? 65
              : 40,
        ),
      ],
    );
  }
}
