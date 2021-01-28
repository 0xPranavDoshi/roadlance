import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import './HttpManager.dart';
import '../Models/Post.dart';
import 'dart:io';

class DatabaseManager {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<int> getUserBalance() {
    return firestore
        .collection('Users')
        .doc(auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot snap) {
      Map data = snap.data();
      print("Data is ${data['CurrentBalance']}");
      return data['CurrentBalance'];
    });
  }

  Future createMediaDetails(List<Map> mediaDetails, Timestamp time) async {
    CollectionReference postsRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .collection('Posts');

    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');
    //   FirebaseAuth auth = FirebaseAuth.instance;

    usersRef
        .doc(auth.currentUser.uid)
        .update({'FirstMediaTime': time.toDate().toString()})
        .then((value) => print("User data saved to Firestore"))
        .catchError((error) => print("Failed to add user data: $error"));

    postsRef
        .doc(time.toDate().toString())
        .set({
          'Violation': null,
          'Description': null,
          'Media-Urls': [],
          'Media-Details': mediaDetails,
          'PhoneNumber': null,
          'NumberPlate': null,
          'Uid': null,
          'Email': null,
          'Latitude': null,
          'Longitude': null,
          'UploadTime': null,
          'Status': null,
        })
        .then((value) => print("Post details saved to Firestore"))
        .catchError((error) => print("Failed to add Post details: $error"));
  }

  Future updateMediaDetails(List<Map> mediaDetails, Timestamp time) async {
    print("Media details are $mediaDetails");
    String firstMediaTime;
    CollectionReference postsRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .collection('Posts');

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        print('Document data: $data');
        firstMediaTime = data['FirstMediaTime'];
      } else {
        print('Document does not exist on the database');
      }
    });

    print("Path is $firstMediaTime");

    return postsRef
        .doc(firstMediaTime)
        .update({'Media-Details': mediaDetails})
        .then((value) => print("Updated Media-Details"))
        .catchError((error) => print("Failed to update Media-Details: $error"));
  }

  Future uploadPost(Post post) async {
    String firstMediaTime;
    String phoneNumber;

    print("Uploading post");

    CollectionReference postsRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .collection('Posts');

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        print('Document data: $data');
        phoneNumber = data['PhoneNumber'];
      } else {
        print('Document does not exist on the database');
      }
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        print('Document data: $data');
        firstMediaTime = data['FirstMediaTime'];
      } else {
        print('Document does not exist on the database');
      }
    });

    postsRef
        .doc(firstMediaTime)
        .update({'Violation': post.violation})
        .then((value) => print("Updated Violation"))
        .catchError((error) => print("Failed to update Violation: $error"));
    postsRef
        .doc(firstMediaTime)
        .update({'Description': post.description})
        .then((value) => print("Updated Description"))
        .catchError((error) => print("Failed to update Description: $error"));
    postsRef
        .doc(firstMediaTime)
        .update({'PhoneNumber': phoneNumber})
        .then((value) => print("Updated PhoneNumber"))
        .catchError((error) => print("Failed to update PhoneNumber: $error"));
    postsRef
        .doc(firstMediaTime)
        .update({'Uid': auth.currentUser.uid})
        .then((value) => print("Updated Uid"))
        .catchError((error) => print("Failed to update Uid: $error"));
    postsRef
        .doc(firstMediaTime)
        .update({'Email': auth.currentUser.email})
        .then((value) => print("Updated Email"))
        .catchError((error) => print("Failed to update Email: $error"));
    postsRef
        .doc(firstMediaTime)
        .update({'Latitude': post.latitude})
        .then((value) => print("Updated Latitude"))
        .catchError((error) => print("Failed to update Latitude: $error"));
    postsRef
        .doc(firstMediaTime)
        .update({'Longitude': post.longitude})
        .then((value) => print("Updated Longitude"))
        .catchError((error) => print("Failed to update Longitude: $error"));
    postsRef
        .doc(firstMediaTime)
        .update({'UploadTime': post.uploadTime})
        .then((value) => print("Updated UploadTime"))
        .catchError((error) => print("Failed to update UploadTime: $error"));
    postsRef
        .doc(firstMediaTime)
        .update({'Status': post.status})
        .then((value) => print("Updated Status"))
        .catchError((error) => print("Failed to update Status: $error"));
  }

  Future uploadFiles(List<File> files, Timestamp uploadTime) async {
    String url;
    for (var i = 0; i < files.length; i++) {
      File file = files[i];
      String path = 'Images/${uploadTime.toDate().toString()}/Media${i + 1}';
      try {
        await firebase_storage.FirebaseStorage.instance.ref(path).putFile(file);
        print("Successfully added media files");
        url = await getDownloadUrl(path);
        uploadUrl(url);
      } on firebase_core.FirebaseException catch (e) {
        print("Error upload files: ${e.message}");
      }
    }
  }

  Future<String> getDownloadUrl(String path) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(path)
        .getDownloadURL();
    return downloadURL;
  }

  Future uploadUrl(String url) async {
    List urls;
    String firstMediaTime;

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        print('Document data: $data');
        firstMediaTime = data['FirstMediaTime'];
      } else {
        print('Document does not exist on the database');
      }
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .collection('Posts')
        .doc(firstMediaTime)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        print('Document data: $data');
        urls = data['Media-Urls'];
        urls.add(url);
      } else {
        print('Document does not exist on the database');
      }
    });

    FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .collection('Posts')
        .doc(firstMediaTime)
        .update({'Media-Urls': urls})
        .then((value) => print("Updated Media-Urls"))
        .catchError((error) => print("Failed to update Media-Urls: $error"));
  }

  Future saveUserData(String firstName, String lastName, String fullName,
      String email, String phoneNumber) {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');
    //   FirebaseAuth auth = FirebaseAuth.instance;

    return usersRef
        .doc(auth.currentUser.uid)
        .set({
          'FirstName': firstName,
          'LastName': lastName,
          'FullName': fullName,
          'Email': email,
          'FirstMediaTime': null,
          'PhoneNumber': phoneNumber,
          'CurrentBalance': 0,
        })
        .then((value) => print("User data saved to Firestore"))
        .catchError((error) => print("Failed to add user data: $error"));
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future saveProfilePic(String uid, File file) async {
    String path = 'Users/$uid/profile_pic';

    if (file == null) {
      print("No image");
    } else {
      try {
        await firebase_storage.FirebaseStorage.instance.ref(path).putFile(file);
        print("Successfully added profile pic file");
      } on firebase_core.FirebaseException catch (e) {
        print("Error upload profile pic file: ${e.message}");
      }
    }
  }

  Future<String> getProfilePic(String uid) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('Users/$uid/profile_pic')
        .getDownloadURL();
    return downloadURL;
  }

  Future getNumberPlate(File file, Timestamp time) async {
    String numberPlate;
    String url;
    String path = 'TempNumberPlateFolder/${time.toDate().toString()}/Media';
    try {
      await firebase_storage.FirebaseStorage.instance.ref(path).putFile(file);
      print("Successfully added media files");
      url = await getDownloadUrl(path);
    } on firebase_core.FirebaseException catch (e) {
      print("Error upload files: ${e.message}");
    }

    HttpManager manager = HttpManager();
    if (url != null) {
      numberPlate = await manager.getNumberPlate(url);
      if (numberPlate != null || numberPlate != 'No Number Plate Found.') {
        return numberPlate;
      }
    }
    return 'No Number Plate Found.';
  }

  uploadNumberPlate(String numberPlate) async {
    String firstMediaTime;

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        print('Document data: $data');
        firstMediaTime = data['FirstMediaTime'];
      } else {
        print('Document does not exist on the database');
      }
    });

    FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .collection('Posts')
        .doc(firstMediaTime)
        .update({'NumberPlate': numberPlate})
        .then((value) => print("Updated Number Plate"))
        .catchError((error) => print("Failed to add Number Plate: $error"));
  }

  Future uploadPostToPolice(Post post, Timestamp uploadTime) async {
    CollectionReference policeRef =
        FirebaseFirestore.instance.collection('Police');
    String phoneNumber;
    List urls;
    String firstMediaTime;

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        print('Document data: $data');
        firstMediaTime = data['FirstMediaTime'];
      } else {
        print('Document does not exist on the database');
      }
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        print('Document data: $data');
        phoneNumber = data['PhoneNumber'];
      } else {
        print('Document does not exist on the database');
      }
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .collection('Posts')
        .doc(firstMediaTime)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        print('Document data: $data');
        urls = data['Media-Urls'];
      } else {
        print('Document does not exist on the database');
      }
    });

    policeRef
        .doc(uploadTime.toDate().toString())
        .set({
          'Violation': post.violation,
          'Description': post.description,
          'Media-Urls': urls,
          'Media-Details': post.mediaDetails,
          'PhoneNumber': phoneNumber,
          'NumberPlate': post.numberPlate,
          'Uid': auth.currentUser.uid,
          'Email': auth.currentUser.email,
          'Latitude': post.latitude,
          'Longitude': post.longitude,
          'UploadTime': uploadTime.toDate().toString(),
          'Status': post.status,
        })
        .then((value) => print("Police details saved to Firestore"))
        .catchError((error) => print("Failed to add Police details: $error"));
  }
}
