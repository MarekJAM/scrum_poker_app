import 'package:flutter/material.dart';

class PlanningScreen extends StatelessWidget {
  static const routeName = '/planning';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    Map<String, int> users = {
      'John': 5,
      'Andrew': 2,
      'Tim': 3,
      'Samuel': 4,
      'Pit': 5,
      'Michael': 6,
      'Alex': 4,
    };

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Row(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = users.keys.elementAt(index);
                  return Card(
                    child: ListTile(
                      title: Text("$key"),
                      trailing: Text("${users[key]}"),
                    ),
                  );
                },
              ),
            ),
            VerticalDivider(),
            Container(
              width: deviceSize.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Task: CS-512',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text('Average: 4.5'),
                  Text('Median: 4'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
