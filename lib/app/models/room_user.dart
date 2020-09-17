import 'package:quiz_app/app/models/user.dart';
import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/utils/room_user_role.dart';
import 'package:quiz_app/app/utils/user_playing_state.dart';

class RoomUser extends User {
  int score; // 得点
  int penalty; // 失点
  UserPlayingState state; // 状態
  RoomUserRole role; // 権限
  RoomUser({
    this.score,
    this.penalty,
    this.state,
    this.role,
    String id,
    String name,
    String imageUrl,
  }) : super(id: id, name: name, imageUrl: imageUrl);

  ///
  /// Method: FireStoreのDocumentからインスタンスを生成する.
  ///
  static RoomUser ofDocument(DocumentSnapshot doc) {
    if (doc == null) {
      return null;
    }

    Map<String, dynamic> json = doc.data;
    return RoomUser.ofJson(json, id: doc.documentID);
  }

  ///
  /// Method: FireStoreのJsonからインスタンスを生成する.
  ///
  static RoomUser ofJson(Map<String, dynamic> json, {String id}) {
    return RoomUser(
      id: json["id"] ?? id,
      name: json["name"] ?? "",
      imageUrl: json["image_url"] ?? "",
      score: json["score"] ?? 0,
      penalty: json["penalty"] ?? 0,
      state: UserPlayingStateExtension.of(json["state"]) ?? null,
      role: RoomUserRoleExtension.of(json["role"]) ?? null,
    );
  }

  ///
  /// Method: Userオブジェクトからインスタンスを生成する.
  ///
  static RoomUser ofUser(User user,
      {int score, int penalty, UserPlayingState state, RoomUserRole role}) {
    return RoomUser(
      id: user.id ?? '',
      name: user.name ?? '',
      imageUrl: user.imageUrl ?? '',
      score: score ?? 0,
      penalty: penalty ?? 0,
      state: state ?? null,
      role: role ?? null,
    );
  }

  Map<String, dynamic> toJsonMap() {
    Map<String, dynamic> json = super.toJsonMap();
    return json
      ..addAll({
        "score": score,
        "penalty": penalty,
        "state": state.value,
        "role": role.value,
      });
  }

  String toString() {
    Map<String, dynamic> json = this.toJsonMap();
    return json.toString();
  }
}
