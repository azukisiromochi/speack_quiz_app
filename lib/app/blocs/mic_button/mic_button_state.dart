import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class MicButtonState extends Equatable {
  @override
  List<Object> get props => [];
}

class MicButtonDefault extends MicButtonState {}

class MicButtonPushed extends MicButtonState {}
