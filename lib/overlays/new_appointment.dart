import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slot_it/models/appointment.dart';
import 'package:slot_it/utils/colors.dart';

class NewAppointmentDialog extends StatefulWidget {
  @override
  _NewAppointmentDialogState createState() => _NewAppointmentDialogState();
}

class _NewAppointmentDialogState extends State<NewAppointmentDialog> {
  DateTime _pickedDate;
  String _selectedDate;
  TimeOfDay _pickedTime;
  String _selectedTime;
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _commentController;
  bool _isDateFilled = false;
  bool _isTimeFilled = false;
  SharedPreferences prefs;

  Future<void> getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _selectDate(BuildContext context) async {
    unfocusField(context);
    _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (_pickedDate != null) {
      log('Selected date: $_pickedDate', name: 'NewAppointmentDialog');

      setState(() {
        _selectedDate = "${_pickedDate.toLocal()}".split(' ')[0];
        _isDateFilled = true;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    unfocusField(context);
    _pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_pickedTime != null) {
      log('Chosen Time: $_pickedTime', name: 'NewAppointmentDialog');

      setState(() {
        _selectedTime = _pickedTime.format(context);
        _isTimeFilled = true;
      });
    }
  }

  void unfocusField(BuildContext context) {
    // The below 2 lines prevent 'last name' (or last focused textfield) to get
    // focus causing keyboard to pop up again after selecting date/time
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      log('Unfocused', name: 'NewAppointmentDialog');
      currentFocus.unfocus();
    }
  }

  Future<void> createAppointment() async {
    log('Name: ${_firstNameController.text} ${_lastNameController.text}',
        name: 'NewAppointmentDialog');
    log('Date: $_selectedDate', name: 'NewAppointmentDialog');
    log('Time: $_selectedTime', name: 'NewAppointmentDialog');
    log('Comments: ${_commentController.text ?? ''}',
        name: 'NewAppointmentDialog');

    // Appointment newAppoint = Appointment(
    //   _firstNameController.text,
    //   _lastNameController.text,
    //   _selectedDate,
    //   _selectedTime,
    //   // _commentController.text ?? '',
    // );

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    List<dynamic> firebaseData = <dynamic>[];

    await users
        .doc(prefs.getString('phone'))
        .get()
        .then((DocumentSnapshot docSnapshot) {
      firebaseData = docSnapshot.data()['appointments'];
    }).catchError((error) => log('Error in reading appointments: $error'));

    // Map<String, dynamic> appointData = {
    //   'firstName': newAppoint.getFirstName,
    //   'lastName': newAppoint.getLastName,
    //   'date': newAppoint.getDate,
    //   'time': newAppoint.getTime,
    //   'comments': newAppoint.getComment
    // };

    // firebaseData.add(appointData);

    log('Number of appointments: ${firebaseData.length}',
        name: 'NewAppointmentDialog');

    await users
        .doc(prefs.getString('phone'))
        .update({'appointments': firebaseData})
        .then((value) => log('Appointment added', name: 'NewAppointmentDialog'))
        .catchError((error) => log('Failed to add appointment: $error',
            name: 'NewAppointmentDialog'));

    Fluttertoast.showToast(
      msg: 'Appointment booked',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
    );

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      children: [
        Container(
          height: 400,
          width: deviceWidth * 0.85,
          padding: EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 5.0,
          ),
          child: Column(
            children: <Widget>[
              HeadingRow(),
              SizedBox(height: 20),
              NameRow(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
              ),
              SizedBox(height: 10.0),
              dateRow(context),
              SizedBox(height: 10.0),
              timeRow(context),
              SizedBox(height: 10.0),
              commentBox(),
              Spacer(),
              bookButton()
            ],
          ),
        ),
      ],
    );
  }

  Widget bookButton() {
    return MaterialButton(
      child: Text(
        'Book',
        style: TextStyle(color: Colors.black45),
      ),
      onPressed: () => createAppointment(),
      color: Color.fromARGB(255, 222, 237, 255),
      splashColor: AppColors.secondaryColor,
      // elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    );
  }

  Widget dateRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(
          Icons.event_note,
          color: AppColors.secondaryColor,
        ),
        Container(
          width: 150,
          height: 35,
          padding: EdgeInsets.symmetric(
            vertical: 7.0,
            horizontal: 5.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.secondaryColor,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            _selectedDate ?? 'Choose date',
            style: TextStyle(
              color: _isDateFilled ? Colors.black : Colors.black54,
              fontFamily: 'SFUIDisplay',
              fontSize: 14,
            ),
          ),
        ),
        Container(
          width: 70,
          child: MaterialButton(
            onPressed: () => _selectDate(context),
            child: Icon(
              Icons.event,
              color: Colors.black45,
            ),
            color: Color.fromARGB(255, 222, 237, 255),
            splashColor: AppColors.secondaryColor,
            elevation: 1.5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
        // SizedBox(width: 45),
      ],
    );
  }

  Widget timeRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(
          Icons.watch_later,
          color: AppColors.secondaryColor,
        ),
        Container(
          width: 150,
          height: 35,
          padding: EdgeInsets.symmetric(
            vertical: 7.0,
            horizontal: 5.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.secondaryColor,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            _selectedTime ?? 'Choose time',
            style: TextStyle(
              color: _isTimeFilled ? Colors.black : Colors.black54,
              fontFamily: 'SFUIDisplay',
              fontSize: 14,
            ),
          ),
        ),
        Container(
          width: 70,
          child: MaterialButton(
            onPressed: () => _selectTime(context),
            child: Icon(
              Icons.more_time,
              color: Colors.black45,
            ),
            color: Color.fromARGB(255, 222, 237, 255),
            splashColor: AppColors.secondaryColor,
            elevation: 1.5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
        // SizedBox(width: 45),
      ],
    );
  }

  Widget commentBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(
          Icons.notes,
          color: AppColors.secondaryColor,
        ),
        Container(
          width: 210,
          height: 100,
          padding: EdgeInsets.symmetric(
            vertical: 3.0,
            horizontal: 5.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.secondaryColor,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'SFUIDisplay',
              fontSize: 14,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter comments (optional)',
            ),
            maxLines: 4,
            controller: _commentController,
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}

class NameRow extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const NameRow(
      {@required this.firstNameController, @required this.lastNameController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(
          Icons.person,
          color: AppColors.secondaryColor,
        ),
        Container(
          width: 110,
          height: 35,
          padding: EdgeInsets.symmetric(
            // vertical: 2.0,
            horizontal: 5.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.secondaryColor,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'SFUIDisplay',
              fontSize: 14,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'First Name',
            ),
            autofocus: false,
            controller: firstNameController,
          ),
        ),
        Container(
          width: 110,
          height: 35,
          padding: EdgeInsets.symmetric(
            // vertical: 2.0,
            horizontal: 5.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.secondaryColor,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'SFUIDisplay',
              fontSize: 14,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Last Name',
            ),
            controller: lastNameController,
            autofocus: false,
          ),
        ),
      ],
    );
  }
}

class HeadingRow extends StatelessWidget {
  const HeadingRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            'Enter details',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
