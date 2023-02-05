import 'package:flutibre_pro/providers/booklist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                '/',
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
}
