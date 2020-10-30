/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peelingfirebase/Firebase_CRUD/cars.dart';
import 'package:peelingfirebase/Firebase_CRUD/datarepository.dart';

//ignore that car error it's useless
//it is just coming becoz i changed the directories
//to reemove this error , just cut this entire code and paste  it below myApp in main.dart

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DataRepository dataRepository = DataRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Peeling Firebase",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: dataRepository.getStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return _buildList(context, snapshot.data.documents);
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          addDialog(context);
        },
      ),
    );
  }

  Future<bool> addDialog(BuildContext context) {
    String carBrand;
    String carColor;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: MediaQuery.of(context).size.height * 0.26),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Enter Info About New Car 🚗",
                        style: TextStyle(fontSize: 24, color: Colors.cyan)),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        onChanged: (val) {
                          carBrand = val.toLowerCase();
                        },
                        decoration:
                        InputDecoration(hintText: "Enter Car Brand"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        onChanged: (val) {
                          carColor = val.toLowerCase();
                        },
                        decoration:
                        InputDecoration(hintText: "Enter Car Color"),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (carBrand != null && carColor != null) {
                          Car car = Car(carBrand, carColor);
                          dataRepository.addCar(car);
                          Navigator.of(context).pop();
                        }
                      },
                      color: Colors.cyan,
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((e) => _buildListItem(context, e)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    Car car = Car.fromSnapshot(snapshot);
    car.reference = snapshot.reference;
    Color carcolor = Colors.white;

    if (car.carColor == "black") {
      carcolor = Colors.black;
    } else if (car.carColor == "red") {
      carcolor = Colors.red;
    } else if (car.carColor == "blue") {
      carcolor = Colors.indigo;
    } else if (car.carColor == "brown") {
      carcolor = Colors.brown;
    } else if (car.carColor == "golden") {
      carcolor = Colors.yellow;
    } else if (car.carColor == "silver") {
      carcolor = Colors.grey;
    }

    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        onTap: () {
          updateDialog(context, car);
        },
        onLongPress: () {
          dataRepository.deleteCar(car);
        },
        title: Text(
          car.carBrand,
          style: TextStyle(
              fontFamily: 'cursive', fontSize: 24, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.directions_car, color: carcolor),
      ),
    );
  }

  Future<bool> updateDialog(BuildContext context, Car car) {
    String carBrand = car.carBrand;
    String carColor = car.carColor;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: MediaQuery.of(context).size.height * 0.26),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Enter Info About New Car 🚗",
                        style: TextStyle(fontSize: 24, color: Colors.cyan)),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        onChanged: (val) {
                          carBrand = val.toLowerCase();
                        },
                        decoration: InputDecoration(hintText: carBrand),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        onChanged: (val) {
                          carColor = val.toLowerCase();
                        },
                        decoration: InputDecoration(hintText: carColor),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (carBrand != car.carBrand ||
                            carColor != car.carColor) {
                          car.carBrand = carBrand;
                          car.carColor = carColor;
                          dataRepository.updateCar(car);
                          Navigator.of(context).pop();
                        }
                      },
                      color: Colors.cyan,
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
*/