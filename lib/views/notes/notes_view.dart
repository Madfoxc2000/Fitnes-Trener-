import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fitnes_trener/constants/routes.dart';
import 'package:fitnes_trener/enums/menu_action.dart';
import 'package:fitnes_trener/services/auth/auth_service.dart';
import 'package:fitnes_trener/services/cloud/cloud_note.dart';
import 'package:fitnes_trener/services/cloud/firebase_cloud_storage.dart';
import 'package:fitnes_trener/utilities/dialogs/logout_dialog.dart';
import 'package:fitnes_trener/views/notes/notes_list_view.dart';

import '../../services/cloud/funkcije.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  bool _sortAscending = false;
  late Query _query;


  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }
  final CollectionReference _notes =
  FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izvedene vezbe',style:TextStyle( fontSize: 18), ),
        actions: [
          IconButton(
            icon: _sortAscending ? Icon(Icons.arrow_upward) : Icon(Icons.arrow_downward),
            color: Colors.white,
            onPressed: (){
              setState(() {
                _sortAscending = !_sortAscending;
                _query = _notes.orderBy('broj_ponavljanja', descending: !_sortAscending);
              });
            },
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PretraziStranica()),
              );
            },
            icon: const Icon(Icons.search),
          ),

          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Odjavi se'),
                ),
              ];
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId, sortiraj: _sortAscending,),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
