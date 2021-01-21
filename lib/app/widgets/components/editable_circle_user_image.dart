import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/utils/my_colors.dart';
import 'package:quiz_app/app/widgets/components/circle_user_image.dart';

class EditableCircleUserImage extends CircleUserImage {
  const EditableCircleUserImage(
      {Key key, @required double size, imagePath, Color iconColor})
      : assert(size != null),
        this._iconColor = iconColor ?? MyColors.darkColor,
        super(key: key, size: size, imagePath: imagePath);

  // アイコン色
  final _iconColor;

  @override
  Widget build(BuildContext context) {
    // 画像
    final _image = super.build(context);

    // ボタン部分
    final radius = -size / 13;
    final iconSize = size / 5.0;

    final _uploadButton = Positioned(
      top: radius,
      right: radius,
      child: Container(
        child: Icon(
          Icons.file_upload,
          size: iconSize,
          color: _iconColor,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: _iconColor,
              width: 3,
            )),
      ),
    );

    return GestureDetector(
      child: Container(
        child: Stack(
          overflow: Overflow.visible,
          children: [
            _image,
            _uploadButton,
          ],
        ),
      ),
      onTap: () => showCameraSelector(context),
    );
  }

  Future<void> showCameraSelector(BuildContext context) async {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text("ギャラリー"),
                  onTap: () => _getImageFromDevice(ImageSource.gallery),
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("カメラ"),
                  onTap: () => _getImageFromDevice(ImageSource.camera),
                ),
              ],
            ));
  }

  _getImageFromDevice(ImageSource source) async {
    await ImagePicker.pickImage(source: source);
  }
}
