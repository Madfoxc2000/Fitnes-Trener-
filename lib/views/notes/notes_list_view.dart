import 'package:flutter/material.dart';
import 'package:fitnes_trener/services/cloud/cloud_note.dart';
import 'package:fitnes_trener/utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);

        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            'Naziv vezbe: '+note.text +'\nIme sportiste: '+ note.nazivSportiste +"\nBroj ponavljanja: "+note.brojPonavljanja,
            maxLines: 3,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),

          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
