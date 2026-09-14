// ══════════════════════════════════════════════════════════════════════
// lib/models/course_content_data.dart
//
// Course Learning Engine — Data Layer
//
// Covers all 8 roadmap categories + 46 careers + Software Engineering Path (10 levels).
// One reusable engine works for every topic.
// Add new topics by extending the _allTopics list only.
// ══════════════════════════════════════════════════════════════════════

// ─── Quiz Question ────────────────────────────────────────────────────
import '../data/courses/software_courses.dart';
import '../data/courses/software_level_2.dart';
import '../data/courses/software_level_3.dart';
import '../data/courses/software_level_4.dart';
import '../data/courses/software_level_5.dart';
import '../data/courses/software_level_6.dart';
import '../data/courses/software_level_7.dart';
import '../data/courses/software_level_8.dart';
import '../data/courses/software_level_9.dart';
import '../data/courses/software_level_10.dart';
import '../data/courses/ai_engineer_level_1.dart';
import '../data/courses/ai_engineer_level_2.dart';
import '../data/courses/ai_engineer_level_3.dart';
import '../data/courses/ai_engineer_level_4.dart';
import '../data/courses/ai_engineer_level_5.dart';
import '../data/courses/ai_engineer_level_6.dart';
import '../data/courses/ai_engineer_level_7.dart';
import '../data/courses/ai_engineer_level_8.dart';
import '../data/courses/ai_engineer_level_9.dart';
import '../data/courses/ai_engineer_level_10.dart';
import '../data/courses/data_scientist_level_1.dart';
import '../data/courses/data_scientist_level_2.dart';
import '../data/courses/data_scientist_level_3.dart';
import '../data/courses/data_scientist_level_4.dart';
import '../data/courses/data_scientist_level_5.dart';
import '../data/courses/data_scientist_level_6.dart';
import '../data/courses/data_scientist_level_7.dart';
import '../data/courses/data_scientist_level_8.dart';
import '../data/courses/data_scientist_level_9.dart';
import '../data/courses/data_scientist_level_10.dart';
import '../data/courses/llm_engineer_level_1.dart';
import '../data/courses/llm_engineer_level_2.dart';
import '../data/courses/llm_engineer_level_3.dart';
import '../data/courses/llm_engineer_level_4.dart';
import '../data/courses/llm_engineer_level_5.dart';
import '../data/courses/llm_engineer_level_6.dart';
import '../data/courses/llm_engineer_level_7.dart';  
import '../data/courses/llm_engineer_level_8.dart';
import '../data/courses/llm_engineer_level_9.dart';
import '../data/courses/llm_engineer_level_10.dart';
import '../data/courses/llm_engineer_level_11.dart';
import '../data/courses/computer_vision_engineer_level1.dart';
import '../data/courses/computer_vision_engineer_level2.dart';
import '../data/courses/computer_vision_engineer_level3.dart';
import '../data/courses/computer_vision_engineer_level4.dart';
import '../data/courses/computer_vision_engineer_level5.dart';
import '../data/courses/computer_vision_engineer_level6.dart';
import '../data/courses/computer_vision_engineer_level7.dart';
import '../data/courses/computer_vision_engineer_level8.dart';
import '../data/courses/computer_vision_engineer_level9.dart';
import '../data/courses/computer_vision_engineer_level10.dart';
import '../data/courses/computer_vision_engineer_level11.dart';
import '../data/courses/claude_engineer_level1.dart';
import '../data/courses/claude_engineer_level2.dart';
import '../data/courses/claude_engineer_level3.dart';
import '../data/courses/claude_engineer_level4.dart';
import '../data/courses/claude_engineer_level5.dart';
import '../data/courses/claude_engineer_level6.dart';
import '../data/courses/claude_engineer_level7.dart';
import '../data/courses/claude_engineer_level8.dart';
import '../data/courses/claude_engineer_level9.dart';
import '../data/courses/claude_engineer_level10.dart';









class QuizQuestion {
  final String         question;
  final List<String>   options;
  final int            correctIndex;
  final String         explanation;
  final int            xpReward;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.xpReward = 10,
  });
}

// ─── Concept Lesson ───────────────────────────────────────────────────

class ConceptLesson {
  final String title;
  final String definition;
  final String analogy;
  final String example;
  final String keyTakeaway;
  final String? codeSnippet;   // optional code block

  const ConceptLesson({
    required this.title,
    required this.definition,
    required this.analogy,
    required this.example,
    required this.keyTakeaway,
    this.codeSnippet,
  });
}

// ─── Mini Challenge ──────────────────────────────────────────────────

class MiniChallenge {
  final String         prompt;
  final List<String>   options;
  final int            correctIndex;
  final String         explanation;
  final int            xpReward;

  const MiniChallenge({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.xpReward = 15,
  });
}

// ─── Final Project ────────────────────────────────────────────────────

class FinalProject {
  final String         title;
  final String         goal;
  final List<String>   steps;
  final String         expectedOutput;
  final int            xpReward;

  const FinalProject({
    required this.title,
    required this.goal,
    required this.steps,
    required this.expectedOutput,
    this.xpReward = 50,
  });
}

// ─── Topic Course ─────────────────────────────────────────────────────

class TopicCourse {
  final String               id;
  final String               topicTitle;   // matches roadmap topic name
  final String               careerId;     // matches CareerData.id
  final String               categoryId;   // matches CareerCategory.id
  final String               difficulty;   // Easy / Medium / Hard
  final int                  estimatedMinutes;
  final int                  totalXp;
  final String               intro;        // motivational intro text
  final String               emoji;
  final List<ConceptLesson>  concepts;
  final List<QuizQuestion>   quiz;
  final List<MiniChallenge>  challenges;
  final FinalProject         finalProject;

  const TopicCourse({
    required this.id,
    required this.topicTitle,
    required this.careerId,
    required this.categoryId,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.totalXp,
    required this.intro,
    required this.emoji,
    required this.concepts,
    required this.quiz,
    required this.challenges,
    required this.finalProject,
  });
}

// ─── Lookup helper ────────────────────────────────────────────────────

class CourseContentData {
  /// Find a course by topicTitle (case-insensitive partial match)
  static TopicCourse? findByTopic(String topicTitle) {
    final q = topicTitle.toLowerCase();
    try {
      return allTopicCourses.firstWhere(
        (c) => c.topicTitle.toLowerCase().contains(q) ||
               q.contains(c.topicTitle.toLowerCase()),
      );
    } catch (_) {
      return null;
    }
  }

  /// Find courses for a specific career
  static List<TopicCourse> forCareer(String careerId) =>
      allTopicCourses.where((c) => c.careerId == careerId).toList();

  /// Find courses for a category
  static List<TopicCourse> forCategory(String categoryId) =>
      allTopicCourses.where((c) => c.categoryId == categoryId).toList();
}

// ══════════════════════════════════════════════════════════════════════
// ALL TOPIC COURSES
// ══════════════════════════════════════════════════════════════════════

