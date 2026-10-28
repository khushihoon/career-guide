import '../../models/course_content_data.dart';

const List<TopicCourse> llmEngineerLevel3 = [
  TopicCourse(
    id: 'numpy_numerical_computing_l3',
    topicTitle: 'NumPy for Numerical Computing',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🔢',
    intro:
        'Welcome to Level 3. Every machine learning library you will ever use — PyTorch, scikit-learn, even Hugging Face — is built on the same numerical foundation: NumPy. This lesson turns Level 2\'s vector and matrix math into real, runnable code you will reuse constantly.',
    concepts: [
      ConceptLesson(
        title: 'NumPy Arrays: Fast, Vectorized Computation',
        definition:
            'NumPy provides the ndarray, a fast, memory-efficient way to store and compute on large numerical arrays — operations on NumPy arrays run as optimized compiled code instead of slow Python loops, which is why every deep learning framework builds on top of this same idea.',
        analogy:
            'A NumPy array is like a factory conveyor belt that processes every item simultaneously, instead of a worker handling one item at a time (a plain Python loop). Doing math on a million numbers with NumPy is like running the whole conveyor belt at once — dramatically faster than looping through them one by one.',
        example:
            'import numpy as np\nprices = np.array([100, 200, 150, 300])\ndiscounted = prices * 0.9   # applies to all 4 values instantly, no loop needed\nprint(discounted)  # [90. 180. 135. 270.]',
        keyTakeaway:
            'This "vectorized" way of thinking — operate on the whole array at once instead of writing a for loop — is the mental shift that makes you effective with every ML and deep learning library from here through Level 10.',
        codeSnippet:
            'import numpy as np\n\nprices = np.array([100, 200, 150, 300])\ndiscounted = prices * 0.9\nprint(discounted)\n\nmatrix = np.array([[1, 2], [3, 4]])\nprint(matrix.sum())      # 10\nprint(matrix.mean())     # 2.5',
      ),
      ConceptLesson(
        title: 'Indexing, Slicing and Reshaping',
        definition:
            'NumPy lets you select subsets of an array using indexing and slicing (just like Python lists, but more powerful for multi-dimensional data), and reshape an array\'s dimensions without changing its underlying data — both essential when preparing data for a machine learning model.',
        analogy:
            'Slicing a NumPy array is like cutting exact portions from a large sheet cake — you specify precisely which rows and columns you want, and NumPy hands you that exact piece without disturbing the rest of the cake. Reshaping is like rearranging the same cake pieces into a different tray shape without changing how much cake you actually have.',
        example:
            'data = np.array([[1, 2, 3], [4, 5, 6]])\nprint(data[0])        # [1 2 3] - first row\nprint(data[:, 1])     # [2 5] - second column, all rows\nreshaped = data.reshape(3, 2)\nprint(reshaped)       # same 6 numbers, new 3x2 shape',
        keyTakeaway:
            'You will reshape data constantly when preparing it for models — from flattening images into vectors to reorganizing batches of text for a transformer in Level 6. Getting comfortable with shape manipulation now prevents hours of confusing "shape mismatch" errors later.',
        codeSnippet:
            'import numpy as np\n\ndata = np.array([[1, 2, 3], [4, 5, 6]])\nprint(data[0])\nprint(data[:, 1])\n\nreshaped = data.reshape(3, 2)\nprint(reshaped)\nprint(reshaped.shape)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why is NumPy preferred over plain Python loops for numerical computation in machine learning?',
        options: [
          'NumPy is required by Python to run any code at all',
          'NumPy performs operations on entire arrays using optimized, vectorized compiled code, making it dramatically faster than looping through elements one by one in plain Python',
          'NumPy can only be used for text processing, not numbers',
          'There is no actual performance difference between NumPy and plain Python loops'
        ],
        correctIndex: 1,
        explanation:
            'NumPy\'s vectorized operations run as optimized compiled code under the hood, making array-wide computations dramatically faster than equivalent Python for-loops — a performance difference that becomes critical at ML scale.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does data.reshape(3, 2) do to a NumPy array that originally has 6 elements in a (2, 3) shape?',
        options: [
          'It deletes half the data to fit the new shape',
          'It reorganizes the same 6 underlying values into a new (3, 2) shape without changing the actual data',
          'It creates 6 brand new random numbers',
          'Reshape only works on 1-dimensional arrays'
        ],
        correctIndex: 1,
        explanation:
            'reshape() reorganizes the same underlying data into a new shape, as long as the total number of elements matches (2x3=6 and 3x2=6 both work) — no data is created or destroyed.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Given data = np.array([10, 20, 30, 40, 50]), what does data[1:4] return?',
        options: [
          '[10, 20, 30, 40]',
          '[20, 30, 40]',
          '[20, 30, 40, 50]',
          '[10, 50]'
        ],
        correctIndex: 1,
        explanation:
            'Slicing [1:4] includes index 1 up to (but not including) index 4 — that is elements at positions 1, 2, and 3: [20, 30, 40]. This same slicing rule applies to plain Python lists too.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'NumPy Data Preparation Toolkit',
      goal:
          'Build a small set of NumPy-based data preparation utilities — the exact kind of preprocessing code used before feeding data into any ML model in this level and beyond.',
      steps: [
        'Create a NumPy array representing 5 samples with 3 features each (shape 5x3) using random numbers',
        'Write a function normalize(data) that scales all values to a 0-1 range using (data - data.min()) / (data.max() - data.min())',
        'Write a function get_feature_column(data, index) that returns a single feature (column) across all samples',
        'Reshape your original 5x3 array into a 15x1 "flattened" array and print its new shape',
        'Print the mean and standard deviation of the normalized data, confirming the mean is close to a small value and values are between 0 and 1',
      ],
      expectedOutput:
          'Original shape: (5, 3)\nNormalized data:\n[[0.42 0.71 0.05] ...]\nFeature column 0: [0.42 0.11 0.88 0.33 0.67]\nFlattened shape: (15, 1)\nMean: 0.48, Std: 0.29',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'pandas_data_handling_l3',
    topicTitle: 'Pandas for Data Handling',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🐼',
    intro:
        'Real-world data almost never arrives as clean NumPy arrays — it arrives as messy spreadsheets, CSVs, and logs. Pandas is the tool every ML and LLM engineer uses to load, clean, and explore this kind of tabular data before it ever reaches a model.',
    concepts: [
      ConceptLesson(
        title: 'DataFrames: Tabular Data in Python',
        definition:
            'A Pandas DataFrame is a labeled, 2-dimensional table of data — similar to a spreadsheet — where each column can hold a different data type, and every row and column has a label you can use to select and filter data intuitively.',
        analogy:
            'A DataFrame is like an Excel spreadsheet that lives inside your Python code — you can filter rows, add columns, sort, and summarize just like in a spreadsheet, except every operation is a reusable, reproducible line of code instead of a manual click.',
        example:
            'import pandas as pd\ndf = pd.DataFrame({\n    "text": ["Great product!", "Terrible service", "Loved it"],\n    "rating": [5, 1, 5]\n})\nprint(df.head())\nprint(df[df["rating"] >= 4])   # filter to only positive reviews',
        keyTakeaway:
            'Whenever you prepare a dataset for fine-tuning an LLM in Level 7, or build a document collection for RAG in Level 8, you will very likely load and clean it using a Pandas DataFrame first — this is the standard entry point for almost all real-world data work.',
        codeSnippet:
            'import pandas as pd\n\ndf = pd.DataFrame({\n    "text": ["Great product!", "Terrible service", "Loved it"],\n    "rating": [5, 1, 5]\n})\nprint(df.head())\nprint(df[df["rating"] >= 4])',
      ),
      ConceptLesson(
        title: 'Cleaning and Exploring Data with Pandas',
        definition:
            'Pandas provides built-in methods for essential data cleaning: .isnull() finds missing values, .dropna() removes them, .fillna() replaces them, .duplicated() finds repeated rows, and .describe() gives a quick statistical summary — all essential before any dataset is usable for training or fine-tuning.',
        analogy:
            'Cleaning a dataset with Pandas is like a librarian preparing a batch of returned books before reshelving them — checking for missing pages (.isnull()), removing damaged duplicates (.dropna()/.duplicated()), and doing a quick overall condition check (.describe()) before the books go back on the shelf for readers to trust and use.',
        example:
            'df.isnull().sum()          # count missing values per column\ndf = df.dropna()           # remove rows with any missing values\ndf = df.drop_duplicates()  # remove exact duplicate rows\nprint(df.describe())       # count, mean, std, min, max for numeric columns',
        keyTakeaway:
            'Raw datasets — whether scraped text for RAG (Level 8) or examples for fine-tuning (Level 7) — are almost never clean. This exact cleaning workflow (check missing values, remove duplicates, summarize) is one of the most repeated tasks in real LLM engineering work.',
        codeSnippet:
            'import pandas as pd\n\ndf = pd.DataFrame({\n    "text": ["Good", None, "Good", "Bad"],\n    "rating": [4, 3, 4, None]\n})\n\nprint(df.isnull().sum())\ncleaned = df.dropna().drop_duplicates()\nprint(cleaned)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is a Pandas DataFrame, in plain terms?',
        options: [
          'A single number stored in memory',
          'A labeled, 2-dimensional table of data (like a spreadsheet) that supports filtering, sorting, and column-wise operations',
          'A type of neural network layer',
          'A file format that only stores images'
        ],
        correctIndex: 1,
        explanation:
            'A DataFrame is Pandas\' core structure — a labeled 2D table similar to a spreadsheet, letting you filter, clean, and analyze tabular data using readable, reusable code.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is cleaning a dataset with .dropna() and .drop_duplicates() especially important before using it to fine-tune an LLM (Level 7)?',
        options: [
          'It is not actually important — LLMs can handle any raw, messy data equally well',
          'Missing values and duplicate examples can degrade training quality and waste compute — clean, deduplicated data leads to more reliable and efficient fine-tuning results',
          'These methods only work on numeric data, never text',
          'Cleaning data is only relevant for classical ML, never for LLMs'
        ],
        correctIndex: 1,
        explanation:
            'Just like in classical ML, messy or duplicated training examples can hurt the quality and efficiency of LLM fine-tuning — the same data-cleaning discipline from this lesson applies directly when preparing fine-tuning datasets in Level 7.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You have a DataFrame df with a "rating" column that has some missing (NaN) values. Which line correctly removes ALL rows that have any missing value in ANY column?',
        options: [
          'df.fillna(0)',
          'df.dropna()',
          'df.describe()',
          'df.duplicated()'
        ],
        correctIndex: 1,
        explanation:
            'df.dropna() removes any row containing at least one missing (NaN) value across any column — the standard method for eliminating incomplete rows before further analysis or modeling.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Clean and Explore a Simulated Review Dataset',
      goal:
          'Practice the exact load-clean-explore workflow used before any real ML or LLM fine-tuning project, using a small simulated customer review dataset.',
      steps: [
        'Create a Pandas DataFrame with at least 10 rows containing columns: "review_text", "rating" (1-5), and intentionally include 2 missing values and 1 duplicate row',
        'Print df.isnull().sum() to identify missing values',
        'Clean the dataset: drop rows with missing values, then drop duplicate rows',
        'Print df.describe() on the cleaned data to summarize the rating column',
        'Filter and print only the reviews with rating >= 4 (positive reviews) and count how many remain',
      ],
      expectedOutput:
          'Missing values before cleaning:\nreview_text    1\nrating         1\n\nCleaned dataset shape: (8, 2)\nRating summary: mean=3.6, min=1, max=5\n\nPositive reviews (rating >= 4): 5',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'supervised_unsupervised_learning_l3',
    topicTitle: 'Supervised vs Unsupervised Learning',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '🎓',
    intro:
        'Before touching a single ML algorithm, you need to know what "kind" of learning problem you are solving. This lesson builds the conceptual map that later explains exactly how LLM pretraining, fine-tuning, and embedding clustering each fit into the bigger ML picture.',
    concepts: [
      ConceptLesson(
        title: 'Supervised Learning: Learning from Labeled Examples',
        definition:
            'Supervised learning trains a model using labeled data — pairs of inputs and correct outputs — so the model learns to predict the correct output for new, unseen inputs by generalizing from the examples it was shown.',
        analogy:
            'Supervised learning is like a student studying with a teacher who has already marked all the practice questions with correct answers. The student (model) studies these labeled examples and learns the underlying pattern well enough to correctly answer NEW, unmarked questions on the actual exam.',
        example:
            'A spam classifier is trained on thousands of emails EACH labeled "spam" or "not spam" by humans. The model learns the pattern connecting email features to the correct label, so it can classify brand-new, never-seen emails.',
        keyTakeaway:
            'Supervised learning is directly relevant to LLM Engineering: instruction fine-tuning (Level 7) is literally supervised learning, where the "labels" are human-written example responses showing the model what a good answer looks like.',
      ),
      ConceptLesson(
        title: 'Unsupervised Learning: Finding Structure Without Labels',
        definition:
            'Unsupervised learning finds patterns, groupings, or structure in data that has NO labels at all — the model discovers structure on its own, without being told the "correct answer" for any example.',
        analogy:
            'Unsupervised learning is like sorting a huge box of unlabeled photographs into meaningful piles purely by visual similarity — no one told you the categories in advance; you discover natural groupings (family, nature, food) just from the patterns you notice yourself.',
        example:
            'Clustering customer purchase data into groups without predefined categories reveals natural segments (e.g., "budget shoppers," "premium loyalists") that no one explicitly labeled — the algorithm discovers these groupings purely from patterns in the data.',
        keyTakeaway:
            'Remarkably, LLM PRETRAINING (Level 6-7) is fundamentally self-supervised — a close cousin of unsupervised learning — where the model learns from raw, unlabeled text by predicting masked or next words, generating its own "labels" from the text itself rather than needing humans to label anything.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the defining characteristic that separates supervised learning from unsupervised learning?',
        options: [
          'Supervised learning is always more accurate than unsupervised learning',
          'Supervised learning uses labeled data (input-output pairs with known correct answers), while unsupervised learning finds patterns in data that has no labels at all',
          'Unsupervised learning can only be used for image data',
          'There is no meaningful difference between the two approaches'
        ],
        correctIndex: 1,
        explanation:
            'The presence or absence of labels is the defining distinction: supervised learning trains on labeled input-output pairs, while unsupervised learning discovers structure in unlabeled data with no known correct answers.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is LLM instruction fine-tuning (Level 7) considered a form of supervised learning?',
        options: [
          'It is actually a form of unsupervised learning, not supervised',
          'It uses labeled examples — pairs of instructions and human-written example responses — that teach the model what a good response looks like, exactly matching the input-output pair structure of supervised learning',
          'Fine-tuning does not involve any training data at all',
          'Supervised learning has no relevance to LLM engineering'
        ],
        correctIndex: 1,
        explanation:
            'Instruction fine-tuning trains on labeled pairs of (instruction, ideal response) — structurally identical to the input-output pairs used in any supervised learning task, just applied to a pretrained language model.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A company wants to automatically group thousands of unlabeled customer support tickets into natural topic categories, without knowing the categories in advance. Which approach fits best?',
        options: [
          'Supervised learning, since it always produces more accurate results',
          'Unsupervised learning, since the goal is to discover natural groupings in the data without any predefined labels or categories',
          'Neither approach can handle this kind of problem',
          'This problem requires manually labeling every ticket first, making the algorithm irrelevant'
        ],
        correctIndex: 1,
        explanation:
            'Discovering natural groupings in unlabeled data — with no predefined categories — is a classic unsupervised learning task (specifically, clustering), exactly matching the scenario described.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Supervised vs Unsupervised Task Classifier',
      goal:
          'Build fluency distinguishing supervised from unsupervised learning scenarios, including how LLM training itself fits into this framework.',
      steps: [
        'List 6 real-world ML tasks (e.g., spam detection, customer segmentation, house price prediction, topic discovery in documents, image classification, anomaly detection)',
        'For each task, classify it as Supervised or Unsupervised, with one sentence justifying why',
        'Explain in 2-3 sentences why LLM instruction fine-tuning (Level 7) is considered supervised learning',
        'Explain in 2-3 sentences why LLM pretraining (Level 6-7) is considered self-supervised (a close cousin of unsupervised learning)',
        'Write one sentence identifying which category feels more intuitive to you right now, and why',
      ],
      expectedOutput:
          '6 tasks correctly classified with clear justifications. Clear explanations of why LLM fine-tuning is supervised and why LLM pretraining is self-supervised, directly connecting this lesson to Levels 6-7.',
      xpReward: 45,
    ),
  ),
  TopicCourse(
    id: 'regression_classification_l3',
    topicTitle: 'Regression and Classification',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '📈',
    intro:
        'Regression and classification are the two fundamental supervised learning task types — and understanding them clearly here means the softmax output layer of every LLM in Level 6 will make immediate sense: next-token prediction is, at its core, a giant classification problem.',
    concepts: [
      ConceptLesson(
        title: 'Regression: Predicting a Continuous Number',
        definition:
            'Regression tasks predict a continuous numeric value (like a price, temperature, or score) — the output can take any value along a continuous range, and the model is evaluated by how close its numeric predictions are to the true values.',
        analogy:
            'Regression is like estimating someone\'s exact height from a photo — the answer is a continuous number (could be 5.6 ft, 5.61 ft, 5.615 ft...) and "close enough" predictions (5.58 ft when the true answer is 5.6 ft) are still considered reasonably good.',
        example:
            'Predicting a house\'s sale price from its size, location, and number of rooms is a regression task — the model outputs a specific number like ₹52,30,000, and its quality is measured by how close this is to the actual sale price.',
        keyTakeaway:
            'Regression will reappear directly when you evaluate certain LLM scoring tasks (predicting a continuous quality score, for example) — the underlying "predict a number, measure the error" framework is exactly the same one built in this lesson.',
        codeSnippet:
            'from sklearn.linear_model import LinearRegression\nimport numpy as np\n\nX = np.array([[500], [800], [1200], [1500]])   # house size (sqft)\ny = np.array([25, 40, 58, 72])                  # price (lakhs)\n\nmodel = LinearRegression()\nmodel.fit(X, y)\nprint(model.predict([[1000]]))   # predicted price for a 1000 sqft house',
      ),
      ConceptLesson(
        title: 'Classification: Predicting a Category',
        definition:
            'Classification tasks predict which discrete category (class) an input belongs to — the output is one of a fixed, finite set of labels, and the model is typically evaluated by how often it picks the correct category.',
        analogy:
            'Classification is like sorting mail into a fixed set of mailboxes labeled "Bills," "Personal," and "Junk" — every piece of mail must go into exactly one of these predefined boxes, unlike regression\'s continuous number line.',
        example:
            'Classifying an email as "spam" or "not spam" is a classification task with 2 classes (binary classification). Classifying a news article into "Sports," "Politics," "Technology," or "Entertainment" is classification with 4 classes (multi-class classification).',
        keyTakeaway:
            'This is the direct conceptual bridge to Level 6\'s transformers: predicting the next token is EXACTLY a classification problem, where the "classes" are every word in the model\'s vocabulary (tens of thousands of possible classes) — the softmax function you will meet in Level 6 is what turns a classification model\'s raw scores into the probability distribution you explored back in Level 2.',
        codeSnippet:
            'from sklearn.linear_model import LogisticRegression\nimport numpy as np\n\nX = np.array([[1], [5], [10], [15]])   # number of suspicious keywords\ny = np.array([0, 0, 1, 1])              # 0 = not spam, 1 = spam\n\nmodel = LogisticRegression()\nmodel.fit(X, y)\nprint(model.predict([[8]]))   # predicted class: 0 or 1',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the key difference between a regression task and a classification task?',
        options: [
          'Regression always uses more data than classification',
          'Regression predicts a continuous numeric value, while classification predicts which discrete category (from a fixed set) an input belongs to',
          'Classification can only ever have exactly 2 possible outcomes',
          'There is no real difference between regression and classification'
        ],
        correctIndex: 1,
        explanation:
            'The core distinction is the type of output: regression outputs a continuous number along a range, while classification outputs one of a fixed, discrete set of category labels.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is predicting an LLM\'s next token fundamentally a classification problem?',
        options: [
          'It is actually a regression problem, since tokens are represented as numbers',
          'The model must choose one specific token from a fixed, finite vocabulary (a discrete set of possible "classes") — exactly matching the structure of a classification task, just with a very large number of classes',
          'Next-token prediction has no relationship to either regression or classification',
          'Classification only applies to image data, never text'
        ],
        correctIndex: 1,
        explanation:
            'Choosing the next token from a fixed vocabulary is structurally identical to classification — selecting one class from a finite, predefined set of options — just with tens of thousands of possible "classes" (vocabulary words) instead of a handful.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A model needs to predict how many days it will take for a package to be delivered. Is this a regression or classification task?',
        options: [
          'Classification, since delivery involves discrete steps',
          'Regression, since the output is a continuous or countable numeric value (number of days) along a range, not a selection from fixed categories',
          'This cannot be solved with either approach',
          'It depends entirely on which programming language is used'
        ],
        correctIndex: 1,
        explanation:
            'Predicting a numeric quantity like "number of days" is a regression task — the output is a number along a continuous/countable range, evaluated by how close the prediction is to the true value, not by matching a fixed category.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build Your First Regression and Classification Models',
      goal:
          'Train one simple regression model and one simple classification model using scikit-learn, building hands-on intuition for both task types before Level 4\'s deep learning content.',
      steps: [
        'Create a small simulated regression dataset: X = years of experience, y = salary (at least 6 data points)',
        'Train a LinearRegression model on this data and predict the salary for 1 new years-of-experience value',
        'Create a small simulated classification dataset: X = hours studied, y = pass/fail (0 or 1) (at least 6 data points)',
        'Train a LogisticRegression model on this data and predict the pass/fail outcome for 1 new hours-studied value',
        'Write 2-3 sentences comparing the two models\' outputs: one is a continuous number, the other is a discrete category — confirm you can explain why each task type fits its respective model',
      ],
      expectedOutput:
          'Regression - Predicted salary for 6 years experience: ₹8.2 LPA\nClassification - Predicted outcome for 4 hours studied: 0 (Fail)\n\nReflection: The regression model output a continuous number, while the classification model selected a discrete class...',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'model_evaluation_metrics_l3',
    topicTitle: 'Model Evaluation Metrics',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '📏',
    intro:
        'A model that "seems to work" is not the same as a model with proven, measured performance. This lesson builds the evaluation vocabulary — accuracy, precision, recall, F1 — that you will reuse constantly when judging LLM outputs and fine-tuned models in later levels.',
    concepts: [
      ConceptLesson(
        title: 'Accuracy and Its Hidden Trap',
        definition:
            'Accuracy is the simplest classification metric: the percentage of predictions the model got correct — but accuracy can be dangerously misleading when classes are imbalanced (one class is much more common than another), directly echoing Level 2\'s Bayes\' Theorem lesson.',
        analogy:
            'Accuracy alone is like judging a weather forecaster purely by "percentage of days correctly predicted" in a desert where it almost never rains — a forecaster who always predicts "no rain" would score a misleadingly high accuracy, despite providing zero useful information about the rare days it actually does rain.',
        example:
            'If 95% of transactions are legitimate and only 5% are fraudulent, a model that predicts "not fraud" for EVERY transaction achieves 95% accuracy — while being completely useless at its actual job of catching fraud.',
        keyTakeaway:
            'Never trust accuracy alone, especially on imbalanced data — this directly connects back to Level 2\'s Bayes\' Theorem lesson, where the same base-rate trap was explored from a probability angle.',
      ),
      ConceptLesson(
        title: 'Precision, Recall, and F1-Score',
        definition:
            'Precision measures: of everything the model flagged as positive, how many were actually positive? Recall measures: of everything that was actually positive, how many did the model successfully catch? F1-score combines both into a single balanced number — each metric matters differently depending on the cost of different types of mistakes.',
        analogy:
            'Precision and recall are like a fishing net\'s two different qualities. Precision asks: "of everything the net caught, how much was actually fish (not seaweed)?" Recall asks: "of all the fish in the lake, how many did the net actually catch?" A net that only catches 1 guaranteed fish has perfect precision but terrible recall; a net that catches everything in the lake has perfect recall but terrible precision.',
        example:
            'A cancer-screening model: HIGH RECALL matters most (catch every possible cancer case, even with some false alarms, since missing a real case is far more costly). A spam filter: HIGH PRECISION matters most (avoid ever flagging a legitimate important email as spam, even if a few spam emails slip through).',
        keyTakeaway:
            'When you evaluate LLM-based classification systems (content moderation, fraud detection, RAG relevance filtering in Level 8) later in this roadmap, you will choose between prioritizing precision or recall based on which type of mistake is more costly for that specific application — exactly the judgment this lesson builds.',
        codeSnippet:
            'from sklearn.metrics import precision_score, recall_score, f1_score\n\ny_true = [1, 0, 1, 1, 0, 1]\ny_pred = [1, 0, 0, 1, 0, 1]\n\nprint("Precision:", precision_score(y_true, y_pred))\nprint("Recall:", recall_score(y_true, y_pred))\nprint("F1:", f1_score(y_true, y_pred))',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why can accuracy alone be a misleading metric for an imbalanced dataset (e.g., 95% legitimate transactions, 5% fraud)?',
        options: [
          'Accuracy is never a useful metric under any circumstances',
          'A model that always predicts the majority class (e.g., always "not fraud") can achieve a high accuracy score while being completely useless at correctly identifying the minority class it is actually meant to detect',
          'Accuracy can only be computed for regression tasks, not classification',
          'Imbalanced datasets always produce low accuracy scores, never high ones'
        ],
        correctIndex: 1,
        explanation:
            'On imbalanced data, always predicting the majority class inflates accuracy while providing zero real detection value for the minority class — exactly the same base-rate trap explored through Bayes\' Theorem in Level 2.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'For a cancer-screening model, why would recall typically be prioritized over precision?',
        options: [
          'Precision is always more important than recall for every possible task',
          'Missing an actual cancer case (a false negative, which lowers recall) is far more costly than a false alarm requiring further testing (which lowers precision) — so recall is prioritized to catch as many real cases as possible',
          'Recall and precision are always exactly equally important in every scenario',
          'Cancer screening models do not require any evaluation metrics'
        ],
        correctIndex: 1,
        explanation:
            'The relative cost of different mistake types determines which metric to prioritize — for cancer screening, missing a real case is far costlier than a false alarm, so recall (catching all real cases) is prioritized over precision.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A spam filter has HIGH precision but LOW recall. What does this specifically mean about its behavior?',
        options: [
          'It flags almost every email as spam, including many legitimate ones',
          'When it DOES flag something as spam, it is almost always correct (high precision), but it misses a lot of actual spam emails that slip through undetected (low recall)',
          'It never makes any mistakes of any kind',
          'High precision and low recall is not a possible combination'
        ],
        correctIndex: 1,
        explanation:
            'High precision means its positive predictions are trustworthy (rarely wrong when it says "spam"), while low recall means it is missing many actual spam emails — a cautious filter that avoids false alarms at the cost of letting some spam through.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build a Complete Model Evaluation Report',
      goal:
          'Practice computing and interpreting the full set of classification metrics on a simulated model\'s predictions, building the evaluation fluency needed throughout this entire roadmap.',
      steps: [
        'Create two lists: y_true (actual labels, at least 15 values, imbalanced with more 0s than 1s) and y_pred (a simulated model\'s predictions with some mistakes)',
        'Compute and print accuracy, precision, recall, and F1-score using scikit-learn\'s metrics functions',
        'Write a function explain_metrics(precision, recall) that returns a plain-language interpretation (e.g., "This model is cautious - when it predicts positive, it is usually right, but it misses some real positives")',
        'Simulate a SECOND set of predictions with different error patterns (more false positives instead of false negatives) and compute its metrics for comparison',
        'Write 2-3 sentences recommending which of the two simulated models would be better for a fraud-detection use case, and why, based on the metrics',
      ],
      expectedOutput:
          'Model A - Accuracy: 0.80, Precision: 0.90, Recall: 0.60, F1: 0.72\nModel B - Accuracy: 0.80, Precision: 0.65, Recall: 0.90, F1: 0.76\n\nRecommendation: For fraud detection, Model B\'s higher recall makes it better suited, since missing fraud cases is more costly than false alarms...',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'train_test_split_cross_validation_l3',
    topicTitle: 'Train/Test Split and Cross-Validation',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '✂️',
    intro:
        'How do you honestly know if a model actually works, rather than just having memorized its training data? This lesson builds the evaluation discipline you will apply when validating every fine-tuned LLM and RAG system in Levels 7-9.',
    concepts: [
      ConceptLesson(
        title: 'Why You Must Never Evaluate on Training Data',
        definition:
            'Train/test splitting divides your dataset into a training set (used to fit the model) and a separate, untouched test set (used only to evaluate final performance) — evaluating on the same data a model was trained on gives a falsely optimistic, meaningless performance estimate.',
        analogy:
            'Evaluating a model on its own training data is like grading a student\'s exam using the EXACT SAME questions they were given the answer key for during study sessions — of course they will score perfectly; that tells you nothing about whether they actually learned the material or would perform well on new, unseen questions.',
        example:
            'A model trained and tested on the identical 1000 examples might show 99% accuracy — but when deployed on genuinely new data, its real performance could drop to 60%, because it had simply memorized the specific training examples rather than learning generalizable patterns.',
        keyTakeaway:
            'This exact discipline — never trust performance measured on data the model has already seen — is directly why Level 7\'s LLM fine-tuning and Level 9\'s production monitoring both emphasize evaluating on genuinely held-out data before trusting any reported performance number.',
        codeSnippet:
            'from sklearn.model_selection import train_test_split\n\nX_train, X_test, y_train, y_test = train_test_split(\n    X, y, test_size=0.2, random_state=42\n)\n# Train only on X_train/y_train, evaluate only on X_test/y_test',
      ),
      ConceptLesson(
        title: 'Cross-Validation: A More Robust Evaluation',
        definition:
            'Cross-validation splits the data into multiple folds, training and testing the model multiple times with different folds held out each time, then averages the results — giving a more reliable performance estimate than a single train/test split, especially with smaller datasets.',
        analogy:
            'Cross-validation is like giving a student 5 different practice exams (instead of just 1) covering the same material, then averaging their scores across all 5 — this gives a far more reliable picture of their true understanding than trusting the result of a single lucky (or unlucky) exam.',
        example:
            'In 5-fold cross-validation, the data is split into 5 equal parts. The model trains on 4 parts and tests on the 5th, repeating this 5 times so every part gets used as the test set exactly once — the final reported score is the average across all 5 runs.',
        keyTakeaway:
            'Cross-validation is especially valuable when you have limited data (a common situation when fine-tuning LLMs on a small, domain-specific dataset in Level 7) — it squeezes a more trustworthy performance estimate out of data that would otherwise only support one single, potentially unlucky evaluation.',
        codeSnippet:
            'from sklearn.model_selection import cross_val_score\nfrom sklearn.linear_model import LogisticRegression\n\nmodel = LogisticRegression()\nscores = cross_val_score(model, X, y, cv=5)\nprint(scores)\nprint(f"Average accuracy: {scores.mean():.2f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why is it considered a serious mistake to evaluate a model\'s performance on the exact same data it was trained on?',
        options: [
          'It is not actually a mistake — this is the correct and standard way to evaluate models',
          'It gives a falsely optimistic performance estimate, since the model may have simply memorized the training examples rather than learning patterns that generalize to new, unseen data',
          'Training and testing on the same data always produces a very low, unfairly pessimistic score',
          'This practice is only a problem for regression tasks, never classification'
        ],
        correctIndex: 1,
        explanation:
            'A model can score deceptively well on data it has already memorized during training — the entire point of a held-out test set is to measure genuine generalization to new, unseen data, which training-data evaluation cannot reveal.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the main advantage of cross-validation over a single train/test split?',
        options: [
          'Cross-validation always trains the model much faster',
          'By training and testing multiple times on different data folds and averaging the results, cross-validation gives a more reliable performance estimate than relying on just one, potentially lucky or unlucky, single split',
          'Cross-validation eliminates the need for any test data at all',
          'There is no meaningful advantage to using cross-validation'
        ],
        correctIndex: 1,
        explanation:
            'Averaging performance across multiple different train/test splits reduces the risk that your evaluation result was just a lucky or unlucky artifact of one particular split, giving a more robust and trustworthy performance estimate.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A colleague reports "our model achieves 99.8% accuracy!" but mentions they evaluated it on the same data used for training. What is the appropriate reaction?',
        options: [
          'Celebrate immediately — 99.8% is an excellent, trustworthy result',
          'Be skeptical of this number, since evaluating on training data can produce a falsely optimistic score that does not reflect real-world performance on new, unseen data — ask for results on a proper held-out test set',
          'This evaluation methodology is completely standard and requires no further scrutiny',
          'The reported number must be a typo, since 99.8% accuracy is never achievable'
        ],
        correctIndex: 1,
        explanation:
            'A high accuracy score reported on training data alone should be treated with skepticism — the only trustworthy way to assess real-world performance is evaluation on genuinely held-out data the model never saw during training.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Proper Train/Test Evaluation Workflow',
      goal:
          'Practice the complete, correct evaluation workflow — train/test split plus cross-validation — building the exact evaluation discipline needed for validating fine-tuned models in Level 7.',
      steps: [
        'Create a simulated classification dataset with at least 30 samples (X features, y labels)',
        'Split the data using train_test_split with test_size=0.2',
        'Train a simple model (e.g., LogisticRegression) on the training set only',
        'Evaluate accuracy on BOTH the training set and the test set, printing both numbers',
        'Run 5-fold cross-validation on the full dataset and print the average cross-validation score',
        'Write 2-3 sentences comparing the training accuracy, test accuracy, and cross-validation average — flag if training accuracy is suspiciously much higher than test accuracy (a sign of overfitting, covered next lesson)',
      ],
      expectedOutput:
          'Training accuracy: 0.96\nTest accuracy: 0.83\nCross-validation scores: [0.80 0.85 0.78 0.82 0.84]\nAverage CV accuracy: 0.82\n\nReflection: Training accuracy is notably higher than test/CV accuracy, a possible early sign of overfitting...',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'overfitting_regularization_l3',
    topicTitle: 'Overfitting and Regularization',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '⚠️',
    intro:
        'Overfitting is the single most common failure mode in machine learning — and it will follow you directly into Level 4\'s deep learning and Level 7\'s LLM fine-tuning. This lesson builds a deep, intuitive understanding of what it is, how to spot it, and how to fix it.',
    concepts: [
      ConceptLesson(
        title: 'What Overfitting Actually Is',
        definition:
            'Overfitting occurs when a model learns the training data TOO well — including its noise and random quirks — resulting in excellent training performance but poor performance on new, unseen data, because the model failed to learn genuinely generalizable patterns.',
        analogy:
            'Overfitting is like a student who memorizes the exact wording and answers of every practice question instead of understanding the underlying concepts — they ace the practice test perfectly (training performance) but fail the real exam, which asks the same concepts in slightly different wording (test performance).',
        example:
            'A model predicting house prices that achieves 99.9% accuracy on training data but only 60% on new data has likely memorized specific quirks of the training houses (this exact house had a red door and sold for X) rather than learning the genuine relationship between size, location, and price.',
        keyTakeaway:
            'The gap between training performance and test performance (Level 3\'s previous lesson) is your primary diagnostic tool for detecting overfitting — a large gap is the clearest warning sign, and you will watch for this exact pattern when fine-tuning LLMs in Level 7.',
      ),
      ConceptLesson(
        title: 'Regularization: Techniques to Prevent Overfitting',
        definition:
            'Regularization techniques deliberately constrain a model during training to prevent it from fitting the training data too precisely — common techniques include L1/L2 regularization (penalizing overly large model weights) and, in deep learning specifically, dropout (randomly disabling parts of the network during training).',
        analogy:
            'Regularization is like deliberately handicapping a student\'s study process in a way that forces genuine understanding — for example, requiring them to explain concepts in their own words rather than memorizing exact textbook phrasing. This "constraint" during learning produces someone who can actually apply the knowledge flexibly to new situations, rather than merely reciting memorized answers.',
        example:
            'L2 regularization adds a penalty to the loss function based on the size of the model\'s weights, discouraging the model from relying too heavily on any single feature. This gentle "pressure" toward simpler, more balanced solutions often generalizes better to new data than an unconstrained model that can fit training data perfectly.',
        keyTakeaway:
            'You will meet regularization again directly in Level 4 (dropout in neural networks) and indirectly in Level 7 (fine-tuning techniques that prevent a model from "forgetting" its general pretrained knowledge while learning a specific task) — the underlying goal, preventing over-specialization to the training data, is identical throughout.',
        codeSnippet:
            'from sklearn.linear_model import LogisticRegression\n\n# Higher C = less regularization (more prone to overfitting)\n# Lower C = more regularization (more constrained, often better generalization)\nmodel_low_reg = LogisticRegression(C=100)\nmodel_high_reg = LogisticRegression(C=0.01)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the clearest warning sign that a model may be overfitting?',
        options: [
          'The model trains very quickly',
          'A large gap between high training performance and much lower test/validation performance — indicating the model learned training-specific quirks rather than genuinely generalizable patterns',
          'The model has a very small number of parameters',
          'Overfitting cannot be detected through any performance metrics'
        ],
        correctIndex: 1,
        explanation:
            'A significant gap between strong training performance and weaker test performance is the classic overfitting signature — the model performs well on data it has memorized but poorly on genuinely new data.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the general purpose of regularization techniques like L2 regularization or dropout?',
        options: [
          'To make the model train as fast as possible, with no other goal',
          'To deliberately constrain the model during training so it does not fit the training data too precisely, encouraging it to learn genuinely generalizable patterns instead of memorized quirks',
          'To increase the model\'s training accuracy as much as possible, regardless of test performance',
          'Regularization techniques have no real effect on model behavior'
        ],
        correctIndex: 1,
        explanation:
            'Regularization deliberately makes training slightly "harder" in a way that discourages over-fitting to training-specific noise, generally improving how well the model generalizes to new, unseen data.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A model shows 98% training accuracy but only 65% test accuracy. What is the most likely diagnosis and a reasonable next step?',
        options: [
          'The model is performing excellently and needs no changes',
          'This is a classic overfitting pattern — reasonable next steps include applying regularization, simplifying the model, or gathering more diverse training data',
          'The test data must be incorrect, since training accuracy is what matters most',
          'This pattern indicates the model needs to be trained for even longer with no other changes'
        ],
        correctIndex: 1,
        explanation:
            'The large gap between training and test accuracy is a textbook overfitting signature — applying regularization, simplifying the model, or adding more diverse training data are all standard, reasonable responses.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Diagnose and Fix Overfitting',
      goal:
          'Deliberately create an overfit model, diagnose it using the training/test gap, and fix it using regularization — building hands-on intuition for a problem you will encounter constantly in Levels 4 and 7.',
      steps: [
        'Create a small simulated dataset (X, y) for classification with around 30 samples, and split into train/test sets',
        'Train a LogisticRegression model with very low regularization (high C value like C=1000) and print both training and test accuracy',
        'Train a second LogisticRegression model with strong regularization (low C value like C=0.01) and print both training and test accuracy',
        'Compare the training-test accuracy GAP for both models',
        'Write 2-3 sentences explaining which model likely generalizes better to new, real-world data, and why, based on the gap you observed',
      ],
      expectedOutput:
          'Low regularization (C=1000) - Train: 0.97, Test: 0.68 (gap: 0.29)\nHigh regularization (C=0.01) - Train: 0.85, Test: 0.80 (gap: 0.05)\n\nReflection: The high-regularization model has a much smaller train-test gap, suggesting it generalizes better despite slightly lower training accuracy...',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'feature_engineering_l3',
    topicTitle: 'Feature Engineering',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '🛠️',
    intro:
        'The features you feed a model often matter more than the algorithm you choose. This lesson builds the "what makes good input data" intuition that directly carries over into how you will design prompts (Level 7) and chunk documents for retrieval (Level 8).',
    concepts: [
      ConceptLesson(
        title: 'What is a Feature, and Why Engineering It Matters',
        definition:
            'A feature is an individual measurable input variable a model uses to make predictions. Feature engineering is the process of creating, transforming, or selecting the most informative features from raw data — often having a bigger impact on model performance than the choice of algorithm itself.',
        analogy:
            'Feature engineering is like a doctor deciding which specific measurements to take before diagnosing a patient — raw, unprocessed information (a patient just standing in the room) is far less useful than deliberately extracted, meaningful measurements (blood pressure, temperature, specific symptoms). Good feature engineering is choosing and shaping the RIGHT measurements.',
        example:
            'Raw data: a timestamp like "2024-03-15 14:30:00". Engineered features from that single raw value: hour_of_day (14), day_of_week (Friday), is_weekend (False), is_business_hours (True) — each engineered feature may reveal a pattern the raw timestamp alone would hide from a simple model.',
        keyTakeaway:
            'This exact instinct — raw data is rarely in its most useful form, and thoughtful transformation reveals hidden patterns — is precisely the mindset you will need for prompt engineering (Level 7) and document chunking strategy (Level 8), where how you shape and present information to a model dramatically affects its output quality.',
      ),
      ConceptLesson(
        title: 'Common Feature Engineering Techniques',
        definition:
            'Common techniques include: encoding categorical variables into numbers (one-hot encoding), scaling numeric features to comparable ranges, creating interaction features (combining two features into a new one), and extracting components from complex data (like date parts from a timestamp).',
        analogy:
            'Feature engineering techniques are like a translator preparing information for an audience that only understands numbers — categorical labels like "red," "blue," "green" must be translated into a numeric form (one-hot encoding) the model can actually process, just as a spoken idiom needs careful translation to make sense in another language.',
        example:
            'One-hot encoding "color" (red/blue/green) creates 3 new binary columns: is_red, is_blue, is_green — where exactly one column is 1 and the rest are 0 for each row, letting a model that only understands numbers still use categorical information effectively.',
        keyTakeaway:
            'While LLMs handle raw text directly (unlike classical ML models, which need numeric features), the underlying engineering mindset — asking "what transformation of this raw input would make the pattern easier for a model to learn?" — remains valuable throughout your entire LLM engineering career, especially in Level 8\'s RAG chunking decisions.',
        codeSnippet:
            'import pandas as pd\n\ndf = pd.DataFrame({"color": ["red", "blue", "green", "red"]})\nencoded = pd.get_dummies(df["color"])\nprint(encoded)\n#    blue  green  red\n# 0  False False True\n# 1  True  False False\n# ...',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why can feature engineering sometimes have a bigger impact on model performance than the choice of algorithm itself?',
        options: [
          'Feature engineering has no real impact on model performance',
          'Well-engineered features present the underlying patterns in the data more clearly and usefully, making it much easier for even a simple model to learn effectively, while poorly-shaped raw features can hide patterns from even a powerful algorithm',
          'Algorithms never actually use the features provided to them',
          'Feature engineering is only relevant for deep learning, never classical ML'
        ],
        correctIndex: 1,
        explanation:
            'The quality and shape of input features directly determines how easily any model — simple or sophisticated — can learn the underlying patterns; well-engineered features can make a simple model outperform a complex one trained on poorly-shaped raw data.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does one-hot encoding accomplish when working with categorical data like "color" (red/blue/green)?',
        options: [
          'It deletes the categorical column entirely',
          'It converts each category into a separate binary (0/1) column, translating non-numeric category labels into a numeric form that models can process',
          'It randomly reassigns the color values',
          'One-hot encoding only works on numeric data, not categories'
        ],
        correctIndex: 1,
        explanation:
            'One-hot encoding creates a separate binary column for each category value, translating categorical labels into the numeric format required by most machine learning models.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You have a raw "purchase_timestamp" column. Which engineered feature would likely be MOST useful for predicting whether a purchase was made during a promotional weekend sale?',
        options: [
          'The exact millisecond of the timestamp',
          'An "is_weekend" boolean feature extracted from the timestamp',
          'Converting the timestamp to a random number',
          'Deleting the timestamp column entirely with no replacement'
        ],
        correctIndex: 1,
        explanation:
            'Extracting an "is_weekend" feature directly captures the specific pattern relevant to the prediction task (weekend sales), making the useful signal far easier for a model to learn than the raw, unprocessed timestamp.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Feature Engineering Practice on a Simulated Dataset',
      goal:
          'Practice transforming raw data into more useful engineered features, building the "reshape data for the model\'s benefit" mindset needed for prompt design and RAG chunking later in this roadmap.',
      steps: [
        'Create a Pandas DataFrame with a raw "signup_timestamp" column (use pd.to_datetime with several sample dates/times) and a "plan_type" categorical column (e.g., "free", "pro", "enterprise")',
        'Engineer 3 new features from the timestamp: hour_of_day, day_of_week, and is_weekend',
        'One-hot encode the "plan_type" column using pd.get_dummies()',
        'Print the final DataFrame showing all original and engineered columns',
        'Write 2-3 sentences explaining which of your engineered features you believe would be most useful for predicting "will this user upgrade their plan," and why',
      ],
      expectedOutput:
          'Original + engineered columns:\nsignup_timestamp | hour_of_day | day_of_week | is_weekend | plan_free | plan_pro | plan_enterprise\n2024-03-15 14:30  | 14          | Friday      | False      | 0         | 1        | 0\n...\n\nReflection: is_weekend and plan_type encoding likely carry the strongest signal for upgrade prediction...',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'decision_trees_ensembles_l3',
    topicTitle: 'Decision Trees and Ensemble Methods',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🌳',
    intro:
        'Decision trees and their ensemble variants (Random Forests, Gradient Boosting) remain some of the most practical, widely-used ML models in industry — and understanding them builds real intuition for model complexity and combining multiple weaker models, ideas that echo throughout deep learning and even multi-agent LLM systems in Level 9.',
    concepts: [
      ConceptLesson(
        title: 'Decision Trees: Learning Through a Series of Questions',
        definition:
            'A decision tree makes predictions by asking a sequence of simple yes/no questions about the input features, branching deeper based on the answers, until it reaches a final prediction at a "leaf" node — the entire tree is learned automatically from training data.',
        analogy:
            'A decision tree is like a doctor\'s diagnostic flowchart — "Is temperature above 100°F? If yes, is there a cough? If yes, check for other flu symptoms..." — each answer narrows down the possibilities until reaching a specific diagnosis, exactly mirroring how a decision tree narrows down to a final prediction.',
        example:
            'A loan-approval decision tree might ask: "Is income > ₹5 lakh?" → if yes, "Is credit score > 700?" → if yes, "Approve." Each branch represents a learned threshold that best splits the training data toward correct predictions.',
        keyTakeaway:
            'Decision trees are highly interpretable — you can literally read the sequence of questions that led to any prediction, which is valuable in regulated industries. However, a single deep tree easily overfits (Level 3\'s earlier lesson), which is exactly the problem ensemble methods solve.',
      ),
      ConceptLesson(
        title: 'Ensembles: Combining Many Weak Models into One Strong One',
        definition:
            'Ensemble methods combine predictions from MANY individual models (often decision trees) to produce a single, more accurate and robust prediction — Random Forests average many independently-trained trees, while Gradient Boosting trains trees sequentially, each one correcting the previous trees\' mistakes.',
        analogy:
            'An ensemble is like asking 100 different doctors for their independent opinion on a diagnosis, then combining their opinions (majority vote or average) instead of trusting just one doctor. Even if each individual doctor makes occasional mistakes, the COMBINED opinion of many independent experts tends to be far more reliable than any single one.',
        example:
            'A Random Forest for credit risk trains 100 different decision trees, each on a slightly different random subset of the data and features. For a new applicant, all 100 trees vote, and the majority decision becomes the final prediction — much more robust than trusting any single tree\'s potentially overfit judgment.',
        keyTakeaway:
            'This "combine many models for a stronger result" principle reappears throughout your LLM Engineering career — in Level 9\'s multi-agent systems, where multiple specialized LLM agents collaborate on a task rather than relying on one single agent to handle everything, echoing exactly this ensemble intuition.',
        codeSnippet:
            'from sklearn.ensemble import RandomForestClassifier\nfrom sklearn.tree import DecisionTreeClassifier\n\nsingle_tree = DecisionTreeClassifier(max_depth=5)\nforest = RandomForestClassifier(n_estimators=100, max_depth=5)\n\n# forest typically generalizes better than a single tree\nforest.fit(X_train, y_train)\nprint(forest.score(X_test, y_test))',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is a key advantage of decision trees, particularly valuable in regulated industries like finance and healthcare?',
        options: [
          'Decision trees are always the most accurate model available for any task',
          'Decision trees are highly interpretable — the exact sequence of questions leading to any prediction can be directly read and explained, which is valuable where decisions need to be justified',
          'Decision trees never require any training data',
          'Decision trees are completely immune to overfitting'
        ],
        correctIndex: 1,
        explanation:
            'Decision trees offer strong interpretability — you can trace the exact sequence of decisions leading to any prediction — a valuable property in regulated contexts requiring explainable decisions, even though they can still overfit if not constrained.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the core principle behind ensemble methods like Random Forests?',
        options: [
          'Training exactly one, extremely large and complex model',
          'Combining predictions from many individual models (often trees), so that the aggregated result is typically more accurate and robust than trusting any single model alone',
          'Ensemble methods do not actually combine multiple models',
          'Random Forests only work when there is exactly one feature in the dataset'
        ],
        correctIndex: 1,
        explanation:
            'Ensemble methods aggregate predictions from many individual models — the combined judgment of many independently-trained models tends to be more robust and accurate than relying on any single model.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A single, very deep decision tree achieves 99% training accuracy but only 70% test accuracy. Based on this level\'s concepts, what is a reasonable fix?',
        options: [
          'Make the tree even deeper to further improve training accuracy',
          'Use an ensemble method like a Random Forest, or limit the tree\'s depth, both of which help prevent the overfitting suggested by this large train-test gap',
          'This performance gap indicates no problem exists and requires no action',
          'Decision trees can never be improved once trained'
        ],
        correctIndex: 1,
        explanation:
            'The large train-test gap signals overfitting (directly connecting to the earlier Level 3 lesson) — using an ensemble method or limiting tree depth are both standard, effective fixes for an overfit decision tree.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Compare a Single Tree vs an Ensemble',
      goal:
          'Directly compare a single decision tree against a Random Forest ensemble on the same dataset, building hands-on intuition for why ensembles generally generalize better.',
      steps: [
        'Create a simulated classification dataset with at least 40 samples and split into train/test sets',
        'Train a single DecisionTreeClassifier (with no depth limit) and record both training and test accuracy',
        'Train a RandomForestClassifier with 100 trees on the same data and record both training and test accuracy',
        'Compare the train-test accuracy gap for both models side by side',
        'Write 2-3 sentences explaining which model generalized better and connecting this result to the ensemble principle (combining many models reduces overfitting risk) from this lesson',
      ],
      expectedOutput:
          'Single Tree - Train: 1.00, Test: 0.71 (gap: 0.29)\nRandom Forest - Train: 0.98, Test: 0.85 (gap: 0.13)\n\nReflection: The Random Forest generalized notably better, consistent with the ensemble principle that combining many models reduces the risk of any single model\'s overfitting...',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'ml_project_workflow_l3',
    topicTitle: 'ML Project Workflow',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '🔄',
    intro:
        'This final Level 3 lesson ties every previous lesson in this level into one complete, repeatable workflow — the exact structure you will follow again, at a much larger scale, when fine-tuning and evaluating LLMs starting in Level 7.',
    concepts: [
      ConceptLesson(
        title: 'The Complete ML Workflow, End to End',
        definition:
            'A professional ML project follows a consistent sequence: define the problem, load and clean data (Pandas), engineer features, split into train/test sets, train a model, evaluate using appropriate metrics, diagnose issues like overfitting, and iterate — this exact sequence, in order, is what turns raw data into a genuinely useful model.',
        analogy:
            'This workflow is like a professional cooking process, not improvised cooking — define the dish (problem), gather and prep ingredients (data cleaning and feature engineering), portion into a "cooking batch" and a "tasting batch" (train/test split), cook (train), and taste-test rigorously before serving (evaluate) — skipping any step risks serving a dish that looks fine but tastes wrong.',
        example:
            'Building a customer churn predictor: define "churn" precisely (Level 3\'s ML foundations), load and clean the customer data (Pandas), engineer features like days_since_last_purchase, split into train/test, train a Random Forest, evaluate with precision/recall (since churn is likely imbalanced), and diagnose any overfitting by comparing train vs test performance.',
        keyTakeaway:
            'This is not just an abstract checklist — it is the SAME workflow you will run, at much larger scale, when preparing a dataset for LLM fine-tuning (Level 7): define the task, clean and format the data, split into train/validation, fine-tune, evaluate, and iterate.',
      ),
      ConceptLesson(
        title: 'Iteration: ML is Rarely a One-Shot Process',
        definition:
            'Real ML projects are iterative — the first model rarely performs well enough, and practitioners cycle back through earlier steps (better features, different algorithms, more regularization, more data) based on what evaluation reveals, rather than expecting success on the very first attempt.',
        analogy:
            'ML iteration is like a chef refining a new recipe through multiple test batches — the first attempt is rarely perfect, and each round of tasting (evaluation) reveals a specific adjustment needed (more seasoning, longer cooking time, a different ingredient) that guides the next attempt, rather than throwing out the whole recipe and starting from nothing.',
        example:
            'A first model might show poor recall on fraud detection. Instead of giving up, a practitioner might: engineer new features (transaction velocity), try a different algorithm (switch from logistic regression to gradient boosting), or address class imbalance directly — each a targeted iteration based on what the evaluation specifically revealed.',
        keyTakeaway:
            'Expect this same iterative mindset when fine-tuning LLMs in Level 7 and building RAG systems in Level 8 — the first version rarely works perfectly, and the professional skill is diagnosing WHAT specifically to improve based on evaluation results, not randomly changing things and hoping.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why does this lesson describe the ML workflow as directly foreshadowing the LLM fine-tuning process you will learn in Level 7?',
        options: [
          'There is no real connection between classical ML workflow and LLM fine-tuning',
          'LLM fine-tuning follows the exact same underlying sequence — define the task, clean and prepare data, split into train/validation sets, train, evaluate, and iterate — just applied to a much larger pretrained model',
          'LLM fine-tuning requires no data preparation or evaluation of any kind',
          'The ML workflow only applies to regression tasks, not to language models'
        ],
        correctIndex: 1,
        explanation:
            'LLM fine-tuning follows the identical structural workflow taught throughout this level — data preparation, train/validation splitting, training, and evaluation — just scaled up and applied to a pretrained language model instead of a classical ML algorithm.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is ML described as "rarely a one-shot process"?',
        options: [
          'The first trained model is always immediately perfect with no further changes needed',
          'Real ML projects typically require multiple iterations — cycling back to improve features, try different algorithms, or address issues revealed by evaluation — rather than succeeding on the very first attempt',
          'Iteration is a sign of failure and should always be avoided',
          'ML models never need to be retrained or adjusted once built'
        ],
        correctIndex: 1,
        explanation:
            'Professional ML work is inherently iterative — evaluation results guide specific, targeted improvements across multiple rounds, rather than expecting a single training attempt to produce a final, optimal model.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You just trained your first model for a new project and its recall is poor. Following this lesson\'s workflow mindset, what should you do next?',
        options: [
          'Immediately abandon the project, since the first attempt did not succeed',
          'Diagnose specifically WHY recall is poor (imbalanced data? missing important features? wrong algorithm?) and iterate with a targeted fix based on that diagnosis, rather than randomly changing settings',
          'Report the poor recall as the final result with no further investigation',
          'Retrain the exact same model with the exact same settings and hope for a different result'
        ],
        correctIndex: 1,
        explanation:
            'The professional iterative mindset requires diagnosing the SPECIFIC cause of poor performance (imbalance, features, algorithm choice) and making a targeted improvement — not giving up, reporting failure as final, or blindly repeating the same approach.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Level 3 Capstone: Complete End-to-End ML Project',
      goal:
          'Complete Level 3 by running a full, professional ML workflow from raw data through iteration — bringing together every lesson in this level into one cohesive project, directly foreshadowing Level 7\'s LLM fine-tuning workflow.',
      steps: [
        'Define a specific ML problem (e.g., "predict whether a customer will churn based on usage patterns") and create a small simulated dataset (Pandas DataFrame, at least 40 rows, with a mix of numeric and categorical features)',
        'Clean the data (handle any missing values, remove duplicates) and engineer at least 2 new features',
        'Split into train/test sets and train a baseline model (e.g., LogisticRegression)',
        'Evaluate using accuracy, precision, recall, and F1-score, and check for overfitting by comparing train vs test performance',
        'Iterate at least once: based on your evaluation results, make one specific, justified improvement (try a Random Forest instead, add regularization, or engineer an additional feature) and re-evaluate',
        'Write a final summary (5-6 sentences) walking through your complete workflow from problem definition to final iteration, explicitly connecting each step to the Level 3 lesson it came from',
      ],
      expectedOutput:
          '=== LEVEL 3 CAPSTONE: END-TO-END ML PROJECT ===\nProblem: Predict customer churn\nBaseline (Logistic Regression) - Test F1: 0.68\nIteration 1 (Random Forest) - Test F1: 0.79\n\nWorkflow summary: [5-6 sentences walking through problem definition, data cleaning, feature engineering, evaluation, and iteration]\n\n=== LEVEL 3 COMPLETE — MACHINE LEARNING FOUNDATIONS MASTERED ===\nLevel 4: Deep Learning Foundations begins next.',
      xpReward: 70,
    ),
  ),
];
