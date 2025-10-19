part of 'todo_cubit.dart';

@immutable
sealed class TodoState {
  final List<Todo> todo;
  TodoState(this.todo);
}

final class TodoInitial extends TodoState {
  TodoInitial() : super([]);
}

final class TodoUpdate extends TodoState {
  TodoUpdate(super.todo);
}

final class TodoLoading extends TodoState {//حالة الانتظار عند التهئة والحفظ والتحميل
  TodoLoading() : super([]);
}
