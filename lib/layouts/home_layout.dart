import 'package:flutter/material.dart';
import 'package:nav_bar/modules/archived_tasks/archived_screen.dart';
import 'package:nav_bar/modules/done_tasks/done_screen.dart';
import 'package:nav_bar/modules/new_tasks/new_task_screen.dart';

class HomeLayoutState extends StatefulWidget {
  const HomeLayoutState({Key? key}) : super(key: key);

  @override
  State<HomeLayoutState> createState() => _HomeLayoutStateState();
}

class _HomeLayoutStateState extends State<HomeLayoutState> {
  int currentIndex = 0;
  List <Widget> screens =
  [
    NewTasksScreen(),
    DoneScreen(),
    ArchivedScreen()
  ];
  List<String>titles =
  [
    'New Tasks',
    'Done Tasks',
    'archived Tasks'


  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
        appBar: AppBar(
          title: Text(
            titles[currentIndex],
            style: TextStyle(fontSize: 30),
          ),
        ),
        body: screens[currentIndex],
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
          [
             BottomNavigationBarItem(icon: Icon(Icons.menu),label: 'Tasks'),
             BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline_outlined),label: 'Done'), 
             BottomNavigationBarItem(icon: Icon(Icons.archive_outlined),label: 'archived'),
          ],
        ),
        );
  }
}
