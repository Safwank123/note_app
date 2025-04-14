import 'package:flutter/material.dart';
import 'package:note_app/providers/notes_provider.dart';
import 'package:note_app/screens/note_from_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoteProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'My Notes',
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey.shade700),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey.shade700),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder(
        future: provider.fetchNotes(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<NoteProvider>(
            builder: (ctx, noteProvider, _) {
              if (noteProvider.notes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.note_add, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 20),
                      Text(
                        'No notes yet!',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to create a new note',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: noteProvider.notes.length,
                itemBuilder: (ctx, i) {
                  final note = noteProvider.notes[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddNoteScreen(note: note),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: _getNoteColor(note.color),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                note.content,
                                style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  color: Colors.grey.shade800,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDate(note.date),
                                    style: GoogleFonts.roboto(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 34,
                          right: 18,
                          child: GestureDetector(
                            onTap: () => provider.deleteNote(note.id),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                     
                              child: const Icon(Icons.delete, color: Colors.red, size: 30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade800,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddNoteScreen()),
        ),
        child: const Icon(Icons.note_add, color: Colors.white),
      ),
    );
  }

  Color _getNoteColor(int? colorCode) {
    if (colorCode == null) return Colors.white;
    return Color(colorCode);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
