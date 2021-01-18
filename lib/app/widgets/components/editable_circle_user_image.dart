import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/widgets/components/circle_user_image.dart';

class EditableCircleUserImage extends CircleUserImage {
  const EditableCircleUserImage({Key key, @required double size, imagePath})
      : assert(size != null),
        super(key: key, size: size, imagePath: imagePath);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: super.build(context),
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
