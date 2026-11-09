// ══════════════════════════════════════════════════════════════════════
// lib/data/courses/cyber_security_level_1.dart
// Cyber Security Engineer Path — LEVEL 1: Introduction to Cyber Security
// & Fundamentals (10 lessons)
// ══════════════════════════════════════════════════════════════════════
import '../../models/course_content_data.dart';

const List<TopicCourse> cyberSecurityLevel1 = [
  // ────────────────────────────────────────────────────────────────────
  // LESSON 1
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l1_intro',
    topicTitle: 'Introduction to Cyber Security',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 180,
    emoji: '🛡️',
    intro:
        'Every UPI payment, hospital record, power grid and WhatsApp message depends on systems that attackers want to break into. Cyber security is the discipline of protecting those systems, and the people who use them. This lesson gives you the big picture before we go deep.',
    concepts: [
      ConceptLesson(
        title: 'What is Cyber Security?',
        definition:
            'Cyber security is the practice of protecting computers, networks, applications, and data from unauthorised access, damage, theft, or disruption.',
        analogy:
            'Think of your home. Locks on doors, a boundary wall, CCTV, an alarm, and a family that knows not to open the door to strangers. Cyber security is the same layered protection, applied to digital assets.',
        example:
            'What is being protected:\n\nDevices: phones, laptops, servers, IoT cameras\nNetworks: office Wi-Fi, the internet, VPNs\nApplications: banking apps, e-commerce sites\nData: Aadhaar details, medical records, passwords\nPeople: employees who can be tricked into clicking',
        keyTakeaway:
            'Cyber security is not one tool. It is a combination of technology, processes, and people working together to reduce risk.',
      ),
      ConceptLesson(
        title: 'Why Cyber Security Matters',
        definition:
            'As more of life moves online (banking, healthcare, government services, education), a successful attack can cause financial loss, privacy violations, business shutdowns, and even physical harm.',
        analogy:
            'When everyone kept money under the mattress, thieves had to visit each house. When money lives in banks and apps, one successful break-in can reach millions of accounts at once. Digital scale cuts both ways.',
        example:
            'Impact of cyber attacks:\n\nFinancial: fraud, ransom payments, lost business\nPrivacy: leaked personal data used for identity theft\nOperational: hospitals or factories forced to stop work\nReputation: customers lose trust in a breached company\nNational: attacks on power, telecom, and banking systems',
        keyTakeaway:
            'Security failures are business failures. Companies hire security engineers because the cost of one major breach is far higher than the cost of prevention.',
      ),
      ConceptLesson(
        title: 'The Main Domains of Cyber Security',
        definition:
            'Cyber security is a broad field made up of several domains: network security, application security, cloud security, endpoint security, identity and access management, data security, and security operations.',
        analogy:
            'A hospital has many specialists: cardiologists, radiologists, surgeons. All care for the patient but in different ways. Security domains are the specialisations of the security world.',
        example:
            'Security domains:\n\nNetwork Security: firewalls, VPNs, intrusion detection\nApplication Security: secure coding, testing web apps\nCloud Security: protecting AWS / Azure / GCP workloads\nEndpoint Security: antivirus and EDR on laptops and phones\nIAM: who can access what, and how they prove who they are\nSecurity Operations (SOC): monitoring and responding to attacks\nGRC: governance, risk, and compliance',
        keyTakeaway:
            'You do not need to master every domain on day one. This learning path builds your foundation first and then lets you specialise.',
      ),
      ConceptLesson(
        title: 'Cyber Security Careers',
        definition:
            'Security careers range from hands-on technical roles (penetration tester, SOC analyst, security engineer) to strategy and compliance roles (GRC analyst, security architect, CISO).',
        analogy:
            'Security teams are like a cricket team: some bowl (attack-simulating red team), some field (defenders and SOC analysts), some plan strategy (architects), and some handle the rulebook (compliance).',
        example:
            'Common roles:\n\nSOC Analyst: watches alerts, investigates incidents\nPenetration Tester: legally attacks systems to find weaknesses\nSecurity Engineer: builds and maintains defences\nCloud Security Engineer: secures cloud environments\nGRC Analyst: audits, policies, compliance\nIncident Responder: contains and recovers from breaches\nCISO: leads the whole security programme',
        keyTakeaway:
            'Demand for security professionals is strong because every organisation needs defence. A solid foundation in networking, operating systems, and programming opens almost every role.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which statement best describes cyber security?',
        options: [
          'Installing an antivirus on your laptop',
          'Protecting systems, networks, applications, and data from unauthorised access, damage, or disruption',
          'Only protecting government websites',
          'Deleting suspicious emails'
        ],
        correctIndex: 1,
        explanation:
            'Cyber security is broad: it covers devices, networks, applications, data, and people. Antivirus is just one small tool within it.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A company has the best firewall money can buy, but an employee gives their password to a fake caller. What does this show?',
        options: [
          'Firewalls are useless',
          'Security depends on technology, processes, AND people',
          'Employees should never use computers',
          'Passwords are not needed if you have a firewall'
        ],
        correctIndex: 1,
        explanation:
            'Strong technology can be bypassed through human error. Effective security combines technical controls, clear processes, and trained people.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which domain focuses on monitoring alerts and responding to attacks around the clock?',
        options: [
          'Governance, Risk, and Compliance',
          'Application Security',
          'Security Operations (SOC)',
          'Cryptography'
        ],
        correctIndex: 2,
        explanation:
            'A Security Operations Centre (SOC) continuously monitors systems for suspicious activity and responds to incidents.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A hospital is hit by an attack that locks all patient records, and doctors cannot treat patients. Which impact category is most directly shown?',
        options: [
          'Only reputational damage',
          'Operational impact, with possible harm to people',
          'Only a minor inconvenience',
          'No impact, since backups always exist'
        ],
        correctIndex: 1,
        explanation:
            'Healthcare attacks can halt operations and directly affect patient safety. This is why critical sectors treat security as a safety issue, not just an IT issue.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You enjoy investigating suspicious activity and working in shifts to catch attackers in real time. Which role fits best?',
        options: [
          'GRC Analyst',
          'SOC Analyst',
          'Security Architect',
          'Compliance Auditor'
        ],
        correctIndex: 1,
        explanation:
            'SOC Analysts monitor alerts, investigate suspicious events, and escalate incidents. It is one of the most common entry points into cyber security.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'My Digital Footprint Security Map',
      goal:
          'Map the digital assets in your own life and identify what needs protection and which security domain covers each one.',
      steps: [
        'List 10 digital assets you own (email, bank app, social accounts, phone, laptop, cloud storage, etc.)',
        'For each asset, write what could go wrong if it were compromised',
        'Rate each asset by importance: High / Medium / Low',
        'Match each asset to a security domain (network, application, endpoint, IAM, data, cloud)',
        'Pick your 3 most critical assets and write one protection you will add to each',
        'Write a short paragraph: which security career sounds most interesting to you and why?',
      ],
      expectedOutput:
          'Digital Footprint Map:\n1. Primary email — High — compromise lets attacker reset all passwords — IAM\n2. UPI app — High — financial loss — Application / Endpoint\n3. Instagram — Medium — impersonation — IAM\n...\nTop 3 protections: enable MFA on email, app lock on UPI, unique passwords everywhere\nCareer interest: SOC Analyst — I like investigating patterns ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 2
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l1_cia_triad',
    topicTitle: 'CIA Triad',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 180,
    emoji: '🔺',
    intro:
        'Almost every security decision, from choosing encryption to designing backups, can be traced back to three words: Confidentiality, Integrity, and Availability. The CIA Triad is the most important mental model in cyber security.',
    concepts: [
      ConceptLesson(
        title: 'Confidentiality — Only the Right People See It',
        definition:
            'Confidentiality means information is accessible only to those authorised to see it. It protects against unauthorised disclosure.',
        analogy:
            'A sealed envelope marked for one person. If anyone else can read the letter, confidentiality is broken, even if the letter itself is unchanged.',
        example:
            'Controls that protect confidentiality:\n\nEncryption: data unreadable without the key\nAccess control: only HR can open salary files\nMFA: stronger proof of identity\nData classification: Public, Internal, Confidential, Secret\n\nBreach example: a misconfigured cloud storage bucket exposes customer records to anyone with the link.',
        keyTakeaway:
            'Confidentiality is about preventing unauthorised viewing. Typical attacks: data theft, snooping, leaks, and shoulder surfing.',
      ),
      ConceptLesson(
        title: 'Integrity — Data Stays Accurate and Untampered',
        definition:
            'Integrity means information remains accurate, complete, and unaltered except by authorised actions. It protects against unauthorised modification.',
        analogy:
            'A bank statement is useful only if the numbers are trustworthy. If someone silently changes 10,000 to 100,000, the statement still exists but can no longer be trusted.',
        example:
            'Controls that protect integrity:\n\nHashing: detect if a file changed (checksums)\nDigital signatures: prove who approved a document\nVersion control and audit logs: track every change\nInput validation: block malicious changes\n\nAttack example: an attacker alters a payment recipient account number in an invoice before it is paid.',
        keyTakeaway:
            'Integrity is about trust in data. If you cannot trust that data is unchanged, decisions built on it become dangerous.',
      ),
      ConceptLesson(
        title: 'Availability — Systems Work When Needed',
        definition:
            'Availability means systems and data are accessible to authorised users when they need them. It protects against disruption and downtime.',
        analogy:
            'A hospital emergency door that is locked during an emergency has failed its purpose, no matter how secure it is. Security that blocks legitimate use is also a failure.',
        example:
            'Controls that protect availability:\n\nBackups and disaster recovery plans\nRedundant servers and load balancing\nDDoS protection\nPatching to prevent crashes\nUPS and power backup\n\nAttack example: a Distributed Denial of Service (DDoS) floods a website so real customers cannot reach it.',
        keyTakeaway:
            'A system that is secure but unusable has failed. Ransomware and DDoS are availability attacks.',
      ),
      ConceptLesson(
        title: 'Balancing the Triad and Going Beyond It',
        definition:
            'The three goals often pull against each other, and security engineers must balance them based on context. Extra properties such as authenticity, accountability, and non-repudiation extend the model.',
        analogy:
            'Imagine a locker room: more locks (confidentiality) make access slower (availability). A hospital values availability first, a spy agency values confidentiality first, and a bank values integrity first.',
        example:
            'Priority by context:\n\nHospital records: Availability and Integrity first\nMilitary secrets: Confidentiality first\nBanking ledger: Integrity first\nNews website: Availability first\n\nExtensions:\nAuthenticity: is this really from who it claims?\nAccountability: who did what, and when?\nNon-repudiation: a sender cannot deny sending',
        keyTakeaway:
            'When analysing any incident, ask: which of C, I, or A was broken? This single question quickly clarifies what went wrong and what control is needed.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'An attacker steals a database of customer emails and sells it. Which part of the CIA Triad was violated?',
        options: [
          'Integrity',
          'Availability',
          'Confidentiality',
          'None of them'
        ],
        correctIndex: 2,
        explanation:
            'Unauthorised disclosure of information is a confidentiality breach.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Ransomware encrypts all files on a company server, so employees cannot open them. Which principle is MOST directly attacked?',
        options: [
          'Availability',
          'Integrity only',
          'Non-repudiation',
          'Authenticity only'
        ],
        correctIndex: 0,
        explanation:
            'Ransomware prevents legitimate users from accessing their data, which is primarily an availability attack (it may also threaten confidentiality if data is stolen).',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which control is most closely associated with protecting data integrity?',
        options: [
          'Hashing and digital signatures',
          'Load balancers',
          'Disk encryption',
          'Power backup'
        ],
        correctIndex: 0,
        explanation:
            'Hashes and digital signatures reveal whether data was changed. Load balancers support availability, and encryption mainly supports confidentiality.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'An attacker silently changes the bank account number on an invoice from a supplier. The company pays the wrong account. Which principle failed?',
        options: [
          'Confidentiality',
          'Availability',
          'Integrity',
          'Physical security'
        ],
        correctIndex: 2,
        explanation:
            'The data was modified without authorisation. That is a loss of integrity. Controls like digital signatures and call-back verification help prevent this.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'For an online ticket-booking site during a big cricket sale, which principle should be prioritised most?',
        options: [
          'Availability, since the site must stay up under heavy traffic',
          'Confidentiality only',
          'Non-repudiation only',
          'None, because traffic does not matter'
        ],
        correctIndex: 0,
        explanation:
            'During peak sales the biggest risk is the site going down. Load balancing, scaling, and DDoS protection are top priorities, while the other principles still matter.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'CIA Incident Classifier',
      goal:
          'Analyse real-style security incidents and classify which parts of the CIA Triad were broken and which controls would help.',
      steps: [
        'Incident 1: Laptop with unencrypted customer data is stolen from a car',
        'Incident 2: Employee edits grades in the college database without permission',
        'Incident 3: A DDoS attack takes a food delivery app offline during dinner time',
        'Incident 4: An email is intercepted and the attachment replaced with a malicious file',
        'For each incident: identify which of C, I, A were violated (can be more than one)',
        'For each incident: recommend two controls that would have reduced the risk',
        'Create your own incident scenario and classify it',
      ],
      expectedOutput:
          'Incident 1: Confidentiality violated\n  Controls: full disk encryption, remote wipe\n\nIncident 2: Integrity violated\n  Controls: role-based access, audit logging\n\nIncident 3: Availability violated\n  Controls: DDoS protection, auto-scaling\n\nIncident 4: Integrity (and possibly Confidentiality)\n  Controls: email scanning, digital signatures\n\nCustom incident documented ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 3
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l1_threat_types',
    topicTitle: 'Types of Cyber Threats',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 185,
    emoji: '⚠️',
    intro:
        'You cannot defend against what you do not understand. This lesson introduces who attacks, how they attack, and where they get in. These ideas will return in every later level of this path.',
    concepts: [
      ConceptLesson(
        title: 'Threat Actors — Who Attacks and Why',
        definition:
            'A threat actor is a person or group that attempts to harm systems or data. Their motivation, skill, and resources vary widely.',
        analogy:
            'Not all burglars are the same: an opportunist tries unlocked doors, an organised gang plans for months, and a disgruntled ex-employee already has a key. Digital attackers vary just as much.',
        example:
            'Common threat actors:\n\nCybercriminals: financial gain (ransomware, fraud)\nHacktivists: political or social causes\nNation-state groups: espionage and sabotage\nInsiders: employees or contractors with legitimate access\nScript kiddies: low-skill users of ready-made tools\nCompetitors: stealing trade secrets',
        keyTakeaway:
            'Defence depends on who you are defending against. A small shop worries about opportunistic criminals; a power grid must plan for well-funded nation-state attackers.',
      ),
      ConceptLesson(
        title: 'Common Attack Types',
        definition:
            'Attacks exploit weaknesses in technology, processes, or people. Knowing the main categories helps you recognise them quickly.',
        analogy:
            'Attack types are like different burglary methods: picking the lock, tricking the guard, blocking the road, or listening at the window. Each needs a different defence.',
        example:
            'Key attack types:\n\nPassword attacks: brute force, credential stuffing\nDoS / DDoS: flood a service so it becomes unavailable\nMan-in-the-Middle: secretly intercept communication\nSQL Injection: insert malicious database commands via web forms\nCross-Site Scripting (XSS): inject scripts into web pages\nPhishing: trick users into giving up credentials\nZero-day exploit: attack a flaw that has no patch yet',
        keyTakeaway:
            'Most real attacks are not magic. They abuse weak passwords, unpatched software, misconfigurations, or human trust.',
      ),
      ConceptLesson(
        title: 'Vulnerabilities, Threats, and Risk',
        definition:
            'A vulnerability is a weakness. A threat is something that can exploit it. Risk is the likelihood and impact of that exploitation happening.',
        analogy:
            'A cracked window is a vulnerability. A burglar is the threat. Risk is how likely the burglar is to use that window, and how much you would lose if they did.',
        example:
            'Example:\n\nVulnerability: web server running outdated software\nThreat: attacker scanning the internet for that version\nRisk: HIGH if server holds customer data and is public\n\nRisk handling options:\n  Mitigate: patch the software\n  Accept: low value test server\n  Transfer: cyber insurance\n  Avoid: shut down the unused service',
        keyTakeaway:
            'Security teams cannot fix everything. They prioritise by risk, fixing what is most likely and most damaging first.',
      ),
      ConceptLesson(
        title: 'Attack Surface and Attack Vectors',
        definition:
            'The attack surface is the total set of points where an attacker could try to get in. An attack vector is the specific path they use.',
        analogy:
            'A castle with ten gates has a bigger attack surface than one with two. Each gate is a potential vector. Fewer, better-guarded gates mean a safer castle.',
        example:
            'Attack surface elements:\n\nOpen network ports and public web apps\nEmployee email inboxes\nUSB ports and removable media\nThird-party vendors and software libraries\nForgotten test servers and old accounts\n\nReducing it:\n  Close unused ports, remove unused software, enforce least privilege',
        keyTakeaway:
            'A core defensive principle: reduce the attack surface. Every unnecessary service, account, or open port is another door an attacker can try.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'A disgruntled employee with legitimate system access deletes important files. What type of threat actor is this?',
        options: ['Nation-state', 'Insider', 'Script kiddie', 'Hacktivist'],
        correctIndex: 1,
        explanation:
            'Insiders already have authorised access, which makes them hard to detect. Controls include least privilege, monitoring, and prompt access removal when people leave.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is a zero-day vulnerability?',
        options: [
          'A bug that is fixed within zero days',
          'A flaw unknown to the vendor, with no patch available yet',
          'A virus that spreads in zero seconds',
          'A security test that costs nothing'
        ],
        correctIndex: 1,
        explanation:
            'A zero-day is exploitable before the vendor has had any days to produce a fix, so standard patching cannot protect against it yet.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which best describes the relationship between vulnerability, threat, and risk?',
        options: [
          'They all mean the same thing',
          'Risk is the likelihood and impact of a threat exploiting a vulnerability',
          'A threat is a weakness and a vulnerability is an attacker',
          'Risk only exists when a breach has already happened'
        ],
        correctIndex: 1,
        explanation:
            'A vulnerability is the weakness, the threat is what could exploit it, and risk combines how likely and how damaging that exploitation would be.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A website login form lets attackers type database commands into the username box and read other users\' data. Which attack is this?',
        options: ['DDoS', 'Man-in-the-Middle', 'SQL Injection', 'Brute force'],
        correctIndex: 2,
        explanation:
            'Injecting database commands through input fields is SQL Injection. Defence: parameterised queries and input validation.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A company is told to reduce its attack surface. Which action does that best?',
        options: [
          'Open more ports for flexibility',
          'Remove unused services, old accounts, and unneeded open ports',
          'Add more employees to the IT team only',
          'Install a second antivirus and change nothing else'
        ],
        correctIndex: 1,
        explanation:
            'Removing unnecessary entry points directly shrinks what attackers can target. Fewer exposed components also means fewer things to monitor and patch.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Threat Landscape Report for a Small Business',
      goal:
          'Analyse the threats facing a fictional small online store and rank the risks.',
      steps: [
        'Scenario: a 10-person online clothing store with a website, payment gateway, and staff laptops',
        'List 5 assets the store must protect',
        'Identify the 3 most likely threat actors and their motivations',
        'List 6 possible vulnerabilities (technical and human)',
        'Rate each risk as High / Medium / Low with a one-line reason',
        'Recommend one mitigation for each High risk',
        'Draw or describe the store attack surface in a short paragraph',
      ],
      expectedOutput:
          'Threat Report: ClothingCo\nAssets: customer data, payment pages, website, laptops, supplier emails\nActors: cybercriminals (fraud), opportunistic scanners, insiders\nRisks:\n  Outdated website plugin — HIGH — easy to exploit\n  Staff phishing — HIGH — common and effective\n  Weak shared password — MEDIUM\nMitigations: auto-updates, phishing training, unique passwords + MFA\nAttack surface summary written ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 4
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l1_malware',
    topicTitle: 'Malware and Its Types',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 185,
    emoji: '🦠',
    intro:
        'Malware is malicious software built to harm, spy on, or take control of systems. It is behind most breaches, from stolen bank credentials to hospital shutdowns. Learn the main types and how each one behaves so you can recognise and stop them.',
    concepts: [
      ConceptLesson(
        title: 'What is Malware?',
        definition:
            'Malware (malicious software) is any program designed to damage, disrupt, steal from, or gain unauthorised access to a system or network.',
        analogy:
            'Malware is like a harmful guest in your house: some come in disguised as a delivery person, some spread silently room to room, and some simply hold your belongings hostage.',
        example:
            'How malware commonly arrives:\n\nEmail attachments and links\nPirated software and cracked apps\nFake app downloads outside official stores\nInfected USB drives\nCompromised websites (drive-by downloads)\nUnpatched software vulnerabilities',
        keyTakeaway:
            'Malware needs a way in. Most infections succeed because a user ran something untrusted or software was not patched.',
      ),
      ConceptLesson(
        title: 'Viruses, Worms, and Trojans',
        definition:
            'A virus attaches to a legitimate file and needs a user action to spread. A worm spreads by itself across networks. A Trojan pretends to be useful software while hiding malicious behaviour.',
        analogy:
            'A virus is like a cold that needs people to pass it on. A worm is like a fire that spreads on its own. A Trojan is like a gift box that looks harmless but contains something dangerous, named after the Trojan Horse.',
        example:
            'Comparison:\n\nVirus: infects files, spreads when infected file is shared or run\nWorm: self-replicates over networks without user action\nTrojan: disguised as legitimate software, does not self-replicate\n\nExamples:\n  Famous worm style: WannaCry spread across networks automatically\n  Trojan style: a fake PDF reader that installs a backdoor',
        keyTakeaway:
            'The key difference is how they spread: virus needs a host file and action, worm spreads alone, Trojan relies on deception.',
      ),
      ConceptLesson(
        title: 'Ransomware, Spyware, and Keyloggers',
        definition:
            'Ransomware encrypts data and demands payment. Spyware secretly collects information. Keyloggers record everything a user types, including passwords.',
        analogy:
            'Ransomware is a kidnapper locking your files and demanding money. Spyware is a hidden camera in your room. A keylogger is someone reading over your shoulder at every keystroke, forever.',
        example:
            'Behaviour and impact:\n\nRansomware: files encrypted, ransom note shown, business stops\n  Defence: offline backups, patching, email filtering\n\nSpyware: tracks browsing, steals data silently\n  Defence: endpoint protection, avoid untrusted apps\n\nKeylogger: captures passwords and card numbers\n  Defence: MFA, on-screen keyboards for sensitive input, EDR',
        keyTakeaway:
            'Offline, tested backups are the strongest defence against ransomware. Paying a ransom does not guarantee you get your data back.',
      ),
      ConceptLesson(
        title: 'Rootkits, Botnets, and Fileless Malware',
        definition:
            'Rootkits hide malware deep in the system. Botnets are networks of infected devices controlled remotely. Fileless malware runs in memory using legitimate tools, leaving few traces on disk.',
        analogy:
            'A rootkit is a burglar who also rewrites the security camera footage. A botnet is an army of hijacked computers that obey one commander. Fileless malware is an intruder who uses your own tools so nothing looks out of place.',
        example:
            'Advanced malware types:\n\nRootkit: hides processes and files from the operating system\nBotnet: thousands of infected devices used for DDoS and spam\nFileless: abuses PowerShell or WMI, lives in memory\nAdware: unwanted ads, often bundled with free software\nCryptojacker: secretly uses your CPU to mine cryptocurrency',
        keyTakeaway:
            'Modern malware tries to avoid detection. Behaviour-based tools such as EDR matter because signature-only antivirus can miss these threats.',
      ),
      ConceptLesson(
        title: 'Preventing and Responding to Malware',
        definition:
            'Defence combines prevention (patching, safe habits, filtering), detection (endpoint tools, monitoring), and response (isolate, remove, restore).',
        analogy:
            'Think of public health: vaccination (patching), hygiene (safe habits), screening (monitoring), and quarantine (isolation) together stop an outbreak.',
        example:
            'If you suspect infection:\n\n1. Disconnect the device from the network\n2. Do not pay or interact with ransom messages\n3. Report to the IT or security team immediately\n4. Scan with trusted security tools\n5. Restore from clean backups if needed\n6. Change passwords from a clean device\n\nPrevention:\n  Keep OS and apps updated\n  Download only from official sources\n  Use endpoint protection\n  Back up regularly (3-2-1 rule)',
        keyTakeaway:
            'Speed matters. Isolating an infected machine quickly can stop one infected laptop from becoming a company-wide incident.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which malware spreads across a network by itself, without needing the user to run anything?',
        options: ['Virus', 'Worm', 'Trojan', 'Keylogger'],
        correctIndex: 1,
        explanation:
            'Worms self-replicate and spread over networks automatically. Viruses need a host file and a user action, and Trojans rely on deception.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'You download a "free video editor" that also secretly installs a backdoor. What type of malware is the editor?',
        options: ['Worm', 'Trojan', 'Rootkit', 'Botnet'],
        correctIndex: 1,
        explanation:
            'A Trojan disguises itself as legitimate software while carrying a hidden malicious function.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the best defence against losing data to ransomware?',
        options: [
          'Paying the ransom quickly',
          'Regular offline backups that are tested for restoration',
          'Turning off the computer for a week',
          'Renaming the files'
        ],
        correctIndex: 1,
        explanation:
            'Clean, offline, tested backups let you restore without paying. Paying does not guarantee data recovery and encourages further attacks.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A laptop shows a message saying all files are encrypted and demands payment. What should you do FIRST?',
        options: [
          'Pay immediately to save time',
          'Disconnect it from the network and report to the security team',
          'Keep working on other files normally',
          'Restart the router only'
        ],
        correctIndex: 1,
        explanation:
            'Isolation limits spread to other devices, and reporting starts the incident response process. Do not pay or negotiate without the security team.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Thousands of smart cameras with default passwords are hijacked and used to flood a website. What have they become part of?',
        options: ['A firewall', 'A botnet', 'A VPN', 'A honeypot'],
        correctIndex: 1,
        explanation:
            'A botnet is a network of compromised devices controlled remotely. IoT devices with default passwords are a common source of botnet recruits.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Malware Field Guide',
      goal:
          'Create a one-page reference guide that explains each malware type and how to defend against it.',
      steps: [
        'Choose 8 malware types: virus, worm, Trojan, ransomware, spyware, keylogger, rootkit, botnet',
        'For each: write a one-line definition and a real-world analogy in your own words',
        'For each: write how it usually spreads',
        'For each: write one prevention and one detection method',
        'Research one real malware incident (for example WannaCry) and summarise what happened and what lesson it taught',
        'Write a 5-step "what to do if infected" checklist for a non-technical family member',
      ],
      expectedOutput:
          'Malware Field Guide\n\nRansomware\n  Definition: encrypts files and demands payment\n  Analogy: kidnapper holding your files\n  Spread: phishing, unpatched servers\n  Prevent: offline backups, patching\n  Detect: unusual file changes, EDR alerts\n...\n\nCase study: WannaCry — spread via unpatched Windows systems; lesson: patch fast\n\nFamily checklist: disconnect, do not pay, report, scan, restore ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 5
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l1_phishing_se',
    topicTitle: 'Phishing and Social Engineering',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 185,
    emoji: '🎣',
    intro:
        'Why break through a strong firewall when you can simply ask someone to open the door? Phishing and social engineering target people, not machines, and they are behind a huge share of real-world breaches and frauds.',
    concepts: [
      ConceptLesson(
        title: 'What is Social Engineering?',
        definition:
            'Social engineering is the manipulation of people into revealing confidential information or performing actions that compromise security.',
        analogy:
            'A con artist does not pick the lock. They walk in wearing a uniform and say "I am here for maintenance". Social engineering is the digital version of that confidence trick.',
        example:
            'Psychological triggers attackers use:\n\nAuthority: "I am calling from the bank head office"\nUrgency: "Your account will be blocked in 30 minutes"\nFear: "Legal action will be taken against you"\nGreed: "You have won a prize"\nHelpfulness: "Can you hold the door for me?"\nTrust: pretending to be a colleague or vendor',
        keyTakeaway:
            'Attackers exploit emotions, mainly urgency and fear, to make you act before you think. Slowing down is your best defence.',
      ),
      ConceptLesson(
        title: 'Types of Phishing',
        definition:
            'Phishing uses fake messages that appear to come from trusted sources to steal credentials, money, or install malware. It comes in many forms.',
        analogy:
            'Phishing is fishing: the attacker casts bait and waits. Mass phishing is a wide net. Spear phishing is a carefully chosen lure for one specific fish.',
        example:
            'Phishing variants:\n\nEmail phishing: mass fake emails\nSpear phishing: targeted at a specific person using personal details\nWhaling: aimed at executives\nSmishing: via SMS\nVishing: via phone calls (fake bank or KYC calls)\nQuishing: malicious QR codes\nBusiness Email Compromise: impersonating a boss to request urgent payment\nClone phishing: a real email copied with a malicious link swapped in',
        keyTakeaway:
            'The channel changes but the trick is the same: impersonate someone trusted and push for quick action involving credentials or money.',
      ),
      ConceptLesson(
        title: 'Spotting a Phishing Message',
        definition:
            'Phishing messages usually contain recognisable warning signs in the sender, language, links, and requests. Checking these before clicking prevents most attacks.',
        analogy:
            'Like checking a banknote for watermarks, you can learn a quick checklist that exposes fakes in seconds.',
        example:
            'Red flags checklist:\n\nSender: look-alike address (support@paypa1-secure.com)\nGreeting: generic ("Dear customer") instead of your name\nTone: urgent, threatening, or too good to be true\nLinks: hover first, and the real URL does not match the text\nAttachments: unexpected .zip, .exe, or macro-enabled documents\nRequests: passwords, OTPs, or card details by email\nQuality: odd grammar or branding\n\nGolden rule: NEVER share an OTP or PIN. Real banks never ask for it.',
        keyTakeaway:
            'When in doubt, do not click. Go to the official website by typing the address yourself, or call the official number printed on your card.',
      ),
      ConceptLesson(
        title: 'Defending Against and Reporting Phishing',
        definition:
            'Defence combines technical controls (email filtering, MFA, link scanning) with awareness training and clear reporting procedures.',
        analogy:
            'Neighbourhood watch works because people report suspicious activity quickly. Reporting phishing protects everyone else too.',
        example:
            'Defence layers:\n\nTechnical: spam filters, SPF / DKIM / DMARC, safe-link scanning\nIdentity: MFA so stolen passwords are not enough\nProcess: verify payment changes by calling a known number\nPeople: regular phishing simulations and training\n\nIf you clicked or shared details:\n  1. Change the password immediately\n  2. Inform your IT / security team\n  3. If money is involved, call your bank right away\n  4. In India: call 1930 or report on cybercrime.gov.in',
        keyTakeaway:
            'Reporting quickly matters more than feeling embarrassed. Fast reporting can stop fraudulent transfers and contain breaches.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'An email addressed only to the CFO, using real project details to request an urgent wire transfer, is best described as:',
        options: [
          'Mass phishing',
          'Whaling or spear phishing',
          'A DDoS attack',
          'Adware'
        ],
        correctIndex: 1,
        explanation:
            'Highly targeted messages that use personal or business context against a senior person are spear phishing, specifically called whaling when aimed at executives.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A caller claiming to be from your bank asks for the OTP "to cancel a fraudulent transaction". What should you do?',
        options: [
          'Share the OTP quickly to stop the fraud',
          'Hang up and never share it; call the bank using the official number',
          'Share only the first three digits',
          'Ask them to send an email first and then share it'
        ],
        correctIndex: 1,
        explanation:
            'Banks never ask for OTPs. This is vishing. Hang up and contact the bank through its official number.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which is the strongest technical protection if a user does get tricked into typing their password on a fake site?',
        options: [
          'A longer email subject',
          'Multi-factor authentication',
          'A bigger monitor',
          'Clearing browser history'
        ],
        correctIndex: 1,
        explanation:
            'MFA means a stolen password alone is not enough to log in, which greatly limits the damage of successful phishing (phishing-resistant MFA like passkeys is stronger still).',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You receive: "Your account will be suspended in 1 hour! Click http://secure-bank-login.xyz to verify." What is the BEST action?',
        options: [
          'Click quickly before the deadline',
          'Ignore the link, open the bank app or type the official URL yourself, and report the message',
          'Forward it to all your friends as a warning with the link',
          'Reply with your account number to confirm'
        ],
        correctIndex: 1,
        explanation:
            'Urgency plus a suspicious domain are classic phishing signs. Verify through official channels you open yourself, and report the message.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A "manager" emails from a look-alike address asking you to buy gift cards urgently and keep it secret. What type of attack is this?',
        options: [
          'Business Email Compromise style social engineering',
          'A harmless internal policy',
          'A firewall update',
          'A routine software patch'
        ],
        correctIndex: 0,
        explanation:
            'Impersonating an authority figure with secrecy and urgency is a classic BEC / social engineering pattern. Verify through a separate, trusted channel.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Phishing Awareness Poster and Red-Flag Audit',
      goal:
          'Analyse sample phishing messages and create an awareness poster for non-technical people.',
      steps: [
        'Collect or write 5 sample phishing messages: email, SMS, WhatsApp, fake KYC call script, and QR code scam (use fictional examples only)',
        'For each, mark all red flags you can find',
        'Classify each by type: phishing, spear phishing, smishing, vishing, quishing',
        'Write what the correct response would be for each one',
        'Design a one-page poster titled "Stop. Think. Verify." with 6 simple rules',
        'Add the reporting steps for India: call 1930 and use cybercrime.gov.in',
      ],
      expectedOutput:
          'Phishing Audit\n\nSample 1 (SMS): "KYC expired, click link" — Smishing\n  Red flags: urgency, shortened link, generic sender\n  Correct response: ignore, open official app, report\n\nSample 2 (Call): "Bank officer asking OTP" — Vishing\n  Red flag: asks for OTP\n  Correct response: hang up, call official number\n...\n\nPoster: Stop. Think. Verify. — 6 rules + reporting steps ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 6
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l1_auth_access',
    topicTitle: 'Authentication and Access Control',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 195,
    emoji: '🔑',
    intro:
        'Security begins with two questions: who are you, and what are you allowed to do? Authentication answers the first, authorisation and access control answer the second. Get these wrong and every other defence can be bypassed.',
    concepts: [
      ConceptLesson(
        title: 'Authentication vs Authorisation',
        definition:
            'Authentication verifies WHO you are. Authorisation decides WHAT you are allowed to do. Accounting (logging) records what you did. Together they form AAA.',
        analogy:
            'At an airport, showing your passport proves who you are (authentication). Your boarding pass decides which flight you can enter (authorisation). The security log records that you passed through (accounting).',
        example:
            'AAA in practice:\n\nAuthentication: logging into the company portal with password + OTP\nAuthorisation: HR staff can see salary data, interns cannot\nAccounting: system logs show who opened which file and when',
        keyTakeaway:
            'Never confuse the two. Proving identity does not mean everything is permitted. A valid login should still be limited to what that user truly needs.',
      ),
      ConceptLesson(
        title: 'Authentication Factors and MFA',
        definition:
            'Authentication factors are categories of proof: something you know, something you have, and something you are. Multi-Factor Authentication (MFA) combines two or more different factors.',
        analogy:
            'Withdrawing from an ATM needs your card (something you have) AND your PIN (something you know). One stolen item alone is not enough.',
        example:
            'Factor types:\n\nKnow: password, PIN, security answer\nHave: phone with authenticator app, hardware key, smart card\nAre: fingerprint, face, iris\n\nMFA strength (weaker to stronger):\n  SMS OTP < Authenticator app codes < Hardware key / passkey\n\nTwo passwords are NOT MFA, because both are "something you know".',
        keyTakeaway:
            'Enable MFA everywhere it is offered, especially for email and banking. Prefer authenticator apps or passkeys over SMS where possible.',
      ),
      ConceptLesson(
        title: 'Passwords and How They Are Stored',
        definition:
            'Strong passwords are long, unique, and unpredictable. Systems must never store passwords in plain text; they store salted hashes so that even a database leak does not reveal the actual passwords.',
        analogy:
            'A salted hash is like a one-way meat grinder with a secret spice: you can turn a password into the result, but you cannot turn the result back into the password, and the spice makes every result unique.',
        example:
            'Good password habits:\n\nLength over complexity: a long passphrase beats P@ssw0rd\nUnique for every site (reuse enables credential stuffing)\nUse a password manager\nCheck for known breaches\n\nWhat developers should do:\n  Hash with bcrypt, scrypt, or Argon2\n  Add a unique random salt per user\n  Never use plain MD5 or SHA-1 for passwords\n  Rate-limit login attempts',
        keyTakeaway:
            'Users: unique long passphrases plus a password manager. Developers: salted, slow hashing. Both sides matter.',
        codeSnippet:
            '# Never store plain passwords. Example with a salted hash\nimport bcrypt\n\npassword = b"my-long-passphrase"\nhashed = bcrypt.hashpw(password, bcrypt.gensalt())\n\nprint(bcrypt.checkpw(password, hashed))  # True\nprint(bcrypt.checkpw(b"wrong", hashed))  # False',
      ),
      ConceptLesson(
        title: 'Access Control Models and Least Privilege',
        definition:
            'Access control defines who can access which resources. Common models are DAC (owner decides), MAC (central policy decides), and RBAC (permissions assigned by role). The principle of least privilege gives users only the minimum access they need.',
        analogy:
            'In an office building, a visitor badge opens the lobby, an employee badge opens work floors, and only the server-room team badge opens the data centre. Access matches the role, nothing more.',
        example:
            'Access control models:\n\nDAC: file owner shares files as they wish (typical file sharing)\nMAC: system-enforced labels such as Confidential / Secret\nRBAC: roles like Admin, Editor, Viewer carry permissions\nABAC: decisions based on attributes (department, time, location)\n\nLeast privilege examples:\n  Intern: read-only access to project docs\n  Developer: no direct access to production database\n  Admin accounts used only when admin work is needed',
        keyTakeaway:
            'Least privilege limits damage. If a low-privilege account is compromised, the attacker can do far less than with an admin account.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which of these is a true example of multi-factor authentication?',
        options: [
          'Password and security question',
          'Password and a code from an authenticator app',
          'Two different passwords',
          'A long password only'
        ],
        correctIndex: 1,
        explanation:
            'MFA needs factors from different categories. A password (know) plus a phone-generated code (have) qualifies. Passwords and security questions are both "know".',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should a website store a salted hash of passwords instead of the passwords themselves?',
        options: [
          'It makes the website load faster',
          'A database leak does not directly reveal user passwords, and salting stops attackers reusing precomputed tables',
          'It lets admins read forgotten passwords',
          'Hashes are always impossible to attack'
        ],
        correctIndex: 1,
        explanation:
            'Hashes are one-way and salts make each hash unique. Attackers still try guesses, which is why slow algorithms like bcrypt or Argon2 are used.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the principle of least privilege mean?',
        options: [
          'Everyone shares one admin account',
          'Users get only the minimum access required for their job',
          'Only managers can log in',
          'Privileges are removed after every login'
        ],
        correctIndex: 1,
        explanation:
            'Least privilege restricts access to what is strictly necessary, limiting the impact of mistakes and compromised accounts.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A company breach exposes a database where passwords were stored as plain text. Users reused those passwords on other sites. What attack will likely follow?',
        options: [
          'Credential stuffing',
          'A DDoS on the router',
          'SQL injection on the user device',
          'Keyboard failure'
        ],
        correctIndex: 0,
        explanation:
            'Attackers try leaked username-password pairs on other services. Unique passwords and MFA are the defence.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A new marketing intern is given full administrator rights "to save time". What is the main problem?',
        options: [
          'It violates least privilege and increases the damage if the account is compromised',
          'Administrators run slower computers',
          'Interns cannot use passwords',
          'There is no problem'
        ],
        correctIndex: 0,
        explanation:
            'Excess privileges turn a minor compromise into a major one. Assign a role with only the permissions the intern needs.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Personal Authentication Hardening Plan',
      goal:
          'Audit and strengthen the authentication setup of your own important accounts.',
      steps: [
        'List your 8 most important accounts (primary email, banking, UPI, social, cloud storage, etc.)',
        'For each, record: is MFA on? Is the password unique? What type of MFA is it?',
        'Set up a password manager and move at least 3 accounts into it with unique generated passwords',
        'Enable authenticator-app MFA or a passkey on your primary email and one financial account',
        'Write down your recovery options (backup codes, recovery email) and where you will store them safely',
        'Design a simple RBAC table for a fictional college app with roles: Student, Teacher, Admin',
      ],
      expectedOutput:
          'Authentication Audit\n\nPrimary email: MFA off -> enabled authenticator app ✓\nBank app: PIN + biometric ✓\nShopping site: password reused -> now unique ✓\n...\n\nRBAC Table:\n  Student: view own grades\n  Teacher: enter grades for own classes\n  Admin: manage users, no grade editing\n\nRecovery plan documented ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 7
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l1_crypto_basics',
    topicTitle: 'Encryption and Basic Cryptography',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 200,
    emoji: '🔐',
    intro:
        'Every time you see the padlock in your browser, send a WhatsApp message, or make a UPI payment, cryptography is working silently in the background. This lesson explains the core ideas, without heavy mathematics, so you can use cryptography correctly.',
    concepts: [
      ConceptLesson(
        title: 'What is Encryption?',
        definition:
            'Encryption converts readable data (plaintext) into unreadable data (ciphertext) using an algorithm and a key. Only someone with the correct key can convert it back (decrypt).',
        analogy:
            'Encryption is a locked box. The algorithm is the design of the lock, which can be public knowledge. The key is the secret that actually opens it.',
        example:
            'Plaintext:  HELLO\nAlgorithm:  AES\nKey:        (secret)\nCiphertext: 9f3A... (unreadable)\n\nTwo states of protected data:\n  Data at rest: encrypted on disk, such as phone storage\n  Data in transit: encrypted while moving, such as HTTPS',
        keyTakeaway:
            'Strong security comes from keeping the KEY secret, not the algorithm. Never invent your own cryptography; use proven standards.',
      ),
      ConceptLesson(
        title: 'Symmetric Encryption',
        definition:
            'Symmetric encryption uses the same key to encrypt and decrypt. It is very fast and ideal for large amounts of data. AES is the modern standard.',
        analogy:
            'Two friends share a diary with one lock and two identical keys. Fast and simple, but they must somehow hand over the key safely first.',
        example:
            'Symmetric in practice:\n\nAES-256: disk encryption, file encryption, VPN data\nChaCha20: fast on mobile devices\n\nStrength: speed\nChallenge: key distribution (how do you share the key safely?)\n\nOutdated and unsafe: DES, RC4',
        keyTakeaway:
            'Use symmetric encryption for bulk data. The hard problem it leaves behind, sharing the key securely, is what asymmetric cryptography solves.',
      ),
      ConceptLesson(
        title: 'Asymmetric Encryption and Digital Signatures',
        definition:
            'Asymmetric encryption uses a key pair: a public key that anyone can have and a private key that stays secret. Data encrypted with the public key can only be decrypted with the private key. Digital signatures reverse this to prove authenticity.',
        analogy:
            'A public mailbox: anyone can drop a letter in through the slot (public key), but only the owner with the mailbox key (private key) can open it. A signature is like a wax seal only you can make but anyone can verify.',
        example:
            'Uses of asymmetric cryptography:\n\nEncryption: send a secret to someone using their public key\nDigital signature: sign with private key, others verify with public key\nKey exchange: safely agree on a session key\n\nCommon algorithms: RSA, ECC (elliptic curve)\n\nTrade-off: slower than symmetric, so it is mainly used to exchange keys and sign data',
        keyTakeaway:
            'Real systems combine both: asymmetric cryptography safely exchanges a key, then fast symmetric encryption protects the actual data. HTTPS works exactly this way.',
      ),
      ConceptLesson(
        title: 'Hashing — Fingerprints for Data',
        definition:
            'A hash function turns any input into a fixed-size output (digest). It is one-way and any tiny change in input produces a completely different hash. Hashing is not encryption because it cannot be reversed.',
        analogy:
            'A hash is like a fingerprint. A fingerprint identifies a person but you cannot rebuild the person from it. Change one letter in a document and the fingerprint becomes totally different.',
        example:
            'Uses of hashing:\n\nFile integrity: compare checksums after download\nPassword storage: store salted hashes\nDigital signatures: sign the hash of a document\nBlockchain and Git: link data by hash\n\nRecommended: SHA-256, SHA-3\nBroken for security uses: MD5, SHA-1',
        keyTakeaway:
            'Encryption is reversible with a key. Hashing is one-way. Pick the right tool: confidentiality needs encryption, integrity and password storage need hashing.',
        codeSnippet:
            'import hashlib\n\na = hashlib.sha256(b"Pay 100 to Alice").hexdigest()\nb = hashlib.sha256(b"Pay 900 to Alice").hexdigest()\n\nprint(a)\nprint(b)\nprint(a == b)  # False - one change, totally different hash',
      ),
      ConceptLesson(
        title: 'HTTPS, TLS, and Certificates',
        definition:
            'HTTPS is HTTP protected by TLS. TLS uses certificates issued by trusted Certificate Authorities (CAs) to prove a website identity and then encrypts traffic with a session key.',
        analogy:
            'A certificate is like a government-issued ID for a website. The browser checks the ID with a trusted authority, then both sides agree on a secret code word for the conversation.',
        example:
            'Simplified TLS flow:\n\n1. Browser connects and asks for the site certificate\n2. Browser verifies the certificate against trusted CAs\n3. Browser and server securely agree on a session key\n4. All further traffic is encrypted with that session key\n\nWhat the padlock means: the connection is encrypted and the domain identity is verified.\nWhat it does NOT mean: the website is trustworthy. Phishing sites can also have HTTPS.',
        keyTakeaway:
            'A padlock means a private connection, not a safe website. Always check the domain name itself.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which type of encryption uses the SAME key for encrypting and decrypting?',
        options: ['Asymmetric', 'Symmetric', 'Hashing', 'Digital signature'],
        correctIndex: 1,
        explanation:
            'Symmetric encryption (like AES) uses one shared secret key. It is fast but requires a safe way to share that key.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Alice wants to send Bob a secret using asymmetric encryption. Which key does she use to encrypt it?',
        options: [
          'Her own private key',
          'Bob\'s public key',
          'Bob\'s private key',
          'A hash of the message'
        ],
        correctIndex: 1,
        explanation:
            'The message is encrypted with the recipient public key, and only Bob private key can decrypt it.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is hashing NOT the same as encryption?',
        options: [
          'Hashing is slower',
          'Hashing is one-way and cannot be reversed to recover the original data',
          'Hashing needs two keys',
          'Hashing only works on images'
        ],
        correctIndex: 1,
        explanation:
            'Encryption can be reversed with the key. A hash is a one-way fingerprint, which is why it suits integrity checks and password storage.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You download software and the vendor lists a SHA-256 checksum. Your computed checksum is different. What does this suggest?',
        options: [
          'The file may be corrupted or tampered with, so do not run it',
          'Nothing, checksums are decorative',
          'Your computer is faster than the vendor',
          'The file is definitely safe'
        ],
        correctIndex: 0,
        explanation:
            'A mismatched hash means the file is not identical to the original. Re-download from the official source and verify again.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A phishing site shows a padlock icon and HTTPS. Does this prove the site is safe?',
        options: [
          'Yes, a padlock always means safe',
          'No, it only means the connection is encrypted; attackers can also get certificates for their own domains',
          'Yes, because HTTPS sites are verified by the government',
          'No, because HTTPS is not real'
        ],
        correctIndex: 1,
        explanation:
            'HTTPS protects the connection, not the honesty of the site owner. Always verify the domain name and treat unexpected login pages with suspicion.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Cryptography Hands-On Lab',
      goal:
          'Practise hashing, integrity checking, and explain how HTTPS combines the cryptographic building blocks.',
      steps: [
        'In Python (or Google Colab), hash the text "Hello" with SHA-256 and print the digest',
        'Change one character and hash again; compare both digests and write what you observe',
        'Create a text file, compute its SHA-256, edit the file, and show the hash changes',
        'Using hashlib, write a small function verify(file, expected_hash) that returns True or False',
        'Open any HTTPS website in your browser, inspect its certificate, and note the issuer and expiry date',
        'Draw or write the 4-step HTTPS flow and mark where asymmetric and symmetric encryption are each used',
      ],
      expectedOutput:
          'Crypto Lab Output\n\nSHA-256("Hello") = 185f8db3...\nSHA-256("Hellp") = 7b4f1c2a... (completely different)\n\nverify("notes.txt", expected) -> True\nAfter editing file -> False\n\nCertificate: issued by a trusted CA, valid until [date]\n\nHTTPS flow:\n  Certificate check (identity)\n  Asymmetric: key exchange\n  Symmetric: bulk data encryption ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 8
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l1_firewall_av',
    topicTitle: 'Firewalls and Antivirus Fundamentals',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 185,
    emoji: '🧱',
    intro:
        'Firewalls and antivirus are the two best-known security tools, and also the most misunderstood. Learn what each one really does, where it fails, and why professionals never rely on a single layer.',
    concepts: [
      ConceptLesson(
        title: 'What a Firewall Does',
        definition:
            'A firewall monitors network traffic and allows or blocks it according to security rules. It sits between trusted and untrusted networks, such as your internal network and the internet.',
        analogy:
            'A firewall is the security guard at a housing society gate. The guard checks who is coming in and going out, and follows a list: residents allowed, unknown visitors stopped.',
        example:
            'Example firewall rules:\n\nALLOW  TCP port 443 (HTTPS) from anywhere to web server\nALLOW  TCP port 22 (SSH) only from office IP range\nDENY   all other inbound traffic (default deny)\n\nBest practice: default deny, allow only what is needed.',
        keyTakeaway:
            'A good firewall follows "default deny": block everything, then explicitly allow only necessary traffic.',
      ),
      ConceptLesson(
        title: 'Types of Firewalls',
        definition:
            'Firewalls have evolved from simple packet filters to deep-inspection and application-aware systems, and can be hardware, software, or cloud-based.',
        analogy:
            'Early firewalls read only the address on the envelope. Modern ones can open the envelope, read the contents, and understand which application sent it.',
        example:
            'Firewall generations:\n\nPacket filtering: checks IP, port, protocol only\nStateful inspection: tracks connection state\nProxy / application firewall: inspects application-layer content\nNext-Generation Firewall (NGFW): deep packet inspection, app awareness, intrusion prevention\nWeb Application Firewall (WAF): protects web apps from SQLi and XSS\n\nDeployment: network (hardware), host-based (software on a PC), cloud security groups',
        keyTakeaway:
            'A network firewall protects the perimeter, a host firewall protects each device, and a WAF protects web applications. Different layers cover different gaps.',
      ),
      ConceptLesson(
        title: 'How Antivirus Works',
        definition:
            'Antivirus software detects, blocks, and removes malware using signatures, heuristics, and behaviour analysis. Modern endpoint tools also use cloud intelligence and machine learning.',
        analogy:
            'Signature detection is like a police wanted poster: it only catches criminals already on the list. Heuristics and behaviour analysis are like noticing someone acting suspiciously even if their face is unknown.',
        example:
            'Detection methods:\n\nSignature-based: matches known malware fingerprints (fast, misses new threats)\nHeuristic: looks for suspicious code traits\nBehaviour-based: watches actions such as mass-encrypting files\nCloud / ML based: uses global threat data\nSandboxing: runs suspicious files in an isolated environment\n\nUpgrade path: Antivirus -> EDR (Endpoint Detection and Response)',
        keyTakeaway:
            'Antivirus is necessary but not sufficient. It reduces common threats, but new and fileless threats require behaviour-based detection and good security habits.',
      ),
      ConceptLesson(
        title: 'Defence in Depth and Limits of These Tools',
        definition:
            'Defence in depth layers multiple controls so that if one fails, others still protect the system. No single tool, including a firewall or antivirus, can stop every attack.',
        analogy:
            'A bank does not rely on a single door. It has guards, cameras, a locked vault, alarms, and dual-key access. An attacker must defeat many layers.',
        example:
            'Layers for a company laptop:\n\nPerimeter: network firewall and email filtering\nHost: OS firewall, antivirus / EDR\nIdentity: MFA and least privilege\nData: disk encryption and backups\nPeople: security awareness training\nMonitoring: logs and alerts\n\nWhat firewalls and AV cannot stop:\n  A user giving their password to a phisher\n  A malicious insider\n  An attack that arrives through an allowed port',
        keyTakeaway:
            'Think in layers. When one control fails, the next should limit the damage.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does the "default deny" firewall principle mean?',
        options: [
          'Block everything except traffic explicitly allowed',
          'Allow everything except traffic explicitly blocked',
          'Deny only suspicious emails',
          'Disable the firewall by default'
        ],
        correctIndex: 0,
        explanation:
            'Default deny is the safest approach: unless a rule specifically permits the traffic, it is blocked.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why can signature-based antivirus miss brand-new malware?',
        options: [
          'Signatures only match malware that is already known',
          'Signatures are too slow',
          'Antivirus cannot read files',
          'New malware is always harmless'
        ],
        correctIndex: 0,
        explanation:
            'Signatures are fingerprints of known threats. New or modified malware has no signature yet, which is why behaviour-based detection is also needed.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which tool is specifically designed to protect a web application from attacks such as SQL injection and XSS?',
        options: [
          'Packet filter',
          'Web Application Firewall (WAF)',
          'USB scanner',
          'Password manager'
        ],
        correctIndex: 1,
        explanation:
            'A WAF understands web traffic and filters malicious HTTP requests aimed at the application layer.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'An employee voluntarily types their password into a phishing page. The company has a strong firewall and antivirus. Why did they not stop it?',
        options: [
          'They are not effective at all',
          'These tools mainly block traffic and files; they cannot always stop a human handing over credentials, so MFA and awareness are needed',
          'The firewall was turned off by the phishing page',
          'Antivirus automatically changes passwords'
        ],
        correctIndex: 1,
        explanation:
            'Technical controls have limits against social engineering. Defence in depth adds MFA, email filtering, and training.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A server should only be managed remotely by the IT team from the office. Which firewall rule is best?',
        options: [
          'Allow SSH (port 22) from any IP address',
          'Allow SSH only from the office IP range and deny all other sources',
          'Disable the firewall for convenience',
          'Allow all ports temporarily'
        ],
        correctIndex: 1,
        explanation:
            'Restricting the management port to known source addresses follows least privilege and shrinks the attack surface.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Design a Layered Defence for a Small Office',
      goal:
          'Design a defence-in-depth plan for a 15-person office and write simple firewall rules.',
      steps: [
        'Scenario: a small accounting office with a web portal, 15 laptops, and a file server holding client data',
        'Write 6 firewall rules using default deny (for example allow HTTPS to the web server, allow SSH only from the office)',
        'Choose and justify host protection for laptops (OS firewall, antivirus or EDR, disk encryption)',
        'List 2 controls for each layer: perimeter, host, identity, data, people, monitoring',
        'Identify 3 attacks your design would NOT stop and what extra control would help',
        'Enable and review the built-in firewall settings on your own computer and document what you find',
      ],
      expectedOutput:
          'Office Defence Plan\n\nFirewall rules:\n  1. DENY all inbound (default)\n  2. ALLOW 443 to web portal\n  3. ALLOW 22 from office IP only\n  ...\n\nLayers:\n  Perimeter: NGFW, email filtering\n  Host: EDR, disk encryption\n  Identity: MFA, least privilege\n  Data: nightly encrypted backups\n  People: quarterly phishing training\n\nGaps: phishing, insider misuse, zero-day -> add training, logging, patching ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 9
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l1_policies_practices',
    topicTitle: 'Security Policies and Safe Practices',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 26,
    totalXp: 180,
    emoji: '📋',
    intro:
        'Technology alone cannot keep an organisation safe. Clear rules and good everyday habits turn security from a product into a culture. This lesson covers the policies companies write and the practical habits every person should follow.',
    concepts: [
      ConceptLesson(
        title: 'What Are Security Policies?',
        definition:
            'A security policy is a formal document that defines how an organisation protects its information and what is expected from employees. Standards, procedures, and guidelines support the policy with more detail.',
        analogy:
            'Policies are the rulebook of a cricket match. Rules (policy), umpire instructions (procedures), and recommended playing tips (guidelines) work together so that everyone plays the same safe game.',
        example:
            'Common security policies:\n\nAcceptable Use Policy: what employees may do with company systems\nPassword Policy: length, rotation, MFA rules\nData Classification Policy: Public, Internal, Confidential, Restricted\nBYOD Policy: rules for personal devices at work\nIncident Response Policy: who to inform and what to do in a breach\nBackup and Retention Policy: what is saved, and for how long\n\nHierarchy: Policy (what and why) -> Standard (required settings) -> Procedure (step by step) -> Guideline (advice)',
        keyTakeaway:
            'A policy only works if it is clear, enforced, and understood. Unread policies do not protect anything.',
      ),
      ConceptLesson(
        title: 'Everyday Safe Practices',
        definition:
            'Safe practices are simple habits that remove the most common risks: updating software, using strong authentication, being careful with links and downloads, and protecting devices.',
        analogy:
            'Brushing teeth and washing hands are small daily habits that prevent most illness. Basic cyber hygiene does the same for your digital life.',
        example:
            'Cyber hygiene checklist:\n\nUpdate OS and apps promptly (auto-update on)\nUse unique passwords with a password manager\nEnable MFA on important accounts\nDownload apps only from official stores\nLock your screen when you leave your desk\nAvoid public Wi-Fi for banking, or use a trusted VPN\nCheck app permissions (does a torch app need contacts?)\nLog out of shared computers\nVerify before you click',
        keyTakeaway:
            'Most breaches exploit basic failures: missing patches, weak passwords, and untrusted clicks. Good hygiene blocks a large share of attacks at almost no cost.',
      ),
      ConceptLesson(
        title: 'Backups and Data Protection Habits',
        definition:
            'Backups protect against ransomware, hardware failure, theft, and accidental deletion. The 3-2-1 rule is a widely used standard for reliable backups.',
        analogy:
            'Keeping a photocopy of your important documents in a different place means that a fire in one place does not destroy everything.',
        example:
            'The 3-2-1 backup rule:\n\n3 copies of your data\n2 different types of storage (for example laptop and external drive)\n1 copy stored offsite or offline (for example cloud or a disconnected drive)\n\nAlso:\n  Test restoring your backup regularly\n  Encrypt backups that hold sensitive data\n  Keep at least one copy that malware cannot reach',
        keyTakeaway:
            'A backup you have never tested is just a hope. Test restores, and keep at least one copy offline.',
      ),
      ConceptLesson(
        title: 'Reporting Incidents and Building a Security Culture',
        definition:
            'A strong security culture encourages people to report mistakes and suspicious activity quickly, without fear of blame. Early reporting turns incidents into minor events instead of major breaches.',
        analogy:
            'In aviation, pilots report near-misses openly, which makes flying safer for everyone. Security teams want the same openness.',
        example:
            'What to report immediately:\n\nSuspicious emails or calls\nLost or stolen devices\nAccidentally clicking a link or opening an attachment\nUnusual system behaviour or pop-ups\nUnknown people in restricted areas\n\nA healthy culture:\n  Reporting is thanked, not punished\n  Leaders follow the same rules\n  Short, regular training instead of one yearly lecture',
        keyTakeaway:
            'Blame silences people. If employees fear punishment, incidents stay hidden and get worse. Make reporting easy and safe.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does the 3-2-1 backup rule recommend?',
        options: [
          '3 copies, 2 types of storage, 1 copy offsite or offline',
          '3 passwords, 2 devices, 1 account',
          '3 firewalls, 2 antivirus programs, 1 server',
          '3 backups per year, 2 per month, 1 per week'
        ],
        correctIndex: 0,
        explanation:
            'Three copies on two kinds of storage with one stored offsite or offline protects against many failure and attack scenarios, including ransomware.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which document typically describes what employees may and may not do with company computers and networks?',
        options: [
          'Acceptable Use Policy',
          'Disaster Recovery Plan',
          'Marketing Plan',
          'Invoice Policy'
        ],
        correctIndex: 0,
        explanation:
            'The Acceptable Use Policy sets expectations for appropriate use of company systems and data.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'An employee realises they clicked a suspicious link. What is the best next step?',
        options: [
          'Say nothing and hope it was harmless',
          'Report it to the security team immediately',
          'Delete the browser and move on',
          'Wait a week to see if anything happens'
        ],
        correctIndex: 1,
        explanation:
            'Fast reporting lets the security team contain a possible compromise early. Delay gives attackers time.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You keep all your project files only on your laptop. The laptop is stolen. Which habit would have prevented total loss?',
        options: [
          'Using a longer laptop name',
          'Following the 3-2-1 backup rule, including an offsite or cloud copy',
          'Using a brighter screen',
          'Installing more games'
        ],
        correctIndex: 1,
        explanation:
            'Independent backups, including one in a different location, protect against theft, fire, hardware failure, and ransomware.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You need to check your bank balance while at a cafe with free public Wi-Fi. What is the safest choice?',
        options: [
          'Use the open Wi-Fi and enter details quickly',
          'Use your mobile data or a trusted VPN instead',
          'Share your password with the cafe staff',
          'Turn off your phone lock first'
        ],
        correctIndex: 1,
        explanation:
            'Open public Wi-Fi can be monitored or spoofed. Mobile data or a trusted VPN reduces the risk of interception.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Write a Mini Security Policy Pack',
      goal:
          'Draft a short, practical set of security policies and a personal cyber hygiene plan.',
      steps: [
        'Scenario: a 20-person software startup with no written security rules',
        'Write a one-page Acceptable Use Policy (6 to 8 clear rules)',
        'Write a Password and MFA Policy (minimum length, MFA required where, password manager use)',
        'Write a short Incident Reporting procedure with who to contact and what details to give',
        'Define a 3-2-1 backup plan for the company source code and documents',
        'Create a personal 10-point cyber hygiene checklist and tick off what you already do',
      ],
      expectedOutput:
          'Mini Policy Pack\n\nAcceptable Use Policy (7 rules)\n  1. Company laptops used for work only\n  2. No installing unapproved software\n  ...\n\nPassword Policy: 14+ characters, password manager, MFA on email, code repo, and cloud\n\nIncident Reporting: report within 1 hour to security@company; include time, what happened, screenshots\n\nBackup Plan: 3 copies (laptop, NAS, cloud), weekly restore test\n\nPersonal checklist: 7/10 done, 3 to improve ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 10
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l1_ethics_legal',
    topicTitle: 'Cyber Security Ethics and Legal Basics',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 200,
    emoji: '⚖️',
    intro:
        'Security professionals hold powerful skills. The line between a career in security and a criminal record is authorisation. This lesson covers ethical principles, the types of hackers, and the legal framework, with a focus on India, that every security professional must respect.',
    concepts: [
      ConceptLesson(
        title: 'Ethical Principles for Security Professionals',
        definition:
            'Ethics in cyber security means using technical skills responsibly: respecting privacy, acting with integrity, obtaining permission, protecting confidential information, and avoiding harm.',
        analogy:
            'A locksmith can open any door. What makes them a trusted professional is that they only open doors they are authorised to open. Hackers with ethics work the same way.',
        example:
            'Core principles:\n\nAuthorisation: never test or access a system without written permission\nConfidentiality: protect any data you see during your work\nIntegrity: be honest in reports, never hide findings\nMinimise harm: avoid damaging systems or exposing user data\nProfessional competence: do not claim skills you do not have\nResponsible disclosure: report vulnerabilities to the owner first',
        keyTakeaway:
            'Skill without ethics is dangerous. Written authorisation is the single biggest difference between an ethical hacker and a criminal.',
      ),
      ConceptLesson(
        title: 'White, Black, and Grey Hat Hackers',
        definition:
            'Hackers are commonly grouped by intent and authorisation. White hats act legally with permission, black hats act illegally for personal gain or harm, and grey hats operate in between without permission but often without malicious intent.',
        analogy:
            'White hats are like hired security guards testing your locks. Black hats are burglars. Grey hats are strangers who test your gate uninvited and then tell you it was open, which is still not legal.',
        example:
            'Hat types:\n\nWhite hat: penetration testers, bug bounty hunters within scope\nBlack hat: ransomware gangs, fraudsters, data thieves\nGrey hat: test without permission, may report afterwards (still potentially illegal)\nRed team: authorised attackers simulating real adversaries\nBlue team: defenders who detect and respond\nPurple team: red and blue collaborating\n\nBug bounty platforms define scope and rules; stay inside them.',
        keyTakeaway:
            'Good intentions do not make unauthorised access legal. Always work inside the agreed scope and rules.',
      ),
      ConceptLesson(
        title: 'Cyber Law in India — The IT Act and Related Rules',
        definition:
            'India Information Technology Act, 2000 (amended 2008) is the main law dealing with cyber crime and electronic commerce. It defines offences such as unauthorised access, data theft, identity theft, and cheating online.',
        analogy:
            'Just as the Indian Penal Code defines physical crimes like theft and trespass, the IT Act defines their digital versions.',
        example:
            'Key provisions (overview):\n\nSection 43: unauthorised access, data damage, or disruption (civil liability / compensation)\nSection 66: computer-related offences with dishonest or fraudulent intent\nSection 66C: identity theft\nSection 66D: cheating by personation using computer resources\nSection 66E: violation of privacy\nSection 66F: cyber terrorism\nSection 67: publishing or transmitting obscene material\n\nOther relevant rules:\n  CERT-In directions (2022): report certain cyber incidents within 6 hours\n  Digital Personal Data Protection Act, 2023: consent-based handling of personal data\n\nNote: laws change. Always check the latest official text.',
        keyTakeaway:
            'Even "just testing" someone else system can break the law. Know the basic provisions, and consult legal advice for real engagements.',
      ),
      ConceptLesson(
        title: 'Privacy, Data Protection, and Global Standards',
        definition:
            'Privacy laws give individuals rights over their personal data and impose duties on organisations that collect it. Globally, GDPR (Europe) is the best-known example, and India DPDP Act 2023 follows similar ideas.',
        analogy:
            'Your personal data is like your house keys. A company holding them is a custodian with duties: use only with permission, protect them, and return or destroy them when asked.',
        example:
            'Common data protection principles:\n\nConsent: clear permission before collecting data\nPurpose limitation: use data only for the stated purpose\nData minimisation: collect only what is needed\nSecurity safeguards: protect data with reasonable controls\nBreach notification: inform authorities and affected people\nRights: access, correction, and erasure of personal data\n\nProfessional standards and frameworks:\n  ISO/IEC 27001, NIST Cybersecurity Framework, PCI DSS (card payments)',
        keyTakeaway:
            'Security and privacy go together. Protecting personal data is both an ethical duty and a legal requirement.',
      ),
      ConceptLesson(
        title: 'Responsible Disclosure and Scope',
        definition:
            'When you find a vulnerability, responsible disclosure means privately informing the owner, giving reasonable time to fix it, and not exploiting or publicly exposing it prematurely. Scope defines what you are allowed to test.',
        analogy:
            'If you notice a neighbour front door is unlocked, the right move is to tell them quietly, not walk in, take photos of their living room, or post about it on social media.',
        example:
            'Responsible disclosure steps:\n\n1. Stop at proof of the issue; do not access or copy real user data\n2. Report privately through the security contact or bug bounty programme\n3. Provide clear steps to reproduce and potential impact\n4. Allow reasonable time for a fix\n5. Do not publish details until the owner agrees or the agreed deadline passes\n\nBefore ANY testing, confirm: written permission, target list, allowed techniques, testing window, and emergency contact.',
        keyTakeaway:
            'Scope and written permission protect you. If something is not explicitly in scope, do not touch it.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the main difference between a white hat hacker and a black hat hacker?',
        options: [
          'The programming language they use',
          'White hats have authorisation and legal intent; black hats act illegally for gain or harm',
          'White hats are always paid more',
          'Black hats never use computers'
        ],
        correctIndex: 1,
        explanation:
            'Authorisation and intent separate ethical hacking from crime. Technical skills can be identical.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'You discover a vulnerability on a website that has no permission for you to test. What is the most responsible action?',
        options: [
          'Download user data as proof',
          'Publish the details online immediately',
          'Stop, avoid accessing data, and report it privately to the site security contact',
          'Sell the information to the highest bidder'
        ],
        correctIndex: 2,
        explanation:
            'Responsible disclosure means minimal contact, no data access, and a private report so the owner can fix it before attackers find it.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which Indian law is the primary legislation dealing with cyber crime and electronic commerce?',
        options: [
          'Information Technology Act, 2000',
          'Right to Education Act',
          'Motor Vehicles Act',
          'Companies Act only'
        ],
        correctIndex: 0,
        explanation:
            'The Information Technology Act, 2000 (amended in 2008) defines cyber offences and provides the legal framework for electronic transactions in India.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A client hires you to test their web application. During testing you notice a neighbouring server, owned by another company, looks vulnerable. What should you do?',
        options: [
          'Test it too since it is nearby',
          'Stay in scope, not touch it, and mention the observation to your client',
          'Attack it to prove your skills',
          'Post it on social media'
        ],
        correctIndex: 1,
        explanation:
            'Only systems explicitly in the agreed scope may be tested. Testing a third-party system without permission can be illegal, even if you are working for a client.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A startup collects users\' phone contacts "just in case we need them later". Which data protection principle does this violate?',
        options: [
          'Data minimisation and purpose limitation',
          'Backup rotation',
          'Salted hashing',
          'Network segmentation'
        ],
        correctIndex: 0,
        explanation:
            'Collecting data without a clear purpose breaks minimisation and purpose limitation. Collect only what you need and tell users why.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Ethical Hacker Code of Conduct and Case Analysis',
      goal:
          'Write your own professional code of conduct and analyse realistic ethical and legal scenarios.',
      steps: [
        'Write a personal Code of Conduct with 8 rules covering authorisation, confidentiality, honesty, privacy, and responsible disclosure',
        'Draft a one-page sample "permission to test" checklist: scope, targets, allowed methods, time window, contacts, data handling',
        'Case 1: a student finds an exposed database on a college website. Describe the legal risks and the right steps',
        'Case 2: a company wants you to test an employee phone without telling the employee. Identify the ethical and legal issues',
        'Case 3: a bug bounty finding is outside the programme scope. What do you do?',
        'Summarise 4 IT Act provisions and 2 data protection principles in your own words (check official sources for current text)',
      ],
      expectedOutput:
          'Code of Conduct (8 rules)\n  1. I test only with written authorisation\n  2. I protect any data I encounter\n  ...\n\nPermission checklist: scope, targets, methods, window, contacts, data handling\n\nCase 1: Stop, do not download data, report privately via security contact\nCase 2: Needs employee consent and legal review; privacy concerns\nCase 3: Do not test out-of-scope; contact programme owner first\n\nLaw summary: Sec 43, 66, 66C, 66D + consent and minimisation principles ✓',
      xpReward: 55,
    ),
  ),
];
