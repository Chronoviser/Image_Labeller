import 'package:cloud_firestore/cloud_firestore.dart';

class Car{

  String carBrand;
  String carColor;

  DocumentReference reference;

  Car(this.carBrand, this.carColor, {this.reference});

  Map<String, dynamic> toJson(Car car){
    return {
      'carBrand' : car.carBrand,
      'carColor' : car.carColor
    };
  }

  factory Car.fromSnapshot(DocumentSnapshot snapshot) {
    return Car(
      snapshot['carBrand'],
      snapshot['carColor']
    );
  }
}