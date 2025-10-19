import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:task_to_do/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitial());

  void add(String title) async {
    // int newId = state.todo.length + 1; //ربما من هنا ايضا
    int newId = (state.todo.isNotEmpty
        ? state.todo.last.id + 1
        : 1); //حتى لا يتكرر الارقام عند الحذف
    List<Todo> updatedList = List.from(state.todo)
      ..add(Todo(title: title, id: newId, date: DateTime.now()));

    // إصدار الحالة الجديدة
    emit(TodoUpdate(updatedList));
    //2. shared preferneces
    await savedTodos();
  }

  void toglle(int id) async {
    List<Todo> update = state.todo.map((value) {
      if (value.id == id) {
        return Todo(
          id: id,
          title: value.title,
          isDone: !value.isDone, //قلب النتيجة);
          // date: DateTime.now(), // هذا سبب علامة الصح لمهمتين
          date: value.date,
        );
      }
      return value;
    }).toList();
    emit(TodoUpdate(update));
    await savedTodosFromList(update);
    print(" تم الضغط على المهمة ID: $id");
  }

  void delete(int id) async {
    List<Todo> deleteTask = state.todo
        .where((value) => value.id != id)
        .toList(); //أنشئ قائمة جديدة تحتوي على جميع المهام باستثناء المهمة التي id الخاص بها يساوي id الذي نريد حذفه.

    emit(TodoUpdate(deleteTask));
    await savedTodos();
  }

  // void setEditingId(int? id) {}

  //   void editing(String title, int id) {
  //     final editingList = state.todo.map((value) {
  //       if (value.id == id) {
  //         return Todo(title: title, id: value.id);
  //       }
  //     }).toList();

  //     emit(TodoUpdate(editingList, editingID: null));
  //   }

  int remaining() {
    final reminingList = state.todo
        .where((value) => !value.isDone)
        .length; //عدد المهام الغير مكتملة

    return reminingList;
  }

  //1. saved todos shared preferences
  Future<void> savedTodos() async {
    final prefs =
        await SharedPreferences.getInstance(); //كائن مرتبط بالتطبيق / ملف التخزين المحلي
    final todoListaAsJson = state.todo.map((value) {
      return jsonEncode(value.toJson()); //تشفير map من المعلومات
    }).toList(); //الي قائمة لان json لا يقبل map

    await prefs.setStringList(
      'todo',
      todoListaAsJson,
    ); //تخزيم القائمة في مفتاح todo

    print("تم حفظ ${state.todo.length} مهمة");
  }

  //3. shared prefrences loadTodos
  // تحميل المهام المحفوظة من SharedPreferences عند تشغيل التطبيق.
  Future<void> loadTodos() async {
    emit(TodoLoading());
    // 1. الحصول على كائن SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // 2. قراءة القائمة المحفوظة من التخزين (قائمة نصوص JSON)
    final List<String> listTodo = prefs.getStringList('todo') ?? [];

    // 3. تحويل كل عنصر JSON إلى كائن Todo باستخدام fromJson
    final List<Todo> todos = listTodo
        .map((jsonStr) => Todo.fromJson(jsonDecode(jsonStr)))
        .toList();

    emit(TodoUpdate(todos));
    print(" تم تحميل ${todos.length} مهمة من SharedPreferences");
  }

  //4 saveTodosFromList تفيد toglle والتدحيث
  Future<void> savedTodosFromList(List<Todo> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((json) => jsonEncode(json.toJson())).toList();
    prefs.setStringList('todo', jsonList);
    print(" حفظ قائمة جديدة بعد التبديل: ${list.map((e) => e.isDone)}");
  }
}
