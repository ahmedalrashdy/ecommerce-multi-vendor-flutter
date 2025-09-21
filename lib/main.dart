import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/core/blocs/auth/auth_events.dart';
import 'package:ecommerce/core/enums/enums.dart';
import 'package:ecommerce/core/helpers/AppHelper.dart';
import 'package:ecommerce/core/helpers/bloc_observer.dart';
import 'package:ecommerce/core/themes/app_theme.dart';
import 'core/blocs/locale/locale_cubit.dart';
import 'core/blocs/theme/theme_cubit.dart';
import 'core/blocs/theme/theme_state.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

late SharedPreferences appSharedPref;
void main() async {
  final Logger logger = Logger(
    printer: PrettyPrinter(
      colors: true,
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  appSharedPref = await AppHelper.sharedPreferencesInitial();

  await AppHelper.getAuthTokens();
  await dotenv.load(fileName: ".env");
  AppHelper.authBloc..add(AuthAppStarted());

  runApp(ProviderScope(
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => LocaleCubit()),
        BlocProvider(create: (ctx) => ThemeCubit()),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    if (locales != null && locales.isNotEmpty) {
      if (LocaleCubit.currentLangCode == SupportedLangs.system.value) {
        context.read<LocaleCubit>().changeLocale(SupportedLangs.system.value);
      }
    }
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (ThemeCubit.isSystemMode) {
      context.read<ThemeCubit>().setTheme(ThemeMode.system);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: AppHelper.authBloc),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, currentLocale) {
              String fontFamily =
                  currentLocale.languageCode == "ar" ? "Cairo" : "OpenSans";
              return MaterialApp.router(
                title: 'Your App Title',
                scaffoldMessengerKey: AppHelper.scaffoldMessengerKey,
                debugShowCheckedModeBanner: false,
                locale: currentLocale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                themeMode: themeState.themeMode,
                theme: AppTheme.lightTheme(fontFamily),
                darkTheme: AppTheme.darkTheme(fontFamily),
                routerConfig: AppHelper.appRouter,
              );
            },
          );
        },
      ),
    );
  }
}
