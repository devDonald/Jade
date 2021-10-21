import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  String doctorId, name, photo, address, email, title, state;
  bool isDoctor, isBusy;

  DoctorModel(
      {this.doctorId,
      this.name,
      this.email,
      this.photo,
      this.address,
      this.title,
      this.isBusy,
      this.state,
      this.isDoctor});

  toJson() {
    return {
      "doctorId": doctorId,
      'name': name,
      'address': address,
      'email': email,
      'title': title,
      'photo': photo,
      'isBusy': isBusy,
      'state': state,
      'isDoctor': isDoctor,
    };
  }

  DoctorModel.fromSnapshot(DocumentSnapshot snapshot) {
    this.doctorId = snapshot['doctorId'];
    this.name = snapshot['name'];
    this.address = snapshot['address'];
    this.title = snapshot['title'];
    this.email = snapshot['email'];
    this.photo = snapshot['photo'];
    this.isBusy = snapshot['isBusy'];
    this.state = snapshot['state'];
    this.isDoctor = snapshot['isDoctor'];
  }
}
