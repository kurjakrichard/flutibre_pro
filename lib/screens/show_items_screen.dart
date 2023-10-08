import 'package:flutibre/model/authors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/authors_provider.dart';
import '../repository/database_handler.dart';

class ShowItemsScreen extends StatefulWidget {
  const ShowItemsScreen({Key? key}) : super(key: key);

  @override
  State<ShowItemsScreen> createState() => _ShowItemsScreenState();
}

class _ShowItemsScreenState extends State<ShowItemsScreen> {
  Authors? selectedAuthor;

  @override
  Widget build(BuildContext context) {
    var routeSettings = ModalRoute.of(context)!.settings;
    if (routeSettings.arguments != null) {
      selectedAuthor = routeSettings.arguments as Authors;
    }
    return Scaffold(
        appBar: AppBar(title: const Text('Flutibre')),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed('/addpage');
          },
        ),
        body: FutureBuilder(
            future: Provider.of<AuthorsProvider>(context, listen: false)
                .selectAll(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Consumer<AuthorsProvider>(
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
                                    selectedAuthor =
                                        await databaseHandler.selectItem(
                                                'authors',
                                                'Authors',
                                                provider.items[index].id!)
                                            as Authors;
                                    if (!context.mounted) return;
                                    Navigator.of(context).pushNamed('/editpage',
                                        arguments: selectedAuthor);
                                    //provider.delete(provider.items[index]);
                                  },
                                  style: ListTileStyle.drawer,
                                  title: Text(provider.items[index].name),
                                  subtitle: Text(provider.items[index].sort),
                                  trailing: Text(provider.items[index].link),
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
