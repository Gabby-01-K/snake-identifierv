// lib/pages/details_page.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsPage extends StatefulWidget {
  // We require the snake name to be passed to this page
  final String snakeName;

  const DetailsPage({super.key, required this.snakeName});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool _isBookmarked = false;
  bool _isLoading = true; // Loading state for checking bookmark
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // When the page loads, check if this snake is already bookmarked
    _checkIfBookmarked();
  }

  /// Gets the current user's ID
  String? get _userId => _auth.currentUser?.uid;

  /// Checks Firestore to see if the snake is bookmarked
  Future<void> _checkIfBookmarked() async {
    // Don't do anything if the user isn't logged in
    if (_userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final docRef = _firestore
          .collection('users')
          .doc(_userId)
          .collection('bookmarks')
          .doc(widget.snakeName); // Use snake name as the ID

      final doc = await docRef.get();

      if (mounted) {
        setState(() {
          _isBookmarked = doc.exists;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error checking bookmark: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Toggles the bookmark status in Firestore
  Future<void> _toggleBookmark() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to bookmark.')),
      );
      return;
    }

    setState(() {
      _isBookmarked = !_isBookmarked; // Optimistic update for quick UI feedback
    });

    final docRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('bookmarks')
        .doc(widget.snakeName);

    try {
      if (_isBookmarked) {
        // If it's now bookmarked, add it to Firestore
        await docRef.set({
          'name': widget.snakeName,
          'timestamp': FieldValue.serverTimestamp(), // So we can sort later
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to bookmarks!')),
          );
        }
      } else {
        // If it's no longer bookmarked, remove it
        await docRef.delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Removed from bookmarks.')),
          );
        }
      }
    } catch (e) {
      debugPrint("Error toggling bookmark: $e");
      // Revert the state if the database call failed
      if (mounted) {
        setState(() => _isBookmarked = !_isBookmarked);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Could not update bookmark.')),
        );
      }
    }
  }

  Future<void> _launchURL(String name) async {
    final encodedName = Uri.encodeComponent(name);
    final urlString =
        'https://www.google.com/search?q=more+about+$encodedName';

    final Uri url = Uri.parse(urlString);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.snakeName),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.snakeName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              icon: _isLoading
                  ? const SizedBox( // Show a small spinner while loading
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
              label: Text(_isBookmarked ? 'Bookmarked' : 'Bookmark'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              // Disable the button while checking the status
              onPressed: _isLoading ? null : _toggleBookmark,
            ),
            // ------------------------------------------

            const SizedBox(height: 16),

            ElevatedButton.icon(
              icon: const Icon(Icons.public),
              label: const Text('Find out more'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                _launchURL(widget.snakeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}