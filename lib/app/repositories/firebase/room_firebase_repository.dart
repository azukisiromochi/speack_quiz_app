import 'package:quiz_app/app/models/room.dart';
import 'package:quiz_app/app/models/room_user.dart';
import 'package:quiz_app/app/repositories/room_repository.dart';
import 'package:quiz_app/app/utils/importer.dart';

class RoomFirebaseRepository extends RoomRepository {
  final Firestore _firestore;

  RoomFirebaseRepository({Firestore fireStore})
      : this._firestore = fireStore ?? Firestore.instance;

  ///
  /// Method: 部屋を作成する.
  ///
  @override
  Future<bool> createRoom(Room room) async {
    // 存在チェック
    DocumentSnapshot doc =
        await _firestore.collection("rooms").document(room.id).get();
    if (doc == null) {
      return false;
    }

    // TODO 空部屋もRoomオブジェクトを使うようにしておく
    // 空部屋を作成する
    await _firestore
        .collection("rooms")
        .document(room.id)
        .setData(room.toJsonMap());
    return true;
  }

  ///
  /// Method: 部屋を取得する.
  ///
  @override
  Future<Room> select(String roomId) async {
    DocumentReference docRef = _firestore.collection("rooms").document(roomId);
    DocumentSnapshot doc = await docRef.get();
    return Room.ofDocument(doc);
  }

  ///
  /// Method: 部屋に参加する.
  ///
  @override
  Future<bool> joinRoom(String roomId, RoomUser user) async {
    // 存在チェック
    DocumentReference docRef = _firestore.collection("rooms").document(roomId);
    DocumentSnapshot doc = await docRef.get();
    if (doc == null) {
      return false;
    }

    // 部屋に参加する
    Map<String, dynamic> param = Map.from(doc.data);
    Map<String, dynamic> users = Map.from(param["users"] ?? {});
    users[user.id] = user.toJsonMap();
    param["users"] = users;
    await docRef.updateData(param);

    return true;
  }

  ///
  /// Method: 部屋を退出する.
  ///
  @override
  Future<bool> exitRoom(String roomId, String userId) async {
    // 存在チェック
    DocumentReference docRef = _firestore.collection("rooms").document(roomId);
    DocumentSnapshot doc = await docRef.get();
    if (doc == null) {
      return false;
    }

    // 退出する
    Map<String, dynamic> param = Map.from(doc.data);
    Map<String, dynamic> users = Map.from(param["users"] ?? {});

    // 最後の1名の場合は部屋ごと削除する
    if (users.length <= 1) {
      await docRef.delete();
    } else {
      param["users"] = users..remove(userId);
      await docRef.updateData(param);
    }
    return true;
  }

  ///
  /// Method: フェッチ
  ///
  @override
  Stream<Room> fetch(String roomId) {
    // 指定されたIDのルームを取得する
    return _firestore
        .collection("rooms")
        .document(roomId)
        .snapshots()
        .map((doc) => Room.ofDocument(doc));
  }

  @override
  Future<bool> updateRoomState(String roomId, String state) async {
    // 存在チェック
    DocumentReference docRef = _firestore.collection("rooms").document(roomId);
    DocumentSnapshot doc = await docRef.get();
    if (doc == null) {
      return false;
    }

    // ユーザー情報を更新
    Map<String, dynamic> room = Map.from(doc.data);
    room["state"] = state;
    await docRef.updateData(room);
    return true;
  }

  @override
  Future<bool> updateUserState(
      String roomId, String userId, String state) async {
    // 存在チェック
    DocumentReference docRef = _firestore.collection("rooms").document(roomId);
    DocumentSnapshot doc = await docRef.get();
    if (doc == null) {
      return false;
    }

    // ユーザー情報を更新
    Map<String, dynamic> room = Map.from(doc.data);
    Map<String, dynamic> users = Map.from(room["users"]);
    Map<String, dynamic> user = Map.from(users[userId]);

    user["state"] = state;
    users[userId] = user;
    room["users"] = users;
    await docRef.updateData(room);
    return true;
  }
}
