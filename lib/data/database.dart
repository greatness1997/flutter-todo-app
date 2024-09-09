import 'package:hive_flutter/hive_flutter.dart';

class TodoDataBase {

  List toDoList = [];

  final _myBox = Hive.box('mybox');

  void createData () {
    toDoList = [
      ["Do Tutorial", false],
      ["Gym", false]
    ];
  }

  void loadData () {
    toDoList = _myBox.get('TODOLIST');
  }

  void updateData () {
    _myBox.put('TODOLIST', toDoList);
  }
}