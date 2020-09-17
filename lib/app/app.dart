import 'package:quiz_app/app/routes/menu_router.dart';
import 'package:quiz_app/app/widgets/components/quiz_progress_indicator.dart';
import 'package:quiz_app/app/widgets/pages/abstract/background_page.dart';
import 'blocs/authentication/auth_importer.dart';
import 'models/login_info.dart';
import 'utils/importer.dart';
import 'utils/my_colors.dart';
import 'repositories/firebase/auth_firebase_repository.dart';
import 'widgets/pages/sign_in_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 認証状態を取り扱うBlocを定義 + アプリ開始イベント(AppStarted)を発火
    return BlocProvider<AuthBloc>(
      create: (context) =>
          AuthBloc(repository: AuthFirestoreRepository())..add(AppStarted()),
      child: _App(),
    );
  }
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Eventout",
      theme: _buildThemeData(context),
      // 上位階層で画像を設定する
      home: BackgroundPage(
        child: BlocBuilder(
          bloc: BlocProvider.of<AuthBloc>(context),
          builder: (context, state) {
            // 認証状態に応じて画面を返却
            if (state is AuthSuccess) {
              return _buildSuccess(context, state);
            } else if (state is NotAuth) {
              return _buildFailure(context, state);
            }

            // 上記以外はプログレス表示
            return _buildProgress(context);
          },
        ),
      ),
    );
  }

  ///
  /// Build: テーマの生成
  ///
  ThemeData _buildThemeData(BuildContext context) {
    return ThemeData(
      // 背景画像を設定するため、背景色は基本透明
      backgroundColor: Colors.transparent,
      scaffoldBackgroundColor: Colors.transparent,
      fontFamily: "Segoe UI",
      textSelectionColor: Colors.black,
      buttonColor: MyColors.accentColor,
      appBarTheme: AppBarTheme(
        color: MyColors.accentColor,
      ),
    );
  }

  ///
  /// Build: 認証成功時
  ///
  Widget _buildSuccess(BuildContext context, AuthSuccess state) {
    // 認証成功時のみ、Providerで認証情報にアクセス可能にする
    LoginInfo _loginInfo = LoginInfo(user: state.loginUser);

    return Provider<LoginInfo>.value(
      value: _loginInfo,
      child: const MenuRouter(),
    );
  }

  ///
  /// Build: 未認証時
  ///
  Widget _buildFailure(BuildContext context, NotAuth state) {
    return const SignInPage();
  }

  ///
  /// Build: 読み込み表示時
  ///
  Widget _buildProgress(BuildContext context) {
    return Scaffold(
      body: Center(
        child: QuizProgressIndicator(),
      ),
    );
  }
}
