import 'package:quiz_app/app/blocs/agora/agora_importer.dart';
import 'package:quiz_app/app/blocs/room_page/room/room_state.dart';
import 'package:quiz_app/app/blocs/room_page/room_page_importer.dart';
import 'package:quiz_app/app/blocs/room_page/users/users_state.dart';
import 'package:quiz_app/app/blocs/speech_to_text/speech_to_text_importer.dart';
import 'package:quiz_app/app/models/login_info.dart';
import 'package:quiz_app/app/models/room_user.dart';
import 'package:quiz_app/app/repositories/firebase/room_firebase_repository.dart';
import 'package:quiz_app/app/utils/Icons/my_icons_importer.dart';
import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/utils/room_user_role.dart';
import 'package:quiz_app/app/utils/user_playing_state.dart';
import 'package:quiz_app/app/widgets/components/join_users_card_list.dart';
import 'package:quiz_app/app/widgets/components/mic_button.dart';
import 'package:quiz_app/app/widgets/components/my_icon_button.dart';
import 'package:quiz_app/app/widgets/components/quiz_progress_indicator.dart';
import 'package:quiz_app/app/widgets/components/quiz_text.dart';
import 'package:quiz_app/app/widgets/components/space_box.dart';

class RoomPage extends StatelessWidget {
  final String roomId;

  const RoomPage({Key key, this.roomId})
      : assert(roomId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // ログイン情報を取得
    LoginInfo _loginInfo = Provider.of<LoginInfo>(context);

    // 使用するBlocを全て定義しておく
    return MultiBlocProvider(
      providers: [
        // 画面全体の状態管理
        BlocProvider<RoomPageBloc>(
          create: (context) => RoomPageBloc(
            repository: RoomFirebaseRepository(),
            roomId: roomId,
            userId: _loginInfo.user.id,
          )..add(RoomPageShow()),
        ),
        // 音声通話(agora.io)の状態管理
        BlocProvider<AgoraBloc>(
          create: (context) =>
              AgoraBloc(channelId: roomId)..add(AgoraStarted()),
        ),
      ],
      child: const _RoomForm(),
    );
  }
}

class _RoomForm extends StatelessWidget {
  const _RoomForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: テスト用
    BlocProvider.of<AgoraBloc>(context);

