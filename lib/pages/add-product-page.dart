import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/App-constant.dart';

class AddProductPage extends StatefulWidget {
  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String? selectedCategoryId;
  String? selectedCategoryName;

  bool isLoading = false;
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final snapshot = await FirebaseFirestore.instance.collection('categories').get();
    final List<Map<String, dynamic>> loaded = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['categoryName'],
      };
    }).toList();

    setState(() {
      categories = loaded;
    });
  }

  Future<void> _uploadProduct() async {
    final title = titleController.text.trim();
    final price = priceController.text.trim();

    if (title.isEmpty || price.isEmpty || selectedCategoryId == null || selectedCategoryName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields and select a category.")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final docRef = FirebaseFirestore.instance.collection('products').doc();

      final productData = {
        'productId': docRef.id,
        'productName': title,
        'productPrice': int.parse(price),
        'productImage': "", // manually added later
        'categoryId': selectedCategoryId,
        'categoryName': selectedCategoryName,
        'productRate': 0.0, // default rating
        'timestamp': Timestamp.now(),
      };

      // Save in global 'products' collection
      await docRef.set(productData);

      // Also save in selected category's subcollection
      final categoryRef = FirebaseFirestore.instance
          .collection('categories')
          .doc(selectedCategoryId)
          .collection('products')
          .doc(docRef.id);

      await categoryRef.set(productData);

      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product uploaded successfully.")),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Product Title"),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Price (Rs)"),
              ),
              SizedBox(height: 20),
              categories.isEmpty
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Select Category"),
                items: categories.map((cat) {
                  return DropdownMenuItem<String>(
                    value: cat['id'],
                    child: Text(cat['name']),
                  );
                }).toList(),
                onChanged: (val) {
                  final selected = categories.firstWhere((cat) => cat['id'] == val);
                  setState(() {
                    selectedCategoryId = selected['id'];
                    selectedCategoryName = selected['name'];
                  });
                },
                value: selectedCategoryId,
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _uploadProduct,
                child: Text("Upload Product",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(backgroundColor: Appconstant.maincolor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
