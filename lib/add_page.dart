import 'package:flutter/material.dart';
import 'dart:io'; // For working with File
import 'package:provider/provider.dart';
import 'submission_provider.dart';
import 'submission.dart';
import 'thank_you_page.dart';
import 'data.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  dataStorage str = dataStorage();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _URLController = TextEditingController();
  String? _imageUrl;

  List<String> imageUrls = [];
  List<String> descriptions = [];

  List<String> _tags = []; // List of selected tags
  bool _showDropdown = false;
  final int maxWords = 50; // Maximum word limit for the description

  final List<String> _availableTags = [
    'Literature',
    '3D Art and Design',
    'Article Review',
    'Science Research',
    'Tennis'
  ];

  // Function to save the entered data
  void _saveData() {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    String imageUrl = _imageUrl ??
        ''; // Check for image URL or set an empty string if no image is uploaded

    // Validate if all fields are filled
    if (title.isEmpty) {
      _showErrorDialog('Title is required');
      return;
    }

    if (description.isEmpty) {
      _showErrorDialog('Description is required!');
      return;
    }

    if (imageUrl.isEmpty) {
      _showErrorDialog('Image is required!');
      return;
    }

    if (_tags.isEmpty) {
      _showErrorDialog('At least one tag is required!');
      return;
    }

    // Create a new Submission object
    Submission submission = Submission(
      title: title,
      description: description,
      imageUrl: imageUrl,
    );

    // Use Provider to update the list of submissions
    Provider.of<SubmissionProvider>(context, listen: false)
        .addSubmission(submission);

    // Navigate to the ThankYouPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThankYouPage(
          imageUrls: imageUrls,
          descriptions: descriptions,
        ),
      ),
    );
  }

// Method to show an error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to add a tag to the list
  void _addTag(String tag) {
    if (!_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _showDropdown = false;
      });
    }
  }

  // Function to count words in a text
  int _wordCount(String text) {
    if (text.isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  void _handleTap(
      String title, String description, String imageUrl, String articleUrl) {
    if (_wordCount(description) <= 50 &&
        _wordCount(title) <= 50 &&
        articleUrl.isNotEmpty) {
      str.addData(imageUrl, description, title, articleUrl, _tags);

      // Clear the form fields after successful submission
      _titleController.clear();
      _descriptionController.clear();
      _imageController.clear();
      _URLController.clear();
      _tags.clear();

      // Show confirmation dialog or navigate to Thank You page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThankYouPage(
            imageUrls: imageUrls,
            descriptions: descriptions,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 54),
                const Text(
                  'Add Your Submission',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7FA643),
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(_titleController, 'Enter Title:', 45),
                const SizedBox(height: 12),
                _buildDescriptionTextField(
                    _descriptionController, 'Enter Description:', 200),
                const SizedBox(height: 12),
                _buildTextField(_imageController, 'Enter image URL', 45),
                const SizedBox(height: 12),
                _buildTextField(_URLController, 'Enter article URL', 45),
                const SizedBox(height: 16),
                _buildTagsSection(),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Check if any field is empty or tags are not selected
                    if (_titleController.text.isEmpty) {
                      _showErrorDialog('Title is required!');
                    } else if (_descriptionController.text.isEmpty) {
                      _showErrorDialog('Description is required!');
                    } else if (_imageController.text.isEmpty) {
                      _showErrorDialog('Image URL is required!');
                    } else if (_URLController.text.isEmpty) {
                      _showErrorDialog('Article URL is required!');
                    } else if (_tags.isEmpty) {
                      _showErrorDialog('At least one tag is required!');
                    } else {
                      // All fields are filled, proceed with the submission
                      _handleTap(
                        _titleController.text,
                        _descriptionController.text,
                        _imageController.text,
                        _URLController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300], // Background color
                    minimumSize: const Size(150, 50),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7FA643),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to build the title text field
  Widget _buildTextField(
      TextEditingController controller, String hintText, double height) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        maxLines: height == 30 ? 1 : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  // Method to build the description text field with word limit logic and scrollability
  Widget _buildDescriptionTextField(
      TextEditingController controller, String hintText, double height) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: TextField(
              controller: controller,
              maxLines: null, // Makes the TextField expand vertically
              onChanged: (text) {
                if (_wordCount(text) > maxWords) {
                  // If the word count exceeds maxWords, truncate the text
                  final trimmedText = text
                      .trim()
                      .split(RegExp(r'\s+'))
                      .take(maxWords)
                      .join(' ');

                  controller.value = TextEditingValue(
                    text: trimmedText,
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: trimmedText.length),
                    ),
                  );
                }
                setState(() {}); // Rebuild to update the word count display
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              '${_wordCount(controller.text)}/$maxWords words',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build the tags section
  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _showDropdown = !_showDropdown;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Text('Tags',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF7FA643), width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add,
                          size: 14, color: Color(0xFF7FA643)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 8.0,
                children: _tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(tag,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _tags.remove(tag);
                            });
                          },
                          child: const Icon(Icons.close,
                              size: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_showDropdown)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: _availableTags.map((tag) {
                return ListTile(
                  title: Text(tag),
                  onTap: () {
                    _addTag(tag);
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
