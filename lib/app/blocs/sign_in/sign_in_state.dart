import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class SignInState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInEmpty extends SignInState {}

class SignInProgress extends SignInState {}

class SignInSuccess extends SignInState {}

class SignInFailure extends SignInState {}
