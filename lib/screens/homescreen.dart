import 'package:file_picker/file_picker.dart';
import 'package:flutibre/model/booklist_item.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:uuid/uuid.dart';
import '../providers/booklist_provider.dart';
import '../service/file_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BookListItem? selectedBook;
  // ignore: prefer_typing_uninitialized_variables
  var bookList;
  PlatformFile? _pickedfile;
  // ignore: unused_field
  bool _isLoading = false;
  FileService fileService = FileService();
  var allowedExtensions = ['pdf', 'odt', 'epub', 'mobi'];

  @override
  Widget build(BuildContext context) {
    bookList =
        Provider.of<BooksListProvider>(context, listen: false).selectAll();
    return Consumer<BooksListProvider>(builder:
        (BuildContext context, BooksListProvider provider, Widget? child) {
      return Scaffold(
        appBar: AppBar(title: const Text('Flutibre')),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
          onPressed: () async {
            BookListItem? newBook = await pickFile(provider);

            Navigator.of(context)
                .pushNamed('/addpage', arguments: newBook)
                .then(
                  (_) => setState(
                    () {
                      bookList =
                          Provider.of<BooksListProvider>(context, listen: false)
                              .selectAll();
                    },
                  ),
                );
          },
        ),
        body: FutureBuilder(
          future: bookList,
          //Provider.of<BooksListProvider>(context, listen: false).selectAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<BooksListProvider>(
                builder: (context, provider, child) {
                  return provider.items.isNotEmpty
                      ? plutoGrid(provider)
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
    });
  }

  String getUuid(BooksListProvider provider) {
    var uuid = const Uuid();
    String bookUuid = uuid.v1();

    if (provider.items.map((item) => item.uuid).contains(bookUuid)) {
      getUuid(provider);
    } else {
      return bookUuid;
    }
    return bookUuid;
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

  Widget plutoGrid(BooksListProvider provider) {
    late final PlutoGridStateManager stateManager;

    final List<PlutoColumn> columns = <PlutoColumn>[
      PlutoColumn(
        title: 'id',
        field: 'id',
        hide: true,
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'title',
        field: 'title',
        type: PlutoColumnType.text(),
        frozen: PlutoColumnFrozen.start,
      ),
      PlutoColumn(
        title: 'authors',
        field: 'authors',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'publisher',
        field: 'publisher',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'rating',
        field: 'rating',
        hide: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'timestamp',
        field: 'timestamp',
        hide: true,
        type: PlutoColumnType.date(),
      ),
      PlutoColumn(
        title: 'size',
        field: 'size',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'tags',
        field: 'tags',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'comments',
        field: 'comments',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'series',
        field: 'series',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'series_index',
        field: 'series_index',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'sort',
        field: 'sort',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'author sort',
        field: 'author_sort',
        hide: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'formats',
        field: 'formats',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'isbn',
        field: 'isbn',
        hide: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'path',
        field: 'path',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'filename',
        field: 'filename',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'lccn',
        field: 'lccn',
        hide: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'pubdate',
        field: 'pubdate',
        hide: true,
        type: PlutoColumnType.date(),
      ),
      PlutoColumn(
        title: 'last_modified',
        field: 'last_modified',
        type: PlutoColumnType.date(),
      ),
      PlutoColumn(
        title: 'uuid',
        field: 'uuid',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'has_cover',
        field: 'has_cover',
        type: PlutoColumnType.text(),
      ),
    ];

    List<PlutoRow> rows = [
      for (var item in provider.items)
        PlutoRow(cells: {
          'id': PlutoCell(value: item.id),
          'title': PlutoCell(value: item.title),
          'authors': PlutoCell(value: item.authors),
          'publisher': PlutoCell(value: item.publisher),
          'rating': PlutoCell(value: item.rating),
          'timestamp': PlutoCell(value: item.timestamp),
          'size': PlutoCell(value: item.size),
          'tags': PlutoCell(value: item.tags),
          'comments': PlutoCell(value: item.comments),
          'series': PlutoCell(value: item.series),
          'series_index': PlutoCell(value: item.series_index),
          'sort': PlutoCell(value: item.sort),
          'author_sort': PlutoCell(value: item.author_sort),
          'formats': PlutoCell(value: item.formats),
          'isbn': PlutoCell(value: item.isbn),
          'path': PlutoCell(value: item.path),
          'filename': PlutoCell(value: item.filename),
          'lccn': PlutoCell(value: item.lccn),
          'pubdate': PlutoCell(value: item.pubdate),
          'last_modified': PlutoCell(value: item.last_modified),
          'uuid': PlutoCell(value: item.uuid),
          'has_cover': PlutoCell(value: item.has_cover),
        }),
    ];

    return PlutoGrid(
      key: const ValueKey('value'),
      mode: PlutoGridMode.selectWithOneTap,
      columns: columns,
      rows: rows,
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager.setShowColumnFilter(false);
        stateManager.notifyListeners();
      },
      onSelected: (event) {
        int index = stateManager.currentRow!.cells.values.first.value;
        selectedBook =
            provider.items.firstWhere((element) => element.id == index);

        Navigator.pushNamed(
          context,
          '/editpage',
          arguments: selectedBook,
        );
      },
      onChanged: (PlutoGridOnChangedEvent event) {
        // ignore: avoid_print
        print(event);
      },
      configuration: const PlutoGridConfiguration(
          columnSize:
              PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale)),
    );
  }

  Future<BookListItem?> pickFile(BooksListProvider provider) async {
    BookListItem? newBook;
    String bookUuid = getUuid(provider);
    try {
      setState(() {
        _isLoading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          allowedExtensions: allowedExtensions);

      if (result != null) {
        _pickedfile = result.files.first;
        // ignore: avoid_print
        print('Name: ${_pickedfile!.name}');
        // ignore: avoid_print
        print('Bytes: ${_pickedfile!.bytes}');
        // ignore: avoid_print
        print('Size: ${_pickedfile!.size}');
        // ignore: avoid_print
        print('Extension: ${_pickedfile!.extension}');
        // ignore: avoid_print
        print('Path: ${_pickedfile!.path}');
        newBook = BookListItem(
            uuid: bookUuid,
            size: _pickedfile!.size,
            formats: _pickedfile!.extension!,
            path: removeDiacritics(_pickedfile!.name));
        await fileService.copyFile(
            pickedfile: _pickedfile,
            path: '/home/sire/Sablonok/Ebooks2',
            filename: _pickedfile!.name,
            extension: _pickedfile!.extension!);
        //fileService.openFile(_pickedfile!.path!);
      } else {
        setState(() {
          _isLoading = false;
        });
        return null;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return newBook;
  }
}
