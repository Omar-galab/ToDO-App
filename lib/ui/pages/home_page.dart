import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/pages/notification_screen.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/task_tile.dart';

import '../../models/task.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: _appBar(),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBare(),
            const SizedBox(
              height: 6,
            ),
            _showTasks(),
          ],
        ));
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          ThemeServices().switchThem();
        },
        icon: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined,
          size: 24,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
      ),
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      actions:  [
         IconButton( onPressed:() {
          notifyHelper.cancelAllNotification();
           _taskController.deletAllTasks();
           
         } ,icon:Icon(
         
               Icons.cleaning_services_outlined,
          size: 24,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        )),
        const CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHedlingStyle,
              ),
              Text(
                'Today',
                style: hedlingStyle,
              )
            ],
          ),
          MyButton(
            lable: '+Add Task',
            ontape: () async {
              await Get.to(const AddTaskPage());
              _taskController.getTasks();
            },
          )
        ],
      ),
    );
  }

  _addDateBare() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        initialSelectedDate: _selectedDate,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        )),
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        )),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        )),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.tasklist.isEmpty) {
          return _noTaskMsg();
        } else {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                var task = _taskController.tasklist[index];

                if (task.repeat == 'Daily' ||
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    (task.repeat == 'Weekly' &&
                        _selectedDate
                                    .difference(
                                        DateFormat.yMd().parse(task.date!))
                                    .inDays %
                                7 ==
                            0) ||
                    (task.repeat == 'Monthly' &&
                        DateFormat.yMd().parse(task.date!).day ==
                            _selectedDate.day)) {
                  /*var hour = task.startTime.toString().split(':')[0];
                  var minutes = task.startTime.toString().split(':')[1];
                  debugPrint('MY time is ' + hour);
                  debugPrint('My minute is' + minutes);
                  */

                  var date = DateFormat.jm().parse(task.startTime!);
                  var mytime = DateFormat('HH:mm').format(date);

                  notifyHelper.scheduledNotification(
                    int.parse(
                      mytime.toString().split(':')[0],
                    ),
                    int.parse(
                      mytime.toString().split(':')[1],
                    ),
                    task,
                  );
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 900),
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () => _showBottomSheet(
                            context,
                            task,
                          ),
                          child: TaskTile(
                            task: task,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
              itemCount: _taskController.tasklist.length,
            ),
          );
        }
      }),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 6,
                        )
                      : const SizedBox(
                          height: 220,
                        ),
                  SvgPicture.asset(
                    'images/task.svg',
                    color: primaryClr.withOpacity(0.5),
                    height: 90,
                    semanticsLabel: 'Task',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'You do not have any tasks yet!\nAdd new tasks to make your days productive.',
                      style: subTileStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 120,
                        )
                      : const SizedBox(
                          height: 180,
                        ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 0
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(children: [
          Flexible(
            child: Container(
              height: 10,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          task.isCompleted == 1
              ? Container()
              : _buildBottomSheet(
                  lable: 'Task compleated',
                  onTap: () {
                    notifyHelper.cancelNotification(task);
                    _taskController.markTsCompleted(task.id!);
                    Get.back();
                  },
                  clr: primaryClr,
                ),
          _buildBottomSheet(
            lable: 'Delete Task ',
            onTap: () async {
              // cancel the notification with id value of zero
              notifyHelper.cancelNotification(task);
              _taskController.deletTasks(task: task);
              Get.back();
            },
            clr: Colors.red[300]!,
          ),
          Divider(
            color: Get.isDarkMode ? Colors.grey : darkGreyClr,
          ),
          _buildBottomSheet(
            lable: 'Cancel',
            onTap: () {
              Get.back();
            },
            clr: primaryClr,
          ),
          const SizedBox(
            height: 20,
          )
        ]),
      ),
    ));
  }

  _buildBottomSheet({
    required String lable,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr,
            ),
            borderRadius: BorderRadius.circular(20),
            color: isClose ? Colors.transparent : clr),
        child: Center(
          child: Text(
            lable,
            style: isClose
                ? tileStyle
                : tileStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
