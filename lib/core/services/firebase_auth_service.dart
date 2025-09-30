import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static User? get currentUser => _auth.currentUser;

  Future<Map<String, dynamic>?> _saveUserToFirestore({
    required String uid,
    required String username,
    required String email,
  }) async {
    final docRef = _firestore.collection('users').doc(uid);

    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return null;
  }
  // Registro con email y password
  Future<User?> registerWithEmail(String username,String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _saveUserToFirestore(
        uid: userCredential.user!.uid,
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
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null && !result.user!.emailVerified) {
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
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw ("cancelled_by_user");

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final result = await _auth.signInWithCredential(credential);
      await _saveUserToFirestore(
        uid: result.user?.uid ?? "",
        username: googleUser.displayName ?? "",
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
      await _saveUserToFirestore(
        uid: result.user?.uid ?? "",
        username: credential.givenName ?? "",
        email: result.user?.email ?? "",
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign-Out
  Future<void> signOut() async {
    try {
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
