import 'package:quiz_app/app/blocs/upload_image/upload_image_event.dart';
import 'package:quiz_app/app/blocs/upload_image/upload_image_state.dart';
import 'package:quiz_app/app/repositories/upload_image_repository.dart';
import 'package:quiz_app/app/utils/importer.dart';

class UploadImageBloc extends Bloc<UploadImageEvent, UploadImageState> {
  final UploadImageRepository _repository;

  UploadImageBloc({UploadImageRepository repository})
      : assert(repository != null),
        _repository = repository;

  @override
  get initialState => UploadImageInit();

  @override
  Stream<UploadImageState> mapEventToState(event) async* {
    if (event is UploadImageIndicate) {
      // 初期表示
      yield* _indicate(event.imageUrl);
    } else if (event is UploadImageUpload) {
      // アップロード
      yield* _upload(event.file);
    }
  }

  /// 初期表示
  Stream<UploadImageState> _indicate(String imageUrl) async* {
    yield UploadImageProgress();

    // 空判定
    if (imageUrl == null) {
      yield UploadImageEmpty();
    } else {
      yield UploadImageDisp(imageUrl: imageUrl);
    }
  }

  /// アップロード
  Stream<UploadImageState> _upload(File file) async* {
    yield UploadImageProgress();

    // 空判定
    try {
      // 画像のアップロード処理
      String imageUrl = await _repository.upload(file);

      // アップロードした画像のURLを返却する
      yield UploadImageDisp(imageUrl: imageUrl);
    } catch (error) {
      // TODO 後から作る
      yield UploadImageEmpty();
    }
  }
}
