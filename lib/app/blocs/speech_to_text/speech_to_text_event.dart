import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class SpeechToTextEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SpeechToTextStarted extends SpeechToTextEvent {}

class SpeechToTextRecord extends SpeechToTextEvent {}

class SpeechToTextStop extends SpeechToTextEvent {}

class SpeechToTextExit extends SpeechToTextEvent {}

class SpeechToTextThrow extends SpeechToTextEvent {}
