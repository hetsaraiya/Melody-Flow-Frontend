import "dart:convert";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  Future<void> _signUp() async {
    await dotenv.load(fileName: ".env");
    String? api = dotenv.get("ENDPOINT", fallback: null);
    var url = '$api/api/signup/';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'username': usernameController.text,
          'name': nameController.text,
          'contact_number': contactNumberController.text,
          'email': emailController.text,
          'gender': genderController.text,
          'password1': passwordController.text,
          'password2': confirmPasswordController.text,
          'secret': dotenv.env["DJANGO_SECRET_KEY"],
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final data = jsonDecode(response.body);
        final String refresh = data['token'];
        final String jwtToken = data['access'];
        prefs.setString("jwtToken", jwtToken);
        prefs.setString("token", refresh);
        print("referesg $refresh");
        print(jwtToken);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Success',
                textAlign: TextAlign.center,
                style: GoogleFonts.acme(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
              ),
              content: Text(
                jsonResponse['msg'],
                textAlign: TextAlign.center,
                style: GoogleFonts.acme(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Request failed with status: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.blueGrey,
        body: Container(
      width: double.infinity,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  "Please Enter SignUp Details...",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.acme(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: 30)),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: usernameController,
                  obscureText: false,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'UserName',
                      hintStyle: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          color: Color.fromARGB(255, 134, 85, 85))),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: nameController,
                  obscureText: false,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Name',
                      hintStyle: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          color: Color.fromARGB(255, 134, 85, 85))),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: contactNumberController,
                  obscureText: false,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Contact Number',
                      hintStyle: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          color: Color.fromARGB(255, 134, 85, 85))),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: emailController,
                  obscureText: false,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Email',
                      hintStyle: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          color: Color.fromARGB(255, 134, 85, 85))),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: genderController,
                  obscureText: false,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Gender',
                      hintStyle: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          color: Color.fromARGB(255, 134, 85, 85))),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: passwordController,
                  obscureText: false,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Password',
                      hintStyle: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          color: Color.fromARGB(255, 134, 85, 85))),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: false,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Confirm Password',
                      hintStyle: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          color: Color.fromARGB(255, 134, 85, 85))),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              OutlinedButton(
                onPressed: _signUp,
                child: const Text("SignUp"),
              ),
              const SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
