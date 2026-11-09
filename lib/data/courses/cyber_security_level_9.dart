// ══════════════════════════════════════════════════════════════════════
// lib/data/courses/cyber_security_level_9.dart
// Cyber Security Engineer Path — LEVEL 9: Advanced Security Practices &
// Real-World Projects (10 lessons)
// ══════════════════════════════════════════════════════════════════════
import '../../models/course_content_data.dart';

const List<TopicCourse> cyberSecurityLevel9 = [
  // ────────────────────────────────────────────────────────────────────
  // LESSON 1
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l9_advanced_threat_modelling',
    topicTitle: 'Advanced Threat Modelling & Security Design Reviews',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 38,
    totalXp: 215,
    emoji: '🧩',
    intro:
        'At the start of this path you learned STRIDE. Real projects need more: structured methods, attack trees, privacy threats, and the ability to review a design and tell a team clearly what to change before it is built. This lesson makes you the person a development team wants in the room at design time.',
    concepts: [
      ConceptLesson(
        title: 'From STRIDE to Risk-Centric Methods (PASTA)',
        definition:
            'PASTA, the Process for Attack Simulation and Threat Analysis, is a seven-stage, risk-centric method that starts from business objectives and works down to technical threats and countermeasures, so that security effort follows business impact.',
        analogy:
            'STRIDE is a checklist of ways a door can be forced. PASTA starts by asking which rooms hold the valuables, who would want them, and how they would get there, and only then looks at doors.',
        example:
            'PASTA stages:\n\n1. Define business objectives and compliance needs\n2. Define the technical scope\n3. Decompose the application (data flows, trust boundaries)\n4. Analyse threats (who attacks and how, using threat intelligence)\n5. Analyse vulnerabilities and weaknesses\n6. Model attacks and attack paths\n7. Analyse risk and define countermeasures\n\nChoosing a method:\n  STRIDE: quick, design-level, per element\n  PASTA: deeper, risk and business driven\n  LINDDUN: privacy threats\n  Attack trees: visualise attacker goals',
        keyTakeaway:
            'Pick the lightest method that answers the question. A quick STRIDE session often beats a heavy process nobody finishes.',
      ),
      ConceptLesson(
        title: 'Attack Trees and Abuse Cases',
        definition:
            'An attack tree places an attacker goal at the root and breaks it into the different ways it could be achieved. Abuse cases describe how a feature could be misused, written next to the normal use cases.',
        analogy:
            'To protect a vault you list every way someone could open it: crack the lock, bribe a guard, steal the keys, or tunnel in. Each branch shows where a defence is needed.',
        example:
            'Goal: read another customer invoice\n\n  Branch A: guess or change the invoice ID (needs object-level checks)\n  Branch B: steal a valid session (needs cookie flags, MFA, short sessions)\n  Branch C: exploit a flaw in the PDF export (needs input handling and patching)\n  Branch D: trick a support agent (needs identity verification process)\n\nAbuse case examples:\n  A user repeatedly requests password resets to spam another user\n  A user applies a discount code in many parallel requests\n\nFor each leaf, record the cost to the attacker, the likelihood, and your countermeasure.',
        keyTakeaway:
            'Trees reveal that one control rarely covers every path. Look for the cheapest branch for the attacker, and defend that first.',
      ),
      ConceptLesson(
        title: 'Privacy Threats with LINDDUN',
        definition:
            'LINDDUN is a threat modelling method for privacy. Its categories are Linking, Identifying, Non-repudiation, Detecting, Data disclosure, Unawareness, and Non-compliance.',
        analogy:
            'STRIDE protects the building. LINDDUN protects the visitors, asking whether anyone can track them, identify them, or learn things about them they did not agree to share.',
        example:
            'Examples:\n\nLinking: combining a fitness app data with another dataset to profile a user\nIdentifying: re-identifying people from supposedly anonymous records\nDetecting: learning that someone uses a sensitive service from traffic patterns\nData disclosure: excessive collection or sharing\nUnawareness: users not knowing what is collected\nNon-compliance: breaking consent or retention rules\n\nMitigations:\n  Data minimisation, pseudonymisation, aggregation\n  Clear notices and consent\n  Retention limits\n  Access controls and encryption',
        keyTakeaway:
            'Treat privacy as a design requirement. Asking what data is truly needed is the cheapest control there is.',
      ),
      ConceptLesson(
        title: 'Running a Security Design Review',
        definition:
            'A design review is a structured meeting or document review in which a security engineer examines an architecture before it is built, identifies risks, and agrees actions with the team.',
        analogy:
            'It is a building plan review with the fire officer: problems found on paper cost a rubber stamp, and the same problems found after construction cost walls.',
        example:
            'Review steps:\n\n1. Read the design document and ask for a data flow diagram\n2. Identify assets, data classes, and trust boundaries\n3. Walk each flow with STRIDE questions\n4. Check authentication, authorisation, secrets, encryption, logging, and third-party dependencies\n5. Rate each finding by risk and effort\n6. Agree owners and dates\n7. Record the outcome and re-review after major changes\n\nPrinciples for the conversation:\n  Be specific and constructive\n  Offer options, not only objections\n  Respect delivery deadlines and propose phased fixes',
        keyTakeaway:
            'Great reviewers help teams ship securely. Offering two safe options is more effective than saying no.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What distinguishes PASTA from a quick STRIDE session?',
        options: [
          'PASTA starts with business objectives and is risk-centric, working down to technical threats',
          'PASTA is only about passwords',
          'PASTA is faster than STRIDE',
          'PASTA ignores attackers'
        ],
        correctIndex: 0,
        explanation:
            'PASTA ties threats to business impact through seven stages, while STRIDE is a lighter design-level checklist.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'In an attack tree, what sits at the root?',
        options: [
          'The firewall',
          'The attacker goal',
          'The cheapest control',
          'The patch list'
        ],
        correctIndex: 1,
        explanation:
            'The root is the attacker objective, and the branches are the different ways to reach it.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the cheapest privacy control available at design time?',
        options: [
          'Collecting more data in case it is useful',
          'Data minimisation: not collecting data you do not need',
          'Adding more logs',
          'Longer retention'
        ],
        correctIndex: 1,
        explanation:
            'Data you never collect cannot be leaked, misused, or demanded in a legal process.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A team presents a design where the mobile app calls the database directly with an embedded credential. What is the best review comment?',
        options: [
          'Looks fine',
          'Introduce an API layer with user authentication and authorisation, remove embedded credentials, and apply least privilege to the data access',
          'Make the credential longer',
          'Hide the app in the store'
        ],
        correctIndex: 1,
        explanation:
            'Credentials embedded in a client can be extracted. A server-side API with per-user authorisation is the safer design.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A release is in three days and the review finds a high-risk issue that needs a 2-week redesign. Which response is most useful?',
        options: [
          'Block the release with no options',
          'Propose a phased plan: a quick compensating control now, with a dated commitment to the full fix, and let the business owner accept the residual risk in writing',
          'Ignore the finding',
          'Approve silently'
        ],
        correctIndex: 1,
        explanation:
            'Offering interim mitigations and explicit risk ownership respects delivery while keeping risk visible.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Design Review Pack for a Real-World Style App',
      goal:
          'Review a fictional design and produce an attack tree, a STRIDE and LINDDUN analysis, and a review report.',
      steps: [
        'Scenario: a telemedicine app with patient login, video consultations, prescriptions, and payments',
        'Draw a data flow diagram with trust boundaries and classify the data',
        'Create an attack tree for the goal: read another patient prescription',
        'Run STRIDE on 5 elements and LINDDUN on 3 data flows',
        'Rank the top 10 risks and propose a countermeasure and owner for each',
        'Write a 2-page design review report with a clear summary, findings, and a phased plan',
      ],
      expectedOutput:
          'Design Review: TeleCare\n\nDFD: mobile app -> API gateway -> services -> DB; video provider and payment gateway as third parties\n\nAttack tree (read others prescriptions): 5 branches; cheapest = object ID tampering -> object-level authorisation test\n\nSTRIDE: 14 threats | LINDDUN: 6 privacy threats\nTop risks: IDOR on prescriptions, weak session handling, over-collection of health data...\n\nReport: summary, 10 findings with owners and dates, phased plan ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 2
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l9_pentest_methodology',
    topicTitle:
        'Penetration Testing Methodology, Scoping & Professional Reporting',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 38,
    totalXp: 215,
    emoji: '🧭',
    intro:
        'A penetration test is a controlled, authorised attempt to break into a system to show how a real attacker could succeed. The value is not in the hacking, it is in the method, the discipline, and a report that makes the client safer. This lesson covers the professional process end to end, without turning into an attack manual.',
    concepts: [
      ConceptLesson(
        title: 'Types of Engagements and Standard Methodologies',
        definition:
            'Penetration tests vary by target and by how much the tester knows in advance. Established methodologies give a consistent, defensible structure.',
        analogy:
            'A building security test could be done by someone given the floor plans (white box), a staff badge only (grey box), or nothing at all (black box). Each reveals different weaknesses.',
        example:
            'Engagement types:\n\nExternal network, internal network, web application, API, mobile, wireless, cloud, social engineering (only with explicit authorisation), physical (separate legal arrangements)\n\nKnowledge levels:\n  Black box, grey box, white box\n\nMethodologies and references:\n  PTES (Penetration Testing Execution Standard)\n  OWASP Web Security Testing Guide (WSTG)\n  NIST SP 800-115\n  OSSTMM\n  MITRE ATT&CK for adversary-informed testing\n\nPTES phases: pre-engagement, intelligence gathering, threat modelling, vulnerability analysis, exploitation, post-exploitation, reporting',
        keyTakeaway:
            'Follow a recognised methodology and record which one you used. It makes the work repeatable and defensible.',
      ),
      ConceptLesson(
        title: 'Pre-Engagement: Scope, Contracts, and Rules',
        definition:
            'Before any testing, the parties agree in writing on scope, objectives, methods, timing, communication, data handling, and legal protections. This stage protects the client, the testers, and third parties.',
        analogy:
            'A surgeon signs consent forms, confirms the procedure, and agrees emergency steps before the first cut. Testing needs the same clarity.',
        example:
            'Documents and decisions:\n\nStatement of work: objectives and deliverables\nRules of Engagement: in-scope and out-of-scope systems, allowed techniques, testing windows, stop conditions, emergency contacts\nAuthorisation letter signed by someone with legal authority, including permission from third-party hosts where needed\nNon-disclosure agreement and data handling rules\nLiability and insurance terms\nCommunication plan: status updates and immediate notification of critical findings\n\nKey rule: if the scope or authorisation is unclear, stop and ask.',
        keyTakeaway:
            'Every action must be traceable to written scope. Testing outside scope is a legal problem, not just a professional one.',
      ),
      ConceptLesson(
        title: 'Test Execution Principles and Safety',
        definition:
            'Execution is careful and documented. The tester proves risk with the minimum necessary impact, avoids harming availability or data, and keeps full records.',
        analogy:
            'A crash-test engineer causes controlled collisions, measures everything, and does not set fire to the factory.',
        example:
            'Principles:\n\nStart with low-impact techniques and escalate only as needed and permitted\nAvoid denial of service and data destruction unless explicitly authorised\nPrefer proof by minimal evidence (a harmless marker file or a screenshot) over taking real data\nLog every action with timestamps and source addresses to help the client correlate activity\nTell the client immediately about critical issues, such as an already compromised system or exposed sensitive data\nClean up test accounts, files, and tools\nProtect client data in transit and at rest and delete it as agreed\n\nPractise only on your own lab machines and legal practice platforms.',
        keyTakeaway:
            'The best testers cause no harm. Careful scoping, minimal proof, and good records distinguish professionals from attackers.',
      ),
      ConceptLesson(
        title: 'Writing a Report That Drives Fixes',
        definition:
            'The report is the real deliverable. It must be clear to executives and precise for engineers, with evidence, risk ratings, and practical remediation steps.',
        analogy:
            'A doctor lab result is only useful with a diagnosis and a treatment plan. A list of numbers helps nobody.',
        example:
            'Report structure:\n\nExecutive summary: scope, headline risks, overall posture, top recommendations\nMethodology and limitations: what was and was not tested\nRisk rating approach: CVSS plus business context\nFindings, each with: title, severity, affected assets, description, impact, evidence, reproduction steps (safe), remediation, references\nPositive observations: what is working well\nAppendices: tool versions, scope details, raw data\n\nAfter delivery:\n  Debrief meeting\n  Remediation support\n  Retest and a short retest report',
        keyTakeaway:
            'A retest that shows issues are fixed is the most valuable follow-up. Offer it in every engagement.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the most important document to obtain before starting a penetration test?',
        options: [
          'A tool license',
          'Written authorisation and agreed scope and rules of engagement',
          'A logo for the report',
          'A list of passwords'
        ],
        correctIndex: 1,
        explanation:
            'Authorisation and clear scope are the legal and professional foundation of any test.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'During testing you discover signs that the client system is already compromised by a real attacker. What should you do?',
        options: [
          'Continue silently and report at the end',
          'Stop and notify the client immediately through the agreed emergency channel',
          'Delete the evidence',
          'Publish it online'
        ],
        correctIndex: 1,
        explanation:
            'A real intrusion needs immediate attention. The communication plan should cover urgent notification.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why offer a retest after delivering the report?',
        options: [
          'To charge more only',
          'To verify that fixes work and demonstrate real risk reduction',
          'It is required by law',
          'To collect more data'
        ],
        correctIndex: 1,
        explanation:
            'Verification closes the loop and gives the client evidence that the risk was reduced.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A client scope lists 10.1.1.0/24. While testing you notice the web app calls an API on a third-party SaaS domain that appears weak. What should you do?',
        options: [
          'Test the third-party API too',
          'Stay in scope, note the observation, and tell the client so they can raise it with the vendor or arrange authorisation',
          'Report it publicly',
          'Ignore everything'
        ],
        correctIndex: 1,
        explanation:
            'Third-party systems need their own authorisation. Report the observation and let the client decide.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You can prove a serious flaw by reading one harmless test file. A colleague suggests downloading the entire customer table as proof. Which is correct?',
        options: [
          'Download the table, it is stronger proof',
          'Use the minimal proof, avoid touching real customer data, and document precisely what you did',
          'Download and share it by email',
          'Delete the table'
        ],
        correctIndex: 1,
        explanation:
            'Minimal proof limits harm and privacy exposure while still demonstrating the issue.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Engagement Pack for a Lab Penetration Test',
      goal:
          'Prepare the full documentation and a report for an authorised test of your own lab environment.',
      steps: [
        'Choose a lab target you own (for example Metasploitable or Juice Shop in your isolated network) and write a statement of work',
        'Write Rules of Engagement and an authorisation letter signed by you as the system owner',
        'Create a test plan following PTES phases and list which tools you will use for each',
        'Perform authorised testing on the lab target using the methods and tools from Levels 5 and 6, logging every action with timestamps',
        'Write a professional report with an executive summary, 6 findings, risk ratings, evidence, and remediation advice',
        'Fix at least 3 findings, perform a retest, and write a one-page retest report',
      ],
      expectedOutput:
          'Pentest Pack (lab)\n\nSoW + RoE + authorisation letter ✓\nPlan: PTES phases with tools per phase\nTest log: 62 timestamped actions\n\nReport: 6 findings (1 critical, 2 high, 3 medium) with evidence and fixes\nRetest: 3 fixed, 3 open, summary written ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 3
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l9_red_blue_purple',
    topicTitle: 'Red, Blue & Purple Team Operations',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 36,
    totalXp: 210,
    emoji: '🎭',
    intro:
        'Security improves fastest when attackers and defenders learn from each other. Red teams emulate real adversaries, blue teams defend, and purple teaming joins them in a shared loop. This lesson explains how these exercises are organised, what they achieve, and how they are run safely.',
    concepts: [
      ConceptLesson(
        title: 'Roles: Red, Blue, Purple, and White',
        definition:
            'The red team emulates attackers to test an organisation detection and response. The blue team defends. The purple team is a collaborative approach where both share knowledge, and the white team oversees the exercise and its rules.',
        analogy:
            'Think of a sports scrimmage: one side attacks, the other defends, a referee keeps it safe, and the coaches sit together afterwards to review the video.',
        example:
            'Roles:\n\nRed team: plans and carries out realistic adversary emulation within agreed rules\nBlue team: monitoring, detection, response, and hardening\nPurple team: a method or function that makes red and blue work together, test by test\nWhite team (control group): sets rules, approves actions, deconflicts, and can stop the exercise\n\nDifference from a penetration test:\n  Penetration test: broad coverage, find as many weaknesses as possible\n  Red team: goal-based, stealthier, tests people, process, and detection, often without most defenders knowing',
        keyTakeaway:
            'The goal is not to win. It is to measure and improve the organisation ability to detect and respond.',
      ),
      ConceptLesson(
        title: 'Adversary Emulation with ATT&CK',
        definition:
            'Adversary emulation reproduces the known behaviour of a real threat actor, based on threat intelligence and ATT&CK, to test whether defences catch the techniques that matter most to the organisation.',
        analogy:
            'A fire service drill that copies the way a real recent fire spread, instead of a random scenario.',
        example:
            'Emulation workflow:\n\n1. Choose a relevant threat actor or scenario from intelligence\n2. Extract the techniques they use and order them as an attack path\n3. Plan safe, controlled versions of each step\n4. Agree objectives (for example, reach a test file server without detection)\n5. Execute with tracking of every action and time\n6. Compare against detections and responses\n7. Report gaps and fix them\n\nResources:\n  MITRE ATT&CK and Center for Threat-Informed Defense emulation plans\n  Atomic Red Team for small technique tests in labs\n  Caldera for automated emulation in lab environments',
        keyTakeaway:
            'Emulate what is relevant to you. A realistic, prioritised plan is better than a long list of random techniques.',
      ),
      ConceptLesson(
        title: 'Running a Purple Team Exercise',
        definition:
            'In a purple team exercise, the technique is performed, the defenders check what they saw, and together they improve detections on the spot. It is a rapid, shared learning loop.',
        analogy:
            'A coach calls a play, the team runs it, and everyone checks the replay and adjusts before the next one.',
        example:
            'Loop for each technique:\n\n1. Red announces or performs a technique (safe version)\n2. Blue searches for evidence in logs, EDR, and network data\n3. Result is recorded: detected, partly detected, logged only, or missed\n4. If missed: find out why (no data, bad rule, wrong threshold)\n5. Build or tune a detection\n6. Repeat the test to confirm it now fires\n\nTracking:\n  A spreadsheet or ATT&CK Navigator layer with outcomes\n  Time to detect and time to respond\n  List of improvements with owners',
        keyTakeaway:
            'The most valuable output is a list of detections that now exist and are proven to work.',
      ),
      ConceptLesson(
        title: 'Safety, Deconfliction, and Rules for Exercises',
        definition:
            'Even in authorised exercises, risks exist: disrupting production, triggering real incident responses, or confusing real attacks with the exercise. Good rules and deconfliction prevent this.',
        analogy:
            'A military exercise uses clear markers so that no one confuses the drill with a real emergency.',
        example:
            'Safety controls:\n\nWritten rules of engagement and approved technique lists\nNo destructive actions, no real data theft, and no actions against third parties\nA white team and a trusted agent who can pause the exercise\nA deconfliction process: if the SOC finds activity, it can ask the white team whether it belongs to the exercise\nTesting windows and rollback plans\nClear escalation if a real attack is found during the exercise\nPost-exercise clean-up and a joint debrief\n\nEthics: people are not punished for being tricked in an exercise, since the goal is to improve the system.',
        keyTakeaway:
            'Deconfliction keeps real incidents from being mistaken for drills, and drills from becoming real incidents.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main purpose of a purple team exercise?',
        options: [
          'To prove the red team is better',
          'To join attackers and defenders in a shared loop that produces tested, improved detections',
          'To avoid reporting',
          'To replace the SOC'
        ],
        correctIndex: 1,
        explanation:
            'Purple teaming focuses on rapid joint learning and measurable detection improvement.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the white team do?',
        options: [
          'Attacks the network',
          'Oversees the exercise, sets rules, approves actions, and can stop it',
          'Writes malware',
          'Sells tools'
        ],
        correctIndex: 1,
        explanation:
            'The white team keeps the exercise safe, controlled, and aligned with its objectives.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is deconfliction important?',
        options: [
          'It speeds up networks',
          'It helps tell exercise activity apart from a real attack, avoiding wrong responses',
          'It removes logs',
          'It is optional decoration'
        ],
        correctIndex: 1,
        explanation:
            'Without deconfliction, a SOC might escalate a drill as an incident or dismiss a real attack as a drill.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'During a red team exercise the SOC sees activity that does not match any planned technique. What should happen?',
        options: [
          'Assume it is the red team',
          'Use the deconfliction process to ask the white team, and treat it as a real incident if it does not belong to the exercise',
          'Ignore it',
          'Delete the logs'
        ],
        correctIndex: 1,
        explanation:
            'Unexplained activity during an exercise may be a real attacker. Deconfliction and caution are essential.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A purple team test of credential access shows the technique was logged but produced no alert. What is the best result of the exercise?',
        options: [
          'Mark it as covered',
          'Create or tune a detection, retest to confirm it alerts, and record the improvement',
          'Remove the logs',
          'Stop testing'
        ],
        correctIndex: 1,
        explanation:
            'Logged is not detected. Turning evidence into an alert and proving it works is the aim.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Purple Team Lab Exercise Report',
      goal:
          'Plan and run a small purple team exercise in your isolated SOC lab from Level 7 and report the improvements.',
      steps: [
        'Pick a realistic scenario from public threat intelligence and list 8 ATT&CK techniques in order',
        'Write exercise rules, roles (you can play several), and a deconfliction note',
        'For each technique, run a safe lab version (for example Atomic Red Team tests in your own lab) and record the result: detected, partly detected, logged only, or missed',
        'For each miss, investigate the cause and build or tune a detection, then retest',
        'Update an ATT&CK Navigator layer showing before and after coverage',
        'Write a report with timings, gaps found, fixes made, and next steps',
      ],
      expectedOutput:
          'Purple Team Report (lab)\n\nScenario: phishing-led intrusion with persistence and credential access\nTechniques tested: 8 | first pass: 3 detected, 2 logged only, 3 missed\nFixes: 4 detections built or tuned | retest: 8/8 detected\n\nNavigator layers before/after ✓\nTime to detect improved from 22 min to 3 min (lab) ✓\nNext steps: add cloud audit log tests ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 4
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l9_digital_forensics',
    topicTitle: 'Digital Forensics & Incident Investigation in Depth',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 42,
    totalXp: 225,
    emoji: '🕵️',
    intro:
        'Forensics answers the questions every incident leaves behind: what happened, how, when, and who or what was affected. Careful, methodical investigation turns scattered traces on disks, in memory, and in logs into a reliable story that can support decisions, regulators, and sometimes courts.',
    concepts: [
      ConceptLesson(
        title: 'Forensic Principles and Evidence Handling',
        definition:
            'Forensic work follows strict principles: preserve original evidence, work on verified copies, document every step, and maintain a chain of custody. These rules protect the integrity and credibility of findings.',
        analogy:
            'A crime scene investigator photographs, bags, labels, and logs everything, and never works on the original evidence directly.',
        example:
            'Process:\n\n1. Identify and secure the sources (computers, phones, cloud accounts, logs)\n2. Collect in order of volatility: memory and network state, then disk, then logs and external data\n3. Create forensic images using write-blocking and record SHA-256 hashes\n4. Verify the hash of every copy\n5. Analyse only copies\n6. Document with time (UTC), tools and versions, and each action taken\n7. Report findings with limitations\n\nLegal context: rules on admissibility of electronic evidence vary by country. In India the rules for electronic records were restructured when the Bharatiya Sakshya Adhiniyam, 2023 replaced the Indian Evidence Act, so confirm requirements with legal counsel.',
        keyTakeaway:
            'Hash at the start, hash at the end, and keep notes of everything in between. A verified hash proves the copy matches the original.',
      ),
      ConceptLesson(
        title: 'Windows and Linux Artefacts',
        definition:
            'Operating systems leave traces of user and program activity in many places. Knowing where to look lets investigators reconstruct what happened even if the attacker deleted obvious files.',
        analogy:
            'Even a careful visitor leaves footprints, fingerprints, and receipts in many places. The skill lies in knowing where each kind of trace lies.',
        example:
            'Windows artefacts (examples):\n\nEvent logs: logons, process creation, service installs, PowerShell\nPrefetch and Amcache: evidence that programs ran\nRegistry hives: persistence entries, USB history, recent files\nBrowser history and downloads\nJump lists and shortcut files: recent file access\nScheduled tasks and services\n\nLinux artefacts:\n  auth.log or secure, syslog, journal\n  Shell history files (can be edited or disabled)\n  Cron and systemd units\n  SSH authorized_keys and known_hosts\n  Package manager logs, recently modified files in system directories\n\nCloud and SaaS: audit logs, sign-in logs, mailbox rules',
        keyTakeaway:
            'No single artefact tells the whole story. Corroborate across several sources to build a confident timeline.',
      ),
      ConceptLesson(
        title: 'Memory Forensics and Timelines',
        definition:
            'Memory analysis examines a snapshot of a running system for processes, network connections, and injected code that may not exist on disk. Timeline analysis merges events from many sources into one ordered story.',
        analogy:
            'Memory is the whiteboard in a room during the meeting, wiped when the lights go out. A timeline is the minute-by-minute diary of everything that happened, compiled from every note taken.',
        example:
            'Memory analysis tasks (with tools such as Volatility 3):\n\nList processes and their parent-child relationships\nFind network connections at capture time\nSpot processes with unusual paths or hidden attributes\nExtract command lines and loaded modules\n\nTimeline tools:\n  Plaso (log2timeline) to merge file system, log, and artefact times\n  Timesketch to explore timelines collaboratively\n\nTips:\n  Normalise to UTC\n  Mark confirmed facts separately from hypotheses\n  Look for clusters of activity and gaps',
        keyTakeaway:
            'Memory shows what is running right now, and timelines show what happened over time. Capture memory early, because it vanishes on shutdown.',
      ),
      ConceptLesson(
        title: 'Tools, Triage, and Forensic Reporting',
        definition:
            'Responders often start with fast triage collection before deep forensics. A good report separates facts, analysis, and conclusions, and states limitations honestly.',
        analogy:
            'An emergency doctor first stabilises the patient and gathers key readings, and the detailed investigation follows later.',
        example:
            'Tools (use in authorised environments only):\n\nTriage collection: KAPE, Velociraptor\nImaging: FTK Imager, dd or dc3dd with hashing\nDisk analysis: Autopsy and The Sleuth Kit\nMemory: Volatility 3\nLogs and timelines: Plaso, Timesketch, SIEM searches\n\nReport contents:\n  Scope and questions asked\n  Evidence list with hashes and chain of custody\n  Methods and tool versions\n  Findings with supporting artefacts\n  Timeline of key events\n  Conclusions and confidence level\n  Limitations and recommendations',
        keyTakeaway:
            'State what you know, what you infer, and what you cannot determine. Honest limits make a report credible.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why do investigators analyse forensic copies and not the original evidence?',
        options: [
          'Copies are faster',
          'It preserves the original unchanged so the findings stay trustworthy and repeatable',
          'Originals cannot be read',
          'Copies are encrypted'
        ],
        correctIndex: 1,
        explanation:
            'Working on verified copies prevents accidental alteration of the original evidence.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which data should be collected FIRST when a live compromised system is found?',
        options: [
          'The printer logs',
          'Volatile data such as memory and active network connections',
          'Old backups',
          'Wallpaper settings'
        ],
        correctIndex: 1,
        explanation:
            'Volatile data is lost on shutdown, so it is captured before slower-changing data like disks.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the purpose of recording a SHA-256 hash of a forensic image?',
        options: [
          'To encrypt it',
          'To prove later that the copy has not changed',
          'To compress it',
          'To rename it'
        ],
        correctIndex: 1,
        explanation:
            'Matching hashes show that the evidence copy remains identical to what was collected.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'An attacker cleared the Windows Security log. Which other sources might still show what happened?',
        options: [
          'None',
          'Forwarded logs in the SIEM, Sysmon or EDR telemetry, Prefetch and Amcache, registry artefacts, network logs, and memory',
          'The monitor settings',
          'The keyboard layout'
        ],
        correctIndex: 1,
        explanation:
            'Evidence exists in many places. Central logs and other artefacts often survive local log clearing.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your timeline shows the malicious process started at 02:14 UTC, but the user claims they were not at the computer. Which additional check helps most?',
        options: [
          'Assume the user is lying',
          'Check remote logon events, VPN logs, and session records for activity at that time to see whether the access was remote',
          'Ignore the claim',
          'Delete the log'
        ],
        correctIndex: 1,
        explanation:
            'Corroborating with logon and remote access records tests the claim objectively without assumptions.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Forensic Investigation of a Lab Incident',
      goal:
          'Collect evidence from a lab machine after a simulated incident and write a forensic report.',
      steps: [
        'In your isolated lab, run safe simulated activity on a VM (create a scheduled task, a new user, download a harmless test file, and clear a test log)',
        'Capture a memory image and a disk image of the VM using appropriate tools, hash both, and create a chain of custody form',
        'Analyse the disk image with Autopsy and the memory image with Volatility 3, recording process lists, network connections, and persistence',
        'Build a timeline with Plaso or by merging event logs and file times',
        'Identify each simulated action in the evidence, and note which were easy or hard to find',
        'Write a forensic report with scope, evidence list, methods, findings, timeline, limitations, and recommendations',
      ],
      expectedOutput:
          'Forensic Report (lab)\n\nEvidence: memory.raw (SHA-256 recorded), disk.E01 (hash verified), chain of custody ✓\n\nFindings:\n  02:14 UTC user labtest created (4720 + registry)\n  02:16 scheduled task created (4698)\n  02:19 file downloaded to Downloads (browser history)\n  02:22 Security log cleared (1102)\n\nMemory: suspicious test process with parent cmd.exe; network connection to lab server\nLimitations: no network capture available\nRecommendations: forward logs, enable Sysmon ✓',
      xpReward: 60,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 5
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l9_malware_triage',
    topicTitle: 'Safe Malware Triage & Sandbox Analysis for Defenders',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 36,
    totalXp: 210,
    emoji: '🧫',
    intro:
        'SOC analysts regularly receive suspicious files and need to decide quickly whether they are harmful and what to block. This lesson teaches the defender workflow: handling samples safely, doing low-risk triage, reading sandbox reports, and turning findings into indicators and detections. It deliberately stays at the level of triage and reporting. It does not cover building or modifying malicious code.',
    concepts: [
      ConceptLesson(
        title: 'Safety First: Handling Suspicious Files',
        definition:
            'Suspicious files must be treated as hazardous until proven otherwise. Safe handling means isolating the analysis environment, controlling who can access samples, and following your organisation policy.',
        analogy:
            'A laboratory handling a dangerous specimen uses a sealed cabinet, protective gear, and strict rules about who can touch it and what leaves the room.',
        example:
            'Safety rules:\n\nNever open or run a suspicious file on your normal workstation\nUse an isolated analysis environment or a company-approved sandbox service\nStore samples in a protected location, in a way that prevents accidental execution (for example in an encrypted archive)\nKeep analysis machines off production networks\nUse snapshots so the analysis machine can be restored\nRestrict sample access and keep a log of who handled what\nShare samples only through approved channels and mark them as dangerous\nFollow legal and company policy before uploading any file to an external service\n\nThis course does not provide steps for writing, modifying, or running malware.',
        keyTakeaway:
            'The golden rule: if you do not need to execute it, do not. Many questions can be answered without running a sample at all.',
      ),
      ConceptLesson(
        title: 'Low-Risk Static Triage',
        definition:
            'Static triage examines a file without running it: identifying its type, hash, basic metadata, and reputation. It often answers whether a file is known and how urgent a response is.',
        analogy:
            'Before opening a parcel you check the sender, the weight, the label, and whether others have already reported it as dangerous.',
        example:
            'Safe triage steps:\n\n1. Record file name, size, and the source of the sample (email, download, endpoint)\n2. Calculate hashes (SHA-256) and search reputation databases using the hash only (for example VirusTotal, MalwareBazaar)\n3. Identify the true file type (not only the extension)\n4. Check metadata such as signing status, compile or creation times, and document properties\n5. Check whether security tools already detect it and under what names\n6. Search your own environment for the same hash\n\nTools:\n  Hash utilities, file type identifiers, certificate viewers\n  Existing sandbox and EDR reports\n\nA known-bad hash can be enough to contain and scope without any deeper analysis.',
        keyTakeaway:
            'Searching by hash is safe and fast. It frequently answers the question without opening the file.',
        codeSnippet:
            'import hashlib\n\ndef sha256_file(path):\n    h = hashlib.sha256()\n    with open(path, "rb") as f:\n        for chunk in iter(lambda: f.read(8192), b""):\n            h.update(chunk)\n    return h.hexdigest()\n\nprint(sha256_file("sample.bin"))',
      ),
      ConceptLesson(
        title: 'Reading Sandbox Reports',
        definition:
            'Automated sandboxes run a file in a controlled environment and record what it does: processes, files, registry changes, and network connections. Analysts read the report to understand behaviour and extract indicators.',
        analogy:
            'It is like watching security footage of a suspect in a locked test room instead of letting them roam the building.',
        example:
            'What to look for in a report:\n\nProcess tree: what launched what\nFiles created or modified, especially in startup or temp locations\nRegistry and scheduled task changes (persistence)\nNetwork activity: domains, IPs, ports, user agents\nAttempts to disable security tools or clear logs\nDropped files and their hashes\nMapped ATT&CK techniques\n\nLimits:\n  Malware may detect sandboxes and behave differently\n  A clean report does not prove a file is safe\n  Sandboxes show a single run, so behaviour might vary\n\nService examples: Any.Run, Hybrid Analysis, Joe Sandbox, Cuckoo-based sandboxes (check the sharing and privacy settings before uploading anything).',
        keyTakeaway:
            'Sandbox output is evidence, not a verdict. Treat a clean result with caution and corroborate with other data.',
      ),
      ConceptLesson(
        title: 'From Findings to Indicators, Detections, and Response',
        definition:
            'The point of triage is action: extract indicators of compromise, search for them across the environment, contain affected hosts, and create detections that last longer than a single hash.',
        analogy:
            'Once you know what the intruder looks like and which doors they used, you check every camera for them and fix the doors.',
        example:
            'Output of triage:\n\nIndicators: file hashes, domains, IPs, URLs, mutex or file names, registry keys, scheduled task names\nScoping: search EDR, proxy, DNS, and mail logs for each indicator\nContainment: block domains and hashes, isolate affected hosts, reset exposed credentials\nDetection: write behaviour-based rules (Sigma, YARA only where appropriate) that survive small changes\nReport: what the sample did, where it was seen, actions taken, and recommendations\nShare: with approved intelligence partners using TLP markings\n\nPyramid of Pain reminder: favour behaviour-based detections over lists of hashes.',
        keyTakeaway:
            'A good triage ends with scoping and a lasting detection, not just a verdict on one file.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the safest first step when you receive a suspicious file?',
        options: [
          'Double-click it',
          'Calculate its hash and check reputation by hash, without opening it',
          'Email it to colleagues',
          'Rename it and run it'
        ],
        correctIndex: 1,
        explanation:
            'Hash lookups give useful information with no execution risk.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why can a clean sandbox report still be misleading?',
        options: [
          'Sandboxes are always wrong',
          'Some malware detects sandboxes or needs specific conditions, so it may not show its behaviour in a single run',
          'Reports are always too long',
          'Clean reports are impossible'
        ],
        correctIndex: 1,
        explanation:
            'Evasion and conditional behaviour mean a quiet run is not proof of safety.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should you check company policy before uploading a file to a public analysis service?',
        options: [
          'Uploads are free',
          'Uploaded files may be shared publicly and could contain confidential information',
          'It makes analysis slower',
          'The service deletes them instantly'
        ],
        correctIndex: 1,
        explanation:
            'Public services often share submissions, so sensitive files must not be uploaded without approval.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'The hash of an email attachment matches a known ransomware sample reported by several vendors. What is the best immediate action?',
        options: [
          'Open it to confirm',
          'Contain: search for the hash across endpoints and mail, remove the email from mailboxes, isolate any affected host, and escalate per the playbook',
          'Wait for the weekend',
          'Ignore, it is only a hash'
        ],
        correctIndex: 1,
        explanation:
            'A reliable known-bad match justifies immediate scoping and containment without executing the file.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A sandbox report shows a document creating a scheduled task and contacting a rare domain. Which detections would last longest?',
        options: [
          'Only block the file hash',
          'Behavioural rules for Office applications spawning scripts, new scheduled tasks by unusual parents, and rare-domain connections, in addition to blocking the indicators',
          'Delete the report',
          'Block all documents'
        ],
        correctIndex: 1,
        explanation:
            'Behaviour-based detections remain useful when the attacker changes the file hash or domain.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Suspicious File Triage Casebook (Safe, Using Test Files)',
      goal:
          'Practise the full triage workflow using harmless test files and public, safe resources, and write a triage report.',
      steps: [
        'Use the industry-standard harmless EICAR antivirus test file and a few ordinary files as samples, in an isolated lab VM only',
        'Calculate SHA-256 hashes of each and look them up in a public reputation service using the hash only',
        'Identify true file types and metadata, and note what your endpoint protection says',
        'Read two public sandbox reports for well-known samples published by reputable vendors, and write a summary of the process tree, persistence, and network indicators',
        'Extract indicators from the public reports and write how you would scope them across logs',
        'Write a one-page triage report template and fill it in for one case, including a behavioural detection idea',
      ],
      expectedOutput:
          'Triage Casebook (safe)\n\nSamples: EICAR test file + 2 ordinary files; hashes recorded\nReputation: EICAR flagged by all engines (expected); ordinary files clean\n\nPublic report review: process tree, scheduled task persistence, 3 domains\nScoping plan: search DNS, proxy, EDR for domains and hashes; mail purge\n\nTemplate and filled report ✓\nDetection idea: Office app spawning script interpreter -> alert ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 6
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l9_security_automation_soar',
    topicTitle: 'Security Automation & SOAR in Practice',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 40,
    totalXp: 220,
    emoji: '🤖',
    intro:
        'Security teams cannot hire their way out of alert overload. Automation does the repetitive work, such as enrichment, lookups, and ticket creation, so humans can focus on judgement. Here you combine your Python and API skills with SOAR concepts to build and govern real automation safely.',
    concepts: [
      ConceptLesson(
        title: 'What to Automate and What Not To',
        definition:
            'SOAR, Security Orchestration, Automation, and Response, connects tools and runs playbooks automatically. Good automation targets repetitive, well-understood, low-risk tasks and keeps humans in control of high-impact decisions.',
        analogy:
            'An autopilot handles routine flying so the pilots can focus on decisions, but a pilot still takes over when something unusual happens.',
        example:
            'Good candidates:\n\nEnriching IPs, domains, and hashes from reputation services\nAdding user, asset, and recent alert context to a ticket\nCreating, updating, and routing tickets\nPhishing report processing: extract URLs and attachments, check reputation, find recipients\nDisabling an account or isolating a host after human approval\nSending notifications\n\nPoor candidates for full automation:\n  Actions with high business impact and unclear confidence\n  Novel or ambiguous situations\n  Anything irreversible without approval',
        keyTakeaway:
            'Automate the boring, reversible, high-volume work first. Keep a human in the loop for decisions that can disrupt the business.',
      ),
      ConceptLesson(
        title: 'Playbook Design',
        definition:
            'A playbook is a documented workflow with triggers, steps, decisions, and outcomes. Designing it carefully on paper before building it avoids fragile automation.',
        analogy:
            'A recipe with clear steps, quantities, and checks, before anyone turns on the stove.',
        example:
            'Example: phishing report playbook\n\nTrigger: user reports an email\n1. Extract sender, URLs, attachments, headers\n2. Check URL and hash reputation (hash only; no confidential files uploaded)\n3. Search mail logs for other recipients\n4. If malicious with high confidence: request approval to purge, block sender and URL\n5. Add all details to the ticket and notify the reporter\n6. Log every action with timestamps\n\nDesign elements:\n  Inputs and outputs for each step\n  Error handling and retries\n  Approval gates\n  Metrics: time saved, accuracy',
        keyTakeaway:
            'Write the manual procedure first. Automate only steps you already understand and can verify.',
      ),
      ConceptLesson(
        title: 'Building Automation with Python and Open-Source SOAR',
        definition:
            'You can build useful automation with Python scripts and APIs, or with open-source orchestration tools such as Shuffle, n8n, or TheHive with Cortex. The principles of reliability and safety are the same.',
        analogy:
            'Using Lego bricks to build a machine: each block does one thing well, and connecting them correctly makes something powerful.',
        example:
            'Tools:\n\nPython with requests, schedule, and logging for custom scripts\nShuffle or n8n for visual workflows\nTheHive for cases and Cortex for analysers\nWebhooks from SIEM alerts into the workflow\nChat notifications to a team channel\n\nSimple pattern:\n  Receive alert (webhook) -> enrich -> decide -> notify or ticket -> wait for approval -> act -> log\n\nPython skeleton idea:\n  Read alert JSON, validate fields, call APIs with timeouts and retries, write an enriched result, and never print secrets.',
        keyTakeaway:
            'Treat automation as production software: versioned, tested, logged, and reviewed.',
        codeSnippet:
            'import json\nimport ipaddress\n\ndef enrich(alert):\n    ip = alert.get("src_ip", "")\n    try:\n        alert["is_private"] = ipaddress.ip_address(ip).is_private\n    except ValueError:\n        alert["is_private"] = None\n    return alert\n\nprint(json.dumps(enrich({"src_ip": "203.0.113.9"})))',
      ),
      ConceptLesson(
        title: 'Guardrails, Testing, and Governance of Automation',
        definition:
            'Automation can cause outages as fast as it can save time. Guardrails, testing, and clear ownership keep it safe.',
        analogy:
            'A powerful machine in a workshop needs guards, an emergency stop, and trained operators.',
        example:
            'Guardrails:\n\nAllow-lists for protected assets (never auto-isolate domain controllers or executive accounts)\nRate limits and maximum actions per hour\nApproval steps for destructive actions\nDry-run mode that logs what it would do\nA kill switch that disables the automation immediately\nAudit logs of every automated action and the data used\nLeast-privilege service accounts with scoped API tokens, rotated and stored in a secrets manager\nTests with sample alerts and a staging environment\nOwnership: named owner, change control, and periodic review\n\nWatch for automation risks: wrong data causing wrong actions, loops that retrigger themselves, and attackers abusing the automation account.',
        keyTakeaway:
            'The automation account is a high-value target. Scope it tightly, monitor it, and make every action reversible and logged.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which task is the best first candidate for full automation?',
        options: [
          'Isolating the CEO laptop on a single low-confidence alert',
          'Enriching alerts with reputation and asset context and attaching it to the ticket',
          'Deleting production databases',
          'Disabling all accounts on weekends'
        ],
        correctIndex: 1,
        explanation:
            'Enrichment is repetitive, low-risk, and reversible. High-impact actions need confidence and approval.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is a dry-run mode in an automation playbook?',
        options: [
          'A mode that runs only in the rain',
          'A mode that logs what actions would be taken without actually performing them',
          'A mode that deletes logs',
          'A faster mode'
        ],
        correctIndex: 1,
        explanation:
            'Dry runs let you test logic safely before allowing real actions.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why must the credentials used by the automation be tightly scoped?',
        options: [
          'To make scripts shorter',
          'Because a compromised automation account could be abused to take powerful actions at scale',
          'Because APIs reject long tokens',
          'To avoid logging'
        ],
        correctIndex: 1,
        explanation:
            'Automation accounts are attractive targets, so least privilege, rotation, and monitoring are essential.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your auto-containment playbook isolates any host that triggers a high alert. One day it isolates a domain controller and halts logins. What guardrail was missing?',
        options: [
          'A bigger monitor',
          'A protected-asset allow-list and an approval step for critical systems',
          'More alerts',
          'A faster API'
        ],
        correctIndex: 1,
        explanation:
            'Critical assets need exclusions or human approval before disruptive actions.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'An automated playbook creates a ticket whenever an alert arrives, and the ticket update re-triggers the alert, creating thousands of tickets. What problem is this?',
        options: [
          'A DNS error',
          'A feedback loop; add deduplication, idempotency checks, and rate limits',
          'A disk issue',
          'A browser bug'
        ],
        correctIndex: 1,
        explanation:
            'Automations that trigger themselves need loop protection and idempotent design.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build a Phishing Triage Automation (Lab)',
      goal:
          'Design, build, test, and document a small automation that enriches reported phishing emails, with proper guardrails.',
      steps: [
        'Write the manual phishing triage procedure as a flowchart with decision points and approval gates',
        'Create sample reported emails (invented, harmless) in a folder, including headers and URLs',
        'Write a Python script or Shuffle or n8n workflow that extracts URLs and sender domains, checks them against a lab blocklist and a public reputation source by indicator only, and produces a JSON result',
        'Add guardrails: dry-run mode, rate limits, protected-sender allow-list, logging, and a kill switch',
        'Add an approval step before any blocking action and write 6 tests with sample inputs',
        'Document the design, risks, metrics (time saved per case), and ownership in a README',
      ],
      expectedOutput:
          'Phishing Automation (lab)\n\nFlow: report -> extract -> reputation -> verdict -> approval -> block -> ticket\n\nGuardrails: dry-run ✓ rate limit 30/h ✓ protected senders ✓ kill switch ✓ audit log ✓\nTests: 6 passed\n\nResult on 10 samples: 7 benign, 3 suspicious; time per case 6 min -> 1 min ✓\nREADME with risks and ownership ✓',
      xpReward: 60,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 7
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l9_privacy_engineering',
    topicTitle: 'Privacy Engineering & Data Protection Compliance',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 38,
    totalXp: 215,
    emoji: '🔏',
    intro:
        'Security protects data from attackers. Privacy protects people from misuse of their data, including by the organisation that holds it. Laws such as India DPDP Act 2023 and the EU GDPR make privacy a legal duty, and security engineers are central to meeting it. This lesson covers the principles, the engineering practices, and the compliance workflows.',
    concepts: [
      ConceptLesson(
        title: 'Privacy Principles and Key Laws',
        definition:
            'Privacy law gives individuals rights over their personal data and places duties on organisations that collect and use it. Common principles include lawful and fair processing, purpose limitation, data minimisation, accuracy, storage limitation, security, and accountability.',
        analogy:
            'Your data is lent to the organisation for a stated purpose. The organisation is a careful borrower: it uses the data only for that purpose, protects it, and returns or destroys it when finished.',
        example:
            'Key laws (verify current text and timelines):\n\nIndia DPDP Act, 2023: roles of Data Fiduciary (organisation) and Data Principal (individual), notice and consent, purpose limitation, security safeguards, breach intimation, rights of access, correction, and erasure, special rules for children data, obligations for significant data fiduciaries\nEU GDPR: lawful bases, data subject rights, data protection impact assessments, breach notification to the regulator within 72 hours where required, heavy fines\nOther: sector rules such as RBI, SEBI, and IRDAI requirements in India\n\nCheck the current rules and implementation dates on official government sources, since subordinate rules and timelines are updated.',
        keyTakeaway:
            'Know which laws apply to your data and users. Legal obligations shape what security must prove, so work closely with your legal team.',
      ),
      ConceptLesson(
        title: 'Privacy by Design and Data Mapping',
        definition:
            'Privacy by design builds privacy protections into systems from the start. A data map records what personal data exists, where it flows, why it is collected, and who can access it.',
        analogy:
            'Before moving house you list every item and where it goes. You cannot protect or delete what you have not inventoried.',
        example:
            'Data mapping questions:\n\nWhat personal data do we collect? (names, phone numbers, location, health, financial, children data)\nWhy do we collect it, and what is the legal basis or consent?\nWhere is it stored and which systems and vendors receive it?\nWho can access it?\nHow long do we keep it, and how is it deleted?\nIs it transferred across borders?\n\nPrivacy by design principles:\n  Proactive, not reactive\n  Privacy as the default setting\n  Embedded into design\n  End-to-end security\n  Visibility and transparency\n  Respect for user privacy',
        keyTakeaway:
            'A current data map is the foundation of every privacy task: notices, rights requests, breach response, and impact assessments all depend on it.',
      ),
      ConceptLesson(
        title: 'Technical Privacy Controls',
        definition:
            'Engineering controls reduce privacy risk: minimising data, masking it, separating identifiers from other data, and controlling access and retention.',
        analogy:
            'A hospital shows a doctor only the information needed for the current treatment, and uses a patient number instead of a name on lab samples.',
        example:
            'Techniques:\n\nData minimisation: collect only needed fields\nPseudonymisation: replace direct identifiers with tokens, keeping the mapping separately and securely (still personal data in law)\nAnonymisation: irreversible removal of identifiability (hard to do well; re-identification is a real risk)\nAggregation and differential privacy for analytics\nTokenisation and format-preserving encryption for sensitive fields\nField-level encryption and strict access control\nRetention schedules with automated deletion\nConsent and preference management systems\nPrivacy-preserving logging: do not log personal data unnecessarily\n\nWarning: removing names alone often does not anonymise data. Combinations such as birth date, postal code, and gender can identify people.',
        keyTakeaway:
            'Be sceptical of claims of anonymisation. Test whether combinations of fields could re-identify people.',
      ),
      ConceptLesson(
        title: 'Rights Requests, Impact Assessments, and Breach Handling',
        definition:
            'Organisations must handle requests from individuals, assess high-risk processing, and respond correctly to data breaches. Security engineers help make these processes technically possible and reliable.',
        analogy:
            'It is the customer service, safety inspection, and emergency response functions of the privacy programme.',
        example:
            'Processes:\n\nData principal rights: find all data about a person across systems, correct it, and delete it on valid request, within legal time limits\nData Protection Impact Assessment (DPIA): required for high-risk processing such as large-scale sensitive data or new technologies; describe processing, assess risks, and define mitigations\nBreach handling: detect, contain, assess the risk to individuals, notify the regulator and affected people when required, and document the decision\nVendor management: contracts that define processor duties and security measures\n\nEngineering enablers:\n  Searchable data inventory, deletion workflows, audit trails, and tested breach response plans',
        keyTakeaway:
            'If you cannot find and delete a person data across your systems, you cannot honour their rights. Design for it early.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does purpose limitation require?',
        options: [
          'Collect as much data as possible',
          'Use personal data only for the specified purposes for which it was collected',
          'Store data forever',
          'Share data freely'
        ],
        correctIndex: 1,
        explanation:
            'Organisations may not reuse data for unrelated purposes without a proper basis.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is pseudonymised data still treated as personal data in many laws?',
        options: [
          'Because it is public',
          'Because the individual can still be identified by combining it with the separately held mapping or other data',
          'Because it is encrypted',
          'Because names are visible'
        ],
        correctIndex: 1,
        explanation:
            'Pseudonymisation reduces risk but does not remove the possibility of re-identification.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the foundation that makes rights requests, notices, and breach response possible?',
        options: [
          'A current data map and inventory of personal data',
          'A faster internet',
          'A new logo',
          'More employees'
        ],
        correctIndex: 0,
        explanation:
            'You must know what personal data you hold and where it flows to manage it properly.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A team says: "We removed names, so the dataset is anonymous." The dataset still contains date of birth, postal code, and gender. What is your response?',
        options: [
          'Agree',
          'Explain that combinations of these fields can re-identify people, so it may still be personal data; assess re-identification risk and apply stronger anonymisation or aggregation',
          'Publish it',
          'Add more columns'
        ],
        correctIndex: 1,
        explanation:
            'Quasi-identifiers can single out individuals, so removing names alone is insufficient.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A user requests deletion of all their data, but copies exist in 3 databases, backups, and analytics exports. What design could have helped?',
        options: [
          'Nothing',
          'A maintained data map, central identifiers, deletion workflows that cover all systems, and defined backup retention and handling',
          'Hiding the request',
          'Deleting only the login'
        ],
        correctIndex: 1,
        explanation:
            'Planning for data discovery and deletion across systems makes rights requests manageable.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Privacy Impact Pack for a Fictional App',
      goal:
          'Create a data map, privacy risk assessment, and controls plan for a fictional health and fitness app.',
      steps: [
        'Scenario: an app that collects name, phone, location, workout data, heart rate, and optional health conditions, and uses a cloud analytics vendor',
        'Create a data map with data type, purpose, legal basis or consent, storage location, recipients, access roles, and retention',
        'Run a LINDDUN-style review and write 8 privacy risks with mitigations',
        'Write a mini DPIA for the health data processing',
        'Design technical controls: minimisation, pseudonymisation, field-level encryption, retention automation, and consent management',
        'Write a rights request procedure (access and deletion) and a breach notification decision flow, noting which laws you would check',
      ],
      expectedOutput:
          'Privacy Pack: FitLife\n\nData map: 9 data types | purposes | retention: workout 2 y, health 1 y, location 30 d\n\nRisks (8): excessive location collection, vendor sharing, re-identification from analytics, weak consent...\nMini DPIA: health data = high risk; mitigations: explicit consent, encryption, access limits, vendor DPA\n\nControls: minimise location, pseudonymise analytics IDs, field-level encryption, auto-delete job\nProcedures: rights requests (30 day target), breach flow (assess, notify per DPDP/GDPR as applicable) ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 8
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l9_mobile_iot_ot',
    topicTitle: 'Mobile, IoT & Industrial (OT) Security Fundamentals',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 38,
    totalXp: 215,
    emoji: '📱',
    intro:
        'Security does not stop at websites and servers. Phones hold banking apps, smart devices sit on home and office networks, and industrial systems run power grids and factories. Each has special constraints and risks. This lesson gives you a defender view of all three.',
    concepts: [
      ConceptLesson(
        title: 'Mobile App Security Essentials',
        definition:
            'Mobile apps run on devices the user controls, so the app cannot trust its own environment. Secure mobile development protects stored data, network communication, authentication, and the app itself, guided by OWASP MASVS and MASTG.',
        analogy:
            'Delivering valuables to a customer home means you cannot assume the house is safe. You carry less, lock what you carry, and verify who is at the door.',
        example:
            'Key practices:\n\nStore secrets and tokens in the platform secure storage (Android Keystore, iOS Keychain; in Flutter, a secure storage plugin built on them), never in plain preferences or source code\nNever hard-code API keys or backend credentials in the app\nUse TLS for all traffic and consider certificate pinning for high-risk apps, with a safe update plan\nAuthenticate users on the server and authorise every request on the server\nUse biometric authentication as a convenience layer on top of server-side checks\nMinimise permissions\nProtect against screenshots and clipboard leaks for sensitive screens where appropriate\nValidate deep links and inputs\nObfuscation and root or jailbreak detection raise the effort for attackers but are not security boundaries\nKeep dependencies updated and scan them\n\nReferences: OWASP Mobile Application Security Verification Standard (MASVS) and Testing Guide (MASTG).',
        keyTakeaway:
            'Anything shipped inside an app can be extracted. Keep real secrets and decisions on the server.',
      ),
      ConceptLesson(
        title: 'Testing Mobile Apps Safely',
        definition:
            'Mobile security testing examines the app, its storage, its network traffic, and its backend API, using your own test devices and apps you are authorised to assess.',
        analogy:
            'A safety inspector checks the product, its packaging, and the delivery route, but only for products they are authorised to test.',
        example:
            'Test areas (own apps or intentionally vulnerable apps only):\n\nInsecure data storage: are tokens or personal data readable on the device?\nNetwork: is all traffic encrypted and does the app validate certificates?\nAuthentication and session handling\nBackend API authorisation (most real flaws live here)\nExposed components and deep links\nThird-party SDKs and what data they collect\n\nPractice resources:\n  Intentionally vulnerable apps designed for learning\n  OWASP MASTG exercises\n  Your own debug builds on an emulator or test phone\n\nUse proxy tools such as ZAP or Burp with your own test builds to inspect traffic.',
        keyTakeaway:
            'Most serious mobile issues are on the server side. Always test the API the app talks to, not just the app.',
      ),
      ConceptLesson(
        title: 'IoT Security Fundamentals',
        definition:
            'Internet of Things devices are small, numerous, and often poorly secured: default passwords, no update mechanism, exposed services, and long lifespans. Compromised IoT devices have powered large botnets.',
        analogy:
            'Imagine thousands of cheap door locks that all share the same factory key. One leaked key opens every door.',
        example:
            'Common IoT problems:\n\nDefault or hard-coded credentials\nNo secure update path, or unsigned firmware\nUnencrypted communication\nUnnecessary open services\nInsecure cloud and mobile companion apps\nLack of vendor support after a few years\n\nDefences:\n  Change default credentials, disable unused services\n  Put IoT on a separate VLAN with restricted internet access\n  Keep firmware updated and prefer vendors with a security update policy\n  Secure boot and signed updates for manufacturers\n  Unique per-device credentials\n  Monitor for unusual traffic\n\nReferences: OWASP IoT guidance, ETSI EN 303 645 baseline for consumer IoT.',
        keyTakeaway:
            'Segment IoT devices and never trust them. Assume they are vulnerable and limit what they can reach.',
      ),
      ConceptLesson(
        title: 'Operational Technology and Industrial Control Systems',
        definition:
            'Operational technology (OT) and industrial control systems (ICS) run physical processes such as power, water, manufacturing, and transport. Safety and availability come first, and many systems are old, fragile, and cannot be patched or scanned like office IT.',
        analogy:
            'IT protects information. OT protects physical processes where a mistake could stop a factory or endanger people, so careful, gentle methods are essential.',
        example:
            'Key ideas:\n\nPriorities differ: in OT availability and safety usually come before confidentiality\nThe Purdue model describes layers from physical process up to business networks, and guides segmentation\nSegment IT and OT with firewalls and a demilitarised zone; air gaps are rarely complete in practice\nUse passive network monitoring (for example Zeek or dedicated OT monitoring tools) instead of aggressive active scanning, which can crash fragile devices\nControl remote access with MFA, jump hosts, and recording\nInventory assets and know firmware versions\nStandards: IEC 62443 and NIST SP 800-82\nIndia: critical information infrastructure is supported by NCIIPC\n\nOnly work on OT with explicit authorisation, safety training, and owner supervision.',
        keyTakeaway:
            'In OT, do no harm. Prefer passive monitoring, careful change control, and close cooperation with the engineers who run the process.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Where should a mobile app store an authentication token?',
        options: [
          'In plain text in shared preferences',
          'In the platform secure storage, such as Android Keystore or iOS Keychain',
          'In the app source code',
          'In a public file'
        ],
        correctIndex: 1,
        explanation:
            'Secure storage protects tokens using hardware-backed or OS-protected mechanisms.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is it risky to embed a backend admin API key inside a mobile app?',
        options: [
          'Apps cannot have keys',
          'The app can be unpacked and the key extracted by anyone',
          'Keys make apps slower',
          'It is required'
        ],
        correctIndex: 1,
        explanation:
            'Anything inside the app package can be inspected, so powerful secrets must stay on the server.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is aggressive active scanning dangerous in OT environments?',
        options: [
          'It is too slow',
          'Fragile devices may crash or misbehave, which can disrupt physical processes and safety',
          'It cannot find anything',
          'It needs a license'
        ],
        correctIndex: 1,
        explanation:
            'Industrial devices often cannot handle unexpected traffic, so passive monitoring and careful coordination are preferred.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Smart cameras on your office network all use the same default password and can reach the internal file server. What is the best remediation?',
        options: [
          'Leave them',
          'Change to unique strong credentials, move them to an isolated IoT VLAN, block access to internal servers, and update firmware',
          'Remove the passwords',
          'Give them admin rights'
        ],
        correctIndex: 1,
        explanation:
            'Segmentation and unique credentials limit both compromise and lateral movement.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A mobile banking app relies on root detection and obfuscation as its main protection. What is wrong with this approach?',
        options: [
          'Nothing',
          'These controls raise effort but can be bypassed, so server-side authentication, authorisation, and monitoring must be the real protection',
          'They make the app too secure',
          'They are illegal'
        ],
        correctIndex: 1,
        explanation:
            'Client-side defences are speed bumps, not security boundaries. Enforce rules on the server.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Mobile, IoT, and OT Security Assessment Plan',
      goal:
          'Produce a checklist-based review for a mobile app, a smart device setup, and an OT network scenario.',
      steps: [
        'Mobile: write a 15-item checklist from OWASP MASVS for storage, network, authentication, and platform use; review one app you own or build against it',
        'Inspect your own test build traffic with a proxy on an emulator and record whether all traffic is encrypted and whether sensitive data appears in responses',
        'IoT: inventory the smart devices in your home lab, change defaults, create an isolated network segment, and verify the devices cannot reach your main devices',
        'OT: read about the Purdue model and design a segmentation diagram for a fictional water treatment plant with IT, DMZ, control, and field layers',
        'List safe monitoring approaches for the plant and explain why active scanning is avoided',
        'Write a summary with the top 5 risks across all three areas and recommended controls',
      ],
      expectedOutput:
          'Assessment Pack\n\nMobile checklist: 15 items | own app: 11 pass, 4 fail (token in shared prefs, no pinning plan, verbose logs, over-broad permissions)\nTraffic review: all HTTPS; one response over-shares fields -> API fix\n\nIoT: 4 devices, defaults changed, isolated VLAN, no route to internal hosts ✓\n\nOT design: Purdue levels 0-5 with DMZ and one-way gateways; passive monitoring only; MFA jump host\n\nTop 5 risks + controls ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 9
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l9_bug_bounty_disclosure',
    topicTitle:
        'Bug Bounty, Vulnerability Disclosure & Security Research Ethics',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 36,
    totalXp: 210,
    emoji: '🐞',
    intro:
        'Many organisations invite outside researchers to report vulnerabilities, and some pay rewards for valid findings. Done well, bug bounty and responsible disclosure are a legitimate career path and a valuable service. Done carelessly, they can lead to legal trouble. This lesson covers how to take part professionally and how organisations should run such programmes.',
    concepts: [
      ConceptLesson(
        title: 'Vulnerability Disclosure Programmes and Bug Bounties',
        definition:
            'A vulnerability disclosure programme (VDP) gives researchers a safe, official way to report security issues. A bug bounty adds financial rewards, usually through a published scope and rules, often on a platform.',
        analogy:
            'A VDP is a clearly signposted door marked "report a problem here". A bug bounty adds a reward for helpful reports.',
        example:
            'Key elements:\n\nA published policy: scope, rules, how to report, and what to expect\nSafe harbour language: the organisation commits not to take legal action against good-faith research within the rules\nA security contact and a security.txt file on websites (RFC 9116)\nTriage, response times, and fixing commitments\nRewards table based on severity (for bounty programmes)\n\nPlatforms: HackerOne, Bugcrowd, Intigriti, and company-run programmes\nIndia: CERT-In coordinates vulnerability reports, and some government and private bodies run their own programmes',
        keyTakeaway:
            'Only test what a published programme explicitly allows, and read the rules for every programme before touching anything.',
      ),
      ConceptLesson(
        title: 'Researcher Ethics and Staying Legal',
        definition:
            'Ethical research stays within scope, avoids harm, protects data, and discloses responsibly. Legal protections depend on following the rules, and the law may not protect you if you go beyond them.',
        analogy:
            'A guest invited to inspect a house for fire hazards may check the smoke alarms but may not open private drawers or take belongings.',
        example:
            'Rules of conduct:\n\nTest only in-scope assets and permitted techniques\nNo denial of service, no social engineering of staff, no physical attacks unless explicitly allowed\nDo not access, download, modify, or share real user data beyond the minimum to prove an issue, and stop immediately if you see personal data\nUse test accounts you create, not real user accounts\nDo not exploit further after proving the issue (no pivoting, persistence, or data collection)\nReport promptly and keep details confidential until the issue is fixed or the programme allows disclosure\nNever demand payment or threaten disclosure\nIf unsure, ask the programme before acting\n\nLaws differ by country, and a programme policy does not override the law, so understand the rules that apply to you.',
        keyTakeaway:
            'Stop at proof. Minimal, careful testing and honest communication protect you and the organisation.',
      ),
      ConceptLesson(
        title: 'Writing a Great Vulnerability Report',
        definition:
            'A good report makes it easy for the security team to understand, reproduce, and fix the issue. Quality reports are accepted faster and rewarded better.',
        analogy:
            'A clear repair ticket with photos and exact steps gets the leaking pipe fixed quickly. A vague note gets lost.',
        example:
            'Report structure:\n\nTitle: specific and descriptive\nSummary: one or two sentences\nAffected asset and version\nSeverity with reasoning (CVSS and business impact)\nSteps to reproduce: numbered, exact, and safe\nProof: screenshots, requests and responses (with sensitive data redacted)\nImpact: what an attacker could realistically do\nSuggested fix\nReferences: CWE, OWASP category\n\nCommon reasons for rejection:\n  Out of scope, duplicate, no real impact, or not reproducible\n  Automated scanner output without validation',
        keyTakeaway:
            'Validate before you report. One clear, reproducible report beats ten noisy ones.',
      ),
      ConceptLesson(
        title: 'Handling Reports as an Organisation, and the CVE Process',
        definition:
            'Organisations need a process to receive, triage, fix, and communicate about reports. For widely used software, vulnerabilities may receive a CVE identifier through a CVE Numbering Authority (CNA) and be published in a coordinated advisory.',
        analogy:
            'It is the hospital intake process: acknowledge the patient, assess severity, treat, and tell the right people once it is safe.',
        example:
            'Organisation workflow:\n\n1. Acknowledge receipt quickly\n2. Triage and reproduce\n3. Assess severity and affected versions\n4. Fix, test, and release\n5. Communicate with the reporter, and credit them if they agree\n6. Publish an advisory and request a CVE if appropriate\n7. Review for similar issues\n\nCoordinated disclosure timelines are commonly around 90 days, adjusted for severity and complexity.\n\nFor researchers: contact the vendor first; if there is no response, a coordinator such as CERT-In or a national CERT can help.',
        keyTakeaway:
            'Responsiveness and respect for researchers builds trust and results in better security for everyone.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Before testing any website for a bug bounty, what must you do first?',
        options: [
          'Run every scanner immediately',
          'Read the programme scope and rules and test only what is explicitly allowed',
          'Ask other researchers for permission',
          'Test everything on the domain'
        ],
        correctIndex: 1,
        explanation:
            'Scope and rules define what is authorised, and going beyond them can be illegal.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'You find an exposed database while testing and see real customer records. What should you do?',
        options: [
          'Download all records as proof',
          'Stop, avoid accessing more data, and report it immediately with minimal proof',
          'Share it with friends',
          'Demand a payment'
        ],
        correctIndex: 1,
        explanation:
            'Minimise access to personal data and report responsibly. Never threaten or demand payment.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the purpose of a security.txt file?',
        options: [
          'To list passwords',
          'To tell researchers how to contact the organisation about security issues',
          'To block crawlers',
          'To speed up pages'
        ],
        correctIndex: 1,
        explanation:
            'security.txt provides a standard place for contact details and disclosure policy.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You submitted a valid vulnerability, but the company has not replied for 3 weeks. What is the most appropriate step?',
        options: [
          'Post it publicly now',
          'Follow up politely, try other security contacts, and if still no response consider a coordinator such as CERT-In while keeping details confidential',
          'Exploit it further',
          'Forget it'
        ],
        correctIndex: 1,
        explanation:
            'Persistent, professional follow-up and coordination channels are better than immediate public disclosure.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A researcher sends a report that is raw scanner output with no validation and says it is critical. How should a triage team respond?',
        options: [
          'Pay the maximum reward',
          'Politely ask for a validated, reproducible proof of impact, explain what is needed, and close as informational if it cannot be reproduced',
          'Ban the researcher',
          'Ignore all reports'
        ],
        correctIndex: 1,
        explanation:
            'Constructive feedback improves report quality and keeps the programme fair and effective.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Responsible Disclosure Toolkit',
      goal:
          'Create a vulnerability disclosure policy, a security.txt, and a model report, and practise on a legal target.',
      steps: [
        'Write a vulnerability disclosure policy for a fictional company: scope, safe harbour language, rules, contact, and response targets',
        'Create a security.txt file following RFC 9116 with contact, policy link, and expiry',
        'Write a bug report template with all required fields',
        'Practise on a legal target: your own lab or an intentionally vulnerable app, or a legal training platform, and write one full report for a real finding there',
        'Write an internal triage workflow for the fictional company from receipt to fix and advisory',
        'Write a one-page personal code of conduct for security research',
      ],
      expectedOutput:
          'Disclosure Toolkit\n\nPolicy: scope (app.example.com, api.example.com), safe harbour, rules, 5-day acknowledgement, 90-day fix target\nsecurity.txt: Contact, Policy, Expires, Preferred-Languages ✓\n\nReport template + one complete lab report (IDOR in Juice Shop: steps, proof, impact, fix)\nTriage workflow: acknowledge -> reproduce -> assess -> fix -> advisory -> credit\n\nPersonal code of conduct written ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 10
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l9_real_world_capstone',
    topicTitle: 'Capstone: Real-World Security Programme Project & Portfolio',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 70,
    totalXp: 300,
    emoji: '🏆',
    intro:
        'This is your Level 9 capstone and the largest project in the path so far. You will act as the security engineer for a fictional company: assess risk, design controls, build detection, test, respond to a simulated incident, and report to leadership. You will also package everything as a public portfolio that shows employers how you work.',
    concepts: [
      ConceptLesson(
        title: 'Choosing and Scoping Your Project',
        definition:
            'A strong capstone has a clear story, a defined scope, and measurable results. You choose a company scenario and a track, then break the work into deliverables you can finish.',
        analogy:
            'A good final-year project in engineering has a defined problem, a plan, a build, tests, and a presentation, not just a pile of experiments.',
        example:
            'Scenario: ShopRight, an online retailer with 300 staff, an e-commerce web app, mobile app, cloud hosting, and a small IT team\n\nTracks (choose one primary and include elements of others):\n  Security operations: SIEM, detections, incident response\n  Application security: assessment, fixes, pipeline security\n  Cloud security: secure environment as code, posture management\n  GRC and privacy: risk register, policies, DPDP compliance plan\n  Offensive and purple: scoped test, report, detection improvements\n\nScope rules:\n  Everything runs in your isolated lab or your own learning account\n  Use fictional data only\n  Time-box each deliverable',
        keyTakeaway:
            'Finish a smaller scope well. A complete, well-documented project beats an ambitious unfinished one.',
      ),
      ConceptLesson(
        title: 'Deliverables of a Professional Security Project',
        definition:
            'Professional projects produce a consistent set of documents and artefacts: an assessment, a plan, working technical controls, test evidence, and an executive summary.',
        analogy:
            'A building project delivers plans, inspection reports, the finished building, and a handover manual.',
        example:
            'Deliverable checklist:\n\n1. Scope and assumptions document\n2. Asset inventory and data map\n3. Threat model and risk register (top 10 risks with owners)\n4. Security architecture diagram\n5. Technical implementation: hardened configuration, IaC, or detections\n6. Test evidence: scans, test cases, purple team results\n7. Incident simulation and response report\n8. Policies: acceptable use, access control, incident response (short and practical)\n9. Metrics and before-and-after comparison\n10. Executive summary (1 page) and roadmap (next 6 months)',
        keyTakeaway:
            'Write the executive summary for a non-technical reader. Being able to explain security in business terms is a career-defining skill.',
      ),
      ConceptLesson(
        title: 'Documentation, Version Control, and Communication',
        definition:
            'Clear documentation and tidy version control show that you work professionally. They let others understand, trust, and reuse your work.',
        analogy:
            'A well-organised workshop with labelled drawers and a logbook lets anyone pick up the work. A messy one hides the quality of the craft.',
        example:
            'Repository structure:\n\nREADME: project summary, scenario, how to navigate\n/docs: architecture, threat model, risk register, reports\n/iac or /config: infrastructure and configuration code\n/detections: Sigma rules and queries with tests\n/scripts: automation with README and tests\n/evidence: sanitised screenshots and outputs\nLICENSE and a clear safety statement\n\nHabits:\n  Meaningful commit messages\n  Diagrams as images and source files\n  No secrets, real IPs, or real data\n  A short project demo video or slide deck\n  A blog post or write-up explaining decisions and lessons learned',
        keyTakeaway:
            'Treat reviewers as busy readers. A clear README and one-page summary decide whether they read the rest.',
      ),
      ConceptLesson(
        title: 'Presenting, Getting Feedback, and Joining the Community',
        definition:
            'Presenting your work and receiving feedback accelerates your growth and builds your reputation. The security community offers many welcoming ways to learn and contribute.',
        analogy:
            'A craftsperson who shows their work at a fair gets advice, contacts, and opportunities that a hidden workshop never provides.',
        example:
            'Ways to share and grow:\n\nPresent the project to a mentor, friends, or a college or local meetup\nAsk for peer review of your reports and detections\nWrite blog posts or CTF write-ups (never reveal active challenge solutions that rules forbid)\nContribute to open-source security projects, for example by improving documentation, adding Sigma rules, or fixing small issues\nJoin communities such as OWASP chapters and local security meetups, and CTF teams\nParticipate in legal practice platforms and competitions\nFollow responsible disclosure and professional ethics at all times\n\nBuild a professional profile: a concise LinkedIn summary, GitHub portfolio, and a short talk you can give.',
        keyTakeaway:
            'Visibility compounds. Regular small public contributions build a record that hiring managers can see.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which is a sensible scope for a capstone project?',
        options: [
          'Testing a real company website without permission',
          'A fictional company in your isolated lab or learning account using fictional data, with time-boxed deliverables',
          'Scanning your neighbour network',
          'Using real customer data'
        ],
        correctIndex: 1,
        explanation:
            'Safe, legal scope and realistic deliverables make the project completable and publishable.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Who should the executive summary be written for?',
        options: [
          'Only other engineers',
          'A non-technical leader who needs the key risks, decisions, and recommendations in plain language',
          'Attackers',
          'No one'
        ],
        correctIndex: 1,
        explanation:
            'Clear communication to decision makers is as important as technical depth.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What must a public portfolio repository never contain?',
        options: [
          'Diagrams',
          'Secrets, real IP addresses or account identifiers, and real personal data',
          'A README',
          'Sigma rules'
        ],
        correctIndex: 1,
        explanation:
            'Sensitive information must be removed and repositories scanned for secrets before publishing.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You have 3 weeks left and many unfinished ideas for your project. What is the best strategy?',
        options: [
          'Start more new components',
          'Cut scope to a complete core set of deliverables, finish and document them well, and list the rest as future work',
          'Stop documenting',
          'Skip testing'
        ],
        correctIndex: 1,
        explanation:
            'A finished, well-documented core is more valuable than many half-done items.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A reviewer says your report is technically strong but too long and hard to follow. How should you improve it?',
        options: [
          'Add more pages',
          'Add a one-page executive summary, use clear headings, move details to appendices, and lead with the top risks and actions',
          'Remove all evidence',
          'Use more jargon'
        ],
        correctIndex: 1,
        explanation:
            'Structure and a clear summary make complex work accessible to different audiences.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Level 9 Capstone: Security Programme for ShopRight (Lab Project)',
      goal:
          'Deliver a complete, end-to-end security project for a fictional company in an isolated lab or learning account, and publish a sanitised portfolio.',
      steps: [
        'Write a scope document for ShopRight: assets, users, data, threats, assumptions, and the track you are emphasising',
        'Build an asset inventory, data map, and a STRIDE and LINDDUN threat model of the e-commerce platform',
        'Create a risk register with at least 10 risks, ratings, owners, and treatments, and map controls to NIST CSF 2.0',
        'Design the security architecture and implement a core part in your lab: for example a hardened environment as code, a SIEM with 8 detections, or an application hardening pipeline',
        'Run a scoped, authorised assessment of your lab environment, write a professional findings report, fix the top issues, and retest',
        'Run a purple team exercise or tabletop and a simulated incident from detection to lessons learned, with a forensic timeline and incident report',
        'Write short, practical policies: access control, incident response, vulnerability management, and data protection and privacy, including a rights request and breach flow',
        'Build a metrics dashboard or table: coverage, detections tested, time to detect and respond, findings before and after',
        'Write a one-page executive summary and a 6-month roadmap with priorities and estimated effort',
        'Publish a sanitised portfolio repository with README, docs, code, evidence, and a short demo or slide deck, and share a write-up for feedback',
      ],
      expectedOutput:
          'ShopRight Security Programme (lab portfolio)\n\nScope: lab-only, fictional data\nThreat model: 18 threats | Risk register: 12 risks mapped to NIST CSF 2.0\n\nImplementation: Terraform baseline + Wazuh SIEM with 8 tested detections + CI security pipeline\nAssessment: 11 findings -> 7 fixed -> retest report\nPurple team: 8 techniques, 5/8 detected first pass, 8/8 after tuning\nIncident simulation: detect 4 min, contain 12 min; forensic timeline and report\n\nPolicies (4) + privacy flow ✓ | Metrics table ✓\nExecutive summary (1 page) + 6-month roadmap ✓\nPublished sanitised repo with demo ✓',
      xpReward: 120,
    ),
  ),
];
