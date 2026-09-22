import '../models/course_content_data.dart';
import 'course_generator_service.dart';

// ══════════════════════════════════════════════════════════════════════
//              ai_course_service.dart
// Deterministic topic knowledge base.
//
// No AI/API calls — this is a hand-written, offline lookup table of real
// explanations/analogies/examples/quiz facts for common topics that show
// up across the app's career paths (software, AI/data, cloud/devops,
// security, design, emerging tech, testing, specialized/architecture).
//
// Matching is by whole-word/phrase (case-insensitive) containment against
// the topic name a level actually asks for, so "Arrays & Strings" matches
// both the `array` and `string` entries, "Docker & Containerisation"
// matches `docker`, etc. Topics that don't match anything still get a
// meaningfully upgraded, topic-and-career-named fallback (see
// _fallbackKnowledge) rather than the old fully generic text — so this
// never breaks for the hundreds of topic strings across every career
// file, it just degrades gracefully in quality for ones we don't have a
// hand-written entry for.
// ══════════════════════════════════════════════════════════════════════

class _TopicKnowledge {
  final String definition;
  final String analogy;
  final String example;
  final String keyTakeaway;

  /// A single real technical fact used to build a topic-specific quiz
  /// question with a genuine correct answer (not a placeholder).
  final String quizQuestion;
  final List<String> quizOptions; // index 0 is always correct
  final String quizExplanation;

  /// True if this topic is something you'd typically practise by writing
  /// code / following exact steps (→ coding-style challenge phrasing).
  /// False if it's a concept you'd apply through judgement in a scenario
  /// (→ scenario-style challenge phrasing).
  final bool isHandsOn;

  const _TopicKnowledge({
    required this.definition,
    required this.analogy,
    required this.example,
    required this.keyTakeaway,
    required this.quizQuestion,
    required this.quizOptions,
    required this.quizExplanation,
    required this.isHandsOn,
  });
}

