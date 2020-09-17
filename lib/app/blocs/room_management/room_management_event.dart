import 'package:quiz_app/app/models/user.dart';
import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class RoomManagementEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RoomManagementCreated extends RoomManagementEvent {
  final User user;

  RoomManagementCreated({this.user}) : assert(user != null);
}

class RoomManagementJoined extends RoomManagementEvent {
  final User user;
  final String roomId;

  RoomManagementJoined({this.user, this.roomId})
      : assert(user != null),
        assert(roomId != null);
}
