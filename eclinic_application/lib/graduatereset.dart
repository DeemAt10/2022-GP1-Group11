import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/afterreset.dart';
import 'package:myapp/afterresetgraduate.dart';
import 'package:myapp/login.dart';
import 'style/Mycolors.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart';
import 'package:myapp/screeens/resources/snackbar.dart';

class graduatereset extends StatefulWidget {
  const graduatereset({super.key});

  @override
  State<graduatereset> createState() => _graduateresetState();
}

class _graduateresetState extends State<graduatereset> {
  final double profileheight = 244;
  final formkey = GlobalKey<FormState>();
  final _emailcontrol = TextEditingController();
  var email;
  bool ifsend = false;
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          primary: false,
          centerTitle: true,
          backgroundColor: Mycolors.mainColorWhite,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 12, 12, 12), //change your color here
          ),
          title: Text(''),
          titleTextStyle: TextStyle(
            fontFamily: 'bold',
            fontSize: 18,
            color: Mycolors.mainColorBlack,
          ),
        ),
        backgroundColor: Mycolors.BackgroundColor,
        body: SingleChildScrollView(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //     "Forget your password?",
              //     style: TextStyle(
              //         fontWeight: FontWeight.w500,
              //         overflow: TextOverflow.ellipsis,
              //         color: Mycolors.mainColorBlack,
              //         fontFamily: 'bold',
              //         fontSize: 17),
              //     textAlign: TextAlign.start,
              //   ),
              // ),
              // SizedBox(
              //   height: 50,
              // ),
              // Image(
              //   image: AssetImage('assets/images/forgot-password.png'),
              //   width: 180,
              //   height: 180,
              // ),
              // SizedBox(
              //   height: 40,
              // ),
              // ifsend
              //     ? Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Align(
              //             alignment: Alignment.center,
              //             child: Text(
              //               "Reset link has been sent on this email:",
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w500,
              //                   overflow: TextOverflow.ellipsis,
              //                   color: Mycolors.mainColorBlack,
              //                   fontFamily: 'bold',
              //                   fontSize: 17),
              //               textAlign: TextAlign.start,
              //             ),
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           Text(
              //             _emailcontrol.text,
              //             style: TextStyle(
              //                 fontFamily: 'main',
              //                 fontSize: 16,
              //                 color: Mycolors.mainColorBlack),
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           Align(
              //             alignment: Alignment.center,
              //             child: Text(
              //               "  Please check your email and click \nin the received link to reset password",
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w500,
              //                   overflow: TextOverflow.ellipsis,
              //                   color: Mycolors.mainColorGray,
              //                   fontFamily: 'main',
              //                   fontSize: 17),
              //               textAlign: TextAlign.start,
              //             ),
              //           ),
              //           SizedBox(
              //             height: 60,
              //           ),
              //           Image(
              //             image: AssetImage('assets/images/checkmailbox .png'),
              //             width: 180,
              //             height: 180,
              //           ),
              //           SizedBox(
              //             height: 80,
              //           ),
              //           SizedBox(
              //             height: 20,
              //           ),
              //           ElevatedButton(
              //             style: ElevatedButton.styleFrom(
              //               textStyle:
              //                   TextStyle(fontFamily: 'main', fontSize: 16),
              //               //shadowColor: Colors.blue[900],
              //               elevation: 0,
              //               backgroundColor: Mycolors.mainShadedColorBlue,
              //               minimumSize: Size(150, 50),
              //               shape: RoundedRectangleBorder(
              //                 borderRadius:
              //                     BorderRadius.circular(17), // <-- Radius
              //               ),
              //             ),
              //             onPressed: () async {
              //               try {
              //                 // await FirebaseAuth.instance
              //                 //     .sendPasswordResetEmail(email: email);
              //                 Navigator.pushNamed(context, "login");

              //                 setState(() {
              //                   // ifsend = false;
              //                   // _emailcontrol.text = "";
              //                 });
              //               } on FirebaseAuthException catch (e) {
              //                 return;
              //               }
              //               print(email);
              //             },
              //             child: Text("Login"),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(top: 15, bottom: 40),
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Text(
              //                   "Didn't receive the reset link ? ",
              //                   style: TextStyle(
              //                       color: Mycolors.mainColorBlack,
              //                       fontFamily: 'main',
              //                       fontSize: 14),
              //                 ),
              //                 GestureDetector(
              //                     onTap: () async {
              //                       try {
              //                         await FirebaseAuth.instance
              //                             .sendPasswordResetEmail(email: email);

              //                         setState(() {
              //                           ifsend = true;
              //                           showInSnackBar(context,
              //                               "Another link has been sent ");
              //                         });
              //                       } on FirebaseAuthException catch (e) {
              //                         return;
              //                       }
              //                       print(email);
              //                     },
              //                     child: Text(
              //                       " Resend",
              //                       style: TextStyle(
              //                           color: Mycolors.mainColorBlack,
              //                           fontFamily: 'bold',
              //                           fontSize: 14),
              //                     )),
              //               ],
              //             ),
              //           ),
              //         ],
              //       )
              //     :
              SizedBox(
                width: 600,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Forget your password?",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: Mycolors.mainColorBlack,
                            fontFamily: 'bold',
                            fontSize: 17),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "   Enter your registered email below to\n receive password reset instruction link ",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: Mycolors.mainColorGray,
                            fontFamily: 'main',
                            fontSize: 17),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Image(
                      image: AssetImage('assets/images/enteremail.png'),
                      width: 180,
                      height: 180,
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 383,
                        child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Email:",
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Mycolors.mainColorBlack,
                                      fontFamily: 'bold',
                                      fontSize: 13),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              TextFormField(
                                  controller: _emailcontrol,
                                  decoration: InputDecoration(
                                      // labelText: 'Email',
                                      hintText: "Email ",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          borderSide: const BorderSide(
                                            width: 0,
                                          ))),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        _emailcontrol.text == "") {
                                      return 'Please enter your email';
                                    }
                                  }),
                              SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                      fontFamily: 'main', fontSize: 16),
                                  // shadowColor: Colors.blue[900],
                                  elevation: 0,
                                  backgroundColor: Mycolors.mainShadedColorBlue,
                                  minimumSize: Size(150, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(17), // <-- Radius
                                  ),
                                ),
                                onPressed: () async {
                                  if (formkey.currentState!.validate()) {
                                    try {
                                      await FirebaseAuth.instance
                                          .sendPasswordResetEmail(
                                              email: _emailcontrol.text);
                                      // showSucessAlert();
                                      setState(() {
                                        ifsend = true;
                                      });
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  afterresetgraduate(
                                                    value: _emailcontrol.text,
                                                  ))));
                                    } on FirebaseAuthException catch (e) {
                                      print(e.message);
                                      if (e.message ==
                                          "The email address is badly formatted.") {
                                        // showerror(context,
                                        //     "please check the email format");
                                        showInSnackBar(context,
                                            "please check the email format",
                                            onError: true);
                                      }
                                      if (e.message ==
                                          "There is no user record corresponding to this identifier. The user may have been deleted.") {
                                        // showSucessAlert();
                                        setState(() {
                                          ifsend = true;
                                          //reset2
                                          Navigator.pushNamed(
                                              context, 'afterreset');
                                        });
                                      }
                                    }
                                  }

                                  print(email);
                                },
                                child: Text("Send "),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       top: 15, bottom: 40),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.center,
                              //     children: [
                              //       Text(
                              //         "Remember password ? ",
                              //         style: TextStyle(
                              //             color: Mycolors.mainColorBlack,
                              //             fontFamily: 'main',
                              //             fontSize: 14),
                              //       ),
                              //       GestureDetector(
                              //           onTap: () {
                              //             Navigator.pushNamed(
                              //                 context, "login");
                              //           },
                              //           child: Text(
                              //             " Log in",
                              //             style: TextStyle(
                              //                 color:
                              //                     Mycolors.mainColorBlack,
                              //                 fontFamily: 'bold',
                              //                 fontSize: 14),
                              //           )),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget buildprofileImage() => CircleAvatar(
      // radius: profileheight / 2,
      // backgroundColor: Mycolors.mainColorShadow,
      // backgroundImage: AssetImage('assets/images/forgot-password.png'),
      //  Image(image: AssetImage('assets/images/forgot-password.png')),
      );
}