import '../../models/course_content_data.dart';

const List<TopicCourse> aiEngineerLevel5 = [
  TopicCourse(
    id: 'intro_to_machine_learning',
    topicTitle: 'Introduction to Machine Learning',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 150,
    emoji: '🤖',
    intro:
        'Welcome to Machine Learning — the technology behind Netflix recommendations, voice assistants, fraud detection, and self-driving cars. In this lesson you will understand exactly what ML is, why it exists, and how it fundamentally differs from traditional programming.',
    concepts: [
      ConceptLesson(
        title: 'What is Machine Learning?',
        definition:
            'Machine Learning is a field of AI where computers learn patterns from data and improve their performance on a task without being explicitly programmed with fixed rules.',
        analogy:
            'Traditional programming is like giving someone a strict recipe to follow step by step. Machine Learning is like teaching someone to cook by showing them thousands of meals until they learn the underlying technique themselves.',
        example:
            'Instead of writing thousands of if-else rules to detect spam emails, you show an ML model 50,000 labeled emails (spam/not spam) and it learns the patterns on its own.',
        keyTakeaway:
            'ML shifts the work from "writing rules" to "providing examples". The more relevant, quality data you provide, the better the model becomes at generalising to new situations.',
        codeSnippet:
            '# Traditional programming\ndef is_spam(email):\n    if "free money" in email:\n        return True\n    return False\n\n# Machine Learning approach (conceptual)\n# model.fit(emails, labels)  -> learns patterns\n# model.predict(new_email)   -> uses learned patterns',
      ),
      ConceptLesson(
        title: 'Machine Learning vs Traditional Programming',
        definition:
            'In traditional programming, you provide rules + data to get output. In Machine Learning, you provide data + output (examples) to get the rules (the model).',
        analogy:
            'Imagine trying to write rules that distinguish a photo of a cat from a dog — ear shape, whiskers, fur texture, pose — the rules would be endless and fragile. ML instead learns these rules automatically by examining thousands of labeled cat and dog photos.',
        example:
            'A traditional currency converter uses a fixed formula (rule). A traditional spam filter using keyword rules breaks easily when spammers change wording. An ML spam filter adapts because it learns underlying patterns, not just keywords.',
        keyTakeaway:
            'ML is the right tool when the rules are too complex, too numerous, or constantly changing to hand-code manually — image recognition, language understanding, and fraud detection are classic examples.',
      ),
      ConceptLesson(
        title: 'Why Machine Learning Matters in AI',
        definition:
            'Machine Learning is the foundation underneath almost every modern AI application — including deep learning, computer vision, and natural language processing (NLP) systems like ChatGPT.',
        analogy:
            'If Artificial Intelligence is the broad goal of "building intelligent systems", Machine Learning is the primary engine that powers most of today\'s practical progress toward that goal — much like the internal combustion engine powers most cars.',
        example:
            'Google Translate, YouTube\'s recommendation system, bank fraud alerts, medical diagnosis tools, and voice assistants like Siri all rely on machine learning models trained on massive datasets.',
        keyTakeaway:
            'Understanding ML fundamentals is non-negotiable for any AI engineer — even advanced deep learning systems are built directly on top of core ML concepts you will learn in this level.',
      ),
      ConceptLesson(
        title: 'The Machine Learning Workflow',
        definition:
            'A typical ML project follows a repeatable pipeline: collect data, prepare/clean it, choose a model, train it, evaluate it, and deploy it for real use.',
        analogy:
            'Building an ML model is like training an athlete: gather data (their performance history), prepare a training plan (clean and organise the data), practice with feedback (train the model), test their performance (evaluate), and finally send them to compete (deploy to production).',
        example:
            'Building a house price predictor: 1) Collect historical house sales data. 2) Clean missing values. 3) Choose a regression model. 4) Train it on past sales. 5) Evaluate accuracy on new houses. 6) Deploy it in a real estate app.',
        keyTakeaway:
            'Every ML project follows this same general workflow regardless of domain — memorising this pipeline gives you a mental map for any ML problem you will ever face.',
      ),
      ConceptLesson(
        title: 'What Can (and Can\'t) Machine Learning Do?',
        definition:
            'ML excels at finding patterns in large amounts of data to make predictions or decisions, but it cannot reason like a human, lacks true understanding, and is only as good as the data it learns from.',
        analogy:
            'An ML model is like an extremely well-practiced pattern-matcher with no common sense — like a chess grandmaster who has memorised millions of games but has never actually held a chess piece or understood why the rules exist.',
        example:
            'ML can predict which customers are likely to churn based on historical behavior, but it cannot explain WHY in a human, causal sense unless specifically designed to (explainable AI) — and it can be confidently wrong if trained on biased or insufficient data.',
        keyTakeaway:
            'Set realistic expectations: ML is a powerful pattern-recognition tool, not magic. "Garbage in, garbage out" — bad or biased data always produces bad or biased models.',
      ),
      ConceptLesson(
        title: 'Python: The Language of Machine Learning',
        definition:
            'Python is the dominant programming language for ML because of its simplicity and its rich ecosystem of libraries like NumPy, Pandas, and Scikit-learn.',
        analogy:
            'Python is to Machine Learning what English is to international business — not the only option, but the common language nearly every tool, tutorial, and team uses, making collaboration and learning dramatically easier.',
        example:
            'NumPy handles numerical computation, Pandas handles tabular data, Matplotlib/Seaborn handle visualization, and Scikit-learn provides ready-to-use ML algorithms — together forming the standard Python ML toolkit.',
        keyTakeaway:
            'Mastering this level means becoming comfortable with Python\'s ML ecosystem, especially Scikit-learn, which you will use to build your very first machine learning model by the end of this level.',
        codeSnippet:
            'import numpy as np\nimport pandas as pd\nfrom sklearn.linear_model import LinearRegression\n\nprint("Python ML stack ready: NumPy, Pandas, Scikit-learn")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the core difference between traditional programming and Machine Learning?',
        options: [
          'Traditional programming uses Python, ML uses Java',
          'Traditional programming requires rules + data to get output; ML uses data + output to learn the rules',
          'There is no real difference',
          'ML never uses any code'
        ],
        correctIndex: 1,
        explanation:
            'Traditional programming requires you to explicitly write the rules. Machine Learning flips this: you provide example data and outcomes, and the model learns the underlying rules itself.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is Python the dominant language for Machine Learning?',
        options: [
          'It is the only language that can run on computers',
          'It has a rich ecosystem of ML libraries (NumPy, Pandas, Scikit-learn) and simple, readable syntax',
          'It is the fastest language for all computations',
          'Machine Learning cannot be done in any other language'
        ],
        correctIndex: 1,
        explanation:
            'Python\'s simplicity combined with its mature ecosystem of specialized libraries makes it the standard choice for ML development across the industry.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does "garbage in, garbage out" mean in the context of Machine Learning?',
        options: [
          'ML models automatically clean bad data',
          'Poor quality or biased training data will produce poor quality or biased model results',
          'It refers to deleting old code',
          'It only applies to image data'
        ],
        correctIndex: 1,
        explanation:
            'ML models learn directly from the data they are given. If that data is flawed, incomplete, or biased, the resulting model will reflect and often amplify those same flaws.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A company wants to detect fraudulent credit card transactions. The patterns of fraud constantly change and are too complex for fixed rules. What approach is BEST suited here?',
        options: [
          'Hard-code thousands of if-else rules',
          'Use Machine Learning to learn fraud patterns directly from historical transaction data',
          'Manually review every single transaction',
          'Ignore fraud detection entirely'
        ],
        correctIndex: 1,
        explanation:
            'When patterns are complex, numerous, and constantly evolving, Machine Learning is far more practical than hand-coded rules, since it can adapt by learning from new data.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Which of the following best summarizes a typical Machine Learning workflow in correct order?',
        options: [
          'Deploy, train, collect data, evaluate',
          'Collect data, prepare data, train model, evaluate model, deploy model',
          'Evaluate model, collect data, deploy, train',
          'Train model, collect data, deploy, prepare data'
        ],
        correctIndex: 1,
        explanation:
            'The standard ML pipeline flows from data collection through preparation, training, evaluation, and finally deployment — skipping or reordering steps usually leads to unreliable models.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'ML Workflow Planner',
      goal:
          'Design a written ML workflow plan for a real-world prediction problem of your choice.',
      steps: [
        'Choose a real-world prediction problem (e.g. predicting house prices, predicting student grades, predicting weather)',
        'Describe what data you would collect and from where',
        'List 3 data cleaning/preparation steps you would perform',
        'State whether this is a regression or classification problem and why',
        'Describe how you would evaluate whether your model is successful',
        'Write a short paragraph on how you would deploy this model for real users',
      ],
      expectedOutput:
          'A complete written ML workflow plan covering data collection, preparation, model type justification, evaluation approach, and deployment strategy for the chosen problem.',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'types_of_machine_learning',
    topicTitle: 'Types of Machine Learning',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 150,
    emoji: '🧩',
    intro:
        'Not all Machine Learning works the same way. Understanding the three core types — Supervised, Unsupervised, and Reinforcement Learning — is essential before you can choose the right approach for any real-world AI problem.',
    concepts: [
      ConceptLesson(
        title: 'The Three Main Types of Machine Learning',
        definition:
            'Machine Learning is generally divided into three categories: Supervised Learning (learns from labeled data), Unsupervised Learning (finds patterns in unlabeled data), and Reinforcement Learning (learns through trial, error, and rewards).',
        analogy:
            'Supervised learning is like a student studying with an answer key. Unsupervised learning is like a detective grouping clues without knowing the final answer. Reinforcement learning is like training a dog with treats — it learns by trying actions and getting rewarded or punished.',
        example:
            'Supervised: predicting house prices from labeled past sales. Unsupervised: grouping customers into segments without predefined categories. Reinforcement: a game-playing AI that learns to win by playing millions of games.',
        keyTakeaway:
            'Choosing the correct TYPE of machine learning for your problem is the very first and most important decision in any ML project — it shapes every subsequent step.',
      ),
      ConceptLesson(
        title: 'Supervised Learning Overview',
        definition:
            'Supervised learning trains a model on labeled data, where each example has a known correct answer (the "label"), and the model learns to predict that label for new, unseen data.',
        analogy:
            'It is like a teacher giving a student practice problems WITH the correct answers attached, so the student can compare their guesses and learn to improve.',
        example:
            'Given historical emails labeled as "spam" or "not spam", a supervised model learns to classify new, unseen emails correctly.',
        keyTakeaway:
            'Supervised learning requires labeled data, which can be expensive to collect, but it generally produces the most accurate, directly useful predictions when labels are available.',
      ),
      ConceptLesson(
        title: 'Unsupervised Learning Overview',
        definition:
            'Unsupervised learning works with unlabeled data, finding hidden structures, patterns, or groupings without any predefined correct answers.',
        analogy:
            'It is like handing someone a huge pile of mixed photographs with no labels and asking them to sort the pile into meaningful groups based purely on visual similarity.',
        example:
            'An e-commerce company groups customers into clusters based on purchasing behavior without knowing in advance what those groups should be — useful for marketing segmentation.',
        keyTakeaway:
            'Unsupervised learning is powerful for exploration and discovering unknown patterns, but the results require human interpretation since there are no "correct" labels to validate against.',
      ),
      ConceptLesson(
        title: 'Reinforcement Learning Overview',
        definition:
            'Reinforcement learning trains an "agent" to make a sequence of decisions by rewarding good actions and penalizing bad ones, learning optimal behavior through trial and error.',
        analogy:
            'It is like training a pet: the pet (agent) tries different actions in its environment, gets a treat (reward) for good behavior or no treat for bad behavior, and gradually learns the best strategy to maximize treats over time.',
        example:
            'AlphaGo learned to play the board game Go at a superhuman level by playing millions of games against itself and being rewarded for winning moves.',
        keyTakeaway:
            'Reinforcement learning is ideal for sequential decision-making problems like robotics, game-playing, and autonomous systems, where actions affect future states and rewards.',
      ),
      ConceptLesson(
        title: 'Semi-Supervised & Self-Supervised Learning',
        definition:
            'Semi-supervised learning combines a small amount of labeled data with a large amount of unlabeled data. Self-supervised learning generates its own labels automatically from the structure of the data itself.',
        analogy:
            'Semi-supervised learning is like a teacher providing answers for only 10% of homework problems and letting students figure out patterns for the rest. Self-supervised learning is like a student creating their own practice questions and answers from a textbook they already have.',
        example:
            'Large language models like GPT are largely trained using self-supervised learning — predicting the next word in massive amounts of unlabeled text, generating their own training signal.',
        keyTakeaway:
            'These hybrid approaches have become extremely important in modern AI because labeled data is expensive, while unlabeled data (like raw internet text) is abundant.',
      ),
      ConceptLesson(
        title: 'Choosing the Right Type for Your Problem',
        definition:
            'The right ML type depends on your goal: do you have labeled outcomes to predict (supervised), are you exploring unknown patterns (unsupervised), or are you optimizing a sequence of decisions (reinforcement)?',
        analogy:
            'Choosing the ML type is like choosing the right tool from a toolbox — a hammer (supervised) for nails, a magnifying glass (unsupervised) for inspection, and a steering wheel (reinforcement) for navigating a changing path.',
        example:
            'Predicting whether a loan applicant will default → supervised. Grouping news articles by topic without predefined categories → unsupervised. Training a robot to walk → reinforcement learning.',
        keyTakeaway:
            'Always start by asking: "Do I have labeled outcomes?" If yes, lean supervised. If no, but I want structure, lean unsupervised. If the problem involves sequential actions and rewards, lean reinforcement.',
        codeSnippet:
            '# Conceptual decision guide\ndef choose_ml_type(has_labels, is_sequential_decision):\n    if is_sequential_decision:\n        return "Reinforcement Learning"\n    elif has_labels:\n        return "Supervised Learning"\n    else:\n        return "Unsupervised Learning"',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What distinguishes Supervised Learning from Unsupervised Learning?',
        options: [
          'Supervised learning never uses Python',
          'Supervised learning uses labeled data with known correct answers; unsupervised learning works with unlabeled data',
          'They are exactly the same technique',
          'Unsupervised learning is always more accurate'
        ],
        correctIndex: 1,
        explanation:
            'Supervised learning relies on labeled training examples, while unsupervised learning discovers patterns in data that has no predefined labels.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which type of Machine Learning is best suited for training a robot to walk through trial and error with rewards?',
        options: [
          'Supervised Learning',
          'Unsupervised Learning',
          'Reinforcement Learning',
          'None of these'
        ],
        correctIndex: 2,
        explanation:
            'Reinforcement Learning is specifically designed for sequential decision-making problems where an agent learns optimal actions through rewards and penalties.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why has self-supervised learning become important for training large language models?',
        options: [
          'It requires massive amounts of expensive human-labeled data',
          'It allows models to generate their own training labels from abundant unlabeled text data',
          'It only works on small datasets',
          'It is identical to reinforcement learning'
        ],
        correctIndex: 1,
        explanation:
            'Self-supervised learning lets models like GPT learn from vast amounts of raw, unlabeled text by predicting missing or next parts of the data, avoiding the need for expensive manual labeling.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A retail company wants to group their 100,000 customers into segments based on purchasing behavior, without knowing in advance what the segments should look like. Which ML type fits best?',
        options: [
          'Supervised Learning',
          'Unsupervised Learning',
          'Reinforcement Learning',
          'Self-Supervised Learning only'
        ],
        correctIndex: 1,
        explanation:
            'Since there are no predefined labels or categories for the customer segments, Unsupervised Learning (specifically clustering) is the right approach to discover natural groupings in the data.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You have a dataset of 10,000 medical X-ray images, each labeled by doctors as "healthy" or "diseased". You want to build a model that predicts this label for new X-rays. Which type of ML should you use?',
        options: [
          'Unsupervised Learning',
          'Reinforcement Learning',
          'Supervised Learning',
          'None of the above'
        ],
        correctIndex: 2,
        explanation:
            'Since the dataset already has correct labels for each example, this is a classic Supervised Learning classification problem.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'ML Type Classifier',
      goal:
          'Analyze 5 real-world AI scenarios and correctly classify which type of machine learning each requires, with justification.',
      steps: [
        'Write down 5 different real-world AI use cases (e.g. movie recommendations, self-driving car navigation, email spam detection, customer segmentation, game-playing AI)',
        'For each scenario, identify whether it requires Supervised, Unsupervised, or Reinforcement Learning',
        'Write a 2-3 sentence justification for each classification',
        'Identify which scenario could potentially use a hybrid approach (e.g. semi-supervised) and explain why',
        'Summarize your findings in a short table format',
      ],
      expectedOutput:
          'A table of 5 AI scenarios, each correctly classified by ML type with clear justification, plus one identified hybrid-approach scenario.',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'supervised_learning',
    topicTitle: 'Supervised Learning',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 35,
    totalXp: 160,
    emoji: '🎓',
    intro:
        'Supervised Learning is the most widely used and commercially successful branch of Machine Learning. From predicting house prices to diagnosing diseases, this lesson dives deep into how models learn from labeled examples to make accurate predictions.',
    concepts: [
      ConceptLesson(
        title: 'How Supervised Learning Works',
        definition:
            'Supervised learning trains a model on input-output pairs (features and labels), allowing it to learn a mapping function that can predict the output for new, unseen inputs.',
        analogy:
            'It\'s like learning multiplication tables: you are shown pairs like (3,4) → 12 and (5,6) → 30 repeatedly, until you can correctly answer (7,8) → ? on your own, even though you never saw that exact pair before.',
        example:
            'A model trained on (square footage, number of rooms) → house price pairs learns to predict the price of a brand new house it has never seen, based on its features.',
        keyTakeaway:
            'The quality and quantity of labeled training pairs directly determines how well a supervised model can generalize to new, unseen data.',
        codeSnippet:
            'from sklearn.linear_model import LinearRegression\nimport numpy as np\n\nX = np.array([[1000], [1500], [2000], [2500]])  # square footage\ny = np.array([200000, 300000, 400000, 500000])   # price\n\nmodel = LinearRegression()\nmodel.fit(X, y)\nprint(model.predict([[1800]]))  # predicts price for new house',
      ),
      ConceptLesson(
        title: 'Regression vs Classification',
        definition:
            'Regression predicts a continuous numeric value (like price or temperature). Classification predicts a discrete category or class label (like spam/not-spam or cat/dog/bird).',
        analogy:
            'Regression is like predicting someone\'s exact height in centimeters (a continuous number). Classification is like predicting whether someone is "short", "medium", or "tall" (a category).',
        example:
            'Regression: predicting tomorrow\'s temperature in degrees. Classification: predicting whether tomorrow will be "sunny", "rainy", or "cloudy".',
        keyTakeaway:
            'Always identify whether your problem needs a number (regression) or a category (classification) FIRST — this determines which algorithms and evaluation metrics you should use.',
      ),
      ConceptLesson(
        title: 'Common Supervised Learning Algorithms',
        definition:
            'Popular supervised algorithms include Linear Regression (for continuous values), Logistic Regression (for binary classification), Decision Trees, Random Forests, and Support Vector Machines.',
        analogy:
            'Each algorithm is like a different tool in a toolbox — Linear Regression is a straight ruler for drawing simple trends, while Decision Trees are like a flowchart of yes/no questions leading to a final decision.',
        example:
            'Predicting exam scores from study hours → Linear Regression. Predicting whether a tumor is malignant or benign → Logistic Regression or Decision Trees.',
        keyTakeaway:
            'There is no single "best" algorithm for every problem — choosing the right one depends on your data size, complexity, and whether you need interpretability or raw accuracy.',
        codeSnippet:
            'from sklearn.linear_model import LogisticRegression\nfrom sklearn.tree import DecisionTreeClassifier\n\n# Logistic Regression for binary classification\nlog_model = LogisticRegression()\n\n# Decision Tree for classification\ntree_model = DecisionTreeClassifier()',
      ),
      ConceptLesson(
        title: 'Training a Supervised Model with Scikit-learn',
        definition:
            'Scikit-learn provides a consistent interface for training models: instantiate the model, call .fit() with training data, and call .predict() to make predictions on new data.',
        analogy:
            'Scikit-learn\'s .fit() method is like enrolling a model in "school" with your training data as its textbook. The .predict() method is like giving the model a final exam with new questions it has never seen.',
        example:
            'model = LinearRegression(); model.fit(X_train, y_train); predictions = model.predict(X_test) — this 3-line pattern works for nearly every Scikit-learn algorithm.',
        keyTakeaway:
            'Scikit-learn\'s consistent .fit() / .predict() API means once you learn it for one algorithm, you can apply the same workflow to dozens of other algorithms with minimal code changes.',
        codeSnippet:
            'from sklearn.linear_model import LinearRegression\nfrom sklearn.model_selection import train_test_split\nimport numpy as np\n\nX = np.array([[1],[2],[3],[4],[5]])\ny = np.array([2,4,6,8,10])\n\nX_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)\nmodel = LinearRegression()\nmodel.fit(X_train, y_train)\npredictions = model.predict(X_test)\nprint(predictions)',
      ),
      ConceptLesson(
        title: 'Evaluating Supervised Models',
        definition:
            'Regression models are typically evaluated with metrics like Mean Squared Error (MSE) or R² score. Classification models use Accuracy, Precision, Recall, and F1-score.',
        analogy:
            'Evaluation metrics are like report cards for your model — different subjects (regression vs classification) require different grading systems to fairly measure performance.',
        example:
            'A house price model with MSE = 5000 means predictions are off by an average squared error of 5000 (in price-squared units). A spam classifier with 95% accuracy correctly classifies 95 out of 100 emails.',
        keyTakeaway:
            'Never trust a single metric blindly — for imbalanced classification problems (e.g. 99% non-fraud, 1% fraud), accuracy can be misleading, and Precision/Recall give a more honest picture.',
        codeSnippet:
            'from sklearn.metrics import mean_squared_error, accuracy_score\n\n# Regression evaluation\nmse = mean_squared_error(y_test, predictions)\n\n# Classification evaluation\n# accuracy = accuracy_score(y_test, predictions)\nprint(f"MSE: {mse}")',
      ),
      ConceptLesson(
        title: 'Real-World Applications of Supervised Learning',
        definition:
            'Supervised learning powers some of the most impactful real-world AI applications across healthcare, finance, marketing, and technology.',
        analogy:
            'Supervised learning is the workhorse of practical AI — like a reliable employee who has been trained extensively on past cases and now handles new, similar cases with confidence.',
        example:
            'Credit scoring (predicting loan default risk), medical diagnosis (predicting disease from symptoms/scans), email spam filtering, and price prediction in e-commerce all rely heavily on supervised learning.',
        keyTakeaway:
            'Because labeled historical data is so often available in business settings, supervised learning remains the most commonly deployed type of machine learning in production systems today.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the key difference between Regression and Classification?',
        options: [
          'Regression predicts categories; classification predicts numbers',
          'Regression predicts continuous numeric values; classification predicts discrete categories',
          'They are the exact same task',
          'Classification can only be used with images'
        ],
        correctIndex: 1,
        explanation:
            'Regression outputs a continuous number (like price), while classification outputs a discrete label or category (like spam/not-spam).',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the Scikit-learn .fit() method do?',
        options: [
          'Deletes the training data',
          'Trains the model by learning patterns from the provided training data',
          'Only visualizes the data',
          'Converts the model into a different algorithm'
        ],
        correctIndex: 1,
        explanation:
            '.fit() is the core training step in Scikit-learn — it feeds the training data into the model so it can learn the underlying patterns or relationships.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why can accuracy be a misleading metric for an imbalanced classification problem (e.g. 99% non-fraud, 1% fraud)?',
        options: [
          'Accuracy is always perfectly fair',
          'A model that always predicts "non-fraud" would still score 99% accuracy while catching zero actual fraud cases',
          'Accuracy cannot be computed for imbalanced data',
          'Imbalanced data does not affect accuracy at all'
        ],
        correctIndex: 1,
        explanation:
            'With heavily imbalanced classes, a naive model can achieve high accuracy by simply always predicting the majority class, making accuracy alone a poor indicator of real performance.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You want to predict the exact selling price (in dollars) of a used car based on its mileage, age, and brand. What type of supervised learning task is this?',
        options: [
          'Classification',
          'Regression',
          'Clustering',
          'Reinforcement Learning'
        ],
        correctIndex: 1,
        explanation:
            'Predicting an exact continuous numeric value (price in dollars) is a regression task, not classification.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Write the correct Scikit-learn code pattern to train a LinearRegression model called "model" using training data X_train and y_train.',
        options: [
          'model.predict(X_train, y_train)',
          'model.fit(X_train, y_train)',
          'model.train(X_train)',
          'LinearRegression.fit(model, X_train)'
        ],
        correctIndex: 1,
        explanation:
            'The correct Scikit-learn pattern is model.fit(X_train, y_train) — this trains the model on the provided feature and label data.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'House Price Predictor',
      goal:
          'Build a simple supervised regression model using Scikit-learn to predict house prices from square footage.',
      steps: [
        'Create a small synthetic dataset using NumPy: square footage (X) and corresponding house prices (y) for at least 10 houses',
        'Split the data into training and test sets using train_test_split',
        'Train a LinearRegression model on the training data',
        'Use the model to predict prices for the test set',
        'Calculate and print the Mean Squared Error of your predictions',
        'Predict the price of a new house with a square footage of your choice',
      ],
      expectedOutput:
          'Model trained successfully.\nTest predictions: [...]\nMean Squared Error: 12500.0\nPredicted price for 1800 sqft house: \$360000',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'unsupervised_learning',
    topicTitle: 'Unsupervised Learning',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 150,
    emoji: '🔮',
    intro:
        'What happens when your data has no labels at all? Unsupervised Learning answers that question — discovering hidden structures, groupings, and patterns in raw data without any predefined answers, exactly like a detective working from scratch.',
    concepts: [
      ConceptLesson(
        title: 'What is Unsupervised Learning?',
        definition:
            'Unsupervised learning analyzes unlabeled data to discover hidden patterns, groupings, or structures, without being told the "correct" answer in advance.',
        analogy:
            'Imagine being handed a box of mixed Lego pieces with no instructions and asked to organize them into logical groups — you might naturally group by color, size, or shape, discovering structure on your own.',
        example:
            'A streaming service analyzes viewing habits of millions of users without predefined categories, discovering natural groups like "binge-watchers of true crime" or "weekend comedy viewers".',
        keyTakeaway:
            'Unsupervised learning is exploratory by nature — it reveals patterns you may not have even known to look for, making it powerful for discovery rather than direct prediction.',
      ),
      ConceptLesson(
        title: 'Clustering — Grouping Similar Data',
        definition:
            'Clustering algorithms group data points into clusters such that points within a cluster are more similar to each other than to points in other clusters.',
        analogy:
            'Clustering is like sorting a fruit basket into piles by similarity — apples with apples, oranges with oranges — without anyone telling you the fruit names in advance, just based on appearance.',
        example:
            'K-Means clustering groups customers into segments (e.g. "high spenders", "occasional buyers", "bargain hunters") based purely on purchasing patterns, with no predefined labels.',
        keyTakeaway:
            'Clustering is one of the most commonly used unsupervised techniques in business — powering customer segmentation, anomaly detection, and content recommendation systems.',
        codeSnippet:
            'from sklearn.cluster import KMeans\nimport numpy as np\n\nX = np.array([[1,2],[1,4],[1,0],[10,2],[10,4],[10,0]])\nkmeans = KMeans(n_clusters=2, random_state=42, n_init=10)\nkmeans.fit(X)\nprint(kmeans.labels_)  # cluster assignment for each point',
      ),
      ConceptLesson(
        title: 'K-Means Clustering Explained',
        definition:
            'K-Means is a popular clustering algorithm that partitions data into K clusters by repeatedly assigning points to the nearest cluster center and updating those centers until they stabilize.',
        analogy:
            'Imagine placing K magnets randomly in a room full of metal balls. Each ball gets pulled to its nearest magnet (cluster). Then each magnet repositions itself to the center of the balls it attracted. This repeats until the magnets stop moving — that\'s K-Means.',
        example:
            'A retail store uses K-Means with K=3 to discover three natural customer groups: budget shoppers, mid-range shoppers, and premium shoppers, based on average spending and visit frequency.',
        keyTakeaway:
            'Choosing the right value of K (number of clusters) is a key decision in K-Means — too few clusters oversimplifies the data, too many fragments meaningful groups unnecessarily.',
      ),
      ConceptLesson(
        title: 'Dimensionality Reduction',
        definition:
            'Dimensionality reduction techniques like PCA (Principal Component Analysis) compress data with many features into fewer dimensions while preserving as much important information as possible.',
        analogy:
            'Imagine trying to describe a 3D sculpture using only a 2D photograph — you lose some detail, but a well-chosen angle still captures the most important shape and structure. PCA finds the best "angle" to view high-dimensional data in fewer dimensions.',
        example:
            'A dataset with 100 different customer features might be reduced to just 2-3 "principal components" for easier visualization and faster model training, while retaining most of the meaningful variation.',
        keyTakeaway:
            'Dimensionality reduction is essential when working with very high-dimensional data (like images or genetic data) — it speeds up training, reduces noise, and enables visualization of complex datasets.',
        codeSnippet:
            'from sklearn.decomposition import PCA\nimport numpy as np\n\nX = np.random.rand(100, 10)  # 100 samples, 10 features\npca = PCA(n_components=2)\nX_reduced = pca.fit_transform(X)\nprint(X_reduced.shape)  # (100, 2)',
      ),
      ConceptLesson(
        title: 'Anomaly Detection',
        definition:
            'Anomaly detection identifies data points that significantly differ from the majority of the data — often used to flag fraud, defects, or unusual system behavior.',
        analogy:
            'Anomaly detection is like a security guard who has watched thousands of normal days pass by — when something unusual happens (a person sneaking in at 3am), it immediately stands out as different from the learned "normal" pattern.',
        example:
            'Credit card companies use unsupervised anomaly detection to flag transactions that deviate significantly from a customer\'s typical spending pattern, even without prior examples of that specific fraud type.',
        keyTakeaway:
            'Anomaly detection is especially valuable when fraudulent or faulty examples are rare or constantly evolving, making it hard to collect enough labeled examples for supervised learning.',
      ),
      ConceptLesson(
        title: 'Evaluating Unsupervised Models',
        definition:
            'Since there are no true labels, unsupervised models are evaluated using internal metrics like the Silhouette Score (cluster cohesion/separation) or through human interpretation of discovered patterns.',
        analogy:
            'Evaluating clusters without labels is like judging if you organized your closet "well" — there\'s no single correct answer, but you can check if items within each section make logical sense together and are clearly distinct from other sections.',
        example:
            'A Silhouette Score close to 1 indicates well-separated, cohesive clusters, while a score close to 0 or negative suggests clusters are overlapping or poorly defined.',
        keyTakeaway:
            'Unlike supervised learning, unsupervised model evaluation often requires domain expertise and human judgment alongside any mathematical metrics — the patterns must actually make business sense.',
        codeSnippet:
            'from sklearn.metrics import silhouette_score\nfrom sklearn.cluster import KMeans\nimport numpy as np\n\nX = np.random.rand(50, 2)\nkmeans = KMeans(n_clusters=3, random_state=42, n_init=10)\nlabels = kmeans.fit_predict(X)\nscore = silhouette_score(X, labels)\nprint(f"Silhouette Score: {score}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main goal of Unsupervised Learning?',
        options: [
          'To predict labeled outcomes using predefined categories',
          'To discover hidden patterns or groupings in data that has no labels',
          'To play games and learn from rewards',
          'To clean missing values in a dataset'
        ],
        correctIndex: 1,
        explanation:
            'Unsupervised learning explores unlabeled data to find natural patterns, structures, or groupings without any predefined correct answers.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the K in K-Means clustering represent?',
        options: [
          'The number of features in the dataset',
          'The number of clusters the algorithm should create',
          'The number of training epochs',
          'The accuracy score of the model'
        ],
        correctIndex: 1,
        explanation:
            'K represents the number of clusters you want K-Means to partition the data into — a value you choose before running the algorithm.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is dimensionality reduction (like PCA) useful before training models on high-dimensional data?',
        options: [
          'It adds more features to improve accuracy',
          'It compresses data into fewer dimensions, reducing noise and speeding up training while preserving important information',
          'It deletes the dataset entirely',
          'It is only used for image colorization'
        ],
        correctIndex: 1,
        explanation:
            'Dimensionality reduction simplifies high-dimensional data into fewer meaningful dimensions, which speeds up computation, reduces noise, and can improve model performance and visualization.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A bank wants to flag unusual transactions that differ significantly from a customer\'s normal spending pattern, without having labeled examples of every possible fraud type. Which unsupervised technique fits best?',
        options: [
          'K-Means Clustering for marketing',
          'Anomaly Detection',
          'Linear Regression',
          'Logistic Regression'
        ],
        correctIndex: 1,
        explanation:
            'Anomaly Detection is specifically designed to identify data points that deviate significantly from learned "normal" patterns, making it ideal for fraud detection without requiring labeled fraud examples.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'After running K-Means clustering, you compute a Silhouette Score of 0.85. What does this generally indicate?',
        options: [
          'The clusters are poorly defined and overlapping',
          'The clusters are well-separated and cohesive',
          'The model failed to run',
          'The Silhouette Score is unrelated to clustering quality'
        ],
        correctIndex: 1,
        explanation:
            'A Silhouette Score close to 1 (like 0.85) indicates that data points are well-matched to their own cluster and clearly separated from other clusters — a sign of good clustering quality.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Customer Segmentation with K-Means',
      goal:
          'Build an unsupervised clustering model using Scikit-learn to segment synthetic customer data.',
      steps: [
        'Create a synthetic dataset using NumPy with 2 features: annual_spending and visit_frequency for 50 customers',
        'Use Scikit-learn\'s KMeans to cluster the customers into 3 groups',
        'Print the cluster label assigned to each customer',
        'Calculate and print the Silhouette Score to evaluate cluster quality',
        'Write a short interpretation describing what each of the 3 clusters might represent (e.g. high spenders, occasional shoppers, budget customers)',
      ],
      expectedOutput:
          'Cluster labels: [0, 1, 2, 0, 1, ...]\nSilhouette Score: 0.72\nInterpretation: Cluster 0 = high spenders, Cluster 1 = occasional shoppers, Cluster 2 = budget customers',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'reinforcement_learning_basics',
    topicTitle: 'Reinforcement Learning Basics',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 150,
    emoji: '🎮',
    intro:
        'Reinforcement Learning is how AI systems learn to master games, control robots, and optimize complex decisions — by trial, error, and reward, just like how living creatures learn from experience.',
    concepts: [
      ConceptLesson(
        title: 'What is Reinforcement Learning?',
        definition:
            'Reinforcement Learning (RL) is a type of machine learning where an "agent" learns to make decisions by performing actions in an "environment" and receiving rewards or penalties as feedback.',
        analogy:
            'RL is like training a puppy: the puppy (agent) tries different behaviors in your house (environment), gets a treat (reward) for sitting on command, and gradually learns which behaviors lead to treats and which don\'t.',
        example:
            'A reinforcement learning agent playing a video game tries random moves at first, but over millions of attempts, learns which sequences of actions lead to higher scores (rewards).',
        keyTakeaway:
            'Unlike supervised learning, RL doesn\'t need pre-labeled "correct" answers — it learns purely through interaction and feedback from its environment over time.',
      ),
      ConceptLesson(
        title: 'Core Components: Agent, Environment, Action, Reward',
        definition:
            'Every RL system has 4 core components: the Agent (decision-maker), the Environment (the world it operates in), Actions (choices the agent can make), and Rewards (feedback signals indicating success or failure).',
        analogy:
            'Imagine a maze-solving robot (agent) inside a maze (environment). At each step, it can move left, right, up, or down (actions), and it gets points for reaching the exit and loses points for hitting walls (rewards).',
        example:
            'In a self-driving car RL system: the agent is the car\'s decision system, the environment is the road and traffic, actions are steering/braking/accelerating, and rewards are based on safe, efficient driving.',
        keyTakeaway:
            'Understanding these 4 components is essential for framing ANY problem as a reinforcement learning task — if you can identify an agent, environment, actions, and rewards, RL can likely be applied.',
      ),
      ConceptLesson(
        title: 'The Exploration vs Exploitation Trade-off',
        definition:
            'Exploration means trying new, untested actions to discover potentially better strategies. Exploitation means using the best-known action so far to maximize immediate reward. RL agents must balance both.',
        analogy:
            'Imagine choosing a restaurant: exploitation is always going to your favorite known restaurant (guaranteed good meal), while exploration is trying a brand new restaurant (might be even better, or might be worse) to discover new options.',
        example:
            'An RL agent learning to play chess must sometimes try unconventional moves (exploration) instead of always playing its current best-known strategy (exploitation), to discover potentially superior strategies.',
        keyTakeaway:
            'Too much exploitation leads to a model stuck in mediocre, "good enough" strategies. Too much exploration wastes time on bad choices. Balancing both is one of the central challenges in RL.',
      ),
      ConceptLesson(
        title: 'Rewards and the Reward Signal',
        definition:
            'The reward signal is a numeric score given to the agent after each action, indicating how good or bad that action was toward achieving the overall goal.',
        analogy:
            'A reward signal is like a video game score counter — go up when you do something good (collect a coin), go down or stay flat when you do something bad (lose a life), guiding your strategy over time.',
        example:
            'In a robot-walking RL task, the reward might be +1 for each step taken without falling, and -10 for falling down, encouraging the robot to learn stable walking patterns over time.',
        keyTakeaway:
            'Designing a good reward function is one of the hardest and most important parts of RL — a poorly designed reward can cause the agent to learn unintended or even harmful behaviors ("reward hacking").',
      ),
      ConceptLesson(
        title: 'Real-World Applications of Reinforcement Learning',
        definition:
            'Reinforcement learning powers game-playing AI, robotics, autonomous vehicles, resource management systems, and increasingly, the fine-tuning of large language models through human feedback (RLHF).',
        analogy:
            'RL is like the difference between a chess student who memorizes opening books (supervised) versus one who plays millions of practice games against themselves and learns purely from winning and losing (reinforcement).',
        example:
            'AlphaGo and AlphaZero mastered Go and Chess through reinforcement learning by playing against themselves. Modern chatbots like ChatGPT use RLHF (Reinforcement Learning from Human Feedback) to align responses with human preferences.',
        keyTakeaway:
            'RL is uniquely suited for problems involving sequential decisions where the consequences of an action may not be immediately obvious — making it essential for robotics, gaming, and advanced AI alignment.',
      ),
      ConceptLesson(
        title: 'Reinforcement Learning vs Supervised Learning',
        definition:
            'Supervised learning learns from a fixed dataset of labeled examples. Reinforcement learning learns by actively interacting with an environment and receiving delayed, sequential feedback.',
        analogy:
            'Supervised learning is like studying from a textbook with all the answers provided upfront. Reinforcement learning is like learning to ride a bike — there\'s no answer key, just feedback (falling or balancing) after each attempt.',
        example:
            'Predicting house prices from historical data is supervised. Teaching a robotic arm to grasp objects through repeated physical attempts and feedback is reinforcement learning.',
        keyTakeaway:
            'Choose RL when your problem involves a sequence of decisions with delayed consequences and no readily available labeled dataset — choose supervised learning when you already have clear, labeled examples.',
        codeSnippet:
            '# Conceptual RL loop (pseudocode)\n# state = environment.reset()\n# for step in range(max_steps):\n#     action = agent.choose_action(state)\n#     next_state, reward, done = environment.step(action)\n#     agent.learn(state, action, reward, next_state)\n#     state = next_state\n#     if done:\n#         break',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What are the 4 core components of a Reinforcement Learning system?',
        options: [
          'Data, Labels, Model, Output',
          'Agent, Environment, Action, Reward',
          'Mean, Median, Mode, Variance',
          'Train, Test, Validate, Deploy'
        ],
        correctIndex: 1,
        explanation:
            'Every RL system is built around an Agent making decisions, an Environment it interacts with, Actions it can take, and Rewards that provide feedback on those actions.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does the exploration vs exploitation trade-off describe?',
        options: [
          'Balancing trying new actions (exploration) against using the best-known action (exploitation)',
          'Choosing between supervised and unsupervised learning',
          'Deciding how much data to collect',
          'Choosing a programming language'
        ],
        correctIndex: 0,
        explanation:
            'This trade-off describes the core RL challenge of balancing trying new, potentially better actions against reliably using the current best-known strategy.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is designing a good reward function so important in Reinforcement Learning?',
        options: [
          'It has no real impact on the final behavior',
          'A poorly designed reward function can cause the agent to learn unintended or harmful behaviors',
          'Reward functions are only used for visualization',
          'Reward functions replace the need for an environment'
        ],
        correctIndex: 1,
        explanation:
            'Since RL agents optimize purely to maximize reward, a flawed reward function can lead to "reward hacking" — where the agent finds unintended shortcuts that technically maximize reward but fail the actual goal.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'An RL agent learning to play a maze game has found one path to the exit that works reasonably well, and keeps repeating it without trying new paths. What problem does this represent?',
        options: [
          'Too much exploration',
          'Too much exploitation, potentially missing a better path',
          'A perfectly balanced agent',
          'This is not related to RL at all'
        ],
        correctIndex: 1,
        explanation:
            'Always repeating the same known-good path without trying new ones is over-exploitation — the agent may be stuck with a "good enough" solution while missing a potentially better one.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You are designing an RL system to teach a robot vacuum to clean a room efficiently. Identify the correct mapping: the robot is the ______, and the room is the ______.',
        options: [
          'Agent, Environment',
          'Environment, Agent',
          'Reward, Action',
          'Action, Reward'
        ],
        correctIndex: 0,
        explanation:
            'The robot (decision-maker) is the Agent, and the room it operates within is the Environment — a classic mapping of RL components to a real-world scenario.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Reinforcement Learning Concept Simulator',
      goal:
          'Design and document a simple RL system (conceptually, in Python pseudocode) for a real-world scenario of your choice.',
      steps: [
        'Choose a real-world scenario suitable for RL (e.g. a delivery robot choosing routes, a thermostat learning optimal temperature settings)',
        'Clearly define the Agent, Environment, Actions, and Reward structure for your scenario',
        'Write Python pseudocode representing one iteration of the agent choosing an action and receiving a reward',
        'Explain how you would handle the exploration vs exploitation trade-off in your scenario',
        'Describe what a poorly designed reward function might cause the agent to do incorrectly in your scenario',
      ],
      expectedOutput:
          'A complete written RL system design including Agent/Environment/Action/Reward definitions, Python pseudocode for one learning step, and an explanation of exploration vs exploitation handling.',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'feature_engineering_ml5',
    topicTitle: 'Feature Engineering',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 150,
    emoji: '⚙️',
    intro:
        'Feature Engineering is often called the single highest-leverage skill in applied Machine Learning. A great feature can boost model accuracy more than switching to a fancier algorithm. This lesson teaches you to think like a true ML practitioner.',
    concepts: [
      ConceptLesson(
        title: 'What is Feature Engineering?',
        definition:
            'Feature Engineering is the process of using domain knowledge to create, transform, or select input variables (features) that make machine learning models more accurate and effective.',
        analogy:
            'Raw data is like raw ingredients in a kitchen. Feature engineering is the skilled chef\'s prep work — chopping, marinating, combining ingredients in the right way — that transforms raw materials into something the final dish (model) can actually use well.',
        example:
            'Raw data: a "birthdate" column. Engineered feature: "age" calculated from birthdate, which is often far more directly useful to a model predicting health risk than the raw birthdate itself.',
        keyTakeaway:
            'Models cannot automatically know what matters in your data — feature engineering is how YOU inject domain knowledge and human intuition directly into what the model sees.',
      ),
      ConceptLesson(
        title: 'Creating New Features',
        definition:
            'New features can be created by combining existing columns mathematically, extracting components from complex data (like dates), or applying domain-specific calculations.',
        analogy:
            'Creating a new feature is like calculating "speed" from "distance" and "time" — neither original column alone tells the full story, but their combination reveals a more meaningful insight.',
        example:
            'From "weight_kg" and "height_m", engineer "BMI" using BMI = weight_kg / (height_m ** 2) — a single feature that captures body composition far better than either column alone.',
        keyTakeaway:
            'The best engineered features often combine 2 or more existing features in a way that captures a real-world relationship the model could not learn from raw columns alone.',
        codeSnippet:
            'import pandas as pd\n\ndf = pd.DataFrame({"weight_kg": [70, 85, 60], "height_m": [1.75, 1.80, 1.65]})\ndf["bmi"] = df["weight_kg"] / (df["height_m"] ** 2)\nprint(df)',
      ),
      ConceptLesson(
        title: 'Encoding Categorical Features',
        definition:
            'Most ML algorithms require numeric input, so categorical (text-based) features must be converted into numbers using techniques like One-Hot Encoding or Label Encoding.',
        analogy:
            'A model can\'t understand the word "blue" any more than a calculator can. Encoding is like assigning each category a numeric code so mathematical operations can actually be performed.',
        example:
            'A "city" column with values [Delhi, Mumbai, Pune] gets One-Hot Encoded into 3 binary columns: city_Delhi, city_Mumbai, city_Pune, each containing 0 or 1.',
        keyTakeaway:
            'Use One-Hot Encoding for non-ordinal categories (no natural order, like city names) and Label Encoding for ordinal categories with a clear order (like "low/medium/high").',
        codeSnippet:
            'import pandas as pd\n\ndf = pd.DataFrame({"city": ["Delhi", "Mumbai", "Pune", "Delhi"]})\nencoded = pd.get_dummies(df["city"], prefix="city")\nprint(encoded)',
      ),
      ConceptLesson(
        title: 'Feature Scaling',
        definition:
            'Feature scaling transforms numeric features to a similar range or distribution, preventing features with large numeric ranges from dominating those with small ranges.',
        analogy:
            'Comparing "income in dollars" (ranging in thousands) against "number of children" (ranging 0-5) without scaling is like comparing a giant\'s footsteps to an ant\'s — scaling brings both onto a fair, comparable scale.',
        example:
            'StandardScaler transforms data to have mean=0 and standard deviation=1. MinMaxScaler rescales data into a fixed 0-1 range.',
        keyTakeaway:
            'Distance-based algorithms (like K-Means or KNN) and gradient-based models (like neural networks) are especially sensitive to unscaled features — always scale your numeric features before training these models.',
        codeSnippet:
            'from sklearn.preprocessing import StandardScaler\nimport numpy as np\n\ndata = np.array([[1000], [50000], [200000]])\nscaler = StandardScaler()\nscaled_data = scaler.fit_transform(data)\nprint(scaled_data)',
      ),
      ConceptLesson(
        title: 'Feature Selection',
        definition:
            'Feature selection is the process of identifying and keeping only the most relevant features for your model, removing redundant or unhelpful ones.',
        analogy:
            'Feature selection is like packing for a trip — you don\'t bring your entire wardrobe, just the most relevant, useful items for your specific destination and purpose, leaving behind anything that just adds unnecessary weight.',
        example:
            'A dataset with 200 columns might only have 15 truly predictive features for a specific task — including the other 185 irrelevant features can actually hurt model performance and slow down training.',
        keyTakeaway:
            'More features are not always better. Irrelevant or redundant features can introduce noise, increase overfitting risk, and slow down training — feature selection helps models focus on what truly matters.',
      ),
      ConceptLesson(
        title: 'Feature Engineering Best Practices',
        definition:
            'Effective feature engineering combines domain expertise, experimentation, and careful validation to ensure new features genuinely improve model performance rather than introducing bias or leakage.',
        analogy:
            'Good feature engineering is like good cooking — you taste-test (validate) along the way rather than blindly adding every spice (feature) you can think of, ensuring each addition actually improves the final result.',
        example:
            'A common mistake is "data leakage" — accidentally including a feature that contains information about the target that wouldn\'t be available at prediction time, such as using "total_amount_refunded" to predict "will_refund" before the refund has happened.',
        keyTakeaway:
            'Always validate that engineered features actually improve model performance on a held-out test set, and double-check that no feature accidentally leaks information from the future or the target itself.',
        codeSnippet:
            '# Bad: data leakage example\n# df["will_churn"] uses "cancellation_date" which only exists AFTER churning\n# This gives unrealistically perfect accuracy during training but fails in production\n\n# Good: only use features available BEFORE the prediction moment\nfeatures = ["monthly_usage", "support_tickets", "tenure_months"]',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the primary purpose of feature engineering?',
        options: [
          'To make datasets smaller in file size',
          'To use domain knowledge to create or transform input variables that improve model accuracy',
          'To delete all categorical columns',
          'To visualize data only'
        ],
        correctIndex: 1,
        explanation:
            'Feature engineering injects domain expertise into the dataset by creating, transforming, or selecting variables that help models learn more effectively.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'When should you use One-Hot Encoding instead of Label Encoding?',
        options: [
          'When the categorical feature has a natural order (e.g. low/medium/high)',
          'When the categorical feature has no natural order (e.g. city names)',
          'One-Hot Encoding should never be used',
          'They are always interchangeable with no difference'
        ],
        correctIndex: 1,
        explanation:
            'One-Hot Encoding avoids implying a false numeric order, making it ideal for non-ordinal categories like city names, while Label Encoding suits ordinal categories with a clear ranking.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is "data leakage" in the context of feature engineering?',
        options: [
          'Losing data due to a corrupted file',
          'Accidentally including a feature that contains information not actually available at prediction time',
          'A type of feature scaling technique',
          'A method for encoding categorical variables'
        ],
        correctIndex: 1,
        explanation:
            'Data leakage occurs when a feature inadvertently includes information from the future or the target variable itself, leading to unrealistically high training performance that fails in real-world deployment.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You have "height_cm" and "weight_kg" columns and want a single feature capturing body composition better than either alone. What should you create?',
        options: [
          'Delete both columns',
          'A combined feature like BMI = weight_kg / (height_m)^2',
          'Convert both to categorical text values',
          'Leave the columns completely unchanged'
        ],
        correctIndex: 1,
        explanation:
            'Combining height and weight into BMI creates a new feature that captures the relationship between the two raw variables, often more predictive than either column alone.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A churn prediction model accidentally includes a "cancellation_date" feature, which only has a value AFTER a customer has already churned. What problem does this represent?',
        options: [
          'Feature scaling error',
          'Data leakage, since this information would not be available at prediction time',
          'A perfectly valid feature with no issues',
          'One-Hot Encoding error'
        ],
        correctIndex: 1,
        explanation:
            'This is a classic data leakage scenario — the feature contains future information unavailable at actual prediction time, which would cause the model to appear deceptively accurate during training but fail badly in real-world use.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Feature Engineering Workshop',
      goal:
          'Engineer multiple new features from a raw e-commerce dataset and prepare it for machine learning using Pandas and Scikit-learn.',
      steps: [
        'Create a synthetic Pandas DataFrame with columns: purchase_date, amount, customer_age, city',
        'Engineer a "days_since_purchase" feature based on purchase_date',
        'One-hot encode the city column using pd.get_dummies',
        'Scale the amount and customer_age columns using StandardScaler from Scikit-learn',
        'Print the final transformed DataFrame showing all original and newly engineered features',
        'Write 2 sentences identifying any potential data leakage risk in your engineered features',
      ],
      expectedOutput:
          'Original columns: purchase_date, amount, customer_age, city\nNew columns: days_since_purchase, city_*, amount (scaled), customer_age (scaled)\nFeature engineering complete with no data leakage identified.',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'data_preprocessing_ml5',
    topicTitle: 'Data Preprocessing',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 150,
    emoji: '🧼',
    intro:
        'Before any algorithm can learn anything useful, raw data must be properly preprocessed. This lesson covers the essential preprocessing steps every AI engineer performs before training a single machine learning model.',
    concepts: [
      ConceptLesson(
        title: 'Why Data Preprocessing is Essential',
        definition:
            'Data preprocessing is the process of cleaning, transforming, and organizing raw data into a format suitable for machine learning algorithms to learn from effectively.',
        analogy:
            'Feeding raw, unprocessed data directly into a model is like trying to cook with unwashed, unpeeled, unchopped vegetables straight from the ground — technically the ingredients are there, but the result will be a mess.',
        example:
            'A dataset with missing values, mismatched scales, and text categories cannot be directly used by most ML algorithms, which expect clean, complete, numeric input.',
        keyTakeaway:
            'Most ML algorithms assume clean, well-structured, numeric data — preprocessing is the bridge between messy real-world data and what algorithms actually require.',
      ),
      ConceptLesson(
        title: 'Handling Missing Data',
        definition:
            'Missing data must be detected and handled — either by removing incomplete rows/columns or by imputing (filling in) reasonable estimated values.',
        analogy:
            'Missing data is like blank spaces in a survey — sometimes you discard incomplete surveys entirely, and sometimes you make a reasonable, informed estimate to fill in the gap rather than losing the whole response.',
        example:
            'df.dropna() removes rows with missing values. df["age"].fillna(df["age"].median()) fills missing ages with the median value of the column.',
        keyTakeaway:
            'The right strategy (drop vs impute) depends on how much data is missing and why — losing too much data through dropping can be worse than a reasonable imputation.',
        codeSnippet:
            'import pandas as pd\n\ndf = pd.DataFrame({"age": [25, None, 30, None, 40]})\nprint(df.isnull().sum())\n\ndf["age"] = df["age"].fillna(df["age"].median())\nprint(df)',
      ),
      ConceptLesson(
        title: 'Encoding and Scaling for ML Models',
        definition:
            'Before training, categorical variables must be encoded into numbers, and numeric variables are typically scaled to a similar range to prevent any single feature from dominating the model.',
        analogy:
            'Imagine a tug-of-war where one side has giants and the other has children — without scaling the "strength" fairly, the contest is meaningless. Feature scaling ensures every feature gets a fair influence on the model.',
        example:
            'Scikit-learn\'s StandardScaler and MinMaxScaler are the most commonly used scaling tools, while pd.get_dummies() or OneHotEncoder handle categorical encoding.',
        keyTakeaway:
            'Always apply the SAME scaling/encoding transformation learned from training data to your test data — never fit a new scaler on test data, as this would leak information and produce unrealistic results.',
        codeSnippet:
            'from sklearn.preprocessing import StandardScaler\n\nscaler = StandardScaler()\nX_train_scaled = scaler.fit_transform(X_train)\nX_test_scaled = scaler.transform(X_test)  # use transform, NOT fit_transform, on test data',
      ),
      ConceptLesson(
        title: 'Removing Duplicates and Outliers',
        definition:
            'Duplicate records can artificially bias a model toward over-represented patterns, and extreme outliers can distort statistical assumptions or skew model training.',
        analogy:
            'Duplicate data is like counting one person\'s vote multiple times in an election — it distorts the true outcome. An extreme outlier is like one person showing up to a children\'s height survey who is 9 feet tall — it must be investigated before deciding how to handle it.',
        example:
            'df.drop_duplicates() removes exact duplicate rows. The IQR method (values beyond Q1 - 1.5*IQR or Q3 + 1.5*IQR) is commonly used to detect numeric outliers.',
        keyTakeaway:
            'Never blindly delete outliers without investigation — some outliers represent valuable real-world signal (like fraud), while others are simple data entry errors needing correction.',
        codeSnippet:
            'import pandas as pd\n\ndf = pd.DataFrame({"id": [1,2,2,3], "value": [10, 20, 20, 9999]})\ndf_clean = df.drop_duplicates()\n\nQ1, Q3 = df["value"].quantile([0.25, 0.75])\nIQR = Q3 - Q1\noutliers = df[(df["value"] < Q1 - 1.5*IQR) | (df["value"] > Q3 + 1.5*IQR)]\nprint(outliers)',
      ),
      ConceptLesson(
        title: 'Building a Preprocessing Pipeline',
        definition:
            'A preprocessing pipeline chains together multiple preprocessing steps (imputation, encoding, scaling) into a single, repeatable, automated sequence using tools like Scikit-learn\'s Pipeline class.',
        analogy:
            'A preprocessing pipeline is like an assembly line at a factory — raw materials (raw data) enter one end, pass automatically through each processing station in the correct order, and a finished, ready-to-use product (clean, model-ready data) comes out the other end.',
        example:
            'A Scikit-learn Pipeline might chain: SimpleImputer (handle missing values) → StandardScaler (scale numeric features) → the final model, all executed with a single .fit() call.',
        keyTakeaway:
            'Pipelines ensure preprocessing steps are applied consistently and in the correct order every time, preventing common errors like accidentally applying different transformations to training vs test data.',
        codeSnippet:
            'from sklearn.pipeline import Pipeline\nfrom sklearn.impute import SimpleImputer\nfrom sklearn.preprocessing import StandardScaler\nfrom sklearn.linear_model import LinearRegression\n\npipeline = Pipeline([\n    ("imputer", SimpleImputer(strategy="median")),\n    ("scaler", StandardScaler()),\n    ("model", LinearRegression())\n])\n# pipeline.fit(X_train, y_train)',
      ),
      ConceptLesson(
        title: 'Common Preprocessing Mistakes to Avoid',
        definition:
            'Common mistakes include fitting scalers/encoders on the full dataset (including test data) before splitting, ignoring missing values, and not validating preprocessing choices against actual model performance.',
        analogy:
            'Fitting a scaler on your entire dataset (including test data) before splitting is like studying the exam answer key before taking the exam — it gives a falsely inflated sense of how well your model will actually perform on truly unseen data.',
        example:
            'Correct order: split data FIRST into train/test, THEN fit your scaler/imputer ONLY on training data, and apply (transform only) that same fitted transformation to test data.',
        keyTakeaway:
            'Always split your data into train/test sets BEFORE fitting any preprocessing steps — fitting on the full dataset first is one of the most common and damaging mistakes in real-world ML projects.',
        codeSnippet:
            'from sklearn.model_selection import train_test_split\nfrom sklearn.preprocessing import StandardScaler\n\n# CORRECT order\nX_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)\nscaler = StandardScaler()\nX_train_scaled = scaler.fit_transform(X_train)  # fit only on train\nX_test_scaled = scaler.transform(X_test)        # transform only on test',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why must categorical variables be encoded before training most ML models?',
        options: [
          'It makes the dataset file smaller',
          'Most ML algorithms perform mathematical operations and require numeric input, not raw text',
          'Encoding is purely a stylistic preference',
          'It is only required for image data'
        ],
        correctIndex: 1,
        explanation:
            'Machine learning algorithms compute mathematical operations that require numeric inputs — categorical text values must be converted into numbers first through encoding.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the correct order for splitting data and applying a scaler?',
        options: [
          'Fit the scaler on the entire dataset, then split into train/test',
          'Split into train/test FIRST, then fit the scaler only on training data and transform both sets',
          'There is no correct order — it never matters',
          'Always fit a new scaler separately on train and test data'
        ],
        correctIndex: 1,
        explanation:
            'You must split your data first, then fit your scaler ONLY on the training set, and apply (transform) that same fitted scaler to the test set — fitting on the full dataset first causes data leakage.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the benefit of using a Scikit-learn Pipeline for preprocessing?',
        options: [
          'It chains multiple preprocessing steps into one consistent, repeatable, automated sequence',
          'It deletes all missing values automatically without any other benefit',
          'It replaces the need for a machine learning model entirely',
          'It only works with image data'
        ],
        correctIndex: 0,
        explanation:
            'Pipelines combine multiple preprocessing and modeling steps into a single object, ensuring consistent application of the same steps in the correct order every time, reducing errors.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You fit a StandardScaler on your ENTIRE dataset (including test data) before splitting into train/test sets. What problem does this cause?',
        options: [
          'No problem at all, this is the recommended approach',
          'Data leakage — test data information influences the scaling applied to training data, giving unrealistically optimistic results',
          'It makes the model train faster with no downsides',
          'It only affects categorical features, not numeric ones'
        ],
        correctIndex: 1,
        explanation:
            'Fitting a scaler on the full dataset before splitting allows information from the test set to influence preprocessing, a classic form of data leakage that inflates apparent model performance unrealistically.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Which Pandas method removes rows containing any missing values from a DataFrame?',
        options: [
          'df.fillna()',
          'df.dropna()',
          'df.drop_duplicates()',
          'df.isnull()'
        ],
        correctIndex: 1,
        explanation:
            'df.dropna() removes rows (by default) that contain any missing (NaN) values, while df.fillna() fills them in instead of removing them.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Complete Preprocessing Pipeline',
      goal:
          'Build a full Scikit-learn preprocessing pipeline that handles missing values, scaling, and encoding for a synthetic dataset.',
      steps: [
        'Create a synthetic Pandas DataFrame with numeric columns (some containing missing values) and one categorical column',
        'Split the data into training and test sets using train_test_split',
        'Build a Scikit-learn Pipeline that imputes missing values with SimpleImputer and scales numeric features with StandardScaler',
        'Fit the pipeline ONLY on the training data, then transform both training and test sets',
        'Print the shape and a sample of the transformed training data to confirm preprocessing was applied correctly',
        'Write 2 sentences explaining why you split the data before fitting the pipeline',
      ],
      expectedOutput:
          'Pipeline created successfully.\nTraining data transformed: shape (80, 3)\nTest data transformed: shape (20, 3)\nExplanation: splitting before fitting prevents data leakage from test set into preprocessing steps.',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'train_validation_test_split',
    topicTitle: 'Train, Validation and Test Split',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 25,
    totalXp: 140,
    emoji: '✂️',
    intro:
        'How do you know if your model will actually work on data it has never seen before? The answer lies in correctly splitting your data into Training, Validation, and Test sets — one of the most important and most commonly misunderstood concepts in Machine Learning.',
    concepts: [
      ConceptLesson(
        title: 'Why We Split Data into Multiple Sets',
        definition:
            'Data is split into Training (to learn from), Validation (to tune the model), and Test (for final, unbiased evaluation) sets to honestly measure how well a model will perform on completely new, unseen data.',
        analogy:
            'Training data is like textbook exercises with answers. Validation data is like a practice exam used to improve your study strategy (no official grade). Test data is like the real final exam — you only look at it once, after all preparation is complete.',
        example:
            'A typical split: 70% Training, 15% Validation, 15% Test. The model learns from the 70%, gets tuned using the 15% validation set, and is finally, honestly evaluated on the untouched 15% test set.',
        keyTakeaway:
            'NEVER use test data to make decisions during model development — doing so contaminates your "final exam" and gives a dishonest, overly optimistic measure of real-world performance.',
      ),
      ConceptLesson(
        title: 'The Training Set',
        definition:
            'The training set is the portion of data the model directly learns from — it sees both the input features and the correct output labels during this phase.',
        analogy:
            'The training set is like a student\'s study material with both questions AND answers provided — they read these in school over and over to learn the underlying patterns.',
        example:
            'In a house price model, the training set contains historical houses with all their features (size, rooms, location) AND their known sale prices, which the model uses to learn the price-predicting pattern.',
        keyTakeaway:
            'The training set is usually the largest portion of your data (commonly 60-80%) since the model needs sufficient examples to learn meaningful, generalizable patterns.',
        codeSnippet:
            'from sklearn.model_selection import train_test_split\nimport numpy as np\n\nX = np.arange(100).reshape(-1, 1)\ny = np.arange(100) * 2\n\nX_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)\nprint(X_train.shape, X_test.shape)  # (80, 1) (20, 1)',
      ),
      ConceptLesson(
        title: 'The Validation Set',
        definition:
            'The validation set is used during model development to tune hyperparameters and compare different model versions, WITHOUT touching the final test set.',
        analogy:
            'The validation set is like a mock exam a student takes before the real final — it gives honest feedback on weaknesses to focus on improving, without being the actual graded test that determines the final outcome.',
        example:
            'When choosing between 3 different model configurations (e.g. different tree depths), you compare their performance on the validation set, not the test set, to select the best one.',
        keyTakeaway:
            'The validation set lets you experiment and tune freely without "burning" your test set — once you evaluate on the test set, that result should be treated as final and not used to make further changes.',
      ),
      ConceptLesson(
        title: 'The Test Set',
        definition:
            'The test set is a completely held-out portion of data used ONLY ONCE, at the very end, to provide an honest, unbiased estimate of how the final model will perform on real, unseen data.',
        analogy:
            'The test set is like the actual final exam day — no more studying, no more practice, just a true, one-time measurement of what you have actually learned.',
        example:
            'After finalizing your model using training and validation data, you evaluate it ONE TIME on the test set and report that result as your model\'s expected real-world performance.',
        keyTakeaway:
            'If you find yourself going back to "improve" your model after seeing test set results, you have effectively turned your test set into a second validation set — invalidating its honesty as a true performance measure.',
      ),
      ConceptLesson(
        title: 'Cross-Validation',
        definition:
            'Cross-validation is a more robust evaluation technique that splits training data into multiple "folds", training and validating the model multiple times on different fold combinations to get a more reliable performance estimate.',
        analogy:
            'Instead of taking just ONE practice exam (a single validation split), cross-validation is like taking 5 different practice exams covering different material combinations, then averaging your scores for a more reliable picture of your true ability.',
        example:
            '5-fold cross-validation splits training data into 5 parts, trains 5 times (each time using 4 parts for training and 1 for validation), and averages the 5 resulting performance scores.',
        keyTakeaway:
            'Cross-validation is especially valuable for smaller datasets, where a single train/validation split might give a misleadingly lucky or unlucky performance estimate due to random chance.',
        codeSnippet:
            'from sklearn.model_selection import cross_val_score\nfrom sklearn.linear_model import LinearRegression\nimport numpy as np\n\nX = np.arange(100).reshape(-1, 1)\ny = np.arange(100) * 2\n\nmodel = LinearRegression()\nscores = cross_val_score(model, X, y, cv=5)\nprint(f"Average score: {scores.mean():.3f}")',
      ),
      ConceptLesson(
        title: 'Common Splitting Mistakes',
        definition:
            'Common mistakes include not shuffling data before splitting (especially with ordered/time-series data), data leakage between sets, and using too small a test set to draw reliable conclusions.',
        analogy:
            'Splitting unshuffled, sorted data (e.g. all "Class A" students first, then "Class B") without shuffling first is like only studying the first half of a textbook and being tested only on the second half you never reviewed — the split would not be representative.',
        example:
            'For time-series data (like stock prices), you should NOT randomly shuffle before splitting — instead, train on earlier dates and test on later dates, mimicking how the model would actually be used in the real world.',
        keyTakeaway:
            'Always use the random_state parameter for reproducibility, ensure your splits are representative of the overall data distribution, and adapt your splitting strategy (random vs chronological) to match your specific problem type.',
        codeSnippet:
            '# For time-series data, split chronologically rather than randomly\nsplit_index = int(len(X) * 0.8)\nX_train, X_test = X[:split_index], X[split_index:]\ny_train, y_test = y[:split_index], y[split_index:]',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the purpose of the validation set?',
        options: [
          'To provide the final, one-time performance measurement of a model',
          'To tune hyperparameters and compare model versions during development',
          'To replace the need for a training set',
          'It serves no real purpose in machine learning'
        ],
        correctIndex: 1,
        explanation:
            'The validation set allows you to tune and compare model configurations during development without contaminating the test set, which is reserved for final evaluation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should you NEVER use the test set to make decisions during model development?',
        options: [
          'The test set cannot be loaded into Python',
          'Doing so contaminates the test set, giving an overly optimistic and dishonest measure of real-world performance',
          'There is no real downside to this practice',
          'Test sets are always larger than training sets'
        ],
        correctIndex: 1,
        explanation:
            'Using the test set to guide development decisions means you are effectively "peeking at the answer key", inflating apparent performance and giving an unreliable estimate of how the model will truly perform on genuinely new data.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is cross-validation especially valuable for smaller datasets?',
        options: [
          'It eliminates the need for any test set',
          'A single train/validation split on small data might give a misleadingly lucky or unlucky estimate; cross-validation averages multiple splits for a more reliable result',
          'It makes the dataset larger automatically',
          'It only works with image data'
        ],
        correctIndex: 1,
        explanation:
            'With small datasets, a single random split can be unrepresentative by chance. Cross-validation averages performance across multiple different splits, producing a more robust and trustworthy estimate.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You evaluate your model on the test set, see disappointing results, then go back and adjust your model and re-evaluate on the SAME test set again. What problem does this create?',
        options: [
          'No problem, this is standard best practice',
          'The test set is no longer a true, unbiased measure of performance since it influenced your development decisions',
          'This always improves real-world performance',
          'It only matters for classification problems, not regression'
        ],
        correctIndex: 1,
        explanation:
            'Once you adjust your model based on test set results and re-evaluate, the test set has effectively become a second validation set, and its results no longer give an honest measure of true generalization performance.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You are building a model to predict next month\'s stock prices using 5 years of historical daily data. Should you randomly shuffle the data before splitting into train/test?',
        options: [
          'Yes, always shuffle randomly for any dataset',
          'No, time-series data should typically be split chronologically (train on earlier dates, test on later dates)',
          'It makes no difference for time-series data',
          'Shuffling is required by Scikit-learn and cannot be skipped'
        ],
        correctIndex: 1,
        explanation:
            'For time-series data, random shuffling can leak future information into training and creates an unrealistic evaluation. Chronological splitting better mimics real-world deployment, where you only have access to past data when predicting the future.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Proper Data Splitting & Cross-Validation Demo',
      goal:
          'Demonstrate correct train/validation/test splitting and cross-validation using Scikit-learn on a synthetic dataset.',
      steps: [
        'Create a synthetic dataset using NumPy with 200 samples and 1 feature, with a linear relationship to the target plus some noise',
        'Split the data into 70% training, 15% validation, and 15% test sets using train_test_split (called twice)',
        'Train a LinearRegression model on the training set only',
        'Evaluate the model on the validation set and print the score',
        'Run 5-fold cross-validation on the training set and print the average cross-validation score',
        'Only at the very end, evaluate the final model ONCE on the test set and print the final, honest performance score',
      ],
      expectedOutput:
          'Training set: 140 samples\nValidation set: 30 samples\nTest set: 30 samples\nValidation score: 0.94\nCross-validation average score: 0.93\nFinal test score (evaluated once): 0.95',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'overfitting_vs_underfitting',
    topicTitle: 'Overfitting vs Underfitting',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 150,
    emoji: '⚖️',
    intro:
        'Why does a model that performs perfectly on training data sometimes fail miserably in the real world? The answer lies in understanding Overfitting and Underfitting — two of the most fundamental and commonly encountered problems in Machine Learning.',
    concepts: [
      ConceptLesson(
        title: 'What is Overfitting?',
        definition:
            'Overfitting occurs when a model learns the training data too well — including its noise and random fluctuations — causing it to perform poorly on new, unseen data.',
        analogy:
            'Overfitting is like a student who memorizes the exact answers to specific textbook practice problems without understanding the underlying concepts — they ace the practice questions but fail any exam question phrased even slightly differently.',
        example:
            'A decision tree allowed to grow extremely deep might perfectly classify every single training example (100% training accuracy) but perform poorly on new data because it memorized noise rather than learning general patterns.',
        keyTakeaway:
            'The classic sign of overfitting is a large gap between excellent training performance and poor validation/test performance — the model has memorized rather than learned generalizable patterns.',
      ),
      ConceptLesson(
        title: 'What is Underfitting?',
        definition:
            'Underfitting occurs when a model is too simple to capture the underlying patterns in the data, resulting in poor performance on BOTH training and new data.',
        analogy:
            'Underfitting is like a student who barely studied at all — they perform poorly on both practice problems AND the real exam because they never learned the underlying concepts in the first place.',
        example:
            'Using a simple straight-line (linear) model to fit data that actually follows a complex curved pattern will result in poor accuracy on both training and test data, since the model is too simplistic to capture the true relationship.',
        keyTakeaway:
            'Unlike overfitting, underfitting shows poor performance EVERYWHERE — both training and validation/test scores will be disappointingly low, signaling the model needs more complexity or better features.',
      ),
      ConceptLesson(
        title: 'The Bias-Variance Tradeoff',
        definition:
            'Bias refers to error from overly simplistic assumptions (underfitting). Variance refers to error from excessive sensitivity to training data fluctuations (overfitting). Good models balance both.',
        analogy:
            'Imagine throwing darts at a target. High bias is like consistently throwing darts to the same WRONG spot (consistent but inaccurate). High variance is like throwing darts scattered wildly all over the board (inconsistent, unpredictable). The ideal is consistently hitting NEAR the bullseye.',
        example:
            'A very simple linear model has high bias (oversimplified) but low variance (consistent). A very complex deep decision tree has low bias (flexible) but high variance (sensitive to specific training examples).',
        keyTakeaway:
            'The goal of model building is finding the "sweet spot" of model complexity that minimizes BOTH bias and variance together — neither too simple (underfitting) nor too complex (overfitting).',
      ),
      ConceptLesson(
        title: 'Detecting Overfitting and Underfitting',
        definition:
            'You detect these problems by comparing training performance against validation performance: similar low scores indicate underfitting, while a large gap (high training, low validation) indicates overfitting.',
        analogy:
            'Comparing training vs validation scores is like comparing a student\'s practice test scores against their real exam scores — if both are low, they need to study more fundamentals (underfitting); if practice scores are great but real exam scores are poor, they memorized rather than understood (overfitting).',
        example:
            'Training accuracy = 98%, Validation accuracy = 65% → strong sign of overfitting. Training accuracy = 60%, Validation accuracy = 58% → sign of underfitting.',
        keyTakeaway:
            'Always track BOTH training and validation performance throughout model development — looking at training accuracy alone is one of the most common and dangerous mistakes beginners make.',
        codeSnippet:
            'from sklearn.metrics import accuracy_score\n\ntrain_acc = accuracy_score(y_train, model.predict(X_train))\nval_acc = accuracy_score(y_val, model.predict(X_val))\nprint(f"Train: {train_acc:.2f}, Validation: {val_acc:.2f}")\n\nif train_acc - val_acc > 0.15:\n    print("Warning: Possible overfitting detected")',
      ),
      ConceptLesson(
        title: 'Fixing Overfitting',
        definition:
            'Common solutions to overfitting include gathering more training data, simplifying the model, applying regularization, using cross-validation, and early stopping.',
        analogy:
            'Fixing overfitting is like teaching a student to understand CONCEPTS rather than memorize exact answers — exposing them to more varied practice problems, simplifying overly complex study notes, and stopping rote memorization in favor of genuine understanding.',
        example:
            'Regularization (like L2 penalty) discourages a model from relying too heavily on any single feature. Pruning a decision tree (limiting its maximum depth) prevents it from memorizing tiny, noisy details in the training data.',
        keyTakeaway:
            'There is no single universal fix for overfitting — the best approach typically combines getting more/better data, reducing model complexity, and applying appropriate regularization techniques.',
        codeSnippet:
            'from sklearn.tree import DecisionTreeClassifier\n\n# Overfitting-prone: unlimited depth\noverfit_model = DecisionTreeClassifier(max_depth=None)\n\n# Better: limited depth reduces overfitting risk\nregularized_model = DecisionTreeClassifier(max_depth=5)',
      ),
      ConceptLesson(
        title: 'Fixing Underfitting',
        definition:
            'Common solutions to underfitting include using a more complex model, adding more relevant features, reducing regularization, and training for longer (more iterations/epochs).',
        analogy:
            'Fixing underfitting is like helping a student who barely studied — giving them more comprehensive study materials, more time to learn, and a deeper curriculum that actually covers the complexity of the real exam.',
        example:
            'Switching from a simple Linear Regression to a more flexible model like a Random Forest, or adding polynomial features to capture non-linear relationships, can help resolve underfitting.',
        keyTakeaway:
            'If both your training AND validation scores are poor, the fix is almost always to INCREASE model complexity or improve your features — not to add more regularization, which would make underfitting worse.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the classic sign of overfitting?',
        options: [
          'Poor performance on both training and validation data',
          'Excellent training performance but poor validation/test performance',
          'Excellent performance on both training and validation data',
          'The model fails to run entirely'
        ],
        correctIndex: 1,
        explanation:
            'Overfitting shows a clear gap: the model performs very well on training data (which it has memorized) but poorly on new, unseen validation/test data.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'In the bias-variance tradeoff, what does "high bias" typically indicate?',
        options: [
          'The model is too complex and memorizing noise',
          'The model is too simple and making overly simplistic assumptions, leading to underfitting',
          'The model has perfect accuracy',
          'Bias has no relationship to model performance'
        ],
        correctIndex: 1,
        explanation:
            'High bias refers to error from oversimplified assumptions in a model, which is the underlying cause of underfitting — the model fails to capture the true complexity of the data.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'If both training accuracy and validation accuracy are low (e.g. 55% and 53%), what problem does this most likely indicate?',
        options: [
          'Overfitting',
          'Underfitting',
          'Perfect model performance',
          'Data leakage'
        ],
        correctIndex: 1,
        explanation:
            'Consistently poor performance on BOTH training and validation data indicates underfitting — the model is too simple to capture the underlying patterns even in the training data itself.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A deep decision tree achieves 99% accuracy on training data but only 62% on validation data. What is the BEST fix?',
        options: [
          'Increase the tree depth even further',
          'Limit the tree\'s maximum depth (regularization) or gather more training data to reduce overfitting',
          'Remove the validation set entirely',
          'This is not actually a problem'
        ],
        correctIndex: 1,
        explanation:
            'This is a textbook overfitting scenario. Limiting tree depth (a form of regularization) or providing more diverse training data are standard, effective fixes for overfitting.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A simple linear regression model achieves poor R² scores on BOTH training (0.40) and test (0.38) data for a dataset with an obviously curved (non-linear) relationship. What is the BEST fix?',
        options: [
          'Add stronger regularization to the linear model',
          'Use a more complex model (e.g. polynomial features or a non-linear algorithm) to better capture the curved relationship',
          'Remove more training data',
          'The model cannot be improved further'
        ],
        correctIndex: 1,
        explanation:
            'Consistently poor performance on both sets indicates underfitting. Since the true relationship is non-linear, increasing model complexity (e.g. polynomial features or a more flexible algorithm) is the appropriate fix.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Overfitting & Underfitting Detector',
      goal:
          'Build and compare 3 models of varying complexity on the same dataset to demonstrate underfitting, good fit, and overfitting.',
      steps: [
        'Create a synthetic NumPy dataset with a non-linear (e.g. quadratic) relationship plus some noise',
        'Split the data into training and test sets',
        'Train Model A: an underfit model (e.g. simple linear regression on the non-linear data)',
        'Train Model B: a well-fit model (e.g. polynomial regression with an appropriate degree)',
        'Train Model C: an overfit model (e.g. polynomial regression with an excessively high degree)',
        'Print training and test scores (e.g. R²) for all 3 models and write a short conclusion identifying which model exhibits underfitting, good fit, and overfitting',
      ],
      expectedOutput:
          'Model A (Linear): Train R²=0.45, Test R²=0.43 -> Underfitting\nModel B (Degree 2): Train R²=0.92, Test R²=0.90 -> Good fit\nModel C (Degree 15): Train R²=0.99, Test R²=0.40 -> Overfitting',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'build_first_ml_model',
    topicTitle: 'Build Your First Machine Learning Model',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 40,
    totalXp: 200,
    emoji: '🚀',
    intro:
        'This is the moment everything in this level has been building toward — you will now build, train, evaluate, and use your very first complete Machine Learning model from start to finish using Python, Pandas, and Scikit-learn.',
    concepts: [
      ConceptLesson(
        title: 'Putting It All Together: The Full ML Workflow',
        definition:
            'Building a real ML model combines everything from this level: understanding the problem type, preprocessing data, engineering features, splitting data correctly, training a model, and evaluating it honestly.',
        analogy:
            'This is like a chef finally cooking a complete meal after individually mastering chopping, seasoning, and cooking techniques separately — now you combine every skill into one complete, working dish.',
        example:
            'Building a student performance predictor combines: loading data (Pandas), cleaning missing values, encoding categories, splitting train/test, training a model (Scikit-learn), and evaluating accuracy — the entire pipeline from this level.',
        keyTakeaway:
            'Real-world ML projects rarely use just ONE isolated skill — they require combining data handling, preprocessing, modeling, and evaluation together into a single coherent, end-to-end workflow.',
      ),
      ConceptLesson(
        title: 'Step 1 & 2: Load and Explore Your Data',
        definition:
            'Every ML project begins with loading the dataset (often with Pandas) and exploring it to understand its structure, types, and any quality issues before doing anything else.',
        analogy:
            'Loading and exploring data is like reading the recipe and checking your ingredients are fresh BEFORE you start cooking — skipping this step leads to mistakes discovered too late in the process.',
        example:
            'pd.read_csv("students.csv") loads the data. df.info(), df.describe(), and df.isnull().sum() reveal data types, summary statistics, and missing values respectively.',
        keyTakeaway:
            'Never skip the exploration step — understanding your data\'s shape, types, and quality issues upfront saves enormous debugging time later in the modeling process.',
        codeSnippet:
            'import pandas as pd\n\ndf = pd.read_csv("students.csv")\nprint(df.shape)\nprint(df.head())\nprint(df.info())\nprint(df.isnull().sum())',
      ),
      ConceptLesson(
        title: 'Step 3 & 4: Preprocess and Split the Data',
        definition:
            'After exploring, you clean missing values, encode categorical features, separate input features (X) from the target label (y), and split into training and test sets.',
        analogy:
            'This step is like prepping all ingredients and dividing your cooking session into "practice runs" and a "final dinner service" — getting everything ready and organized before the actual model training begins.',
        example:
            'X = df.drop("final_grade", axis=1) separates features. y = df["final_grade"] isolates the target. train_test_split(X, y, test_size=0.2) creates your training and test sets.',
        keyTakeaway:
            'Clearly separating your features (X) from your target (y) BEFORE splitting is essential — confusing this order is one of the most common beginner mistakes in Scikit-learn workflows.',
        codeSnippet:
            'from sklearn.model_selection import train_test_split\n\nX = df.drop("final_grade", axis=1)\ny = df["final_grade"]\n\nX_train, X_test, y_train, y_test = train_test_split(\n    X, y, test_size=0.2, random_state=42\n)',
      ),
      ConceptLesson(
        title: 'Step 5: Train Your Model',
        definition:
            'With clean, split data ready, you instantiate a Scikit-learn model and call .fit() on the training data to let it learn the underlying patterns.',
        analogy:
            'This is the moment of actual "learning" — like a student finally sitting down to study using their prepared notes, absorbing the patterns that will help them on the upcoming real exam.',
        example:
            'For predicting a continuous grade: model = LinearRegression(); model.fit(X_train, y_train). For predicting pass/fail: model = LogisticRegression(); model.fit(X_train, y_train).',
        keyTakeaway:
            'Training (.fit()) is often the simplest line of code in the entire ML pipeline — all the real complexity and effort lives in the preprocessing steps that come before it.',
        codeSnippet:
            'from sklearn.linear_model import LinearRegression\n\nmodel = LinearRegression()\nmodel.fit(X_train, y_train)\nprint("Model trained successfully!")',
      ),
      ConceptLesson(
        title: 'Step 6: Evaluate and Interpret Results',
        definition:
            'After training, you use the model to predict on the test set and calculate appropriate evaluation metrics to honestly measure how well it generalizes to new, unseen data.',
        analogy:
            'This is the "final exam" moment — checking exactly how well the student (model) actually performs on questions (test data) they have genuinely never seen before, giving an honest measure of true learning.',
        example:
            'predictions = model.predict(X_test); from sklearn.metrics import mean_squared_error, r2_score; print(r2_score(y_test, predictions)) tells you how well your regression model performs.',
        keyTakeaway:
            'A model is only as valuable as your ability to honestly evaluate and interpret its real-world performance — always report test set metrics, never just training accuracy.',
        codeSnippet:
            'from sklearn.metrics import r2_score, mean_squared_error\n\npredictions = model.predict(X_test)\nr2 = r2_score(y_test, predictions)\nmse = mean_squared_error(y_test, predictions)\nprint(f"R² Score: {r2:.3f}")\nprint(f"MSE: {mse:.3f}")',
      ),
      ConceptLesson(
        title: 'From First Model to Real AI Engineer',
        definition:
            'Completing your first end-to-end ML model marks the transition from learning isolated concepts to practicing genuine AI engineering — and this same exact workflow scales up to far more complex, real-world projects.',
        analogy:
            'Building your first complete model is like a pilot completing their first solo flight — every advanced flight they will ever take afterward uses the exact same fundamental skills, just applied to bigger, more complex aircraft and routes.',
        example:
            'The same workflow (load → explore → preprocess → split → train → evaluate) used for a simple student grade predictor scales directly to training massive production models for fraud detection, medical diagnosis, or recommendation systems.',
        keyTakeaway:
            'You now possess the complete, fundamental skillset of practical Machine Learning — every advanced topic you learn from here forward builds directly on this exact same end-to-end workflow.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the correct general order of steps in a basic ML workflow?',
        options: [
          'Train model, load data, split data, evaluate',
          'Load data, explore data, preprocess data, split data, train model, evaluate model',
          'Evaluate model, train model, load data',
          'Split data, load data, evaluate, preprocess'
        ],
        correctIndex: 1,
        explanation:
            'The standard ML workflow flows from loading and exploring data, through preprocessing and splitting, to training and finally honest evaluation of the model.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'In Scikit-learn, what does X typically represent and what does y represent?',
        options: [
          'X represents the target label; y represents the input features',
          'X represents the input features; y represents the target label',
          'X and y are always identical',
          'X and y refer only to coordinates in a graph'
        ],
        correctIndex: 1,
        explanation:
            'By Scikit-learn convention, X represents the input feature matrix (what the model uses to make predictions), and y represents the target label (what the model is trying to predict).',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should you evaluate your model on the test set rather than just reporting training accuracy?',
        options: [
          'Training accuracy is always identical to test accuracy',
          'Test set evaluation gives an honest measure of how the model performs on genuinely new, unseen data',
          'Test set evaluation is optional and rarely matters',
          'Training accuracy is more important than test accuracy'
        ],
        correctIndex: 1,
        explanation:
            'Training accuracy only shows how well a model memorized the data it already saw. Test set evaluation reveals true generalization performance on unseen data, which is what actually matters in real-world use.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You have a DataFrame df with a target column "passed" (0 or 1) and several feature columns. Which line correctly separates the target from the features?',
        options: [
          'X = df["passed"]; y = df.drop("passed", axis=1)',
          'X = df.drop("passed", axis=1); y = df["passed"]',
          'X = df; y = df',
          'X = df.dropna(); y = df.fillna(0)'
        ],
        correctIndex: 1,
        explanation:
            'X should contain all feature columns (everything EXCEPT the target), achieved with df.drop("passed", axis=1), while y should isolate just the target column, df["passed"].',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'After training a classification model, which Scikit-learn metric would you use to measure the percentage of correct predictions on the test set?',
        options: [
          'mean_squared_error',
          'r2_score',
          'accuracy_score',
          'silhouette_score'
        ],
        correctIndex: 2,
        explanation:
            'accuracy_score is the standard Scikit-learn metric for measuring the percentage of correct predictions in a classification task. MSE and R² are regression metrics; silhouette_score is for unsupervised clustering.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Complete End-to-End Machine Learning Model',
      goal:
          'Build, train, and evaluate your first complete machine learning model from raw data to final performance report, using Python, Pandas, NumPy, and Scikit-learn.',
      steps: [
        'Create a synthetic Pandas DataFrame of 100 students with features: study_hours, attendance_percentage, previous_grade, and a target column final_grade (numeric)',
        'Explore the dataset: print shape, check for missing values, and print summary statistics',
        'Preprocess the data: handle any missing values and scale numeric features using StandardScaler',
        'Separate features (X) and target (y), then split into training and test sets (80/20) using train_test_split',
        'Train a LinearRegression model on the training data',
        'Evaluate the model on the test set using R² score and Mean Squared Error, then predict the final grade for one new, custom student example',
        'Print a final summary report including dataset shape, evaluation metrics, and the new student prediction',
      ],
      expectedOutput:
          '=== FIRST MACHINE LEARNING MODEL ===\nDataset shape: (100, 4)\nMissing values handled: 0 remaining\nModel trained successfully.\nR² Score: 0.91\nMean Squared Error: 18.4\nPredicted final grade for new student: 82.3\n\nCongratulations — you built your first complete ML model!',
      xpReward: 100,
    ),
  ),
];
