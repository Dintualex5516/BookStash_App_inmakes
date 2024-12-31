import "package:cloud_firestore/cloud_firestore.dart";

class DatabaseHelper{
Future addBookDetails(Map<String,dynamic> bookInfoMap,String id)async{
  return await FirebaseFirestore.instance.collection("books").doc(id).set(bookInfoMap);
}



// get all books nfo

Future<Stream<QuerySnapshot>> getAllBooksInfo() async {
  return await FirebaseFirestore.instance.collection("books").snapshots();

}

// update

Future updateBook(String id, Map<String,dynamic>updateDetails)async{
  return await FirebaseFirestore.instance.collection("books").doc(id).update(updateDetails);
}


Future deleteBook(String id)async{
  return await FirebaseFirestore.instance.collection("books").doc(id).delete();
}


}