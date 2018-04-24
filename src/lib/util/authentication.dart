part of mobile_hotkey;


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _signIn = new GoogleSignIn();

Future<FirebaseUser> signInWithGoogle() async {
  GoogleSignInAccount currentUser = _signIn.currentUser;
  if (currentUser == null) {
    currentUser = await _signIn.signInSilently();
  }
  if (currentUser == null) {
    currentUser = await _signIn.signIn();
  }

  final GoogleSignInAuthentication auth = await currentUser.authentication;

  final FirebaseUser user = await _auth.signInWithGoogle(
    idToken: auth.idToken,
    accessToken: auth.accessToken
  );

  assert(user != null);
  assert(!user.isAnonymous);

  return user;
}

Future<Null> signOutWithGoogle() async {
  await _auth.signOut();
  await _signIn.signOut();
}