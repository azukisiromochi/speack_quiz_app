import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class RoomManagementState extends Equatable {
  @override
  List<Object> get props => [];
}

class RoomManagementInitial extends RoomManagementState {}

class RoomManagementProgress extends RoomManagementState {}

class RoomManagementSuccess extends RoomManagementState {
  final roomId;

  RoomManagementSuccess({this.roomId}) : assert(roomId != null);
}

class RoomManagementFailure extends RoomManagementState {
  final String message;

  RoomManagementFailure({this.message});

  @override
  List<Object> get props => [message];
}
