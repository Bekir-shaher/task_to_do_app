import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_to_do/cubit/todo_cubit.dart';
import 'package:task_to_do/extention/extentions.dart';
import 'package:task_to_do/models/todo.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

class TodoTile extends StatelessWidget {
  TodoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      //فقط blocBuilder لان في main blocProvider
      builder: (context, state) {
        if (state is TodoLoading) {
          //اذا في حالة الانتظار
          return Center(
            child: CircularProgressIndicator(),
          ); //تظهر علامة الانتظار
        }
        if (state.todo.isEmpty) {
          return Center(
            child: Text(
              "There is'not any tasks",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          );
        }
        return Column(
          children: [
            // SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: state.todo.length,
                itemBuilder: (context, index) {
                  var item = state.todo[index];
                  return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                    ), //مسافة متماثله من الاعلى

                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade700), //الحدود
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: item.isDone,
                        onChanged: (value) {
                          context.read<TodoCubit>().toglle(item.id);
                          print('id: ${item.id}');
                        },
                        activeColor: Colors.grey.shade700, //لون المربع الداخلي
                        checkColor: Colors.white70, //لون علامة الصح
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          // color: Colors.grey.shade700, //لونالخط بشكل منفرد
                          decoration: item.isDone
                              ? TextDecoration
                                    .lineThrough //خط من خلال النص
                              : TextDecoration.none,
                          color:
                              item
                                  .isDone //لون النص بعد
                              ? Colors.grey
                              : Colors.grey.shade700,
                        ),
                      ),
                      subtitle: Text(
                        item.date.format(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          context.read<TodoCubit>().delete(item.id);
                        },
                        icon: Icon(Icons.close, color: Colors.grey.shade700),
                      ),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      onTap: () {
                        // context.read<TodoCubit>().update(item.title, item.id);
                        // print("Ontap");
                      },
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Title(
                color: Colors.grey.shade900,
                child: Text(
                  'Your remainig todos:${context.read<TodoCubit>().remaining()}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            Padding(
              //اظن هنا تتغير المقوله بين فتره وفتره
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('''"Doing what you loves is the cornerstone of having 
                abundance in your life. Wayne Dyer"'''),
            ),
          ],
        );
      },
    );
  }
}
