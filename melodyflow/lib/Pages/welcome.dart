import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:melodyflow/Helpers/fetchhome.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.6,
              child: Text(
                "$screenHeight",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Center(
              child: SizedBox(
                width: screenWidth * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async{
                    // await fetchSimpleHome();
                    Navigator.pushNamed(context, "/signin");
                  },
                  child: const Text("Sign In"),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Center(
              child: SizedBox(
                width: screenWidth * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/signup");
                  },
                  child: const Text("Sign Up"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
