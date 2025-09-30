import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static User? get currentUser => _auth.currentUser;

  Future<User?> getUser() async {
    return currentUser;
  }

  Future<void> addBike(Map<String, dynamic> bikeData) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('bikes')
        .add({
      ...bikeData,
      'isPrimary': false,
      'createdAt': now,
      'updatedAt': now,
    });
  }

  Future<List<Map<String, dynamic>>> getBikes() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('bikes')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> updateUsername(String username) async {
    final user = _auth.currentUser;
    final uid = user?.uid;
    if (user == null) return;
    if (uid == null) throw Exception("User not logged in");

    final userRef = _firestore.collection("users").doc(uid);

    await userRef.set(
      {
        "username": username,
        "updatedAt": FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<Map<String, dynamic>?> getUserFirestore() async {
    final doc = await _firestore.collection('users').doc(currentUser?.uid).get();
    if (doc.exists) {
    final data = doc.data()!;
      return {
        'uid': doc.id,
        ...data,
      };
    }
    return null;
  }
}
