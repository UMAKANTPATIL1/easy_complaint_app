import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

enum AppState {
  free,
  picked,
  cropped,
}

class AddComplaint extends StatefulWidget {
  final String loginUserName;
  final String loginUserMail;
  final String loginUserContact;
  const AddComplaint(
      {Key? key,
      required this.loginUserName,
      required this.loginUserMail,
      required this.loginUserContact})
      : super(key: key);

  @override
  State<AddComplaint> createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  final descriptionController = TextEditingController();
  var departmentSelectedValue;
  final _formKey = GlobalKey<FormState>();
  bool status = false;
  File? _imageFile;
  AppState? state;
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  Position? _currentPosition;
  String currentAddress = '';
  String formattedDate = '';

  Future<void> sendApplication(String url, String storedImageName) async {
    try {
      if (_formKey.currentState!.validate()) {
        FirebaseFirestore.instance.collection('complaint_data').add({
          'status': 'Pending',
          'isCompleted': 'NO',
          'feedback': '',
          'department': departmentSelectedValue,
          'description': descriptionController.text.toString(),
          'complaint_location': currentAddress,
          'user_name': widget.loginUserName,
          'user_email': widget.loginUserMail,
          'user_contact': widget.loginUserContact,
          'image': url,
          'imageName': storedImageName,
          'date': formattedDate,
        }).then((_) {
          setState(() {
            status = false;
          });
          Navigator.of(context).pop();
          showSnackBar(context, "Complaint Sent Successfully");
        });
      }
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
  void initState() {
    super.initState();
    state = AppState.free;
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String storedImageName = "img${DateTime.now()}";
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("uploads/$storedImageName");
    UploadTask uploadTask = ref.putFile(_imageFile!);
    await uploadTask.whenComplete(() {
      ref.getDownloadURL().then(
            (value) => sendApplication(value, storedImageName),
          );
    }).catchError((onError) {
      print(onError);
    });
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.best))
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng(); // This function is for Geocoding.
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      Placemark place = p[0];
      setState(() {
        currentAddress =
            "${place.street}, ${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}";
      });
    } catch (e) {
      print(e);
    }
  }

  getDate() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat("dd-MM-yyyy hh:mm");
    final String formatted = formatter.format(now);
    setState(() {
      formattedDate = formatted;
    });
  }

  Future<void> _pickImage() async {
    ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((image) async {
      await _getCurrentLocation();
      await getDate();
      setState(() {
        _imageFile = File(image!.path);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b4850),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b4850),
        title: const Text(
          "Add Complaint",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 50, 16, 0),
            child: Column(
              children: [
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
                const SizedBox(height: 20),
                TextFormField(
                  maxLines: 3,
                  minLines: 3,
                  autofocus: false,
                  controller: descriptionController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Description cannot be Empty");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    descriptionController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.description, color: Colors.grey),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Description",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFFFFFFF))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: _imageFile != null,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                        top: 10, left: 30, right: 30, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38)),
                    margin: const EdgeInsets.only(
                        top: 20, bottom: 20, left: 20, right: 20),
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.file(
                              _imageFile!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitHeight,
                            ),
                          )
                        : Container(),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  currentAddress,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _pickImage();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(150, 40),
                      ),
                      child: const Text(
                        "Load Image",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0b4850)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Visibility(
                    visible: status == true,
                    child: const Center(child: CircularProgressIndicator())),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        uploadImageToFirebase(context);
                        setState(() {
                          status = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(250, 40),
                      ),
                      child: const Text(
                        "Submit",
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
