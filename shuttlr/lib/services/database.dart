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

  final CollectionReference historyCollection =
      FirebaseFirestore.instance.collection('history');

  Future updateLocation(String latitude, String longitude, String route) async {
    return await locationCollection
        .doc(uid)
        .set({'latitude': latitude, 'longitude': longitude, 'route': route});
  }

  Future updateHistory(String route, String timeElapsed) async {
    return await historyCollection.doc(uid).set({
      'route': route,
      'time_elapsed': timeElapsed,
    });
  }

  //this is a stream of snapshots
  //basically the current instances of the database at a particular moment in time
  Stream<QuerySnapshot> get locations {
    return locationCollection.snapshots();
  }

  Stream<QuerySnapshot> get histories {
    return historyCollection.snapshots();
  }
}
