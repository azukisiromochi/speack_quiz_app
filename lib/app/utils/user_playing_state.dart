enum UserPlayingState {
  IN_PREPARATION,
  READY,
}

extension UserPlayingStateExtension on UserPlayingState {
  String get name {
    switch (this) {
      case UserPlayingState.IN_PREPARATION:
        return '準備中';
      case UserPlayingState.READY:
        return '準備完了';
      default:
        return null;
    }
  }

  String get value {
    switch (this) {
      case UserPlayingState.IN_PREPARATION:
        return '00010';
      case UserPlayingState.READY:
        return '00020';
      default:
        return null;
    }
  }

  static UserPlayingState of(String value) {
    switch (value) {
      case '00010':
        return UserPlayingState.IN_PREPARATION;
      case '00020':
        return UserPlayingState.READY;
      default:
        return null;
    }
  }
}
