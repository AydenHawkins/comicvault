import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:comicvault/models/comic_issue.dart';
import 'package:comicvault/models/comic_series.dart';

class ApiService {
  static const String _baseUrl = 'https://metron.cloud/api';
  static const String _authToken = 'Basic QXlkZW5IYXdraW5zOkx5c3NhYmVhcjE3IQ==';

  // Helper method to handle the HTTP request and parse the response
  Future<List<T>> _search<T>(
    String endpoint,
    String queryParam, {
    required String queryValue,
    Map<String, String>? filters,
  }) async {
    String urlString = '$_baseUrl/$endpoint/?$queryParam=$queryValue';

    // If filters are provided, add them to the URL
    if (filters != null && filters.isNotEmpty) {
      filters.forEach((key, value) {
        urlString += '&$key=$value';
      });
    }

    final url = Uri.parse(urlString);

    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': _authToken,
        'Cookie': 'sessionid=123456',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.containsKey('results') && data['results'] != null) {
        return List<T>.from(
          data['results'].map((item) {
            if (T == ComicIssue) {
              return ComicIssue.fromMap(item) as T;
            } else if (T == ComicSeries) {
              return ComicSeries.fromMap(item) as T;
            } else {
              throw Exception('Unknown type for parsing response');
            }
          }),
        );
      } else {
        throw Exception('No results found in the response');
      }
    } else {
      throw Exception(
        'Failed to load data: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // Search comic issues by series name, issue number, cover year, and series year began
  Future<List<ComicIssue>> searchIssues(
    String seriesName, {
    String? coverYear,
    String? issueNumber,
    String? seriesYearBegan,
  }) async {
    Map<String, String> filters = {};

    if (coverYear != null) filters['cover_year'] = coverYear;
    if (issueNumber != null) filters['number'] = issueNumber;
    if (seriesYearBegan != null) filters['series_year_began'] = seriesYearBegan;

    return await _search<ComicIssue>(
      'issue',
      'series_name',
      queryValue: seriesName,
      filters: filters,
    );
  }

  // Search comic series by name, year began, and year end
  Future<List<ComicSeries>> searchSeries(
    String seriesName, {
    String? yearBegan,
    String? yearEnd,
  }) async {
    Map<String, String> filters = {};

    if (yearBegan != null) filters['year_began'] = yearBegan;
    if (yearEnd != null) filters['year_end'] = yearEnd;

    return await _search<ComicSeries>(
      'series',
      'name',
      queryValue: seriesName,
      filters: filters,
    );
  }

  Future<List<ComicIssue>> fetchSeriesIssueList(int seriesId) async {
    String urlString = '$_baseUrl/series/$seriesId/issue_list/';

    final url = Uri.parse(urlString);

    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': _authToken,
        'Cookie': 'sessionid=123456',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.containsKey('results') && data['results'] != null) {
        return List<ComicIssue>.from(
          data['results'].map((item) => ComicIssue.fromMap(item)),
        );
      } else {
        throw Exception('No results found in the response');
      }
    } else {
      throw Exception(
        'Failed to load data: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<void> updateComicSeriesWithIssues(ComicSeries series) async {
    try {
      List<ComicIssue> issues = await fetchSeriesIssueList(series.id);

      series.setIssues(issues);
    } catch (e) {
      throw Exception('Failed to update issues: $e');
    }
  }
}
