///  ██████ ██   ██  █████  ███    ██  ██████  ███████ ███████
/// ██      ██   ██ ██   ██ ████   ██ ██       ██      ██      ██
/// ██      ███████ ███████ ██ ██  ██ ██   ███ █████   ███████
/// ██      ██   ██ ██   ██ ██  ██ ██ ██    ██ ██           ██ ██
///  ██████ ██   ██ ██   ██ ██   ████  ██████  ███████ ███████
///
/// - moved _getListSP() & _setListSP() into the class and made the functions private, because they are not used outside of the class.
/// - changed _todoList to a variable, becuase the content changes when data is loaded
/// - added the _loadDataToList() function to load the data saved in shared preferences and display them.
/// - added action-buttons for saving, loading and deleting data.
/// - removed _getItems(), because it is no longer used.
/// - changed the process of building the widgets gromm the list.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo',
      home: TodoList(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.deepOrangeAccent),
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  //final List<String> _todoList = getListSP();
  List<String> _todoList = <String>[];
  final TextEditingController _textFieldController = TextEditingController();

  Future<List<String>> _getListSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = <String>[];
    if (prefs.containsKey("list")) {
      list = prefs.getStringList("list")!;
    }
    return list;
  }

  void _setListSP(List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("list", list);
  }

  /// Get the Data from shared Preferences and load them into the List.
  void _loadDataToList() async {
    var _data = await _getListSP();
    setState(() {
      _todoList = _data;
    });
  }

  void _addTodoItem(String title) {
    //Wrapping it inside a set state will notify
    // the app that the state has changed

    setState(() {
      _todoList.add(title);

      /// Automatisches Speichern
      _setListSP(_todoList);
    });
    _textFieldController.clear();
  }

  //Generate list of item widgets
  Widget _buildTodoItem(String title) {
    return ListTile(
      title: Text(title),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          setState(() {
            _todoList.remove(title);
          });
        },
      ),
    );
  }

  //Generate a single item widget
  Future<Future> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Füge einen Eintrag zu deiner Liste hinzu'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Name des Eintrages'),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Abbrechen'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Hinzufügen'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              )
            ],
          );
        });
  }

  /// Läd beim Initialisieren der App die gespeicherten Daten.
  @override
  void initState() {
    super.initState();
    _loadDataToList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo'),
        actions: [
          /* IconButton(
            onPressed: () => _setListSP(_todoList),
            icon: Icon(Icons.save),
            tooltip: "Save to SharedPreferences",
          ),
          IconButton(
            onPressed: () => _loadDataToList(),
            icon: Icon(Icons.download),
            tooltip: "Load from SharedPreferences",
          ), */
          IconButton(
            onPressed: () {
              setState(() {
                _todoList = [];
              });
            },
            icon: Icon(Icons.delete),
            tooltip: "Delete list",
          ),
        ],
      ),

      /// Loop over every item in _todoList and create a widget using _buildTodoItem(_). Append all items to a list.
      body:
          ListView(children: _todoList.map((e) => _buildTodoItem(e)).toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'Eintrag hinzufügen',
        child: Icon(Icons.add),
      ),
    );
  }

  /// NOT IN USE ANYMORE
  // List<Widget> _getItems() {
  //   final List<Widget> todoWidgets = <Widget>[];
  //   for (String title in _todoList) {
  //     todoWidgets.add(_buildTodoItem(title));
  //   }
  //   return todoWidgets;
  // }
}
