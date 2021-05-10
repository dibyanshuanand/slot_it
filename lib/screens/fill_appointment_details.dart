import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:slot_it/models/appointment.dart';
import 'package:slot_it/utils/appoint_type_coding.dart';
import 'package:slot_it/utils/snackbar_msg.dart';
import 'package:slot_it/widgets/form_button.dart';

class FillAppointDetails extends StatefulWidget {
  @override
  _FillAppointDetailsState createState() => _FillAppointDetailsState();
}

class _FillAppointDetailsState extends State<FillAppointDetails> {
  int activatedOption = 0;

  TextStyle textStyle = TextStyle(fontSize: 17);
  TextEditingController _dateController = TextEditingController();

  Widget AppointTypeButton(
      TextStyle textStyle, AppointmentType type, String price, int index) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 14),
      height: 102,
      width: 124,
      child: InkWell(
        onTap: () {
          log('${CodeAppointType.getStringType(type)} button pressed',
              name: 'AppointTypeButton');
          Provider.of<Appointment>(context, listen: false).setAppointType(type);
          setState(() {
            activatedOption = index;
          });
        },
        splashColor: const Color(0xFFE8F5E9),
        child: Container(
          // height: 75,
          // width: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
            ),
            borderRadius: BorderRadius.circular(10),
            color: index == activatedOption
                ? Color(0xFFA5D6A7)
                : Color(0x00000000),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                CodeAppointType.getStringType(type),
                style: TextStyle(fontSize: 15),
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                '\u20B9 $price',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void chooseDate() async {
    DateTime _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      // firstDate: DateTime(2021, 3, 19),
      lastDate: DateTime.now().add(Duration(days: 5)),
      helpText: 'Select date of appointment',
    );

    if (_pickedDate != null) {
      log(
        'Chosen date: ${_pickedDate?.toString()?.split(' ')[0]}',
        name: 'BookingScreen -> chooseDate',
      );

      var splitDate = _pickedDate.toString().split(' ')[0].split('-');
      String _finalTime =
          splitDate[2] + '-' + splitDate[1] + '-' + splitDate[0];

      setState(() {
        _dateController.text = _finalTime;
      });
    } else {
      log('No date selected', name: 'BookingScreen -> chooseDate');
    }
  }

  void onNextPressed() {
    if (validateInput()) {
      Provider.of<Appointment>(context, listen: false)
          .setAppointDate(_dateController.text);
      log('Data: ${Provider.of<Appointment>(context, listen: false).getCompleteData()}',
          name: 'AppointTypeButton');
      Navigator.pushNamed(context, '/confirmation-screen');
    } else {
      log('Input validation unsuccessful',
          name: 'FillAppointDetails -> onNextPressed');
      showSnackMsg(context,
          'Choice of appointment date & appointment type cannot be empty');
    }
  }

  bool validateInput() {
    if (_dateController.text.isEmpty || activatedOption == 0) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Appointment Details',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        height: screen.height,
        width: screen.width,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0, bottom: 2.0),
                  child: Text(
                    'Choose appointment date',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextField(
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'SFUIDisplay',
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 192, 222, 250),
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    // labelText: 'Appointment Date',
                    labelStyle: TextStyle(fontSize: 15),
                    // hintText: 'DD-MM-YYYY',
                  ),
                  onTap: chooseDate,
                  controller: _dateController,
                  readOnly: true,
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0, bottom: 2.0),
                  child: Text(
                    'Select appointment type',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Wrap(
                spacing: 18.0,
                children: [
                  AppointTypeButton(
                    textStyle,
                    AppointmentType.gen_check,
                    '300',
                    1,
                  ),
                  AppointTypeButton(
                    textStyle,
                    AppointmentType.gen_check_usg,
                    '1000',
                    2,
                  ),
                  AppointTypeButton(
                    textStyle,
                    AppointmentType.preg_usg,
                    '800',
                    3,
                  ),
                  AppointTypeButton(
                    textStyle,
                    AppointmentType.foll_study,
                    '400',
                    4,
                  ),
                  AppointTypeButton(
                    textStyle,
                    AppointmentType.gyna_usg,
                    '1000',
                    5,
                  ),
                  AppointTypeButton(
                    textStyle,
                    AppointmentType.growth_scan_doppler,
                    '1000',
                    6,
                  ),
                ],
              ),
              SizedBox(height: 32),
              FormButton(
                tapCallback: onNextPressed,
                btnLabel: 'Next',
                btnIcon: Icons.arrow_forward_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
