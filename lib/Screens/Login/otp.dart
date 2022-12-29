/*
 * Noob Music is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Noob Music is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Noob Music.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Copyright (c) 2021-2022, Noob Music
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:noobmusic/CustomWidgets/gradient_containers.dart';
//import 'package:noobmusic/Helpers/supabase.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:noobmusic/Screens/Login/auth.dart';
import 'package:pinput/pinput.dart';
//import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class otp extends StatefulWidget {
  @override
  _otpState createState() => _otpState();
}

class _otpState extends State<otp> {
  TextEditingController controller = TextEditingController();
  TextEditingController countryController = TextEditingController();
  Uuid uuid = const Uuid();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var code="";
  bool loading = false;


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return GradientContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
            elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: MediaQuery.of(context).size.width / 1.85,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: const Image(
                    image: AssetImage(
                      'assets/icon-white-trans.png',
                    ),
                  ),
                ),
              ),
              const GradientContainer(
                child: null,
                opacity: true,
              ),
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Noob\nMusic\n',
                                    style: TextStyle(
                                      height: 0.97,
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    children: <TextSpan>[
                                      const TextSpan(
                                        text: 'OTP',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 80,
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 80,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Text(
                              "We need to register your phone without getting started!",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Pinput(
                              length: 6,
                              // defaultPinTheme: defaultPinTheme,
                              // focusedPinTheme: focusedPinTheme,
                              // submittedPinTheme: submittedPinTheme,

                              showCursor: true,
                              onCompleted: (pin) => print(pin),
                              onChanged: (value){
                                code=value;
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                  ),
                                  onPressed: () async{
                                    try {
                                      final PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: AuthScreen.verify, smsCode: code);

                                      // Sign the user in (or link) with the credential
                                      await auth.signInWithCredential(credential);
                                      Navigator.pushNamedAndRemoveUntil(context, '/pref', (route) => false);
                                    }
                                    catch(e){
                                      if (kDebugMode) {
                                        print('Wrong otp');
                                      }
                                    }

                                  },
                                  child: const Text('Verify Phone Number'),),
                            ),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/aut',
                                            (route) => false,
                                      );
                                    },
                                    child: const Text(
                                      'Edit Phone Number ?',
                                      style: TextStyle(color: Colors.white),
                                    ),)
                              ],
                            )
                                /*Container(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                    left: 10,
                                    right: 10,
                                  ),
                                  height: 57.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[900],
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 3.0),
                                      )
                                    ],
                                  ),

                                  child: TextField(
                                    controller: controller,
                                    textAlignVertical: TextAlignVertical.center,
                                    textCapitalization:
                                    TextCapitalization.sentences,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1.5,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      border: InputBorder.none,
                                      hintText: AppLocalizations.of(context)!
                                          .enterName,
                                      hintStyle: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                    ),
                                    onSubmitted: (String value) async {
                                      if (value.trim() == '') {
                                        await _addUserData(
                                          AppLocalizations.of(context)!.guest,
                                        );
                                      } else {
                                        await _addUserData(value.trim());
                                      }
                                      Navigator.popAndPushNamed(
                                        context,
                                        '/pref',
                                      );
                                    },
                                  ),
                                ),*/

                                /* GestureDetector(
                                  onTap: () async {
                                    if (controller.text.trim() == '') {
                                      await _addUserData('Guest');
                                    } else {
                                      await _addUserData(
                                        controller.text.trim(),
                                      );
                                    }
                                    Navigator.popAndPushNamed(context, '/pref');
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    height: 55.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(0.0, 3.0),
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .getStarted,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),*/


                              ],
                            ),

                        ),
                      ),
                    ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
