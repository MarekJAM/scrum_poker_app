import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/rooms/bloc.dart';
import 'package:scrum_poker_app/ui/widgets/app_drawer.dart';
import 'screens.dart';

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
        title: Text('Rooms'),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: BlocBuilder<RoomsBloc, RoomsState>(
                builder: (_, state) {
                  if (state is RoomsLoaded) {
                    return state.rooms.roomList.length > 0
                        ? ListView.builder(
                            itemCount: state.rooms.roomList.length,
                            itemBuilder: (ctx, int i) => Card(
                              child: ListTile(
                                title: Text(state.rooms.roomList[i]),
                                onTap: () => Navigator.of(context)
                                    .pushNamed(PlanningScreen.routeName),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              'There are no available rooms at the moment.\nWhy don\'t you create one?',
                              textAlign: TextAlign.center,
                            ),
                          );
                  } else if (state is RoomsLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is RoomsError) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          '+',
          style: TextStyle(fontSize: 35),
        ),
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
