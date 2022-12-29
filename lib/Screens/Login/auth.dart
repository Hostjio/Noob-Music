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
import 'package:flutter/services.dart';
import 'package:noobmusic/CustomWidgets/gradient_containers.dart';
//import 'package:noobmusic/Helpers/supabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class AuthScreen extends StatefulWidget {

  static String verify="";


  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController countryController = TextEditingController();
  Uuid uuid = const Uuid();
  var phone="";
  bool loading = false;


  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
                                        text: 'Sign Up',
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
                            Column(
                              children: [
                              Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: TextField(
                                      controller: countryController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(fontSize: 33, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: TextField(
                                        onChanged: (value){
                                          phone=value;
                                        },
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "1234 5678 90",
                                        ),
                                      ))
                                ],
                              ),
                            ),
                                SizedBox(
                                  height: 20,
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
                                        setState(() {
                                           loading = true;
                                        });
                                        await FirebaseAuth.instance.verifyPhoneNumber(
                                          phoneNumber: '${countryController.text + phone}',
                                          verificationCompleted: (PhoneAuthCredential credential) {
                                            setState(() {
                                              loading = false;
                                            });
                                          },
                                          verificationFailed: (FirebaseAuthException e) {
                                            setState(() {
                                              loading = false;
                                            });
                                          },
                                          codeSent: (String verificationId, int? resendToken) {
                                            AuthScreen.verify=verificationId;
                                            Navigator.pushNamed(context, '/otp');
                                            setState(() {
                                              loading = false;
                                            });
                                          },
                                          codeAutoRetrievalTimeout: (String verificationId) {
                                            setState(() {
                                              loading = false;
                                            });
                                          },
                                        );

                                      },
                                      child: loading? CircularProgressIndicator(color: Colors.white,):Text("Send the code")),
                                ),
                                SizedBox(
                                  height: 40,
                                ),

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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .disclaimer,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .disclaimerText,
                                        style: TextStyle(
                                          color: Colors.grey.withOpacity(0.7),
                                        ),
                                      ),
                                    ],

                                  ),
                                ),
                              ],
                            ),
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

