import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDepartment extends StatefulWidget {
  const AddDepartment({Key? key}) : super(key: key);

  @override
  State<AddDepartment> createState() => _AddDepartmentState();
}

class _AddDepartmentState extends State<AddDepartment> {
  final _departmentNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _helplineController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> addDepartment() async {
    try {
      CollectionReference ref =
          FirebaseFirestore.instance.collection('department_credentials');
      String docId = ref.doc().id;
      await ref.doc(docId).set({
        'department_name': _departmentNameController.text.toString(),
        'email': _emailController.text.toString(),
        'password': _passController.text.toString(),
        'helpline': _helplineController.text.toString(),
        'doc_id': docId,
      }).then((_) {
        Navigator.of(context).pop();
        showSnackBar(context, "Department Added Successfully");
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
          "Add Department",
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
                TextFormField(
                  controller: _departmentNameController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value?.isEmpty == null || value!.isEmpty) {
                      return "Enter Department Name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.corporate_fare, color: Colors.grey),
                    hintText: "Department Name",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty == null || value!.isEmpty) {
                      return "Enter email";
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Please Enter a valid email");
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter valid password";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.vpn_key, color: Colors.grey),
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _helplineController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter valid Helpline Number";
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
                          addDepartment();
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
