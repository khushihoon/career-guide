import '../../models/course_content_data.dart';

const List<TopicCourse> claudeEngineerLevel1 = [
  // ────────────────────────────────────────────────────────────────────
  // LEVEL 1 — CLAUDE ENGINEER: FOUNDATIONS
  // ────────────────────────────────────────────────────────────────────

  TopicCourse(
    id: 'llm_basics_l1',
    topicTitle: 'What is a Large Language Model?',
    careerId: 'claude_engineer',
    categoryId: 'cloud_devops',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '🧠',
    intro:
        'Welcome to Level 1 of the Claude Engineer roadmap! Before you can build anything with Claude, you need to understand what a Large Language Model actually is — not as magic, but as a genuinely understandable piece of engineering. In 20 minutes, you will build a rock-solid mental model that every later level depends on.',
    concepts: [
      ConceptLesson(
        title: 'What is a Large Language Model (LLM)?',
        definition:
            'A Large Language Model is a neural network trained on enormous amounts of text to predict the next word (technically, the next "token") given everything that came before it.',
        analogy:
            'Think of an LLM like an extremely well-read friend playing a very sophisticated game of "finish my sentence." Show them millions of books, articles, and conversations, and they get so good at predicting what comes next that the predictions start to look like genuine understanding.',
        example:
            'Given "The capital of France is", a well-trained LLM assigns a very high probability to the word "Paris" — not because it "looked it up," but because that pattern appeared correctly, over and over, across its training data.',
        keyTakeaway:
            'An LLM is fundamentally a next-token predictor. Everything Claude does — answering questions, writing code, having a conversation — emerges from this one core mechanism applied at massive scale.',
      ),
      ConceptLesson(
        title: 'Claude: A Specific, Trained Assistant',
        definition:
            'Claude is Anthropic\'s LLM-based AI assistant — a model that has been trained not just to predict text, but specifically trained and fine-tuned to be a helpful, honest, and harmless conversational assistant.',
        analogy:
            'If a raw LLM is like a brilliant but unfocused writer who can imitate any style, Claude is that same writer after years of training specifically to be a thoughtful, careful assistant — helpful by default, but also taught where to draw lines.',
        example:
            'Ask a raw, untrained base model a question and it might just continue your text in unpredictable ways. Ask Claude the same question, and it responds as an assistant genuinely trying to help you, because that behaviour was deliberately trained in.',
        keyTakeaway:
            'As a "Claude Engineer," you are not just working with "an AI" in the abstract — you are working with a specific, deliberately shaped assistant. Understanding that shaping (helpfulness, honesty, harm-avoidance) is central to building good products with it.',
      ),
      ConceptLesson(
        title: 'What an LLM Is NOT',
        definition:
            'An LLM does not have a database of facts it looks up, does not "know" whether something is true, and has no persistent memory between separate conversations unless a product is specifically built to provide one.',
        analogy:
            'It is less like a librarian pulling a fact from a shelf, and more like someone recalling a pattern from a very, very good memory of everything they have read — usually accurate, but capable of confidently misremembering, exactly like a human can.',
        example:
            'Claude might state an incorrect date confidently, not because it is "lying," but because the pattern-completion process produced a plausible-sounding but wrong answer. This is called a "hallucination," and you will learn to reduce it later in this roadmap.',
        keyTakeaway:
            'Never assume an LLM output is automatically correct just because it sounds confident. Understanding this limitation from Level 1 onward is what separates a careful Claude Engineer from someone who builds fragile, unreliable products.',
      ),
      ConceptLesson(
        title: 'Why This Technology Exploded Recently',
        definition:
            'Modern LLMs became dramatically more capable due to three things scaling together: much larger models, much larger training datasets, and much larger amounts of compute (GPU/TPU power) used to train them.',
        analogy:
            'Imagine a student who suddenly gets a library ten thousand times bigger, ten thousand times more study time, and a ten-thousand-times-better memory — the resulting jump in capability is not gradual, it is transformative.',
        example:
            'Early language models from a decade ago could barely produce a coherent paragraph. Today\'s models, trained at massive scale, can write working code, reason through multi-step problems, and hold long, coherent conversations.',
        keyTakeaway:
            'Scale (data + compute + model size) is the single biggest driver behind the recent LLM revolution — and it is why staying current with new model releases genuinely matters for a Claude Engineer\'s career.',
      ),
      ConceptLesson(
        title: 'The "Stochastic Parrot" Debate',
        definition:
            'Some researchers argue LLMs are simply recombining memorized patterns ("stochastic parrots") without genuine understanding, while others argue that sufficiently large-scale pattern learning produces emergent reasoning — this remains an active, genuinely open debate.',
        analogy:
            'It is a bit like debating whether a chess engine "understands" chess or is "just" calculating probabilities extremely well — the practical output can be excellent either way, but the philosophical question of genuine understanding remains contested.',
        example:
            'An LLM can solve a brand-new logic puzzle it has never seen verbatim in training, which some see as evidence of genuine reasoning, while others attribute it to sophisticated pattern generalization rather than true comprehension.',
        keyTakeaway:
            'As a Claude Engineer, you do not need to resolve this philosophical debate to build great products — but knowing it exists helps you speak credibly and avoid overclaiming when discussing AI capabilities with stakeholders.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'At its core, what is a Large Language Model doing when it generates a response?',
        options: [
          'Looking up facts in a database',
          'Predicting the next token based on patterns learned from training data',
          'Running a fixed set of if/else rules',
          'Searching the internet in real time'
        ],
        correctIndex: 1,
        explanation:
            'LLMs are fundamentally next-token predictors. They generate text by repeatedly predicting the most likely next token given everything before it — this simple mechanism, at massive scale, produces remarkably coherent output.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What makes Claude different from a raw, untrained base language model?',
        options: [
          'Claude runs on different hardware',
          'Claude has been deliberately trained to be a helpful, honest, and harmless assistant',
          'Claude cannot generate text',
          'Claude only works with code, not language'
        ],
        correctIndex: 1,
        explanation:
            'Claude is a base LLM that has gone through additional, deliberate training specifically to behave as a helpful, honest, and harmless assistant — this shaping is what makes it usable as a genuine product, not just a raw text predictor.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why might an LLM confidently state something that is factually incorrect?',
        options: [
          'It is deliberately lying to the user',
          'It generates plausible-sounding token patterns, which can sometimes be wrong even when they sound confident',
          'It always refuses to answer if unsure',
          'This never actually happens with modern models'
        ],
        correctIndex: 1,
        explanation:
            'This is called "hallucination." Since an LLM generates the most statistically plausible continuation rather than looking up verified facts, it can produce confident, fluent, but factually incorrect output.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does the "stochastic parrot" critique argue about LLMs?',
        options: [
          'That LLMs are physically shaped like parrots',
          'That LLMs may simply be recombining memorized patterns without genuine understanding',
          'That LLMs always produce random, meaningless output',
          'That LLMs can never generate grammatically correct text'
        ],
        correctIndex: 1,
        explanation:
            'The "stochastic parrot" critique questions whether pattern-based text generation constitutes genuine understanding, versus sophisticated recombination of memorized patterns — a real, ongoing debate in the field.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which best describes the relationship between "training" and "fine-tuning" for a model like Claude?',
        options: [
          'They are unrelated processes',
          'Base training builds general language ability; fine-tuning further shapes the model toward helpful, honest, harmless assistant behavior',
          'Fine-tuning happens before base training',
          'Fine-tuning removes all of the model\'s general knowledge'
        ],
        correctIndex: 1,
        explanation:
            'Base training builds broad language capability from massive text data; fine-tuning is additional, deliberate training that shapes the model toward specific desired behaviors, like being a helpful assistant.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A colleague says: "Claude is basically a search engine that finds answers on the internet." What is the key misconception in this statement?',
        options: [
          'Claude cannot answer any questions',
          'Claude generates responses by predicting likely text based on training, not by performing a live internet search',
          'Claude is actually faster than a search engine',
          'There is no misconception, this is accurate'
        ],
        correctIndex: 1,
        explanation:
            'Unless explicitly connected to a search or retrieval tool (a topic for a later level), Claude does not "look things up" — it generates responses based on patterns learned during training, which is a fundamentally different mechanism than search.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A teammate claims "LLMs definitely have genuine understanding, exactly like humans do — this is settled science." What is the issue with this claim?',
        options: [
          'The claim is completely accurate and uncontested',
          'Whether LLMs have "genuine understanding" remains an open, actively debated question among researchers, not a settled fact',
          'LLMs definitely do not understand anything at all, which is also settled science',
          'This question has no relevance to building real products'
        ],
        correctIndex: 1,
        explanation:
            'The nature of LLM "understanding" remains a genuinely open research question. A careful Claude Engineer avoids overclaiming certainty on unsettled questions when discussing AI capabilities.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Explain an LLM to a Non-Technical Friend',
      goal:
          'Practice explaining what an LLM is and is not, in your own words, using a clear analogy — the exact communication skill you will need throughout your Claude Engineer career.',
      steps: [
        'Write a 3-4 sentence explanation of what an LLM is, using a real-world analogy (not the exact one from this lesson)',
        'Write 2 sentences explaining why an LLM can sometimes be confidently wrong (hallucination)',
        'Write 1 sentence explaining what makes Claude specifically different from a raw base model',
        'Read your explanation out loud and check: would a non-technical friend genuinely understand this?',
      ],
      expectedOutput:
          'A clear, jargon-light explanation covering: what an LLM does (next-token prediction via a chosen analogy), why it can hallucinate, and what makes Claude specifically an "assistant" rather than a raw model.',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'tokens_context_l1',
    topicTitle: 'How Claude Reads Text — Tokens',
    careerId: 'claude_engineer',
    categoryId: 'cloud_devops',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '🔤',
    intro:
        'Before you write a single prompt, you need to understand tokens — the actual units Claude "sees" text in. This single concept explains pricing, context limits, and even some of Claude\'s quirks with spelling and counting. Let\'s demystify it.',
    concepts: [
      ConceptLesson(
        title: 'What is a Token?',
        definition:
            'A token is the basic unit of text an LLM processes — often a word, part of a word, or punctuation mark. Text is broken into tokens before Claude ever "sees" it.',
        analogy:
            'Think of tokens like Lego bricks used to build a sentence. Some bricks are whole words ("cat"), some are common word-pieces ("ing", "un-"), and some are just punctuation. Claude assembles and reads meaning from these bricks, not from raw letters.',
        example:
            '"unbelievable" might be split into tokens like "un" + "believ" + "able". A short, common word like "the" is usually a single token. As a rough rule of thumb, 1 token ≈ 4 characters of English text.',
        keyTakeaway:
            'Claude does not read letter-by-letter or word-by-word the way humans do — it reads token-by-token. This single fact explains many downstream behaviours you will encounter throughout your Claude Engineer career.',
      ),
      ConceptLesson(
        title: 'Why Tokenization Explains Some of Claude\'s Quirks',
        definition:
            'Because rare or unusual words get split into multiple sub-word tokens, tasks like counting exact letters in a word or doing precise character-level manipulation can sometimes trip up an LLM.',
        analogy:
            'Imagine trying to count the letters in a word when you can only see it in three or four chunky puzzle pieces rather than individual letters — you can usually still do it, but it takes more careful reasoning than for a human reading letter by letter.',
        example:
            'Asking Claude to count the number of "r"s in "strawberry" is a genuinely harder task for a token-based model than it looks, precisely because the word may not be tokenized as individual letters.',
        keyTakeaway:
            'Understanding tokenization helps you predict WHERE an LLM is likely to struggle — a genuinely practical skill for designing prompts and evaluating output reliability later in this roadmap.',
      ),
      ConceptLesson(
        title: 'Tokens, Pricing, and the Context Window',
        definition:
            'Claude\'s API usage is billed by token count (input tokens + output tokens), and every model has a maximum context window — the total number of tokens (input + output combined) it can handle in one conversation.',
        analogy:
            'Think of the context window like the size of a whiteboard. You can write a lot on it, but once it is full, older content has to be erased (or summarized) to make room for new content.',
        example:
            'If a model has a 200,000-token context window, and your conversation (system prompt + chat history + new message) exceeds that, older content must be trimmed or summarized before Claude can process the new request.',
        keyTakeaway:
            'As a Claude Engineer, token count is not just an abstract detail — it directly drives your product\'s cost, latency, and the maximum amount of information you can give Claude at once. You will return to this concept constantly.',
        codeSnippet:
            '// Rough mental-math rule of thumb:\n// 1 token ≈ 4 characters of English text\n// 1 token ≈ 0.75 words\n\n// A 1,000-word document is roughly:\n// 1,000 words ÷ 0.75 ≈ 1,333 tokens',
      ),
      ConceptLesson(
        title: 'Estimating Token Counts in Practice',
        definition:
            'While exact token counts require a real tokenizer, a quick mental estimate — roughly 4 characters or 0.75 words per token for English — is good enough for early planning and back-of-envelope cost estimates.',
        analogy:
            'This is like estimating a road trip\'s fuel cost using an average mileage figure before you have the exact route — not perfectly precise, but plenty useful for planning purposes.',
        example:
            'A short paragraph of about 200 words is roughly 200 ÷ 0.75 ≈ 267 tokens. A full 10-page document might be 5,000+ words, or roughly 6,500+ tokens — already a meaningful fraction of many models\' context windows.',
        keyTakeaway:
            'Getting comfortable with rough token estimation, before you ever touch a real tokenizer tool, builds the intuition you will rely on constantly when designing prompts and estimating API costs.',
      ),
      ConceptLesson(
        title: 'Training Data Cutoffs',
        definition:
            'Every LLM is trained on data collected up to a certain point in time, called the "training cutoff" — meaning the model has no inherent knowledge of events after that date unless given that information in context.',
        analogy:
            'This is like a very well-read encyclopedia that stopped being updated on a specific date — brilliant about everything up to that point, but genuinely blind to anything that happened afterward, unless someone hands it today\'s newspaper.',
        example:
            'Ask a model about a product released well after its training cutoff, and it may either say it does not know, or — without careful prompting — hallucinate a plausible-sounding but incorrect guess.',
        keyTakeaway:
            'Always account for training cutoffs when designing features involving current events, recent releases, or time-sensitive facts — this is precisely why tool use and retrieval, covered in later levels, exist.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is a "token" in the context of an LLM like Claude?',
        options: [
          'A security credential for logging in',
          'The basic unit of text (word, sub-word, or punctuation) that the model processes',
          'A single character of text',
          'A complete sentence'
        ],
        correctIndex: 1,
        explanation:
            'A token is the basic unit of text an LLM processes — it might be a whole word, part of a word, or a punctuation mark, depending on how common that piece of text is.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why can counting exact letters in a word sometimes be a genuinely difficult task for an LLM?',
        options: [
          'LLMs cannot process short words at all',
          'Words are often split into multi-character sub-word tokens rather than individual letters, making precise character-level tasks harder',
          'This task is actually always easy for LLMs',
          'LLMs refuse to answer counting questions'
        ],
        correctIndex: 1,
        explanation:
            'Because tokenization often groups multiple letters into a single token, the model does not always have direct, easy access to individual character positions, making some character-counting tasks surprisingly error-prone.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does a model\'s "context window" refer to?',
        options: [
          'The visual size of the chat window on screen',
          'The maximum number of tokens (input + output combined) the model can handle in one conversation',
          'The number of users who can chat at once',
          'The time limit for a single API call'
        ],
        correctIndex: 1,
        explanation:
            'The context window is the maximum total token capacity — combining system prompt, conversation history, and generated output — that a model can handle within a single request.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'If a document is roughly 4,000 characters long, roughly how many tokens would you estimate it uses?',
        options: [
          'About 100 tokens',
          'About 1,000 tokens',
          'About 16,000 tokens',
          'Exactly 4,000 tokens'
        ],
        correctIndex: 1,
        explanation:
            'Using the rough rule of 1 token ≈ 4 characters, a 4,000-character document is roughly 1,000 tokens.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does a model\'s "training cutoff" refer to?',
        options: [
          'The maximum length of a single response',
          'The date after which the model has no inherent knowledge of events, since its training data ends at that point',
          'The temperature setting limit',
          'The number of tokens allowed per request'
        ],
        correctIndex: 1,
        explanation:
            'The training cutoff is the point in time after which the model has no built-in knowledge, since its training data does not include anything past that date.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Using the rough rule of thumb (1 token ≈ 0.75 words), roughly how many tokens would an 1,500-word blog post use?',
        options: [
          'About 500 tokens',
          'About 1,125 tokens',
          'About 2,000 tokens',
          'About 6,000 tokens'
        ],
        correctIndex: 2,
        explanation:
            '1,500 words ÷ 0.75 ≈ 2,000 tokens. This kind of quick mental estimate is exactly the practical skill this lesson builds.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A user asks Claude about an event that happened after the model\'s training cutoff, with no additional context provided. What is the most responsible outcome?',
        options: [
          'Claude should always confidently guess an answer',
          'Claude should ideally indicate it may not have information about very recent events, rather than confidently fabricating details',
          'This situation can never actually happen',
          'The user should be blamed for asking the question'
        ],
        correctIndex: 1,
        explanation:
            'Since events after the training cutoff are not part of the model\'s knowledge, the responsible behavior is acknowledging this limitation rather than confidently generating a fabricated answer.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Token Estimation Worksheet',
      goal:
          'Practice estimating token counts for realistic Claude Engineer scenarios using the rule-of-thumb ratio.',
      steps: [
        'Estimate the token count for a 300-word product description using the 0.75 words-per-token rule',
        'Estimate the token count for a 10-page document (assume 500 words per page)',
        'If a model has a 200,000 token context window, calculate roughly how many 500-word documents you could fit in a single conversation, leaving room for a 2,000-token response',
        'Write 2-3 sentences on why this estimation skill matters when designing a real Claude-powered product',
      ],
      expectedOutput:
          '300-word description: ~400 tokens\n10-page document (5,000 words): ~6,667 tokens\n200,000 token window ÷ ~667 tokens per document ≈ roughly 297 documents (with room left for output)\n\nReflection: Token estimation directly affects product cost, whether documents fit at all, and how much conversation history can be retained.',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'prompting_basics_l1',
    topicTitle: 'Prompting Basics — System vs User Messages',
    careerId: 'claude_engineer',
    categoryId: 'cloud_devops',
    difficulty: 'Easy',
    estimatedMinutes: 22,
    totalXp: 115,
    emoji: '💬',
    intro:
        'A prompt is your only way to communicate with Claude — there is no other interface. In this lesson, you will learn the two fundamental building blocks of every Claude conversation: the system prompt and user messages, and why separating them well is the first real skill of prompt engineering.',
    concepts: [
      ConceptLesson(
        title: 'What is a Prompt?',
        definition:
            'A prompt is the complete text input you send to Claude — including instructions, context, and the actual question or task — that Claude uses to generate its response.',
        analogy:
            'A prompt is like a work order you hand to a very capable new employee. The clearer and more complete the work order, the better the resulting work — a vague work order produces vague, unpredictable results.',
        example:
            'A weak prompt: "write something about dogs." A strong prompt: "Write a 100-word, upbeat paragraph about why Golden Retrievers make great family pets, aimed at first-time dog owners."',
        keyTakeaway:
            'Prompt quality directly drives output quality. This single idea is the foundation of everything else in this roadmap — a Claude Engineer\'s core skill is writing prompts that reliably produce the intended result.',
      ),
      ConceptLesson(
        title: 'The System Prompt — Setting the Stage',
        definition:
            'The system prompt is a special instruction, set once, that defines Claude\'s role, personality, constraints, and overall behaviour for the entire conversation — separate from the back-and-forth user messages.',
        analogy:
            'The system prompt is like the job description and company handbook you give a new employee on day one — it shapes HOW they approach every task, before any specific customer request ever arrives.',
        example:
            'System prompt: "You are a concise, friendly customer support assistant for a shoe company. Always keep responses under 100 words and never discuss competitor products."',
        keyTakeaway:
            'Put durable, role-defining instructions in the system prompt, not repeated in every single user message. This separation is one of the most important organizational habits a Claude Engineer builds early.',
      ),
      ConceptLesson(
        title: 'User Messages — The Actual Conversation',
        definition:
            'User messages are the specific questions, requests, or inputs sent within the ongoing conversation — the part that changes turn by turn, layered on top of the stable system prompt.',
        analogy:
            'If the system prompt is the job description, user messages are the individual customer requests that come in throughout the day — each one different, but all handled according to the same underlying role.',
        example:
            'Given the shoe-company system prompt above, a user message might be: "Do you have the Trailblazer sneaker in size 10?" — Claude answers this specific question while still following the system prompt\'s tone and length rules.',
        keyTakeaway:
            'Separating stable instructions (system) from changing requests (user) keeps your prompts organized, reusable, and much easier to debug as your Claude-powered product grows in complexity.',
      ),
      ConceptLesson(
        title: 'Claude\'s Response — The Assistant Turn',
        definition:
            'Claude\'s reply is called the "assistant" turn. In a multi-turn conversation, the full exchange (user, assistant, user, assistant...) is sent back to Claude each time so it has the full context of what has been said.',
        analogy:
            'This is like handing someone the complete transcript of a conversation so far, every single time you ask a follow-up question — without that transcript, they would have no memory of what was discussed a moment ago.',
        example:
            'Turn 1 — User: "What\'s the capital of Japan?" Assistant: "Tokyo." Turn 2 — User: "What\'s its population?" — Claude only understands "its" refers to Tokyo because the full prior turn was included in the request.',
        keyTakeaway:
            'Claude has no memory of its own between API calls — the illusion of a flowing conversation is created entirely by resending the full message history each time. You will build on this fact heavily in Level 3.',
        codeSnippet:
            '// Conceptual structure of a Claude conversation\n{\n  "system": "You are a helpful, concise assistant.",\n  "messages": [\n    {"role": "user", "content": "What\'s the capital of Japan?"},\n    {"role": "assistant", "content": "Tokyo."},\n    {"role": "user", "content": "What\'s its population?"}\n  ]\n}',
      ),
      ConceptLesson(
        title: 'Multi-Turn Conversation as Accumulated Context',
        definition:
            'Every message a user sends and every reply Claude gives becomes part of the accumulated context for the rest of that conversation — meaning earlier turns genuinely shape how later turns are interpreted.',
        analogy:
            'This is like a growing shared notebook between two people talking — everything written earlier in the notebook remains visible and influences how new entries are understood.',
        example:
            'If a user says "I am vegetarian" in turn 2, and then asks "what should I eat for dinner?" in turn 8, Claude can genuinely take the earlier statement into account, precisely because it is still present in context.',
        keyTakeaway:
            'Designing good multi-turn experiences means being deliberate about what stays in context and for how long — a theme you will build on heavily starting with this level\'s context window lesson.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the primary purpose of a system prompt?',
        options: [
          'To ask Claude a specific question',
          'To set Claude\'s durable role, tone, and constraints for the entire conversation',
          'To show Claude\'s previous response',
          'To count tokens automatically'
        ],
        correctIndex: 1,
        explanation:
            'The system prompt defines stable, role-level behaviour (personality, constraints, tone) that applies throughout the whole conversation, separate from the specific, changing user requests.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why does Claude need the full conversation history resent with every new message?',
        options: [
          'Because Claude has no built-in memory between separate API calls',
          'Because the API requires it for billing purposes only',
          'Because user messages are deleted after each turn',
          'This is not actually true — Claude remembers on its own'
        ],
        correctIndex: 0,
        explanation:
            'Claude does not retain memory between API calls on its own. The full message history must be resent each time to give Claude the context needed to respond coherently, creating the illusion of ongoing memory.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which of these belongs in a system prompt rather than a user message?',
        options: [
          '"What is the weather in Delhi today?"',
          '"You are a professional legal-document summarizer who always responds in bullet points"',
          '"Summarize this specific contract I am about to paste"',
          '"Translate this sentence to Hindi"'
        ],
        correctIndex: 1,
        explanation:
            'A durable role definition ("You are a professional legal-document summarizer...") belongs in the system prompt, since it applies to every request in the conversation, not just one specific message.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the risk of ALWAYS repeating durable role instructions inside every single user message instead of the system prompt?',
        options: [
          'There is no risk at all',
          'It wastes tokens repeatedly and makes the prompt harder to maintain consistently across a conversation',
          'It makes responses faster',
          'User messages cannot contain instructions'
        ],
        correctIndex: 1,
        explanation:
            'Repeating durable instructions in every user message wastes tokens and creates a maintenance burden — the system prompt exists specifically to hold this kind of stable, conversation-wide instruction.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why does accumulated multi-turn context matter for how Claude interprets a later message?',
        options: [
          'It does not matter at all, each message is interpreted in total isolation',
          'Earlier turns remain part of the context and genuinely shape how later messages are understood',
          'Only the very first message in a conversation is ever considered',
          'Context accumulation only applies to system prompts, never user messages'
        ],
        correctIndex: 1,
        explanation:
            'Since the full conversation history is resent with each request, earlier turns remain part of the context and genuinely influence how Claude interprets and responds to later messages.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are building a Claude-powered recipe assistant. Where should the instruction "Always respond with ingredients as a bulleted list, never a paragraph" go?',
        options: [
          'In every single user message, repeated each time',
          'In the system prompt, since it is a durable formatting rule for the entire conversation',
          'It should not be included anywhere',
          'Only in the very first user message'
        ],
        correctIndex: 1,
        explanation:
            'A formatting rule meant to apply to every response throughout the conversation belongs in the system prompt — putting it there avoids repeating yourself and keeps behaviour consistent.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'In turn 5 of a conversation, a user refers to "that first option I mentioned" without repeating what it was. What allows Claude to correctly resolve this reference?',
        options: [
          'Claude cannot resolve this and will always fail',
          'The full conversation history, including the earlier message with that option, is included in the current context',
          'Claude randomly guesses which option is meant',
          'This only works if the user repeats the entire conversation manually'
        ],
        correctIndex: 1,
        explanation:
            'Because the complete conversation history is resent with each request, Claude can look back at earlier turns within the same context window to correctly resolve references like "that first option."',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Design a System Prompt for a Real Assistant',
      goal:
          'Practice separating durable role instructions from specific user requests by designing a complete system prompt for a realistic assistant.',
      steps: [
        'Choose a realistic assistant idea (e.g., a fitness coach, a coding tutor, a travel planner)',
        'Write a complete system prompt covering: role, tone, response length constraints, and one thing it should never do',
        'Write 3 example user messages this assistant might realistically receive',
        'For each user message, write a short note on how the system prompt would shape the response',
      ],
      expectedOutput:
          'System prompt: "You are an encouraging beginner-friendly fitness coach. Keep responses under 150 words, use simple language, and never recommend specific supplement brands."\n\n3 example user messages with notes on how tone/length/constraints shape each response.',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'context_window_l1',
    topicTitle: 'Context Window & Conversation Memory',
    careerId: 'claude_engineer',
    categoryId: 'cloud_devops',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '🪟',
    intro:
        'You touched on the context window briefly in the tokens lesson — now let\'s go deeper. Understanding exactly how conversation memory works (and what happens when it runs out) is essential before you design any real multi-turn Claude product.',
    concepts: [
      ConceptLesson(
        title: 'The Context Window as Claude\'s "Working Memory"',
        definition:
            'The context window is the entire span of text — system prompt, full conversation history, and any documents you provide — that Claude can actually "see" and reason over when generating a response.',
        analogy:
            'Think of it as a person\'s short-term working memory during a meeting: they can reason brilliantly about everything currently in front of them on the table, but anything not on the table right now might as well not exist for this conversation.',
        example:
            'If your context window is full of a 50-page document plus a long chat history, Claude can reference details from anywhere within that window — but nothing outside it, including earlier conversations from a different session.',
        keyTakeaway:
            'Everything Claude "knows" about your specific conversation lives entirely inside the current context window — there is no hidden, separate memory store unless your application specifically builds one (a topic for Level 5\'s RAG lesson).',
      ),
      ConceptLesson(
        title: 'What Happens When Conversations Get Too Long',
        definition:
            'When a conversation approaches or exceeds the model\'s context window limit, older messages must be trimmed, summarized, or the request will fail — because everything must fit within that fixed token budget.',
        analogy:
            'This is like a notebook with a fixed number of pages — once it is full, you either need to erase old pages to keep writing, summarize earlier pages onto a fresh one, or start a brand-new notebook.',
        example:
            'A long customer-support chat that has gone on for hours might need older, resolved topics summarized into a short recap, so the remaining context budget is preserved for the current, active issue.',
        keyTakeaway:
            'Designing HOW your product handles a full context window (trimming, summarizing, or restarting) is a genuine architectural decision — not an afterthought — that you will need to make for any real, long-running Claude application.',
      ),
      ConceptLesson(
        title: 'Context Window is Not the Same as "Knowledge"',
        definition:
            'Claude\'s general knowledge comes from its training data (frozen at a point in time), while the context window is the separate, temporary space for the SPECIFIC conversation and documents you provide right now.',
        analogy:
            'General training knowledge is like everything a person learned in school over many years; the context window is like the specific notes and documents spread out on their desk for today\'s particular task.',
        example:
            'Claude might "know" general facts about photosynthesis from training, but it only "knows" the specific contents of the PDF you upload because you placed that PDF\'s text directly into the current context window.',
        keyTakeaway:
            'This distinction — trained knowledge versus in-context information — is central to understanding why giving Claude the RIGHT documents in context (rather than assuming it already "knows" your specific data) is often the key to a reliable Claude-powered product.',
      ),
      ConceptLesson(
        title: 'Bigger Context Windows: Benefits and Trade-offs',
        definition:
            'Larger context windows let you provide much more information (long documents, extensive chat history) at once, but using more tokens generally means higher cost and, at very large sizes, can sometimes affect latency.',
        analogy:
            'A bigger desk lets you spread out more documents and reference all of them at once — genuinely useful, but it also costs more to "rent" that bigger desk, and it can take a little longer to scan everything spread across it.',
        example:
            'Pasting an entire 100-page manual into context for a single question might technically fit within a large context window, but costs far more in tokens than retrieving just the 2 relevant pages (a technique you will learn in Level 5\'s RAG lesson).',
        keyTakeaway:
            'A large context window is a powerful tool, not an excuse to skip good design. A skilled Claude Engineer still thinks carefully about what actually needs to be in context, rather than dumping everything in "just in case."',
      ),
      ConceptLesson(
        title: 'Determinism vs Variability in Practice',
        definition:
            'Even with identical prompts and settings, LLM output can vary slightly between calls due to the probabilistic nature of generation — a genuinely important consideration when designing tests or expecting exact repeatability.',
        analogy:
            'This is like asking the same skilled musician to play the same song twice — the notes are all correct both times, but small, natural variations in timing or expression are expected, not a sign of error.',
        example:
            'Running the identical prompt twice at a moderate temperature might produce two summaries that are both excellent and accurate, but phrased slightly differently — this is expected behavior, not a bug.',
        keyTakeaway:
            'When building automated tests for Claude-powered features (a topic explored deeply in Level 8), design your tests to check for correctness and required elements, not for exact, word-for-word repeatability.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What best describes the context window?',
        options: [
          'A separate, permanent database Claude can search',
          'The entire span of text (system prompt + conversation + documents) Claude can actually see for the current request',
          'The visual browser window showing the chat',
          'A setting that controls Claude\'s personality'
        ],
        correctIndex: 1,
        explanation:
            'The context window is the full amount of text — system prompt, conversation history, and any provided documents — Claude can actually reason over for a given request.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the key difference between Claude\'s trained knowledge and information in its context window?',
        options: [
          'There is no difference, they are the same thing',
          'Trained knowledge comes from training data (frozen in time); context window information is the specific, temporary content you provide for the current conversation',
          'Context window information is always more accurate than trained knowledge',
          'Trained knowledge changes every time you send a new message'
        ],
        correctIndex: 1,
        explanation:
            'Trained knowledge is baked in during training and frozen at a point in time. Context window content is the specific, temporary information supplied for the current request — a distinction essential for building reliable products.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is a genuine trade-off of using a very large context window unnecessarily?',
        options: [
          'There are no trade-offs, bigger is always strictly better',
          'Higher token cost, and potentially increased latency, even if only a small part of the content is actually relevant',
          'Claude becomes unable to respond at all',
          'The system prompt stops working'
        ],
        correctIndex: 1,
        explanation:
            'Filling the context window with more content than necessary increases cost (more tokens billed) and can affect latency, even when only a small fraction of that content is genuinely relevant to the task.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A conversation has grown so long it now exceeds the model\'s context window. What is the most direct consequence if nothing is done?',
        options: [
          'Nothing happens, the window expands automatically forever',
          'The request will fail or require trimming/summarizing older content to fit',
          'Claude automatically remembers everything regardless of the limit',
          'The temperature setting automatically increases'
        ],
        correctIndex: 1,
        explanation:
            'Exceeding the context window means the request cannot be processed as-is — older content must be trimmed or summarized, or the request will fail.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why might identical prompts produce slightly different responses across separate calls?',
        options: [
          'This indicates a bug that should always be reported',
          'Generation is probabilistic by nature, so some natural variation is expected, especially at non-zero temperature',
          'Claude randomly ignores parts of the prompt',
          'This only happens when the system prompt is missing'
        ],
        correctIndex: 1,
        explanation:
            'Because token generation is sampled from a probability distribution, some natural variation between calls is expected and normal, particularly at higher temperature settings.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A support chatbot conversation has been running for 3 hours and is approaching the context window limit. What is the MOST appropriate engineering response?',
        options: [
          'Let the next request simply fail with no plan',
          'Summarize or trim older, resolved parts of the conversation to preserve budget for the current issue',
          'Increase the model\'s temperature setting',
          'Switch to a different system prompt mid-conversation with no other changes'
        ],
        correctIndex: 1,
        explanation:
            'Summarizing or trimming older content is the standard, deliberate way to handle a conversation approaching its context limit, preserving space for the currently relevant discussion.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A QA engineer writes an automated test that fails whenever Claude\'s exact wording differs even slightly between runs of the same prompt. What is the flaw in this testing approach?',
        options: [
          'There is no flaw, exact wording should always match perfectly',
          'The test ignores the expected natural variability of generation and should instead check for required content/correctness, not exact wording',
          'Automated testing of LLM output is never possible',
          'The flaw is unrelated to how LLMs generate text'
        ],
        correctIndex: 1,
        explanation:
            'Since LLM output can naturally vary slightly between calls, tests should check for the presence of correct, required information rather than demanding exact, word-for-word repeatability.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Design a Context Management Strategy',
      goal:
          'Practice thinking through a realistic context-window management decision for a long-running Claude application.',
      steps: [
        'Describe a realistic product with potentially very long conversations (e.g., a therapy journaling app, a long research assistant session)',
        'Explain what should happen when the conversation approaches the context window limit: trim oldest messages, summarize, or start fresh — and justify your choice',
        'Identify what information (if any) should be preserved even after trimming or summarizing (e.g., key facts, user preferences)',
        'Write 2-3 sentences on the cost/latency trade-off of your chosen approach versus simply using the largest available context window at all times',
      ],
      expectedOutput:
          'Strategy document: product description, chosen context-management approach with justification, list of "must preserve" information, and a short cost/latency reflection.',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sampling_params_l1',
    topicTitle: 'Sampling Parameters — Temperature & Top-p',
    careerId: 'claude_engineer',
    categoryId: 'cloud_devops',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '🎛️',
    intro:
        'Claude has "dials" you can turn to control how creative or predictable its responses are. This lesson teaches you temperature and related sampling settings — small numbers that make a genuinely large difference in your product\'s behaviour.',
    concepts: [
      ConceptLesson(
        title: 'How Claude Actually Picks the Next Token',
        definition:
            'At each step, Claude calculates a probability distribution over many possible next tokens, then samples from that distribution to pick one — it does not always simply pick the single highest-probability option.',
        analogy:
            'Imagine a weighted lottery where more likely words get more tickets in the drawing. Even the most likely word does not always win every single time — some genuine randomness is involved, controlled by settings you can adjust.',
        example:
            'After "The sky is", tokens like "blue" might get 70% of the probability weight, "clear" might get 10%, and dozens of other tokens split the remainder — the final choice is sampled from this distribution, not deterministically fixed.',
        keyTakeaway:
            'Response generation is probabilistic, not perfectly deterministic by default. Understanding this is the foundation for understanding why the same prompt can sometimes produce slightly different responses.',
      ),
      ConceptLesson(
        title: 'Temperature — Controlling Randomness',
        definition:
            'Temperature is a setting (typically between 0 and 1) that controls how "flat" or "peaked" that probability distribution is — low temperature makes Claude more predictable and focused, high temperature makes it more varied and creative.',
        analogy:
            'Temperature is like adjusting how adventurous a chef is willing to be. Low temperature = a reliable chef who sticks closely to the tried-and-true recipe. High temperature = a chef willing to experiment with unusual, more surprising combinations.',
        example:
            'At temperature 0, asking for "a name for a pet goldfish" will very reliably return the single most statistically common suggestion (e.g., "Bubbles") almost every time. At temperature 1, you might get a much wider variety: "Nemo," "Finley," "Captain Orange," and so on.',
        keyTakeaway:
            'Use LOW temperature for tasks needing consistency and precision (data extraction, code generation, factual Q&A). Use HIGHER temperature for tasks benefiting from variety and creativity (brainstorming, creative writing).',
        codeSnippet:
            '// Conceptual guide, not exact API syntax\n// temperature: 0.0  → highly deterministic, focused\n// temperature: 0.5  → balanced\n// temperature: 1.0  → more varied, creative',
      ),
      ConceptLesson(
        title: 'Matching Temperature to the Task',
        definition:
            'Choosing the right temperature is a genuine design decision, not a default you should ignore — different Claude Engineer tasks call for very different points on the randomness spectrum.',
        analogy:
            'You would not want a surgeon\'s checklist app to behave "creatively," and you would not want a poetry-generation app to always produce the exact same, most predictable line every time — the right amount of randomness depends entirely on the job.',
        example:
            'A JSON-data-extraction tool should almost always use a low temperature for consistency. A "generate 5 different tagline ideas" marketing tool should use a higher temperature to genuinely produce variety across the 5 options.',
        keyTakeaway:
            'As you design real Claude-powered features later in this roadmap, matching temperature to the specific task\'s need for consistency versus creativity will become second nature — start building that instinct now.',
      ),
      ConceptLesson(
        title: 'Other Sampling Controls: Top-p and Max Tokens',
        definition:
            'Beyond temperature, "top-p" (nucleus sampling) restricts sampling to only the most likely tokens that together make up a given probability mass, and "max tokens" simply caps the maximum length of a generated response.',
        analogy:
            'If temperature adjusts HOW adventurous the chef is, top-p is like limiting the chef to only choosing from the top few most reasonable ingredients on the shelf, rather than literally every ingredient in the entire kitchen, no matter how unlikely.',
        example:
            'Setting max_tokens to 150 ensures a response is capped at roughly 150 tokens, which is useful for controlling cost and keeping responses appropriately concise for a chat UI.',
        keyTakeaway:
            'Temperature, top-p, and max tokens together form your basic toolbox for shaping Claude\'s output style and length — you will combine these settings deliberately once you start making real API calls in Level 3.',
      ),
      ConceptLesson(
        title: 'Why "Garbage In, Garbage Out" Applies Doubly to LLMs',
        definition:
            'The classic engineering principle that poor input produces poor output applies especially strongly to LLMs — vague, contradictory, or incomplete prompts reliably produce vague, inconsistent, or incorrect responses.',
        analogy:
            'Handing someone a confusing, contradictory set of instructions and expecting a precise, correct result is unrealistic for a human employee, and it is equally unrealistic for Claude — clarity in genuinely does drive quality out.',
        example:
            'A prompt that says "make it good" with no further detail will produce far less reliable results than one specifying exact length, tone, format, and audience.',
        keyTakeaway:
            'This principle underlies almost every prompt engineering technique you will learn throughout this roadmap — investing effort in a clear, complete prompt consistently pays off in output quality.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does a LOW temperature setting generally produce?',
        options: [
          'More random, unpredictable, and varied output',
          'More focused, predictable, and consistent output',
          'Longer responses only',
          'No response at all'
        ],
        correctIndex: 1,
        explanation:
            'Low temperature makes the probability distribution more "peaked" toward the most likely tokens, producing more predictable, consistent, focused output — ideal for tasks needing reliability.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'For which task would a HIGHER temperature setting generally be most appropriate?',
        options: [
          'Extracting structured data from an invoice into JSON',
          'Brainstorming 10 varied creative slogan ideas for a new product',
          'Answering a precise factual question',
          'Generating consistent, repeatable test output'
        ],
        correctIndex: 1,
        explanation:
            'Creative brainstorming benefits from genuine variety across outputs, which higher temperature settings encourage — unlike precision tasks, which benefit from lower temperature\'s consistency.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the "max tokens" setting control?',
        options: [
          'How creative the response is',
          'The maximum length (in tokens) of the generated response',
          'How many separate API calls are allowed',
          'The size of the context window'
        ],
        correctIndex: 1,
        explanation:
            'Max tokens simply caps how long a generated response can be, which is useful for controlling cost and keeping output appropriately sized for a given use case.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why would setting temperature to exactly 0 be a reasonable choice for a data-extraction pipeline feeding into a database?',
        options: [
          'It guarantees the fastest possible response time',
          'It maximizes consistency and predictability, which matters when downstream systems expect a reliable, repeatable format',
          'It increases the model\'s creativity for edge cases',
          'Temperature 0 disables the model entirely'
        ],
        correctIndex: 1,
        explanation:
            'For structured extraction feeding automated systems, consistency matters far more than creativity — a near-zero temperature favors the most likely, most predictable output every time.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'How does the "garbage in, garbage out" principle apply to prompt engineering?',
        options: [
          'It does not apply to LLMs at all',
          'Vague, incomplete, or contradictory prompts reliably produce vague, inconsistent, or incorrect output',
          'Only code has this principle, not natural language prompts',
          'This principle only matters for few-shot prompts'
        ],
        correctIndex: 1,
        explanation:
            'Just like in traditional engineering, poor-quality input (an unclear or contradictory prompt) reliably produces poor-quality output — clarity and completeness in prompting directly drive result quality.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are building a tool that extracts a customer\'s order number from a support email into a consistent JSON format every time. Which temperature setting is most appropriate?',
        options: [
          'A high temperature, for maximum creativity',
          'A low temperature, for maximum consistency and predictability',
          'Temperature has no effect on this kind of task',
          'The highest possible temperature setting available'
        ],
        correctIndex: 1,
        explanation:
            'Structured data extraction benefits from low temperature, since you want the exact same, correct, predictable output every time given the same input — not creative variation.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'For a task generating a company\'s official press release (which must be precise and consistent), which temperature range is most appropriate?',
        options: [
          'A high temperature, to maximize creative variety',
          'A low temperature, to prioritize precision, consistency, and professional reliability',
          'Temperature is irrelevant for this type of task',
          'The exact middle value, regardless of task needs'
        ],
        correctIndex: 1,
        explanation:
            'An official press release needs precise, consistent, professional language — exactly the kind of task where low temperature\'s predictability is most valuable.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Temperature Decision Matrix',
      goal:
          'Practice matching sampling settings to realistic Claude Engineer tasks, building the judgment you will need when configuring real API calls.',
      steps: [
        'List 5 different realistic Claude-powered tasks (e.g., code generation, poem writing, customer email classification, brainstorming names, legal document summarization)',
        'For each task, assign a recommended temperature range (low / medium / high) with 1-2 sentence justification',
        'For the 2 tasks needing the LOWEST temperature, explain what could go wrong if a high temperature were used instead',
        'For the task needing the HIGHEST temperature, explain what would be lost if too low a temperature were used instead',
      ],
      expectedOutput:
          'A 5-row table: Task | Recommended Temperature | Justification — plus 2 "what could go wrong" notes for low-temperature tasks and 1 note for the high-temperature task.',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'zero_few_shot_l1',
    topicTitle: 'Zero-shot vs Few-shot Prompting',
    careerId: 'claude_engineer',
    categoryId: 'cloud_devops',
    difficulty: 'Easy',
    estimatedMinutes: 22,
    totalXp: 115,
    emoji: '🎯',
    intro:
        'One of the single highest-leverage prompt engineering techniques is showing Claude examples of what you want, rather than just describing it. This lesson teaches you zero-shot and few-shot prompting — and when each genuinely makes a difference.',
    concepts: [
      ConceptLesson(
        title: 'Zero-Shot Prompting — Just Ask',
        definition:
            'Zero-shot prompting means giving Claude an instruction WITHOUT any examples of the desired output — relying entirely on Claude\'s general training to correctly interpret what you want.',
        analogy:
            'This is like giving a new employee a task with only a verbal description and no sample of finished work to reference — it often works fine for straightforward tasks, but leaves more room for misinterpretation on subtle or unusual ones.',
        example:
            'Zero-shot prompt: "Classify this review as Positive, Negative, or Neutral: \'The delivery was fast but the product broke after one use.\'" — no examples given, just the instruction and the task.',
        keyTakeaway:
            'Zero-shot prompting is your starting point for most tasks — simple, fast to write, and often good enough. Reach for it first before adding complexity.',
      ),
      ConceptLesson(
        title: 'Few-Shot Prompting — Show, Don\'t Just Tell',
        definition:
            'Few-shot prompting means including a small number of example input-output pairs directly in the prompt, demonstrating the EXACT format, tone, or reasoning style you want Claude to follow.',
        analogy:
            'This is like handing that same new employee 2-3 genuinely excellent, finished examples of the work before they start — dramatically reducing ambiguity about exactly what "good" looks like.',
        example:
            'Few-shot prompt: "Classify sentiment as Positive, Negative, or Neutral.\\n\\nReview: \'Amazing quality!\' → Positive\\nReview: \'Arrived broken.\' → Negative\\nReview: \'It\'s okay, does the job.\' → Neutral\\n\\nReview: \'The delivery was fast but the product broke after one use.\' → "',
        keyTakeaway:
            'Few-shot examples are especially powerful for enforcing a SPECIFIC output format or a subtle judgment call that is hard to fully describe in words alone — showing beats describing for these cases.',
      ),
      ConceptLesson(
        title: 'When Few-Shot Genuinely Helps',
        definition:
            'Few-shot examples provide the most value when the task involves a specific, non-obvious output format, a nuanced judgment call, or a style that is difficult to fully capture in a plain-language instruction.',
        analogy:
            'If you wanted a very SPECIFIC handwriting style copied exactly, describing it in words ("loopy, slightly slanted") is far less effective than simply showing a genuine handwriting sample to copy from.',
        example:
            'Getting Claude to always output dates in the exact format "DD-Mon-YYYY" (e.g., "05-Sep-2026") is far more reliable with 2-3 concrete examples than with a written description alone, since the written description leaves more room for ambiguity.',
        keyTakeaway:
            'Reach for few-shot examples specifically when zero-shot output is inconsistent, in the wrong format, or missing subtle nuance you are struggling to describe in plain instructions.',
      ),
      ConceptLesson(
        title: 'The Trade-off: More Examples, More Tokens',
        definition:
            'Every example you add to a few-shot prompt consumes tokens (directly connecting to Level 1\'s tokens lesson) — meaning few-shot prompting is more expensive and uses more of your context window than zero-shot prompting.',
        analogy:
            'Providing more reference samples to that new employee takes more of their limited desk space — genuinely useful up to a point, but you would not want to bury them under 50 samples when 2-3 excellent ones would do the job.',
        example:
            'A prompt with 10 detailed few-shot examples might cost 5-10x more input tokens than the equivalent zero-shot version — a cost that is often worthwhile for reliability, but should be a deliberate choice, not a default.',
        keyTakeaway:
            'Use the SMALLEST number of examples that reliably achieves the result you need — typically 2 to 5 well-chosen examples is the sweet spot for most real-world Claude Engineer tasks.',
      ),
      ConceptLesson(
        title: 'Low Temperature Does Not Mean Zero Creativity',
        definition:
            'Even at low temperature settings, Claude can still produce well-written, natural-sounding language — low temperature reduces randomness in word CHOICE, but does not make output robotic or force it to repeat identical phrasing.',
        analogy:
            'A careful, precise writer following a strict style guide can still produce genuinely engaging prose — precision and quality are not opposites, they simply constrain the randomness of word selection.',
        example:
            'A low-temperature response to "describe a sunset" will still read as a coherent, well-formed sentence — it will simply tend toward the more common, statistically likely descriptive choices rather than unusual ones.',
        keyTakeaway:
            'Do not assume low temperature always means "boring" output — for most factual and professional tasks, low temperature simply means more reliable, consistent quality, which is exactly what you want.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the defining characteristic of a zero-shot prompt?',
        options: [
          'It includes 5 or more examples',
          'It gives Claude an instruction with no examples of the desired output',
          'It always produces incorrect results',
          'It uses a temperature of zero'
        ],
        correctIndex: 1,
        explanation:
            'Zero-shot prompting relies purely on a clear instruction, with no example input-output pairs included, relying on Claude\'s general training to correctly interpret the task.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'When is few-shot prompting MOST likely to provide meaningful value over zero-shot?',
        options: [
          'For every single task, with no exceptions',
          'When the task requires a specific, non-obvious output format or a nuanced judgment call that is hard to fully describe in words',
          'Only when writing poetry',
          'Few-shot prompting never actually helps'
        ],
        correctIndex: 1,
        explanation:
            'Few-shot examples are most valuable when a specific format, tone, or subtle judgment is hard to capture in a written instruction alone — showing concrete examples resolves that ambiguity directly.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is a genuine trade-off of adding more few-shot examples to a prompt?',
        options: [
          'There is no trade-off, more examples are always strictly better with no downside',
          'More examples consume more tokens, increasing cost and context window usage',
          'More examples make Claude respond more slowly regardless of token count',
          'Few-shot examples always reduce accuracy'
        ],
        correctIndex: 1,
        explanation:
            'Every additional example adds tokens to the prompt, directly increasing cost and consuming more of the available context window — a genuine trade-off to weigh against the reliability gained.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A prompt grounded in a provided document still occasionally states something not actually present in that document. What best describes this situation?',
        options: [
          'This is impossible once grounding is used',
          'Grounding significantly reduces but does not fully eliminate hallucination risk, so occasional errors can still occur',
          'This means grounding techniques are worthless and should never be used',
          'This only happens at temperature 0'
        ],
        correctIndex: 1,
        explanation:
            'Grounding meaningfully reduces hallucination but does not guarantee zero errors — this is exactly why setting accurate expectations and considering human review remains important.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Does a low temperature setting make Claude\'s writing sound robotic or unnatural?',
        options: [
          'Yes, low temperature always produces broken, unnatural text',
          'No, low temperature reduces randomness in word choice but can still produce natural, well-formed language',
          'Temperature has no effect on writing style at all',
          'Low temperature only works for code, never for prose'
        ],
        correctIndex: 1,
        explanation:
            'Low temperature reduces the randomness in which words are selected, favoring more statistically likely choices — but this does not prevent Claude from producing coherent, natural-sounding writing.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A zero-shot prompt asking Claude to extract phone numbers keeps returning inconsistent formats (some with dashes, some without, some with country codes). What is the most direct fix?',
        options: [
          'Increase the temperature setting',
          'Add 2-3 few-shot examples showing the exact desired phone number format',
          'Switch to a completely different, unrelated task',
          'There is no way to fix this issue'
        ],
        correctIndex: 1,
        explanation:
            'This is a textbook case for few-shot prompting: showing 2-3 concrete examples of the exact desired format directly resolves the format-consistency ambiguity that a plain-language instruction alone left open.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A few-shot prompt includes 3 examples but no written instruction explaining the task at all. What risk does this create?',
        options: [
          'No risk, examples alone are always fully sufficient',
          'Claude may correctly infer the pattern from examples, but subtle reasoning or edge cases the examples do not cover could be misunderstood without an explicit instruction',
          'This will always cause the request to fail completely',
          'Examples without instructions are not permitted by the API'
        ],
        correctIndex: 1,
        explanation:
            'While examples alone can often work, pairing them with an explicit instruction reduces ambiguity for edge cases or reasoning the examples do not directly demonstrate.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Convert a Zero-Shot Prompt to Few-Shot',
      goal:
          'Practice recognizing when zero-shot prompting is insufficient and upgrading it with well-chosen few-shot examples.',
      steps: [
        'Write a zero-shot prompt for a task with a specific output format need (e.g., converting messy addresses into a standard format)',
        'Predict 2 specific ways the zero-shot version might produce inconsistent output',
        'Rewrite the prompt as a few-shot version with exactly 3 well-chosen example input-output pairs',
        'Write 2-3 sentences on why you chose those specific 3 examples (what variety or edge cases they cover)',
      ],
      expectedOutput:
          'Zero-shot prompt, predicted failure modes, upgraded few-shot version with 3 examples, and a short justification for the chosen examples.',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'xml_prompting_l1',
    topicTitle: 'Structuring Prompts with XML Tags',
    careerId: 'claude_engineer',
    categoryId: 'cloud_devops',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '🏷️',
    intro:
        'Claude is specifically trained to pay close attention to XML-style tags in prompts. This simple formatting technique is one of the most reliable ways to organize complex prompts and dramatically reduce ambiguity — let\'s learn it properly.',
    concepts: [
      ConceptLesson(
        title: 'Why Structure Matters in Prompts',
        definition:
            'As prompts grow more complex — combining instructions, context documents, and examples — clearly separating these different parts helps Claude understand exactly which piece of text is which.',
        analogy:
            'Imagine handing someone a single unformatted wall of text mixing your instructions, a reference document, AND an example, all run together with no clear separation — they would have to guess where one part ends and another begins.',
        example:
            'Without structure: "Summarize this in 3 bullets keep it professional here is the document Q3 revenue grew 12%..." — it is genuinely unclear where the instruction ends and the document begins.',
        keyTakeaway:
            'As prompts grow in complexity throughout this roadmap, clear structure stops being a nice-to-have and becomes essential for getting consistent, reliable results.',
      ),
      ConceptLesson(
        title: 'Using XML Tags to Separate Prompt Parts',
        definition:
            'XML-style tags (like <document>, <instructions>, <example>) let you clearly wrap and label different sections of a prompt — and Claude has specifically been trained to recognize and respect this structure.',
        analogy:
            'XML tags are like clearly labelled folders on a desk: one folder says "Instructions," another says "Reference Document," another says "Example." Claude can instantly tell which folder is which, rather than having to guess.',
        example:
            '<instructions>\\nSummarize the document below in exactly 3 bullet points. Keep a professional tone.\\n</instructions>\\n\\n<document>\\nQ3 revenue grew 12% year-over-year, driven primarily by...\\n</document>',
        keyTakeaway:
            'This is one of the single most reliable, low-effort techniques for improving prompt reliability — reach for XML tags any time your prompt combines instructions with a document, examples, or multiple distinct sections.',
      ),
      ConceptLesson(
        title: 'Tag Names Are Flexible — Consistency Matters More',
        definition:
            'There is no fixed, required list of XML tag names — you can name tags descriptively for your specific use case (<contract>, <customer_review>, <output_format>) as long as you are clear and consistent within a given prompt.',
        analogy:
            'Just as you can label your own physical folders however makes sense to you ("2024 Taxes" vs "Tax Documents"), the specific tag names matter less than making sure each one clearly and consistently describes its contents.',
        example:
            'For a legal-document use case: <contract>...</contract> and <question>...</contract> are perfectly good, descriptive tag names — there is no requirement to use generic names like <document> if something more specific fits better.',
        keyTakeaway:
            'Choose tag names that are self-explanatory for your specific task, and use the SAME tag names consistently if you reference that section again later in the prompt or ask Claude to reference it in its output.',
        codeSnippet:
            '<role>\\nYou are a professional contract reviewer.\\n</role>\\n\\n<contract>\\n[full contract text here]\\n</contract>\\n\\n<question>\\nDoes this contract include an automatic renewal clause?\\n</question>',
      ),
      ConceptLesson(
        title: 'Combining XML Structure with Few-Shot Examples',
        definition:
            'XML tags and few-shot examples (from the previous lesson) combine especially well — wrapping each example clearly in its own tags makes even a multi-example few-shot prompt easy for Claude to parse correctly.',
        analogy:
            'This is like organizing several reference samples into clearly labelled folders (<example_1>, <example_2>) rather than piling them all together in one messy stack — easier for anyone, human or Claude, to follow.',
        example:
            '<examples>\\n<example>\\nInput: "Great product, fast shipping!" → Positive\\n</example>\\n<example>\\nInput: "Arrived damaged." → Negative\\n</example>\\n</examples>\\n\\n<input>\\n"It works but instructions were unclear." →',
        keyTakeaway:
            'As your prompts grow to combine multiple techniques from this roadmap — instructions, examples, and documents — XML structure is the organizing "glue" that keeps everything clear and reliable together.',
      ),
      ConceptLesson(
        title: 'Nested and Multiple XML Sections',
        definition:
            'For more complex prompts, XML tags can be nested or used multiple times — for example, wrapping several documents each in their own tag, or nesting an <example> section inside a broader <instructions> block.',
        analogy:
            'This is like using labelled folders within labelled folders — a "Reference Materials" folder might contain several individually labelled sub-folders, keeping even a genuinely complex set of materials easy to navigate.',
        example:
            '<documents>\\n<document_1>[first document text]</document_1>\\n<document_2>[second document text]</document_2>\\n</documents>\\n\\n<question>\\nCompare the two documents above.\\n</question>',
        keyTakeaway:
            'As your Claude Engineer projects grow more sophisticated in later levels — especially Level 5\'s RAG lesson, which often involves multiple retrieved documents — this nested-tagging pattern becomes genuinely essential.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why does using XML-style tags in a prompt genuinely help Claude produce more reliable output?',
        options: [
          'Claude ignores XML tags completely',
          'Claude has been specifically trained to recognize and respect XML tag structure, making it easier to distinguish different parts of a complex prompt',
          'XML tags make prompts shorter',
          'XML tags are only useful for coding tasks, never for text tasks'
        ],
        correctIndex: 1,
        explanation:
            'Claude is specifically trained to pay attention to XML-style structure, making tags a reliable, low-effort way to clearly separate instructions, documents, and examples within a complex prompt.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Is there a fixed, required list of XML tag names you must use with Claude?',
        options: [
          'Yes, only <document> and <instructions> are allowed',
          'No, tag names are flexible — choose descriptive names and use them consistently within a given prompt',
          'Yes, tag names must exactly match a predefined official list',
          'XML tags cannot have custom names at all'
        ],
        correctIndex: 1,
        explanation:
            'There is no required, fixed tag vocabulary. You can choose descriptive tag names that fit your specific use case, as long as you use them clearly and consistently within the prompt.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is a genuine benefit of wrapping each few-shot example in its own XML tags?',
        options: [
          'It makes the prompt use fewer tokens overall',
          'It keeps multiple examples clearly separated and easy for Claude to parse correctly, even as the number of examples grows',
          'It prevents Claude from using few-shot examples at all',
          'It has no real benefit over an unstructured list of examples'
        ],
        correctIndex: 1,
        explanation:
            'Wrapping each example in clear tags keeps them cleanly separated, which becomes increasingly valuable as you combine multiple examples with instructions and documents in more complex prompts.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should few-shot examples typically be paired with an explicit written instruction?',
        options: [
          'Examples alone are always sufficient and instructions are unnecessary',
          'Instructions explain the reasoning and task clearly, while examples remove ambiguity about exact formatting — together they are more reliable than either alone',
          'Combining them always increases errors',
          'Written instructions should never be used alongside examples'
        ],
        correctIndex: 1,
        explanation:
            'Instructions and examples serve complementary purposes — instructions convey the reasoning and general task, while examples pin down specific formatting or subtle judgment calls — combining both is typically most reliable.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why might you use nested or multiple XML tags in a more complex prompt?',
        options: [
          'XML tags cannot be nested or repeated under any circumstances',
          'To clearly organize multiple documents or sections, such as wrapping several separate documents each in their own tag',
          'Nesting tags always confuses Claude and should be avoided',
          'Multiple tags are only used for code generation tasks'
        ],
        correctIndex: 1,
        explanation:
            'Nested or multiple XML tags help organize genuinely complex prompts involving several distinct documents or sections, keeping each part clearly separated and labeled.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are writing a prompt that includes both a long reference document AND a specific question about it. What is the best way to structure this prompt?',
        options: [
          'Combine the document and question into one unbroken paragraph',
          'Wrap the document and question in separate, clearly labelled XML tags (e.g., <document> and <question>)',
          'Put the question first with no labelling, followed by the raw document',
          'XML tags should be avoided for this use case'
        ],
        correctIndex: 1,
        explanation:
            'Wrapping the document and question in separate, clearly labelled tags avoids ambiguity about where one section ends and the other begins — exactly the kind of structure Claude is trained to leverage.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A prompt needs to compare 3 separate customer contracts against each other. What is the best way to structure this using XML tags?',
        options: [
          'Paste all 3 contracts together with no separation at all',
          'Wrap each contract in its own clearly labelled tag (e.g., <contract_1>, <contract_2>, <contract_3>) nested within a broader <contracts> section',
          'XML tags cannot handle more than one document',
          'Use a different, unrelated tag name for each contract with no consistent pattern'
        ],
        correctIndex: 1,
        explanation:
            'Wrapping each contract in its own clearly labelled, consistently structured tag (nested if helpful) keeps multiple documents cleanly organized and easy for Claude to distinguish and compare.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Restructure a Messy Prompt with XML Tags',
      goal:
          'Practice taking an unstructured, ambiguous prompt and rewriting it with clear, well-labelled XML structure.',
      steps: [
        'Write a "messy," unstructured prompt combining an instruction, a short reference document, and one example — all run together with no clear separation',
        'Identify the 3 distinct parts that should be separated',
        'Rewrite the prompt using clear, descriptive XML tags for each part',
        'Write 1-2 sentences on how the restructured version reduces ambiguity compared to the original',
      ],
      expectedOutput:
          'Original messy prompt, identification of its 3 parts, a clean XML-structured rewrite, and a short reflection on the improvement.',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'hallucination_grounding_l1',
    topicTitle: 'Avoiding Hallucination — Grounding Responses',
    careerId: 'claude_engineer',
    categoryId: 'cloud_devops',
    difficulty: 'Easy',
    estimatedMinutes: 22,
    totalXp: 115,
    emoji: '⚓',
    intro:
        'You learned in the very first lesson that LLMs can confidently produce incorrect information. Now you will learn concrete, practical techniques to reduce this — a foundational skill for building any Claude product people can genuinely trust.',
    concepts: [
      ConceptLesson(
        title: 'What is Hallucination, Precisely?',
        definition:
            'Hallucination is when an LLM generates text that is fluent and confident-sounding but factually incorrect, fabricated, or unsupported by any real source — a direct consequence of how token prediction works.',
        analogy:
            'It is like a very well-spoken person confidently answering a trivia question with a wrong but plausible-sounding answer, rather than saying "I am not sure" — the confidence of the delivery has no relationship to its actual accuracy.',
        example:
            'Asked to cite a specific academic paper on a niche topic, an LLM might generate a completely plausible-sounding title, author, and year — that simply does not exist, fabricated because it "sounds like" what a real citation would look like.',
        keyTakeaway:
            'Hallucination is not a rare bug — it is an inherent characteristic of how generative language models work. Every Claude Engineer must design around this reality, not assume it away.',
      ),
      ConceptLesson(
        title: 'Technique 1: Ground Responses in Provided Context',
        definition:
            'The single most effective way to reduce hallucination is to explicitly provide the actual source material in the prompt\'s context, and instruct Claude to answer ONLY based on that provided information.',
        analogy:
            'This is the difference between asking someone to answer purely from memory versus handing them the actual reference document and saying "answer using only what is written here."',
        example:
            'Instead of "What are the terms of our refund policy?" (relying on Claude\'s general knowledge, which it does not have about YOUR specific company), provide: "<policy>[your actual refund policy text]</policy> Based only on the policy above, what are the terms?"',
        keyTakeaway:
            'This "grounding" technique directly connects to Level 5\'s upcoming RAG lesson — providing real source material in context is consistently the strongest defense against hallucination for factual, company-specific tasks.',
      ),
      ConceptLesson(
        title: 'Technique 2: Explicitly Permit "I Don\'t Know"',
        definition:
            'Explicitly instructing Claude that it is acceptable — even preferred — to say "I don\'t know" or "this is not covered in the provided information" measurably reduces confident fabrication.',
        analogy:
            'This is like telling a student before an exam "it is genuinely fine to write \'I am not sure\' rather than guessing" — removing the implicit pressure to always produce a confident-sounding answer reduces the temptation to fabricate one.',
        example:
            'System prompt addition: "If the provided document does not contain the answer, explicitly say so rather than guessing or using outside knowledge."',
        keyTakeaway:
            'This is a genuinely simple, low-cost instruction to add to nearly any Claude prompt handling factual questions — and it consistently improves reliability for a very small amount of extra effort.',
      ),
      ConceptLesson(
        title: 'Technique 3: Ask for Citations or Quotes',
        definition:
            'Instructing Claude to quote or reference the specific part of the provided source material that supports its answer makes fabrication more visible and easier to verify.',
        analogy:
            'This is like requiring someone to point to the exact line in a document that supports their claim, rather than accepting a vague, unsupported assertion — the requirement itself discourages making things up.',
        example:
            '"Answer the question, and include a direct quote from the document supporting your answer" — if Claude cannot produce a genuine supporting quote, that is itself a strong signal the claim may be unreliable.',
        keyTakeaway:
            'Requiring visible evidence for claims is a genuinely powerful technique you will build on heavily in Level 5\'s RAG lesson, where proper citation becomes an essential product feature, not just a nice-to-have.',
      ),
      ConceptLesson(
        title: 'Hallucination Cannot Be Fully Eliminated — Only Reduced',
        definition:
            'Even with strong grounding, explicit "I don\'t know" permission, and citation requirements, hallucination risk can be significantly reduced but never fully eliminated — a genuinely important expectation to set correctly from the start.',
        analogy:
            'This is like defensive driving techniques — following every best practice dramatically reduces your accident risk, but does not reduce it to mathematically zero. Good engineering manages risk; it rarely eliminates it entirely.',
        example:
            'A well-grounded, citation-required customer support bot will hallucinate far less often than an ungrounded one — but a responsible product still includes human review or escalation paths for high-stakes situations, rather than assuming zero errors.',
        keyTakeaway:
            'Setting accurate expectations about hallucination risk — with your team, stakeholders, and users — is itself a genuine professional skill. Never promise a Claude-powered feature is "100% accurate."',
      ),
      ConceptLesson(
        title: 'Grounding Reduces, But Does Not Replace, Good Judgment',
        definition:
            'Even a well-grounded, citation-required prompt still benefits from human review for high-stakes decisions — grounding techniques reduce hallucination risk, but they do not transfer full accountability away from thoughtful system design.',
        analogy:
            'Wearing a seatbelt dramatically reduces injury risk, but a responsible driver does not stop paying attention to the road simply because the seatbelt is on — good technique and good judgment work together, not as substitutes for each other.',
        example:
            'A well-grounded medical-information assistant should still include a clear disclaimer and encourage consulting a real professional for serious decisions, even though grounding significantly improves its factual reliability.',
        keyTakeaway:
            'Treat grounding techniques as risk reduction, not risk elimination — this distinction matters enormously as you design increasingly consequential Claude-powered products later in this roadmap.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is "hallucination" in the context of an LLM like Claude?',
        options: [
          'When the model refuses to answer any question',
          'When the model generates fluent, confident-sounding text that is factually incorrect or fabricated',
          'A hardware malfunction',
          'When the model runs out of context window space'
        ],
        correctIndex: 1,
        explanation:
            'Hallucination refers to confidently generated text that is factually wrong or fabricated — a natural consequence of how token-prediction-based generation works, not a rare malfunction.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the single most effective technique for reducing hallucination on factual, company-specific questions?',
        options: [
          'Increasing the temperature setting',
          'Explicitly providing the actual source material in context and instructing Claude to answer only based on it',
          'Making the prompt as short as possible',
          'Removing the system prompt entirely'
        ],
        correctIndex: 1,
        explanation:
            'Grounding — providing real source material directly in the prompt\'s context and restricting the answer to that material — is consistently the strongest defense against hallucination for factual tasks.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Can hallucination be fully, 100% eliminated through good prompt engineering alone?',
        options: [
          'Yes, with a perfectly written prompt, hallucination becomes mathematically impossible',
          'No — good techniques significantly reduce hallucination risk, but do not reduce it to zero',
          'Hallucination is not actually a real phenomenon',
          'Only by using the highest possible temperature setting'
        ],
        correctIndex: 1,
        explanation:
            'Hallucination risk can be substantially reduced through grounding, explicit uncertainty permission, and citation requirements — but it cannot be fully eliminated, an important expectation to set correctly.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why might you use nested or multiple XML tags when grounding a response in several documents?',
        options: [
          'XML tags cannot be used with grounding at all',
          'To clearly wrap each individual document in its own tag, making it unambiguous which document supports which part of the answer',
          'This has no relevance to hallucination reduction',
          'Only a single document can ever be grounded at once'
        ],
        correctIndex: 1,
        explanation:
            'Clearly labelling each document with its own tag helps both Claude and a human reviewer trace exactly which source supports which claim, directly reinforcing the citation-based grounding technique.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Does using strong grounding techniques mean a Claude-powered product no longer needs human review for high-stakes decisions?',
        options: [
          'Yes, grounding fully eliminates the need for any human oversight',
          'No, grounding reduces hallucination risk but does not replace thoughtful system design and human review for consequential decisions',
          'Grounding techniques have no effect on hallucination risk',
          'Human review is only ever needed if no grounding is used'
        ],
        correctIndex: 1,
        explanation:
            'Grounding techniques meaningfully reduce hallucination risk, but for high-stakes decisions, responsible system design still includes appropriate human review rather than assuming full automation is risk-free.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are building a Claude-powered assistant that answers questions about your company\'s specific internal HR policy. What is the MOST important design choice to reduce hallucination risk?',
        options: [
          'Rely entirely on Claude\'s general training knowledge, with no provided documents',
          'Provide the actual, current HR policy document directly in context and instruct Claude to answer only based on it',
          'Use the highest possible temperature setting',
          'Avoid using a system prompt entirely'
        ],
        correctIndex: 1,
        explanation:
            'Claude has no built-in knowledge of your company\'s specific internal policy. Grounding the response in the actual provided policy document is essential to avoid confident, fabricated answers about company-specific information.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A well-grounded, citation-required medical-information prompt is being used to let the system fully auto-approve treatment decisions with zero human review. What is the concern here?',
        options: [
          'There is no concern, grounding fully eliminates all risk',
          'Even strong grounding does not eliminate all risk; high-stakes decisions like treatment approval still warrant human review, not full automation',
          'Grounding techniques are irrelevant to medical use cases',
          'This is a purely technical decision with no genuine risk considerations'
        ],
        correctIndex: 1,
        explanation:
            'Grounding meaningfully reduces hallucination risk but does not reduce it to zero — for high-stakes, hard-to-reverse decisions, responsible design still includes human review rather than full automation.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build a Hallucination-Resistant Prompt',
      goal:
          'Practice applying all three hallucination-reduction techniques together in a single, realistic, well-grounded prompt.',
      steps: [
        'Choose a realistic scenario requiring factual accuracy (e.g., answering questions about a specific product\'s technical specifications)',
        'Write a short, realistic source document (3-5 sentences) that will be provided in context',
        'Write a complete prompt using XML tags (from the previous lesson) that: grounds the answer in the document, explicitly permits "not covered in the document," and requires a supporting quote',
        'Write one example question this prompt would handle well, and one example question it should correctly refuse to answer (because the document does not cover it)',
      ],
      expectedOutput:
          'Source document, complete grounded prompt with all 3 hallucination-reduction techniques applied, and 2 example questions showing correct in-scope and out-of-scope handling.',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'model_family_l1',
    topicTitle: 'The Claude Model Family — Choosing a Model',
    careerId: 'claude_engineer',
    categoryId: 'cloud_devops',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 110,
    emoji: '🧬',
    intro:
        'Not every task needs the most powerful model available. This lesson teaches you how to think about choosing the right model for the job — a decision that directly affects your product\'s cost, speed, and quality.',
    concepts: [
      ConceptLesson(
        title: 'Why Multiple Model Sizes Exist',
        definition:
            'Anthropic offers multiple Claude models at different capability, speed, and cost tiers, because different real-world tasks have genuinely different requirements — not every task needs maximum reasoning power.',
        analogy:
            'This is like a delivery company offering bicycles, cars, and trucks. Using a truck to deliver a single small envelope is technically possible but genuinely wasteful — the right vehicle depends entirely on the job.',
        example:
            'A simple task like classifying a short customer message as "urgent" or "not urgent" likely does not require the same model tier as generating a nuanced, multi-page legal analysis.',
        keyTakeaway:
            'Model selection is a genuine engineering decision, not just picking "the best one available" by default — matching model capability to task complexity directly affects your product\'s cost and speed.',
      ),
      ConceptLesson(
        title: 'The Capability–Speed–Cost Triangle',
        definition:
            'Across the model family, there is a general trade-off: more capable models tend to be slower and more expensive per token, while smaller, faster models are cheaper and quicker but handle less complex reasoning.',
        analogy:
            'This mirrors choosing between a master craftsman (slower, more expensive, exceptional quality for complex work) and a skilled generalist (faster, cheaper, perfectly capable for straightforward, well-defined tasks).',
        example:
            'A high-volume feature classifying thousands of support tickets per minute into simple categories likely benefits from a faster, cheaper model, while a smaller-volume feature drafting complex legal summaries likely benefits from a more capable one.',
        keyTakeaway:
            'You will revisit this exact capability-speed-cost triangle repeatedly throughout this roadmap, especially in Level 7\'s production-optimization lessons — internalizing it now pays off continuously.',
      ),
      ConceptLesson(
        title: 'Matching Model Choice to Task Complexity',
        definition:
            'A practical way to choose a model is asking: "Does this task require deep, multi-step reasoning, nuanced judgment, or long-context understanding — or is it a simpler, well-defined task with a clear, narrow answer?"',
        analogy:
            'This is genuinely the same judgment a manager uses when assigning work: routine, well-defined tasks go to whoever can do them efficiently; complex, judgment-heavy tasks go to someone with deeper expertise, even if that costs more.',
        example:
            'Simple sentiment classification, basic data extraction, and short summarization often work well with faster, more economical models. Complex multi-step reasoning, nuanced writing, and sophisticated code generation often benefit from a more capable model.',
        keyTakeaway:
            'Start by genuinely testing whether a faster, cheaper model handles your specific task well enough — only reach for a more expensive, more capable model when testing shows you genuinely need the extra capability.',
      ),
      ConceptLesson(
        title: 'Model Choice Is Not Permanent — Plan to Re-Evaluate',
        definition:
            'As Anthropic releases new models over time, and as your product\'s requirements evolve, the "right" model choice for a given feature can and should change — model selection is an ongoing decision, not a one-time setup step.',
        analogy:
            'This is like periodically re-evaluating whether you still need that truck for deliveries, once faster, more efficient vehicles become available — sticking with an old choice out of habit, rather than re-evaluating, wastes genuine opportunity.',
        example:
            'A feature launched using an older model generation might genuinely benefit from re-testing against a newer model release, which could offer better quality, lower cost, or both.',
        keyTakeaway:
            'Building the habit of periodically re-evaluating model choice — rather than "set it and forget it" — is a mark of a genuinely mature Claude Engineer, and you will practice this systematically in Level 8\'s evaluation lessons.',
      ),
      ConceptLesson(
        title: 'Documenting Your Model Selection Reasoning',
        definition:
            'Writing down WHY a specific model tier was chosen for a specific feature (expected volume, complexity, latency needs) creates a genuinely valuable reference for future re-evaluation and team collaboration.',
        analogy:
            'This is similar to a purchasing manager documenting why a specific vendor was chosen — not because the decision is permanent, but because the reasoning becomes valuable context when conditions change and the decision needs revisiting.',
        example:
            'A short note like "Chose the faster/cheaper tier for this classifier because volume is high (50k/day) and the task is simple; re-evaluate if accuracy drops below 95% in production" is genuinely useful documentation.',
        keyTakeaway:
            'This documentation habit connects directly to Level 8\'s evaluation lessons, where systematically tracking model choices and their outcomes becomes an essential, ongoing engineering practice.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why does Anthropic offer multiple Claude models at different capability tiers, rather than just one single model?',
        options: [
          'To confuse developers with too many choices',
          'Because different real-world tasks have genuinely different requirements for capability, speed, and cost',
          'Smaller models are always strictly better in every way',
          'There is only actually one real model, marketed under different names'
        ],
        correctIndex: 1,
        explanation:
            'Different tasks genuinely need different amounts of reasoning power, speed, and cost-efficiency — offering multiple model tiers lets engineers match the right tool to each specific job.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the general trade-off across the capability-speed-cost triangle?',
        options: [
          'More capable models are always faster and cheaper',
          'More capable models tend to be slower and more expensive per token than smaller, faster models',
          'There is no meaningful trade-off between these three factors',
          'Cost has no relationship to model capability'
        ],
        correctIndex: 1,
        explanation:
            'Generally, more capable models involve more computation per response, which tends to mean higher cost and slower response times compared to smaller, faster models.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should model selection be treated as an ongoing decision rather than a one-time setup step?',
        options: [
          'Because new models are released over time and product requirements evolve, making periodic re-evaluation genuinely valuable',
          'Because Claude models never actually change or improve',
          'Model selection only matters once, during initial development',
          'Re-evaluating model choice is never worth the effort'
        ],
        correctIndex: 0,
        explanation:
            'As new model releases become available and product needs evolve, periodically re-evaluating model choice can improve quality, reduce cost, or both — treating it as a one-time decision leaves potential improvements on the table.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A high-volume, simple classification feature and a low-volume, complex legal-reasoning feature exist in the same product. What does the capability-speed-cost triangle suggest?',
        options: [
          'Both features should always use the identical model tier for simplicity',
          'They may reasonably use different model tiers, matched to each feature\'s specific complexity and volume needs',
          'The high-volume feature should always use the most expensive available model',
          'Model tier has no relationship to volume or complexity'
        ],
        correctIndex: 1,
        explanation:
            'The capability-speed-cost triangle suggests matching model tier to task complexity and volume — a high-volume, simple task and a low-volume, complex task often warrant genuinely different model choices.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is documenting the reasoning behind a model selection decision genuinely useful?',
        options: [
          'Documentation is never useful once a model is chosen',
          'It creates a valuable reference for future re-evaluation and team collaboration when conditions or requirements change',
          'Only the final model name matters, never the reasoning',
          'This kind of documentation is only relevant for very large companies'
        ],
        correctIndex: 1,
        explanation:
            'Recording the reasoning behind a model choice (volume, complexity, latency needs) makes future re-evaluation and team collaboration significantly easier when circumstances change.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A product feature classifies 50,000 short support tickets per day into 5 simple categories, with no complex reasoning required. What model choice consideration is MOST important here?',
        options: [
          'Always use the single most capable model available, regardless of cost',
          'Test whether a faster, more cost-efficient model handles this well-defined, high-volume task adequately, given the trade-off triangle',
          'Model choice does not matter for this kind of task',
          'Use the slowest available model to maximize thoroughness'
        ],
        correctIndex: 1,
        explanation:
            'For a high-volume, well-defined classification task, testing a faster and more cost-efficient model is the sensible first step — reaching for maximum capability by default would likely waste cost without a proportional quality benefit.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A team launched a feature 8 months ago using an older Claude model and has never revisited that choice since. What does this lesson suggest?',
        options: [
          'This is ideal and no further action is ever needed',
          'The team should periodically re-evaluate this choice against newer model releases, since requirements and available models both evolve over time',
          'Model choice should never be reconsidered once launched',
          'Older models are always automatically better than newer ones'
        ],
        correctIndex: 1,
        explanation:
            'Treating model selection as a one-time, permanent decision misses potential quality or cost improvements from newer releases — periodic re-evaluation is a mark of mature engineering practice.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Model Selection Decision Brief',
      goal:
          'Practice writing a clear, justified model-selection recommendation for a realistic Claude-powered product.',
      steps: [
        'Describe 3 different realistic features within one product (e.g., a "quick FAQ chatbot," a "complex research report generator," and a "high-volume ticket classifier")',
        'For each feature, note: expected volume, complexity of reasoning required, and latency sensitivity',
        'For each feature, recommend a general model tier (faster/cheaper vs. more capable/expensive) with a 2-3 sentence justification referencing the capability-speed-cost triangle',
        'Write 1-2 sentences on how you would plan to re-evaluate these choices in the future',
      ],
      expectedOutput:
          'A decision brief covering 3 features, each with volume/complexity/latency notes, a model-tier recommendation with justification, and a brief re-evaluation plan.',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'first_api_call_l1',
    topicTitle: 'Your First Claude API Call',
    careerId: 'claude_engineer',
    categoryId: 'cloud_devops',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '🚀',
    intro:
        'Level 1\'s capstone: you will bring every concept from this level together — tokens, system prompts, sampling parameters, and hallucination-resistant grounding — into your very first real, working Claude API call. This is where "Claude Engineer" stops being theory and starts being practice.',
    concepts: [
      ConceptLesson(
        title: 'Anatomy of a Claude API Request',
        definition:
            'A basic Claude API request combines: which model to use, an optional system prompt, the list of conversation messages, sampling parameters (like temperature), and a max_tokens limit — all sent together as one structured request.',
        analogy:
            'This is like filling out a complete, structured order form rather than describing your order verbally — every field has a specific, well-defined purpose, and together they fully specify exactly what you want.',
        example:
            'A request combines: model: "a specific Claude model name", system: "your durable instructions", messages: [the conversation so far], max_tokens: a length cap, and temperature: your randomness setting — all the pieces from this entire level, working together.',
        keyTakeaway:
            'Every single concept from this level — tokens, system vs user messages, sampling parameters — comes together in this one structured request. This lesson is genuinely the synthesis of everything you have learned so far.',
        codeSnippet:
            '// Conceptual request structure (pseudocode, language-agnostic)\n{\n  "model": "claude-model-name",\n  "system": "You are a concise, helpful assistant.",\n  "messages": [\n    {"role": "user", "content": "Explain photosynthesis in 2 sentences."}\n  ],\n  "max_tokens": 150,\n  "temperature": 0.3\n}',
      ),
      ConceptLesson(
        title: 'Reading the API Response',
        definition:
            'Claude\'s API response includes the generated text content, along with useful metadata like the number of input and output tokens used and the reason generation stopped (e.g., naturally finished, or hit the max_tokens limit).',
        analogy:
            'This is like receiving not just the finished product from a factory, but also a receipt showing exactly how many raw materials were used and confirmation of why production stopped when it did.',
        example:
            'A response might include: the actual generated text, usage: {input_tokens: 45, output_tokens: 38}, and stop_reason: "end_turn" (meaning Claude finished its thought naturally, rather than being cut off).',
        keyTakeaway:
            'Understanding the response structure — not just the generated text — lets you track cost (via token usage) and diagnose issues (like responses being cut off due to max_tokens) from Level 1 onward.',
      ),
      ConceptLesson(
        title: 'Applying Grounding and Structure to a Real Call',
        definition:
            'A genuinely well-engineered first API call combines this level\'s techniques together: a clear system prompt, XML-structured context, appropriate sampling settings, and hallucination-resistant instructions — not just a bare, unstructured question.',
        analogy:
            'This is the difference between a beginner\'s first attempt at a recipe versus a chef genuinely applying every technique they have learned, combined together, in one dish — the SAME ingredients, used with genuine skill.',
        example:
            'A well-engineered call for a document Q&A tool: system prompt establishing the role, <document> tags wrapping the source text, low temperature for factual consistency, and an explicit "say so if not covered" instruction — all four Level 1 techniques applied together.',
        keyTakeaway:
            'From your very first real API call onward, apply these techniques deliberately, together — this habit, built from Level 1, is what separates careful Claude Engineering from simply "typing a question into a text box."',
      ),
      ConceptLesson(
        title: 'Iterating on Your First Prompt',
        definition:
            'Your first version of any real prompt is rarely your best version — genuine prompt engineering is an iterative process of testing, observing failures, and refining, not a one-shot, "write it once and done" activity.',
        analogy:
            'This mirrors how a writer rarely publishes their very first draft — the first version gets you started, but genuine quality comes from reviewing the output, noticing what is off, and deliberately refining from there.',
        example:
            'If your first version of a summarization prompt produces summaries that are too long, the deliberate fix (adjusting max_tokens, adding an explicit length instruction, or adding a few-shot example of the right length) is a normal, expected part of the process — not a sign of failure.',
        keyTakeaway:
            'Expect to iterate. This mindset — test, observe, refine — is the foundation of prompt engineering that you will formalize much further in Level 2\'s dedicated prompt engineering fundamentals lesson.',
      ),
      ConceptLesson(
        title: 'Documenting Your First Prompt Design',
        definition:
            'Writing down WHY you made specific choices in your first prompt (why this temperature, why this structure, why this instruction) creates a genuinely valuable reference for future iteration and for collaborating with teammates.',
        analogy:
            'This is like a scientist keeping a lab notebook — not because every experiment needs to be perfect, but because recording your reasoning makes it possible to learn from, repeat, and improve on what you tried.',
        example:
            'A short note like "Used temperature 0.2 because this is a factual extraction task; added explicit \'say I don\'t know\' instruction after observing occasional fabricated answers in testing" is genuinely valuable documentation.',
        keyTakeaway:
            'Building this documentation habit from your very first API call sets you up well for Level 8\'s evaluation and testing lessons, where systematic tracking of prompt versions becomes essential.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which of these is a required part of a basic Claude API request?',
        options: [
          'A pre-written response from Claude',
          'The list of conversation messages',
          'A screenshot of the chat interface',
          'A separate database connection'
        ],
        correctIndex: 1,
        explanation:
            'The messages array (containing the conversation, including at least one user message) is a core, required part of a Claude API request, along with specifying which model to use.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does the "stop_reason" field in an API response tell you?',
        options: [
          'How many tokens the response used',
          'Why generation stopped, such as finishing naturally versus hitting the max_tokens limit',
          'The temperature setting that was used',
          'Whether the request was billed correctly'
        ],
        correctIndex: 1,
        explanation:
            'The stop_reason field indicates WHY generation ended — for example, "end_turn" (Claude finished naturally) versus being cut off because it reached the max_tokens limit, which is useful for diagnosing truncated responses.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is prompt engineering described as an iterative process rather than a one-shot activity?',
        options: [
          'Because the very first version of a prompt is always already perfect',
          'Because testing, observing output, and refining is normal and expected — the first version rarely produces the ideal result immediately',
          'Because Claude requires prompts to be rewritten every single time it is used',
          'Iteration is not actually a real part of prompt engineering'
        ],
        correctIndex: 1,
        explanation:
            'Just like drafting any piece of writing, prompt engineering typically requires testing an initial version, observing where it falls short, and deliberately refining it — this iterative loop is a normal, expected part of the process.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is it valuable to document the reasoning behind your first prompt design choices?',
        options: [
          'Documentation is never useful for prompt engineering work',
          'It creates a genuinely valuable reference for future iteration, debugging, and collaborating with teammates',
          'Only the final prompt matters, not the reasoning behind it',
          'Documentation should be avoided to keep prompts secret'
        ],
        correctIndex: 1,
        explanation:
            'Recording why specific choices were made (temperature, structure, instructions) creates a valuable reference for future refinement and makes it far easier to collaborate with others or debug issues later.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is testing a first prompt against multiple realistic example inputs (not just one) a good practice, even at the very first API call?',
        options: [
          'Testing multiple inputs is unnecessary if the first test happens to succeed',
          'A single successful test does not guarantee the prompt handles the range of realistic inputs it will actually encounter in production',
          'Multiple tests always cost the exact same as one test with no trade-off',
          'This practice only matters for few-shot prompts'
        ],
        correctIndex: 1,
        explanation:
            'One successful test does not confirm robustness across the range of realistic inputs a feature will actually face — testing multiple varied examples early builds genuine confidence before relying on a prompt in production.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your first API call for a document-summarization tool returns summaries that are consistently cut off mid-sentence. Based on this level\'s concepts, what is the MOST likely cause and fix?',
        options: [
          'The temperature is set incorrectly and must be fixed first',
          'The response likely hit the max_tokens limit; increasing max_tokens or shortening the requested summary length is the most direct fix',
          'This cannot be fixed and the model must be changed entirely',
          'The system prompt should be removed entirely'
        ],
        correctIndex: 1,
        explanation:
            'A response cut off mid-sentence is a classic sign of hitting the max_tokens limit. Checking the stop_reason field would confirm this, and the direct fix is increasing max_tokens or explicitly requesting a shorter output.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Two teammates each independently write a prompt for the same task, but neither documents their reasoning. Months later, one prompt performs noticeably better. What genuine problem does this create?',
        options: [
          'No problem, undocumented prompts are just as easy to improve as documented ones',
          'Without documented reasoning, it becomes much harder to understand WHY the better prompt works, making future iteration and knowledge-sharing more difficult',
          'Documentation has no relationship to prompt engineering quality',
          'This situation could never realistically happen'
        ],
        correctIndex: 1,
        explanation:
            'Without documented reasoning behind design choices, it becomes significantly harder to understand, replicate, or build on what made one prompt more effective — a habit worth building from your very first prompt.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Level 1 Capstone: Design Your First Complete API Call',
      goal:
          'Synthesize every concept from Level 1 — tokens, system prompts, sampling parameters, zero/few-shot, XML structure, and hallucination grounding — into one complete, well-engineered, realistic API request design.',
      steps: [
        'Choose a realistic first project: a document Q&A tool that answers questions ONLY based on a provided short document',
        'Write the complete system prompt, establishing role, tone, and the explicit "say so if not covered" hallucination-reduction instruction',
        'Write the full user message using XML tags to clearly separate the <document> from the <question>',
        'Choose and justify an appropriate temperature setting and max_tokens value for this specific task',
        'Estimate the rough total token cost of one request (document + question + system prompt + expected response length) using the estimation skill from the tokens lesson',
        'Write one example question this design handles well, and one it should correctly decline to answer',
      ],
      expectedOutput:
          'A complete, structured API call design: system prompt, XML-structured user message, justified temperature and max_tokens choices, a rough token cost estimate, and 2 example questions demonstrating correct grounded and refused behaviour.\n\n=== LEVEL 1 COMPLETE — CLAUDE ENGINEER FOUNDATIONS MASTERED ===\nYou now understand how LLMs work, how Claude reads and generates text, and how to write your first well-engineered, grounded prompt. Level 2 builds directly on this foundation with deeper prompt engineering techniques.',
      xpReward: 90,
    ),
  ),
];
