import "package:flutter/material.dart";
import "package:melodyflow/Models/song.dart";
import "package:melodyflow/Pages/home.dart";
import "package:melodyflow/Pages/play.dart";
import "package:melodyflow/Pages/signin.dart";
import "package:melodyflow/Pages/signup.dart";
import "package:melodyflow/Pages/welcome.dart";
import "package:melodyflow/Theme/theme.dart";

void main() {
  runApp(const MelodyFlow());
}

class MelodyFlow extends StatefulWidget {
  const MelodyFlow({super.key});

  @override
  State<MelodyFlow> createState() => _MelodyFlowState();
}

class _MelodyFlowState extends State<MelodyFlow> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MelodyFlow",
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (context) => const Welcome(),
        '/signup': (context) => const SignUp(),
        '/signin': (context) => SignIn(),
        '/home': (context) => const HomePage(),
        '/play': (context) => PlaySong(song: ModalRoute.of(context)!.settings.arguments as Song,),
      },
    );
  }
}
