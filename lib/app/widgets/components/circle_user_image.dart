import 'package:quiz_app/app/utils/importer.dart';

class CircleUserImage extends StatelessWidget {
  const CircleUserImage({Key key, this.size, this.imagePath})
      : assert(size != null),
        super(key: key);

  final double size;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    // 円形にくりぬいて画像URLがあれば設定する
    BoxDecoration _boxDecoration = BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      border: Border.all(color: Colors.black),
      image: (imagePath.isNotEmpty)
          ? DecorationImage(fit: BoxFit.fill, image: NetworkImage(imagePath))
          : null,
    );

    // 画像がなければアイコンを設定
    Widget _icon = (imagePath.isEmpty)
        ? Icon(
            Icons.person,
            color: Colors.grey,
            size: size - 10,
          )
        : Container();

    // 表示
    return Container(
      width: size,
      height: size,
      decoration: _boxDecoration,
      child: _icon,
    );
  }
}
