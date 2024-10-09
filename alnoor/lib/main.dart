import 'package:alnoor/blocs/category_bloc.dart';
import 'package:alnoor/blocs/favorites_bloc.dart';
import 'package:alnoor/blocs/product_bloc.dart';
import 'package:alnoor/blocs/register_bloc.dart';
import 'package:alnoor/blocs/login_bloc.dart';
import 'package:alnoor/blocs/subcategory_bloc.dart';
import 'package:alnoor/repositories/category_repository.dart';
import 'package:alnoor/repositories/favourites_repository.dart';
import 'package:alnoor/repositories/product_repository.dart';
import 'package:alnoor/repositories/register_repository.dart';
import 'package:alnoor/repositories/login_repository.dart';
import 'package:alnoor/repositories/subcategory_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';  // Import the Google Fonts package
import 'screens/Landing_Screen/Splash_Screen.dart';
import 'services/notification_service.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS || Platform.isWindows)) {
    await FlutterDownloader.initialize(debug: true);
  }

  await _initializeNotifications();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoryBloc(CategoryRepository()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(ProductRepository()),
        ),
        BlocProvider(
          create: (context) => FavouriteBloc(FavouritesRepository()),
        ),
        BlocProvider(
          create: (context) =>
              RegisterBloc(registerRepository: RegisterRepository()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(loginRepository: LoginRepository()),
        ),
        BlocProvider(
            create: (context) => SubcategoryBloc(SubcategoryRepository()))
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
    NotificationService.initialize(context);

    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey, // Set the global key here
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme( // Use GoogleFonts Poppins throughout the app
          Theme.of(context).textTheme,
        ),
        
      ),
      home: StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
