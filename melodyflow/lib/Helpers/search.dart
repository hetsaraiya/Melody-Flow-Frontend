// ignore_for_file: prefer_const_declarations

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:melodyflow/Models/serach.dart';

Future<List<Search>> searchSongs(String query) async {
  await dotenv.load(fileName: ".env");
  final String apiUrl = "${dotenv.env['ENDPOINT']}/api/searchSong?q=$query";
  print("object $query");
  final Map<String, dynamic> requestData = {'q': query};

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(requestData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body)['data'] as List<dynamic>;
      print("object ${jsonDecode(response.body)['data'] as dynamic}");
      return jsonList.map((e) => Search.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load songs');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<List<Search>> performSearch(String query) async {
  if (query.isEmpty) {
    return [];
  }

  try {
    List<Search> results = await searchSongs(query);
    return results;
  } catch (e) {
    // Decide how to handle the error. Here, we rethrow it.
    throw Exception('Failed to perform search');
  }
}
