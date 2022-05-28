import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
//import 'dart:developer' as devtools show log; //to log. used instead of print

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); //This is for firebase initialization. Using this makes sure its initialized everytime for use
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteView: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //This needs to be imported above and written here before authentication
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        //nsapshot can be used to get the results of future
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            //final emailVerified = user?.emailVerified ?? false;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          //Show a view here
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => const VerifyEmailView(),
          //   ),
          // );  //This is how to push a view

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
