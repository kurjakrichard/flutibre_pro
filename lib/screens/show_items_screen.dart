import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/authors_provider.dart';
import 'add_item_screen.dart';

class ShowItemsScreen extends StatelessWidget {
  const ShowItemsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Flutibre')),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddItemScreen()));
          },
        ),
        body: FutureBuilder(
            future:
                Provider.of<AuthorsProvider>(context, listen: false).select(),
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
                                  style: ListTileStyle.drawer,
                                  title: Text(provider.items[index].name),
                                  subtitle:
                                      Text(provider.items[index].sort ?? ''),
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
