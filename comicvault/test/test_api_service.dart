import 'package:flutter_test/flutter_test.dart';
import 'package:comicvault/services/api_service.dart';

void main() {
  final apiService = ApiService();

  test('Search for Batman issue #404', () async {
    final comics = await apiService.searchIssues('Batman', '404');
    expect(comics, isNotEmpty);
    expect(comics.first.seriesName, equals('Batman'));
  });
}
