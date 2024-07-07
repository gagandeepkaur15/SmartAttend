import 'package:flutter/material.dart';
import 'package:nami_task/widgets/app_bar.dart';
import 'package:nami_task/widgets/back_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/primary_button.dart';

class AttendanceScreen extends StatefulWidget {
  final String course;
  const AttendanceScreen({super.key, required this.course});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final String location = "LH 121";
  final String time = "11 AM";

  // Value selected from dropdown
  String? _selectedValue;

  // Otions of dropdown
  final List<String> _dropdownItems = [
    'Last 30 Days',
    'Last week',
    'Last 2 days',
    'Today'
  ];

  //Dates on which attendance taken
  final List<String> _dates = [
    "12 June 2024",
    "14 June 2024",
    "15 June 2024",
    "16 June 2024",
    "17 June 2024",
  ];

  //Days on which attendance taken
  final List<String> _days = [
    "Monday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  //Attendance on mentioned days
  final List<String> _attendance = [
    "Present",
    "Present",
    "Absent",
    "Present",
    "Present",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leftWidget: MyBackButton(
          myContext: context,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.course,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Icon(
                  Icons.location_on_sharp,
                  color: Theme.of(context).primaryColor,
                  size: 20.sp,
                ),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.timer,
                  color: Theme.of(context).primaryColor,
                  size: 20.sp,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(height: 5.h),

            // button hero
            const Hero(
              tag: "button",
              child: PrimaryButton(text: "Mark Attendance"),
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Attendance history",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "and statistics",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

                // Drop Down
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    border: Border.all(color: Colors.black),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedValue,
                    hint: Text(
                      'Last 30 Days',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    items: _dropdownItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue = newValue;
                      });
                    },
                    underline: const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),

            //Header Row
            Container(
              width: 100.w,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              margin: EdgeInsets.only(bottom: 0.5.h),
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Row(
                children: [
                  Text(
                    "Date",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(width: 27.w),
                  Text(
                    "Day",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Text(
                    "Attendance",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            ),

            //Attendance Data Rows
            Expanded(
              child: ListView.builder(
                  itemCount: _days.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: 100.w,
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.w, vertical: 0.8.h),
                      margin: EdgeInsets.only(bottom: 0.5.h),
                      decoration: BoxDecoration(
                        color: _attendance[index] == "Present"
                            ? Theme.of(context).indicatorColor
                            : const Color(0xffFFE3E3),
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _dates[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _days[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _attendance[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Center(
              // bottom text hero
              child: Hero(
                tag: 'bottomTextHero',
                child: Text("Powered by Lucify",
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
