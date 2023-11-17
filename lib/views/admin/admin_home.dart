import 'package:easy_complaint_system/views/admin/add_department.dart';
import 'package:easy_complaint_system/views/admin/department_list.dart';
import 'package:flutter/material.dart';
import '../login_page.dart';

class AdminHome extends StatefulWidget {
  final String loginUserEmail;
  const AdminHome({Key? key, required this.loginUserEmail}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b4850),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b4850),
        title: const Text(
          "Admin",
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
                    builder: (context) => const AddDepartment(),
                  ),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset("assets/images/add_department.png"),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Add Department",
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
                      builder: (context) => const DepartmentList()),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset("assets/images/department.png")),
                  const SizedBox(height: 10),
                  const Text(
                    "View Departments",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 80),
            // InkWell(
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const AddHelpline()));
            //   },
            //   child: Column(
            //     children: [
            //       SizedBox(
            //           height: 100,
            //           width: 100,
            //           child: Image.asset("assets/images/helpline.png")),
            //       const SizedBox(height: 10),
            //       const Text(
            //         "Add Helpline",
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 18,
            //             fontWeight: FontWeight.bold),
            //       ),
            //     ],
            //   ),
            // ),
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
