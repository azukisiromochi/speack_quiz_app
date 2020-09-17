import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/utils/my_colors.dart';

///
/// Class: ボタン
///
class MyIconButton extends StatelessWidget {
  final double _width;
  final String _text;
  final IconData _icon;
  final Color _color;
  final Color _textColor;
  final VoidCallback _onPressed;

  ///
  /// Event: ボタン押下
  ///
  void _handlePush() {
    if (_onPressed != null) {
      _onPressed();
    }
  }

  const MyIconButton(
      {Key key,
      double width,
      String text,
      IconData icon,
      Color color,
      Color textColor,
      VoidCallback onPressed})
      : _width = width,
        _text = text,
        _icon = icon,
        _color = color,
        _textColor = textColor,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: _width,
      child: RaisedButton(
        color: _color ?? MyColors.accentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15, right: 10),
              child: Icon(
                _icon,
                color: _textColor,
              ),
            ),
            Text(
              _text,
              style: TextStyle(color: _textColor),
            ),
          ],
        ),
        onPressed: () => _handlePush(),
      ),
    );
  }
}
