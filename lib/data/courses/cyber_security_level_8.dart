// ══════════════════════════════════════════════════════════════════════
// lib/data/courses/cyber_security_level_8.dart
// Cyber Security Engineer Path — LEVEL 8: Cloud Security & Enterprise
// Protection (10 lessons)
// ══════════════════════════════════════════════════════════════════════
import '../../models/course_content_data.dart';

const List<TopicCourse> cyberSecurityLevel8 = [
  // ────────────────────────────────────────────────────────────────────
  // LESSON 1
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l8_cloud_shared_responsibility',
    topicTitle: 'Cloud Security Foundations & the Shared Responsibility Model',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 190,
    emoji: '☁️',
    intro:
        'Most organisations now run important workloads on AWS, Azure, or Google Cloud. The cloud gives speed and scale, but it also changes who is responsible for what. Many cloud breaches happen because customers assumed the provider handled something that was actually their job.',
    concepts: [
      ConceptLesson(
        title: 'Cloud Service and Deployment Models',
        definition:
            'Cloud services are delivered as IaaS (infrastructure), PaaS (platform), or SaaS (software), and deployed as public, private, hybrid, or multi-cloud. Each model gives the customer a different amount of control, and therefore a different amount of security work.',
        analogy:
            'IaaS is renting an empty plot and building everything yourself. PaaS is renting a furnished flat where you bring only your belongings. SaaS is staying in a hotel room where almost everything is handled for you.',
        example:
            'Examples:\n\nIaaS: virtual machines and networks (AWS EC2, Azure Virtual Machines, Google Compute Engine)\nPaaS: managed databases and app platforms (AWS RDS and Elastic Beanstalk, Azure App Service, Google App Engine)\nSaaS: Microsoft 365, Google Workspace, Salesforce\n\nDeployment models:\n  Public cloud: shared provider infrastructure\n  Private cloud: dedicated to one organisation\n  Hybrid: on-premises plus cloud\n  Multi-cloud: more than one provider',
        keyTakeaway:
            'The more the provider manages, the less you control and the less you can configure. You are always responsible for your data, identities, and settings.',
      ),
      ConceptLesson(
        title: 'The Shared Responsibility Model',
        definition:
            'The provider secures the cloud itself, meaning the physical data centres, hardware, and core services. The customer secures what they put in the cloud, including data, identities, access, configuration, and applications.',
        analogy:
            'The landlord is responsible for the building structure and the main door. The tenant is responsible for locking their own flat, who gets a key, and what they leave on the balcony.',
        example:
            'Provider responsibility (security OF the cloud):\n  Physical security, hardware, hypervisor, global network, managed service software\n\nCustomer responsibility (security IN the cloud):\n  Identity and access management\n  Data classification and encryption choices\n  Network and firewall configuration\n  Operating system and application patching on IaaS\n  Security group and storage permissions\n  Logging and monitoring\n  Compliance for your own data\n\nThe split shifts with the service model: on IaaS you patch the OS; on SaaS you mostly manage users and data.',
        keyTakeaway:
            'Learn the exact responsibility split for each service you use. Misreading it is the root of many cloud incidents.',
      ),
      ConceptLesson(
        title: 'Why Cloud Breaches Happen',
        definition:
            'Industry reports consistently show that most cloud security incidents come from customer-side mistakes, such as misconfiguration, stolen credentials, and excessive permissions, rather than from failures of the provider infrastructure.',
        analogy:
            'A bank vault can be perfectly built and still be emptied if someone leaves the door open or hands out the code.',
        example:
            'Common root causes:\n\nPublicly readable storage buckets\nOverly broad IAM permissions\nLeaked access keys in code repositories\nNo multi-factor authentication on privileged accounts\nOpen management ports (SSH, RDP) to the internet\nUnpatched virtual machines\nDisabled or ignored logging\nUnmonitored third-party integrations\n\nThe speed of the cloud means that a single mistake can be created and exploited within minutes.',
        keyTakeaway:
            'Cloud security is mostly identity, configuration, and visibility. Master those three and you prevent most real incidents.',
      ),
      ConceptLesson(
        title: 'Frameworks, Certifications, and Getting Started Safely',
        definition:
            'Industry frameworks give structure to cloud security work, and cloud certifications provide a learning path. You can practise safely in free-tier accounts if you follow cost and safety rules.',
        analogy:
            'A framework is a trusted checklist used by pilots. A free-tier account is a flight simulator with a small fuel budget.',
        example:
            'Frameworks and references:\n\nCIS Foundations Benchmarks for AWS, Azure, and GCP\nCloud Security Alliance Cloud Controls Matrix (CCM)\nProvider well-architected security guidance\nISO/IEC 27017 and 27018\nNIST Cybersecurity Framework\n\nCertifications to consider:\n  AWS Certified Security Specialty, Microsoft SC-900 and AZ-500, Google Professional Cloud Security Engineer, CCSP\n\nSafe practice rules:\n  Set budget alerts on day one\n  Enable MFA on the root or owner account\n  Use a dedicated learning account, never a company account\n  Delete resources when finished\n  Never store real personal data',
        keyTakeaway:
            'A billing alert and MFA on the owner account are the first two things to configure in any new cloud account.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'In the shared responsibility model, who is responsible for configuring who can access data stored in a cloud bucket?',
        options: [
          'The cloud provider',
          'The customer',
          'The internet service provider',
          'Nobody'
        ],
        correctIndex: 1,
        explanation:
            'Access configuration of your own resources and data is always the customer responsibility.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which service model leaves the customer with the most security responsibility?',
        options: ['SaaS', 'PaaS', 'IaaS', 'They are all equal'],
        correctIndex: 2,
        explanation:
            'With IaaS the customer manages the operating system, applications, network settings, and data, so more is theirs to secure.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What are the most common causes of real cloud breaches?',
        options: [
          'Physical theft of data centre hardware',
          'Customer-side misconfiguration, stolen credentials, and excessive permissions',
          'Provider employees guessing passwords',
          'Weather events'
        ],
        correctIndex: 1,
        explanation:
            'Most incidents involve identity and configuration failures on the customer side.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A team says: "Our data is safe because AWS is secure." What is the best reply?',
        options: [
          'Agree completely',
          'Explain that AWS secures the infrastructure, but the team must secure access, configuration, and data in their account',
          'Say cloud is unsafe and should not be used',
          'Tell them to disable logging'
        ],
        correctIndex: 1,
        explanation:
            'The model is shared. Provider security does not replace customer configuration and access control.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You open a new personal cloud account to practise. Which two actions should come first?',
        options: [
          'Create public storage with sample data',
          'Enable MFA on the owner account and set a budget alert',
          'Open all ports for convenience',
          'Share the password with friends'
        ],
        correctIndex: 1,
        explanation:
            'MFA protects the most powerful account, and a budget alert prevents surprise bills from mistakes or abuse.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Shared Responsibility Map and Safe Cloud Account Setup',
      goal:
          'Create a responsibility map for three services and prepare a safe learning account.',
      steps: [
        'Pick one IaaS, one PaaS, and one SaaS service you might use',
        'For each, draw a table with columns: provider responsibility and customer responsibility, covering data, identity, network, OS, application, and physical',
        'Write 3 real-world breach causes and map each to the responsibility that failed',
        'Create a free-tier AWS, Azure, or Google Cloud learning account (not a company account)',
        'Enable MFA on the owner account, create a non-owner admin user for daily use, and set a budget alert at a very small amount',
        'Write a one-page cloud lab safety checklist for yourself',
      ],
      expectedOutput:
          'Responsibility Map\n\nEC2 (IaaS): provider = hardware, hypervisor | customer = OS patches, firewall, IAM, data\nRDS (PaaS): provider = DB engine patching | customer = access, encryption settings, network exposure\nMicrosoft 365 (SaaS): provider = application | customer = users, MFA, sharing settings, data\n\nBreach map: public bucket -> customer config; leaked key -> customer identity\n\nLearning account: MFA on root ✓ daily admin user ✓ budget alert 5 USD ✓\nSafety checklist written ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 2
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l8_cloud_iam',
    topicTitle: 'Cloud Identity & Access Management',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 38,
    totalXp: 215,
    emoji: '🪪',
    intro:
        'In the cloud, identity is the new perimeter. Anyone who holds the right credentials can reach your resources from anywhere in the world. Cloud IAM controls who can do what, so getting it right is the single most important cloud security skill.',
    concepts: [
      ConceptLesson(
        title: 'IAM Building Blocks',
        definition:
            'Cloud IAM systems manage identities (users, groups, roles, and service identities), authentication (proving who you are), and authorisation (policies that define permitted actions on resources).',
        analogy:
            'IAM is the access card system of a large office: employees get cards (identities), the cards open particular doors (permissions), and the system logs every swipe.',
        example:
            'Core concepts (AWS terms, with similar ones in Azure and GCP):\n\nUser: a person or application with long-term credentials\nGroup: a set of users sharing permissions\nRole: a set of permissions that can be assumed temporarily\nPolicy: a document that allows or denies actions on resources\nPrincipal, Action, Resource, Condition: the parts of a statement\n\nEquivalents:\n  Azure: Entra ID, RBAC roles, managed identities, Conditional Access\n  GCP: IAM roles, service accounts, organisation policies',
        keyTakeaway:
            'Prefer temporary credentials from roles over long-term access keys. Short-lived access limits the damage of a leak.',
      ),
      ConceptLesson(
        title: 'Least Privilege in Practice',
        definition:
            'Least privilege means granting only the permissions needed for a task, on only the resources needed, for only as long as needed. Broad wildcard permissions are the most common cloud IAM mistake.',
        analogy:
            'A cleaner gets a key to the rooms they clean, not the master key to the whole building and the safe.',
        example:
            'A narrow AWS policy (concept):\n\n{\n  "Version": "2012-10-17",\n  "Statement": [{\n    "Effect": "Allow",\n    "Action": ["s3:GetObject"],\n    "Resource": "arn:aws:s3:::example-reports-bucket/*"\n  }]\n}\n\nBad pattern: Action set to a star and Resource set to a star (full administrator).\n\nPractices:\n  Start with no access and add what is needed\n  Use provider tools that show unused permissions (AWS IAM Access Analyzer, Azure access reviews)\n  Review permissions regularly\n  Use conditions such as source IP, MFA, or time',
        keyTakeaway:
            'A wildcard policy is a warning sign. Replace it with specific actions and resources.',
        codeSnippet:
            '{\n  "Version": "2012-10-17",\n  "Statement": [{\n    "Effect": "Allow",\n    "Action": ["s3:GetObject"],\n    "Resource": "arn:aws:s3:::example-reports-bucket/*"\n  }]\n}',
      ),
      ConceptLesson(
        title: 'Protecting Privileged Accounts and Access Keys',
        definition:
            'The cloud owner or root account has unlimited power and must be locked down. Long-term access keys are a frequent source of leaks and must be managed carefully or avoided.',
        analogy:
            'The root account is the master key to the whole company. It is kept in a safe, used only in emergencies, and never carried around.',
        example:
            'Must-do controls:\n\nEnable MFA on root or owner accounts, preferably with a hardware key\nDo not use the root account for daily work, and never create access keys for it\nRequire MFA for all human users, using SSO with the corporate identity provider\nUse roles and managed identities for applications instead of keys\nIf keys are unavoidable: rotate them, scope them narrowly, store in a secrets manager, never commit them to code\nScan repositories for leaked keys\nSet alerts on root logins and on key creation\nBreak-glass emergency accounts with strong controls and monitoring',
        keyTakeaway:
            'Leaked access keys are found and abused by bots within minutes. Avoid long-lived keys and alert on any use of root.',
      ),
      ConceptLesson(
        title: 'Federation, SSO, and Multi-Account Governance',
        definition:
            'Federation lets people use their corporate identity to access cloud accounts through single sign-on. Large organisations split workloads across many accounts or subscriptions and govern them centrally with guardrails.',
        analogy:
            'Instead of every hotel issuing you a separate key and password, you show one trusted passport everywhere, and the head office decides which hotels you may enter.',
        example:
            'Enterprise patterns:\n\nSSO with SAML or OpenID Connect from the company identity provider\nCentral joiner, mover, leaver process: removing a person from the directory removes cloud access\nSeparate accounts for production, development, security logging, and shared services\nAWS Organizations with Service Control Policies (SCPs) that set maximum permissions\nAzure management groups and Azure Policy\nGoogle Cloud organisation policies\n\nGuardrail examples:\n  Deny disabling audit logging\n  Deny leaving approved regions\n  Deny creating public storage',
        keyTakeaway:
            'Guardrails at the organisation level protect you even when a single account owner makes a mistake.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why are temporary credentials from roles safer than long-term access keys?',
        options: [
          'They are longer',
          'They expire automatically, so a leak has limited time to be abused',
          'They bypass MFA',
          'They are free of cost'
        ],
        correctIndex: 1,
        explanation:
            'Short-lived credentials reduce the window of opportunity if they are exposed.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is wrong with a policy that allows all actions on all resources?',
        options: [
          'Nothing',
          'It violates least privilege and gives full control, magnifying the damage of any compromise',
          'It slows the account',
          'It is not allowed by cloud providers'
        ],
        correctIndex: 1,
        explanation:
            'Wildcard administrator policies mean a single stolen credential can control everything.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the purpose of Service Control Policies (SCPs) in AWS Organizations?',
        options: [
          'To grant permissions to users',
          'To set maximum permission boundaries for accounts, acting as organisation-wide guardrails',
          'To store files',
          'To speed up networks'
        ],
        correctIndex: 1,
        explanation:
            'SCPs do not grant access but limit what accounts can do, even for their administrators.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A developer accidentally commits a cloud access key to a public repository. What is the correct sequence?',
        options: [
          'Delete the file and carry on',
          'Revoke or rotate the key immediately, review activity logs for misuse, then clean the repository and add scanning',
          'Wait to see if anyone uses it',
          'Make the repository private only'
        ],
        correctIndex: 1,
        explanation:
            'Assume exposure: revoke first, investigate use through audit logs, and prevent recurrence with secret scanning.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'An application running on a virtual machine needs to read one storage bucket. What is the best design?',
        options: [
          'Embed an administrator key in the code',
          'Attach a role or managed identity to the VM with permission to read only that bucket',
          'Make the bucket public',
          'Share the owner password'
        ],
        correctIndex: 1,
        explanation:
            'A narrowly scoped role with temporary credentials avoids stored secrets and limits impact.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'IAM Design and Audit in Your Learning Account',
      goal:
          'Design least-privilege access for a small team and audit your own account for risky settings.',
      steps: [
        'Scenario: a team with a developer, an analyst, and an auditor, plus an application that reads one storage bucket',
        'Design groups and roles with specific permissions for each, and write the policies as JSON with no wildcards for resources where possible',
        'Create these in your learning account and test that each identity can do only what is intended',
        'Run the provider IAM analysis tools (such as IAM Access Analyzer or credential report) and list findings',
        'Confirm MFA on the owner account, no access keys on the root account, and no unused users or keys',
        'Write a short IAM standard for the team: MFA, roles over keys, review cycle, and break-glass process',
      ],
      expectedOutput:
          'IAM Review (learning account)\n\nGroups: developers (deploy to dev only), analysts (read-only reports), auditors (read logs)\nApp role: read-only on bucket example-reports\n\nTests: developer cannot touch prod ✓ analyst cannot delete ✓ auditor cannot change config ✓\n\nCredential report: root MFA enabled ✓ no root keys ✓ 1 unused key removed\n\nIAM standard written ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 3
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l8_cloud_network',
    topicTitle: 'Cloud Network Security',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 36,
    totalXp: 210,
    emoji: '🧱',
    intro:
        'The networking ideas from Level 2 return in the cloud under new names: virtual networks, subnets, security groups, and gateways. In the cloud, a single checkbox can expose a database to the entire internet, so understanding cloud network design is essential.',
    concepts: [
      ConceptLesson(
        title: 'Virtual Networks and Segmentation',
        definition:
            'A virtual private cloud (VPC in AWS and GCP) or virtual network (VNet in Azure) is your isolated network inside the provider. You divide it into subnets and control traffic with route tables and firewalls.',
        analogy:
            'A VPC is your own fenced estate inside a large shared city. You decide which buildings have gates to the street and which are only reachable from inside.',
        example:
            'Typical three-tier design:\n\nPublic subnet: load balancer, bastion or NAT gateway (reachable from the internet)\nPrivate application subnet: application servers (no direct internet access)\nPrivate data subnet: databases (only the application tier can connect)\n\nKey rule: put only what must be public in public subnets. Databases and internal services belong in private subnets.\n\nConnectivity options:\n  Internet gateway, NAT gateway, VPN, dedicated links, VPC peering, transit gateways',
        keyTakeaway:
            'Public by exception, private by default. Every resource that does not need a public address should not have one.',
      ),
      ConceptLesson(
        title: 'Security Groups, NACLs, and NSGs',
        definition:
            'Cloud firewalls control traffic. Security groups (AWS) and network security groups (Azure) are stateful and attach to resources. Network ACLs (AWS) are stateless and apply at the subnet level.',
        analogy:
            'A security group is the lock on each apartment door that remembers who you invited. A network ACL is the checkpoint at the entrance of the whole floor.',
        example:
            'Good rules:\n\nWeb tier: allow 443 from the internet\nApp tier: allow the app port only from the web tier security group\nDatabase tier: allow the database port only from the app tier security group\nManagement: allow SSH or RDP only from a bastion, a VPN range, or use a managed session service\n\nDangerous rules:\n  0.0.0.0/0 on port 22, 3389, or any database port\n  All traffic open between all tiers\n\nTip: reference other security groups as sources instead of IP ranges for internal traffic.',
        keyTakeaway:
            'Never open management or database ports to 0.0.0.0/0. Use security group references, VPNs, or managed access services instead.',
      ),
      ConceptLesson(
        title: 'Edge Protection: WAF, DDoS, and Private Connectivity',
        definition:
            'Cloud providers offer web application firewalls, DDoS protection, and private endpoints that keep traffic to managed services off the public internet.',
        analogy:
            'A WAF is a skilled doorman at the shop front for web traffic. Private endpoints are staff-only corridors that avoid the public street altogether.',
        example:
            'Controls:\n\nWAF (AWS WAF, Azure Front Door and WAF, Cloud Armor): filters common web attacks and bad bots\nDDoS protection (AWS Shield, Azure DDoS Protection, Cloud Armor)\nCDN in front of applications to absorb load and hide origin servers\nPrivate endpoints or VPC endpoints: reach storage and databases over private paths\nEgress filtering: restrict outbound traffic so compromised workloads cannot freely contact attackers\nVPC Flow Logs and NSG flow logs: record traffic metadata for detection\n\nThe cloud metadata service: enforce the stronger version (AWS IMDSv2) to reduce SSRF risk.',
        keyTakeaway:
            'Control outbound traffic too. Egress filtering and flow logs often expose compromised workloads that inbound controls missed.',
      ),
      ConceptLesson(
        title: 'Secure Remote Access and Zero Trust in the Cloud',
        definition:
            'Administrators should reach servers without exposing management ports publicly. Zero trust approaches verify every request based on identity, device, and context, instead of trusting a network location.',
        analogy:
            'Instead of leaving the staff door open on the street with a lock, you give each authorised staff member a personal, logged, time-limited pass that works only for the room they need.',
        example:
            'Options:\n\nSession manager services (AWS Systems Manager Session Manager, Azure Bastion): no open inbound ports\nVPN or zero-trust access gateways with MFA\nJust-in-time access that grants admin rights for a limited time\nIdentity-aware proxies for internal applications\nLogging of every administrative session\n\nZero trust principles (NIST SP 800-207):\n  Never trust, always verify\n  Least privilege access\n  Assume breach and monitor continuously',
        keyTakeaway:
            'Management access should be authenticated, authorised, time-limited, and logged. Open SSH to the world is never acceptable.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Where should a production database normally be placed in a cloud network?',
        options: [
          'In a public subnet with a public IP',
          'In a private subnet reachable only from the application tier',
          'On the internet gateway',
          'In the CDN'
        ],
        correctIndex: 1,
        explanation:
            'Databases should not be directly reachable from the internet. Private subnets and tight security group rules protect them.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which security group rule is most dangerous?',
        options: [
          'Allow 443 from anywhere to a public web server',
          'Allow 22 from 0.0.0.0/0 to production servers',
          'Allow the app port from the web tier security group',
          'Allow database port from the app tier only'
        ],
        correctIndex: 1,
        explanation:
            'Opening SSH to the entire internet invites constant brute force and exploitation attempts.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is egress (outbound) filtering valuable?',
        options: [
          'It makes servers faster',
          'It can stop compromised workloads from contacting attacker servers or exfiltrating data',
          'It removes the need for inbound rules',
          'It is only for compliance'
        ],
        correctIndex: 1,
        explanation:
            'Restricting outbound connections limits command-and-control traffic and data theft after a compromise.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A scan of your account shows port 3389 (RDP) open to 0.0.0.0/0 on a Windows server. What is the best fix?',
        options: [
          'Leave it, it needs remote access',
          'Remove the public rule and use a bastion, VPN, or managed session service with MFA and logging',
          'Change the Windows wallpaper',
          'Open more ports'
        ],
        correctIndex: 1,
        explanation:
            'Public RDP is a favourite ransomware entry point. Use controlled, authenticated access paths.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'An app tier must talk to a database tier. Which rule design is best?',
        options: [
          'Database security group allows the database port from the app tier security group only',
          'Database security group allows all traffic from 0.0.0.0/0',
          'Disable the security group',
          'Put both in one public subnet'
        ],
        correctIndex: 0,
        explanation:
            'Referencing the app tier security group as the source gives precise least-privilege access that follows scaling automatically.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Three-Tier Network Design and Rule Review',
      goal:
          'Design a secure three-tier cloud network and review its rules against a checklist.',
      steps: [
        'Draw a diagram with a VPC or VNet, public subnet, private app subnet, and private data subnet across two availability zones',
        'Write the security group or NSG rules for each tier with source, port, and reason',
        'Add a WAF and CDN in front of the load balancer and mark where flow logs are enabled',
        'Decide how administrators will connect (managed session service or VPN) with no public management ports',
        'Create a simplified version in your learning account (free-tier friendly components only) and verify that the database is not publicly reachable',
        'Run a configuration review tool (Prowler, ScoutSuite, or the provider security advisor) and list network findings',
      ],
      expectedOutput:
          'Network Design\n\nVPC 10.0.0.0/16 | public 10.0.1.0/24 | app 10.0.2.0/24 | data 10.0.3.0/24 (2 AZs)\n\nRules:\n  ALB: 443 from internet\n  App: 8080 from ALB SG\n  DB: 5432 from App SG only\n  Admin: Session Manager (no inbound 22/3389)\n\nWAF + CDN at edge; flow logs on; VPC endpoint for storage\nReview: 0 public database, 1 finding (default SG open) fixed ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 4
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l8_cloud_data_protection',
    topicTitle: 'Data Protection in the Cloud: Encryption, Keys & Storage',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 36,
    totalXp: 210,
    emoji: '🗄️',
    intro:
        'Data is what attackers ultimately want, and cloud storage makes it easy to share and just as easy to expose by accident. This lesson covers how to classify, encrypt, store, and back up data so a mistake does not become a headline.',
    concepts: [
      ConceptLesson(
        title: 'Classify First, Then Protect',
        definition:
            'Data classification labels information by sensitivity so that you apply the right level of protection. You cannot protect data well if you do not know where it is or how sensitive it is.',
        analogy:
            'A hospital keeps routine notices on a public board, patient records in a locked cabinet, and the most sensitive items in a vault. Each gets the protection it deserves.',
        example:
            'Example classification:\n\nPublic: marketing content\nInternal: internal documents\nConfidential: customer data, contracts, source code\nRestricted: payment data, health records, encryption keys\n\nTools that help discover sensitive data:\n  AWS Macie for S3\n  Microsoft Purview\n  Google Cloud Data Loss Prevention\n\nLegal context: India DPDP Act, 2023 and other privacy laws place duties on handling personal data, including security safeguards.',
        keyTakeaway:
            'Start with an inventory and classification. Controls follow from knowing what you hold.',
      ),
      ConceptLesson(
        title: 'Encryption at Rest and in Transit, and Key Management',
        definition:
            'Cloud providers make encryption easy: storage can be encrypted by default, and connections use TLS. The real security decision is who controls the keys and who is allowed to use them.',
        analogy:
            'Locking a box is easy. The real question is who holds the key, how many copies exist, and whether anyone can borrow it without being noticed.',
        example:
            'Key management options:\n\nProvider-managed keys: simplest, provider controls rotation\nCustomer-managed keys in a key management service (AWS KMS, Azure Key Vault, Google Cloud KMS): you set who can use each key and can audit every use\nCustomer-supplied or external keys (HSM) for strict requirements\n\nPractices:\n  Enable encryption by default for storage, databases, and backups\n  Enforce TLS 1.2 or higher for all connections\n  Separate key administrators from key users\n  Enable automatic key rotation\n  Log every key use\n  Use envelope encryption (data keys protected by master keys)',
        keyTakeaway:
            'Encryption without good key access control is incomplete. Restrict and monitor who can use the keys.',
      ),
      ConceptLesson(
        title: 'Securing Object Storage',
        definition:
            'Object storage such as Amazon S3, Azure Blob Storage, and Google Cloud Storage is behind many headline breaches, almost always because of public access or overly permissive policies.',
        analogy:
            'It is a huge filing room. A single wrongly labelled door that says "public" can let anyone walk in and copy every file.',
        example:
            'Controls:\n\nBlock public access at the account and bucket level (S3 Block Public Access)\nUse bucket policies and IAM roles with least privilege\nDisable legacy access control lists where possible\nEnable versioning and object lock for important data\nEnable access logging\nUse pre-signed URLs with short expiry for temporary sharing\nEncrypt by default\nScan for sensitive data and public exposure regularly\n\nCheck your own bucket public access settings:\n  aws s3api get-public-access-block --bucket your-bucket-name',
        keyTakeaway:
            'Turn on account-wide public access blocking and make exceptions only through a reviewed process.',
        codeSnippet:
            'aws s3api get-public-access-block --bucket your-bucket-name\n\n# Run only against buckets in your own learning account.',
      ),
      ConceptLesson(
        title: 'Secrets, Backups, and Ransomware Resilience',
        definition:
            'Applications need passwords, tokens, and keys, which must never be hard-coded. Backups protect against failure and ransomware only if they are protected and tested.',
        analogy:
            'Secrets belong in a bank safe deposit system with a sign-in log, not on a sticky note on the monitor. Backups are only useful if you have proven you can actually restore from them.',
        example:
            'Secrets management:\n\nUse AWS Secrets Manager or Parameter Store, Azure Key Vault, or Google Secret Manager\nRotate secrets automatically\nGrant applications access through roles, not copied credentials\nScan code and images for leaked secrets\n\nBackup resilience:\n  Follow 3-2-1: three copies, two media types, one offsite or offline\n  Immutable backups (object lock, vault lock) so attackers cannot delete them\n  Separate account or subscription for backups\n  Test restores regularly\n  Define RPO (acceptable data loss) and RTO (acceptable downtime)',
        keyTakeaway:
            'Immutable, separated, and tested backups are the strongest answer to ransomware.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the most important question about cloud encryption beyond simply turning it on?',
        options: [
          'The colour of the console',
          'Who controls the keys and who is allowed to use them',
          'How many users are online',
          'The region name'
        ],
        correctIndex: 1,
        explanation:
            'Access to the keys determines who can decrypt. Key policies and auditing are central to real protection.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which setting best prevents accidental public exposure of S3 buckets across an account?',
        options: [
          'Account-level S3 Block Public Access',
          'Naming buckets cleverly',
          'Disabling encryption',
          'Using larger objects'
        ],
        correctIndex: 0,
        explanation:
            'Account-wide blocking acts as a guardrail even if a single bucket policy is misconfigured.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What do RPO and RTO mean?',
        options: [
          'Recovery Point Objective (acceptable data loss) and Recovery Time Objective (acceptable downtime)',
          'Random Port Option and Routing Table Object',
          'Remote Process Output and Real Time Operation',
          'Read Policy Only and Read Time Only'
        ],
        correctIndex: 0,
        explanation:
            'RPO defines how much recent data you can afford to lose, and RTO defines how long you can afford to be down.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A pre-signed URL for a sensitive report was shared in a chat with a 30-day expiry. What is the issue and the fix?',
        options: [
          'No issue',
          'The long expiry widens exposure; use a short expiry, restrict access if possible, and rotate or revoke if the link may have leaked',
          'Pre-signed URLs cannot be used',
          'Encrypt the chat'
        ],
        correctIndex: 1,
        explanation:
            'Anyone with the link can download until it expires. Short lifetimes limit the risk.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Ransomware encrypts your production data and also deletes backups stored in the same account using stolen admin credentials. What design would have helped?',
        options: [
          'More production servers',
          'Immutable backups stored in a separate, tightly controlled account',
          'A faster internet connection',
          'Disabling logging'
        ],
        correctIndex: 1,
        explanation:
            'Separation and immutability stop attackers from destroying recovery copies even with high privileges in the production account.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Data Protection Plan for a Small Cloud Application',
      goal:
          'Create and partially implement a data protection plan with classification, encryption, key control, secrets, and backups.',
      steps: [
        'Scenario: a small app with user profiles, uploaded documents, and a database',
        'Classify each data type and decide encryption and retention requirements',
        'In your learning account, create a bucket with public access blocked, default encryption, versioning, and access logging (use dummy data only)',
        'Create a customer-managed key, restrict key use to one role, and enable rotation',
        'Store a sample secret in a secrets manager and read it from a role instead of from code',
        'Write a backup and recovery plan with RPO and RTO targets, immutable backup settings, and a restore test checklist, then delete all resources',
      ],
      expectedOutput:
          'Data Protection Plan\n\nClassification: profiles = confidential; documents = confidential; logs = internal\n\nImplemented (lab): bucket with Block Public Access ✓ SSE-KMS ✓ versioning ✓ access logs ✓\nKMS key: used only by app role; rotation on ✓\nSecret in Secrets Manager; read via role ✓\n\nBackup plan: RPO 4 h, RTO 2 h; immutable copies in separate account; monthly restore test\nResources deleted after lab ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 5
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l8_cloud_logging_detection',
    topicTitle: 'Cloud Logging, Monitoring & Threat Detection',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 36,
    totalXp: 210,
    emoji: '📡',
    intro:
        'You built SOC skills in Level 7. Cloud environments need the same visibility, but the logs and detections are different. Every action in a cloud account is an API call, and recording those calls gives you a powerful record of everything that happens.',
    concepts: [
      ConceptLesson(
        title: 'The Cloud Audit Trail',
        definition:
            'Cloud providers record management activity as audit logs: who called which API, from where, when, and with what result. These logs are the foundation of cloud investigation and detection.',
        analogy:
            'It is the CCTV and visitor register of your cloud account. Every door opened, every setting changed, and every key created is written down with a time and a name.',
        example:
            'Key sources:\n\nAWS CloudTrail: API and console activity (enable in all regions, with log file validation)\nAzure Activity Log, Entra ID sign-in and audit logs\nGoogle Cloud Audit Logs: Admin Activity, Data Access, System Event\nVPC Flow Logs, NSG flow logs: network metadata\nStorage access logs and load balancer logs\nDNS query logs\nApplication and OS logs from workloads\n\nPractices:\n  Send logs to a separate, locked-down logging account\n  Enable immutability and integrity validation\n  Keep retention that meets investigation and legal needs',
        keyTakeaway:
            'Turn on the audit trail in every region from day one and store it where an attacker in your workload accounts cannot delete it.',
      ),
      ConceptLesson(
        title: 'Native Threat Detection Services',
        definition:
            'Cloud providers offer managed services that analyse logs and flag suspicious behaviour, such as unusual API calls, compromised credentials, or crypto-mining.',
        analogy:
            'They are built-in security analysts who read the visitor register all day and raise their hand when something looks wrong.',
        example:
            'Services to know:\n\nAWS: GuardDuty (threat detection), Security Hub (aggregated findings and standards), Config (configuration history and rules), Inspector (vulnerabilities), Macie (sensitive data), IAM Access Analyzer\nAzure: Microsoft Defender for Cloud, Microsoft Sentinel (SIEM and SOAR), Entra ID Protection\nGoogle Cloud: Security Command Center, Chronicle\n\nTypical findings:\n  Calls from known malicious IPs\n  Unusual region activity\n  Credential use from unexpected locations\n  Instances communicating with crypto-mining pools\n  Disabled logging',
        keyTakeaway:
            'Enable the native detection service in every account and send its findings to your central SIEM or ticketing system.',
      ),
      ConceptLesson(
        title: 'High-Value Cloud Detections',
        definition:
            'Certain cloud events are strong signs of compromise or risky change, and every team should alert on them: use of the root account, disabling logging, creating access keys, and changes to security controls.',
        analogy:
            'Some alarms matter more than others: the vault opening at night matters more than a light left on.',
        example:
            'Detections to implement:\n\nRoot or owner account login or API use\nConsole login without MFA\nCloudTrail or logging disabled or modified\nNew IAM user, access key, or admin policy attached\nSecurity group opened to 0.0.0.0/0 on sensitive ports\nStorage bucket made public\nSnapshot or image shared with an unknown account\nUnusual spikes in resource creation (possible crypto-mining)\nAPI calls from unusual regions or Tor exit nodes\nFailed access bursts (permission enumeration)\n\nEach detection should link to a response playbook.',
        keyTakeaway:
            'Alert on identity changes and logging changes first. Attackers need to do both to persist and to hide.',
      ),
      ConceptLesson(
        title: 'Responding to a Cloud Incident',
        definition:
            'Cloud incident response uses the same lifecycle as elsewhere, but the actions are API calls: revoke credentials, change policies, snapshot disks, and isolate instances with security groups.',
        analogy:
            'You still follow the fire plan, but the fire doors are now closed by changing settings rather than turning a physical key.',
        example:
            'Compromised access key playbook:\n\n1. Identify the key and the principal from the alert\n2. Disable or delete the key and revoke active sessions\n3. Review audit logs for everything that identity did, including new users, roles, keys, and resources\n4. Remove attacker-created identities and resources\n5. Rotate related secrets\n6. Snapshot affected instances for forensics before termination\n7. Identify the leak path (repository, laptop, application) and close it\n8. Report, learn, and add detections\n\nUse infrastructure as code to rebuild clean resources quickly.',
        keyTakeaway:
            'In the cloud, containment is fast: a few API calls can cut off an attacker, but only if you have prepared the permissions and playbooks in advance.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why should cloud audit logs be stored in a separate, locked-down account?',
        options: [
          'It makes logs smaller',
          'So an attacker who compromises a workload account cannot delete or alter the evidence',
          'To save money only',
          'Because logs cannot be stored in the same account'
        ],
        correctIndex: 1,
        explanation:
            'Separation and immutability protect the integrity of your investigation evidence.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which event is among the highest-priority alerts in a cloud account?',
        options: [
          'A user viewing a dashboard',
          'Use of the root account, or logging being disabled',
          'A new virtual machine tag',
          'A routine software update'
        ],
        correctIndex: 1,
        explanation:
            'Root use and tampering with logging are strong indicators of compromise or dangerous changes.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What should you do early when a cloud access key is suspected to be compromised?',
        options: [
          'Wait and watch',
          'Disable or rotate the key, revoke sessions, and review audit logs for everything it did',
          'Delete all logs',
          'Create more keys'
        ],
        correctIndex: 1,
        explanation:
            'Cut off the credential first, then use the audit trail to scope what the attacker did.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'GuardDuty reports that an EC2 instance is communicating with a known crypto-mining pool. What is the best response?',
        options: [
          'Ignore the finding',
          'Isolate the instance with a restrictive security group, snapshot for evidence, investigate how it was compromised, and rebuild from a clean image',
          'Increase the instance size',
          'Disable GuardDuty'
        ],
        correctIndex: 1,
        explanation:
            'Containment, evidence preservation, root cause analysis, and a clean rebuild follow the standard incident response approach.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your audit log shows a new IAM user with administrator rights created at 03:00 by an access key belonging to a developer. What does this suggest?',
        options: [
          'Normal onboarding',
          'Possible compromised credentials and persistence, so investigate immediately and disable the key and new user',
          'A scheduled backup',
          'A billing event'
        ],
        correctIndex: 1,
        explanation:
            'Creating privileged identities at odd times using an existing key is a classic persistence technique.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Cloud Detection Starter Pack',
      goal:
          'Enable logging and native detection in your learning account and implement five high-value alerts.',
      steps: [
        'Enable the audit trail in all regions and send logs to a separate bucket with encryption and log file validation',
        'Enable the native threat detection service available in your cloud (for example GuardDuty or Defender for Cloud) and review sample findings',
        'Create alerts for 5 events: root login, console login without MFA, access key created, security group opened to the internet, and logging disabled',
        'Safely trigger each in your learning account (for example, create and delete a test key, open then close a test rule) and confirm the alert',
        'Write a one-page playbook for a compromised access key',
        'Document costs and turn off or delete anything that is not free-tier once the exercise is complete',
      ],
      expectedOutput:
          'Detection Pack (learning account)\n\nCloudTrail: all regions, log validation on, separate bucket ✓\nGuardDuty enabled; sample findings reviewed ✓\n\nAlerts tested: root login ✓ no-MFA console ✓ new access key ✓ SG open to 0.0.0.0/0 ✓ trail stopped ✓\n\nPlaybook: compromised key (8 steps) ✓\nCost review: 0.00 USD, resources cleaned up ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 6
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l8_cspm_iac',
    topicTitle: 'Cloud Posture Management & Infrastructure as Code Security',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 38,
    totalXp: 220,
    emoji: '🛠️',
    intro:
        'Cloud environments change constantly, so a one-time review is outdated within days. Cloud Security Posture Management (CSPM) continuously checks configurations against best practice, and Infrastructure as Code (IaC) security stops insecure settings before they ever reach the cloud.',
    concepts: [
      ConceptLesson(
        title: 'What CSPM Does',
        definition:
            'CSPM tools continuously scan cloud accounts for misconfigurations and compliance gaps, such as public storage, open ports, missing encryption, and excessive permissions, and report them with severity and guidance.',
        analogy:
            'It is a building inspector who visits every day instead of once a year, checking every door, window, and fire exit against the building code.',
        example:
            'Tools:\n\nNative: AWS Security Hub and Config, Microsoft Defender for Cloud, Google Security Command Center\nOpen source: Prowler, ScoutSuite, CloudSploit, Steampipe\nCommercial platforms: Wiz, Prisma Cloud, Orca, and others\n\nStandards checked:\n  CIS Foundations Benchmarks\n  PCI DSS, ISO 27001, SOC 2 mappings\n  Provider best-practice standards\n\nExample open-source use in your own account (read-only audit):\n  prowler aws',
        keyTakeaway:
            'Run a posture scan regularly and prioritise by exposure and data sensitivity, not by raw count of findings.',
        codeSnippet:
            'prowler aws\n\n# Read-only audit. Run only in accounts you own or are authorised to review.',
      ),
      ConceptLesson(
        title: 'Common Misconfigurations and How to Prioritise',
        definition:
            'Posture scans can list hundreds of findings. Prioritisation focuses first on issues that are internet-exposed, involve sensitive data, or grant broad privileges.',
        analogy:
            'In a house inspection, a missing smoke alarm and an unlocked front door matter more than a scratched skirting board.',
        example:
            'Top findings to fix first:\n\nPublicly accessible storage or databases\nSecurity groups open to the internet on SSH, RDP, or database ports\nRoot account without MFA or with access keys\nAdministrator-level policies attached widely\nAudit logging disabled\nUnencrypted storage and snapshots\nPublic snapshots and images\nOutdated TLS versions and weak ciphers on public endpoints\nUnused but active credentials\n\nCombine findings: a public virtual machine with a vulnerability and an admin role is far more dangerous than each issue alone (attack path thinking).',
        keyTakeaway:
            'Look at combinations, not single findings. Exposure plus privilege plus sensitive data is the dangerous trio.',
      ),
      ConceptLesson(
        title: 'Infrastructure as Code and Why Security Belongs There',
        definition:
            'Infrastructure as Code describes cloud resources in files, using tools such as Terraform, CloudFormation, Bicep, or Pulumi. Because the same template can create hundreds of resources, a single insecure line is copied everywhere.',
        analogy:
            'Instead of building each house by hand, an architect prints a blueprint. A flaw in the blueprint appears in every house, but fixing the blueprint fixes all future houses.',
        example:
            'Benefits for security:\n\nRepeatable, reviewable builds\nPeer review of changes through pull requests\nVersion history of every change\nEasy rebuild after an incident\nPolicy checks before deployment\n\nRisks:\n  Secrets committed into IaC files or state files\n  Insecure defaults copied from examples\n  Over-privileged pipeline credentials\n  Configuration drift when people change things manually in the console',
        keyTakeaway:
            'Treat IaC like application code: review it, test it, scan it, and protect the pipeline credentials and state files.',
      ),
      ConceptLesson(
        title: 'Scanning IaC and Enforcing Policy as Code',
        definition:
            'Scanners analyse IaC files before deployment and flag insecure settings. Policy as code engines enforce rules automatically, blocking non-compliant changes.',
        analogy:
            'It is an automatic plan checker in the planning office that rejects any blueprint with a missing fire exit before construction begins.',
        example:
            'Tools:\n\nCheckov, Trivy (config scanning), tfsec, KICS: scan Terraform, CloudFormation, Kubernetes, and Dockerfiles\nOpen Policy Agent (OPA) and Conftest, HashiCorp Sentinel: policy as code\nAWS Config rules, Azure Policy, GCP organisation policy: enforce at runtime\nTerraform plan checks in pull requests\n\nSecure Terraform example (concept):\n\nresource "aws_s3_bucket_public_access_block" "b" {\n  bucket                  = aws_s3_bucket.b.id\n  block_public_acls       = true\n  block_public_policy     = true\n  ignore_public_acls      = true\n  restrict_public_buckets = true\n}\n\nPipeline: write -> scan -> review -> plan -> approve -> apply -> detect drift',
        keyTakeaway:
            'Scan in the pull request and enforce at runtime. Prevention in code plus detection in the cloud closes the loop.',
        codeSnippet:
            'checkov -d ./terraform\n\nresource "aws_s3_bucket_public_access_block" "b" {\n  bucket                  = aws_s3_bucket.b.id\n  block_public_acls       = true\n  block_public_policy     = true\n  ignore_public_acls      = true\n  restrict_public_buckets = true\n}',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main purpose of CSPM?',
        options: [
          'To continuously detect cloud misconfigurations and compliance gaps',
          'To speed up virtual machines',
          'To encrypt emails',
          'To design logos'
        ],
        correctIndex: 0,
        explanation:
            'CSPM continuously checks cloud settings against best practices and reports risky configurations.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is a single insecure line in an IaC template especially risky?',
        options: [
          'It cannot be fixed',
          'The template may be reused to create many resources, spreading the flaw widely',
          'It deletes the template',
          'It only affects billing'
        ],
        correctIndex: 1,
        explanation:
            'IaC amplifies both good and bad settings. Fixing the template fixes every future deployment.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is configuration drift?',
        options: [
          'Resources slowly becoming faster',
          'The live environment differing from the code-defined desired state because of manual changes',
          'A network cable moving',
          'A change in region names'
        ],
        correctIndex: 1,
        explanation:
            'Manual console changes can silently diverge from the code and bypass reviews. Drift detection finds them.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A scan reports 400 findings. How should you decide what to fix first?',
        options: [
          'Alphabetically',
          'Prioritise internet-exposed resources, sensitive data, and high privilege, and look for combinations that form attack paths',
          'Fix the lowest severity first',
          'Ignore the report'
        ],
        correctIndex: 1,
        explanation:
            'Exposure, data sensitivity, and privilege determine real risk and help you reduce it quickly.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A Terraform state file containing database passwords was committed to a public repository. What are the correct actions?',
        options: [
          'Nothing, state files are not important',
          'Treat the secrets as compromised: rotate them, remove the file, store state in a protected remote backend, and add secret scanning',
          'Rename the file',
          'Make the repository bigger'
        ],
        correctIndex: 1,
        explanation:
            'State files can contain sensitive values. Rotate secrets and protect state with encrypted remote storage and tight access.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Posture Scan and Secure IaC Pipeline',
      goal:
          'Scan your learning account for misconfigurations and build a small IaC pipeline that blocks insecure changes.',
      steps: [
        'Run a posture scan (Prowler, ScoutSuite, or native tools) in your learning account and export the results',
        'Prioritise the top 10 findings by exposure, sensitivity, and privilege, and fix at least 5',
        'Write a small Terraform configuration for a secure storage bucket and a restricted security group',
        'Scan it with Checkov or Trivy, deliberately add 3 insecure settings, and confirm the scanner flags them',
        'Add the scan to a GitHub Actions workflow that fails the pull request on high severity findings',
        'Make one change manually in the console, detect the drift with a plan, and document how you would prevent it',
      ],
      expectedOutput:
          'Posture and IaC Report\n\nScan: 63 findings | Top 10 prioritised | 5 fixed (public access block, MFA, logging, SG, encryption)\n\nTerraform: secure bucket + restricted SG\nCheckov: 0 failures; after adding 3 insecure settings: 3 failures caught ✓\nPipeline: PR blocked on high findings ✓\n\nDrift: manual SG change detected by terraform plan; prevention: restrict console write access ✓',
      xpReward: 60,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 7
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l8_container_k8s',
    topicTitle: 'Container & Kubernetes Security',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 40,
    totalXp: 225,
    emoji: '🐳',
    intro:
        'Modern cloud applications run in containers orchestrated by Kubernetes. Containers are fast and portable, but they share a kernel, rely on images from many sources, and are controlled by a powerful API. This lesson covers how to secure images, runtime, and clusters.',
    concepts: [
      ConceptLesson(
        title: 'How Containers Differ from Virtual Machines',
        definition:
            'Containers package an application and its dependencies and share the host operating system kernel, while virtual machines each run a full operating system. Containers are lighter, but their isolation is weaker than that of a VM.',
        analogy:
            'Virtual machines are separate houses with their own walls and plumbing. Containers are flats in the same building that share the foundations and pipes, so one badly secured flat can affect others.',
        example:
            'Security implications:\n\nA kernel vulnerability or a privileged container can affect the host and other containers\nImages bundle libraries that may contain vulnerabilities\nContainers are short-lived, so traditional patching is replaced by rebuilding images\nContainer registries become part of your supply chain\n\nCore protections:\n  Linux namespaces and cgroups for isolation\n  Capabilities, seccomp, and AppArmor or SELinux profiles to restrict what containers may do',
        keyTakeaway:
            'Shared kernel means a tighter blast-radius discipline: run containers with the fewest privileges possible.',
      ),
      ConceptLesson(
        title: 'Secure Images and Dockerfiles',
        definition:
            'Images are the foundation of container security. Small, minimal, scanned images built by trusted pipelines reduce the attack surface and the number of vulnerabilities.',
        analogy:
            'Packing for a trip: the fewer unnecessary items you carry, the fewer things there are to lose or to be stolen.',
        example:
            'Best practices:\n\nUse minimal base images (slim, distroless, or Alpine where suitable)\nPin versions and use trusted registries\nRun as a non-root user\nDo not store secrets in images or environment files committed to Git\nUse multi-stage builds to keep build tools out of the final image\nScan images for vulnerabilities in the pipeline (Trivy, Grype)\nSign images (Cosign) and verify signatures before deployment\nGenerate an SBOM for each image\nRebuild regularly to pick up patches',
        keyTakeaway:
            'Scan in the pipeline, sign what you build, and deploy only images that pass your checks.',
        codeSnippet:
            'FROM python:3.12-slim\nRUN useradd -m appuser\nWORKDIR /app\nCOPY requirements.txt .\nRUN pip install --no-cache-dir -r requirements.txt\nCOPY . .\nUSER appuser\nCMD ["python", "app.py"]',
      ),
      ConceptLesson(
        title: 'Kubernetes Security Essentials',
        definition:
            'Kubernetes controls many containers through a central API. Securing a cluster means protecting the control plane, restricting who can do what with RBAC, limiting pod privileges, controlling network traffic, and managing secrets safely.',
        analogy:
            'Kubernetes is the building manager for a huge complex of flats. If someone steals the manager master key, they control every flat, so the key and the rules need strong protection.',
        example:
            'Key controls:\n\nRBAC: least-privilege roles for users and service accounts; avoid cluster-admin\nPod Security Standards (restricted profile): no privileged pods, no host namespaces, non-root, read-only root filesystem where possible\nNetwork policies: default deny between pods, allow only required flows\nSecrets: use external secret stores or encryption at rest; do not treat base64 as encryption\nAdmission control: Kyverno or OPA Gatekeeper to enforce policy\nAPI server: no anonymous access, private endpoint where possible, audit logging on\nKeep Kubernetes and nodes updated\nBenchmarks: CIS Kubernetes Benchmark, tested with kube-bench',
        keyTakeaway:
            'Default deny network policies and restricted pod settings are the two quickest wins in Kubernetes hardening.',
        codeSnippet:
            'securityContext:\n  runAsNonRoot: true\n  allowPrivilegeEscalation: false\n  readOnlyRootFilesystem: true\n  capabilities:\n    drop: ["ALL"]',
      ),
      ConceptLesson(
        title: 'Runtime Detection and Supply Chain Protection',
        definition:
            'Even with hardened images, running containers need monitoring. Runtime tools detect unexpected behaviour, while supply chain controls ensure only trusted code reaches the cluster.',
        analogy:
            'Locking the doors is not enough. You also want cameras inside to notice if someone behaves oddly, and a check on every delivery before it enters the building.',
        example:
            'Runtime tools:\n\nFalco: detects suspicious system calls and behaviours in containers\nCloud provider workload protection (GuardDuty for EKS and ECS, Defender for Containers)\nAudit logs from the Kubernetes API\n\nExample suspicious events:\n  A shell started inside a production container\n  Unexpected outbound connections\n  A container writing to sensitive paths\n  A new privileged pod\n\nSupply chain controls:\n  Private, access-controlled registries\n  Image signing and verification\n  SBOMs and provenance (SLSA concepts)\n  Admission policies that block unsigned or vulnerable images',
        keyTakeaway:
            'Combine build-time scanning, deploy-time policy, and runtime detection. No single stage catches everything.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why is running a container as root considered risky?',
        options: [
          'It uses more memory',
          'If the container is compromised, the attacker has higher privileges and a greater chance to affect the host',
          'Root users cannot use networks',
          'It slows down startup'
        ],
        correctIndex: 1,
        explanation:
            'Running as a non-root user limits the damage an attacker can do after compromising the application.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Kubernetes Secrets are stored base64 encoded by default. What does this mean for security?',
        options: [
          'They are strongly encrypted',
          'Base64 is an encoding, not encryption, so you should enable encryption at rest, limit access with RBAC, and consider an external secret store',
          'Secrets are public',
          'They cannot be used'
        ],
        correctIndex: 1,
        explanation:
            'Encoding is trivially reversible. Protect secrets with encryption at rest and strict access control.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does a default-deny network policy achieve?',
        options: [
          'Blocks all pod-to-pod traffic unless explicitly allowed',
          'Allows all traffic',
          'Deletes pods',
          'Speeds up the cluster'
        ],
        correctIndex: 0,
        explanation:
            'Default deny reduces lateral movement. You then open only the specific flows each application needs.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A vulnerability scan of your image reports 120 findings, mostly from the large base image. What is the best way to reduce them?',
        options: [
          'Ignore all',
          'Switch to a minimal base image, use multi-stage builds, update packages, and re-scan',
          'Add more packages',
          'Disable the scanner'
        ],
        correctIndex: 1,
        explanation:
            'Smaller images contain fewer components and therefore fewer vulnerabilities.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Falco alerts: "A shell was spawned in a production web container". What should you do?',
        options: [
          'Ignore, shells are normal in production',
          'Treat as possible compromise: investigate the pod, check recent logs and network connections, isolate or replace the pod, and find the entry point',
          'Disable Falco',
          'Delete the cluster'
        ],
        correctIndex: 1,
        explanation:
            'Interactive shells in production containers are unusual and may indicate exploitation or misuse.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Harden a Container Image and a Kubernetes Deployment',
      goal:
          'Build a hardened image, scan it, and deploy it to a local Kubernetes cluster with restrictive settings.',
      steps: [
        'Write a simple web app and a Dockerfile using a slim base image, a non-root user, and a multi-stage build if useful',
        'Scan the image with Trivy, record the findings, and reduce them by updating and slimming the image',
        'Install a local cluster (kind or minikube) and deploy the app with a security context that drops capabilities and uses a read-only root filesystem',
        'Add a default-deny network policy and one allow rule for the app, and test it',
        'Run kube-bench or a configuration scanner on the cluster and review the top findings',
        'Write a short hardening checklist for container deployments in your own words',
      ],
      expectedOutput:
          'Container Hardening Report (local)\n\nImage: python:3.12-slim, non-root, multi-stage\nTrivy: 74 findings -> 9 after slimming and updating\n\nDeployment: runAsNonRoot ✓ readOnlyRootFilesystem ✓ drop ALL capabilities ✓\nNetworkPolicy: default deny + allow ingress 8080 from ingress controller ✓\n\nkube-bench: 12 warnings reviewed, 5 fixed\nChecklist written ✓',
      xpReward: 60,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 8
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l8_enterprise_identity_endpoint',
    topicTitle: 'Enterprise Identity, Active Directory & Endpoint Protection',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 40,
    totalXp: 225,
    emoji: '🏢',
    intro:
        'Behind most large organisations sits Microsoft Active Directory, the system that decides who everyone is and what they can reach. Attackers aim to take it over because that gives them the whole company. This lesson explains how enterprise identity works, why it is a prime target, and how to defend it and the endpoints that connect to it.',
    concepts: [
      ConceptLesson(
        title: 'Active Directory in Plain Language',
        definition:
            'Active Directory (AD) is a directory service that stores users, groups, computers, and policies for a Windows network. Domain controllers authenticate users, mostly using Kerberos, and Group Policy applies settings across many machines.',
        analogy:
            'AD is the HR and ID office of a big company. It knows every employee, which department they are in, what they may enter, and which rules apply to their equipment.',
        example:
            'Key components:\n\nDomain controller (DC): the server that holds the directory and authenticates users\nDomain, forest, and organisational units (OUs): the structure\nUsers, groups, and computer accounts\nGroup Policy Objects (GPOs): central configuration\nKerberos: ticket-based authentication\nPrivileged groups: Domain Admins, Enterprise Admins, Administrators\nHybrid identity: Microsoft Entra ID (formerly Azure AD) synchronised with on-premises AD\n\nWhy it matters: whoever controls a domain admin account controls the whole domain.',
        keyTakeaway:
            'Protect domain controllers and privileged groups above everything else. They are the keys to the kingdom.',
      ),
      ConceptLesson(
        title: 'Common AD Attack Paths (Defender View)',
        definition:
            'Attackers who gain a foothold on one workstation try to move toward domain admin by abusing weak passwords, cached credentials, over-privileged service accounts, and misconfigurations. Understanding these paths tells defenders what to fix and what to monitor.',
        analogy:
            'It is like a burglar who gets into the staff canteen and then looks for a forgotten master key, an unlocked records room, or a manager who reuses the same code everywhere.',
        example:
            'Attack patterns and defences (concept level):\n\nCredential theft from memory on workstations: use Credential Guard, EDR, and limit admin logons to workstations\nPassword reuse of local administrator accounts: use Windows LAPS for unique passwords\nKerberoasting (requesting service tickets for offline password cracking): use long random passwords or group managed service accounts, and monitor ticket requests\nWeak or never-expiring service account passwords: audit and rotate\nUnconstrained delegation and excessive permissions on objects: review and remove\nMisconfigured certificate services: audit with defensive tools\nLegacy protocols (NTLM, SMBv1, LLMNR): disable where possible\n\nDefenders can map risky paths in their own domain using tools like BloodHound Community Edition in authorised assessments.',
        keyTakeaway:
            'Most AD compromises use known weaknesses. Unique local admin passwords, strong service account passwords, and tiering remove many of the easiest paths.',
      ),
      ConceptLesson(
        title: 'Tiered Administration and Privileged Access Management',
        definition:
            'Tiered administration separates accounts by the level of systems they manage, so that credentials with high privilege are never used on lower-trust machines. Privileged Access Management (PAM) adds approval, time limits, and recording for privileged sessions.',
        analogy:
            'The person who manages the vault never uses the same badge to enter the public lobby, where it could be copied. And vault access is granted only for the time needed, with a camera on.',
        example:
            'Practices:\n\nSeparate admin accounts from daily accounts\nTier 0: domain controllers and identity systems; Tier 1: servers; Tier 2: workstations and users\nDomain admins log on only to Tier 0 systems (use dedicated admin workstations)\nJust-in-time and just-enough access, with approval and expiry\nPassword vaulting and session recording (CyberArk, Delinea, or built-in options)\nMFA for all privileged access\nProtected Users group and authentication policies\nRegular access reviews\n\nCloud parallel: Entra ID Privileged Identity Management (PIM) provides just-in-time roles.',
        keyTakeaway:
            'A domain admin credential must never touch an ordinary workstation. Tiering stops one stolen credential from becoming total compromise.',
      ),
      ConceptLesson(
        title: 'Endpoint Management and Protection at Scale',
        definition:
            'Enterprises must manage thousands of devices consistently: patching, configuration, encryption, malware protection, and the ability to wipe lost devices. Mobile device management and endpoint detection platforms provide this control.',
        analogy:
            'It is fleet management for company vehicles: every vehicle is tracked, serviced on schedule, locked, and can be disabled remotely if stolen.',
        example:
            'Controls:\n\nMDM or UEM: Microsoft Intune, Jamf, Workspace ONE for configuration and compliance\nPatch management with defined timelines and reporting\nFull disk encryption (BitLocker, FileVault)\nEDR on all endpoints, with isolation capability\nApplication control (AppLocker, WDAC) and removal of local admin rights\nConditional access: allow access only from compliant, managed devices\nBYOD policy with containerisation of work data\nAsset inventory and lost-device procedures\nBrowser and email protections\n\nMetrics: percentage of devices compliant, patched, encrypted, and covered by EDR.',
        keyTakeaway:
            'Combine device compliance with identity. Access decisions should check both who you are and whether your device is healthy.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why is a domain controller one of the most critical assets in a Windows enterprise?',
        options: [
          'It stores marketing material',
          'It holds the directory and authenticates users, so controlling it means controlling the whole domain',
          'It makes the network faster',
          'It provides printers'
        ],
        correctIndex: 1,
        explanation:
            'Compromising a domain controller or a domain admin gives an attacker control over every joined system and account.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What problem does Windows LAPS solve?',
        options: [
          'It speeds up logins',
          'It gives each machine a unique, regularly rotated local administrator password, stopping credential reuse across machines',
          'It blocks viruses',
          'It encrypts disks'
        ],
        correctIndex: 1,
        explanation:
            'Unique local admin passwords prevent an attacker from using one stolen password to access many machines.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the main idea behind tiered administration?',
        options: [
          'Admins share one account',
          'High-privilege credentials are never used on lower-trust systems where they could be stolen',
          'Admins work only at night',
          'Users manage domain controllers'
        ],
        correctIndex: 1,
        explanation:
            'Separating privilege tiers prevents credential theft on workstations from leading to domain-wide compromise.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You find that service accounts with domain admin rights use passwords that have not changed for 8 years. What is the best remediation?',
        options: [
          'Leave them, they work',
          'Remove unneeded privileges, move to group managed service accounts or long random passwords, rotate, and monitor their use',
          'Share the passwords with the team',
          'Disable logging for them'
        ],
        correctIndex: 1,
        explanation:
            'Over-privileged, long-lived service account credentials are prime targets. Reduce privilege and strengthen and rotate them.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A domain administrator regularly logs in to an ordinary employee laptop to fix issues. What is the risk and the fix?',
        options: [
          'No risk',
          'Domain admin credentials can be stolen from that laptop; use separate admin accounts, dedicated admin workstations, and tiering',
          'The laptop will be slower',
          'It is encouraged'
        ],
        correctIndex: 1,
        explanation:
            'Privileged credentials exposed on lower-trust machines are a classic path to full domain compromise.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Enterprise Identity Hardening Plan',
      goal:
          'Build a small lab domain and write a hardening plan covering identity, privilege, and endpoints.',
      steps: [
        'In your isolated lab, install a Windows Server evaluation VM as a domain controller and join a Windows client VM',
        'Create OUs, standard users, an admin account for each tier, and a service account',
        'Apply Group Policy settings: password policy, account lockout, disable legacy protocols where possible, and enable audit policies',
        'Review privileged group membership and list who really needs each privilege',
        'Document 10 hardening actions, including LAPS, tiering, MFA, Protected Users, and monitoring of key Event IDs (4624, 4625, 4672, 4720, 4732)',
        'Write an endpoint compliance baseline: encryption, EDR, patching, local admin removal, and application control',
      ],
      expectedOutput:
          'Enterprise Hardening Plan (lab)\n\nLab: DC01 + WIN-CLIENT01, isolated network\nOUs: Tier0, Tier1, Tier2, Users, ServiceAccounts\nGPOs: password length 14, lockout after 5, audit logon and account changes, SMBv1 off\n\nPrivileged groups reviewed: Domain Admins 2 -> 1 (documented)\nHardening list: LAPS, admin tiering, MFA for admins, Protected Users, gMSA for services, central logging, patch SLAs, EDR, BitLocker, local admin removal\n\nMonitoring: 4624/4625/4672/4720/4732 alerts defined ✓',
      xpReward: 60,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 9
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l8_enterprise_architecture_grc',
    topicTitle: 'Enterprise Security Architecture, Risk & Governance',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 40,
    totalXp: 225,
    emoji: '🏛️',
    intro:
        'Technology alone does not protect an enterprise. Leaders need a security architecture that fits together, a way to manage risk, and governance that links security to business goals. This lesson gives you the big-picture skills that separate a technician from a security engineer who can advise leadership.',
    concepts: [
      ConceptLesson(
        title: 'Defence in Depth and Zero Trust Architecture',
        definition:
            'Defence in depth layers multiple independent controls so that a single failure does not lead to a breach. Zero trust architecture, described in NIST SP 800-207, removes implicit trust based on network location and verifies every access request.',
        analogy:
            'Defence in depth is a castle with a moat, walls, gatehouses, and guards. Zero trust adds a guard at every internal door who checks your identity and reason for being there every single time.',
        example:
            'Layers:\n\nPeople: training, clear policies\nIdentity: MFA, least privilege, conditional access\nDevices: managed and compliant endpoints with EDR\nNetwork: segmentation, microsegmentation, encrypted traffic\nApplications: secure development, WAF, API protection\nData: classification, encryption, DLP\nMonitoring: SIEM, detection, response\nResilience: backups, disaster recovery\n\nZero trust principles:\n  Verify explicitly (identity, device, location, behaviour)\n  Use least privilege access\n  Assume breach: segment, encrypt, and monitor everything',
        keyTakeaway:
            'Design so that any single control can fail without disaster. Trust is earned per request, not granted by being on the network.',
      ),
      ConceptLesson(
        title: 'Risk Management Basics',
        definition:
            'Risk management identifies assets, threats, and vulnerabilities, estimates the likelihood and impact of harm, and decides how to treat each risk: mitigate, transfer, avoid, or accept.',
        analogy:
            'It is deciding how to protect your home: lock the doors (mitigate), buy insurance (transfer), avoid leaving a car outside in a flood zone (avoid), or accept the small risk of a scratch (accept).',
        example:
            'Process:\n\n1. Identify assets and their value\n2. Identify threats and vulnerabilities\n3. Assess likelihood and impact (qualitative: low, medium, high; or quantitative in money)\n4. Calculate or rate the risk\n5. Choose a treatment and assign an owner\n6. Record in a risk register\n7. Review regularly\n\nSimple quantitative idea:\n  Annualised loss expectancy = single loss expectancy x annual rate of occurrence\n\nRisk appetite: the level of risk leadership is willing to accept. Decisions to accept risk must be made by the business owner, in writing.',
        keyTakeaway:
            'Security recommends, and the business decides. Make risks visible, quantify when you can, and record every acceptance with an owner and a review date.',
      ),
      ConceptLesson(
        title: 'Frameworks, Standards, and Compliance',
        definition:
            'Frameworks give structure to security programmes, and standards and laws set requirements that organisations must show they meet. Compliance proves controls exist, while good security makes them effective.',
        analogy:
            'A framework is the recipe book for a security programme. A standard is the exam syllabus, and compliance is the certificate that shows you have passed.',
        example:
            'Key references:\n\nNIST Cybersecurity Framework 2.0: Govern, Identify, Protect, Detect, Respond, Recover\nISO/IEC 27001: information security management system, with Annex A controls\nCIS Critical Security Controls v8\nSOC 2: trust services criteria for service providers\nPCI DSS: payment card data\nIndia: DPDP Act 2023, CERT-In directions, RBI and SEBI cyber security frameworks for regulated sectors\nGlobal privacy: GDPR\n\nTypical audit evidence: policies, risk register, access reviews, scan reports, incident records, training logs.',
        keyTakeaway:
            'Pick one framework as your backbone and map others to it. That avoids duplicated effort across many audits.',
      ),
      ConceptLesson(
        title: 'Business Continuity, Third-Party Risk, and Security Awareness',
        definition:
            'A secure enterprise plans for disruption, manages risk from suppliers, and builds a security-aware culture. These soft and strategic controls often decide how bad an incident becomes.',
        analogy:
            'A hospital has backup generators, checks its suppliers medicine quality, and trains every staff member in emergency procedures.',
        example:
            'Key practices:\n\nBusiness impact analysis: which processes matter most and how long can they be down\nBusiness continuity and disaster recovery plans with tested failover (RTO and RPO targets)\nIncident response plan with regular tabletop exercises\nVendor risk management: security questionnaires, contracts with security clauses, ongoing monitoring, and limited access for suppliers\nSoftware supply chain controls\nSecurity awareness: phishing simulations, role-based training, easy reporting channels\nSecurity champions in business teams\nExecutive reporting with clear metrics',
        keyTakeaway:
            'Test your plans. An untested disaster recovery plan is just a document, and a vendor with weak security can become your breach.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which statement best captures zero trust?',
        options: [
          'Trust everything inside the corporate network',
          'Never trust implicitly; verify identity, device, and context for every access request',
          'Disable all access',
          'Trust only the VPN'
        ],
        correctIndex: 1,
        explanation:
            'Zero trust removes implicit trust from network location and evaluates each request on its merits.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Who should make the final decision to ACCEPT a significant security risk?',
        options: [
          'The security analyst alone',
          'The business risk owner with authority, documented in the risk register',
          'The intern',
          'The vendor'
        ],
        correctIndex: 1,
        explanation:
            'Risk acceptance is a business decision. Security advises, and the accountable owner decides and records it.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What are the six functions of NIST Cybersecurity Framework 2.0?',
        options: [
          'Govern, Identify, Protect, Detect, Respond, Recover',
          'Plan, Build, Test, Ship, Run, Retire',
          'Scan, Patch, Backup, Encrypt, Log, Report',
          'Hash, Sign, Verify, Encrypt, Decrypt, Rotate'
        ],
        correctIndex: 0,
        explanation:
            'CSF 2.0 added Govern to the original five functions to emphasise strategy and oversight.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A critical supplier with access to your customer database suffers a breach. What control would best have reduced your exposure?',
        options: [
          'Giving them admin access to everything',
          'Vendor risk management with least privilege access, contractual security requirements, monitoring, and incident notification clauses',
          'Not documenting the relationship',
          'Trusting them fully'
        ],
        correctIndex: 1,
        explanation:
            'Limiting what suppliers can reach and holding them to security obligations reduces third-party risk.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'The CFO asks why the company should spend money on a 100,000 USD security control. What is a good approach?',
        options: [
          'Say it is required by security',
          'Explain the risk in business terms: likelihood, impact, expected loss, options considered, and how the control reduces risk compared with cost',
          'Use technical jargon only',
          'Avoid answering'
        ],
        correctIndex: 1,
        explanation:
            'Translating risk into business impact and comparing options is how security earns support from leadership.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Security Architecture and Risk Register for a Company',
      goal:
          'Produce a layered security architecture and a risk register for a fictional mid-sized company.',
      steps: [
        'Scenario: a 600-person fintech with on-premises AD, cloud workloads, a mobile app, and third-party payment processors',
        'Draw a layered architecture showing identity, endpoints, network segmentation, cloud, applications, data, and monitoring',
        'List 12 risks with asset, threat, likelihood, impact, treatment, owner, and review date',
        'Map your key controls to NIST CSF 2.0 functions and to 5 relevant CIS Controls',
        'Define RTO and RPO for 3 critical services and a testing schedule for recovery',
        'Write a one-page executive summary with top 5 risks, recommended investments, and expected risk reduction',
      ],
      expectedOutput:
          'Architecture and Risk Pack: FinCo\n\nLayers: SSO + MFA | managed devices + EDR | segmented network | cloud guardrails + CSPM | WAF + API security | encryption + DLP | SIEM + SOC | immutable backups\n\nRisk register (12): ransomware (High), compromised admin (High), third-party breach (Medium), misconfigured bucket (Medium)...\n\nCSF mapping: Govern, Identify, Protect, Detect, Respond, Recover ✓\nRTO/RPO: payments 1 h / 5 min; reporting 8 h / 4 h; HR 24 h / 24 h\n\nExecutive summary written ✓',
      xpReward: 60,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 10
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l8_cloud_capstone',
    topicTitle: 'Capstone: Secure a Cloud Environment End to End',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 60,
    totalXp: 270,
    emoji: '🏆',
    intro:
        'This is your Level 8 capstone. You will design, build, harden, monitor, and test a small but realistic cloud environment in your own learning account, using infrastructure as code, least-privilege identity, protected data, logging, detections, and posture scanning. You will finish with an architecture document and a verified before-and-after security report.',
    concepts: [
      ConceptLesson(
        title: 'Planning the Secure Cloud Build',
        definition:
            'A good build starts with requirements and a threat model, not with clicking in the console. You decide what must be protected, who needs access, and how the environment will be monitored before creating anything.',
        analogy:
            'An architect draws plans, checks building codes, and plans safety exits before the first brick is laid.',
        example:
            'Planning checklist:\n\nWorkload: a small three-tier web app with a database and file storage\nSecurity goals: no public database, least-privilege roles, encrypted data, central logs, alerts for key risky events\nThreats (STRIDE): stolen credentials, exposed storage, vulnerable web app, over-privileged roles, tampered logs\nBudget guardrail: free-tier components, a small budget alert, automatic clean-up plan\nRepeatability: everything created with Terraform or equivalent IaC in a Git repository',
        keyTakeaway:
            'Write the goals and threats first. They tell you which controls to build and how to prove they work.',
      ),
      ConceptLesson(
        title: 'Verifying Security with Tests and Scans',
        definition:
            'A secure design is only proven when you test it. You verify identities, network exposure, data protection, logging, and detections with scans and deliberate safe checks.',
        analogy:
            'After building a house you test the smoke alarms, try the locks, and check that the fire exits open. You do not just trust the plans.',
        example:
            'Verification activities:\n\nIAM: confirm each role can do only its intended actions, and that forbidden actions fail\nNetwork: confirm the database is unreachable from the internet and management ports are closed\nData: confirm storage blocks public access and objects are encrypted\nLogging: confirm audit logs arrive in the separate logging bucket with integrity validation\nDetections: trigger safe test events (create and delete a test key, open then close a test rule) and confirm alerts\nPosture: run Prowler or the native scanner, and compare findings before and after hardening\nIaC: run Checkov or Trivy in the pipeline',
        keyTakeaway:
            'For every control you claim, keep a test or screenshot that shows it works. Evidence is what turns a design into proof.',
      ),
      ConceptLesson(
        title: 'Cost, Clean-Up, and Safety Rules',
        definition:
            'Cloud labs can generate unexpected bills if resources are left running. A responsible engineer plans costs, tags resources, and removes everything when finished.',
        analogy:
            'Leaving taps running in a rented flat costs you money even when you are away. Switch everything off when you leave.',
        example:
            'Rules:\n\nUse a dedicated learning account with MFA and a budget alert\nTag every resource with project and owner\nUse free-tier eligible services and small sizes\nNever use real personal data or real company secrets\nDo not expose anything publicly except what the lab requires, and then only briefly\nDestroy resources with the IaC destroy command when finished and verify in the console\nCheck the billing dashboard the next day\nNever test against accounts or systems you do not own',
        keyTakeaway:
            'Clean-up is part of the project. A verified destroy and a zero-cost bill show maturity and protect your wallet.',
      ),
      ConceptLesson(
        title: 'Presenting a Cloud Security Portfolio',
        definition:
            'Your capstone becomes powerful career evidence when documented clearly: architecture, controls, tests, findings, and lessons learned, with no real secrets or account identifiers.',
        analogy:
            'A before-and-after renovation portfolio with plans, photos, and inspection reports is far more convincing than a statement that you are good at building.',
        example:
            'Portfolio contents:\n\nArchitecture diagram and threat model\nTerraform repository with README, pipeline, and scan results\nIAM design and test results\nLogging and detection list with proof of alerts\nPosture scan before and after, with remediation list\nCost and clean-up evidence\nLessons learned and what you would add with more time\n\nSafe publishing:\n  Remove account IDs, keys, ARNs of real resources where sensitive, and any personal data\n  State clearly that it was built in a personal learning account\n  Keep your repository free of secrets (run a scanner)',
        keyTakeaway:
            'Clear diagrams, working code, and measured results make a cloud security portfolio stand out to hiring managers.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why should you plan goals and threats before building in the console?',
        options: [
          'To delay the project',
          'So the controls you build address real risks and you know what to test',
          'Because consoles require it',
          'To increase costs'
        ],
        correctIndex: 1,
        explanation:
            'A plan ties controls to risks and gives you clear success criteria.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which is the best evidence that a detection works?',
        options: [
          'A claim in the README',
          'A safe test event that triggered the alert, with a screenshot or log of the alert',
          'The rule name',
          'A colourful dashboard'
        ],
        correctIndex: 1,
        explanation:
            'Triggering the rule safely and capturing the alert proves it works end to end.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What should you remove or avoid when publishing a cloud lab write-up?',
        options: [
          'The architecture diagram',
          'Access keys, secrets, sensitive account identifiers, and any personal data',
          'The lessons learned section',
          'The scan results'
        ],
        correctIndex: 1,
        explanation:
            'Never publish credentials or sensitive identifiers. Redact and scan the repository before sharing.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You finish the lab at night and are tired. What is the best end-of-project step?',
        options: [
          'Leave everything running',
          'Run the IaC destroy, check the console for leftovers, and review billing the next day',
          'Delete only the screenshots',
          'Share the account credentials with a friend'
        ],
        correctIndex: 1,
        explanation:
            'Destroying resources and verifying the bill prevents costs and removes unmonitored risks.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your posture scan shows 40 findings before hardening and 6 after. What additional information makes this result more credible?',
        options: [
          'Nothing',
          'A list of which findings were fixed, which were accepted with reasons, and evidence such as scan output and configuration screenshots',
          'A larger font',
          'A different scanner brand name'
        ],
        correctIndex: 1,
        explanation:
            'Detailed accounting of fixes and accepted risks shows real engineering and honest reporting.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Level 8 Capstone: Secure a Small Cloud Environment with IaC',
      goal:
          'Build, harden, monitor, and verify a three-tier cloud environment in your own learning account, then publish a sanitised portfolio.',
      steps: [
        'Write a short requirements and STRIDE threat model for a small three-tier web application with a database and file storage',
        'Create a Git repository and write Terraform (or CloudFormation or Bicep) for a VPC or VNet with public and private subnets, restricted security groups, and no public database',
        'Create least-privilege IAM roles for the application, a developer, and an auditor, with MFA on the owner account and no root keys',
        'Add a storage bucket with public access blocked, default encryption with a customer-managed key, versioning, and access logging, and store a sample secret in a secrets manager',
        'Enable the audit trail in all regions to a separate protected log bucket, enable the native threat detection service, and create alerts for 5 high-value events',
        'Add a CI pipeline that runs IaC scanning (Checkov or Trivy) and secret scanning and blocks insecure changes',
        'Run a posture scan before and after hardening, and record findings, fixes, and accepted risks',
        'Safely trigger your detections, confirm alerts, and write a short incident playbook for a compromised access key',
        'Run the destroy command, confirm clean-up in the console, and check cost the next day',
        'Publish a sanitised case study with diagrams, code, scan results, test evidence, and lessons learned, stating it was built in a personal learning account',
      ],
      expectedOutput:
          'Cloud Security Capstone (learning account)\n\nThreat model: 9 threats (STRIDE) mapped to controls\nIaC: Terraform repo with VPC, 3 tiers, SGs, IAM roles, S3 (SSE-KMS, versioning, Block Public Access), Secrets Manager\n\nLogging and detection: CloudTrail all regions -> separate bucket; GuardDuty; 5 alerts tested ✓\nPipeline: Checkov + gitleaks block insecure PRs ✓\n\nPosture: 41 findings before -> 7 after (4 fixed by IaC, 3 accepted with reasons)\nPlaybook: compromised key ✓\n\nDestroy verified; cost 0.00 USD ✓\nPublished sanitised case study with diagrams and results ✓',
      xpReward: 105,
    ),
  ),
];
