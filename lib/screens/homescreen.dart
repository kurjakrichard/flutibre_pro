import 'package:flutibre/model/booklist_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booklist_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BookListItem? selectedBook;

  @override
  Widget build(BuildContext context) {
    var routeSettings = ModalRoute.of(context)!.settings;
    if (routeSettings.arguments != null) {
      selectedBook = routeSettings.arguments as BookListItem;
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
            future: Provider.of<BooksListProvider>(context, listen: false)
                .selectAll(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Consumer<BooksListProvider>(
                  builder: (context, provider, child) {
                    return provider.items.isNotEmpty
                        ? ListView.builder(
                            itemCount: provider.items.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5,
                                child: ListTile(
                                  onTap: () async {
                                    selectedBook = provider.items[index];

                                    if (!context.mounted) return;
                                    Navigator.of(context).pushNamed('/editpage',
                                        arguments: selectedBook);
                                    //provider.delete(provider.items[index]);
                                  },
                                  style: ListTileStyle.drawer,
                                  title: Text(provider.items[index].authors),
                                  subtitle: Text(provider.items[index].title),
                                  trailing:
                                      Text(provider.items[index].series ?? ''),
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
