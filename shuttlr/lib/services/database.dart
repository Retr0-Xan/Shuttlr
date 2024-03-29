import 'package:cloud_firestore/cloud_firestore.dart';


//this class will be used to create, read, update locations in the firestore
//we create a database service class which takes in the uid
//uid is the uid of the current signed in user
//we use this uid to create a document with the same id as the uid of the user(driver)
class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference locationCollection =
      FirebaseFirestore.instance.collection('locations');

  Future updateLocation(String longitude, String latitude) async {
    return await locationCollection.doc(uid).set({
      'longitude': longitude,
      'latitude': latitude,
    });
  }
  //this is a stream of snapshots
  //basically the current instances of the database at a particular moment in time
  Stream<QuerySnapshot> get locations {
    return locationCollection.snapshots();
  }
}
