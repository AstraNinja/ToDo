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
  // ignore: unused_element
  Future<Future> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Füge einen Eintrag zu deiner Liste hinzu',
                style: CupertinoTheme.of(context).textTheme.textStyle),
            content: CupertinoTextField(
              controller: _textFieldController,
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text('Hinzufügen'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Abbrechen'),
              )
            ],
          );
        });
  }

  /// TODO ITEM WIDGET
  Widget toDoItem(String text, int index) {
    return Material(
      child: ListTile(
        title: Text(text),
        tileColor: Colors.black,
        textColor: Colors.white,
        trailing: CupertinoButton(
          onPressed: () {
            // print(index);
            setState(() {
              _todoList.removeAt(index);
            });
          },
          //child: Icon(Icons.delete),
          child: Icon(CupertinoIcons.delete),
        ),
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
          child: Icon(CupertinoIcons.delete),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _todoList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 100, bottom: 8),
                        child: Text("Die Liste ist leer!",
                            style: CupertinoTheme.of(context).textTheme.textStyle),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _todoList.length,
                        itemBuilder: ((context, index) {
                          return toDoItem(_todoList[index], index);
                        }),
                      ),
                CupertinoButton(
                  onPressed: () => _showAlertDialog(context),
                  color: Colors.blue,
                  child: Text("Hinzufügen"),
                ),
              ]),
        ),
      ),
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

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Element hinzufügen'),
        content: CupertinoTextField(
          controller: _textFieldController,
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Abbrechen'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            onPressed: () {
              Navigator.pop(context);
              _addTodoItem(_textFieldController.text);
            },
            child: const Text('Hinzufügen'),
          )
        ],
      ),
    );
  }
}
