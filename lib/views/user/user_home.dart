import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_complaint_system/views/user/complaint_list.dart';
import 'package:easy_complaint_system/views/user/helplin_list.dart';
import 'package:flutter/material.dart';
import '../login_page.dart';
import 'add_complaint.dart';

class UserHome extends StatefulWidget {
  final String loginUserEmail;
  const UserHome({Key? key, required this.loginUserEmail}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  List userList = [];
  List userDocID = [];

  Future<List?> getUserData() async {
    try {
      var collection = FirebaseFirestore.instance
          .collection('user_credentials')
          .where('email', isEqualTo: widget.loginUserEmail);
      var querySnapshots = await collection.get();
      for (var i = 0; i < querySnapshots.docs.length; i++) {
        userDocID.add(querySnapshots.docs[i].id.toString());
      }
      setState(() {
        userList = querySnapshots.docs;
      });
      if (userList.isEmpty) {
        showSnackBar(context, "No Record Found");
      }
    } on FirebaseException catch (e) {
      print(e.code);
    }
    return userList;
  }

  showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b4850),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
        backgroundColor: const Color(0xFF0b4850),
        title: const Text(
          "User Home",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddComplaint(
                              loginUserName: userList[0]['name'].toString(),
                              loginUserContact:
                                  userList[0]['contact'].toString(),
                              loginUserMail: widget.loginUserEmail,
                            )));
              },
              child: Column(
                children: [
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset("assets/images/add_complaint.png")),
                  const SizedBox(height: 10),
                  const Text(
                    "Add Complaint",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ComplaintList(
                              loginUserName: userList[0]['name'].toString(),
                              loginUserContact:
                                  userList[0]['contact'].toString(),
                              loginUserMail: widget.loginUserEmail,
                            )));
              },
              child: Column(
                children: [
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset("assets/images/complaint_list.png")),
                  const SizedBox(height: 10),
                  const Text(
                    "View Complaint",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HelplineNumber(
                              loginUserMail: widget.loginUserEmail,
                            )));
              },
              child: Column(
                children: [
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset("assets/images/helpline.png")),
                  const SizedBox(height: 10),
                  const Text(
                    "Helpline",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(context) async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}
