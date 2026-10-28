// ══════════════════════════════════════════════════════════════════════
// lib/data/courses/dynamic_career_paths.dart
//
// Metadata-only "curriculum skeleton" for career paths whose lesson
// CONTENT is generated dynamically at runtime by CourseGeneratorService
// (via the backend + AI, or mock mode when no API key is configured).
//
// IMPORTANT: This file intentionally contains NO lesson content
// (no definitions, quizzes, analogies, etc.) — only topic labels used
// to build the AI prompt. Actual TopicCourse content always comes from
// CourseGeneratorService.generateOrLoadCourse() at runtime.
//
// STRUCTURE (matches the Software Engineer / AI & Data paths):
// Every career here now runs the same 10-level professional arc —
// Beginner Foundations → Fundamentals → Fundamentals (applied) →
// Intermediate → Intermediate (applied) → Advanced → Advanced (applied)
// → Projects/Capstone → Professional & Industry Practices → Interview
// & Job Prep — targeting ~100 real, career-relevant topics per career
// (no filler, no duplicates), the same way the real 633-lesson paths
// are structured level by level.
//
// Existing levels/topics were NEVER edited or reworded — only new
// topics were appended to existing levels and new levels appended
// after the last existing one, so nothing already live was changed,
// deleted, or rewritten.
//
// Every path is written the way a real engineering org would structure
// an internal training ladder, naming the actual tools, frameworks, and
// standards a working professional in that role uses day to day (Burp
// Suite, MITRE ATT&CK, Figma, Solidity, Playwright, AWS Well-Architected,
// etc.), not generic "learn the basics" filler.
//
// Add a new AI-generated career by adding one GeneratedCareerPath here.
// No other file needs to change — CourseGeneratorService, TopicCourse,
// and CourseEngineScreen all remain exactly as they are.
// ══════════════════════════════════════════════════════════════════════

class GeneratedLevel {
  final int level;
  final String levelTitle;
  final List<String> topics;
  final String difficulty; // Easy / Medium / Hard

  const GeneratedLevel({
    required this.level,
    required this.levelTitle,
    required this.topics,
    required this.difficulty,
  });
}

class GeneratedCareerPath {
  final String careerId;
  final String careerTitle;
  final String categoryId;
  final String emoji;
  final List<GeneratedLevel> levels;

  const GeneratedCareerPath({
    required this.careerId,
    required this.careerTitle,
    required this.categoryId,
    required this.emoji,
    required this.levels,
  });
}

