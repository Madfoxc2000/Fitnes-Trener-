import 'package:flutter/material.dart';
import 'package:fitnes_trener/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Odjavi se',
    content: 'Da li ste sigurni da zelite da se odjavite ?',
    optionsBuilder: () => {
      'Odustani': false,
      'Odjavi se': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
