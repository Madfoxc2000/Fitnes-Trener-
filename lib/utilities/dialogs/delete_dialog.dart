import 'package:flutter/material.dart';
import 'package:fitnes_trener/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Da li ste sigurni da zelite obrisati ovaj zapis?',
    optionsBuilder: () => {
      'Odustani': false,
      'Da': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
