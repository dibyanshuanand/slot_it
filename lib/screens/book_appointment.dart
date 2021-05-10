import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:slot_it/models/appointment.dart';
import 'package:slot_it/utils/snackbar_msg.dart';
import 'package:slot_it/widgets/form_button.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _dobController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  void onNextPressed() {
    if (validateForm()) {
      Provider.of<Appointment>(context, listen: false).setBasicDetails(
          _nameController.text,
          _phoneController.text,
          _dobController.text,
          _addressController.text);

      log(
        'Data: ${Provider.of<Appointment>(context, listen: false).getBasicData()}',
        name: 'BookingScreen -> onNextPressed',
      );

      Navigator.pushNamed(context, '/appointment-type-screen');
    } else {
      log('Form validation unsuccessful',
          name: 'BookingScreen -> onNextPressed');
      showSnackMsg(context, 'Form fields cannot be empty');
    }
  }

  bool validateForm() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _addressController.text.isEmpty) {
      log('Details not complete', name: 'BookingScreen -> validateForm');
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double scrnHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book an appointment',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        height: scrnHeight,
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    BookField(
                      'Patient Name',
                      'Enter full name of patient',
                      _nameController,
                      inputType: TextInputType.name,
                      caps: TextCapitalization.words,
                    ),
                    BookField(
                      'Phone Number',
                      'Enter your phone number',
                      _phoneController,
                      inputType: TextInputType.phone,
                      maxLen: 10,
                    ),
                    BookField(
                      'Date of Birth',
                      'DD-MM-YYYY',
                      _dobController,
                      popDateChooser: () => chooseDate(context),
                      readOnly: true,
                    ),
                    AddressField(
                      'Address',
                      'Enter your address',
                      _addressController,
                    ),
                  ],
                ),
              ),
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

  Future<void> chooseDate(BuildContext context) async {
    // DateTime _pickedDate = await showDatePicker(
    //   context: context,
    //   initialDate: DateTime.now().add(Duration(days: 1)),
    //   firstDate: DateTime.now().add(Duration(days: 1)),
    //   lastDate: DateTime.now().add(Duration(days: 3)),
    // );

    DateTime _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1920, 1, 1),
      lastDate: DateTime.now().subtract(Duration(days: 30)),
      helpText: 'Select Date of Birth',
      initialDatePickerMode: DatePickerMode.year,
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
        _dobController.text = _finalTime;
      });
    } else {
      log('No date selected', name: 'BookingScreen -> chooseDate');
    }
  }

  Widget BookField(
      String label, String hint, TextEditingController textController,
      {TextInputType inputType = TextInputType.text,
      Function popDateChooser,
      bool readOnly = false,
      TextCapitalization caps = TextCapitalization.none,
      int maxLen}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
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
          labelText: label,
          labelStyle: TextStyle(fontSize: 15),
          hintText: hint,
        ),
        onTap: popDateChooser ?? () {},
        controller: textController,
        readOnly: readOnly,
        keyboardType: inputType,
        textCapitalization: caps,
        maxLength: maxLen,
        validator: (String value) {
          if (label.contains('Phone')) {
            return (value.length < 10) ? 'Invalid phone number' : null;
          }
          return (value.isEmpty) ? 'Field cannot be empty' : null;
        },
      ),
    );
  }

  Widget AddressField(
      String label, String hint, TextEditingController textController) {
    return Container(
      constraints: BoxConstraints.expand(height: 200),
      padding: const EdgeInsets.all(16.0),
      height: 200,
      child: TextFormField(
        // expands: true,
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
          labelText: label,
          labelStyle: TextStyle(fontSize: 15),
          hintText: hint,
        ),
        minLines: 3,
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.words,
        controller: textController,
      ),
    );
  }
}
