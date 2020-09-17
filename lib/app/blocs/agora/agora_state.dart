import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class AgoraState extends Equatable {
  @override
  List<Object> get props => [];
}

class AgoraInitial extends AgoraState {}

class AgoraReady extends AgoraState {}
