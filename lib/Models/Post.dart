import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    this.violation,
    this.description,
    this.status,
    this.mediaUrls,
    this.mediaDetails,
    this.numberPlate,
    this.latitude,
    this.longitude,
    this.uploadTime,
  });

  final String violation;
  final String description;
  final String status;
  final List mediaUrls;
  final List mediaDetails;
  final String numberPlate;
  final double latitude;
  final double longitude;
  final Timestamp uploadTime;
}
