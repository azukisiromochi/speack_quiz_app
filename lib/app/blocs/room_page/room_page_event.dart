import 'package:quiz_app/app/utils/importer.dart';

@immutable
abstract class RoomPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Event: 初期表示
class RoomPageShow extends RoomPageEvent {}

/// Event: 退室
class RoomPageExit extends RoomPageEvent {}

/// Event: ゲーム開始
class RoomPageEventGameStarted extends RoomPageEvent {}

/// Event: ゲーム終了
class RoomPageEventGameFinished extends RoomPageEvent {}

/// Event: ユーザー準備完了
class RoomPageEventUserReady extends RoomPageEvent {}

/// Event: ユーザー準備完了取り消し
class RoomPageEventUserReadyCancel extends RoomPageEvent {}
