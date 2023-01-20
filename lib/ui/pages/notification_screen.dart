import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

import '../theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    Key? key,
    required this.payload,
  }) : super(key: key);
  final String payload;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (() => Get.back()),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: primaryClr,
          ),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        centerTitle: true,
        title: Text(
          _payload.toString().split('|')[0],
          style: TextStyle(
              color: Get.isDarkMode ? Colors.white : darkGreyClr, fontSize: 25),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          //up columen
          Column(
            children: [
              Text(
                'Hello GLAB',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Get.isDarkMode ? Colors.white : darkGreyClr,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'You have new reminder',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Get.isDarkMode ? Colors.white : darkGreyClr,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          //main build Expanded
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: primaryClr,
              ),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //firist row
                  Row(
                    children: const [
                      Icon(
                        Icons.text_format,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Title discra
                  Text(
                    _payload.toString().split('|')[0],
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //soucend row
                  Row(
                    children: const [
                      Icon(
                        Icons.description,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Descrabtion
                  Text(
                    _payload.toString().split('|')[0],
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //3TH row
                  Row(
                    children: const [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  //Date discrab
                  Text(
                    _payload.toString().split('|')[0],
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              )),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      )),
    );
  }
}
