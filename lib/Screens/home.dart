import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_flutter/Screens/addNote.dart';
import 'dart:math' as math;

import 'package:notes_app_flutter/Screens/viewNote.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Query ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('notes')
      .orderBy('created', descending: true);
  List<Color> myColors = [
    Colors.yellow[200],
    Colors.red[200],
    Colors.green[200],
    Colors.deepPurple[200],
    Colors.purple[200],
    Colors.cyan[200],
    Colors.teal[200],
    Colors.tealAccent[200],
    Colors.pink[200],
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Sticky Notes',
          style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'lato',
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Color(0xff070706),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: ref.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  Color backgrounColor = myColors[Random().nextInt(8)];
                  Map data = snapshot.data.docs[index].data();
                  DateTime myDateTime = data['created'].toDate();
                  String timeString =
                      DateFormat.yMMMd().add_jm().format(myDateTime);
                  return InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => ViewNote(
                                    data,
                                    timeString,
                                    snapshot.data.docs[index].reference,
                                  )))
                          .then((value) {
                        setState(() {});
                      });
                    },
                    child: Card(
                      color: backgrounColor,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${data['title']}',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 24,
                                    fontFamily: 'lato',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                timeString,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                    fontFamily: 'lato',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return Text('Loading');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddNote()))
              .then((value) {
            setState(() {
              print('CCC');
            });
          });
        },
        child: Icon(
          Icons.note_add,
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[700],
      ),
    );
  }
}
