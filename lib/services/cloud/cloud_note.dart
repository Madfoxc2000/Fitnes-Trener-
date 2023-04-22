import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnes_trener/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final String brojPonavljanja;
  final String nazivSportiste;
  final List listaPretraga;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.brojPonavljanja,
    required this.nazivSportiste,
    required this.listaPretraga,

  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String,
        brojPonavljanja = snapshot.data()[textFieldBrojPonavljanja] as String,
        nazivSportiste = snapshot.data()[textFieldNazivSportiste] as String,
        listaPretraga = snapshot.data()["pretraga"];
}
