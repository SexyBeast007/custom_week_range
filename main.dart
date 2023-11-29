import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(children: [
            SizedBox(
              width: 400.0,
              child: CustomCalendarWidget(
                startDateMillis: DateTime.now().millisecondsSinceEpoch,
                endDateMillis: DateTime.now()
                    .add(Duration(days: 7))
                    .millisecondsSinceEpoch,
              ),
            ),
            SizedBox(
              width: 400.0,
              child: CustomCalendarWidget(
                startDateMillis: 1701432000000,
                endDateMillis: 1702036800000,
              ),
            ),
            SizedBox(
              width: 400.0,
              child: CustomCalendarWidget(
                startDateMillis: 1701518400000,
                endDateMillis: 1702123200000,
              ),
            ),
            SizedBox(
              width: 400.0,
              child: CustomCalendarWidget(
                startDateMillis: 1701604800000,
                endDateMillis: 1702209600000,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class CustomCalendarWidget extends StatelessWidget {
  final int startDateMillis;
  final int endDateMillis;

  CustomCalendarWidget({
    super.key,
    required this.startDateMillis,
    required this.endDateMillis,
  });

  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(startDateMillis);
    DateTime endDate = DateTime.fromMillisecondsSinceEpoch(endDateMillis);

    DateTime gridStart =
        startDate.subtract(Duration(days: startDate.weekday % 7));
    List<DateTime> dateList =
        List.generate(14, (index) => gridStart.add(Duration(days: index)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            DateFormat('MMMM').format(startDate),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.5,
            mainAxisSpacing: 10.0, // Space between rows
            crossAxisSpacing: 0.0,
          ),
          itemCount: dateList.length,
          itemBuilder: (context, index) {
            DateTime currentDate = dateList[index];
            bool isStartDay = currentDate.isAtSameMomentAs(startDate);
            bool isEndDay = currentDate.isAtSameMomentAs(endDate);
            bool isInRange =
                currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
            bool isEndOfWeek = index % 7 == 6;
            bool isStartOfWeek = index % 7 == 0;

            return DayWidget(
              currentDate: currentDate,
              isStartDay: isStartDay,
              isEndDay: isEndDay,
              isInRange: isInRange,
              isEndOfWeek: isEndOfWeek,
              isStartOfWeek: isStartOfWeek,
            );
          },
        ),
      ],
    );
  }
}

class DayWidget extends StatelessWidget {
  final DateTime currentDate;
  final bool isStartDay, isEndDay, isInRange, isEndOfWeek, isStartOfWeek;

  DayWidget({
    Key? key,
    required this.currentDate,
    required this.isStartDay,
    required this.isEndDay,
    required this.isInRange,
    required this.isEndOfWeek,
    required this.isStartOfWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isStartDay || isEndDay) {
      return _buildStartEndDay();
    } else if (isInRange) {
      return _buildInRangeDay();
    } else {
      return _buildRegularDay();
    }
  }

  Widget _buildStartEndDay() {
    bool isStartOfRange = isStartDay && !isEndDay;
    bool isEndOfRange = isEndDay && !isStartDay;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Green bar for start of the range
        if (isStartOfRange || (isStartDay && isStartOfWeek))
          Positioned(
            right: 0,  // Bar extends to the right
            child: Container(
              width: 32.5,
              height: 20.0,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topRight: isStartOfRange && isEndOfWeek ? Radius.circular(10) : Radius.zero,
                  bottomRight: isStartOfRange && isEndOfWeek ? Radius.circular(10) : Radius.zero,
                ),
              ),
            ),
          ),
        // Green bar for end of the range
        if (isEndOfRange || (isEndDay && isEndOfWeek))
          Positioned(
            left: 0,  // Bar extends to the left
            child: Container(
              width: 32.5,
              height: 20.0,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: isEndOfRange && isStartOfWeek ? Radius.circular(10) : Radius.zero,
                  bottomLeft: isEndOfRange && isStartOfWeek ? Radius.circular(10) : Radius.zero,
                ),
              ),
            ),
          ),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '${currentDate.day}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
}




  Widget _buildInRangeDay() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 20.0, // Explicitly setting the height
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.horizontal(
                  left: isStartOfWeek ? Radius.circular(10) : Radius.zero,
                  right: isEndOfWeek ? Radius.circular(10) : Radius.zero,
                ),
              ),
            ),
          ),
        ),
        Text(
          '${currentDate.day}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildRegularDay() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '${currentDate.day}',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}
