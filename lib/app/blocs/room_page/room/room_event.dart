import 'package:quiz_app/app/models/room.dart';
import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class RoomEvent extends Equatable {
  @override
  List<Object> get props => [];
}

///
/// Event: 部屋状態の変更
///
class RoomEventChangeEntity extends RoomEvent {
  final Room room;

  RoomEventChangeEntity({this.room});
  @override
  List<Object> get props => [room];
}
