import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class SpeechToTextState extends Equatable {
  @override
  List<Object> get props => [];
}

class SpeechToTextInitial extends SpeechToTextState {}

class SpeechToTextReady extends SpeechToTextState {}

class SpeechToTextFailure extends SpeechToTextState {}
