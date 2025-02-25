import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  CollectionReference products = FirebaseFirestore.instance.collection("products"); // <-- Add this here!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new product"),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, "/add");
          }, icon: Icon(Icons.add))
        ],
      ),
      body:
       Padding(
         padding: const EdgeInsets.all(8.0),
         child: Center(
          child: ListView(
         children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: "Title",
            hintText: "Enter the title of the product"
          ),
        ),
        TextFormField(
          controller: desController,
          decoration: InputDecoration(
           labelText: "Description",
            hintText: "Enter the description of the product"
          ),
        ),
        TextFormField(
          controller: priceController,
          decoration: InputDecoration(
            labelText: "Price",
            hintText: "Enter the price of the product"
          ),
        ),
        TextFormField(
          controller: imageController,
          decoration: InputDecoration(
            labelText: "Image Url",
            hintText: "Enter the Image Url of the product"
          ),
        ),
        ElevatedButton(onPressed: 
        (){
          //Add product in database
          products.add({
            'title': titleController.text,
'description': desController.text,
'price': double.parse(priceController.text),
'image': imageController.text,
        }).then((value) =>{
         titleController.clear(),
         desController.clear(),
         priceController.clear(),
         imageController.clear(),
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("products added succesfully"),
         ))}).catchError((error)=>{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("products added succesfully")), )
         });
        }, 
         child: Text("Add Product")),
         ],
          ),
               ),
       ),
    );
  }
}