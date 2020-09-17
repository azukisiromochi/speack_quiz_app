enum RoomUserRole {
  MASTER,
  GUEST,
}

extension RoomUserRoleExtension on RoomUserRole {
  String get name {
    switch (this) {
      case RoomUserRole.MASTER:
        return 'マスター';
      case RoomUserRole.GUEST:
        return 'ゲスト';
      default:
        return null;
    }
  }

  String get value {
    switch (this) {
      case RoomUserRole.MASTER:
        return '00010';
      case RoomUserRole.GUEST:
        return '00020';
      default:
        return null;
    }
  }

  static RoomUserRole of(String value) {
    switch (value) {
      case '00010':
        return RoomUserRole.MASTER;
      case '00020':
        return RoomUserRole.GUEST;
      default:
        return null;
    }
  }
}
