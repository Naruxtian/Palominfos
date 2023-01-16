import 'package:flutter/material.dart';
import 'package:palominfos/providers/series_provider.dart';
import 'package:palominfos/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'providers/movies_provider.dart';
import 'screens/screens.dart';


void main() => runApp(const AppState());


class AppState extends StatelessWidget {
  const AppState({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoviesProvider(), lazy: false,),
        ChangeNotifierProvider(create: (_) => SeriesProvider(), lazy: false,)
      ],
      child: const MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Palominfos',
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomeScreen(),
        'details': (_) => const DetailsScreen(),
        'serieDetails': (_) => const SeriesDetailsScreen(),
      },
      theme: AppTheme.christmasThemeDark,

    );
  }
}