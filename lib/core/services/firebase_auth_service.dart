import 'dart:io';
import 'package:bikers_app/core/i18n/strings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static User? get currentUser => _auth.currentUser;


  Future<String> _getDevideId()  async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceId = '';
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      deviceId = info.id;
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      deviceId = info.identifierForVendor ?? '';
    }
    return deviceId;
  }

  Future<bool?> _isValidUserRegistered(String deviceId, String email) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('deviceId', isEqualTo: deviceId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return false;
      final existingUserDoc = query.docs.first;
      final existingEmail = existingUserDoc.data()['email'];
      if (existingEmail != email) {
        return false;
      }
    } catch (e) {
      return true;
    }
    return null;
  }
  
  Future<Map<String, dynamic>?> _saveUserToFirestore({
    required String uid,
    required String deviceId,
    required String username,
    required String email,
  }) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final docRef = _firestore.collection('users').doc(uid);

    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'username': username,
        'deviceId': deviceId,
        'fcmToken': fcmToken,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return null;
  }
  
  Future<bool> validateUserSession(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!userDoc.exists) return false;
      return true;
    } catch (e) {
      return false;
    }
}

  // Registro con email y password
  Future<User?> registerWithEmail(String username,String email, String password) async {
    try {
      var deviceId = await _getDevideId();
      final query = await _firestore
          .collection('users')
          .where('deviceId', isEqualTo: deviceId)
          .get();

      if (query.docs.isNotEmpty) {
        throw Exception('Este dispositivo ya está registrado con otra cuenta.');
      }
      
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _saveUserToFirestore(
        uid: userCredential.user!.uid,
        deviceId: deviceId,
        username: username,
        email: email,
      );
      await userCredential.user!.sendEmailVerification();
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Login con email y password
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final deviceId = await _getDevideId();
      final isValidUser = await _isValidUserRegistered(deviceId, email);
      if (isValidUser == false) {
        throw Exception('User exist');
      }
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (!result.user!.emailVerified) {
        await _auth.signOut(); 
        throw Exception('email-not-verified');
      }

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final deviceId = await _getDevideId();
      final googleUser = await _googleSignIn.signIn();
      final isValidUser = await _isValidUserRegistered(deviceId, googleUser?.email ?? '');
      if (isValidUser == false) {
        throw (LoginStrings.errorAlreadyEmail);
      }
      
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final uid = result.user?.uid;
      if (uid == null) throw Exception('No UID obtenido de Firebase');

      await _saveUserToFirestore(
        uid: uid,
        deviceId: deviceId,
        username: googleUser?.displayName ?? "",
        email: result.user?.email ?? "",
      );

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Apple Sign-In
  Future<User?> signInWithApple() async {
    try {
      final deviceId = await _getDevideId();
      final isValidUser = await _isValidUserRegistered(deviceId, AppleIDAuthorizationScopes.email.name);
      if (isValidUser == false) {
        throw Exception('User exist');
      }
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final result = await _auth.signInWithCredential(oauthCredential);
      final user = result.user;
      if (user == null) throw Exception('apple-signin-failed');

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists && doc.data()?['deviceId'] != deviceId) {
        await _auth.signOut();
        throw Exception('Este usuario ya está registrado en otro dispositivo.');
      }

      await _saveUserToFirestore(
        uid: user.uid,
        deviceId: deviceId,
        username: credential.givenName ?? "",
        email: user.email ?? "",
      );

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign-Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();

      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  
  // Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
