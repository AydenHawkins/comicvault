import 'package:flutter/material.dart';
import 'package:comicvault/services/api_service.dart';
import 'package:comicvault/models/comic_issue.dart';
import 'package:comicvault/custom_widgets/comic_card.dart';

class SearchScreenv2 extends StatefulWidget {
  const SearchScreenv2({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreenv2> {
  final ApiService _apiService = ApiService();
  String _selectedCategory = 'issue';
  final TextEditingController _seriesController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();
  List<ComicIssue> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final seriesName = _seriesController.text;
      final issueNumber = _issueController.text;

      if (seriesName.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please enter the series name.';
        });
        return;
      }

      // Call different API search methods based on the category
      List<ComicIssue> results;
      switch (_selectedCategory) {
        case 'issue':
          results = await _apiService.searchIssues(seriesName, issueNumber);
          break;
        // case 'character':
        //   results = await _apiService.searchCharacters(seriesName);
        //   break;
        // case 'series':
        //   results = await _apiService.searchSeries(seriesName);
        //   break;
        default:
          results = [];
      }

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching results: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comic Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items:
                  <String>[
                    'issue',
                    'character',
                    'series',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.capitalize()),
                    );
                  }).toList(),
            ),

            SizedBox(height: 16),

            TextField(
              controller: _seriesController,
              decoration: InputDecoration(
                labelText: 'Series Name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _performSearch(),
            ),

            SizedBox(height: 16),

            TextField(
              controller: _issueController,
              decoration: InputDecoration(
                labelText: 'Issue Number',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _performSearch(),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 16),

            ElevatedButton(onPressed: _performSearch, child: Text('Search')),

            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
              ),

            if (_isLoading) CircularProgressIndicator(),

            Expanded(
              child:
                  _searchResults.isEmpty && !_isLoading
                      ? Center(child: Text('No results found'))
                      : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.6,
                        ),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final comic = _searchResults[index];
                          return ComicCardV2(comic: comic);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return isEmpty ? this : this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
