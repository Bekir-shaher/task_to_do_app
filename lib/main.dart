import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_to_do/cubit/todo_cubit.dart';
import 'package:task_to_do/screens/home_screen.dart';

void main() {
  runApp(BlocProvider(create:
   (context) => TodoCubit(), child: home_screen()));
}
