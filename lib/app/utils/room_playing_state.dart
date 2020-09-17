enum RoomPlayingState {
  LOBBY,
  PLAYING,
  FINISSHED,
}

extension RoomStateExtension on RoomPlayingState {
  String get name {
    switch (this) {
      case RoomPlayingState.LOBBY:
        return 'ロビー';
      case RoomPlayingState.PLAYING:
        return 'ゲーム中';
      case RoomPlayingState.FINISSHED:
        return '終了';
      default:
        return null;
    }
  }

  String get value {
    switch (this) {
      case RoomPlayingState.LOBBY:
        return '00010';
      case RoomPlayingState.PLAYING:
        return '00020';
      case RoomPlayingState.FINISSHED:
        return '00030';
      default:
        return null;
    }
  }

  static RoomPlayingState of(String value) {
    switch (value) {
      case '00010':
        return RoomPlayingState.LOBBY;
      case '00020':
        return RoomPlayingState.PLAYING;
      case '00030':
        return RoomPlayingState.FINISSHED;
      default:
        return null;
    }
  }
}
