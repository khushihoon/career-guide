// ══════════════════════════════════════════════════════════════════════
// lib/data/courses/ai_level_4.dart
//
// AI Engineer Path — Level 4: Data Analysis & Data Processing
//
// Goal: Teach learners how to collect, clean, transform, analyze and
// visualize real-world datasets used for Artificial Intelligence and
// Machine Learning.
//
// Uses the shared TopicCourse / ConceptLesson / QuizQuestion / MiniChallenge
// / FinalProject models defined in course_content_data.dart.
// ══════════════════════════════════════════════════════════════════════

import '../../models/course_content_data.dart';

const List<TopicCourse> aiEngineerLevel4 = [

  // ────────────────────────────────────────────────────────────────────
  // 1. INTRODUCTION TO DATA ANALYSIS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'introduction_to_data_analysis',
    topicTitle: 'Introduction to Data Analysis',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '🔍',
    intro: 'Before any AI model can be trained, someone has to find, understand, and prepare the data. Data analysis is that critical first step — and it\'s often said that AI engineers spend 80% of their time on data and only 20% on the actual model. Let\'s learn why.',
    concepts: [
      ConceptLesson(
        title: 'What is Data Analysis?',
        definition: 'Data analysis is the process of inspecting, cleaning, transforming, and modelling data to discover useful information, draw conclusions, and support decision-making.',
        analogy: 'Data analysis is like being a detective at a crime scene. Raw data is scattered evidence — fingerprints, witness statements, footage. Analysis is piecing it all together into a coherent story that answers a real question.',
        example: 'A ride-sharing company analyses millions of trip records to discover that demand spikes every Friday evening near train stations — insight that directly informs pricing and driver allocation.',
        keyTakeaway: 'Data analysis turns raw, messy numbers into actionable insight. It is the foundation every AI/ML project is built on — bad analysis leads to bad models, no matter how advanced the algorithm.',
      ),
      ConceptLesson(
        title: 'The Data Analysis Lifecycle',
        definition: 'A repeatable process: Collect → Clean → Explore → Transform → Visualize → Communicate. Real-world analysis loops through these stages multiple times.',
        analogy: 'It\'s like cooking a meal: gather ingredients (collect), wash and chop them (clean), taste-test as you go (explore), season and cook (transform), plate it nicely (visualize), and finally serve it to guests (communicate).',
        example: 'Analysing customer churn: collect transaction logs → clean missing IDs → explore churn patterns by age group → engineer a "days since last purchase" feature → visualize churn rate by segment → present findings to the product team.',
        keyTakeaway: 'Skipping steps (especially cleaning and exploring) is the #1 reason AI projects fail. A disciplined process beats jumping straight to modelling every time.',
      ),
      ConceptLesson(
        title: 'Why Data Analysis Matters for AI Engineers',
        definition: 'AI models learn patterns FROM data. If the data is wrong, biased, incomplete, or misunderstood, the model will learn the wrong patterns — no matter how sophisticated the algorithm is.',
        analogy: '"Garbage in, garbage out." Even the world\'s best chef can\'t make a great meal with spoiled ingredients. Similarly, even GPT-level architectures can\'t produce good results from bad data.',
        example: 'A loan approval model trained on historical data that under-represents one demographic group will learn and amplify that bias — a failure of data analysis, not algorithm design.',
        keyTakeaway: 'Strong data analysis skills are what separate AI engineers who build reliable, trustworthy systems from those who build fragile ones that fail in the real world.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main goal of data analysis?',
        options: [
          'To make data look colourful',
          'To inspect, clean, transform, and model data to discover useful insights',
          'To delete unnecessary files',
          'To write more code than necessary'
        ],
        correctIndex: 1,
        explanation: 'Data analysis is fundamentally about extracting meaningful, actionable insight from raw data through a structured process of inspection, cleaning, and transformation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why do AI engineers typically spend most of their time on data rather than model building?',
        options: [
          'Because models are easy to build and require no skill',
          'Because data quality directly determines model quality — bad data leads to bad models',
          'Because data analysis is required by law',
          'Because models train themselves automatically'
        ],
        correctIndex: 1,
        explanation: 'Models learn patterns from data. If data is messy, incomplete, or biased, the resulting model inherits those flaws — making data preparation the most impactful part of the AI workflow.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A company wants to skip data cleaning and exploration, jumping straight from raw data collection to training their AI model. What is the most likely outcome?',
        options: [
          'The model will train faster with no downsides',
          'The model will likely learn incorrect patterns from messy or biased data, producing unreliable predictions',
          'This is actually the recommended best practice',
          'It has no effect on model quality'
        ],
        correctIndex: 1,
        explanation: 'Skipping cleaning and exploration means the model trains directly on errors, outliers, and biases hidden in raw data — a leading cause of poor real-world AI performance.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Data Analysis Lifecycle Walkthrough',
      goal: 'Document a complete data analysis lifecycle plan for a real-world scenario.',
      steps: [
        'Choose a scenario (e.g. analysing e-commerce sales data)',
        'Write what data you would COLLECT and from where',
        'List 3 cleaning steps you would perform',
        'List 2 questions you would EXPLORE in the data',
        'List 1 new feature you would TRANSFORM/engineer',
        'Describe how you would VISUALIZE and COMMUNICATE the final insights',
      ],
      expectedOutput: 'A written lifecycle plan covering all 6 stages (Collect, Clean, Explore, Transform, Visualize, Communicate) for the chosen scenario, with specific, realistic details at each stage.',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 2. NUMPY FUNDAMENTALS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'numpy_fundamentals',
    topicTitle: 'NumPy Fundamentals',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🧮',
    intro: 'NumPy is the foundation that almost every Python data science and AI library — Pandas, scikit-learn, PyTorch, TensorFlow — is built on top of. Learning NumPy fundamentals is like learning the alphabet before writing sentences.',
    concepts: [
      ConceptLesson(
        title: 'Why NumPy Instead of Python Lists?',
        definition: 'NumPy provides the ndarray, a fast, memory-efficient array structure optimised for numerical computation, dramatically outperforming standard Python lists for large-scale math.',
        analogy: 'A Python list is like a bag of mixed items you check one by one. A NumPy array is like a perfectly organised warehouse shelf — every item is the same type, in a fixed location, so the forklift (CPU) can grab everything in one efficient sweep.',
        example: 'Adding two lists of 1 million numbers with a Python loop might take seconds. The same operation with NumPy arrays takes milliseconds, because NumPy uses optimised, compiled C code under the hood.',
        keyTakeaway: 'NumPy arrays are faster and more memory-efficient than Python lists because they store data in contiguous memory blocks of a single type, and operations run as vectorised, compiled code.',
        codeSnippet: 'import numpy as np\nimport time\n\n# Python list vs NumPy array speed comparison\npy_list = list(range(1_000_000))\nnp_array = np.arange(1_000_000)\n\n# NumPy vectorized operation (fast)\nresult = np_array * 2',
      ),
      ConceptLesson(
        title: 'Creating Arrays',
        definition: 'NumPy provides many ways to create arrays: from Python lists, with placeholder values (zeros, ones), or with ranges and random values.',
        analogy: 'Creating arrays in NumPy is like choosing different ways to prepare a table for guests — you can set it from an existing list of orders, pre-fill it with blank plates (zeros), or generate a randomised seating chart.',
        example: 'np.zeros((3,3)) creates an empty 3x3 grid. np.arange(0, 10, 2) creates [0,2,4,6,8]. np.random.rand(2,2) creates a 2x2 matrix of random values.',
        keyTakeaway: 'Knowing the right array creation function saves time and avoids manual loops — essential for quickly setting up data structures for AI experiments.',
        codeSnippet: 'a = np.array([1, 2, 3])\nzeros = np.zeros((2, 3))\nones = np.ones((3, 3))\nrange_arr = np.arange(0, 10, 2)\nrandom_arr = np.random.rand(2, 2)\nprint(a, zeros, ones, range_arr, random_arr, sep="\\n")',
      ),
      ConceptLesson(
        title: 'Array Indexing & Slicing',
        definition: 'Indexing accesses individual elements; slicing extracts a sub-range of an array using the start:stop:step syntax.',
        analogy: 'Slicing a NumPy array is like cutting a specific section out of a loaf of bread — you tell it where to start cutting, where to stop, and whether to take every slice or skip some.',
        example: 'arr = np.array([10,20,30,40,50])\narr[1] → 20\narr[1:4] → [20,30,40]\narr[::2] → [10,30,50] (every second element)',
        keyTakeaway: 'Slicing in NumPy does NOT copy data by default — it returns a "view" into the original array. Modifying a slice can modify the original array, a common source of subtle bugs.',
        codeSnippet: 'arr = np.array([10, 20, 30, 40, 50])\nprint(arr[1:4])    # [20 30 40]\nprint(arr[::2])    # [10 30 50]\nprint(arr[-1])     # 50 (last element)',
      ),
      ConceptLesson(
        title: 'Vectorized Operations',
        definition: 'Vectorization means applying an operation to an entire array at once, without writing explicit loops — NumPy handles the looping internally in fast compiled code.',
        analogy: 'A vectorised operation is like a printing press stamping 1,000 pages simultaneously, versus hand-stamping each page one at a time. Same result, dramatically faster.',
        example: 'prices = np.array([100, 200, 300])\ndiscounted = prices * 0.9  # applies to ALL elements at once, no loop needed',
        keyTakeaway: 'Always prefer vectorised NumPy operations over manual Python for-loops when working with numeric data — it is the single biggest performance habit to build as an AI engineer.',
        codeSnippet: 'prices = np.array([100, 200, 300, 400])\ndiscounted = prices * 0.9\nprint(discounted)  # [ 90. 180. 270. 360.]',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why are NumPy arrays generally faster than Python lists for numerical operations?',
        options: [
          'NumPy arrays use less code',
          'NumPy stores data in contiguous memory of a single type and runs vectorised, compiled operations',
          'Python lists are not allowed to store numbers',
          'NumPy arrays automatically use the GPU'
        ],
        correctIndex: 1,
        explanation: 'NumPy arrays are stored efficiently in memory as a single data type and operations are executed using optimised, compiled C code rather than slow Python-level loops.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the slice arr[::2] return for arr = [10, 20, 30, 40, 50]?',
        options: ['[10, 20]', '[10, 30, 50]', '[20, 40]', '[50, 40, 30, 20, 10]'],
        correctIndex: 1,
        explanation: 'The slice [::2] starts at the beginning, goes to the end, and takes every 2nd element: indices 0, 2, 4 → values 10, 30, 50.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You need to double every value in a NumPy array of 1 million numbers. What is the BEST approach?',
        options: [
          'Write a Python for loop that multiplies each element one at a time',
          'Use the vectorised operation array * 2',
          'Convert it to a list first, then loop through it',
          'It cannot be done without external libraries'
        ],
        correctIndex: 1,
        explanation: 'Vectorised operations like array * 2 are dramatically faster than manual loops because NumPy applies the operation to the entire array using optimised compiled code.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'NumPy Array Playground',
      goal: 'Practice core NumPy array creation, indexing, slicing, and vectorised operations.',
      steps: [
        'Create a NumPy array of 20 random integers between 1 and 100',
        'Print the first 5 elements, the last 5 elements, and every 3rd element',
        'Use a vectorised operation to compute the square of every element',
        'Filter the array to keep only values greater than 50 using boolean indexing',
        'Print the mean, max, and min of the original array',
      ],
      expectedOutput: 'First 5: [...]\nLast 5: [...]\nEvery 3rd: [...]\nSquared: [...]\nValues > 50: [...]\nMean: 52.3, Max: 98, Min: 4',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 3. ARRAYS & MATRIX OPERATIONS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'arrays_matrix_operations',
    topicTitle: 'Arrays & Matrix Operations',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '🧱',
    intro: 'Beyond basic arrays, real data analysis requires reshaping, combining, and operating on multi-dimensional arrays. This is where NumPy becomes a true workhorse for preparing datasets for AI models.',
    concepts: [
      ConceptLesson(
        title: 'Reshaping Arrays',
        definition: 'Reshaping changes the dimensions (shape) of an array without changing its underlying data — turning a flat array into a grid, or vice versa.',
        analogy: 'Reshaping is like rearranging the same 12 eggs from a single row of 12 into a tray of 3 rows by 4 columns — same eggs, different arrangement.',
        example: 'A flat array of 12 pixel values can be reshaped into a 3x4 image grid: arr.reshape(3, 4).',
        keyTakeaway: 'Reshaping is essential when feeding data into models — image data, for example, often needs reshaping from a flat vector into a 2D or 3D grid (or vice versa) to match model input requirements.',
        codeSnippet: 'import numpy as np\narr = np.arange(12)\nreshaped = arr.reshape(3, 4)\nprint(reshaped)\n# [[ 0  1  2  3]\n#  [ 4  5  6  7]\n#  [ 8  9 10 11]]',
      ),
      ConceptLesson(
        title: 'Broadcasting',
        definition: 'Broadcasting allows NumPy to perform operations between arrays of different shapes by automatically "stretching" the smaller array to match the larger one, without copying data.',
        analogy: 'Broadcasting is like a single announcement made over a stadium PA system reaching every seat simultaneously — one small piece of information (the scalar) is automatically applied everywhere it\'s needed, without manually repeating it for every seat.',
        example: 'arr = np.array([[1,2,3],[4,5,6]])\narr + 10  → adds 10 to EVERY element, even though 10 is a single scalar, not a matching matrix.',
        keyTakeaway: 'Broadcasting eliminates the need for manual loops when combining arrays of different shapes — but you must understand its rules to avoid unexpected results or shape errors.',
        codeSnippet: 'matrix = np.array([[1, 2, 3], [4, 5, 6]])\nrow_vector = np.array([10, 20, 30])\nresult = matrix + row_vector\nprint(result)\n# [[11 22 33]\n#  [14 25 36]]',
      ),
      ConceptLesson(
        title: 'Stacking & Concatenating Arrays',
        definition: 'Stacking and concatenation combine multiple arrays into a single larger array, either along rows (vertically) or columns (horizontally).',
        analogy: 'Stacking arrays is like joining multiple spreadsheets into one — stacking vertically adds more rows (more records), stacking horizontally adds more columns (more features) for the same records.',
        example: 'np.vstack([a, b]) stacks two arrays as new rows.\nnp.hstack([a, b]) stacks two arrays as new columns.',
        keyTakeaway: 'Combining datasets from multiple sources (e.g. merging this month\'s sales data with last month\'s) frequently requires stacking arrays correctly along the right axis.',
        codeSnippet: 'a = np.array([[1, 2], [3, 4]])\nb = np.array([[5, 6], [7, 8]])\n\nprint(np.vstack([a, b]))  # stacks as new rows\nprint(np.hstack([a, b]))  # stacks as new columns',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does reshaping an array do?',
        options: [
          'Deletes some of the data',
          'Changes the array\'s dimensions/shape without changing its underlying values',
          'Sorts the array in ascending order',
          'Converts the array to a Python list'
        ],
        correctIndex: 1,
        explanation: 'Reshaping rearranges the same data into a new shape (e.g. flat to 2D grid) — the total number of elements stays the same, only the structure changes.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does NumPy broadcasting allow you to do?',
        options: [
          'Delete arrays automatically',
          'Perform operations between differently-shaped arrays by automatically expanding the smaller one',
          'Send data over a network',
          'Convert arrays into matrices only'
        ],
        correctIndex: 1,
        explanation: 'Broadcasting lets NumPy apply operations between arrays of different (but compatible) shapes by virtually "stretching" the smaller array, without manually copying data.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You have a 100x3 matrix of customer data (100 customers, 3 features) and want to add a fixed bias vector of length 3 to every row. What NumPy feature makes this possible in one line?',
        options: ['Reshaping', 'Broadcasting', 'Sorting', 'Concatenation'],
        correctIndex: 1,
        explanation: 'Broadcasting automatically applies the length-3 bias vector to every row of the 100x3 matrix without needing a manual loop — exactly the pattern used when adding bias in neural network layers.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Matrix Reshaping & Combination Toolkit',
      goal: 'Practice reshaping, broadcasting, and stacking using a simulated sensor dataset.',
      steps: [
        'Create a flat NumPy array of 24 random temperature readings',
        'Reshape it into a (4, 6) matrix representing 4 days of 6 hourly readings',
        'Use broadcasting to convert all readings from Celsius to Fahrenheit (F = C * 9/5 + 32)',
        'Create a second (4, 6) matrix of humidity readings and stack it with the temperature matrix using hstack to form a (4, 12) combined matrix',
        'Print the final shape and a few sample rows',
      ],
      expectedOutput: 'Original shape: (24,)\nReshaped: (4, 6)\nFahrenheit conversion applied\nCombined matrix shape: (4, 12)',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 4. PANDAS SERIES & DATAFRAMES
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'pandas_series_dataframes',
    topicTitle: 'Pandas Series & DataFrames',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 140,
    emoji: '🐼',
    intro: 'Pandas is THE tool every data scientist and AI engineer uses to work with real-world tabular data — spreadsheets, CSV files, database exports. If NumPy is the engine, Pandas is the dashboard that makes data manipulation intuitive.',
    concepts: [
      ConceptLesson(
        title: 'What is a Pandas Series?',
        definition: 'A Series is a one-dimensional labelled array in Pandas — like a single column of data with an index attached to each value.',
        analogy: 'A Series is like a single column in a spreadsheet, but with row labels (an index) attached to every value, instead of just a plain list of numbers.',
        example: 'ages = pd.Series([25, 30, 35], index=["Alice", "Bob", "Charlie"])\nages["Bob"] → 30',
        keyTakeaway: 'A Series combines the simplicity of a NumPy array with the convenience of labelled indexing — letting you look up values by meaningful names instead of just position numbers.',
        codeSnippet: 'import pandas as pd\nages = pd.Series([25, 30, 35], index=["Alice", "Bob", "Charlie"])\nprint(ages)\nprint(ages["Bob"])  # 30',
      ),
      ConceptLesson(
        title: 'What is a DataFrame?',
        definition: 'A DataFrame is a 2-dimensional labelled data structure in Pandas — essentially a table with rows and columns, where each column is a Series.',
        analogy: 'A DataFrame is like a full Excel spreadsheet: multiple labelled columns (Series), each row representing one record, all neatly organised and searchable.',
        example: 'df = pd.DataFrame({"name": ["Alice","Bob"], "age": [25,30]})\nThis creates a table with 2 columns (name, age) and 2 rows.',
        keyTakeaway: 'The DataFrame is THE central data structure in nearly all real-world data analysis and AI preprocessing workflows — almost every dataset you load will become a DataFrame.',
        codeSnippet: 'import pandas as pd\ndf = pd.DataFrame({\n    "name": ["Alice", "Bob", "Charlie"],\n    "age": [25, 30, 35],\n    "city": ["Delhi", "Mumbai", "Pune"]\n})\nprint(df)\nprint(df.shape)  # (3, 3)',
      ),
      ConceptLesson(
        title: 'Selecting & Filtering Data',
        definition: 'Pandas lets you select specific columns, rows, or filtered subsets of a DataFrame using label-based (.loc) or position-based (.iloc) indexing, or boolean conditions.',
        analogy: 'Filtering a DataFrame is like using a librarian\'s catalogue system: you can ask for a specific shelf (column), a specific book by title (label), or "all mystery novels published after 2010" (boolean condition).',
        example: 'df[df["age"] > 28] → returns only rows where age is greater than 28.\ndf.loc[0, "name"] → returns the name in row 0.\ndf.iloc[0, 1] → returns the value at row 0, column index 1.',
        keyTakeaway: 'Boolean filtering (df[condition]) is the single most-used Pandas operation in real-world data analysis — it lets you instantly slice large datasets down to exactly what you need.',
        codeSnippet: 'df = pd.DataFrame({"name": ["Alice","Bob","Charlie"], "age": [25,30,35]})\nadults_over_28 = df[df["age"] > 28]\nprint(adults_over_28)\nprint(df.loc[0, "name"])   # Alice\nprint(df.iloc[1, 1])       # 30',
      ),
      ConceptLesson(
        title: 'GroupBy & Aggregation',
        definition: 'GroupBy splits a DataFrame into groups based on a column\'s values, then applies an aggregation function (like sum, mean, count) to each group separately.',
        analogy: 'GroupBy is like sorting a deck of cards by suit, then counting how many cards are in each suit pile — you split, summarise, and report on each group independently.',
        example: 'df.groupby("city")["age"].mean() → calculates the average age for each city, all in one line.',
        keyTakeaway: 'GroupBy + aggregation is one of the most powerful tools for exploratory data analysis — answering questions like "what is the average sales per region?" or "how many customers per category?" instantly.',
        codeSnippet: 'df = pd.DataFrame({\n    "city": ["Delhi","Mumbai","Delhi","Pune"],\n    "sales": [200, 150, 300, 100]\n})\nresult = df.groupby("city")["sales"].sum()\nprint(result)\n# Delhi    500\n# Mumbai   150\n# Pune     100',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is a Pandas DataFrame?',
        options: [
          'A single column of unlabeled numbers',
          'A 2-dimensional labelled data structure resembling a table, made of multiple Series',
          'A type of NumPy array only used for images',
          'A database connection object'
        ],
        correctIndex: 1,
        explanation: 'A DataFrame is a 2D table-like structure with labelled rows and columns, where each column is itself a Pandas Series.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does df[df["age"] > 28] do?',
        options: [
          'Deletes all rows where age is greater than 28',
          'Returns only the rows where the age column value is greater than 28',
          'Creates a new column called "age > 28"',
          'Sorts the DataFrame by age'
        ],
        correctIndex: 1,
        explanation: 'This is boolean filtering — the condition df["age"] > 28 creates a True/False mask, and applying it to df returns only the rows where the condition is True.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does df.groupby("city")["sales"].sum() compute?',
        options: [
          'The total sales across the entire DataFrame, ignoring city',
          'The sum of sales for EACH unique city, separately',
          'The number of cities in the dataset',
          'It deletes the sales column'
        ],
        correctIndex: 1,
        explanation: 'GroupBy splits the data into groups by the "city" column, and .sum() calculates the total sales within each individual group/city.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You need the average exam score for each student, grouped by their class section, from a DataFrame with columns "section" and "score". Which line does this correctly?',
        options: [
          'df["score"].mean()',
          'df.groupby("section")["score"].mean()',
          'df.loc["section"]',
          'df.sort_values("score")'
        ],
        correctIndex: 1,
        explanation: 'groupby("section") splits the data by section, and ["score"].mean() computes the average score within each section group — exactly what\'s needed.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Student Records Analyzer',
      goal: 'Build and analyze a Pandas DataFrame of student records.',
      steps: [
        'Create a DataFrame with columns: name, section, score, attendance for 10 students',
        'Filter and print all students with score >= 80',
        'Use groupby to print the average score per section',
        'Use .loc to print the full record of the top-scoring student',
        'Add a new column "passed" that is True if score >= 40, else False',
      ],
      expectedOutput: 'High scorers: [...]\nAverage score per section: A: 78.5, B: 82.1\nTop student record: {...}\nDataFrame now includes a "passed" boolean column',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 5. DATA CLEANING TECHNIQUES
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'data_cleaning_techniques',
    topicTitle: 'Data Cleaning Techniques',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '🧹',
    intro: 'Real-world data is messy — duplicate records, inconsistent formatting, typos, and impossible values are everywhere. Data cleaning is the unglamorous but absolutely essential skill that determines whether your AI model succeeds or fails.',
    concepts: [
      ConceptLesson(
        title: 'Why Real-World Data is Messy',
        definition: 'Data collected from forms, sensors, APIs, and human entry is rarely perfectly clean — it commonly contains duplicates, typos, inconsistent formats, and invalid values.',
        analogy: 'Raw collected data is like ingredients fresh from a farm — covered in dirt, with some rotten pieces mixed in. You can\'t cook with it directly; it needs washing and sorting first.',
        example: 'A "country" column might contain "India", "india", "IN", and "Bharat" — all referring to the same country, but appearing as 4 different values to a computer.',
        keyTakeaway: 'Expect every real dataset to be messy. Building the habit of inspecting data BEFORE analysing it saves enormous time and prevents misleading results.',
        codeSnippet: 'import pandas as pd\ndf = pd.read_csv("data.csv")\nprint(df.info())          # data types and missing values\nprint(df.describe())      # summary statistics\nprint(df.duplicated().sum())  # count of duplicate rows',
      ),
      ConceptLesson(
        title: 'Removing Duplicates',
        definition: 'Duplicate rows are identical or near-identical records that can skew statistics and bias model training if not removed.',
        analogy: 'Counting duplicate survey responses as if they were unique opinions is like counting one person\'s vote multiple times in an election — it distorts the true result.',
        example: 'A customer dataset where the same purchase was accidentally logged twice will inflate total sales figures unless duplicates are removed.',
        keyTakeaway: 'Always check for and handle duplicates early — df.duplicated() and df.drop_duplicates() are two of the most commonly used Pandas cleaning functions.',
        codeSnippet: 'df = pd.DataFrame({"id": [1,2,2,3], "name": ["A","B","B","C"]})\nprint(df.duplicated())          # flags duplicate rows\ndf_clean = df.drop_duplicates()\nprint(df_clean)',
      ),
      ConceptLesson(
        title: 'Fixing Inconsistent Formatting',
        definition: 'Inconsistent formatting (different capitalisation, whitespace, units, or date formats) makes identical values appear as different categories to a computer.',
        analogy: 'Imagine a filing cabinet where "New York", "new york", and " New York " are treated as 3 completely different cities just because of capitalisation and spacing. A human reader sees they\'re the same — but a computer needs cleaning to see it too.',
        example: 'df["city"] = df["city"].str.strip().str.lower() standardises all city names to lowercase with no extra whitespace, merging what would otherwise be treated as separate categories.',
        keyTakeaway: 'Standardising text formatting (case, whitespace, units) is one of the highest-impact, lowest-effort cleaning steps — it directly prevents the model from treating identical categories as different ones.',
        codeSnippet: 'df = pd.DataFrame({"city": [" New York", "new york", "NEW YORK "]})\ndf["city_clean"] = df["city"].str.strip().str.lower()\nprint(df["city_clean"].unique())  # array([\'new york\'], dtype=object)',
      ),
      ConceptLesson(
        title: 'Detecting & Handling Outliers',
        definition: 'Outliers are data points that differ significantly from the rest of the data — sometimes real (a billionaire\'s income) and sometimes errors (a typo entering age as 999).',
        analogy: 'An outlier is like one person showing up to a kids\' birthday party who is 9 feet tall — it could be a legitimate giant, or someone accidentally measured wrong. You investigate before deciding what to do.',
        example: 'Using the IQR method: values below Q1 - 1.5*IQR or above Q3 + 1.5*IQR are flagged as potential outliers for review.',
        keyTakeaway: 'Never blindly delete outliers — investigate first. Some outliers are valuable signal (fraud detection relies on them!), others are simple data entry errors that need correcting or removing.',
        codeSnippet: 'Q1 = df["income"].quantile(0.25)\nQ3 = df["income"].quantile(0.75)\nIQR = Q3 - Q1\noutliers = df[(df["income"] < Q1 - 1.5*IQR) | (df["income"] > Q3 + 1.5*IQR)]\nprint(outliers)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why is removing duplicate rows important before analysis?',
        options: [
          'It makes the file size smaller, which is the only benefit',
          'Duplicates can skew statistics and bias the model by over-representing certain records',
          'Duplicates are not actually a problem in data analysis',
          'It is required to convert CSV files to Excel'
        ],
        correctIndex: 1,
        explanation: 'Duplicate records artificially inflate the importance of certain data points, distorting summary statistics and potentially biasing a trained model toward over-represented patterns.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why might "New York", "new york", and "NEW YORK " be treated as 3 different categories by a computer?',
        options: [
          'They are different cities',
          'Computers are case-sensitive and whitespace-sensitive by default unless text is standardised',
          'This never happens in real datasets',
          'Pandas automatically merges them'
        ],
        correctIndex: 1,
        explanation: 'Without explicit cleaning (lowercasing, trimming whitespace), a computer treats differently-formatted strings as entirely distinct values, even if a human would recognise them as the same.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You find that a dataset has an "age" column with a value of 999 for one record, while all other ages are between 1-100. What is the BEST first step?',
        options: [
          'Immediately delete the entire dataset',
          'Investigate the record — it is likely a data entry error or placeholder value that needs correction, not necessarily deletion',
          'Assume it is correct and proceed with analysis',
          'Replace ALL ages in the dataset with 999'
        ],
        correctIndex: 1,
        explanation: 'A value of 999 is a classic "placeholder for missing data" pattern used by some systems. Investigating first (rather than blindly deleting or keeping it) is the professional approach to outlier handling.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Messy Dataset Cleanup',
      goal: 'Clean a realistically messy customer dataset using Pandas.',
      steps: [
        'Create a DataFrame with intentionally messy data: duplicate rows, inconsistent city capitalisation/whitespace, and one obvious outlier age value (e.g. 250)',
        'Detect and remove duplicate rows',
        'Standardise the city column (strip whitespace, lowercase)',
        'Detect the outlier age using the IQR method and replace it with the column median',
        'Print a "before" and "after" summary showing row count, unique cities, and age statistics',
      ],
      expectedOutput: 'Before: 12 rows, 5 unique city spellings, max age=250\nAfter: 10 rows, 3 unique cities, max age=58\nCleaning complete.',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 6. HANDLING MISSING VALUES
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'handling_missing_values',
    topicTitle: 'Handling Missing Values',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '❓',
    intro: 'Missing data is one of the most common and most dangerous problems in real datasets. Handle it wrong, and you can silently corrupt every model trained on that data. This lesson teaches you to handle missing values like a professional.',
    concepts: [
      ConceptLesson(
        title: 'Why Data Goes Missing',
        definition: 'Missing values occur for many reasons: sensors fail, users skip optional form fields, data gets lost during transfer, or some values simply don\'t apply to certain records.',
        analogy: 'Missing data is like blank spaces in a survey — sometimes a person skipped a question intentionally (not applicable to them), sometimes the form glitched, and sometimes the answer was lost in transit. Understanding WHY helps decide HOW to handle it.',
        example: 'A "spouse_name" field is naturally empty for unmarried respondents (Missing Not At Random) versus a "income" field that\'s randomly missing due to a survey glitch (Missing At Random).',
        keyTakeaway: 'Understanding WHY data is missing (the missingness pattern) is just as important as knowing it IS missing — it determines the correct strategy to handle it.',
        codeSnippet: 'import pandas as pd\ndf = pd.read_csv("data.csv")\nprint(df.isnull().sum())          # count missing per column\nprint(df.isnull().mean() * 100)   # percentage missing per column',
      ),
      ConceptLesson(
        title: 'Detecting Missing Values',
        definition: 'Before fixing missing data, you must systematically detect where it occurs — which columns, how much, and whether there are patterns.',
        analogy: 'Detecting missing values is like a building inspector checking every room for leaks before deciding which repairs are needed — you map the problem fully before fixing anything.',
        example: 'df.isnull().sum() instantly shows exactly how many missing values exist in each column, letting you prioritise which columns need the most attention.',
        keyTakeaway: 'Never assume a dataset is complete — always run df.isnull().sum() (or equivalent) as one of the very first steps when loading any new dataset.',
        codeSnippet: 'df = pd.DataFrame({"age": [25, None, 30], "income": [50000, 60000, None]})\nprint(df.isnull())\nprint(df.isnull().sum())\n# age       1\n# income    1',
      ),
      ConceptLesson(
        title: 'Strategies: Drop vs Impute',
        definition: 'You can DROP rows/columns with missing values, or IMPUTE (fill in) reasonable estimated values — the right choice depends on how much data is missing and why.',
        analogy: 'If only 1 question out of 100 on a survey is unanswered by a few people, you fill in a reasonable estimate (impute). If someone left 95 out of 100 questions blank, you probably discard their whole survey (drop) — it\'s not reliable enough to use.',
        example: 'Dropping: df.dropna() removes rows with ANY missing values.\nImputing: df["age"].fillna(df["age"].median()) fills missing ages with the median age.',
        keyTakeaway: 'Dropping is simple but can lose valuable data and introduce bias if missingness isn\'t random. Imputation preserves more data but introduces assumptions — always document which strategy you used and why.',
        codeSnippet: 'df = pd.DataFrame({"age": [25, None, 30, None, 40]})\n\n# Strategy 1: Drop rows with missing values\ndf_dropped = df.dropna()\n\n# Strategy 2: Impute with median\ndf_imputed = df.copy()\ndf_imputed["age"] = df_imputed["age"].fillna(df["age"].median())\nprint(df_imputed)',
      ),
      ConceptLesson(
        title: 'Advanced Imputation Techniques',
        definition: 'Beyond simple mean/median fill, advanced imputation uses other columns or similar records to make a smarter estimate of the missing value.',
        analogy: 'Instead of guessing a missing house price using the average of ALL houses (simple imputation), advanced imputation looks at SIMILAR houses (same size, same neighbourhood) to make a much more accurate guess.',
        example: 'Group-based imputation: df["income"].fillna(df.groupby("city")["income"].transform("median")) fills missing income using the median income for that person\'s specific city, rather than the entire dataset\'s median.',
        keyTakeaway: 'Simple imputation (mean/median) is a fast starting point, but for AI models where accuracy matters, group-based or model-based imputation often produces significantly better results.',
        codeSnippet: 'df = pd.DataFrame({\n    "city": ["Delhi","Mumbai","Delhi","Mumbai"],\n    "income": [50000, None, 55000, 70000]\n})\ndf["income"] = df["income"].fillna(\n    df.groupby("city")["income"].transform("median")\n)\nprint(df)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does df.isnull().sum() return?',
        options: [
          'The total number of rows in the dataset',
          'The count of missing (null) values in each column',
          'The sum of all numeric values',
          'A list of duplicate rows'
        ],
        correctIndex: 1,
        explanation: 'isnull() creates a True/False mask for missing values, and .sum() counts the True values per column, giving you the number of missing entries in each column.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'When is dropping rows with missing values generally NOT a good strategy?',
        options: [
          'When less than 1% of data is missing randomly',
          'When a large percentage of data is missing, since dropping would discard too much valuable information',
          'It is always the best strategy regardless of how much is missing',
          'Dropping is never acceptable in any scenario'
        ],
        correctIndex: 1,
        explanation: 'If a large fraction of your dataset has missing values, dropping rows could remove a huge, potentially biased chunk of your data — imputation is usually preferred in that case.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A dataset has a "salary" column that is missing for 40% of rows, and missingness appears random (no clear pattern). What is generally the SAFER first approach?',
        options: [
          'Drop all rows with missing salary, losing 40% of the dataset',
          'Impute the missing values (e.g. with median or group-based estimates) to preserve more data',
          'Delete the entire salary column',
          'Replace all missing values with 0'
        ],
        correctIndex: 1,
        explanation: 'With 40% missing, dropping would discard a huge portion of valuable data. Since the missingness appears random, imputation is the safer choice to preserve dataset size while filling reasonable estimates.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Missing Data Handler',
      goal: 'Build a Pandas pipeline that detects and handles missing values using multiple strategies.',
      steps: [
        'Create a DataFrame of 15 employee records with "department", "age", and "salary" columns, intentionally including several missing values',
        'Print a missing value report (count and percentage per column)',
        'For "age", fill missing values using the overall median',
        'For "salary", fill missing values using the group-based median per "department"',
        'Print a final confirmation that no missing values remain',
      ],
      expectedOutput: 'Missing value report:\nage: 3 (20%)\nsalary: 4 (27%)\n\nAfter imputation:\nage missing: 0\nsalary missing: 0\nAll missing values successfully handled.',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 7. DATA TRANSFORMATION
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'data_transformation',
    topicTitle: 'Data Transformation',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '🔄',
    intro: 'Raw, clean data still isn\'t always ready for AI models. Data transformation reshapes, rescales, and recodes data into the exact format machine learning algorithms expect — a critical bridge between cleaned data and a trainable dataset.',
    concepts: [
      ConceptLesson(
        title: 'Encoding Categorical Variables',
        definition: 'Most machine learning algorithms require numeric input, so categorical (text-based) variables must be converted into numbers through encoding.',
        analogy: 'A model can\'t understand the word "red" any more than a calculator can — encoding is like assigning each colour a numeric code (red=1, blue=2, green=3) so the math can actually be computed.',
        example: 'One-Hot Encoding turns a "color" column with values [red, blue, green] into 3 separate binary columns: is_red, is_blue, is_green.',
        keyTakeaway: 'Label Encoding (assigning 0,1,2...) works for ordinal data with a natural order (e.g. "low/medium/high"). One-Hot Encoding is preferred for non-ordinal categories to avoid implying a false numeric order.',
        codeSnippet: 'import pandas as pd\ndf = pd.DataFrame({"color": ["red", "blue", "green", "red"]})\nencoded = pd.get_dummies(df["color"], prefix="color")\nprint(encoded)\n#    color_blue  color_green  color_red\n# 0       False        False       True\n# ...',
      ),
      ConceptLesson(
        title: 'Feature Scaling — Normalization & Standardization',
        definition: 'Scaling transforms numeric features to a common range or distribution, preventing features with large numeric ranges from dominating those with small ranges.',
        analogy: 'Imagine comparing a person\'s height in centimetres (150-200) against their age in years (1-100) without scaling — height would unfairly dominate any distance-based calculation simply because its numbers are bigger. Scaling levels the playing field.',
        example: 'Normalization (Min-Max scaling): rescales values to a 0-1 range.\nStandardization (Z-score): rescales values to have mean=0, std dev=1.',
        keyTakeaway: 'Many ML algorithms (KNN, gradient descent-based models, neural networks) perform significantly better — and train faster — when features are scaled to similar ranges before training.',
        codeSnippet: 'import numpy as np\ndata = np.array([10, 200, 1500, 50])\n\n# Min-Max Normalization\nnormalized = (data - data.min()) / (data.max() - data.min())\n\n# Standardization (Z-score)\nstandardized = (data - data.mean()) / data.std()\nprint(normalized)\nprint(standardized)',
      ),
      ConceptLesson(
        title: 'Applying Custom Transformations',
        definition: 'Pandas\' .apply() and .map() functions let you apply any custom function to transform a column\'s values, far beyond built-in operations.',
        analogy: 'apply() is like handing every item on a conveyor belt to a custom machine you built yourself — it can do whatever transformation logic you need, not just the standard pre-built options.',
        example: 'df["age_group"] = df["age"].apply(lambda x: "Senior" if x >= 60 else "Adult" if x >= 18 else "Minor")',
        keyTakeaway: 'apply() gives you full flexibility for custom business logic — turning raw numbers into meaningful, model-ready categories or derived values.',
        codeSnippet: 'df = pd.DataFrame({"age": [15, 25, 65, 45]})\ndf["age_group"] = df["age"].apply(\n    lambda x: "Senior" if x >= 60 else "Adult" if x >= 18 else "Minor"\n)\nprint(df)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why do machine learning algorithms typically require categorical variables to be encoded as numbers?',
        options: [
          'Encoding makes the dataset file smaller',
          'Most ML algorithms perform mathematical operations and cannot directly process text categories',
          'Encoding is only needed for image data',
          'It is purely a stylistic choice with no functional reason'
        ],
        correctIndex: 1,
        explanation: 'Machine learning algorithms compute mathematical operations (distances, weighted sums, gradients) that require numeric inputs — text categories must be converted to numbers first.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does Min-Max Normalization do to a feature?',
        options: [
          'Removes the feature entirely',
          'Rescales the feature values into a fixed range, typically 0 to 1',
          'Converts numeric data into text categories',
          'Doubles every value in the column'
        ],
        correctIndex: 1,
        explanation: 'Min-Max Normalization rescales data using (x - min) / (max - min), compressing all values into a 0-1 range while preserving their relative relationships.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A dataset has "house_size" ranging from 500-5000 sqft and "num_bedrooms" ranging from 1-5. Without scaling, what problem could occur in a distance-based ML algorithm like KNN?',
        options: [
          'No problem at all — scaling is never necessary',
          'house_size would dominate distance calculations purely because its numeric range is much larger, even if num_bedrooms is equally or more important',
          'The algorithm would refuse to run',
          'num_bedrooms would always be considered more important'
        ],
        correctIndex: 1,
        explanation: 'Distance-based algorithms compute differences between feature values directly. Without scaling, a feature with a large numeric range (house_size) will dominate the distance calculation regardless of its actual predictive importance.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Feature Transformation Pipeline',
      goal: 'Build a complete transformation pipeline preparing a dataset for machine learning.',
      steps: [
        'Create a DataFrame with columns: city (categorical), age (numeric), income (numeric, large range)',
        'One-hot encode the city column using pd.get_dummies',
        'Standardize the age and income columns using Z-score standardization',
        'Use .apply() to create a new "income_bracket" column (Low/Medium/High) based on the original income values',
        'Print the final transformed DataFrame, confirming all columns are now numeric except the new bracket labels',
      ],
      expectedOutput: 'Original columns: city, age, income\nAfter transformation: city_Delhi, city_Mumbai, ..., age (standardized), income (standardized), income_bracket\nAll numeric features scaled successfully.',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 8. FEATURE ENGINEERING BASICS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'feature_engineering_basics',
    topicTitle: 'Feature Engineering Basics',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 140,
    emoji: '⚙️',
    intro: 'Feature engineering is widely considered the single highest-leverage skill in applied machine learning. A great feature can boost model accuracy more than switching to a fancier algorithm — this lesson teaches you to think like a feature engineer.',
    concepts: [
      ConceptLesson(
        title: 'What is Feature Engineering?',
        definition: 'Feature engineering is the process of using domain knowledge to create new input variables (features) from raw data that make machine learning models more accurate.',
        analogy: 'Raw ingredients (flour, eggs, sugar) are like raw data. A skilled baker (feature engineer) combines them in the right way to create something far more useful (a cake) than the raw ingredients alone — the model is the oven that bakes it into a prediction.',
        example: 'Raw data: "purchase_date" timestamp. Engineered features: day_of_week, is_weekend, days_since_last_purchase — each potentially far more predictive than the raw timestamp alone.',
        keyTakeaway: 'Models don\'t automatically know what matters — feature engineering is how YOU inject domain knowledge and intuition into the data the model sees.',
      ),
      ConceptLesson(
        title: 'Creating Features from Dates & Time',
        definition: 'Raw date/time values are rarely useful directly — but they hide many powerful derived features like day of week, month, season, or time since an event.',
        analogy: 'A single date like "2024-12-25" doesn\'t tell a model much directly, but breaking it apart reveals rich signal: it\'s a Wednesday, in December, and a major holiday — each of which might strongly affect sales predictions.',
        example: 'df["day_of_week"] = df["date"].dt.dayofweek\ndf["is_weekend"] = df["day_of_week"].isin([5, 6])\ndf["month"] = df["date"].dt.month',
        keyTakeaway: 'Date/time feature engineering is one of the highest-impact techniques in real-world AI projects — especially for sales forecasting, fraud detection, and user behaviour modelling.',
        codeSnippet: 'import pandas as pd\ndf = pd.DataFrame({"date": pd.to_datetime(["2024-12-25", "2024-07-04"])})\ndf["day_of_week"] = df["date"].dt.day_name()\ndf["month"] = df["date"].dt.month\ndf["is_weekend"] = df["date"].dt.dayofweek >= 5\nprint(df)',
      ),
      ConceptLesson(
        title: 'Binning & Combining Features',
        definition: 'Binning groups continuous numeric values into discrete categories (buckets). Combining features creates new variables by mathematically merging two or more existing columns.',
        analogy: 'Binning is like converting an exact exam score (87) into a letter grade (B+) — sometimes a simplified category is more useful and interpretable than the precise number. Combining is like calculating "speed" from "distance" and "time" — a new feature that\'s more meaningful than either alone.',
        example: 'Binning: df["age_group"] = pd.cut(df["age"], bins=[0,18,35,60,100], labels=["Teen","Young Adult","Adult","Senior"])\nCombining: df["bmi"] = df["weight_kg"] / (df["height_m"] ** 2)',
        keyTakeaway: 'Combining existing features into a new, more meaningful one (like BMI from height and weight) often captures relationships that raw individual features cannot express alone.',
        codeSnippet: 'import pandas as pd\ndf = pd.DataFrame({"age": [15, 25, 45, 70]})\ndf["age_group"] = pd.cut(\n    df["age"], bins=[0,18,35,60,100],\n    labels=["Teen","Young Adult","Adult","Senior"]\n)\nprint(df)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the primary purpose of feature engineering?',
        options: [
          'To make datasets smaller',
          'To use domain knowledge to create new input variables that improve model accuracy',
          'To delete unnecessary rows',
          'To convert data into a CSV file'
        ],
        correctIndex: 1,
        explanation: 'Feature engineering injects domain expertise into the dataset by creating new, more informative variables, often improving model performance more than algorithm changes alone.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is "is_weekend" often a more useful feature than the raw purchase date for predicting sales?',
        options: [
          'It is not actually more useful',
          'It captures a clear behavioural pattern (weekend vs weekday spending) that the raw date does not directly express',
          'Raw dates cannot be used in models at all',
          'It makes the dataset load faster'
        ],
        correctIndex: 1,
        explanation: 'A raw date is just a timestamp, but "is_weekend" directly encodes a meaningful behavioural pattern that often correlates strongly with spending habits — making it easier for the model to learn from.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You have "height_cm" and "weight_kg" columns and want to create a single feature that captures body composition better than either column alone. What should you do?',
        options: [
          'Delete both columns',
          'Combine them into a new feature like BMI = weight_kg / (height_m)^2',
          'Keep them completely unchanged — combining features is never useful',
          'Convert both to categorical text values'
        ],
        correctIndex: 1,
        explanation: 'Combining height and weight into BMI creates a new feature that captures the relationship between the two raw variables — often more predictive for health-related models than either column alone.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Feature Engineering Workshop',
      goal: 'Engineer multiple new features from a raw e-commerce transactions dataset.',
      steps: [
        'Create a DataFrame with columns: purchase_date, amount, customer_age',
        'Engineer date features: day_of_week, month, is_weekend',
        'Engineer a binned feature: age_group from customer_age using pd.cut',
        'Engineer a combined feature: amount_per_age_year = amount / customer_age',
        'Print the final DataFrame showing all original and newly engineered columns',
      ],
      expectedOutput: 'Original columns: purchase_date, amount, customer_age\nNew columns: day_of_week, month, is_weekend, age_group, amount_per_age_year\nFeature engineering complete — 5 new predictive features created.',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 9. DATA VISUALIZATION WITH MATPLOTLIB
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'data_visualization_matplotlib',
    topicTitle: 'Data Visualization with Matplotlib',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '📈',
    intro: 'A picture is worth a thousand rows of data. Matplotlib is Python\'s foundational plotting library — the tool every AI engineer uses to instantly spot patterns, trends, and problems that would be invisible in raw numbers alone.',
    concepts: [
      ConceptLesson(
        title: 'Why Visualization Matters in AI',
        definition: 'Visualization transforms abstract numbers into visual patterns that the human brain can interpret instantly — critical for understanding data and diagnosing model behaviour.',
        analogy: 'Staring at a spreadsheet of 10,000 numbers to find a trend is like trying to recognise a friend\'s face by reading a list of pixel colour codes. A chart instantly reveals what raw numbers hide.',
        example: 'Anscombe\'s Quartet: 4 datasets with nearly identical statistics (mean, variance, correlation) but completely different shapes — only visible when plotted, invisible in the raw statistics.',
        keyTakeaway: 'Always visualise your data before and after modelling. Statistics alone can be deeply misleading; a single chart often reveals what numbers hide.',
      ),
      ConceptLesson(
        title: 'Line & Bar Charts',
        definition: 'Line charts show trends over a continuous variable (often time). Bar charts compare quantities across discrete categories.',
        analogy: 'A line chart is like a heart rate monitor — tracking continuous change over time. A bar chart is like a leaderboard — comparing distinct, separate competitors side by side.',
        example: 'Use a line chart to show monthly revenue trends over a year. Use a bar chart to compare revenue across 5 different product categories.',
        keyTakeaway: 'Choosing the right chart type for your data structure (continuous trend vs categorical comparison) is essential for clear, honest communication of insights.',
        codeSnippet: 'import matplotlib.pyplot as plt\n\nmonths = ["Jan","Feb","Mar","Apr"]\nrevenue = [12000, 15000, 11000, 18000]\n\nplt.plot(months, revenue, marker="o")\nplt.title("Monthly Revenue Trend")\nplt.xlabel("Month")\nplt.ylabel("Revenue (₹)")\nplt.show()',
      ),
      ConceptLesson(
        title: 'Histograms & Scatter Plots',
        definition: 'A histogram shows the distribution (shape and spread) of a single numeric variable. A scatter plot shows the relationship between two numeric variables.',
        analogy: 'A histogram is like a height-sorted lineup photo of an entire class — showing how many students fall into each height range. A scatter plot is like plotting each student\'s height against their shoe size, revealing whether the two are related.',
        example: 'A histogram of customer ages reveals whether your user base skews young or old. A scatter plot of "ad spend" vs "sales" reveals whether more spending correlates with more sales.',
        keyTakeaway: 'Histograms are essential for understanding distributions before choosing models or transformations. Scatter plots are essential for visually spotting correlations and outliers between two variables.',
        codeSnippet: 'import numpy as np\nimport matplotlib.pyplot as plt\n\nages = np.random.normal(35, 10, 500)\nplt.hist(ages, bins=20, color="skyblue", edgecolor="black")\nplt.title("Customer Age Distribution")\nplt.show()\n\nad_spend = np.random.rand(50) * 1000\nsales = ad_spend * 2 + np.random.normal(0, 100, 50)\nplt.scatter(ad_spend, sales)\nplt.xlabel("Ad Spend")\nplt.ylabel("Sales")\nplt.show()',
      ),
      ConceptLesson(
        title: 'Customizing & Saving Plots',
        definition: 'Matplotlib allows extensive customisation — titles, labels, colours, legends, gridlines — and the ability to save plots as image files for reports and presentations.',
        analogy: 'A raw, unlabeled chart is like a map with no street names or legend — technically correct, but useless to anyone else. Customisation turns a chart into clear communication.',
        example: 'plt.legend(), plt.grid(True), and plt.savefig("chart.png") are essential finishing touches that make charts presentation-ready for stakeholders.',
        keyTakeaway: 'A professional chart always has a title, axis labels, and (when needed) a legend. Never share an unlabeled chart in a professional AI report — context is everything.',
        codeSnippet: 'plt.plot([1,2,3], [4,5,6], label="Revenue")\nplt.plot([1,2,3], [3,4,8], label="Costs")\nplt.title("Revenue vs Costs")\nplt.xlabel("Quarter")\nplt.ylabel("Amount (₹)")\nplt.legend()\nplt.grid(True)\nplt.savefig("revenue_vs_costs.png")\nplt.show()',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'When should you use a line chart instead of a bar chart?',
        options: [
          'When comparing distinct, unordered categories',
          'When showing a trend over a continuous variable like time',
          'Line charts and bar charts are always interchangeable',
          'Only when working with text data'
        ],
        correctIndex: 1,
        explanation: 'Line charts are ideal for showing continuous trends (like revenue over months), while bar charts are better suited for comparing distinct, separate categories.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does a histogram show?',
        options: [
          'The relationship between two numeric variables',
          'The distribution (shape and spread) of a single numeric variable',
          'A comparison between text categories only',
          'A map of geographic data'
        ],
        correctIndex: 1,
        explanation: 'A histogram bins a single numeric variable into ranges and shows the frequency (count) of values falling into each range — revealing the distribution\'s shape.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You want to visually check if there is a relationship between "hours studied" and "exam score" for 200 students. Which chart type is the BEST choice?',
        options: ['A bar chart', 'A scatter plot', 'A pie chart', 'A single line chart with no markers'],
        correctIndex: 1,
        explanation: 'A scatter plot is specifically designed to reveal the relationship between two numeric variables, making it ideal for visually checking correlation between hours studied and exam scores.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Sales Dashboard with Matplotlib',
      goal: 'Build a multi-chart sales analysis dashboard using Matplotlib.',
      steps: [
        'Create synthetic monthly sales data for 12 months using NumPy',
        'Create a line chart showing the monthly sales trend, with title and axis labels',
        'Create a bar chart comparing total sales across 4 product categories',
        'Create a histogram showing the distribution of 500 simulated individual transaction amounts',
        'Create a scatter plot showing the relationship between marketing spend and sales for 50 simulated data points',
        'Save all 4 charts as image files',
      ],
      expectedOutput: '4 charts generated and saved: sales_trend.png, category_comparison.png, transaction_distribution.png, spend_vs_sales.png',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 10. DATA VISUALIZATION WITH SEABORN
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'data_visualization_seaborn',
    topicTitle: 'Data Visualization with Seaborn',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '🎻',
    intro: 'Seaborn is built on top of Matplotlib but specialises in statistical visualisation, working seamlessly with Pandas DataFrames. It\'s the go-to tool for AI engineers doing serious exploratory data analysis — beautiful charts with far less code.',
    concepts: [
      ConceptLesson(
        title: 'Why Seaborn Over Plain Matplotlib?',
        definition: 'Seaborn provides high-level functions for common statistical plots, works directly with DataFrames, and applies attractive default styling automatically.',
        analogy: 'If Matplotlib is a fully manual camera where you control every setting yourself, Seaborn is a smart camera with excellent auto-settings built specifically for statistical photography — faster, and the results look professional by default.',
        example: 'Plotting a correlation heatmap in plain Matplotlib takes many lines of manual setup. In Seaborn: sns.heatmap(df.corr(), annot=True) does it in one line.',
        keyTakeaway: 'Use Seaborn for fast, statistically-aware exploratory visualisations during data analysis. Use plain Matplotlib when you need fine, custom control for final presentation-quality charts.',
        codeSnippet: 'import seaborn as sns\nimport pandas as pd\n\ndf = pd.DataFrame({"age": [25,30,35,40], "income": [40000,55000,60000,80000]})\nsns.scatterplot(data=df, x="age", y="income")',
      ),
      ConceptLesson(
        title: 'Distribution Plots — Histplot & Boxplot',
        definition: 'Seaborn\'s histplot shows the distribution of a numeric variable with statistical enhancements. Boxplot summarises a distribution using quartiles, the median, and outliers, in one compact visual.',
        analogy: 'A boxplot is like a 5-number medical summary card (minimum, lower range, median, upper range, maximum) at a glance — quickly telling a doctor (or data analyst) the overall health of the data, including any unusual extreme values (outliers).',
        example: 'sns.boxplot(data=df, x="department", y="salary") instantly shows the median, spread, and outliers of salary FOR EACH department, side by side.',
        keyTakeaway: 'Boxplots are one of the fastest ways to spot outliers and compare distributions across multiple categories — an essential tool in any AI engineer\'s EDA toolkit.',
        codeSnippet: 'import seaborn as sns\nimport pandas as pd\n\ndf = pd.DataFrame({\n    "department": ["Eng","Eng","Sales","Sales","Eng","Sales"],\n    "salary": [80000, 95000, 60000, 65000, 110000, 58000]\n})\nsns.boxplot(data=df, x="department", y="salary")',
      ),
      ConceptLesson(
        title: 'Correlation Heatmaps',
        definition: 'A heatmap visualises a matrix of values using colour intensity — most commonly used in AI to show correlation coefficients between every pair of numeric features at once.',
        analogy: 'A correlation heatmap is like a weather map showing temperature across a region using colour — instead of temperature, it shows how strongly every feature relates to every other feature, all in one glance.',
        example: 'sns.heatmap(df.corr(), annot=True, cmap="coolwarm") instantly reveals which features are strongly correlated (potentially redundant) and which are independent.',
        keyTakeaway: 'Correlation heatmaps are one of the very first visualisations AI engineers create on a new dataset — they instantly reveal redundant features and potential multicollinearity issues before model training even begins.',
        codeSnippet: 'import seaborn as sns\nimport pandas as pd\n\ndf = pd.DataFrame({\n    "age": [25,30,35,40,45],\n    "income": [40000,52000,61000,75000,90000],\n    "experience": [2,5,8,12,18]\n})\nsns.heatmap(df.corr(), annot=True, cmap="coolwarm")',
      ),
      ConceptLesson(
        title: 'Pairplots for Multi-Variable Exploration',
        definition: 'A pairplot creates a grid of scatter plots for every pair of numeric variables in a dataset simultaneously, with histograms on the diagonal — an instant full overview of relationships.',
        analogy: 'A pairplot is like meeting every guest at a party and instantly seeing how each one relates to every other guest, all summarised on one big poster — instead of having 20 separate one-on-one conversations.',
        example: 'sns.pairplot(df) on a dataset with 4 numeric columns instantly generates a 4x4 grid of scatter plots and histograms, revealing patterns across all variable pairs at once.',
        keyTakeaway: 'Pairplots are an extremely efficient first step in exploratory data analysis — a single function call can reveal more relationships than dozens of individual scatter plots created manually.',
        codeSnippet: 'import seaborn as sns\nimport pandas as pd\n\ndf = pd.DataFrame({\n    "age": [25,30,35,40,45,50],\n    "income": [40000,52000,61000,75000,90000,98000],\n    "spending_score": [60,55,40,35,20,15]\n})\nsns.pairplot(df)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the key advantage of Seaborn over plain Matplotlib for statistical plots?',
        options: [
          'Seaborn cannot create scatter plots',
          'Seaborn provides high-level statistical plotting functions that work directly with DataFrames, requiring less code',
          'Seaborn is slower and less commonly used in industry',
          'Seaborn cannot be combined with Pandas'
        ],
        correctIndex: 1,
        explanation: 'Seaborn is built specifically for statistical visualisation and integrates directly with Pandas DataFrames, letting you create complex, attractive charts with far less code than plain Matplotlib.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does a correlation heatmap primarily reveal?',
        options: [
          'The exact values of every row in a dataset',
          'How strongly every pair of numeric features relates to each other',
          'The number of missing values in the dataset',
          'The geographic location of data points'
        ],
        correctIndex: 1,
        explanation: 'A correlation heatmap visualises the correlation coefficient between every pair of numeric features simultaneously, using colour intensity to instantly show strong vs weak relationships.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A correlation heatmap shows that "square_footage" and "num_rooms" have a correlation of 0.95. What should an AI engineer consider doing?',
        options: [
          'Ignore this information completely',
          'Recognise potential redundancy (multicollinearity) and consider keeping only one of the two highly correlated features',
          'Automatically delete both features',
          'Add 10 more correlated features to improve the model'
        ],
        correctIndex: 1,
        explanation: 'A 0.95 correlation indicates the two features carry almost the same information (multicollinearity). Keeping both can confuse certain models and add little value — many engineers consider dropping or combining one.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Statistical EDA Dashboard with Seaborn',
      goal: 'Build a complete exploratory analysis dashboard using Seaborn on a synthetic dataset.',
      steps: [
        'Create a DataFrame with columns: department, salary, years_experience, performance_score for 30 employees',
        'Create a boxplot comparing salary across departments',
        'Create a correlation heatmap of all numeric columns with annotations',
        'Create a pairplot of salary, years_experience, and performance_score',
        'Print a written summary of 2 insights discovered from the visualisations',
      ],
      expectedOutput: 'Boxplot, heatmap, and pairplot generated successfully.\nInsight 1: Engineering department has higher median salary with more variance.\nInsight 2: years_experience and salary show a strong positive correlation (0.82).',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 11. EXPLORATORY DATA ANALYSIS (EDA)
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'exploratory_data_analysis',
    topicTitle: 'Exploratory Data Analysis (EDA)',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 150,
    emoji: '🕵️',
    intro: 'EDA is where data analysis, statistics, and visualisation come together into a structured investigation process. It is the single most important phase before training any AI model — done well, it can reveal insights that completely change your modelling strategy.',
    concepts: [
      ConceptLesson(
        title: 'What is EDA and Why It Comes First',
        definition: 'Exploratory Data Analysis is a systematic approach to summarising, visualising, and investigating a dataset\'s main characteristics before formal modelling begins.',
        analogy: 'EDA is like a doctor performing a full check-up before prescribing treatment — you wouldn\'t prescribe medicine (build a model) without first understanding the patient\'s (dataset\'s) overall condition.',
        example: 'Before building a churn prediction model, EDA reveals: what % of customers actually churn, which features differ most between churners and non-churners, and whether the dataset is imbalanced.',
        keyTakeaway: 'Skipping EDA and jumping straight to modelling is one of the most common mistakes beginners make. EDA often reveals data quality issues or surprising patterns that completely change your approach.',
      ),
      ConceptLesson(
        title: 'The EDA Checklist',
        definition: 'A structured EDA process typically covers: shape/size of data, data types, summary statistics, missing values, distributions, outliers, and relationships between variables.',
        analogy: 'An EDA checklist is like a pilot\'s pre-flight checklist — systematically verifying every critical system before takeoff (modelling), rather than relying on memory or skipping steps under time pressure.',
        example: 'df.shape, df.dtypes, df.describe(), df.isnull().sum(), df.corr(), and visualisations of key distributions form a typical first-pass EDA checklist for any new dataset.',
        keyTakeaway: 'Following a consistent EDA checklist for every new dataset builds reliability and ensures you never accidentally skip a critical data quality check.',
        codeSnippet: 'import pandas as pd\ndf = pd.read_csv("data.csv")\n\nprint(df.shape)\nprint(df.dtypes)\nprint(df.describe())\nprint(df.isnull().sum())\nprint(df.corr(numeric_only=True))',
      ),
      ConceptLesson(
        title: 'Asking the Right Questions',
        definition: 'Effective EDA is driven by specific, business-relevant questions rather than aimless exploration — each chart or statistic should aim to answer something meaningful.',
        analogy: 'Wandering through a library without a question in mind wastes time. Walking in with "I need to find books about 1800s European history" focuses your search and makes it productive. Good EDA works the same way.',
        example: 'For a sales dataset, productive EDA questions include: "Which product category drives the most revenue?", "Does seasonality affect sales?", "Are there regional differences in customer behaviour?"',
        keyTakeaway: 'Before opening a notebook, write down 3-5 specific questions you want EDA to answer. This keeps your analysis focused and ensures it actually informs your modelling decisions.',
      ),
      ConceptLesson(
        title: 'From EDA Insights to Modelling Decisions',
        definition: 'The ultimate purpose of EDA is to directly inform decisions about feature engineering, model selection, and data preprocessing — not just to produce pretty charts.',
        analogy: 'EDA findings should function like a map handed to a hiker before a trip — directly guiding which path (modelling approach) to take, rather than being framed and admired on a wall without ever being used.',
        example: 'EDA reveals the target variable is highly imbalanced (95% vs 5%) → this directly informs the decision to use specific techniques like class weighting or resampling during model training.',
        keyTakeaway: 'Every EDA finding should connect to an action: a feature to engineer, a transformation to apply, or a modelling technique to choose. EDA without action is just decoration.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why is EDA typically performed BEFORE building a machine learning model?',
        options: [
          'It is purely a formality with no real impact',
          'It reveals data quality issues, patterns, and characteristics that directly inform modelling decisions',
          'EDA is only needed after a model performs poorly',
          'EDA replaces the need for any model training'
        ],
        correctIndex: 1,
        explanation: 'EDA uncovers critical information — missing data, distributions, imbalances, correlations — that should directly shape decisions about feature engineering, preprocessing, and model choice.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the value of writing specific questions BEFORE starting an EDA session?',
        options: [
          'It has no real value',
          'It focuses the analysis on business-relevant insights rather than aimless exploration',
          'It is required by Pandas',
          'It removes the need for any visualisations'
        ],
        correctIndex: 1,
        explanation: 'Specific questions keep EDA purposeful and efficient, ensuring time is spent investigating things that will actually matter for the business problem and the eventual model.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'During EDA, you discover the target variable for a fraud detection dataset is 99% "not fraud" and only 1% "fraud". What should this insight directly influence?',
        options: [
          'Nothing — this information is not useful',
          'The choice of modelling techniques (e.g. handling class imbalance) and evaluation metrics (e.g. avoiding plain accuracy)',
          'You should immediately delete the fraud cases',
          'You should stop the project entirely'
        ],
        correctIndex: 1,
        explanation: 'A 99%/1% imbalance is a critical EDA finding that should directly inform model choice (resampling, class weights) and metric choice (precision/recall instead of accuracy) — exactly the "EDA informs decisions" principle.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Complete EDA Report',
      goal: 'Conduct a full, structured exploratory data analysis on a synthetic customer dataset and summarise findings.',
      steps: [
        'Create a synthetic DataFrame of 200 customers with: age, monthly_spend, region, churned (yes/no)',
        'Run the EDA checklist: shape, dtypes, describe(), missing values, and churned class balance',
        'Create 3 visualisations: a histogram of monthly_spend, a boxplot of monthly_spend by churned status, and a bar chart of churn rate by region',
        'Write 3 specific EDA questions you investigated and the answers you found',
        'Write a final "Recommendations for Modelling" section based on your findings',
      ],
      expectedOutput: 'Full EDA report including data summary, 3 charts, 3 answered questions, and a modelling recommendations section addressing class imbalance and key churn drivers.',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 12. WORKING WITH CSV, EXCEL & JSON
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'csv_excel_json',
    topicTitle: 'Working with CSV, Excel & JSON',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '📁',
    intro: 'Data doesn\'t arrive in a perfect Pandas DataFrame — it comes from CSV exports, Excel reports, and JSON API responses. Knowing how to reliably import, export, and convert between these formats is a daily skill for every AI engineer.',
    concepts: [
      ConceptLesson(
        title: 'Reading & Writing CSV Files',
        definition: 'CSV (Comma-Separated Values) is the most common plain-text format for tabular data, widely used for data exports, imports, and sharing across systems.',
        analogy: 'A CSV file is like a simple recipe card written in plain text — anyone, any software, any programming language can read it, unlike more complex proprietary formats.',
        example: 'pd.read_csv("sales.csv") loads a CSV file directly into a DataFrame. df.to_csv("output.csv", index=False) saves a DataFrame back to CSV.',
        keyTakeaway: 'CSV is the universal format for data exchange — simple, lightweight, and supported everywhere. Always check delimiter, encoding, and header settings when reading unfamiliar CSV files.',
        codeSnippet: 'import pandas as pd\n\ndf = pd.read_csv("sales.csv")\nprint(df.head())\n\ndf.to_csv("cleaned_sales.csv", index=False)',
      ),
      ConceptLesson(
        title: 'Reading & Writing Excel Files',
        definition: 'Excel files (.xlsx) are widely used in business settings and can contain multiple sheets, formatting, and formulas — Pandas can read and write them using read_excel and to_excel.',
        analogy: 'If CSV is a single recipe card, an Excel workbook is a whole recipe binder with multiple labelled tabs (sheets) — Pandas lets you flip directly to the exact tab you need.',
        example: 'pd.read_excel("report.xlsx", sheet_name="Q1_Sales") reads a specific sheet from a multi-sheet Excel workbook.',
        keyTakeaway: 'Excel files often require the sheet_name parameter since a single file can contain many sheets. Always confirm which sheet contains the data you actually need.',
        codeSnippet: 'import pandas as pd\n\ndf = pd.read_excel("report.xlsx", sheet_name="Q1_Sales")\nprint(df.head())\n\ndf.to_excel("output_report.xlsx", sheet_name="Cleaned", index=False)',
      ),
      ConceptLesson(
        title: 'Reading & Writing JSON Files',
        definition: 'JSON (JavaScript Object Notation) is a flexible, nested data format widely used by web APIs to exchange data — Pandas can convert JSON into flat DataFrames and back.',
        analogy: 'JSON is like a set of nested folders inside folders, each labelled, holding related information together — versus CSV\'s flat, single-table structure. APIs love JSON because it naturally represents complex, nested data.',
        example: 'pd.read_json("api_response.json") converts JSON data into a DataFrame. For deeply nested JSON, pd.json_normalize() flattens nested structures into clean tabular columns.',
        keyTakeaway: 'JSON is the standard format for API data in AI applications (e.g. fetching live data to feed a model). Learning to flatten nested JSON is an essential real-world data engineering skill.',
        codeSnippet: 'import pandas as pd\n\ndf = pd.read_json("api_response.json")\nprint(df.head())\n\n# Flatten nested JSON\nnested_data = [{"user": {"name": "Alice", "age": 25}, "score": 90}]\nflat_df = pd.json_normalize(nested_data)\nprint(flat_df)\n#    user.name  user.age  score\n# 0      Alice        25     90',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does the Pandas function pd.read_csv() do?',
        options: [
          'Converts a DataFrame into a chart',
          'Loads a CSV file into a Pandas DataFrame',
          'Deletes a CSV file',
          'Converts CSV into a SQL database'
        ],
        correctIndex: 1,
        explanation: 'pd.read_csv() is the standard Pandas function for importing CSV files directly into a DataFrame, ready for analysis.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why might you need the sheet_name parameter when using pd.read_excel()?',
        options: [
          'It is never needed',
          'Excel workbooks can contain multiple sheets, and you need to specify which one to load',
          'It is used to delete a sheet',
          'It only applies to CSV files'
        ],
        correctIndex: 1,
        explanation: 'Unlike CSV files, Excel workbooks commonly contain multiple sheets. sheet_name tells Pandas exactly which sheet\'s data to load into the DataFrame.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You receive nested JSON data from an API where each record contains a nested "address" object with "city" and "zipcode" fields. What is the BEST Pandas approach to flatten this into clean columns?',
        options: [
          'pd.read_csv() on the JSON file directly',
          'pd.json_normalize() to flatten the nested structure into separate columns',
          'Manually retype all the data',
          'It is impossible to flatten nested JSON in Pandas'
        ],
        correctIndex: 1,
        explanation: 'pd.json_normalize() is specifically designed to flatten nested JSON structures (like nested "address" objects) into clean, separate DataFrame columns such as address.city and address.zipcode.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Multi-Format Data Importer',
      goal: 'Build a Python script that reads data from CSV, Excel, and JSON sources, then unifies them into a single clean dataset.',
      steps: [
        'Create and save sample data in 3 formats: a CSV with customer purchases, an Excel file with customer demographics, and a JSON file with customer support tickets',
        'Read all 3 files into separate DataFrames using the appropriate Pandas functions',
        'Merge the CSV and Excel DataFrames on a shared customer_id column',
        'Flatten and merge in relevant fields from the JSON support ticket data',
        'Save the final unified dataset back to a single clean CSV file',
      ],
      expectedOutput: 'Loaded: purchases.csv (50 rows), demographics.xlsx (50 rows), tickets.json (30 rows)\nMerged dataset shape: (50, 8)\nSaved as unified_customer_data.csv',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 13. SQL BASICS FOR AI ENGINEERS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'sql_basics_for_ai_engineers',
    topicTitle: 'SQL Basics for AI Engineers',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '🗄️',
    intro: 'Most real-world company data doesn\'t live in CSV files — it lives in databases, queried with SQL. Every AI engineer needs to be comfortable pulling exactly the data they need directly from a database before any Python analysis even begins.',
    concepts: [
      ConceptLesson(
        title: 'Why AI Engineers Need SQL',
        definition: 'SQL (Structured Query Language) is the standard language for querying and manipulating data stored in relational databases — the primary storage system for most company data.',
        analogy: 'If your data lives in a massive warehouse with millions of items, SQL is the precise request form you fill out to have exactly the items you need delivered to your desk — instead of searching the entire warehouse by hand.',
        example: 'A company\'s entire customer transaction history might live in a PostgreSQL database with millions of rows — far too large to export as a single CSV. SQL lets you query exactly the subset you need.',
        keyTakeaway: 'SQL is one of the most consistently in-demand skills across ALL data and AI roles. Even AI engineers who primarily use Python need SQL to access their training data in the first place.',
      ),
      ConceptLesson(
        title: 'SELECT, WHERE & ORDER BY',
        definition: 'SELECT chooses which columns to retrieve. WHERE filters which rows to include. ORDER BY sorts the results.',
        analogy: 'SELECT is choosing which ingredients you want from a pantry. WHERE is specifying conditions like "only items that haven\'t expired". ORDER BY is arranging them on the shelf by expiry date.',
        example: 'SELECT name, age, city FROM customers WHERE age > 30 ORDER BY age DESC;\n\nThis selects 3 columns, filters for customers over 30, and sorts oldest first.',
        keyTakeaway: 'SELECT + WHERE + ORDER BY form the foundation of nearly every SQL query an AI engineer writes when pulling training data from a database.',
        codeSnippet: '-- Basic SQL query example\nSELECT name, age, city\nFROM customers\nWHERE age > 30\nORDER BY age DESC;',
      ),
      ConceptLesson(
        title: 'JOINs — Combining Tables',
        definition: 'A JOIN combines rows from two or more tables based on a related column, letting you bring together data that\'s split across multiple tables.',
        analogy: 'Imagine a "customers" table and a separate "orders" table. A JOIN is like a matchmaker connecting each order to the right customer based on a shared customer_id — bringing together information that lives in two different places.',
        example: 'SELECT customers.name, orders.amount\nFROM customers\nJOIN orders ON customers.id = orders.customer_id;\n\nThis combines customer names with their order amounts, even though they live in separate tables.',
        keyTakeaway: 'Real company databases are normalised — split across many related tables to avoid duplication. JOINs are essential to reconstruct a complete, useful dataset for AI model training.',
        codeSnippet: '-- INNER JOIN combining two tables\nSELECT customers.name, orders.amount, orders.order_date\nFROM customers\nJOIN orders ON customers.id = orders.customer_id\nWHERE orders.amount > 500;',
      ),
      ConceptLesson(
        title: 'GROUP BY & Aggregate Functions',
        definition: 'GROUP BY groups rows sharing a common value, and aggregate functions (COUNT, SUM, AVG, MAX, MIN) summarise each group.',
        analogy: 'GROUP BY in SQL is exactly like Pandas\' groupby() — sorting items into labelled piles and then summarising each pile (e.g. counting items, totalling values).',
        example: 'SELECT city, COUNT(*) as customer_count, AVG(age) as avg_age\nFROM customers\nGROUP BY city;\n\nThis returns the customer count and average age for EACH city.',
        keyTakeaway: 'SQL\'s GROUP BY mirrors Pandas\' groupby() conceptually — many AI engineers do initial aggregation directly in SQL (faster on huge datasets) before pulling a smaller, summarised result into Python.',
        codeSnippet: '-- Aggregate query example\nSELECT city, COUNT(*) AS customer_count, AVG(age) AS avg_age\nFROM customers\nGROUP BY city\nORDER BY customer_count DESC;',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does the SQL WHERE clause do?',
        options: [
          'Sorts the results',
          'Filters which rows are included in the result based on a condition',
          'Combines two tables',
          'Deletes a table'
        ],
        correctIndex: 1,
        explanation: 'WHERE filters rows based on a condition — only rows where the condition evaluates to true are included in the query results.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why are JOINs necessary when working with relational databases?',
        options: [
          'They are never necessary',
          'Real-world data is often split across multiple related tables, and JOINs combine them based on shared keys',
          'JOINs delete duplicate data automatically',
          'JOINs are only used for visualisation'
        ],
        correctIndex: 1,
        explanation: 'Relational databases normalise data into multiple linked tables to avoid duplication. JOINs reconstruct a unified view by matching related rows across tables using shared key columns.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What SQL clause is most similar to Pandas\' groupby() function?',
        options: ['WHERE', 'ORDER BY', 'GROUP BY', 'SELECT'],
        correctIndex: 2,
        explanation: 'GROUP BY in SQL groups rows sharing common values and applies aggregate functions to each group — conceptually identical to Pandas\' groupby() operation.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You need the total order amount for each customer, but customer names are in a "customers" table and order amounts are in a separate "orders" table. What SQL combination do you need?',
        options: [
          'Only SELECT, no other clauses',
          'A JOIN to combine the tables, plus GROUP BY and SUM() to total amounts per customer',
          'Only WHERE, with no JOIN',
          'DELETE both tables and start over'
        ],
        correctIndex: 1,
        explanation: 'You need a JOIN to combine customer and order data across the two related tables, then GROUP BY customer with SUM() to calculate each customer\'s total order amount.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'SQL Query Builder for AI Training Data',
      goal: 'Write a set of SQL queries to extract and prepare a customer purchase dataset for ML training, then verify them conceptually with Pandas equivalents.',
      steps: [
        'Write a SQL query selecting customer name, city, and age for customers older than 25, sorted by age',
        'Write a SQL JOIN query combining a "customers" table and "purchases" table to get each customer\'s total purchase amount',
        'Write a SQL GROUP BY query showing average purchase amount per city',
        'For each SQL query, write the equivalent Pandas code that would achieve the same result on an already-loaded DataFrame',
        'Print all 3 SQL queries alongside their Pandas equivalents for comparison',
      ],
      expectedOutput: 'SQL Query 1 + Pandas equivalent\nSQL Query 2 (JOIN) + Pandas equivalent (merge + groupby)\nSQL Query 3 (GROUP BY) + Pandas equivalent (groupby + mean)\nAll queries documented and ready for use against a live database.',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 14. BUILDING COMPLETE DATA PIPELINES
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'building_complete_data_pipelines',
    topicTitle: 'Building Complete Data Pipelines',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Hard',
    estimatedMinutes: 30,
    totalXp: 160,
    emoji: '🏭',
    intro: 'A data pipeline automates the entire journey from raw data to model-ready dataset. This is where all your individual skills — cleaning, transforming, visualising — come together into one professional, repeatable system, exactly as real AI teams build them.',
    concepts: [
      ConceptLesson(
        title: 'What is a Data Pipeline?',
        definition: 'A data pipeline is an automated, repeatable sequence of steps that moves data from its raw source through cleaning, transformation, and preparation, ending in a model-ready dataset.',
        analogy: 'A data pipeline is like a factory assembly line for data — raw material (messy data) enters one end, passes through a series of automated stations (clean, transform, validate), and a finished product (model-ready dataset) comes out the other end, every single time, consistently.',
        example: 'A daily pipeline might: 1) pull yesterday\'s sales from a database, 2) clean and validate it, 3) engineer features, 4) append it to the training dataset, 5) trigger model retraining — all automatically, without manual intervention.',
        keyTakeaway: 'Pipelines turn one-off, manual data analysis into a reliable, repeatable, production-grade system — essential for any AI system that needs to run continuously in the real world.',
      ),
      ConceptLesson(
        title: 'Designing Pipeline Stages',
        definition: 'A well-designed pipeline breaks the process into clear, independent stages: Extract (get raw data), Transform (clean/engineer), Load (save the model-ready result) — commonly called ETL.',
        analogy: 'ETL is like a restaurant kitchen workflow: Extract is receiving raw ingredients from suppliers, Transform is the chef prepping and cooking, Load is plating the finished dish and sending it out to the table, ready to be consumed.',
        example: 'Extract: pull raw CSVs from a shared drive.\nTransform: clean missing values, encode categories, engineer features.\nLoad: save the final, clean DataFrame as a Parquet file ready for model training.',
        keyTakeaway: 'Keeping pipeline stages clearly separated (rather than one giant tangled script) makes pipelines easier to debug, test, and maintain — a core software engineering principle applied to data work.',
        codeSnippet: 'import pandas as pd\n\ndef extract(filepath):\n    return pd.read_csv(filepath)\n\ndef transform(df):\n    df = df.drop_duplicates()\n    df["age"] = df["age"].fillna(df["age"].median())\n    return df\n\ndef load(df, output_path):\n    df.to_csv(output_path, index=False)\n    print(f"Saved cleaned data to {output_path}")\n\nraw = extract("raw_data.csv")\ncleaned = transform(raw)\nload(cleaned, "model_ready_data.csv")',
      ),
      ConceptLesson(
        title: 'Validation & Error Handling in Pipelines',
        definition: 'A robust pipeline includes validation checks at each stage (e.g. confirming no nulls remain, expected columns exist) and error handling to catch and report problems before they corrupt downstream model training.',
        analogy: 'Validation checks are like quality control inspectors stationed at each point on a factory assembly line — they catch a defective product immediately, rather than letting it travel all the way to the customer (the trained model) before anyone notices something\'s wrong.',
        example: 'After cleaning, a pipeline might assert that df.isnull().sum().sum() == 0 and raise an alert if any nulls remain unexpectedly — catching silent data corruption before it reaches the model.',
        keyTakeaway: 'Production AI pipelines fail silently far more often than they fail loudly. Building in validation checks at each stage is what separates fragile, "it worked on my laptop" pipelines from reliable, production-grade systems.',
        codeSnippet: 'def validate(df, required_columns):\n    missing_cols = set(required_columns) - set(df.columns)\n    if missing_cols:\n        raise ValueError(f"Missing required columns: {missing_cols}")\n    if df.isnull().sum().sum() > 0:\n        raise ValueError("Unexpected missing values remain after cleaning!")\n    print("Validation passed.")\n\nvalidate(cleaned, ["name", "age", "city"])',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does the "ETL" pipeline pattern stand for?',
        options: [
          'Evaluate, Test, Launch',
          'Extract, Transform, Load',
          'Encode, Train, Learn',
          'Explore, Transform, List'
        ],
        correctIndex: 1,
        explanation: 'ETL stands for Extract (get raw data), Transform (clean and engineer it), and Load (save the final, model-ready result) — the standard structure for data pipelines.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is validation important within a data pipeline?',
        options: [
          'It is an optional, unnecessary step',
          'It catches data quality problems early, before they silently corrupt model training',
          'Validation slows down pipelines for no benefit',
          'Validation is only needed for SQL databases'
        ],
        correctIndex: 1,
        explanation: 'Without validation checks, data quality issues can flow silently through a pipeline and corrupt model training without anyone noticing until performance unexpectedly drops in production.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You\'re designing a daily pipeline that pulls new sales data, cleans it, and feeds it into a forecasting model. Why is it important to separate the pipeline into distinct Extract, Transform, and Load functions instead of one giant script?',
        options: [
          'It makes no real difference',
          'Separated stages are easier to test, debug, and maintain independently when something goes wrong',
          'It makes the pipeline run slower on purpose',
          'It is only a stylistic preference with zero practical benefit'
        ],
        correctIndex: 1,
        explanation: 'Clearly separated stages let you test and debug each part independently — if the pipeline fails, you immediately know whether the issue is in extraction, transformation, or loading, dramatically speeding up troubleshooting.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'End-to-End ETL Pipeline',
      goal: 'Build a complete, validated ETL pipeline that processes raw customer data into a model-ready dataset.',
      steps: [
        'Write an extract(filepath) function that loads a raw CSV into a DataFrame',
        'Write a transform(df) function that removes duplicates, fills missing values, encodes categorical columns, and engineers at least 1 new feature',
        'Write a validate(df) function that checks for required columns and confirms zero remaining missing values, raising an error if checks fail',
        'Write a load(df, output_path) function that saves the final DataFrame to CSV',
        'Write a run_pipeline(input_path, output_path) function that calls all 4 stages in order and prints a success message',
      ],
      expectedOutput: 'Extracting raw data...\nTransforming data...\nValidating data... Validation passed.\nLoading cleaned data to model_ready_data.csv\nPipeline completed successfully. Final shape: (200, 9)',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 15. AI DATA ANALYSIS CAPSTONE PROJECT
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'ai_data_analysis_capstone',
    topicTitle: 'AI Data Analysis Capstone Project',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Hard',
    estimatedMinutes: 45,
    totalXp: 220,
    emoji: '🏆',
    intro: 'This is it — the capstone that brings together everything from this entire level. You\'ll build a complete AI Data Analytics Pipeline: importing real-world-style datasets, cleaning them, engineering features, visualising insights, generating a report, and preparing the final dataset for machine learning. This is exactly the kind of project that belongs in a professional AI engineering portfolio.',
    concepts: [
      ConceptLesson(
        title: 'Thinking Like a Data Analytics Lead',
        definition: 'A capstone-level project requires end-to-end ownership — deciding what data is needed, how to clean it, what insights matter, and how to communicate results to both technical and non-technical stakeholders.',
        analogy: 'Earlier lessons taught you individual tools — a hammer, a saw, a drill. A capstone project is building the entire house: deciding the blueprint, choosing which tools to use when, and making sure everything fits together into something genuinely useful.',
        example: 'A real AI Data Analytics Lead doesn\'t just clean data — they decide WHICH insights matter to the business, how confident they are in the findings, and how to present results clearly to people who don\'t code.',
        keyTakeaway: 'Capstone-level thinking means connecting every technical step back to a real-world purpose: what decision will this analysis support, and is the final dataset genuinely ready for a model to learn from?',
      ),
      ConceptLesson(
        title: 'Combining Multiple Data Sources',
        definition: 'Real-world AI projects rarely use a single clean dataset — they combine data from multiple sources (databases, CSVs, APIs) that must be merged, reconciled, and unified.',
        analogy: 'Building a complete picture from multiple datasets is like assembling a jigsaw puzzle where the pieces come from 3 different boxes — you need to carefully figure out how they fit together (matching keys, consistent formats) before the full picture (unified dataset) emerges.',
        example: 'Combining a "transactions" CSV, a "customer_demographics" Excel file, and a "support_tickets" JSON export into one unified customer analytics dataset using shared customer IDs.',
        keyTakeaway: 'The ability to merge, reconcile, and unify data from multiple real-world sources is one of the most valuable and differentiating skills for an AI engineer working on production systems.',
      ),
      ConceptLesson(
        title: 'Communicating Insights with a Report',
        definition: 'A data analytics report translates technical findings into clear, actionable language and visuals for stakeholders, summarising the most important insights and recommendations.',
        analogy: 'A great analytics report is like a tour guide summarising a 3-hour museum visit into the 5 most fascinating highlights for a tired visitor — distilling enormous complexity into clear, memorable, useful takeaways.',
        example: 'A good report includes: an executive summary, key findings with supporting charts, data quality notes, and clear recommendations for next steps (e.g. "the model should account for regional differences in churn rate").',
        keyTakeaway: 'Technical skill alone isn\'t enough — the ability to clearly communicate WHY findings matter and WHAT should be done about them is what makes an AI engineer\'s work genuinely impactful within an organisation.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What distinguishes capstone-level data analysis thinking from completing individual technical exercises?',
        options: [
          'Capstone projects use more advanced syntax only',
          'Capstone-level thinking requires end-to-end ownership, connecting technical steps to real business decisions and outcomes',
          'There is no real difference',
          'Capstone projects never require visualisation'
        ],
        correctIndex: 1,
        explanation: 'A capstone project requires you to own the entire process — deciding what matters, why, and how to communicate it — rather than just executing isolated technical steps.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is the ability to combine data from multiple sources (CSV, Excel, JSON, databases) especially valuable for AI engineers?',
        options: [
          'It is rarely needed in real projects',
          'Real-world company data is almost always scattered across multiple systems and formats, requiring unification before analysis',
          'Only data scientists need this skill, not AI engineers',
          'Multiple sources are always already perfectly unified'
        ],
        correctIndex: 1,
        explanation: 'In practice, company data is rarely centralised in one clean source — AI engineers must regularly merge and reconcile data from databases, files, and APIs into a single usable dataset.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You\'ve completed a thorough data analysis with excellent charts and clean code, but your final report is full of technical jargon that non-technical stakeholders can\'t understand. What is the BEST fix?',
        options: [
          'Nothing — stakeholders should learn the technical terms themselves',
          'Rewrite the report\'s key findings and recommendations in clear, plain language, while keeping technical details available separately for technical readers',
          'Remove all charts since they require explanation',
          'Skip writing a report altogether'
        ],
        correctIndex: 1,
        explanation: 'Effective communication means adapting your message to your audience. Plain-language summaries with clear recommendations make insights actionable for stakeholders, while technical detail can still be available for those who need it.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'AI Data Analytics Capstone Pipeline',
      goal: 'Build a complete, professional AI Data Analytics Pipeline that imports multiple datasets, cleans data, performs feature engineering, visualizes insights, generates a report, and prepares the final dataset for Machine Learning.',
      steps: [
        'IMPORT: Create and load 3 related synthetic datasets in different formats (CSV: transactions, Excel: customer demographics, JSON: support tickets) and merge them into one unified DataFrame using shared customer IDs',
        'CLEAN: Detect and handle duplicates, missing values, and inconsistent formatting across the unified dataset',
        'FEATURE ENGINEER: Create at least 3 new features (e.g. total_spend, days_since_last_purchase, support_ticket_count, age_group)',
        'VISUALIZE: Create at least 4 charts (using Matplotlib and/or Seaborn) covering distributions, comparisons, and correlations, each with clear titles and labels',
        'REPORT: Write a structured analytics report with an executive summary, 3-5 key findings backed by your charts, and clear recommendations for the modelling team',
        'PREPARE FOR ML: Encode categorical variables, scale numeric features, split the data into train/test sets, and save the final model-ready dataset to CSV',
      ],
      expectedOutput: '=== AI DATA ANALYTICS CAPSTONE PIPELINE ===\n\n[Import] 3 datasets merged successfully. Unified shape: (300, 12)\n[Clean] Removed 8 duplicates, imputed 15 missing values, standardized formatting\n[Feature Engineering] 3 new features created: total_spend, days_since_last_purchase, age_group\n[Visualization] 4 charts generated: spend_distribution.png, churn_by_region.png, correlation_heatmap.png, support_tickets_vs_spend.png\n[Report] Executive summary + 5 key findings + recommendations generated\n[ML Preparation] Train shape: (240, 15), Test shape: (60, 15)\n\nPipeline completed successfully. Dataset is ready for Machine Learning model training.',
      xpReward: 100,
    ),
  ),
];