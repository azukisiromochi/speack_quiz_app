import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/widgets/components/editable_circle_user_image.dart';
import 'package:quiz_app/app/widgets/components/space_box.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SettingsForm();
  }
}

class _SettingsForm extends StatelessWidget {
  const _SettingsForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // 横幅のマージン
          width: double.infinity,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SpaceBox(height: 100),
              Container(
                width: 100,
                height: 100,
                color: Colors.white,
              ),
              EditableCircleUserImage(
                size: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
