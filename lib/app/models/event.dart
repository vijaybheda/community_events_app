import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final String imageUrl;
  final String createdBy;
  final List<String> attendees;
  final String category;
  final DateTime createdOn;
  final DateTime updatedOn;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.imageUrl,
    required this.createdBy,
    required this.attendees,
    required this.category,
    required this.createdOn,
    required this.updatedOn,
  });

  factory Event.fromMap(Map<String, dynamic> map, String id) {
    return Event(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdBy: map['createdBy'] ?? '',
      attendees: List<String>.from(map['attendees'] ?? []),
      category: map['category'] ?? '',
      createdOn: (map['createdOn'] as Timestamp).toDate(),
      updatedOn: (map['updatedOn'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dateTime': dateTime,
      'location': location,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'attendees': attendees,
      'category': category,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }
}
