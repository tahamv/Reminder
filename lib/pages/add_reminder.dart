import 'package:flutter/material.dart';
import 'package:test_on_class/const/const.dart';
import 'package:test_on_class/model/reminder_model.dart';
import 'package:test_on_class/services/notification/local_notification.dart';
import 'package:timezone/timezone.dart' as tz;

class AddReminder extends StatefulWidget {
  const AddReminder({Key? key}) : super(key: key);

  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  TextEditingController controller = TextEditingController(text: "Reminder Name");
  TextEditingController timeController = TextEditingController(text: "18:33");
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Reminder"),
      ),
      body: Form(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("ReminderName:"),
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  fillColor: Colors.grey,
                  focusColor: Colors.grey,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.greenAccent), //<-- SEE HERE
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.greenAccent), //<-- SEE HERE
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("time:"),
                    Container(
                      child: TextFormField(
                        controller: timeController,
                        onTap: () async {
                          selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2024),
                          );
                          selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          timeController.text =
                              "${selectedDate?.year ?? ""}/${selectedDate?.month ?? ""}/${selectedDate?.day ?? ""} ${selectedTime?.hour ?? ""}:${selectedTime?.minute ?? ""}";
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                          fillColor: Colors.grey,
                          focusColor: Colors.grey,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Colors.greenAccent), //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Colors.greenAccent), //<-- SEE HERE
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Center(
                  child: ElevatedButton(
                onPressed: () async{
                  DateTime selectedDateTime = DateTime(selectedDate?.year??2020,selectedDate?.month??12,selectedDate?.day??20,selectedTime?.hour??20,selectedTime?.minute??20);
                  ReminderModel reminder = ReminderModel(name: controller.text, time: selectedDateTime);
                  reminder = await reminderProvider.insert(reminder);
                  LocalNotificationService.showNotificationScheduled(ReceivedNotification(id: reminder.id??0, title: reminder.name??"", body: reminder.name??"", payload: "", data: {}),tz.TZDateTime.from(reminder.time??DateTime.now(), tz.local));
                  Navigator.pop(context,);
                },
                child: Text("Add"),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
