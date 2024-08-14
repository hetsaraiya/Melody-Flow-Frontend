// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:melodyflow/Models/serach.dart';
import 'package:melodyflow/Models/song.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SearchResultWidget extends StatefulWidget {
  final List<Search> searchResults;
  final Function(String) onSuggestionTap;

  SearchResultWidget(
      {required this.searchResults, required this.onSuggestionTap});

  @override
  State<SearchResultWidget> createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  bool _isLoading = false;

  Future<void> getSong(songId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await dotenv.load(fileName: ".env");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("jwtToken");
      final response = await http.post(
        Uri.parse('${dotenv.env['ENDPOINT']}/api/getSong'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': songId,
          'secret': dotenv.env["DJANGO_SECRET_KEY"]!,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushNamed(
          context,
          '/play',
          arguments: Song.fromJson(jsonDecode(response.body)),
        );
      } else {
        throw Exception('Failed to load song');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load song. Please try again later. with $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.searchResults.length,
          itemBuilder: (context, index) {
            final result = widget.searchResults[index];
            return ListTile(
              leading: result.type == 'suggestion'
                  ? const Icon(Icons.search)
                  : const Icon(Icons.music_note),
              title: Text(result.title),
              subtitle: result.subTitle != null ? Text(result.subTitle!) : null,
              trailing: result.thumbnail != null
                  ? Image.network(result.thumbnail!, width: 50, height: 50)
                  : null,
              onTap: () {
                if (result.type == 'song') {
                  getSong(result.videoId);
                } else if (result.type == 'playlist') {
                  Fluttertoast.showToast(
                    msg: "Coming Soon",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else if (result.type == "suggestion") {
                  widget.onSuggestionTap(result.title);
                }
              },
            );
          },
        ),
        if (_isLoading)
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
