import 'package:quiz_app/app/utils/importer.dart';

class QuizText extends StatelessWidget {
  final String _quizText;

  const QuizText({Key key, String quizText})
      : _quizText = quizText,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: 枠線の丸みは要調整
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(right: 30, left: 30),
      width: double.infinity,
      height: 135,
      child: Text(_quizText ?? ""),
    );
  }
}
