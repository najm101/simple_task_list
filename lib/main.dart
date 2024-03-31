import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paginated List View Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaginatedListView(),
    );
  }
}

class PaginatedListView extends StatefulWidget {
  @override
  _PaginatedListViewState createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView> {
  final List<String> names = [
    'Alice',
    'Bob',
    'Charlie',
    'David',
    'Eve',
    'Frank',
    'Grace',
    'Helen',
    'Ivy',
    'Jack',
    'Kate',
    'Liam',
    'Mia',
    'Noah',
    'Olivia',
    'Peter',
    'Quinn',
    'Rachel',
    'Sam',
    'Tom',
    'Ursula'
  ];
  TextEditingController nameCont = TextEditingController(text: "");
  final int itemsPerPage = 5; // Items per page
  int currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paginated Task View'),
        actions: [Icon(Icons.sunny)],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: (names.length / itemsPerPage).ceil(),
              itemBuilder: (BuildContext context, int pageIndex) {
                final startIndex = pageIndex * itemsPerPage;
                final endIndex = startIndex + itemsPerPage;
                return ListView.builder(
                  itemCount: endIndex <= names.length
                      ? itemsPerPage
                      : names.length - startIndex,
                  itemBuilder: (BuildContext context, int index) {
                    final itemIndex = startIndex + index;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: Colors.blueGrey[100]),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text('AH'),
                        ),
                        title: Text(names[itemIndex]), // Fix here
                        subtitle: const Text("checked-in"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  names.removeAt(itemIndex); // Fix here
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent[100],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _showEditDialog(itemIndex)
                                    .then((value) => setState(() {}));
                              },
                              icon: const Icon(Icons.edit),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.blueGrey[100]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: currentPage == 0
                      ? null
                      : () => _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut),
                ),
                for (int i = 0; i < (names.length / itemsPerPage).ceil(); i++)
                  IconButton(
                    icon: Icon(Icons.circle,
                        color: currentPage == i ? Colors.blue : Colors.grey),
                    onPressed: () => _pageController.animateToPage(
                      i,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed:
                      currentPage == (names.length / itemsPerPage).ceil() - 1
                          ? null
                          : () => _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMyDialog().then((value) => setState(() {})),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Employee'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameCont,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ADD'),
              onPressed: () {
                names.add(nameCont.text);
                nameCont.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(int index) async {
    setState(() {
      nameCont.text = names[index];
    });
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Employee'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameCont,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                names.removeAt(index);
                names.insert(index, nameCont.text);
                nameCont.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
