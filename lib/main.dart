import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/my_files/area.dart';
import 'package:flutter_application_1/my_files/map.dart';
import 'package:flutter_application_1/my_files/practice.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/photp_screen.dart';
import 'package:flutter_application_1/screens/test.dart';
import 'package:flutter_application_1/search_screen/search_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(428, 926),
          minTextAdapt: true,
          splitScreenMode: true,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Email And Password Login',
            theme: ThemeData(primarySwatch: Colors.blue,),
            debugShowCheckedModeBanner: false,
            //home: const test(),
            home: StreamBuilder(
              stream: FirebaseAuth.instance
                  .authStateChanges(), // .idTokenChanges   .userChanges
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    //return FirebaseAuth.instance.currentUser?.phoneNumber==''? photpscreen():const homescreen();
                    return const homescreen();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
                  );
                }
                return const test();
              },
            ),

            routes: {
              SearchProperty.routeName: (ctx) => SearchProperty(),
              Practice.routeName: (ctx) => Practice(),
              Area.routeName: (ctx) => Area(),
              Map_C.routeName: (ctx) => Map_C(),
            },
          );
        }
      ),
    );
  }
}
