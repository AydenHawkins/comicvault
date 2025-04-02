import 'package:comicvault/models/comic_issue.dart';

class ComicSeries {
  final int id;
  final String series;
  final int yearBegan;
  final int volume;
  final int issueCount;
  final String modified;
  List<ComicIssue> issues;

  ComicSeries({
    required this.id,
    required this.series,
    required this.yearBegan,
    required this.volume,
    required this.issueCount,
    required this.modified,
    this.issues = const [],
  });

  factory ComicSeries.fromMap(Map<String, dynamic> map) {
    return ComicSeries(
      id: map['id'],
      series: map['series'],
      yearBegan: map['year_began'],
      volume: map['volume'],
      issueCount: map['issue_count'],
      modified: map['modified'],
      issues: [],
    );
  }

  void setIssues(List<ComicIssue> issueList) {
    issues = issueList;
  }
}
