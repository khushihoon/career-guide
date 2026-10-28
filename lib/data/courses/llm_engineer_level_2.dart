import '../../models/course_content_data.dart';

const List<TopicCourse> llmEngineerLevel2 = [
  TopicCourse(
    id: 'why_math_matters_l2',
    topicTitle: 'Why Math Matters for LLM Engineering',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '📐',
    intro:
        'Welcome to Level 2. Every transformer you will fine-tune, every embedding you will search, every training loop you will debug rests on a small set of math ideas — vectors, matrices, derivatives, and probability. This lesson shows you exactly why, before the details arrive.',
    concepts: [
      ConceptLesson(
        title: 'Math is the Engine Room, Not the Ship\'s Deck',
        definition:
            'You will rarely do math by hand in real LLM engineering — libraries like PyTorch and NumPy handle the calculations. But you need enough mathematical intuition to understand WHY a model trains the way it does, WHY it fails, and HOW to fix it when it does.',
        analogy:
            'Math for an LLM Engineer is like knowing how an engine works for a race car driver. You are not manufacturing pistons by hand during a race, but when the car behaves strangely, understanding combustion and torque is exactly what lets you diagnose the problem instead of guessing blindly.',
        example:
            'When a model\'s training loss stops decreasing (Level 4 and 7), understanding gradients and learning rates (this level) is what lets you diagnose whether the issue is a learning rate that is too high, a vanishing gradient, or something else entirely — rather than randomly changing settings and hoping.',
        keyTakeaway:
            'This level is not about becoming a mathematician — it is about building just enough intuition in linear algebra, calculus, and probability that every later level (Deep Learning, Transformers, Fine-Tuning) makes sense at a mechanical level, not just a magical one.',
      ),
      ConceptLesson(
        title: 'The Four Math Pillars of This Level',
        definition:
            'This level covers exactly four connected pillars: Linear Algebra (vectors and matrices — how data and model weights are represented), Calculus (derivatives and gradients — how models learn), Probability & Statistics (how models express uncertainty and how data is distributed), and Information Theory (how we measure a model\'s "surprise", directly used in LLM loss functions).',
        analogy:
            'These four pillars are like the four legs of a table supporting every deep learning concept you will meet later. Remove linear algebra, and you cannot represent data. Remove calculus, and models cannot learn. Remove probability, and you cannot understand model outputs or evaluate uncertainty. All four together create a stable foundation.',
        example:
            'Every single transformer forward pass (Level 6) is matrix multiplication (linear algebra). Every training step (Level 4, 7) uses gradients (calculus). Every next-token prediction (Level 1, 6) is a probability distribution over the vocabulary (probability). Every LLM loss function (Level 7) is built from cross-entropy (information theory).',
        keyTakeaway:
            'Keep this four-pillar map in mind as you go through this level — each lesson slots into one of these pillars, and by the end you will see clearly how they connect directly to the deep learning and transformer concepts waiting in Levels 4 and 6.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why does an LLM Engineer need mathematical intuition if libraries like PyTorch handle the actual calculations?',
        options: [
          'They do not — math is completely irrelevant to real LLM engineering work',
          'Mathematical intuition lets you understand WHY a model trains or fails a certain way and HOW to diagnose and fix problems, rather than randomly guessing when something goes wrong',
          'PyTorch requires you to manually compute every gradient by hand',
          'Math is only needed for writing academic research papers, not building products'
        ],
        correctIndex: 1,
        explanation:
            'While libraries handle the computation, genuine mathematical intuition is what lets an engineer diagnose training problems, understand model behavior, and make informed decisions — rather than treating the model as an unexplainable black box.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which of the four math pillars covered in this level is most directly responsible for HOW a neural network learns from its mistakes during training?',
        options: [
          'Linear Algebra',
          'Calculus (derivatives and gradients)',
          'Information Theory',
          'None of these relate to learning'
        ],
        correctIndex: 1,
        explanation:
            'Calculus — specifically gradients — is the mechanism by which neural networks (and LLMs) adjust their internal weights to reduce error during training, which is exactly what "learning" means in this context.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A beginner says "I will just skip the math level and learn PyTorch commands directly." What is the risk of this approach?',
        options: [
          'There is no risk at all — this is the recommended approach',
          'They will be able to copy-paste PyTorch code, but when training fails or produces unexpected results (which happens constantly in real work), they will have no foundation to diagnose or fix the problem',
          'PyTorch does not actually require any understanding of the underlying model',
          'Skipping math makes learning PyTorch commands significantly faster with no downside'
        ],
        correctIndex: 1,
        explanation:
            'Without the underlying math intuition, PyTorch code becomes an unexplainable black box — functional when everything goes right, but impossible to debug or improve when something inevitably goes wrong.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'My Math Foundation Map',
      goal:
          'Build a personal reference map connecting each of the four math pillars in this level to the specific later-roadmap concepts they will support.',
      steps: [
        'List the 4 math pillars covered in this level: Linear Algebra, Calculus, Probability & Statistics, Information Theory',
        'For each pillar, write one sentence explaining what it is used for in plain language',
        'For each pillar, name one specific concept from Level 4, 6, or 7 (Deep Learning, Transformers, LLMs) that directly depends on it',
        'Honestly rate your current comfort level (1-5) with each of the 4 pillars before starting this level',
        'Write 2-3 sentences on which pillar you expect to find most challenging and why',
      ],
      expectedOutput:
          'A complete 4-pillar map connecting each math area to a later roadmap concept, an honest self-rating for each area, and a reflection identifying the expected challenge area — setting a clear baseline before diving into Level 2\'s lessons.',
      xpReward: 45,
    ),
  ),
  TopicCourse(
    id: 'vectors_vector_spaces_l2',
    topicTitle: 'Vectors and Vector Spaces',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '➡️',
    intro:
        'Every word, every sentence, every document an LLM ever processes is first converted into a vector — a list of numbers. This lesson builds your intuition for what a vector actually is and why this representation is the foundation of every embedding you will use starting in Level 6.',
    concepts: [
      ConceptLesson(
        title: 'What is a Vector?',
        definition:
            'A vector is an ordered list of numbers representing a point or direction in space — in machine learning, vectors are used to numerically represent almost everything: a data point, a word, a sentence, or a model\'s internal state.',
        analogy:
            'A vector is like a GPS coordinate. A single number ("37") tells you almost nothing useful on its own. But a vector like (37.7749, -122.4194) tells you an exact location — San Francisco. Similarly, a single number cannot capture the "meaning" of a word, but a vector of hundreds of numbers can.',
        example:
            'In 2D, the vector [3, 4] represents a point 3 units right and 4 units up from the origin. In machine learning, a word like "king" might be represented as a vector of 300 numbers — far more dimensions than we can visualize, but the same underlying idea.',
        keyTakeaway:
            'Vectors are how machines represent meaning numerically. When you reach Level 6\'s embeddings and Level 8\'s vector search, you will be working directly with vectors that are hundreds or thousands of dimensions long — but the core intuition starts here with simple 2D and 3D examples.',
        codeSnippet:
            'import numpy as np\n\nword_vector = np.array([0.2, -0.5, 0.8, 0.1])\nprint(word_vector)\nprint(word_vector.shape)   # (4,) - a 4-dimensional vector',
      ),
      ConceptLesson(
        title: 'Vector Operations: Addition, Scaling, and Dot Product',
        definition:
            'Vectors support specific mathematical operations: addition (combining two vectors), scalar multiplication (stretching/shrinking a vector), and the dot product (a single number measuring how much two vectors "align" with each other) — the dot product specifically is the core operation inside every transformer\'s attention mechanism.',
        analogy:
            'The dot product is like measuring how much two arrows point in the same direction. Two arrows pointing the exact same way have a high dot product (strong alignment). Two arrows pointing in completely different directions have a low or negative dot product. This "alignment score" is exactly how a transformer measures how relevant one word is to another.',
        example:
            'a = [1, 2, 3]\nb = [4, 5, 6]\ndot_product = (1*4) + (2*5) + (3*6) = 4 + 10 + 18 = 32\n\nThis single number (32) summarizes how aligned these two vectors are — a foundational calculation you will meet again inside self-attention in Level 6.',
        keyTakeaway:
            'The dot product is not just an abstract math operation — it is literally the mechanism behind semantic search (Level 8) and self-attention (Level 6): "how similar/relevant is vector A to vector B?" is answered, in large part, by computing a dot product.',
        codeSnippet:
            'import numpy as np\n\na = np.array([1, 2, 3])\nb = np.array([4, 5, 6])\n\nprint(a + b)          # [5 7 9] - vector addition\nprint(a * 2)          # [2 4 6] - scalar multiplication\nprint(np.dot(a, b))   # 32 - dot product',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is a vector, in the context of machine learning and LLMs?',
        options: [
          'A single number representing a category',
          'An ordered list of numbers representing a point or direction in space, used to numerically represent data like words, sentences, or documents',
          'A type of Python loop',
          'A visual diagram with no numerical meaning'
        ],
        correctIndex: 1,
        explanation:
            'A vector is an ordered list of numbers — this simple structure is how machine learning models numerically represent complex things like word meaning, which you will see directly in Level 6\'s embeddings.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is the dot product operation especially important for your future work in LLM Engineering?',
        options: [
          'It has no real relevance to LLMs at all',
          'It measures how aligned/similar two vectors are, which is the exact core calculation used inside self-attention (Level 6) and semantic/vector search (Level 8)',
          'It is only used for adding two numbers together',
          'The dot product can only be computed for 2-dimensional vectors'
        ],
        correctIndex: 1,
        explanation:
            'The dot product\'s ability to measure vector alignment/similarity is directly reused as the core mechanism inside self-attention and vector-based semantic search — two of the most important concepts in later levels.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Given vectors a = [2, 0] and b = [0, 3], what does their dot product tell you about their relationship?',
        options: [
          'They point in exactly the same direction',
          'The dot product is 0, meaning these vectors are perpendicular (completely unaligned/unrelated directions)',
          'They are identical vectors',
          'The dot product cannot be computed for these vectors'
        ],
        correctIndex: 1,
        explanation:
            'Dot product = (2*0) + (0*3) = 0. A dot product of 0 indicates the vectors are perpendicular — pointing in completely unrelated directions, the mathematical equivalent of "no alignment at all."',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Vector Operations Playground',
      goal:
          'Practice core vector operations using NumPy, building the exact numerical intuition needed for embeddings and attention in later levels.',
      steps: [
        'Create two 4-dimensional NumPy vectors representing 2 different "documents" (just use arbitrary numbers between -1 and 1)',
        'Compute and print their vector addition',
        'Compute and print one vector scaled by 3 (scalar multiplication)',
        'Compute and print their dot product',
        'Write a function cosine_similarity_intuition(a, b) that returns the dot product divided by the product of both vectors\' magnitudes (use np.linalg.norm() for magnitude) — this is a preview of the real similarity metric used in Level 8\'s vector search',
        'Test your function on 2 similar-looking vectors and 2 very different vectors, and compare the results',
      ],
      expectedOutput:
          'Vector A: [0.2 -0.5 0.8 0.1], Vector B: [0.3 -0.4 0.7 0.2]\nSum: [0.5 -0.9 1.5 0.3]\nScaled A (x3): [0.6 -1.5 2.4 0.3]\nDot product: 0.99\nCosine similarity (similar vectors): 0.97 (high)\nCosine similarity (different vectors): 0.12 (low)',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'matrices_matrix_operations_l2',
    topicTitle: 'Matrices and Matrix Operations',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🔢',
    intro:
        'If a vector is a single row of numbers, a matrix is a whole grid of them — and matrices are how neural networks store their entire learned "knowledge" as weights. This lesson builds matrix fluency before you meet matrix multiplication, the single most repeated operation inside every LLM.',
    concepts: [
      ConceptLesson(
        title: 'What is a Matrix?',
        definition:
            'A matrix is a 2-dimensional grid of numbers, organized into rows and columns — every layer of a neural network, including every layer of a transformer, stores its learned parameters as one or more matrices.',
        analogy:
            'A matrix is like a spreadsheet grid — rows and columns of numbers, each cell holding one value. Just as a spreadsheet can represent an entire table of student grades, a matrix inside a neural network represents an entire table of learned "weights" connecting inputs to outputs.',
        example:
            'A tiny 2x3 matrix (2 rows, 3 columns):\n[[1, 2, 3],\n [4, 5, 6]]\n\nA real transformer layer might have weight matrices with millions of entries — but the underlying structure, rows and columns of numbers, is exactly the same idea at a much larger scale.',
        keyTakeaway:
            'Whenever you hear "the model has billions of parameters" (Level 1\'s LLM lesson), those parameters are literally the numbers stored inside enormous matrices — matrix fluency here directly demystifies what "billions of parameters" actually means.',
        codeSnippet:
            'import numpy as np\n\nmatrix = np.array([[1, 2, 3], [4, 5, 6]])\nprint(matrix)\nprint(matrix.shape)   # (2, 3) - 2 rows, 3 columns',
      ),
      ConceptLesson(
        title: 'Matrix Multiplication: The Core Operation of Deep Learning',
        definition:
            'Matrix multiplication combines two matrices into a new one by taking dot products of rows and columns — this single operation, repeated billions of times, is what actually happens when data flows through a neural network or transformer.',
        analogy:
            'Matrix multiplication is like a factory assembly line where each output item is built by combining specific proportions of multiple input ingredients according to a fixed recipe (the weight matrix). Every layer in a neural network is essentially "here is my recipe (weight matrix), apply it to the input data (input matrix) to produce the output."',
        example:
            'A (2x3) matrix multiplied by a (3x2) matrix produces a (2x2) result — the "inner" dimensions (3 and 3) must match, and they cancel out, leaving the "outer" dimensions (2 and 2) as the result shape. This exact shape-matching rule is what you will check constantly when debugging neural network code in Level 4.',
        keyTakeaway:
            'Every single forward pass through a neural network layer — and every attention calculation inside a transformer (Level 6) — is fundamentally matrix multiplication. Understanding this now means Level 4 and Level 6 will feel like applying a familiar tool, not learning something entirely new.',
        codeSnippet:
            'import numpy as np\n\nA = np.array([[1, 2, 3], [4, 5, 6]])       # shape (2, 3)\nB = np.array([[7, 8], [9, 10], [11, 12]])  # shape (3, 2)\n\nresult = np.matmul(A, B)   # or A @ B\nprint(result)\nprint(result.shape)   # (2, 2)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'When people say an LLM "has billions of parameters," what are these parameters, concretely?',
        options: [
          'Lines of Python code written by engineers',
          'Numbers stored inside the model\'s weight matrices, learned during training',
          'The number of words the model can generate per second',
          'The number of GPUs used to train the model'
        ],
        correctIndex: 1,
        explanation:
            'Model parameters are literally the numeric entries stored inside the model\'s weight matrices — "billions of parameters" means billions of individual numbers organized into these matrices, learned during training.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is matrix multiplication described as "the core operation of deep learning"?',
        options: [
          'It is only used once, at the very start of training',
          'Every forward pass through a neural network layer, and every attention calculation inside a transformer, is fundamentally built from matrix multiplication, repeated at massive scale',
          'Matrix multiplication is only used for image processing tasks, not language models',
          'Neural networks do not actually use matrix multiplication at all'
        ],
        correctIndex: 1,
        explanation:
            'Matrix multiplication is repeated constantly throughout every layer of every neural network and transformer — it is the fundamental computational operation that makes deep learning and LLMs actually work.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You want to multiply matrix A (shape 4x3) by matrix B. Which shape must B have for the multiplication to be valid?',
        options: [
          '4x3',
          '3x anything (3 rows, any number of columns)',
          '4x4 only',
          'Any shape works for matrix multiplication'
        ],
        correctIndex: 1,
        explanation:
            'For A (4x3) to multiply B, B\'s number of ROWS must match A\'s number of COLUMNS (3). B can have any number of columns — e.g., 3x2, 3x5, etc. This "inner dimensions must match" rule is essential for debugging neural network shape errors.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Matrix Multiplication Practice: A Mini Neural Network Layer',
      goal:
          'Simulate the exact matrix multiplication that happens inside a single neural network layer, connecting today\'s math directly to Level 4\'s deep learning content.',
      steps: [
        'Create a NumPy matrix representing 3 input data points, each with 4 features (shape 3x4)',
        'Create a NumPy weight matrix representing a layer that transforms 4 features into 2 output values (shape 4x2)',
        'Multiply the input matrix by the weight matrix using np.matmul() or @ and print the result, confirming the shape is 3x2',
        'Add a "bias" vector of shape (2,) to the result using simple addition, printing the final output',
        'Write 2-3 sentences explaining, in your own words, how this exact operation (input @ weights + bias) is what happens inside a real neural network layer, which you will build for real in Level 4',
      ],
      expectedOutput:
          'Input shape: (3, 4)\nWeights shape: (4, 2)\nOutput shape after matmul: (3, 2)\nFinal output (with bias added):\n[[0.82 1.14]\n [0.35 0.91]\n [1.02 0.44]]\n\nExplanation: This matmul + bias pattern is exactly what a neural network layer computes...',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'matrix_mult_neural_nets_l2',
    topicTitle: 'Matrix Multiplication in Neural Networks',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🕸️',
    intro:
        'Now that you know what matrices and matrix multiplication are, this lesson connects them directly to how a real neural network layer works — the exact mechanism you will implement with PyTorch in Level 4 and see scaled up inside transformers in Level 6.',
    concepts: [
      ConceptLesson(
        title: 'A Neural Network Layer is Matrix Multiplication Plus a Twist',
        definition:
            'A single neural network layer computes: output = activation_function(input @ weights + bias) — matrix multiplication combines the input with learned weights, a bias is added, and a non-linear activation function is applied so the network can learn more than simple straight-line patterns.',
        analogy:
            'A neural network layer is like a voting committee. Each input feature "votes" with a certain weighted influence (the weight matrix) toward each output decision. The bias is like a starting lean before any votes are counted. The activation function is the committee\'s rule for turning the raw vote tally into a final decision — sometimes non-linear, like "only approve if support is above a certain threshold."',
        example:
            'A layer takes 4 input features, computes a weighted combination for 2 outputs (matrix multiplication + bias), then applies an activation function like ReLU (which simply zeroes out any negative values) to introduce the non-linearity that lets the network learn complex, non-straight-line patterns.',
        keyTakeaway:
            'Every single layer in every neural network — no matter how deep or complex — repeats this exact 3-step pattern: matrix multiply, add bias, apply activation. Level 4 will have you build this in real PyTorch code, and you will recognize every part of it from this lesson.',
        codeSnippet:
            'import numpy as np\n\ndef relu(x):\n    return np.maximum(0, x)\n\ninputs = np.array([[1.0, -0.5, 2.0, 0.3]])   # 1 sample, 4 features\nweights = np.random.randn(4, 3)               # 4 inputs -> 3 outputs\nbias = np.zeros(3)\n\noutput = relu(inputs @ weights + bias)\nprint(output)',
      ),
      ConceptLesson(
        title: 'Why Non-Linear Activation Functions Matter',
        definition:
            'Without a non-linear activation function, stacking multiple matrix-multiplication layers would mathematically collapse into just one single matrix multiplication — no matter how many layers you add, the network could only ever learn simple straight-line relationships. Activation functions like ReLU introduce the non-linearity that gives deep networks their real power.',
        analogy:
            'Stacking linear layers without activation functions is like stacking multiple identical rulers end to end — no matter how many rulers you stack, you still only get a straight line. Adding a non-linear "bend" at each stage (the activation function) is what lets the combined shape curve and capture genuinely complex patterns, like a road that turns instead of a perfectly straight highway.',
        example:
            'ReLU(x) = max(0, x) — this extremely simple rule (keep positive values, zero out negative ones) is enough non-linearity to let deep networks learn astonishingly complex patterns, including the patterns that let an LLM understand grammar, context, and meaning.',
        keyTakeaway:
            'This is exactly why Level 4 will emphasize activation functions so heavily — without them, no amount of "depth" (number of layers) would give a neural network any more power than simple linear regression, which you will see explicitly demonstrated in Level 4.',
        codeSnippet:
            'import numpy as np\n\ndef relu(x):\n    return np.maximum(0, x)\n\nvalues = np.array([-2.0, -0.5, 0.0, 1.5, 3.0])\nprint(relu(values))   # [0.  0.  0.  1.5 3. ] - negatives zeroed out',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the standard 3-step pattern computed inside a single neural network layer?',
        options: [
          'Only matrix multiplication, nothing else',
          'Matrix multiply the input by weights, add a bias, then apply a non-linear activation function',
          'Randomly generate output values with no relationship to the input',
          'Sort the input values in ascending order'
        ],
        correctIndex: 1,
        explanation:
            'Every neural network layer follows this exact pattern: output = activation(input @ weights + bias) — matrix multiplication, bias addition, then non-linear activation, repeated for every layer.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is a non-linear activation function (like ReLU) essential in a deep neural network?',
        options: [
          'It is not actually essential and can always be removed with no consequence',
          'Without it, stacking multiple layers mathematically collapses into a single linear transformation — the network could never learn complex, non-straight-line patterns no matter how many layers it has',
          'Activation functions only affect how fast the network trains, not what it can learn',
          'Activation functions are only needed for image data, not text'
        ],
        correctIndex: 1,
        explanation:
            'Without non-linear activation functions, stacking layers provides no additional representational power — the entire network collapses mathematically into one linear transformation, unable to learn complex patterns regardless of depth.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'What does ReLU(-3.5) return?',
        options: [
          '-3.5',
          '0',
          '3.5',
          'An error, since ReLU cannot handle negative numbers'
        ],
        correctIndex: 1,
        explanation:
            'ReLU(x) = max(0, x). Since -3.5 is negative, ReLU returns 0 — this simple "zero out negatives, keep positives" rule is the non-linearity at the heart of most modern neural networks.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build a 2-Layer Neural Network Forward Pass (NumPy Only)',
      goal:
          'Manually implement the forward pass of a tiny 2-layer neural network using only NumPy — directly previewing what you will build with PyTorch in Level 4.',
      steps: [
        'Create an input matrix representing 2 samples with 3 features each (shape 2x3)',
        'Create weight matrix 1 (3 inputs -> 4 hidden units) and bias 1 (shape 4,)',
        'Compute hidden_output = relu(input @ weights1 + bias1)',
        'Create weight matrix 2 (4 hidden units -> 1 output) and bias 2 (shape 1,)',
        'Compute final_output = hidden_output @ weights2 + bias2 (no activation on the final layer, since this simulates a regression output)',
        'Print the shape of every intermediate result and the final output, and write 2 sentences describing what each step represents',
      ],
      expectedOutput:
          'Input shape: (2, 3)\nHidden output shape: (2, 4)\nFinal output shape: (2, 1)\nFinal predictions: [[1.42] [0.87]]\n\nThis 2-layer forward pass is exactly what Level 4 will have you build in real PyTorch.',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'derivatives_and_gradients_l2',
    topicTitle: 'Derivatives and Gradients',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 30,
    totalXp: 130,
    emoji: '📉',
    intro:
        'How does a neural network actually "learn"? The answer is entirely built on derivatives and gradients. This lesson demystifies these calculus concepts in plain language — no calculus background required — so that gradient descent in the next lesson clicks immediately.',
    concepts: [
      ConceptLesson(
        title: 'What is a Derivative, Intuitively?',
        definition:
            'A derivative measures how much a function\'s output changes when its input changes slightly — it tells you the "slope" or "rate of change" at any given point, which is exactly the information a model needs to know which direction to adjust its parameters.',
        analogy:
            'A derivative is like reading the steepness of a hillside under your feet while hiking in fog with no map. You cannot see the whole landscape, but you can feel which direction is downhill (steepest descent) right where you are standing — that local steepness reading is exactly what a derivative provides.',
        example:
            'For the function f(x) = x², the derivative is f\'(x) = 2x. At x=3, the slope is 2(3)=6, meaning the function is increasing steeply there. At x=0, the slope is 0 — flat, the bottom of the curve. This exact "which way is downhill" information is what a neural network uses to reduce its errors.',
        keyTakeaway:
            'You will never manually compute derivatives in real LLM engineering — PyTorch\'s "autograd" system does this automatically. But understanding what a derivative represents (the local slope, telling you which direction reduces error) is essential to understanding why training sometimes fails.',
      ),
      ConceptLesson(
        title: 'Gradients: Derivatives for Many Parameters at Once',
        definition:
            'A gradient is simply a collection of derivatives — one for each parameter in a model — indicating the direction of steepest INCREASE in the loss (error). Training a neural network means repeatedly moving parameters in the OPPOSITE direction of the gradient, to decrease the loss.',
        analogy:
            'If a derivative is the slope under one foot, a gradient is like sensing the slope under every single foot of a giant, billion-legged creature simultaneously — one combined signal telling every single "leg" (parameter) exactly which tiny direction to move to walk the whole creature downhill toward lower error, all at once.',
        example:
            'A model with 3 parameters (w1, w2, w3) has a gradient like [0.4, -0.2, 0.1] — meaning increasing w1 currently increases error the most (so we should decrease w1), while w2 is already helping reduce error (so we should increase w2 slightly). This exact per-parameter signal drives every training step in Level 4 and Level 7\'s fine-tuning.',
        keyTakeaway:
            'Every single "training step" you will ever run — whether training a small neural network in Level 4 or fine-tuning a billion-parameter LLM in Level 7 — is fundamentally: compute the gradient, then nudge every parameter slightly in the opposite direction. This lesson is the conceptual key to that entire process.',
        codeSnippet:
            '# Conceptual illustration (PyTorch autograd handles this automatically)\nimport numpy as np\n\ndef loss_function(w):\n    return (w - 3) ** 2   # minimum at w = 3\n\ndef gradient(w):\n    return 2 * (w - 3)    # derivative of the loss function\n\nw = 0.0\nfor step in range(5):\n    grad = gradient(w)\n    w = w - 0.3 * grad   # move opposite to the gradient\n    print(f"Step {step}: w={w:.2f}, gradient={grad:.2f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'In plain language, what does a derivative tell you about a function at a specific point?',
        options: [
          'The exact final answer the function will ever produce',
          'How much the function\'s output changes for a small change in input — the local slope or rate of change at that point',
          'The total number of inputs the function can accept',
          'Whether the function is written in Python or another language'
        ],
        correctIndex: 1,
        explanation:
            'A derivative measures the local rate of change (slope) of a function at a given point — exactly the "which direction is downhill" information needed to reduce a model\'s error during training.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why does training a neural network involve moving parameters in the OPPOSITE direction of the gradient?',
        options: [
          'It does not matter which direction you move — any direction works equally well',
          'The gradient points in the direction of steepest INCREASE in loss/error, so moving in the opposite direction is what decreases the error, which is the actual goal of training',
          'Moving opposite to the gradient is purely a stylistic convention with no mathematical reason',
          'Gradients always point directly toward the correct answer, so you should follow them exactly'
        ],
        correctIndex: 1,
        explanation:
            'Since the gradient specifically points toward increasing loss, moving in the opposite direction is exactly what reduces the error — this is the entire mathematical basis of gradient descent, covered in depth in the next lesson.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A model\'s gradient for parameter w is calculated as +5 (positive). What does this suggest about how w should be adjusted to reduce loss?',
        options: [
          'w should be increased further, since the gradient is positive',
          'w should be decreased, since the gradient points toward increasing loss, and we want to move opposite to it to decrease loss',
          'The gradient value has no relationship to how w should be adjusted',
          'w should be set to exactly 0 regardless of the gradient value'
        ],
        correctIndex: 1,
        explanation:
            'A positive gradient means increasing w would increase the loss — so to REDUCE loss (the goal of training), w should be adjusted in the opposite direction, i.e., decreased.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Manual Gradient Descent Simulation',
      goal:
          'Implement a simple gradient descent loop by hand for a basic function, building direct intuition for the exact mechanism used to train every neural network and LLM in this roadmap.',
      steps: [
        'Define a simple loss function loss(w) = (w - 5) ** 2 (the true minimum is at w=5, but your model does not "know" this yet)',
        'Define its derivative/gradient function gradient(w) = 2 * (w - 5)',
        'Start with an initial guess w = 0.0 and a learning_rate = 0.2',
        'Write a loop that runs 10 steps: at each step, compute the gradient, update w by moving opposite to the gradient (w = w - learning_rate * gradient), and print the current w and loss',
        'Observe and write 2-3 sentences describing what happens to w over the 10 steps, and confirm it moves closer to the true minimum of 5',
        'Try changing the learning_rate to a much larger value (like 1.5) and describe what goes wrong — a direct preview of Level 4\'s "learning rate too high" training problem',
      ],
      expectedOutput:
          'Step 0: w=2.00, loss=9.00\nStep 1: w=3.20, loss=3.24\n...\nStep 9: w=4.95, loss=0.0025\n\nWith learning_rate=1.5: w oscillates wildly and loss increases instead of decreasing - this is exactly the "learning rate too high" problem covered in Level 4.',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'probability_fundamentals_l2',
    topicTitle: 'Probability Fundamentals',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🎲',
    intro:
        'Every single token an LLM generates is chosen from a probability distribution over its entire vocabulary. Understanding probability is not optional trivia for an LLM Engineer — it is the literal mechanism behind next-token prediction, sampling, and temperature settings you will configure constantly.',
    concepts: [
      ConceptLesson(
        title: 'Probability Basics: Events and Distributions',
        definition:
            'Probability measures how likely an event is, expressed as a number between 0 (impossible) and 1 (certain). A probability distribution assigns a probability to every possible outcome of an event, and all probabilities in a valid distribution must sum to exactly 1.',
        analogy:
            'A probability distribution is like a pie chart of possible outcomes — every possible next word an LLM could generate gets a "slice" of the pie representing how likely it is, and all the slices together must add up to the whole pie (100%, or 1.0 in probability terms).',
        example:
            'Given the prompt "The sky is", an LLM might assign: "blue" → 0.72, "clear" → 0.15, "grey" → 0.08, and thousands of other words each getting tiny remaining probabilities — all summing to exactly 1.0. This distribution is recalculated fresh for every single token the model generates.',
        keyTakeaway:
            'When you configure an LLM\'s "temperature" setting in Level 7, you are directly reshaping this probability distribution — higher temperature flattens it (more randomness), lower temperature sharpens it (more predictable, confident choices). Understanding distributions now makes temperature immediately intuitive later.',
      ),
      ConceptLesson(
        title: 'Conditional Probability: The Foundation of Language Modeling',
        definition:
            'Conditional probability measures the probability of an event GIVEN that another event has already happened, written P(A|B) — this is precisely what an LLM computes at every step: the probability of the next word, GIVEN all the words that came before it.',
        analogy:
            'Conditional probability is like a weather forecaster updating their prediction after seeing dark clouds roll in. The unconditional probability of rain today might be 20%, but the conditional probability of rain GIVEN that dark clouds are visible right now jumps to 80% — new information (context) sharply changes the probability estimate.',
        example:
            'The unconditional probability of the word "Paris" appearing next in a random sentence is very low. But the conditional probability of "Paris" GIVEN the preceding words "The capital of France is" is very high — this exact conditional calculation, P(next word | previous words), is the mathematical definition of what an LLM computes at every single generation step (directly connecting back to Level 1\'s "next-token prediction" explanation).',
        keyTakeaway:
            'An LLM is, mathematically, nothing more than a very sophisticated way of estimating P(next token | all previous tokens) — conditional probability is not just useful background knowledge, it is the literal mathematical definition of what a language model does.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What must be true about all the probabilities in a valid probability distribution over an LLM\'s vocabulary at a given step?',
        options: [
          'They must all be equal to each other',
          'They must each individually be between 0 and 1, and they must all sum together to exactly 1',
          'Only the top prediction needs a valid probability; the rest can be ignored',
          'There is no requirement — probabilities can be any positive number'
        ],
        correctIndex: 1,
        explanation:
            'A valid probability distribution requires every individual probability to be between 0 and 1, and the complete set of probabilities across all possible outcomes must sum to exactly 1 — representing 100% certainty spread across all possibilities.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is conditional probability described as "the mathematical definition of what a language model does"?',
        options: [
          'Conditional probability has no real connection to how LLMs work',
          'An LLM computes the probability of the next token GIVEN all previous tokens at every generation step — this is exactly what conditional probability, P(A|B), formally represents',
          'LLMs only use unconditional probability, never conditional probability',
          'Conditional probability is only relevant for image generation models, not text'
        ],
        correctIndex: 1,
        explanation:
            'Next-token prediction is precisely P(next token | previous tokens) — a conditional probability calculation, repeated at every single step of text generation.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'An LLM assigns these probabilities for the next word after "I love": {"you": 0.4, "pizza": 0.3, "coding": 0.2, "rain": 0.1}. Is this a valid probability distribution?',
        options: [
          'No, because there are too many words listed',
          'Yes, because every value is between 0 and 1 and they sum to exactly 1.0 (0.4+0.3+0.2+0.1)',
          'No, because "you" has too high a probability',
          'It cannot be determined without knowing the full vocabulary'
        ],
        correctIndex: 1,
        explanation:
            'This is a valid probability distribution: every individual value falls between 0 and 1, and the complete set sums to exactly 1.0 — satisfying both requirements of a proper probability distribution.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Simulating an LLM\'s Next-Token Probability Distribution',
      goal:
          'Build a small simulation of how an LLM samples its next word from a probability distribution — directly previewing the sampling and temperature concepts you will configure for real starting in Level 7.',
      steps: [
        'Create a Python dictionary representing a simulated next-word probability distribution with at least 5 words and probabilities that sum to 1.0 (e.g., after the prompt "The weather today is")',
        'Write a function verify_valid_distribution(dist) that checks whether the probabilities sum to (approximately) 1.0 and returns True/False',
        'Using Python\'s `random` module (random.choices with weights), write a function sample_next_word(dist) that randomly samples one word according to its probability',
        'Run your sampling function 10 times and print the results, observing that higher-probability words are chosen more often but not every single time',
        'Write 2-3 sentences explaining how this relates to the "temperature" concept: what would happen to the sampling if you artificially flattened the distribution (made all probabilities more equal)?',
      ],
      expectedOutput:
          'Distribution: {"sunny": 0.5, "cloudy": 0.25, "rainy": 0.15, "snowy": 0.07, "windy": 0.03}\nIs valid distribution: True\n\n10 samples: [sunny, sunny, cloudy, sunny, rainy, sunny, cloudy, sunny, sunny, cloudy]\n\nExplanation: A flatter distribution (higher temperature) would make rarer words like "windy" get sampled more often...',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'bayes_theorem_l2',
    topicTitle: 'Bayes\' Theorem',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🔄',
    intro:
        'Bayes\' Theorem is the single most important tool for updating beliefs given new evidence — and it underlies everything from spam filters to how you should interpret an LLM\'s confidence scores and evaluation metrics later in this roadmap.',
    concepts: [
      ConceptLesson(
        title: 'What Bayes\' Theorem Actually Says',
        definition:
            'Bayes\' Theorem provides a formula for updating the probability of a hypothesis given new evidence: P(A|B) = [P(B|A) × P(A)] / P(B) — it lets you correctly combine your PRIOR belief about something with NEW evidence to get an updated, more accurate belief.',
        analogy:
            'Bayes\' Theorem is like a detective updating their suspicion of a suspect as new clues arrive. Before any clues (the prior), several suspects seem roughly equally likely. As specific evidence comes in (a fingerprint, an alibi), the detective updates their belief about each suspect\'s guilt — Bayes\' Theorem is the precise mathematical rule for HOW MUCH to update, rather than just guessing.',
        example:
            'A rare disease affects 1% of people (the "prior"). A test is 95% accurate. If someone tests positive, Bayes\' Theorem reveals their actual probability of having the disease is often surprisingly LOW — because the disease is so rare, false positives from the 99% healthy population can outnumber true positives, even with a fairly accurate test.',
        keyTakeaway:
            'This exact base-rate reasoning — do not just trust a headline accuracy number, account for how common or rare the thing actually is — is essential when you evaluate LLM outputs and classifiers later in this roadmap (Level 7\'s LLM evaluation lesson directly builds on this intuition).',
      ),
      ConceptLesson(
        title: 'Why This Matters for Evaluating AI Systems',
        definition:
            'Bayes\' Theorem\'s "base rate" lesson applies directly to evaluating any AI system, including LLMs: a system\'s reported accuracy alone can be dangerously misleading if you do not also consider how rare or common the thing being detected actually is in the real world.',
        analogy:
            'Evaluating an AI system using only its headline accuracy is like judging a smoke detector purely by "how often it correctly identifies smoke when tested in a lab" without asking how often it falsely goes off in a normal, smoke-free kitchen. Both numbers matter, and Bayesian thinking is what correctly combines them into a realistic picture.',
        example:
            'A content moderation LLM that is "99% accurate" at detecting policy violations sounds impressive — but if violations are genuinely rare (say, 0.1% of all content), that same 99% accuracy could still mean the majority of flagged content is actually a false positive, exactly mirroring the disease-testing example above.',
        keyTakeaway:
            'Whenever you evaluate an LLM-based classification or detection system in this roadmap, apply Bayesian thinking: do not trust a headline accuracy number in isolation — always ask "how rare is the thing being detected, and how does that change what this accuracy number actually means in practice?"',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'In the disease-testing example, why can the probability of actually having a rare disease given a positive test result be surprisingly LOW, even with a 95% accurate test?',
        options: [
          'The test\'s accuracy percentage must have been reported incorrectly',
          'Because the disease is rare (a low base rate/prior), even a small false-positive rate applied to the much larger healthy population can produce more false positives than true positives from the small diseased population',
          'Bayes\' Theorem does not apply to medical testing scenarios',
          'A 95% accurate test always guarantees a 95% probability of having the disease given a positive result'
        ],
        correctIndex: 1,
        explanation:
            'This is the classic base-rate effect: because the disease is rare, the much larger healthy population\'s small false-positive rate can numerically outweigh the true positives from the small diseased population, correctly captured by Bayes\' Theorem.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is Bayesian "base rate" thinking directly relevant to evaluating LLM-based classification systems later in this roadmap?',
        options: [
          'It has no relevance to AI systems, only to medical testing',
          'A headline accuracy number for an AI system can be misleading without considering how rare or common the thing being detected actually is — exactly the same base-rate reasoning as the medical testing example',
          'AI systems are never evaluated using accuracy or similar metrics',
          'Bayesian thinking only applies to systems with less than 50% accuracy'
        ],
        correctIndex: 1,
        explanation:
            'The same base-rate reasoning from medical testing applies directly to evaluating any AI classification system — a high headline accuracy can still hide a large proportion of false positives when the detected event is rare.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A fraud-detection LLM system is "97% accurate" and fraud occurs in only 0.2% of transactions. What is the MOST appropriate reaction to this headline accuracy number?',
        options: [
          'Trust the number completely — 97% accuracy means the system is virtually perfect for all purposes',
          'Apply Bayesian base-rate thinking: given how rare fraud actually is, calculate or estimate what proportion of "flagged as fraud" transactions are genuinely fraudulent before concluding the system is reliable',
          'Assume the accuracy number must be an error, since it seems too high',
          'Ignore the accuracy number entirely, since it provides no useful information'
        ],
        correctIndex: 1,
        explanation:
            'Given how rare fraud is (0.2%), Bayesian reasoning is essential to understand what proportion of flagged transactions are truly fraudulent versus false positives — a headline accuracy number alone can be dangerously misleading for rare-event detection.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Bayes\' Theorem Calculator for AI System Evaluation',
      goal:
          'Build a small, reusable Bayes\' Theorem calculator and apply it to a realistic AI evaluation scenario, building the base-rate intuition you will need throughout this roadmap.',
      steps: [
        'Write a function bayes_theorem(prior, sensitivity, false_positive_rate) that returns P(actually positive | flagged positive) using Bayes\' Theorem',
        'Test your function with the classic disease example: prior=0.01, sensitivity=0.95, false_positive_rate=0.10',
        'Test your function with a content-moderation scenario: prior=0.001 (violations are rare), sensitivity=0.99, false_positive_rate=0.02',
        'For each test, print the result and write one sentence interpreting what it means in plain language',
        'Write 2-3 sentences reflecting on how this changes the way you would interpret a future LLM classifier\'s "99% accuracy" claim',
      ],
      expectedOutput:
          'Disease test: P(disease | positive) = 8.8% (surprisingly low despite 95% test accuracy)\nContent moderation: P(violation | flagged) = 4.7% (most flags would actually be false positives)\n\nReflection: A 99% accuracy claim is meaningless without knowing the base rate...',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'stats_distributions_l2',
    topicTitle: 'Statistics and Distributions',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '📊',
    intro:
        'Mean, variance, and the normal distribution are not just statistics-class trivia — they describe how model weights are initialized, how training data is distributed, and how you will evaluate model performance throughout this entire roadmap.',
    concepts: [
      ConceptLesson(
        title: 'Mean and Variance: Describing a Dataset in Two Numbers',
        definition:
            'The mean is the average value of a dataset. Variance (and its square root, standard deviation) measures how spread out the values are around that mean — together, these two numbers give a compact summary of an entire dataset\'s central tendency and spread.',
        analogy:
            'Mean and variance are like describing a group of runners\' finish times with two numbers: the average finish time (mean) tells you the typical performance, while the spread (variance) tells you whether everyone finished close together (low variance, consistent group) or with huge gaps between fastest and slowest (high variance, very mixed ability levels).',
        example:
            'Training losses over 5 epochs: [2.1, 1.8, 1.9, 2.0, 1.7]. Mean = 1.9. If instead the losses were [4.5, 0.2, 3.8, 0.5, 1.0], the mean might be similar, but the huge variance would signal unstable, erratic training — a real diagnostic signal you will use when monitoring model training in Level 4 and beyond.',
        keyTakeaway:
            'When you monitor a model\'s training loss curve in Level 4 and Level 7, you will be reading exactly this: is the mean loss trending down, and is the variance (noise/instability) reasonable or dangerously high? This lesson gives you the vocabulary to describe what you are seeing precisely.',
        codeSnippet:
            'import numpy as np\n\nlosses = np.array([2.1, 1.8, 1.9, 2.0, 1.7])\nprint(f"Mean: {np.mean(losses):.2f}")\nprint(f"Variance: {np.var(losses):.4f}")\nprint(f"Std Dev: {np.std(losses):.4f}")',
      ),
      ConceptLesson(
        title:
            'The Normal Distribution: The Bell Curve That Appears Everywhere',
        definition:
            'The normal (Gaussian) distribution is a specific, extremely common bell-shaped probability distribution, fully described by just its mean and standard deviation — many real-world phenomena, and critically, the way neural network weights are randomly initialized before training, follow this exact distribution.',
        analogy:
            'The normal distribution is like the natural spread of heights in a large population — most people cluster around an average height, with progressively fewer people as you move toward extremely short or extremely tall, forming the familiar bell shape. Neural network weight initialization deliberately mimics this same natural, centered-with-tapering-extremes pattern.',
        example:
            'When you initialize a neural network layer in PyTorch (Level 4), the starting weights are typically drawn randomly from a normal distribution centered at 0 with a small standard deviation — this specific mathematical choice, rather than arbitrary random numbers, is deliberately designed to help training start smoothly and stably.',
        keyTakeaway:
            'You will encounter the normal distribution constantly: in weight initialization (Level 4), in how you interpret model confidence scores, and in statistical evaluation of model outputs — recognizing this one shape and what "mean" and "standard deviation" mean for it will make many later concepts feel immediately familiar.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'You are monitoring a model\'s training loss and notice the variance across recent training steps is extremely high. What does this most likely indicate?',
        options: [
          'The model has finished training perfectly',
          'Training is unstable or erratic — the loss is jumping around significantly rather than trending smoothly, a signal worth investigating (e.g., learning rate too high)',
          'High variance in training loss is always a good sign',
          'Variance has no meaningful relationship to training stability'
        ],
        correctIndex: 1,
        explanation:
            'High variance in training loss indicates instability — the model\'s error is fluctuating erratically rather than trending smoothly downward, often a signal of problems like a learning rate set too high (directly connecting to Level 2\'s gradient descent lesson).',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is the normal distribution particularly relevant to neural network training specifically?',
        options: [
          'It has no actual relevance to neural networks',
          'Neural network weights are typically initialized by drawing random values from a normal distribution, a deliberate choice that helps training start smoothly and stably',
          'The normal distribution is only used for image data, never for text or language models',
          'Normal distributions are only relevant after training is fully complete'
        ],
        correctIndex: 1,
        explanation:
            'Weight initialization — the very first step before any training begins — commonly draws values from a normal distribution, a deliberate and well-studied choice that supports stable, effective training from the start.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Two models report the same average (mean) accuracy of 85% across 10 evaluation runs. Model A has very low variance across runs; Model B has very high variance. Which model is generally more trustworthy for production use, and why?',
        options: [
          'Model B, because high variance always indicates a more powerful model',
          'Model A, because low variance means its performance is consistent and predictable across different runs, while Model B\'s high variance means its performance could unpredictably swing much lower in practice despite the same average',
          'Both models are equally trustworthy, since variance has no practical significance',
          'Neither model\'s variance can be meaningfully compared'
        ],
        correctIndex: 1,
        explanation:
            'Low variance with the same mean indicates consistent, predictable performance — a critical quality for production systems, where unpredictable swings in performance (as in high-variance Model B) create real business risk.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Training Loss Statistics Analyzer',
      goal:
          'Build a small statistics analyzer for simulated training loss data, developing the exact monitoring skills you will use when training real models in Level 4 and 7.',
      steps: [
        'Create two simulated lists of "training losses" over 20 steps: one representing STABLE training (gradually decreasing, low variance) and one representing UNSTABLE training (erratic, high variance) — you can generate these with NumPy',
        'Write a function analyze_training(losses) that computes and prints the mean, variance, and standard deviation',
        'Run your function on both simulated datasets and compare the results',
        'Write a function is_training_stable(losses, variance_threshold) that returns True/False based on whether the variance is below a given threshold',
        'Write 2-3 sentences interpreting what the stable vs unstable statistics tell you, connecting it to what you would do differently as an engineer for each case (e.g., lower the learning rate for unstable training)',
      ],
      expectedOutput:
          'Stable training - Mean: 1.42, Variance: 0.021, Std Dev: 0.145 -> Stable: True\nUnstable training - Mean: 1.48, Variance: 3.87, Std Dev: 1.967 -> Stable: False\n\nInterpretation: Despite similar means, the unstable run shows dangerous fluctuation, suggesting the learning rate should be reduced...',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'loss_functions_gradient_descent_l2',
    topicTitle: 'Loss Functions and Gradient Descent',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 30,
    totalXp: 135,
    emoji: '🎯',
    intro:
        'This lesson brings together vectors, matrices, derivatives, and probability into one unified story: how a model actually learns. Loss functions measure how wrong a model is, and gradient descent is the algorithm that uses that measurement to make the model better, one step at a time.',
    concepts: [
      ConceptLesson(
        title: 'Loss Functions: Measuring How Wrong a Model Is',
        definition:
            'A loss function takes a model\'s prediction and the true target value, and outputs a single number measuring how "wrong" the prediction was — a well-designed loss function is the entire objective that guides everything a model learns during training.',
        analogy:
            'A loss function is like a golf scorecard — a single number summarizing how far your shot landed from the hole. A lower score (loss) means you are closer to the target. The entire game of "training a model" is simply an extremely sophisticated process of trying to minimize this one score, shot after shot, across millions of training examples.',
        example:
            'For a regression task predicting house prices, a common loss function is Mean Squared Error: loss = (predicted_price - actual_price)². If the model predicts ₹50 lakh for a house that actually sold for ₹55 lakh, the loss reflects that 5-lakh error, squared to penalize larger errors more heavily.',
        keyTakeaway:
            'The specific choice of loss function shapes what a model actually learns to prioritize. In Level 7, you will meet cross-entropy loss specifically — the loss function used to train every LLM, directly built from the probability and information theory concepts in this level.',
      ),
      ConceptLesson(
        title: 'Gradient Descent: The Complete Learning Loop',
        definition:
            'Gradient descent is the algorithm that repeatedly: (1) makes a prediction, (2) computes the loss, (3) computes the gradient of the loss with respect to every model parameter, and (4) updates every parameter slightly in the direction that reduces the loss — this loop, repeated thousands or millions of times, is literally how every neural network and LLM learns.',
        analogy:
            'Gradient descent is like descending a foggy mountain by repeatedly checking the slope right under your feet and taking one small careful step in the downhill direction, then checking again, then stepping again — you cannot see the whole mountain (the entire loss landscape), but by repeating this simple local process enough times, you reliably end up much closer to the valley floor (minimum loss).',
        example:
            'Training a model for 1000 steps means running this exact 4-step loop 1000 times: predict, measure loss, compute gradient, update parameters — each individual step makes only a tiny improvement, but the cumulative effect over many steps is what turns a randomly-initialized model into one that can write coherent text.',
        keyTakeaway:
            'This 4-step loop is the single most important concept in this entire level — Level 4\'s PyTorch training loops and Level 7\'s LLM fine-tuning are both, at their core, exactly this same loop, just applied to much larger models with much more data. Understanding it deeply here means Level 4 and 7 will feel like recognizing an old friend.',
        codeSnippet:
            '# The complete gradient descent loop (simplified)\nfor step in range(1000):\n    prediction = model(input_data)          # 1. Predict\n    loss = loss_function(prediction, target) # 2. Measure loss\n    gradients = compute_gradients(loss)      # 3. Compute gradients\n    update_parameters(model, gradients)      # 4. Update parameters\n\n# This exact loop, in PyTorch, is what Level 4 will have you write for real',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the fundamental purpose of a loss function in training a machine learning model?',
        options: [
          'It has no real purpose in training, only in final evaluation',
          'It outputs a single number measuring how wrong the model\'s prediction was, providing the objective signal that the entire training process tries to minimize',
          'It determines how many layers a neural network should have',
          'It is only used for classification tasks, never regression'
        ],
        correctIndex: 1,
        explanation:
            'The loss function is the core objective of training — a single measurable number quantifying prediction error, which gradient descent then works to systematically minimize across the entire training process.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What are the 4 core steps repeated in every iteration of the gradient descent training loop?',
        options: [
          'Load data, save the model, print results, exit the program',
          'Make a prediction, compute the loss, compute the gradient, update the model\'s parameters',
          'Only compute the loss, nothing else is needed',
          'Randomly change the model architecture at every step'
        ],
        correctIndex: 1,
        explanation:
            'The gradient descent loop consistently repeats: predict → measure loss → compute gradients → update parameters — this exact 4-step cycle is the mechanism behind training every neural network and LLM you will build in this roadmap.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A model\'s loss is decreasing very slowly over thousands of training steps, and progress seems to have almost completely stalled. Based on this level\'s concepts, what are 2 plausible causes worth investigating?',
        options: [
          'The loss function has no relationship to training speed',
          'The learning rate might be too small (tiny parameter updates each step), or the model might be near a flat region of the loss landscape where gradients are very small',
          'Stalled training can only ever be caused by having too much training data',
          'This situation always means the model has already achieved perfect performance'
        ],
        correctIndex: 1,
        explanation:
            'Slow, stalled progress commonly stems from either a learning rate that is too small (tiny steps) or gradients that have become very small (a flat region of the loss landscape) — both directly connect to this level\'s derivative and gradient descent concepts.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Level 2 Capstone: Complete Gradient Descent from Scratch',
      goal:
          'Complete Level 2 by implementing a full, working gradient descent training loop from scratch on a simple linear regression problem — tying together vectors, derivatives, loss functions, and gradient descent from this entire level into one working program.',
      steps: [
        'Create a small simulated dataset: X (5 input values) and y (5 target values) that roughly follow a linear relationship y = 3x + 2 with a little random noise',
        'Define a simple model: predict(x, w, b) = w * x + b, starting with random initial values for w and b',
        'Define the Mean Squared Error loss function: loss = mean((predictions - y) ** 2)',
        'Manually derive (or look up) and implement the gradients of the loss with respect to w and b',
        'Write a training loop that runs 100 steps of gradient descent, updating w and b each step, and print the loss every 20 steps to confirm it decreases',
        'After training, print the final learned w and b, and compare them to the true values (3 and 2) — write 2-3 sentences reflecting on how close gradient descent got, and how this exact process scales up to training billion-parameter LLMs in Level 7',
      ],
      expectedOutput:
          '=== LEVEL 2 CAPSTONE: GRADIENT DESCENT FROM SCRATCH ===\nStep 0: loss=14.32\nStep 20: loss=2.15\nStep 40: loss=0.34\nStep 60: loss=0.06\nStep 80: loss=0.02\n\nFinal learned w: 2.94 (true: 3.0)\nFinal learned b: 2.11 (true: 2.0)\n\nReflection: Gradient descent successfully recovered the true relationship from noisy data...\n\n=== LEVEL 2 COMPLETE — MATHEMATICS FOR AI MASTERED ===\nLevel 3: Machine Learning Foundations begins next.',
      xpReward: 70,
    ),
  ),
  TopicCourse(
    id: 'entropy_cross_entropy_l2',
    topicTitle: 'Entropy and Cross-Entropy',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 125,
    emoji: '🌀',
    intro:
        'This final Level 2 lesson introduces the exact loss function used to train every LLM you will ever fine-tune: cross-entropy. It combines everything from this level — probability, logarithms, and the loss function concept — into the one formula powering GPT, Claude, and every language model in between.',
    concepts: [
      ConceptLesson(
        title: 'Entropy: Measuring Uncertainty',
        definition:
            'Entropy measures the amount of uncertainty or "surprise" in a probability distribution — a distribution where one outcome is almost certain has LOW entropy, while a distribution where all outcomes are equally likely has HIGH entropy.',
        analogy:
            'Entropy is like measuring how surprised you would be by the outcome of an event. A coin that always lands heads (100% certain) has zero entropy — no surprise, ever. A fair coin (50/50) has high entropy — genuine, maximal uncertainty about the outcome. The more genuinely unpredictable something is, the higher its entropy.',
        example:
            'A language model predicting the next word after "The" has HIGH entropy (many plausible next words: "cat", "dog", "quick", "old"...). A model predicting the next word after "Once upon a" has LOW entropy (overwhelmingly likely to be "time") — entropy directly captures this intuitive difference in predictability.',
        keyTakeaway:
            'When you evaluate an LLM\'s outputs later in this roadmap, entropy is one lens for understanding how "confident" or "uncertain" the model is at each generation step — high entropy at a token often signals genuine ambiguity, while low entropy signals strong confidence.',
      ),
      ConceptLesson(
        title: 'Cross-Entropy: The Loss Function That Trains Every LLM',
        definition:
            'Cross-entropy loss measures the difference between the model\'s predicted probability distribution and the TRUE distribution (where the actual correct next word has 100% probability and everything else has 0%) — minimizing this exact loss, across billions of training examples, is literally how every LLM learns to predict language.',
        analogy:
            'Cross-entropy loss is like a strict but fair teacher grading not just whether you got the right answer, but how CONFIDENT you were in that answer. If the correct answer was "Paris" and you were 95% confident in "Paris," you get a very low penalty. If you were only 5% confident in "Paris" (even if you technically listed it as a possibility), you get heavily penalized — the loss specifically rewards confident correctness, not just lucky guesses.',
        example:
            'If the true next word is "Paris" and the model assigned it a predicted probability of 0.9, the cross-entropy loss is low (roughly -log(0.9) ≈ 0.10). If the model only assigned "Paris" a probability of 0.1, the loss is much higher (-log(0.1) ≈ 2.30) — the loss grows sharply as the model\'s confidence in the correct answer drops, exactly the training signal needed to push the model toward better predictions.',
        keyTakeaway:
            'This is the exact loss function you will see named explicitly in Level 4 (deep learning) and Level 7 (fine-tuning LLMs) — every single training step of every LLM you will ever fine-tune is, at its mathematical core, minimizing cross-entropy loss, built directly from the probability and entropy concepts in this lesson.',
        codeSnippet:
            'import numpy as np\n\ndef cross_entropy_loss(true_word_probability):\n    return -np.log(true_word_probability)\n\nprint(cross_entropy_loss(0.9))   # 0.105 - low loss, model was confident and correct\nprint(cross_entropy_loss(0.1))   # 2.303 - high loss, model was not confident enough',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'A language model is choosing the next word after "Once upon a" (very predictable: almost certainly "time"). What would you expect its entropy to be at this point, and why?',
        options: [
          'High entropy, because language models are always maximally uncertain',
          'Low entropy, because the next word is highly predictable — one outcome ("time") dominates the probability distribution, meaning very little genuine uncertainty',
          'Entropy cannot be computed for language models',
          'Entropy is unrelated to how predictable an outcome is'
        ],
        correctIndex: 1,
        explanation:
            'Low entropy reflects low uncertainty — when one outcome (like "time" after "Once upon a") dominates the probability distribution, there is little genuine surprise or uncertainty, which is exactly what low entropy measures.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why does cross-entropy loss increase sharply when a model assigns LOW probability to the actually-correct answer, even if that answer was technically included as a possibility?',
        options: [
          'Cross-entropy loss does not actually depend on the model\'s assigned probability at all',
          'Cross-entropy specifically rewards confident correctness — the loss formula (-log of the assigned probability) grows sharply as confidence in the correct answer drops, creating a strong training signal to push the model toward higher confidence in correct answers',
          'Cross-entropy loss only cares about whether the top prediction was correct, ignoring probability values entirely',
          'Low probability assignments are always penalized equally regardless of how low they are'
        ],
        correctIndex: 1,
        explanation:
            'The -log() shape of cross-entropy loss specifically penalizes low confidence in the correct answer increasingly sharply — this precise mathematical shape is what drives models to become both correct AND appropriately confident during training.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Model A assigns 0.8 probability to the correct next word. Model B assigns 0.3 probability to the same correct next word. Which model will have a LOWER cross-entropy loss for this example, and why?',
        options: [
          'Model B, because lower probabilities always produce lower loss',
          'Model A, because cross-entropy loss decreases as the assigned probability to the correct answer increases — Model A was more confidently correct',
          'Both models will have identical loss regardless of their assigned probabilities',
          'Cross-entropy loss cannot be compared between different models'
        ],
        correctIndex: 1,
        explanation:
            'Cross-entropy loss = -log(assigned probability to correct answer). Since 0.8 > 0.3, Model A\'s loss (-log(0.8) ≈ 0.22) is lower than Model B\'s loss (-log(0.3) ≈ 1.20) — Model A was more confidently correct, and its loss reflects that.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Level 2 Wrap-Up: Cross-Entropy Loss Explorer',
      goal:
          'Build a small tool exploring cross-entropy loss behavior across different confidence levels, cementing your understanding of the exact loss function that trains every LLM before moving to Level 3.',
      steps: [
        'Write a function cross_entropy_loss(predicted_probability) implementing -log(predicted_probability) using NumPy',
        'Compute and print the loss for predicted probabilities: 0.99, 0.7, 0.5, 0.3, 0.1, 0.01',
        'Create a simple visualization (can be a printed table or a basic matplotlib plot) showing how loss changes as predicted probability decreases from 0.99 to 0.01',
        'Write 2-3 sentences describing the pattern you observe: does loss increase smoothly, or does it accelerate sharply as probability gets very low?',
        'Write a final short reflection (4-5 sentences) summarizing everything learned across Level 2 — from vectors through cross-entropy — and how each piece connects to a specific concept coming in Level 3 (Machine Learning Foundations) and beyond',
      ],
      expectedOutput:
          '=== CROSS-ENTROPY LOSS EXPLORER ===\nP=0.99 -> Loss=0.010\nP=0.70 -> Loss=0.357\nP=0.50 -> Loss=0.693\nP=0.30 -> Loss=1.204\nP=0.10 -> Loss=2.303\nP=0.01 -> Loss=4.605\n\nPattern: Loss increases sharply and accelerates as probability approaches 0...\n\nLevel 2 reflection: [4-5 sentences connecting vectors, matrices, gradients, probability, and cross-entropy to Level 3+]\n\n=== LEVEL 2 COMPLETE — MATHEMATICS FOR AI MASTERED ===',
      xpReward: 65,
    ),
  ),
];
