import 'package:quiz_app/app/blocs/mic_button/mic_button_importer.dart';
import 'package:quiz_app/app/utils/importer.dart';

///
/// Class: プッシュトゥ―トーク用マイクのボタンクラス
///
class MicButton extends StatelessWidget {
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  const MicButton({Key key, this.onTapDown, this.onTapUp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MicButtonBloc>(
      create: (context) => MicButtonBloc(),
      child: _MicButtonBody(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
      ),
    );
  }
}

class _MicButtonBody extends StatelessWidget {
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  const _MicButtonBody({Key key, this.onTapDown, this.onTapUp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _onMicTapDown(context),
      onTapUp: (details) => _onMicTapUp(context),
      onLongPressEnd: (details) => _onMicTapUp(context),
      child: BlocBuilder(
        bloc: BlocProvider.of<MicButtonBloc>(context),
        builder: (context, state) {
          // 状態に応じて色を変更する
          Color _buttonColor =
              (state is MicButtonPushed) ? Colors.white : Colors.white;
          // FIXME: アイコンの色は色々試してみたい。いつか
          Color _iconColor =
              (state is MicButtonPushed) ? Colors.blueGrey : Colors.blueGrey;
          Color _borderColor =
              (state is MicButtonPushed) ? Colors.redAccent : Colors.grey;

          return Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _borderColor, width: 8),
              color: _buttonColor,
            ),
            child: Icon(
              EvaIcons.mic,
              size: 40,
              color: _iconColor,
            ),
          );
        },
      ),
    );
  }

  ///
  /// Event: マイクボタン押下開始
  ///
  void _onMicTapDown(BuildContext context) {
    // ボタンの状態変化
    BlocProvider.of<MicButtonBloc>(context).add(MicButtonPush());

    if (onTapUp != null) {
      onTapUp();
    }
  }

  ///
  /// Event: マイクボタンを離した
  ///
  void _onMicTapUp(BuildContext context) {
    // ボタンの状態変化
    BlocProvider.of<MicButtonBloc>(context).add(MicButtonRelease());

    if (onTapDown != null) {
      onTapDown();
    }
  }
}
