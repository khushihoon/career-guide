import '../../models/course_content_data.dart';

const List<TopicCourse> aiEngineerLevel10 = [
  TopicCourse(
    id: 'ai_resume_ats_optimization_l10',
    topicTitle: 'AI Engineer Resume & ATS Optimization',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Expert',
    estimatedMinutes: 35,
    totalXp: 180,
    emoji: '📄',
    intro:
        'Your resume is the first filter every hiring manager applies. At FAANG companies, a single job posting receives 5,000+ applications — the average recruiter spends 7 seconds on your resume before deciding. This lesson teaches you to craft an AI Engineer resume that passes ATS filters, impresses technical recruiters, and lands interviews at top companies.',
    concepts: [
      ConceptLesson(
        title: 'How AI Engineer Resumes Are Actually Evaluated',
        definition:
            'Resumes pass through three filters sequentially: an ATS (Applicant Tracking System) scans for keyword matches, a recruiter screens for role fit in under 10 seconds, and a technical hiring manager evaluates technical depth. Each filter has different criteria — your resume must satisfy all three simultaneously.',
        analogy:
            'Your resume is like a product going through quality checkpoints on a factory line. The ATS is the first automated scanner — if it cannot read your file format or find the required keywords, your resume is rejected before any human sees it. The recruiter is the human quality check — looking for clear signals of role relevance in seconds. The hiring manager is the expert — evaluating actual technical substance.',
        example:
            'A Google ML engineer role passes 60,000 applications through ATS (selects 3,000), recruiters screen (select 300), hiring managers review (select 100 for phone screens). Your resume must clear all three stages. Most candidates fail at stage 1 — poor ATS optimization — before any human ever reads their resume.',
        keyTakeaway:
            'The #1 mistake AI engineers make on resumes: writing for humans and forgetting ATS. Use simple, single-column formatting (not tables or text boxes), standard section headers, and include exact keywords from the job description in context. ATS tools like Workday, Greenhouse, and Lever parse text — fancy designs confuse parsers.',
      ),
      ConceptLesson(
        title: 'The AI Engineer Resume Structure',
        definition:
            'An effective AI Engineer resume has exactly five sections in order: Contact Information, Professional Summary (3 lines max), Technical Skills, Work Experience (with quantified achievements), and Projects. Education comes after experience unless you are a recent graduate.',
        analogy:
            'Your resume structure is like a news article: the most important information comes first (headline = summary), supporting details follow in descending importance (body = experience), and background context comes last (footer = education). Readers scan top-to-bottom — front-load impact.',
        example:
            'Ineffective: "Responsible for training machine learning models and collaborating with team members to improve performance."\nEffective: "Trained and deployed a BERT-based NLP classifier (92% F1) that automated 73% of customer support ticket routing, saving ₹45L/year in manual processing costs at a team of 3 engineers."\nThe second version has: metric, technology, business impact, and scale — everything a hiring manager needs.',
        keyTakeaway:
            'Every bullet point in your Work Experience section must follow the XYZ formula: "Accomplished X by doing Y resulting in Z." Remove all soft skill words (worked with, collaborated, helped, assisted). Replace them with strong verbs (designed, built, deployed, reduced, improved, automated) followed by specific metrics.',
        codeSnippet:
            '# Resume bullet point formula (not code — formatting template)\n\n# WEAK (tells, not shows):\n# - Worked on machine learning models for the team\n# - Helped improve model performance\n# - Collaborated with data scientists\n\n# STRONG (XYZ formula with metrics):\n# - Designed and deployed a real-time fraud detection model\n#   using XGBoost achieving 94.2% precision, preventing\n#   ₹1.2Cr in monthly fraud losses (40% reduction)\n#\n# - Reduced model inference latency from 450ms to 28ms\n#   by implementing ONNX Runtime optimization and Redis\n#   prediction caching, enabling real-time serving at 10K RPS\n#\n# - Built an automated MLOps pipeline using Airflow + MLflow\n#   that reduced model retraining cycle from 2 weeks to 6 hours\n#   for a team of 8 data scientists',
      ),
      ConceptLesson(
        title: 'Technical Skills Section: What to Include and How',
        definition:
            'The Technical Skills section should list specific, verifiable technologies categorized logically — not vague claims. Include only skills you can defend in a technical interview. Arrange by relevance to AI engineering roles.',
        analogy:
            'Your Technical Skills section is like a restaurant menu — it sets expectations for what you can deliver. If the menu says you serve filet mignon and a customer orders it, you must actually be able to cook it. List only skills you can confidently discuss and demonstrate in an interview.',
        example:
            'Effective AI Engineer skills section:\nML Frameworks: PyTorch, TensorFlow, Keras, scikit-learn, XGBoost, LightGBM\nNLP/LLM: Hugging Face Transformers, LangChain, OpenAI API, BERT, GPT-4\nMLOps: MLflow, DVC, Apache Airflow, Docker, Kubernetes, GitHub Actions\nCloud: AWS (SageMaker, EC2, S3, Lambda), GCP (Vertex AI, BigQuery)\nLanguages: Python (Expert), SQL (Advanced), Bash, R (Basic)\nData: Pandas, NumPy, Spark, Kafka, PostgreSQL, Redis',
        keyTakeaway:
            'Never list "Machine Learning" as a skill — it is a field, not a skill. Never list "AI" as a skill. List specific frameworks, tools, and platforms. Do not include skills you learned for a single weekend project five years ago. If you list TensorFlow, you should be able to discuss learning rate schedules, custom training loops, and debugging NaN losses in an interview.',
      ),
      ConceptLesson(
        title: 'ATS Keyword Optimization',
        definition:
            'ATS systems match your resume against job description keywords using exact string matching and semantic analysis. To pass ATS, mirror the exact terminology from the job description while keeping context natural — not keyword stuffing.',
        analogy:
            'ATS keyword optimization is like search engine optimization for your resume. The job description is the search query. Your resume is the webpage being indexed. If the job says "Large Language Model fine-tuning" and your resume only says "LLM training," the ATS may score it lower — even though they mean the same thing.',
        example:
            'Job description says: "Experience with fine-tuning Large Language Models using PEFT/LoRA methods, RAG pipeline development, and LangChain."\nYour current resume says: "Worked on model customization for chatbot applications."\nOptimized version: "Fine-tuned Mistral-7B using LoRA (PEFT) achieving 87% task accuracy, and built a RAG pipeline with LangChain and FAISS that reduced hallucination rate from 23% to 4%."\nSame experience — radically different ATS match score.',
        keyTakeaway:
            'Before submitting any application: copy the job description into a word cloud tool (or simply read it carefully), identify the top 15 technical keywords, and ensure they appear naturally in your resume. Each keyword should appear at least once, ideally in context with a metric or outcome.',
      ),
      ConceptLesson(
        title: 'Resume Projects Section for AI Engineers',
        definition:
            'For AI engineers with under 5 years of experience, the Projects section is often more important than Work Experience — it demonstrates applied skills, initiative, and the ability to build complete systems rather than just contribute to existing ones.',
        analogy:
            'Your projects section is your show-don\'t-tell evidence. It is one thing to claim you know deep learning — it is another to show a GitHub repository with a deployed computer vision model that has 250 GitHub stars. Project evidence is concrete and verifiable in a way that job descriptions are not.',
        example:
            'Strong AI project entry:\n"AI Document Q&A System — Production RAG Pipeline\nBuilt a production-grade RAG system using LangChain, FAISS, and GPT-4 that answers questions from enterprise PDF documents. Deployed as a FastAPI service on AWS ECS with Docker, handling 500 daily queries. Achieved 91% answer accuracy on RAGAS evaluation. Stack: Python, LangChain, OpenAI, FAISS, FastAPI, Docker, AWS. GitHub: 310 stars. Live demo: [URL]"',
        keyTakeaway:
            'Every project entry needs: what you built (one sentence), the key technologies used, a quantified result (accuracy, users, requests/day, GitHub stars), and a link to the live demo or GitHub repository. A project with no link and no metrics is unverifiable — it may as well not be on your resume.',
      ),
      ConceptLesson(
        title: 'Resume for Different AI Engineer Career Stages',
        definition:
            'Fresher (0-2 years), mid-level (2-5 years), and senior (5+ years) AI engineer resumes emphasize different signals. Freshers lead with projects and education; mid-level engineers lead with measurable work impact; senior engineers lead with system scope and team influence.',
        analogy:
            'A fresher resume is like a student\'s portfolio piece — projects and academic achievements are the primary evidence of capability. A mid-level engineer resume is like a professional\'s project reference list — work outcomes and measurable contributions are the evidence. A senior engineer resume is like a track record — scale of systems built, teams led, and organizational impact are the evidence.',
        example:
            'Fresher priority order: 1) Technical Skills 2) Projects (3-4 strong projects with GitHub links) 3) Education (with GPA if ≥3.5/9.0) 4) Internships or Part-time Work 5) Certifications.\nMid-level priority order: 1) Summary (3 lines, strong) 2) Work Experience 3) Key Projects 4) Technical Skills 5) Education.\nSenior priority order: 1) Summary (scope and impact) 2) Work Experience (systems designed, teams led) 3) Technical Skills 4) Education (degrees only).',
        keyTakeaway:
            'A fresher who tries to hide their inexperience with elaborate formatting and vague language fares worse than a fresher who clearly showcases strong, specific projects with GitHub links. Clarity about your current level, combined with clear evidence of your capabilities, is always the winning strategy.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'A job description lists "experience with MLflow and Kubeflow" but your resume says "proficient in ML experiment tracking and pipeline orchestration tools." How will most ATS systems score your application?',
        options: [
          'High score — the concepts are equivalent',
          'Low score — ATS performs exact keyword matching or close variants, not conceptual matching. "MLflow" and "Kubeflow" in the JD must appear in your resume as those exact terms',
          'Medium score — ATS will infer the connection',
          'The score depends entirely on the recruiter, not ATS'
        ],
        correctIndex: 1,
        explanation:
            'Most ATS systems score resumes by keyword frequency and exact term matching, not semantic equivalence. If the job requires "MLflow" and your resume says "ML experiment tracking tools," the ATS gives you zero credit for that keyword — even though you mean the same thing.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which resume bullet point best demonstrates AI engineering competence to a hiring manager?',
        options: [
          '"Responsible for working on machine learning models with the data science team"',
          '"Developed and deployed a customer churn prediction model using XGBoost achieving 89% AUC, reducing monthly churn by 18% and saving ₹28L/year in customer acquisition costs"',
          '"Experienced in machine learning, deep learning, and artificial intelligence"',
          '"Passionate about using AI to solve real-world business problems"'
        ],
        correctIndex: 1,
        explanation:
            'The second option follows the XYZ formula — it states the specific action (developed and deployed), the technology (XGBoost), a technical metric (89% AUC), and a business outcome with quantified impact (18% churn reduction, ₹28L saved). Hiring managers can immediately assess technical depth and business value.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'For a fresher AI engineer with no work experience, what should be the most prominent section after contact information?',
        options: [
          'Education (GPA and degree)',
          'Technical Skills followed by Projects — demonstrating applied skills through built systems is more compelling evidence of capability than academic credentials alone',
          'A lengthy objective statement explaining career goals',
          'Certifications and online courses completed'
        ],
        correctIndex: 1,
        explanation:
            'Freshers differentiate themselves through demonstrated projects, not credentials. Any serious AI engineering applicant has a degree and certifications — what sets freshers apart is concrete evidence of building real systems. Projects with GitHub links and metrics are far more compelling to technical hiring managers.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You have this bullet on your resume: "Worked with the team to improve model performance on classification tasks." Which rewrite best applies the XYZ formula for an AI Engineer resume?',
        options: [
          '"Assisted senior data scientists in improving various machine learning models"',
          '"Optimized a multi-class text classification model by implementing focal loss and data augmentation, improving F1 score from 0.71 to 0.88 on a 50K sample dataset, reducing misclassification cost by ₹12L/quarter"',
          '"Collaborated effectively with cross-functional teams to enhance AI model metrics"',
          '"Worked hard to improve the team\'s ML models for better business outcomes"'
        ],
        correctIndex: 1,
        explanation:
            'The second option contains: specific action (implemented focal loss and data augmentation), specific metric improvement (F1 0.71 → 0.88), data scale (50K samples), and quantified business impact (₹12L/quarter). Every word contributes evidence — nothing is filler.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You are applying for a Senior ML Engineer role at a product company. The job description mentions: "PyTorch, distributed training, model optimization, ONNX, TensorRT." Your resume currently lists "experienced in deep learning frameworks and model optimization." What is the correct fix?',
        options: [
          'Your resume is fine — hiring managers understand general terms',
          'Replace the vague phrase with exact terms from the JD: "PyTorch (distributed training with DDP), model optimization (ONNX export, TensorRT quantization)" if you genuinely have this experience — making each ATS keyword visible while remaining truthful',
          'Add a separate keywords section at the bottom listing all job description terms',
          'The fix is formatting, not content — use a different resume template'
        ],
        correctIndex: 1,
        explanation:
            'Mirror the exact terminology from the job description when it accurately represents your experience. This passes ATS keyword matching while remaining honest. A separate keywords section is considered keyword stuffing and is penalized by modern ATS systems.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Professional AI Engineer Resume',
      goal:
          'Create a complete, ATS-optimized, one-page professional resume for an AI Engineer role at a target company.',
      steps: [
        'Choose one target role: Junior AI Engineer (fresher), ML Engineer (2-4 years), or Senior AI Engineer (5+ years). Find a real job posting for this role at a company you admire.',
        'Write a 3-line Professional Summary using: [Role title] with [X years / strong project background] in [top 3 relevant skills], specialized in [specific domain]. Proven track record of [1 key achievement].',
        'Build the Technical Skills section with at least 6 categories, listing only tools you can defend in a technical interview. Mirror terminology from your target job posting.',
        'Write 3-5 Work Experience bullet points using the XYZ formula for each role. Every bullet must contain a specific technology, a measurable metric, and a business outcome. Remove all soft skill language.',
        'Add 2-3 project entries with: project name, 1-sentence description, key technologies, quantified result, and GitHub/demo link.',
        'Run your resume through a free ATS checker (Jobscan or Resume Worded) against the target job posting and achieve a match score above 75%.',
      ],
      expectedOutput:
          'Complete 1-page AI Engineer resume with: Professional Summary, Technical Skills (6+ categories), Experience (3+ XYZ-formula bullets per role), Projects (2-3 with metrics and links). ATS match score ≥75% against target job posting. Zero soft skill filler words.',
      xpReward: 70,
    ),
  ),
  TopicCourse(
    id: 'github_portfolio_branding_l10',
    topicTitle: 'GitHub Portfolio & Personal Branding',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Expert',
    estimatedMinutes: 30,
    totalXp: 165,
    emoji: '💻',
    intro:
        'Your GitHub profile is your living portfolio — the most powerful signal of technical competence an AI engineer can send. At companies like Google, Meta, and Anthropic, technical recruiters routinely look at GitHub profiles before phone screens. This lesson teaches you to build a GitHub presence that gets you noticed, respected, and hired.',
    concepts: [
      ConceptLesson(
        title: 'Why GitHub is Your Most Powerful Career Asset',
        definition:
            'GitHub is the industry-standard platform where AI engineers demonstrate skills through code rather than claims. A strong GitHub profile with quality repositories shows initiative, coding ability, system thinking, and documentation skills — evidence that resumes and certifications cannot replicate.',
        analogy:
            'Your GitHub is like a professional chef\'s kitchen portfolio — not a list of recipes they claim to know, but actual dishes they have cooked, plated, and documented. Technical hiring managers who look at your GitHub see exactly how you think, code, document, and collaborate — far more revealing than any resume bullet point.',
        example:
            'A Google ML Engineer recruiter reported: "When a candidate has a strong GitHub — well-documented repos, consistent commit history, meaningful projects with READMEs — we often fast-track them to technical interviews. It preemptively answers \'can this person actually build things?\' and lets us focus the interview on depth rather than basics."',
        keyTakeaway:
            'Quality beats quantity on GitHub. Three production-quality repositories with comprehensive READMEs, clean code, and working demos are worth more than 50 repositories of messy tutorial copies. A recruiter who sees one impressive project is more compelled than one who sees twenty half-finished ones.',
      ),
      ConceptLesson(
        title: 'Crafting a Professional GitHub Profile',
        definition:
            'Your GitHub profile page has four key elements: a professional profile picture, a compelling bio (60 words describing your specialization), a pinned repository section (your 6 best projects), and a README profile (a markdown file that introduces you and showcases your best work).',
        analogy:
            'Your GitHub profile page is like the reception area of your professional office — it sets the first impression before any visitor opens a single door (repository). A professional photo, clear description of who you are and what you build, and your best work prominently displayed signals seriousness and attention to craft.',
        example:
            'Effective GitHub bio: "AI Engineer specializing in NLP and LLM systems. Building production RAG pipelines and fine-tuning LLMs for enterprise. Open to collaboration on impactful AI projects. Currently working at [Company]. Writing about ML engineering at [blog link]."\nProfile README: includes technology badges, featured projects with links, current focus, and contact. Pinned repos: 3 ML projects, 1 NLP project, 1 MLOps project, 1 contribution to a major library.',
        keyTakeaway:
            'Create a profile README.md file in a repository named exactly as your GitHub username. This file displays on your profile page. Include a brief introduction, your tech stack shown as badges, your pinned projects with one-line descriptions, and links to your LinkedIn and portfolio. Many AI engineers overlook this — it is a significant differentiator.',
        codeSnippet:
            '# GitHub Profile README template (README.md)\n# File location: github.com/yourusername/yourusername/README.md\n\n## Hi, I am [Your Name] 👋\nAI Engineer specializing in Large Language Models and production ML systems.\nCurrently building [current project/role]. Open to collaboration and interesting problems.\n\n## 🔧 Tech Stack\n![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)\n![PyTorch](https://img.shields.io/badge/PyTorch-EE4C2C?style=flat&logo=pytorch&logoColor=white)\n![TensorFlow](https://img.shields.io/badge/TensorFlow-FF6F00?style=flat&logo=tensorflow&logoColor=white)\n![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)\n\n## 🚀 Featured Projects\n| Project | Description | Stars |\n|---------|-------------|-------|\n| [RAG Enterprise](link) | Production Q&A system for documents | ⭐ 312 |\n| [LLM Fine-Tuner](link) | QLoRA fine-tuning toolkit | ⭐ 187 |\n| [ML Pipeline](link) | End-to-end MLOps with Prefect + MLflow | ⭐ 94 |\n\n## 📊 GitHub Stats\n![GitHub Stats](https://github-readme-stats.vercel.app/api?username=yourusername)',
      ),
      ConceptLesson(
        title: 'What Makes a Repository Portfolio-Worthy',
        definition:
            'A portfolio-worthy repository has: a comprehensive README (problem statement, demo GIF/screenshot, architecture diagram, installation instructions, usage examples, results/metrics, and license), clean modular code, requirements.txt or pyproject.toml, and a working demo or deployed endpoint.',
        analogy:
            'A portfolio-worthy GitHub repository is like a well-published research paper: it has a clear abstract (README summary), methodology explained clearly (code structure), reproducible results (installation and usage instructions), and peer-review quality (clean code, meaningful commit messages). Anyone should be able to clone, run, and understand your project in under 10 minutes.',
        example:
            'README structure for an AI project:\n1. Project title and one-line description\n2. Demo GIF or screenshot (most viewed element)\n3. Key features and what problem it solves\n4. Architecture diagram (system design visual)\n5. Installation: git clone, pip install -r requirements.txt, example commands\n6. Usage examples with actual code snippets\n7. Model performance metrics (accuracy table, latency benchmarks)\n8. Project structure (file tree with descriptions)\n9. Contributing guidelines\n10. License',
        keyTakeaway:
            'The README is the most important file in any repository. A technically brilliant project with a poor README gets zero attention. A moderately good project with an excellent README (especially with a compelling demo GIF) gets stars, forks, and employer attention. Invest 20% of your project time in the README.',
        codeSnippet:
            '# Strong README structure (template)\n# Copy-paste and fill in for each portfolio project\n\n# 🤖 Project Name\n> One-sentence description of what this does and why it matters\n\n![Demo GIF](demo/demo.gif)  <!-- Most important visual element -->\n\n## ✨ Features\n- Feature 1 (with metric: "Reduces latency by 60%")\n- Feature 2\n- Feature 3\n\n## 🏗️ Architecture\n![Architecture Diagram](docs/architecture.png)\n\n## 🚀 Quick Start\n```bash\ngit clone https://github.com/yourusername/project-name\ncd project-name\npip install -r requirements.txt\npython main.py --config config/default.yaml\n```\n\n## 📊 Performance\n| Metric | Value |\n|--------|-------|\n| Accuracy | 91.4% |\n| Inference Latency (P99) | 28ms |\n| Throughput | 3,500 req/s |\n\n## 🔧 Tech Stack\nPython • PyTorch • FastAPI • Docker • Redis • MLflow',
      ),
      ConceptLesson(
        title: 'Commit History and Activity: Signaling Consistency',
        definition:
            'A consistent green activity graph on GitHub signals ongoing learning and building to recruiters. Active repositories with meaningful, well-described commits (not "fix stuff" or "update") demonstrate professional coding habits.',
        analogy:
            'Your GitHub commit history is like a fitness tracker for your coding discipline. A recruiter glancing at a profile with a consistent, active green graph (like a gym member who shows up 4-5 days per week) forms a very different impression than one with months of inactivity followed by a burst of commits the week before applying.',
        example:
            'Good commit message practice:\nBad: "fix bug", "update file", "changes"\nGood: "feat: add streaming response support to RAG API endpoint"\n"fix: resolve memory leak in FAISS index updates during concurrent requests"\n"refactor: extract feature engineering into reusable pipeline class"\n"docs: add architecture diagram and API usage examples to README"\nEach commit message tells a reader exactly what changed and why.',
        keyTakeaway:
            'Commit daily or near-daily — even small improvements (fix a typo in README, add a test, improve a docstring) count. Use conventional commit prefixes: feat:, fix:, docs:, refactor:, test:. This creates a professional commit history that any engineering team would be proud to inherit.',
      ),
      ConceptLesson(
        title: 'Personal Branding: Blog, Newsletter, and Social Presence',
        definition:
            'Personal branding as an AI engineer means consistently sharing useful technical insights through writing (blog posts, LinkedIn articles, Twitter/X threads) and speaking (conference talks, meetup presentations) — building a reputation that attracts opportunities.',
        analogy:
            'Personal branding for an AI engineer is like compounding interest for your career: each article, thread, or talk you publish slightly increases your visibility and credibility. Over 2-3 years of consistent output, the compound effect produces opportunities that would otherwise require years of networking and luck to find.',
        example:
            'Effective AI engineer content to create: 1) "I built an X, here is what I learned" project retrospectives. 2) "How I solved Y problem" technical tutorials with working code. 3) "Paper explained simply" breakdowns of recent ML research. 4) "Week in AI engineering" newsletters. None of these require you to be a world expert — sharing your genuine learning process is genuinely valuable to others at earlier stages.',
        keyTakeaway:
            'You do not need to be famous or an expert to build a valuable personal brand. Sharing honest technical learning in public — including mistakes and what you learned from them — builds authentic credibility faster than polished expert-only content. Start with one post per week on one platform and be consistent for 6 months.',
      ),
      ConceptLesson(
        title: 'Portfolio Website: Your Unified Professional Hub',
        definition:
            'A personal portfolio website serves as the central hub linking your resume, GitHub projects, blog, LinkedIn, and contact information — providing a curated, narrative presentation of your work that no single platform can offer alone.',
        analogy:
            'Your portfolio website is like your professional studio space — GitHub is your workshop (where the work is done), LinkedIn is your business card, your blog is your writing desk, but the portfolio website is the curated gallery where you invite people to see your best work in the most favorable light you have designed.',
        example:
            'Effective AI engineer portfolio structure: Home (strong 2-sentence introduction, key skills, call to action). About (story of your journey, current focus). Projects (3-6 featured projects with demo GIFs, architecture, metrics). Blog/Writing (latest 3-5 posts). Contact (LinkedIn, GitHub, Email, Twitter). Deploy free on Vercel, Netlify, or GitHub Pages using a simple HTML/CSS template or Next.js.',
        keyTakeaway:
            'Build your portfolio website in one weekend using a template (not from scratch — that delay is not worth the learning trade-off). Focus on content quality, not web development perfectionism. A simple, fast-loading site with excellent content beats a beautiful site with thin content every time.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'A technical recruiter at a top AI company takes 45 seconds to view a GitHub profile. What is the MOST important element that determines whether they click into a repository?',
        options: [
          'The total number of repositories',
          'The pinned repository list — which project names, one-line descriptions, and star counts appear without clicking anything, determining whether the recruiter invests more time',
          'The programming language statistics chart',
          'The follower count'
        ],
        correctIndex: 1,
        explanation:
            'Pinned repositories are the first visible project content on any GitHub profile. The project name, description, and star count are all visible without any clicks. These 6 pinned repos are your shopfront window — they must immediately communicate the type, quality, and scale of your work.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the most important element of any portfolio GitHub repository README?',
        options: [
          'A comprehensive list of every library version used',
          'A demo GIF or screenshot showing the project working — it is the most viewed element, communicates the project\'s value faster than any text, and determines whether most visitors continue reading',
          'A detailed explanation of every function in the codebase',
          'A list of known bugs and limitations'
        ],
        correctIndex: 1,
        explanation:
            'Human brains process visual information 60,000x faster than text. A 5-second GIF showing your AI model performing inference on real data communicates more than 500 words of description. Many developers skip reading READMEs but always view the demo visual.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why does consistent personal branding (writing, tutorials, threads) benefit an AI engineer\'s career even if they never become "famous"?',
        options: [
          'It is purely ego-driven with no practical career benefit',
          'It compounds visibility over time, demonstrates communication skills (critical for senior roles), creates an SEO-discoverable track record, and attracts inbound opportunities from people who found your content useful',
          'Only engineers at top companies benefit from personal branding',
          'Personal branding takes too long to show ROI to be worthwhile'
        ],
        correctIndex: 1,
        explanation:
            'Even modest, consistent technical writing compounds over 1-2 years into a searchable body of work that demonstrates expertise, communication ability, and initiative. Recruiters who find your work through search are already pre-sold before they contact you — the opposite of cold applying.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You have a working ML project but your current README is: "# My ML Project. This is my machine learning project. Run python main.py to use it." How should you prioritize improving it?',
        options: [
          'Rewrite all the code to make it cleaner first before improving the README',
          'Add in this order: 1) a demo GIF or screenshot (highest impact), 2) a one-paragraph problem statement and solution summary, 3) quick start installation commands, 4) a performance metrics table — making it repo-worthy in under 2 hours',
          'Add more inline code comments throughout the source files',
          'Submit it to GitHub Trending without changes'
        ],
        correctIndex: 1,
        explanation:
            'The demo GIF alone can transform a repository from "ignored" to "starred." The problem statement explains why someone should care. Installation instructions let others use it. Metrics prove it works. These four additions have the highest impact-to-effort ratio for a portfolio repository.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your GitHub shows no commits for the past 3 months because you were studying but not building. An interview is in 2 weeks. What is the BEST use of those 2 weeks?',
        options: [
          'Backdate commits to fill the gap',
          'Build one small but complete, well-documented AI project (even a simple RAG chatbot or fine-tuning demo), commit it with meaningful messages daily, and pin it — demonstrating active learning rather than trying to hide the gap',
          'Focus entirely on interview prep and ignore GitHub',
          'Star 200 repositories to appear active'
        ],
        correctIndex: 1,
        explanation:
            'One well-built, well-documented project built in 2 weeks demonstrates more than nothing. Backdating commits is dishonest and detectable. Focusing only on interview prep misses the opportunity. A simple but complete new project with daily commits in a focused burst is the honest, highest-ROI choice.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Production GitHub Portfolio',
      goal:
          'Build a professional GitHub portfolio that demonstrates AI engineering capability to any technical recruiter in under 60 seconds.',
      steps: [
        'Create or update your GitHub profile README.md with: professional introduction, tech stack badges, featured projects table, current focus, and links to LinkedIn and portfolio.',
        'Audit your repositories: pin exactly 6 — your 3 strongest ML/AI projects, 1 MLOps/deployment project, 1 NLP/LLM project, 1 data pipeline or analysis project. Unpin anything unfinished.',
        'For your top 2 pinned repositories: add a demo GIF or screenshot, rewrite the README following the 10-section template, add a project architecture diagram, and ensure installation works from a fresh clone.',
        'Ensure consistent commit history: make at least 5 meaningful commits across your repositories this week with professional commit messages using feat:/fix:/docs: prefixes.',
        'Create your portfolio website using a free template (GitHub Pages, Vercel, or Netlify). Include: About section, 3 featured project cards with screenshots and links, and a contact section.',
        'Share the portfolio URL in your resume, LinkedIn, and email signature. Send to one peer for honest feedback and implement their top 3 suggestions.',
      ],
      expectedOutput:
          'Professional GitHub profile with complete README. 6 pinned repositories. Top 2 repos with demo GIFs, comprehensive READMEs, and working installation. Portfolio website live and linked. GitHub activity shows recent consistent commits. Peer review completed.',
      xpReward: 65,
    ),
  ),
  TopicCourse(
    id: 'linkedin_optimization_l10',
    topicTitle: 'LinkedIn Optimization for AI Engineers',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Expert',
    estimatedMinutes: 25,
    totalXp: 150,
    emoji: '🔗',
    intro:
        'LinkedIn is where 90% of professional AI engineering recruitment happens. Recruiters from Google, Microsoft, Meta, and top AI startups use LinkedIn Recruiter to find candidates daily. This lesson teaches you to optimize every element of your LinkedIn profile to appear in recruiter searches and convert profile views into interview invitations.',
    concepts: [
      ConceptLesson(
        title: 'How LinkedIn Recruiter Search Works',
        definition:
            'LinkedIn Recruiter uses an algorithm that ranks profiles based on keyword relevance, connection proximity, profile completeness, and recent activity. Understanding how recruiters search helps you optimize your profile to appear in the right searches.',
        analogy:
            'LinkedIn Recruiter search is like Google Search for human talent. Recruiters type queries like "ML Engineer LangChain RAG Python Bangalore" and LinkedIn ranks profiles by how well they match — keyword frequency in your headline and about section, relevant skills endorsed by others, and profile completeness all affect your ranking.',
        example:
            'A recruiter searching "NLP Engineer BERT PyTorch remote" will see profiles ranked by: keyword presence (BERT, PyTorch, NLP in headline, about, and experience), connection proximity (2nd-degree connections ranked higher), profile activity (recently active profiles ranked higher), and profile completeness (all-star profiles ranked higher).',
        keyTakeaway:
            'The LinkedIn headline is the highest-weighted field in recruiter search — optimize it for your target job title and top 2-3 skills. "AI Engineer | NLP & LLM Systems | PyTorch | Open to Opportunities" outperforms "Software Engineer at Company X" by appearing in hundreds more recruiter searches per month.',
      ),
      ConceptLesson(
        title: 'LinkedIn Headline and About Section Optimization',
        definition:
            'Your LinkedIn headline (220 characters) and About section (2,600 characters) are the two most critical profile elements — they appear in search results, determine recruiter interest, and must contain your target keywords while conveying your professional identity.',
        analogy:
            'Your LinkedIn headline is like a newspaper headline — it must communicate the most important information in the fewest words and make the reader want to know more. Your About section is like the first paragraph of your story — it must hook the reader, establish your credibility, and give them a reason to contact you.',
        example:
            'Optimized AI Engineer headline: "Senior ML Engineer | LLM Fine-Tuning & RAG Systems | Python, PyTorch, AWS | Ex-Amazon | Open to Remote Roles"\nOptimized About structure: 1) Hook sentence (who you are and your specialization). 2) 3-4 bullet points of key achievements with metrics. 3) Current focus and what you are building. 4) What you are looking for and how to contact you.',
        keyTakeaway:
            'Use the About section as a narrative resume — tell your story in first person, include 8-10 of your target role\'s keywords naturally, and end with a call to action ("Email me at..." or "Connect if you are working on problems in X domain"). LinkedIn\'s algorithm indexes the About section heavily for search ranking.',
      ),
      ConceptLesson(
        title: 'Skills, Endorsements and Recommendations',
        definition:
            'LinkedIn allows 50 skills — select 50 that match your target role exactly. Skills endorsed by many connections appear higher in profile rankings. Three written recommendations from colleagues or managers significantly increase recruiter trust and response rate.',
        analogy:
            'Skills and endorsements on LinkedIn are like product ratings on Amazon — they provide social proof that your claimed capabilities are verified by others. A profile with 45 endorsements for "PyTorch" and "Machine Learning" signals to a recruiter that these are genuine, verified skills rather than self-claimed competencies.',
        example:
            'Skill selection strategy: First 10 skills = exact titles of your target role (Machine Learning, Deep Learning, Natural Language Processing, MLOps, Python, PyTorch, TensorFlow). Next 20 skills = specific tools and frameworks (FastAPI, Docker, Kubernetes, MLflow, Airflow, BERT). Remaining 20 skills = adjacent technical and domain skills. Order matters — the top 3 visible skills are chosen by you.',
        keyTakeaway:
            'Ask 3 colleagues to write you LinkedIn recommendations this week — not generic "great teammate" recommendations, but specific ones that mention a project and your measurable contribution. Three specific recommendations increase recruiter response rates by 40% compared to no recommendations.',
      ),
      ConceptLesson(
        title: 'LinkedIn Content Strategy for AI Engineers',
        definition:
            'Posting valuable content on LinkedIn 1-2 times per week builds algorithmic visibility, establishes technical authority, and attracts inbound opportunities from recruiters and collaborators who discover your expertise through the feed.',
        analogy:
            'LinkedIn content for AI engineers is like a weekly radio broadcast — each post reaches people who would never actively search for your profile. Over time, consistent broadcasting builds an audience of listeners (followers) who know your work and naturally think of you when relevant opportunities arise.',
        example:
            'High-performing LinkedIn content formats for AI engineers: 1) "I spent the weekend testing 5 open-source LLMs for [task] — here are my results" (comparison posts get massive engagement). 2) "We reduced model inference latency by 73% using [technique] — here is how" (behind-the-scenes engineering). 3) "I failed to build [project] first time — here is what I learned" (authentic failure posts have the highest emotional resonance).',
        keyTakeaway:
            'LinkedIn posts that include: a specific technical insight with context, a visual (screenshot, chart, diagram), and a question at the end consistently receive 3-5x the engagement of posts without these elements. Post on Tuesday-Thursday mornings for maximum algorithmic reach.',
      ),
      ConceptLesson(
        title: 'Strategic Networking and Outreach',
        definition:
            'Effective LinkedIn networking for AI engineers involves targeted connection requests with personalized notes to hiring managers and peer engineers at target companies, and thoughtful engagement (meaningful comments) on posts by influential people in your target domain.',
        analogy:
            'LinkedIn networking is like planting seeds — each connection request, meaningful comment, or message is a seed. Most seeds do not immediately produce fruit, but a garden built over months eventually yields multiple opportunities simultaneously. The mistake most people make is only planting seeds when they urgently need fruit.',
        example:
            'Effective connection request: "Hi [Name], I saw your post about [specific technical topic] and your experience building [specific system] resonated with my work on [similar project]. I am currently focusing on [relevant domain] and would love to connect with others doing interesting work in this space."\nThis approach — specific, genuine, low-pressure — gets accepted 60% of the time vs 15% for generic requests.',
        keyTakeaway:
            'The worst time to network is when you urgently need a job — desperation is palpable and people are busy. The best networking is consistent, low-pressure relationship building that is not tied to immediate need. Comment meaningfully on 3 posts daily and send 2-3 personalized connection requests weekly — the pipeline builds itself over 6 months.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'A LinkedIn Recruiter searches for "ML Engineer Python PyTorch LLM Bangalore." Your headline says "Software Developer at TechCorp." Why might your profile not appear despite being a perfect match?',
        options: [
          'Your follower count is too low',
          'The search terms "ML Engineer," "Python," "PyTorch," and "LLM" do not appear in your headline — LinkedIn Recruiter search heavily weights the headline field for keyword ranking. Changing your headline to include these terms would dramatically improve search visibility',
          'TechCorp is not a well-known company on LinkedIn',
          'You need Premium membership to appear in recruiter searches'
        ],
        correctIndex: 1,
        explanation:
            'LinkedIn Recruiter ranks profiles by keyword match across all fields, but the headline carries the highest algorithmic weight. A headline optimized with your target role title and top 3-4 skills ensures you appear in the searches most relevant to your target roles.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the most effective LinkedIn content type for AI engineers trying to build visibility and authority?',
        options: [
          'Reposts of news articles without commentary',
          'Posts sharing specific technical insights from your work with results, a visual (chart or screenshot), and an engaging question — these consistently receive 3-5x the reach of generic posts',
          'Job seeking announcements ("I am looking for ML opportunities")',
          'Sharing motivational quotes with AI-themed images'
        ],
        correctIndex: 1,
        explanation:
            'Technical insights from real work demonstrate genuine expertise that no generalist content can replicate. Visuals increase engagement (LinkedIn algorithm rewards posts that keep people on the platform). Questions invite comments which further boost algorithmic reach.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A recruiter from a company you admire views your LinkedIn profile but does not send a message. Your profile headline currently says "Graduate Student | Interested in Machine Learning." What is the most impactful single change?',
        options: [
          'Add more certifications to the Licenses & Certifications section',
          'Rewrite the headline to: "ML Engineer | NLP & LLM Systems | PyTorch, HuggingFace | Actively Building & Open to Opportunities" — signaling your specialization, key skills, and availability in a single line that appears in all search results',
          'Change your profile picture to a more professional photo',
          'Connect with everyone at the company to get referrals'
        ],
        correctIndex: 1,
        explanation:
            'The headline is the first text a recruiter sees below your name — in search results, connection lists, and profile views. A vague or student-identity headline signals ambiguity about your role and skills. A specific, keyword-rich headline signals exactly what you offer and for which roles.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Optimized LinkedIn Profile',
      goal:
          'Fully optimize your LinkedIn profile to appear in AI Engineer recruiter searches and attract inbound opportunities.',
      steps: [
        'Update Headline to include: target job title + top 2 AI skills + key tools + open to opportunities signal (220 chars max).',
        'Rewrite About section: hook sentence, 4 bullet-point achievements with metrics, current focus, and contact call-to-action. Include 8 target role keywords naturally.',
        'Add or update all 50 Skills slots with exact terminology from your target job descriptions. Reorder top 3 visible skills to your strongest.',
        'Request 2-3 specific recommendations from colleagues/professors mentioning a project and your measurable contribution.',
        'Post one piece of technical content: a project summary, a technical lesson learned, or a comparison of tools you have used. Include a visual and end with a question.',
        'Send 5 personalized connection requests to AI engineers or hiring managers at your target companies with specific, genuine messages.',
      ],
      expectedOutput:
          'Optimized headline with target role + top skills. About section with metrics and keywords. 50 skills populated. 2+ recommendations requested. First LinkedIn technical post published. 5 personalized connection requests sent. Profile completeness at "All-Star" level.',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'open_source_research_l10',
    topicTitle: 'Open Source Contribution & Research Reading',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Expert',
    estimatedMinutes: 30,
    totalXp: 160,
    emoji: '🔬',
    intro:
        'The most respected AI engineers in the industry combine two habits: contributing to open-source AI projects and staying current with research papers. Together, these practices signal intellectual curiosity, technical depth, and community engagement — qualities that distinguish senior engineers from those who simply implement what others discover.',
    concepts: [
      ConceptLesson(
        title: 'Why Open Source Contributions Define Senior AI Engineers',
        definition:
            'Open source contributions to major AI libraries (PyTorch, Hugging Face, scikit-learn, LangChain, Ray) are the most credible signal of technical depth available — they are publicly reviewed by world-class engineers and are verified by the very organizations these contributions serve.',
        analogy:
            'An open-source contribution to PyTorch or Hugging Face is like having your architectural design accepted into a prestigious international building competition — it is reviewed, critiqued, and validated by the best practitioners in the field before being accepted. This validation carries far more credibility than any self-reported claim.',
        example:
            'A data scientist who has merged 3 pull requests to Hugging Face Transformers — even if they are minor documentation improvements and bug fixes — signals to a Meta or Google recruiter that this person: reads source code at a professional level, understands the project\'s standards and processes, communicates technical changes clearly, and is recognized by the community.',
        keyTakeaway:
            'Start with small contributions: documentation improvements, bug fixes in the issue tracker labeled "good first issue," or adding missing test cases. Your first merged PR takes the longest; subsequent contributions to the same repository become progressively easier as you understand the codebase and community standards.',
        codeSnippet:
            '# How to find and make your first open source contribution\n\n# Step 1: Find beginner-friendly issues\n# GitHub search: "good first issue" in ML repositories\n# URLs to bookmark:\n# github.com/huggingface/transformers/issues?q=label%3A"Good+First+Issue"\n# github.com/scikit-learn/scikit-learn/issues?q=label%3AEasy\n# github.com/langchain-ai/langchain/issues?q=label%3A"good+first+issue"\n\n# Step 2: Fork, clone, create branch\n# git clone https://github.com/YOUR_USERNAME/transformers\n# git checkout -b fix/issue-12345-add-docstring-to-bert-forward\n\n# Step 3: Make your change, add tests if applicable\n# Follow the project\'s coding style exactly\n\n# Step 4: PR description template\n# Title: "fix: Add missing docstring to BertModel.forward() method (#12345)"\n# Body:\n# - What this PR does (1-2 sentences)\n# - Why it is needed (link to issue)\n# - What was changed (specific files/functions)\n# - How it was tested\n# - Screenshots if applicable',
      ),
      ConceptLesson(
        title: 'Reading Research Papers: A Practical Framework',
        definition:
            'Effective research paper reading uses a three-pass method: first pass (5 minutes — title, abstract, conclusion, skim figures), second pass (30 minutes — read carefully, skip proofs), third pass (3+ hours — full understanding and reproducibility). Most papers only need the first two passes.',
        analogy:
            'Reading ML research papers is like being a journalist covering a complex scientific story: your first pass is scanning the headline and key findings, your second pass is reading the full story to understand the evidence, and your third pass (for papers you actually need to implement) is reviewing every primary source the story cites.',
        example:
            'First pass of the attention paper "Attention Is All You Need": Read abstract (transformer architecture for NLP), scan Figure 1 (encoder-decoder architecture diagram), read conclusion (BLEU score improvements). In 5 minutes you now know: what problem it solves, what the proposed solution is, and what the results are. You can now decide whether to read further.',
        keyTakeaway:
            'You do not need to understand every proof or every ablation study. AI engineers primarily need to understand: what problem the paper solves (abstract), what the key innovation is (introduction and methodology overview), and what the results look like (results section and figures). Implementation details come only when you need to build it.',
        codeSnippet:
            '# Essential AI research reading list for AI engineers\n# 30 min/day of paper reading transforms your understanding in 3 months\n\n# Daily sources:\n# - Papers with Code: paperswithcode.com (papers + implementations)\n# - Hugging Face Daily Papers: huggingface.co/papers\n# - Andrej Karpathy\'s X/Twitter feed\n# - DeepMind / OpenAI / Anthropic blogs\n\n# Must-understand foundational papers for AI engineers:\n# 1. Attention Is All You Need (2017) - Transformer architecture\n# 2. BERT (2018) - Bidirectional encoder pretraining\n# 3. GPT-3 (2020) - Few-shot learning at scale\n# 4. LoRA (2021) - Low-rank adaptation for fine-tuning\n# 5. Chinchilla (2022) - Scaling laws\n# 6. InstructGPT (2022) - RLHF alignment\n# 7. LLaMA (2023) - Open source LLMs\n# 8. Retrieval-Augmented Generation (2020) - RAG\n# 9. FlashAttention (2022) - Efficient attention\n# 10. Mixtral (2024) - Mixture of Experts',
      ),
      ConceptLesson(
        title: 'Staying Current: Building a Research Reading Habit',
        definition:
            'The AI field publishes 100+ relevant papers per week. Staying current requires a curated, systematic reading system rather than trying to read everything — following key researchers, using curation services, and reading deeply on your specialization while staying broadly aware of adjacent fields.',
        analogy:
            'Staying current in AI research is like monitoring a large and fast-moving stock market — you cannot track every stock in detail, but you can identify the sectors most relevant to your portfolio, follow a few key analysts deeply, and maintain broad awareness of market trends through curated summaries.',
        example:
            'Sustainable research reading system: 15 minutes each morning reviewing Hugging Face Daily Papers (top 5 papers) and Twitter ML researcher feeds. Deeper 60-minute weekly session reading one paper fully in your specialization (NLP, computer vision, RL). Monthly: read one survey paper covering a topic adjacent to your core area.',
        keyTakeaway:
            'Consistency beats completeness in research reading. Reading one paper thoroughly per week and being able to explain its key contribution clearly is more valuable for your career than skimming 20 papers per week and understanding none deeply. Your specialization depth matters more than breadth at this stage.',
      ),
      ConceptLesson(
        title: 'Implementing Papers: The Deepest Form of Understanding',
        definition:
            'Implementing a research paper from scratch in PyTorch or TensorFlow — without relying on existing implementations — is the most demanding and most rewarding form of technical learning for AI engineers, and creates compelling portfolio content.',
        analogy:
            'Implementing a research paper is like cooking a complex dish from the original recipe without any ready-made sauces or pre-cut ingredients — you develop a far deeper understanding of every component, every technique, and every potential failure mode than you could ever gain from watching someone else cook it.',
        example:
            'Valuable papers to implement for portfolio: Transformer architecture from "Attention Is All You Need" (builds deep understanding of attention). LoRA from "Low-Rank Adaptation of Large Language Models" (directly applicable to fine-tuning workflows). A diffusion model simplified (demonstrates mathematical intuition and PyTorch expertise). Upload each implementation to GitHub with a detailed README explaining every design decision.',
        keyTakeaway:
            'Even a partial implementation — just the core architectural innovation of a paper — is valuable portfolio content. Frame your implementation repository as "my understanding of [Paper Title] implemented from scratch" — this accurately sets expectations and demonstrates intellectual engagement with the research community.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the most effective strategy for finding your first open-source AI contribution opportunity?',
        options: [
          'Propose an entirely new feature to a major library like PyTorch',
          'Search GitHub for issues labeled "good first issue" or "beginner" in repositories you already use (Hugging Face, scikit-learn, LangChain) — these are specifically set aside for new contributors and are reviewed with additional patience',
          'Fork a repository and make changes without opening an issue first',
          'Start your own open-source project and announce it on social media'
        ],
        correctIndex: 1,
        explanation:
            '"Good first issue" labels are explicitly maintained to help new contributors get started. These issues are scoped to be approachable, well-defined, and reviewed constructively by maintainers who understand the contributor is new. They are the lowest-friction path to a first merged PR.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Using the three-pass reading method, what should you do in the FIRST pass of reading a research paper?',
        options: [
          'Read every section carefully including all mathematical proofs',
          'Read only the title, abstract, conclusion, and skim all figures and headings in 5 minutes — this gives you enough context to decide whether to invest in a full read',
          'Implement the paper\'s core algorithm immediately',
          'Read only the introduction and skip everything else'
        ],
        correctIndex: 1,
        explanation:
            'The first pass is a 5-minute survey to understand the paper\'s contribution and decide whether it warrants deeper reading. Title, abstract, conclusion, and figures contain the essential information. Deep reading of mathematical proofs and experimental details comes only in the third pass when you need to implement the work.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You want to contribute to Hugging Face Transformers but feel intimidated because the codebase has millions of lines. What is the correct first step?',
        options: [
          'Study the entire codebase for 3 months before making any contribution',
          'Search for issues labeled "good first issue," read the contributing guidelines, pick the smallest, clearest issue, clone the repo, make that specific minimal change, and open a PR — the maintainers will guide you on improvements through the review process',
          'Directly email a Hugging Face engineer to ask what to contribute',
          'Create a competing library that is simpler and better organized'
        ],
        correctIndex: 1,
        explanation:
            'Every expert contributor started with a small, specific change. The PR review process itself is educational — maintainers will suggest improvements that teach you the codebase standards far faster than studying it independently. Taking the first small action is the entire barrier to entry.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Open Source Contribution & Research Paper Implementation',
      goal:
          'Complete one verified open-source AI contribution and implement one research paper concept.',
      steps: [
        'Identify 3 "good first issue" candidates in AI libraries you use. Choose the one most clearly defined and within your current skill level. Solve it, open a PR, and document the contribution process.',
        'Select one foundational research paper in your specialization. Read it using the three-pass method. Write a 500-word explanation of the paper\'s key contribution, suitable for a LinkedIn post or blog.',
        'Implement the core innovation of the chosen paper from scratch in PyTorch or TensorFlow — even a simplified version. Create a GitHub repository with a comprehensive README explaining every implementation decision.',
        'Share both the contribution and the paper explanation: post the PR link and paper explanation on LinkedIn, noting what you learned from each.',
      ],
      expectedOutput:
          'One open-source PR opened (ideally merged or with substantive maintainer feedback). 500-word paper explanation written. Paper implementation on GitHub with comprehensive README. Both shared publicly on LinkedIn with engagement.',
      xpReward: 65,
    ),
  ),
  TopicCourse(
    id: 'ai_system_design_interview_l10',
    topicTitle: 'AI System Design Interview Preparation',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Expert',
    estimatedMinutes: 40,
    totalXp: 200,
    emoji: '🏗️',
    intro:
        'The AI System Design interview is the most differentiating interview round for senior AI engineering roles. It is a 45-60 minute open-ended exercise where you design a production ML system from scratch. This lesson gives you a proven framework that demonstrates end-to-end thinking to any interviewer at any top company.',
    concepts: [
      ConceptLesson(
        title: 'The AI System Design Interview Framework',
        definition:
            'Every AI system design interview should follow a structured 6-step framework: Clarify Requirements → Estimate Scale → Define ML Problem → Design Data Pipeline → Design Training System → Design Serving System → Address Monitoring and Maintenance.',
        analogy:
            'The AI system design framework is like an architect\'s blueprint process: you first understand what the building is for and who will use it (requirements), estimate scale and materials needed, choose the structural approach, design the foundation (data), the building itself (training), the facade and interior (serving), and the maintenance plan (monitoring).',
        example:
            '"Design YouTube\'s recommendation system." Framework applied: 1) Clarify: 2 billion users, 500 hours of video uploaded per minute, goal is to maximize watch time. 2) Scale: 1 million predictions per second, 15 billion training examples. 3) ML Problem: predict P(user watches video > 30 seconds). 4) Data: user watch history, video features, engagement signals. 5) Training: two-tower neural network, updated every 24 hours. 6) Serving: ANN retrieval + ranking model + business rules. 7) Monitoring: engagement metrics, diversity tracking, A/B framework.',
        keyTakeaway:
            'Interviewers are not looking for the single "correct" answer — no such thing exists. They are evaluating your thinking process: do you clarify before designing? Do you make explicit trade-offs? Do you consider monitoring and failure modes? Do you adjust your design when given new constraints? Framework adherence demonstrates professional engineering discipline.',
      ),
      ConceptLesson(
        title: 'Clarifying Requirements: The Questions Interviewers Expect',
        definition:
            'The first 5 minutes of an AI system design interview should be dedicated to clarifying requirements through targeted questions — before drawing any architecture. Failing to clarify is the most common and most costly interview mistake.',
        analogy:
            'Designing an ML system without clarifying requirements is like a doctor prescribing treatment without asking about symptoms. The prescription might accidentally be correct, but the process reveals dangerously poor judgment regardless of the outcome.',
        example:
            'Questions to ask for any ML system design problem: 1) What is the business objective and how is success measured? 2) How many users and what is the expected request volume? 3) What is the latency requirement (real-time vs batch)? 4) What training data is available and how fresh must it be? 5) Are there fairness, explainability, or regulatory requirements? 6) What is the infrastructure budget constraint? 7) Is this replacing an existing system (needs migration plan) or greenfield?',
        keyTakeaway:
            'Spend 5 full minutes asking clarifying questions before touching the whiteboard. Interviewers at Google and Meta have reported that candidates who ask no clarifying questions almost never receive offers for senior roles — it demonstrates absence of the real-world engineering discipline of understanding the problem before solving it.',
      ),
      ConceptLesson(
        title: 'Scale Estimation for ML Systems',
        definition:
            'Back-of-envelope scale estimation demonstrates that you can make quantitative judgments about system requirements — a critical skill for engineering decisions. For ML systems, estimate: daily active users, events per user per day, training data volume, prediction request volume, model size, and storage requirements.',
        analogy:
            'Scale estimation in AI system design is like a contractor estimating materials before starting construction. Without rough estimates, you cannot decide whether you need PVC or industrial steel pipes (Redis vs Cassandra), a single-room structure or a multi-floor building (single server vs distributed system), or simple plumbing or an entire sewage treatment plant (batch vs real-time processing).',
        example:
            'Estimation for "Design Netflix\'s content recommendation system": 230M subscribers × 2 sessions/day = 460M sessions/day. Each session triggers 10 recommendation calls = 4.6B calls/day = ~53,000 calls/second at peak. Training data: 460M sessions × 20 events/session = 9.2B daily training events. Model serving: 53K RPS requires ~100 serving pods at 500 QPS/pod. Storage: 500K videos × 512-dim embeddings × 4 bytes = ~1GB for video embeddings.',
        keyTakeaway:
            'You do not need to be exact — you need to be in the right order of magnitude. Show your arithmetic explicitly ("53K RPS means we need approximately X serving pods if each handles Y QPS") — interviewers want to see your estimation reasoning, not just the answer.',
      ),
      ConceptLesson(
        title: 'Common AI System Design Interview Questions',
        definition:
            'The most frequently asked AI system design questions at top companies fall into 6 categories: recommendation systems, search ranking, NLP classification systems, fraud/anomaly detection, large-scale ML training infrastructure, and LLM-powered applications.',
        analogy:
            'Common AI system design questions are like standard engineering case studies — while every problem has unique nuances, the core architectural patterns repeat. Mastering the framework and 6-8 representative problems prepares you for 90% of what you will encounter, with the remaining 10% covered by the framework itself.',
        example:
            'Top 8 AI system design questions to prepare for any top company interview:\n1. Design YouTube/Netflix recommendation system\n2. Design Google Search ranking\n3. Design Twitter/LinkedIn feed ranking\n4. Design a fraud detection system for a payment platform\n5. Design Uber surge pricing (real-time demand ML)\n6. Design a large-scale text classification system\n7. Design a production RAG/chatbot system\n8. Design a distributed ML training platform',
        keyTakeaway:
            'For each of these 8 questions, prepare a 10-minute verbal walkthrough using the 6-step framework. Practice saying your design out loud — the ability to think and communicate simultaneously is a skill that requires practice. Record yourself and listen back to identify where you rush, skip steps, or make unsupported claims.',
      ),
      ConceptLesson(
        title: 'Trade-Off Communication: The Senior Engineer Signal',
        definition:
            'Senior AI engineer interviews require explicit trade-off reasoning — not just stating your design choices, but explaining what you are giving up and why that is acceptable given the requirements.',
        analogy:
            'Trade-off reasoning in system design is like an engineering specification review: a junior engineer says "I will use solution X." A senior engineer says "I will use solution X rather than Y because X provides lower latency at the cost of higher memory usage, and given our 50ms SLA requirement is more critical than our generous 16GB memory budget, X is the right choice."',
        example:
            'Explicit trade-off example:\n"For the candidate generation step, I am choosing approximate nearest neighbor search (FAISS) over exact nearest neighbor. FAISS is 10-100x faster but finds the top-100 candidates with 95% accuracy rather than 100%. For a recommendation system, missing 5% of truly relevant candidates is acceptable — we are showing 10 recommendations, and exact search at our scale (5M+ items) would not meet our 50ms SLA."',
        keyTakeaway:
            'Make every design decision a trade-off statement: "I am choosing [X] over [Y] because [metric A favoring X] is more important than [metric B favoring Y] given [specific constraint from requirements]." Three explicit, well-reasoned trade-offs in a 45-minute interview consistently receive "strong hire" signals from senior interviewers.',
      ),
      ConceptLesson(
        title: 'ML-Specific System Design Considerations',
        definition:
            'AI system design interviews require demonstrating knowledge of ML-specific concerns that software-only system design questions do not require: training-serving skew, data freshness requirements, model drift, A/B testing framework for model updates, cold start problem, and feature store architecture.',
        analogy:
            'ML-specific concerns in system design are like the electrical systems in a building — invisible to most occupants, absolutely critical to operation, and best designed by specialists who understand them deeply. A system design interview that shows ML-specific depth signals to interviewers that you actually know what it is like to operate ML systems in production.',
        example:
            'For a fraud detection system design, ML-specific concerns to address: Training data imbalance (0.1% fraud rate — need SMOTE or class weighting). Freshness requirement (new fraud patterns emerge hourly — need near-real-time feature updates). No ground truth delay (know about fraud hours/days after the transaction — need semi-supervised or delayed label training). Regulatory explainability (must explain rejection to customer in plain language — need SHAP integration). These concerns separate ML system designers from software system designers.',
        keyTakeaway:
            'For every AI system design problem, proactively address three ML-specific concerns that a generic software engineer would not think of. This demonstrates the depth that justifies the "AI Engineer" title over "Software Engineer with ML experience" — a distinction that top companies take very seriously.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'In an AI system design interview for "design a product recommendation system," how much time should be spent on clarifying requirements before starting the design?',
        options: [
          'No time — start designing immediately to demonstrate decisiveness',
          'About 5 minutes — ask questions about user scale, latency requirements, training data availability, and success metrics before drawing any architecture',
          'The entire interview — keep asking questions without committing to a design',
          '30 seconds — ask one question then start designing'
        ],
        correctIndex: 1,
        explanation:
            'Spending 5 minutes clarifying requirements is the first signal of senior engineering maturity in a system design interview. It prevents designing for wrong constraints and demonstrates that you understand real-world engineering involves understanding the problem before solving it.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What distinguishes a "Strong Hire" AI system design interview performance from a passing one?',
        options: [
          'Using the most advanced ML algorithms for every component',
          'Explicit trade-off reasoning for each major design decision, demonstrating ML-specific concerns (training-serving skew, data freshness, model drift), and adjusting the design appropriately when the interviewer adds new constraints',
          'Drawing the most comprehensive and detailed architecture diagram',
          'Naming the most specific technology choices for every component'
        ],
        correctIndex: 1,
        explanation:
            'Strong Hire signals: asking good clarifying questions, making quantitative scale estimates, providing explicit trade-off reasoning, demonstrating ML-specific depth, and adapting gracefully when constraints change. These behaviors demonstrate the judgment and communication skills of a senior engineer.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'You are designing a real-time fraud detection system. The interviewer asks why you chose a gradient boosting model over a deep learning model. What is the BEST response structure?',
        options: [
          '"Gradient boosting is always better than deep learning for tabular data"',
          '"For fraud detection with tabular transaction features, gradient boosting (XGBoost) provides: 15ms inference vs 45ms for a DNN (meeting our 20ms SLA), better interpretability for regulatory compliance requirements, and competitive accuracy on our structured features — making it the right choice for this specific constraint set. If we had unstructured data like transaction text or images, deep learning would be reconsidered."',
          '"I prefer gradient boosting because I am more familiar with it"',
          '"Both options are equally valid — the choice does not matter much"'
        ],
        correctIndex: 1,
        explanation:
            'The best response explicitly states: the specific technical metrics favoring the choice (15ms vs 45ms inference), how those metrics relate to requirements (20ms SLA), what is being traded away (potentially some accuracy), and under what conditions the decision would change. This is complete trade-off reasoning.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'In an AI system design interview, the interviewer says: "Now assume the system needs to handle 100x the traffic we discussed." How should a senior engineer respond?',
        options: [
          '"That changes everything — my previous design is wrong. Let me start completely over."',
          '"With 100x traffic, the key changes are: horizontal scaling of the serving layer to 100+ pods with auto-scaling, switching from single-instance Redis to a Redis cluster, moving from synchronous to asynchronous feature computation, and adding a content delivery network for static model artifacts. The core ML architecture remains the same — just the infrastructure scales."',
          '"My system can handle any traffic scale without modification."',
          '"That would require a complete redesign that we do not have time for."'
        ],
        correctIndex: 1,
        explanation:
            'Adapting gracefully to changing constraints is exactly what senior engineer interviews test. The correct response acknowledges the impact, identifies specifically what changes (infrastructure layers), and explicitly notes what stays the same (core ML design). This demonstrates calm, structured thinking under ambiguity.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You are asked to design a content moderation ML system. After you describe the ML pipeline, the interviewer asks: "What happens when your model is wrong?" What ML-specific concerns does this question probe?',
        options: [
          'Just the model accuracy metric, which should already be high',
          'False positive rate (incorrectly flagging legitimate content — user trust damage), false negative rate (missing harmful content — platform safety risk), human review escalation workflow, feedback loops for continuous improvement, bias auditing for demographic parity, and appeal mechanisms for affected users',
          'Only the model retraining frequency',
          'Nothing specific to ML — this is a general software reliability question'
        ],
        correctIndex: 1,
        explanation:
            'This question probes ML-specific operational concerns: the asymmetric cost of different types of errors (false positives harm good users; false negatives harm platform safety), the need for human-in-the-loop escalation, feedback mechanisms, and fairness considerations. These distinguish ML system design from software system design.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'AI System Design Mock Interview',
      goal:
          'Complete a timed, documented AI system design interview for one of the top 8 common questions.',
      steps: [
        'Choose one system design question: "Design a real-time product recommendation system for an e-commerce platform with 10 million daily active users."',
        'Set a timer for 45 minutes. Write out your design covering all 6 framework steps: requirements, scale estimation, problem formulation, data pipeline, training system, serving system, and monitoring.',
        'For each major design decision (model choice, database technology, serving architecture), write one explicit trade-off statement: "I choose X over Y because..."',
        'Draw or describe an architecture diagram showing: data sources, feature pipeline, training infrastructure, model registry, serving API, monitoring, and feedback loop.',
        'Identify and address 3 ML-specific concerns beyond what a software-only system design would consider.',
        'Review your design against the framework checklist: Did you clarify? Estimate scale? State trade-offs? Address ML-specific concerns? Request peer review or compare against publicly available solutions online.',
      ],
      expectedOutput:
          'Complete 45-minute AI system design document covering all 6 framework steps. Explicit trade-off statements for 3+ major decisions. Architecture diagram with all components labeled. 3 ML-specific concerns identified and addressed. Peer review or self-review completed against framework checklist.',
      xpReward: 80,
    ),
  ),
  TopicCourse(
    id: 'technical_coding_interviews_l10',
    topicTitle: 'Technical Coding Interviews for AI Engineers',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Expert',
    estimatedMinutes: 35,
    totalXp: 185,
    emoji: '💡',
    intro:
        'AI engineering interviews at top companies include technical coding rounds that test data structures, algorithms, and ML implementation skills. This lesson gives you the preparation strategy, key topic priorities, and communication framework to perform confidently in coding interviews at companies ranging from startups to FAANG.',
    concepts: [
      ConceptLesson(
        title: 'What AI Engineer Coding Interviews Actually Test',
        definition:
            'AI engineer coding interviews typically cover three areas: standard data structures and algorithms (LeetCode-style), ML implementation questions (implement a neural network layer, write backpropagation), and Python/NumPy proficiency for ML workloads (vectorization, broadcasting, efficient array operations).',
        analogy:
            'An AI engineer coding interview is like a driving test with three components: parallel parking (DSA — fundamental technique test), highway driving (ML implementation — domain-specific skill), and vehicle inspection knowledge (Python/NumPy proficiency — tooling expertise). Failing any one component is disqualifying regardless of performance on the others.',
        example:
            'Google ML Engineer coding round examples: Question 1 (DSA): "Implement a sliding window maximum algorithm." Question 2 (ML Implementation): "Implement batch normalization forward and backward passes in NumPy." Question 3 (ML Proficiency): "Debug this training loop — find and fix the 3 bugs preventing convergence." Three completely different skill domains tested in one interview.',
        keyTakeaway:
            'Do not neglect DSA preparation assuming ML knowledge alone is sufficient — top companies use identical DSA screening regardless of the ML specialization. Similarly, do not neglect ML implementation questions. A balanced 60/40 split (DSA/ML) in your preparation is appropriate for most mid-to-senior AI engineering roles.',
      ),
      ConceptLesson(
        title: 'DSA Priority List for AI Engineers',
        definition:
            'AI engineers should prioritize DSA topics in order of frequency in ML engineering interviews: Arrays/Strings and HashMaps (universal), Dynamic Programming (matrix problems appear often), Trees/Graphs (for hierarchical data and graph neural networks), Sorting/Searching (for ranked outputs), and Heaps (top-K problems in recommendation).',
        analogy:
            'Prioritizing DSA topics for AI engineering interviews is like packing for an outdoor expedition — bring the universally essential items first (arrays, hashmaps, DP are always needed), then the domain-specific items (graphs for network ML, heaps for ranking), and leave the very specialized equipment (advanced graph algorithms, segment trees) for expert-level positions.',
        example:
            'High-frequency ML-adjacent DSA problems: sliding window operations (for time-series feature engineering), top-K elements (for recommendation candidates), matrix operations (for attention mechanisms), BFS/DFS on graphs (for graph neural network traversal), and binary search on sorted lists (for efficient similarity lookup). These appear more often in ML engineering interviews than in generic software engineering interviews.',
        keyTakeaway:
            'If you have limited preparation time, prioritize: Arrays/Two Pointers, HashMaps/Counting, Dynamic Programming (especially 2D grid DP which mirrors many ML matrix operations), Trees/BFS/DFS, and Heap-based problems. These 5 categories cover 75% of what appears in AI engineer technical screens.',
      ),
      ConceptLesson(
        title: 'ML Implementation Coding Questions',
        definition:
            'ML implementation coding questions ask you to implement from scratch (without ML libraries) common ML operations: forward/backward passes, specific layer types (attention, batch norm), loss functions, evaluation metrics, or optimization algorithms.',
        analogy:
            'ML implementation questions are like asking a mechanical engineer to build an engine component with hand tools — it tests whether you understand the mechanics deeply enough to build it without automated machinery, proving genuine expertise rather than learned API usage.',
        example:
            'Common ML implementation questions: "Implement the forward and backward pass of a two-layer neural network using only NumPy." "Implement the scaled dot-product attention mechanism." "Write K-means clustering from scratch." "Implement BLEU score calculation." "Write the gradient descent update rule with L2 regularization." "Implement precision, recall, and F1 score without sklearn."',
        keyTakeaway:
            'For every ML concept you use in production, be able to implement its core logic from scratch in Python/NumPy. Not the full optimized library — the core computation. Implementing softmax, cross-entropy loss, backpropagation through a dense layer, and attention mechanism from scratch should take you under 15 minutes each after proper preparation.',
        codeSnippet:
            '# Core ML implementations to memorize/practice\nimport numpy as np\n\n# 1. Softmax (appears in every classification problem)\ndef softmax(x):\n    x_shifted = x - np.max(x, axis=-1, keepdims=True)\n    exp_x = np.exp(x_shifted)\n    return exp_x / np.sum(exp_x, axis=-1, keepdims=True)\n\n# 2. Cross-entropy loss\ndef cross_entropy_loss(y_pred_probs, y_true_onehot):\n    eps = 1e-9  # prevent log(0)\n    return -np.mean(np.sum(y_true_onehot * np.log(y_pred_probs + eps), axis=1))\n\n# 3. Attention mechanism\ndef scaled_dot_product_attention(Q, K, V, mask=None):\n    d_k = Q.shape[-1]\n    scores = Q @ K.transpose(-2, -1) / np.sqrt(d_k)\n    if mask is not None:\n        scores = scores + (mask * -1e9)\n    weights = softmax(scores)\n    return weights @ V, weights\n\n# 4. K-means clustering\ndef kmeans(X, k, max_iter=100):\n    centroids = X[np.random.choice(len(X), k, replace=False)]\n    for _ in range(max_iter):\n        distances = np.linalg.norm(X[:, np.newaxis] - centroids, axis=2)\n        labels = np.argmin(distances, axis=1)\n        new_centroids = np.array([X[labels == i].mean(axis=0) for i in range(k)])\n        if np.allclose(centroids, new_centroids): break\n        centroids = new_centroids\n    return labels, centroids\n\n# 5. Gradient descent with L2 regularization\ndef gradient_descent_step(weights, gradient, learning_rate, lambda_l2=0.01):\n    l2_grad = 2 * lambda_l2 * weights\n    return weights - learning_rate * (gradient + l2_grad)',
      ),
      ConceptLesson(
        title: 'The STAR Coding Interview Communication Framework',
        definition:
            'Effective coding interview communication follows a structured approach: Summarize the problem back, Think aloud through your approach, Announce before coding, and Recap after — showing the interviewer your reasoning process, not just your code.',
        analogy:
            'Coding interview communication is like narrating a surgery for medical students observing — the surgeon explains what they see, what they plan to do, what they are doing as they do it, and what they observe afterward. An interviewer is evaluating your reasoning process, not just the outcome. A correct solution built silently is less impressive than a slightly imperfect solution built with clear thinking communicated throughout.',
        example:
            '"OK so this is asking me to find the K closest points to the origin. My first thought is a sort-by-distance approach which would be O(n log n), but I think we can do better with a max-heap of size K — maintaining only the K closest points as we scan, giving us O(n log K). Let me walk through the approach before coding: [explains]. Any questions or constraints I am missing before I start? [codes with running commentary]. And now I will verify with your example: K=2, points [[1,3],[-2,2]]... distance 1+9=10 and 4+4=8, so closest 2 are [[-2,2],[1,3]] which matches. Time complexity O(n log K), space O(K)."',
        keyTakeaway:
            'In a 45-minute coding interview, the first 5 minutes (problem clarification and approach discussion) and last 3 minutes (testing and complexity analysis) are where most interview outcomes are determined. Write code in the middle 37 minutes — but bookend it with quality communication.',
      ),
      ConceptLesson(
        title: 'Python Proficiency: NumPy, Vectorization and Efficiency',
        definition:
            'AI engineering coding interviews often include Python proficiency questions testing efficient data manipulation with NumPy and Pandas — writing vectorized operations, avoiding inefficient loops, and demonstrating knowledge of broadcasting, array indexing, and memory efficiency.',
        analogy:
            'Python proficiency for ML engineering is like kitchen knife skills for a professional chef — it is not the most glamorous skill, but it dramatically affects the speed and quality of every single thing you produce. An ML engineer who reaches for for-loops when vectorized operations are available is like a chef who reaches for a spoon to mince garlic.',
        example:
            'Common Python/NumPy proficiency questions: "Rewrite this triple-nested for loop computing cosine similarity between two sets of embeddings as a vectorized NumPy operation (should be 100x faster)." "Implement efficient batch tokenization for 100K sentences without loading all into memory at once." "Find the top-100 most similar document embeddings to a query embedding without computing all pairwise distances."',
        keyTakeaway:
            'Master these NumPy patterns before any ML engineering interview: array broadcasting, boolean masking and fancy indexing, einsum for complex tensor operations, argsort for efficient top-K selection, and memory-efficient chunked processing of large datasets. Each of these appears regularly in ML engineering coding screens.',
        codeSnippet:
            '# NumPy patterns to master for ML engineering interviews\nimport numpy as np\n\n# 1. Efficient cosine similarity (vectorized — no loops)\ndef batch_cosine_similarity(query, embeddings):\n    """query: (d,), embeddings: (N, d) -> similarities: (N,)\"\"\"\n    query_norm = query / np.linalg.norm(query)\n    emb_norms = embeddings / np.linalg.norm(embeddings, axis=1, keepdims=True)\n    return emb_norms @ query_norm  # (N,) — no loop needed\n\n# 2. Top-K without sorting all (efficient)\ndef top_k_efficient(similarities, k):\n    return np.argpartition(similarities, -k)[-k:]  # O(N) vs O(N log N) sort\n\n# 3. Efficient batch operations with broadcasting\ndef pairwise_distances(X, Y):\n    """X: (N, d), Y: (M, d) -> distances: (N, M)\"\"\"\n    # X**2: (N, 1), Y**2: (M,), -2*X@Y.T: (N, M)\n    return np.sqrt(np.sum(X**2, axis=1, keepdims=True) +\n                   np.sum(Y**2, axis=1) -\n                   2 * X @ Y.T)\n\n# 4. Chunked processing for memory efficiency\ndef compute_embeddings_chunked(texts, model, chunk_size=128):\n    all_embeddings = []\n    for i in range(0, len(texts), chunk_size):\n        chunk = texts[i:i + chunk_size]\n        embeddings = model.encode(chunk)  # only chunk_size in memory at once\n        all_embeddings.append(embeddings)\n    return np.vstack(all_embeddings)',
      ),
      ConceptLesson(
        title: 'Interview Preparation Strategy: 8-Week Plan',
        definition:
            'A structured 8-week coding interview preparation plan covers DSA fundamentals, ML implementations, mock interviews, and company-specific preparation — with progressive difficulty and consistent review of previously seen patterns.',
        analogy:
            'Coding interview preparation is like training for a marathon: you cannot run 42km on day 1 without preparation, but with a structured progressive training plan — building base fitness, adding speed work, doing test runs — the marathon becomes achievable and predictable. Random preparation without structure is the most common failure mode.',
        example:
            'Week 1-2: Array, String, HashMap problems (40 easy/medium LeetCode). Week 3-4: Trees, Graphs, Two Pointers, Sliding Window (30 medium problems). Week 5: DP fundamentals (20 medium DP problems — focus on 2D grid patterns). Week 6: ML implementations from scratch (softmax, backprop, attention, k-means, k-NN). Week 7: 2 mock interviews per day, review weak areas. Week 8: Company-specific problems (search on LeetCode by company tag), behavioral questions, final review.',
        keyTakeaway:
            'Consistency beats intensity in coding interview preparation. 2 problems per day for 8 weeks (112 problems) produces consistently better outcomes than 20 problems per day for 1 week (140 problems) — the spaced repetition and habit of daily problem-solving builds pattern recognition that intensive cramming cannot.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'In an AI engineering technical interview, after reading a coding problem, what should you do BEFORE writing any code?',
        options: [
          'Immediately start coding to show speed and confidence',
          'Restate the problem back to confirm understanding, ask clarifying questions (edge cases, input constraints), describe your approach out loud and confirm its correctness with the interviewer, then begin coding',
          'Ask the interviewer for a hint to show humility',
          'Write comments first describing what you plan to code'
        ],
        correctIndex: 1,
        explanation:
            'Jumping straight to coding without clarification is the most common interview mistake. Restating the problem prevents misunderstandings, clarifying questions reveal edge cases and constraints, and discussing your approach before coding allows the interviewer to redirect you if needed — saving you from implementing a wrong approach for 30 minutes.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'An AI engineer coding interview asks you to "find the K most similar vectors to a query vector from a dataset of 1 million vectors." What is more efficient than sorting all pairwise similarities?',
        options: [
          'A for-loop computing each similarity one at a time',
          'np.argpartition(similarities, -K)[-K:] — a partial sort that finds top-K in O(N) time vs O(N log N) for full sort, dramatically faster for large N at moderate K values',
          'Sorting descending and taking the first K',
          'Loading the full dataset into a list and using Python\'s sorted() function'
        ],
        correctIndex: 1,
        explanation:
            'np.argpartition is a key NumPy optimization pattern for top-K selection — it uses an O(N) algorithm (introselect) rather than full O(N log N) sorting. For N=1M and K=100, this is roughly 10,000x more efficient than a full sort.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are asked to "implement sigmoid activation and binary cross-entropy loss from scratch in Python without any ML libraries." The timer starts now. What is the correct implementation order?',
        options: [
          'Start with binary cross-entropy since it is more complex',
          'Implement sigmoid first (it is needed inside BCE), add numerical stability (np.exp(-x) clipping), implement BCE using the sigmoid output, then test with simple examples: sigmoid(0)=0.5, BCE with perfect prediction ≈ 0',
          'Ask for the mathematical formula first',
          'Use scipy.special.expit instead of implementing it'
        ],
        correctIndex: 1,
        explanation:
            'Dependency order matters: sigmoid must be implemented first since BCE needs it. Numerical stability (preventing overflow in np.exp for large negative x) must be added immediately. Testing with known values (sigmoid(0)=0.5) confirms correctness before submitting. This methodical approach demonstrates professional coding discipline.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Technical Interview Preparation Sprint',
      goal:
          'Complete a structured technical interview preparation with documented solutions across all three AI engineering interview domains.',
      steps: [
        'DSA Foundation (Week 1 simulation): Solve 10 medium-difficulty LeetCode problems across: arrays (3), trees (2), graphs (2), and DP (3). Write time/space complexity analysis for each solution.',
        'ML Implementation Sprint: Implement from scratch without ML libraries: softmax, cross-entropy loss, scaled dot-product attention, k-means clustering, and gradient descent with L2 regularization. Document each with docstrings and test cases.',
        'NumPy Proficiency: Implement batch cosine similarity, top-K efficient selection using argpartition, pairwise distance matrix using broadcasting, and chunked batch processing for large datasets.',
        'Timed Mock Interview: Set a 45-minute timer. Attempt this question: "Implement a simple neural network with one hidden layer using only NumPy — forward pass, backward pass, and weight updates." Communicate out loud as you code.',
        'Review and Score: After the mock interview, assess yourself on: Did you clarify? Did you think out loud? Did you handle edge cases? Did you state time/space complexity? Use this to identify your weakest area.',
        'Company-Specific Practice: Search LeetCode for 5 problems tagged with one target company and solve them, noting patterns specific to that company\'s interview style.',
      ],
      expectedOutput:
          '10 LeetCode medium solutions with complexity analysis documented. 5 ML implementations with docstrings and test cases. 4 NumPy efficiency patterns implemented. 45-minute mock interview completed with self-assessment. Company-specific pattern analysis documented.',
      xpReward: 75,
    ),
  ),
  TopicCourse(
    id: 'behavioral_hr_interview_l10',
    topicTitle: 'Behavioral & HR Interview Mastery',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Expert',
    estimatedMinutes: 30,
    totalXp: 160,
    emoji: '🎯',
    intro:
        'Behavioral interviews determine whether you get the offer after acing the technical rounds. At Google, Amazon, and Meta, behavioral interviews screen for leadership principles, collaboration skills, and professional judgment — and failing them disqualifies technically brilliant engineers every day. This lesson gives you the framework to answer any behavioral question with confidence and precision.',
    concepts: [
      ConceptLesson(
        title: 'Why Behavioral Interviews Eliminate Technical Candidates',
        definition:
            'Top AI companies use behavioral interviews to assess cultural fit, leadership maturity, conflict resolution, and professional judgment — qualities that determine whether a technically skilled engineer will actually be effective within the organization.',
        analogy:
            'Behavioral interviews assess whether a brilliant chef will thrive in a specific restaurant\'s kitchen — not just their cooking skills. A technically perfect cook who cannot handle busy service rush, disrespects colleagues, or refuses to adapt to the restaurant\'s standards is a poor hire regardless of technical brilliance.',
        example:
            'Google\'s "Googliness" assessment, Amazon\'s Leadership Principles evaluation, and Meta\'s "People Focused" interview all screen for the same underlying question: is this person effective when working with others, under pressure, and in situations with no clear right answer? Technical skills get you to the behavioral interview; behavioral skills determine whether you leave with an offer.',
        keyTakeaway:
            'Prepare behavioral interview stories before technical preparation — not after. Many engineers fail behavioral rounds simply because they prepared zero stories. Two weeks of story preparation can be the difference between an offer and rejection for candidates who are technical equals.',
      ),
      ConceptLesson(
        title: 'The STAR Framework: Behavioral Interview Gold Standard',
        definition:
            'STAR (Situation, Task, Action, Result) is the universal structure for answering behavioral questions: briefly describe the context (Situation), your specific role (Task), exactly what you did (Action — the most important and detailed section), and the measurable outcome (Result).',
        analogy:
            'A STAR answer is like a case study presentation: you set the scene (Situation), explain what was needed (Task), narrate your investigation and solution process (Action — the main story), and report the outcome (Result). Skipping any element is like presenting a case study with the conclusion missing.',
        example:
            '"Tell me about a time you had a technical disagreement with a colleague."\nS: "At my previous role, we were selecting a model for a real-time fraud detection system with a 50ms SLA."\nT: "I was responsible for the ML component and my colleague (a senior engineer) favored a deep neural network, while I believed gradient boosting was more appropriate for our latency constraint."\nA: "I ran benchmark experiments: XGBoost achieved 15ms inference at 94% precision while the DNN averaged 65ms at 95.8% precision. I presented the data to both of us and our manager, framing the decision as a trade-off between latency compliance and marginal accuracy, not as a personal debate."\nR: "We chose XGBoost. It met the SLA and maintained 93.1% precision in production. My colleague appreciated the data-driven approach and we established a shared benchmarking process for future model decisions."',
        keyTakeaway:
            'The Action section should be 60-70% of your STAR answer — this is where interviewers assess your judgment and capability. Most candidates spend too much time on Situation and not enough on what they specifically did. Use "I" not "we" in the Action section — the interviewer is evaluating your individual contribution.',
      ),
      ConceptLesson(
        title: 'The 6 Must-Prepare Behavioral Story Categories',
        definition:
            'Behavioral interviews draw from six core categories that cover the vast majority of questions at any company: technical conflict resolution, failing and recovering, influencing without authority, delivering under tight deadline, handling ambiguity, and proactively improving a process.',
        analogy:
            'Preparing 6 behavioral story categories is like stocking a restaurant kitchen with 6 versatile mother sauces — from these, you can create hundreds of dishes (answer variations) that cover almost any menu request (question). Having the core stories prepared lets you adapt them to any specific question phrasing.',
        example:
            'The 6 categories and one story minimum for each: 1) Technical conflict (disagreed with colleague/manager, stayed data-driven, resolved productively). 2) Failure (ML model underperformed, root-caused it, recovered with a better approach). 3) Influence without authority (got stakeholder support for a technical change without formal power). 4) Deadline pressure (shipped production ML system under tight deadline, maintained quality). 5) Ambiguity (defined and solved a poorly-specified ML problem). 6) Process improvement (proactively built a tool/process that improved team efficiency).',
        keyTakeaway:
            'Write out your STAR stories before the interview, not during. Each story should be 2-3 minutes when spoken. Practice saying them aloud — the written version is always longer and more formal than the spoken version. Time yourself: over 3 minutes per story is too long for behavioral interviews.',
      ),
      ConceptLesson(
        title: 'Company-Specific Behavioral Frameworks',
        definition:
            'Each major company has specific cultural values that their behavioral interviews map to: Amazon has 16 Leadership Principles, Google assesses Googliness and Leadership, Meta values Move Fast and People Focus, and startups assess adaptability and ownership.',
        analogy:
            'Company-specific behavioral frameworks are like dress codes — each organization has its own standards, and a wardrobe that is perfect for one company may be inappropriate for another. Understanding what each organization values allows you to select the most relevant stories from your collection rather than using a generic one-size-fits-all approach.',
        example:
            'Amazon "Customer Obsession" principle: prepare a story where you directly advocated for user experience or customer impact against business pressure or technical convenience. Amazon "Bias for Action" principle: prepare a story where you moved forward with 70% of information rather than waiting for complete certainty, and the outcome was positive. Mapping your stories to specific company principles dramatically improves your match rate.',
        keyTakeaway:
            'For every company you interview with, read their published values, engineering blog posts, and employee reviews on Glassdoor. Map each of your 6 core stories to their framework. Tell the interviewer which principle your story addresses if they have a well-known framework — it signals that you researched their culture.',
      ),
      ConceptLesson(
        title:
            'Questions to Ask Interviewers: Making the Best Use of the Last 5 Minutes',
        definition:
            'The last 5 minutes of every interview — when you ask the interviewer questions — is an opportunity to demonstrate intellectual curiosity, strategic thinking, and genuine interest in the role. Generic questions signal disinterest; specific, thoughtful questions signal preparedness and seriousness.',
        analogy:
            'Questions you ask at the end of an interview are like questions a customer asks before a major purchase — they reveal how seriously you have done your research, whether you understand what you are buying, and whether you are genuinely interested or just shopping around.',
        example:
            'Strong questions for an AI engineer role: "What is the biggest ML infrastructure challenge the team is working on this quarter?" / "How does the team approach the trade-off between model performance and inference cost at your scale?" / "What does the model review and deployment approval process look like?" / "What does success look like in this role in the first 6 months?" These demonstrate technical depth, role understanding, and genuine curiosity — the opposite of "What are the benefits?"',
        keyTakeaway:
            'Prepare 5-6 questions per interview so you have backup if earlier questions get answered during the conversation. Ask each interviewer one unique question — asking the same question in every round signals you are not listening and not genuinely curious. The best questions combine your research about the company with something you genuinely want to know.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'In a STAR behavioral answer, which section should take up the most time and why?',
        options: [
          'Situation — the context is the most important for the interviewer to understand',
          'Action — this is where the interviewer assesses your judgment, initiative, and specific contribution. What YOU did matters more than the background context',
          'Result — the outcome is what demonstrates competence',
          'Task — clarifying your specific responsibility is the most critical element'
        ],
        correctIndex: 1,
        explanation:
            'Interviewers are evaluating your individual judgment and capability — what you specifically did, how you thought about the problem, what options you considered, and why you chose your approach. Action should be 60-70% of your answer. Many candidates over-explain Situation (30% of the answer) and rush Action — the reverse of optimal.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'An interviewer at Amazon asks: "Tell me about a time you failed." What is the WORST way to answer this question?',
        options: [
          'Describing a genuine technical failure, what you learned, and how you applied that learning to future work',
          '"I once worked too hard and cared too much about quality" — disguising a strength as a weakness, which interviewers at Amazon are trained to recognize as evasive and score negatively',
          'Acknowledging a real ML project that underperformed and explaining the root cause and recovery',
          'Describing a mistake in a previous technical decision and the process change it prompted'
        ],
        correctIndex: 1,
        explanation:
            'Disguising a strength as a failure ("I work too hard") is one of the most recognized non-answers in behavioral interviews. Experienced Amazon interviewers are specifically trained to probe these non-answers further and score them as evidence of poor self-awareness or dishonesty. Genuine failures with learning demonstrate mature professional judgment.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are asked: "Tell me about a time you had to make a technical decision with incomplete information." Using STAR, which answer demonstrates the best engineering judgment?',
        options: [
          '"I always wait until I have complete information before making decisions" — showing thoroughness',
          '"We needed to select a model architecture for a product launch in 3 weeks with only 2 weeks of data available. I defined the minimum viable accuracy threshold (82% precision), ran a rapid experiment with 3 architectures on available data, chose the one meeting threshold with least overfitting risk (despite incomplete validation), and built in a monitoring alert to catch degradation — which never fired. We launched on time and maintained 84% precision."',
          '"I asked my manager to make the decision since I did not have enough information"',
          '"I delayed the project launch until we had enough data to be certain"'
        ],
        correctIndex: 1,
        explanation:
            'The second answer shows: quantified requirements (82% precision threshold), structured experiment design under time constraint, explicit risk mitigation (monitoring alert), and positive outcome with metrics. It demonstrates professional judgment in ambiguity — exactly what Amazon\'s "Bias for Action" and Google\'s "Level of Comfort with Ambiguity" evaluate.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Behavioral Interview Story Bank',
      goal:
          'Build a complete behavioral interview story bank covering all 6 categories, optimized for STAR structure and company-specific principles.',
      steps: [
        'Write one STAR story for each of the 6 categories: technical conflict, failure and recovery, influence without authority, deadline pressure, handling ambiguity, process improvement. Each story should be 250-350 words written.',
        'Time yourself telling each story aloud. Target 2-2.5 minutes per story. If any story exceeds 3 minutes, cut the Situation to one sentence and redistribute time to Action.',
        'Map your 6 stories to the company principles of 2 target companies (e.g., Amazon Leadership Principles, Google\'s Googliness attributes). Note which story best maps to which principle.',
        'Prepare 6 thoughtful questions to ask interviewers — 2 about technical challenges, 2 about team culture and process, 2 about the specific role and success metrics.',
        'Practice with a peer or record yourself on video for one full behavioral mock interview covering: STAR answers for 4 questions, 2 thoughtful questions to the interviewer, and professional closing.',
        'Review the video or peer feedback and identify: do you say "we" when you should say "I"? Do you spend too long on Situation? Do your results include metrics? Iterate on the 2 weakest stories.',
      ],
      expectedOutput:
          '6 written STAR stories (250-350 words each), timed at 2-2.5 min spoken. Stories mapped to target company principles. 6 thoughtful interviewer questions prepared. Full mock behavioral interview recorded or peer-reviewed. 2 weakest stories improved based on feedback.',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'ai_career_paths_l10',
    topicTitle:
        'AI Career Paths (Startup, Product, FAANG, Research, Freelancing)',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Expert',
    estimatedMinutes: 30,
    totalXp: 160,
    emoji: '🗺️',
    intro:
        'There is no single "AI engineer career path" — there are five distinctly different trajectories, each with different trade-offs, skill requirements, and outcomes. This lesson gives you an honest, practical picture of each path so you can make an informed choice that aligns with your values, ambitions, and life circumstances.',
    concepts: [
      ConceptLesson(
        title: 'FAANG/Big Tech AI Engineering: The Full Picture',
        definition:
            'FAANG (Meta, Amazon, Apple, Netflix, Google) and Big Tech AI roles (Microsoft, OpenAI, Anthropic, DeepMind) offer the highest compensation, most advanced infrastructure, and largest scale problems — with structured processes, slower individual impact, and highly competitive hiring.',
        analogy:
            'Working at a FAANG AI company is like working in a world-class research hospital — you have the best equipment, collaborate with the best specialists, and work on the hardest cases, but you are one of hundreds of specialists and the institutional processes move slowly. The environment enables work otherwise impossible; the scale means individual impact is diffuse.',
        example:
            'FAANG AI engineer realities: Compensation at Google/Meta: ₹1.5-4 Cr/year in India, \$300K-800K+ total compensation in the US. Scope: you own one specific component in a massive system — never the entire thing. Interview bar: 5-8 rounds including DSA, ML system design, ML fundamentals, and behavioral. Timeline from application to offer: 4-12 weeks. Exit opportunities: excellent — ex-FAANG engineers command premium in any subsequent role.',
        keyTakeaway:
            'FAANG is neither the only path nor the right path for everyone. It optimizes for compensation, brand prestige, and access to large-scale infrastructure. It sub-optimizes for end-to-end ownership, fast individual impact, and entrepreneurial experience. Decide what you are optimizing for before spending months on FAANG interview preparation.',
      ),
      ConceptLesson(
        title: 'AI Startups: Equity, Speed, and Ownership',
        definition:
            'AI startups offer early employees end-to-end ownership, faster career progression, direct business impact, and equity upside — with lower base salaries, higher execution risk, and significantly more ambiguity in processes and role definition.',
        analogy:
            'Joining an AI startup as an early engineer is like being one of the first crew members on an expedition ship — you have far more influence over the voyage than on a cruise liner, your individual contribution visibly affects outcomes, and if the expedition succeeds you share the discovery. If it fails, you have the experience of what an expedition actually takes.',
        example:
            'An early AI engineer (employee #12) at a Series A startup might: design and own the entire ML platform, deploy models to production, present ML roadmap to the board, hire the ML team, and receive 0.3-1% equity. If the company raises a Series B at \$100M valuation, that equity is worth \$300K-\$1M on paper. If it exits at \$500M, it is worth \$1.5-5M. But most startups do not exit at these valuations.',
        keyTakeaway:
            'Startup AI roles are best suited for engineers who: thrive with ambiguity, want to see direct impact of their work, are willing to trade some compensation for ownership and upside, and learn faster through doing than through structured mentorship. They are poorly suited for engineers who need structured environments, clear processes, or guaranteed stability.',
      ),
      ConceptLesson(
        title: 'Product Company AI Engineering: The Middle Path',
        definition:
            'Product company AI engineering (Swiggy, Flipkart, CRED, Razorpay, Zepto in India; Stripe, Airbnb, Spotify, Lyft globally) offers a compelling middle ground: meaningful scale, business-aligned ML problems, moderate compensation, and tangible user impact without startup risk.',
        analogy:
            'A product company AI role is like cooking in a well-established restaurant that has its signature reputation and steady clientele — you are not on the unstable frontier, but you are also not lost in the bureaucracy of a massive institution. Your work directly affects diners who come back because of the food you cook.',
        example:
            'ML Engineer at Swiggy: owning the demand forecasting model that affects every restaurant partner\'s revenue. Direct business impact visible in 2-week release cycles. Team of 3-5 ML engineers — your work is visible to leadership. Compensation: ₹30-90L in India (less than FAANG, more than most startups). Role security better than startups. Exit opportunities: strong — demonstrated product-scale ML engineering.',
        keyTakeaway:
            'Product companies offer the best starting point for most early-career AI engineers: real scale (not startup toy problems), real business stakes (not isolated research), human-sized teams (you are not lost in FAANG\'s bureaucracy), and competitive compensation. They also provide excellent preparation for either FAANG or startup paths later.',
      ),
      ConceptLesson(
        title: 'Research Path: PhD, Research Engineering, Applied Research',
        definition:
            'The research path encompasses: academic research (PhD leading to professor or research scientist roles), research engineering (implementing and scaling research at AI labs), and applied research (bridging research and production at companies like Google Brain, Meta FAIR, Microsoft Research).',
        analogy:
            'The research path in AI is like academic medicine — you spend years building fundamental understanding that the entire field benefits from, your work is cited and built upon by others, and the intrinsic reward is discovering something genuinely new. The career path is long, the compensation may lag industry until senior levels, and the impact is diffuse but deep.',
        example:
            'Research Engineer at a frontier AI lab (Anthropic, OpenAI, DeepMind): focus on implementing and scaling research ideas from papers. Requires: deep mathematical understanding of ML, ability to read and implement papers, software engineering excellence, and ability to contribute original ideas. Compensation at senior levels comparable to FAANG. Requires either a strong publication record or exceptional practical ML contributions.',
        keyTakeaway:
            'The research path requires genuine intellectual curiosity and tolerance for uncertainty — most research directions fail, and the ones that succeed may take years to show impact. It is the right path for people who find the "why does this work?" question more compelling than the "how do we deploy this?" question.',
      ),
      ConceptLesson(
        title: 'Freelancing and Consulting: Independence and Diversification',
        definition:
            'AI consulting and freelancing offers the highest hourly rates in the field, complete schedule independence, and varied project exposure — with the trade-offs of income volatility, lack of institutional benefits, and self-driven business development requirements.',
        analogy:
            'AI freelancing is like being a general contractor rather than a company employee — you are hired for specific projects, command premium rates for specialized expertise, work on diverse challenges, and have no single employer\'s constraints, but you also have no guaranteed income between projects and must continuously market yourself.',
        example:
            'Experienced AI consultant typical engagements: helping a healthcare company build their first ML infrastructure (₹8-15L for 3 months), training a company\'s engineering team on LLM integration (₹2-5L for intensive workshops), and building a custom RAG system for a law firm (₹10-20L over 4 months). Combined ₹20-40L annual revenue working 60% of the year.',
        keyTakeaway:
            'Freelancing becomes viable after 4-5 years of strong portfolio experience — it is not a path for early-career engineers. To transition: build a public portfolio, specialize in a high-demand niche (LLM systems, ML infrastructure, NLP), start with referrals from your professional network, and maintain at least 6 months of expenses before leaving employment.',
      ),
      ConceptLesson(
        title: 'Choosing Your Path: A Framework',
        definition:
            'Choose your career path by honestly evaluating five personal variables: financial goals (immediate vs long-term wealth), risk tolerance (stability vs upside), ownership preference (full stack vs specialized), impact style (deep/narrow vs broad/diffuse), and learning style (mentored/structured vs self-directed).',
        analogy:
            'Choosing an AI career path is like choosing where to invest your most valuable asset (your career capital) — different investment vehicles (FAANG, startup, research, consulting) have different risk/reward profiles, liquidity (exit opportunities), and time horizons, and no single vehicle is objectively best for all investors.',
        example:
            'Decision matrix: If top priority is maximum long-term wealth → FAANG + equity at a likely-to-IPO startup. If top priority is immediate ownership and learning breadth → early-stage startup. If top priority is work-life balance and business impact → product company. If top priority is intellectual depth and discovery → research path. If top priority is autonomy and variety → consulting after gaining experience. Most people prioritize 2-3 of these — the path that satisfies your top 2 is usually the right one.',
        keyTakeaway:
            'Career paths are not permanent choices — most AI engineers move between them over time. Starting at a product company and moving to FAANG after 3 years is extremely common. FAANG engineers founding startups is the norm. Research engineers consulting during sabbatical is regular. Choose optimally for your next 2-3 years, not for your entire life.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the primary trade-off an AI engineer accepts when choosing a FAANG role over an early-stage startup role?',
        options: [
          'FAANG roles have lower compensation than startups',
          'FAANG offers higher compensation and brand prestige while startups offer more individual ownership, end-to-end impact, equity upside, and faster breadth of learning — the trade-off is stability and compensation vs ownership and potential upside',
          'FAANG roles use less advanced technology than startups',
          'Startups never offer equity compensation'
        ],
        correctIndex: 1,
        explanation:
            'Both paths have genuine advantages. FAANG provides compensation certainty, infrastructure scale, and institutional support. Startups provide ownership, direct impact visibility, and equity upside (with risk). The right choice depends entirely on what the individual engineer prioritizes at this stage of their career.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'At what career stage does AI freelancing typically become financially viable?',
        options: [
          'Immediately after completing an AI bootcamp',
          'After 4-5 years of demonstrated portfolio-worthy experience with a specialization in high-demand AI skills — before that, the hourly rate premium is insufficient and clients cannot verify expertise without a strong track record',
          'Only after working at a FAANG company',
          'Any time, since AI skills are always in demand'
        ],
        correctIndex: 1,
        explanation:
            'Freelancing rates are premium because clients pay for verified expertise and demonstrated delivery. Without a portfolio of completed projects and professional references, commanding premium rates is extremely difficult. 4-5 years of quality experience in a specialization builds the credibility clients require before trusting you with significant engagements.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You receive two offers simultaneously: FAANG ML Engineer at ₹45L total compensation with strong structured mentorship, and a Series A startup ML Engineer at ₹28L base + 0.15% equity building a foundational AI product. You are 2 years into your career. What factors should MOST influence this decision?',
        options: [
          'Always choose the highest salary — financial security is paramount',
          'Evaluate: your risk tolerance (startup may fail), what you want to learn in the next 3 years (breadth and ownership vs specialization), your financial obligations (dependents, loans), and how you value the equity option — then choose the option aligning with your top 2 priorities for this career stage',
          'Always choose the startup — equity upside is worth any trade-off',
          'Choose whichever has the more famous company name for your resume'
        ],
        correctIndex: 1,
        explanation:
            'This is a genuinely difficult trade-off with no universally correct answer. The right decision depends on personal circumstances: financial obligations (a single person with minimal obligations can take more equity risk than someone supporting dependents), career priorities (if you want end-to-end ownership, the startup is better; if you want specialization and mentorship, FAANG is better), and your honest assessment of the startup\'s probability of success.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Career Path Decision Framework',
      goal:
          'Build a personal career path decision framework and 5-year plan aligned with your specific values and circumstances.',
      steps: [
        'Rate your priorities (1-5): financial stability, ownership/impact, learning breadth, work-life balance, intellectual depth, entrepreneurial upside, institutional prestige. Your top 3 priorities are your compass.',
        'Research 3 specific companies for each career path that interests you (FAANG, product company, startup, research). Find real job postings at each and note compensation ranges, technology stack, team size, and role expectations.',
        'Interview one professional in each of your top 2 preferred paths through LinkedIn outreach. Ask: what do you wish you had known? What do you find most valuable and most limiting about this path?',
        'Write a 2-year career plan: target role, target company type, skills you still need to build, and the specific actions you will take in the next 6 months to reach this target.',
        'Write a 5-year vision: where do you want to be, what kind of problems do you want to solve, what type of team do you want to be part of?',
        'Identify your single biggest career gap today: is it technical depth, portfolio strength, network, interview skills, or experience level? Write a specific 90-day action plan to close this gap.',
      ],
      expectedOutput:
          'Priority ranking completed. 3 companies researched per preferred path. 2 professional conversations conducted and insights documented. 2-year specific career plan written. 5-year vision defined. Biggest gap identified with 90-day action plan.',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'salary_negotiation_career_growth_l10',
    topicTitle: 'Salary Negotiation & Career Growth',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Expert',
    estimatedMinutes: 30,
    totalXp: 165,
    emoji: '💰',
    intro:
        'The average AI engineer who does not negotiate their first job offer leaves ₹5-20 lakhs on the table in year one alone — and this compounds across every raise, promotion, and subsequent offer. This lesson gives you the exact language, tactics, and mindset to negotiate with confidence and receive the compensation you deserve as a skilled AI professional.',
    concepts: [
      ConceptLesson(
        title: 'The Negotiation Mindset Shift',
        definition:
            'Salary negotiation is not a conflict — it is a collaborative conversation about how to structure a mutually beneficial arrangement. Companies expect candidates to negotiate; not negotiating is often interpreted as lack of confidence or market awareness, not politeness.',
        analogy:
            'Not negotiating a salary offer is like accepting the first price at a car dealership without any discussion. The dealer posted that price knowing it is the starting point for a conversation, not the final price. The candidate who says "I accept" to the first offer does not make the recruiter happy — they make the recruiter think they got a bargain.',
        example:
            'A Google recruiter reported: "Candidates who professionally negotiate always receive at least some improvement in their offer — sometimes just ₹2-3L, sometimes significant equity refreshes or signing bonuses. Candidates who accept immediately occasionally get better deals, but more often than not they leave meaningful compensation on the table. We never retract offers due to professional negotiation."',
        keyTakeaway:
            'Negotiation is professional, expected, and never risky when done respectfully. The worst realistic outcome of professional negotiation is "I am sorry, that is our best offer" — you are no worse off than not negotiating. The best outcome can add 10-30% to your total compensation package.',
      ),
      ConceptLesson(
        title: 'Market Research: Know Your Number Before Any Conversation',
        definition:
            'Effective salary negotiation requires knowing your market rate — the range of compensation for your specific role, experience level, and location — through multiple data sources before any offer conversation begins.',
        analogy:
            'Knowing your market rate before negotiating is like knowing a house\'s appraised value before making an offer — it prevents both overpaying and underselling, and gives you an objective basis for any price discussion that removes the emotional component and grounds the conversation in data.',
        example:
            'Research sources for AI Engineer compensation in India: LinkedIn Salary (search exact role + location + YoE), Glassdoor (search company + role + location), Levels.fyi (for companies with public comp data, especially FAANG), AmbitionBox (India-specific), industry network contacts, job postings with listed salary ranges. Cross-reference at least 3 sources for reliable range.',
        keyTakeaway:
            'Never reveal your salary expectation or current salary before receiving an offer — it anchors the negotiation below your market value. If pressed, say "I am happy to discuss compensation once we have confirmed mutual interest in the role." If legally required to disclose current salary (some locations), provide the total compensation (base + bonus + benefits), not just base salary.',
        codeSnippet:
            '# Salary research checklist (not code — research framework)\n# Research before any interview starts\n\n# Step 1: Data sources\n# India:\n# - AmbitionBox: ambitionbox.com (India-specific, large dataset)\n# - LinkedIn Salary: linkedin.com/salary\n# - Glassdoor: glassdoor.co.in/Salaries\n# - Naukri.com Salary Insights\n\n# Global/FAANG:\n# - Levels.fyi (most accurate for FAANG total compensation)\n# - Glassdoor.com\n# - Blind (anonymous self-reported compensation)\n\n# Step 2: Search parameters\n# Role: "Machine Learning Engineer" / "AI Engineer" / "Senior ML Engineer"\n# YoE: filter to your experience band\n# Location: Bangalore / Mumbai / Remote / Hyderabad\n# Company size: filter appropriately (startup vs mid vs enterprise)\n\n# Step 3: Calculate your range\n# Minimum acceptable: 10% above current total compensation\n# Target: market median for your role + YoE\n# Aspirational: top 25th percentile of market range',
      ),
      ConceptLesson(
        title: 'Negotiation Language: Exact Scripts That Work',
        definition:
            'Effective negotiation uses professional, collaborative language that maintains positive tone, anchors high, and gives the recruiter a path to say yes — avoiding ultimatums, apologies, and aggressive demands that create unnecessary friction.',
        analogy:
            'Negotiation language is like a dance — you must lead without stepping on your partner. Aggressive ultimatums step on toes and end the dance. Apologetic acceptance follows the other person\'s lead entirely. Confident, collaborative language lets both parties move together toward a better outcome for both.',
        example:
            'Offer received: ₹28L base. Your target: ₹35L.\nWeak: "I was hoping for more. Can you do better?"\nAggressive: "That is below my minimum. I need ₹40L or I cannot consider this."\nStrong: "Thank you so much for this offer — I am genuinely excited about the role and the team. Based on my research into market rates for ML Engineers at this experience level in Bangalore, and the production LLM systems and RAG pipeline experience I bring, I was expecting something closer to ₹35L. Is there flexibility to get there?"\nThe strong script: expresses genuine enthusiasm, grounds the request in external data (not emotion), states the specific number clearly, and ends with a collaborative question.',
        keyTakeaway:
            'Always counter with a specific number, not a range. Saying "I am looking for ₹33-38L" tells the recruiter your target is ₹33L (they will offer the bottom of your range). Say the number you actually want. Silence after stating your number is a powerful tool — do not fill it nervously. The recruiter needs to think; let them.',
      ),
      ConceptLesson(
        title: 'Beyond Base Salary: The Complete Compensation Package',
        definition:
            'Total compensation for AI engineers includes: base salary, annual performance bonus (10-30% of base), signing bonus (often negotiable), equity (ESOPs, RSUs — often the largest component at FAANG), health insurance value, professional development budget, and remote work allowance.',
        analogy:
            'Negotiating only base salary is like evaluating a home purchase on the list price alone without considering property taxes, maintenance costs, HOA fees, and appreciation potential. Total compensation, not base salary, is the relevant metric — and some components (equity, signing bonus) are often more negotiable than base salary.',
        example:
            'AI engineer at a product company: base ₹32L looks similar to FAANG offer of ₹35L base. But FAANG total: ₹35L base + ₹5L signing + ₹8L/year performance bonus + ₹50L RSU vesting over 4 years = ₹65L+/year effective. Product company total: ₹32L + ₹3L performance bonus + ₹5L ESOPs/year = ₹40L+/year. The ₹35L base FAANG offer is actually 62% higher total compensation.',
        keyTakeaway:
            'When comparing or negotiating offers, convert everything to total annual compensation: base + expected bonus + signing bonus amortized + equity annual value. Never compare base salaries alone. In negotiations, when base salary cannot be increased, ask about signing bonus, equity acceleration, earlier review cycle, or professional development budget.',
      ),
      ConceptLesson(
        title: 'Career Growth: Promotions and Salary Increases',
        definition:
            'Career growth for AI engineers requires: delivering measurable impact (not just completing tasks), building visibility (making your work known beyond your immediate team), developing junior engineers (a requirement for senior and staff promotion), and managing up (building alignment with your manager on growth expectations).',
        analogy:
            'Getting promoted as an AI engineer is like moving from local competition to national championship — you must first demonstrate mastery at your current level (complete work excellently), then demonstrate the capabilities of the next level (own larger problems, influence others), and ensure the right people witness this demonstration (visibility with senior leadership).',
        example:
            'ML Engineer to Senior ML Engineer promotion criteria at most tech companies: technical excellence (builds systems that work in production, not just notebooks), scope expansion (owns entire ML pipeline, not just model training), cross-team influence (technical decisions affect multiple teams), mentorship (actively helps junior engineers grow), communication (presents work to leadership clearly). These are documented criteria — ask your manager for them explicitly.',
        keyTakeaway:
            'Start your promotion case file 12 months before your target promotion date. Document every project with business metrics. Explicitly discuss promotion criteria with your manager quarterly. Ask directly: "What would it look like for me to be ready for promotion in the next review cycle?" Promotions are not passively received — they are actively managed.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'A recruiter asks "What is your current salary?" before making an offer. What is the most professionally effective response in most situations?',
        options: [
          'Provide your exact current salary immediately to appear transparent',
          '"I would prefer to discuss compensation after we have confirmed the role is a strong mutual fit. I am happy to discuss my expectations once an offer is on the table." This preserves your negotiating position without revealing information that anchors the offer below market rate',
          'Refuse to answer and end the conversation',
          'Add 20% to your current salary and present that as your expectation'
        ],
        correctIndex: 1,
        explanation:
            'Revealing your current salary before an offer anchors the recruiter to your current compensation rather than the market rate for the new role — especially problematic if you are currently underpaid. Professionally deferring the discussion is standard practice and respected by experienced recruiters.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'You receive an offer of ₹30L. Your market research shows the range for this role is ₹32-42L. Which counter-offer approach is MOST effective?',
        options: [
          '"I was hoping for ₹35-42L — somewhere in that range would work" (giving a range)',
          '"Thank you for the offer. Based on my research into market rates for this role in this location and the [specific experience] I bring, I was expecting ₹38L. Is there room to get there?" (stating a specific number above your minimum, with data and enthusiasm)',
          '"Your offer is too low — I cannot accept less than ₹42L" (ultimatum at the top of range)',
          '"That sounds reasonable, but could you do a little better?" (vague request)'
        ],
        correctIndex: 1,
        explanation:
            'A specific number (₹38L) — above your minimum but within realistic range — gives the recruiter a clear target to work toward. Grounding it in market data makes it objective, not personal. Enthusiasm for the role reduces defensive reactions. Ending with a collaborative question gives them a path to yes.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'After negotiating base salary successfully (from ₹28L to ₹32L), the recruiter says "That is our final offer on base. We cannot go higher." You know from your research that signing bonuses are common at this company. What is the best next move?',
        options: [
          'Accept the offer immediately since you already got an increase',
          '"I completely understand, and I appreciate you working to get there. Would there be any flexibility on the signing bonus to bridge the gap a bit more? Even a one-time amount would mean a lot during the transition period." — shifting negotiation to a different component when one is exhausted',
          'Reject the offer and ask for more time',
          'Ask for a different job title instead of more compensation'
        ],
        correctIndex: 1,
        explanation:
            'When one compensation component is exhausted, skilled negotiators shift to others: signing bonus (one-time, easier to approve), equity accelerators, earlier performance review cycle, or professional development budget. A "no" on base salary does not mean a "no" on total compensation.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Salary Negotiation Strategy & Career Growth Plan',
      goal:
          'Build a personalized salary negotiation strategy and 5-year career growth plan with specific milestones.',
      steps: [
        'Research your target market compensation: spend 30 minutes on AmbitionBox, Glassdoor, and Levels.fyi for your target role, location, and experience level. Document the 25th, 50th, and 75th percentile total compensation.',
        'Write your negotiation script: a 3-paragraph response to receiving an offer — paragraph 1 (express genuine enthusiasm), paragraph 2 (state your counter with market data), paragraph 3 (collaborative close with a question). Keep total to under 90 seconds spoken.',
        'Identify all negotiable components beyond base salary for your target role: signing bonus, equity, performance bonus, review cycle, remote work policy, professional development budget, relocation assistance.',
        'Write your current promotion criteria: what does the next job title above yours require? Research publicly (job postings for the next level) or ask your current manager. List 5 specific criteria you need to demonstrate.',
        'Create a 12-month career growth action plan: one specific initiative per quarter that advances toward promotion or your next role target, with measurable success criteria for each.',
        'Practice your negotiation script aloud 3 times. Record once and listen for: do you sound confident? Do you state your number clearly without apology? Do you stay positive throughout?',
      ],
      expectedOutput:
          'Market comp research documented (25/50/75th percentile). Complete negotiation script written (3 paragraphs). All negotiable components listed. Promotion criteria for next level documented. 12-month career growth plan with quarterly milestones. Negotiation script practiced and recorded.',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'industry_ready_capstone_mock_interview_l10',
    topicTitle: 'Industry-Ready AI Capstone & Mock Interview',
    careerId: 'ai_engineer',
    categoryId: 'ai_data',
    difficulty: 'Expert',
    estimatedMinutes: 90,
    totalXp: 300,
    emoji: '🏆',
    intro:
        'This is it — the final capstone of the entire AI Engineer learning path. You have built the technical skills, the projects, the portfolio, the interview preparation, and the career strategy. This lesson brings everything together into a comprehensive professional package and a full mock interview experience. By the end, you will be ready to walk into any AI engineering interview with confidence.',
    concepts: [
      ConceptLesson(
        title: 'The Industry-Ready AI Engineer: Complete Profile',
        definition:
            'An industry-ready AI engineer has five verified components: a quantified, ATS-optimized resume that passes 75%+ match scores; a production-quality GitHub portfolio with 3+ documented projects; an optimized LinkedIn profile appearing in recruiter searches; practiced answers for all interview types; and a clear career strategy aligned with personal goals.',
        analogy:
            'An industry-ready AI engineer is like a professional athlete ready for the season opener — technically prepared (skills and models built), physically ready (resume and portfolio polished), mentally rehearsed (mock interviews completed), strategically positioned (target companies and roles identified), and confident from having prepared correctly rather than hoping to get lucky.',
        example:
            'The complete industry-ready profile checklist: Resume with ≥75% ATS match against target JDs. GitHub with 6 pinned repos, top 2 with demo GIFs and comprehensive READMEs. LinkedIn with optimized headline, complete skills section, 2+ recommendations. 6 behavioral STAR stories prepared and timed. 45-minute AI system design interview practiced. 10+ ML implementations from scratch ready. Target companies shortlisted with research on each. Salary range researched and negotiation script prepared.',
        keyTakeaway:
            'The difference between "prepared" and "ready" is the mock interview — practicing under realistic conditions, with timed constraints and no safety net, reveals gaps that study alone cannot. Every athlete has game-day experience before the championship. Your mock interviews are your pre-season games.',
      ),
      ConceptLesson(
        title: 'The Job Search System: From Application to Offer',
        definition:
            'An effective job search operates as a system: daily sourcing of new opportunities, weekly application batches, pipeline tracking (source → applied → phone screen → technical → offer), and A/B testing different approaches based on response rates.',
        analogy:
            'Job searching without a system is like fishing without strategy — dropping a line randomly and hoping something bites. A job search system is like commercial fishing — identifying the right waters (target companies), using the right bait (optimized resume and portfolio), fishing multiple lines simultaneously (multiple applications), and tracking what works (which sources generate interviews).',
        example:
            'Effective weekly job search system: Monday: 5 new applications from job boards (LinkedIn Jobs, Naukri, company career pages). Tuesday: 2 LinkedIn outreach messages to engineers at target companies with genuine questions. Wednesday: 1 piece of technical content shared on LinkedIn (blog post, project update). Thursday: 3 more applications + 1 follow-up on existing applications. Friday: review pipeline, update ATS tracking spreadsheet, research upcoming target companies. Total: 8 applications + outreach + content per week.',
        keyTakeaway:
            'Referrals convert at 5-10x the rate of cold applications — every month in your current role is an opportunity to build relationships that become referrals when you search. Prioritize: employee referral (highest) → inbound (recruiter contacts you) → direct company application → job board application (lowest). Invert your effort allocation to match this priority order.',
      ),
      ConceptLesson(
        title: 'Mock Interview Debrief: Converting Practice into Performance',
        definition:
            'A structured mock interview debrief extracts maximum learning from each practice session — identifying specific mistakes (not just noting "it went OK"), categorizing them by type (technical knowledge, communication, problem-solving process, behavioral depth), and creating targeted improvement actions.',
        analogy:
            'A mock interview debrief is like game film review in professional sports — the team does not just play the game and move on; coaches analyze every decision, every missed opportunity, and every successful play to extract specific, actionable improvements. The analysis is where the improvement actually happens, not just the game itself.',
        example:
            'Post-mock interview debrief framework: 1) What question types felt weakest? (technical DSA, ML implementation, system design, behavioral). 2) For each weakness: what specifically failed? (forgot complexity analysis, did not clarify requirements, ran out of behavioral depth). 3) What specific action addresses each failure? (practice 5 more DP problems, write 2 more behavioral STAR stories, read one system design case study). 4) Set a date to re-attempt similar question types.',
        keyTakeaway:
            'Do a minimum of 5 full mock interviews before your first real interview at a target company. Each mock should be with a different person if possible (a peer, a senior engineer, an interviewing coach) — different interviewers reveal different gaps. Recording mock interviews is uncomfortable but reveals habits (filler words, rushed explanations) that you cannot notice while in the moment.',
      ),
      ConceptLesson(
        title: 'The First 90 Days in a New AI Role',
        definition:
            'Successfully transitioning into a new AI engineering role requires a structured 90-day plan: first 30 days (listen and learn), days 31-60 (contribute incrementally), days 61-90 (own something end-to-end). Most engineers who fail in new roles do so by trying to contribute too aggressively too early.',
        analogy:
            'Starting a new AI engineering role is like arriving in a new city — the first month is for mapping the terrain (understand the codebase, the team dynamics, the business context). The second month is for cautious navigation (small contributions, ask before doing). The third month is for moving with confidence (own a project, demonstrate judgment independently).',
        example:
            'First 90 days action plan for ML Engineer: Days 1-30: Complete all onboarding. Read existing code and documentation. Have 1:1s with every teammate to understand their work. Ask questions constantly. Do not refactor anything. Days 31-60: Own one small, well-defined task end-to-end. Fix a non-critical bug. Improve one piece of documentation. Attend all team rituals and contribute opinions when asked. Days 61-90: Propose one small improvement with data and evidence. Take ownership of a medium-sized feature. Begin contributing to technical discussions proactively.',
        keyTakeaway:
            'The engineers who are most valued in new roles are those who deeply understand before they propose changes — not those who immediately try to impress with big ideas. Earn the right to have opinions by demonstrating that you understand the current system, its constraints, and the reasons behind decisions that might look obviously wrong from the outside.',
      ),
      ConceptLesson(
        title: 'Long-Term Career Compounding: The 10-Year Vision',
        definition:
            'Career capital in AI engineering compounds over time: skills built on skills (each level of technical depth enables the next), reputation built on reputation (each public contribution makes the next easier), and opportunities built on opportunities (each role opens doors invisible before that role).',
        analogy:
            'Career compounding is like investing in a high-growth asset — the gains in each period reinvest and generate larger gains in the next period. An AI engineer who builds consistently for 10 years with deliberate skill development, public visibility, and network investment reaches a point where opportunities come to them rather than the reverse.',
        example:
            'A career trajectory with compounding: Year 1-2: Junior ML Engineer, learning fundamentals, building portfolio. Year 3-4: ML Engineer at product company, shipping production systems, starting to write publicly. Year 5-6: Senior ML Engineer, open source contributions, conference talks, building industry network. Year 7-8: Staff/Principal ML Engineer, thought leadership in specialization, consulting opportunities, offers from frontier AI labs. Years 9-10: multiple paths open — leadership at a top company, founding an AI startup, or prestigious research role. Each stage makes the next more accessible.',
        keyTakeaway:
            'The most reliable predictor of long-term AI career success is consistent deliberate practice combined with public output — building skills in private while sharing learning publicly. The engineers you will be competing against in 5 years are building their portfolios and public profiles today. The best time to start was 5 years ago; the second best time is today.',
      ),
      ConceptLesson(
        title: 'Continuous Learning: Staying Relevant in a Fast-Moving Field',
        definition:
            'The AI field evolves faster than any other engineering discipline — frameworks from 3 years ago are obsolete, models from 2 years ago are outdated, and roles that did not exist 18 months ago are now the most in-demand. Staying relevant requires a systematic approach to continuous learning.',
        analogy:
            'Staying current in AI engineering is like maintaining a garden in a climate with rapidly changing seasons — you must continuously adapt to what is currently growing and what will be in demand next season, while maintaining the deep-rooted trees (fundamentals) that survive any seasonal change.',
        example:
            'Sustainable continuous learning system for an employed AI engineer: Daily (15 min): skim 5 headlines on AI news (Morning Brew AI edition, Hugging Face Daily Papers). Weekly (2 hours): read one paper in your specialization, implement one small experiment. Monthly (4 hours): complete one focused learning project using a new tool or technique. Quarterly (1 day): attend an AI meetup or conference. Annual (1 week): take a vacation-level deep dive into one topic that will be relevant in 2-3 years.',
        keyTakeaway:
            'The most durable investment in your AI career is not any specific framework or model architecture — it is the habit of continuous learning combined with deep fundamentals (linear algebra, probability, optimization, software engineering) that transfer across every paradigm shift. Frameworks change; fundamentals persist.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the most important thing to do in the first 30 days of a new AI engineering role?',
        options: [
          'Immediately propose improvements to the existing ML infrastructure',
          'Listen, observe, and understand before contributing — read the codebase, meet every team member, and learn the business context before suggesting any changes, no matter how obvious they may seem',
          'Demonstrate your technical superiority by solving the hardest open problem',
          'Immediately begin contributing as much code as possible to show productivity'
        ],
        correctIndex: 1,
        explanation:
            'Engineers who fail in new roles most commonly do so by proposing changes before understanding the context — there are usually very good reasons for decisions that look obviously wrong from the outside. The first 30 days are for earning the right to have opinions by demonstrating understanding first.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'In a 50-application job search, you have received only 3 phone screen responses. What is the most likely root cause and fix?',
        options: [
          'The job market is bad and nothing can be done',
          'A 6% response rate typically indicates an ATS optimization problem — your resume keywords do not match the job descriptions you are applying to. Fix: run your resume through an ATS checker against 3-5 of the JDs and improve keyword matching',
          'You need to apply to 200 more jobs immediately',
          'Your GitHub portfolio needs more repositories'
        ],
        correctIndex: 1,
        explanation:
            'A response rate below 15-20% for qualified candidates almost always indicates an application quality problem, not a market problem. The most common cause is ATS keyword mismatch. Fixing the resume for one target role type and running it through a checker typically increases response rate within the next application batch.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What single habit, if practiced consistently for 3 years, has the highest career compounding effect for an AI engineer?',
        options: [
          'Completing one new online course per month',
          'Consistently building projects AND sharing learning publicly (blog, GitHub, LinkedIn, talks) — combining private skill building with public visibility creates a compounding effect where each piece of content attracts an audience that amplifies the next piece',
          'Applying to jobs continuously regardless of the current role\'s learning opportunities',
          'Reading 5 research papers per week regardless of depth of understanding'
        ],
        correctIndex: 1,
        explanation:
            'Building in private without sharing means starting from scratch on reputation with each new opportunity. Sharing without building means empty content. Combining both compounds: skills make content credible, content attracts audience, audience brings opportunities that enable deeper skills. This flywheel effect is the most reliable career accelerant in AI engineering.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You have been in your current ML engineer role for 18 months. You feel technically stagnant — using the same tools and solving similar problems. What is the MOST strategically sound response?',
        options: [
          'Immediately quit and start a startup',
          'Have a direct conversation with your manager: "I am looking to grow into [specific next-level skill — e.g., distributed training, LLM systems]. Can we identify a project in the next quarter that would let me build that? If not, I may need to look for that growth elsewhere." This gives your current employer a chance to invest in your growth before you invest elsewhere',
          'Apply for senior roles elsewhere immediately',
          'Start learning new skills on your own time but say nothing to your employer'
        ],
        correctIndex: 1,
        explanation:
            'Direct, professional communication with your manager about growth needs gives your current employer the opportunity to provide the learning you need — which is less costly for them than losing you. It also creates a documented record of your growth requests that protects you if you later need to explain a job change.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You have completed every project in this Level 10 curriculum. A friend asks "Are you ready to start applying for AI engineering jobs?" What is the honest self-assessment framework?',
        options: [
          '"Yes — completing the curriculum means I am ready"',
          '"I should assess: Have I completed 3+ production-quality GitHub projects? Have I done 5+ mock interviews? Is my resume ATS-optimized? Have I researched my target companies? Have I practiced my behavioral stories? Yes to all 5 = ready to start applying. No to any = fix that before applying to top-tier targets"',
          '"No — I need 2 more years of study before applying"',
          '"Yes — the portfolio projects in the curriculum are enough regardless of mock interview practice"'
        ],
        correctIndex: 1,
        explanation:
            'Readiness for job applications is multidimensional. Completing curriculum is necessary but not sufficient. The 5-point readiness check covers the most common failure modes: weak portfolio, insufficient interview practice, poor resume optimization, inadequate company research, and unprepared behavioral answers.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Level 10 Capstone: Complete Industry-Ready AI Engineer Package',
      goal:
          'Complete all eight deliverables that define a fully industry-ready AI engineer, ready to apply with confidence and succeed in the full interview loop at top companies.',
      steps: [
        'PROFESSIONAL AI RESUME: Finalize your one-page AI engineer resume with ATS optimization. Run through Resume Worded or Jobscan against your top target job posting and achieve ≥75% match. All bullets follow XYZ formula. All technical skills are verifiable. GitHub and portfolio links included.',
        'OPTIMIZED LINKEDIN PROFILE: Confirm LinkedIn shows All-Star profile completeness. Headline contains target role + top 3 skills. About section contains 8+ target keywords naturally. 50 skills populated. 2+ specific recommendations. Recent technical content post live.',
        'PRODUCTION GITHUB PORTFOLIO: Confirm 6 pinned repositories. Top 2 repos have demo GIFs and comprehensive READMEs with installation instructions and metrics. Consistent commit history for the past 30 days. Portfolio website live with featured projects.',
        'COMPLETE INTERVIEW PREPARATION: Confirm written STAR stories for all 6 behavioral categories (timed at 2-2.5 min each). 45-minute AI system design document complete for one major question. 5 ML implementations from scratch working with test cases. 10+ LeetCode medium problems solved with complexity analysis.',
        'MOCK TECHNICAL INTERVIEW: Conduct a full 45-minute mock technical interview (DSA + ML implementation). Either record yourself or do it with a peer. Complete a written debrief identifying 3 specific weaknesses and 3 targeted improvements.',
        'MOCK BEHAVIORAL INTERVIEW: Conduct a full 30-minute mock behavioral interview covering 4 STAR questions and 2 questions you ask the interviewer. Complete a debrief on STAR story depth, I vs we usage, and result specificity.',
        'CAREER ROADMAP: Write your specific 5-year career roadmap with: Year 1 target role + company type, Year 2-3 target progression, Year 4-5 vision. For Year 1, list the top 5 specific companies to apply to, the role title at each, and one inside connection (or plan to make one) at each.',
        'LAUNCH PLAN: Write a 30-day job search launch plan: Week 1 (finalize all materials, apply to 5 roles), Week 2 (apply to 10 more, make 5 outreach contacts), Week 3-4 (follow up, more applications, begin interview preparation for expected callbacks). Track every application in a spreadsheet.',
      ],
      expectedOutput:
          '=== LEVEL 10 CAPSTONE: INDUSTRY-READY AI ENGINEER ===\n\n✅ RESUME: 1-page, ATS score ≥75%, XYZ bullets, GitHub + portfolio linked\n✅ LINKEDIN: All-Star level, optimized headline + skills, 2 recommendations, recent post\n✅ GITHUB: 6 pinned repos, 2 comprehensive READMEs with demo GIFs, portfolio website live\n✅ BEHAVIORAL: 6 STAR stories written + timed (all 2-2.5 min)\n✅ TECHNICAL: System design document complete, 5 ML implementations working, 10+ LeetCode solved\n✅ MOCK TECHNICAL: 45-min mock completed, debrief with 3 improvements identified\n✅ MOCK BEHAVIORAL: 30-min mock completed, debrief with specific improvements\n✅ CAREER ROADMAP: 5-year plan written, top 5 target companies identified, connections planned\n✅ LAUNCH PLAN: 30-day job search plan documented\n\n🎓 AI ENGINEER PATH COMPLETE — Level 1 through Level 10 Mastered\nYou have the skills, the portfolio, the preparation, and the strategy.\nThe next step is yours to take. Go build something amazing.',
      xpReward: 150,
    ),
  ),
];
