import '../../models/course_content_data.dart';

const List<TopicCourse> dataScientistLevel2 = [
  TopicCourse(
    id: 'python_fundamentals_ds2',
    topicTitle: 'Python Fundamentals for Data Science',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 30,
    totalXp: 130,
    emoji: '🐍',
    intro:
        'Python is the language of data science. It is readable, powerful, and backed by the largest data science ecosystem in the world. Before diving into analysis and modeling, you need a solid grip on how Python thinks and works. This lesson builds your Python mental model from the ground up — the right foundation for everything that follows.',
    concepts: [
      ConceptLesson(
        title: 'Why Python for Data Science?',
        definition:
            'Python dominates data science because it combines the readability of plain English with a massive ecosystem of specialized libraries — NumPy, Pandas, scikit-learn, TensorFlow — that solve the hardest data problems with a few lines of code.',
        analogy:
            'Python for data science is like choosing English as your working language for international research — it is not always the most technically precise language for every niche, but it is spoken by the most people, has the most resources, and connects you to the largest community of practitioners and tools worldwide.',
        example:
            'Sorting 10 million customer records by purchase value in Python takes two lines. Loading a CSV, filtering rows by condition, and computing group statistics takes five lines with Pandas. What would require hundreds of lines in C or Java is readable, maintainable, and fast enough for most real-world data tasks in Python.',
        keyTakeaway:
            'Python\'s most important quality for data science is not speed — it is productivity. The ability to explore, prototype, visualize, and iterate rapidly on a dataset is worth far more than raw execution speed for most data science workflows. Learn Python deeply and you unlock the entire modern data science ecosystem.',
        codeSnippet:
            '# Python is readable and expressive\nnumbers = [3, 1, 4, 1, 5, 9, 2, 6]\nsorted_numbers = sorted(numbers)\nprint(sorted_numbers)   # [1, 1, 2, 3, 4, 5, 6, 9]\n\n# One-liner to filter and transform\neven_squares = [x**2 for x in numbers if x % 2 == 0]\nprint(even_squares)     # [16, 4, 36]',
      ),
      ConceptLesson(
        title: 'Setting Up Your Python Environment',
        definition:
            'A Python data science environment needs three things: Python itself, a package manager (pip or conda) for installing libraries, and a development environment. Google Colab provides all three in a browser with zero setup — the fastest way for beginners to start writing data science code.',
        analogy:
            'Setting up a Python environment is like equipping a workshop. Python is the workshop itself. pip/conda is the hardware store where you get additional tools (libraries). Jupyter or Colab is the workbench where you do your actual work — neatly organized so your experiments, tools, and results are all visible in one place.',
        example:
            'Three ways to run Python for data science: 1) Google Colab (colab.research.google.com) — free, no installation, GPU access, perfect for beginners. 2) Anaconda — installs Python + Jupyter + all core data science libraries in one package. 3) VS Code + Python extension — professional development environment for larger projects.',
        keyTakeaway:
            'Start with Google Colab. The zero-setup environment means you write code in your first session rather than spending a day debugging installation issues. When you outgrow Colab\'s limitations (larger datasets, custom environments, production workflows), migrate to a local Jupyter or VS Code setup.',
        codeSnippet:
            '# Verify your Python data science environment is working\nimport sys\nprint(f"Python version: {sys.version}")\n\n# Check core libraries are installed\nimport numpy as np\nimport pandas as pd\nimport matplotlib.pyplot as plt\n\nprint(f"NumPy: {np.__version__}")\nprint(f"Pandas: {pd.__version__}")\nprint("Environment ready for data science!")',
      ),
      ConceptLesson(
        title: 'Python Syntax: Indentation, Comments and Print',
        definition:
            'Python uses indentation (spaces or tabs) to define code blocks — unlike other languages that use curly braces. Proper indentation is not optional; it is syntactically required. Comments (lines starting with #) explain code to humans without affecting execution.',
        analogy:
            'Python\'s indentation requirement is like paragraph formatting in writing — proper indentation is what makes nested structures (like loops inside loops, or code inside functions) readable and unambiguous. Just as a text with no paragraph breaks would be confusing, code with inconsistent indentation is both visually confusing and syntactically broken in Python.',
        example:
            'In Python, 4 spaces of indentation per level is the universal convention. A function body is indented. An if block inside the function is indented again. Each print statement at different levels tells Python which block it belongs to — mixing up indentation causes IndentationError, the most common beginner Python error.',
        keyTakeaway:
            'Use exactly 4 spaces for each indentation level — never mix spaces and tabs. Most modern text editors and Jupyter automatically handle this when you press Tab. The first IndentationError you encounter is confusing; once you understand that indentation IS the block structure, Python\'s syntax becomes remarkably readable.',
        codeSnippet:
            '# Python syntax demonstration\n# Comments explain code - Python ignores them\n\ndef analyze_sales(revenue, target):\n    """Docstring explains what the function does"""\n    if revenue >= target:\n        performance = "Achieved"    # 4 spaces indent inside if\n        bonus = revenue * 0.05\n    else:\n        performance = "Below target"\n        bonus = 0.0\n    \n    # This line is inside the function but not inside if/else\n    print(f"Performance: {performance}")\n    print(f"Bonus: ₹{bonus:,.2f}")\n    return bonus\n\n# Call the function (no indent - outside function)\nresult = analyze_sales(125000, 100000)\nprint(f"Returned: {result}")',
      ),
      ConceptLesson(
        title: 'Python Data Collections: Lists, Tuples, Dictionaries and Sets',
        definition:
            'Python\'s built-in collection types are the workhorses of data handling: lists (ordered, mutable sequences), tuples (ordered, immutable sequences), dictionaries (key-value mappings), and sets (unordered collections of unique values).',
        analogy:
            'Python collections are like different types of containers: a list is an ordered numbered shelf where you can add and remove items. A tuple is a sealed numbered box — the contents are fixed. A dictionary is a labeled filing cabinet where each folder has a specific name. A set is a bag of unique items — no duplicates allowed.',
        example:
            'In data science, these collections appear constantly: a list stores a column of values. A tuple stores an immutable dataset record. A dictionary stores a data schema or configuration. A set performs fast membership testing or deduplication. Understanding when to use each — and their time complexity characteristics — is fundamental to writing efficient data processing code.',
        keyTakeaway:
            'Dictionary lookups are O(1) — near-instant regardless of size. List lookups by index are O(1) too, but searching by value is O(n). Set membership tests are O(1). These performance characteristics matter enormously when processing millions of records. Choose the right collection for the operation you need.',
        codeSnippet:
            '# Python collections for data science\nscores = [85, 92, 78, 95, 88]     # list - ordered, mutable\ncoordinates = (28.6, 77.2)         # tuple - immutable lat/lon\n\nstudent = {                        # dictionary - key:value\n    "name": "Priya",\n    "age": 23,\n    "city": "Mumbai",\n    "grade": "A"\n}\n\ncities_visited = {"Delhi", "Mumbai", "Pune", "Mumbai"}  # set - unique\nprint(cities_visited)   # {\'Delhi\', \'Mumbai\', \'Pune\'} - duplicate removed\n\n# Useful operations\nprint(scores[2])             # 78 - list indexing\nprint(student["name"])       # Priya - dict access\nprint("Delhi" in cities_visited)  # True - set membership O(1)',
      ),
      ConceptLesson(
        title: 'List Comprehensions: Pythonic Data Transformation',
        definition:
            'List comprehensions are a concise, readable Python syntax for creating new lists by transforming or filtering existing sequences — they replace multi-line for loops with a single expressive line and are faster than equivalent explicit loops.',
        analogy:
            'A list comprehension is like a conveyor belt factory: you describe the transformation (convert raw material to finished product) and the filter (only process items meeting a condition) in one instruction, and the factory applies it to every item automatically. It is more efficient and readable than individually inspecting and processing each item by hand.',
        example:
            'Data transformation with list comprehensions is ubiquitous in data science preprocessing: converting a column of strings to lowercase, filtering records meeting a condition, transforming units (Celsius to Fahrenheit for all temperature readings), or extracting specific fields from a list of dictionaries — all done concisely without explicit for loops.',
        keyTakeaway:
            'List comprehensions are the most distinctly "Pythonic" construct — using them correctly signals that you think in Python rather than translating from another language. Master the basic form [expression for item in iterable if condition] and you will write cleaner, more efficient data processing code immediately.',
        codeSnippet:
            '# List comprehensions in data science contexts\ntemperatures_c = [22.5, 35.1, 18.3, 40.2, 28.7]\n\n# Convert Celsius to Fahrenheit\ntemperatures_f = [round(c * 9/5 + 32, 1) for c in temperatures_c]\nprint(temperatures_f)   # [72.5, 95.2, 64.9, 104.4, 83.7]\n\n# Filter: keep only high temperatures\nheatwave_days = [c for c in temperatures_c if c >= 35]\nprint(heatwave_days)    # [35.1, 40.2]\n\n# Transform and filter together\ncustomer_data = [\n    {"name": "Rahul", "spend": 4500},\n    {"name": "Priya", "spend": 850},\n    {"name": "Amit", "spend": 12000}\n]\nhigh_value = [c["name"] for c in customer_data if c["spend"] > 1000]\nprint(high_value)       # [\'Rahul\', \'Amit\']',
      ),
      ConceptLesson(
        title: 'String Operations for Data Science',
        definition:
            'Data scientists work with text constantly — cleaning customer names, parsing log files, standardizing category labels, extracting information from messy text fields. Python\'s string methods and f-strings are essential tools for this work.',
        analogy:
            'String operations in data science are like editing tools for text data. Just as a document editor has find-and-replace, spell-check, and formatting tools, Python\'s string methods let you clean, standardize, extract, and format text data programmatically — applying the same transformations to millions of records in seconds.',
        example:
            'Real data cleaning with strings: a dataset of customer city entries contains "  Mumbai ", "MUMBAI", "mumbai ", "Mumbai". Four strings representing the same city. Applying .strip().title() standardizes all four to "Mumbai" — a simple two-method chain that would require manual review of millions of records otherwise. String standardization before analysis prevents the same category from appearing as multiple separate groups.',
        keyTakeaway:
            'The most used string methods in data science are: .strip() (remove whitespace), .lower()/.upper()/.title() (case standardization), .split() (parse text into components), .replace() (substitute characters), .contains() via Pandas (search for substrings in data columns). These six methods solve 80% of text cleaning problems.',
        codeSnippet:
            '# String operations for data cleaning\nraw_entries = ["  Mumbai ", "MUMBAI", "mumbai ", "New Delhi", "new delhi"]\n\n# Standardize: strip whitespace and title case\ncleaned = [city.strip().title() for city in raw_entries]\nprint(cleaned)   # [\'Mumbai\', \'Mumbai\', \'Mumbai\', \'New Delhi\', \'New Delhi\']\nprint(set(cleaned))  # {\'Mumbai\', \'New Delhi\'} - correct unique cities\n\n# F-strings for readable output\nname = "Priya Sharma"\nsales = 125000\ntarget = 100000\nachievement = (sales / target) * 100\n\nreport = f"Sales Rep: {name} | Revenue: ₹{sales:,} | Achievement: {achievement:.1f}%"\nprint(report)   # Sales Rep: Priya Sharma | Revenue: ₹1,25,000 | Achievement: 125.0%',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What makes Python\'s indentation different from most other programming languages, and why does it matter?',
        options: [
          'Python indentation is purely aesthetic — it has no effect on code execution',
          'Python uses indentation to define code blocks (replacing curly braces) — incorrect indentation causes syntax errors, not just poor readability',
          'Python indentation slows down execution compared to curly-brace languages',
          'Python only requires indentation inside functions, not for if/else blocks'
        ],
        correctIndex: 1,
        explanation:
            'Python uses indentation as the actual syntax for defining code blocks. An IndentationError means your code will not run at all — not just look messy. This enforces readable code structure as a language requirement, making Python code remarkably consistent across developers.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'You have a list of 1 million customer IDs and need to check whether a specific ID exists. Which Python collection type makes this check FASTEST?',
        options: [
          'A list — because list indexing is O(1)',
          'A set — because set membership testing is O(1) regardless of size, vs O(n) for list search',
          'A tuple — because tuples use less memory than lists',
          'A dictionary — because dictionary access is always the fastest operation'
        ],
        correctIndex: 1,
        explanation:
            'Set membership testing ("id in my_set") is O(1) — constant time regardless of set size — because sets use hash tables. List membership testing ("id in my_list") is O(n) — it scans every element. For 1 million records, a set check takes the same time as a 10-element set check; a list check could scan all 1 million entries.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which of the following correctly creates a list of squares for all even numbers from 1 to 10 using a list comprehension?',
        options: [
          '[x**2 for x in range(1, 11)]',
          '[x**2 for x in range(1, 11) if x % 2 == 0]',
          '[x**2 if x % 2 == 0 for x in range(1, 11)]',
          'for x in range(1, 11): if x % 2 == 0: x**2'
        ],
        correctIndex: 1,
        explanation:
            'The correct list comprehension syntax is [expression for item in iterable if condition]. The condition filter comes after the for clause. Option A produces squares of ALL numbers 1-10. Option C has incorrect syntax order. Option D is a regular loop, not a comprehension.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You have a list of product names: ["  Apple iPhone  ", "SAMSUNG GALAXY", "oneplus nord ", "  IPHONE "]. Write a list comprehension that returns a deduplicated list of cleaned product names (stripped of whitespace, title case), using a set for deduplication.',
        options: [
          'list([name for name in products])',
          'list(set([name.strip().title() for name in products]))',
          '[name.lower() for name in products if name != ""]',
          'set(products.strip().title())'
        ],
        correctIndex: 1,
        explanation:
            'First apply .strip().title() to each name in a list comprehension (cleaning), then wrap in set() to deduplicate, then wrap in list() to convert back to a list. This gives ["Apple Iphone", "Iphone", "Oneplus Nord", "Samsung Galaxy"] — wait, actually "Apple iPhone" and "IPHONE" become "Apple Iphone" and "Iphone" — two different things. The set correctly identifies them as different after cleaning.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A data file has sales records as strings: ["2024-01-15,Electronics,4500", "2024-01-16,Clothing,1200", "2024-01-17,Electronics,7800"]. Which code correctly extracts all Electronics sales amounts as a list of integers?',
        options: [
          '[record for record in records if "Electronics" in record]',
          '[int(record.split(",")[2]) for record in records if record.split(",")[1] == "Electronics"]',
          '[record.split(",")[2] for record in records]',
          'records.filter("Electronics")'
        ],
        correctIndex: 1,
        explanation:
            'Split each record by comma to get [date, category, amount]. Filter for category == "Electronics" with the if clause. Extract amount at index [2] and convert to int. This produces [4500, 7800] — the correct Electronics sales amounts as integers.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Python Data Processing Toolkit',
      goal:
          'Build a Python data processing toolkit using only built-in Python (no libraries yet) that cleans, analyzes, and summarizes a simulated dataset.',
      steps: [
        'Create a list of 10 student dictionaries, each with: name (messy case/whitespace), scores (list of 3 exam scores), city, and grade.',
        'Write a function clean_student(student) that returns a new dictionary with: name stripped and title-cased, average score calculated, city cleaned, and grade assigned based on average (A: ≥90, B: ≥75, C: ≥60, F: below 60).',
        'Apply the clean function to all 10 students using a list comprehension.',
        'Write a function city_summary(students) that returns a dictionary of {city: average_score} for all students using loops and dictionary operations.',
        'Print a formatted report showing each student\'s name, average score, and grade using f-strings.',
      ],
      expectedOutput:
          'Clean student list with correctly computed averages and grades. City summary dictionary. Formatted report printed with all students. All logic uses only built-in Python — no NumPy or Pandas.',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'variables_datatypes_operators_ds2',
    topicTitle: 'Variables, Data Types & Operators',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🔢',
    intro:
        'Every piece of data in a Python program lives in a variable with a specific type. Understanding Python\'s type system and operators is not just syntax knowledge — it directly affects how your data behaves during analysis, what operations are valid, and what errors you will encounter when processing real datasets.',
    concepts: [
      ConceptLesson(
        title: 'Python Variables and Dynamic Typing',
        definition:
            'Python variables are labels that point to objects in memory — Python is dynamically typed, meaning the same variable can hold an integer, then a string, then a list without explicit declaration. The type is attached to the value, not the variable name.',
        analogy:
            'Python variables are like labeled sticky notes that can be moved to attach to any object. The note "x" can be stuck to the number 42 right now, then moved to stick to the string "hello" in the next line. The note itself has no type — the object it points to does. This flexibility is convenient for interactive data exploration but requires awareness to avoid accidental type mismatches.',
        example:
            'In data analysis, dynamic typing becomes a risk when you expect a column to contain numbers but it contains strings (because someone entered "N/A" in a field meant for integers). Python will not warn you until you try to do arithmetic on those values. Understanding types helps you anticipate and handle these real data quality issues.',
        keyTakeaway:
            'Always verify the types of your variables when working with real data using type() or, in Pandas, df.dtypes. The most common data science errors — "TypeError: unsupported operand type" and "ValueError: could not convert string to float" — come from type mismatches that explicit type checking prevents.',
        codeSnippet:
            '# Python dynamic typing\nx = 42\nprint(type(x))      # <class \'int\'>\n\nx = "Forty-two"\nprint(type(x))      # <class \'str\'> - same variable, different type\n\nx = [1, 2, 3]\nprint(type(x))      # <class \'list\'>\n\n# Type checking - critical in data science\nrevenue = "125,000"   # loaded from CSV as string!\nprint(type(revenue))  # <class \'str\'> - NOT a number yet\n\n# Convert before calculating\nrevenue_clean = float(revenue.replace(",", ""))\nprint(revenue_clean + 5000)  # 130000.0 - works now',
      ),
      ConceptLesson(
        title: 'Numeric Types: int, float and complex',
        definition:
            'Python has three numeric types: int (whole numbers, arbitrary precision), float (decimal numbers, 64-bit by default), and complex (real + imaginary, rarely used in data science). Arithmetic operations between int and float always return float.',
        analogy:
            'Python numeric types are like different precision measuring tools. An int is a whole number counter — perfect for counting items (3 customers, 47 transactions). A float is a precise measuring device — suitable for continuous measurements (₹1,245.67 revenue, 36.8°C temperature, 23.7% growth rate). Mixing them in calculations automatically promotes to float.',
        example:
            'Float precision surprises every beginner: 0.1 + 0.2 == 0.3 is False in Python (and every language using IEEE 754 floating point). The actual result is 0.30000000000000004. In financial data science, this matters — always use round() for monetary comparisons or use Python\'s decimal module for exact decimal arithmetic.',
        keyTakeaway:
            'Float imprecision is not a Python bug — it is a fundamental property of how computers represent decimal numbers in binary. For financial calculations requiring exact decimal arithmetic, use the decimal module. For data analysis and machine learning, float precision is almost always sufficient — use round() only when displaying results to humans.',
        codeSnippet:
            '# Numeric types in data science\nprice = 1299           # int\ndiscount_rate = 0.15   # float\n\ndiscount_amount = price * discount_rate\nprint(discount_amount)          # 194.85 - int * float = float\nprint(type(discount_amount))    # <class \'float\'>\n\n# Float precision issue\nprint(0.1 + 0.2)               # 0.30000000000000004\nprint(0.1 + 0.2 == 0.3)        # False!\nprint(round(0.1 + 0.2, 2))     # 0.3 - use round for display\n\n# Integer division vs float division\nprint(7 // 2)   # 3 - integer division (floor)\nprint(7 / 2)    # 3.5 - float division\nprint(7 % 2)    # 1 - modulo (remainder)',
      ),
      ConceptLesson(
        title: 'Boolean Type and Comparison Operators',
        definition:
            'Booleans (True/False) are the foundation of conditional logic and data filtering. Comparison operators (==, !=, <, >, <=, >=) and logical operators (and, or, not) combine to create the filtering conditions used in every data selection operation.',
        analogy:
            'Boolean logic for data filtering is like a security checkpoint with multiple criteria. "Let through only passengers who ARE over 18 AND DO NOT have a restricted item AND ARE on the passenger list" — this is (age > 18) and (not has_restricted_item) and (name in passenger_list). Each condition evaluates to True or False; their logical combination determines the final pass/fail decision.',
        example:
            'Boolean filtering is the backbone of data selection in Pandas: df[(df["age"] > 18) & (df["city"] == "Mumbai") & (df["premium"] == True)]. The & and | operators (instead of and/or) are required for element-wise Pandas operations, but the Boolean logic is identical. Understanding how these conditions combine is essential for writing any data filter.',
        keyTakeaway:
            'A critical distinction: = is assignment (x = 5 stores 5 in x). == is comparison (x == 5 checks if x equals 5 and returns True/False). Using = when you meant == in a conditional is a common beginner error. Python will often catch it as a syntax error inside if statements, but not always.',
        codeSnippet:
            '# Boolean logic for data filtering\nage = 25\ncity = "Mumbai"\npremium = True\nspend = 4500\n\n# Multiple conditions\nqualifies_offer = age >= 21 and city == "Mumbai" and spend > 1000\nprint(qualifies_offer)    # True\n\n# Useful for filtering\ncustomers = [\n    {"name": "Rahul", "age": 19, "spend": 800},\n    {"name": "Priya", "age": 25, "spend": 4500},\n    {"name": "Amit", "age": 32, "spend": 12000},\n]\n\n# Filter customers qualifying for premium upgrade\npremium_candidates = [\n    c["name"] for c in customers\n    if c["age"] >= 21 and c["spend"] >= 1000\n]\nprint(premium_candidates)  # [\'Priya\', \'Amit\']',
      ),
      ConceptLesson(
        title: 'Type Conversion and the Importance of Correct Types',
        definition:
            'Type conversion (casting) explicitly changes a value from one type to another. In data science, type conversion is performed constantly — reading CSV files produces string columns that must be converted to numbers, integers must become floats for ratio calculations, and categories must sometimes be converted to numeric codes for modeling.',
        analogy:
            'Type conversion in data science is like exchanging currencies. A price quoted in rupees must be converted to dollars before comparing with US market data. The conversion is explicit and intentional — you are changing the representation of the same underlying value for compatibility with a new context. Failing to convert means comparing apples to oranges.',
        example:
            'A typical data loading scenario: a CSV file is loaded and every column comes in as string type. The age column contains "25", "30", "N/A", "28". To calculate average age, convert to int (int("25") works) but int("N/A") raises ValueError. Real data cleaning uses try-except or Pandas\'s pd.to_numeric(errors="coerce") to handle conversion failures gracefully.',
        keyTakeaway:
            'The most important type conversions in data science: str to int/float (after CSV loading), int to float (for ratio calculations), float to int (for count/index operations using int()), and any type to str (for string formatting and concatenation). Each has potential failure modes with real data that you need to handle.',
        codeSnippet:
            '# Type conversion in data processing\n# Simulated data loaded from CSV (everything is string)\nraw_data = [\n    {"product": "Laptop", "price": "75000", "units": "12", "rating": "4.5"},\n    {"product": "Phone",  "price": "25000", "units": "45", "rating": "4.2"},\n    {"product": "Tablet", "price": "35000", "units": "8",  "rating": "3.9"},\n]\n\n# Convert types for analysis\nfor item in raw_data:\n    item["price"] = int(item["price"])\n    item["units"] = int(item["units"])\n    item["rating"] = float(item["rating"])\n    item["revenue"] = item["price"] * item["units"]   # now possible\n\n# Safe conversion with error handling\ndef safe_int(value, default=0):\n    try:\n        return int(value)\n    except (ValueError, TypeError):\n        return default\n\nprint(safe_int("42"))    # 42\nprint(safe_int("N/A"))   # 0 - graceful failure\nprint(safe_int(None))    # 0 - handles None too',
      ),
      ConceptLesson(
        title: 'None Type: Representing Missing Data',
        definition:
            'None is Python\'s special value for "no value" or "missing data" — it is distinct from zero, empty string, or False. None appears constantly in data science when handling missing values, representing unavailable data, and as default function return values.',
        analogy:
            'None in data science is the difference between "the customer\'s age is 0" (impossible — indicates an error), "the customer\'s age is missing" (not collected or not provided), and "we do not know the customer\'s age" (same as missing). None is the honest representation of "this data point does not exist," which is fundamentally different from any specific value including zero.',
        example:
            'Handling None in data pipelines: when calculating average customer age, including None values causes TypeError. Filtering them out (with if age is not None) or replacing with a default value before computation are both valid approaches depending on the analysis. Pandas represents this same concept as NaN (Not a Number) for numeric columns and NaT for date columns.',
        keyTakeaway:
            'Always check for None before performing operations that would fail on None. Use "value is None" (not "value == None") for None comparison — this is more Pythonic and avoids subtle bugs with objects that override the == operator. In Pandas, use pd.isna() or df.isnull() for equivalent None/NaN checking.',
        codeSnippet:
            '# None and missing data handling\ncustomer_ages = [25, None, 30, None, 28, 35, None]\n\n# Count missing values\nmissing = sum(1 for age in customer_ages if age is None)\nprint(f"Missing: {missing} out of {len(customer_ages)}")\n\n# Calculate average, excluding None\nvalid_ages = [age for age in customer_ages if age is not None]\naverage_age = sum(valid_ages) / len(valid_ages)\nprint(f"Average age: {average_age:.1f}")\n\n# Function with None as default\ndef calculate_discount(price, discount_rate=None):\n    if discount_rate is None:\n        discount_rate = 0.10   # default 10%\n    return price * (1 - discount_rate)\n\nprint(calculate_discount(1000))         # 900.0 (default rate)\nprint(calculate_discount(1000, 0.20))   # 800.0 (custom rate)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'A CSV file is loaded and the "revenue" column contains values like "1,25,000". What must be done before performing arithmetic on these values?',
        options: [
          'Nothing — Python automatically handles comma-formatted numbers',
          'Remove commas using .replace(",", "") then convert to float using float() — the values are strings with formatting characters that prevent direct numeric conversion',
          'Use int() directly — int() handles formatted numbers automatically',
          'The column needs to be divided by 1000 to remove the comma effect'
        ],
        correctIndex: 1,
        explanation:
            'CSV files load all values as strings by default. Comma-formatted numbers like "1,25,000" cannot be directly converted with float() or int() — the comma character causes ValueError. Removing commas first with .replace(",", "") then converting with float() is the standard cleaning step.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'print(0.1 + 0.2 == 0.3) outputs False in Python. Why?',
        options: [
          'This is a Python bug that has been fixed in Python 3.10+',
          'Floating point numbers are stored in binary, making exact decimal representation impossible for many fractions — 0.1 and 0.2 cannot be represented exactly, so their sum is 0.30000000000000004, not exactly 0.3',
          'Python uses integer division by default for comparison operations',
          'The == operator compares memory addresses for floats, not values'
        ],
        correctIndex: 1,
        explanation:
            'IEEE 754 floating point representation cannot exactly represent most decimal fractions in binary. This affects every programming language using standard floating point — Python, Java, C, JavaScript all produce this result. Use round() for display or abs(a - b) < epsilon for equality comparisons when exactness matters.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A dataset has sales data where some amounts are missing (None). Which code correctly calculates the total sales, treating None as 0?',
        options: [
          'sum(sales_data)',
          'sum(amount if amount is not None else 0 for amount in sales_data)',
          'sum(amount for amount in sales_data if amount != None)',
          'total = 0; for s in sales_data: total += s'
        ],
        correctIndex: 1,
        explanation:
            'Using a generator expression with conditional expression (amount if amount is not None else 0) handles None values gracefully by substituting 0. Option A fails with TypeError on None values. Option C uses != None which works but "is not None" is more Pythonic. Option D fails when it encounters None in the += operation.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Sales Data Type Analyzer',
      goal:
          'Build a Python function that takes raw sales data (messy types) and returns a clean, type-correct analysis report.',
      steps: [
        'Create a list of 8 sales records as dictionaries with intentionally messy data: prices as strings with commas, dates as strings, some None values, ratings as strings.',
        'Write a function clean_record(record) that converts all fields to correct types, handles None with defaults, and adds a computed revenue field.',
        'Write a function analyze_sales(records) that returns: total revenue, average rating (excluding None), count of records with missing data, and the highest-revenue product.',
        'Use boolean logic to filter and categorize records: high-value (revenue > 50000), medium-value (10000-50000), low-value (below 10000).',
        'Print a formatted summary report using f-strings.',
      ],
      expectedOutput:
          'All records cleaned with correct types. Analysis report with total revenue, average rating, missing data count, and top product. Three-tier categorization applied and printed.',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'conditionals_loops_ds2',
    topicTitle: 'Conditional Statements & Loops',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🔁',
    intro:
        'Control flow is how you tell Python to make decisions and repeat operations. In data science, conditional logic classifies and segments data, while loops process every record in a dataset. This lesson teaches you to write precise, efficient control flow for real data processing tasks.',
    concepts: [
      ConceptLesson(
        title: 'if, elif and else: Decision Making in Data',
        definition:
            'Conditional statements (if/elif/else) evaluate Boolean expressions and execute specific code blocks based on which condition is True — the backbone of data classification, business rule implementation, and exception handling in data pipelines.',
        analogy:
            'An if/elif/else chain is like a decision flowchart for data: "If this record meets condition A, do X. Else if it meets condition B, do Y. Otherwise, do Z." This logic converts raw data values into actionable categories — transforming a customer\'s purchase amount into a tier label, a student\'s score into a grade, or a patient\'s reading into a risk category.',
        example:
            'Classifying customer transaction risk in a fraud detection system: if the transaction is in a new country AND over ₹1 lakh, mark as high risk. Elif the transaction is in a known country but unusually large (3x the customer\'s average), mark as medium risk. Else mark as normal. This multi-condition rule is expressed exactly in Python\'s if/elif/else structure.',
        keyTakeaway:
            'elif chains execute only the first matching condition — subsequent conditions are not checked once a match is found. This is important for performance with many conditions and for correctness when conditions overlap. Order your conditions from most specific to most general when building classification logic.',
        codeSnippet:
            '# if/elif/else for data classification\ndef classify_customer(annual_spend):\n    """Classify customer tier based on annual spend"""\n    if annual_spend >= 500000:\n        return "Platinum"\n    elif annual_spend >= 100000:\n        return "Gold"\n    elif annual_spend >= 25000:\n        return "Silver"\n    else:\n        return "Standard"\n\n# Apply to dataset\nspend_data = [750000, 125000, 30000, 8000, 220000]\ntiers = [classify_customer(s) for s in spend_data]\nprint(list(zip(spend_data, tiers)))\n# [(750000, \'Platinum\'), (125000, \'Gold\'), (30000, \'Silver\'),\n#  (8000, \'Standard\'), (220000, \'Gold\')]',
      ),
      ConceptLesson(
        title: 'for Loops: Processing Every Data Record',
        definition:
            'The for loop iterates over any iterable (list, dictionary, file, range) and executes a code block for each element — the fundamental tool for processing every record in a dataset, every column in a table, or every file in a directory.',
        analogy:
            'A for loop for data processing is like a quality inspector on an assembly line: they examine every single item that comes down the conveyor belt, apply the same set of checks to each, take action based on what they find, and move to the next. The inspector\'s work is identical for each item — only the specific findings vary.',
        example:
            'In data preprocessing, for loops appear in: iterating over all columns to check data quality, processing each row to apply business rules, reading multi-file datasets where each file represents a time period, and training machine learning models across multiple hyperparameter combinations. Even when Pandas vectorization replaces explicit loops, understanding for loops is prerequisite to understanding what Pandas does internally.',
        keyTakeaway:
            'Prefer vectorized operations (NumPy/Pandas) over Python for loops when performance matters for large datasets — a Pandas operation on 1 million rows is 100x faster than an equivalent Python for loop. However, for loops are clearer, easier to debug, and perfectly fine for datasets under 100,000 rows or for logic that is complex to vectorize.',
        codeSnippet:
            '# for loops in data processing\ncricket_scores = [\n    {"player": "Virat",  "runs": 82, "balls": 65},\n    {"player": "Rohit",  "runs": 45, "balls": 38},\n    {"player": "Dhoni",  "runs": 67, "balls": 35},\n    {"player": "Jadeja", "runs": 28, "balls": 22},\n]\n\n# Process each record\nprint("Player Performance Analysis:")\nfor innings in cricket_scores:\n    strike_rate = (innings["runs"] / innings["balls"]) * 100\n    innings["strike_rate"] = round(strike_rate, 1)\n    \n    # Classification using conditional\n    if strike_rate >= 150:\n        category = "Aggressive"\n    elif strike_rate >= 100:\n        category = "Balanced"\n    else:\n        category = "Defensive"\n    \n    print(f"  {innings[\'player\']}: SR={strike_rate:.1f} [{category}]")',
      ),
      ConceptLesson(
        title: 'while Loops and Loop Control: break and continue',
        definition:
            'while loops execute as long as a condition remains True — ideal when the number of iterations is unknown in advance. break exits a loop immediately; continue skips to the next iteration. Both are used in data processing for early termination and conditional skipping.',
        analogy:
            'A while loop is like searching through a stack of papers for a specific document: you keep checking the next paper (while not found) until you find what you need (break) or reach the bottom (condition becomes False). continue is like deciding to skip a paper that has already been processed — you check if it qualifies, and if not, move immediately to the next without processing it.',
        example:
            'In data streaming contexts, while loops are essential: read records from a file stream while records are available, stopping when the stream ends. break is used in search operations: find the first fraud indicator in a transaction and stop searching once found. continue is used in data cleaning: skip records that fail validation without counting them toward totals.',
        keyTakeaway:
            'Prefer for loops when you know the iterable in advance (a list, DataFrame, file). Use while loops when iteration depends on a condition that changes during processing (reading until end of stream, retrying failed operations, converging to a solution). Infinite loops (while True with break) are a valid pattern for event processing and interactive data exploration.',
        codeSnippet:
            '# while loop with break and continue\n# Simulated data stream with some invalid records\ndata_stream = [1200, 3400, -99, 5600, -99, 7800, -99, 2100, None, 4500]\n\ntotal = 0\nvalid_count = 0\nMAX_RECORDS = 6   # process at most 6 valid records\n\nfor value in data_stream:\n    # Skip invalid values\n    if value is None or value < 0:\n        continue    # skip this iteration\n    \n    total += value\n    valid_count += 1\n    \n    # Stop after collecting enough records\n    if valid_count >= MAX_RECORDS:\n        print(f"Reached limit of {MAX_RECORDS} records")\n        break\n\nprint(f"Processed {valid_count} valid records")\nprint(f"Total: ₹{total:,}")\nprint(f"Average: ₹{total/valid_count:,.0f}")',
      ),
      ConceptLesson(
        title: 'enumerate and zip: Pythonic Loop Patterns',
        definition:
            'enumerate() adds a counter to any iterable, yielding (index, value) pairs. zip() combines multiple iterables element by element. Both replace error-prone manual index tracking and enable clean, readable multi-sequence processing.',
        analogy:
            'enumerate() is like a librarian stamping page numbers on pages that were unnumbered — you get the content (the value) plus the position (the index) without having to track position separately. zip() is like a zipper connecting two fabric edges — it pairs the first element of one sequence with the first of another, the second with the second, creating matched pairs.',
        example:
            'Data science uses enumerate() for tracking progress over large datasets ("Processing record 47,823 of 1,000,000") and for converting lists to dictionaries where the index serves as a key. zip() combines parallel data sources: matching dates with corresponding values, pairing feature names with their importance scores, or iterating over train and test sets together.',
        keyTakeaway:
            'Never use range(len(my_list)) to get both index and value — use enumerate(my_list) instead. Never manually index into two parallel lists — use zip(list1, list2) instead. These Pythonic patterns are clearer, safer (no index out-of-bounds errors), and signal professional Python proficiency.',
        codeSnippet:
            '# enumerate and zip in data processing\ncities = ["Mumbai", "Delhi", "Bangalore", "Chennai"]\npopulations = [20.7, 31.0, 12.5, 10.9]  # millions\nrankings = [1, 2, 3, 4]\n\n# enumerate: get index + value without manual tracking\nprint("City Index Map:")\nfor idx, city in enumerate(cities, start=1):  # start counting at 1\n    print(f"  {idx}. {city}")\n\n# zip: process parallel data sources together\nprint("\\nCity Population Report:")\nfor city, pop, rank in zip(cities, populations, rankings):\n    print(f"  Rank {rank}: {city} — {pop}M people")\n\n# zip to create a dictionary\ncity_population = dict(zip(cities, populations))\nprint("\\nDict:", city_population)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'In a for loop over a list of 1 million records, you use "continue" when a record has a missing field. What does this do?',
        options: [
          'Stops the entire loop and exits',
          'Skips the current record and immediately moves to processing the next record in the list, without executing the remaining code in the loop body for the skipped record',
          'Pauses the loop until the missing field is filled',
          'Removes the record from the list permanently'
        ],
        correctIndex: 1,
        explanation:
            'continue immediately jumps to the next iteration of the loop, skipping all remaining code in the current iteration body. The loop continues normally from the next element. It is the correct pattern for "skip invalid records, process all others."',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which is the MOST PYTHONIC way to iterate over a list "features" and get both the position (index) and value?',
        options: [
          'for i in range(len(features)): value = features[i]',
          'for i, value in enumerate(features):',
          'i = 0; while i < len(features): value = features[i]; i += 1',
          'for value in features: i = features.index(value)'
        ],
        correctIndex: 1,
        explanation:
            'enumerate() is the Python idiom for getting index and value simultaneously. Option A works but is not Pythonic and is more error-prone. Option C is verbose. Option D is both un-Pythonic and O(n²) — features.index() searches from the beginning every time, creating a quadratic complexity loop.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You need to process a list of stock prices and identify the first price that exceeds ₹5,000. Once found, record both its position and value, then stop processing. Which approach is CORRECT?',
        options: [
          'Use a for loop with enumerate() to get index and value, use an if condition to check > 5000, use break when the condition is met, and store the index and value found',
          'Sort the prices first then take the first element',
          'Use a while loop that increments an index counter manually until the price is found',
          'Use list comprehension to find all prices above 5000 then take index 0'
        ],
        correctIndex: 0,
        explanation:
            'for loop with enumerate() gives both position and value without manual index tracking. The if condition checks the threshold. break stops immediately when the first match is found — without break, the loop would continue unnecessarily. This is the efficient, Pythonic solution.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'IPL Match Data Processor',
      goal:
          'Build a complete IPL match data processor using loops and conditionals to classify teams, identify patterns, and generate a summary report.',
      steps: [
        'Create a list of 10 IPL match dictionaries with: team1, team2, team1_score, team2_score, venue, and date.',
        'Write a function determine_winner(match) that returns the winning team name or "Tie" using if/elif/else.',
        'Use a for loop with enumerate() to process all matches: determine winner, classify the match as high-scoring (total > 350), competitive (margin < 15 runs), or one-sided.',
        'Use a dictionary to accumulate win counts for each team (loop + conditional increment).',
        'Print a formatted table of match results and a final standings table sorted by wins.',
      ],
      expectedOutput:
          'All 10 matches processed with winners determined. Match classifications applied. Win count dictionary built correctly. Sorted standings table printed.',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'functions_modules_ds2',
    topicTitle: 'Functions & Modules',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 125,
    emoji: '🔧',
    intro:
        'Functions are the building blocks of reusable data science code. Every professional data science codebase is organized into functions — for preprocessing, feature engineering, model evaluation, and reporting. This lesson teaches you to write clean, reusable, well-documented functions that make your data science work reproducible and maintainable.',
    concepts: [
      ConceptLesson(
        title: 'Defining and Calling Functions',
        definition:
            'A function is a named, reusable block of code that accepts inputs (parameters), performs a task, and optionally returns a result. Functions eliminate code duplication, make code testable, and create named abstractions that make complex logic readable.',
        analogy:
            'A function in data science is like a recipe in a cookbook. You write the recipe once (define the function), give it a descriptive name, list the ingredients (parameters), describe the steps (function body), and specify what you end up with (return value). Then you can prepare that dish for any occasion (call the function with different inputs) without rewriting the instructions each time.',
        example:
            'Instead of writing the same data cleaning steps for customer data in 10 different analysis notebooks, define clean_customer_data(df) once. When the cleaning logic needs to change (a new data quality requirement), you update it in one place. All 10 notebooks that call the function automatically use the updated logic — this is the primary value of functions in maintainable data science code.',
        keyTakeaway:
            'The DRY principle (Don\'t Repeat Yourself) is the core motivation for functions. Any data processing step you write more than twice should be a function. Any logic that could be wrong should be testable as a function. Any transformation that has a meaningful name should be a function — because named functions make code self-documenting.',
        codeSnippet:
            '# Functions in data science\ndef calculate_cltv(avg_purchase_value, purchase_frequency,\n                   customer_lifespan, profit_margin=0.20):\n    """\n    Calculate Customer Lifetime Value.\n    \n    Args:\n        avg_purchase_value: Average value per purchase in rupees\n        purchase_frequency: Purchases per year\n        customer_lifespan: Expected years as customer\n        profit_margin: Decimal profit margin (default 20%)\n    \n    Returns:\n        Estimated customer lifetime value in rupees\n    """\n    annual_value = avg_purchase_value * purchase_frequency\n    cltv = annual_value * customer_lifespan * profit_margin\n    return round(cltv, 2)\n\n# Reuse for different customer segments\npremium_cltv = calculate_cltv(8000, 24, 5)\nstandard_cltv = calculate_cltv(2000, 12, 3)\nprint(f"Premium CLTV: ₹{premium_cltv:,}")\nprint(f"Standard CLTV: ₹{standard_cltv:,}")',
      ),
      ConceptLesson(
        title: 'Default Parameters and *args, **kwargs',
        definition:
            'Default parameter values make functions more flexible by providing sensible defaults that callers can override. *args accepts any number of positional arguments as a tuple. **kwargs accepts any number of keyword arguments as a dictionary.',
        analogy:
            'Default parameters are like a restaurant\'s default meal options. A thali comes with a standard set of dishes (defaults) — but you can substitute or add items (override parameters). *args is like accepting a variable number of guests at a dinner party — you do not know exactly how many will come, but you prepare for each. **kwargs is like a customization form where guests can specify any special requirements by name.',
        example:
            'In data science, default parameters create flexible preprocessing functions: normalize(data, method="minmax", clip_outliers=True) works sensibly with just the data argument using standard defaults, but allows full customization when needed. **kwargs are commonly used to pass configuration to underlying library calls: model.fit(X, y, **training_config) passes any model-specific parameters without hardcoding them.',
        keyTakeaway:
            'Default parameters should be immutable objects (numbers, strings, None, tuples) — never use mutable defaults like [] or {}. Using a mutable default like def process(data, results=[]) creates a shared object across all calls, causing subtle and confusing bugs. Use results=None and create a new list inside the function if mutable defaults are needed.',
        codeSnippet:
            '# Default parameters and *args, **kwargs\ndef normalize_data(data, method="minmax", feature_range=(0, 1)):\n    """Normalize data to a specified range"""\n    min_val = min(data)\n    max_val = max(data)\n    \n    if method == "minmax":\n        low, high = feature_range\n        scaled = [(x - min_val) / (max_val - min_val)\n                  * (high - low) + low for x in data]\n    elif method == "zscore":\n        mean = sum(data) / len(data)\n        std = (sum((x - mean)**2 for x in data) / len(data)) ** 0.5\n        scaled = [(x - mean) / std for x in data]\n    return [round(v, 4) for v in scaled]\n\nprices = [100, 250, 180, 320, 90]\nprint(normalize_data(prices))                    # default minmax 0-1\nprint(normalize_data(prices, "zscore"))          # z-score\nprint(normalize_data(prices, feature_range=(0, 100)))  # custom range',
      ),
      ConceptLesson(
        title: 'Lambda Functions: Anonymous One-Liners',
        definition:
            'Lambda functions are small, anonymous functions defined in a single line — used when a short function is needed as an argument to another function (like sorted(), map(), filter()) and a full function definition would be unnecessarily verbose.',
        analogy:
            'A lambda function is like a disposable tool made on the spot for one specific task. Instead of manufacturing a complete named tool (a def function), you create a quick unnamed tool right where you need it. It is perfect for simple transformations you need once, but for any complex or reused logic, a proper named function is far more readable and maintainable.',
        example:
            'Lambdas appear constantly in data science for quick transformations: sorted(students, key=lambda s: s["gpa"], reverse=True) sorts a list of dictionaries by GPA. df["category"].map(lambda x: "premium" if x > 1000 else "standard") applies a conditional transformation to a Pandas Series. sorted(products, key=lambda p: (p["category"], -p["price"])) sorts by multiple criteria.',
        keyTakeaway:
            'Use lambdas for short, clear one-liners when a function is needed as an argument. If the lambda contains any logic that requires explanation, use a named function instead — readability is more valuable than brevity. PEP 8 (Python style guide) recommends against assigning lambdas to variables: never write f = lambda x: x**2 when def f(x): return x**2 is clearer.',
        codeSnippet:
            '# Lambda functions in data processing\nproducts = [\n    {"name": "Laptop", "price": 75000, "category": "Electronics"},\n    {"name": "Shirt",  "price": 1200,  "category": "Clothing"},\n    {"name": "Phone",  "price": 25000, "category": "Electronics"},\n    {"name": "Jeans",  "price": 2500,  "category": "Clothing"},\n]\n\n# Sort by price descending\nby_price = sorted(products, key=lambda p: p["price"], reverse=True)\nprint("By price:", [p["name"] for p in by_price])\n\n# Sort by category first, then price within category\nby_category_price = sorted(\n    products,\n    key=lambda p: (p["category"], -p["price"])\n)\nfor p in by_category_price:\n    print(f"  {p[\'category\']:12} {p[\'name\']:10} ₹{p[\'price\']:,}")',
      ),
      ConceptLesson(
        title: 'Modules and Imports: Organizing Data Science Code',
        definition:
            'A module is a Python file containing functions, classes, and variables that can be imported by other files. Python\'s import system lets you use both built-in modules (math, statistics, datetime, os) and third-party libraries (NumPy, Pandas, scikit-learn) in any script.',
        analogy:
            'Modules are like specialized departments in a company. Instead of one person knowing everything, different departments (modules) contain specialized expertise (functions). When you need statistical calculations, you import the statistics module. When you need array processing, you import NumPy. Each department provides its expertise on demand without cluttering your workspace with everything simultaneously.',
        example:
            'Professional data science projects organize code into modules: data_loading.py (functions for loading and validating raw data), preprocessing.py (cleaning and transformation functions), features.py (feature engineering functions), evaluation.py (model evaluation metrics). Each notebook or script imports exactly what it needs from these shared modules, ensuring consistent logic across the entire project.',
        keyTakeaway:
            'Use specific imports (from datetime import datetime, timedelta) rather than wildcard imports (from datetime import *) — wildcard imports pollute your namespace and make it unclear where functions come from. Use aliases for verbose module names (import pandas as pd, import numpy as np) — these are universal conventions that make collaboration seamless.',
        codeSnippet:
            '# Imports in data science\nimport math\nimport statistics\nfrom datetime import datetime, timedelta\nfrom collections import Counter, defaultdict\n\n# math module for mathematical functions\ndata = [4, 9, 16, 25]\nsqrt_data = [math.sqrt(x) for x in data]\nprint(sqrt_data)    # [2.0, 3.0, 4.0, 5.0]\n\n# statistics module for quick stats\nscores = [78, 85, 92, 67, 89, 73, 96]\nprint(f"Mean: {statistics.mean(scores)}")\nprint(f"Median: {statistics.median(scores)}")\nprint(f"Stdev: {statistics.stdev(scores):.2f}")\n\n# collections for data aggregation\ncategories = ["Electronics", "Clothing", "Electronics",\n              "Food", "Clothing", "Electronics"]\ncounts = Counter(categories)\nprint(dict(counts))    # {\'Electronics\': 3, \'Clothing\': 2, \'Food\': 1}',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which is the CORRECT way to define a function with an optional "outlier_threshold" parameter that defaults to 3.0?',
        options: [
          'def remove_outliers(data, outlier_threshold):',
          'def remove_outliers(data, outlier_threshold=3.0):',
          'def remove_outliers(data=None, outlier_threshold):',
          'def remove_outliers(outlier_threshold=3.0, data):'
        ],
        correctIndex: 1,
        explanation:
            'Default parameters are specified with = in the function signature. Option A has no default (threshold is required). Option C has wrong order — non-default parameters cannot follow default ones. Option D is also wrong — parameters with defaults must come AFTER parameters without defaults. Python raises SyntaxError for options C and D.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the PRIMARY advantage of organizing data processing logic into named functions rather than writing all code sequentially in a notebook?',
        options: [
          'Functions run faster than sequential code',
          'Named functions create reusable, testable, maintainable units — when logic changes (a new data quality requirement), you update one function and all callers automatically use the updated logic, preventing drift and duplication',
          'Functions use less memory than sequential code',
          'Python requires functions for any code longer than 10 lines'
        ],
        correctIndex: 1,
        explanation:
            'The primary value of functions is reusability and maintainability — DRY (Don\'t Repeat Yourself). Functions also enable testing (you can write tests for isolated functions), make code self-documenting through meaningful names, and prevent inconsistencies when the same logic needs to run in multiple places.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You need to sort a list of employee dictionaries first by department (alphabetically), then by salary (descending within each department). Which lambda key correctly achieves this?',
        options: [
          'key=lambda e: e["department"]',
          'key=lambda e: (e["department"], -e["salary"])',
          'key=lambda e: e["salary"], reverse=True',
          'key=lambda e: [e["department"], e["salary"]]'
        ],
        correctIndex: 1,
        explanation:
            'Using a tuple as the sort key enables multi-level sorting. The first element (department) is the primary sort key. The second element (-salary, negated) makes salary sort descending within the same department. Python sorts tuples lexicographically — comparing the first element first, then the second on ties.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Reusable Data Analysis Functions Library',
      goal:
          'Build a library of 6 reusable data analysis functions covering data validation, normalization, aggregation, and reporting.',
      steps: [
        'Write validate_dataset(data, required_fields) that checks for required fields and None values, returning a dict with validation results.',
        'Write normalize_column(values, method="minmax") with default parameter supporting both minmax and zscore normalization.',
        'Write group_statistics(data, group_field, value_field) that returns count, mean, min, and max for each group using Counter and manual calculations.',
        'Write detect_outliers(values, threshold=3.0) using z-score method — returns a list of (index, value) tuples for outliers.',
        'Write format_currency_report(data, amount_field) that formats a summary with Indian number formatting (₹X,XX,XXX).',
        'Write a main() function that calls all five functions on a sample employee salary dataset and prints results.',
      ],
      expectedOutput:
          'All 6 functions defined with docstrings. Validation, normalization, group statistics, outlier detection, and reporting all work correctly on sample data. main() demonstrates the complete pipeline.',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'oop_for_data_science_ds2',
    topicTitle: 'Object-Oriented Programming (OOP)',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🏗️',
    intro:
        'Object-Oriented Programming organizes code around data structures that bundle together related data and the operations on that data. In data science, OOP is everywhere — every NumPy array, Pandas DataFrame, and scikit-learn model is an object. Understanding OOP lets you use these tools deeply and write your own reusable data science components.',
    concepts: [
      ConceptLesson(
        title: 'Classes and Objects: Blueprints and Instances',
        definition:
            'A class is a blueprint defining the structure and behavior of a type of object. An object (instance) is a specific realization of that blueprint with its own data. Classes bundle related data (attributes) and operations (methods) into a single, organized unit.',
        analogy:
            'A class is like an architectural blueprint for houses. The blueprint specifies that each house will have bedrooms, bathrooms, and a kitchen (attributes) with methods like add_room() and calculate_area() (methods). Each actual house built from that blueprint (object/instance) has its own specific values — 3 bedrooms, 2 bathrooms — while sharing the same structure and capabilities.',
        example:
            'In data science, you create classes when you have a coherent concept that has both data and operations: a Dataset class (stores data, provides cleaning methods), a Model class (stores parameters, provides fit/predict methods), a Experiment class (stores configuration, provides run/evaluate methods). scikit-learn\'s entire API is built on this pattern — every estimator is a class instance.',
        keyTakeaway:
            'You do not need to create classes for most data science scripts — functions and notebooks suffice for analysis. Classes become valuable for building reusable components, defining custom model pipelines, creating consistent interfaces, and organizing larger projects. Understanding classes is essential for using scikit-learn, PyTorch, and other ML libraries effectively.',
        codeSnippet:
            '# Class for organizing a data science project component\nclass DataCleaner:\n    """Reusable data cleaning pipeline for tabular datasets"""\n    \n    def __init__(self, fill_strategy="median", outlier_method="iqr"):\n        """Initialize with configurable cleaning strategies"""\n        self.fill_strategy = fill_strategy\n        self.outlier_method = outlier_method\n        self.stats = {}     # will store computed stats after fitting\n    \n    def fit(self, data):\n        """Compute statistics from training data"""\n        numeric_cols = [k for k, v in data[0].items() \n                       if isinstance(v, (int, float))]\n        for col in numeric_cols:\n            values = [row[col] for row in data if row[col] is not None]\n            self.stats[col] = {\n                "median": sorted(values)[len(values) // 2],\n                "mean": sum(values) / len(values)\n            }\n        return self   # return self for method chaining\n    \n    def transform(self, data):\n        """Apply cleaning using stored statistics"""\n        cleaned = []\n        for row in data:\n            clean_row = row.copy()\n            for col, stat in self.stats.items():\n                if clean_row.get(col) is None:\n                    fill_value = (stat["median"] if self.fill_strategy == "median"\n                                  else stat["mean"])\n                    clean_row[col] = fill_value\n            cleaned.append(clean_row)\n        return cleaned\n\n# Usage\ncleaner = DataCleaner(fill_strategy="median")\ncleaner.fit(training_data)\nclean_data = cleaner.transform(new_data)',
      ),
      ConceptLesson(
        title: 'Inheritance: Extending Existing Classes',
        definition:
            'Inheritance allows a new class (child) to inherit all attributes and methods of an existing class (parent) and add or override specific behaviors — enabling code reuse and creating hierarchies of related types.',
        analogy:
            'Inheritance is like a specialized doctor who inherits all general medical training (the parent class Doctor) and adds specialized skills (the child class Cardiologist adds cardiac-specific examination and treatment methods). The cardiologist can do everything a general doctor does AND specialized cardiac work, without relearning all of medicine from scratch.',
        example:
            'In data science and ML, inheritance appears constantly: scikit-learn\'s BaseEstimator is the parent class that all ML models inherit from, providing common fit() and predict() interfaces. If you build a custom model, you inherit from BaseEstimator and TransformerMixin, which gives you all the pipeline compatibility features automatically without reimplementing them.',
        keyTakeaway:
            'Inheritance is most valuable when you have truly hierarchical relationships (a specialized thing IS a general thing). Overuse of inheritance creates complex, fragile code. Many modern Python projects prefer composition (objects containing other objects) over inheritance for flexibility. But understanding inheritance is essential for working with scikit-learn\'s model architecture and Keras\'s neural network layers.',
        codeSnippet:
            '# Inheritance in data science context\nclass BaseTransformer:\n    """Base class for all data transformers"""\n    \n    def fit(self, data):\n        return self\n    \n    def transform(self, data):\n        raise NotImplementedError("Subclass must implement transform")\n    \n    def fit_transform(self, data):\n        """Convenience: fit and transform in one step"""\n        return self.fit(data).transform(data)\n\nclass MinMaxScaler(BaseTransformer):\n    """Scale values to [0, 1] range"""\n    \n    def fit(self, data):\n        self.min_ = min(data)\n        self.max_ = max(data)\n        return self\n    \n    def transform(self, data):\n        range_ = self.max_ - self.min_\n        return [(x - self.min_) / range_ for x in data]\n\n# Child class inherits fit_transform from parent\nscaler = MinMaxScaler()\nresult = scaler.fit_transform([10, 20, 30, 40, 50])\nprint(result)   # [0.0, 0.25, 0.5, 0.75, 1.0]',
      ),
      ConceptLesson(
        title: 'Special Methods: Making Objects Behave Like Python Built-ins',
        definition:
            'Special methods (dunder methods, named __method__) allow custom objects to support Python\'s built-in operations: __init__ (initialization), __len__ (len() function), __str__ (string representation), __repr__ (developer representation), __iter__ (iteration), and __getitem__ (indexing).',
        analogy:
            'Special methods are like implementing a universal adapter interface on a custom device. If your device implements the standard USB interface (__iter__, __getitem__, etc.), it works with all USB accessories (for loops, len(), indexing) without requiring any custom adapters. Python\'s for loop does not care what type of object you are iterating — it just requires the __iter__ interface.',
        example:
            'Pandas DataFrame implements dozens of special methods: len(df) returns row count (__len__), df[0:10] slices rows (__getitem__), for row in df iterates (__iter__), print(df) shows formatted output (__str__). By implementing these for your own classes, your objects integrate naturally with all Python constructs and feel like built-in types.',
        keyTakeaway:
            '__init__ and __repr__ are the two special methods you should implement for almost every data science class you create. __init__ properly initializes the object state. __repr__ creates a developer-friendly string like "DataCleaner(fill_strategy=\'median\', outlier_method=\'iqr\')" that makes debugging dramatically easier.',
        codeSnippet:
            '# Special methods for data science classes\nclass Dataset:\n    def __init__(self, data, name="unnamed"):\n        self.data = data\n        self.name = name\n        self.n_rows = len(data)\n        self.n_cols = len(data[0]) if data else 0\n    \n    def __len__(self):\n        return self.n_rows        # len(dataset) -> row count\n    \n    def __repr__(self):\n        return f"Dataset(name={self.name!r}, rows={self.n_rows}, cols={self.n_cols})"\n    \n    def __getitem__(self, idx):\n        return self.data[idx]     # dataset[0] -> first row\n    \n    def __iter__(self):\n        return iter(self.data)    # for row in dataset: works\n\n# All Python built-ins now work naturally\nds = Dataset([{"a": 1}, {"a": 2}, {"a": 3}], name="sales")\nprint(repr(ds))         # Dataset(name=\'sales\', rows=3, cols=1)\nprint(len(ds))          # 3\nprint(ds[0])            # {\'a\': 1}\nfor row in ds: print(row)  # iterates naturally',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'In scikit-learn, every machine learning model has fit() and predict() methods. What OOP concept enables this consistent interface across dozens of different algorithms?',
        options: [
          'Lambda functions allow each algorithm to have the same syntax',
          'Inheritance — all scikit-learn estimators inherit from BaseEstimator, which defines the common interface. Each algorithm overrides fit() and predict() with its specific implementation while keeping the shared interface',
          'Python modules automatically standardize method names across imported libraries',
          'Decorators enforce consistent method names on all classes in a module'
        ],
        correctIndex: 1,
        explanation:
            'Inheritance enables scikit-learn\'s consistent API. All estimators inherit from BaseEstimator, ensuring they all support the same interface (fit, predict, get_params, set_params). This allows pipelines, cross-validation, and grid search to work with ANY estimator interchangeably — the power of a well-designed inheritance hierarchy.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which two special methods should you implement for almost every data science class you create?',
        options: [
          '__len__ and __iter__ — to support built-in Python operations',
          '__init__ (to properly initialize object state) and __repr__ (to create a developer-friendly string representation for debugging)',
          '__add__ and __mul__ — to support mathematical operations',
          '__getitem__ and __setitem__ — to support indexing'
        ],
        correctIndex: 1,
        explanation:
            '__init__ is essential for every class — it initializes the object correctly. __repr__ is crucial for debugging — without it, printing an object just shows a memory address like "<__main__.DataCleaner object at 0x7f1234>". A good __repr__ shows all important configuration in a readable format.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are building a DataValidator class that checks whether records meet quality standards. What should __init__ store and what should the validate() method return to be most useful?',
        options: [
          '__init__ should store nothing; validate() should print results directly',
          '__init__ should store the validation rules as attributes (required_fields, value_ranges, allowed_types); validate(record) should return a dictionary with "passed": bool, "errors": list — enabling callers to decide how to handle failures',
          '__init__ should store the entire dataset; validate() should fix errors automatically',
          '__init__ should store only the field count; validate() should return True or False only'
        ],
        correctIndex: 1,
        explanation:
            'Good class design: __init__ stores configuration (what to validate against) as attributes. validate() takes a record and returns structured results that give callers full information (passed/failed AND what errors occurred) to make informed decisions. A simple True/False return loses the error details needed for debugging and logging.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Data Pipeline Class',
      goal:
          'Build a reusable DataPipeline class that encapsulates a complete data processing workflow using OOP principles.',
      steps: [
        'Define class DataPipeline with __init__(name, steps=[]) that stores pipeline name and a list of transformation step names.',
        'Implement add_step(step_name, transform_func) that adds a named transformation step to the pipeline.',
        'Implement run(data) that applies all transformation steps in order, printing progress for each step.',
        'Implement __repr__ that shows pipeline name and all step names clearly.',
        'Implement __len__ that returns the number of steps.',
        'Create a pipeline instance, add 3 steps (clean, normalize, encode), run it on sample data, and verify all special methods work correctly.',
      ],
      expectedOutput:
          'DataPipeline class with all methods. repr() shows name and steps. len() returns step count. run() processes data through all steps in order with progress output.',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'file_exception_handling_ds2',
    topicTitle: 'File Handling & Exception Handling',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '📁',
    intro:
        'Data science starts with data — and data lives in files. Reading CSVs, writing results, handling JSON from APIs, and processing multiple data files are daily tasks for every data scientist. Equally important is handling errors gracefully — production data pipelines must not crash when they encounter unexpected data.',
    concepts: [
      ConceptLesson(
        title: 'Reading and Writing Files in Python',
        definition:
            'Python\'s built-in open() function reads and writes text and binary files. The with statement (context manager) ensures files are properly closed even if errors occur — the correct pattern for all file operations in production data code.',
        analogy:
            'Using with open() for file handling is like checking out a library book using the official checkout process rather than just taking it off the shelf. The checkout process (context manager) ensures the book is properly registered as borrowed and returned correctly. Just picking up a file without closing it (not using with) is like taking a book without checking it out — it "works" but leaves the library\'s records in an inconsistent state.',
        example:
            'Data scientists read files constantly: transaction logs (text), configuration files (JSON/YAML), raw data exports (CSV), model outputs (JSON). Writing files is equally common: saving cleaned data, exporting analysis results, writing reports. Always use with open() for all file operations — it prevents file handle leaks that can exhaust system resources in long-running data pipelines.',
        keyTakeaway:
            'Always use with open(filename, mode) as f: for file operations — never use f = open() without a matching f.close() in a finally block. The with statement ensures the file is closed even if an exception occurs mid-processing. Use encoding="utf-8" explicitly for text files containing Indian characters or other non-ASCII content.',
        codeSnippet:
            '# File reading and writing for data science\nimport json\n\n# Reading a text data file\nwith open("sales_data.csv", "r", encoding="utf-8") as f:\n    header = f.readline().strip().split(",")\n    records = []\n    for line in f:\n        values = line.strip().split(",")\n        records.append(dict(zip(header, values)))\n\nprint(f"Loaded {len(records)} records")\n\n# Writing results to JSON\nresults = {\n    "total_records": len(records),\n    "analysis_date": "2024-01-15",\n    "summary": {"total_revenue": 125000}\n}\n\nwith open("analysis_results.json", "w", encoding="utf-8") as f:\n    json.dump(results, f, indent=2, ensure_ascii=False)\nprint("Results saved successfully")',
      ),
      ConceptLesson(
        title: 'Working with CSV and JSON Files',
        definition:
            'Python\'s csv module and json module provide robust, edge-case-handling file parsing for the two most common data science file formats — more reliable than manual string splitting for handling quoted fields, nested structures, and encoding edge cases.',
        analogy:
            'Using Python\'s csv module instead of manually splitting on commas is like using a professional document scanner instead of manually transcribing text. Manual splitting seems straightforward until you encounter CSV fields containing commas within quotes: "Singh, Priya",2500,"Mumbai" — a manual split on comma would incorrectly split the name field. The csv module handles these edge cases automatically.',
        example:
            'Real CSV data contains fields with commas, newlines in quoted fields, different encodings (especially for Indian names in Hindi or regional scripts), BOM markers from Excel exports, and inconsistent line endings. The csv module handles all of these correctly. Similarly, json.load() and json.dump() handle unicode characters, nested structures, and number formatting that manual string parsing would get wrong.',
        keyTakeaway:
            'Always use the csv module for CSV files (never split by comma manually), json module for JSON files (never use eval() on JSON — it is a serious security risk), and pathlib.Path for file paths (more readable than string concatenation, handles OS differences automatically). These three modules cover 90% of file handling in data science.',
        codeSnippet:
            '# csv and json modules for data science\nimport csv\nimport json\nfrom pathlib import Path\n\n# Reading CSV with csv.DictReader (handles edge cases)\ndata_path = Path("data") / "customers.csv"\n\nif data_path.exists():\n    with open(data_path, "r", encoding="utf-8-sig") as f:  # utf-8-sig handles BOM\n        reader = csv.DictReader(f)\n        customers = list(reader)\n    print(f"Loaded: {len(customers)} customers")\n    print("Columns:", list(customers[0].keys()))\nelse:\n    print(f"File not found: {data_path}")\n\n# Writing processed results to JSON\nresults = {\n    "analysis": "customer_segments",\n    "segments": [\n        {"name": "Premium", "count": 245, "avg_spend": 45000},\n        {"name": "Standard", "count": 1823, "avg_spend": 8500}\n    ]\n}\n\noutput_path = Path("results") / "segments.json"\noutput_path.parent.mkdir(parents=True, exist_ok=True)\nwith open(output_path, "w", encoding="utf-8") as f:\n    json.dump(results, f, indent=2, ensure_ascii=False)',
      ),
      ConceptLesson(
        title: 'Exception Handling: Building Robust Data Pipelines',
        definition:
            'Exceptions are Python\'s way of signaling errors. try/except blocks catch exceptions and handle them gracefully, preventing pipeline crashes. except can target specific exception types (ValueError, FileNotFoundError, KeyError) for precise error handling.',
        analogy:
            'Exception handling in data pipelines is like safety nets in a circus performance. The performer (code) attempts something challenging (processing potentially invalid data). If something goes wrong (an exception occurs), the safety net (except block) catches the fall and allows the show to continue (the pipeline processes the next record) rather than ending the entire performance (program crash).',
        example:
            'Production data pipelines must handle: missing files (FileNotFoundError), malformed records (ValueError when converting strings to numbers), missing dictionary keys (KeyError), network timeouts (ConnectionError) when fetching live data, and unexpected null values (TypeError). Each has a different appropriate response — log and skip for bad records, retry for network errors, fail fast for missing critical files.',
        keyTakeaway:
            'Catch specific exceptions, not all exceptions. "except Exception:" catches everything including programming errors you should fix (NameError, AttributeError). "except ValueError:" catches only the specific type of error you anticipated. Catching too broadly hides bugs; catching too narrowly misses expected failures. Always log what went wrong — a silent failure is worse than a loud one.',
        codeSnippet:
            '# Exception handling in data pipelines\nimport logging\n\nlogging.basicConfig(level=logging.INFO)\nlogger = logging.getLogger(__name__)\n\ndef parse_record(raw_record):\n    """Parse and validate a raw data record with error handling"""\n    errors = []\n    parsed = {}\n    \n    # Each field handled with specific error type\n    try:\n        parsed["id"] = int(raw_record.get("id", ""))\n    except (ValueError, AttributeError):\n        errors.append("Invalid or missing ID")\n    \n    try:\n        parsed["amount"] = float(str(raw_record.get("amount", "")).replace(",", ""))\n        if parsed["amount"] < 0:\n            raise ValueError("Amount cannot be negative")\n    except ValueError as e:\n        errors.append(f"Invalid amount: {e}")\n    \n    return parsed, errors\n\n# Process with error tracking\nraw_records = [\n    {"id": "101", "amount": "1,500"},\n    {"id": "abc", "amount": "2,000"},  # bad ID\n    {"id": "103", "amount": "-500"},   # negative amount\n]\n\nsuccessful, failed = [], []\nfor record in raw_records:\n    parsed, errors = parse_record(record)\n    if errors:\n        logger.warning(f"Record failed: {errors}")\n        failed.append((record, errors))\n    else:\n        successful.append(parsed)\n\nprint(f"Parsed: {len(successful)} OK, {len(failed)} failed")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why should you use "with open(file) as f:" instead of "f = open(file)" followed by "f.close()"?',
        options: [
          'with open() is faster than manually opening and closing files',
          'The with statement (context manager) guarantees the file is closed even if an exception occurs between opening and closing — without it, an exception causes the file handle to remain open, potentially corrupting data or exhausting system resources',
          'with open() is only required for writing, not reading files',
          'f.close() is deprecated and no longer works in Python 3'
        ],
        correctIndex: 1,
        explanation:
            'If an exception occurs after f = open() but before f.close(), the file is never properly closed. The with statement guarantees __exit__ (which closes the file) is called even if an exception propagates. In long-running data pipelines processing thousands of files, unclosed file handles can exhaust the OS limit on open file handles.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A data pipeline processes 1 million records and occasionally encounters malformed data. Which exception handling strategy is CORRECT?',
        options: [
          'except Exception: pass — silently ignore all errors and continue',
          'Catch specific expected exceptions (ValueError for bad number formats, KeyError for missing fields), log each failure with the problematic record details, and continue processing the remaining records',
          'Let all exceptions propagate — fix the data before running the pipeline',
          'except Exception: raise SystemExit — abort on first error'
        ],
        correctIndex: 1,
        explanation:
            'Production data pipelines must be resilient to occasional bad records — stopping on first error means 1 bad record out of 1 million prevents all processing. Catching specific exceptions, logging them with details for later investigation, and continuing is the correct approach. Silent failure (pass) hides problems; broad catch hides programming errors.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A function reads a JSON config file and a user provides an invalid path. Which code correctly handles this and all other potential failures?',
        options: [
          'with open(path) as f: return json.load(f)',
          'try: \\n  with open(path, encoding="utf-8") as f: return json.load(f) \\nexcept FileNotFoundError: return {} \\nexcept json.JSONDecodeError as e: raise ValueError(f"Invalid JSON: {e}")',
          'if os.path.exists(path): return json.load(open(path))',
          'return eval(open(path).read())'
        ],
        correctIndex: 1,
        explanation:
            'FileNotFoundError (wrong path) returns empty dict as default. JSONDecodeError (malformed JSON) re-raises as ValueError with a helpful message — it is better to fail loudly on corrupt config than silently use empty config. Option D uses eval() which is a critical security vulnerability. Option C leaks the file handle if json.load fails.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Robust Multi-File Data Loader',
      goal:
          'Build a robust data loading system that reads multiple CSV files, handles all errors gracefully, and produces a consolidated dataset with a processing report.',
      steps: [
        'Create 3 simulated CSV file contents as strings in your code (use io.StringIO to simulate file reading without actual files).',
        'Write load_csv_safe(file_content, filename) that uses csv.DictReader and returns (data, errors) — catching all potential exceptions per record.',
        'Write validate_record(record, schema) that checks required fields and value ranges, returning validation errors.',
        'Write consolidate_files(file_sources) that loads all files, tracks statistics per file (records loaded, records failed), and returns a merged dataset plus a processing report.',
        'Print a formatted report showing: files processed, total records, records failed per file, and a sample of failed records with their error messages.',
      ],
      expectedOutput:
          'All 3 files processed. Records with errors caught and logged. Consolidated dataset returned. Report shows per-file statistics and error samples.',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'numpy_essentials_ds2',
    topicTitle: 'NumPy Essentials',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 35,
    totalXp: 150,
    emoji: '🔢',
    intro:
        'NumPy is the numerical computing foundation that every data science library is built on. Arrays, vectorized math, and broadcasting are the building blocks of all machine learning operations. Master NumPy and you understand what Pandas and scikit-learn are actually doing under the hood.',
    concepts: [
      ConceptLesson(
        title: 'NumPy Arrays: The Foundation of Numerical Computing',
        definition:
            'NumPy arrays (ndarray) are fixed-type, contiguous-memory data structures optimized for numerical computation — they are 100-1000x faster than Python lists for mathematical operations and form the basis of every major ML framework.',
        analogy:
            'A NumPy array is like a perfectly organized spreadsheet column vs a Python list\'s junk drawer. All items in a NumPy array are the same type, stored in adjacent memory locations, so the CPU can process them using SIMD (Single Instruction Multiple Data) hardware instructions — multiplying all 1 million prices by 0.9 in a single CPU operation rather than one at a time.',
        example:
            'Calculating the mean return of 252 trading days: with a Python list, a for loop processes each day individually — ~0.1ms. With NumPy\'s np.mean(), all 252 values are processed together using optimized C code — ~0.001ms. For 10 million stock prices, the difference is seconds vs milliseconds. This speed advantage compounds across every operation in a data pipeline.',
        keyTakeaway:
            'NumPy operations are vectorized — they apply to the entire array at once without explicit loops. This is both faster and more readable. "prices * 0.9" in NumPy multiplies every price by 0.9 simultaneously. Understanding that NumPy operations are element-wise by default is the core mental model for all subsequent numerical computing.',
        codeSnippet:
            'import numpy as np\n\n# Creating arrays\nprices = np.array([1200, 4500, 800, 12000, 3500])\nprint(prices.dtype)    # int64 - all same type\nprint(prices.shape)    # (5,) - 1D array, 5 elements\n\n# Vectorized operations - apply to ALL elements at once\ndiscounted = prices * 0.9        # NO loop needed\ngst_inclusive = prices * 1.18\nlog_prices = np.log(prices)      # log of every element\n\nprint("Original:", prices)\nprint("Discounted:", discounted.astype(int))\n\n# Python list comparison\nimport timeit\npython_list = list(range(1_000_000))\nnumpy_array = np.arange(1_000_000)\n\n# NumPy is ~100x faster for numerical operations\n# numpy_array * 2  vs  [x*2 for x in python_list]',
      ),
      ConceptLesson(
        title: 'Array Creation, Shapes and Reshaping',
        definition:
            'NumPy provides multiple array creation functions (zeros, ones, arange, linspace, random) and the reshape() method to change array dimensions without copying data — essential for preparing data in the shapes ML algorithms expect.',
        analogy:
            'Reshaping a NumPy array is like rearranging the same number of people into different seating configurations in a theater. 12 people can be arranged as 1×12 (one long row), 3×4 (three rows of four), 4×3, 6×2, or 2×6. The people (data) do not change — only the spatial arrangement changes. Machine learning models are like different theaters that require specific seating configurations to function.',
        example:
            'An image dataset of 1000 grayscale photos at 28×28 pixels requires reshaping for different ML models: a Dense neural network needs input shape (1000, 784) — each image flattened to a vector. A CNN needs shape (1000, 28, 28, 1) — preserving spatial structure. The same 1000×28×28 data array is reshaped to match each model\'s expected input without copying data.',
        keyTakeaway:
            'reshape(-1, n) is the most used reshape pattern in data science — it automatically calculates the unknown dimension. prices.reshape(-1, 1) converts a 1D array of 5 prices to shape (5, 1) — a column vector required by many scikit-learn models. Understanding when to use reshape(-1, 1), flatten(), and ravel() prevents the most common ML data preparation errors.',
        codeSnippet:
            'import numpy as np\n\n# Array creation functions\nzeros = np.zeros((3, 4))              # 3x4 matrix of zeros\nones = np.ones((2, 3), dtype=float)   # 2x3 matrix of ones\nrange_arr = np.arange(0, 10, 2)       # [0, 2, 4, 6, 8]\neven_space = np.linspace(0, 1, 5)     # [0, .25, .5, .75, 1.0]\n\n# Random arrays (with seed for reproducibility)\nnp.random.seed(42)\nrand_data = np.random.randn(100, 5)   # 100 samples, 5 features\nprint("Data shape:", rand_data.shape) # (100, 5)\n\n# Reshaping\nflat_image = np.arange(784)           # simulated flattened image\nimage_2d = flat_image.reshape(28, 28) # restore 28x28 grid\nprint("Image shape:", image_2d.shape) # (28, 28)\n\n# -1 lets NumPy calculate the dimension\nprices = np.array([1200, 4500, 800, 12000, 3500])\ncol_vector = prices.reshape(-1, 1)    # (5, 1) - column vector\nprint("Column vector shape:", col_vector.shape)',
      ),
      ConceptLesson(
        title: 'Boolean Indexing and Fancy Indexing',
        definition:
            'Boolean indexing filters array elements using a boolean condition array of the same shape. Fancy indexing selects elements using an integer array of indices. Both are key tools for data filtering and selection in NumPy and Pandas.',
        analogy:
            'Boolean indexing is like using a stamp of True/False marks on a physical dataset: stamp True on every row meeting your condition, then collect only the stamped rows. The resulting selection can be any size — from zero elements to the entire array. The stamp pattern (boolean array) and the data array must match in shape, but the selection result has only the True-stamped elements.',
        example:
            'Boolean indexing is how Pandas\' powerful data filtering works under the hood. When you write df[df["age"] > 25], Pandas evaluates df["age"] > 25 to create a boolean Series of True/False values, then uses that boolean array to index into the DataFrame. Understanding this NumPy foundation explains why Pandas filtering is so fast and why combining conditions requires & and | (not and and or).',
        keyTakeaway:
            'For multiple conditions in boolean indexing, use & (element-wise AND) and | (element-wise OR), not Python\'s and/or keywords. Parentheses are required around each condition when combining: arr[(arr > 0) & (arr < 100)]. Python\'s and/or evaluate entire arrays as single True/False values, causing ValueError for ambiguous truth values.',
        codeSnippet:
            'import numpy as np\n\nscores = np.array([45, 78, 92, 38, 85, 61, 73, 55, 88, 42])\n\n# Boolean indexing\npassing = scores[scores >= 60]\nprint("Passing scores:", passing)   # [78, 92, 85, 61, 73, 88]\n\n# Multiple conditions with & and |\nhigh_b = scores[(scores >= 70) & (scores < 90)]\nprint("B grade:", high_b)           # [78, 85, 73, 88]\n\noutliers = scores[(scores < 40) | (scores > 90)]\nprint("Outliers:", outliers)        # [38, 92]\n\n# Boolean indexing for assignment (modify in place)\nscores_adjusted = scores.copy()\nscores_adjusted[scores_adjusted < 40] = 40  # floor at 40\nprint("After floor:", scores_adjusted)\n\n# Fancy indexing (integer array)\nindices = np.array([0, 2, 5, 9])\nselected = scores[indices]\nprint("Selected by index:", selected)   # [45, 92, 61, 42]',
      ),
      ConceptLesson(
        title: 'Broadcasting: Operations Between Different-Shaped Arrays',
        definition:
            'Broadcasting allows NumPy to perform operations between arrays of different shapes by automatically expanding the smaller array to match the larger one — enabling concise matrix operations without explicit loops or manual replication of data.',
        analogy:
            'Broadcasting is like a standardized form that automatically copies itself to fill a booklet. You fill in one line (a 1D array), and broadcasting automatically copies that pattern to fill all relevant rows in the table (expanding to match a 2D array). The copying is conceptual — NumPy performs the computation without actually allocating the extra memory.',
        example:
            'Normalizing a dataset by subtracting the column mean: data has shape (1000, 5), column_means has shape (5,). Broadcasting automatically subtracts each column\'s mean from every row of that column: data - column_means works because NumPy broadcasts the (5,) array across the (1000, 5) array. Without broadcasting, you would need to reshape or use np.tile() to manually replicate the means.',
        keyTakeaway:
            'Broadcasting rules: arrays are compared dimension by dimension from the trailing dimension. Dimensions are compatible if they are equal or one of them is 1. A (5,) array is broadcast-compatible with (1000, 5) because (5,) is treated as (1, 5) which broadcasts to (1000, 5). Understanding broadcasting prevents errors and makes code dramatically more concise.',
        codeSnippet:
            'import numpy as np\n\n# Broadcasting for data normalization\nnp.random.seed(42)\ndata = np.random.randn(5, 3) * 10 + 50  # 5 samples, 3 features\nprint("Data shape:", data.shape)         # (5, 3)\n\n# Column statistics\ncol_means = data.mean(axis=0)   # shape (3,) - mean of each column\ncol_stds = data.std(axis=0)     # shape (3,) - std of each column\nprint("Means:", col_means.round(2))\n\n# Z-score normalization via broadcasting\n# (5,3) - (3,) -> broadcasts to (5,3) - (5,3) element-wise\nz_scores = (data - col_means) / col_stds\nprint("\\nZ-scores mean (should be ~0):", z_scores.mean(axis=0).round(10))\nprint("Z-scores std  (should be ~1):", z_scores.std(axis=0).round(10))\n\n# Adding a bias term to each row\nbias = np.array([1, 2, 3])      # (3,) broadcasts across rows\ndata_biased = data + bias        # (5,3) + (3,) = (5,3)',
      ),
      ConceptLesson(
        title: 'NumPy Statistics and Linear Algebra',
        definition:
            'NumPy provides complete statistical functions (mean, median, std, percentile, corrcoef) and linear algebra operations (dot product, matrix multiply, inverse, eigenvalues) — the mathematical backbone of all machine learning algorithms.',
        analogy:
            'NumPy\'s statistical and linear algebra functions are like having a master mathematical calculator that performs complex matrix operations instantly and without rounding errors. Every machine learning algorithm from linear regression to PCA to neural networks is fundamentally matrix operations — NumPy makes these operations as simple to express as basic arithmetic.',
        example:
            'The heart of linear regression is the matrix equation W = (X^T X)^(-1) X^T y. NumPy expresses this in three lines: XtX = X.T @ X, XtX_inv = np.linalg.inv(XtX), W = XtX_inv @ X.T @ y. Understanding that ML algorithms are linear algebra operations demystifies them and reveals why they are fast (optimized LAPACK/BLAS routines) and why GPU acceleration works (GPUs are matrix operation hardware).',
        keyTakeaway:
            'For matrix multiplication use @ or np.matmul() (not *). The * operator performs element-wise multiplication (Hadamard product). np.dot(a, b) works for vectors (dot product) and 2D matrices (matrix multiply) but becomes confusing for higher-dimensional arrays — use @ for all matrix operations to write clear, unambiguous code.',
        codeSnippet:
            'import numpy as np\n\n# Statistical functions\nstock_returns = np.array([0.05, -0.03, 0.08, 0.02, -0.01, 0.12, -0.04, 0.07])\n\nprint(f"Mean return: {np.mean(stock_returns):.4f}")\nprint(f"Std dev: {np.std(stock_returns):.4f}")\nprint(f"Median: {np.median(stock_returns):.4f}")\nprint(f"25th percentile: {np.percentile(stock_returns, 25):.4f}")\nprint(f"75th percentile: {np.percentile(stock_returns, 75):.4f}")\n\n# Correlation between two stocks\nstock_a = np.array([0.05, -0.02, 0.08, 0.01, -0.03])\nstock_b = np.array([0.03, -0.01, 0.06, 0.02, -0.02])\ncorr_matrix = np.corrcoef(stock_a, stock_b)\nprint(f"\\nCorrelation: {corr_matrix[0,1]:.4f}")\n\n# Matrix multiplication for ML\nX = np.random.randn(100, 3)   # 100 samples, 3 features\nW = np.array([2.5, -1.2, 0.8]) # weights\npredictions = X @ W            # matrix multiply (100,3) @ (3,) = (100,)\nprint(f"\\nPredictions shape: {predictions.shape}")',
      ),
      ConceptLesson(
        title: 'NumPy for Data Science: Practical Patterns',
        definition:
            'Five NumPy patterns appear constantly in data science workflows: axis parameter for row/column operations, np.where() for conditional selection, np.sort()/argsort() for ordering, np.unique() for categorical analysis, and np.concatenate()/stack() for combining arrays.',
        analogy:
            'These NumPy patterns are like power tools in a workshop — each has a specific purpose that would be tedious to accomplish with basic tools. axis=0 operates across rows (down each column), axis=1 operates across columns (along each row). Keeping these patterns sharp means you can perform common data operations immediately without looking them up.',
        example:
            'np.where(condition, value_if_true, value_if_false) is equivalent to a vectorized if/else on entire arrays — essential for creating derived categorical columns. np.argsort() returns the indices that would sort an array — used for finding top-K values without sorting the entire array when you only need the positions of top performers.',
        keyTakeaway:
            'The axis parameter confusion is a common source of errors. For a 2D array (rows × columns): axis=0 collapses rows (operates down — gives one value per column). axis=1 collapses columns (operates across — gives one value per row). np.sum(data, axis=0) gives column totals. np.sum(data, axis=1) gives row totals.',
        codeSnippet:
            'import numpy as np\n\nscores = np.array([\n    [85, 92, 78],    # student 1: math, english, science\n    [72, 65, 88],    # student 2\n    [91, 87, 94],    # student 3\n    [68, 73, 71],    # student 4\n])\n\n# axis=1: compute across columns (per student)\nstudent_averages = scores.mean(axis=1)\nprint("Student averages:", student_averages)   # [85, 75, 90.67, 70.67]\n\n# axis=0: compute across rows (per subject)\nsubject_averages = scores.mean(axis=0)\nprint("Subject averages:", subject_averages)   # [79, 79.25, 82.75]\n\n# np.where: conditional classification\ngrades = np.where(student_averages >= 85, "Pass", "Needs Support")\nprint("Grades:", grades)\n\n# np.argsort: find ranking\nranking = np.argsort(student_averages)[::-1]  # descending\nprint("Ranking (best to worst):", ranking + 1)  # 1-indexed',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the KEY difference between * (asterisk) and @ when applied to NumPy 2D arrays?',
        options: [
          '* and @ are identical for 2D arrays — both perform matrix multiplication',
          '* performs element-wise multiplication (each element multiplied by the corresponding element). @ performs matrix multiplication (dot product of rows and columns)',
          '@ is faster but * is more accurate for large arrays',
          '* works only for float arrays while @ works for any numeric type'
        ],
        correctIndex: 1,
        explanation:
            'This distinction is critical and a common source of bugs. A * B multiplies each element a[i,j] by the corresponding b[i,j] — requires same shape. A @ B performs matrix multiplication — rows of A dotted with columns of B. In machine learning, weights applied to features always use @ (matrix multiply), never * (element-wise).',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'For a 2D NumPy array "data" of shape (1000, 5) representing 1000 samples with 5 features each, which operation gives the MEAN of each feature (one mean per column)?',
        options: [
          'np.mean(data) — returns overall mean of all values',
          'data.mean(axis=0) — axis=0 collapses rows, giving one mean per column (per feature)',
          'data.mean(axis=1) — axis=1 gives one mean per row (per sample)',
          'np.mean(data, keepdims=True) — preserves shape after operation'
        ],
        correctIndex: 1,
        explanation:
            'axis=0 operates across rows — it collapses the row dimension, leaving one value per column (per feature). For shape (1000, 5) with axis=0, the result has shape (5,) — one mean for each of the 5 features. axis=1 would give one mean per sample (1000 values). This is the most common NumPy axis confusion.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You have a sales array of shape (12, 4) representing monthly sales for 4 products over 12 months. Which code gives you the total annual sales per product?',
        options: [
          'sales.sum() — total of everything',
          'sales.sum(axis=0) — sum across rows (months), giving shape (4,) — one total per product',
          'sales.sum(axis=1) — sum across columns (products), giving shape (12,) — one total per month',
          'np.mean(sales, axis=0) — mean is needed for annual total'
        ],
        correctIndex: 1,
        explanation:
            'axis=0 collapses the row dimension (months), summing all 12 months for each product. Result shape (4,) gives one annual total per product. axis=1 would sum products within each month, giving monthly totals across all products. Annual per-product totals require axis=0.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Stock Market Analysis with NumPy',
      goal:
          'Build a complete stock performance analysis system using only NumPy for all numerical computations.',
      steps: [
        'Create a NumPy array of shape (252, 5) representing 252 trading days of prices for 5 stocks (simulate with np.random.seed(42) and cumulative random walk).',
        'Calculate daily returns for each stock: (price_today - price_yesterday) / price_yesterday.',
        'Compute portfolio statistics for each stock: annual mean return, volatility (std of daily returns), and Sharpe ratio (mean_return / volatility).',
        'Use boolean indexing to find all days where any stock had a loss exceeding 2%.',
        'Use np.argsort to rank stocks by Sharpe ratio and print results with np.where to classify each as "Strong Buy", "Hold", or "Review".',
      ],
      expectedOutput:
          'Daily returns array computed correctly. Per-stock statistics (mean, std, Sharpe) calculated using axis parameter. High-loss days identified with boolean indexing. Stocks ranked and classified by Sharpe ratio.',
      xpReward: 65,
    ),
  ),
  TopicCourse(
    id: 'pandas_fundamentals_ds2',
    topicTitle: 'Pandas Fundamentals',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 40,
    totalXp: 175,
    emoji: '🐼',
    intro:
        'Pandas is the Swiss Army knife of data science — it handles loading, cleaning, transforming, merging, and analyzing tabular data with an elegant, expressive API. If you spend 60% of your time on data preparation (which you will), Pandas is the tool you will be using. This lesson covers the operations you will use every single day.',
    concepts: [
      ConceptLesson(
        title: 'Series and DataFrame: The Two Core Structures',
        definition:
            'A Pandas Series is a one-dimensional labeled array — like a single spreadsheet column with an index. A DataFrame is a two-dimensional labeled structure of columns — like a complete spreadsheet or SQL table. Every column of a DataFrame is a Series.',
        analogy:
            'A Pandas DataFrame is like a well-organized spreadsheet with superpowers. The spreadsheet structure (rows and columns with labels) is familiar. The superpowers are: load it from any file format in one line, filter it with SQL-like conditions, merge it with another table on a key column, handle missing values consistently, and apply custom functions to every row or column simultaneously.',
        example:
            'Every real-world dataset handled in data science passes through a Pandas DataFrame: customer purchase history from a database, sensor readings from IoT devices, financial transactions from a CSV, survey responses from a form. The DataFrame provides a unified interface for all of these disparate sources — the same operations work regardless of where the data came from.',
        keyTakeaway:
            'The DataFrame index is not just a row number — it is a meaningful label that allows fast lookup and alignment between DataFrames. Understanding that Pandas automatically aligns on index when performing operations between DataFrames (not on position like NumPy arrays) prevents subtle, hard-to-detect data alignment bugs.',
        codeSnippet:
            'import pandas as pd\nimport numpy as np\n\n# Creating a DataFrame\ndf = pd.DataFrame({\n    "name": ["Priya", "Rahul", "Amit", "Sneha", "Vijay"],\n    "city": ["Mumbai", "Delhi", "Mumbai", "Bangalore", "Delhi"],\n    "sales": [85000, 72000, 91000, 68000, 78000],\n    "experience_yrs": [3, 5, 8, 2, 6],\n    "target_met": [True, False, True, False, True]\n})\n\nprint(df.shape)           # (5, 5) - 5 rows, 5 columns\nprint(df.dtypes)          # data type of each column\nprint(df.head(3))         # first 3 rows\nprint(df.describe())      # statistics for numeric columns\nprint(df.info())          # complete column info including nulls',
      ),
      ConceptLesson(
        title: 'Data Selection: loc, iloc and Boolean Indexing',
        definition:
            'Pandas provides three ways to select data: column access with bracket notation, label-based selection with .loc[], position-based selection with .iloc[], and boolean indexing for filtering rows by conditions.',
        analogy:
            'loc, iloc, and boolean indexing are three different ways to navigate a spreadsheet. .loc["Mumbai"] is like "go to the Mumbai section" — label-based navigation. .iloc[0:5] is like "go to rows 1 through 5" — position-based navigation. Boolean indexing is like "show me all rows where the highlighted cell is green" — condition-based selection.',
        example:
            'Common selection patterns: df["sales"] selects a column. df[["name", "sales"]] selects multiple columns. df.loc[0:2, "name":"sales"] selects a block by labels. df.iloc[0:3, 1:4] selects a block by position. df[df["sales"] > 80000] filters high performers. df[(df["city"] == "Mumbai") & (df["sales"] > 75000)] filters with multiple conditions.',
        keyTakeaway:
            'Always use .loc[] when you know the label, .iloc[] when you know the position. Avoid chaining selections like df["col1"]["value1"] — use .loc[] instead to prevent the SettingWithCopyWarning and ensure you are modifying the original DataFrame rather than an ambiguous copy.',
        codeSnippet:
            'import pandas as pd\n\ndf = pd.DataFrame({\n    "name": ["Priya", "Rahul", "Amit", "Sneha"],\n    "city": ["Mumbai", "Delhi", "Mumbai", "Bangalore"],\n    "sales": [85000, 72000, 91000, 68000]\n})\n\n# Column selection\nprint(df["sales"])                   # single column as Series\nprint(df[["name", "sales"]])         # multiple columns as DataFrame\n\n# Boolean filtering\nmumbai_team = df[df["city"] == "Mumbai"]\nhigh_performers = df[df["sales"] >= 80000]\n\n# Multiple conditions\ntop_mumbai = df[(df["city"] == "Mumbai") & (df["sales"] >= 80000)]\nprint("\\nTop Mumbai performers:")\nprint(top_mumbai)\n\n# .loc for label-based selection\nprint(df.loc[0:2, "name":"sales"])   # rows 0-2, cols name through sales\n\n# .iloc for position-based selection\nprint(df.iloc[1:3, 0:2])             # rows 1-2, first 2 columns',
      ),
      ConceptLesson(
        title: 'Data Cleaning with Pandas',
        definition:
            'Pandas provides a complete toolkit for data cleaning: isnull()/fillna()/dropna() for missing values, drop_duplicates() for deduplication, astype() for type conversion, str accessor for text cleaning, and rename() for column standardization.',
        analogy:
            'Pandas data cleaning is like detailing a car before a sale: checking for missing parts (isnull), filling minor gaps (fillna), removing duplicates (drop_duplicates), converting rusty parts (astype), polishing surfaces (str.strip/lower), and relabeling components (rename). Each step transforms raw, inconsistent data into a clean, consistent dataset ready for analysis.',
        example:
            'A real messy dataset before analysis: customer ages contain NaN, product names have inconsistent capitalization and leading whitespace, order dates are strings not datetime objects, duplicate order IDs exist, and the "revenue" column contains string values with currency symbols. Each problem requires a specific Pandas cleaning operation before any analysis or modeling.',
        keyTakeaway:
            'df.isnull().sum() is always the first command you run on any new dataset — it shows exactly how many missing values exist per column. The decision to fillna() (fill with mean/median/mode) or dropna() (remove rows/columns) depends on the percentage missing and the importance of that column. Dropping more than 10% of rows requires strong justification.',
        codeSnippet:
            'import pandas as pd\nimport numpy as np\n\n# Messy dataset\ndf = pd.DataFrame({\n    "name": ["  priya", "RAHUL", "amit ", None, "vijay"],\n    "age": [25, None, 32, 28, None],\n    "city": ["Mumbai", "Delhi", "mumbai", "Delhi", "Delhi"],\n    "revenue": ["1,25,000", "72,000", "91,000", "68,000", "78,000"]\n})\n\nprint("Missing values:\\n", df.isnull().sum())\n\n# Fix each issue\ndf["name"] = df["name"].str.strip().str.title()\ndf["city"] = df["city"].str.strip().str.title()\ndf["revenue"] = df["revenue"].str.replace(",", "").astype(float)\ndf["age"] = df["age"].fillna(df["age"].median())   # fill with median\ndf = df.dropna(subset=["name"])                     # drop rows with missing name\ndf = df.drop_duplicates()\n\nprint("\\nCleaned dataset:")\nprint(df)',
      ),
      ConceptLesson(
        title: 'GroupBy and Aggregation',
        definition:
            'groupby() splits a DataFrame into groups based on column values, then apply() or agg() applies aggregation functions to each group — producing summary statistics by category, the cornerstone of exploratory data analysis.',
        analogy:
            'groupby().agg() is like sorting a stack of invoices into folders by city, then calculating the total and average for each city\'s folder. You split (group by city), compute (sum/mean the values), and combine (present results). This split-apply-combine pattern appears in virtually every data analysis and reporting task.',
        example:
            'Standard EDA questions answered with groupby: "What is the average sales per region?" df.groupby("region")["sales"].mean(). "How many customers are in each tier and what do they spend on average?" df.groupby("tier").agg({"customer_id": "count", "monthly_spend": "mean"}). "What is the top product in each category?" df.groupby("category")["revenue"].idxmax().',
        keyTakeaway:
            'agg() with a dictionary is the most powerful groupby pattern — it applies different aggregations to different columns simultaneously. df.groupby("city").agg({"sales": ["mean", "sum", "count"], "age": "mean"}) produces a multi-level column result that answers multiple questions about each city in one operation.',
        codeSnippet:
            'import pandas as pd\n\ndf = pd.DataFrame({\n    "region": ["North", "South", "North", "South", "North", "West"],\n    "product": ["A", "B", "A", "A", "B", "A"],\n    "sales": [45000, 62000, 38000, 71000, 55000, 48000],\n    "units": [45, 62, 38, 71, 55, 48]\n})\n\n# Basic groupby\nregion_avg = df.groupby("region")["sales"].mean()\nprint("Average sales by region:\\n", region_avg)\n\n# Multiple aggregations\nregion_stats = df.groupby("region").agg(\n    total_sales=("sales", "sum"),\n    avg_sales=("sales", "mean"),\n    transaction_count=("sales", "count"),\n    total_units=("units", "sum")\n).round(0)\nprint("\\nRegion statistics:")\nprint(region_stats)\n\n# GroupBy + transform for adding group stats back\ndf["region_avg"] = df.groupby("region")["sales"].transform("mean")\ndf["vs_region_avg"] = df["sales"] - df["region_avg"]\nprint("\\nPerformance vs region average:")\nprint(df[["region", "sales", "region_avg", "vs_region_avg"]])',
      ),
      ConceptLesson(
        title: 'Merging and Joining DataFrames',
        definition:
            'pd.merge() combines two DataFrames based on shared key columns — equivalent to SQL JOINs. pd.concat() stacks DataFrames vertically (more rows) or horizontally (more columns). These operations are fundamental when working with data from multiple tables or sources.',
        analogy:
            'Merging DataFrames is exactly like SQL JOINs you would perform in a database. Inner join: keep only records that appear in both tables (customers who placed orders). Left join: keep all records from the left table, fill with NaN where the right table has no match (all customers, even those with no orders). The operation is identical conceptually — Pandas just applies it to in-memory DataFrames instead of database tables.',
        example:
            'Every real data analysis combines multiple sources: customers table + orders table joined on customer_id, sales transactions + product catalog joined on product_id, employee records + payroll data joined on employee_id. Understanding merge types (inner, left, right, outer) prevents data loss or accidental duplication of records during the join.',
        keyTakeaway:
            'Always verify row counts after merging: if the result has more rows than the left table, there are duplicate keys in the right table (one customer matches multiple product records). If fewer rows than expected, some keys have no match. pd.merge(validate="1:m") and checking for duplicates in keys before merging prevents silent data corruption.',
        codeSnippet:
            'import pandas as pd\n\n# Two related tables\ncustomers = pd.DataFrame({\n    "customer_id": [101, 102, 103, 104],\n    "name": ["Priya", "Rahul", "Amit", "Sneha"],\n    "city": ["Mumbai", "Delhi", "Mumbai", "Bangalore"]\n})\n\norders = pd.DataFrame({\n    "order_id": [1001, 1002, 1003, 1004, 1005],\n    "customer_id": [101, 102, 101, 103, 105],  # 105 has no matching customer\n    "amount": [4500, 8200, 2100, 6700, 3300]\n})\n\n# Inner join: only matching records\ninner = pd.merge(customers, orders, on="customer_id", how="inner")\nprint(f"Inner join: {len(inner)} rows")\n\n# Left join: all customers, even without orders\nleft = pd.merge(customers, orders, on="customer_id", how="left")\nprint(f"Left join: {len(left)} rows\")\nprint(left[left[\"order_id\"].isna()])  # customers with no orders\n\n# Concat: stacking DataFrames\nnew_customers = pd.DataFrame({\"customer_id\": [105], \"name\": [\"Vijay\"], \"city\": [\"Pune\"]})\nall_customers = pd.concat([customers, new_customers], ignore_index=True)\nprint(f\"\\nTotal customers after concat: {len(all_customers)}\")',
      ),
      ConceptLesson(
        title: 'apply() and Map: Custom Transformations',
        definition:
            'apply() applies a function along an axis of a DataFrame (to each row or each column). map() applies a function or dictionary mapping to each element of a Series. These enable custom transformations that go beyond built-in Pandas methods.',
        analogy:
            'apply() is like hiring a specialist consultant who visits each row of your spreadsheet (or each column) and applies their expert analysis. map() is like using a translation dictionary — for each value in a Series, look up its corresponding mapped value. Both extend Pandas beyond its built-in vocabulary to handle any custom business logic.',
        example:
            'apply() with axis=1 processes each row as a Series, enabling computations that need multiple columns: calculating a risk score from multiple financial indicators, deriving a composite grade from multiple exam scores, or formatting a full address from separate street/city/state columns. map() is perfect for category encoding, label translation, and applying custom scoring functions to individual values.',
        keyTakeaway:
            'apply() is slower than vectorized Pandas operations (use built-in methods and NumPy operations when possible). But apply() is the correct tool when the transformation requires complex logic that cannot be expressed as a single vectorized operation. The speed trade-off is usually acceptable for preprocessing code that runs once per dataset.',
        codeSnippet:
            'import pandas as pd\nimport numpy as np\n\ndf = pd.DataFrame({\n    "name": ["Priya", "Rahul", "Amit", "Sneha"],\n    "math": [85, 72, 91, 68],\n    "english": [78, 80, 85, 73],\n    "science": [90, 65, 88, 71]\n})\n\n# apply with axis=1: custom function per row\ndef assign_grade(row):\n    avg = (row["math"] + row["english"] + row["science"]) / 3\n    if avg >= 85: return "A"\n    elif avg >= 75: return "B"\n    elif avg >= 65: return "C"\n    else: return "F"\n\ndf["average"] = df[["math", "english", "science"]].mean(axis=1).round(1)\ndf["grade"] = df.apply(assign_grade, axis=1)\n\n# map: translate values using a dictionary\ncity_region = {"Mumbai": "West", "Delhi": "North", "Bangalore": "South"}\ncities = pd.Series(["Mumbai", "Delhi", "Mumbai", "Bangalore"])\nregions = cities.map(city_region)\nprint(regions)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'You want to filter a DataFrame to show only rows where city is "Mumbai" AND sales exceed 80000. Which syntax is CORRECT?',
        options: [
          'df[df["city"] == "Mumbai" and df["sales"] > 80000]',
          'df[(df["city"] == "Mumbai") & (df["sales"] > 80000)]',
          'df[df["city"] == "Mumbai"][df["sales"] > 80000]',
          'df.filter(city="Mumbai", sales__gt=80000)'
        ],
        correctIndex: 1,
        explanation:
            'Boolean filtering with multiple conditions requires & (element-wise AND) with parentheses around each condition. Option A uses Python\'s "and" keyword which tries to evaluate entire boolean Series as a single bool, causing ValueError. Option C chains indexing which can produce unexpected results and SettingWithCopyWarning.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'After a pd.merge(left_df, right_df, on="id", how="inner"), the result has MORE rows than either input DataFrame. What likely caused this?',
        options: [
          'Inner merge always produces more rows than the input DataFrames',
          'The "id" column has duplicate values in one or both DataFrames — when one id in left matches multiple rows with the same id in right, Pandas creates one output row per matching combination (Cartesian product of matching rows)',
          'An additional index column was accidentally added during the merge',
          'This is impossible — inner merge can only produce fewer or equal rows than the smaller input'
        ],
        correctIndex: 1,
        explanation:
            'Row multiplication in merge is a classic data engineering trap. If customer_id 101 appears 2 times in the left table and 3 times in the right table, the merge produces 2×3=6 rows for customer 101. Always check for duplicates in join keys before merging, and verify output row counts against expectations.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You have a DataFrame "df" with columns "category", "revenue", and "units_sold". Which code produces a summary showing total_revenue and avg_units for each category in one operation?',
        options: [
          'df.groupby("category")["revenue"].sum()',
          'df.groupby("category").agg(total_revenue=("revenue", "sum"), avg_units=("units_sold", "mean"))',
          'df.groupby("category").apply(lambda x: x.sum())',
          'df[["category", "revenue", "units_sold"]].describe()'
        ],
        correctIndex: 1,
        explanation:
            'agg() with named aggregations (new_col_name=(source_col, function)) produces a clean, labeled result DataFrame with custom column names. This is the most Pythonic and readable way to compute multiple aggregations on different columns simultaneously.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'E-Commerce Data Analysis with Pandas',
      goal:
          'Build a complete e-commerce sales analysis using Pandas — from raw data loading through cleaning, transformation, aggregation, and insights.',
      steps: [
        'Create two DataFrames: "orders" (order_id, customer_id, product_id, quantity, order_date, status) with 20 rows including some NaN and duplicates, and "products" (product_id, name, category, price) with 8 rows.',
        'Clean the orders DataFrame: fill missing quantities with 1, fill missing status with "Pending", drop duplicate order_ids, convert order_date to datetime.',
        'Merge orders with products on product_id (left merge). Calculate a "revenue" column (quantity * price).',
        'GroupBy analysis: total revenue and order count by product category; average order value by status; top 3 customers by total revenue.',
        'Use apply() to add a "tier" column: High Value (>500), Medium (200-500), Low (<200) based on order revenue.',
        'Print a formatted summary report with all insights.',
      ],
      expectedOutput:
          'Orders and products DataFrames created and cleaned. Merge completed correctly (left join). Revenue column computed. Three groupby analyses with correct aggregations. Tier classification applied. Formatted summary report printed.',
      xpReward: 70,
    ),
  ),
  TopicCourse(
    id: 'data_visualization_ds2',
    topicTitle: 'Data Visualization Basics (Matplotlib & Seaborn)',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 35,
    totalXp: 150,
    emoji: '📊',
    intro:
        'A number without context is noise. A visualization is signal. Data visualization transforms analysis outputs into insights that human brains can instantly process. This lesson teaches you to create production-quality visualizations with Matplotlib and Seaborn — the tools every data scientist uses daily for exploration and communication.',
    concepts: [
      ConceptLesson(
        title: 'Why Visualization Matters: Anscombe\'s Quartet',
        definition:
            'Anscombe\'s Quartet demonstrates why visualization is non-negotiable: four datasets with nearly identical statistics (same mean, variance, and correlation) look completely different when plotted — revealing that identical numbers can represent completely different underlying patterns.',
        analogy:
            'Anscombe\'s Quartet is like four different cities that all have the same annual average temperature but completely different climates — one has stable mild weather year-round, another has extreme summers and winters, another has a perfect curve peaking in summer. The average (statistic) is identical; the reality (visualization) is completely different. Statistical summaries always need visual verification.',
        example:
            'All four datasets in Anscombe\'s Quartet have: mean of x = 9, mean of y ≈ 7.5, variance of x = 11, variance of y ≈ 4.12, correlation = 0.816. But when plotted: Dataset 1 is a clean linear relationship. Dataset 2 is a curved relationship. Dataset 3 has one extreme outlier. Dataset 4 has all identical x values except one. Never trust statistics without visualizing the data.',
        keyTakeaway:
            'Always visualize distributions before calculating means, correlations before building regression models, and outliers before computing statistics. Visualization is not the final step of analysis — it should be integrated throughout, starting with the very first exploratory analysis of any new dataset.',
      ),
      ConceptLesson(
        title: 'Matplotlib Fundamentals: Figure, Axes and Plots',
        definition:
            'Matplotlib\'s structure: a Figure is the overall container (the canvas), Axes are the individual plot areas within the figure (with x-axis, y-axis, labels), and plot functions (plot(), scatter(), bar(), hist()) draw on the current axes. Understanding this hierarchy enables complex multi-panel layouts.',
        analogy:
            'Matplotlib\'s Figure/Axes architecture is like a physical poster board (Figure) that holds multiple framed paintings (Axes). Each painting has its own borders, labels, and content. The poster board organizes the paintings spatially. You can put one large painting on the board, or arrange many smaller paintings in a grid — the board is the container, each painting is a self-contained visualization.',
        example:
            'A professional data science dashboard is a Figure with multiple Axes: one Axes shows the revenue trend line chart, another shows a sales distribution histogram, another shows a regional comparison bar chart. plt.subplots(2, 2) creates a 2×2 grid of four Axes — each gets its own data and labels while sharing the overall Figure for coherent export as one image.',
        keyTakeaway:
            'Always save figures before calling plt.show() or the save will be blank (show() clears the figure). Use fig, axes = plt.subplots() to get explicit handles for multi-panel figures rather than using plt.subplot() calls which track state implicitly. Explicit is better than implicit, especially for complex layouts.',
        codeSnippet:
            'import matplotlib.pyplot as plt\nimport numpy as np\n\n# Matplotlib object-oriented interface (professional approach)\nfig, axes = plt.subplots(1, 2, figsize=(12, 5))\nfig.suptitle("Sales Analysis Dashboard", fontsize=14, fontweight="bold")\n\n# Plot 1: Line chart\nmonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]\nrevenue = [45000, 52000, 48000, 61000, 57000, 69000]\naxes[0].plot(months, revenue, marker="o", color="#2196F3", linewidth=2)\naxes[0].set_title("Monthly Revenue")\naxes[0].set_ylabel("Revenue (₹)")\naxes[0].set_xlabel("Month")\naxes[0].grid(True, alpha=0.3)\n\n# Plot 2: Bar chart\ncategories = ["Electronics", "Clothing", "Food", "Books"]\ncounts = [245, 312, 189, 143]\naxes[1].bar(categories, counts, color=["#FF5722", "#4CAF50", "#FFC107", "#9C27B0"])\naxes[1].set_title("Sales by Category")\naxes[1].set_ylabel("Units Sold")\n\nplt.tight_layout()\nplt.savefig("sales_dashboard.png", dpi=150, bbox_inches="tight")\nplt.show()',
      ),
      ConceptLesson(
        title: 'Choosing the Right Chart Type',
        definition:
            'Chart selection depends on the data type and relationship being shown: line charts for trends over time, bar charts for category comparisons, histograms for distributions, scatter plots for relationships between variables, box plots for distribution and outlier comparison, and heatmaps for correlation matrices.',
        analogy:
            'Choosing a chart type is like choosing the right lens for a camera. A telephoto lens (scatter plot) shows the relationship between two distant subjects. A wide-angle lens (histogram) shows the full landscape of a single variable. A portrait lens (bar chart) focuses on one characteristic at a time. Using the wrong lens for the scene produces a technically correct but misleading image.',
        example:
            'Common data science visualization decisions: comparing mean salary across departments → bar chart (category comparison). Showing how revenue changed month-by-month → line chart (time trend). Understanding age distribution of customers → histogram (single variable distribution). Investigating correlation between ad spend and sales → scatter plot (two variable relationship). Comparing salary distributions across departments → box plot (distribution comparison by category).',
        keyTakeaway:
            'Pie charts should almost never be used in data science — humans are poor at comparing angles, making pie charts less informative than bar charts for the same data. Use bar charts instead. 3D charts add visual complexity without adding information and often distort perception — keep charts simple and 2D.',
        codeSnippet:
            'import matplotlib.pyplot as plt\nimport numpy as np\n\n# Different chart types for different questions\nnp.random.seed(42)\nages = np.random.normal(35, 10, 500)\n\nfig, axes = plt.subplots(2, 2, figsize=(14, 10))\n\n# 1. Histogram: distribution of a single variable\naxes[0, 0].hist(ages, bins=30, color="#2196F3", alpha=0.7, edgecolor="white")\naxes[0, 0].set_title("Age Distribution")\naxes[0, 0].set_xlabel("Age")\naxes[0, 0].set_ylabel("Frequency")\n\n# 2. Scatter: relationship between two variables\nspend = ages * 800 + np.random.normal(0, 5000, 500)\naxes[0, 1].scatter(ages, spend, alpha=0.5, s=20, color="#FF5722")\naxes[0, 1].set_title("Age vs Spending")\naxes[0, 1].set_xlabel("Age")\naxes[0, 1].set_ylabel("Annual Spend (₹)")\n\n# 3. Box plot: distribution comparison by group\ndata_by_group = [np.random.normal(mu, 5, 100) for mu in [70, 80, 75, 85]]\naxes[1, 0].boxplot(data_by_group, labels=["Q1", "Q2", "Q3", "Q4"])\naxes[1, 0].set_title("Quarterly Score Distribution")\n\n# 4. Bar: category comparison\ncats = ["Electronics", "Clothing", "Food"]\nvals = [450000, 280000, 190000]\naxes[1, 1].barh(cats, vals, color=["#4CAF50", "#FF9800", "#E91E63"])\naxes[1, 1].set_title("Revenue by Category")\n\nplt.tight_layout()\nplt.show()',
      ),
      ConceptLesson(
        title: 'Seaborn: Statistical Visualizations Made Easy',
        definition:
            'Seaborn is a higher-level visualization library built on Matplotlib that creates statistically informative, aesthetically polished charts with less code — automatically computing and displaying statistical summaries, confidence intervals, and distributional characteristics.',
        analogy:
            'Seaborn is to Matplotlib what an automatic camera mode is to full manual photography. Matplotlib gives you complete control over every visual element. Seaborn automates the statistical and aesthetic decisions that experts make — selecting sensible defaults, adding confidence intervals automatically, using colorblind-friendly palettes — so you get publication-quality results with less configuration.',
        example:
            'Seaborn\'s boxplot() automatically shows median, quartiles, and outliers. violinplot() adds the density distribution alongside box plot statistics. heatmap() with annot=True creates annotated correlation matrices in one line. pairplot() creates a grid of scatter plots and histograms for all variable pairs — an entire exploratory analysis in one function call.',
        keyTakeaway:
            'Use Seaborn for exploratory data analysis (EDA) and initial visualization — it produces statistically rich, professional-looking charts quickly. Use Matplotlib for fine-grained customization of final presentation charts. Both work with Pandas DataFrames natively. Many Seaborn functions accept a DataFrame and column names directly: sns.boxplot(data=df, x="category", y="sales").',
        codeSnippet:
            'import seaborn as sns\nimport matplotlib.pyplot as plt\nimport pandas as pd\nimport numpy as np\n\nnp.random.seed(42)\ndf = pd.DataFrame({\n    "region": np.random.choice(["North", "South", "East", "West"], 200),\n    "product": np.random.choice(["A", "B", "C"], 200),\n    "sales": np.random.normal(50000, 15000, 200),\n    "satisfaction": np.random.uniform(2, 5, 200)\n})\n\nfig, axes = plt.subplots(1, 3, figsize=(18, 5))\nfig.suptitle("Sales Analysis — Seaborn", fontsize=14)\n\n# Box plot: sales distribution by region\nsns.boxplot(data=df, x="region", y="sales", ax=axes[0], palette="Set2")\naxes[0].set_title("Sales by Region")\n\n# Violin plot: full distribution shape\nsns.violinplot(data=df, x="product", y="sales", ax=axes[1], palette="Set3")\naxes[1].set_title("Sales Distribution by Product")\n\n# Scatter with regression line\nsns.regplot(data=df, x="satisfaction", y="sales", ax=axes[2],\n            scatter_kws={"alpha": 0.4}, color="#E91E63")\naxes[2].set_title("Satisfaction vs Sales")\n\nplt.tight_layout()\nplt.show()',
      ),
      ConceptLesson(
        title: 'Correlation Heatmaps and Pairplots for EDA',
        definition:
            'Correlation heatmaps visualize the pairwise correlation matrix between all numeric variables simultaneously — revealing which features are related. Pairplots create a grid of scatter plots and histograms for all variable pairs — the fastest comprehensive visual EDA of a new dataset.',
        analogy:
            'A correlation heatmap for a dataset is like an X-ray of the relationships within your data — it shows the invisible skeleton of how variables relate to each other before you have had a chance to look at each pair individually. Strong correlations (near ±1) are immediately visible as intense red or blue cells. Weak correlations (near 0) appear as pale, nearly white cells.',
        example:
            'Before building a house price prediction model, a correlation heatmap reveals: bedrooms and bathrooms are highly correlated (0.87) — using both may add multicollinearity. Square footage and price are highly correlated (0.79) — a strong predictor. Distance from city center and price are negatively correlated (-0.65) — farther means cheaper. These insights directly inform feature selection before any modeling.',
        keyTakeaway:
            'Correlation heatmaps reveal multicollinearity (two features highly correlated with each other) that can hurt model interpretability and stability. Two variables with correlation above 0.9 often contain redundant information — you may need to keep only one for modeling. The heatmap makes this decision obvious visually without requiring explicit testing of each pair.',
        codeSnippet:
            'import seaborn as sns\nimport matplotlib.pyplot as plt\nimport pandas as pd\nimport numpy as np\n\nnp.random.seed(42)\nn = 150\ndf = pd.DataFrame({\n    "price_lakhs": np.random.uniform(30, 200, n),\n    "sqft": np.random.uniform(500, 3000, n),\n    "bedrooms": np.random.randint(1, 6, n),\n    "bathrooms": np.random.randint(1, 4, n),\n    "age_years": np.random.uniform(0, 30, n)\n})\n# Make sqft correlated with price\ndf["price_lakhs"] = df["sqft"] * 0.06 + np.random.normal(0, 10, n)\n\nfig, axes = plt.subplots(1, 2, figsize=(16, 6))\n\n# Correlation heatmap\ncorr_matrix = df.corr()\nsns.heatmap(corr_matrix, annot=True, fmt=".2f",\n            cmap="RdYlGn", center=0, ax=axes[0],\n            square=True, linewidths=0.5)\naxes[0].set_title("Feature Correlation Matrix")\n\n# Distribution of target variable\nsns.histplot(df["price_lakhs"], kde=True, ax=axes[1], color="#3F51B5")\naxes[1].set_title("Price Distribution")\naxes[1].set_xlabel("Price (Lakhs ₹)")\n\nplt.tight_layout()\nplt.show()',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Anscombe\'s Quartet shows four datasets with nearly identical statistical summaries but completely different patterns. What does this demonstrate about data analysis?',
        options: [
          'Statistical summaries are more reliable than visualizations for understanding data',
          'Visualization is non-negotiable — identical statistics can describe completely different underlying relationships, making it dangerous to rely on numbers alone without visual verification',
          'More complex statistics (kurtosis, skewness) always reveal what simple statistics miss',
          'Datasets with the same mean and variance are always similar in their patterns'
        ],
        correctIndex: 1,
        explanation:
            'Anscombe\'s Quartet is a classic demonstration that summary statistics are not sufficient to understand data. A linear trend, a curve, an outlier-driven pattern, and vertical scatter can all produce nearly identical means, variances, and correlations. Visualization reveals the truth that numbers hide.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'You want to compare the DISTRIBUTION of salaries across four different departments simultaneously, showing median, quartiles, and outliers. Which chart type is MOST appropriate?',
        options: [
          'Line chart — to show how salaries change between departments',
          'Box plot — designed specifically to show distribution characteristics (median, IQR, outliers) for multiple categories side by side',
          'Pie chart — to show what percentage of total salary each department represents',
          'Scatter plot — to show all individual salary points'
        ],
        correctIndex: 1,
        explanation:
            'Box plots are specifically designed for distributional comparison across categories — they show the median (center line), interquartile range (box height), range (whiskers), and outliers (points beyond whiskers) for each category simultaneously. This answers "how does the salary distribution differ across departments?" more completely than any other single chart type.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A correlation heatmap shows that two predictor variables in your dataset have a correlation of 0.95 with each other. What should you consider doing BEFORE building a regression model?',
        options: [
          'Nothing — high feature correlation always improves model performance',
          'Consider dropping one of the two highly correlated features — near-perfect correlation (0.95) indicates they carry nearly identical information, and including both can cause multicollinearity that makes model coefficients unstable and hard to interpret',
          'Multiply the two features together to create a combined feature',
          'The model will automatically handle multicollinearity — no action needed'
        ],
        correctIndex: 1,
        explanation:
            'Multicollinearity (high correlation between predictors) can make regression coefficients unstable and hard to interpret — small changes in data can produce large changes in coefficients. Keeping only one of the two correlated features typically retains predictive power while improving model stability and interpretability.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Complete EDA Visualization Report',
      goal:
          'Create a comprehensive visual EDA report for a housing dataset using both Matplotlib and Seaborn.',
      steps: [
        'Generate a housing dataset with 200 rows using NumPy: price_lakhs, sqft, bedrooms, bathrooms, age_years, locality (categorical), and amenities_score.',
        'Create a 3×2 Figure with 6 subplots covering: price distribution (histogram+KDE), price vs sqft scatter with regression, box plots of price by locality, correlation heatmap of all numeric features, bar chart of median price by bedrooms count, and violin plot of price by number of bathrooms.',
        'All plots must have: descriptive titles, axis labels, appropriate colors, and readable tick labels.',
        'Below the plots, print a text summary of 5 key insights extracted from the visualizations (e.g. "Correlation heatmap shows sqft and price strongly correlated at 0.82").',
        'Save the complete dashboard as "housing_eda.png".',
      ],
      expectedOutput:
          '6-panel EDA dashboard saved as housing_eda.png. All plots properly labeled. 5 written insights based on actual patterns in the generated data. Both Matplotlib and Seaborn used appropriately.',
      xpReward: 65,
    ),
  ),
  TopicCourse(
    id: 'python_data_science_mini_project_ds2',
    topicTitle: 'Python Data Science Mini Project',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 60,
    totalXp: 200,
    emoji: '🏆',
    intro:
        'This is your Level 2 capstone — a complete, end-to-end data analysis project using every Python skill you have built throughout this level. You will work with a realistic dataset, apply all your Python and Pandas knowledge, produce meaningful visualizations, and communicate your findings. This project is portfolio-worthy proof of your Python data science proficiency.',
    concepts: [
      ConceptLesson(
        title: 'End-to-End Python Data Science Project Structure',
        definition:
            'A professional Python data science project has clear separation into pipeline stages: configuration and imports, data loading, data validation and cleaning, feature engineering, exploratory analysis and visualization, insight extraction, and report generation — each stage as reusable functions.',
        analogy:
            'A professional data science project structure is like a well-organized recipe book. The introduction explains the ingredients (data) and equipment (imports). Each recipe chapter covers one preparation stage. The final chapter presents the finished dish (insights and report). A reader can open to any chapter and immediately understand what is happening and why.',
        example:
            'The difference between a notebook full of sequential cells and a structured project: in the structured version, load_and_validate_data() can be called independently, tested, and reused. clean_customer_data(df) is predictable and unit-testable. compute_segment_statistics(df) can be called on any cleaned DataFrame. The structured version is what professional teams expect when they review or build on your work.',
        keyTakeaway:
            'Writing your analysis as a collection of well-named, single-purpose functions is what transforms a student notebook into professional code. Even if you are working alone, function-based code is easier to debug, iterate on, and return to after weeks away. Name functions for what they do (clean_missing_values, not process_stuff).',
      ),
      ConceptLesson(
        title: 'Real-World Data Quality Challenges',
        definition:
            'Real datasets always contain a combination of quality issues that require systematic identification and resolution before analysis: missing values, outliers, inconsistent formats, duplicate records, wrong data types, and impossible values — each requiring investigation before deciding how to handle it.',
        analogy:
            'A real dataset\'s quality issues are like a box of unsorted, mixed-condition documents from a filing cabinet that has never been organized. Some documents are complete and clean (ideal records). Some have coffee stains obscuring part of the text (missing values). Some clearly have typos in dates (impossible values). Some are duplicates from the photocopier (duplicate records). Processing all these correctly requires systematic inspection, not just hope.',
        example:
            'Handling a real customer dataset: (1) age column — has NaN, "N/A", and values of 0 and 999 (impossible ages). (2) phone numbers — 10 digits, 11 digits, country codes, formatting varies. (3) transaction dates — mix of formats: "2024-01-15", "15/01/2024", "Jan 15 2024". (4) amounts — some rows have negative values (returns?), some have extremely large values (data entry errors?). Each requires investigation, not automatic fix.',
        keyTakeaway:
            'The correct approach to data quality is investigate first, clean second. Before filling missing age values with the median, check WHY they are missing — are they missing randomly, or is missingness correlated with another variable? Understanding the cause of quality issues often reveals that the "missing" values carry information that a simple fill would destroy.',
      ),
      ConceptLesson(
        title: 'Structuring Your Mini Project Notebook',
        definition:
            'A portfolio-quality Jupyter notebook has clear markdown cells explaining each section\'s purpose and key findings, clean well-commented code cells, visualizations with titles and labels, and a final summary section synthesizing the key insights in plain language.',
        analogy:
            'A portfolio notebook is like a well-written technical report — not just a collection of code outputs. Each section has an introduction (what you are about to do and why), the analysis (your code and outputs), and a discussion (what you found and what it means). A reader who is not a data scientist should be able to read the markdown text and understand the story even without running the code.',
        example:
            'The structure of an excellent mini project notebook: Section 1 (markdown): "Business Context" — why this analysis matters. Section 2: "Data Loading and Overview" — with code and printed summaries plus a markdown cell describing key observations. Section 3: "Data Quality and Cleaning" — with code showing what was found and fixed plus markdown explaining decisions. Section 4: "Analysis" with visualizations. Section 5 (markdown): "Key Insights" — 5 bullet points in plain language.',
        keyTakeaway:
            'Write your insights in plain language that a business stakeholder could read. "The correlation between marketing spend and revenue is 0.73 (Pearson r)" becomes "Higher marketing spend consistently predicts higher revenue — roughly, each additional ₹1 of marketing spend produces ₹8.50 of additional revenue, though this relationship becomes weaker at very high spending levels."',
      ),
      ConceptLesson(
        title: 'Capstone Dataset: Customer Purchase Analysis',
        definition:
            'The capstone project analyzes a simulated e-commerce customer purchase dataset covering 6 months of transactions — applying all Level 2 Python and data science skills to extract actionable business insights.',
        analogy:
            'This capstone is your first complete data investigation — like a trainee detective taking their first solo case. You have all the skills acquired in training (Python, Pandas, visualization). Now you apply them systematically to a real scenario, demonstrating that you can work independently from raw data to actionable insight without a guide telling you each next step.',
        example:
            'The capstone dataset contains: 500 customer purchase transactions with customer_id, purchase_date, product_category, amount, payment_method, city, and customer_age. Common analytical questions: Which product categories drive the most revenue? Are there seasonal patterns in purchase behavior? Which customer segments (by age group and city) are most valuable? What is the distribution of transaction values, and are there outliers?',
        keyTakeaway:
            'Approach the capstone with a hypothesis-driven mindset from Level 1: before looking at the data, write down 3 questions you want to answer. Then use your Python and Pandas skills to answer them. Compare your initial hypotheses to what the data actually shows — the surprises are often the most valuable insights.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'In a professional data science project, what is the PRIMARY benefit of organizing analysis logic as reusable functions rather than sequential notebook cells?',
        options: [
          'Functions run faster than sequential cells in Jupyter',
          'Functions create testable, reusable, maintainable units — if the data format changes, you update one function and all analysis using it automatically updates; you can also test each function independently to verify correctness',
          'Jupyter notebooks require functions for cells longer than 20 lines',
          'Functions automatically document what the code does without any comments'
        ],
        correctIndex: 1,
        explanation:
            'Reusability, testability, and maintainability are the core benefits of function-based code. When a data format changes or a business rule evolves, updating one well-named function propagates that change everywhere it is called. Sequential notebook cells require finding and updating every instance separately — a major source of inconsistencies in data projects.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'You discover that 12% of customer age records are missing (None/NaN). Before filling them all with the median, what should you investigate FIRST?',
        options: [
          'Nothing — 12% missing is acceptable for any analysis',
          'Whether the missingness is related to other variables — if age is disproportionately missing for customers from certain cities or purchasing certain products, filling with the overall median could introduce systematic bias into those groups',
          'Whether the median or mean is a better fill value',
          'Whether to use dropna() or fillna() based on which produces better model accuracy'
        ],
        correctIndex: 1,
        explanation:
            'Missing data mechanisms matter. If age is missing 30% for one city and 2% for others (Missing Not At Random), filling with the overall median imposes the wrong age distribution on that city. Understanding WHY data is missing guides the correct imputation strategy — and sometimes reveals that missingness itself is a meaningful signal.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'During capstone EDA, you find that the "amount" column has mean=4,500 and median=2,200. What does this gap suggest and how should you investigate?',
        options: [
          'The data is incorrect and should be deleted',
          'The distribution is right-skewed — a few very large transactions are pulling the mean far above the median. Visualize with a histogram to see the distribution shape, and use a box plot to identify outliers. Decide whether outliers are legitimate large purchases (keep) or data errors (investigate/remove)',
          'Use the mean for all analysis since it uses all data points',
          'This is normal for any financial dataset and requires no investigation'
        ],
        correctIndex: 1,
        explanation:
            'Mean >> median is the classic right-skewed distribution signature. A few extreme values (legitimate big transactions or data errors) inflate the mean while the median accurately represents the typical transaction. Always visualize to understand whether the skew is real (genuine large orders) or erroneous (data entry mistakes like extra zeros).',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Python Data Science Capstone: Customer Purchase Analysis',
      goal:
          'Complete a full end-to-end customer purchase analysis demonstrating mastery of all Python and data science skills from Level 2.',
      steps: [
        'DATA GENERATION: Use NumPy (seed=42) to create a DataFrame of 500 customer transactions with: customer_id (1-100), purchase_date (random dates Jan-Jun 2024), product_category (5 categories), amount (random, some outliers), payment_method (3 types), city (5 cities), customer_age (with 8% None values). Add deliberate data quality issues: 3 duplicate rows, some inconsistent city capitalizations.',
        'DATA LOADING AND VALIDATION: Write validate_dataset(df) that checks and reports: shape, missing values per column, duplicate rows, data types, and value range summaries.',
        'DATA CLEANING: Write clean_dataset(df) that: removes duplicates, standardizes city names, fills missing ages with median, converts purchase_date to datetime, removes amount outliers (using IQR method). Return clean df and a cleaning report dict.',
        'FEATURE ENGINEERING: Add columns: month, day_of_week, age_group (bins: 18-25, 26-35, 36-50, 50+), amount_tier (Low/Medium/High using quantiles).',
        'ANALYSIS AND VISUALIZATION: Create a 4-panel visualization dashboard showing: monthly revenue trend, revenue by product category (bar), amount distribution by age group (box plot), payment method breakdown (bar with percentages). All with titles and labels.',
        'INSIGHTS REPORT: Compute and print: top 3 revenue cities, highest-value customer segment (age_group x city combination), peak revenue month, most popular payment method for high-value transactions, and percentage of revenue from Premium tier customers. Write a 5-insight summary in plain business language.',
      ],
      expectedOutput:
          '=== PYTHON DATA SCIENCE CAPSTONE — LEVEL 2 ===\nDataset: 500 transactions, 6 months of data\nData Quality Issues Found: 3 duplicates, 8% missing ages, inconsistent cities\nCleaning Applied: All issues resolved\nFeature Engineering: 4 new columns added\nVisualization Dashboard: 4-panel chart saved\n\nKey Business Insights:\n1. [Revenue by city insight]\n2. [Top customer segment insight]\n3. [Seasonal trend insight]\n4. [Payment method insight]\n5. [Customer tier value insight]\n\nLevel 2 Complete — Python for Data Science Mastered.\nReady for Level 3: Statistics and Mathematics for Data Science.',
      xpReward: 100,
    ),
  ),
];