const List<GeneratedCareerPath> dynamicCareerPaths = [
  // ════════════════════════════════════════════════════════════════
  // ☁️ CLOUD & DEVOPS (categoryId: cloud_devops) — unchanged this round
  // ════════════════════════════════════════════════════════════════
  GeneratedCareerPath(
    careerId: 'cloud_devops_engineer_ai',
    careerTitle: 'DevOps Engineer',
    categoryId: 'cloud_devops',
    emoji: '⚙️',
    levels: [
      GeneratedLevel(
        level: 1,
        levelTitle: 'DevOps Foundations & Linux',
        difficulty: 'Easy',
        topics: [
          'DevOps culture: breaking the Dev vs Ops wall',
          'Linux administration essentials for DevOps',
          'Shell scripting (Bash) for automation',
          'Git branching strategies used in real teams (trunk-based, GitFlow)',
        ],
      ),
      GeneratedLevel(
        level: 2,
        levelTitle: 'Containerisation with Docker',
        difficulty: 'Medium',
        topics: [
          'Writing production-grade Dockerfiles (multi-stage builds)',
          'Docker Compose for local multi-service development',
          'Image optimisation and vulnerability scanning',
          'Container registries and image versioning strategy',
        ],
      ),
      GeneratedLevel(
        level: 3,
        levelTitle: 'CI/CD Pipelines',
        difficulty: 'Medium',
        topics: [
          'Building pipelines with GitHub Actions / GitLab CI / Jenkins',
          'Automated testing, linting, and quality gates in CI',
          'Deployment strategies: blue-green, canary, rolling',
          'Secrets management in pipelines (Vault, GitHub Secrets)',
        ],
      ),
      GeneratedLevel(
        level: 4,
        levelTitle: 'Kubernetes in Production',
        difficulty: 'Hard',
        topics: [
          'Core Kubernetes objects: pods, deployments, services, ingress',
          'Helm charts for repeatable deployments',
          'Autoscaling (HPA/VPA) and resource requests/limits',
          'Debugging a failing pod like a production incident',
        ],
      ),
      GeneratedLevel(
        level: 5,
        levelTitle: 'Infrastructure as Code',
        difficulty: 'Hard',
        topics: [
          'Terraform fundamentals: state, providers, modules',
          'Writing reusable, environment-aware IaC modules',
          'Ansible for configuration management',
          'GitOps workflow with ArgoCD / FluxCD',
        ],
      ),
      GeneratedLevel(
        level: 6,
        levelTitle: 'Observability & Site Reliability',
        difficulty: 'Hard',
        topics: [
          'Metrics, logs, and traces: the three pillars of observability',
          'Prometheus and Grafana dashboards that actually get used',
          'Defining SLIs, SLOs, and error budgets',
          'On-call practices and writing a blameless postmortem',
        ],
      ),
      GeneratedLevel(
        level: 7,
        levelTitle: 'Advanced Kubernetes & Service Mesh',
        difficulty: 'Hard',
        topics: [
          'Service mesh fundamentals (Istio/Linkerd concepts)',
          'Multi-cluster and multi-tenant Kubernetes design',
          'StatefulSets and running stateful workloads on K8s',
          'Kubernetes security: RBAC, network policies, admission control',
          'Operators and the operator pattern for automation',
        ],
      ),
      GeneratedLevel(
        level: 8,
        levelTitle: 'DevOps Capstone Project',
        difficulty: 'Hard',
        topics: [
          'Designing a complete CI/CD + IaC pipeline from scratch',
          'Deploying a multi-service app to Kubernetes end-to-end',
          'Setting up full observability for the deployed system',
          'Running a simulated production incident and resolving it',
          'Documenting the platform for another engineer to operate',
        ],
      ),
      GeneratedLevel(
        level: 9,
        levelTitle: 'Platform Engineering & Team Practices',
        difficulty: 'Medium',
        topics: [
          'Building an internal developer platform (IDP)',
          'Self-service infrastructure for product teams',
          'DevOps culture: measuring DORA metrics',
          'Cost and reliability trade-offs in platform decisions',
          'Mentoring teams on DevOps best practices',
        ],
      ),
      GeneratedLevel(
        level: 10,
        levelTitle: 'Interview & Job Preparation',
        difficulty: 'Medium',
        topics: [
          'Common DevOps engineer interview questions',
          'Live troubleshooting scenario practice',
          'Explaining a past incident using the STAR method',
          'Negotiating DevOps/SRE offers and role levelling',
          'Continuing education: certifications and community resources',
        ],
      ),
    ],
  ),

  GeneratedCareerPath(
    careerId: 'cloud_solutions_engineer_ai',
    careerTitle: 'Cloud Engineer (AWS / Azure / GCP)',
    categoryId: 'cloud_devops',
    emoji: '☁️',
    levels: [
      GeneratedLevel(
        level: 1,
        levelTitle: 'Cloud Computing Foundations',
        difficulty: 'Easy',
        topics: [
          'IaaS vs PaaS vs SaaS and when each fits',
          'Core compute: EC2 / Azure VMs / Compute Engine',
          'Cloud networking basics: VPCs, subnets, security groups',
          'Identity and Access Management (IAM) fundamentals',
        ],
      ),
      GeneratedLevel(
        level: 2,
        levelTitle: 'Storage, Databases & Serverless',
        difficulty: 'Medium',
        topics: [
          'Object storage (S3 / Blob Storage) and lifecycle policies',
          'Managed databases: RDS, DynamoDB, Cosmos DB trade-offs',
          'Building with serverless (Lambda / Azure Functions)',
          'Event-driven architecture with SQS/SNS or equivalents',
        ],
      ),
      GeneratedLevel(
        level: 3,
        levelTitle: 'Cloud Networking & Security',
        difficulty: 'Medium',
        topics: [
          'Load balancers, CDNs, and DNS routing policies',
          'Designing a secure multi-tier VPC architecture',
          'Encryption at rest and in transit, key management (KMS)',
          'Compliance basics: shared responsibility model',
        ],
      ),
      GeneratedLevel(
        level: 4,
        levelTitle: 'Cost Optimisation & Well-Architected Design',
        difficulty: 'Hard',
        topics: [
          'The AWS Well-Architected Framework\'s 6 pillars',
          'Right-sizing, reserved instances, and spot strategy',
          'Tagging strategy for cost visibility',
          'Designing for high availability across regions',
        ],
      ),
      GeneratedLevel(
        level: 5,
        levelTitle: 'Cloud Certification Readiness',
        difficulty: 'Hard',
        topics: [
          'Exam-style architecture scenarios and trade-off questions',
          'Disaster recovery patterns: backup/restore to multi-region',
          'Migration strategies: rehost, replatform, refactor',
          'Preparing for AWS Solutions Architect / Azure Administrator exams',
        ],
      ),
      GeneratedLevel(
        level: 6,
        levelTitle: 'Automation & Infrastructure as Code',
        difficulty: 'Hard',
        topics: [
          'Provisioning cloud resources with Terraform/CloudFormation',
          'Building reusable infrastructure modules',
          'CI/CD for infrastructure changes',
          'Policy-as-code and guardrails (Sentinel, AWS Config Rules)',
        ],
      ),
      GeneratedLevel(
        level: 7,
        levelTitle: 'Cloud-Native Application Architecture',
        difficulty: 'Hard',
        topics: [
          'Containerising applications for cloud deployment',
          'Managed Kubernetes services (EKS, AKS, GKE)',
          'Cloud-native CI/CD pipelines',
          'Designing for elasticity and auto-scaling',
        ],
      ),
      GeneratedLevel(
        level: 8,
        levelTitle: 'Cloud Capstone Project',
        difficulty: 'Hard',
        topics: [
          'Designing a complete multi-tier cloud architecture end-to-end',
          'Provisioning the full environment with infrastructure as code',
          'Implementing monitoring, alerting, and cost controls',
          'Presenting the architecture and trade-offs to a mock panel',
        ],
      ),
      GeneratedLevel(
        level: 9,
        levelTitle: 'Cloud Governance & FinOps',
        difficulty: 'Medium',
        topics: [
          'Multi-account/subscription governance strategy',
          'FinOps practices for ongoing cost accountability',
          'Security posture management across cloud accounts',
          'Building a cloud center of excellence',
        ],
      ),
      GeneratedLevel(
        level: 10,
        levelTitle: 'Interview & Job Preparation',
        difficulty: 'Medium',
        topics: [
          'Common cloud engineer interview questions',
          'Scenario-based architecture interview practice',
          'Explaining past cloud projects using the STAR method',
          'Negotiating cloud engineer offers and choosing a specialisation',
        ],
      ),
    ],
  ),

  // ════════════════════════════════════════════════════════════════
  // 🔒 SECURITY (categoryId: cyber_security)
  // ════════════════════════════════════════════════════════════════
  GeneratedCareerPath(
    careerId: 'sec_ethical_hacking_ai',
    careerTitle: 'Ethical Hacking & Penetration Testing',
    categoryId: 'cyber_security',
    emoji: '🕵️',
    levels: [
      GeneratedLevel(
        level: 1,
        levelTitle: 'Security Foundations & Attacker Mindset',
        difficulty: 'Easy',
        topics: const [],
      ),
      GeneratedLevel(
        level: 2,
        levelTitle: 'Reconnaissance & Enumeration',
        difficulty: 'Easy',
        topics: const [],
      ),
      GeneratedLevel(
        level: 3,
        levelTitle: 'Web Application Exploitation',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 4,
        levelTitle: 'Network & Infrastructure Exploitation',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 5,
        levelTitle: 'Active Directory & Post-Exploitation',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 6,
        levelTitle: 'Professional Reporting & Bug Bounty',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 7,
        levelTitle: 'Cloud & Container Security Testing',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 8,
        levelTitle: 'Mobile & IoT Penetration Testing',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 9,
        levelTitle: 'Red Team Operations',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 10,
        levelTitle: 'Career Prep: Interviews & Certifications',
        difficulty: 'Medium',
        topics: const [],
      ),
    ],
  ),

  GeneratedCareerPath(
    careerId: 'sec_soc_analyst_ai',
    careerTitle: 'Security Operations (SOC) Analyst',
    categoryId: 'cyber_security',
    emoji: '🛰️',
    levels: [
      GeneratedLevel(
        level: 1,
        levelTitle: 'SOC Fundamentals & Log Sources',
        difficulty: 'Easy',
        topics: const [],
      ),
      GeneratedLevel(
        level: 2,
        levelTitle: 'Detection Engineering',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 3,
        levelTitle: 'Incident Response',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 4,
        levelTitle: 'Threat Intelligence & Hunting',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 5,
        levelTitle: 'SOC Leadership & Automation',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 6,
        levelTitle: 'Cloud & Endpoint Detection',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 7,
        levelTitle: 'Malware Analysis Basics for SOC',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 8,
        levelTitle: 'Advanced Investigations & Digital Forensics',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 9,
        levelTitle: 'SOC Program & Compliance',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 10,
        levelTitle: 'Career Prep: Interviews & Certifications',
        difficulty: 'Medium',
        topics: const [],
      ),
    ],
  ),

  // ════════════════════════════════════════════════════════════════
  // 🎨 DESIGN & PRODUCT (categoryId: design_product)
  // ════════════════════════════════════════════════════════════════
  GeneratedCareerPath(
    careerId: 'design_ux_ui_ai',
    careerTitle: 'UX/UI Designer',
    categoryId: 'design_product',
    emoji: '🎨',
    levels: [
      GeneratedLevel(
        level: 1,
        levelTitle: 'Design Thinking & User Research',
        difficulty: 'Easy',
        topics: const [],
      ),
      GeneratedLevel(
        level: 2,
        levelTitle: 'Wireframing & Prototyping in Figma',
        difficulty: 'Easy',
        topics: const [],
      ),
      GeneratedLevel(
        level: 3,
        levelTitle: 'Visual Design Systems',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 4,
        levelTitle: 'Interaction & Motion Design',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 5,
        levelTitle: 'UX Strategy & Measurement',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 6,
        levelTitle: 'Advanced UX Research Methods',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 7,
        levelTitle: 'Product Design for Scale',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 8,
        levelTitle: 'Portfolio & Capstone Project',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 9,
        levelTitle: 'Professional Practice & Leadership',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 10,
        levelTitle: 'Interview & Job Preparation',
        difficulty: 'Medium',
        topics: const [],
      ),
    ],
  ),

  GeneratedCareerPath(
    careerId: 'design_product_manager_ai',
    careerTitle: 'Product Manager',
    categoryId: 'design_product',
    emoji: '📱',
    levels: [
      GeneratedLevel(
        level: 1,
        levelTitle: 'Product Fundamentals',
        difficulty: 'Easy',
        topics: const [],
      ),
      GeneratedLevel(
        level: 2,
        levelTitle: 'Prioritisation & Roadmapping',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 3,
        levelTitle: 'Data-Driven Product Decisions',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 4,
        levelTitle: 'Go-to-Market & Product Strategy',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 5,
        levelTitle: 'Technical Fluency for PMs',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 6,
        levelTitle: 'Growth Product Management',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 7,
        levelTitle: 'Platform & B2B Product Management',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 8,
        levelTitle: 'Product Leadership & Team Building',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 9,
        levelTitle: 'Case Studies & Capstone Project',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 10,
        levelTitle: 'Interview & Job Preparation',
        difficulty: 'Medium',
        topics: const [],
      ),
    ],
  ),

  // ════════════════════════════════════════════════════════════════
  // ⛓️ EMERGING TECH (categoryId: emerging_tech)
  // ════════════════════════════════════════════════════════════════
  GeneratedCareerPath(
    careerId: 'emerging_blockchain_dev_ai',
    careerTitle: 'Blockchain Developer',
    categoryId: 'emerging_tech',
    emoji: '⛓️',
    levels: [
      GeneratedLevel(
        level: 1,
        levelTitle: 'Blockchain Foundations',
        difficulty: 'Easy',
        topics: const [],
      ),
      GeneratedLevel(
        level: 2,
        levelTitle: 'Smart Contract Development with Solidity',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 3,
        levelTitle: 'Full-Stack DApp Development',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 4,
        levelTitle: 'DeFi & Token Standards',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 5,
        levelTitle: 'Smart Contract Security & Auditing',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 6,
        levelTitle: 'Layer 2 & Scaling Solutions',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 7,
        levelTitle: 'Advanced DeFi & Protocol Design',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 8,
        levelTitle: 'Blockchain Capstone Project',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 9,
        levelTitle: 'Professional & Industry Practices',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 10,
        levelTitle: 'Interview & Job Preparation',
        difficulty: 'Medium',
        topics: const [],
      ),
    ],
  ),

  GeneratedCareerPath(
    careerId: 'emerging_arvr_dev_ai',
    careerTitle: 'AR/VR & Spatial Computing Developer',
    categoryId: 'emerging_tech',
    emoji: '🕶️',
    levels: [
      GeneratedLevel(
        level: 1,
        levelTitle: 'Spatial Computing Foundations',
        difficulty: 'Easy',
        topics: const [],
      ),
      GeneratedLevel(
        level: 2,
        levelTitle: 'Building Immersive Scenes',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 3,
        levelTitle: 'Advanced Interaction & Multiplayer',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 4,
        levelTitle: 'Intermediate XR Development',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 5,
        levelTitle: 'AR Development Deep Dive',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 6,
        levelTitle: 'Advanced Graphics & Shaders',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 7,
        levelTitle: 'Multiplayer & Social XR',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 8,
        levelTitle: 'XR Capstone Project',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 9,
        levelTitle: 'Professional & Industry Practices',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 10,
        levelTitle: 'Interview & Job Preparation',
        difficulty: 'Medium',
        topics: const [],
      ),
    ],
  ),

  // ════════════════════════════════════════════════════════════════
  // 🧪 TESTING & QA (categoryId: testing_qa)
  // ════════════════════════════════════════════════════════════════
  GeneratedCareerPath(
    careerId: 'qa_manual_testing_ai',
    careerTitle: 'QA / Manual Testing',
    categoryId: 'testing_qa',
    emoji: '🧪',
    levels: [
      GeneratedLevel(
        level: 1,
        levelTitle: 'Testing Foundations',
        difficulty: 'Easy',
        topics: const [],
      ),
      GeneratedLevel(
        level: 2,
        levelTitle: 'Test Design Techniques',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 3,
        levelTitle: 'API & Non-Functional Testing',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 4,
        levelTitle: 'QA Strategy & Leadership',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 5,
        levelTitle: 'Mobile & Cross-Platform Testing',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 6,
        levelTitle: 'Test Documentation & Reporting',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 7,
        levelTitle: 'Specialized Testing Domains',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 8,
        levelTitle: 'QA Capstone Project',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 9,
        levelTitle: 'Professional & Industry Practices',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 10,
        levelTitle: 'Interview & Job Preparation',
        difficulty: 'Medium',
        topics: const [],
      ),
    ],
  ),

  GeneratedCareerPath(
    careerId: 'qa_sdet_ai',
    careerTitle: 'SDET / Test Automation Engineer',
    categoryId: 'testing_qa',
    emoji: '⚙️',
    levels: [
      GeneratedLevel(
        level: 1,
        levelTitle: 'Automation Foundations',
        difficulty: 'Easy',
        topics: const [],
      ),
      GeneratedLevel(
        level: 2,
        levelTitle: 'UI Automation at Scale',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 3,
        levelTitle: 'API Automation & CI/CD Integration',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 4,
        levelTitle: 'Advanced Test Architecture',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 5,
        levelTitle: 'Performance & Load Test Automation',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 6,
        levelTitle: 'Automation Framework Design',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 7,
        levelTitle: 'Cloud & Containerised Test Execution',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 8,
        levelTitle: 'SDET Capstone Project',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 9,
        levelTitle: 'Professional & Industry Practices',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 10,
        levelTitle: 'Interview & Job Preparation',
        difficulty: 'Medium',
        topics: const [],
      ),
    ],
  ),

  // ════════════════════════════════════════════════════════════════
  // 📈 SPECIALIZED (categoryId: specialized)
  // ════════════════════════════════════════════════════════════════
  GeneratedCareerPath(
    careerId: 'spec_solutions_architect_ai',
    careerTitle: 'Solutions Architect',
    categoryId: 'specialized',
    emoji: '🏗️',
    levels: [
      GeneratedLevel(
        level: 1,
        levelTitle: 'Architecture Foundations',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 2,
        levelTitle: 'Scalable System Design',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 3,
        levelTitle: 'Cloud, Cost & Security Architecture',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 4,
        levelTitle: 'Architecture Leadership',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 5,
        levelTitle: 'Integration & API Architecture',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 6,
        levelTitle: 'Data Architecture',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 7,
        levelTitle: 'Migration & Modernisation Projects',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 8,
        levelTitle: 'Architecture Capstone Project',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 9,
        levelTitle: 'Professional & Industry Practices',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 10,
        levelTitle: 'Interview & Job Preparation',
        difficulty: 'Medium',
        topics: const [],
      ),
    ],
  ),

  GeneratedCareerPath(
    careerId: 'spec_engineering_manager_ai',
    careerTitle: 'Engineering Manager',
    categoryId: 'specialized',
    emoji: '🧑‍💼',
    levels: [
      GeneratedLevel(
        level: 1,
        levelTitle: 'People Management Foundations',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 2,
        levelTitle: 'Team & Delivery Management',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 3,
        levelTitle: 'Engineering Leadership',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 4,
        levelTitle: 'Hiring & Team Building',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 5,
        levelTitle: 'Performance & Career Development',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 6,
        levelTitle: 'Technical Strategy & Execution',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 7,
        levelTitle: 'Cross-Functional Leadership',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 8,
        levelTitle: 'Engineering Management Capstone',
        difficulty: 'Hard',
        topics: const [],
      ),
      GeneratedLevel(
        level: 9,
        levelTitle: 'Professional & Industry Practices',
        difficulty: 'Medium',
        topics: const [],
      ),
      GeneratedLevel(
        level: 10,
        levelTitle: 'Interview & Job Preparation',
        difficulty: 'Medium',
        topics: const [],
      ),
    ],
  ),
];
