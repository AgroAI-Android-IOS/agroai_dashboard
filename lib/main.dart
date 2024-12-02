import 'package:flareline/core/theme/global_theme.dart';
import 'package:flareline/flutter_gen/app_localizations.dart';
import 'package:flareline/routes.dart';  // Import your routes file
import 'package:flareline_uikit/service/localization_provider.dart';
import 'package:flareline_uikit/service/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'pages/Plants/View/PlantList.dart'; // Import the PlantListPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();
  
  if (GetPlatform.isDesktop && !GetPlatform.isWeb) {
    await windowManager.ensureInitialized();
    
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1080, 720),
      minimumSize: Size(480, 360),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(_)), // theme
        ChangeNotifierProvider(create: (_) => LocalizationProvider(_)), // localization
      ],
      child: Builder(builder: (context) {
        context.read<LocalizationProvider>().supportedLocales = AppLocalizations.supportedLocales;
        return MaterialApp(
          navigatorKey: RouteConfiguration.navigatorKey,
          restorationScopeId: 'rootFlareLine',
          title: 'FlareLine',
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: context.watch<LocalizationProvider>().locale,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateRoute: (settings) => RouteConfiguration.onGenerateRoute(settings),
          themeMode: context.watch<ThemeProvider>().isDark ? ThemeMode.dark : ThemeMode.light,
          theme: GlobalTheme.lightThemeData,
          darkTheme: GlobalTheme.darkThemeData,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
              child: widget!,
            );
          },
        );
      }),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlareLine'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.local_florist),
              title: Text('Plants'),
              onTap: () {
                // Navigate to PlantListPage using GetX
                Get.to(() => PlantListPage());
              },
            ),
            // Add more items here if needed
          ],
        ),
      ),
      body: Center(
        child: Text('Welcome to the FlareLine App!'),
      ),
    );
  }
}