final Map<String, _TopicKnowledge> _knowledgeBase = {
  'array': const _TopicKnowledge(
    definition:
        'An array is an ordered collection of items stored so each one can be accessed instantly by its position (index).',
    analogy:
        'An array is like a row of numbered lockers — if you know the locker number, you can open it directly without checking every other one first.',
    example:
        'Storing a list of user scores as scores[0], scores[1], scores[2]... so you can jump straight to any score.',
    keyTakeaway:
        'Reading an array element by index is instant (O(1)); searching for a value you don\'t know the position of still means checking items one by one.',
    quizQuestion: 'Why are arrays fast to read from by index?',
    quizOptions: [
      'Elements sit at predictable memory positions, so the computer can jump straight to any index',
      'Arrays automatically sort themselves',
      'Arrays store data as text, which is always fast',
      'Arrays delete unused elements automatically',
    ],
    quizExplanation:
        'Because array elements are laid out in order, the position of any index can be calculated directly — no searching required.',
    isHandsOn: true,
  ),
  'string': const _TopicKnowledge(
    definition:
        'A string is a sequence of characters — the data type used to represent text.',
    analogy:
        'A string is like a string of beads, where each bead is one character, threaded in a fixed order.',
    example:
        'The text "hello" is a string of 5 characters that a program can search, split, or combine with other strings.',
    keyTakeaway:
        'Strings are usually immutable in modern languages — operations like "changing" a string actually create a new one.',
    quizQuestion: 'What happens when you "modify" a string in most languages?',
    quizOptions: [
      'A new string is created — the original is left unchanged',
      'The original string is overwritten in place',
      'The string is deleted',
      'Nothing happens until the program restarts',
    ],
    quizExplanation:
        'Strings are typically immutable, so any "change" (like concatenation) actually produces a brand-new string in memory.',
    isHandsOn: true,
  ),
  'loop': const _TopicKnowledge(
    definition:
        'A loop repeats a block of code multiple times without you writing it out repeatedly.',
    analogy:
        'A loop is like telling someone "knock on every door on this street" instead of naming each door individually.',
    example:
        'A for-loop that prints "Hello" to each of 100 guests, one at a time, using a single line of code.',
    keyTakeaway:
        'Use a for-loop when you know how many times to repeat; use a while-loop when you repeat until a condition becomes false.',
    quizQuestion: 'When should you prefer a while-loop over a for-loop?',
    quizOptions: [
      'When the number of repetitions isn\'t known in advance and depends on a condition',
      'When you always know exactly how many times to repeat',
      'When you never want the loop to run',
      'Loops are interchangeable and it never matters',
    ],
    quizExplanation:
        'While-loops are built around a condition, making them the right tool when the repeat count isn\'t fixed ahead of time.',
    isHandsOn: true,
  ),
  'function': const _TopicKnowledge(
    definition:
        'A function is a named, reusable block of code that performs one specific task and can be called wherever it\'s needed.',
    analogy:
        'A function is like a recipe: write it once, then anyone can follow it (call it) as many times as they like.',
    example:
        'A calculateTax(income) function that any part of a program can call instead of re-writing the tax formula each time.',
    keyTakeaway:
        'If you find yourself writing the same logic twice, it belongs in a function — this is the "Don\'t Repeat Yourself" principle.',
    quizQuestion: 'What is the main benefit of putting repeated logic into a function?',
    quizOptions: [
      'It avoids duplicating code and makes the logic easier to fix in one place',
      'It makes the program run on a different computer',
      'It automatically fixes bugs',
      'It deletes unused variables',
    ],
    quizExplanation:
        'Functions centralise logic — fixing a bug in one function fixes it everywhere that function is called.',
    isHandsOn: true,
  ),
  'object-oriented': const _TopicKnowledge(
    definition:
        'Object-oriented programming (OOP) organises code around "objects" that bundle data and the behaviour that acts on that data.',
    analogy:
        'A class is a blueprint (like a car design); an object is an actual car built from that blueprint — each with its own colour, speed, and fuel level, but built the same way.',
    example:
        'A User class with a name and email, plus a sendWelcomeEmail() method that only makes sense for a User.',
    keyTakeaway:
        'Encapsulation (bundling data with behaviour) and inheritance (reusing a class\'s behaviour in a more specific class) are the two ideas to master first.',
    quizQuestion: 'What is the difference between a class and an object?',
    quizOptions: [
      'A class is the blueprint; an object is a specific instance created from it',
      'They are exactly the same thing with two names',
      'A class can only ever create one object',
      'An object is written before the class that defines it',
    ],
    quizExplanation:
        'A class defines the structure/behaviour; each object is a separate instance following that structure.',
    isHandsOn: true,
  ),
  'api': const _TopicKnowledge(
    definition:
        'An API (Application Programming Interface) is a defined way for one piece of software to request data or actions from another.',
    analogy:
        'An API is like a restaurant menu: you don\'t need to know how the kitchen works, you just order from the menu and get a result back.',
    example:
        'A weather app calling a weather API and getting back today\'s temperature as structured data (JSON), without knowing how that data was collected.',
    keyTakeaway:
        'A good API hides internal complexity behind a simple, stable contract — the caller only needs to know the inputs and outputs.',
    quizQuestion: 'What is the main purpose of an API?',
    quizOptions: [
      'To let one piece of software request data/actions from another through a defined contract',
      'To make a program\'s source code publicly visible',
      'To permanently store user data',
      'To design a user interface',
    ],
    quizExplanation:
        'An API is a contract for communication between systems — it defines what you can ask for and what you get back.',
    isHandsOn: true,
  ),
  'sql': const _TopicKnowledge(
    definition:
        'SQL (Structured Query Language) is the standard language for reading and writing data stored in a relational database.',
    analogy:
        'SQL is like asking a very literal librarian very specific questions: "get me every book by this author published after 2020" — and getting exactly that back.',
    example:
        'SELECT name, email FROM users WHERE signup_date > \'2024-01-01\' returns exactly the matching rows.',
    keyTakeaway:
        'Master SELECT, WHERE, JOIN, and GROUP BY first — together they cover the majority of real-world querying needs.',
    quizQuestion: 'Which SQL clause is used to combine rows from two related tables?',
    quizOptions: ['JOIN', 'DELETE', 'PRINT', 'IMPORT'],
    quizExplanation:
        'JOIN combines rows from two or more tables based on a related column between them.',
    isHandsOn: true,
  ),
  'git': const _TopicKnowledge(
    definition:
        'Git is a version control system that tracks changes to code over time, letting multiple people work on the same project safely.',
    analogy:
        'Git is like a save-game system for your codebase — you can always go back to an earlier "save point" if something breaks.',
    example:
        'git commit -m "fix login bug" saves a snapshot of the current changes with a message explaining what changed.',
    keyTakeaway:
        'Commit small, working changes often, and write commit messages that explain WHY, not just WHAT, changed.',
    quizQuestion: 'What does a Git commit actually do?',
    quizOptions: [
      'Saves a labelled snapshot of the current changes to the project history',
      'Permanently deletes old versions of the code',
      'Publishes the code to the public internet',
      'Automatically fixes bugs in the code',
    ],
    quizExplanation:
        'A commit records a snapshot of the tracked changes at that point in time, which you can always return to later.',
    isHandsOn: true,
  ),
  'docker': const _TopicKnowledge(
    definition:
        'Docker packages an application together with everything it needs to run into a standardised, portable unit called a container.',
    analogy:
        'A Docker container is like a shipping container: it fits on any ship, truck, or crane, regardless of what\'s inside — solving "it works on my machine".',
    example:
        'A Dockerfile that installs Python, copies your code, and runs it — producing an image that behaves identically on your laptop and on a server.',
    keyTakeaway:
        'A Docker IMAGE is a static blueprint; a CONTAINER is a running instance of that image — you can run many containers from one image.',
    quizQuestion: 'What is the difference between a Docker image and a Docker container?',
    quizOptions: [
      'An image is a static blueprint; a container is a running instance of it',
      'They are identical, just different names for the same thing',
      'A container is stored on disk and an image only exists in memory',
      'An image can only ever produce one container',
    ],
    quizExplanation:
        'Images are immutable snapshots. Containers are the live, running processes started from an image — you can run several at once.',
    isHandsOn: true,
  ),
  'kubernetes': const _TopicKnowledge(
    definition:
        'Kubernetes automatically deploys, scales, and manages containerised applications across a cluster of machines.',
    analogy:
        'If Docker packs the shipping containers, Kubernetes is the port that decides which ship each container goes on, replaces damaged ones automatically, and adds more ships when traffic spikes.',
    example:
        'Kubernetes automatically restarting a crashed container, and spinning up 3 more copies of a service when traffic triples.',
    keyTakeaway:
        'Kubernetes\' core job is keeping the "actual state" of your running app matching the "desired state" you declared — automatically.',
    quizQuestion: 'What is Kubernetes primarily responsible for?',
    quizOptions: [
      'Automatically deploying, scaling, and healing containerised applications across machines',
      'Compiling source code into an executable',
      'Replacing the need for version control',
      'Designing user interfaces',
    ],
    quizExplanation:
        'Kubernetes is a container orchestrator — it keeps your running containers matching the state you declared, automatically.',
    isHandsOn: true,
  ),
  'neural network': const _TopicKnowledge(
    definition:
        'A neural network is a model made of layers of connected "neurons" that learn to map inputs to outputs by adjusting connection weights during training.',
    analogy:
        'A neural network is like a committee of simple voters: each one makes a small, weighted judgement, and their combined votes produce a surprisingly sophisticated decision.',
    example:
        'A neural network trained on labelled images learns to output "cat" or "dog" for a new, unseen photo.',
    keyTakeaway:
        'Training adjusts the weights between neurons to reduce prediction error — this is what "learning" means in a neural network.',
    quizQuestion: 'What does "training" a neural network actually change?',
    quizOptions: [
      'The weights of the connections between neurons, to reduce prediction error',
      'The programming language the network is written in',
      'The number of users of the app',
      'The colour of the output',
    ],
    quizExplanation:
        'Training repeatedly nudges connection weights in the direction that reduces error on the training data.',
    isHandsOn: true,
  ),
  'machine learning': const _TopicKnowledge(
    definition:
        'Machine learning is a way of building systems that find patterns in data and improve at a task without being explicitly programmed with rules for every case.',
    analogy:
        'Instead of writing 1,000 explicit rules for "what is spam", you show the system 100,000 labelled examples and let it work out the pattern itself.',
    example:
        'A model trained on past house prices learns to estimate the price of a new house it has never seen.',
    keyTakeaway:
        'The quality and quantity of training data usually matters more than the specific algorithm chosen.',
    quizQuestion: 'What is "overfitting" in machine learning?',
    quizOptions: [
      'A model performs very well on training data but poorly on new, unseen data',
      'A model trains too quickly',
      'A model uses too little data by design',
      'A model that only works offline',
    ],
    quizExplanation:
        'Overfitting means the model memorised the training data\'s noise instead of learning patterns that generalise to new data.',
    isHandsOn: true,
  ),
  'regression': const _TopicKnowledge(
    definition:
        'Regression is a machine learning technique used to predict a continuous numeric value, such as a price or a temperature.',
    analogy:
        'Regression is like drawing the best-fitting line through a scatter of points, so you can estimate a new point\'s value based on where it would sit on that line.',
    example:
        'Predicting a house\'s price (a number) from its size and location using linear regression.',
    keyTakeaway:
        'Use regression when the output is a number on a continuous scale; use classification when the output is a category.',
    quizQuestion: 'When should you use regression instead of classification?',
    quizOptions: [
      'When predicting a continuous numeric value, like a price',
      'When predicting one of a fixed set of categories',
      'When there is no data available at all',
      'Regression and classification are always interchangeable',
    ],
    quizExplanation:
        'Regression outputs a number on a continuous scale; classification outputs a category from a fixed set.',
    isHandsOn: true,
  ),
  'classification': const _TopicKnowledge(
    definition:
        'Classification is a machine learning technique used to predict which category (class) something belongs to.',
    analogy:
        'Classification is like sorting mail into labelled bins — each new letter gets assigned to exactly one bin based on its features.',
    example:
        'A model that reads an email and classifies it as "spam" or "not spam".',
    keyTakeaway:
        'Accuracy alone can be misleading for imbalanced data — a model that always guesses the majority class can still score high accuracy while being useless.',
    quizQuestion: 'Why can accuracy be a misleading metric for classification?',
    quizOptions: [
      'On imbalanced data, always predicting the majority class can still score high accuracy while catching none of the minority class',
      'Accuracy can never be calculated for classification models',
      'Accuracy always equals 100% for correctly trained models',
      'Accuracy only applies to regression, not classification',
    ],
    quizExplanation:
        'If 99% of cases are one class, always predicting that class gives 99% accuracy while completely missing the other class.',
    isHandsOn: true,
  ),
  'natural language': const _TopicKnowledge(
    definition:
        'Natural Language Processing (NLP) is the field of building systems that understand, generate, or work with human language.',
    analogy:
        'NLP is like teaching a computer to read between the lines of a conversation, not just match keywords.',
    example:
        'An NLP model that reads a product review and determines whether the sentiment is positive or negative.',
    keyTakeaway:
        'Modern NLP is dominated by transformer-based models that read entire sentences at once rather than word-by-word.',
    quizQuestion: 'What architecture underlies most modern NLP models like BERT and GPT?',
    quizOptions: ['Transformers', 'Decision trees', 'Spreadsheets', 'Regular expressions only'],
    quizExplanation:
        'Transformers use an attention mechanism to weigh the relevance of every word in a sentence to every other word.',
    isHandsOn: true,
  ),
  'llm': const _TopicKnowledge(
    definition:
        'A Large Language Model (LLM) is a neural network trained on huge amounts of text to predict and generate human-like language.',
    analogy:
        'An LLM is like an extremely well-read assistant who has seen an enormous number of examples of how sentences tend to continue, and uses that pattern to write the next most likely words.',
    example:
        'An LLM completing "The capital of France is" with "Paris" based on patterns learned from its training data.',
    keyTakeaway:
        'LLMs predict text statistically — they don\'t "know" facts the way a database does, which is why they can confidently produce incorrect answers.',
    quizQuestion: 'Why can an LLM confidently produce an incorrect answer?',
    quizOptions: [
      'It generates the statistically most likely next words, not verified facts from a database',
      'It always checks the internet before responding',
      'It refuses to answer anything uncertain',
      'It only produces pre-written template answers',
    ],
    quizExplanation:
        'LLMs generate text based on learned statistical patterns, not a lookup of verified facts, so confident-sounding errors ("hallucinations") can occur.',
    isHandsOn: true,
  ),
  'prompt engineering': const _TopicKnowledge(
    definition:
        'Prompt engineering is the practice of designing the input you give an AI model to reliably get the output you want.',
    analogy:
        'A prompt is like a set of instructions to a new employee: vague instructions get vague results, but clear, specific instructions with examples get consistent, high-quality work.',
    example:
        'Adding "respond only in valid JSON with keys: name, age" to a prompt to reliably get structured output instead of free text.',
    keyTakeaway:
        'Being specific, giving examples (few-shot prompting), and asking the model to reason step by step all measurably improve output quality.',
    quizQuestion: 'What is "few-shot prompting"?',
    quizOptions: [
      'Including a few examples of the desired input/output pattern directly in the prompt',
      'Asking the model the same question multiple times',
      'Limiting the model to very short responses only',
      'Disabling the model\'s ability to reason',
    ],
    quizExplanation:
        'Few-shot prompting shows the model a handful of examples so it can infer the pattern you want it to follow.',
    isHandsOn: true,
  ),
  'retrieval': const _TopicKnowledge(
    definition:
        'Retrieval-Augmented Generation (RAG) combines a search step (retrieving relevant documents) with an AI model generating an answer grounded in those documents.',
    analogy:
        'RAG is like an open-book exam: instead of relying purely on memory, the model is handed the most relevant pages first, then asked to answer using them.',
    example:
        'A support chatbot that first searches your company\'s docs for the relevant policy, then answers the user\'s question using that exact policy text.',
    keyTakeaway:
        'RAG reduces made-up answers by grounding generation in real retrieved sources, and lets you update knowledge without retraining the model.',
    quizQuestion: 'What problem does RAG primarily help reduce?',
    quizOptions: [
      'The model inventing plausible-sounding but incorrect answers ("hallucination")',
      'Slow internet connections',
      'The need for any training data at all',
      'The cost of storing images',
    ],
    quizExplanation:
        'By grounding the model\'s answer in retrieved, relevant source documents, RAG reduces reliance on the model\'s possibly-wrong internal memory.',
    isHandsOn: true,
  ),
  'authentication': const _TopicKnowledge(
    definition:
        'Authentication is the process of verifying that someone is who they claim to be, typically before granting access.',
    analogy:
        'Authentication is like showing ID at the door — it proves who you are, but doesn\'t yet decide what rooms you\'re allowed into (that\'s authorization).',
    example:
        'A login form checking a password, or an app checking a valid session token before letting a request through.',
    keyTakeaway:
        'Authentication ("who are you?") and authorization ("what are you allowed to do?") are different steps — mixing them up is a common security mistake.',
    quizQuestion: 'What is the difference between authentication and authorization?',
    quizOptions: [
      'Authentication verifies identity; authorization decides what that identity is allowed to do',
      'They are the exact same process with two names',
      'Authorization always happens before authentication',
      'Authentication only applies to databases',
    ],
    quizExplanation:
        'Authentication confirms identity first; authorization then checks the permissions tied to that identity.',
    isHandsOn: true,
  ),
  'encryption': const _TopicKnowledge(
    definition:
        'Encryption scrambles data using a key so that only someone with the correct key can read it.',
    analogy:
        'Encryption is like locking a message in a box that only opens with the right key — anyone can see the box, but only the key holder can read what\'s inside.',
    example:
        'HTTPS encrypts traffic between your browser and a website so it can\'t be read by anyone intercepting the connection.',
    keyTakeaway:
        'Encryption protects data confidentiality; it doesn\'t by itself guarantee the data hasn\'t been tampered with — that requires integrity checks too.',
    quizQuestion: 'What does encryption primarily protect?',
    quizOptions: [
      'The confidentiality of data, so only someone with the right key can read it',
      'The speed of a network connection',
      'The amount of storage space used',
      'The visual design of an application',
    ],
    quizExplanation:
        'Encryption is about confidentiality — making data unreadable without the correct decryption key.',
    isHandsOn: true,
  ),
  'network': const _TopicKnowledge(
    definition:
        'Networking is the set of technologies and protocols that let computers communicate and exchange data with each other.',
    analogy:
        'A network is like a postal system — IP addresses are addresses, and protocols like TCP are the rules for how a package is packed, sent, and confirmed as delivered.',
    example:
        'Visiting a website: DNS resolves the domain to an IP address, then TCP reliably delivers the page data to your browser.',
    keyTakeaway:
        'TCP guarantees reliable, ordered delivery (slower); UDP is faster but doesn\'t guarantee delivery — the right choice depends on what you\'re building.',
    quizQuestion: 'What is the key trade-off between TCP and UDP?',
    quizOptions: [
      'TCP guarantees reliable, ordered delivery at the cost of speed; UDP is faster but not guaranteed',
      'TCP and UDP are identical in every way',
      'UDP always requires more setup than TCP',
      'TCP only works over Wi-Fi',
    ],
    quizExplanation:
        'TCP\'s handshake and acknowledgements make it reliable but slower; UDP skips that overhead for speed at the cost of guarantees.',
    isHandsOn: true,
  ),
  'unit test': const _TopicKnowledge(
    definition:
        'A unit test checks that one small piece of code (usually a single function) behaves correctly in isolation.',
    analogy:
        'Unit testing is like quality-checking each individual brick before building a wall, instead of only checking the finished wall and hoping it holds.',
    example:
        'A test asserting that add(2, 3) returns 5, run automatically every time the code changes.',
    keyTakeaway:
        'Good unit tests cover the happy path, edge cases (empty/zero/negative), and expected failures — not just the obvious case.',
    quizQuestion: 'What should a thorough set of unit tests cover?',
    quizOptions: [
      'The happy path, edge cases, and expected failure cases',
      'Only the case where everything works perfectly',
      'Only how the whole application looks visually',
      'Only the deployment process',
    ],
    quizExplanation:
        'Thorough tests include normal inputs, boundary/edge cases, and inputs expected to correctly trigger an error.',
    isHandsOn: true,
  ),
  'user experience': const _TopicKnowledge(
    definition:
        'User Experience (UX) design is the practice of shaping how a product feels to use — how easily people can achieve their goals with it.',
    analogy:
        'UX is the difference between a hospital where you instantly find the right department, and one where you wander confused for 20 minutes — the treatment might be identical, but the experience isn\'t.',
    example:
        'Removing 5 unnecessary fields from a checkout form and watching form completions go up.',
    keyTakeaway:
        'Most UX problems come from asking users to do or decide more than necessary — reducing friction usually beats adding features.',
    quizQuestion: 'What does Hick\'s Law predict happens when you add more choices?',
    quizOptions: [
      'Decision time increases — more options make choosing slower',
      'Users always decide faster with more options',
      'The number of choices has no effect on decision time',
      'Users stop making decisions entirely',
    ],
    quizExplanation:
        'Hick\'s Law states decision time grows (roughly logarithmically) as the number of choices increases.',
    isHandsOn: false,
  ),
  'user interface': const _TopicKnowledge(
    definition:
        'User Interface (UI) design is the visual and interactive layer of a product — the actual screens, buttons, and layout users touch.',
    analogy:
        'If UX is the floor plan of a house, UI is the paint, fixtures, and furniture — both matter, but they\'re different jobs.',
    example:
        'Choosing a consistent button style, spacing, and colour system so the whole app feels like one coherent product.',
    keyTakeaway:
        'Consistency (the same action always looks and behaves the same way) reduces the mental effort needed to use an interface.',
    quizQuestion: 'Why does visual consistency across a UI matter?',
    quizOptions: [
      'It reduces the mental effort users need to relearn patterns on every screen',
      'It has no effect on usability',
      'It only matters for accessibility, not general users',
      'It slows down development for no benefit',
    ],
    quizExplanation:
        'Consistent patterns let users transfer what they learned on one screen to the next, lowering cognitive load.',
    isHandsOn: false,
  ),
  'blockchain': const _TopicKnowledge(
    definition:
        'A blockchain is a shared, append-only ledger replicated across many computers, where each block is cryptographically linked to the one before it.',
    analogy:
        'A blockchain is like a shared notebook where every page includes a fingerprint of the previous page — tearing out or changing an old page instantly breaks every fingerprint after it.',
    example:
        'A cryptocurrency transaction that, once confirmed in a block, becomes extremely costly to alter or reverse.',
    keyTakeaway:
        'Immutability comes from chaining cryptographic hashes — changing any historical block invalidates every block after it.',
    quizQuestion: 'What makes blockchain data resistant to tampering?',
    quizOptions: [
      'Each block includes a hash of the previous block, so altering history breaks every block after it',
      'Blockchain data is stored on a single trusted server',
      'Blockchain uses stronger passwords than normal databases',
      'Only administrators are allowed to view blockchain data',
    ],
    quizExplanation:
        'Because each block\'s hash depends on the previous block, changing old data invalidates the chain from that point forward.',
    isHandsOn: true,
  ),
  'smart contract': const _TopicKnowledge(
    definition:
        'A smart contract is code deployed on a blockchain that automatically executes its logic when predefined conditions are met.',
    analogy:
        'A smart contract is like a vending machine: insert the right input, and the machine automatically and impartially delivers the output — no cashier required.',
    example:
        'A smart contract that automatically releases payment to a seller only once a buyer confirms delivery.',
    keyTakeaway:
        'Smart contracts typically can\'t be changed after deployment — so bugs found after launch are often permanent, making careful review essential.',
    quizQuestion: 'Why is careful review especially critical before deploying a smart contract?',
    quizOptions: [
      'Deployed smart contracts usually can\'t be modified, so bugs can be permanent',
      'Smart contracts automatically fix their own bugs',
      'Smart contracts are always reviewed by a human before every execution',
      'Smart contracts can be freely edited at any time after deployment',
    ],
    quizExplanation:
        'Because most smart contracts are immutable once deployed, an undiscovered bug can\'t simply be patched — it may be permanent.',
    isHandsOn: true,
  ),
  'agile': const _TopicKnowledge(
    definition:
        'Agile is an approach to building software in small, iterative cycles with frequent feedback, instead of one long upfront plan.',
    analogy:
        'Agile is like sculpting with clay and constantly stepping back to check the shape, instead of designing the entire statue on paper before touching any clay.',
    example:
        'A team shipping a small working feature every two weeks and adjusting the plan based on real user feedback.',
    keyTakeaway:
        'The core idea is short feedback loops — the sooner you learn something is wrong, the cheaper it is to fix.',
    quizQuestion: 'What is the core benefit of Agile\'s short iteration cycles?',
    quizOptions: [
      'Problems and wrong assumptions get caught and fixed early, when they\'re cheap',
      'It guarantees the project needs no planning at all',
      'It removes the need for any testing',
      'It means requirements never change',
    ],
    quizExplanation:
        'Short cycles create frequent feedback, so mistakes or bad assumptions surface (and get fixed) early rather than late.',
    isHandsOn: false,
  ),
  'architecture': const _TopicKnowledge(
    definition:
        'Software/system architecture is the set of high-level decisions about how a system\'s major components are structured and interact.',
    analogy:
        'Architecture is like a city planner\'s decisions about roads and zoning — individual buildings (features) come later, but the layout decided now shapes everything built on top of it for years.',
    example:
        'Deciding to split a monolithic app into separate services so different teams can deploy independently without blocking each other.',
    keyTakeaway:
        'Architecture decisions are expensive to reverse — the goal is usually to optimise for the ability to change later, not just to solve today\'s problem.',
    quizQuestion: 'What should good architecture decisions primarily optimise for?',
    quizOptions: [
      'The system\'s ability to evolve and change over time, not just today\'s requirements',
      'Using the newest technology available regardless of fit',
      'Making every decision permanent and unchangeable',
      'Minimising the number of engineers involved',
    ],
    quizExplanation:
        'Because architecture is costly to reverse, strong architects weigh how easily the system can adapt to future, unknown requirements.',
    isHandsOn: false,
  ),
  'continuous integration': const _TopicKnowledge(
    definition:
        'Continuous Integration (CI) is the practice of automatically building and testing code every time it changes, to catch problems immediately.',
    analogy:
        'CI is like a smoke alarm that checks constantly rather than once a year — problems are caught within minutes, not months later.',
    example:
        'A pull request that automatically runs the full test suite before it\'s allowed to be merged.',
    keyTakeaway:
        'The value of CI comes from frequency — the faster feedback arrives after a change, the cheaper that change is to fix.',
    quizQuestion: 'Why does Continuous Integration reduce the cost of fixing bugs?',
    quizOptions: [
      'Tests run immediately on every change, so problems are found while the context is still fresh',
      'It removes the need to write tests at all',
      'It automatically writes new features',
      'It only runs once a year during release week',
    ],
    quizExplanation:
        'Immediate feedback means a bug is caught right after it\'s introduced, while the relevant code is still fresh in the developer\'s mind.',
    isHandsOn: true,
  ),
  'cloud': const _TopicKnowledge(
    definition:
        'Cloud computing means running applications and storing data on remote servers you rent on demand, instead of owning physical hardware.',
    analogy:
        'Cloud computing is like renting electricity from a utility company instead of building and maintaining your own power plant — you pay for what you use, and someone else handles the infrastructure.',
    example:
        'An app automatically renting more server capacity during a traffic spike, then scaling back down afterwards to save cost.',
    keyTakeaway:
        'Elasticity — the ability to scale resources up and down on demand — is the defining advantage cloud computing offers over fixed physical servers.',
    quizQuestion: 'What is "elasticity" in cloud computing?',
    quizOptions: [
      'The ability to automatically scale resources up or down based on demand',
      'The physical flexibility of server hardware',
      'A pricing model that never changes',
      'A type of network cable',
    ],
    quizExplanation:
        'Elasticity means capacity can grow or shrink automatically to match real-time demand, avoiding both overpaying and outages.',
    isHandsOn: true,
  ),
  'devops': const _TopicKnowledge(
    definition:
        'DevOps is a set of practices that bring development and operations together, automating how software is built, tested, and released.',
    analogy:
        'DevOps is like a relay race where the baton (the code) is handed off smoothly and automatically, instead of being thrown over a wall between two teams that don\'t talk to each other.',
    example:
        'An automated pipeline that tests, builds, and deploys code to production within minutes of a merge, with no manual steps.',
    keyTakeaway:
        'DevOps success is measured by how fast and how safely you can ship changes — both speed and safety, not one at the expense of the other.',
    quizQuestion: 'What does DevOps primarily aim to improve?',
    quizOptions: [
      'The speed and safety of shipping software changes',
      'The visual design of the product',
      'The number of meetings a team has',
      'The choice of programming language',
    ],
    quizExplanation:
        'DevOps practices (automation, CI/CD, monitoring) are aimed at shipping changes both faster and more reliably.',
    isHandsOn: true,
  ),
  'penetration testing': const _TopicKnowledge(
    definition:
        'Penetration testing is the authorised practice of simulating real attacks against a system to find security weaknesses before real attackers do.',
    analogy:
        'A penetration tester is like a locksmith hired to try to break into your own house, so you can fix the weak locks before a real burglar finds them.',
    example:
        'A tester attempting SQL injection on a login form to check whether attacker-supplied input can manipulate the database query.',
    keyTakeaway:
        'Penetration testing must always be explicitly authorised — the exact same actions without permission are illegal, regardless of intent.',
    quizQuestion: 'What legally separates penetration testing from hacking?',
    quizOptions: [
      'Explicit authorisation from the system\'s owner before testing begins',
      'The tools used are different',
      'Penetration testers never find real vulnerabilities',
      'Penetration testing is always done anonymously',
    ],
    quizExplanation:
        'The techniques can be identical — what makes it legal penetration testing is documented, prior authorisation from the owner.',
    isHandsOn: true,
  ),
};

