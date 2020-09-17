import 'package:quiz_app/app/models/user.dart';

///
/// Class: 認証用の通信を行うリポジトリ
///
abstract class AuthRepository {
  Future<void> signOut();

  Future<bool> isSignIn();

  Future<User> signIn();

  Future<User> getCurrentUser();
}
