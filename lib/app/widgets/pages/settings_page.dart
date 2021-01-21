import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/utils/my_colors.dart';
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
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
        ],
      ),
    );
  }

  SliverAppBar _buildHeader(BuildContext context) {
    return SliverAppBar(
      shadowColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(0.3, 1.6),
                end: Alignment.topRight,
                stops: [
                  0.5,
                  0.5,
                ],
                colors: [
                  MyColors.darkColor,
                  MyColors.baseColor,
                ]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SpaceBox(height: 50),
              EditableCircleUserImage(
                imagePath:
                    "https://firebasestorage.googleapis.com/v0/b/quizpushtalk.appspot.com/o/o0800106713741944682.jpg?alt=media&token=8fbaa6b2-2b0e-41ca-99d3-ba9b505e1673",
                size: 100,
              ),
              const SpaceBox(height: 5),
              Text(
                "Lady GaGa",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceBox(height: 5),
            ],
          ),
        ),
      ),
      expandedHeight: 200,
    );
  }
}
