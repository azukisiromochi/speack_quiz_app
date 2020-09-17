import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/widgets/pages/menu_page.dart';

class MenuRouter extends StatelessWidget {
  const MenuRouter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: _Router.root,
      onGenerateRoute: _Router().onGenerateRoute,
    );
  }
}

class _Router {
  static final root = '/';

  final _routes = <String, Widget Function(BuildContext, RouteSettings)>{
    root: (context, settings) => const MenuPage(),
  };

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final pageBuilder = _routes[settings.name];
    if (pageBuilder != null) {
      return MaterialPageRoute<void>(
        builder: (context) => pageBuilder(context, settings),
        settings: settings,
      );
    }

    assert(false, 'unexpected settings: $settings');
    return null;
  }
}
