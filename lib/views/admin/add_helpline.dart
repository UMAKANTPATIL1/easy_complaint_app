import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddHelpline extends StatefulWidget {
  const AddHelpline({Key? key}) : super(key: key);

  @override
  State<AddHelpline> createState() => _AddHelplineState();
}

class _AddHelplineState extends State<AddHelpline> {
  final _helplineController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var departmentSelectedValue;

  Future<void> addDepartment() async {
    try {
      CollectionReference ref =
          FirebaseFirestore.instance.collection('helpline_data');
      String docId = ref.doc().id;
      await ref.doc(docId).set({
        'department_name': departmentSelectedValue,
        'helpline_number': _helplineController.text.toString(),
        'doc_id': docId,
      }).then((_) {
        Navigator.of(context).pop();
        showSnackBar(context, "Helpline Added Successfully");
      });
    } on FirebaseException catch (e) {
      print("Error: $e.code");
      showSnackBar(context, "Something went wrong");
    }
  }

  showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b4850),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b4850),
        title: const Text(
          "Add Helpline",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('department_credentials')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      const Text("Loading");
                    }
                    return DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF0b4850),
                      validator: (value) {
                        if (value?.isEmpty == null || value!.isEmpty) {
                          return "Select Department";
                        }
                        return null;
                      },
                      items: snapshot.data?.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        return DropdownMenuItem<String>(
                          value: documentSnapshot.get('department_name'),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              documentSnapshot.get('department_name'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF1F4F8))),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFF1F4F8)),
                        ),
                      ),
                      onChanged: (personValue) {
                        setState(() {
                          departmentSelectedValue = personValue;
                        });
                      },
                      value: departmentSelectedValue,
                      isExpanded: false,
                      hint: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Select Department",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  obscureText: true,
                  controller: _helplineController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Helpline Number";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Helpline Number",
                    prefixIcon: Icon(Icons.phone, color: Colors.grey),
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          //addDepartment();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(250, 40),
                      ),
                      child: const Text(
                        "Add",
                        style: TextStyle(
                            fontSize: 18.0,
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
  }
}
