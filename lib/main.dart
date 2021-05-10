import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slot_it/models/appointment.dart';
import 'package:slot_it/overlays/new_appointment.dart';
import 'package:slot_it/screens/book_appointment.dart';
import 'package:slot_it/screens/booking_complete.dart';
import 'package:slot_it/screens/confirm_details.dart';
import 'package:slot_it/screens/home.dart';
import 'package:slot_it/screens/login.dart';
import 'package:slot_it/screens/fill_appointment_details.dart';
import 'package:slot_it/screens/time_slots.dart';
import 'package:slot_it/router/router.dart' as router;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Appointment(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.white,
          primaryColor: Colors.lightGreen, //const Color(0xffff607e),
          // secondaryHeaderColor: const Color.fromARGB(255, 192, 222, 250),
        ),
        title: 'Slot It',
        onGenerateRoute: router.generateRoute,
        initialRoute: '/',
        // routes: {
        //   '/': (context) => MainApp(),
        //   '/home': (context) => HomeScreen(),
        //   '/new_appoint_dialog': (context) => NewAppointmentDialog(),
        //   '/basic-details-screen': (context) => BookingScreen(),
        //   '/appointment-type-screen': (context) => FillAppointDetails(),
        //   '/confirmation-screen': (context) => ConfirmDetailsScreen(),
        //   '/time-slot-screen': (context) => BookTimeSlot(),
        //   '/book-complete-screen': (context) => BookComplete(),
        // },
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInOne(),
    );
  }
}
