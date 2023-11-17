import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_complaint_system/views/department/approved_complaints.dart';
import 'package:easy_complaint_system/views/department/pending_complaints.dart';
import 'package:easy_complaint_system/views/department/rejected_complaints.dart';
import 'package:flutter/material.dart';
import '../login_page.dart';

class DepartmentHome extends StatefulWidget {
  final String loginUserEmail;
  const DepartmentHome({Key? key, required this.loginUserEmail})
      : super(key: key);

  @override
  State<DepartmentHome> createState() => _DepartmentHomeState();
}

class _DepartmentHomeState extends State<DepartmentHome> {
  List departmentList = [];
  List departmentDocID = [];

  Future<List?> getDepartmentData() async {
    try {
      var collection = FirebaseFirestore.instance
          .collection('department_credentials')
          .where('email', isEqualTo: widget.loginUserEmail);
      var querySnapshots = await collection.get();
      for (var i = 0; i < querySnapshots.docs.length; i++) {
        departmentDocID.add(querySnapshots.docs[i].id.toString());
      }
      setState(() {
        departmentList = querySnapshots.docs;
      });
      if (departmentList.isEmpty) {
        showSnackBar(context, "No Record Found");
      }
    } on FirebaseException catch (e) {
      print(e.code);
    }
    return departmentList;
  }

  showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  @override
  void initState() {
    getDepartmentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b4850),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b4850),
        title: const Text(
          "Department Home",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
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
                        builder: (context) => PendingComplaints(
                              departmentName: departmentList[0]
                                      ['department_name']
                                  .toString(),
                            )));
              },
              child: Column(
                children: [
                  SizedBox(
                      height: 100,
                      width: 100,
                      child:
                          Image.asset("assets/images/pending_complaints.png")),
                  const SizedBox(height: 10),
                  const Text(
                    "Pending Complaints",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ApprovedComplaints(
                              departmentName: departmentList[0]
                                      ['department_name']
                                  .toString(),
                            )));
              },
              child: Column(
                children: [
                  SizedBox(
                      height: 100,
                      width: 100,
                      child:
                          Image.asset("assets/images/approved_complaints.png")),
                  const SizedBox(height: 10),
                  const Text(
                    "Approved Complaints",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RejectedComplaints(
                              departmentName: departmentList[0]
                                      ['department_name']
                                  .toString(),
                            )));
              },
              child: Column(
                children: [
                  SizedBox(
                      height: 100,
                      width: 100,
                      child:
                          Image.asset("assets/images/rejected_complaints.png")),
                  const SizedBox(height: 10),
                  const Text(
                    "Rejected Complaints",
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
