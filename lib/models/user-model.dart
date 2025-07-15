import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel{
  final String UserId;
  final String UserName;
  final String UserEmail;
  final String streetadress;
  final String country;
  final String phoneNo;

  Usermodel({
   required this.UserId,
   required this.UserName,
   required this.UserEmail,
    required this.streetadress,
    required this.country,
    required this.phoneNo

});
  factory Usermodel.fromDucumen(DocumentSnapshot doc){
    return Usermodel(
      UserId: doc['userId'],
      UserName: doc['fullname'],
      UserEmail: doc['emailadress'],
        streetadress: doc['streetadress'],
        country: doc['country'],
        phoneNo: doc['phoneNo']
    );
  }
}