/// Looks up the best-matching knowledge entry for [topic] using
/// whole-word/phrase matching (case-insensitive) so short keys like "api"
/// or "git" don't false-positive match inside unrelated words. Longer
/// keys are checked first so more specific entries win over broader ones
/// (e.g. "neural network" over a hypothetical shorter "network" match).
_TopicKnowledge? _lookupKnowledge(String topic) {
  final sortedKeys = _knowledgeBase.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  for (final key in sortedKeys) {
    final pattern = RegExp(r'\b' + RegExp.escape(key) + r'\b', caseSensitive: false);
    if (pattern.hasMatch(topic)) {
      return _knowledgeBase[key];
    }
  }
  return null;
}

/// True if a topic name suggests hands-on/coding practice rather than a
/// judgement-based scenario — used only when the topic isn't in the
/// knowledge base (known topics carry their own `isHandsOn` flag).
bool _looksHandsOn(String topic) {
  final t = topic.toLowerCase();
  const handsOnHints = [
    'code', 'algorithm', 'script', 'query', 'syntax', 'function',
    'method', 'class', 'variable', 'loop', 'array', 'string',
    'python', 'java', 'sql', 'api', 'build', 'implement',
  ];
  return handsOnHints.any((h) => t.contains(h));
}


  // ============================================================
  // QUIZ OPTION ORDERING
  // ============================================================
  // The correct answer is deliberately NOT kept at index 0.
  //
  // This is deterministic rather than random:
  // - the same course inputs produce the same option order
  // - no network/API is required
  // - the answer position cannot be gamed by always tapping option 1
  // - future app rebuilds do not create unstable quiz content
  //
  // A stable hash is used so the ordering is reproducible forever for
  // the same course/question identity.
