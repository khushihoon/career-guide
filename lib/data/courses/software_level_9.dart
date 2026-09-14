// ══════════════════════════════════════════════════════════════════════
// lib/models/software_courses_level9.dart
// Software Engineering Learning Path — LEVEL 9: Software Engineering
// ══════════════════════════════════════════════════════════════════════
import '../../models/course_content_data.dart'; 


const List<TopicCourse> softwareCoursesLevel9 = [

  TopicCourse(
    id: 'sep_l9_sdlc',
    topicTitle: 'SDLC',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 200,
    emoji: '🔄',
    intro: 'The Software Development Life Cycle (SDLC) is the structured process every professional software team follows to plan, build, test, and deliver software. Understanding SDLC models separates engineers who just write code from those who understand how software is professionally built from inception to production.',
    concepts: [
      ConceptLesson(
        title: 'What is the SDLC?',
        definition: 'The Software Development Life Cycle is a structured framework of phases that guide a software project from initial idea to deployment and maintenance — ensuring quality, predictability, and alignment with business needs.',
        analogy: 'The SDLC is like constructing a building. You do not start pouring concrete before having blueprints (design), permits (requirements approval), or a foundation plan (architecture). Skipping phases creates buildings that collapse — and software that fails in production.',
        example: 'Classic SDLC Phases:\n1. Planning     — scope, feasibility, resource estimation\n2. Requirements — what the system must do\n3. Design       — architecture, database, UI wireframes\n4. Implementation — actual coding\n5. Testing      — unit, integration, system, UAT\n6. Deployment   — release to production\n7. Maintenance  — bug fixes, updates, monitoring',
        keyTakeaway: 'Every software project goes through these phases — the difference between SDLC models is HOW and in what order. Waterfall does them once sequentially; Agile does them repeatedly in short cycles.',
      ),
      ConceptLesson(
        title: 'Waterfall Model',
        definition: 'Waterfall is a sequential SDLC model where each phase must be fully completed before the next begins. Requirements are locked upfront, and working software is only delivered at the end.',
        analogy: 'Waterfall is like building a dam — you must complete the foundation before building walls, walls before installing gates. If requirements change halfway through, the cost is enormous.',
        example: 'Waterfall 12-month project:\nMonths 1-2:  Requirements\nMonths 3-4:  Design\nMonths 5-9:  Development\nMonths 10-11: Testing\nMonth 12:    Deployment\n\nProblems:\n• Working software only after 12 months\n• Requirements locked but change during 12 months\n• Bugs found in month 10 are very expensive to fix',
        keyTakeaway: 'Waterfall works for truly fixed requirements (government contracts, safety-critical systems). For most modern software where requirements evolve, it is too rigid.',
      ),
      ConceptLesson(
        title: 'Iterative and Incremental Models',
        definition: 'Iterative models build the system through repeated cycles, with each cycle delivering working software. Feedback from each iteration shapes the next — requirements can evolve.',
        analogy: 'Iterative development is like sculpting. You start rough, chip away more detail each round, and refine based on what you see. You never carve the entire final sculpture blindly in one pass.',
        example: 'Iterative 12-month project:\nIteration 1 (Month 1-2): Core auth, basic dashboard → feedback\nIteration 2 (Month 3-4): Product catalog, search → feedback\nIteration 3 (Month 5-6): Orders, checkout → feedback\n...\nEach iteration: working software + real stakeholder feedback',
        keyTakeaway: 'Iterative models let you validate assumptions early. Discovering a wrong feature in iteration 1 costs 2 weeks to fix. Discovering it in waterfall month 11 costs the entire project budget.',
      ),
      ConceptLesson(
        title: 'SDLC in Real Modern Teams',
        definition: 'Modern software teams blend SDLC phases with Agile sprints and CI/CD pipelines — all phases happen continuously and in parallel rather than sequentially once.',
        analogy: 'Modern SDLC is like a restaurant kitchen during service — planning, cooking, quality checking, and serving all happen simultaneously for different dishes, not one full cycle for each dish.',
        example: 'A typical sprint in a modern team:\nMonday:    Sprint planning (requirements)\nMon-Thu:   Development + code review (implementation)\nAll week:  Automated tests on every commit (testing)\nFriday:    Sprint demo to stakeholders (delivery)\nAll week:  Monitoring of last sprint production (maintenance)',
        keyTakeaway: 'All SDLC phases still exist — just compressed into 1-2 weeks and running in tight loops. Understanding this is expected in any engineering interview.',
      ),
      ConceptLesson(
        title: 'Functional vs Non-Functional Requirements',
        definition: 'Functional requirements describe WHAT the system does (features). Non-functional requirements (NFRs) describe HOW WELL — performance, reliability, security, scalability, and maintainability.',
        analogy: 'Car functional: "seats 5, has AC, plays music." Non-functional: "0-100 in 8 seconds, 15km/L, crash-safe." Both matter enormously.',
        example: 'Functional:\n  "Users can register with email and password"\n  "System must send order confirmation email"\n\nNon-functional (NFRs):\n  Performance:   "API response < 200ms at P95"\n  Availability:  "99.9% uptime"\n  Security:      "bcrypt passwords, HTTPS only"\n  Scalability:   "Handle 10,000 concurrent users"',
        keyTakeaway: 'NFRs drive 80% of architecture decisions. Engineers who skip NFRs build systems that work in testing but collapse in production.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main disadvantage of the Waterfall model for most modern software?',
        options: [
          'It produces too much documentation',
          'Working software only delivered at the end, requirements locked upfront, late feedback extremely expensive',
          'It requires too many developers',
          'It does not include a testing phase'
        ],
        correctIndex: 1,
        explanation: 'Waterfall\'s sequential lock-in-first approach means stakeholders see nothing for months, and when requirements change (they always do), revisiting earlier phases is enormously expensive.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which of these is a Non-Functional Requirement (NFR)?',
        options: [
          'Users can add items to a shopping cart',
          'The system must respond to 95% of API requests within 200 milliseconds',
          'Admins can view all orders',
          'Users receive an email after registration'
        ],
        correctIndex: 1,
        explanation: 'NFRs define HOW WELL a system performs — performance, availability, security, scalability. "200ms at P95" is a performance NFR. The others describe WHAT the system does — functional requirements.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the key advantage of iterative SDLC over waterfall?',
        options: [
          'It requires less documentation',
          'Working software and stakeholder feedback arrive early, allowing course correction before most budget is spent',
          'Development is always faster',
          'Testing is eliminated'
        ],
        correctIndex: 1,
        explanation: 'Early, frequent feedback is the core value. Discovering a wrong feature assumption in iteration 1 costs 2 weeks. In waterfall month 11 it costs the entire project.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A startup has rapidly changing requirements and weekly investor feedback. Which SDLC fits best?',
        options: [
          'Waterfall — locks requirements and prevents scope creep',
          'Iterative/Agile — short cycles deliver features weekly, rapid pivots based on real feedback',
          'No process — move fast and fix bugs later',
          'Waterfall for features, Agile for bugs only'
        ],
        correctIndex: 1,
        explanation: 'Rapidly changing requirements and frequent feedback loops are exactly what Agile/iterative models handle. Waterfall would lock requirements the startup knows will change, wasting months.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: '"The system must allow users to login." Functional or non-functional requirement?',
        options: [
          'Non-functional — it describes security',
          'Functional — it describes a specific feature the system must perform',
          'Both functional and non-functional',
          'Neither — it is a business requirement'
        ],
        correctIndex: 1,
        explanation: 'A functional requirement describes WHAT the system does — a specific feature. "Allow users to login" is a feature. A related NFR: "login must complete within 500ms" or "use MFA for admins."',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'SDLC Planning Document',
      goal: 'Create a complete SDLC plan for a real project covering all phases with functional and non-functional requirements.',
      steps: [
        'Choose a project: online exam platform, food delivery app, or hospital appointment system',
        'Write 8 functional requirements covering core user flows',
        'Write 5 NFRs with specific measurable targets (e.g. "P95 response < 200ms", "99.9% uptime")',
        'Create an iterative plan: 4 two-week iterations with features assigned to each',
        'Identify 3 risks with a mitigation strategy for each',
        'Write why iterative was chosen over waterfall for this project',
      ],
      expectedOutput: 'Project: Online Exam Platform\nFunctional (8): Create exam, questions, student login, take exam, auto-grade, results, admin reports, certificates\nNFRs (5): <500ms load, 99.9% uptime, 10k concurrent, WCAG 2.1, AES-256\nIteration Plan: Sprint1 Auth, Sprint2 Exam engine, Sprint3 Grading, Sprint4 Reports\nRisks documented ✓',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sep_l9_agile',
    topicTitle: 'Agile',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 195,
    emoji: '⚡',
    intro: 'Agile transformed the software industry. Over 90% of professional software teams use some form of Agile. Understanding its values, principles, and why it exists is not optional — it is how modern software engineering works. Every software engineering job interview will reference Agile.',
    concepts: [
      ConceptLesson(
        title: 'The Agile Manifesto',
        definition: 'The Agile Manifesto (2001) established 4 values prioritising people, working software, collaboration, and responsiveness over rigid processes and documentation.',
        analogy: 'The Agile Manifesto was a declaration of independence from the waterfall empire — 17 experienced developers documented what actually worked in practice, creating a shared philosophy for the industry.',
        example: 'The 4 Agile Values:\n1. Individuals and interactions  OVER processes and tools\n2. Working software              OVER comprehensive documentation\n3. Customer collaboration        OVER contract negotiation\n4. Responding to change          OVER following a plan\n\n"While there is value in items on the right,\nwe value items on the left more."',
        keyTakeaway: 'Agile does NOT mean no documentation. It means people and working code are more valuable than process artifacts. Documentation still exists — it serves the team rather than being an end in itself.',
      ),
      ConceptLesson(
        title: 'Core Agile Principles in Practice',
        definition: 'The 12 Agile principles translate manifesto values into concrete guidance: early continuous delivery, welcome changing requirements, frequent working software, and sustainable pace.',
        analogy: 'Agile principles are the rules of a consistently winning sports team: practice daily, adjust strategy mid-game, involve coaches throughout, and do not burn out players.',
        example: '"Deliver working software frequently — weeks not months"\n→ Sprint demos every 2 weeks\n\n"Welcome changing requirements even late in development"\n→ Backlog can be reprioritised any time before a sprint\n\n"Sustainable pace — able to maintain indefinitely"\n→ No death marches; crunch time is a process failure',
        keyTakeaway: 'The sustainable pace principle is violated by most companies claiming to "do Agile." Consistent crunch is not Agile — it is a sign of poor estimation, planning, and scope management.',
      ),
      ConceptLesson(
        title: 'User Stories',
        definition: 'A user story is a requirement written from the user\'s perspective: "As a [role], I want [feature] so that [benefit]." It captures WHO, WHAT, and WHY without specifying implementation.',
        analogy: 'A user story is a traveller\'s hotel request: "As a frequent business traveller, I want express phone check-in so that I go straight to my room without queuing." Tells the hotel WHAT the guest needs without dictating HOW to build the system.',
        example: '"As a customer, I want to filter products by price range\n so that I can find items within my budget."\n\n"As an admin, I want to export sales as CSV\n so that I can analyse data in Excel."\n\nAcceptance Criteria format:\nGiven: [context]\nWhen: [action]\nThen: [expected outcome]',
        keyTakeaway: 'User stories shift focus from "what to build" to "who benefits and why." This prevents building features nobody uses because the WHY was never questioned.',
      ),
      ConceptLesson(
        title: 'Story Points and Estimation',
        definition: 'Story points are relative units of effort (not hours) estimating complexity. Teams compare stories against each other rather than predicting absolute time.',
        analogy: 'Story points are like shirt sizes — S, M, L, XL. Everyone agrees XL is bigger than S. Story points capture relative complexity without false precision in time estimates.',
        example: 'Fibonacci-like scale: 1, 2, 3, 5, 8, 13, 21\n\n"User login" = 3 points (reference)\n"Password reset flow" = 5 points (slightly bigger)\n"Social OAuth integration" = 13 points (much more complex)\n\nPlanning Poker: each team member votes simultaneously\nto avoid anchoring bias. Discuss when votes differ.',
        keyTakeaway: 'Story points are meaningless across teams. They only make sense WITHIN a team to track velocity and forecast future work. Never convert to hours for external commitments.',
      ),
      ConceptLesson(
        title: 'Agile Anti-Patterns — Dark Agile',
        definition: '"Dark Agile" occurs when teams adopt Agile terminology but none of the values — standups become status reports, sprints become mini-waterfalls, retrospectives are skipped.',
        analogy: 'Dark Agile is a gym that sells memberships and has equipment but the culture is sedentary — people talk about fitness without actually exercising.',
        example: 'Common Dark Agile anti-patterns:\n\n"Sprint waterfall": Design all week 1, build week 2, test week 3\n"Estimation abuse": Story points used as hard deadlines\n"No retrospectives": Skip the primary improvement mechanism\n"No sprint demos": Lose the feedback loop that defines Agile\n"Backlog neglect": Graveyard of irrelevant old stories',
        keyTakeaway: 'Understanding Dark Agile helps identify and improve dysfunctional teams. Distinguishing genuine Agile from impostors signals real engineering experience in interviews.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'According to the Agile Manifesto, what is valued MORE than comprehensive documentation?',
        options: [
          'Detailed technical specifications',
          'Working software',
          'Formal contracts',
          'Strict adherence to plans'
        ],
        correctIndex: 1,
        explanation: 'The manifesto values "working software over comprehensive documentation" — a running, tested product delivers more value than documents about what it should eventually do.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the correct format for a user story?',
        options: [
          '"The system shall allow users to log in with email and password"',
          '"As a [role], I want [feature] so that [benefit]"',
          '"TODO: implement login"',
          '"Login feature — 3 days development"'
        ],
        correctIndex: 1,
        explanation: 'User stories follow "As a [role], I want [feature] so that [benefit]" — capturing who, what, and why. This format keeps focus on user value over technical implementation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does consistent crunch time in an "Agile" team indicate?',
        options: [
          'High team commitment and Agile excellence',
          'A violation of sustainable pace — symptom of poor estimation, scope management, or planning',
          'Normal in software development',
          'The team works on important features'
        ],
        correctIndex: 1,
        explanation: 'Sustainable pace is a core Agile principle. Regular crunch indicates process problems: over-commitment, poor estimation, scope creep — not a sign of good Agile practice.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Rewrite as a proper user story: "Build a search feature with filters for price, category, and rating."',
        options: [
          '"Implement ElasticSearch with faceted search"',
          '"As a shopper, I want to filter search results by price, category, and rating so that I can quickly find products matching my preferences"',
          '"Search feature — 8 story points, due Friday"',
          '"Search must return results in under 100ms"'
        ],
        correctIndex: 1,
        explanation: 'A proper user story captures WHO (shopper), WHAT (filter by price/category/rating), and WHY (find relevant products quickly). It avoids implementation details like ElasticSearch.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'A manager says "You estimated 40 story points so you MUST deliver exactly 40 this sprint." What Agile principle is violated?',
        options: [
          'No principle violated — accountability matters',
          'Story points are estimates not commitments — treating them as hard deadlines creates incentives to sandbag rather than improve accuracy',
          'Only the Scrum Master can discuss story points',
          'Convert to hours first'
        ],
        correctIndex: 1,
        explanation: 'Story points are probabilistic estimates for planning, not contractual commitments. Treating them as exact deliverables destroys trust and undermines the entire purpose of Agile estimation.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Agile Product Backlog',
      goal: 'Create a prioritised product backlog with user stories, acceptance criteria, and story points.',
      steps: [
        'Write 10 user stories in correct format covering core user journeys',
        'Add acceptance criteria (Given/When/Then) to at least 5 stories',
        'Estimate each story with Fibonacci story points and justify relative sizing',
        'Prioritise: 3 Must Have (Sprint 1), 4 Should Have, 3 Nice to Have',
        'Identify 2 stories over 8 points and split each into 2 smaller stories',
        'Final backlog: 12 stories with estimates, priorities, and acceptance criteria',
      ],
      expectedOutput: 'Product Backlog (12 stories after splitting):\n[MUST HAVE Sprint 1]\n  #1 User registration (3 pts)\n  #2 User login (2 pts)\n  #3 Browse products (5 pts)\n[SHOULD HAVE]\n  #4a Search basics (5 pts) — split from 13pt story\n  #4b Search filters (5 pts)\n[NICE TO HAVE]\n  #10 Social login (8 pts)\nAll stories: acceptance criteria ✓ | Fibonacci estimates ✓',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sep_l9_scrum',
    topicTitle: 'Scrum',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 195,
    emoji: '🏉',
    intro: 'Scrum is the most widely used Agile framework — over 70% of Agile teams use it. Every engineering job description mentions it. Understanding Scrum roles, ceremonies, and artefacts and knowing how to make them effective is a day-one skill at most professional software companies.',
    concepts: [
      ConceptLesson(
        title: 'Scrum Roles',
        definition: 'Scrum has three roles: Product Owner (defines what to build, prioritises backlog), Scrum Master (facilitates process, removes impediments), and Development Team (builds the product).',
        analogy: 'A restaurant: Product Owner is the owner deciding the menu. Scrum Master is the head waiter ensuring the kitchen runs smoothly. Development Team is the kitchen cooking the dishes.',
        example: 'Product Owner:\n  • Owns and prioritises the Product Backlog\n  • Defines user stories and acceptance criteria\n  • Makes business decisions on what to build next\n\nScrum Master:\n  • Facilitates all ceremonies\n  • Removes impediments (blockers)\n  • NOT a manager — servant-leader\n\nDevelopment Team:\n  • Self-organising — decides HOW to build\n  • Cross-functional — all skills in one team\n  • Typically 3-9 people',
        keyTakeaway: 'The Scrum Master is NOT a project manager and does NOT assign work. They are a servant-leader optimising the team\'s process. This distinction is critical and commonly misunderstood.',
      ),
      ConceptLesson(
        title: 'The Sprint',
        definition: 'A Sprint is a fixed-length iteration (typically 2 weeks) during which the team builds a potentially shippable product increment.',
        analogy: 'A sprint is like a race lap — fixed distance, same start point (planning), same finish (review), then immediately the next lap begins. The team improves with each lap.',
        example: 'Two-week Sprint structure:\nDay 1:    Sprint Planning (2-4 hours)\n          → Select stories, create Sprint Backlog\nDays 2-9: Development\n          → Daily Standups (15 min)\n          → CI/CD and code reviews\nDay 10:   Sprint Review (1-2 hours)\n          → Demo to stakeholders, gather feedback\nDay 10:   Sprint Retrospective (1-1.5 hours)\n          → How can we improve our PROCESS?',
        keyTakeaway: 'A sprint is a time-box — it NEVER extends. Incomplete items return to the backlog. Scope adjusts to the time-box, not the other way around.',
      ),
      ConceptLesson(
        title: 'Scrum Ceremonies',
        definition: 'Five ceremonies: Sprint Planning (plan the sprint), Daily Standup (15-min daily sync), Sprint Review (demo), Sprint Retrospective (process improvement), Backlog Refinement (prepare future stories).',
        analogy: 'Scrum ceremonies are scheduled engine maintenance — daily oil checks (standups), tune-ups (retrospectives) — keeping the team running at peak efficiency rather than breaking down unexpectedly.',
        example: 'Daily Standup — 3 questions, 15 min MAX:\n1. What did I complete yesterday?\n2. What will I complete today?\n3. Are there any blockers?\n\nGood: "Finished auth API yesterday. Password reset today. No blockers."\nBad: "Yesterday I was working on auth, had a JWT issue, tried several things, eventually found a Stack Overflow..." → STOP. Discuss offline.',
        keyTakeaway: 'Standups are for synchronisation — NOT detailed status reports. If it regularly exceeds 15 minutes, the team is having meetings-within-a-meeting.',
      ),
      ConceptLesson(
        title: 'Scrum Artefacts',
        definition: 'Three artefacts: Product Backlog (all known work, PO prioritises), Sprint Backlog (work for this sprint), Increment (working integrated product after each sprint).',
        analogy: 'Product Backlog is the full-year shopping list. Sprint Backlog is this week\'s list. The Increment is what you actually bought and put in the fridge — usable right now.',
        example: 'Product Backlog (PO maintains):\n  Priority 1: Auth (5pts)\n  Priority 2: Product catalog (8pts)\n  ...\n  Priority 47: Dark mode (3pts)\n\nSprint Backlog (Team selects at planning):\n  Auth (5pts) + Catalog (8pts) = 13pts\n\nDefinition of Done (DoD):\n  Code written + tests passing + code reviewed\n  + deployed to staging + docs updated',
        keyTakeaway: 'The Definition of Done must be a team agreement on a quality gate. "Partial completion" is not done — it returns to the backlog. Weak DoD leads to accumulating technical debt sprint by sprint.',
      ),
      ConceptLesson(
        title: 'Sprint Retrospective',
        definition: 'The retrospective is the most important Scrum ceremony — dedicated time for the team to inspect their own process and identify concrete improvements for the next sprint.',
        analogy: 'A retrospective is like a sports team watching game tape — not to blame players but to adjust tactics and enter the next game better prepared.',
        example: 'Start/Stop/Continue format:\n\nSTART:\n  "Write tests before submitting PRs"\n  "Document APIs in Swagger as we build"\n\nSTOP:\n  "Long discussions in standup — park offline"\n  "Skipping review on small changes"\n\nCONTINUE:\n  "Pair programming on complex features"\n\nEach retro: pick 1-2 CONCRETE action items\nassigned to specific people for next sprint.',
        keyTakeaway: 'Retrospectives without concrete action items are complaints sessions. Every retro must end with assigned actions. Review them at the START of the next retro.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the Scrum Master\'s primary responsibility?',
        options: [
          'Assigning tasks and evaluating performance',
          'Facilitating ceremonies, removing impediments, coaching team as a servant-leader',
          'Writing user stories and prioritising the backlog',
          'Making architectural decisions'
        ],
        correctIndex: 1,
        explanation: 'The Scrum Master is a servant-leader — facilitating, coaching, and removing blockers. They do NOT manage people or assign work. That role confusion is a common anti-pattern.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What happens to unfinished Sprint Backlog items at the end of a Sprint?',
        options: [
          'Sprint is extended until complete',
          'Returned to Product Backlog for reprioritisation in future sprints',
          'Abandoned permanently',
          'Team works overtime to finish'
        ],
        correctIndex: 1,
        explanation: 'Sprints are time-boxed and never extended. Incomplete items return to the Product Backlog where the PO reprioritises. Scope adjusts to time, not the reverse.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the purpose of the Sprint Retrospective?',
        options: [
          'Demo completed features to stakeholders',
          'Team inspects its own process and identifies concrete improvements for the next sprint',
          'Plan the next sprint\'s work',
          'Product Owner reviews backlog priority'
        ],
        correctIndex: 1,
        explanation: 'The retrospective is about PROCESS improvement — how the team works together. It is separate from Sprint Review (product demo) and Sprint Planning (plan the next sprint).',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'During Daily Standup a developer explains a complex technical problem in detail — it has been running 25 minutes. What should the Scrum Master do?',
        options: [
          'Let it continue — technical discussions are valuable',
          'Interrupt: "Let\'s note this as a blocker and discuss after standup. Who needs to be involved?" Then continue',
          'End the standup immediately',
          'Tell the developer to summarise in one sentence'
        ],
        correctIndex: 1,
        explanation: 'Standups are 15-minute synchronisations. Detailed technical discussions are "parked" and scheduled separately with relevant people after standup. The Scrum Master facilitates this without dismissing the issue.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'The team\'s Definition of Done is "code is written and manually tested by the developer." What is the problem?',
        options: [
          'Nothing — this is a complete DoD',
          'Too narrow. A professional DoD includes: automated tests, peer code review, CI passing, deployed to staging, documentation updated',
          'DoDs should not mention testing',
          'Only the Scrum Master defines the DoD'
        ],
        correctIndex: 1,
        explanation: 'A weak DoD allows low-quality code into the codebase. A strong DoD with automated tests, peer review, CI, and staging deployment creates a quality gate preventing technical debt accumulation sprint by sprint.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Sprint Simulation',
      goal: 'Simulate a complete Scrum sprint from planning through retrospective for a small feature set.',
      steps: [
        'Start with the backlog from the Agile course, select stories for ~20-25 story points, write a Sprint Goal',
        'Create Sprint Backlog: break each story into tasks (3+ tasks per story)',
        'Write 3 days of Daily Standup notes simulating updates and one blocker being resolved',
        'Simulate Sprint Review: what was completed, what was not, 2 pieces of stakeholder feedback',
        'Run Start/Stop/Continue retrospective with 2 action items assigned to specific people',
        'Document the full sprint lifecycle in one clean document',
      ],
      expectedOutput: 'Sprint Goal: "Users can register, login, and browse catalog"\nSprint Backlog: 22pts — Registration(3), Login(2), Catalog(8), Search(5), Cart(4)\nDay 3 blocker: Auth library conflict → resolved\nReview: 18/22pts done. Catalog search UI needs redesign.\nRetro actions: START automated tests (Alice) | STOP long PR discussions (whole team)',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sep_l9_testing_fundamentals',
    topicTitle: 'Testing Fundamentals',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 205,
    emoji: '🧪',
    intro: 'Testing is not something QA does after developers finish. In professional engineering, testing is a first-class concern woven into every stage of development. Engineers who write tests ship fewer bugs, refactor with confidence, and sleep better at night.',
    concepts: [
      ConceptLesson(
        title: 'The Testing Pyramid',
        definition: 'Three levels: Unit tests (many, fast, cheap), Integration tests (fewer, moderate), End-to-End tests (few, slow, expensive). Base = most unit tests. Top = fewest E2E tests.',
        analogy: 'Building inspection: many small checks (each brick), some combination checks (walls), few full walk-throughs (completed building).',
        example: 'Ideal proportions:\n  E2E:          ~10 tests   (slow, brittle)\n  Integration:  ~100 tests  (moderate)\n  Unit:         ~1000 tests (fast, reliable)\n\nInverted pyramid (anti-pattern):\n  Many E2E, few unit tests\n  → Slow CI, flaky tests, poor coverage signal',
        keyTakeaway: 'An inverted pyramid is technical debt. E2E tests are 100x slower and 10x more brittle than unit tests. Invest heavily in unit tests — they give the most value per developer minute.',
      ),
      ConceptLesson(
        title: 'Test Doubles: Mocks, Stubs, Fakes',
        definition: 'Test doubles replace real dependencies. Stubs return pre-set responses. Mocks verify interactions. Fakes are simplified real implementations.',
        analogy: 'Stunt doubles in films — the real star (database, API) replaced by a controlled substitute for scenes where precise, repeatable behaviour matters.',
        example: 'from unittest.mock import MagicMock\n\n# STUB: returns fixed response\nuser_repo = MagicMock()\nuser_repo.find_by_email.return_value = User(id=1, name="Alice")\n\n# MOCK: verifies the call was made\nmock_email.assert_called_once_with(\n    to="alice@mail.com", subject="Welcome!"\n)\n\n# FAKE: in-memory implementation\nclass FakeUserRepo:\n    def __init__(self): self.users = {}\n    def save(self, u): self.users[u.id] = u',
        keyTakeaway: 'Mocks and stubs let you test in isolation without real databases or APIs. Tests depending on real external services are slow, flaky, and impossible to run offline.',
      ),
      ConceptLesson(
        title: 'Test-Driven Development (TDD)',
        definition: 'TDD: write a failing test FIRST, then minimum code to pass it, then refactor — Red-Green-Refactor cycle repeated continuously.',
        analogy: 'Writing exam questions BEFORE the textbook — you define exactly what correct behaviour looks like, then write only enough content to answer those questions.',
        example: '# RED: write failing test first\ndef test_member_discount():\n    cart = ShoppingCart(is_member=True)\n    cart.add_item(price=1000)\n    assert cart.total() == 900  # FAILS — class doesn\'t exist\n\n# GREEN: minimum code to pass\nclass ShoppingCart:\n    def __init__(self, is_member=False):\n        self.is_member = is_member\n        self.items = []\n    def add_item(self, price): self.items.append(price)\n    def total(self):\n        t = sum(self.items)\n        return t * 0.9 if self.is_member else t\n\n# REFACTOR: clean up while keeping test green',
        keyTakeaway: 'TDD forces you to think about the API before the implementation. Code written with TDD is naturally more testable, has clearer interfaces, and fewer bugs.',
      ),
      ConceptLesson(
        title: 'Coverage and Test Quality',
        definition: 'Code coverage measures % of code executed by tests. High coverage is necessary but not sufficient — tests with trivial assertions give false confidence.',
        analogy: 'A building inspection that verifies every room was entered — but does not check if anything in those rooms works. 100% coverage + zero meaningful assertions = 0 real quality.',
        example: '# 100% coverage but USELESS:\ndef test_calculate_tax():\n    result = calculate_tax(100000, 0.18)\n    assert result is not None  # checks nothing!\n\n# 100% coverage AND useful:\ndef test_calculate_tax():\n    assert calculate_tax(100000, 0.18) == 18000\n    assert calculate_tax(0, 0.18) == 0\n    with pytest.raises(ValueError):\n        calculate_tax(-1000, 0.18)',
        keyTakeaway: 'Aim for 70-80% as a baseline but focus on TEST QUALITY over coverage numbers. Meaningful assertions over coverage percentage.',
      ),
      ConceptLesson(
        title: 'FIRST Principles for Good Tests',
        definition: 'Good tests are FIRST: Fast (milliseconds), Independent (no shared state), Repeatable (same result every run), Self-validating (clear pass/fail), Timely (written close to code).',
        analogy: 'FIRST is like properties of a good referee: fast decisions, consistent regardless of who is playing, accurate every time, gives clear verdicts, available at the right moment.',
        example: '# BAD: slow, depends on real database\ndef test_create_user():\n    db = RealPostgresDB()  # slow!\n    user = UserService(db).create("alice@mail.com")\n\n# GOOD: fast, isolated with fake\ndef test_create_user():\n    fake_db = FakeUserRepository()\n    service = UserService(fake_db)\n    user = service.create("alice@mail.com")\n    assert user.email == "alice@mail.com"',
        keyTakeaway: 'If a test takes more than 100ms it will be skipped by developers under pressure. Fast tests get run constantly. Slow test suites become obstacles teams work around.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'According to the Testing Pyramid, which tests should you have the MOST of?',
        options: [
          'End-to-End tests',
          'Integration tests',
          'Unit tests — fastest, cheapest, most reliable',
          'Manual tests'
        ],
        correctIndex: 2,
        explanation: 'Unit tests form the pyramid base — many (hundreds to thousands), milliseconds to run, and give the most precise information about what broke when they fail.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the TDD Red-Green-Refactor cycle?',
        options: [
          'Write code, test it, deploy it',
          'Write FAILING test first (Red), minimum code to pass (Green), improve quality (Refactor) keeping tests passing',
          'Red = bug, Green = deployed, Refactor = rewrite',
          'Three phases done once per project'
        ],
        correctIndex: 1,
        explanation: 'TDD\'s cycle: Red (failing test defining desired behaviour), Green (simplest code making it pass), Refactor (improve structure without breaking tests).',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Is 95% code coverage sufficient to guarantee high quality?',
        options: [
          'Yes — 95% means 95% of bugs are caught',
          'No — coverage measures execution, not correctness. Tests can execute without meaningful assertions',
          'Yes — 95% is the gold standard',
          'No — only 100% is acceptable'
        ],
        correctIndex: 1,
        explanation: 'Coverage measures which lines ran, not whether they were tested correctly. A test calling a function with no assertions can achieve 100% coverage while missing all logical errors.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'E2E tests take 45 minutes per CI run. Developers start force-pushing to skip CI. What is the root problem and solution?',
        options: [
          'Developers need more discipline',
          'Test suite too slow — move most to unit/integration level, keep only critical paths as E2E, target < 5 min total CI time',
          'CI server needs more hardware',
          'Reduce number of PRs'
        ],
        correctIndex: 1,
        explanation: 'Tests developers avoid do not exist in practice. The solution is making the feedback loop fast enough that running tests is the path of least resistance — not stricter rules.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Which test is BETTER?\nA: assert send_email(user) is not None\nB: assert send_email(user) == True and mock_smtp.send.called_with(user.email, "Welcome!")',
        options: [
          'A — simpler is always better',
          'B — verifies actual return value AND that email was sent to right address with right subject',
          'Both are equivalent quality',
          'A — None checks cover all edge cases'
        ],
        correctIndex: 1,
        explanation: 'Test A only checks the function returned something — almost no information about correctness. Test B verifies both the return value and the interaction. Meaningful assertions make tests valuable.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Test Suite with TDD',
      goal: 'Build a shopping cart module using TDD with unit tests, mocks, and meaningful coverage.',
      steps: [
        'Using TDD (test first!), implement ShoppingCart: add_item(), remove_item(), apply_discount(code), total(), checkout()',
        'Write unit tests for every method: happy path, edge cases (empty cart, invalid), error cases',
        'Use mock/stub for DiscountService — tests must not call the real service',
        'Test checkout() verifies PaymentService is called with correct amount via mock',
        'Measure coverage with pytest-cov and achieve > 80%',
        'Document one complete Red-Green-Refactor cycle in comments',
      ],
      expectedOutput: 'Tests: 18 passing, 0 failing\nCoverage: 87%\nTDD cycle in comments:\n  RED: test_member_discount fails\n  GREEN: added discount logic\n  REFACTOR: extracted _apply_discount() helper\nmock_payment.charge.assert_called_with(amount=900, currency="INR") ✓',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l9_unit_testing',
    topicTitle: 'Unit Testing',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 210,
    emoji: '🔬',
    intro: 'Unit testing is the most practiced and most valued testing skill in software engineering. Google, Meta, and Amazon require engineers to write unit tests as part of standard workflow — not as an afterthought. This course makes you proficient with pytest, Python\'s most powerful testing framework.',
    concepts: [
      ConceptLesson(
        title: 'Unit Testing with pytest',
        definition: 'pytest is Python\'s most popular testing framework. Tests are regular functions starting with test_. pytest auto-discovers them, runs them, and reports failures with detailed, actionable messages.',
        analogy: 'pytest is like a meticulous quality inspector who knows exactly what to look for (test_ functions), runs all checks automatically, and writes a detailed report explaining precisely what failed and why — without you guiding each step.',
        example: '# calculator.py\ndef add(a, b): return a + b\ndef divide(a, b):\n    if b == 0: raise ValueError("Cannot divide by zero")\n    return a / b\n\n# test_calculator.py\nimport pytest\nfrom calculator import add, divide\n\ndef test_add_positive():\n    assert add(3, 5) == 8\n\ndef test_add_negative():\n    assert add(-3, -5) == -8\n\ndef test_divide_by_zero_raises():\n    with pytest.raises(ValueError, match="Cannot divide by zero"):\n        divide(10, 0)',
        keyTakeaway: 'pytest shows the exact assertion that failed, actual value, and expected value. The -v flag shows individual test names. Failures are immediately actionable without digging through logs.',
        codeSnippet: '# Running pytest:\npytest                          # all tests\npytest test_calc.py -v          # verbose output\npytest -k "add"                 # tests matching "add"\npytest --cov=calculator         # with coverage report',
      ),
      ConceptLesson(
        title: 'Fixtures — Shared Test Setup',
        definition: 'Fixtures provide reusable setup and teardown for tests — creating shared resources like fake databases, configured service objects, or test data that multiple tests can use without repeating setup code.',
        analogy: 'A test kitchen that pre-prepares common ingredients before any recipe starts. Each cook (test) starts from the same prepared baseline without repeating the prep work from scratch.',
        example: 'import pytest\nfrom myapp import UserService, FakeUserRepository\n\n@pytest.fixture\ndef user_repo():\n    return FakeUserRepository()  # fresh instance for each test\n\n@pytest.fixture\ndef user_service(user_repo):    # fixtures can compose!\n    return UserService(user_repo)\n\n@pytest.fixture\ndef existing_user(user_service):\n    return user_service.create("alice@mail.com", "password")\n\ndef test_create_user(user_service):\n    user = user_service.create("bob@mail.com", "pass")\n    assert user.email == "bob@mail.com"\n\ndef test_duplicate_email_fails(user_service, existing_user):\n    with pytest.raises(ValueError):\n        user_service.create("alice@mail.com", "other")',
        keyTakeaway: 'Fixtures compose — a fixture can request other fixtures as parameters. Each test gets a fresh fixture instance by default, ensuring test isolation. Use scope="session" for expensive shared setup.',
      ),
      ConceptLesson(
        title: 'Parametrised Tests',
        definition: 'Parametrised tests run the same test logic with multiple input/output combinations — eliminating duplication while covering many scenarios cleanly.',
        analogy: 'Running the same quality check on many products in a factory — same inspection steps, same pass/fail criteria, different products going through. One test definition, many test cases.',
        example: 'import pytest\nfrom myapp import is_valid_email\n\n@pytest.mark.parametrize("email, expected", [\n    ("alice@example.com",  True),\n    ("bob@company.co.in",  True),\n    ("notanemail",         False),\n    ("missing@domain",     False),\n    ("",                   False),\n    ("space @mail.com",    False),\n])\ndef test_email_validation(email, expected):\n    assert is_valid_email(email) == expected\n\n# Runs as 6 separate, individually named tests:\n# test_email_validation[alice@example.com-True]\n# test_email_validation[notanemail-False]',
        keyTakeaway: 'Without parametrisation, 6 email cases need 6 separate functions. With @pytest.mark.parametrize, you write the logic once and declare data. Adding new cases is one new line — not a whole new function.',
      ),
      ConceptLesson(
        title: 'Testing Exceptions and Edge Cases',
        definition: 'Good unit tests explicitly verify that code raises the correct exceptions for invalid input and handles boundary conditions — not just the happy path where everything works.',
        analogy: 'Car safety testing: not just "does it drive forward?" but "does it stop on wet roads?", "protect passengers in a side impact?", "handle a flat tyre?" Edge cases reveal real quality.',
        example: 'import pytest\nfrom myapp import BankAccount, InsufficientFundsError\n\nclass TestWithdrawal:\n    def test_valid_withdrawal(self):\n        acc = BankAccount(balance=1000)\n        acc.withdraw(300)\n        assert acc.balance == 700\n\n    def test_exact_balance_withdrawal(self):\n        acc = BankAccount(balance=500)\n        acc.withdraw(500)\n        assert acc.balance == 0\n\n    def test_overdraft_raises_error(self):\n        acc = BankAccount(balance=100)\n        with pytest.raises(InsufficientFundsError) as exc:\n            acc.withdraw(200)\n        assert "Insufficient" in str(exc.value)\n\n    def test_negative_amount_raises_error(self):\n        acc = BankAccount(balance=1000)\n        with pytest.raises(ValueError, match="must be positive"):\n            acc.withdraw(-50)',
        keyTakeaway: 'For every function that can fail, test: valid input, boundary values (exact balance, zero), and invalid input. The "sad path" tests are where most production bugs hide.',
      ),
      ConceptLesson(
        title: 'Mocking with unittest.mock',
        definition: 'Python\'s unittest.mock replaces real dependencies with controlled test doubles — patch(), MagicMock, and assertion methods let you verify exactly how mocks were called.',
        analogy: 'A film director using a cardboard storefront instead of a real shop — the actors (code under test) interact with it as if it were real, but the director controls exactly what it does and can replay the scene precisely.',
        example: 'from unittest.mock import MagicMock, patch\nfrom myapp import OrderService\n\ndef test_order_sends_confirmation():\n    mock_email = MagicMock()\n    service = OrderService(email_service=mock_email)\n\n    order = service.place_order(user_id=42, items=[1, 2, 3])\n\n    # Verify exact interaction\n    mock_email.send_confirmation.assert_called_once_with(\n        user_id=42,\n        order_id=order.id\n    )\n\n# Patch a module-level dependency:\ndef test_uses_current_time():\n    with patch("myapp.datetime") as mock_dt:\n        mock_dt.now.return_value = "2024-01-15"\n        order = OrderService().place_order(user_id=1, items=[1])\n        assert order.created_at == "2024-01-15"',
        keyTakeaway: 'assert_called_once_with() verifies a mock was called exactly once with specific arguments. call_count tracks total invocations. These give precise control over interaction verification without needing real services.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does a pytest fixture provide?',
        options: [
          'Automatic test generation',
          'Reusable composable setup shared across multiple tests without repeating code',
          'Performance benchmarking for tests',
          'Automatic test discovery only'
        ],
        correctIndex: 1,
        explanation: 'Fixtures provide shared setup and optional teardown — creating test databases, configured services, or sample data. Each test gets a fresh instance by default, ensuring complete isolation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the main benefit of @pytest.mark.parametrize?',
        options: [
          'Makes tests run in parallel',
          'Runs the same test logic with multiple input/output combinations, eliminating duplication across many scenarios',
          'Automatically skips slow tests',
          'Generates test data automatically from types'
        ],
        correctIndex: 1,
        explanation: 'Parametrisation declares many test cases as data (input/expected pairs) and runs the same logic against all of them — replacing 10 near-identical functions with one function and a data list.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does mock.assert_called_once_with(arg1, arg2) verify?',
        options: [
          'The mock was created with those arguments',
          'The mock was called exactly once and that call used exactly arg1 and arg2 as arguments',
          'The mock will only accept those arguments in future calls',
          'The mock\'s return value equals arg1 and arg2'
        ],
        correctIndex: 1,
        explanation: 'assert_called_once_with() combines two assertions: the mock was invoked exactly once, and that invocation used exactly the specified arguments. Fails if called zero times, more than once, or with different arguments.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You have 15 near-identical test functions testing the same validation with different inputs. What refactoring makes this cleaner?',
        options: [
          'Delete 14 tests and keep only the most complex one',
          'Use @pytest.mark.parametrize — define logic once, list all 15 input/expected pairs as data',
          'Combine all 15 into one long test function',
          'Move them to a separate slow-tests file'
        ],
        correctIndex: 1,
        explanation: 'Parametrisation eliminates code duplication while keeping all 15 test cases. Adding a new case means one new line in the parameter list — not writing a whole new test function.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: '200 tests each create a real DB connection and take 0.5s. Total: 100 seconds CI time. What is the correct fix?',
        options: [
          'Buy faster hardware',
          'Replace real DB with a FakeRepository or in-memory SQLite — unit tests should not use real databases',
          'Run tests in parallel only',
          'Reduce to 50 tests'
        ],
        correctIndex: 1,
        explanation: 'Unit tests should use fakes or in-memory databases. With a FakeRepository each test runs in microseconds. 200 unit tests should complete in under 1 second total, not 100.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Comprehensive Unit Test Suite',
      goal: 'Write a professional unit test suite for a user management system using pytest, fixtures, parametrisation, and mocks.',
      steps: [
        'Build UserService with: register(email, password), login(email, password), update_profile(user_id, data), delete(user_id)',
        'Create fixtures: fake_repo (FakeUserRepository), user_service (UserService with fake_repo), registered_user (pre-created)',
        'Write parametrised tests for email validation: 6 valid and 4 invalid formats minimum',
        'Write tests for all 4 service methods — happy path, validation errors, not-found (3+ tests per method)',
        'Use MagicMock to verify register() calls the notification service exactly once with the correct email',
        'Run pytest --cov=user_service and achieve > 85% coverage',
      ],
      expectedOutput: '=================== test session starts ===================\nCollected 28 items\ntest_user_service.py::test_register_valid PASSED\ntest_user_service.py::test_email[alice@mail.com-True] PASSED\n...\n28 passed in 0.34s\n\nCoverage: 89% ✓\nmock_notify.send_welcome.assert_called_once_with("alice@mail.com") ✓',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l9_integration_testing',
    topicTitle: 'Integration Testing',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 205,
    emoji: '🔗',
    intro: 'Unit tests verify individual components work in isolation. Integration tests verify they work TOGETHER — that authentication middleware correctly calls the user service, the service correctly queries the database, and the response is correctly formatted. These tests catch the entire class of bugs that unit tests miss entirely.',
    concepts: [
      ConceptLesson(
        title: 'What Integration Tests Catch',
        definition: 'Integration tests verify the interaction between two or more real components — testing that database queries work correctly, middleware chains function properly, and service A correctly uses service B.',
        analogy: 'Unit tests check each instrument in an orchestra plays correctly alone. Integration tests check they play together in tune — violin, cello, and piano must coordinate as a group, not just play individually.',
        example: 'Bugs only caught by integration tests:\n\n1. ORM misconfiguration:\n   Unit: mock returns correct data\n   Integration: real query returns wrong columns\n\n2. Middleware ordering error:\n   Unit: auth middleware works in isolation\n   Integration: auth runs AFTER route handler — bug!\n\n3. Database constraint violation:\n   Unit: service logic is correct\n   Integration: UNIQUE constraint prevents insert — bug!\n\n4. Serialisation mismatch:\n   Unit: model data looks right\n   Integration: response has wrong field names',
        keyTakeaway: 'The classic integration bug: unit tests for auth pass, unit tests for user service pass, but connected together the token is verified AFTER user data is fetched — only visible when the two are integrated.',
      ),
      ConceptLesson(
        title: 'Testing REST APIs with TestClient',
        definition: 'API integration tests use a test client to make actual HTTP requests, verifying that endpoints return correct status codes, headers, and response bodies for various scenarios.',
        analogy: 'Sending real orders to a restaurant and checking: right dish (body), right container (content-type), right bill amount (status code), correct presentation (no extra fields).',
        example: 'from fastapi.testclient import TestClient\nfrom myapp import app\n\nclient = TestClient(app)\n\ndef test_register_returns_201():\n    response = client.post("/api/users", json={\n        "email": "alice@mail.com",\n        "password": "SecurePass123"\n    })\n    assert response.status_code == 201\n    data = response.json()\n    assert data["email"] == "alice@mail.com"\n    assert "password" not in data  # never expose password!\n    assert "id" in data\n\ndef test_wrong_password_returns_401():\n    response = client.post("/api/auth/login", json={\n        "email": "alice@mail.com",\n        "password": "WrongPassword"\n    })\n    assert response.status_code == 401\n    assert "token" not in response.json()',
        keyTakeaway: 'Always verify the FULL response: status code, absence of sensitive fields, Content-Type header, and data structure. Many API bugs are caught by "is the password field absent from the response?"',
      ),
      ConceptLesson(
        title: 'Database Integration Testing',
        definition: 'Database integration tests use a real but isolated database to verify that queries, constraints, transactions, and migrations work correctly — typically in-memory SQLite or a containerised test database.',
        analogy: 'A dress rehearsal with real props — you discover the lighting rig blocks the actor\'s movements, something a props-free rehearsal never would have revealed.',
        example: 'import pytest, sqlite3\nfrom myapp.database import UserRepository\n\n@pytest.fixture\ndef test_db():\n    conn = sqlite3.connect(":memory:")  # isolated, fast\n    conn.execute("""CREATE TABLE users (\n        id INTEGER PRIMARY KEY,\n        email TEXT UNIQUE NOT NULL,\n        password_hash TEXT NOT NULL\n    )""")\n    yield conn\n    conn.close()  # auto cleanup\n\n@pytest.fixture\ndef user_repo(test_db):\n    return UserRepository(test_db)\n\ndef test_save_and_retrieve(user_repo):\n    user_repo.save("alice@mail.com", "hash123")\n    found = user_repo.find_by_email("alice@mail.com")\n    assert found.email == "alice@mail.com"\n\ndef test_unique_constraint_enforced(user_repo):\n    user_repo.save("alice@mail.com", "hash1")\n    with pytest.raises(Exception):  # UNIQUE violation\n        user_repo.save("alice@mail.com", "hash2")',
        keyTakeaway: 'In-memory SQLite is an excellent integration test database — fast, isolated per test, zero external dependencies. For PostgreSQL-specific features, use Docker-based test databases with testcontainers.',
      ),
      ConceptLesson(
        title: 'Contract Testing Between Services',
        definition: 'Contract testing verifies that a service\'s API matches exactly what its consumers expect — critical in microservices where producer and consumer services are developed by different teams independently.',
        analogy: 'A building code inspection verifying water pipes (provider) connect at exactly the right points that plumbing fixtures (consumer) expect — independent of whether either party knows the other\'s full design.',
        example: '# Consumer-driven contract testing (Pact framework):\n\n# Consumer (frontend) defines what it expects:\n# "GET /users/42 must return:\n#  { id: 42, name: \'Alice\', email: \'alice@mail.com\' }"\n\n# Provider (user service) runs this contract against\n# its real implementation to verify compliance.\n\n# If Provider renames "name" to "full_name":\n# → Contract test FAILS in CI before reaching production\n# → Consumer never breaks in production\n\n# Result: breaking API changes caught early,\n# not discovered at 2am in production.',
        keyTakeaway: 'Contract testing is essential for microservices — it catches breaking API changes before they reach production without requiring both services to be deployed together for integration tests.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What do integration tests verify that unit tests typically miss?',
        options: [
          'Individual function logic',
          'Correct interaction between components — database queries, middleware chains, serialisation working together as a real system',
          'Code formatting and style',
          'Performance under load'
        ],
        correctIndex: 1,
        explanation: 'Unit tests use mocks to test components in isolation. Integration tests wire real components together, revealing bugs in connections: wrong query columns, middleware ordering issues, schema mismatches.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'When testing a REST API endpoint, what should you verify beyond just the status code?',
        options: [
          'Nothing — status code is sufficient',
          'Response body structure, absence of sensitive fields like passwords, Content-Type header, and correct data values',
          'Only the response time',
          'Only that the response body is not empty'
        ],
        correctIndex: 1,
        explanation: 'Many API bugs live in the response body, not the status code. Checking that passwords are absent, IDs are present, and field names match the contract catches real security and API contract bugs.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is in-memory SQLite ideal for integration testing?',
        options: [
          'It is identical to PostgreSQL in all cases',
          'Fast (no disk I/O), automatically isolated per test, zero external service dependencies required',
          'It supports all PostgreSQL-specific features',
          'It is the recommended production database'
        ],
        correctIndex: 1,
        explanation: 'In-memory SQLite creates a fresh database in milliseconds, has zero external dependencies, and is automatically destroyed when the connection closes — perfect test isolation without any setup overhead.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Unit tests for AuthMiddleware pass. Unit tests for UserController pass. Integration test of both together fails with 401. What likely went wrong?',
        options: [
          'Both unit test suites have bugs',
          'The components interact differently than expected — middleware ordering, token extraction from wrong header, or user ID type mismatch between them',
          'The integration test environment is misconfigured',
          'Integration tests always fail on the first run'
        ],
        correctIndex: 1,
        explanation: 'This is the classic integration bug: each component works alone but the handoff between them breaks. Middleware might extract user ID as string while controller expects integer, or read from a different header key.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'An integration test creates real data in the PRODUCTION database during CI. What is wrong and how do you fix it?',
        options: [
          'Nothing — integration tests need real data',
          'Tests must never touch production. Use a separate isolated test database with automatic cleanup to keep production data safe and tests deterministic',
          'Only read operations are safe in production',
          'Just use a different connection string'
        ],
        correctIndex: 1,
        explanation: 'Tests writing to production can corrupt real data, violate privacy regulations (fake user records mixed with real ones), and make production state non-deterministic. Always use isolated test environments.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'API Integration Test Suite',
      goal: 'Build a complete integration test suite for a REST API covering database operations, authentication flow, and error handling.',
      steps: [
        'Set up a FastAPI or Flask app with SQLite and a user management API (register, login, get profile)',
        'Create a pytest fixture that builds a fresh in-memory database with schema before each test',
        'Write integration tests for registration: POST /register → 201, user in DB, password is hashed not stored plain',
        'Write integration tests for login: valid credentials → 200 with JWT token, wrong password → 401',
        'Write integration tests for authenticated endpoint: valid JWT → 200 with user data, no JWT → 401',
        'Write a test verifying duplicate email registration returns 409 Conflict with a descriptive error message',
      ],
      expectedOutput: '======= Integration Test Suite =======\ntest_register_creates_user_in_db PASSED\ntest_register_hashes_password PASSED\ntest_register_duplicate_returns_409 PASSED\ntest_login_valid_returns_token PASSED\ntest_login_wrong_password_returns_401 PASSED\ntest_profile_with_valid_jwt PASSED\ntest_profile_no_jwt_returns_401 PASSED\n\n7 passed in 1.23s (all use in-memory test DB) ✓',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l9_clean_code',
    topicTitle: 'Clean Code',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 210,
    emoji: '✨',
    intro: 'Code is read far more often than it is written — by teammates, future maintainers, code reviewers, and your future self at 2am debugging a production incident. Writing code that is immediately understandable without needing a tour guide is a professional skill that genuinely sets senior engineers apart.',
    concepts: [
      ConceptLesson(
        title: 'Meaningful Names',
        definition: 'Names for variables, functions, and classes should clearly communicate their purpose — eliminating the need for comments to explain what they are or do.',
        analogy: 'Naming in code is like labelling drawers in a shared kitchen. "Drawer" tells you nothing. "Wooden Spoons and Spatulas" tells you everything instantly. The best code reads like well-written prose.',
        example: '# BAD: cryptic abbreviations reveal nothing\nd = 86400\nfor i in lst:\n    if x.chk(i): p.do(i)\n\n# GOOD: names explain intent without comments\nSECONDS_PER_DAY = 86400\nfor order in pending_orders:\n    if validator.is_eligible(order):\n        payment_processor.charge(order)\n\n# BAD function: meaningless name, opaque params\ndef calc(a, b, c):\n    return a * b * c\n\n# GOOD function: self-documenting\ndef calculate_order_total(price, quantity, tax_rate):\n    return price * quantity * (1 + tax_rate)',
        keyTakeaway: 'If you need a comment to explain what a variable does, its name is wrong. Rename first — often the comment becomes unnecessary entirely.',
      ),
      ConceptLesson(
        title: 'Functions: Small and Single Purpose',
        definition: 'Functions should do ONE thing, do it well, and do it only. A function longer than 20-30 lines usually does more than one thing and should be split up.',
        analogy: 'A toaster toasts bread. It does not also brew coffee, play music, and file taxes. The moment your function needs the word "and" to describe what it does, it is doing too much.',
        example: '# BAD: one function doing everything\ndef process_order(order):\n    if not order.items: raise ValueError("Empty")\n    subtotal = sum(i.price for i in order.items)\n    tax = subtotal * 0.18\n    db.orders.insert(order)\n    email.send(order.customer, f"Confirmed: {subtotal+tax}")\n    return subtotal + tax\n\n# GOOD: each function has exactly one responsibility\ndef validate_order(order):\n    if not order.items: raise ValueError("Empty order")\n\ndef calculate_total(order, tax_rate=0.18):\n    return sum(i.price for i in order.items) * (1 + tax_rate)\n\ndef save_order(order):\n    return db.orders.insert(order)\n\ndef notify_customer(order, total):\n    email.send(order.customer, f"Order confirmed: {total}")',
        keyTakeaway: 'Breaking one large function into four small ones removes complexity — it does not add it. Each small function is independently understandable, testable, and reusable.',
      ),
      ConceptLesson(
        title: 'DRY — Don\'t Repeat Yourself',
        definition: 'Every piece of logic should have a single, authoritative representation. Duplication causes maintenance bugs — fixing in one copy while forgetting the others.',
        analogy: 'Speed limit signs on roads rather than painted on every metre of asphalt. One authoritative sign covers an entire stretch. Update one sign and the rule changes everywhere instantly.',
        example: '# VIOLATION: same discount logic copied in 3 files\n# checkout.py:  if customer.is_member: total *= 0.9\n# cart.py:      if user.member: price *= 0.9\n# admin.py:     if order.customer.is_member: amount *= 0.9\n\n# FIX: one authoritative function\ndef apply_member_discount(amount, customer):\n    MEMBER_DISCOUNT = 0.10\n    if customer.is_member:\n        return amount * (1 - MEMBER_DISCOUNT)\n    return amount\n\n# Discount changes from 10% to 15%?\n# Update ONE place — all three callers benefit.',
        keyTakeaway: 'DRY violations compound over time. Code copied 3 times means 3 places to update, 3 places for the bug to reappear, and 3 places to confuse the next developer.',
      ),
      ConceptLesson(
        title: 'Comments: When and When Not To',
        definition: 'Comments should explain WHY — intent, reasoning, trade-offs that cannot be expressed in code. They should NOT explain WHAT, which is the code\'s own job through clear naming.',
        analogy: 'A comment explaining WHAT the code does is like captioning every photo with "this is a picture." Useful comments explain WHY the photo is there — context the image itself cannot convey.',
        example: '# BAD — explains the obvious (noise):\nx = x + 1            # increment x by 1\nif user.age >= 18:   # check if user is 18 or older\n\n# GOOD — explains WHY, not what:\n# Using bcrypt 12 rounds — OWASP minimum for production security.\n# Lower rounds are faster but vulnerable to brute-force at scale.\nhashed = bcrypt.hashpw(password, bcrypt.gensalt(12))\n\n# Skip validation for admins — trusted internal accounts.\n# Validation adds 50ms per request. See security ADR-007.\nif not user.is_admin:\n    validate_input(request.body)',
        keyTakeaway: 'The urge to write a WHAT comment is a signal to improve the code instead. If the code truly cannot be made self-explanatory, THEN write a WHY comment explaining the non-obvious reasoning.',
      ),
      ConceptLesson(
        title: 'Consistent Formatting',
        definition: 'Consistent formatting — indentation, line length, naming conventions — reduces cognitive load by making code predictable. Use automated formatters like Black to eliminate all style debates.',
        analogy: 'Typography in a published book — inconsistent fonts and random capitalisation make content harder to read even if the words are correct. Consistent style lets readers focus on meaning, not form.',
        example: '# Inconsistent (brain wastes effort noticing inconsistencies):\ndef calculateTotal(items,taxRate = 0.18 ):\n    t=0\n    for Item in items:\n        t +=Item.price\n    return t*(1+taxRate)\n\n# Black-formatted (zero cognitive overhead for formatting):\ndef calculate_total(items, tax_rate=0.18):\n    subtotal = sum(item.price for item in items)\n    return subtotal * (1 + tax_rate)\n\n# Enforce in CI with pyproject.toml:\n# [tool.black]\n# line-length = 88\n# target-version = ["py311"]',
        keyTakeaway: 'Style debates waste engineering time. Adopt an automated formatter and enforce it in CI. The specific style matters far less than applying it consistently across the entire codebase.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'When is a code comment MOST valuable?',
        options: [
          'When explaining what a line of code does',
          'When explaining WHY a non-obvious decision was made or what trade-off was accepted',
          'The more comments the better for documentation',
          'Comments should never be used'
        ],
        correctIndex: 1,
        explanation: 'Good code explains WHAT through clear naming. Comments add value by explaining WHY — business reasoning, security decisions, performance trade-offs, and constraints that code alone cannot convey.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the main cost of duplicated code (DRY violation)?',
        options: [
          'It makes files physically larger',
          'Every bug fix and change must be applied in multiple places — some copies get missed, creating inconsistency bugs',
          'Duplicated code runs slower',
          'It only matters in large codebases'
        ],
        correctIndex: 1,
        explanation: 'Duplication means every change requires finding and updating all copies. Some are inevitably missed — creating bugs where one copy has the fix and another still has the old, broken behaviour.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the ideal function length according to clean code principles?',
        options: [
          'As long as needed to complete all related tasks',
          'Short enough to do ONE thing well — typically 10-25 lines fitting on one screen',
          'Exactly 100 lines maximum',
          'No specific guidance exists'
        ],
        correctIndex: 1,
        explanation: 'A function that can be described without the word "and" is probably the right size. Beyond ~30 lines, most functions are doing multiple things and should be decomposed into smaller, focused functions.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'def calc(x, y, z):\n    return x * y + z * 0.18\n\nThis has multiple clean code issues. Which is most impactful to fix first?',
        options: [
          'The function is too long',
          'Naming: rename to calculate_price_with_tax(price, quantity, tax_rate) and replace 0.18 with named constant TAX_RATE',
          'Add a comment explaining what x, y, z mean',
          'Break it into two separate functions'
        ],
        correctIndex: 1,
        explanation: 'Poor naming is the root problem. Once renamed to calculate_price_with_tax(price, quantity, tax_rate), the formula becomes self-documenting. 0.18 becomes TAX_RATE. The comment becomes unnecessary.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'The same email validation logic appears in 4 files. A bug is found — it accepts emails without a domain. How many places need fixing and what is the real solution?',
        options: [
          'Fix 1 place — they share code already',
          'Fix all 4 (likely miss at least one), then immediately extract into single validate_email() in shared utilities — one authoritative source forever',
          'Fix only the most critical file',
          'Delete 3 copies and keep 1'
        ],
        correctIndex: 1,
        explanation: 'All 4 must be fixed (finding all 4 in a large codebase is harder than it sounds). The real fix is extracting to one authoritative function — future fixes propagate automatically everywhere it is used.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Clean Code Refactoring Workshop',
      goal: 'Systematically refactor a messy codebase into clean code, documenting each improvement made.',
      steps: [
        'Start with a 200-line messy function: poor names, deep nesting, duplicated logic, magic numbers, misleading WHAT comments',
        'Step 1 — Rename: give all variables, functions, and classes self-documenting names',
        'Step 2 — Extract: break the 200-line function into functions of 10-25 lines each with one clear purpose',
        'Step 3 — DRY: identify all duplicated logic and extract each into a single reusable function',
        'Step 4 — Comments: remove all WHAT comments, keep only meaningful WHY comments where genuinely needed',
        'Step 5 — Verify: run all existing tests to confirm behaviour is completely unchanged after refactoring',
      ],
      expectedOutput: 'BEFORE:\n  One function: process_everything() — 200 lines\n  Variables: d, x, t, f, arr1, temp\n  15 WHAT comments\n  Duplicate discount logic: 3 copies\n\nAFTER:\n  9 focused functions, average 18 lines each\n  All variables self-documenting\n  3 meaningful WHY comments only\n  1 authoritative discount function\n  All 28 unit tests: still passing ✓',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l9_refactoring',
    topicTitle: 'Refactoring',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 205,
    emoji: '🔧',
    intro: 'Refactoring is the disciplined technique of restructuring existing code without changing its external behaviour. It is the engineering equivalent of remodelling a room while the family still lives in it. Every professional engineer refactors continuously — it is not a special project, it is everyday craft.',
    concepts: [
      ConceptLesson(
        title: 'What is Refactoring?',
        definition: 'Refactoring changes the INTERNAL structure of code while preserving its EXTERNAL behaviour — making code easier to understand and modify without adding features or fixing bugs.',
        analogy: 'Reorganising a filing cabinet — the same documents exist, all are still accessible, but now organised so anyone (including you next month) can find anything instantly. Nothing was added or removed.',
        example: 'BEFORE (works but completely opaque):\ndef d(n):\n    r = 0\n    for i in range(n+1):\n        r = r + i\n    return r\n\nAFTER (same behaviour, instantly understandable):\ndef sum_of_numbers_up_to(n):\n    return sum(range(n + 1))\n\n# SAME OUTPUT:\n# d(10) == sum_of_numbers_up_to(10) == 55\n# Tests confirm: external behaviour unchanged',
        keyTakeaway: 'Refactoring requires a test suite to be safe. Without tests you cannot confirm behaviour is preserved — you are guessing. "Refactoring without tests" is just "changing code and hoping for the best."',
      ),
      ConceptLesson(
        title: 'Code Smells — Signs Refactoring Is Needed',
        definition: 'Code smells are surface indicators of deeper design problems: Long Method, Large Class, Duplicate Code, Magic Numbers, Long Parameter List, Feature Envy, Shotgun Surgery.',
        analogy: 'A musty smell hints at mould; a flickering light hints at wiring problems. Smells do not mean catastrophe is immediate, but they signal something worth investigating before it gets worse.',
        example: 'Common code smells:\n\n1. Long Method:        function > 30 lines doing multiple things\n2. Large Class:        class with 20+ methods, too many responsibilities\n3. Duplicate Code:     same logic copied to 3+ places\n4. Magic Numbers:      price * 0.18 — what is 0.18? why?\n5. Long Parameter List: func(a, b, c, d, e, f, g)\n6. Shotgun Surgery:    one change forces edits in 10 different files\n7. Feature Envy:       method uses another class\'s data more than its own\n8. WHAT Comments:      signal that the code itself is not clear enough',
        keyTakeaway: 'Code smells are not bugs — the code works. They signal the code will become harder to change over time. Address them continuously (minutes per PR) rather than letting them accumulate into technical debt.',
      ),
      ConceptLesson(
        title: 'Core Refactoring Techniques',
        definition: 'Common refactoring moves: Extract Function, Rename, Replace Magic Number with Named Constant, Replace Conditional with Lookup, Extract Class, Replace Conditional with Polymorphism.',
        analogy: 'Standard renovation moves — "move the bookcase", "add a wall" — each is a specific, well-defined change that can be applied safely one step at a time.',
        example: '# TECHNIQUE: Replace Magic Number with Named Constant\nBEFORE: if cart.total > 999: shipping = 0\nAFTER:\n  FREE_SHIPPING_THRESHOLD = 999\n  if cart.total > FREE_SHIPPING_THRESHOLD: shipping = 0\n\n# TECHNIQUE: Replace Conditional with Lookup\nBEFORE:\n  def day_name(x):\n      if x == 1: return "Mon"\n      if x == 2: return "Tue"\n      ... # 5 more ifs\n\nAFTER:\n  DAY_NAMES = {1:"Mon", 2:"Tue", 3:"Wed",\n               4:"Thu", 5:"Fri", 6:"Sat", 7:"Sun"}\n  def day_name(x):\n      return DAY_NAMES.get(x, "Unknown")',
        keyTakeaway: 'Always apply one technique at a time — each step must leave the code working and tests passing. Multiple small safe steps consistently beat one large risky leap.',
      ),
      ConceptLesson(
        title: 'The Boy Scout Rule',
        definition: 'Leave the code a little cleaner than you found it. Every time you touch a file, make one small improvement — a better name, a removed duplicate, a clearer structure. Incremental improvement prevents debt accumulation.',
        analogy: 'Cleaning a little when you use a shared kitchen — wipe the counter, put away one dish. Not a full spring clean every time, but a small act of respect for the next person who uses it.',
        example: 'PR workflow with Boy Scout Rule:\nYou add a new payment method feature.\nOn the way, you notice:\n  • Poorly named variable → rename it (30 seconds)\n  • Duplicated validation → extract function (2 minutes)\n  • Magic number → named constant (30 seconds)\n\nFix them in the SAME PR but a SEPARATE commit:\n  Commit 1: "Add cryptocurrency payment method"\n  Commit 2: "Refactor: clarify payment module naming"\n\nThe second commit keeps the review clean and\nmakes the improvement traceable in history.',
        keyTakeaway: 'Technical debt accumulates gradually because nobody applies the Boy Scout Rule. Teams that consistently leave code a little better maintain codebases that are a pleasure to work in years later.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does refactoring change and what does it NOT change?',
        options: [
          'Changes external behaviour; does not change internal structure',
          'Changes internal structure to improve design; does NOT change external behaviour — tests must still pass',
          'Changes both structure and behaviour simultaneously',
          'Only renames variables and functions'
        ],
        correctIndex: 1,
        explanation: 'The defining characteristic of refactoring is preserved external behaviour. If tests passed before, they must pass after every step. Changing what the code DOES while restructuring is redesigning, not refactoring.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is an existing test suite essential BEFORE starting to refactor?',
        options: [
          'Tests make refactoring faster to write',
          'Without tests you cannot confirm behaviour is preserved — you might change what the code does without noticing',
          'Tests are required by refactoring tools',
          'Tests are only needed after refactoring is complete'
        ],
        correctIndex: 1,
        explanation: 'Tests are the safety net confirming "behaviour preserved" after each step. A failing test immediately pinpoints what changed. Without tests, bugs silently slip through even well-intentioned refactoring.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the Boy Scout Rule in software engineering?',
        options: [
          'Always write tests before writing code',
          'Leave the code a little cleaner than you found it — make small improvements every time you touch a file',
          'Always fully document every function you write',
          'Only senior developers are allowed to refactor production code'
        ],
        correctIndex: 1,
        explanation: 'Incremental continuous improvement. Small improvements with every PR prevent technical debt from accumulating, without requiring expensive "refactoring sprints" where nothing new gets built.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'def get_day(x):\n    if x==1: return "Mon"\n    if x==2: return "Tue"\n    # ... 5 more ifs\n    if x==7: return "Sun"\n\nWhich refactoring technique fits best here?',
        options: [
          'Extract into 7 separate single-day functions',
          'Replace Conditional with Lookup: DAY_NAMES = {1:"Mon",...}; return DAY_NAMES.get(x, "Unknown")',
          'Add more elif branches for clarity',
          'Just replace the magic numbers'
        ],
        correctIndex: 1,
        explanation: 'A chain of if/elif statements returning different values for different inputs is best replaced with a dictionary lookup. Shorter, no branching, and adding a new day means one new dictionary entry.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You need to add a feature to a file and notice a function "do_stuff" doing 5 unrelated things. You are under time pressure. What should you do?',
        options: [
          'Add your feature directly to do_stuff — it already handles everything else',
          'Spend 10 minutes extracting do_stuff into named sub-functions (separate commit), then add your feature cleanly — Boy Scout Rule',
          'Skip your feature until the function is fully refactored',
          'Rewrite the entire file from scratch before touching it'
        ],
        correctIndex: 1,
        explanation: 'Boy Scout Rule: improve a little, not everything. Extracting one messy function into named sub-functions takes 10 minutes, makes YOUR feature addition easier, and leaves the code better. A separate commit keeps the PR review clean.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Code Smell Detective and Refactoring',
      goal: 'Identify code smells in a provided codebase and systematically apply refactoring techniques with test verification at each step.',
      steps: [
        'Audit a provided messy codebase and list every smell found: Long Method, Duplicate Code, Magic Numbers, Feature Envy, Long Parameter List',
        'Prioritise the 5 most impactful smells by the damage they cause to readability and future maintainability',
        'Before any refactoring: run the full test suite and record which tests pass',
        'Apply one refactoring technique at a time — commit after each technique and verify tests still pass before continuing',
        'Document each refactoring: smell identified, technique applied, before/after code snippet',
        'After all refactoring: compare lines of code and cyclomatic complexity before vs after',
      ],
      expectedOutput: 'Smells found: 8 total\n  Long Method x2, Magic Numbers x5, Duplicate Logic x3, Feature Envy x1\n\nRefactoring Log (each verified with tests):\n1. Replace Magic Numbers → Named Constants (6) ✓\n2. Extract validate_input() from process() ✓\n3. DRY: extract calculate_discount() ✓\n4. Rename: f() → format_date() ✓\n\nBefore: 1 function (180 lines), 7 magic numbers\nAfter:  8 functions (avg 15 lines), 0 magic numbers\nAll 24 tests: still passing ✓',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l9_software_architecture',
    topicTitle: 'Software Architecture Basics',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 38,
    totalXp: 240,
    emoji: '🏛️',
    intro: 'Software architecture defines how a system is structured, what patterns it uses, and how components interact. These decisions are hard to reverse and shape everything that follows. Understanding architectural patterns — monolith, layered, event-driven — is what distinguishes a developer from an architect.',
    concepts: [
      ConceptLesson(
        title: 'What is Software Architecture?',
        definition: 'Software architecture defines the high-level structure of a system — how major components are organised, how they communicate, and the fundamental principles they follow. These decisions are very costly to change once established.',
        analogy: 'City planning — individual buildings (classes, functions) can be modified or replaced fairly easily, but the road network and zoning laws (architecture) shape everything and are extremely expensive to change once built.',
        example: 'Architectural decisions and their long-term consequences:\n\n"Monolith vs Microservices"\n  → Wrong choice costs months or years to reverse\n\n"Synchronous vs Event-driven communication"\n  → Determines how failures propagate across the system\n\n"SQL vs NoSQL database"\n  → Determines query flexibility, consistency guarantees\n  → Changing after years of production data is catastrophic',
        keyTakeaway: 'Architecture decisions are disproportionately important because they are so expensive to reverse. A wrong variable name costs 5 minutes to fix. A wrong architectural pattern costs months. Invest more time upfront in architecture.',
      ),
      ConceptLesson(
        title: 'Monolithic Architecture',
        definition: 'A monolith is a single deployable unit where all application components — UI, business logic, data access — are packaged and deployed together as one process.',
        analogy: 'A full-service department store — everything under one roof, one management team, one set of systems. Efficient for small to medium scale, but scaling means expanding the entire building rather than just one department.',
        example: 'Monolith structure:\nmyapp/\n  ├── controllers/   (HTTP handlers)\n  ├── services/       (business logic)\n  ├── models/         (data models)\n  └── repositories/   (database access)\n\n→ ONE deployable process on ONE server\n→ ONE shared database\n→ Scale: deploy more identical copies of the entire app\n\nAdvantages: simple to develop, test, deploy, and debug\nDisadvantages: any change requires redeploying everything',
        keyTakeaway: 'Start with a monolith. Instagram, Shopify, and Stack Overflow all ran as monoliths at millions of users. Only migrate to microservices when you have a specific, demonstrated problem a monolith genuinely cannot solve.',
      ),
      ConceptLesson(
        title: 'Layered Architecture',
        definition: 'Layered architecture organises code into horizontal layers — Presentation, Business Logic, Data Access — where each layer only communicates with the layer directly below it.',
        analogy: 'A restaurant: customers interact with waiters (Presentation), who relay requests to the kitchen (Business Logic), which retrieves ingredients from storage (Data Access). No customer ever goes directly into the kitchen or storage.',
        example: 'Presentation Layer (Controllers/APIs):\n  → Handle HTTP requests, validate input, call Services\n  → Know nothing about databases\n\nBusiness Logic Layer (Services):\n  → Business rules, calculations, orchestration\n  → Independent of HTTP and independent of database\n\nData Access Layer (Repositories):\n  → SQL queries, ORM usage, return domain objects\n  → Know nothing about HTTP\n\nDatabase (Infrastructure):\n  → PostgreSQL, MongoDB, Redis\n\nGOLDEN RULE: each layer only imports from the DIRECT layer below',
        keyTakeaway: 'The key benefit: swap the database (change Repository implementation) without touching Business Logic. Add a GraphQL API (new Presentation layer) without changing any business rules. Layers enable safe, independent change.',
      ),
      ConceptLesson(
        title: 'Event-Driven Architecture',
        definition: 'Event-driven architecture uses events (messages representing "something happened") published to a message bus, with multiple independent subscribers reacting — achieving loose coupling and resilience.',
        analogy: 'A city public announcement system. An event ("fire on 5th street") is broadcast once. The fire department, police, hospital, and media each hear it and react completely independently without any coordination from the broadcaster.',
        example: 'Order placement event flow:\n\nOrderService publishes event: "order_placed"\n  payload: {order_id: 123, customer_id: 42, total: 5000}\n\nEach subscriber reacts independently:\n  InventoryService  → deducts stock\n  EmailService      → sends confirmation email\n  AnalyticsService  → records the sale\n  LoyaltyService    → awards loyalty points\n\nAdding SMS notifications next month?\n  → Create SMSService that subscribes to "order_placed"\n  → ZERO changes to OrderService or any other subscriber\n\nPopular tools: RabbitMQ, Apache Kafka, AWS SQS/SNS',
        keyTakeaway: 'Event-driven makes adding new functionality trivially easy — subscribe a new service to existing events. Failures in one subscriber (SMS service down) do not affect others (email still sends perfectly).',
      ),
      ConceptLesson(
        title: 'Architectural Trade-offs',
        definition: 'Every architectural choice involves explicit trade-offs: simplicity vs flexibility, consistency vs availability, monolith vs microservices. Understanding these trade-offs — not blindly following trends — is what separates architects from developers.',
        analogy: 'Engineering trade-offs in product design — a thinner phone has worse battery life and is more fragile. There is no perfect phone. There is no perfect architecture. The question is always "which trade-off is right for THIS specific context?"',
        example: 'When Monolith wins:\n  • Team of 3-10 engineers\n  • Early-stage startup validating product-market fit\n  • Need fast initial development velocity\n  • Simple deployment pipeline required\n\nWhen Microservices win:\n  • 50+ engineers across 5+ autonomous teams\n  • Different services need different scaling strategies\n  • Teams need full deployment autonomy from each other\n  • Different services genuinely need different tech stacks\n\nNetflix → microservices ✓ (thousands of engineers)\nShopify, Basecamp → monolith ✓ (deliberate choice)\nBoth made the RIGHT choice for their specific context.',
        keyTakeaway: 'Architecture is not about copying what the biggest companies use — it is about what is right for your scale, team size, and problem. A 3-person startup using microservices spends most of its time on infrastructure, not product.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the recommended starting architecture for most new software projects?',
        options: [
          'Microservices — for maximum future scalability',
          'Monolith — simple to build, test, and deploy; migrate only when specific demonstrated problems require it',
          'Event-driven architecture from day one',
          'Serverless functions for all endpoints'
        ],
        correctIndex: 1,
        explanation: 'Most successful products started as monoliths (Instagram, Shopify, Stack Overflow). A monolith is simpler to build, test, and deploy. Extract microservices only when you have a specific, demonstrated problem a monolith cannot solve.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the golden rule of layered architecture?',
        options: [
          'All layers communicate directly with each other freely',
          'Each layer only communicates with the layer directly below it — dependencies flow downward only',
          'The database layer can call business logic when needed',
          'All layers must be independently deployed as separate services'
        ],
        correctIndex: 1,
        explanation: 'Directional dependency is what gives layered architecture its benefits — you can replace a layer without affecting the layers above it, because dependencies only flow downward, never upward or sideways.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the main advantage of event-driven architecture for adding new features?',
        options: [
          'It automatically makes all services faster',
          'New subscribers can react to existing events without modifying the event publisher or any other existing subscriber',
          'Events are automatically encrypted end-to-end',
          'It eliminates the need for databases entirely'
        ],
        correctIndex: 1,
        explanation: 'Adding LoyaltyService or SMSService that react to "order_placed" requires zero changes to OrderService or EmailService — perfect extension without modification, the Open/Closed Principle at architectural scale.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A 3-person startup proposes starting with 12 microservices "to be ready to scale later." What is the correct advice?',
        options: [
          'Agree — microservices are modern best practice for all teams',
          'Start with a well-structured monolith. 3 engineers cannot effectively maintain 12 services\' infrastructure. Extract services only when specific bottlenecks demand it',
          'Compromise at 6 microservices',
          'Use serverless functions instead'
        ],
        correctIndex: 1,
        explanation: 'Microservices for a 3-person team means most time goes to infrastructure (service discovery, distributed tracing, inter-service auth) instead of building the product. A modular monolith gives the same code organisation with 10% of the operational complexity.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'In a layered architecture, the Controller directly queries the database instead of calling the Service layer. What specific problems does this create?',
        options: [
          'No problem — direct queries are actually faster',
          'Tight coupling: business logic leaks into the controller, controller cannot be unit tested without a real database, and swapping the database requires modifying controllers',
          'Only performance is slightly affected',
          'This is actually the recommended pattern for simple apps'
        ],
        correctIndex: 1,
        explanation: 'Bypassing layers eliminates all the benefits of layered architecture. Business logic in controllers is untestable without HTTP. Database changes break controllers. One class becomes responsible for two separate concerns.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Architecture Decision Document',
      goal: 'Design the architecture for a real system, document every decision made, and explicitly justify each trade-off accepted.',
      steps: [
        'Choose a system: ride-sharing backend, e-learning platform, or hospital management system',
        'Write the architectural context: team size, expected scale (daily users, peak requests/second), and top 3 non-functional requirements with measurable targets',
        'Design a layered architecture: draw the layers, name the key components in each layer, and define what belongs where',
        'Identify 2 features that benefit from event-driven architecture and design the complete event flow for each',
        'Write a formal Architecture Decision Record (ADR) for the most important decision: options considered, decision made, and trade-offs explicitly accepted',
        'Identify 3 architectural risks and document a specific mitigation strategy for each',
      ],
      expectedOutput: 'System: E-Learning Platform\nContext: 5 engineers, 50k students, 500 concurrent peak\n\nArchitecture: Layered Monolith\n  Presentation: REST API (FastAPI)\n  Services: CourseService, EnrolmentService, ProgressService\n  Repositories: CourseRepo, UserRepo\n  Database: PostgreSQL + Redis cache\n\nEvent flows:\n  "course_completed" → issue_certificate + send_email + update_leaderboard\n\nADR-001: Monolith over microservices\n  Options: monolith, microservices, modular monolith\n  Decision: monolith\n  Trade-offs: vertical scaling only; acceptable at current team size\n\n3 risks with mitigations documented ✓',
      xpReward: 60,
    ),
  ),
];