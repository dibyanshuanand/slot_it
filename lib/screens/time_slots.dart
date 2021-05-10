import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slot_it/models/appointment.dart';
import 'package:slot_it/utils/constants.dart';
import 'package:slot_it/utils/snackbar_msg.dart';
import 'package:slot_it/widgets/form_button.dart';
import 'package:slot_it/widgets/loading_dialog.dart';

class BookTimeSlot extends StatefulWidget {
  @override
  _BookTimeSlotState createState() => _BookTimeSlotState();
}

class _BookTimeSlotState extends State<BookTimeSlot> {
  String _chosenSlot = '00_00';
  bool _isLoading = true;
  TimeSlot timeSlotObj;
  Map<String, String> patientDetails;

  void setLoadingState() {
    setState(() {
      _isLoading = true;
    });
  }

  void disableLoadingState() {
    setState(() {
      _isLoading = false;
    });
  }

  Widget loadingWidget(double height) {
    return Container(
      alignment: Alignment.center,
      height: height,
      child: Column(
        children: [
          Spacer(),
          Image.asset(
            'assets/clock_loading.gif',
            width: 200,
            height: 150,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 10),
          Text('Getting free time slots ...'),
          Spacer(),
        ],
      ),
    );
  }

  Widget SlotCard(String key) {
    return InkResponse(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      containedInkWell: true,
      highlightColor: const Color(0xFFA5D6A7),
      highlightShape: BoxShape.rectangle,
      splashColor: timeSlotObj.slotStatus(key)
          ? const Color(0xFFE8F5E9)
          : const Color(0x00000000),
      child: Opacity(
        opacity: timeSlotObj.slotStatus(key) ? 1 : 0.4,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 14.0,
          ),
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.green),
            border: timeSlotObj.slotStatus(key)
                ? Border.all(color: Colors.green)
                : Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
            color: key == _chosenSlot
                ? const Color(0xFFA5D6A7)
                : const Color(0x00000000),
            //     timeSlots[key][0]
            // ? key == _chosenSlot
            //     ? const Color(0xFFA5D6A7)
            //     : const Color(0x00000000)
            // : const Color(0xFFBDBDBD),
          ),
          child: Text(
            timeSlotObj.slotTime(key),
            style: timeSlotObj.slotStatus(key)
                ? TextStyle()
                : TextStyle(color: Color(0xFF757575)),
          ),
        ),
      ),
      onTap: timeSlotObj.slotStatus(key)
          ? () {
              setState(() {
                _chosenSlot = key;
              });
              log('Chosen slot: $_chosenSlot',
                  name: 'BookTimeSlot -> SlotCard');
            }
          : () {},
    );
  }

  void getFreeTimeSlots() {
    FirebaseFirestore.instance
        .collection(Provider.of<Appointment>(context, listen: false)
            .getCompleteData()['appoint_date'])
        .where('avail', isEqualTo: false)
        .get()
        .then((querySnapshot) {
      var docList = querySnapshot.docs.toList();
      log('Document list: $docList', name: 'getFreeTimeSlots');

      docList.forEach((doc) {
        timeSlotObj.updateSlotStatus(doc.id, false);
      });
      disableLoadingState();
    });
  }

  String getNextKey(String searchKey) {
    var presentInd = 0;
    for (String key in timeSlotObj.getTimeSlots.keys) {
      if (key == searchKey) {
        return timeSlotObj.getTimeSlots.keys.elementAt(presentInd + 1);
      }
      presentInd++;
    }
  }

  Future<void> onBookPressed() async {
    var numBooking = timeSlotObj.appointLen(patientDetails['type']);
    if (_chosenSlot == '00_00') {
      log('No slot selected', name: 'BookTimeSlot -> onBookPressed');
      showSnackMsg(context, 'Select a time slot to continue');
    } else {
      showDialog(
        context: context,
        builder: (context) => LoadingDialog('Booking your appointment ... '),
        barrierDismissible: false,
      );

      DocumentReference slotRef = await FirebaseFirestore.instance
          .collection(patientDetails['appoint_date'])
          .doc(_chosenSlot);

      // var nextSlot = numBooking == 2 ? getNextKey(_chosenSlot) : null;

      await slotRef.get().then((value) async {
        if (value.exists) {
          log('Data received: ${value.data()}',
              name: 'BookTimeSlot -> onBookPressed');
          await slotRef
              .update({'avail': false})
              .then((value) => log('Slot $_chosenSlot blocked',
                  name: 'BookTimeSlot -> onBookPressed'))
              .catchError((error) {
                log(
                  'Error encountered in blocking slot in firestore: ${error.toString()}',
                  name: 'BookTimeSlot -> onBookPressed',
                );
                showSnackMsg(
                    context, 'Booking error. Try again after some time :(');
                return;
              });
        } else {
          log('Time slot does not exist in the database',
              name: 'BookTimeSlot -> onBookPressed');
          slotRef
              .set({'avail': false})
              .then((value) => log('Slot $_chosenSlot blocked',
                  name: 'BookTimeSlot -> onBookPressed'))
              .catchError((error) {
                log(
                  'Error encountered in blocking slot in firestore: ${error.toString()}',
                  name: 'BookTimeSlot -> onBookPressed',
                );
                showSnackMsg(
                    context, 'Booking error. Try again after some time :(');
                return;
              });
          log('Time slot created at $_chosenSlot',
              name: 'BookTimeSlot -> onBookPressed');
        }

        // await slotRef
        //     .update({'avail': false})
        //     .then((value) => log('Slot $_chosenSlot blocked',
        //         name: 'BookTimeSlot -> onBookPressed'))
        //     .catchError((error) {
        //       log(
        //         'Error encountered in blocking slot in firestore: ${error.toString()}',
        //         name: 'BookTimeSlot -> onBookPressed',
        //       );
        //       showSnackMsg(
        //           context, 'Booking error. Try again after some time :(');
        //       return;
        //     });

        await slotRef
            .collection('patient')
            .doc(patientDetails['phone'])
            .set(patientDetails)
            .then((value) => log('Slot Booked'))
            .catchError((error) {
          log('Error encountered in updating data: ${error.toString()}',
              name: 'BookTimeSlot -> onBookPressed');
          showSnackMsg(context, 'Booking error. Try again after some time :(');
        });
      }).catchError((error) {
        log('Error encountered in getting data: ${error.toString()}',
            name: 'BookTimeSlot -> onBookPressed');
        showSnackMsg(context, 'Booking error. Try again after some time :(');
        return;
      });

      if (numBooking == 2) {
        var nextSlot = getNextKey(_chosenSlot);
        DocumentReference nextDocRef = await FirebaseFirestore.instance
            .collection(patientDetails['appoint_date'])
            .doc(nextSlot);

        await nextDocRef.set({'avail': false}).then((value) => log(
            'Next slot at $nextSlot',
            name: 'BookTimeSlot -> onBookPressed'));

        DocumentReference patientRef = await FirebaseFirestore.instance
            .collection(patientDetails['appoint_date'])
            .doc(_chosenSlot)
            .collection('patient')
            .doc(patientDetails['phone']);

        await nextDocRef
            .collection('patient')
            .doc(patientDetails['phone'])
            .set({'ref': patientRef})
            .then((value) =>
                log('Next slot booked', name: 'BookTimeSlot -> onBookPressed'))
            .catchError((error) {
              log('Error encountered in booking extra slot: ${error.toString()}',
                  name: 'BookTimeSlot -> onBookPressed');
              showSnackMsg(
                  context, 'Booking error. Try again after some time :(');
              return;
            });
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/book-complete-screen',
        ModalRoute.withName('/home'),
      );
      // getFreeTimeSlots();
      // slotRef.set(data)
    }
  }

  @override
  void initState() {
    super.initState();
    timeSlotObj = TimeSlot();
    getFreeTimeSlots();
    patientDetails =
        Provider.of<Appointment>(context, listen: false).getCompleteData();
    // showDialog(
    //   context: context,
    //   builder: (context) => LoadingDialog('Fetching from Firebase'),
    //   barrierDismissible: false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    double scrnHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text(
          'Select time slot for appointment',
          style: TextStyle(fontSize: 15),
        ),
        // centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              _chosenSlot = '00_00';
              setLoadingState();
              getFreeTimeSlots();
            },
          ),
        ],
      ),
      body: _isLoading
          ? loadingWidget(scrnHeight)
          : Container(
              alignment: Alignment.topCenter,
              // padding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 28.0),
              padding: EdgeInsets.fromLTRB(10, 20, 10, 72),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 18,
                  children: List.generate(
                    timeSlotObj.getNumSlots,
                    (index) => SlotCard(
                        timeSlotObj.getTimeSlots.keys.elementAt(index)),
                  ),
                ),
              ),
            ),
      floatingActionButton: FormButton(
        btnLabel: 'Book',
        btnIcon: Icons.done_all,
        tapCallback: onBookPressed,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
