import 'package:flutibre/model/booklist_item.dart';
import 'package:flutibre/model/data.dart';
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
        future:
            Provider.of<BooksListProvider>(context, listen: false).selectAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<BooksListProvider>(
              builder: (context, provider, child) {
                return provider.items.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: datatable(provider)))
                    : const Center(
                        child: Text(
                          'List has no data',
                          style: TextStyle(fontSize: 35, color: Colors.black),
                        ),
                      );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget datatable(BooksListProvider provider) {
    List<DataColumn> columns = [
      const DataColumn(label: Text('id')),
      const DataColumn(label: Text('title')),
      const DataColumn(label: Text('authors')),
      const DataColumn(label: Text('publisher')),
      const DataColumn(label: Text('rating')),
      const DataColumn(label: Text('timestamp')),
      const DataColumn(label: Text('size')),
      const DataColumn(label: Text('tags')),
      const DataColumn(label: Text('comments')),
      const DataColumn(label: Text('series')),
      const DataColumn(label: Text('series_index')),
      const DataColumn(label: Text('sort')),
      const DataColumn(label: Text('author_sort')),
      const DataColumn(label: Text('formats')),
      const DataColumn(label: Text('isbn')),
      const DataColumn(label: Text('path')),
      const DataColumn(label: Text('lccn')),
      const DataColumn(label: Text('pubdate')),
      const DataColumn(label: Text('last_modified')),
      const DataColumn(label: Text('has_cover')),
    ];

    return DataTable(
      columns: columns,
      rows: [
        for (BookListItem item in provider.items)
          DataRow(cells: <DataCell>[
            DataCell(Text(item.id.toString())),
            DataCell(Text(item.title)),
            DataCell(Text(item.authors)),
            DataCell(Text(item.publisher ?? '')),
            DataCell(Text(item.rating.toString())),
            DataCell(Text(item.timestamp)),
            DataCell(Text(item.size.toString())),
            DataCell(Text(item.tags ?? '')),
            DataCell(Text(item.comments ?? '')),
            DataCell(Text(item.series ?? '')),
            DataCell(Text(item.series_index.toString())),
            DataCell(Text(item.sort)),
            DataCell(Text(item.author_sort)),
            DataCell(Text(item.formats)),
            DataCell(Text(item.isbn)),
            DataCell(Text(item.path)),
            DataCell(Text(item.lccn)),
            DataCell(Text(item.pubdate)),
            DataCell(Text(item.last_modified)),
            DataCell(Text(item.has_cover.toString())),
          ]),
      ],
    );
  }

  Widget list(BooksListProvider provider) {
    return ListView.builder(
      itemCount: provider.items.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          child: ListTile(
            onTap: () async {
              selectedBook = provider.items[index];

              if (!context.mounted) return;
              Navigator.of(context)
                  .pushNamed('/editpage', arguments: selectedBook);
              //provider.delete(provider.items[index]);
            },
            style: ListTileStyle.drawer,
            title: Text(provider.items[index].authors),
            subtitle: Text(provider.items[index].title),
            trailing: Text(provider.items[index].series ?? ''),
          ),
        );
      },
    );
  }
}
