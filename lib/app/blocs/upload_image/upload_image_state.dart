import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class UploadImageState extends Equatable {
  @override
  List<Object> get props => [];
}

/// 初期状態
class UploadImageInit extends UploadImageState {}

/// 画像を表示させていない状態
class UploadImageEmpty extends UploadImageState {}

/// 画像を読み込み中の状態(アップロード中も含む)
class UploadImageProgress extends UploadImageState {}

/// 画像を表示させている状態
class UploadImageDisp extends UploadImageState {
  final String imageUrl;

  UploadImageDisp({this.imageUrl}) : assert(imageUrl != null);
}
