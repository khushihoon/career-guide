import '../../models/course_content_data.dart';

const List<TopicCourse> dataScientistLevel5 = [

  TopicCourse(
    id: 'ml_workflow_sklearn_ds5',
    topicTitle: 'ML Workflow & Scikit-learn',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 35,
    totalXp: 160,
    emoji: '⚙️',
    intro: 'Welcome to Level 5 — you are now officially entering machine learning. Every model you will ever build follows the same underlying workflow, and scikit-learn is the library that makes that workflow consistent across dozens of algorithms. Master this pattern once, and every future model becomes familiar.',
    concepts: [
      ConceptLesson(
        title: 'The Universal Estimator Interface',
        definition: 'Every scikit-learn model shares the same interface: .fit(X, y) trains the model on data, .predict(X) generates predictions, and .score(X, y) evaluates performance — this consistency means switching between algorithms requires changing almost no surrounding code.',
        analogy: 'The scikit-learn interface is like a universal remote control that works identically across every TV brand — press "power" and it turns on, regardless of manufacturer. Whether you use a decision tree or a linear model, .fit() always means "learn from this data," making the underlying algorithm swappable without rewriting your pipeline.',
        example: 'Switching from LinearRegression() to RandomForestRegressor() in an existing pipeline requires changing exactly one line — model = RandomForestRegressor() — because both objects expose the identical .fit()/.predict() interface, letting you experiment with different algorithms rapidly.',
        keyTakeaway: 'Once you understand fit/predict/score, you already know how to use hundreds of scikit-learn algorithms — the interface is the same whether you are doing regression, classification, or clustering. This consistency is scikit-learn\'s single biggest design strength.',
        codeSnippet: 'from sklearn.linear_model import LinearRegression\nfrom sklearn.ensemble import RandomForestRegressor\nimport numpy as np\n\nX = np.array([[1],[2],[3],[4],[5]])\ny = np.array([2,4,6,8,10])\n\nfor model in [LinearRegression(), RandomForestRegressor()]:\n    model.fit(X, y)          # same call for both\n    print(type(model).__name__, model.predict([[6]]))',
      ),
      ConceptLesson(
        title: 'Pipelines: Chaining Preprocessing and Modeling',
        definition: 'A scikit-learn Pipeline bundles preprocessing steps (scaling, encoding) and a final model into a single object — ensuring the exact same transformations are applied consistently to training and future data, and preventing common data leakage mistakes.',
        analogy: 'A Pipeline is like an assembly line where raw material enters one end and a finished product exits the other, with every station (scaling, encoding, prediction) applied automatically in the correct fixed order — you never accidentally skip a station or apply it out of sequence.',
        example: 'Pipeline([("scaler", StandardScaler()), ("model", LogisticRegression())]) lets you call .fit(X_train, y_train) once, and both scaling and model training happen correctly in sequence — then .predict(X_new) automatically applies the same fitted scaler before predicting, with zero risk of forgetting a step.',
        keyTakeaway: 'Pipelines are the professional standard for any real ML project — they eliminate an entire class of bugs where preprocessing is accidentally applied inconsistently between training and deployment, which is one of the most common production ML failures.',
        codeSnippet: 'from sklearn.pipeline import Pipeline\nfrom sklearn.preprocessing import StandardScaler\nfrom sklearn.linear_model import LogisticRegression\n\npipeline = Pipeline([\n    ("scaler", StandardScaler()),\n    ("model", LogisticRegression())\n])\n\npipeline.fit(X_train, y_train)     # scales then fits, in order\npredictions = pipeline.predict(X_test)  # scales then predicts, in order',
      ),
      ConceptLesson(
        title: 'Train/Test Split and the Golden Rule',
        definition: 'train_test_split() divides data into a training set (the model learns from this) and a test set (used only for final honest evaluation) — the golden rule of machine learning is that the test set must never influence any decision made during model development.',
        analogy: 'The train/test split is like studying from a textbook (training set) and then taking a final exam with genuinely new questions (test set) — if you accidentally saw the exam questions while studying, your exam score would no longer honestly reflect how much you actually learned.',
        example: 'Splitting 1000 customer records into 800 training and 200 test rows, training a churn model only on the 800, and evaluating final accuracy only on the untouched 200 gives an honest estimate of how the model will perform on genuinely new customers it has never seen.',
        keyTakeaway: 'random_state parameter ensures your split is reproducible across runs. stratify=y is essential for classification with imbalanced classes — it ensures both train and test sets maintain the same proportion of each class as the full dataset.',
        codeSnippet: 'from sklearn.model_selection import train_test_split\n\nX_train, X_test, y_train, y_test = train_test_split(\n    X, y, test_size=0.2, random_state=42, stratify=y)\nprint(f"Train: {len(X_train)}, Test: {len(X_test)}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main advantage of scikit-learn\'s consistent fit/predict interface across different algorithms?',
        options: [
          'It makes every algorithm produce identical predictions',
          'It allows you to swap between different algorithms (e.g., LinearRegression to RandomForestRegressor) with minimal code changes, since every estimator shares the same .fit() and .predict() methods',
          'It eliminates the need for any data preprocessing',
          'It only works for classification problems, not regression'
        ],
        correctIndex: 1,
        explanation: 'The shared interface means the surrounding code (data prep, evaluation, pipeline structure) stays the same regardless of which specific algorithm object you plug in — only the model constructor line typically needs to change.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why must the test set remain completely untouched during model development, including preprocessing decisions?',
        options: [
          'Test sets are only needed for very large datasets',
          'Any influence from the test set during development (including fitting scalers or making feature choices based on it) causes data leakage, producing an overly optimistic and dishonest estimate of real-world performance',
          'The test set is only used to make the final report look longer',
          'Scikit-learn automatically prevents any test set leakage regardless of how the code is written'
        ],
        correctIndex: 1,
        explanation: 'The entire purpose of a test set is to simulate genuinely unseen future data — any leakage, however subtle, compromises this and gives a falsely optimistic sense of how well the model will actually perform in production.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You are building a pipeline that scales numeric features before feeding them to a logistic regression model. What is the correct way to structure this in scikit-learn?',
        options: [
          'Manually scale the data with StandardScaler, then separately call LogisticRegression().fit() on the scaled data, keeping the two steps completely disconnected',
          'Use Pipeline([("scaler", StandardScaler()), ("model", LogisticRegression())]) so both steps are bundled and consistently applied together during fit and predict',
          'Skip scaling entirely since logistic regression does not need it',
          'Apply StandardScaler separately to the training and test sets by fitting on each independently'
        ],
        correctIndex: 1,
        explanation: 'Bundling into a Pipeline ensures the exact same fitted scaling transformation is consistently applied during both training and future prediction — manually chaining steps separately risks inconsistency and is the more error-prone approach.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'First End-to-End ML Pipeline',
      goal: 'Build a complete, correctly structured machine learning pipeline from raw data through evaluation, demonstrating the full scikit-learn workflow.',
      steps: [
        'Simulate a dataset of 300 samples with 4 numeric features and a binary target variable using NumPy.',
        'Split the data into train (80%) and test (20%) sets using train_test_split with a fixed random_state.',
        'Build a Pipeline combining StandardScaler and LogisticRegression.',
        'Fit the pipeline on the training data only, then generate predictions on the test set.',
        'Print training accuracy and test accuracy, and explain in a short comment whether there is a meaningful gap between them.',
      ],
      expectedOutput: 'Pipeline correctly built and fitted only on training data. Train and test accuracy both printed, with a correct interpretation of any gap between them (indicating overfitting or good generalization).',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'linear_regression_ds5',
    topicTitle: 'Linear Regression',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 35,
    totalXp: 160,
    emoji: '📈',
    intro: 'Linear regression is the simplest, most interpretable, and most widely used predictive model in existence — and understanding it deeply teaches concepts (coefficients, residuals, assumptions) that carry forward into every more complex model you will learn later in this path.',
    concepts: [
      ConceptLesson(
        title: 'The Linear Regression Equation',
        definition: 'Linear regression models the relationship between input features and a continuous target as a weighted sum: y = b0 + b1*x1 + b2*x2 + ... + bn*xn, where each coefficient represents how much the target changes per unit increase in that feature, holding others constant.',
        analogy: 'Linear regression is like a recipe formula for predicting a cake\'s sweetness: base sweetness + (sugar_grams × sugar_effect) + (fruit_count × fruit_effect) — each ingredient contributes a fixed, additive amount to the final prediction, and the coefficients tell you exactly how much each ingredient matters.',
        example: 'A house price model: price = 500000 + 8000*sqft + 200000*bedrooms means each additional square foot adds ₹8,000 to predicted price, and each additional bedroom adds ₹200,000 — these coefficients are directly interpretable business insights, not just prediction machinery.',
        keyTakeaway: 'The coefficient interpretation ("holding all other features constant") is the single most important and most commonly misunderstood aspect of linear regression — a coefficient describes the isolated effect of one feature, assuming everything else stays fixed.',
        codeSnippet: 'from sklearn.linear_model import LinearRegression\nimport numpy as np\n\nX = np.array([[1000,2],[1500,3],[2000,3],[1200,2]])  # sqft, bedrooms\ny = np.array([50,75,95,60])   # price in lakhs\n\nmodel = LinearRegression()\nmodel.fit(X, y)\nprint(f"Intercept: {model.intercept_:.2f}")\nprint(f"Coefficients (sqft, bedrooms): {model.coef_}")',
      ),
      ConceptLesson(
        title: 'Residuals and Ordinary Least Squares',
        definition: 'A residual is the difference between the actual value and the model\'s prediction for each data point. Ordinary Least Squares (OLS) is the standard method that finds the line minimizing the sum of squared residuals across the entire dataset.',
        analogy: 'Fitting a regression line is like finding the single straight rope that, when stretched through a scattered field of pegs, minimizes the total squared distance from every peg to the rope — squaring the distances means being far off any single peg is penalized much more heavily than being slightly off many pegs.',
        example: 'If a model predicts a house price of ₹52 lakh but the actual sale was ₹58 lakh, the residual is ₹6 lakh. OLS finds the coefficients that make the sum of all such squared residuals across every house in the training data as small as mathematically possible.',
        keyTakeaway: 'Residuals should show no obvious pattern when plotted against predictions — a clear pattern (like a curve or funnel shape) signals that the linear model is missing something important, such as a non-linear relationship the model cannot capture.',
        codeSnippet: 'from sklearn.linear_model import LinearRegression\nimport numpy as np\n\nX = np.array([[1],[2],[3],[4],[5]])\ny = np.array([2.1, 3.9, 6.2, 7.8, 10.1])\n\nmodel = LinearRegression().fit(X, y)\npredictions = model.predict(X)\nresiduals = y - predictions\nprint("Residuals:", residuals.round(2))',
      ),
      ConceptLesson(
        title: 'Regularization: Ridge and Lasso',
        definition: 'Ridge (L2) and Lasso (L1) regression add a penalty term to the standard loss function that discourages excessively large coefficients — reducing overfitting, and in Lasso\'s case, shrinking unimportant feature coefficients all the way to exactly zero (automatic feature selection).',
        analogy: 'Regularization is like a budget constraint on a shopping trip — without a limit, you might overspend wildly on a few items (huge coefficients fitting noise); a spending cap forces more balanced, restrained choices across all items, producing a more generalizable outcome that works well beyond just this one trip.',
        example: 'A model with 50 features where only 10 are truly predictive: Lasso regression will often shrink the coefficients of the 40 unhelpful features to exactly zero, effectively performing automatic feature selection while Ridge would shrink them toward zero but rarely to exactly zero.',
        keyTakeaway: 'Use Ridge when you believe most features contribute somewhat and want to prevent any single one from dominating. Use Lasso when you suspect many features are irrelevant and want automatic feature selection built into the model itself.',
        codeSnippet: 'from sklearn.linear_model import Ridge, Lasso\nimport numpy as np\n\nX = np.random.randn(100, 20)\ny = X[:, 0] * 3 + X[:, 1] * 2 + np.random.randn(100) * 0.5\n\nridge = Ridge(alpha=1.0).fit(X, y)\nlasso = Lasso(alpha=0.1).fit(X, y)\nprint(f"Ridge nonzero coefs: {(ridge.coef_ != 0).sum()}")\nprint(f"Lasso nonzero coefs: {(lasso.coef_ != 0).sum()}")  # fewer - some zeroed',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'In a linear regression model predicting salary from years_experience and education_level, the coefficient for years_experience is 45000. What does this mean?',
        options: [
          'Every employee earns exactly ₹45,000',
          'Holding education_level constant, each additional year of experience is associated with an estimated ₹45,000 increase in predicted salary',
          'The model is 45000% accurate',
          'years_experience has no real effect on salary'
        ],
        correctIndex: 1,
        explanation: 'A linear regression coefficient represents the isolated effect of that one feature on the target, assuming all other features in the model remain fixed — this "holding constant" interpretation is essential to reading coefficients correctly.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the key practical difference between Ridge and Lasso regression?',
        options: [
          'Ridge and Lasso are identical in every practical respect',
          'Lasso (L1) can shrink irrelevant feature coefficients all the way to exactly zero, effectively performing feature selection, while Ridge (L2) shrinks coefficients toward zero but rarely to exactly zero',
          'Ridge is only usable for classification problems',
          'Lasso always produces higher accuracy than Ridge on every dataset'
        ],
        correctIndex: 1,
        explanation: 'This is the defining practical distinction — Lasso\'s L1 penalty can zero out coefficients entirely (automatic feature selection), while Ridge\'s L2 penalty shrinks all coefficients somewhat but keeps them nonzero.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A residual plot (residuals vs predicted values) shows a clear curved, U-shaped pattern rather than random scatter. What does this suggest?',
        options: [
          'The model is performing perfectly and needs no changes',
          'The relationship between features and target is likely non-linear, and a simple linear model is systematically missing this curvature — a non-linear model or transformed features may be needed',
          'The dataset must have too many rows',
          'This pattern always indicates a coding error, never a modeling issue'
        ],
        correctIndex: 1,
        explanation: 'A patterned (non-random) residual plot is a diagnostic signal that the linear model\'s assumptions are violated — most commonly indicating an unmodeled non-linear relationship that the straight-line fit cannot capture.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'House Price Prediction with Regularized Regression',
      goal: 'Build and compare standard, Ridge, and Lasso linear regression models on a simulated housing dataset, interpreting coefficients and diagnosing fit quality.',
      steps: [
        'Simulate a housing dataset (n=300) with 8 features (some genuinely predictive, some pure noise) and a continuous price target.',
        'Split into train/test sets and fit standard LinearRegression, Ridge, and Lasso models.',
        'Print and compare the coefficients across all three models, noting which features Lasso zeroes out.',
        'Compute residuals for the standard model on the test set and check for any obvious non-random pattern.',
        'Print a short written interpretation of the 3 largest coefficients from the standard model in plain business language.',
      ],
      expectedOutput: 'All three models correctly fit and compared. Lasso correctly zeroes out at least some noise-feature coefficients. Residual pattern correctly assessed. Coefficient interpretations are accurate and business-readable.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'logistic_regression_ds5',
    topicTitle: 'Logistic Regression',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 35,
    totalXp: 160,
    emoji: '🎯',
    intro: 'Most real business questions are yes/no: will this customer churn, is this transaction fraudulent, will this loan default? Logistic regression is the foundational classification algorithm that answers these questions with interpretable, probability-based predictions.',
    concepts: [
      ConceptLesson(
        title: 'From Linear Output to Probability: The Sigmoid Function',
        definition: 'Logistic regression takes a linear combination of features and passes it through the sigmoid function, which squashes any real number into a value between 0 and 1 — interpretable directly as a probability of the positive class.',
        analogy: 'The sigmoid function is like a dimmer switch that smoothly converts any raw input (however extreme) into a value between "fully off" and "fully on" — no matter how large or small the raw linear score, the sigmoid always outputs a sensible probability between 0 and 1.',
        example: 'A raw linear score of +5 for a customer might correspond to a sigmoid output of 0.99 (very likely to churn), while a score of -3 might correspond to 0.05 (very unlikely) — the sigmoid ensures these outputs are always valid, interpretable probabilities regardless of the raw score\'s magnitude.',
        keyTakeaway: 'Unlike linear regression, logistic regression coefficients affect the LOG-ODDS of the outcome, not the probability directly — this makes coefficient interpretation slightly less intuitive but still directionally clear: a positive coefficient increases the probability of the positive class.',
        codeSnippet: 'from sklearn.linear_model import LogisticRegression\nimport numpy as np\n\nX = np.array([[1],[2],[3],[8],[9],[10]])   # hours studied\ny = np.array([0,0,0,1,1,1])                 # passed exam\n\nmodel = LogisticRegression().fit(X, y)\nprobabilities = model.predict_proba(X)[:, 1]\nprint("P(pass):", probabilities.round(3))',
      ),
      ConceptLesson(
        title: 'Decision Threshold and Classification',
        definition: 'Logistic regression outputs a probability, which is converted into a class prediction (0 or 1) using a decision threshold — the default is 0.5, but this threshold can and should be adjusted based on the relative costs of false positives versus false negatives.',
        analogy: 'The decision threshold is like setting the sensitivity on a smoke detector — a lower threshold (more sensitive) catches more real fires but also triggers more false alarms; a higher threshold reduces false alarms but risks missing real fires. The "right" setting depends entirely on which mistake is more costly.',
        example: 'For a cancer screening model, missing a real case (false negative) is far more costly than a false alarm — so you might lower the decision threshold to 0.3 to catch more true positives, accepting more false positives as an acceptable tradeoff for that specific business context.',
        keyTakeaway: 'Never blindly use the default 0.5 threshold without considering the business cost of each error type — the appropriate threshold is a business decision informed by statistics, not a fixed technical default.',
        codeSnippet: 'from sklearn.linear_model import LogisticRegression\nimport numpy as np\n\nX = np.array([[1],[2],[3],[8],[9],[10]])\ny = np.array([0,0,0,1,1,1])\nmodel = LogisticRegression().fit(X, y)\n\nprobs = model.predict_proba(X)[:, 1]\nfor threshold in [0.3, 0.5, 0.7]:\n    preds = (probs >= threshold).astype(int)\n    print(f"Threshold {threshold}: predictions = {preds}")',
      ),
      ConceptLesson(
        title: 'Multiclass Classification',
        definition: 'Logistic regression extends beyond binary (yes/no) outcomes to multiclass problems (predicting one of 3+ categories) using strategies like one-vs-rest (training one binary classifier per class) or the softmax function (a direct multiclass generalization of sigmoid).',
        analogy: 'One-vs-rest multiclass classification is like holding separate elimination rounds — "is this Category A or not?", "is this Category B or not?" — for every category, then picking whichever round gave the highest confidence as the final answer.',
        example: 'Classifying customer support tickets into "Billing", "Technical", or "General" categories uses multiclass logistic regression — scikit-learn handles the one-vs-rest or softmax strategy automatically when you call .fit() on a target with more than 2 classes.',
        keyTakeaway: 'Scikit-learn\'s LogisticRegression automatically detects and handles multiclass targets without requiring any special multiclass-specific code from you — the same .fit()/.predict() interface works identically for binary and multiclass problems.',
        codeSnippet: 'from sklearn.linear_model import LogisticRegression\nimport numpy as np\n\nX = np.array([[1,2],[2,3],[8,8],[9,9],[15,2],[16,3]])\ny = np.array([0,0,1,1,2,2])   # 3 classes\n\nmodel = LogisticRegression(multi_class="ovr").fit(X, y)\nprint(model.predict([[8.5, 8.5]]))   # predicts class 1',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the role of the sigmoid function in logistic regression?',
        options: [
          'It removes outliers from the training data',
          'It converts the raw linear combination of features (which can be any real number) into a value between 0 and 1, interpretable as a probability',
          'It selects which features to include in the model',
          'It converts categorical features into numeric ones'
        ],
        correctIndex: 1,
        explanation: 'The sigmoid function is precisely what transforms an unbounded linear score into a bounded, interpretable probability — this is the core mechanism that distinguishes logistic regression from plain linear regression.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A hospital is building a model to flag patients at risk of a serious condition, where missing a true case is far worse than a false alarm. How should the decision threshold be adjusted from the default 0.5?',
        options: [
          'Increase the threshold above 0.5 to reduce false alarms as much as possible',
          'Lower the threshold below 0.5, making the model more sensitive to flag more potential cases as positive, accepting more false positives to reduce the risk of missing a true case',
          'The threshold should never be changed from 0.5 under any circumstances',
          'Threshold has no effect on which cases get flagged'
        ],
        correctIndex: 1,
        explanation: 'When false negatives (missed real cases) are more costly than false positives (false alarms), lowering the threshold makes the model flag more cases as positive, trading some false alarms for catching more true positives — the correct tradeoff for this specific cost structure.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A fraud detection model outputs probability 0.42 for a transaction, and the default threshold of 0.5 classifies it as "not fraud." The business considers missing fraud cases extremely costly. What is an appropriate next step?',
        options: [
          'Trust the default 0.5 threshold without question since it is the standard default',
          'Consider lowering the decision threshold (e.g., to 0.3) so that transactions with moderate fraud probability like 0.42 get flagged for review, reflecting the high cost of missing real fraud',
          'Immediately declare no transactions can ever be fraud below 0.5',
          'Threshold adjustments are not possible in logistic regression'
        ],
        correctIndex: 1,
        explanation: 'Given the high cost of missing fraud (false negatives), lowering the threshold to catch more borderline cases like 0.42 as flagged-for-review is a reasonable business-driven adjustment — the threshold should reflect the actual cost asymmetry of the two error types.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Customer Churn Prediction Model',
      goal: 'Build a logistic regression model to predict customer churn, correctly interpreting probabilities and choosing an appropriate decision threshold.',
      steps: [
        'Simulate a customer dataset (n=400) with features: tenure_months, monthly_spend, support_tickets, and a binary churned target, with realistic relationships built in.',
        'Split into train/test sets and fit a LogisticRegression model within a Pipeline that includes StandardScaler.',
        'Generate predicted probabilities (not just class labels) on the test set using predict_proba().',
        'Compare classification results at threshold 0.5 versus a lower threshold (0.3), printing how many customers are flagged as at-risk under each.',
        'Print the model coefficients and interpret the direction (positive/negative) of each feature\'s effect on churn probability in plain language.',
      ],
      expectedOutput: 'Model correctly fit and probabilities generated. Threshold comparison clearly shows the tradeoff in flagged customers. Coefficient interpretation is accurate and clearly explained in business terms.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'decision_trees_ds5',
    topicTitle: 'Decision Trees',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 150,
    emoji: '🌳',
    intro: 'Decision trees are the most intuitively explainable machine learning model — they make predictions through a series of simple yes/no questions, mirroring how humans naturally reason through decisions. They are also the building block for the powerful ensemble methods you will learn in Level 6.',
    concepts: [
      ConceptLesson(
        title: 'How Decision Trees Split Data',
        definition: 'A decision tree repeatedly splits the dataset into subgroups based on feature thresholds (e.g., "is age > 30?"), choosing at each step the split that most effectively separates the target classes — measured by metrics like Gini impurity or information gain.',
        analogy: 'A decision tree is like a doctor diagnosing a patient through a sequence of targeted questions: "Is your temperature above 38°C?" then, depending on the answer, "Do you have a cough?" — each question narrows down the possibilities, eventually arriving at a confident diagnosis (prediction).',
        example: 'A loan approval tree might first split on "credit_score > 650?" then split each resulting group further on "income > 500000?" — the tree automatically discovers which questions, asked in which order, best separate approved from rejected applicants in the historical training data.',
        keyTakeaway: 'Decision trees require zero feature scaling — because they split based on threshold comparisons, not distance calculations, the raw units and scale of features do not affect how the tree learns, unlike distance-based or gradient-based algorithms.',
        codeSnippet: 'from sklearn.tree import DecisionTreeClassifier\nimport numpy as np\n\nX = np.array([[650,500000],[720,300000],[580,700000],[800,900000]])\ny = np.array([0,1,0,1])   # loan rejected/approved\n\ntree = DecisionTreeClassifier(max_depth=3, random_state=42)\ntree.fit(X, y)\nprint(tree.predict([[700, 600000]]))',
      ),
      ConceptLesson(
        title: 'Overfitting in Trees: Depth and Pruning',
        definition: 'A decision tree grown without limits will keep splitting until every training example is perfectly classified — memorizing noise rather than learning general patterns. Controlling max_depth, min_samples_split, and min_samples_leaf prevents this overfitting.',
        analogy: 'An unlimited decision tree is like a student who memorizes the exact answer to every single practice question instead of understanding the underlying concept — they ace the practice test perfectly but fail on any new, slightly different question on the real exam.',
        example: 'A tree with max_depth=None might create a unique leaf for every single training customer, achieving 100% training accuracy but performing poorly on new customers — limiting max_depth=5 forces the tree to find genuinely general patterns instead of memorizing individual records.',
        keyTakeaway: 'Always compare training accuracy against test accuracy for a decision tree — a large gap (e.g., 99% train vs 70% test) is the clearest sign of overfitting, and the fix is almost always to constrain tree depth or leaf size, not to add more data alone.',
        codeSnippet: 'from sklearn.tree import DecisionTreeClassifier\nfrom sklearn.model_selection import train_test_split\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(200, 4)\ny = (X[:,0] + X[:,1] > 0).astype(int)\nX_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3)\n\nfor depth in [None, 3, 5]:\n    tree = DecisionTreeClassifier(max_depth=depth, random_state=42).fit(X_train, y_train)\n    print(f"depth={depth}: train={tree.score(X_train,y_train):.2f}, test={tree.score(X_test,y_test):.2f}")',
      ),
      ConceptLesson(
        title: 'Feature Importance from Trees',
        definition: 'Decision trees naturally compute feature importance — a score reflecting how much each feature contributed to reducing impurity across all splits in the tree, giving a direct, built-in measure of which variables mattered most to the model\'s decisions.',
        analogy: 'Feature importance is like reviewing a detective\'s case notes to see which clues they relied on most heavily to solve the case — some clues (features) were used in nearly every major decision point, while others barely factored in at all.',
        example: 'A customer churn tree might reveal that "support_tickets" has feature importance 0.45 (the single most influential factor), while "signup_channel" has importance 0.02 (barely used) — directly telling a business team where to focus retention efforts.',
        keyTakeaway: 'Feature importance is a fast, built-in way to understand what a tree-based model is actually paying attention to — always inspect it after training, both to gain business insight and to sanity-check that the model is not relying on an unexpected or spurious feature.',
        codeSnippet: 'from sklearn.tree import DecisionTreeClassifier\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(200, 4)\ny = (X[:,0] * 2 + X[:,2] > 0).astype(int)\ntree = DecisionTreeClassifier(max_depth=4, random_state=42).fit(X, y)\n\nfor i, importance in enumerate(tree.feature_importances_):\n    print(f"Feature {i}: {importance:.3f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why do decision trees not require feature scaling (unlike algorithms such as logistic regression or k-nearest neighbors)?',
        options: [
          'Decision trees automatically scale all features internally without you noticing',
          'Trees split data based on threshold comparisons on individual features one at a time, not on distances between points across all features simultaneously — so differing raw scales do not distort how splits are chosen',
          'Feature scaling is actually required for trees, and skipping it is always an error',
          'Trees can only handle already-scaled data as input'
        ],
        correctIndex: 1,
        explanation: 'Because a tree evaluates conditions like "feature > threshold" independently per feature, the relative scale between different features never enters into how a split is chosen — unlike distance-based methods where scale differences directly distort results.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A decision tree achieves 99% accuracy on training data but only 68% on test data. What does this large gap most likely indicate, and what is the standard fix?',
        options: [
          'The model is performing excellently and needs no changes',
          'The tree has overfit by growing too deep and memorizing training data noise — limiting max_depth or increasing min_samples_leaf typically helps close this gap',
          'The test set must be corrupted since a well-trained model should never underperform on test data',
          'Overfitting cannot occur with decision trees'
        ],
        correctIndex: 1,
        explanation: 'A large train-test accuracy gap is the classic signature of overfitting — the tree grew complex enough to memorize training noise rather than learning generalizable patterns, and constraining its depth/leaf size is the standard remedy.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A trained decision tree shows feature_importances_ of [0.02, 0.65, 0.01, 0.32] for features [signup_channel, support_tickets, referral_source, monthly_spend]. What can you conclude?',
        options: [
          'All four features contribute equally to the model\'s predictions',
          'support_tickets and monthly_spend are by far the most influential features in the model\'s decisions, while signup_channel and referral_source contribute very little',
          'signup_channel is the most important feature since it appears first in the list',
          'Feature importance values have no practical business meaning'
        ],
        correctIndex: 1,
        explanation: 'Higher feature_importances_ values directly indicate which features the tree relied on most heavily across its splits — here support_tickets (0.65) and monthly_spend (0.32) dominate, while the other two contribute almost nothing.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Interpretable Loan Approval Classifier',
      goal: 'Build a decision tree classifier for loan approval, tune its depth to avoid overfitting, and extract business-readable insights from feature importance.',
      steps: [
        'Simulate a loan applicant dataset (n=350) with features: credit_score, annual_income, existing_debt, years_employed, and a binary approved target with realistic relationships.',
        'Split into train/test sets, then train decision trees at several max_depth values (2, 4, 8, None) and compare train vs test accuracy for each.',
        'Select the depth that best balances accuracy and generalization, justifying the choice with the train/test comparison.',
        'Extract and print feature_importances_ for the chosen model, ranked from most to least important.',
        'Write a 3-4 sentence plain-language summary explaining which factors most influence loan approval according to the model.',
      ],
      expectedOutput: 'Depth comparison correctly identifies overfitting at unconstrained depth. Chosen model has a reasonable train/test gap. Feature importance correctly ranked and clearly interpreted in the written summary.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'random_forests_ds5',
    topicTitle: 'Random Forests',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 155,
    emoji: '🌲',
    intro: 'A single decision tree is prone to overfitting. A random forest — hundreds of trees voting together — is dramatically more robust, and it remains one of the most reliable, widely used algorithms in professional data science, often serving as a strong default baseline for tabular data.',
    concepts: [
      ConceptLesson(
        title: 'Why Many Trees Beat One: Ensemble Intuition',
        definition: 'A random forest trains many decision trees, each on a random subset of data (bagging) and a random subset of features per split, then combines their individual predictions by majority vote (classification) or averaging (regression) — this combination reduces the overfitting risk any single tree carries.',
        analogy: 'Asking one expert for a diagnosis carries the risk of their individual blind spots or biases. Asking 200 independent experts and taking the majority opinion smooths out any single expert\'s quirks — the "wisdom of the crowd" effect is exactly what a random forest exploits mathematically.',
        example: 'A single decision tree on customer data might overfit to a quirky pattern in a small subset of training customers. A forest of 200 trees, each seeing a slightly different random sample, is unlikely to unanimously agree on that same quirky pattern — the ensemble\'s majority vote naturally cancels out individual overfitting.',
        keyTakeaway: 'The key sources of randomness in a random forest — bootstrap sampling of rows (bagging) and random feature subsets per split — are both essential; removing either one significantly reduces the ensemble\'s ability to reduce overfitting compared to a single tree.',
        codeSnippet: 'from sklearn.ensemble import RandomForestClassifier\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(300, 5)\ny = (X[:,0] + X[:,2] > 0).astype(int)\n\nforest = RandomForestClassifier(n_estimators=200, max_depth=6, random_state=42)\nforest.fit(X, y)\nprint(f"Forest accuracy: {forest.score(X, y):.3f}")',
      ),
      ConceptLesson(
        title: 'Key Hyperparameters: n_estimators, max_depth, max_features',
        definition: 'n_estimators controls how many trees are grown (more trees generally improve stability but with diminishing returns and higher compute cost); max_depth limits individual tree complexity; max_features controls how many features are randomly considered at each split.',
        analogy: 'n_estimators is like deciding how many independent judges to consult before reaching a verdict — more judges generally produce a more stable, reliable consensus, but each additional judge beyond a certain point adds less and less new insight while still costing time.',
        example: 'Increasing n_estimators from 10 to 100 typically produces a noticeably more stable and accurate forest. Increasing from 500 to 1000 usually produces only marginal further improvement — most of the benefit is captured well before very large tree counts.',
        keyTakeaway: 'A common effective starting point is n_estimators=100-300, with max_depth left unconstrained or lightly limited (since the ensemble averaging already controls overfitting far better than a single deep tree would). max_features="sqrt" is scikit-learn\'s sensible default for classification.',
        codeSnippet: 'from sklearn.ensemble import RandomForestClassifier\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(300, 5)\ny = (X[:,0] + X[:,2] > 0).astype(int)\n\nfor n in [10, 50, 200]:\n    forest = RandomForestClassifier(n_estimators=n, random_state=42)\n    forest.fit(X, y)\n    print(f"n_estimators={n}: accuracy={forest.score(X, y):.3f}")',
      ),
      ConceptLesson(
        title: 'Out-of-Bag (OOB) Score: Free Validation',
        definition: 'Because each tree in a random forest is trained on a bootstrap sample (roughly two-thirds of the data), the remaining "out-of-bag" third can be used to evaluate that tree — averaging these out-of-bag predictions gives a built-in performance estimate without needing a separate validation set.',
        analogy: 'The OOB score is like getting a free practice exam grade using only the questions each individual study group member happened to skip during their own personalized review session — since every tree skips a different random subset, you get honest feedback without setting aside any additional data.',
        example: 'Setting oob_score=True when building a RandomForestClassifier gives you model.oob_score_ — an unbiased performance estimate computed "for free" from data each tree never saw during its own training, useful especially when data is limited and a full separate validation split feels wasteful.',
        keyTakeaway: 'OOB score is a convenient built-in sanity check but does not replace a proper held-out test set for final model evaluation — it is most useful during early experimentation when you want quick feedback without repeatedly re-splitting your data.',
        codeSnippet: 'from sklearn.ensemble import RandomForestClassifier\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(300, 5)\ny = (X[:,0] + X[:,2] > 0).astype(int)\n\nforest = RandomForestClassifier(n_estimators=200, oob_score=True, random_state=42)\nforest.fit(X, y)\nprint(f"OOB score: {forest.oob_score_:.3f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What are the two key sources of randomness that make a random forest more robust than a single decision tree?',
        options: [
          'Random forests use no randomness at all — the name is misleading',
          'Bootstrap sampling of rows (each tree sees a different random subset of data) and random feature subsets considered at each split — both introduce diversity among trees, whose combined vote reduces overfitting',
          'Random initial weights and random learning rates',
          'Randomly deleting half the dataset before training'
        ],
        correctIndex: 1,
        explanation: 'These two sources of randomness — row sampling (bagging) and feature subsampling per split — ensure individual trees make different mistakes, so their combined majority vote is far more stable than any single tree\'s predictions.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the out-of-bag (OOB) score provide, and why is it useful?',
        options: [
          'It measures how long the model took to train',
          'It provides a built-in, roughly unbiased performance estimate using the data each individual tree did not see during its own bootstrap training, without requiring a separate validation split',
          'It counts the total number of trees in the forest',
          'It is only relevant for regression problems, never classification'
        ],
        correctIndex: 1,
        explanation: 'Because each tree trains on a bootstrap sample that excludes roughly a third of the data, that excluded portion serves as a natural, "free" validation set for that tree — averaging these gives a convenient performance estimate.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You increase n_estimators from 100 to 1000 and observe only a tiny improvement in test accuracy, while training time increases significantly. What does this suggest?',
        options: [
          'The model is now broken and must be retrained from scratch',
          'The forest has likely reached diminishing returns from additional trees — accuracy gains from more estimators level off, so the extra compute cost may not be worth the marginal improvement',
          'More trees always guarantee proportionally better accuracy with no limit',
          'This indicates the dataset is too small to use a random forest at all'
        ],
        correctIndex: 1,
        explanation: 'Random forest performance typically improves with more trees up to a point, then plateaus — recognizing diminishing returns helps you choose a practical n_estimators value that balances accuracy against training/prediction cost.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Random Forest Model Comparison and Tuning',
      goal: 'Build a random forest classifier, compare it against a single decision tree baseline, and tune key hyperparameters using OOB score.',
      steps: [
        'Simulate a customer dataset (n=400) with 6 features and a binary target, with moderate noise built in.',
        'Train a single DecisionTreeClassifier and a RandomForestClassifier (both with default reasonable settings) and compare their test accuracy.',
        'Sweep n_estimators over [10, 50, 100, 300] and plot OOB score against n_estimators to visualize diminishing returns.',
        'Select a final n_estimators value based on the OOB curve, and print the top 5 features by importance from the final model.',
        'Write a short comparison summarizing why the forest outperformed (or matched) the single tree, referencing the ensemble intuition.',
      ],
      expectedOutput: 'Forest correctly outperforms or matches the single tree with better generalization. OOB curve clearly shows diminishing returns pattern. Feature importance correctly extracted and ranked. Written comparison correctly explains the ensemble benefit.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'knn_ds5',
    topicTitle: 'K-Nearest Neighbors',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 25,
    totalXp: 140,
    emoji: '📍',
    intro: 'K-Nearest Neighbors is the most intuitive algorithm in machine learning: to predict something about a new point, just look at what happened to the most similar points you have already seen. Simple to understand, surprisingly effective, and a great lens for understanding the importance of feature scaling and distance.',
    concepts: [
      ConceptLesson(
        title: 'The Core KNN Idea: Vote from Neighbors',
        definition: 'K-Nearest Neighbors makes a prediction for a new point by finding the K closest points in the training data (by distance) and taking a majority vote (classification) or average (regression) of their target values — there is no explicit "training" phase beyond storing the data.',
        analogy: 'KNN is like deciding what to order at an unfamiliar restaurant by asking the 5 nearby diners whose plates look most similar to what you usually enjoy — you go with whatever the majority of those similar-tasting diners chose, trusting that similar preferences predict a similar good outcome for you.',
        example: 'To predict whether a new customer will churn, KNN finds the 5 existing customers most similar to them (by tenure, spend, support tickets) and predicts churn if the majority of those 5 similar customers actually churned — no formula, just direct comparison to known similar cases.',
        keyTakeaway: 'KNN is called a "lazy learner" because it does no real computation during .fit() — it simply stores the training data and does all the actual work at prediction time by searching for nearest neighbors, making prediction slower than model-based algorithms as data grows.',
        codeSnippet: 'from sklearn.neighbors import KNeighborsClassifier\nimport numpy as np\n\nX = np.array([[1,2],[2,3],[8,8],[9,9],[1,1],[8,9]])\ny = np.array([0,0,1,1,0,1])\n\nknn = KNeighborsClassifier(n_neighbors=3)\nknn.fit(X, y)\nprint(knn.predict([[7, 8]]))   # closest neighbors are class 1',
      ),
      ConceptLesson(
        title: 'Why Feature Scaling Is Critical for KNN',
        definition: 'KNN relies entirely on distance calculations between points — if features have wildly different scales (income in lakhs vs age in years), the feature with naturally larger numbers dominates the distance calculation, effectively drowning out the other feature\'s influence.',
        analogy: 'Without scaling, computing distance with unscaled income and age is like measuring similarity between two people by combining "difference in height in millimeters" with "difference in age in centuries" — the millimeter measurement would completely swamp the tiny century numbers, even if age is actually more relevant.',
        example: 'Two customers with identical ages (25 vs 26) but very different incomes (₹50,000 vs ₹500,000) would appear "very different" in raw distance purely due to the income scale — after StandardScaler normalizes both features to comparable ranges, the true relative similarity becomes accurately reflected.',
        keyTakeaway: 'Always scale features before using KNN (or any distance-based algorithm) — this is one of the clearest, most concrete illustrations of why the feature scaling concept from Level 4 matters in practice, not just in theory.',
        codeSnippet: 'from sklearn.preprocessing import StandardScaler\nfrom sklearn.neighbors import KNeighborsClassifier\nimport numpy as np\n\nX = np.array([[25, 50000],[26, 500000],[40, 60000],[41, 520000]])\ny = np.array([0, 1, 0, 1])\n\nX_scaled = StandardScaler().fit_transform(X)   # essential before KNN\nknn = KNeighborsClassifier(n_neighbors=3).fit(X_scaled, y)',
      ),
      ConceptLesson(
        title: 'Choosing K: The Bias-Variance Tradeoff',
        definition: 'A small K (like 1) makes predictions highly sensitive to individual noisy points (high variance, overfitting), while a very large K smooths predictions so much they may ignore genuine local patterns (high bias, underfitting) — choosing K requires balancing these two failure modes.',
        analogy: 'Choosing K is like deciding how many neighbors to ask for restaurant advice — asking just 1 person (K=1) risks getting an unusual, unrepresentative opinion; asking the entire city (very large K) dilutes any useful local insight into a generic city-wide average that ignores your specific neighborhood\'s character.',
        example: 'With K=1, a single mislabeled or unusual training point can flip a prediction for any nearby new point. With K=50 in a dataset of 100 points, nearly half the entire dataset votes on every prediction, smoothing out almost all local structure — cross-validation typically reveals a "sweet spot" K value between these extremes.',
        keyTakeaway: 'Use cross-validation (covered later in this level) to systematically test a range of K values and select the one that generalizes best — there is no universal "correct" K; it depends entirely on the specific dataset\'s size and noise level.',
        codeSnippet: 'from sklearn.neighbors import KNeighborsClassifier\nfrom sklearn.model_selection import cross_val_score\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(200, 2)\ny = (X[:,0] + X[:,1] > 0).astype(int)\n\nfor k in [1, 5, 15, 50]:\n    scores = cross_val_score(KNeighborsClassifier(n_neighbors=k), X, y, cv=5)\n    print(f"K={k}: mean CV accuracy = {scores.mean():.3f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why is KNN sometimes called a "lazy learner"?',
        options: [
          'Because it produces inaccurate predictions',
          'Because it does not build an explicit model during .fit() — it simply stores the training data and performs all real computation (finding neighbors) at prediction time',
          'Because it only works with small datasets',
          'Because it requires no data at all to make predictions'
        ],
        correctIndex: 1,
        explanation: 'Unlike algorithms that learn explicit parameters during training (like regression coefficients), KNN defers all real work to prediction time, when it searches the stored training data for nearest neighbors — earning it the "lazy learner" description.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is feature scaling especially critical for KNN compared to, say, a decision tree?',
        options: [
          'Feature scaling is equally unimportant for both algorithms',
          'KNN relies directly on distance calculations across all features simultaneously, so unscaled features with larger raw ranges will dominate the distance metric — decision trees instead split one feature at a time regardless of scale',
          'Decision trees actually require MORE scaling than KNN',
          'Scaling is only relevant for text data, not for KNN'
        ],
        correctIndex: 1,
        explanation: 'KNN\'s distance-based nature makes it directly sensitive to the relative scale of features in a way that threshold-splitting trees are not — this is one of the clearest practical demonstrations of why scaling matters for certain algorithm families.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A KNN model with K=1 achieves 100% training accuracy but performs noticeably worse on test data than a model with K=15. What does this suggest?',
        options: [
          'K=1 is always the best choice since it achieves perfect training accuracy',
          'K=1 is likely overfitting to individual noisy training points (high variance), while K=15 smooths predictions using more neighbors, generalizing better to new data',
          'The test data must be corrupted since K=1 achieved perfect accuracy',
          'K value has no effect on how well a KNN model generalizes'
        ],
        correctIndex: 1,
        explanation: 'K=1 memorizes the exact training data (every point is its own nearest neighbor, guaranteeing 100% training accuracy) but is highly sensitive to noise — a moderate K like 15 typically generalizes better by averaging over a more representative local neighborhood.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'KNN Customer Similarity Classifier',
      goal: 'Build a properly scaled KNN classifier, demonstrate the impact of scaling, and select an appropriate K using cross-validation.',
      steps: [
        'Simulate a customer dataset (n=250) with 2 features on very different scales (e.g., age in years, income in rupees) and a binary target.',
        'Train a KNN classifier WITHOUT scaling and record its cross-validated accuracy.',
        'Train the same KNN classifier WITH StandardScaler applied first (using a Pipeline) and compare accuracy — demonstrating the scaling impact concretely.',
        'Sweep K over a range of values (1, 3, 5, 10, 20, 40) using cross_val_score and identify the best-performing K.',
        'Print a summary comparing scaled vs unscaled performance and stating the chosen optimal K with justification.',
      ],
      expectedOutput: 'Unscaled KNN clearly underperforms scaled KNN, demonstrating the scaling requirement concretely. K sweep correctly identifies a reasonable optimal value via cross-validation. Summary clearly explains both findings.',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'naive_bayes_ds5',
    topicTitle: 'Naive Bayes',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 25,
    totalXp: 140,
    emoji: '📧',
    intro: 'Naive Bayes is a fast, elegantly simple probabilistic classifier built directly on Bayes\' theorem from Level 3. Despite its "naive" independence assumption, it remains a genuinely strong baseline for text classification tasks like spam detection and sentiment analysis, and trains almost instantly even on large datasets.',
    concepts: [
      ConceptLesson(
        title: 'Bayes\' Theorem Applied to Classification',
        definition: 'Naive Bayes classifies a new example by computing P(class | features) using Bayes\' theorem — combining the prior probability of each class with the likelihood of observing the given features under that class, then picking the class with the highest resulting probability.',
        analogy: 'Naive Bayes reasoning mirrors a doctor updating a diagnosis: starting with a baseline likelihood of each possible condition (prior), then updating that belief based on observed symptoms (likelihood) to arrive at a final, evidence-informed probability for each possible diagnosis (posterior).',
        example: 'Classifying an email as spam: start with the prior P(spam) = 20% of all emails. Observing the word "free" appears, which is common in spam, updates the probability upward. Combining evidence from multiple words in the email produces a final posterior probability used to classify it.',
        keyTakeaway: 'The "naive" part of Naive Bayes is the assumption that all features are conditionally independent given the class — this assumption is almost never exactly true in reality, yet the algorithm performs surprisingly well in practice, especially for text classification.',
        codeSnippet: 'from sklearn.naive_bayes import MultinomialNB\nfrom sklearn.feature_extraction.text import CountVectorizer\n\nemails = ["win free money now", "meeting scheduled tomorrow", "free prize claim now", "project deadline tomorrow"]\nlabels = [1, 0, 1, 0]   # 1=spam, 0=not spam\n\nvectorizer = CountVectorizer()\nX = vectorizer.fit_transform(emails)\nmodel = MultinomialNB().fit(X, labels)\nprint(model.predict(vectorizer.transform(["free money today"])))',
      ),
      ConceptLesson(
        title: 'Variants: Gaussian, Multinomial and Bernoulli',
        definition: 'Different Naive Bayes variants assume different distributions for the features: GaussianNB assumes continuous features follow a normal distribution, MultinomialNB works with count data (like word frequencies), and BernoulliNB works with binary presence/absence features.',
        analogy: 'Choosing a Naive Bayes variant is like choosing the right measuring tool for the job — a thermometer (Gaussian) for continuous temperature readings, a tally counter (Multinomial) for counting word occurrences, and a checklist of yes/no boxes (Bernoulli) for simple presence/absence indicators.',
        example: 'Predicting flower species from continuous petal measurements uses GaussianNB. Classifying documents by word frequency counts uses MultinomialNB. Detecting spam based purely on whether specific keywords appear at all (regardless of count) uses BernoulliNB.',
        keyTakeaway: 'Matching the Naive Bayes variant to your actual data type is essential — using GaussianNB on word count data (which is not normally distributed and cannot be negative) would give poor, mismatched results compared to correctly using MultinomialNB.',
        codeSnippet: 'from sklearn.naive_bayes import GaussianNB\nimport numpy as np\n\n# Continuous features - GaussianNB is appropriate\nX = np.array([[5.1,3.5],[4.9,3.0],[7.0,3.2],[6.4,3.2]])\ny = np.array([0,0,1,1])\n\nmodel = GaussianNB().fit(X, y)\nprint(model.predict([[6.0, 3.1]]))',
      ),
      ConceptLesson(
        title: 'Naive Bayes for Text: Speed and Simplicity',
        definition: 'Naive Bayes is exceptionally fast to train (a single pass counting word frequencies per class) and requires relatively little training data compared to more complex models, making it a common first baseline for text classification tasks before trying more sophisticated approaches.',
        analogy: 'Naive Bayes for text classification is like a quick first-pass triage nurse — fast, simple, and surprisingly accurate for routine cases, even though a specialist (a more sophisticated model) might eventually be needed for the trickiest, most ambiguous edge cases.',
        example: 'A startup building a first spam filter can get a working, reasonably accurate MultinomialNB model running within minutes on a modest labeled dataset — providing an immediate baseline before investing time in more complex deep learning text models covered later in this path.',
        keyTakeaway: 'Always try Naive Bayes as a fast baseline for text classification problems — if it already performs well, you may not need a more complex (and slower, harder to interpret) model at all; if it underperforms, it still gives you a clear benchmark to beat.',
        codeSnippet: 'from sklearn.naive_bayes import MultinomialNB\nfrom sklearn.feature_extraction.text import TfidfVectorizer\nfrom sklearn.pipeline import Pipeline\n\ntexts = ["great product love it", "terrible waste of money", "amazing quality", "awful do not buy"]\nlabels = [1, 0, 1, 0]   # 1=positive, 0=negative\n\npipeline = Pipeline([("tfidf", TfidfVectorizer()), ("nb", MultinomialNB())])\npipeline.fit(texts, labels)\nprint(pipeline.predict(["really good quality"]))',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does the "naive" assumption in Naive Bayes refer to?',
        options: [
          'That the algorithm is too simple to ever be useful',
          'That all features are treated as conditionally independent of each other given the class — an assumption that is rarely exactly true but still often works well in practice',
          'That the model requires no training data whatsoever',
          'That the model only works for binary classification, never multiclass'
        ],
        correctIndex: 1,
        explanation: 'The independence assumption between features (given the class label) is what makes the probability calculation computationally simple — this assumption is technically "naive" because real features often do have some relationship, yet the model still performs well empirically.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'You are building a spam filter based on word frequency counts in each email. Which Naive Bayes variant is most appropriate?',
        options: [
          'GaussianNB, since it is the most commonly used variant overall',
          'MultinomialNB, since it is specifically designed for count-based data like word frequencies',
          'Any variant works identically well regardless of data type',
          'BernoulliNB, since spam filtering always requires binary features'
        ],
        correctIndex: 1,
        explanation: 'MultinomialNB is specifically designed for count data (like how many times each word appears) — GaussianNB assumes continuous normally-distributed data, which does not match word count data well.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You need a fast first-pass baseline model for classifying thousands of customer support tickets by topic using their text content, before investing time in a more complex model. What is a reasonable first choice?',
        options: [
          'Skip building any baseline and go straight to the most complex model available',
          'Build a MultinomialNB or TF-IDF + Naive Bayes pipeline as a fast, simple baseline — establishing a benchmark accuracy before considering more complex approaches',
          'Naive Bayes cannot be used for any text classification task',
          'Wait until a deep learning model is available before attempting any classification'
        ],
        correctIndex: 1,
        explanation: 'Naive Bayes is specifically valued as a fast, low-effort baseline for text classification — establishing this benchmark first is standard practice before investing in more complex, slower-to-train models.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Product Review Sentiment Classifier',
      goal: 'Build a Naive Bayes text classifier that predicts whether a product review is positive or negative, using a TF-IDF preprocessing pipeline.',
      steps: [
        'Create a simulated dataset of 40 short product review texts, roughly half clearly positive and half clearly negative, with corresponding binary labels.',
        'Build a Pipeline combining TfidfVectorizer and MultinomialNB.',
        'Split the data into train/test sets and fit the pipeline on training data only.',
        'Evaluate test accuracy and print predictions alongside true labels for the test set.',
        'Test the model on 3 new, unseen review sentences you write yourself, printing its predictions.',
      ],
      expectedOutput: 'Pipeline correctly fit on training data. Test accuracy reasonably high given the clear-cut simulated reviews. Predictions on new unseen sentences are sensible and align with their apparent sentiment.',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'model_evaluation_metrics_ds5',
    topicTitle: 'Model Evaluation Metrics',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 35,
    totalXp: 160,
    emoji: '📐',
    intro: 'A model\'s accuracy number alone can be dangerously misleading. This lesson goes deep into the full toolkit of evaluation metrics — precision, recall, F1, ROC-AUC, and their regression counterparts — so you always know exactly how well a model is really performing, and for whom.',
    concepts: [
      ConceptLesson(
        title: 'The Confusion Matrix: The Foundation of Classification Metrics',
        definition: 'A confusion matrix tabulates predictions against actual outcomes across four categories — true positives, true negatives, false positives, and false negatives — and every other classification metric (precision, recall, F1) is directly derived from these four counts.',
        analogy: 'A confusion matrix is like a detailed scorecard from a security checkpoint: how many actual threats were correctly caught (true positives), how many innocent people were correctly let through (true negatives), how many innocent people were wrongly stopped (false positives), and how many actual threats slipped through (false negatives).',
        example: 'A fraud model\'s confusion matrix might show: 85 frauds correctly caught (TP), 9,800 legitimate transactions correctly cleared (TN), 15 legitimate transactions wrongly flagged (FP), and 10 actual frauds missed (FN) — each of these four numbers tells a different part of the performance story.',
        keyTakeaway: 'Always inspect the full confusion matrix, not just an overall accuracy number — two models with identical 95% accuracy can have very different confusion matrices, with one making far more costly errors (like missing more fraud cases) than the other.',
        codeSnippet: 'from sklearn.metrics import confusion_matrix\nimport numpy as np\n\ny_true = np.array([1,0,1,1,0,0,1,0])\ny_pred = np.array([1,0,0,1,0,1,1,0])\n\ncm = confusion_matrix(y_true, y_pred)\nprint(cm)\n# [[TN, FP], [FN, TP]]',
      ),
      ConceptLesson(
        title: 'Precision, Recall and F1-Score',
        definition: 'Precision measures "of everything predicted positive, how much was actually positive" — minimizing false alarms. Recall measures "of everything actually positive, how much did we catch" — minimizing missed cases. F1-score is the harmonic mean, balancing both.',
        analogy: 'Precision is like a strict bouncer who only lets in people they are truly confident are on the guest list — few wrong admissions, but possibly turning away some genuine guests. Recall is like a lenient bouncer who lets in everyone who might plausibly be a guest — catches every real guest, but also lets in some non-guests.',
        example: 'A cancer screening model prioritizes recall (catching every possible case, even with some false alarms, since missing a real case is far worse). A spam filter for an important business inbox might prioritize precision (never blocking a legitimate email, even if some spam slips through occasionally).',
        keyTakeaway: 'There is almost always a tradeoff between precision and recall — improving one typically comes at some cost to the other. F1-score is useful when you need a single balanced number, but understanding WHICH of precision or recall matters more for your specific business problem is more important than optimizing F1 blindly.',
        codeSnippet: 'from sklearn.metrics import precision_score, recall_score, f1_score\nimport numpy as np\n\ny_true = np.array([1,0,1,1,0,0,1,0])\ny_pred = np.array([1,0,0,1,0,1,1,0])\n\nprint(f"Precision: {precision_score(y_true, y_pred):.2f}")\nprint(f"Recall: {recall_score(y_true, y_pred):.2f}")\nprint(f"F1: {f1_score(y_true, y_pred):.2f}")',
      ),
      ConceptLesson(
        title: 'ROC-AUC and Regression Metrics',
        definition: 'ROC-AUC measures a classifier\'s ability to distinguish between classes across ALL possible decision thresholds (rather than just one), producing a single 0.5-to-1.0 score. For regression problems, RMSE and MAE (Level 4/5 equivalents of loss) measure average prediction error magnitude.',
        analogy: 'ROC-AUC is like evaluating a weather forecaster across every possible "rain alert" sensitivity setting simultaneously, rather than judging them at just one arbitrary threshold — a higher AUC means the forecaster genuinely separates rainy days from dry days well, regardless of exactly where you set the alert threshold.',
        example: 'An ROC-AUC of 0.5 means the model performs no better than random guessing at distinguishing classes; an AUC of 0.95 means it distinguishes the classes very well across virtually any threshold choice — this threshold-independence makes AUC especially useful for comparing models before deciding on a specific operating threshold.',
        keyTakeaway: 'For regression, RMSE penalizes large errors more heavily (due to squaring) while MAE treats all errors proportionally — choose RMSE when large mistakes are especially costly, and MAE when you want a metric that is more robust to a few extreme outlier errors.',
        codeSnippet: 'from sklearn.metrics import roc_auc_score, mean_squared_error, mean_absolute_error\nimport numpy as np\n\ny_true_class = np.array([1,0,1,1,0])\ny_probs = np.array([0.9,0.2,0.8,0.6,0.3])\nprint(f"ROC-AUC: {roc_auc_score(y_true_class, y_probs):.3f}")\n\ny_true_reg = np.array([100,150,200])\ny_pred_reg = np.array([110,140,220])\nprint(f"RMSE: {mean_squared_error(y_true_reg, y_pred_reg, squared=False):.2f}")\nprint(f"MAE: {mean_absolute_error(y_true_reg, y_pred_reg):.2f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A disease screening model needs to catch as many true cases as possible, even at the cost of some false alarms, because missing a real case is dangerous. Which metric should be prioritized?',
        options: [
          'Precision, to avoid any false alarms at all costs',
          'Recall, since it specifically measures how many of the actual positive cases were correctly caught by the model — directly aligned with minimizing missed diagnoses',
          'Only overall accuracy, ignoring precision and recall entirely',
          'Neither precision nor recall matters for medical applications'
        ],
        correctIndex: 1,
        explanation: 'Recall directly measures the fraction of true positives correctly identified — prioritizing it aligns with the goal of catching as many real cases as possible, even if that means accepting more false positives (lower precision) in exchange.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does an ROC-AUC score of 0.5 indicate about a classification model?',
        options: [
          'The model is performing at a professional, production-ready level',
          'The model is performing no better than random guessing at distinguishing between the two classes, regardless of decision threshold',
          'The model has 50% precision specifically',
          'The model needs exactly 50% more training data'
        ],
        correctIndex: 1,
        explanation: 'AUC of 0.5 is the theoretical baseline representing pure random guessing — a useful, informative model should score meaningfully above 0.5, with 1.0 representing perfect class separation.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A spam filter has precision 0.98 and recall 0.60 — it rarely misclassifies a legitimate email as spam, but misses many actual spam emails. Which business scenario does this best fit?',
        options: [
          'A scenario where missing spam is catastrophic and false alarms on legitimate email are trivial',
          'A scenario prioritizing an important business inbox where accidentally blocking a legitimate email (false positive) is much more costly than letting some spam through — high precision is intentionally favored over high recall',
          'This metric combination is always undesirable in every context',
          'Precision and recall values have no relationship to real business tradeoffs'
        ],
        correctIndex: 1,
        explanation: 'High precision with lower recall means the model is conservative about flagging things as spam, minimizing the risk of blocking real emails — exactly the right tradeoff when false positives (blocking legitimate mail) are the more costly error type.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Complete Model Evaluation Report Tool',
      goal: 'Build a comprehensive evaluation tool that computes and interprets the full suite of classification and regression metrics for a trained model.',
      steps: [
        'Train a logistic regression classifier on a simulated binary classification dataset (n=300) with a Pipeline including StandardScaler.',
        'Compute and print the confusion matrix, precision, recall, F1-score, and ROC-AUC on the test set.',
        'Write compare_thresholds(model, X_test, y_test) that shows precision, recall, and F1 at thresholds 0.3, 0.5, and 0.7, demonstrating the tradeoff.',
        'Train a separate simple linear regression model on a simulated regression dataset and compute RMSE and MAE on its test set.',
        'Write a final report interpreting all metrics in plain business language, including a recommendation for which threshold to use for the classifier given a stated business scenario.',
      ],
      expectedOutput: 'All classification and regression metrics correctly computed. Threshold comparison clearly shows precision/recall tradeoff. Business language interpretation and threshold recommendation are clear and well-justified.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'cross_validation_ds5',
    topicTitle: 'Cross-Validation',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 150,
    emoji: '🔄',
    intro: 'A single train/test split gives you one performance estimate — but what if you got a lucky or unlucky split? Cross-validation solves this by testing your model across multiple different splits, giving a far more reliable, trustworthy estimate of how it will actually perform in the real world.',
    concepts: [
      ConceptLesson(
        title: 'Why a Single Train/Test Split Is Not Enough',
        definition: 'A single random train/test split can, by chance, produce an unusually easy or unusually hard test set — leading to an evaluation that misleadingly overstates or understates a model\'s true, typical performance. Cross-validation averages across multiple different splits to reduce this luck-of-the-draw risk.',
        analogy: 'Judging a student\'s ability from a single exam is risky — they might have gotten lucky with familiar questions, or unlucky with an unusually hard paper. Giving them 5 different exams covering the same material and averaging the scores gives a far more reliable picture of their true, consistent ability.',
        example: 'A model evaluated on one particular 80/20 split shows 85% accuracy — but a different random 80/20 split of the exact same data might show 78% or 91% purely due to which specific rows ended up in the test set. Cross-validation reveals this variability directly instead of hiding it behind a single number.',
        keyTakeaway: 'Any single accuracy number from one train/test split should be treated with some skepticism — cross-validation gives both an average performance estimate AND a sense of how much that performance varies, which is itself valuable information about model reliability.',
      ),
      ConceptLesson(
        title: 'K-Fold Cross-Validation',
        definition: 'K-fold cross-validation splits the data into K equal-sized folds, then trains and evaluates the model K times — each time using a different fold as the test set and the remaining K-1 folds as training data — producing K performance scores that are then averaged.',
        analogy: 'K-fold cross-validation is like rotating which section of a classroom takes the exam-review quiz while the rest study together, repeating this K times so every student eventually takes the quiz exactly once, on material they genuinely had to learn rather than directly review beforehand — every row of data gets used for both training and testing across the process.',
        example: 'With 5-fold cross-validation on 500 samples, the data splits into 5 folds of 100 each. Round 1 trains on folds 2-5 (400 samples) and tests on fold 1; round 2 trains on folds 1,3,4,5 and tests on fold 2; and so on — producing 5 accuracy scores that get averaged into one final, more trustworthy estimate.',
        keyTakeaway: 'cross_val_score() in scikit-learn automates this entire process in one line. Common choices are K=5 or K=10 — providing a good balance between computational cost and estimate stability for most typical dataset sizes.',
        codeSnippet: 'from sklearn.model_selection import cross_val_score\nfrom sklearn.linear_model import LogisticRegression\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(300, 4)\ny = (X[:,0] + X[:,1] > 0).astype(int)\n\nscores = cross_val_score(LogisticRegression(), X, y, cv=5)\nprint("Fold scores:", scores.round(3))\nprint(f"Mean: {scores.mean():.3f}, Std: {scores.std():.3f}")',
      ),
      ConceptLesson(
        title: 'Stratified K-Fold for Imbalanced Data',
        definition: 'Stratified K-fold ensures each fold maintains approximately the same class proportion as the full dataset — critical for imbalanced classification problems where random folds might accidentally produce a fold with very few (or zero) examples of the minority class.',
        analogy: 'Stratified sampling for cross-validation is like ensuring every rotating exam group at a school has a proportionally representative mix of students from each grade level — rather than randomly risking a group that accidentally has zero 10th graders, which would make that group\'s results meaningless for evaluating 10th grade performance.',
        example: 'A fraud dataset with only 2% fraud cases, split with regular K-fold, might accidentally produce one fold with 0.5% fraud and another with 4% fraud purely by chance — Stratified K-fold guarantees each fold maintains close to that original 2% proportion, producing far more consistent and reliable evaluation.',
        keyTakeaway: 'Scikit-learn\'s cross_val_score() automatically uses stratified folds for classification problems by default — but understanding WHY this matters (avoiding wildly unrepresentative folds on imbalanced data) helps you recognize and diagnose evaluation problems when they occur.',
        codeSnippet: 'from sklearn.model_selection import StratifiedKFold, cross_val_score\nfrom sklearn.linear_model import LogisticRegression\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(300, 3)\ny = np.zeros(300); y[:15] = 1   # heavily imbalanced - 5% positive\n\nskf = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)\nscores = cross_val_score(LogisticRegression(), X, y, cv=skf, scoring="f1")\nprint(f"Stratified F1 scores: {scores.round(3)}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why can a single random train/test split sometimes give a misleading picture of a model\'s true performance?',
        options: [
          'A single split is always perfectly representative and never misleading',
          'By chance, a single split might produce an unusually easy or hard test set, so the resulting single accuracy number may not reflect the model\'s typical, consistent performance across different possible splits',
          'Train/test splits only work correctly for regression problems, not classification',
          'This is only a concern for datasets with fewer than 10 rows'
        ],
        correctIndex: 1,
        explanation: 'The randomness inherent in any single split means the specific rows that land in the test set could, by chance, be unusually easy or hard — cross-validation addresses this by averaging across multiple different splits.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is Stratified K-Fold specifically important for a dataset where the positive class makes up only 3% of all examples?',
        options: [
          'Stratification is irrelevant regardless of class balance',
          'Regular random K-fold could accidentally create some folds with very few or zero positive examples, making evaluation on those folds unreliable — stratified folds preserve the 3% proportion consistently across every fold',
          'Stratified K-fold is only used for regression problems',
          'Stratification always requires exactly 10 folds'
        ],
        correctIndex: 1,
        explanation: 'With a rare positive class, random folds risk wildly uneven distribution of that rare class across folds — stratification specifically guards against this by maintaining consistent class proportions in every single fold.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: '5-fold cross-validation on a model produces scores [0.91, 0.62, 0.89, 0.88, 0.90]. What does the one unusually low fold (0.62) suggest?',
        options: [
          'The model should be trusted at exactly 0.62 accuracy since that is the most recent fold',
          'There is meaningful variability across folds — worth investigating whether that particular fold contained unusual data, an especially hard subset, or a data quality issue, rather than just averaging away the concern',
          'Cross-validation results should always be identical across every fold with no exceptions',
          'This pattern indicates the code has a bug and cannot produce a valid mean score'
        ],
        correctIndex: 1,
        explanation: 'One notably low fold among otherwise consistent high scores is a signal worth investigating — it might indicate a genuinely harder data subset, an issue specific to that fold, or general model instability, rather than something to simply average over without inspection.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Robust Model Evaluation with Cross-Validation',
      goal: 'Build a cross-validation evaluation tool that compares multiple models robustly, including handling of an imbalanced dataset scenario.',
      steps: [
        'Simulate a balanced classification dataset (n=300) and an imbalanced dataset (n=300, 8% positive class).',
        'On the balanced dataset, run 5-fold cross_val_score for LogisticRegression, DecisionTreeClassifier, and KNeighborsClassifier (with scaling in a Pipeline where appropriate), printing mean and std for each.',
        'On the imbalanced dataset, compare regular K-Fold versus StratifiedKFold cross-validation results using F1 score, demonstrating why stratification matters.',
        'Identify and print which model had both the highest mean score and the lowest variability (std) across folds on the balanced dataset.',
        'Write a short summary explaining the tradeoff between mean performance and consistency (variance) when choosing a final model.',
      ],
      expectedOutput: 'All models correctly cross-validated with mean and std reported. Stratified vs regular K-Fold comparison clearly demonstrates the benefit of stratification on imbalanced data. Final model selection is well-justified considering both mean and variance.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'capstone_classification_regression_ds5',
    topicTitle: 'Capstone: Classification/Regression Project',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 70,
    totalXp: 225,
    emoji: '🏆',
    intro: 'This is your Level 5 capstone — build, evaluate, and compare complete machine learning solutions for both a classification and a regression problem, combining every skill from this level: the scikit-learn workflow, multiple algorithms, proper evaluation, and cross-validation, into two portfolio-ready end-to-end projects.',
    concepts: [
      ConceptLesson(
        title: 'Choosing the Right Algorithm for the Problem',
        definition: 'No single algorithm is universally best — the right choice depends on the problem type (classification vs regression), dataset size, need for interpretability, presence of non-linear relationships, and computational constraints. Comparing multiple candidate models empirically is standard professional practice.',
        analogy: 'Choosing an ML algorithm is like choosing a vehicle for a journey — a motorcycle (simple linear model) is fast and easy to understand for a quick city trip, while an off-road truck (random forest) handles rough, complex terrain better but is more complex to maintain; the "best" choice depends entirely on the specific journey\'s demands.',
        example: 'For a problem requiring strong interpretability for regulatory reasons (like credit approval), logistic regression\'s clear coefficients might be preferred even if a random forest achieves slightly higher raw accuracy — the right choice depends on business constraints, not accuracy alone.',
        keyTakeaway: 'A professional workflow always compares at least 2-3 candidate algorithms using consistent evaluation (cross-validation, same metrics) before selecting a final model — never assume the most complex algorithm is automatically the best choice for a given problem.',
      ),
      ConceptLesson(
        title: 'Baseline Models: Setting a Performance Floor',
        definition: 'Before building any sophisticated model, establishing a simple baseline (like always predicting the majority class, or the mean value) tells you the minimum bar any real model must clear — a "97% accurate" model is meaningless if simply guessing the majority class already achieves 96%.',
        analogy: 'A baseline model is like a "par" score in golf — it tells you what a trivially simple strategy achieves, so you can judge whether your actual, more sophisticated effort genuinely represents skillful improvement or is barely better than doing nothing clever at all.',
        example: 'On an imbalanced fraud dataset where only 2% of transactions are fraud, a model that always predicts "not fraud" achieves 98% accuracy while being completely useless — comparing your real model\'s F1-score or recall against this trivial baseline reveals whether it is actually adding value.',
        keyTakeaway: 'Always establish and report a baseline (DummyClassifier or DummyRegressor in scikit-learn) alongside your real model results — this context is essential for anyone reading your work to correctly judge whether the reported performance is genuinely impressive.',
        codeSnippet: 'from sklearn.dummy import DummyClassifier\nfrom sklearn.model_selection import cross_val_score\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(300, 4)\ny = np.zeros(300); y[:15] = 1\n\nbaseline = DummyClassifier(strategy="most_frequent")\nscores = cross_val_score(baseline, X, y, cv=5, scoring="accuracy")\nprint(f"Baseline accuracy (always majority class): {scores.mean():.3f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'On an imbalanced dataset where 96% of records belong to one class, why is a baseline model important before evaluating a "real" model\'s 96% accuracy?',
        options: [
          'Baselines are unnecessary since 96% accuracy is always impressive regardless of context',
          'A trivial baseline that always predicts the majority class would ALSO achieve 96% accuracy on this data — establishing that your real model must clear this baseline to demonstrate genuine, meaningful skill beyond trivial guessing',
          'Baseline models are only relevant for regression, not classification',
          'The baseline model will always outperform any real machine learning model'
        ],
        correctIndex: 1,
        explanation: 'On heavily imbalanced data, accuracy can be trivially high just by guessing the majority class — comparing against this baseline reveals whether a model\'s reported accuracy actually represents meaningful learned skill or is essentially no better than a naive guess.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A company needs a credit approval model that regulators require to be fully explainable to rejected applicants. A random forest scores 2% higher accuracy than logistic regression. What should guide the final model choice?',
        options: [
          'Always choose whichever model has the highest raw accuracy, regardless of any other consideration',
          'Weigh the interpretability requirement (a hard business/regulatory constraint) against the modest accuracy difference — logistic regression\'s clear, explainable coefficients may be the more appropriate choice despite slightly lower accuracy',
          'Model choice should never consider business or regulatory context',
          'Random forests can never be made interpretable under any circumstances'
        ],
        correctIndex: 1,
        explanation: 'Real-world model selection weighs multiple factors beyond raw accuracy — here, a hard regulatory requirement for explainability may reasonably outweigh a small accuracy advantage, favoring the more interpretable model.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You are comparing 4 classification algorithms on the same dataset using 5-fold cross-validation. What is the most rigorous way to select the final model?',
        options: [
          'Pick whichever model happened to score highest on a single train/test split',
          'Compare mean cross-validation scores AND their variability (std) across all 4 models using consistent metrics, considering both performance and stability alongside any interpretability or business requirements',
          'Always choose the algorithm with the most complex-sounding name',
          'Randomly select one of the 4 models'
        ],
        correctIndex: 1,
        explanation: 'Rigorous model selection considers cross-validated performance (both mean and consistency) across multiple algorithms using the same evaluation protocol, alongside any relevant business constraints — not a single lucky split or an arbitrary choice.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Dual Capstone: Customer Churn Classification + Revenue Regression',
      goal: 'Build two complete, portfolio-quality ML solutions — a classification model predicting customer churn and a regression model predicting customer revenue — comparing multiple algorithms rigorously for each.',
      steps: [
        'CLASSIFICATION TASK: Simulate a customer dataset (n=500) with realistic features and a binary churn target. Establish a DummyClassifier baseline, then compare LogisticRegression, DecisionTreeClassifier, RandomForestClassifier, and KNeighborsClassifier (all in Pipelines with scaling where needed) using 5-fold cross-validation on F1-score.',
        'Select the best classification model, evaluate it on a held-out test set with a full confusion matrix, precision, recall, F1, and ROC-AUC, and print feature importances or coefficients.',
        'REGRESSION TASK: Simulate a separate dataset (n=500) with features predicting customer monthly revenue. Establish a DummyRegressor baseline, then compare LinearRegression, Ridge, and RandomForestRegressor using 5-fold cross-validation on RMSE.',
        'Select the best regression model, evaluate on a held-out test set with RMSE and MAE, and interpret the top predictive features.',
        'Write a combined summary report presenting both models\' final performance versus their baselines, and a clear recommendation for which model to deploy for each task with justification.',
      ],
      expectedOutput: '=== LEVEL 5 CAPSTONE: CHURN + REVENUE MODELS ===\nClassification: Baseline F1=[X], Best model=[name], F1=[Y], ROC-AUC=[Z]\nTop churn drivers: [feature list]\n\nRegression: Baseline RMSE=[X], Best model=[name], RMSE=[Y], MAE=[Z]\nTop revenue drivers: [feature list]\n\nBoth models clearly outperform their respective baselines with sound justification.\n\nLevel 5 Complete — Machine Learning Foundations Mastered.\nReady for Level 6: Advanced Machine Learning.',
      xpReward: 120,
    ),
  ),

];