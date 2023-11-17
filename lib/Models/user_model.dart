class UserModel {
  String? uid;
  String? email;
  String? name;
  String? pwd;
  String? contact;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.pwd,
    this.contact,
  });

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      pwd: map['password'],
      contact: map['contact'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'contact': contact,
      'name': name,
      'password': pwd,
    };
  }
}
