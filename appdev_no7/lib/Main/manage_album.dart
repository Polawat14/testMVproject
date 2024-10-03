import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CreateAlbumScreen extends StatefulWidget {
  @override
  _CreateAlbumScreenState createState() => _CreateAlbumScreenState();
}


class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
  final TextEditingController _albumNameController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref(); // สร้างอินสแตนซ์ของ Realtime Database
  final User? _user = FirebaseAuth.instance.currentUser; // ดึงข้อมูลผู้ใช้ที่ล็อกอินอยู่

  void _addAlbum() async {
    final albumName = _albumNameController.text.trim(); // ใช้ trim() เพื่อลบช่องว่างข้างหน้าและข้างหลัง
    if (albumName.isNotEmpty && _user != null && _user!.email != null) { // ตรวจสอบว่าผู้ใช้ล็อกอินอยู่และมีอีเมล
      // เพิ่มข้อมูลอัลบั้มใน Realtime Database โดยใช้ push() เพื่อสร้าง key แบบสุ่ม
      await _database.child('albums').child(albumName).set({
        'created_at': DateTime.now().toIso8601String(), // เก็บวันที่และเวลา
        'user_email': _user!.email, // เก็บอีเมลของผู้ใช้
      });

      print('Album added by user: ${_user!.email}');
      _albumNameController.clear(); // ล้างช่องกรอกชื่อหลังจากเพิ่ม
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
            const SizedBox(height: 20), // ระยะห่างก่อนปุ่ม
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