import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/models.dart';
import 'apply_screen.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job job;

  const JobDetailsScreen({
    super.key,
    required this.job,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  static const Color _bg = Color(0xFF080B14);
  static const Color _surface = Color(0xFF111625);
  static const Color _surface2 = Color(0xFF151B2D);
  static const Color _border = Color(0xFF273047);
  static const Color _violet = Color(0xFF8B5CF6);
  static const Color _violetBright = Color(0xFFA78BFA);
  static const Color _cyan = Color(0xFF22D3EE);
  static const Color _muted = Color(0xFF8D96AB);
  static const Color _text = Color(0xFFF7F8FC);

  bool _isSaving = false;
  bool _isSaved = false;
  bool _saveStateLoaded = false;

  Job get job => widget.job;

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  String get _userId => FirebaseAuth.instance.currentUser?.uid ?? '';

  DocumentReference<Map<String, dynamic>> get _savedJobRef {
    return FirebaseFirestore.instance
        .collection('saved_jobs')
        .doc('${_userId}_${job.id}');
  }

  Future<void> _loadSavedState() async {
    final userId = _userId;
    if (userId.isEmpty) {
      if (mounted) {
        setState(() {
          _saveStateLoaded = true;
        });
      }
      return;
    }

    try {
      final doc = await _savedJobRef.get();

      if (!mounted) return;

      setState(() {
        _isSaved = doc.exists;
        _saveStateLoaded = true;
      });
    } on FirebaseException {
      if (!mounted) return;

      setState(() {
        _saveStateLoaded = true;
      });
    }
  }

  Future<void> _toggleSavedJob() async {
    final userId = _userId;

    if (userId.isEmpty) {
      _showMessage('Please login first.');
      return;
    }

    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      if (_isSaved) {
        await _savedJobRef.delete();

        if (!mounted) return;

        setState(() {
          _isSaved = false;
        });

        _showMessage('Job removed from saved jobs.');
      } else {
        await _savedJobRef.set(
          {
            'jobId': job.id,
            'careerId': job.careerId,
            'jobTitle': job.title,
            'companyName': job.company,
            'location': job.location,
            'salary': job.salary,
            'skills': List<String>.from(job.skills),
            'type': job.type,
            'icon': job.icon,
            'applyUrl': job.applyUrl,
            'userId': userId,
            'savedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );

        if (!mounted) return;

        setState(() {
          _isSaved = true;
        });

        _showMessage('Job saved.');
      }
    } on FirebaseException {
      if (!mounted) return;

      _showMessage(
        _isSaved
            ? 'Could not remove this job.'
            : 'Could not save this job.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    final value = url.trim();

    if (value.isEmpty) {
      _showMessage('Application link is not available for this job.');
      return;
    }

    final uri = Uri.tryParse(value);

    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        uri.host.isEmpty) {
      _showMessage('This application link is invalid.');
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        _showMessage('Cannot open the application link.');
      }
    } catch (_) {
      if (context.mounted) {
        _showMessage('Cannot open the application link.');
      }
    }
  }

  void _showApplyOptions(BuildContext context) {
    final hasExternalUrl = job.applyUrl.trim().isNotEmpty;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Text(
                    'How would you like to apply?',
                    style: TextStyle(
                      color: _text,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    'Choose an available application route.',
                    style: TextStyle(color: _muted),
                  ),
                ),
                const SizedBox(height: 4),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  tileColor: _surface2,
                  leading: const Icon(
                    Icons.edit_note_rounded,
                    color: _violetBright,
                  ),
                  title: const Text(
                    'Fill Application Form',
                    style: TextStyle(
                      color: _text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Create an application record in Career Guide.',
                    style: TextStyle(color: _muted),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ApplyScreen(job: job),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  enabled: hasExternalUrl,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  tileColor: _surface2,
                  leading: Icon(
                    Icons.open_in_new_rounded,
                    color: hasExternalUrl ? _cyan : _muted,
                  ),
                  title: Text(
                    'Apply on Company Website',
                    style: TextStyle(
                      color: hasExternalUrl ? _text : _muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    hasExternalUrl
                        ? 'Open the provided application link.'
                        : 'No application link is available.',
                    style: const TextStyle(color: _muted),
                  ),
                  onTap: hasExternalUrl
                      ? () {
                          Navigator.pop(sheetContext);
                          _launchUrl(context, job.applyUrl);
                        }
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  String _roleSummary() {
    if (job.skills.isEmpty) {
      return 'Job details are provided from the available job record. Review the employer listing for the complete role description and requirements.';
    }

    final skills = job.skills.take(3).join(', ');

    return 'This role is listed as ${job.title} at ${job.company}. '
        'The available job record highlights $skills. '
        'Review the employer listing for the complete responsibilities, qualifications, and application details.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        foregroundColor: _text,
        elevation: 0,
        title: const Text(
          'Job Details',
          style: TextStyle(
            color: _text,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: _isSaved ? 'Remove saved job' : 'Save job',
            onPressed: _isSaving ? null : _toggleSavedJob,
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _violetBright,
                    ),
                  )
                : Icon(
                    _isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: _isSaved ? _violetBright : _text,
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildInfoRow(),
            const SizedBox(height: 24),
            _buildSkillsSection(),
            const SizedBox(height: 24),
            _buildRoleSection(),
            const SizedBox(height: 24),
            _buildApplicationNote(),
            const SizedBox(height: 28),
            _buildApplyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _violet.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _violet.withOpacity(0.22),
              ),
            ),
            child: Center(
              child: Text(
                job.icon,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.title,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 21,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  job.company,
                  style: const TextStyle(
                    color: _violetBright,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (job.location.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: _muted,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          job.location,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        Expanded(
          child: _infoCard(
            Icons.payments_outlined,
            'Salary',
            job.salary.trim().isEmpty ? 'Not provided' : job.salary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _infoCard(
            Icons.business_center_outlined,
            'Type',
            job.type.trim().isEmpty ? 'Not provided' : job.type,
          ),
        ),
      ],
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _violetBright, size: 19),
          const SizedBox(height: 9),
          Text(
            label,
            style: const TextStyle(
              color: _muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _text,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Skills Required'),
        const SizedBox(height: 12),
        if (job.skills.isEmpty)
          const Text(
            'No skills were provided in this job record.',
            style: TextStyle(
              color: _muted,
              fontSize: 14,
              height: 1.5,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: job.skills
                .map(
                  (skill) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _violet.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _violet.withOpacity(0.30),
                      ),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(
                        color: _violetBright,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildRoleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('About This Role'),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Text(
            _roleSummary(),
            style: const TextStyle(
              color: _muted,
              fontSize: 14,
              height: 1.65,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cyan.withOpacity(0.07),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _cyan.withOpacity(0.18),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: _cyan,
            size: 19,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Opening an employer website does not automatically mark an application as submitted.',
              style: TextStyle(
                color: _muted,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () => _showApplyOptions(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: _violet,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_rounded, size: 18),
            SizedBox(width: 8),
            Text(
              'Apply Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _text,
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
