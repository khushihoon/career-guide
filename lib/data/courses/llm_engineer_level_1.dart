import '../../models/course_content_data.dart';

const List<TopicCourse> llmEngineerLevel1 = [
  TopicCourse(
    id: 'intro_llm_engineering_l1',
    topicTitle: 'Introduction to LLM Engineering',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '🚀',
    intro:
        'Welcome to your first step toward becoming an LLM Engineer. This is the professional who builds, fine-tunes, and deploys the systems behind ChatGPT-style products. Before touching a single line of Python, you need a clear map of what this career actually is and where you are headed across the next 10 levels.',
    concepts: [
      ConceptLesson(
        title: 'What Does an LLM Engineer Actually Do?',
        definition:
            'An LLM Engineer builds applications and systems powered by Large Language Models — this spans fine-tuning models on custom data, building retrieval-augmented generation (RAG) pipelines, designing AI agents, and deploying these systems reliably in production.',
        analogy:
            'An LLM Engineer is like an electrician for the AI age. Electricians did not invent electricity, but they know how to wire it safely into houses, factories, and cities so it becomes genuinely useful. An LLM Engineer does not invent transformer architecture — they know how to wire powerful pretrained models into real, reliable products.',
        example:
            'A day in the life: fine-tuning an open-source model on a company\'s support tickets, building a RAG pipeline so the model can answer questions from internal documents, and deploying the whole system behind an API that the product team can call — all in one week.',
        keyTakeaway:
            'LLM Engineering sits between pure research (inventing new architectures) and pure software engineering (building apps) — it requires enough ML understanding to make good technical decisions, and enough engineering discipline to ship reliable systems.',
      ),
      ConceptLesson(
        title: 'The 10-Level Roadmap Ahead of You',
        definition:
            'This career path moves from foundations (Python, math, classical ML, deep learning) through NLP and transformers, into LLM-specific skills (fine-tuning, RAG, agents), and finally into production engineering and interview readiness — each level builds directly on the one before it.',
        analogy:
            'This roadmap is like training to become a commercial pilot. You do not start in the cockpit of a jumbo jet — you start with flight theory and small aircraft (foundations), progress to instrument flying (deep learning and NLP), then fly increasingly complex aircraft (transformers, LLMs), before finally being certified to fly passengers commercially (production systems).',
        example:
            'Levels 1-4 build your programming, math, and ML foundation. Levels 5-6 teach NLP and the transformer architecture that powers every modern LLM. Levels 7-9 cover fine-tuning, RAG, and agents — the core LLM Engineer skillset. Level 10 turns all of it into interview-ready proof of your skills.',
        keyTakeaway:
            'Do not skip foundations to rush toward "building with GPT-4" — every advanced LLM Engineer skill in later levels depends directly on genuinely understanding what happens underneath, which is exactly what the early levels build.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which best describes the core focus of an LLM Engineer role?',
        options: [
          'Inventing entirely new transformer architectures from scratch',
          'Building, fine-tuning, and deploying real applications and systems powered by existing large language models',
          'Only writing marketing content about AI products',
          'Manually labeling training datasets full-time'
        ],
        correctIndex: 1,
        explanation:
            'LLM Engineers apply and adapt existing large language models — through fine-tuning, RAG, agents, and deployment — to build real, working products, rather than primarily inventing new model architectures (that is more of an AI research scientist role).',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why does this roadmap start with programming and math foundations instead of jumping straight into "prompting GPT-4"?',
        options: [
          'Foundations are unrelated to LLM engineering and included only as filler',
          'Every advanced skill later in the roadmap — fine-tuning, building transformers, deploying models — depends on genuinely understanding the underlying programming, math, and ML concepts taught in the early levels',
          'Prompting is actually more advanced than Python programming',
          'The roadmap order does not matter and could be studied in any sequence'
        ],
        correctIndex: 1,
        explanation:
            'Skills like fine-tuning and building RAG pipelines are not "magic" — they rest directly on programming fluency, math intuition, and ML/DL fundamentals taught in the early levels. Skipping ahead creates fragile, shallow knowledge.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A friend says "You don\'t need Python or math to be an LLM Engineer, just learn to write good prompts." What is the most accurate response?',
        options: [
          'They are completely right — prompting is the entire job',
          'Prompting is a small, useful skill, but real LLM Engineering roles require fine-tuning models, building RAG/agent pipelines, and deploying production systems — all of which require solid Python, math, and ML foundations',
          'LLM Engineers never write any code at all',
          'Math and programming are only needed for data scientists, not LLM engineers'
        ],
        correctIndex: 1,
        explanation:
            'Prompt engineering is one small piece of the job. Real LLM Engineer roles expect fine-tuning, RAG pipeline construction, agent design, and production deployment — all of which require genuine programming and ML fluency.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'My LLM Engineer Career Map',
      goal:
          'Create a personal roadmap document mapping your current skills against the 10-level path ahead, to anchor your learning motivation from day one.',
      steps: [
        'List the 10 levels of this roadmap in order (Foundations → Math → ML → DL → NLP → Transformers → LLMs & Fine-Tuning → RAG → Agents/Production → Advanced/Interview Prep)',
        'For each level, write one sentence on what you expect to be able to build by the end of it',
        'Honestly rate your current confidence (1-5) in Python programming today',
        'Write 2-3 sentences on why you specifically want to become an LLM Engineer',
        'Identify one real product (an app, chatbot, or tool) you would love to be able to build by the end of this roadmap',
      ],
      expectedOutput:
          'A personal roadmap document with all 10 levels summarized, an honest Python confidence rating, a personal motivation statement, and one concrete target product to build by the end of the journey.',
      xpReward: 45,
    ),
  ),
  TopicCourse(
    id: 'what_is_genai_l1',
    topicTitle: 'What is Generative AI?',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '✨',
    intro:
        'ChatGPT, Midjourney, GitHub Copilot — all Generative AI. But what actually makes AI "generative" rather than just "predictive"? This lesson builds the conceptual foundation you will keep returning to throughout your entire LLM Engineering journey.',
    concepts: [
      ConceptLesson(
        title: 'Generative vs Discriminative AI',
        definition:
            'Discriminative AI classifies or predicts a label for existing input (is this email spam or not?). Generative AI creates entirely new content — text, images, audio, code — that did not exist before, by learning the underlying patterns and structure of its training data.',
        analogy:
            'Discriminative AI is like an art critic who can accurately judge whether a painting is a forgery or an original. Generative AI is like an art student who has studied thousands of paintings so thoroughly that they can now paint an entirely new, original piece in a similar style.',
        example:
            'A spam filter (discriminative) looks at an email and outputs "spam" or "not spam". ChatGPT (generative) looks at "write me an email to my landlord about a leaking pipe" and generates an entirely new, original email that never existed before.',
        keyTakeaway:
            'Generative AI does not retrieve pre-written answers from a database — it constructs new content token by token (or pixel by pixel) based on patterns learned from massive amounts of training data. This is the core capability every LLM Engineer builds on top of.',
      ),
      ConceptLesson(
        title: 'The Generative AI Landscape Beyond Text',
        definition:
            'Generative AI spans multiple modalities: text generation (LLMs like GPT, Claude), image generation (Diffusion models like Midjourney, DALL-E), audio/speech generation, and code generation — with text-based LLMs being the most mature and the primary focus of LLM Engineering.',
        analogy:
            'Generative AI is like a family of specialized artists under one roof — one sculpts in text (LLMs), one paints in pixels (diffusion models), one composes in sound (audio generation). They share common underlying deep learning principles, but each has specialized techniques for its specific medium.',
        example:
            'ChatGPT and Claude generate text. Midjourney and Stable Diffusion generate images from text prompts. ElevenLabs generates realistic speech audio. GitHub Copilot generates code. All are "generative AI" but require different specialized architectures and training approaches.',
        keyTakeaway:
            'This roadmap focuses specifically on text-based Generative AI (LLMs), since it is currently the most in-demand, most mature, and most directly applicable to building real-world software products — the core focus of the LLM Engineer role.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the fundamental difference between generative and discriminative AI?',
        options: [
          'Generative AI is always more accurate than discriminative AI',
          'Discriminative AI classifies or labels existing input, while generative AI creates entirely new content that did not exist before by learning patterns from training data',
          'There is no real difference — the terms are interchangeable',
          'Discriminative AI only works with images, and generative AI only works with text'
        ],
        correctIndex: 1,
        explanation:
            'The core distinction is creation vs classification: discriminative models judge/label existing input, while generative models produce genuinely new output — text, images, audio — based on learned patterns.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why does this LLM Engineer roadmap focus specifically on text-based generative AI rather than image or audio generation?',
        options: [
          'Text-based LLMs are the only form of generative AI that actually works',
          'Text-based LLMs are currently the most mature, most in-demand, and most directly applicable technology for building real-world software products — making it the highest-value focus for this specific career path',
          'Image and audio generation are not considered part of generative AI at all',
          'Text generation requires no understanding of deep learning'
        ],
        correctIndex: 1,
        explanation:
            'While generative AI spans many modalities, text-based LLMs currently offer the broadest, most mature, and most commercially in-demand skillset — which is why LLM Engineering as a career path centers on them.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Which of these is an example of a DISCRIMINATIVE AI task, not a generative one?',
        options: [
          'Writing an original poem about the ocean',
          'Classifying a customer review as positive or negative sentiment',
          'Generating a new marketing email from a short prompt',
          'Creating an image from a text description'
        ],
        correctIndex: 1,
        explanation:
            'Classifying sentiment assigns an existing label (positive/negative) to input that already exists — a discriminative task. The other three options all involve creating genuinely new content, making them generative.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Generative vs Discriminative AI Audit',
      goal:
          'Identify and classify 6 real AI tools/products you have encountered as either generative or discriminative, building intuition for the distinction.',
      steps: [
        'List 6 AI-powered tools or features you have personally used or heard of (e.g., spam filters, ChatGPT, Netflix recommendations, Midjourney, autocorrect, Grammarly)',
        'For each one, classify it as Generative or Discriminative',
        'For each classification, write one sentence justifying WHY it fits that category',
        'Identify which of your 6 examples are text-based generative AI (the specific focus of this roadmap)',
        'Write 2-3 sentences on one real-world problem you would want to solve using text-based generative AI in the future',
      ],
      expectedOutput:
          '6 AI tools correctly classified as generative or discriminative, each with a clear one-sentence justification. Text-based generative examples correctly identified. A personal reflection on a future generative AI application you want to build.',
      xpReward: 45,
    ),
  ),
  TopicCourse(
    id: 'what_are_llms_l1',
    topicTitle: 'What are Large Language Models?',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🧠',
    intro:
        'Large Language Models are the engine behind every AI product you will build in this career. This lesson demystifies what an LLM actually is, in plain language, before you encounter the deep technical details in Level 6.',
    concepts: [
      ConceptLesson(
        title: 'LLMs in Plain Language',
        definition:
            'A Large Language Model is a neural network trained on massive amounts of text to predict the next word (technically, the next "token") in a sequence — and this simple prediction task, at massive scale, produces a system capable of writing, reasoning, summarizing, translating, and coding.',
        analogy:
            'An LLM is like an extremely well-read person who has read a significant fraction of the internet, and whose core skill is finishing your sentences in a way that sounds natural and useful — except this person has read literally billions of documents and can apply that pattern-completion skill to almost any topic.',
        example:
            'Given "The capital of France is", an LLM predicts the most likely next token is "Paris" — not because it looked up a fact in a database, but because it has seen this pattern millions of times in its training data and learned the statistical association.',
        keyTakeaway:
            'At its core, an LLM is "just" next-token prediction at an enormous scale — but this simple mechanism, trained on enough data with enough parameters, produces genuinely useful reasoning, writing, and problem-solving behavior. Understanding this core mechanism will make every later level click into place.',
      ),
      ConceptLesson(
        title: '"Large" — What Makes These Models So Big',
        definition:
            'LLMs are called "large" because of their parameter count (the learned numerical weights inside the neural network, often in the billions) and the massive scale of text they are trained on (hundreds of billions to trillions of words) — this scale is a key reason they can generalize to tasks they were never explicitly trained for.',
        analogy:
            'Parameters are like the countless tiny adjustable dials inside a giant mixing board that shape the final sound. A small model has a few thousand dials — enough for simple patterns. A large language model has billions of dials, each fine-tuned during training, enabling far more nuanced and flexible behavior.',
        example:
            'GPT-2 (2019) had 1.5 billion parameters. Modern frontier LLMs have hundreds of billions of parameters, trained on trillions of words of text — this scale increase is a major reason today\'s models can hold coherent conversations, write working code, and reason through multi-step problems, while earlier smaller models could not.',
        keyTakeaway:
            'Model scale (parameters + training data) is one major driver of LLM capability, but not the only one — architecture design, training technique, and fine-tuning also matter enormously, which is exactly what Levels 6 and 7 of this roadmap will teach you in depth.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'At its core, what task is a Large Language Model fundamentally trained to perform?',
        options: [
          'Looking up facts from a stored database of pre-written answers',
          'Predicting the most likely next token (word/sub-word) in a sequence, based on patterns learned from massive amounts of training text',
          'Directly copying and pasting from web pages it has memorized verbatim',
          'Running mathematical calculations using a built-in calculator'
        ],
        correctIndex: 1,
        explanation:
            'LLMs are fundamentally next-token prediction systems — trained to predict the most statistically likely next piece of text given everything that came before, based on patterns learned from massive training data.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why are LLMs referred to as "large"?',
        options: [
          'Because the software installation file size is very large',
          'Because they contain enormous numbers of learned parameters (often billions) and are trained on massive amounts of text data — this scale is a key driver of their advanced capabilities',
          'Because they require a large physical building to store',
          '"Large" refers only to the length of text they can generate in one response'
        ],
        correctIndex: 1,
        explanation:
            '"Large" specifically refers to the enormous parameter count and massive training data scale — both of which are strongly linked to the emergent capabilities (reasoning, coherent writing, coding) that smaller models lack.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A beginner says "LLMs must have a giant database where they look up the right answer to every question." What is the accurate correction?',
        options: [
          'This is actually correct — LLMs work exactly like a search engine database lookup',
          'LLMs do not store or look up pre-written answers — they generate new text token by token based on statistical patterns learned during training, which is why they can respond to entirely novel questions they have never seen before',
          'LLMs only work for questions that were explicitly included as exact question-answer pairs in training',
          'LLMs generate random text with no relationship to their training data at all'
        ],
        correctIndex: 1,
        explanation:
            'LLMs generate responses through learned statistical pattern prediction, not database lookup — this is precisely why they can respond coherently to entirely novel prompts they never saw verbatim during training.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'LLM Concept Explainer',
      goal:
          'Write a clear, jargon-free explanation of what an LLM is and how it works at a high level, suitable for a complete beginner — practicing the communication skill every LLM Engineer needs.',
      steps: [
        'Write a 4-5 sentence explanation of what an LLM is, using the "next-token prediction" concept, in plain language with no jargon',
        'Write one concrete example (like the "capital of France" example) demonstrating next-token prediction in action',
        'Explain in 2-3 sentences why model "size" (parameters + training data) matters for capability',
        'List 3 real applications you have personally used that are powered by an LLM (e.g., ChatGPT, Claude, GitHub Copilot, customer support chatbots)',
        'Write one sentence explaining one thing about LLMs that still feels confusing or surprising to you right now — this becomes something to watch for as later levels explain it in depth',
      ],
      expectedOutput:
          'A clear, plain-language explanation of LLMs covering next-token prediction, a concrete example, the role of scale, 3 real applications identified, and one honest open question for future levels to resolve.',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'llm_vs_traditional_ai_l1',
    topicTitle: 'How LLMs Differ from Traditional AI/ML',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '⚖️',
    intro:
        'Traditional ML (like the models a Data Scientist builds) and LLMs are related but genuinely different beasts. Understanding exactly how they differ — and where they overlap — will help you see clearly why this roadmap includes classical ML and deep learning levels before ever touching a transformer.',
    concepts: [
      ConceptLesson(
        title: 'Task-Specific vs General-Purpose Models',
        definition:
            'Traditional ML models are typically trained for one narrow, specific task (predict house prices, detect fraud, classify images) using a specific labeled dataset for that task. LLMs are general-purpose — one single pretrained model can perform translation, summarization, coding, and reasoning without being separately trained for each.',
        analogy:
            'A traditional ML model is like a specialized tool — a hammer is excellent at driving nails but useless for cutting wood. An LLM is more like a skilled generalist craftsperson who, having learned broad foundational skills, can reasonably handle many different tasks (with some being asked to specialize further, similar to fine-tuning).',
        example:
            'A traditional fraud detection model (built by a Data Scientist) is trained specifically and only on transaction data to output fraud/not-fraud — it cannot write an email or summarize a document. A single LLM like GPT-4 can do fraud-pattern explanation, email writing, AND document summarization, all from one general-purpose pretrained model.',
        keyTakeaway:
            'This generality is exactly why LLM Engineering is a distinct discipline — instead of training a new model from scratch for every task (the traditional ML approach), LLM Engineers adapt one powerful general-purpose model to many specific use cases through prompting, RAG, and fine-tuning.',
      ),
      ConceptLesson(
        title: 'Why This Roadmap Still Teaches Classical ML and Deep Learning',
        definition:
            'Despite LLMs being general-purpose, the underlying mathematical and engineering foundations — gradient descent, neural network training, evaluation metrics, overfitting — are identical to what powers LLMs. Skipping these foundations to jump straight to "using LLMs" leaves dangerous gaps in your ability to fine-tune, debug, and reason about LLM behavior.',
        analogy:
            'Skipping ML/DL foundations to jump straight into LLMs is like learning to drive a race car without ever understanding how an engine, brakes, or steering actually work — you might drive competently in ideal conditions, but the moment something unexpected happens (the car skids, the model behaves unexpectedly), you have no foundation to diagnose or fix the problem.',
        example:
            'When fine-tuning an LLM in Level 7, you will directly apply Level 3-4 concepts: gradient descent, loss functions, overfitting, and learning rate tuning — the exact same principles, just applied to a much larger model. Without Levels 3-4, fine-tuning becomes trial-and-error guesswork instead of informed engineering.',
        keyTakeaway:
            'LLMs are built ON TOP OF classical ML and deep learning principles, not as a replacement for them — every level in this roadmap is deliberately sequenced so each new skill has a solid foundation to stand on.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the key difference between a traditional ML model built by a Data Scientist and a general-purpose LLM?',
        options: [
          'Traditional ML models are always more accurate than LLMs on every possible task',
          'Traditional ML models are typically trained for one narrow, specific task, while a single pretrained LLM can perform many different tasks (translation, summarization, coding) without separate task-specific training',
          'LLMs cannot be used for any classification-style tasks at all',
          'There is no meaningful difference between the two approaches'
        ],
        correctIndex: 1,
        explanation:
            'The defining difference is generality: traditional ML models are narrow specialists trained for one task, while LLMs are general-purpose models capable of handling many different tasks from one pretrained foundation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why does this LLM Engineer roadmap still include classical ML (Level 3) and deep learning (Level 4) foundations before reaching LLM-specific content?',
        options: [
          'Classical ML and deep learning have no actual relevance to LLM engineering',
          'The core mathematical and engineering principles (gradient descent, loss functions, overfitting) that power classical ML and deep learning are the SAME principles that underlie LLMs — skipping them leaves dangerous gaps for tasks like fine-tuning and debugging',
          'These levels are included only as unrelated filler content',
          'LLMs work using a completely different, unrelated set of mathematical principles'
        ],
        correctIndex: 1,
        explanation:
            'LLMs are built on the exact same foundational principles taught in classical ML and deep learning levels — genuinely understanding fine-tuning, training behavior, and model debugging requires this foundation.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A beginner asks: "If LLMs are so powerful and general-purpose, why not just skip straight to Level 7 (Fine-Tuning) and skip the math/ML levels entirely?" What is the best response?',
        options: [
          'That is a great idea — math and classical ML have no relevance to fine-tuning an LLM',
          'Fine-tuning an LLM directly applies gradient descent, loss functions, and overfitting concepts from the math and ML levels — skipping them means fine-tuning becomes unreliable guesswork instead of informed, debuggable engineering',
          'Fine-tuning requires no understanding of how neural networks actually learn',
          'The math and ML levels are only useful for becoming a Data Scientist, never an LLM Engineer'
        ],
        correctIndex: 1,
        explanation:
            'Fine-tuning is a direct, hands-on application of gradient descent and neural network training principles — without genuinely understanding these foundations, fine-tuning becomes unpredictable trial-and-error rather than informed engineering.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Traditional ML vs LLM Comparison Table',
      goal:
          'Build a clear comparison table contrasting traditional ML and LLMs across key dimensions, solidifying your understanding of where each approach fits.',
      steps: [
        'Create a comparison table with columns: "Traditional ML" and "Large Language Models"',
        'Add rows for: Task Scope (narrow vs general), Typical Training Data Size, Typical Use Case Example, and Who Typically Builds/Uses Them',
        'Fill in each cell with a specific, accurate description for both columns',
        'Write 2-3 sentences explaining one scenario where a traditional ML model (not an LLM) would actually be the better tool for the job',
        'Write 2-3 sentences explaining one scenario where an LLM would clearly be the better tool for the job',
      ],
      expectedOutput:
          'A complete, accurate comparison table across 4 dimensions. One well-reasoned scenario favoring traditional ML, and one well-reasoned scenario favoring LLMs — demonstrating genuine understanding of when each approach fits best.',
      xpReward: 45,
    ),
  ),
  TopicCourse(
    id: 'python_fundamentals_llm_l1',
    topicTitle: 'Python Fundamentals for LLM Engineering',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🐍',
    intro:
        'Python is the language every LLM framework speaks — PyTorch, Hugging Face, LangChain, OpenAI SDK. This lesson gets you writing and running real Python code, building the muscle memory you will use in every single lesson from here through Level 10.',
    concepts: [
      ConceptLesson(
        title: 'Setting Up Your Python Environment',
        definition:
            'Before writing any LLM code, you need a working Python installation and a way to run code — either locally (installed Python + an editor) or in the cloud (Google Colab, which requires zero installation and gives free GPU access, ideal for LLM experimentation).',
        analogy:
            'Setting up your environment is like a chef setting up their kitchen before cooking — you would not start cooking a complex dish in a kitchen with no stove or utensils. Google Colab is like a fully-equipped shared kitchen you can walk into immediately with zero setup, while a local install is like building your own permanent kitchen at home.',
        example:
            'To start immediately with zero setup: go to colab.research.google.com, create a new notebook, and type print("Hello, LLM Engineer!") in a cell, then press Shift+Enter to run it. You now have a working Python environment with free GPU access for later deep learning lessons.',
        keyTakeaway:
            'Beginners should start with Google Colab — it removes all installation friction and lets you focus entirely on learning Python and, later, running actual deep learning models with free GPU access, which becomes essential from Level 4 onward.',
      ),
      ConceptLesson(
        title: 'Running and Reading Your First Python Code',
        definition:
            'Python code executes top to bottom, line by line. The print() function displays output. Comments (starting with #) are notes for humans that Python ignores entirely — both are essential for writing and understanding any code you will encounter in this roadmap.',
        analogy:
            'Reading Python code top-to-bottom is like following a recipe step by step — you cannot skip ahead to step 5 before completing step 1-4, because later steps often depend on ingredients prepared earlier. Comments are like a chef\'s handwritten notes in the margin of the recipe, useful for humans but not part of the actual cooking process.',
        example:
            '# This program greets an LLM Engineer\nname = "Alex"  # store the name\nprint(f"Welcome, {name}, to LLM Engineering!")  # display a personalized greeting\n\nOutput: Welcome, Alex, to LLM Engineering!',
        keyTakeaway:
            'Get comfortable running small snippets of code and reading the output immediately — this constant "write a little, run it, see what happens" cycle is exactly how professional LLM Engineers iterate, from simple scripts through complex model training loops.',
        codeSnippet:
            '# Your first LLM Engineer Python program\nname = "Alex"\nrole = "LLM Engineer"\nprint(f"Welcome, {name}! You are becoming an {role}.")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why is Google Colab recommended as a starting environment for beginners in this roadmap?',
        options: [
          'It is the only tool that can ever run Python code',
          'It requires zero installation, removes setup friction, and provides free GPU access — which becomes essential for deep learning and LLM experimentation later in this roadmap',
          'It is required to write any Python program, even simple ones',
          'Local Python installations are always broken and unreliable'
        ],
        correctIndex: 1,
        explanation:
            'Colab removes all installation friction for beginners and, critically, provides free GPU access — a resource you will directly need starting in Level 4 for deep learning and later for LLM fine-tuning experimentation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'In the line `name = "Alex"  # store the name`, what does the `#` symbol do?',
        options: [
          'It causes an error because Python does not support that symbol',
          'It marks the rest of the line as a comment — a human-readable note that Python completely ignores when running the code',
          'It tells Python to print everything after it',
          'It is required syntax for every variable assignment'
        ],
        correctIndex: 1,
        explanation:
            'The `#` symbol starts a comment in Python — everything after it on that line is ignored by the Python interpreter and exists purely to help human readers understand the code.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'What will this code print?\n\nname = "Maya"\nprint(f"Hello, {name}!")',
        options: [
          'Hello, name!',
          'Hello, Maya!',
          'f"Hello, {name}!"',
          'An error, because f-strings are not valid Python'
        ],
        correctIndex: 1,
        explanation:
            'f-strings (f"...") let you embed variable values directly inside a string using curly braces. {name} is replaced with the actual value stored in the name variable, "Maya", producing "Hello, Maya!".',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Your First LLM Engineer Python Script',
      goal:
          'Set up a working Python environment (local or Colab) and write your first multi-line script, establishing the write-run-read cycle you will use throughout this entire roadmap.',
      steps: [
        'Open Google Colab (or set up a local Python environment) and create a new notebook/file',
        'Write 3 variables: your name, your target role ("LLM Engineer"), and today\'s date as text',
        'Write a comment above each variable explaining what it stores',
        'Use an f-string to print a full sentence combining all 3 variables into a personalized welcome message',
        'Add a second print statement listing 3 things you are excited to learn in this roadmap',
        'Run the code and confirm the output displays correctly with no errors',
      ],
      expectedOutput:
          'Welcome, [Your Name]! You started your journey to becoming an LLM Engineer on [date].\nThings I am excited to learn: transformers, fine-tuning, building AI agents.\n\n(Code runs successfully with no errors, all 3 variables displayed correctly.)',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'variables_datatypes_operators_l1',
    topicTitle: 'Variables, Data Types and Operators',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🔤',
    intro:
        'Every prompt template, every model configuration, every API parameter you will work with as an LLM Engineer is built from variables, data types, and operators. This lesson locks in these absolute fundamentals with LLM-flavored examples.',
    concepts: [
      ConceptLesson(
        title: 'Variables and Core Data Types',
        definition:
            'A variable is a named container for a value. Python\'s core data types are: str (text), int (whole numbers), float (decimals), and bool (True/False) — every configuration setting you will pass to an LLM API (temperature, max_tokens, model name) uses one of these basic types.',
        analogy:
            'Variables are like labeled storage bins in a warehouse. You write "temperature" on one bin and put the value 0.7 inside. Whenever your code needs that setting, it opens that specific labeled bin instead of you having to remember the raw number every time.',
        example:
            'model_name = "gpt-4"       # str\ntemperature = 0.7          # float\nmax_tokens = 500           # int\nstream_response = True     # bool\n\nThese 4 variables are exactly the kind of configuration you will set constantly when calling any LLM API.',
        keyTakeaway:
            'LLM API calls are essentially just Python function calls configured with variables of these exact 4 basic types — mastering them now means every future API call in this roadmap will feel immediately familiar.',
        codeSnippet:
            'model_name = "gpt-4"\ntemperature = 0.7\nmax_tokens = 500\nstream_response = True\n\nprint(type(model_name))       # <class \'str\'>\nprint(type(temperature))      # <class \'float\'>',
      ),
      ConceptLesson(
        title: 'Operators: Arithmetic, Comparison and Logical',
        definition:
            'Arithmetic operators (+, -, *, /) perform math. Comparison operators (==, !=, <, >) compare values and return True/False. Logical operators (and, or, not) combine multiple True/False conditions — all three types appear constantly when writing logic around LLM outputs (checking token limits, validating responses).',
        analogy:
            'Operators are like the verbs of programming — arithmetic operators DO math, comparison operators ASK questions ("is this bigger than that?"), and logical operators COMBINE multiple questions into one ("is it both affordable AND fast?"). Every piece of decision-making logic in your future LLM pipelines is built from these simple building blocks.',
        example:
            'token_count = 450\nmax_allowed = 500\nis_within_limit = token_count <= max_allowed   # True\nis_safe_and_short = is_within_limit and (token_count < 400)   # False\n\nThis exact pattern — checking token limits with comparison and logical operators — appears constantly in real LLM applications.',
        keyTakeaway:
            'You will use comparison and logical operators constantly to validate LLM inputs and outputs — checking token limits, confidence thresholds, and response quality — long before you ever touch a transformer model directly.',
        codeSnippet:
            'token_count = 450\nmax_allowed = 500\n\nis_within_limit = token_count <= max_allowed\nprint(is_within_limit)   # True\n\nis_safe_and_short = is_within_limit and (token_count < 400)\nprint(is_safe_and_short)  # False',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which Python data type would you use to store an LLM API setting like temperature = 0.7?',
        options: ['int', 'str', 'float', 'bool'],
        correctIndex: 2,
        explanation:
            'Since 0.7 is a decimal number, it is stored as a float. Whole numbers (like max_tokens = 500) use int, and text values (like model_name = "gpt-4") use str.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does the expression `token_count <= max_allowed` return?',
        options: [
          'The sum of the two numbers',
          'A True or False boolean value depending on whether the comparison holds',
          'An error, since <= is not valid Python',
          'The larger of the two values'
        ],
        correctIndex: 1,
        explanation:
            '<= is a comparison operator. It evaluates whether token_count is less than or equal to max_allowed and returns a boolean (True or False) result — never the numbers themselves.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'What is the output of this code?\n\nresponse_length = 320\nmax_length = 500\nis_valid = response_length < max_length and response_length > 0\nprint(is_valid)',
        options: ['320', 'True', 'False', 'An error'],
        correctIndex: 1,
        explanation:
            'response_length (320) is both less than max_length (500) AND greater than 0 — both conditions are True, so the `and` combines them into a final result of True.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'LLM API Config Validator',
      goal:
          'Build a small script that stores typical LLM API configuration settings and validates them using operators — a realistic mini version of checks used in real LLM applications.',
      steps: [
        'Create variables for: model_name (str), temperature (float), max_tokens (int), and use_streaming (bool)',
        'Write a comparison check: is temperature between 0 and 1 (inclusive)?',
        'Write a comparison check: is max_tokens less than or equal to 2000?',
        'Combine both checks using `and` into one variable called config_is_valid',
        'Print a clear message: if config_is_valid is True, print "Configuration is valid!", otherwise print "Configuration has an issue - check settings."',
        'Test your script with one valid configuration and one intentionally invalid configuration (e.g., temperature = 1.5)',
      ],
      expectedOutput:
          'Test 1 (temperature=0.7, max_tokens=500): Configuration is valid!\nTest 2 (temperature=1.5, max_tokens=500): Configuration has an issue - check settings.',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'conditions_loops_l1',
    topicTitle: 'Conditions and Loops',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🔁',
    intro:
        'Every LLM pipeline needs decision-making (should we retry this API call?) and repetition (process each document in a batch). Conditions and loops are the control structures that make this possible — and you will use them in nearly every script you write in this career.',
    concepts: [
      ConceptLesson(
        title: 'Conditional Logic: if / elif / else',
        definition:
            'Conditional statements let your program branch into different behavior based on whether a condition is True or False — essential for handling different LLM API outcomes (success, rate limit, error) differently.',
        analogy:
            'Conditional logic is like a customer service flowchart. IF the customer\'s issue is billing, route to billing. ELIF it is technical, route to tech support. ELSE, route to general inquiries. Your code needs exactly this kind of branching to handle the different situations an LLM API call can produce.',
        example:
            'status_code = 429\nif status_code == 200:\n    print("Success! Processing response.")\nelif status_code == 429:\n    print("Rate limited - waiting before retry.")\nelse:\n    print("Unexpected error - logging for review.")',
        keyTakeaway:
            'Real LLM applications constantly check conditions — did the API call succeed? Is the response too long? Did the model refuse the request? — if/elif/else is the fundamental tool for handling every one of these branches correctly.',
        codeSnippet:
            'status_code = 429\n\nif status_code == 200:\n    print("Success! Processing response.")\nelif status_code == 429:\n    print("Rate limited - waiting before retry.")\nelse:\n    print("Unexpected error - logging for review.")',
      ),
      ConceptLesson(
        title: 'Loops: for and while',
        definition:
            'A for loop repeats code a set number of times, typically iterating over a list of items. A while loop repeats code as long as a condition remains True — both are essential for processing batches of prompts, retrying failed API calls, and handling streaming LLM responses.',
        analogy:
            'A for loop is like going through a stack of exam papers one by one until the stack is empty — you know exactly how many papers exist. A while loop is like knocking on a door repeatedly until someone answers — you do not know in advance how many knocks it will take, only the condition that ends the repetition.',
        example:
            'prompts = ["Summarize this article", "Translate to French", "Fix this code bug"]\nfor prompt in prompts:\n    print(f"Processing: {prompt}")\n\nThis exact for-loop pattern is how you will process a batch of user prompts through an LLM in almost every project in this roadmap.',
        keyTakeaway:
            'for loops are your default choice when processing a known list of items (prompts, documents, API responses). while loops are your choice for retry logic ("keep retrying while the call has failed and we have not exceeded max attempts").',
        codeSnippet:
            'prompts = ["Summarize this article", "Translate to French", "Fix this code bug"]\n\nfor prompt in prompts:\n    print(f"Processing: {prompt}")\n\n# while loop example: retry logic\nattempts = 0\nwhile attempts < 3:\n    print(f"Attempt {attempts + 1}")\n    attempts += 1',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'You need to process a known list of 10 prompts through an LLM API, one at a time. Which loop type is the natural choice?',
        options: [
          'while loop',
          'for loop',
          'if/elif/else',
          'None of these can process a list'
        ],
        correctIndex: 1,
        explanation:
            'A for loop is designed exactly for iterating over a known collection (like a list of 10 prompts) — it naturally processes each item once without needing to manually track a counter or exit condition.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is a while loop typically better suited than a for loop for implementing API retry logic?',
        options: [
          'while loops are always faster than for loops',
          'Retry logic depends on an unknown number of attempts (keep retrying until success or a max limit is hit) rather than a fixed, known list — which matches exactly what a while loop with a condition is designed for',
          'for loops cannot use conditions of any kind',
          'while loops are required by Python for any API-related code'
        ],
        correctIndex: 1,
        explanation:
            'Retry logic depends on a condition (has the call succeeded yet? have we hit the max attempts?) rather than iterating over a fixed, known list — exactly the scenario a while loop is designed to handle.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'What does this code print?\n\nresponses = ["ok", "error", "ok"]\nfor r in responses:\n    if r == "error":\n        print("Retry needed")\n    else:\n        print("Success")',
        options: [
          'Success\\nSuccess\\nSuccess',
          'Success\\nRetry needed\\nSuccess',
          'Retry needed\\nRetry needed\\nRetry needed',
          'An error, because you cannot use if inside a for loop'
        ],
        correctIndex: 1,
        explanation:
            'The for loop checks each item: "ok" → Success, "error" → Retry needed, "ok" → Success. if/elif/else statements can absolutely be nested inside for loops — this pattern is extremely common in real code.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Batch Prompt Processor with Retry Logic',
      goal:
          'Build a simulated batch prompt processor that loops through multiple prompts and includes basic retry logic for simulated failures — a realistic mini version of a production LLM pipeline.',
      steps: [
        'Create a list of 5 prompt strings representing tasks to send to an LLM',
        'Use a for loop to go through each prompt and print "Processing: [prompt]"',
        'Simulate a status_code for each prompt (you choose the values, include at least one 429 and one 200)',
        'Inside the loop, use if/elif/else to print "Success", "Rate limited - retrying", or "Unknown error" based on the status code',
        'For any rate-limited prompt, use a while loop to simulate up to 3 retry attempts, printing each attempt',
        'Print a final summary counting how many prompts succeeded vs needed retries',
      ],
      expectedOutput:
          'Processing: Summarize this article\nSuccess\nProcessing: Translate to French\nRate limited - retrying\n  Retry attempt 1\n  Retry attempt 2\nProcessing: Fix this code bug\nSuccess\n...\nSummary: 4 succeeded, 1 needed retries',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'functions_l1',
    topicTitle: 'Functions',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '⚙️',
    intro:
        'Functions are how you package reusable logic — and in LLM engineering, you will write functions for building prompts, calling APIs, and parsing responses constantly. This lesson makes functions second nature before you build your first real LLM utility.',
    concepts: [
      ConceptLesson(
        title: 'Defining and Calling Functions',
        definition:
            'A function is a named, reusable block of code defined once with `def` and called (invoked) as many times as needed, optionally accepting input parameters and returning an output value.',
        analogy:
            'A function is like a vending machine. You define it once (design the machine and stock it). Then anyone can call it (insert money, press a button) as many times as they want, and it reliably produces the same type of output every time based on the input given.',
        example:
            'def build_prompt(task, tone):\n    return f"Please {task} in a {tone} tone."\n\nprompt1 = build_prompt("summarize this article", "formal")\nprompt2 = build_prompt("write a birthday message", "playful")\n\nEach call reuses the same function logic with different inputs.',
        keyTakeaway:
            'Any time you find yourself writing similar code more than once (building prompts, formatting outputs), that is a signal to wrap it in a function — this single habit is what separates clean, maintainable LLM code from messy, repetitive scripts.',
        codeSnippet:
            'def build_prompt(task, tone="neutral"):\n    return f"Please {task} in a {tone} tone."\n\nprint(build_prompt("summarize this article", "formal"))\nprint(build_prompt("write a birthday message", "playful"))',
      ),
      ConceptLesson(
        title: 'Parameters, Default Values, and Return Values',
        definition:
            'Function parameters accept input values when called. Default parameter values are used automatically if the caller does not provide one. The return statement sends a value back to whoever called the function — without it, a function produces no usable output.',
        analogy:
            'Default parameter values are like a coffee shop\'s standard order — if you just say "one coffee," you get it with the default milk and sugar unless you specifically request otherwise. This lets callers skip specifying every single detail every time, using it only when they need something non-standard.',
        example:
            'def call_llm(prompt, temperature=0.7, max_tokens=200):\n    return f"[Simulated LLM call] prompt=\'{prompt}\', temp={temperature}, tokens={max_tokens}"\n\n# Uses defaults:\nprint(call_llm("Explain gravity"))\n# Overrides defaults:\nprint(call_llm("Explain gravity", temperature=0.2, max_tokens=100))',
        keyTakeaway:
            'Every real LLM API wrapper function you write will use default parameters (like temperature=0.7) so callers only need to specify what genuinely differs from the standard case — exactly the pattern used by professional libraries like the OpenAI SDK.',
        codeSnippet:
            'def call_llm(prompt, temperature=0.7, max_tokens=200):\n    return f"[Simulated LLM call] prompt=\'{prompt}\', temp={temperature}, tokens={max_tokens}"\n\nprint(call_llm("Explain gravity"))\nprint(call_llm("Explain gravity", temperature=0.2, max_tokens=100))',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the primary benefit of wrapping repeated logic (like building a prompt string) inside a function?',
        options: [
          'Functions make Python code run on a GPU automatically',
          'It makes the logic reusable and maintainable — you define the behavior once and can call it many times with different inputs, instead of duplicating similar code repeatedly',
          'Functions are required by Python for any code to execute',
          'It automatically connects your code to an LLM API'
        ],
        correctIndex: 1,
        explanation:
            'Functions package logic once so it can be reused and updated in a single place — avoiding the maintenance nightmare of duplicated, slightly-different copies of similar code scattered throughout a project.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'In `def call_llm(prompt, temperature=0.7):`, what happens if you call `call_llm("Hello")` without specifying temperature?',
        options: [
          'It raises an error because temperature is required',
          'temperature automatically uses its default value of 0.7',
          'temperature becomes None',
          'The function cannot run without all parameters explicitly provided'
        ],
        correctIndex: 1,
        explanation:
            'Default parameter values are used automatically when the caller omits that argument — call_llm("Hello") runs successfully with temperature defaulting to 0.7.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'What does this code print?\n\ndef greet_model(name):\n    return f"Hello, {name} model!"\n\nresult = greet_model("GPT")\nprint(result)',
        options: [
          'Hello, name model!',
          'Hello, GPT model!',
          'None',
          'An error, since return statements cannot use f-strings'
        ],
        correctIndex: 1,
        explanation:
            'The function returns the formatted string with "GPT" substituted for {name}. That returned value is stored in `result` and printed: "Hello, GPT model!"',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Reusable LLM Prompt-Building Toolkit',
      goal:
          'Build a small library of reusable functions for constructing and simulating LLM calls — the foundational pattern of every real prompt engineering codebase.',
      steps: [
        'Write a function build_summarization_prompt(text, max_words=50) that returns a formatted prompt string asking to summarize the given text in max_words or fewer',
        'Write a function build_translation_prompt(text, target_language) that returns a formatted prompt string asking to translate the text',
        'Write a function simulate_llm_call(prompt, temperature=0.7) that returns a string simulating what an LLM call would look like (no real API needed) including the prompt and temperature used',
        'Call each function at least twice with different inputs, including at least one call that uses a default parameter and one that overrides it',
        'Print all results clearly labeled',
      ],
      expectedOutput:
          'Summarization prompt: "Summarize the following in 50 words or fewer: ..."\nTranslation prompt: "Translate the following to Spanish: ..."\n[Simulated LLM call] prompt=\'...\', temperature=0.7\n[Simulated LLM call] prompt=\'...\', temperature=0.2',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'lists_dicts_tuples_sets_l1',
    topicTitle: 'Lists, Dictionaries, Tuples and Sets',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 30,
    totalXp: 130,
    emoji: '📦',
    intro:
        'Every conversation history, every API response, every tokenized document you will work with as an LLM Engineer is stored in lists and dictionaries. This lesson builds deep fluency with Python\'s core collection types using exactly the shapes of data you will see in real LLM work.',
    concepts: [
      ConceptLesson(
        title: 'Lists: Ordered, Changeable Collections',
        definition:
            'A list is an ordered, changeable collection of items accessed by numeric index (starting at 0) — used constantly to store batches of prompts, conversation turns, or generated tokens.',
        analogy:
            'A list is like a numbered playlist. Song #1, Song #2, Song #3 — order matters, and you can add, remove, or reorder songs at any time. Conversation histories with an LLM work exactly this way: an ordered sequence of turns you can append to.',
        example:
            'conversation = ["Hello!", "How can I help you today?", "What is RAG?"]\nconversation.append("RAG stands for Retrieval-Augmented Generation.")\nprint(conversation[0])   # Hello!\nprint(len(conversation)) # 4',
        keyTakeaway:
            'Lists are your default tool for anything ordered and growing over time — conversation histories, batches of documents to process, or a sequence of generated tokens.',
        codeSnippet:
            'conversation = ["Hello!", "How can I help you today?"]\nconversation.append("What is RAG?")\nprint(conversation)\nprint(len(conversation))',
      ),
      ConceptLesson(
        title: 'Dictionaries: Key-Value Pairs (The LLM API\'s Native Language)',
        definition:
            'A dictionary stores key-value pairs, letting you look up a value instantly by its name rather than a numeric position — this is EXACTLY the format every LLM API request and response uses (JSON, which maps directly to Python dicts).',
        analogy:
            'A dictionary is like a labeled filing cabinet — you look up "role" and instantly get "assistant", you look up "content" and instantly get the message text. No need to remember whether "role" was the 1st or 3rd item — you just ask for it by name.',
        example:
            'message = {"role": "user", "content": "Explain quantum computing", "temperature": 0.7}\nprint(message["role"])       # user\nprint(message["content"])    # Explain quantum computing',
        keyTakeaway:
            'Every LLM API call you will ever make — OpenAI, Anthropic, Hugging Face — sends and receives data as dictionaries (JSON under the hood). Fluency here is directly, immediately applicable to real API work starting in Level 7.',
        codeSnippet:
            'message = {"role": "user", "content": "Explain quantum computing"}\nprint(message["role"])\nprint(message["content"])\n\nmessage["temperature"] = 0.7  # add a new key\nprint(message)',
      ),
      ConceptLesson(
        title: 'Tuples and Sets: When You Need Something Different',
        definition:
            'A tuple is like a list but immutable (cannot be changed after creation) — used for fixed, unchanging data like coordinate pairs or fixed configuration values. A set stores only unique items with no duplicates — useful for deduplicating tokens or tracking unique categories.',
        analogy:
            'A tuple is like a sealed, tamper-proof certificate — once issued, its contents cannot be altered, ideal for values that should never accidentally change. A set is like a guest list where everyone\'s name appears exactly once no matter how many times they were invited — perfect for automatically removing duplicates.',
        example:
            'model_version = ("gpt-4", "2024-05")  # tuple - fixed, should not change\n\nunique_topics = {"AI", "Python", "AI", "Machine Learning"}\nprint(unique_topics)  # {\'AI\', \'Python\', \'Machine Learning\'} - duplicate "AI" automatically removed',
        keyTakeaway:
            'Reach for a tuple when data should genuinely never change (a fixed model version identifier). Reach for a set when you need automatic deduplication (unique words across many documents, unique categories seen in a dataset).',
        codeSnippet:
            'model_version = ("gpt-4", "2024-05")\nprint(model_version[0])  # gpt-4\n\nunique_topics = {"AI", "Python", "AI", "Machine Learning"}\nprint(unique_topics)\nprint(len(unique_topics))  # 3, duplicates removed',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why are Python dictionaries especially important for LLM Engineering specifically?',
        options: [
          'Dictionaries are actually rarely used in real LLM code',
          'Every LLM API request and response is structured as key-value data (JSON), which maps directly onto Python dictionaries — making dict fluency directly applicable to real API work',
          'Dictionaries are only used for storing model weights',
          'LLM APIs never use dictionaries or JSON at all'
        ],
        correctIndex: 1,
        explanation:
            'LLM APIs communicate using JSON, which Python represents as dictionaries — every message, config, and response you will handle in Level 7+ uses exactly this key-value structure.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'You need to store a growing conversation history where new messages are constantly appended in order. Which data structure is the best fit?',
        options: [
          'A tuple, since it is immutable',
          'A set, to avoid duplicates',
          'A list, since it is ordered and changeable',
          'A single string only'
        ],
        correctIndex: 2,
        explanation:
            'A list is ordered (preserves conversation sequence) and changeable (supports .append() for new messages) — exactly matching the requirements of a growing conversation history.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'What does this code print?\n\nmsg = {"role": "assistant", "content": "Hi there!"}\nprint(msg["content"])',
        options: [
          'role',
          'assistant',
          'Hi there!',
          'An error, since "content" is not a valid index'
        ],
        correctIndex: 2,
        explanation:
            'Dictionary values are accessed by their key using square brackets. msg["content"] looks up the value associated with the "content" key, which is "Hi there!"',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Conversation History Manager',
      goal:
          'Build a small conversation history manager using lists and dictionaries — the exact data structure pattern used by every real chatbot and LLM API integration.',
      steps: [
        'Create an empty list called conversation_history',
        'Write a function add_message(history, role, content) that appends a dictionary {"role": role, "content": content} to the history list',
        'Add at least 4 messages alternating between "user" and "assistant" roles using your function',
        'Write a function get_unique_roles(history) that returns a set of all unique roles present in the conversation (should return {"user", "assistant"})',
        'Write a loop that prints each message in the conversation formatted as "[role]: content"',
        'Print the total number of messages and the unique roles found',
      ],
      expectedOutput:
          '[user]: What is RAG?\n[assistant]: Retrieval-Augmented Generation combines search with generation.\n[user]: Can you give an example?\n[assistant]: Sure! A chatbot that searches your docs before answering.\n\nTotal messages: 4\nUnique roles: {\'user\', \'assistant\'}',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'strings_text_processing_l1',
    topicTitle: 'Strings and Text Processing',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 30,
    totalXp: 130,
    emoji: '📝',
    intro:
        'LLMs are, fundamentally, text-in-text-out systems — which means string manipulation is one of the single most-used skills in your entire career. This lesson builds real fluency with the text processing patterns you will use to build prompts and clean model outputs.',
    concepts: [
      ConceptLesson(
        title: 'String Basics and f-strings for Prompt Building',
        definition:
            'Strings are sequences of text characters. Python\'s f-strings let you embed variables directly inside a string using {curly braces} — the single most common technique for dynamically building LLM prompts from templates.',
        analogy:
            'f-strings are like a mail-merge template for a form letter — you write the fixed template once ("Dear {name}, your order #{order_id} has shipped") and the specific values get automatically filled in for each individual letter, rather than manually typing every letter from scratch.',
        example:
            'user_question = "What is a transformer?"\ncontext = "Transformers are a neural network architecture..."\nprompt = f"Using this context: {context}\\n\\nAnswer this question: {user_question}"\nprint(prompt)',
        keyTakeaway:
            'f-strings are how you will build nearly every dynamic prompt in this entire roadmap — from simple prompts here in Level 1 to complex RAG prompt templates in Level 8, the underlying technique is exactly this.',
        codeSnippet:
            'user_question = "What is a transformer?"\ncontext = "Transformers are a neural network architecture..."\nprompt = f"Using this context: {context}\\n\\nAnswer this question: {user_question}"\nprint(prompt)',
      ),
      ConceptLesson(
        title: 'Essential String Methods for Cleaning LLM Output',
        definition:
            'Python provides built-in string methods for cleaning and transforming text: .strip() removes extra whitespace, .lower()/.upper() change case, .split() breaks text into a list, .replace() substitutes text, and .join() combines a list back into a single string — all essential for cleaning raw LLM output.',
        analogy:
            'String methods are like a proofreading toolkit — .strip() trims stray whitespace like tidying uneven margins, .split() breaks a paragraph into individual sentences for closer inspection, .replace() is a find-and-replace tool. LLM outputs often arrive slightly messy, and these are the tools you use to clean them before showing them to a user.',
        example:
            'raw_output = "  The answer is: PARIS.  \\n"\ncleaned = raw_output.strip().lower().replace("the answer is: ", "")\nprint(cleaned)  # "paris."\n\nwords = "machine learning is powerful".split()\nprint(words)  # [\'machine\', \'learning\', \'is\', \'powerful\']',
        keyTakeaway:
            'Raw LLM output is almost never perfectly clean — extra whitespace, inconsistent casing, unwanted prefixes. Every LLM Engineer writes cleaning functions using exactly these string methods before passing model output to users or downstream systems.',
        codeSnippet:
            'raw_output = "  The answer is: PARIS.  \\n"\ncleaned = raw_output.strip().replace("The answer is: ", "")\nprint(cleaned)\n\nwords = "machine learning is powerful".split()\nprint(words)\nprint(" | ".join(words))',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why are f-strings especially important for LLM Engineering?',
        options: [
          'They are the only way to write any text in Python',
          'They let you dynamically insert variable values into a template string — exactly the technique used to build prompts from reusable templates with changing content',
          'f-strings automatically call an LLM API',
          'f-strings only work with numbers, not text'
        ],
        correctIndex: 1,
        explanation:
            'f-strings enable dynamic prompt construction — embedding variable content (user questions, retrieved context, examples) into a fixed template structure, which is exactly how real prompt engineering works.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'An LLM response arrives as "  Paris.\\n" (with extra whitespace). Which method call removes the extra whitespace?',
        options: [
          'response.split()',
          'response.strip()',
          'response.upper()',
          'response.join()'
        ],
        correctIndex: 1,
        explanation:
            '.strip() removes leading and trailing whitespace (including newlines) from a string — exactly the tool needed to clean up whitespace-padded LLM output.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'What does this code print?\n\ntext = "Hello World"\nprint(text.lower().split())',
        options: [
          "['Hello', 'World']",
          "['hello', 'world']",
          "'hello world'",
          "An error, since .lower() and .split() cannot be chained together"
        ],
        correctIndex: 1,
        explanation:
            'Methods can be chained: .lower() first converts to "hello world", then .split() breaks it into a list by whitespace: [\'hello\', \'world\']. Method chaining like this is extremely common in text-cleaning code.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Prompt Template Builder + Output Cleaner',
      goal:
          'Build two complementary utilities every LLM Engineer needs: a dynamic prompt builder using f-strings, and an output cleaner using string methods.',
      steps: [
        'Write a function build_qa_prompt(context, question) that returns an f-string formatted prompt combining the context and question with clear labels',
        'Test it with at least 2 different context/question pairs',
        'Write a function clean_llm_output(raw_text) that strips whitespace, removes a common unwanted prefix like "Answer: " if present (using .replace()), and returns the cleaned result',
        'Test clean_llm_output() with at least 3 messy example strings (extra whitespace, unwanted prefixes, mixed casing)',
        'Write a function word_count(text) using .split() that returns the number of words in a piece of text, and test it on one of your cleaned outputs',
      ],
      expectedOutput:
          'Prompt 1: "Context: Transformers use self-attention...\\n\\nQuestion: What is self-attention?"\nCleaned output 1: "self-attention lets each word look at every other word."\nWord count: 8',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'oop_basics_l1',
    topicTitle: 'Object-Oriented Programming Basics',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 30,
    totalXp: 130,
    emoji: '🏛️',
    intro:
        'Every framework you will use in this career — PyTorch models, Hugging Face tokenizers, LangChain chains — is built from classes. You do not need to be a design-pattern expert, but you must be comfortable reading, using, and extending classes fluently.',
    concepts: [
      ConceptLesson(
        title: 'Classes and Objects: The Blueprint Pattern',
        definition:
            'A class is a blueprint defining what data (attributes) and behavior (methods) a type of object has. An object (or instance) is one actual thing created from that blueprint, with its own independent data.',
        analogy:
            'A class is like the blueprint for a car model — it defines that every car of this model has a color, a fuel level, and a "drive" behavior. Each individual car built from that blueprint (each object) has its own specific color and fuel level, even though they all share the same design.',
        example:
            'class ChatSession:\n    def __init__(self, user_name):\n        self.user_name = user_name\n        self.history = []\n\n    def add_message(self, content):\n        self.history.append(content)\n\nsession1 = ChatSession("Alex")\nsession2 = ChatSession("Priya")\n# Each session independently tracks its own history',
        keyTakeaway:
            '__init__ is the special method that runs automatically when you create a new object, setting up its initial data (self.user_name, self.history). This exact pattern appears in every PyTorch model and Hugging Face class you will ever use.',
        codeSnippet:
            'class ChatSession:\n    def __init__(self, user_name):\n        self.user_name = user_name\n        self.history = []\n\n    def add_message(self, content):\n        self.history.append(content)\n\nsession1 = ChatSession("Alex")\nsession1.add_message("Hello!")\nprint(session1.history)',
      ),
      ConceptLesson(
        title: 'Why LLM Libraries Are Built Entirely from Classes',
        definition:
            'Every major LLM framework — PyTorch\'s nn.Module, Hugging Face\'s tokenizers and pipelines, LangChain\'s chains — packages related data and behavior together as classes, which you will constantly instantiate, configure, and occasionally subclass rather than build from scratch.',
        analogy:
            'Using library classes is like renting a fully furnished, professionally-built apartment instead of constructing your own house from raw materials — you do not need to understand every detail of how the plumbing was engineered; you need to know how to correctly use the faucets, thermostat, and appliances that were already built for you.',
        example:
            'When you later write:\ntokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")\nmodel = AutoModel.from_pretrained("bert-base-uncased")\n\nBoth AutoTokenizer and AutoModel are classes. from_pretrained() is a method that constructs a fully-configured object for you — exactly the class/object pattern from this lesson, just built by Hugging Face engineers.',
        keyTakeaway:
            'You do not need to become an expert at DESIGNING complex class hierarchies right now — you need fluency READING and USING classes, since that is 90% of what real LLM engineering with existing frameworks requires.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the relationship between a class and an object in Python?',
        options: [
          'They are exactly the same thing with different names',
          'A class is the blueprint/template defining structure and behavior, while an object is one specific instance created from that blueprint, with its own independent data',
          'A class can only ever create exactly one object',
          'Objects define classes, not the other way around'
        ],
        correctIndex: 1,
        explanation:
            'A class defines the shared structure and behavior (the blueprint). Each object created from it (via instantiation) is an independent instance with its own data, following that shared blueprint.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the purpose of the __init__ method in a Python class?',
        options: [
          'It deletes the object when no longer needed',
          'It runs automatically when a new object is created, used to set up the object\'s initial attributes/data',
          'It is only used for printing objects to the console',
          '__init__ is optional and never actually used in real code'
        ],
        correctIndex: 1,
        explanation:
            '__init__ is the constructor method — it runs automatically whenever a new object is created from the class, typically used to set initial attribute values (like self.history = []).',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Given this class:\nclass PromptBuilder:\n    def __init__(self, style):\n        self.style = style\n\npb = PromptBuilder("formal")\nWhat is the value of pb.style?',
        options: [
          '"style"',
          '"formal"',
          'None',
          'An error, since style was never assigned'
        ],
        correctIndex: 1,
        explanation:
            'When PromptBuilder("formal") is called, __init__ runs with style="formal", and self.style = style stores it as "formal" on the object. So pb.style returns "formal".',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build a ChatSession Class',
      goal:
          'Build a small, realistic ChatSession class that manages conversation state — directly foreshadowing the session/memory classes used in real LLM chatbot applications from Level 8 onward.',
      steps: [
        'Create a ChatSession class with an __init__ method that stores user_name and an empty history list',
        'Add a method add_message(role, content) that appends a {"role": role, "content": content} dictionary to history',
        'Add a method get_message_count() that returns the number of messages in history',
        'Add a method get_last_message() that returns the most recent message, or a friendly message if history is empty',
        'Create 2 separate ChatSession objects for 2 different users, add different messages to each, and print each session\'s message count independently — demonstrating that each object maintains its own separate state',
      ],
      expectedOutput:
          'Session for Alex: 3 messages\nLast message: {\'role\': \'assistant\', \'content\': \'Happy to help!\'}\n\nSession for Priya: 2 messages\nLast message: {\'role\': \'user\', \'content\': \'Thanks!\'}\n\n(Each session tracks completely independent state)',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'modules_packages_venv_l1',
    topicTitle: 'Modules, Packages and Virtual Environments',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '📚',
    intro:
        'You will never build an LLM system from raw Python alone — you will import powerful libraries like transformers, torch, and langchain. This lesson teaches you how Python organizes code into reusable modules and packages, and how to manage them safely per project.',
    concepts: [
      ConceptLesson(
        title: 'Modules and the import Statement',
        definition:
            'A module is simply a Python file containing reusable code. The import statement lets you access code from another module or installed library — this is how you will bring in every LLM tool you use throughout this roadmap.',
        analogy:
            'Modules are like specialized toolboxes. Instead of forging every tool yourself from raw metal, you import a pre-built toolbox (a module) and immediately use the tools inside it. Python\'s standard library and installed packages are thousands of expertly pre-built toolboxes ready to import.',
        example:
            'import math\nprint(math.sqrt(16))   # 4.0\n\nimport json\ndata = json.loads(\'{"role": "user", "content": "hi"}\')\nprint(data["role"])   # user\n\nThe json module will become essential from Level 7 onward for handling LLM API responses.',
        keyTakeaway:
            'Whenever you need functionality that seems common (math, dates, JSON parsing), check if a module already provides it before writing it yourself — Python\'s ecosystem, and the LLM libraries built on top of it, exist precisely so you rarely reinvent the wheel.',
        codeSnippet:
            'import json\n\nraw_response = \'{"role": "assistant", "content": "Hello!"}\'\ndata = json.loads(raw_response)\nprint(data["content"])\n\nback_to_json = json.dumps(data)\nprint(back_to_json)',
      ),
      ConceptLesson(
        title: 'Packages and pip: Installing the LLM Ecosystem',
        definition:
            'A package is a collection of modules bundled together and distributed for others to install — pip is Python\'s package installer, used to install every major LLM library (transformers, torch, openai, langchain) you will use throughout this roadmap.',
        analogy:
            'pip is like an app store specifically for Python code. Instead of downloading and manually configuring a complex library like PyTorch yourself, one command (pip install torch) downloads and correctly sets it up, ready to import and use immediately.',
        example:
            'pip install transformers torch\n\n# Then in your Python code:\nfrom transformers import pipeline\ngenerator = pipeline("text-generation", model="gpt2")\n\nThis single pip install unlocks the entire Hugging Face ecosystem you will use extensively starting in Level 6.',
        keyTakeaway:
            'Nearly every powerful capability in this roadmap — running transformers, fine-tuning models, building RAG pipelines — starts with a single pip install command bringing in a well-built package, followed by an import statement to use it.',
        codeSnippet:
            '# In your terminal:\n# pip install transformers\n\n# In your Python code:\nfrom transformers import pipeline\ngenerator = pipeline("sentiment-analysis")\nprint(generator("I love learning about LLMs!"))',
      ),
      ConceptLesson(
        title: 'Virtual Environments: Isolating Your LLM Projects',
        definition:
            'A virtual environment is an isolated Python installation for a single project, ensuring its installed package versions never conflict with another project\'s requirements — critical in LLM engineering where projects often need specific, sometimes conflicting versions of torch or transformers.',
        analogy:
            'A virtual environment is like giving each project its own separate, sealed toolbox rather than sharing one communal toolbox across your entire workshop. If one project needs an older wrench size (an older library version) for a legacy build, it will not accidentally disrupt a different project using newer tools.',
        example:
            'python -m venv llm-project-env\nsource llm-project-env/bin/activate   # Mac/Linux\nllm-project-env\\Scripts\\activate      # Windows\npip install transformers torch\n\nNow this project\'s packages are completely isolated from any other project on your machine.',
        keyTakeaway:
            'Get in the habit of creating a fresh virtual environment for every new LLM project from day one — this single habit prevents the vast majority of "it worked last week but now it\'s broken" bugs that waste enormous amounts of engineering time.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the role of pip in Python development?',
        options: [
          'It runs your Python code faster',
          'It is Python\'s package installer, used to download and install external libraries (like transformers or torch) so they can be imported and used in your code',
          'It is a text editor for writing Python code',
          'It only works for installing standard library modules, never third-party packages'
        ],
        correctIndex: 1,
        explanation:
            'pip is Python\'s standard package manager — it downloads and installs external packages (like the LLM libraries you will use throughout this roadmap) so they become available to import in your code.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should each LLM project typically use its own separate virtual environment?',
        options: [
          'Virtual environments make code run on a GPU automatically',
          'They isolate each project\'s package versions from each other, preventing conflicts when different projects require different (sometimes incompatible) versions of the same library',
          'Python requires a new virtual environment for every single script you write',
          'Virtual environments are only needed for very large, enterprise-scale projects'
        ],
        correctIndex: 1,
        explanation:
            'Virtual environments isolate dependencies per project — critical in LLM engineering where different projects frequently require different, sometimes conflicting, versions of large libraries like torch or transformers.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You want to use Python\'s built-in tools for parsing JSON data returned from an LLM API. Which line correctly brings in that functionality?',
        options: [
          'pip install json',
          'import json',
          'from json use everything',
          'download json'
        ],
        correctIndex: 1,
        explanation:
            'json is part of Python\'s standard library (no installation needed), so `import json` alone gives you access to json.loads() and json.dumps() for parsing and creating JSON data.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Set Up Your First Isolated LLM Project Environment',
      goal:
          'Practice the exact environment setup workflow you will repeat for every real project in this career: virtual environment, package installation, and using an installed package.',
      steps: [
        'Create a new virtual environment for a project called "llm-basics" using python -m venv',
        'Activate the virtual environment',
        'Use pip to install the `requests` package (a common library for making API calls)',
        'Write a requirements.txt file listing the installed package(s) using pip freeze',
        'Write a short Python script that imports the json module (standard library) and parses a sample JSON string representing a fake LLM API response, printing out the "content" field',
        'Document the 4 terminal commands you ran, in order, as comments at the top of your script',
      ],
      expectedOutput:
          '# Commands run:\n# 1. python -m venv llm-basics-env\n# 2. source llm-basics-env/bin/activate\n# 3. pip install requests\n# 4. pip freeze > requirements.txt\n\nParsed content: "Hello! How can I help you today?"',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'apis_json_fundamentals_l1',
    topicTitle: 'APIs and JSON Fundamentals',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 30,
    totalXp: 135,
    emoji: '🔌',
    intro:
        'Nearly every LLM you will use in production — GPT-4, Claude, Gemini — is accessed through an API. This lesson demystifies exactly how APIs work and how JSON, the universal data format of the web, structures every request and response you will ever send.',
    concepts: [
      ConceptLesson(
        title: 'What is an API, in Plain Language?',
        definition:
            'An API (Application Programming Interface) is a defined way for one piece of software to request something from another over the internet — sending a structured request and receiving a structured response, without needing to know anything about how the other system works internally.',
        analogy:
            'An API is like ordering food through a restaurant\'s menu and waiter, rather than walking into the kitchen yourself. You do not need to know how the kitchen is organized or how the chef cooks — you place a structured order (the API request) through an agreed-upon interface (the menu) and receive a structured result (the API response).',
        example:
            'When your Python code calls an LLM API, it sends a structured request ("here is my prompt, and my settings") to OpenAI or Anthropic\'s servers over the internet, and receives back a structured response containing the generated text — all without you needing to know anything about the massive model running on their servers.',
        keyTakeaway:
            'You do not need to understand networking protocols in deep detail to use APIs effectively — you need to understand the CONTRACT: what structured request format is expected, and what structured response format you will receive back.',
      ),
      ConceptLesson(
        title: 'JSON: The Universal Language of APIs',
        definition:
            'JSON (JavaScript Object Notation) is a lightweight, text-based data format for structuring information as key-value pairs and lists — nearly every API on the internet, including every major LLM provider, sends and receives data in JSON, which maps directly onto Python dictionaries and lists.',
        analogy:
            'JSON is like a universally agreed-upon shipping label format used by every courier company worldwide — no matter which company (OpenAI, Anthropic, Google) is shipping the package (data), the label format (JSON structure) is understood by everyone, making the whole global system interoperable.',
        example:
            'A real (simplified) LLM API request in JSON:\n{\n  "model": "gpt-4",\n  "messages": [{"role": "user", "content": "What is RAG?"}],\n  "temperature": 0.7\n}\n\nThis JSON maps directly onto a Python dictionary with the exact same structure.',
        keyTakeaway:
            'Since JSON maps directly onto Python dicts and lists (Lesson 9 of this level), your existing Python skills already transfer perfectly to reading, building, and parsing real LLM API requests and responses.',
        codeSnippet:
            'import json\n\nrequest_data = {\n    "model": "gpt-4",\n    "messages": [{"role": "user", "content": "What is RAG?"}],\n    "temperature": 0.7\n}\n\njson_string = json.dumps(request_data)\nprint(json_string)\n\nparsed_back = json.loads(json_string)\nprint(parsed_back["messages"][0]["content"])',
      ),
      ConceptLesson(
        title: 'HTTP Status Codes and Basic Request Structure',
        definition:
            'API requests use HTTP methods (most commonly POST, for sending data) and receive a status code indicating the outcome: 200 means success, 4xx codes mean a client-side error (bad request, invalid API key), and 5xx codes mean a server-side error — understanding these is essential for writing reliable LLM API integrations.',
        analogy:
            'HTTP status codes are like a standardized set of traffic signals used by every API worldwide — a green light (200) means proceed, your request succeeded. A red light with a specific reason (401, 429) tells you exactly what went wrong on your end. A flashing signal (500) tells you the problem is on the other side, not yours.',
        example:
            '200 OK — request succeeded, response contains the generated text.\n401 Unauthorized — your API key is missing or invalid.\n429 Too Many Requests — you have hit a rate limit; wait and retry.\n500 Internal Server Error — something went wrong on the provider\'s end, not yours.',
        keyTakeaway:
            'Recognizing what a status code means is the first step in writing the retry-and-error-handling logic (from Level 1\'s software best practices lesson) that keeps real LLM applications reliable — 429 means "retry later," while 401 means "fix your credentials, retrying won\'t help."',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why is JSON considered the "universal language" of modern APIs, including LLM APIs?',
        options: [
          'JSON is the only data format that computers can understand',
          'JSON provides a lightweight, standardized, text-based way to structure key-value data that nearly every API (including every major LLM provider) uses to send and receive information, and it maps directly onto Python dicts/lists',
          'JSON is a programming language used exclusively for building APIs',
          'JSON can only be used with the Python programming language'
        ],
        correctIndex: 1,
        explanation:
            'JSON\'s standardized, simple key-value structure has become the near-universal format for API communication across the entire industry, including every major LLM provider — and it maps directly onto Python\'s native dict/list structures.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'You call an LLM API and receive a 429 status code. What does this indicate, and what is the appropriate response?',
        options: [
          'The request succeeded perfectly, no action needed',
          'You have hit a rate limit — the appropriate response is to wait and retry, rather than immediately assuming your credentials or request format are wrong',
          'Your API key is permanently invalid and cannot be fixed',
          'The LLM provider\'s servers are completely down with no way to recover'
        ],
        correctIndex: 1,
        explanation:
            '429 specifically means "Too Many Requests" — a rate limit was hit. The correct response is implementing retry logic with a delay (as covered in Level 1\'s software best practices lesson), not treating it as a permanent failure.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'An API response comes back with status code 401. What is the MOST likely correct interpretation?',
        options: [
          'The request succeeded and returned useful data',
          'There is likely a problem with your API key or authentication credentials, not a temporary rate limit issue',
          'You should immediately retry the exact same request with no changes',
          'The server is experiencing a temporary internal outage'
        ],
        correctIndex: 1,
        explanation:
            '401 Unauthorized specifically indicates an authentication problem (missing or invalid API key) — retrying the identical request will not help; the credentials themselves need to be fixed.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Simulated LLM API Request/Response Handler',
      goal:
          'Build a complete simulated API interaction — constructing a JSON-style request, simulating a response with different status codes, and handling each outcome appropriately — directly preparing you for real API calls starting in Level 7.',
      steps: [
        'Build a Python dictionary representing a realistic LLM API request: model, messages (list with role/content), and temperature',
        'Convert it to a JSON string using json.dumps() and print it',
        'Write a function simulate_api_call(status_code) that returns a simulated response dictionary based on the status_code passed in (200: success with fake generated text, 429: rate limited, 401: auth error, 500: server error)',
        'Write a function handle_response(response) that checks the status_code field and prints an appropriate message for each of the 4 cases (success, retry needed, fix credentials, server issue)',
        'Test your handle_response() function with all 4 possible status codes',
      ],
      expectedOutput:
          'Request JSON: {"model": "gpt-4", "messages": [...], "temperature": 0.7}\n\nStatus 200: Success! Generated text: "..."\nStatus 429: Rate limited - implement retry with backoff\nStatus 401: Authentication error - check API key\nStatus 500: Server error - not your fault, log and retry later',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'git_github_basics_l1',
    topicTitle: 'Working with Git and GitHub Basics',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '🌿',
    intro:
        'Every LLM project you build — prompt templates, fine-tuning scripts, RAG pipelines — needs version control from day one. This lesson gets you comfortable with the specific Git and GitHub workflow you will use throughout the rest of this roadmap and your entire career.',
    concepts: [
      ConceptLesson(
        title: 'Git Fundamentals: Tracking Changes Over Time',
        definition:
            'Git is a version control system that tracks changes to your files over time, letting you save meaningful checkpoints (commits), see exactly what changed and when, and revert to any previous state — essential in LLM engineering where prompt tweaks and config changes directly affect model behavior.',
        analogy:
            'Git is like a detailed, permanent revision history for a shared document — instead of a vague "Document_final_v3_ACTUAL_final.docx", every single meaningful change is recorded with a timestamp and description, and you can instantly rewind to see exactly what any earlier version looked like.',
        example:
            'git init                                    # start tracking a new project\ngit add prompt_templates.py                 # stage a specific changed file\ngit commit -m "Improve summarization prompt clarity"   # save a checkpoint with a description',
        keyTakeaway:
            'In LLM engineering specifically, commit your prompt templates and configuration files just as rigorously as your code — a single prompt wording change can dramatically shift model behavior, and Git lets you trace exactly which change caused it.',
        codeSnippet:
            '# Basic Git workflow\ngit init\ngit add prompt_templates.py\ngit commit -m "Improve summarization prompt clarity"\ngit log   # view commit history',
      ),
      ConceptLesson(
        title: 'GitHub: Sharing and Collaborating on Your Work',
        definition:
            'GitHub is a cloud platform for hosting Git repositories, enabling you to back up your projects online, showcase your work publicly (essential for your future portfolio), and collaborate with others — you will use it to store every project throughout this entire roadmap.',
        analogy:
            'If Git is your personal, detailed diary of every change you have made, GitHub is like publishing that diary online in a shared library — others can read it, learn from it, and (with permission) even contribute their own pages to it. Your GitHub profile becomes a public, browsable record of your actual skills.',
        example:
            'git remote add origin https://github.com/yourname/llm-basics.git\ngit push origin main\n\nAfter this, your project is backed up online and visible on your GitHub profile — exactly what future employers and Level 10\'s portfolio-building lesson will expect to see.',
        keyTakeaway:
            'Start pushing every project from this roadmap to GitHub starting today, not just at the end — by Level 10, you will have an entire portfolio of real, dated, version-controlled LLM projects instead of scrambling to build one from scratch.',
        codeSnippet:
            '# Connect a local repo to GitHub and push it\ngit remote add origin https://github.com/yourname/llm-basics.git\ngit branch -M main\ngit push -u origin main',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why is Git especially valuable for LLM engineering projects specifically, beyond general software development?',
        options: [
          'Git is not actually useful for LLM projects',
          'A single change to a prompt template or model configuration can dramatically shift LLM behavior — Git lets you track exactly what changed and revert if a change causes unexpected or worse results',
          'Git is required by all LLM APIs to function at all',
          'Git can only track changes to Python code, not text files like prompts'
        ],
        correctIndex: 1,
        explanation:
            'Because prompt wording and configuration changes directly and often unpredictably affect LLM output quality, Git\'s ability to track exactly what changed and revert to prior states is especially valuable for debugging and iterating on LLM systems.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the relationship between Git and GitHub?',
        options: [
          'They are exactly the same tool with two different names',
          'Git is the version control tool that tracks changes locally, while GitHub is a cloud platform for hosting Git repositories online, enabling backup, sharing, and collaboration',
          'GitHub is required to use Git at all, even locally',
          'Git is only used for LLM projects, while GitHub is used for all other programming'
        ],
        correctIndex: 1,
        explanation:
            'Git is the underlying version control system (works entirely locally if needed). GitHub is a separate cloud service that hosts Git repositories online, adding backup, sharing, and collaboration features on top of Git.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You just finished improving a prompt template and want to save this change with a description before continuing. Which sequence of commands is correct?',
        options: [
          'git push, then git commit',
          'git add prompt_templates.py, then git commit -m "description of the change"',
          'git init only, with no further steps needed',
          'git remote add origin, then git init'
        ],
        correctIndex: 1,
        explanation:
            'The standard local workflow is: stage the specific changed file with git add, then save a described checkpoint with git commit -m "...". Pushing to GitHub (git push) is a separate, later step for syncing to the cloud.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Create and Push Your First LLM Engineering Repository',
      goal:
          'Set up your first real Git repository and GitHub project, establishing the version-control habit you will use for every project throughout this entire 10-level roadmap.',
      steps: [
        'Create a new folder called "llm-engineer-journey" and run git init inside it',
        'Create a simple README.md file describing your goal: becoming an LLM Engineer, and listing the 10 levels of this roadmap',
        'Stage and commit the README with a clear commit message',
        'Create a GitHub account (if you do not have one) and create a new empty repository',
        'Connect your local repository to GitHub using git remote add origin, then push your first commit using git push',
        'Confirm your README.md is visible on your GitHub repository page',
      ],
      expectedOutput:
          'git log output:\ncommit a1b2c3d - "Initial commit: LLM Engineer journey README"\n\nGitHub repository "llm-engineer-journey" is live and publicly visible, containing your README.md file — the first entry in your future professional portfolio.',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'ai_llm_dev_tools_l1',
    topicTitle: 'Introduction to AI/LLM Development Tools',
    careerId: 'llm_engineer',
    categoryId: 'ai_data',
    difficulty: 'Beginner',
    estimatedMinutes: 25,
    totalXp: 125,
    emoji: '🧰',
    intro:
        'This final Level 1 lesson gives you a guided map of the entire LLM development toolchain you will use across Levels 2-10 — so every new tool you encounter later feels like a recognizable piece of a whole picture, not a random surprise.',
    concepts: [
      ConceptLesson(
        title: 'The Core LLM Development Toolchain',
        definition:
            'The LLM Engineer toolchain spans several categories: development environments (Jupyter/Colab), deep learning frameworks (PyTorch), model libraries (Hugging Face Transformers), orchestration frameworks (LangChain), and provider APIs (OpenAI, Anthropic) — each solving a distinct part of the LLM engineering workflow.',
        analogy:
            'The LLM toolchain is like a professional kitchen\'s full equipment set — the stove (development environment) is where you actually cook, the specialized appliances (PyTorch, Transformers) handle specific complex tasks efficiently, and the delivery system (APIs) gets the finished dish to the customer. You do not need every tool for every dish, but you need to know what each one is for.',
        example:
            'A typical LLM project touches multiple tools: Google Colab or Jupyter (write and run code) → PyTorch (train/fine-tune, Level 4 & 7) → Hugging Face Transformers (load pretrained models, Level 6) → LangChain (orchestrate RAG pipelines, Level 8) → an LLM provider API like OpenAI (generate final responses, Level 7+).',
        keyTakeaway:
            'You do not need to master every tool today — you need a mental map of what each one is FOR, so when Level 6 introduces Hugging Face or Level 8 introduces LangChain, you immediately understand where it fits in the bigger picture.',
      ),
      ConceptLesson(
        title: 'Where Each Tool Fits in Your 10-Level Journey',
        definition:
            'This roadmap deliberately introduces tools in the order you will actually need them: general Python tools now (Level 1), NumPy/Pandas for math and data (Levels 2-3), PyTorch for deep learning (Level 4), Hugging Face for transformers and pretrained models (Levels 5-7), and LangChain plus vector databases for RAG and agents (Levels 8-9).',
        analogy:
            'Learning tools in this deliberate sequence is like a medical student\'s training — you do not hand a first-year student a scalpel on day one; you build anatomy knowledge first, then basic clinical skills, and only introduce surgical tools once the foundation genuinely supports using them safely and effectively.',
        example:
            'If you tried to use LangChain (Level 8) today without understanding what an LLM actually is (this level) or how transformers work (Level 6), you would be copy-pasting code you do not understand — exactly the shallow, fragile knowledge this carefully sequenced roadmap is designed to prevent.',
        keyTakeaway:
            'Trust the sequencing of this roadmap — every tool is introduced exactly when you have the foundation to genuinely understand what it is doing and why, rather than treating it as a black box to memorize commands for.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the main purpose of understanding the overall LLM toolchain map at the end of Level 1, before diving into specific tools later?',
        options: [
          'To memorize every specific command for every tool immediately',
          'To build a mental map of what each category of tool is FOR, so that when specific tools (Hugging Face, LangChain) are introduced in later levels, you already understand where they fit into the bigger picture',
          'This lesson has no real value or purpose',
          'To install every single tool in the entire toolchain right now, in Level 1'
        ],
        correctIndex: 1,
        explanation:
            'This lesson deliberately builds a conceptual map rather than deep tool-specific skill — so that later, when Levels 6-9 introduce Hugging Face, LangChain, and vector databases in depth, you already understand their role in the overall workflow.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why does this roadmap introduce PyTorch (Level 4) before Hugging Face Transformers (Levels 5-7), rather than the reverse order?',
        options: [
          'The order is completely arbitrary and does not matter at all',
          'PyTorch teaches the foundational deep learning mechanics that Hugging Face Transformers is built on top of — understanding the foundation first prevents Hugging Face from feeling like an unexplainable black box',
          'PyTorch and Hugging Face Transformers are actually unrelated tools with no connection',
          'Hugging Face Transformers does not require any deep learning knowledge at all'
        ],
        correctIndex: 1,
        explanation:
            'Hugging Face Transformers is built on top of PyTorch (or TensorFlow) — genuinely understanding what is happening underneath Hugging Face\'s convenient interfaces requires the deep learning foundation that Level 4 provides first.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A beginner wants to skip straight to Level 8 (RAG with LangChain) because it sounds like the most exciting, product-ready skill. What is the best advice based on this lesson?',
        options: [
          'Great idea — LangChain requires no prior knowledge and can be learned in complete isolation',
          'Build through the roadmap in order — LangChain in Level 8 assumes genuine understanding of LLMs, embeddings, and transformers from earlier levels, without which you would be copy-pasting code you cannot debug or extend',
          'LangChain has no relationship to any of the earlier levels in this roadmap',
          'Tools should always be learned in a completely random, unstructured order'
        ],
        correctIndex: 1,
        explanation:
            'LangChain and RAG pipelines assume genuine understanding of LLMs, embeddings, and how models process text — knowledge built specifically in Levels 5-7. Skipping ahead produces shallow, unreliable understanding that breaks the moment something needs debugging.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Level 1 Capstone: My LLM Toolchain Map',
      goal:
          'Complete Level 1 by building a personal reference map of the entire LLM development toolchain across this roadmap, tying together everything learned across all 15 lessons in this level.',
      steps: [
        'Create a table with 3 columns: Tool/Library Name, What It Is Used For, and Which Level of This Roadmap Introduces It (based on this lesson\'s descriptions)',
        'Fill in at least 6 rows covering: Python/Colab, NumPy/Pandas, PyTorch, Hugging Face Transformers, LangChain, and an LLM Provider API (OpenAI/Anthropic)',
        'Write a short paragraph (4-5 sentences) summarizing what you personally learned across ALL of Level 1 — from "What is an LLM" through Git basics — in your own words',
        'Push this file to the GitHub repository you created in the previous lesson, as a new file called level1_toolchain_map.md',
        'Write one sentence stating which Level 1 topic you feel most confident about, and one sentence stating which topic you want to revisit before moving to Level 2',
      ],
      expectedOutput:
          '=== LEVEL 1 CAPSTONE: LLM TOOLCHAIN MAP ===\n\nTool | Purpose | Introduced In\nPython/Colab | Write and run all code | Level 1\nPyTorch | Deep learning framework | Level 4\nHugging Face Transformers | Load/use pretrained models | Levels 5-7\nLangChain | Orchestrate RAG/agent pipelines | Level 8\n\nPersonal summary: [4-5 sentences]\nMost confident in: [topic]\nWant to revisit: [topic]\n\n=== LEVEL 1 COMPLETE — PYTHON & PROGRAMMING FOUNDATIONS MASTERED ===\nLevel 2: Mathematics for AI begins next.',
      xpReward: 60,
    ),
  ),
];
