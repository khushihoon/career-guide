import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'roadmap_screen.dart';
import 'mentor_screen.dart';
import 'courses_screen.dart';
import 'profile_screen.dart';
import 'copilot_hub_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    RoadmapScreen(),
    CopilotHubScreen(),
    MentorScreen(),
    CoursesScreen(),
    // ❌ ProfileScreen removed from bottom navigation
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Career App'),
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
        actions: [
          // ✅ Profile icon (replaces bell icon)
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFFA78BFA)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF1E1E2E), width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF13131F),
          selectedItemColor: const Color(0xFFA78BFA),
          unselectedItemColor: const Color(0xFF666677),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'Roadmap',
            ),
            BottomNavigationBarItem(
              icon: _CopilotIcon(active: false),
              activeIcon: _CopilotIcon(active: true),
              label: 'Copilot',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy_outlined),
              activeIcon: Icon(Icons.smart_toy),
              label: 'Mentor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: 'Courses',
            ),
            // ❌ Profile item removed
          ],
        ),
      ),
    );
  }
}

class _CopilotIcon extends StatelessWidget {
  final bool active;
  const _CopilotIcon({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: active
            ? const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: active ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: active
            ? null
            : Border.all(color: const Color(0xFF444455), width: 1.5),
      ),
      child: Icon(
        Icons.auto_awesome,
        size: 16,
        color: active ? Colors.white : const Color(0xFF666677),
      ),
    );
  }
}