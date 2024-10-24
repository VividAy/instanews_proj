import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String link; // Add the link for the article

  const DetailsPage({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.link, // Accept the link for the article
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  // Function to show the leave dialog
  Future<void> _showLeaveDialog() async {
    bool shouldLeave = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave the Page?'),
          content: const Text('Do you want to open the link?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User chose to stay
              },
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User chose to leave
              },
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );

    // If the user confirmed to leave, open the link
    if (shouldLeave) {
      if (await canLaunch(widget.link)) {
        await launch(widget.link); // Open the article link in a browser
      } else {
        throw 'Could not launch ${widget.link}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) async {
          // Swipe left detected (negative velocity means swipe left)
          if (details.primaryVelocity! < 0) {
            // Show the dialog to confirm if the user wants to leave
            _showLeaveDialog();
          }
        },
        child: Column(
          children: [
            // First Container (showing an image)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    widget.imageUrl, // Display passed image URL
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Second Container (showing the title, description, and likes/comments)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title, // Display passed title
                              style: const TextStyle(
                                fontSize: 24.0,
                                color: Color(0xFF7FA643),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.description, // Display passed description
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      // Profile picture (bottom left)
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            'https://picsum.photos/200',
                          ),
                        ),
                      ),
                      // Heart icon (bottom right)
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite_border),
                              color: Colors.grey,
                              onPressed: () {
                                // Handle like button press
                              },
                            ),
                            const Text('0'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
