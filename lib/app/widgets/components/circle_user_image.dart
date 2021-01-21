import 'package:quiz_app/app/utils/importer.dart';

class CircleUserImage extends StatelessWidget {
  const CircleUserImage({Key key, this.size, this.imagePath})
      : assert(size != null),
        super(key: key);

  final double size;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    bool hasImagePath = imagePath != null && imagePath.isNotEmpty;

    // 画像をくり抜いてURLがあれば設定する
    BoxDecoration _boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
      color: Colors.white,
      image: hasImagePath
          ? DecorationImage(fit: BoxFit.fill, image: NetworkImage(imagePath))
          : DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/empty_user_image.png")),
    );

    // 表示
    return Container(
      width: size,
      height: size,
      decoration: _boxDecoration,
    );
  }
}
