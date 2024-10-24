// thank_you_page.dart

import 'package:flutter/material.dart';
import 'package:instanews/main.dart';


class ThankYouPage extends StatelessWidget {
  const ThankYouPage(
      {super.key,
      required List<String> imageUrls,
      required List<String> descriptions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Thank you for your submission!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                ); // Go back to the previous page
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
