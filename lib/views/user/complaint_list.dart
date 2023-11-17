import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_complaint_system/views/user/complaint_image.dart';
import 'package:flutter/material.dart';

class ComplaintList extends StatefulWidget {
  final String loginUserName;
  final String loginUserMail;
  final String loginUserContact;
  const ComplaintList(
      {Key? key,
      required this.loginUserName,
      required this.loginUserMail,
      required this.loginUserContact})
      : super(key: key);

  @override
  State<ComplaintList> createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  final _formKey = GlobalKey<FormState>();
  final feedbackEditingController = TextEditingController();
  List complaintList = [];
  List complaintDocID = [];

  Future<List?> getComplaintData() async {
    try {
      var collection = FirebaseFirestore.instance
          .collection('complaint_data')
          .where('user_email', isEqualTo: widget.loginUserMail);
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

  Future<void> updateFeedback(int index) async {
    try {
      FirebaseFirestore.instance
          .collection('complaint_data')
          .doc(complaintDocID[index])
          .update({
        'feedback': feedbackEditingController.text,
      }).then((value) {
        setState(() {
          getComplaintData();
        });
        showSnackBar(context, "Feedback Added");
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
          "Complaints",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                                      "Department",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      complaintList[index]['department']
                                          .toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                        complaintList[index]
                                                ['complaint_location']
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
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
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Status",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      complaintList[index]['status'].toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Visibility(
                                  visible: complaintList[index]['status'] ==
                                      'Accepted',
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Is Complaint Resolved",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        complaintList[index]['isCompleted']
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: complaintList[index]
                                              ['isCompleted'] ==
                                          'YES' &&
                                      complaintList[index]['feedback'] == '',
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 40,
                                        child: TextFormField(
                                          autofocus: false,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          textAlign: TextAlign.start,
                                          controller: feedbackEditingController,
                                          keyboardType: TextInputType.text,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return ("Feedback cannot be Empty");
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            feedbackEditingController.text =
                                                value!;
                                          },
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                                Icons.feedback,
                                                color: Colors.grey,
                                                size: 16),
                                            //contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                            contentPadding: EdgeInsets.zero,
                                            hintText: "Feedback",
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Color(0xFFFFFFFF))),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xFFFFFFFF))),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              updateFeedback(index);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              minimumSize: const Size(120, 30),
                                            ),
                                            child: const Text(
                                              "Submit",
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
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