    return BlocListener(
      bloc: BlocProvider.of<RoomPageBloc>(context),
      listener: (prev, current) {
        if (current is RoomPageClose) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  ///
  /// Build: AppBarの生成
  ///
  Widget _buildAppBar(BuildContext context) {
    // blocの取得
    // ignore: close_sinks
    final RoomPageBloc _bloc = BlocProvider.of<RoomPageBloc>(context);
    final String _roomId = _bloc.roomId;
    // TODO: 後から整形したい
    return AppBar(
      leading: IconButton(
        icon: Icon(
          LeaveRoomIcon.icon,
          color: Colors.black,
          size: 30,
        ),
        onPressed: () {
          // TODO: 退室してよいかの確認ダイアログを入れる
          _bloc.add(RoomPageExit());
        },
      ),
      centerTitle: true,
      title: Row(
        children: <Widget>[
          Text(
            "ルーム番号：",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          Text(
            _roomId,
            style: TextStyle(
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }

  ///
  /// Build: Body部の生成
  ///
  Widget _buildBody(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<RoomPageBloc>(context),
      builder: (context, state) {
        // ステータスに応じて画面描画
        if (state is RoomPageSuccess) {
          return _buildSuccess(context, state);
        } else if (state is RoomPageFailure) {
          return _buildFailure(context, state);
        }

        // 上記以外はプログレス表示
        return Center(
          child: QuizProgressIndicator(),
        );
      },
    );
  }

  // ===============================================
  // =====  画面全体の状態が変遷した際のBuildメソッド  ===============
  // ===============================================

  ///
  /// Build: 画面表示成功時
  ///
  Widget _buildSuccess(BuildContext context, RoomPageSuccess pageState) {
    return BlocBuilder(
      bloc: BlocProvider.of<RoomPageBloc>(context)?.roomBloc,
      builder: (context, roomState) {
        // 部屋の状態に応じて画面を表示する
        if (roomState is RoomStateLobby) {
          // ◆ロビー
          return _buildLobby(context);
        } else if (roomState is RoomStatePlaying) {
          // ◆プレイ中
          return _buildPlaying(context);
        } else if (roomState is RoomStateFinished) {
          // ◆ゲーム終了
          return _buildFinished(context);
        } else {
          // 該当しない場合は空表示
          return Container();
        }
      },
    );
  }

  ///
  /// Build: 画面表示失敗時
  ///
  Widget _buildFailure(BuildContext context, RoomPageFailure state) {
    return Container(
      child: Text("読み込み失敗"),
    );
  }

  // ===============================================
  // =====  画面表示成功時のBuildメソッド  ======================
  // ===============================================

  ///
  /// Build: [部屋ステート：ロビー(Initial)] 画面表示
  ///
  Widget _buildLobby(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          const SpaceBox(height: 30),
          _buildJoinUsersAreaForLobby(context),
          const SpaceBox(height: 50),
          _buildReadyButton(context),
          const SpaceBox(height: 30),
          const MicButton(),
        ],
      ),
    );
  }

  ///
  /// Build: [部屋ステート：プレイ中(Playing)] 画面表示
  ///
  Widget _buildPlaying(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<RoomPageBloc>(context)?.usersBloc,
      builder: (context, state) {
        if (state is UsersStateSuccess) {
          // 自身の情報を取得する
          RoomUser user = getLoginRoomUser(context, state.users);

          // 権限に応じて画面生成する
          bool isMaster = user.role == RoomUserRole.MASTER;
          return isMaster
              ? _buildPlayingMaster(context, state.users, user)
              : _buildPlayingGuest(context, state.users, user);
        }

        return Container();
      },
    );
  }

  ///
  /// Build: [部屋ステート：ゲーム終了(Finish)] 画面表示
  ///
  Widget _buildFinished(BuildContext context) {
    // TODO: ゲーム終了時のステータスに応じたWidgetを返す
    return Container();
  }

  // ===============================================
  // =====  ロビー状態のBuildメソッド  =========================
  // ===============================================

  ///
  /// Build: 参加者一覧枠の生成(ロビー用)
  ///
  Widget _buildJoinUsersAreaForLobby(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<RoomPageBloc>(context).usersBloc,
      builder: (context, userState) {
        List<RoomUser> users =
            (userState is UsersStateSuccess) ? userState.users : [];
        return JoinUsersCardList(
          users: users,
          isShowScore: false,
        );
      },
    );
  }

  // ===============================================
  // =====  ゲームプレイ中のBuildメソッド  ======================
  // ===============================================

  ///
  /// Build: [権限：ルームマスター]画面表示
  ///
  Widget _buildPlayingMaster(
      BuildContext context, List<RoomUser> users, RoomUser myUser) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          const SpaceBox(height: 30),
          _buildJoinUsersAreaForPlaying(context, users),
          const SpaceBox(height: 20),
          _buildSkipQuizButton(context),
          const SpaceBox(height: 80),
          const MicButton(),
        ],
      ),
    );
  }

  ///
  /// Build: [権限：ゲスト]画面表示
  ///
  Widget _buildPlayingGuest(
      BuildContext context, List<RoomUser> users, RoomUser myUser) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          const SpaceBox(height: 30),
          _buildQuizText(context),
          const SpaceBox(height: 20),
          _buildJoinUsersAreaForPlaying(context, users),
          const SpaceBox(height: 30),
          const MicButton(),
        ],
      ),
    );
  }

  Widget _buildMicButton(BuildContext context, RoomUser user) {
    // TODO: マスターの場合のみ、SpeechToTextBlocを作動させる
    return MicButton(
      onTapDown: () => {},
      onTapUp: () => {},
    );
  }

  ///
  /// Build: [次の問題へ]ボタン生成
  ///
  Widget _buildSkipQuizButton(BuildContext context) {
    return MyIconButton(
      color: Colors.grey,
      icon: Icons.skip_next,
      text: "次の問題へ",
      textColor: Colors.white,
      width: 170,
      onPressed: () => {
        // TODO: 次の問題というイベントを発火させる(イベント的には `正解`, `不正解`, `スキップ` の三種か？)
      },
    );
  }

  ///
  /// Build: 参加者一覧枠の生成(プレイ中用)
  ///
  Widget _buildJoinUsersAreaForPlaying(
      BuildContext context, List<RoomUser> users) {
    return JoinUsersCardList(
      users: users ?? [],
      isShowScore: true,
    );
  }

  ///
  /// Build: 問題文部分の生成
  ///
  Widget _buildQuizText(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<RoomPageBloc>(context).speechToTextBloc,
      listener: (prevState, state) {
        if (state is SpeechToTextFailure) {
          // エラーが発生した場合は、ひそかに初期化する
          BlocProvider.of<SpeechToTextBloc>(context).add(SpeechToTextStarted());
        }
      },
      child: StreamBuilder(
        stream:
            BlocProvider.of<RoomPageBloc>(context).speechToTextBloc.readText,
        builder: (context, snapshot) {
          return QuizText(
            quizText: snapshot?.data,
          );
        },
      ),
    );
  }

  // ===============================================
  // =====  その他共通Buildメソッド  ==========================
  // ===============================================

  ///
  /// Build: 準備ボタンの生成
  ///
  Widget _buildReadyButton(BuildContext context) {
    return Container(
      width: 220,
      height: 65,
      child: BlocBuilder(
        bloc: BlocProvider.of<RoomPageBloc>(context).usersBloc,
        builder: (context, userState) {
          if (userState is UsersStateSuccess) {
            return _buildReadyButtonSuccess(context, userState);
          }
          return Container();
        },
      ),
    );
  }

  ///
  /// Build: 準備ボタンの生成(ユーザー取得成功時)
  ///
  Widget _buildReadyButtonSuccess(
      BuildContext context, UsersStateSuccess state) {
    // ignore: close_sinks
    RoomPageBloc pageBloc = BlocProvider.of<RoomPageBloc>(context);

    // 自身を取得
    RoomUser myUser = getLoginRoomUser(context, state.users);
    if (myUser.role == RoomUserRole.MASTER) {
      return _buildMasterReadyButton(context, state.users, pageBloc);
    } else {
      return _buildGuestReadyButton(context, myUser, pageBloc);
    }
  }

  ///
  /// Build: ルームマスターの準備ボタン生成
  ///
  Widget _buildMasterReadyButton(
      BuildContext context, List<RoomUser> users, RoomPageBloc pageBloc) {
    VoidCallback _onPressed;
    if (canGameStarted(users)) {
      _onPressed = () => pageBloc.add(RoomPageEventGameStarted());
    }
    return RaisedButton(
      onPressed: _onPressed,
      child: Text('ゲーム開始'),
    );
  }

  ///
  /// Build: ゲストの準備ボタン生成
  ///
  Widget _buildGuestReadyButton(
      BuildContext context, RoomUser user, RoomPageBloc pageBloc) {
    switch (user.state) {
      case UserPlayingState.IN_PREPARATION:
        return RaisedButton(
          onPressed: () => pageBloc.add(RoomPageEventUserReady()),
          child: Text('準備完了'),
        );
      case UserPlayingState.READY:
        return RaisedButton(
          onPressed: () => pageBloc.add(RoomPageEventUserReadyCancel()),
          child: Text(
            '取り消し',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          color: Colors.blueGrey,
        );
        break;
      default:
        return Container();
    }
  }

  // ===============================================
  // =====  その他共通メソッド  =============================
  // ===============================================

  ///
  /// Method: アラートダイアログを表示する
  ///
  Future<void> _showAlertDialog(
      {BuildContext context, String title, String content}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          )
        ],
      ),
    );
  }

  ///
  /// Method: ログインユーザーのルームユーザー情報を取得する.
  ///
  RoomUser getLoginRoomUser(BuildContext context, List<RoomUser> users) {
    LoginInfo _loginInfo = Provider.of<LoginInfo>(context);
    return users.firstWhere((e) => e.id == _loginInfo.user.id);
  }

  ///
  /// Method: ゲーム開始可能か否か
  ///
  bool canGameStarted(List<RoomUser> users) {
    // 全員準備完了状態か否か
    bool isAllUsersReady = users
        .map((e) => e.state == UserPlayingState.READY)
        .reduce((a, b) => a && b);
    // 複数人いるか否か
    bool isMultiPlayer = users.length >= 2;

    // 全ての条件を満たすときにゲーム開始可能
    return isAllUsersReady && isMultiPlayer;
  }
}
