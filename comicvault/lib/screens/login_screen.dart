import 'dart:async';

import 'package:comicvault/screens/search_screen_v2.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool firebaseReady = false;
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) => setState(() => firebaseReady = true));
  }

  @override
  Widget build(BuildContext context) {
    if (!firebaseReady) return const Center(child: CircularProgressIndicator());

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) return const SearchScreenv2();
    return const LoginScreen();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  String? error;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Enter your email'),
                maxLength: 64,
                onChanged: (value) => email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null; // Returning null means "no issues"
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Enter a password"),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Your password must contain at least 8 characters.';
                  }
                  return null; // Returning null means "no issues"
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    tryLogin();
                  }
                },
              ),
              ElevatedButton(
                child: const Text('Sign Up'),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
              if (error != null)
                Text(
                  "Error: $error",
                  style: TextStyle(color: Colors.red[800], fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void tryLogin() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      error = null; // clear the error message if exists.
      setState(() {}); // Trigger a rebuild

      if (!mounted) return;

      Navigator.of(context).pop();
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const SearchScreenv2()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
      } else if (e.code == 'wrong-password' ||
          e.code == 'INVALID_LOGIN_CREDENTIALS' ||
          e.code == 'invalid-credential') {
        error = 'Wrong password provided for that user.';
      } else {
        error = 'An error occurred: ${e.message}';
      }

      setState(() {});
    }
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? email;
  String? password;
  String? retypePassword;
  String? error;
  bool? verified;
  bool isLoading = false;
  String loadingMessage = '';

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Enter your email'),
                maxLength: 64,
                onChanged: (value) => email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (!isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null; // Returning null means "no issues"
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Enter a password"),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Your password must contain at least 8 characters.';
                  }
                  return null; // Returning null means "no issues"
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Re-enter the password",
                ),
                obscureText: true,
                onChanged: (value) => retypePassword = value,
                validator: (value) {
                  if (password != retypePassword) {
                    return 'Your passwords must match.';
                  }
                  return null; // Returning null means "no issues"
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Create Account'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    trySignUp();
                  }
                },
              ),
              if (error != null)
                Text(
                  "Error: $error",
                  style: TextStyle(color: Colors.red[800], fontSize: 12),
                ),
              if (isLoading && error == null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),
              if (loadingMessage.isNotEmpty && error == null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(loadingMessage, textAlign: TextAlign.center),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void trySignUp() async {
    setState(() {
      isLoading = true;
      loadingMessage = "Creating account...";
    });
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      print("Logged in ${credential.user}");
      error = null; // clear the error message if exists.
      setState(() {}); // Trigger a rebuild
      await sendVerificationEmail();
      setState(() {
        loadingMessage =
            'A verification email has been sent to $email. Please verify your email to continue.';
      });
      await isEmailVerified();

      if (!mounted) return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        error = 'There is already an account associated with that email.';
      } else if (e.code == 'weak-password') {
        error = 'Please use a stronger password.';
      } else {
        error = 'An error occurred: ${e.message}';
      }

      setState(() {});
    }
  }

  //Regular expression checking oh boy I love csc360!!
  //ty dr. simmonds
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  //Send verification email to user if they are not verified yet
  Future<void> sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  //Refresh user profile and check if they have verified their email yet
  // Null users have not verified their email
  Future<void> isEmailVerified() async {
    Timer.periodic(Duration(seconds: 2), (timer) async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
          timer.cancel();
          setState(() {
            isLoading = false;
            loadingMessage = 'Email verified! Redirecting...';
          });
          Future.delayed(Duration(seconds: 2), () {
            if (!mounted) return;
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SearchScreenv2()),
            );
          });
        }
      }
    });
  }
}

//BELOW IS SMS AUTHENTICATION I'LL JUST KEEP IT HERE MAYBE WOULD BE USEFUL SOMEDAY

// class MultiAuth extends StatefulWidget {
//   const MultiAuth({super.key});

//   @override
//   State<MultiAuth> createState() => _MultiAuthState();
// }

// class _MultiAuthState extends State<MultiAuth> {
//   String? phoneNum;
//   String? error;
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'Enter your phone number.',
//                 ),
//                 maxLength: 64,
//                 onChanged: (value) => phoneNum = value,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter some text';
//                   }
//                   return null; // Returning null means "no issues"
//                 },
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 child: const Text('Get SMS'),
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     User? user = FirebaseAuth.instance.currentUser;
//                     if (user != null) {
//                       final multiFactorSession =
//                           await user.multiFactor.getSession();
//                       print(multiFactorSession);
//                       await FirebaseAuth.instance.verifyPhoneNumber(
//                         multiFactorSession: multiFactorSession,
//                         phoneNumber: phoneNum,
//                         verificationCompleted: (_) {},
//                         verificationFailed: (_) {},
//                         codeSent: (
//                           String verificationId,
//                           int? resendToken,
//                         ) async {
//                           // The SMS verification code has been sent to the provided phone number.
//                           // ...
//                           String? smsCode = null;
//                           try {
//                             smsCode = await getSmsCodeFromUser(context);
//                           } catch (e) {
//                             print(e);
//                           }

//                           print(smsCode);

//                           if (smsCode != null) {
//                             // Create a PhoneAuthCredential with the code
//                             final credential = PhoneAuthProvider.credential(
//                               verificationId: verificationId,
//                               smsCode: smsCode,
//                             );

//                             print(credential);

//                             try {
//                               await user.multiFactor.enroll(
//                                 PhoneMultiFactorGenerator.getAssertion(
//                                   credential,
//                                 ),
//                               );
//                             } on FirebaseAuthException catch (e) {
//                               print(e.message);
//                             } catch (e) {
//                               print("Error: $e");
//                             }
//                           }
//                         },
//                         codeAutoRetrievalTimeout: (_) {},
//                       );
//                     }
//                   }
//                 },
//               ),
//               if (error != null)
//                 Text(
//                   "Error: $error",
//                   style: TextStyle(color: Colors.red[800], fontSize: 12),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<String?> getSmsCodeFromUser(BuildContext context) async {
//     String? smsCode;

//     // Update the UI - wait for the user to enter the SMS code
//     await showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('SMS code:'),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Sign in'),
//             ),
//             OutlinedButton(
//               onPressed: () {
//                 smsCode = null;
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//           ],
//           content: Container(
//             padding: const EdgeInsets.all(20),
//             child: TextField(
//               onChanged: (value) {
//                 smsCode = value;
//               },
//               textAlign: TextAlign.center,
//               autofocus: true,
//             ),
//           ),
//         );
//       },
//     );

//     return smsCode;
//   }
// }
