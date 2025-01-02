import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase core package
import 'package:provider/provider.dart'; // Provider package
import 'pages/splash_page.dart';
import 'firebase_options.dart'; // Firebase options file
import 'pages/recipe_provider.dart'; // RecipeProvider file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(DapurKuApp());
}

class DapurKuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()), // Register RecipeProvider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Roboto'),
        home: SplashScreen(),
      ),
    );
  }
}
