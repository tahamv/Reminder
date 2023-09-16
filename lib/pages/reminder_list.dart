import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_on_class/const/const.dart';
import 'package:test_on_class/model/reminder_model.dart';
import 'package:test_on_class/pages/add_reminder.dart';
import 'package:test_on_class/widgets/reminder_item.dart';

class ReminderList extends StatefulWidget {
  const ReminderList({Key? key}) : super(key: key);

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  List<ReminderModel> reminders = [];
  bool isLoading = true;

  void readDatabase()async{
    setState(() {
      isLoading = true;
    });
    reminders = await reminderProvider.getAll()??[];
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    readDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Reminder App"),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            return ReminderItem(
              reminder: reminders[index],
              onDeleteTap: (reminder) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Warning'),		 // To display the title it is optional
                      content: Text('Are you sure you want to delete this reminder'), // Message which will be pop up on the screen
                      // Action widget which will provide the user to acknowledge the choice
                      actions: [
                        ElevatedButton(					 // FlatButton widget is used to make a text to work like a button
                          onPressed: () {
                            Navigator.pop(context);
                          },			 // function used to perform after pressing the button
                          child: Text('CANCEL'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              reminderProvider.delete(reminder.id??0);
                              reminders.remove(reminder);
                            });
                            Navigator.pop(context);

                          },
                          child: const Text('DELETE'),
                        ),
                      ],
                    );
                  },
                );



              },
            );
          }),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddReminder()),
          );
          reminders = await reminderProvider.getAll()??[];
          setState(() {

          });

        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
