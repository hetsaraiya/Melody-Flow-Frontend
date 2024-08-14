// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> getUserName(){
//   await dotenv.load(fileName: ".env");
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? token = prefs.getString("jwtToken");
//   final response = await http.get(Uri.parse(''));
//   if (response.statusCode == 200) {
//     return response.body;
//   } else {
//     throw Exception('Failed to load user');
//   }
// }