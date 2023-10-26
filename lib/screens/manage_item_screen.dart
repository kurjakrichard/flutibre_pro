import 'package:flutibre/repository/database_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/authors.dart';
import '../model/books.dart';
import '../providers/booklist_provider.dart';

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
  Books? selectedItem;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _sortController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _sortController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var routeSettings = ModalRoute.of(context)!.settings;
    if (routeSettings.arguments != null) {
      selectedItem = routeSettings.arguments as Books;
      _titleController.text = selectedItem!.title;
      _sortController.text = selectedItem!.sort;
      _authorController.text = selectedItem!.author_sort;
    } else {
      selectedItem = null;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          selectedItem != null
              ? IconButton(
                  tooltip: 'Delete book',
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<BooksProvider>(context, listen: false)
                        .delete(selectedItem!.id!);
                    Navigator.pop(context);
                  },
                )
              : Container(),
        ],
      ),
      body: ListView(
        children: [
          textController('Title', _titleController),
          textController('Sort', _sortController),
          textController('Author', _authorController),
          ElevatedButton(
              onPressed: () {
                DateTime addDateTime = DateTime.now();
                String authorSort = sortingAuthor(_authorController.text);
                Books book = Books(
                    id: selectedItem?.id,
                    title: _titleController.text,
                    last_modified:
                        '${addDateTime.toString().substring(0, 19)}+00:00',
                    sort: _sortController.text,
                    author_sort: authorSort,
                    timestamp:
                        '${addDateTime.toString().substring(0, 19)}+00:00');
                if (selectedItem != null && selectedItem != book) {
                  Provider.of<BooksProvider>(context, listen: false).update(
                      book: book,
                      author: Authors(
                          name: 'Brandon Sanderson',
                          sort: 'Sanderson, Brandon'),
                      id: selectedItem!.id!);
                } else if (selectedItem == null) {
                  Authors author =
                      Authors(name: _authorController.text, sort: authorSort);
                  Provider.of<BooksProvider>(context, listen: false)
                      .insert(book: book, author: author);
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

  String sortingAuthor(String author) {
    List<String> authorSplit = author.split(' ');
    String authorSort = authorSplit[authorSplit.length - 1];
    authorSplit.removeLast();
    for (var item in authorSplit) {
      authorSort = authorSort + ', ' + item;
    }
    return authorSort;
  }

  void clerControllers() {
    _titleController.clear();
    _sortController.clear();
    _authorController.clear();
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
