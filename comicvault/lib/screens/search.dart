import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comicvault/screens/series_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:comicvault/services/api_service.dart';
import 'package:comicvault/models/comic_issue.dart';
import 'package:comicvault/models/comic_series.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();

  String _searchType = 'Issue';
  final TextEditingController _searchController = TextEditingController();
  String? _searchQuery = '';

  // Filter variables
  String? coverYear, issueNumber, seriesYearBegan, yearBegan, yearEnd;

  List<dynamic> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SegmentedButton<String>(
                segments: const <ButtonSegment<String>>[
                  ButtonSegment<String>(value: 'Issue', label: Text('Issue')),
                  ButtonSegment<String>(value: 'Series', label: Text('Series')),
                ],
                selected: <String>{_searchType},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _searchType = newSelection.first;
                    _searchController.clear();
                    _searchQuery = '';
                    _searchResults.clear();
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText:
                          _searchType == 'Series'
                              ? 'Enter series name'
                              : 'Enter issue title',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.filter_alt),
                        onPressed: () {
                          _showFilterBottomSheet(context);
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _performSearch();
                      }
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child:
                  _searchType == 'Series'
                      ? _buildSeriesResults()
                      : _buildIssueResults(),
            ),
          ],
        ),
      ),
    );
  }

  // Show the Bottom Sheet for Filters
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchType == 'Issue') ...[
                const Text('Issue Filters'),
                TextField(
                  decoration: const InputDecoration(labelText: 'Cover Year'),
                  onChanged: (value) => coverYear = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Issue Number'),
                  onChanged: (value) => issueNumber = value,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Series Year Began',
                  ),
                  onChanged: (value) => seriesYearBegan = value,
                ),
              ] else ...[
                const Text('Series Filters'),
                TextField(
                  decoration: const InputDecoration(labelText: 'Year Began'),
                  onChanged: (value) => yearBegan = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Year End'),
                  onChanged: (value) => yearEnd = value,
                ),
              ],
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _performSearch();
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Perform the search based on the selected category and filters
  void _performSearch() async {
    List<dynamic> results = [];

    try {
      if (_searchType == 'Series') {
        results = await _apiService.searchSeries(
          _searchQuery!,
          yearBegan: yearBegan,
          yearEnd: yearEnd,
        );

        for (var series in results) {
          if (series is ComicSeries) {
            await _apiService.updateComicSeriesWithIssues(series);
          }
        }
      } else {
        results = await _apiService.searchIssues(
          _searchQuery!,
          coverYear: coverYear,
          issueNumber: issueNumber,
          seriesYearBegan: seriesYearBegan,
        );
      }

      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      _clearFilters();
    }
  }

  void _clearFilters() {
    setState(() {
      coverYear = null;
      issueNumber = null;
      seriesYearBegan = null;
      yearBegan = null;
      yearEnd = null;
    });
  }

  Widget _buildSeriesResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final series = _searchResults[index] as ComicSeries;
        return _buildSeriesRow(series);
      },
    );
  }

  Widget _buildSeriesRow(ComicSeries series) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  series.series,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeriesDetailScreen(series: series),
                    ),
                  );
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: series.issues.length > 8 ? 8 : series.issues.length,
            itemBuilder: (context, issueIndex) {
              final issue = series.issues[issueIndex];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              issue.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          issue.issueNumber,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildIssueResults() {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.65,
        mainAxisExtent: 320,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final issue = _searchResults[index] as ComicIssue;
        return _buildIssueCard(issue);
      },
    );
  }

  Widget _buildIssueCard(ComicIssue issue) {
    return GestureDetector(
      onTap: () {
        print("Tapped on $issue");
        addComic(issue);
      },
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
              padding: const EdgeInsets.all(8.0),
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

  void addComic(ComicIssue comic) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Comics')
          .add(comic.toMap());

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Added Your Comic!")));
    } on FirebaseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong!")));
    }
  }
}
