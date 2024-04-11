import 'package:flutibre/model/booklist_item.dart';
import 'package:flutibre/model/books.dart';
import 'package:flutibre/model/authors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booklist_provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key, required this.title, required this.buttonText})
      : super(key: key);
  final String title;
  final String buttonText;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  BookListItem? oldBookListItem;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var routeSettings = ModalRoute.of(context)!.settings;
    final route = ModalRoute.of(context)?.settings.name;

    oldBookListItem = routeSettings.arguments as BookListItem;
    _titleController.text = oldBookListItem?.title ?? '';
    _authorController.text = oldBookListItem?.authors ?? '';
    _commentController.text = oldBookListItem?.comments ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          route != '/addpage'
              ? IconButton(
                  tooltip: 'Delete book',
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<BooksListProvider>(context, listen: false)
                        .delete(oldBookListItem!.id);
                    Navigator.pop(context);
                  },
                )
              : Container(),
        ],
      ),
      body: ListView(
        children: [
          textController('Title', _titleController),
          textController('Author', _authorController),
          textController('Comment', _commentController),
          ElevatedButton(
              onPressed: () {
                DateTime addDateTime = DateTime.now();
                String authorSort = sortingAuthor(_authorController.text);
                BookListItem newBookListItem = BookListItem(
                  //  id: oldBookListItem!.id,
                  title: _titleController.text,
                  authors: _authorController.text,
                  last_modified:
                      '${addDateTime.toString().substring(0, 19)}+00:00',
                  sort: _titleController.text,
                  author_sort: authorSort,
                  timestamp: '${addDateTime.toString().substring(0, 19)}+00:00',
                );
                newBookListItem.title = _titleController.text;
                newBookListItem.authors = _authorController.text;
                newBookListItem.comments = _commentController.text;
                if (route == '/editpage' &&
                    oldBookListItem != newBookListItem) {
                  Books newBook = Books(
                      id: newBookListItem.id,
                      title: newBookListItem.title,
                      uuid: oldBookListItem!.uuid);
                  Provider.of<BooksListProvider>(context, listen: false).update(
                      book: newBook,
                      author: Authors(
                          name: 'Brandon Sanderson',
                          sort: 'Sanderson, Brandon'),
                      id: oldBookListItem!.id);
                } else if (route == '/addpage') {
                  String authorSort = sortingAuthor(_authorController.text);
                  DateTime addDateTime = DateTime.now();
                  Books newBook = Books(
                    id: newBookListItem.id,
                    title: newBookListItem.title,
                    uuid: oldBookListItem!.uuid,
                    sort: newBookListItem.title,
                    author_sort: authorSort,
                    path: oldBookListItem!.path,
                    timestamp:
                        '${addDateTime.toString().substring(0, 19)}+00:00',
                    last_modified:
                        '${addDateTime.toString().substring(0, 19)}+00:00',
                  );
                  Authors author =
                      Authors(name: _authorController.text, sort: authorSort);
                  Provider.of<BooksListProvider>(context, listen: false)
                      .insert(book: newBook, author: author);
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

    String authorLast = '';
    if (authorSplit.length > 1) {
      authorSplit.removeLast();
      for (var item in authorSplit) {
        authorLast = '$authorLast, $item';
      }
    }

    authorLast = authorLast.replaceAll(",", "");

    return '$authorSort,$authorLast';
  }

  void clerControllers() {
    _titleController.clear();
    _authorController.clear();
    _commentController.clear();
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
