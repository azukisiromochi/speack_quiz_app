import 'package:quiz_app/app/blocs/room_page/room/room_bloc.dart';
import 'package:quiz_app/app/blocs/room_page/room/room_importer.dart';
import 'package:quiz_app/app/blocs/room_page/room_page_event.dart';
import 'package:quiz_app/app/blocs/room_page/room_page_state.dart';
import 'package:quiz_app/app/blocs/room_page/users/users_importer.dart';
import 'package:quiz_app/app/blocs/speech_to_text/speech_to_text_importer.dart';
import 'package:quiz_app/app/models/room.dart';
import 'package:quiz_app/app/repositories/room_repository.dart';
import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/utils/room_playing_state.dart';
import 'package:quiz_app/app/utils/user_playing_state.dart';

class RoomPageBloc extends Bloc<RoomPageEvent, RoomPageState> {
  /// 画面内の状態管理==========
  final RoomBloc _roomBloc;
  final UsersBloc _usersBloc;
  // 音声 → 文字への変換に関する状態管理
  final SpeechToTextBloc _speechToTextBloc;

  /// ===================

  final RoomRepository _repository;
  final String roomId;
  final String userId;

  RoomBloc get roomBloc => _roomBloc;
  UsersBloc get usersBloc => _usersBloc;
  SpeechToTextBloc get speechToTextBloc => _speechToTextBloc;

  RoomPageBloc({RoomRepository repository, this.roomId, this.userId})
      : assert(repository != null),
        assert(roomId != null),
        assert(userId != null),
        _repository = repository,
        _roomBloc = RoomBloc(),
        _usersBloc = UsersBloc(),
        _speechToTextBloc = SpeechToTextBloc(),
        super();

  @override
  Future<void> close() {
    // Bloc内で管理しているローカルBlocを閉じる
    _roomBloc?.close();
    _usersBloc?.close();
    _speechToTextBloc?.close();

    // 親の呼び出し
    return super.close();
  }

  @override
  RoomPageState get initialState => RoomPageInitial();

  @override
  Stream<RoomPageState> mapEventToState(RoomPageEvent event) async* {
    if (event is RoomPageShow) {
      yield* _show(event);
    } else if (event is RoomPageExit) {
      yield* _exit(event);
    } else if (event is RoomPageEventGameStarted) {
      yield* _gameStarted(event);
    } else if (event is RoomPageEventGameFinished) {
      yield* _gameFinished(event);
    } else if (event is RoomPageEventUserReady) {
      yield* _ready(event);
    } else if (event is RoomPageEventUserReadyCancel) {
      yield* _readyCancel(event);
    }
  }

  ///
  /// Event: 初期表示
  ///
  Stream<RoomPageState> _show(RoomPageShow event) async* {
    yield RoomPageProgress();

    try {
      // ルーム情報を取得
      Stream<Room> room = _repository.fetch(roomId);
      yield RoomPageSuccess();

      // 各種Blocの情報を初期化する
      // TODO Agoraを入れる

      // データの状態を監視
      _roomStateHandler(room);
    } catch (e) {
      yield RoomPageFailure();
    }
  }

  ///
  /// Event: 退室
  ///
  Stream<RoomPageState> _exit(RoomPageExit event) async* {
    yield RoomPageProgress();

    await _repository.exitRoom(roomId, userId);
    yield RoomPageClose();
  }

  ///
  /// Event: ゲーム開始
  ///
  Stream<RoomPageState> _gameStarted(RoomPageEventGameStarted event) async* {
    // 部屋の状態を確認する
    // TODO PSC)竹原: 全員が準備完了状態 かつ 参加者が2名以上の場合のみ開始可能
    if (false) {
      return;
    }

    // TODO PSC)竹原: ここでゲームを開始状態に切り替えて、初期データを登録する(得点などを0にする)
    await _repository.updateRoomState(roomId, RoomPlayingState.PLAYING.value);

    // 各Blocの初期化
    _speechToTextBloc.add(SpeechToTextStarted());
  }

  ///
  /// Event: ゲーム終了
  ///
  Stream<RoomPageState> _gameFinished(RoomPageEventGameFinished event) async* {
    // TODO PSC)竹原: 結果を確定させる？
    await _repository.updateRoomState(roomId, RoomPlayingState.FINISSHED.value);
  }

  ///
  /// Event: 準備完了
  ///
  Stream<RoomPageState> _ready(RoomPageEventUserReady event) async* {
    await _repository.updateUserState(
        roomId, userId, UserPlayingState.READY.value);
  }

  ///
  /// Event: 準備完了取り消し
  ///
  Stream<RoomPageState> _readyCancel(
      RoomPageEventUserReadyCancel event) async* {
    await _repository.updateUserState(
        roomId, userId, UserPlayingState.IN_PREPARATION.value);
  }

  ///
  /// Handler: ルーム状態、ユーザー状態の変更を検知し状態変更を通知する.
  ///
  void _roomStateHandler(Stream<Room> room) async {
    room.listen((room) async {
      // 変更を通知
      if (room != null) {
        _roomBloc.add(RoomEventChangeEntity(room: room));
      }
      if (room?.users != null) {
        _usersBloc.add(UsersEventChangeEntity(users: room.users));
      }
    });
  }
}
