import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:crypto/crypto.dart';
// import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slot_it/widgets/loading_indicator.dart';

class SignInOne extends StatefulWidget {
  @override
  _SignInOneState createState() => _SignInOneState();
}

class _SignInOneState extends State<SignInOne> {
  TextEditingController _phoneController;
  TextEditingController _passwordController;
  bool _initialized = true;
  bool _error = false;
  bool _isSignInLoading = false;
  bool _isWrongPassVisible = false;
  bool _isAccountErrVisible = false;
  CollectionReference users;
  SharedPreferences prefs;

  // To store VerificationId from various callbacks of verifyPhoneNumber
  String actualCode;

  FirebaseAuth auth;

  void _toggleLoad() {
    setState(() {
      _isSignInLoading = !_isSignInLoading;
    });
  }

  void _toggleWrongPass() {
    setState(() {
      _isWrongPassVisible = !_isWrongPassVisible;
    });
  }

  void _toggleAccountErr() {
    setState(() {
      _isAccountErrVisible = !_isAccountErrVisible;
    });
  }

  Future<void> getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      log('Firebase initialized', name: 'SignInOne');
      setState(() {
        _initialized = true;
      });
      users = FirebaseFirestore.instance.collection('users');
      auth = FirebaseAuth.instance;
    } catch (e) {
      log('Error in Firebase: ${e.toString()}', name: 'SignInOne');
      setState(() {
        _error = true;
      });
    }
  }

  Future<void> onSignInPressed(BuildContext context) async {
    if (_isWrongPassVisible) _toggleWrongPass();
    if (_isAccountErrVisible) _toggleAccountErr();
    _toggleLoad();
    log('onSignInPressed triggered', name: 'SignInOne');

    /// Hashing to SHA-512 using crypto2.1.5
    // var bytes = utf8.encode(_passwordController.text);
    // var digest = sha512.convert(bytes);
    // log('Password as bytes: ${digest.bytes}', name: 'SignInOne');
    // log('Password as hex string: $digest', name: 'SignInOne');

    /// Hashing to BCrypt using dbcrypt1.0.0
    // var hashedPassword = DBCrypt().hashpw('pass', DBCrypt().gensalt());
    // log('DBCrypt hashed password: $hashedPassword', name: 'SignInOne');
    // bool isCorrect =
    //     DBCrypt().checkpw(_passwordController.text, hashedPassword);
    // if (isCorrect)
    //   log('DBCrypt password matches!', name: 'SignInOne');
    // else
    //   log('DBCrypt pass does not match', name: 'SignInOne');

    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     print('${doc.id} ${doc.data()}');
    //   });
    //   _toggleLoad();
    // });

    // Last used from here
    /*await users
        .doc(_phoneController.text)
        .get()
        .then((DocumentSnapshot docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data();
        log('Hashed password from Firestore: ${data['password']}',
            name: 'SignInOne');
        log('Password: ${DBCrypt().hashpw('1234', DBCrypt().gensalt())}',
            name: 'SignInOne');
        if (DBCrypt().checkpw(_passwordController.text, data['password'])) {
          prefs.setString('phone', _phoneController.text);
          Navigator.pushReplacementNamed(context, '/home');
          log('Logged in', name: 'SignInOne');
        } else {
          if (!_isWrongPassVisible) {
            _toggleWrongPass();
          }
          log('Something went wrong', name: 'SignInOne');
        }
      } else {
        if (!_isAccountErrVisible) {
          _toggleAccountErr();
        }
        log('No document found', name: 'SignInOne');
      }
    });

    _toggleLoad();*/
  }

  Future<void> _getOtpPressed() async {
    log('Phone number receieved: +91${_phoneController.text}',
        name: 'SignInOne -> _getOtpPressed');

    showLoadingDialog(context, 'Auto-verifying OTP ...');
    await auth.verifyPhoneNumber(
      phoneNumber: '+91${_phoneController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        log('verificationCompleted called', name: 'PhoneAuth');

        // showLoadingDialog(context, 'Auto-verifying OTP ...');
        await auth.signInWithCredential(credential).then((value) {
          if (value.user != null) {
            log('Authentication successful', name: 'verificationCompleted');
            Navigator.pop(context);
            _onAuthenticationSuccessful();
          } else {
            log('Invalid code/invalid authentication',
                name: 'verificationCompleted');
            Navigator.pop(context);
          }
        }).catchError((error) {
          log('Something has gone wrong: $error',
              name: 'verificationCompleted');
          Navigator.popUntil(context, ModalRoute.withName('/'));
        });
        // log('Credential: ${credential.token}', name: 'SignInOne');
        // Navigator.pushReplacementNamed(context, '/home');
      },
      verificationFailed: (FirebaseAuthException e) {
        log('verificationFailed called', name: 'PhoneAuth');

        if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid Phone Number')),
          );
          log(e.message, name: 'SignInOne');
        }

        if (e.message.contains('not authorized')) {
          log(
            'verificationFailed: Something has gone wrong, please try later \n ${e.message}',
            name: 'SignInOne',
          );
        } else if (e.message.contains('Network')) {
          log(
            'verificationFailed: Please check your internet connection and try again',
            name: 'SignInOne',
          );
        } else {
          log(
            'verificationFailed: Something has gone wrong, please try later \n ${e.message}',
            name: 'SignInOne',
          );
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        log('codeSent called', name: 'PhoneAuth');

        actualCode = verificationId;
        log('Code sent to ${_phoneController.text}', name: 'SignInOne');
        log('Enter OTP', name: 'SignInOne -> codeSent');

        _signInWithPhoneNumber(context);

        // PhoneAuthCredential credential = PhoneAuthProvider.credential(
        //   verificationId: verificationId,
        //   smsCode: _passwordController.text,
        // );

        // await auth.signInWithCredential(credential);
        // log('Credential: ${credential.token}', name: 'SignInOne');
        // Navigator.pushReplacementNamed(context, '/home');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log('codeAutoRetrievalTimeout called', name: 'PhoneAuth');

        actualCode = verificationId;

        Navigator.popUntil(context, ModalRoute.withName('/'));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Cannot auto-resolve OTP. Please enter OTP manually')),
        );
      },
    );
  }

  void _signInWithPhoneNumber(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Enter OTP'),
    ));
  }

  void _onAuthenticationSuccessful() {
    log('Entered successful authentication',
        name: 'onAuthenticationSuccessful');

    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _onSignInPressed(BuildContext context) async {
    AuthCredential _authCredential = await PhoneAuthProvider.credential(
      verificationId: actualCode,
      smsCode: _passwordController.text,
    );

    try {
      auth.signInWithCredential(_authCredential).then((value) {
        log('Authentication successful', name: '_signInWithPhoneNumber');
        _onAuthenticationSuccessful();
      }).catchError((error) {
        log('Something has gone wrong, please try later: $error',
            name: '_signInWithPhoneNumber');
      });
    } catch (e) {
      log('Exception thrown: $e', name: 'SignInOne -> _onSignInPressed');
    }
  }

  void _dummySignInPressed(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void showLoadingDialog(BuildContext context, String message) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      // backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 200,
          padding: EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.pinkAccent[50],
          ),
          child: Column(
            children: <Widget>[
              Text(
                'Please wait',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                message,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30.0,
              ),
              CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffff2d55)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
    getSharedPrefs();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    if (_error) {
      return Center(
        child: Text('Unknown Error'),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Colors.white,
        child: !_initialized
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xffff2d55)),
                    ),
                    SizedBox(width: 24),
                    Text('Loading data ...'),
                  ],
                ),
              )
            : Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/login_back.jpg'),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Container(
                    height: 400,
                    width: deviceWidth * 0.9,
                    margin: EdgeInsets.only(top: 290, left: deviceWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          // spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Builder(
                      builder: (BuildContext ctx) => Padding(
                        padding: EdgeInsets.all(23),
                        child: ListView(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              height: 50,
                              width: 275,
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFUIDisplay',
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 192, 222, 250),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: 'Phone Number',
                                  labelStyle: TextStyle(fontSize: 15),
                                  prefix: Container(
                                    width: 75,
                                    padding: EdgeInsets.all(4),
                                    child: Row(
                                      children: <Widget>[
                                        Opacity(
                                          opacity: 0.7,
                                          child: Image.asset(
                                            'assets/india.png',
                                            width: 20,
                                            height: 20,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        Text('+91'),
                                      ],
                                    ),
                                  ),
                                ),
                                controller: _phoneController,
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                MaterialButton(
                                  onPressed: () => _getOtpPressed(),
                                  child: Text(
                                    'Get OTP',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'SFUIDisplay',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  color: Color(0xffff2d55).withOpacity(0.9),
                                  elevation: 0,
                                  minWidth: 100,
                                  height: 50,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                // SizedBox(width: 20),
                                Container(
                                  height: 50,
                                  width: 125,
                                  child: TextField(
                                    obscureText: true,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay',
                                    ),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 192, 222, 250),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      labelText: 'OTP',
                                      labelStyle: TextStyle(fontSize: 15),
                                    ),
                                    controller: _passwordController,
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: _isWrongPassVisible,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Container(
                                  child: Text(
                                    'Phone number and password do not match',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _isAccountErrVisible,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Container(
                                  child: Text(
                                    'No account associated with this phone number',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: MaterialButton(
                                onPressed: () => _dummySignInPressed(ctx),
                                child: _isSignInLoading
                                    ? CircularLoading()
                                    : Text(
                                        'SIGN IN',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'SFUIDisplay',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                color: Color(0xffff2d55),
                                elevation: 0,
                                minWidth: 400,
                                height: 50,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(top: 20),
                            //   child: Center(
                            //     child: Text(
                            //       '',
                            //       // 'Forgot your password?',
                            //       style: TextStyle(
                            //           fontFamily: 'SFUIDisplay',
                            //           fontSize: 15,
                            //           fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "Don't have an account? ",
                                        style: TextStyle(
                                          fontFamily: 'SFUIDisplay',
                                          color: Colors.black,
                                          fontSize: 15,
                                        )),
                                    TextSpan(
                                        text: "Sign up",
                                        style: TextStyle(
                                          fontFamily: 'SFUIDisplay',
                                          color: Color(0xffff2d55),
                                          fontSize: 15,
                                        ))
                                  ]),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
