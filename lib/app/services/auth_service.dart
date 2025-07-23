import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import '../models/app_user.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Rxn<AppUser> currentUser = Rxn<AppUser>();

  @override
  void onInit() {
    super.onInit();
    print('AuthService onInit');
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    print('AuthService signInWithGoogle googleUser $googleUser');
    if (googleUser == null) return;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    print('AuthService signInWithGoogle $googleAuth');
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print('AuthService signInWithGoogle credential $credential');
    final userCredential = await _auth.signInWithCredential(credential);
    print('AuthService signInWithGoogle userCredential $userCredential');
    _onAuthStateChanged(userCredential.user);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    currentUser.value = null;
  }

  void _onAuthStateChanged(User? user) {
    print('AuthService _onAuthStateChanged $user');
    if (user == null) {
      currentUser.value = null;
    } else {
      currentUser.value = AppUser(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL ?? '',
      );
    }
  }
}
