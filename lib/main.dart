import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:sidebarx/sidebarx.dart';



void main() {
  setPathUrlStrategy();
  return runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  static const String title = 'GoRouter Routes';

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerDelegate: _router.routerDelegate,
    routeInformationParser: _router.routeInformationParser,
    routeInformationProvider: _router.routeInformationProvider,
  );

  final GoRouter _router = GoRouter(
    errorBuilder: (context, state) =>  SidebarXExampleApp(path: "homepage", params: {}),
    routes: <GoRoute>[
      GoRoute(

        routes: <GoRoute>[
          GoRoute(
            path: 'personal',
            builder: (BuildContext context, GoRouterState state) =>
            SidebarXExampleApp(path: "personal", params: {})),
          GoRoute(
            path: 'dashboard',
            builder: (BuildContext context, GoRouterState state) =>
            SidebarXExampleApp(path: "dashboard", params: {})),
        ],
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
        SidebarXExampleApp(path: "homepage", params: {})),
    ],

  );
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("HomePage");
  }
}


class SidebarXExampleApp extends StatelessWidget {
  final Map<String, dynamic> params;
  final String path;
  SidebarXExampleApp({Key? key, required this.path, required this.params}) : super(key: key);
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _controller.selectIndex(getindex(path));

    print("path: "+path);


    return MaterialApp(
      title: 'SidebarX Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(
          headline5: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
              backgroundColor: canvasColor,
              title: Text(_getTitleByIndex(_controller.selectedIndex)),
              leading: IconButton(
                onPressed: () {
                  // if (!Platform.isAndroid && !Platform.isIOS) {
                  //   _controller.setExtended(true);
                  // }
                  _key.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu),
              ),
            )
                : null,
            drawer: ExampleSidebarX(controller: _controller),
            body: Row(
              children: [
                if (!isSmallScreen) ExampleSidebarX(controller: _controller),
                Expanded(
                  child: Center(
                    child: _ScreensExample(controller: _controller,params: {},)
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,

      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
          onTap: () {
            GoRouter.of(context).go('/');
          },
        ),
        SidebarXItem(
          icon: Icons.search,
          label: 'Dashboard',
          onTap: () {
            GoRouter.of(context).go('/dashboard');
          },
        ),
        SidebarXItem(
          icon: Icons.account_circle,
          label: 'Personal',
          onTap: () {
            GoRouter.of(context).go('/personal');
          },
        ),
      ],
    );
  }
}


class _ScreensExample extends StatelessWidget {
  final  Map<String, dynamic> params;
  const _ScreensExample({
    Key? key, required this.params,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            print("animatebuilder home");
            return Text("home");
          case 1:
            print("animatebuilder dashboard");
            return Text("dashboard");
          case 2:
            print("animatebuilder personal");
            return Text("personal");

          default:
            return  CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: <Widget>[
                      const Text('Header'),

                      const Text('Footer'),
                    ],
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}
int getindex(String path)
{
  if (path=="homepage") return 0;
  if (path=="dashboard") return 1;
  if (path=="personal") return 2;
  return 0;
}
String _getTitleByIndex(int index) {
  switch (index) {

    case 0:
      return 'Home';
    case 1:
      return 'Dashboard';
    case 2:
      return 'Personal';

    default:
      return 'Not found page';
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);