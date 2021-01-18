import 'package:quiz_app/app/utils/importer.dart';

import '../upload_image_repository.dart';

class UploadImageFirebaseRepository extends UploadImageRepository {
  @override
  Future<String> upload(File file) async {
    // TODO 後からファイル名とかを見直す

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String subDirectoryName = "users";
    final StorageReference ref =
        FirebaseStorage().ref().child(subDirectoryName).child('${timestamp}');
    final StorageUploadTask uploadTask = ref.putFile(
        file,
        StorageMetadata(
          contentType: "image/jpeg",
        ));
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    if (snapshot.error == null) {
      return await snapshot.ref.getDownloadURL();
    } else {
      return 'Something goes wrong';
    }
  }
}
