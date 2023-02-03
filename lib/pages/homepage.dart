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
  Icon custIcon = const Icon(Icons.search);
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookListProvider>(
      builder: (context, books, child) => Scaffold(
        drawer: drawerNavigation(context),
        appBar: AppBar(
          title: !isSearching
              ? const Text('Flutibre Pro')
              : TextField(
                  onChanged: (value) {
                    books.getBookList(value);
                  },
                  textInputAction: TextInputAction.go,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    border: InputBorder.none,
                    hintText: "Search term",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
          actions: <Widget>[
            isSearching
                ? IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        books.getBookList();
                        isSearching = false;
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  )
          ],
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: books.filteredBookList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Center(child: Text(books.filteredBookList[index].name)),
              );
            }),
        floatingActionButton: FloatingActionButton(
          heroTag: 'btn1',
          tooltip: 'Increment',
          onPressed: () {
            //books.getBookList('Pálma');
            ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                leading: Icon(Icons.search),
                content: Text('Search'),
                actions: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).clearMaterialBanners();
                    },
                    child: Text('Bezárás'),
                  )
                ],
              ),
            );
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
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          )
        ]),
      ),
    );
  }
}
