import "package:book_stash/pages/books.dart";
import "package:book_stash/service/auth_service.dart";
import "package:book_stash/service/database.dart";
import "package:book_stash/utils/toast.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  
TextEditingController titleController=TextEditingController();
TextEditingController priceController=TextEditingController();
TextEditingController authorController=TextEditingController();



Stream? booksStream;
dynamic getInfoInit()    async{
  booksStream = await DatabaseHelper().getAllBooksInfo();
  setState(() {
    
  });
}
@override
void initState(){
    getInfoInit();
  super.initState();
  }



Widget allBooksInfo(){

  return StreamBuilder( builder: (context,AsyncSnapshot snapshot){
    return snapshot.hasData? ListView.builder(
      itemCount: snapshot.data.docs.length,
    itemBuilder: (context, index) {
      DocumentSnapshot documentSnapshot=snapshot.data.docs[index];
      return  Container(
        margin: EdgeInsets.only(bottom:21.0),
        child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width, 
                decoration: BoxDecoration(color: const Color.fromARGB(255, 34, 54, 134),
                borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.book_rounded,size:40,color: const Color.fromARGB(255, 64, 156, 80)),
                        
                        InkWell(
                          onTap: (){
                            titleController.text=documentSnapshot['Title'];
                            priceController.text=documentSnapshot['price'];
                            authorController.text=documentSnapshot['Author'];

                            editBook(documentSnapshot['Id']);

                          },
                          child: Icon(Icons.edit_document,size:40,color: const Color.fromARGB(255, 197, 116, 50))),
                          InkWell(
                            onTap:(){

                             showDeleteConfirmationDialog(context, documentSnapshot["Id"]);
                            },
                            
                            child: Icon(Icons.delete_forever,size:45,color:Colors.greenAccent,)),
                        
                        
                        
                      ],
                    ),
                    SizedBox(height:20),
                    Text('Title: ${documentSnapshot["Title"]}',style :TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
                    Text('price: ${documentSnapshot["price"]}',style :TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
                    Text('Author: ${documentSnapshot["Author"]}',style :TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
        
                  ],
                ),
              ),
            ),
      );
    },
    ):Container();
  },stream: booksStream,);
} 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BookStash"),
      actions: [IconButton(onPressed: ()async{

        await AuthServiceHelper.logout();
        Navigator.pushReplacementNamed(context, '/login');

      }, icon: Icon(Icons.logout_rounded))],
      ),
      body: Container(
        margin:EdgeInsets.only(left:10.0,right: 10,top: 25),
        child: Column(children: [
           Expanded(child:  allBooksInfo()),
         
          

        ],),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          Navigator.push(context, MaterialPageRoute(builder: 
          (context)=>Books()
          ),);

      },
      child: Icon(Icons.add),),
    );
  }


Future editBook(String id){


  return showDialog(
    context: context, 
    builder: (context)=> AlertDialog(
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
           mainAxisAlignment:MainAxisAlignment.spaceBetween, 
          
          children: [
          Text("Edit a book",style:TextStyle(color:Colors.deepPurple,fontSize:20.0 , fontWeight:FontWeight.bold),),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.cancel_outlined,size:35,color: Colors.deepPurple,)
            ),


        ],),
        Divider(height: 10,color: Colors.deepPurple,thickness: 5,),
        SizedBox(height: 10.0,),

        
          Text('Title',style:TextStyle(color: Colors.black,fontSize: 20),),
          SizedBox(height: 10.0,),
          Container(
            padding:EdgeInsets.only(left: 12.0),
            decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: titleController ,
              decoration: InputDecoration(border: InputBorder.none),

            
            ),
          ),

           Text('Price',style:TextStyle(color: Colors.black,fontSize: 20),),
          SizedBox(height: 10.0,),
          Container(
            padding:EdgeInsets.only(left: 12.0),
            decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: priceController,
              decoration: InputDecoration(border: InputBorder.none),

            
            ),
          ),
         
          Text('Author',style:TextStyle(color: Colors.black,fontSize: 20),),
          SizedBox(height: 10.0,),
          Container(
            padding:EdgeInsets.only(left: 12.0),
            decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: authorController,
              decoration: InputDecoration(border: InputBorder.none),

            
            ),
          ),
          SizedBox(height: 20.0,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(onPressed:()async{
                Map<String,dynamic> updateDetails={
                   "Title":titleController.text,
                   "price":priceController.text,
                   "Author":authorController.text,
                   "Id":id,

                  
                };
                await DatabaseHelper().updateBook(id, updateDetails).then((value){
                  Message.show(message: "Sucessfully updated" );
                  Navigator.pop(context);
                });



              }, child: Text("update")),
              OutlinedButton(onPressed:(){
                Navigator.pop(context);

              }, child: Text("cancel")),
            ],
          )

         
      ],

    ),
  ));
}
void showDeleteConfirmationDialog(BuildContext context ,String id )
{
  showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      title:Text('confirm Deletion'),
      content: Text('are u sure u wat to delete?'),
      actions: [
        TextButton(onPressed: ()async{
          await DatabaseHelper().deleteBook(id);
          Navigator.pop(context);
          

        },
         child: Text('yes'),
         ),
         TextButton(onPressed: (){
          Navigator.of(context).pop(false);

        },
         child: Text('no'),
         ),
      ],
    );
  });
}


}














