import 'package:quiz_app/app/blocs/room_page/users/users_event.dart';
import 'package:quiz_app/app/blocs/room_page/users/users_state.dart';
import 'package:quiz_app/app/utils/importer.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  @override
  UsersState get initialState => UsersStateInitial();

  @override
  Stream<UsersState> mapEventToState(UsersEvent event) async* {
    if (event is UsersEventChangeEntity) {
      yield* _changeEntity(event);
    }
  }

  ///
  /// Event: 状態変更
  ///
  Stream<UsersState> _changeEntity(UsersEventChangeEntity event) async* {
    try {
      // 画面内の状態が変更されているか
      bool isChangeState = this.state is! UsersStateSuccess;

      // 部屋の状態を確認し、変更されているか
      UsersStateSuccess _state =
          this.state is UsersStateSuccess ? this.state : null;
      bool isChangeUsers = event.users.map((e) => e.toString()).join(",") !=
          _state?.users?.map((e) => e.toString())?.join(",");

      // どちらかが真の場合のみ変更を通知
      if (isChangeState || isChangeUsers) {
        yield UsersStateSuccess(users: event.users);
      }
    } catch (e) {
      // TODO: エラー内容を確認
      debugPrint(e);
    }
  }
}
