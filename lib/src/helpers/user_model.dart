import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId, name, photo, address, gender;
  bool isDoctor;
  String occupation, phone, email, age;

  UserModel(
      {this.userId,
      this.name,
      this.photo,
      this.address,
      this.phone,
      this.email,
      this.occupation,
      this.gender,
      this.age,
      this.isDoctor});

  toJson() {
    return {
      "userId": userId,
      "email": email,
      'name': name,
      'address': address,
      'gender': gender,
      'phone': phone,
      'photo': photo,
      'age': age,
      'isDoctor': isDoctor,
      'occupation': occupation,
    };
  }

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    this.userId = snapshot['userId'];
    this.name = snapshot['name'];
    this.email = snapshot['email'];
    this.address = snapshot['address'];
    this.phone = snapshot['phone'];
    this.gender = snapshot['gender'];
    this.photo = snapshot['photo'];
    this.isDoctor = snapshot['isDoctor'];
    this.occupation = snapshot['occupation'];
    this.age = snapshot['age'];
  }
}
