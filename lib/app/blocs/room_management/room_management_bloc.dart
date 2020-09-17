import 'dart:math';

import 'package:quiz_app/app/models/room.dart';
import 'package:quiz_app/app/models/room_user.dart';
import 'package:quiz_app/app/repositories/room_repository.dart';
import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/utils/room_playing_state.dart';
import 'package:quiz_app/app/utils/room_user_role.dart';
import 'package:quiz_app/app/utils/user_playing_state.dart';
import 'room_management_event.dart';
import 'room_management_state.dart';

class RoomManagementBloc
    extends Bloc<RoomManagementEvent, RoomManagementState> {
  RoomRepository _repository;

  RoomManagementBloc({RoomRepository repository})
      : assert(repository != null),
        _repository = repository,
        super();

  @override
  RoomManagementState get initialState => RoomManagementInitial();

  @override
  Stream<RoomManagementState> mapEventToState(
      RoomManagementEvent event) async* {
    if (event is RoomManagementCreated) {
      yield* _roomCreate(event);
    } else if (event is RoomManagementJoined) {
      yield* _roomJoined(event);
    }
  }

  ///
  /// Event: ルーム作成
  ///
  Stream<RoomManagementState> _roomCreate(RoomManagementCreated event) async* {
    yield RoomManagementProgress();

    try {
      // ルームID(6桁の乱数)を生成
      String roomId = createRoomId();

      // ユーザー情報を管理者用に変換する
      RoomUser user = RoomUser.ofUser(event.user,
          state: UserPlayingState.READY, role: RoomUserRole.MASTER);

      // 部屋の作成
      Room room = Room(id: roomId, state: RoomPlayingState.LOBBY);
      await _repository.createRoom(room);

      // 部屋への参加
      await _repository.joinRoom(roomId, user);

      yield RoomManagementSuccess(roomId: roomId);

      // bool isCreateSuccess = await _repository.createRoom(room);

      // if (isCreateSuccess) {
      //   // 部屋への参加
      //   bool isJoinSuccess = await _repository.joinRoom(roomId, user);
      //   if (isJoinSuccess) {
      //     yield RoomManagementSuccess(roomId: roomId);
      //   }
      // }

    } catch (e) {
      // TODO: リポジトリからエラーを取得出来るようにしたい
      yield RoomManagementFailure(message: "ルーム作成に失敗しました。");
    }
  }

  ///
  /// Event: ルームに参加する.
  ///
  Stream<RoomManagementState> _roomJoined(RoomManagementJoined event) async* {
    yield RoomManagementProgress();

    try {
      // イベント情報を取得
      String roomId = event.roomId;
      RoomUser user = RoomUser.ofUser(event.user,
          state: UserPlayingState.IN_PREPARATION, role: RoomUserRole.GUEST);

      // 部屋情報を取得する
      Room room = await _repository.select(roomId);

      // 参加可能か否かを判定
      if (canJoinedRoom(room)) {
        // 参加する
        await _repository.joinRoom(roomId, user);
        yield RoomManagementSuccess(roomId: roomId);
      } else {
        yield RoomManagementFailure(message: "このルームには参加不可能です。");
      }
    } catch (e) {
      yield RoomManagementFailure(message: "ルームに参加出来ませんでした。");
    }
  }

  ///
  /// Method: ルームに参加可能か否か.
  ///
  bool canJoinedRoom(Room room) {
    // TODO 各種バリデーションチェック (参加人数やゲームの状態)
    return true;
  }

  ///
  /// Method: ルームIDを生成する.
  ///
  String createRoomId() {
    final rand = Random();
    return rand.nextInt(1000000).toString().padLeft(6, "0");
  }
}
