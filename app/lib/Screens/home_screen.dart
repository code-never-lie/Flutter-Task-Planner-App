// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/task_model.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class Homescreen extends StatefulWidget {
  static const routeName = '/home_screen';
  const Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // ignore: prefer_typing_uninitialized_variables
  var _taskController;
  final List<Task> _tasks = [];
  List<bool> _tasksdone = [];
  // ignore: non_constant_identifier_names
  Saveddata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Task t = Task.fromString(_taskController.text);

    String? tasks = preferences.getString("task");
    List list = (tasks == null) ? [] : json.decode(tasks);
    // ignore: avoid_print
    print(list);
    list.add(json.encode(t.getMap()));
    preferences.setString('task', json.encode(list));
    _taskController.text = "";
    Navigator.of(context).pop();
    _getTasks();
  }

  void _getTasks() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? tasks = preferences.getString("task");
    List list = (tasks == null) ? [] : json.decode(tasks);
    _tasks.clear();
    for (dynamic d in list) {
      // ignore: avoid_print
      print(d.runtimeType);
      _tasks.add(Task.fromMap(json.decode(d)));
    }
    _tasksdone = List.generate(tasks!.length, (index) => false);
    setState(() {});
  }

  void updatelisttask() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<Task> panding = [];
    for (var i = 0; i < _tasks.length; i++) {
      if (!_tasksdone[i]) panding.add(_tasks[i]);
    }
    var pandingListEncode =
        List.generate(panding.length, (i) => json.encode(panding[i].getMap()));
    preferences.setString("task", json.encode(pandingListEncode));
    _getTasks();
    Fluttertoast.showToast(
        msg: "Press Saved Button",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void initState() {
    super.initState();
    _getTasks();
    _taskController = TextEditingController();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager", style: GoogleFonts.lobster()),
        actions: [
          IconButton(
              onPressed: () {
                updatelisttask();
              },
              icon: const Icon(Icons.save)),
          IconButton(
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.setString('task', json.encode([]));
                _getTasks();
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
      // ignore: unrelated_type_equality_checks, unnecessary_null_comparison
      body: (_tasks == null)
          ? Center(
              child: Text(
                "No Task added yet!",
                style: GoogleFonts.lobster(color: Colors.black, fontSize: 20),
              ),
            )
          : Column(
              children: _tasks
                  .map((e) => Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5.0,
                        ),
                        padding: const EdgeInsets.only(
                          left: 10.0,
                        ),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.black,
                              width: 0.7,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.task,
                              style: GoogleFonts.lobster(
                                  color: Colors.black, fontSize: 20),
                            ),
                            Checkbox(
                              value: _tasksdone[_tasks.indexOf(e)],
                              onChanged: (value) {
                                // This is where we update the state when the checkbox is tapped
                                setState(() {
                                  _tasksdone[_tasks.indexOf(e)] = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        splashColor: Colors.red,
        onPressed: () {
          Fluttertoast.showToast(
              msg: "Press Floating Action Button",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  height: 600,
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Add Task",
                              style: GoogleFonts.lobster(
                                  color: Colors.black, fontSize: 20)),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.close),
                          )
                        ],
                      ),
                      const Divider(
                        thickness: 3,
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                          controller: _taskController,
                          autocorrect: true,
                          enableInteractiveSelection: true,
                          enableSuggestions: true,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              hintText: "Enter Task",
                              hintStyle: GoogleFonts.lobster(),
                              contentPadding: const EdgeInsets.all(20),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(5.0),
                              ))),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 10,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white)),
                                onPressed: () {
                                  Fluttertoast.showToast(
                                      msg: "Press Add Button",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.blue,
                                      fontSize: 16.0);
                                  Saveddata();
                                },
                                child: Text("Add ",
                                    style: GoogleFonts.lobster(
                                        color: Colors.black, fontSize: 20)),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 10,
                              child: ElevatedButton(
                                onPressed: () {
                                  Fluttertoast.showToast(
                                      msg: "Press Reset Button",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  _taskController.text = "";
                                },
                                child: Text("Reset ",
                                    style: GoogleFonts.lobster(
                                      color: Colors.black,
                                      fontSize: 20,
                                    )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
