import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/authors.dart';
import '../providers/authors_provider.dart';

class ManageItemScreen extends StatefulWidget {
  const ManageItemScreen(
      {Key? key, required this.title, required this.buttonText})
      : super(key: key);
  final String title;
  final String buttonText;

  @override
  State<ManageItemScreen> createState() => _ManageItemScreenState();
}

class _ManageItemScreenState extends State<ManageItemScreen> {
  Authors? selectedAuthor;
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
    var routeSettings = ModalRoute.of(context)!.settings;
    if (routeSettings.arguments != null) {
      selectedAuthor = routeSettings.arguments as Authors;
      _nameController.text = selectedAuthor!.name;
      _sortController.text = selectedAuthor!.sort;
      _linkController.text = selectedAuthor!.link;
    } else {
      selectedAuthor = null;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          selectedAuthor != null
              ? IconButton(
                  tooltip: 'Delete book',
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<AuthorsProvider>(context, listen: false)
                        .delete(selectedAuthor!);
                    Navigator.pop(context);
                  },
                )
              : Container(),
        ],
      ),
      body: ListView(
        children: [
          textController('Name', _nameController),
          textController('Sort', _sortController),
          textController('Link', _linkController),
          ElevatedButton(
              onPressed: () {
                Authors author = Authors(
                    id: selectedAuthor?.id,
                    name: _nameController.text,
                    sort: _sortController.text,
                    link: _linkController.text);
                if (selectedAuthor != null && selectedAuthor != author) {
                  Provider.of<AuthorsProvider>(context, listen: false)
                      .update(author, selectedAuthor!.id!);
                } else if (selectedAuthor == null) {
                  Provider.of<AuthorsProvider>(context, listen: false)
                      .insert(author);
                }
                //context.read<TodoProvider>().insertTodo(todo);
                clerControllers();
                Navigator.pop(context);
              },
              child: Text(widget.buttonText))
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