// import "package:book_stash/pages/books.dart";
// import "package:book_stash/service/database.dart";
// import "package:cloud_firestore/cloud_firestore.dart";
// import "package:flutter/material.dart";

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   TextEditingController titleController = TextEditingController();
//   TextEditingController priceController = TextEditingController();
//   TextEditingController authorController = TextEditingController();

//   Stream? booksStream;

//   dynamic getInfoInit() async {
//     booksStream = await DatabaseHelper().getAllBooksInfo();
//     setState(() {});
//   }

//   @override
//   void initState() {
//     getInfoInit();
//     super.initState();
//   }

//   Widget allBooksInfo() {
//     return StreamBuilder(
//       builder: (context, AsyncSnapshot snapshot) {
//         return snapshot.hasData
//             ? ListView.builder(
//                 itemCount: snapshot.data.docs.length,
//                 itemBuilder: (context, index) {
//                   DocumentSnapshot documentSnapshot =
//                       snapshot.data.docs[index];
//                   return Container(
//                     margin: EdgeInsets.only(bottom: 21.0),
//                     child: Material(
//                       elevation: 5.0,
//                       borderRadius: BorderRadius.circular(20),
//                       child: Container(
//                         padding: EdgeInsets.all(20),
//                         width: MediaQuery.of(context).size.width,
//                         decoration: BoxDecoration(
//                             color: const Color.fromARGB(255, 34, 54, 134),
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Icon(Icons.book_rounded,
//                                     size: 40,
//                                     color: const Color.fromARGB(
//                                         255, 64, 156, 80)),
//                                 InkWell(
//                                   onTap: () {
//                                     // Open edit book dialog
//                                     editBook(
//                                       context,
//                                       documentSnapshot.id,
//                                       documentSnapshot["Title"],
//                                       documentSnapshot["price"],
//                                       documentSnapshot["Author"],
//                                     );
//                                   },
//                                   child: Icon(Icons.edit_document,
//                                       size: 40,
//                                       color: const Color.fromARGB(
//                                           255, 197, 116, 50)),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 20),
//                             Text(
//                               'Title: ${documentSnapshot["Title"]}',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               'Price: ${documentSnapshot["price"]}',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               'Author: ${documentSnapshot["Author"]}',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               )
//             : Container();
//       },
//       stream: booksStream,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("BookStash"),
//       ),
//       body: Container(
//         margin: EdgeInsets.only(left: 10.0, right: 10, top: 25),
//         child: Column(
//           children: [
//             Expanded(child: allBooksInfo()),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => Books()),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   // Edit book dialog
//   Future<void> editBook(BuildContext context, String id, String currentTitle,
//       String currentPrice, String currentAuthor) async {
//     // Set the current book data in the controllers
//     titleController.text = currentTitle;
//     priceController.text = currentPrice;
//     authorController.text = currentAuthor;

//     // Show the dialog
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           "Edit a book",
//           style: TextStyle(color: Colors.deepPurple, fontSize: 20.0),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: InputDecoration(
//                 labelText: 'Title',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: priceController,
//               decoration: InputDecoration(
//                 labelText: 'Price',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: authorController,
//               decoration: InputDecoration(
//                 labelText: 'Author',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Close the dialog
//                   },
//                   child: Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     await saveEditedBook(id);
//                     Navigator.pop(context); // Close the dialog after saving
//                   },
//                   child: Text('Save'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Save edited book to Firestore
//   Future<void> saveEditedBook(String id) async {
//     try {
//       await FirebaseFirestore.instance.collection('books').doc(id).update({
//         'Title': titleController.text,
//         'price': priceController.text,
//         'Author': authorController.text,
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Book updated successfully')),
//       );
//     } catch (e) {
//       print("Error updating book: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error updating book')),
//       );
//     }
//   }
// }
