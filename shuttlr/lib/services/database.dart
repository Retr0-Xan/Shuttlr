import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference locationCollection =
      FirebaseFirestore.instance.collection('locations');

  Future updateLocation(String longitude, String latitude) async {
    return await locationCollection.doc(uid).set({
      'longitude' : longitude,
      'latitude' : latitude,
    });
  }
}
