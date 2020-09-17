import 'package:quiz_app/app/blocs/room_page/room/room_event.dart';
import 'package:quiz_app/app/blocs/room_page/room/room_state.dart';
import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/utils/room_playing_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  @override
  RoomState get initialState => RoomStateLobby();

  @override
  Stream<RoomState> mapEventToState(RoomEvent event) async* {
    if (event is RoomEventChangeEntity) {
      yield* _changeEntity(event);
    }
  }

  ///
  /// Event: ゲーム開始
  ///
  Stream<RoomState> _changeEntity(RoomEventChangeEntity event) async* {
    // 取得した区分にしたがってBlocの状態を返却する
    switch (event.room.state) {
      case RoomPlayingState.PLAYING:
        yield RoomStatePlaying();
        break;
      case RoomPlayingState.FINISSHED:
        yield RoomStateFinished();
        break;
      case RoomPlayingState.LOBBY:
      default:
        yield RoomStateLobby();
        break;
    }
  }
}
