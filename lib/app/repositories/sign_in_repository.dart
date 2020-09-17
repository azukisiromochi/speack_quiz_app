abstract class SignInRepository {
  Future<void> signInAnonymously();

  Future<void> signInWithGoogle();

  Future<void> signInWithTwitter();
}
