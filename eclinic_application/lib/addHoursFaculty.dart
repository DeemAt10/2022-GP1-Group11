import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/facultyhome.dart';
//import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'TimeFiles/simple_time_range_picker.dart';
import 'model/availableHoursArray.dart';
import 'style/Mycolors.dart';
import 'model/checkbox_state.dart';
import 'model/startEnd.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'model/timesWithDates.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/login.dart';

class addHoursFaculty extends StatefulWidget {
  const addHoursFaculty({super.key});

  // const deem({super.key});

  @override
  State<addHoursFaculty> createState() => _AddHourState();
}

class _AddHourState extends State<addHoursFaculty> {
  @override
  // initState() {
  //   super.initState();
  //   getusers();
  // }
  var muser;
  int _selectedIndex = 1;
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  TimeOfDay initime = TimeOfDay.now();
  bool Ischecked = false;
  bool? isExists;
  bool? isSemesterDateExists;
  final daysOfHelp = [
    CheckBoxState(title: 'Sunday', hours: ['un']),
    CheckBoxState(title: 'Monday', hours: ['un']),
    CheckBoxState(title: 'Tuesday', hours: ['un']),
    CheckBoxState(title: 'Wednesday', hours: ['un']),
    CheckBoxState(title: 'Thursday', hours: ['un']),
  ];

  List availableHours = [];

  DateTime startingDate = DateTime.now(); //admin start date or today
  DateTime endDate = DateTime.now(); //admin end date
  String? email = '';
  String? userid = '';

  var mettingmethoddrop;
  // var mettingmethoddrop2;
  var meetingmethod;
  var mettingmethodinfo;
  var _meetingmethodcontroller = TextEditingController();
  var _meetingmethodcontroller2 = TextEditingController();
  RegExp english = RegExp("^[\u0000-\u007F]+\$");
  final formkey = GlobalKey<FormState>();
  var mm;
  var mmi;

  getusers() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;
    print('****************************************************');
    print(userid);

//var semester;

    final DocumentSnapshot docRef = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(userid)
        .get();
    print(docRef);
    var semester = await docRef['semester'];
    print(semester);

