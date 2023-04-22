import 'package:flutter/material.dart';
import 'package:fitnes_trener/services/auth/auth_service.dart';
import 'package:fitnes_trener/utilities/generics/get_arguments.dart';
import 'package:fitnes_trener/services/cloud/cloud_note.dart';
import 'package:fitnes_trener/services/cloud/cloud_storage_exceptions.dart';
import 'package:fitnes_trener/services/cloud/firebase_cloud_storage.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  _CreateUpdateNoteViewState createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;
  late final TextEditingController _brojPonavljanja;
  late final TextEditingController _imeSportiste;


  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    _brojPonavljanja = TextEditingController();
    _imeSportiste = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    final text2 = _brojPonavljanja.text;
    final text3 = _imeSportiste.text;
    List searchList = [];
    for (var i = 1; i <= text3.length; i++) {
      var nextEl = text3.substring(0, i).toLowerCase();
      searchList.add(nextEl);
      nextEl = text3.substring(0, i);
      searchList.add(nextEl);
      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
        brojPonavljanja: text2,
        nazivSportiste: text3,
        listapretraga: searchList,
      );
    }
  }
    void _setupTextControllerListener() {
      _textController.removeListener(_textControllerListener);
      _textController.addListener(_textControllerListener);
    }

    Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
      final widgetNote = context.getArgument<CloudNote>();

      if (widgetNote != null) {
        _note = widgetNote;
        _textController.text = widgetNote.text;
        _brojPonavljanja.text = widgetNote.brojPonavljanja;
        _imeSportiste.text = widgetNote.nazivSportiste;
        return widgetNote;
      }

      final existingNote = _note;
      if (existingNote != null) {
        return existingNote;
      }
      final currentUser = AuthService
          .firebase()
          .currentUser!;
      final userId = currentUser.id;
      final newNote = await _notesService.createNewNote(ownerUserId: userId);
      _note = newNote;
      return newNote;
    }

    void _deleteNoteIfTextIsEmpty() {
      final note = _note;
      if (_textController.text.isEmpty && note != null) {
        _notesService.deleteNote(documentId: note.documentId);
      }
    }

    void _saveNoteIfTextNotEmpty() async {
      final note = _note;
      final text = _textController.text;
      final text2 = _brojPonavljanja.text;
      final text3 = _imeSportiste.text;
      List searchList = [];
      for (var i = 1; i <= text3.length; i++) {
        var nextEl = text3.substring(0, i).toLowerCase();
        searchList.add(nextEl);
        nextEl = text3.substring(0, i);
        searchList.add(nextEl);
      }
      if (note != null && text.isNotEmpty) {
        await _notesService.updateNote(
          documentId: note.documentId,
          text: text,
          brojPonavljanja: text2,
          nazivSportiste: text3,
          listapretraga: searchList,
        );
      }
    }

    @override
    void dispose() {
      _deleteNoteIfTextIsEmpty();
      _saveNoteIfTextNotEmpty();
      _textController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nova vezba'),
        ),
        body: FutureBuilder(
          future: createOrGetExistingNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setupTextControllerListener();
                return Scaffold(
                  body: Column(
                    children: [


                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        child: TextField(
                          controller: _textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Naziv vezbe',
                            hintText: 'Naziv vezbe...',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        child: TextField(
                          controller: _brojPonavljanja,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Broj ponavljanja',
                            hintText: 'Broj ponavljanja ...',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        child: TextField(
                          controller: _imeSportiste,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Ime sportiste',
                            hintText: 'Ime sportiste...',
                          ),
                        ),
                      ),
                    ],
                  ),

                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      );
    }
  }