import 'package:flutter/material.dart';
import 'package:note_app/models/note_models.dart';
import 'package:note_app/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note; // Proper placement of optional note

  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final bool _isBold = false;
  final bool _isItalic = false;
  final bool _isUnderline = false;
  final Color _currentColor = Colors.black;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.note != null;
    final provider = Provider.of<NoteProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Edit Note' : 'New Note',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                style: TextStyle(
                  fontSize: 18,
                  color: _currentColor,
                  fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                  decoration:
                      _isUnderline ? TextDecoration.underline : TextDecoration.none,
                ),
                decoration: const InputDecoration(
                  hintText: 'Start writing...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          _buildSaveButton(context, isEdit, provider),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isEdit, NoteProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.check, color: Colors.white),
          label: Text(
            isEdit ? 'Save Changes' : 'Save Note',
            style: const TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade800,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            final title = _titleController.text.trim();
            final content = _contentController.text.trim();

            if (title.isEmpty && content.isEmpty) return;

            if (isEdit) {
              await provider.updateNote(widget.note!.id, title, content);
            } else {
              await provider.addNote(title, content);
            }

            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
