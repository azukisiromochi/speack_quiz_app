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

class _SettingsForm extends StatefulWidget {
  const _SettingsForm({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingFormState();
}

class _SettingFormState extends State<_SettingsForm>
    with TickerProviderStateMixin {
  TabController _tabCon;

  final List<Tab> tabs = <Tab>[
    Tab(
      text: 'Profile',
    ),
    Tab(
      text: "Score",
    ),
  ];

  @override
  void initState() {
    super.initState();

    _tabCon = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget tabBarView = TabBarView(
      controller: _tabCon,
      children: tabs
          .map(
            (tab) => Container(
              height: 600,
              child: Text(tab.text),
            ),
          )
          .toList(),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              height: 600,
              child: Text("hoge"),
            ),
          ])),
        ],
      ),
    );
  }

  SliverAppBar _buildHeader(BuildContext context) {
    Decoration headerDecoration = BoxDecoration(
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
    );

    Widget userImage = EditableCircleUserImage(
      imagePath:
          "https://firebasestorage.googleapis.com/v0/b/quizpushtalk.appspot.com/o/o0800106713741944682.jpg?alt=media&token=8fbaa6b2-2b0e-41ca-99d3-ba9b505e1673",
      size: 100,
    );

    Widget userName = Text(
      "Lady GaGa",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );

    Widget tabBar = TabBar(
      controller: _tabCon,
      indicator: MaterialIndicator(
        color: Colors.black,
        horizontalPadding: 40,
        paintingStyle: PaintingStyle.fill,
      ),
      labelColor: Colors.black,
      tabs: tabs,
    );

    return SliverAppBar(
      shadowColor: Colors.black,
      floating: true,
      pinned: true,
      snap: true,
      bottom: tabBar,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: headerDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SpaceBox(height: 50),
              userImage,
              const SpaceBox(height: 5),
              userName,
              const SpaceBox(height: 5),
            ],
          ),
        ),
      ),
      expandedHeight: 200,
    );
  }
}