int _stableHash(String value) {
    var hash = 17;
    for (final codeUnit in value.codeUnits) {
      hash = (hash * 31 + codeUnit) & 0x7fffffff;
    }
    return hash;
  }

QuizQuestion _repositionCorrectOption(
    QuizQuestion question, {
    required String seed,
  }) {
    final original = List<String>.from(question.options);
    if (original.length <= 1) {
      return question;
    }

    final correctIndex = question.correctIndex.clamp(0, original.length - 1).toInt();
    // Force a non-zero rotation whenever there is more than one option.
    // This guarantees the original correct position is not preserved simply
    // because the hash happened to produce zero.
    final shift = 1 + (_stableHash(seed) % (original.length - 1));

    final rotated = List<String>.generate(
      original.length,
      (newIndex) => original[(newIndex - shift + original.length) % original.length],
    );

    final newCorrectIndex = (correctIndex + shift) % original.length;

    return QuizQuestion(
      question: question.question,
      options: rotated,
      correctIndex: newCorrectIndex,
      explanation: question.explanation,
      xpReward: question.xpReward,
    );
  }

class AiCourseService {
  // ============================================================
  // MOCK MODE
  // ============================================================
  //
  // Abhi API key nahi hai.
  // Isliye app offline/mock course generate karegi.
  //
  // Baad mein isi class mein backend/AI connection add hoga.
  //
  // UPGRADE: content below is now built from a deterministic, offline
  // topic-knowledge base (see top of file) instead of one-line generic
  // templates — still zero network/API calls, still fully deterministic.
  // ============================================================

