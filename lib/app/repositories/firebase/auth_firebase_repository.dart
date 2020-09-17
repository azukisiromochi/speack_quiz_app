import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/models/user.dart';

import '../auth_repository.dart';

class AuthFirestoreRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final Firestore _firestore;

  AuthFirestoreRepository({FirebaseAuth firebaseAuth, Firestore fireStore})
      : this._firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        this._firestore = fireStore ?? Firestore.instance;

  ///
  /// Method: 認証済か否かを判定する.
  ///
  @override
  Future<bool> isSignIn() async {
    final user = await _firebaseAuth.currentUser();
    return user != null;
  }

  ///
  /// Method: 認証済のユーザー情報を取得する.
  ///
  @override
  Future<User> getCurrentUser() async {
    // 認証情報を取得
    final authUser = await _firebaseAuth.currentUser();

    // システムで保持するユーザー情報を取得する
    return _getUser(authUser.uid);
  }

  ///
  /// Method: 認証状態をクリアする.
  ///
  @override
  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  ///
  /// Method: 認証する.
  ///
  @override
  Future<User> signIn() async {
    // 認証
    final authUser = await _firebaseAuth.currentUser();

    // ユーザーを取得する
    User user =
        await _firestore.collection("users").getDocuments().then((snapshot) {
      List<DocumentSnapshot> docs = snapshot.documents.where((doc) {
        return doc.documentID == authUser.uid;
      })?.toList();

      if (docs.isEmpty) {
        return null;
      }

      return User.ofDocument(docs.first);
    });

    // 取得できない(新規ユーザー)の場合は空のユーザー情報を登録する
    if (user == null) {
      user = User(
        id: authUser.uid,
        name: authUser.displayName ?? "名無し",
        imageUrl: authUser.photoUrl,
      );

      await _firestore
          .collection("users")
          .document(authUser.uid)
          .setData(user.toJsonMap());
    }

    return user;
  }

  ///
  /// Method: ユーザー情報を取得する.
  ///
  Future<User> _getUser(String authUserId) {
    return _firestore.collection("users").getDocuments().then((snapshot) {
      DocumentSnapshot doc = snapshot.documents
          .where((doc) => doc.documentID == authUserId)
          ?.toList()
          ?.first;

      return User.ofDocument(doc);
    });
  }
}
