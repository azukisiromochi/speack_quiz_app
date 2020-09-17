import 'package:quiz_app/app/utils/importer.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:quiz_app/app/utils/settings.dart';

import 'agora_event.dart';
import 'agora_state.dart';

class AgoraBloc extends Bloc<AgoraEvent, AgoraState> {
  final String _channelId;

  AgoraBloc({@required String channelId})
      : assert(channelId != null),
        _channelId = channelId,
        super();

  @override
  AgoraState get initialState => AgoraInitial();

  @override
  Future<void> close() async {
    // TODO テスト用
    // await AgoraRtcEngine.leaveChannel();
    super.close();
  }

  @override
  Stream<AgoraState> mapEventToState(AgoraEvent event) async* {
    debugPrint("ここにそもそも来てない・・・？");
    if (event is AgoraStarted) {
      yield* _mapStartToState(event);
    }
  }

  ///
  /// Event: 起動
  ///
  Stream<AgoraState> _mapStartToState(AgoraStarted event) async* {
    if (AGORA_APP_ID.isEmpty) {
      // TODO: 初期化失敗を返す
    }

    // TODO PSC)竹原: 課金が怖いので、しばらくはコメントアウト
    // await _initAgoraRtcEngine();
    // _addAgoraEventHandlers();
    // await AgoraRtcEngine.enableWebSdkInteroperability(true);
    // await AgoraRtcEngine.joinChannel(null, _channelId, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(AGORA_APP_ID);
    await AgoraRtcEngine.disableVideo();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    // エラー発生時
    AgoraRtcEngine.onError = (dynamic code) {
      // TODO: 後から作る
      debugPrint("onError");
    };

    // チャンネルに自分が入れた時？
    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      // TODO: 後から作る
      debugPrint("onJoinChannelSuccess");
      AgoraRtcEngine.muteLocalAudioStream(true);
    };

    // チャンネルから自分が退室する時
    AgoraRtcEngine.onLeaveChannel = () {
      // TODO: 後から作る
      debugPrint("onLeaveChannel");
    };

    // チャンネルに他のユーザーが参加した時
    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      // TODO: 後から作る
      debugPrint("onUserJoined");
    };

    // チャンネルから他のユーザーが退室したとき？
    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      // TODO: 後から作る
      debugPrint("onUserOffline");
    };
  }
}
