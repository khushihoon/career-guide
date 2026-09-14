import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/models.dart';
import 'jobdetails_screen.dart';

class SavedJobsScreen extends StatelessWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F0F1A),
        body: Center(
          child: Text('Please login first',
              style: TextStyle(color: Color(0xFF888899))),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        title: const Text('Saved Jobs'),
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('saved_jobs')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF7C3AED)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border,
                      size: 56, color: Color(0xFF444455)),
                  SizedBox(height: 12),
                  Text('No saved jobs yet',
                      style: TextStyle(color: Color(0xFF888899))),
                ],
              ),
            );
          }

          final savedJobs = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: savedJobs.length,
            itemBuilder: (context, index) {
              final data = savedJobs[index].data() as Map<String, dynamic>;
              
              // ✅ Fix: Job constructor ke hisaab se (bina id ke)
              final job = Job(
                title: data['jobTitle'] ?? '',
                company: data['companyName'] ?? '',
                location: data['location'] ?? '',
                salary: data['salary'] ?? '',
                skills: List<String>.from(data['skills'] ?? []),
                type: data['type'] ?? 'Full-time',
                icon: data['icon'] ?? '💼',
                applyUrl: data['applyUrl'] ?? '',
              );

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2A2A40)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(job.icon, style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                  title: Text(job.title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(job.company,
                      style: const TextStyle(color: Color(0xFF888899))),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Color(0xFFEF4444)),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('saved_jobs')
                          .doc(savedJobs[index].id)
                          .delete();
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDetailsScreen(job: job),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}