import 'dart:io';

import 'package:flutibre_pro/providers/booklist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<BookListProvider>(
      builder: (context, books, child) => Scaffold(
        drawer: drawerNavigation(context),
        appBar: AppBar(
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
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: books.currentBooks.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Center(child: Text(books.currentBooks[index].name)),
              );
            }),
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
