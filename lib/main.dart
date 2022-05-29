import 'package:flutter/cupertino.dart';

import 'package:todo/src/to_do_screen.dart';

void main() {
  runApp(App());
}

/// APP WIDGET
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo',
      home: TodoList(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.deepOrangeAccent),
      ),
    ); */
    return CupertinoApp(
      home: ToDoScreen(),
    );
  }
}
