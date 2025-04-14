//needs to be tested before it's used, might not work (probably doesn't work)
class Firestore {
  final String userCollection = "users";
  final String comicCollection = "comics";

  void add_comic(
    String user,
    int id,
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
      "issueNum": issue,
      "releaseDate": release,
    };

    db
        .collection(userCollection)
        .doc(user)
        .collection(comicCollection)
        .doc(id)
        .set(comic, SetOptions(merge: true))
        .onError((e, _) => print("Error writing document: $e"));
  }

  //takes a given comic to be removed from a specific user's file
  void remove_comic(String user, int id) {
    db = FirebaseFirestore.instance;

    final document = db
        .collection(userCollection)
        .doc(user)
        .collection(comicCollection)
        .doc(id)
        .delete()
        .then(onError: (e) => print("Error deleting comic: $e"));
  }
}
