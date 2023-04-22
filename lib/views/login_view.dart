import 'package:flutter/material.dart';
import 'package:fitnes_trener/constants/routes.dart';
import 'package:fitnes_trener/services/auth/auth_exceptions.dart';
import 'package:fitnes_trener/services/auth/auth_service.dart';
import 'package:fitnes_trener/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset : false,
        backgroundColor: Colors.white,
        appBar: AppBar( title: Row(
          children: [
            Center(child: Text("Fitnes Trener")),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.sports_gymnastics,
                color: Colors.white,
                size: 30.0, ),
            )
          ],
        ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 20,
                height: 20,
              ),
              Text('Uloguj se', textAlign: TextAlign.justify,style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold, fontSize: 30),),
              SizedBox(
                width: 20,
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Sifra'),
                ),
              ),
              SizedBox(
                width: 20,
                height: 20,
              ),
              FloatingActionButton.extended(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await AuthService.firebase().logIn(
                      email: email,
                      password: password,
                    );
                    final user = AuthService.firebase().currentUser;
                    if (user?.isEmailVerified ?? false) {
                      // user's email is verified
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        notesRoute,
                        (route) => false,
                      );
                    } else {
                      // user's email is NOT verified
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute,
                        (route) => false,
                      );
                    }
                  } on UserNotFoundAuthException {
                    await showErrorDialog(
                      context,
                      'Korisnik sa ovim podacima ne postoji',
                    );
                  } on WrongPasswordAuthException {
                    await showErrorDialog(
                      context,
                      'Pogresna sifra',
                    );
                  } on GenericAuthException {
                    await showErrorDialog(
                      context,
                      'Greska autorizacije',
                    );
                  }
                },
                label: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                    (route) => false,
                  );
                },
                child: const Text('Niste registrovani? Registruj se ovde!'),
              ),
              SizedBox(
                width: 20,
                height: 12,
              ),
              Image.asset('assets/images/trainer.png'),
            ],
          ),
        ),
      ),
    );
  }
}
