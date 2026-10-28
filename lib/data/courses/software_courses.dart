// ══════════════════════════════════════════════════════════════════════
// lib/models/software_courses.dart
//
// Complete Software Engineering Learning Path
// Beginner → Job-Ready Software Engineer
//
// Reuses the TopicCourse / ConceptLesson / QuizQuestion / MiniChallenge /
// FinalProject model classes defined in course_content_data.dart.
// This file ONLY adds course content — it does not redefine any model,
// touch any UI, navigation, XP system, or quiz engine.
//
// Structure: 10 Levels, 80 topics, strict learning-path order.
// Level 1  — Programming Foundations
// Level 2  — Problem Solving
// Level 3  — Data Structures
// Level 4  — Algorithms
// Level 5  — Object Oriented Programming
// Level 6  — Databases
// Level 7  — Version Control
// Level 8  — Web Fundamentals
// Level 9  — Software Engineering
// Level 10 — Professional & Interview Mastery
// ══════════════════════════════════════════════════════════════════════

import '../../models/course_content_data.dart';

const List<TopicCourse> softwareEngineeringPath = [
  // ════════════════════════════════════════════════════════════════════
  // LEVEL 1 — PROGRAMMING FOUNDATIONS
  // ════════════════════════════════════════════════════════════════════

  TopicCourse(
    id: 'sep_l1_python_fundamentals',
    topicTitle: 'Python Fundamentals',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 35,
    totalXp: 225,
    emoji: '🐍',
    intro:
        'Welcome to Level 1 of your Software Engineering journey. Python is the most beginner-friendly language in the world, and also one of the most powerful — used at Google, Netflix, NASA, and Instagram. By the end of this course you will be able to read and write real Python programs, and you\'ll have the foundation every later course in this path builds on.',
    concepts: [
      ConceptLesson(
        title: 'Learning Objectives & Why Python First',
        definition:
            'By the end of this course you will be able to: install and run Python, write variables and expressions, understand Python\'s syntax philosophy, and execute your first complete program.',
        analogy:
            'Learning Python first is like learning to drive in an automatic car before a manual one — you get the core skill of "driving" (programming) without fighting unnecessary complexity (manual memory management, complex syntax) on day one.',
        example:
            'Companies using Python at massive scale:\n• Instagram — entire backend\n• Netflix — recommendation systems\n• NASA — mission-critical scientific computing\n• Google — internal tooling and AI research',
        keyTakeaway:
            'Python prioritises readability. Code that reads like English is easier to debug, maintain, and review — which is exactly what real engineering teams need.',
      ),
      ConceptLesson(
        title: 'Setting Up & Running Your First Program',
        definition:
            'Python code can run in an interactive shell (REPL) for quick experiments, or as a saved .py file for real programs.',
        analogy:
            'The REPL is like a kitchen counter for tasting as you cook — quick experiments. A .py file is like writing the full recipe down so it can be repeated exactly, shared, and run any time.',
        example:
            '# save as hello.py\nprint("Hello, World!")\n\n# run from terminal:\n# python hello.py\n# Output: Hello, World!',
        keyTakeaway:
            'Every single programmer in history has written a "Hello, World!" program as their first step. You just joined that tradition.',
        codeSnippet:
            'print("Hello, World!")\nprint("I am learning Python.")\nprint(2 + 2)  # 4',
      ),
      ConceptLesson(
        title: 'Python\'s Syntax Philosophy',
        definition:
            'Python uses indentation (whitespace) instead of curly braces {} to define code blocks — this is enforced by the language, not optional style.',
        analogy:
            'Indentation in Python is like paragraph structure in writing — it\'s not just decoration, it actually defines where one idea ends and the next begins. Get it wrong, and the "sentence" doesn\'t parse.',
        example:
            'if True:\n    print("This line is part of the if-block")\n    print("So is this one")\nprint("This is NOT part of the if-block")',
        keyTakeaway:
            'Consistent indentation (4 spaces is the standard) is not a style choice in Python — it is required syntax. Mixing tabs and spaces causes errors.',
        codeSnippet:
            'temperature = 35\nif temperature > 30:\n    print("It\'s hot!")\nelse:\n    print("It\'s comfortable")',
      ),
      ConceptLesson(
        title: 'Comments & Documentation',
        definition:
            'Comments are lines ignored by the Python interpreter, used to explain WHY code does something — for other developers, and for your future self.',
        analogy:
            'A comment is like a sticky note left for the next person who opens the fridge — "leftover curry, eat by Friday" — explaining context that isn\'t obvious just by looking.',
        example:
            '# This calculates 18% GST on a price\nprice = 1000\ngst = price * 0.18  # 0.18 = 18%\ntotal = price + gst',
        keyTakeaway:
            'Good comments explain WHY, not WHAT. "# add 1" is useless. "# adjust for zero-based indexing" is valuable.',
        codeSnippet:
            '"""\nThis is a multi-line docstring.\nUsed to document what a whole file or function does.\n"""\nprint("Code after the docstring")',
      ),
      ConceptLesson(
        title: 'The print() Function & Basic I/O',
        definition:
            'print() displays output to the console. It is the most-used function for understanding what your program is doing while you build it.',
        analogy:
            'print() is like a status light on a machine — it lets you see what is happening inside, instead of guessing blindly.',
        example:
            'name = "Maya"\nscore = 92\nprint("Name:", name, "Score:", score)\nprint(f"Name: {name}, Score: {score}")  # f-string, cleaner',
        keyTakeaway:
            'f-strings (f"...") are the modern, preferred way to combine text and variables — readable and fast.',
        codeSnippet:
            'city = "Agra"\npopulation = 1600000\nprint(f"{city} has a population of {population:,}")\n# Agra has a population of 1,600,000',
      ),
      ConceptLesson(
        title: 'Writing Your First Real Program',
        definition:
            'A real program combines variables, output, and basic logic to solve an actual small problem — not just print a single line.',
        analogy:
            'Your first real program is like your first full meal cooked alone — simple, maybe a bit rough, but a genuine milestone that proves you can combine skills, not just follow one instruction.',
        example:
            '# A simple greeting program\nuser_name = "Rahul"\nuser_age = 20\nbirth_year = 2026 - user_age\nprint(f"Hi {user_name}! You were likely born around {birth_year}.")',
        keyTakeaway:
            'Every complex system you will ever build — apps, AI models, websites — is just thousands of small steps like this one, combined.',
        codeSnippet:
            'first_num = 12\nsecond_num = 8\nprint(f"Sum: {first_num + second_num}")\nprint(f"Difference: {first_num - second_num}")\nprint(f"Product: {first_num * second_num}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What defines a code block in Python?',
        options: [
          'Curly braces {}',
          'Semicolons',
          'Indentation (whitespace)',
          'Round brackets ()'
        ],
        correctIndex: 2,
        explanation:
            'Python uses consistent indentation to define where a block of code (like inside an if statement) begins and ends — unlike languages such as Java or C++ that use curly braces.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the print() function do?',
        options: [
          'Saves a file',
          'Displays output to the console',
          'Deletes a variable',
          'Connects to the internet'
        ],
        correctIndex: 1,
        explanation:
            'print() outputs text or values to the console, making it the primary way to see what your program is doing and to display results to a user.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which of these is the modern, preferred way to insert a variable into a string?',
        options: [
          'String concatenation with +',
          'f-strings: f"{variable}"',
          '%s formatting only',
          'print(variable) inside the string'
        ],
        correctIndex: 1,
        explanation:
            'f-strings, introduced in Python 3.6, let you embed expressions directly inside string literals using curly braces — cleaner and faster than older methods.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'What is the OUTPUT of this code?\n\nif True:\nprint("Hello")',
        options: [
          'Hello',
          'Nothing',
          'IndentationError',
          'SyntaxError: missing semicolon'
        ],
        correctIndex: 2,
        explanation:
            'Python requires the body of an if statement to be indented. Without indentation, Python raises an IndentationError because it cannot determine what belongs inside the if-block.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Which line correctly prints "Score: 90" using an f-string, given score = 90?',
        options: [
          'print("Score: " + score)',
          'print(f"Score: {score}")',
          'print("Score: {score}")',
          'print(score: "Score")'
        ],
        correctIndex: 1,
        explanation:
            'f-strings use f"..." with variables inside curly braces. Option 1 would fail because you cannot directly concatenate a string and an integer with +.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Personal Profile Generator',
      goal:
          'Write a Python program that stores your personal details in variables and prints a formatted profile summary.',
      steps: [
        'Create variables: name, age, city, favourite_language',
        'Calculate birth_year using the current year and age',
        'Use an f-string to print a complete profile in one formatted block',
        'Add at least 2 comments explaining what each calculation does',
        'Print a horizontal line of dashes before and after the profile for style',
      ],
      expectedOutput:
          '----------------------------\nName: Rahul\nAge: 20 (Born around 2006)\nCity: Agra\nFavourite Language: Python\n----------------------------',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sep_l1_java_fundamentals',
    topicTitle: 'Java Fundamentals',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 35,
    totalXp: 225,
    emoji: '☕',
    intro:
        'Java powers Android apps, enterprise banking systems, and some of the largest backend systems on Earth. It teaches you discipline that Python doesn\'t force — explicit types, compiled code, and a strict structure. Many of the world\'s top engineering teams (Amazon, LinkedIn, Uber) run critical systems on Java. Let\'s learn why.',
    concepts: [
      ConceptLesson(
        title: 'Learning Objectives & Why Java Matters',
        definition:
            'By the end of this course you will understand Java\'s compiled nature, write and run a complete Java program, and understand the role of the JVM (Java Virtual Machine).',
        analogy:
            'Java is like a shipping standard — code compiled once runs on ANY machine with a JVM installed ("write once, run anywhere"), the same way a standard shipping container fits any compliant ship or truck worldwide.',
        example:
            'Companies running critical infrastructure on Java:\n• Amazon — large parts of their backend\n• LinkedIn — core services\n• Banks worldwide — transaction processing systems\n• Android — the entire app ecosystem (via Kotlin/Java)',
        keyTakeaway:
            'Java\'s strictness (explicit types, mandatory structure) catches more errors before your program even runs, compared to more flexible scripting languages.',
      ),
      ConceptLesson(
        title: 'Compiling & Running Your First Program',
        definition:
            'Java source code (.java) is compiled into bytecode (.class), which the JVM then executes — this two-step process is different from Python\'s direct interpretation.',
        analogy:
            'Compiling Java is like translating a recipe into a universal cooking-symbol language first. Any kitchen (JVM) anywhere in the world can then follow those symbols exactly, regardless of local language.',
        example:
            '// save as HelloWorld.java\npublic class HelloWorld {\n    public static void main(String[] args) {\n        System.out.println("Hello, World!");\n    }\n}\n\n// Terminal:\n// javac HelloWorld.java   (compiles to HelloWorld.class)\n// java HelloWorld          (runs it)',
        keyTakeaway:
            'Every Java program needs a class containing a main() method — this is the fixed entry point the JVM looks for to start execution.',
        codeSnippet:
            'public class HelloWorld {\n    public static void main(String[] args) {\n        System.out.println("Hello, World!");\n    }\n}',
      ),
      ConceptLesson(
        title: 'Java Syntax Structure',
        definition:
            'Java uses curly braces {} to define code blocks and requires every statement to end with a semicolon — both are mandatory, not optional style.',
        analogy:
            'Curly braces in Java are like punctuation marks in formal writing — a missing full stop (semicolon) or unclosed quotation mark (brace) makes the whole sentence (program) fail to parse correctly.',
        example:
            'public class Demo {\n    public static void main(String[] args) {\n        int temperature = 35;\n        if (temperature > 30) {\n            System.out.println("It\'s hot!");\n        } else {\n            System.out.println("It\'s comfortable");\n        }\n    }\n}',
        keyTakeaway:
            'Unlike Python, indentation in Java is purely cosmetic — the compiler ignores it. But you should still indent consistently for human readability.',
      ),
      ConceptLesson(
        title: 'Comments & the Class Structure',
        definition:
            'Java supports single-line (//) and multi-line (/* */) comments, plus special documentation comments (/** */) used to auto-generate API docs.',
        analogy:
            'A /** */ documentation comment is like an official product label — tools can read it automatically to generate a manual (Javadoc), unlike a regular comment which is just a private note.',
        example:
            '/**\n * Calculates the area of a rectangle.\n * @param width the rectangle width\n * @param height the rectangle height\n * @return the calculated area\n */\npublic static int area(int width, int height) {\n    return width * height; // simple multiplication\n}',
        keyTakeaway:
            'Professional Java codebases rely heavily on Javadoc comments — they are not optional decoration in enterprise teams, they are the documentation.',
      ),
      ConceptLesson(
        title: 'Input & Output Basics',
        definition:
            'System.out.println() prints output. The Scanner class reads input from the user via the console.',
        analogy:
            'System.out is like a megaphone broadcasting outward. Scanner is like a microphone listening for what the user says back.',
        example:
            'import java.util.Scanner;\n\npublic class Greet {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        System.out.print("Enter your name: ");\n        String name = sc.nextLine();\n        System.out.println("Hello, " + name + "!");\n    }\n}',
        keyTakeaway:
            'Always close or be mindful of Scanner resources in larger programs, and remember nextInt()/nextLine() behave differently when mixed — a very common beginner bug.',
      ),
      ConceptLesson(
        title: 'Writing Your First Real Program',
        definition:
            'A real Java program combines variables, structure, and output to compute something meaningful — going beyond a single print statement.',
        analogy:
            'Just like in Python, writing your first multi-step Java program is the moment theory becomes a real, working tool in your hands.',
        example:
            'public class ProfileApp {\n    public static void main(String[] args) {\n        String name = "Priya";\n        int age = 22;\n        int birthYear = 2026 - age;\n        System.out.println("Name: " + name);\n        System.out.println("Estimated birth year: " + birthYear);\n    }\n}',
        keyTakeaway:
            'Notice how much more verbose this is than Python — that verbosity is intentional. It forces clarity, which matters enormously in large team codebases.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the role of the JVM in Java?',
        options: [
          'It writes Java code automatically',
          'It executes compiled Java bytecode, enabling "write once, run anywhere"',
          'It replaces the need for a compiler',
          'It only runs on Windows'
        ],
        correctIndex: 1,
        explanation:
            'The Java Virtual Machine (JVM) executes the compiled bytecode (.class files), which is why the same compiled Java program can run on any operating system that has a JVM installed.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is mandatory at the end of every Java statement?',
        options: ['A comma', 'A colon', 'A semicolon', 'Nothing is required'],
        correctIndex: 2,
        explanation:
            'Java requires a semicolon at the end of every statement. Forgetting it causes a compile-time error — this is enforced syntax, not a style choice.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does every executable Java program require?',
        options: [
          'A function called start()',
          'A class containing a main() method as the entry point',
          'At least 2 classes',
          'A Scanner object'
        ],
        correctIndex: 1,
        explanation:
            'The JVM looks specifically for a public static void main(String[] args) method as the starting point of execution — without it, a Java program cannot run as an application.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'What is wrong with this code?\n\npublic class Test {\n    public static void main(String[] args) {\n        System.out.println("Hello")\n    }\n}',
        options: [
          'Nothing — it runs fine',
          'Missing semicolon after println("Hello")',
          'main() should not be static',
          'System.out.println is spelled wrong'
        ],
        correctIndex: 1,
        explanation:
            'Every statement in Java requires a terminating semicolon. Without it after println("Hello"), the compiler will throw a syntax error.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Which Java class is used to read user input from the console?',
        options: ['Reader', 'Scanner', 'InputBox', 'System.in.read()'],
        correctIndex: 1,
        explanation:
            'java.util.Scanner is the standard class used to read input — text, integers, or lines — from System.in (the console).',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Java Profile Generator',
      goal:
          'Write a Java program that reads a user\'s name and age via Scanner, then prints a formatted profile.',
      steps: [
        'Import java.util.Scanner and create a Scanner object reading from System.in',
        'Prompt for and read the user\'s name (nextLine()) and age (nextInt())',
        'Calculate an estimated birth year using 2026 - age',
        'Print a formatted profile block using System.out.println()',
        'Add Javadoc-style comments explaining the program\'s purpose at the top of the class',
      ],
      expectedOutput:
          'Enter your name: Priya\nEnter your age: 22\n\n--- Profile ---\nName: Priya\nAge: 22\nEstimated Birth Year: 2004',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sep_l1_variables_data_types',
    topicTitle: 'Variables & Data Types',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 215,
    emoji: '📦',
    intro:
        'Every single program ever written — from a calculator app to ChatGPT — is fundamentally about storing and transforming data. Variables and data types are the atoms of programming. Master this course and every future topic becomes dramatically easier to understand.',
    concepts: [
      ConceptLesson(
        title: 'What is a Variable, Really?',
        definition:
            'A variable is a named reference to a value stored in memory, allowing your program to retrieve, use, and change that value by name instead of by raw memory address.',
        analogy:
            'A variable is like a labelled locker in a gym. You don\'t need to remember "locker number 4271" — you just remember "my locker", and the gym staff maps that name to the right location for you.',
        example:
            'age = 25          # locker labelled "age" holding the value 25\nname = "Kabir"    # locker labelled "name" holding "Kabir"\nage = 26          # same locker, new value — overwritten',
        keyTakeaway:
            'Variables can be reassigned — the name stays the same, but the value inside can change. This is fundamentally different from a constant.',
      ),
      ConceptLesson(
        title: 'Primitive Data Types',
        definition:
            'Primitive data types are the basic building blocks every language provides: integers (whole numbers), floats/doubles (decimals), booleans (true/false), and characters/strings (text).',
        analogy:
            'Primitive types are like the basic LEGO brick shapes — squares, rectangles, small connectors. Every complex LEGO structure (every complex data structure) is eventually built from combinations of these basic pieces.',
        example:
            'Integer:  age = 25\nFloat:    price = 99.99\nBoolean:  is_active = True\nString:   name = "Kabir"\nCharacter (Java): char grade = \'A\';',
        keyTakeaway:
            'Different languages have different exact primitive sets, but the core ideas (whole numbers, decimals, true/false, text) are universal across every programming language.',
        codeSnippet:
            'age = 25            # int\nheight = 5.9         # float\nis_student = True    # bool\nname = "Aisha"        # str\nprint(type(age), type(height), type(is_student), type(name))',
      ),
      ConceptLesson(
        title: 'Type Systems: Static vs Dynamic',
        definition:
            'In a statically-typed language (Java, C++), you declare a variable\'s type, and it cannot change. In a dynamically-typed language (Python, JavaScript), the type is inferred and CAN change at runtime.',
        analogy:
            'A statically-typed locker is permanently labelled "shoes only" — you can never put a jacket in it. A dynamically-typed locker has a label written in pencil — you can erase "shoes" and write "jacket" whenever you like.',
        example:
            '// Java (static)\nint age = 25;\n// age = "twenty-five";  // COMPILE ERROR\n\n# Python (dynamic)\nage = 25\nage = "twenty-five"  # totally legal, just risky',
        keyTakeaway:
            'Static typing catches type errors before the program runs (safer for large teams). Dynamic typing is faster to write but pushes type errors to runtime, where they\'re more expensive to find.',
      ),
      ConceptLesson(
        title: 'Type Conversion (Casting)',
        definition:
            'Type conversion changes a value from one data type to another — either implicitly (automatic) or explicitly (you request it).',
        analogy:
            'Casting is like converting currency. ₹100 doesn\'t disappear when converted to dollars — it becomes a new representation of roughly the same value, and you must explicitly choose to do that conversion.',
        example:
            '# Python\nage_str = "25"\nage_int = int(age_str)  # explicit conversion\nprint(age_int + 5)  # 30\n\n// Java\nString ageStr = "25";\nint age = Integer.parseInt(ageStr);',
        keyTakeaway:
            'Forgetting to convert types is one of the most common beginner bugs: trying to add a string "25" and an integer 5 directly will crash or behave unexpectedly depending on the language.',
        codeSnippet:
            'price = "499"\nquantity = 3\n# total = price * quantity   # this actually repeats the string 3 times in Python!\ntotal = int(price) * quantity\nprint(total)  # 1497',
      ),
      ConceptLesson(
        title: 'Naming Conventions & Best Practices',
        definition:
            'Different languages have different naming conventions: snake_case (Python), camelCase (Java/JavaScript), but all share the principle that names should be descriptive.',
        analogy:
            'Naming a variable "x" is like labelling every box in a house move "stuff" — technically it works, but everyone unpacking later will be confused and frustrated.',
        example:
            'Bad:  x = 25, d = "Kabir", flag = True\nGood: age = 25, name = "Kabir", is_logged_in = True\n\nPython: snake_case → user_age\nJava/JS: camelCase → userAge',
        keyTakeaway:
            'Code is read far more often than it is written. A few extra seconds choosing a clear name saves hours of confusion for your team (and your future self) later.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is a variable?',
        options: [
          'A fixed value that can never change',
          'A named reference to a value stored in memory',
          'A type of loop',
          'A function with no parameters'
        ],
        correctIndex: 1,
        explanation:
            'A variable acts as a named label pointing to a value in memory. You interact with the name; the program handles where the actual value lives.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'In a statically-typed language, what happens if you try to assign a String to a variable declared as int?',
        options: [
          'It works automatically',
          'A compile-time error occurs',
          'It only fails at runtime',
          'The variable becomes a float'
        ],
        correctIndex: 1,
        explanation:
            'Statically-typed languages like Java check types at compile time. Assigning a String to an int-typed variable is caught immediately as a type mismatch, before the program ever runs.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does type conversion (casting) allow you to do?',
        options: [
          'Delete a variable',
          'Change a value from one data type to another',
          'Rename a variable',
          'Make a variable constant'
        ],
        correctIndex: 1,
        explanation:
            'Type conversion changes the representation of a value — for example, converting the string "25" into the integer 25 so it can be used in arithmetic.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'In Python, what is the output of:\n\nprice = "10"\nquantity = 3\nprint(price * quantity)',
        options: ['30', '"101010"', 'TypeError', '"30"'],
        correctIndex: 1,
        explanation:
            'Multiplying a string by an integer in Python repeats the string that many times — it does NOT convert it to a number. "10" * 3 produces "101010", a common source of beginner bugs.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Which variable name follows good naming convention best practices?',
        options: ['x1', 'temp', 'total_order_amount', 'a'],
        correctIndex: 2,
        explanation:
            'total_order_amount is descriptive and immediately tells any reader what the variable represents, unlike vague single-letter or generic names.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Unit Converter Tool',
      goal:
          'Build a small program demonstrating variables, multiple data types, and type conversion together.',
      steps: [
        'Create a string variable holding a temperature value as text, e.g. "37.5"',
        'Convert it to a float using explicit type conversion',
        'Create an integer variable for distance in kilometres',
        'Convert the distance to miles (km * 0.621) — note the result will be a float',
        'Create a boolean variable is_metric and use it to decide which units to print',
        'Print a clearly formatted summary of all converted values with their types labelled',
      ],
      expectedOutput:
          'Temperature: 37.5°C (float)\nDistance: 10 km = 6.21 miles (float)\nUsing metric system: True (bool)',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sep_l1_operators',
    topicTitle: 'Operators',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 195,
    emoji: '➕',
    intro:
        'Operators are the verbs of programming — they DO things to your data: add it, compare it, combine conditions. Every calculation, every decision, every comparison your program will ever make relies on operators. This course makes sure you never get tripped up by operator precedence or subtle bugs again.',
    concepts: [
      ConceptLesson(
        title: 'Arithmetic Operators',
        definition:
            'Arithmetic operators perform mathematical operations: + (add), - (subtract), * (multiply), / (divide), % (modulo/remainder), ** or ^ (exponent).',
        analogy:
            'Arithmetic operators are exactly the same maths symbols you learned in school — programming just lets a computer apply them millions of times per second instead of you doing it by hand.',
        example:
            'a = 17\nb = 5\nprint(a + b)   # 22\nprint(a - b)   # 12\nprint(a * b)   # 85\nprint(a / b)   # 3.4  (float division)\nprint(a // b)  # 3    (integer/floor division)\nprint(a % b)   # 2    (remainder)',
        keyTakeaway:
            'The modulo operator (%) is one of the most useful and under-appreciated tools in programming — used for checking even/odd numbers, cycling through array indices, and much more.',
      ),
      ConceptLesson(
        title: 'Comparison Operators',
        definition:
            'Comparison operators compare two values and always produce a Boolean (True/False) result: == (equal), != (not equal), >, <, >=, <=.',
        analogy:
            'Comparison operators are like a yes/no referee — they don\'t calculate a new number, they make a single judgment call: is this true, or is this false?',
        example:
            'age = 20\nprint(age == 18)  # False\nprint(age != 18)  # True\nprint(age >= 18)  # True — commonly used for "is adult" checks',
        keyTakeaway:
            'Beginners commonly confuse = (assignment) with == (comparison). "x = 5" SETS x to 5. "x == 5" CHECKS if x equals 5. Mixing these up is a classic bug.',
        codeSnippet:
            'score = 85\nis_passing = score >= 60\nprint(is_passing)  # True',
      ),
      ConceptLesson(
        title: 'Logical Operators',
        definition:
            'Logical operators combine multiple Boolean conditions: AND (both must be true), OR (at least one must be true), NOT (flips true/false).',
        analogy:
            'AND is like needing both a ticket AND an ID to enter a concert — missing either one means you don\'t get in. OR is like a discount that applies if you\'re a student OR a senior citizen — either qualifies.',
        example:
            'age = 25\nhas_license = True\n\ncan_drive = age >= 18 and has_license\nprint(can_drive)  # True\n\nis_weekend = False\nis_holiday = True\nis_day_off = is_weekend or is_holiday\nprint(is_day_off)  # True',
        keyTakeaway:
            'Logical operators let you express complex real-world rules ("eligible if age 18+ AND has valid ID, OR has a guardian present") as precise, testable code.',
        codeSnippet:
            'temperature = 22\nis_raining = False\ngood_weather = (temperature > 18) and (not is_raining)\nprint(good_weather)  # True',
      ),
      ConceptLesson(
        title: 'Assignment Operators',
        definition:
            'Assignment operators store values into variables. Compound assignment operators (+=, -=, *=, /=) combine an operation with assignment in one step.',
        analogy:
            'x += 1 is like saying "add one more item to the box, and keep it in the same box" — a shorthand for the full sentence "take what\'s in the box, add one, put the result back".',
        example:
            'score = 10\nscore += 5   # same as: score = score + 5\nprint(score)  # 15\n\nscore *= 2   # same as: score = score * 2\nprint(score)  # 30',
        keyTakeaway:
            'Compound assignment operators make loops and counters far more concise and readable — you\'ll use += constantly when accumulating totals.',
      ),
      ConceptLesson(
        title: 'Operator Precedence',
        definition:
            'Operator precedence determines the order in which operations are evaluated when multiple operators appear in one expression — exactly like "PEMDAS/BODMAS" in maths.',
        analogy:
            'Operator precedence is like the order of operations in a recipe: "mix dry ingredients, THEN add liquid" matters — doing it in the wrong order changes the result, even though the same steps were technically performed.',
        example:
            'result = 2 + 3 * 4\nprint(result)  # 14, NOT 20 — multiplication happens before addition\n\nresult2 = (2 + 3) * 4\nprint(result2)  # 20 — parentheses override default precedence',
        keyTakeaway:
            'When in doubt, use parentheses. They cost nothing and instantly remove any ambiguity about evaluation order — for you and for anyone reading your code later.',
        codeSnippet:
            'is_eligible = True\nage = 16\nresult = age >= 18 or is_eligible and age >= 13\n# Use parentheses to make intent crystal clear:\nresult_clear = (age >= 18) or (is_eligible and age >= 13)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does the modulo operator (%) return?',
        options: [
          'The product of two numbers',
          'The remainder after division',
          'The square root',
          'The absolute value'
        ],
        correctIndex: 1,
        explanation:
            'The modulo operator returns the remainder of a division. 17 % 5 = 2 because 17 ÷ 5 = 3 remainder 2. It is commonly used to check even/odd numbers (n % 2 == 0).',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the key difference between = and == ?',
        options: [
          'They are interchangeable',
          '= assigns a value; == compares two values for equality',
          '== is faster than =',
          '= is used only with strings'
        ],
        correctIndex: 1,
        explanation:
            'A single = stores a value into a variable. A double == checks whether two values are equal and returns a Boolean. Confusing them is one of the most common beginner errors.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the AND logical operator require to return True?',
        options: [
          'Only one condition needs to be true',
          'Both conditions must be true',
          'Neither condition can be true',
          'It always returns True'
        ],
        correctIndex: 1,
        explanation:
            'The AND operator only evaluates to True when ALL combined conditions are true. If even one condition is False, the entire AND expression is False.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'What is the value of result?\n\nresult = 10 + 2 * 3 - 4 / 2',
        options: ['14', '16', '12', '10'],
        correctIndex: 0,
        explanation:
            'Following precedence: 2*3=6 and 4/2=2 are calculated first. Then 10 + 6 - 2 = 14. Multiplication and division happen before addition and subtraction.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'age = 17\nhas_parent_consent = True\ncan_register = age >= 18 or (age >= 13 and has_parent_consent)\n\nWhat is can_register?',
        options: ['True', 'False', 'Error', 'None'],
        correctIndex: 0,
        explanation:
            'age >= 18 is False, but (age >= 13 and has_parent_consent) is (True and True) = True. Since OR needs only one side true, the final result is True.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Eligibility & Billing Calculator',
      goal:
          'Build a program that uses arithmetic, comparison, logical, and assignment operators together to solve a real scenario.',
      steps: [
        'Create variables for a customer\'s age, purchase_amount, and is_member (boolean)',
        'Use comparison operators to check if purchase_amount qualifies for free shipping (>= 999)',
        'Use logical operators to determine a discount: 10% if is_member, OR 5% if purchase_amount > 2000',
        'Use compound assignment (-=) to apply the discount to purchase_amount',
        'Use the modulo operator to check if the final amount is a "round" number (divisible by 10)',
        'Print a full billing summary with all calculated values',
      ],
      expectedOutput:
          'Original Amount: ₹2500\nMember Discount Applied: 10%\nFinal Amount: ₹2250\nFree Shipping: Yes\nRound Number: Yes',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sep_l1_input_output',
    topicTitle: 'Input & Output',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 195,
    emoji: '⌨️',
    intro:
        'A program that can\'t take input or show output is just a calculator that talks to itself. Input/Output (I/O) is what makes software interactive and useful for real humans. This course covers reading user input safely and formatting output professionally — skills you\'ll use in literally every program you ever write.',
    concepts: [
      ConceptLesson(
        title: 'Reading User Input',
        definition:
            'Programs read input from the user through standard input functions: input() in Python, Scanner in Java, prompt() in browser JavaScript.',
        analogy:
            'Reading input is like a waiter taking your order — the program pauses, listens for what you say, and only continues once it has received your response.',
        example:
            '# Python\nname = input("What is your name? ")\nprint(f"Hello, {name}!")\n\n// Java\nScanner sc = new Scanner(System.in);\nString name = sc.nextLine();',
        keyTakeaway:
            'input() in Python ALWAYS returns a string, even if the user types a number. You must explicitly convert it (int(), float()) before doing maths with it.',
        codeSnippet:
            'age_str = input("Enter your age: ")\nage = int(age_str)  # convert to int before maths\nnext_year_age = age + 1\nprint(f"Next year you will be {next_year_age}")',
      ),
      ConceptLesson(
        title: 'Validating Input',
        definition:
            'Input validation checks that user-provided data is in the expected format and range BEFORE your program tries to use it — preventing crashes and bad data.',
        analogy:
            'Input validation is like a bouncer checking ID at a club entrance — better to catch a problem at the door than deal with chaos once the wrong person is already inside causing trouble.',
        example:
            'age_str = input("Enter your age: ")\nif age_str.isdigit():\n    age = int(age_str)\n    print(f"Age accepted: {age}")\nelse:\n    print("Invalid input — please enter a number")',
        keyTakeaway:
            'Never trust raw user input. Real-world programs crash or get exploited because developers assumed input would always be "well-behaved" — it never is.',
      ),
      ConceptLesson(
        title: 'Formatted Output',
        definition:
            'Formatted output controls exactly how data is displayed: decimal places, alignment, padding, thousands separators — making output professional and readable.',
        analogy:
            'Unformatted output is like a receipt printed with random spacing and no currency symbol — technically correct numbers, but unprofessional and hard to read at a glance.',
        example:
            'price = 1234.5\nprint(f"Price: ₹{price:,.2f}")\n# Price: ₹1,234.50\n\nname = "Sam"\nprint(f"{name:>10}")  # right-align in 10 characters\nprint(f"{name:<10}|")  # left-align in 10 characters',
        keyTakeaway:
            'Formatting isn\'t cosmetic fluff — in financial software, an unformatted "1234.5" instead of "₹1,234.50" can cause genuine confusion and costly mistakes.',
        codeSnippet:
            'items = [("Tea", 50), ("Coffee", 120), ("Sandwich", 180)]\nfor name, price in items:\n    print(f"{name:<12}₹{price:>6.2f}")',
      ),
      ConceptLesson(
        title: 'Multiple Inputs & Output Streams',
        definition:
            'Programs often need several pieces of input at once, and output can be directed to different destinations: console, files, or even error streams (stderr).',
        analogy:
            'stdout (normal output) is like a restaurant\'s main dining announcements. stderr (error output) is like a separate kitchen alarm bell — both are "output", but they serve very different purposes and audiences.',
        example:
            '# Python: reading multiple values on one line\nvalues = input("Enter 3 numbers separated by spaces: ").split()\nnums = [int(v) for v in values]\nprint(f"Sum: {sum(nums)}")\n\nimport sys\nprint("This is a normal message")\nprint("This is an error", file=sys.stderr)',
        keyTakeaway:
            'Separating normal output (stdout) from error output (stderr) lets other programs and logging tools distinguish "the program is talking" from "something went wrong" automatically.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What data type does Python\'s input() function always return?',
        options: ['Integer', 'Float', 'String', 'Boolean'],
        correctIndex: 2,
        explanation:
            'input() always returns a string, regardless of what the user typed. You must explicitly convert it with int() or float() before performing numeric calculations.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is input validation important?',
        options: [
          'It makes the program run faster',
          'It prevents crashes and bad data by checking input before using it',
          'It is required by Python syntax',
          'It only matters for graphical applications'
        ],
        correctIndex: 1,
        explanation:
            'Real users (and attackers) will eventually provide unexpected input. Validation catches problems early, before they cause crashes or corrupt data deeper in the program.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the difference between stdout and stderr?',
        options: [
          'There is no real difference',
          'stdout is for normal output; stderr is a separate stream specifically for error messages',
          'stderr is faster than stdout',
          'stdout only works in Java'
        ],
        correctIndex: 1,
        explanation:
            'stdout carries normal program output, while stderr is a separate stream intended for error messages — allowing tools to filter or redirect each independently.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A user enters "abc" when asked for their age. What happens if you immediately run int(user_input) without validation?',
        options: [
          'It returns 0',
          'It silently ignores the letters',
          'It raises a ValueError and crashes the program',
          'It rounds to the nearest number'
        ],
        correctIndex: 2,
        explanation:
            'int("abc") cannot be converted to a number, so Python raises a ValueError. Without validation or a try/except block, this crashes the program.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'price = 49.5\nprint(f"₹{price:.2f}")\n\nWhat is printed?',
        options: ['₹49.5', '₹49.50', '₹49', '₹49.500'],
        correctIndex: 1,
        explanation:
            'The format specifier :.2f forces exactly 2 decimal places, converting 49.5 into the properly formatted "49.50".',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Interactive Restaurant Bill Generator',
      goal:
          'Build a program that takes multiple user inputs, validates them, and prints a professionally formatted bill.',
      steps: [
        'Ask the user how many items they ordered (validate it is a digit before converting to int)',
        'Loop that many times, asking for an item name and price each time',
        'Validate that each price entered is a valid number before adding it to the total',
        'Calculate a subtotal, then add 5% GST',
        'Print a formatted, aligned bill with item names, prices, subtotal, GST, and grand total — all formatted to 2 decimal places',
      ],
      expectedOutput:
          'How many items? 2\nItem 1 name: Coffee     Price: 120\nItem 2 name: Sandwich   Price: 180\n\n--- BILL ---\nCoffee       ₹120.00\nSandwich     ₹180.00\nSubtotal     ₹300.00\nGST (5%)     ₹ 15.00\nTOTAL        ₹315.00',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sep_l1_conditional_statements',
    topicTitle: 'Conditional Statements',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 205,
    emoji: '🔀',
    intro:
        'Every intelligent decision a program makes — from "is this password correct?" to "should this self-driving car brake now?" — runs through conditional logic. This course takes you from simple if-statements to writing clean, readable decision logic that scales to complex real-world rules.',
    concepts: [
      ConceptLesson(
        title: 'The if Statement',
        definition:
            'An if statement executes a block of code only when its condition evaluates to True.',
        analogy:
            'An if statement is like a security checkpoint with one rule: "if you have a valid ticket, you may enter." No ticket, no entry — nothing else happens.',
        example: 'age = 20\nif age >= 18:\n    print("You can vote")',
        keyTakeaway:
            'If the condition is False, the entire indented block is simply skipped — the program continues with whatever comes after it.',
        codeSnippet:
            'temperature = 38\nif temperature > 37:\n    print("Fever detected — see a doctor")',
      ),
      ConceptLesson(
        title: 'if-else: Handling Both Outcomes',
        definition:
            'if-else lets you specify exactly two paths: one block runs if the condition is True, the other runs if it is False.',
        analogy:
            'if-else is like a fork in a road with exactly two paths — you will always end up on one or the other, never neither, never both.',
        example:
            'age = 15\nif age >= 18:\n    print("Adult ticket")\nelse:\n    print("Child ticket")',
        keyTakeaway:
            'Exactly one of the two blocks always runs. This guarantees your program always has a defined response, never an undefined gap in logic.',
        codeSnippet:
            'balance = 500\nwithdrawal = 700\nif withdrawal <= balance:\n    print("Withdrawal approved")\nelse:\n    print("Insufficient funds")',
      ),
      ConceptLesson(
        title: 'elif: Handling Multiple Conditions',
        definition:
            'elif ("else if") lets you check several conditions in sequence, stopping at the first one that is True.',
        analogy:
            'elif is like a triage nurse checking symptoms in priority order: "is it critical? No. Is it urgent? No. Then it must be routine." Only the first matching category is acted on.',
        example:
            'score = 72\nif score >= 90:\n    grade = "A"\nelif score >= 80:\n    grade = "B"\nelif score >= 70:\n    grade = "C"\nelse:\n    grade = "F"\nprint(grade)  # C',
        keyTakeaway:
            'Order matters in elif chains! Conditions are checked top to bottom, and only the FIRST true one executes — even if a later condition would also be true.',
        codeSnippet:
            'temperature = 25\nif temperature > 35:\n    status = "Hot"\nelif temperature > 20:\n    status = "Pleasant"\nelif temperature > 10:\n    status = "Cool"\nelse:\n    status = "Cold"\nprint(status)  # Pleasant',
      ),
      ConceptLesson(
        title: 'Nested Conditionals',
        definition:
            'A nested conditional is an if statement placed inside another if (or else) block, used when a decision depends on multiple, related questions.',
        analogy:
            'Nested conditionals are like a doctor\'s decision tree: "if the patient has a fever, THEN check if it\'s above 39°C — if so, recommend emergency care; if not, recommend rest." Each layer narrows the decision further.',
        example:
            'age = 20\nhas_id = True\n\nif age >= 18:\n    if has_id:\n        print("Entry allowed")\n    else:\n        print("ID required")\nelse:\n    print("Must be 18+")',
        keyTakeaway:
            'Deep nesting (4+ levels) makes code hard to read. Often, combining conditions with logical AND/OR is cleaner than deeply nesting if-statements.',
        codeSnippet:
            '# Cleaner alternative to nesting:\nif age >= 18 and has_id:\n    print("Entry allowed")\nelif age >= 18 and not has_id:\n    print("ID required")\nelse:\n    print("Must be 18+")',
      ),
      ConceptLesson(
        title: 'The Ternary / Conditional Expression',
        definition:
            'A ternary expression is a compact one-line if-else used to assign a value based on a condition, instead of writing a full multi-line if-else block.',
        analogy:
            'A ternary expression is like answering "yes or no?" in a single breath instead of writing a full paragraph explaining your reasoning — useful when the decision is genuinely simple.',
        example:
            '# Python\nage = 20\nstatus = "Adult" if age >= 18 else "Minor"\nprint(status)  # Adult\n\n// Java / JavaScript equivalent:\n// String status = age >= 18 ? "Adult" : "Minor";',
        keyTakeaway:
            'Use ternary expressions for simple, single-value decisions. For anything with multiple steps or side effects, a full if-else block remains more readable.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What happens to the code inside an if block when its condition is False?',
        options: [
          'It runs anyway',
          'It is skipped entirely',
          'It causes an error',
          'It runs once, then stops'
        ],
        correctIndex: 1,
        explanation:
            'When an if condition evaluates to False, the entire indented block beneath it is skipped, and execution continues with the next statement after the block.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'In an if/elif/elif/else chain, how many blocks can execute?',
        options: [
          'All of them, if their conditions are true',
          'Exactly one — the first condition that evaluates to True',
          'Always the else block',
          'None unless explicitly called'
        ],
        correctIndex: 1,
        explanation:
            'Once Python finds the first True condition in an if/elif chain, it executes that block and skips all remaining elif/else checks — even if they would also be True.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is a ternary expression used for?',
        options: [
          'Looping multiple times',
          'A compact one-line if-else for simple value assignment',
          'Defining a class',
          'Reading user input'
        ],
        correctIndex: 1,
        explanation:
            'A ternary expression like `status = "Adult" if age >= 18 else "Minor"` condenses a simple two-branch decision into a single readable line.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'score = 85\nif score >= 90:\n    grade = "A"\nelif score >= 80:\n    grade = "B"\nelif score >= 85:\n    grade = "A-"\nelse:\n    grade = "C"\nprint(grade)\n\nWhat is printed, and why might this surprise a beginner?',
        options: [
          '"A-", because 85 matches that condition too',
          '"B", because elif chains stop at the FIRST true condition, even if a later one also matches',
          '"A", because 85 rounds up',
          '"C", because none of the conditions are exactly equal to 85'
        ],
        correctIndex: 1,
        explanation:
            'Even though score >= 85 (the "A-" condition) is also true, the chain already matched and executed score >= 80 first, so "B" is assigned and the rest of the chain is skipped. This is a classic elif-ordering bug.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Which approach is generally cleaner for: "if age is 18+ AND has a valid ID, allow entry"?',
        options: [
          'Two nested if statements, 2 levels deep',
          'One if statement combining both conditions with "and"',
          'Two separate unrelated if statements',
          'A while loop'
        ],
        correctIndex: 1,
        explanation:
            'Combining related conditions with logical operators (age >= 18 and has_id) is usually more readable than nesting, especially for simple two-condition checks.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Loan Eligibility Checker',
      goal:
          'Build a decision system using if/elif/else and combined logical conditions to evaluate loan eligibility.',
      steps: [
        'Take inputs: applicant age, monthly_income, credit_score, has_existing_loan (yes/no)',
        'Reject immediately if age < 21 or age > 60',
        'Use elif tiers to assign an interest rate based on credit_score: 750+ = 7%, 650-749 = 10%, below 650 = "Not eligible"',
        'If has_existing_loan is True, add a nested check reducing max loan amount by 30%',
        'Calculate max_loan_amount as monthly_income * 20 (adjusted if existing loan applies)',
        'Print a clear final decision: approved/rejected, interest rate, and max loan amount',
      ],
      expectedOutput:
          'Age: 28 ✓\nCredit Score: 720 → Interest Rate: 10%\nExisting Loan: Yes → Max loan reduced by 30%\n\nDECISION: Approved\nMax Loan Amount: ₹2,80,000\nInterest Rate: 10%',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sep_l1_loops',
    topicTitle: 'Loops',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 210,
    emoji: '🔁',
    intro:
        'Loops are how computers do what humans hate doing: the exact same task, hundreds or millions of times, without complaining or making mistakes. From processing every row in a spreadsheet to rendering every pixel on your screen, loops are everywhere. Master them and repetitive problems stop being intimidating.',
    concepts: [
      ConceptLesson(
        title: 'The for Loop',
        definition:
            'A for loop iterates over a sequence (list, range, string) running its body once for each element.',
        analogy:
            'A for loop is like a teacher calling roll from a class list — they go through each name on the list exactly once, in order, until the list is finished.',
        example:
            'for i in range(5):\n    print(i)\n# Prints: 0 1 2 3 4\n\nfruits = ["apple", "banana", "cherry"]\nfor fruit in fruits:\n    print(fruit)',
        keyTakeaway:
            'range(5) generates 0 through 4 — 5 numbers total, NOT including 5. This "off by one" trap catches almost every beginner at least once.',
        codeSnippet:
            'total = 0\nfor num in [10, 20, 30]:\n    total += num\nprint(total)  # 60',
      ),
      ConceptLesson(
        title: 'The while Loop',
        definition:
            'A while loop repeats its body as long as a condition remains True, checking the condition before every iteration.',
        analogy:
            'A while loop is like waiting at a bus stop: "while the bus hasn\'t arrived, keep waiting." You don\'t know in advance exactly how many minutes you\'ll wait — you just keep checking the condition.',
        example:
            'count = 0\nwhile count < 5:\n    print(count)\n    count += 1\n# Prints: 0 1 2 3 4',
        keyTakeaway:
            'Unlike for loops, while loops are ideal when you don\'t know the exact number of iterations in advance — like waiting for valid user input.',
        codeSnippet:
            'password = ""\nwhile password != "secret123":\n    password = input("Enter password: ")\nprint("Access granted")',
      ),
      ConceptLesson(
        title: 'break and continue',
        definition:
            'break immediately exits the loop entirely. continue skips the rest of the current iteration and jumps to the next one.',
        analogy:
            'break is like a fire alarm — everyone leaves the building immediately, no matter what they were doing. continue is like skipping just one item on your to-do list and moving straight to the next task.',
        example:
            'for num in range(10):\n    if num == 5:\n        break          # stop completely at 5\n    print(num)\n# Prints: 0 1 2 3 4\n\nfor num in range(5):\n    if num == 2:\n        continue        # skip just this number\n    print(num)\n# Prints: 0 1 3 4',
        keyTakeaway:
            'break and continue let you write more efficient, readable loops by avoiding deeply nested if-statements just to "skip" or "stop early".',
      ),
      ConceptLesson(
        title: 'The Infinite Loop Trap',
        definition:
            'An infinite loop never satisfies its exit condition, causing the program to run forever (or until it crashes/is forcibly stopped).',
        analogy:
            'An infinite loop is like a hamster wheel with no door — the hamster keeps running forever because nothing in the design ever lets it stop.',
        example:
            '# DANGEROUS — never updates count, condition is always True\ncount = 0\nwhile count < 5:\n    print("Still running...")\n    # forgot: count += 1',
        keyTakeaway:
            'Every while loop must have a clear path to making its condition False eventually. Before running any while loop, double-check: "what guarantees this will eventually stop?"',
      ),
      ConceptLesson(
        title: 'Nested Loops',
        definition:
            'A nested loop is a loop placed inside another loop, where the inner loop completes fully for every single iteration of the outer loop.',
        analogy:
            'Nested loops are like checking every seat in every row of a cinema: for EACH row (outer loop), check EVERY seat in that row (inner loop) before moving to the next row.',
        example:
            'for row in range(3):\n    for col in range(3):\n        print(f"({row}, {col})", end=" ")\n    print()  # newline after each row\n\n# Output:\n# (0,0) (0,1) (0,2)\n# (1,0) (1,1) (1,2)\n# (2,0) (2,1) (2,2)',
        keyTakeaway:
            'Nested loops are common for grids, matrices, and comparing every pair of items in two lists — but they multiply runtime: 3 outer x 3 inner = 9 total iterations.',
        codeSnippet:
            'for i in range(1, 4):\n    for j in range(1, 4):\n        print(f"{i} x {j} = {i*j}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does range(5) generate in Python?',
        options: [
          '1, 2, 3, 4, 5',
          '0, 1, 2, 3, 4',
          '0, 1, 2, 3, 4, 5',
          '5 only'
        ],
        correctIndex: 1,
        explanation:
            'range(5) generates 5 numbers starting from 0: 0, 1, 2, 3, 4. It does NOT include 5 — a common beginner trap known as an "off by one" mistake.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the key difference between break and continue?',
        options: [
          'They do the same thing',
          'break exits the loop entirely; continue skips only the current iteration',
          'continue exits the loop entirely; break skips the current iteration',
          'break only works in while loops'
        ],
        correctIndex: 1,
        explanation:
            'break stops the loop completely, moving execution past it. continue jumps straight to the next iteration, skipping any remaining code in the current one.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What causes an infinite loop in a while statement?',
        options: [
          'Using range() instead of a list',
          'The loop\'s exit condition never becomes False',
          'Forgetting to use print()',
          'Using too many variables'
        ],
        correctIndex: 1,
        explanation:
            'An infinite loop happens when nothing inside the loop body ever changes the condition toward becoming False — so the while check always passes, forever.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'What is printed by this code?\n\nfor i in range(5):\n    if i == 3:\n        continue\n    print(i)',
        options: ['0 1 2 3 4', '0 1 2 4', '0 1 2', '3'],
        correctIndex: 1,
        explanation:
            'continue skips only the iteration where i == 3 — print(i) is not called for that one value, but the loop continues normally for 4. Result: 0 1 2 4.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'How many total times does "print(x)" run in this nested loop?\n\nfor i in range(3):\n    for j in range(4):\n        print(i, j)',
        options: ['3', '4', '7', '12'],
        correctIndex: 3,
        explanation:
            'The outer loop runs 3 times; for EACH of those, the inner loop runs 4 times. Total iterations = 3 × 4 = 12.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Multiplication Table & Prime Checker',
      goal:
          'Build a program demonstrating for loops, while loops, break, and continue together.',
      steps: [
        'Use a for loop to print a multiplication table (1 to 10) for a number entered by the user',
        'Use a while loop with break to keep asking for a number until the user types "stop"',
        'Inside that while loop, use a nested for loop to check if each entered number is prime (use continue to skip non-divisor checks efficiently)',
        'Track and print how many prime numbers the user entered in total before stopping',
        'Handle invalid (non-numeric) input gracefully using validation from the Input & Output course',
      ],
      expectedOutput:
          'Multiplication table for 7:\n7 x 1 = 7\n7 x 2 = 14\n...\n7 x 10 = 70\n\nEnter a number (or "stop"): 13\n13 is prime!\nEnter a number (or "stop"): stop\nTotal primes entered: 1',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sep_l1_functions',
    topicTitle: 'Functions',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 210,
    emoji: '🧩',
    intro:
        'Functions are the single most important tool for managing complexity in software. Every well-designed program — no matter how large — is really just hundreds of small, well-named functions working together. Master functions and you unlock the ability to build things far bigger than you could ever hold in your head at once.',
    concepts: [
      ConceptLesson(
        title: 'Defining & Calling Functions',
        definition:
            'A function is a named, reusable block of code that performs a specific task. You define it once and call it as many times as needed.',
        analogy:
            'A function is like a vending machine button: press "B4" (call the function) and you always get the same snack (result) for that button, no matter how many times you press it.',
        example:
            'def greet(name):\n    return f"Hello, {name}!"\n\nprint(greet("Maya"))   # Hello, Maya!\nprint(greet("Arjun"))  # Hello, Arjun!',
        keyTakeaway:
            'Functions follow the DRY principle (Don\'t Repeat Yourself). If you find yourself copy-pasting the same logic twice, it almost certainly belongs in a function.',
      ),
      ConceptLesson(
        title: 'Parameters & Arguments',
        definition:
            'Parameters are placeholders defined in a function\'s signature. Arguments are the actual values you pass in when calling the function.',
        analogy:
            'A parameter is like a blank on a form ("Name: ____"). An argument is what you actually write in that blank when you fill out the form ("Name: Priya").',
        example:
            'def calculate_area(length, width):  # length, width = parameters\n    return length * width\n\narea = calculate_area(5, 3)  # 5, 3 = arguments\nprint(area)  # 15',
        keyTakeaway:
            'Default parameter values (def greet(name="friend")) let a function work even when the caller doesn\'t provide every argument.',
        codeSnippet:
            'def greet(name="friend"):\n    return f"Hello, {name}!"\n\nprint(greet())          # Hello, friend!\nprint(greet("Zara"))    # Hello, Zara!',
      ),
      ConceptLesson(
        title: 'Return Values',
        definition:
            'The return statement sends a value back to wherever the function was called, ending the function\'s execution immediately.',
        analogy:
            'return is like a vending machine actually dispensing your snack — without it, you pressed the button and heard a noise, but nothing actually came out for you to use.',
        example:
            'def add(a, b):\n    result = a + b\n    return result\n\ntotal = add(3, 4)\nprint(total)  # 7 — the returned value is now stored in "total"',
        keyTakeaway:
            'A function with no explicit return statement returns None by default in Python — this trips up beginners who expect a value but get nothing back.',
        codeSnippet:
            'def is_even(n):\n    return n % 2 == 0\n\nif is_even(10):\n    print("Even!")',
      ),
      ConceptLesson(
        title: 'Variable Scope',
        definition:
            'Scope determines where a variable can be accessed. Local variables exist only inside the function that created them; global variables exist throughout the whole program.',
        analogy:
            'Local variables are like conversations inside a closed meeting room — once the meeting ends, nobody outside remembers what was said. Global variables are like an announcement over the building\'s loudspeaker — everyone everywhere can hear it.',
        example:
            'def calculate():\n    local_value = 100  # only exists inside this function\n    return local_value\n\ncalculate()\n# print(local_value)  # NameError — local_value doesn\'t exist out here',
        keyTakeaway:
            'Relying heavily on global variables makes code unpredictable and hard to debug — any function anywhere could silently change them. Prefer passing values as parameters and returning results.',
      ),
      ConceptLesson(
        title: 'Pure Functions & Side Effects',
        definition:
            'A pure function always returns the same output for the same input and has no side effects (doesn\'t modify anything outside itself). A function with side effects changes external state — printing, modifying a global variable, writing to a file.',
        analogy:
            'A pure function is like a calculator: 2+2 always gives 4, and using it doesn\'t change anything else in the room. A function with side effects is like a chef who not only hands you a dish but also rearranges your kitchen while doing it.',
        example:
            '# Pure function\ndef add(a, b):\n    return a + b  # same input always gives same output, nothing else changes\n\n# Function with a side effect\ntotal = 0\ndef add_to_total(n):\n    global total\n    total += n  # modifies external state',
        keyTakeaway:
            'Pure functions are easier to test, debug, and reason about, because you never need to wonder "what else did calling this change?" Favour them whenever practical.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the difference between a parameter and an argument?',
        options: [
          'They are the same thing',
          'A parameter is the placeholder in the function definition; an argument is the actual value passed when calling it',
          'Parameters can only be numbers',
          'Arguments are only used in loops'
        ],
        correctIndex: 1,
        explanation:
            'Parameters are named in the function\'s signature (def greet(name)). Arguments are the real values supplied at the call site (greet("Maya") — "Maya" is the argument).',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does a Python function return if it has no explicit return statement?',
        options: ['0', 'An empty string', 'None', 'It causes an error'],
        correctIndex: 2,
        explanation:
            'If a function never hits a return statement, Python automatically returns None — a common source of confusion when a beginner expects a real value back.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What makes a function "pure"?',
        options: [
          'It uses only global variables',
          'It always returns the same output for the same input and has no side effects',
          'It must not take any parameters',
          'It must always return None'
        ],
        correctIndex: 1,
        explanation:
            'Pure functions are predictable and self-contained: given the same inputs, they always produce the same output, and they never modify anything outside their own scope.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'def mystery(x):\n    x = x + 10\n    return x\n\nvalue = 5\nresult = mystery(value)\nprint(value, result)\n\nWhat is printed?',
        options: ['5 5', '15 15', '5 15', '15 5'],
        correctIndex: 2,
        explanation:
            'Python passes the integer by value for this purpose — the function works with a local copy of x. The original "value" variable outside the function remains unchanged at 5, while the function returns the new computed 15.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Which function below is "pure"?',
        options: [
          'def f(a, b): print(a+b)',
          'def f(a, b): return a + b',
          'total = 0\\ndef f(a): global total; total += a',
          'def f(): return input("Enter: ")'
        ],
        correctIndex: 1,
        explanation:
            'return a + b always produces the same result for the same inputs and has no side effects. The others either print/modify global state or depend on unpredictable user input.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Reusable Math & Validation Toolkit',
      goal:
          'Build a small library of pure functions for common calculations, demonstrating parameters, return values, defaults, and scope.',
      steps: [
        'Write a pure function calculate_bmi(weight_kg, height_m) that returns the BMI value',
        'Write a function classify_bmi(bmi) that returns a category string ("Underweight"/"Normal"/"Overweight") using the BMI value',
        'Write a function with a default parameter: apply_discount(price, discount_percent=10)',
        'Write a function is_valid_email(email) that returns True/False using basic checks (contains "@" and ".")',
        'Call all four functions with test values and print clearly labelled results',
        'Ensure NONE of your functions rely on global variables — pass everything as parameters',
      ],
      expectedOutput:
          'BMI: 22.9 → Category: Normal\nDiscounted Price: ₹900.00 (10% off ₹1000)\nEmail "test@mail.com" valid: True\nEmail "invalid-email" valid: False',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sep_l1_error_handling',
    topicTitle: 'Error Handling',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 210,
    emoji: '🛡️',
    intro:
        'Real software runs in a messy, unpredictable world: users type garbage, networks fail, files go missing. The difference between an amateur program and a production-ready one is how gracefully it handles things going wrong. This course teaches you to anticipate failure and build software that survives it.',
    concepts: [
      ConceptLesson(
        title: 'What is an Exception?',
        definition:
            'An exception is an error that occurs during program execution, disrupting the normal flow — unless it is caught and handled.',
        analogy:
            'An exception is like a smoke alarm going off mid-cooking. The kitchen doesn\'t just keep operating normally and ignore it — something interrupts the normal flow until the issue is addressed.',
        example:
            'age = int("twenty")  # ValueError: invalid literal for int()\nresult = 10 / 0       # ZeroDivisionError: division by zero\nmy_list[100]          # IndexError: list index out of range',
        keyTakeaway:
            'Unhandled exceptions crash your program immediately, printing a "traceback" showing exactly where and why it failed.',
      ),
      ConceptLesson(
        title: 'try / except Blocks',
        definition:
            'A try block contains code that might fail. The except block catches a specific type of exception and handles it gracefully instead of crashing.',
        analogy:
            'try/except is like a circus performer with a safety net: they ATTEMPT the risky trick (try), and if they fall (exception), the net (except) catches them instead of letting them hit the ground (crash).',
        example:
            'try:\n    age = int(input("Enter your age: "))\n    print(f"You are {age} years old")\nexcept ValueError:\n    print("That\'s not a valid number!")',
        keyTakeaway:
            'Always catch SPECIFIC exception types (ValueError, ZeroDivisionError) rather than a bare "except:", which can accidentally hide unrelated bugs you actually need to know about.',
        codeSnippet:
            'try:\n    result = 10 / int(input("Divide by: "))\n    print(result)\nexcept ZeroDivisionError:\n    print("Cannot divide by zero")\nexcept ValueError:\n    print("Please enter a valid number")',
      ),
      ConceptLesson(
        title: 'finally & Guaranteed Cleanup',
        definition:
            'The finally block always executes, whether or not an exception occurred — typically used for cleanup like closing files or releasing resources.',
        analogy:
            'finally is like locking the door when you leave a building — you do it whether your visit went well or whether something went wrong inside. It always happens, no matter what.',
        example:
            'try:\n    file = open("data.txt")\n    data = file.read()\nexcept FileNotFoundError:\n    print("File not found")\nfinally:\n    print("Cleanup: attempting to close file")\n    # file.close() would go here if file was opened successfully',
        keyTakeaway:
            'finally guarantees important cleanup (closing files, releasing locks, disconnecting from a database) happens even if an error occurs partway through — preventing resource leaks.',
      ),
      ConceptLesson(
        title: 'Raising Custom Exceptions',
        definition:
            'You can deliberately raise (throw) an exception using the raise keyword when your code detects an invalid state that the rest of the program needs to know about.',
        analogy:
            'Raising an exception is like a referee blowing a whistle the moment a rule is broken — instead of silently letting an invalid play continue, you immediately flag it so it can be addressed.',
        example:
            'def withdraw(balance, amount):\n    if amount > balance:\n        raise ValueError("Insufficient funds")\n    return balance - amount\n\ntry:\n    withdraw(100, 500)\nexcept ValueError as e:\n    print(f"Transaction failed: {e}")',
        keyTakeaway:
            'Raising clear, specific exceptions with helpful messages makes debugging dramatically easier than letting invalid states silently propagate and cause confusing failures elsewhere.',
        codeSnippet:
            'class InsufficientFundsError(Exception):\n    pass\n\ndef withdraw(balance, amount):\n    if amount > balance:\n        raise InsufficientFundsError(f"Need {amount}, have {balance}")\n    return balance - amount',
      ),
      ConceptLesson(
        title: 'Defensive Programming Principles',
        definition:
            'Defensive programming means anticipating things that could go wrong (bad input, missing files, network failures) and writing code that handles them gracefully rather than assuming everything will go right.',
        analogy:
            'Defensive programming is like a pilot\'s pre-flight checklist — not because they expect every flight to fail, but because checking in advance catches the rare problem before it becomes a disaster mid-flight.',
        example:
            'def safe_divide(a, b):\n    if b == 0:\n        return None  # or raise a clear exception\n    return a / b\n\nresult = safe_divide(10, 0)\nif result is None:\n    print("Cannot divide by zero")',
        keyTakeaway:
            'The most expensive bugs in real companies are usually caused by an "impossible" edge case nobody defended against. Always ask: "what if this input is empty, zero, negative, or missing?"',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the purpose of a try/except block?',
        options: [
          'To make code run faster',
          'To catch and gracefully handle errors instead of letting the program crash',
          'To define a new function',
          'To create a loop'
        ],
        correctIndex: 1,
        explanation:
            'try/except lets your program attempt risky code and respond gracefully to specific failures instead of crashing immediately with an unhandled exception.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'When does the finally block execute?',
        options: [
          'Only if an exception occurs',
          'Only if no exception occurs',
          'Always — whether or not an exception occurred',
          'Only if the program is run twice'
        ],
        correctIndex: 2,
        explanation:
            'finally always runs, regardless of whether the try block succeeded or an exception was raised, making it ideal for guaranteed cleanup code.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is catching a bare "except:" with no specific exception type considered bad practice?',
        options: [
          'It is actually best practice',
          'It can accidentally hide unrelated bugs and unexpected errors you should know about',
          'It only works in Java',
          'It runs slower than specific exceptions'
        ],
        correctIndex: 1,
        explanation:
            'A bare except catches EVERYTHING, including bugs you didn\'t anticipate (like a typo causing a NameError). This can silently swallow serious problems, making debugging much harder.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'try:\n    result = 10 / 0\nexcept ZeroDivisionError:\n    print("A")\nexcept ValueError:\n    print("B")\nfinally:\n    print("C")\n\nWhat is printed?',
        options: ['A then C', 'B then C', 'C only', 'A, B, then C'],
        correctIndex: 0,
        explanation:
            '10/0 raises ZeroDivisionError, which matches the first except block, printing "A". Then finally always runs regardless, printing "C". The ValueError block is never reached.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You are writing a function that processes a list of ages. Some entries might be negative, which is invalid. What is the BEST defensive approach?',
        options: [
          'Assume all input is always valid',
          'Check for negative ages and raise a clear, specific exception or return an error indicator',
          'Silently ignore negative ages without telling anyone',
          'Crash the whole program intentionally'
        ],
        correctIndex: 1,
        explanation:
            'Defensive programming means explicitly checking for known-invalid states (like negative ages) and handling them clearly — either by raising a descriptive exception or returning a clear error signal — rather than assuming or silently ignoring the problem.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Robust File-Based Calculator',
      goal:
          'Build a calculator tool that reads two numbers and an operation from user input, handling every realistic failure gracefully.',
      steps: [
        'Prompt for two numbers and an operator (+, -, *, /) using input()',
        'Use try/except to catch ValueError if the numbers aren\'t valid',
        'Use try/except to catch ZeroDivisionError specifically for division by zero',
        'Raise a custom exception InvalidOperatorError if the operator isn\'t one of the 4 supported symbols',
        'Use a finally block to always print "Calculation attempt finished" regardless of outcome',
        'Wrap the entire flow in a loop that keeps asking until the user types "quit"',
      ],
      expectedOutput:
          'Enter first number: 10\nEnter operator: /\nEnter second number: 0\nError: Cannot divide by zero\nCalculation attempt finished\n\nEnter first number: quit\nGoodbye!',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sep_l1_file_handling',
    topicTitle: 'File Handling',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 210,
    emoji: '📁',
    intro:
        'Programs that forget everything the moment they close are only half-useful. File handling lets your software remember — saving user data, reading configuration, processing reports. Every database, every saved game, every exported PDF ultimately relies on the file-handling fundamentals you\'ll learn here.',
    concepts: [
      ConceptLesson(
        title: 'Opening & Closing Files',
        definition:
            'Opening a file creates a connection between your program and a file on disk. Closing it releases that connection and ensures any pending writes are saved.',
        analogy:
            'Opening a file is like borrowing a book from a librarian — you have to formally check it out, and properly checking it back in (closing) ensures the librarian\'s records (the actual saved file) stay accurate.',
        example:
            'file = open("notes.txt", "r")  # "r" = read mode\ncontent = file.read()\nfile.close()  # always close when done manually\nprint(content)',
        keyTakeaway:
            'Forgetting to close a file can cause data loss (unsaved writes) or resource leaks if your program opens many files without releasing them — exactly why context managers exist.',
      ),
      ConceptLesson(
        title: 'The with Statement (Context Managers)',
        definition:
            'The "with" statement automatically closes a file when its block finishes, even if an error occurs inside — eliminating the risk of forgetting file.close().',
        analogy:
            '"with" is like a self-locking door — you don\'t need to remember to lock it manually when you leave; it happens automatically the moment you step out, accident or not.',
        example:
            'with open("notes.txt", "r") as file:\n    content = file.read()\n    print(content)\n# File is automatically closed here, guaranteed',
        keyTakeaway:
            'Always prefer "with open(...)" over manual open()/close() pairs in real code — it is safer and is the standard professional practice in Python.',
        codeSnippet:
            'with open("log.txt", "a") as file:  # "a" = append mode\n    file.write("New log entry\\n")',
      ),
      ConceptLesson(
        title: 'File Modes: Read, Write, Append',
        definition:
            '"r" opens for reading (file must exist). "w" opens for writing, ERASING existing content. "a" opens for appending, adding to the end without erasing.',
        analogy:
            '"w" mode is like handing someone a blank whiteboard — anything previously written is wiped clean first. "a" mode is like handing them a notebook and asking them to write on the next free line, keeping everything before it intact.',
        example:
            'with open("data.txt", "w") as f:\n    f.write("This replaces everything in the file")\n\nwith open("data.txt", "a") as f:\n    f.write("\\nThis is added to the end")',
        keyTakeaway:
            'Accidentally using "w" instead of "a" is one of the most common — and most destructive — file handling bugs. It silently deletes existing data with no warning.',
      ),
      ConceptLesson(
        title: 'Reading Files Line by Line',
        definition:
            'For large files, reading line by line (rather than the whole file at once) keeps memory usage low and lets you process data incrementally.',
        analogy:
            'Reading line by line is like reading a long letter one sentence at a time as you walk, instead of insisting on photographing the entire letter into your memory before reading a single word.',
        example:
            'with open("students.txt", "r") as f:\n    for line in f:\n        print(line.strip())  # strip() removes the trailing newline',
        keyTakeaway:
            'Iterating a file object directly (for line in f) is memory-efficient even for files too large to fit in RAM all at once — Python reads lazily under the hood.',
        codeSnippet:
            'with open("scores.txt", "r") as f:\n    total = 0\n    count = 0\n    for line in f:\n        total += int(line.strip())\n        count += 1\n    print(f"Average: {total/count}")',
      ),
      ConceptLesson(
        title: 'Working with CSV & Structured Files',
        definition:
            'CSV (Comma-Separated Values) files store tabular data as plain text, with each line representing a row and commas separating columns — Python\'s csv module parses these reliably.',
        analogy:
            'A CSV file is like a spreadsheet exported as plain text — the structure (rows and columns) is implied purely by line breaks and commas, rather than visual cell borders.',
        example:
            'import csv\n\nwith open("students.csv", "r") as f:\n    reader = csv.reader(f)\n    for row in reader:\n        print(row)  # each row is a list: [\'Name\', \'Score\']',
        keyTakeaway:
            'Never manually split CSV lines with line.split(",") in real projects — it breaks on edge cases like commas inside quoted text. Always use the csv module instead.',
        codeSnippet:
            'import csv\n\nwith open("output.csv", "w", newline="") as f:\n    writer = csv.writer(f)\n    writer.writerow(["Name", "Score"])\n    writer.writerow(["Aisha", 92])',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the main advantage of using "with open(...)" instead of manual open()/close()?',
        options: [
          'It reads files faster',
          'It guarantees the file is automatically closed, even if an error occurs',
          'It only works with CSV files',
          'It prevents files from being read'
        ],
        correctIndex: 1,
        explanation:
            'The "with" statement is a context manager — it guarantees cleanup code (closing the file) runs automatically when the block ends, regardless of whether an exception occurred inside.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What happens if you open an existing file in "w" mode?',
        options: [
          'New content is added to the end, keeping old content',
          'The existing content is erased before new content is written',
          'It throws an error if the file already exists',
          'Nothing happens until you call .write()'
        ],
        correctIndex: 1,
        explanation:
            '"w" (write) mode immediately erases any existing content in the file the moment it is opened — even before you write anything new. Use "a" (append) to preserve existing content.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should you use Python\'s csv module instead of manually splitting lines by commas?',
        options: [
          'The csv module is slower but more "official"',
          'Manual splitting breaks on edge cases like commas inside quoted fields, which the csv module handles correctly',
          'There is no real difference',
          'csv module only works with Excel files'
        ],
        correctIndex: 1,
        explanation:
            'Real-world CSV data often contains commas inside quoted text fields (e.g., "Smith, John"). The csv module correctly parses these edge cases, while a naive split(",") would incorrectly break the field apart.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A developer accidentally writes:\n\nwith open("important_data.txt", "w") as f:\n    f.write("new note")\n\n...when they meant to ADD a note to an existing file. What is the consequence?',
        options: [
          'Nothing — "w" and "a" behave identically',
          'All previous content in important_data.txt is permanently erased before the new note is written',
          'The program throws an error and refuses to run',
          'Only the first line of the old file is erased'
        ],
        correctIndex: 1,
        explanation:
            '"w" mode immediately truncates (erases) the file\'s existing content the moment it is opened. This is a destructive, easy-to-make mistake — the correct mode for adding content without erasing is "a".',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You need to process a 10GB log file without running out of memory. What is the best approach?',
        options: [
          'Use file.read() to load the entire file into a single string',
          'Iterate over the file object line by line using a for loop',
          'Convert the file to a list first using readlines()',
          'Open the file multiple times in parallel'
        ],
        correctIndex: 1,
        explanation:
            'Iterating directly over the file object (for line in f) reads one line at a time lazily, keeping memory usage flat — essential for files too large to fit comfortably in RAM.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Student Grade Record System',
      goal:
          'Build a file-based system that reads, processes, and writes student data using CSV files.',
      steps: [
        'Create a CSV file students.csv with columns: Name, Score (write at least 5 rows using csv.writer)',
        'Write a function that reads students.csv using csv.reader and calculates the class average',
        'Append a new student record to the file using mode "a" without erasing existing data',
        'Write a summary report to a new file report.txt listing each student and whether they passed (score >= 40)',
        'Wrap all file operations in try/except to handle a missing file gracefully',
        'Use "with" statements for every single file operation — no manual open()/close() calls',
      ],
      expectedOutput:
          'students.csv created with 5 records.\nClass average: 78.4\nNew student "Kabir, 88" appended successfully.\nreport.txt written:\nAisha - PASS\nKabir - PASS\nRavi - FAIL\n...',
      xpReward: 50,
    ),
  ),
];
