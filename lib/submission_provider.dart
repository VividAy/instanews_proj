import 'package:flutter/material.dart';
import 'submission.dart';

class SubmissionProvider with ChangeNotifier {
  // List to hold submissions
  List<Submission> _submissions = [
    // Add an initial predefined submission
    Submission(
      title: "Initial Submission",
      description:
          "This is an example submission before any new content is added.",
      imageUrl: "https://picsum.photos/300/200?image=1", // Sample image URL
    ),
  ];

  List<Submission> get submissions => _submissions;

  void addSubmission(Submission submission) {
    _submissions.add(submission);
    notifyListeners(); // Notify listeners about the change
  }
}
