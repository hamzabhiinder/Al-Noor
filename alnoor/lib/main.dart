import 'package:alnoor/blocs/category_bloc.dart';
import 'package:alnoor/blocs/favorites_bloc.dart';
import 'package:alnoor/blocs/product_bloc.dart';
import 'package:alnoor/repositories/category_repository.dart';
import 'package:alnoor/repositories/favourites_repository.dart';
import 'package:alnoor/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/product.dart';
import 'screens/Landing_Screen/Splash_Screen.dart';
import 'utils/product_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register the adapter
  Hive.registerAdapter(ProductAdapter());

  // Open the box only once and keep it open
  final productBox = await Hive.openBox<List<dynamic>>('productBox');

  await _initializeNotifications();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoryBloc(CategoryRepository()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(ProductRepository(), productBox),
        ),
        BlocProvider(
          create: (context) => FavouriteBloc(FavouritesRepository()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> _initializeNotifications() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
