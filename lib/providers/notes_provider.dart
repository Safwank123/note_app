import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/note_models.dart';

class NoteProvider with ChangeNotifier {
  final List<Note> _notes = [];
  final CollectionReference _notesRef = 
      FirebaseFirestore.instance.collection('notes');

  List<Note> get notes => [..._notes];

  Future<void> fetchNotes() async {
    try {
      final snapshot = await _notesRef.orderBy('date', descending: true).get();
      _notes.clear();
      for (var doc in snapshot.docs) {
        _notes.add(Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id));
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addNote(String title, String content, {int? color}) async {
    try {
      final newNote = {
        'title': title,
        'content': content,
        'date': Timestamp.now(),
        'color': color ?? 0xFFFFFFFF,
      };
      
      final docRef = await _notesRef.add(newNote);
      _notes.insert(0, Note(
        id: docRef.id,
        title: title,
        content: content,
        date: DateTime.now(),
        color: color,
      ));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateNote(String id, String title, String content, {int? color}) async {
    try {
      final updateData = <String, dynamic>{
        'title': title,
        'content': content,
        if (color != null) 'color': color,
      };

      await _notesRef.doc(id).update(updateData);
      
      final index = _notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        _notes[index] = _notes[index].copyWith(
          title: title,
          content: content,
          color: color,
        );
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _notesRef.doc(id).delete();
      _notes.removeWhere((note) => note.id == id);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}