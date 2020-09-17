import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/repositories/sign_in_repository.dart';

import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInRepository _repository;

  SignInBloc({SignInRepository repository})
      : assert(repository != null),
        _repository = repository,
        super();

  @override
  SignInState get initialState => SignInEmpty();

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is SignInAnonymously) {
      yield* _signInAnonymously(event);
    } else if (event is SignInWithGoogle) {
      yield* _signInWithGoogle(event);
    } else if (event is SignInWithTwitter) {
      _signInWithTwitter(event);
    }
  }

  ///
  /// Event: 匿名ログイン
  ///
  Stream<SignInState> _signInAnonymously(SignInAnonymously event) async* {
    yield SignInProgress();

    try {
      await _repository.signInAnonymously();
      yield SignInSuccess();
    } catch (e) {
      yield SignInFailure();
    }
  }

  ///
  /// Event: Googleログイン
  ///
  Stream<SignInState> _signInWithGoogle(SignInWithGoogle event) async* {
    yield SignInProgress();

    try {
      await _repository.signInWithGoogle();
      yield SignInSuccess();
    } catch (e) {
      yield SignInFailure();
    }
  }

  ///
  /// Event: Twitterログイン
  ///
  Stream<SignInState> _signInWithTwitter(SignInWithTwitter event) async* {
    yield SignInProgress();

    try {
      await _repository.signInWithTwitter();
      yield SignInSuccess();
    } catch (e) {
      yield SignInFailure();
    }
  }
}
