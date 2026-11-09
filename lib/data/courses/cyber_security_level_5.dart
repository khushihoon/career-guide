// ══════════════════════════════════════════════════════════════════════
// lib/data/courses/cyber_security_level_5.dart
// Cyber Security Engineer Path — LEVEL 5: Security Tools &
// Vulnerability Assessment (10 lessons)
// ══════════════════════════════════════════════════════════════════════
import '../../models/course_content_data.dart';

const List<TopicCourse> cyberSecurityLevel5 = [
  // ────────────────────────────────────────────────────────────────────
  // LESSON 1
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l5_va_fundamentals',
    topicTitle: 'Vulnerability Assessment Fundamentals',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 185,
    emoji: '🩺',
    intro:
        'You cannot fix what you cannot find. Vulnerability assessment is the discipline of systematically discovering, measuring, and tracking weaknesses before attackers exploit them. This lesson sets out the vocabulary, the process, and how assessment differs from penetration testing.',
    concepts: [
      ConceptLesson(
        title: 'What is a Vulnerability Assessment?',
        definition:
            'A vulnerability assessment is a structured process of identifying, classifying, and prioritising weaknesses in systems, networks, and applications. It tells you what is wrong and how serious it is, so you can decide what to fix first.',
        analogy:
            'It is a full health check-up for your infrastructure. The doctor measures blood pressure, cholesterol, and scans for problems, then gives you a ranked list of what needs attention.',
        example:
            'What an assessment produces:\n\nA list of assets that were checked\nWeaknesses found on each asset\nA severity rating for each finding\nEvidence showing why it was reported\nRecommended fixes\nA priority order for remediation\n\nWhat it does not do by itself:\n  Prove an attacker could really break in\n  Fix anything',
        keyTakeaway:
            'Assessment finds and ranks weaknesses. It is the foundation of every vulnerability management programme.',
      ),
      ConceptLesson(
        title: 'Vulnerability Assessment vs Penetration Testing',
        definition:
            'A vulnerability assessment is broad and mostly automated, aiming to list as many weaknesses as possible. A penetration test is narrower and manual, trying to chain weaknesses together to show real impact.',
        analogy:
            'An assessment is an inspector walking through a building noting every unlocked window. A penetration test is hiring someone to actually try to get in and reach the safe.',
        example:
            'Comparison:\n\nVulnerability assessment:\n  Goal: find and list weaknesses\n  Method: scanners plus review\n  Breadth: wide\n  Frequency: continuous or monthly\n  Output: prioritised findings list\n\nPenetration test:\n  Goal: prove what an attacker can achieve\n  Method: manual skills plus tools\n  Depth: deep on selected targets\n  Frequency: yearly or after major changes\n  Output: attack narrative and impact\n\nMature organisations do both.',
        keyTakeaway:
            'Use assessments for coverage and regular tracking, and penetration tests for depth and realistic impact.',
      ),
      ConceptLesson(
        title: 'Key Vocabulary: CVE, CWE, CVSS, NVD',
        definition:
            'CVE gives a public vulnerability a unique ID. CWE classifies the type of weakness. CVSS scores severity. NVD is the US database that enriches CVE records with scores and details.',
        analogy:
            'CVE is the case number, CWE is the type of crime, CVSS is the seriousness rating, and NVD is the public records office that holds the files.',
        example:
            'Examples:\n\nCVE-2021-44228: the Log4Shell vulnerability in a popular Java logging library\nCWE-89: SQL injection\nCWE-79: cross-site scripting\nCWE-798: hard-coded credentials\nCVSS base score: 0.0 to 10.0\n\nSeverity bands (CVSS v3.x):\n  0.1 to 3.9 Low\n  4.0 to 6.9 Medium\n  7.0 to 8.9 High\n  9.0 to 10.0 Critical',
        keyTakeaway:
            'CVE tells you which flaw, CWE tells you what kind, and CVSS tells you how bad in general. None of them tells you how bad it is in your environment.',
      ),
      ConceptLesson(
        title: 'The Vulnerability Management Lifecycle',
        definition:
            'Vulnerability management is a repeating cycle: discover assets, scan, analyse and prioritise, remediate, verify, and report. It never ends because new vulnerabilities and new systems appear constantly.',
        analogy:
            'It is like maintaining a garden: you survey it, pull the weeds, check they are gone, and then do it again next week because new weeds keep growing.',
        example:
            'Cycle:\n\n1. Discover: know every asset (you cannot protect unknown systems)\n2. Assess: scan and review\n3. Prioritise: by risk, not just score\n4. Remediate: patch, reconfigure, or mitigate\n5. Verify: re-scan to confirm the fix\n6. Report: metrics and trends\n7. Repeat\n\nUseful standards:\n  NIST SP 800-115 (technical testing guide)\n  CIS Controls (continuous vulnerability management)',
        keyTakeaway:
            'A scan that is run once and filed away is not vulnerability management. The cycle, the ownership, and the follow-up are what reduce risk.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which statement best describes the difference between a vulnerability assessment and a penetration test?',
        options: [
          'They are identical',
          'An assessment broadly finds and ranks weaknesses; a penetration test tries to exploit them to prove real impact',
          'A penetration test is always automated',
          'An assessment only checks passwords'
        ],
        correctIndex: 1,
        explanation:
            'Assessments give breadth and tracking. Penetration tests give depth by chaining weaknesses into realistic attack paths.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does CWE-89 refer to?',
        options: [
          'A specific product version',
          'The weakness class SQL injection',
          'A firewall setting',
          'A CVSS score'
        ],
        correctIndex: 1,
        explanation:
            'CWE catalogues types of weaknesses. CWE-89 is improper neutralisation of input in SQL commands, known as SQL injection.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is asset discovery the first step of vulnerability management?',
        options: [
          'It is optional',
          'You cannot assess or protect systems you do not know exist',
          'It reduces the cost of scanners',
          'It replaces patching'
        ],
        correctIndex: 1,
        explanation:
            'Unknown or forgotten assets are often the most dangerous because nobody patches or monitors them.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A scanner reports a CVSS 9.8 vulnerability on a server that is switched off and disconnected in a store room. What is the right conclusion?',
        options: [
          'It is the most urgent issue in the company',
          'The base score alone does not decide priority; exposure and asset status matter, so it should be confirmed and decommissioned or tracked accordingly',
          'Ignore the scanner forever',
          'Plug it back in to test'
        ],
        correctIndex: 1,
        explanation:
            'Severity must be interpreted in context. A powered-off, disconnected asset carries far less immediate risk than the base score suggests.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Management says: "We ran a scan last year, so we are covered." What is the best reply?',
        options: [
          'Agree, one scan is enough',
          'Explain that new vulnerabilities and assets appear continuously, so scanning and remediation must be a repeating cycle',
          'Say scanning is useless',
          'Ask for no further budget'
        ],
        correctIndex: 1,
        explanation:
            'Thousands of new CVEs are published every year, and environments change daily. Vulnerability management must be continuous.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Vulnerability Management Vocabulary and Process Map',
      goal:
          'Create a one-page reference that explains the key terms and the lifecycle with a real example.',
      steps: [
        'Write a short definition of vulnerability, threat, risk, CVE, CWE, CVSS, and NVD in your own words',
        'Look up one real CVE on the NVD website and record its ID, CWE, CVSS score, and affected product',
        'Draw the 7-step vulnerability management cycle and add one example action for each step',
        'Write a table comparing vulnerability assessment and penetration testing',
        'List 5 questions you would ask before starting an assessment at a new organisation',
        'Summarise in 3 sentences why context matters more than a raw CVSS score',
      ],
      expectedOutput:
          'Reference Sheet\n\nCVE example: CVE-2021-44228 | CWE-502/CWE-20 related | CVSS 10.0 | Apache Log4j\n\nLifecycle: Discover -> Assess -> Prioritise -> Remediate -> Verify -> Report -> Repeat\n\nVA vs PT table completed ✓\n\nQuestions: What assets exist? Who owns them? What is the scope? What is business critical? How often can we scan?\n\nContext summary written ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 2
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l5_roe_lab',
    topicTitle: 'Rules of Engagement, Authorisation & Building a Safe Lab',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 190,
    emoji: '📝',
    intro:
        'The most important skill in security testing is knowing what you are allowed to do. Before touching any tool you need written authorisation, a defined scope, and a safe place to practise. This lesson protects both you and the systems you test.',
    concepts: [
      ConceptLesson(
        title: 'Authorisation and the Law',
        definition:
            'Testing a system without permission can be a criminal offence, even if you mean well and cause no damage. Written authorisation from someone with the legal authority to approve testing is mandatory.',
        analogy:
            'A locksmith testing a door lock needs the owner permission first. Without it, the same action is breaking in.',
        example:
            'Why verbal approval is not enough:\n\nThe person approving may not own the system\nThird-party hosting or cloud providers may have their own rules\nIf something breaks, you need proof you were authorised\n\nThe authorisation should name:\n  Who approved and their authority\n  Exact systems and IP ranges\n  Dates and times allowed\n  Allowed and forbidden techniques\n  Emergency contacts\n\nIn India, unauthorised access can fall under the IT Act, 2000.',
        keyTakeaway:
            'No written authorisation, no testing. This rule has no exceptions, including for practice on public websites.',
      ),
      ConceptLesson(
        title: 'Scope and Rules of Engagement',
        definition:
            'Scope defines which systems are in and out of bounds. Rules of Engagement (RoE) define how testing may be carried out, when, and what to do if something goes wrong.',
        analogy:
            'Scope is the boundary of the property you are allowed to inspect. The RoE is the instruction sheet: which rooms, which hours, which tools, and whom to call in an emergency.',
        example:
            'Typical RoE items:\n\nIn-scope: 10.20.30.0/24 internal servers\nOut-of-scope: payment systems, third-party SaaS, production database writes\nAllowed: authenticated scanning, safe checks\nForbidden: denial of service, data destruction, social engineering\nTesting window: weekdays 22:00 to 04:00\nData handling: findings stored encrypted, deleted after the project\nStop conditions: stop and call the contact if a system becomes unstable\n\nIf you discover something out of scope, stop and report it.',
        keyTakeaway:
            'Staying inside scope is part of professionalism. If in doubt, ask before you act.',
      ),
      ConceptLesson(
        title: 'Building a Safe Home Lab',
        definition:
            'A home lab is an isolated environment where you can practise with intentionally vulnerable systems. It lets you learn tools legally and without risk to anyone else.',
        analogy:
            'It is a driving school practice ground. You can make mistakes there without endangering anyone on the road.',
        example:
            'Typical lab setup:\n\nHost machine with 16 GB RAM if possible\nVirtualBox or VMware\nHost-only or internal network, never bridged to your home network for vulnerable machines\nAttacker-side VM: a Linux distribution with security tools such as Kali\nTarget VMs built for practice:\n  Metasploitable 2 (intentionally vulnerable Linux)\n  DVWA (Damn Vulnerable Web Application)\n  OWASP Juice Shop\n  Windows evaluation VMs\n\nTake snapshots before each experiment so you can restore.',
        keyTakeaway:
            'Never connect intentionally vulnerable machines to the internet or your home network. Keep them on an isolated host-only network.',
      ),
      ConceptLesson(
        title: 'Legal Practice Platforms and Responsible Habits',
        definition:
            'Beyond your own lab, several platforms provide legal targets and guided learning. Good habits, such as note-taking and clean-up, make you a reliable professional.',
        analogy:
            'Practising on legal platforms is like playing in official leagues. The rules are clear, and everyone present has agreed to take part.',
        example:
            'Legal ways to practise:\n\nTryHackMe and Hack The Box (guided and competitive labs)\nOWASP WebGoat and Juice Shop\nPortSwigger Web Security Academy (free labs)\nCapture the Flag (CTF) events\nBug bounty programmes, strictly within published scope\n\nProfessional habits:\n  Keep dated notes of every command and result\n  Take screenshots as evidence\n  Record tool versions\n  Clean up any test accounts or files you created\n  Protect findings: they are sensitive',
        keyTakeaway:
            'Notes and evidence are as valuable as the findings themselves. Start the habit in your lab.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which of these is sufficient authorisation to begin testing a company network?',
        options: [
          'A verbal OK from a colleague',
          'Written approval from someone with authority, naming scope, dates, and rules',
          'Your own belief that it is for a good cause',
          'An email from a friend who works there'
        ],
        correctIndex: 1,
        explanation:
            'Written, specific authorisation from a person with the legal authority to approve testing protects everyone and is required.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'During an authorised test you find a vulnerable server that is NOT in your scope. What should you do?',
        options: [
          'Test it anyway since it is nearby',
          'Do not touch it, and report the observation to your contact',
          'Publish the details online',
          'Delete the server'
        ],
        correctIndex: 1,
        explanation:
            'Scope is a hard boundary. Report what you observed and ask for scope to be extended if needed.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should intentionally vulnerable VMs be kept on a host-only network?',
        options: [
          'To make them faster',
          'So that attackers on the internet or your home network cannot reach them',
          'Because they need less memory',
          'It is only a style preference'
        ],
        correctIndex: 1,
        explanation:
            'These machines are deliberately weak. Exposing them to a real network could allow actual attackers to compromise them.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A friend asks you to "quickly scan" their small business website to see if it is secure. They have not told their hosting provider. What is the best approach?',
        options: [
          'Scan it right away',
          'Get written permission from the actual owner, check the hosting provider policy, define scope, and then proceed',
          'Scan the hosting provider instead',
          'Refuse to ever help'
        ],
        correctIndex: 1,
        explanation:
            'The site owner must authorise testing, and hosting providers often have their own rules. Document scope and permission first.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You want to practise with Metasploitable 2 on your laptop. What is the safest network setting?',
        options: [
          'Bridged to your home Wi-Fi',
          'Host-only or internal network with no route to the internet',
          'Port-forwarded from your router',
          'Placed in a public cloud'
        ],
        correctIndex: 1,
        explanation:
            'A host-only or internal network keeps the vulnerable VM isolated from real networks.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Authorisation Template and Lab Build',
      goal:
          'Write a Rules of Engagement document and build an isolated practice lab.',
      steps: [
        'Draft a one-page RoE template with sections: parties, scope, exclusions, allowed techniques, forbidden actions, schedule, contacts, data handling, and stop conditions',
        'Fill it in for a fictional engagement against your own lab network',
        'Install VirtualBox or VMware and create a host-only network',
        'Import one attacker-side VM and one intentionally vulnerable target VM such as Metasploitable 2 or Juice Shop',
        'Verify the VMs can reach each other but have no route to the internet, and take a clean snapshot of each',
        'Start a testing notebook with a dated first entry describing your lab layout',
      ],
      expectedOutput:
          'Lab Ready\n\nRoE: signed by me as lab owner; scope 192.168.56.0/24; no DoS; window anytime\n\nNetwork: host-only 192.168.56.0/24\n  Attacker VM: 192.168.56.101\n  Target VM:   192.168.56.10\n\nIsolation check: no internet route ✓\nSnapshots: clean-baseline taken ✓\nNotebook entry 1 written ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 3
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l5_recon_discovery',
    topicTitle: 'Reconnaissance & Asset Discovery',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 195,
    emoji: '🗺️',
    intro:
        'Before you can assess anything you must know what exists. Reconnaissance and asset discovery build the map of an environment. Attackers do this first, and so should defenders, because forgotten assets are where breaches often begin.',
    concepts: [
      ConceptLesson(
        title: 'Passive vs Active Reconnaissance',
        definition:
            'Passive reconnaissance gathers information without touching the target systems, using public sources. Active reconnaissance interacts directly with the target, such as by probing ports, and therefore needs authorisation.',
        analogy:
            'Passive recon is studying a building from public maps and photographs. Active recon is walking up and trying the doors, which you may only do with permission.',
        example:
            'Passive sources:\n\nCompany website and job postings (technology hints)\nDNS records and certificate transparency logs\nWHOIS registration data\nSearch engines and public code repositories\nPublic breach and leak notices about the organisation\n\nActive techniques:\n  Ping sweeps\n  Port scans\n  Service banner checks\n  Web crawling\n\nOnly the active techniques require explicit permission.',
        keyTakeaway:
            'Start passive, stay quiet, and move to active techniques only when scope and permission cover them.',
      ),
      ConceptLesson(
        title: 'DNS and Certificate-Based Discovery',
        definition:
            'DNS records and certificate transparency logs reveal subdomains and services an organisation may have forgotten. These are common sources of shadow IT and exposed test systems.',
        analogy:
            'It is like checking the company phone directory and the building permits to find every office the company has opened, including ones nobody remembers.',
        example:
            'Useful lookups on domains you own or are authorised to review:\n\nnslookup or dig for A, MX, TXT, NS records\nCertificate transparency search (crt.sh) lists certificates issued for a domain, exposing subdomains such as test.example.com\nReverse DNS for IP ranges\n\nTypical findings:\n  Old staging or test sites still online\n  Forgotten admin portals\n  Subdomains pointing to services that no longer exist (subdomain takeover risk)\n\nTools: dig, amass, subfinder (authorised use only)',
        keyTakeaway:
            'Forgotten subdomains and test servers are frequent weak points. Your own organisation should find them before attackers do.',
      ),
      ConceptLesson(
        title: 'Network Discovery and Asset Inventory',
        definition:
            'Active discovery identifies live hosts and open services inside your authorised range. The results feed an asset inventory that records what each system is, who owns it, and how important it is.',
        analogy:
            'It is taking a roll call of every device on the network, writing down each name, role, and owner.',
        example:
            'Discovery methods:\n\nPing sweep: nmap -sn 192.168.56.0/24\nARP scan on local networks\nPassive monitoring of network traffic\nCloud provider inventory APIs\nConfiguration management databases (CMDB)\nEndpoint management and DHCP logs\n\nAn inventory should record:\n  Hostname and IP\n  Operating system and version\n  Owner and business purpose\n  Criticality (high, medium, low)\n  Exposure (internal or internet-facing)',
        keyTakeaway:
            'An inventory with owners and criticality turns a long scan report into a prioritised plan. Without it, nobody knows who must fix what.',
        codeSnippet:
            'nmap -sn 192.168.56.0/24\n\n# Lab network only. Record each live host in your inventory.',
      ),
      ConceptLesson(
        title: 'Shadow IT, Cloud Assets, and the Attack Surface',
        definition:
            'Shadow IT is any system or service used without the knowledge of the security team. Cloud and SaaS make it easy to create assets that never appear in traditional inventories, which expands the attack surface.',
        analogy:
            'It is like employees quietly renting extra offices around town without telling the head office. Nobody locks those doors because nobody knows they exist.',
        example:
            'Where hidden assets appear:\n\nCloud storage buckets created by a project team\nTest servers left running after a demo\nPersonal SaaS accounts used for company data\nForgotten VPN or remote access gateways\nIoT devices and printers\n\nControls:\n  Cloud asset discovery tools and tagging policies\n  Regular external attack surface scans\n  Procurement and approval processes\n  Employee awareness',
        keyTakeaway:
            'Continuous discovery matters because the environment changes daily. A one-time inventory goes stale within weeks.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which activity is passive reconnaissance?',
        options: [
          'Port scanning a target',
          'Reading public DNS records and certificate transparency logs',
          'Sending crafted packets to a server',
          'Logging in to a service'
        ],
        correctIndex: 1,
        explanation:
            'Passive recon uses public information without sending traffic to the target systems.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why can forgotten subdomains such as test.example.com be dangerous?',
        options: [
          'They make DNS faster',
          'They often run outdated or unmonitored software that attackers can find and abuse',
          'They improve security',
          'They cost nothing'
        ],
        correctIndex: 1,
        explanation:
            'Test and staging systems frequently miss patches and monitoring but may still be reachable from the internet.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What makes an asset inventory especially useful for prioritising fixes?',
        options: [
          'It lists IP addresses only',
          'It records owner, purpose, and criticality for each asset',
          'It is printed in colour',
          'It has the most recent scanner logo'
        ],
        correctIndex: 1,
        explanation:
            'Owner and criticality tell you who must fix an issue and how urgent it is for the business.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A certificate transparency search for your company domain shows legacy-portal.example.com, which nobody on the IT team recognises. What should you do?',
        options: [
          'Ignore it',
          'Investigate it as an unknown asset: confirm ownership, check exposure, and decommission or secure it',
          'Publish the name on social media',
          'Attack it to see what happens'
        ],
        correctIndex: 1,
        explanation:
            'Unknown internet-facing assets are high-risk. Identify the owner, assess exposure, and remove or secure it.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You scan an authorised /24 and find 37 live hosts, but the inventory lists only 30. What does this suggest?',
        options: [
          'The scanner is wrong',
          'There are 7 unmanaged or unknown devices that need to be identified and added or removed',
          'The inventory is perfect',
          'The network is faster'
        ],
        correctIndex: 1,
        explanation:
            'A mismatch between discovery results and the inventory reveals shadow or forgotten devices.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build an Asset Inventory of Your Lab',
      goal:
          'Discover the hosts in your lab network and record them in a structured inventory.',
      steps: [
        'Run a ping sweep of your lab subnet only and list all live hosts',
        'For each host record IP, hostname, operating system guess, and purpose',
        'Add columns for owner, criticality, and exposure (internal only in your lab)',
        'Do a passive review of a domain you own or a well-known public domain: DNS records and certificate transparency subdomains',
        'List any assets you were surprised to find and explain why they matter',
        'Save the inventory as a CSV file using the Python skills from Level 4',
      ],
      expectedOutput:
          'Asset Inventory (lab)\n\n192.168.56.10  metasploitable   Linux   practice target   owner: me  criticality: low  exposure: host-only\n192.168.56.101 attacker-vm     Linux   scanner           owner: me  criticality: medium\n\nPassive review: example domain has 6 subdomains in CT logs, 1 unexpected (old-test)\n\ninventory.csv saved ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 4
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l5_nmap_depth',
    topicTitle: 'Nmap in Depth',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 36,
    totalXp: 205,
    emoji: '📍',
    intro:
        'Nmap is the most widely used network discovery tool in the world. In Level 2 you used it for simple checks. Now you will learn its scan types, service detection, scripting engine, and output formats so you can use it like a professional, always inside your authorised scope.',
    concepts: [
      ConceptLesson(
        title: 'Scan Types and What They Mean',
        definition:
            'Nmap supports several scan techniques. The most common are the TCP connect scan, the SYN scan, and the UDP scan. Each balances speed, accuracy, and how much it shows up in logs.',
        analogy:
            'A connect scan is knocking and waiting for the door to open fully. A SYN scan is knocking, hearing someone answer, and walking away before the door is opened.',
        example:
            'Common scans (authorised targets only):\n\n-sT TCP connect scan: works without special privileges\n-sS SYN scan: faster and stealthier, needs root\n-sU UDP scan: slow but finds DNS, SNMP, and others\n-sn host discovery only\n-Pn skip discovery and treat hosts as up (useful when ping is blocked)\n-p 1-1024 specific ports, -p- all 65535 ports\n--top-ports 100 the most common ports\n\nResults: open, closed, filtered, open|filtered',
        keyTakeaway:
            'Choose the scan to match your goal. A full TCP scan plus a targeted UDP scan is a common baseline for a lab target.',
        codeSnippet:
            'nmap -sS -p 1-1024 192.168.56.10\nnmap -sU --top-ports 20 192.168.56.10\nnmap -p- 192.168.56.10',
      ),
      ConceptLesson(
        title: 'Service, Version, and OS Detection',
        definition:
            'Beyond open ports, Nmap can identify the service and version behind each port and guess the operating system. Version information is what lets you match services to known vulnerabilities.',
        analogy:
            'Knowing a door is open is useful. Knowing it is a 1998 model lock with a known flaw is far more useful.',
        example:
            'Options:\n\n-sV service and version detection\n-O operating system detection (needs root)\n-A aggressive: combines -sV, -O, default scripts, and traceroute\n--version-intensity 0 to 9 controls how hard it tries\n\nExample result:\n  21/tcp open ftp vsftpd 2.3.4\n  22/tcp open ssh OpenSSH 4.7p1\n  80/tcp open http Apache httpd 2.2.8\n\nMatch versions to CVE databases to find known weaknesses.\nNote: banners can be wrong or hidden, so verify findings.',
        keyTakeaway:
            'Version detection turns a port list into a vulnerability lead list. Treat results as leads to verify, not final proof.',
        codeSnippet: 'nmap -sV 192.168.56.10\nnmap -A 192.168.56.10',
      ),
      ConceptLesson(
        title: 'The Nmap Scripting Engine (NSE)',
        definition:
            'NSE runs scripts written in Lua to extend Nmap for tasks such as service discovery, safe checks, and vulnerability detection. Scripts are grouped into categories that indicate how risky they are.',
        analogy:
            'NSE scripts are like specialist attachments for a power tool. Some are gentle, such as measuring. Others are heavy duty and can disturb what you are working on.',
        example:
            'Script categories:\n\nsafe: should not affect the target\ndefault: run with -sC\ndiscovery: gather more information\nvuln: check for known vulnerabilities\nintrusive: may crash or disturb services\nbrute: password guessing\ndos: can cause denial of service\nexploit: attempts exploitation\n\nGood practice:\n  Start with default and safe scripts\n  Read the script description before running it\n  Never run intrusive, brute, dos, or exploit scripts without explicit permission in the RoE\n  Test on lab systems first',
        keyTakeaway:
            'Script categories are risk labels. Match them to your Rules of Engagement before you run anything.',
        codeSnippet:
            'nmap -sC -sV 192.168.56.10\nnmap --script safe -p 80 192.168.56.10\nnmap --script-help http-title',
      ),
      ConceptLesson(
        title: 'Timing, Output Formats, and Parsing Results',
        definition:
            'Timing templates control scan speed and noise. Output formats let you save results for reports and automation. XML output can be parsed by scripts, tying Nmap into your Python skills.',
        analogy:
            'Timing is how quickly the inspector walks through the building: too fast and they miss things or cause disruption, too slow and the job takes forever.',
        example:
            'Timing: -T0 to -T5 (paranoid to insane). Use -T3 default or -T4 on stable lab networks. Avoid -T5 on real systems.\n\nOutput:\n  -oN normal text\n  -oX XML\n  -oG grepable\n  -oA all three formats with one base name\n\nGood practice:\n  Always save results with -oA\n  Record date, scope, and command in your notes\n  Compare scans over time to spot changes\n\nParsing XML in Python: use a safe parser such as defusedxml when files may come from untrusted sources.',
        keyTakeaway:
            'Always save machine-readable output. A scan you cannot compare with the next one gives you no trend.',
        codeSnippet:
            'nmap -sV -oA lab-scan1 192.168.56.10\n\nimport xml.etree.ElementTree as ET\nroot = ET.parse("lab-scan1.xml").getroot()\nfor port in root.iter("port"):\n    state = port.find("state").get("state")\n    print(port.get("portid"), state)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which Nmap option performs service and version detection?',
        options: ['-sn', '-sV', '-oX', '-Pn'],
        correctIndex: 1,
        explanation:
            '-sV probes open ports to identify the running service and version.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which NSE script categories require explicit permission in the Rules of Engagement?',
        options: [
          'safe and default only',
          'intrusive, brute, dos, and exploit',
          'discovery only',
          'None, all are always allowed'
        ],
        correctIndex: 1,
        explanation:
            'These categories can disturb services, crash systems, or attempt access, so they must be explicitly authorised.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why should you save Nmap results with -oA?',
        options: [
          'It makes the scan faster',
          'It stores results in normal, XML, and grepable formats for reporting, automation, and comparison',
          'It hides the scan',
          'It disables version detection'
        ],
        correctIndex: 1,
        explanation:
            'Saved output provides evidence and lets you compare scans over time or parse them with scripts.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A host does not respond to ping, so a default Nmap run reports it as down, but you know it is up. Which option helps?',
        options: ['-Pn', '-oN', '-sV only', '-T0'],
        correctIndex: 0,
        explanation:
            '-Pn skips host discovery and scans the ports anyway, which helps when ICMP is blocked.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your scan shows 80/tcp open http Apache 2.2.8 on a lab target. What is the correct next step?',
        options: [
          'Declare the server hacked',
          'Look up known vulnerabilities for that version in CVE databases and verify them safely in the lab',
          'Delete Apache',
          'Close the lab'
        ],
        correctIndex: 1,
        explanation:
            'Version information gives leads. Research the CVEs for that version, then verify safely before reporting.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Nmap Baseline and Change Detection',
      goal:
          'Create a full scan baseline of your lab target, make a change, and detect it with a second scan.',
      steps: [
        'Run a TCP scan of all ports, a service and version scan, and a top-20 UDP scan on your lab target and save with -oA',
        'Run the default scripts (-sC) and record any notable results',
        'Write a Python script that reads the XML and prints a table of open ports, services, and versions',
        'Change the target: stop one service and start another, then rescan',
        'Write a second script or section that compares the two XML files and prints new, closed, and changed ports',
        'Document the exact commands, dates, and findings in your notebook',
      ],
      expectedOutput:
          'Baseline scan 1: 23 open ports\n  21 vsftpd 2.3.4 | 22 OpenSSH 4.7 | 80 Apache 2.2.8 | 3306 MySQL 5.0 ...\n\nChange: stopped ftp, started telnet\nScan 2 diff:\n  Closed: 21/tcp\n  New: 23/tcp telnet\n\nParser output table ✓ | Notebook updated ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 5
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l5_vuln_scanners',
    topicTitle:
        'Vulnerability Scanners: OpenVAS, Nessus & Authenticated Scanning',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 34,
    totalXp: 205,
    emoji: '📡',
    intro:
        'Nmap tells you what is running. A vulnerability scanner goes further by checking those services against thousands of known weaknesses and misconfigurations. This lesson covers how scanners work, how to configure them, and how to read their results critically.',
    concepts: [
      ConceptLesson(
        title: 'How Vulnerability Scanners Work',
        definition:
            'A scanner discovers hosts and services, then runs checks that look for known vulnerabilities and insecure settings by comparing versions, probing behaviour, and inspecting configuration. Checks are updated regularly through feeds.',
        analogy:
            'A scanner is an inspector with a huge checklist of known building defects. It walks around, tests each item, and records which ones apply.',
        example:
            'Popular tools:\n\nGreenbone / OpenVAS: open-source, community feed\nNessus: widely used commercial scanner (a limited free version exists for learning)\nQualys, Rapid7 InsightVM, Tenable: enterprise platforms\nNuclei: template-based scanner for web and network checks\n\nScan workflow:\n  Define targets\n  Choose a scan policy\n  Run the scan\n  Review and validate results\n  Export and track remediation\n\nAlways update the vulnerability feed before scanning.',
        keyTakeaway:
            'A scanner is only as good as its feed and configuration. Update first, choose the right policy, and review the results with judgement.',
      ),
      ConceptLesson(
        title: 'Authenticated vs Unauthenticated Scanning',
        definition:
            'An unauthenticated scan sees the system as an outsider. An authenticated (credentialed) scan logs in with an account and can inspect installed software, patch levels, and settings from the inside, giving far more accurate results.',
        analogy:
            'An outsider can only judge a house from the street. An invited inspector with a key can check the wiring, the pipes, and the smoke alarms.',
        example:
            'Comparison:\n\nUnauthenticated:\n  Shows what an external attacker can see\n  Fewer findings, more guesses from banners\n  Good for internet-facing exposure checks\n\nAuthenticated:\n  Reads installed packages and patch levels\n  Finds missing patches and weak local settings\n  Fewer false positives\n  Needs a dedicated, least-privilege scan account\n\nProtect the scan account: unique strong password or key, limited rights, monitored use, and removed when no longer needed.',
        keyTakeaway:
            'Run both: unauthenticated scans for the attacker view, and authenticated scans for accuracy and depth.',
      ),
      ConceptLesson(
        title: 'Configuring Scans Safely',
        definition:
            'Scan policies control which checks run, how fast, and how aggressive they are. Poorly tuned scans can overload fragile systems such as old printers, medical devices, and industrial controllers.',
        analogy:
            'A gentle health check is fine for everyone, but you would not stress-test an elderly patient the way you would an athlete.',
        example:
            'Configuration choices:\n\nTarget list and exclusions (for example, fragile systems)\nPort range and discovery method\nSafe checks only vs including potentially disruptive checks\nScan speed and number of parallel hosts\nTime window outside business hours\nCredentials for authenticated checks\n\nGood practice:\n  Notify system owners before scanning\n  Start with a small test group\n  Monitor target performance during the scan\n  Keep a record of the policy used',
        keyTakeaway:
            'A scan that crashes a production system is a self-inflicted incident. Tune, test, and communicate before scanning real environments.',
      ),
      ConceptLesson(
        title: 'Reading Results and Handling False Positives',
        definition:
            'Scanner output is a starting point, not a verdict. A false positive reports a problem that does not exist. A false negative misses a real one. Analysts validate findings before they are sent for remediation.',
        analogy:
            'A smoke detector that goes off at toast is a false positive. One that stays silent in a real fire is a false negative. You need to investigate the first and worry about the second.',
        example:
            'Typical causes of false positives:\n\nBackported security fixes: the version number looks old but the fix is applied\nBanner mismatch or hidden version\nShared hosting or proxies changing responses\nUnauthenticated guesses\n\nValidation steps:\n  Read the plugin description and evidence\n  Check the real package version and patch notes\n  Re-test manually in a safe way\n  Record the decision and reason for any exception\n\nTrack false positives so the policy can be tuned.',
        keyTakeaway:
            'Never forward raw scanner output as a final report. Validate, deduplicate, and explain each finding so owners trust the results.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main advantage of an authenticated scan?',
        options: [
          'It is always faster',
          'It can inspect installed software and settings from the inside, giving more accurate results',
          'It needs no credentials',
          'It hides the scanner'
        ],
        correctIndex: 1,
        explanation:
            'Credentialed access lets the scanner read patch levels and configuration directly, reducing guesswork and false positives.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A scanner flags an old-looking Apache version, but the vendor has backported the fix into the package. What is this?',
        options: [
          'A true positive',
          'A likely false positive that must be validated against the patch level',
          'A false negative',
          'A new CVE'
        ],
        correctIndex: 1,
        explanation:
            'Distributions often backport fixes without changing the version number, so version-based checks can be wrong.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should you notify system owners before running a scan on production systems?',
        options: [
          'It is not necessary',
          'Scans can cause load or disruption, and owners can prepare, monitor, or exclude fragile systems',
          'It makes scans legal after the fact',
          'It speeds up the scanner'
        ],
        correctIndex: 1,
        explanation:
            'Communication prevents surprises and lets owners protect fragile systems and watch for problems.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You must scan a hospital network that includes old infusion pumps known to crash on unusual traffic. What is the best approach?',
        options: [
          'Run the most aggressive policy to be thorough',
          'Exclude or specially handle the fragile devices, use safe checks, coordinate with the owners, and scan in a controlled window',
          'Skip the whole network',
          'Scan during peak patient hours'
        ],
        correctIndex: 1,
        explanation:
            'Safety comes first. Coordinate with owners, use gentle policies, and treat fragile devices separately.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'The scanner credentials are a domain administrator account shared with the whole team. What is the problem?',
        options: [
          'None, admin rights make scans better',
          'It violates least privilege and creates a high-value account that is easy to misuse or leak; use a dedicated, limited scan account',
          'Credentials are not allowed in scans',
          'Scans will run slower'
        ],
        correctIndex: 1,
        explanation:
            'Scan accounts should be dedicated, limited to what the scanner needs, and tightly monitored.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Run and Triage a Lab Vulnerability Scan',
      goal:
          'Scan your lab target with a vulnerability scanner and triage the results.',
      steps: [
        'Install Greenbone Community Edition (OpenVAS) or Nessus Essentials in your lab and update its feeds',
        'Run an unauthenticated scan of your lab target and export the report',
        'Create a limited scan account on the target and run an authenticated scan',
        'Compare the number and type of findings between the two scans',
        'Pick 5 findings, validate each (check the real version, test safely), and mark them true or false positive with reasons',
        'Write a short note on how you would tune the scan policy based on what you learned',
      ],
      expectedOutput:
          'Scan Comparison (lab target)\n\nUnauthenticated: 38 findings (4 critical, 9 high)\nAuthenticated: 71 findings (6 critical, 15 high)\n\nValidated 5 findings:\n  vsftpd backdoor banner -> true positive\n  Apache 2.2.8 outdated -> true positive\n  SSL cert mismatch -> true (informational)\n  MySQL weak config -> true\n  Samba version -> false positive (backported)\n\nTuning notes: exclude none (lab), enable safe checks only on real systems ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 6
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l5_web_scanning',
    topicTitle: 'Web Vulnerability Scanning: Nikto, OWASP ZAP & Burp Suite',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 36,
    totalXp: 205,
    emoji: '🕸️',
    intro:
        'Websites and web applications are among the most attacked parts of any organisation. Web scanners and intercepting proxies help you find weaknesses such as missing headers, outdated components, and injection points. You will practise only on deliberately vulnerable applications that you run yourself.',
    concepts: [
      ConceptLesson(
        title: 'How Web Application Testing Differs',
        definition:
            'Web applications have custom logic, so network scanners miss many of their flaws. Web testing tools crawl pages, observe requests and responses, and test inputs for known classes of problems.',
        analogy:
            'A network scanner checks the locks on the building doors. A web scanner walks inside and tests every form, button, and form field in the offices.',
        example:
            'Typical web findings:\n\nMissing security headers (Content-Security-Policy, X-Content-Type-Options, HSTS)\nInformation leakage in errors and banners\nOutdated JavaScript libraries\nInsecure cookies (missing Secure or HttpOnly flags)\nDirectory listing and exposed files\nInjection and cross-site scripting indicators\nWeak TLS settings\n\nThe OWASP Top 10 is the standard reference list for web risks.',
        keyTakeaway:
            'Web scanners find the common and easy issues quickly. Business-logic flaws still need manual testing and human thinking.',
      ),
      ConceptLesson(
        title: 'Nikto — Quick Web Server Checks',
        definition:
            'Nikto is an open-source scanner that checks web servers for outdated software, dangerous files, and common misconfigurations. It is fast and thorough but very noisy, so it is only for systems you are authorised to test.',
        analogy:
            'Nikto is a loud inspector who tries every known default door and cupboard in sequence. It finds a lot, but everyone in the building hears it.',
        example:
            'Basic use in your lab:\n\nnikto -h http://192.168.56.10\nnikto -h http://192.168.56.10 -o nikto.txt\n\nTypical findings:\n  Server banner reveals exact version\n  Default files or admin pages present\n  Missing headers\n  Outdated server software\n\nNotes:\n  Expect false positives\n  Generates a large number of log entries\n  Not suitable for stealthy testing',
        keyTakeaway:
            'Nikto is excellent for lab practice and quick baselines, but its output must be validated and its noise respected.',
        codeSnippet: 'nikto -h http://192.168.56.10 -o nikto-lab.txt',
      ),
      ConceptLesson(
        title: 'OWASP ZAP — Free and Powerful',
        definition:
            'OWASP ZAP (Zed Attack Proxy) is a free tool that sits between your browser and a web application, recording traffic, crawling the site, and running passive and active checks.',
        analogy:
            'ZAP is a transparent glass tunnel between you and the website. You see every request and response, and the tool studies them for weaknesses.',
        example:
            'ZAP workflow in your lab:\n\n1. Point your browser proxy at ZAP\n2. Browse the target (DVWA or Juice Shop) to build the site map\n3. Spider or crawl to find more pages\n4. Passive scan: analyses traffic without sending attacks (safe)\n5. Active scan: sends test payloads (only on targets you own or are authorised to test)\n6. Review alerts, each with risk level, evidence, and a suggested fix\n7. Export a report\n\nZAP also supports automation, such as baseline scans in CI pipelines.',
        keyTakeaway:
            'Start with passive scanning. Use active scanning only where it is permitted and cannot damage data.',
      ),
      ConceptLesson(
        title: 'Burp Suite and Manual Verification',
        definition:
            'Burp Suite is an intercepting proxy widely used by web testers. It lets you pause, inspect, modify, and replay individual requests. The free Community Edition is enough for learning manual techniques.',
        analogy:
            'If ZAP is an automatic scanner, Burp is a precision workbench where you can pick up a single request, examine it carefully, and change one detail at a time to see what happens.',
        example:
            'Core Burp tools:\n\nProxy: intercept and view traffic\nRepeater: resend a request after small changes\nDecoder: encode and decode data\nComparer: spot differences between responses\nIntruder: automated variation of inputs (rate limited in the Community Edition)\n\nHow it helps validate findings:\n  Confirm a scanner alert by replaying the request\n  Check whether a header or cookie really lacks a protection\n  Understand how the application handles unexpected input\n\nUse only against your lab apps or authorised targets.',
        keyTakeaway:
            'Automated tools raise questions, and manual verification answers them. A confirmed finding with clear evidence is worth ten raw alerts.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which of these is a typical finding from a web scan?',
        options: [
          'A missing Content-Security-Policy header',
          'A broken keyboard',
          'A full disk on your laptop',
          'A weak Wi-Fi signal'
        ],
        correctIndex: 0,
        explanation:
            'Missing or weak security headers are among the most common web configuration findings.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the safest first scan mode in OWASP ZAP?',
        options: [
          'Active scan against any website',
          'Passive scanning of traffic while you browse an application you own or are authorised to test',
          'Denial of service mode',
          'Brute force mode'
        ],
        correctIndex: 1,
        explanation:
            'Passive scanning observes traffic without sending attack payloads, so it is much less intrusive.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is Nikto described as noisy?',
        options: [
          'It plays audio',
          'It sends a very large number of requests that appear clearly in logs and monitoring',
          'It only scans at night',
          'It encrypts its traffic'
        ],
        correctIndex: 1,
        explanation:
            'Nikto makes thousands of requests for known files and paths, which is easy for defenders to spot.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'ZAP reports that a cookie lacks the HttpOnly flag on your lab app. What is the risk?',
        options: [
          'None',
          'Client-side scripts such as injected JavaScript could read the cookie, making session theft easier if a cross-site scripting flaw exists',
          'The cookie will expire',
          'The server will crash'
        ],
        correctIndex: 1,
        explanation:
            'HttpOnly prevents JavaScript from reading the cookie. Without it, an XSS flaw can steal the session identifier.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A colleague wants to run an active ZAP scan against the live customer website without permission "because it is just a scan". What do you say?',
        options: [
          'Go ahead',
          'No. Active scans send attack payloads and need written authorisation, a defined scope, and a safe window; test in a staging copy first',
          'Run it faster',
          'Use a VPN so nobody notices'
        ],
        correctIndex: 1,
        explanation:
            'Active scanning can alter data or disrupt services. It requires explicit authorisation and ideally a non-production environment.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Web Scan of an Intentionally Vulnerable App',
      goal:
          'Scan a local deliberately vulnerable application, validate findings manually, and write a short report.',
      steps: [
        'Run DVWA or OWASP Juice Shop in your isolated lab and confirm it is not reachable from the internet',
        'Run Nikto against it and save the output',
        'Configure ZAP as a proxy, browse the application, and review passive scan alerts',
        'Run a ZAP active scan against the lab app only, and export the alert list',
        'Using Burp Community or ZAP request tools, manually verify 3 findings and capture evidence',
        'Write a short report with for each finding: description, evidence, risk, and fix',
      ],
      expectedOutput:
          'Web Scan Report: DVWA (lab)\n\nNikto: 14 findings (server banner, default files, missing headers)\nZAP passive: 9 alerts | active: 21 alerts\n\nValidated findings:\n  1. Missing CSP header -> add header\n  2. Cookie without HttpOnly -> set flag\n  3. Directory listing on /config -> disable indexing\n\nEvidence screenshots saved ✓ | Report exported ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 7
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l5_config_compliance',
    topicTitle: 'Configuration & Compliance Auditing',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 200,
    emoji: '✅',
    intro:
        'Many breaches come not from unpatched software but from weak settings: default passwords, open ports, lax permissions. Configuration auditing checks systems against secure baselines such as the CIS Benchmarks, and compliance auditing proves that you follow required standards.',
    concepts: [
      ConceptLesson(
        title: 'Why Misconfiguration Matters',
        definition:
            'A misconfiguration is a setting that leaves a system weaker than it should be, even if all software is up to date. Misconfigurations are consistently among the leading causes of real-world breaches.',
        analogy:
            'A brand-new, high-quality lock is useless if it is left unlocked. The product is fine, but the way it is set up is the problem.',
        example:
            'Common misconfigurations:\n\nDefault credentials left in place\nOverly permissive file or share permissions\nUnnecessary services enabled\nWeak password and lockout policies\nCloud storage buckets open to the public\nVerbose error pages revealing internals\nLogging disabled\nOutdated TLS versions and weak ciphers',
        keyTakeaway:
            'Patching is not enough. Secure configuration is a separate discipline that needs its own checks.',
      ),
      ConceptLesson(
        title: 'Security Baselines: CIS Benchmarks and STIGs',
        definition:
            'A baseline is an agreed set of secure settings for a type of system. The CIS Benchmarks and DISA STIGs are widely used, community and government-reviewed guides with specific recommendations.',
        analogy:
            'A baseline is a building code for IT systems. Rather than every builder inventing their own rules, everyone follows the same tested standard.',
        example:
            'Baseline sources:\n\nCIS Benchmarks: for Linux, Windows, databases, cloud platforms, browsers\n  Level 1: practical settings with low business impact\n  Level 2: stricter, for high-security environments\nDISA STIGs: used by US defence organisations\nVendor hardening guides\n\nA benchmark item looks like:\n  Recommendation: Ensure SSH root login is disabled\n  Rationale: why it matters\n  Audit: how to check\n  Remediation: how to fix',
        keyTakeaway:
            'Adopt a recognised baseline, record any deviations with a reason, and re-check regularly.',
      ),
      ConceptLesson(
        title: 'Auditing Tools: Lynis, OpenSCAP, and CIS-CAT',
        definition:
            'Auditing tools automatically compare a system with a baseline and report which checks pass or fail. They save hours of manual review and make results repeatable.',
        analogy:
            'It is an inspector with the building code on a clipboard, ticking off each rule as pass or fail.',
        example:
            'Tools:\n\nLynis: open-source Linux auditing (lynis audit system)\nOpenSCAP: scans against SCAP content such as the SCAP Security Guide\nCIS-CAT: CIS own assessment tool\nMicrosoft security baselines and Intune compliance reports\nCloud: AWS Config, Security Hub, Azure Policy\n\nWorkflow:\n  1. Choose the right baseline for the OS and role\n  2. Run the audit\n  3. Review failures by risk\n  4. Fix or document accepted exceptions\n  5. Re-run and keep the report as evidence',
        keyTakeaway:
            'Auditing tools give you a score and a to-do list. Re-running them after fixes proves improvement.',
        codeSnippet:
            'sudo lynis audit system\n\n# Review warnings and suggestions, fix in a lab, then run it again.',
      ),
      ConceptLesson(
        title: 'Compliance Frameworks and Evidence',
        definition:
            'Compliance means meeting the requirements of laws, standards, or contracts. Frameworks such as ISO 27001, PCI DSS, SOC 2, and India DPDP Act 2023 require organisations to show that controls exist and work.',
        analogy:
            'Compliance is passing a regulated exam: you must not only know the answer but also show your working and keep the paper for the inspector.',
        example:
            'Examples:\n\nISO/IEC 27001: information security management system\nPCI DSS: protecting payment card data (includes regular vulnerability scanning)\nSOC 2: service organisation controls reports\nHIPAA: health data in the US\nDPDP Act 2023 (India): personal data protection duties\n\nEvidence auditors expect:\n  Scan and audit reports with dates\n  Remediation tickets and closure proof\n  Policies and exception approvals\n  Logs showing continuous monitoring\n\nCompliance is not the same as security: a company can pass an audit and still be vulnerable.',
        keyTakeaway:
            'Treat compliance as a minimum floor. Good security goes beyond the checklist, and good evidence makes audits painless.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which statement about misconfiguration is true?',
        options: [
          'Fully patched systems cannot be misconfigured',
          'A fully patched system can still be insecure because of weak or default settings',
          'Misconfiguration only affects Windows',
          'It is rarely a cause of breaches'
        ],
        correctIndex: 1,
        explanation:
            'Patching fixes software flaws, but insecure settings are a separate and very common source of exposure.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What are CIS Benchmarks?',
        options: [
          'A type of malware',
          'Consensus-based secure configuration guides for many platforms',
          'A cloud billing tool',
          'A programming language'
        ],
        correctIndex: 1,
        explanation:
            'CIS Benchmarks are widely used hardening guides that list secure settings with audit and remediation steps.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is passing a compliance audit not the same as being secure?',
        options: [
          'Audits are always wrong',
          'Compliance sets a minimum standard at a point in time, while real attackers exploit gaps beyond the checklist',
          'Audits only check physical security',
          'Compliance is illegal'
        ],
        correctIndex: 1,
        explanation:
            'A checklist cannot cover every threat, and controls may drift after the audit. Security needs continuous effort.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A Lynis audit of a new server shows 15 suggestions. A manager asks you to fix all of them tonight on production. What is the best approach?',
        options: [
          'Apply everything immediately',
          'Prioritise by risk, test changes in a lab or staging, schedule a change window, and document any accepted exceptions',
          'Ignore the report',
          'Delete the server'
        ],
        correctIndex: 1,
        explanation:
            'Hardening changes can break applications. Prioritise, test, and change in a controlled way.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A PCI DSS assessor asks how you prove that vulnerability scanning happens regularly. What evidence do you give?',
        options: [
          'A verbal promise',
          'Dated scan reports, remediation tickets, and re-scan results showing issues were closed',
          'A photo of the server room',
          'The scanner license'
        ],
        correctIndex: 1,
        explanation:
            'Auditors look for dated evidence that scans occur and that findings are tracked to closure.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Baseline Audit and Remediation Cycle',
      goal:
          'Audit a lab Linux server against a baseline, remediate selected findings, and prove the improvement.',
      steps: [
        'Choose a lab Linux VM and run a Lynis audit, saving the report and hardening index',
        'Pick 8 failed or suggested items and map each to a CIS Benchmark recommendation (look them up)',
        'Classify each by risk and by effort to fix',
        'Fix at least 5 of them in the lab and record the exact changes',
        'Re-run the audit and compare the score and failed items before and after',
        'Write an exceptions list: any item you chose not to fix, with the reason and an approver',
      ],
      expectedOutput:
          'Baseline Audit\n\nBefore: hardening index 56, warnings 5, suggestions 41\nFixed 5: SSH root login off, password ageing, unused services disabled, file permissions, auditd enabled\nAfter: hardening index 73, warnings 2\n\nExceptions: 3 items (compatibility with legacy app), approved by lab owner\n\nEvidence saved: before.txt, after.txt, change-log.md ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 8
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l5_validation_frameworks',
    topicTitle:
        'Validating Findings Safely & Understanding Exploitation Frameworks',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 32,
    totalXp: 205,
    emoji: '🧪',
    intro:
        'Scanners report possibilities. Validation turns a possibility into a confirmed, explained finding. Professionals sometimes use exploitation frameworks to prove impact, but only within explicit authorisation. This lesson explains the purpose, the limits, and the safe habits, without turning into an attack manual.',
    concepts: [
      ConceptLesson(
        title: 'Why Validation Matters',
        definition:
            'Validation confirms that a reported vulnerability really exists and is reachable in your environment. It reduces false positives, builds trust with system owners, and helps you judge real impact.',
        analogy:
            'A smoke alarm says there might be a fire. Validation is walking over and checking whether it is burnt toast or an actual blaze before calling the fire brigade.',
        example:
            'Levels of validation (least to most intrusive):\n\n1. Review: read the evidence and plugin output\n2. Version check: confirm package versions and patch notes\n3. Safe probe: a harmless request that confirms the condition\n4. Configuration check: inspect the setting directly\n5. Controlled proof: demonstrate impact in a lab or an explicitly authorised test\n\nAlways use the least intrusive method that gives a reliable answer.',
        keyTakeaway:
            'Most findings can be validated without exploiting anything. Choose the gentlest method that gives certainty.',
      ),
      ConceptLesson(
        title: 'What Exploitation Frameworks Are For',
        definition:
            'Exploitation frameworks, such as Metasploit, organise and automate tested techniques so professionals can demonstrate that a weakness is truly exploitable. They are legitimate tools used by penetration testers and defenders to test detections.',
        analogy:
            'A crash-test facility deliberately crashes cars to prove how safe they are. The testing is controlled, agreed, and done to improve safety, not to hurt people.',
        example:
            'Legitimate uses:\n\nProve that a critical vulnerability is exploitable, to justify urgent patching\nMeasure how far an attacker could get from one weakness\nTest whether security monitoring detects an attack\nTrain defenders in a lab\n\nWhere they belong:\n  Authorised penetration tests with clear RoE\n  Your own isolated lab with deliberately vulnerable machines\n\nWhere they do not belong:\n  Any system you do not own or have written permission to test\n  Production systems without explicit approval and a rollback plan',
        keyTakeaway:
            'The tool does not make an action ethical. Authorisation, scope, and purpose do. Practise only in your isolated lab.',
      ),
      ConceptLesson(
        title: 'Risks of Testing and How to Control Them',
        definition:
            'Proving a vulnerability can crash services, corrupt data, or leave behind access. Controlled testing limits these risks with preparation, communication, and clean-up.',
        analogy:
            'A surgeon prepares, has a team, a plan, and equipment ready before the first cut. Testing live systems deserves the same discipline.',
        example:
            'Risk controls:\n\nBackups and snapshots before testing\nA written plan and a named contact who can stop the test\nTesting in staging when possible\nAvoiding data modification and destruction\nUsing proof that is harmless, such as reading a non-sensitive file or creating a clearly named marker\nRecording every step with timestamps\nRemoving anything you created afterwards\nStopping immediately if something unexpected happens\n\nReport honestly what was and was not proven.',
        keyTakeaway:
            'Prove the minimum needed to make the risk clear. Never go further than the approved scope, even if you could.',
      ),
      ConceptLesson(
        title: 'Writing Evidence That Others Can Reproduce',
        definition:
            'A validated finding should include enough evidence for another professional to confirm it. Good evidence is precise, minimal, and free of unnecessary sensitive data.',
        analogy:
            'It is a lab report: someone else should be able to repeat your steps and get the same result.',
        example:
            'Good evidence includes:\n\nAffected host and service, with date and time\nTool and version used\nExact request or command (with secrets removed)\nThe relevant part of the output or a screenshot\nWhy this proves the vulnerability exists\nWhat you did NOT do (for example, no data was read or changed)\n\nProtect evidence:\n  Redact passwords, tokens, and personal data\n  Store files encrypted\n  Delete according to the agreed retention period',
        keyTakeaway:
            'Clear, redacted evidence earns trust and speeds up fixes. Vague claims get ignored.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which validation approach should you try first?',
        options: [
          'The most intrusive technique available',
          'The least intrusive method that gives a reliable answer, such as a version check or configuration inspection',
          'Deleting data to prove impact',
          'Skipping validation'
        ],
        correctIndex: 1,
        explanation:
            'Start gentle. Many findings can be confirmed by reviewing evidence, versions, or settings without exploiting anything.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'When is it appropriate to use an exploitation framework?',
        options: [
          'Against any system reachable from the internet',
          'In your own isolated lab or within a clearly authorised engagement',
          'On a friend network without telling them',
          'During a job interview demonstration on a real site'
        ],
        correctIndex: 1,
        explanation:
            'Use is justified only by explicit authorisation and defined scope, or by practising against your own lab systems.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should you record the steps and timestamps of validation testing?',
        options: [
          'To fill the report with pages',
          'So that others can reproduce the result and so there is a clear record of what you did and when',
          'To hide mistakes',
          'To increase the CVSS score'
        ],
        correctIndex: 1,
        explanation:
            'Precise records support reproducibility, accountability, and incident analysis if something goes wrong during testing.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You can confirm a critical remote vulnerability on a production server by reading its exact patch level. A colleague suggests actually exploiting it "to be sure". What is the better approach?',
        options: [
          'Exploit it right away',
          'Use the version and patch evidence, report it with high confidence, and only attempt controlled proof if the RoE permits and the owner agrees',
          'Ignore it',
          'Shut the server down'
        ],
        correctIndex: 1,
        explanation:
            'If reliable non-intrusive evidence exists, exploitation adds risk without much benefit. Controlled proof needs explicit approval.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'While validating a finding you accidentally see customer personal data. What should you do?',
        options: [
          'Copy it for the report',
          'Stop accessing it, avoid saving or sharing it, and report the exposure to your contact according to the data-handling rules',
          'Post a screenshot online',
          'Keep it for later reference'
        ],
        correctIndex: 1,
        explanation:
            'Minimise data exposure, do not retain it, and report it. The exposure itself is a finding.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Validation Notes for Five Lab Findings',
      goal:
          'Validate selected scanner findings in your lab using the gentlest reliable method and write reproducible evidence.',
      steps: [
        'Take 5 findings from your earlier lab scans (network and web)',
        'For each, choose a validation level from the list (review, version check, safe probe, configuration check)',
        'Carry out the validation in your isolated lab and capture evidence: command, output, and a screenshot',
        'Mark each finding confirmed, false positive, or needs more information, with a one-line reason',
        'Write what you did NOT do for each finding, to show you stayed minimal',
        'Redact any secrets and store the evidence folder encrypted',
      ],
      expectedOutput:
          'Validation Log (lab)\n\n1. Outdated Apache 2.2.8 -> version check -> confirmed\n   Evidence: banner + package version; not exploited\n2. Missing HttpOnly flag -> inspected response headers -> confirmed\n3. Samba CVE flagged -> package patch notes -> false positive (backported)\n4. FTP anonymous access -> safe login check -> confirmed; no files read\n5. SSL weak cipher -> TLS scan output -> confirmed\n\nEvidence folder encrypted ✓ | Secrets redacted ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 9
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l5_risk_prioritisation',
    topicTitle: 'Risk Prioritisation with CVSS, EPSS & CISA KEV',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 34,
    totalXp: 210,
    emoji: '📊',
    intro:
        'A scan of a mid-sized company can produce tens of thousands of findings, and there is never enough time to fix them all. Prioritisation is the skill of deciding what to fix first. It combines severity scores, real-world exploit data, and business context.',
    concepts: [
      ConceptLesson(
        title: 'CVSS: What It Measures and What It Does Not',
        definition:
            'The Common Vulnerability Scoring System rates how severe a vulnerability is in general, using factors such as attack vector, complexity, privileges required, user interaction, and impact on confidentiality, integrity, and availability.',
        analogy:
            'CVSS is like a crash-test star rating for a car model. It says how dangerous the model is in standard conditions, but not how likely you are to crash, or how valuable the passenger is.',
        example:
            'Metric groups:\n\nBase: intrinsic qualities of the flaw (the score most reports show)\nTemporal (v3.x) or Threat (v4.0): exploit maturity and fix availability\nEnvironmental: your own context, such as asset importance and existing controls\n\nExample vector:\n  AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H = 9.8 Critical\n  Network attack, low complexity, no privileges, no user interaction, high impact\n\nVersions: v3.1 is widely used and v4.0 was published in late 2023. Know which one your tools report.',
        keyTakeaway:
            'The base score is only the starting point. Environmental context can raise or lower real priority a lot.',
      ),
      ConceptLesson(
        title: 'EPSS: How Likely Is Exploitation?',
        definition:
            'The Exploit Prediction Scoring System (EPSS) estimates the probability that a vulnerability will be exploited in the wild within the next 30 days, as a value from 0 to 1 (0 to 100 percent).',
        analogy:
            'CVSS is how bad the damage would be if the car crashed. EPSS is the weather forecast: how likely a crash is soon.',
        example:
            'Why EPSS helps:\n\nMost published vulnerabilities are never exploited\nA small percentage account for nearly all attacks\nA CVSS 9.8 with an EPSS of 0.1 percent may be less urgent than a CVSS 7.5 with an EPSS of 80 percent\n\nUsage:\n  Check the EPSS score for each CVE\n  Combine with CVSS and asset context\n  Re-check over time, because scores change as new exploit activity appears',
        keyTakeaway:
            'Severity says how bad. EPSS says how likely. You need both to prioritise intelligently.',
      ),
      ConceptLesson(
        title: 'CISA KEV and Threat Intelligence',
        definition:
            'The CISA Known Exploited Vulnerabilities (KEV) catalog lists vulnerabilities that are confirmed to be actively exploited. Anything on KEV that exists in your environment deserves immediate attention.',
        analogy:
            'KEV is a list of doors that burglars are known to be breaking through right now. If you have one of those doors, fixing it comes before everything else.',
        example:
            'Using KEV:\n\nCompare your scan results with the KEV list\nTreat matches as top priority, especially on internet-facing systems\nNote the due dates and required actions CISA publishes\nCombine with vendor advisories and threat reports\n\nOther sources:\n  Vendor security bulletins\n  National CERT alerts (for India, CERT-In advisories)\n  Threat intelligence feeds\n  Public exploit availability and reports of active campaigns',
        keyTakeaway:
            'Known exploitation is the strongest signal of urgency. A KEV match on an exposed system should jump the queue.',
      ),
      ConceptLesson(
        title: 'Building a Practical Prioritisation Model',
        definition:
            'A good model combines severity, exploit likelihood, asset criticality, exposure, and compensating controls into a simple priority and a fix deadline that teams can follow.',
        analogy:
            'A hospital triage nurse considers how serious the injury is, how fast it is getting worse, and who the patient is. Prioritising vulnerabilities uses the same layered thinking.',
        example:
            'Example decision factors:\n\n1. On KEV or exploited in the wild? -> Priority 1\n2. Internet-facing and CVSS 9.0 or higher? -> Priority 1\n3. High EPSS on a critical internal asset? -> Priority 2\n4. High severity on a low-value isolated system? -> Priority 3\n5. Everything else -> routine patch cycle\n\nSample SLAs:\n  Priority 1: 48 hours to 7 days\n  Priority 2: 14 to 30 days\n  Priority 3: 60 to 90 days\n\nDocument exceptions with compensating controls and an approver.',
        keyTakeaway:
            'Agree on the model and SLAs in advance with the business. Predictable rules prevent endless debates during every scan.',
        codeSnippet:
            'def priority(cvss, epss, on_kev, internet_facing, critical_asset):\n    if on_kev:\n        return 1\n    if internet_facing and cvss >= 9.0:\n        return 1\n    if critical_asset and epss >= 0.5:\n        return 2\n    if cvss >= 7.0:\n        return 3\n    return 4\n\nprint(priority(9.8, 0.9, True, True, True))',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does EPSS estimate?',
        options: [
          'The cost of a patch',
          'The probability that a vulnerability will be exploited in the wild in the next 30 days',
          'The number of users affected',
          'The age of the software'
        ],
        correctIndex: 1,
        explanation:
            'EPSS gives a likelihood of exploitation, complementing CVSS which measures severity.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A vulnerability on your internet-facing server appears in the CISA KEV catalog. How should you treat it?',
        options: [
          'Routine monthly patching',
          'Top priority, because it is known to be actively exploited',
          'Ignore it until the next audit',
          'Wait for a higher CVSS score'
        ],
        correctIndex: 1,
        explanation:
            'KEV listing confirms real-world exploitation, so fixing it on exposed systems is urgent.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is CVSS base score alone not enough for prioritisation?',
        options: [
          'It is always wrong',
          'It ignores your asset importance, exposure, existing controls, and real exploitation activity',
          'It only covers Windows',
          'It changes every minute'
        ],
        correctIndex: 1,
        explanation:
            'Base scores describe the flaw in general. Environment and threat context determine real risk.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You have two findings. A: CVSS 9.8, EPSS 0.2 percent, internal test server with no data. B: CVSS 7.5, EPSS 85 percent, on KEV, internet-facing payment gateway. Which first?',
        options: [
          'A, because the CVSS is higher',
          'B, because it is exploited, exposed, and on a critical asset',
          'Neither',
          'Both are identical'
        ],
        correctIndex: 1,
        explanation:
            'Active exploitation, internet exposure, and asset criticality make B far more urgent despite the lower base score.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'The business cannot patch a critical legacy system for 3 months. What is the best response?',
        options: [
          'Accept the risk silently',
          'Document a risk exception with an approver and end date, and apply compensating controls such as network isolation, a WAF or virtual patch, and extra monitoring',
          'Delete the finding from the report',
          'Switch off all logging'
        ],
        correctIndex: 1,
        explanation:
            'When patching is not possible, reduce exposure through compensating controls and record formal, time-limited approval.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Prioritise a Findings List',
      goal:
          'Build a prioritisation model and apply it to a set of findings from your lab and a sample list.',
      steps: [
        'Take 15 findings (from your lab scans plus a few invented ones) with CVE, CVSS, and affected asset',
        'Look up the EPSS score and CISA KEV status for each real CVE using the public sources',
        'Add asset columns: criticality (1 to 3) and exposure (internal or internet-facing)',
        'Write a Python function based on the lesson example and tune it to your own rules',
        'Rank all findings, assign priority 1 to 4, and set a fix deadline for each',
        'Write a half-page explanation for the 3 findings where your ranking differs most from sorting by CVSS alone',
      ],
      expectedOutput:
          'Prioritised List\n\nP1  CVE-xxxx-1  CVSS 7.5  EPSS 0.85  KEV yes  internet  -> fix in 48h\nP1  CVE-xxxx-2  CVSS 9.8  EPSS 0.60  internet         -> 7 days\nP2  CVE-xxxx-3  CVSS 8.1  EPSS 0.55  internal critical -> 30 days\nP4  CVE-xxxx-9  CVSS 9.1  EPSS 0.002 isolated test      -> routine\n\nCVSS-only order differs on 6 of 15 items\nExplanation written ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 10
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l5_reporting_capstone',
    topicTitle: 'Reporting, Remediation & Capstone Vulnerability Assessment',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 45,
    totalXp: 240,
    emoji: '🏆',
    intro:
        'Findings only reduce risk when they are understood and fixed. A great report persuades busy people to act, and a good remediation process makes sure problems stay fixed. This capstone ties together every tool and idea of Level 5 into a complete, professional vulnerability assessment of your lab.',
    concepts: [
      ConceptLesson(
        title: 'Anatomy of a Good Vulnerability Report',
        definition:
            'A vulnerability report communicates risk to different audiences: executives need the big picture, and engineers need exact details to fix problems. A strong report serves both.',
        analogy:
            'It is a medical report with a one-page summary for the patient and detailed lab results for the specialist.',
        example:
            'Suggested structure:\n\n1. Executive summary: scope, key risks, overall rating, top 3 actions\n2. Scope and methodology: targets, dates, tools, and limitations\n3. Summary of findings: counts by severity, charts, trends\n4. Detailed findings (one per issue):\n   Title and ID\n   Severity and CVSS (plus priority)\n   Affected assets\n   Description and impact\n   Evidence\n   Recommendation\n   References (CVE, vendor advisory)\n5. Appendices: raw outputs, tool versions, false positives list\n\nWrite for the reader: plain language in the summary, precision in the details.',
        keyTakeaway:
            'Lead with business impact and clear actions. A report nobody finishes reading fixes nothing.',
      ),
      ConceptLesson(
        title: 'Writing Findings That Get Fixed',
        definition:
            'Each finding should be specific, evidence-based, and actionable. Owners fix issues fastest when they know exactly what is wrong, why it matters, and what to do.',
        analogy:
            'A good repair ticket says which tap, what leak, how to fix it, and what happens if you wait. A bad ticket says "plumbing issue".',
        example:
            'Weak finding:\n  "The server is insecure. Please fix."\n\nStrong finding:\n  Title: Anonymous FTP enabled on fileserver01\n  Severity: High (priority 2)\n  Impact: Anyone on the internal network can read and upload files, enabling data exposure and malware staging\n  Evidence: anonymous login succeeded on 192.168.56.10:21 (screenshot, date, tool version)\n  Recommendation: disable anonymous access in the FTP configuration; consider SFTP\n  Verification: re-test shows anonymous login refused\n\nAvoid blame and jargon. Describe the system, not the person.',
        keyTakeaway:
            'Specific title, clear impact, reproducible evidence, concrete fix, and a way to verify. That formula works every time.',
      ),
      ConceptLesson(
        title: 'Remediation Tracking and Metrics',
        definition:
            'Remediation tracking follows each finding from discovery to verified closure using tickets, owners, and deadlines. Metrics show whether the programme is working.',
        analogy:
            'It is a project board where every problem has an owner, a due date, and a done column that only counts once someone has checked the fix.',
        example:
            'Process:\n\nCreate tickets in the team tracker (Jira, ServiceNow, GitHub issues)\nAssign an owner and due date based on priority\nTrack status: open, in progress, fixed, verified, accepted risk\nRe-scan to verify closure\nEscalate overdue critical items\n\nUseful metrics:\n  Mean time to remediate (MTTR) by severity\n  Percentage of scanned assets (coverage)\n  Open critical and high findings over time\n  SLA compliance rate\n  Recurring findings (signals a process problem)',
        keyTakeaway:
            'Measure what matters: coverage, speed of fixing, and recurrence. Trends tell the story better than single numbers.',
      ),
      ConceptLesson(
        title: 'Communicating and Building Trust',
        definition:
            'Security teams succeed when other teams see them as partners. How you communicate findings determines whether people cooperate or resist.',
        analogy:
            'A good safety inspector helps the workshop become safer, and is welcomed back. A harsh one who only criticises is avoided, and problems stay hidden.',
        example:
            'Habits that build trust:\n\nTalk to owners before sending the formal report\nExplain the reason, not just the rule\nOffer practical fixes and workarounds\nRecognise teams that fix things quickly\nBe honest about uncertainty and false positives\nRespect change windows and business constraints\nFollow up politely and track dates\n\nWhen disagreements arise, bring data and business impact, and escalate calmly through agreed paths.',
        keyTakeaway:
            'Technical skill finds problems, but communication gets them fixed. Both are part of the job.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Who is the executive summary of a vulnerability report mainly written for?',
        options: [
          'Only the scanner vendor',
          'Decision makers who need the big picture, key risks, and top actions in plain language',
          'Attackers',
          'Only penetration testers'
        ],
        correctIndex: 1,
        explanation:
            'Executives need a clear summary of risk and decisions required, without deep technical detail.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which of these makes a finding actionable?',
        options: [
          'A vague statement that the server is insecure',
          'Specific affected asset, clear impact, reproducible evidence, a concrete fix, and a verification step',
          'A long list of CVE numbers with no explanation',
          'Only a severity colour'
        ],
        correctIndex: 1,
        explanation:
            'Owners need to know exactly what to change and how to confirm success.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does mean time to remediate (MTTR) measure?',
        options: [
          'How long a scan takes',
          'The average time taken to fix vulnerabilities after they are found',
          'The number of scanners owned',
          'The time between audits'
        ],
        correctIndex: 1,
        explanation:
            'MTTR shows how quickly the organisation closes findings, and is a key indicator of programme effectiveness.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your report lists 4,000 findings sorted by scanner order, and nobody acts on it. What should you change first?',
        options: [
          'Add more findings',
          'Deduplicate, group by root cause and owner, prioritise by risk, and lead with the few actions that remove the most risk',
          'Make the font smaller',
          'Stop reporting'
        ],
        correctIndex: 1,
        explanation:
            'Grouping by root cause and prioritising turns an overwhelming list into a short, achievable plan.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A system owner disputes a finding, saying "that is a false positive". What is the best next step?',
        options: [
          'Insist they are wrong',
          'Review the evidence together, re-validate the finding, and update the status with a documented reason if it is indeed a false positive',
          'Delete the report',
          'Escalate to the CEO immediately'
        ],
        correctIndex: 1,
        explanation:
            'Collaborative re-validation builds trust and improves accuracy. Document the outcome either way.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Level 5 Capstone: Complete Vulnerability Assessment of Your Lab',
      goal:
          'Run a full assessment cycle on your isolated lab and deliver a professional report with a remediation plan and verification.',
      steps: [
        'Write a Rules of Engagement document and confirm your lab is isolated; take clean snapshots',
        'Discover assets and build an inventory with owner, criticality, and exposure',
        'Run Nmap (full TCP, service detection, top UDP) and save the output with -oA',
        'Run an authenticated and an unauthenticated vulnerability scan, plus Nikto and ZAP against your lab web application',
        'Audit one Linux VM against a baseline with Lynis or OpenSCAP',
        'Validate at least 8 findings with the gentlest method and mark true or false positives',
        'Prioritise with CVSS, EPSS, KEV, and asset context, and set deadlines',
        'Write the report: executive summary, scope, methodology, findings table, 8 detailed findings, and appendices',
        'Remediate at least 5 findings, rescan, and show before and after counts and closure evidence',
        'Publish the sanitised report and notes in a private or public portfolio repository without any secrets or real data',
      ],
      expectedOutput:
          'Vulnerability Assessment Report: Lab Network 192.168.56.0/24\n\nExecutive summary:\n  Overall risk: High. 3 critical and 7 high findings, mostly outdated services and weak configuration.\n  Top 3 actions: upgrade Apache, disable anonymous FTP, enforce SSH key login.\n\nMethodology: Nmap, OpenVAS (authenticated + unauthenticated), Nikto, ZAP, Lynis\n\nFindings: 61 raw -> 29 after deduplication -> 8 validated in detail\nPriority: P1 x3, P2 x5\n\nRemediation: 5 fixed; re-scan shows critical 3 -> 1, high 7 -> 3\nMTTR in lab: 2 days | Hardening index 56 -> 76\n\nAppendices: tool versions, raw outputs, false positive list ✓\nPortfolio repository with sanitised report ✓',
      xpReward: 90,
    ),
  ),
];
