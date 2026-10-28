import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/models.dart';
import 'jobdetails_screen.dart';

class SavedJobsScreen extends StatelessWidget {
  const SavedJobsScreen({super.key});

  static const Color _bg = Color(0xFF080B14);
  static const Color _surface = Color(0xFF111625);
  static const Color _surface2 = Color(0xFF151B2D);
  static const Color _border = Color(0xFF273047);
  static const Color _violet = Color(0xFF8B5CF6);
  static const Color _muted = Color(0xFF8D96AB);
  static const Color _text = Color(0xFFF7F8FC);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId == null || userId.trim().isEmpty) {
      return const Scaffold(
        backgroundColor: _bg,
        body: Center(
          child: Text(
            'Please login first',
            style: TextStyle(color: _muted),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text(
          'Saved Jobs',
          style: TextStyle(
            color: _text,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: _bg,
        foregroundColor: _text,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('saved_jobs')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _ErrorState(message: 'Unable to load saved jobs.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: _violet),
            );
          }

          final docs = snapshot.data?.docs ??
              <QueryDocumentSnapshot<Map<String, dynamic>>>[];

          if (docs.isEmpty) {
            return const _EmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();

              final job = _jobFromSavedData(data);

              return _SavedJobCard(
                job: job,
                onDelete: () => _deleteSavedJob(context, doc.id),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JobDetailsScreen(job: job),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Job _jobFromSavedData(Map<String, dynamic> data) {
    final rawSkills = data['skills'];

    final skills = rawSkills is List
        ? rawSkills
            .map((skill) => skill.toString().trim())
            .where((skill) => skill.isNotEmpty)
            .toList()
        : <String>[];

    return Job(
      // IMPORTANT: preserve the canonical Job.id when it exists.
      id: _readOptionalString(data['jobId']),
      careerId: _readOptionalString(data['careerId']),
      title: _readString(data['jobTitle']),
      company: _readString(data['companyName']),
      location: _readString(data['location']),
      salary: _readString(data['salary']),
      skills: skills,
      type: _readString(data['type'], fallback: 'Full-time'),
      icon: _readString(data['icon'], fallback: '💼'),
      applyUrl: _readString(data['applyUrl']),
    );
  }

  Future<void> _deleteSavedJob(
    BuildContext context,
    String documentId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('saved_jobs')
          .doc(documentId)
          .delete();
    } on FirebaseException {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not remove this saved job.'),
        ),
      );
    }
  }

  String _readString(
    dynamic value, {
    String fallback = '',
  }) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? fallback : text;
  }

  String? _readOptionalString(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }
}

class _SavedJobCard extends StatelessWidget {
  const _SavedJobCard({
    required this.job,
    required this.onDelete,
    required this.onTap,
  });

  final Job job;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: SavedJobsScreen._surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SavedJobsScreen._border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: SavedJobsScreen._violet.withOpacity(0.14),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              job.icon,
              style: const TextStyle(fontSize: 27),
            ),
          ),
        ),
        title: Text(
          job.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: SavedJobsScreen._text,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            job.company,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: SavedJobsScreen._muted,
            ),
          ),
        ),
        trailing: IconButton(
          tooltip: 'Remove saved job',
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Color(0xFFF4726B),
          ),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: SavedJobsScreen._surface2,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: SavedJobsScreen._border),
              ),
              child: const Icon(
                Icons.bookmark_border_rounded,
                size: 34,
                color: SavedJobsScreen._muted,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No saved jobs yet',
              style: TextStyle(
                color: SavedJobsScreen._text,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Jobs you save will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SavedJobsScreen._muted,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: SavedJobsScreen._muted,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
