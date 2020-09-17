import 'package:quiz_app/app/utils/importer.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'dart:math';

class QuizProgressIndicator extends ProgressIndicator {
  const QuizProgressIndicator({
    Key key,
    double value,
    Color backgroundColor,
    Animation<Color> valueColor,
    this.strokeWidth = 4.0,
    String semanticsLabel,
    String semanticsValue,
  }) : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
        );

  final double strokeWidth;

  @override
  State<StatefulWidget> createState() => _QuizProgressIndicatorState();
}

class _QuizProgressIndicatorState extends State<QuizProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  SequenceAnimation _sequenceAnimation;
  bool _isReverse = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _isReverse = !_isReverse;
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
        // 色変更
        .addAnimatable(
            animatable:
                ColorTween(begin: Colors.blueAccent, end: Colors.pinkAccent),
            from: Duration.zero,
            to: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutQuint,
            tag: "color_change")
        // 色変更(reverse)
        .addAnimatable(
            animatable:
                ColorTween(begin: Colors.pinkAccent, end: Colors.blueAccent),
            from: Duration.zero,
            to: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutQuint,
            tag: "color_reverse")
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController..forward(),
      builder: (context, child) {
        double fadeOutVal = _sequenceAnimation["fade_out"].value;
        double fadeInVal = _sequenceAnimation["fade_in"].value;
        Color color = _isReverse
            ? _sequenceAnimation["color_reverse"].value
            : _sequenceAnimation["color_change"].value;

        return Transform.rotate(
          angle: _sequenceAnimation["rotate"].value,
          child: CustomPaint(
            foregroundPainter: _MarkPainter(
              questionAnimationValue: _isReverse ? fadeInVal : fadeOutVal,
              exclamationAnimationValue: _isReverse ? fadeOutVal : fadeInVal,
              color: color,
            ),
          ),
        );
      },
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
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Paint circlePaint = Paint()..color = _color;
    canvas.drawCircle(center, 10, circlePaint);
  }

  void _paintExclamation(Canvas canvas, Size size) {
    double coefficient = _exclamationAnimationValue;
    double widthCenter = size.width / 2;
    double heightCenter = size.height / 2;

    // 棒線
    final Offset lineFrom =
        Offset(widthCenter, heightCenter - (20 * coefficient));
    final Offset lineTo =
        Offset(widthCenter, heightCenter - (80 * coefficient));
    final linePaint = Paint()
      ..color = _color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    canvas.drawLine(lineFrom, lineTo, linePaint);
  }

  void _paintQuestionMark(Canvas canvas, Size size) {
    double coefficient = _questionAnimationValue;
    double widthCenter = size.width / 2;
    double heightCenter = size.height / 2;

    // 棒線
    final Offset lineFrom =
        Offset(widthCenter, heightCenter - (20 * coefficient));
    final Offset lineTo =
        Offset(widthCenter, heightCenter - (35 * coefficient));
    final linePaint = Paint()
      ..color = _color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    canvas.drawLine(lineFrom, lineTo, linePaint);

    // 曲線
    final arcPaint = Paint()
      ..color = _color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    final Rect arcRect = Rect.fromCircle(
        center: Offset(widthCenter, heightCenter - (60 * coefficient)),
        radius: 20 * coefficient);
    final arcFrom = -pi * coefficient;
    final arcTo = pi * 1.5 * coefficient;
    canvas.drawArc(arcRect, arcFrom, arcTo, false, arcPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
