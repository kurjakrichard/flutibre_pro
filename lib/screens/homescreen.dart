import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutibre/model/booklist_item.dart';
import 'package:flutibre/repository/database_handler.dart';
import 'package:flutter/material.dart';
//import 'package:pluto_grid/pluto_grid.dart';
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
  bool isSearching = false;
  List<BookListItem> books = [];
  List<BookListItem> filteredBooks = [];
  BookListItem? selectedBook;
  DatabaseHandler databaseHandler = DatabaseHandler();
  // ignore: prefer_typing_uninitialized_variables

  PlatformFile? _pickedfile;
  // ignore: unused_field
  FileService fileService = FileService();
  var allowedExtensions = ['pdf', 'odt', 'epub', 'mobi'];

  @override
  void initState() {
    Provider.of<BooksListProvider>(context, listen: false).selectAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BooksListProvider>(builder:
        (BuildContext context, BooksListProvider provider, Widget? child) {
      return Scaffold(
          appBar: appBar(context),
          floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
              onPressed: () async {
                BookListItem? newBook = await pickfile(provider);
                // ignore: use_build_context_synchronously
                Provider.of<BooksListProvider>(context, listen: false)
                    .insert(newBookListItem: newBook!);

                // ignore: use_build_context_synchronously
                Navigator.of(context)
                    .pushNamed('/readpage', arguments: newBook)
                    .then(
                      (_) => setState(
                        () {
                          Provider.of<BooksListProvider>(context, listen: false)
                              .selectAll();
                        },
                      ),
                    );
              }),
          body: Consumer<BooksListProvider>(
            builder: (context, provider, child) {
              books = provider.items;
              filteredBooks = filteredBooks.isEmpty ? books : filteredBooks;
              return books.isNotEmpty
                  ? datatable(filteredBooks)
                  : const Center(child: CircularProgressIndicator());
            },
          ));
    });
  }

  String getUuid() {
    var uuid = const Uuid();
    String bookUuid = uuid.v1();

    if (books.map((item) => item.uuid).contains(bookUuid)) {
      getUuid();
    } else {
      return bookUuid;
    }
    return bookUuid;
  }

  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: !isSearching
          ? const Text('Flutibre')
          : TextField(
              onChanged: (value) => filteredBook(value),
              cursorColor: Colors.white,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                hintText: 'Search book',
                //hintStyle: TextStyle(color: Colors.white)
              ),
            ),
      actions: <Widget>[
        isSearching
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = false;
                    filteredBooks = books;
                  });
                },
                icon: const Icon(Icons.cancel))
            : IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = true;
                  });
                },
                icon: const Icon(Icons.search))
      ],
    );
  }

  Widget datatable(List<BookListItem> books) {
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
        for (BookListItem item in books)
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

  Widget list(List<BookListItem> filteredBooks) {
    return ListView.builder(
      itemCount: filteredBooks.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          child: ListTile(
            onTap: () async {
              selectedBook = filteredBooks[index];

              if (!context.mounted) return;
              Navigator.of(context)
                  .pushNamed('/editpage', arguments: selectedBook);
              //provider.delete(provider.items[index]);
            },
            style: ListTileStyle.drawer,
            title: Text(filteredBooks[index].authors),
            subtitle: Text(filteredBooks[index].title),
            trailing: Text(filteredBooks[index].series ?? ''),
          ),
        );
      },
    );
  }

  /* Widget plutoGrid(List<BookListItem> books) {
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
      for (var item in books)
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
          'filename': PlutoCell(value: item.name),
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
        selectedBook = books.firstWhere((book) => book.id == index);

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
*/
  Future<BookListItem?> pickfile(BooksListProvider provider) async {
    List seq = await databaseHandler.getSqliteSequence();
    int id = seq[0]['seq'] + 1;
    BookListItem newBookListItem = BookListItem();
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          allowedExtensions: allowedExtensions);

      if (result != null) {
        _pickedfile = result.files.first;
        String fileName =
            _pickedfile!.name.substring(0, _pickedfile!.name.lastIndexOf('.'));

        File? newFile = await fileService.copyFile(
            oldpath: _pickedfile!.path!,
            path: '/home/sire/Sablonok/Ebooks3',
            filename: fileName,
            extension: _pickedfile!.extension!);

        if (newFile.existsSync()) {
          DateTime addDateTime = DateTime.now();
          Map<String, String> authorTitle = getTitleAuthor(_pickedfile!.name);
          String authorName = authorTitle['author']!;
          String title = authorTitle['title']!;
          String authorSort = sortingAuthor(authorName);
          String path =
              '${removeDiacritics(authorName)}/${removeDiacritics(title)}($id)';
          String bookUuid = getUuid();
          newBookListItem = BookListItem(
              id: id,
              authors: authorName,
              author_sort: authorSort,
              title: title,
              path: path,
              name: _pickedfile!.name,
              formats: _pickedfile!.extension!,
              size: _pickedfile!.size,
              has_cover: 0,
              timestamp: '${addDateTime.toString().substring(0, 19)}+00:00',
              last_modified: '${addDateTime.toString().substring(0, 19)}+00:00',
              uuid: bookUuid);
        }
        //fileService.openFile(_pickedfile!.path!);
      } else {
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return newBookListItem;
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

  Map<String, String> getTitleAuthor(String name) {
    List<String> authorTitle = name.split('-');
    Map<String, String> getTitleAuthor = {
      'title': authorTitle[0].replaceAll('_', ' ').trim(),
      'author': authorTitle.length < 2
          ? 'unknow author'
          : authorTitle[1].split('.').first.replaceAll('_', ' ').trim()
    };
    return getTitleAuthor;
  }

  void filteredBook(String value) {
    setState(() {
      filteredBooks = books.where((book) => book.title == value).toList();
    });
  }
}
