import 'package:quiz_app/app/models/room_user.dart';
import 'package:quiz_app/app/utils/importer.dart';

///
/// 部屋全体の状態
///
@immutable
abstract class UsersState extends Equatable {
  @override
  List<Object> get props => [];
}

class UsersStateInitial extends UsersState {}

class UsersStateSuccess extends UsersState {
  final List<RoomUser> users;

  UsersStateSuccess({this.users});

  @override
  List<Object> get props => [users];
}
