import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/App-constant.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _titleController = TextEditingController();
  bool isLoading = false;

  Future<void> _uploadCategory() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Category title is required"),
      ));
      return;
    }

    setState(() => isLoading = true);

    try {
      final docRef = FirebaseFirestore.instance.collection('categories').doc();

      await docRef.set({
        'categoryId': docRef.id,
        'categoryName': title,
        'categoryImage': '', // you will paste image URL here later
        'timestamp': Timestamp.now(),
      });

      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Category uploaded"),
      ));
      Navigator.pop(context);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Category")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Category Title"),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _uploadCategory,
              child: Text("Upload Category",style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(backgroundColor: Appconstant.maincolor),
            ),
          ],
        ),
      ),
    );
  }
}
