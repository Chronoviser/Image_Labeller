import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///E:/summer_course_android/peeling_firebase/lib/Firebase_CRUD/cars.dart';

class DataRepository {
  CollectionReference collection = Firestore.instance.collection('cars');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<void> addCar(Car car) {
    collection.document().setData(car.toJson(car));
  }

  deleteCar(Car car) async {
    await collection.document(car.reference.documentID).delete();
  }

  updateCar(Car car) async {
    await collection.document(car.reference.documentID).updateData(car.toJson(car));
  }
}
