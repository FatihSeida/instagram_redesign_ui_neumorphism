import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/blocs/blocs.dart';
import 'package:flutter_instagram/blocs/simple_bloc_observer.dart';
import 'package:flutter_instagram/config/custom_router.dart';
import 'package:flutter_instagram/cubits/cubits.dart';
import 'package:flutter_instagram/repositories/repositories.dart';
import 'package:flutter_instagram/screens/screens.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
        RepositoryProvider<StorageRepository>(
          create: (_) => StorageRepository(),
        ),
        RepositoryProvider<PostRepository>(
          create: (_) => PostRepository(),
        ),
        RepositoryProvider<NotificationRepository>(
          create: (_) => NotificationRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<LikedPostsCubit>(
            create: (context) => LikedPostsCubit(
              postRepository: context.read<PostRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
        ],
        child: NeumorphicApp(
          title: 'Flutter Instagram',
          debugShowCheckedModeBanner: false,
          materialTheme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: NeumorphicTheme.baseColor(context),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          theme: NeumorphicThemeData(
            baseColor: NeumorphicTheme.baseColor(context),
            lightSource: LightSource.topLeft,
            depth: 10,
            textTheme: TextTheme(
              subtitle1: GoogleFonts.sourceSansPro(color: Colors.grey),
              headline6: GoogleFonts.sourceSansPro(color: Colors.grey),
              headline5: GoogleFonts.sourceSansPro(color: Colors.grey),
              headline4: GoogleFonts.sourceSansPro(color: Colors.grey),
              headline3: GoogleFonts.sourceSansPro(color: Colors.grey),
              headline2: GoogleFonts.sourceSansPro(color: Colors.grey),
              headline1: GoogleFonts.sourceSansPro(color: Colors.grey),
            ),
          ),
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: SplashScreen.routeName,
        ),
      ),
    );
  }
}
