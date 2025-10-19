import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_to_do/cubit/todo_cubit.dart';
import 'package:task_to_do/models/todo.dart';
import 'package:task_to_do/widgets/todo_tile.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  late var task; //العنوان يبدا من واحد بالترتيب؟
  // bool? isDone; //هذه في list tile
  late TextEditingController ctrlTask = TextEditingController();

  //4 shared Prefrences
  @override
  void initState() {
    super.initState();
    context.read<TodoCubit>().loadTodos();

    // Future.delayed(Duration.zero, () {
    //   context.read<TodoCubit>().loadTodos();
    // });
  }

  // @override
  // void dispose() {
  //   ctrlTask.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // هذا يفعّل دعم اللغات
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      //هذه هي اللغات التي يدعمها
      // supportedLocales: [
      //   // Locale('en'), // الإنجليزية
      //   // Locale('ar'), // العربية
      // ], //لا يعمل
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
        body: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            children: [
              Align(
                //محاذاة
                alignment: Alignment.centerLeft, //يجعل العنوان يسارا
                child: Text(
                  "Your To Do",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    flex: 10,
                    child: TextField(
                      controller: ctrlTask,
                      // textDirection:
                      //     TextDirection.rtl, //اتجاه النص يمين للعربية
                      decoration: InputDecoration(hintText: "Add new task"),
                      onChanged: (value) {
                        task = value;
                      },
                    ),
                  ),
                  SizedBox(width: 15), //مسافة بين الايقونه والحقل
                  Container(
                    //هنا بنستخدم اكشن من الحالة
                    //حاوية لون الايقونه وشكلها
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: () {
                        //هنا سنتخدم حفظ المهمة عبر الحالات
                        if (task.isNotEmpty) {
                          context.read<TodoCubit>().add(task);
                          ctrlTask.clear();
                        }
                      },
                      icon: Icon(Icons.add, color: Colors.white70),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(child: TodoTile()),
            ],
          ),
        ),
      ),
    );
  }
}
