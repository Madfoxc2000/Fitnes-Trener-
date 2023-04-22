import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PretragaStranica extends StatelessWidget {
  const PretragaStranica({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pretraga',
      theme: ThemeData(
          primarySwatch: Colors.grey,
          // ignore: deprecated_member_use
          accentColor: Colors.grey),
      debugShowCheckedModeBanner: false,
      home: const PretraziStranica(),
    );
  }
}

class PretraziStranica extends StatefulWidget {
  const PretraziStranica({Key? key}) : super(key: key);

  @override
  State<PretraziStranica> createState() => _PretraziStranicaState();
}

class _PretraziStranicaState extends State<PretraziStranica> {
  List searchResult = [];

  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('notes')
        .where('pretraga', arrayContains: query)
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  void filter(String value) async {
    //final int? number = int.tryParse(value);
    final result = await FirebaseFirestore.instance
        .collection('notes')
        .where('text', isEqualTo: value)
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Pretraga",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              child: Card(
                color: Colors.white,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Filtriraj po vezbi:",
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0
                          )
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)
                      )
                  ),
                  onChanged: (value) {
                    filter(value);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                color: Colors.white,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Pretraži po imenu",
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0
                          )
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)
                      )
                  ),
                  onChanged: (query) {
                    searchFromFirebase(query);
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResult.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.lightBlue,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      textColor: Colors.black,
                      title: Text(
                        'Ime: '+ searchResult[index]['naziv_sportiste'],
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text ('Naziv vezbe: ' +searchResult[index]['text'] +
                          '\n' +
                          'Broj ponavljanja: ' +
                          searchResult[index]['broj_ponavljanja'].toString() +
                          ' ',
                          style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}