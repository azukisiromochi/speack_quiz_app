import 'package:quiz_app/app/models/user.dart';
import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class NotAuth extends AuthState {}

class AuthProgress extends AuthState {}

class AuthSuccess extends AuthState {
  // ログインユーザー情報
  final User loginUser;

  AuthSuccess({this.loginUser})
      : assert(loginUser != null),
        super();

  @override
  List<Object> get props => [loginUser];
}