    final DocumentSnapshot docRef2 = await semester.get();
    //String id = docRef2.id.substring(1);
    // final DocumentSnapshot docForSem = await FirebaseFirestore.instance
    //     .collection("semester")
    //     .doc(docRef2.id)
    //     .get();
    print(docRef2.exists);
    print('***********************print dates***********************');
    print(docRef2['semestername']);
    print(docRef2['startdate']);
    startingDate = docRef2['startdate'].toDate();
    endDate = docRef2['enddate'].toDate();
    print('***********************print dates***********************');
    print(startingDate);
    //print('***********************tttiimmmmmeeees***********************');
    //print(new TimeOfDay(hour: 13, minute: 0));
// semester.get().then(
//     (DocumentSnapshot doc2) {

//       startingDate=doc2['startdate'].toDate();
//       endDate=doc2['enddate'].toDate();
//       print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
//           print(startingDate);
//           print(endDate);
//      }
//    );

//print(docRef['semester']);
//semester= docRef['semester'];

//  print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
//   print(docRef);
//    docRef.get().then(
//     (DocumentSnapshot doc) {
//      //semester1 = doc.data()!.semester;
//      //final data = doc.data() as Map<String, dynamic>;

//      semester=doc['semester'];

//     print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
//     print(semester);
//     //print(semester['semestername']);
//      },
//    onError: (e) => print("Error getting document: $e"),
//    );

// //  setState(() {
// // if(semester != null){

// // }
// //  });
  }

  @override
  initState() {
    super.initState();
    IsSemesterDatesExists();

    IsHoursExists(); // use a helper method because initState() cannot be async

    getusers();
    //retrivecolldepsem();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    PrintViewHours();
  }

  // retrivecolldepsem() async {
  //   final snap2 = await FirebaseFirestore.instance
  //       .collection('faculty')
  //       .doc(userid)
  //       .get();
  //   print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
  //   var mm = snap2['meetingmethod'];
  //   mettingmethoddrop2 = mm;
  //   print(mm);
  //   var mmi = snap2['mettingmethodinfo'];
  //   print(mmi);
  //   _meetingmethodcontroller2 = TextEditingController(text: mmi);
  // }

  Future<bool?> IsSemesterDatesExists() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    final snap = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(userid)
        .get();
    print("D------------------print semester-----------------D");
    print(snap['semester']);
    var semester = snap['semester'];

    final DocumentSnapshot docRef2 = await semester.get();
    print("-------------------print doc-----------------");
    try {
      print(docRef2['startdate']);
      if (docRef2['startdate'] != null) {
        setState(() {
          isSemesterDateExists = true;
        });
      } else {
        setState(() {
          isSemesterDateExists = false;
        });
      }

      print(isSemesterDateExists);
    } catch (e) {
      // setState(() {
      //   isSemesterDateExists = false;
      // });
      print("-------------------print doc----------------no-");
      print(isSemesterDateExists);
      print("no");
    }
  }

  Future<bool?> IsHoursExists() async {
    // if (isSemesterDateExists == true) {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;
    // print('******************');
    // print(userid);

    final snap = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(userid)
        .get();

    if (snap.data()!.containsKey('availablehours') == true &&
        snap['availablehours'] != null) {
      print("*******&&&&&&&&&&&&&&&&&&&^^^^^^^^^^^^^^^^^^");
      print("THERE ARE HOURS");
      setState(() {
        isExists = true;
      });

      return isExists;
    } else {
      print("*******&&&&&&&&&&&&&&&&&&&^^^^^^^^^^^^^^^^^^");
      print("NO HOURS");
      setState(() {
        isExists = false;
      });

      return isExists;
    }
    // }
  }

  int numOfDaysOfHelp = 0;
  bool viewHexist = false;
  Future getavailableHours() async {
    await Future.delayed(Duration(seconds: 1));
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    userid = user!.uid;
    email = user.email!;

    if (isExists == true) {
      final snap = await FirebaseFirestore.instance
          .collection("faculty")
          .doc(userid)
          .get();

      var array = snap['availablehours'];
      numOfDaysOfHelp = array.length;
      for (var i = 0; i < array.length; i++) {
        availableHours.add(availableHoursArray(
            title: array[i]['Day'], hours: array[i]['time']));
      }
    } else {
      numOfDaysOfHelp = 0;
    }

    // final snap = await FirebaseFirestore.instance
    //     .collection("faculty")
    //     .doc(userid)
    //     .collection('availableHours')
    //     .get()
    //     .then((QuerySnapshot snapshot) {
    //   print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    //   print(snapshot.size);
    //   numOfDaysOfHelp = snapshot.size;
    //   snapshot.docs.forEach((DocumentSnapshot doc) {
    //     // for (int i = 0; i < availableHours.length; i++) {
    //     //  if (doc['Day'] != availableHours[i].title) {
    //     availableHours.add(
    //         availableHoursArray(title: doc['Day'], hours: doc['HoursString2']));
    //     // }//end of if
    //     // }// end for
    //   });
    // });
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    print(availableHours.length);

    // final snap2 = await FirebaseFirestore.instance
    //     .collection('faculty')
    //     .doc(userid)
    //     .get();
    // print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
    // var mm = snap2['meetingmethod'];
    // mettingmethoddrop2 = mm;
    // print(mm);
    // var mmi = snap2['mettingmethodinfo'];
    // print(mmi);
    // _meetingmethodcontroller2 = TextEditingController(text: mmi);
    setState(() {
      viewHexist = true;
    });
  }

  PrintViewHours() async {
    await Future.delayed(Duration(seconds: 2));
    String string = "";

    print("++++++++++++++++++++++++++++++++++    ${availableHours.length}");
    for (int i = 0; i < availableHours.length; i++) {
      print(
          "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^    ${availableHours[i].hours.length}");

      for (int j = 0; j < availableHours[i].hours.length; j++) {
        string = string +
            "\n Start: " +
            availableHours[i].hours[j]['startTime'] +
            " - end: " +
            availableHours[i].hours[j]['endTime'];
      }
      print("(((((((((())))))))))))))))))))))))");
      print(availableHours[i].title);
      print(string);
      availableHours[i].allhours =
          string; //store the value of all the hours in a string in the array
      string = ""; //to delete old values of the previos day
    }

    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    print(string);
  }

  @override
  Widget build(BuildContext context) {
    //PrintViewHours();
    IsValueChecked();

    if (isSemesterDateExists == false) {
      return SafeArea(
        child: Scaffold(
          // backgroundColor: Mycolors.BackgroundColor,
          body: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 30, bottom: 10),
              //   child: Text(
              //     "Please add your available days and hours",
              //     style: TextStyle(
              //         color: Mycolors.mainColorBlack,
              //         fontFamily: 'main',
              //         fontSize: 24),
              //   ),
              // ),
              // FutureBuilder(
              //   future: IsSemesterDatesExists(),
              //   builder: (context, snapshot) {
              //     // return Card(
              //     //   //color: Mycolors.mainColorBlue,
              //     //   shape: RoundedRectangleBorder(
              //     //     borderRadius: BorderRadius.circular(17), // <-- Radius
              //     //   ),
              //     //   shadowColor: Color.fromARGB(94, 114, 168, 243),
              //     //   elevation: 20,
              //     //   child:
              //     return
              Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                  "The admin did not add the start and end dates for the help desk yet, please try later.",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: Colors.black54, fontFamily: 'main', fontSize: 17),
                ),
              )
              //);
              //   },
              // ),
            ],
          ),
        ),
      );
    } else if (isExists == false && isSemesterDateExists == true) {
      return SafeArea(
        child: Scaffold(
          // backgroundColor: Mycolors.BackgroundColor,
          // appBar: AppBar(
          //   backgroundColor: Mycolors.BackgroundColor,
          //   automaticallyImplyLeading: false,
          //   title: Text('Add hours',),
          // ),
          body:
              // Form(
              //   key: formkey,
              //   child:
              Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(children: [
              // Padding(
              //   padding: const EdgeInsets.only(
              //       top: 20, bottom: 5, right: 20, left: 20),
              //   child: Card(
              //     color: Colors.white,
              //     margin: EdgeInsets.only(bottom: 20),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(17), // <-- Radius
              //       side: BorderSide(
              //         width: 1,
              //         color: Mycolors.mainShadedColorBlue,
              //       ),
              //     ),
              //     shadowColor: Color.fromARGB(94, 250, 250, 250),
              //     elevation: 20,
              //     child:
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10, right: 3),
                child: Text(
                  "Please add your available days and hours",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Mycolors.mainShadedColorBlue,
                      fontFamily: 'main',
                      fontSize: 20),
                ),
              ),
              //   ),
              // ),
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 350,
                    child: ListView.builder(
                      itemCount: daysOfHelp.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(17), // <-- Radius
                          ),
                          shadowColor: Color.fromARGB(94, 250, 250, 250),
                          elevation: 20,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(top: 11.7),
                              child: Text(
                                daysOfHelp[index].title,
                                style: TextStyle(
                                    color: Mycolors.mainColorBlack,
                                    fontFamily: 'main',
                                    fontSize: 17),
                              ),
                            ),
                            leading: Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                  activeColor: Mycolors.mainColorBlue,
                                  checkColor: Mycolors.mainColorWhite,
                                  value: daysOfHelp[index].value,
                                  onChanged: (newvalue) {
                                    setState(() {
                                      daysOfHelp[index].value = newvalue!;
                                    });
                                    selectTime1(index);
                                  }),
                            ),
                            subtitle: subtitleForEachDay(index),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     alignment: Alignment.topCenter,
              //     child: SizedBox(
              //       width: 350,
              //       child: DropdownButtonFormField(
              //         decoration: InputDecoration(
              //           // suffixIcon: Icon(Icons.edit),
              //           hintText: "Choose meeting method",
              //           border: OutlineInputBorder(),
              //         ),
              //         items: const [
              //           DropdownMenuItem(
              //               child: Text("In person metting"), value: "inperson"),
              //           DropdownMenuItem(
              //               child: Text("Online meeting "), value: "online"),
              //         ],
              //         onChanged: (value) {
              //           setState(() {
              //             mettingmethoddrop = value;
              //           });
              //         },
              //         autovalidateMode: AutovalidateMode.onUserInteraction,
              //         validator: (value) {
              //           if (value == null || mettingmethoddrop == null) {
              //             return 'Please Choose meeting method';
              //           }
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 8,
              // ),
              // if (mettingmethoddrop != null && mettingmethoddrop == "inperson")
              //   SizedBox(
              //     width: 350,
              //     child: TextFormField(
              //         controller: _meetingmethodcontroller,
              //         decoration: InputDecoration(
              //             labelText: 'Office number',
              //             hintText: "Enter your office number",
              //             // suffixIcon: Icon(Icons.edit),
              //             border: OutlineInputBorder()),
              //         autovalidateMode: AutovalidateMode.onUserInteraction,
              //         validator: (value) {
              //           if (value!.isEmpty ||
              //               _meetingmethodcontroller.text == "") {
              //             return 'Please enter your office number';
              //           } else {
              //             if (!(english
              //                 .hasMatch(_meetingmethodcontroller.text))) {
              //               return "only english is allowed";
              //             }
              //           }
              //         }),
              //   ),
              // if (mettingmethoddrop != null && mettingmethoddrop == "online")
              //   SizedBox(
              //     width: 350,
              //     child: TextFormField(
              //         controller: _meetingmethodcontroller,
              //         decoration: InputDecoration(
              //             labelText: 'meeting link',
              //             hintText: "Enter your meeting link",
              //             // suffixIcon: Icon(Icons.edit),
              //             border: OutlineInputBorder()),
              //         autovalidateMode: AutovalidateMode.onUserInteraction,
              //         validator: (value) {
              //           if (value!.isEmpty ||
              //               _meetingmethodcontroller.text == "") {
              //             return 'Please enter your meeting link';
              //           } else {
              //             if (!(english
              //                 .hasMatch(_meetingmethodcontroller.text))) {
              //               return "only english is allowed";
              //             }
              //           }
              //         }),
              //   ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
                    shadowColor: Colors.blue[900],
                    elevation: 20,
                    backgroundColor: Mycolors.mainShadedColorBlue,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17), // <-- Radius
                    ),
                  ),
                  child: Text("Confirm"),
                  onPressed: Ischecked
                      ? () {
                          showConfirmationDialog(context);
                        }
                      : null,
                ),
              ),
            ]),
          ),
          // ),
        ),
      );
    } else if (isExists == true) {
      return SafeArea(
        child: Scaffold(
          // appBar: AppBar(title: Text("gg")),
          backgroundColor: Color.fromARGB(255, 246, 246, 246),
          body:
              // Form(
              //   key: formkey,
              //   child:
              Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 350,
                      child: Column(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 4, bottom: 20),
                          //   child: Text(
                          //     "View hours",
                          //     style: TextStyle(
                          //         color: Mycolors.mainColorBlack,
                          //         fontFamily: 'main',
                          //         fontSize: 24),
                          //   ),
                          // ),
                          Expanded(
                            child: FutureBuilder(
                                future: getavailableHours(),
                                builder: (context, snapshot) {
                                  if (viewHexist) {
                                    return ListView.builder(
                                      itemCount: numOfDaysOfHelp,
                                      itemBuilder: ((context, index) {
                                        return Card(
                                            color: Colors.white,
                                            margin: EdgeInsets.only(bottom: 20),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      17), // <-- Radius
                                              // side: BorderSide(
                                              //   width: 1,
                                              //   color:
                                              //       Mycolors.mainShadedColorBlue,
                                              // ),
                                            ),
                                            shadowColor: Color.fromARGB(
                                                94, 250, 250, 250),
                                            elevation: 20,
                                            child: ExpansionTile(
                                              iconColor:
                                                  Mycolors.mainShadedColorBlue,
                                              collapsedIconColor:
                                                  Mycolors.mainShadedColorBlue,
                                              title: Text(
                                                availableHours[index].title,
                                                style: TextStyle(
                                                    color:
                                                        Mycolors.mainColorBlue,
                                                    fontFamily: 'Semibold',
                                                    fontSize: 17),
                                              ),
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15),
                                                  child: Text(
                                                    availableHours[index]
                                                        .allhours,
                                                    style: TextStyle(
                                                        color: Mycolors
                                                            .mainColorBlack,
                                                        fontFamily: 'main',
                                                        fontSize: 16),
                                                  ),
                                                )
                                              ],
                                            ));
                                      }),
                                    );
                                  }
                                  return Center(
                                      child: CircularProgressIndicator(
                                          color: Mycolors.mainShadedColorBlue));
                                }),
                          ),
                          FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('faculty')
                                  .doc(userid!)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  muser = snapshot.data!.data()
                                      as Map<String, dynamic>;
                                  String mettingmethoddrop2 =
                                      muser['meetingmethod'];
                                  final metingmethodinfotext =
                                      muser['mettingmethodinfo'];

                                  return Container(
                                    height: 140,
                                    width: 350,
                                    child: Card(
                                      //Mycolors.mainShadedColorBlue
                                      //color: Color.fromARGB(171, 255, 255, 255),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            17), // <-- Radius
                                        // side: BorderSide(
                                        //   width: 1,
                                        //   color: Mycolors.mainShadedColorBlue,
                                        // ),
                                      ),
                                      shadowColor:
                                          Color.fromARGB(171, 212, 212, 240),
                                      elevation: 40,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                //iconSize: 100,
                                                alignment: Alignment.topLeft,
                                                color: Color.fromARGB(
                                                    200, 21, 70, 160),
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                ),
                                                // the method which is called
                                                // when button is pressed
                                                onPressed: (() {
                                                  showEditDialog(context);
                                                }),
                                              ),
                                            ],
                                          ),
                                          // const SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Meeting method: " +
                                                      mettingmethoddrop2 +
                                                      " meeting",
                                                  style: TextStyle(
                                                      color: Mycolors
                                                          .mainColorBlue,
                                                      fontFamily: 'main',
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  "Office number/link: " +
                                                      metingmethodinfotext,
                                                  style: TextStyle(
                                                      color: Mycolors
                                                          .mainColorBlue,
                                                      fontFamily: 'main',
                                                      fontSize: 18),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } //end of if
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: Mycolors.mainShadedColorBlue));
                              }),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ),
        ),
      );
    } else {
      return Center(
          child:
              CircularProgressIndicator(color: Mycolors.mainShadedColorBlue));
    }
  } //end build

  showEditDialog(BuildContext context) {
    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 20,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog

    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 20,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(70, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Save"),
      onPressed: () {
        mm = muser['meetingmethod'];
        mmi = _meetingmethodcontroller2.text;

        if (formkey.currentState!.validate()) {
          print("///hhiiii");
          print(mm);
          FirebaseFirestore.instance.collection('faculty').doc(userid).update({
            "meetingmethod": mm,
            "mettingmethodinfo": mmi,
          });

          Fluttertoast.showToast(
            msg: "Your meeting method has been updated successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Color.fromARGB(255, 127, 166, 233),
            textColor: Color.fromARGB(255, 248, 249, 250),
            fontSize: 18.0,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => facultyhome(_selectedIndex),
            ),
          );
        }
      },
    );
    final metingmethodinfotext = muser['mettingmethodinfo'];

    _meetingmethodcontroller2 =
        TextEditingController(text: metingmethodinfotext);
    AlertDialog alert = AlertDialog(
      title: Text("Edit meething method"),
      content: SizedBox(
          height: 150,
          child: Column(
            children: [
              Form(
                  key: formkey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 350,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            hintText: "Choose meeting method",
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                                child: Text("In person metting"),
                                value: "inperson"),
                            DropdownMenuItem(
                                child: Text("Online meeting"), value: "online"),
                          ],
                          value: muser['meetingmethod'],
                          onChanged: (value) {
                            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                            print(value);
                            muser['meetingmethod'] = value;
                            print(muser['meetingmethod']);
                            _meetingmethodcontroller2.text = "";
                          },
                          //     onChanged: (value) {
                          //   setState(() {
                          //     mettingmethoddrop = value;
                          //     _meetingmethodcontroller.text = "";
                          //   });
                          // }
                        ),
                      ),
                      if (muser['meetingmethod'] != "")
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 350,
                            child: TextFormField(
                                controller: _meetingmethodcontroller2,
                                decoration: InputDecoration(
                                    labelText: 'Office number/link',
                                    hintText: "Enter your office number/link",
                                    // suffixIcon: Icon(Icons.edit),
                                    border: OutlineInputBorder()),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      _meetingmethodcontroller2.text == "") {
                                    return 'Please enter your office number/link';
                                  } else {
                                    if (!(english.hasMatch(
                                        _meetingmethodcontroller2.text))) {
                                      return "only english is allowed";
                                    }
                                  }
                                }),
                          ),
                        ),
                      // Container(
                      //   padding: EdgeInsets.only(bottom: 20),
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       textStyle:
                      //           TextStyle(fontFamily: 'main', fontSize: 16),
                      //       shadowColor: Colors.blue[900],
                      //       elevation: 20,
                      //       backgroundColor: Mycolors.mainShadedColorBlue,
                      //       minimumSize: Size(200, 50),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius:
                      //             BorderRadius.circular(17), // <-- Radius
                      //       ),
                      //     ),
                      //     onPressed: () {
                      //       mm = muser['meetingmethod'];
                      //       mmi = _meetingmethodcontroller2.text;

                      //       if (formkey.currentState!.validate()) {
                      //         print("///hhiiii");
                      //         print(mm);
                      //         FirebaseFirestore.instance
                      //             .collection('faculty')
                      //             .doc(userid)
                      //             .update({
                      //           "meetingmethod": mm,
                      //           "mettingmethodinfo": mmi,
                      //         });

                      //         Fluttertoast.showToast(
                      //           msg:
                      //               "Your meeting method has been updated successfully",
                      //           toastLength: Toast.LENGTH_SHORT,
                      //           gravity: ToastGravity.CENTER,
                      //           timeInSecForIosWeb: 2,
                      //           backgroundColor:
                      //               Color.fromARGB(255, 127, 166, 233),
                      //           textColor: Color.fromARGB(255, 248, 249, 250),
                      //           fontSize: 18.0,
                      //         );
                      //       }
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) =>
                      //               facultyhome(_selectedIndex),
                      //         ),
                      //       );
                      //     },
                      //     child: Text("Save changes"),
                      //   ),
                      // ),
                    ],
                  ))
            ],
          )),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  IsValueChecked() {
    if (daysOfHelp[0].value == false &&
        daysOfHelp[1].value == false &&
        daysOfHelp[2].value == false &&
        daysOfHelp[3].value == false &&
        daysOfHelp[4].value == false) {
      Ischecked = false;
    } else {
      Ischecked = true;
    }
  }

  _timeFormated(TimeOfDay Stime, TimeOfDay Etime, int x) {
    if (Stime == null || Etime == null) {}

    daysOfHelp[x].hours.add(startEnd(start: Stime, end: Etime));
    //ArrayOfTimesOfDays.add(startEnd(start: _startTime, end: _endTime));
  }

  selectTime1(int x) {
    if (daysOfHelp[x].value == false)
      return;
    else {
      if (daysOfHelp[x].hours.length == 1) {
        return TimeRangePicker.show(
            context: context,
            unSelectedEmpty: true,
            startTime:
                TimeOfDay(hour: _startTime.hour, minute: _startTime.minute),
            endTime: TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
            onSubmitted: (TimeRangeValue value) {
              setState(() {
                _startTime = value.startTime!;
                _endTime = value.endTime!;
              });

              if (_startTime.hour == _endTime.hour &&
                  _startTime.minute == _endTime.minute) {
                //can she have a period of time ends and start at the same hour???????????
                showerror(context,
                    "the start time connot be equal to the end time", x);
              } else if (_startTime.hour < 7 ||
                  _startTime.hour > 16 ||
                  _endTime.hour < 7 ||
                  _endTime.hour > 16) {
                // print(_startTime.hour);
                // print(_endTime.hour);
                showerror(context,
                    "the time you choosed is out of the working hours", x);
              } else
                _timeFormated(_startTime, _endTime, x);
            },
            onCancel: (() {
              setState(() {
                daysOfHelp[x].value = false;
                //daysOfHelp[x].hours[0] = "un";
              });
            }));
      }
    }
  }

  subtitleForEachDay(int x) {
    if (daysOfHelp[x].value == false)
      return Text("Unavailable");
    else {
      return Column(
        children: <Widget>[
          for (int i = 1; i < daysOfHelp[x].hours.length; i++)
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    daysOfHelp[x].hours[i].toString(),
                    style: TextStyle(
                        color: Mycolors.mainColorBlack,
                        fontFamily: 'main',
                        fontSize: 14),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 20,
                      ),
                      onPressed: () => {deleteHour(x, i)},
                    ),
                  ),
                ],
              ),

              // subtitle: IconButton(
              //   icon: Icon(Icons.delete),
              //   onPressed: () => {deleteHour(x, i)},
              // ),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  surfaceTintColor: Mycolors.mainColorWhite,
                  backgroundColor: Mycolors.mainColorWhite,
                  foregroundColor: Mycolors.mainColorGreen),
              child: Text("+ Add"),
              onPressed: () => TimeRangePicker.show(
                context: context,
                unSelectedEmpty: true,
                startTime:
                    TimeOfDay(hour: _startTime.hour, minute: _startTime.minute),
                endTime:
                    TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
                onSubmitted: (TimeRangeValue value) {
                  setState(() {
                    _startTime = value.startTime!;
                    _endTime = value.endTime!;
                  });
                  bool flag = true;
                  for (var i = 1; i < daysOfHelp[x].hours.length; i++) {
                    startEnd startend = daysOfHelp[x].hours[i];
                    //--------------the new time = to the old times----------------------
                    if (startend.start.hour == _startTime.hour &&
                        startend.start.minute == _startTime.minute &&
                        startend.end.hour == _endTime.hour &&
                        startend.end.minute == _endTime.minute) {
                      showerror(
                          context,
                          "the new time you choosed is the same for the previos one",
                          x);
                      flag = false;
                    }
                    //----------------------------the start time = to the end time-------------------------------------
                    else if (_startTime.hour == _endTime.hour &&
                        _startTime.minute == _endTime.minute) {
                      //can she have a period of time ends and start at the same hour???????????
                      showerror(context,
                          "the start time connot be equal to the end time", x);
                      flag = false;
                    }
                    //----------------------------the start time > to the end time-------------------------------------
                    else if (_startTime.hour == _endTime.hour &&
                        _startTime.minute >= _endTime.minute) {
                      showerror(context,
                          "the end time must be after the end time", x);
                      flag = false;
                    } else if (_startTime.hour > startend.start.hour &&
                        _endTime.hour <= startend.end.hour) {
                      showerror(
                          context,
                          "the new time must be out of the prevrios period ",
                          x);
                      flag = false;
                    } else if (_startTime.hour == startend.end.hour &&
                        _startTime.minute < startend.end.minute) {
                      showerror(context,
                          "the new time must be out of the prevrios period", x);
                      flag = false;
                    } else if (_startTime.hour <= startend.start.hour &&
                        _startTime.minute <= startend.start.minute &&
                        _endTime.hour >= startend.end.hour &&
                        _endTime.minute >= startend.end.minute) {
                      showerror(context,
                          "the new time must be out of the prevrios period", x);
                      flag = false;
                    } else if (_startTime.hour < startend.end.hour &&
                        _endTime.hour > startend.start.hour) {
                      showerror(context,
                          "the new time must be out of the prevrios period", x);
                      flag = false;
                    } else if (_startTime.hour == startend.end.hour &&
                        _startTime.minute == startend.end.minute) {
                      showerror(
                          context,
                          "the start time must be out of the prevrios period",
                          x);
                      flag = false;
                    }
                    //------------------------time must be in working hours(7-4)-------------------------
                    else if (_startTime.hour < 7 ||
                        _startTime.hour > 16 ||
                        _endTime.hour < 7 ||
                        _endTime.hour > 16) {
                      // print(_startTime.hour);
                      // print(_endTime.hour);
                      showerror(
                          context,
                          "the time you choosed is out of the working hours",
                          x);
                      flag = false;
                    }
                  }
                  if (flag) _timeFormated(_startTime, _endTime, x);
                },
              ),
            ),
          ),
        ],
      );
    } //end else
  } //end subtitle function

  deleteHour(int x, int i) {
    setState(() {
      dynamic res = daysOfHelp[x].hours.removeAt(i);
      if (daysOfHelp[x].hours.length == 1) {
        daysOfHelp[x].value = false;
      }
    });
  } //end delete function

  showConfirmationDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 20,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(60, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog

    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
        shadowColor: Colors.blue[900],
        elevation: 20,
        backgroundColor: Mycolors.mainShadedColorBlue,
        minimumSize: Size(70, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text("Confirm"),
      onPressed: () {
        setState(() {
          meetingmethod = mettingmethoddrop;
          mettingmethodinfo = _meetingmethodcontroller.text;
        });
        if (formkey.currentState!.validate()) {
          Confirm();
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("warning"),
      content: SizedBox(
        height: 300,
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 350,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      // suffixIcon: Icon(Icons.edit),
                      hintText: "Choose meeting method",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                          child: Text("In person metting"), value: "inperson"),
                      DropdownMenuItem(
                          child: Text("Online meeting "), value: "online"),
                    ],
                    onChanged: (value) {
                      setState(() {
                        mettingmethoddrop = value;
                      });
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || mettingmethoddrop == null) {
                        return 'Please Choose meeting method';
                      }
                    },
                  ),
                ),
              ),

              SizedBox(
                height: 8,
              ),

              SizedBox(
                width: 350,
                child: TextFormField(
                    controller: _meetingmethodcontroller,
                    decoration: InputDecoration(
                        labelText: 'Office number/link',
                        hintText: "Enter your office number/link",
                        // suffixIcon: Icon(Icons.edit),
                        border: OutlineInputBorder()),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty ||
                          _meetingmethodcontroller.text == "") {
                        return 'Please enter your office number/link';
                      } else {
                        if (!(english
                            .hasMatch(_meetingmethodcontroller.text))) {
                          return "only english is allowed";
                        }
                      }
                    }),
              ),

              // SizedBox(
              //   width: 350,
              //   child: TextFormField(
              //       controller: _meetingmethodcontroller,
              //       decoration: InputDecoration(
              //           labelText: 'meeting link',
              //           hintText: "Enter your meeting link",
              //           // suffixIcon: Icon(Icons.edit),
              //           border: OutlineInputBorder()),
              //       autovalidateMode: AutovalidateMode.onUserInteraction,
              //       validator: (value) {
              //         if (value!.isEmpty || _meetingmethodcontroller.text == "") {
              //           return 'Please enter your meeting link';
              //         } else {
              //           if (!(english.hasMatch(_meetingmethodcontroller.text))) {
              //             return "only english is allowed";
              //           }
              //         }
              //       }),
              // ),
              Text(
                  "if you press on confirm that means you approved on the entered hours and you know that you CANNOT updated later"),
            ],
          ),
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    // show the dialog
  }

  Confirm() async {
    for (var k = 0; k < daysOfHelp.length; k++) {
      if (daysOfHelp[k].value == true) {
        addAvailableHoursToDB(k);
        var ArrayOfAllTheDayRanges = [];
        for (var i = 1; i < daysOfHelp[k].hours.length; i++) {
          TimeOfDay starttime = daysOfHelp[k].hours[i].start;
          TimeOfDay endtime = daysOfHelp[k].hours[i].end;

          List<timesWithDates> Ranges = hourDivision(starttime, endtime);
//var ArrayOfAllTheDayRanges = [];
//print(ArrayOfAllTheDayRanges.length);
          ArrayOfAllTheDayRanges.add(Ranges);
          //print(ArrayOfAllTheDayRanges.length);

        } //end of generating all ranges for one day
//print(ArrayOfAllTheDayRanges.length);
        OneDayGenerating(daysOfHelp[k].title, ArrayOfAllTheDayRanges);
      } //value true
    } //loop on each day
    await Future.delayed(Duration(seconds: 1));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => facultyhome(_selectedIndex),
      ),
    );
  } //end confirm

  addAvailableHoursToDB(int x) async {
    //await
    // FirebaseFirestore.instance
    //     .collection("faculty")
    //     .doc(userid)
    //     .collection('availableHours')
    //     .doc(daysOfHelp[x].title)
    //     .set({
    //   'Day': daysOfHelp[x].title,
    // });

    // for (int i = 1; i < daysOfHelp[x].hours.length; i++) {

    //   FirebaseFirestore.instance
    //       .collection("faculty")
    //       .doc(userid)
    //       .collection('availableHours')
    //       .doc(daysOfHelp[x].title)
    //       .update({

    //     "HoursString2": FieldValue.arrayUnion([
    //       {
    //         'starttime':
    //             "${daysOfHelp[x].hours[i].start.hour}:${daysOfHelp[x].hours[i].start.minute}",
    //         'endtime':
    //             "${daysOfHelp[x].hours[i].end.hour}:${daysOfHelp[x].hours[i].end.minute}",
    //       }
    //     ]),
    //   });
    // }

    List hoursArray = [];

    for (int i = 1; i < daysOfHelp[x].hours.length; i++) {
      Map map = {
        'startTime':
            "${daysOfHelp[x].hours[i].start.hour}:${daysOfHelp[x].hours[i].start.minute}",
        'endTime':
            "${daysOfHelp[x].hours[i].end.hour}:${daysOfHelp[x].hours[i].end.minute}"
      };
      hoursArray.add(map);
    }

    await FirebaseFirestore.instance.collection("faculty").doc(userid).update({
      "availablehours": FieldValue.arrayUnion([
        {
          'Day': daysOfHelp[x].title,
          "time": hoursArray,
        }
      ]),
    });

    await FirebaseFirestore.instance.collection('faculty').doc(userid).update({
      'meetingmethod': meetingmethod,
      'mettingmethodinfo': mettingmethodinfo,
    });
  } //end method add hours to db

  hourDivision(TimeOfDay starttime, TimeOfDay endtime) {
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day, starttime.hour,
        starttime.minute); //user input converted
    DateTime end = DateTime(now.year, now.month, now.day, endtime.hour,
        endtime.minute); //user input converted

    var Ranges = <timesWithDates>[];

    var current1 = start;
    var current2 = current1.add(Duration(minutes: 25));

    while (current1.isBefore(end) && current2.isBefore(end)) {
      Ranges.add(
          new timesWithDates(StartOfRange: current1, EndOfRange: current2));

      current1 = current2.add(Duration(minutes: 5));
      current2 = current1.add(Duration(minutes: 25));
    }
    //print(Ranges); //each day will have its own array with all the available ranges in it.
    return Ranges;
  }

