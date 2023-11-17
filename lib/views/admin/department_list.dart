import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DepartmentList extends StatefulWidget {
  const DepartmentList({Key? key}) : super(key: key);

  @override
  State<DepartmentList> createState() => _DepartmentListState();
}

class _DepartmentListState extends State<DepartmentList> {
  List departmentList = [];
  List departmentDocID = [];

  Future<List?> getDepartmentData() async {
    try {
      var collection =
          FirebaseFirestore.instance.collection('department_credentials');
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

  void deleteDepartment(int index) {
    FirebaseFirestore.instance
        .collection("department_credentials")
        .doc(departmentList[index]['doc_id'])
        .delete()
        .then((value) {
      setState(() {
        getDepartmentData();
      });
    });
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
          "Departments",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: departmentList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: InkWell(
                      onLongPress: () {
                        deleteDepartment(index);
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
                                    departmentList[index]['department_name']
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
                                    "Email",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    departmentList[index]['email'].toString(),
                                    style: const TextStyle(color: Colors.white),
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
            const SizedBox(height: 10),
            const Text(
              "Long press to delete department",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
