import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/repositories/auth_repository.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({AuthRepository repository})
      : assert(repository != null),
        _repository = repository,
        super();

  @override
  get initialState => NotAuth();

  @override
  Stream<AuthState> mapEventToState(event) async* {
    if (event is AppStarted) {
      yield* _appStarted(event);
    } else if (event is LoggedIn) {
      yield* _loggedIn(event);
    } else if (event is LoggedOut) {
      yield* _loggedOut(event);
    }
  }

  ///
  /// Event: アプリ起動
  ///
  Stream<AuthState> _appStarted(AppStarted event) async* {
    yield AuthProgress();

    // 認証状態の確認
    final bool isSignIn = await _repository.isSignIn();

    if (isSignIn) {
      yield AuthSuccess(loginUser: await _repository.getCurrentUser());
    } else {
      yield NotAuth();
    }
  }

  ///
  /// Event: ログイン
  ///
  Stream<AuthState> _loggedIn(LoggedIn event) async* {
    yield AuthProgress();

    try {
      yield AuthSuccess(loginUser: await _repository.signIn());
    } catch (e) {
      yield NotAuth();
    }
  }

  ///
  /// Event: ログアウト
  ///
  Stream<AuthState> _loggedOut(LoggedOut event) async* {
    yield AuthProgress();
    await _repository.signOut();
    yield NotAuth();
  }
}
