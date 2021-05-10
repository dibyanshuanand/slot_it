import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slot_it/router/router.dart';
import 'package:slot_it/screens/gpay_info.dart';
import 'package:slot_it/widgets/home_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference users;

  void onBookPressed(BuildContext context) {
    log('onBookPressed', name: 'HomeScreen');
    Navigator.pushNamed(context, Routes.BasicDetailsPage);
  }

  void onInfoPressed(BuildContext context) {
    log('onInfoPressed', name: 'HomeScreen');
    Navigator.pushNamed(context, Routes.InformationPage);
  }

  void onAnnouncementPressed(BuildContext context) {
    log('onAnnouncementPressed', name: 'HomeScreen');
  }

  void onContactPressed(BuildContext context) {
    log('onContactPressed', name: 'HomeScreen');
  }

  void onAboutPressed(BuildContext context) {
    log('onAboutPressed', name: 'HomeScreen');
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => GPayInfoScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    users = FirebaseFirestore.instance.collection('users');
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 150,
            width: screen.width * 0.8,
            margin: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: screen.width * 0.1,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.green,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: Text('Photo Here'),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                // spacing: 10.0,
                // runSpacing: 20.0,
                // direction: Axis.vertical,
                // alignment: WrapAlignment.center,
                children: <Widget>[
                  HomeCard(
                    Icons.pending_actions_rounded,
                    'Book an appointment',
                    Colors.lightGreen[50],
                    () => onBookPressed(context),
                  ),
                  HomeCard(
                    Icons.info,
                    'Information',
                    Colors.lightGreen[50],
                    () => onInfoPressed(context),
                  ),
                  HomeCard(
                    Icons.announcement_rounded,
                    'Announcements',
                    Colors.lightGreen[50],
                    () => onAnnouncementPressed(context),
                  ),
                  HomeCard(
                    Icons.contact_page_rounded,
                    'Contact Us',
                    Colors.lightGreen[50],
                    () => onContactPressed(context),
                  ),
                  HomeCard(
                    Icons.lightbulb_outline_rounded,
                    'About Us',
                    Colors.lightGreen[50],
                    () => onAboutPressed(context),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
