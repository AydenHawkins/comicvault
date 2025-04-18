import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comicvault/models/comic_issue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:comicvault/custom_widgets/sort_button.dart';
import 'package:comicvault/models/sort_option.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final comicsRef = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Comics');

  SortOption _selectedSort = SortOption.alphabetical;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: comicsRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("Add a comic to get started!")),
          );
        }

        var comicDocs = snapshot.data!.docs;

        List<ComicIssue> comics =
            comicDocs
                .map(
                  (doc) => ComicIssue(
                    id: doc['id'],
                    seriesName: doc['seriesName'],
                    seriesVolume: doc['seriesVolume'],
                    seriesYearBegan: doc['seriesYearBegan'],
                    issueNumber: doc['issueNumber'],
                    issueTitle: doc['issueTitle'],
                    coverDate: doc['coverDate'],
                    imageUrl: doc['imageURL'],
                    coverHash: doc['coverHash'],
                    modified: doc['modified'],
                  ),
                )
                .toList();

        // Apply search filter
        if (_searchQuery.isNotEmpty) {
          comics =
              comics.where((comic) {
                final query = _searchQuery.toLowerCase();
                return comic.issueTitle.toLowerCase().contains(query) ||
                    comic.seriesName.toLowerCase().contains(query);
              }).toList();
        }

        // Apply sorting
        if (_selectedSort == SortOption.alphabetical) {
          comics.sort(
            (a, b) => a.issueTitle.toLowerCase().compareTo(
              b.issueTitle.toLowerCase(),
            ),
          );
        } else if (_selectedSort == SortOption.releaseDate) {
          comics.sort((a, b) => b.coverDate.compareTo(a.coverDate));
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Collection")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search comics...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Sort Dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SortButton(
                      selectedSort: _selectedSort,
                      onSortSelected: (SortOption option) {
                        setState(() {
                          _selectedSort = option;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Comic Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.65,
                          mainAxisExtent: 320,
                        ),
                    itemCount: comics.length,
                    itemBuilder: (context, index) {
                      final issue = comics[index];
                      return _buildIssueCard(issue, comicDocs, index);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIssueCard(ComicIssue issue, var comicDocs, int index) {
    return GestureDetector(
      onTap: () => deleteComic(comicDocs, index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Image.network(issue.imageUrl, fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    issue.issueTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteComic(var comicDocs, int index) async {
    try {
      QueryDocumentSnapshot comic = comicDocs[index];
      await comicsRef.doc(comic.id).delete();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Deleted The Comic.")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong!")));
    }
  }
}
