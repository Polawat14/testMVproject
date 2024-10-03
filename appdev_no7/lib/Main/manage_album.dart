import 'dart:ffi';

import 'package:flutter/material.dart';

class CreateAlbumScreen extends StatefulWidget {
  @override
  _CreateAlbumScreenState createState() => _CreateAlbumScreenState();
}

class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
  final TextEditingController _albumNameController = TextEditingController();

  void _addAlbum() {
    // ใส่โลจิกการเพิ่มอัลบั้มที่นี่
    final albumName = _albumNameController.text;
    if (albumName.isNotEmpty) {
      // ตัวอย่าง: เพิ่มอัลบั้มในฐานข้อมูลหรือรายการของคุณ
      print('Album added: $albumName');
      // ล้างช่องกรอกชื่อหลังจากเพิ่ม
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