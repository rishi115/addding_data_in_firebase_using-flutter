import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CollectionReference messagesRef =
  FirebaseFirestore.instance.collection('messages');
  final TextEditingController _messageController = TextEditingController();

  Future<void> addMessage(String message) async {
    await messagesRef.add({
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firestore Demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Enter a message',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Add Message'),
                onPressed: () {
                  addMessage(_messageController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Message added to Firestore'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
