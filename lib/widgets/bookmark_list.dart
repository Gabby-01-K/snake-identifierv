// lib/widgets/bookmark_list.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/details_page.dart';

class BookmarkList extends StatelessWidget {
  const BookmarkList({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // If the user is logged out, show nothing
      return Container();
    }

    // Reference to the user's bookmark collection
    final bookmarksStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .orderBy('timestamp', descending: true) // Show newest first
        .snapshots(); // This returns a Stream

    return StreamBuilder<QuerySnapshot>(
      stream: bookmarksStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Could not load bookmarks.'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'You have not bookmarked any snakes yet.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Data acquired, build a list
        final bookmarks = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true, // Important for nesting in a Column
          physics: const NeverScrollableScrollPhysics(), // Also for nesting
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            final doc = bookmarks[index];
            final snakeName = doc['name'] as String? ?? 'Unknown Snake';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(snakeName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // When tapped, go to the DetailsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(snakeName: snakeName),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}