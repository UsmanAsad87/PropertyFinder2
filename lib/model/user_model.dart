class UserModel {
  String? uid;
  String? email;
  String? firstname;
  String? secondname;
  String? phone;
  String? address;
  String? profilePic;

  UserModel(
      {this.uid,
      this.email,
      this.firstname,
      this.secondname,
      this.phone,
      this.address,
      this.profilePic});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email']??"",
      firstname: map['firstname']??"",
      secondname: map['secondname']??"",
      phone: map['phone']??"",
      address: map['address']??"",
      profilePic:map['profilePic']??"",
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstname': firstname,
      'secondname': secondname,
      'phone': phone,
      'address': address,
      'profilePic':profilePic
    };
  }
}