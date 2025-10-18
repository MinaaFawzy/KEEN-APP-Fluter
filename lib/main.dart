import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/screens/bottom_nav_bar/bottom_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,

    ),
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'KEEN',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.black,
          appBarTheme: const AppBarTheme(
            scrolledUnderElevation: 0.0,
          )
      ),
      home:  BottomNavBar(),
    );
  }
}

