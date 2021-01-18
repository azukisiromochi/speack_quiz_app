import 'package:quiz_app/app/utils/importer.dart';

abstract class UploadImageRepository {
  Future<String> upload(File file);
}
