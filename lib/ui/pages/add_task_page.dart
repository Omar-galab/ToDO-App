// ignore_for_file: prefer_final_fields, unused_field, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _notecontroller = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 0;
  List<int> remindList = [0, 5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Text(
              'Add Task',
              style: hedlingStyle,
            ),
            InputField(
              title: 'Title',
              hint: 'Enter title here',
              controller: _titlecontroller,
            ),
            InputField(
              title: 'Note',
              hint: 'Enter note here',
              controller: _notecontroller,
            ),
            InputField(
              title: 'Date',
              hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                onPressed: () => _getDateFromUser(),
                icon: const Icon(Icons.calendar_month_outlined),
                color: Colors.grey,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    title: 'Start Time',
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: () => _getTimeFromUser(isStartTime: true),
                      icon: const Icon(Icons.access_time_filled),
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: InputField(
                    title: 'End Time',
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: () => _getTimeFromUser(isStartTime: false),
                      icon: const Icon(Icons.access_time_filled),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            InputField(
              title: 'Remind',
              hint: '$_selectedRemind minutes early',
              widget: Row(
                children: [
                  DropdownButton(
                    dropdownColor: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                    items: remindList
                        .map<DropdownMenuItem<String>>(
                            (int value) => DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(
                                  '$value',
                                  style: const TextStyle(color: Colors.white),
                                )))
                        .toList(),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    underline: Container(height: 0),
                    style: subTileStyle,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                  ),
                  const SizedBox(
                    width: 6,
                  )
                ],
              ),
            ),
            InputField(
              title: 'Repeat',
              hint: _selectedRepeat,
              widget: Row(
                children: [
                  DropdownButton(
                    dropdownColor: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                    items: repeatList
                        .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(
                                  value,
                                  style: const TextStyle(color: Colors.white),
                                )))
                        .toList(),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    underline: Container(height: 0),
                    style: subTileStyle,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 6,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _colorPalette(),
                MyButton(
                    lable: 'Create Task',
                    ontape: () {
                      _validateDate();
                    })
              ],
            )
          ],
        )),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: (() => Get.back()),
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: primaryClr,
        ),
      ),
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  _validateDate() {
    if (_titlecontroller.text.isNotEmpty && _notecontroller.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_titlecontroller.text.isNotEmpty ||
        _notecontroller.text.isNotEmpty) {
      Get.snackbar('required', 'All fields are required',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    } else {
      print('####### SOMTHING BAD HAPPEND #########');
    }
  }

  _addTasksToDb() async {
    try {
      int value = await _taskController.addTask(
        task: Task(
          title: _titlecontroller.text,
          note: _notecontroller.text,
          isCompleted: 0,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          color: _selectedColor,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
        ),
      );

      print(value);
    } catch (e) {
      print('Error');
    }
  }

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: tileStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
            children: List<Widget>.generate(
          3,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: index == 0
                    ? primaryClr
                    : index == 1
                        ? pinkClr
                        : orangeClr,
                radius: 14,
                child: _selectedColor == index
                    ? const Icon(
                        Icons.done,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
        ))
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    } else {
      print('It\'s null or somthing is wrong');
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
    );
    String _formatedTime = _pickedTime!.format(context);
    if (isStartTime) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = _formatedTime;
      });
    } else {
      print('ERROR');
    }
  }
}
