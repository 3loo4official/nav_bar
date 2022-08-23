import 'package:flutter/material.dart';
import 'package:nav_bar/modules/archived_tasks/archived_screen.dart';
import 'package:nav_bar/modules/done_tasks/done_screen.dart';
import 'package:nav_bar/modules/new_tasks/new_task_screen.dart';
import 'package:nav_bar/shared/components.dart';
import 'package:sqflite/sqflite.dart';

class HomeLayoutState extends StatefulWidget {
  const HomeLayoutState({Key? key}) : super(key: key);

  @override
  State<HomeLayoutState> createState() => _HomeLayoutStateState();
}

class _HomeLayoutStateState extends State<HomeLayoutState> {
  int currentIndex = 0;
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneScreen(),
    const ArchivedScreen()
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'archived Tasks'];
  Database? dataBase;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
          style: const TextStyle(fontSize: 30),
        ),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            Navigator.pop(context);
            isBottomSheetShown = false;
            setState(() {
              fabIcon = Icons.edit;
            });
          } else {
            scaffoldKey.currentState?.showBottomSheet((context) => Container(
              color: Colors.grey[150],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    defaultFormField(
                      controller: titleController,
                      type: TextInputType.text,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'title must not be empty';
                        }
                        return null!;
                      },
                      label: 'Task Title',
                      prefixIcon: Icons.title,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    defaultFormField(
                      controller: timeController,
                      type: TextInputType.datetime,
                      onTap: ()
                      {
                        showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now()
                        ).then((value)
                        {
                          timeController.text = value!.format(context).toString();
                          print(value.format(context));
                        });
                      },
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'time must not be empty';
                        }
                        return null!;
                      },
                      label: 'Task Time',
                      prefixIcon: Icons.watch_later_outlined,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    defaultFormField(
                      controller: dateController,
                      type: TextInputType.datetime,
                      onTap: ()
                      {
                        showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse('2022-8-23'),
                        ).then((value)
                        {

                        });
                      },
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'Date must not be empty';
                        }
                        return null!;
                      },
                      label: 'Task Date',
                      prefixIcon: Icons.date_range,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ));
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: ((index) {
          setState(() {
            currentIndex = index;
          });
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline_outlined), label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: 'archived'),
        ],
      ),
    );
  }

  void createDataBase() async {
    dataBase =
        await openDatabase('todo.db', version: 1, onCreate: (db, version) {
      // id integer
      //title String
      // date String
      // time String
      // status String

      print('Data Base created');
      db
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('Table created');
      }).catchError((error) {
        print('error when creating Table ${error.toString()}');
      });
    }, onOpen: ((db) {
      print('Data Base opened');
    }));
  }

  void insertToDataBase() async {
    await dataBase?.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("first task","08/02","12:20","new")')
          .then((value) {
        print('$value inserted successfully');
      }).catchError((error) {
        print('error when inserting New Record ${error.toString()}');
      });

      return null!;
    });
  }
}
