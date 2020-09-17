import 'package:quiz_app/app/models/room.dart';
import 'package:quiz_app/app/models/room_user.dart';

abstract class RoomRepository {
  Future<bool> createRoom(Room room);

  Future<bool> joinRoom(String roomId, RoomUser user);

  Future<bool> exitRoom(String roomId, String userId);

  Stream<Room> fetch(String roomId);

  Future<Room> select(String roomId);

  Future<bool> updateUserState(String roomId, String userId, String state);

  Future<bool> updateRoomState(String roomId, String state);
}
