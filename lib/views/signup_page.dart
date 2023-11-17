import 'package:easy_complaint_system/views/otp_screen.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final contactEditingController = TextEditingController();
  final branchEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  final otpController = TextEditingController();

  showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Name Field
    final nameField = TextFormField(
      autofocus: false,
      controller: nameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        nameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person, color: Colors.grey),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Full Name",
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFFFFFFF))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFFFFF))),
      ),
    );

    // Email Field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email, color: Colors.grey),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFFFFFFF))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFFFFF))),
      ),
    );

    // contact Field
    final contactField = TextFormField(
      autofocus: false,
      controller: contactEditingController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Mobile No");
        }
        return null;
      },
      onSaved: (value) {
        contactEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.phone, color: Colors.grey),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Mobile No",
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFFFFFFF))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFFFFF))),
      ),
    );

    // Password Field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
        return null;
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key, color: Colors.grey),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFFFFFFF))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFFFFF))),
      ),
    );

    // Confirm Password Field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return "Password don't match";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key, color: Colors.grey),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFFFFFFF))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFFFFF))),
      ),
    );

    final signUpButton = Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtpScreen(
                              name: nameEditingController.text.toString(),
                              email: emailEditingController.text.toString(),
                              contact: "+91${contactEditingController.text}",
                              password:
                                  passwordEditingController.text.toString(),
                            )));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(150, 40),
            ),
            child: const Text(
              "Sign Up",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0b4850)),
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      backgroundColor: const Color(0xFF0b4850),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b4850),
        automaticallyImplyLeading: false,
        title: const Text("Sign Up", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0xFF0b4850),
            child: Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    nameField,
                    const SizedBox(height: 20),
                    emailField,
                    const SizedBox(height: 20),
                    contactField,
                    const SizedBox(height: 20),
                    passwordField,
                    const SizedBox(height: 20),
                    confirmPasswordField,
                    const SizedBox(height: 20),
                    signUpButton,
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
