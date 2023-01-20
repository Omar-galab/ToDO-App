import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> tasklist = <Task>[].obs;

  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task);
  }

  //get
  Future<void> getTasks() async {
    final tasks = await DBHelper.query();
    tasklist.assignAll(tasks.map((element) => Task.fromJson(element)).toList());
  }

  void deletTasks({Task? task}) async {
    final tasks = await DBHelper.query();
    await DBHelper.delete(task!);
    getTasks();
  }

  void markTsCompleted(int id) async {
    final tasks = await DBHelper.query();
    await DBHelper.update(id);
    getTasks();
  }
  void deletAllTasks()async{
    await DBHelper.deleteAll();
    getTasks();
  }
}
