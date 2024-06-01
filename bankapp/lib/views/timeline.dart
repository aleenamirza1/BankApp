import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeLineMonth extends StatefulWidget {
  const TimeLineMonth({super.key});

  @override
  State<TimeLineMonth> createState() => _TimeLineMonthState();
}

class _TimeLineMonthState extends State<TimeLineMonth> {
  String currentMonth = "";
  List<String> months = [];
  final scrollController = ScrollController();
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    for (int i = -18; i <= 0; i++) {
      months.add(DateFormat('MMM y').format(DateTime(
        now.year,
        now.month + i,
        1,
      )));
    }
    currentMonth = DateFormat("MMM y").format(now);

    Future.delayed(Duration(seconds: 1), () {
      ScrollToSelectMonth();
    });
  }

  ScrollToSelectMonth() {
    final SelectedMonthIndex = months.indexOf(currentMonth);
    if (SelectedMonthIndex != -1) {
      final scrollOffset = (SelectedMonthIndex * 100.0) - 170;
      scrollController.animateTo(scrollOffset,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.builder(
          controller: scrollController,
          itemCount: months.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentMonth = months[index];
                });
                ScrollToSelectMonth();
              },
              child: Container(
                width: 80,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: currentMonth == months[index]
                        ? Colors.blue
                        : Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                  months[index],
                  style: TextStyle(
                    color: currentMonth == months[index]
                        ? Colors.white
                        : Colors.purple,
                  ),
                )),
              ),
            );
          }),
    );
  }
}
