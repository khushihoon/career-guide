import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import 'apply_screen.dart';

class JobDetailsScreen extends StatelessWidget {
  final Job job;
  const JobDetailsScreen({super.key, required this.job});

  Future<void> _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open link')),
        );
      }
    }
  }

  void _showApplyOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Apply Options', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_note, color: Color(0xFF7C3AED)),
              title: const Text('Fill Application Form', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ApplyScreen(job: job)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_browser, color: Color(0xFF7C3AED)),
              title: const Text('Apply on Company Website', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _launchUrl(context, job.applyUrl);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        title: Text(job.title),
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF2A2A40)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F0F20),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(job.icon, style: const TextStyle(fontSize: 30)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job.title,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(job.company,
                            style: const TextStyle(fontSize: 14, color: Color(0xFFA78BFA), fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(job.location,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF888899))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Info chips
            Row(
              children: [
                _infoChip(Icons.attach_money, job.salary),
                const SizedBox(width: 10),
                _infoChip(Icons.business_center, job.type),
              ],
            ),
            const SizedBox(height: 24),

            // Skills
            _sectionTitle('Skills Required'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: job.skills.map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1A4E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.4)),
                ),
                child: Text(s, style: const TextStyle(color: Color(0xFFC4B5FD), fontSize: 13)),
              )).toList(),
            ),
            const SizedBox(height: 24),

            // About
            _sectionTitle('About This Role'),
            const SizedBox(height: 10),
            Text(
              'This is a great opportunity to join ${job.company} as a ${job.title}. '
              'You will work on cutting-edge AI systems. '
              'Experience in ${job.skills.take(2).join(", ")} is essential.',
              style: const TextStyle(color: Color(0xFF888899), fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 32),

            // Apply Now Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => _showApplyOptions(context),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send, size: 18, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Apply Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFA78BFA), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(
        t,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      );
}