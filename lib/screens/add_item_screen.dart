import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/authors.dart';
import '../providers/authors_provider.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sortController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _sortController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: ListView(
        children: [
          textController('Name', _nameController),
          textController('Sort', _sortController),
          textController('Link', _linkController),
          ElevatedButton(
              onPressed: () {
                Authors author = Authors(
                    name: _nameController.text,
                    sort: _sortController.text,
                    link: _linkController.text);
                Provider.of<AuthorsProvider>(context, listen: false)
                    .insert(author);
                //context.read<TodoProvider>().insertTodo(todo);
                clerControllers();
                Navigator.pop(context);
              },
              child: const Text('Insert'))
        ],
      ),
    );
  }

  void clerControllers() {
    _nameController.clear();
    _sortController.clear();
    _linkController.clear();
  }

  Widget textController(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(), hintText: title),
      ),
    );
  }
}
