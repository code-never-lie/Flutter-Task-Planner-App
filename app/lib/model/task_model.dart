class Task {
  String task;
  DateTime time;
  Task(this.task, this.time);

  factory Task.fromString(String task) {
    return Task(task, DateTime.now());
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(map['task'], DateTime.fromMicrosecondsSinceEpoch(map['time']));
  }

  Map<String, dynamic> getMap() {
    return {
      'task': task,
      'time': time.microsecondsSinceEpoch,
    };
  }

  get getTask => task;

  set setTask(task) => this.task = task;

  get getTime => time;

  set setTime(time) => this.time = time;
}
