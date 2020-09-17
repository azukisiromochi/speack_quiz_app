import 'package:quiz_app/app/models/room.dart';
import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class RoomPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class RoomPageInitial extends RoomPageState {}

class RoomPageClose extends RoomPageState {}

class RoomPageProgress extends RoomPageState {}

class RoomPageSuccess extends RoomPageState {
  // final Stream<Room> room;

  // RoomPageSuccess({this.room}) : assert(room != null);
}

class RoomPageFailure extends RoomPageState {}
