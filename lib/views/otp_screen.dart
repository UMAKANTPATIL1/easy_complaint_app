import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/user_model.dart';
import 'login_page.dart';

class OtpScreen extends StatefulWidget {
  final String name;
  final String email;
  final String contact;
  final String password;
  const OtpScreen(
      {Key? key,
      required this.name,
      required this.email,
      required this.contact,
      required this.password})
      : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _auth = FirebaseAuth.instance;
  String verificationID = "";
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  @override
  void initState() {
    super.initState();
    verifyNumber(widget.email, widget.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 10, right: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "CODE",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold, fontSize: 80),
                ),
                Text(
                  "VERIFICATION",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 40),
                const Text(
                  "Enter Verification code send at",
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.contact,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: otpController,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter OTP");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    otpController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.sms, color: Colors.grey),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "OTP",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFFFFFFF))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        verifyOTP();
                      }
                    },
                    child: const Text("Submit"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyNumber(String email, String password) {
    _auth.verifyPhoneNumber(
      phoneNumber: widget.contact,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential).then((value) {
          signUp(email, password);
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBar(context, "Verification Failed Try Again");
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationID = verificationId;
        showSnackBar(context, "OTP Sent to Number");
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    await _auth.signInWithCredential(credential).then((value) {
      signUp(widget.email, widget.password);
    });
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFireStore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFireStore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = widget.name;
    userModel.contact = widget.contact;
    userModel.pwd = widget.password;

    await firebaseFirestore
        .collection("user_credentials")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
  }
}
