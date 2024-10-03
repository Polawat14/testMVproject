import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CreateAlbumScreen extends StatefulWidget {
  @override
  _CreateAlbumScreenState createState() => _CreateAlbumScreenState();
}


class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
  final TextEditingController _albumNameController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref(); 
  final User? _user = FirebaseAuth.instance.currentUser;

  void _addAlbum() async {
    final albumName = _albumNameController.text.trim();
    if (albumName.isNotEmpty && _user != null && _user!.email != null) {
      final String userUid = _user!.uid;  // ใช้ uid ของผู้ใช้
      final String? displayName = _user!.displayName ?? _user!.email;  // ใช้ displayName หรือ email ถ้า displayName ไม่มี

      // เพิ่มข้อมูลอัลบั้มใน Realtime Database ภายใต้ userUid
      await _database.child('users').child(userUid).child(albumName).set({
        'created_at': DateTime.now().toIso8601String(),
        'user_email': _user!.email,
      });

      print('Album added by user: $displayName');
      _albumNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Album'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _albumNameController,
              decoration: const InputDecoration(labelText: 'Album Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addAlbum,
              child: const Text('Add Album'),
            ),
          ],
        ),
      ),
    );
  }
}