// ══════════════════════════════════════════════════════════════════════
// lib/data/courses/cyber_security_level_3.dart
// Cyber Security Engineer Path — LEVEL 3: Operating Systems & Linux
// Security (10 lessons)
// ══════════════════════════════════════════════════════════════════════
import '../../models/course_content_data.dart';

const List<TopicCourse> cyberSecurityLevel3 = [
  // ────────────────────────────────────────────────────────────────────
  // LESSON 1
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l3_os_fundamentals',
    topicTitle: 'Operating System Fundamentals for Security',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 185,
    emoji: '🖥️',
    intro:
        'Every application, file, and network connection runs on top of an operating system. If the OS is weak, everything above it is weak. This lesson explains what an operating system does and which parts attackers and defenders care about most.',
    concepts: [
      ConceptLesson(
        title: 'What an Operating System Does',
        definition:
            'An operating system (OS) manages hardware and provides services to programs. Its core jobs are process management, memory management, file systems, device control, and user and security management.',
        analogy:
            'The OS is the manager of a busy office building. It decides who gets which room (memory), which tasks run when (scheduling), who is allowed into which floor (permissions), and keeps the building running.',
        example:
            'Core OS functions:\n\nProcess management: runs and schedules programs\nMemory management: gives each program its own space\nFile system: organises and protects data on disk\nDevice drivers: talk to hardware\nUser management: accounts, logins, permissions\nNetworking stack: sends and receives packets\n\nCommon operating systems: Windows, Linux, macOS, Android, iOS',
        keyTakeaway:
            'The OS enforces the rules that separate users, programs, and data. Most security controls depend on it working correctly.',
      ),
      ConceptLesson(
        title: 'Kernel, User Space, and Privilege Levels',
        definition:
            'The kernel is the core of the OS with full control of hardware. Normal programs run in user space with limited rights and must ask the kernel to do sensitive things through system calls.',
        analogy:
            'Think of a bank: customers (user programs) wait outside the counter, and only staff (the kernel) can open the vault. Customers make requests, and staff decide whether to fulfil them.',
        example:
            'Privilege separation:\n\nKernel mode: full access to memory and hardware\nUser mode: restricted, each process isolated\n\nPrivileged accounts:\n  Linux: root (UID 0)\n  Windows: Administrator and SYSTEM\n\nWhy it matters:\n  A bug in a user program should not crash or take over the whole system\n  Attackers try privilege escalation: moving from a normal user to root or SYSTEM',
        keyTakeaway:
            'Most attacks have two stages: get in as a low-privilege user, then escalate. Strong privilege separation makes the second step hard.',
      ),
      ConceptLesson(
        title: 'Processes, Memory, and Files',
        definition:
            'A process is a running program. Each process has its own memory space and runs with the permissions of the user who started it. Files and directories are protected by permissions set by the OS.',
        analogy:
            'A recipe book (program) sits on the shelf. When a chef cooks from it, that is a process, working in their own kitchen space with only the ingredients they have been given access to.',
        example:
            'Security relevance:\n\nProcess isolation: one program cannot read another memory directly\nMalware often hides as a normal-looking process name\nA process runs with the rights of its owner, so a web server running as root is dangerous\nSensitive data can live in files (configs, keys) or in memory (passwords while in use)\n\nSafe habit: run services with their own low-privilege accounts.',
        keyTakeaway:
            'Running software with the lowest privilege possible limits how much damage a compromised process can do.',
      ),
      ConceptLesson(
        title: 'Why Operating Systems Get Attacked',
        definition:
            'Attackers target the OS because it controls everything above it. Common weaknesses include unpatched vulnerabilities, weak or default accounts, excess services, and misconfigured permissions.',
        analogy:
            'If a building master key can be copied easily, it does not matter how strong each room lock is. The OS holds the master keys.',
        example:
            'Typical OS weaknesses:\n\nMissing security updates\nDefault or weak passwords\nUnnecessary services running\nOverly permissive file permissions\nUsers running as administrator all the time\nNo logging or monitoring\n\nOS hardening idea:\n  Remove, restrict, update, monitor',
        keyTakeaway:
            'Most OS compromises use known weaknesses that were never fixed. Patching and hardening prevent a large share of incidents.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why do normal programs run in user space instead of kernel mode?',
        options: [
          'To make them slower',
          'So that a bug or compromise in one program cannot directly control hardware or the whole system',
          'Because the kernel cannot run programs',
          'To save electricity'
        ],
        correctIndex: 1,
        explanation:
            'Privilege separation protects the system. User programs must go through the kernel for sensitive operations, where checks can be enforced.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is privilege escalation?',
        options: [
          'Upgrading your internet plan',
          'Moving from a low-privilege account to a higher one such as root or administrator',
          'Installing more RAM',
          'Making a file smaller'
        ],
        correctIndex: 1,
        explanation:
            'After gaining a foothold, attackers try to elevate their rights to gain full control over the system.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A web server is configured to run as root. What is the main risk?',
        options: [
          'The website loads slower',
          'If the web server is compromised, the attacker immediately gets root-level control',
          'The server cannot use HTTPS',
          'There is no risk'
        ],
        correctIndex: 1,
        explanation:
            'A process runs with its owner rights. Running services as dedicated low-privilege users limits the damage of a compromise.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'An employee uses an administrator account for everyday browsing and email. What is the best improvement?',
        options: [
          'Nothing, administrators are more trusted',
          'Use a standard account day to day and elevate only when needed',
          'Share the admin password with the team',
          'Disable the password'
        ],
        correctIndex: 1,
        explanation:
            'Least privilege means a malicious download opens with standard rights, not full control of the machine.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Which of these is the most direct way to reduce OS-level risk across many machines?',
        options: [
          'Applying security updates promptly and removing unneeded services',
          'Changing the wallpaper',
          'Adding more users',
          'Turning off logging'
        ],
        correctIndex: 0,
        explanation:
            'Patching and reducing the attack surface fix the most commonly exploited weaknesses.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Know Your Own Operating System',
      goal:
          'Inspect your own computer and document its users, processes, and security basics.',
      steps: [
        'Note your OS name, version, and whether it is up to date',
        'List all local user accounts and mark which have administrator or sudo rights',
        'List the 10 processes using the most memory or CPU and identify what each one is',
        'Identify 3 services that start automatically and decide whether you really need them',
        'Check whether disk encryption and a firewall are enabled',
        'Write 3 improvements you will make to your own system and why',
      ],
      expectedOutput:
          'OS Report\n\nOS: Ubuntu 24.04, updates current\nUsers: 2 (1 sudo)\nTop processes: browser, IDE, system services — all recognised\nAuto-start services: bluetooth, cups (printing, not needed) -> disable\nDisk encryption: enabled | Firewall: off -> enable\n\nImprovements: enable firewall, disable cups, use standard account daily ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 2
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l3_linux_basics',
    topicTitle: 'Linux Basics: Filesystem & Essential Commands',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 32,
    totalXp: 195,
    emoji: '🐧',
    intro:
        'Most servers, cloud machines, and security tools run Linux, and most security jobs expect you to be comfortable on its command line. This lesson gives you the map of the filesystem and the commands you will use every day.',
    concepts: [
      ConceptLesson(
        title: 'The Linux Filesystem Layout',
        definition:
            'Linux organises everything as one tree starting at the root directory /. Standard directories have standard purposes, and security-relevant data lives in predictable places.',
        analogy:
            'Think of a well-organised building: configuration in one room, logs in another, user belongings upstairs, and temporary items in the lobby. Once you know the layout, you can find anything.',
        example:
            'Important directories:\n\n/etc     system configuration files\n/home    user home directories\n/root    home of the root user\n/var/log logs\n/tmp     temporary files (world-writable)\n/bin /usr/bin  programs\n/dev     device files\n/proc    live information about processes\n\nSecurity-relevant files:\n  /etc/passwd  user accounts\n  /etc/shadow  password hashes (root only)\n  /etc/ssh/sshd_config  SSH server settings',
        keyTakeaway:
            'Know where configuration, logs, and user data live. Investigations and hardening both start with these locations.',
      ),
      ConceptLesson(
        title: 'Navigating and Viewing Files',
        definition:
            'A handful of commands let you move around, list, read, and search files. They are the foundation of every Linux task.',
        analogy:
            'These commands are like walking around a building: where am I, what is in this room, open this document, find that file.',
        example:
            'Everyday commands:\n\npwd            show current directory\nls -la         list files with details and hidden files\ncd /var/log    change directory\ncat file.txt   print a file\nless file.txt  scroll through a file\nhead / tail    first or last lines (tail -f follows a growing log)\nfind / -name "*.conf"   search by name\ngrep "error" file.txt   search inside files\n\nHelp:\n  man ls     manual page\n  ls --help  quick help',
        keyTakeaway:
            'ls, cd, cat, less, tail, find, and grep cover most daily work. grep and tail -f are especially important for reading logs.',
        codeSnippet:
            'pwd\nls -la /etc | head\ncd /var/log\ntail -n 20 syslog\ngrep -i "failed" auth.log',
      ),
      ConceptLesson(
        title: 'Creating, Copying, and Removing Safely',
        definition:
            'Linux gives you powerful commands to create, move, and delete data. There is no recycle bin, so deletions are usually permanent and mistakes can be costly, especially as root.',
        analogy:
            'Working on the command line is like using a very sharp knife. It does exactly what you say, so measure twice and cut once.',
        example:
            'File commands:\n\nmkdir notes          create directory\ntouch a.txt          create empty file\ncp a.txt b.txt       copy\nmv a.txt docs/       move or rename\nrm a.txt             delete a file\nrm -r folder         delete a folder recursively\n\nSafe habits:\n  Use ls before rm to check what you are about to remove\n  Avoid running commands as root unless needed\n  Never paste commands you do not understand\n  Be extra careful with rm -r and wildcards',
        keyTakeaway:
            'Pause before destructive commands. Running a carelessly typed command as root is one of the most common causes of accidental data loss.',
      ),
      ConceptLesson(
        title: 'Pipes, Redirection, and Text Tools',
        definition:
            'Linux commands can be chained with pipes (|) and their output redirected to files. Combined with text tools such as grep, sort, uniq, cut, and wc, this makes powerful quick analysis of logs and data.',
        analogy:
            'A pipe is like a conveyor belt in a factory: the output of one machine becomes the input of the next.',
        example:
            'Examples:\n\ncat auth.log | grep "Failed password"         failed logins\ngrep "Failed password" auth.log | wc -l       count them\nls -l > listing.txt                          save output to a file\ncommand >> log.txt                           append to a file\nsort names.txt | uniq -c | sort -nr          count duplicates\n\nUse case: find the most frequent source of failed logins by extracting the IP column, sorting, and counting.',
        keyTakeaway:
            'Pipes turn simple tools into a log analysis toolkit. This is a core skill for SOC analysts and incident responders.',
        codeSnippet:
            'grep "Failed password" /var/log/auth.log | wc -l\n\ncut -d" " -f1 access.log | sort | uniq -c | sort -nr | head',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which directory holds most system configuration files in Linux?',
        options: ['/home', '/etc', '/tmp', '/dev'],
        correctIndex: 1,
        explanation:
            '/etc stores configuration for the system and most services, so it is central to hardening and troubleshooting.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which command shows new lines of a log file as they are written?',
        options: ['cat log', 'tail -f log', 'ls -l log', 'cp log log2'],
        correctIndex: 1,
        explanation:
            'tail -f follows a file and prints new lines as they appear, which is ideal for watching live logs.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the pipe symbol | do?',
        options: [
          'Deletes the first command output',
          'Sends the output of one command as input to the next',
          'Starts a new user session',
          'Compresses a file'
        ],
        correctIndex: 1,
        explanation:
            'A pipe connects commands so that the output of the left side becomes the input of the right side.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You want to count how many times the text "Failed password" appears in an authentication log. Which command is correct?',
        options: [
          'grep "Failed password" auth.log | wc -l',
          'ls "Failed password" auth.log',
          'cd auth.log',
          'cat "Failed password"'
        ],
        correctIndex: 0,
        explanation:
            'grep finds the matching lines and wc -l counts them. This pattern is used constantly for quick log checks.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Before deleting files matching a wildcard with rm, what is the safest habit?',
        options: [
          'Run it as root to avoid errors',
          'List the same wildcard with ls first to confirm exactly what will be removed',
          'Add -f to skip all warnings',
          'Run it twice'
        ],
        correctIndex: 1,
        explanation:
            'Previewing with ls shows precisely what will match so you do not delete something unexpected.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Linux Command Line Practice Lab',
      goal:
          'Practise core commands in a safe Linux environment such as a VM, WSL, or an online terminal.',
      steps: [
        'Set up a safe Linux environment: a VM (Ubuntu), WSL on Windows, or a free browser-based terminal',
        'Create a folder structure: lab/logs, lab/notes, lab/scripts with mkdir',
        'Create a text file with 20 fake log lines (mix of Failed and Accepted logins with made-up IPs)',
        'Use grep, wc, sort, and uniq to count failed logins and find the most frequent IP',
        'Redirect results into a report file using > and >>',
        'List 10 commands you used and what each does in a one-page cheat sheet',
      ],
      expectedOutput:
          'Practice Lab Report\n\nFolders: lab/logs, lab/notes, lab/scripts created\nSample log: 20 lines\nFailed logins: 12 | Accepted: 8\nMost frequent failing IP: 203.0.113.9 (7 times)\n\nCommands: pwd, ls, cd, cat, grep, wc, sort, uniq, mkdir, tail ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 3
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l3_users_groups_sudo',
    topicTitle: 'Users, Groups & Sudo',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 195,
    emoji: '👥',
    intro:
        'Almost every Linux security decision is about who can do what. Users, groups, and sudo are the building blocks of access control on the system. Misconfigured accounts are one of the first things attackers and auditors look for.',
    concepts: [
      ConceptLesson(
        title: 'Users, UIDs, and the Key Account Files',
        definition:
            'Every Linux user has a name and a numeric User ID (UID). Account information is stored in /etc/passwd, and password hashes are stored in /etc/shadow, which only root can read.',
        analogy:
            'The passwd file is the public staff directory, and the shadow file is the locked cabinet holding each staff member secret credentials.',
        example:
            'Important facts:\n\nUID 0 = root (all-powerful)\nUID 1-999 = usually system and service accounts\nUID 1000+ = normal human users\n\n/etc/passwd line format:\n  username:x:UID:GID:comment:home:shell\n\nService accounts often use /usr/sbin/nologin as the shell so nobody can log in as them interactively.\n\n/etc/shadow stores hashed passwords and ageing information.',
        keyTakeaway:
            'Only root should have UID 0. Any other account with UID 0 is a serious red flag during an audit.',
      ),
      ConceptLesson(
        title: 'Managing Users and Passwords',
        definition:
            'Administrators create, modify, lock, and delete accounts with standard commands. Good account lifecycle management removes access quickly when people leave.',
        analogy:
            'It is like an office reception issuing, updating, and cancelling ID cards. An unreturned old card is a security hole.',
        example:
            'Common commands (need admin rights):\n\nadduser anita          create a user\npasswd anita           set or change password\nusermod -aG docker anita   add to a group\nusermod -L anita       lock an account\nuserdel -r anita       delete user and home directory\nchage -l anita         view password ageing\n\nChecks:\n  id anita       UID, groups\n  who / w        who is logged in\n  last           login history',
        keyTakeaway:
            'Disable or remove accounts of people who have left. Dormant accounts are favourite targets because nobody notices their misuse.',
      ),
      ConceptLesson(
        title: 'Groups and Shared Access',
        definition:
            'Groups let you give the same permissions to several users at once. Each user has a primary group and can belong to additional groups.',
        analogy:
            'Instead of giving each employee a key to the finance room one by one, you give the key to the Finance team and add or remove members from the team.',
        example:
            'Group basics:\n\n/etc/group lists groups and members\ngroups anita       show a user groups\ngroupadd finance   create a group\n\nPowerful groups to watch:\n  sudo or wheel: can gain admin rights\n  docker: effectively root-equivalent on the host\n  adm: can read many system logs\n\nBest practice: give people membership only in groups they need.',
        keyTakeaway:
            'Treat membership of sudo, wheel, and docker like handing out admin keys. Review these groups regularly.',
      ),
      ConceptLesson(
        title: 'sudo and Least Privilege',
        definition:
            'sudo lets permitted users run specific commands with elevated rights while logging each use. It is safer than logging in as root because it is controlled and auditable.',
        analogy:
            'sudo is like a manager countersigning a request for a one-time special access. The action happens, and a record of who asked and what they did is kept.',
        example:
            'Using sudo:\n\nsudo apt update          run one command as root\nsudo -l                  list what you are allowed to run\nvisudo                   safely edit the sudoers file\n\nExample sudoers rule (concept):\n  anita ALL=(ALL) /usr/bin/systemctl restart nginx\n  This allows only restarting one service, not everything.\n\nBad practice:\n  NOPASSWD: ALL for everyone\n  Sharing the root password\n\nAudit trail: sudo actions are recorded in the auth log.',
        keyTakeaway:
            'Prefer narrowly scoped sudo rules over broad access, always edit with visudo, and disable direct root login over SSH.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which file stores the hashed passwords on a Linux system?',
        options: [
          '/etc/passwd',
          '/etc/shadow',
          '/etc/hosts',
          '/var/log/auth.log'
        ],
        correctIndex: 1,
        explanation:
            '/etc/shadow holds password hashes and is readable only by root, unlike /etc/passwd which is world-readable.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'During an audit you find a normal-looking user account with UID 0. What does this mean?',
        options: [
          'It is a harmless default',
          'The account has full root privileges and is a serious red flag',
          'The account is locked',
          'The account cannot log in'
        ],
        correctIndex: 1,
        explanation:
            'UID 0 grants root authority regardless of the account name. Only root should have UID 0.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is sudo generally safer than sharing the root password?',
        options: [
          'It is faster to type',
          'It is controlled per user and each use is logged',
          'It disables the firewall',
          'It removes the need for passwords'
        ],
        correctIndex: 1,
        explanation:
            'sudo provides accountability and fine-grained control, while a shared root password hides who did what.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A developer was added to the docker group "just to run containers". Why is this a security concern?',
        options: [
          'Docker is slow',
          'Docker group membership is effectively root-equivalent on the host',
          'Docker blocks the network',
          'It deletes the home directory'
        ],
        correctIndex: 1,
        explanation:
            'Users who can control the Docker daemon can mount the host filesystem and gain root-level control, so membership should be tightly limited.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'An employee left the company 6 months ago but their Linux account still works. What should be done?',
        options: [
          'Nothing, unused accounts are safe',
          'Lock or remove the account, rotate any shared secrets, and review its recent activity',
          'Change the employee name',
          'Give the account more access'
        ],
        correctIndex: 1,
        explanation:
            'Dormant accounts are a common backdoor. Offboarding should disable access immediately and check for misuse.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'User and Privilege Audit',
      goal:
          'Audit users, groups, and sudo rights on a Linux machine you own and write a findings report.',
      steps: [
        'List all accounts from /etc/passwd and separate system accounts from human users',
        'Verify only root has UID 0 (check the UID field)',
        'Check which users belong to sudo or wheel, and which to docker',
        'Review sudo rules with sudo -l and the sudoers file via visudo (read only)',
        'Check last login times with last and identify any account that has never or not recently logged in',
        'Write a findings table with: finding, risk, and recommended fix',
      ],
      expectedOutput:
          'User Audit Report\n\nAccounts: 31 total (28 system, 3 human)\nUID 0 accounts: root only ✓\nsudo members: anita, ravi\ndocker members: ravi (review)\nDormant account: testuser, last login 8 months ago\n\nFindings:\n  testuser dormant -> lock\n  ravi in docker group -> confirm need\n  NOPASSWD rule on one account -> remove ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 4
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l3_file_permissions',
    topicTitle: 'File Permissions & Ownership',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 200,
    emoji: '🔏',
    intro:
        'File permissions are the most basic and most important access control in Linux. A single wrong setting, like a world-readable private key, can expose an entire system. Learn to read and set permissions confidently.',
    concepts: [
      ConceptLesson(
        title: 'Reading Permissions: r, w, x',
        definition:
            'Each file has permissions for three classes: the owner (user), the group, and others. Each class can have read (r), write (w), and execute (x) permissions.',
        analogy:
            'Think of a document in an office: the owner can edit it, the team can read it, and everyone else cannot even open it.',
        example:
            'Output of ls -l:\n\n-rwxr-xr-- 1 anita devs 4096 Jan 10 notes.sh\n\nBreakdown:\n  -        file type (d = directory)\n  rwx      owner: read, write, execute\n  r-x      group: read, execute\n  r--      others: read only\n  anita    owner\n  devs     group\n\nMeaning on directories:\n  r: list contents\n  w: create or delete files inside\n  x: enter the directory',
        keyTakeaway:
            'Always read permissions in three blocks: owner, group, others. The "others" block is the one that exposes data to everyone.',
      ),
      ConceptLesson(
        title: 'Numeric (Octal) Permissions and chmod',
        definition:
            'Permissions can be written as numbers: read = 4, write = 2, execute = 1. Add them for each class. chmod changes permissions, and chown changes the owner and group.',
        analogy:
            'It is like scoring: read is worth 4 points, write 2, execute 1. A score of 7 means all three, 6 means read and write, 5 means read and execute.',
        example:
            'Common values:\n\n644 = rw-r--r--  normal file, others can read\n600 = rw-------  private file (keys, secrets)\n755 = rwxr-xr-x  program or public directory\n700 = rwx------  private directory\n777 = rwxrwxrwx  everyone can do everything (dangerous)\n\nCommands:\n  chmod 600 id_rsa\n  chmod u+x script.sh\n  chown anita:devs report.txt',
        keyTakeaway:
            'Avoid 777. Private keys and secrets should be 600, and files should only be as open as they must be.',
        codeSnippet:
            'chmod 600 secret.key\nchmod 755 deploy.sh\nchown anita:devs report.txt\nls -l secret.key deploy.sh report.txt',
      ),
      ConceptLesson(
        title: 'umask, Sticky Bit, SUID, and SGID',
        definition:
            'umask sets the default permissions for new files. Special bits change behaviour: SUID runs a program with its owner rights, SGID uses the group, and the sticky bit stops users deleting other users files in shared directories.',
        analogy:
            'SUID is like a special pass that lets a program act with its owner authority while it runs. Useful, but if the program has a flaw, that authority can be abused.',
        example:
            'Special bits:\n\nSUID (4000): run as file owner. Example: passwd needs to update the root-owned shadow file\nSGID (2000): run as group, or new files inherit group in a directory\nSticky (1000): in /tmp, users can delete only their own files\n\numask 022 gives:\n  new files 644, new directories 755\n\nAudit (on your own system):\n  find / -perm -4000 -type f 2>/dev/null\n  Lists SUID files. Unexpected ones deserve investigation.',
        keyTakeaway:
            'Review SUID programs regularly. Unexpected SUID binaries are a classic privilege escalation path.',
      ),
      ConceptLesson(
        title: 'Common Permission Mistakes',
        definition:
            'Many breaches start with simple permission errors: files readable by everyone that should not be, writable system files, and overly permissive web directories.',
        analogy:
            'It is like leaving the key to the safe taped to the safe door. The lock is strong, but the way it is used makes it useless.',
        example:
            'Mistakes to look for:\n\nSSH private key with 644 or 777 (SSH may refuse to use it)\nConfig files with database passwords readable by everyone\nWeb root writable by the web server user, allowing uploaded files to change the site\nScripts run by cron that are writable by other users\nHome directories with 777\n\nFixes:\n  Apply least privilege\n  Separate owners for code and for data\n  Review with find and ls -l regularly',
        keyTakeaway:
            'Secrets belong to one owner with 600 or 640 at most. If a file contains a password or key, check its permissions first.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does the permission string rwxr-x--- mean?',
        options: [
          'Owner: all, group: read and execute, others: nothing',
          'Owner: read only, group: all, others: all',
          'Everyone can write',
          'Only others can read'
        ],
        correctIndex: 0,
        explanation:
            'rwx for owner, r-x for group, and --- for others, meaning others have no access.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which permission value is best for a private SSH key file?',
        options: ['777', '644', '600', '666'],
        correctIndex: 2,
        explanation:
            '600 (rw-------) allows only the owner to read and write. SSH refuses keys that are accessible by others.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why can an unexpected SUID binary be dangerous?',
        options: [
          'It makes the disk full',
          'It runs with its owner privileges, which may allow privilege escalation if it has a flaw',
          'It disables the keyboard',
          'It changes the time zone'
        ],
        correctIndex: 1,
        explanation:
            'SUID programs execute with the file owner rights, often root. A vulnerability or misuse can lead to full system control.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A config file with the database password has permissions 644 and is in a shared server. What is the best fix?',
        options: [
          'Leave it, 644 is standard',
          'Set 600 or 640 with the correct owner and group so only the application can read it',
          'Set 777 for convenience',
          'Rename the file'
        ],
        correctIndex: 1,
        explanation:
            '644 allows every local user to read the secret. Restrict it to the owner and the needed group.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'What does chmod 750 script.sh give?',
        options: [
          'Owner rwx, group r-x, others none',
          'Owner r-x, group rwx, others none',
          'Everyone rwx',
          'Owner rw-, group r--, others r--'
        ],
        correctIndex: 0,
        explanation:
            '7 = rwx for owner, 5 = r-x for group, 0 = no permissions for others.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Permission Audit and Fix Lab',
      goal:
          'Create files with deliberately bad permissions in a practice folder, then audit and fix them.',
      steps: [
        'In a lab folder, create 6 files: a fake private key, a config with a fake password, a script, a public readme, and two others',
        'Set bad permissions on some of them (for example 777 on the key and config)',
        'Use ls -l to document each file and judge which are too open',
        'Fix each file with chmod and chown, choosing the least privilege that still works',
        'Check your default umask and explain what permissions new files get',
        'On your own system, list SUID files with find and write down any you do not recognise to research',
      ],
      expectedOutput:
          'Permission Audit\n\nBefore:\n  fake_key      777 -> too open\n  db_config.conf 666 -> exposes password\n\nAfter:\n  fake_key      600\n  db_config.conf 640 owner app, group app\n  deploy.sh     750\n  readme.txt    644\n\numask: 022 (files 644, dirs 755)\nSUID files found: passwd, sudo, mount... all expected ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 5
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l3_processes_services',
    topicTitle: 'Process & Service Management',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 195,
    emoji: '⚙️',
    intro:
        'Malware, backdoors, and cryptominers all show up as processes, services, or scheduled jobs. Knowing what normal looks like and how to inspect it lets you spot what does not belong.',
    concepts: [
      ConceptLesson(
        title: 'Viewing and Understanding Processes',
        definition:
            'A process is a running instance of a program with a process ID (PID), an owner, and resource usage. Tools like ps, top, and htop let you inspect them.',
        analogy:
            'Looking at processes is like checking who is working in an office right now, what each person is doing, and who is using too many resources.',
        example:
            'Commands:\n\nps aux            all processes with owners\nps -ef --forest   process tree (parent and child)\ntop or htop       live view of CPU and memory\npgrep nginx       find PIDs by name\nkill PID          ask a process to stop\nkill -9 PID       force stop\n\nWhat to look for:\n  Unknown process names or random strings\n  Processes running from /tmp or hidden directories\n  Very high CPU with no clear reason (possible cryptominer)\n  Unexpected parent-child relationships',
        keyTakeaway:
            'Know your normal baseline. A strange process in /tmp using 100 percent CPU deserves immediate investigation.',
      ),
      ConceptLesson(
        title: 'Services and systemd',
        definition:
            'Services (daemons) are background programs that start automatically, such as web servers or SSH. Modern Linux distributions manage them with systemd and the systemctl command.',
        analogy:
            'Services are like the permanent staff of a building: security, reception, and maintenance. They run all the time, and each extra staff member is another person who needs to be vetted.',
        example:
            'systemctl commands:\n\nsystemctl status ssh        check one service\nsystemctl list-units --type=service   running services\nsystemctl enable nginx      start at boot\nsystemctl disable cups      do not start at boot\nsystemctl stop / start / restart nginx\n\nHardening idea:\n  List what is enabled and listening\n  Disable what is not required\n  Check listening ports: ss -tulpn',
        keyTakeaway:
            'Every running service is an attack surface. If it is not needed, disable it.',
        codeSnippet:
            'systemctl list-units --type=service --state=running\nss -tulpn\nsudo systemctl disable --now cups',
      ),
      ConceptLesson(
        title: 'Scheduled Tasks and Persistence',
        definition:
            'Cron jobs and systemd timers run commands on a schedule. Attackers abuse them for persistence, which means making their access survive a reboot. Defenders review them for unexpected entries.',
        analogy:
            'A scheduled job is a recurring calendar reminder. If an intruder adds their own reminder to your calendar, the intrusion comes back even after you think you removed it.',
        example:
            'Where to look:\n\ncrontab -l           your user cron jobs\n/etc/crontab         system cron\n/etc/cron.d/ and /etc/cron.daily/\nsystemctl list-timers  systemd timers\n\nOther persistence spots to review:\n  ~/.bashrc and ~/.profile\n  authorized_keys in ~/.ssh\n  Newly created services in /etc/systemd/system\n  Unknown users and sudo rules\n\nSuspicious cron entry (concept):\n  A job that downloads and runs a script from an unknown website every minute',
        keyTakeaway:
            'After a suspected compromise, removing the malware is not enough. Check cron, services, startup files, SSH keys, and accounts for persistence.',
      ),
      ConceptLesson(
        title: 'Resource Limits and Safe Process Practice',
        definition:
            'Limiting what each service can use, and running it with the right account, reduces both accidents and attack impact.',
        analogy:
            'Giving each department a fixed budget and a limited key set means one overspending or compromised team cannot ruin the whole company.',
        example:
            'Good practice:\n\nRun each service under its own dedicated user\nUse systemd options such as NoNewPrivileges and ProtectSystem in service files\nSet resource limits to stop one service starving others\nMonitor sudden resource spikes\nKeep an inventory of what should be running on each server\n\nContainers and sandboxes add another layer of isolation.',
        keyTakeaway:
            'Isolation and least privilege for services contain the damage when one of them is compromised.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which command lets you see the running processes with their owners?',
        options: ['ps aux', 'cd /', 'mkdir proc', 'chmod 600'],
        correctIndex: 0,
        explanation:
            'ps aux lists all processes with user, PID, CPU, and memory use, which is a starting point for investigation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is it important to disable unnecessary services?',
        options: [
          'They use electricity',
          'Each running service adds attack surface and may contain vulnerabilities',
          'Linux does not allow more than 10 services',
          'Services block logging'
        ],
        correctIndex: 1,
        explanation:
            'Fewer services mean fewer potential entry points and fewer things to patch and monitor.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'An attacker adds a cron job that re-downloads a backdoor every hour. What is this technique called?',
        options: ['Persistence', 'Encryption', 'Hashing', 'Segmentation'],
        correctIndex: 0,
        explanation:
            'Persistence means making sure access survives reboots or cleanup. Scheduled tasks are a common method.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You find a process called "kworker-x" running from /tmp, using 95 percent CPU, started by a normal user. What is the best next step?',
        options: [
          'Ignore it, it looks like a system process',
          'Investigate it as suspicious: inspect its path, parent process, network connections, and isolate the machine if confirmed',
          'Restart the mouse',
          'Give it more CPU'
        ],
        correctIndex: 1,
        explanation:
            'Real kernel workers do not run from /tmp. A fake-looking name with high CPU suggests a cryptominer or malware.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'After removing a malicious process, the machine is infected again after reboot. What was most likely missed?',
        options: [
          'The persistence mechanism, such as a cron job, service, or SSH key',
          'The monitor brightness',
          'A missing printer driver',
          'The keyboard layout'
        ],
        correctIndex: 0,
        explanation:
            'Re-infection after reboot indicates a persistence mechanism that still exists. Review cron, services, startup files, and authorised keys.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Process and Persistence Review',
      goal:
          'Baseline the running processes, services, and scheduled jobs on your own Linux system.',
      steps: [
        'Record the top 15 processes from ps aux and identify each one',
        'List all running services and mark each as needed or unnecessary',
        'Use ss -tulpn to map each listening port to its service',
        'Review user cron jobs, system cron, and systemd timers; note every entry',
        'Check ~/.ssh/authorized_keys and startup files for anything you do not recognise',
        'Disable at least one unneeded service in your lab VM and confirm the change',
      ],
      expectedOutput:
          'Baseline Report\n\nProcesses: 15 identified (all standard)\nRunning services: 24 (2 unnecessary: cups, avahi) -> disabled in lab\nListening ports: 22 sshd, 631 cups (closed after disable)\nCron: 1 user job (backup script), no unknown entries\nauthorized_keys: 1 key, mine ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 6
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l3_packages_patching',
    topicTitle: 'Package Management, Patching & Software Security',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 185,
    emoji: '📦',
    intro:
        'Most successful attacks use vulnerabilities that already had patches available. Keeping software updated and installed only from trusted sources is the single most effective habit in system security.',
    concepts: [
      ConceptLesson(
        title: 'Package Managers and Repositories',
        definition:
            'A package manager installs, updates, and removes software from trusted repositories. Packages are cryptographically signed so the system can verify they were not tampered with.',
        analogy:
            'A package manager is like an official app store for your server: software comes from a vetted source with a verified seal, instead of random downloads from the internet.',
        example:
            'Common package managers:\n\nDebian / Ubuntu: apt\nRed Hat / Fedora / CentOS: dnf or yum\nArch: pacman\nAlpine: apk\n\nCommands (Ubuntu):\n  sudo apt update           refresh package lists\n  sudo apt upgrade          install available updates\n  apt list --upgradable     see pending updates\n  sudo apt install nginx    install\n  sudo apt remove nginx     remove\n\nSignature checks stop attackers from replacing packages in transit.',
        keyTakeaway:
            'Prefer official repositories. Every extra third-party source is something you must trust and keep updated.',
      ),
      ConceptLesson(
        title: 'Vulnerabilities, CVEs, and Patching',
        definition:
            'A vulnerability is a flaw in software. Public flaws get a CVE identifier (such as CVE-2021-44228) and a severity score (CVSS). A patch is the vendor fix.',
        analogy:
            'A recall notice for a car with a faulty brake: the flaw is documented publicly, and the fix is available. Driving without applying it is a risk everyone can see.',
        example:
            'Patch management cycle:\n\n1. Inventory: know what software and versions you run\n2. Monitor: follow vendor advisories and CVE feeds\n3. Prioritise: severity, exposure to the internet, and whether exploits exist\n4. Test: try patches on a staging system\n5. Deploy: roll out in a planned window\n6. Verify: confirm the vulnerable version is gone\n\nCVSS ranges: 0.1 to 3.9 Low, 4.0 to 6.9 Medium, 7.0 to 8.9 High, 9.0 to 10.0 Critical\n\nEnable unattended security updates where appropriate.',
        keyTakeaway:
            'Internet-facing systems with critical vulnerabilities come first. Speed matters because exploits are often published within days.',
      ),
      ConceptLesson(
        title: 'Safe Software Installation',
        definition:
            'Installing software from untrusted places is a common route for malware. Safe practice means verifying source, integrity, and necessity before installing anything.',
        analogy:
            'Before accepting a parcel, you check who sent it and whether you ordered it. Software deserves the same caution.',
        example:
            'Safe installation checklist:\n\nUse official repositories first\nVerify checksums or signatures of downloaded files\nBe cautious with commands that pipe a remote script straight into a shell\nAvoid cracked or pirated software\nRemove software you no longer use\nPin versions and review dependencies in your own projects\n\nSupply chain risk:\n  Compromised libraries or packages can infect many users\n  Review dependencies and use vulnerability scanners',
        keyTakeaway:
            'Never run a remote script you have not read. Verify what you install, especially on servers.',
        codeSnippet:
            'sudo apt update\napt list --upgradable\nsha256sum downloaded-file.iso\n# compare the output with the checksum published by the vendor',
      ),
      ConceptLesson(
        title: 'Vulnerability Scanning and Software Inventory',
        definition:
            'Scanners compare installed software against databases of known vulnerabilities. Regular scans and an up-to-date inventory tell you what needs fixing.',
        analogy:
            'A health check-up compares your readings with known risk ranges and tells you what needs attention before it becomes serious.',
        example:
            'Tools and ideas (use only on your own systems):\n\nOpenVAS / Greenbone: network vulnerability scanner\nLynis: Linux security auditing tool\ndebsecan or similar: lists known vulnerabilities for installed Debian packages\nTrivy: scans containers and dependencies\n\nOutput should lead to action:\n  Finding -> risk rating -> owner -> fix date -> re-scan',
        keyTakeaway:
            'A scan report that nobody acts on has no value. Track findings to closure and re-scan to confirm.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main purpose of a CVE identifier?',
        options: [
          'To make software run faster',
          'To give a publicly known vulnerability a unique, trackable ID',
          'To encrypt packages',
          'To name Linux versions'
        ],
        correctIndex: 1,
        explanation:
            'CVE IDs let everyone refer to the same vulnerability consistently across advisories, scanners, and patches.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which should be patched first?',
        options: [
          'A critical vulnerability on an internet-facing server',
          'A low-severity issue on an offline test machine',
          'A cosmetic bug in a desktop theme',
          'None, wait a year'
        ],
        correctIndex: 0,
        explanation:
            'Prioritise by severity and exposure. Critical flaws on reachable systems are the most urgent.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should you verify a downloaded installer with its published checksum?',
        options: [
          'To make the file smaller',
          'To confirm the file was not corrupted or tampered with',
          'To speed up the download',
          'To remove the need for antivirus'
        ],
        correctIndex: 1,
        explanation:
            'If the checksum matches the one from the trusted source, the file is identical to the original.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A tutorial tells you to run a command that downloads a script from an unknown website and runs it as root immediately. What is the safest approach?',
        options: [
          'Run it, tutorials are always safe',
          'Download it first, read the script, check the source reputation, and prefer official packages',
          'Run it in a hurry to save time',
          'Share it with colleagues without reading'
        ],
        correctIndex: 1,
        explanation:
            'Running unknown scripts as root gives them full control. Always inspect what you execute.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A server runs software 3 years out of date and has no update plan. What is the best first step?',
        options: [
          'Do nothing, it works',
          'Create an inventory, scan for known vulnerabilities, test updates in staging, and schedule a patch window',
          'Delete the server logs',
          'Turn off the firewall'
        ],
        correctIndex: 1,
        explanation:
            'Inventory, assess, test, and deploy is the standard patch management path. Blindly updating production can also cause outages.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Patch and Inventory Review',
      goal:
          'Review the updates and installed software of a Linux machine you own and write a patch plan.',
      steps: [
        'Run apt update and list pending upgrades (or the equivalent on your distribution)',
        'Record which pending updates are security related',
        'List installed packages and identify 5 you no longer need',
        'Look up one installed package on a public CVE database and note any known vulnerabilities for its version',
        'Verify the checksum of one downloaded file against the vendor published value',
        'Write a short patch policy: how often to check, who approves, how to test, how to roll back',
      ],
      expectedOutput:
          'Patch Review\n\nPending updates: 14 (4 security)\nUnneeded packages: 5 identified -> removed\nCVE lookup: example-package 1.2 has CVE-xxxx, fixed in 1.3 -> upgrade\nChecksum: matched ✓\n\nPatch policy: weekly check, critical within 72 hours, staging test, snapshot before update ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 7
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l3_linux_hardening',
    topicTitle: 'Linux Hardening Basics',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 34,
    totalXp: 205,
    emoji: '🧰',
    intro:
        'Hardening means reducing a system attack surface and tightening its settings so there is less to exploit. A freshly installed server is rarely secure by default. This lesson gives you a practical, repeatable hardening routine.',
    concepts: [
      ConceptLesson(
        title: 'What is Hardening and Why Use Baselines',
        definition:
            'System hardening is the process of securing a system by removing unnecessary software, closing unneeded ports, tightening permissions, and applying secure configuration. Baselines such as the CIS Benchmarks provide a trusted checklist.',
        analogy:
            'Hardening is like preparing a house before a long trip: lock every window, remove spare keys from hiding places, switch off unused utilities, and set the alarm.',
        example:
            'Hardening principles:\n\nMinimise: install only what is required\nUpdate: patch the OS and applications\nRestrict: least privilege for users and services\nHarden configuration: secure defaults\nMonitor: log and alert\nAutomate: use scripts or configuration management so servers stay consistent\n\nReferences:\n  CIS Benchmarks\n  Vendor security guides\n  Tools: Lynis for auditing',
        keyTakeaway:
            'Use a recognised baseline instead of inventing your own checklist, and automate it so every server is built the same way.',
      ),
      ConceptLesson(
        title: 'Hardening SSH',
        definition:
            'SSH is the main remote access door to Linux servers, so it is a top target for brute force attacks. Key-based authentication, disabled root login, and limited access greatly reduce the risk.',
        analogy:
            'Replacing a simple padlock with a keycard system and allowing entry only to registered staff makes the main gate far harder to break.',
        example:
            'Recommended settings in /etc/ssh/sshd_config:\n\nPermitRootLogin no\nPasswordAuthentication no   (after keys are set up and tested)\nPubkeyAuthentication yes\nAllowUsers anita ravi\nMaxAuthTries 3\nProtocol 2 (default in modern versions)\n\nAfter editing, test and reload:\n  sudo sshd -t\n  sudo systemctl reload ssh\n\nExtra measures:\n  Restrict by firewall to known IP ranges or a VPN\n  Use MFA where supported\n  Use fail2ban to block repeated failures',
        keyTakeaway:
            'Always keep a second session open while changing SSH settings so a mistake does not lock you out.',
        codeSnippet:
            '# /etc/ssh/sshd_config (excerpt)\nPermitRootLogin no\nPasswordAuthentication no\nPubkeyAuthentication yes\nMaxAuthTries 3\nAllowUsers anita ravi',
      ),
      ConceptLesson(
        title: 'Accounts, Passwords, and Kernel Settings',
        definition:
            'Hardening also covers account policy and kernel parameters: password strength and ageing, locking inactive accounts, and network-related kernel settings.',
        analogy:
            'These are the building rules: how strong visitor passes must be, when they expire, and how the entrance should behave when someone tries to tailgate.',
        example:
            'Account controls:\n\nPassword quality rules (pam_pwquality)\nPassword ageing (chage, /etc/login.defs)\nLock accounts after repeated failures\nRemove unused accounts and groups\nSet a login banner warning about authorised use\n\nKernel and network settings (sysctl), for example:\n  net.ipv4.conf.all.rp_filter = 1       reverse path filtering\n  net.ipv4.tcp_syncookies = 1           SYN flood protection\n  net.ipv4.conf.all.accept_redirects = 0\n  kernel.randomize_va_space = 2         ASLR',
        keyTakeaway:
            'Small configuration settings add real protection, such as SYN cookies against floods and ASLR that makes exploits harder.',
      ),
      ConceptLesson(
        title: 'Auditing Your Hardening with Lynis',
        definition:
            'Auditing tools check a system against best practices and produce a list of findings. Lynis is a popular open-source auditing tool for Linux.',
        analogy:
            'It is a home inspector with a checklist who walks through your system and tells you which locks are missing.',
        example:
            'Workflow (on systems you own or are authorised to audit):\n\nsudo lynis audit system\n\nReport includes:\n  Warnings: serious issues\n  Suggestions: recommended improvements\n  Hardening index: overall score\n\nProcess:\n  1. Baseline scan\n  2. Fix the highest-risk items first\n  3. Re-scan and compare the score\n  4. Document exceptions and the reason',
        keyTakeaway:
            'Hardening is a cycle: audit, fix, verify, repeat. Document any exception together with the reason and an owner.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which SSH setting prevents direct login as the root user?',
        options: [
          'PermitRootLogin no',
          'MaxAuthTries 100',
          'PasswordAuthentication yes',
          'AllowRoot true'
        ],
        correctIndex: 0,
        explanation:
            'Disabling direct root login forces attackers to guess a normal username too, and gives you per-user accountability through sudo.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is a major benefit of key-based SSH authentication over passwords?',
        options: [
          'Keys are easier to guess',
          'It removes the possibility of simple password guessing attacks',
          'It makes SSH slower',
          'It disables logging'
        ],
        correctIndex: 1,
        explanation:
            'A strong private key cannot realistically be brute forced like a weak password.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why keep a second SSH session open while you change sshd_config?',
        options: [
          'It makes the change faster',
          'So that a mistake does not lock you out of the server',
          'It is required by Linux',
          'It disables the firewall'
        ],
        correctIndex: 1,
        explanation:
            'If the new configuration breaks logins, the existing session lets you fix it.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your server auth log shows thousands of failed SSH logins for users like admin, test, and oracle. Which combination of fixes is strongest?',
        options: [
          'Keep passwords but make them shorter',
          'Key-only authentication, disable root login, allow only named users, and restrict SSH by firewall or VPN',
          'Move to a faster network',
          'Turn on more password hints'
        ],
        correctIndex: 1,
        explanation:
            'Layered controls shrink exposure: no passwords to guess, no root, a small list of allowed users, and limited sources.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Lynis reports 12 suggestions on a new server. What is the best way to proceed?',
        options: [
          'Ignore all of them',
          'Apply every change blindly in production',
          'Prioritise by risk, test changes in a lab, apply them, then re-audit',
          'Delete the report'
        ],
        correctIndex: 2,
        explanation:
            'Test changes before production, fix the highest-risk issues first, and re-scan to confirm.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Harden a Lab Linux Server',
      goal:
          'Apply a hardening checklist to a fresh Linux VM, then audit and document the improvement.',
      steps: [
        'Create a fresh Ubuntu or Debian VM and run a baseline audit (for example with Lynis) and record the score',
        'Create a non-root admin user and set up SSH key login for it',
        'Disable root SSH login and password authentication (keep a second session open and test first)',
        'Remove or disable 3 unnecessary services and packages',
        'Set a sensible password policy and enable automatic security updates',
        'Re-run the audit, compare scores, and write a short hardening report with before and after',
      ],
      expectedOutput:
          'Hardening Report\n\nBaseline hardening index: 58\nChanges:\n  Non-root admin + SSH key ✓\n  PermitRootLogin no, PasswordAuthentication no ✓\n  Disabled cups, avahi; removed telnet client ✓\n  Auto security updates enabled ✓\n  Password policy set ✓\n\nAfter hardening index: 76\nRemaining suggestions: 6 (documented with reasons) ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 8
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l3_logging_auditing',
    topicTitle: 'Logging, Auditing & Log Analysis',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 200,
    emoji: '📜',
    intro:
        'Logs are the black box recorder of a system. When something goes wrong, logs tell you who did what, when, and from where. Learning to read and protect logs is a core skill for SOC analysts and incident responders.',
    concepts: [
      ConceptLesson(
        title: 'Why Logs Matter and What to Collect',
        definition:
            'Logs are time-stamped records of events on a system. They support detection of attacks, investigation after incidents, troubleshooting, and compliance.',
        analogy:
            'Logs are CCTV footage for your computer. Without them, you only know a theft happened but not who, how, or when.',
        example:
            'Key log categories:\n\nAuthentication: logins, failures, sudo usage\nSystem: boots, service starts and stops, errors\nApplication: web server access and error logs\nNetwork and firewall: allowed and blocked connections\nSecurity tools: antivirus, IDS alerts\n\nGood logging needs:\n  Accurate time (NTP)\n  Enough detail (who, what, when, where, result)\n  Retention long enough for investigations\n  Protection from tampering',
        keyTakeaway:
            'If an attacker can delete your logs, you lose the story. Send logs to a separate, protected server.',
      ),
      ConceptLesson(
        title: 'Linux Log Locations and journalctl',
        definition:
            'Linux stores logs as text files under /var/log and, on systemd systems, also in the journal, which you read with journalctl.',
        analogy:
            'Think of /var/log as the filing cabinet of reports, and journalctl as the search desk that finds any record quickly.',
        example:
            'Important logs:\n\n/var/log/auth.log (Debian / Ubuntu) or /var/log/secure (RHEL family): logins and sudo\n/var/log/syslog or /var/log/messages: general system\n/var/log/kern.log: kernel messages\n/var/log/nginx/ or /var/log/apache2/: web server\n/var/log/wtmp and btmp: login history (read with last and lastb)\n\njournalctl examples:\n  journalctl -u ssh            one service\n  journalctl --since "1 hour ago"\n  journalctl -p err            errors only\n  journalctl -f                follow live',
        keyTakeaway:
            'Authentication logs are the first place to look when you suspect unauthorised access.',
        codeSnippet:
            'sudo grep "Failed password" /var/log/auth.log | tail\nlast -n 10\njournalctl -u ssh --since "1 hour ago"',
      ),
      ConceptLesson(
        title: 'Reading Logs for Attacks',
        definition:
            'Log analysis means looking for patterns that indicate attacks: repeated failures, logins at unusual times, new accounts, privilege changes, and unexpected outbound connections.',
        analogy:
            'A detective does not read every word of every file. They look for patterns: the same face appearing repeatedly, activity at odd hours, or something out of place.',
        example:
            'Patterns to spot:\n\nMany Failed password lines from one IP: brute force\nFailed attempts followed by one Accepted: possible successful guess\nLogin at 3 a.m. from a new country: suspicious\nA new user created, then added to sudo: possible persistence\nsudo commands that edit auth files or disable logging\nLarge numbers of 404 or 403 on a web server: scanning\n\nQuick analysis (on your own logs):\n  grep "Failed password" auth.log | awk to extract IPs | sort | uniq -c | sort -nr',
        keyTakeaway:
            'The most dangerous pattern is "many failures then a success". Always investigate what happened after a successful login.',
      ),
      ConceptLesson(
        title: 'auditd, Centralised Logging, and Windows Events',
        definition:
            'auditd is the Linux auditing framework that records detailed events such as file access and command execution. Centralised logging collects logs from many machines in one protected place, often a SIEM. Windows records similar events in the Event Log.',
        analogy:
            'auditd is a bodyguard who writes down every sensitive action. A central log server is the vault where all those notes are safely stored, away from where an intruder might shred them.',
        example:
            'auditd example (concept):\n\nWatch changes to a sensitive file:\n  auditctl -w /etc/passwd -p wa -k passwd_changes\n  ausearch -k passwd_changes\n\nCentral logging:\n  rsyslog or agents forward logs to a log server or SIEM\n  Alerts on suspicious patterns\n\nUseful Windows Event IDs:\n  4624 successful logon\n  4625 failed logon\n  4672 special privileges assigned\n  4688 new process created\n  4720 user account created',
        keyTakeaway:
            'Forward logs off the machine in real time. Local logs alone are easy for an attacker to wipe.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which log is the best first place to look for failed SSH logins on Ubuntu?',
        options: [
          '/var/log/auth.log',
          '/var/log/kern.log',
          '/etc/passwd',
          '/tmp'
        ],
        correctIndex: 0,
        explanation:
            'auth.log records authentication events, including failed and successful logins and sudo use.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why should logs be forwarded to a separate central server?',
        options: [
          'To make the system slower',
          'So an attacker who compromises one machine cannot erase the evidence',
          'To use more disk space',
          'Because logs cannot be stored locally'
        ],
        correctIndex: 1,
        explanation:
            'Central, protected storage preserves evidence even if the original machine is compromised.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which Windows Event ID indicates a failed logon?',
        options: ['4624', '4625', '4688', '4720'],
        correctIndex: 1,
        explanation:
            '4625 is a failed logon. 4624 is successful, 4688 is process creation, and 4720 is account creation.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'The auth log shows 800 failed logins for root from one IP, followed by one Accepted password for root from the same IP. What should you do?',
        options: [
          'Nothing, one success is normal',
          'Treat it as a likely compromise: isolate the host, review activity after the login, rotate credentials, and check for persistence',
          'Delete the log',
          'Reboot and continue as usual'
        ],
        correctIndex: 1,
        explanation:
            'Many failures followed by a success from the same source strongly suggests a successful brute force. Respond as an incident.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A user account was created at 3:12 a.m. and immediately added to the sudo group, by a session nobody recognises. What does this look like?',
        options: [
          'Routine maintenance',
          'Possible attacker persistence that needs investigation',
          'A printer update',
          'A harmless log glitch'
        ],
        correctIndex: 1,
        explanation:
            'New privileged accounts created at unusual times by unknown sessions are a classic persistence indicator.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Log Investigation Exercise',
      goal:
          'Analyse a sample authentication log, find an attack pattern, and write an incident summary.',
      steps: [
        'Create or download a safe sample auth log with a mix of normal and failed logins (you can generate 50 lines of fake data)',
        'Count failed logins and find the top 3 source IPs using grep, awk, sort, and uniq',
        'Find any case where failures are followed by a successful login from the same IP',
        'Check for suspicious events such as new users or sudo to unusual commands',
        'Write an incident summary: what happened, timeline, evidence, impact, and recommended actions',
        'List 5 log sources you would forward to a central server and 3 alerts you would create',
      ],
      expectedOutput:
          'Incident Summary\n\nFailed logins: 312 | Top IPs: 203.0.113.9 (240), 198.51.100.7 (50)\nSuccess after failures: 203.0.113.9 logged in as admin at 02:41\nFollow-up activity: new user backup2 created at 02:44, added to sudo\n\nRecommendation: isolate host, disable accounts, rotate credentials, block IP, harden SSH\n\nCentral logs: auth, syslog, web, firewall, DNS\nAlerts: failed login burst, new sudo user, login from new country ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 9
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l3_windows_security',
    topicTitle: 'Windows Security Fundamentals',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 200,
    emoji: '🪟',
    intro:
        'Most corporate laptops and many servers run Windows, so a security engineer must understand it as well as Linux. This lesson covers the core security features, accounts, permissions, and logs of Windows from a defender point of view.',
    concepts: [
      ConceptLesson(
        title: 'Windows Accounts, UAC, and Privilege',
        definition:
            'Windows has local accounts, domain accounts, and built-in privileged identities such as Administrator and SYSTEM. User Account Control (UAC) asks for confirmation before running tasks that need elevated rights.',
        analogy:
            'UAC is like the manager countersignature required before a sensitive action. Even if you are logged in as an administrator, you must confirm before the system changes.',
        example:
            'Key ideas:\n\nStandard user: everyday work, limited rights\nAdministrator: can change system settings\nSYSTEM: highest local authority used by the OS itself\nUAC prompts: reduce silent malware installs\nLocal Administrator Password Solution (LAPS): unique local admin passwords per machine\n\nBest practices:\n  Daily work as standard user\n  Separate admin accounts for admin work\n  Do not reuse the same local admin password everywhere',
        keyTakeaway:
            'Reusing one local administrator password across all machines lets an attacker move from one to all. Unique passwords per device stop this.',
      ),
      ConceptLesson(
        title: 'NTFS Permissions and Sharing',
        definition:
            'NTFS file permissions control access to files and folders using access control lists (ACLs). Share permissions apply when folders are shared across the network, and the more restrictive set wins.',
        analogy:
            'NTFS permissions are the locks on each room, and share permissions are the rules at the building front desk. A visitor must pass both.',
        example:
            'Common NTFS permissions:\n\nFull control, Modify, Read and execute, List folder contents, Read, Write\n\nBest practices:\n  Assign permissions to groups, not individual users\n  Use least privilege\n  Remove Everyone and overly broad group access\n  Disable inheritance only when needed and document it\n  Turn off the old SMBv1 protocol\n\nCheck effective access using the Security tab in file properties.',
        keyTakeaway:
            'Group-based permissions are easier to manage and audit. Remove access by removing the user from the group.',
      ),
      ConceptLesson(
        title: 'Built-in Protections: Defender, Firewall, BitLocker',
        definition:
            'Windows includes endpoint protection (Microsoft Defender), a host firewall, disk encryption (BitLocker), and update services. Used properly, they cover many basic needs.',
        analogy:
            'These are the standard safety features of a new car: seat belts, airbags, and ABS. They only protect you if they are switched on and kept maintained.',
        example:
            'Protections:\n\nMicrosoft Defender Antivirus and SmartScreen\nWindows Defender Firewall with profiles: Domain, Private, Public\nBitLocker: full disk encryption, protects data if a laptop is lost\nWindows Update: patches\nSecure Boot and TPM: protect the boot process\nControlled folder access: guards against ransomware changes\n\nCheck status in Windows Security settings or with PowerShell commands such as Get-MpComputerStatus.',
        keyTakeaway:
            'Verify these features are enabled on every device. A lost laptop without disk encryption is a data breach.',
      ),
      ConceptLesson(
        title: 'Windows Logs and Active Directory Basics',
        definition:
            'Windows records events in the Event Viewer under Security, System, and Application logs. In organisations, Active Directory (AD) provides central user, group, and policy management through a domain.',
        analogy:
            'Active Directory is the company HR and ID system: one place that decides who exists, what groups they belong to, and which rules apply to their devices.',
        example:
            'Event Viewer essentials:\n\n4624 successful logon | 4625 failed logon\n4672 special privileges assigned\n4688 process creation\n4720 account created | 4726 account deleted\n1102 audit log cleared (suspicious)\n\nActive Directory concepts:\n  Domain, Domain Controller, Organisational Units\n  Users, groups, and Group Policy Objects (GPOs)\n  Kerberos and NTLM authentication\n\nWhy AD is a prime target: compromise of a domain admin can mean control of the whole organisation.',
        keyTakeaway:
            'Protect domain admin accounts above all else, and alert when security logs are cleared.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the purpose of User Account Control (UAC)?',
        options: [
          'To speed up Windows',
          'To require confirmation before actions that need elevated privileges',
          'To remove all passwords',
          'To disable antivirus'
        ],
        correctIndex: 1,
        explanation:
            'UAC reduces silent privilege use, making it harder for malware to make system changes unnoticed.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which feature protects data on a laptop if it is lost or stolen?',
        options: [
          'BitLocker disk encryption',
          'Wallpaper settings',
          'Task Manager',
          'Calculator'
        ],
        correctIndex: 0,
        explanation:
            'BitLocker encrypts the drive so the data cannot be read without the key, even if the disk is removed.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Windows Event ID 1102 means the audit log was cleared. Why is this important?',
        options: [
          'It is a normal daily event',
          'Attackers often clear logs to hide activity, so it should trigger an investigation',
          'It means Windows updated',
          'It means the printer is offline'
        ],
        correctIndex: 1,
        explanation:
            'Clearing security logs is a common anti-forensics step. Unexpected clearing should raise an alert.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A company uses the same local administrator password on all 500 laptops. One laptop is compromised. What is the biggest risk?',
        options: [
          'The laptop battery drains',
          'The attacker can use the same password to take over every other laptop',
          'Wi-Fi stops working',
          'Nothing, it is isolated'
        ],
        correctIndex: 1,
        explanation:
            'Shared local admin credentials allow lateral movement. Use unique, managed passwords such as LAPS.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A shared finance folder grants Modify access to the Everyone group. What is the best fix?',
        options: [
          'Leave it, it is convenient',
          'Remove Everyone and grant access only to a Finance security group using least privilege',
          'Give Full Control to everyone',
          'Rename the folder'
        ],
        correctIndex: 1,
        explanation:
            'Broad access to sensitive data violates least privilege. Use specific groups with the minimum necessary rights.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Windows Security Checklist Audit',
      goal:
          'Audit a Windows machine you own against a security checklist and document the results.',
      steps: [
        'Check that Windows Update is current and note the last update date',
        'Confirm Microsoft Defender and the firewall are enabled for all profiles',
        'Check whether BitLocker (or device encryption) is on',
        'List local users and groups, and confirm you use a standard account daily',
        'Open Event Viewer and find examples of event IDs 4624 and 4625 in the Security log',
        'Write a one-page checklist with Pass, Fail, and Fix columns for 10 items',
      ],
      expectedOutput:
          'Windows Audit\n\nUpdates: current ✓ | Defender: on ✓ | Firewall: all profiles on ✓\nBitLocker: off -> enable\nAccounts: daily use as admin -> create standard account\nEvent Viewer: found 4625 failures after typing wrong PIN (expected)\n\nChecklist: 7 pass, 3 fail with fixes documented ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 10
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l3_host_firewall_mac',
    topicTitle: 'Host Firewalls, SELinux/AppArmor & Hardening Lab',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 40,
    totalXp: 220,
    emoji: '🧱',
    intro:
        'Even if the network firewall fails, each server should defend itself. Host firewalls and mandatory access control systems add a final layer of protection on the machine. This lesson ends the level with a hands-on hardening lab that ties everything together.',
    concepts: [
      ConceptLesson(
        title: 'Host Firewalls with UFW and nftables',
        definition:
            'A host firewall filters traffic going to and from one machine. On Ubuntu, UFW offers a simple interface on top of the underlying packet filtering (iptables or nftables). Red Hat family systems use firewalld.',
        analogy:
            'If the network firewall is the guard at the building gate, the host firewall is the lock on each apartment door. Both matter.',
        example:
            'UFW example (run on your own lab VM):\n\nsudo ufw default deny incoming\nsudo ufw default allow outgoing\nsudo ufw allow 22/tcp\nsudo ufw allow 443/tcp\nsudo ufw enable\nsudo ufw status verbose\n\nLimit brute force:\n  sudo ufw limit 22/tcp\n\nRestrict to a source:\n  sudo ufw allow from 192.168.1.0/24 to any port 22 proto tcp\n\nWarning: always allow SSH before enabling the firewall on a remote machine.',
        keyTakeaway:
            'Default deny incoming, allow only what is needed, and always keep a way to reach the machine before enabling rules remotely.',
        codeSnippet:
            'sudo ufw default deny incoming\nsudo ufw default allow outgoing\nsudo ufw allow 22/tcp\nsudo ufw enable\nsudo ufw status verbose',
      ),
      ConceptLesson(
        title: 'Intrusion Prevention with Fail2ban',
        definition:
            'Fail2ban reads logs and temporarily blocks IP addresses that show malicious behaviour, such as too many failed logins, by updating firewall rules automatically.',
        analogy:
            'It is a doorman who notices someone trying many wrong keys and tells the gate to refuse that person for a while.',
        example:
            'How it works:\n\n1. Fail2ban watches /var/log/auth.log\n2. Finds repeated failed SSH attempts from an IP\n3. Adds a firewall rule banning that IP for a set time\n\nExample settings (jail.local):\n  maxretry = 5\n  findtime = 10m\n  bantime = 1h\n\nCommands:\n  sudo fail2ban-client status sshd\n\nLimits: it slows brute force but does not replace key-based authentication or patching.',
        keyTakeaway:
            'Fail2ban is a helpful extra layer, but strong authentication is the real protection.',
      ),
      ConceptLesson(
        title: 'Mandatory Access Control: SELinux and AppArmor',
        definition:
            'Standard Linux permissions let owners decide access (discretionary control). SELinux and AppArmor add mandatory access control, where the system policy limits what each program can do, even if it runs as root.',
        analogy:
            'Normal permissions are like giving staff a key and trusting them. Mandatory access control is like the building rules that say the cleaner can only enter specific rooms, whatever keys they hold.',
        example:
            'Comparison:\n\nSELinux (Red Hat family): label-based policy, modes Enforcing, Permissive, Disabled\nAppArmor (Ubuntu, SUSE): path-based profiles, easier to learn\n\nCommands:\n  getenforce            SELinux mode\n  sestatus              details\n  sudo aa-status        AppArmor profiles\n\nBenefit:\n  If a web server is compromised, the policy can stop it from reading SSH keys or opening a shell\n\nBad habit: turning SELinux off when it blocks something. Instead read the denial and fix the policy.',
        keyTakeaway:
            'Do not disable SELinux or AppArmor to fix an error. Learn to read the denial messages and adjust the policy correctly.',
      ),
      ConceptLesson(
        title: 'Putting It Together: A Hardening Checklist',
        definition:
            'A complete host hardening routine combines everything in this level: patching, accounts, permissions, services, SSH, firewall, logging, and mandatory access control.',
        analogy:
            'Think of securing a house: windows, doors, alarm, cameras, and a neighbourhood watch. No single item is enough, but together they make an attacker give up.',
        example:
            'Linux server baseline:\n\n1. Update the OS and enable automatic security updates\n2. Create named admin users; disable root SSH login\n3. SSH keys only, restricted by AllowUsers\n4. Default-deny host firewall with minimal allow rules\n5. Remove or disable unused services and packages\n6. Fix permissions on sensitive files\n7. Enable logging and forward logs centrally\n8. Keep SELinux or AppArmor enforcing\n9. Install fail2ban for brute force protection\n10. Audit with Lynis and document exceptions\n11. Back up configuration and test restores',
        keyTakeaway:
            'Turn the checklist into a script or configuration template so every new server starts hardened.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the safest default policy for incoming traffic on a host firewall?',
        options: [
          'Allow all',
          'Deny all, then allow only what is needed',
          'Allow only HTTP',
          'Disable the firewall'
        ],
        correctIndex: 1,
        explanation:
            'Default deny incoming blocks everything not explicitly permitted, which keeps the attack surface small.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does Fail2ban do?',
        options: [
          'Encrypts the hard drive',
          'Temporarily blocks IPs that show repeated malicious behaviour such as failed logins',
          'Installs updates',
          'Deletes user accounts'
        ],
        correctIndex: 1,
        explanation:
            'Fail2ban parses logs and adds temporary firewall bans for abusive sources.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A service fails because SELinux blocks it. What is the best practice?',
        options: [
          'Disable SELinux permanently',
          'Read the denial in the audit log and adjust the policy or labels correctly',
          'Delete the service',
          'Run the service as root'
        ],
        correctIndex: 1,
        explanation:
            'Disabling mandatory access control removes a valuable protection. Understand the denial and apply the correct fix.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are configuring UFW on a remote cloud server over SSH. What must you do BEFORE enabling the firewall?',
        options: [
          'Nothing, just enable it',
          'Allow SSH (for example ufw allow 22/tcp) so you do not lock yourself out',
          'Reboot the server',
          'Delete all users'
        ],
        correctIndex: 1,
        explanation:
            'With default deny incoming, SSH would be blocked the moment the firewall is enabled unless you allow it first.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A web application is exploited, but because of AppArmor the attacker cannot read /home/admin/.ssh. What does this show?',
        options: [
          'Mandatory access control limits what a compromised program can reach, reducing the damage',
          'AppArmor is a virus',
          'SSH keys are public',
          'The web server is faster'
        ],
        correctIndex: 0,
        explanation:
            'MAC policies confine processes even when exploited, which is why they are valuable as an extra layer.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Level 3 Capstone: Secure Linux Server Build',
      goal:
          'Build and document a hardened Linux server in a VM, using the full checklist from this level.',
      steps: [
        'Create a fresh Ubuntu server VM and take a snapshot, then run a baseline audit (Lynis) and record the score',
        'Create a named admin user, set up SSH keys, and disable root login and password authentication',
        'Enable UFW with default deny incoming and allow only SSH and one web port',
        'Install and configure fail2ban for SSH, and confirm AppArmor profiles are enforcing with aa-status',
        'Disable unneeded services, apply updates, and fix permissions of one sensitive file',
        'Install a simple web server, check it is reachable only on the allowed port, then review auth and web logs',
        'Re-run the audit and write a final report: before and after, what you changed, and remaining risks',
      ],
      expectedOutput:
          'Capstone Report: Hardened Ubuntu Server\n\nBaseline hardening index: 55 | Final: 80\n\nControls:\n  Admin user + SSH keys, root login off ✓\n  UFW: deny incoming; allow 22, 443 ✓\n  Fail2ban active on sshd ✓\n  AppArmor enforcing ✓\n  Unused services disabled; updates applied ✓\n  Logs reviewed: auth.log, nginx access and error ✓\n\nRemaining risks: no central log server yet; backups not automated\n\nSnapshot taken before changes, rollback tested ✓',
      xpReward: 70,
    ),
  ),
];
