import 'package:flutter/material.dart';
import 'package:melodyflow/Models/song.dart';

class SongContainer extends StatelessWidget {
  final Song song;

  const SongContainer({
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/play',
            arguments: song,
          );
        },
        child: SizedBox(
          width: screenWidth * 0.53,
          height: screenHeight * 0.23,
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  child: Transform.scale(
                    scale: 1.4,
                    child: Image.network(
                      song.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                top: 60,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.02,
                left: screenHeight * 0.02,
                right: screenHeight * 0.02,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: TextStyle(
                        fontSize: screenHeight * 0.018,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      song.artistName,
                      style: TextStyle(
                        fontSize: screenHeight * 0.014,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
