import 'package:quiz_app/app/blocs/authentication/auth_event.dart';
import 'package:quiz_app/app/blocs/authentication/auth_importer.dart';
import 'package:quiz_app/app/blocs/room_management/room_management_importer.dart';
import 'package:quiz_app/app/models/login_info.dart';
import 'package:quiz_app/app/repositories/firebase/room_firebase_repository.dart';
import 'package:quiz_app/app/utils/importer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiz_app/app/utils/string_utils.dart';
import 'package:quiz_app/app/widgets/components/my_icon_button.dart';
import 'package:quiz_app/app/widgets/components/quiz_progress_indicator.dart';
import 'package:quiz_app/app/widgets/components/space_box.dart';
import 'package:quiz_app/app/widgets/pages/room_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RoomManagementBloc>(
          create: (context) =>
              RoomManagementBloc(repository: RoomFirebaseRepository()),
        )
      ],
      // モーダルプログレスの設定
      child: ProgressHUD(
        backgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
        // FIXME: サイズを指定しないとエラーになる
        indicatorWidget: Container(
          width: 5.0,
          height: 5.0,
          child: QuizProgressIndicator(),
        ),
        child: Scaffold(
          body: SingleChildScrollView(
            child: const _MenuForm(),
          ),
        ),
      ),
    );
  }
}

class _MenuForm extends StatelessWidget {
  const _MenuForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<RoomManagementBloc>(context),
      listener: (prevState, state) async {
        final _progress = ProgressHUD.of(context);

        // プログレス表示 ・ 非表示
        if (state is RoomManagementProgress) {
          _progress.show();
        } else {
          _progress.dismiss();
        }

        // 部屋作成 or 参加に成功した場合
        if (state is RoomManagementSuccess) {
          // ルーム画面に遷移
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomPage(
                roomId: state.roomId,
              ),
            ),
          );
        }

        // 部屋作成 or 参加に失敗した場合
        if (state is RoomManagementFailure) {
          // Toast表示
          if (state.message.isNotEmpty) {
            Fluttertoast.showToast(
              msg: state.message,
              backgroundColor: Colors.red[300],
              textColor: Colors.white,
              gravity: ToastGravity.TOP,
            );
          }
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SpaceBox(height: 100),
            const _LogoImage(),
            const SpaceBox(height: 75),
            MyIconButton(
              text: "ルームを作成する",
              width: 300,
              icon: Icons.home,
              onPressed: () async => onRoomCreate(context),
            ),
            const SpaceBox(height: 20),
            MyIconButton(
              text: "ルームを探す",
              width: 300,
              icon: Icons.search,
              onPressed: () async => onRoomSearch(context),
            ),
            const SpaceBox(height: 20),
            Container(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MyIconButton(
                    text: "スコア",
                    width: 140,
                    icon: Icons.assessment,
                    onPressed: () async => onScore(context),
                  ),
                  MyIconButton(
                    text: "設定",
                    width: 140,
                    color: Colors.grey,
                    textColor: Colors.white,
                    icon: Icons.settings,
                    onPressed: () async => onSettings(context),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///
  /// Event: ルーム作成ボタン押下
  ///
  Future<void> onRoomCreate(BuildContext context) async {
    // マイクのパーミッション確認
    await _handleMic();

    // ログイン情報を取得しイベント発火
    final LoginInfo loginInfo = Provider.of<LoginInfo>(context, listen: false);
    BlocProvider.of<RoomManagementBloc>(context)
        .add(RoomManagementCreated(user: loginInfo.user));
  }

  ///
  /// Event: ルームを探すボタン押下
  ///
  Future<void> onRoomSearch(BuildContext context) async {
    await _handleMic();

    String roomId = await showRoomSearchDialog(
      context: context,
      barrierDismissible: false,
    );

    // 部屋番号が入力されていれば次画面へ
    if (roomId != null) {
      // ログイン情報を取得しイベント発火
      final LoginInfo loginInfo =
          Provider.of<LoginInfo>(context, listen: false);
      BlocProvider.of<RoomManagementBloc>(context)
          .add(RoomManagementJoined(user: loginInfo.user, roomId: roomId));
    }
  }

  ///
  /// Event: スコアボタン押下
  ///
  Future<void> onScore(BuildContext context) async {
    // TODO: スコア確認ページを作成する(一旦ログアウト用に使用する)
    BlocProvider.of<AuthBloc>(context).add(LoggedOut());
  }

  ///
  /// Event: 設定ボタン押下
  ///
  Future<void> onSettings(BuildContext context) async {
    // TODO: 設定ページを作成する
  }

  ///
  /// Method: 「ルームを探す」ダイアログを表示する.
  ///
  Future<String> showRoomSearchDialog({
    @required BuildContext context,
    TransitionBuilder builder,
    bool useRootNavigator = true,
    bool barrierDismissible = true,
  }) {
    final Widget dialog = _RoomSearchDialog();
    return showDialog(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return builder == null ? dialog : builder(context, dialog);
      },
    );
  }

  ///
  /// Method: マイクの権限確認
  ///
  Future<void> _handleMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.microphone],
    );
  }
}

///
/// Class: 「ルームを探す」ダイアログWidget
///
class _RoomSearchDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RoomSearchDialogState();
}

class _RoomSearchDialogState extends State<_RoomSearchDialog> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    MaterialLocalizations localizations = MaterialLocalizations.of(context);

    final List<Widget> actions = [
      FlatButton(
        child: Text(localizations.cancelButtonLabel),
        onPressed: () => Navigator.pop(context),
      ),
      FlatButton(
        child: Text(localizations.okButtonLabel),
        onPressed: () {
          // バリデーションチェック
          if (_formKey.currentState.validate()) {
            String roomNo = _textController.text;
            // 呼び出し元に入力値を返却する
            Navigator.pop<String>(context, roomNo);
          }
        },
      ),
    ];

    return AlertDialog(
      title: Text("ルームを探す"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textController,
          maxLength: 6,
          decoration: InputDecoration(
            hintText: "ルーム番号",
          ),
          autofocus: true,
          keyboardType: TextInputType.number,
          // ignore: missing_return
          validator: (val) {
            if (val.isEmpty) {
              return 'ルーム番号を入力してください。';
            }
            if (!StringUtils.isNumeric(val)) {
              return '半角数字で入力してください。';
            }
            if (val.length != 6) {
              return "6桁で入力してください。";
            }
          },
        ),
      ),
      actions: actions,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

///
/// Class: ロゴ
///
class _LogoImage extends StatelessWidget {
  const _LogoImage({Key key}) : super(key: key);

  // TODO: 後からアニメーションにするから変える
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 222,
      height: 121,
      child: Image.asset(
        "assets/images/logo.png",
      ),
    );
  }
}
