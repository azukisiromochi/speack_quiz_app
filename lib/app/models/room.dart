import 'package:quiz_app/app/models/room_user.dart';
import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/utils/room_playing_state.dart';

class Room {
  String id; // ID
  List<RoomUser> users; // 参加者
  RoomPlayingState state; // 状態
  String quizText; // 問題文

  Room({this.id, this.users, this.state, this.quizText});

  ///
  /// Method: FireStoreのDocumentからインスタンスを生成する.
  ///
  static Room ofDocument(DocumentSnapshot doc) {
    if (doc?.data == null) {
      return null;
    }

    // TODO 要リファクタリング
    Map<String, dynamic> json = Map.from(doc.data);
    Map<String, dynamic> users = Map.from(json["users"]);
    List<RoomUser> roomUsers = users.values
        .map((userJson) => RoomUser.ofJson(Map.from(userJson)))
        .toList();

    return Room(
      id: doc.documentID,
      users: roomUsers ?? [],
      state: RoomStateExtension.of(json["state"]) ?? null,
      quizText: json["quiz_text"],
    );
  }

  Map<String, dynamic> toJsonMap() {
    return {
      "id": id,
      "users": users?.map((e) => e.toJsonMap())?.join(","),
      "state": state.value,
      "quiz_text": quizText,
    };
  }
}
