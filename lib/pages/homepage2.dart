import 'dart:io';
import 'package:flutibre_pro/providers/booklist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../model/book.dart';
import '../model/booklist_item.dart';
import '../model/data.dart';
import '../utils/ebook_service.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  TextEditingController searchController = TextEditingController();
  final EbookService _bookService = EbookService();
  Widget? bookDetails;

  @override
  void initState() {
    super.initState();

    bookDetails = bookDetailsItem();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookListProvider>(
      builder: (context, books, child) => Scaffold(
        drawer: drawerNavigation(context),
        appBar: appBar(books),
        body: listView(true, books),
        floatingActionButton: FloatingActionButton(
          heroTag: 'btn1',
          tooltip: 'Increment',
          onPressed: () {
            //books.getBookList('Pálma');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  ListView listView2(BookListProvider books) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: books.currentBooks.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Center(child: Text(books.currentBooks[index].name)),
          );
        });
  }

  FutureBuilder listView(bool isWide, BookListProvider books) {
    Book? selectedBook;
    return FutureBuilder(
        future: books.currentBooks2,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length as int,
              itemExtent: 90,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () async {
                    List<Data>? formats = await _bookService
                        .readBookFormats(snapshot.data[index].id);
                    selectedBook = Book(
                        id: snapshot.data[index].id,
                        title: snapshot.data[index].title,
                        author_sort: snapshot.data[index].author_sort,
                        path: snapshot.data[index].path,
                        has_cover: snapshot.data[index].has_cover,
                        series_index: snapshot.data[index].series_index,
                        formats: formats);
                    if (!isWide) {
                      Navigator.pushNamed(
                        context,
                        '/bookdetailspage',
                        arguments: selectedBook,
                      );
                    } else {
                      setState(() {
                        bookDetails = bookDetailsItem(book: selectedBook);
                      });
                    }
                  },
                  child: bookItem(snapshot.data[index]),
                );
              }),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  PreferredSizeWidget appBar(BookListProvider books) {
    return AppBar(
      title: const Text('Flutibre Pro'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                content: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    value.isEmpty
                        ? books.toggleAllBooks()
                        : books.filteredBookList(value);
                  },
                  textInputAction: TextInputAction.go,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.search,
                    ),
                    border: InputBorder.none,
                    hintText: 'Search term',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).clearMaterialBanners();
                    },
                    child: const Text('Bezárás'),
                  )
                ],
              ),
            );
          },
        )
      ],
    );
  }

  Widget bookDetailElement(
      {required String detailType, required String detailContent}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(detailType,
            style: Theme.of(context).textTheme.displayMedium,
            overflow: TextOverflow.ellipsis),
        const VerticalDivider(),
        Flexible(
          child: Text(detailContent,
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

//DrawerNavigation widget
  Widget drawerNavigation(context) {
    return Material(
      child: Drawer(
        child: ListView(children: [
          DrawerHeader(
              child: Row(
            children: [
              Image.asset('images/bookshelf-icon2.png'),
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  'Flutibre',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          )),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(AppLocalizations.of(context)!.homepage),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/homepage',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settingspage),
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          )
        ]),
      ),
    );
  }

  Widget bookDetailsItem({Book? book}) {
    List<String> formats = [];
    if (book == null) {
      return const Center(child: Text('Nincs könyv kiválasztva'));
    } else {
      for (var item in book.formats!) {
        formats.add(item.format.toLowerCase());
      }
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: loadCover(book.has_cover, book.path),
              ),
              SizedBox(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          bookDetailElement(
                              detailType: 'Title:', detailContent: book.title),
                          bookDetailElement(
                              detailType: 'Author:',
                              detailContent: book.author_sort),
                          Text(
                            'Formats: ${formats.toString().replaceAll('[', '').replaceAll(']', '')}',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: Colors.cyan,
                              ),
                              child: const Text(
                                'Back',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                String bookPath =
                                    '${prefs.getString('path')}/${book.path}/${book.formats![0].name}.${book.formats![0].format.toLowerCase()}';
                                if (Platform.isWindows) {
                                  (bookPath.replaceAll('/', '\\'));
                                } else {
                                  OpenFilex.open(bookPath);
                                }
                              },
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: Colors.cyan,
                              ),
                              child: const Text(
                                'Open',
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 60)
            ],
          ));
    }
  }

  Widget bookItem(book) {
    return Card(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: Color.fromRGBO(98, 163, 191, 0.5),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(2, 2),
              blurRadius: 40,
            )
          ],
        ),
        height: 70,
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: loadCover(book.has_cover, book.path),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      book.name ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      book.title ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Image loadCover(int hasCover, String path) {
    return hasCover == 1
        ? Image.file(File('${prefs.getString('path')}/$path/cover.jpg'))
        : Image.asset('images/cover.png');
  }
}
