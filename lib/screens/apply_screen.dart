import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/models.dart';
import '../services/copilot_provider.dart';

class ApplyScreen extends StatefulWidget {
  final Job job;

  const ApplyScreen({
    super.key,
    required this.job,
  });

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  static const _bg = Color(0xFF080B14);
  static const _surface = Color(0xFF111625);
  static const _surface2 = Color(0xFF151B2D);
  static const _border = Color(0xFF273047);
  static const _violet = Color(0xFF8B5CF6);
  static const _violetBright = Color(0xFFA78BFA);
  static const _cyan = Color(0xFF22D3EE);
  static const _mint = Color(0xFF34D399);
  static const _muted = Color(0xFF8D96AB);
  static const _text = Color(0xFFF7F8FC);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _coverController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? '';
      _nameController.text = user.displayName ?? '';
    }
  }

  Future<void> _submitApplication() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage(
        'Please log in before tracking an application.',
        isError: true,
      );
      return;
    }

    final uid = user.uid;
    final jobId = widget.job.id;
    final careerId = widget.job.careerId;
    final applicationRef = FirebaseFirestore.instance
        .collection('applications')
        .doc('${uid}_$jobId');

    setState(() => _isSubmitting = true);

    try {
      final existing = await applicationRef.get();

      if (existing.exists) {
        if (!mounted) return;

        _showMessage(
          'You have already tracked an application for this job.',
        );

        await Future<void>.delayed(const Duration(milliseconds: 350));
        if (mounted) Navigator.pop(context);
        return;
      }

      await applicationRef.set({
        'userId': uid,
        'jobId': jobId,
        'careerId': careerId,
        'jobTitle': widget.job.title,
        'companyName': widget.job.company,
        'companyIcon': widget.job.icon,
        'location': widget.job.location,
        'salary': widget.job.salary,
        'type': widget.job.type,
        'applyUrl': widget.job.applyUrl,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'coverLetter': _coverController.text.trim(),
        // This records the user's application action inside Career Guide.
        // It does not claim that an employer/ATS has confirmed receipt.
        'status': 'applied',
        'applicationSource': 'career_guide',
        'employerSubmissionConfirmed': false,
        'appliedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Feed the same real application event into Copilot.
      // CopilotController.recordJobApplied() is idempotent through
      // CopilotFirestoreService.appendAppliedJob().
      final controller = CopilotProvider.maybeOf(context);
      if (controller != null) {
        await controller.recordJobApplied(uid, jobId);
      }

      if (!mounted) return;

      _showMessage(
        'Application tracked successfully.',
        isSuccess: true,
      );

      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (mounted) Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (!mounted) return;

      final message = e.code == 'permission-denied'
          ? 'You are not allowed to save this application.'
          : e.code == 'unavailable'
              ? 'Connection unavailable. Please try again.'
              : 'Couldn’t save the application. Please try again.';

      _showMessage(message, isError: true);
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'Couldn’t save the application. Please try again.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showMessage(
    String message, {
    bool isError = false,
    bool isSuccess = false,
  }) {
    final color = isError
        ? const Color(0xFFEF4444)
        : isSuccess
            ? _mint
            : _violet;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons.error_outline_rounded
                    : isSuccess
                        ? Icons.check_circle_rounded
                        : Icons.info_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
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
          'Track Application',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildJobCard(),
                const SizedBox(height: 28),
                const Text(
                  'Application details',
                  style: TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Save the details you want to keep with this application.',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                _buildField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _buildField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) return 'Enter your email';
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(email)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _buildField(
                  controller: _phoneController,
                  label: 'Phone Number (optional)',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Cover letter / notes',
                  style: TextStyle(
                    color: _text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                _buildField(
                  controller: _coverController,
                  label: 'Why are you interested in this role?',
                  icon: Icons.edit_note_rounded,
                  maxLines: 6,
                ),
                const SizedBox(height: 14),
                _buildNotice(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitApplication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _violet,
                      disabledBackgroundColor: _violet.withOpacity(0.35),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 23,
                            height: 23,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline_rounded),
                              SizedBox(width: 9),
                              Text(
                                'Track Application',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: _violet.withOpacity(0.12),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _violet.withOpacity(0.22),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.job.icon,
              style: const TextStyle(fontSize: 27),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.job.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.job.company,
                  style: const TextStyle(
                    color: _violetBright,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.job.location} • ${widget.job.type}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotice() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: _cyan,
            size: 19,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Career Guide will track this application in your account. '
              'Employer or ATS receipt is not confirmed by this in-app record.',
              style: TextStyle(
                color: _muted,
                fontSize: 11.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(
        color: _text,
        fontSize: 14,
      ),
      cursorColor: _violetBright,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _muted),
        prefixIcon: Icon(
          icon,
          color: _muted,
          size: 20,
        ),
        filled: true,
        fillColor: _surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: _violetBright,
            width: 1.3,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 1.2,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _coverController.dispose();
    super.dispose();
  }
}