//Sunday
  OneDayGenerating(String day, List<dynamic> ArrayOfAllTheDayRanges) {
    var AllActualDatesWithRanges = <timesWithDates>[];

    //print("out of the firstore code start date${startdateINDate}");
    //DateTime startingDate = startdateINDate; //admin start date or today
    //print("old start date${startingDate}");
    //DateTime endDate = enddateINDate; //admin end date

    int diff = endDate.difference(startingDate).inDays;

    for (var i = 0; i <= diff; i++) {
      DateTime newDate =
          DateTime(startingDate.year, startingDate.month, startingDate.day + i);

      String dayname = DateFormat("EEE").format(
          newDate); //عشان يطلع اليوم الي فيه هذا التاريخ الجديد- الاحد او الاثنين... كسترنق

      if ((dayname == 'Sun' && day == 'Sunday') ||
          (dayname == 'Mon' && day == 'Monday') ||
          (dayname == 'Tue' && day == 'Tuesday') ||
          (dayname == 'Wed' && day == 'Wednesday') ||
          (dayname == 'Thu' && day == 'Thursday')) {
        for (var i = 0; i < ArrayOfAllTheDayRanges.length; i++) {
          for (var j = 0; j < ArrayOfAllTheDayRanges[i].length; j++) {
            DateTime start = DateTime(
                newDate.year,
                newDate.month,
                newDate.day,
                ArrayOfAllTheDayRanges[i][j].StartOfRange.hour,
                ArrayOfAllTheDayRanges[i][j].StartOfRange.minute);
            DateTime end = DateTime(
                newDate.year,
                newDate.month,
                newDate.day,
                ArrayOfAllTheDayRanges[i][j].EndOfRange.hour,
                ArrayOfAllTheDayRanges[i][j].EndOfRange.minute);

            AllActualDatesWithRanges.add(
                new timesWithDates(StartOfRange: start, EndOfRange: end));
          } //loop on one index in ArrayOfAllTheDayRanges
        } //loop on ArrayOfAllTheDayRanges

        //AllActualDatesWithRanges
        //HERE STORING IN DATABASE *****************************************

        //day
        //date
        //time
      } //end if sunday

    }

//start*************************************************************************************
    for (var i = 0; i < AllActualDatesWithRanges.length; i++) {
      Timestamp StartInTimestamp = Timestamp.fromDate(DateTime(
          AllActualDatesWithRanges[i].StartOfRange.year,
          AllActualDatesWithRanges[i].StartOfRange.month,
          AllActualDatesWithRanges[i].StartOfRange.day,
          AllActualDatesWithRanges[i].StartOfRange.hour,
          AllActualDatesWithRanges[i].StartOfRange.minute));

      Timestamp EndInTimestamp = Timestamp.fromDate(DateTime(
          AllActualDatesWithRanges[i].EndOfRange.year,
          AllActualDatesWithRanges[i].EndOfRange.month,
          AllActualDatesWithRanges[i].EndOfRange.day,
          AllActualDatesWithRanges[i].EndOfRange.hour,
          AllActualDatesWithRanges[i].EndOfRange.minute));

      FirebaseFirestore.instance
          .collection("faculty")
          .doc(userid)
          .collection('appointment')
          .doc() //Is there a specific id i should put for the appointments
          .set({
        // 'Day': day, //string
        'starttime': StartInTimestamp, //Start timestamp
        'endtime': EndInTimestamp,
        'Booked':
            false, //string if booked then it should have a student refrence
      });
    } //end for loop for one day

    print(day);
    print(AllActualDatesWithRanges.toString());
  }

  showerror(BuildContext context, String msg, int x) {
    if (daysOfHelp[x].hours.length == 1)
      setState(() {
        daysOfHelp[x].value = false;
      });
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            height: 90,
            decoration: BoxDecoration(
                color: Color(0xFFC72C41),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Oh snap!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        msg,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ));
  }
} //en
