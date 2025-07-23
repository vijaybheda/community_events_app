import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';
import '../models/app_user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Events
  Stream<List<Event>> getEvents() {
    return _db.collection('events').orderBy('dateTime').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Event.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addEvent(Event event) async {
    await _db.collection('events').add(event.toMap());
  }

  Future<void> updateEvent(Event event) async {
    await _db.collection('events').doc(event.id).update(event.toMap());
  }

  Future<void> deleteEvent(String eventId) async {
    await _db.collection('events').doc(eventId).delete();
  }

  // Users
  Future<void> createUser(AppUser user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data()!);
    }
    return null;
  }
} 