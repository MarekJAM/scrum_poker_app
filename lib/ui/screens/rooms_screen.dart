import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/rooms/bloc.dart';
import '../../ui/widgets/app_drawer.dart';
import 'screens.dart';

class RoomsScreen extends StatelessWidget {
  static const routeName = '/rooms';
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => RoomsScreen());
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    TextEditingController _roomController =
        TextEditingController();
    final _formKey = GlobalKey<FormState>();

    List<String> rooms = [];

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
              child: BlocConsumer<RoomsBloc, RoomsState>(
                listener: (ctx, state) {
                  if (state is RoomsLoadingError) {
                    Scaffold.of(ctx).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(ctx).errorColor,
                        content: Text(state.message),
                      ),
                    );
                  } else if (state is RoomsConnectedToRoom) {
                    Navigator.of(context)
                        .pushReplacementNamed(PlanningScreen.routeName);
                  }
                },
                buildWhen: (_, state) {
                  if (state is RoomsLoaded ||
                      state is RoomsLoading ||
                      state is RoomsLoadingError) {
                    return true;
                  } else {
                    return false;
                  }
                },
                builder: (_, state) {
                  if (state is RoomsLoaded) {
                    rooms = state.rooms.roomList;
                    return rooms.length > 0
                        ? ListView.builder(
                            itemCount: rooms.length,
                            itemBuilder: (ctx, int i) => Card(
                              child: ListTile(
                                title: Text(rooms[i]),
                                onTap: () {
                                  BlocProvider.of<RoomsBloc>(context).add(
                                    RoomsConnectToRoomE(rooms[i]),
                                  );
                                },
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
                  } else if (state is RoomsLoadingError) {
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
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Room name"),
                              controller: _roomController,
                              validator: (value) {
                                if (rooms.contains(value)) {
                                  return "Room with that name already exists.";
                                } else if (value.isEmpty) {
                                  return "Provide room name.";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BlocBuilder<RoomsBloc, RoomsState>(
                              builder: (_, state) {
                                return Column(
                                  children: [
                                    state is RoomsConnectionWithRoomError
                                        ? Container(
                                            child: Text(
                                              state.message,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .errorColor),
                                            ),
                                          )
                                        : Container(),
                                    state is RoomsConnectingToRoom
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : RaisedButton(
                                            child: Text("Create"),
                                            onPressed: () {
                                              if (_formKey.currentState.validate()) {
                                              BlocProvider.of<RoomsBloc>(
                                                      context)
                                                  .add(
                                                RoomsCreateRoomE(
                                                  _roomController.text,
                                                ),
                                              );
                                              }
                                            },
                                          ),
                                  ],
                                );
                              },
                            ),
                          ),
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
