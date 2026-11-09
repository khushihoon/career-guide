// ══════════════════════════════════════════════════════════════════════
// lib/data/courses/cyber_security_level_4.dart
// Cyber Security Engineer Path — LEVEL 4: Programming & Security
// Automation (10 lessons)
// ══════════════════════════════════════════════════════════════════════
import '../../models/course_content_data.dart';

const List<TopicCourse> cyberSecurityLevel4 = [
  // ────────────────────────────────────────────────────────────────────
  // LESSON 1
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l4_why_programming',
    topicTitle: 'Why Programming Matters in Security & Python Setup',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 26,
    totalXp: 180,
    emoji: '💻',
    intro:
        'A security team may face millions of log lines a day, and nobody can read them by hand. Programming lets you automate the boring parts, build your own tools, and understand how software can be attacked. This lesson shows why code is a core security skill and gets your environment ready.',
    concepts: [
      ConceptLesson(
        title: 'How Security Engineers Use Code',
        definition:
            'Security engineers write scripts and small programs to automate repeated tasks, analyse data, connect tools together, and test their own systems.',
        analogy:
            'A security analyst without scripting is like a detective who must read every page of every file by hand. One who can script has a tireless assistant that searches thousands of files in seconds.',
        example:
            'Everyday security uses of code:\n\nParse logs to find failed logins\nCheck file integrity with hashes\nCheck your own network for open ports\nPull threat data from APIs\nAutomate account audits and reports\nBuild alerts for suspicious activity\nAutomate incident response steps (SOAR)\nRead source code to review it for flaws',
        keyTakeaway:
            'You do not need to be a full-time software developer. You need to read code, write practical scripts, and automate your own work.',
      ),
      ConceptLesson(
        title: 'Why Python and Bash',
        definition:
            'Python is the most popular security language because of its readable syntax and huge library ecosystem. Bash is the shell language of Linux, ideal for gluing commands together.',
        analogy:
            'Bash is the Swiss army knife in your pocket for quick jobs on a server. Python is the full toolbox in your workshop for bigger, reusable projects.',
        example:
            'When to use which:\n\nBash:\n  Quick tasks on Linux\n  Chaining commands with pipes\n  Cron jobs and server maintenance\n\nPython:\n  Parsing complex data (JSON, CSV)\n  Calling web APIs\n  Network and file tools\n  Larger tools you want to test and reuse\n\nOthers you will meet:\n  PowerShell (Windows automation)\n  JavaScript (web security)\n  C and C++ (understanding memory bugs)\n  Go and Rust (modern security tooling)',
        keyTakeaway:
            'Start with Python and Bash. Together they cover most day-to-day security automation.',
      ),
      ConceptLesson(
        title: 'Setting Up a Safe Python Environment',
        definition:
            'A virtual environment is an isolated folder holding the Python packages for one project, so projects do not interfere with each other or with the system Python.',
        analogy:
            'A virtual environment is a separate toolbox for each project. You never mix the screws of one project with the tools of another.',
        example:
            'Setup steps:\n\n1. Install Python 3.10 or newer\n2. Install a code editor such as VS Code\n3. Create a project folder\n4. Create and activate a virtual environment\n5. Install packages with pip\n6. Track dependencies in requirements.txt\n7. Put the project under Git version control\n\nHabit: install packages only from the official PyPI index and check the exact package name, because fake look-alike packages exist.',
        keyTakeaway:
            'Always use a virtual environment and pin your dependencies. Typosquatted packages are a real supply chain attack.',
        codeSnippet:
            'python3 --version\npython3 -m venv venv\nsource venv/bin/activate\npip install requests\npip freeze > requirements.txt',
      ),
      ConceptLesson(
        title: 'Running Scripts and Reading Errors',
        definition:
            'You run a Python script from the terminal, and when it fails Python prints a traceback that shows the error type, file, and line number. Learning to read it is the fastest way to debug.',
        analogy:
            'A traceback is a trail of footprints leading to the spot where the program tripped. Read it from the bottom up: the last line says what went wrong, the lines above say where.',
        example:
            'Common beginner errors:\n\nSyntaxError: typo or missing symbol\nIndentationError: wrong spacing (Python uses indentation as structure)\nNameError: using a variable that does not exist\nTypeError: mixing incompatible types\nFileNotFoundError: wrong path\nModuleNotFoundError: package not installed in this environment\n\nDebugging habits:\n  Print intermediate values\n  Run small pieces first\n  Search the exact error message',
        keyTakeaway:
            'Errors are normal. Read the last line first, then the line number, then fix one thing at a time.',
        codeSnippet:
            'print("Hello, security world")\nname = "analyst"\nprint(f"Welcome, {name}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why is scripting valuable for a SOC analyst?',
        options: [
          'It lets them automate searching and analysing large volumes of data',
          'It replaces the need for any security knowledge',
          'It makes computers faster',
          'It is only needed by web designers'
        ],
        correctIndex: 0,
        explanation:
            'Automation handles repetitive, large-scale tasks such as log parsing, freeing analysts to focus on judgement and investigation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the main benefit of a Python virtual environment?',
        options: [
          'It makes Python run faster',
          'It isolates a project dependencies from other projects and the system',
          'It encrypts your code',
          'It removes the need for pip'
        ],
        correctIndex: 1,
        explanation:
            'Isolation avoids version conflicts and makes your project reproducible and safer to manage.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A package called "reqeusts" appears in a tutorial. What should you suspect?',
        options: [
          'It is the official package',
          'It may be a typosquatted look-alike of "requests", so verify the exact name first',
          'It is a built-in Python module',
          'It is safe because it is on the internet'
        ],
        correctIndex: 1,
        explanation:
            'Attackers publish packages with misspelt names hoping developers install them by mistake. Always check names carefully.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You run a script and see: ModuleNotFoundError: No module named requests. What is the most likely fix?',
        options: [
          'Reinstall the operating system',
          'Activate the right virtual environment and install the package with pip',
          'Delete the script',
          'Change the font in the editor'
        ],
        correctIndex: 1,
        explanation:
            'The package is not installed in the active environment. Activate the correct venv and run pip install requests.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Which statement best describes when to choose Bash instead of Python?',
        options: [
          'For quick command chaining and server tasks on Linux',
          'For building complex data processing with JSON and APIs',
          'Never, Bash is obsolete',
          'Only on Windows'
        ],
        correctIndex: 0,
        explanation:
            'Bash is ideal for short command pipelines and maintenance tasks. Python suits larger and more structured programs.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Set Up Your Security Automation Workspace',
      goal:
          'Prepare a clean development environment and run your first security-flavoured script.',
      steps: [
        'Install Python 3.10 or newer and VS Code (or another editor)',
        'Create a folder named security-automation and a virtual environment inside it',
        'Install requests and note the version with pip freeze',
        'Initialise a Git repository and make your first commit with a README',
        'Write hello.py that prints your name and today date using the datetime module',
        'Deliberately cause a NameError, read the traceback, and write what each line told you',
      ],
      expectedOutput:
          'Workspace ready\n\nPython 3.12 | venv active | requests 2.x installed\nGit repo initialised, first commit: Add README\n\nhello.py output:\n  Hello, I am Anita - 2026-01-15\n\nTraceback notes:\n  Last line: NameError: name total is not defined\n  Line 7 in hello.py -> variable never created ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 2
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l4_python_fundamentals',
    topicTitle: 'Python Fundamentals for Security',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 32,
    totalXp: 195,
    emoji: '🐍',
    intro:
        'Before you can parse logs or build tools you need the basic building blocks of Python: variables, decisions, loops, functions, and error handling. Every example in this lesson uses a security flavour so the ideas stick.',
    concepts: [
      ConceptLesson(
        title: 'Variables and Data Types',
        definition:
            'A variable stores a value under a name. Python has built-in types for text (str), whole numbers (int), decimals (float), true or false (bool), and collections.',
        analogy:
            'A variable is a labelled box. The label is the name, and the box holds a value you can look at or change later.',
        example:
            'Examples:\n\nusername = "admin"        str\nfailed_attempts = 5       int\nrisk_score = 7.5          float\nis_locked = False         bool\n\nUseful facts:\n  type(x) shows the type\n  int("42") converts text to a number\n  f"User {username} failed {failed_attempts} times" builds readable text',
        keyTakeaway:
            'Choose clear names such as failed_attempts instead of x. Readable code is easier to review and less likely to hide bugs.',
        codeSnippet:
            'username = "admin"\nfailed_attempts = 5\nprint(f"{username} failed {failed_attempts} times")\nprint(type(failed_attempts))',
      ),
      ConceptLesson(
        title: 'Decisions and Loops',
        definition:
            'if, elif, and else let a program choose between actions. for and while loops repeat actions. Together they are how you process many events and react to them.',
        analogy:
            'A security guard checks each visitor in turn (loop) and for each one decides whether to allow, question, or refuse them (decision).',
        example:
            'Logic you will use constantly:\n\nif attempts > 5: flag the account\nfor line in file: examine each log line\nwhile not done: keep retrying with a limit\nbreak and continue control a loop\n\nOperators:\n  == equal, != not equal, > < comparisons\n  and, or, not combine conditions',
        keyTakeaway:
            'Most security scripts are a loop over events with a few decisions inside. Master this pattern first.',
        codeSnippet:
            'attempts = [2, 7, 1, 9]\nfor n in attempts:\n    if n > 5:\n        print(f"{n} attempts: suspicious")\n    else:\n        print(f"{n} attempts: normal")',
      ),
      ConceptLesson(
        title: 'Functions and Reuse',
        definition:
            'A function is a named block of code you can call many times with different inputs. Functions keep scripts organised, testable, and easy to reuse.',
        analogy:
            'A function is a recipe. Write it once, then cook it whenever you need it with different ingredients.',
        example:
            'Why functions matter in security tooling:\n\nis_private_ip(ip)\ncount_failed_logins(path)\nsha256_file(path)\nsend_alert(message)\n\nGood habits:\n  One job per function\n  Descriptive names\n  Return values instead of printing inside everything\n  Add short docstrings',
        keyTakeaway:
            'Small, single-purpose functions are easier to test and trust. Large tangled scripts hide mistakes.',
        codeSnippet:
            'def risk_level(attempts):\n    if attempts >= 10:\n        return "high"\n    if attempts >= 5:\n        return "medium"\n    return "low"\n\nprint(risk_level(7))',
      ),
      ConceptLesson(
        title: 'Handling Errors Safely',
        definition:
            'try and except let your program handle problems, such as a missing file or bad input, without crashing or leaking confusing details.',
        analogy:
            'It is a safety net under a trapeze artist. If something goes wrong, the program lands gently and decides what to do next.',
        example:
            'Common failures to handle:\n\nFileNotFoundError: log file does not exist\nPermissionError: no rights to read it\nValueError: bad number in the data\nConnectionError: network call failed\n\nSecurity notes:\n  Do not hide errors silently with an empty except\n  Log what went wrong\n  Never print passwords or keys in error messages',
        keyTakeaway:
            'Catch specific errors, log them, and fail safely. A silent failure in a security tool can mean missed attacks.',
        codeSnippet:
            'try:\n    with open("auth.log") as f:\n        lines = f.readlines()\nexcept FileNotFoundError:\n    print("Log file not found")\nexcept PermissionError:\n    print("No permission to read the log")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What will type(5.0) return in Python?',
        options: ['int', 'str', 'float', 'bool'],
        correctIndex: 2,
        explanation: '5.0 has a decimal point, so Python treats it as a float.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is a bare except that ignores all errors dangerous in a security script?',
        options: [
          'It makes the script faster',
          'It can hide failures so the tool silently misses attacks',
          'It deletes the logs',
          'It stops Python from running'
        ],
        correctIndex: 1,
        explanation:
            'Silent failures give a false sense of safety. Catch specific errors and log them.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the best reason to put code in functions?',
        options: [
          'Functions make files bigger',
          'They make code reusable, readable, and easier to test',
          'Python requires them',
          'They hide the code from reviewers'
        ],
        correctIndex: 1,
        explanation:
            'Well-named functions break big problems into small trusted pieces.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'What does this code print?\n\nattempts = [3, 8, 5]\nfor n in attempts:\n    if n > 5:\n        print("flag")',
        options: ['flag three times', 'flag once', 'nothing', 'an error'],
        correctIndex: 1,
        explanation: 'Only 8 is greater than 5, so flag is printed once.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A function receives the text "abc" but expects a number and calls int(). Which error is raised?',
        options: [
          'FileNotFoundError',
          'ValueError',
          'NameError',
          'IndentationError'
        ],
        correctIndex: 1,
        explanation:
            'int("abc") raises a ValueError because the text cannot be converted to an integer.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Login Risk Scorer',
      goal:
          'Write a small program that scores login activity and flags risky accounts.',
      steps: [
        'Create a list of dictionaries with fake data: username, failed_attempts, country',
        'Write a function risk_level(failed_attempts) returning low, medium, or high',
        'Loop over the data and print each user with the risk level',
        'Add 1 extra rule: login from an unusual country raises the risk by one level',
        'Wrap file or input handling in try and except and print a clear message on errors',
        'Print a summary count of how many users are low, medium, and high',
      ],
      expectedOutput:
          'Login Risk Report\n\nanita   2 attempts  IN  low\nravi    7 attempts  IN  medium\nmaya    3 attempts  XX  medium (unusual country)\nadmin  12 attempts  IN  high\n\nSummary: low 1 | medium 2 | high 1 ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 3
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l4_files_regex_logs',
    topicTitle: 'Files, Strings & Regex for Log Analysis',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 34,
    totalXp: 205,
    emoji: '🔎',
    intro:
        'Logs are text, and security work is largely about finding the interesting lines in a mountain of text. Reading files safely, slicing strings, and using regular expressions turn you into a fast log detective.',
    concepts: [
      ConceptLesson(
        title: 'Reading and Writing Files Safely',
        definition:
            'Python opens files with open(). The with statement closes the file automatically, even if an error happens. Large log files should be read line by line, not all at once.',
        analogy:
            'Reading a huge book one page at a time is easy. Trying to hold the whole library in your hands at once is not.',
        example:
            'Good patterns:\n\nwith open(path) as f:\n    for line in f:\n        process(line)\n\nModes:\n  r read, w write (overwrites), a append, rb binary read\n\nSafety:\n  Never build file paths blindly from user input (path traversal)\n  Do not overwrite original evidence files\n  Handle encoding issues with errors="replace" when logs contain odd characters',
        keyTakeaway:
            'Iterate line by line and always use with. Treat original log files as evidence: read them, never modify them.',
        codeSnippet:
            'count = 0\nwith open("auth.log", errors="replace") as f:\n    for line in f:\n        if "Failed password" in line:\n            count += 1\nprint(count)',
      ),
      ConceptLesson(
        title: 'String Methods for Parsing',
        definition:
            'Strings have built-in methods to split, strip, search, and transform text. Simple parsing often needs nothing more.',
        analogy:
            'String methods are scissors, tape, and a highlighter for text: cut it, clean it, and mark what matters.',
        example:
            'Useful methods:\n\nline.strip()          remove spaces and newline\nline.split()          break into words\nline.split(",")       break on commas\n"error" in line       substring test\nline.startswith("Jan")\nline.lower()          case-insensitive checks\nline.replace("a","b")\n\nExample log line:\n  Jan 10 02:41:07 server sshd[991]: Failed password for root from 203.0.113.9 port 51234 ssh2',
        keyTakeaway:
            'When the format is simple, split and in are enough. When it varies, switch to regular expressions.',
      ),
      ConceptLesson(
        title: 'Regular Expressions',
        definition:
            'A regular expression (regex) describes a text pattern, such as an IP address, so you can find or extract matches from messy text. Python provides the re module.',
        analogy:
            'A regex is a stencil. Lay it over a page of text and only the shapes that fit the stencil show through.',
        example:
            'Building blocks:\n\n\\d    a digit\n\\w    a letter, digit, or underscore\n.     any character\n+     one or more\n*     zero or more\n( )   capture a group\n[ ]   a set of characters\n\nPattern for an IPv4-like value:\n  (\\d+\\.\\d+\\.\\d+\\.\\d+)\n\nNote: this matches the shape only. Use the ipaddress module afterwards to validate real addresses.',
        keyTakeaway:
            'Regex finds candidates; validation confirms them. Always test patterns on sample data and keep them as readable as you can.',
        codeSnippet:
            'import re\n\nline = "Failed password for root from 203.0.113.9 port 51234"\nm = re.search(r"from (\\d+\\.\\d+\\.\\d+\\.\\d+)", line)\nif m:\n    print(m.group(1))',
      ),
      ConceptLesson(
        title: 'Counting and Summarising Events',
        definition:
            'Once you can extract fields, you can count and rank them. collections.Counter makes it simple to find the most frequent IPs, users, or error codes.',
        analogy:
            'It is like tallying votes: every time an IP appears, add one mark, then see who has the most marks.',
        example:
            'Typical analysis:\n\nTop 5 source IPs of failed logins\nUsers with the most failures\nRequests per hour (spot spikes)\nStatus codes on a web server (many 404 means scanning)\n\nOutput ideas:\n  Print a table\n  Save to CSV\n  Raise an alert above a threshold',
        keyTakeaway:
            'Counting by field is the heart of log analysis. A sudden spike or a single dominant source is usually where to look first.',
        codeSnippet:
            'import re\nfrom collections import Counter\n\npattern = re.compile(r"Failed password .* from (\\d+\\.\\d+\\.\\d+\\.\\d+)")\ncounts = Counter()\n\nwith open("auth.log", errors="replace") as f:\n    for line in f:\n        m = pattern.search(line)\n        if m:\n            counts[m.group(1)] += 1\n\nfor ip, n in counts.most_common(5):\n    print(ip, n)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why should large log files be read line by line?',
        options: [
          'It uses less memory and works on very big files',
          'Python cannot read whole files',
          'It makes the file encrypted',
          'It is required by law'
        ],
        correctIndex: 0,
        explanation:
            'Iterating over lines keeps memory use small even if the file is gigabytes in size.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the with statement guarantee when opening a file?',
        options: [
          'The file is deleted',
          'The file is closed automatically, even if an error occurs',
          'The file is encrypted',
          'The file is copied'
        ],
        correctIndex: 1,
        explanation:
            'with handles clean-up for you and prevents leaked file handles.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A regex matches 999.999.999.999 as an IP-like pattern. What should you do next?',
        options: [
          'Trust it, regex always validates',
          'Validate the value with the ipaddress module',
          'Ignore the match',
          'Delete the log'
        ],
        correctIndex: 1,
        explanation:
            'Regex checks shape only. ipaddress.ip_address() confirms that the value is a real address.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You need the 3 most common failing IP addresses in an authentication log. Which Python tool makes the counting simplest?',
        options: [
          'collections.Counter',
          'os.remove',
          'time.sleep',
          'random.choice'
        ],
        correctIndex: 0,
        explanation:
            'Counter tallies items and most_common(n) returns the top n, which is perfect for ranking IPs.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'An analyst opens a log file in write mode (w) to "add a note". What happens?',
        options: [
          'The note is added at the end',
          'The file is erased and replaced, destroying the original evidence',
          'Nothing changes',
          'The file becomes read-only'
        ],
        correctIndex: 1,
        explanation:
            'Mode w truncates the file. Use append mode or a separate output file, and never modify original evidence.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Auth Log Analyzer',
      goal:
          'Write a script that reads an authentication log and reports suspicious login activity.',
      steps: [
        'Create a sample auth.log with at least 40 lines of fake data mixing Failed and Accepted logins',
        'Use a regex to extract the IP address from each failed login line',
        'Count failures per IP with Counter and print the top 5',
        'Detect any IP with failures followed by an Accepted login and flag it',
        'Validate every extracted IP with the ipaddress module',
        'Write the results to a report.txt file without modifying the original log',
      ],
      expectedOutput:
          'Auth Log Analysis\n\nTotal failed logins: 36\nTop sources:\n  203.0.113.9   24\n  198.51.100.7  8\n\nALERT: 203.0.113.9 had 24 failures then an Accepted login\nInvalid IP strings skipped: 1\nReport saved to report.txt ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 4
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l4_data_structures_formats',
    topicTitle: 'Data Structures, JSON & CSV for Security Data',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 195,
    emoji: '🗂️',
    intro:
        'Security tools exchange data constantly: alerts in JSON, exports in CSV, asset lists in tables. Knowing how to hold and transform that data in lists, dictionaries, and sets is what lets you build real reports and detections.',
    concepts: [
      ConceptLesson(
        title: 'Lists, Dictionaries, and Sets',
        definition:
            'A list is an ordered collection. A dictionary stores key-value pairs. A set stores unique items and is very fast for membership tests.',
        analogy:
            'A list is a numbered queue. A dictionary is a phonebook where you look up a name to get a number. A set is a guest list where each name appears only once.',
        example:
            'Security uses:\n\nlist: events in the order they happened\ndict: {"ip": "203.0.113.9", "count": 24}\nset: known bad IPs for instant lookups\n\nExample:\n  blocklist = {"203.0.113.9", "198.51.100.7"}\n  if ip in blocklist: raise_alert()\n\nSet operations:\n  a - b  items in a not in b\n  a & b  items in both\n  a | b  items in either',
        keyTakeaway:
            'Use sets for fast lookups against allow and block lists, and dictionaries for structured records.',
        codeSnippet:
            'blocklist = {"203.0.113.9", "198.51.100.7"}\nevent = {"ip": "203.0.113.9", "user": "root"}\n\nif event["ip"] in blocklist:\n    print("Blocked source:", event)',
      ),
      ConceptLesson(
        title: 'Working with JSON',
        definition:
            'JSON is a text format for structured data and is the standard of web APIs and many security tools. Python reads it into dictionaries and lists with the json module.',
        analogy:
            'JSON is a standard shipping label format. Every system knows where to find the sender, destination, and contents.',
        example:
            'Example alert:\n\n{\n  "alert_id": 1021,\n  "severity": "high",\n  "source_ip": "203.0.113.9",\n  "tags": ["bruteforce", "ssh"]\n}\n\nPython:\n  json.loads(text)    text to Python\n  json.dumps(obj)     Python to text\n  json.load(file)     read from a file\n\nSafety: parse JSON with the json module only. Never use eval() on data.',
        keyTakeaway:
            'JSON is the language of APIs. Be comfortable reading nested dictionaries and lists.',
        codeSnippet:
            'import json\n\ntext = "{\\"severity\\": \\"high\\", \\"source_ip\\": \\"203.0.113.9\\"}"\nalert = json.loads(text)\nprint(alert["severity"], alert["source_ip"])',
      ),
      ConceptLesson(
        title: 'Reading and Writing CSV',
        definition:
            'CSV files store tables as plain text, one row per line. Python csv module reads rows as lists or dictionaries and writes reports back out.',
        analogy:
            'A CSV is a simple spreadsheet saved as text. Anyone can open it in Excel, and any script can process it.',
        example:
            'Good practice:\n\ncsv.DictReader reads rows as dictionaries using the header\ncsv.DictWriter writes dictionaries as rows\nUse newline="" when opening for writing\n\nUse cases:\n  Asset inventories\n  Exported vulnerability scan results\n  Reports for management\n\nWarning: CSV cells beginning with = + - or @ can run as formulas in a spreadsheet (CSV injection). Sanitise untrusted data before exporting.',
        keyTakeaway:
            'CSV is the common language between scripts and spreadsheets. Sanitise untrusted cells before sharing a file that will be opened in Excel.',
        codeSnippet:
            'import csv\n\nrows = [{"ip": "203.0.113.9", "count": 24}]\nwith open("report.csv", "w", newline="") as f:\n    w = csv.DictWriter(f, fieldnames=["ip", "count"])\n    w.writeheader()\n    w.writerows(rows)',
      ),
      ConceptLesson(
        title: 'Sorting, Filtering, and Comprehensions',
        definition:
            'Python can filter and transform collections in a single readable line using comprehensions, and sort them by any field.',
        analogy:
            'It is like asking a clerk: "From all the files, give me only the high-severity ones, sorted by date" instead of sorting them by hand.',
        example:
            'Patterns:\n\nhigh = [a for a in alerts if a["severity"] == "high"]\nips = {a["source_ip"] for a in alerts}\nranked = sorted(alerts, key=lambda a: a["count"], reverse=True)\n\nCombine them:\n  Filter, count unique sources, and sort by risk to produce a priority list for the analyst.',
        keyTakeaway:
            'Filter first, then sort, then summarise. This three-step pattern turns raw alerts into a prioritised work list.',
        codeSnippet:
            'alerts = [\n    {"ip": "203.0.113.9", "severity": "high", "count": 24},\n    {"ip": "198.51.100.7", "severity": "low", "count": 3},\n]\nhigh = [a for a in alerts if a["severity"] == "high"]\nprint(sorted(high, key=lambda a: a["count"], reverse=True))',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which data structure is best for checking quickly whether an IP is on a blocklist?',
        options: ['List', 'Set', 'String', 'Tuple of numbers'],
        correctIndex: 1,
        explanation:
            'Sets offer very fast membership tests and automatically hold only unique values.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should you never use eval() to parse data received from an API?',
        options: [
          'It is slow',
          'It can execute malicious code hidden in the data',
          'It only works on numbers',
          'It deletes JSON files'
        ],
        correctIndex: 1,
        explanation:
            'eval runs text as code. Use json.loads, which only parses data and does not execute anything.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is CSV injection?',
        options: [
          'Adding more rows to a file',
          'Untrusted cell values starting with characters like = that run as formulas when opened in a spreadsheet',
          'A way to compress CSV files',
          'A Python module'
        ],
        correctIndex: 1,
        explanation:
            'Spreadsheet programs may treat cells starting with = + - or @ as formulas. Sanitise untrusted data before export.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You have two sets: yesterday_ips and today_ips. Which expression gives the IPs seen today that were NOT seen yesterday?',
        options: [
          'today_ips - yesterday_ips',
          'yesterday_ips - today_ips',
          'today_ips & yesterday_ips',
          'today_ips + yesterday_ips'
        ],
        correctIndex: 0,
        explanation:
            'Set difference today minus yesterday leaves only new addresses, which is useful for spotting new sources.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Given alerts as a list of dictionaries, which approach produces the 5 highest-count entries?',
        options: [
          'Sort by the count key in reverse order and take the first 5',
          'Print them in random order',
          'Convert to a set and print',
          'Delete the last 5'
        ],
        correctIndex: 0,
        explanation:
            'sorted(..., key=..., reverse=True)[:5] returns the five largest by the chosen field.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Alert Triage Report Builder',
      goal: 'Load alerts from JSON, prioritise them, and export a CSV report.',
      steps: [
        'Create alerts.json with at least 12 fake alerts: id, severity, source_ip, count, tags',
        'Load the file with the json module and handle missing or bad files gracefully',
        'Filter alerts whose severity is high or critical',
        'Build a set of unique source IPs and compare it against a small blocklist set',
        'Sort the filtered alerts by count in descending order',
        'Write the result to triage.csv and sanitise any cell starting with = + - or @',
      ],
      expectedOutput:
          'Triage Report\n\nLoaded 12 alerts | High or critical: 5\nUnique source IPs: 9 | On blocklist: 2\n\nTop alerts:\n  1021  203.0.113.9   critical  24\n  1033  198.51.100.7  high      11\n\ntriage.csv written (5 rows) ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 5
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l4_bash_scripting',
    topicTitle: 'Bash Scripting for Security Automation',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 200,
    emoji: '📟',
    intro:
        'Bash scripts turn the commands you learned in Level 3 into repeatable, schedulable tools. A short script can audit permissions, check logs, and report results every night while you sleep. It is also easy to write dangerous Bash by accident, so safety habits matter.',
    concepts: [
      ConceptLesson(
        title: 'Your First Script: Shebang, Variables, Arguments',
        definition:
            'A Bash script is a text file of commands. The first line, the shebang, tells the system which interpreter to use. Variables store values, and arguments let you pass input when you run the script.',
        analogy:
            'A script is a written recipe for the shell. Instead of typing each step every time, you run the recipe.',
        example:
            'Basics:\n\n#!/bin/bash        first line\nNAME="analyst"     variable (no spaces around =)\necho "Hello \$NAME"  use a variable\n\$1 \$2             first and second arguments\n\$#                number of arguments\n\nMake it runnable:\n  chmod +x script.sh\n  ./script.sh argument',
        keyTakeaway:
            'Always quote variables as "\$VAR" to avoid breaking on spaces or odd characters, and treat all input as untrusted.',
        codeSnippet: '#!/bin/bash\nLOG="\$1"\necho "Analysing: \$LOG"',
      ),
      ConceptLesson(
        title: 'Conditions, Loops, and Exit Codes',
        definition:
            'Bash supports if statements, for and while loops, and every command returns an exit code: 0 means success and anything else means failure. Scripts use these to decide what to do next.',
        analogy:
            'An exit code is a thumbs up or thumbs down after each task. Zero is thumbs up.',
        example:
            'Patterns:\n\nif [ ! -f "\$LOG" ]; then\n  echo "File not found"\n  exit 1\nfi\n\nfor f in /var/log/*.log; do\n  echo "\$f"\ndone\n\nChecking the last command:\n  echo \$?\n\nCombine commands:\n  cmd1 && cmd2   run cmd2 only if cmd1 succeeded\n  cmd1 || cmd2   run cmd2 only if cmd1 failed',
        keyTakeaway:
            'Check inputs and exit with a non-zero code on failure. This lets schedulers and other tools know something went wrong.',
        codeSnippet:
            '#!/bin/bash\nLOG="\$1"\nif [ ! -f "\$LOG" ]; then\n  echo "File not found: \$LOG"\n  exit 1\nfi\ngrep -c "Failed password" "\$LOG"',
      ),
      ConceptLesson(
        title: 'Safe Scripting Habits',
        definition:
            'Bash is easy to get subtly wrong. A few habits prevent most disasters: strict mode, quoting, avoiding dangerous wildcards, and never running untrusted input as a command.',
        analogy:
            'Working with Bash as root is like handling a chainsaw. With the safety guard on and a steady stance it is a great tool; without them, one slip is serious.',
        example:
            'Safety checklist:\n\nset -euo pipefail    stop on errors, unset variables, and pipe failures\nQuote every variable\nNever use eval on input\nUse full paths for critical commands in scheduled scripts\nTest on copies, never first on production\nKeep secrets out of scripts and command lines\nRun with least privilege, not as root unless required\nShellCheck: a free tool that finds common script bugs',
        keyTakeaway:
            'Start every serious script with strict mode and run ShellCheck on it. Both catch bugs before they cause damage.',
        codeSnippet:
            '#!/bin/bash\nset -euo pipefail\n\nLOG="\${1:?Usage: script.sh logfile}"\ngrep -oE "from [0-9.]+" "\$LOG" | cut -d" " -f2 | sort | uniq -c | sort -nr | head -5',
      ),
      ConceptLesson(
        title: 'Scheduling and Reporting with Cron',
        definition:
            'Cron runs scripts on a schedule. Combined with a script that checks something and writes a report or sends an alert, it gives you simple continuous monitoring.',
        analogy:
            'Cron is an alarm clock for your scripts. Set the time once, and it runs the job every day without you.',
        example:
            'Cron format: minute hour day month weekday command\n\n0 2 * * *   /home/anita/scripts/audit.sh   every day at 02:00\n*/15 * * * * /home/anita/scripts/check.sh every 15 minutes\n\nTips:\n  Edit with crontab -e\n  Use absolute paths\n  Redirect output to a log file\n  Make sure the script is not writable by other users, or it becomes a privilege escalation path\n\nIdeas for scheduled jobs:\n  Nightly check for new SUID files\n  Hourly failed login summary\n  Weekly list of users with sudo rights',
        keyTakeaway:
            'Scheduled scripts run unattended, so protect them: correct ownership, tight permissions, absolute paths, and logged output.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does an exit code of 0 mean in Bash?',
        options: [
          'The command failed',
          'The command succeeded',
          'The file is empty',
          'The script was deleted'
        ],
        correctIndex: 1,
        explanation:
            'By convention 0 means success and any non-zero value signals an error.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why should variables be quoted in Bash, as in "\$FILE"?',
        options: [
          'It makes the script shorter',
          'It prevents breakage and surprises from spaces or special characters in values',
          'It encrypts the variable',
          'It is required for comments'
        ],
        correctIndex: 1,
        explanation:
            'Unquoted variables are split on spaces and expand wildcards, which causes bugs and can be exploited.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A cron script is writable by every user on the server. What is the risk?',
        options: [
          'None, cron ignores permissions',
          'Any user could edit it and gain the privileges of the account that runs it',
          'The script will run slower',
          'Cron will delete it'
        ],
        correctIndex: 1,
        explanation:
            'If a privileged cron job executes a file others can modify, attackers can plant commands that run with higher rights.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'What is the main benefit of putting set -euo pipefail at the top of a script?',
        options: [
          'It stops the script early on errors, undefined variables, and failed pipes instead of continuing silently',
          'It makes the script run twice',
          'It hides the output',
          'It deletes temporary files'
        ],
        correctIndex: 0,
        explanation:
            'Strict mode prevents scripts from carrying on after a failure, which could cause wrong results or damage.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You want a script to run every day at 03:30. Which cron time fields are correct?',
        options: ['30 3 * * *', '3 30 * * *', '* * 3 30 *', '30 * 3 * *'],
        correctIndex: 0,
        explanation:
            'The order is minute, hour, day, month, weekday. Minute 30 and hour 3 gives 03:30 daily.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Nightly Security Audit Script',
      goal:
          'Write a safe Bash script that checks key items on a lab Linux machine and produces a dated report.',
      steps: [
        'Start with a shebang and set -euo pipefail, and accept an output folder as an argument with validation',
        'Check for users with UID 0 other than root',
        'List SUID files and save the list, noting any not seen in the previous report',
        'Count failed SSH logins in the last log file and list the top 3 source IPs',
        'List listening ports with ss and save them to the report',
        'Save everything to a dated report file, run ShellCheck, and schedule it in cron for a lab VM',
      ],
      expectedOutput:
          'audit-2026-01-15.txt\n\nUID 0 accounts: root only ✓\nSUID files: 14 (0 new)\nFailed SSH logins: 120 | Top: 203.0.113.9 (80), 198.51.100.7 (25)\nListening: 22 sshd, 631 cups (review)\n\nShellCheck: no warnings\nCron: 0 2 * * * /opt/audit/audit.sh /var/reports ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 6
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l4_network_python',
    topicTitle: 'Network Programming with Python (Sockets & DNS)',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 34,
    totalXp: 205,
    emoji: '🔌',
    intro:
        'The tools you used in Level 2, such as port checks and DNS lookups, are built from simple Python network calls. Writing small versions yourself teaches how networks really behave. Use these only on your own systems or ones you have written permission to test.',
    concepts: [
      ConceptLesson(
        title: 'Sockets: The Building Block',
        definition:
            'A socket is an endpoint for network communication. Python socket module lets you open TCP or UDP connections, send data, and receive replies.',
        analogy:
            'A socket is a telephone handset. You dial a number (IP and port), speak, listen, and hang up.',
        example:
            'Key ideas:\n\nsocket.AF_INET: IPv4\nsocket.SOCK_STREAM: TCP\nsocket.SOCK_DGRAM: UDP\nconnect(): start a TCP connection\nsettimeout(): never wait forever\n\nAlways:\n  Set timeouts\n  Close sockets (use with)\n  Handle exceptions like timeouts and refused connections',
        keyTakeaway:
            'Every network tool, from scanners to monitoring agents, is built on this pattern: connect, send, receive, close.',
        codeSnippet:
            'import socket\n\ndef check_port(host, port, timeout=1.0):\n    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:\n        s.settimeout(timeout)\n        return s.connect_ex((host, port)) == 0\n\nprint(check_port("127.0.0.1", 22))',
      ),
      ConceptLesson(
        title: 'A Simple Port Checker for Your Own Systems',
        definition:
            'A port checker tries to connect to a list of ports and reports which respond. Defenders use this to confirm firewall rules and spot unexpected services on machines they own.',
        analogy:
            'It is walking round your own building checking which doors are unlocked. You do it to fix problems, and only in your own building.',
        example:
            'Design:\n\nAccept host and port list as arguments\nValidate the host with the ipaddress module\nLoop over ports with a short timeout\nPrint open ports and map them to service names\nSave results with a timestamp\n\nIMPORTANT rules:\n  Only check systems you own or have written permission to test\n  Respect the agreed scope and time window\n  Do not run it against other people networks, even for practice',
        keyTakeaway:
            'Scanning without permission can be illegal. Build the tool, test it on localhost or your own lab VM, and keep records of authorisation.',
        codeSnippet:
            'import socket\n\nCOMMON = {22: "ssh", 80: "http", 443: "https", 3306: "mysql"}\n\nfor port, name in COMMON.items():\n    s = socket.socket()\n    s.settimeout(0.5)\n    if s.connect_ex(("127.0.0.1", port)) == 0:\n        print(f"{port} ({name}): open")\n    s.close()',
      ),
      ConceptLesson(
        title: 'DNS and Address Tools',
        definition:
            'Python can resolve names to IP addresses and validate or compare addresses. The socket module handles lookups, and the ipaddress module understands networks and subnets.',
        analogy:
            'DNS lookup is the phonebook, and the ipaddress module is a calculator that understands phone number structure.',
        example:
            'Useful functions:\n\nsocket.gethostbyname("example.com")      name to IPv4\nsocket.gethostbyaddr("8.8.8.8")          reverse lookup\nipaddress.ip_address("10.0.0.5").is_private\nipaddress.ip_network("192.168.1.0/24")\nip in network                             membership test\n\nUses:\n  Flag connections to unexpected external addresses\n  Check which logged IPs are inside your own ranges\n  Expand a CIDR range into a host list for authorised checks',
        keyTakeaway:
            'The ipaddress module saves you from writing fragile string parsing for IPs and subnets.',
        codeSnippet:
            'import ipaddress\n\nnet = ipaddress.ip_network("192.168.1.0/24")\nip = ipaddress.ip_address("192.168.1.23")\nprint(ip in net, ip.is_private)',
      ),
      ConceptLesson(
        title: 'Concurrency and Responsible Speed',
        definition:
            'Network tasks spend most time waiting. Threads or asynchronous code let you check many hosts or ports at once, which is much faster than doing them one by one.',
        analogy:
            'Instead of one inspector checking 100 doors in sequence, ten inspectors check ten doors each. It finishes faster, but you must make sure they do not overwhelm the building.',
        example:
            'Tools:\n\nconcurrent.futures.ThreadPoolExecutor: simple parallel tasks\nasyncio: advanced asynchronous style\n\nResponsible use:\n  Limit the number of workers (for example 20)\n  Add timeouts and small delays when needed\n  Respect rate limits and avoid disrupting production systems\n  Log what you check and when\n\nSpeed without control can look like an attack and can cause outages.',
        keyTakeaway:
            'Faster is not always better. Throttle your tools so they never cause the harm you are trying to prevent.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why is it important to set a timeout on a socket?',
        options: [
          'To make the program wait forever',
          'So the program does not hang when a host does not respond',
          'To encrypt traffic',
          'To change the port number'
        ],
        correctIndex: 1,
        explanation:
            'Without a timeout, a silent host can freeze your script indefinitely.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'When is it acceptable to run your Python port checker against a network?',
        options: [
          'Any network you can reach',
          'Only systems you own or have explicit written permission to test',
          'Any company network at night',
          'Public websites for practice'
        ],
        correctIndex: 1,
        explanation:
            'Authorisation is mandatory. Unauthorised scanning may break the law and harm others.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which module helps you check whether an IP belongs to a given subnet?',
        options: ['ipaddress', 'random', 'turtle', 'calendar'],
        correctIndex: 0,
        explanation:
            'ipaddress provides ip_address and ip_network objects, so you can write ip in network.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your checker uses 500 threads and floods a small test server so that it crashes. What was the mistake?',
        options: [
          'Too much concurrency with no throttling, which can cause an unintended denial of service',
          'Python is not allowed to use threads',
          'The server was too polite',
          'The timeout was too short'
        ],
        correctIndex: 0,
        explanation:
            'Responsible tools limit workers and rates so they do not harm the systems being checked.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You need to know if the address 10.20.30.40 is inside the range 10.20.0.0/16. Which is the cleanest solution?',
        options: [
          'Compare the strings character by character',
          'Use ipaddress.ip_address(...) in ipaddress.ip_network(...)',
          'Use a random number',
          'Ping it five times'
        ],
        correctIndex: 1,
        explanation:
            'The ipaddress module handles subnet maths correctly and avoids string-parsing mistakes.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Own-System Port and DNS Checker',
      goal:
          'Build a command-line tool that checks ports and resolves names on your own lab systems.',
      steps: [
        'Use argparse to accept a host, a list of ports, and a timeout',
        'Validate the host with the ipaddress module or resolve it with socket.gethostbyname',
        'Check each port with a timeout and print open ports with their service names',
        'Add a ThreadPoolExecutor with a max of 20 workers and measure the speed-up',
        'Save results with a timestamp to a JSON file',
        'Add a clear warning in the script help text: use only on systems you own or are authorised to test',
      ],
      expectedOutput:
          'Port Checker (authorised use only)\n\nTarget: 127.0.0.1 | Timeout: 0.5s | Workers: 20\n\n22 (ssh): open\n80 (http): open\n3306 (mysql): closed\n\nChecked 1024 ports in 3.1s (sequential: 41s)\nResults saved to scan-2026-01-15.json ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 7
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l4_crypto_python',
    topicTitle: 'Hashing, Encryption & Password Tools in Python',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 34,
    totalXp: 205,
    emoji: '🔐',
    intro:
        'In Level 1 you learned the theory of hashing and encryption. Now you will use them in code: verifying file integrity, generating secure random values, storing passwords properly, and encrypting data with a trusted library.',
    concepts: [
      ConceptLesson(
        title: 'File Integrity with hashlib',
        definition:
            'The hashlib module computes cryptographic hashes such as SHA-256. Comparing a stored hash with a fresh one tells you whether a file has changed.',
        analogy:
            'A hash is a tamper-evident seal. If the seal on a package differs from the one recorded at the factory, someone opened it.',
        example:
            'Use cases:\n\nVerify downloaded software against the vendor checksum\nDetect changes in important system files\nDeduplicate files\nBuild a simple file-integrity monitor\n\nTips:\n  Use SHA-256 or better, not MD5 or SHA-1, for security decisions\n  Read big files in chunks\n  Store baseline hashes somewhere an attacker cannot easily edit',
        keyTakeaway:
            'A file-integrity monitor is just stored hashes plus a comparison loop. It is the idea behind tools such as AIDE and Tripwire.',
        codeSnippet:
            'import hashlib\n\ndef sha256_file(path):\n    h = hashlib.sha256()\n    with open(path, "rb") as f:\n        for chunk in iter(lambda: f.read(8192), b""):\n            h.update(chunk)\n    return h.hexdigest()\n\nprint(sha256_file("notes.txt"))',
      ),
      ConceptLesson(
        title: 'Secure Randomness and Safe Comparison',
        definition:
            'For passwords, tokens, and keys you must use a cryptographically secure random source. Python secrets module provides it, while the random module does not. When comparing secrets, use constant-time comparison.',
        analogy:
            'The random module is like a casino dice game: fine for games but predictable enough to be unsafe for locking a vault. secrets is a proper vault lock generator.',
        example:
            'Right tools:\n\nsecrets.token_urlsafe(16)    random URL-safe token\nsecrets.token_hex(16)        random hex string\nsecrets.choice(alphabet)     safe random choice\nhmac.compare_digest(a, b)    constant-time comparison\n\nAvoid for security:\n  random.random(), random.choice()\n  Using the time or a counter as a secret\n  Comparing secrets with == when timing attacks matter',
        keyTakeaway:
            'Use secrets for anything an attacker must not guess. Never use random for passwords, tokens, or keys.',
        codeSnippet:
            'import secrets, hmac\n\ntoken = secrets.token_urlsafe(16)\nprint(token)\nprint(hmac.compare_digest(token, token))',
      ),
      ConceptLesson(
        title: 'Storing Passwords Correctly',
        definition:
            'Passwords must be stored as salted, slow hashes using algorithms designed for the job, such as bcrypt, scrypt, or Argon2. Plain SHA-256 is too fast and is not enough for passwords.',
        analogy:
            'A slow hash makes each guess expensive, like a safe that takes a full second to test each combination. For an attacker trying billions of guesses, that cost adds up enormously.',
        example:
            'Right approach:\n\nUse bcrypt, argon2-cffi, or hashlib.scrypt\nLet the library generate a unique salt\nStore only the resulting hash\nVerify with the library check function\nEnforce a sensible minimum length and rate-limit logins\n\nWrong approaches:\n  Plain MD5 or SHA-1 of the password\n  The same salt for all users\n  Writing your own hashing scheme',
        keyTakeaway:
            'Never invent your own password scheme. Use a proven library and let it handle salts and cost settings.',
        codeSnippet:
            'import bcrypt\n\npw = b"my-long-passphrase"\nhashed = bcrypt.hashpw(pw, bcrypt.gensalt())\n\nprint(bcrypt.checkpw(pw, hashed))\nprint(bcrypt.checkpw(b"wrong", hashed))',
      ),
      ConceptLesson(
        title: 'Encrypting Data with Fernet',
        definition:
            'Fernet, from the cryptography package, provides simple authenticated symmetric encryption. It encrypts and signs data so tampering is detected when decrypting.',
        analogy:
            'Fernet is a locked box with a tamper-proof seal. If anyone changes the contents, the seal breaks and opening fails.',
        example:
            'Workflow:\n\n1. Generate a key once and store it safely, not in the code or in Git\n2. Encrypt data with the key\n3. Store or send the ciphertext\n4. Decrypt with the same key; tampering raises an error\n\nKey management is the hard part:\n  Environment variables, a secrets manager, or a vault\n  Rotate keys periodically\n  Back up keys separately from the data\n\nAvoid implementing encryption algorithms yourself.',
        keyTakeaway:
            'Use high-level, well-reviewed libraries. The strength of your protection depends more on key handling than on the algorithm.',
        codeSnippet:
            'from cryptography.fernet import Fernet\n\nkey = Fernet.generate_key()\nf = Fernet(key)\n\ntoken = f.encrypt(b"secret report")\nprint(f.decrypt(token))',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which Python module should you use to generate a password reset token?',
        options: ['random', 'secrets', 'math', 'time'],
        correctIndex: 1,
        explanation:
            'secrets uses a cryptographically secure source. The random module is predictable and unsuitable for security tokens.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is plain SHA-256 a poor choice for storing passwords?',
        options: [
          'It is too slow',
          'It is very fast, so attackers can test billions of guesses per second; password hashing should be slow and salted',
          'It cannot hash text',
          'It produces long output'
        ],
        correctIndex: 1,
        explanation:
            'Password storage needs deliberately slow, salted algorithms such as bcrypt, scrypt, or Argon2.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Where should an encryption key NOT be stored?',
        options: [
          'In a secrets manager',
          'Hard-coded in source code committed to a public Git repository',
          'In an environment variable on a protected server',
          'In an access-controlled vault'
        ],
        correctIndex: 1,
        explanation:
            'Keys in source control are easily leaked. Use a secrets manager or protected environment configuration.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You want to detect if /etc/passwd changes between nightly checks. What is a simple, reliable approach?',
        options: [
          'Compare file sizes only',
          'Store its SHA-256 hash as a baseline and compare the new hash each night',
          'Open the file in a text editor and look',
          'Ask users if anything changed'
        ],
        correctIndex: 1,
        explanation:
            'Hash comparison detects any change, even a single character, which file size alone can miss.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A developer writes: hashed = hashlib.md5(password.encode()).hexdigest() to store user passwords. What should you recommend?',
        options: [
          'Keep it, MD5 is fine',
          'Replace it with bcrypt or Argon2 with per-user salts, and plan a migration for existing users',
          'Use SHA-1 instead',
          'Store passwords in plain text for speed'
        ],
        correctIndex: 1,
        explanation:
            'MD5 is fast and broken for security use. Use a modern password hashing function and migrate existing hashes at next login.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'File Integrity Monitor and Secure Notes Tool',
      goal:
          'Build a small integrity checker and an encrypted notes helper using the proper libraries.',
      steps: [
        'Write sha256_file and a function that builds a baseline dictionary of file paths to hashes for a lab folder',
        'Save the baseline to baseline.json, then modify one file and run a check that reports changed, new, and missing files',
        'Write a password strength helper that rejects short or common passwords and generates a strong one with secrets',
        'Store a test password with bcrypt and verify correct and wrong attempts',
        'Encrypt and decrypt a text note with Fernet, loading the key from an environment variable rather than the code',
        'Document key handling: where it is stored, who can read it, and how you would rotate it',
      ],
      expectedOutput:
          'Integrity Check\n\nBaseline: 24 files\nChanged: config.ini\nNew: backdoor.txt\nMissing: none\n\nPassword tool: weak passwords rejected, generated 20-char token\nbcrypt: correct = True | wrong = False\nFernet: note encrypted and decrypted; key from NOTES_KEY env var ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 8
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l4_web_api_automation',
    topicTitle: 'Web & API Automation with Python',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 200,
    emoji: '🌐',
    intro:
        'Modern security tools talk to each other through APIs. With a few lines of Python you can pull threat data, enrich alerts, check assets, and push notifications. You must also handle keys, limits, and errors responsibly.',
    concepts: [
      ConceptLesson(
        title: 'HTTP and REST APIs',
        definition:
            'A REST API exposes data and actions over HTTP. You send a request with a method, URL, and optional headers or body, and get back a status code and usually JSON.',
        analogy:
            'An API is a restaurant menu and waiter. You order using the defined options, and the kitchen (the service) returns exactly what you ordered.',
        example:
            'Request parts:\n\nMethod: GET (read), POST (create), PUT or PATCH (update), DELETE (remove)\nURL: https://api.example.com/v1/alerts\nHeaders: authentication and content type\nBody: JSON for POST\n\nStatus code families:\n  2xx success\n  3xx redirect\n  4xx client problem (401 unauthorised, 403 forbidden, 404 not found, 429 too many requests)\n  5xx server problem',
        keyTakeaway:
            'Learn the status codes. 401, 403, and 429 tell you exactly why a call failed and what to fix.',
      ),
      ConceptLesson(
        title: 'The requests Library',
        definition:
            'requests is the standard Python library for HTTP. It sends requests, handles headers and JSON, and exposes the response status and content.',
        analogy:
            'requests is a polite messenger who carries your request to the service and brings back the reply, along with a note about whether it succeeded.',
        example:
            'Good habits:\n\nAlways set a timeout\nCall raise_for_status() to turn bad responses into exceptions\nUse resp.json() to parse JSON\nUse a Session for many calls to the same host\nKeep TLS verification on (never use verify=False in real tools)\nAdd a clear User-Agent for your tool',
        keyTakeaway:
            'No timeout means a call can hang forever, and verify=False silently removes HTTPS protection. Avoid both.',
        codeSnippet:
            'import requests\n\nresp = requests.get("https://api.github.com", timeout=10)\nresp.raise_for_status()\ndata = resp.json()\nprint(resp.status_code, list(data.keys())[:3])',
      ),
      ConceptLesson(
        title: 'API Keys and Secrets',
        definition:
            'API keys and tokens prove who you are. They must be kept out of source code and logs. Environment variables or a secrets manager are the standard places to hold them.',
        analogy:
            'An API key is like a hotel key card. Anyone who finds it can enter your room, so you do not tape it to the door.',
        example:
            'Safe handling:\n\nRead from the environment: os.environ.get("API_KEY")\nKeep a .env file out of Git (add it to .gitignore)\nNever print keys or put them in error messages\nUse least privilege keys (read-only when possible)\nRotate keys and revoke any that leak\nScan repositories for committed secrets (tools such as gitleaks)\n\nIf a key leaks: revoke it immediately, then investigate.',
        keyTakeaway:
            'Treat every key as a password. Leaked keys in public repositories are found and abused by bots within minutes.',
        codeSnippet:
            'import os\nimport requests\n\nkey = os.environ.get("API_KEY")\nif not key:\n    raise SystemExit("Set the API_KEY environment variable")\n\nheaders = {"Authorization": f"Bearer {key}"}\nresp = requests.get("https://api.example.com/v1/alerts", headers=headers, timeout=10)',
      ),
      ConceptLesson(
        title: 'Rate Limits, Retries, and Threat-Intel Enrichment',
        definition:
            'APIs limit how fast you may call them. Well-behaved tools slow down, retry sensibly, and cache results. A common security use is enrichment: looking up an IP or hash in a threat-intelligence service to add context to an alert.',
        analogy:
            'Rate limits are like a library lending desk: you can borrow many books, but not all at once. Coming back politely later works better than shouting at the desk.',
        example:
            'Patterns:\n\nRespect the 429 status and the Retry-After header\nUse exponential backoff: wait 1s, 2s, 4s, then stop\nCache repeated lookups so you do not waste quota\nLog failures without logging secrets\n\nEnrichment flow:\n  Alert has IP 203.0.113.9\n  Tool queries a reputation API\n  Result adds country, reputation score, and tags\n  Analyst sees context and decides faster\n\nCheck each service terms and what data you are allowed to send. Never send confidential internal data to third-party services without approval.',
        keyTakeaway:
            'Be a good API citizen: back off on limits, cache results, and never leak private data to external services.',
        codeSnippet:
            'import time\nimport requests\n\ndef get_with_retry(url, tries=3):\n    for i in range(tries):\n        r = requests.get(url, timeout=10)\n        if r.status_code != 429:\n            r.raise_for_status()\n            return r.json()\n        time.sleep(2 ** i)\n    raise RuntimeError("Rate limited too many times")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which HTTP status code means you are sending too many requests?',
        options: ['200', '404', '429', '500'],
        correctIndex: 2,
        explanation:
            '429 Too Many Requests means you hit a rate limit and should slow down or retry later.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Where should an API key be stored in a Python tool?',
        options: [
          'Hard-coded in the script and pushed to GitHub',
          'In an environment variable or secrets manager, kept out of source control',
          'In a public README',
          'In the URL of every request'
        ],
        correctIndex: 1,
        explanation:
            'Keys must not be in code or repositories. Environment variables and secrets managers keep them separate from the code.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is verify=False in a requests call risky?',
        options: [
          'It makes the call slower',
          'It disables certificate checks, allowing a man-in-the-middle to intercept the connection',
          'It deletes cookies',
          'It changes the HTTP method'
        ],
        correctIndex: 1,
        explanation:
            'Skipping TLS verification removes the identity guarantee of HTTPS and exposes the traffic to interception.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A teammate committed a file containing a live API key to a public repository. What should happen FIRST?',
        options: [
          'Delete the file and hope nobody saw it',
          'Revoke or rotate the key immediately, then clean the repository and investigate any use',
          'Rename the repository',
          'Wait a week'
        ],
        correctIndex: 1,
        explanation:
            'Once a key is public, assume it is compromised. Revocation comes first, followed by clean-up and review of access logs.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your script looks up 5,000 IPs and keeps hitting rate limits. Which change helps most?',
        options: [
          'Remove all timeouts',
          'Cache results, de-duplicate IPs, add backoff, and respect the limit',
          'Open more terminals and run it again',
          'Turn off error handling'
        ],
        correctIndex: 1,
        explanation:
            'Caching and de-duplication cut the number of calls, and backoff keeps you within the service rules.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Alert Enrichment Script',
      goal:
          'Build a script that reads alerts, enriches IPs with a public API, and produces an annotated report.',
      steps: [
        'Pick a free API that needs no private data, such as a public IP geolocation or reputation service, and read its terms',
        'Store the API key (if needed) in an environment variable and never in code',
        'Load a list of IPs from your earlier alerts file and de-duplicate them',
        'Call the API with a timeout, error handling, backoff on 429, and a simple cache dictionary',
        'Merge the enrichment (country, reputation, tags) into each alert and write a JSON report',
        'Add a short README section explaining how keys are handled and what data is sent externally',
      ],
      expectedOutput:
          'Enrichment Run\n\nUnique IPs: 18 | Cache hits: 6 | API calls: 12\nRate limit hits: 1 (retried after 2s)\n\n203.0.113.9  -> country: XX, reputation: malicious, tags: scanner\n198.51.100.7 -> country: YY, reputation: unknown\n\nenriched_alerts.json written ✓\nKey source: ENRICH_API_KEY environment variable ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 9
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l4_secure_coding',
    topicTitle: 'Secure Coding Practices',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 36,
    totalXp: 215,
    emoji: '🧱',
    intro:
        'The tools you write become part of your organisation attack surface. A log parser that trusts its input, or a script that runs shell commands carelessly, can become the very weakness an attacker uses. This lesson teaches how to write code that is hard to abuse.',
    concepts: [
      ConceptLesson(
        title: 'Never Trust Input: Validation and Sanitisation',
        definition:
            'Input validation checks that data matches what you expect before using it. Treat everything from users, files, networks, and APIs as untrusted until validated.',
        analogy:
            'A nightclub bouncer checks every guest at the door instead of assuming everyone is fine. Validation is that bouncer for your code.',
        example:
            'Validation approaches:\n\nAllow-lists: accept only known good values (preferred)\nType and range checks: is it an integer between 1 and 65535?\nLength limits\nFormat checks with strict patterns\nUse standard libraries: ipaddress, pathlib, urllib.parse\n\nExamples:\n  Port must be an integer from 1 to 65535\n  Hostname must match a safe pattern or valid IP\n  Filename must stay inside the intended folder (block ../)',
        keyTakeaway:
            'Allow-lists beat block-lists. Define what is valid, and reject everything else.',
        codeSnippet:
            'import ipaddress\n\ndef parse_port(text):\n    port = int(text)\n    if not 1 <= port <= 65535:\n        raise ValueError("port out of range")\n    return port\n\nip = ipaddress.ip_address("203.0.113.9")',
      ),
      ConceptLesson(
        title: 'Injection: SQL and Command Injection',
        definition:
            'Injection happens when untrusted input is mixed into a command or query so that it is interpreted as code. SQL injection targets databases, and command injection targets the operating system shell.',
        analogy:
            'Imagine a form letter where the clerk copies your entered name straight into an instruction line. If you write "Anita; also give me the keys", the clerk may follow it. Safe code keeps data and instructions separate.',
        example:
            'SQL injection:\n  Bad: building a query by joining strings with user input\n  Good: parameterised queries with placeholders\n\nCommand injection:\n  Bad: os.system("ping " + host) or subprocess with shell=True and joined input\n  Good: subprocess.run(["ping", "-c", "1", host], check=True) with a validated host\n\nOther dangerous calls with untrusted input:\n  eval(), exec(), pickle.loads(), yaml.load() without safe loader',
        keyTakeaway:
            'Keep data separate from code: parameterised queries for databases, argument lists for processes, and no eval on external data.',
        codeSnippet:
            'import sqlite3, subprocess\n\nconn = sqlite3.connect("users.db")\nname = "anita"\nrows = conn.execute("SELECT * FROM users WHERE name = ?", (name,)).fetchall()\n\nsubprocess.run(["ping", "-c", "1", "127.0.0.1"], check=True)',
      ),
      ConceptLesson(
        title: 'Secrets, Logging, and Error Handling',
        definition:
            'Secure code protects secrets, logs useful but safe information, and fails without revealing internals. Passwords, tokens, and personal data must never appear in logs or error messages.',
        analogy:
            'A bank teller can tell you "that transaction failed", but should not read out the vault combination when explaining why.',
        example:
            'Good practice:\n\nUse the logging module with levels (INFO, WARNING, ERROR)\nNever log passwords, tokens, full card numbers, or personal data\nShow users a generic error and log details privately\nKeep secrets in environment variables or a vault, not in code\nAdd .env and key files to .gitignore\nUse a pre-commit secret scanner\n\nFail closed: if a security check cannot run, deny access rather than allow it.',
        keyTakeaway:
            'Log enough to investigate, but never enough to help an attacker. Fail closed, not open.',
        codeSnippet:
            'import logging\n\nlogging.basicConfig(level=logging.INFO)\nlog = logging.getLogger("tool")\n\nlog.info("Login failed for user %s", "anita")\n# never: log.info("password was %s", password)',
      ),
      ConceptLesson(
        title: 'Dependencies, Static Analysis, and Code Review',
        definition:
            'Your tool relies on third-party packages that may contain vulnerabilities. Scanning dependencies, running static analysers, and reviewing code catch problems before attackers do.',
        analogy:
            'Building a house with ready-made parts means you inherit any hidden defects in them. Inspect the parts and the finished house.',
        example:
            'Practical tools:\n\npip-audit: checks installed packages for known vulnerabilities\nBandit: static analysis for common Python security issues\nShellCheck: for Bash scripts\ngitleaks: finds committed secrets\nDependabot or similar: automatic update suggestions\n\nGood habits:\n  Pin versions in requirements.txt\n  Keep dependencies few and updated\n  Peer review every change, especially security-sensitive code\n  Follow OWASP guidance and the OWASP Top 10',
        keyTakeaway:
            'Automate scanning in your workflow so every change is checked, and pair it with human code review.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which is the safest way to include user input in a database query?',
        options: [
          'Join the string directly into the SQL text',
          'Use a parameterised query with placeholders',
          'Remove all spaces from the input',
          'Convert it to uppercase'
        ],
        correctIndex: 1,
        explanation:
            'Parameterised queries keep data separate from SQL code, which prevents SQL injection.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is subprocess.run(command_string, shell=True) with user input dangerous?',
        options: [
          'It is slower',
          'The shell can interpret special characters in the input and run extra commands',
          'It cannot run Python',
          'It uses too much memory'
        ],
        correctIndex: 1,
        explanation:
            'With a shell, input like a semicolon followed by another command can execute attacker commands. Use an argument list and validate input.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which is a safer approach to validating a filename supplied by a user?',
        options: [
          'Trust it',
          'Resolve the path and confirm it stays inside the intended folder, and use an allow-list of names where possible',
          'Check that it contains a dot',
          'Convert it to lowercase'
        ],
        correctIndex: 1,
        explanation:
            'Path traversal uses sequences like ../ to escape the intended folder. Resolve and verify the final path.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your tool uses pickle.loads() to read data from a file uploaded by users. What is the main risk?',
        options: [
          'Pickle is too slow',
          'Unpickling untrusted data can execute arbitrary code, so use a safe format such as JSON',
          'Pickle files are too large',
          'There is no risk'
        ],
        correctIndex: 1,
        explanation:
            'pickle can run code during loading. Use data-only formats like JSON for untrusted input.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A login function throws a detailed error showing the full SQL query and database name to the user. What is the problem?',
        options: [
          'The message is too short',
          'It leaks internal details that help attackers, so show a generic message and log details privately',
          'Errors should never be logged',
          'It improves security'
        ],
        correctIndex: 1,
        explanation:
            'Detailed errors reveal structure that helps attackers. Show users a generic failure and record details only in protected logs.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Secure Code Review and Fix',
      goal:
          'Review a deliberately flawed script, find the vulnerabilities, and fix them.',
      steps: [
        'Write or obtain a small flawed lab script with 5 problems: SQL built from strings, shell=True with input, hard-coded API key, verify=False, and logging a password',
        'Run Bandit and pip-audit on it and record every finding',
        'Fix each problem: parameterised query, argument list with validated host, key from an environment variable, TLS verification on, and safe logging',
        'Add input validation using ipaddress and range checks for ports',
        'Re-run the scanners and confirm the findings are resolved',
        'Write a short before and after review note listing each flaw, its risk, and the fix',
      ],
      expectedOutput:
          'Secure Review\n\nBandit findings before: 6 | after: 0\npip-audit: 1 vulnerable dependency -> upgraded\n\nFixes:\n  SQL string building -> parameterised query ✓\n  shell=True -> argument list + validated IP ✓\n  Hard-coded key -> environment variable ✓\n  verify=False -> removed ✓\n  Password in log -> removed ✓\n\nReview note written ✓',
      xpReward: 60,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 10
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l4_automation_capstone',
    topicTitle: 'Automation Capstone: Build a Log Monitoring & Alert Tool',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 45,
    totalXp: 240,
    emoji: '🏆',
    intro:
        'This is your Level 4 capstone. You will combine everything so far into one professional-quality tool: a command-line log monitor that detects suspicious activity, enriches it, and raises alerts. You will also learn how to structure, test, schedule, and document a tool so others can trust and use it.',
    concepts: [
      ConceptLesson(
        title: 'Structuring a Real Tool',
        definition:
            'A professional tool has a clear structure: a command-line interface, separate modules for parsing, detection, and output, configuration kept outside the code, and sensible logging.',
        analogy:
            'A well-run kitchen has stations: prep, cooking, plating. A well-built tool has the same separation, so each part can be improved or fixed without breaking the rest.',
        example:
            'Suggested layout:\n\nlogwatch/\n  logwatch/\n    __init__.py\n    parser.py      read and parse lines\n    detectors.py   detection rules\n    alerts.py      output: console, file, email or webhook\n    cli.py         argparse interface\n  tests/\n    test_parser.py\n    test_detectors.py\n  config.example.json\n  requirements.txt\n  README.md\n\nUse argparse for options such as --log, --threshold, and --output.',
        keyTakeaway:
            'Separating parsing, detection, and alerting makes the tool testable and lets you add new rules without rewriting everything.',
      ),
      ConceptLesson(
        title: 'Detection Rules and Thresholds',
        definition:
            'A detection rule describes suspicious behaviour in measurable terms, such as a number of events within a time window. Thresholds must balance catching real attacks against creating too many false alarms.',
        analogy:
            'A smoke alarm that triggers on toast is ignored, and one that never triggers is useless. Good thresholds sit between the two.',
        example:
            'Example rules:\n\nBrute force: 10 or more failed logins from one IP within 5 minutes\nSuccess after failures: an Accepted login right after repeated failures from the same IP\nNew privileged user: a user added to sudo\nOdd hour login: login for a normal user between midnight and 5 a.m.\nBlocklist hit: any event from a known bad IP\n\nTuning:\n  Start with sample data\n  Record false positives and adjust\n  Make thresholds configurable',
        keyTakeaway:
            'Make every threshold configurable and document why each rule exists. Tuning never ends.',
        codeSnippet:
            'from collections import defaultdict\n\nfailures = defaultdict(int)\nTHRESHOLD = 10\n\ndef check_event(ip, success):\n    if success:\n        return None\n    failures[ip] += 1\n    if failures[ip] == THRESHOLD:\n        return f"ALERT: {ip} reached {THRESHOLD} failed logins"\n    return None',
      ),
      ConceptLesson(
        title: 'Testing Your Tool with pytest',
        definition:
            'Automated tests prove your code does what you expect and keep working as you change it. In security tools, a bug can mean a missed attack, so tests are especially valuable.',
        analogy:
            'Tests are a pre-flight checklist. You run the same checks every time, so changes cannot silently break something critical.',
        example:
            'What to test:\n\nParser: handles normal lines, odd lines, and empty lines\nDetectors: triggers exactly at the threshold, not before\nValidation: rejects bad IPs and bad ports\nOutput: alerts contain no secrets\n\nTools:\n  pytest to run tests\n  Sample log files in a tests folder\n  Coverage reports to find untested code\n\nTip: write a test for every bug you fix so it never returns.',
        keyTakeaway:
            'If a detection rule has no test, you do not know it works. Test the boundaries: just below, at, and above the threshold.',
        codeSnippet:
            'def risk_level(attempts):\n    if attempts >= 10:\n        return "high"\n    if attempts >= 5:\n        return "medium"\n    return "low"\n\ndef test_risk_levels():\n    assert risk_level(4) == "low"\n    assert risk_level(5) == "medium"\n    assert risk_level(10) == "high"',
      ),
      ConceptLesson(
        title: 'Delivery: Git, Scheduling, Alerts, and Documentation',
        definition:
            'A finished tool is version-controlled, scheduled, documented, and safe to operate. Others should be able to install and run it, and understand what it does and does not do.',
        analogy:
            'A product is not finished when it works on your laptop. It is finished when someone else can set it up from the instructions and trust the results.',
        example:
            'Delivery checklist:\n\nGit: meaningful commits, a .gitignore that excludes secrets and logs\nREADME: purpose, install steps, usage examples, limits, and a safety note\nConfiguration: example file without real secrets\nScheduling: cron or systemd timer for regular runs\nAlerting: console, file, email, or a chat webhook with the URL kept as a secret\nLogging: tool activity logged separately from alerts\nRun as a low-privilege user with read-only access to logs\nCI: run tests and scanners automatically on every push\n\nPortfolio tip: a clean GitHub repository of this tool is strong evidence in interviews.',
        keyTakeaway:
            'Documentation and tests turn a script into a tool. Employers look for exactly that difference.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why should detection thresholds be configurable?',
        options: [
          'So the tool looks more complicated',
          'Because different environments have different normal behaviour, and rules need tuning to balance false positives and misses',
          'To make the code longer',
          'Because Python requires it'
        ],
        correctIndex: 1,
        explanation:
            'A threshold that suits one organisation may flood another with false alarms or miss attacks. Configurable values allow tuning.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which test case best checks the boundary of a rule that alerts at 10 failed logins?',
        options: [
          'Only test with 1000 failures',
          'Test with 9, 10, and 11 failures',
          'Only test with 0 failures',
          'Do not test, the rule looks fine'
        ],
        correctIndex: 1,
        explanation:
            'Boundary testing around the threshold catches off-by-one errors that would cause missed or premature alerts.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What should your .gitignore for a security tool always exclude?',
        options: [
          'The README',
          'Secrets such as .env files and keys, plus real log files and virtual environments',
          'The source code',
          'The tests'
        ],
        correctIndex: 1,
        explanation:
            'Secrets and sensitive logs must never be committed. Virtual environments and caches only add clutter.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your monitor sends 200 alerts a day and analysts start ignoring them. What is the best response?',
        options: [
          'Turn off the monitor',
          'Tune thresholds using real data, group related alerts, and raise severity only for high-confidence patterns',
          'Send even more alerts',
          'Delete the logs'
        ],
        correctIndex: 1,
        explanation:
            'Alert fatigue hides genuine incidents. Tuning, grouping, and prioritising keep alerts meaningful.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your tool sends alerts to a chat webhook. Where should the webhook URL be kept?',
        options: [
          'In the source code on GitHub',
          'In an environment variable or secrets manager, with an example config that holds no real value',
          'In the alert message itself',
          'In the README'
        ],
        correctIndex: 1,
        explanation:
            'A webhook URL works like a password. Keep it outside the code and out of version control.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Level 4 Capstone: LogWatch — Log Monitoring & Alert Tool',
      goal:
          'Build, test, and document a command-line log monitor that detects suspicious activity and raises alerts.',
      steps: [
        'Create the project structure with separate parser, detectors, alerts, and CLI modules, and a Git repository with a proper .gitignore',
        'Use argparse to accept a log file, thresholds, an output path, and an optional blocklist file',
        'Implement 4 detection rules: brute force by IP, success after failures, new sudo user, and blocklist hit',
        'Validate all IPs with the ipaddress module and handle missing or malformed lines safely',
        'Write at least 8 pytest tests, including boundary tests for each threshold, and a sample log file in tests',
        'Add alert output to the console and a JSON report, optionally to a webhook read from an environment variable',
        'Run Bandit, ShellCheck (if you included a wrapper), and pip-audit, then write a README with install steps, usage, limits, and a safety note',
        'Schedule it in cron on a lab VM and capture one real alert from a simulated attack on your own lab system',
      ],
      expectedOutput:
          'LogWatch v0.1\n\nusage: logwatch --log auth.log --threshold 10 --blocklist bad_ips.txt --out report.json\n\nRun summary:\n  Lines parsed: 5,420 | Malformed skipped: 3\n  ALERT brute_force: 203.0.113.9 (24 failures in 5 min)\n  ALERT success_after_failures: 203.0.113.9 logged in as admin\n  ALERT new_sudo_user: backup2 added to sudo\n  ALERT blocklist_hit: 198.51.100.7\n\nTests: 9 passed | Bandit: 0 issues | pip-audit: clean\nGitHub repo with README ✓ | Cron: */15 * * * * ✓',
      xpReward: 85,
    ),
  ),
];
