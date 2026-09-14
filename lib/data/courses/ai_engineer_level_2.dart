// ══════════════════════════════════════════════════════════════════════
// lib/models/ai_engineer_level_2.dart
// AI Engineer Learning Path — LEVEL 2: Python for AI Engineering
// ══════════════════════════════════════════════════════════════════════

import '../../models/course_content_data.dart'; 

const List<TopicCourse> aiEngineerLevel2 = [

  TopicCourse(
    id: 'aep_l2_python_fundamentals',
    topicTitle: 'Python Fundamentals Review',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 185,
    emoji: '🐍',
    intro: 'Python is the language of AI. Before diving into NumPy, pandas, and neural networks, you need rock-solid Python fundamentals. This course reviews the core concepts that every AI engineer uses daily — with examples drawn directly from real AI workflows.',
    concepts: [
      ConceptLesson(
        title: 'Why Python for AI Engineering?',
        definition: 'Python dominates AI because of its clean syntax, massive ecosystem (NumPy, pandas, PyTorch, scikit-learn), interactive notebooks, and a community that has standardised on it for every AI library and research paper.',
        analogy: 'Python for AI is like English for international business — not the fastest or most powerful option in every case, but the universal language everyone uses. Knowing it means every library, tutorial, and tool is immediately accessible to you.',
        example: '# Python makes complex AI tasks readable:\n\n# Load a dataset\nimport pandas as pd\ndf = pd.read_csv("crop_data.csv")\n\n# Train a model in 3 lines\nfrom sklearn.ensemble import RandomForestClassifier\nmodel = RandomForestClassifier()\nmodel.fit(df[features], df["label"])\n\n# Predict\npredictions = model.predict(new_data)\nprint(f"Accuracy: {model.score(X_test, y_test):.2%}")\n\n# Same workflow in any AI domain:\n# change the data → same Python structure',
        keyTakeaway: 'Python code reads almost like English — this is not accidental. Readability means fewer bugs, faster debugging, and AI code that your team can understand and maintain. Clean Python is professional Python.',
      ),
      ConceptLesson(
        title: 'Python Execution Model — How Python Runs Your Code',
        definition: 'Python is an interpreted language — it executes code line by line from top to bottom. Understanding this helps you debug AI scripts, understand import order, and structure ML pipelines correctly.',
        analogy: 'Python executing your script is like a chef following a recipe from top to bottom — they do not skip ahead or reorder steps. If line 10 uses a variable defined on line 20, Python crashes because it has not seen line 20 yet.',
        example: '# Python executes top to bottom:\nprint("Step 1: Loading data")       # runs first\ndf = pd.read_csv("data.csv")        # runs second\nprint("Step 2: Training model")     # runs third\nmodel.fit(X, y)                     # runs fourth\n\n# This would FAIL — using before defining:\nprint(model.score(X_test, y_test))  # ERROR!\nmodel = RandomForestClassifier()    # defined AFTER use\n\n# Python Jupyter cell execution:\n# Each cell runs independently but shares state\n# Run Cell 1 (imports) before Cell 2 (model training)',
        keyTakeaway: 'In Jupyter notebooks, always run cells in order. A common beginner bug is running a model training cell before the data loading cell — Python has not seen the data variable yet and will throw a NameError.',
      ),
      ConceptLesson(
        title: 'Python Style — Writing Professional AI Code',
        definition: 'PEP 8 is Python\'s official style guide. Following it makes your AI code readable by any Python engineer worldwide. Key rules: use snake_case for variables, 4-space indentation, meaningful names, and docstrings for functions.',
        analogy: 'PEP 8 is like the coding equivalent of grammar rules in English — you can write without following them, but professional readers will immediately notice, and it signals whether you are a beginner or a professional.',
        example: '# BAD — unprofessional AI code:\ndef f(x,y,z):\n  r=x*y+z*0.18\n  return r\n\na=f(100,5,0)\nprint(a)\n\n# GOOD — professional AI code:\ndef calculate_order_total(price, quantity, tax_rate=0.18):\n    """Calculate order total including GST tax.\n    \n    Args:\n        price: Unit price in rupees\n        quantity: Number of units ordered\n        tax_rate: GST rate (default 18%)\n    Returns:\n        Total price including tax\n    """\n    subtotal = price * quantity\n    return subtotal * (1 + tax_rate)\n\norder_total = calculate_order_total(price=100, quantity=5)\nprint(f"Order total: Rs{order_total:.2f}")',
        keyTakeaway: 'Write AI code as if the person maintaining it is a senior engineer who knows where you live. Meaningful names, docstrings, and consistent style are not optional niceties — they are professional requirements.',
      ),
      ConceptLesson(
        title: 'Python Environment Management',
        definition: 'Virtual environments isolate project dependencies so different AI projects can use different library versions without conflicting. Every professional AI project uses either venv, conda, or Poetry for dependency management.',
        analogy: 'A virtual environment is like a separate toolbox for each project — project A needs scikit-learn 1.3 and project B needs scikit-learn 0.24. Without virtual environments, installing one breaks the other. Each toolbox keeps its tools separate.',
        example: '# Creating a virtual environment for an AI project:\n\n# Using venv (built into Python):\npython -m venv ai_project_env\nsource ai_project_env/bin/activate  # Mac/Linux\n# ai_project_env\\Scripts\\activate   # Windows\n\n# Install project-specific packages:\npip install numpy pandas scikit-learn torch\n\n# Save dependencies for teammates:\npip freeze > requirements.txt\n\n# Teammate recreates your environment:\npip install -r requirements.txt\n\n# Using conda (popular in data science):\nconda create -n ai_project python=3.11\nconda activate ai_project\nconda install numpy pandas scikit-learn\n\n# Check current environment:\nwhich python  # shows active Python path',
        keyTakeaway: 'Never install AI packages into your global Python environment. Always create a virtual environment per project. This prevents the classic "it works on my machine" problem and makes your projects reproducible.',
      ),
      ConceptLesson(
        title: 'Python in the AI Development Workflow',
        definition: 'Professional AI development uses Python across the full pipeline: data ingestion, preprocessing, model training, evaluation, API serving, and monitoring. Understanding the full flow helps you see where your Python skills fit.',
        analogy: 'Python in an AI pipeline is like plumbing in a building — it connects every component (data sources, ML models, APIs, databases) and carries information between them. Without solid Python plumbing, no AI system works end to end.',
        example: '# Complete AI pipeline in Python:\n\n# 1. Data ingestion\nimport pandas as pd\ndf = pd.read_csv("raw_data.csv")\n\n# 2. Preprocessing\nfrom sklearn.preprocessing import StandardScaler\nscaler = StandardScaler()\nX_scaled = scaler.fit_transform(df[features])\n\n# 3. Training\nfrom sklearn.ensemble import GradientBoostingClassifier\nmodel = GradientBoostingClassifier()\nmodel.fit(X_train, y_train)\n\n# 4. Evaluation\nfrom sklearn.metrics import classification_report\nprint(classification_report(y_test, model.predict(X_test)))\n\n# 5. Serving via API\nfrom fastapi import FastAPI\napp = FastAPI()\n\n@app.post("/predict")\ndef predict(data: dict):\n    features = extract_features(data)\n    return {"prediction": model.predict([features])[0]}',
        keyTakeaway: 'A single Python script can handle the entire AI lifecycle. Understanding each stage — ingestion, preprocessing, training, evaluation, and serving — gives you a mental map of where your Python skills apply in production.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'In a Jupyter notebook, you run Cell 3 (model training) before Cell 1 (data loading). What happens?',
        options: [
          'Python automatically finds the data from Cell 1',
          'NameError — the data variable does not exist yet because Cell 1 has not been executed',
          'The model trains on empty data silently',
          'Jupyter automatically runs cells in order'
        ],
        correctIndex: 1,
        explanation: 'Python executes code in the order cells are RUN, not the order they appear. If you run Cell 3 before Cell 1, variables defined in Cell 1 do not exist yet — causing a NameError. Always run Jupyter cells in sequence.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why should you always use a virtual environment for AI projects?',
        options: [
          'Virtual environments make Python run faster',
          'They isolate project dependencies so different projects can use different library versions without conflicting — ensuring reproducibility',
          'They are required by PyTorch to work',
          'Virtual environments automatically update packages'
        ],
        correctIndex: 1,
        explanation: 'Different AI projects need different library versions. A virtual environment keeps each project\'s dependencies isolated, preventing version conflicts and making your project reproducible on any machine using requirements.txt.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the correct Python naming convention for a variable storing model accuracy?',
        options: [
          'modelAccuracy (camelCase)',
          'model_accuracy (snake_case — Python PEP 8 standard)',
          'ModelAccuracy (PascalCase)',
          'MODELACCURACY (uppercase)'
        ],
        correctIndex: 1,
        explanation: 'PEP 8 (Python\'s official style guide) specifies snake_case for variables and functions. PascalCase is for classes. Following PEP 8 makes your code immediately readable to any Python engineer worldwide.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You inherit an AI project with this function:\ndef p(x,y): return x*y+0.18*x*y\n\nWhat are the TWO main problems with this code?',
        options: [
          'It uses multiplication which is slow',
          'Meaningless function name "p" and parameter names "x", "y" — and magic number 0.18 with no explanation. Rename to calculate_price_with_gst(price, quantity) with TAX_RATE = 0.18',
          'It is missing a print statement',
          'Python does not support this syntax'
        ],
        correctIndex: 1,
        explanation: 'Two violations of professional Python: (1) p, x, y are meaningless names — future engineers cannot understand purpose without reading every line. (2) 0.18 is a magic number with no context. Named constants (TAX_RATE = 0.18) explain intent.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You install torch, tensorflow, and scikit-learn globally on your laptop. Six months later, a new project needs an older version of scikit-learn that conflicts with tensorflow. What should you have done from the start?',
        options: [
          'Only install one ML library at a time',
          'Created a separate virtual environment for each project — each project installs its own package versions in isolation, preventing conflicts permanently',
          'Used a different laptop for each project',
          'Uninstalled and reinstalled packages as needed'
        ],
        correctIndex: 1,
        explanation: 'Virtual environments from day one prevent this exact scenario. One venv per project means each project has its own scikit-learn version, its own torch version, and they never interfere with each other.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Python AI Environment Setup',
      goal: 'Set up a professional Python environment for AI development and write your first structured AI pipeline script.',
      steps: [
        'Create a virtual environment named "ai_engineer_env" using venv or conda',
        'Install: numpy, pandas, matplotlib, scikit-learn, and jupyter — save to requirements.txt',
        'Write a Python script "ai_pipeline.py" with 5 clearly named functions: load_data(), preprocess_data(), train_model(), evaluate_model(), and save_results()',
        'Each function must have a proper docstring explaining what it does, its parameters, and return value',
        'Add a main() function that calls all 5 in correct order and wrap it in if __name__ == "__main__":',
        'Run the script and verify it executes without errors using sample Iris data from sklearn.datasets',
      ],
      expectedOutput: '=== AI Pipeline Started ===\nload_data(): Loaded 150 samples, 4 features\npreprocess_data(): Train/test split 120/30, scaled features\ntrain_model(): RandomForest trained in 0.12s\nevaluate_model(): Accuracy 96.67% | F1 0.967\nsave_results(): Results saved to results.json\n=== Pipeline Complete ===\n\nrequirements.txt created ✓\nAll 5 functions have docstrings ✓\nif __name__ == "__main__" used ✓',
      xpReward: 45,
    ),
  ),

  TopicCourse(
    id: 'aep_l2_variables_datatypes',
    topicTitle: 'Variables, Data Types & Operators',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 190,
    emoji: '📦',
    intro: 'Every AI system processes data — and data comes in types. Understanding Python data types deeply, including their AI-specific use cases, is what separates engineers who write correct ML code from those who spend hours debugging type errors. This course covers data types through the lens of AI engineering.',
    concepts: [
      ConceptLesson(
        title: 'Core Python Data Types for AI',
        definition: 'Python has six core data types used constantly in AI: int, float, str, bool, list, and dict. Each has specific AI applications — floats for model weights, lists for feature vectors, dicts for model configurations and JSON data.',
        analogy: 'Data types are like different containers in a chemistry lab — each designed for specific substances. Putting acid in a paper cup (wrong type) causes problems. Using the right container (correct data type) keeps your AI pipeline safe and predictable.',
        example: '# AI use cases for each data type:\n\n# int — epoch count, batch size, class labels\nepochs = 100\nbatch_size = 32\nclass_label = 0  # 0=cat, 1=dog\n\n# float — model weights, probabilities, learning rate\nlearning_rate = 0.001\naccuracy = 0.9734\nconfidence = 0.87  # model is 87% confident\n\n# str — file paths, feature names, model names\ndata_path = "datasets/crop_disease/train/"\nmodel_name = "resnet50_fine_tuned"\n\n# bool — flags for training options\nuse_gpu = True\nshuffle_data = True\nearly_stopping = False\n\n# list — feature vectors, batch of predictions\nfeature_vector = [5.1, 3.5, 1.4, 0.2]\npredictions = [0, 1, 1, 0, 1]\n\n# dict — model config, hyperparameters\nconfig = {"lr": 0.001, "epochs": 100, "batch": 32}',
        keyTakeaway: 'Type errors are the most common Python bug in AI code. Always know what type your variables hold — especially when mixing NumPy arrays, Python lists, and pandas Series which look similar but behave differently in ML operations.',
      ),
      ConceptLesson(
        title: 'Type Conversion — A Critical AI Skill',
        definition: 'AI libraries often require specific data types. Knowing how to convert between types — and when Python does it automatically vs when it does not — prevents the most common ML library errors.',
        analogy: 'Type conversion in AI is like currency exchange — your data might be in Indian Rupees (Python list) but the ML library speaks US Dollars (NumPy array). You need to exchange it correctly before the transaction works.',
        example: '# Common type conversions in AI code:\n\n# String to number (reading CSV data)\nage_str = "25"\nage_int = int(age_str)    # 25\nprice_str = "1299.99"\nprice_float = float(price_str)  # 1299.99\n\n# List to NumPy array (required by sklearn)\nimport numpy as np\nfeatures_list = [5.1, 3.5, 1.4, 0.2]\nfeatures_array = np.array(features_list)  # shape: (4,)\n\n# Reshape for model input (common in deep learning)\nfeatures_2d = features_array.reshape(1, -1)  # shape: (1, 4)\n\n# Pandas to NumPy (very common in ML)\nimport pandas as pd\ndf = pd.read_csv("data.csv")\nX = df[["age", "income", "score"]].values  # NumPy array\ny = df["label"].values\n\n# Float to int for class labels\nprob = 0.73\nlabel = int(prob > 0.5)  # 1 (True → int 1)',
        keyTakeaway: 'The most common AI type conversion: pandas DataFrame → NumPy array using .values or .to_numpy(). The second most common: Python list → NumPy array using np.array(). Master these two and you eliminate 90% of type errors in ML code.',
      ),
      ConceptLesson(
        title: 'Strings for AI — Text Processing Basics',
        definition: 'Text is the most common data type in modern AI. String operations — splitting, stripping, replacing, formatting — are used constantly for data cleaning, file path handling, and preparing text for NLP models.',
        analogy: 'String processing for AI is like cleaning and sorting raw ingredients before cooking — the text data arrives messy (extra spaces, inconsistent capitalisation, special characters) and must be cleaned before any AI model can use it effectively.',
        example: '# String operations critical for AI data cleaning:\n\n# Clean text for NLP preprocessing\nraw_text = "  Hello! This is a Product Review. 5/5 Stars.  "\n\n# Strip whitespace\nclean = raw_text.strip()  # "Hello! This is..."\n\n# Lowercase for consistent processing\nlower = clean.lower()  # "hello! this is a product review..."\n\n# Split into words (tokenisation basics)\nwords = lower.split()  # ["hello!", "this", "is", ...]\n\n# Remove punctuation\nimport re\nno_punct = re.sub(r"[^a-zA-Z0-9 ]", "", clean)\n\n# F-strings for model output reporting\naccuracy = 0.9734\nepoch = 42\nprint(f"Epoch {epoch}: accuracy = {accuracy:.2%}")\n# Output: "Epoch 42: accuracy = 97.34%"\n\n# File path handling\nbase_dir = "datasets"\ndataset = "crop_disease"\npath = f"{base_dir}/{dataset}/train/"',
        keyTakeaway: 'In NLP (Natural Language Processing), text cleaning — lowercase, strip, remove special characters — is always done before tokenisation. Build these string operations into muscle memory because you will use them in every text AI project.',
      ),
      ConceptLesson(
        title: 'Lists and Dicts — The AI Engineer\'s Containers',
        definition: 'Lists store ordered sequences (feature vectors, training batches, prediction outputs). Dicts store key-value mappings (model configs, class label mappings, experiment results). Together they are the backbone of data handling in AI.',
        analogy: 'Lists are like numbered seats in a cinema — you access data by position (row 3 is seat 3). Dicts are like name badges at a conference — you access data by name (badge "learning_rate" gives you 0.001). Each is optimal for different data access patterns.',
        example: '# Lists in AI — feature vectors and batches:\nfeature_names = ["age", "income", "credit_score", "tenure"]\nfeature_vector = [32, 75000, 720, 36]\n\n# List operations:\nfeature_names.append("loan_amount")  # add feature\nnum_features = len(feature_names)    # 5\nfirst_feature = feature_names[0]     # "age"\nlast_feature = feature_names[-1]     # "loan_amount"\n\n# List comprehension — very common in AI:\nscaled = [x / 100000 for x in feature_vector]  # normalise\npositive_preds = [p for p in predictions if p > 0.5]\n\n# Dicts in AI — model config and results:\nhyperparams = {\n    "learning_rate": 0.001,\n    "n_estimators": 100,\n    "max_depth": 5,\n    "batch_size": 32\n}\n\n# Class label mapping:\nclass_map = {0: "cat", 1: "dog", 2: "bird"}\n\n# Access and update:\nlr = hyperparams["learning_rate"]  # 0.001\nhyperparams["epochs"] = 50        # add new key\nresults = {"accuracy": 0.94, "f1": 0.93, "auc": 0.97}',
        keyTakeaway: 'List comprehensions are the most Pythonic pattern for data transformation in AI. [transform(x) for x in data if condition(x)] replaces 5-line for loops with a single readable line. Master this pattern — you will use it daily.',
      ),
      ConceptLesson(
        title: 'Operators and Comparisons in AI Code',
        definition: 'Python operators power the logic in every ML pipeline — arithmetic for calculations, comparison for filtering data, logical for combining conditions, and the walrus operator (:=) for concise training loops.',
        analogy: 'Operators in AI code are like the rules of arithmetic in mathematics — they seem basic but they are what give your code its reasoning power. Without precise operator knowledge, your model evaluation logic, data filtering, and training conditions all fail.',
        example: '# Arithmetic operators in AI:\nloss = (y_pred - y_true) ** 2  # squared error\nmse = total_loss / n_samples   # mean calculation\nnormalized = (x - x_min) / (x_max - x_min)  # min-max scaling\n\n# Comparison operators for data filtering:\nhigh_confidence = predictions[predictions > 0.8]\npositive_class = labels[labels == 1]\nnot_missing = data[data != -1]\n\n# Logical operators combining conditions:\nvalid_samples = (age > 0) & (age < 120) & (income >= 0)\n# Note: use & not "and" for NumPy/pandas arrays!\n\n# Augmented assignment in training loops:\ntotal_loss = 0\ncorrect = 0\nfor pred, true in zip(predictions, labels):\n    total_loss += (pred - true) ** 2\n    correct += (pred == true)\n\n# Floor division and modulo for batching:\nn_samples = 1000\nbatch_size = 32\nn_batches = n_samples // batch_size  # 31\nremainder = n_samples % batch_size   # 8 leftover',
        keyTakeaway: 'The critical distinction: use & (bitwise AND) and | (bitwise OR) for NumPy/pandas array comparisons — NOT the Python keywords "and" and "or". Using "and" on an array raises a ValueError that confuses many beginners.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'You load a CSV where the "age" column contains "25", "30", "28" as strings. You try to compute the mean. What must you do first?',
        options: [
          'Nothing — Python automatically converts strings to numbers',
          'Convert to numeric type: df["age"] = pd.to_numeric(df["age"]) or df["age"].astype(int)',
          'Use the str.mean() method on the string column',
          'Sort the column first before computing mean'
        ],
        correctIndex: 1,
        explanation: 'String columns cannot be mathematically averaged. You must convert to numeric first using pd.to_numeric() or .astype(int/float). This is one of the most common data cleaning steps in every ML pipeline.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does this list comprehension produce?\nresult = [x**2 for x in range(5) if x % 2 == 0]',
        options: [
          '[0, 1, 4, 9, 16]',
          '[0, 4, 16] — squares of even numbers 0, 2, 4',
          '[1, 9, 25] — squares of odd numbers',
          '[0, 2, 4] — even numbers only'
        ],
        correctIndex: 1,
        explanation: 'range(5) = [0,1,2,3,4]. Filter even (x%2==0): [0,2,4]. Square each: [0,4,16]. List comprehensions with if conditions are extremely common in AI for filtering samples, selecting features, and transforming predictions.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'You want to filter a pandas Series where values are > 0.5 AND < 0.9. Which is correct?',
        options: [
          'series[series > 0.5 and series < 0.9]',
          'series[(series > 0.5) & (series < 0.9)]',
          'series[series > 0.5 & series < 0.9]',
          'series.filter(lambda x: x > 0.5 and x < 0.9)'
        ],
        correctIndex: 1,
        explanation: 'For NumPy arrays and pandas Series, use & (bitwise AND) not "and". Each condition must be in parentheses: (series > 0.5) & (series < 0.9). Using "and" raises ValueError: "The truth value of a Series is ambiguous."',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'data = ["25", "30", None, "28", "abc", "35"]\nYou need a clean list of integers for ML training.\nWhich approach correctly handles all edge cases?',
        options: [
          'clean = [int(x) for x in data]',
          'clean = [int(x) for x in data if x is not None and x.isdigit()]',
          'clean = list(map(int, data))',
          'clean = [x for x in data if x != None]'
        ],
        correctIndex: 1,
        explanation: 'The safe approach: filter None first (x is not None), then check if it is a valid digit string (x.isdigit()) before converting. The naive int(x) would crash on None and "abc". Real ML data is always messy — handle all edge cases.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'config = {"lr": 0.001, "epochs": 100}\nYou want to add "batch_size": 32 and update "epochs" to 50.\nWhat is the correct code?',
        options: [
          'config.add("batch_size", 32)\nconfig.update_key("epochs", 50)',
          'config["batch_size"] = 32\nconfig["epochs"] = 50',
          'config.append({"batch_size": 32})\nconfig["epochs"] == 50',
          'config = config + {"batch_size": 32, "epochs": 50}'
        ],
        correctIndex: 1,
        explanation: 'Dict assignment: config["new_key"] = value adds new keys. config["existing_key"] = value updates existing keys. Both use the same syntax — Python automatically handles add vs update based on whether the key exists.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Data Type Detective — AI Data Cleaning Pipeline',
      goal: 'Build a complete Python data cleaning pipeline that handles real-world messy data using proper data type operations.',
      steps: [
        'Create a dictionary representing a raw dataset of 10 customer records with mixed types: ages as strings, incomes as strings with commas, booleans as "Yes"/"No", missing values as None or empty string',
        'Write clean_age(value) that converts string ages to int, returns None for invalid values, and flags ages outside 0-120',
        'Write clean_income(value) that removes commas, converts to float, and returns None for non-numeric values',
        'Write clean_boolean(value) that converts "Yes"/"No"/"True"/"False"/"1"/"0" to Python bool',
        'Write a master clean_record(record) function that applies all cleaners and returns a cleaned dict with a "data_quality" score (% of valid fields)',
        'Process all 10 records and print a summary showing how many records are clean vs have issues',
      ],
      expectedOutput: 'Processing 10 customer records...\n\nRecord 1: age=25, income=75000.0, active=True | quality=100%\nRecord 3: age=None(invalid), income=None(missing) | quality=40%\nRecord 7: age=150(out of range), income=120000.0 | quality=60%\n\nSummary:\n  Clean records (>80% quality): 6\n  Partial records (40-80%): 3\n  Unusable records (<40%): 1\n  Total field issues: 8',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'aep_l2_control_flow',
    topicTitle: 'Conditional Statements & Loops',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 185,
    emoji: '🔀',
    intro: 'Control flow is the skeleton of every AI pipeline. Training loops iterate through data batches. Conditionals route predictions to different actions. Understanding how to write efficient, readable control flow is what makes your AI code performant and correct — not just working.',
    concepts: [
      ConceptLesson(
        title: 'Conditionals in AI — Decision Making in Code',
        definition: 'if/elif/else statements control which code path executes based on conditions. In AI, they power prediction routing, data quality checks, training decisions, and threshold-based classification.',
        analogy: 'Conditionals in AI code are like a doctor\'s decision tree — IF temperature > 38.5 THEN flag as fever, ELIF temperature > 37.5 THEN monitor, ELSE normal. The code makes the same structured decision the doctor makes, but at millions of predictions per second.',
        example: '# Conditionals in real AI scenarios:\n\n# 1. Threshold-based prediction routing\ndef classify_confidence(probability):\n    if probability >= 0.9:\n        return "high_confidence", "auto_approve"\n    elif probability >= 0.7:\n        return "medium_confidence", "human_review"\n    elif probability >= 0.5:\n        return "low_confidence", "flag_for_review"\n    else:\n        return "below_threshold", "reject"\n\n# 2. Data quality check\ndef validate_age(age):\n    if age is None:\n        return "missing"\n    elif not isinstance(age, (int, float)):\n        return "wrong_type"\n    elif age < 0 or age > 120:\n        return "out_of_range"\n    else:\n        return "valid"\n\n# 3. Training decision\nif val_loss < best_loss:\n    best_loss = val_loss\n    save_model(model, "best_model.pt")\n    patience_counter = 0\nelse:\n    patience_counter += 1\n    if patience_counter >= patience:\n        print("Early stopping triggered")\n        break',
        keyTakeaway: 'In production AI, always use thresholds thoughtfully — the boundary between "auto-approve" and "human review" is a business decision with real consequences. Make these thresholds configurable (not hard-coded) so they can be adjusted without changing the code.',
      ),
      ConceptLesson(
        title: 'For Loops — Iterating Over AI Data',
        definition: 'For loops iterate over sequences: lists of samples, rows in a DataFrame, batches in a dataset, or experiments in a hyperparameter search. Python\'s for loop is more readable than C/Java equivalents and integrates naturally with AI data structures.',
        analogy: 'A for loop in AI training is like an assembly line in a factory — each batch of data goes through the same processing steps (forward pass, calculate loss, backpropagate, update weights) in sequence. The loop ensures every batch gets processed exactly once per epoch.',
        example: '# For loops in AI workflows:\n\n# 1. Processing a dataset batch by batch\nfor batch_idx, (X_batch, y_batch) in enumerate(dataloader):\n    predictions = model(X_batch)\n    loss = criterion(predictions, y_batch)\n    print(f"Batch {batch_idx}: loss={loss:.4f}")\n\n# 2. Iterating over features for analysis\nfeature_names = ["age", "income", "score"]\nfor feature in feature_names:\n    missing = df[feature].isnull().sum()\n    print(f"{feature}: {missing} missing values")\n\n# 3. Grid search over hyperparameters\nlearning_rates = [0.1, 0.01, 0.001, 0.0001]\nresults = {}\nfor lr in learning_rates:\n    model = train_model(learning_rate=lr)\n    acc = evaluate(model)\n    results[lr] = acc\n    print(f"lr={lr}: accuracy={acc:.4f}")\n\nbest_lr = max(results, key=results.get)\nprint(f"Best learning rate: {best_lr}")',
        keyTakeaway: 'enumerate() is essential for for loops in AI — it gives you both the index and value simultaneously. Use it whenever you need to track which batch, which epoch, or which sample you are processing.',
      ),
      ConceptLesson(
        title: 'While Loops — Training Until Convergence',
        definition: 'While loops run until a condition becomes False. In AI, they power training loops that run until convergence, early stopping logic, retry mechanisms for API calls, and data generation until a quota is met.',
        analogy: 'A while loop in model training is like a sculptor chipping away at marble — you keep refining until the statue looks right (loss converges), not for a fixed number of chops. You stop when the condition (accuracy threshold met, loss plateau) is satisfied.',
        example: '# While loops in AI:\n\n# 1. Training until convergence\nepoch = 0\nbest_loss = float("inf")\npatience = 5\nno_improve = 0\n\nwhile no_improve < patience:\n    epoch += 1\n    train_loss = train_one_epoch(model, data)\n    val_loss = validate(model, val_data)\n\n    if val_loss < best_loss:\n        best_loss = val_loss\n        no_improve = 0\n        save_checkpoint(model)\n    else:\n        no_improve += 1\n\n    print(f"Epoch {epoch}: val_loss={val_loss:.4f}")\n\nprint(f"Training stopped. Best loss: {best_loss:.4f}")\n\n# 2. Retry failed API calls\nmax_retries = 3\nretries = 0\nwhile retries < max_retries:\n    try:\n        response = call_llm_api(prompt)\n        break  # success, exit loop\n    except Exception as e:\n        retries += 1\n        print(f"Retry {retries}/{max_retries}: {e}")',
        keyTakeaway: 'Always set a maximum iteration limit in while loops — infinite loops crash AI training scripts. Use break to exit when the condition is met, and always have a fallback counter (max_retries, max_epochs) as a safety net.',
      ),
      ConceptLesson(
        title: 'List Comprehensions and Generator Expressions',
        definition: 'List comprehensions create new lists in a single, readable line. Generator expressions do the same but lazily (one element at a time) — essential for processing large datasets that do not fit in memory.',
        analogy: 'A list comprehension is like a factory that produces all products at once and stores them. A generator is like a factory that produces one product on demand and immediately hands it to the next worker — using far less warehouse space for the same throughput.',
        example: '# List comprehensions in AI:\n\n# Feature scaling (normalisation)\nvalues = [15, 25, 30, 45, 60]\nmin_v, max_v = min(values), max(values)\nnormalized = [(x - min_v) / (max_v - min_v) for x in values]\n# [0.0, 0.22, 0.33, 0.67, 1.0]\n\n# Filter high-confidence predictions\npredictions = [0.3, 0.8, 0.95, 0.45, 0.91]\nhigh_conf = [p for p in predictions if p > 0.8]\n# [0.95, 0.91]\n\n# Apply function to all elements\nlabels = [0, 1, 1, 0, 1]\nlabel_names = ["negative" if l==0 else "positive"\n               for l in labels]\n\n# Generator for large dataset processing:\ndef load_large_dataset(file_path):\n    with open(file_path) as f:\n        for line in f:  # reads ONE line at a time\n            yield process_line(line)  # generator!\n\n# This processes 10GB files without loading all in RAM:\nfor sample in load_large_dataset("huge_dataset.csv"):\n    model.train_on_sample(sample)',
        keyTakeaway: 'For large ML datasets (millions of samples), always use generators or PyTorch DataLoader — loading everything into RAM causes out-of-memory crashes. The yield keyword creates a generator that produces one sample at a time on demand.',
      ),
      ConceptLesson(
        title: 'Loop Control — break, continue, and else',
        definition: 'break exits a loop immediately. continue skips the current iteration. else on a for/while loop runs only if the loop completed WITHOUT a break — useful for AI workflows that need to know if all items passed validation.',
        analogy: 'break is like a fire alarm stopping the assembly line immediately. continue is like skipping a defective product and moving to the next one. The else clause is like a quality certificate that is only issued if the entire assembly line ran without any fire alarms.',
        example: '# Loop control in AI data validation:\n\n# continue — skip invalid samples\nclean_samples = []\nfor sample in raw_samples:\n    if sample["age"] is None:\n        continue  # skip, process next sample\n    if sample["income"] < 0:\n        continue  # skip invalid income\n    clean_samples.append(sample)\n\n# break — stop when enough data found\npositive_samples = []\nfor sample in all_samples:\n    if sample["label"] == 1:\n        positive_samples.append(sample)\n    if len(positive_samples) == 1000:\n        break  # found enough, stop searching\n\n# for-else — validate ALL samples passed\nfor i, value in enumerate(feature_values):\n    if value < 0:\n        print(f"Invalid value at index {i}")\n        break\nelse:\n    # Only runs if loop completed without break\n    print("All values are valid — safe to train")',
        keyTakeaway: 'The for-else pattern is underused but powerful for AI validation — it elegantly expresses "if any sample fails this check, abort; otherwise, proceed." This is cleaner than setting a boolean flag and checking it after the loop.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'In a model training loop, you want to print progress every 10 batches and skip expensive logging on all others. Which control statement?',
        options: [
          'break when batch_idx % 10 != 0',
          'continue when batch_idx % 10 != 0 — skips the logging code for batches that are not multiples of 10',
          'while batch_idx % 10 == 0 for the logging',
          'if batch_idx == 10: pass'
        ],
        correctIndex: 1,
        explanation: 'continue skips the rest of the current iteration. Using "if batch_idx % 10 != 0: continue" at the top of the loop body means all expensive logging code below it is skipped for non-milestone batches — efficient and readable.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the output?\nresult = [x*2 for x in range(4) if x != 2]',
        options: [
          '[0, 2, 4, 6]',
          '[0, 2, 6] — doubles of 0, 1, 3 (2 is excluded)',
          '[0, 4, 8] — doubles of 0, 2, 4',
          '[2, 4, 6]'
        ],
        correctIndex: 1,
        explanation: 'range(4) = [0,1,2,3]. Filter: exclude x==2 → [0,1,3]. Double each: [0,2,6]. The condition "if x != 2" filters out the value 2 before the transformation x*2 is applied.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is a generator (using yield) better than a list for loading a 50GB training dataset?',
        options: [
          'Generators are faster than lists',
          'Generators produce one sample at a time on demand — loading a 50GB list into RAM crashes the program. Generators use a few MB regardless of dataset size.',
          'Lists cannot store more than 1 million items',
          'Generators automatically clean the data'
        ],
        correctIndex: 1,
        explanation: 'A list loads ALL data into RAM simultaneously — impossible for 50GB datasets. A generator yields one sample at a time, using only the memory needed for that one sample. PyTorch DataLoader uses this pattern internally for all large dataset training.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You have predictions = [0.2, 0.8, 0.6, 0.9, 0.1, 0.75]\nWrite a one-line list comprehension that returns a list of "positive" where prediction > 0.5, else "negative".',
        options: [
          'labels = ["positive" for p in predictions if p > 0.5]',
          'labels = ["positive" if p > 0.5 else "negative" for p in predictions]',
          'labels = [p > 0.5 for p in predictions]',
          'labels = filter(lambda p: p > 0.5, predictions)'
        ],
        correctIndex: 1,
        explanation: 'The ternary expression inside a list comprehension: [value_if_true if condition else value_if_false for item in iterable]. This produces ["negative","positive","positive","positive","negative","positive"] — all 6 items, with the label determined per item.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'A training loop must stop if loss becomes NaN (not a number). Which control statement handles this?',
        options: [
          'continue — skip the NaN batch',
          'break with an import math check: if math.isnan(loss): break — immediately stop training to prevent NaN propagation through the entire model',
          'pass — ignore NaN and continue',
          'return — return from the training function'
        ],
        correctIndex: 1,
        explanation: 'NaN loss propagates through backpropagation and corrupts all model weights. break immediately stops the training loop when NaN is detected. Always check for NaN loss in production training loops — it is a sign of too high learning rate or data issues.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Mini Training Loop Simulator',
      goal: 'Build a complete simulated training loop demonstrating all control flow concepts in an AI context.',
      steps: [
        'Simulate a dataset of 1000 samples with randomly generated features and binary labels using random module',
        'Implement a batch_generator(data, batch_size) generator function that yields data in batches of 32',
        'Write a training loop that iterates 20 epochs with the batch generator, computes a fake "loss" (decreasing each epoch with random noise)',
        'Implement early stopping: if loss does not improve for 3 consecutive epochs, break with a message',
        'Use continue to skip any batch where more than 50% of labels are the same (simulate class imbalance skip)',
        'After training, use list comprehension to classify all predictions with threshold 0.5 and print accuracy',
      ],
      expectedOutput: 'Epoch 1/20: avg_loss=0.6832 | batches=31\nEpoch 2/20: avg_loss=0.6241 | batches=31\n...\nEpoch 7/20: avg_loss=0.5102 | batches=31\nEarly stopping triggered at epoch 10 (no improvement for 3 epochs)\n\nFinal evaluation:\n  Predictions classified: 1000\n  Accuracy: 73.4%\n  Training history saved to list ✓',
      xpReward: 45,
    ),
  ),

  TopicCourse(
    id: 'aep_l2_functions_modules',
    topicTitle: 'Functions & Modules',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 190,
    emoji: '🧩',
    intro: 'Well-designed functions are what make AI pipelines maintainable, testable, and reusable. Professional ML engineers structure every pipeline as composable functions — each doing one thing well. This course teaches you to write production-quality functions and organise your AI code into proper modules.',
    concepts: [
      ConceptLesson(
        title: 'Functions in AI — Single Responsibility Principle',
        definition: 'Every function in an AI pipeline should do exactly ONE thing — load data, preprocess, train, evaluate, or save. Functions that do multiple things are hard to test, reuse, and debug when something goes wrong.',
        analogy: 'Functions in AI code are like specialist doctors — the cardiologist does not also do knee surgery. A function named train_model() should not also clean data, save results, and send email notifications. Each function has one clear responsibility.',
        example: '# BAD — one function doing everything:\ndef run_everything(file_path):\n    df = pd.read_csv(file_path)       # load\n    df = df.dropna()                   # clean\n    X, y = df.drop("label"), df["label"]  # split\n    model = RandomForest().fit(X, y)  # train\n    acc = model.score(X, y)           # evaluate\n    print(f"Accuracy: {acc}")         # report\n    model.save("model.pkl")           # save\n\n# GOOD — one function, one responsibility:\ndef load_data(file_path: str) -> pd.DataFrame:\n    """Load CSV dataset from file path."""\n    return pd.read_csv(file_path)\n\ndef clean_data(df: pd.DataFrame) -> pd.DataFrame:\n    """Remove missing values and validate types."""\n    return df.dropna()\n\ndef train_model(X, y) -> RandomForestClassifier:\n    """Train and return a Random Forest classifier."""\n    return RandomForestClassifier().fit(X, y)\n\ndef evaluate_model(model, X_test, y_test) -> dict:\n    """Return dict of evaluation metrics."""\n    return {"accuracy": model.score(X_test, y_test)}',
        keyTakeaway: 'The single responsibility principle makes your AI functions independently testable. You can test load_data() with a mock file, test clean_data() with a prepared DataFrame, and test train_model() with synthetic data — without ever needing all three to work simultaneously.',
      ),
      ConceptLesson(
        title: 'Default Arguments and *args, **kwargs',
        definition: 'Default arguments make functions flexible with sensible defaults. *args accepts variable positional arguments. **kwargs accepts variable keyword arguments. Together they power highly configurable ML functions and are used extensively in scikit-learn and PyTorch APIs.',
        analogy: 'Default arguments are like a restaurant\'s standard meal — you get rice, dal, and sabzi by default. But you can customise: extra spicy (kwarg), two rotis instead of one (arg). Most customers use defaults; power users customise.',
        example: '# Default arguments in ML:\ndef train_model(\n    X_train,\n    y_train,\n    n_estimators=100,      # default: 100 trees\n    max_depth=None,        # default: no limit\n    random_state=42,       # default: reproducible\n    test_size=0.2          # default: 20% test\n):\n    model = RandomForestClassifier(\n        n_estimators=n_estimators,\n        max_depth=max_depth,\n        random_state=random_state\n    )\n    return model.fit(X_train, y_train)\n\n# Use with defaults:\nmodel = train_model(X, y)\n\n# Customise specific parameters:\nmodel = train_model(X, y, n_estimators=500, max_depth=10)\n\n# **kwargs for flexible model configuration:\ndef create_model(model_type="rf", **model_params):\n    if model_type == "rf":\n        return RandomForestClassifier(**model_params)\n    elif model_type == "xgb":\n        return XGBClassifier(**model_params)\n\nmodel = create_model("rf", n_estimators=200, max_depth=5)',
        keyTakeaway: '**kwargs is how scikit-learn, PyTorch, and TensorFlow APIs are designed — they accept arbitrary keyword arguments and pass them through. Understanding this pattern means you can work fluently with any ML library\'s API without memorising every parameter.',
      ),
      ConceptLesson(
        title: 'Lambda Functions for Data Transformation',
        definition: 'Lambda functions are anonymous single-expression functions. In AI, they are used with map(), filter(), sorted(), and pandas .apply() for concise data transformations without defining full named functions.',
        analogy: 'Lambda functions are like Post-it note instructions — too small to deserve a full memo (named function), but precise enough to communicate a specific transformation. Use them for quick one-off operations; use named functions when the logic needs a name.',
        example: '# Lambda functions in AI data processing:\n\n# With pandas apply() — most common AI use case:\ndf["log_income"] = df["income"].apply(lambda x: np.log(x+1))\ndf["age_group"] = df["age"].apply(\n    lambda x: "young" if x < 30 else "senior" if x > 60 else "adult"\n)\n\n# Sorting model results:\nexperiments = [\n    {"name": "rf", "accuracy": 0.89},\n    {"name": "xgb", "accuracy": 0.93},\n    {"name": "lr", "accuracy": 0.81}\n]\nbest_first = sorted(experiments,\n                    key=lambda x: x["accuracy"],\n                    reverse=True)\n\n# Filter predictions above threshold:\nhigh_conf = list(filter(lambda p: p > 0.8, predictions))\n\n# Apply normalisation:\nnormalize = lambda x, min_v, max_v: (x - min_v) / (max_v - min_v)\nscaled = [normalize(v, 0, 100) for v in raw_values]',
        keyTakeaway: 'pandas .apply(lambda x: ...) is one of the most used patterns in data science. It applies a function to every element of a Series or row/column of a DataFrame. Master this pattern — it appears in almost every data preprocessing notebook.',
      ),
      ConceptLesson(
        title: 'Python Modules and Package Structure',
        definition: 'Python modules are .py files that can be imported. Packages are directories with __init__.py. Professional AI projects organise code into modules: data.py, models.py, train.py, evaluate.py, utils.py.',
        analogy: 'Python modules in an AI project are like the different departments in a company — the data team (data.py), model design team (models.py), training team (train.py), and quality control team (evaluate.py). Each department has its own responsibilities but they work together.',
        example: '# Professional AI project structure:\n#\n# my_ai_project/\n# ├── data/\n# │   ├── __init__.py\n# │   ├── loader.py      # load_csv(), load_images()\n# │   └── preprocessor.py # clean(), encode(), scale()\n# ├── models/\n# │   ├── __init__.py\n# │   ├── classifier.py  # build_model(), load_model()\n# │   └── evaluator.py   # accuracy(), f1(), confusion_matrix()\n# ├── utils/\n# │   ├── __init__.py\n# │   └── logger.py      # setup_logging(), log_metrics()\n# ├── train.py           # main training script\n# └── config.py          # hyperparameters, paths\n\n# Import between modules:\n# In train.py:\nfrom data.loader import load_csv\nfrom data.preprocessor import clean, scale\nfrom models.classifier import build_model\nfrom models.evaluator import accuracy\nfrom config import HYPERPARAMS',
        keyTakeaway: 'A proper project structure makes your AI code collaborative. When a teammate opens your project, they immediately know where to find the data loading code (data/loader.py), model code (models/classifier.py), and training code (train.py) — without asking you.',
      ),
      ConceptLesson(
        title: 'Decorators — Powering MLOps Patterns',
        definition: 'Decorators wrap functions to add behaviour (logging, timing, caching) without changing the function itself. They power FastAPI route definitions, PyTorch hooks, and MLOps instrumentation patterns.',
        analogy: 'A decorator is like giftwrapping a present — the original gift (function) is unchanged inside, but the wrapper adds something extra (timing, logging, authentication) that the receiver sees first. Multiple wrappers can be stacked.',
        example: '# Decorator patterns in AI engineering:\n\nimport time\nimport functools\n\n# Timing decorator for ML experiments:\ndef timer(func):\n    @functools.wraps(func)\n    def wrapper(*args, **kwargs):\n        start = time.time()\n        result = func(*args, **kwargs)\n        elapsed = time.time() - start\n        print(f"{func.__name__} took {elapsed:.2f}s")\n        return result\n    return wrapper\n\n@timer\ndef train_model(X, y):\n    model = RandomForestClassifier(n_estimators=500)\n    return model.fit(X, y)\n\n# Output: "train_model took 3.24s"\n\n# FastAPI uses decorators for AI API routes:\nfrom fastapi import FastAPI\napp = FastAPI()\n\n@app.post("/predict")\ndef predict(data: dict):\n    features = preprocess(data)\n    prediction = model.predict([features])\n    return {"prediction": int(prediction[0])}',
        keyTakeaway: 'The @timer decorator pattern is essential for ML experimentation — you need to know how long each training step, data loading, and preprocessing takes to optimise your pipeline. Add timing decorators to every major function in your AI pipeline from day one.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A function called "train_and_evaluate_and_save_and_plot_model()" violates which principle?',
        options: [
          'It violates Python naming conventions',
          'Single Responsibility Principle — it does four things. It should be four separate functions: train_model(), evaluate_model(), save_model(), plot_results()',
          'It is too long to be a valid function name',
          'Functions should not contain "and" in their names'
        ],
        correctIndex: 1,
        explanation: 'A function that does multiple things (train AND evaluate AND save AND plot) is hard to test, reuse, and debug. If training works but saving fails, you cannot test saving independently. Split into focused single-responsibility functions.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does **kwargs allow in a function definition?',
        options: [
          'Accepts unlimited positional arguments as a tuple',
          'Accepts any number of keyword arguments as a dictionary — enabling flexible ML functions that pass configuration through to underlying libraries',
          'Makes all arguments optional',
          'Accepts arguments from a JSON file'
        ],
        correctIndex: 1,
        explanation: '**kwargs collects any additional keyword arguments into a dict. This is how scikit-learn passes parameters through — RandomForestClassifier(**params) where params is a dict of any hyperparameters. Essential for building configurable ML pipelines.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'df["category"] = df["score"].apply(lambda x: "A" if x>=90 else "B" if x>=70 else "C")\nWhat category gets a score of 75?',
        options: [
          '"A"',
          '"B" — 75 is >= 70 but < 90',
          '"C"',
          'Error — lambda cannot have multiple conditions'
        ],
        correctIndex: 1,
        explanation: '75 is not >= 90 (not A). 75 IS >= 70 (B). The lambda evaluates left to right: if 90 fails, try 70 — it succeeds, so return "B". Chained ternary expressions in lambdas are evaluated sequentially.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You want to time how long model.fit(X, y) takes without modifying the fit() function. What is the cleanest approach?',
        options: [
          'Add print(time.time()) before and after every fit() call manually',
          'Write a @timer decorator that wraps any function and prints execution time, then apply @timer to your wrapper function that calls fit()',
          'Use a global variable to track time',
          'Modify the sklearn source code to add timing'
        ],
        correctIndex: 1,
        explanation: 'Decorators add behaviour without modifying the original function. A @timer decorator wraps your training function, measures execution time, and prints it — the training function itself remains unchanged and reusable without the timing.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'experiments = [{"model": "RF", "f1": 0.87}, {"model": "XGB", "f1": 0.93}, {"model": "LR", "f1": 0.79}]\nSort this list from highest to lowest F1 score using a lambda.',
        options: [
          'sorted(experiments, key="f1")',
          'sorted(experiments, key=lambda x: x["f1"], reverse=True)',
          'experiments.sort(lambda x: x["f1"])',
          'sorted(experiments, reverse=True)'
        ],
        correctIndex: 1,
        explanation: 'sorted() with key=lambda x: x["f1"] sorts by the "f1" key of each dict. reverse=True gives highest first. Result: [XGB 0.93, RF 0.87, LR 0.79]. This pattern sorts experiment results, model rankings, and hyperparameter search outputs.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Modular AI Pipeline — Proper Project Structure',
      goal: 'Build a properly structured, modular AI project demonstrating professional function design and module organisation.',
      steps: [
        'Create a mini-project with 4 Python files: config.py (hyperparameters), data_utils.py (loading and cleaning functions), model_utils.py (build, train, evaluate functions), and main.py (orchestrates everything)',
        'In config.py: define constants for DATA_PATH, TEST_SIZE, RANDOM_STATE, and a HYPERPARAMS dict',
        'In data_utils.py: write load_data(), clean_data(), split_features_target(), and train_test_split_data() — each with docstrings',
        'In model_utils.py: write build_model(**params), train_model(), evaluate_model() returning a metrics dict, and a @timer decorator for all training functions',
        'In main.py: import from all modules and run the full pipeline in order using proper function calls',
        'Run main.py and verify clean execution with properly formatted output showing each step',
      ],
      expectedOutput: '=== AI Pipeline Starting ===\n[config] Loaded: test_size=0.2, random_state=42\n[data] Loading data... 150 samples loaded\n[data] Cleaning... 0 rows dropped\n[data] Split: X_train(120,4), X_test(30,4)\n[model] Building RandomForestClassifier...\n[timer] train_model() took 0.08s\n[model] Training complete\n[eval] Accuracy: 96.67%\n[eval] F1 Score: 0.967\n[eval] AUC-ROC: 0.995\n=== Pipeline Complete ===',
      xpReward: 55,
    ),
  ),

TopicCourse(
    id: 'aep_l2_oop',
    topicTitle: 'Object-Oriented Programming in Python',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 205,
    emoji: '🏗️',
    intro: 'OOP is how professional AI systems are built. PyTorch models are classes. scikit-learn estimators are classes. FastAPI apps use classes. Every serious ML framework is built on OOP. This course teaches OOP through real AI engineering examples so you can read, extend, and build production AI systems.',
    concepts: [
      ConceptLesson(
        title: 'Classes in AI — Building Custom ML Components',
        definition: 'A class bundles data (attributes) and behaviour (methods) together. In AI, classes represent models, datasets, trainers, and pipelines — objects that hold state (weights, configuration) and behaviour (fit, predict, transform).',
        analogy: 'A class in AI is like the blueprint for a machine learning model. The blueprint (class) defines what the model looks like and what it can do. Each trained model (instance) is built from that blueprint but holds its own learned weights and configuration.',
        example: '# Custom ML model as a class:\nclass SimpleLinearClassifier:\n    """A simple linear classifier for binary classification."""\n\n    def __init__(self, learning_rate=0.01, epochs=100):\n        self.learning_rate = learning_rate\n        self.epochs = epochs\n        self.weights = None\n        self.bias = None\n        self.training_history = []\n\n    def fit(self, X, y):\n        """Train the classifier on data X with labels y."""\n        n_samples, n_features = X.shape\n        self.weights = np.zeros(n_features)\n        self.bias = 0\n        for epoch in range(self.epochs):\n            y_pred = self._sigmoid(X @ self.weights + self.bias)\n            loss = self._binary_cross_entropy(y, y_pred)\n            self.training_history.append(loss)\n        return self\n\n    def predict(self, X):\n        """Predict class labels for samples in X."""\n        probabilities = self._sigmoid(X @ self.weights + self.bias)\n        return (probabilities >= 0.5).astype(int)\n\n    def _sigmoid(self, z):\n        return 1 / (1 + np.exp(-z))\n\n    def _binary_cross_entropy(self, y_true, y_pred):\n        return -np.mean(y_true * np.log(y_pred + 1e-8))',
        keyTakeaway: 'Notice that scikit-learn\'s API (fit(), predict(), transform()) is a class-based design pattern. When you call model.fit(X, y), you are calling a method on a class instance. Understanding OOP lets you read, extend, and customise any ML library.',
      ),
      ConceptLesson(
        title: 'Inheritance — Extending ML Models',
        definition: 'Inheritance lets a child class acquire all methods of a parent class and add or override what it needs. In AI, you inherit from base classes to create specialised models, custom datasets, and extended pipelines.',
        analogy: 'Inheritance in AI is like a specialised doctor who first trains as a general physician (parent class) then specialises in cardiology (child class). They keep all general medicine skills and add specialised cardiac expertise on top.',
        example: '# Inheritance in PyTorch — the standard pattern:\nimport torch\nimport torch.nn as nn\n\n# Every PyTorch model inherits from nn.Module:\nclass CropDiseaseClassifier(nn.Module):\n    """CNN for classifying crop diseases from leaf images."""\n\n    def __init__(self, num_classes=10):\n        super().__init__()  # always call parent __init__\n        self.conv1 = nn.Conv2d(3, 32, kernel_size=3)\n        self.conv2 = nn.Conv2d(32, 64, kernel_size=3)\n        self.fc = nn.Linear(64 * 6 * 6, num_classes)\n        self.relu = nn.ReLU()\n        self.pool = nn.MaxPool2d(2)\n\n    def forward(self, x):  # override parent forward()\n        x = self.pool(self.relu(self.conv1(x)))\n        x = self.pool(self.relu(self.conv2(x)))\n        x = x.view(x.size(0), -1)  # flatten\n        return self.fc(x)\n\n# Usage — identical to any scikit-learn model:\nmodel = CropDiseaseClassifier(num_classes=10)\noutput = model(input_tensor)  # calls forward()',
        keyTakeaway: 'Every PyTorch model you will ever build inherits from nn.Module. Every scikit-learn custom estimator inherits from BaseEstimator. Understanding inheritance is not academic — it is the entry point to every serious AI framework.',
      ),
      ConceptLesson(
        title: 'Encapsulation — Protecting Model State',
        definition: 'Encapsulation hides internal implementation details and exposes a clean interface. In AI, this means users interact with fit() and predict() without needing to know about weight matrices, gradient computations, or numerical stability tricks.',
        analogy: 'Encapsulation in an ML model is like a car\'s accelerator pedal — you press it to go faster without knowing anything about fuel injection, engine timing, or gearbox ratios. The complex internals are hidden; you interact with the clean interface.',
        example: '# Encapsulation in a data preprocessing class:\nclass FeaturePreprocessor:\n    """Preprocesses features for ML training."""\n\n    def __init__(self):\n        self._scaler = None      # private — internal detail\n        self._encoder = None     # private — internal detail\n        self._feature_names = [] # private — internal detail\n        self.is_fitted = False   # public — safe to check\n\n    def fit(self, df: pd.DataFrame):\n        """Public interface — fit preprocessor to data."""\n        self._feature_names = list(df.columns)\n        self._scaler = StandardScaler().fit(df)\n        self.is_fitted = True\n        return self\n\n    def transform(self, df: pd.DataFrame) -> np.ndarray:\n        """Public interface — transform new data."""\n        if not self.is_fitted:\n            raise ValueError("Call fit() before transform()")\n        return self._scaler.transform(df)\n\n    # Users never call _scaler or _encoder directly\n    # They only use fit() and transform()',
        keyTakeaway: 'The underscore prefix (_attribute) signals "internal — do not use this directly." In production AI systems, hiding implementation details behind clean interfaces (fit/transform/predict) means you can change the internal algorithm without breaking any code that uses the class.',
      ),
      ConceptLesson(
        title: 'Special Methods — Making AI Classes Pythonic',
        definition: 'Special methods (__len__, __repr__, __getitem__, __iter__) make custom classes work with Python built-ins. In AI, these power custom Dataset classes that work seamlessly with PyTorch DataLoader.',
        analogy: 'Special methods are like teaching your custom object to speak Python\'s native language. Without them, Python does not know how to print your model, get its length, or index into your dataset. With them, your AI objects feel like native Python citizens.',
        example: '# Custom Dataset class with special methods:\nclass CropImageDataset:\n    """PyTorch-compatible dataset for crop images."""\n\n    def __init__(self, image_paths, labels, transform=None):\n        self.image_paths = image_paths\n        self.labels = labels\n        self.transform = transform\n\n    def __len__(self):\n        """Called by len(dataset) and DataLoader."""\n        return len(self.image_paths)\n\n    def __getitem__(self, idx):\n        """Called by dataset[0], dataset[42], DataLoader."""\n        image = load_image(self.image_paths[idx])\n        label = self.labels[idx]\n        if self.transform:\n            image = self.transform(image)\n        return image, label\n\n    def __repr__(self):\n        """Called by print(dataset)."""\n        return f"CropDataset({len(self)} samples, "\\\n               f"{len(set(self.labels))} classes)"\n\n# Now it works with all PyTorch tools:\ndataset = CropImageDataset(paths, labels)\nprint(len(dataset))   # calls __len__\nimg, lbl = dataset[0] # calls __getitem__\nprint(dataset)        # calls __repr__\nloader = DataLoader(dataset, batch_size=32)',
        keyTakeaway: '__len__ and __getitem__ are the two special methods that make any class compatible with PyTorch DataLoader. Implement these two methods in any custom dataset class and it immediately works with the full PyTorch training ecosystem.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'In PyTorch, every custom neural network class starts with class MyModel(nn.Module). What does this inheritance give you?',
        options: [
          'Access to the Python standard library',
          'All of PyTorch\'s parameter tracking, GPU transfer (.to(device)), saving/loading (.state_dict()), and gradient management — for free, without reimplementing them',
          'Automatic training loop generation',
          'Free access to pretrained weights'
        ],
        correctIndex: 1,
        explanation: 'Inheriting from nn.Module gives your model parameter tracking (model.parameters()), GPU support (model.to("cuda")), save/load (torch.save/load), and gradient hooks — all the infrastructure needed for production training. This is why every PyTorch model inherits from it.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A custom Dataset class needs to work with PyTorch DataLoader. Which two special methods MUST be implemented?',
        options: [
          '__init__ and __del__',
          '__len__ (returns dataset size) and __getitem__ (returns one sample by index) — DataLoader calls these internally to batch and shuffle data',
          '__repr__ and __str__',
          '__iter__ and __next__'
        ],
        correctIndex: 1,
        explanation: 'DataLoader needs to know the dataset size (__len__) to calculate batch counts and needs to access individual samples by index (__getitem__) to build batches. These two methods make any class a valid PyTorch dataset.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why should model internal weights and scalers be prefixed with underscore (self._weights) in Python classes?',
        options: [
          'Underscore makes attributes faster to access',
          'It signals "internal implementation detail — do not access this directly from outside the class." Users interact with fit() and predict(), not raw internal state.',
          'Python requires underscore for numeric attributes',
          'It prevents the attribute from being saved when pickling'
        ],
        correctIndex: 1,
        explanation: 'The underscore prefix is Python\'s convention for "private" — a signal to users that these are internal details. Users call model.fit() and model.predict(). If internal weights are exposed, users might modify them directly and break model integrity.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You are building a custom scikit-learn compatible model. Which methods MUST your class implement to work with cross_val_score() and GridSearchCV()?',
        options: [
          'Only __init__()',
          'fit(X, y) to train, predict(X) to generate predictions, and inherit from BaseEstimator + ClassifierMixin — scikit-learn checks for these to use the model in its pipeline tools',
          'Only predict(X)',
          '__len__() and __getitem__()'
        ],
        correctIndex: 1,
        explanation: 'scikit-learn\'s cross-validation and grid search call fit() and predict() on your model. Inheriting from BaseEstimator gives you get_params()/set_params() for GridSearchCV. ClassifierMixin adds score() automatically. This interface contract is what makes custom models plug into the full sklearn ecosystem.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'class ModelTracker:\n    experiment_count = 0  # class variable\n    def __init__(self, name):\n        self.name = name\n        ModelTracker.experiment_count += 1\n\nt1 = ModelTracker("RF experiment")\nt2 = ModelTracker("XGB experiment")\nprint(ModelTracker.experiment_count)',
        options: [
          '0',
          '1',
          '2 — class variables are shared across all instances; each __init__ increments the shared counter',
          'Error — class variables cannot be modified in __init__'
        ],
        correctIndex: 2,
        explanation: 'experiment_count is a class variable shared across ALL instances. Each ModelTracker() call triggers __init__ which increments ModelTracker.experiment_count. After creating t1 and t2, the shared counter is 2. This pattern tracks total experiments across an entire ML session.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Custom ML Pipeline Class',
      goal: 'Build a complete object-oriented ML pipeline class that chains preprocessing and model training with a scikit-learn compatible interface.',
      steps: [
        'Create class MLPipeline with __init__(self, model_type="rf", **model_params) that accepts model configuration',
        'Add fit(self, X, y) method that: scales features using StandardScaler, trains the chosen model, stores training metrics, and returns self',
        'Add predict(self, X) method that applies the same scaling then returns predictions',
        'Add evaluate(self, X_test, y_test) method returning a dict with accuracy, f1, and a confusion matrix',
        'Add __repr__ showing model type, training samples count, and accuracy if fitted',
        'Demonstrate: create two MLPipeline instances with different models, fit both, compare evaluate() results',
      ],
      expectedOutput: 'Pipeline 1: MLPipeline(model=rf, samples=120, accuracy=0.967)\nPipeline 2: MLPipeline(model=xgb, samples=120, accuracy=0.933)\n\nEvaluation RF:\n  accuracy: 0.967\n  f1: 0.966\n  confusion_matrix: [[13, 0], [1, 16]]\n\nEvaluation XGB:\n  accuracy: 0.933\n  f1: 0.932\n\nBest model: rf with 96.7% accuracy\nBoth pipelines fitted and evaluated ✓',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'aep_l2_file_exception',
    topicTitle: 'File Handling & Exception Handling',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 185,
    emoji: '📁',
    intro: 'AI engineers constantly read data files, save model weights, and write results. When things go wrong — corrupted files, missing data, API timeouts — exception handling prevents catastrophic pipeline failures. This course makes your AI code robust for production.',
    concepts: [
      ConceptLesson(
        title: 'File I/O for AI — Reading and Writing Data',
        definition: 'AI pipelines read CSV datasets, JSON configs, model weights, and image files — and write results, logs, and trained models. Python\'s file handling with context managers ensures files are always properly closed even when errors occur.',
        analogy: 'File handling with context managers is like borrowing a library book — you check it out (open), use it (read/write), and return it (close). The "with" statement is like an automatic return system that returns the book even if you forget or something goes wrong.',
        example: '# File handling patterns in AI:\n\n# 1. Read CSV data (prefer pandas, but know the basics)\nwith open("dataset.csv", "r", encoding="utf-8") as f:\n    header = f.readline().strip().split(",")\n    data = [line.strip().split(",") for line in f]\n\n# 2. Save model results as JSON\nimport json\nresults = {"accuracy": 0.94, "f1": 0.93, "model": "rf"}\nwith open("results.json", "w") as f:\n    json.dump(results, f, indent=2)\n\n# 3. Load config from JSON\nwith open("config.json", "r") as f:\n    config = json.load(f)\n\n# 4. Save model with pickle\nimport pickle\nwith open("model.pkl", "wb") as f:  # binary write\n    pickle.dump(trained_model, f)\n\n# 5. Load saved model\nwith open("model.pkl", "rb") as f:  # binary read\n    model = pickle.load(f)\n\n# 6. Append to experiment log\nwith open("experiments.log", "a") as f:\n    f.write(f"Epoch 42: loss=0.234, acc=0.912\\n")',
        keyTakeaway: 'Always use "with open()" — never just open(). If your code crashes between open() and close(), the file remains locked or partially written. Context managers guarantee cleanup even when exceptions occur.',
      ),
      ConceptLesson(
        title: 'Exception Handling — Making AI Code Robust',
        definition: 'try/except blocks catch errors and handle them gracefully instead of crashing. In AI pipelines, they handle missing files, corrupted data, API failures, and GPU out-of-memory errors without terminating the entire training run.',
        analogy: 'Exception handling in AI is like a hospital\'s backup generator — when the main power fails (exception), the backup kicks in automatically (except block) and critical systems keep running. The hospital does not shut down because of a power outage.',
        example: '# Exception handling in AI workflows:\n\n# 1. Handle missing data files gracefully:\ndef load_dataset(file_path):\n    try:\n        df = pd.read_csv(file_path)\n        print(f"Loaded {len(df)} samples from {file_path}")\n        return df\n    except FileNotFoundError:\n        print(f"ERROR: File not found: {file_path}")\n        return None\n    except pd.errors.EmptyDataError:\n        print(f"ERROR: File is empty: {file_path}")\n        return None\n    except Exception as e:\n        print(f"Unexpected error loading data: {e}")\n        raise  # re-raise unexpected errors\n\n# 2. Handle API failures with retry:\ndef call_llm_with_retry(prompt, max_retries=3):\n    for attempt in range(max_retries):\n        try:\n            response = openai_client.chat(prompt)\n            return response\n        except RateLimitError:\n            wait = 2 ** attempt  # exponential backoff\n            print(f"Rate limited. Waiting {wait}s...")\n            time.sleep(wait)\n        except APIError as e:\n            print(f"API error: {e}")\n            raise\n    raise Exception("Max retries exceeded")',
        keyTakeaway: 'Catch SPECIFIC exceptions (FileNotFoundError, ValueError) before catching the generic Exception. Catching Exception too broadly hides bugs — a typo causing a NameError would be silently swallowed. Be specific, then fall through to a generic handler as a last resort.',
      ),
      ConceptLesson(
        title: 'Custom Exceptions for AI Systems',
        definition: 'Custom exception classes make AI pipeline errors descriptive and actionable. Instead of a generic ValueError, raise DataQualityError or ModelNotFittedError with context about what went wrong and how to fix it.',
        analogy: 'Custom exceptions are like specific error codes in a hospital monitoring system — "CODE BLUE" tells staff exactly what is wrong and what to do. A generic alarm that just beeps tells them nothing actionable.',
        example: '# Custom exceptions for an AI pipeline:\n\nclass AIEngineError(Exception):\n    """Base exception for AI pipeline errors."""\n    pass\n\nclass DataQualityError(AIEngineError):\n    """Raised when data fails quality validation."""\n    def __init__(self, message, n_invalid, column=None):\n        self.n_invalid = n_invalid\n        self.column = column\n        super().__init__(\n            f"Data quality error in column {column}: "\n            f"{message} ({n_invalid} invalid samples)"\n        )\n\nclass ModelNotFittedError(AIEngineError):\n    """Raised when predict() called before fit()."""\n    pass\n\n# Using custom exceptions:\nclass SafeMLPipeline:\n    def predict(self, X):\n        if self._model is None:\n            raise ModelNotFittedError(\n                "Call fit() before predict()"\n            )\n        return self._model.predict(X)\n\n    def validate_data(self, df):\n        null_count = df.isnull().sum().sum()\n        if null_count > len(df) * 0.2:\n            raise DataQualityError(\n                "Too many missing values",\n                n_invalid=null_count\n            )',
        keyTakeaway: 'Custom exceptions in production AI systems let monitoring tools catch specific error types, alert on them differently, and help engineers diagnose issues from logs. ModelNotFittedError is infinitely more useful than "AttributeError: \'NoneType\' object has no attribute \'predict\'".',
      ),
      ConceptLesson(
        title: 'Working with Paths — os and pathlib',
        definition: 'AI projects use file paths constantly — dataset paths, model checkpoint paths, log directories. Python\'s pathlib module provides clean, OS-independent path handling that works identically on Windows, Linux, and macOS.',
        analogy: 'pathlib is like a GPS for your file system — instead of hardcoding street addresses (string paths with slashes), you describe the route from a known landmark (project root) and the GPS calculates the correct path for whatever city (operating system) you are in.',
        example: '# pathlib in AI projects — the modern approach:\nfrom pathlib import Path\n\n# Define project structure:\nPROJECT_ROOT = Path(__file__).parent.parent\nDATA_DIR = PROJECT_ROOT / "data"\nMODELS_DIR = PROJECT_ROOT / "models"\nLOGS_DIR = PROJECT_ROOT / "logs"\n\n# Create directories if they do not exist:\nMODELS_DIR.mkdir(parents=True, exist_ok=True)\nLOGS_DIR.mkdir(parents=True, exist_ok=True)\n\n# List all CSV files in a directory:\ncsv_files = list(DATA_DIR.glob("*.csv"))\nprint(f"Found {len(csv_files)} datasets")\n\n# Build safe file paths:\nmodel_path = MODELS_DIR / "crop_classifier_v1.pkl"\nif model_path.exists():\n    print(f"Loading model from {model_path}")\n    model = load_model(model_path)\nelse:\n    print("No saved model found, training from scratch")\n\n# Get file info:\nfor csv in csv_files:\n    size_mb = csv.stat().st_size / (1024 * 1024)\n    print(f"{csv.name}: {size_mb:.1f} MB")',
        keyTakeaway: 'Use pathlib.Path everywhere in AI projects instead of string concatenation ("data" + "/" + "file.csv"). Path handles OS differences automatically, provides .exists(), .mkdir(), .glob(), and makes paths readable and composable with the / operator.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why should you use "with open(file) as f:" instead of "f = open(file)"?',
        options: [
          '"with" makes file reading faster',
          'Context managers guarantee the file is closed even if an exception occurs mid-read — preventing file lock corruption and resource leaks in long-running AI processes',
          '"with" automatically converts the file to pandas DataFrame',
          'There is no difference between the two approaches'
        ],
        correctIndex: 1,
        explanation: 'Without "with", if an exception occurs between open() and close(), the file stays locked. In long-running ML training, this causes resource leaks that accumulate until the OS runs out of file handles and crashes the process.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Your AI pipeline tries to load a model file that does not exist. Which exception should you catch?',
        options: [
          'Exception — catches everything',
          'FileNotFoundError — specific to missing files, gives a clear error message and lets you handle the missing file case (train from scratch, alert user)',
          'ValueError — for wrong value types',
          'RuntimeError — for runtime issues'
        ],
        correctIndex: 1,
        explanation: 'FileNotFoundError is the specific exception for missing files. Catching it specifically lets you handle "no saved model" gracefully (train from scratch) while letting other unexpected errors (disk full, permissions) propagate as real errors.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'How do you list all .csv files in a "datasets/" directory using pathlib?',
        options: [
          'import os; os.listdir("datasets/")',
          'from pathlib import Path; files = list(Path("datasets/").glob("*.csv"))',
          'open("datasets/*.csv")',
          'pd.read_csv("datasets/*.csv")'
        ],
        correctIndex: 1,
        explanation: 'Path.glob("*.csv") returns a generator of all CSV files in the directory. list() converts it to a list. This works identically on Windows and Linux unlike string-based os.listdir() which requires manual filtering.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Your training script processes 10,000 CSV files. Some files are corrupted. Without exception handling, one bad file crashes the entire job. What is the correct approach?',
        options: [
          'Delete all corrupted files before running',
          'Wrap file loading in try/except, log the error with the filename, skip to the next file with continue — process all valid files and generate a report of skipped files at the end',
          'Use a separate script to validate files first',
          'Catch Exception and silently ignore all errors'
        ],
        correctIndex: 1,
        explanation: 'The professional approach: catch the specific error (pd.errors.ParserError, UnicodeDecodeError), log which file failed and why, continue to the next file. After processing, report how many files succeeded vs failed. Never silently swallow errors.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You hardcode model_path = "C:\\\\Users\\\\rahul\\\\project\\\\model.pkl" in your script. A teammate on Linux tries to run it and it fails. How do you fix this permanently?',
        options: [
          'Tell teammates to use Windows',
          'Use pathlib: model_path = Path(__file__).parent / "models" / "model.pkl" — this builds the path relative to the script location and works on Windows, Linux, and macOS automatically',
          'Use forward slashes instead of backslashes',
          'Add an if/else for Windows vs Linux'
        ],
        correctIndex: 1,
        explanation: 'Absolute hardcoded paths are a collaboration anti-pattern. pathlib builds relative paths from the script\'s own location using Path(__file__).parent. The / operator works on all OSes. This is the standard pattern in every professional Python project.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Robust AI Data Loader',
      goal: 'Build a production-grade data loading system with exception handling, custom errors, and pathlib-based file management.',
      steps: [
        'Define custom exceptions: DataLoadError, DataValidationError, and InsufficientDataError with descriptive messages',
        'Create a RobustDataLoader class using pathlib to manage a "datasets/" directory structure',
        'Implement load_single_file(path) that handles FileNotFoundError, empty files, encoding errors, and schema mismatches — logging each issue',
        'Implement load_all_files(directory) that loads all CSVs, skips corrupted ones with logging, and raises InsufficientDataError if less than 3 files load successfully',
        'Implement validate_schema(df, required_columns) that raises DataValidationError with the missing column names if schema does not match',
        'Write a summary report showing files loaded, files skipped with reasons, total samples, and data quality score',
      ],
      expectedOutput: 'RobustDataLoader initialised at: datasets/\n\nLoading files...\n  crops_train.csv: 1200 samples ✓\n  crops_test.csv: 300 samples ✓\n  corrupted.csv: SKIPPED (DataLoadError: encoding error)\n  empty.csv: SKIPPED (DataLoadError: empty file)\n  weather.csv: SKIPPED (DataValidationError: missing columns [disease_label])\n\nSummary:\n  Files loaded: 2/5\n  Total samples: 1500\n  Data quality score: 94.2%\n  Custom exceptions used: 3 distinct error types ✓',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'aep_l2_numpy',
    topicTitle: 'NumPy Fundamentals',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 35,
    totalXp: 220,
    emoji: '🔢',
    intro: 'NumPy is the foundation of every AI library. PyTorch tensors, TensorFlow tensors, pandas DataFrames, and scikit-learn arrays are all built on NumPy. You cannot truly understand ML code without understanding NumPy arrays, broadcasting, and vectorised operations. This course gives you production-level NumPy fluency.',
    concepts: [
      ConceptLesson(
        title: 'NumPy Arrays — The Foundation of ML Data',
        definition: 'A NumPy ndarray is a fast, multi-dimensional array of homogeneous data stored in contiguous memory. It is the universal data container for ML — feature matrices, label vectors, model weights, and image tensors are all ndarrays.',
        analogy: 'A NumPy array is like a super-powered spreadsheet grid — but stored in memory as a single block of numbers (not Python objects), making mathematical operations 100x faster than Python lists. The entire column can be multiplied at once, not one cell at a time.',
        example: '# NumPy arrays in ML:\nimport numpy as np\n\n# Feature matrix — 5 samples, 3 features:\nX = np.array([\n    [25, 50000, 720],  # age, income, credit_score\n    [32, 75000, 680],\n    [45, 120000, 750],\n    [28, 45000, 640],\n    [38, 90000, 710]\n])\nprint(X.shape)    # (5, 3)\nprint(X.dtype)    # int64\nprint(X.ndim)     # 2 (2-dimensional)\n\n# Label vector:\ny = np.array([0, 1, 1, 0, 1])\nprint(y.shape)    # (5,) — 1-dimensional\n\n# Create arrays:\nzeros = np.zeros((100, 10))     # 100 samples, 10 features\nones = np.ones((32, 3, 224, 224)) # batch of 32 RGB images\nrandom = np.random.randn(1000, 20) # random data\nrange_arr = np.arange(0, 1, 0.1)   # [0.0, 0.1, ..., 0.9]',
        keyTakeaway: 'Always check .shape, .dtype, and .ndim when debugging ML code. Most dimension errors ("expected 2D input but got 1D") come from shape mismatches that are immediately visible with these three attributes.',
      ),
      ConceptLesson(
        title: 'Array Indexing and Slicing for ML',
        definition: 'NumPy indexing lets you select specific samples, features, and subsets of your data. Boolean indexing filters data by condition. Fancy indexing selects arbitrary rows or columns by index list.',
        analogy: 'NumPy indexing is like a precision laser cutter — you specify exactly which rows (samples), which columns (features), or which conditions (filters) you want, and NumPy extracts just those elements without copying the rest of the array.',
        example: '# Indexing in ML workflows:\n\n# Select specific samples:\nfirst_sample = X[0]           # shape: (3,)\nlast_sample = X[-1]           # last sample\nfirst_three = X[:3]           # rows 0, 1, 2\n\n# Select specific features:\nage_column = X[:, 0]          # all rows, column 0\nincome_credit = X[:, 1:]      # columns 1 and 2\n\n# Boolean indexing — filter samples:\nhigh_credit = X[X[:, 2] > 700]  # rows where credit > 700\n# Returns [[25,50000,720],[45,120000,750],[38,90000,710]]\n\n# Label filtering:\npositive_samples = X[y == 1]  # samples where label is 1\n\n# Fancy indexing:\nselected_rows = X[[0, 2, 4]]  # rows 0, 2, and 4 specifically\n\n# Train/test split manually:\nX_train = X[:4]   # first 4 samples\nX_test = X[4:]    # remaining samples\ny_train = y[:4]\ny_test = y[4:]',
        keyTakeaway: 'Boolean indexing (X[X[:, 2] > 700]) is one of the most powerful NumPy patterns — it filters rows based on a column condition in one line. This is how you select high-confidence predictions, filter outliers, and create balanced datasets.',
      ),
      ConceptLesson(
        title: 'Vectorised Operations and Broadcasting',
        definition: 'Vectorised operations apply mathematical functions to entire arrays at once — 100-1000x faster than Python loops. Broadcasting automatically expands array shapes for element-wise operations between differently-shaped arrays.',
        analogy: 'Vectorised operations are like a factory press that stamps 1000 parts simultaneously instead of stamping one at a time. Broadcasting is like adding the same overhead cost to every item in a list — you do not need to expand the cost into an array of 1000 copies first.',
        example: '# Vectorised operations — no loops needed:\nX = np.random.randn(10000, 20)  # 10000 samples, 20 features\n\n# Manual min-max normalisation (vectorised):\nX_min = X.min(axis=0)   # min of each feature (shape: 20,)\nX_max = X.max(axis=0)   # max of each feature (shape: 20,)\nX_scaled = (X - X_min) / (X_max - X_min)  # broadcasting!\n# X is (10000,20), X_min is (20,) — broadcasting auto-expands!\n\n# Standard scaling (z-score):\nmean = X.mean(axis=0)   # mean per feature\nstd = X.std(axis=0)     # std per feature\nX_standardized = (X - mean) / std\n\n# Performance comparison:\nimport time\n# Loop version (SLOW):\nstart = time.time()\nresult_loop = np.zeros_like(X)\nfor i in range(len(X)):\n    result_loop[i] = (X[i] - mean) / std\nprint(f"Loop: {time.time()-start:.3f}s")  # ~2.1s\n\n# Vectorised (FAST):\nstart = time.time()\nresult_vec = (X - mean) / std\nprint(f"Vectorised: {time.time()-start:.3f}s")  # ~0.02s',
        keyTakeaway: 'If you find yourself writing a for loop in NumPy, stop and think: "can I vectorise this?" The answer is almost always yes. Vectorised NumPy is 100x faster than Python loops and is what makes ML training on large datasets feasible.',
      ),
      ConceptLesson(
        title: 'Essential NumPy for ML — Statistics and Linear Algebra',
        definition: 'NumPy provides the statistical (mean, std, percentile) and linear algebra (dot product, matrix multiply, transpose) operations that underlie every ML algorithm. Understanding these operations helps you read ML papers and implement algorithms from scratch.',
        analogy: 'NumPy\'s statistical and linear algebra functions are the mathematical vocabulary of ML. Without them, reading an ML paper is like reading chemistry without knowing element symbols. With them, equations in papers translate directly to NumPy code.',
        example: '# Statistics for ML:\ny = np.array([1, 0, 1, 1, 0, 1, 0, 0, 1, 1])\n\nprint(f"Class balance: {y.mean():.1%} positive")\nprint(f"Std deviation: {y.std():.3f}")\nprint(f"Counts: {np.bincount(y)}")  # [4, 6]\n\n# Statistical features from data:\nX = np.random.randn(1000, 10)\nprint(f"Mean per feature: {X.mean(axis=0).round(2)}")\nprint(f"Std per feature: {X.std(axis=0).round(2)}")\nprint(f"Correlation: {np.corrcoef(X.T).shape}")  # (10,10)\n\n# Linear algebra — the math of ML:\nA = np.array([[1, 2], [3, 4]])\nB = np.array([[5, 6], [7, 8]])\n\n# Matrix multiplication (dot product):\nC = A @ B           # or np.dot(A, B)\nprint(C)            # [[19,22],[43,50]]\n\n# Transpose:\nX_T = X.T           # shape: (10, 1000)\n\n# Manual linear regression prediction:\n# y_pred = X @ weights + bias\nweights = np.random.randn(10)\nbias = 0.0\ny_pred = X @ weights + bias  # shape: (1000,)',
        keyTakeaway: 'The @ operator for matrix multiplication is the most important NumPy operator in ML. Every neural network forward pass, linear regression prediction, and attention computation is fundamentally a series of matrix multiplications. Learn to read @ as "matrix multiply."',
      ),
      ConceptLesson(
        title: 'Reshaping and Stacking Arrays',
        definition: 'reshape() changes array dimensions without copying data. stack(), concatenate(), and vstack()/hstack() combine arrays. These operations are essential for preparing data for deep learning models that expect specific input shapes.',
        analogy: 'Reshaping a NumPy array is like rearranging items from a 10x10 grid into a single row of 100 — the same 100 items, just organised differently. No new items, no removal — just a different view of the same underlying data.',
        example: '# Reshaping in deep learning:\nimport numpy as np\n\n# Flatten images for a fully-connected layer:\nbatch_images = np.random.randn(32, 3, 224, 224)\n# Shape: (batch=32, channels=3, height=224, width=224)\n\nflat = batch_images.reshape(32, -1)  # -1 auto-calculates\nprint(flat.shape)  # (32, 150528) = 32 * 3 * 224 * 224\n\n# Add batch dimension for single sample:\nsingle_image = np.random.randn(3, 224, 224)\nbatch_of_one = single_image.reshape(1, *single_image.shape)\nprint(batch_of_one.shape)  # (1, 3, 224, 224)\n# Or: single_image[np.newaxis]  # same result\n\n# Stacking multiple arrays:\nbatch1 = np.random.randn(32, 10)\nbatch2 = np.random.randn(32, 10)\ncombined = np.vstack([batch1, batch2])  # (64, 10)\n\n# Concatenate predictions from multiple batches:\npred_list = [model_predict(batch) for batch in all_batches]\nall_predictions = np.concatenate(pred_list, axis=0)',
        keyTakeaway: 'The most common reshape operations: flatten for FC layers (reshape(batch, -1)), add batch dim for single inference (reshape(1, ...)). The -1 in reshape means "calculate this dimension automatically from the total number of elements."',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'X has shape (1000, 20) and mean has shape (20,). What does (X - mean) produce?',
        options: [
          'An error — shapes are incompatible',
          'A (1000, 20) array — NumPy broadcasting automatically subtracts the mean of each feature from all 1000 samples of that feature',
          'A (20,) array',
          'A scalar value'
        ],
        correctIndex: 1,
        explanation: 'Broadcasting: NumPy expands the (20,) mean to (1000, 20) by repeating it 1000 times, then subtracts element-wise. This is feature-wise mean subtraction — the first step of standard scaling. Broadcasting makes this a single line instead of a loop.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does X[y == 1] return when X is a feature matrix and y is a label array?',
        options: [
          'A single value where y equals 1',
          'All rows of X where the corresponding label in y is 1 — boolean indexing selects positive class samples',
          'The indices where y equals 1',
          'A boolean array'
        ],
        correctIndex: 1,
        explanation: 'y == 1 creates a boolean array. X[boolean_array] selects rows where True. This returns all feature vectors of positive class samples — essential for class-balanced sampling, oversampling, and class-specific analysis.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A single image has shape (3, 224, 224). A model expects batch input of shape (batch_size, 3, 224, 224). How do you add the batch dimension?',
        options: [
          'image.reshape(1, 224, 224)',
          'image[np.newaxis] or image.reshape(1, 3, 224, 224) — adds a new first dimension of size 1, creating shape (1, 3, 224, 224)',
          'np.expand(image)',
          'image.batch(1)'
        ],
        correctIndex: 1,
        explanation: 'image[np.newaxis] inserts a new axis at position 0, changing (3,224,224) to (1,3,224,224). This "fake batch" lets you pass a single image through a model that expects batches. Equivalent: image.reshape(1, *image.shape).',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'X = np.array([[1,2,3],[4,5,6],[7,8,9]])\nWhat does X[X > 4] return?',
        options: [
          '[[5,6],[7,8,9]] — a 2D subarray',
          '[5, 6, 7, 8, 9] — a 1D array of all elements greater than 4',
          'The rows where any element > 4',
          'Error — boolean indexing only works on 1D arrays'
        ],
        correctIndex: 1,
        explanation: 'X > 4 creates a boolean array of same shape. X[boolean_array] returns ALL elements where True as a flat 1D array: [5,6,7,8,9]. This flattening is standard NumPy behaviour for multi-dimensional boolean indexing.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You have predictions of shape (1000,) and need to convert them to shape (1000, 1) for a model that expects column vectors. What is the correct NumPy operation?',
        options: [
          'predictions.reshape(1000)',
          'predictions.reshape(-1, 1) or predictions[:, np.newaxis] — adds a second dimension of size 1',
          'predictions.expand_dims(1)',
          'np.array([predictions])'
        ],
        correctIndex: 1,
        explanation: 'reshape(-1, 1) uses -1 to auto-calculate the first dimension (1000) and explicitly sets the second to 1, giving (1000, 1). predictions[:, np.newaxis] inserts a new axis at position 1. Both produce (1000, 1).',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'NumPy ML Operations Library',
      goal: 'Implement core ML mathematical operations from scratch using only NumPy — no scikit-learn allowed.',
      steps: [
        'Implement min_max_scale(X) that scales each feature to [0,1] range using vectorised NumPy operations',
        'Implement standard_scale(X) that standardises each feature to mean=0, std=1',
        'Implement train_test_split(X, y, test_size=0.2, random_state=42) using NumPy random shuffling',
        'Implement euclidean_distance(a, b) and cosine_similarity(a, b) using NumPy dot products',
        'Implement accuracy(y_true, y_pred), precision(y_true, y_pred), and recall(y_true, y_pred) using NumPy boolean operations',
        'Test all functions on the Iris dataset loaded via sklearn.datasets and verify results match scikit-learn equivalents',
      ],
      expectedOutput: 'NumPy ML Operations Library Test:\n\nmin_max_scale: range [0.000, 1.000] ✓ matches sklearn\nstandard_scale: mean=0.000, std=1.000 ✓ matches sklearn\ntrain_test_split: train=120, test=30 ✓\n\nMetrics on Iris (using dummy classifier):\n  accuracy: 0.967 ✓ matches sklearn\n  precision: 0.968 ✓ matches sklearn\n  recall: 0.967 ✓ matches sklearn\n\nAll NumPy implementations verified ✓',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'aep_l2_pandas',
    topicTitle: 'Pandas for Data Analysis',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 35,
    totalXp: 225,
    emoji: '🐼',
    intro: 'pandas is the most used Python library in data science. Every CSV dataset, every feature engineering step, every data quality check goes through pandas. If NumPy is the engine of ML, pandas is the cockpit where you actually work with your data. This course makes you production-proficient in pandas.',
    concepts: [
      ConceptLesson(
        title: 'DataFrames and Series — pandas Fundamentals',
        definition: 'A pandas DataFrame is a 2D labelled table (rows = samples, columns = features). A Series is a 1D labelled array (one feature or one label). Together they provide the interface for all data manipulation before ML training.',
        analogy: 'A DataFrame is like a spreadsheet with superpowers — each column has a name (not just "Column A"), each row has an index, and you can filter, transform, aggregate, and merge in a single line of readable code. It is the most productive data manipulation tool in Python.',
        example: '# DataFrame fundamentals in ML:\nimport pandas as pd\n\ndf = pd.read_csv("loan_applications.csv")\n\n# First look at any new dataset:\nprint(df.shape)       # (10000, 15) — rows, columns\nprint(df.dtypes)      # data type of each column\nprint(df.head())      # first 5 rows\nprint(df.info())      # non-null counts, dtypes\nprint(df.describe())  # statistics for numeric columns\n\n# Access columns:\nages = df["age"]               # Series\nfeatures = df[["age", "income", "score"]]  # DataFrame\n\n# Access rows:\nfirst_row = df.iloc[0]         # by position\nspecific_row = df.loc[42]      # by index label\n\n# Add a new feature column:\ndf["income_per_age"] = df["income"] / df["age"]\ndf["is_high_income"] = (df["income"] > 100000).astype(int)',
        keyTakeaway: 'Always call df.info() and df.describe() on any new dataset before ANY other analysis. info() shows missing values and data types (the two most common data problems). describe() shows ranges and distributions that immediately reveal outliers.',
      ),
      ConceptLesson(
        title: 'Data Cleaning — The Real Work of ML',
        definition: 'Data cleaning handles missing values, incorrect types, outliers, and duplicates. In real ML projects, data cleaning takes 60-80% of the total project time. pandas provides the tools to do it efficiently and reproducibly.',
        analogy: 'Data cleaning is like editing a raw video before publishing — the raw footage has gaps (missing values), wrong takes (incorrect data), background noise (outliers), and duplicates. You must clean all of these before the video (dataset) is ready for the audience (ML model).',
        example: '# Complete data cleaning workflow:\nimport pandas as pd\nimport numpy as np\n\ndf = pd.read_csv("raw_data.csv")\n\n# 1. Handle missing values:\nprint(df.isnull().sum())           # count per column\nprint(df.isnull().mean() * 100)   # percentage missing\n\ndf["income"].fillna(df["income"].median(), inplace=True)\ndf["category"].fillna("unknown", inplace=True)\ndf.dropna(subset=["label"], inplace=True)  # must have label\n\n# 2. Fix data types:\ndf["age"] = pd.to_numeric(df["age"], errors="coerce")\ndf["date"] = pd.to_datetime(df["date"])\ndf["category"] = df["category"].astype("category")\n\n# 3. Handle outliers:\nQ1 = df["income"].quantile(0.25)\nQ3 = df["income"].quantile(0.75)\nIQR = Q3 - Q1\ndf = df[(df["income"] >= Q1 - 1.5*IQR) &\n        (df["income"] <= Q3 + 1.5*IQR)]\n\n# 4. Remove duplicates:\ndf.drop_duplicates(inplace=True)\nprint(f"Clean dataset: {df.shape[0]} samples")',
        keyTakeaway: 'The three-step rule for missing values: (1) if < 5% missing → drop those rows, (2) if 5-30% missing → impute with median/mode/model, (3) if > 30% missing → consider dropping the column entirely. Never impute labels — always drop rows with missing labels.',
      ),
      ConceptLesson(
        title: 'Feature Engineering with pandas',
        definition: 'Feature engineering creates new informative features from existing ones — the most impactful step in improving ML model performance. pandas makes it fast: date features, interaction terms, aggregations, and encoding all in readable one-liners.',
        analogy: 'Feature engineering is like giving the model extra context — instead of just "transaction time: 23:45:00", you give it "is_late_night: True", "hour: 23", "is_weekend: False". The model cannot extract these on its own; you must create them explicitly.',
        example: '# Feature engineering for a loan dataset:\n\n# Date features:\ndf["loan_date"] = pd.to_datetime(df["loan_date"])\ndf["loan_year"] = df["loan_date"].dt.year\ndf["loan_month"] = df["loan_date"].dt.month\ndf["loan_dayofweek"] = df["loan_date"].dt.dayofweek\ndf["is_weekend_application"] = (df["loan_dayofweek"] >= 5).astype(int)\n\n# Ratio features:\ndf["debt_to_income"] = df["debt"] / (df["income"] + 1)\ndf["income_per_dependent"] = df["income"] / (df["dependents"] + 1)\n\n# Binning (discretisation):\ndf["age_group"] = pd.cut(\n    df["age"],\n    bins=[0, 25, 35, 50, 65, 100],\n    labels=["young", "early_career", "mid_career", "senior", "retirement"]\n)\n\n# Encoding categorical features:\ndf = pd.get_dummies(df, columns=["category", "region"],\n                    drop_first=True, dtype=int)\n\n# Aggregate features (group statistics):\nregion_avg = df.groupby("region")["income"].mean()\ndf["region_avg_income"] = df["region"].map(region_avg)',
        keyTakeaway: 'pd.cut() for binning continuous features, pd.get_dummies() for one-hot encoding, and groupby().mean() for aggregate features are the three most used feature engineering operations. Master these and you can engineer features for 80% of tabular ML problems.',
      ),
      ConceptLesson(
        title: 'GroupBy and Aggregation for ML Analysis',
        definition: 'groupby() splits data into groups, applies aggregation functions (mean, sum, count), and combines results. It powers class-wise statistics, cohort analysis, and feature aggregation that reveal patterns invisible in individual rows.',
        analogy: 'GroupBy is like an accountant\'s pivot report — instead of showing every transaction, it summarises "how much each department spent this quarter." In ML, it answers "what is the default rate by credit score bucket?" or "what is average purchase value by customer segment?"',
        example: '# GroupBy for ML analysis:\n\n# Class-wise statistics (essential for classification):\nclass_stats = df.groupby("label").agg({\n    "age": ["mean", "std"],\n    "income": ["mean", "median"],\n    "credit_score": "mean"\n})\nprint(class_stats)\n\n# Default rate by credit score bucket:\ndf["credit_bucket"] = pd.cut(df["credit_score"],\n                              bins=[0, 600, 700, 800, 900])\ndefault_rates = df.groupby("credit_bucket")["defaulted"].mean()\nprint("Default rates by credit score:") \nprint(default_rates)\n\n# Count samples per class (class balance check):\nprint(df["label"].value_counts())\nprint(df["label"].value_counts(normalize=True))  # %\n\n# Correlation with target:\nnumeric_cols = df.select_dtypes(include=np.number).columns\ncorrelations = df[numeric_cols].corr()["label"].sort_values()\nprint("Feature correlations with target:")\nprint(correlations)',
        keyTakeaway: 'Always run df.groupby("label").mean() before modelling — it shows which features differ most between classes. High difference = potentially strong predictive feature. Near-zero difference = likely weak feature. This guides feature selection before training.',
      ),
      ConceptLesson(
        title: 'pandas for ML Pipeline Integration',
        definition: 'pandas integrates with scikit-learn through .values and sklearn pipelines. Understanding how to convert DataFrames to NumPy arrays and back, and how to use sklearn\'s ColumnTransformer with pandas, completes the pandas-to-ML workflow.',
        analogy: 'The pandas-to-sklearn handoff is like a translator at a UN meeting — the diplomat (pandas) has prepared the data beautifully in French (DataFrame), but the ML algorithm (sklearn) only speaks English (NumPy array). You need the translator (.values, .to_numpy()) to make them work together.',
        example: '# Complete pandas → sklearn workflow:\nimport pandas as pd\nimport numpy as np\nfrom sklearn.model_selection import train_test_split\nfrom sklearn.preprocessing import StandardScaler\nfrom sklearn.ensemble import RandomForestClassifier\nfrom sklearn.pipeline import Pipeline\nfrom sklearn.compose import ColumnTransformer\nfrom sklearn.preprocessing import OneHotEncoder\n\ndf = pd.read_csv("loan_data.csv")\n\n# Define feature types:\nnumeric_features = ["age", "income", "credit_score"]\ncategorical_features = ["employment_type", "region"]\ntarget = "defaulted"\n\n# Prepare X and y:\nX = df[numeric_features + categorical_features]\ny = df[target]\n\n# Train/test split:\nX_train, X_test, y_train, y_test = train_test_split(\n    X, y, test_size=0.2, random_state=42, stratify=y\n)\n\n# sklearn Pipeline handles all transforms:\npreprocessor = ColumnTransformer([\n    ("num", StandardScaler(), numeric_features),\n    ("cat", OneHotEncoder(drop="first"), categorical_features)\n])\npipeline = Pipeline([\n    ("preprocessor", preprocessor),\n    ("model", RandomForestClassifier())\n])\n\npipeline.fit(X_train, y_train)\nprint(f"Accuracy: {pipeline.score(X_test, y_test):.2%}")',
        keyTakeaway: 'sklearn\'s Pipeline + ColumnTransformer is the production pattern for handling mixed numeric/categorical data. It applies the right preprocessing to each column type automatically, prevents data leakage (fit only on train), and makes deployment trivial (one object to save).',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'df["income"] has 300 missing values out of 10,000 rows (3%). What is the correct handling strategy?',
        options: [
          'Drop the entire "income" column',
          'Fill with median: df["income"].fillna(df["income"].median()) — 3% missing is small enough to impute; median is robust to outliers unlike mean',
          'Fill with 0 — it is a safe default for income',
          'Drop all 10,000 rows and collect more data'
        ],
        correctIndex: 1,
        explanation: 'At 3% missing, dropping rows wastes valuable data. Filling with median is the standard practice for numeric features — median is robust to outliers (a common issue with income data). Never fill income with 0 — it creates a false data point that corrupts the model.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does pd.get_dummies(df, columns=["city"]) do to a column with values ["Mumbai", "Delhi", "Chennai"]?',
        options: [
          'Replaces city names with numbers 0, 1, 2',
          'Creates three new binary columns: city_Mumbai, city_Delhi, city_Chennai — each is 1 for matching city, 0 otherwise (one-hot encoding)',
          'Groups cities by region automatically',
          'Removes the city column from the DataFrame'
        ],
        correctIndex: 1,
        explanation: 'pd.get_dummies() creates one binary column per unique category value. "Mumbai" gets city_Mumbai=1, city_Delhi=0, city_Chennai=0. This converts categorical text to numeric format that ML algorithms can process. Use drop_first=True to avoid the dummy variable trap.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why use stratify=y in train_test_split when splitting a dataset with 90% negative / 10% positive labels?',
        options: [
          'It makes splitting faster',
          'Stratify ensures the 90/10 class ratio is preserved in BOTH train and test sets — without it, random chance might put all positive samples in train or test, making evaluation unreliable',
          'It shuffles the data before splitting',
          'It is only needed for multi-class problems'
        ],
        correctIndex: 1,
        explanation: 'Without stratify, random splitting of imbalanced data can create a test set with very few positive samples — making evaluation unreliable. stratify=y ensures both sets have the same class distribution as the original, giving meaningful accuracy and recall metrics.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'df has columns: age (some "N/A" strings), income (some negatives), city (categorical), label. Write the data cleaning order.',
        options: [
          'Encode city → fill age → remove negatives → split',
          'Convert age strings to numeric (pd.to_numeric with errors="coerce") → fill NaN with median → remove rows where income < 0 → encode city with get_dummies → then split',
          'Split first → then clean each set separately',
          'Remove all rows with any issues first'
        ],
        correctIndex: 1,
        explanation: 'Correct order: (1) fix types before operations (pd.to_numeric), (2) impute missing values, (3) remove invalid rows (negative income), (4) encode categoricals, (5) THEN split train/test. Never split before cleaning — you want the same cleaning applied consistently.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You want to find the average income and default rate for each city. Which pandas operation?',
        options: [
          'df.sort_values("city")',
          'df.groupby("city").agg({"income": "mean", "defaulted": "mean"}) — groups by city and applies different aggregations to each column simultaneously',
          'df[df["city"] == "Mumbai"].mean()',
          'df.pivot("city", "income", "defaulted")'
        ],
        correctIndex: 1,
        explanation: '.groupby("city").agg({}) lets you apply different aggregation functions to different columns simultaneously. "mean" on "defaulted" gives default rate per city (since it is binary, mean = proportion). This is the key operation for cohort analysis in ML.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Complete pandas EDA and Feature Engineering Pipeline',
      goal: 'Perform professional exploratory data analysis and feature engineering on a real dataset using pandas.',
      steps: [
        'Load the Titanic dataset (from seaborn: sns.load_dataset("titanic")) and run the full initial inspection: shape, dtypes, info, describe, isnull summary',
        'Handle missing values: fill age with median grouped by pclass and sex, fill embarked with mode, drop cabin (too many missing)',
        'Feature engineering: create family_size = sibsp + parch + 1, is_alone = (family_size == 1).astype(int), title extracted from name using str.extract',
        'Encode categoricals: get_dummies for sex, embarked, and title',
        'GroupBy analysis: survival rate by sex, by pclass, by age group (child/adult/senior using pd.cut), and by family size',
        'Prepare final feature matrix X and label y, verify shapes, and print top 5 features correlated with survival',
      ],
      expectedOutput: 'Titanic EDA Summary:\n  Shape: (891, 12) → after cleaning: (889, 18)\n  Missing handled: age(177)=median by group, cabin=dropped\n\nFeature Engineering:\n  family_size added (1-11 range)\n  is_alone added (38.6% are alone)\n  title extracted: Mr, Mrs, Miss, Master, Other\n\nSurvival Rates:\n  By sex: female=74.2%, male=18.9%\n  By pclass: 1st=63.0%, 2nd=47.3%, 3rd=24.2%\n  By family size: alone=30.4%, small(2-4)=57.9%\n\nTop correlated features with survival:\n  sex_female: +0.543\n  pclass: -0.338\n  fare: +0.257',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'aep_l2_visualization',
    topicTitle: 'Data Visualization (Matplotlib & Seaborn)',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 195,
    emoji: '📊',
    intro: 'Visualization is how AI engineers communicate data insights, model performance, and training progress. A well-designed chart reveals patterns that tables of numbers cannot — and convinces stakeholders faster than any written report. This course teaches you to create professional, publication-quality AI visualizations.',
    concepts: [
      ConceptLesson(
        title: 'Matplotlib Fundamentals — Building Any Chart',
        definition: 'Matplotlib is Python\'s foundational plotting library. Every other visualization tool (seaborn, pandas plot, PyTorch training plots) is built on Matplotlib. Understanding its figure/axes object model lets you customize any chart completely.',
        analogy: 'Matplotlib is like a blank canvas and professional paint set — you have complete control but must specify everything explicitly. Seaborn is like paint-by-numbers — faster for standard plots, beautiful defaults, but limited customization. Use both together.',
        example: '# Matplotlib essentials for AI:\nimport matplotlib.pyplot as plt\nimport numpy as np\n\n# Training loss curve:\nepochs = range(1, 51)\ntrain_loss = [1.0 * 0.95**e + 0.05*np.random.randn() for e in epochs]\nval_loss = [1.0 * 0.93**e + 0.08*np.random.randn() for e in epochs]\n\nfig, axes = plt.subplots(1, 2, figsize=(12, 4))\n\n# Plot 1: Loss curves:\naxes[0].plot(epochs, train_loss, label="Train Loss", color="blue")\naxes[0].plot(epochs, val_loss, label="Val Loss",\n             color="orange", linestyle="--")\naxes[0].set_title("Training and Validation Loss")\naxes[0].set_xlabel("Epoch")\naxes[0].set_ylabel("Loss")\naxes[0].legend()\naxes[0].grid(True, alpha=0.3)\n\n# Plot 2: Feature importance bar chart:\nfeature_names = ["age", "income", "credit_score", "tenure"]\nimportances = [0.35, 0.28, 0.22, 0.15]\naxes[1].barh(feature_names, importances, color="steelblue")\naxes[1].set_title("Feature Importance")\naxes[1].set_xlabel("Importance")\n\nplt.tight_layout()\nplt.savefig("model_analysis.png", dpi=150, bbox_inches="tight")\nplt.show()',
        keyTakeaway: 'Always use fig, ax = plt.subplots() instead of plt.plot() directly — the object-oriented interface lets you control each subplot precisely. Use plt.tight_layout() before saving to prevent overlapping labels. Save at dpi=150 for crisp figures.',
      ),
      ConceptLesson(
        title: 'Seaborn for Statistical ML Visualisation',
        definition: 'Seaborn builds on Matplotlib to create beautiful statistical plots with minimal code. Its heatmap, pairplot, boxplot, and histplot are the most-used charts in ML exploratory data analysis.',
        analogy: 'Seaborn is like hiring an interior designer — they know which colours, layouts, and proportions look professional and make your analysis credible. Instead of specifying every pixel, you describe what you want and get a polished result.',
        example: '# Seaborn for ML EDA:\nimport seaborn as sns\nimport matplotlib.pyplot as plt\n\n# Set professional style:\nsns.set_theme(style="whitegrid", palette="husl")\n\ndf = sns.load_dataset("titanic")\n\n# 1. Correlation heatmap — reveals feature relationships:\nfig, axes = plt.subplots(1, 2, figsize=(14, 5))\nnumeric_df = df.select_dtypes(include="number")\ncorr_matrix = numeric_df.corr()\nsns.heatmap(corr_matrix, annot=True, fmt=".2f",\n            cmap="coolwarm", center=0, ax=axes[0])\naxes[0].set_title("Feature Correlation Heatmap")\n\n# 2. Distribution by class:\nsns.boxplot(data=df, x="pclass", y="age",\n            hue="survived", ax=axes[1])\naxes[1].set_title("Age Distribution by Class and Survival")\n\nplt.tight_layout()\nplt.show()\n\n# 3. Pairplot — see all feature relationships at once:\nsns.pairplot(df[["age","fare","pclass","survived"]],\n             hue="survived", diag_kind="kde")\nplt.show()',
        keyTakeaway: 'The correlation heatmap is the single most important EDA chart — it shows which features are correlated with each other (multicollinearity) and with the target. Run it on every new dataset before feature selection. Dark red = strong positive correlation; dark blue = strong negative.',
      ),
      ConceptLesson(
        title: 'Model Evaluation Charts — Confusion Matrix and ROC',
        definition: 'The confusion matrix, ROC curve, precision-recall curve, and learning curves are the standard charts for evaluating ML model performance. These charts appear in every ML paper, presentation, and production report.',
        analogy: 'Model evaluation charts are like a doctor\'s full diagnostic report — not just "your blood pressure is 140/90" (single metric) but a complete picture: trend over time, comparison to healthy range, and which specific tests are elevated. Charts tell the full story.',
        example: '# Standard model evaluation charts:\nimport matplotlib.pyplot as plt\nimport seaborn as sns\nfrom sklearn.metrics import (confusion_matrix,\n    roc_curve, auc, precision_recall_curve)\nfrom sklearn.datasets import load_breast_cancer\nfrom sklearn.ensemble import RandomForestClassifier\nfrom sklearn.model_selection import train_test_split\n\nX, y = load_breast_cancer(return_X_y=True)\nX_train, X_test, y_train, y_test = train_test_split(X, y)\nmodel = RandomForestClassifier().fit(X_train, y_train)\ny_pred = model.predict(X_test)\ny_prob = model.predict_proba(X_test)[:, 1]\n\nfig, axes = plt.subplots(1, 3, figsize=(15, 4))\n\n# Confusion matrix:\ncm = confusion_matrix(y_test, y_pred)\nsns.heatmap(cm, annot=True, fmt="d", cmap="Blues", ax=axes[0])\naxes[0].set_title("Confusion Matrix")\naxes[0].set_ylabel("True Label")\naxes[0].set_xlabel("Predicted Label")\n\n# ROC Curve:\nfpr, tpr, _ = roc_curve(y_test, y_prob)\nroc_auc = auc(fpr, tpr)\naxes[1].plot(fpr, tpr, label=f"AUC = {roc_auc:.2f}")\naxes[1].plot([0,1], [0,1], "k--")\naxes[1].set_title("ROC Curve")\naxes[1].legend()\n\n# Feature importance:\nimportances = model.feature_importances_\ntop_idx = importances.argsort()[-10:][::-1]\naxes[2].barh(range(10), importances[top_idx])\naxes[2].set_title("Top 10 Feature Importances")\n\nplt.tight_layout()\nplt.savefig("model_evaluation.png", dpi=150)',
        keyTakeaway: 'The confusion matrix is mandatory for every classification problem — it shows exactly where your model makes mistakes (which class it confuses with which). Always plot it with actual counts (fmt="d") so you can see if errors are clinically significant, not just statistically.',
      ),
      ConceptLesson(
        title: 'Training Progress Visualisation',
        definition: 'Plotting training and validation loss/accuracy curves over epochs reveals whether your model is underfitting, overfitting, or training correctly. These curves are the primary diagnostic tool during deep learning training.',
        analogy: 'Training curves are like a student\'s exam scores over a semester — training loss is their homework scores (always improving), validation loss is their actual exam scores (what really matters). When homework improves but exams worsen, the student is memorising, not learning (overfitting).',
        example: '# Training curve analysis:\nimport matplotlib.pyplot as plt\n\ndef plot_training_curves(history):\n    """Plot training and validation loss/accuracy.\n    Args:\n        history: dict with keys train_loss, val_loss,\n                 train_acc, val_acc — lists by epoch\n    """\n    fig, axes = plt.subplots(1, 2, figsize=(12, 4))\n    epochs = range(1, len(history["train_loss"]) + 1)\n\n    # Loss subplot:\n    axes[0].plot(epochs, history["train_loss"],\n                 "b-", label="Training Loss")\n    axes[0].plot(epochs, history["val_loss"],\n                 "r--", label="Validation Loss")\n    axes[0].set_title("Model Loss")\n    axes[0].set_xlabel("Epoch")\n    axes[0].set_ylabel("Loss")\n    axes[0].legend()\n    axes[0].grid(True, alpha=0.3)\n\n    # Accuracy subplot:\n    axes[1].plot(epochs, history["train_acc"],\n                 "b-", label="Training Acc")\n    axes[1].plot(epochs, history["val_acc"],\n                 "r--", label="Validation Acc")\n    axes[1].set_title("Model Accuracy")\n    axes[1].set_xlabel("Epoch")\n    axes[1].set_ylabel("Accuracy")\n    axes[1].legend()\n\n    plt.tight_layout()\n    plt.show()\n\n    # Diagnose:\n    if history["val_loss"][-1] > history["val_loss"][-10]:\n        print("Warning: Validation loss increasing — overfitting detected!")',
        keyTakeaway: 'Overfitting signature: training loss keeps decreasing but validation loss starts increasing. Underfitting signature: both training and validation loss plateau at a high value. The gap between training and validation performance is your bias-variance indicator.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'In a confusion matrix for cancer detection, which error is more dangerous: False Positive or False Negative?',
        options: [
          'False Positive — incorrectly diagnosing cancer when there is none causes unnecessary treatment',
          'False Negative — missing actual cancer means the patient receives no treatment and the disease progresses untreated. Minimising False Negatives (maximising Recall) is the clinical priority.',
          'Both are equally dangerous',
          'Neither is dangerous in modern medicine'
        ],
        correctIndex: 1,
        explanation: 'False Negative (missed cancer) is clinically more dangerous — the patient has cancer but is told they are healthy and receives no treatment. This is why cancer screening models optimise for Recall (catch as many true cases as possible) even at the cost of more False Positives (unnecessary follow-up tests).',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Your training loss curve decreases steadily but validation loss starts increasing after epoch 20. What does this indicate?',
        options: [
          'The model is training correctly',
          'Overfitting — the model is memorising training data. Apply regularisation, early stopping, or dropout. The optimal model is at epoch 20 where val_loss was lowest.',
          'Underfitting — the model needs more parameters',
          'The learning rate is too low'
        ],
        correctIndex: 1,
        explanation: 'Training loss going down while validation loss goes up is the classic overfitting signature. The model has memorised training data and lost generalisation ability. Solutions: early stopping (save model at epoch 20), L1/L2 regularisation, dropout, or more training data.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is the correlation heatmap the FIRST visualization to create on a new dataset?',
        options: [
          'It is the fastest chart to create',
          'It reveals multicollinearity (highly correlated features to drop), shows which features correlate with the target (feature selection), and identifies data leakage (a feature with >0.99 correlation to target)',
          'It is required by Kaggle competitions',
          'It automatically cleans the data'
        ],
        correctIndex: 1,
        explanation: 'The correlation heatmap in one chart reveals: which features to potentially drop (high inter-correlation = redundant), which features are promising (high correlation with target), and data leakage (a feature impossibly correlated with target). It guides every subsequent analysis decision.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You have a model with 95% accuracy on a binary fraud detection dataset where 95% of samples are "not fraud". The ROC-AUC is 0.61. What do the charts tell you?',
        options: [
          'The model is excellent — 95% accuracy is high',
          'The model is nearly useless — 95% accuracy is achieved by predicting "not fraud" always. AUC of 0.61 (barely above 0.5 random baseline) confirms poor fraud discrimination. Use PR-curve and Recall for fraud class as primary metrics.',
          'The AUC calculation has a bug',
          'The model needs more training epochs'
        ],
        correctIndex: 1,
        explanation: 'High accuracy + low AUC = degenerate model on imbalanced data. The model likely predicts "not fraud" for almost everything, achieving 95% accuracy trivially. AUC of 0.61 means it barely beats random guessing at ranking fraud vs non-fraud. The confusion matrix would show near-zero Recall for the fraud class.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You want to show your manager how feature importance varies across 5 different model experiments. What chart type best communicates this?',
        options: [
          'Line chart — shows trends over time',
          'Grouped horizontal bar chart (barh) with one bar per feature per model — makes direct comparison of importance values across models easy to read, especially for long feature names',
          'Pie chart — shows proportion of importance',
          'Scatter plot — shows relationships between features'
        ],
        correctIndex: 1,
        explanation: 'Horizontal bar charts work best for feature importance because feature names are text labels that are easier to read horizontally. Grouped bars (hue per model) enable direct comparison across models. Seaborn\'s barplot with hue parameter creates this in one line.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'AI Model Analysis Dashboard',
      goal: 'Create a complete visual analysis report for a trained ML model — 6 charts in a professional multi-panel layout.',
      steps: [
        'Train a RandomForestClassifier on the breast cancer dataset from sklearn.datasets',
        'Create a 2x3 subplot figure (figsize 16x10) with proper titles and labels for all 6 charts',
        'Chart 1: Correlation heatmap of top 10 features (seaborn heatmap)',
        'Chart 2: Target class distribution bar chart showing class balance',
        'Chart 3: Confusion matrix with actual counts and color coding',
        'Chart 4: ROC curve with AUC score in legend',
        'Chart 5: Feature importance (top 10 features, horizontal bar)',
        'Chart 6: Training accuracy vs number of estimators (1 to 200) showing the learning curve',
      ],
      expectedOutput: 'Model: RandomForestClassifier on Breast Cancer Dataset\nAccuracy: 96.5% | AUC-ROC: 0.994 | F1: 0.966\n\n6-panel visualization saved as model_dashboard.png\n  Panel 1: Correlation heatmap (10x10) ✓\n  Panel 2: Class balance (212 malignant, 357 benign) ✓\n  Panel 3: Confusion matrix (3 FP, 2 FN) ✓\n  Panel 4: ROC curve (AUC=0.994) ✓\n  Panel 5: Top 10 feature importances ✓\n  Panel 6: Accuracy vs n_estimators curve ✓\n\nDashboard saved to model_dashboard.png ✓',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'aep_l2_mini_project',
    topicTitle: 'Python Mini AI Project',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Hard',
    estimatedMinutes: 50,
    totalXp: 300,
    emoji: '🚀',
    intro: 'This is your Level 2 capstone — where every Python for AI skill comes together in one real, end-to-end project. You will build a complete crop disease prediction system: load and clean data, engineer features, train and compare models, visualise results, and serve predictions through a simple API. This is what professional AI engineering looks like.',
    concepts: [
      ConceptLesson(
        title: 'Project Architecture — Planning Before Coding',
        definition: 'Every professional AI project starts with a clear architecture plan: what data flows where, which modules handle which responsibilities, how the training pipeline connects to the serving pipeline, and what the output interface looks like.',
        analogy: 'Planning an AI project architecture is like an architect designing a building before construction. You sketch the floor plan (module structure), decide where the plumbing goes (data flow), and specify the entrance (API interface) before a single brick is laid (code is written).',
        example: '# Project: Crop Disease Prediction System\n#\n# Architecture:\n#\n# INPUT: Crop feature data (soil, weather, crop type)\n# ↓\n# data_loader.py: load CSV, validate schema\n# ↓\n# feature_engineer.py: create derived features\n# ↓\n# preprocessor.py: scale, encode, train/test split\n# ↓\n# model_trainer.py: train multiple models, select best\n# ↓\n# evaluator.py: metrics + visualizations\n# ↓\n# model_saver.py: save model + preprocessor as pickle\n# ↓\n# predictor.py: load saved model, predict new samples\n# ↓\n# OUTPUT: Disease prediction + confidence score\n#\n# Each module: one responsibility, tested independently\n# config.py: all paths, hyperparameters in one place',
        keyTakeaway: 'The architecture diagram is a communication tool — show it to a senior engineer and they immediately understand what you are building, where the complexity is, and how to review your code. A project without architecture is a project that is hard to maintain.',
      ),
      ConceptLesson(
        title: 'Building Reproducible ML Experiments',
        definition: 'Reproducibility means another engineer can run your code and get the exact same results. This requires: fixed random seeds, versioned data, logged hyperparameters, saved model artifacts, and environment specifications.',
        analogy: 'Reproducibility in ML is like a scientific experiment that must be replicable — if another lab cannot reproduce your results with your method and data, your findings are scientifically invalid. The same standard applies to ML engineering.',
        example: '# Reproducibility essentials:\nimport random\nimport numpy as np\n\n# Fix all random seeds at the top of EVERY script:\ndef set_all_seeds(seed=42):\n    """Fix random seeds for full reproducibility."""\n    random.seed(seed)\n    np.random.seed(seed)\n    try:\n        import torch\n        torch.manual_seed(seed)\n        torch.backends.cudnn.deterministic = True\n    except ImportError:\n        pass\n\nset_all_seeds(42)\n\n# Log all hyperparameters:\nconfig = {\n    "random_seed": 42,\n    "test_size": 0.2,\n    "n_estimators": 100,\n    "max_depth": 10,\n    "data_version": "v2.3",\n    "model_version": "rf_v1"\n}\n\nimport json\nwith open("experiment_config.json", "w") as f:\n    json.dump(config, f, indent=2)\n\n# Log results alongside config:\nresults = {"accuracy": 0.94, "f1": 0.93}\nwith open("experiment_results.json", "w") as f:\n    json.dump({**config, **results}, f, indent=2)',
        keyTakeaway: 'Set random seeds at the very top of every script — before any imports that might use randomness. Log your complete config and results together in one JSON file per experiment. This lets you rebuild any past experiment exactly and compare results fairly.',
      ),
      ConceptLesson(
        title: 'Model Comparison and Selection',
        definition: 'Training multiple models and selecting the best based on appropriate metrics is standard practice. Build a comparison framework that evaluates all candidate models consistently and selects the winner objectively.',
        analogy: 'Model comparison is like a cooking competition — all chefs use the same ingredients (data), the same kitchen (compute), and are judged by the same criteria (metrics). The winner is selected objectively, not by preference or guesswork.',
        example: '# Model comparison framework:\nfrom sklearn.linear_model import LogisticRegression\nfrom sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier\nfrom sklearn.svm import SVC\nfrom sklearn.metrics import accuracy_score, f1_score, roc_auc_score\nimport pandas as pd\n\n# Define candidate models:\ncandidates = {\n    "Logistic Regression": LogisticRegression(max_iter=1000),\n    "Random Forest": RandomForestClassifier(n_estimators=100, random_state=42),\n    "Gradient Boosting": GradientBoostingClassifier(random_state=42),\n    "SVM": SVC(probability=True, random_state=42)\n}\n\n# Evaluate all candidates consistently:\nresults = []\nfor name, model in candidates.items():\n    model.fit(X_train, y_train)\n    y_pred = model.predict(X_test)\n    y_prob = model.predict_proba(X_test)[:, 1]\n    results.append({\n        "Model": name,\n        "Accuracy": accuracy_score(y_test, y_pred),\n        "F1": f1_score(y_test, y_pred, average="weighted"),\n        "AUC": roc_auc_score(y_test, y_prob)\n    })\n\nresults_df = pd.DataFrame(results).sort_values("F1", ascending=False)\nprint(results_df.to_string(index=False))\nbest_model_name = results_df.iloc[0]["Model"]',
        keyTakeaway: 'Always compare at least 3 models: a simple baseline (Logistic Regression), a classical ML workhorse (Random Forest or XGBoost), and one more. The baseline tells you the minimum acceptable performance. The winner tells you if complexity is worth it.',
      ),
      ConceptLesson(
        title: 'Saving and Loading the Complete Pipeline',
        definition: 'Saving an ML model means saving BOTH the trained model AND the fitted preprocessor — because predictions on new data must go through identical preprocessing as training data. Saving only the model is a common bug that produces wrong predictions.',
        analogy: 'Saving an ML pipeline is like publishing a recipe — you save both the list of ingredients (model weights) AND the preparation instructions (preprocessor). A recipe that says "add flour" without specifying "sifted" or "packed" produces inconsistent results.',
        example: '# Save and load complete ML pipeline:\nimport pickle\nfrom pathlib import Path\n\ndef save_pipeline(model, preprocessor, config, save_dir="models/"):\n    """Save complete ML pipeline for later use."""\n    Path(save_dir).mkdir(exist_ok=True)\n\n    # Save model:\n    with open(f"{save_dir}/model.pkl", "wb") as f:\n        pickle.dump(model, f)\n\n    # Save preprocessor (CRITICAL — do not forget this!):\n    with open(f"{save_dir}/preprocessor.pkl", "wb") as f:\n        pickle.dump(preprocessor, f)\n\n    # Save config and feature names:\n    with open(f"{save_dir}/config.json", "w") as f:\n        json.dump(config, f, indent=2)\n\n    print(f"Pipeline saved to {save_dir}")\n\ndef load_pipeline(save_dir="models/"):\n    """Load complete ML pipeline."""\n    with open(f"{save_dir}/model.pkl", "rb") as f:\n        model = pickle.load(f)\n    with open(f"{save_dir}/preprocessor.pkl", "rb") as f:\n        preprocessor = pickle.load(f)\n    with open(f"{save_dir}/config.json") as f:\n        config = json.load(f)\n    return model, preprocessor, config\n\ndef predict_new(raw_data: dict, save_dir="models/"):\n    model, preprocessor, config = load_pipeline(save_dir)\n    df = pd.DataFrame([raw_data])\n    X = preprocessor.transform(df)  # same transform as training!\n    pred = model.predict(X)\n    prob = model.predict_proba(X).max()\n    return {"prediction": int(pred[0]), "confidence": float(prob)}',
        keyTakeaway: 'The most common production ML bug: saving only the model without the preprocessor, then applying raw features directly to the model and getting nonsense predictions. Always save model + preprocessor + feature_names as a complete package.',
      ),
      ConceptLesson(
        title: 'Serving Predictions — Simple FastAPI Endpoint',
        definition: 'A trained ML model has no value until it can make predictions on new data. FastAPI creates a REST API endpoint that accepts input data and returns predictions — turning your Python model into a service any application can call.',
        analogy: 'Serving a model with FastAPI is like opening a restaurant after developing the recipes — you have done all the hard work (trained the model), now you open the kitchen to customers. The API is the window through which anyone can order a prediction.',
        example: '# Simple FastAPI prediction server:\nfrom fastapi import FastAPI, HTTPException\nfrom pydantic import BaseModel\nfrom typing import List\nimport pickle\nimport pandas as pd\nimport json\n\napp = FastAPI(title="Crop Disease Predictor API")\n\n# Load pipeline once at startup:\nmodel, preprocessor, config = load_pipeline("models/")\n\n# Define input schema:\nclass CropFeatures(BaseModel):\n    temperature: float\n    humidity: float\n    soil_ph: float\n    rainfall: float\n    crop_type: str\n\nclass PredictionResponse(BaseModel):\n    disease: str\n    confidence: float\n    model_version: str\n\n@app.post("/predict", response_model=PredictionResponse)\ndef predict_disease(features: CropFeatures):\n    """Predict crop disease from environmental features."""\n    try:\n        df = pd.DataFrame([features.dict()])\n        X = preprocessor.transform(df)\n        pred_idx = model.predict(X)[0]\n        confidence = model.predict_proba(X).max()\n        disease_name = config["class_names"][pred_idx]\n        return PredictionResponse(\n            disease=disease_name,\n            confidence=round(float(confidence), 3),\n            model_version=config["model_version"]\n        )\n    except Exception as e:\n        raise HTTPException(status_code=500, detail=str(e))\n\n@app.get("/health")\ndef health_check():\n    return {"status": "healthy", "model": config["model_version"]}',
        keyTakeaway: 'Always add a /health endpoint to any ML API — monitoring systems ping it to check the service is running. Use Pydantic models (BaseModel) for input validation — FastAPI automatically returns a 422 error with a clear message if required fields are missing or have wrong types.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'You trained a model on scaled features (StandardScaler applied). A new prediction request comes in with raw unscaled features. What happens?',
        options: [
          'The model adapts automatically to unscaled input',
          'The model produces incorrect predictions — it learned from scaled data with mean=0, std=1. Raw features have completely different value ranges and the model\'s learned weights do not apply correctly to them.',
          'The model returns an error automatically',
          'The predictions will be slightly off but usable'
        ],
        correctIndex: 1,
        explanation: 'This is the most common production ML bug. A model trained on StandardScaled data (mean=0, std=1) will produce wildly wrong predictions on raw input (mean=50000, std=30000 for income). Always save and apply the fitted preprocessor to ALL new data before prediction.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why must random seeds be set BEFORE any other imports or operations in an ML script?',
        options: [
          'Python requires seeds at the top for syntax reasons',
          'Some libraries initialise their random state during import. Setting seeds after importing may miss these initialisations — some randomness has already been consumed. Seeds at the very top guarantee complete reproducibility.',
          'Seeds only affect numpy.random, not other libraries',
          'It is a style convention with no practical effect'
        ],
        correctIndex: 1,
        explanation: 'Libraries like numpy can initialise internal random state during import. If you set np.random.seed() after import, some random choices during import may already have occurred. Setting ALL seeds as the very first operation in your script ensures nothing random has happened before you take control.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'FastAPI\'s Pydantic BaseModel input schema automatically does what when a request sends a string for a float field?',
        options: [
          'Accepts it silently and converts automatically',
          'Returns a 422 Unprocessable Entity error with a clear message showing which field has the wrong type — before your prediction code ever runs',
          'Crashes the entire server',
          'Converts the string to 0.0 as a default'
        ],
        correctIndex: 1,
        explanation: 'Pydantic validates all incoming request data against the BaseModel schema before calling your function. Wrong types, missing required fields, and out-of-range values all produce automatic 422 errors with descriptive messages — protecting your model from bad input without any manual validation code.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Your model achieves 94% accuracy in training but only 71% in production. The training and production data both come from the same source. What is the most likely cause?',
        options: [
          'The production server is slower',
          'Data leakage in training — a feature that is available during training but not at prediction time (like a future date field or a derived label) inflated training accuracy. The model never learned the real signal.',
          'The model needs more training data',
          'Production users are different from training users'
        ],
        correctIndex: 1,
        explanation: 'A 23% gap between training and production accuracy (with same data source) is the classic data leakage signature. A feature available at training time but not genuinely at prediction time — like a field filled AFTER the event you are predicting — inflates training accuracy artificially.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Your FastAPI /predict endpoint crashes when a user sends {"temperature": "hot", "humidity": 85}. How do you handle this gracefully?',
        options: [
          'Add try/except around all code and return 500 on any error',
          'Use Pydantic BaseModel with temperature: float — FastAPI automatically returns 422 with message "temperature: value is not a valid float" before your code runs. For unexpected errors inside, use HTTPException(status_code=500, detail=str(e))',
          'Validate each field manually with if/else',
          'Return empty prediction on any error'
        ],
        correctIndex: 1,
        explanation: 'Pydantic handles type validation automatically (422 for "hot" where float expected). For errors inside prediction logic (model failure, preprocessing error), catch with try/except and raise HTTPException(500, detail=message). This gives clients actionable error messages at the right HTTP status code.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Crop Disease Prediction System — Complete AI Project',
      goal: 'Build a production-ready crop disease prediction system from data to API — applying every Python for AI skill from Level 2.',
      steps: [
        'Setup: create virtual environment, install dependencies, define project structure with config.py, data_utils.py, feature_engineer.py, model_trainer.py, evaluate.py, predictor.py, and app.py',
        'Data: use sklearn\'s make_classification to generate a synthetic crop disease dataset (1000 samples, 8 features, 4 classes). Save as CSV and load via data_utils.py with full validation and custom exceptions',
        'Feature Engineering: in feature_engineer.py, create 3 interaction features and 2 binned features from raw data using pandas — document each feature\'s agricultural rationale in docstrings',
        'Training: in model_trainer.py, compare Logistic Regression, Random Forest, and GradientBoosting — log all results to experiments.json with timestamps and full config',
        'Evaluation: use evaluate.py to generate a 4-panel visualization: confusion matrix, ROC curves for each class (OvR), feature importance, and class distribution',
        'Pipeline: save the winning model + preprocessor + config using save_pipeline(). Write predict_new(raw_dict) that loads the saved pipeline and returns prediction + confidence',
        'API: in app.py, create a FastAPI app with /predict POST endpoint, /health GET endpoint, and proper Pydantic input/output models',
        'Run the full pipeline end-to-end and make a test prediction via both direct Python call and simulated HTTP request',
      ],
      expectedOutput: '=== Crop Disease Prediction System ===\n\nEnvironment: crop_disease_env (Python 3.11)\nDependencies: requirements.txt (8 packages)\n\nData Pipeline:\n  Generated: 1000 samples, 8 features, 4 disease classes\n  Cleaned: 0 invalid samples removed\n  Features engineered: 13 total (8 original + 5 new)\n\nModel Comparison:\n  Logistic Regression: F1=0.812, AUC=0.941\n  Random Forest:       F1=0.951, AUC=0.997  ← WINNER\n  Gradient Boosting:   F1=0.938, AUC=0.996\n\nWinner saved: models/model.pkl + preprocessor.pkl + config.json\n\nEvaluation dashboard: evaluation.png ✓\nExperiment log: experiments.json ✓\n\nPython prediction test:\n  Input: {temperature:28, humidity:70, soil_ph:6.2, ...}\n  Output: {disease: "leaf_blight", confidence: 0.923}\n\nFastAPI server running on http://localhost:8000\n  GET /health → {"status": "healthy", "model": "rf_v1"}\n  POST /predict → {disease, confidence, model_version} ✓\n\n=== Level 2 Complete — Python for AI Mastered ===',
      xpReward: 100,
    ),
  ),

];