import 'package:flutter/material.dart';
import 'package:fitnes_trener/constants/routes.dart';
import 'package:fitnes_trener/services/auth/auth_exceptions.dart';
import 'package:fitnes_trener/services/auth/auth_service.dart';
import 'package:fitnes_trener/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        appBar: AppBar(
          title: Row(
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
              Text('Registruj se', textAlign: TextAlign.justify,style: TextStyle(fontWeight:FontWeight.bold, fontSize: 30),),
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
                      border: OutlineInputBorder(),
                      labelText: 'Email'),
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
                      border: OutlineInputBorder(),
                      labelText: 'Sifra'),
                ),
              ),
              SizedBox(
                width:20,
                height: 20,
              ),
              FloatingActionButton.extended(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await AuthService.firebase().createUser(
                      email: email,
                      password: password,
                    );
                    AuthService.firebase().sendEmailVerification();
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  } on WeakPasswordAuthException {
                    await showErrorDialog(
                      context,
                      'Sifra mora biti bar 6 karaktera dugacka',
                    );
                  } on EmailAlreadyInUseAuthException {
                    await showErrorDialog(
                      context,
                      'Email se vec koristi',
                    );
                  } on InvalidEmailAuthException {
                    await showErrorDialog(
                      context,
                      'Email adresa nije pravilno formirana',
                    );
                  } on GenericAuthException {
                    await showErrorDialog(
                      context,
                      'Registracija nije uspela',
                    );
                  }
                },
                label: Text('Register'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                        (route) => false,
                  );
                },
                child: const Text('Vec ste registrovani? Uloguj se ovde!'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

