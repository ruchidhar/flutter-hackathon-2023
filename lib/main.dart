import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabasetime/account/view/account_view.dart';
import 'package:supabasetime/account/view_model/account_view_model.dart';
import 'package:supabasetime/calendar/view/calendar_view.dart';
import 'package:supabasetime/calendar/view_model/calendar_view_model.dart';
import 'package:supabasetime/home/repository/home_repo.dart';
import 'package:supabasetime/home/view/home_view.dart';
import 'package:supabasetime/login/view_model/login_view_model.dart';
import 'package:supabasetime/shared/services/image_picker/image_picker_service.dart';
import 'package:supabasetime/shared/services/input_validator/input_validator_service.dart';
import 'package:supabasetime/shared/services/supabase/supabase_service.dart';

import 'home/view_model/home_view_model.dart';
import 'locator.dart';
import 'login/view/login_view.dart';
import 'shared/routes/routes.dart';
import 'shared/services/navigation/navigation_service.dart';
import 'splash/view/splash_view.dart';
import 'splash/view_model/splash_view_model.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: '',
    anonKey: '',
  );

  // Init the service locator
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SplashViewModel(
            navigationService: locator<NavigationService>(),
            supabaseService: locator<SupabaseService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(
            navigationService: locator<NavigationService>(),
            supabaseService: locator<SupabaseService>(),
            inputValidatorService: locator<InputValidatorService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(
            navigationService: locator<NavigationService>(),
            supabaseService: locator<SupabaseService>(),
            homeRepository: locator<HomeRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AccountViewModel(
            navigationService: locator<NavigationService>(),
            supabaseService: locator<SupabaseService>(),
            imagePickerService: locator<ImagePickerService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CalendarViewModel(
            navigationService: locator<NavigationService>(),
            supabaseService: locator<SupabaseService>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Tracker',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(),
        ),
      ),
      initialRoute: AppRoutes.splashRoute,
      routes: <String, WidgetBuilder>{
        AppRoutes.splashRoute: (_) => const SplashView(),
        AppRoutes.loginRoute: (_) => const LoginView(),
        AppRoutes.homeRoute: (_) => const HomeView(),
        AppRoutes.accountRoute: (_) => const AccountView(),
        AppRoutes.calendarRoute: (_) => const CalendarView(),
      },
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
