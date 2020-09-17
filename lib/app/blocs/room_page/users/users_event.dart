import 'package:quiz_app/app/models/room_user.dart';
import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class UsersEvent extends Equatable {
  @override
  List<Object> get props => [];
}

///
/// Event: ユーザー状態の変更
///
class UsersEventChangeEntity extends UsersEvent {
  final List<RoomUser> users;

  UsersEventChangeEntity({this.users});
  @override
  List<Object> get props => [users];
}
