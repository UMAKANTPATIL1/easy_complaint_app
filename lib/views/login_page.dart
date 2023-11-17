import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_complaint_system/views/department/department_home.dart';
import 'package:easy_complaint_system/views/signup_page.dart';
import 'package:easy_complaint_system/views/user/user_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'admin/admin_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAdmin = true;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List? userList;
  bool status = false;
  var selectedValue;
  var profile = ['Admin', 'Department', 'User'];

  void _show() {
    showSnackBar(context, "Select Profile");
  }

  Future<void> checkLoginStatus() async {
    try {
      status = false;
      String tableName = "";

      if (selectedValue == 'Admin') {
        tableName = "admin_credentials";
      } else if (selectedValue == 'Department') {
        tableName = "department_credentials";
      } else {
        tableName = "user_credentials";
      }
      var collection = FirebaseFirestore.instance.collection(tableName);
      var querySnapshots = await collection.get();
      userList = querySnapshots.docs;

      if (userList != null && userList!.isNotEmpty) {
        for (int i = 0; i < userList!.length; i++) {
          if (userList![i]['email'].toString() ==
                  _emailController.text.toString() &&
              userList![i]['password'].toString() ==
                  _passController.text.toString()) {
            status = true;
            break;
          }
        }
      }

      if (status) {
        setState(() {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => selectedValue == 'Admin'
                      ? AdminHome(
                          loginUserEmail: _emailController.text.toString(),
                        )
                      : selectedValue == 'Department'
                          ? DepartmentHome(
                              loginUserEmail: _emailController.text.toString(),
                            )
                          : UserHome(
                              loginUserEmail:
                                  _emailController.text.toString())));
        });
      } else {
        showSnackBar(context, "incorrect email password");
      }
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b4850),   //background_colour
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Easy Complaint System",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0b4850),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20.0,
          ),
          DropdownButton(
              dropdownColor: const Color(0xFF0b4850),
              hint: const Text("Select Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              value: selectedValue,
              items: profile
                  .map(
                    (v) => DropdownMenuItem(
                      value: v,
                      child: Text(
                        v,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selectedValue = v!)),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              "Please Enter Login Details",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 40.0,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            //  style: TextStyle(color: Colors.black),  //textColor
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
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      selectedValue == null ? _show() : checkLoginStatus();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      //primary: Colors.blue,
                      minimumSize: const Size(150, 40),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0b4850)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Visibility(
              visible: selectedValue == 'User',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
