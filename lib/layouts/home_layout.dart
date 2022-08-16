import 'package:flutter/material.dart';
import 'package:nav_bar/modules/archived_tasks/archived_screen.dart';
import 'package:nav_bar/modules/done_tasks/done_screen.dart';
import 'package:nav_bar/modules/new_tasks/new_task_screen.dart';
import 'package:sqflite/sqflite.dart';

class HomeLayoutState extends StatefulWidget {
  const HomeLayoutState({Key? key}) : super(key: key);

  @override
  State<HomeLayoutState> createState() => _HomeLayoutStateState();
}

class _HomeLayoutStateState extends State<HomeLayoutState> {
  int currentIndex = 0;
  List <Widget> screens =
  [
    const NewTasksScreen(),
    const DoneScreen(),
    const ArchivedScreen()
  ];
  List<String>titles =
  [
    'New Tasks',
    'Done Tasks',
    'archived Tasks'
  ];
  Database? dataBase;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDataBase();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            titles[currentIndex],
            style: const TextStyle(fontSize: 30),
          ),
        ),
        body: screens[currentIndex],
         floatingActionButton: FloatingActionButton(
           onPressed: ()
           {
            insertToDataBase();
           },
           child: Icon(Icons.add),
         ),
         bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: ((index) 
          {
            setState(() {
              currentIndex = index;
            });
          }),
          items: 
          const [
             BottomNavigationBarItem(icon: Icon(Icons.menu),label: 'Tasks'),
             BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline_outlined),label: 'Done'), 
             BottomNavigationBarItem(icon: Icon(Icons.archive_outlined),label: 'archived'),
          ],
        ),
        );
  }
  
  void createDataBase() async {
    dataBase = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) 
      { 
        // id integer
        //title String
        // date String
        // time String
        // status String

        print('Data Base created');
        db.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value)
        {
          print('Table created');
        }).catchError((error)
        {
          print('error when creating Table ${error.toString()}');
        });
      },

      onOpen: ((db)
      { 
        print('Data Base opened');
        
      })

    );
  
  }
  void insertToDataBase()async{
  await dataBase?.transaction((txn)
  {
    txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("first task","08/02","12:20","new")')
        .then((value) {
      print('$value inserted successfully');
    }).catchError((error){
      print('error when inserting New Record ${error.toString()}');
    });

    return null!;
  });
  }
}
