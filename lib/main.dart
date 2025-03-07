import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/addproducts.dart';
import 'package:firebase_crud/auth.dart';
import 'package:firebase_crud/fetchproducts.dart';
import 'package:firebase_crud/firebase_options.dart';
import 'package:firebase_crud/products.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
  bool isAdmin = prefs.getBool("isAdmin") ?? false;


  runApp(MyApp( isLoggedIn: isLoggedIn, isAdmin: isAdmin));
 
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isAdmin;

  const MyApp({super.key, required this.isLoggedIn,required this.isAdmin});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:  ProductApi(),
        routes: {
          "/signup": (context) => Signup(),
           "/productApi": (context) => ProductApi(),
          "/products": (context) => isLoggedIn ? MyProducts()  : Login(),
          "/add": (context) => (isLoggedIn && isAdmin)? AddProducts() : Login(),
        });
  }
}
