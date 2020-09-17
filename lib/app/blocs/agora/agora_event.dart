import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class AgoraEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AgoraStarted extends AgoraEvent {}
