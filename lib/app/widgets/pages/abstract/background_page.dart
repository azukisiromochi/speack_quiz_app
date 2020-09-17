import 'package:quiz_app/app/utils/importer.dart';

///
/// 背景用ページ
/// 画面いっぱいに背景画像を表示し、その上に子要素を表示する.
///
class BackgroundPage extends StatelessWidget {
  final Widget _child;

  const BackgroundPage({Key key, @required Widget child})
      : assert(child != null),
        this._child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // 背景画像を画面いっぱいに表示し、指定された子を上部に表示
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.none)),
        child: _child);
  }
}
