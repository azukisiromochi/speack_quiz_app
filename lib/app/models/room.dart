import 'package:quiz_app/app/models/room_user.dart';
import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/utils/room_playing_state.dart';

class Room {
  String id; // ID
  List<RoomUser> users; // 参加者
  RoomPlayingState state; // 状態

  Room({this.id, this.users, this.state});

  ///
  /// Method: FireStoreのDocumentからインスタンスを生成する.
  ///
  static Room ofDocument(DocumentSnapshot doc) {
    if (doc?.data == null) {
      return null;
    }

    // TODO 後から
    Map<String, dynamic> json = Map.from(doc.data);
    Map<String, dynamic> users = Map.from(json["users"]);
    List<RoomUser> roomUsers = users.values
        .map((userJson) => RoomUser.ofJson(Map.from(userJson)))
        .toList();

    return Room(
      id: doc.documentID,
      users: roomUsers ?? [],
      state: RoomStateExtension.of(json["state"]) ?? null,
    );
  }

  Map<String, dynamic> toJsonMap() {
    return {
      "id": id,
      "users": users?.map((e) => e.toJsonMap())?.join(","),
      "state": state.value,
    };
  }
}
