import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
String userEmial = "";

getUserDetails()async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();

setState(() {
  userEmial = prefs.getString("email")!;
  print(userEmial);
});
}

  CollectionReference products =
      FirebaseFirestore.instance.collection("products");
  _deleteProduct(String productId) async {
    try {
      await products.doc(productId).delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Product deleted")));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Can't detele product right now...!")));
    }
  }

  void _editProduct(String id, String title, double price, String description,
      String image) async {
    TextEditingController titleController = TextEditingController(text: title);
    TextEditingController priceController =
        TextEditingController(text: price.toString());
    TextEditingController desController =
        TextEditingController(text: description);
    TextEditingController imageController = TextEditingController(text: image);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Editing $title"),
            content: Column(
              mainAxisSize:MainAxisSize.min, 
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: "Price"),
                ),
                TextField(
                  controller: desController,
                  decoration: InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: imageController,
                  decoration: InputDecoration(labelText: "Image"),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      await products.doc(id).update({
                        'title': titleController.text,
                        'price': double.parse(priceController.text),
                        'description': desController.text,
                        'image': imageController.text,
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Product updatetd")));
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Can't update product right now...!"),
                      ));
                    }
                  },
                  child: Text("Update")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
            ],
          );
        });
  }

  @override
initState(){
  getUserDetails();
    print(userEmial);

}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
        userEmial !=null ? Text(userEmial): Text("no"),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, "/add");
              }),
              IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setBool("isLoggedIn", false);
prefs.remove("email");



                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
              })
        ],
      ),
      body: Center(
        child: StreamBuilder(
          stream: products.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data!.docs[index];

                      return ListTile(
                          title: Text(snapshot.data!.docs[index]['title']),
                          subtitle:
                              Text(snapshot.data!.docs[index]['description']),
                          leading: CircleAvatar(
                            child: Image.network(
                                snapshot.data!.docs[index]['image'],
                                height: 50),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(snapshot.data!.docs[index]['price']
                                  .toString()),
                              IconButton(
                                onPressed: () {
                                  _editProduct(
                                      product.id,
                                      product['title'],
                                      product['price'],
                                      product['description'],
                                      product['image']);
                                },
                                icon: Icon(Icons.edit,color: const Color.fromARGB(255, 81, 150, 224),),
                              ),
                              IconButton(
                                  onPressed: () {
                                    _deleteProduct(
                                        snapshot.data!.docs[index].id);
                                  },
                                  icon: Icon(Icons.delete,color: const Color.fromARGB(255, 225, 74, 71),)),
                            ],
                          ));
                    });
              } else {
                return Text("no data");
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
