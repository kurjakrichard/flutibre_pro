import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/books.dart';
import '../providers/booklist_provider.dart';
import '../repository/database_handler.dart';

class ShowItemsScreen extends StatefulWidget {
  const ShowItemsScreen({Key? key}) : super(key: key);

  @override
  State<ShowItemsScreen> createState() => _ShowItemsScreenState();
}

class _ShowItemsScreenState extends State<ShowItemsScreen> {
  Books? selectedBook;

  @override
  Widget build(BuildContext context) {
    var routeSettings = ModalRoute.of(context)!.settings;
    if (routeSettings.arguments != null) {
      selectedBook = routeSettings.arguments as Books;
    }
    return Scaffold(
        appBar: AppBar(title: const Text('Flutibre')),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed('/addpage');
          },
        ),
        body: FutureBuilder(
            future:
                Provider.of<BooksProvider>(context, listen: false).selectAll(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Consumer<BooksProvider>(
                  builder: (context, provider, child) {
                    return provider.items.isNotEmpty
                        ? ListView.builder(
                            itemCount: provider.items.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5,
                                child: ListTile(
                                  onTap: () async {
                                    var databaseHandler = DatabaseHandler();
                                    selectedBook =
                                        await databaseHandler.selectItemById(
                                            'books',
                                            'Books',
                                            provider.items[index].id) as Books;

                                    if (!context.mounted) return;
                                    Navigator.of(context).pushNamed('/editpage',
                                        arguments: selectedBook);
                                    //provider.delete(provider.items[index]);
                                  },
                                  style: ListTileStyle.drawer,
                                  title: Text(provider.items[index].name),
                                  subtitle: Text(provider.items[index].sort),
                                  trailing:
                                      Text(provider.items[index].author_sort),
                                ),
                              );
                            })
                        : const Center(
                            child: Text(
                            'List has no data',
                            style: TextStyle(fontSize: 35, color: Colors.black),
                          ));
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
