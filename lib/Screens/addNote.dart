import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String title, description;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 20,
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey[700])),
                    ),
                    ElevatedButton(
                      onPressed: saveToFirebase,
                      child: Icon(
                        Icons.save,
                        size: 20,
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey[700])),
                    )
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration:
                            InputDecoration.collapsed(hintText: "Title"),
                        onChanged: (val) {
                          title = val;
                        },
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 32,
                            fontFamily: 'lato',
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: TextFormField(
                          decoration: InputDecoration.collapsed(
                              hintText: "Description"),
                          onChanged: (val) {
                            description = val;
                          },
                          maxLines: 20,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontFamily: 'lato',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveToFirebase() {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('notes');
    var data = {
      'title': title,
      'description': description,
      'created': DateTime.now(),
    };
    ref.add(data);
    Navigator.pop(context);
  }
}
