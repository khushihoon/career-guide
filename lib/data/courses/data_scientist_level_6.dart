import '../../models/course_content_data.dart';

const List<TopicCourse> dataScientistLevel6 = [

  TopicCourse(
    id: 'support_vector_machines_ds6',
    topicTitle: 'Support Vector Machines',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 35,
    totalXp: 165,
    emoji: '⚔️',
    intro: 'Welcome to Level 6 — Advanced Machine Learning. Support Vector Machines take a fundamentally different geometric approach to classification: instead of modeling probabilities, they find the widest possible boundary separating classes. This lesson also introduces the "kernel trick," one of the most elegant ideas in classical machine learning.',
    concepts: [
      ConceptLesson(
        title: 'Maximum Margin Classification',
        definition: 'A Support Vector Machine (SVM) finds the decision boundary (hyperplane) that maximizes the margin — the distance between the boundary and the nearest points of each class, called support vectors — producing the most "confident" possible separation between classes.',
        analogy: 'Finding a maximum-margin boundary is like drawing the widest possible road between two neighborhoods on a map — rather than any road that simply separates them, you specifically want the road with the most buffer space on both sides, so that new houses (new data points) are least likely to end up confusingly close to the dividing line.',
        example: 'Given two clusters of customers (churned vs retained) that are cleanly separable, an SVM does not just find any separating line — it finds the one line positioned to have maximum breathing room from the closest customers on each side, making it more robust to new, slightly different customers.',
        keyTakeaway: 'Only the "support vectors" — the closest points to the boundary — actually determine where the boundary sits; points far from the boundary have zero influence on the final decision line, which is a distinctive property compared to algorithms like logistic regression that weigh every point.',
        codeSnippet: 'from sklearn.svm import SVC\nimport numpy as np\n\nX = np.array([[1,2],[2,1],[2,3],[8,8],[9,7],[8,9]])\ny = np.array([0,0,0,1,1,1])\n\nsvm = SVC(kernel="linear")\nsvm.fit(X, y)\nprint(f"Number of support vectors: {len(svm.support_vectors_)}")\nprint(svm.predict([[7, 8]]))',
      ),
      ConceptLesson(
        title: 'The Kernel Trick: Handling Non-Linear Boundaries',
        definition: 'When classes are not linearly separable in the original feature space, the kernel trick implicitly maps data into a higher-dimensional space where a linear boundary CAN separate them — without ever having to compute that higher-dimensional transformation explicitly, keeping computation efficient.',
        analogy: 'Imagine two intertwined spirals on a flat table that no straight line can separate — but if you lift the table into 3D space in just the right way, a flat sheet of paper (a linear boundary) inserted at the right height might cleanly separate them. The kernel trick achieves this "lifting" effect mathematically, without literally reconstructing the higher-dimensional space.',
        example: 'Data arranged in concentric circles (one class inside a ring, another class in the ring itself) is impossible to separate with a straight line in 2D — but an RBF (radial basis function) kernel effectively transforms this into a shape where a linear boundary becomes possible, correctly classifying the circular pattern.',
        keyTakeaway: 'The RBF kernel (kernel="rbf") is the most commonly used default for non-linear problems and works well in many cases without manual tuning. Use kernel="linear" when you specifically expect the data to already be linearly separable, since it trains faster and remains more interpretable.',
        codeSnippet: 'from sklearn.svm import SVC\nimport numpy as np\n\nnp.random.seed(1)\n# Circular pattern - not linearly separable\ntheta = np.linspace(0, 2*np.pi, 100)\ninner = np.column_stack([np.cos(theta), np.sin(theta)]) + np.random.normal(0,0.1,(100,2))\nouter = np.column_stack([3*np.cos(theta), 3*np.sin(theta)]) + np.random.normal(0,0.1,(100,2))\nX = np.vstack([inner, outer])\ny = np.array([0]*100 + [1]*100)\n\nsvm_rbf = SVC(kernel="rbf").fit(X, y)\nprint(f"RBF kernel accuracy: {svm_rbf.score(X, y):.3f}")',
      ),
      ConceptLesson(
        title: 'The C Parameter: Controlling the Margin-Error Tradeoff',
        definition: 'The C parameter controls how strictly the SVM penalizes misclassified points — a small C allows a wider margin with more tolerance for misclassifications (softer boundary), while a large C forces a narrower margin that tries hard to classify every training point correctly (harder boundary, more overfitting risk).',
        analogy: 'The C parameter is like deciding how strict a dress code enforcer should be at an event — a lenient enforcer (small C) allows a wide range of outfits through with only occasional pushback, prioritizing smooth overall flow; a very strict enforcer (large C) meticulously blocks every single borderline violation, even at the cost of creating bottlenecks and being overly rigid.',
        example: 'On noisy, overlapping customer data, a very large C might force the SVM to carve out an oddly-shaped, overly complex boundary just to correctly classify a few noisy training points — a smaller C would accept a few training misclassifications in exchange for a smoother, more generalizable boundary.',
        keyTakeaway: 'Like max_depth in decision trees, C is a regularization-style hyperparameter — always tune it using cross-validation rather than guessing, and watch for the classic overfitting signature (very high training accuracy but much lower test accuracy) when C is set too large.',
        codeSnippet: 'from sklearn.svm import SVC\nfrom sklearn.model_selection import cross_val_score\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(200, 2)\ny = (X[:,0] + np.random.normal(0,0.5,200) > 0).astype(int)\n\nfor c in [0.01, 1, 100]:\n    scores = cross_val_score(SVC(C=c, kernel="rbf"), X, y, cv=5)\n    print(f"C={c}: mean CV accuracy = {scores.mean():.3f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What distinguishes the "support vectors" in a Support Vector Machine from other training points?',
        options: [
          'Support vectors are simply the first few points in the training dataset',
          'Support vectors are the training points closest to the decision boundary — they are the only points that actually determine where the maximum-margin boundary is positioned, while distant points have no influence',
          'Support vectors are randomly selected points chosen before training begins',
          'Every single training point is equally a "support vector" by definition'
        ],
        correctIndex: 1,
        explanation: 'Only the closest points to the boundary (the support vectors) actually determine its position — this is a distinctive property of SVMs compared to models like logistic regression, where every training point contributes to the final decision boundary.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is the kernel trick valuable for classification problems where classes are not linearly separable in the original feature space?',
        options: [
          'It deletes any data points that cannot be linearly separated',
          'It implicitly maps data into a higher-dimensional space where a linear boundary can separate the classes, without the computational cost of explicitly constructing that higher-dimensional representation',
          'It only works for classification problems with exactly 2 features',
          'It converts a classification problem into a regression problem'
        ],
        correctIndex: 1,
        explanation: 'The kernel trick achieves the effect of a higher-dimensional transformation (where linear separation becomes possible) through clever mathematics, without the prohibitive computational cost of literally computing that higher-dimensional space.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'An SVM with a very large C value achieves 100% training accuracy but only 65% test accuracy, with a highly irregular, jagged decision boundary. What is the appropriate fix?',
        options: [
          'Increase C even further to push training accuracy even higher',
          'Decrease C to allow a wider, smoother margin that tolerates some training misclassifications in exchange for better generalization to new data',
          'This indicates SVMs can never work well on this type of data',
          'The issue can only be fixed by collecting completely new data'
        ],
        correctIndex: 1,
        explanation: 'A very large C overfits by forcing the boundary to accommodate every training point exactly, producing an irregular boundary that fails to generalize — decreasing C is the standard fix, favoring a smoother, wider-margin boundary.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'SVM Classifier with Kernel and Hyperparameter Comparison',
      goal: 'Build and compare SVM classifiers with different kernels and C values on a non-linearly separable simulated dataset.',
      steps: [
        'Simulate a non-linearly separable 2-class dataset (n=250) with a circular or moon-shaped pattern using NumPy.',
        'Train an SVM with kernel="linear" and report its accuracy — demonstrating its limitation on non-linear data.',
        'Train an SVM with kernel="rbf" and compare accuracy, demonstrating the kernel trick\'s benefit.',
        'Sweep C over [0.01, 0.1, 1, 10, 100] with the RBF kernel using cross-validation, plotting or printing mean accuracy for each.',
        'Select the best C value and print the final number of support vectors used by the chosen model.',
      ],
      expectedOutput: 'Linear kernel clearly underperforms RBF kernel on the non-linear data. C sweep correctly identifies a good value balancing accuracy and generalization. Final support vector count reported.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'gradient_boosting_ds6',
    topicTitle: 'Gradient Boosting (XGBoost, LightGBM)',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 40,
    totalXp: 175,
    emoji: '🚀',
    intro: 'If random forests are a strong team of independent experts voting together, gradient boosting is a team where each new expert is specifically trained to fix the mistakes of the ones before it. This sequential, error-correcting approach is what dominates tabular data competitions and real-world production systems today.',
    concepts: [
      ConceptLesson(
        title: 'Boosting: Learning from Previous Mistakes',
        definition: 'Gradient boosting builds an ensemble of models SEQUENTIALLY — each new tree is trained specifically to predict the residual errors of the combined ensemble so far, gradually correcting the model\'s mistakes with each additional tree added.',
        analogy: 'Boosting is like a team of editors reviewing a draft essay in sequence — the first editor makes a pass and marks up mistakes, the second editor focuses specifically on fixing what the first editor missed or got wrong, and so on — each editor\'s job is defined entirely by what remains unfixed after the previous ones.',
        example: 'After the first tree in a gradient boosting model predicts house prices with some errors, the second tree is trained not on the original prices, but specifically on the RESIDUALS (errors) from tree 1 — gradually, each additional tree chips away at whatever error remains, improving the combined prediction.',
        keyTakeaway: 'Unlike random forests (where trees are built independently and in parallel), gradient boosting trees must be built one after another in sequence, since each new tree depends on the combined predictions of all previous trees — this makes boosting inherently slower to train but often more accurate.',
        codeSnippet: 'from sklearn.ensemble import GradientBoostingClassifier\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(300, 5)\ny = (X[:,0] + X[:,2]**2 > 0.5).astype(int)\n\ngb = GradientBoostingClassifier(n_estimators=100, learning_rate=0.1, max_depth=3)\ngb.fit(X, y)\nprint(f"Gradient boosting accuracy: {gb.score(X, y):.3f}")',
      ),
      ConceptLesson(
        title: 'Learning Rate and n_estimators: The Core Tradeoff',
        definition: 'The learning_rate controls how much each new tree\'s correction is applied to the overall prediction — a small learning rate requires more trees (higher n_estimators) to converge but often generalizes better, while a large learning rate converges faster but risks overshooting and overfitting.',
        analogy: 'Learning rate is like the size of steps taken while carefully walking down a foggy hillside toward the valley bottom — large steps (high learning rate) get you down quickly but risk overshooting past the true bottom and stumbling; small, careful steps (low learning rate) take longer but reach the true bottom more reliably, provided you take enough of them.',
        example: 'A model with learning_rate=0.3 and n_estimators=50 might converge quickly but overfit, while learning_rate=0.01 with n_estimators=1000 takes longer to train but often produces a more robust, better-generalizing final model — this tradeoff is one of the most important tuning decisions in gradient boosting.',
        keyTakeaway: 'A common professional practice is to set a small learning_rate (0.01-0.1) combined with a large n_estimators, then use early stopping (monitoring validation performance to halt training once it stops improving) rather than guessing the exact right number of trees in advance.',
        codeSnippet: 'from sklearn.ensemble import GradientBoostingClassifier\nfrom sklearn.model_selection import cross_val_score\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(300, 5)\ny = (X[:,0] + X[:,2]**2 > 0.5).astype(int)\n\nfor lr in [0.01, 0.1, 0.5]:\n    scores = cross_val_score(GradientBoostingClassifier(learning_rate=lr, n_estimators=100), X, y, cv=5)\n    print(f"learning_rate={lr}: mean accuracy = {scores.mean():.3f}")',
      ),
      ConceptLesson(
        title: 'XGBoost and LightGBM: Industry-Standard Implementations',
        definition: 'XGBoost and LightGBM are highly optimized, production-grade implementations of gradient boosting — offering dramatically faster training, built-in regularization, native handling of missing values, and superior performance compared to scikit-learn\'s standard GradientBoostingClassifier, making them the default choice in industry.',
        analogy: 'If scikit-learn\'s GradientBoostingClassifier is a well-built standard car, XGBoost and LightGBM are heavily tuned racing versions of the same underlying design — same fundamental engine (boosting), but engineered specifically for speed, efficiency, and handling real-world messiness like missing data far better.',
        example: 'On a Kaggle tabular data competition or a real company\'s fraud detection pipeline, XGBoost or LightGBM is almost always the practical default choice over scikit-learn\'s built-in gradient boosting — they train faster on large datasets and often achieve meaningfully better accuracy with less manual tuning effort.',
        keyTakeaway: 'The core conceptual ideas (sequential error-correction, learning rate, n_estimators) transfer directly from scikit-learn\'s gradient boosting to XGBoost/LightGBM — learning the fundamentals here means you already understand 90% of how to use these more powerful, industry-standard libraries.',
        codeSnippet: '# XGBoost follows the same familiar scikit-learn interface\nfrom xgboost import XGBClassifier\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(300, 5)\ny = (X[:,0] + X[:,2]**2 > 0.5).astype(int)\n\nxgb_model = XGBClassifier(n_estimators=200, learning_rate=0.05, max_depth=4)\nxgb_model.fit(X, y)\nprint(f"XGBoost accuracy: {xgb_model.score(X, y):.3f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the fundamental structural difference between how random forests and gradient boosting build their trees?',
        options: [
          'There is no meaningful structural difference between the two approaches',
          'Random forest trees are built independently and in parallel on random data subsets, while gradient boosting trees are built sequentially, with each new tree specifically trained to correct the errors of the combined ensemble so far',
          'Random forests only use one tree total, while gradient boosting always uses exactly 100 trees',
          'Gradient boosting trees are built in parallel, while random forest trees are built sequentially'
        ],
        correctIndex: 1,
        explanation: 'This sequential, error-correcting structure is the defining characteristic of boosting, fundamentally different from the parallel, independent tree-building approach of bagging-based random forests.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the general tradeoff between using a small learning_rate versus a large one in gradient boosting?',
        options: [
          'Learning rate has no meaningful effect on model training or performance',
          'A small learning rate requires more trees (higher n_estimators) to converge but often generalizes better; a large learning rate converges faster with fewer trees but risks overshooting and overfitting',
          'A large learning rate always produces a more accurate final model with no downsides',
          'Learning rate only affects how the model is saved to disk, not its actual predictions'
        ],
        correctIndex: 1,
        explanation: 'This is the central tuning tradeoff in gradient boosting — smaller steps per tree (low learning rate) generally produce more robust models but require more trees and longer training time to reach comparable performance.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You need to train a gradient boosting model on a large tabular dataset (2 million rows) as part of a production pipeline where training speed matters significantly. What is the most practical choice?',
        options: [
          'Use scikit-learn\'s standard GradientBoostingClassifier exclusively, regardless of speed requirements',
          'Use XGBoost or LightGBM, which are specifically optimized for training speed and efficiency on large datasets compared to scikit-learn\'s standard implementation',
          'Gradient boosting cannot be used at all on datasets larger than 100,000 rows',
          'Random forests are always faster than any gradient boosting implementation'
        ],
        correctIndex: 1,
        explanation: 'XGBoost and LightGBM are specifically engineered for speed and efficiency on large datasets, making them the practical industry choice over scikit-learn\'s standard (slower) gradient boosting implementation for large-scale production use.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Gradient Boosting Tuning and Comparison Tool',
      goal: 'Build a complete gradient boosting model, tune its key hyperparameters, and compare against a random forest baseline from Level 5.',
      steps: [
        'Simulate a classification dataset (n=400) with non-linear feature relationships built in.',
        'Train a baseline RandomForestClassifier (default settings) and record its cross-validated accuracy.',
        'Train a GradientBoostingClassifier and sweep learning_rate over [0.01, 0.1, 0.3] with a fixed n_estimators, comparing cross-validated accuracy for each.',
        'Select the best learning_rate, then sweep max_depth over [2, 3, 5] to find a good combination.',
        'Print a final comparison table: baseline random forest vs tuned gradient boosting, with a written conclusion on which performed better and why boosting\'s sequential approach may explain the difference.',
      ],
      expectedOutput: 'Random forest baseline correctly established. Learning rate and depth sweeps correctly identify good hyperparameters. Final comparison clearly shows tuned gradient boosting result versus baseline, with a sound explanation.',
      xpReward: 70,
    ),
  ),

  TopicCourse(
    id: 'hyperparameter_tuning_ds6',
    topicTitle: 'Hyperparameter Tuning',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 35,
    totalXp: 165,
    emoji: '🎛️',
    intro: 'You have been manually sweeping single hyperparameters like max_depth and C throughout this level — now you learn the systematic, professional tools for tuning multiple hyperparameters simultaneously: grid search, randomized search, and the reasoning behind choosing between them.',
    concepts: [
      ConceptLesson(
        title: 'Grid Search: Exhaustive Systematic Search',
        definition: 'GridSearchCV exhaustively tries every possible combination of specified hyperparameter values, evaluating each combination with cross-validation, and returns the combination that performed best — guaranteed to find the best combination within the specified grid, at the cost of computation time that grows multiplicatively with each added parameter.',
        analogy: 'Grid search is like trying every single combination on a padlock systematically, one by one, until you find the exact combination that opens it — thorough and guaranteed to find the best option within your search space, but the number of combinations to check explodes quickly as you add more dial positions (hyperparameters) to search.',
        example: 'Searching over 3 values of max_depth and 4 values of n_estimators requires training and evaluating 3×4=12 different models with cross-validation — adding a third parameter with 5 values would explode this to 60 total model trainings, illustrating why grid search becomes expensive with many parameters.',
        keyTakeaway: 'Grid search is best suited for a small number of hyperparameters with a modest number of candidate values each — beyond 2-3 parameters, the combinatorial explosion in training time usually makes randomized search or more advanced methods more practical.',
        codeSnippet: 'from sklearn.model_selection import GridSearchCV\nfrom sklearn.ensemble import RandomForestClassifier\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(200, 4)\ny = (X[:,0] > 0).astype(int)\n\nparam_grid = {"n_estimators": [50, 100, 200], "max_depth": [3, 5, None]}\ngrid = GridSearchCV(RandomForestClassifier(random_state=42), param_grid, cv=5)\ngrid.fit(X, y)\nprint(f"Best params: {grid.best_params_}")\nprint(f"Best CV score: {grid.best_score_:.3f}")',
      ),
      ConceptLesson(
        title: 'Randomized Search: Efficient Exploration',
        definition: 'RandomizedSearchCV samples a fixed number of random combinations from the specified hyperparameter distributions rather than trying every combination exhaustively — often finding near-optimal hyperparameters with far fewer total model trainings than a full grid search.',
        analogy: 'Randomized search is like exploring an unfamiliar large city by visiting a well-distributed random sample of neighborhoods rather than methodically walking down every single street — you get a good overall sense of the city\'s best areas far faster, even though you technically did not check every possible location.',
        example: 'A grid search over 5 hyperparameters with 5 values each would require 5^5 = 3,125 model trainings — a randomized search sampling just 100 random combinations from the same space often finds a comparably good result at a tiny fraction of the computational cost.',
        keyTakeaway: 'Research has shown that randomized search frequently finds hyperparameters nearly as good as exhaustive grid search, especially when only a few hyperparameters actually matter significantly — making it the more practical default choice for larger search spaces.',
        codeSnippet: 'from sklearn.model_selection import RandomizedSearchCV\nfrom sklearn.ensemble import RandomForestClassifier\nfrom scipy.stats import randint\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(200, 4)\ny = (X[:,0] > 0).astype(int)\n\nparam_dist = {"n_estimators": randint(50, 300), "max_depth": randint(2, 15)}\nrandom_search = RandomizedSearchCV(RandomForestClassifier(random_state=42),\n                                    param_dist, n_iter=20, cv=5, random_state=42)\nrandom_search.fit(X, y)\nprint(f"Best params: {random_search.best_params_}")',
      ),
      ConceptLesson(
        title: 'Nested Cross-Validation: Avoiding Tuning Leakage',
        definition: 'When you use cross-validation both to tune hyperparameters AND to report final performance using the SAME data splits, the reported performance becomes overly optimistic — nested cross-validation uses an outer loop for honest evaluation and an inner loop for tuning, keeping the two processes properly separated.',
        analogy: 'Using the same cross-validation folds for both tuning and final evaluation is like a student grading their own practice test AND choosing which practice test to report as their "official score" — of course they will pick and report their best-looking result, giving a falsely rosy picture rather than an honest, independent assessment.',
        example: 'A model tuned via GridSearchCV reports a 0.91 CV score — but if that SAME 0.91 score is also reported as the "final expected real-world performance," it is likely optimistic, since the hyperparameters were specifically selected to maximize performance on those exact folds; a separate, untouched final test set (or nested CV) gives an honest estimate.',
        keyTakeaway: 'For rigorous, publication-quality model evaluation, always keep a final held-out test set completely separate from any cross-validation used for hyperparameter tuning — report the tuned model\'s performance only on this untouched final test set for an honest final number.',
        codeSnippet: 'from sklearn.model_selection import train_test_split, GridSearchCV\nfrom sklearn.ensemble import RandomForestClassifier\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(300, 4)\ny = (X[:,0] > 0).astype(int)\n\n# Held-out test set, untouched during tuning\nX_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)\n\ngrid = GridSearchCV(RandomForestClassifier(random_state=42),\n                     {"max_depth":[3,5,None]}, cv=5)\ngrid.fit(X_train, y_train)   # tuning only on training data\nprint(f"CV score during tuning: {grid.best_score_:.3f}")\nprint(f"Honest test score: {grid.score(X_test, y_test):.3f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why does grid search become computationally impractical as you add more hyperparameters to search over?',
        options: [
          'Grid search always trains exactly one model regardless of parameter count',
          'The total number of combinations to evaluate grows multiplicatively with each additional hyperparameter and its number of candidate values, quickly exploding into an impractically large number of model trainings',
          'Grid search is always faster than randomized search regardless of parameter count',
          'Adding more hyperparameters has no effect on grid search computation time'
        ],
        correctIndex: 1,
        explanation: 'This combinatorial explosion (multiplying the number of values across every hyperparameter) is exactly why grid search is only practical for a small number of parameters with modest candidate value counts.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is it misleading to report the exact same cross-validation score used for hyperparameter tuning as your final "honest" performance estimate?',
        options: [
          'This is actually the correct, standard practice with no concerns',
          'The hyperparameters were specifically selected to maximize performance on those exact folds, making the reported score optimistically biased — a separate, untouched held-out test set gives a more honest final performance estimate',
          'Cross-validation scores are always identical to final test scores by definition',
          'This concern only applies to regression problems, never classification'
        ],
        correctIndex: 1,
        explanation: 'Because tuning specifically optimizes for performance on those particular folds, reusing that same score as the final reported performance overstates how well the model will truly perform on genuinely new, unseen data.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You need to tune 5 hyperparameters, each with 6 possible values, for a model that takes a noticeable amount of time to train. What is the more practical search strategy?',
        options: [
          'GridSearchCV, since it exhaustively guarantees finding the single best combination regardless of computation time',
          'RandomizedSearchCV, sampling a reasonable fixed number of combinations — since a full grid search here would require 6^5 = 7,776 model trainings, which is likely impractically expensive',
          'Skip hyperparameter tuning entirely for this model',
          'Manually guess reasonable values without any systematic search'
        ],
        correctIndex: 1,
        explanation: 'With 5 parameters and 6 values each, a full grid search requires thousands of trainings — RandomizedSearchCV can explore this space far more efficiently by sampling a manageable, fixed number of random combinations instead.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Systematic Hyperparameter Tuning Pipeline',
      goal: 'Build a rigorous hyperparameter tuning workflow using both grid and randomized search, with a properly held-out test set for honest final evaluation.',
      steps: [
        'Simulate a classification dataset (n=400) and split into a training set (used for tuning) and a completely separate held-out test set (used only for final evaluation).',
        'Run GridSearchCV over a small parameter grid (2 parameters, 3 values each) for a RandomForestClassifier using only the training data.',
        'Run RandomizedSearchCV over a larger parameter space (4 parameters) with n_iter=30 on the same training data, and compare best_score_ and training time conceptually against grid search.',
        'Select the best model from either search, then evaluate it ONCE on the held-out test set, comparing this honest test score against the CV score seen during tuning.',
        'Print a summary explaining any gap between the CV tuning score and the final held-out test score.',
      ],
      expectedOutput: 'Grid and randomized search both correctly implemented and compared. Held-out test set correctly kept separate from all tuning. Final honest test score reported and compared against tuning CV score with clear explanation.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'ensemble_methods_ds6',
    topicTitle: 'Ensemble Methods',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 30,
    totalXp: 155,
    emoji: '🤝',
    intro: 'Random forests and gradient boosting are both ensembles — but they are only two specific strategies out of a broader family of ensemble techniques. This lesson generalizes the concept: how and why combining multiple diverse models often beats any single model alone, including a professional technique called stacking.',
    concepts: [
      ConceptLesson(
        title: 'Voting Classifiers: Combining Different Model Types',
        definition: 'A voting classifier combines predictions from several DIFFERENT algorithm types (e.g., logistic regression, decision tree, and SVM together) — using hard voting (majority class wins) or soft voting (averaging predicted probabilities) — leveraging the different strengths and blind spots of diverse models.',
        analogy: 'A voting classifier is like assembling a panel of specialists with different backgrounds — a cardiologist, a nutritionist, and a psychologist — to jointly evaluate a patient, rather than relying on just one specialist\'s single perspective; each brings genuinely different expertise that a single expert would miss.',
        example: 'A voting ensemble combining logistic regression (captures linear patterns well), a decision tree (captures certain non-linear patterns), and KNN (captures local similarity patterns) can outperform any single one of these models alone, precisely because each algorithm has different strengths on different parts of the data.',
        keyTakeaway: 'Ensembling works best when the combined models are genuinely diverse in their errors — combining several very similar models (like three slightly different logistic regressions) provides far less benefit than combining fundamentally different algorithm types that make different kinds of mistakes.',
        codeSnippet: 'from sklearn.ensemble import VotingClassifier\nfrom sklearn.linear_model import LogisticRegression\nfrom sklearn.tree import DecisionTreeClassifier\nfrom sklearn.neighbors import KNeighborsClassifier\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(200, 4)\ny = (X[:,0] + X[:,1] > 0).astype(int)\n\nvoting = VotingClassifier(estimators=[\n    ("lr", LogisticRegression()),\n    ("tree", DecisionTreeClassifier(max_depth=4)),\n    ("knn", KNeighborsClassifier(n_neighbors=5))\n], voting="soft")\nvoting.fit(X, y)\nprint(f"Voting ensemble accuracy: {voting.score(X, y):.3f}")',
      ),
      ConceptLesson(
        title: 'Bagging vs Boosting: Two Ensemble Philosophies',
        definition: 'Bagging (like random forests) trains models independently and in parallel on random data subsets, then averages/votes — primarily reducing variance/overfitting. Boosting (like gradient boosting) trains models sequentially, each correcting previous errors — primarily reducing bias/underfitting.',
        analogy: 'Bagging is like getting independent second opinions from several doctors who each examine the patient separately without knowing what the others concluded — averaging their opinions smooths out any individual doctor\'s quirks. Boosting is like a single doctor doing several successive exams, each one specifically probing whatever the previous exam might have missed.',
        example: 'A model that is systematically too simple (underfitting, high bias) — like a shallow decision tree that misses important patterns — benefits more from boosting, which specifically targets correcting systematic errors. A model that overfits noisy data (high variance) benefits more from bagging, which averages away individual model quirks.',
        keyTakeaway: 'Diagnose whether your problem is more about high bias (consistently missing real patterns) or high variance (overly sensitive to specific training data quirks) before choosing between bagging-style and boosting-style ensembles — they solve fundamentally different failure modes.',
      ),
      ConceptLesson(
        title: 'Stacking: A Model That Learns How to Combine Models',
        definition: 'Stacking trains several diverse "base models," then trains a separate "meta-model" whose job is specifically to learn the best way to combine the base models\' predictions — rather than using a fixed voting rule, the combination strategy itself is learned from data.',
        analogy: 'Stacking is like hiring a general manager whose specific job is to weigh and combine the recommendations of several specialist advisors, learning over time which advisor to trust more in which situations — rather than always simply averaging every advisor\'s opinion equally regardless of context.',
        example: 'A stacked model might learn that the logistic regression base model is especially reliable for straightforward cases, while the random forest base model should be weighted more heavily for complex edge cases — this nuanced, learned combination often outperforms simple averaging or majority voting.',
        keyTakeaway: 'Stacking is more complex to implement correctly and carries more overfitting risk than simple voting or bagging/boosting (the meta-model must be trained on out-of-fold predictions to avoid leakage) — reserve it for situations where the extra complexity is justified by a meaningful performance need, such as competition settings.',
        codeSnippet: 'from sklearn.ensemble import StackingClassifier\nfrom sklearn.linear_model import LogisticRegression\nfrom sklearn.tree import DecisionTreeClassifier\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(200, 4)\ny = (X[:,0] + X[:,1] > 0).astype(int)\n\nstack = StackingClassifier(\n    estimators=[("tree", DecisionTreeClassifier(max_depth=4)), ("lr", LogisticRegression())],\n    final_estimator=LogisticRegression()\n)\nstack.fit(X, y)\nprint(f"Stacking accuracy: {stack.score(X, y):.3f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why does combining several very SIMILAR models (e.g., three nearly identical logistic regressions) in an ensemble provide little benefit?',
        options: [
          'Similar models always improve ensemble performance the most',
          'Ensembling benefits most from diversity in errors — models that make very similar mistakes on the same data points provide little additional corrective information when combined together',
          'Ensembles can never contain more than two models',
          'Similar models cannot technically be combined in scikit-learn'
        ],
        correctIndex: 1,
        explanation: 'The core benefit of ensembling comes from combining models that make DIFFERENT mistakes on different examples — nearly identical models tend to agree (and be wrong) on the same cases, providing little corrective diversity.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A model shows consistently high error on both training and test data (underfitting, high bias). Which ensemble strategy is more likely to help address this specific problem?',
        options: [
          'Bagging, since it always fixes every type of model weakness equally',
          'Boosting, since it is specifically designed to sequentially correct systematic errors that a simpler base model consistently makes',
          'No ensemble method can ever help with underfitting',
          'Only increasing dataset size can address underfitting, never ensembling'
        ],
        correctIndex: 1,
        explanation: 'Boosting\'s sequential error-correction mechanism is specifically well-suited to addressing systematic underfitting (high bias), since each additional model is explicitly trained to fix the remaining, consistent errors of the ensemble so far.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You want to combine a decision tree, a logistic regression, and a KNN model in a way that learns the OPTIMAL way to weigh their combined predictions, rather than using simple majority voting. Which ensemble technique is designed for this?',
        options: [
          'Simple hard voting only',
          'Stacking — training a meta-model specifically to learn how to best combine the base models\' predictions, rather than using a fixed combination rule',
          'Bagging with a single model type repeated three times',
          'This capability does not exist in ensemble methods'
        ],
        correctIndex: 1,
        explanation: 'Stacking is specifically designed for this purpose — a meta-model learns the optimal combination strategy from data, rather than relying on a fixed, predetermined voting rule like simple majority or averaging.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Ensemble Strategy Comparison Tool',
      goal: 'Build and compare voting, bagging-style, and stacking ensembles against their individual base models on a simulated dataset.',
      steps: [
        'Simulate a classification dataset (n=350) with moderately complex, non-linear relationships.',
        'Train and cross-validate 3 diverse individual base models: LogisticRegression, DecisionTreeClassifier, and KNeighborsClassifier (with appropriate scaling).',
        'Build a VotingClassifier (soft voting) combining all three, and cross-validate its performance against the individual base models.',
        'Build a StackingClassifier with the same three base models and a LogisticRegression meta-model, and cross-validate its performance.',
        'Print a comparison table of all 5 approaches (3 base models + voting + stacking) with mean cross-validated accuracy, and write a conclusion on which ensemble strategy performed best and why.',
      ],
      expectedOutput: 'All individual models and both ensemble strategies correctly built and cross-validated. Comparison table clearly shows relative performance. Conclusion correctly reasons about why the ensembles outperformed (or matched) individual base models.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'handling_imbalanced_data_ds6',
    topicTitle: 'Handling Imbalanced Data',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 30,
    totalXp: 155,
    emoji: '⚖️',
    intro: 'Fraud, churn, disease, rare defects — the most business-critical classification problems are almost always imbalanced, where the class you actually care about is rare. This lesson gives you a practical toolkit for handling this common, high-stakes challenge properly.',
    concepts: [
      ConceptLesson(
        title: 'Why Standard Models Fail on Imbalanced Data',
        definition: 'A model trained naively on imbalanced data (e.g., 98% negative, 2% positive) can achieve high accuracy simply by nearly always predicting the majority class — because standard training procedures minimize overall error, and the rare minority class contributes little to that overall error signal.',
        analogy: 'Training a model on heavily imbalanced data without adjustment is like grading a class where 98% of students are strong and 2% are struggling — a teacher who simply assumes "everyone is doing fine" would be right 98% of the time, yet would be completely failing the very students who most need identification and help.',
        example: 'A fraud model trained naively on data with 0.5% fraud might learn to simply predict "not fraud" for almost everyone, achieving 99.5% accuracy while catching zero actual fraud cases — the accuracy number looks excellent while the model is completely useless for its actual business purpose.',
        keyTakeaway: 'Always check class balance FIRST, before training any classification model — if one class represents less than roughly 10-15% of the data, standard accuracy-focused training and evaluation (Level 5\'s metrics) need deliberate adjustment, which this lesson covers.',
        codeSnippet: 'import numpy as np\n\ny = np.zeros(1000)\ny[:15] = 1   # only 1.5% positive class\nprint(f"Class balance: {(y==1).mean():.1%} positive, {(y==0).mean():.1%} negative")\n# A model always predicting 0 would achieve 98.5% "accuracy"',
      ),
      ConceptLesson(
        title: 'Resampling Techniques: Oversampling and Undersampling',
        definition: 'Resampling directly addresses class imbalance in the training data — oversampling duplicates or synthesizes new minority class examples (like SMOTE), while undersampling removes majority class examples — both aiming to give the model a more balanced view during training.',
        analogy: 'Oversampling is like making extra photocopies of the rare, important documents in a filing cabinet so they do not get overlooked when someone skims through quickly. Undersampling is like removing some of the excessively duplicated common documents so the rare ones represent a fairer proportion of what remains to review.',
        example: 'SMOTE (Synthetic Minority Oversampling Technique) does not just duplicate existing minority examples exactly — it generates new, synthetic minority examples by interpolating between existing ones, giving the model more varied exposure to the minority class pattern rather than exact repeated copies.',
        keyTakeaway: 'Resampling should only be applied to the TRAINING data, never to the test/validation set — the test set must remain a realistic, untouched representation of the true real-world class distribution to give an honest performance estimate.',
        codeSnippet: '# Conceptual SMOTE usage (imbalanced-learn library)\nfrom imblearn.over_sampling import SMOTE\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(300, 4)\ny = np.zeros(300); y[:20] = 1   # imbalanced\n\nsmote = SMOTE(random_state=42)\nX_resampled, y_resampled = smote.fit_resample(X, y)\nprint(f"Before: {(y==1).sum()} positive / {len(y)} total")\nprint(f"After: {(y_resampled==1).sum()} positive / {len(y_resampled)} total")',
      ),
      ConceptLesson(
        title: 'Class Weights: Adjusting the Loss Function Directly',
        definition: 'Instead of resampling the data, many scikit-learn models accept a class_weight parameter that directly penalizes misclassifying the minority class more heavily during training — achieving a similar rebalancing effect without physically altering the training dataset.',
        analogy: 'Using class weights is like telling an exam grader "mistakes on question 5 count triple" rather than physically adding more copies of question 5 to the exam paper — the grader\'s behavior shifts to pay disproportionate attention to that question, achieving a similar rebalancing effect without changing the underlying exam itself.',
        example: 'Setting class_weight="balanced" in LogisticRegression or RandomForestClassifier automatically computes weights inversely proportional to class frequency — making the rare 2% fraud class effectively count much more heavily in the model\'s loss calculation during training, without needing any separate resampling step.',
        keyTakeaway: 'class_weight="balanced" is often the simplest, most convenient first approach to try for imbalanced data — it requires no extra library, no data modification, and works directly within the standard scikit-learn training call.',
        codeSnippet: 'from sklearn.linear_model import LogisticRegression\nfrom sklearn.model_selection import cross_val_score\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(300, 4)\ny = np.zeros(300); y[:20] = 1\n\nmodel_default = LogisticRegression()\nmodel_weighted = LogisticRegression(class_weight="balanced")\n\nprint("Default F1:", cross_val_score(model_default, X, y, cv=5, scoring="f1").mean())\nprint("Weighted F1:", cross_val_score(model_weighted, X, y, cv=5, scoring="f1").mean())',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A fraud detection model trained naively achieves 99.2% accuracy but a recall of only 3% for the fraud class. What does this reveal?',
        options: [
          'The model is performing excellently and should be deployed immediately as-is',
          'The model is likely just predicting "not fraud" for nearly everyone, exploiting the severe class imbalance to achieve high accuracy while being nearly useless at actually catching fraud cases',
          'Recall is not a relevant metric for fraud detection problems',
          'A 99.2% accuracy always guarantees a genuinely useful model regardless of other metrics'
        ],
        correctIndex: 1,
        explanation: 'This is the classic imbalanced-data trap — high accuracy alongside very low recall for the minority class reveals the model has essentially learned to ignore the rare class entirely while still scoring well on the misleading accuracy metric.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why should resampling techniques like SMOTE be applied only to the training data, never to the test set?',
        options: [
          'Resampling has no effect on model evaluation regardless of where it is applied',
          'The test set must remain a realistic, untouched representation of the true real-world class distribution — resampling it would give a dishonest performance estimate that does not reflect actual deployment conditions',
          'SMOTE can technically only be applied to test sets, never training sets',
          'This restriction only applies to regression problems, not classification'
        ],
        correctIndex: 1,
        explanation: 'The test set exists specifically to simulate honest real-world performance — artificially rebalancing it would misrepresent the true class distribution the model will actually face in production, invalidating the evaluation.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You are building a model for a dataset with 3% positive class and want a quick first approach to address the imbalance without any extra libraries or data modification. What is the most convenient first step?',
        options: [
          'Ignore the imbalance entirely and proceed with default settings',
          'Set class_weight="balanced" in the chosen scikit-learn model, which directly adjusts the training loss to account for the imbalance without requiring any data resampling',
          'Manually delete 97% of the negative class examples without any systematic method',
          'Imbalanced data cannot be addressed without installing additional specialized libraries'
        ],
        correctIndex: 1,
        explanation: 'class_weight="balanced" is a convenient, built-in first approach requiring no extra libraries or data manipulation — a sensible starting point before considering more involved techniques like SMOTE if further improvement is needed.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Imbalanced Fraud Detection Model Comparison',
      goal: 'Build and compare multiple strategies for handling class imbalance on a simulated fraud detection dataset, evaluating with appropriate metrics.',
      steps: [
        'Simulate a fraud dataset (n=1000) with 3% positive (fraud) class and realistic feature relationships.',
        'Split into train/test sets using stratified splitting to preserve class balance in both.',
        'Train a baseline LogisticRegression with default settings and evaluate precision, recall, F1, and ROC-AUC on the test set.',
        'Train a second LogisticRegression with class_weight="balanced" and compare the same metrics.',
        'Apply SMOTE to the training data only, train a third model, and compare all three approaches in a final summary table with a clear recommendation.',
      ],
      expectedOutput: 'Baseline model shows the classic high-accuracy-low-recall pattern. Class-weighted and SMOTE models both show meaningfully improved recall/F1 for the fraud class. Final comparison table and recommendation clearly presented.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'clustering_ds6',
    topicTitle: 'Clustering (K-Means, DBSCAN, Hierarchical)',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 35,
    totalXp: 165,
    emoji: '🧩',
    intro: 'Everything so far in Levels 5-6 has been supervised learning — you had labeled answers to learn from. Clustering flips this entirely: you have no labels at all, and the algorithm must discover natural groupings in the data on its own. This is the foundation of customer segmentation, one of the most common real-world data science applications.',
    concepts: [
      ConceptLesson(
        title: 'K-Means: Partitioning Data into K Groups',
        definition: 'K-Means clustering partitions data into K groups by iteratively assigning each point to its nearest cluster center (centroid), then recalculating each centroid as the average of its assigned points — repeating until the assignments stabilize.',
        analogy: 'K-Means is like organizing a large crowd into K meeting points by first guessing K rough locations, having everyone walk to their nearest meeting point, then recalculating each meeting point as the actual center of the people who gathered there, and repeating this shuffle-and-recenter process until everyone settles into stable groups.',
        example: 'Segmenting 5,000 customers by (annual_spend, purchase_frequency) into K=4 clusters might reveal natural groups like "high-spend frequent buyers," "occasional big spenders," "frequent small purchasers," and "rarely active customers" — groupings discovered directly from the data\'s structure, without any pre-existing labels.',
        keyTakeaway: 'K-Means requires you to specify K (the number of clusters) in advance — it does not discover the "right" number of clusters on its own, which is why choosing K (covered next) is a critical, separate step in the clustering workflow.',
        codeSnippet: 'from sklearn.cluster import KMeans\nimport numpy as np\n\nnp.random.seed(1)\ngroup1 = np.random.randn(50, 2) + [0, 0]\ngroup2 = np.random.randn(50, 2) + [8, 8]\ngroup3 = np.random.randn(50, 2) + [0, 8]\nX = np.vstack([group1, group2, group3])\n\nkmeans = KMeans(n_clusters=3, random_state=42, n_init=10)\nlabels = kmeans.fit_predict(X)\nprint(f"Cluster centers:\\n{kmeans.cluster_centers_.round(2)}")',
      ),
      ConceptLesson(
        title: 'Choosing K: The Elbow Method and Silhouette Score',
        definition: 'The elbow method plots within-cluster variance (inertia) against different K values, looking for the "elbow" point where adding more clusters stops providing meaningful improvement. The silhouette score directly measures how well-separated and cohesive clusters are, independent of visual inspection.',
        analogy: 'The elbow method is like adding more shelves to organize a messy closet — the first few shelves dramatically improve organization, but beyond a certain point, adding even more shelves barely helps and just adds unnecessary complexity; the "elbow" is exactly where this diminishing return kicks in.',
        example: 'Plotting inertia for K=1 through K=10 might show a sharp drop from K=1 to K=4, then a much flatter, gradually declining line afterward — the "elbow" at K=4 suggests this is likely the natural number of underlying groups in the data.',
        keyTakeaway: 'Silhouette score ranges from -1 to 1, where higher values indicate well-separated, cohesive clusters — combining both the elbow method (visual, intuitive) and silhouette score (quantitative, precise) gives more confidence in choosing K than either method alone.',
        codeSnippet: 'from sklearn.cluster import KMeans\nfrom sklearn.metrics import silhouette_score\nimport numpy as np\n\nnp.random.seed(1)\ngroup1 = np.random.randn(50, 2) + [0, 0]\ngroup2 = np.random.randn(50, 2) + [8, 8]\ngroup3 = np.random.randn(50, 2) + [0, 8]\nX = np.vstack([group1, group2, group3])\n\nfor k in [2, 3, 4, 5]:\n    labels = KMeans(n_clusters=k, random_state=42, n_init=10).fit_predict(X)\n    score = silhouette_score(X, labels)\n    print(f"K={k}: silhouette score = {score:.3f}")',
      ),
      ConceptLesson(
        title: 'DBSCAN and Hierarchical Clustering: Alternatives to K-Means',
        definition: 'DBSCAN groups points based on density (regions of closely packed points), automatically discovering the number of clusters and naturally identifying outliers as noise — unlike K-Means, it does not assume spherical clusters. Hierarchical clustering builds a tree of nested clusters, letting you choose the number of groups after seeing the full structure.',
        analogy: 'DBSCAN is like identifying crowded neighborhoods on a city map purely by population density, without assuming every neighborhood must be circular or specifying how many neighborhoods should exist beforehand — sparse, isolated houses are naturally flagged as not belonging to any neighborhood. Hierarchical clustering is like building a full family tree first, then deciding afterward at which generation level to group relatives together.',
        example: 'K-Means struggles with crescent-moon-shaped or irregularly shaped clusters (it assumes roughly circular groups), while DBSCAN correctly identifies such shapes based purely on density continuity. DBSCAN also naturally flags isolated outlier points as noise rather than forcing them into the nearest cluster.',
        keyTakeaway: 'Choose K-Means for roughly spherical, similarly-sized clusters where you have a reasonable sense of K. Choose DBSCAN when clusters may be irregularly shaped or you need automatic outlier detection. Choose hierarchical clustering when you want to explore multiple possible groupings at different levels of granularity.',
        codeSnippet: 'from sklearn.cluster import DBSCAN\nimport numpy as np\n\nnp.random.seed(1)\ngroup1 = np.random.randn(50, 2) * 0.5 + [0, 0]\ngroup2 = np.random.randn(50, 2) * 0.5 + [5, 5]\noutliers = np.array([[10, -10], [-10, 10]])\nX = np.vstack([group1, group2, outliers])\n\ndbscan = DBSCAN(eps=1.0, min_samples=5)\nlabels = dbscan.fit_predict(X)\nprint(f"Clusters found: {len(set(labels)) - (1 if -1 in labels else 0)}")\nprint(f"Noise points flagged: {(labels == -1).sum()}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is a key limitation of K-Means that DBSCAN specifically addresses?',
        options: [
          'K-Means cannot be used on any numeric data at all',
          'K-Means requires specifying the number of clusters K in advance and assumes roughly spherical clusters — DBSCAN automatically discovers the number of clusters based on density and handles irregularly shaped clusters and outliers naturally',
          'DBSCAN is always faster than K-Means on every dataset regardless of size',
          'K-Means can only be used for exactly 2 clusters'
        ],
        correctIndex: 1,
        explanation: 'These are the two defining practical advantages of DBSCAN over K-Means — no need to pre-specify K, and natural handling of irregularly-shaped clusters and outlier/noise points, which K-Means structurally cannot do.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the "elbow" point in an elbow method plot (inertia vs K) typically indicate?',
        options: [
          'The exact number of data points in the dataset',
          'The K value beyond which adding more clusters provides diminishing improvement in reducing within-cluster variance — often a reasonable choice for the "natural" number of clusters',
          'The point where the clustering algorithm has failed completely',
          'The elbow always indicates K should equal exactly 2'
        ],
        correctIndex: 1,
        explanation: 'The elbow represents the point of diminishing returns — where additional clusters no longer meaningfully reduce within-cluster variance, suggesting the data\'s natural grouping structure has already been reasonably captured.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You are clustering geographic customer locations and expect some genuine outlier locations (customers far from any cluster) that should NOT be forced into a nearby group. Which algorithm handles this most naturally?',
        options: [
          'K-Means, since it forces every point into the nearest cluster center regardless of how far away it actually is',
          'DBSCAN, since it naturally identifies sparse, isolated points as noise rather than forcing them into an ill-fitting nearby cluster',
          'Neither algorithm can handle outliers under any circumstances',
          'Hierarchical clustering always ignores outliers automatically with no configuration needed'
        ],
        correctIndex: 1,
        explanation: 'DBSCAN\'s density-based approach naturally flags isolated points as noise rather than forcing them into a nearby cluster — exactly the desired behavior when genuine outliers should be identified separately rather than misleadingly grouped.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Customer Segmentation with Clustering Comparison',
      goal: 'Build a complete customer segmentation analysis, choosing K systematically and comparing K-Means against DBSCAN on simulated customer data.',
      steps: [
        'Simulate a customer dataset (n=300) with 2-3 numeric features (e.g., annual_spend, visit_frequency) containing 4 natural underlying groups plus a few deliberate outlier points.',
        'Scale the features, then run K-Means across K=2 through K=8, plotting the elbow curve (inertia) and computing silhouette scores for each K.',
        'Select the best K based on both methods and fit a final K-Means model, printing the characteristics (mean feature values) of each resulting cluster.',
        'Run DBSCAN on the same scaled data, tuning eps and min_samples, and compare the number of clusters found and outliers flagged versus K-Means.',
        'Write a short business interpretation describing each discovered customer segment and recommending which clustering approach was more appropriate for this dataset.',
      ],
      expectedOutput: 'Elbow and silhouette analysis correctly identify a reasonable K. Final K-Means clusters have interpretable, distinct characteristics. DBSCAN correctly identifies outliers. Clear business interpretation and method recommendation provided.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'anomaly_detection_ds6',
    topicTitle: 'Anomaly Detection',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 30,
    totalXp: 155,
    emoji: '🚨',
    intro: 'Fraud, network intrusions, equipment failures, and quality defects share a common pattern: they are rare and different from normal behavior. Anomaly detection is a specialized branch of machine learning built specifically to identify these unusual cases, often with little or no labeled examples of the anomaly itself.',
    concepts: [
      ConceptLesson(
        title: 'Anomaly Detection vs Standard Classification',
        definition: 'Unlike standard classification (which needs labeled examples of every class), anomaly detection often works with little or no labeled anomaly data — instead, it learns what "normal" looks like from mostly-normal training data, then flags anything that deviates significantly from that learned normal pattern.',
        analogy: 'Anomaly detection is like a security guard who has worked a building for years and has developed an intuitive sense of "normal" daily patterns — they do not need a labeled list of every possible type of suspicious behavior in advance; anything that simply feels unusual compared to the established normal pattern draws their attention.',
        example: 'A manufacturing sensor system might have millions of readings from normal, healthy equipment but very few (or zero) confirmed examples of an actual failure — anomaly detection learns the boundaries of normal sensor behavior and flags any reading that falls meaningfully outside that learned envelope.',
        keyTakeaway: 'Choose anomaly detection over standard classification when labeled examples of the "abnormal" case are rare, expensive to obtain, or when genuinely new/unseen types of anomalies might occur that were never present in any training data at all.',
      ),
      ConceptLesson(
        title: 'Isolation Forest: Isolating Anomalies by Random Partitioning',
        definition: 'Isolation Forest identifies anomalies based on a simple insight: anomalous points are "few and different," so they can be isolated with fewer random partition splits than normal points — points that get isolated quickly (near the root of a random tree) are flagged as more likely to be anomalies.',
        analogy: 'Isolation Forest is like playing a guessing game where you randomly ask yes/no questions to isolate one specific person from a crowd — an unusual-looking person (very tall, wearing a distinctive outfit) gets singled out after just a couple of questions, while an average, typical-looking person takes many more questions to distinguish from everyone else nearby.',
        example: 'In a dataset of transaction amounts mostly between ₹500-5000, a single ₹5,00,000 transaction gets "isolated" by a random splitting tree in very few splits (since almost any random threshold immediately separates it from the dense cluster of normal amounts) — this fast isolation is exactly the anomaly signal.',
        keyTakeaway: 'Isolation Forest works well for high-dimensional data and does not require assuming any particular distribution shape for normal data — it directly leverages the structural property that anomalies are inherently easier to isolate than typical points.',
        codeSnippet: 'from sklearn.ensemble import IsolationForest\nimport numpy as np\n\nnp.random.seed(1)\nnormal = np.random.randn(200, 2)\nanomalies = np.array([[6, 6], [-6, -6], [6, -6]])\nX = np.vstack([normal, anomalies])\n\niso_forest = IsolationForest(contamination=0.02, random_state=42)\npredictions = iso_forest.fit_predict(X)   # -1 = anomaly, 1 = normal\nprint(f"Anomalies detected: {(predictions == -1).sum()}")',
      ),
      ConceptLesson(
        title: 'Statistical Approaches: Z-Score and Local Outlier Factor',
        definition: 'Simple statistical anomaly detection (Level 3\'s z-score method, extended here) flags points far from the mean in standard deviation units — effective for single-feature, roughly normal data. Local Outlier Factor (LOF) compares each point\'s local density to its neighbors\', catching anomalies that are only unusual relative to their local neighborhood.',
        analogy: 'A simple z-score check is like flagging anyone significantly taller or shorter than the AVERAGE height across an entire country. Local Outlier Factor is like flagging someone whose height is unusual specifically compared to the people immediately around them in their own local neighborhood — a person of average national height might still be a notable local outlier in a specific unusually tall or short community.',
        example: 'A house priced at ₹80 lakh might look completely normal by a simple national average check, but Local Outlier Factor could flag it as anomalous if every other house in its specific immediate neighborhood sells for ₹20-25 lakh — the anomaly is only visible relative to its local context, not the global average.',
        keyTakeaway: 'Use simple z-score/IQR methods (from Level 3) for quick, single-feature checks on roughly normal data. Use Local Outlier Factor or Isolation Forest for multi-feature anomaly detection where the "normal" pattern may vary across different regions or subgroups of the data.',
        codeSnippet: 'from sklearn.neighbors import LocalOutlierFactor\nimport numpy as np\n\nnp.random.seed(1)\ncluster_a = np.random.randn(100, 2) * 0.5 + [0, 0]\ncluster_b = np.random.randn(100, 2) * 3 + [15, 15]\nX = np.vstack([cluster_a, cluster_b])\n\nlof = LocalOutlierFactor(n_neighbors=20, contamination=0.05)\npredictions = lof.fit_predict(X)\nprint(f"Local outliers flagged: {(predictions == -1).sum()}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why might anomaly detection be preferred over standard supervised classification for detecting a rare type of equipment failure?',
        options: [
          'Anomaly detection always produces higher accuracy than any classification approach',
          'Labeled examples of actual failures may be extremely rare or entirely absent, and anomaly detection can learn what "normal" looks like from abundant healthy-equipment data, flagging deviations without needing many (or any) labeled failure examples',
          'Anomaly detection requires far more labeled data than standard classification',
          'Standard classification can never be applied to equipment failure problems'
        ],
        correctIndex: 1,
        explanation: 'The core advantage is exactly this — anomaly detection sidesteps the need for abundant labeled examples of the rare event itself, instead learning the boundary of normal behavior from the much more plentiful normal data.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the core intuition behind how Isolation Forest identifies anomalies?',
        options: [
          'It simply calculates the mean and standard deviation of every feature',
          'Anomalous points, being "few and different," can typically be isolated using far fewer random partition splits than normal points — points isolated quickly by random splitting are flagged as more likely anomalies',
          'It requires labeled anomaly examples to function at all',
          'It only works for datasets with exactly one feature'
        ],
        correctIndex: 1,
        explanation: 'This "ease of isolation via random splits" is the defining structural insight behind Isolation Forest — anomalies stand apart enough from the bulk of normal data that they get separated quickly, unlike typical points nestled among many similar neighbors.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A house is priced exactly at the national average, but every comparable house in its specific immediate neighborhood is priced 60% lower. A simple global z-score check on price would likely miss this as an outlier. Which technique would catch it?',
        options: [
          'A simple global z-score check would already catch this case perfectly',
          'Local Outlier Factor, since it specifically compares each point\'s characteristics to its LOCAL neighborhood rather than the entire dataset\'s global average',
          'This case cannot be detected by any anomaly detection method',
          'Standard linear regression is the only technique capable of catching this'
        ],
        correctIndex: 1,
        explanation: 'Because the house is anomalous only relative to its LOCAL neighborhood (not the global national average), a method like Local Outlier Factor — which explicitly considers local context — is needed to correctly flag it, unlike a global z-score check.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Multi-Method Anomaly Detection System',
      goal: 'Build an anomaly detection system comparing Isolation Forest and Local Outlier Factor on simulated sensor data, evaluating against known injected anomalies.',
      steps: [
        'Simulate a sensor dataset (n=500) with 3 numeric features representing normal operating readings, and inject 20 deliberate anomalous readings with values clearly outside the normal pattern.',
        'Apply Isolation Forest with an appropriate contamination parameter and record which points are flagged as anomalies.',
        'Apply Local Outlier Factor with an appropriate contamination parameter and record its flagged anomalies.',
        'Since you know the true injected anomaly indices, compute how many of the 20 true anomalies each method successfully caught (a recall-style comparison).',
        'Print a comparison summary of both methods\' detection performance and discuss any differences observed.',
      ],
      expectedOutput: 'Both methods correctly applied and evaluated against the known true anomalies. Comparison clearly reports detection performance for each method. Summary reasonably explains any differences in results between the two approaches.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'model_interpretability_ds6',
    topicTitle: 'Model Interpretability (SHAP, LIME)',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 35,
    totalXp: 165,
    emoji: '🔍',
    intro: 'A model that predicts well but cannot explain WHY is often unusable in regulated industries (finance, healthcare, insurance) and hard to trust anywhere. This lesson covers the modern tools — SHAP and LIME — that open up even the most complex "black box" models like random forests and gradient boosting.',
    concepts: [
      ConceptLesson(
        title: 'Global vs Local Interpretability',
        definition: 'Global interpretability explains how a model behaves overall across the entire dataset (e.g., "support_tickets is the most important feature on average"). Local interpretability explains a single specific prediction (e.g., "THIS customer was flagged as high-risk specifically because of their recent support tickets and low tenure").',
        analogy: 'Global interpretability is like reading a company\'s annual report to understand overall trends and priorities across the whole year. Local interpretability is like getting a detailed explanation for one specific decision — such as why exactly this one customer\'s loan application was rejected — even if it does not tell you about every other decision the company has made.',
        example: 'Feature importance from a random forest (Level 5) is a global explanation — it tells you support_tickets matters most on average across ALL customers. But a customer calling to ask "why was MY specific application rejected?" needs a local explanation specific to their individual case, which feature importance alone cannot provide.',
        keyTakeaway: 'Regulated industries (like lending) often legally require local explanations for individual decisions, not just global feature importance — this distinction is exactly why tools like SHAP and LIME, which provide per-prediction explanations, have become essential in professional practice.',
      ),
      ConceptLesson(
        title: 'SHAP Values: Fairly Distributing Credit Among Features',
        definition: 'SHAP (SHapley Additive exPlanations) values are grounded in game theory — they fairly distribute a prediction\'s total "credit" (how far it deviates from the average prediction) among all input features, telling you exactly how much each feature pushed a specific prediction up or down.',
        analogy: 'SHAP values are like fairly splitting credit for a team\'s project success among individual team members based on their actual, measurable contribution — rather than guessing who mattered most, SHAP uses a rigorous, mathematically fair method (borrowed from game theory) to assign exact credit to each "team member" (feature).',
        example: 'A SHAP explanation for one customer\'s churn prediction might show: base rate 20% + support_tickets contributed +15% + tenure contributed -8% + monthly_spend contributed +3% = final prediction of 30% churn probability — each feature\'s exact contribution to THIS specific prediction is quantified precisely.',
        keyTakeaway: 'SHAP values are additive — they sum up exactly to explain the gap between the average prediction and this specific prediction — this mathematical property is what makes SHAP explanations rigorous and trustworthy rather than just an approximate, heuristic guess.',
        codeSnippet: '# Conceptual SHAP usage\nimport shap\nfrom sklearn.ensemble import RandomForestClassifier\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(200, 4)\ny = (X[:,0] + X[:,1] > 0).astype(int)\nmodel = RandomForestClassifier().fit(X, y)\n\nexplainer = shap.TreeExplainer(model)\nshap_values = explainer.shap_values(X[:5])   # explain first 5 predictions\nprint("SHAP values for first prediction:", shap_values[1][0])',
      ),
      ConceptLesson(
        title: 'LIME: Local Approximation with a Simple Model',
        definition: 'LIME (Local Interpretable Model-agnostic Explanations) explains a single complex prediction by fitting a simple, interpretable model (like linear regression) that approximates the complex model\'s behavior ONLY in the local neighborhood around that specific prediction.',
        analogy: 'LIME is like using a straight ruler to approximate a small local section of a complicated, curving road — the ruler (simple linear model) would be a terrible representation of the ENTIRE winding road (the complex model globally), but for understanding just this one small nearby stretch, the straight-line approximation works surprisingly well.',
        example: 'For one specific loan applicant, LIME might generate many slightly perturbed versions of their data, observe how the complex model\'s prediction changes for each variation, and fit a simple local linear model to these results — revealing that "income" and "existing_debt" were the two features that most influenced THIS specific applicant\'s decision.',
        keyTakeaway: 'LIME is "model-agnostic" — it works identically regardless of what complex model is underneath (neural network, random forest, gradient boosting) because it only observes input-output behavior, never needing to look inside the model itself — making it broadly applicable across nearly any model type.',
        codeSnippet: '# Conceptual LIME usage\nfrom lime.lime_tabular import LimeTabularExplainer\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(200, 4)\nfeature_names = ["income", "debt", "tenure", "score"]\n\nexplainer = LimeTabularExplainer(X, feature_names=feature_names, mode="classification")\n# explanation = explainer.explain_instance(X[0], model.predict_proba)\n# explanation.as_list() would show top contributing features for this instance',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A bank must legally explain to an individual customer exactly why their specific loan application was rejected, not just general trends across all applicants. Which type of interpretability does this require?',
        options: [
          'Global interpretability, since overall feature importance is sufficient for any individual explanation',
          'Local interpretability, since it specifically explains a single prediction for one individual case, which global feature importance alone cannot provide',
          'Neither type of interpretability is relevant to this legal requirement',
          'This requirement can only be satisfied by making the model less accurate'
        ],
        correctIndex: 1,
        explanation: 'Individual, case-specific explanations require local interpretability tools like SHAP or LIME — global feature importance tells you what matters on average, but not the specific reasoning behind one particular customer\'s prediction.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What makes LIME "model-agnostic," and why is this property valuable?',
        options: [
          'LIME only works with linear regression models specifically',
          'LIME explains predictions by observing input-output behavior and fitting a simple local approximation, without needing to look inside the underlying model — making it usable across virtually any model type, from random forests to neural networks',
          'Model-agnostic means LIME cannot be used with any real machine learning model',
          'LIME requires retraining the entire original model from scratch each time'
        ],
        correctIndex: 1,
        explanation: 'Because LIME only needs to query the model\'s predictions for perturbed inputs (treating the model as a black box), it can be applied to explain nearly any model type without needing specialized internal access — a major practical advantage.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A random forest flags a specific customer as high-risk for churn. You want to know exactly which features contributed to THIS particular customer\'s prediction, with mathematically rigorous, additive credit assignment. Which tool is most appropriate?',
        options: [
          'Simply reporting the model\'s overall global feature_importances_ values',
          'SHAP values, since they provide a mathematically rigorous, additive breakdown of exactly how much each feature contributed to this specific customer\'s individual prediction',
          'Retraining an entirely new, simpler model from scratch',
          'This level of individual explanation is not possible with any current technique'
        ],
        correctIndex: 1,
        explanation: 'SHAP values are specifically designed to provide exactly this kind of rigorous, additive, per-prediction explanation — showing precisely how much each feature pushed this individual customer\'s prediction away from the average baseline.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Interpretable Loan Decision Explainer',
      goal: 'Build a random forest loan approval model and produce both global and local (individual-level) explanations for its predictions.',
      steps: [
        'Simulate a loan applicant dataset (n=300) with features: income, existing_debt, credit_score, years_employed, and a binary approved target.',
        'Train a RandomForestClassifier and extract global feature_importances_, printing them ranked from most to least important.',
        'Select 3 specific individual test-set applicants (one clearly approved, one clearly rejected, one borderline) and describe their raw feature values.',
        'Conceptually reason through (using feature importance and each applicant\'s specific values relative to typical approved/rejected profiles) which factors most likely drove EACH of these 3 individual predictions, simulating what a SHAP/LIME-style local explanation would reveal.',
        'Write a short comparison of the global explanation (overall feature importance) versus the 3 local, individual-level explanations, highlighting how they differ.',
      ],
      expectedOutput: 'Global feature importance correctly extracted and ranked. Three individual applicants selected with clear feature-value based reasoning for each prediction. Written comparison clearly distinguishes global versus local interpretability with concrete examples.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'feature_selection_techniques_ds6',
    topicTitle: 'Feature Selection Techniques',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 30,
    totalXp: 155,
    emoji: '🎯',
    intro: 'More features are not always better — irrelevant or redundant features can hurt model performance, slow training, and make interpretation harder. This lesson covers systematic techniques for identifying and keeping only the features that genuinely earn their place in your model.',
    concepts: [
      ConceptLesson(
        title: 'Filter Methods: Statistical Pre-Screening',
        definition: 'Filter methods select features based purely on their statistical relationship with the target — using techniques like correlation (from Level 3) or univariate statistical tests — evaluated independently of any specific machine learning model, making them fast and model-agnostic.',
        analogy: 'Filter methods are like a resume pre-screening step before any interviews happen — you quickly eliminate candidates who clearly do not meet basic minimum qualifications (like a required certification), without yet involving the more expensive, time-consuming full interview process (actually training a model).',
        example: 'SelectKBest with an f_classif score quickly ranks all features by how strongly each individually relates to the target variable — features with very low scores (weak individual relationship with the target) can be filtered out before any model training begins, saving significant time on high-dimensional datasets.',
        keyTakeaway: 'Filter methods are fast but consider each feature in isolation — they can miss features that are only useful in COMBINATION with others (interaction effects), which is exactly what wrapper and embedded methods address next.',
        codeSnippet: 'from sklearn.feature_selection import SelectKBest, f_classif\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(200, 10)\ny = (X[:,2] + X[:,5] > 0).astype(int)   # only features 2,5 truly matter\n\nselector = SelectKBest(score_func=f_classif, k=3)\nX_selected = selector.fit_transform(X, y)\nprint(f"Selected feature indices: {selector.get_support(indices=True)}")',
      ),
      ConceptLesson(
        title: 'Wrapper Methods: Recursive Feature Elimination',
        definition: 'Wrapper methods evaluate feature subsets by actually training and testing a real model on each candidate subset — Recursive Feature Elimination (RFE) repeatedly trains a model, removes the least important feature, and repeats until only the desired number of features remains.',
        analogy: 'A wrapper method is like a sports team coach who actually plays practice games with different lineups to see which combination of players performs best together — rather than judging players purely on individual statistics alone (filter methods), the coach directly tests how well specific combinations perform as a genuine team.',
        example: 'RFE with a logistic regression model starts with all 20 features, trains the model, identifies and removes the single weakest-coefficient feature, retrains on the remaining 19, and repeats this process until only the specified target number of features remains — directly optimizing for actual model performance.',
        keyTakeaway: 'Wrapper methods generally find better feature subsets than filter methods because they account for how features interact with the specific model being used, but they are computationally far more expensive since they require training many models — a real tradeoff to weigh for large feature sets.',
        codeSnippet: 'from sklearn.feature_selection import RFE\nfrom sklearn.linear_model import LogisticRegression\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(200, 10)\ny = (X[:,2] + X[:,5] > 0).astype(int)\n\nrfe = RFE(LogisticRegression(), n_features_to_select=3)\nrfe.fit(X, y)\nprint(f"Selected features: {np.where(rfe.support_)[0]}")\nprint(f"Feature ranking: {rfe.ranking_}")',
      ),
      ConceptLesson(
        title: 'Embedded Methods: Built-In Feature Selection',
        definition: 'Embedded methods perform feature selection AS PART of the normal model training process itself — Lasso regression (from Level 5) naturally zeros out unimportant coefficients during training, and tree-based feature_importances_ can be used to threshold and drop low-importance features after a single training pass.',
        analogy: 'Embedded feature selection is like a librarian who naturally organizes and prioritizes books simply as part of doing their normal daily job — rather than running a completely separate, dedicated "book importance evaluation project" (a wrapper method), the useful ranking emerges naturally as a byproduct of the regular work itself.',
        example: 'Training a single Lasso regression model automatically zeros out coefficients for irrelevant features as a direct side effect of its normal training process — no separate feature selection step is needed at all, since the selection happens intrinsically within one model fit.',
        keyTakeaway: 'Embedded methods offer a practical middle ground between filter methods (fast but naive) and wrapper methods (thorough but expensive) — they get some of the model-awareness benefit of wrapper methods at a fraction of the computational cost, since selection happens during a single training pass.',
        codeSnippet: 'from sklearn.linear_model import Lasso\nimport numpy as np\n\nnp.random.seed(1)\nX = np.random.randn(200, 10)\ny = X[:,2]*3 + X[:,5]*2 + np.random.randn(200)*0.5\n\nlasso = Lasso(alpha=0.1).fit(X, y)\nselected = np.where(lasso.coef_ != 0)[0]\nprint(f"Features selected by Lasso (nonzero coef): {selected}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main limitation of filter methods (like correlation-based selection) compared to wrapper methods?',
        options: [
          'Filter methods are always slower than wrapper methods',
          'Filter methods evaluate each feature independently and in isolation, so they can miss features that are only genuinely useful in COMBINATION with other features (interaction effects) — wrapper methods, by training real models, can capture this',
          'Filter methods can only be used for regression problems, never classification',
          'Filter methods always select more features than wrapper methods'
        ],
        correctIndex: 1,
        explanation: 'Because filter methods score features one at a time without considering how they interact with other features, they can overlook features whose real value only emerges in combination with others — exactly the interaction effects that wrapper methods, by testing actual model performance, can capture.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is Lasso regression considered an "embedded" feature selection method?',
        options: [
          'Because it requires a completely separate feature selection step before model training even begins',
          'Because feature selection happens as a natural byproduct of the normal model training process itself — Lasso\'s L1 penalty directly zeros out unimportant coefficients during a single training pass, with no extra dedicated step required',
          'Because it is the slowest possible feature selection method available',
          'Because it can only be used after wrapper methods have already been applied'
        ],
        correctIndex: 1,
        explanation: 'Embedded methods perform selection intrinsically as part of normal training — Lasso exemplifies this perfectly, since fitting the model on its own naturally drives irrelevant feature coefficients to exactly zero, with no separate selection procedure needed.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You have 200 candidate features and a computationally expensive model to train (each training run takes significant time). You want to first quickly narrow down to a more manageable subset before doing any expensive, thorough model-based selection. What is a sensible first approach?',
        options: [
          'Immediately run an expensive wrapper method (like RFE) on all 200 raw features without any pre-screening',
          'First apply a fast filter method (like SelectKBest with a correlation-based score) to narrow down to a smaller, more manageable candidate set, THEN apply a more expensive wrapper method on that reduced set if needed',
          'Feature selection is never worthwhile when there are more than 100 candidate features',
          'Randomly select 200 features without any systematic method'
        ],
        correctIndex: 1,
        explanation: 'A practical, efficient workflow often combines methods — using a fast filter method first to eliminate obviously weak features cheaply, then applying more expensive wrapper or embedded methods only on the more manageable, pre-narrowed candidate set.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Multi-Method Feature Selection Comparison',
      goal: 'Build a feature selection pipeline comparing filter, wrapper, and embedded methods on a simulated dataset with known relevant and irrelevant features.',
      steps: [
        'Simulate a classification dataset (n=300) with 15 features, where only 4 are genuinely predictive and the remaining 11 are pure noise, using NumPy.',
        'Apply a filter method (SelectKBest) to identify the top features, checking how many of the true 4 relevant features were correctly identified.',
        'Apply a wrapper method (RFE) with a chosen model to select the same number of features, and compare its selection accuracy against the filter method.',
        'Train a Lasso model (embedded method) and check which features received nonzero coefficients, comparing against the true relevant features.',
        'Print a final comparison table showing which method(s) most accurately identified the true 4 relevant features, and discuss any tradeoffs observed.',
      ],
      expectedOutput: 'All three feature selection approaches correctly implemented and compared against the known ground truth of 4 relevant features. Comparison table clearly shows each method\'s accuracy in identifying the true relevant features, with a sound discussion of tradeoffs.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'capstone_kaggle_competition_ds6',
    topicTitle: 'Capstone: Kaggle-style Competition Project',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 75,
    totalXp: 235,
    emoji: '🏆',
    intro: 'This is your Level 6 capstone — simulate a complete Kaggle-style machine learning competition, applying every advanced technique from this level: gradient boosting, hyperparameter tuning, ensembling, feature selection, and imbalanced data handling, all combined into one competitive, portfolio-defining project.',
    concepts: [
      ConceptLesson(
        title: 'The Competitive ML Workflow',
        definition: 'A competition-style machine learning workflow follows a distinctive iterative loop: establish a baseline, engineer and select features, try multiple algorithm families, tune hyperparameters systematically, ensemble the best performers, and validate rigorously — repeating and refining until a leaderboard score plateaus.',
        analogy: 'This workflow is like preparing for a highly competitive exam where every fractional point matters — you start with a solid foundational understanding (baseline), identify and focus on the topics that matter most (feature selection), practice with multiple different study strategies (algorithms), fine-tune your approach based on practice test results (hyperparameter tuning), and combine your best techniques together (ensembling) for the final attempt.',
        example: 'A typical competition progression: baseline logistic regression scores 0.72, feature engineering improves it to 0.78, switching to XGBoost with default settings reaches 0.83, tuned hyperparameters push it to 0.86, and a final stacked ensemble of the 3 best models reaches 0.88 — each step incrementally squeezing out additional performance.',
        keyTakeaway: 'The single most impactful lever in most tabular data competitions is usually feature engineering, not algorithm choice — a well-engineered feature set often provides a bigger performance jump than switching between already-strong algorithms like XGBoost, LightGBM, or random forests.',
      ),
      ConceptLesson(
        title: 'Avoiding Leaderboard Overfitting',
        definition: 'Repeatedly tuning a model based on a single validation set\'s score (or a competition\'s public leaderboard) risks "leaderboard overfitting" — where the model becomes overly tailored to that specific validation set rather than genuinely generalizing, causing a surprising performance drop on the truly final, unseen evaluation.',
        analogy: 'Leaderboard overfitting is like a student who repeatedly takes the exact same practice test, adjusting their answers each time based on feedback until they score perfectly on THAT SPECIFIC test — but this repeated, targeted adjustment does not actually reflect genuine understanding, and they may perform surprisingly poorly on a genuinely different final exam covering the same material.',
        example: 'A competitor who checks their public leaderboard score after every single small change and relentlessly optimizes purely for that specific score might see their PRIVATE (truly final, hidden) leaderboard score drop significantly — because they inadvertently tuned their model to quirks specific to the public validation subset rather than the underlying general pattern.',
        keyTakeaway: 'Maintain a robust internal cross-validation strategy (Level 5) as your primary guide, and use any external leaderboard or single validation score as a secondary sanity check rather than the sole optimization target — this discipline protects against overfitting to one particular evaluation split.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'In most tabular data machine learning competitions, what typically provides the biggest single performance improvement?',
        options: [
          'Switching between already-strong algorithms like XGBoost and LightGBM, which typically matters far more than anything else',
          'Feature engineering — creating well-designed, informative features usually provides a bigger performance boost than choosing between already-strong algorithm options',
          'The specific programming language used to write the code',
          'The color scheme chosen for any visualizations produced'
        ],
        correctIndex: 1,
        explanation: 'Experienced competitors consistently find that thoughtful feature engineering yields larger performance gains than marginal algorithm choice differences — strong algorithms like XGBoost and LightGBM are already highly capable, but they can only work with the information present in the features provided to them.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is repeatedly tuning a model based purely on a single validation score (or public leaderboard) risky?',
        options: [
          'This is always the correct, ideal approach with no downsides whatsoever',
          'Repeated tuning specifically targeting one validation set risks overfitting to that particular set\'s quirks rather than learning genuinely generalizable patterns, potentially causing a real performance drop on a truly new final evaluation',
          'Validation scores have no relationship to real model performance',
          'This concern only applies to regression competitions, never classification'
        ],
        correctIndex: 1,
        explanation: 'This is the essence of "leaderboard overfitting" — excessive tuning targeted at one specific evaluation split can inadvertently fit noise specific to that split, rather than genuinely improving the model\'s true underlying generalization ability.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You are competing in a tabular data competition and must decide where to invest your limited remaining time: trying a fourth algorithm family, or spending more time engineering new features from the existing raw data. Based on typical competition experience, which is generally the better investment?',
        options: [
          'Always try more algorithm families first, since algorithm choice matters far more than features',
          'Generally, investing more time in feature engineering tends to yield larger performance gains than adding yet another algorithm family, based on common competition experience',
          'Time investment choice has no effect on final competition performance',
          'Algorithm choice and feature engineering are always exactly equally impactful in every situation'
        ],
        correctIndex: 1,
        explanation: 'While trying multiple algorithms has value, experienced practitioners consistently observe that feature engineering investment tends to yield the larger marginal performance improvement — a well-established pattern in tabular data competitions.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'End-to-End Kaggle-Style Prediction Competition',
      goal: 'Simulate a complete, competitive machine learning project — from raw data through a final tuned, ensembled model — on a realistic imbalanced classification problem.',
      steps: [
        'DATA SETUP: Simulate a realistic dataset (n=800) for a churn or fraud-style binary classification problem with 12 raw features, an 8% positive class imbalance, and some genuinely irrelevant noise features mixed in.',
        'BASELINE: Establish a DummyClassifier baseline and a simple LogisticRegression baseline with cross-validated F1 and ROC-AUC scores.',
        'FEATURE ENGINEERING & SELECTION: Create at least 3 new engineered features, then apply a feature selection method to identify the most useful final feature set.',
        'MODEL COMPARISON: Train and cross-validate RandomForestClassifier, GradientBoostingClassifier, and SVC (with class_weight="balanced" where applicable), comparing F1 and ROC-AUC for each.',
        'TUNING: Use RandomizedSearchCV to tune hyperparameters for the best-performing model from the comparison.',
        'ENSEMBLING: Build a VotingClassifier or StackingClassifier combining the top 2-3 tuned models.',
        'FINAL EVALUATION: Evaluate the final ensemble on a completely held-out test set (never used in any tuning), reporting confusion matrix, precision, recall, F1, and ROC-AUC, and compare against the initial baseline.',
      ],
      expectedOutput: '=== LEVEL 6 CAPSTONE: COMPETITIVE ML PIPELINE ===\nBaseline F1: [X]\nFeature Engineering: 3+ features added, [N] selected as most predictive\nModel Comparison: [scores for RF, GB, SVM]\nBest Tuned Model: [name], CV F1=[Y]\nFinal Ensemble Test Performance: F1=[Z], ROC-AUC=[W]\nImprovement over baseline: [clear comparison]\n\nLevel 6 Complete — Advanced Machine Learning Mastered.\nReady for Level 7: Deep Learning Fundamentals.',
      xpReward: 130,
    ),
  ),

];