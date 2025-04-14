class ComicIssue {
  final int id;
  final String seriesName;
  final int seriesVolume;
  final int seriesYearBegan;
  final String issueNumber;
  final String issueTitle;
  final String coverDate;
  final String? storeDate;
  final String imageUrl;
  final String coverHash;
  final String modified;

  ComicIssue({
    required this.id,
    required this.seriesName,
    required this.seriesVolume,
    required this.seriesYearBegan,
    required this.issueNumber,
    required this.issueTitle,
    required this.coverDate,
    this.storeDate,
    required this.imageUrl,
    required this.coverHash,
    required this.modified,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'seriesName': seriesName,
      'seriesVolume': seriesVolume,
      'seriesYearBegan': seriesYearBegan,
      'issueNumber': issueNumber,
      'issueTitle': issueTitle,
      'coverDate': coverDate,
      'storeDate': storeDate,
      'imageURL': imageUrl,
      'coverHash': coverHash,
      'modified': modified,
    };
  }

  factory ComicIssue.fromMap(Map<String, dynamic> map) {
    return ComicIssue(
      id: map['id'],
      seriesName: map['series']['name'],
      seriesVolume: map['series']['volume'],
      seriesYearBegan: map['series']['year_began'],
      issueNumber: map['number'],
      issueTitle: map['issue'],
      coverDate: map['cover_date'],
      storeDate: map['store_date'],
      imageUrl: map['image'],
      coverHash: map['cover_hash'],
      modified: map['modified'],
    );
  }
}
