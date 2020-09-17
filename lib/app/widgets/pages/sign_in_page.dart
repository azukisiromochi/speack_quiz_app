import 'package:quiz_app/app/blocs/authentication/auth_importer.dart';
import 'package:quiz_app/app/blocs/sign_in/sign_in_importer.dart';
import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/utils/my_colors.dart';
import 'package:quiz_app/app/repositories/firebase/sign_in_firebase_repository.dart';
import 'package:quiz_app/app/widgets/components/space_box.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => SignInBloc(repository: SignInFireauthRepository()),
        child: const _SingInBody(),
      ),
    );
  }
}

class _SingInBody extends StatelessWidget {
  const _SingInBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // プログレスダイアログ用
    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, showLogs: true, isDismissible: false);

    // ignore: close_sinks
    SignInBloc _bloc = BlocProvider.of<SignInBloc>(context);

    return BlocListener(
      bloc: _bloc,
      listener: (prev, current) {
        // 状態が変更されたタイミングでダイアログが表示されていれば閉じる
        if (pr.isShowing()) {
          pr.hide();
        }

        // 状態が「処理中」の場合はプログレスダイアログを表示する
        if (current is SignInProgress) {
          // プログレスダイアログの表示
          pr.show();
        }

        // 成功
        if (current is SignInSuccess) {
          // 認証状態を「認証済」に変更する
          BlocProvider.of<AuthBloc>(context).add(LoggedIn());
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SpaceBox(height: 40),
            _LoginButton(
              text: "Twitterアカウントでログイン",
              color: MyColors.twitterColor,
              icon: EvaIcons.twitter,
              onPressed: () => _bloc.add(SignInWithTwitter()),
            ),
            const SpaceBox(height: 30),
            _LoginButton(
              text: "Googleアカウントでログイン",
              color: MyColors.googleColor,
              icon: EvaIcons.google,
              onPressed: () => _bloc.add(SignInWithGoogle()),
            ),
            const SpaceBox(height: 50),
            Divider(
              color: Colors.black,
            ),
            const SpaceBox(height: 10),
            Text("アカウント連携をせずに始める"),
            _LoginButton(
              text: "すぐに始める",
              color: const Color(0xff7E7E7E),
              icon: Icons.play_circle_filled,
              onPressed: () => _bloc.add(SignInAnonymously()),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String _text;
  final IconData _icon;
  final Color _color;
  final VoidCallback _onPressed;

  ///
  /// Event: ボタン押下
  ///
  void _handlePush() {
    if (_onPressed != null) {
      _onPressed();
    }
  }

  const _LoginButton(
      {Key key,
      String text,
      IconData icon,
      Color color,
      VoidCallback onPressed})
      : _text = text,
        _icon = icon,
        _color = color,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 300,
      child: RaisedButton(
        color: _color ?? MyColors.accentColor,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20, right: 10),
              child: Icon(
                _icon,
                color: Colors.white,
              ),
            ),
            Text(
              _text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        onPressed: () => _handlePush(),
      ),
    );
  }
}
