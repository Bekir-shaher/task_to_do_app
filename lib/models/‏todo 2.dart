class Todo {
  //اعتقد يكونوا من نوع nullbale
  late int id;
  late String title;
  late bool isDone = false;
  late DateTime date;
  //لاحقاً
  Todo({
    required this.title,
    required this.id,
    this.isDone = false,
    required this.date,
  }); //يجب تمرير isDone

  //نحويل البيانات الى json code
  // Map<String, dynamic> toJson() => {}; syntax
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isDone': isDone,
    'date': date,
  };

  //تحويل json code الى كائن
  factory Todo.fromJson(Map<String, dynamic> json) =>
      Todo(title: json['title'], id: json['id'], date: json['date']);
}
