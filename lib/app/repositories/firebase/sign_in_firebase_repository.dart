import 'package:quiz_app/app/utils/importer.dart';
import '../sign_in_repository.dart';

class SignInFireauthRepository extends SignInRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final TwitterLogin _twitterLogin;

  SignInFireauthRepository(
      {FirebaseAuth firebaseAuth,
      GoogleSignIn googleSignIn,
      TwitterLogin twitterLogin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _twitterLogin = twitterLogin ??
            TwitterLogin(
              consumerKey: "kkOvaF1Mowy4JTvCxKTV5O1WF",
              consumerSecret:
                  "ZECGsI6UUDBEUVGkJe4S5vd0FGqGxC3wMJCgsXgPRfjSwRFnyH",
            );

  ///
  /// Method: 匿名ログイン
  ///
  @override
  Future<void> signInAnonymously() async {
    return Future.wait([_firebaseAuth.signInAnonymously()]);
  }

  ///
  /// Method: Googleログイン
  ///
  @override
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return Future.wait([_firebaseAuth.signInWithCredential(credential)]);
  }

  ///
  /// Method: Twitterログイン
  ///
  @override
  Future<void> signInWithTwitter() async {
    final TwitterLoginResult result = await _twitterLogin.authorize();
    final AuthCredential credential = TwitterAuthProvider.getCredential(
      authToken: result.session.token,
      authTokenSecret: result.session.secret,
    );

    return Future.wait([_firebaseAuth.signInWithCredential(credential)]);
  }
}
