import 'package:flutter/material.dart';
import 'package:test_on_class/model/reminder_model.dart';

class ReminderItem extends StatelessWidget {
  const ReminderItem({Key? key,required this.reminder, required this.onDeleteTap}) : super(key: key);
  final ReminderModel reminder;
  final Function(ReminderModel) onDeleteTap;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      height: 100,
      width: width,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(reminder.name ?? "-"),
              Text(
                  "${reminder.time?.year ?? ""}/${reminder.time?.month ?? ""}/${reminder.time?.day ?? ""} ${reminder.time?.hour ?? ""}:${reminder.time?.minute ?? ""}")
            ],
          ),
          InkWell(
            onTap: (){
              onDeleteTap(reminder);
            },
              child: Icon(Icons.delete_forever,size: 30,))
        ],
      ),
    );
  }
}
