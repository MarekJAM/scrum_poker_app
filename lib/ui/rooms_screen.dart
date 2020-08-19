import 'package:flutter/material.dart';
import 'package:scrum_poker_app/main.dart';

class RoomsScreen extends StatelessWidget {
  static const routeName = '/rooms';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    List<String> rooms = [
      'Room 1',
      'Room 2',
      'Room 3',
      'Room 4',
      'Room 7 and 3/4',
      'There is no room 5 and 6',
      'Room whatever',
      'Room whatever',
      'Room whatever',
      'Room whatever',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Scrum Poker'),
      ),
      drawer: Text('placeholder'),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (ctx, int i) => Card(
                  child: ListTile(
                    title: Text(rooms[i]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('+', style: TextStyle(fontSize: 35),),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Room name"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text("Create"),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
