// ══════════════════════════════════════════════════════════════════════
// lib/data/courses/cyber_security_level_10.dart
// Cyber Security Engineer Path — LEVEL 10: Professional Certification,
// Interview & Job Preparation (10 lessons)
// ══════════════════════════════════════════════════════════════════════
import '../../models/course_content_data.dart';

const List<TopicCourse> cyberSecurityLevel10 = [
  // ────────────────────────────────────────────────────────────────────
  // LESSON 1
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l10_career_map',
    topicTitle: 'Cyber Security Career Map & Choosing Your Role',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 190,
    emoji: '🧭',
    intro:
        'You now have broad skills across networking, systems, code, tools, applications, operations, and cloud. The next step is choosing where to aim. Cyber security has many distinct roles with different daily work, and choosing deliberately makes your applications, certifications, and projects far more effective.',
    concepts: [
      ConceptLesson(
        title: 'The Main Role Families',
        definition:
            'Security roles fall into families: defensive operations, offensive testing, engineering and architecture, application security, cloud security, governance, risk and compliance, and specialist fields such as forensics and threat intelligence.',
        analogy:
            'It is like medicine: general practitioners, surgeons, radiologists, and public health officers all work on health, but their days look very different.',
        example:
            'Role families and typical titles:\n\nSecurity operations: SOC Analyst, Incident Responder, Threat Hunter, Detection Engineer\nOffensive: Penetration Tester, Red Team Operator, Vulnerability Assessor\nEngineering: Security Engineer, Security Automation Engineer, Network Security Engineer\nApplication security: AppSec Engineer, Product Security Engineer, DevSecOps Engineer\nCloud security: Cloud Security Engineer, Cloud Security Architect\nGRC and privacy: GRC Analyst, Auditor, Privacy Analyst, Risk Analyst\nSpecialist: Digital Forensics Analyst, Malware Analyst, Threat Intelligence Analyst\nLeadership: Security Manager, Security Architect, CISO',
        keyTakeaway:
            'You do not have to choose forever. Pick a first target role that matches your strengths and interest, and expect to move sideways over time.',
      ),
      ConceptLesson(
        title: 'Entry-Level Doors Into the Field',
        definition:
            'Most people enter through a small number of entry roles, then specialise. Understanding them helps you apply realistically and sequence your learning.',
        analogy:
            'Most hospitals hire interns and junior doctors first. Few begin as chief surgeons, but the junior roles are real ones with real responsibility.',
        example:
            'Common entry roles:\n\nTier 1 SOC Analyst: monitoring and triage\nJunior Security Analyst or Vulnerability Analyst\nIT support or system administrator moving to security\nJunior penetration tester or associate consultant (often in services firms)\nJunior GRC or compliance analyst\nSoftware developer moving into application security\nCloud or DevOps engineer moving into cloud security\n\nTypes of employers:\n  Product companies and startups\n  IT services and consulting firms\n  Managed security service providers (MSSPs)\n  Global capability centres of multinational companies\n  Banks, fintechs, and telecoms\n  Government bodies and public sector units',
        keyTakeaway:
            'SOC and vulnerability analyst roles are the most accessible entry points, and they build skills that transfer to almost every other path.',
      ),
      ConceptLesson(
        title: 'Matching Skills, Interests, and Work Style',
        definition:
            'Different roles reward different strengths: patience and pattern recognition, creativity and persistence, communication and structure, or deep engineering skill. Honest self-assessment helps you choose a path you will enjoy and stay in.',
        analogy:
            'Some people love the calm detective work of reviewing evidence, others love the thrill of the chase, and others enjoy designing the safest building. All are valuable.',
        example:
            'Self-assessment prompts:\n\nDo I prefer reacting to live events or building things over weeks?\nAm I comfortable with shift work and on-call duty?\nDo I enjoy writing and presenting as much as technical work?\nDo I like breaking things, fixing things, or documenting and governing things?\nHow comfortable am I with coding and automation?\nDo I want to work with customers (consulting) or on a single product long term?\n\nTip: look back at which lessons and projects in this path you enjoyed most. That is useful data.',
        keyTakeaway:
            'Choose the work you would still enjoy on a bad day. Interest sustains the long learning curve security demands.',
      ),
      ConceptLesson(
        title: 'Reading Job Descriptions and Skill Gaps',
        definition:
            'Job descriptions list requirements and wishes. Reading them analytically lets you identify the genuine core skills for a role and plan to fill gaps.',
        analogy:
            'A job description is a shopping list. Some items are essential, and some are nice to have. You do not need every item to be a strong candidate.',
        example:
            'Method:\n\n1. Collect 10 job postings for your target role from LinkedIn, Naukri, or company career pages\n2. List every required skill and tool and count how often each appears\n3. Separate must-haves (appear in most postings) from nice-to-haves\n4. Rate yourself honestly 0 to 10 on each must-have\n5. Pick the top three gaps and plan projects or study to close them\n6. Note keywords to use in your resume\n\nWatch for warning signs: unrealistic requirements for junior pay, vague duties, and requests for fees.',
        keyTakeaway:
            'Apply when you meet most of the core requirements. Many postings are wish lists, and candidates who meet 60 to 70 percent often succeed.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which entry role is generally among the most accessible for a new cyber security graduate?',
        options: [
          'Chief Information Security Officer',
          'Tier 1 SOC Analyst or junior vulnerability analyst',
          'Principal red team lead',
          'Head of cryptography research'
        ],
        correctIndex: 1,
        explanation:
            'SOC and vulnerability analyst roles hire in larger numbers at entry level and build transferable skills.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the best way to identify the real core requirements of a role?',
        options: [
          'Read one job post',
          'Analyse around 10 postings and count which skills and tools appear most often',
          'Ask a friend',
          'Guess'
        ],
        correctIndex: 1,
        explanation:
            'Comparing several postings reveals the common core, which should be the focus of your preparation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A job listing asks for a 6-month fee from candidates to "reserve the position". What should you conclude?',
        options: [
          'It is normal',
          'It is a warning sign of a scam, because legitimate employers do not charge candidates to hire them',
          'It guarantees a job',
          'It is required by law'
        ],
        correctIndex: 1,
        explanation:
            'Asking candidates to pay is a hallmark of fraudulent job offers.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You enjoyed the incident response and SIEM work in this path but disliked long shifts. Which approach is sensible?',
        options: [
          'Give up security',
          'Look at detection engineering, threat hunting, or day-shift roles in product companies or MDR teams with rotation, and research shift expectations before applying',
          'Apply only to night-shift jobs',
          'Choose a role at random'
        ],
        correctIndex: 1,
        explanation:
            'Many related roles use similar skills with different schedules, so research and choose deliberately.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A posting for a junior role lists 15 tools and 5 years of experience. What is the best response?',
        options: [
          'Do not apply ever',
          'Treat it as a wish list, check the core skills, and apply if you meet most of the essentials, with a strong portfolio showing practical ability',
          'Lie about experience',
          'Wait 5 years'
        ],
        correctIndex: 1,
        explanation:
            'Postings often exaggerate. Demonstrated skills and honest applications still stand a good chance.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Career Direction Worksheet',
      goal:
          'Choose a primary and backup target role and analyse the market requirements for them.',
      steps: [
        'Write a short self-assessment answering the prompts in this lesson',
        'Pick a primary target role and one backup role, with reasons',
        'Collect 10 real job postings for the primary role and build a frequency table of skills and tools',
        'Rate yourself 0 to 10 on each of the top 10 skills and mark your 3 largest gaps',
        'Match each gap to a specific project, lab, or lesson from this path to revisit',
        'List 10 employers (across product, services, MSSP, and others) you would like to target',
      ],
      expectedOutput:
          'Career Direction\n\nPrimary: SOC Analyst (Tier 1 to Tier 2) | Backup: Vulnerability Analyst\nWhy: enjoy investigation, SIEM and detection labs; open to rotating shifts\n\nTop skills from 10 postings: SIEM (9), Windows/Linux logs (8), incident response (8), MITRE ATT&CK (7), EDR (7), scripting (6)...\nSelf-rating: SIEM 6, scripting 5, EDR 4\nGaps: EDR hands-on, scripting for automation, cloud logs -> revisit Levels 4, 7, 8 labs\n\n10 target employers listed ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 2
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l10_cert_roadmap',
    topicTitle: 'Certification Roadmap & Study Strategy',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 32,
    totalXp: 195,
    emoji: '🎓',
    intro:
        'Certifications can open doors, satisfy employer requirements, and give structure to your learning. But there are many, they cost money, and not every one suits every role. This lesson helps you choose wisely, plan your preparation, and avoid wasting time or money.',
    concepts: [
      ConceptLesson(
        title: 'What Certifications Do and Do Not Do',
        definition:
            'A certification is a third-party verification that you passed an exam, and sometimes a practical test, on a defined body of knowledge. It signals baseline knowledge and commitment, but it is not proof of job skill by itself.',
        analogy:
            'A driving licence shows you passed a test, which is necessary to be hired as a driver. It does not show you can handle a mountain road in the rain. Portfolios and experience show that.',
        example:
            'Benefits:\n\nPasses automated resume filters and HR requirements, especially for entry roles\nProvides a structured syllabus\nOften required for government, defence, and consulting roles\nSome qualify under compliance requirements\n\nLimits:\n  Exams can be memorised without real skill\n  Costs can be high (exam fees, training, renewals)\n  Certifications expire or require continuing education\n\nBest combination: a certification plus hands-on projects and a portfolio.',
        keyTakeaway:
            'Use certifications to open doors and projects to prove ability. Employers value both together.',
      ),
      ConceptLesson(
        title: 'A Roadmap of Common Certifications',
        definition:
            'Certifications are grouped by level and by specialty. A typical path begins with a foundation exam, adds a role-specific certification, and later an advanced or professional-level credential.',
        analogy:
            'It is a ladder with several branches. The first rungs are shared, and higher up you choose the branch that matches your career.',
        example:
            'Examples (always verify current names, versions, prerequisites, and fees on the official sites):\n\nFoundation: CompTIA Security+, ISC2 Certified in Cybersecurity (CC), Microsoft SC-900\nDefensive and SOC: CompTIA CySA+, Blue Team Level 1, Microsoft SC-200, GIAC GSEC and GCIH\nOffensive: INE eJPT, CEH, PNPT, Offensive Security OSCP\nCloud: AWS Certified Security Specialty, Microsoft AZ-500, Google Professional Cloud Security Engineer, ISC2 CCSP\nGovernance and management: ISACA CISM, ISC2 CISSP (requires several years of experience), ISO 27001 Lead Implementer or Auditor\nPrivacy: CIPP, CIPM, and similar\n\nSuggested first steps:\n  SOC path: Security+ then CySA+ or BTL1\n  Offensive path: eJPT then PNPT or OSCP\n  Cloud path: a cloud associate certificate then the security specialty',
        keyTakeaway:
            'Pick one foundation certification and one role-specific certification that matches your target role. Do not collect certificates for their own sake.',
      ),
      ConceptLesson(
        title: 'Building a Study Plan That Works',
        definition:
            'Effective exam preparation combines the official syllabus, active practice, hands-on labs, and regular self-testing, scheduled over a realistic period.',
        analogy:
            'Preparing for an exam is like training for a race: steady practice with progress checks beats cramming the night before.',
        example:
            'Plan template (8 to 12 weeks):\n\nWeek 1: read the official exam objectives and list topics\nWeeks 2 to 7: study one domain at a time, with a video or book, notes in your own words, and a lab or demonstration for each topic\nEvery week: 20 to 30 practice questions, review each wrong answer, and write a short explanation\nWeeks 8 to 9: full-length timed practice exams, and revision of weak areas\nWeek 10: light revision, rest, and book the exam\n\nTips:\n  Use spaced repetition flashcards for terms and ports\n  Explain concepts aloud or teach a friend\n  Use reputable question banks and avoid illegal exam dumps (they violate exam rules and can get you banned)\n  Check exam format: multiple choice, performance-based, or practical lab',
        keyTakeaway:
            'Never use leaked exam questions. They can lead to a ban and they teach nothing. Real understanding is what lasts.',
      ),
      ConceptLesson(
        title: 'Costs, Funding, and Renewal',
        definition:
            'Exams and training can be expensive, so planning the cost and looking for support protects your budget. Many certifications also require renewal through continuing education.',
        analogy:
            'Planning for a big purchase includes the ongoing maintenance, not just the price tag.',
        example:
            'Money-saving ideas:\n\nFree official study guides, objectives, and community resources\nStudent discounts and promotional vouchers from providers\nEmployer sponsorship (ask during interviews and after joining)\nExam retake policies: understand them before booking\nVoucher bundles with training\nFree learning platforms and labs such as TryHackMe free tiers, Microsoft Learn, and AWS Skill Builder\n\nRenewal:\n  Many credentials need continuing education credits or annual maintenance fees\n  Record your learning activities as you go\n\nWatch out for pushy training providers promising guaranteed jobs.',
        keyTakeaway:
            'Ask employers about certification sponsorship. Many companies pay for relevant credentials once you have joined.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the best combination to show an employer your readiness?',
        options: [
          'A certification only',
          'A relevant certification together with hands-on projects and a portfolio',
          'No evidence',
          'Only a list of tool names'
        ],
        correctIndex: 1,
        explanation:
            'Certification shows baseline knowledge, and projects prove the practical skill employers need.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why should you avoid exam dumps?',
        options: [
          'They are too expensive',
          'They violate exam rules, can lead to a ban, and teach nothing real',
          'They are too long',
          'They are always wrong'
        ],
        correctIndex: 1,
        explanation:
            'Using leaked questions is cheating, risks your credential and reputation, and leaves you unprepared for real work.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which is a sensible first certification pairing for someone targeting a SOC analyst role?',
        options: [
          'A foundation exam such as Security+ followed by a defensive one such as CySA+ or BTL1',
          'Only the most advanced management certificate',
          'A cooking course',
          'Five random certificates'
        ],
        correctIndex: 0,
        explanation:
            'A foundation plus a role-specific defensive credential matches what SOC employers commonly look for.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A training company promises a guaranteed job if you buy an expensive package immediately. What is the best response?',
        options: [
          'Pay immediately',
          'Be cautious: verify claims, ask for placement data and contract terms, compare with free and cheaper official resources, and never rely on job guarantees',
          'Share your bank details',
          'Recommend it to friends'
        ],
        correctIndex: 1,
        explanation:
            'Job guarantees are a common marketing tactic. Verify before paying, and compare alternatives.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You scored 58 percent on a full practice exam. What is the most effective next step?',
        options: [
          'Book the real exam tomorrow',
          'Review every wrong answer by domain, revisit weak topics with labs and notes, and retake a different practice exam before booking',
          'Stop studying',
          'Memorise the exact questions'
        ],
        correctIndex: 1,
        explanation:
            'Targeted review of weak areas improves understanding and readiness far more than repeating the same questions.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Personal Certification Plan and Budget',
      goal:
          'Choose certifications for your target role, build a study schedule, and plan the budget.',
      steps: [
        'Look up the official exam objectives, fees, format, validity, and prerequisites for 3 certifications relevant to your target role',
        'Choose one foundation and one role-specific certification, with reasons and a target date for each',
        'Create a week-by-week study plan with topics, labs, and weekly practice questions',
        'Create a budget with exam fees, materials, and retake allowance, and list free resources and possible employer sponsorship',
        'Define success metrics: practice exam scores you must reach before booking',
        'Set up a tracking sheet and a weekly review habit',
      ],
      expectedOutput:
          'Certification Plan\n\nTarget role: SOC Analyst\nStep 1: Security+ (10 weeks) | Step 2: CySA+ or BTL1 (10 weeks)\n\nWeekly plan: domain study + lab + 30 practice questions\nBudget: exam fees + materials + 1 retake reserve; free resources listed\nReadiness rule: 3 consecutive practice exams above 80 percent before booking\n\nTracking sheet created ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 3
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l10_exam_domain_review',
    topicTitle: 'Core Knowledge Review for Security Certification Exams',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 42,
    totalXp: 220,
    emoji: '📝',
    intro:
        'Foundation certifications such as CompTIA Security+ test breadth across the whole field. You have already met nearly all of the content in this path. This lesson helps you organise it, review the most examinable ideas, and practise exam-style thinking, including how to approach scenario questions.',
    concepts: [
      ConceptLesson(
        title: 'Mapping This Path to Exam Domains',
        definition:
            'Foundation exams are divided into domains with published weightings. Mapping what you have learned to those domains shows where you are strong and where to revise. Always confirm the current objectives on the official exam page.',
        analogy:
            'Before a big exam you create a map of the syllabus and colour in the parts you have mastered. The uncoloured areas are your study plan.',
        example:
            'Example: CompTIA Security+ SY0-701 domains (verify the current version and weightings):\n\n1. General Security Concepts (about 12 percent): CIA, controls, zero trust, cryptography basics, change management\n2. Threats, Vulnerabilities, and Mitigations (about 22 percent): threat actors, malware, social engineering, application and network attacks, mitigation techniques\n3. Security Architecture (about 18 percent): cloud, network design, data protection, resilience\n4. Security Operations (about 28 percent): hardening, vulnerability management, monitoring, IAM, incident response, automation\n5. Security Program Management and Oversight (about 20 percent): governance, risk, compliance, audits, awareness\n\nMapping to this path: Levels 1 to 3 cover domains 1 and 2; Levels 4 to 8 cover domains 3 and 4; Levels 8 and 9 cover domain 5.',
        keyTakeaway:
            'Study proportionally to the weightings. The largest domains deserve the most revision time.',
      ),
      ConceptLesson(
        title: 'High-Yield Concepts to Revise',
        definition:
            'Some topics appear repeatedly across foundation exams and interviews. A short, active revision list helps you recall them quickly.',
        analogy:
            'Revision is like keeping your most-used tools at the front of the toolbox.',
        example:
            'High-yield checklist:\n\nCIA triad and AAA, non-repudiation\nControl types: preventive, detective, corrective, deterrent, compensating, and categories: technical, managerial, operational, physical\nSymmetric (AES) vs asymmetric (RSA, ECC), hashing (SHA-256), digital signatures, PKI and certificates\nAuthentication factors, MFA, SSO, SAML, OAuth, Kerberos basics\nCommon ports: 22, 23, 25, 53, 80, 110, 143, 389, 443, 445, 3389\nAttack types: phishing, SQL injection, XSS, CSRF, DoS and DDoS, MITM, privilege escalation, password attacks\nSecure network design: segmentation, DMZ, VPN, firewalls, IDS and IPS, zero trust\nVulnerability management: scanning, CVSS, patching, prioritisation\nIncident response phases and forensics order of volatility\nRisk: likelihood and impact, ALE, risk responses, BIA, RTO, RPO\nCloud shared responsibility, IAM, encryption, logging\nCompliance and privacy basics',
        keyTakeaway:
            'Turn this checklist into flashcards and quiz yourself daily. Short, frequent recall beats long, occasional reading.',
      ),
      ConceptLesson(
        title: 'Exam-Style Reasoning: BEST, FIRST, and MOST Questions',
        definition:
            'Many exam questions ask for the BEST answer, the FIRST action, or the MOST likely cause, with several options that are partly correct. Success depends on reading carefully and thinking like a practitioner.',
        analogy:
            'It is like triage in an emergency room: several treatments could help, but you must choose what to do first and what matters most.',
        example:
            'Techniques:\n\n1. Read the last sentence first to know what is asked\n2. Underline keywords: first, best, most, least, NOT, cost-effective\n3. Eliminate answers that are clearly wrong or outside the scenario\n4. Prefer answers that follow standard process (for example contain before eradicate)\n5. Prefer the least privilege and defence-in-depth options\n6. Beware of answers that are true but do not answer the question asked\n7. Use time wisely: flag hard questions, move on, and return\n\nFor performance-based questions (simulations): read the whole task, apply known best practices, and double-check each setting.',
        keyTakeaway:
            'Answer as a professional following best practice, not as a hacker looking for shortcuts. The exam rewards process and prudence.',
      ),
      ConceptLesson(
        title: 'Test-Day Readiness',
        definition:
            'Good preparation includes the practical side of exam day: logistics, mindset, and recovery from a poor result. A calm start improves performance.',
        analogy:
            'Even a well-trained athlete prepares kit, travel, food, and sleep for the race.',
        example:
            'Checklist:\n\nConfirm identification requirements and the exam centre or online proctoring rules in advance\nFor online exams: test your computer, camera, internet, and clear the room as required\nSleep well and eat before the exam\nArrive early or log in early\nUse the allowed note board or tools sensibly\nManage time: calculate average minutes per question\nIf you fail: review the score report by domain, study the weak areas, check the retake policy, and try again\n\nAfter passing: add the credential to your resume and LinkedIn, and note its renewal requirements.',
        keyTakeaway:
            'A failed attempt is information, not a verdict. Use the domain feedback to target your next round of study.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the difference between a preventive and a detective control?',
        options: [
          'Preventive stops an incident from happening, and detective identifies that one occurred or is occurring',
          'They are identical',
          'Detective is always a firewall',
          'Preventive only exists in the cloud'
        ],
        correctIndex: 0,
        explanation:
            'Preventive controls try to block events, while detective controls such as logging and IDS alert on them.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A question asks what to do FIRST after confirming ransomware on a workstation. Which answer matches standard incident response?',
        options: [
          'Pay the ransom',
          'Isolate the system from the network to contain the incident',
          'Reinstall the OS immediately',
          'Email all staff the details'
        ],
        correctIndex: 1,
        explanation:
            'Containment is the first priority to stop the spread, followed by investigation, eradication, and recovery.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which of the following uses the SAME key for both encryption and decryption?',
        options: ['RSA', 'AES', 'ECC', 'Diffie-Hellman public key'],
        correctIndex: 1,
        explanation:
            'AES is a symmetric algorithm. RSA and ECC are asymmetric, using key pairs.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which port is used by default for secure remote shell access?',
        options: ['23', '22', '80', '3389'],
        correctIndex: 1,
        explanation:
            'SSH uses TCP port 22. Telnet uses 23, HTTP uses 80, and RDP uses 3389.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Exam question: A company wants to ensure that employees cannot deny having approved a purchase order. Which concept does this describe?',
        options: [
          'Confidentiality',
          'Availability',
          'Non-repudiation',
          'Obfuscation'
        ],
        correctIndex: 2,
        explanation:
            'Non-repudiation, often provided by digital signatures and logging, prevents a person from denying an action they performed.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Exam question: A web application is vulnerable because user input is placed directly into database queries. Which control is the MOST effective fix?',
        options: [
          'Longer passwords',
          'Parameterised queries (prepared statements) with input validation',
          'A bigger firewall',
          'Hiding error messages only'
        ],
        correctIndex: 1,
        explanation:
            'Parameterised queries separate code from data and directly remove the cause of SQL injection.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Exam question: An organisation accepts the risk of a low-impact issue because the fix costs more than the potential loss. Which risk response is this?',
        options: ['Avoid', 'Transfer', 'Mitigate', 'Accept'],
        correctIndex: 3,
        explanation:
            'Accepting a risk means consciously deciding to live with it, ideally documented and approved by the risk owner.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Domain Map, Flashcards, and a Timed Practice Test',
      goal:
          'Map your knowledge to exam domains, create revision material, and take a timed practice test with analysis.',
      steps: [
        'Download the official exam objectives for your chosen foundation certification and list every domain',
        'Map each objective to a lesson or project in this path, and mark your confidence 1 to 5',
        'Create at least 60 flashcards covering ports, control types, crypto, attack types, frameworks, and incident phases',
        'Write 20 of your own exam-style questions (BEST, FIRST, MOST) with explanations of why each wrong option is wrong',
        'Take a full-length timed practice test from a reputable source and record your score by domain',
        'Write an error log of every wrong answer, the reason you missed it, and a plan for each weak domain',
      ],
      expectedOutput:
          'Exam Readiness Report\n\nObjectives mapped: 5 domains, 52 objectives; confidence average 3.6\nFlashcards: 64 | Own questions: 20 with explanations\n\nPractice test: 72 percent (domain 4: 80, domain 2: 70, domain 5: 58)\nError log: 18 items; main causes: misreading FIRST vs BEST, weak GRC terminology\nPlan: 2 weeks on GRC, 30 questions per day, retest ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 4
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l10_resume_portfolio',
    topicTitle: 'Resume, LinkedIn & GitHub Portfolio for Security Roles',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 36,
    totalXp: 205,
    emoji: '📄',
    intro:
        'Your resume gets you the interview, and your portfolio gives the interviewer something concrete to ask about. Security hiring managers read many applications and look for clear, honest evidence of skills. This lesson shows how to present yourself clearly and credibly.',
    concepts: [
      ConceptLesson(
        title: 'Writing a Strong Security Resume',
        definition:
            'A good resume is a concise, honest, easy-to-scan document that shows relevant skills, projects, and results for the target role. One page is usually enough for early-career candidates.',
        analogy:
            'A resume is a trailer, not the whole film. It should make the viewer want to see more, not tell the entire story.',
        example:
            'Structure:\n\nHeader: name, city, email, phone, LinkedIn, GitHub\nSummary: 2 to 3 lines targeting the role\nSkills: grouped (Security tools, Platforms, Languages, Frameworks)\nProjects: 3 to 5 strongest, each with outcomes\nExperience and internships\nEducation and certifications\nAchievements: CTFs, community, publications\n\nWriting bullets (action + what + result):\n  Weak: Worked on SIEM\n  Strong: Built a Wazuh SIEM lab with 8 detections mapped to MITRE ATT&CK and reduced simulated time-to-detect from 22 to 3 minutes\n\nKeep it ATS-friendly: simple formatting, standard headings, keywords from the job description.',
        keyTakeaway:
            'Quantify outcomes where you honestly can, and use the language of the job posting. Never claim skills you could not explain in an interview.',
      ),
      ConceptLesson(
        title: 'Turning Projects Into Resume Evidence',
        definition:
            'Your capstone and level projects are your experience. Describing them with the context, actions, tools, and results makes them as persuasive as work experience.',
        analogy:
            'A chef without restaurant experience shows photos and recipes of dishes they have made. Your projects are your dishes.',
        example:
            'Project description template:\n\nTitle and one-line goal\nTools: Wazuh, Sigma, Python, Terraform, ZAP\nWhat you did: 3 bullets with verbs such as built, automated, detected, hardened, analysed\nResult: a measurable outcome\nLink: the repository or write-up\n\nExample:\n  Cloud Security Capstone | Terraform, AWS, Checkov, GuardDuty\n  Built a three-tier environment as code with least-privilege IAM and encrypted storage\n  Added CI scanning that blocked insecure changes and reduced posture findings from 41 to 7\n  Wrote an incident playbook for compromised keys and tested five detections\n\nBe clear that projects were done in a lab or learning account.',
        keyTakeaway:
            'Each project should answer: what problem, what you did, which tools, and what changed. Honest labels build trust.',
      ),
      ConceptLesson(
        title: 'GitHub and Portfolio Hygiene',
        definition:
            'Your public profile is part of your application. A clean, well-documented GitHub with a small number of strong repositories beats dozens of abandoned ones.',
        analogy:
            'Employers will look at your shopfront. Keep it tidy, safe, and well signposted.',
        example:
            'Checklist:\n\nPin your 4 to 6 best repositories\nEach repo: clear README, purpose, setup, screenshots, and a safety statement for lab work\nNo secrets: run gitleaks across all repositories and history before sharing\nNo real data, real IP addresses, or details of live systems\nNo malware samples or weaponised exploit code\nUseful extras: blog posts, CTF write-ups (following the rules), and short demo videos\nA profile README with a short intro and links\nConsistent small commits show steady activity\n\nIndicators employers like: documentation quality, tests, and reproducible labs.',
        keyTakeaway:
            'Review your own portfolio as an attacker and as a recruiter. Remove anything sensitive, and make the best work easy to find.',
      ),
      ConceptLesson(
        title: 'LinkedIn, Job Portals, and Professional Presence',
        definition:
            'Recruiters search LinkedIn and job portals using keywords. A complete profile with clear headline, summary, and activity makes you discoverable and credible.',
        analogy:
            'It is your listing in the professional phonebook. If your entry is incomplete or unclear, people cannot find or understand you.',
        example:
            'LinkedIn tips:\n\nHeadline: your target role and focus, for example Aspiring SOC Analyst | SIEM, Detection Engineering, Incident Response\nAbout: 4 to 6 lines on interests, strengths, and what you are looking for\nFeatured: link to your best project and write-up\nSkills: align with job postings\nShare short learning posts and project updates occasionally\nConnect with security professionals respectfully, with a personal note\n\nIndian job portals and sources: LinkedIn Jobs, Naukri, Instahyre, Foundit, Wellfound for startups, and company career pages.\n\nSafety: do not share ID numbers, full date of birth, or home address publicly, and be alert to fake recruiters.',
        keyTakeaway:
            'A focused headline and a featured project do more for discoverability than a long list of skills.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which resume bullet is strongest?',
        options: [
          'Worked on security tools',
          'Built a lab SIEM with 8 ATT&CK-mapped detections and cut simulated time-to-detect from 22 to 3 minutes',
          'Responsible for monitoring',
          'Did many projects'
        ],
        correctIndex: 1,
        explanation:
            'It states the action, tools, and a measurable result, which is specific and credible.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What must you check before making a security portfolio repository public?',
        options: [
          'That it has a fancy logo',
          'That it contains no secrets, real data, or sensitive identifiers, by scanning the code and history',
          'That it has as many files as possible',
          'That it uses one colour'
        ],
        correctIndex: 1,
        explanation:
            'Leaked secrets in a security portfolio would be a serious red flag for any employer.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why use keywords from the job description in your resume?',
        options: [
          'To trick people',
          'Applicant tracking systems and recruiters search for them, and they show alignment with the role',
          'To make it longer',
          'It is required by law'
        ],
        correctIndex: 1,
        explanation:
            'Matching genuine skills to the language of the posting helps both automated filters and human readers.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You list "expert in penetration testing" on your resume after finishing one lab. What is the problem?',
        options: [
          'None',
          'It overstates your level and will be exposed in interviews; describe the actual lab work and your learning honestly',
          'It is too short',
          'It uses the wrong colour'
        ],
        correctIndex: 1,
        explanation:
            'Inflated claims damage credibility. Honest, specific descriptions of what you did are more persuasive.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A recruiter message asks for your Aadhaar number and a registration fee before an interview. What should you do?',
        options: [
          'Send them',
          'Do not share, verify the company and recruiter through official channels, and report the message as a likely scam',
          'Send only the fee',
          'Forward it to friends'
        ],
        correctIndex: 1,
        explanation:
            'Genuine employers do not charge candidates, and ID numbers should only be shared at a late, verified stage.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build Your Application Kit',
      goal:
          'Produce a one-page resume, a clean GitHub portfolio, and an optimised LinkedIn profile for your target role.',
      steps: [
        'Write a one-page ATS-friendly resume targeting your chosen role, using strong bullets for your 3 to 5 best projects',
        'Run a secrets scan and a manual review on all your public repositories and clean them up',
        'Pin 4 to 6 best repositories with strong READMEs, safety statements, and screenshots',
        'Update your LinkedIn headline, About section, featured items, and skills',
        'Ask two peers or mentors to review your resume and portfolio, and note their feedback',
        'Create a short list of 20 target roles and tailor your resume for the top 5 with relevant keywords',
      ],
      expectedOutput:
          'Application Kit\n\nResume v1: 1 page, 4 projects with measurable results\nGitHub: 5 pinned repos, README + safety statement, gitleaks clean ✓\nLinkedIn: headline Aspiring SOC Analyst | SIEM | Detection Engineering; featured: Mini SOC lab write-up\n\nPeer feedback: 2 reviews; changes made (shorter summary, clearer metrics)\nTailored versions for 5 roles ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 5
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l10_tech_interview_fundamentals',
    topicTitle: 'Technical Interview Prep I: Fundamentals Questions',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 42,
    totalXp: 220,
    emoji: '🎤',
    intro:
        'Technical interviews begin with fundamentals: can you explain core ideas clearly and accurately? Interviewers care about structured thinking as much as the right answer. This lesson gives you a method for answering and practises the most common questions across networking, systems, cryptography, and web security.',
    concepts: [
      ConceptLesson(
        title: 'A Method for Answering Technical Questions',
        definition:
            'A reliable structure keeps your answers clear: define the concept simply, explain how it works, give an example, mention security implications, and state limits or trade-offs.',
        analogy:
            'It is like explaining a route to a stranger: say where you are going, give the main steps, mention landmarks, and warn about tricky turns.',
        example:
            'Answer structure (the DEEP method):\n\nD: Define it in one sentence\nE: Explain how it works in a few steps\nE: Example from real life or your lab\nP: Pitfalls or security implications\n\nTips:\n  Think aloud when unsure, and say what you do know\n  Ask clarifying questions\n  It is acceptable to say you do not know, then explain how you would find out\n  Avoid buzzwords you cannot explain\n  Be honest about your level',
        keyTakeaway:
            'Clarity and honesty beat bluffing. Interviewers can tell, and they value candidates who reason carefully.',
      ),
      ConceptLesson(
        title: 'Core Questions: Networking and Operating Systems',
        definition:
            'Networking and OS questions test your understanding of how systems communicate and how privilege and permissions work. They are asked for almost every security role.',
        analogy:
            'These are the grammar and vocabulary of the field. Fluency here makes everything else easier.',
        example:
            'Frequently asked questions and key points:\n\nWhat happens when you type a URL in a browser? DNS resolution, TCP handshake, TLS handshake, HTTP request and response, rendering. Mention caching and security checkpoints.\nTCP vs UDP? Reliable and connection-oriented vs fast and connectionless; examples; SYN flood vs UDP amplification.\nExplain the TCP three-way handshake. SYN, SYN-ACK, ACK.\nWhat is the difference between a switch, router, and firewall? Layers 2, 3, and policy enforcement.\nWhat is ARP spoofing and how do you defend? Local network attack; DAI, port security, encryption.\nHow does Linux file permission work? Owner, group, others, rwx and octal; SUID risks.\nWhat is privilege escalation? Vertical vs horizontal; least privilege and patching.\nHow would you harden a new Linux server? Updates, users and sudo, SSH keys, firewall, services, logging, auditing.',
        keyTakeaway:
            'Practise the URL-to-page walkthrough until you can do it at three levels of detail. It is a favourite interview question.',
      ),
      ConceptLesson(
        title: 'Core Questions: Cryptography and Identity',
        definition:
            'Interviewers check that you understand which cryptographic tool solves which problem, and how authentication and authorisation differ.',
        analogy:
            'It is knowing which tool in the toolbox suits which job, not memorising every algorithm.',
        example:
            'Questions and key points:\n\nSymmetric vs asymmetric encryption? Same key vs key pair; speed and key distribution; hybrid use in TLS.\nHashing vs encryption? One-way fingerprint vs reversible with key; password storage uses salted slow hashes.\nHow does HTTPS work? Certificate validation, key exchange, symmetric session encryption.\nWhat is a digital signature? Hash signed with a private key to prove authenticity and integrity.\nAuthentication vs authorisation? Who you are vs what you may do.\nWhat is MFA and which factors exist? Know, have, are.\nHow does SSO work at a high level? Identity provider issues a token or assertion to service providers (SAML, OIDC).\nHow should passwords be stored? Argon2, bcrypt, or scrypt with unique salts.',
        keyTakeaway:
            'When answering, tie the concept to the problem it solves: confidentiality, integrity, authenticity, or non-repudiation.',
      ),
      ConceptLesson(
        title: 'Core Questions: Web Security and Common Attacks',
        definition:
            'Web security questions probe whether you understand how vulnerabilities arise and how they are prevented, not just what they are called.',
        analogy:
            'An interviewer wants to hear that you can find the root cause and recommend the fix, like a doctor, not just name the disease.',
        example:
            'Questions and key points:\n\nSQL injection: cause is string-built queries; fix with parameterised queries, least privilege, validation.\nXSS: types (reflected, stored, DOM); fix with output encoding, CSP, HttpOnly.\nCSRF: forged requests using cookies; fix with tokens, SameSite, re-authentication.\nXSS vs CSRF: script runs in victim browser vs forged action using victim session.\nIDOR and broken access control: missing server-side checks; fix with object-level authorisation.\nWhat is SSRF? Server tricked into fetching internal resources; fix with allow-lists and network egress controls.\nWhat is the same-origin policy and CORS?\nWhat are the OWASP Top 10? Know several categories with an example each.\nHow do you secure an API? Authentication, authorisation, rate limits, schemas, logging.',
        keyTakeaway:
            'For any vulnerability, always give three things: how it happens, how you would find it, and how you would fix it.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'A question stumps you in an interview. What is the best approach?',
        options: [
          'Invent an answer confidently',
          'Say what you do know, think aloud, and explain how you would find or verify the rest, being honest about the gap',
          'Stay silent',
          'Change the subject'
        ],
        correctIndex: 1,
        explanation:
            'Honest reasoning shows problem-solving ability and integrity, both valued in security roles.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the key difference between XSS and CSRF?',
        options: [
          'They are identical',
          'XSS runs attacker script in the victim browser on a trusted site, while CSRF tricks the browser into sending an unwanted authenticated request',
          'XSS affects only servers',
          'CSRF only affects databases'
        ],
        correctIndex: 1,
        explanation:
            'XSS is about injecting script, and CSRF is about forging requests that rely on automatically sent cookies.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which statement about password storage is correct?',
        options: [
          'Store passwords in plain text for convenience',
          'Store salted hashes created with a slow algorithm such as Argon2, bcrypt, or scrypt',
          'Encrypt all passwords with one shared key and store the key beside them',
          'Use MD5 with no salt'
        ],
        correctIndex: 1,
        explanation:
            'Salted, slow hashes make cracking stolen databases expensive. Fast hashes and plain text are unsafe.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Interviewer: "Explain what happens when you type https://example.com in a browser." Which outline is best?',
        options: [
          'The page appears',
          'DNS lookup, TCP handshake, TLS handshake with certificate validation, HTTP request, server response, rendering, with notes on caching and security checks at each step',
          'Only the TLS handshake',
          'The router sends a letter'
        ],
        correctIndex: 1,
        explanation:
            'A layered, ordered walkthrough that mentions security checkpoints shows both knowledge and structure.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Interviewer: "How would you prevent SQL injection?" Which answer is strongest?',
        options: [
          'Block the quote character',
          'Use parameterised queries, validate input with allow-lists, give the database account least privilege, hide detailed errors, and test with scanners and code review',
          'Use a longer password',
          'Hope for the best'
        ],
        correctIndex: 1,
        explanation:
            'The strongest answer names the primary fix and supporting layers, showing defence in depth.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Fundamentals Question Bank and Mock Round',
      goal:
          'Build your own answer bank for 40 core questions and practise answering them aloud.',
      steps: [
        'Write 40 core interview questions across networking, OS, cryptography, identity, and web security',
        'Write a model answer for each using the DEEP structure, in your own words, with an example from your labs',
        'Record yourself answering 15 of them aloud (audio or video) and review for clarity, pace, and filler words',
        'Ask a friend or mentor to ask you 10 questions in random order and give feedback',
        'Mark the questions you answered weakly and revisit the matching lesson or lab',
        'Create a one-page cheat sheet of diagrams: URL journey, TLS handshake, TCP handshake, OWASP Top 10 with fixes',
      ],
      expectedOutput:
          'Question Bank\n\n40 questions with DEEP answers ✓\nRecordings: 15 reviewed; reduced filler words; improved structure\nMock round: 10 questions with a peer; weak: Kerberos, CORS, SSRF\nRevisited Level 3, Level 6 lessons ✓\n\nCheat sheet with 4 diagrams ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 6
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l10_tech_interview_scenarios',
    topicTitle: 'Technical Interview Prep II: Scenarios, Labs & Take-Homes',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 46,
    totalXp: 230,
    emoji: '🧪',
    intro:
        'After fundamentals, interviews move to scenarios: "an alert fires, what do you do?", "design a secure login", or a hands-on lab. These test judgement, process, and communication under uncertainty. This lesson gives you frameworks for each type and plenty of practice scenarios.',
    concepts: [
      ConceptLesson(
        title: 'Incident and Alert Scenarios',
        definition:
            'Scenario questions describe an event and ask how you would respond. The interviewer is looking for a calm, structured approach: understand, scope, contain, investigate, communicate, and learn.',
        analogy:
            'It is like a paramedic who follows the same steps at every emergency and states them clearly aloud while working.',
        example:
            'Framework (the TRIAGE-IR flow):\n\n1. Clarify: ask what, when, where, which systems and users, and what evidence exists\n2. Assess severity and business impact\n3. Contain if needed (isolate host, disable account) while preserving evidence\n4. Investigate: logs, EDR, network, and timeline\n5. Scope: other hosts, accounts, and data\n6. Eradicate and recover\n7. Communicate: who must be told and when\n8. Learn: root cause, detections, and fixes\n\nSample scenario: "A user clicked a link in a suspicious email and entered credentials."\n  Reset credentials and revoke sessions, review sign-in and mailbox rules, find other recipients, block indicators, check for follow-on activity, report, and improve awareness.',
        keyTakeaway:
            'State your assumptions and ask clarifying questions. A structured approach matters more than naming a specific tool.',
      ),
      ConceptLesson(
        title: 'Design and Architecture Scenarios',
        definition:
            'Design questions ask you to build a secure system on a whiteboard or document: for example a login system, a cloud architecture, or a segmented network. Interviewers watch how you think about threats, trade-offs, and priorities.',
        analogy:
            'An architect explains the plan, the risks, and the reasons for each choice, not just the final drawing.',
        example:
            'Approach:\n\n1. Clarify requirements and constraints: users, data sensitivity, scale, compliance\n2. Draw the main components and data flows, and mark trust boundaries\n3. Identify key threats (STRIDE) and attackers\n4. Choose controls: identity, encryption, segmentation, logging, rate limiting\n5. Discuss trade-offs: usability, cost, performance\n6. Describe how you would monitor and respond\n7. Mention testing and review\n\nExample: design a secure password reset\n  Single-use random tokens with short expiry, generic responses to avoid enumeration, rate limiting, notification to the user, invalidate sessions after reset, logging and alerts.',
        keyTakeaway:
            'Think aloud about threats before controls. Explaining why you chose something is more impressive than listing technologies.',
      ),
      ConceptLesson(
        title: 'Hands-On Labs and Take-Home Assignments',
        definition:
            'Many employers use practical exercises: log analysis tasks, CTF-style challenges, vulnerability assessment of a test app, or a take-home report. They test real skill and communication.',
        analogy:
            'A cooking test in the kitchen shows far more than describing recipes. Show your process as well as your result.',
        example:
            'Tips for practical exercises:\n\nRead the instructions fully and note scope, time, and deliverables\nManage time: allocate portions and leave time to write up\nDocument as you work: commands, evidence, and reasoning\nFor reports: executive summary, findings, evidence, risk, and remediation\nStay within the rules and scope of the exercise\nIf you cannot finish, explain what you would do next\nFor log analysis tasks: state hypotheses and verify them with queries\nFor take-homes: keep the solution tidy, with README, tests, and clear structure\n\nPractise with: blue team labs, SIEM exercises, CyberDefenders, TryHackMe SOC paths, and your own capstones.',
        keyTakeaway:
            'Write up your reasoning, not only your answer. Many candidates lose points by giving results without explanation.',
      ),
      ConceptLesson(
        title: 'Communicating Risk and Handling Pushback in Interviews',
        definition:
            'Interviewers often test how you communicate with non-technical people, and how you handle disagreement or pressure. Clear, calm, business-oriented answers stand out.',
        analogy:
            'A translator who converts technical language into decisions gives leaders what they need.',
        example:
            'Practice prompts:\n\n"Explain ransomware to a company director." Use plain language, impact, and the three most important protections.\n"The business wants to launch tomorrow, but you found a high-risk issue." Offer options: quick mitigation, phased fix, written risk acceptance by the owner.\n"A senior engineer disagrees with your recommendation." Listen, ask for their reasoning, share evidence, and look for the safest workable compromise.\n"You made a mistake that caused downtime." Own it, explain what you did to fix it, and describe what you changed to prevent repeats.\n\nPrinciples: be factual, be calm, focus on risk and options, and remain respectful.',
        keyTakeaway:
            'Security recommends and the business decides. Showing you can give options with clear risk trade-offs signals senior-level thinking.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'An interviewer describes a possible compromise with little detail. What should you do first?',
        options: [
          'Start deleting files',
          'Ask clarifying questions about what happened, which systems and users are affected, and what evidence exists',
          'Recommend buying a new tool',
          'Say there is no problem'
        ],
        correctIndex: 1,
        explanation:
            'Clarifying questions show a structured approach and prevent wrong assumptions.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'In a design question about a secure login, which step should come BEFORE choosing controls?',
        options: [
          'Pick a vendor',
          'Clarify requirements and identify the main threats and trust boundaries',
          'Write the code',
          'Plan the celebration'
        ],
        correctIndex: 1,
        explanation:
            'Controls should respond to identified threats and requirements, not the other way round.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'In a take-home exercise, what makes your submission stand out?',
        options: [
          'Only a final answer',
          'Clear documentation of your reasoning, evidence, and a well-structured report',
          'A very long file with no structure',
          'Ignoring the instructions'
        ],
        correctIndex: 1,
        explanation:
            'Showing process and clear communication demonstrates skills that employers value in daily work.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Scenario: Your SIEM shows an admin account logged in from a new country at 03:00, then created a new user and ran a scheduled task. Which sequence best reflects a good response?',
        options: [
          'Ignore, admins travel',
          'Treat as likely compromise: disable the account and revoke sessions, isolate affected hosts, preserve evidence, review all actions, scope other systems and accounts, notify the incident lead, and fix the root cause',
          'Delete the new user only',
          'Wait until morning'
        ],
        correctIndex: 1,
        explanation:
            'The combination of unusual login, new account, and persistence suggests an active intruder, so contain, investigate, and escalate.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Scenario: A manager asks you to explain why a 20 percent increase in the security budget is needed. Which approach is best?',
        options: [
          'Say it is required',
          'Present top risks in business terms with likelihood, impact, options, cost of controls, and the risk reduction they provide',
          'Use acronyms only',
          'Refuse to answer'
        ],
        correctIndex: 1,
        explanation:
            'Linking spend to business risk reduction is how security leaders gain support.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Scenario Playbook and Practical Mock Assessment',
      goal:
          'Prepare written answers for 10 scenarios and complete a timed practical exercise with a short report.',
      steps: [
        'Write 10 scenario questions: 4 incident or alert scenarios, 3 design scenarios, 2 cloud scenarios, and 1 business communication scenario',
        'For each, write a structured answer using the frameworks in this lesson, with assumptions and trade-offs',
        'Practise two of them aloud with a friend who interrupts with follow-up questions',
        'Do a timed 2-hour practical: analyse a sample log file or an intentionally vulnerable lab app and write a short report with an executive summary and findings',
        'Review your report against a checklist: clarity, evidence, risk rating, and remediation',
        'Collect feedback and write 5 improvements to make before real interviews',
      ],
      expectedOutput:
          'Scenario Playbook\n\n10 scenarios answered: phishing credential entry, ransomware on file server, suspicious admin login, public bucket, secure password reset design, three-tier cloud design, vendor breach, budget justification...\n\nPractical (2 h): log analysis report with 5 findings, timeline, and recommendations\nChecklist review: improved executive summary and evidence screenshots\n\nFeedback: 5 improvements listed ✓',
      xpReward: 60,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 7
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l10_behavioural_hr',
    topicTitle: 'Behavioural Interviews, HR Rounds & Offer Negotiation',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 36,
    totalXp: 205,
    emoji: '🤝',
    intro:
        'Technical skill gets you through the technical rounds, but behavioural and HR rounds decide whether the team trusts you. Security professionals handle sensitive information and pressure, so employers look closely at integrity, communication, and judgement. This lesson prepares you for those conversations and for evaluating an offer.',
    concepts: [
      ConceptLesson(
        title: 'The STAR Method for Behavioural Questions',
        definition:
            'Behavioural questions ask for real examples from your past: "Tell me about a time when...". The STAR method structures your answer into Situation, Task, Action, and Result.',
        analogy:
            'It is telling a short story with a clear beginning, middle, and end, so the listener understands exactly what you did and why it mattered.',
        example:
            'STAR:\n\nSituation: set the context briefly\nTask: your responsibility or goal\nAction: the specific steps you took (use I, not only we)\nResult: the outcome, ideally measurable, and what you learned\n\nExample prompt: "Tell me about a time you solved a hard technical problem."\n  S: My lab SIEM was missing logs from the Windows VM.\n  T: I needed reliable data for detections.\n  A: I checked agent status, firewall rules, and time sync, found a blocked port, fixed it, and added an alert for silent log sources.\n  R: Logs became complete, and I now detect missing sources within 10 minutes.\n\nPrepare 6 to 8 stories from projects, studies, teamwork, and challenges that you can adapt.',
        keyTakeaway:
            'Prepare stories in advance. The same story can answer questions about problem-solving, learning, initiative, and teamwork.',
      ),
      ConceptLesson(
        title: 'Ethics, Integrity, and Judgement Questions',
        definition:
            'Security roles involve privileged access and confidential information, so interviewers ask how you handle ethical dilemmas. They are looking for honesty, discretion, and respect for rules.',
        analogy:
            'A bank hires tellers not only for speed but for trustworthiness, since they handle other people money.',
        example:
            'Common questions and a good approach:\n\n"You discover a colleague is looking at records they should not access. What do you do?" Verify facts calmly, follow the reporting process (manager, security, or HR), and do not confront or gossip.\n"You find a vulnerability on a site outside your scope." Stop, do not exploit, and report it responsibly.\n"A senior person asks you to bypass a control to meet a deadline." Explain the risk, offer a safe alternative, and escalate for documented approval if needed.\n"You made an error that exposed data." Report immediately, contain, be transparent, and help fix it.\n\nValues to show: honesty, confidentiality, accountability, and respect for authorisation and privacy.',
        keyTakeaway:
            'In ethics questions the right answer is almost always: act within authority, be transparent, protect people and data, and follow the process.',
      ),
      ConceptLesson(
        title: 'Common HR Questions and Your Own Questions',
        definition:
            'HR rounds assess motivation, communication, and fit. Prepare concise, honest answers, and bring thoughtful questions of your own to evaluate the employer in return.',
        analogy:
            'An interview is a two-way conversation. You are also deciding whether this is a good place to learn and grow.',
        example:
            'Typical questions:\n\n"Tell me about yourself": a 60 to 90 second summary: background, what you built, why this role\n"Why security?" and "Why this company?": specific, honest reasons\n"What are your strengths and weaknesses?": real examples and how you are improving\n"Where do you see yourself in 3 to 5 years?"\n"Are you comfortable with shifts or on-call?": answer honestly\n"Do you have any questions?": always ask\n\nGood questions to ask:\n  What does a typical day or week look like in this role?\n  How is the team structured and who would I learn from?\n  What tools and training are provided? Is certification support available?\n  How are on-call and shifts organised?\n  How is success measured in the first 90 days?',
        keyTakeaway:
            'Questions about learning, mentoring, and expectations signal maturity, and they help you spot red flags.',
      ),
      ConceptLesson(
        title: 'Evaluating and Negotiating an Offer',
        definition:
            'An offer includes more than salary: role, growth, learning, schedule, benefits, and the terms of employment. Evaluating it carefully and negotiating respectfully is part of a professional career.',
        analogy:
            'Choosing a first job is like choosing a training programme as well as a paycheque. The skills and mentors you gain shape the next ten years.',
        example:
            'What to review (India context):\n\nCTC breakup: fixed pay, variable pay, bonuses, allowances, provident fund, gratuity, insurance, and what is guaranteed\nProbation period and confirmation terms\nNotice period and any bond or service agreement clauses (be careful with training bonds)\nJoining date, location, and remote or hybrid policy\nShift and on-call requirements\nLearning budget, certification support, and growth path\nBackground verification process\n\nNegotiation tips:\n  Research typical ranges from reliable sources and recent offers\n  Be polite, evidence-based, and flexible, and negotiate the whole package\n  Get the final offer in writing before resigning from a current job\n  Never accept or reject based on a single number only\n\nProtect yourself: do not pay fees, and verify the offer through the official company channel.',
        keyTakeaway:
            'Read every clause, especially bonds and notice terms. A role with strong mentoring can be worth more than a slightly higher salary.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What do the letters in STAR stand for?',
        options: [
          'Skill, Tool, Action, Review',
          'Situation, Task, Action, Result',
          'Start, Test, Adapt, Repeat',
          'Security, Threat, Alert, Response'
        ],
        correctIndex: 1,
        explanation:
            'STAR structures an example into context, responsibility, your actions, and the outcome.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A senior manager asks you to disable a security control to meet a deadline. What is the most professional response?',
        options: [
          'Silently comply',
          'Explain the risk, propose a safe alternative or temporary mitigation, and request documented approval from the risk owner if the exception is necessary',
          'Refuse and leave',
          'Disable it and hide it'
        ],
        correctIndex: 1,
        explanation:
            'Transparent risk communication and formal acceptance keep both the business and you protected.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should you read the notice period and bond clauses in an offer carefully?',
        options: [
          'They are decorative',
          'They can create financial or legal obligations that affect your freedom to leave later',
          'They set your salary',
          'They are never enforced'
        ],
        correctIndex: 1,
        explanation:
            'Bonds and long notice periods can restrict future moves, so understand them before signing.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are asked: "Tell me about a time you failed." Which answer is best?',
        options: [
          'I never fail',
          'A real, modest example using STAR: what went wrong, your ownership of it, how you fixed it, and what you changed afterwards',
          'Blame a teammate',
          'Refuse to answer'
        ],
        correctIndex: 1,
        explanation:
            'Owning a real mistake and showing learning builds trust, especially in security roles.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You receive an offer by email from an address on a free mail service, asking you to pay a refundable security deposit for equipment. What should you do?',
        options: [
          'Pay quickly',
          'Do not pay; verify the company and recruiter through official channels, and report the offer as likely fraud',
          'Share your bank PIN',
          'Forward it to friends'
        ],
        correctIndex: 1,
        explanation:
            'Real employers do not ask candidates for deposits. Verify and protect yourself from fraud.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Behavioural Story Bank and Offer Evaluation Sheet',
      goal:
          'Prepare your STAR stories, your self-introduction, and a framework for comparing job offers.',
      steps: [
        'Write 8 STAR stories from your projects and studies covering problem-solving, teamwork, failure, learning, initiative, conflict, pressure, and ethics',
        'Write and rehearse a 60 to 90 second "tell me about yourself" for your target role',
        'Write answers to 10 common HR questions and 5 ethics questions',
        'List 10 questions you would ask an employer',
        'Create an offer evaluation sheet scoring role, learning, mentoring, pay and benefits, schedule, location, and risks',
        'Do a mock interview with a friend, record it, and note 3 improvements',
      ],
      expectedOutput:
          'Interview Prep Pack\n\nSTAR bank: 8 stories (SIEM missing logs, team purple exercise, failed exam attempt, ...)\nIntro pitch: 75 seconds ✓\nHR answers: 10 | Ethics answers: 5 | Questions to ask: 10\n\nOffer sheet: weighted scoring (learning 30 percent, mentoring 20 percent, pay 20 percent, schedule 15 percent, location 15 percent)\nMock interview feedback: slow down, give more metrics, ask better questions ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 8
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l10_job_search_networking',
    topicTitle: 'Job Search Strategy, Networking & Avoiding Scams',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 34,
    totalXp: 205,
    emoji: '🔎',
    intro:
        'A good job search is a project: targeted, organised, and persistent. Many security roles are filled through referrals and community connections, not only job portals. This lesson builds a search strategy, shows how to network respectfully, and keeps you safe from the scams that target job seekers.',
    concepts: [
      ConceptLesson(
        title: 'Building a Targeted Search Plan',
        definition:
            'A search plan defines your target roles, employers, application volume, tracking system, and weekly routine. Quality applications to well-matched roles beat mass applying.',
        analogy:
            'It is like fishing with a map: you know where the fish are, what bait to use, and you keep a log of what worked.',
        example:
            'Plan elements:\n\nTargets: 2 roles, 3 locations or remote options, 30 to 50 target employers\nChannels: company career pages, LinkedIn, Naukri, Instahyre, Wellfound, campus placement cells, referrals, communities\nWeekly routine: 5 to 10 tailored applications, 5 networking messages, 1 hour of skill practice, 1 hour of interview practice\nTracking sheet: company, role, date, status, contact, follow-up date, notes\nTailoring: adjust the resume summary and project order to each posting\nFollow-up: polite message after 7 to 10 days\n\nExpect rejections and silence. Treat each as data and keep improving.',
        keyTakeaway:
            'Track everything in a sheet. Patterns in your results, such as which resume version gets replies, tell you what to adjust.',
      ),
      ConceptLesson(
        title: 'Employer Types and Where Beginners Succeed',
        definition:
            'Different employer types offer different learning environments. Knowing their strengths helps you choose well and sequence your career.',
        analogy:
            'A busy city hospital, a specialist clinic, and a research institute each teach different skills. All are valuable at different times.',
        example:
            'Employer types:\n\nMSSPs and MDR providers: high alert volume, fast learning, shift work, many clients\nIT services and consulting: structured training, varied projects, client-facing work, penetration testing and GRC teams\nProduct companies and startups: deeper ownership of one environment, smaller teams, faster growth\nGlobal capability centres: global standards and tooling, large teams\nBanks, fintech, and telecoms: strong regulation, mature programmes\nGovernment and public sector: stability, critical infrastructure focus, formal recruitment processes\n\nBeginner-friendly routes: internships, apprenticeships, graduate programmes, trainee schemes, and moving laterally from IT support, development, or DevOps.',
        keyTakeaway:
            'Your first role is a launchpad. Choose a place with good mentoring and exposure, then specialise as you learn what you enjoy.',
      ),
      ConceptLesson(
        title: 'Networking Without Awkwardness',
        definition:
            'Networking means building genuine professional relationships: learning from others, offering help, and being visible. Referrals often come from people who have seen your work or conversations.',
        analogy:
            'It is planting seeds, not asking for a favour at the first meeting. Helpful interactions grow into opportunities over time.',
        example:
            'Ways to network:\n\nAttend local security meetups, OWASP chapter events, null community sessions, and college or conference events\nJoin online communities and CTF teams\nShare short write-ups and project updates on LinkedIn\nComment thoughtfully on posts of practitioners\nContribute to open-source security tools\nSend short, specific messages\n\nMessage template:\n  Hello [Name], I am building skills in SOC and detection engineering and enjoyed your post on [topic]. I built a small Wazuh lab with ATT&CK-mapped detections and would value any advice on what to improve before applying to roles like yours. Thank you for your time.\n\nEtiquette:\n  Do not ask strangers for jobs in the first message\n  Respect their time and say thank you\n  Offer something back when you can',
        keyTakeaway:
            'Ask for advice, not jobs. People enjoy helping someone who has clearly done their homework.',
      ),
      ConceptLesson(
        title: 'Spotting and Avoiding Job and Recruitment Scams',
        definition:
            'Job seekers are targets for fraud: fake offers, advance fee demands, identity theft, and data harvesting. Security professionals should model the awareness they teach.',
        analogy:
            'A scam offer is bait on a hook. Recognising the hook is the best protection.',
        example:
            'Red flags:\n\nRequests for money for registration, training, equipment, uniforms, or a deposit\nOffers without any interview\nPersonal mail domains such as free email services instead of company email\nMessaging apps only, with urgency and pressure\nRequests for Aadhaar, PAN, bank PIN, OTPs, or photos of documents very early\nUnrealistic pay for little work\nPoor spelling and cloned company websites\nPayment to a personal account\n\nSafety steps:\n  Verify the company through its official website and a phone number you find yourself\n  Check the recruiter on LinkedIn and with the company HR\n  Never share OTPs or banking passwords\n  Share identity documents only after a verified offer and through official HR channels\n  Report fraud: in India call 1930 or report at cybercrime.gov.in, and report fake profiles to the platform',
        keyTakeaway:
            'No legitimate employer charges you to hire you. When in doubt, stop and verify independently.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which networking message is most likely to get a helpful reply?',
        options: [
          'Please give me a job',
          'A short, specific message that shows you did your homework, mentions your project, and asks for advice',
          'A very long message with all your life story',
          'A message with no greeting'
        ],
        correctIndex: 1,
        explanation:
            'Specific, respectful requests for advice make it easy for the other person to help.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which is a clear red flag in a job offer?',
        options: [
          'A request for a resume',
          'A request for a registration fee or deposit before you start',
          'A scheduled interview with named interviewers',
          'A written offer letter from an official company email'
        ],
        correctIndex: 1,
        explanation:
            'Legitimate employers do not charge candidates, so fee requests are a classic scam sign.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why keep a job application tracking sheet?',
        options: [
          'To look busy',
          'To manage follow-ups and learn which approaches work best',
          'It is required by employers',
          'To increase salary'
        ],
        correctIndex: 1,
        explanation:
            'Tracking keeps your search organised and helps you improve using evidence.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A recruiter on a messaging app offers you a remote security analyst job with high pay, no interview, and asks you to send a photo of your ID and pay a small onboarding fee. What do you do?',
        options: [
          'Pay and send the photo',
          'Refuse, verify independently, report the profile and the message, and block the contact',
          'Ask a friend to pay the fee',
          'Forward the ID to others'
        ],
        correctIndex: 1,
        explanation:
            'Every element matches a typical scam. Stop, verify, report, and protect your documents.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'After 30 applications you have had no interview calls. What is the best analysis?',
        options: [
          'Give up',
          'Review your tracking data: tailor the resume to postings, improve project evidence, seek feedback, adjust target roles, and increase referrals',
          'Apply to 300 more with the same resume',
          'Stop learning'
        ],
        correctIndex: 1,
        explanation:
            'Silence is a signal to adjust your approach. Data-driven refinement improves results.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Job Search Launch Plan',
      goal:
          'Create and start a measurable 8-week job search plan, with networking and scam protection.',
      steps: [
        'Choose your target roles, locations, and 30 target employers, grouped by type',
        'Create a tracking sheet and weekly routine with numerical targets for applications, networking messages, and practice',
        'Write two networking message templates and send 5 personalised messages in the first week',
        'Attend one community event or online meetup and write a short summary of what you learned',
        'Create a personal "scam checklist" for job offers and share it with a friend or on your profile',
        'After 4 weeks, review your data and adjust the plan, writing down what changed',
      ],
      expectedOutput:
          'Job Search Plan\n\nTargets: SOC Analyst, Vulnerability Analyst; Bengaluru, Hyderabad, Pune, remote; 30 employers (MSSP 8, services 8, product 7, GCC 7)\n\nWeekly: 8 tailored applications, 5 messages, 2 practice sessions\nTracker: columns for status, follow-up date, notes ✓\n\nCommunity: attended a local security meetup, 3 new contacts\nScam checklist: 10 red flags ✓\n4-week review: tailored resume improved reply rate from 3 to 15 percent; added referral outreach ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 9
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l10_ethics_growth_first90',
    topicTitle: 'Professional Ethics, Lifelong Learning & Your First 90 Days',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 36,
    totalXp: 210,
    emoji: '🌱',
    intro:
        'Landing the role is the start of the journey. Security is a field of trust and constant change, so professional ethics and a habit of learning matter as much as any single skill. This lesson prepares you to behave well, keep growing, protect your wellbeing, and make a strong start in your first 90 days.',
    concepts: [
      ConceptLesson(
        title: 'Professional Codes of Ethics',
        definition:
            'Professional bodies publish codes of ethics that set expectations for security practitioners: act honestly, protect society and the public, provide competent service, and advance the profession.',
        analogy:
            'Doctors take an oath because their work affects people lives. Security professionals hold similar trust over data and systems.',
        example:
            'Common themes (for example ISC2 and ISACA codes):\n\nProtect society, the common good, and public trust\nAct honourably, honestly, justly, and legally\nProvide diligent and competent service to employers and clients\nAdvance and protect the profession\nMaintain confidentiality of information entrusted to you\nAvoid conflicts of interest and disclose them\nRespect privacy and intellectual property\nReport violations through proper channels\n\nIn practice:\n  Use your access only for authorised purposes\n  Never snoop on colleagues or customers\n  Keep client and employer information confidential after you leave',
        keyTakeaway:
            'Trust takes years to build and seconds to lose. Treat every piece of access as a responsibility.',
      ),
      ConceptLesson(
        title: 'Legal Responsibilities and Safe Conduct at Work',
        definition:
            'Security work touches law: unauthorised access offences, privacy duties, contracts, and intellectual property. Knowing the basics helps you stay safe and advise others.',
        analogy:
            'A pilot must know aviation rules as well as how to fly the plane.',
        example:
            'Key points:\n\nAlways work within written authorisation and scope\nFollow company policies and contracts, including confidentiality and acceptable use\nPrivacy laws (India DPDP Act 2023 and others) apply to the data you handle\nIncident reporting duties may apply, for example CERT-In directions in India, and they have strict timelines\nPreserve evidence properly in investigations\nDo not test or scan systems outside your authority, including your employer systems without approval\nBe careful with personal projects: do not use employer data, tools, or time without permission\nWhen unsure, ask your manager, legal, or compliance team\n\nThe law and requirements change, so check official sources and your organisation guidance.',
        keyTakeaway:
            'When a situation is unclear, pause and ask. Asking is a sign of professionalism, not weakness.',
      ),
      ConceptLesson(
        title: 'Staying Current and Building a Learning System',
        definition:
            'Threats, tools, and technologies change constantly. A sustainable learning routine keeps you relevant without causing burnout.',
        analogy:
            'Think of a regular fitness routine: small, consistent effort beats occasional extreme sessions.',
        example:
            'Learning system:\n\nWeekly: 2 to 4 hours of hands-on labs or projects\nDaily: 15 minutes of news from trusted sources (vendor blogs, CERT-In and CISA advisories, security newsletters, reputable podcasts)\nMonthly: read one in-depth report, such as an annual incident report from a reputable vendor\nQuarterly: learn one new tool or technique and write a short note about it\nYearly: review your goals, choose a certification or specialisation, and update your portfolio\n\nPractice resources: TryHackMe, Hack The Box, CyberDefenders, Blue Team Labs, PortSwigger Web Security Academy, cloud provider free tiers.\n\nKeep a learning journal. Teaching others, through blogs, talks, or mentoring, deepens your own understanding.',
        keyTakeaway:
            'Consistency beats intensity. A small weekly lab habit will take you further than occasional bursts.',
      ),
      ConceptLesson(
        title: 'Wellbeing, Burnout, and Your First 90 Days',
        definition:
            'Security work can be stressful, with alerts, incidents, and on-call duty. Looking after your wellbeing keeps you effective. A planned start in a new role helps you build trust and impact quickly.',
        analogy:
            'A marathon runner paces themselves and rests, and a new team member listens first before trying to change the route.',
        example:
            'Wellbeing practices:\n\nSet boundaries and take real breaks and leave\nTalk to your manager about workload and shift patterns\nUse blameless post-incident reviews to learn without guilt\nBuild a support network of peers and mentors\nSeek professional help if stress becomes overwhelming\n\nFirst 90 days plan:\n  Days 1 to 30: learn the environment, tools, people, processes, and expectations; complete training; take notes; ask many questions\n  Days 31 to 60: take on small tasks, handle alerts with supervision, improve documentation, and find a quick win\n  Days 61 to 90: own a small improvement, such as tuning a noisy rule, and share results; agree goals with your manager\n\nTips: find a mentor, deliver on small promises, communicate early about problems, and thank people who help you.',
        keyTakeaway:
            'Early reliability and curiosity build a strong reputation. Listen first, then improve one small thing and show the result.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'You notice you can technically read your colleague mailbox because of your admin rights. What is correct?',
        options: [
          'Read it out of curiosity',
          'Only access it when you have a legitimate, authorised business reason and approval, because privileged access must not be misused',
          'Share it with others',
          'Delete it'
        ],
        correctIndex: 1,
        explanation:
            'Having technical access is not the same as having authorisation. Misuse breaks trust and may be illegal.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the best way to stay current in a fast-changing field?',
        options: [
          'Study once a year in a long burst',
          'A steady routine of small daily reading and regular hands-on practice',
          'Avoid learning new things',
          'Rely only on social media rumours'
        ],
        correctIndex: 1,
        explanation:
            'Regular, manageable habits keep skills fresh and reduce the risk of burnout.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'In your first 30 days at a new job, what is the best priority?',
        options: [
          'Redesign the entire security programme',
          'Learn the environment, tools, people, and processes, and ask questions',
          'Criticise existing work publicly',
          'Avoid meeting anyone'
        ],
        correctIndex: 1,
        explanation:
            'Understanding the context first lets you make useful, well-informed improvements later.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You want to run a vulnerability scan on your employer network to practise for a certification. What should you do?',
        options: [
          'Run it quietly after hours',
          'Do not scan without written approval; use your home lab, or ask your manager whether an approved practice environment is available',
          'Scan and tell no one',
          'Use the CEO laptop'
        ],
        correctIndex: 1,
        explanation:
            'Scanning without approval is a policy breach and may be illegal, even with good intentions.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'After a stressful incident week you feel exhausted and irritable. What is a healthy response?',
        options: [
          'Ignore it and work more',
          'Take proper rest, talk to your manager about workload and recovery time, use the blameless review to learn, and seek support if the stress continues',
          'Quit immediately without thinking',
          'Blame your team'
        ],
        correctIndex: 1,
        explanation:
            'Sustainable performance depends on recovery and open communication about workload.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Professional Charter and 90-Day Plan',
      goal:
          'Write your personal code of conduct, learning system, and a 90-day plan for your first security role.',
      steps: [
        'Write a one-page personal professional code of conduct with at least 8 commitments',
        'Design your weekly learning system with specific hours, sources, labs, and a learning journal',
        'List your top 5 information sources and 3 communities you will follow or join',
        'Write a 90-day plan for a first SOC or security analyst role with goals for days 1 to 30, 31 to 60, and 61 to 90',
        'Write a wellbeing plan: boundaries, breaks, and who you will talk to when stressed',
        'Share the plan with a mentor or friend and ask for one piece of feedback',
      ],
      expectedOutput:
          'Professional Charter\n\nCode of conduct: authorisation first, confidentiality, honesty, privacy, report mistakes early, no snooping, respect scope, keep learning\n\nLearning system: 3 h labs/week, 15 min news/day, monthly report, quarterly new tool\n\n90-day plan:\n  1-30: learn tools, shadow shifts, document runbooks\n  31-60: handle alerts with review, fix 1 documentation gap\n  61-90: tune one noisy rule, present results\n\nWellbeing plan: no work messages after hours unless on-call, weekly walk, trusted peer ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 10
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l10_final_capstone',
    topicTitle: 'Final Capstone: Career Launch Package & Mock Interview Loop',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 75,
    totalXp: 320,
    emoji: '🎯',
    intro:
        'This is the final capstone of the Cyber Security Engineer path. You will assemble everything you have built, from fundamentals to cloud and real-world projects, into a complete career launch package: portfolio, resume, certification plan, interview readiness, and a 90-day action plan. Then you will test it in a full mock interview loop.',
    concepts: [
      ConceptLesson(
        title: 'Auditing Your Skills and Portfolio',
        definition:
            'Before applying, audit what you can actually do and what evidence you can show. A skills and portfolio audit reveals your strongest story and the last gaps to close.',
        analogy:
            'Before a big match, a team reviews its squad, strengths, and weak spots, then picks the best line-up.',
        example:
            'Audit steps:\n\nList skills across 10 areas: networking, OS and Linux, scripting, tools and vulnerability assessment, application security, SOC and detection, incident response, cloud, GRC and privacy, communication\nRate each 1 to 5 with evidence (project, lab, certificate)\nIdentify your 3 flagship projects and rewrite their READMEs for clarity\nCheck every repository for secrets and sensitive data\nIdentify 2 gaps to close in the next 30 days with a concrete task each\nMatch your skills to your target role requirements from the job postings analysis',
        keyTakeaway:
            'Know your strongest three stories and your biggest honest gap. Both will be asked about in interviews.',
      ),
      ConceptLesson(
        title: 'Assembling the Career Launch Package',
        definition:
            'The package gathers all career materials in one organised place so you can apply quickly and consistently with high quality.',
        analogy:
            'It is a ready-to-go travel bag: everything you need is packed and checked, so you can leave when the opportunity arrives.',
        example:
            'Contents:\n\nResume (master version and 3 tailored versions)\nLinkedIn profile updated\nGitHub portfolio with pinned repositories and READMEs\nOne-page portfolio summary (links, 3 flagship projects, metrics)\nCover letter template\nCertification plan and timeline\nSTAR story bank and self-introduction\nScenario playbook and question bank\nJob search tracker and networking templates\n90-day plan and professional charter\nReferences or mentors who agreed to vouch for you (ask permission first)',
        keyTakeaway:
            'Keep a single organised folder and a master resume. Quick, tidy tailoring helps you respond to opportunities within a day.',
      ),
      ConceptLesson(
        title: 'Running a Mock Interview Loop',
        definition:
            'A mock loop simulates a real interview day with several rounds: HR screen, technical fundamentals, scenarios and practical, and behavioural. Practising under realistic conditions reduces nerves and exposes weak spots.',
        analogy:
            'A full-dress rehearsal before opening night shows what needs fixing while there is still time.',
        example:
            'Loop design (about 3 hours, with friends, mentors, or peers as interviewers):\n\nRound 1: HR screen, 20 minutes: introduction, motivation, questions\nRound 2: Technical fundamentals, 40 minutes: networking, OS, crypto, web security\nRound 3: Scenario and design, 40 minutes: incident scenario, secure design, cloud issue\nRound 4: Practical or portfolio walkthrough, 40 minutes: present a flagship project in 10 minutes and answer questions\nRound 5: Behavioural and ethics, 20 minutes\n\nFeedback form for each round: strengths, improvements, clarity, honesty, and a score from 1 to 5.\nRecord yourself where permitted, and review.',
        keyTakeaway:
            'Feedback is the point. Ask interviewers to be honest and specific, and turn each comment into an action.',
      ),
      ConceptLesson(
        title: 'Your Next 12 Months and Beyond',
        definition:
            'A career plan converts goals into milestones. Setting clear targets for the next year and a vision for 3 to 5 years keeps you moving even when progress feels slow.',
        analogy:
            'A trek goes better with a map showing the next camp and the summit, even if the weather changes the route.',
        example:
            'Plan structure:\n\n0 to 3 months: apply, interview, and secure a first role or internship; keep learning weekly\n3 to 6 months: settle into the job, earn your first certification, and complete a work improvement project\n6 to 12 months: specialise (detection engineering, cloud security, application security, GRC), add a second certification, start sharing knowledge publicly\n1 to 3 years: grow to mid-level responsibilities, mentor newcomers, lead small projects\n3 to 5 years: choose a technical or leadership direction\n\nMeasure progress with outcomes: skills gained, projects delivered, and feedback received, not only job titles.',
        keyTakeaway:
            'Careers in security are long and varied. Keep learning, keep ethics at the centre, and help others on the way up.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main purpose of a mock interview loop?',
        options: [
          'To avoid real interviews',
          'To rehearse realistically, expose weak spots, and collect feedback before the real thing',
          'To collect certificates',
          'To replace studying'
        ],
        correctIndex: 1,
        explanation:
            'Rehearsal under realistic conditions builds confidence and reveals what to improve.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which item should be checked in every public repository before you share your portfolio?',
        options: [
          'The number of stars',
          'That it contains no secrets or sensitive data, using a scanner on the code and history',
          'The repository colour',
          'The file count'
        ],
        correctIndex: 1,
        explanation:
            'Leaking secrets in a security portfolio would undermine your credibility.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'How should you measure early career progress?',
        options: [
          'Only by job title',
          'By skills gained, projects delivered, feedback received, and responsibilities grown',
          'By number of certificates only',
          'By hours online'
        ],
        correctIndex: 1,
        explanation:
            'Outcomes and growth are better indicators than titles, which vary between companies.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'In a mock interview you struggled to explain your flagship project in 10 minutes. What should you do?',
        options: [
          'Skip presenting projects',
          'Create a structured walkthrough: problem, approach, architecture, key decisions, results, lessons, and rehearse it with a timer and feedback',
          'Read the README aloud',
          'Add more tools without explaining'
        ],
        correctIndex: 1,
        explanation:
            'A structured, rehearsed project story is one of the strongest assets in an interview.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your mock interviewers say your technical answers are accurate but too long and unfocused. What is the best improvement?',
        options: [
          'Talk faster',
          'Use a structure such as DEEP or STAR, lead with the main point, keep to 1 to 2 minutes, and check whether the interviewer wants more detail',
          'Say less and avoid examples',
          'Ignore the feedback'
        ],
        correctIndex: 1,
        explanation:
            'Concise, structured answers are easier to follow and leave room for useful follow-up questions.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'FINAL CAPSTONE: Cyber Security Engineer Career Launch Package',
      goal:
          'Complete a full skills audit, assemble your career package, run a mock interview loop, and commit to a 12-month plan.',
      steps: [
        'Perform a skills audit across 10 areas with evidence, and choose your 3 flagship projects from Levels 5 to 9',
        'Polish the READMEs of those projects, run a secrets scan on all repositories, and write a one-page portfolio summary',
        'Finalise your master resume and 3 tailored versions, and update LinkedIn and your GitHub profile',
        'Complete your certification plan with dates, budget, and the readiness rule for booking',
        'Prepare your STAR stories, self-introduction, scenario playbook, and 40-question fundamentals bank',
        'Run a full mock interview loop with 5 rounds using peers or mentors, collect written feedback, and record at least two rounds',
        'Write an improvement plan based on feedback and re-practise the weakest round',
        'Set up your job search tracker and send your first 10 tailored applications or networking messages',
        'Write your 90-day plan and 12-month career roadmap, including learning goals and wellbeing practices',
        'Publish a short reflection post or document: what you built in this path, what you learned, and what you will do next',
      ],
      expectedOutput:
          'Career Launch Package\n\nSkills audit: 10 areas rated with evidence; top strengths: SIEM and detection, cloud security basics, application security; gaps: advanced scripting, EDR depth\n\nFlagship projects: Mini SOC lab, Cloud security capstone, AppSec assessment (READMEs polished, secrets scan clean)\nResume: master + 3 tailored | LinkedIn and GitHub updated ✓\n\nCertification plan: Security+ in 10 weeks, then CySA+ or BTL1\nInterview prep: 8 STAR stories, 40 Q bank, 10 scenarios ✓\n\nMock loop: 5 rounds, average 3.8 / 5; weak: concise answers -> practised with DEEP; retest 4.3 / 5\nJob search: tracker live, 10 applications/messages sent ✓\n\n90-day plan + 12-month roadmap ✓\nReflection post published ✓',
      xpReward: 130,
    ),
  ),
];
