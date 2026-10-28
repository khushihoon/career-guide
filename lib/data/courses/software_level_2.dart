// ══════════════════════════════════════════════════════════════════════
// lib/models/software_courses_level2.dart
//
// Software Engineering Learning Path — LEVEL 2: Problem Solving & Logic
//
// Reuses TopicCourse / ConceptLesson / QuizQuestion / MiniChallenge /
// FinalProject from course_content_data.dart. Does not modify any
// existing file, model, or course.
// ══════════════════════════════════════════════════════════════════════

import '../../models/course_content_data.dart';

const List<TopicCourse> softwareCoursesLevel2 = [
  TopicCourse(
    id: 'sep_l2_computational_thinking',
    topicTitle: 'Computational Thinking',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 195,
    emoji: '🧠',
    intro:
        'Before you write a single line of code for a hard problem, you need to think like a computer scientist. Computational thinking is the mental toolkit that lets engineers at top companies break impossible-looking problems into manageable pieces. This course rewires how you approach problems — for the rest of your career.',
    concepts: [
      ConceptLesson(
        title: 'Decomposition',
        definition:
            'Decomposition means breaking a large, complex problem into smaller, more manageable sub-problems that are each easier to solve individually.',
        analogy:
            'Building a house feels impossible as one giant task. But "lay the foundation," "build the walls," "install the roof," "wire the electricity" — each step alone is completely manageable.',
        example:
            'Problem: "Build a food delivery app"\nDecomposed: 1) User signup/login 2) Restaurant listing 3) Menu browsing 4) Cart 5) Payment 6) Order tracking 7) Delivery assignment',
        keyTakeaway:
            'Any time a problem feels overwhelming, the first question to ask is: "What are the smaller pieces this is actually made of?"',
      ),
      ConceptLesson(
        title: 'Pattern Recognition',
        definition:
            'Pattern recognition means noticing similarities between a new problem and problems you\'ve already solved, so you can reuse known strategies.',
        analogy:
            'A doctor seeing a new patient with a cough, fever, and fatigue recognises the PATTERN from thousands of past cases — "this looks like flu" — instead of treating it as a totally unprecedented mystery each time.',
        example:
            'Problem A: "Find the largest number in a list."\nProblem B: "Find the most expensive product in a list."\nPattern: both are "scan through items, keep track of the best one seen so far" — the exact same algorithmic pattern.',
        keyTakeaway:
            'Experienced engineers solve new problems faster not because they\'re smarter, but because they\'ve seen more patterns and instantly recognise "oh, this is a sliding window problem" or "this is a graph traversal."',
      ),
      ConceptLesson(
        title: 'Abstraction (Ignoring Irrelevant Detail)',
        definition:
            'Abstraction means focusing only on the details relevant to solving the problem at hand, deliberately ignoring everything else.',
        analogy:
            'A subway map is a deliberate abstraction — it ignores the actual curvy geography of streets above ground because, for the purpose of navigating trains, only station order and connections matter.',
        example:
            'Problem: "Calculate the total price of a shopping cart"\nRelevant: item prices, quantities, discounts\nIrrelevant (ignore for this problem): item colour, item description, shipping warehouse location',
        keyTakeaway:
            'Good abstraction is choosing what to leave OUT, not just what to include. Including irrelevant detail makes a solution unnecessarily complex.',
      ),
      ConceptLesson(
        title: 'Algorithm Design (Step-by-Step Thinking)',
        definition:
            'An algorithm is a precise, ordered sequence of steps that solves a problem. Computational thinking requires converting a vague goal into this kind of exact, unambiguous procedure.',
        analogy:
            'A recipe is an algorithm for cooking: "chop onions, heat oil, add onions, cook until golden" — vague instructions like "make it tasty" won\'t work; a computer (or a new cook) needs precise, ordered steps.',
        example:
            'Vague goal: "Find out if a word is a palindrome"\nAlgorithm:\n1. Remove spaces and convert to lowercase\n2. Reverse the word\n3. Compare reversed word to original\n4. If identical, it\'s a palindrome',
        keyTakeaway:
            'If you can\'t describe your solution as a precise sequence of steps a complete beginner could follow exactly, you don\'t actually have an algorithm yet — you have an idea.',
      ),
      ConceptLesson(
        title: 'Evaluation: Is This Solution Actually Good?',
        definition:
            'Evaluation means critically assessing whether a solution is correct, efficient, and handles edge cases — not just whether it "seems to work" on one example.',
        analogy:
            'A bridge that holds up one truck isn\'t automatically a good bridge — engineers stress-test it against worst-case loads, weather, and time before declaring it safe.',
        example:
            'Solution to "find max in list" using nested loops: works, but O(n²) — slow for huge lists.\nBetter solution: single pass keeping track of current max — O(n), much more efficient.\nEvaluation revealed a better approach existed.',
        keyTakeaway:
            'Always ask three evaluation questions: Does it work on edge cases (empty input, huge input, weird input)? Is it efficient enough? Is it readable and maintainable?',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does "decomposition" mean in computational thinking?',
        options: [
          'Deleting unnecessary code',
          'Breaking a large problem into smaller, manageable sub-problems',
          'Compressing data to save space',
          'Combining multiple programs into one'
        ],
        correctIndex: 1,
        explanation:
            'Decomposition is the practice of splitting an intimidating, large problem into smaller pieces that are individually much easier to tackle and solve.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is pattern recognition valuable when solving new problems?',
        options: [
          'It lets you skip writing any code',
          'It lets you reuse known strategies from similar problems you\'ve solved before',
          'It only applies to mathematics',
          'It guarantees a problem has no bugs'
        ],
        correctIndex: 1,
        explanation:
            'Recognising that a new problem resembles a previously solved one lets you apply a known, proven strategy instead of starting completely from scratch every time.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the purpose of abstraction in problem solving?',
        options: [
          'To add as much detail as possible',
          'To focus only on details relevant to the problem, ignoring the rest',
          'To make code run on multiple computers',
          'To avoid writing functions'
        ],
        correctIndex: 1,
        explanation:
            'Abstraction deliberately strips away irrelevant detail so you can focus your mental effort and code on what actually matters for solving the problem at hand.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are asked to "build a system to manage a school." Using decomposition, which is the BEST first step?',
        options: [
          'Immediately start writing code for the entire system at once',
          'Break it into sub-problems: student records, attendance, grades, timetables, fee management',
          'Ask the user to simplify their request',
          'Give up because the problem is too vague'
        ],
        correctIndex: 1,
        explanation:
            'Decomposition turns one overwhelming goal into several clear, independently solvable sub-problems — the essential first move for any large system.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A solution to "find duplicate names in a list" works correctly on a list of 5 names but takes 10 minutes on a list of 1 million names. What evaluation question was missed?',
        options: [
          'Whether the code compiles',
          'Whether the solution is efficient enough for realistic input sizes',
          'Whether the variable names are descriptive',
          'Whether comments were added'
        ],
        correctIndex: 1,
        explanation:
            'A solution that works but doesn\'t scale has an efficiency problem that wasn\'t caught during evaluation. Testing only small inputs hides serious performance issues.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'System Decomposition Exercise',
      goal:
          'Apply computational thinking to break down a real-world system into sub-problems, patterns, and a step-by-step algorithm for one piece.',
      steps: [
        'Choose a real system: a library management app, a ride-sharing app, or an online exam platform',
        'Decompose it into at least 6 distinct sub-problems',
        'For one sub-problem, identify a pattern from a problem you already know how to solve',
        'Write a precise, numbered algorithm (step-by-step) for solving that one sub-problem',
        'Evaluate your algorithm: does it handle empty input? Large input? Is each step unambiguous?',
        'Write a 3-sentence summary of how computational thinking changed your approach to this problem',
      ],
      expectedOutput:
          'System: Library Management\nSub-problems: [Book catalog, Borrowing, Returns, Late fees, Search, User accounts]\nChosen sub-problem: Late fee calculation\nAlgorithm: 1. Get due date 2. Get return date 3. Calculate days late...\nEvaluation: Handles 0 days late and negative inputs correctly.',
      xpReward: 45,
    ),
  ),
  TopicCourse(
    id: 'sep_l2_problem_solving_fundamentals',
    topicTitle: 'Problem Solving Fundamentals',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 195,
    emoji: '🧩',
    intro:
        'Knowing syntax doesn\'t make you a programmer — solving problems does. This course gives you a repeatable, reliable process for tackling ANY coding problem, from a simple homework exercise to a tricky technical interview question at a top tech company.',
    concepts: [
      ConceptLesson(
        title: 'The 4-Step Problem-Solving Process',
        definition:
            'A reliable problem-solving process has 4 stages: Understand the problem, Plan a solution, Execute (code) the plan, and Review/test the result.',
        analogy:
            'This mirrors how a GPS works: first it understands where you want to go (Understand), calculates a route (Plan), drives you there (Execute), and recalculates if you take a wrong turn (Review).',
        example:
            'Problem: "Find the second largest number in a list"\nUnderstand: What if there are duplicates? What if the list has only 1 item?\nPlan: Track largest and second-largest while scanning once\nExecute: Write the code\nReview: Test with [5,5,5], [1], [3,1,4,1,5]',
        keyTakeaway:
            'Jumping straight to coding without understanding and planning is the #1 reason beginners get stuck or write incorrect solutions.',
      ),
      ConceptLesson(
        title: 'Clarifying the Problem (Asking the Right Questions)',
        definition:
            'Before solving any problem, identify ambiguities and edge cases by asking clarifying questions — about input format, size, and special cases.',
        analogy:
            'A good doctor never starts treatment based on a one-line complaint ("my stomach hurts") — they ask clarifying questions first: where exactly, how long, after eating what? Vague problems need the same investigation.',
        example:
            'Problem: "Sort a list of numbers"\nClarifying questions:\n• Ascending or descending?\n• Can the list contain duplicates?\n• Can the list be empty?\n• Are these integers, floats, or could they be strings?',
        keyTakeaway:
            'In technical interviews, asking 2-3 sharp clarifying questions before coding is often seen as MORE impressive than jumping straight into a solution.',
      ),
      ConceptLesson(
        title: 'Working Through Examples by Hand',
        definition:
            'Before writing code, manually trace through a few example inputs to understand the expected behaviour and discover the underlying pattern.',
        analogy:
            'Before building a machine to fold 1000 shirts, you fold 2-3 shirts by hand first — this reveals the exact motions needed, which you then teach the machine to repeat.',
        example:
            'Problem: "Reverse a string"\nExample by hand: "hello" → "olleh"\nObserve: last letter becomes first, second-last becomes second... this reveals the pattern: iterate from the end backwards.',
        keyTakeaway:
            'If you can\'t solve a SPECIFIC small example by hand, you definitely can\'t write code to solve the general case yet. Always start concrete, then generalise.',
      ),
      ConceptLesson(
        title: 'Brute Force First, Optimise Second',
        definition:
            'A brute force solution checks every possibility directly, without cleverness — it\'s often slow, but it\'s correct and a great starting point.',
        analogy:
            'Brute force is like finding your lost keys by checking every single room in the house, one by one. Slow, but guaranteed to work — and a perfectly reasonable first step before trying a smarter approach.',
        example:
            'Problem: "Find two numbers in a list that sum to a target"\nBrute force: check every pair with two nested loops — O(n²)\nOptimised: use a hash set to check complements in one pass — O(n)',
        keyTakeaway:
            'Getting a correct, even if slow, brute-force solution working FIRST is far better than getting stuck trying to write the "clever" optimal solution from scratch.',
        codeSnippet:
            '# Brute force\ndef two_sum_brute(nums, target):\n    for i in range(len(nums)):\n        for j in range(i+1, len(nums)):\n            if nums[i] + nums[j] == target:\n                return [i, j]',
      ),
      ConceptLesson(
        title: 'Testing Your Own Solution',
        definition:
            'Before considering a solution finished, test it against normal cases, edge cases (empty, single item), and boundary cases (very large/very small values).',
        analogy:
            'A new car isn\'t just tested driving in a straight line on a sunny day — it\'s tested in rain, on sharp turns, and at high speed, because real-world conditions are rarely the easy case.',
        example:
            'Solution to "find average of a list":\nNormal test: [1,2,3] → 2.0 ✓\nEdge case: [] → should this be 0? An error? Decide deliberately, don\'t leave it to chance\nEdge case: [5] → 5.0 ✓',
        keyTakeaway:
            'The cases you DON\'T think to test are exactly the cases that will break in production. Deliberately brainstorm "What\'s the weirdest input someone could give this?"',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the first step in the 4-step problem-solving process?',
        options: [
          'Write code immediately',
          'Understand the problem',
          'Test the final solution',
          'Optimise for speed'
        ],
        correctIndex: 1,
        explanation:
            'Understanding the problem — including its constraints, edge cases, and what exactly is being asked — must come before planning or writing any code.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is a "brute force" solution?',
        options: [
          'A solution that uses the least memory possible',
          'A solution that checks every possibility directly, often simple but slow',
          'A solution that only works for small inputs',
          'A solution written in C++'
        ],
        correctIndex: 1,
        explanation:
            'Brute force means solving a problem by trying all possibilities without clever shortcuts. It\'s usually not the most efficient approach, but it\'s a reliable, correct starting point.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is working through examples by hand useful before coding?',
        options: [
          'It wastes time and should be skipped',
          'It reveals the underlying pattern needed to generalise into code',
          'It is required by all programming languages',
          'It replaces the need for testing'
        ],
        correctIndex: 1,
        explanation:
            'Manually solving small, specific examples helps you discover the actual logic/pattern of the solution, which you can then translate into general-purpose code.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are asked to "find the most frequent word in a document." What is the SMARTEST first move?',
        options: [
          'Immediately write the most optimised algorithm you can think of',
          'Ask clarifying questions (case-sensitive? ignore punctuation? what about ties?) and try a small example by hand',
          'Refuse the task because it\'s too vague',
          'Guess the answer without any code'
        ],
        correctIndex: 1,
        explanation:
            'Clarifying ambiguous requirements and manually working a small example BEFORE coding prevents wasted effort solving the wrong version of the problem.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your solution works perfectly for the example given but you haven\'t tested an empty input. What risk does this create?',
        options: [
          'No risk — empty input never happens in real software',
          'The solution might crash or behave incorrectly on an edge case that wasn\'t considered',
          'It will automatically work because Python handles everything',
          'It will run faster on empty input'
        ],
        correctIndex: 1,
        explanation:
            'Untested edge cases like empty input are a leading cause of real production bugs. A solution that "works" on the happy path may still fail when given unexpected input.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Structured Problem-Solving Journal',
      goal:
          'Solve a moderately tricky problem using the full 4-step process, documenting each stage explicitly.',
      steps: [
        'Choose the problem: "Given a list of integers, find if any two numbers sum to a given target."',
        'UNDERSTAND: write down 3 clarifying questions and their assumed answers',
        'PLAN: work through 2 examples by hand, then describe your approach in plain English',
        'EXECUTE: write a brute-force solution first, then an optimised hash-set based solution',
        'REVIEW: test both solutions against an empty list, a list with one item, and a list with duplicates',
        'Write 2-3 sentences comparing the brute-force and optimised approach\'s time complexity',
      ],
      expectedOutput:
          'Brute force (O(n²)): tested ✓\nOptimised (O(n)): tested ✓\nEdge cases handled: empty list, single item, duplicates\nComparison: optimised approach trades a small memory cost for a major speed improvement on large lists.',
      xpReward: 45,
    ),
  ),
  TopicCourse(
    id: 'sep_l2_flowcharts',
    topicTitle: 'Flowcharts',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 175,
    emoji: '📊',
    intro:
        'Before any code is written for complex business logic — loan approvals, manufacturing processes, hospital triage systems — someone draws a flowchart. Flowcharts let you design and communicate logic visually, catching flaws before they become bugs buried in code.',
    concepts: [
      ConceptLesson(
        title: 'What is a Flowchart?',
        definition:
            'A flowchart is a diagram that represents a process or algorithm using standardised shapes connected by arrows showing the flow of logic.',
        analogy:
            'A flowchart is like a subway map for your logic — each station (shape) represents a step, and the lines connecting them show exactly which path you take depending on conditions along the way.',
        example:
            'Standard shapes:\n• Oval = Start/End\n• Rectangle = Process/Action\n• Diamond = Decision (yes/no)\n• Arrow = Flow direction\n• Parallelogram = Input/Output',
        keyTakeaway:
            'Flowcharts are language-agnostic — the same flowchart could be implemented in Python, Java, or even as a paper-based office process. They represent LOGIC, not specific syntax.',
      ),
      ConceptLesson(
        title: 'Sequential Flow',
        definition:
            'Sequential flow represents steps that happen one after another in a fixed order, with no branching or repetition.',
        analogy:
            'Sequential flow is like following a single hallway with no doors — you walk from start to end in exactly one path, with no decisions to make along the way.',
        example:
            '[Start] → [Get user\'s name] → [Get user\'s age] → [Calculate birth year] → [Display result] → [End]',
        keyTakeaway:
            'Most simple processes start as sequential flow — complexity is added later by introducing decisions and loops on top of this basic skeleton.',
      ),
      ConceptLesson(
        title: 'Decision Branches (Diamonds)',
        definition:
            'A decision shape (diamond) represents a point where the flow splits into different paths based on a yes/no or true/false condition.',
        analogy:
            'A decision diamond is like a fork in a hiking trail with a signpost: "Is it raining? YES → take the covered path. NO → take the scenic path." Only one path is taken each time you reach that point.',
        example:
            '[Start] → [Enter age] → <Age >= 18?>\n              YES → [Show "Adult"] → [End]\n              NO  → [Show "Minor"] → [End]',
        keyTakeaway:
            'Every decision diamond must have exactly two (or more, for multi-way decisions) clearly labelled exit paths — an unlabelled or missing path is a flowchart bug just like in real code.',
      ),
      ConceptLesson(
        title: 'Loops in Flowcharts',
        definition:
            'A loop in a flowchart is represented by an arrow that flows BACK to an earlier point, repeating a sequence of steps until a condition is met.',
        analogy:
            'A flowchart loop is like a roundabout on a road — you keep circling around the same set of streets until a specific exit condition tells you it\'s time to leave the roundabout.',
        example:
            '[Start] → [count = 0] → <count < 5?>\n   YES → [Print count] → [count += 1] → (back to the decision diamond)\n   NO  → [End]',
        keyTakeaway:
            'Every loop in a flowchart MUST have a clear exit condition — exactly like in code, a flowchart with no way to reach "NO" represents an infinite loop.',
      ),
      ConceptLesson(
        title: 'From Flowchart to Code',
        definition:
            'Translating a flowchart into code is mostly mechanical: ovals become program start/end, rectangles become statements, diamonds become if/elif/else, and backward loop arrows become for/while loops.',
        analogy:
            'Converting a flowchart to code is like translating a building blueprint into an actual construction plan — the structure and decisions are already decided; you\'re just choosing the specific materials (programming language syntax) to realise it.',
        example:
            'Flowchart: <age >= 18?> YES→"Adult" NO→"Minor"\n\nPython code:\nif age >= 18:\n    result = "Adult"\nelse:\n    result = "Minor"',
        keyTakeaway:
            'If you can draw a correct flowchart for a problem, writing the actual code becomes dramatically easier — most of the hard thinking is already done visually.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What shape represents a decision (yes/no branch) in a flowchart?',
        options: ['Oval', 'Rectangle', 'Diamond', 'Arrow'],
        correctIndex: 2,
        explanation:
            'A diamond shape represents a decision point where the flow splits based on a condition, such as a true/false or yes/no check.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'How is a loop represented in a flowchart?',
        options: [
          'A rectangle drawn twice',
          'An arrow that flows backward to an earlier point, repeating steps until a condition is met',
          'Two ovals connected directly',
          'Flowcharts cannot represent loops'
        ],
        correctIndex: 1,
        explanation:
            'Loops are shown as arrows that loop back to a previous decision point, repeating a sequence of steps until the loop\'s exit condition becomes true.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the risk of a flowchart loop with no clear exit condition?',
        options: [
          'It will run extremely fast',
          'It represents an infinite loop, just like in actual code',
          'It automatically becomes a decision diamond',
          'There is no risk — flowcharts are just diagrams'
        ],
        correctIndex: 1,
        explanation:
            'A flowchart is meant to represent real logic. A loop with no valid path to exit represents a genuine infinite loop bug, exactly as it would in actual code.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A flowchart has: [Start] → <Is balance >= withdrawal?> with only a YES path leading to [Approve] → [End], and no NO path at all. What is wrong?',
        options: [
          'Nothing — it\'s a valid flowchart',
          'Every decision diamond needs all paths defined; the missing NO path means the logic is incomplete',
          'The diamond shape should be a rectangle',
          'Flowcharts cannot use the word "balance"'
        ],
        correctIndex: 1,
        explanation:
            'A decision point must account for every possible outcome. A missing NO path leaves the logic undefined for cases where the balance is insufficient — a real bug, not just a diagram issue.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Which code structure does a flowchart\'s backward-looping arrow with an exit condition correspond to?',
        options: [
          'An if statement',
          'A function definition',
          'A while or for loop',
          'A variable declaration'
        ],
        correctIndex: 2,
        explanation:
            'A flowchart arrow that loops back to a decision point, with a defined exit condition, directly corresponds to a while loop (or for loop) in actual code.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Flowchart-to-Code Translator',
      goal:
          'Design a flowchart for a real decision process, then translate it into working code.',
      steps: [
        'Choose a process: "Determine shipping cost based on order weight and membership status"',
        'Design the flowchart on paper or in a diagramming tool, including at least 2 decision diamonds and 1 loop (e.g. looping through multiple items)',
        'Label every path out of every decision diamond clearly',
        'Translate your flowchart directly into Python code, keeping the structure 1-to-1 with your diagram',
        'Test your code against 3 different scenarios that exercise every path in the flowchart',
        'Write a short note identifying which flowchart shape mapped to which code structure',
      ],
      expectedOutput:
          'Flowchart: 2 decisions, 1 loop, all paths labelled.\nCode: matches flowchart structure exactly.\nTest 1 (heavy order, member): ₹0 shipping\nTest 2 (light order, non-member): ₹50 shipping\nTest 3 (empty cart): handled gracefully',
      xpReward: 45,
    ),
  ),
  TopicCourse(
    id: 'sep_l2_pseudocode',
    topicTitle: 'Pseudocode',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 175,
    emoji: '📝',
    intro:
        'Pseudocode is the bridge between "I have an idea" and "I have working code." It lets you design logic in plain, structured English without worrying about syntax errors — which is exactly why technical interviewers love it, and why senior engineers still use it to plan before touching a keyboard.',
    concepts: [
      ConceptLesson(
        title: 'What is Pseudocode?',
        definition:
            'Pseudocode is a plain-language, structured description of an algorithm\'s logic — written to be understood by humans, not executed by a computer.',
        analogy:
            'Pseudocode is like a recipe written in plain English before being translated for a professional kitchen\'s specific equipment — "boil water, add pasta, wait 10 minutes" conveys the exact steps without committing to one specific stove brand or measuring system.',
        example:
            'BEGIN\n  GET list_of_numbers\n  SET max_value TO first item in list\n  FOR each number IN list_of_numbers:\n    IF number > max_value THEN\n      SET max_value TO number\n  RETURN max_value\nEND',
        keyTakeaway:
            'Pseudocode has no fixed syntax rules — its only job is to clearly communicate logic. Some teams use ALL CAPS keywords; others use indentation similar to Python. Both are valid as long as it\'s clear.',
      ),
      ConceptLesson(
        title: 'Representing Sequence, Selection & Iteration',
        definition:
            'Every algorithm, no matter how complex, is built from just 3 control structures: sequence (steps in order), selection (decisions), and iteration (repetition/loops).',
        analogy:
            'These 3 structures are like the only 3 LEGO brick shapes you ever truly need — straight bricks (sequence), branching bricks (selection), and repeating patterns (iteration) — combine them endlessly to build anything.',
        example:
            'SEQUENCE:\n  SET total TO 0\n  ADD price TO total\n\nSELECTION:\n  IF total > 1000 THEN apply discount\n\nITERATION:\n  FOR each item IN cart:\n    ADD item.price TO total',
        keyTakeaway:
            'If you can express ANY algorithm using only these 3 structures in pseudocode, you can express it in ANY programming language — they all support sequence, selection, and iteration.',
      ),
      ConceptLesson(
        title: 'Writing Pseudocode for Interviews',
        definition:
            'In technical interviews, pseudocode is often used to communicate your approach to the interviewer BEFORE diving into actual syntax — demonstrating clear thinking under pressure.',
        analogy:
            'Showing pseudocode first is like a surgeon explaining their plan before the operation — it lets others verify the approach is sound before any irreversible (or hard-to-undo) action begins.',
        example:
            'Problem: "Check if a string is a palindrome"\n\nPseudocode:\n  CONVERT string to lowercase\n  REMOVE all spaces\n  SET reversed TO string reversed\n  IF string EQUALS reversed THEN\n    RETURN true\n  ELSE\n    RETURN false',
        keyTakeaway:
            'Interviewers often care MORE about your pseudocode logic than your exact syntax — a clean, correct plan in pseudocode, even with a small syntax slip in the final code, signals strong problem-solving.',
      ),
      ConceptLesson(
        title: 'Translating Pseudocode into Real Code',
        definition:
            'Converting pseudocode into actual code is a mechanical step once the logic is correct — each pseudocode line typically maps to one or a few real lines of code.',
        analogy:
            'Translating pseudocode to code is like converting a hand-drawn map into precise GPS coordinates — the route was already correct; you\'re just expressing it in a more exact format.',
        example:
            'Pseudocode:\n  FOR each number IN list:\n    IF number is even THEN\n      ADD number to even_list\n\nPython:\nfor number in my_list:\n    if number % 2 == 0:\n        even_list.append(number)',
        keyTakeaway:
            'If your pseudocode is detailed and correct, writing the final code becomes almost a "filling in the syntax blanks" exercise rather than genuine new problem-solving.',
      ),
      ConceptLesson(
        title: 'Common Pseudocode Mistakes',
        definition:
            'The most common pseudocode mistakes are being too vague (skipping real logic), too detailed (writing actual syntax), or forgetting edge cases entirely.',
        analogy:
            'Pseudocode that\'s too vague is like a recipe that just says "cook the chicken well" — not actually useful instructions. Pseudocode that\'s too detailed is like writing the exact brand of pan to use — over-specifying details that don\'t matter yet.',
        example:
            'Too vague: "Sort the list somehow"\nToo detailed: "list.sort(key=lambda x: x[1], reverse=True)"\nJust right: "SORT the list in descending order BY the second value of each item"',
        keyTakeaway:
            'Good pseudocode sits exactly in the middle: precise enough that anyone could implement it correctly, but free of any specific programming language syntax.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main purpose of pseudocode?',
        options: [
          'To run directly as executable code',
          'To describe an algorithm\'s logic in plain language for human understanding, before writing real code',
          'To replace the need for programming languages entirely',
          'To document finished code after it is written'
        ],
        correctIndex: 1,
        explanation:
            'Pseudocode is a planning and communication tool — it expresses logic clearly for humans to review and understand, without needing to follow any specific language\'s exact syntax.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What are the 3 fundamental control structures every algorithm is built from?',
        options: [
          'Variables, functions, and classes',
          'Sequence, selection, and iteration',
          'Input, output, and storage',
          'Loops, arrays, and strings'
        ],
        correctIndex: 1,
        explanation:
            'Every algorithm, regardless of complexity, can be expressed using just sequence (ordered steps), selection (decisions/branches), and iteration (loops/repetition).',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why might pseudocode be useful even before writing actual code in an interview?',
        options: [
          'It is required by all programming languages',
          'It lets you and the interviewer verify your logic is correct before committing to exact syntax',
          'It runs faster than real code',
          'It avoids the need for testing'
        ],
        correctIndex: 1,
        explanation:
            'Pseudocode communicates your thinking clearly and lets an interviewer catch logical issues early — before you spend time writing detailed, syntax-correct code based on a flawed plan.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Which of these is the BEST quality pseudocode for "find the sum of even numbers in a list"?',
        options: [
          '"Add up the good numbers somehow"',
          'sum_evens = [n for n in nums if n % 2 == 0]; return sum(sum_evens)',
          'SET total TO 0, FOR each number IN list: IF number is even THEN ADD number TO total, RETURN total',
          '"Use Python to solve this efficiently"'
        ],
        correctIndex: 2,
        explanation:
            'This option is precise and unambiguous about the logic (initialize a total, loop, check evenness, accumulate, return) without committing to any specific language\'s exact syntax — the hallmark of good pseudocode.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A teammate writes pseudocode that says: "list.sort(reverse=True)". What is the issue with this as pseudocode?',
        options: [
          'Nothing — this is perfect pseudocode',
          'It is actual Python syntax, not language-agnostic plain-language logic',
          'It sorts in the wrong direction',
          'Pseudocode cannot mention sorting'
        ],
        correctIndex: 1,
        explanation:
            'Good pseudocode should describe the LOGIC ("sort the list in descending order"), not commit to one specific language\'s exact method call syntax, which limits its usefulness as a language-agnostic planning tool.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Pseudocode-First Algorithm Design',
      goal:
          'Design and document an algorithm fully in pseudocode before implementing it, demonstrating sequence, selection, and iteration.',
      steps: [
        'Choose the problem: "Given a list of exam scores, calculate the letter grade distribution (count of A, B, C, D, F)"',
        'Write complete pseudocode using clear keywords (SET, FOR, IF, RETURN) covering all 3 control structures',
        'Review your pseudocode for vagueness or over-detailed syntax, and refine it',
        'Translate your finished pseudocode line-by-line into working Python code',
        'Test the code against a list of scores covering every grade boundary case',
        'Include your original pseudocode as a comment block above your final code',
      ],
      expectedOutput:
          'Pseudocode:\nSET grade_counts TO empty dictionary\nFOR each score IN scores:\n  determine grade letter\n  increment grade_counts[letter]\nRETURN grade_counts\n\nCode output: {"A": 3, "B": 5, "C": 2, "D": 1, "F": 0}',
      xpReward: 45,
    ),
  ),
  TopicCourse(
    id: 'sep_l2_debugging_fundamentals',
    topicTitle: 'Debugging Fundamentals',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 205,
    emoji: '🐛',
    intro:
        'Every engineer, no matter how senior, spends a huge fraction of their career debugging — finding and fixing things that don\'t work as expected. Debugging isn\'t a sign you\'re bad at programming; it\'s a core skill, separate from writing code, that you can deliberately train. This course gives you a systematic process instead of random guessing.',
    concepts: [
      ConceptLesson(
        title: 'Types of Bugs',
        definition:
            'Syntax errors break the language\'s grammar rules and stop the program from running at all. Runtime errors crash the program while it\'s executing. Logic errors let the program run, but produce the WRONG result.',
        analogy:
            'A syntax error is a grammatically broken sentence that doesn\'t even parse. A runtime error is a sentence that parses but trips someone up mid-speech (like dividing by zero). A logic error is a sentence that\'s perfectly grammatical but factually wrong.',
        example:
            'Syntax error: if x > 5  (missing colon)\nRuntime error: 10 / 0  (ZeroDivisionError)\nLogic error: average = total + count  (should be total / count — runs fine, wrong answer)',
        keyTakeaway:
            'Logic errors are the hardest to find because the program runs without crashing — you only notice something\'s wrong when the OUTPUT looks incorrect.',
      ),
      ConceptLesson(
        title: 'Reading Error Messages & Tracebacks',
        definition:
            'A traceback shows the exact sequence of function calls leading to an error, including the file, line number, and error type — your most valuable debugging clue.',
        analogy:
            'A traceback is like a flight recorder (black box) after an incident — it doesn\'t guess what went wrong, it shows the EXACT sequence of events leading up to the failure.',
        example:
            'Traceback (most recent call last):\n  File "app.py", line 12, in <module>\n    result = divide(10, 0)\n  File "app.py", line 5, in divide\n    return a / b\nZeroDivisionError: division by zero',
        keyTakeaway:
            'Always read the LAST line of a traceback first (the actual error type and message), then trace upward to see exactly which line of YOUR code triggered it.',
      ),
      ConceptLesson(
        title: 'The Scientific Method of Debugging',
        definition:
            'Effective debugging follows the scientific method: form a hypothesis about the cause, design a test to check it, observe the result, and refine your hypothesis based on evidence.',
        analogy:
            'Debugging like a scientist means treating the bug as a mystery with discoverable evidence — not randomly changing code and hoping it works, which is like a doctor prescribing random medicines without diagnosing the actual illness.',
        example:
            'Bug: function returns wrong total\nHypothesis: "Maybe the loop skips the last item"\nTest: print the loop variable each iteration\nObserve: loop correctly reaches the last item — hypothesis rejected\nNew hypothesis: "Maybe the initial total isn\'t reset to 0"',
        keyTakeaway:
            'Changing code randomly without a clear hypothesis ("let me just try this") often introduces NEW bugs while failing to fix the original one.',
      ),
      ConceptLesson(
        title: 'Print Debugging & Using a Debugger',
        definition:
            'Print debugging inserts temporary print statements to inspect variable values at key points. A real debugger lets you pause execution (breakpoints) and inspect the program\'s exact state.',
        analogy:
            'Print debugging is like leaving sticky notes at checkpoints to see what happened. A real debugger is like having a pause button on reality itself — you can freeze the exact moment something happened and inspect everything.',
        example:
            '# Print debugging\ndef calculate_total(items):\n    total = 0\n    for item in items:\n        print(f"Processing {item}, running total: {total}")  # debug line\n        total += item\n    return total',
        keyTakeaway:
            'Print debugging is fast for simple bugs. For complex bugs in larger programs, a real debugger (breakpoints, step-through, variable inspection) saves enormous time.',
      ),
      ConceptLesson(
        title: 'Binary Search Debugging (Isolating the Bug)',
        definition:
            'When a bug\'s location is unknown in a large program, use binary search debugging: check the midpoint of the code/data, determine if the bug is before or after that point, and repeat — narrowing the search exponentially.',
        analogy:
            'This is exactly how you\'d find a broken light bulb in a long string of 100 holiday lights efficiently: check the middle bulb\'s section — if it works, the broken bulb is in the other half. Keep halving until you find it.',
        example:
            'A 1000-line script crashes somewhere. Instead of reading top to bottom:\n1. Add a print/breakpoint at line 500 — does it get reached? Yes → bug is after line 500\n2. Check line 750 — reached? No → bug is between 500-750\n3. Repeat — narrows to the exact line in ~10 steps instead of 1000',
        keyTakeaway:
            'Binary search debugging turns a problem that would take O(n) checks into one that takes only O(log n) checks — incredibly powerful for large codebases.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the key difference between a runtime error and a logic error?',
        options: [
          'They are the same thing',
          'A runtime error crashes the program; a logic error lets it run but produces an incorrect result',
          'Logic errors only happen in Python',
          'Runtime errors are always easier to fix than logic errors'
        ],
        correctIndex: 1,
        explanation:
            'Runtime errors (like dividing by zero) stop execution immediately with a visible crash. Logic errors don\'t crash anything — the program runs fine but computes the wrong answer, which is often harder to notice.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'When reading a Python traceback, which part should you check first?',
        options: [
          'The first line',
          'The last line, which shows the actual error type and message',
          'The middle of the traceback',
          'Tracebacks should be ignored'
        ],
        correctIndex: 1,
        explanation:
            'The final line of a traceback states the actual exception type and message (e.g. ZeroDivisionError: division by zero), giving you the clearest, most direct clue about what went wrong.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the core idea behind "binary search debugging"?',
        options: [
          'Randomly guessing where the bug might be',
          'Repeatedly checking the midpoint of code/data to narrow down the bug\'s location exponentially faster',
          'Rewriting the entire program from scratch',
          'Only debugging the first line of code'
        ],
        correctIndex: 1,
        explanation:
            'By checking the midpoint and determining whether the bug occurs before or after it, you halve the search space each time — finding the bug in a large program far faster than checking line by line.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A function "calculate_average" runs without crashing but always returns 0. What type of bug is this MOST likely?',
        options: [
          'Syntax error',
          'Runtime error',
          'Logic error',
          'Network error'
        ],
        correctIndex: 2,
        explanation:
            'The program runs successfully (no crash) but produces an incorrect result — this is the classic signature of a logic error, such as a misplaced calculation or wrong variable being returned.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You have a 2000-line script and a bug somewhere inside it. Using binary search debugging, roughly how many checks would you need to isolate the exact problem area, compared to checking line by line?',
        options: [
          'Still about 2000 checks',
          'About 11 checks (log2 of 2000), vastly fewer than checking every line',
          'Exactly 2 checks',
          'It is impossible to estimate'
        ],
        correctIndex: 1,
        explanation:
            'Binary search debugging halves the search space with each check. log2(2000) ≈ 11, meaning roughly 11 well-placed checks can isolate the bug\'s location instead of scanning all 2000 lines sequentially.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Bug Hunt: Fix the Broken Calculator',
      goal:
          'Apply systematic debugging techniques to find and fix multiple intentionally injected bugs in a small program.',
      steps: [
        'Take a calculator program containing 3 intentional bugs: one syntax error, one runtime error, one logic error',
        'Fix the syntax error first (the program won\'t even run until this is resolved)',
        'Use a traceback to identify and fix the runtime error',
        'Use print debugging or a debugger with the scientific method to isolate and fix the logic error',
        'Document each bug: what type it was, how you found it, and the fix applied',
        'Add at least 5 test cases proving all 3 bugs are now resolved',
      ],
      expectedOutput:
          'Bug 1 (Syntax): Missing colon on line 4 — fixed\nBug 2 (Runtime): ZeroDivisionError on divide by 0 — added guard clause\nBug 3 (Logic): Average used + instead of / — fixed\nAll 5 test cases passing.',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'sep_l2_string_fundamentals',
    topicTitle: 'String Fundamentals',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 200,
    emoji: '🔤',
    intro:
        'Names, messages, search queries, file paths, JSON data — almost everything a program handles eventually passes through a string. Mastering string manipulation is one of the highest-leverage skills in programming, and an enormous fraction of coding interview questions are really just string problems in disguise.',
    concepts: [
      ConceptLesson(
        title: 'What is a String?',
        definition:
            'A string is a sequence of characters treated as text. In most languages, strings are immutable — once created, their content cannot be changed in place.',
        analogy:
            'A string is like a string of beads, each bead a single character. You can look at any bead by its position (index), but you can\'t just "swap out" one bead — you have to make a whole new string of beads to represent a change.',
        example:
            'name = "Python"\nprint(name[0])    # \'P\'\nprint(name[-1])   # \'n\' (last character)\nprint(len(name))  # 6',
        keyTakeaway:
            'Strings being immutable means operations like "replace a character" actually create a brand NEW string rather than modifying the original in place.',
      ),
      ConceptLesson(
        title: 'String Indexing & Slicing',
        definition:
            'Indexing accesses a single character by position. Slicing extracts a substring using a start, stop, and optional step: string[start:stop:step].',
        analogy:
            'Slicing is like cutting a specific section out of a long printed receipt — you specify exactly where to start cutting and where to stop, and you get back just that portion.',
        example:
            'text = "Hello, World!"\nprint(text[0:5])    # "Hello"\nprint(text[7:])     # "World!"\nprint(text[:5])     # "Hello"\nprint(text[::-1])   # "!dlroW ,olleH" — reversed!',
        keyTakeaway:
            'Slicing never raises an "out of range" error like indexing does — text[100:200] on a short string simply returns an empty string instead of crashing.',
        codeSnippet:
            'sentence = "The quick brown fox"\nwords = sentence.split()  # [\'The\', \'quick\', \'brown\', \'fox\']\nfirst_three_chars = sentence[:3]  # "The"',
      ),
      ConceptLesson(
        title: 'Common String Methods',
        definition:
            'Strings come with built-in methods for transformation and inspection: .upper(), .lower(), .strip(), .split(), .replace(), .find(), .join().',
        analogy:
            'String methods are like specialised kitchen tools — .strip() is a peeler removing unwanted edges (whitespace), .split() is a knife cutting one piece into many, .join() is glue combining many pieces back into one.',
        example:
            'text = "  Hello World  "\nprint(text.strip())          # "Hello World" (no surrounding spaces)\nprint(text.strip().lower())  # "hello world"\nprint("a,b,c".split(","))    # [\'a\', \'b\', \'c\']\nprint("-".join(["a","b","c"])) # "a-b-c"',
        keyTakeaway:
            'Methods can be chained together (text.strip().lower().replace(" ", "_")), applying each transformation in sequence — extremely common in real data-cleaning code.',
      ),
      ConceptLesson(
        title: 'String Concatenation & Formatting',
        definition:
            'Concatenation joins strings together using + or methods like .join(). Formatting (f-strings) embeds variables and expressions directly inside a string.',
        analogy:
            'Concatenation with + is like taping separate strips of paper end to end. f-string formatting is like having a pre-printed template with blanks that automatically fill in the right values.',
        example:
            'first = "Hello"\nsecond = "World"\nresult = first + ", " + second + "!"  # concatenation\nprint(result)  # Hello, World!\n\nname = "Maya"\nprint(f"Hi, {name}!")  # cleaner formatting',
        keyTakeaway:
            'Repeatedly concatenating strings with + inside a large loop is inefficient because each + creates a brand new string. For many concatenations, prefer "".join(list_of_strings).',
      ),
      ConceptLesson(
        title: 'String Comparison & Searching',
        definition:
            'Strings can be compared for equality (==) or order (alphabetical, via <, >). Searching checks if a substring exists using "in", .find(), or .index().',
        analogy:
            'Comparing strings alphabetically works like a librarian sorting books on a shelf — "apple" comes before "banana" the same way it would in a dictionary or phone book.',
        example:
            'print("apple" == "Apple")     # False — case-sensitive!\nprint("apple" < "banana")     # True — alphabetical order\nprint("World" in "Hello World")  # True\nprint("Hello World".find("World"))  # 6 (starting index)',
        keyTakeaway:
            'String comparison is case-sensitive by default. "Apple" != "apple". Always .lower() both sides first when comparing user input where case shouldn\'t matter.',
        codeSnippet:
            'user_input = "YES"\nif user_input.lower() == "yes":\n    print("Confirmed")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does string immutability mean?',
        options: [
          'Strings cannot be read',
          'Once created, a string\'s content cannot be changed in place — operations create new strings instead',
          'Strings can only contain numbers',
          'Strings are always uppercase'
        ],
        correctIndex: 1,
        explanation:
            'Because strings are immutable, any "modification" like replace() or upper() actually produces a brand new string object rather than altering the original string in memory.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What happens if you slice a string with an out-of-range index, like text[100:200] on a 10-character string?',
        options: [
          'It raises an IndexError',
          'It returns an empty string, without crashing',
          'It crashes the entire program',
          'It returns the full original string'
        ],
        correctIndex: 1,
        explanation:
            'Unlike direct indexing (text[100], which would error), slicing is forgiving — out-of-range slice bounds simply return whatever is available, or an empty string if nothing matches.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is "apple" == "Apple" False in most programming languages?',
        options: [
          'It is a bug in the language',
          'String comparison is case-sensitive by default',
          'Strings cannot be compared at all',
          'Only numbers can use =='
        ],
        correctIndex: 1,
        explanation:
            'String equality comparisons are case-sensitive by default in most languages — "a" and "A" are different characters, so "apple" and "Apple" are considered different strings.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'text = "Programming"\nprint(text[3:7])\n\nWhat is printed?',
        options: ['"gram"', '"ogra"', '"Progra"', '"ramm"'],
        correctIndex: 1,
        explanation:
            'Indexing starts at 0: P(0)r(1)o(2)g(3)r(4)a(5)m(6)m(7)... text[3:7] takes indices 3,4,5,6 → "ogra".',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You need to join 10,000 short strings into one. Which approach is MOST efficient?',
        options: [
          'Using + in a loop, repeatedly building the result string',
          'Using "".join(list_of_strings) once on the full list',
          'Converting each string to a number first',
          'There is no performance difference'
        ],
        correctIndex: 1,
        explanation:
            'Repeated += concatenation creates a new string object on every single iteration (because strings are immutable), which is inefficient for large numbers of joins. "".join() is optimised for exactly this case.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Text Analyzer Tool',
      goal:
          'Build a tool that analyzes a block of text using string indexing, slicing, methods, and searching.',
      steps: [
        'Take a multi-sentence paragraph as input (use input() or a hardcoded string)',
        'Count the total number of words using .split()',
        'Find and print the longest word in the text',
        'Count how many times a specific word appears (case-insensitive) using .lower() and .count()',
        'Reverse the entire text using slicing ([::-1]) and print it',
        'Use .join() to efficiently rebuild the text with all words capitalized',
      ],
      expectedOutput:
          'Word count: 24\nLongest word: "programming" (11 letters)\n"python" appears 3 times (case-insensitive)\nReversed text: "...dlrow olleH"\nCapitalized: "The Quick Brown Fox..."',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'sep_l2_arrays_lists',
    topicTitle: 'Arrays & Lists',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 205,
    emoji: '📋',
    intro:
        'If variables are atoms, arrays and lists are molecules — the first real data structure you\'ll use to organise multiple related pieces of data together. Shopping carts, leaderboards, photo galleries, search results — virtually every app feature involves a list of something.',
    concepts: [
      ConceptLesson(
        title: 'What is a List/Array?',
        definition:
            'A list (Python) or array (most languages) is an ordered collection of items, each accessible by its position (index), starting from 0.',
        analogy:
            'A list is like a row of numbered mailboxes on a street — mailbox #0, #1, #2... Each one holds something, and you access any mailbox directly by its number.',
        example:
            'fruits = ["apple", "banana", "cherry"]\nprint(fruits[0])  # apple\nprint(fruits[2])  # cherry\nprint(len(fruits))  # 3',
        keyTakeaway:
            'Index 0 is the FIRST item, not the second. This "zero-indexing" trips up nearly every beginner at least once — get comfortable with it early.',
      ),
      ConceptLesson(
        title: 'Adding & Removing Items',
        definition:
            'Lists support adding items (.append(), .insert()) and removing items (.remove(), .pop()) dynamically — unlike fixed-size arrays in some languages.',
        analogy:
            'Adding to a list is like adding one more chair to the end of a row (.append()) or squeezing a chair into the middle of the row (.insert()). Removing is like pulling a specific chair out and shifting the rest to close the gap.',
        example:
            'tasks = ["Wake up", "Eat breakfast"]\ntasks.append("Go to work")          # add to end\ntasks.insert(1, "Brush teeth")       # insert at index 1\ntasks.remove("Eat breakfast")        # remove by value\nlast_task = tasks.pop()              # remove and return last item',
        keyTakeaway:
            'append() adds to the end in O(1) time — fast. insert() at the beginning is O(n) because every other element must shift over to make room.',
      ),
      ConceptLesson(
        title: 'Iterating Over Lists',
        definition:
            'Iteration means processing each item in a list one at a time, typically using a for loop — the most common operation performed on lists.',
        analogy:
            'Iterating a list is like a teacher going down a class roster, reading each name aloud one at a time, in order, until the list is finished.',
        example:
            'scores = [85, 92, 78, 95]\nfor score in scores:\n    print(f"Score: {score}")\n\n# With index using enumerate\nfor index, score in enumerate(scores):\n    print(f"Student {index+1}: {score}")',
        keyTakeaway:
            'Use enumerate() whenever you need BOTH the index and the value during iteration — manually tracking a separate counter variable is unnecessary and error-prone.',
      ),
      ConceptLesson(
        title: 'List Slicing & Copying',
        definition:
            'Like strings, lists support slicing to extract a sub-list. Copying a list creates an independent duplicate, separate from the original.',
        analogy:
            'Slicing a list is like photocopying just pages 3 to 7 of a long report — you get a smaller, separate document containing only that portion.',
        example:
            'numbers = [1, 2, 3, 4, 5]\nprint(numbers[1:4])     # [2, 3, 4]\n\noriginal = [1, 2, 3]\ncopy = original[:]       # creates an independent copy\ncopy.append(4)\nprint(original)  # [1, 2, 3] — unaffected\nprint(copy)      # [1, 2, 3, 4]',
        keyTakeaway:
            'Writing "copy = original" does NOT create a copy — it just creates a second name pointing to the SAME list. Use original[:] or list(original) for a true independent copy.',
        codeSnippet:
            'a = [1, 2, 3]\nb = a              # b is just another name for the SAME list\nb.append(4)\nprint(a)  # [1, 2, 3, 4] — surprise! a changed too',
      ),
      ConceptLesson(
        title: 'Common List Operations & Algorithms',
        definition:
            'Common list tasks include finding the maximum/minimum, summing all elements, sorting, filtering, and checking membership — most have built-in functions, but understanding the manual approach builds real algorithmic intuition.',
        analogy:
            'Knowing built-in shortcuts (max(), sum()) is like knowing a calculator has a square-root button. Understanding HOW to compute it manually (scanning and comparing) is like understanding the maths behind that button — essential for solving novel problems the calculator can\'t handle directly.',
        example:
            'numbers = [4, 8, 1, 9, 3]\nprint(max(numbers))    # 9\nprint(sum(numbers))    # 25\nprint(sorted(numbers)) # [1, 3, 4, 8, 9]\nprint(9 in numbers)    # True\n\n# Manual max-finding (the underlying algorithm)\ncurrent_max = numbers[0]\nfor n in numbers:\n    if n > current_max:\n        current_max = n',
        keyTakeaway:
            'In interviews, you\'ll often be asked to implement these "obvious" built-in operations manually — this proves you understand the underlying algorithm, not just the shortcut function name.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the index of the FIRST item in a list?',
        options: ['1', '0', '-1', 'It depends on the list'],
        correctIndex: 1,
        explanation:
            'Lists use zero-based indexing — the first element is at index 0, the second at index 1, and so on. This is standard across nearly all major programming languages.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does .append() do to a list, and what is its typical time complexity?',
        options: [
          'Inserts at the beginning, O(n)',
          'Adds to the end, typically O(1)',
          'Removes the last item, O(1)',
          'Sorts the entire list, O(n log n)'
        ],
        correctIndex: 1,
        explanation:
            '.append() adds a single item to the end of the list. Since no other elements need to shift, this is typically a fast, constant-time O(1) operation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'If you write "b = a" where a is a list, and then modify b, what happens to a?',
        options: [
          'a remains completely unchanged',
          'a is also affected, because b and a refer to the SAME list in memory',
          'This causes an error',
          'A new list is automatically created'
        ],
        correctIndex: 1,
        explanation:
            'b = a does not copy the list — it just creates a second variable name pointing to the exact same list object. Modifying b therefore also affects what a sees, since they reference identical memory.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'numbers = [10, 20, 30, 40, 50]\nprint(numbers[1:4])\n\nWhat is printed?',
        options: [
          '[10, 20, 30, 40]',
          '[20, 30, 40]',
          '[20, 30, 40, 50]',
          '[10, 20, 30]'
        ],
        correctIndex: 1,
        explanation:
            'Slicing [1:4] includes indices 1, 2, and 3 (stopping BEFORE index 4): that\'s 20, 30, 40.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You need to insert an item at the very beginning of a list with 1 million elements, repeatedly, inside a loop. Why might this be a performance problem?',
        options: [
          'Lists cannot have items inserted at the beginning',
          'Inserting at the beginning is O(n) because every existing element must shift over — repeating this is expensive',
          'It will cause a syntax error',
          'There is no performance concern at all'
        ],
        correctIndex: 1,
        explanation:
            'Inserting at index 0 forces every other element in the list to shift one position to make room — an O(n) operation. Doing this repeatedly in a loop becomes O(n²) overall, which is slow for large lists.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Class Leaderboard System',
      goal:
          'Build a leaderboard tool demonstrating list creation, modification, iteration, slicing, and common operations.',
      steps: [
        'Create a list of (name, score) tuples for at least 6 students',
        'Sort the list by score in descending order (without using a pre-built sort if possible, to practice the algorithm)',
        'Use slicing to extract and print only the top 3 students',
        'Add a new student to the list using .append() and re-sort',
        'Remove the lowest-scoring student using .pop() or .remove()',
        'Print a final formatted leaderboard with rank numbers using enumerate()',
      ],
      expectedOutput:
          '--- LEADERBOARD ---\n1. Aisha   - 95\n2. Kabir   - 89\n3. Priya   - 84\n4. Ravi    - 76\n5. Zara    - 70\n\nTop 3: Aisha, Kabir, Priya\nLowest scorer removed: Zara',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'sep_l2_tuples',
    topicTitle: 'Tuples',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 165,
    emoji: '🔗',
    intro:
        'Sometimes you want a collection of values that should NEVER change once created — coordinates, RGB colours, a date. Tuples give you exactly that guarantee, and understanding when to reach for a tuple instead of a list is a small but real signal of programming maturity.',
    concepts: [
      ConceptLesson(
        title: 'What is a Tuple?',
        definition:
            'A tuple is an ordered, immutable collection of items — once created, its contents cannot be changed, added to, or removed.',
        analogy:
            'A tuple is like a sealed, tamper-proof evidence bag — once items are placed inside and it\'s sealed, nobody can add, remove, or swap what\'s inside without breaking the seal (creating an entirely new bag).',
        example:
            'point = (3, 7)\nrgb_color = (255, 0, 128)\nprint(point[0])  # 3\n# point[0] = 5  # ERROR — tuples are immutable',
        keyTakeaway:
            'Use a tuple when the collection of values represents a single, fixed, logical unit (like an x,y coordinate) that should never be accidentally modified.',
      ),
      ConceptLesson(
        title: 'Tuple vs List: When to Use Which',
        definition:
            'Lists are for collections that change over time (adding/removing items). Tuples are for fixed collections representing a single conceptual unit that shouldn\'t change.',
        analogy:
            'A list is like a shopping cart — items get added and removed as you shop. A tuple is like a printed receipt after checkout — it\'s a fixed record of exactly what happened, and editing it after the fact wouldn\'t make sense.',
        example:
            'List (mutable): shopping_cart = ["milk", "eggs"]\nshopping_cart.append("bread")  # makes sense — cart changes\n\nTuple (immutable): date_of_birth = (15, "March", 1998)\n# this should never change — using a tuple signals that intent',
        keyTakeaway:
            'Choosing a tuple over a list isn\'t just a technical detail — it communicates to anyone reading your code "this data is fixed and should never be modified," which prevents accidental bugs.',
      ),
      ConceptLesson(
        title: 'Tuple Unpacking',
        definition:
            'Tuple unpacking lets you assign each element of a tuple directly to separate variables in a single line.',
        analogy:
            'Unpacking a tuple is like opening a small gift box that has 3 labelled compartments and immediately placing each item on its correctly labelled shelf in one motion.',
        example:
            'point = (3, 7)\nx, y = point\nprint(x, y)  # 3 7\n\n# Common real-world use: swapping variables\na, b = 5, 10\na, b = b, a  # swap without a temp variable!\nprint(a, b)  # 10 5',
        keyTakeaway:
            'Tuple unpacking is used constantly in real Python code — looping over dictionary items (for key, value in d.items()), or returning multiple values from a function.',
        codeSnippet:
            'def get_min_max(numbers):\n    return min(numbers), max(numbers)\n\nlow, high = get_min_max([4, 8, 1, 9])\nprint(low, high)  # 1 9',
      ),
      ConceptLesson(
        title: 'Tuples as Dictionary Keys',
        definition:
            'Because tuples are immutable, they can be used as dictionary keys — unlike lists, which cannot, since dictionary keys must be hashable (unchangeable).',
        analogy:
            'Using a tuple as a dictionary key is like using a permanent engraved nameplate as a locker label — it can\'t be smudged or changed accidentally, so it\'s safe to rely on as a fixed identifier.',
        example:
            'distances = {\n    (0, 0): 0,\n    (1, 1): 1.41,\n    (3, 4): 5.0\n}\nprint(distances[(3, 4)])  # 5.0\n\n# This would FAIL with a list key:\n# distances[[3, 4]] = 5.0  # TypeError: unhashable type: \'list\'',
        keyTakeaway:
            'This is a genuinely useful, practical reason to choose tuples: any time you need a compound (multi-part) key for a dictionary, like grid coordinates, a tuple is the natural choice.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the defining characteristic of a tuple?',
        options: [
          'It can only hold numbers',
          'It is immutable — its contents cannot be changed after creation',
          'It is always sorted automatically',
          'It can only have 2 elements'
        ],
        correctIndex: 1,
        explanation:
            'A tuple\'s defining feature is immutability — once created, you cannot add, remove, or change its elements, unlike a list.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why can tuples be used as dictionary keys, but lists cannot?',
        options: [
          'Tuples are faster than lists',
          'Dictionary keys must be immutable/hashable, and tuples satisfy this while lists do not',
          'Lists can only be dictionary values, never keys',
          'There is no actual difference'
        ],
        correctIndex: 1,
        explanation:
            'Dictionary keys must be hashable, meaning their value can never change after creation. Tuples meet this requirement because they\'re immutable; lists do not, since their contents can change.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does tuple unpacking allow you to do?',
        options: [
          'Convert a tuple into a string',
          'Assign each element of a tuple directly to separate variables in one line',
          'Make a tuple mutable',
          'Delete elements from a tuple'
        ],
        correctIndex: 1,
        explanation:
            'Tuple unpacking lets you write x, y = point to directly extract and assign each value to its own variable, instead of accessing them individually by index.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'a, b = 10, 20\na, b = b, a\nprint(a, b)\n\nWhat is printed?',
        options: ['10 20', '20 10', 'Error', '0 0'],
        correctIndex: 1,
        explanation:
            'This is the classic tuple-unpacking swap trick. The right side (b, a) is evaluated first as (20, 10), then unpacked into a, b — resulting in a=20, b=10.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You are storing GPS coordinates that should never accidentally be modified once recorded. Which data structure is the most appropriate choice?',
        options: [
          'A list',
          'A tuple',
          'A dictionary with no values',
          'A single string'
        ],
        correctIndex: 1,
        explanation:
            'A tuple is ideal here — it represents a fixed, logical unit (latitude, longitude) that should never change, and its immutability protects against accidental modification.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Geographic Distance Calculator',
      goal:
          'Build a tool that stores coordinates as tuples, uses tuple unpacking, and uses tuples as dictionary keys.',
      steps: [
        'Store at least 4 city locations as tuples: (city_name, (latitude, longitude))',
        'Write a function that takes two coordinate tuples and unpacks them into separate lat/lon variables',
        'Implement a simplified distance calculation between two coordinate tuples',
        'Build a dictionary using coordinate tuples as keys, mapping to a "visited: True/False" status',
        'Attempt to modify a tuple directly and catch the resulting TypeError to demonstrate immutability',
        'Print a summary of distances between all city pairs',
      ],
      expectedOutput:
          'Agra (27.18, 78.02) to Delhi (28.70, 77.10): ~187 km\nAttempted to modify tuple — caught TypeError as expected: tuples are immutable\nVisited status: {(27.18, 78.02): True, (28.70, 77.10): False}',
      xpReward: 45,
    ),
  ),
  TopicCourse(
    id: 'sep_l2_sets',
    topicTitle: 'Sets',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 180,
    emoji: '🎯',
    intro:
        'Need to instantly check if something already exists? Need to find common elements between two groups, or remove duplicates effortlessly? Sets are the unsung heroes of efficient programming — built directly on hash tables, giving you blazing-fast membership checks that lists simply can\'t match.',
    concepts: [
      ConceptLesson(
        title: 'What is a Set?',
        definition:
            'A set is an unordered collection of unique elements — duplicates are automatically removed, and there is no guaranteed order.',
        analogy:
            'A set is like a guest list at an exclusive party — each person\'s name appears exactly once, no matter how many times someone tries to add them again, and the list isn\'t necessarily in any particular order.',
        example:
            'numbers = {1, 2, 2, 3, 3, 3}\nprint(numbers)  # {1, 2, 3} — duplicates automatically removed\n\nempty_set = set()  # note: {} creates an empty DICT, not a set!',
        keyTakeaway:
            'A common beginner trap: {} creates an empty dictionary, NOT an empty set. You must use set() explicitly to create an empty set.',
      ),
      ConceptLesson(
        title: 'Why Sets are Fast: O(1) Membership Checks',
        definition:
            'Sets are built on hash tables internally, giving average O(1) time for checking if an item exists — dramatically faster than scanning a list (O(n)).',
        analogy:
            'Checking if a name is in a set is like checking if a name appears in a well-organised digital database with instant search — versus checking a list, which is like manually flipping through every page of a phone book one at a time.',
        example:
            'big_list = list(range(1000000))\nbig_set = set(range(1000000))\n\n# Checking membership in a list scans every element: O(n)\n999999 in big_list   # slow for large lists\n\n# Checking membership in a set uses hashing: O(1) average\n999999 in big_set    # nearly instant, regardless of size',
        keyTakeaway:
            'If your program repeatedly checks "does this item exist in my collection?", converting that collection to a set can turn a slow O(n) operation into a near-instant O(1) one.',
      ),
      ConceptLesson(
        title: 'Set Operations: Union, Intersection, Difference',
        definition:
            'Sets support powerful mathematical operations: union (combine, no duplicates), intersection (common elements), and difference (elements in one but not the other).',
        analogy:
            'Think of two Venn diagram circles: union is "everything in either circle," intersection is "only the overlapping middle," and difference is "the part of one circle NOT covered by the other."',
        example:
            'students_math = {"Aisha", "Kabir", "Priya"}\nstudents_science = {"Kabir", "Priya", "Ravi"}\n\nprint(students_math | students_science)  # union: all students in either class\nprint(students_math & students_science)  # intersection: in BOTH classes\nprint(students_math - students_science)  # difference: ONLY in math',
        keyTakeaway:
            'These set operations let you solve "find common items," "find unique items," and "combine without duplicates" problems in a single line, instead of writing manual nested loops.',
      ),
      ConceptLesson(
        title: 'Removing Duplicates with Sets',
        definition:
            'Converting a list to a set is the fastest, most idiomatic way to remove duplicate values from a collection.',
        analogy:
            'Converting a guest sign-in sheet (with possible repeated names from people signing in twice) into a guest LIST is like converting a list to a set — you automatically end up with each unique guest counted exactly once.',
        example:
            'emails = ["a@x.com", "b@x.com", "a@x.com", "c@x.com", "b@x.com"]\nunique_emails = list(set(emails))\nprint(unique_emails)  # order not guaranteed, but duplicates are gone\nprint(len(set(emails)))  # 3 unique emails',
        keyTakeaway:
            'Converting list → set → list is a one-line idiom for deduplication, but remember it does NOT preserve the original order. If order matters, use a different technique (like dict.fromkeys()).',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What happens when you add a duplicate value to a set?',
        options: [
          'The set grows with the duplicate included',
          'Nothing changes — sets automatically ignore duplicates, keeping only unique values',
          'It raises an error',
          'The entire set is cleared'
        ],
        correctIndex: 1,
        explanation:
            'Sets only ever contain unique elements. Attempting to add a value that already exists in the set has no effect — the set remains unchanged.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why are membership checks ("x in my_set") generally much faster than ("x in my_list")?',
        options: [
          'Sets are always smaller than lists',
          'Sets use hashing internally, giving O(1) average lookup versus O(n) for scanning a list',
          'Lists cannot check membership at all',
          'There is no real performance difference'
        ],
        correctIndex: 1,
        explanation:
            'Sets are built on hash tables, allowing direct, near-instant lookups regardless of size. Lists must be scanned element by element in the worst case, making membership checks O(n).',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does the intersection operation (&) between two sets return?',
        options: [
          'All elements from both sets combined',
          'Only the elements that appear in BOTH sets',
          'Elements that appear in only one set',
          'An empty set always'
        ],
        correctIndex: 1,
        explanation:
            'Intersection (&) returns only the elements common to both sets — exactly the overlapping region you\'d see in a Venn diagram of the two sets.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'a = {1, 2, 3, 4}\nb = {3, 4, 5, 6}\nprint(a - b)\n\nWhat is printed?',
        options: ['{1, 2}', '{5, 6}', '{1, 2, 3, 4, 5, 6}', '{3, 4}'],
        correctIndex: 0,
        explanation:
            'a - b returns elements in "a" that are NOT in "b". 1 and 2 are only in a, so the difference is {1, 2}.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You need to check, millions of times, whether a username already exists in a system with 10 million registered users. Which data structure should you use for this check?',
        options: [
          'A list, scanning each time',
          'A set, for O(1) average membership checks',
          'A tuple',
          'A single large string'
        ],
        correctIndex: 1,
        explanation:
            'With millions of repeated lookups against 10 million users, a set\'s O(1) average membership check vastly outperforms a list\'s O(n) linear scan — this difference could mean milliseconds versus seconds per check.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Student Enrollment Analyzer',
      goal:
          'Build a tool using sets to analyze overlapping and unique student enrollments across multiple courses.',
      steps: [
        'Create 3 sets representing students enrolled in Math, Science, and Art courses',
        'Find students enrolled in BOTH Math and Science using intersection',
        'Find students enrolled in Math but NOT in any other course using difference operations',
        'Find all unique students across all 3 courses combined using union',
        'Remove duplicate entries from a raw enrollment list (with accidental repeats) using set conversion',
        'Print a clear summary report of all findings',
      ],
      expectedOutput:
          'Math & Science overlap: {Kabir, Priya}\nMath-only students: {Aisha}\nAll unique students (union): {Aisha, Kabir, Priya, Ravi, Zara}\nDeduplicated raw list: 5 unique students from 8 raw entries',
      xpReward: 45,
    ),
  ),
  TopicCourse(
    id: 'sep_l2_dictionaries_hashmaps',
    topicTitle: 'Dictionaries / Hash Maps',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 210,
    emoji: '🗂️',
    intro:
        'If you learn only ONE data structure deeply in your entire career, make it the hash map. It powers databases, caches, compilers, and is the single most commonly used data structure in real-world software engineering — and in coding interviews, it\'s often the key to turning a slow brute-force solution into a fast, elegant one.',
    concepts: [
      ConceptLesson(
        title: 'What is a Dictionary (Hash Map)?',
        definition:
            'A dictionary stores data as key-value pairs, allowing you to retrieve a value almost instantly using its associated key, rather than searching through a sequence.',
        analogy:
            'A dictionary is exactly like a real-world phone book or word dictionary: you look up a specific entry (key) and immediately get its associated information (value) — you don\'t need to read every page in order.',
        example:
            'student = {\n    "name": "Aisha",\n    "age": 21,\n    "grade": "A"\n}\nprint(student["name"])  # Aisha\nprint(student.get("city", "Unknown"))  # "Unknown" — safe default if key missing',
        keyTakeaway:
            'Use .get(key, default) instead of direct [key] access when a key might not exist — it avoids a KeyError crash and lets you specify a sensible fallback value.',
      ),
      ConceptLesson(
        title: 'How Hashing Works (Conceptually)',
        definition:
            'A hash function converts a key into a number (a "hash"), which determines roughly where in memory the value is stored — enabling near-instant lookup without searching.',
        analogy:
            'Hashing is like a coat-check system at a theatre: your ticket number (hash of the key) tells the attendant EXACTLY which hook your coat (value) is hanging on — no need to search through every coat in the building.',
        example:
            'hash("apple")   # some large number, e.g. 4324908213\nhash("banana")  # a completely different number\n\n# Python uses this internally to decide where to store each key-value pair\n# so it can find it again instantly without scanning',
        keyTakeaway:
            'You almost never call hash() directly in real code — but understanding that THIS is what makes O(1) lookup possible explains why dictionaries are so fast.',
      ),
      ConceptLesson(
        title: 'Adding, Updating & Removing Entries',
        definition:
            'Dictionaries support adding new key-value pairs, updating existing values, and removing entries entirely — all in average O(1) time.',
        analogy:
            'Updating a dictionary entry is like erasing and rewriting one specific page in your address book — you don\'t need to touch or reprint any other page.',
        example:
            'inventory = {"apples": 50, "bananas": 30}\ninventory["apples"] = 45        # update existing key\ninventory["cherries"] = 20      # add new key\ndel inventory["bananas"]        # remove a key entirely\nprint(inventory)  # {\'apples\': 45, \'cherries\': 20}',
        keyTakeaway:
            'Unlike lists, dictionaries let you add, update, or remove ANY entry directly by key, without needing to know its position or shift other elements around.',
      ),
      ConceptLesson(
        title: 'Iterating Over Dictionaries',
        definition:
            'You can iterate over a dictionary\'s keys, values, or key-value pairs together using .keys(), .values(), and .items().',
        analogy:
            'Iterating with .items() is like flipping through every page of an address book and reading BOTH the name AND the phone number on each page, rather than just one or the other.',
        example:
            'prices = {"tea": 50, "coffee": 120, "juice": 80}\nfor item, price in prices.items():\n    print(f"{item}: ₹{price}")\n\nfor item in prices.keys():\n    print(item)\n\nfor price in prices.values():\n    print(price)',
        keyTakeaway:
            'In modern Python (3.7+), dictionaries preserve insertion order — iterating gives you items in the order they were added, which wasn\'t guaranteed in older versions.',
      ),
      ConceptLesson(
        title: 'Real Interview Pattern: Frequency Counting',
        definition:
            'One of the most common interview patterns is using a dictionary to count how many times each item appears in a collection — turning an O(n²) brute-force comparison into an O(n) solution.',
        analogy:
            'Frequency counting with a dictionary is like a librarian tallying book genres by simply adding a checkmark to each genre\'s tally sheet as books come in — one quick pass, instead of repeatedly re-counting the entire pile for each genre.',
        example:
            'words = ["the", "cat", "sat", "the", "cat", "the"]\nfrequency = {}\nfor word in words:\n    frequency[word] = frequency.get(word, 0) + 1\nprint(frequency)  # {\'the\': 3, \'cat\': 2, \'sat\': 1}\n\nmost_common = max(frequency, key=frequency.get)\nprint(most_common)  # "the"',
        keyTakeaway:
            'This single pattern — "loop once, use a dictionary to count or group" — solves an enormous fraction of real interview questions: anagrams, duplicates, most-frequent-element, and more.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does a dictionary primarily store?',
        options: [
          'Only numbers, in sorted order',
          'Key-value pairs, allowing fast lookup by key',
          'Only unique values with no keys',
          'A fixed-size sequence of items'
        ],
        correctIndex: 1,
        explanation:
            'A dictionary maps keys to values, allowing you to retrieve associated data almost instantly using the key, rather than searching sequentially.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why does using .get(key, default) help avoid errors?',
        options: [
          'It always returns None',
          'It safely returns a default value instead of crashing with a KeyError if the key does not exist',
          'It deletes the key if not found',
          'It is identical to using square brackets []'
        ],
        correctIndex: 1,
        explanation:
            'Direct access with dictionary[key] raises a KeyError if the key is missing. .get(key, default) gracefully returns the specified default value instead, avoiding a crash.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What real-world problem-solving pattern uses a dictionary to turn an O(n²) approach into O(n)?',
        options: [
          'Sorting a list',
          'Frequency counting — tallying occurrences in a single pass instead of repeated comparisons',
          'Reversing a string',
          'Printing output to the console'
        ],
        correctIndex: 1,
        explanation:
            'Instead of comparing every item against every other item (O(n²)), using a dictionary to count occurrences requires just one pass through the data (O(n)) — a massive efficiency gain.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'inventory = {"apples": 10}\nprint(inventory["bananas"])\n\nWhat happens?',
        options: [
          'Prints None',
          'Prints 0',
          'Raises a KeyError',
          'Prints an empty string'
        ],
        correctIndex: 2,
        explanation:
            'Accessing a missing key directly with square brackets raises a KeyError, crashing the program if not handled. Using .get("bananas", 0) instead would safely return 0.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You need to check if two words are anagrams of each other (same letters, different order). Which approach using a dictionary is most efficient?',
        options: [
          'Compare every letter of word 1 against every letter of word 2 with nested loops',
          'Build a letter-frequency dictionary for each word and compare the two dictionaries for equality',
          'Sort both words and assume they cannot be anagrams',
          'Anagram checking cannot use dictionaries'
        ],
        correctIndex: 1,
        explanation:
            'Building a frequency count of letters for each word (a single O(n) pass each) and then comparing the two resulting dictionaries is far more efficient than nested-loop comparisons, and is a classic interview pattern.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Word Frequency & Anagram Checker',
      goal:
          'Build a tool that uses dictionaries for frequency counting and to check if two words are anagrams.',
      steps: [
        'Write a function word_frequency(text) that returns a dictionary counting how often each word appears',
        'Identify and print the most frequent word using the dictionary',
        'Write a function are_anagrams(word1, word2) using letter-frequency dictionaries to check if two words are anagrams',
        'Test are_anagrams with at least 3 pairs, including one true anagram and one false case',
        'Use .get() with a default value throughout to avoid any KeyError crashes',
        'Print a clear, formatted summary of all results',
      ],
      expectedOutput:
          'Word frequencies: {"the": 3, "cat": 2, "sat": 1}\nMost frequent word: "the"\n\n"listen" and "silent" are anagrams: True\n"hello" and "world" are anagrams: False',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'sep_l2_time_complexity_intro',
    topicTitle: 'Time Complexity Introduction',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 210,
    emoji: '⏱️',
    intro:
        'Two solutions can both be "correct" and produce identical results — yet one finishes instantly while the other takes hours on large input. Time complexity (Big-O notation) is the language engineers use to talk precisely about HOW WELL a solution scales, and it is one of the single most interview-tested concepts in all of software engineering.',
    concepts: [
      ConceptLesson(
        title: 'Why Time Complexity Matters',
        definition:
            'Time complexity describes how the running time of an algorithm grows as the input size grows — NOT the exact number of seconds it takes on one specific computer.',
        analogy:
            'Time complexity is like comparing two delivery methods by how they scale: walking door-to-door gets slower in direct proportion to the number of houses, while a postal sorting machine barely slows down even as volume grows massively.',
        example:
            'Searching for a name in an unsorted list of 10 people: fast, barely noticeable\nSearching for a name in an unsorted list of 100 million people: could take minutes with the wrong algorithm\nTime complexity predicts THIS scaling behaviour before you even run the code.',
        keyTakeaway:
            'A program that works fine in testing with 10 items can completely fail in production with 10 million items if its time complexity is poor — this gap is a leading cause of real-world performance crises.',
      ),
      ConceptLesson(
        title: 'Big-O Notation Basics',
        definition:
            'Big-O notation describes the WORST-CASE growth rate of an algorithm\'s running time as a function of input size (n), ignoring constant factors and lower-order terms.',
        analogy:
            'Big-O is like describing a car\'s fuel efficiency category (economy vs sports vs truck) rather than its exact litres-per-100km on one specific road — it captures the general PATTERN of behaviour, not one precise measurement.',
        example:
            'O(1)      — constant time: same speed regardless of input size\nO(log n)  — logarithmic: grows very slowly (e.g. binary search)\nO(n)      — linear: grows directly proportional to input size\nO(n log n)— log-linear: efficient sorting algorithms\nO(n²)     — quadratic: nested loops over the same data\nO(2^n)    — exponential: extremely slow for large n',
        keyTakeaway:
            'When comparing Big-O complexities for large n, O(1) < O(log n) < O(n) < O(n log n) < O(n²) < O(2^n) — each category is dramatically slower than the one before it as input grows.',
      ),
      ConceptLesson(
        title: 'Identifying Common Complexities in Code',
        definition:
            'You can often identify time complexity by examining loop structure: a single loop over n items is typically O(n); nested loops over the same data are typically O(n²).',
        analogy:
            'Counting nested loop levels is like counting how many times you re-check the same shelf: checking each book once is O(n); checking every book against every OTHER book is like rechecking the shelf for every single item — O(n²).',
        example:
            '# O(n) — single pass\nfor item in my_list:\n    print(item)\n\n# O(n²) — nested loop over the same list\nfor item1 in my_list:\n    for item2 in my_list:\n        print(item1, item2)\n\n# O(1) — no loop, constant operations regardless of input size\nfirst_item = my_list[0]',
        keyTakeaway:
            'Be careful: not every nested loop is automatically O(n²). A loop nested inside another but iterating over a FIXED small number (like always 5 times) doesn\'t multiply complexity the same way.',
        codeSnippet:
            '# O(n) despite looking nested — inner loop is fixed size, not "n"\nfor item in my_list:        # n iterations\n    for i in range(5):       # always exactly 5, regardless of n\n        print(item, i)',
      ),
      ConceptLesson(
        title: 'Best, Average & Worst Case',
        definition:
            'An algorithm can have different complexities depending on the input scenario: best case (most favourable input), average case (typical input), and worst case (least favourable input) — Big-O typically refers to worst case.',
        analogy:
            'Searching for your keys in a messy room has a best case (they\'re right on top, found instantly), an average case (some searching needed), and a worst case (they\'re in the very last place you check) — Big-O analysis usually plans for that worst case.',
        example:
            'Linear search for a target value in an unsorted list:\nBest case: target is the FIRST item — O(1)\nWorst case: target is the LAST item, or not present at all — O(n)\n\nWe typically describe this algorithm\'s complexity as O(n), referring to the worst case.',
        keyTakeaway:
            'When an interviewer asks "what is the time complexity of this?", they almost always mean the worst case unless explicitly stated otherwise.',
      ),
      ConceptLesson(
        title: 'Comparing Algorithms with the Same Goal',
        definition:
            'Different algorithms can solve the exact same problem with very different time complexities — understanding this lets you make informed engineering trade-offs.',
        analogy:
            'Finding a name in a phone book by checking every single page (O(n)) versus using the alphabetical structure to repeatedly check the middle and narrow down (O(log n), binary search) — both find the answer, but one scales dramatically better.',
        example:
            'Problem: "Does this sorted list of 1 million numbers contain X?"\nLinear search: O(n) — up to 1,000,000 checks in the worst case\nBinary search: O(log n) — only about 20 checks in the worst case, because it discards half the remaining list each step',
        keyTakeaway:
            'The SAME problem, solved with a smarter algorithm exploiting structure (like sortedness), can be the difference between an instant response and a multi-second delay — this is the entire reason algorithmic knowledge matters in real engineering.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does Big-O notation primarily describe?',
        options: [
          'The exact number of seconds an algorithm takes',
          'How an algorithm\'s running time grows as input size increases, typically in the worst case',
          'How much memory a program uses, only',
          'The programming language used'
        ],
        correctIndex: 1,
        explanation:
            'Big-O describes the GROWTH RATE of running time relative to input size — a general scaling pattern, not a precise stopwatch measurement tied to one specific machine.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which time complexity generally scales WORSE (slower) as input size grows: O(n) or O(n²)?',
        options: [
          'O(n) is worse',
          'O(n²) is worse',
          'They are identical',
          'It depends entirely on the programming language'
        ],
        correctIndex: 1,
        explanation:
            'O(n²) grows quadratically — doubling the input size roughly quadruples the work. O(n) grows linearly — doubling the input size only doubles the work, making it far more scalable.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A single for loop iterating once over a list of n items is typically what time complexity?',
        options: ['O(1)', 'O(log n)', 'O(n)', 'O(n²)'],
        correctIndex: 2,
        explanation:
            'A single pass through n items, doing a constant amount of work per item, is the textbook definition of O(n) — linear time complexity.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'What is the time complexity of this code?\n\nfor i in range(n):\n    for j in range(n):\n        print(i, j)',
        options: ['O(n)', 'O(log n)', 'O(n²)', 'O(1)'],
        correctIndex: 2,
        explanation:
            'Both loops iterate over a size proportional to n, and they are nested — total operations grow as n × n = n², making this O(n²).',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You have a sorted list of 1 million numbers and need to repeatedly check if specific values exist. Which approach scales best?',
        options: [
          'Linear search every time — O(n) per check',
          'Binary search every time — O(log n) per check',
          'Both perform identically',
          'Sorting doesn\'t affect search performance'
        ],
        correctIndex: 1,
        explanation:
            'Because the list is sorted, binary search can repeatedly halve the search space, achieving O(log n) per check — roughly 20 comparisons for 1 million items, versus up to 1,000,000 for linear search.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Algorithm Complexity Comparison Tool',
      goal:
          'Implement and empirically compare two algorithms with different time complexities solving the same problem.',
      steps: [
        'Implement a linear search function with O(n) complexity to find a target in an unsorted list',
        'Implement a binary search function with O(log n) complexity to find a target in a SORTED list',
        'Generate test lists of increasing size: 100, 10,000, and 1,000,000 elements',
        'Time both functions (using a timing library) on each list size and record the results',
        'Print a comparison table showing how each algorithm\'s time scales as input size grows',
        'Write a 2-3 sentence conclusion explaining the observed pattern in terms of Big-O',
      ],
      expectedOutput:
          'Size: 100      Linear: 0.00001s   Binary: 0.000001s\nSize: 10,000   Linear: 0.001s     Binary: 0.000002s\nSize: 1,000,000 Linear: 0.08s     Binary: 0.000003s\n\nConclusion: Binary search\'s O(log n) barely increases as input grows 10,000x, while linear search\'s O(n) scales directly with size.',
      xpReward: 55,
    ),
  ),
];
