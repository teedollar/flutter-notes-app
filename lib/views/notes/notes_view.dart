import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  //Get user email
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    //_notesService.open; //Each function already does this
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteView);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  //devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    await AuthService.firebase().logout();
                    //Route user to login
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Logout')),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                //return const Text("Helloooooo");
                //Note FutureBuider can be done, but StreamBuilder always remain in waiting state
                return StreamBuilder(
                    //StreamBuilder will be used to list the notes to UI
                    stream: _notesService.allNotes,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        //return const Text("Hello");
                        case ConnectionState.active:
                          //return const Text("Stuff are here");
                          if (snapshot.hasData) {
                            final allNotes =
                                snapshot.data as List<DatabaseNote>;
                            //print(allNotes);
                            //return const Text("Data should be here ");
                            return NotesListView(
                              notes: allNotes,
                              onDeleteNote: (note) async {
                                await _notesService.deleteNote(id: note.id);
                              },
                              onTap: (note) async {
                                Navigator.of(context).pushNamed(
                                  createOrUpdateNoteView,
                                  arguments: note,
                                );
                              },
                            );
                          } else {
                            return const Text("This is the else statement");
                            //return const CircularProgressIndicator();
                          }
                        default:
                          //return const CircularProgressIndicator();
                          return const Text("On the inside switch default");
                      }
                    });
              default:
                return const Text("Still on the outer switch");
              //return const CircularProgressIndicator();
            }
          }),
    );
  }
}
