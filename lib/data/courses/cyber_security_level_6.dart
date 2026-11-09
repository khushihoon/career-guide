// ══════════════════════════════════════════════════════════════════════
// lib/data/courses/cyber_security_level_6.dart
// Cyber Security Engineer Path — LEVEL 6: Web Application &
// Application Security (10 lessons)
// ══════════════════════════════════════════════════════════════════════
import '../../models/course_content_data.dart';

const List<TopicCourse> cyberSecurityLevel6 = [
  // ────────────────────────────────────────────────────────────────────
  // LESSON 1
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l6_web_security_basics',
    topicTitle: 'How the Web Works: HTTP, Cookies, Sessions & Browser Security',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 32,
    totalXp: 195,
    emoji: '🌍',
    intro:
        'Every web attack abuses some part of how browsers and servers talk to each other. Before studying individual vulnerabilities you need a solid picture of requests, responses, cookies, sessions, and the browser rules that keep websites apart. This lesson builds that foundation.',
    concepts: [
      ConceptLesson(
        title: 'HTTP Requests and Responses',
        definition:
            'HTTP is a request and response protocol. The browser sends a request with a method, a path, headers, and sometimes a body. The server replies with a status code, headers, and content.',
        analogy:
            'It is like ordering at a counter: you hand over a slip with what you want (request), and the staff hand back the item with a receipt (response). The server remembers nothing about you unless you give it something to identify you.',
        example:
            'A simple request:\n\nGET /products?id=12 HTTP/1.1\nHost: shop.example.com\nCookie: session=abc123\nUser-Agent: Mozilla/5.0\n\nA simple response:\n\nHTTP/1.1 200 OK\nContent-Type: text/html\nSet-Cookie: session=abc123; Secure; HttpOnly\n\nImportant parts for security:\n  Method: GET reads, POST changes data\n  Parameters in the URL, body, headers, and cookies\n  Every one of those is input the attacker controls',
        keyTakeaway:
            'Everything in a request can be forged by an attacker, including headers and cookies. Never trust any of it without checking.',
      ),
      ConceptLesson(
        title: 'Cookies and Sessions',
        definition:
            'HTTP is stateless, so websites use cookies to carry a session identifier. The server maps that identifier to your logged-in state. Whoever holds the session cookie is treated as you.',
        analogy:
            'A session cookie is a wristband at a festival. Show the wristband and you are let in without proving who you are again. If someone steals or copies it, they get in too.',
        example:
            'Cookie security flags:\n\nSecure: only sent over HTTPS\nHttpOnly: JavaScript cannot read it (limits theft through XSS)\nSameSite: Strict, Lax, or None, controls whether the cookie is sent on cross-site requests (helps against CSRF)\nPath and Domain: limit where it is sent\nExpires or Max-Age: limits lifetime\n\nGood session practice:\n  Long, random, unpredictable session IDs\n  New ID after login\n  Destroy the session on logout and after inactivity',
        keyTakeaway:
            'Protect the session cookie with Secure, HttpOnly, and SameSite, because stealing it is as good as stealing the password.',
        codeSnippet:
            'from flask import Flask, make_response\n\napp = Flask(__name__)\n\n@app.route("/login")\ndef login():\n    resp = make_response("ok")\n    resp.set_cookie("session", "random-token", secure=True, httponly=True, samesite="Lax")\n    return resp',
      ),
      ConceptLesson(
        title: 'Same-Origin Policy and CORS',
        definition:
            'The same-origin policy stops a web page from reading data from a different origin (scheme, host, and port). CORS is the controlled way a server can relax that rule for chosen origins.',
        analogy:
            'Each website lives in its own locked room. A page in one room cannot peek into another room, unless the owner of the other room explicitly lets specific visitors in.',
        example:
            'Origin = scheme + host + port\n\nhttps://shop.example.com and https://shop.example.com:8443 are different origins\nhttps://shop.example.com and http://shop.example.com are different origins\n\nCORS headers:\n  Access-Control-Allow-Origin: https://app.example.com\n\nDangerous misconfigurations:\n  Allow-Origin set to any origin together with credentials\n  Reflecting whatever Origin header the request sends\n  Trusting the null origin',
        keyTakeaway:
            'Treat CORS as an allow-list of trusted origins. Allowing every origin on a site that uses cookies exposes user data to other websites.',
      ),
      ConceptLesson(
        title: 'HTTPS, Security Headers, and the Browser as Defender',
        definition:
            'Browsers enforce many protections when the server asks them to. HTTPS protects traffic in transit, and security headers switch on additional browser defences.',
        analogy:
            'Security headers are instructions to the security guard of each visitor: only accept deliveries from these suppliers, never open this door in a frame, and always use the secure entrance.',
        example:
            'Key response headers:\n\nStrict-Transport-Security (HSTS): always use HTTPS\nContent-Security-Policy (CSP): which sources of scripts and content are allowed\nX-Content-Type-Options: nosniff\nX-Frame-Options or CSP frame-ancestors: prevent clickjacking\nReferrer-Policy: limit what is sent in the Referer header\nPermissions-Policy: restrict browser features such as camera and microphone\n\nYou can test headers with browser developer tools or free online header checkers.',
        keyTakeaway:
            'Security headers are cheap, high-value defences. Check them on every application you assess.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why is HTTP described as stateless, and how do websites remember logged-in users?',
        options: [
          'It stores passwords in each request, so no memory is needed',
          'Each request is independent, so sites use cookies or tokens to carry a session identifier',
          'HTTP keeps a permanent connection open',
          'Browsers send the screen resolution to identify users'
        ],
        correctIndex: 1,
        explanation:
            'The server does not remember requests by itself. A session cookie or token links requests to a logged-in session.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which cookie flag prevents JavaScript from reading the cookie?',
        options: ['Secure', 'HttpOnly', 'SameSite', 'Path'],
        correctIndex: 1,
        explanation:
            'HttpOnly hides the cookie from scripts, which limits session theft through cross-site scripting.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which pair of URLs have DIFFERENT origins?',
        options: [
          'https://a.com/page1 and https://a.com/page2',
          'https://a.com and http://a.com',
          'https://a.com/x and https://a.com/y?z=1',
          'https://a.com/ and https://a.com/#top'
        ],
        correctIndex: 1,
        explanation:
            'The scheme differs (https vs http), so they are different origins. Paths, query strings, and fragments do not change the origin.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A site sets Access-Control-Allow-Origin to whatever Origin the request sends and also allows credentials. What is the risk?',
        options: [
          'No risk',
          'Any malicious website could make a logged-in visitor browser read private data from your site',
          'The site will be slower',
          'Cookies will be deleted'
        ],
        correctIndex: 1,
        explanation:
            'Reflecting origins with credentials effectively disables the same-origin protection for authenticated data.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You inspect a login response and see Set-Cookie: session=abc123 with no flags. Which fix is most appropriate?',
        options: [
          'Nothing, it is fine',
          'Add Secure, HttpOnly, and an appropriate SameSite value, and use a long random session ID',
          'Make the cookie shorter',
          'Put the cookie in the URL'
        ],
        correctIndex: 1,
        explanation:
            'The flags protect the cookie in transit, from scripts, and from cross-site use. Putting session IDs in URLs is even worse.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Web Traffic and Header Inspection Lab',
      goal:
          'Inspect real traffic in your browser developer tools and audit the headers and cookies of an application you own or an intentionally vulnerable lab app.',
      steps: [
        'Open your lab app (DVWA or Juice Shop) and use the browser developer tools Network tab to record a login request and response',
        'Document the method, URL, headers, cookies, and status code of each step',
        'Check every Set-Cookie header and list which of Secure, HttpOnly, and SameSite are present',
        'List which security headers are present or missing (HSTS, CSP, nosniff, frame protection, Referrer-Policy)',
        'Test the origin rules: explain which pairs of URLs from your lab share an origin and which do not',
        'Write a one-page summary with 5 improvements you would recommend',
      ],
      expectedOutput:
          'Header Audit: DVWA (lab)\n\nLogin: POST /login.php -> 302 redirect\nCookie PHPSESSID: no Secure, no HttpOnly, no SameSite\n\nMissing headers: HSTS, CSP, X-Content-Type-Options, frame protection\n\nRecommendations:\n  1. Add cookie flags\n  2. Enable HTTPS and HSTS\n  3. Add a CSP\n  4. Add nosniff\n  5. Add frame-ancestors ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 2
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l6_owasp_threat_modelling',
    topicTitle: 'OWASP Top 10 & Threat Modelling for Web Apps',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 200,
    emoji: '🔟',
    intro:
        'The OWASP Top 10 is the most widely used awareness list of web application risks, and threat modelling is how you find design problems before any code is written. Together they give you the map and the method for the rest of this level.',
    concepts: [
      ConceptLesson(
        title: 'The OWASP Top 10 at a Glance',
        definition:
            'OWASP, the Open Worldwide Application Security Project, publishes a regularly updated list of the most critical web application security risks. It is a risk awareness list, not a complete checklist.',
        analogy:
            'It is a list of the most common causes of road accidents. It tells you where to concentrate your safety efforts, but it does not cover every possible hazard.',
        example:
            'OWASP Top 10 (2021 edition, widely used as the reference):\n\nA01 Broken Access Control\nA02 Cryptographic Failures\nA03 Injection\nA04 Insecure Design\nA05 Security Misconfiguration\nA06 Vulnerable and Outdated Components\nA07 Identification and Authentication Failures\nA08 Software and Data Integrity Failures\nA09 Security Logging and Monitoring Failures\nA10 Server-Side Request Forgery (SSRF)\n\nCheck owasp.org for the newest edition, because the list is revised periodically.',
        keyTakeaway:
            'Learn the categories well. Interviewers and clients both speak in OWASP terms.',
      ),
      ConceptLesson(
        title: 'Why Insecure Design Is Different',
        definition:
            'Many flaws are not coding mistakes but missing or weak design decisions, such as no rate limit on a password reset or no check that a user can only see their own orders. Better coding cannot fix a design that never considered the threat.',
        analogy:
            'If an architect forgets to put locks on the plan, no amount of careful bricklaying will make the building secure.',
        example:
            'Design-level flaws:\n\nUnlimited login attempts\nPassword reset that reveals whether an email exists\nBusiness logic that allows negative quantities in a cart\nCoupons that can be reused endlessly\nNo separation between admin and user functions\n\nPrevention:\n  Threat modelling during design\n  Secure design patterns and reference architectures\n  Abuse-case thinking: how could someone misuse this feature?',
        keyTakeaway:
            'Ask abuse-case questions during design. Fixing a design flaw after launch is far more expensive than preventing it.',
      ),
      ConceptLesson(
        title: 'Threat Modelling with STRIDE',
        definition:
            'Threat modelling is a structured way of asking what can go wrong in a system. STRIDE is a popular checklist of six threat types applied to each part of a data flow diagram.',
        analogy:
            'It is walking through a building plan with a burglar mindset, door by door, asking how each could be abused.',
        example:
            'STRIDE:\n\nSpoofing: pretending to be someone else (violates authentication)\nTampering: modifying data (violates integrity)\nRepudiation: denying an action (needs logging)\nInformation disclosure: leaking data (violates confidentiality)\nDenial of service: making it unavailable (violates availability)\nElevation of privilege: gaining rights you should not have (violates authorisation)\n\nProcess:\n  1. Draw the system: users, web app, API, database, trust boundaries\n  2. Apply STRIDE to each element and flow\n  3. Rate and rank the threats\n  4. Decide on mitigations\n  5. Review again when the design changes',
        keyTakeaway:
            'Trust boundaries are where most threats appear: browser to server, server to database, and your system to third parties.',
      ),
      ConceptLesson(
        title: 'Applying the Model: A Small Shop Example',
        definition:
            'Applying STRIDE to a simple online shop shows how threats map to concrete controls and tests.',
        analogy:
            'It is like checking each station of a factory line for safety hazards rather than inspecting the whole building at once.',
        example:
            'Element: Login form to server\n  Spoofing: stolen passwords -> MFA, rate limiting\n  Tampering: modified requests -> server-side validation\n  Information disclosure: credentials in transit -> HTTPS\n\nElement: Orders API\n  Elevation of privilege: viewing others orders -> object-level access checks\n  Repudiation: disputed order -> audit logs\n\nElement: Database\n  Tampering and disclosure: injection -> parameterised queries, least-privilege DB account\n\nElement: Payment provider link\n  Spoofing: fake callbacks -> verify signatures',
        keyTakeaway:
            'Each threat should end with a concrete control and a way to test it. A model without tests is only a document.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which OWASP category covers a user being able to view another user order by changing an ID in the URL?',
        options: [
          'Injection',
          'Broken Access Control',
          'Cryptographic Failures',
          'Logging Failures'
        ],
        correctIndex: 1,
        explanation:
            'Accessing resources you are not authorised for, such as other users orders, is broken access control.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'In STRIDE, what does the T stand for?',
        options: ['Tracking', 'Tampering', 'Testing', 'Tunnelling'],
        correctIndex: 1,
        explanation:
            'T is for Tampering, meaning unauthorised modification of data, which violates integrity.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is insecure design hard to fix with better coding alone?',
        options: [
          'Developers refuse to fix it',
          'The flaw is in the missing or weak design decision, so the code may be correct but still allow abuse',
          'Design flaws cannot be fixed',
          'Because it only affects databases'
        ],
        correctIndex: 1,
        explanation:
            'If a feature was designed without a needed control, perfect coding of that feature still leaves the weakness.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A password reset page says "No account with that email" for unknown addresses and "Reset link sent" for real ones. Which STRIDE category is most relevant?',
        options: [
          'Information disclosure',
          'Denial of service',
          'Repudiation',
          'None'
        ],
        correctIndex: 0,
        explanation:
            'The different messages let an attacker discover which emails have accounts (user enumeration), which is information disclosure. Use one generic message for both.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A coupon code can be applied unlimited times in separate requests. What kind of problem is this?',
        options: [
          'A cryptography problem',
          'An insecure design or business logic flaw',
          'A network problem',
          'A browser bug'
        ],
        correctIndex: 1,
        explanation:
            'The code may work as written, but the design lacks a rule limiting coupon use, which is a business logic flaw.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'STRIDE Threat Model for a Small Web App',
      goal:
          'Draw a data flow diagram for a simple application and produce a STRIDE threat model with mitigations.',
      steps: [
        'Choose a simple app: an online notes service with login, a notes API, and a database',
        'Draw a data flow diagram with user, browser, web server, API, database, and any third-party service, and mark trust boundaries',
        'Apply all six STRIDE categories to at least 5 elements or flows',
        'Write each threat, its likelihood and impact (low, medium, high), and a mitigation',
        'Map each threat to the nearest OWASP Top 10 category',
        'List 5 abuse cases (for example: guessing other note IDs) and one test for each',
      ],
      expectedOutput:
          'Threat Model: NotesApp\n\nDFD: Browser -> Web server -> API -> DB (trust boundaries at browser and DB)\n\nThreats (sample):\n  Spoofing on login: credential stuffing | High | MFA + rate limit (A07)\n  Elevation: reading others notes by ID | High | object-level checks (A01)\n  Tampering: injection into note search | High | parameterised queries (A03)\n  Repudiation: no audit of deletions | Medium | audit log (A09)\n\n5 abuse cases with tests ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 3
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l6_injection',
    topicTitle: 'Injection Attacks and Defences',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 36,
    totalXp: 210,
    emoji: '💉',
    intro:
        'Injection happens whenever untrusted input is mixed into a command or query and gets interpreted as code. It has topped vulnerability lists for over a decade, and it is also one of the best understood and most preventable. Practise only on your own intentionally vulnerable lab application.',
    concepts: [
      ConceptLesson(
        title: 'The Core Idea of Injection',
        definition:
            'An injection flaw occurs when an application builds a command, query, or document by joining strings that include user input, so that the input can change the meaning of the command.',
        analogy:
            'Imagine a clerk who copies your written name straight into a form that also contains instructions. If your "name" includes extra instructions, the clerk may follow them. Safe systems keep data and instructions strictly apart.',
        example:
            'Where injection appears:\n\nSQL: database queries\nOS command: shell commands built from input\nLDAP: directory queries\nNoSQL: query objects\nTemplates: server-side template injection\nXPath, XML, and header injection\n\nCommon root cause:\n  Building a command with string concatenation or formatting from untrusted input.',
        keyTakeaway:
            'Wherever your code builds an interpreter command from input, ask: could input change its structure? If yes, redesign so data never becomes code.',
      ),
      ConceptLesson(
        title: 'SQL Injection Explained (Concept)',
        definition:
            'SQL injection lets an attacker alter database queries by supplying input that is treated as SQL. It can expose, change, or delete data, and in some setups lead to wider system compromise.',
        analogy:
            'A librarian looks up books using a slip you fill in. If you can write extra instructions on the slip that the librarian follows, you can ask for books you should not see.',
        example:
            'Vulnerable pattern (concept):\n\nThe application joins a user-supplied value into the text of a SELECT statement. If the value contains SQL syntax, the database executes it as part of the query.\n\nImpact:\n  Reading other users data\n  Bypassing login checks\n  Modifying or deleting records\n  In some cases reading files or running commands\n\nTypes:\n  In-band (results visible)\n  Blind (inferred from behaviour or timing)\n  Out-of-band\n\nTest only on your own lab application such as DVWA, and recognise it as a finding in a scan report.',
        keyTakeaway:
            'SQL injection exists only because queries were built from strings. Remove that practice and the vulnerability disappears.',
      ),
      ConceptLesson(
        title: 'Prevention: Parameterised Queries and Safe APIs',
        definition:
            'Parameterised queries (prepared statements) send the SQL structure and the data separately, so the database never treats input as code. This is the primary defence, supported by validation and least privilege.',
        analogy:
            'It is giving the clerk a pre-printed form with fixed instructions and blank boxes. Whatever you write goes only into the boxes, and can never become an instruction.',
        example:
            'Defence in depth:\n\n1. Parameterised queries or a reputable ORM used correctly\n2. Input validation using allow-lists (types, lengths, formats)\n3. Least-privilege database accounts (no admin rights for the web app)\n4. Generic error messages (no SQL errors shown to users)\n5. Web Application Firewall as an extra layer, not a fix\n6. Regular testing with scanners and code review\n\nWatch out:\n  ORMs can still be misused with raw string queries\n  Stored procedures built with string concatenation are still vulnerable',
        keyTakeaway:
            'Parameterised queries are the fix. Validation, least privilege, and monitoring reduce the damage if something slips through.',
        codeSnippet:
            'import sqlite3\n\nconn = sqlite3.connect("shop.db")\nemail = "anita@example.com"\n\nrows = conn.execute(\n    "SELECT id, name FROM users WHERE email = ?",\n    (email,)\n).fetchall()',
      ),
      ConceptLesson(
        title: 'Command Injection and Other Injection Types',
        definition:
            'Command injection happens when input is passed to an operating system shell. Other forms target templates, NoSQL queries, and file paths. The prevention principle is always the same: keep data separate from commands.',
        analogy:
            'Handing a stranger a blank cheque and asking them to fill in only the amount is risky if the rest of the cheque is also open for them to write on.',
        example:
            'Safer patterns:\n\nOS commands: avoid the shell, pass arguments as a list, validate input against an allow-list\nFile paths: resolve the full path and verify it stays inside the intended directory\nTemplates: never build template source from user input\nNoSQL: validate types and reject unexpected operators\nLDAP and XPath: use parameterised or escaped APIs\n\nIf you can use a library function instead of running an external command, do so.',
        keyTakeaway:
            'Prefer built-in library calls over shelling out. When you must run a process, pass arguments as a list and validate every value.',
        codeSnippet:
            'import ipaddress, subprocess\n\nhost = "203.0.113.9"\nipaddress.ip_address(host)\nsubprocess.run(["ping", "-c", "1", host], check=True)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the primary defence against SQL injection?',
        options: [
          'Hiding the database name',
          'Using parameterised queries so input is never treated as SQL code',
          'Making the form fields smaller',
          'Blocking all special characters only'
        ],
        correctIndex: 1,
        explanation:
            'Parameterised queries separate structure from data. Character blocking alone is fragile and easily bypassed.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should the web application database account NOT have administrator rights?',
        options: [
          'Admin accounts are slower',
          'If injection occurs, a low-privilege account limits what the attacker can do',
          'Databases do not support admin accounts',
          'It prevents logging'
        ],
        correctIndex: 1,
        explanation:
            'Least privilege limits damage when another control fails.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A developer uses an ORM but writes a raw query joining a user value into the text. Is this safe?',
        options: [
          'Yes, ORMs are always safe',
          'No, concatenating input into raw queries reintroduces injection risk even with an ORM',
          'Yes, because ORMs encrypt queries',
          'Only unsafe on weekends'
        ],
        correctIndex: 1,
        explanation:
            'ORMs protect you only when you use their parameter-binding features, not when you build raw SQL from strings.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'An error page on a site displays a full database error with table and column names. What should be changed?',
        options: [
          'Make the message longer',
          'Show a generic error to users and log the details privately',
          'Add more detail',
          'Turn off HTTPS'
        ],
        correctIndex: 1,
        explanation:
            'Detailed errors help attackers learn the structure of the database. Show a generic message and keep details in protected logs.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A tool lets admins ping a hostname by building a shell command from a form field. What is the safest redesign?',
        options: [
          'Remove spaces from the field',
          'Validate the value as an IP or allow-listed hostname and call the process with an argument list, with no shell',
          'Run the tool as root for reliability',
          'Allow any input but log it'
        ],
        correctIndex: 1,
        explanation:
            'Validation plus an argument list avoids shell interpretation, which removes the main route for command injection.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Find and Fix an Injection Flaw in a Lab App',
      goal:
          'Understand an injection flaw in your own lab application, fix it with parameterised queries, and prove the fix.',
      steps: [
        'Write a tiny Flask or similar app with a SQLite user search page that deliberately builds its query from a string (lab only, never deployed)',
        'Explain in writing, without writing an exploit, why the code is unsafe and what class of weakness it is (CWE-89)',
        'Run a scanner such as ZAP or Bandit against the lab code or app and record how the flaw is reported',
        'Rewrite the query using parameter binding and add allow-list validation of the input',
        'Add a generic error handler and a least-privilege note for the database account',
        'Re-run the scanner and a manual test to confirm the finding is gone, and write a before and after summary',
      ],
      expectedOutput:
          'Injection Fix Report (lab)\n\nBefore: string-built SQL in /search; Bandit B608 warning; ZAP SQL injection alert\nCWE-89 | OWASP A03\n\nFix: parameter binding, length and format validation, generic error page\nAfter: Bandit clean for that rule; ZAP alert not raised\n\nLesson: separate data from code; least privilege and generic errors limit damage ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 4
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l6_xss_csp',
    topicTitle: 'Cross-Site Scripting (XSS) & Content Security Policy',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 34,
    totalXp: 205,
    emoji: '📜',
    intro:
        'Cross-site scripting lets an attacker run their script inside another user browser session on your website. It can steal sessions, change page content, or perform actions as the victim. The defences are well known: encode output, avoid dangerous APIs, and add a Content Security Policy.',
    concepts: [
      ConceptLesson(
        title: 'What XSS Is and Why It Matters',
        definition:
            'XSS occurs when an application includes untrusted data in a web page without proper encoding, so the browser runs it as script. The script runs with the permissions of the victim on that site.',
        analogy:
            'It is like a public noticeboard where anyone can pin a note, and the building then reads out every note over the loudspeaker as an official announcement. If a note contains instructions, everyone hears them as if they came from the management.',
        example:
            'What a successful XSS can do (in a lab you control, to understand impact):\n\nRead data visible on the page\nPerform actions as the logged-in user\nCapture keystrokes on the page\nRedirect users to fake pages\nSteal session cookies that lack HttpOnly\n\nSimple test string used in labs: a harmless script that shows a message box. Seeing it run proves the input was not handled safely.',
        keyTakeaway:
            'XSS is a failure to separate data from code in the browser. The browser cannot tell which scripts are yours, unless you tell it.',
      ),
      ConceptLesson(
        title: 'Reflected, Stored, and DOM-Based XSS',
        definition:
            'Reflected XSS returns input from the current request in the response. Stored XSS saves malicious input on the server so it affects every visitor. DOM-based XSS happens entirely in client-side JavaScript that handles data unsafely.',
        analogy:
            'Reflected: someone hands you a leaflet that makes the website shout their message back at you. Stored: a note pinned permanently on the board that everyone reads. DOM-based: the page itself writes the note on the wall using what you typed.',
        example:
            'Comparison:\n\nReflected: search term shown on the results page without encoding; needs the victim to open a crafted link\nStored: comment or profile field saved and shown to others; usually the most serious\nDOM-based: JavaScript uses values such as the URL fragment in dangerous sinks like innerHTML\n\nCommon dangerous sinks:\n  innerHTML, outerHTML, document.write, eval, setTimeout with strings\n\nSafer alternatives:\n  textContent, setAttribute for safe attributes, framework data binding',
        keyTakeaway:
            'Stored XSS affects the most people. DOM-based XSS is easy to miss because the server never sees the payload.',
      ),
      ConceptLesson(
        title: 'Prevention: Output Encoding and Safe Frameworks',
        definition:
            'The primary defence is context-aware output encoding: converting special characters so the browser treats them as text, with the right encoding for HTML, attributes, JavaScript, and URLs. Modern frameworks do this automatically unless you bypass them.',
        analogy:
            'Encoding is putting the note inside a glass display case. Everyone can read the words, but nothing in it can speak into the loudspeaker.',
        example:
            'Good practice:\n\nUse templating engines with auto-escaping turned on\nNever mark user data as safe or trusted by default\nAvoid innerHTML with untrusted data; use textContent\nIf rich text is needed, sanitise with a trusted library such as DOMPurify\nValidate input as defence in depth, but rely on output encoding\nSet HttpOnly on session cookies\n\nFramework warnings:\n  React: dangerouslySetInnerHTML\n  Angular: bypassSecurityTrust methods\n  Vue: v-html\n  Jinja2: the safe filter and autoescape settings',
        keyTakeaway:
            'Escape on output, in the right context, using the framework tools. Every use of a bypass feature is a risk to review.',
        codeSnippet:
            'from markupsafe import escape\n\ncomment = "<b>Hello</b>"\nprint(escape(comment))\n# Output is text that browsers show, not run',
      ),
      ConceptLesson(
        title: 'Content Security Policy (CSP)',
        definition:
            'CSP is a response header that tells the browser which sources of scripts, styles, images, and other content are allowed. A strong policy blocks inline scripts and unknown origins, greatly limiting what an XSS flaw can do.',
        analogy:
            'CSP is a guest list at the door of your page. Even if an attacker slips a script note under the door, the guard refuses to read anything that is not on the list.',
        example:
            'Example policy:\n\nContent-Security-Policy: default-src \'self\'; script-src \'self\'; object-src \'none\'; frame-ancestors \'none\'; base-uri \'self\'\n\nKey ideas:\n  Avoid unsafe-inline and unsafe-eval for scripts\n  Use nonces or hashes if inline scripts are needed\n  Start in report-only mode to see what would break\n  Use the report-uri or report-to feature to collect violations\n\nCSP is a second layer. It does not replace output encoding.',
        keyTakeaway:
            'Deploy a strict CSP in report-only mode first, fix what breaks, then enforce it. It turns many XSS bugs into harmless errors.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which type of XSS is stored on the server and affects every visitor who views the page?',
        options: [
          'Reflected XSS',
          'Stored XSS',
          'DOM-based XSS',
          'None of these'
        ],
        correctIndex: 1,
        explanation:
            'Stored XSS persists in the application data, so each user loading that content runs the script.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the primary defence against XSS?',
        options: [
          'Context-aware output encoding',
          'Hiding the website',
          'Using longer passwords',
          'Blocking all users from entering text'
        ],
        correctIndex: 0,
        explanation:
            'Encoding output ensures data is displayed as text, not interpreted as code. CSP and validation add defence in depth.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is CSP report-only mode useful when first deploying a policy?',
        options: [
          'It blocks everything',
          'It shows what would have been blocked without breaking the site, so you can tune the policy first',
          'It encrypts pages',
          'It removes the need for testing'
        ],
        correctIndex: 1,
        explanation:
            'Report-only mode lets you find legitimate content that violates the policy before enforcing it.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A developer sets element.innerHTML = userComment to show comments. What is the safest quick fix?',
        options: [
          'Leave it, comments are harmless',
          'Use element.textContent = userComment, or sanitise with a trusted library if formatting is needed',
          'Use eval instead',
          'Hide the element'
        ],
        correctIndex: 1,
        explanation:
            'textContent treats the value as text, which removes the injection path. Use a proven sanitiser only when rich HTML is required.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A site has a stored XSS flaw but uses HttpOnly cookies and a strict CSP. What is the likely effect?',
        options: [
          'The flaw becomes impossible to exist',
          'The flaw still exists but its impact is reduced: scripts cannot read the session cookie and inline or foreign scripts may be blocked',
          'The site becomes faster',
          'The flaw becomes worse'
        ],
        correctIndex: 1,
        explanation:
            'These layers reduce exploitability and impact, but the underlying encoding bug should still be fixed.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Fix a Lab XSS Flaw and Add a CSP',
      goal:
          'Identify a deliberately vulnerable page in your lab, fix it with encoding, and add a CSP.',
      steps: [
        'Build a small lab comment page that shows saved comments using unsafe HTML insertion (lab use only)',
        'Describe in words which sink or template setting causes the weakness, and map it to CWE-79 and OWASP A03',
        'Use ZAP passive and active scanning on the lab page and record the XSS alert',
        'Fix the page using auto-escaping or textContent, and sanitise rich text only if needed',
        'Add a Content-Security-Policy header in report-only mode, then enforce it after resolving violations',
        'Verify the fix with ZAP and manual review, and summarise the before and after',
      ],
      expectedOutput:
          'XSS Fix Report (lab)\n\nBefore: innerHTML used with comments | ZAP: XSS (stored) | CWE-79\nFix: textContent / auto-escaping, HttpOnly cookie, CSP\nCSP report-only found 2 inline scripts -> moved to files, then enforced\nAfter: ZAP alert gone; comment text displayed as plain text ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 5
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l6_auth_sessions',
    topicTitle: 'Authentication & Session Management Flaws',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 34,
    totalXp: 205,
    emoji: '🔑',
    intro:
        'Login pages, password resets, and session handling are attacked constantly because a single mistake can hand over an entire account. This lesson covers how authentication fails in real applications and how to build it correctly.',
    concepts: [
      ConceptLesson(
        title: 'Common Authentication Weaknesses',
        definition:
            'Authentication weaknesses let attackers log in as someone else, usually by guessing, reusing, or bypassing credentials. They are covered by OWASP A07, Identification and Authentication Failures.',
        analogy:
            'A building with a strong front door but a spare key under the mat, a guard who answers any question about who works there, and no limit on how many times you can try the lock.',
        example:
            'Typical flaws:\n\nNo limit on login attempts (brute force, credential stuffing)\nWeak or default passwords allowed\nUser enumeration: different messages for unknown user and wrong password\nPasswords stored in plain text or with weak hashes\nSession IDs in URLs or never changed after login\nNo multi-factor authentication for sensitive accounts\nLogin and reset flows that can be bypassed\nVerbose error messages',
        keyTakeaway:
            'Attackers automate login attempts using leaked passwords from other breaches. Rate limiting, MFA, and breached-password checks are essential.',
      ),
      ConceptLesson(
        title: 'Building Login Securely',
        definition:
            'Secure login combines strong password storage, throttling, safe messages, and optional multi-factor authentication. Use well-tested libraries and identity providers instead of writing your own.',
        analogy:
            'It is the checklist of a good hotel front desk: verify identity carefully, limit repeated failed attempts, never announce which guests are staying, and issue a fresh key card after check-in.',
        example:
            'Good practice:\n\nHash passwords with bcrypt, scrypt, or Argon2 (unique salt each)\nUse the same generic message: Invalid username or password\nRate limit and add temporary lockout or increasing delays\nCheck new passwords against known breached lists and require length over complexity\nOffer MFA, preferably app-based, hardware keys, or passkeys\nLog failures and alert on bursts\nUse a trusted identity provider or framework auth when possible\nNever email passwords',
        keyTakeaway:
            'Use proven authentication libraries and identity providers. Building your own login system is almost always a mistake.',
      ),
      ConceptLesson(
        title: 'Session Management Done Right',
        definition:
            'After login the application relies on a session identifier. Weak handling allows attackers to steal, guess, or force a session onto a victim.',
        analogy:
            'A wristband should be hard to forge, replaced when you enter the VIP area, cut off when you leave, and expire at the end of the event.',
        example:
            'Session controls:\n\nGenerate IDs with a cryptographically secure random source\nIssue a NEW session ID after login to prevent session fixation\nSet Secure, HttpOnly, and SameSite cookie flags\nSet idle and absolute timeouts\nInvalidate the session on the server at logout\nBind sensitive actions to re-authentication (change email, change password, payment)\nNever place session IDs in URLs\nRotate sessions on privilege change',
        keyTakeaway:
            'Regenerate the session ID at login and destroy it at logout on the server side, not just in the browser.',
      ),
      ConceptLesson(
        title: 'Password Reset, MFA, and Token Pitfalls',
        definition:
            'Account recovery and token-based sessions create new attack paths. Weak reset flows and badly validated tokens, such as JWTs, are frequent real-world failures.',
        analogy:
            'A reset flow is a side door for locked-out residents. If it is easier to pass than the front door, attackers use it.',
        example:
            'Password reset best practice:\n\nSingle-use, random, short-lived reset tokens\nSend only to the registered email\nSame response whether or not the account exists\nInvalidate old sessions after a reset\nNo security questions with guessable answers\n\nJWT pitfalls:\n  Always verify the signature and the expected algorithm\n  Never accept tokens with no signature\n  Use strong secrets or asymmetric keys\n  Short expiry and a refresh strategy\n  Do not store sensitive data in the token payload (it is readable)\n  Plan revocation, because stateless tokens are hard to invalidate',
        keyTakeaway:
            'Recovery paths and token handling must be as strong as the login itself, because attackers pick the weakest door.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why should a login page show the same message for an unknown username and a wrong password?',
        options: [
          'It looks neater',
          'It prevents attackers from discovering which accounts exist (user enumeration)',
          'It makes login faster',
          'It is required by browsers'
        ],
        correctIndex: 1,
        explanation:
            'Different messages leak which usernames are valid, helping attackers focus their guessing.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is session fixation and how is it prevented?',
        options: [
          'A fault in the server clock; prevent it with NTP',
          'An attacker forces a known session ID onto a victim; prevent it by issuing a new session ID after login',
          'A way to speed up sessions; prevent it by caching',
          'A database error; prevent it by backups'
        ],
        correctIndex: 1,
        explanation:
            'If the session ID does not change at login, an attacker who set it earlier can reuse it. Regenerate it on authentication.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which JWT practice is correct?',
        options: [
          'Accept tokens even if the signature is missing',
          'Verify the signature and expected algorithm, and set a short expiry',
          'Put the user password in the token payload',
          'Use a one-letter secret'
        ],
        correctIndex: 1,
        explanation:
            'Signature and algorithm verification and short lifetimes are basic requirements. Payloads are readable, so never place secrets in them.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your logs show 50,000 login attempts in an hour from many IPs, each trying one common password across thousands of usernames. What is this attack and what helps?',
        options: [
          'A SQL injection; use a WAF',
          'Password spraying or credential stuffing; add rate limiting by account and IP, MFA, breached-password checks, and alerting',
          'A DNS attack; change the domain',
          'A hardware failure'
        ],
        correctIndex: 1,
        explanation:
            'Low-and-slow guessing across many accounts is password spraying. Layered controls on accounts, IPs, and credentials are needed.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A password reset link never expires and can be used many times. What is the fix?',
        options: [
          'Nothing, it is convenient',
          'Make reset tokens random, single-use, and short-lived, and invalidate them after use',
          'Email the password instead',
          'Use the username as the token'
        ],
        correctIndex: 1,
        explanation:
            'Long-lived or reusable tokens give attackers a lasting way into an account if the email is ever exposed.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Authentication Review and Hardened Login Prototype',
      goal:
          'Review a lab login system against a checklist and build a hardened version of the key parts.',
      steps: [
        'Write a 15-item authentication and session checklist from this lesson',
        'Audit your lab app (DVWA or Juice Shop) against it and mark each item pass or fail with evidence',
        'Build a small Flask login prototype with bcrypt password hashing and a generic error message',
        'Add simple rate limiting (per IP and per username) and a lockout delay',
        'Regenerate the session on login, set secure cookie flags, and destroy the session on logout',
        'Write 5 tests (pytest) for the rules, such as locked after 5 failures and generic message returned',
      ],
      expectedOutput:
          'Auth Review\n\nChecklist: 15 items | Lab app: 6 pass, 9 fail\nFails: no rate limit, session ID unchanged at login, weak cookie flags, user enumeration, no MFA...\n\nPrototype:\n  bcrypt hashing ✓ generic error ✓ rate limit ✓ session regenerated ✓ cookie flags ✓\n  Tests: 5 passed ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 6
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l6_access_control_csrf',
    topicTitle: 'Broken Access Control, IDOR & CSRF',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 34,
    totalXp: 205,
    emoji: '🚧',
    intro:
        'Broken access control is number one on the OWASP Top 10. It happens when the application fails to enforce what each user is allowed to see or do. CSRF is a related problem where an attacker tricks a logged-in user browser into performing actions. Both are often invisible to scanners, so human understanding matters.',
    concepts: [
      ConceptLesson(
        title: 'What Broken Access Control Means',
        definition:
            'Access control decides who may access which data and functions. It is broken when users can act outside their intended permissions, for example by viewing other accounts, using admin features, or modifying others data.',
        analogy:
            'A hotel where your key card opens your room, but also every other room if you simply walk up and try it. Authentication proved who you are, but nothing checked what you are allowed to open.',
        example:
            'Typical failures:\n\nCan view or edit another user record by changing an ID\nA normal user can open an admin URL\nHidden buttons are the only protection (the server does not check)\nAPI endpoints without permission checks\nMissing checks on actions such as delete and export\nMetadata or token manipulation to claim a higher role',
        keyTakeaway:
            'Enforce access control on the server for every request. Hiding a button is not security.',
      ),
      ConceptLesson(
        title: 'IDOR and Object-Level Authorisation',
        definition:
            'Insecure Direct Object Reference (IDOR) occurs when the application uses an identifier from the request, such as an order number, to fetch an object without checking that the current user owns it. In API terms it is called BOLA, broken object-level authorisation.',
        analogy:
            'A coat check that hands over any coat if you quote its number, without checking your ticket belongs to you.',
        example:
            'Vulnerable pattern (concept):\n\nGET /orders/1043 returns the order for ID 1043 to anyone who is logged in. Changing the number to 1044 returns someone else order.\n\nPrevention:\n  On every access, check that the object belongs to the current user or that the user has a role permitting access\n  Derive the user from the session on the server, not from a request parameter\n  Use unpredictable identifiers (UUIDs) as an extra layer, never as the only control\n  Write automated tests that try cross-user access',
        keyTakeaway:
            'Every object lookup needs an ownership or permission check. Test it by trying to access another user data with your own session.',
        codeSnippet:
            'def get_order(order_id, current_user):\n    order = db.find_order(order_id)\n    if order is None or order.owner_id != current_user.id:\n        return "Not found", 404\n    return order',
      ),
      ConceptLesson(
        title: 'Privilege Escalation and Function-Level Checks',
        definition:
            'Vertical privilege escalation means a lower-privileged user reaches higher-privileged functions. Horizontal escalation means reaching a peer data. Both come from missing server-side checks.',
        analogy:
            'A staff-only door with a sign but no lock. Anyone who ignores the sign walks in.',
        example:
            'Good access control design:\n\nDeny by default: permit only what is explicitly allowed\nRole-based access control (RBAC) or attribute-based control, centralised in one place\nCheck permissions on every sensitive function, not just in the user interface\nRe-check on every request; do not rely on earlier checks\nLog access control failures and alert on repeated attempts\nAvoid trusting client-side values such as role flags in cookies or hidden fields\n\nTest with accounts of different roles and attempt each action with each account.',
        keyTakeaway:
            'Centralise authorisation logic, deny by default, and test every role against every function.',
      ),
      ConceptLesson(
        title: 'Cross-Site Request Forgery (CSRF)',
        definition:
            'CSRF tricks a logged-in user browser into sending an unwanted request to a site, because browsers automatically attach cookies. The server cannot tell the forged request from a real one unless it adds extra proof.',
        analogy:
            'Someone slips a pre-filled money-transfer form in front of you while you are already logged in at the bank counter, and you sign it without reading. The bank sees your valid signature.',
        example:
            'Defences:\n\nAnti-CSRF tokens: a secret, per-session value that must accompany state-changing requests\nSameSite cookies (Lax or Strict) to stop cross-site sending\nCheck Origin or Referer headers on sensitive requests\nUse POST or other non-GET methods for changes, never GET\nRe-authenticate for critical actions\nFrameworks usually provide built-in CSRF protection: enable it\n\nNote: CSRF does not apply to APIs that use tokens in headers rather than cookies, but those have other risks.',
        keyTakeaway:
            'Any state-changing request that relies only on cookies needs a CSRF defence. Turn on the framework protection and add SameSite cookies.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'A user changes the order number in a URL and sees another customer order. What is this?',
        options: [
          'Injection',
          'IDOR, a form of broken access control',
          'A DNS issue',
          'Hardware failure'
        ],
        correctIndex: 1,
        explanation:
            'The application did not check that the order belonged to the requesting user.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is hiding the admin menu from normal users NOT enough?',
        options: [
          'It is enough',
          'Users can still call the admin URLs or APIs directly, so the server must enforce permissions',
          'Menus are not allowed',
          'Browsers show all menus'
        ],
        correctIndex: 1,
        explanation:
            'Client-side hiding is cosmetic. The server must check permissions on every request.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which combination best defends against CSRF?',
        options: [
          'Anti-CSRF tokens and SameSite cookies',
          'Longer URLs',
          'Making all requests GET',
          'Disabling cookies for the server'
        ],
        correctIndex: 0,
        explanation:
            'Tokens prove the request came from your page, and SameSite limits cross-site cookie sending.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'An API endpoint PUT /users/55/role accepts a role value in the body from any logged-in user. What is the main flaw?',
        options: [
          'The URL is too short',
          'Missing function-level authorisation: only admins should be able to change roles, and the server must enforce it',
          'The body is JSON',
          'The user ID is a number'
        ],
        correctIndex: 1,
        explanation:
            'Changing roles is a privileged function. Without a server-side check, any user can escalate their own privileges.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You want to automatically catch IDOR regressions. What is a good test design?',
        options: [
          'Test only with an admin account',
          'Create two normal users in tests; log in as user A and try to read and modify user B objects, expecting 403 or 404',
          'Test only the login page',
          'Skip testing'
        ],
        correctIndex: 1,
        explanation:
            'Cross-user tests directly verify object-level authorisation and prevent the flaw from returning.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Access Control Matrix and Automated Tests',
      goal:
          'Design a role-permission matrix for a small app and prove it with automated tests.',
      steps: [
        'Define 3 roles (guest, user, admin) and 8 functions for a simple notes app (view own notes, edit, delete, view all notes, manage users, etc.)',
        'Fill in an access control matrix with allow or deny for each role and function',
        'Implement the app using Flask or similar with a central authorisation function and deny-by-default',
        'Write pytest tests for every matrix cell, including cross-user tests for object-level access',
        'Add CSRF protection using the framework feature and SameSite cookies',
        'Run ZAP against the lab app and record which findings relate to access control or CSRF, noting that scanners often miss logic flaws',
      ],
      expectedOutput:
          'Access Control Report\n\nMatrix: 3 roles x 8 functions = 24 cells\nImplementation: central can(user, action, obj) | deny by default ✓\n\nTests: 24 matrix tests + 4 cross-user tests = 28 passed ✓\nCSRF: framework tokens + SameSite=Lax ✓\n\nZAP: 2 header findings; no IDOR detected by scanner (manual and automated tests cover it) ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 7
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l6_misconfig_data_components',
    topicTitle:
        'Security Misconfiguration, Data Exposure & Vulnerable Components',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 34,
    totalXp: 205,
    emoji: '⚙️',
    intro:
        'Many web breaches involve no clever exploit at all: a debug mode left on, a secret in a public repository, an outdated library with a known flaw. This lesson covers the everyday weaknesses of configuration, data protection, and third-party code.',
    concepts: [
      ConceptLesson(
        title: 'Security Misconfiguration in Web Apps',
        definition:
            'Security misconfiguration means insecure default settings, incomplete setups, open cloud storage, verbose errors, or unnecessary features left enabled. It is OWASP A05.',
        analogy:
            'Moving into a new house and leaving the builder default master key, the construction ladder at the window, and the site office door open.',
        example:
            'Common issues:\n\nDebug mode or stack traces shown in production\nDefault accounts and sample applications left installed\nDirectory listing enabled\nAdmin consoles exposed to the internet\nMissing security headers and weak TLS settings\nPublicly readable cloud storage buckets\nUnneeded HTTP methods enabled\nOverly permissive CORS\nServer banners revealing versions\n\nPrevention:\n  Hardened, repeatable builds\n  Separate dev, test, and production configurations\n  Automated configuration scanning',
        keyTakeaway:
            'Treat configuration as code: version it, review it, and scan it so every environment is built the same secure way.',
      ),
      ConceptLesson(
        title: 'Protecting Sensitive Data',
        definition:
            'Applications must protect sensitive data in transit, at rest, and in use. Failures here, OWASP A02 Cryptographic Failures, include missing encryption, weak algorithms, and poor key management.',
        analogy:
            'Sending valuables in a see-through envelope, keeping the spare key taped to the vault, or storing the combination in a note on the wall.',
        example:
            'Good practice:\n\nUse HTTPS everywhere with modern TLS (1.2 or 1.3) and HSTS\nEncrypt sensitive data at rest with proven algorithms (AES-GCM)\nHash passwords with bcrypt, scrypt, or Argon2\nStore keys in a secrets manager or key management service, not in code\nCollect and keep only the data you need (data minimisation)\nMask or tokenise card and personal data\nDo not log secrets or personal data\nSet cache control headers so sensitive pages are not stored\n\nIndia: the Digital Personal Data Protection Act, 2023 places duties on handling personal data.',
        keyTakeaway:
            'The safest sensitive data is data you never collect or store. Protect what remains with strong, standard cryptography and good key management.',
      ),
      ConceptLesson(
        title: 'Vulnerable and Outdated Components',
        definition:
            'Web applications depend on dozens or hundreds of libraries. A flaw in a single dependency, such as the Log4Shell issue in Log4j, can compromise every application using it. This is OWASP A06.',
        analogy:
            'A house built with prefabricated parts is only as safe as the weakest part. A recall on one window model affects every house that used it.',
        example:
            'Software composition analysis (SCA):\n\nInventory all dependencies, including indirect ones (an SBOM, software bill of materials, in formats such as CycloneDX or SPDX)\nScan them against vulnerability databases\nTools: pip-audit, npm audit, OWASP Dependency-Check, Trivy, Dependabot, Snyk\nUpdate regularly and pin versions\nRemove unused dependencies\nPrefer well-maintained projects\nWatch for typosquatted and malicious packages\n\nProcess:\n  Alert -> assess exposure -> update or mitigate -> test -> deploy',
        keyTakeaway:
            'You are responsible for your dependencies. Know what you ship, scan it continuously, and update promptly.',
        codeSnippet:
            'pip install pip-audit\npip-audit -r requirements.txt\n\nnpm audit',
      ),
      ConceptLesson(
        title: 'File Upload, SSRF, and Other Everyday Risks',
        definition:
            'Features such as file upload and URL fetching are frequent sources of serious flaws. Server-Side Request Forgery (SSRF) lets an attacker make your server request internal resources, and unsafe upload handling can lead to malware storage or code execution.',
        analogy:
            'A receptionist who will fetch any parcel from any address on request, including from the locked internal store room, is a perfect tool for someone outside to use.',
        example:
            'Safe file upload:\n\nCheck size, type by content (not just name or declared type), and allow-list extensions\nGenerate random server-side file names\nStore outside the web root or in object storage with no execute rights\nScan for malware if needed\nServe downloads with correct content type and Content-Disposition\n\nSSRF defence (OWASP A10):\n  Allow-list the destinations your server may fetch\n  Block internal ranges and cloud metadata addresses such as 169.254.169.254\n  Disable unneeded URL schemes and redirects\n  Network egress controls and metadata service hardening in the cloud',
        keyTakeaway:
            'Any feature that handles files or fetches URLs on behalf of users needs strict allow-lists and network controls.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why is leaving debug mode enabled in production dangerous?',
        options: [
          'It makes the app faster',
          'It can reveal stack traces, configuration, and internal details to attackers',
          'It improves security',
          'It disables HTTPS'
        ],
        correctIndex: 1,
        explanation:
            'Debug output leaks internals and sometimes even offers interactive consoles. Production should show generic errors only.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is an SBOM?',
        options: [
          'A type of firewall',
          'A software bill of materials: an inventory of the components inside an application',
          'A database backup',
          'A security badge'
        ],
        correctIndex: 1,
        explanation:
            'An SBOM lists libraries and versions so you can quickly identify exposure when a new vulnerability is announced.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which is the best defence against SSRF?',
        options: [
          'Trust all user-supplied URLs',
          'Allow-list permitted destinations and block internal and metadata addresses',
          'Increase the timeout',
          'Remove HTTPS'
        ],
        correctIndex: 1,
        explanation:
            'Restricting where the server may connect, plus network egress controls, prevents abuse of the server as a proxy into internal resources.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A new critical vulnerability is announced in a popular web library. How does an SBOM help most?',
        options: [
          'It removes the vulnerability',
          'It lets you quickly find which of your applications use the affected version and prioritise updates',
          'It encrypts the library',
          'It disables the library'
        ],
        correctIndex: 1,
        explanation:
            'Knowing exactly what you run turns a frantic search into a quick, targeted response.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'An upload feature saves files using the original file name inside the web root and allows any extension. What should change?',
        options: [
          'Nothing',
          'Allow-list types, validate content, use random names, store outside the web root with no execute rights',
          'Only allow larger files',
          'Move files to the desktop'
        ],
        correctIndex: 1,
        explanation:
            'Controlling type, name, and location prevents attackers from uploading and running scripts.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Production Readiness Review of a Lab Web App',
      goal:
          'Review a lab web application for configuration, data protection, and dependency risks and produce a fix list.',
      steps: [
        'Choose a small Flask or Node lab app and list its dependencies, creating a simple SBOM (for example with pip freeze or npm ls)',
        'Run pip-audit or npm audit and record vulnerable packages and fixed versions',
        'Review configuration: debug mode, secret keys, error pages, headers, TLS settings, CORS, and directory listing',
        'Search the repository for secrets with gitleaks or a manual review, and move any secrets to environment variables',
        'Review the upload or URL-fetch feature (if any) against the safe-handling checklist',
        'Write a prioritised fix list with owners and deadlines, and apply at least 5 fixes',
      ],
      expectedOutput:
          'Readiness Review (lab)\n\nSBOM: 42 packages | pip-audit: 3 vulnerable (2 fixes available)\nConfig: debug=True -> off; secret key in code -> env var; missing HSTS and CSP -> added\nSecrets scan: 1 hard-coded key found and rotated\nUpload: random names + allow-list added\n\nFix list: 9 items | 6 applied | re-audit shows 1 vulnerable package remaining (documented) ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 8
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l6_api_security',
    topicTitle: 'API Security: REST, GraphQL, OAuth & JWT',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 36,
    totalXp: 215,
    emoji: '🔌',
    intro:
        'Mobile apps, single-page apps, and partner integrations all talk to APIs, so APIs have become the main attack surface of modern applications. They share risks with web apps but add their own, such as object-level authorisation, excessive data exposure, and resource abuse.',
    concepts: [
      ConceptLesson(
        title: 'Why APIs Are a Prime Target',
        definition:
            'APIs expose application logic and data directly, in machine-readable form, often with many endpoints and little user interface protection. Attackers can test them at scale with simple scripts.',
        analogy:
            'A website is a shop front with a guided layout. An API is the loading dock behind it: efficient and powerful, but if nobody checks the paperwork, anyone can load anything.',
        example:
            'API security challenges:\n\nMany endpoints, some undocumented or forgotten (shadow and zombie APIs)\nClients are trusted too much (mobile apps can be inspected and modified)\nObject IDs in every URL and body\nOver-sharing: endpoints return full objects and rely on the client to hide fields\nNo rate limits on expensive operations\nVersioning leaves old, weaker versions running',
        keyTakeaway:
            'Never rely on the client to enforce security. Every API call must be authenticated, authorised, validated, and limited by the server.',
      ),
      ConceptLesson(
        title: 'OWASP API Security Top 10',
        definition:
            'OWASP maintains a separate Top 10 list for APIs, with the 2023 edition widely used. It focuses on authorisation, resource consumption, and inventory problems that are specific to APIs.',
        analogy:
            'It is the checklist for loading dock safety, as opposed to shop front safety.',
        example:
            'OWASP API Security Top 10 (2023):\n\nAPI1 Broken Object Level Authorization\nAPI2 Broken Authentication\nAPI3 Broken Object Property Level Authorization (excessive data exposure and mass assignment)\nAPI4 Unrestricted Resource Consumption\nAPI5 Broken Function Level Authorization\nAPI6 Unrestricted Access to Sensitive Business Flows\nAPI7 Server Side Request Forgery\nAPI8 Security Misconfiguration\nAPI9 Improper Inventory Management\nAPI10 Unsafe Consumption of APIs',
        keyTakeaway:
            'BOLA, broken object-level authorisation, is the most common API flaw. Test it first on every endpoint that takes an ID.',
      ),
      ConceptLesson(
        title: 'Mass Assignment, Excessive Data Exposure, and Rate Limiting',
        definition:
            'Mass assignment happens when the server blindly binds all fields from a request to an internal object, so users can set fields they should not, such as role. Excessive data exposure is returning more fields than needed. Missing rate limits allow abuse and denial of service.',
        analogy:
            'A form where the clerk copies every box you tick, including a hidden "make me an admin" box you added yourself. Another clerk who hands over the entire file when you asked for a phone number.',
        example:
            'Controls:\n\nAllow-list the fields that may be set from a request (explicit schemas)\nReturn only needed fields using response schemas or DTOs\nNever return password hashes, tokens, or internal flags\nValidate every field: type, length, range, format\nApply rate limits and quotas per user, per key, and per IP\nLimit page sizes and query depth (important for GraphQL)\nSet timeouts and payload size limits',
        keyTakeaway:
            'Define explicit input and output schemas. Whatever is not in the schema is not accepted and not returned.',
        codeSnippet:
            'ALLOWED_FIELDS = {"display_name", "bio"}\n\ndef update_profile(user, payload):\n    clean = {k: v for k, v in payload.items() if k in ALLOWED_FIELDS}\n    user.update(clean)\n    return {"display_name": user.display_name, "bio": user.bio}',
      ),
      ConceptLesson(
        title: 'OAuth 2.0, OpenID Connect, and Token Security',
        definition:
            'OAuth 2.0 lets an application obtain limited access to a resource on a user behalf without handling their password. OpenID Connect adds identity on top. Tokens are the keys, so their handling is critical.',
        analogy:
            'OAuth is a valet key: it lets the valet drive and park the car but not open the boot or glove box. The owner never hands over the master key.',
        example:
            'Good practice:\n\nUse the authorisation code flow with PKCE for public clients (mobile and single-page apps)\nRegister exact redirect URIs and validate them strictly\nUse the state parameter to prevent CSRF in the flow\nRequest the minimum scopes\nKeep access tokens short-lived and use refresh tokens carefully\nValidate token signature, issuer, audience, and expiry on the API\nStore tokens securely (avoid localStorage for sensitive tokens where possible)\nRevoke tokens on logout and on suspected compromise\n\nGraphQL extras: disable introspection in production if not needed, limit depth and complexity, and enforce authorisation per field and resolver.',
        keyTakeaway:
            'Use standard flows with trusted libraries, validate every token claim, and keep scopes and lifetimes small.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which API flaw lets a user read another user data by changing an ID in the request?',
        options: [
          'Broken Object Level Authorization (BOLA)',
          'Rate limiting',
          'TLS misconfiguration',
          'Open redirect'
        ],
        correctIndex: 0,
        explanation:
            'BOLA is the API version of IDOR and is the most common serious API vulnerability.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is mass assignment?',
        options: [
          'Assigning many tasks to a server',
          'Binding all request fields to an object so users can set properties they should not, such as role',
          'A database backup method',
          'A load balancing feature'
        ],
        correctIndex: 1,
        explanation:
            'Without an allow-list of settable fields, attackers can add extra fields that change privileged properties.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which OAuth flow is recommended for mobile and single-page apps?',
        options: [
          'Authorisation code flow with PKCE',
          'Sending the password in the URL',
          'Implicit flow without checks',
          'Sharing the client secret in the app'
        ],
        correctIndex: 0,
        explanation:
            'PKCE protects the authorisation code for public clients that cannot keep a secret.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A GET /users/me endpoint returns the full user record, including password hash and internal admin flag, relying on the mobile app to hide fields. What is the problem?',
        options: [
          'None, the app hides them',
          'Excessive data exposure: the server should return only the needed fields using a response schema',
          'The endpoint is too fast',
          'The record is too short'
        ],
        correctIndex: 1,
        explanation:
            'Anyone can call the API directly and see all returned fields. The server must limit output.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A public search API lets clients request any page size, and one call asking for a million records slows the server. What control is missing?',
        options: [
          'Better colours',
          'Maximum page size, rate limits, and request timeouts (resource consumption limits)',
          'More JSON fields',
          'A new domain'
        ],
        correctIndex: 1,
        explanation:
            'Unrestricted resource consumption lets a single client degrade the service. Enforce limits on size, rate, and time.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'API Security Test Plan and Hardened Endpoints',
      goal:
          'Create an API security test checklist and apply it to a small lab API, then fix the weaknesses you find.',
      steps: [
        'Build a small lab REST API (Flask or FastAPI) with users, notes, and an admin endpoint',
        'Write a test checklist based on the OWASP API Top 10 with at least 12 test cases',
        'Test BOLA by calling endpoints as user A with user B IDs, and test function-level access with a normal user on the admin endpoint',
        'Add explicit input and output schemas to remove mass assignment and excessive data exposure',
        'Add rate limiting, maximum page size, and request size limits',
        'Validate JWT signature, expiry, issuer, and audience, and write pytest tests for each rule',
      ],
      expectedOutput:
          'API Security Report (lab)\n\nChecklist: 12 cases | Initially failed: 7\n  BOLA on /notes/{id}: failed -> owner check added\n  Admin endpoint open to users: failed -> role check\n  Mass assignment of role: failed -> allow-listed fields\n  No rate limit: failed -> 60 req/min per user\n\nAfter fixes: 12/12 passed | pytest: 15 tests ✓',
      xpReward: 60,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 9
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l6_secure_sdlc_devsecops',
    topicTitle: 'Secure SDLC, Code Review & DevSecOps Testing',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 36,
    totalXp: 215,
    emoji: '🔁',
    intro:
        'Security works best when it is built into every stage of software development rather than bolted on at the end. This lesson covers the secure development lifecycle, how to review code for security, and how to automate security testing in a delivery pipeline.',
    concepts: [
      ConceptLesson(
        title: 'The Secure Software Development Lifecycle',
        definition:
            'A secure SDLC adds security activities to each phase of development: requirements, design, coding, testing, deployment, and maintenance. The aim is to find problems early, when they are cheapest to fix.',
        analogy:
            'It is quality control on a factory line. Checking each part as it is made is far cheaper than recalling finished products from customers.',
        example:
            'Security activities by phase:\n\nRequirements: security and privacy requirements, abuse cases\nDesign: threat modelling, secure design review\nCoding: secure coding standards, peer review, static analysis\nTesting: dynamic testing, dependency scanning, penetration testing\nRelease: configuration checks, secrets scanning, approvals\nOperations: monitoring, patching, incident response\n\nFrameworks to know:\n  OWASP SAMM and BSIMM (maturity models)\n  NIST SSDF (Secure Software Development Framework)\n  OWASP ASVS (Application Security Verification Standard)',
        keyTakeaway:
            'Shift left: the earlier a flaw is found, the cheaper and safer it is to fix. Use ASVS as a ready-made list of security requirements.',
      ),
      ConceptLesson(
        title: 'Security-Focused Code Review',
        definition:
            'A security code review looks specifically for weaknesses: how input enters, how it is validated, where it ends up, and whether access checks are present. A short checklist makes reviews faster and more consistent.',
        analogy:
            'It is proofreading with one question in mind: could this sentence be misunderstood or abused? A different mindset from checking spelling.',
        example:
            'Review questions:\n\nWhere does untrusted input enter? Is it validated and encoded?\nAre queries parameterised?\nIs every sensitive action authorised on the server?\nAre secrets kept out of the code and logs?\nIs error handling safe, with generic messages to users?\nAre dependencies up to date and necessary?\nAre cryptographic functions standard and used correctly?\nIs new code covered by tests, including abuse cases?\n\nHot spots: authentication, session, file handling, deserialisation, SQL, shell calls, redirects, and anything that parses external data.',
        keyTakeaway:
            'Follow the data: from every entry point, trace how it flows to every sink such as a query, command, file, or response.',
      ),
      ConceptLesson(
        title: 'SAST, DAST, SCA, and Secrets Scanning',
        definition:
            'Automated tools complement human review. SAST analyses source code, DAST tests a running application, SCA checks third-party components, and secrets scanning finds credentials in code and history.',
        analogy:
            'SAST reads the recipe for mistakes. DAST tastes the finished dish. SCA checks the ingredients for recalls. Secrets scanning checks that nobody left the safe combination in the recipe.',
        example:
            'Tool types and examples:\n\nSAST: Semgrep, Bandit (Python), CodeQL, SonarQube\nDAST: OWASP ZAP, Burp Suite\nSCA: pip-audit, npm audit, Dependabot, Trivy, OWASP Dependency-Check\nSecrets: gitleaks, trufflehog\nIaC and container scanning: Checkov, Trivy\nIAST: instrumentation during tests\n\nStrengths and limits:\n  SAST: early, precise location, but false positives and misses runtime issues\n  DAST: finds real running issues, but later and needs a deployed app\n  SCA: finds known dependency flaws only\n  None of them find every logic flaw',
        keyTakeaway:
            'Combine tool types. Each finds different problems, and none replaces human thinking about design and business logic.',
        codeSnippet:
            'bandit -r app/\npip-audit -r requirements.txt\ngitleaks detect --source .',
      ),
      ConceptLesson(
        title: 'DevSecOps: Security in the Pipeline',
        definition:
            'DevSecOps embeds automated security checks into the continuous integration and delivery pipeline so that every change is tested automatically, and unsafe changes are blocked or flagged before release.',
        analogy:
            'It is airport security built into the boarding process: every passenger and bag is checked automatically on the way to the gate, rather than after the plane has taken off.',
        example:
            'Example pipeline stages:\n\n1. Pre-commit: secrets scan and linters\n2. Pull request: SAST, dependency scan, unit and abuse-case tests, required review\n3. Build: container image scan, SBOM generation\n4. Deploy to staging: DAST baseline scan with ZAP\n5. Release gate: block on critical findings or unresolved high issues\n6. Production: monitoring, alerts, runtime protection\n\nPractical tips:\n  Fail the build only on findings that are reliable and important\n  Tune rules to reduce noise\n  Give developers clear, fast feedback inside their normal tools\n  Track metrics: findings per release and time to fix',
        keyTakeaway:
            'Make the secure way the easy way. Fast, accurate automated checks in the pipeline change developer habits more than reports ever do.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does shifting security left mean?',
        options: [
          'Moving security to the end of the project',
          'Doing security activities earlier in development, where flaws are cheaper to fix',
          'Removing security checks',
          'Moving the firewall to the left of the rack'
        ],
        correctIndex: 1,
        explanation:
            'Finding issues in requirements, design, and coding avoids expensive late fixes and production incidents.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which tool type tests a running application from the outside?',
        options: ['SAST', 'DAST', 'SCA', 'Linting'],
        correctIndex: 1,
        explanation:
            'Dynamic application security testing probes a deployed app, as ZAP does. SAST reads source code instead.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A secrets scanner finds an API key in the Git history from 6 months ago, although the file has since been deleted. What is the correct response?',
        options: [
          'Nothing, it was deleted',
          'Treat the key as compromised: revoke and rotate it, then clean or secure the history',
          'Rename the repository',
          'Make the key longer'
        ],
        correctIndex: 1,
        explanation:
            'Deleted files remain in version history. Anything that was committed should be considered exposed and rotated.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'The pipeline fails every build because SAST produces 400 low-confidence warnings, and developers start ignoring it. What is the best approach?',
        options: [
          'Remove all scanning',
          'Tune rules, set severity thresholds, baseline existing issues, and block only on high-confidence critical findings',
          'Increase the number of warnings',
          'Tell developers to work faster'
        ],
        correctIndex: 1,
        explanation:
            'Noise destroys trust. Tuning and clear thresholds keep the pipeline useful and respected.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'During code review you see a function that builds a file path from a request parameter and opens it. What is the key concern and fix?',
        options: [
          'Variable naming; rename it',
          'Path traversal: resolve the path, verify it stays inside the allowed directory, and prefer an allow-list of file identifiers',
          'File size; compress it',
          'Speed; add caching'
        ],
        correctIndex: 1,
        explanation:
            'Unchecked paths can reach files outside the intended folder. Canonicalise and restrict to an allow-listed location.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build a Security Pipeline for a Lab Project',
      goal:
          'Add automated security checks to a small project in GitHub Actions or a similar CI system.',
      steps: [
        'Create a small Python web project in a Git repository with tests and a requirements file',
        'Add a pre-commit hook or CI step running gitleaks for secrets scanning',
        'Add Bandit (SAST) and pip-audit (SCA) steps that fail on high severity findings',
        'Add a step that generates an SBOM or dependency list as a build artefact',
        'Add a ZAP baseline scan against a staging container started in the pipeline (lab or your own app only)',
        'Seed 3 deliberate issues, confirm the pipeline catches them, fix them, and document the results with screenshots',
      ],
      expectedOutput:
          'Pipeline Report (lab)\n\nStages: gitleaks -> bandit -> pip-audit -> tests -> SBOM -> ZAP baseline\n\nSeeded issues: hard-coded key (gitleaks fail), string-built SQL (bandit fail), vulnerable package (pip-audit fail)\nAfter fixes: pipeline green; ZAP baseline: 0 high, 2 medium (headers)\n\nWorkflow file and README committed ✓',
      xpReward: 60,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 10
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l6_appsec_capstone',
    topicTitle: 'Capstone: Secure Review & Hardening of a Vulnerable Web App',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Hard',
    estimatedMinutes: 50,
    totalXp: 250,
    emoji: '🏆',
    intro:
        'This is your Level 6 capstone. You will take a deliberately vulnerable application in your isolated lab through a full application security cycle: threat model, test, report, fix, and verify. The result is a professional case study that shows exactly what an application security engineer does.',
    concepts: [
      ConceptLesson(
        title: 'The Application Security Assessment Workflow',
        definition:
            'A structured assessment follows repeatable steps: understand the application, model threats, test systematically, validate and rate findings, report clearly, support fixes, and verify them.',
        analogy:
            'It is a structured medical examination: history, tests, diagnosis, treatment plan, and a follow-up check to confirm recovery.',
        example:
            'Workflow:\n\n1. Scope and authorisation (your lab: written RoE)\n2. Understand the app: features, roles, data, technologies, entry points\n3. Threat model the main flows with STRIDE\n4. Test: automated scans plus manual checks for each OWASP category\n5. Validate and rate: confirm findings, assign severity and priority\n6. Report: executive summary and technical findings\n7. Fix and retest\n8. Lessons learned and prevention (tests, pipeline checks, training)',
        keyTakeaway:
            'Following the same workflow every time makes your results complete, repeatable, and credible.',
      ),
      ConceptLesson(
        title: 'A Manual Testing Checklist by Category',
        definition:
            'Automated scanners find only part of the issues. A checklist built on the OWASP Top 10 and ASVS guides manual checks that cover logic and access control flaws.',
        analogy:
            'A pilot pre-flight checklist: tools help, but a human follows every step in order so nothing is missed.',
        example:
            'Checklist highlights (lab application only):\n\nAccess control: test each function with each role; try other users object IDs\nAuthentication: rate limits, error messages, reset flow, session regeneration\nInput handling: injection points in every parameter and header\nOutput handling: encoding in each page context; CSP and headers\nConfiguration: error pages, debug, directory listing, default accounts, TLS\nData: transport and storage protection, secrets in code and responses\nComponents: dependency versions and known CVEs\nBusiness logic: negative numbers, repeated actions, skipped steps\nLogging: are security events recorded and are they safe?',
        keyTakeaway:
            'Combine scanner output with a human checklist. Logic and authorisation flaws are where manual testing adds the most value.',
      ),
      ConceptLesson(
        title: 'Writing the Fix, the Test, and the Prevention',
        definition:
            'A complete remediation has three parts: fix the flaw, add a test so it cannot return, and add a preventive control so the whole class of issue is caught automatically next time.',
        analogy:
            'Repairing a leaking pipe, installing a gauge that alerts on future leaks, and changing the plumbing standard so new pipes are fitted correctly.',
        example:
            'Example for an IDOR finding:\n\nFix: add an ownership check in the data access function\nTest: automated cross-user test that must return 403 or 404\nPrevention: a shared authorisation helper plus a pipeline check that fails if routes lack an authorisation decorator\n\nExample for a vulnerable dependency:\n  Fix: update to the patched version\n  Test: run the full test suite\n  Prevention: Dependabot alerts and a pip-audit gate in CI',
        keyTakeaway:
            'Fix, test, prevent. This three-step habit is what turns one-off fixes into lasting improvement.',
      ),
      ConceptLesson(
        title: 'Presenting Your Work as a Portfolio Case Study',
        definition:
            'A well-written case study shows employers your process, not only your results. It should be safe to publish: no real data, no live targets, and clear statements that testing happened in an isolated lab.',
        analogy:
            'It is the before and after photo gallery of a renovation, with notes about the problems found and the methods used to solve them.',
        example:
            'Case study structure:\n\nTitle and one-paragraph summary\nLab setup and scope (isolated, intentionally vulnerable application)\nMethod: tools and checklists used\nFindings table: ID, title, OWASP category, severity, status\nTwo or three deep dives with evidence, fix, test, and prevention\nBefore and after metrics\nLessons learned and what you would do with more time\n\nPublishing tips:\n  Use a public repository or blog\n  Never include real credentials, personal data, or details of live systems\n  Credit the vulnerable app project you used',
        keyTakeaway:
            'A clear, honest case study is one of the strongest signals in a security hiring process. Make it easy to read and safe to share.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What are the three parts of a complete remediation?',
        options: [
          'Fix, test, and prevention',
          'Delete, ignore, and hide',
          'Rename, move, and copy',
          'Scan, scan, and scan'
        ],
        correctIndex: 0,
        explanation:
            'Fix the flaw, add a regression test, and add a control that catches the class of issue in future.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is manual testing still essential even with good scanners?',
        options: [
          'Scanners never find anything',
          'Scanners often miss logic and access control flaws that need understanding of the application',
          'Manual testing is faster than scanning',
          'Scanners are illegal'
        ],
        correctIndex: 1,
        explanation:
            'Authorisation and business logic weaknesses depend on context that tools cannot fully understand.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What must a published portfolio case study NOT contain?',
        options: [
          'A findings table',
          'Real credentials, personal data, or details of live systems you were not authorised to test',
          'Screenshots from your lab',
          'A lessons learned section'
        ],
        correctIndex: 1,
        explanation:
            'Protecting data and staying within authorised scope is part of professional ethics, including in portfolio work.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You found 25 issues in the lab app. Which order is the best way to present them?',
        options: [
          'In the order you happened to find them',
          'Grouped by OWASP category and sorted by risk, with the top 3 summarised for management',
          'Alphabetically',
          'Only the easiest ones'
        ],
        correctIndex: 1,
        explanation:
            'Risk-ordered and categorised findings help readers focus on what matters most.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'After fixing a stored XSS flaw, what extra step ensures it stays fixed?',
        options: [
          'Nothing',
          'Add an automated regression test and a CSP or lint rule that catches similar problems',
          'Delete the test environment',
          'Rename the page'
        ],
        correctIndex: 1,
        explanation:
            'Regression tests and preventive controls stop the same class of flaw from returning later.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title:
          'Level 6 Capstone: Application Security Assessment of a Lab Web App',
      goal:
          'Perform a complete application security assessment of an intentionally vulnerable application in your isolated lab, fix it, and publish a safe case study.',
      steps: [
        'Choose OWASP Juice Shop, DVWA, or WebGoat in your isolated lab, write a Rules of Engagement document, and take a clean snapshot',
        'Document the application: roles, features, data, technologies, and entry points',
        'Create a STRIDE threat model with a data flow diagram and at least 10 threats',
        'Run ZAP (passive and active) and Nikto, and review security headers, cookies, and TLS',
        'Manually test each OWASP Top 10 category using your checklist, and record at least 12 confirmed findings with evidence',
        'Rate each finding with CVSS or a simple severity and map it to OWASP and CWE',
        'Write the report: executive summary, scope, method, findings table, and 3 detailed deep dives',
        'Fix at least 6 issues in a copy of the app or in your own small reproduction, with regression tests',
        'Add a pipeline with SAST, SCA, secrets scanning, and a ZAP baseline to prevent regressions',
        'Publish a sanitised case study in a repository or blog, stating clearly it was done in an isolated lab',
      ],
      expectedOutput:
          'AppSec Case Study: Juice Shop (isolated lab)\n\nScope: lab only, written RoE\nThreat model: 14 threats across 6 flows\nFindings: 15 confirmed\n  A01 Broken Access Control x4 | A03 Injection x3 | A07 Auth failures x2 | A05 Misconfiguration x3 | A06 Components x2 | A02 Crypto x1\nSeverity: 3 critical, 6 high, 5 medium, 1 low\n\nFixes: 6 applied with regression tests (24 tests pass)\nPipeline: gitleaks, Bandit, pip-audit/npm audit, ZAP baseline ✓\n\nDeep dives: IDOR on orders, stored XSS in reviews, JWT validation weakness\nPublished sanitised case study with lessons learned ✓',
      xpReward: 95,
    ),
  ),
];
