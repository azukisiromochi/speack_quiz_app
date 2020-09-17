import 'package:quiz_app/app/utils/importer.dart';

import 'speech_to_text_event.dart';
import 'speech_to_text_state.dart';

class SpeechToTextBloc extends Bloc<SpeechToTextEvent, SpeechToTextState> {
  final SpeechRecognition _speech;
  final StreamController<String> _speechTextStream = StreamController<String>();
  bool _isListening = false;
  bool _speechRecognitionAvailable = false;

  Stream<String> get readText => _speechTextStream.stream;

  SpeechToTextBloc()
      : _speech = new SpeechRecognition(),
        super();

  @override
  Future<void> close() async {
    _speechTextStream.close();
    super.close();
  }

  @override
  SpeechToTextState get initialState => SpeechToTextInitial();

  @override
  Stream<SpeechToTextState> mapEventToState(SpeechToTextEvent event) async* {
    if (event is SpeechToTextStarted) {
      yield* _started(event);
    } else if (event is SpeechToTextRecord) {
      yield* _record(event);
    } else if (event is SpeechToTextStop) {
      yield* _stop(event);
    } else if (event is SpeechToTextThrow) {
      yield SpeechToTextFailure();
    }
  }

  ///
  /// Event: Blocの開始(初期化)
  ///
  Stream<SpeechToTextState> _started(SpeechToTextStarted event) async* {
    debugPrint("SpeechToTextBloc: event is SpeechToTextStarted");

    // ハンドラ定義
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    // 初期化
    _speechRecognitionAvailable = await _speech.activate('ja-JA');
    if (!!_speechRecognitionAvailable) {
      yield SpeechToTextReady();
    } else {
      yield SpeechToTextFailure();
    }
  }

  ///
  /// Event: 開始
  ///
  Stream<SpeechToTextState> _record(SpeechToTextRecord event) async* {
    debugPrint("SpeechToTextBloc: event is SpeechToTextRecord");

    // 録音の準備が完了している場合のみ開始する
    if (!!_speechRecognitionAvailable) {
      bool _result = await _speech.listen();

      // 失敗してたらステータスを変更
      if (!_result) {
        yield SpeechToTextFailure();
      }
    }
  }

  ///
  /// Event: 録音停止
  ///
  Stream<SpeechToTextState> _stop(SpeechToTextStop event) async* {
    debugPrint("SpeechToTextBloc: event is SpeechToTextStop");

    // 録音の準備が完了している場合のみ開始する
    if (!!_isListening) {
      await _speech.stop();
    }
  }

  ///
  /// Handle: 録音したテキストの結果通知ハンドラ
  ///
  void onRecognitionResult(String text) {
    // 空文字連携がされた場合は更新しない
    if (text.isNotEmpty) {
      _speechTextStream.add(text);
    }
  }

  ///
  /// Handle: 使用可能判定通知ハンドラ
  ///
  void onSpeechAvailability(bool result) =>
      _speechRecognitionAvailable = result;

  ///
  /// Handle: 録音開始通知ハンドラ
  ///
  void onRecognitionStarted() => _isListening = true;

  ///
  /// Handle: 録音完了通知ハンドラ
  /// ※ テキストは逐次連携を行っているため、連携しない
  ///
  void onRecognitionComplete(String text) => _isListening = false;

  ///
  /// Handle: エラーハンドラ
  ///
  void errorHandler() => this.add(SpeechToTextThrow());
}
