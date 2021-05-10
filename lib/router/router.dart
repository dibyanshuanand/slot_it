import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slot_it/main.dart';
import 'package:slot_it/screens/book_appointment.dart';
import 'package:slot_it/screens/booking_complete.dart';
import 'package:slot_it/screens/confirm_details.dart';
import 'package:slot_it/screens/fill_appointment_details.dart';
import 'package:slot_it/screens/home.dart';
import 'package:slot_it/screens/information.dart';
import 'package:slot_it/screens/payment.dart';
import 'package:slot_it/screens/time_slots.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.MainPage:
      return CupertinoPageRoute(
        settings: settings,
        builder: (context) => MainApp(),
      );
      break;
    case Routes.HomePage:
      return CupertinoPageRoute(
        settings: settings,
        builder: (context) => HomeScreen(),
      );
      break;
    case Routes.BasicDetailsPage:
      return CupertinoPageRoute(
        settings: settings,
        builder: (context) => BookingScreen(),
      );
      break;
    case Routes.AppointDetailsPage:
      return CupertinoPageRoute(
        settings: settings,
        builder: (context) => FillAppointDetails(),
      );
      break;
    case Routes.ConfirmBookPage:
      return CupertinoPageRoute(
        settings: settings,
        builder: (context) => ConfirmDetailsScreen(),
      );
      break;
    case Routes.TimeSlotPage:
      return CupertinoPageRoute(
        settings: settings,
        builder: (context) => BookTimeSlot(),
      );
      break;
    case Routes.BookCompletePage:
      return CupertinoPageRoute(
        settings: settings,
        builder: (context) => BookComplete(),
      );
      break;
    case Routes.InformationPage:
      return CupertinoPageRoute(
        settings: settings,
        builder: (context) => InformationScreen(),
      );
    case Routes.PaymentPage:
      return CupertinoPageRoute(
        builder: (context) => PaymentScreen(),
      );
    default:
    //TODO: Navigate to error page
  }
}

class Routes {
  static const String MainPage = '/';
  static const String HomePage = '/home';
  static const String BasicDetailsPage = '/basic-details-screen';
  static const String AppointDetailsPage = '/appointment-type-screen';
  static const String ConfirmBookPage = '/confirmation-screen';
  static const String TimeSlotPage = '/time-slot-screen';
  static const String BookCompletePage = '/book-complete-screen';
  static const String PaymentPage = '/pay-screen';
  static const String InformationPage = '/info-screen';
}
