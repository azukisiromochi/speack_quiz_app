import 'package:quiz_app/app/utils/importer.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'dart:math';

class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuizProgressIndicatorState();
}

class _QuizProgressIndicatorState extends State<TestPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  SequenceAnimation _sequenceAnimation;
  bool _isRepeat = true;

  @override
  void initState() {
    super.initState();

    // 1秒間隔で繰り返す
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..addStatusListener((status) {
        // 完了したタイミングでフラグ値を反転
        if (status == AnimationStatus.completed) {
          _isRepeat = !_isRepeat;
          _animationController.reset();
          _animationController.forward();
        }
      });
//      ..repeat();

    _sequenceAnimation = SequenceAnimationBuilder()
        // 回転
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: pi * 2),
            from: Duration.zero,
            to: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutQuint,
            tag: "rotate")
        // フェードアウト
        .addAnimatable(
            animatable: Tween<double>(begin: 1.0, end: 0.0),
            from: Duration.zero,
            to: const Duration(milliseconds: 500),
            curve: Curves.easeInQuart,
            tag: "fade_out")
        // フェードイン
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: 1.0),
            from: const Duration(milliseconds: 500),
            to: const Duration(milliseconds: 1000),
            curve: Curves.easeOutQuart,
            tag: "fade_in")
        // 色変更①
        .addAnimatable(
            animatable:
                ColorTween(begin: Colors.blueAccent, end: Colors.pinkAccent),
            from: Duration.zero,
            to: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutQuint,
            tag: "color_out")
        // 色変更②
        .addAnimatable(
            animatable:
                ColorTween(begin: Colors.pinkAccent, end: Colors.blueAccent),
            from: Duration.zero,
            to: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutQuint,
            tag: "color_in")
        .animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          double fadeOutVal = _sequenceAnimation["fade_out"].value;
          double fadeInVal = _sequenceAnimation["fade_in"].value;

          return Center(
            child: Transform.rotate(
              angle: _sequenceAnimation["rotate"].value,
              child: CustomPaint(
                foregroundPainter: _MarkPainter(
                  questionAnimationValue: _isRepeat ? fadeOutVal : fadeInVal,
                  exclamationAnimationValue: _isRepeat ? fadeInVal : fadeOutVal,
                  color: _isRepeat
                      ? _sequenceAnimation["color_out"].value
                      : _sequenceAnimation["color_in"].value,
                ),
                child: Container(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  final double _questionAnimationValue;
  final double _exclamationAnimationValue;
  final Color _color;

  _MarkPainter(
      {Key key,
      @required double questionAnimationValue,
      @required double exclamationAnimationValue,
      @required Color color})
      : assert(questionAnimationValue != null),
        assert(exclamationAnimationValue != null),
        assert(color != null),
        _questionAnimationValue = questionAnimationValue,
        _exclamationAnimationValue = exclamationAnimationValue,
        _color = color,
        super();

  @override
  void paint(Canvas canvas, Size size) {
    // クエスチョンマークの描画
    _paintQuestionMark(canvas, size);

    // ビックリマークの描画
    _paintExclamation(canvas, size);

    //　中心点の描画
    // 点 (色だけ変動)
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Paint circlePaint = Paint()..color = _color;
//    final Paint circlePaint = Paint()..color = Colors.grey;
    canvas.drawCircle(center, 10, circlePaint);
  }

  ///
  /// Method: びっくりマークの描画
  ///
  void _paintExclamation(Canvas canvas, Size size) {
    // 色設定 (ピンク)
    Color color = Colors.pinkAccent;

    // 点 (色だけ変動)
//    final Offset center = Offset(size.width / 2, size.height / 2);
//    final Paint circlePaint = Paint()
//      ..color = color.withOpacity(_exclamationAnimationValue);
//    canvas.drawCircle(center, 10, circlePaint);

    // 棒線
    final Offset lineFrom = Offset(
        size.width / 2, (size.height / 2) - (20 * _exclamationAnimationValue));
    final Offset lineTo = Offset(
        size.width / 2, (size.height / 2) - (80 * _exclamationAnimationValue));
    final linePaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    canvas.drawLine(lineFrom, lineTo, linePaint);
  }

  ///
  /// Method: クエスチョンマークの描画
  ///
  void _paintQuestionMark(Canvas canvas, Size size) {
    // 色設定 (青)
    Color color = Colors.blueAccent;

    // 点 (色だけ変動)
//    final Offset center = Offset(size.width / 2, size.height / 2);
//    final Paint circlePaint = Paint()
//      ..color = color.withOpacity(_questionAnimationValue);
//    canvas.drawCircle(center, 10, circlePaint);

    // 棒線
    final Offset lineFrom = Offset(
        size.width / 2, (size.height / 2) - (20 * _questionAnimationValue));
    final Offset lineTo = Offset(
        size.width / 2, (size.height / 2) - (35 * _questionAnimationValue));
    final linePaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    canvas.drawLine(lineFrom, lineTo, linePaint);

    // 曲線
    final arcPaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round //　線の先端が丸っこくなる
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    final Rect arcRect = Rect.fromCircle(
        center: Offset(
            size.width / 2, (size.height / 2) - (60 * _questionAnimationValue)),
        radius: (20 * _questionAnimationValue));
    final arcFrom = (-1 * pi * _questionAnimationValue);
    final arcTo = (pi * 1.5 * _questionAnimationValue);
    canvas.drawArc(arcRect, arcFrom, arcTo, false, arcPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
