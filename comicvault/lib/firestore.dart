//needs to be tested before it's used, might not work (probably doesn't work)
class Firestore {
  final String collectionName = "users";
  final String fileName = "user";

  static add_comic(
    String user,
    String title,
    String publisher,
    int issue,
    String release,
  ) {
    //firebase docs just give this line when showing how to initialize a database, not sure if it just works or if I'm missing something
    //probably the latter
    db = FirebaseFirestore.instance;

    final comic = {
      "Title": title,
      "Publiser": publisher,
      "issueNumber": issue,
      "releaseDate": release,
    };

    db
        .collection(collectionName)
        .doc(fileName)
        .set(comic, SetOptions(merge: true))
        .onError((e, _) => print("Error writing document: $e"));
  }
}