const List<TopicCourse> allTopicCourses = [

  // ────────────────────────────────────────────────────────────────────
  // SOFTWARE ENGINEERING PATH (10 Levels — from software_courses.dart)
  // ────────────────────────────────────────────────────────────────────
  ...softwareEngineeringPath,
  ...softwareCoursesLevel2,
  ...softwareCoursesLevel3,
  ...softwareCoursesLevel4,
  ...softwareCoursesLevel5,
  ...softwareCoursesLevel6,
  ...softwareCoursesLevel7,
  ...softwareCoursesLevel8,
  ...softwareCoursesLevel9,
  ...softwareCoursesLevel10,

  

 //========================================================================
  //AI ENGIENEERS PATH (10 Levels)
 //========================================================================

  ...aiEngineerLevel1,
  ...aiEngineerLevel2,
  ...aiEngineerLevel3,
  ...aiEngineerLevel4,
  ...aiEngineerLevel5,
  ...aiEngineerLevel6,
  ...aiEngineerLevel7,
  ...aiEngineerLevel8,
  ...aiEngineerLevel9,
  ...aiEngineerLevel10,

 //==========================================================================
  // DATA SCIENTISTS PATH (10 Level)
 //==========================================================================

  ...dataScientistLevel1,
  ...dataScientistLevel2,
  ...dataScientistLevel3,
  ...dataScientistLevel4,
  ...dataScientistLevel5,
  ...dataScientistLevel6,
  ...dataScientistLevel7,
  ...dataScientistLevel8,
  ...dataScientistLevel9,
  ...dataScientistLevel10,


  // ========================================================================
  // LLM ENGINEERS PATH (level 10)
  //=========================================================================

  ...llmEngineerLevel1,
  ...llmEngineerLevel2,
  ...llmEngineerLevel3,
  ...llmEngineerLevel4,
  ...llmEngineerLevel5,
  ...llmEngineerLevel6,
  ...llmEngineerLevel7,
  ...llmEngineerLevel8,
  ...llmEngineerLevel9,
  ...llmEngineerLevel10,
  ...llmEngineerLevel11,



  //==========================================================================

  // COMPUTER VISION ENGINEERS PATH (level ALL LEVELS)

  //==========================================================================

  ...computerVisionEngineerLevel1,
  ...computerVisionEngineerLevel2,
  ...computerVisionEngineerLevel3,
  ...computerVisionEngineerLevel4,
  ...computerVisionEngineerLevel5,
  ...computerVisionEngineerLevel6,
  ...computerVisionEngineerLevel7,
  ...computerVisionEngineerLevel8,
  ...computerVisionEngineerLevel9,
  ...computerVisionEngineerLevel10,
  ...computerVisionEngineerLevel11,


  //==========================================================================
  // CLAUDE ENGINEER PATH (level ALL LEVELS)
  //==========================================================================

  ...claudeEngineerLevel1,
  ...claudeEngineerLevel2,
  ...claudeEngineerLevel3,
  ...claudeEngineerLevel4,
  ...claudeEngineerLevel5,
  ...claudeEngineerLevel6,
  ...claudeEngineerLevel7,
  ...claudeEngineerLevel8,
  ...claudeEngineerLevel9,
  ...claudeEngineerLevel10,


  




  // ────────────────────────────────────────────────────────────────────
  // SOFTWARE DEVELOPMENT
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'python_basics',
    topicTitle: 'Python/Java Basics',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🐍',
    intro: 'Python is the #1 programming language in the world for AI, data science, and web development. In this lesson, you\'ll go from zero to writing real Python code in 25 minutes. Every top engineer started exactly where you are right now.',
    concepts: [
      ConceptLesson(
        title: 'Variables',
        definition: 'A variable is a named container that stores a value in your program\'s memory.',
        analogy: 'Think of a variable like a labelled box. You write "name" on the box and put "Alice" inside. Whenever you need the name, you open that box.',
        example: 'In Python:\nname = "Alice"\nage = 25\nsalary = 85000.50\n\nThe computer now remembers these values by name.',
        keyTakeaway: 'Variables store data. Use meaningful names like `user_age` instead of `x` so your code reads like English.',
        codeSnippet: 'name = "Alice"\nage = 25\nprint(name)   # Alice\nprint(age)    # 25',
      ),
      ConceptLesson(
        title: 'Data Types',
        definition: 'Data types tell Python what kind of value you\'re storing — text, number, decimal, or true/false.',
        analogy: 'Just like how a hospital labels containers as "blood", "medicine", or "water" — Python labels data as String, Integer, Float, or Boolean so it knows how to handle it.',
        example: 'name = "Alice"     → String (text)\nage = 25           → Integer (whole number)\nheight = 5.7       → Float (decimal)\nis_student = True  → Boolean (yes/no)',
        keyTakeaway: 'Every value has a type. Python figures it out automatically — you don\'t need to declare types (unlike Java or C++).',
        codeSnippet: 'print(type("Alice"))  # <class \'str\'>\nprint(type(25))       # <class \'int\'>\nprint(type(5.7))      # <class \'float\'>\nprint(type(True))     # <class \'bool\'>',
      ),
      ConceptLesson(
        title: 'Control Flow',
        definition: 'Control flow lets your program make decisions — run different code based on conditions.',
        analogy: 'It\'s like traffic lights. IF the light is green, GO. ELIF it\'s yellow, SLOW DOWN. ELSE, STOP. Your program follows the same logic.',
        example: 'score = 85\nif score >= 90:\n    print("A grade")\nelif score >= 80:\n    print("B grade")\nelse:\n    print("Work harder!")',
        keyTakeaway: 'if/elif/else lets your program be smart and respond differently to different situations.',
        codeSnippet: 'score = 85\nif score >= 90:\n    print("A")\nelif score >= 80:\n    print("B")  # This prints!\nelse:\n    print("C")',
      ),
      ConceptLesson(
        title: 'Loops',
        definition: 'Loops let you repeat code multiple times without writing it multiple times.',
        analogy: 'Imagine telling someone to say "hello" to 100 guests. You wouldn\'t write "say hello" 100 times. You\'d say "for each guest, say hello". That\'s a loop.',
        example: 'for i in range(5):\n    print(f"Hello #{i+1}")\n\nOutputs:\nHello #1\nHello #2\n... up to Hello #5',
        keyTakeaway: 'for loops iterate over a sequence. while loops repeat until a condition is false. Loops eliminate repetition.',
        codeSnippet: '# Print squares 1-5\nfor i in range(1, 6):\n    print(f"{i} squared = {i**2}")',
      ),
      ConceptLesson(
        title: 'Functions',
        definition: 'A function is a reusable block of code that does one specific job. You define it once and call it many times.',
        analogy: 'A function is like a recipe. You write the recipe (define the function) once. Then anyone can follow it (call it) whenever they want to cook that dish.',
        example: 'def greet(name):\n    return f"Hello, {name}!"\n\nprint(greet("Alice"))  # Hello, Alice!\nprint(greet("Bob"))    # Hello, Bob!',
        keyTakeaway: 'Functions make code reusable and organised. The DRY principle: Don\'t Repeat Yourself. If you write it twice, it belongs in a function.',
        codeSnippet: 'def calculate_tax(income, rate=0.20):\n    return income * rate\n\ntax = calculate_tax(100000)\nprint(f"Tax owed: {tax}")  # 20000.0',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the data type of the value 42 in Python?',
        options: ['String', 'Float', 'Integer', 'Boolean'],
        correctIndex: 2,
        explanation: '42 is a whole number, so Python classifies it as an Integer (int). If it were 42.0, it would be a Float.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which keyword starts a decision block in Python?',
        options: ['when', 'if', 'check', 'case'],
        correctIndex: 1,
        explanation: 'Python uses "if" to start a decision/conditional block, followed by "elif" (else if) and "else".',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the "def" keyword do in Python?',
        options: ['Defines a variable', 'Defines a function', 'Deletes a value', 'Defines a loop'],
        correctIndex: 1,
        explanation: '"def" is short for "define". It tells Python you are about to define a reusable function.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What will print(type(True)) output?',
        options: ["<class 'string'>", "<class 'int'>", "<class 'bool'>", "<class 'boolean'>"],
        correctIndex: 2,
        explanation: 'True and False are Boolean values. Python\'s type system calls this class \'bool\'.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'What is the OUTPUT of this code?\n\nx = 10\ny = 3\nprint(x % y)',
        options: ['3', '3.33', '1', '10'],
        correctIndex: 2,
        explanation: '% is the modulo (remainder) operator. 10 ÷ 3 = 3 remainder 1. So 10 % 3 = 1.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Which of these correctly calls a function named "calculate" with argument 50?',
        options: ['calculate.50', 'calculate[50]', 'calculate(50)', 'call calculate(50)'],
        correctIndex: 2,
        explanation: 'Functions are called using parentheses: functionName(arguments). So calculate(50) is correct.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Student Grade Calculator',
      goal: 'Build a Python program that takes 3 exam scores, calculates the average, and prints the letter grade.',
      steps: [
        'Create 3 variables: score1, score2, score3',
        'Calculate the average: average = (score1 + score2 + score3) / 3',
        'Use if/elif/else to determine the grade (A=90+, B=80+, C=70+, F=below 70)',
        'Print the average and grade using f-strings',
        'Wrap everything in a function called get_grade(s1, s2, s3)',
      ],
      expectedOutput: 'Average: 85.0\nGrade: B\n\nWell done! You passed.',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'data_structures',
    topicTitle: 'Data Structures',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 140,
    emoji: '📊',
    intro: 'Data structures are the building blocks of every software system. Knowing them is the single most important skill for software engineering interviews at Google, Amazon, and Microsoft. Let\'s master them step by step.',
    concepts: [
      ConceptLesson(
        title: 'Arrays & Lists',
        definition: 'An array is an ordered collection of elements stored at consecutive memory locations. In Python, we use Lists.',
        analogy: 'An array is like a numbered row of seats in a cinema. Seat 1, Seat 2, Seat 3... You can jump directly to any seat by number.',
        example: 'fruits = ["apple", "banana", "cherry"]\nprint(fruits[0])   # apple (index starts at 0)\nprint(fruits[-1])  # cherry (negative index from end)',
        keyTakeaway: 'Lists are O(1) for access by index, O(n) for search. Use them when order matters and you access by position.',
        codeSnippet: 'nums = [3, 1, 4, 1, 5, 9]\nnums.append(2)      # Add to end\nnums.pop()          # Remove from end\nnums.sort()         # Sort in place\nprint(nums)',
      ),
      ConceptLesson(
        title: 'Hash Maps (Dictionaries)',
        definition: 'A hash map stores key-value pairs. You look up values by their key instantly, regardless of size.',
        analogy: 'A dictionary is exactly like a real dictionary — you look up a word (key) and get its definition (value). You don\'t read every page — you jump straight to it.',
        example: 'student = {\n    "name": "Alice",\n    "grade": "A",\n    "score": 95\n}\nprint(student["name"])  # Alice',
        keyTakeaway: 'Hash maps give O(1) average lookup. Use them for frequency counting, caching, and grouping data.',
        codeSnippet: '# Count word frequency\nwords = ["hi", "bye", "hi", "hello", "hi"]\ncount = {}\nfor w in words:\n    count[w] = count.get(w, 0) + 1\nprint(count)  # {\'hi\': 3, \'bye\': 1, \'hello\': 1}',
      ),
      ConceptLesson(
        title: 'Linked Lists',
        definition: 'A linked list is a chain of nodes where each node stores data AND a pointer to the next node.',
        analogy: 'A linked list is like a treasure hunt. Each clue (node) tells you the data AND where the next clue is hidden. You must follow the chain from the start.',
        example: 'Node 1: [data=5 | next→] → Node 2: [data=10 | next→] → Node 3: [data=15 | next=None]\n\nTo find the 3rd element, you must traverse nodes 1 and 2 first.',
        keyTakeaway: 'Linked lists are O(1) for insert/delete at known positions but O(n) for access. Great for queues and implementing stacks.',
        codeSnippet: 'class Node:\n    def __init__(self, data):\n        self.data = data\n        self.next = None\n\nhead = Node(5)\nhead.next = Node(10)\nhead.next.next = Node(15)',
      ),
      ConceptLesson(
        title: 'Stacks & Queues',
        definition: 'Stack: Last In, First Out (LIFO). Queue: First In, First Out (FIFO).',
        analogy: 'Stack = a stack of plates. You add on top and take from top. Queue = a line at a coffee shop. First person in line gets served first.',
        example: 'Stack use: Undo/redo in text editors, call stack in functions.\nQueue use: Print jobs, customer service systems, BFS traversal.',
        keyTakeaway: 'Use a stack for "undo" and "backtrack" problems. Use a queue for "level by level" and "first come first served" problems.',
        codeSnippet: 'from collections import deque\n\n# Stack (use list)\nstack = []\nstack.append(1)  # push\nstack.pop()      # pop\n\n# Queue (use deque)\nqueue = deque()\nqueue.append(1)   # enqueue\nqueue.popleft()   # dequeue',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the time complexity of accessing an element in an array by index?',
        options: ['O(n)', 'O(log n)', 'O(1)', 'O(n²)'],
        correctIndex: 2,
        explanation: 'Arrays store elements at contiguous memory. Since we know the start address, index access is O(1) — constant time, regardless of array size.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which data structure follows LIFO (Last In, First Out)?',
        options: ['Queue', 'Array', 'Stack', 'Hash Map'],
        correctIndex: 2,
        explanation: 'A Stack follows LIFO. Think of a stack of plates — you always add and remove from the top. The last plate added is the first removed.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the average time complexity for lookup in a Hash Map?',
        options: ['O(n)', 'O(log n)', 'O(n²)', 'O(1)'],
        correctIndex: 3,
        explanation: 'Hash maps use a hash function to convert keys to array indices, giving O(1) average lookup. This is why they are used everywhere in software engineering.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You need to check if the word "hello" appears in a list of 1 million words. Which data structure gives the FASTEST lookup?',
        options: ['Linked List', 'Hash Set', 'Regular Array', 'Stack'],
        correctIndex: 1,
        explanation: 'A Hash Set (backed by a hash map) gives O(1) average lookup. A regular array/linked list requires O(n) — scanning every element.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Which data structure is best for implementing an "undo" feature in a text editor?',
        options: ['Queue', 'Hash Map', 'Stack', 'Linked List'],
        correctIndex: 2,
        explanation: 'A Stack is perfect for undo. Each action is pushed. When you press Ctrl+Z, the last action is popped and reversed. LIFO matches undo behaviour exactly.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Library Book Tracker',
      goal: 'Build a system to track borrowed books using appropriate data structures.',
      steps: [
        'Use a dictionary {book_id: book_title} to store the library',
        'Use a list to store the borrow history (ordered by time)',
        'Use a stack to implement "undo last borrow"',
        'Add functions: borrow(book_id), return_book(book_id), undo_last()',
        'Print the borrow history sorted by book title',
      ],
      expectedOutput: 'Borrowed: Python Cookbook\nBorrowed: Clean Code\nUndo: Clean Code returned\nHistory: [Python Cookbook]',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'html_fundamentals',
    topicTitle: 'HTML Fundamentals',
    careerId: 'frontend_dev',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 100,
    emoji: '🌐',
    intro: 'HTML is the skeleton of every website on the internet. Every page you\'ve ever visited — Google, Instagram, YouTube — starts with HTML. In 20 minutes, you\'ll understand how the web is actually built.',
    concepts: [
      ConceptLesson(
        title: 'What is HTML?',
        definition: 'HTML (HyperText Markup Language) is a language that describes the structure of web pages using elements called tags.',
        analogy: 'HTML is like the blueprint of a building. The blueprint shows where the walls, doors, and windows go — but it\'s not the building itself. CSS is the paint, and JavaScript is the electricity.',
        example: '<!DOCTYPE html>\n<html>\n  <head><title>My Page</title></head>\n  <body>\n    <h1>Hello World!</h1>\n    <p>This is a paragraph.</p>\n  </body>\n</html>',
        keyTakeaway: 'HTML uses opening <tag> and closing </tag> to mark the beginning and end of elements. Every webpage is a tree of nested HTML elements.',
        codeSnippet: '<h1>Heading 1</h1>\n<h2>Heading 2</h2>\n<p>Paragraph text here.</p>\n<a href="https://google.com">Click me!</a>',
      ),
      ConceptLesson(
        title: 'Semantic HTML',
        definition: 'Semantic HTML uses meaningful tags that describe the PURPOSE of the content, not just its appearance.',
        analogy: 'Using <div> for everything is like labelling every room in your house "room". Semantic HTML is like having "kitchen", "bedroom", "bathroom" — immediately clear what each does.',
        example: 'Bad: <div class="header"> vs Good: <header>\nBad: <div class="nav"> vs Good: <nav>\nBad: <div class="main"> vs Good: <main>\nBad: <div class="footer"> vs Good: <footer>',
        keyTakeaway: 'Semantic HTML improves accessibility (screen readers), SEO (search engines understand it better), and code readability for other developers.',
        codeSnippet: '<header>\n  <nav>...navigation...</nav>\n</header>\n<main>\n  <article>...content...</article>\n  <aside>...sidebar...</aside>\n</main>\n<footer>...footer...</footer>',
      ),
      ConceptLesson(
        title: 'Forms & Inputs',
        definition: 'HTML forms collect user input — text, choices, files — and send them to a server.',
        analogy: 'A web form is exactly like a paper form at a hospital. You fill in your name, age, symptoms — then submit it to the doctor (server).',
        example: '<form action="/submit" method="POST">\n  <input type="text" placeholder="Your name">\n  <input type="email" placeholder="Email">\n  <input type="password" placeholder="Password">\n  <button type="submit">Sign Up</button>\n</form>',
        keyTakeaway: 'Always use the correct input type (email, password, number, date). Browsers automatically validate and display the right keyboard on mobile.',
        codeSnippet: '<form>\n  <label for="email">Email:</label>\n  <input id="email" type="email" required>\n  \n  <select name="country">\n    <option>India</option>\n    <option>USA</option>\n  </select>\n  \n  <button>Submit</button>\n</form>',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does HTML stand for?',
        options: ['Hyper Transfer Markup Language', 'HyperText Markup Language', 'High Text Machine Language', 'HyperText Machine Learning'],
        correctIndex: 1,
        explanation: 'HTML = HyperText Markup Language. "HyperText" refers to links that connect pages. "Markup" means you are annotating text with tags to give it structure.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which tag is the correct semantic element for the main navigation of a webpage?',
        options: ['<div class="nav">', '<navigation>', '<nav>', '<menu>'],
        correctIndex: 2,
        explanation: '<nav> is the semantic HTML5 element for navigation links. It tells browsers, screen readers, and search engines: "this is the main navigation area".',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which HTML attribute makes a form field required?',
        options: ['mandatory', 'required', 'validate', 'necessary'],
        correctIndex: 1,
        explanation: 'The "required" attribute prevents form submission if the field is empty. Browsers show a validation message automatically — no JavaScript needed.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Which HTML tag should you use for the main written content of a blog post?',
        options: ['<section>', '<div>', '<article>', '<content>'],
        correctIndex: 2,
        explanation: '<article> is the semantic element for self-contained content like blog posts, news articles, or forum posts. It can be shared independently from the rest of the page.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Personal Portfolio Page',
      goal: 'Build a structured HTML page for your personal developer portfolio.',
      steps: [
        'Create the HTML boilerplate (doctype, html, head, body)',
        'Add a <header> with your name as <h1> and a <nav> with links',
        'Create a <main> section with an <article> describing yourself',
        'Add a skills section using an unordered list <ul>',
        'Add a contact <form> with name, email, and message fields',
        'Close with a <footer> containing your copyright',
      ],
      expectedOutput: 'A complete HTML page with header, nav, about section, skills list, contact form, and footer — all using semantic tags.',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // AI & DATA
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'ml_fundamentals',
    topicTitle: 'Machine Learning Fundamentals',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 150,
    emoji: '🤖',
    intro: 'Machine learning is the technology behind ChatGPT, Netflix recommendations, and self-driving cars. In this lesson, you\'ll understand exactly how machines "learn" from data — and write your first ML model logic.',
    concepts: [
      ConceptLesson(
        title: 'What is Machine Learning?',
        definition: 'Machine Learning is a subset of AI where systems learn patterns from data and improve their performance without being explicitly programmed for each task.',
        analogy: 'Traditional programming: You write rules. ML: You show the computer thousands of examples and it figures out the rules itself. Like teaching a child — you don\'t explain every grammar rule, you just show them enough sentences and they learn.',
        example: 'Traditional: if price < 5000 AND sqft > 1000 then = "good deal"\nML: Show 10,000 house prices and let the model discover the patterns itself.',
        keyTakeaway: 'ML finds patterns in data that humans can\'t easily code. The more quality data you have, the better the model learns.',
        codeSnippet: '# ML in 5 lines with scikit-learn\nfrom sklearn.linear_model import LinearRegression\nimport numpy as np\n\nX = np.array([[1], [2], [3], [4], [5]])\ny = np.array([2, 4, 6, 8, 10])\n\nmodel = LinearRegression()\nmodel.fit(X, y)  # LEARN\nprint(model.predict([[6]]))  # PREDICT → [12]',
      ),
      ConceptLesson(
        title: 'Supervised vs Unsupervised Learning',
        definition: 'Supervised learning trains on labelled data (input + correct answer). Unsupervised learning finds patterns in unlabelled data.',
        analogy: 'Supervised = learning with a teacher who marks your homework (tells you right/wrong). Unsupervised = exploring a new city alone and grouping similar-looking buildings yourself.',
        example: 'Supervised: Classify emails as spam/not spam using 10,000 labelled examples.\nUnsupervised: Group 1 million customers into segments without knowing the segments in advance.',
        keyTakeaway: 'Supervised: you have labelled training data. Unsupervised: you\'re discovering structure. Reinforcement: learning by trial and reward.',
      ),
      ConceptLesson(
        title: 'Training, Validation & Testing',
        definition: 'You split your data into 3 sets: Training (learn), Validation (tune), Test (final evaluation).',
        analogy: 'Training data = textbook exercises with answers. Validation data = practice exam (no official grade). Test data = the real final exam. You only look at test data once — at the very end.',
        example: 'Split:\n• Training: 70% — model learns from this\n• Validation: 15% — tune hyperparameters\n• Test: 15% — final unbiased evaluation\n\nNEVER use test data to make decisions during development.',
        keyTakeaway: 'Overfitting: model memorises training data but fails on new data. Always evaluate on unseen test data for honest performance numbers.',
        codeSnippet: 'from sklearn.model_selection import train_test_split\n\nX_train, X_test, y_train, y_test = train_test_split(\n    X, y, test_size=0.2, random_state=42)\n\nmodel.fit(X_train, y_train)\nscore = model.score(X_test, y_test)',
      ),
      ConceptLesson(
        title: 'Model Evaluation Metrics',
        definition: 'Metrics measure how good your model is. Different problems need different metrics.',
        analogy: 'Judging a chef differently for different meals: dessert = taste (accuracy), restaurant = profit (precision), hospital food = no allergic reactions (recall). The metric must match what matters.',
        example: 'Classification:\n• Accuracy: % correct predictions\n• Precision: when you say positive, how often right?\n• Recall: how many actual positives did you find?\n• F1: balance of precision and recall',
        keyTakeaway: 'Accuracy is misleading for imbalanced datasets. If 99% of emails are not spam, predicting "not spam" always gives 99% accuracy but catches zero spam.',
        codeSnippet: 'from sklearn.metrics import accuracy_score, f1_score\n\ny_pred = model.predict(X_test)\nprint(accuracy_score(y_test, y_pred))\nprint(f1_score(y_test, y_pred))',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which type of ML is used when you have labelled training data?',
        options: ['Unsupervised Learning', 'Reinforcement Learning', 'Supervised Learning', 'Transfer Learning'],
        correctIndex: 2,
        explanation: 'Supervised Learning uses labelled data — each training example has an input AND a correct output. The model learns to map inputs to outputs.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is overfitting in machine learning?',
        options: [
          'Model trains too slowly',
          'Model performs well on training data but poorly on new data',
          'Model has too many features',
          'Model accuracy is above 99%'
        ],
        correctIndex: 1,
        explanation: 'Overfitting means the model memorised the training data instead of learning general patterns. It performs great on training data but fails on unseen data — the real-world test.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'You\'re building a cancer detection model. 99% of patients are healthy. Why is accuracy alone a bad metric?',
        options: [
          'Accuracy is always a bad metric',
          'A model predicting everyone as healthy gets 99% accuracy but catches zero cancer cases',
          'Accuracy is too hard to calculate',
          'Cancer datasets are too small'
        ],
        correctIndex: 1,
        explanation: 'This is the "class imbalance" problem. A model that always predicts "no cancer" gets 99% accuracy but is completely useless. You need Recall — catching all actual cancer cases — as the primary metric.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You want to group 1 million users by their behaviour patterns, but you don\'t know the groups in advance. Which type of ML should you use?',
        options: ['Supervised Learning', 'Unsupervised Learning', 'Reinforcement Learning', 'Deep Learning only'],
        correctIndex: 1,
        explanation: 'Unsupervised learning (specifically clustering algorithms like k-means) is designed for discovering structure in unlabelled data. You don\'t need to know the groups beforehand.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'What is the correct data split order for building an ML model?',
        options: [
          'Test → Validate → Train',
          'Train → Test → Validate',
          'Train on all data, then test',
          'Train → Validate → Test (in that order)'
        ],
        correctIndex: 3,
        explanation: 'You train first, tune hyperparameters using validation data, and ONLY look at test data once at the very end. Looking at test data during development is "data leakage" and gives dishonest results.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'House Price Predictor',
      goal: 'Build a simple ML model that predicts house prices based on size and number of rooms.',
      steps: [
        'Create training data: list of (size_sqft, rooms, price) tuples',
        'Split into training and test sets (80/20 split)',
        'Train a LinearRegression model on the training data',
        
        'Evaluate using Mean Absolute Error on test data',
        'Predict the price of a 1500 sqft house with 3 rooms',
        'Print: "Predicted price: ₹X" and "Model MAE: Y"',
      ],
      expectedOutput: 'Model trained successfully!\nTest MAE: ₹45,000\nPredicted price for 1500 sqft, 3 rooms: ₹85,00,000',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // CLOUD & DEVOPS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'docker_basics',
    topicTitle: 'Docker & Containerisation',
    careerId: 'devops_engineer',
    categoryId: 'cloud_devops',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '🐳',
    intro: 'Docker changed how software is built and deployed forever. Before Docker, "it works on my machine" was the #1 developer complaint. After Docker, your code runs identically everywhere — development, testing, production. Let\'s learn why.',
    concepts: [
      ConceptLesson(
        title: 'What is Docker?',
        definition: 'Docker is a platform that packages your application and ALL its dependencies into a standardised unit called a container, which runs identically on any machine.',
        analogy: 'Docker is like a shipping container for software. Before shipping containers, loading cargo was chaotic. After — standard size, fits any ship, any port. Docker does the same for software.',
        example: 'Without Docker: "App works on my laptop (Ubuntu) but crashes on the server (CentOS)."\nWith Docker: Package app + Ubuntu + dependencies → runs identically on any server.',
        keyTakeaway: 'Containers solve the "works on my machine" problem. Docker images are immutable snapshots. Containers are running instances of those images.',
        codeSnippet: '# Run any app in one command\ndocker run -p 8080:80 nginx\n\n# Now visit http://localhost:8080\n# Nginx is running inside a container!',
      ),
      ConceptLesson(
        title: 'Dockerfile — Building Images',
        definition: 'A Dockerfile is a text file with instructions to build a Docker image. Think of it as a recipe for creating your container.',
        analogy: 'A Dockerfile is like an IKEA instruction manual. Follow the steps and you always get the exact same furniture. Another developer follows your Dockerfile and gets the exact same environment.',
        example: 'FROM python:3.11     # Start with Python base\nWORKDIR /app         # Set working directory\nCOPY . .             # Copy your code in\nRUN pip install -r requirements.txt  # Install dependencies\nCMD ["python", "app.py"]  # What to run',
        keyTakeaway: 'Each instruction in a Dockerfile creates a cached "layer". Only changed layers rebuild, making Docker builds very fast.',
        codeSnippet: '# Build and run your image\ndocker build -t my-app .\ndocker run -p 5000:5000 my-app\n\n# List running containers\ndocker ps',
      ),
      ConceptLesson(
        title: 'Docker Compose',
        definition: 'Docker Compose lets you define and run multi-container applications with a single YAML file.',
        analogy: 'Starting a web app needs: a database, a backend server, and a web server. Without Compose, you start 3 containers manually. With Compose, one command starts all 3 in the right order.',
        example: 'docker-compose.yml:\nservices:\n  web:\n    build: .\n    ports: ["5000:5000"]\n  db:\n    image: postgres\n    environment:\n      POSTGRES_PASSWORD: secret',
        keyTakeaway: 'docker-compose up starts all services. docker-compose down stops everything. Essential for local development with multiple services.',
        codeSnippet: '# Start all services\ndocker-compose up -d\n\n# View logs\ndocker-compose logs -f\n\n# Stop all services\ndocker-compose down',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What problem does Docker primarily solve?',
        options: [
          'Makes code run faster',
          'Replaces cloud servers',
          'Ensures app runs identically across all environments',
          'Provides database storage'
        ],
        correctIndex: 2,
        explanation: 'Docker solves the "it works on my machine" problem by packaging your app with ALL its dependencies into a container that runs identically on any machine — dev laptop, CI server, or production cloud.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the difference between a Docker Image and a Docker Container?',
        options: [
          'They are the same thing',
          'Image is running, Container is stopped',
          'Image is a blueprint (snapshot), Container is a running instance',
          'Container is stored on disk, Image runs in memory'
        ],
        correctIndex: 2,
        explanation: 'A Docker Image is an immutable snapshot/blueprint. A Container is a running instance of that image. You can run many containers from one image, just like running many programs from one installer.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Which Dockerfile instruction sets the command that runs when a container starts?',
        options: ['RUN', 'START', 'CMD', 'EXECUTE'],
        correctIndex: 2,
        explanation: 'CMD sets the default command to run when a container starts. RUN executes commands DURING the build phase to install software. CMD runs AFTER the container is started.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Containerise a Python Web App',
      goal: 'Write a Dockerfile for a FastAPI application and run it in a container.',
      steps: [
        'Create a simple FastAPI app in app.py with one endpoint: GET /health → {"status": "ok"}',
        'Create requirements.txt with: fastapi and uvicorn',
        'Write a Dockerfile: FROM python:3.11-slim, WORKDIR /app, COPY, RUN pip install, EXPOSE 8000, CMD uvicorn',
        'Build the image: docker build -t my-fastapi .',
        'Run the container: docker run -p 8000:8000 my-fastapi',
        'Test: curl http://localhost:8000/health',
      ],
      expectedOutput: '{"status": "ok"}\n\nContainer is running! Your API is accessible at localhost:8000',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // CYBER SECURITY
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'networking_security',
    topicTitle: 'Networking Fundamentals',
    careerId: 'ethical_hacker',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '🔒',
    intro: 'Every cyberattack travels through a network. To defend systems (or ethically test them), you must understand how data moves across the internet. This knowledge is the foundation of every security career.',
    concepts: [
      ConceptLesson(
        title: 'OSI Model — 7 Layers',
        definition: 'The OSI model is a conceptual framework that describes how network communication happens in 7 distinct layers, from physical cables to user applications.',
        analogy: 'Sending a letter through a postal system has layers: you write it (Application), put in an envelope (Presentation), address it (Session), choose express or standard (Transport), choose a route (Network), the postman delivers it (Data Link), and physically carries it (Physical).',
        example: '7. Application  — HTTP, FTP, DNS, SMTP\n6. Presentation — SSL/TLS encryption, compression\n5. Session      — Connection management\n4. Transport    — TCP (reliable) / UDP (fast)\n3. Network      — IP addresses, routing\n2. Data Link    — MAC addresses, switches\n1. Physical     — Cables, Wi-Fi signals',
        keyTakeaway: 'Hackers attack different OSI layers: phishing (Layer 7), SSL stripping (Layer 6), IP spoofing (Layer 3). Knowing layers helps you understand where each attack happens.',
      ),
      ConceptLesson(
        title: 'TCP/IP — How the Internet Works',
        definition: 'TCP/IP is the actual protocol suite the internet uses. TCP ensures reliable delivery. IP handles addressing and routing.',
        analogy: 'IP is like the postal address system — it finds the destination. TCP is like a certified mail service — it guarantees every piece arrives, in order, and asks for re-delivery if anything is lost.',
        example: 'When you visit google.com:\n1. DNS converts "google.com" → IP address (142.250.180.78)\n2. TCP creates a connection (3-way handshake: SYN → SYN-ACK → ACK)\n3. Your browser sends HTTP request\n4. Google\'s server sends HTML response\n5. TCP closes the connection',
        keyTakeaway: 'TCP is connection-oriented (reliable). UDP is connectionless (fast but no guarantee). Security: TCP\'s handshake can be exploited in SYN flood attacks.',
        codeSnippet: '# Quick port scan with Python\nimport socket\nfor port in [22, 80, 443, 3306, 5432]:\n    sock = socket.socket()\n    result = sock.connect_ex(("127.0.0.1", port))\n    if result == 0:\n        print(f"Port {port}: OPEN")\n    sock.close()',
      ),
      ConceptLesson(
        title: 'Common Protocols & Ports',
        definition: 'Protocols are rules for communication. Ports are virtual "doors" on a server that map to specific services.',
        analogy: 'An IP address is like a hotel address. Ports are like room numbers. Port 80 = Room 80 (HTTP/reception). Port 443 = Room 443 (HTTPS/VIP). Port 22 = Room 22 (SSH/staff).',
        example: 'Port 22  → SSH (Secure Shell — remote server access)\nPort 80  → HTTP (unencrypted web)\nPort 443 → HTTPS (encrypted web)\nPort 3306→ MySQL database\nPort 5432→ PostgreSQL database\nPort 25  → SMTP (email sending)',
        keyTakeaway: 'As a security professional: exposed database ports (3306, 5432) to the internet = critical vulnerability. Open unnecessary ports = attack surface.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'At which OSI layer does IP addressing and routing occur?',
        options: ['Layer 1 (Physical)', 'Layer 4 (Transport)', 'Layer 3 (Network)', 'Layer 7 (Application)'],
        correctIndex: 2,
        explanation: 'Layer 3 (Network) handles IP addresses and routing. Routers operate at this layer, directing packets from source to destination across multiple networks.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the default port for HTTPS (encrypted web traffic)?',
        options: ['80', '8080', '22', '443'],
        correctIndex: 3,
        explanation: 'HTTPS uses port 443. HTTP uses port 80. The "S" in HTTPS means the traffic is encrypted with TLS. Browsers automatically add ":443" even when you don\'t type it.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You find a server with port 3306 open to the internet. What is the SECURITY risk?',
        options: [
          'No risk — port 3306 is safe',
          'Port 3306 is MySQL. Exposing a database directly is critical — attackers can attempt to authenticate and steal all data',
          'The server will run slower',
          'It only affects email services'
        ],
        correctIndex: 1,
        explanation: 'Port 3306 is MySQL. Databases should NEVER be directly exposed to the internet. Attackers can attempt brute-force login, exploit vulnerabilities, or cause denial-of-service. Databases should only be accessible from the app server (private network).',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Network Port Scanner',
      goal: 'Build a Python tool that scans a target host for open ports and identifies common services.',
      steps: [
        'Import socket and define a list of common ports to scan (21, 22, 23, 25, 53, 80, 110, 143, 443, 3306, 5432, 6379)',
        'Define a dict mapping port numbers to service names',
        'For each port, attempt a socket connection with a 1-second timeout',
        'If connection succeeds: print "Port X (SERVICE): OPEN"',
        'If connection fails: mark as closed (optional, skip in output)',
        'Add execution time measurement and print summary',
      ],
      expectedOutput: 'Scanning localhost...\nPort 22  (SSH): OPEN\nPort 80  (HTTP): OPEN\nPort 443 (HTTPS): OPEN\nScan complete. 3 open ports found in 2.1 seconds.',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // DESIGN & PRODUCT
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'ux_fundamentals',
    topicTitle: 'UX Fundamentals',
    careerId: 'ux_designer',
    categoryId: 'design_product',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 100,
    emoji: '🎨',
    intro: 'Great UX is invisible — users accomplish their goals without even thinking about the interface. Bad UX makes people frustrated and quit. After this lesson, you\'ll see every app through the eyes of a UX designer and never use an app the same way again.',
    concepts: [
      ConceptLesson(
        title: 'What is UX Design?',
        definition: 'UX (User Experience) Design is the process of creating products that provide meaningful, relevant experiences to users. It encompasses the entire journey of acquiring and integrating the product.',
        analogy: 'UX is the difference between a confusing hospital (you can\'t find the right department) and a well-designed one (clear signage, logical layout, friendly staff). The medical care might be identical — the experience is completely different.',
        example: 'Good UX: Instagram\'s camera button is always in the same place. You never think about where it is.\nBad UX: A checkout form that clears all fields if you make one mistake. You feel punished, not helped.',
        keyTakeaway: 'UX is not just visual design. It\'s research, information architecture, interaction design, usability testing, and accessibility — all combined.',
      ),
      ConceptLesson(
        title: 'The 5 Stages of Design Thinking',
        definition: 'Design Thinking is a human-centred problem-solving framework with 5 iterative stages.',
        analogy: 'Design thinking is how a doctor diagnoses: Empathise (listen to the patient), Define (identify the real problem), Ideate (consider treatments), Prototype (try a treatment), Test (monitor results). Repeat until the patient is well.',
        example: '1. EMPATHISE: Interview users. What frustrates them? What do they need?\n2. DEFINE: "Users need X because Y" — clear problem statement\n3. IDEATE: Brainstorm 10+ solutions. No judgement yet.\n4. PROTOTYPE: Build the simplest version that can be tested\n5. TEST: Watch real users use it. Take notes. Iterate.',
        keyTakeaway: 'Design Thinking is not linear. You go back to earlier stages constantly. The biggest mistake is skipping "Empathise" and solving the wrong problem.',
      ),
      ConceptLesson(
        title: 'UX Laws You Must Know',
        definition: 'UX laws are proven principles based on human psychology that predict how users will interact with interfaces.',
        analogy: 'These laws are like the laws of gravity for design. You can\'t break them without consequences. Break Fitts\'s Law (small click targets) and users will miss. Break Miller\'s Law (too many options) and users will freeze.',
        example: 'Fitts\'s Law: Make clickable targets bigger and closer.\nHick\'s Law: More choices = longer decision time. Reduce options.\nMiller\'s Law: People can hold 7±2 items in working memory. Limit lists.\nJakob\'s Law: Users spend time on other sites. Match familiar patterns.',
        keyTakeaway: 'The best design is one users already know how to use before they start. Use familiar patterns. Save cognitive effort for content, not navigation.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does UX stand for?',
        options: ['Universal Excellence', 'User Experience', 'UI Expertise', 'Unified Exchange'],
        correctIndex: 1,
        explanation: 'UX = User Experience. It encompasses every aspect of a user\'s interaction with a product — how it feels, how easy it is to use, and whether it meets their needs.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'According to Hick\'s Law, what happens when you give users MORE choices?',
        options: [
          'They are happier',
          'They decide faster',
          'They take longer to decide (decision paralysis)',
          'The app feels more premium'
        ],
        correctIndex: 2,
        explanation: 'Hick\'s Law: Decision time increases logarithmically with the number of choices. This is why great UX reduces options. Netflix shows 5 featured shows, not 500, on the home screen.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A checkout form has 15 required fields. Users abandon it at 80%. What is the PRIMARY UX fix?',
        options: [
          'Make the form prettier with better colours',
          'Add a progress bar',
          'Reduce required fields to the minimum necessary (usually name, email, payment)',
          'Make the font larger'
        ],
        correctIndex: 2,
        explanation: 'Form abandonment is almost always caused by too many fields. Amazon showed that removing "Company Name" from their checkout form increased conversions by 5%. Every unnecessary field costs you users.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'UX Audit Report',
      goal: 'Conduct a beginner UX audit of any popular app and document 5 UX issues with solutions.',
      steps: [
        'Choose an app (Zomato, Paytm, LinkedIn, etc.)',
        'Use it for 10 minutes as a first-time user',
        'Document 5 UX issues you encounter (confusion, friction, unclear labels)',
        'For each issue: describe the problem, which UX law it violates, and propose a solution',
        'Rate each issue: Critical / Major / Minor',
        'Write a one-paragraph executive summary',
      ],
      expectedOutput: '5 UX Issues documented with:\n- Description of the problem\n- Which UX law is violated\n- Proposed solution\n- Severity rating\n+ Executive summary',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // EMERGING TECH
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'blockchain_fundamentals',
    topicTitle: 'Blockchain Fundamentals',
    careerId: 'blockchain_dev',
    categoryId: 'emerging_tech',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '⛓️',
    intro: 'Blockchain is one of the most misunderstood technologies in the world. Most people only know "Bitcoin" — but the underlying technology is revolutionising finance, supply chains, gaming, and identity. Let\'s understand it from first principles.',
    concepts: [
      ConceptLesson(
        title: 'What is a Blockchain?',
        definition: 'A blockchain is a distributed ledger — a shared database that is replicated across thousands of computers, where each block of data is cryptographically linked to the previous one.',
        analogy: 'Imagine a Google Doc that: (1) everyone has a copy of, (2) once you write something, it can never be erased, and (3) everyone can verify every change ever made. That\'s a blockchain.',
        example: 'Traditional database: Bank owns a single ledger. Bank says "Alice has ₹10,000". You trust the bank.\n\nBlockchain: 10,000 computers each have a copy. Alice\'s balance is verified by consensus. No single entity controls it.',
        keyTakeaway: 'Blockchain is NOT just Bitcoin. Bitcoin is one application. The technology enables trustless, transparent, immutable record-keeping without a central authority.',
      ),
      ConceptLesson(
        title: 'How Blocks are Created',
        definition: 'A block contains: a list of transactions, a timestamp, and a cryptographic hash of the PREVIOUS block. This chaining is what makes it tamper-proof.',
        analogy: 'Imagine a series of safes where each safe\'s combination lock code is derived from the contents of the previous safe. Change the contents of Safe #3, and all combinations for Safes #4, #5, #6 break. This is immutability.',
        example: 'Block 1: [transactions | timestamp | prev_hash: 0000 | hash: abc123]\nBlock 2: [transactions | timestamp | prev_hash: abc123 | hash: def456]\nBlock 3: [transactions | timestamp | prev_hash: def456 | hash: ghi789]\n\nChange Block 2? Hash changes → Block 3 breaks → invalid chain.',
        keyTakeaway: 'The hash of every block includes the previous block\'s hash. Tampering with ANY historical block invalidates all subsequent blocks — making fraud computationally infeasible.',
      ),
      ConceptLesson(
        title: 'Smart Contracts',
        definition: 'A smart contract is self-executing code stored on a blockchain that automatically enforces the terms of an agreement when predefined conditions are met.',
        analogy: 'A vending machine is like a physical smart contract. Insert ₹50 (condition), press button (trigger), get snack (automatic execution). No vendor needed. No trust needed. The machine just works as programmed.',
        example: 'Traditional: Buyer and seller need a lawyer to hold funds in escrow.\nSmart Contract: Code automatically releases funds to seller ONLY when buyer confirms delivery. No lawyer, no trust required.',
        keyTakeaway: 'Smart contracts run on Ethereum. Written in Solidity. Cannot be modified after deployment. Code is law. This is powerful AND dangerous — bugs are permanent.',
        codeSnippet: '// Simple Solidity smart contract\npragma solidity ^0.8.0;\n\ncontract SimpleStorage {\n    uint256 public storedData;\n    \n    function set(uint256 x) public {\n        storedData = x;\n    }\n    \n    function get() public view returns (uint256) {\n        return storedData;\n    }\n}',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What makes blockchain data tamper-proof?',
        options: [
          'It uses very strong passwords',
          'Each block\'s hash includes the previous block\'s hash, so changing any block breaks all subsequent blocks',
          'It is stored on government servers',
          'Only admins can read the data'
        ],
        correctIndex: 1,
        explanation: 'Cryptographic linking: each block contains a hash of the previous block. Change block 500, and blocks 501 through the current block all have invalid hashes. You\'d need to redo proof-of-work for the entire chain — computationally infeasible.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is a Smart Contract?',
        options: [
          'A legal contract written digitally',
          'Self-executing code on a blockchain that runs automatically when conditions are met',
          'A contract that can be modified by both parties',
          'A database stored in the cloud'
        ],
        correctIndex: 1,
        explanation: 'Smart contracts are programs stored on the blockchain that execute automatically when predetermined conditions are met. They are immutable — once deployed, they cannot be changed.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A startup wants to create a decentralised voting system for elections. Why is blockchain a good fit?',
        options: [
          'It\'s faster than traditional systems',
          'Votes are immutable, transparent, and verifiable by anyone without trusting a central authority',
          'Blockchain is cheaper than traditional databases',
          'Blockchain only works for financial applications'
        ],
        correctIndex: 1,
        explanation: 'Blockchain is ideal for voting because: (1) votes cannot be changed after submission (immutable), (2) anyone can verify results (transparent), (3) no single authority can manipulate results (decentralised). These are exactly the requirements for trustworthy elections.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Simple Blockchain in Python',
      goal: 'Build a simplified blockchain with blocks, hashing, and chain validation.',
      steps: [
        'Import hashlib. Create a Block class with: index, data, previous_hash, hash, timestamp',
        'Calculate hash using SHA-256 of (index + data + previous_hash + timestamp)',
        'Create a Blockchain class with a genesis block (first block, previous_hash = "0")',
        'Add an add_block(data) method that creates a new block linked to the previous',
        'Add a is_valid() method that verifies all hashes are correct and chains are linked',
        'Test: add 3 blocks, print the chain, tamper with block 2, verify chain is now invalid',
      ],
      expectedOutput: 'Block 0: Hash=abc123, Data=Genesis\nBlock 1: Hash=def456, Data=Alice sent 5 BTC to Bob\nBlock 2: Hash=ghi789, Data=Bob sent 2 BTC to Charlie\nChain valid: True\n\n[TAMPER] Modified Block 1...\nChain valid: False — Block 2 hash mismatch!',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // TESTING & QA
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'software_testing_fundamentals',
    topicTitle: 'Software Testing Fundamentals',
    careerId: 'qa_engineer',
    categoryId: 'testing_qa',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 100,
    emoji: '🧪',
    intro: 'Every app you\'ve ever used that "just works" — someone made sure it works. QA engineers are the guardians of software quality. They catch bugs before users do. Without them, apps crash, data is lost, and companies lose millions. Let\'s learn the foundations.',
    concepts: [
      ConceptLesson(
        title: 'Why Testing Matters',
        definition: 'Software testing is the process of evaluating software to detect differences between expected and actual behaviour.',
        analogy: 'Would you drive a car that was never tested? Or fly in a plane? Software runs in hospitals, banks, nuclear plants. A bug in the wrong place can cost lives. Testing is quality insurance.',
        example: 'Famous bugs that cost billions:\n• Ariane 5 rocket: integer overflow → ₹5,700 crore rocket destroyed\n• Therac-25 radiation machine: race condition → 6 patients received fatal radiation doses\n• Knight Capital: trading algorithm bug → ₹3,400 crore loss in 45 minutes',
        keyTakeaway: 'Prevention > Cure. A bug found by a developer costs ₹100 to fix. Found by QA: ₹1,000. Found by a customer: ₹10,000. Found in production at a bank: ₹1 crore+.',
      ),
      ConceptLesson(
        title: 'Testing Types — The Testing Pyramid',
        definition: 'The Testing Pyramid defines 3 levels of tests: Unit (many, fast, cheap) → Integration (medium) → End-to-End (few, slow, expensive).',
        analogy: 'The pyramid is like a building inspection. Many small checks (unit tests = checking each brick), some combination checks (integration tests = checking walls), few full walk-throughs (E2E tests = inspecting the entire building).',
        example: 'Unit Tests: Test one function in isolation\n  → "Does calculateTax(100000) return 20000?"\n\nIntegration Tests: Test multiple components together\n  → "Does the login API work with the database?"\n\nE2E Tests: Test entire user journey\n  → "Can a user sign up, add an item to cart, and checkout?"',
        keyTakeaway: 'Have MANY unit tests (fast, reliable), SOME integration tests, FEW E2E tests (slow, fragile). The inverted pyramid is an anti-pattern.',
      ),
      ConceptLesson(
        title: 'Writing Your First Test Case',
        definition: 'A test case defines: what to test, how to test it, what inputs to use, and what result is expected.',
        analogy: 'A test case is like a recipe with expected results. Ingredients (inputs) + Method (steps) + Expected dish (expected output). If the dish tastes different, something went wrong.',
        example: 'Test Case: Login with valid credentials\n\nPrecondition: User account exists (email: test@test.com, pass: Test@123)\nSteps:\n1. Navigate to /login\n2. Enter email: test@test.com\n3. Enter password: Test@123\n4. Click "Login"\n\nExpected: Redirect to /dashboard with "Welcome!" message\nActual: [fill in during testing]\nStatus: PASS / FAIL',
        keyTakeaway: 'Always test: happy path (valid inputs), negative path (invalid inputs), edge cases (empty, null, maximum values). Test all three for complete coverage.',
        codeSnippet: '# Python unit test example\nimport unittest\n\ndef add(a, b):\n    return a + b\n\nclass TestAdd(unittest.TestCase):\n    def test_positive(self):\n        self.assertEqual(add(2, 3), 5)\n    \n    def test_negative(self):\n        self.assertEqual(add(-1, -1), -2)\n    \n    def test_zero(self):\n        self.assertEqual(add(0, 0), 0)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'According to the Testing Pyramid, which type of test should you have THE MOST of?',
        options: ['End-to-End Tests', 'Integration Tests', 'Unit Tests', 'Manual Tests'],
        correctIndex: 2,
        explanation: 'Unit tests form the base of the pyramid — you should have the most. They are fast (milliseconds), isolated, and cheap to write. E2E tests are at the top — few, slow, and expensive.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the purpose of "negative testing"?',
        options: [
          'Testing that the app fails slowly',
          'Testing the app with invalid or unexpected inputs to ensure it handles them gracefully',
          'Writing tests with a negative attitude',
          'Testing only the features that might fail'
        ],
        correctIndex: 1,
        explanation: 'Negative testing verifies that the system handles invalid inputs correctly — showing error messages, not crashing, not accepting bad data. Example: entering "abc" in a phone number field should show "Invalid phone number", not crash the app.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Which test would you write MOST of in a well-structured test suite?',
        options: [
          'Manual test cases in Excel',
          'End-to-End tests that simulate full user journeys',
          'Unit tests for individual functions',
          'Performance tests'
        ],
        correctIndex: 2,
        explanation: 'Unit tests should be the most numerous. They are fast (run in milliseconds), isolated (no database needed), and cheap to maintain. A healthy project might have 500 unit tests, 100 integration tests, and 20 E2E tests.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Test Suite for a Calculator',
      goal: 'Write comprehensive unit tests for a calculator with add, subtract, multiply, divide functions.',
      steps: [
        'Create calculator.py with 4 functions: add, subtract, multiply, divide',
        'Handle divide by zero in the divide function (raise ValueError)',
        'Create test_calculator.py using unittest',
        'Write at least 3 tests per function (happy path, negative numbers, zero)',
        'Write 2 negative tests for divide (divide by zero should raise error)',
        'Run tests and achieve 100% pass rate',
      ],
      expectedOutput: 'Ran 14 tests in 0.001s\n\nOK\n\nAll 14 tests passed!\nCoverage: 100%',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // SPECIALIZED
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'enterprise_architecture',
    topicTitle: 'Enterprise Architecture Foundations',
    careerId: 'solutions_architect',
    categoryId: 'specialized',
    difficulty: 'Hard',
    estimatedMinutes: 35,
    totalXp: 180,
    emoji: '🏗️',
    intro: 'Solutions Architects are the most senior and highest-paid engineers at major tech companies. They see the whole picture when everyone else sees only their piece. This lesson teaches you to think at the system level — designing for millions of users, years of growth, and zero downtime.',
    concepts: [
      ConceptLesson(
        title: 'What is Enterprise Architecture?',
        definition: 'Enterprise Architecture (EA) is the practice of aligning an organisation\'s business strategy with its technology infrastructure through structured frameworks and principles.',
        analogy: 'An Enterprise Architect is like the master architect of a city — not just designing one building, but deciding how all buildings, roads, utilities, and parks work together for the next 20 years.',
        example: 'A startup with 5 engineers: monolith app, single database, deployed on one server. Fine.\n\nSame company with 1000 engineers, 10M users: monolith becomes a bottleneck. EA redesigns → microservices, distributed databases, event-driven architecture.',
        keyTakeaway: 'Architecture decisions made today constrain decisions for years. The cost of wrong architecture compounds. Great architects optimise for change — the ability to evolve the system.',
      ),
      ConceptLesson(
        title: 'Architecture Decision Records (ADRs)',
        definition: 'An ADR is a document that captures an important architectural decision, its context, the options considered, and the reasoning behind the choice.',
        analogy: 'An ADR is like a ship\'s log for software decisions. "On this date, we chose X over Y because Z. The trade-offs accepted were A and B." Future engineers don\'t wonder why — they read the log.',
        example: 'ADR #1: Use PostgreSQL over MongoDB\n\nContext: We need to store user financial data with complex relationships\nDecision: PostgreSQL\nReasoned because: ACID compliance, complex joins needed, mature ecosystem\nTrade-offs: Less flexible schema than MongoDB, harder to shard horizontally\nConsequences: All services must use PostgreSQL. Migration requires approval.',
        keyTakeaway: 'ADRs prevent "why did we do this?!" debates years later. Every significant architecture decision should have an ADR. They are living documents — supersede them when decisions change.',
      ),
      ConceptLesson(
        title: 'Non-Functional Requirements (NFRs)',
        definition: 'NFRs define HOW a system should work, not WHAT it should do. They include performance, reliability, scalability, security, and maintainability.',
        analogy: 'Functional requirements are "the car must seat 5 people and have A/C". Non-functional requirements are "it must go 0-100 in 4 seconds, last 15 years, be safe in a crash, and use less than 7L/100km". Both matter enormously.',
        example: 'NFR Examples for a payment system:\n• Performance: P99 response time < 200ms\n• Availability: 99.99% uptime (< 52 min downtime/year)\n• Security: PCI-DSS Level 1 compliance\n• Scalability: Handle 100,000 transactions/second at peak\n• Recovery: RPO 4 hours, RTO 1 hour',
        keyTakeaway: 'NFRs drive 80% of architecture decisions. "We need 99.99% uptime" completely changes your architecture vs "99% uptime". Clarify NFRs before designing anything.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does an Architecture Decision Record (ADR) primarily document?',
        options: [
          'The cost of infrastructure',
          'A significant architectural decision, its context, options considered, and reasoning',
          'The number of engineers on a project',
          'Database schema changes'
        ],
        correctIndex: 1,
        explanation: 'ADRs capture the CONTEXT, DECISION, OPTIONS CONSIDERED, and CONSEQUENCES of significant architectural choices. They answer "why did we build it this way?" for future engineers.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which of these is a Non-Functional Requirement?',
        options: [
          'Users can log in with email and password',
          'The system must handle 100,000 concurrent users',
          'Products can be added to a shopping cart',
          'Users can filter products by category'
        ],
        correctIndex: 1,
        explanation: 'NFRs define HOW the system behaves (performance, scalability, security, reliability) — not WHAT it does. "Handle 100,000 concurrent users" is a performance/scalability NFR. Login, cart, and filter are all functional requirements.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A startup\'s monolith app is causing deployment problems — one team\'s code change breaks another team\'s features. What architectural change should you recommend?',
        options: [
          'Add more servers',
          'Rewrite the entire app in a different programming language',
          'Decompose into microservices so each team owns and deploys their service independently',
          'Hire more QA engineers'
        ],
        correctIndex: 2,
        explanation: 'Tight coupling in a monolith causes deployment conflicts. Microservices give each team ownership of their bounded context — they deploy independently without affecting other services. This is called "Conway\'s Law" — organisations build systems that mirror their communication structure.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Architecture Document: E-Commerce Platform',
      goal: 'Write a complete 1-page architecture document for a new e-commerce platform expecting 1M users at launch.',
      steps: [
        'Define the NFRs: availability (99.9%), P99 latency (<500ms), concurrent users (50,000), data retention (7 years)',
        'Identify the main services needed: Product, Order, Payment, User, Notification',
        'Choose a database for each service with justification (SQL vs NoSQL)',
        'Design the high-level architecture: API Gateway → Services → Databases',
        'Identify 3 potential failure points and how to mitigate each',
        'Write 1 Architecture Decision Record for the most important decision you made',
      ],
      expectedOutput: 'Architecture Document containing:\n- NFR table (5 requirements)\n- Service diagram (5 services)\n- Database decisions with justification\n- 3 failure mitigation strategies\n- 1 complete ADR',
      xpReward: 50,
    ),
  ),
];