import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class MicButtonEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MicButtonPush extends MicButtonEvent {}

class MicButtonRelease extends MicButtonEvent {}
