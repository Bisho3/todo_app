import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/todo/cubit/states.dart';
import 'package:todo_app/modules/archived/archived_screen.dart';
import 'package:todo_app/modules/done/done_screen.dart';
import 'package:todo_app/modules/tasks/tasks_screen.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoInitialize());

  static TodoCubit get(context) => BlocProvider.of(context);

  int currentindex = 0;

  List<Widget> Screen = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  List<String> appbar = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void chageBottomNav(index) {
    currentindex = index;
    emit(TodoChangeBottomNavigatorStates());
  }

  // Database
  late Database database;
  List<Map> newtasks = [];
  List<Map> newdone = [];
  List<Map> newarchive = [];

  void CreateDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database Created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table Created');
        }).catchError((error) {
          print('Error Creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        GetDataFromDatabase(database);
        print('Database Opend Successfully');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  InsertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    return await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","New")')
          .then((value) {
        print('$value Inserted Successfully');
        emit(AppInsertDatabaseState());
        GetDataFromDatabase(database);
      }).catchError((error) {
        print('Error When Inserting NEW Record ${error.toString()}');
      });
    });
  }

  void GetDataFromDatabase(database) {
    newtasks = [];
    newdone = [];
    newarchive = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'New') {
          newtasks.add(element);
        } else if (element['status'] == 'done') {
          newdone.add(element);
        } else {
          newarchive.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
    ;
  }

  void UpdateData({
    required String status,
    required int id,
  }) {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      GetDataFromDatabase(database);
      emit(AppUpdateData());
    });
  }

  void DeleteData({
    required int id,
  }) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      GetDataFromDatabase(database);
      emit(AppDeleteData());
    });
  }

  // icon
  bool isBottomSheetShow = false;
  IconData febicon = Icons.edit;

  void ChangeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShow = isShow;
    febicon = icon;
    emit(AppChangeBottomSheetState());
  }
}
