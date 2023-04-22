import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnes_trener/services/cloud/cloud_note.dart';
import 'package:fitnes_trener/services/cloud/cloud_storage_constants.dart';
import 'package:fitnes_trener/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');
  

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
    required String brojPonavljanja,
    required String nazivSportiste,
    required List listapretraga,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text, textFieldBrojPonavljanja: brojPonavljanja, textFieldNazivSportiste: nazivSportiste, "pretraga": listapretraga });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId, required bool sortiraj, }) {
    bool _sortAscending = sortiraj;
  final notes = FirebaseFirestore.instance.collection('notes').orderBy('broj_ponavljanja', descending: !_sortAscending);
      return notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));
      
  }


  


  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
      textFieldBrojPonavljanja: '',
      textFieldNazivSportiste: '',
      "pretraga" : [],
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
      brojPonavljanja: '',
      nazivSportiste: '',
      listaPretraga: [],
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
