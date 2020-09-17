import 'package:quiz_app/app/utils/importer.dart';

class User {
  String id; // ID
  final String name; // 名前
  final String imageUrl; // 画像URL

  User({this.id, this.name, this.imageUrl}); // 画像URL

  ///
  /// Method: FireStoreのDocumentからインスタンスを生成する.
  ///
  static User ofDocument(DocumentSnapshot doc) {
    if (doc == null) {
      return null;
    }

    Map<String, dynamic> json = doc.data;
    return User(
      id: doc.documentID,
      name: json["name"] ?? "",
      imageUrl: json["image_url"] ?? "",
    );
  }

  Map<String, dynamic> toJsonMap() {
    return {
      "id": id,
      "name": name,
      "image_url": imageUrl,
    };
  }
}
