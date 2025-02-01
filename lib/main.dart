import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petani_cerdas/bloc/session_check_bloc.dart';
import 'package:petani_cerdas/pages/dashboard/dashboard_page.dart';
import 'package:petani_cerdas/pages/dashboard/transaction/add_transaction_page.dart';
import 'package:petani_cerdas/pages/pin/login_pin_page.dart';
import 'package:petani_cerdas/resources/style_config.dart';
import 'firebase_options.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/pin/create_pin_page.dart';
import 'pages/pin/otp_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
            return DashboardPage();
          },
        ),
        routes: {
          '/dashboard': (context) => DashboardPage(),
          '/login': (context) => LoginPage(),
          '/login_pin': (context) => LoginPinPage(),
          '/register': (context) => RegisterPage(),
          '/otp': (context) => OtpPage(),
          '/create_pin': (context) => CreatePinPage(),
          '/add_transaction': (context) => AddTransactionPage(),
        },
      ),
    );
  }
}
