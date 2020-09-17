import 'package:quiz_app/app/models/room.dart';
import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/utils/room_playing_state.dart';

///
/// 部屋全体の状態
///
@immutable
abstract class RoomState extends Equatable {
  @override
  List<Object> get props => [];
}

class RoomStateLobby extends RoomState {}

class RoomStatePlaying extends RoomState {}

class RoomStateFinished extends RoomState {}
