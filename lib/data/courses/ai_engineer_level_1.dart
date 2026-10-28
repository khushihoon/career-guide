// ══════════════════════════════════════════════════════════════════════
// lib/models/ai_engineer_level_1.dart
// AI Engineer Learning Path — LEVEL 1: AI Foundations
// ══════════════════════════════════════════════════════════════════════
import '../../models/course_content_data.dart';

const List<TopicCourse> aiEngineerLevel1 = [
  TopicCourse(
    id: 'aep_l1_what_is_ai',
    topicTitle: 'What is Artificial Intelligence?',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 180,
    emoji: '🤖',
    intro:
        'Artificial Intelligence is the most transformative technology of the 21st century — powering everything from the recommendations on your phone to self-driving cars and medical diagnosis systems. Before you can build AI, you need to deeply understand what it actually is, how it thinks, and why it matters. This course gives you that foundation.',
    concepts: [
      ConceptLesson(
        title: 'What is Artificial Intelligence?',
        definition:
            'Artificial Intelligence (AI) is the science of creating computer systems that can perform tasks which normally require human intelligence — such as recognising speech, making decisions, translating languages, and understanding images.',
        analogy:
            'AI is like teaching a very fast, tireless student who has read every book ever written. Give them a task — identify a cat in a photo, translate a sentence, predict tomorrow\'s weather — and they apply patterns learned from millions of examples to give you an answer.',
        example:
            'AI in your daily life right now:\n\nGoogle Search: understands what you MEAN, not just words\nGmail Smart Reply: suggests reply before you type it\nSpotify/YouTube: knows your taste better than friends do\nSwiggy/Zomato: predicts your delivery time to the minute\nGPay fraud detection: blocks suspicious transactions instantly\nFace Unlock: recognises your face in milliseconds in the dark',
        keyTakeaway:
            'AI is not science fiction — it is pattern recognition at massive scale. Every AI system learns from data, finds patterns, and uses those patterns to make predictions or decisions on new inputs.',
      ),
      ConceptLesson(
        title: 'How AI Thinks — Patterns, Not Rules',
        definition:
            'Traditional software follows explicit rules programmed by humans. AI systems learn rules AUTOMATICALLY from data — nobody hand-codes every rule for recognising a cat or translating Hindi to English.',
        analogy:
            'Traditional programming is like giving someone a precise recipe with every step spelled out. AI is like a child who has seen 10,000 fruits and learned to recognise apples without anyone ever writing the rules explicitly.',
        example:
            'Traditional rule-based spam detection:\n  IF email contains "FREE MONEY" → SPAM\n  IF email contains "Nigerian prince" → SPAM\n  Fails the moment spammers change wording\n\nAI spam detection:\n  Train on 10 million labelled emails\n  AI learns subtle patterns automatically\n  Catches new spam variations without rule updates',
        keyTakeaway:
            'The fundamental shift of AI: instead of programming rules, you provide DATA and the AI discovers the rules itself. This is why AI improves as it sees more data — more patterns to learn from.',
      ),
      ConceptLesson(
        title: 'The Three Components Every AI System Needs',
        definition:
            'Every AI system requires three things: DATA (examples to learn from), an ALGORITHM (the learning method), and COMPUTE (processing power to train and run the model).',
        analogy:
            'Building an AI is like training a chef: DATA is the recipes they study, the ALGORITHM is the training curriculum, and COMPUTE is the kitchen time and equipment needed to practise thousands of dishes.',
        example:
            'AI that detects diseases in X-rays:\n\nDATA:\n  100,000 labelled X-ray images\n  Each labelled: "normal" or "pneumonia"\n\nALGORITHM:\n  Convolutional Neural Network (CNN)\n  Learns visual patterns distinguishing healthy vs diseased\n\nCOMPUTE:\n  8 NVIDIA GPUs running for 3 days\n  Processes each image thousands of times',
        keyTakeaway:
            'When an AI product fails, the root cause is almost always one of these three: not enough quality data, wrong algorithm, or insufficient compute. Good AI engineers diagnose which pillar is weak.',
      ),
      ConceptLesson(
        title: 'Narrow AI vs General AI — Where We Are Today',
        definition:
            'Narrow AI (Weak AI) is highly capable at ONE specific task. General AI (Strong AI) can reason across any domain like a human. All AI that exists today — including GPT-4 and Gemini — is Narrow AI.',
        analogy:
            'Today\'s best AI is like world-champion specialists: one chess champion, one translation champion, one image recognition champion. Unbeatable in their skill but cannot do each other\'s jobs. General AI would be the all-rounder champion at everything simultaneously.',
        example:
            'Narrow AI in practice:\n  AlphaGo: beats world champions at Go but cannot play Chess\n  GPT-4: writes code and essays but cannot drive a car\n  Siri: answers voice questions but cannot diagnose diseases\n\nGeneral AI (does NOT exist yet):\n  Would learn ANY task from minimal examples\n  Would transfer knowledge across completely different domains\n  Would reason about situations never encountered before',
        keyTakeaway:
            'Even the most impressive AI systems like ChatGPT are sophisticated pattern matchers trained on massive data — not human-like general intelligence. Understanding this distinction is critical for every AI engineer.',
      ),
      ConceptLesson(
        title: 'Intelligence vs Automation — The Key Difference',
        definition:
            'AI is not the same as simple automation. Automation follows fixed scripts. AI handles variability, uncertainty, and novel situations — it generalises from examples rather than executing predefined steps.',
        analogy:
            'A vending machine (automation) gives a specific product when you press a specific button — no thinking required. An AI assistant understands "I want something cold and sweet" even if you have never said that before, recommending options based on context and preferences.',
        example:
            'Automation vs AI:\n\nAutomation:\n  ATM dispenses money when PIN matches → fixed flow\n  Email filter moves newsletter to folder → explicit rule\n\nAI:\n  ChatGPT answers any question in any language → handles novelty\n  Tesla Autopilot navigates unforeseen road situations → adapts\n  AlphaFold predicts protein structures never seen → generalises',
        keyTakeaway:
            'Automation replaces repetitive human tasks with scripts. AI replaces cognitive tasks — recognising, reasoning, predicting, and deciding in situations that were never explicitly programmed.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the fundamental difference between traditional programming and AI?',
        options: [
          'AI is always faster than traditional programming',
          'Traditional programming uses explicit rules written by humans; AI learns rules automatically from data',
          'AI only works with images; traditional programming works with text',
          'AI requires internet; traditional programming does not'
        ],
        correctIndex: 1,
        explanation:
            'Traditional programming: programmer writes rules → computer follows them. AI: programmer provides data → AI discovers rules itself. This shift from rule-writing to data-providing is the core paradigm of AI.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which of these is an example of Narrow AI?',
        options: [
          'An AI that can do anything a human can do',
          'ChatGPT answering questions — excellent at language tasks but cannot drive a car or interact with the physical world',
          'A robot that thinks, feels, and has consciousness',
          'A calculator that does arithmetic'
        ],
        correctIndex: 1,
        explanation:
            'ChatGPT is Narrow AI — extremely capable at language tasks but has no capability outside its specific domain. A calculator is not AI (follows fixed rules). True General AI does not exist yet.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What are the three components every AI system needs?',
        options: [
          'Internet, a laptop, and Python',
          'Data (examples), Algorithm (learning method), and Compute (processing power)',
          'Rules, a programmer, and a database',
          'Camera, microphone, and speaker'
        ],
        correctIndex: 1,
        explanation:
            'Every AI system needs: Data to learn from, an Algorithm to define how learning happens, and Compute to power training and inference. Missing or weak any one limits AI performance.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your phone suggests the next word as you type "Happy Birth...". Is this traditional programming or AI? Why?',
        options: [
          'Traditional programming — it follows a simple rule to suggest common words',
          'AI — it learned from millions of messages to predict likely next words for YOUR specific typing patterns and context',
          'Neither — it just looks up a dictionary',
          'Traditional programming — someone coded every possible word combination'
        ],
        correctIndex: 1,
        explanation:
            'Predictive text is AI — it learned from massive text corpora and personalises to your typing history. No human programmed "after Happy Birth suggest day". The model discovered this pattern from data.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A bank blocks ALL transactions from Nigeria saying "all transactions from Nigeria are risky." Is this AI?',
        options: [
          'Yes — it made a smart automatic decision',
          'No — this is simple rule-based automation. Real AI fraud detection analyses hundreds of signals (behaviour, device, amount, time) to make nuanced per-transaction decisions',
          'Yes — blocking transactions requires intelligence',
          'Cannot determine without more information'
        ],
        correctIndex: 1,
        explanation:
            'Blocking all transactions from a country is a hardcoded rule — automation, not AI. Real AI fraud detection learns from millions of transactions and distinguishes legitimate travel from actual fraud using nuanced patterns without blanket rules.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'AI in My Life — Discovery Project',
      goal:
          'Identify, analyse, and document 10 AI systems you interact with daily, understanding what each one does and what makes it AI.',
      steps: [
        'List 10 apps or services you used today (phone, apps, websites, devices)',
        'For each: Is there AI involved? What specific task does the AI perform?',
        'For 3 of them: identify the likely DATA it was trained on and what PATTERNS it learned',
        'Find one example where an AI gave you a bad or surprising result — what went wrong?',
        'Research one Indian AI company (Sarvam AI, Krutrim, Yellow.ai, Uniphore) and describe what AI they build',
        'Write a paragraph: How would your day be different if all AI was removed from your life?',
      ],
      expectedOutput:
          'AI Discovery Report:\n10 AI systems identified:\n  1. YouTube recommendations — learns watch history patterns\n  2. Google Maps ETA — predicts traffic using real-time data\n  3. Paytm fraud detection — flags unusual transaction patterns\n  ...\nBad AI example: Spotify recommended a genre I hate\nIndian AI company: Sarvam AI builds LLMs for Indian languages\nLife without AI: navigation would be paper maps, music discovery manual...',
      xpReward: 45,
    ),
  ),
  TopicCourse(
    id: 'aep_l1_history_of_ai',
    topicTitle: 'History & Evolution of AI',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 185,
    emoji: '📜',
    intro:
        'AI did not appear overnight. It has a 70-year history of brilliant ideas, devastating failures, and unexpected breakthroughs. Understanding this history teaches you WHY modern AI is built the way it is, what has failed before, and what patterns of progress to expect in the future.',
    concepts: [
      ConceptLesson(
        title: 'The Birth of AI (1950s) — Turing and Dartmouth',
        definition:
            'Modern AI was born at the 1956 Dartmouth Conference where John McCarthy coined the term "Artificial Intelligence." Alan Turing had already proposed the Turing Test in 1950 — a benchmark for machine intelligence.',
        analogy:
            'The Dartmouth Conference was AI\'s founding moment — like visionaries sitting around a table saying "let\'s build flying machines" before aeroplanes existed. Right about the destination but drastically underestimating the journey.',
        example:
            'Key 1950s milestones:\n\n1950: Alan Turing — "Computing Machinery and Intelligence"\n      Proposes the Turing Test: "Can a machine fool\n      a human into thinking it is also human?"\n\n1956: Dartmouth Conference — McCarthy, Minsky,\n      Shannon gather to study AI formally\n      "We propose a 2-month study to find how to make\n      machines use language and solve human problems"\n\n1957: First neural network — Frank Rosenblatt\'s\n      Perceptron learns to classify simple images',
        keyTakeaway:
            'The founders of AI believed they could build human-level intelligence in ONE SUMMER. This overconfidence created a boom-bust pattern that has repeated throughout AI history — and continues today.',
      ),
      ConceptLesson(
        title: 'AI Winters — When AI Failed (1970s and 1980s)',
        definition:
            'AI Winters were periods of dramatically reduced funding caused by overpromising and underdelivering. Two major winters: 1974-1980 and 1987-1993.',
        analogy:
            'An AI Winter is like a stock market crash after massive hype. Investors poured in money based on promises. When promises failed, funding dried up completely — like a harsh winter that kills everything that was thriving.',
        example:
            'First AI Winter (1974-1980):\n  PROMISE: "Translate Russian to English in 3-5 years"\n  REALITY: 20 years later machines still failed on\n            simple ambiguous sentences\n  RESULT: US and UK governments cut all AI funding\n\nSecond AI Winter (1987-1993):\n  PROMISE: Expert Systems would replace human experts\n  REALITY: Too brittle, required endless manual updates\n  RESULT: Billions lost, "AI" became a dirty word\n           in research funding circles',
        keyTakeaway:
            'AI Winters teach the most important lesson: be honest about capabilities and limitations. Overpromising AI creates backlash that sets entire fields back by decades. The best AI engineers are realistic, not hype-driven.',
      ),
      ConceptLesson(
        title: 'The Machine Learning Revolution (1990s-2000s)',
        definition:
            'In the 1990s AI shifted from hand-coded rules to statistical learning from data — the birth of modern Machine Learning. This quiet revolution laid the foundation for everything that followed.',
        analogy:
            'The ML revolution was like switching from hand-painting maps to photography — instead of manually drawing every detail, you capture reality directly from data. Less artistry, more accuracy, infinitely scalable.',
        example:
            '1997: IBM Deep Blue defeats chess world champion\n      Kasparov — by searching millions of positions\n      statistically, not by "thinking"\n\n1998: LeNet — Yann LeCun\'s neural network reads\n      handwritten zip codes for US Postal Service\n\n2006: Netflix Prize — \$1M contest to improve movie\n      recommendations by 10%\n\n2009: ImageNet — 14M labelled images created\n      This dataset would spark the Deep Learning\n      revolution 3 years later',
        keyTakeaway:
            'The 1990s shift from "program the rules" to "learn from data" is the most important paradigm shift in AI history. Every modern AI system — GPT, Gemini, Stable Diffusion — is built on this foundation.',
      ),
      ConceptLesson(
        title: 'The Deep Learning Explosion (2012-Present)',
        definition:
            'In 2012, AlexNet won the ImageNet competition by a massive margin using deep neural networks and GPUs — launching the Deep Learning era that transformed every field of AI.',
        analogy:
            'The 2012 AlexNet moment was like the Wright Brothers first flight — something theoretically possible but practically failing for decades suddenly worked dramatically. Everyone immediately understood nothing would be the same.',
        example:
            '2012: AlexNet wins ImageNet — 15.3% error vs 26%\n      for second place. Deep Learning wins.\n2016: AlphaGo defeats Lee Sedol at Go\n2017: Transformer architecture invented at Google —\n      foundation of every modern LLM\n2020: GPT-3 launches — AI writes like a human\n2022: ChatGPT reaches 100M users in 2 months —\n      fastest product adoption in history\n2023: GPT-4, Gemini, Claude — multimodal AI\n2024: AI agents, video generation, LLMs on phones',
        keyTakeaway:
            'We are living through the most rapid technological transformation in history. Models that shock the world today will be considered primitive in 3 years. An AI engineer must keep learning continuously.',
      ),
      ConceptLesson(
        title: 'India\'s AI Journey',
        definition:
            'India has become a major player in the global AI ecosystem — with the world\'s largest AI talent pool, growing AI startups, government AI missions, and unique challenges driving local AI innovation.',
        analogy:
            'India\'s AI position is like arriving at exactly the right time for the AI revolution — with a massive educated workforce, 1.4 billion users generating unique data, and problems that drive globally relevant innovation.',
        example:
            'India in AI:\n\nTalent: India produces 1.5M engineering graduates/year\n        Indian engineers lead AI teams at Google,\n        Microsoft, OpenAI, Meta, Amazon\n\nStartups: Sarvam AI (Indian language LLMs)\n          Krutrim (Ola\'s AI company)\n          Yellow.ai (conversational AI)\n          Uniphore (voice AI)\n\nGovernment: India AI Mission (10,000 GPU cluster)\n            Bhashini: AI translation across 22 languages\n\nOpportunity: 22 languages, 11 scripts — unique\n             low-resource language AI challenge',
        keyTakeaway:
            'India is not just consuming AI — it is building it. The next breakthroughs for low-resource languages, agricultural AI, and healthcare AI for underserved populations will come significantly from Indian engineers.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What caused the first AI Winter in the 1970s?',
        options: [
          'Computers were too slow to run AI programs',
          'AI researchers overpromised results and failed to deliver, causing government funding to be completely cut',
          'The internet had not been invented yet',
          'AI was banned by government regulations'
        ],
        correctIndex: 1,
        explanation:
            'The first AI Winter was caused by the gap between promises and results — particularly in machine translation and general problem solving. When promises did not materialise, funding dried up completely.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What happened in 2012 that launched the Deep Learning era?',
        options: [
          'ChatGPT was released to the public',
          'AlexNet dramatically outperformed all approaches on ImageNet using deep neural networks and GPUs',
          'The first smartphone with AI was released',
          'Google was founded and started using AI for search'
        ],
        correctIndex: 1,
        explanation:
            'AlexNet achieved 15.3% error on ImageNet vs 26% for the next best approach — proving deep neural networks were fundamentally superior. This moment launched the modern AI era.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the 2017 Transformer architecture power today?',
        options: [
          'Electric cars and energy grids',
          'All major Large Language Models including GPT-4, Gemini, Claude, and LLaMA',
          'Only image generation tools like DALL-E',
          'Robotics and physical automation systems'
        ],
        correctIndex: 1,
        explanation:
            'The Transformer (from "Attention Is All You Need" paper, Google 2017) is the foundational architecture behind every major LLM today — GPT, Gemini, Claude, LLaMA, Mistral, and hundreds more.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A tech CEO says "Our AI will achieve human-level intelligence within 2 years." Based on AI history, how should you evaluate this claim?',
        options: [
          'Believe it — AI is advancing very fast now',
          'Be sceptical — history shows AI timelines are consistently overestimated. Evaluate specific benchmarks, not broad claims',
          'Ignore it — AI will never reach human-level intelligence',
          'Accept it — CEOs always have insider information'
        ],
        correctIndex: 1,
        explanation:
            'AI history repeatedly shows bold predictions failing: general translation in 5 years (took 60+), expert systems replacing doctors (failed), self-driving in 2 years (still not there). Evaluate specific capability claims, not grand timelines.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Why was creating the ImageNet dataset (14M labelled images, 2009) considered as important as inventing a new algorithm?',
        options: [
          'It was not important — algorithms matter more than data',
          'High-quality labelled data is the fuel for AI. Without ImageNet, deep learning could not be trained or benchmarked — data enabled the entire 2012 revolution',
          'Because it was created by Stanford University',
          'Because it contained exactly 14 million images'
        ],
        correctIndex: 1,
        explanation:
            'ImageNet proved that data is as important as algorithms. The dataset enabled fair comparison, drove competition, and gave researchers the fuel to train deep networks. Without it, the 2012 AlexNet breakthrough might have been delayed by years.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'AI Timeline — India and the World',
      goal:
          'Create a visual AI history timeline combining global milestones with India-specific AI developments.',
      steps: [
        'Research and list 10 global AI milestones from 1950 to 2024 — one per significant year',
        'Research and list 5 India-specific AI milestones (company launches, government initiatives, breakthroughs)',
        'For each global milestone, write: what was promised, what was delivered, and what lesson it teaches',
        'Identify 3 moments where AI hype clearly exceeded reality and explain the consequences',
        'Identify 3 moments where AI surprised even experts — what made those breakthroughs unexpected?',
        'Write a 100-word prediction: what AI milestone do you expect in India in the next 3 years and why?',
      ],
      expectedOutput:
          'AI Timeline Document:\nGlobal milestones (10 entries):\n  1956: Dartmouth Conference — promised AI in 1 summer\n  1997: Deep Blue beats Kasparov — narrow AI dominance\n  2012: AlexNet — deep learning becomes dominant...\nIndia milestones (5 entries):\n  2023: Krutrim founded by Ola\'s Bhavish Aggarwal\n  2024: India AI Mission — 10,000 GPU compute cluster...\n3 hype vs reality gaps identified ✓\n3 surprising breakthroughs analysed ✓\nPersonal prediction written ✓',
      xpReward: 45,
    ),
  ),
  TopicCourse(
    id: 'aep_l1_types_of_ai',
    topicTitle: 'Types of AI (ANI, AGI, ASI)',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 180,
    emoji: '🧩',
    intro:
        'Not all AI is the same. From the recommendation engine on Netflix to hypothetical superintelligent machines, AI spans a vast spectrum of capability. Understanding the three fundamental types — ANI, AGI, and ASI — is essential vocabulary for any AI professional, and shapes how you approach AI projects and evaluate AI tools.',
    concepts: [
      ConceptLesson(
        title: 'ANI — Artificial Narrow Intelligence (Where We Are)',
        definition:
            'Artificial Narrow Intelligence (ANI) is AI designed to perform ONE specific task extremely well. All AI systems that exist today are ANI — no matter how impressive they appear.',
        analogy:
            'ANI is like Olympic gold medalists — each the absolute best in their specific event. The sprint champion cannot compete in swimming. The weightlifting champion cannot run a marathon. Extraordinary specialists, zero versatility.',
        example:
            'ANI examples:\n\nLanguage: GPT-4 generates text — cannot see images alone\nVision: Tesla Autopilot reads roads — cannot write emails\nGame: AlphaGo beats world Go champions — cannot play Chess\nMedical: AI detects cancer in scans — cannot diagnose\n         from conversation\nFinance: AI predicts stock patterns — cannot drive a car\n\nEven ChatGPT is ANI:\n  Writes code, essays, answers → yes\n  Physically interact with world → no\n  Learns permanently from a conversation → no',
        keyTakeaway:
            'Even systems that seem incredibly general (GPT-4) are still narrow — pattern matchers trained on text. They cannot learn new skills permanently, cannot act in the physical world, and cannot reason about truly novel situations.',
      ),
      ConceptLesson(
        title: 'AGI — Artificial General Intelligence (The Goal)',
        definition:
            'Artificial General Intelligence (AGI) is AI that can perform any intellectual task a human can — learning new skills from minimal examples, transferring knowledge across domains, and reasoning about novel situations.',
        analogy:
            'AGI is like a brilliant human who picks up a violin for the first time and within a week plays professionally — then learns a new language the next week, masters chess, then writes a novel. That fluid generalisation across any domain is AGI.',
        example:
            'What AGI would be able to do:\n  → Learn to play ANY game from the rules in minutes\n  → Read a medical textbook and immediately diagnose\n    patients with zero prior medical training data\n  → Understand and generate any human language\n    after 1 hour of exposure\n  → Solve problems in domains that never existed before\n\nCurrent status: Does NOT exist.\nExpert estimates: 2030-2075+ (huge disagreement)\n\nKey question: Is it a matter of more compute,\n             or do we need fundamentally new ideas?',
        keyTakeaway:
            'AGI is the goal that has driven AI research for 70 years and remains elusive. The gap between today\'s best ANI and AGI is not just a matter of more data or faster computers — researchers genuinely disagree on what is missing.',
      ),
      ConceptLesson(
        title: 'ASI — Artificial Superintelligence (The Speculation)',
        definition:
            'Artificial Superintelligence (ASI) is hypothetical AI that surpasses human intelligence in EVERY domain — science, creativity, social skills — by potentially enormous margins.',
        analogy:
            'ASI would be to human intelligence what human intelligence is to an ant — not just smarter in degree, but smarter in a completely different dimension. An ant cannot comprehend what humans build; humans might similarly struggle to comprehend what ASI would create.',
        example:
            'What ASI might theoretically do:\n\nScience: Solve in hours problems taking scientists\n         decades (cancer cure, fusion energy)\n\nTechnology: Design its own improved successors,\n            accelerating intelligence exponentially\n\nRisk: Could pursue goals misaligned with human\n      values unless carefully designed\n\nCurrent status: Pure speculation. No timeline.\nKey thinkers:\n  Nick Bostrom, Eliezer Yudkowsky (deeply concerned)\n  Yann LeCun (sceptical it is even possible)',
        keyTakeaway:
            'ASI should be understood conceptually but should not dominate your thinking as a practising AI engineer. Your career will be built entirely on ANI systems. Understanding ASI matters for long-term AI safety thinking.',
      ),
      ConceptLesson(
        title: 'Four Capability Levels of AI',
        definition:
            'Beyond ANI/AGI/ASI, AI researchers classify systems by capability: Reactive (responds to current input only), Limited Memory (uses past data), Theory of Mind (models others\' beliefs), and Self-Aware (has consciousness).',
        analogy:
            'These four levels mirror human social development: a newborn reacts to stimuli (reactive), a toddler remembers past events (limited memory), a school child understands others think differently (theory of mind), an adult is fully self-aware.',
        example:
            '1. REACTIVE AI:\n   Responds only to current input, no memory\n   Example: Deep Blue — each move evaluated fresh\n   Example: Basic spam filters\n\n2. LIMITED MEMORY AI (where most AI is today):\n   Uses past data to inform current decisions\n   Example: Self-driving cars use recent sensor data\n   Example: ChatGPT uses conversation context\n   Example: Netflix remembers your watch history\n\n3. THEORY OF MIND AI (emerging research):\n   Understands others have different beliefs\n   Still largely in research stage\n\n4. SELF-AWARE AI:\n   Has consciousness, emotions, self-concept\n   Does not currently exist',
        keyTakeaway:
            'Most production AI is Level 2 (Limited Memory). When evaluating any AI system, asking "which capability level?" immediately clarifies what it can and cannot do — far more practically useful than the ANI/AGI distinction.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'GPT-4 can write code, poems, essays, and explain science — does this make it AGI?',
        options: [
          'Yes — it can do so many different things',
          'No — it is still ANI. Trained on text data across many domains but cannot learn permanently or reason about truly novel situations outside its training',
          'Yes — AGI just means doing many different tasks',
          'It depends on how you define intelligence'
        ],
        correctIndex: 1,
        explanation:
            'GPT-4 is ANI despite its impressive range. It cannot learn new skills from conversation permanently, cannot act in the physical world, and its apparent "understanding" is sophisticated pattern matching — not genuine general reasoning.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A self-driving car remembers that the school road is always busy at 3:30 PM and adjusts its route. What capability level?',
        options: [
          'Reactive AI — responds only to current sensors',
          'Limited Memory AI — uses historical patterns to inform current decisions',
          'Theory of Mind AI — understands other drivers\' intentions',
          'Self-Aware AI — knows it is a car'
        ],
        correctIndex: 1,
        explanation:
            'Using historical traffic patterns (past data) to make current routing decisions is Limited Memory AI — the most common level in today\'s deployed AI systems.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why do AI researchers disagree so widely on when AGI will arrive?',
        options: [
          'Because AI research is kept secret by companies',
          'Because nobody knows what fundamental capability is missing — some think more compute works, others think we need entirely new ideas not yet discovered',
          'Because AGI already exists but is hidden',
          'Because AGI has been achieved in labs but not released'
        ],
        correctIndex: 1,
        explanation:
            'The AGI timeline debate reflects genuine scientific uncertainty. We do not know if scaling current approaches will reach AGI, or if fundamentally new ideas are needed. Without knowing what is missing, estimating when it will be found is impossible.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Siri fails to understand your question in a noisy environment and says "I did not get that." What type and capability level is Siri?',
        options: [
          'AGI — Level 3 Theory of Mind',
          'ANI — Level 2 Limited Memory. Trained specifically for voice tasks (Narrow), uses your history and context (Limited Memory), but cannot handle noise robustly',
          'ANI — Level 1 Reactive. No memory used at all',
          'ASI — because it is intelligent in other situations'
        ],
        correctIndex: 1,
        explanation:
            'Siri is Narrow AI (voice assistant only) at Level 2 (uses preferences, history, app context). The failure reveals ANI limits — it cannot robustly handle variation and noise a human listener easily manages.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A startup claims "We have built AGI — our AI can answer questions in 50 languages!" Is this AGI?',
        options: [
          'Yes — 50 languages is incredibly general',
          'No — supporting many languages is still ANI. All 50 languages were in training data. AGI would learn language 51 from scratch by reading one book overnight with no pre-training',
          'Possibly — depends on the quality of answers',
          'Yes — AGI means working in multiple domains'
        ],
        correctIndex: 1,
        explanation:
            'Multilingual capability is ANI — the model was trained on text in those 50 languages. AGI would mean acquiring language 51 with minimal exposure, transferring skills across unrelated domains, and reasoning about genuinely novel situations.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'AI Classification Lab',
      goal:
          'Analyse 10 real AI products and classify each by type (ANI/AGI/ASI) and capability level, then defend your classifications.',
      steps: [
        'Choose 10 AI products: ChatGPT, Alexa, Tesla Autopilot, AlphaFold, MidJourney, Google Translate, Spotify, GitHub Copilot, Sarvam AI, plus one of your choice',
        'For each: classify as ANI/AGI/ASI and as Reactive/Limited Memory/Theory of Mind/Self-Aware',
        'Write 2 sentences justifying each classification',
        'Identify 3 things each product CAN do and 3 things it CANNOT do',
        'Find one product commonly called "AI" that is actually just rule-based automation',
        'Write one paragraph: which of these 10 is closest to AGI and what would it specifically need to actually become AGI?',
      ],
      expectedOutput:
          'AI Classification Report:\nChatGPT: ANI | Limited Memory\n  Can: write text, answer questions, explain concepts\n  Cannot: learn permanently, act physically, see images alone\n  Justification: Pattern matching across text domain only\n\nTesla Autopilot: ANI | Limited Memory\n  Can: navigate roads, detect objects, adjust speed\n  Cannot: handle extreme off-road situations\n\nFalse AI found: [X product] is just if-then rules ✓\nClosest to AGI: ChatGPT — needs physical grounding,\npermanent learning, and genuine reasoning to qualify ✓',
      xpReward: 45,
    ),
  ),
  TopicCourse(
    id: 'aep_l1_ai_data_dl',
    topicTitle: 'AI vs Machine Learning vs Deep Learning',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 195,
    emoji: '🎯',
    intro:
        'AI, Machine Learning, and Deep Learning are used interchangeably in headlines — but they mean very different things. Every AI engineer must understand the precise relationship between these three concepts, where each is used, and why.',
    concepts: [
      ConceptLesson(
        title: 'The Three Nested Circles',
        definition:
            'AI is the broadest category (any machine simulating intelligence). Machine Learning is a SUBSET of AI (machines that learn from data). Deep Learning is a SUBSET of ML (ML using multi-layered neural networks).',
        analogy:
            'Think of nested Russian dolls. AI is the outermost doll — everything is inside it. Machine Learning is the middle doll — inside AI but not all AI is ML. Deep Learning is the innermost doll — a specific powerful technique within ML.',
        example:
            'Visual representation:\n\n┌─────────────────────────────┐\n│  ARTIFICIAL INTELLIGENCE    │\n│  Expert systems, rule-based │\n│  ┌─────────────────────┐   │\n│  │  MACHINE LEARNING   │   │\n│  │  Linear regression, │   │\n│  │  Decision trees,SVM │   │\n│  │  ┌──────────────┐  │   │\n│  │  │ DEEP LEARNING│  │   │\n│  │  │ Neural nets, │  │   │\n│  │  │ CNNs, LLMs   │  │   │\n│  │  └──────────────┘  │   │\n│  └─────────────────────┘   │\n└─────────────────────────────┘',
        keyTakeaway:
            'When someone says "we used AI", they might mean rule-based logic, ML, or deep learning — each is radically different in complexity, data needs, and capability. Always ask "which type?" — this instantly reveals technical depth.',
      ),
      ConceptLesson(
        title: 'Machine Learning — Learning from Data',
        definition:
            'Machine Learning is a method of implementing AI where algorithms improve automatically through experience (data) without being explicitly programmed for every scenario.',
        analogy:
            'Traditional programming is giving instructions for every scenario. ML is showing thousands of examples paired with correct answers and letting the algorithm figure out the rules — often discovering rules humans would never think to write.',
        example:
            'ML for House Price Prediction:\n\nTraditional approach:\n  IF bedrooms==3 AND location=="Koramangala"\n  THEN price = 1.2Cr\n  (impossible to write all combinations)\n\nML approach:\n  Feed 50,000 historical house sales\n  Algorithm learns:\n  price = (0.3 * bedrooms) + (0.5 * sqft/1000)\n         + location_score + floor_modifier + ...\n  Discovers complex relationships humans would miss\n\nML categories:\n  Supervised: labelled training data\n  Unsupervised: find patterns without labels\n  Reinforcement: learn by reward/punishment',
        keyTakeaway:
            'ML is the workhorse of AI in production. Most business AI — fraud detection, recommendation systems, pricing models — use classical ML, not deep learning. Understanding when to use ML vs deep learning is critical.',
      ),
      ConceptLesson(
        title: 'Deep Learning — Neural Networks at Scale',
        definition:
            'Deep Learning uses artificial neural networks with many layers to learn hierarchical representations of data. Each layer learns increasingly abstract features — from pixels to edges to shapes to objects.',
        analogy:
            'Deep Learning is like a team of specialists in an assembly line. Layer 1 detects edges. Layer 2 combines edges into shapes. Layer 3 recognises parts. Layer 4 identifies complete objects. Each layer builds on the previous — nobody told them what to look for.',
        example:
            'How a deep network recognises a cat:\n\nLayer 1 (Input): Raw pixel values\nLayer 2: Detects edges (horizontal, vertical lines)\nLayer 3: Combines edges into shapes (curves, angles)\nLayer 4: Recognises parts (eyes, ears, fur texture)\nLayer 5: Combines parts into cat features\nLayer 6 (Output): 97.3% confident this is a cat\n\nNobody programmed "cats have whiskers" —\nthe network discovered this from 1 million photos',
        keyTakeaway:
            'Deep Learning became dominant because it automatically learns features from raw data — eliminating painful human feature engineering. The same architecture learns images, speech, text, or video by changing training data.',
      ),
      ConceptLesson(
        title: 'When to Use Each Approach',
        definition:
            'Choosing the right approach depends on: data availability, problem complexity, interpretability requirements, and compute budget. Deep Learning is NOT always the best choice.',
        analogy:
            'Choosing between AI approaches is like choosing tools: a screwdriver for screws, a drill for larger work, heavy machinery for construction. Using heavy machinery (deep learning) to hang a picture (simple classification) is wasteful.',
        example:
            'Decision guide:\n\nUSE RULE-BASED AI when:\n  Rules are clear and stable, compliance required\n  Example: Tax calculation, legal document rules\n\nUSE CLASSICAL ML when:\n  Structured tabular data, smaller datasets (<100k)\n  Interpretability matters (banking, healthcare)\n  Example: Credit scoring, churn prediction\n  Algorithms: XGBoost, Random Forest, Logistic Reg\n\nUSE DEEP LEARNING when:\n  Unstructured data: images, text, audio, video\n  Large datasets available (millions of examples)\n  Raw performance matters over interpretability\n  Example: Image recognition, LLMs, speech-to-text',
        keyTakeaway:
            'A common beginner mistake is reaching for deep learning for every problem. A well-tuned XGBoost often beats a deep neural network on tabular data, trains 100x faster, and is far easier to interpret in production.',
      ),
      ConceptLesson(
        title: 'The Modern AI Stack — 2024',
        definition:
            'The 2024 AI stack includes Large Language Models, Foundation Models, Generative AI, and AI Agents — all built on deep learning but with distinct characteristics and use cases.',
        analogy:
            'The AI stack is like a city\'s transport network — deep learning is the road system, ML frameworks are public transport, different model types are buses/metro/rickshaws for different jobs, and LLMs are the flying taxis that work differently from everything before.',
        example:
            'The 2024 AI Stack:\n\nFOUNDATION: Deep Learning, Neural Networks, GPUs\n\nFRAMEWORKS: PyTorch, TensorFlow, JAX\n\nMODEL TYPES:\n  Computer Vision: CNNs (YOLO, ResNet)\n  Language: Transformers (BERT, GPT)\n  Multimodal: GPT-4V, Gemini, Claude\n  Audio: Whisper (speech), MusicGen\n\nAPPLICATION LAYER:\n  LLM APIs: OpenAI, Anthropic, Google\n  Fine-tuning: LoRA, QLoRA\n  RAG: Retrieval Augmented Generation\n  Agents: LangChain, AutoGPT\n\nPRODUCT LAYER:\n  ChatGPT, Copilot, Perplexity, Claude.ai',
        keyTakeaway:
            'The modern AI engineer needs the full stack — from which neural network architecture to choose, to which framework to use, to how to deploy and monitor in production. Each layer requires different skills.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Is every Machine Learning system also a Deep Learning system?',
        options: [
          'Yes — ML and Deep Learning are the same thing',
          'No — Deep Learning is a subset of ML using neural networks. ML also includes decision trees, linear regression, and SVM which are not deep learning',
          'Yes — all modern ML uses deep neural networks',
          'No — ML is a subset of Deep Learning'
        ],
        correctIndex: 1,
        explanation:
            'Deep Learning is a specific TYPE of Machine Learning using multi-layer neural networks. ML is broader and includes many non-neural approaches. Not all ML is Deep Learning — but all Deep Learning is ML.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'You have 5,000 rows of customer data and want to predict churn. Which approach is MOST appropriate?',
        options: [
          'Deep Learning — neural networks are always best',
          'Classical ML (XGBoost or Random Forest) — structured tabular data with small dataset suits classical ML; deep learning needs much more data and adds unnecessary complexity',
          'Rule-based AI — write rules for who churns',
          'No AI — 5,000 rows is too small'
        ],
        correctIndex: 1,
        explanation:
            'Structured tabular data with 5,000 rows is the sweet spot for classical ML. XGBoost trains in seconds, is more interpretable, and often outperforms deep learning on this type and size of data.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'In a deep neural network recognising faces, what does Layer 2 likely learn?',
        options: [
          'Complete face identities directly',
          'Low-level features like edges, curves, and gradients — building blocks that deeper layers combine into higher-level features',
          'The name of each person in the database',
          'Whether the image is good quality'
        ],
        correctIndex: 1,
        explanation:
            'Deep networks learn hierarchically: early layers detect basic features (edges, curves), middle layers combine these into shapes, and later layers recognise complex patterns. This hierarchy is what makes deep learning so powerful.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A news headline says "Company Uses AI to Detect Cancer in X-Rays." What follow-up questions should an AI engineer ask?',
        options: [
          'No questions — AI in healthcare is always impressive',
          'What TYPE of AI — rule-based, classical ML, or deep learning? What training data size and quality? What accuracy across diverse populations? How does it compare to radiologist performance?',
          'Which programming language was used?',
          'How much did it cost to build?'
        ],
        correctIndex: 1,
        explanation:
            'A technical AI engineer evaluates claims by asking: what specific approach, what data, what performance metrics, and on what population? "AI" in a headline tells you almost nothing about actual capability or reliability.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You want to build an AI that detects defective products on a factory line using camera images. Which approach?',
        options: [
          'Rule-based: "if colour != expected colour then defective"',
          'Deep Learning with a CNN — image data is exactly where deep learning excels. Train on labelled good/defective images to detect subtle visual defects rules would miss',
          'Classical ML with manually extracted features',
          'No AI needed — manual inspection is sufficient'
        ],
        correctIndex: 1,
        explanation:
            'Visual defect detection from images is precisely where CNNs shine. Deep learning learns subtle visual patterns (tiny cracks, colour variations, texture anomalies) that are impossible to capture with hand-written rules.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'AI Approach Selection Challenge',
      goal:
          'Given 5 real business problems, choose the correct AI approach and justify your decision.',
      steps: [
        'Problem 1: Predict loan default based on 20 financial features, 50,000 records, bank needs explanation for each decision',
        'Problem 2: Identify and count pedestrians in CCTV footage from 200 cameras in real time',
        'Problem 3: Route customer support emails to correct department based on content',
        'Problem 4: Flag fraudulent transactions — 10 million per day, patterns change weekly',
        'Problem 5: Generate personalised marketing copy for 1 million customers',
        'For each: state your approach, specific algorithm or model type, why you chose it over alternatives, and one key challenge',
      ],
      expectedOutput:
          'Problem 1 (Loan Default): Classical ML — XGBoost\n  Reason: Tabular data, interpretability required by regulation\n  Challenge: Class imbalance (few defaults vs many good loans)\n\nProblem 2 (Pedestrian): Deep Learning — YOLO CNN\n  Reason: Real-time video requires DL; CNNs for images\n  Challenge: Real-time processing across 200 cameras\n\nProblem 3 (Email routing): Classical ML or fine-tuned LLM\nProblem 4 (Fraud): Online ML (adapts to new patterns)\nProblem 5 (Marketing copy): LLM with RAG\nAll 5 justified with alternatives considered ✓',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'aep_l1_ai_applications',
    topicTitle: 'Real-World AI Applications',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 190,
    emoji: '🌍',
    intro:
        'AI is not a future technology — it is already deeply woven into every industry. Healthcare, agriculture, education, finance, and transportation are being transformed right now. Understanding where AI is being applied, what problems it solves, and what challenges remain helps you identify where YOUR skills can make the biggest impact.',
    concepts: [
      ConceptLesson(
        title: 'AI in Healthcare — Saving Lives with Data',
        definition:
            'AI in healthcare diagnoses diseases from medical images, predicts patient deterioration, accelerates drug discovery, and personalises treatment — often matching or exceeding specialist performance on specific tasks.',
        analogy:
            'AI in healthcare is like having a radiologist who has seen 50 million X-rays working alongside every doctor in every rural clinic in India simultaneously — bringing specialist-level screening to places that previously had none.',
        example:
            'Real healthcare AI deployments:\n\nGlobal:\n  Google DeepMind: detects eye disease from scans\n  with 94% accuracy (matches top ophthalmologists)\n  AlphaFold 2: predicted 3D structure of all 200M+\n  known proteins — solved a 50-year biology challenge\n\nIndia-specific:\n  Niramai: AI detects breast cancer in thermography\n  (non-invasive, lower cost than mammography)\n  Tricog: AI ECG analysis for heart attacks in\n  rural India where cardiologists are unavailable\n  Wadhwani AI: TB detection from chest X-rays\n  deployed across Indian government hospitals',
        keyTakeaway:
            'Healthcare AI creates the highest potential societal impact — bringing expert-level diagnosis to rural areas. It also has the highest stakes for errors. AI engineers in healthcare must understand both technical AND ethical dimensions deeply.',
      ),
      ConceptLesson(
        title: 'AI in Agriculture — Feeding 1.4 Billion People',
        definition:
            'AI in agriculture predicts crop yields, detects plant diseases from smartphone photos, optimises irrigation, and connects farmers to markets — transforming India\'s agricultural sector which employs 600 million people.',
        analogy:
            'AI in agriculture is like giving every Indian farmer a team of agricultural scientists, meteorologists, and market analysts in their pocket — advising on watering schedules, disease outbreaks before they spread, and when to sell for maximum price.',
        example:
            'Agricultural AI in practice:\n\nCrop Disease Detection:\n  Plantix app: farmer photographs a sick leaf\n  AI identifies disease with 95% accuracy\n  Suggests treatment immediately\n  Used by 10M+ farmers in India\n\nYield Prediction:\n  Google + ITC: satellite + weather + soil data\n  Predicts wheat yield 6 weeks before harvest\n  Helps government plan food distribution\n\nMarket Price Prediction:\n  Fasal: AI predicts vegetable prices 4 weeks ahead\n  Farmers decide when to harvest and when to sell',
        keyTakeaway:
            'Agricultural AI addresses uniquely Indian challenges — small farm sizes, limited connectivity, many languages. Building AI for agriculture requires domain understanding: works on low-end smartphones, offline-capable, supports diverse Indian crops.',
      ),
      ConceptLesson(
        title: 'AI in Finance — Every Rupee Transaction Uses AI',
        definition:
            'Financial AI powers real-time fraud detection, credit scoring for the unbanked, algorithmic trading, and personalised investment advice — processing millions of decisions per second.',
        analogy:
            'Financial AI is like a hyper-vigilant, never-sleeping security system watching every transaction across every bank account in India, learning each person\'s normal behaviour, and flagging the moment anything unusual happens — in milliseconds.',
        example:
            'Finance AI in India:\n\nUPI Fraud Detection:\n  NPCI\'s AI processes 10+ billion UPI transactions/month\n  Detects suspicious patterns in milliseconds\n  Reduces fraud before money leaves account\n\nCredit for the Unbanked:\n  Traditional banks require credit history to give credit\n  Crediwatch, FinBox: AI analyses alternative data\n  (utility payments, mobile usage, GST filings)\n  Extends credit to 400M Indians with no bank history\n\nWealth Management:\n  Zerodha Coin, Groww: AI-powered fund recommendations\n  Personalised to risk profile and financial goals',
        keyTakeaway:
            'Financial AI requires extremely high reliability — a bug can move millions wrongly. Financial AI engineers must deeply understand precision, recall, and the cost of false positives vs false negatives in monetary terms.',
      ),
      ConceptLesson(
        title: 'AI in Education — Personalised Learning at Scale',
        definition:
            'Educational AI personalises learning paths, identifies students at risk of dropout, automates assessment, and creates interactive tutoring — potentially transforming how 250 million Indian students learn.',
        analogy:
            'AI in education is like giving every student a personal tutor who knows exactly which concepts they struggle with, adapts to their learning style, never loses patience, is available at 2 AM, and costs a fraction of a human tutor.',
        example:
            'Educational AI in India:\n\nAdaptive Learning:\n  BYJU\'S: AI tracks every student interaction\n  Identifies where each student struggles\n  Adjusts difficulty and explanation style\n  Used by 150M+ students\n\nDropout Prediction:\n  AI analyses attendance, grades, engagement\n  Identifies at-risk students 3 months before dropout\n  Enables early teacher intervention\n\nLanguage Learning:\n  Duolingo: AI adapts to learning speed\n  Identifies which words you forget and retests them\n  Optimises review timing using spaced repetition',
        keyTakeaway:
            'Educational AI must be designed with equity in mind — students with poor internet or low-end devices must not be disadvantaged. Building AI for education in India requires understanding these real-world constraints.',
      ),
      ConceptLesson(
        title: 'Emerging AI — The Next Wave for India',
        definition:
            'AI is now transforming climate science, legal systems, creative industries, and language preservation — with Indian-language AI representing one of the most important and underserved frontiers globally.',
        analogy:
            'Emerging AI applications are like new rivers being carved by water — flowing into areas where human bottlenecks are most severe and where data is becoming available for the first time.',
        example:
            'Next-wave AI applications:\n\nClimate AI:\n  Google DeepMind: AI controls data centre cooling\n  40% energy reduction achieved\n\nLegal AI:\n  Indian Supreme Court: AI translates judgements\n  to 9 Indian languages automatically\n\nCreative AI:\n  Suno AI: complete songs generated from text\n  Adobe Firefly: AI in professional creative tools\n\nIndian Language AI (most important for India):\n  Bhashini (Govt): AI translation across 22 languages\n  Sarvam AI: LLMs trained specifically on Indian text\n  AI Vaani: voice AI for rural India\n  900M+ non-English Indians currently excluded from AI',
        keyTakeaway:
            'The single biggest opportunity for Indian AI engineers is Indian-language AI. 900+ million Indians are not served by English-first AI. Building AI that works in Hindi, Tamil, Telugu, Bengali is both a massive market and a critical social mission.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why is AI in agriculture particularly important for India?',
        options: [
          'India has the most advanced farms in the world',
          'Agriculture employs 600 million people with significant challenges in disease detection, water management, and market access that AI can address at scale and low cost',
          'Indian farmers have the most smartphones in the world',
          'India has the best satellite coverage for agricultural monitoring'
        ],
        correctIndex: 1,
        explanation:
            'India\'s agricultural sector is massive (600M employed) and faces severe challenges — crop diseases, water scarcity, market uncertainty. AI tools like Plantix and Fasal deliver expert-level guidance at near-zero marginal cost per farmer.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'In financial AI fraud detection, why is a false negative (missing real fraud) worse than a false positive?',
        options: [
          'They are equally bad',
          'A false negative means actual money is stolen and difficult to recover; a false positive only temporarily inconveniences a customer who can call the bank — the costs are asymmetric',
          'False positives are worse because customers get angry',
          'False negatives are not a problem in practice'
        ],
        correctIndex: 1,
        explanation:
            'In fraud detection, asymmetric costs determine the right threshold. Missing fraud = financial loss + customer harm. False positive = temporary inconvenience. Fraud systems are tuned to be conservative — better to occasionally block legitimate transactions than allow fraud.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What makes Indian-language AI a unique and important AI engineering challenge?',
        options: [
          'Indian languages are simple to process',
          'Indian languages have limited digital training data (low-resource), 11 different scripts, complex code-switching, and serve 900M+ non-English speakers excluded from current AI',
          'Indian languages are all similar to each other',
          'There is no demand for Indian language AI'
        ],
        correctIndex: 1,
        explanation:
            'Indian-language AI is uniquely challenging: data scarcity, script diversity (Devanagari, Tamil, Telugu are very different), and linguistic complexity. Solving this serves 900M+ people currently excluded from AI benefits.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A doctor says "AI will replace radiologists in 5 years." A radiologist says "AI will never replace me." Who is closer to the truth?',
        options: [
          'The doctor — AI will replace radiologists completely',
          'Neither extreme is right. AI will augment radiologists — automating routine screening, freeing them for complex cases. "AI + radiologist" beats both alone.',
          'The radiologist — AI cannot do medical work',
          'Depends entirely on the country'
        ],
        correctIndex: 1,
        explanation:
            'Evidence shows AI + human expert outperforms either alone. AI catches patterns humans miss in routine screening; humans handle ambiguity, rare cases, and patient context AI cannot. The realistic future is augmentation, not replacement.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You want to build an AI to help Indian farmers identify crop diseases. What is the MOST important challenge to solve first?',
        options: [
          'Choose between TensorFlow and PyTorch',
          'Build a dataset of crop disease images labelled in Indian languages, covering the specific crops and diseases relevant to Indian agriculture — without this, no algorithm will work',
          'Deploy to AWS or Google Cloud first',
          'Build a mobile app interface first'
        ],
        correctIndex: 1,
        explanation:
            'Data is the foundation. Western crop disease datasets have limited overlap with Indian crops and disease variants. Collecting India-specific disease data is the hardest and most important step — all algorithm and deployment decisions are secondary.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'AI Application Deep Dive',
      goal:
          'Research and document a real AI application in one industry, understanding the technical approach, impact, and challenges.',
      steps: [
        'Choose one industry: healthcare, agriculture, finance, education, or an industry you care about',
        'Find 3 real companies (at least 1 Indian) using AI in that industry — research their actual products',
        'For the most interesting one: describe the AI problem, what data they use, likely algorithm type, and how they measure success',
        'Identify 2 things working well (outcomes achieved) and 2 challenges they still face',
        'Find one case where AI in this industry caused harm or failed — what went wrong?',
        'Propose one AI application that does NOT yet exist but would have significant impact',
      ],
      expectedOutput:
          'AI Application Deep Dive: Healthcare\n3 Companies:\n  1. Niramai (India) — thermal imaging cancer detection\n  2. Google DeepMind — eye disease detection\n  3. Tricog (India) — rural ECG heart attack detection\n\nDeep dive on Niramai:\n  Problem: Breast cancer detected late in India (80% at stage 3+)\n  Data: Thermal camera images + patient demographics\n  Algorithm: CNN-based classification\n  Metric: Sensitivity > 90%, specificity > 85%\nWorking: 1/10th cost of mammogram, no radiation\nChallenge: Regulatory approval, doctor trust-building\nAI failure researched: [real case documented] ✓\nNew proposal: AI triage for rural ASHA workers ✓',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'aep_l1_ai_careers',
    topicTitle: 'AI Career Paths & Industry Roles',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 195,
    emoji: '💼',
    intro:
        'The AI job market is one of the fastest-growing in the world — and India is at the epicentre. But "AI jobs" is not a single career — it spans research scientists, ML engineers, data scientists, AI product managers, and MLOps engineers. Understanding the different paths, their requirements, and compensation helps you make deliberate career decisions.',
    concepts: [
      ConceptLesson(
        title: 'The AI Career Landscape',
        definition:
            'AI careers span from pure research (inventing algorithms) to applied engineering (building AI products) to business roles (AI strategy). Each requires different skills, education, and experience.',
        analogy:
            'The AI career landscape is like a hospital — surgeons (AI researchers), doctors (ML engineers), nurses (data scientists), administrators (AI product managers), and facilities staff (MLOps engineers) all serve different essential functions.',
        example:
            'Major AI career paths:\n\nAI RESEARCH SCIENTIST\n  What: Invent new ML algorithms and architectures\n  Where: Google Brain, DeepMind, OpenAI, IIT labs\n  Education: PhD typically required\n  Salary: ₹50L-2Cr+ at top labs\n\nML ENGINEER (most in demand)\n  What: Build and deploy ML models in production\n  Where: Every tech company, startups, banks\n  Education: BTech/MTech + strong coding + ML\n  Salary: ₹15-60L depending on company\n\nDATA SCIENTIST\n  What: Analyse data, build models, generate insights\n  Where: Consulting, e-commerce, healthcare, finance\n  Salary: ₹8-40L\n\nMLOPS ENGINEER\n  What: Deploy, monitor, maintain ML in production\n  Salary: ₹15-50L',
        keyTakeaway:
            'ML Engineer is the highest-demand, highest-paying, most practical AI career for most people. It requires strong software engineering PLUS ML knowledge — not just ML theory. Build both skills equally.',
      ),
      ConceptLesson(
        title: 'Skills Required for Each AI Role',
        definition:
            'Different AI roles require different skill combinations. The most versatile and hireable profile combines solid programming, mathematical foundations, ML/DL knowledge, and ability to deploy production systems.',
        analogy:
            'AI skill requirements are like different cooking roles — a pastry chef (data scientist) needs precision and chemistry. A line cook (ML engineer) needs speed and consistency under pressure. An executive chef (AI architect) needs all skills plus business sense.',
        example:
            'ML ENGINEER core skills:\n  Programming: Python (expert), SQL (strong)\n  ML libraries: scikit-learn, PyTorch/TensorFlow\n  Data: pandas, NumPy, data cleaning\n  MLOps: Docker, APIs, model serving\n  Cloud: AWS/GCP/Azure basics\n  Maths: Linear algebra, probability, calculus\n\nDATA SCIENTIST core skills:\n  Statistics: hypothesis testing, distributions\n  Visualisation: matplotlib, seaborn, Tableau\n  Communication: presenting insights to non-technical\n  SQL: complex queries, window functions\n\nAI RESEARCHER core skills:\n  Deep mathematics: linear algebra, optimisation theory\n  Paper reading and implementation\n  Experiment design and novel idea communication',
        keyTakeaway:
            'Python is non-negotiable for any AI role. Start there. Then add: pandas + numpy for data, scikit-learn for classical ML, PyTorch for deep learning, and basic SQL. This foundation opens 80% of AI job opportunities.',
      ),
      ConceptLesson(
        title: 'The Indian AI Job Market',
        definition:
            'India has the world\'s second-largest AI talent pool. Bengaluru, Hyderabad, and Pune are becoming global AI hubs. AI salaries in India are growing at 20-30% annually with top roles matching global compensation.',
        analogy:
            'The Indian AI job market is like a gold rush where the gold mine is expertise — the more specific and deep your AI skills, the more companies compete for you. Unlike the IT boom which was volume-based, AI careers are expertise-based.',
        example:
            'Indian AI job market 2024:\n\nTop hiring companies:\n  Product: Google, Microsoft, Amazon, Meta, Adobe\n  Indian unicorns: Flipkart, Zepto, Meesho, Swiggy\n  AI-first: Sarvam AI, Krutrim, Yellow.ai\n  Finance: Goldman Sachs, Morgan Stanley (Bengaluru)\n\nCompensation ranges:\n  Fresher ML Engineer (service): ₹8-20L\n  Fresher ML Engineer (product): ₹20-45L\n  3yr Experience: ₹25-60L\n  5yr Experience: ₹40-1Cr+\n  Staff/Principal AI Engineer: ₹80L-2Cr+\n\nTop hiring cities:\n  Bengaluru (40% of AI jobs), Hyderabad, Pune',
        keyTakeaway:
            'The gap between AI engineers at service vs product companies is enormous — both in compensation and learning quality. A fresher at a product company earns 2-3x more AND learns 5-10x more. Target product companies aggressively.',
      ),
      ConceptLesson(
        title: 'Building Your AI Portfolio',
        definition:
            'In AI hiring, demonstrated projects matter more than certificates. A portfolio of 3-4 well-documented AI projects on GitHub with clear problem statements, approaches, and results is more valuable than 10 Coursera certificates.',
        analogy:
            'An AI portfolio is like a chef\'s tasting menu — it does not matter how many culinary certificates you have if your dishes are mediocre. Show interviewers what you can actually BUILD, not just what you have studied.',
        example:
            'Portfolio projects that impress AI interviewers:\n\nTIER 1 (shows basics):\n  Sentiment analysis of product reviews\n  House price prediction with proper EDA\n  Image classifier for a domain you care about\n\nTIER 2 (shows depth):\n  End-to-end ML pipeline deployed as an API\n  Fine-tuned LLM for a specific use case\n  RAG-based document Q&A system\n\nTIER 3 (differentiates):\n  Novel dataset you collected and labelled yourself\n  Real product used by actual users\n  AI system solving an Indian-language problem\n  Research replication of a recent important paper\n\nDocumentation matters:\n  Clear README: problem, approach, results\n  Visualisations of model performance\n  Deployed demo (Streamlit, Gradio, or web API)',
        keyTakeaway:
            'ONE well-documented, deployed, end-to-end AI project is worth more than 20 tutorial notebooks. Interviewers want to see: did you define a real problem, clean real data, train a model, evaluate it properly, and deploy it?',
      ),
      ConceptLesson(
        title: 'AI Learning Roadmap — From Zero to Employed',
        definition:
            'A structured learning roadmap prevents the most common AI learner mistake: jumping to advanced topics without foundations. Building skills in the right order saves months of confusion and creates genuine competence.',
        analogy:
            'An AI learning roadmap is like learning to cook — you do not start with a 5-star soufflé. You master knife skills and basic recipes first. Each level makes the next level possible.',
        example:
            'AI Engineer Roadmap (12-18 months):\n\nMONTH 1-2: Python Mastery\n  NumPy, pandas, matplotlib, visualisation\n\nMONTH 3-4: Machine Learning Foundations\n  Supervised/unsupervised learning\n  Model evaluation, cross-validation, scikit-learn\n\nMONTH 5-7: Deep Learning\n  Neural networks fundamentals\n  PyTorch or TensorFlow\n  CNNs for images, Transformers for text\n\nMONTH 8-10: Specialisation + Projects\n  NLP / Computer Vision / Tabular ML\n  2-3 real portfolio projects\n\nMONTH 11-12: Production + Portfolio\n  Model deployment (FastAPI, Docker)\n  MLOps basics, interview preparation',
        keyTakeaway:
            'You are already on Month 1-2 of this roadmap by building Python skills now. Every subsequent AI level in this learning path follows this exact roadmap. You are building the right foundation right now.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which AI role is currently in HIGHEST demand in India?',
        options: [
          'AI Research Scientist — companies want original research',
          'ML Engineer — companies need people who can build AND deploy ML systems in production, combining software engineering and ML knowledge',
          'Data Analyst — the most common entry-level role',
          'AI Ethics Officer — compliance is the priority'
        ],
        correctIndex: 1,
        explanation:
            'ML Engineer is the highest-demand role because every company using AI needs engineers who can build production systems — not just research algorithms or analyse data. The combination of coding and ML skills is rare and highly valued.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why does a portfolio project matter more than a Coursera certificate in AI hiring?',
        options: [
          'Certificates are not recognised in India',
          'Projects demonstrate actual ability to define a problem, handle real data, train models, evaluate results, and deploy — all skills certificates only test through multiple choice',
          'Projects are faster to create than getting certificates',
          'Certificates are only useful for research roles'
        ],
        correctIndex: 1,
        explanation:
            'Hiring managers want evidence of real capability, not test scores. A deployed AI project shows end-to-end thinking — problem definition, data work, modelling, evaluation, and deployment. No certificate course tests all of this authentically.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A fresher joins an IT service company vs a product company as an ML Engineer. Who learns more in year 1?',
        options: [
          'Service company — more projects and exposure',
          'Product company — works on real production ML systems at scale, learns engineering practices from senior AI engineers in an AI-first environment',
          'Equal learning at both types',
          'Service company — better training programs'
        ],
        correctIndex: 1,
        explanation:
            'Product companies build AI for their own products at scale — engineers work on real ML problems with real users. Service companies often do analytics projects for clients with limited AI depth. The quality and pace of learning is dramatically different.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Candidate A has 5 Coursera AI certificates. Candidate B has 2 certificates and one deployed Streamlit app classifying crop diseases with 89% accuracy. Who gets the ML Engineer interview?',
        options: [
          'Candidate A — more certificates show more learning',
          'Candidate B — the deployed app proves end-to-end ML engineering: problem definition, data handling, model training, evaluation, and deployment. Exactly what the job requires.',
          'Both equally — both have shown AI interest',
          'Neither — both need a master\'s degree'
        ],
        correctIndex: 1,
        explanation:
            'Candidate B wins every time. A deployed project with real results (89% accuracy on crop disease) proves end-to-end ML engineering capability — all the skills the job actually requires. Certificates only show coursework completion.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You are a BTech student with strong Python skills and 12 months before graduation. What is the MOST impactful use of time for AI career prep?',
        options: [
          'Collect as many AI certificates as possible',
          'Follow the structured roadmap: master pandas/numpy → classical ML → one deep learning framework → build 2-3 real portfolio projects → contribute to open source → apply at month 10',
          'Focus on AI theory and mathematics only',
          'Build LinkedIn connections without learning technical skills'
        ],
        correctIndex: 1,
        explanation:
            'Structured skill-building + real projects + applications is the highest-ROI approach. Certificates without projects get you nowhere. Projects without solid foundations produce mediocre work. The roadmap builds both simultaneously.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'My AI Career Blueprint',
      goal:
          'Create a personalised AI career roadmap based on your background, interests, and target role.',
      steps: [
        'Identify your target AI role: ML Engineer, Data Scientist, AI Researcher, MLOps Engineer, or AI Product Manager',
        'Research 5 specific job postings for your target role on LinkedIn/Naukri — list the top 5 required skills',
        'Honestly rate your current skill level in each (0-10)',
        'Identify your top 3 skill gaps and how to address each',
        'Design your first portfolio project: problem, data, algorithm, how to deploy',
        'Write a 6-month learning plan with specific weekly milestones',
      ],
      expectedOutput:
          'My AI Career Blueprint:\nTarget Role: ML Engineer at a product company\n\nTop 5 required skills (from job postings):\n  1. Python (pandas, numpy, scikit-learn)\n  2. Deep Learning (PyTorch/TensorFlow)\n  3. SQL and data manipulation\n  4. Model deployment (FastAPI, Docker)\n  5. Experiment tracking (MLflow, W&B)\n\nSkill ratings: Python 7/10 | Deep Learning 2/10 | SQL 4/10\nTop 3 gaps: Deep Learning, Deployment, SQL\n\nFirst portfolio project:\n  Crop disease detection for Indian farmers\n  Data: PlantVillage + Indian images\n  Algorithm: CNN (ResNet-18 fine-tuned)\n  Deploy: Streamlit app + REST API\n\n6-month plan with weekly milestones ✓',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'aep_l1_ai_ethics',
    topicTitle: 'AI Ethics & Responsible AI',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 205,
    emoji: '⚖️',
    intro:
        'AI systems are making decisions that affect people\'s lives — who gets a loan, who gets parole, whose medical scan is flagged. These systems can encode discrimination, violate privacy, and produce harmful outcomes at massive scale. Every AI engineer has an ethical responsibility to understand and address these issues — not just the technical ones.',
    concepts: [
      ConceptLesson(
        title: 'AI Bias — When Training Data Discriminates',
        definition:
            'AI bias occurs when an AI system produces systematically unfair outcomes for certain groups — often because training data reflects historical human biases, or because underrepresented groups have less data.',
        analogy:
            'AI bias is like hiring a biased recruiter and outsourcing all hiring to them — except at 10,000x speed and scale, with no accountability. If AI learned from historically biased hiring data, it perpetuates and amplifies those biases at massive scale.',
        example:
            'Real AI bias cases:\n\nAmazon Hiring AI (2018):\n  AI trained on 10 years of Amazon resumes\n  Problem: Most successful hires were male\n  AI learned to penalise female-associated signals\n  Downgraded graduates of all-women colleges\n  Amazon shut down the system\n\nFacial Recognition:\n  MIT study: major systems had 1% error on\n  white men, 35% error on dark-skinned women\n  These systems were deployed in law enforcement\n\nCredit Scoring in India:\n  AI scores sometimes correlate with caste or\n  geography without intentionally encoding them\n  Proxy discrimination at scale',
        keyTakeaway:
            'Bias in AI is not just unfair — it causes real harm at massive scale. An AI engineer who deploys a biased model is responsible for its outcomes. Always ask: does my training data represent all groups fairly? How does my model perform across demographic subgroups?',
      ),
      ConceptLesson(
        title: 'Privacy, Data Protection, and AI',
        definition:
            'AI systems consume enormous personal data — location, medical records, financial transactions, social connections. How this data is collected, stored, used, and protected is a critical ethical and legal concern.',
        analogy:
            'Data privacy in AI is like a hospital\'s patient records — immensely valuable for AI training, but with strict rules about who can see what and for what purpose. Violating these boundaries causes real harm to real people.',
        example:
            'Privacy issues in AI:\n\nData Collection Overreach:\n  A mental health app collects diary entries\n  to "improve the AI" — sells patterns to insurers\n  who use it to deny coverage\n\nFacial Recognition:\n  Debates: should police use facial recognition\n  without a legal framework for accuracy or appeals?\n\nMedical AI Privacy:\n  Training cancer detection AI requires patient scans\n  Patient consent, anonymisation, data security\n  are non-negotiable ethical requirements\n\nIndia\'s Framework:\n  Digital Personal Data Protection Act (2023)\n  Requires: explicit consent, purpose limitation,\n  data minimisation, right to erasure',
        keyTakeaway:
            'As an AI engineer, you have direct access to sensitive user data. Best practices: collect minimum data needed, anonymise where possible, get explicit consent, never sell user data, and understand the legal framework in your country.',
      ),
      ConceptLesson(
        title: 'AI Transparency and Explainability',
        definition:
            'Many powerful AI systems are "black boxes" — they make accurate predictions but cannot explain WHY. Explainability is critical in high-stakes domains where people need to understand and contest AI decisions.',
        analogy:
            'An AI black box making important decisions is like a judge who says "you are guilty" with no reasoning or ability to appeal. Even if usually correct, the lack of transparency undermines trust and makes it impossible to detect when the system is wrong.',
        example:
            'Explainability in practice:\n\nWhere it is CRITICAL:\n  Loan denial: "Why was my loan rejected?"\n  Medical diagnosis: "Why does AI think I have cancer?"\n  Criminal justice: "Why is this person high-risk?"\n\nTools for AI explainability:\n  LIME: explains any model\'s individual prediction\n  SHAP: shows which features most influenced output\n  Integrated Gradients: for neural network explanations\n\nEU AI Act (2024) requirements:\n  High-risk AI systems MUST be explainable\n  Users have right to explanation for AI decisions\n  Indian regulations will follow similar patterns',
        keyTakeaway:
            'If you are building AI that makes consequential decisions about people, explainability is not optional — it is a requirement. In regulated industries (banking, healthcare, hiring), black-box AI may be legally prohibited.',
      ),
      ConceptLesson(
        title: 'Responsible AI — Principles into Practice',
        definition:
            'Responsible AI is a framework of principles — Fairness, Accountability, Transparency, Safety, Privacy, and Inclusivity — that guide ethical development and deployment of AI systems.',
        analogy:
            'Responsible AI principles are like engineering safety standards for buildings — you can build a skyscraper without following them, but it might collapse. Standards are not obstacles to creativity; they are what makes powerful systems safe enough to actually use.',
        example:
            'Responsible AI Principles:\n\nFAIRNESS:\n  Test model performance across ALL demographic groups\n  Identify and mitigate bias before deployment\n\nACCOUNTABILITY:\n  Clear ownership of AI system outcomes\n  Audit trails for AI decisions\n  Humans in the loop for high-stakes decisions\n\nSAFETY:\n  Adversarial testing before deployment\n  Monitoring for unexpected behaviour in production\n\nTRANSPARENCY:\n  Document what data was used and how\n  Disclose when users are interacting with AI\n\nPRIVACY:\n  Minimum data collection\n  Secure storage and handling\n\nINCLUSIVITY:\n  Test on underrepresented populations\n  Design for language and accessibility diversity',
        keyTakeaway:
            'Responsible AI is not just ethics — it is good engineering. AI systems that are biased, opaque, or unsafe create legal liability, destroy user trust, and cause real harm. Building responsibly makes systems more reliable, defensible, and sustainable.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Amazon\'s hiring AI penalised women\'s resumes even though it was never told to consider gender. How did this happen?',
        options: [
          'An engineer secretly programmed gender bias',
          'The AI learned from 10 years of historical hiring data where most successful hires were male — it learned that male-associated signals predicted success, creating discriminatory patterns from biased training data',
          'Amazon intentionally built discrimination into the system',
          'The algorithm had a mathematical error'
        ],
        correctIndex: 1,
        explanation:
            'This is historical bias in training data — the AI correctly learned patterns from past hiring but those patterns encoded systemic gender discrimination. The AI replicated and amplified past human bias at massive scale.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is explainability especially important in AI loan decision-making?',
        options: [
          'It makes the AI more accurate',
          'Applicants have a legal right to know why they were denied, regulators need to verify no discrimination occurred, and loan officers need to understand AI recommendations before acting on them',
          'It makes the system run faster',
          'It is required only for loans above ₹10 lakhs'
        ],
        correctIndex: 1,
        explanation:
            'Financial decisions have legal obligations: regulations require lenders to explain rejections, applicants have rights to contest decisions, and regulators audit for discrimination. A black-box AI cannot operate legally in regulated lending.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A face recognition system achieves 98% overall accuracy but has 40% error rate for darker-skinned women. Is this acceptable for public deployment?',
        options: [
          'Yes — 98% overall is excellent performance',
          'No — differential performance across demographic groups indicates dangerous bias. 40% error in one group means disproportionate harm. Overall accuracy hides group-level failures.',
          'Yes — no system is perfect and 98% is very good',
          'It depends on the use case'
        ],
        correctIndex: 1,
        explanation:
            'Aggregate accuracy hides discriminatory performance. 98% overall with 40% error for one group means that group is systematically failed. For law enforcement use, 40% false matches could mean wrongful arrests — unacceptable regardless of overall accuracy.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You build an AI that predicts prisoner recidivism (likelihood of re-offending) to help judges with sentencing. It is 75% accurate. Should you deploy it?',
        options: [
          'Yes — 75% accuracy is better than human intuition alone',
          'Not without critical safeguards: test accuracy across racial/economic groups, ensure judges understand it is advisory only, provide explainability for each prediction, establish appeal process, and monitor real-world outcomes',
          'No AI should ever be used in criminal justice',
          'Yes — deploy and monitor results afterward'
        ],
        correctIndex: 1,
        explanation:
            'Criminal justice AI has life-altering consequences. 75% accuracy means 25% wrong — potentially years of someone\'s life affected by an error. Group-level fairness is essential. Human oversight, explainability, and appeal processes are non-negotiable.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your startup collects users\' WhatsApp messages to "improve AI recommendations." Users agreed to Terms of Service (page 47, paragraph 3, tiny font). Is this ethical?',
        options: [
          'Yes — they agreed to the ToS technically',
          'No — buried consent is not meaningful consent. Ethical data collection requires clear disclosure, specific explanation of use, genuine ability to opt out, and proportionality (WhatsApp messages is extreme for recommendations)',
          'Yes — all major companies do this',
          'It depends on local laws'
        ],
        correctIndex: 1,
        explanation:
            'Ethical consent is informed, specific, and freely given — not buried in 50-page documents. Collecting WhatsApp messages for recommendations violates proportionality and informed consent principles. Legality does not equal ethicality.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'AI Ethics Audit',
      goal:
          'Conduct an ethical audit of a real AI system you use, identifying risks and proposing mitigations.',
      steps: [
        'Choose an AI system you interact with regularly (food delivery ETA, job recommendation, content feed, credit scoring)',
        'Identify: what data does this system use about you? Did you meaningfully consent to this collection?',
        'Identify potential bias: are there groups who might be systematically disadvantaged by this system?',
        'Assess transparency: do you know when and why this AI is making decisions about you?',
        'Research: has this company been reported for AI bias, privacy violations, or ethical issues?',
        'Write a 3-point improvement proposal: what changes would make this AI more fair, transparent, or privacy-respecting?',
      ],
      expectedOutput:
          'AI Ethics Audit: LinkedIn Job Recommendations\n\nData collected: browsing history, connections, search terms,\n  CV content, engagement patterns\nConsent quality: ToS mentions this, not prominently disclosed\n\nBias risks:\n  Recommendations may favour certain universities\n  May disadvantage career-changers\n  English-first interface disadvantages regional candidates\n\nTransparency: No explanation for why specific jobs shown\n\nReported issues: [research actual reported issues] ✓\n\n3 Improvement Proposals:\n  1. Explain why each job was recommended\n  2. Allow users to see and edit their inferred profile\n  3. Add Hindi/regional language recommendation support ✓',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'aep_l1_ai_tools',
    topicTitle: 'AI Tools & Development Environment',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 32,
    totalXp: 200,
    emoji: '🛠️',
    intro:
        'Before you can build AI, you need to set up your AI development environment correctly. This course covers the exact tools, libraries, and platforms that professional AI engineers use daily — and gets you running your first AI code on a real dataset. No more theory — time to build.',
    concepts: [
      ConceptLesson(
        title: 'Python — The Language of AI',
        definition:
            'Python is the dominant language of AI and machine learning — chosen for its simplicity, massive ecosystem of ML libraries, and a community that has built more AI tools in Python than all other languages combined.',
        analogy:
            'Python is to AI what English is to international business — not the only option, but the universal language every library, tutorial, and company uses. Fighting it means fighting the entire AI ecosystem.',
        example:
            'Why Python dominates AI:\n\n1. Libraries: NumPy, pandas, scikit-learn, PyTorch,\n   TensorFlow — all Python-first\n\n2. Research: 95%+ of AI papers release Python code\n\n3. Readability: AI code is complex — Python\'s\n   clean syntax makes it manageable\n\n4. REPL: Jupyter notebooks let you experiment\n   interactively — critical for AI exploration\n\n5. Community: Stack Overflow, GitHub, Kaggle\n   — all Python-first for AI\n\nPython version for AI (2024):\n  Use Python 3.10+ (3.11 or 3.12 preferred)\n  DO NOT use Python 2 (dead)\n\nCheck your version:\nimport sys\nprint(sys.version)  # should be 3.10+',
        keyTakeaway:
            'You already know Python from this learning path — you have the most critical foundation for AI already. The next step is adding AI-specific libraries on top of your existing Python foundation.',
      ),
      ConceptLesson(
        title: 'Essential AI Libraries — Your Core Toolkit',
        definition:
            'Five libraries form the core AI engineering toolkit: NumPy (numerical computing), pandas (data manipulation), matplotlib/seaborn (visualisation), scikit-learn (classical ML), and PyTorch or TensorFlow (deep learning).',
        analogy:
            'AI libraries are like a professional kitchen\'s tools — each designed for a specific job. NumPy is your knives (numerical foundation), pandas is your prep counter (data handling), matplotlib is your plating tools (visualisation), scikit-learn is your conventional oven (standard ML), and PyTorch is your high-tech combi oven (deep learning).',
        example:
            '# Install everything:\n# pip install numpy pandas matplotlib scikit-learn torch\n\n# 1. NumPy — numerical arrays\nimport numpy as np\narr = np.array([1, 2, 3, 4, 5])\nprint(arr.mean(), arr.std())  # 3.0, 1.41\n\n# 2. pandas — data manipulation\nimport pandas as pd\ndf = pd.read_csv("data.csv")\nprint(df.head(), df.describe())\n\n# 3. matplotlib — visualisation\nimport matplotlib.pyplot as plt\nplt.plot(df["age"], df["salary"])\nplt.show()\n\n# 4. scikit-learn — classical ML\nfrom sklearn.linear_model import LinearRegression\nmodel = LinearRegression()\nmodel.fit(X_train, y_train)\n\n# 5. PyTorch — deep learning\nimport torch\nimport torch.nn as nn',
        keyTakeaway:
            'Learn these five libraries in order — each builds on the previous. This foundation gets you through 80% of everything in this AI learning path.',
      ),
      ConceptLesson(
        title: 'Jupyter Notebooks — AI\'s Laboratory',
        definition:
            'Jupyter Notebooks are interactive coding environments where code, outputs, visualisations, and explanations coexist in one document — essential for data exploration, experimentation, and sharing AI work.',
        analogy:
            'A Jupyter notebook is like a scientist\'s lab notebook — run an experiment (code cell), record the result right next to it (output), write what you observed (markdown), then run the next experiment. All in sequence, all saved, all sharable.',
        example:
            '# Jupyter Notebook workflow for ML:\n\n# Cell 1: Load data\nimport pandas as pd\ndf = pd.read_csv("customers.csv")\ndf.head()  # Shows interactive table below\n\n# Cell 2: Explore — output appears immediately\ndf.describe()  # Statistics right here\ndf["age"].hist()  # Chart appears inline\n\n# Cell 3: Clean\ndf = df.dropna()\n\n# Cell 4: Train\nfrom sklearn.tree import DecisionTreeClassifier\nmodel = DecisionTreeClassifier()\nmodel.fit(X_train, y_train)\n\n# Cell 5: Evaluate\nfrom sklearn.metrics import accuracy_score\nprint(f"Accuracy: {accuracy_score(y_test, preds):.2%}")\n\n# Start Jupyter:\n# pip install jupyter\n# jupyter notebook',
        keyTakeaway:
            'Every Kaggle competition, AI tutorial, and research paper code uses Jupyter notebooks. The ability to explore data interactively and iterate quickly is a core AI engineering skill. Use Google Colab for free cloud Jupyter access.',
      ),
      ConceptLesson(
        title: 'Google Colab — Free AI Computing in the Cloud',
        definition:
            'Google Colab provides free access to Jupyter notebooks with GPU and TPU support — giving every learner access to the compute needed for training deep learning models without any hardware investment.',
        analogy:
            'Google Colab is like a free fully-equipped gym open 24/7 — instead of buying expensive gym equipment for your home, you go to the free gym when you need it. Free powerful GPUs instead of spending ₹80,000 on your own.',
        example:
            '# Getting started with Google Colab:\n# 1. Go to colab.research.google.com\n# 2. Sign in with Google account\n# 3. Create new notebook\n\n# Check if GPU is available:\nimport torch\nprint(torch.cuda.is_available())  # True if GPU connected\nprint(torch.cuda.get_device_name(0))  # "Tesla T4"\n\n# Enable GPU: Runtime → Change runtime type → T4 GPU\n\n# Colab advantages:\n# Free GPU (Tesla T4 or V100)\n# All major ML libraries pre-installed\n# Google Drive integration for data\n# Easy notebook sharing\n# No local setup required\n\n# Limitations:\n# 12 hour session limit\n# GPU not guaranteed at peak times\n# Not for production deployment',
        keyTakeaway:
            'Start all your AI learning on Google Colab — zero setup, free GPU, everything pre-installed. This removes the biggest barrier for beginners: hardware and environment setup.',
      ),
      ConceptLesson(
        title: 'Kaggle — The AI Learning Playground',
        definition:
            'Kaggle is the world\'s largest data science community with free datasets, competitions, courses, and notebooks. It is where AI learners prove skills, build portfolios, and connect with the global AI community.',
        analogy:
            'Kaggle is like a global AI dojo where practitioners of all levels train and compete. Beginners learn from expert notebooks. Intermediate learners enter competitions. Advanced practitioners earn Grand Master status recognised worldwide by AI employers.',
        example:
            'How to use Kaggle as a learner:\n\n1. DATASETS: 50,000+ free datasets\n   Search any topic → instant CSV download\n   Example: Indian crop yield, medical records\n\n2. NOTEBOOKS: See how experts solve problems\n   Filter by most votes → learn best practices\n   Copy and modify expert solutions\n\n3. COMPETITIONS:\n   Beginner: Titanic (binary classification)\n   Intermediate: House Prices (regression)\n   Advanced: Cash prize competitions\n   Top 25% finish is worth noting on resume\n\n4. COURSES (free):\n   Intro to ML, Pandas, Feature Engineering\n\n5. PROFILE BUILDING:\n   Public notebooks → your visible portfolio',
        keyTakeaway:
            'Complete the Titanic survival prediction on Kaggle as your FIRST AI project. It has a clear problem, clean data, community solutions to learn from, and a leaderboard to measure progress. It is the "Hello World" of practical ML.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why is Python the dominant language for AI and not Java or C++?',
        options: [
          'Python is faster than Java and C++ for AI computation',
          'Python\'s ecosystem, clean syntax, interactive notebooks, and the entire AI research community standardising on Python creates a compounding network effect making any alternative extremely costly',
          'Python was specifically designed for AI from the start',
          'Python is the only language that supports machine learning'
        ],
        correctIndex: 1,
        explanation:
            'Python is not faster than C++ — but AI libraries (PyTorch, TensorFlow) are written in C++ and exposed through Python APIs. Performance underneath + clean Python syntax on top + universal community adoption made Python the undisputed standard.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the main advantage of Google Colab for AI beginners?',
        options: [
          'It is faster than any laptop for AI',
          'Free access to GPU-accelerated Jupyter notebooks in the cloud — no hardware purchase, no setup, all major ML libraries pre-installed, accessible from any browser',
          'It has the best AI models built in',
          'It stores unlimited data for free'
        ],
        correctIndex: 1,
        explanation:
            'Colab removes the single biggest barrier for AI learners: hardware and setup cost. Free GPU compute, zero configuration, pre-installed libraries — a beginner can run deep learning experiments in minutes of creating an account.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What should be the FIRST Kaggle competition a beginner enters?',
        options: [
          'The highest prize competition to maximise learning',
          'The Titanic Survival Prediction — specifically designed for beginners with clean data, binary classification, and massive community support for learning',
          'Any competition with image data',
          'Create your own dataset before entering competitions'
        ],
        correctIndex: 1,
        explanation:
            'Titanic is the canonical beginner competition — clean dataset, simple binary problem, hundreds of community notebooks to learn from, and a leaderboard to measure progress. It teaches the complete ML workflow end to end.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'import numpy as np\narr = np.array([10, 20, 30, 40, 50])\nprint(arr.mean())\nprint(arr[arr > 25])\n\nWhat is printed?',
        options: [
          '30.0 and [30, 40, 50]',
          '30.0 and [10, 20]',
          '150 and [30, 40, 50]',
          'Error — NumPy does not support boolean indexing'
        ],
        correctIndex: 0,
        explanation:
            'arr.mean() = (10+20+30+40+50)/5 = 30.0. Boolean indexing arr[arr > 25] filters elements greater than 25: [30, 40, 50]. NumPy boolean indexing is one of its most powerful features for data filtering.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You want to explore a 50,000-row dataset about Indian crop yields, visualise distributions, and try linear regression. What is the FASTEST way to start today?',
        options: [
          'Install Python, set up virtual environment, install all packages locally first',
          'Open Google Colab, create a new notebook, upload the CSV, import pandas and matplotlib — everything is pre-installed and you can start in under 2 minutes',
          'Buy a GPU first for proper training',
          'Learn statistics theory before touching the data'
        ],
        correctIndex: 1,
        explanation:
            'Google Colab is the fastest path: browser-based, pre-installed libraries, free GPU, Google Drive integration. Skip all setup friction and start working with real data immediately.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Your First AI Environment — Setup and First Code',
      goal:
          'Set up your complete AI development environment and run your first meaningful AI code on a real dataset.',
      steps: [
        'Open Google Colab and create a new notebook named "AI_Foundations_Lab.ipynb"',
        'Cell 1: Import numpy, pandas, matplotlib, and sklearn — print their versions to verify installation',
        'Cell 2: Load the Iris dataset using sklearn.datasets.load_iris() — print its shape and first 5 rows as a DataFrame',
        'Cell 3: Create 2 visualisations — histogram of petal lengths and scatter plot of sepal vs petal length coloured by species',
        'Cell 4: Train a Decision Tree classifier on Iris data — print train and test accuracy',
        'Cell 5: Make a prediction for a new flower [5.1, 3.5, 1.4, 0.2] — what species does the model predict?',
      ],
      expectedOutput:
          '=== AI Environment Setup Complete ===\nnumpy: 1.24.0 | pandas: 2.0.1 | sklearn: 1.3.0\n\nIris Dataset: 150 samples x 4 features, 3 species\n\nVisualisations: Petal length histogram ✓\n                Sepal vs Petal scatter plot ✓\n\nDecision Tree Results:\n  Training Accuracy: 100.00%\n  Test Accuracy: 97.78%\n\nPrediction for [5.1, 3.5, 1.4, 0.2]:\n  Predicted species: setosa\n\nColab notebook shared link: [your link here]',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'aep_l1_ai_mindset',
    topicTitle: 'AI Mindset & Problem Solving',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 28,
    totalXp: 190,
    emoji: '🧠',
    intro:
        'The difference between a good AI engineer and a great one is not just technical knowledge — it is how they think about problems. AI problem-solving requires a specific mindset: data-driven, experimental, comfortable with uncertainty, and focused on real-world impact over algorithmic elegance. This course builds that mindset.',
    concepts: [
      ConceptLesson(
        title: 'Thinking in Distributions, Not Individual Predictions',
        definition:
            'AI systems make probabilistic predictions — they are right most of the time, not always. An AI engineer thinks about model performance across thousands of predictions (distributions), not individual cases.',
        analogy:
            'A weather forecast of "70% chance of rain" does not fail if it does not rain — the 70% was the correct prediction of a probability. AI engineers evaluate models the same way: over many predictions, is the model well-calibrated and performing at the right level?',
        example:
            'Distribution thinking:\n\nBAD thinking (individual):\n  "My spam filter classified a legitimate email as spam\n  → the model is broken, I should fix it"\n\nGOOD thinking (distribution):\n  "Over 10,000 emails, my spam filter has:\n  99.2% accuracy overall\n  0.3% false positive rate (legit marked as spam)\n  1.1% false negative rate (spam in inbox)\n  This is acceptable — individual errors always\n  occur. Aggregate performance is what matters."\n\nKey metrics to think in:\n  Accuracy, Precision, Recall, F1, AUC-ROC',
        keyTakeaway:
            'Never evaluate an AI model by a single example — always evaluate across a representative test set. Individual errors are expected. The question is whether the DISTRIBUTION of errors is within acceptable bounds.',
      ),
      ConceptLesson(
        title: 'The Experimental Mindset — Hypothesise, Test, Iterate',
        definition:
            'AI development is inherently experimental — you cannot know in advance which algorithm, features, or hyperparameters will work best. The scientific method (hypothesis → experiment → measure → iterate) is the correct workflow.',
        analogy:
            'AI development is like drug discovery — you have many candidate compounds (models), test them systematically in controlled experiments, measure outcomes precisely, and iterate based on results. The best teams run the most experiments.',
        example:
            'Experimental workflow:\n\nHypothesis 1: "Logistic Regression will work\n  for customer churn prediction"\n  → Experiment: Train LR, measure AUC = 0.72\n\nHypothesis 2: "Feature engineering will improve"\n  → Add customer lifetime value, days since purchase\n  → AUC = 0.79\n\nHypothesis 3: "XGBoost will outperform LR"\n  → Train XGB with defaults, AUC = 0.83\n\nHypothesis 4: "Tuning XGB hyperparameters"\n  → Grid search, AUC = 0.87\n\nEach experiment: documented, reproducible, measured',
        keyTakeaway:
            'Track every experiment with: hypothesis, parameters, results, and conclusion. MLflow, Weights and Biases, or even a spreadsheet work. Experiments without documentation get repeated unknowingly.',
      ),
      ConceptLesson(
        title: 'Start Simple, Add Complexity Only When Needed',
        definition:
            'A common beginner mistake is jumping to complex models for every problem. The professional approach: start with the simplest model that might work, measure performance, then add complexity only when simple approaches are demonstrably insufficient.',
        analogy:
            'Start simple is like a doctor prescribing paracetamol before morphine. Start with the mildest effective treatment. Only escalate complexity when simpler approaches clearly fail.',
        example:
            'Complexity escalation ladder:\n\nLevel 1 (Start here):\n  Baseline: predict majority class always\n  Logistic Regression → 89% accuracy\n  Improvement over baseline? Yes, continue.\n\nLevel 2 (If Level 1 insufficient):\n  Feature engineering + Random Forest → 92%\n  Business need met? Maybe stop here.\n\nLevel 3 (If Level 2 insufficient):\n  XGBoost with tuning → 94%\n  Worth added complexity? Evaluate carefully.\n\nLevel 4 (Rarely needed for tabular data):\n  Neural network → 94.2%\n  0.2% gain worth the complexity? Usually no.\n\nDeep Learning: only when Levels 1-3 clearly fail',
        keyTakeaway:
            'The most impressive AI engineers solve hard problems with the simplest possible approach. Complexity is a cost, not a virtue. Always justify adding it with measured performance improvement.',
      ),
      ConceptLesson(
        title: 'Data-First Thinking — Garbage In, Garbage Out',
        definition:
            'The quality and relevance of training data determines AI performance more than algorithm choice. AI engineers spend 60-80% of their time on data — collection, cleaning, labelling, and feature engineering.',
        analogy:
            'A Michelin-star chef cannot make a great dish from rotten ingredients — no amount of cooking skill compensates. AI is identical: the best neural network trained on poor data produces poor results. Invest in data first.',
        example:
            'Data-first thinking for crop disease AI:\n\nStep 1: Data Audit (2 weeks)\n  - Enough images? (need 1000+ per class minimum)\n  - Representative? (all lighting, angles, disease stages)\n  - Labels correct? (expert agronomist review)\n  - Class imbalance? (rare diseases underrepresented)\n\nStep 2: Data Cleaning (1 week)\n  - Remove duplicates and corrupted images\n  - Standardise image size and format\n  - Correct mislabelled examples\n\nStep 3: Data Augmentation (1 week)\n  - Rotate, flip, adjust brightness synthetically\n\nOnly then: Model selection and training (1 week)\n\nResult: Clean data + simple model beats\n        noisy data + complex model every time',
        keyTakeaway:
            'If a model performs poorly, look at the data FIRST before changing the algorithm. 90% of the time, the problem is data quality, not algorithm choice. "More data usually beats better algorithms." — Andrew Ng',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Your image classifier achieves 95% accuracy but misclassifies one of your own photos. Should you retrain the model immediately?',
        options: [
          'Yes — any wrong prediction indicates the model needs fixing',
          'No — evaluate across your entire test set. 95% accuracy means 5% errors are expected. One misclassified photo is not evidence of a systematic problem.',
          'Yes — user-visible errors are always unacceptable',
          'No — never retrain a model once deployed'
        ],
        correctIndex: 1,
        explanation:
            'Thinking in distributions: 95% accuracy means 1 in 20 predictions will be wrong — this is expected. Individual errors need investigation only when they reveal systematic failures in specific subgroups, not random expected errors.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'You have customer churn data with 15 features. What should you build FIRST?',
        options: [
          'A deep neural network — most powerful option',
          'A Logistic Regression baseline — simple, fast, interpretable. Establish what "simple" achieves before deciding if complexity is worth adding.',
          'XGBoost — best for tabular data always',
          'A rule-based system — ML is overkill for churn'
        ],
        correctIndex: 1,
        explanation:
            'Start simple: Logistic Regression on tabular data gives a baseline quickly. If it achieves 89% and you need 95%, that gap justifies complexity. If it achieves 93% and you need 94%, the marginal gain may not justify moving to XGBoost.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Your model performs poorly despite a sophisticated architecture. What should you investigate FIRST?',
        options: [
          'Try a different neural network architecture',
          'Audit the data: Is training data sufficient? Are labels correct? Is there class imbalance? Is test data representative? Data problems cause 80% of ML failures.',
          'Increase model size and training time',
          'Switch to a different ML framework'
        ],
        correctIndex: 1,
        explanation:
            'Poor performance is overwhelmingly caused by data problems, not architecture choices. Incorrect labels, insufficient data, class imbalance, train/test distribution mismatch — fix these before changing models.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A CTO says "We need a Transformer-based neural network to classify customer support emails into 5 categories." You have 2,000 labelled emails. What do you say?',
        options: [
          '"Great — let us start training the Transformer immediately"',
          '"With 2,000 samples, start with TF-IDF + Logistic Regression (trains in minutes). Measure accuracy. Only escalate to BERT fine-tuning if classical ML is insufficient — Transformers need much more data to outperform simpler baselines."',
          '"Transformers do not work for text classification"',
          '"2,000 samples is too small for any AI — collect more first"'
        ],
        correctIndex: 1,
        explanation:
            'Start simple: TF-IDF + Logistic Regression on 2,000 samples is fast, interpretable, and often achieves 85-90% accuracy on email classification. BERT fine-tuning adds complexity and cost for marginal gains at this data size.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You train an AI on Monday\'s customer purchase data. On Friday, the model\'s predictions become much less accurate. Most likely cause?',
        options: [
          'The model code has a bug',
          'Data drift — Friday shopping patterns (weekend behaviour, sale events) differ from Monday. The model encounters out-of-distribution data it was not trained on.',
          'The server is too slow on Fridays',
          'The model needs to be retrained every day always'
        ],
        correctIndex: 1,
        explanation:
            'Data drift is when real-world data distribution changes after a model is trained. Weekend vs weekday shopping behaviour is a classic drift scenario. AI engineers must monitor performance continuously and have retraining pipelines ready.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'AI Problem Framing Workshop',
      goal:
          'Take 3 real business problems and frame them as AI problems with correct approach, metrics, and data requirements.',
      steps: [
        'Problem 1: A hospital wants to reduce patient readmissions within 30 days of discharge',
        'Problem 2: An e-commerce company wants to show personalised product recommendations',
        'Problem 3: A bank wants to approve or reject personal loan applications in 30 seconds',
        'For each: Is this classification, regression, or recommendation? What is the target variable? What data is needed? What metric to optimise? What does success look like?',
        'For Problem 3 (loan): identify 2 ethical risks and how you would mitigate them',
        'Propose the starting approach (simple baseline), escalation path if insufficient, and one key risk to monitor in production',
      ],
      expectedOutput:
          'Problem 1: Hospital Readmissions\n  Type: Binary Classification (readmitted in 30d: yes/no)\n  Features: diagnosis codes, age, medications, social factors\n  Metric: Recall (must catch at-risk patients)\n  Baseline: Logistic Regression on structured EHR data\n  Risk: Demographic bias in predictions\n\nProblem 2: E-commerce Recommendations\n  Type: Collaborative Filtering + Ranking\n  Metric: Click-through rate, conversion, revenue\n  Start: Matrix factorisation → neural CF if needed\n\nProblem 3: Loan Approval\n  Type: Binary Classification with probability\n  Ethics: Fairness testing across income groups,\n          right to explanation for each rejection\n  Baseline: Logistic Regression (interpretable)\n  Monitor: Approval rate by demographic group ✓',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'aep_l1_capstone',
    topicTitle: 'AI Foundations Capstone Project',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Medium',
    estimatedMinutes: 45,
    totalXp: 280,
    emoji: '🏆',
    intro:
        'This is your Level 1 capstone — where you demonstrate mastery of AI foundations by building a complete, end-to-end ML project. You will define a problem, explore data, train your first model, evaluate it properly, and document everything professionally. This project goes on your portfolio and marks your transformation from AI learner to AI builder.',
    concepts: [
      ConceptLesson(
        title: 'The End-to-End AI Project Workflow',
        definition:
            'A complete AI project follows a systematic workflow: Problem Definition → Data Collection → Exploratory Data Analysis → Preprocessing → Model Training → Evaluation → Documentation.',
        analogy:
            'An AI project workflow is like building a house — you cannot skip the foundation (data) and jump to painting walls (model training). Every step enables the next. Missing steps cause expensive failures.',
        example:
            'Complete AI project workflow:\n\n1. PROBLEM DEFINITION\n   What exactly are we predicting?\n   What metric matters to the business?\n   What does success look like?\n\n2. DATA COLLECTION AND LOADING\n   Find or collect relevant dataset\n   Load into pandas DataFrame\n   Understand columns and data types\n\n3. EXPLORATORY DATA ANALYSIS (40% of time)\n   Shape, missing values, distributions\n   Target variable analysis\n   Correlations and visualisations\n\n4. DATA CLEANING AND FEATURES\n   Handle missing values (justify approach)\n   Encode categorical variables\n   Train/test split (80/20, stratified)\n\n5. MODEL TRAINING\n   Baseline model first\n   Then improved model\n\n6. EVALUATION\n   Metrics appropriate for the problem\n   Confusion matrix, feature importance\n\n7. DOCUMENTATION\n   Clear README, findings, next steps',
        keyTakeaway:
            'This workflow is the professional standard for every AI project. Internalise it. Every Kaggle competition, every company AI project, every research implementation follows this sequence — in exactly this order.',
      ),
      ConceptLesson(
        title: 'Exploratory Data Analysis (EDA) — Know Your Data',
        definition:
            'EDA is the process of understanding your dataset before modelling — distributions, missing values, correlations, outliers, and class imbalance. Skipping EDA leads to models trained on misunderstood data.',
        analogy:
            'EDA is like reading a recipe thoroughly before cooking — if you skip this and dive in, you might discover halfway through that you are missing a key ingredient. EDA prevents expensive mid-project discoveries.',
        example:
            '# Essential EDA in pandas:\nimport pandas as pd\nimport matplotlib.pyplot as plt\nimport seaborn as sns\n\ndf = pd.read_csv("dataset.csv")\n\n# 1. Basic overview\nprint(df.shape)        # rows, columns\nprint(df.dtypes)       # data types\nprint(df.head())\n\n# 2. Missing values\nprint(df.isnull().sum())\nprint(df.isnull().mean() * 100)  # % missing\n\n# 3. Target distribution\ndf["target"].value_counts().plot(kind="bar")\n\n# 4. Numeric distributions\ndf.describe()\ndf.hist(figsize=(12, 8))\n\n# 5. Correlations\nsns.heatmap(df.corr(), annot=True)\n\n# 6. Outliers\ndf.boxplot()',
        keyTakeaway:
            'You will find surprising things through EDA: columns with 40% missing values, 95:5 class imbalance, features perfectly correlated with the target (data leakage). These findings completely change your modelling approach.',
      ),
      ConceptLesson(
        title: 'Model Evaluation — Measuring What Matters',
        definition:
            'Choosing the right evaluation metric is as important as choosing the right algorithm. Accuracy is misleading for imbalanced datasets; precision/recall trade-offs depend on the cost of each error type.',
        analogy:
            'Choosing the right metric is like choosing the right measuring tool — you would not measure a room\'s temperature with a ruler. Each metric answers a different question about model performance.',
        example:
            'Metric selection guide:\n\nBALANCED BINARY CLASSIFICATION:\n  Accuracy works fine\n  Example: cat vs dog classifier\n\nIMBALANCED CLASSIFICATION:\n  Use Precision, Recall, F1, AUC-ROC\n  Example: fraud detection (0.1% fraud rate)\n  Accuracy of 99.9% by always saying "no fraud"!\n\nCOST-ASYMMETRIC:\n  Cancer screening: high Recall critical\n  (better to overdiagnose than miss cancer)\n  Spam filter: high Precision preferred\n  (better miss spam than lose real emails)\n\nREGRESSION:\n  RMSE, MAE, R-squared\n\nKEY INSIGHT:\n  Always ask: what is the cost of a false positive\n  vs a false negative in THIS specific context?',
        keyTakeaway:
            'Never report only accuracy. Always use metrics appropriate for your problem. For imbalanced classes, accuracy is meaningless — use F1, AUC-ROC, precision, and recall.',
      ),
      ConceptLesson(
        title: 'Communicating AI Results',
        definition:
            'An AI engineer who cannot explain results to non-technical stakeholders will not have their models deployed. Communication is as important as technical skill — perhaps more so in business settings.',
        analogy:
            'A brilliant diagnosis is worthless if the doctor cannot explain it to the patient. An AI model achieving 93% accuracy means nothing to a business leader who needs to understand what errors occur and what decisions it enables.',
        example:
            'Technical → Business communication:\n\nTECHNICAL (for engineer):\n  "XGBoost: AUC-ROC 0.89, F1 0.76,\n  Precision 0.81, Recall 0.72.\n  Top features: days_since_purchase,\n  total_spend, support_tickets."\n\nBUSINESS (for stakeholder):\n  "Our churn model identifies 72 out of every\n  100 customers who will leave — 30 days before\n  they actually leave. For every 100 alerts, 81\n  are genuine churn risks. Based on ₹500\n  intervention cost and ₹8,000 average customer\n  value, the model pays for itself if retention\n  saves just 10% of flagged customers."',
        keyTakeaway:
            'Always translate metrics into business impact. Not "AUC-ROC 0.87" but "correctly identifies 72 of 100 churning customers with a 30-day warning, saving approximately ₹X per month at scale."',
      ),
      ConceptLesson(
        title: 'Your First Portfolio Project — What It Should Include',
        definition:
            'A portfolio-ready AI project goes beyond a working notebook — it includes a clear problem statement, professional documentation, visualisations, model evaluation, and a deployed demo or running instructions.',
        analogy:
            'A portfolio project is like a product launch — not just "it works" but a professional presentation explaining the problem, solution, results, and what you learned. A great model with poor documentation is a restaurant with no sign and a locked door.',
        example:
            'Capstone project README template:\n\n# Project Title — One compelling line\n\n## Problem Statement\n[What problem? For whom?]\n\n## Dataset\n[Source, size, features, target variable]\n\n## Approach\n1. EDA findings (2-3 key insights with charts)\n2. Data preprocessing steps and why\n3. Models tried and results\n\n## Results\n[Table: Model | Accuracy | F1 | AUC]\n\n## Key Findings\n[3 non-obvious insights]\n\n## How to Run\n1. Open in Google Colab (link)\n2. Run All Cells\n\n## What I Would Do With More Time\n[Shows engineering thinking and self-awareness]',
        keyTakeaway:
            '"What I Would Do With More Time" is especially powerful — it shows you understand your work\'s limitations and can think about improvement. This self-awareness signals senior-level thinking even in beginner projects.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'A dataset has 95% "no diabetes" and 5% "diabetes" cases. A model predicts "no diabetes" for every patient and achieves 95% accuracy. Is this model useful?',
        options: [
          'Yes — 95% accuracy is excellent',
          'No — this is a degenerate model catching zero diabetes cases. For imbalanced medical data, accuracy is meaningless. Recall for the positive class is the critical metric — this model has 0% recall.',
          'Yes — use it until a better model is available',
          'Depends on the patient population'
        ],
        correctIndex: 1,
        explanation:
            'This is the class imbalance trap. Always report Recall for positive class — this model catches 0% of actual diabetics. For healthcare, missing the disease is catastrophic. Use recall, F1, and AUC-ROC on imbalanced medical datasets.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'In your EDA you find that "employee_id" has 99% correlation with the target "salary". Should you include this feature in your model?',
        options: [
          'Yes — high correlation means high predictive power',
          'No — this is data leakage. Employee_id should have no causal relationship with salary; the correlation is likely an artifact of how data was collected. Including it produces inflated training accuracy that will not generalise.',
          'Yes — use any feature with high correlation',
          'It depends on your business problem'
        ],
        correctIndex: 1,
        explanation:
            'Data leakage is when a feature correlates with the target due to data collection artifacts, not a meaningful relationship. Including leaked features produces inflated training metrics but fails completely on new data. Always ask: would this feature be available at prediction time for a new sample?',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A product manager asks "How accurate is your model?" What is the BEST response from an AI engineer?',
        options: [
          '"It is 87% accurate"',
          '"Accuracy of 87%, but more importantly: it correctly identifies 91 of 100 actual fraud cases (recall) with 84% of flagged cases being real fraud (precision). At our transaction volume this prevents approximately ₹2L in monthly fraud losses."',
          '"The AUC-ROC is 0.93 and F1 is 0.87"',
          '"It depends on the threshold we set"'
        ],
        correctIndex: 1,
        explanation:
            'The best answer translates technical metrics into business impact: what percentage of real problems are caught, what percentage of alerts are real, and what is the business value. This is how AI engineers earn trust and get models deployed.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your spam classifier correctly identifies 98% of spam but also blocks 15% of legitimate emails. What metric reveals this 15% problem and how do you fix it?',
        options: [
          'Accuracy — just improve overall accuracy',
          'False Positive Rate (15% of legitimate emails flagged). Fix: lower the classification threshold to reduce false positives, accepting that some spam may get through — then communicate the trade-off to stakeholders.',
          'Recall — you need to catch more spam',
          'F1 score — balance both errors equally'
        ],
        correctIndex: 1,
        explanation:
            'False Positive Rate reveals legitimate emails being blocked. Lowering the classification threshold (e.g., from 0.5 to 0.7) means the model must be more confident before flagging — reducing false positives at the cost of missing some spam. This is the precision-recall trade-off every production classifier must navigate.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'During EDA you find "employee_id" has 99% correlation with salary. Another engineer says "great, this will make our model very accurate!" What is the correct response?',
        options: [
          'Agree — high correlation is always good for models',
          'Warn about data leakage: employee_id has no business relationship with salary. Including it will inflate training accuracy but fail on new employees. Remove it and retrain to get honest performance estimates.',
          'Include it but mention it in the documentation',
          'Run the model with it and see what happens first'
        ],
        correctIndex: 1,
        explanation:
            'Data leakage inflated training accuracy collapses when the model sees new data where the leaked feature does not have the same spurious correlation. Always identify and remove leaked features before training — they create false confidence in model performance.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'AI Foundations Capstone — End-to-End ML Project',
      goal:
          'Build, evaluate, and document a complete end-to-end machine learning project — your first professional AI portfolio piece.',
      steps: [
        'Choose your dataset: Titanic (beginner), Heart Disease UCI (intermediate), or any India-specific Kaggle dataset you care about',
        'Phase 1 EDA (40% of time): load data, check shape/types/missing values, visualise all feature and target distributions, identify 3 interesting insights, plot correlation heatmap',
        'Phase 2 Preprocessing: handle missing values (justify approach), encode categoricals, create 80/20 train/test split stratified on target',
        'Phase 3 Modelling: train at least 2 models (start with Logistic Regression baseline, then Random Forest or XGBoost), compare performance side by side',
        'Phase 4 Evaluation: report accuracy, precision, recall, F1, and AUC-ROC — plot confusion matrix and feature importance chart',
        'Phase 5 Documentation: write professional README with problem statement, 3 EDA visualisation screenshots, results comparison table, key insights, and What I Would Do With More Time section',
        'Share your Colab notebook (public link) and write a 3-sentence non-technical summary of your project',
      ],
      expectedOutput:
          '=== AI Foundations Capstone Complete ===\n\nDataset: Heart Disease UCI (303 patients, 14 features)\nProblem: Predict presence of heart disease (binary)\n\nEDA Insights:\n  1. Age and max heart rate strongly correlated with disease\n  2. Chest pain type 4 (asymptomatic) has highest disease rate\n  3. 45% have heart disease — moderately balanced dataset\n\nModel Comparison:\n  Model              | Accuracy | Recall | AUC-ROC\n  Logistic Regression|  83.6%   |  0.87  |  0.89\n  Random Forest      |  88.5%   |  0.91  |  0.94\n\nBest model: Random Forest (AUC 0.94)\nTop features: max heart rate, chest pain type, thalassemia\n\nConfusion matrix plotted ✓\nFeature importance chart ✓\n\nNon-technical summary:\n"Our AI examines 13 health measurements and correctly\nidentifies 91 out of 100 heart disease patients — giving\ndoctors an early warning that enables potentially\nlife-saving intervention."\n\nColab notebook: [your public link]\nGitHub repository: [your link]',
      xpReward: 80,
    ),
  ),
];
