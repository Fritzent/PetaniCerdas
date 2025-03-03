import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:petani_cerdas/bloc/session_check_bloc.dart';
import 'package:petani_cerdas/pages/dashboard/calendar/add_calendar_page.dart';
import 'package:petani_cerdas/pages/dashboard/dashboard_page.dart';
import 'package:petani_cerdas/pages/dashboard/transaction/add_transaction_page.dart';
import 'package:petani_cerdas/pages/pin/login_pin_page.dart';
import 'package:petani_cerdas/repository/notification_service.dart';
import 'package:petani_cerdas/repository/user_service.dart';
import 'package:petani_cerdas/resources/style_config.dart';
import 'firebase_options.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/pin/create_pin_page.dart';
import 'pages/pin/otp_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidInitializationSettings initializationSettingsAndroid;
  late DarwinInitializationSettings iosSettings;

  initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  iosSettings = DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: iosSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<NotificationService>(
            create: (context) => NotificationService(
              flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
            ),
          ),
          RepositoryProvider<UserService>(
            create: (context) => UserService(),
          ),
        ],
        child: MainApp(
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        ),
      ),
    );
  });
}

class MainApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  const MainApp({super.key, required this.flutterLocalNotificationsPlugin});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SessionCheckBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: ColorList.whiteColor,
          textTheme: GoogleFonts.inriaSansTextTheme(),
        ),
        home: BlocBuilder<SessionCheckBloc, SessionCheckState>(
          builder: (context, state) {
            if (state.status == SessionStatus.loading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (state.status == SessionStatus.notFound) {
              return LoginPage();
            }
            return DashboardPage(
              notificationsPlugin: flutterLocalNotificationsPlugin,
            );
          },
        ),
        routes: {
          '/dashboard': (context) => DashboardPage(
                notificationsPlugin: flutterLocalNotificationsPlugin,
              ),
          '/login': (context) => LoginPage(),
          '/login_pin': (context) => LoginPinPage(),
          '/register': (context) => RegisterPage(),
          '/otp': (context) => OtpPage(),
          '/create_pin': (context) => CreatePinPage(),
          '/add_transaction': (context) => AddTransactionPage(),
          '/add_calendar': (context) => AddCalendarPage(),
        },
      ),
    );
  }
}
