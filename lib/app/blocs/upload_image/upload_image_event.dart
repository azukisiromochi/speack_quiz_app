import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class UploadImageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UploadImageIndicate extends UploadImageEvent {
  final String imageUrl;

  UploadImageIndicate({this.imageUrl});
}

class UploadImageUpload extends UploadImageEvent {
  final File file;

  UploadImageUpload({this.file}) : assert(file != null);
}
