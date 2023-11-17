import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../user/complaint_image.dart';

class PendingComplaints extends StatefulWidget {
  final String departmentName;
  const PendingComplaints({Key? key, required this.departmentName})
      : super(key: key);

  @override
  State<PendingComplaints> createState() => _PendingComplaintsState();
}

class _PendingComplaintsState extends State<PendingComplaints> {
  List complaintList = [];
  List complaintDocID = [];

  Future<List?> getComplaintData() async {
    try {
      var collection = FirebaseFirestore.instance
          .collection('complaint_data')
          .where('department', isEqualTo: widget.departmentName)
          .where('status', isEqualTo: 'Pending');
      var querySnapshots = await collection.get();
      for (var i = 0; i < querySnapshots.docs.length; i++) {
        complaintDocID.add(querySnapshots.docs[i].id.toString());
      }
      setState(() {
        complaintList = querySnapshots.docs;
      });
      if (complaintList.isEmpty) {
        showSnackBar(context, "No Record Found");
      }
    } on FirebaseException catch (e) {
      print(e.code);
    }
    return complaintList;
  }

  Future<void> updateClaimData(int index, String status) async {
    try {
      FirebaseFirestore.instance
          .collection('complaint_data')
          .doc(complaintDocID[index])
          .update({
        'status': status,
      }).then((value) {
        setState(() {
          getComplaintData();
        });
        showSnackBar(context, "Complaint $status");
      });
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  @override
  void initState() {
    getComplaintData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b4850),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b4850),
        title: const Text(
          "Pending Complaints",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: complaintList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ComplaintImage(
                                      imageUrl: complaintList[index]['image']
                                          .toString(),
                                    )));
                      },
                      child: Card(
                        elevation: 8,
                        shadowColor: Colors.white,
                        color: const Color(0xFF0b4850),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Complaint By",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    complaintList[index]['user_name']
                                        .toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Contact",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    complaintList[index]['user_contact']
                                        .toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Complaint About",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    complaintList[index]['description']
                                        .toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Location",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      complaintList[index]['complaint_location']
                                          .toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Date",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    complaintList[index]['date'].toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      updateClaimData(index, "Accepted");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      minimumSize: const Size(120, 30),
                                    ),
                                    child: const Text(
                                      "Accept",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0b4850)),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      updateClaimData(index, "Rejected");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      minimumSize: const Size(120, 30),
                                    ),
                                    child: const Text(
                                      "Reject",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0b4850)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
