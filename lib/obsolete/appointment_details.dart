/// THIS IS OLD FILE.
///  !!!!!!!!!!!!!!!!!!!!!    DO NOT REFERNCE OR USE    !!!!!!!!!!!!!!!!!!!!!

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentDetails extends StatefulWidget {
  @override
  _AppointmentDetailsState createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  List<dynamic> firebaseData = [];
  SharedPreferences prefs;
  bool _isDataLoaded = false;

  void toggleLoading() {
    setState(() {
      _isDataLoaded = !_isDataLoaded;
    });
  }

  Future<void> getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> getDetails() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    prefs = await SharedPreferences.getInstance();
    log('SharedPreferences instantiated');
    await users
        .doc(prefs.getString('phone'))
        .get()
        .then((DocumentSnapshot docSnapshot) {
      firebaseData = docSnapshot.data()['appointments'];
      log('Number of appointments: ${firebaseData.length}');
      toggleLoading();
    }).catchError((error) => log('Error in reading appointments: $error'));
  }

  @override
  void initState() {
    super.initState();
    //getSharedPrefs();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return _isDataLoaded
        ? ListView.builder(
            itemCount: firebaseData.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(firebaseData[index]['firstName']),
              );
            },
          )
        : Center(child: CircularProgressIndicator());
  }
}
