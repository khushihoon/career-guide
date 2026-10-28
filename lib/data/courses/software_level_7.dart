// ══════════════════════════════════════════════════════════════════════
// lib/models/software_courses_level7.dart
// Software Engineering Learning Path — LEVEL 7: Version Control
// ══════════════════════════════════════════════════════════════════════

import '../../models/course_content_data.dart';

const List<TopicCourse> softwareCoursesLevel7 = [
  TopicCourse(
    id: 'sep_l7_git_fundamentals',
    topicTitle: 'Git Fundamentals',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 35,
    totalXp: 220,
    emoji: '📸',
    intro:
        'Git is the version control system used by virtually every professional software team on Earth. Without Git, you cannot collaborate, cannot track what changed and why, and cannot safely experiment with new ideas. Every job description for a software engineer lists Git as a requirement. This course takes you from zero to confidently using Git in a real project.',
    concepts: [
      ConceptLesson(
        title: 'What is Version Control and Why Git?',
        definition:
            'Version control tracks every change made to your code over time, who made it, why, and when — letting you rewind to any past state, compare versions, and collaborate without overwriting each other\'s work.',
        analogy:
            'Version control is like Google Docs\'s version history, but for code — except infinitely more powerful. Without it, collaboration means emailing zip files named "project_final_v3_ACTUALLY_FINAL.zip", losing work, and having no idea what changed between versions.',
        example:
            'Without Git: "It was working yesterday — what changed??" (no way to know)\nWith Git:\n  git log  →  shows every change ever made\n  git diff →  shows exactly what changed\n  git revert → undoes any specific change safely\n  git blame → shows who wrote each line and when',
        keyTakeaway:
            'Git does not just save files — it saves the entire HISTORY of every file, forever. Every commit is a snapshot you can return to at any time. This safety net is what lets professional engineers experiment boldly.',
      ),
      ConceptLesson(
        title: 'The Three States: Working, Staging, Repository',
        definition:
            'Git has three areas: the Working Directory (your actual files), the Staging Area (changes you have selected to include in the next commit), and the Repository (permanent history of all commits).',
        analogy:
            'Think of Git like packing a suitcase for a trip: your room is the Working Directory (everything you might take), the suitcase on the bed is the Staging Area (items you have chosen to bring), and the shipped package is the Repository (what has officially been sent and recorded).',
        example:
            '# Step 1: Edit files in Working Directory (just your local files)\n# Step 2: Stage changes you want to commit\ngit add index.html       # stage one specific file\ngit add src/             # stage an entire directory\ngit add .                # stage ALL changes\n\n# Step 3: Commit staged changes to the repository\ngit commit -m "Add user login page"\n# Now this snapshot is permanently recorded',
        keyTakeaway:
            'The Staging Area is Git\'s most misunderstood feature. It lets you make multiple small, logical commits from one big working session — a professional practice that makes history clean and understandable.',
        codeSnippet:
            'git status        # see what is modified/staged\ngit add file.py   # stage specific file\ngit diff          # see unstaged changes\ngit diff --staged # see staged changes before committing\ngit commit -m "descriptive message"',
      ),
      ConceptLesson(
        title: 'Initializing and Configuring Git',
        definition:
            'git init creates a new Git repository in a folder. git config sets your identity (name and email) which is attached to every commit you make.',
        analogy:
            'git init is like setting up a new filing cabinet in your office. git config is filling out the nameplate — so every document you file is stamped with your name and contact details, making it clear who filed what.',
        example:
            '# First-time setup (do this once on any new machine)\ngit config --global user.name "Rahul Kumar"\ngit config --global user.email "rahul@example.com"\n\n# Create a new repository\nmkdir my-project\ncd my-project\ngit init        # creates a hidden .git folder\n\n# Or clone an existing repository\ngit clone https://github.com/user/repo.git',
        keyTakeaway:
            'Your name and email are embedded in EVERY commit you make — this is how teams know who wrote what. Use your professional email for work projects; it is permanently attached to your contributions.',
      ),
      ConceptLesson(
        title: 'Committing and Reading History',
        definition:
            'A commit permanently records a snapshot of staged changes with a message explaining WHY. git log shows the full history; git show and git diff let you inspect any specific commit.',
        analogy:
            'Each commit is like a dated entry in a lab notebook — not just "I changed something" but "I changed X because Y, on this date, and here is the exact before-and-after." Future engineers (including yourself) are the audience.',
        example:
            '# Bad commit messages (avoid these):\ngit commit -m "fix"\ngit commit -m "changes"\ngit commit -m "asdfjkl"\n\n# Good commit messages (do this):\ngit commit -m "Fix null pointer error in user login flow"\ngit commit -m "Add email validation to registration form"\ngit commit -m "Refactor payment service to use Strategy pattern"\n\n# Reading history\ngit log                    # full history\ngit log --oneline          # compact view\ngit show abc1234           # inspect one commit\ngit diff HEAD~1 HEAD       # compare last two commits',
        keyTakeaway:
            'Write commit messages for your team-member who is debugging at 2am. "Fix bug" is useless. "Fix race condition in session expiry when two tabs open simultaneously" is invaluable.',
      ),
      ConceptLesson(
        title: 'Undoing Changes Safely',
        definition:
            'Git provides multiple undo tools for different situations: git restore (undo unstaged changes), git reset (un-stage or un-commit locally), and git revert (safely undo a commit by creating a new inverse commit).',
        analogy:
            'Undo tools in Git are like different levels of "take-back" in a board game: restore is taking back a move you have not announced yet, reset is taking back your last turn (but only if you have not shown your cards), and revert is publicly announcing "I am undoing my last move" without hiding that it happened.',
        example:
            '# Undo changes in working directory (before staging)\ngit restore filename.py\n\n# Un-stage a file (keep changes in working directory)\ngit restore --staged filename.py\n\n# Undo last commit (keep changes staged)\ngit reset --soft HEAD~1\n\n# Undo last commit (keep changes in working directory, unstaged)\ngit reset HEAD~1\n\n# SAFELY undo a past commit (creates a new reverting commit)\ngit revert abc1234  # SAFE for shared/public branches',
        keyTakeaway:
            'NEVER use git reset --hard on commits you have already pushed to a shared branch — it rewrites history and causes problems for everyone else. Use git revert instead, which creates a new commit that undoes the old one without erasing history.',
      ),
      ConceptLesson(
        title: '.gitignore — What NOT to Track',
        definition:
            'A .gitignore file lists files and patterns that Git should never track — typically build artifacts, secret files, dependencies, and editor-specific files.',
        analogy:
            'A .gitignore is like a "do not photograph" sign at an event — certain things (your API keys, the node_modules folder with 200,000 files, your personal IDE settings) should never make it into the shared album (repository).',
        example:
            '# .gitignore file contents:\n\n# Never commit API keys or passwords\n.env\nsecrets.json\n\n# Never commit installed dependencies (easily reinstalled)\nnode_modules/\nvenv/\n__pycache__/\n*.pyc\n\n# Never commit build output\ndist/\nbuild/\n*.exe\n\n# Never commit editor settings\n.vscode/\n.idea/\n*.swp',
        keyTakeaway:
            'Accidentally committing a .env file with API keys or passwords to a public GitHub repository is a serious security incident — these secrets are immediately scraped by bots. Always .gitignore your secrets BEFORE your first commit.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What are the three main areas in Git\'s workflow?',
        options: [
          'Local, Remote, Cloud',
          'Working Directory, Staging Area, Repository',
          'Draft, Review, Published',
          'Branch, Merge, Deploy'
        ],
        correctIndex: 1,
        explanation:
            'Working Directory is your actual files. Staging Area holds changes selected for the next commit. Repository is the permanent history of all commits. Understanding these three areas is the foundation of Git.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should you use git revert instead of git reset on a branch others are using?',
        options: [
          'git revert is faster',
          'git reset rewrites history, causing conflicts for others; git revert adds a new commit that safely undoes the change without altering history',
          'git reset does not work on public branches',
          'git revert preserves file contents; git reset does not'
        ],
        correctIndex: 1,
        explanation:
            'When others have pulled your commits, resetting (rewriting) history causes their local Git to conflict with the remote. git revert creates a new commit that undoes changes without altering shared history.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why should .env files be listed in .gitignore?',
        options: [
          '.env files are too large for Git',
          '.env files typically contain API keys and passwords that would be exposed publicly if committed to a repository',
          '.env files cause Git to run slowly',
          '.env files are automatically committed anyway'
        ],
        correctIndex: 1,
        explanation:
            'Environment files contain secrets (API keys, database passwords) that must never be shared. Public repositories are scanned by bots within minutes of any secret being committed — .gitignore prevents this.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You accidentally staged a file you did not mean to include. The commit has NOT been made yet. What is the correct command?',
        options: [
          'git commit --undo',
          'git restore --staged filename',
          'git reset --hard HEAD',
          'git revert HEAD'
        ],
        correctIndex: 1,
        explanation:
            'git restore --staged filename removes the file from the staging area (un-stages it) while keeping your working directory changes intact — exactly what you need before an accidental commit.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Which is the BETTER commit message and why?\nA: "fixed stuff"\nB: "Fix crash when user submits empty cart at checkout"',
        options: [
          'A — shorter is always better',
          'B — it tells future engineers exactly what was fixed and in what context, making debugging and code review far easier',
          'A — Git has a 50 character limit so short is required',
          'Both are equally good'
        ],
        correctIndex: 1,
        explanation:
            'Good commit messages are the documentation of your codebase\'s evolution. Future engineers (and your future self) need to understand WHAT changed and WHY from the message alone, without reading the diff.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Personal Portfolio Project with Git History',
      goal:
          'Build a small project from scratch using Git properly — staged commits, meaningful messages, .gitignore, and undo operations.',
      steps: [
        'Initialize a new Git repository and configure user name/email',
        'Create a .gitignore file before any other files — include __pycache__, .env, *.pyc, and your editor\'s folder',
        'Build a small Python project (a to-do list or calculator) across at least 6 separate, meaningful commits — one feature or fix per commit',
        'Use git log --oneline to verify your clean, readable commit history',
        'Intentionally make a bad change, then use git revert to undo it cleanly (preserving history)',
        'Use git diff HEAD~2 HEAD to show a formatted summary of the last 2 commits\' changes',
      ],
      expectedOutput:
          'git log --oneline:\nabc1234 Revert "Add broken feature"\ndef5678 Add broken feature (intentional — to demonstrate revert)\n789abcd Add delete task functionality\n456def0 Add mark-complete functionality\n123abc9 Add create task functionality\n000abc1 Initial project setup with .gitignore',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'sep_l7_git_branching',
    topicTitle: 'Git Branching',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 215,
    emoji: '🌿',
    intro:
        'Branches are Git\'s killer feature — they let you work on new features or bug fixes in complete isolation without touching working code. Every professional team uses branches. Understanding branching strategy is the difference between chaotic code collisions and smooth, parallel development.',
    concepts: [
      ConceptLesson(
        title: 'What is a Branch?',
        definition:
            'A branch is a lightweight, movable pointer to a specific commit — creating a branch creates a separate line of development where you can make commits without affecting the main branch.',
        analogy:
            'A branch is like a parallel universe for your code — you can make any change you want, experiment freely, and break things completely, all without touching the original universe (main branch). If your experiment works, you merge it in. If not, you delete the branch and it is as if it never happened.',
        example:
            'main:        A --- B --- C\n                          \\\nfeature:                   D --- E --- F\n\nC is the point where you branched. D, E, F are new commits\non the feature branch. main stays at C, untouched.\n\n# Create and switch to a new branch\ngit branch feature/user-login\ngit checkout feature/user-login\n\n# Or in one command (modern Git)\ngit switch -c feature/user-login',
        keyTakeaway:
            'Branches in Git are extraordinarily cheap — they are just a pointer (40 bytes). Creating, switching, and deleting branches is nearly instantaneous. Use them freely for EVERY new feature or bug fix.',
      ),
      ConceptLesson(
        title: 'Branch Naming Conventions',
        definition:
            'Professional teams use consistent branch naming conventions to communicate intent: feature/description for new features, bugfix/description for bug fixes, hotfix/description for urgent production fixes.',
        analogy:
            'Branch naming is like labelling drawers in a shared workspace — without labels, nobody knows what is inside without opening every drawer. Clear naming conventions let any team member understand the purpose of a branch immediately.',
        example:
            '# Good branch names (follow a convention)\ngit switch -c feature/user-authentication\ngit switch -c feature/payment-integration\ngit switch -c bugfix/null-pointer-login\ngit switch -c hotfix/security-patch-cve-2024\ngit switch -c chore/update-dependencies\n\n# Bad branch names (avoid)\ngit switch -c test\ngit switch -c fixes\ngit switch -c john\ngit switch -c temp',
        keyTakeaway:
            'The feature/bugfix/hotfix prefix system is used at Google, Meta, Amazon, and most professional teams. Adopt it from day one — it signals professionalism and makes code review requests self-explanatory.',
      ),
      ConceptLesson(
        title: 'Switching Branches and Stashing',
        definition:
            'git switch changes your active branch. If you have uncommitted work, Git may refuse to switch — git stash temporarily saves your work so you can switch freely and restore it later.',
        analogy:
            'git stash is like packing your messy desk into a box before leaving the office — your work is not lost, just temporarily stored. When you return (switch back), you unpack (pop the stash) and continue exactly where you left off.',
        example:
            '# You are halfway through coding on feature/login\n# Urgent bug reported on main! Cannot switch with unsaved changes.\n\ngit stash            # Save work-in-progress\ngit switch main      # Switch to fix the bug\ngit switch -c hotfix/login-crash\n# ... fix the bug, commit ...\ngit switch feature/login  # Go back to your feature\ngit stash pop        # Restore your in-progress work',
        keyTakeaway:
            'git stash saves ALL tracked file changes (staged and unstaged) into a stack. git stash pop restores the most recent stash and removes it from the stack. git stash list shows all saved stashes.',
        codeSnippet:
            'git stash                    # Save work\ngit stash list               # Show all stashes\ngit stash pop                # Restore latest stash\ngit stash apply stash@{2}    # Restore a specific stash\ngit stash drop stash@{0}     # Delete a specific stash',
      ),
      ConceptLesson(
        title: 'Remote Branches and git push',
        definition:
            'Remote branches are versions of your branches that live on a server (GitHub, GitLab, etc.). git push uploads your local branch commits to the remote; git pull downloads and merges remote changes into your local branch.',
        analogy:
            'Local branches are like your personal notebook. Remote branches are the shared office whiteboard. push copies your notebook to the whiteboard; pull copies the whiteboard\'s latest state back to your notebook.',
        example:
            '# Push your local branch to remote for the first time\ngit push -u origin feature/user-login\n# -u sets "upstream" so future pushes just need: git push\n\n# Update remote with new local commits\ngit push\n\n# Download remote changes and merge into current branch\ngit pull\n\n# Download all remote branch info without merging\ngit fetch origin\n\n# List all branches (local and remote)\ngit branch -a',
        keyTakeaway:
            'Always git fetch before starting new work to see what teammates have pushed. git pull = git fetch + git merge. Understanding this is important when you want to inspect remote changes before merging.',
      ),
      ConceptLesson(
        title: 'Tracking and Deleting Branches',
        definition:
            'After a feature is merged, the branch should be deleted to keep the repository clean. Both the local and remote branch should be deleted.',
        analogy:
            'Deleting merged branches is like throwing away a Post-it note after completing the task written on it — the task is done and recorded in the main to-do list (history), so the note itself is just clutter.',
        example:
            '# Delete local branch (only if fully merged)\ngit branch -d feature/user-login\n\n# Force delete (even if not merged — use with caution)\ngit branch -D experiment/risky-idea\n\n# Delete remote branch\ngit push origin --delete feature/user-login\n\n# Clean up stale remote tracking references\ngit fetch --prune\n\n# List merged branches (safe to delete)\ngit branch --merged main',
        keyTakeaway:
            'A repository with 200 stale branches nobody has touched in months is a maintenance nightmare. Most teams add automatic branch deletion after merge as a project setting in GitHub/GitLab.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What does creating a new Git branch actually do at the file system level?',
        options: [
          'Copies the entire project directory',
          'Creates a lightweight 40-byte pointer to the current commit — no file copying involved',
          'Creates a new remote repository',
          'Duplicates the entire commit history'
        ],
        correctIndex: 1,
        explanation:
            'A Git branch is just a named pointer to a commit — it takes essentially no space or time to create. This is why branching is encouraged: it costs almost nothing and provides complete isolation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the purpose of git stash?',
        options: [
          'Permanently saves uncommitted changes',
          'Temporarily saves uncommitted work so you can switch branches and restore the work later',
          'Creates a new commit without a message',
          'Uploads local changes to GitHub'
        ],
        correctIndex: 1,
        explanation:
            'git stash temporarily shelves your in-progress work (without committing) so you can switch to another branch cleanly. git stash pop restores your work when you come back.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the difference between git fetch and git pull?',
        options: [
          'They are identical commands',
          'git fetch downloads remote changes without merging; git pull downloads AND merges them into your current branch',
          'git fetch only works for tags; git pull works for branches',
          'git pull is faster than git fetch'
        ],
        correctIndex: 1,
        explanation:
            'git fetch safely downloads all remote changes and branch information without touching your local working files. git pull = git fetch + git merge — it downloads and immediately integrates changes.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are working on feature/dashboard when an urgent bug is reported in production. You have unstaged changes you are not ready to commit. What is the correct sequence?',
        options: [
          'Commit your half-done work with message "WIP", switch to fix the bug',
          'git stash → git switch main → git switch -c hotfix/bug → fix and commit → git switch feature/dashboard → git stash pop',
          'Delete your feature branch and start over after fixing the bug',
          'Fix the bug directly on your feature branch and sort it out later'
        ],
        correctIndex: 1,
        explanation:
            'Stash saves your in-progress work cleanly without a messy "WIP" commit. Fix the bug on a dedicated hotfix branch. Return and pop your stash to continue exactly where you left off.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'After merging feature/payment-integration into main, what should you do with the feature branch?',
        options: [
          'Keep it forever as a record',
          'Delete both the local and remote branch — the work is preserved in main\'s history, the branch itself is now clutter',
          'Rename it to archived/payment-integration',
          'Push it to a separate backup repository'
        ],
        correctIndex: 1,
        explanation:
            'Once merged, a feature branch\'s commits live in main\'s history permanently. The branch pointer is just clutter. Delete it locally (git branch -d) and on the remote (git push origin --delete) to keep the repo clean.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Feature Branch Workflow Simulation',
      goal:
          'Simulate a professional feature branch development cycle with stashing, remote pushing, and cleanup.',
      steps: [
        'Start on main with a simple Python project already committed',
        'Create feature/add-search branch and make 3 commits implementing a search feature',
        'Simulate an urgent bug: stash your in-progress changes, switch to main, create hotfix/fix-crash, commit the fix, switch back, pop stash, and continue',
        'Push your feature branch to a remote (use a GitHub repo or simulate with a bare local repo)',
        'Verify git branch -a shows both local and remote versions of your feature branch',
        'After merging feature/add-search into main, delete both the local and remote feature branch and verify with git branch -a',
      ],
      expectedOutput:
          'git log --oneline (main after all merges):\nabc1234 Merge feature/add-search into main\ndef5678 Add search results pagination\n789abcd Add search query validation\n456def0 Add basic search endpoint\n123abc9 Merge hotfix/fix-crash into main\n000abc1 Fix crash when list is empty\n999zyx1 Initial project',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'sep_l7_merging',
    topicTitle: 'Merging',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 215,
    emoji: '🔀',
    intro:
        'Merging is how isolated work comes together — the moment your feature branch joins the main codebase. Understanding fast-forward vs three-way merges, resolving conflicts calmly and correctly, and the difference between merge and rebase is what separates engineers who struggle with Git from those who feel completely in control.',
    concepts: [
      ConceptLesson(
        title: 'Fast-Forward Merge',
        definition:
            'A fast-forward merge happens when the target branch (main) has not moved since you branched off — Git simply moves the main pointer forward to your branch tip, no merge commit needed.',
        analogy:
            'A fast-forward merge is like a train that waited at a station while you boarded — when you are ready, it simply moves forward to where you ended up, with no need to stop and negotiate which passengers to combine.',
        example:
            'main:    A --- B\n                \\\nfeature:         C --- D\n\n# Fast-forward: main moves to D, no merge commit\ngit switch main\ngit merge feature/my-work\n\n# Result:\nmain:    A --- B --- C --- D\n\n# Force a merge commit even when FF is possible:\ngit merge --no-ff feature/my-work',
        keyTakeaway:
            'Fast-forward merges produce the cleanest linear history. However, many teams use --no-ff to always create a merge commit, making it clear in the log when a feature was merged, even if no conflicts existed.',
      ),
      ConceptLesson(
        title: 'Three-Way Merge',
        definition:
            'A three-way merge is needed when both branches have new commits since the branch point — Git finds the common ancestor, then combines the changes from both sides, creating a new merge commit.',
        analogy:
            'A three-way merge is like two chefs who both modified the same recipe separately while apart — you compare both versions to the original you all started from, take each improvement, and produce a combined final recipe.',
        example:
            'main:    A --- B --- C\n              \\\nfeature:       D --- E\n\n# Three-way merge: uses A (common ancestor), C (main tip),\n# and E (feature tip) to create merge commit M\ngit switch main\ngit merge feature/my-work\n\n# Result:\nmain:    A --- B --- C --- M\n                    /\nfeature: D --- E --/',
        keyTakeaway:
            'Merge commits (M) contain exactly two parents — one from each branch being merged. This preserves the complete history of how features developed in parallel, which is valuable for understanding a codebase\'s evolution.',
      ),
      ConceptLesson(
        title: 'Merge Conflicts — What They Are',
        definition:
            'A merge conflict occurs when both branches modified the SAME lines in the SAME file in incompatible ways — Git cannot automatically decide which version is correct and marks the conflict for manual resolution.',
        analogy:
            'A merge conflict is like two people editing the same paragraph of a shared document while offline — when reconnecting, someone must read both versions and write a single paragraph that correctly incorporates both intentions.',
        example:
            '<<<<<<< HEAD (your current branch - main)\nreturn user.email.toLowerCase();\n=======\nreturn user.email.trim().toLowerCase();\n>>>>>>> feature/email-fix\n\n# HEAD section: what your branch has\n# ======= divides the two versions\n# feature/email-fix section: what is being merged in\n\n# Resolution: keep the CORRECT version (or combine both):\nreturn user.email.trim().toLowerCase();  # both changes preserved',
        keyTakeaway:
            'Conflict markers (<<<, ===, >>>) are added by Git to show you EXACTLY what conflicted. You must manually edit the file to the correct final state, then git add and git commit to complete the merge.',
      ),
      ConceptLesson(
        title: 'Resolving Conflicts Step-by-Step',
        definition:
            'Resolving conflicts has a clear 5-step process: understand both changes, decide on the correct resolution, edit the file to remove all conflict markers, stage the resolved file, and complete the merge commit.',
        analogy:
            'Resolving a conflict is like a mediator between two people who both changed a shared document — read what each person intended, understand the purpose of both changes, write the version that honours both intentions (or pick the correct one), and confirm the resolution.',
        example:
            '# 1. Git tells you there are conflicts\ngit merge feature/email-validation\n# CONFLICT (content): Merge conflict in user.py\n\n# 2. See which files have conflicts\ngit status  # shows "both modified: user.py"\n\n# 3. Open user.py and resolve ALL conflict markers manually\n#    (remove <<<<<, =====, >>>>> and keep correct code)\n\n# 4. Stage the resolved file\ngit add user.py\n\n# 5. Complete the merge\ngit commit  # Git pre-fills the merge commit message',
        keyTakeaway:
            'Use a good merge tool (VS Code has excellent built-in conflict UI, or use git mergetool) to visualize conflicts more clearly than raw text. Never leave conflict markers (<<<, ===, >>>) in committed code.',
      ),
      ConceptLesson(
        title: 'Rebase — Alternative to Merge',
        definition:
            'git rebase moves your branch\'s commits to start AFTER the latest commit on the target branch, creating a linear history without merge commits — at the cost of rewriting the rebased commits\' hashes.',
        analogy:
            'Rebase is like cutting a branch off a tree and grafting it onto a new, higher position on the trunk — it looks like the branch always grew from that higher point, even though it originally came from lower. Clean and linear, but the branch\'s history is "rewritten".',
        example:
            '# BEFORE rebase\nmain:    A --- B --- C\n              \\\nfeature:       D --- E\n\n# AFTER: git switch feature; git rebase main\nmain:    A --- B --- C\n                      \\\nfeature:               D\' --- E\'\n(D\' and E\' have new commit hashes — they are "rewritten")\n\n# Now merge into main: clean fast-forward!\ngit switch main\ngit merge feature  # fast-forward, perfectly linear history',
        keyTakeaway:
            'Golden rule: NEVER rebase commits that have been pushed to a shared remote branch — it rewrites hashes and causes serious problems for teammates who have pulled those commits. Rebase only local, unpushed commits.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'When does a fast-forward merge happen?',
        options: [
          'When there are conflicts to resolve',
          'When the target branch has not moved since you created your branch — Git simply moves the pointer forward',
          'When you use git merge --fast',
          'Only when merging into main'
        ],
        correctIndex: 1,
        explanation:
            'Fast-forward is possible when the target branch has no new commits since the branch point — the branch tip can simply be moved forward to the feature branch tip, creating no merge commit.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What causes a merge conflict?',
        options: [
          'Any time two branches are merged',
          'When both branches modified the same lines in the same file in incompatible ways that Git cannot automatically resolve',
          'When a branch is more than 100 commits behind main',
          'When commit messages are too long'
        ],
        correctIndex: 1,
        explanation:
            'Git automatically merges changes to different files or different lines in the same file. A conflict only occurs when both branches changed the SAME lines, and Git cannot determine which version (or combination) is correct.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should you NEVER rebase commits already pushed to a shared remote branch?',
        options: [
          'Rebase is slower than merge on remote branches',
          'Rebasing rewrites commit hashes — teammates who pulled those commits will have a conflicting diverged history',
          'GitHub does not support rebase operations',
          'Rebased commits lose their author information'
        ],
        correctIndex: 1,
        explanation:
            'Rebase rewrites commit hashes. If teammates pulled the original commits, their Git history diverges from the rewritten remote — causing confusion and forced pushes that overwrite others\' work.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You see this in a file after a failed merge:\n<<<<<<< HEAD\nreturn price * 1.18;\n=======\nreturn price * (1 + tax_rate);\n>>>>>>> feature/dynamic-tax\n\nWhat is the CORRECT action?',
        options: [
          'Delete all lines including both versions and leave the file empty',
          'Keep the line from HEAD only and delete the rest',
          'Understand both changes, decide the correct final code (likely return price * (1 + tax_rate)), remove ALL conflict markers, then git add and git commit',
          'Run git merge --abort and never merge again'
        ],
        correctIndex: 2,
        explanation:
            'Conflict resolution requires understanding BOTH changes. Here, the feature branch generalizes the hardcoded 18% to use a variable — likely the better version. Remove all markers, keep the correct code, stage and commit.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your feature branch is 15 commits behind main and has 5 of your own commits. You want a clean, linear history without merge commits. What should you do?',
        options: [
          'git merge main into your feature branch',
          'git rebase main while on your feature branch — this replays your 5 commits on top of the latest main',
          'Delete your branch and start over',
          'Cherry-pick each commit manually'
        ],
        correctIndex: 1,
        explanation:
            'git rebase main replays your 5 commits on top of the latest main commit, giving a clean linear history. After rebasing, merging into main becomes a simple fast-forward with no merge commit.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Merge and Conflict Resolution Workshop',
      goal:
          'Practice all merge scenarios: fast-forward, three-way, conflict resolution, and rebase.',
      steps: [
        'Set up a repository with main branch and an initial commit',
        'Create feature/a — make 2 commits. Merge into main immediately (fast-forward). Verify git log shows linear history',
        'Create feature/b (from main). Then also add a new commit to main. Merge feature/b — this forces a three-way merge. Verify the merge commit in git log --graph',
        'Create feature/c AND feature/d — both modify the same function in the same file differently. Merge feature/c first, then merge feature/d to trigger a conflict',
        'Resolve the conflict manually, stage, and complete the merge — verify no conflict markers remain in the code',
        'Create feature/e with 3 commits. Rebase it onto the latest main. Verify the clean linear history, then merge with fast-forward',
      ],
      expectedOutput:
          'git log --oneline --graph:\n* abc1234 Merge feature/d (conflict resolved correctly)\n* def5678 Merge feature/c\n*   789abcd Merge feature/b (three-way merge commit)\n|\\  \n| * 456def0 feature/b work\n* | 123abc9 Direct commit to main\n|/  \n* 000xyz1 feature/a merged (fast-forward, no merge commit)\n* 999start Initial commit',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'sep_l7_pull_requests',
    topicTitle: 'Pull Requests',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 210,
    emoji: '📋',
    intro:
        'A Pull Request (PR) is how professional teams propose, review, and discuss code changes before they are merged — making code review a central part of the development workflow. Writing good PRs and giving good code reviews are skills that directly impact your perceived seniority on any engineering team.',
    concepts: [
      ConceptLesson(
        title: 'What is a Pull Request?',
        definition:
            'A Pull Request is a proposal to merge a branch\'s changes into another branch — providing a structured place for the team to review code, ask questions, suggest improvements, and formally approve changes before merging.',
        analogy:
            'A Pull Request is like submitting an essay for peer review before it goes into a textbook — your peers read it, point out improvements, ask clarifying questions, and give a formal approval before it becomes permanent.',
        example:
            'Typical PR Workflow:\n1. Push feature/user-auth branch to remote\n2. Open PR: "Add user authentication"\n3. Write description: what does this do? why? how to test?\n4. Assign reviewers from your team\n5. Reviewers read code, leave comments, request changes\n6. You address feedback with new commits\n7. Reviewer approves\n8. PR merged into main (protected branch)\n9. Feature branch automatically deleted',
        keyTakeaway:
            'PRs are not just a formality — they are the primary mechanism for knowledge transfer, catching bugs before production, and maintaining code quality over time.',
      ),
      ConceptLesson(
        title: 'Writing an Excellent PR Description',
        definition:
            'A great PR description explains WHAT the change does, WHY it is needed, HOW it was implemented, HOW to test it, and any important trade-offs or known limitations.',
        analogy:
            'A PR description is like a doctor\'s chart before surgery — the surgeon (reviewer) needs to know: what procedure (what), why the patient needs it (why), how you plan to perform it (how), and any complications to watch for (risks/trade-offs).',
        example:
            '## What does this PR do?\nAdds email + password authentication with JWT tokens.\n\n## Why is this needed?\nCurrently the app has no authentication. Users can access\nany endpoint without logging in. (Fixes #123)\n\n## How to test\n1. POST /api/auth/register with email+password\n2. POST /api/auth/login — should receive JWT token\n3. Access /api/profile with token in Authorization header\n4. Access /api/profile WITHOUT token — should get 401\n\n## Notes\n- Passwords hashed with bcrypt (12 rounds)\n- JWT expires in 24 hours — refresh flow is a separate PR',
        keyTakeaway:
            'A PR description that requires the reviewer to read every line of code to understand the change is inconsiderate. Give reviewers the context to do a focused, thorough review efficiently.',
      ),
      ConceptLesson(
        title: 'Giving Constructive Code Reviews',
        definition:
            'A good code review is specific (not vague), explains WHY a change is suggested (not just what), distinguishes must-fix from nice-to-have, and assumes positive intent — reviewing the code, not the person.',
        analogy:
            'Code review is like editing a colleague\'s report: highlight specific sentences, explain why the suggestion improves clarity, and distinguish "this sentence is factually wrong" (must fix) from "this word choice might be clearer" (optional).',
        example:
            '# Unhelpful review comments:\n"This is wrong."\n"Bad naming."\n"Why did you write it this way?"\n\n# Helpful review comments:\n"[Must Fix] This will cause a null pointer if user is not\nauthenticated. Add a null check before accessing user.email.\nSee how we handle this in AuthService.java:45"\n\n"[Nit] Consider naming this `isEmailValid` instead of\n`checkEmail` — the is/has prefix makes boolean functions\nclearer to read. No blocker on this one."',
        keyTakeaway:
            'Label comments as [Must Fix], [Suggestion], or [Nit] (nitpick) — this makes it immediately clear to the author what is blocking approval and what is optional feedback.',
      ),
      ConceptLesson(
        title: 'Responding to Code Review Feedback',
        definition:
            'Responding to reviews professionally means addressing every comment (either with a code change or a reasoned explanation), not taking feedback personally, and asking for clarification when a comment is unclear.',
        analogy:
            'Responding to code review is like a student responding to essay feedback — you address each comment thoughtfully, explain your reasoning when you disagree respectfully, and thank reviewers for their time and expertise.',
        example:
            '# On a comment saying "refactor this into a helper function":\n\n# Option A: Agree and do it\ngit commit -m "Refactor email validation into helper per review"\n# Reply on PR: "Good point — extracted to validateEmail() helper.\n# See latest commit."\n\n# Option B: Disagree respectfully with reasoning\n# Reply: "I considered extracting this, but this validation\n# is unique to this endpoint (validates domain against whitelist\n# only used here). Extracting would make it look reusable when\n# it is not. Happy to discuss further if you disagree."',
        keyTakeaway:
            'Every review comment deserves a response — silence is unprofessional. Either resolve it or explain why you disagree. Reviewers who see their comments silently ignored stop reviewing carefully.',
      ),
      ConceptLesson(
        title: 'Protected Branches and Merge Requirements',
        definition:
            'Protected branches (like main) are configured in GitHub/GitLab to REQUIRE certain conditions before merging: code review approvals, CI tests passing, and no unresolved conflicts.',
        analogy:
            'A protected branch is like a bank vault — only those with proper authorization (approved PR) and after the security system clears (CI tests pass) can access it. Random people cannot just walk in with code.',
        example:
            'Common branch protection rules (set in GitHub Settings):\n✓ Require 1 or more approving reviews\n✓ Dismiss stale reviews when new commits are pushed\n✓ Require status checks to pass (CI/CD pipeline)\n✓ Require branches to be up to date before merging\n✓ Restrict who can push directly to main\n✓ Restrict who can merge\n✓ Require linear history (no merge commits)',
        keyTakeaway:
            'Branch protection is not about distrust — it is about preventing accidents. Even the most senior engineer should not be able to push broken code to production directly. The protection rules ensure the process is followed every time.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the primary purpose of a Pull Request?',
        options: [
          'To automatically deploy code to production',
          'To propose merging a branch\'s changes and provide a structured place for team code review and discussion before merging',
          'To create a backup of the current codebase',
          'To notify the team that you are working on a feature'
        ],
        correctIndex: 1,
        explanation:
            'PRs are the code review mechanism — they create a dedicated space to inspect proposed changes, discuss them, request improvements, and formally approve before any changes reach the main branch.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'When giving a code review, what makes the comment "This is wrong" unhelpful?',
        options: [
          'It is too short',
          'It is vague — it does not explain what specifically is wrong, why it is wrong, or how to fix it',
          'Code reviews should not point out errors',
          'It should be said in person, not written'
        ],
        correctIndex: 1,
        explanation:
            'Effective review comments are specific (what exactly is wrong), educational (why it is a problem), and actionable (how to fix it). "This is wrong" fails all three criteria.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does "branch protection" on main typically enforce?',
        options: [
          'Only the repository owner can see the main branch',
          'Required code review approvals and CI status checks before any PR can be merged into main',
          'All commits must be cryptographically signed',
          'The branch cannot be deleted'
        ],
        correctIndex: 1,
        explanation:
            'Branch protection rules prevent direct pushes to main and require passing CI checks plus at least one reviewer approval before merging — ensuring code quality and process compliance.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A reviewer leaves a comment: "[Nit] Consider using a list comprehension here instead of a for loop." What does [Nit] signal and how should you respond?',
        options: [
          '[Nit] means must-fix — update immediately',
          '[Nit] means nitpick — optional feedback. You can accept it, decline with reasoning, or acknowledge and defer to a follow-up PR — it is not blocking approval',
          '[Nit] means the reviewer is being negative',
          'Ignore [Nit] comments entirely'
        ],
        correctIndex: 1,
        explanation:
            '[Nit] or [Nitpick] signals optional style feedback that does not block merging. You should still respond (acknowledging you saw it) but can decide whether to implement it now or later based on scope and effort.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your PR is approved and you are about to merge, but your branch is 20 commits behind main. What should you do first?',
        options: [
          'Merge anyway — the approval covers the current state',
          'Update your branch (rebase or merge main into your branch), ensure tests still pass, then merge — stale branches can introduce unexpected conflicts into main',
          'Ask the reviewer to re-approve after updating',
          'Delete and recreate the branch from main'
        ],
        correctIndex: 1,
        explanation:
            'Most teams require branches to be up-to-date before merging (enforced by branch protection). Updating your branch first ensures your tested code reflects the current state of main, preventing last-minute integration bugs.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Complete PR Lifecycle Simulation',
      goal:
          'Simulate the complete Pull Request workflow from branch creation to merge, including a proper review cycle.',
      steps: [
        'Create a feature branch (feature/add-search) and implement a search feature across 4 well-named commits',
        'Write a complete PR description template covering: What, Why, How to Test, and Notes/Trade-offs',
        'Simulate receiving a code review with 3 types of comments: one Must Fix, one Suggestion, one Nit',
        'Address the Must Fix with a new commit, respond to the Suggestion with a reasoned explanation, and acknowledge the Nit',
        'Demonstrate updating a branch that has fallen behind main (rebase or merge main in)',
        'Document what branch protection rules you would set on main for a 5-person team and why',
      ],
      expectedOutput:
          'PR Description: Covers What/Why/How-to-test/Notes ✓\nReview responses:\n  [Must Fix] addressed in commit abc1234\n  [Suggestion] declined with reasoning: "..."  \n  [Nit] acknowledged, deferred to follow-up PR\nBranch updated to latest main ✓\nBranch protection config documented:\n  - 1 required approval\n  - CI must pass\n  - Up-to-date required\n  - Direct push to main restricted',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'sep_l7_github_collaboration',
    topicTitle: 'GitHub Collaboration',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 210,
    emoji: '🤝',
    intro:
        'GitHub is where the world\'s software is built — from personal projects to the Linux kernel. Understanding GitHub\'s collaboration features (Issues, Projects, Actions, Forks) is essential for contributing to open source, working on a team, and building a professional engineering portfolio that hiring managers actually look at.',
    concepts: [
      ConceptLesson(
        title: 'GitHub Issues — Tracking Work',
        definition:
            'GitHub Issues are the task tracking system built into every repository — used to report bugs, request features, ask questions, and track all planned work with labels, assignees, and milestones.',
        analogy:
            'GitHub Issues are like sticky notes on a shared project board that the entire team can see, discuss, assign to people, and check off when done — but with a full conversation thread, links to related code, and permanent searchable history.',
        example:
            '# Good bug report Issue:\nTitle: "Login crashes with 500 error when email contains + character"\n\nSteps to reproduce:\n1. Go to /login\n2. Enter email: user+tag@example.com\n3. Click Login\n\nExpected: Login succeeds\nActual: 500 Internal Server Error\n\nEnvironment: Chrome 125, macOS 14.2, Production\n\nLabels: bug, priority-high\nAssigned to: @rahul',
        keyTakeaway:
            'Linking commits and PRs to Issues (using "Fixes #123" in a PR description) automatically closes the Issue when the PR is merged — creating a clear record of what work addressed what problem.',
      ),
      ConceptLesson(
        title: 'Forking and Contributing to Open Source',
        definition:
            'Forking creates your own copy of someone else\'s repository under your account — the standard workflow for contributing to projects you do not have write access to.',
        analogy:
            'Forking is like getting a legal copy of an architect\'s blueprints so you can make your own modifications — you do your work on your copy, then formally propose your changes back to the original architect for consideration.',
        example:
            '# Standard open source contribution workflow:\n1. Fork the repo on GitHub (creates your-username/project)\n2. Clone YOUR fork locally\n   git clone https://github.com/your-username/project\n3. Add the original as "upstream"\n   git remote add upstream https://github.com/original-org/project\n4. Create a feature branch, make changes, commit\n5. Push to YOUR fork\n   git push origin feature/my-fix\n6. Open a PR from your fork to the original repo\n7. Keep your fork updated:\n   git fetch upstream && git merge upstream/main',
        keyTakeaway:
            'Your GitHub profile and your contributions to real open-source projects are more valuable than a resume in many engineering hiring processes. Every merged PR to a notable project is a permanent, verifiable credential.',
      ),
      ConceptLesson(
        title: 'GitHub Actions — Automated CI/CD',
        definition:
            'GitHub Actions is a built-in automation platform that runs workflows triggered by events (push, PR opened, schedule) — used for running tests, linting, building, and deploying code automatically.',
        analogy:
            'GitHub Actions is like a robot that watches your repository and automatically performs tasks whenever something happens — every time someone pushes code, the robot instantly runs all tests, checks formatting, and reports back with a green checkmark or red X.',
        example:
            '# .github/workflows/tests.yml\nname: Run Tests\n\non:\n  push:\n    branches: [main]\n  pull_request:\n    branches: [main]\n\njobs:\n  test:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v4\n      - name: Set up Python\n        uses: actions/setup-python@v5\n        with:\n          python-version: "3.11"\n      - name: Install dependencies\n        run: pip install -r requirements.txt\n      - name: Run tests\n        run: pytest',
        keyTakeaway:
            'CI (Continuous Integration) with GitHub Actions means every single PR automatically has all tests run. A PR cannot be merged if tests fail — this is one of the most impactful quality practices any team can adopt.',
      ),
      ConceptLesson(
        title: 'GitHub Projects and Milestones',
        definition:
            'GitHub Projects is a built-in Kanban/Scrum board for tracking Issues and PRs across a sprint or milestone. Milestones group Issues around a release or deadline.',
        analogy:
            'GitHub Projects is like a physical Kanban board that automatically moves sticky notes as you update Issues — "Bug: login crash" moves from "To Do" to "In Progress" when assigned, then to "Done" when the fixing PR is merged.',
        example:
            'Project board columns:\nBacklog | To Do | In Progress | Review | Done\n\nMilestone: v2.0 Release (Due: July 15)\n  Issue #45: Add payment integration\n  Issue #52: Update user dashboard\n  Issue #61: Fix export bug\n  Issue #70: Performance improvements\n\nProgress: 2/4 issues closed (50%)',
        keyTakeaway:
            'In a job interview, being able to say "we tracked work with GitHub Projects, closed ~20 issues per sprint, and released every 2 weeks" demonstrates genuine professional engineering workflow experience.',
      ),
      ConceptLesson(
        title: 'Building a Professional GitHub Profile',
        definition:
            'Your GitHub profile is your engineering portfolio — hiring managers check it directly. A strong profile has: a complete README, pinned repositories with good documentation, consistent contribution activity, and contributions to open source.',
        analogy:
            'Your GitHub profile is like a live portfolio website that updates itself as you work — every commit, every PR, every repository is a piece of evidence of your skills and work ethic, visible to any hiring manager worldwide.',
        example:
            'Profile essentials:\n✓ Profile README.md: who you are, what you build, tech stack\n✓ Pinned repos: 4-6 of your best projects with clear READMEs\n✓ Green contribution graph: consistent activity shows reliability\n✓ Stars and forks on your projects: others find them useful\n✓ Open source contributions: PRs merged to real projects\n\nFor each pinned repo:\n✓ Clear README: what it does, tech stack, screenshots, how to run\n✓ Proper .gitignore, requirements.txt/package.json\n✓ Meaningful commit history (not "fix", "changes", "asdf")',
        keyTakeaway:
            'Many companies have moved away from homework assignments in interviews — they look at GitHub instead. A strong GitHub profile with 3-4 well-documented projects is more powerful than most resumes.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the purpose of forking a repository on GitHub?',
        options: [
          'To delete the original repository',
          'To create your own copy of a repository under your account, enabling you to propose changes via PR without needing write access to the original',
          'To merge two repositories together',
          'To make a repository private'
        ],
        correctIndex: 1,
        explanation:
            'Forking is the standard open-source contribution model: you fork to your account, make changes, then open a PR from your fork back to the original. You never need write access to the original project.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What triggers a GitHub Actions workflow in a typical CI setup?',
        options: [
          'Only manual triggers by the repository owner',
          'Events like push to main or a pull request being opened — automatically running tests and checks without human intervention',
          'A nightly schedule only',
          'Only when a release is published'
        ],
        correctIndex: 1,
        explanation:
            'GitHub Actions workflows are triggered by repository events — push, pull_request, schedule, release, etc. For CI, the most common triggers are push to main and pull_request, ensuring every change is automatically tested.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Using "Fixes #45" in a PR description does what when the PR is merged?',
        options: [
          'Nothing — it is just a comment',
          'Automatically closes Issue #45 and links the PR to it, creating a clear record of what code addressed what problem',
          'Reopens Issue #45 for further work',
          'Notifies only the issue author'
        ],
        correctIndex: 1,
        explanation:
            'GitHub recognises keywords like "Fixes #45", "Closes #123", "Resolves #78" in PR descriptions — automatically closing the referenced Issue when the PR is merged and creating a permanent link between the problem and the solution.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You find a bug in a popular open-source Python library on GitHub. You do not have write access. What is the correct process to submit a fix?',
        options: [
          'Email the maintainer with your changes as a zip file',
          'Fork the repo → clone your fork → create a branch → fix the bug → push to your fork → open a PR from your fork to the original repo',
          'Create a new repository with your fixed version and announce it',
          'You cannot contribute without write access'
        ],
        correctIndex: 1,
        explanation:
            'Fork → Branch → Fix → Push → PR is the universal open-source contribution workflow. Your fork gives you write access to your own copy, and the PR proposes your changes back to the maintainers of the original.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A GitHub Actions workflow runs tests on every PR, but a developer pushed directly to main bypassing the CI check. Which GitHub feature prevents this?',
        options: [
          'Issue labels',
          'Branch protection rules on main — requiring status checks (CI) to pass before any merge or direct push is allowed',
          'GitHub Projects board',
          'Repository archiving'
        ],
        correctIndex: 1,
        explanation:
            'Branch protection with "Require status checks to pass before merging" blocks direct pushes and PRs until the specified GitHub Actions checks complete successfully — no bypassing allowed, even for admins (with the right settings).',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Open Source Ready Project',
      goal:
          'Set up a complete professional GitHub project with Issues, CI workflow, branch protection, and portfolio-ready documentation.',
      steps: [
        'Create a GitHub repository for your to-do or calculator project from earlier in this level',
        'Write a comprehensive README.md: project description, tech stack, screenshots (or output examples), installation steps, usage guide, contributing guide',
        'Create a .github/workflows/tests.yml GitHub Actions CI workflow that runs your tests on every push and PR',
        'Set up branch protection on main: require 1 approval, require CI to pass, no direct push',
        'Create 3 GitHub Issues for future improvements, apply labels (enhancement, bug, documentation)',
        'Create a simple GitHub Project board with columns (Backlog, In Progress, Done) and add your Issues to it',
      ],
      expectedOutput:
          'README: Professional with description, setup, usage ✓\nCI Workflow: Tests run automatically on push/PR ✓\nBranch protection: Direct push to main blocked ✓\nIssues: 3 created with labels and milestone ✓\nProject board: Issues visible on Kanban board ✓\nRepository ready for open-source contributions ✓',
      xpReward: 55,
    ),
  ),
];
