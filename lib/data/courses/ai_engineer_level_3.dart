// ══════════════════════════════════════════════════════════════════════
// lib/data/courses/ai_level_3.dart
//
// AI Engineer Path — Level 3: Mathematics for Artificial Intelligence
//
// Goal: Build the mathematical foundation required for Machine Learning,
// Deep Learning and modern AI systems.
//
// Uses the shared TopicCourse / ConceptLesson / QuizQuestion / MiniChallenge
// / FinalProject models defined in course_content_data.dart.
// ══════════════════════════════════════════════════════════════════════

import '../../models/course_content_data.dart';

const List<TopicCourse> aiEngineerLevel3 = [

  // ────────────────────────────────────────────────────────────────────
  // 1. LINEAR ALGEBRA ESSENTIALS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'linear_algebra_essentials',
    topicTitle: 'Linear Algebra Essentials',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '📐',
    intro: 'Every AI model — from a simple linear regression to GPT — is built on linear algebra. Images, text, and sound are all converted into numbers arranged in vectors and matrices. Master this, and the "black box" of AI starts making sense.',
    concepts: [
      ConceptLesson(
        title: 'Why Linear Algebra Powers AI',
        definition: 'Linear algebra is the branch of mathematics dealing with vectors, matrices, and the linear transformations between them. It is the language used to represent and manipulate data in AI systems.',
        analogy: 'If AI is a factory, linear algebra is the conveyor belt system — it moves and reshapes raw data (numbers) into the form each machine (layer) needs to do its job.',
        example: 'A 28x28 pixel handwritten digit image isn\'t "seen" by a neural network as a picture — it\'s flattened into a vector of 784 numbers. Every layer in the network then applies matrix operations to that vector.',
        keyTakeaway: 'AI models don\'t understand images, words, or sounds directly. They understand numbers organised as vectors and matrices — and linear algebra is how those numbers are transformed into predictions.',
      ),
      ConceptLesson(
        title: 'Vector Spaces & Linear Combinations',
        definition: 'A vector space is a collection of vectors that can be added together and scaled by numbers. A linear combination is the result of scaling and adding vectors.',
        analogy: 'Mixing paint colours is a linear combination. 2 parts red + 1 part blue gives you a specific purple. Change the proportions, and you get a different point in "colour space".',
        example: 'If v1 = [1, 0] and v2 = [0, 1], then 3*v1 + 2*v2 = [3, 2]. Every point in 2D space can be reached by combining these two vectors — they form a "basis".',
        keyTakeaway: 'Neural network layers are essentially learning the best linear combinations of input features to separate classes or predict values.',
        codeSnippet: 'import numpy as np\n\nv1 = np.array([1, 0])\nv2 = np.array([0, 1])\nresult = 3 * v1 + 2 * v2\nprint(result)  # [3 2]',
      ),
      ConceptLesson(
        title: 'Why AI Engineers Need This (Not Just Mathematicians)',
        definition: 'Unlike pure math, AI engineers use linear algebra operationally — through libraries like NumPy, PyTorch, and TensorFlow — to build, debug, and optimise models.',
        analogy: 'A pilot doesn\'t need to derive the physics of lift from scratch every flight, but understanding aerodynamics helps them react correctly when something goes wrong. Similarly, you won\'t hand-derive every gradient, but understanding linear algebra helps you debug a model that won\'t train.',
        example: 'When a neural network throws a "shape mismatch" error (e.g. cannot multiply a (32, 10) matrix by a (5, 1) matrix), understanding matrix dimensions is what lets you fix it in seconds instead of hours.',
        keyTakeaway: 'You don\'t need a math PhD to be an AI engineer, but fluency in vectors and matrices is what separates someone who copies tutorials from someone who can actually debug and design models.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why is linear algebra fundamental to AI systems?',
        options: [
          'It makes code run faster',
          'AI represents data (images, text, sound) as vectors and matrices, and transforms them using linear algebra',
          'It is only used for visualising data',
          'It is required only for blockchain AI'
        ],
        correctIndex: 1,
        explanation: 'All data fed into AI models — pixels, words, audio samples — is represented numerically as vectors and matrices. Every layer of a model transforms this data using linear algebra operations.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is a linear combination of vectors?',
        options: [
          'Multiplying two vectors element by element',
          'Scaling vectors by numbers and adding the results together',
          'Finding the length of a vector',
          'Sorting vectors by size'
        ],
        correctIndex: 1,
        explanation: 'A linear combination scales each vector by a number (coefficient) and sums the results. This is the core operation neural networks use to combine input features.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A 64x64 colour image (3 colour channels) is flattened into a vector before entering a neural network. How many numbers will that vector contain?',
        options: ['64', '4,096', '12,288', '196,608'],
        correctIndex: 2,
        explanation: '64 x 64 x 3 (RGB channels) = 12,288. Every pixel\'s 3 colour values become individual numbers in the flattened vector.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Vector Space Explorer',
      goal: 'Use NumPy to create vectors and explore linear combinations.',
      steps: [
        'Create two 2D vectors v1 = [2, 1] and v2 = [1, 3]',
        'Compute and print 3 different linear combinations using different scalar coefficients',
        'Compute the vector that results from (2*v1 - v2)',
        'Print all results with clear labels',
      ],
      expectedOutput: '3*v1 + 2*v2 = [8 9]\n1*v1 + 4*v2 = [6 13]\n2*v1 - v2 = [3 -1]',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 2. SCALARS, VECTORS, MATRICES & TENSORS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'scalars_vectors_matrices_tensors',
    topicTitle: 'Scalars, Vectors, Matrices & Tensors',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '🔢',
    intro: 'Before you can build any AI model, you need to know exactly what kind of "container" your data lives in. Scalars, vectors, matrices, and tensors are the four building blocks every machine learning framework is built around.',
    concepts: [
      ConceptLesson(
        title: 'Scalars — Single Numbers',
        definition: 'A scalar is a single number with no direction — just magnitude. It has zero dimensions.',
        analogy: 'A scalar is like a single temperature reading: "25°C". Just one value, nothing more.',
        example: 'In AI: a model\'s learning rate (0.001), a single prediction confidence score (0.92), or the loss value after one training step.',
        keyTakeaway: 'Scalars are 0-dimensional. In code, they are just plain numbers (int or float) — the simplest possible data.',
        codeSnippet: 'learning_rate = 0.001  # scalar\nloss = 0.452           # scalar',
      ),
      ConceptLesson(
        title: 'Vectors — Ordered Lists of Numbers',
        definition: 'A vector is a 1-dimensional array of numbers, representing both magnitude and direction in space.',
        analogy: 'A vector is like a GPS direction: "go 3km East, 4km North". It has multiple components that together describe one thing.',
        example: 'In AI: a word embedding like "king" might be represented as a 300-dimensional vector. A single house\'s features (size, rooms, age) form a vector like [1500, 3, 10].',
        keyTakeaway: 'Vectors are 1-dimensional. Every row of training data (one example) is typically represented as a vector of features.',
        codeSnippet: 'import numpy as np\nhouse = np.array([1500, 3, 10])  # size, rooms, age\nprint(house.shape)  # (3,)',
      ),
      ConceptLesson(
        title: 'Matrices — Grids of Numbers',
        definition: 'A matrix is a 2-dimensional grid of numbers arranged in rows and columns.',
        analogy: 'A matrix is like a spreadsheet — rows represent records (e.g. each student), and columns represent attributes (e.g. each exam score).',
        example: 'A dataset of 100 houses, each with 3 features, forms a 100x3 matrix. Each row is one house\'s feature vector.',
        keyTakeaway: 'Matrices are 2-dimensional. Neural network weights between two layers are stored as matrices.',
        codeSnippet: 'houses = np.array([\n    [1500, 3, 10],\n    [2000, 4, 5],\n    [1200, 2, 20]\n])\nprint(houses.shape)  # (3, 3)',
      ),
      ConceptLesson(
        title: 'Tensors — Multi-Dimensional Arrays',
        definition: 'A tensor is a generalisation of scalars, vectors, and matrices to any number of dimensions. Scalars are 0D tensors, vectors are 1D tensors, matrices are 2D tensors, and tensors can go to 3D, 4D, or higher.',
        analogy: 'If a matrix is a spreadsheet, a tensor is a stack of spreadsheets — like a 3D Excel workbook with multiple sheets, or a 4D version with multiple workbooks for different months.',
        example: 'A single colour image is a 3D tensor (height x width x colour channels). A batch of 32 images is a 4D tensor (batch x height x width x channels) — exactly how PyTorch and TensorFlow store image data.',
        keyTakeaway: 'Every framework — PyTorch, TensorFlow, NumPy — represents ALL data as tensors. Even a single number is technically a 0D tensor. This is why the library is called "TensorFlow".',
        codeSnippet: 'batch_of_images = np.random.rand(32, 64, 64, 3)\nprint(batch_of_images.shape)  # (32, 64, 64, 3)\n# 32 images, 64x64 pixels, 3 colour channels',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'How many dimensions does a vector have?',
        options: ['0', '1', '2', 'Variable, always more than 2'],
        correctIndex: 1,
        explanation: 'A vector is a 1-dimensional array — it has only one axis (length). A scalar has 0 dimensions, a matrix has 2.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the shape of a batch of 16 grayscale images, each 28x28 pixels?',
        options: ['(28, 28)', '(16, 28, 28)', '(16, 28, 28, 3)', '(28, 28, 16)'],
        correctIndex: 1,
        explanation: 'Grayscale images have only 1 colour channel (often omitted), so the shape is (batch_size, height, width) = (16, 28, 28). If they were RGB, it would be (16, 28, 28, 3).',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You have a dataset of 500 students, each with 4 exam scores. What data structure should you use, and what shape will it have?',
        options: ['A vector with shape (500,)', 'A matrix with shape (500, 4)', 'A scalar', 'A tensor with shape (4, 500, 500)'],
        correctIndex: 1,
        explanation: 'Each student is a row (500 rows) and each exam score is a column (4 columns), giving a 2D matrix of shape (500, 4).',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Data Structure Identifier',
      goal: 'Use NumPy to create examples of scalars, vectors, matrices, and tensors and print their dimensions.',
      steps: [
        'Create a scalar (single float), print its value and confirm it has no shape attribute issue using np.array(x).shape',
        'Create a vector of 5 numbers and print its shape',
        'Create a 3x3 matrix and print its shape',
        'Create a 3D tensor representing 2 grayscale images of size 4x4 and print its shape',
        'Print a summary table showing each structure\'s name, dimensions, and shape',
      ],
      expectedOutput: 'Scalar: shape=()\nVector: shape=(5,)\nMatrix: shape=(3, 3)\nTensor: shape=(2, 4, 4)',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 3. MATRIX OPERATIONS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'matrix_operations',
    topicTitle: 'Matrix Operations',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '➕',
    intro: 'Matrix operations are how neural networks transform data layer by layer. Addition, subtraction, scaling, and transposition might look like simple arithmetic — but they are literally what happens inside every AI model when it makes a prediction.',
    concepts: [
      ConceptLesson(
        title: 'Matrix Addition & Subtraction',
        definition: 'You add or subtract matrices by combining corresponding elements — both matrices must have the exact same shape.',
        analogy: 'Imagine two identical spreadsheets of monthly sales for two stores. Adding them element by element gives you the combined sales spreadsheet — cell by cell, in the same position.',
        example: '[[1, 2], [3, 4]] + [[5, 6], [7, 8]] = [[6, 8], [10, 12]]',
        keyTakeaway: 'Matrices can only be added/subtracted if they have the SAME shape. This is used in AI for combining gradients, residual connections in deep networks, and updating weights.',
        codeSnippet: 'import numpy as np\nA = np.array([[1, 2], [3, 4]])\nB = np.array([[5, 6], [7, 8]])\nprint(A + B)\n# [[ 6  8]\n#  [10 12]]',
      ),
      ConceptLesson(
        title: 'Scalar Multiplication',
        definition: 'Multiplying a matrix by a scalar multiplies every single element in the matrix by that number.',
        analogy: 'If a recipe serves 4 people and you scale it for 8 people, you double every ingredient amount. Scalar multiplication does the same to every cell in a matrix.',
        example: '2 * [[1, 2], [3, 4]] = [[2, 4], [6, 8]]',
        keyTakeaway: 'In AI, scalar multiplication is used in gradient descent — scaling the gradient by the learning rate before updating weights.',
        codeSnippet: 'A = np.array([[1, 2], [3, 4]])\nprint(2 * A)\n# [[2 4]\n#  [6 8]]',
      ),
      ConceptLesson(
        title: 'Transpose',
        definition: 'The transpose of a matrix flips it over its diagonal — rows become columns and columns become rows.',
        analogy: 'Imagine rotating a spreadsheet 90 degrees so what was a horizontal row of data becomes a vertical column instead.',
        example: 'Original (2x3): [[1, 2, 3], [4, 5, 6]]\nTransposed (3x2): [[1, 4], [2, 5], [3, 6]]',
        keyTakeaway: 'Transpose is essential when matrix shapes don\'t align for multiplication — a very common fix when debugging neural network shape errors.',
        codeSnippet: 'A = np.array([[1, 2, 3], [4, 5, 6]])\nprint(A.T)\n# [[1 4]\n#  [2 5]\n#  [3 6]]\nprint(A.T.shape)  # (3, 2)',
      ),
      ConceptLesson(
        title: 'Identity & Inverse Matrices',
        definition: 'The identity matrix is a square matrix with 1s on the diagonal and 0s elsewhere — multiplying by it leaves a matrix unchanged. The inverse of a matrix "undoes" its transformation.',
        analogy: 'The identity matrix is like multiplying a number by 1 — nothing changes. The inverse is like dividing — it reverses the operation, getting you back to where you started.',
        example: 'I = [[1, 0], [0, 1]]\nA * I = A (always)\nA * A_inverse = I',
        keyTakeaway: 'Inverse matrices are used in solving systems of linear equations, but in deep learning, true inversion is rarely computed directly — it\'s too expensive at scale, so gradient-based methods are preferred instead.',
        codeSnippet: 'A = np.array([[4, 7], [2, 6]])\nA_inv = np.linalg.inv(A)\nprint(A_inv)\nprint(np.dot(A, A_inv))  # ~Identity matrix',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is required for two matrices to be added together?',
        options: ['They must be square', 'They must have the exact same shape', 'They must both be vectors', 'One must be the identity matrix'],
        correctIndex: 1,
        explanation: 'Matrix addition is element-wise, so both matrices must have exactly the same number of rows and columns.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the transpose of a matrix do?',
        options: ['Multiplies every element by -1', 'Flips rows into columns and columns into rows', 'Deletes the diagonal', 'Doubles the matrix size'],
        correctIndex: 1,
        explanation: 'Transposing swaps rows and columns. A matrix of shape (m, n) becomes shape (n, m) after transposing.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You have weight matrix W with shape (10, 5) and need to multiply it with an input of shape (10, 1), but the shapes don\'t align. What is a common fix?',
        options: ['Add zeros to the input', 'Transpose W to shape (5, 10)', 'Delete W', 'Convert to a scalar'],
        correctIndex: 1,
        explanation: 'Transposing W to (5, 10) allows matrix multiplication W.T with shape (5,10) against input (10,1), producing a valid (5,1) result. Shape mismatches are commonly fixed with transpose.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Matrix Operations Calculator',
      goal: 'Build a NumPy script demonstrating all core matrix operations.',
      steps: [
        'Create two 3x3 matrices A and B with random integers',
        'Compute and print A + B and A - B',
        'Compute and print 5 * A (scalar multiplication)',
        'Compute and print the transpose of A',
        'Compute the inverse of A (if invertible) and verify A @ A_inverse ≈ Identity',
      ],
      expectedOutput: 'A + B:\n[[...]]\nA - B:\n[[...]]\n5 * A:\n[[...]]\nTranspose of A:\n[[...]]\nA @ A_inverse ≈ Identity matrix: True',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 4. DOT PRODUCT & MATRIX MULTIPLICATION
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'dot_product_matrix_multiplication',
    topicTitle: 'Dot Product & Matrix Multiplication',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 140,
    emoji: '✖️',
    intro: 'If there is ONE operation that powers all of deep learning, it\'s matrix multiplication. Every prediction a neural network makes — from spam detection to ChatGPT — boils down to billions of dot products computed at lightning speed.',
    concepts: [
      ConceptLesson(
        title: 'The Dot Product',
        definition: 'The dot product takes two vectors of the same length, multiplies corresponding elements, and sums the results into a single scalar number.',
        analogy: 'Imagine calculating your total grocery bill: multiply each item\'s price by its quantity, then add them all up. That single final total is exactly what a dot product computes.',
        example: 'a = [1, 2, 3], b = [4, 5, 6]\nDot product = (1*4) + (2*5) + (3*6) = 4 + 10 + 18 = 32',
        keyTakeaway: 'The dot product measures how much two vectors "agree" in direction. It is the single most repeated operation inside a neural network — every neuron computes a dot product of inputs and weights.',
        codeSnippet: 'import numpy as np\na = np.array([1, 2, 3])\nb = np.array([4, 5, 6])\nprint(np.dot(a, b))  # 32',
      ),
      ConceptLesson(
        title: 'Matrix Multiplication',
        definition: 'Matrix multiplication combines two matrices by computing the dot product of each row of the first matrix with each column of the second, producing a new matrix.',
        analogy: 'Imagine a factory where each worker (row) has different skills, and each task (column) needs different skill combinations. Matrix multiplication computes how well every worker matches every task, all at once.',
        example: 'A (2x3) @ B (3x2) = C (2x2)\n\nEach element of C is the dot product of a row from A and a column from B.',
        keyTakeaway: 'For A @ B to work, the number of COLUMNS in A must equal the number of ROWS in B. This single rule explains 90% of "shape mismatch" errors in deep learning.',
        codeSnippet: 'A = np.array([[1, 2, 3], [4, 5, 6]])      # shape (2, 3)\nB = np.array([[7, 8], [9, 10], [11, 12]]) # shape (3, 2)\nC = A @ B                                  # shape (2, 2)\nprint(C)',
      ),
      ConceptLesson(
        title: 'Matrix Multiplication Inside a Neural Network',
        definition: 'A neural network layer computes output = input @ weights + bias, where @ is matrix multiplication. This single operation is repeated at every layer.',
        analogy: 'Imagine an assembly line where each station (layer) takes the previous station\'s output, applies a specific transformation (matrix multiply), and passes it forward. The final output after all stations is the prediction.',
        example: 'Input: [batch_size=32, features=10]\nWeights: [features=10, neurons=64]\nOutput: [batch_size=32, neurons=64] = Input @ Weights',
        keyTakeaway: 'This is literally what "training a neural network" means at the lowest level: adjusting the numbers inside weight matrices so that input @ weights produces correct outputs.',
        codeSnippet: 'inputs = np.random.rand(32, 10)   # 32 samples, 10 features\nweights = np.random.rand(10, 64)  # 10 inputs -> 64 neurons\noutput = inputs @ weights\nprint(output.shape)  # (32, 64)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does the dot product of two vectors return?',
        options: ['A vector', 'A matrix', 'A single scalar number', 'A tensor'],
        correctIndex: 2,
        explanation: 'The dot product multiplies corresponding elements and sums them, always producing a single number (scalar), regardless of the vectors\' length.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'For matrix A (shape 4x6) to be multiplied with matrix B, what shape must B have?',
        options: ['(6, n) for any n', '(4, n) for any n', '(n, 4) for any n', 'Must also be (4, 6)'],
        correctIndex: 0,
        explanation: 'The number of columns in A (6) must match the number of rows in B. So B must have shape (6, n), and the result will have shape (4, n).',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You get a "ValueError: shapes (32,10) and (64,10) not aligned" error when computing input @ weights. What is the most likely fix?',
        options: ['Add more training data', 'Transpose the weights matrix to shape (10, 64)', 'Use a smaller batch size', 'Switch to addition instead of multiplication'],
        correctIndex: 1,
        explanation: 'Matrix multiplication requires inner dimensions to match. (32,10) needs a second matrix starting with 10 rows, so transposing weights from (64,10) to (10,64) fixes the mismatch.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Mini Neural Network Layer Simulator',
      goal: 'Simulate a single neural network layer using only dot products and matrix multiplication in NumPy.',
      steps: [
        'Create an input matrix of shape (5, 3) representing 5 samples with 3 features each',
        'Create a weights matrix of shape (3, 4) representing 4 neurons',
        'Create a bias vector of shape (4,)',
        'Compute output = input @ weights + bias',
        'Print the shape and values of the output, and explain in a comment what each dimension represents',
      ],
      expectedOutput: 'Output shape: (5, 4)\nOutput:\n[[...]]\n# 5 samples, each transformed into 4 neuron activations',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 5. PROBABILITY FUNDAMENTALS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'probability_fundamentals',
    topicTitle: 'Probability Fundamentals',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '🎲',
    intro: 'AI models rarely give certain answers — they give probabilities. "90% chance this is spam" or "70% confident this is a cat" — probability is the language of uncertainty, and uncertainty is everywhere in AI.',
    concepts: [
      ConceptLesson(
        title: 'What is Probability?',
        definition: 'Probability measures how likely an event is to happen, expressed as a number between 0 (impossible) and 1 (certain).',
        analogy: 'Probability is like a weather forecast. "70% chance of rain" doesn\'t guarantee rain — it tells you how confident the forecaster is, based on patterns in the data.',
        example: 'A coin flip: P(heads) = 0.5. A fair die: P(rolling a 4) = 1/6 ≈ 0.167. A spam classifier: P(spam | this email) = 0.92.',
        keyTakeaway: 'Probability is the mathematical foundation of confidence scores, classification outputs, and uncertainty estimation in every AI system.',
        codeSnippet: 'import numpy as np\n# Simulate 10,000 coin flips\nflips = np.random.choice(["H", "T"], size=10000)\np_heads = np.mean(flips == "H")\nprint(p_heads)  # ~0.5',
      ),
      ConceptLesson(
        title: 'Independent vs Dependent Events',
        definition: 'Independent events don\'t affect each other\'s outcomes. Dependent events do — the probability of one changes based on whether the other happened.',
        analogy: 'Flipping a coin twice: independent — the first flip doesn\'t affect the second. Drawing cards without replacement: dependent — drawing an Ace changes the odds of drawing another Ace.',
        example: 'Independent: P(rain today) and P(coin shows heads) — unrelated.\nDependent: P(it rains) and P(you bring an umbrella) — highly related.',
        keyTakeaway: 'Many AI models, like Naive Bayes, ASSUME features are independent to simplify calculations — even when they aren\'t perfectly independent in reality. This trade-off is intentional for speed and simplicity.',
      ),
      ConceptLesson(
        title: 'Probability Distributions (Intro)',
        definition: 'A probability distribution describes how probabilities are spread across all possible outcomes of a random variable.',
        analogy: 'A probability distribution is like a height chart of a population — most people cluster around average height, with fewer very short or very tall people. The "shape" of that chart is the distribution.',
        example: 'Discrete: rolling a die has a uniform distribution (each of 6 outcomes equally likely).\nContinuous: human heights follow a normal (bell curve) distribution.',
        keyTakeaway: 'Many AI algorithms assume the data follows a specific distribution (often Normal/Gaussian). Understanding distributions helps you choose the right model and interpret its outputs correctly.',
        codeSnippet: 'import numpy as np\nimport matplotlib.pyplot as plt\nsamples = np.random.normal(loc=0, scale=1, size=1000)\nplt.hist(samples, bins=30)\nplt.show()',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What range of values can a probability take?',
        options: ['-1 to 1', '0 to 1', '0 to 100', '1 to 10'],
        correctIndex: 1,
        explanation: 'Probability is always between 0 (impossible) and 1 (certain), inclusive. It is often expressed as a percentage (0% to 100%) but the raw value is between 0 and 1.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which of these is an example of dependent events?',
        options: [
          'Flipping a coin twice',
          'Rolling two separate dice',
          'Drawing two cards from a deck WITHOUT replacing the first',
          'Two unrelated weather events in different cities'
        ],
        correctIndex: 2,
        explanation: 'Drawing without replacement is dependent — removing the first card changes the probabilities for the second draw, since the deck composition changed.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A spam filter outputs P(spam) = 0.92 for an email. What does this number represent?',
        options: [
          'The email is definitely spam',
          'There is a 92% model confidence that the email is spam, based on learned patterns',
          'The email has 92 spam keywords',
          'The model is broken'
        ],
        correctIndex: 1,
        explanation: 'Classifier outputs are probabilities representing the model\'s confidence, not certainty. 0.92 means the model is fairly confident, but it could still be wrong — that\'s the nature of probabilistic predictions.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Probability Simulation Lab',
      goal: 'Use NumPy to simulate and verify probability concepts experimentally.',
      steps: [
        'Simulate 10,000 fair coin flips and calculate the empirical probability of heads',
        'Simulate 10,000 rolls of a 6-sided die and calculate the empirical probability of each number',
        'Simulate drawing 2 cards without replacement from a simplified 10-card deck (4 aces, 6 others) 10,000 times and estimate P(both aces)',
        'Print all results compared to the theoretical probabilities',
      ],
      expectedOutput: 'P(Heads) empirical: 0.501 (theoretical: 0.5)\nP(Roll=4) empirical: 0.166 (theoretical: 0.167)\nP(Both Aces) empirical: 0.133 (theoretical: 0.133)',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 6. CONDITIONAL PROBABILITY & BAYES' THEOREM
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'conditional_probability_bayes',
    topicTitle: 'Conditional Probability & Bayes\' Theorem',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 140,
    emoji: '🔁',
    intro: 'Bayes\' Theorem is arguably the single most influential formula in AI. It powers spam filters, medical diagnosis systems, recommendation engines, and is the mathematical backbone of how AI updates beliefs as new evidence arrives.',
    concepts: [
      ConceptLesson(
        title: 'Conditional Probability',
        definition: 'Conditional probability is the probability of an event occurring GIVEN that another event has already occurred, written as P(A | B).',
        analogy: 'P(rain | cloudy sky) is much higher than P(rain) alone. Knowing it\'s cloudy changes — conditions — your estimate of rain. That\'s exactly what "conditional" means.',
        example: 'P(disease | positive test result) ≠ P(disease) alone. A positive test increases your probability estimate, but doesn\'t guarantee the disease — false positives exist.',
        keyTakeaway: 'Conditional probability is written P(A|B) = P(A and B) / P(B). It is the foundation for how AI systems incorporate new evidence to update predictions.',
        codeSnippet: '# P(A|B) = P(A and B) / P(B)\np_a_and_b = 0.15\np_b = 0.30\np_a_given_b = p_a_and_b / p_b\nprint(p_a_given_b)  # 0.5',
      ),
      ConceptLesson(
        title: 'Bayes\' Theorem',
        definition: 'Bayes\' Theorem describes how to update the probability of a hypothesis based on new evidence: P(A|B) = [P(B|A) * P(A)] / P(B).',
        analogy: 'Imagine a doctor diagnosing a rare disease. Before the test (prior belief), they think there\'s a 1% chance. After a positive test result (new evidence), Bayes\' Theorem tells them exactly how much to update that belief — not jump straight to 99%, but calculate the real updated probability.',
        example: 'P(Spam | "free money") = [P("free money" | Spam) * P(Spam)] / P("free money")\n\nThis is exactly how the Naive Bayes spam classifier algorithm works.',
        keyTakeaway: 'Bayes\' Theorem combines PRIOR belief with NEW EVIDENCE to produce an updated, more accurate POSTERIOR probability. This "update your beliefs with evidence" pattern appears throughout AI — from spam filters to Bayesian neural networks.',
        codeSnippet: 'def bayes_theorem(p_b_given_a, p_a, p_b):\n    return (p_b_given_a * p_a) / p_b\n\n# Disease example\np_disease = 0.01            # prior\np_positive_given_disease = 0.95\np_positive = 0.06\nresult = bayes_theorem(p_positive_given_disease, p_disease, p_positive)\nprint(result)  # ~0.158',
      ),
      ConceptLesson(
        title: 'Naive Bayes Classifier',
        definition: 'Naive Bayes is a classification algorithm that applies Bayes\' Theorem, "naively" assuming all features are independent of each other to simplify computation.',
        analogy: 'It\'s like a doctor who, to save time, assumes every symptom (fever, cough, fatigue) is completely unrelated to the others when estimating a diagnosis — not perfectly accurate, but fast and surprisingly effective in practice.',
        example: 'Email spam detection: Naive Bayes calculates P(spam | word1, word2, word3...) by multiplying individual word probabilities, assuming each word\'s presence is independent of the others.',
        keyTakeaway: 'Despite its "naive" independence assumption being technically wrong, Naive Bayes is fast, simple, and remarkably effective for text classification tasks like spam detection and sentiment analysis.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does P(A | B) represent?',
        options: [
          'The probability of A and B both happening independently',
          'The probability of A occurring given that B has already occurred',
          'The probability of B occurring given A has occurred',
          'The probability that A and B never happen together'
        ],
        correctIndex: 1,
        explanation: 'P(A|B) reads as "probability of A given B" — it is the probability of A happening, updated based on the knowledge that B has already occurred.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What two key pieces does Bayes\' Theorem combine to produce a posterior probability?',
        options: [
          'Mean and variance',
          'Prior belief and new evidence',
          'Maximum and minimum values',
          'Two independent random variables'
        ],
        correctIndex: 1,
        explanation: 'Bayes\' Theorem combines your PRIOR probability (what you believed before) with new EVIDENCE (the likelihood of observing the data) to compute an updated POSTERIOR probability.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is Naive Bayes called "naive"?',
        options: [
          'It is a beginner-level algorithm',
          'It assumes all features are independent of each other, which is rarely true in reality',
          'It only works with small datasets',
          'It cannot be used for production systems'
        ],
        correctIndex: 1,
        explanation: 'The "naive" assumption is that all features (e.g. words in an email) are statistically independent given the class — an oversimplification, but one that makes the algorithm fast and surprisingly effective.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A rare disease affects 1% of people. A test is 95% accurate for sick people (true positive rate) but also has a 5% false positive rate on healthy people. If you test positive, why is your actual probability of having the disease likely much LOWER than 95%?',
        options: [
          'Because the test is broken',
          'Because the disease is rare (low prior), so most positive results come from the much larger healthy population testing falsely positive',
          'Because Bayes\' Theorem only works for common diseases',
          'Because 95% accuracy is too low'
        ],
        correctIndex: 1,
        explanation: 'This is the classic "base rate fallacy". With only 1% prevalence, even a small false-positive rate among the 99% healthy population produces more false positives in absolute numbers than true positives from the rare 1% sick population. Bayes\' Theorem corrects for this intuition error.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Medical Diagnosis Bayes Calculator',
      goal: 'Build a Python tool that applies Bayes\' Theorem to a realistic medical testing scenario.',
      steps: [
        'Write a bayes_theorem(p_b_given_a, p_a, p_b) function',
        'Define prior P(disease) = 0.01, P(positive|disease) = 0.95, P(positive|no disease) = 0.05',
        'Calculate P(positive) using the law of total probability: P(positive|disease)*P(disease) + P(positive|no disease)*P(no disease)',
        'Calculate and print P(disease | positive) using Bayes\' Theorem',
        'Print a clear explanation comparing the prior (1%) to the posterior probability',
      ],
      expectedOutput: 'Prior P(disease): 0.01 (1%)\nPosterior P(disease | positive test): 0.16 (16%)\n\nEven with a positive test, true probability is only ~16% due to the rarity of the disease.',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 7. STATISTICS FOR AI
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'statistics_for_ai',
    topicTitle: 'Statistics for AI',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '📈',
    intro: 'Statistics is how AI engineers make sense of raw data before a single model is trained. From cleaning datasets to evaluating model performance, statistical thinking is what separates a reliable AI system from a fragile one.',
    concepts: [
      ConceptLesson(
        title: 'Descriptive vs Inferential Statistics',
        definition: 'Descriptive statistics summarise and describe data you already have. Inferential statistics use a sample of data to make predictions or conclusions about a larger population.',
        analogy: 'Descriptive statistics is like describing the 30 students in your classroom. Inferential statistics is using those 30 students to predict something about every student in the country.',
        example: 'Descriptive: "The average age in this dataset of 1,000 customers is 34."\nInferential: "Based on this sample, we estimate the average age of ALL our customers (millions) is between 32-36."',
        keyTakeaway: 'AI engineers use descriptive statistics to explore datasets (EDA — Exploratory Data Analysis) and inferential statistics to validate whether a model\'s performance will generalise to new, unseen data.',
      ),
      ConceptLesson(
        title: 'Why Statistics Matters for AI Engineers',
        definition: 'Statistics provides the tools to understand data quality, detect bias, measure model performance, and determine whether results are meaningful or just random noise.',
        analogy: 'Imagine launching a product update and seeing sales go up by 2%. Is that a real improvement, or just random daily fluctuation? Statistics (specifically hypothesis testing) is how you separate signal from noise.',
        example: 'A/B testing a new recommendation algorithm: Statistics tells you whether a 3% engagement increase is statistically significant or just random chance.',
        keyTakeaway: 'Without statistics, AI engineers cannot reliably tell whether a model improvement is real or coincidental — this is one of the most common mistakes in industry AI projects.',
      ),
      ConceptLesson(
        title: 'Correlation vs Causation',
        definition: 'Correlation means two variables move together. Causation means one variable directly CAUSES the change in another. Correlation does NOT imply causation.',
        analogy: 'Ice cream sales and drowning incidents both rise in summer — they\'re correlated. But ice cream doesn\'t cause drowning. Both are caused by a third factor: hot weather.',
        example: 'An AI model finds that "umbrella sales" correlate with "traffic accidents". It would be wrong to conclude umbrellas cause accidents — rainy weather causes both.',
        keyTakeaway: 'AI models, especially simple ones, can easily mistake correlation for causation. This is why "explainable AI" and careful feature analysis matter — to avoid building models on spurious patterns.',
        codeSnippet: 'import numpy as np\nx = np.array([1, 2, 3, 4, 5])\ny = np.array([2, 4, 5, 4, 5])\ncorrelation = np.corrcoef(x, y)[0, 1]\nprint(correlation)  # e.g. 0.77 — correlated, not necessarily causal',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main difference between descriptive and inferential statistics?',
        options: [
          'Descriptive statistics summarises existing data; inferential statistics draws conclusions about a larger population from a sample',
          'They are exactly the same thing',
          'Descriptive statistics is only for AI; inferential is for traditional statistics',
          'Inferential statistics never uses real data'
        ],
        correctIndex: 0,
        explanation: 'Descriptive statistics describes the data you have (mean, median, charts). Inferential statistics uses a sample to make generalised conclusions or predictions about a wider population.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'If two variables are strongly correlated, what can you conclude?',
        options: [
          'One variable definitely causes the other',
          'They move together, but this does NOT prove one causes the other',
          'They are completely unrelated',
          'The correlation is always a coding error'
        ],
        correctIndex: 1,
        explanation: 'Correlation only shows that two variables tend to move together. It never proves causation — a third hidden factor could be driving both, or the relationship could be coincidental.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'An AI model finds a strong correlation between "number of fire trucks at a scene" and "amount of fire damage". Should you conclude fire trucks CAUSE damage?',
        options: [
          'Yes, remove fire trucks to reduce damage',
          'No — bigger fires naturally cause both more damage AND require more fire trucks. This is a confounding variable, not causation',
          'Yes, because the correlation is statistically significant',
          'Statistics cannot detect this kind of relationship'
        ],
        correctIndex: 1,
        explanation: 'This is a classic correlation-causation trap. Fire size is the confounding variable causing both more trucks to be dispatched AND more damage. Removing trucks would not reduce damage — it would make things worse.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Exploratory Data Analysis Report',
      goal: 'Use NumPy to perform descriptive statistics and correlation analysis on a sample dataset.',
      steps: [
        'Create a synthetic dataset of 100 "employees" with random salary and years_of_experience arrays',
        'Calculate and print mean, median, and standard deviation for both arrays',
        'Calculate the correlation coefficient between salary and years_of_experience',
        'Print a conclusion stating whether the correlation is strong, and a caution about NOT assuming causation',
      ],
      expectedOutput: 'Salary - Mean: 65000, Median: 64500, Std Dev: 12300\nExperience - Mean: 7.2, Median: 7, Std Dev: 3.1\nCorrelation: 0.81 (strong positive)\nNote: Correlation does not imply causation.',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 8. MEAN, MEDIAN, MODE, VARIANCE & STANDARD DEVIATION
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'mean_median_mode_variance_std',
    topicTitle: 'Mean, Median, Mode, Variance & Standard Deviation',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '📊',
    intro: 'These five measures are the most-used statistics in all of AI and data science. Every dataset you ever load — before you train a single model — gets summarised using mean, median, mode, variance, and standard deviation.',
    concepts: [
      ConceptLesson(
        title: 'Mean, Median & Mode',
        definition: 'Mean is the average of all values. Median is the middle value when sorted. Mode is the most frequently occurring value.',
        analogy: 'Imagine 5 friends\' salaries. Mean is what each would get if you pooled and split equally. Median is what the middle friend earns when lined up by salary. Mode is the salary amount that appears most often among them.',
        example: 'Data: [10, 12, 12, 15, 100]\nMean = (10+12+12+15+100)/5 = 29.8\nMedian = 12 (middle value when sorted)\nMode = 12 (appears twice)',
        keyTakeaway: 'Mean is sensitive to outliers (the 100 pulled it way up). Median is robust to outliers. Always check both — if they differ a lot, your data likely has outliers or skew.',
        codeSnippet: 'import numpy as np\ndata = np.array([10, 12, 12, 15, 100])\nprint(np.mean(data))    # 29.8\nprint(np.median(data))  # 12.0\nfrom scipy import stats\nprint(stats.mode(data, keepdims=True).mode)  # [12]',
      ),
      ConceptLesson(
        title: 'Variance',
        definition: 'Variance measures how spread out data points are from the mean, calculated as the average of squared differences from the mean.',
        analogy: 'Imagine two archers. Both average a bullseye, but one\'s arrows are tightly clustered (low variance) while the other\'s are scattered all over the target (high variance). Same average, very different consistency.',
        example: 'Data: [2, 4, 4, 4, 5, 5, 7, 9]\nMean = 5\nVariance = average of (value - mean)² for each value = 4.0',
        keyTakeaway: 'High variance means data is unpredictable and spread out. Low variance means data is consistent and predictable. Variance is squared, so its units are not directly interpretable — that\'s why we use standard deviation.',
        codeSnippet: 'data = np.array([2, 4, 4, 4, 5, 5, 7, 9])\nprint(np.var(data))  # 4.0',
      ),
      ConceptLesson(
        title: 'Standard Deviation',
        definition: 'Standard deviation is the square root of variance, bringing the spread measurement back into the same units as the original data.',
        analogy: 'If variance tells you "how spread out" in squared units (hard to interpret, like "squared dollars"), standard deviation translates it back into normal units you can actually understand, like "dollars".',
        example: 'Variance = 4.0 → Standard Deviation = √4.0 = 2.0\n\nFor a dataset of test scores with mean=70 and std=10, most students score between 60-80 (within 1 standard deviation).',
        keyTakeaway: 'Standard deviation is one of the most used metrics in AI — for normalising data (z-score scaling), detecting outliers, and measuring model prediction uncertainty.',
        codeSnippet: 'data = np.array([2, 4, 4, 4, 5, 5, 7, 9])\nprint(np.std(data))  # 2.0\n\n# Z-score normalization (used before training many ML models)\nz_scores = (data - np.mean(data)) / np.std(data)\nprint(z_scores)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which measure of central tendency is MOST resistant to outliers?',
        options: ['Mean', 'Median', 'Mode', 'Standard Deviation'],
        correctIndex: 1,
        explanation: 'Median only looks at the middle value\'s position, so extreme outliers don\'t pull it as much as they pull the mean (which sums all values).',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is standard deviation mathematically?',
        options: ['The average of all values', 'The most frequent value', 'The square root of variance', 'The difference between max and min'],
        correctIndex: 2,
        explanation: 'Standard deviation = √variance. It converts the "squared spread" of variance back into the original data units, making it easier to interpret.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Two ML models both have 85% mean accuracy across 10 test runs. Model A has std dev = 1%. Model B has std dev = 15%. Which model would you trust more for production?',
        options: [
          'Model B, because high variance shows it can also perform much better',
          'Model A, because its low standard deviation means consistent, predictable performance',
          'They are equally trustworthy since the mean is the same',
          'Neither — standard deviation is irrelevant to model selection'
        ],
        correctIndex: 1,
        explanation: 'Model A is more reliable. Same average performance, but Model A is consistent (low std dev) while Model B is unpredictable — it might score 70% or 100% on any given run. Consistency matters greatly in production AI systems.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Statistical Summary Toolkit',
      goal: 'Build a reusable Python function that computes a full statistical summary of any numeric dataset.',
      steps: [
        'Write a function summarize(data) that returns a dictionary with mean, median, mode, variance, and std dev',
        'Test it on a dataset of 20 exam scores you generate with NumPy',
        'Test it again on the same data with one extreme outlier added (e.g. a score of 0 or 100 added to otherwise normal scores)',
        'Print both summaries side by side and explain how the outlier affected mean vs median',
      ],
      expectedOutput: 'Without outlier: Mean=75.2, Median=76.0, Std=8.1\nWith outlier: Mean=68.5, Median=76.0, Std=18.4\n\nObservation: Median stayed stable; mean and std dev were both pulled by the outlier.',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 9. DATA DISTRIBUTIONS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'data_distributions',
    topicTitle: 'Data Distributions',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '🔔',
    intro: 'Understanding how your data is distributed is one of the first and most important steps before training any AI model. The shape of your data determines which algorithms will work well, and which will fail badly.',
    concepts: [
      ConceptLesson(
        title: 'The Normal (Gaussian) Distribution',
        definition: 'The normal distribution is a symmetric, bell-shaped curve where most values cluster around the mean, with fewer values further away in both directions.',
        analogy: 'Human height follows a normal distribution. Most people are near average height, with progressively fewer people as you go toward very short or very tall — forming a smooth bell shape.',
        example: 'IQ scores, measurement errors, and many natural phenomena follow normal distributions: mean=100, std dev=15. About 68% of people fall within 1 std dev (85-115).',
        keyTakeaway: 'Many statistical AI methods (like linear regression) assume normally distributed data or errors. Always check this assumption — violating it can hurt model performance.',
        codeSnippet: 'import numpy as np\ndata = np.random.normal(loc=100, scale=15, size=10000)\nprint(np.mean(data))  # ~100\nprint(np.std(data))   # ~15',
      ),
      ConceptLesson(
        title: 'Skewed Distributions',
        definition: 'A skewed distribution is asymmetric — it has a long "tail" stretching out on one side, pulling the mean away from the median.',
        analogy: 'Income distribution is right-skewed: most people earn a moderate amount, but a small number of billionaires create a long tail stretching the average far above what a typical person earns.',
        example: 'Right-skewed (positive skew): mean > median (e.g. salaries, house prices)\nLeft-skewed (negative skew): mean < median (e.g. age at retirement)',
        keyTakeaway: 'When data is heavily skewed, the mean becomes misleading. AI engineers often apply transformations (like log transform) to make skewed data more normal before training models.',
        codeSnippet: '# Log transform to fix right-skewed data (e.g. salaries)\nskewed_data = np.random.exponential(scale=50000, size=1000)\nnormalized = np.log1p(skewed_data)\nprint(f"Skew before: {((skewed_data - skewed_data.mean())**3).mean()}")',
      ),
      ConceptLesson(
        title: 'Why Distributions Matter for AI Models',
        definition: 'Different AI algorithms make different assumptions about the underlying data distribution — knowing your data\'s shape helps you pick the right model and preprocessing steps.',
        analogy: 'Choosing a model without checking your data distribution is like choosing shoes without knowing if you\'ll walk on sand, ice, or pavement — the wrong choice leads to poor performance.',
        example: 'Linear regression assumes residuals are normally distributed. If your target variable (e.g. house prices) is heavily right-skewed, predictions will be biased unless you transform the data first.',
        keyTakeaway: 'Always visualise your data distribution (histograms) BEFORE choosing a model. Mismatched assumptions between your data and your algorithm is one of the most common causes of poor model performance.',
        codeSnippet: 'import matplotlib.pyplot as plt\ndata = np.random.normal(0, 1, 1000)\nplt.hist(data, bins=30)\nplt.title("Distribution Check")\nplt.show()',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What shape does a normal (Gaussian) distribution have?',
        options: ['A flat line', 'A symmetric bell curve centred on the mean', 'A sharp spike at zero', 'A staircase pattern'],
        correctIndex: 1,
        explanation: 'The normal distribution is symmetric and bell-shaped, with most values clustered near the mean and progressively fewer values further away in both directions.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'In a right-skewed distribution, what is typically true about mean vs median?',
        options: ['Mean equals median', 'Mean is greater than median', 'Mean is less than median', 'There is no relationship'],
        correctIndex: 1,
        explanation: 'Right-skewed data has a long tail of high values that pull the mean upward, while the median (which only cares about position) stays closer to where most data is concentrated.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You\'re building a model to predict house prices, and the price data is heavily right-skewed (a few mansions cost 50x the typical house). What should you consider doing before training?',
        options: [
          'Ignore the skew — it never matters',
          'Apply a log transformation to the price data to make it more normally distributed',
          'Delete all the expensive houses from the dataset',
          'Use only the mode of prices for prediction'
        ],
        correctIndex: 1,
        explanation: 'Log transformation compresses large values more than small ones, reducing skew and making the data closer to a normal distribution — which many regression algorithms assume and perform better with.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Distribution Detective',
      goal: 'Generate, visualise, and diagnose different data distributions using NumPy.',
      steps: [
        'Generate 3 datasets: one normal, one right-skewed (exponential), one uniform — each with 5000 samples',
        'For each dataset, calculate mean, median, and a simple skew estimate ((mean - median))',
        'Print a diagnosis for each: "Normal", "Right-skewed", or "Left-skewed/Uniform" based on the mean-median comparison',
        'Apply a log transform to the skewed dataset and re-check whether mean and median are now closer together',
      ],
      expectedOutput: 'Dataset 1 (Normal): mean≈median → Symmetric\nDataset 2 (Exponential): mean > median → Right-skewed\nAfter log transform: mean≈median → Skew reduced',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 10. CALCULUS BASICS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'calculus_basics',
    topicTitle: 'Calculus Basics',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '∫',
    intro: 'Calculus sounds intimidating, but for AI you only need ONE core idea: rate of change. Every time a neural network "learns", it is using calculus to figure out which direction to adjust its weights to reduce errors.',
    concepts: [
      ConceptLesson(
        title: 'What is a Function\'s Rate of Change?',
        definition: 'The rate of change measures how much one quantity changes in response to a change in another — essentially, the "slope" at any given point.',
        analogy: 'Your car\'s speedometer shows the rate of change of distance over time. It tells you HOW FAST your position is changing at this exact instant — not your average speed over the whole trip.',
        example: 'If a function f(x) = x² represents a model\'s error based on a weight x, the rate of change at any point tells you whether increasing or decreasing x will reduce the error.',
        keyTakeaway: 'In AI, the "function" is usually the loss/error function, and the input is a model\'s weights. Calculus tells us exactly how to adjust weights to reduce error.',
      ),
      ConceptLesson(
        title: 'Limits — The Foundation of Calculus',
        definition: 'A limit describes the value a function approaches as the input gets closer and closer to a specific point, even if it never quite reaches it.',
        analogy: 'Imagine walking halfway to a wall, then half of the remaining distance, then half again — you get infinitely close to the wall without technically touching it. The wall\'s position is the "limit" you\'re approaching.',
        example: 'As x approaches 0, the function f(x) = sin(x)/x approaches 1, even though directly plugging in x=0 gives an undefined 0/0.',
        keyTakeaway: 'Limits are the mathematical foundation that makes derivatives possible — they let us precisely define "instantaneous rate of change" even though we can\'t literally divide by zero.',
      ),
      ConceptLesson(
        title: 'Why AI Needs Calculus (Not Algebra Alone)',
        definition: 'Algebra solves static equations. Calculus handles CHANGE — exactly what\'s needed when a model needs to improve itself iteratively based on errors.',
        analogy: 'Algebra is like reading a single photo of a race — you see one moment. Calculus is like watching the video — you see how positions change over time, which is what you need to know HOW to improve.',
        example: 'A neural network with millions of weights needs to know exactly how a tiny change in EACH weight affects the final error. Calculus (specifically derivatives) computes this efficiently using the chain rule.',
        keyTakeaway: 'Without calculus, there is no way to mathematically determine HOW to adjust a model\'s parameters to reduce errors. This is why calculus is non-negotiable for understanding how AI training works.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does "rate of change" measure?',
        options: [
          'The total value of a function',
          'How much one quantity changes in response to a change in another',
          'The maximum value a function can reach',
          'The number of inputs to a function'
        ],
        correctIndex: 1,
        explanation: 'Rate of change describes how sensitive an output is to changes in input — essentially the slope of the function at a given point.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is calculus essential for training AI models, beyond just algebra?',
        options: [
          'It makes code run faster',
          'It allows us to compute how to adjust millions of weights to reduce model error iteratively',
          'It is not actually needed for AI',
          'It only matters for image-based AI models'
        ],
        correctIndex: 1,
        explanation: 'Training a model means iteratively improving it. Calculus (derivatives) tells us the exact direction and magnitude to adjust each weight to reduce error — something static algebra cannot do.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A model\'s error function shows a very steep slope at the current weight value. What does this suggest?',
        options: [
          'The model is perfectly trained',
          'A small change in that weight will cause a large change in error — meaning a bigger adjustment may be needed',
          'The weight has no effect on the error',
          'The model should stop training immediately'
        ],
        correctIndex: 1,
        explanation: 'A steep slope (high rate of change) means the weight is highly sensitive — small changes have a big impact on error. This is exactly the information gradient-based optimisation uses to decide how much to adjust weights.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Rate of Change Visualizer',
      goal: 'Use NumPy to numerically estimate the rate of change of a simple function at different points.',
      steps: [
        'Define a function f(x) = x**2 + 3*x in Python',
        'Write a numerical_rate_of_change(f, x, h=0.0001) function that estimates the slope using (f(x+h) - f(x)) / h',
        'Calculate the rate of change at x = -2, 0, and 3',
        'Print results and explain in a comment what a positive vs negative rate of change means for that point',
      ],
      expectedOutput: 'Rate of change at x=-2: -1.0\nRate of change at x=0: 3.0\nRate of change at x=3: 9.0',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 11. DERIVATIVES & GRADIENTS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'derivatives_gradients',
    topicTitle: 'Derivatives & Gradients',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Hard',
    estimatedMinutes: 30,
    totalXp: 150,
    emoji: '📉',
    intro: 'Derivatives and gradients are the engine behind every neural network\'s ability to learn. This is THE most important mathematical concept in deep learning — understand this, and "backpropagation" stops being mysterious.',
    concepts: [
      ConceptLesson(
        title: 'The Derivative',
        definition: 'A derivative measures the instantaneous rate of change of a function at a specific point — essentially, the slope of the tangent line at that exact spot.',
        analogy: 'A derivative is like checking your exact speed at one precise moment using a radar gun, rather than calculating your average speed over an entire journey.',
        example: 'For f(x) = x², the derivative f\'(x) = 2x. At x=3, the slope is 2*3 = 6 — meaning the function is increasing steeply at that point.',
        keyTakeaway: 'The derivative tells you the direction AND steepness of change. In AI, it tells the model exactly which direction to adjust a parameter to reduce error.',
        codeSnippet: '# Numerical derivative approximation\ndef derivative(f, x, h=1e-5):\n    return (f(x + h) - f(x - h)) / (2 * h)\n\nf = lambda x: x**2\nprint(derivative(f, 3))  # ~6.0 (matches 2x at x=3)',
      ),
      ConceptLesson(
        title: 'Partial Derivatives',
        definition: 'A partial derivative measures the rate of change of a function with respect to ONE variable, while holding all other variables constant.',
        analogy: 'Imagine a hilly landscape with two directions: North-South and East-West. A partial derivative tells you the slope if you only walk North, ignoring how steep it is going East.',
        example: 'For f(x, y) = x² + y³:\n∂f/∂x = 2x (treating y as a constant)\n∂f/∂y = 3y² (treating x as a constant)',
        keyTakeaway: 'Neural networks have millions of parameters (weights). Partial derivatives tell us how the error changes with respect to EACH individual weight, one at a time.',
      ),
      ConceptLesson(
        title: 'The Gradient',
        definition: 'A gradient is a vector containing all the partial derivatives of a function — it points in the direction of the steepest INCREASE of that function.',
        analogy: 'If you\'re standing on a hill in fog and want to find the steepest path upward, the gradient is the arrow pointing in exactly that direction. To go DOWN fastest (reduce error), you walk in the OPPOSITE direction of the gradient.',
        example: 'For f(x, y) = x² + y², the gradient is [2x, 2y]. At point (3, 4), the gradient is [6, 8] — pointing toward the direction of steepest increase from that point.',
        keyTakeaway: 'This is the absolute core of how neural networks learn: compute the gradient of the error with respect to all weights, then move weights in the OPPOSITE direction of the gradient to reduce error. This is called "gradient descent".',
        codeSnippet: 'import numpy as np\n\ndef f(x, y):\n    return x**2 + y**2\n\ndef gradient(x, y, h=1e-5):\n    df_dx = (f(x + h, y) - f(x - h, y)) / (2 * h)\n    df_dy = (f(x, y + h) - f(x, y - h)) / (2 * h)\n    return np.array([df_dx, df_dy])\n\nprint(gradient(3, 4))  # ~[6.0, 8.0]',
      ),
      ConceptLesson(
        title: 'The Chain Rule & Backpropagation',
        definition: 'The chain rule lets you compute the derivative of a composite function (a function made of nested functions) by multiplying the derivatives of each step together.',
        analogy: 'Imagine a chain of gears connected to each other. Turning the first gear ultimately moves the last gear, but the effect passes through every gear in between, each one scaling the rotation. The chain rule tracks exactly how much the final movement is affected by the first gear\'s turn.',
        example: 'If y = f(g(x)), then dy/dx = dy/dg * dg/dx. In a 5-layer neural network, this rule is applied 5 times in sequence to compute how the final error relates back to the very first layer\'s weights.',
        keyTakeaway: 'Backpropagation — the algorithm that trains every neural network — is simply the chain rule applied repeatedly, layer by layer, from the output back to the input. This is THE single most important algorithm in deep learning.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does the derivative of a function tell you?',
        options: [
          'The maximum value of the function',
          'The instantaneous rate of change (slope) at a specific point',
          'The total area under the curve',
          'How many inputs the function has'
        ],
        correctIndex: 1,
        explanation: 'The derivative gives the exact slope/rate of change at a single point — how fast the output changes as the input changes, at that exact location.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What direction does the gradient point in?',
        options: [
          'The direction of steepest decrease',
          'A random direction',
          'The direction of steepest increase of the function',
          'Always toward zero'
        ],
        correctIndex: 2,
        explanation: 'The gradient vector always points toward the direction of steepest INCREASE. This is why gradient descent moves in the OPPOSITE direction — to decrease error as fast as possible.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What mathematical rule does backpropagation rely on?',
        options: ['The Pythagorean theorem', 'The chain rule', 'Bayes\' Theorem', 'The law of large numbers'],
        correctIndex: 1,
        explanation: 'Backpropagation applies the chain rule repeatedly, layer by layer, to compute how the final error depends on every weight throughout the entire network.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A neural network\'s loss function gradient with respect to a specific weight is calculated as 0. What does this most likely mean?',
        options: [
          'The model has crashed',
          'That weight is at a local minimum or flat region — small changes to it don\'t currently affect the loss',
          'The weight must be deleted',
          'The model achieved 100% accuracy'
        ],
        correctIndex: 1,
        explanation: 'A gradient of 0 means the function is flat at that point with respect to that weight — it could be a minimum (good), maximum (bad), or saddle point. It does NOT automatically mean the model is perfect.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Gradient Calculator for a 2-Variable Function',
      goal: 'Build a numerical gradient calculator and use it to find the direction of steepest descent.',
      steps: [
        'Define f(x, y) = (x - 3)**2 + (y - 5)**2 in Python (minimum is at x=3, y=5)',
        'Write a numerical gradient(f, x, y, h=1e-5) function using the central difference method',
        'Compute the gradient at the starting point (x=0, y=0)',
        'Print the gradient vector and explain (in a comment) which direction to move x and y to reduce f',
        'Take ONE small step in the negative gradient direction and print the new (x, y) and new f value, showing it decreased',
      ],
      expectedOutput: 'Gradient at (0,0): [-6.0, -10.0]\nMove in opposite direction to decrease f\nNew point after one step: (0.06, 0.10)\nf decreased from 34.0 to 32.5',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 12. GRADIENT DESCENT
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'gradient_descent',
    topicTitle: 'Gradient Descent',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Hard',
    estimatedMinutes: 30,
    totalXp: 160,
    emoji: '⛰️',
    intro: 'Gradient Descent is THE algorithm that trains nearly every machine learning model in existence — from simple linear regression to massive language models like GPT. Understanding it deeply is a defining skill of every real AI engineer.',
    concepts: [
      ConceptLesson(
        title: 'What is Gradient Descent?',
        definition: 'Gradient Descent is an iterative optimisation algorithm that repeatedly adjusts a model\'s parameters in the direction that reduces error, using the gradient of the loss function.',
        analogy: 'Imagine you\'re standing on a foggy mountain and need to reach the lowest valley. You can\'t see the whole landscape, but you can feel which direction is downhill right where you stand. You take a step downhill, check again, and repeat — eventually reaching the bottom.',
        example: 'A linear regression model starts with random weights (high error). Gradient descent repeatedly computes the gradient of the error and nudges the weights in the opposite direction, reducing error step by step.',
        keyTakeaway: 'Gradient Descent doesn\'t solve for the perfect answer in one shot — it iteratively improves, step by step, getting closer to the minimum error with each update.',
      ),
      ConceptLesson(
        title: 'The Learning Rate',
        definition: 'The learning rate controls how big a step gradient descent takes in each iteration. It is one of the most important hyperparameters in all of machine learning.',
        analogy: 'Walking downhill in fog: too small a step size (low learning rate) means you take forever to reach the bottom. Too big a step (high learning rate) means you might overshoot the valley entirely and end up further away, or bounce around chaotically.',
        example: 'learning_rate = 0.001 → slow but steady convergence\nlearning_rate = 1.5 → may overshoot and diverge, error increases instead of decreasing\nlearning_rate = 0.01 → often a reasonable starting point',
        keyTakeaway: 'Choosing the right learning rate is critical. Too low wastes time and compute; too high causes the model to never converge. Most AI engineers experiment with several learning rates or use adaptive methods.',
        codeSnippet: 'def gradient_descent_step(weight, gradient, learning_rate=0.01):\n    return weight - learning_rate * gradient\n\nweight = 10.0\ngrad = 4.0  # example gradient\nnew_weight = gradient_descent_step(weight, grad)\nprint(new_weight)  # 9.96',
      ),
      ConceptLesson(
        title: 'Batch, Stochastic & Mini-Batch Gradient Descent',
        definition: 'Batch GD uses the entire dataset for each update. Stochastic GD (SGD) uses just ONE random sample per update. Mini-batch GD uses small groups of samples — a practical middle ground.',
        analogy: 'Batch GD is like polling your ENTIRE country before making one decision — accurate, but extremely slow. SGD is like asking just ONE random person — fast, but noisy and unreliable. Mini-batch is like polling a representative sample of 100 people — fast AND fairly accurate. Most real AI training uses mini-batches.',
        example: 'Training a model on 1 million images:\nBatch GD: 1 update per epoch, using all 1M images each time — very slow.\nSGD: 1 million updates per epoch, one image at a time — very noisy.\nMini-batch (size 32): ~31,250 updates per epoch, balancing speed and stability.',
        keyTakeaway: 'Mini-batch gradient descent is the industry standard for training deep learning models. It balances computational efficiency (fits in GPU memory) with stable, reliable convergence.',
      ),
      ConceptLesson(
        title: 'Convergence & Local Minima',
        definition: 'Convergence means gradient descent has reached a point where further updates produce little to no improvement — ideally the global minimum, but sometimes a local minimum (a "good enough" but not optimal point).',
        analogy: 'If your foggy mountain has multiple small valleys, you might walk downhill and get trapped in a shallow ditch (local minimum) without realising there\'s a much deeper valley (global minimum) elsewhere that you can\'t see in the fog.',
        example: 'Modern deep learning uses techniques like momentum, adaptive learning rates (Adam optimizer), and random weight initialisation to help escape shallow local minima and reach better solutions.',
        keyTakeaway: 'Perfect convergence to the absolute global minimum is rarely guaranteed in deep learning — but in practice, modern optimisers find "good enough" minima that produce highly effective models.',
        codeSnippet: '# Simple gradient descent loop\nweight = 10.0\nlearning_rate = 0.1\nfor step in range(20):\n    gradient = 2 * (weight - 3)  # derivative of (w-3)^2\n    weight = weight - learning_rate * gradient\nprint(weight)  # converges close to 3.0',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does Gradient Descent do at each step?',
        options: [
          'Randomly changes all weights',
          'Adjusts parameters in the direction that reduces the error, based on the gradient',
          'Deletes the worst-performing weight',
          'Increases the learning rate automatically'
        ],
        correctIndex: 1,
        explanation: 'Gradient Descent moves parameters in the OPPOSITE direction of the gradient (which points toward increasing error), reducing the loss step by step.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What happens if the learning rate is set too high?',
        options: [
          'Training becomes perfectly accurate',
          'The model may overshoot the minimum and fail to converge, even diverging',
          'Nothing changes',
          'The model trains instantly with zero error'
        ],
        correctIndex: 1,
        explanation: 'A learning rate that\'s too high causes updates to overshoot the minimum repeatedly, sometimes causing the loss to increase instead of decrease — a classic training failure mode.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why does mini-batch gradient descent dominate in modern deep learning?',
        options: [
          'It uses less code',
          'It balances computational efficiency with stable, reliable convergence',
          'It guarantees the global minimum every time',
          'It does not require a learning rate'
        ],
        correctIndex: 1,
        explanation: 'Mini-batch gradient descent fits efficiently in GPU memory, processes data faster than full-batch, and produces more stable updates than pure stochastic (single-sample) gradient descent.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'During training, you notice the loss value is oscillating wildly and sometimes increasing instead of decreasing. What is the MOST likely cause?',
        options: [
          'The dataset is too large',
          'The learning rate is too high, causing the model to overshoot the minimum repeatedly',
          'The model has too few parameters',
          'The gradient is always zero'
        ],
        correctIndex: 1,
        explanation: 'Wild oscillation or increasing loss is the classic symptom of too high a learning rate. The fix is typically to reduce the learning rate or use an adaptive optimizer like Adam.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Gradient Descent Visualizer & Optimizer',
      goal: 'Implement gradient descent from scratch in Python/NumPy to find the minimum of a function, and visualise convergence.',
      steps: [
        'Define f(w) = (w - 4)**2 + 2 and its derivative f_prime(w) = 2*(w - 4)',
        'Initialise weight = 0.0 and learning_rate = 0.1',
        'Run a loop for 30 iterations, updating weight using gradient descent and storing the loss at each step',
        'Print the weight and loss every 5 iterations to show convergence toward w=4',
        'Use matplotlib to plot the loss curve over iterations, showing it decreasing toward the minimum',
      ],
      expectedOutput: 'Step 0: w=0.80, loss=12.24\nStep 5: w=2.62, loss=3.91\nStep 10: w=3.51, loss=2.24\nStep 25: w=3.95, loss=2.00\nFinal weight ≈ 4.00, minimum loss ≈ 2.00',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 13. OPTIMIZATION CONCEPTS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'optimization_concepts',
    topicTitle: 'Optimization Concepts',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Hard',
    estimatedMinutes: 25,
    totalXp: 140,
    emoji: '🎯',
    intro: 'Gradient descent is just the starting point. Modern AI training relies on more advanced optimisation techniques that make training faster, more stable, and capable of handling massive, complex models like deep neural networks.',
    concepts: [
      ConceptLesson(
        title: 'Loss Functions — Defining What "Good" Means',
        definition: 'A loss function (or cost function) is a mathematical formula that measures how wrong a model\'s predictions are compared to the true values. Optimisation is the process of minimising this loss.',
        analogy: 'A loss function is like a golf score — lower is better. Every shot (prediction) gets scored against the goal (true answer), and your objective throughout the game (training) is to minimise your total score.',
        example: 'Mean Squared Error (MSE) for regression: average of (predicted - actual)². Cross-Entropy Loss for classification: penalises confident wrong predictions heavily.',
        keyTakeaway: 'Choosing the right loss function for your problem type (regression vs classification) is one of the most important decisions in building an AI model — it defines exactly what "improvement" means.',
        codeSnippet: 'import numpy as np\n\ndef mse_loss(y_true, y_pred):\n    return np.mean((y_true - y_pred) ** 2)\n\ny_true = np.array([3, 5, 2.5, 7])\ny_pred = np.array([2.8, 5.1, 2.0, 6.5])\nprint(mse_loss(y_true, y_pred))',
      ),
      ConceptLesson(
        title: 'Momentum — Smoothing the Path Downhill',
        definition: 'Momentum is an optimisation technique that accumulates a moving average of past gradients, helping the optimiser move faster through flat regions and smooth out noisy updates.',
        analogy: 'Imagine rolling a heavy ball downhill instead of taking individual careful steps. The ball builds momentum, rolling through small bumps and flat patches that would otherwise stop a cautious walker.',
        example: 'Without momentum: gradient descent can get stuck oscillating in narrow valleys.\nWith momentum: the optimiser "remembers" its recent direction and pushes through, converging faster.',
        keyTakeaway: 'Momentum-based optimisers converge faster and are less likely to get stuck in shallow local minima or saddle points compared to plain gradient descent.',
      ),
      ConceptLesson(
        title: 'Adam Optimizer — The Industry Standard',
        definition: 'Adam (Adaptive Moment Estimation) combines momentum with adaptive learning rates for each parameter individually, making it one of the most widely used optimisers in deep learning today.',
        analogy: 'Adam is like a smart hiking guide who not only remembers your recent direction (momentum) but also adjusts your stride length individually for each leg muscle (parameter) based on how much each one has been working.',
        example: 'Adam automatically adapts the effective learning rate per parameter, requiring much less manual tuning than plain SGD, which is why frameworks like PyTorch and TensorFlow use it as a default choice.',
        keyTakeaway: 'Adam is the most commonly used optimiser for training deep neural networks because it converges quickly and works well across a huge range of problems with minimal tuning.',
        codeSnippet: '# Using Adam in PyTorch (conceptual example)\n# optimizer = torch.optim.Adam(model.parameters(), lr=0.001)\n# optimizer.zero_grad()\n# loss.backward()\n# optimizer.step()',
      ),
      ConceptLesson(
        title: 'Overfitting, Underfitting & Regularization',
        definition: 'Overfitting is when a model memorises training data but fails to generalise. Underfitting is when a model is too simple to capture patterns at all. Regularization adds constraints during optimisation to prevent overfitting.',
        analogy: 'Overfitting is like a student who memorises exact textbook answers but fails any question phrased differently. Underfitting is like a student who barely studied at all. Regularization is like a teacher who penalises overly complicated, convoluted answers, encouraging simpler, more generalisable understanding.',
        example: 'L2 Regularization adds a penalty term to the loss function based on the size of the weights, discouraging the model from relying too heavily on any single feature.',
        keyTakeaway: 'A well-optimised model finds a balance — simple enough to generalise to new data, but complex enough to capture real patterns. Optimisation is not just about minimising loss on training data, but on UNSEEN data too.',
        codeSnippet: '# L2 Regularization added to a loss function\ndef regularized_loss(y_true, y_pred, weights, lambda_=0.01):\n    mse = np.mean((y_true - y_pred) ** 2)\n    l2_penalty = lambda_ * np.sum(weights ** 2)\n    return mse + l2_penalty',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the purpose of a loss function?',
        options: [
          'To store training data',
          'To measure how wrong a model\'s predictions are, guiding optimisation',
          'To visualise neural network architecture',
          'To clean missing data'
        ],
        correctIndex: 1,
        explanation: 'The loss function quantifies prediction error. Optimisation algorithms like gradient descent work by minimising this loss value during training.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What advantage does Momentum provide over plain gradient descent?',
        options: [
          'It eliminates the need for a loss function',
          'It helps the optimiser move through flat regions and smooth out noisy updates, converging faster',
          'It guarantees the global minimum every time',
          'It removes the need for training data'
        ],
        correctIndex: 1,
        explanation: 'Momentum accumulates past gradients, allowing the optimiser to maintain direction through flat or noisy regions instead of getting stuck or oscillating, leading to faster convergence.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A model achieves 99% accuracy on training data but only 60% on new test data. What is this called?',
        options: ['Underfitting', 'Overfitting', 'Regularization', 'Convergence'],
        correctIndex: 1,
        explanation: 'This is a classic sign of overfitting — the model memorised the training data\'s noise and specifics rather than learning generalisable patterns, so it performs poorly on unseen data.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You\'re training a deep learning model and notice training loss keeps decreasing, but validation loss starts increasing after epoch 10. What should you do?',
        options: [
          'Keep training for many more epochs since training loss is still improving',
          'Recognise this as overfitting and consider regularization, early stopping, or more data',
          'Increase the model size to fix the problem',
          'Remove the validation set entirely'
        ],
        correctIndex: 1,
        explanation: 'Decreasing training loss with increasing validation loss is the textbook signature of overfitting. Early stopping (halting training at epoch 10) or adding regularization are standard fixes.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Optimizer Comparison Lab',
      goal: 'Compare plain gradient descent vs gradient descent with momentum on the same optimisation problem.',
      steps: [
        'Define a loss function f(w) = (w - 5)**2 with derivative f_prime(w) = 2*(w - 5)',
        'Implement plain gradient descent for 30 steps, tracking weight and loss history',
        'Implement gradient descent WITH momentum (velocity = 0.9*velocity - lr*gradient; weight += velocity) for 30 steps',
        'Print the final weight and number of steps each method took to get within 0.01 of the true minimum (w=5)',
        'Print a brief conclusion on which converged faster and why',
      ],
      expectedOutput: 'Plain GD: reached w≈4.99 in 25 steps\nMomentum GD: reached w≈4.99 in 14 steps\nConclusion: Momentum converged roughly 1.8x faster by building speed in a consistent direction.',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 14. MATHEMATICAL THINKING FOR MACHINE LEARNING
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'mathematical_thinking_for_ml',
    topicTitle: 'Mathematical Thinking for Machine Learning',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 25,
    totalXp: 140,
    emoji: '🧠',
    intro: 'Knowing formulas is not the same as thinking mathematically. This lesson ties together everything you\'ve learned — linear algebra, probability, statistics, and calculus — into the unified mindset real AI engineers use to design, debug, and reason about models.',
    concepts: [
      ConceptLesson(
        title: 'Seeing AI Models as Mathematical Functions',
        definition: 'Every AI model, no matter how complex, is fundamentally a mathematical function: it takes inputs (numbers) and produces outputs (numbers) through a series of learned transformations.',
        analogy: 'A massive language model like GPT might seem magical, but at its core, it\'s the same idea as f(x) = mx + c, just with billions of parameters instead of two, stacked across hundreds of layers.',
        example: 'A house price predictor: price = w1*size + w2*rooms + w3*age + bias. A deep neural network is the same idea, just with many stacked, non-linear versions of this equation.',
        keyTakeaway: 'Demystify AI by remembering: it is functions, matrices, probabilities, and derivatives — all working together. There is no magic, only mathematics applied at scale.',
      ),
      ConceptLesson(
        title: 'Connecting the Dots: How the Math Pieces Fit Together',
        definition: 'Linear algebra represents the data and model structure. Probability and statistics quantify uncertainty and evaluate performance. Calculus (via gradients) tells the model how to improve.',
        analogy: 'Think of building a house: linear algebra is the structural frame, statistics is the quality inspection, and calculus is the construction crew that keeps making adjustments until the house is sound.',
        example: 'Training a classifier: 1) Data is represented as matrices (linear algebra). 2) The model outputs probabilities (probability theory). 3) A loss function measures error using statistics. 4) Gradient descent (calculus) updates weights to reduce that error.',
        keyTakeaway: 'Real AI engineering is rarely about ONE math topic — it\'s about understanding how linear algebra, probability, statistics, and calculus work TOGETHER as one connected system.',
      ),
      ConceptLesson(
        title: 'Mathematical Intuition Over Memorisation',
        definition: 'Mathematical thinking for ML means understanding WHY a formula works and what it represents conceptually, rather than just memorising it to plug in numbers.',
        analogy: 'A cook who only follows a recipe exactly can make ONE dish. A cook who understands WHY ingredients work together can invent new dishes and fix mistakes. AI engineers need the second kind of understanding.',
        example: 'Instead of memorising "MSE = average of squared errors", understand WHY we square errors (to penalise large mistakes more and avoid negative/positive cancellation) — this intuition helps you choose better loss functions for new problems.',
        keyTakeaway: 'The best AI engineers can read an unfamiliar formula in a research paper and reason about what it likely does, because they understand the underlying mathematical PATTERNS, not just memorised equations.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Fundamentally, what is an AI model from a mathematical perspective?',
        options: [
          'A type of database',
          'A mathematical function that transforms inputs into outputs through learned parameters',
          'A random number generator',
          'A type of compiler'
        ],
        correctIndex: 1,
        explanation: 'No matter how complex, an AI model is a (potentially huge) mathematical function — learned weights transform input numbers into output numbers through structured operations.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which combination correctly describes how the math areas work together in training a model?',
        options: [
          'Only calculus matters; the rest are irrelevant',
          'Linear algebra represents data/structure, probability/statistics evaluate and quantify uncertainty, calculus drives learning via gradients',
          'Probability is only used for image generation',
          'Statistics replaces the need for linear algebra entirely'
        ],
        correctIndex: 1,
        explanation: 'These math fields work together as a system: linear algebra structures the data, probability and statistics measure performance and uncertainty, and calculus (via gradients) drives the actual learning process.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You read a new research paper with an unfamiliar formula. What mindset helps an AI engineer the MOST?',
        options: [
          'Memorise the formula exactly without understanding it',
          'Try to understand what each term conceptually represents and why the formula makes mathematical sense',
          'Skip all math and just copy the code from GitHub',
          'Assume it is too advanced and stop reading'
        ],
        correctIndex: 1,
        explanation: 'Mathematical intuition — understanding what each part of a formula represents and why — lets engineers adapt, debug, and apply new techniques even without memorising every equation in advance.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Math-to-AI Concept Map',
      goal: 'Build a small Python program that demonstrates how all 4 math areas combine in a single mini training loop.',
      steps: [
        'Create a simple dataset (linear algebra): X (features) and y (true values) as NumPy arrays',
        'Initialise random weights and compute predictions using matrix multiplication',
        'Compute a probability-like confidence score using a sigmoid function on the output',
        'Compute the Mean Squared Error loss (statistics) between predictions and true values',
        'Compute the gradient (calculus) and update the weights by one gradient descent step',
        'Print a summary showing how each of the 4 math areas was used in this single loop iteration',
      ],
      expectedOutput: 'Predictions (linear algebra): [...]\nConfidence scores (probability): [...]\nLoss (statistics): 4.21\nGradient (calculus): [...]\nWeights updated successfully using all 4 math domains in one loop!',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // 15. AI MATHEMATICS MINI PROJECT
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'ai_mathematics_mini_project',
    topicTitle: 'AI Mathematics Mini Project',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Hard',
    estimatedMinutes: 40,
    totalXp: 200,
    emoji: '🧰',
    intro: 'Time to bring everything together. In this capstone lesson, you\'ll build a complete AI Mathematics Toolkit — a single Python project using NumPy that demonstrates matrix operations, probability simulations, statistical analysis, and gradient descent visualisation, exactly the skills real AI engineers use daily.',
    concepts: [
      ConceptLesson(
        title: 'Designing a Toolkit, Not Just a Script',
        definition: 'A toolkit is a reusable, organised set of functions designed to be called repeatedly for different inputs — unlike a one-off script that solves a single problem.',
        analogy: 'A one-off script is like a disposable calculator built for one math problem. A toolkit is like a Swiss Army knife — multiple reusable tools, each doing one job well, ready whenever you need them.',
        example: 'Instead of writing matrix multiplication code every time you need it, you build a reusable matrix_multiply(A, B) function once, then call it throughout your entire project (and future projects).',
        keyTakeaway: 'Professional AI engineers build reusable, well-organised code. This mindset — turning one-off calculations into clean, reusable functions — is a core software engineering skill that elevates your AI math from "homework" to "production-ready".',
      ),
      ConceptLesson(
        title: 'Combining Matrix Operations, Probability & Statistics in One Project',
        definition: 'Real AI projects rarely use just ONE math concept in isolation — they combine matrix operations, probability simulations, and statistical analysis together to solve a single end-to-end problem.',
        analogy: 'Building a car requires combining mechanical engineering, electronics, and design together — not just one discipline in isolation. An AI toolkit similarly combines multiple math disciplines to be genuinely useful.',
        example: 'A toolkit function might: take a dataset (matrix), simulate random sampling (probability), compute summary statistics (statistics), and visualise a gradient descent path (calculus) — all working together.',
        keyTakeaway: 'Building integrated projects (not isolated exercises) is what prepares you for real AI engineering work, where problems always require combining multiple mathematical tools together.',
      ),
      ConceptLesson(
        title: 'Visualizing Gradient Descent',
        definition: 'Visualising gradient descent means plotting the loss value (or the parameter path) over training iterations, to see the optimisation process happening in real time.',
        analogy: 'Visualising gradient descent is like watching a GPS track of a hiker descending a mountain — you can literally see the path getting closer to the valley floor (minimum) step by step.',
        example: 'A loss-vs-iteration plot that starts high and curves down to a flat minimum is the single most common chart in all of machine learning — it tells you immediately whether training is working.',
        keyTakeaway: 'Visualisation turns abstract numbers into intuitive understanding. Every AI engineer should be comfortable plotting loss curves to diagnose whether a model is learning correctly.',
        codeSnippet: 'import matplotlib.pyplot as plt\n\ndef plot_loss_curve(loss_history):\n    plt.plot(loss_history)\n    plt.xlabel("Iteration")\n    plt.ylabel("Loss")\n    plt.title("Gradient Descent Convergence")\n    plt.show()',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main advantage of building a "toolkit" instead of separate one-off scripts?',
        options: [
          'Toolkits run faster automatically',
          'Toolkits are reusable, organised collections of functions that can be called repeatedly across projects',
          'Toolkits do not require any testing',
          'Toolkits only work with NumPy'
        ],
        correctIndex: 1,
        explanation: 'A toolkit organises reusable functions so you don\'t rewrite the same logic repeatedly — a core principle of professional, maintainable software and AI engineering.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is visualising the loss curve during gradient descent useful?',
        options: [
          'It makes the code run faster',
          'It lets you immediately see whether training is converging or has issues like oscillation or stalling',
          'It is purely decorative and has no practical use',
          'It replaces the need for a loss function'
        ],
        correctIndex: 1,
        explanation: 'A loss curve visually shows whether a model is learning (decreasing loss), stuck (flat loss), or unstable (oscillating/increasing loss) — making it an essential diagnostic tool.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You are designing your AI Mathematics Toolkit. Which structure best reflects professional AI engineering practice?',
        options: [
          'One giant script with all logic mixed together and no functions',
          'Separate, well-named, reusable functions for each capability (matrix ops, probability, statistics, gradient descent), combined in a clean main program',
          'Copy-pasting the same matrix multiplication code every time it is needed',
          'Avoiding comments and explanations entirely to keep the code short'
        ],
        correctIndex: 1,
        explanation: 'Professional code organises functionality into clear, reusable, well-named functions. This makes the toolkit maintainable, testable, and genuinely reusable across future projects — exactly how real AI engineering teams work.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'AI Mathematics Toolkit',
      goal: 'Build a complete AI Mathematics Toolkit using Python and NumPy that demonstrates matrix operations, probability simulations, statistical analysis, and gradient descent visualisation in one unified, well-organised project.',
      steps: [
        'MATRIX MODULE: write functions for matrix addition, multiplication, and transpose, and demonstrate each on sample matrices',
        'PROBABILITY MODULE: write a function that simulates 10,000 dice rolls and returns the empirical probability distribution of each outcome',
        'STATISTICS MODULE: write a function that takes any NumPy array and returns mean, median, variance, and standard deviation',
        'GRADIENT DESCENT MODULE: implement gradient descent on f(w) = (w-7)**2 and return the full loss history across 50 iterations',
        'VISUALIZATION: use matplotlib to plot (a) a bar chart of the dice probability distribution and (b) the gradient descent loss curve',
        'MAIN PROGRAM: tie all 4 modules together in a single main() function that runs each demonstration in sequence and prints a clean summary report',
      ],
      expectedOutput: '=== AI MATHEMATICS TOOLKIT ===\n\n[Matrix Module] A+B, A*B, and Transpose computed successfully.\n[Probability Module] Dice simulation (10,000 rolls): {1: 0.166, 2: 0.168, 3: 0.165, 4: 0.167, 5: 0.167, 6: 0.167}\n[Statistics Module] Mean=50.2, Median=50.0, Variance=84.1, StdDev=9.17\n[Gradient Descent Module] Converged to w≈7.00 after 50 iterations, final loss≈0.00\n\nAll modules executed successfully. Toolkit ready for use.',
      xpReward: 80,
    ),
  ),
];