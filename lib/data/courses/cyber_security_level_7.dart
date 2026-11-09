// ══════════════════════════════════════════════════════════════════════
// lib/data/courses/cyber_security_level_7.dart
// Cyber Security Engineer Path — LEVEL 7: Security Operations &
// Threat Detection (10 lessons)
// ══════════════════════════════════════════════════════════════════════
import '../../models/course_content_data.dart';

const List<TopicCourse> cyberSecurityLevel7 = [
  // ────────────────────────────────────────────────────────────────────
  // LESSON 1
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l7_soc_fundamentals',
    topicTitle: 'SOC Fundamentals: People, Process & Technology',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 190,
    emoji: '🛰️',
    intro:
        'Prevention will sometimes fail, so every organisation also needs people who watch for attacks and respond fast. A Security Operations Centre (SOC) is that watchtower. This lesson explains how a SOC is organised, what it uses, and how its success is measured.',
    concepts: [
      ConceptLesson(
        title: 'What a SOC Does',
        definition:
            'A Security Operations Centre is a team, with supporting processes and tools, that continuously monitors an organisation for security threats, investigates alerts, and coordinates the response to incidents.',
        analogy:
            'A SOC is the control room of a metro network. Screens show every station, operators watch for anything unusual, and when something goes wrong they know exactly who to call and what to do.',
        example:
            'Core SOC functions:\n\nContinuous monitoring of logs and alerts\nAlert triage and investigation\nIncident response and coordination\nThreat intelligence and threat hunting\nDetection engineering (writing and tuning rules)\nVulnerability and exposure awareness\nReporting and metrics\n\nOperating models:\n  In-house 24x7 SOC\n  Managed security service provider (MSSP / MDR)\n  Hybrid',
        keyTakeaway:
            'A SOC is not just a room of screens. It is a combination of people, process, and technology working around the clock.',
      ),
      ConceptLesson(
        title: 'SOC Roles and Tiers',
        definition:
            'SOC teams are often organised in tiers. Tier 1 triages alerts, Tier 2 investigates deeper and responds, and Tier 3 handles advanced threats, hunting, and engineering. A SOC manager and incident commander coordinate.',
        analogy:
            'It is a hospital emergency department: a triage nurse sorts patients, doctors treat them, and specialists handle the complex cases.',
        example:
            'Typical roles:\n\nTier 1 Analyst: monitors the queue, triages, closes false positives, escalates\nTier 2 Analyst: deep investigation, containment actions, incident handling\nTier 3 / Threat Hunter: proactive hunting, malware and forensic analysis\nDetection Engineer: builds and tunes detections\nThreat Intelligence Analyst: tracks threat actors and indicators\nIncident Commander: leads major incidents\nSOC Manager: staffing, metrics, and improvement\n\nEntry path: most careers start at Tier 1 and grow through Tier 2 into specialisations.',
        keyTakeaway:
            'Tier 1 is where most people start. Learn to triage well, document clearly, and escalate with good evidence.',
      ),
      ConceptLesson(
        title: 'The SOC Technology Stack',
        definition:
            'SOC tools collect data, detect threats, support investigation, and automate response. The core stack includes SIEM, EDR, network detection, threat intelligence, ticketing, and SOAR.',
        analogy:
            'The SIEM is the central camera wall. EDR cameras are on every laptop and server. Ticketing is the incident logbook, and SOAR is the set of automatic door locks that can close on command.',
        example:
            'Key technologies:\n\nSIEM: central log collection, correlation, alerting (Splunk, Elastic, Microsoft Sentinel, Wazuh, QRadar)\nEDR / XDR: endpoint visibility and response (CrowdStrike, Microsoft Defender, SentinelOne, Wazuh agents)\nNDR / IDS: network detection (Zeek, Suricata, Security Onion)\nThreat intelligence platform: MISP, commercial feeds\nCase management: TheHive, Jira, ServiceNow\nSOAR: automated playbooks (Cortex XSOAR, Shuffle, Splunk SOAR)\nEmail security and sandboxes',
        keyTakeaway:
            'Tools change, but the ideas stay the same: collect, detect, investigate, respond. Learn the concepts, then any product becomes easier.',
      ),
      ConceptLesson(
        title: 'Metrics, Shifts, and Avoiding Burnout',
        definition:
            'SOCs measure how fast they detect and respond, and how accurate their alerts are. Shift work and alert volume create a real risk of fatigue, so good SOCs design for sustainability.',
        analogy:
            'A lifeguard who watches the pool for 12 hours without a break will miss something. Good teams design shifts and alert quality so people stay sharp.',
        example:
            'Common metrics:\n\nMTTD: mean time to detect\nMTTR or MTTC: mean time to respond or contain\nAlert volume and false positive rate\nEscalation accuracy\nIncidents by category and severity\nCoverage of MITRE ATT&CK techniques\n\nHealthy practices:\n  Rotate shifts fairly\n  Tune noisy rules\n  Write clear playbooks\n  Hold post-incident reviews without blame\n  Invest in training',
        keyTakeaway:
            'Quality beats quantity. Fewer, better alerts and clear playbooks make a SOC faster and keep analysts effective.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main job of a Tier 1 SOC analyst?',
        options: [
          'Designing the company network',
          'Monitoring and triaging alerts, closing false positives, and escalating real threats with evidence',
          'Writing marketing material',
          'Managing payroll'
        ],
        correctIndex: 1,
        explanation:
            'Tier 1 is the first line: sort alerts, decide what is real, and pass credible incidents on with good notes.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does MTTD measure?',
        options: [
          'Mean time to deploy',
          'Mean time to detect a threat after it begins',
          'Maximum traffic to data',
          'Monthly total tickets'
        ],
        correctIndex: 1,
        explanation:
            'MTTD shows how quickly threats are noticed. Lower is better, because attackers have less time to act.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which tool is mainly used to collect logs from many sources and correlate events?',
        options: ['SIEM', 'Spreadsheet only', 'Antivirus', 'Router'],
        correctIndex: 0,
        explanation:
            'A SIEM centralises logs, normalises them, correlates events, and raises alerts.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A SOC receives 2,000 alerts a day, and 95 percent are false positives. Analysts are exhausted. What is the best long-term fix?',
        options: [
          'Hire more people to read everything',
          'Tune and prioritise detections, automate repetitive checks, and improve playbooks',
          'Turn off the SIEM',
          'Ignore low alerts permanently without review'
        ],
        correctIndex: 1,
        explanation:
            'Reducing noise and automating routine work improves both detection quality and analyst wellbeing.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A small company cannot afford a 24x7 team. Which option often makes sense?',
        options: [
          'No monitoring',
          'A managed detection and response (MDR) provider or hybrid model',
          'Only monitoring on weekdays',
          'Printing the logs'
        ],
        correctIndex: 1,
        explanation:
            'MDR services provide round-the-clock coverage without building a full internal team.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Design a SOC for a Mid-Sized Company',
      goal:
          'Plan the people, process, and technology of a small SOC for a 500-person company.',
      steps: [
        'Choose a company profile: a fintech with a web app, cloud workloads, and 500 employees',
        'Decide the operating model (in-house, MDR, or hybrid) and justify it',
        'Define roles and shifts for the first year, including the number of analysts per tier',
        'List the technology stack with one tool per category and the reason for the choice',
        'Define 8 metrics, with a target for each, and explain how you would collect them',
        'Write a one-page description of how an alert flows from detection to closure',
      ],
      expectedOutput:
          'SOC Design: FinCo\n\nModel: hybrid (in-house business hours, MDR overnight)\nStaffing: 4 Tier 1, 2 Tier 2, 1 detection engineer, 1 manager\nStack: Wazuh/Elastic SIEM, Defender EDR, Suricata, MISP, TheHive, Shuffle\n\nMetrics: MTTD < 30 min for high alerts, MTTR < 4 h, false positive rate < 30 percent...\n\nAlert flow: detection -> triage -> ticket -> investigation -> containment -> closure -> lessons ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 2
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l7_log_sources',
    topicTitle: 'Log Sources & Data Collection for Detection',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 34,
    totalXp: 200,
    emoji: '📥',
    intro:
        'You can only detect what you can see. Choosing the right log sources, collecting them reliably, and keeping them trustworthy is the foundation of every detection. This lesson shows which logs matter most and what each one reveals.',
    concepts: [
      ConceptLesson(
        title: 'Windows Event Logs',
        definition:
            'Windows records security-relevant events in the Security, System, and Application logs, plus specialised logs such as PowerShell and Sysmon. They are among the richest sources for detecting attacks on endpoints and in Active Directory.',
        analogy:
            'Windows logs are the diary of the machine: who logged in, what started, what changed, and when.',
        example:
            'Key Event IDs:\n\n4624 successful logon | 4625 failed logon\n4648 logon with explicit credentials\n4672 special privileges assigned\n4688 process created (enable command-line logging)\n4697 / 7045 service installed\n4698 scheduled task created\n4720 user created | 4732 member added to a privileged group\n1102 audit log cleared\n4104 PowerShell script block logging\n\nLogon types in 4624:\n  2 interactive, 3 network, 10 remote desktop',
        keyTakeaway:
            'Learn a core set of Event IDs well. Enabling process command-line and PowerShell logging gives detection teams a huge advantage.',
      ),
      ConceptLesson(
        title: 'Sysmon and Linux Logs',
        definition:
            'Sysmon is a free Microsoft tool that adds detailed logging of process creation, network connections, file creation, registry changes, and DNS queries on Windows. On Linux, authentication logs, syslog, auditd, and journald provide similar insight.',
        analogy:
            'Sysmon is a high-resolution camera added on top of the standard security cameras, recording much finer detail about what each program does.',
        example:
            'Useful Sysmon events:\n\n1 process creation (with parent, hash, and command line)\n3 network connection\n7 image (DLL) loaded\n11 file created\n13 registry value set\n22 DNS query\n\nLinux sources:\n  /var/log/auth.log or /var/log/secure: logins, sudo\n  /var/log/syslog or messages: general events\n  auditd: file access, command execution, privilege changes\n  journald: services via journalctl\n  Web server access and error logs\n\nUse a community-maintained Sysmon configuration as a starting point and tune it.',
        keyTakeaway:
            'Parent-child process relationships and command lines are among the most valuable detection data. Sysmon and auditd provide them.',
      ),
      ConceptLesson(
        title: 'Network, DNS, Proxy, and Cloud Logs',
        definition:
            'Network and cloud logs show what systems talk to and what actions happen in cloud accounts. They detect attacks that never touch a monitored endpoint.',
        analogy:
            'Endpoint logs are cameras inside rooms. Network logs are cameras on the corridors and entrances, and cloud logs are the visitor register for the rented offices in other buildings.',
        example:
            'Key sources:\n\nFirewall: allowed and denied connections\nDNS: queries and responses (malware lookups, tunnelling)\nWeb proxy: URLs visited and downloads\nNetFlow or Zeek: who talks to whom, how much, and for how long\nVPN and identity provider: logins, impossible travel, MFA failures\nEmail gateway: phishing and attachment verdicts\nCloud audit logs: AWS CloudTrail, Azure Activity and Entra ID sign-ins, Google Cloud Audit Logs\nEDR telemetry\nApplication and database audit logs',
        keyTakeaway:
            'Combine endpoint, network, identity, and cloud logs. An attacker may hide from one source but rarely from all of them.',
      ),
      ConceptLesson(
        title: 'Collection Quality: Time, Parsing, and Retention',
        definition:
            'Collected logs are useful only if timestamps are accurate, fields are parsed consistently, and data is retained long enough. Log integrity matters, because attackers try to delete or alter logs.',
        analogy:
            'Security footage with the wrong clock, blurry images, or recordings that are erased after a day is of little use when an incident is discovered weeks later.',
        example:
            'Quality checklist:\n\nTime sync: use NTP everywhere and store timestamps in UTC\nParsing and normalisation: map fields to a common schema (for example ECS or CIM)\nCompleteness: monitor for log sources that stop sending (silence is an alert)\nRetention: keep hot data for searches and cold data for investigations and compliance\nIntegrity: forward logs off the host immediately, restrict who can delete, and hash or sign archives\nPrivacy: avoid collecting unnecessary personal data and restrict access\n\nIndia: CERT-In directions of 2022 require organisations to retain certain logs for 180 days. Check the current official text for the details that apply to you.',
        keyTakeaway:
            'Alert on missing logs as well as bad events. A source that goes quiet might mean an outage or an attacker covering their tracks.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which Windows Event ID indicates a failed logon?',
        options: ['4624', '4625', '4688', '4720'],
        correctIndex: 1,
        explanation:
            '4625 is a failed logon. 4624 is successful logon, 4688 is process creation, and 4720 is user account created.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is accurate time synchronisation important for logs?',
        options: [
          'It makes logs smaller',
          'Events from many systems can only be correlated into a correct timeline if clocks agree',
          'It improves screen brightness',
          'It encrypts the logs'
        ],
        correctIndex: 1,
        explanation:
            'If clocks differ, the sequence of events across systems becomes confusing or misleading during an investigation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A critical server stops sending logs to the SIEM at 02:10 a.m. What should the SOC do?',
        options: [
          'Nothing, no logs means no problem',
          'Treat it as a potential outage or tampering and investigate',
          'Delete the server',
          'Wait one month'
        ],
        correctIndex: 1,
        explanation:
            'Silence from a log source can indicate failure or an attacker disabling logging, so it deserves a prompt check.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You see Event ID 1102 on a domain controller at 3 a.m. What does it mean and how serious is it?',
        options: [
          'A routine update',
          'The audit log was cleared, which is highly suspicious and should be investigated immediately',
          'A printer was added',
          'A user logged out'
        ],
        correctIndex: 1,
        explanation:
            'Clearing the security log is a common attacker technique to hide activity, especially on important systems.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You can enable only one extra Windows logging feature this week to improve detection. Which gives the best value?',
        options: [
          'Process creation with command-line logging, and PowerShell script block logging',
          'Wallpaper logging',
          'Clipboard images',
          'Screen resolution changes'
        ],
        correctIndex: 0,
        explanation:
            'Command lines and PowerShell content reveal what attackers actually run, which makes many detections possible.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Log Source Inventory and Gap Analysis',
      goal:
          'Build a log source inventory for a lab network and identify the gaps against common attack stages.',
      steps: [
        'Set up (or plan) a small lab: one Windows VM, one Linux VM, a firewall or router VM, and a DNS service',
        'Enable detailed Windows auditing, process command-line logging, PowerShell logging, and install Sysmon with a community configuration',
        'Configure auditd and SSH logging on the Linux VM',
        'Create an inventory table: source, event types, where it is stored, retention, and who owns it',
        'Map each source to attack stages (initial access, execution, persistence, lateral movement, exfiltration) and mark gaps',
        'Write a short plan to close the 3 most important gaps',
      ],
      expectedOutput:
          'Log Inventory (lab)\n\nWindows Security: 4624/4625/4688/4720 ✓ | PowerShell 4104 ✓ | Sysmon 1,3,11,13,22 ✓\nLinux: auth.log ✓ auditd ✓ web logs ✓\nNetwork: firewall ✓ DNS ✓ | Proxy: none (gap)\n\nGaps: no proxy logs for web activity; no cloud audit; no email logs\nPlan: add Squid proxy logs, enable cloud trail in test account, log mail gateway ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 3
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l7_siem',
    topicTitle: 'SIEM Fundamentals: Splunk, Elastic, Wazuh & Sentinel',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 36,
    totalXp: 210,
    emoji: '🧭',
    intro:
        'A SIEM, Security Information and Event Management system, is the analyst main workbench. It gathers logs, makes them searchable, correlates events, and raises alerts. This lesson explains how SIEMs work and how to ask them useful questions.',
    concepts: [
      ConceptLesson(
        title: 'How a SIEM Works',
        definition:
            'A SIEM collects logs from many sources, parses and normalises them into common fields, stores them, and lets analysts search, correlate, visualise, and alert on them.',
        analogy:
            'A SIEM is like a city control room that merges feeds from thousands of cameras and sensors into one searchable timeline, with alarms that fire when patterns look dangerous.',
        example:
            'Pipeline:\n\n1. Collect: agents, syslog, APIs, cloud connectors\n2. Parse and normalise: extract fields such as source IP, user, action\n3. Store and index: hot and cold tiers\n4. Search and analyse: queries and dashboards\n5. Detect and alert: correlation rules, thresholds, anomaly detection\n6. Respond: tickets and automation\n\nPopular platforms:\n  Splunk, Elastic Security (ELK), Microsoft Sentinel (KQL), IBM QRadar, Wazuh (open source), Security Onion',
        keyTakeaway:
            'A SIEM is only as good as the data and detections you give it. Poor parsing or missing sources make it blind.',
      ),
      ConceptLesson(
        title: 'Searching and Querying Logs',
        definition:
            'Each SIEM has its own query language, but the ideas are the same: filter events, group them, count, and compare over time. Learning one language makes the others easier.',
        analogy:
            'Querying is asking a very large archive precise questions: show me only the failed logins, grouped by source, over the last hour.',
        example:
            'Same question in three languages: which source IPs had more than 10 failed logins in the last hour?\n\nSplunk SPL:\n  index=auth action=failure earliest=-1h | stats count by src_ip | where count > 10\n\nMicrosoft Sentinel KQL:\n  SecurityEvent | where EventID == 4625 | where TimeGenerated > ago(1h) | summarize count() by IpAddress | where count_ > 10\n\nElastic KQL filter idea:\n  event.code: 4625 and @timestamp >= now-1h, then aggregate by source.ip\n\nCommon operations: filter, group by, count, sort, time window, join with a watchlist',
        keyTakeaway:
            'Master four operations in any SIEM: filter, group, count, and time window. Almost every detection uses them.',
        codeSnippet:
            'index=auth action=failure earliest=-1h\n| stats count by src_ip\n| where count > 10\n| sort - count',
      ),
      ConceptLesson(
        title: 'Correlation Rules, Dashboards, and Alerts',
        definition:
            'Correlation rules combine events to reveal behaviour that no single log line shows. Dashboards give an at-a-glance view, and alerts notify analysts when conditions are met.',
        analogy:
            'One person entering a building is normal. The same person entering at 3 a.m., through a side door, right after a badge was disabled, is a pattern that only correlation reveals.',
        example:
            'Correlation examples:\n\nFailed logins followed by a success from the same IP within 10 minutes\nA user logging in from two countries within one hour (impossible travel)\nA new service installed shortly after a remote logon\nA process launched by an Office application spawning a command shell\nA large outbound transfer to a rare destination after hours\n\nGood alert design:\n  Clear name and description\n  Severity and context fields\n  Link to a playbook\n  Suppression to avoid repeat floods',
        keyTakeaway:
            'Every alert should tell the analyst what happened, why it matters, and what to do next.',
      ),
      ConceptLesson(
        title: 'Open-Source SIEM Options for Learning',
        definition:
            'You can build a real SIEM lab for free. Wazuh and the Elastic stack are popular open-source platforms that offer collection agents, rules, dashboards, and endpoint monitoring.',
        analogy:
            'Practising on an open-source SIEM is like learning to drive in a training car: the controls are the same ideas you will meet in any vehicle.',
        example:
            'Lab options:\n\nWazuh: manager, indexer, dashboard, and agents with built-in rules, file integrity monitoring, vulnerability detection, and compliance checks\nElastic Stack: Elasticsearch, Kibana, Beats or Elastic Agent, with prebuilt detection rules\nSecurity Onion: network and host detection distribution\nSplunk Free or developer licences for learning SPL\nMicrosoft Sentinel free trial for KQL practice\n\nResource tip: allocate 8 GB RAM or more for the SIEM VM and use small log volumes in your lab.',
        keyTakeaway:
            'Pick one platform and go deep. Skills transfer, and a lab you built yourself is excellent portfolio evidence.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What does a SIEM do with raw logs before analysts search them?',
        options: [
          'Deletes them',
          'Parses and normalises them into common fields and stores them for search and correlation',
          'Encrypts them without storing',
          'Prints them'
        ],
        correctIndex: 1,
        explanation:
            'Parsing and normalisation turn many log formats into consistent fields that can be searched and correlated.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which four operations underlie most SIEM detection queries?',
        options: [
          'Filter, group, count, and time window',
          'Print, scan, copy, and paste',
          'Encrypt, compress, upload, and delete',
          'Zoom, rotate, crop, and save'
        ],
        correctIndex: 0,
        explanation:
            'Filtering events, grouping them by a field, counting, and limiting by time cover the majority of detection logic.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is impossible travel in a detection rule?',
        options: [
          'A user with a slow computer',
          'Logins for one account from distant locations within a time span too short to travel',
          'A broken VPN',
          'A cancelled flight'
        ],
        correctIndex: 1,
        explanation:
            'If the same account logs in from far-apart places within minutes, the credentials may be compromised or a VPN is involved, and it needs checking.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You need an alert for any account with 5 or more failed logins followed by a success within 10 minutes. Why is this a correlation rule rather than a simple filter?',
        options: [
          'It uses one event only',
          'It combines multiple events in sequence over time to reveal a pattern no single event shows',
          'It does not need time',
          'It only counts successes'
        ],
        correctIndex: 1,
        explanation:
            'Correlation joins related events by account, source, and time to detect behaviours like brute force success.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A new rule triggers 300 times a day on a backup server that logs in to many hosts. What is the best action?',
        options: [
          'Disable detection',
          'Investigate the pattern, add a documented exception or lower severity for that known account, and keep monitoring',
          'Ignore the SIEM',
          'Delete the backup server'
        ],
        correctIndex: 1,
        explanation:
            'Tuning with documented, narrow exceptions reduces noise while keeping the rule useful for everything else.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Stand Up a Lab SIEM and Write Five Searches',
      goal:
          'Deploy an open-source SIEM in your lab, ingest logs from two machines, and write searches and a dashboard.',
      steps: [
        'Install Wazuh or the Elastic stack on a lab VM with enough memory',
        'Install agents on one Windows and one Linux VM and confirm logs arrive',
        'Write 5 searches: failed logins by source, successful logins by user, new processes with a command line, new users created, and service installs',
        'Build a dashboard showing logins over time, top failing sources, and top processes',
        'Create 2 alert rules (for example, 5 failed logins in 5 minutes and a new admin user) and trigger each safely in your lab',
        'Document the queries, screenshots, and what each result means',
      ],
      expectedOutput:
          'SIEM Lab Report\n\nPlatform: Wazuh 4.x | Agents: 2 (Windows 11, Ubuntu)\n\nSearches: failed logins by IP, successful logins by user, new processes, user creation, service installs ✓\nDashboard: logins/hour, top sources, top processes ✓\nAlerts: brute force (triggered by 6 wrong passwords) ✓, new admin user ✓\n\nDocumentation with screenshots ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 4
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l7_detection_engineering',
    topicTitle: 'Detection Engineering: Rules, Sigma & YARA',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 38,
    totalXp: 220,
    emoji: '🎯',
    intro:
        'A detection is a hypothesis: if an attacker does this, we will see that. Detection engineering is the craft of turning attacker behaviour into reliable rules, testing them, and tuning them over time. Great detections are specific, explainable, and maintained.',
    concepts: [
      ConceptLesson(
        title: 'What Makes a Good Detection',
        definition:
            'A good detection finds malicious behaviour with an acceptable balance of true positives and false positives, includes the context an analyst needs, and keeps working as the environment changes.',
        analogy:
            'A good metal detector at an airport finds weapons without beeping for every belt buckle, and the staff know exactly what to do when it sounds.',
        example:
            'Qualities of a good detection:\n\nBased on behaviour, not only on easily changed values\nPrecise enough to keep false positives manageable\nIncludes context (user, host, command line, parent process)\nMapped to a MITRE ATT&CK technique\nDocumented: purpose, data needed, known false positives, response steps\nTested with safe simulations\nOwned and reviewed on a schedule\n\nBad detection example: alert on every PowerShell execution (too noisy to be useful).',
        keyTakeaway:
            'Write detections about what the attacker must do, not about what a single tool happens to print. Behaviour is harder for attackers to change.',
      ),
      ConceptLesson(
        title: 'Sigma: Writing Detections Once for Any SIEM',
        definition:
            'Sigma is an open, vendor-neutral format for describing detection rules in YAML. Rules can be converted into the query languages of different SIEMs, so the community can share detections.',
        analogy:
            'Sigma is to SIEM queries what a universal recipe format is to cooking: write the recipe once and adapt it to any kitchen.',
        example:
            'Sigma rule structure (concept):\n\ntitle: Suspicious Service Created\nstatus: experimental\ndescription: Detects creation of a new Windows service\nlogsource:\n  product: windows\n  service: system\ndetection:\n  selection:\n    EventID: 7045\n  condition: selection\nfalsepositives:\n  - Legitimate software installation\nlevel: medium\ntags:\n  - attack.persistence\n  - attack.t1543\n\nThe public SigmaHQ repository contains thousands of community rules. Always review, test, and tune a rule before using it.',
        keyTakeaway:
            'Reuse community rules as a starting point, but never deploy them blindly. Test each one against your own data.',
        codeSnippet:
            'title: Suspicious Service Created\nlogsource:\n  product: windows\n  service: system\ndetection:\n  selection:\n    EventID: 7045\n  condition: selection\nlevel: medium',
      ),
      ConceptLesson(
        title: 'YARA and Suricata Rules',
        definition:
            'YARA describes patterns in files and memory, mainly used to classify malware. Suricata rules describe patterns in network traffic. Both are signature languages with clear strengths and limits.',
        analogy:
            'YARA is a fingerprint checklist for files, and Suricata rules are a checklist for what packets look like. Both work well for known patterns and less well for brand-new techniques.',
        example:
            'YARA (concept, lab test string only):\n\nrule Lab_Test_Marker {\n  meta:\n    description = "Lab detection test"\n  strings:\n    \$a = "LAB-TEST-MARKER"\n  condition:\n    \$a\n}\n\nSuricata rule (concept):\n\nalert http any any -> any any (msg:"LAB test marker in HTTP"; content:"LAB-TEST-MARKER"; sid:1000001; rev:1;)\n\nLimits:\n  Signatures miss new or changed malware\n  Overly broad strings cause false positives\n  Keep rules documented and versioned',
        keyTakeaway:
            'Signatures are great for known threats and quick wins. Pair them with behavioural detections for the unknown.',
      ),
      ConceptLesson(
        title: 'Testing, Tuning, and the Detection Lifecycle',
        definition:
            'Detections are living products. They are designed, tested, deployed, measured, tuned, and eventually retired. Safe simulation of attacker behaviour in a lab proves that a rule actually fires.',
        analogy:
            'A fire alarm needs regular testing with safe smoke, not just a hope that it works on the day.',
        example:
            'Lifecycle:\n\n1. Idea: from threat intelligence, an incident, or an ATT&CK technique\n2. Data check: do we collect the needed logs?\n3. Build: write the rule and documentation\n4. Test: run a safe simulation in the lab (for example Atomic Red Team tests, only in your own lab) and confirm the alert fires\n5. Baseline: replay against a week of normal logs to estimate false positives\n6. Deploy with an owner and a playbook\n7. Measure: true positive rate, volume, analyst feedback\n8. Tune or retire\n\nKeep a detection backlog and coverage map.',
        keyTakeaway:
            'An untested detection is only an assumption. Prove it fires in your lab and measure its noise before it reaches analysts.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is Sigma?',
        options: [
          'A type of malware',
          'A vendor-neutral YAML format for writing detection rules that can be converted to many SIEM query languages',
          'A firewall brand',
          'A Windows update'
        ],
        correctIndex: 1,
        explanation:
            'Sigma lets the community share and reuse detection logic across different SIEM products.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why are behaviour-based detections generally more durable than detections based only on file hashes?',
        options: [
          'Hashes are encrypted',
          'Attackers can change a hash trivially, but the underlying behaviour is harder to change',
          'Behaviours are always rarer',
          'Hashes cannot be searched'
        ],
        correctIndex: 1,
        explanation:
            'Changing one byte changes a hash, while an attacker still needs to perform the same type of actions to reach their goal.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Before deploying a new detection rule, what is a good way to estimate false positives?',
        options: [
          'Deploy and hope',
          'Replay the rule against historical normal logs and review the hits',
          'Ask nobody',
          'Increase severity to critical'
        ],
        correctIndex: 1,
        explanation:
            'Backtesting against real normal data shows how noisy the rule would be before analysts depend on it.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A rule alerts whenever powershell.exe runs. It fires 5,000 times a day. How could you improve it?',
        options: [
          'Leave it',
          'Narrow it using behaviour: suspicious parent processes, encoded or hidden-window command lines, downloads, and unusual users or hosts',
          'Disable PowerShell logging',
          'Raise severity'
        ],
        correctIndex: 1,
        explanation:
            'Adding context and suspicious behaviours reduces noise while keeping detection of malicious use.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You want to prove that your new persistence detection works. What is the safest approach?',
        options: [
          'Use real malware on a production machine',
          'Run a harmless simulation of the technique in your isolated lab and confirm the alert fires',
          'Assume it works',
          'Ask a friend to try on their laptop'
        ],
        correctIndex: 1,
        explanation:
            'Safe, controlled lab simulations validate detections without risking real systems.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build, Test, and Document Three Detections',
      goal:
          'Create three behaviour-based detections, test them safely in your lab, and document each one.',
      steps: [
        'Pick three techniques: brute force (T1110), new service creation (T1543), and a scheduled task or cron job creation (T1053)',
        'Write each detection as a Sigma rule and convert or translate it into your SIEM query language',
        'Document for each: purpose, data source, logic, known false positives, severity, and response steps',
        'Safely simulate each behaviour in your own lab (for example creating a harmless test service or task) and confirm the alert fires',
        'Estimate false positives by running the query over a few days of normal lab logs',
        'Tune at least one rule and record the before and after alert counts',
      ],
      expectedOutput:
          'Detection Pack (lab)\n\n1. Brute force (T1110): 5 failures/5 min then success -> fired on test ✓ | FP: 0 in 3 days\n2. New service (T1543): EventID 7045 outside change window -> fired ✓ | FP: 4 (software installs) -> tuned with approved installer list\n3. Scheduled task (T1053): 4698 by non-admin -> fired ✓\n\nEach with Sigma file, SIEM query, and documentation ✓\nTuning: 4 alerts/day -> 0.3 alerts/day ✓',
      xpReward: 60,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 5
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l7_attack_frameworks',
    topicTitle: 'MITRE ATT&CK, Kill Chain & Threat Frameworks',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 34,
    totalXp: 205,
    emoji: '🗃️',
    intro:
        'Security teams need a common language to describe how attackers operate. MITRE ATT&CK, the Cyber Kill Chain, and the Diamond Model provide that language. They help you understand an incident, communicate it, and measure how well your detections cover real attacker behaviour.',
    concepts: [
      ConceptLesson(
        title: 'MITRE ATT&CK: Tactics, Techniques, Procedures',
        definition:
            'ATT&CK is a public knowledge base of real-world attacker behaviour. Tactics are the goals (the why), techniques are the methods (the how), and procedures are the specific implementations seen in the wild.',
        analogy:
            'If an attacker is a burglar: the tactic is getting inside, the technique is picking a lock or climbing through a window, and the procedure is the exact lock pick and approach they used last time.',
        example:
            'Enterprise tactics (in typical order):\n\nReconnaissance, Resource Development, Initial Access, Execution, Persistence, Privilege Escalation, Defense Evasion, Credential Access, Discovery, Lateral Movement, Collection, Command and Control, Exfiltration, Impact\n\nExample techniques:\n  T1566 Phishing\n  T1059 Command and Scripting Interpreter\n  T1053 Scheduled Task/Job\n  T1110 Brute Force\n  T1078 Valid Accounts\n  T1021 Remote Services\n  T1003 OS Credential Dumping\n  T1070 Indicator Removal\n  T1486 Data Encrypted for Impact',
        keyTakeaway:
            'Tag every detection and every incident with ATT&CK technique IDs. It makes reports clearer and gaps visible.',
      ),
      ConceptLesson(
        title: 'Using ATT&CK in the SOC',
        definition:
            'ATT&CK is used to map detections, plan hunts, describe incidents, and assess coverage. The ATT&CK Navigator tool lets you colour a matrix showing which techniques you can detect.',
        analogy:
            'It is a map of the territory. Colour the areas you patrol, and the blank areas show where an attacker could walk unseen.',
        example:
            'Practical uses:\n\nCoverage map: mark each technique as detected, partly detected, or blind\nDetection backlog: prioritise techniques that threat actors targeting your sector use\nIncident reports: list the techniques observed, in order\nPurple teaming: choose techniques to simulate and check\nThreat intelligence: compare actor profiles with your coverage\n\nCaution:\n  Coverage on paper does not equal real detection quality\n  A technique has many sub-techniques and variants\n  Test your detections, do not just tick boxes',
        keyTakeaway:
            'A coloured matrix is a starting point. Test each claimed detection, because coverage claims are easy to overstate.',
      ),
      ConceptLesson(
        title: 'The Cyber Kill Chain and Attack Lifecycles',
        definition:
            'The Cyber Kill Chain, from Lockheed Martin, describes seven stages of an intrusion. The idea is that breaking the chain at any stage stops the attack, so defenders aim to detect early.',
        analogy:
            'A chain is only as strong as its weakest link. Break any link and the attacker cannot reach their goal.',
        example:
            'Seven stages:\n\n1. Reconnaissance: research the target\n2. Weaponization: prepare the attack tool\n3. Delivery: send it (email, web, USB)\n4. Exploitation: trigger a weakness\n5. Installation: establish persistence\n6. Command and Control: communicate with the attacker\n7. Actions on Objectives: steal, encrypt, destroy\n\nExample defence per stage:\n  Delivery: email filtering\n  Exploitation: patching\n  Installation: EDR\n  C2: DNS and proxy monitoring\n  Objectives: data loss prevention and backups\n\nLimits: it is linear and perimeter-focused, so ATT&CK is better for detailed modern analysis.',
        keyTakeaway:
            'Use the kill chain for a simple story and ATT&CK for detail. The earlier you detect, the cheaper the incident.',
      ),
      ConceptLesson(
        title: 'Diamond Model and the Pyramid of Pain',
        definition:
            'The Diamond Model links four elements of any intrusion: adversary, capability, infrastructure, and victim. The Pyramid of Pain ranks indicators by how much it hurts the attacker when you detect and block them.',
        analogy:
            'The Diamond Model is the cast list and props of a crime. The Pyramid of Pain explains that taking away a robber disposable gloves barely bothers them, while taking away their whole method of operating forces them to start again.',
        example:
            'Pyramid of Pain (easy to change at the bottom, painful at the top):\n\nTOP: Tactics, Techniques, and Procedures (TTPs): very painful\nTools: painful\nNetwork and host artifacts: annoying\nDomain names: simple\nIP addresses: easy\nBOTTOM: Hash values: trivial\n\nImplication:\n  Blocking hashes and IPs is quick but short-lived\n  Detecting behaviours (TTPs) forces attackers to change how they work',
        keyTakeaway:
            'Invest detection effort high on the pyramid. Behaviour-based detections last longer than lists of hashes and IPs.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'In MITRE ATT&CK, what is a tactic?',
        options: [
          'A specific tool name',
          'The attacker goal at a stage of an intrusion, such as Persistence or Lateral Movement',
          'A vulnerability ID',
          'A type of firewall'
        ],
        correctIndex: 1,
        explanation:
            'Tactics describe why an action is taken. Techniques describe how it is done.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'According to the Pyramid of Pain, which indicator type is hardest and most painful for an attacker to change?',
        options: [
          'File hashes',
          'IP addresses',
          'Tactics, techniques, and procedures',
          'Domain names'
        ],
        correctIndex: 2,
        explanation:
            'Changing how they operate costs attackers the most effort, so TTP-based detection is the most valuable.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which Kill Chain stage is email filtering mainly aimed at disrupting?',
        options: [
          'Reconnaissance',
          'Delivery',
          'Actions on Objectives',
          'Installation'
        ],
        correctIndex: 1,
        explanation:
            'Email filtering blocks the delivery of malicious messages and attachments.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'An incident report says: phishing email opened, macro ran a script, a scheduled task was created, and data was uploaded to a cloud storage site. Which techniques map in order?',
        options: [
          'T1566, T1059, T1053, T1567',
          'T1110, T1021, T1486, T1070',
          'T1003 only',
          'None apply'
        ],
        correctIndex: 0,
        explanation:
            'Phishing (T1566), scripting execution (T1059), scheduled task persistence (T1053), and exfiltration over a web service (T1567) match the story.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your ATT&CK Navigator shows most techniques coloured green, but you have never tested the detections. What is the risk?',
        options: [
          'None',
          'False confidence: rules may not fire, so you should validate each with safe simulations',
          'The map will disappear',
          'You will pay more'
        ],
        correctIndex: 1,
        explanation:
            'Claimed coverage must be tested. Otherwise gaps stay hidden until a real attack.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'ATT&CK Coverage Map and Incident Story',
      goal:
          'Map your lab detections to ATT&CK and describe a sample incident using ATT&CK and the kill chain.',
      steps: [
        'List all detections you have built so far and tag each with ATT&CK tactic and technique',
        'Fill in an ATT&CK Navigator layer, colouring covered, partial, and uncovered techniques',
        'Pick 5 techniques relevant to a ransomware scenario and note which log source you would need to detect each',
        'Write a short fictional incident story and map each step to a kill chain stage and an ATT&CK technique',
        'Place 8 example indicators (hash, IP, domain, tool name, behaviour, and so on) on the Pyramid of Pain and explain which you would invest in',
        'Identify your top 3 coverage gaps and a plan to test and close them',
      ],
      expectedOutput:
          'Coverage Report (lab)\n\nDetections: 7 mapped (T1110, T1543, T1053, T1059, T1078, T1021, T1070)\nNavigator layer exported ✓\n\nIncident story:\n  Delivery: phishing (T1566) -> Execution: macro/script (T1059) -> Persistence: task (T1053) -> C2 -> Exfil (T1567)\n\nPyramid: invest in TTP behaviours; hashes only for quick blocks\n\nGaps: credential dumping (T1003), lateral movement (T1021 partial), exfiltration -> plan with tests ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 6
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l7_edr_ndr',
    topicTitle: 'Endpoint & Network Detection: EDR, Sysmon, Suricata & Zeek',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 36,
    totalXp: 210,
    emoji: '🖥️',
    intro:
        'Modern attacks are caught by watching behaviour on endpoints and traffic on the network. EDR tools observe what programs do on each machine, and network detection tools observe how systems communicate. Together they give you two independent views of the same attack.',
    concepts: [
      ConceptLesson(
        title: 'What EDR Provides',
        definition:
            'Endpoint Detection and Response tools run an agent on each endpoint that records process, file, registry, network, and user activity, detects suspicious behaviour, and lets analysts investigate and respond remotely.',
        analogy:
            'Traditional antivirus is a guard checking IDs at the door against a wanted list. EDR is a guard who stays inside, watches what everyone does, and can lock a room remotely.',
        example:
            'EDR capabilities:\n\nContinuous telemetry on process trees, command lines, and connections\nBehavioural detection and known-malware prevention\nHost isolation: cut a machine off the network while keeping the analyst connection\nRemote actions: kill a process, quarantine a file, collect a triage package\nThreat hunting across all endpoints\nHistorical search\n\nExamples: Microsoft Defender for Endpoint, CrowdStrike Falcon, SentinelOne, Elastic Defend, Wazuh (open source), Velociraptor (open-source forensics and response)',
        keyTakeaway:
            'Isolation is the key response action: it stops spread quickly while preserving evidence on the machine.',
      ),
      ConceptLesson(
        title: 'Reading Process Trees',
        definition:
            'A process tree shows which program started which. Attacks often reveal themselves in unusual parent-child chains, such as an office document starting a command shell.',
        analogy:
            'It is a family tree of programs. If a word processor suddenly becomes the parent of a command prompt, something is off in the family.',
        example:
            'Suspicious chains to look for:\n\nwinword.exe -> cmd.exe or powershell.exe\noutlook.exe -> script interpreters\nA web server process -> a shell\nsvchost.exe started from an unusual parent\nPowerShell with encoded or hidden-window arguments\nProcesses running from user temp or download folders\n\nQuestions to ask:\n  What launched this process and why?\n  Who is the user, and is this normal for them?\n  What did it connect to or create?\n  Is the binary signed and known?',
        keyTakeaway:
            'Context decides meaning. The same program can be normal or malicious depending on its parent, user, and behaviour.',
      ),
      ConceptLesson(
        title: 'Network Detection with Suricata and Zeek',
        definition:
            'Suricata is an intrusion detection and prevention engine that matches traffic against signatures. Zeek is a network analysis framework that records rich, structured logs about connections, DNS, HTTP, TLS, and files. They complement each other.',
        analogy:
            'Suricata is a guard with a list of known bad patterns who shouts when he sees one. Zeek is a meticulous note-taker who records every conversation in the building so you can search the notes later.',
        example:
            'Zeek logs include:\n\nconn.log: every connection with duration and bytes\ndns.log: queries and answers\nhttp.log: requests and user agents\nssl.log: TLS server names and certificates\nfiles.log: files transferred\n\nSuricata alerts:\n  Signature matches for known exploits, malware communication, and policy violations\n\nDetections to try:\n  Beaconing: regular small connections at fixed intervals\n  DNS tunnelling: very long or high-volume queries to one domain\n  Large outbound transfers after hours\n  Connections to newly registered domains\n\nSecurity Onion bundles Suricata, Zeek, and a SIEM-style interface for labs.',
        keyTakeaway:
            'Even when traffic is encrypted, metadata such as destinations, timing, volumes, and certificates reveals a lot.',
      ),
      ConceptLesson(
        title: 'Combining Endpoint and Network Views',
        definition:
            'The strongest investigations pivot between endpoint and network data. A suspicious connection leads to the process that made it, and a suspicious process leads to everything else it contacted.',
        analogy:
            'A detective with CCTV footage and phone records can cross-check a suspect story from two independent angles.',
        example:
            'Example pivot:\n\n1. Zeek shows a host sending small packets every 60 seconds to a rare domain\n2. EDR shows the process making those connections: a renamed utility in a temp folder\n3. Process tree shows it was started by a scheduled task created at 02:14\n4. Host isolation is triggered and a triage package is collected\n5. Network search finds three other hosts contacting the same domain\n6. Scope of the incident is now known\n\nBenefits:\n  Faster scoping\n  Fewer blind spots\n  Higher confidence before taking action',
        keyTakeaway:
            'Learn to pivot: from IP to process, from process to user, from user to other hosts. Pivoting turns one alert into the full story.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which EDR response action cuts a compromised machine off from the network while keeping the analyst connection?',
        options: [
          'Host isolation',
          'Disk formatting',
          'Rebooting',
          'Printing logs'
        ],
        correctIndex: 0,
        explanation:
            'Isolation stops lateral movement and data exfiltration while keeping the machine available for investigation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is a Word document spawning PowerShell suspicious?',
        options: [
          'Word normally launches shells as part of editing',
          'Documents rarely need to start command interpreters, so it often indicates a malicious macro or exploit',
          'PowerShell is a word processor',
          'It is always harmless'
        ],
        correctIndex: 1,
        explanation:
            'Office applications launching scripting engines is a classic malicious macro pattern and a high-value detection.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the main difference between Suricata and Zeek?',
        options: [
          'Suricata mainly matches signatures and raises alerts; Zeek records rich structured logs of network activity',
          'They are identical',
          'Zeek only works on Windows',
          'Suricata does not use rules'
        ],
        correctIndex: 0,
        explanation:
            'Suricata is a signature-based detection engine, while Zeek is a network analysis framework producing detailed logs. Many teams use both.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Zeek shows an internal server making a small connection to the same external IP every 60 seconds, all day. What behaviour does this suggest?',
        options: [
          'A normal browser',
          'Beaconing, a possible command-and-control channel that needs investigation',
          'A software update',
          'A broken cable'
        ],
        correctIndex: 1,
        explanation:
            'Regular, small, periodic connections are typical of malware checking in with its controller.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'An EDR alert shows an unknown binary in a temp folder started by a scheduled task. What is the best first move?',
        options: [
          'Ignore it',
          'Isolate the host if confidence is high, collect process, file, and network evidence, then scope other hosts for the same indicators',
          'Delete the user',
          'Reinstall the OS immediately and lose evidence'
        ],
        correctIndex: 1,
        explanation:
            'Contain first when risk is high, preserve evidence, and then scope. Reinstalling too early destroys useful evidence.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Endpoint and Network Visibility Lab',
      goal:
          'Observe benign test activity from both the endpoint and the network side and practise pivoting.',
      steps: [
        'In your lab, run Sysmon or Wazuh agents on a Windows VM and Zeek or Suricata on a network monitor VM (Security Onion is a convenient option)',
        'Generate benign test activity: open a document that launches a harmless script, create a scheduled task, and make periodic web requests to a lab server',
        'Find the process tree for each action in the endpoint logs',
        'Find the matching connections in Zeek conn.log and dns.log',
        'Write a Suricata rule that alerts on a harmless test marker in HTTP traffic and confirm it fires',
        'Write an investigation note showing how you pivoted from the network event to the process, and the exact fields you used',
      ],
      expectedOutput:
          'Visibility Lab Notes\n\nEndpoint: Sysmon EID 1 shows winword.exe -> cmd.exe (benign test); task creation 4698 ✓\nNetwork: Zeek conn.log shows 10.0.2.15 -> 10.0.2.50 every 60 s (my test beacon)\nSuricata: rule sid:1000001 fired on LAB-TEST-MARKER ✓\n\nPivot: conn.log (dest IP, time) -> Sysmon EID 3 (process, PID) -> EID 1 (parent, command line) ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 7
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l7_alert_triage',
    topicTitle: 'Alert Triage & Investigation Techniques',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 36,
    totalXp: 210,
    emoji: '🔬',
    intro:
        'Triage is the daily core of SOC work: looking at an alert and deciding quickly whether it is real, how serious it is, and what happens next. A repeatable method makes you faster, calmer, and more accurate than guessing.',
    concepts: [
      ConceptLesson(
        title: 'A Repeatable Triage Method',
        definition:
            'Good triage follows a consistent set of questions: what fired, what is the context, is it expected, how bad could it be, and what is the evidence. The outcome is a decision: false positive, benign true positive, or real incident.',
        analogy:
            'It is the checklist of an emergency paramedic arriving at a scene: assess the situation, check the vital signs, decide how serious it is, and act.',
        example:
            'Triage steps:\n\n1. Understand the alert: rule name, severity, time, entities (user, host, IP)\n2. Gather context: asset importance, user role, recent changes, past alerts\n3. Check the raw events behind the alert\n4. Enrich: reputation of IPs, domains, and hashes; who owns the system\n5. Decide: false positive, benign true positive, suspicious, or confirmed malicious\n6. Act: close with notes, escalate, or contain\n7. Document: what you checked and why you decided\n\nAim to reach a decision with evidence, not intuition.',
        keyTakeaway:
            'Write your reasoning in the ticket. Notes protect you, help the next analyst, and improve future rule tuning.',
      ),
      ConceptLesson(
        title: 'Investigating a Suspicious Login',
        definition:
            'Login alerts are among the most common. The goal is to decide whether the legitimate user logged in, or whether an attacker is using stolen credentials.',
        analogy:
            'It is a bank calling you about an unusual transaction: where were you, what device did you use, and does it match your habits?',
        example:
            'Questions to ask:\n\nIs the location, device, and time normal for this user?\nWas MFA used and did it succeed or fail repeatedly?\nDid the login follow many failures (guessing) or a password reset?\nWhat did the account do after logging in? New mailbox rules, file downloads, privilege changes?\nAre there logins to other accounts from the same IP?\nDoes the user confirm the activity (contact them through a known channel)?\n\nPossible outcomes:\n  Benign: user travelling, with confirmation\n  Malicious: reset credentials and sessions, review mailbox rules, search for the IP across systems',
        keyTakeaway:
            'Always check what happened after the login. The login itself is only the entry point.',
      ),
      ConceptLesson(
        title: 'Investigating a Phishing Email Safely',
        definition:
            'Phishing is the most common initial access method. Analysts examine headers, links, and attachments safely, and then find every recipient and block the threat.',
        analogy:
            'It is a bomb disposal approach to a suspicious parcel: examine it from a safe distance, using tools designed for it, and never open it casually.',
        example:
            'Safe analysis steps:\n\n1. Do not click links or open attachments on your normal workstation\n2. Review email headers: sender, Return-Path, Received chain, and SPF, DKIM, and DMARC results\n3. Compare the display name with the real address and look for look-alike domains\n4. Extract URLs and check their reputation using safe tools; use a sandbox such as Any.Run or a company sandbox for detonation\n5. Hash attachments and check reputation\n6. Search mail logs for other recipients and clicks\n7. Remove the email from mailboxes, block sender, domain, and URL, and reset credentials if anyone entered them\n8. Report and update awareness material',
        keyTakeaway:
            'Scope matters as much as analysis: find every recipient and every person who clicked, not only the one who reported it.',
      ),
      ConceptLesson(
        title: 'IOC Enrichment, Pivoting, and Escalation',
        definition:
            'Enrichment adds context to indicators such as IPs, domains, and hashes. Pivoting uses one finding to discover related activity. Escalation passes a case on with the information the next person needs.',
        analogy:
            'A detective who finds one fingerprint checks the database, asks where else it appeared, and then briefs the senior officer with a clear summary.',
        example:
            'Enrichment sources:\n\nVirusTotal, AbuseIPDB, URLhaus, and similar reputation services (never upload confidential files)\nWHOIS and passive DNS for domain age and history\nInternal threat intelligence and past incidents\nAsset inventory: who owns the machine\n\nPivot examples:\n  IP -> all hosts that contacted it\n  Hash -> all hosts with that file\n  User -> all their recent logins and file access\n\nGood escalation note:\n  What happened, when, which assets and users, evidence, what you did, what you recommend, and the current confidence level',
        keyTakeaway:
            'Be careful what you upload to public services. Hashes and public indicators are fine, but sensitive company files are not.',
        codeSnippet:
            'import ipaddress\n\ndef is_internal(ip):\n    return ipaddress.ip_address(ip).is_private\n\nfor ip in ["10.0.2.15", "203.0.113.9"]:\n    print(ip, "internal" if is_internal(ip) else "external")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'During a suspicious login investigation, what is the most important follow-up check after confirming the login looks odd?',
        options: [
          'The colour of the user avatar',
          'What the account did after logging in, such as mailbox rules, downloads, and privilege changes',
          'The server brand',
          'The weather'
        ],
        correctIndex: 1,
        explanation:
            'Post-login activity shows the real impact and whether an attacker is actively using the account.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which is a safe way to analyse a suspicious attachment?',
        options: [
          'Open it on your daily laptop',
          'Hash it and analyse it in an isolated sandbox or company-approved analysis environment',
          'Forward it to colleagues to see what happens',
          'Rename it and open it'
        ],
        correctIndex: 1,
        explanation:
            'Isolation protects your systems. Hash lookups and sandbox detonation give information without risking infection.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should you NOT upload a confidential internal document to a public malware scanning service?',
        options: [
          'It will always be flagged',
          'The file and its contents may be shared with others and exposed publicly',
          'It will be deleted',
          'It slows the scanner'
        ],
        correctIndex: 1,
        explanation:
            'Many public services share uploads with their user community, so sensitive content could leak. Use hashes or an internal sandbox.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A user reports a phishing email. Your analysis confirms it is malicious. You find 14 other recipients and 2 who clicked. What are the next steps?',
        options: [
          'Close the ticket',
          'Purge the email from all mailboxes, block indicators, reset credentials and review activity for the 2 who clicked, and update awareness',
          'Tell only the reporter',
          'Wait for more reports'
        ],
        correctIndex: 1,
        explanation:
            'Containment and scoping must cover all recipients, with extra attention to anyone who interacted with the email.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'An alert shows a login from a new country for an executive, with MFA approved. The executive says they are at home. What should you suspect and do?',
        options: [
          'Nothing, MFA approved',
          'Possible MFA fatigue, token theft, or session hijack: verify through a known channel, review session and device details, revoke sessions, and investigate post-login activity',
          'Delete the account',
          'Switch off MFA'
        ],
        correctIndex: 1,
        explanation:
            'Approved MFA does not guarantee safety. Verify with the user and check for session theft or fatigue-style attacks.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Triage Casebook: Three Alerts',
      goal:
          'Write complete triage notes for three realistic alerts using a consistent method.',
      steps: [
        'Prepare three scenarios (invented data): impossible travel login, suspicious process tree, and a phishing report',
        'For each, write the alert summary, entities, context questions, and evidence you would collect',
        'Write the analysis steps, tools you would use, and enrichment checks',
        'State a decision with confidence level: false positive, benign true positive, suspicious, or malicious',
        'Write the containment and escalation recommendation and the final ticket note',
        'Add a "lessons for detection tuning" line to each case',
      ],
      expectedOutput:
          'Triage Casebook\n\nCase 1: Impossible travel (user: priya) -> VPN provider explains location; user confirmed -> benign true positive; tuning: add VPN ranges\n\nCase 2: winword.exe -> powershell.exe on FIN-LT-07 -> encoded command, outbound to rare domain -> malicious (high confidence); isolate host, scope domain, escalate to Tier 2\n\nCase 3: Phishing report -> look-alike domain, 14 recipients, 2 clicks -> malicious; purge, block, reset 2 credentials\n\nEach with notes and tuning lessons ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 8
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l7_incident_response',
    topicTitle: 'Incident Response Lifecycle, Playbooks & Forensics Basics',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 40,
    totalXp: 220,
    emoji: '🚨',
    intro:
        'When an alert turns out to be a real incident, calm and structure matter more than speed alone. Incident response gives you a lifecycle, playbooks, and evidence-handling habits so you act effectively under pressure and learn from every event.',
    concepts: [
      ConceptLesson(
        title: 'The Incident Response Lifecycle',
        definition:
            'The NIST incident handling guide (SP 800-61) describes phases: preparation, detection and analysis, containment, eradication and recovery, and post-incident activity. Check nist.gov for the latest revision of the guide.',
        analogy:
            'It is the fire brigade cycle: train and equip beforehand, detect the fire, contain it, put it out and repair damage, then investigate how it started and improve the building.',
        example:
            'Phases:\n\n1. Preparation: policies, roles, tools, contact lists, training, backups\n2. Detection and analysis: confirm the incident, scope it, assess severity\n3. Containment: stop the spread (short-term and long-term)\n4. Eradication: remove the cause (malware, accounts, vulnerabilities)\n5. Recovery: restore systems and monitor closely\n6. Post-incident: lessons learned, report, improvements\n\nThe cycle repeats: lessons feed back into preparation.',
        keyTakeaway:
            'Most of the success of an incident is decided in preparation. Plans and contact lists written during a crisis are too late.',
      ),
      ConceptLesson(
        title: 'Containment, Eradication, and Recovery',
        definition:
            'Containment limits the damage, eradication removes the attacker footholds, and recovery restores normal operation safely. The order and care matter, because rushing can destroy evidence or let the attacker back in.',
        analogy:
            'Containment is closing the fire doors. Eradication is putting out every ember. Recovery is rebuilding, with someone watching for rekindling.',
        example:
            'Containment options:\n\nIsolate hosts with EDR\nDisable compromised accounts and revoke sessions and tokens\nBlock malicious IPs, domains, and URLs\nSegment affected network areas\n\nEradication:\n  Remove malware and persistence (tasks, services, keys)\n  Reset credentials, including service accounts and secrets\n  Patch the exploited vulnerability\n\nRecovery:\n  Rebuild from known-good images or backups\n  Verify integrity, restore data, and reintroduce systems in stages\n  Increase monitoring for weeks\n\nDecision factors: business impact, evidence needs, attacker awareness.',
        keyTakeaway:
            'Contain quickly but deliberately. Capture evidence first when you can, and reset every credential an attacker may have touched.',
      ),
      ConceptLesson(
        title: 'Playbooks and Communication',
        definition:
            'A playbook is a step-by-step guide for a specific type of incident, such as ransomware or phishing. Clear roles, severity levels, and communication plans keep a response organised.',
        analogy:
            'It is an aircraft emergency checklist. Pilots know what to do in each case, which frees them to think about the unusual parts.',
        example:
            'Playbook contents:\n\nTrigger and scope\nRoles: incident commander, analysts, communications, legal, IT, management\nSteps for detection, containment, eradication, and recovery\nDecision points and approvals\nCommunication templates for staff, customers, and regulators\nEvidence collection checklist\n\nSeverity levels example: Sev 1 critical business impact, Sev 2 major, Sev 3 minor.\n\nIndia: CERT-In directions (2022) require reporting specified cyber incidents within 6 hours of noticing them, and the DPDP Act, 2023 sets duties on personal data breaches. Confirm the current requirements with your legal team.',
        keyTakeaway:
            'Decide who talks to whom before the incident. Confusion in communication causes more damage than many technical mistakes.',
      ),
      ConceptLesson(
        title: 'Evidence Handling and Digital Forensics Basics',
        definition:
            'Digital forensics preserves and analyses evidence so it can support an investigation and possibly legal action. Key principles are to preserve original data, document everything, and keep a chain of custody.',
        analogy:
            'A crime scene is sealed, photographed, and every item is bagged and logged. Digital evidence deserves the same care.',
        example:
            'Good practice:\n\nOrder of volatility: capture the most fleeting data first (memory, network connections, running processes), then disk and logs\nWork on forensic copies, never the original\nUse write-blockers and record hashes (for example SHA-256) of images\nChain of custody: who handled the evidence, when, and why\nDocument every action with timestamps in UTC\nStore evidence securely with restricted access\n\nUseful tools (use only in authorised environments):\n  Velociraptor, KAPE for triage collection\n  Volatility for memory analysis\n  Autopsy for disk analysis\n  FTK Imager for imaging',
        keyTakeaway:
            'If something might be needed in court or by regulators, treat it as evidence from the start. A hash and a note take seconds and protect the case.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which is the correct order of the main incident response phases?',
        options: [
          'Recovery, Preparation, Detection, Containment',
          'Preparation, Detection and Analysis, Containment, Eradication and Recovery, Post-incident',
          'Containment, Preparation, Post-incident, Detection',
          'Post-incident, Recovery, Detection, Preparation'
        ],
        correctIndex: 1,
        explanation:
            'The lifecycle starts with preparation, moves through detection, containment, eradication, and recovery, and ends with lessons learned that feed back into preparation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does order of volatility mean in forensics?',
        options: [
          'Collect the most short-lived data first, such as memory and network connections, before slower-changing data like disks',
          'Collect data alphabetically',
          'Delete volatile data',
          'Collect only logs'
        ],
        correctIndex: 0,
        explanation:
            'Volatile data disappears when the system is shut down or changes, so it must be captured first.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is a chain of custody record important?',
        options: [
          'It makes evidence smaller',
          'It documents who handled the evidence and when, proving it was not altered',
          'It speeds up recovery',
          'It replaces backups'
        ],
        correctIndex: 1,
        explanation:
            'Without a clear chain of custody, evidence may be challenged and lose value in investigations and legal proceedings.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You confirm ransomware encrypting a file server. Which action comes FIRST?',
        options: [
          'Pay the ransom',
          'Isolate affected systems from the network to stop spread, alert the incident commander, and preserve evidence',
          'Reformat all servers immediately',
          'Post on social media'
        ],
        correctIndex: 1,
        explanation:
            'Containment prevents more encryption. Follow the playbook, involve the right people, and preserve evidence before rebuilding.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'After removing malware from a server, the attacker returns two days later. What was most likely missed?',
        options: [
          'The monitor settings',
          'Persistence or stolen credentials that were not removed or reset during eradication',
          'The colour of the cables',
          'A printer driver'
        ],
        correctIndex: 1,
        explanation:
            'Eradication must remove all footholds and reset exposed credentials, or the attacker simply walks back in.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Incident Response Playbook and Tabletop Exercise',
      goal:
          'Write a ransomware response playbook and walk through a tabletop exercise with a fictional timeline.',
      steps: [
        'Write a one-to-two-page playbook for ransomware with roles, severity levels, and steps for each lifecycle phase',
        'Add a communication plan: internal, management, customers, regulators (CERT-In and data protection duties to verify with legal)',
        'Add an evidence checklist including the order of volatility and chain of custody form',
        'Create a fictional 12-step incident timeline, from the first alert to lessons learned',
        'Run the timeline as a tabletop: at each step, write the decision you would make and who must be told',
        'Finish with a post-incident review listing 5 improvements to prevent a recurrence',
      ],
      expectedOutput:
          'IR Playbook: Ransomware\n\nRoles: commander, 2 analysts, IT lead, comms, legal\nSeverity: Sev 1 (business critical systems encrypted)\n\nTabletop timeline:\n  09:02 EDR alert mass file rename -> 09:05 isolate host -> 09:20 scope shares -> 09:45 disable accounts -> ... -> next day restore from offline backup\n\nEvidence: memory image, disk image, hashes, custody form ✓\nComms: CERT-In report within 6 hours (verify with legal) ✓\n\nImprovements: MFA on VPN, offline backup tests, EDR on file servers, phishing training, tighter share permissions ✓',
      xpReward: 60,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 9
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l7_threat_intel_hunting',
    topicTitle: 'Threat Intelligence & Threat Hunting',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 38,
    totalXp: 215,
    emoji: '🏹',
    intro:
        'Detection rules catch what you already know to look for. Threat intelligence tells you what attackers are doing, and threat hunting is the proactive search for threats that slipped past automated defences. Together they move a SOC from reacting to anticipating.',
    concepts: [
      ConceptLesson(
        title: 'Types of Threat Intelligence',
        definition:
            'Threat intelligence is evidence-based knowledge about threats that helps decisions. It is commonly split into strategic, operational, tactical, and technical levels, each for a different audience.',
        analogy:
            'A weather service gives long-term climate reports for planners, storm warnings for emergency teams, and a minute-by-minute radar for pilots. Each level serves a different decision.',
        example:
            'Levels:\n\nStrategic: trends, motivations, risk to the business (for executives)\nOperational: campaigns and attacker plans (for SOC and IR leads)\nTactical: TTPs, how attackers operate (for detection engineers and hunters)\nTechnical: IOCs such as IPs, domains, hashes (for automated blocking and searching)\n\nGood intelligence is:\n  Relevant to your sector and technology\n  Timely\n  Accurate and sourced\n  Actionable',
        keyTakeaway:
            'Intelligence that does not change a decision or a detection is just information. Always ask: what will we do differently because of this?',
      ),
      ConceptLesson(
        title: 'Sources, Formats, and Sharing',
        definition:
            'Intelligence comes from open sources, commercial providers, communities, and your own incidents. Standard formats such as STIX, and sharing protocols such as TAXII, let tools exchange it automatically.',
        analogy:
            'It is a shared neighbourhood watch bulletin: everyone reports suspicious cars, using a common format so the information is easy to act on.',
        example:
            'Sources:\n\nOpen: vendor blogs, CERT advisories (CERT-In, CISA), MITRE ATT&CK group pages, abuse.ch feeds\nCommunity: ISACs for your sector, trusted sharing groups\nTools: MISP (open-source platform), OpenCTI\nFormats: STIX 2.1 for objects, TAXII for transport, Sigma and YARA for detection logic\n\nTraffic Light Protocol (TLP) marks how far a report may be shared:\n  TLP:RED, AMBER, GREEN, CLEAR\n\nHandling: respect sharing marks, validate before blocking, and track the age of indicators.',
        keyTakeaway:
            'Indicators decay quickly. Always record where an indicator came from, when, and how confident you are.',
      ),
      ConceptLesson(
        title: 'Hypothesis-Driven Threat Hunting',
        definition:
            'Threat hunting is the proactive, human-led search for evidence of attackers that have evaded automated detection. A good hunt starts with a hypothesis based on intelligence or ATT&CK techniques.',
        analogy:
            'Rather than waiting for the alarm, a security guard walks the building at night looking for anything out of place, guided by knowledge of how burglars usually get in.',
        example:
            'Hunt process:\n\n1. Hypothesis: attackers with valid accounts use remote services to move sideways (T1021)\n2. Data: authentication logs, EDR process data, network flows\n3. Method: look for rare account and host pairs, logons at unusual times, or admin tools from unexpected sources\n4. Analyse and validate findings\n5. Outcome: confirmed threat (start incident response), benign finding (document), or no evidence (record what was checked)\n6. Improve: turn a successful hunt into a permanent detection\n\nUseful techniques:\n  Frequency analysis (rare is interesting)\n  Baselining normal behaviour\n  Stacking and grouping data\n  Timeline analysis',
        keyTakeaway:
            'Every hunt should leave something behind: a new detection, a logging improvement, or a documented gap.',
      ),
      ConceptLesson(
        title: 'A Simple Hunt Example with Data Stacking',
        definition:
            'Data stacking counts how often each value appears in a field. Values that appear very rarely, or suddenly often, are worth examining.',
        analogy:
            'If you look at a list of everyone who entered a building this month, the person who came once at 3 a.m. stands out more than the thousand who came every morning.',
        example:
            'Hunt: unusual parent processes starting PowerShell\n\n1. Collect all process creation events for PowerShell over 30 days\n2. Count by parent process name\n3. Expect a few common parents (explorer.exe, a management agent)\n4. Investigate rare parents such as winword.exe or a web server process\n5. Check user, host, and command line for those few events\n\nThe same technique works for:\n  Rarely seen user agents\n  Domains contacted by only one host\n  Scheduled tasks created outside change windows\n  Service names seen on only one machine',
        keyTakeaway:
            'Rare and new are the hunter best friends. Count, sort ascending, and look at the tail.',
        codeSnippet:
            'from collections import Counter\n\nevents = [\n    {"parent": "explorer.exe"},\n    {"parent": "explorer.exe"},\n    {"parent": "mgmt-agent.exe"},\n    {"parent": "winword.exe"},\n]\n\ncounts = Counter(e["parent"] for e in events)\nfor name, n in sorted(counts.items(), key=lambda x: x[1]):\n    print(n, name)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What distinguishes threat hunting from alert triage?',
        options: [
          'Hunting waits for alerts to arrive',
          'Hunting is proactive and hypothesis-driven, searching for threats that have not triggered alerts',
          'They are exactly the same',
          'Hunting only uses antivirus'
        ],
        correctIndex: 1,
        explanation:
            'Triage reacts to alerts, while hunting actively searches for hidden activity using hypotheses.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is it important to record the source and age of an indicator of compromise?',
        options: [
          'To make the list longer',
          'Indicators go stale quickly, and knowing their origin and confidence prevents blocking the wrong things or relying on old data',
          'It is required for backups',
          'It makes hashes shorter'
        ],
        correctIndex: 1,
        explanation:
            'Infrastructure changes constantly. Context helps you judge reliability and decide when to retire an indicator.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What should every successful threat hunt ideally produce?',
        options: [
          'Nothing',
          'A lasting improvement such as a new detection, better logging, or a documented gap',
          'A longer meeting',
          'A new logo'
        ],
        correctIndex: 1,
        explanation:
            'Turning hunt findings into permanent detections or fixes multiplies the value of the effort.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A threat report says an actor targeting your sector uses scheduled tasks for persistence (T1053). What is a good hunting hypothesis?',
        options: [
          'Nothing can be done',
          'Scheduled tasks created outside change windows or by unusual users and parent processes may indicate persistence, so search task creation events for rare creators and odd command lines',
          'Delete all scheduled tasks',
          'Block all employees'
        ],
        correctIndex: 1,
        explanation:
            'A hypothesis ties intelligence to specific data and a method of analysis, which makes the hunt testable.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A feed gives you 50,000 IP addresses to block immediately. What is the best approach?',
        options: [
          'Block all instantly without checking',
          'Check source quality and age, test against your logs for false positives, prioritise recent high-confidence items, and roll out with monitoring',
          'Ignore the feed',
          'Share it publicly'
        ],
        correctIndex: 1,
        explanation:
            'Blind blocking can disrupt business, and old indicators can be harmless or reassigned. Validate and prioritise first.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Run a Hypothesis-Driven Hunt in Your Lab',
      goal:
          'Plan, execute, and document a threat hunt, then convert the results into a detection.',
      steps: [
        'Choose a technique from a public threat report and write a clear hunting hypothesis in one paragraph',
        'List the data sources and fields you need, and confirm they exist in your lab SIEM',
        'Generate some benign test activity that matches the technique, mixed with normal lab activity',
        'Use stacking and frequency analysis (queries or a Python script) to find rare values and examine them',
        'Document findings: what you saw, what was benign, what was suspicious, and what data was missing',
        'Convert the successful query into a documented detection rule with tuning notes, and record a lessons-learned summary',
      ],
      expectedOutput:
          'Hunt Report (lab)\n\nHypothesis: attackers use scheduled tasks created by non-admin users for persistence (T1053)\nData: Security 4698, Sysmon 1 | Window: 30 days of lab logs\n\nStacking: 12 task creators; 11 are system or admin; 1 rare: user lab-test creating a task at 02:14 (my simulation)\n\nOutcome: simulated activity found ✓; 2 benign tasks documented\nNew detection: 4698 by non-admin outside business hours -> medium alert\nGap: no logging on the Linux VM cron changes -> add auditd rule ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 10
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l7_soc_capstone',
    topicTitle: 'Capstone: Build and Operate a Mini SOC Lab',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 55,
    totalXp: 260,
    emoji: '🏆',
    intro:
        'This is your Level 7 capstone. You will build a small but realistic Security Operations lab, create and test detections, run safe simulated attacks, investigate the alerts, and write an incident report. It brings together logging, SIEM, detection engineering, triage, incident response, and hunting in one portfolio project.',
    concepts: [
      ConceptLesson(
        title: 'Designing the Mini SOC Lab',
        definition:
            'A mini SOC lab contains monitored machines, a SIEM, optional network sensors, and a safe way to generate test activity. Everything runs in an isolated network so nothing can affect real systems.',
        analogy:
            'It is a flight simulator for defenders: realistic enough to practise decisions, but safe enough that mistakes teach rather than hurt.',
        example:
            'Suggested architecture:\n\nHost-only or internal network, no route to the internet for test machines\n\nVMs:\n  SIEM: Wazuh or Elastic (8 GB RAM or more)\n  Windows 10 or 11 evaluation VM with Sysmon and the Wazuh agent\n  Ubuntu VM with the agent and auditd\n  Optional: Security Onion or a Zeek and Suricata sensor\n  Optional: a vulnerable web app VM from Level 6\n\nSnapshot every VM before testing so you can restore a clean state.',
        keyTakeaway:
            'Isolation and snapshots make the lab safe and repeatable. Never connect test machines carrying simulated attacks to a real network.',
      ),
      ConceptLesson(
        title: 'Safe Attack Simulation and Purple Teaming',
        definition:
            'Purple teaming means attackers and defenders cooperate: simulate a behaviour, check whether the defence saw it, and improve. In a lab you can use safe, scripted simulations of ATT&CK techniques.',
        analogy:
            'It is a fire drill: you light a controlled, harmless test fire to see whether alarms ring and people know what to do.',
        example:
            'Safe simulation ideas (your own lab only):\n\nFailed login bursts to trigger brute force detection\nCreating a harmless scheduled task and a harmless test service\nAdding a new local user, then adding it to the administrators group\nRunning a benign script from a temp folder\nMaking periodic web requests to a lab server to mimic beaconing\nClearing a test log\n\nFrameworks:\n  Atomic Red Team provides small, documented technique tests mapped to ATT&CK\n  Caldera is an automated adversary emulation platform\n\nRules: only on your own isolated lab, with tests you understand, and with snapshots ready.',
        keyTakeaway:
            'For every simulation record three things: what you did, what the SIEM showed, and what you changed because of it.',
      ),
      ConceptLesson(
        title: 'Investigating and Reporting the Lab Incident',
        definition:
            'After simulations, treat the resulting alerts as real: triage, investigate, scope, contain, and write an incident report. This practises the full analyst workflow.',
        analogy:
            'After the fire drill, the team holds a review: what rang, what did not, how quickly people responded, and what to fix.',
        example:
            'Incident report outline:\n\nSummary: what happened, impact, status\nTimeline (UTC): key events with evidence\nAffected assets and accounts\nAttack path mapped to ATT&CK techniques\nDetection: which rules fired, and which should have but did not\nResponse actions: containment, eradication, recovery\nRoot cause and contributing factors\nRecommendations with owners and deadlines\nLessons learned and metrics (time to detect, time to contain)',
        keyTakeaway:
            'A clear incident report with a timeline and metrics is exactly what hiring managers want to see from a SOC candidate.',
      ),
      ConceptLesson(
        title: 'Packaging Your SOC Portfolio',
        definition:
            'Your lab project becomes a portfolio when it is documented well: architecture, detections, evidence, and reflections, all sanitised and safe to share.',
        analogy:
            'A mechanic shows prospective employers photos and notes of rebuilt engines. You show dashboards, detections, and incident reports of the lab you built.',
        example:
            'Portfolio checklist:\n\nArchitecture diagram and setup guide\nList of log sources with justification\nDetection library with Sigma files and ATT&CK mapping\nDashboards and screenshots\nSimulation log: technique, expected result, actual result\nOne full incident report\nHunt report and lessons learned\nA README that states clearly it was done in an isolated lab\n\nPublish in a public repository or personal site. Remove real IP addresses, credentials, and any personal data.',
        keyTakeaway:
            'Hiring managers value evidence of process: how you set up, tested, failed, and improved, not just final screenshots.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is purple teaming?',
        options: [
          'Attackers and defenders cooperating: simulate behaviours, check whether defences see them, and improve',
          'A type of firewall colour scheme',
          'A solo attack exercise with no defenders',
          'A software license'
        ],
        correctIndex: 0,
        explanation:
            'Purple teaming closes the loop between offensive simulation and defensive improvement.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should lab test machines be isolated from real networks?',
        options: [
          'To make them faster',
          'So that simulated attacks and deliberately weak systems cannot affect or be reached from real systems',
          'Because isolation is optional',
          'To save electricity'
        ],
        correctIndex: 1,
        explanation:
            'Isolation prevents accidental harm and protects your real network from vulnerable lab machines.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which item belongs in an incident report timeline?',
        options: [
          'Events with UTC timestamps and the evidence behind each',
          'Only your opinions',
          'A list of favourite tools',
          'Nothing, timelines are optional'
        ],
        correctIndex: 0,
        explanation:
            'A timeline with evidence makes the incident understandable and verifiable.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You ran 8 simulated techniques, and your SIEM alerted on only 5. What is the most valuable next step?',
        options: [
          'Hide the 3 misses',
          'Investigate why 3 were missed (missing logs, wrong rule logic, or filters), fix the gaps, and re-test',
          'Delete the SIEM',
          'Run more tests without fixing anything'
        ],
        correctIndex: 1,
        explanation:
            'Finding gaps is the point of purple teaming. Fix and re-test so improvement is proven.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You want to share your lab write-up publicly. What must you check first?',
        options: [
          'That it contains real passwords for credibility',
          'That it has no real credentials, personal data, or details of live systems, and that it states the work was done in an isolated lab',
          'That the text is long',
          'That there are no screenshots'
        ],
        correctIndex: 1,
        explanation:
            'Sanitising protects you and others, and a clear lab statement shows professionalism.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title:
          'Level 7 Capstone: Mini SOC Lab with Detections and Incident Report',
      goal:
          'Build an isolated mini SOC, develop and test detections, investigate simulated activity, and publish a sanitised portfolio write-up.',
      steps: [
        'Build the lab: SIEM VM, Windows VM with Sysmon and agent, Linux VM with agent and auditd, optionally a network sensor, all on an isolated network with snapshots',
        'Document the log source inventory and confirm data from each source reaches the SIEM',
        'Create at least 6 detections (Sigma plus SIEM queries) mapped to ATT&CK, covering authentication, persistence, execution, and defence evasion',
        'Build a dashboard for logins, process activity, new accounts and tasks, and alert volume',
        'Run safe simulations for 8 techniques using your own scripts or Atomic Red Team tests, and record expected vs actual results',
        'Triage the alerts using your method, investigate one multi-step scenario end to end, and contain it in the lab',
        'Run one hypothesis-driven hunt and convert the result into a detection',
        'Write a full incident report with timeline, ATT&CK mapping, root cause, metrics, and recommendations',
        'Fix at least 3 detection gaps and re-test them to show improvement',
        'Publish the sanitised portfolio (README, architecture, Sigma rules, dashboards, report) stating clearly that it was done in an isolated lab',
      ],
      expectedOutput:
          'Mini SOC Portfolio\n\nLab: Wazuh + Windows (Sysmon) + Ubuntu (auditd) + Zeek/Suricata sensor; isolated; snapshots ✓\n\nDetections: 8 (T1110, T1078, T1053, T1543, T1059, T1136, T1070, T1021) with Sigma files\nSimulations: 8 run -> 5 detected at first pass -> 3 gaps fixed -> 8/8 detected on re-test\n\nIncident report: multi-step scenario (brute force -> new account -> scheduled task -> beaconing)\n  Time to detect: 4 min | Time to contain: 12 min\n  Root cause: weak password on lab account; recommendations: MFA, lockout, alerting on new admins\n\nHunt: rare scheduled task creators -> new detection ✓\nPublished sanitised README + diagrams + rules ✓',
      xpReward: 100,
    ),
  ),
];
