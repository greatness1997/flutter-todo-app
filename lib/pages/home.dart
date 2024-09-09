import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/components/dialog_box.dart';
import 'package:myapp/components/todo_list.dart';
import 'package:myapp/data/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}



class _HomeState extends State<Home> {

  final _myBox = Hive.box('mybox');

  final _controller = TextEditingController();

  TodoDataBase db = TodoDataBase();

  @override
  void initState() {
    if(_myBox.get('TODOLIST') == null){
      db.createData();
    }else{
      db.loadData();
;    }
    super.initState();
  }

  void toggleBox(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });

    db.updateData();
  }

  void addTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateData();
  }

  void createNewTask () {
    showDialog(
      context: context,
      builder: (contex) {
        return DialogBox(
          controller: _controller,
          onSave: addTask,
          onCancel: () => Navigator.of(contex).pop(),
        ); 
      }
    );
  }

  void delete(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[200],
        appBar: AppBar(
          title: const Text("TO DO"),
        ),
        floatingActionButton: FloatingActionButton(onPressed: createNewTask, backgroundColor: Colors.yellow, child: Icon(Icons.add),),
        body: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) {
            return TodoList(
                deleteTask: (context) => delete(index),
                taskName: db.toDoList[index][0],
                taskCompleted: db.toDoList[index][1],
                onChanged: (value) => toggleBox(value, index));
          },
        ));
  }
}
