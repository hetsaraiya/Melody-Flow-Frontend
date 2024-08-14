import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:melodyflow/Models/song.dart';

Future<List<Song>> fetchHome() async {
  await dotenv.load(fileName: ".env");
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // String? token = prefs.getString("jwtToken");
  // print('Token: $token');

  // if (token == null || token.isEmpty) {
  //   print('Error: No token found');
  //   return [];
  // }

  final Map<String, dynamic> requestData = {
    'secret': dotenv.env["DJANGO_SECRET_KEY"],
  };

  final response = await http.post(
    Uri.parse('${dotenv.env['ENDPOINT']}/api/home'),
    headers: {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $token',
    },
    body: jsonEncode(requestData),
  );

  if (response.statusCode == 200) {
    print('Response: ${response.body}');
    final responseBody = jsonDecode(response.body);
    final List<dynamic> videos = responseBody['videos'];
    final List<Song> songs =
        videos.map((video) => Song.fromJson(video)).toList();

    return songs;
  } else {
    print('Error: ${response.body}');
    return [];
  }
}