  static Future<TopicCourse> generateCourse({
    required String careerId,
    required String careerTitle,
    required String categoryId,
    required int level,
    required String levelTitle,
    required List<String> topics,
    String difficulty = 'Beginner',
    // NEW: optional, defaults to null so every existing caller compiles
    // and behaves exactly as before. When the caller DOES have a record
    // of topics the user has already mastered (e.g. from
    // LearningProgressContext / prior completed levels), passing it here
    // lets this level's course skip re-teaching those as brand-new
    // concepts, without needing a second progress/course database — the
    // caller remains the single source of truth for what's "mastered".
    Set<String>? masteredTopics,
  }) async {
    // Generator ka prompt ready karo.
    //
    // Abhi API ko send nahi kar rahe.
    final prompt = CourseGeneratorService.buildCoursePrompt(
      careerId: careerId,
      careerTitle: careerTitle,
      categoryId: categoryId,
      level: level,
      levelTitle: levelTitle,
      topics: topics,
      difficulty: difficulty,
    );

    // Prompt ko use hua maana ja raha hai.
    // Future mein yahin backend/AI API call hogi.
    if (prompt.isEmpty) {
      throw Exception('Course generation prompt is empty.');
    }

    // ==========================================================
    // RESPECT LEARNING PROGRESSION (if the caller provided it)
    // ==========================================================
    //
    // Filter out topics the caller says are already mastered so this
    // level doesn't unnecessarily re-teach them from scratch. If that
    // filtering would leave nothing (e.g. the user has mastered every
    // topic in this level already), fall back to the full original list
    // so the level still has real content — framed as a refresher.
    final masteredLower =
        (masteredTopics ?? const <String>{}).map((t) => t.toLowerCase()).toSet();
    final filteredTopics = masteredLower.isEmpty
        ? topics
        : topics.where((t) => !masteredLower.contains(t.toLowerCase())).toList();
    final isRefresher = masteredLower.isNotEmpty && filteredTopics.isEmpty;
    final effectiveTopics = isRefresher ? topics : filteredTopics;

    // Topics actually used to build concepts/quiz/challenges. If a level
    // has no topics at all, fall back to the level title itself so the
    // course still has real, level-specific (if not topic-specific)
    // content rather than breaking.
    final topicsForContent =
        effectiveTopics.isNotEmpty ? effectiveTopics : [levelTitle];

    // ==========================================================
    // CONCEPTS — genuinely topic-specific where we have a knowledge
    // entry, and meaningfully career+level-specific otherwise.
    // ==========================================================

    final concepts = <ConceptLesson>[];

    for (int i = 0; i < topicsForContent.length && i < 5; i++) {
      final topic = topicsForContent[i];
      final known = _lookupKnowledge(topic);

      if (known != null) {
        concepts.add(
          ConceptLesson(
            title: topic,
            definition: known.definition,
            analogy: known.analogy,
            example:
                '${known.example} As a $careerTitle at the $levelTitle stage, you\'ll apply this in real work, not just theory.',
            keyTakeaway: known.keyTakeaway,
          ),
        );
      } else {
        // Upgraded generic fallback: still names the exact topic, career,
        // and level, rather than a fully interchangeable placeholder.
        concepts.add(
          ConceptLesson(
            title: topic,
            definition:
                '$topic is a concept every $careerTitle should understand at the $levelTitle stage — it directly supports the skills this level is building toward.',
            analogy:
                'Think of $topic as one specific tool in your $careerTitle toolkit for $levelTitle: useful on its own, and more powerful once combined with everything else in this level.',
            example:
                'A working $careerTitle applies $topic when handling real $levelTitle-level problems, not just in isolated exercises.',
            keyTakeaway:
                'Read a short explanation of $topic, then immediately try using it — hands-on repetition is what turns $topic from theory into a usable skill.',
          ),
        );
      }
    }

    // Agar topics 5 se kam hain to minimum useful concepts
    // create karne ke liye level title use hoga.
    while (concepts.length < 5) {
      final n = concepts.length + 1;
      concepts.add(
        ConceptLesson(
          title: '$levelTitle — Practical Round $n',
          definition:
              'A focused practice round reinforcing what $levelTitle covers for a $careerTitle.',
          analogy:
              'Practice is like rehearsing a skill until it becomes automatic — the goal here is fluency, not new material.',
          example:
              'Re-apply what you\'ve just learned in $levelTitle to a slightly different scenario, without looking at the explanation first.',
          keyTakeaway:
              'Repetition with small variation is what converts "I understood it once" into "I can do this reliably".',
        ),
      );
    }

    // ==========================================================
    // QUIZ — topic-specific with real correct answers where we have a
    // knowledge entry, and topic-named (not generic) otherwise.
    // ==========================================================

    final quiz = <QuizQuestion>[];
    for (int i = 0; i < 5; i++) {
      final topic = topicsForContent[i % topicsForContent.length];
      final known = _lookupKnowledge(topic);

      if (known != null) {
        quiz.add(
          QuizQuestion(
            question: known.quizQuestion,
            options: known.quizOptions,
            correctIndex: 0,
            explanation: known.quizExplanation,
            xpReward: 10,
          ),
        );
      } else {
        // Rotate through several distinct, topic-named templates so a
        // course built entirely from unknown topics doesn't repeat the
        // exact same question shape five times.
        switch (i % 4) {
          case 0:
            quiz.add(
              QuizQuestion(
                question:
                    'What\'s the right first step when learning $topic as a $careerTitle?',
                options: [
                  'Understand the fundamentals of $topic before attempting advanced use',
                  'Skip straight to advanced use without the basics',
                  'Memorise the definition of $topic without practising it',
                  'Avoid applying $topic in real work',
                ],
                correctIndex: 0,
                explanation:
                    'Strong fundamentals in $topic make everything built on top of it — advanced techniques, debugging, real projects — easier to learn.',
                xpReward: 10,
              ),
            );
            break;
          case 1:
            quiz.add(
              QuizQuestion(
                question:
                    'Why does practising $topic matter for a working $careerTitle, not just knowing about it?',
                options: [
                  'Practical use turns knowledge of $topic into a demonstrable, job-ready skill',
                  'Practising $topic removes the need to ever learn it properly',
                  'Practical use of $topic guarantees a job offer',
                  'Practising $topic replaces the need for real projects',
                ],
                correctIndex: 0,
                explanation:
                    'Employers evaluate what you can DO with $topic, not just whether you can define it — practice is what builds that ability.',
                xpReward: 10,
              ),
            );
            break;
          case 2:
            quiz.add(
              QuizQuestion(
                question:
                    'At the $levelTitle stage, what best demonstrates real understanding of $topic?',
                options: [
                  'Applying $topic correctly to a new, unfamiliar problem',
                  'Reciting the definition of $topic from memory',
                  'Only reading about $topic without trying it',
                  'Avoiding any problem that involves $topic',
                ],
                correctIndex: 0,
                explanation:
                    'Being able to apply $topic to a problem you haven\'t seen before is a much stronger signal of understanding than memorised definitions.',
                xpReward: 10,
              ),
            );
            break;
          default:
            quiz.add(
              QuizQuestion(
                question:
                    'A $careerTitle at the $levelTitle stage should build what kind of proof of skill in $topic?',
                options: [
                  'A small, practical project that actually uses $topic',
                  'A list of notes about $topic with nothing built',
                  'A certificate with no accompanying project',
                  'Nothing — theory alone is sufficient',
                ],
                correctIndex: 0,
                explanation:
                    'A real project using $topic is concrete evidence of skill — far more convincing than notes or certificates alone.',
                xpReward: 10,
              ),
            );
        }
      }
    }

    // ==========================================================
    // MINI CHALLENGES — phrased as a coding challenge for hands-on
    // topics, or a judgement-based scenario for conceptual ones.
    // ==========================================================

    final challenges = <MiniChallenge>[];
    final challengeTopicCount = topicsForContent.length >= 2 ? 2 : 1;

    for (int i = 0; i < challengeTopicCount; i++) {
      final topic = topicsForContent[i];
      final known = _lookupKnowledge(topic);
      final handsOn = known?.isHandsOn ?? _looksHandsOn(topic);

      if (handsOn) {
        challenges.add(
          MiniChallenge(
            prompt:
                'You\'re working through $topic as a $careerTitle. What\'s the strongest way to actually build the skill, not just read about it?',
            options: [
              'Write or trace through a small, real example that uses $topic yourself',
              'Only read the definition of $topic',
              'Skip $topic and move to the next concept',
              'Copy a finished example without changing anything',
            ],
            correctIndex: 0,
            explanation:
                'Actively writing or tracing through your own example with $topic — even a small one — builds far more real skill than passively reading or copying.',
            xpReward: 15,
          ),
        );
      } else {
        challenges.add(
          MiniChallenge(
            prompt:
                'As a $careerTitle, you\'re asked to apply $topic to a real decision at the $levelTitle stage. What\'s the right approach?',
            options: [
              'Use the principles of $topic to reason through the specific situation, not just apply a generic rule',
              'Ignore $topic and decide based on guesswork',
              'Apply the same fixed answer regardless of the situation',
              'Wait for someone else to decide',
            ],
            correctIndex: 0,
            explanation:
                'Concepts like $topic are judgement tools — the goal is reasoning through the specific situation using $topic\'s principles, not applying it mechanically.',
            xpReward: 15,
          ),
        );
      }
    }

    // Preserve the original guarantee of at least 2 challenges even when
    // there's only 1 distinct topic to draw from.
    while (challenges.length < 2) {
      final topic = topicsForContent.first;
      challenges.add(
        MiniChallenge(
          prompt:
              'What should you do right after learning $topic in $levelTitle?',
          options: [
            'Practise $topic immediately, while it\'s fresh',
            'Forget about $topic until later',
            'Skip practising $topic entirely',
            'Only read about $topic again without trying it',
          ],
          correctIndex: 0,
          explanation:
              'Practising immediately after learning $topic — while it\'s fresh — is what locks the skill in.',
          xpReward: 15,
        ),
      );
    }

    // ============================================================
    // FINAL PROJECT — portfolio-oriented, referencing the actual topics
    // this level covered so it's demonstrably tied to real skills.
    // ============================================================

    final projectTopics = topicsForContent.take(4).toList();
    final topicSteps = projectTopics
        .map((t) => 'Apply $t to solve a real part of the project.')
        .toList();

    final project = FinalProject(
      title: '$careerTitle Portfolio Project — $levelTitle',
      goal:
          'Build a small, real project that demonstrably uses ${projectTopics.join(', ')} — something you could show a recruiter or hiring manager as proof of this level\'s skills.',
      steps: [
        'Review the concepts covered in $levelTitle: ${projectTopics.join(', ')}.',
        'Pick one realistic, scoped-down problem a $careerTitle might actually face.',
        'Plan a simple solution before writing/building anything.',
        ...topicSteps,
        'Test what you built and fix anything that doesn\'t work as expected.',
        'Write 2-3 sentences explaining what you built and which skills it demonstrates — this is what goes in your portfolio.',
      ],
      expectedOutput:
          'A small, working ($difficulty-level) project you can add to your portfolio that clearly demonstrates ${projectTopics.join(', ')} to a future employer.',
      xpReward: 50,
    );

    // ============================================================
    // RETURN TOPIC COURSE
    // ============================================================

    // Reposition quiz answers only after all questions have been built.
    // This keeps the knowledge base readable (index 0 remains the source
    // answer there) while the actual course presented to the user has
    // non-predictable answer positions.
    final randomizedQuiz = <QuizQuestion>[];
    for (int i = 0; i < quiz.length; i++) {
      randomizedQuiz.add(
        _repositionCorrectOption(
          quiz[i],
          seed:
              '$careerId|$categoryId|$level|$levelTitle|$i|${topicsForContent[i % topicsForContent.length]}',
        ),
      );
    }

    return TopicCourse(
      id: '${careerId}_level_$level',
      topicTitle: levelTitle,
      careerId: careerId,
      categoryId: categoryId,
      difficulty: difficulty,
      estimatedMinutes: 30,
      totalXp: 150,
      intro: isRefresher
          ? 'You\'ve already made progress on $levelTitle — here\'s a quick, practical refresher to keep $careerTitle skills sharp before moving on.'
          : 'Learn $levelTitle step by step and build practical $careerTitle skills you can actually use.',
      emoji: '📚',
      concepts: concepts,
      quiz: randomizedQuiz,
      challenges: challenges,
      finalProject: project,
    );
  }
}