import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class SignInEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInAnonymously extends SignInEvent {}

class SignInWithGoogle extends SignInEvent {}

class SignInWithTwitter extends SignInEvent {}
