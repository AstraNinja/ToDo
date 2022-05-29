import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// TODO SCREEN
class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  //final List<String> _todoList = getListSP();
  List<String> _todoList = <String>[];
  final TextEditingController _textFieldController = TextEditingController();

  /// LOAD DATA
  Future<List<String>> _getListSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = <String>[];
    if (prefs.containsKey("list")) {
      list = prefs.getStringList("list")!;
    }
    return list;
  }

  /// SAVE DATA
  void setListSP(List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("list", list);
  }

  /// LOAD DATA AND SAVE TO LIST
  void loadDataToList() async {
    var data = await _getListSP();
    setState(() {
      _todoList = data;
    });
  }

  /// ADD ITEM TO TODO LIST
  void _addTodoItem(String title) {
    //Wrapping it inside a set state will notify
    // the app that the state has changed

    setState(() {
      _todoList.add(title);

      /// Automatisches Speichern
      // _setListSP(_todoList);
    });
    _textFieldController.clear();
  }

  /// GENERATE ITEM WIDGETS
  //Generate list of item widgets
  // Widget _buildTodoItem(String title) {
  //   return ListTile(
  //     title: Text(title),
  //   );
  // }

  /// ITEM CREATION DIALOG
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
                child: const Text('Hinzufügen'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              ),
              TextButton(
                child: const Text('Abbrechen'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  /// TODO ITEM WIDGET
  Widget toDoItem(String text, int index) {
    return ListTile(
      title: Text(text),
      trailing: IconButton(
        onPressed: () {
          // print(index);
          setState(() {
            _todoList.removeAt(index);
          });
        },
        icon: Icon(Icons.delete),
      ),
    );
  }

  /// Läd beim Initialisieren der App die gespeicherten Daten.
  @override
  void initState() {
    super.initState();
    loadDataToList();
  }

  /// APP UI
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("ToDo"),
        trailing: CupertinoButton(
          padding: EdgeInsets.all(8),
          onPressed: () {
            setState(() {
              _todoList = [];
            });
          },
          child: Icon(Icons.delete),
        ),
      ),
      child: Column(children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: _todoList.length,
          itemBuilder: ((context, index) {
            if (_todoList.isEmpty) {
              return Text("Die Liste ist leer!");
            } else {
              return toDoItem(_todoList[index], index);
            }
          }),
        ),
        CupertinoButton(
          onPressed: () => _displayDialog(context),
          color: Colors.blue,
          child: Text("Hinzufügen"),
        ),
      ]),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _displayDialog(context),
      //   tooltip: 'Eintrag hinzufügen',
      //   child: Icon(Icons.add),
      // ),
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
