import 'package:flutter/material.dart';
import 'package:melodyflow/Helpers/fetchhome.dart';
import 'package:melodyflow/Helpers/search.dart';
import 'package:melodyflow/Models/song.dart';
import 'package:melodyflow/Models/serach.dart';
import 'package:melodyflow/Widgets/search_container.dart';
import 'package:melodyflow/Widgets/song_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Song> _songs = [];
  List<Search> _searchResults = [];
  bool _isLoading = true;
  bool _isSearching = false;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final List<String> _sectionTitles = [
    'Top Hits',
    'New Releases',
    'Recommended for You',
    'Trending Now',
  ];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    List<Song> songs = await fetchHome();
    print('Fetched ${songs.length} songs');
    for (var song in songs) {
      print('Title: ${song.title}, Artist: ${song.artistName}');
    }
    setState(() {
      _songs = songs;
      _isLoading = false;
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    try {
      List<Search> results = await searchSongs(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleSuggestionTap(String suggestion) {
    setState(() {
      _searchController.text = suggestion;
      _isSearching = true;
    });
    _performSearch(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _songs.isEmpty
                ? const Text('No songs found')
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _isSearching
                                  ? Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: screenWidth * 0.1,
                                            left: screenWidth * 0.1),
                                        child: TextField(
                                          focusNode: _searchFocusNode,
                                          controller: _searchController,
                                          decoration: InputDecoration(
                                            hintText: 'Search songs...',
                                            border: const OutlineInputBorder(),
                                            suffixIcon: IconButton(
                                              icon: const Icon(Icons.clear),
                                              onPressed: () {
                                                setState(() {
                                                  _isSearching = false;
                                                  _searchController.clear();
                                                  _searchResults = [];
                                                });
                                              },
                                            ),
                                          ),
                                          onChanged: (value) {
                                            _performSearch(value);
                                          },
                                        ),
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.search),
                                      onPressed: () {
                                        setState(() {
                                          _isSearching = true;
                                        });
                                        _searchFocusNode.requestFocus();
                                      },
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: Text(
                            'Welcome to MelodyFlow!',
                            style: TextStyle(
                              fontSize: screenHeight * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        _searchResults.isNotEmpty
                            ? SearchResultWidget(
                                searchResults: _searchResults,
                                onSuggestionTap: _handleSuggestionTap,
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: (_songs.length / 4).ceil(),
                                itemBuilder: (context, rowIndex) {
                                  int startIndex = rowIndex * 4;
                                  int endIndex = startIndex + 4;
                                  if (endIndex > _songs.length) {
                                    endIndex = _songs.length;
                                  }
                                  List<Song> rowSongs =
                                      _songs.sublist(startIndex, endIndex);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.03,
                                            vertical: screenHeight * 0.02),
                                        child: Text(
                                          _sectionTitles[
                                              rowIndex % _sectionTitles.length],
                                          style: TextStyle(
                                            fontSize: screenHeight * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: rowSongs.map((song) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      screenWidth * 0.03),
                                              child: SongContainer(song: song),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.025),
                                    ],
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
