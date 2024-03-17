// ignore_for_file: avoid_print, camel_case_types, use_build_context_synchronously, avoid_init_to_null
import 'package:bike_rental/MainScreen.dart';
import 'package:bike_rental/login/text_field.dart';
import 'package:flutter/material.dart';
import 'package:bike_rental/login/palette.dart';
import 'package:bike_rental/login/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String? userName = null;
String? userEmail = null;
String? userPword = null;

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isSignupScreen = false;
  bool isRememberMe = false;
  bool _acceptedTerms = false;

  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();
  final email = TextEditingController();
  final pass1 = TextEditingController();
  final pass2 = TextEditingController();
  //final userNamme = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkWifiStatus();
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _checkWifiStatus() async {
    bool isEnabled = await checkInternetConnection();
    if (!isEnabled) {
      _askUserToEnableWifi();
    }
  }

  Future<void> _askUserToEnableWifi() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Internet not available!'),
          content: const Text(
              'Please turn on Wifi/Mobile data to continue or you can still acccess your history.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showCustomPopup(BuildContext context, String message) async {
    Alert(
      context: context,
      style: AlertStyle(
        backgroundColor: Colors.white,
        overlayColor: Colors.black.withOpacity(0.7),
        titleStyle: const TextStyle(
          color: Color.fromARGB(255, 242, 26, 6),
          fontSize: 26.0,
        ),
      ),
      title: message,
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ).show();
  }

  void signInWithGoogle(BuildContext context) async {
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        clientId:
            '107861929323-v3cjcb57oob017u7psefmcsg308c4luf.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser == null) {
        // User canceled the sign-in
        return null;
      }
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = authResult.user!;
      userName = user.displayName;
      userEmail = user.email;
      userName ??= null;
      //print('User Name: $userName');
      //print('User Email: $userEmail');
      showCustomPopup(context, "signed-in successfully with Google.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
      print("signed-in successfully with Google.");
    } catch (e) {
      showCustomPopup(context, "Error occurred during Google sign-in:");
      print('Error during Google sign-in: $e');
      // Handle error if needed
      return null;
    }
  }

  void signUserUp() async {
    if (pass1.text == "" || pass2.text == "" || email.text == "") {
      showCustomPopup(context, "Please fill all the required fields!");
      print("Please fill all the required fields!");
    } else if (_acceptedTerms == false) {
      showCustomPopup(context, "Please accept our conditions!");
      print("Please accept our conditions!");
    } else if (pass1.text == pass2.text) {
      try {
        // ignore: unused_local_variable
        UserCredential credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: pass1.text,
        );
        final User user = credential.user!;
        userName = user.displayName;
        userEmail = user.email;
        userName ??= null;
        //print('User Name: $userName');
        //print('User Email: $userEmail');
        showCustomPopup(context, "Signed-up successfully.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
        print("Signed-up successfully.");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showCustomPopup(context, 'The password provided is too weak.');
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showCustomPopup(context,
              'Provided account already exists, Please try with sign-in');
          print('Provided account already exists, Please try with sign-in');
        }
      } catch (e) {
        showCustomPopup(context, "Error occurred!");
        print(e);
      }
    } else {
      showCustomPopup(context, "Password doesn't match!");
      print("Password doesn't match!");
    }
  }

  void signUserIn() async {
    if (emailCont.text == "" || passwordCont.text == "") {
      showCustomPopup(context, "Please fill all the required fields!");
      print("Please fill all the required fields!");
    } else {
      try {
        // ignore: unused_local_variable
        UserCredential credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailCont.text, password: passwordCont.text);
        final User user = credential.user!;
        userName = user.displayName;
        userEmail = user.email;
        userName ??= null;
        //print('User Name: $userName');
        //print('User Email: $userEmail');
        showCustomPopup(context, "Signed-in successfully.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
        print("Signed-in successfully.");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showCustomPopup(context, 'No user found for that email.');
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showCustomPopup(context, 'Wrong password provided for that user.');
          print('Wrong password provided for that user.');
        } else if (e.code == 'invalid-credential') {
          showCustomPopup(context, 'Invalid credentials.');
          print('Invalid credentials.');
        } else {
          showCustomPopup(context, e.code);
          print(e.code);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 300,
              child: Container(
                padding: const EdgeInsets.only(top: 90, left: 20),
                color: Colors.green,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: "Welcome",
                          style: const TextStyle(
                            fontSize: 25,
                            letterSpacing: 2,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: isSignupScreen ? " Home," : " Back,",
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          ]),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      isSignupScreen
                          ? "Signup to Continue"
                          : "Signin to Continue",
                      style: const TextStyle(
                        letterSpacing: 1,
                        color: Colors.black87,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Trick to add the shadow for the submit button
          buildBottomHalfContainer(true),
          //Main Contianer for Login and Signup
          AnimatedPositioned(
            duration: const Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            top: isSignupScreen ? 205 : 230,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              height: isSignupScreen ? 410 : 260,
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "SIGNUP",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1),
                              ),
                              if (isSignupScreen)
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: Colors.red,
                                )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1),
                              ),
                              if (!isSignupScreen)
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: Colors.red,
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isSignupScreen) buildSignupSection(),
                    if (!isSignupScreen) buildSigninSection()
                  ],
                ),
              ),
            ),
          ),
          // Trick to add the submit button
          buildBottomHalfContainer(false),
          // Bottom buttons
          Positioned(
            top: MediaQuery.of(context).size.height - 130,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Text(isSignupScreen ? "Or Signup with" : "Or Signin with"),
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SquareTile(
                        onTap: () => signInWithGoogle(context),
                        imagePath: 'assets/google.png',
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildSigninSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buildTextField(
              icon: Icons.mail_outline,
              hintText: "E-mail",
              ispassword: false,
              isemail: true,
              controller: emailCont),
          buildTextField(
              icon: const IconData(0xf1ac, fontFamily: 'MaterialIcons'),
              hintText: "Password",
              ispassword: true,
              isemail: false,
              controller: passwordCont),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isRememberMe,
                    activeColor: Palette.textColor2,
                    onChanged: (value) {
                      setState(() {
                        isRememberMe = !isRememberMe;
                      });
                    },
                  ),
                  const Text("Remember me",
                      style: TextStyle(fontSize: 12, color: Palette.textColor1))
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text("Forgot Password?",
                    style: TextStyle(fontSize: 12, color: Palette.textColor1)),
              )
            ],
          )*/
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Terms and Conditions"),
        content: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " Hello from",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                Text(
                  " TrackED!",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _acceptedTerms = true;
              });
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Change the color to blue
            ),
            child: const Text("Accept"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _acceptedTerms = false;
              });
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Change the color to red
            ),
            child: const Text(
              "Decline",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          //buildTextField(icon: const IconData(0xf1ac, fontFamily: 'MaterialIcons'),hintText: "User Name",ispassword: false,isemail: false,controller: userNamme,),
          buildTextField(
            icon: const IconData(0xe3c4, fontFamily: 'MaterialIcons'),
            hintText: "E-mail",
            ispassword: false,
            isemail: true,
            controller: email,
          ),
          buildTextField(
            icon: const IconData(0xe3b1, fontFamily: 'MaterialIcons'),
            hintText: "Set password",
            ispassword: true,
            isemail: false,
            controller: pass1,
          ),
          buildTextField(
            icon: const IconData(0xe3b1, fontFamily: 'MaterialIcons'),
            hintText: "Confirm password",
            ispassword: true,
            isemail: false,
            controller: pass2,
          ),
          Container(
              width: 500,
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          child: Text(
                            "By pressing 'Accept' you agree to our ",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Palette.textColor2),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showTermsDialog();
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 40), // Adjust the width as needed
                                  Text(
                                    'Terms and Conditions',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Checkbox(
                              value: _acceptedTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptedTerms = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(width: 1, color: Colors.grey),
          minimumSize: const Size(145, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: backgroundColor),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: isSignupScreen ? 560 : 435,
      right: 0,
      left: 0,
      child: Center(
        child: GestureDetector(
          onTap: isSignupScreen ? signUserUp : signUserIn,
          child: Container(
            height: 90,
            width: 90,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1.5,
                    blurRadius: 10,
                  )
              ],
            ),
            child: !showShadow
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.lightGreenAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.3),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  )
                : const Center(),
          ),
        ),
      ),
    );
  }
}
