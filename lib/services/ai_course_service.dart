import '../models/course_content_data.dart';
import 'course_generator_service.dart';

class AiCourseService {
  // ============================================================
  // MOCK MODE
  // ============================================================
  //
  // Abhi API key nahi hai.
  // Isliye app offline/mock course generate karegi.
  //
  // Baad mein isi class mein backend/AI connection add hoga.
  // ============================================================

  static Future<TopicCourse> generateCourse({
    required String careerId,
    required String careerTitle,
    required String categoryId,
    required int level,
    required String levelTitle,
    required List<String> topics,
    String difficulty = 'Beginner',
  }) async {
    // Generator ka prompt ready karo.
    //
    // Abhi API ko send nahi kar rahe.
    final prompt = CourseGeneratorService.buildCoursePrompt(
      careerId: careerId,
      careerTitle: careerTitle,
      categoryId: categoryId,
      level: level,
      levelTitle: levelTitle,
      topics: topics,
      difficulty: difficulty,
    );

    // Prompt ko use hua maana ja raha hai.
    // Future mein yahin backend/AI API call hogi.
    if (prompt.isEmpty) {
      throw Exception('Course generation prompt is empty.');
    }

    // ==========================================================
    // MOCK COURSE
    // ==========================================================

    final concepts = <ConceptLesson>[];

    for (int i = 0; i < topics.length && i < 5; i++) {
      final topic = topics[i];

      concepts.add(
        ConceptLesson(
          title: topic,
          definition:
              '$topic is an important skill for a $careerTitle.',
          analogy:
              'Think of $topic as one building block in your $careerTitle career.',
          example:
              'A $careerTitle can apply $topic in a practical project.',
          keyTakeaway:
              'Understand the fundamentals of $topic and practise it with real examples.',
        ),
      );
    }

    // Agar topics 5 se kam hain to minimum useful concepts
    // create karne ke liye level title use hoga.
    while (concepts.length < 5) {
      concepts.add(
        ConceptLesson(
          title: '$levelTitle — Practice ${concepts.length + 1}',
          definition:
              'Practice the concepts covered in $levelTitle.',
          analogy:
              'Practice is like training a skill repeatedly until it becomes natural.',
          example:
              'Build a small practical exercise related to $levelTitle.',
          keyTakeaway:
              'Practice is required to turn knowledge into a job-ready skill.',
        ),
      );
    }

    // ==========================================================
    // QUIZ
    // ==========================================================

    final quiz = <QuizQuestion>[
      QuizQuestion(
        question: 'What should you focus on first in $levelTitle?',
        options: [
          'Understanding the fundamentals',
          'Skipping the basics',
          'Only memorising definitions',
          'Avoiding practice',
        ],
        correctIndex: 0,
        explanation:
            'Strong fundamentals make advanced learning easier.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is practical practice important for $careerTitle?',
        options: [
          'It builds real-world skills',
          'It removes the need to learn',
          'It guarantees a job',
          'It replaces projects',
        ],
        correctIndex: 0,
        explanation:
            'Practical work helps convert knowledge into usable skills.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is a good way to learn $levelTitle?',
        options: [
          'Learn and practise',
          'Only watch videos',
          'Only read titles',
          'Skip exercises',
        ],
        correctIndex: 0,
        explanation:
            'Combining learning with practice gives better results.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What should a career learner build?',
        options: [
          'Practical projects',
          'Only notes',
          'Only certificates',
          'Nothing',
        ],
        correctIndex: 0,
        explanation:
            'Projects demonstrate practical ability.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the goal of this level?',
        options: [
          'Build useful career skills',
          'Finish without understanding',
          'Avoid difficult topics',
          'Memorise everything',
        ],
        correctIndex: 0,
        explanation:
            'The goal is practical, career-focused learning.',
        xpReward: 10,
      ),
    ];

    // ==========================================================
    // MINI CHALLENGES
    // ==========================================================

    final challenges = <MiniChallenge>[
      MiniChallenge(
        prompt:
            'Choose the best approach for learning $levelTitle.',
        options: [
          'Learn the concept and build something',
          'Only memorise',
          'Skip practice',
          'Avoid projects',
        ],
        correctIndex: 0,
        explanation:
            'Learning plus building is the best practical approach.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'What should you do after learning a topic?',
        options: [
          'Practise it',
          'Forget it',
          'Skip it',
          'Only read about it',
        ],
        correctIndex: 0,
        explanation:
            'Practice reinforces the newly learned skill.',
        xpReward: 15,
      ),
    ];

    // ============================================================
    // FINAL PROJECT
    // ============================================================

    final project = FinalProject(
      title: '$careerTitle — $levelTitle Project',
      goal:
          'Build a small practical project using the skills learned in this level.',
      steps: [
        'Review the concepts from $levelTitle.',
        'Choose one practical problem.',
        'Plan the solution.',
        'Build the project.',
        'Test and improve the result.',
        'Document what you learned.',
      ],
      expectedOutput:
          'A working beginner-friendly project demonstrating $levelTitle.',
      xpReward: 50,
    );

    // ============================================================
    // RETURN TOPIC COURSE
    // ============================================================

    return TopicCourse(
      id: '${careerId}_level_$level',
      topicTitle: levelTitle,
      careerId: careerId,
      categoryId: categoryId,
      difficulty: difficulty,
      estimatedMinutes: 30,
      totalXp: 150,
      intro:
          'Learn $levelTitle step by step and build practical $careerTitle skills.',
      emoji: '📚',
      concepts: concepts,
      quiz: quiz,
      challenges: challenges,
      finalProject: project,
    );
  }
}