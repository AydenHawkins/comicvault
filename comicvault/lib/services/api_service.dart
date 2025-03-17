import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:comicvault/models/comic_issue.dart';

class ApiService {
  static const String _baseUrl = 'https://metron.cloud/api';
  static const String _authToken = 'Basic QXlkZW5IYXdraW5zOkx5c3NhYmVhcjE3IQ==';

  Future<List<ComicIssue>> searchIssues(
    String seriesName,
    String? issueNumber,
  ) async {
    String urlString = '$_baseUrl/issue/?series_name=$seriesName';

    if (issueNumber != null && issueNumber.isNotEmpty) {
      urlString += '&number=$issueNumber';
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
        return List<ComicIssue>.from(
          data['results'].map((issue) => ComicIssue.fromMap(issue)),
        );
      } else {
        throw Exception('No results found in the response');
      }
    } else {
      throw Exception(
        'Failed to load comics: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
