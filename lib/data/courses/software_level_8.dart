// ══════════════════════════════════════════════════════════════════════
// lib/models/software_courses_level8.dart
// Software Engineering Learning Path — LEVEL 8: Web Fundamentals
// ════════════════════════════════════════════════════════════════════
import '../../models/course_content_data.dart';

const List<TopicCourse> softwareCoursesLevel8 = [
  TopicCourse(
    id: 'sep_l8_internet_basics',
    topicTitle: 'Internet Basics',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 200,
    emoji: '🌍',
    intro:
        'Every application you build runs on top of the internet. Whether you are building a mobile app, a web service, or a cloud system — understanding how the internet actually works at the protocol level is what separates engineers who debug network issues in minutes from those who guess for hours. This course demystifies the infrastructure your code runs on.',
    concepts: [
      ConceptLesson(
        title: 'How the Internet Works — The Big Picture',
        definition:
            'The internet is a global network of computers that communicate using standardised protocols. When you visit a website, your request travels through multiple layers: your device, your ISP, routers, servers, and back — all in milliseconds.',
        analogy:
            'The internet is like a global postal system. Your browser writes a letter (HTTP request), puts it in an envelope with the recipient\'s address (IP address), hands it to your local post office (ISP router), which passes it through sorting facilities (internet backbone routers) until it arrives at the destination post office (server), which reads the letter and sends a reply back.',
        example:
            'What happens when you type "google.com":\n1. DNS lookup: "google.com" → IP address 142.250.195.46\n2. TCP connection: your device connects to that IP on port 443\n3. TLS handshake: secure encrypted channel established\n4. HTTP request sent: "GET / HTTP/1.1"\n5. Server responds with HTML content\n6. Browser renders the page\nTotal time: typically 50-200ms',
        keyTakeaway:
            'Every web request goes through this exact sequence. Understanding each step is what lets you diagnose "why is this API call slow?" — is it DNS? TCP? TLS? Server processing? Network latency?',
      ),
      ConceptLesson(
        title: 'IP Addresses and DNS',
        definition:
            'Every device on the internet has an IP address (a unique numerical identifier). DNS (Domain Name System) is the internet\'s phone book — it translates human-readable domain names into IP addresses.',
        analogy:
            'DNS is exactly like your smartphone\'s contact list. You look up "Priya" and your phone finds her number (142.250.195.46). Without contacts, you would need to memorise everyone\'s phone number directly — DNS lets us use names instead of raw IP addresses.',
        example:
            'IPv4 address: 142.250.195.46 (4 numbers, 0-255, ~4 billion addresses)\nIPv6 address: 2001:0db8:85a3:0000:0000:8a2e:0370:7334 (128-bit, ~340 undecillion)\n\nDNS Lookup chain:\nbrowser cache → OS cache → router cache\n→ ISP DNS resolver → Root DNS → TLD server → Authoritative DNS\n→ Returns: google.com = 142.250.195.46\n→ Your browser caches this for TTL seconds',
        keyTakeaway:
            'IPv4 addresses are nearly exhausted — the world is slowly migrating to IPv6. As a developer, understanding that "domain name → IP" is a separate step (with its own latency and caching) helps you optimise application startup time.',
      ),
      ConceptLesson(
        title: 'TCP/IP — Reliable Data Transport',
        definition:
            'TCP (Transmission Control Protocol) ensures data arrives completely and in order, using a three-way handshake to establish connections and acknowledgements to confirm receipt. IP handles addressing and routing.',
        analogy:
            'TCP is like certified mail with a delivery confirmation: you send the package, the recipient must sign for it and send back confirmation. If no confirmation arrives, you resend. This guarantees delivery, but takes more time than dropping a letter in a box (UDP).',
        example:
            'TCP Three-Way Handshake:\n1. Client → Server: SYN (I want to connect)\n2. Server → Client: SYN-ACK (OK, I\'m ready)\n3. Client → Server: ACK (Great, let\'s communicate)\n\nThis takes one round-trip time (RTT) before any data can be sent.\nFor a server in the US from India: ~200ms just for the handshake!\n\nUDP (User Datagram Protocol): no handshake, no guaranteed delivery\n→ Used for: video calls, online games, DNS queries\n→ Fast but accepts occasional packet loss',
        keyTakeaway:
            'TCP\'s handshake is why HTTP/2 and HTTP/3 exist — newer protocols keep connections open (connection reuse) or use UDP underneath (QUIC in HTTP/3) to eliminate repeated handshake costs.',
      ),
      ConceptLesson(
        title: 'Ports and Protocols',
        definition:
            'A port is a numbered virtual endpoint on a server — different services listen on different ports. Well-known ports are standardised so clients always know where to connect.',
        analogy:
            'An IP address is like a company\'s main phone number. Ports are like department extensions — dial the main number then extension 80 for the web department, extension 443 for the secure web department, extension 22 for the IT support department.',
        example:
            'Common ports:\nPort 80    → HTTP (unencrypted web)\nPort 443   → HTTPS (encrypted web)\nPort 22    → SSH (secure shell, remote server access)\nPort 21    → FTP (file transfer)\nPort 25    → SMTP (email sending)\nPort 3306  → MySQL database\nPort 5432  → PostgreSQL database\nPort 6379  → Redis cache\nPort 27017 → MongoDB\n\nSecurity rule: database ports (3306, 5432) should NEVER\nbe exposed to the public internet.',
        keyTakeaway:
            'When you write a server that "listens on port 8000", you are claiming that port number on the machine. The operating system routes incoming connections on that port to your application.',
      ),
      ConceptLesson(
        title: 'Client-Server Architecture',
        definition:
            'The client-server model divides computing into two roles: clients (requesters — browsers, mobile apps) and servers (providers — web servers, APIs, databases). Most internet applications follow this model.',
        analogy:
            'Client-server is like a restaurant: the customer (client) decides what they want and places an order (request). The kitchen (server) does the heavy work of preparing the meal (processing) and delivers the result (response). The customer does not go into the kitchen.',
        example:
            'Web application layers:\nClient tier:  Browser (React, HTML/CSS/JS)\n              ↓ HTTP request\nServer tier:  Web server (Django, Express, Spring Boot)\n              ↓ SQL query\nData tier:    Database (PostgreSQL, MongoDB)\n\nMobile app layers:\nClient:  Flutter / React Native app\n         ↓ HTTPS API calls\nServer:  REST API (Node.js / FastAPI)\n         ↓ queries\nData:    Database + Redis cache',
        keyTakeaway:
            'Understanding which tier handles what logic is fundamental to system design. Business logic belongs on the server (never trusted from the client), presentation belongs on the client, and persistent data belongs in the data tier.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does DNS do?',
        options: [
          'Encrypts internet traffic',
          'Translates human-readable domain names into IP addresses',
          'Routes packets between routers',
          'Manages port assignments'
        ],
        correctIndex: 1,
        explanation:
            'DNS (Domain Name System) acts as the internet\'s phone book — converting names like "google.com" into machine-usable IP addresses like "142.250.195.46" so browsers know where to connect.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the purpose of the TCP three-way handshake?',
        options: [
          'To encrypt the connection',
          'To establish a reliable, mutually confirmed connection before any data is sent',
          'To resolve the server\'s IP address',
          'To select which port to use'
        ],
        correctIndex: 1,
        explanation:
            'The SYN → SYN-ACK → ACK handshake confirms both sides are ready to communicate and establishes sequence numbers for reliable, ordered data delivery — before any application data is transmitted.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should database ports like 3306 (MySQL) never be exposed to the public internet?',
        options: [
          'Databases are too slow to handle internet traffic',
          'Attackers can directly attempt to authenticate, exploit vulnerabilities, or run denial-of-service attacks against the database',
          'Database ports only work on local networks',
          'It is only a convention, not a real security concern'
        ],
        correctIndex: 1,
        explanation:
            'Exposing database ports publicly allows anyone on the internet to attempt logins, exploit known vulnerabilities, and exfiltrate all your data. Databases should only be accessible from your application server on a private network.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A user complains that your website loads in 600ms for them in Mumbai but only 80ms for users in London where your server is. What is the PRIMARY cause?',
        options: [
          'The user\'s computer is slower',
          'Network latency — the physical distance between Mumbai and London means packets take ~100ms each way, adding 200ms+ to every request',
          'The database queries are slow',
          'JavaScript is blocking the render'
        ],
        correctIndex: 1,
        explanation:
            'Light travels through fiber optic cables at roughly 200,000 km/s. Mumbai to London is ~7,200 km — one round trip takes ~72ms minimum, just for physics. Multiple round trips (DNS, TCP handshake, TLS, request) add up to hundreds of milliseconds.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You are building a live multiplayer game that can tolerate occasional dropped frames but must minimise latency. TCP or UDP?',
        options: [
          'TCP — it guarantees every packet arrives',
          'UDP — no handshake, no retransmission, lower latency even if occasional packets are lost',
          'Both are equivalent for games',
          'Neither — games use a different protocol'
        ],
        correctIndex: 1,
        explanation:
            'Online games choose UDP because TCP\'s guaranteed delivery can cause "head-of-line blocking" — waiting for one dropped packet while later packets queue up. For games, a slightly outdated position is better than a delayed but complete one.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Network Diagnostic Tool',
      goal:
          'Build a Python tool that demonstrates internet fundamentals: DNS resolution, TCP connection, and latency measurement.',
      steps: [
        'Write a dns_lookup(domain) function using socket.getaddrinfo() to resolve a domain to IP addresses',
        'Write a tcp_ping(host, port) function that measures how long a TCP connection takes to establish (time the connect())',
        'Measure TCP connection time to google.com:443, github.com:443, and a server in a different country',
        'Write a traceroute_simple(host) that uses increasing TTL values to identify each hop on the path',
        'Print a formatted report showing: domain, resolved IP, TCP connection time, and number of hops',
        'Identify which step (DNS, TCP handshake) contributes most latency in your results',
      ],
      expectedOutput:
          'DNS Resolution:\n  google.com → 142.250.195.46 (2.3ms)\n  github.com → 140.82.121.4 (3.1ms)\n\nTCP Connection Times:\n  google.com:443 → 18ms\n  github.com:443 → 22ms\n\nHop count to google.com: 8 hops\nConclusion: DNS is fast (cached), TCP handshake dominates latency',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'sep_l8_http',
    topicTitle: 'HTTP',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 32,
    totalXp: 210,
    emoji: '📡',
    intro:
        'HTTP is the language of the web. Every API call, every web page load, every file download uses HTTP. Understanding HTTP deeply — methods, status codes, headers, and the request-response cycle — is the foundation for building any web application, API, or web service.',
    concepts: [
      ConceptLesson(
        title: 'The HTTP Request-Response Cycle',
        definition:
            'HTTP (HyperText Transfer Protocol) works as a request-response protocol: the client sends a request with a method, URL, headers, and optional body; the server processes it and returns a response with a status code, headers, and optional body.',
        analogy:
            'HTTP is like ordering at a restaurant by written form. You fill out: what you want (method), from where (URL), any special requirements (headers), and details (body). The waiter returns: whether they can fulfil it (status code), any notes (headers), and the food itself (response body).',
        example:
            '=== HTTP REQUEST ===\nGET /api/users/123 HTTP/1.1\nHost: api.example.com\nAuthorization: Bearer eyJhbGci...\nAccept: application/json\n\n=== HTTP RESPONSE ===\nHTTP/1.1 200 OK\nContent-Type: application/json\nContent-Length: 87\n\n{"id": 123, "name": "Alice", "email": "alice@example.com"}',
        keyTakeaway:
            'HTTP is stateless — each request is completely independent. The server has no memory of previous requests. This is why authentication tokens must be sent with EVERY request, not just once.',
      ),
      ConceptLesson(
        title: 'HTTP Methods (Verbs)',
        definition:
            'HTTP methods indicate the intended action: GET (retrieve), POST (create), PUT (replace), PATCH (partial update), DELETE (remove). Using the correct method is what makes an API semantic and predictable.',
        analogy:
            'HTTP methods are like the actions on a file manager: GET opens a file, POST creates a new file, PUT replaces a file entirely with a new version, PATCH edits specific lines in a file, DELETE removes the file.',
        example:
            'GET    /api/products         → list all products\nGET    /api/products/42      → get product with id 42\nPOST   /api/products         → create a new product (body has data)\nPUT    /api/products/42      → REPLACE product 42 entirely\nPATCH  /api/products/42      → UPDATE specific fields of product 42\nDELETE /api/products/42      → delete product 42\n\nSafe methods (no side effects): GET, HEAD, OPTIONS\nIdempotent (same result if called multiple times): GET, PUT, DELETE',
        keyTakeaway:
            'Using GET for operations that modify data is a serious design mistake — GET requests are cached, bookmarked, and clicked without warning. Destructive actions must use POST, PUT, PATCH, or DELETE.',
      ),
      ConceptLesson(
        title: 'HTTP Status Codes',
        definition:
            'Status codes are 3-digit numbers in every HTTP response indicating the outcome: 2xx (success), 3xx (redirect), 4xx (client error — the request was wrong), 5xx (server error — the server failed).',
        analogy:
            'Status codes are like a concise outcome signal from the waiter: "200" means your order arrived perfectly, "404" means we do not have that dish, "401" means members only — please show your card, "500" means the kitchen caught fire.',
        example:
            '200 OK              → success\n201 Created         → new resource created (after POST)\n204 No Content      → success with no body (after DELETE)\n301 Moved Permanently → resource URL changed permanently\n302 Found           → temporary redirect\n400 Bad Request     → invalid input from client\n401 Unauthorized    → not authenticated\n403 Forbidden       → authenticated but not allowed\n404 Not Found       → resource does not exist\n409 Conflict        → conflict with current state\n422 Unprocessable   → validation error\n429 Too Many Requests → rate limited\n500 Internal Server Error → server crashed\n503 Service Unavailable → server overloaded or down',
        keyTakeaway:
            'The 401 vs 403 distinction is critical: 401 means "I do not know who you are" (not authenticated). 403 means "I know who you are, but you are not allowed" (not authorized). Using the wrong one misleads clients and security tools.',
      ),
      ConceptLesson(
        title: 'HTTP Headers',
        definition:
            'Headers are key-value metadata attached to requests and responses — carrying information about content type, authentication, caching, encoding, and much more.',
        analogy:
            'HTTP headers are like the labels and stamps on a package — the package itself is the body, but the labels tell the carrier (and recipient) the content type, whether fragile, return address, customs info, and delivery instructions.',
        example:
            '# Common Request Headers:\nAuthorization: Bearer <token>     # who you are\nContent-Type: application/json     # what format you are sending\nAccept: application/json           # what format you want back\nUser-Agent: Mozilla/5.0...         # what client is making the request\nIf-None-Match: "abc123"            # cache validation\n\n# Common Response Headers:\nContent-Type: application/json     # what format the body is\nCache-Control: max-age=3600        # how long to cache\nSet-Cookie: session=xyz; HttpOnly  # set a cookie\nX-RateLimit-Remaining: 42          # how many requests left\nAccess-Control-Allow-Origin: *     # CORS permission',
        keyTakeaway:
            'Content-Type is one of the most important headers. Sending JSON with Content-Type: text/html or forgetting it entirely causes APIs to misparse requests and return confusing errors.',
      ),
      ConceptLesson(
        title: 'HTTP/1.1 vs HTTP/2 vs HTTP/3',
        definition:
            'HTTP has evolved to fix performance bottlenecks: HTTP/2 adds multiplexing (multiple requests over one connection), header compression, and server push. HTTP/3 uses QUIC (UDP-based) to eliminate TCP head-of-line blocking.',
        analogy:
            'HTTP/1.1 is like a single-lane road — one car (request) at a time per lane. HTTP/2 is a multi-lane highway — many cars travel simultaneously on the same road. HTTP/3 is a teleportation system — it eliminates the road entirely for some bottlenecks.',
        example:
            'HTTP/1.1 problem: loading 50 assets requires 50 sequential requests\n→ or multiple TCP connections (expensive)\n\nHTTP/2 solution: all 50 assets over ONE connection, simultaneously\n→ multiplexing: no waiting for earlier requests to finish\n→ header compression: repeated headers sent once\n\nHTTP/3 solution: uses UDP + QUIC protocol\n→ connection establishment: 0 round trips (0-RTT resumption)\n→ no TCP head-of-line blocking\n→ better performance on lossy networks (mobile)',
        keyTakeaway:
            'Most modern browsers and servers support HTTP/2 automatically. You benefit from HTTP/2\'s multiplexing without changing your application code — but knowing why it exists helps you understand performance trade-offs.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the key difference between HTTP 401 and 403?',
        options: [
          'They are the same error',
          '401 means not authenticated (server does not know who you are); 403 means authenticated but not authorized (server knows who you are but denies access)',
          '401 is a server error; 403 is a client error',
          '401 only applies to admin routes'
        ],
        correctIndex: 1,
        explanation:
            '401 (Unauthorized) means the request lacks valid authentication credentials — "please log in." 403 (Forbidden) means credentials are valid but the authenticated user lacks permission — "you do not have access to this resource."',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What HTTP method should be used to PARTIALLY update a resource (e.g. change only the email field of a user)?',
        options: [
          'POST',
          'PUT — it replaces the whole resource',
          'PATCH — designed for partial updates',
          'GET with query parameters'
        ],
        correctIndex: 2,
        explanation:
            'PATCH is specifically designed for partial updates — sending only the fields you want to change. PUT replaces the entire resource, meaning you must send ALL fields even if only one changed.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is HTTP considered "stateless"?',
        options: [
          'It cannot handle state changes',
          'Each HTTP request is independent — the server has no memory of previous requests, so authentication must be sent with every single request',
          'HTTP cannot store data',
          'Servers delete state after each response'
        ],
        correctIndex: 1,
        explanation:
            'HTTP\'s stateless nature means every request starts fresh with zero context. This is why you send your auth token with every API call — the server has no automatic memory of your previous authenticated requests.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A developer uses GET /api/users/delete?id=5 to delete a user. What is wrong with this design?',
        options: [
          'Nothing — GET with query parameters is valid',
          'GET is a safe, cacheable method — browsers, proxies, and crawlers can trigger it unintentionally. Delete actions must use the DELETE method to signal intent and prevent accidental execution',
          'The URL format is incorrect',
          'DELETE requests cannot include an id parameter'
        ],
        correctIndex: 1,
        explanation:
            'GET requests are considered "safe" — they should never modify state. Search engines crawl GET links, browsers prefetch them, and caches store them. A delete action on a GET URL can be accidentally triggered, causing data loss.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your API returns 200 OK with body {"error": "User not found"}. What is wrong?',
        options: [
          'Nothing — 200 with an error message is fine',
          'The status code contradicts the body. A missing user should return 404 Not Found, not 200 OK — clients check the status code first and many will treat 200 as success without reading the body',
          'The error message format is incorrect',
          'You should use 500 instead'
        ],
        correctIndex: 1,
        explanation:
            'HTTP status codes are the machine-readable signal. Returning 200 with an error in the body breaks every standard client, monitoring tool, and load balancer that relies on status codes to detect errors. Use 404 for "not found".',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'HTTP Request Inspector',
      goal:
          'Build a tool that makes HTTP requests, inspects responses, and demonstrates proper use of methods, headers, and status codes.',
      steps: [
        'Use Python\'s requests library to make GET, POST, PUT, PATCH, and DELETE requests to a public test API (e.g. https://jsonplaceholder.typicode.com)',
        'Print the full request details: method, URL, headers sent',
        'Print the full response details: status code, status meaning, response headers, and body',
        'Trigger a 404 (request a non-existent resource) and a 201 (POST to create something) and show the different status codes',
        'Set custom headers (Accept: application/json, a fake Authorization token) and verify they appear in the request',
        'Build a helper function that checks status code ranges and prints: "2xx: Success", "4xx: Client Error", "5xx: Server Error"',
      ],
      expectedOutput:
          'GET /posts/1 → 200 OK\n  Content-Type: application/json\n  Body: {"id": 1, "title": "...", ...}\n\nPOST /posts → 201 Created\n  Body: {"id": 101, "title": "My Post", ...}\n\nGET /posts/99999 → 404 Not Found\n  Category: 4xx Client Error\n\nDELETE /posts/1 → 200 OK\n  Category: 2xx Success',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'sep_l8_https',
    topicTitle: 'HTTPS',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 28,
    totalXp: 200,
    emoji: '🔐',
    intro:
        'Every website that handles passwords, payment data, or personal information MUST use HTTPS. Understanding how TLS encryption works, what certificates are, and what common security vulnerabilities look like is no longer optional for any web developer. Browsers now actively warn users about HTTP sites.',
    concepts: [
      ConceptLesson(
        title: 'Why HTTP is Dangerous Without S',
        definition:
            'Plain HTTP transmits all data — including passwords, cookies, and personal information — as readable text. Anyone on the same network (coffee shop WiFi, corporate network, ISP) can read, intercept, or modify this traffic.',
        analogy:
            'Sending data over HTTP is like sending a postcard through the mail — every postal worker, sorting machine operator, and mail carrier who touches it can read the message. HTTPS puts that postcard inside a sealed, tamper-evident envelope that only the recipient can open.',
        example:
            'On an unsecured WiFi network, with HTTP:\nAttacker uses Wireshark and sees:\nPOST /login HTTP/1.1\nHost: bank.example.com\n\nusername=alice&password=SuperSecret123\n\nWith HTTPS: attacker sees only random encrypted bytes\nNo username, no password, nothing useful.',
        keyTakeaway:
            'Never transmit passwords, tokens, or personal data over HTTP — even on "internal" networks. HTTP provides zero confidentiality or integrity. HTTPS is the minimum required baseline for any real application.',
      ),
      ConceptLesson(
        title: 'TLS — How HTTPS Actually Works',
        definition:
            'TLS (Transport Layer Security) encrypts HTTP traffic using asymmetric encryption for the handshake (establishing a shared secret) and symmetric encryption for the actual data transfer.',
        analogy:
            'TLS is like two strangers agreeing on a secret code in public without revealing the code itself. They use a mathematical trick (public-key cryptography) to establish a shared secret that eavesdroppers cannot determine — then use that secret to encrypt all future messages.',
        example:
            'TLS Handshake (simplified):\n1. Client → Server: "Hello, I support TLS 1.3, these cipher suites..."\n2. Server → Client: Certificate (public key + identity), selected cipher\n3. Client: Verifies certificate is signed by trusted CA\n4. Both: Use Diffie-Hellman key exchange to derive shared secret\n5. Both: Switch to symmetric encryption using shared secret\n6. All subsequent HTTP data is encrypted with symmetric key\n\nAsymmetric (RSA/ECDH): slow, used only for handshake\nSymmetric (AES-256): fast, used for all actual data',
        keyTakeaway:
            'TLS protects three things: confidentiality (nobody can read it), integrity (nobody can modify it undetected), and authentication (you are talking to who you think you are — via certificates).',
      ),
      ConceptLesson(
        title: 'SSL Certificates and Certificate Authorities',
        definition:
            'An SSL/TLS certificate proves that a server is who it claims to be — signed by a trusted Certificate Authority (CA) that your browser pre-trusts. Without this, you cannot be sure you are talking to the real server.',
        analogy:
            'A certificate is like a government-issued ID card. Your browser trusts certain governments (Certificate Authorities) the way you trust the government that issued an ID. If the ID is signed by a trusted authority, you trust it. A self-signed certificate is like an ID card you printed yourself — visually similar but not trustworthy.',
        example:
            'Certificate contains:\n  Subject: *.google.com\n  Issued by: Google Trust Services (CA)\n  Valid from: Jan 1, 2024\n  Valid until: Dec 31, 2024\n  Public key: (used in handshake)\n  Signature: (CA\'s digital signature proving authenticity)\n\nFree certificates: Let\'s Encrypt (auto-renewing, 90 days)\nPaid EV certificates: Extended Validation, shows company name\n\nSelf-signed: only for local development, never production',
        keyTakeaway:
            'Let\'s Encrypt revolutionised web security by providing free, automated TLS certificates — there is no longer any excuse for running HTTP in production. Tools like Certbot automate the entire process.',
      ),
      ConceptLesson(
        title: 'Common HTTPS Pitfalls',
        definition:
            'Even with HTTPS enabled, common mistakes can undermine security: mixed content (HTTP resources on an HTTPS page), missing HSTS header, certificate expiry, and weak cipher suites.',
        analogy:
            'HTTPS pitfalls are like having a secure vault but leaving the key under the doormat (weak cipher), forgetting to renew the security system subscription (expired certificate), or securing the front door while leaving a window open (mixed content).',
        example:
            '# Mixed Content Error (browser blocks this):\n# HTTPS page loading an HTTP resource:\n<img src="http://cdn.example.com/image.jpg">\n# Browser says: "This page is not fully secure"\n\n# HSTS Header (tell browsers to ALWAYS use HTTPS):\nStrict-Transport-Security: max-age=31536000; includeSubDomains\n\n# Certificate expired:\ncurl https://example.com\n# curl: (60) SSL certificate problem: certificate has expired\n\n# Check certificate expiry:\nopenssl s_client -connect example.com:443 | openssl x509 -noout -dates',
        keyTakeaway:
            'Set up automated certificate renewal (Let\'s Encrypt + Certbot renews automatically). Add HSTS headers. Audit for mixed content. Run your domain through SSL Labs (ssllabs.com/ssltest) — it grades your HTTPS configuration.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What are the three security guarantees that TLS provides?',
        options: [
          'Speed, reliability, and compression',
          'Confidentiality (encrypted), integrity (unmodified), and authentication (server identity verified)',
          'Authentication, authorisation, and accounting',
          'Encryption, backup, and redundancy'
        ],
        correctIndex: 1,
        explanation:
            'TLS provides: Confidentiality (data is encrypted, nobody can read it), Integrity (any tampering is detected via message authentication codes), and Authentication (certificates prove the server is who it claims to be).',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is a self-signed certificate not trusted by browsers in production?',
        options: [
          'Self-signed certificates use weaker encryption',
          'Browsers only trust certificates signed by pre-trusted Certificate Authorities — a self-signed certificate has no third-party verification of identity',
          'Self-signed certificates expire after 24 hours',
          'They only work on port 8443'
        ],
        correctIndex: 1,
        explanation:
            'The trust chain relies on CAs that browsers pre-trust. A self-signed cert is signed by you — the same entity claiming the identity — which proves nothing about who you actually are. Browsers show a security warning.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is "mixed content" in HTTPS and why is it dangerous?',
        options: [
          'Mixing HTML and JavaScript on the same page',
          'Loading HTTP resources (images, scripts) on an HTTPS page — attackers can intercept and replace those HTTP resources even though the page itself is secure',
          'Using both GET and POST on the same page',
          'Having both internal and external links'
        ],
        correctIndex: 1,
        explanation:
            'Mixed content breaks the security model — if a script loads over HTTP on an HTTPS page, an attacker can intercept and replace that script with malicious code, compromising the entire page even though the HTML was delivered securely.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A user connects to your web app from a coffee shop WiFi. The site uses HTTPS with a valid certificate. What can the coffee shop WiFi operator see?',
        options: [
          'All request and response data including passwords',
          'Only the domain name (from DNS and SNI) and connection timing — the actual content is fully encrypted',
          'Only the file sizes but not the content',
          'Nothing at all including the domain name'
        ],
        correctIndex: 1,
        explanation:
            'With HTTPS, the network operator can see which domain you connected to (from DNS queries and TLS SNI) and how much data was transferred, but the actual HTTP requests, responses, and any data (including passwords) are encrypted and unreadable.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your API certificate expired at midnight. At 12:01 AM, users start getting connection errors. What is the immediate fix and long-term prevention?',
        options: [
          'Restart the server — certificates auto-renew on restart',
          'Immediate: renew the certificate manually (certbot renew). Long-term: set up automatic renewal (certbot renews 30 days before expiry) and monitor expiry dates with alerts',
          'Switch to HTTP temporarily until the new certificate arrives',
          'Ask users to disable certificate checking in their browser'
        ],
        correctIndex: 1,
        explanation:
            'Certificate expiry is a common, entirely preventable outage. Let\'s Encrypt certificates renew automatically with certbot running as a cron job. Set up monitoring alerts at 30 days and 7 days before expiry as a backup.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'HTTPS Security Auditor',
      goal:
          'Build a tool that checks a website\'s HTTPS configuration and identifies common security issues.',
      steps: [
        'Write a function check_certificate(domain) using ssl module to retrieve and display certificate details: subject, issuer, expiry date, days until expiry',
        'Flag certificates expiring within 30 days with a WARNING and within 7 days with CRITICAL',
        'Check for HSTS header in the response and report its presence and max-age value',
        'Check if the server redirects HTTP to HTTPS (make an HTTP request and check for 301/302 redirect)',
        'Check for mixed content by scanning the HTML response for http:// in src and href attributes',
        'Print a formatted security report with PASS/WARN/FAIL status for each check',
      ],
      expectedOutput:
          'HTTPS Security Report for: github.com\n\n[PASS] Certificate valid: expires in 287 days\n[PASS] Issuer: DigiCert Inc\n[PASS] HSTS enabled: max-age=31536000; includeSubDomains\n[PASS] HTTP → HTTPS redirect: 301 Moved Permanently\n[PASS] No mixed content detected\n\nOverall: 5/5 checks passed ✓',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'sep_l8_rest_apis',
    topicTitle: 'REST APIs',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 35,
    totalXp: 225,
    emoji: '🔌',
    intro:
        'REST APIs are the universal language that lets applications communicate — your mobile app talks to your backend, your backend talks to payment providers, and third-party services talk to each other, all using REST. Building well-designed REST APIs is one of the most in-demand backend skills in the industry.',
    concepts: [
      ConceptLesson(
        title: 'What is REST?',
        definition:
            'REST (Representational State Transfer) is an architectural style for web APIs based on 6 constraints: stateless, client-server, cacheable, uniform interface, layered system, and code-on-demand (optional).',
        analogy:
            'REST is like the standard rules of chess — not a specific implementation, but a set of constraints that, when followed, produce systems that are predictable, interoperable, and understood by everyone who knows the rules.',
        example:
            'A RESTful API treats everything as a "resource" with a URL:\n/users            → the users collection\n/users/42          → user with id 42\n/users/42/orders   → orders belonging to user 42\n/products          → the products collection\n/products/7        → product with id 7\n\nHTTP methods define actions on those resources:\nGET /users/42      → read user 42\nPUT /users/42      → replace user 42\nDELETE /users/42   → delete user 42',
        keyTakeaway:
            'REST is NOT a protocol or standard — it is a set of design principles. An API can call itself "RESTful" without fully following all constraints. The key insight is that URLs identify resources and HTTP methods define actions.',
      ),
      ConceptLesson(
        title: 'Designing RESTful URL Structure',
        definition:
            'Good REST URL design uses nouns (not verbs) for resources, hierarchical structure to show relationships, and plural names for collections.',
        analogy:
            'REST URLs are like an organised filing system path: /company/engineering/backend/projects/47 tells you exactly where project 47 is in the hierarchy — company → department → team → projects → specific project.',
        example:
            '# GOOD REST URL Design:\nGET    /api/v1/products                # list all products\nGET    /api/v1/products/42             # get product 42\nPOST   /api/v1/products                # create product\nPATCH  /api/v1/products/42            # update product 42\nDELETE /api/v1/products/42            # delete product 42\nGET    /api/v1/products/42/reviews    # reviews for product 42\n\n# BAD REST URL Design (verbs in URL):\nPOST   /api/getProduct?id=42\nPOST   /api/deleteUser\nGET    /api/createOrder\nPOST   /api/updateProductPrice',
        keyTakeaway:
            'The verb belongs in the HTTP method, not the URL. /api/deleteUser is not RESTful — /api/users/42 with DELETE method is. Versioning (/api/v1/) allows breaking changes without breaking existing clients.',
      ),
      ConceptLesson(
        title: 'Request and Response Format',
        definition:
            'REST APIs almost universally use JSON for request and response bodies, with Content-Type: application/json headers. A consistent response structure makes APIs predictable and easy to integrate.',
        analogy:
            'A consistent API response format is like a standardised restaurant order ticket — the same format every time means any staff member can read any ticket without training, and the kitchen always knows exactly what to do.',
        example:
            '# Consistent success response:\n{\n  "success": true,\n  "data": {\n    "id": 42,\n    "name": "Alice",\n    "email": "alice@example.com"\n  }\n}\n\n# Consistent error response:\n{\n  "success": false,\n  "error": {\n    "code": "VALIDATION_ERROR",\n    "message": "Email is required",\n    "details": [\n      {"field": "email", "issue": "must not be empty"}\n    ]\n  }\n}',
        keyTakeaway:
            'Design your error response format FIRST and use it consistently everywhere. Developers integrating your API should be able to write one error-handling function that works for all endpoints.',
      ),
      ConceptLesson(
        title: 'Pagination, Filtering and Sorting',
        definition:
            'APIs returning large datasets must support pagination (limiting results per page), filtering (returning only matching items), and sorting (ordering results) — all via query parameters.',
        analogy:
            'Pagination is like a library catalogue that returns 20 results per page — you do not download the entire catalogue (millions of records) to find one book. You search (filter), sort, and navigate page by page.',
        example:
            '# Pagination:\nGET /api/products?page=2&limit=20\nGET /api/products?offset=40&limit=20\n\n# Filtering:\nGET /api/products?category=electronics&min_price=500&max_price=5000\nGET /api/orders?status=pending&customer_id=42\n\n# Sorting:\nGET /api/products?sort=price&order=asc\nGET /api/products?sort=-created_at  # minus = descending\n\n# Response includes pagination metadata:\n{\n  "data": [...],\n  "pagination": {\n    "total": 847,\n    "page": 2,\n    "limit": 20,\n    "total_pages": 43\n  }\n}',
        keyTakeaway:
            'Never return unlimited results from an API — even if a table has only 100 rows today, it may have 10 million in a year. Always paginate from the start; adding it later is a breaking change for existing clients.',
      ),
      ConceptLesson(
        title: 'API Versioning and Documentation',
        definition:
            'API versioning allows you to make breaking changes without breaking existing clients. Documentation (OpenAPI/Swagger) makes your API self-describing and enables automatic client generation.',
        analogy:
            'API versioning is like software updates that let users stay on v1 until they are ready to migrate to v2 — you do not force everyone to upgrade the moment you need to change something.',
        example:
            '# Versioning strategies:\n# URL versioning (most common):\nGET /api/v1/users   # old clients keep using v1\nGET /api/v2/users   # new clients use v2 with new schema\n\n# Header versioning:\nGET /api/users\nAPI-Version: 2\n\n# OpenAPI (Swagger) documentation:\nopenapi: "3.0.0"\ninfo:\n  title: Product API\n  version: "1.0"\npaths:\n  /products:\n    get:\n      summary: List all products\n      parameters:\n        - name: page\n          in: query\n          schema:\n            type: integer',
        keyTakeaway:
            'OpenAPI/Swagger documentation is not optional for professional APIs — it enables automatic client SDK generation, interactive testing (Swagger UI), and makes your API self-documenting. Many teams generate it automatically from code annotations.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the correct REST design for an endpoint that creates a new user?',
        options: [
          'GET /api/createUser',
          'POST /api/users (body contains user data)',
          'POST /api/createUser',
          'PUT /api/newUser'
        ],
        correctIndex: 1,
        explanation:
            'REST uses nouns for URLs (/api/users = the users collection) and HTTP methods for actions (POST = create). The action "create" belongs in the method, not the URL.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why should REST APIs always include pagination?',
        options: [
          'It is required by the HTTP specification',
          'Returning unlimited results can return millions of rows, crashing clients and overwhelming servers — pagination limits data per request from the start',
          'Pagination is only needed for databases with more than 1000 rows',
          'It makes the API stateful'
        ],
        correctIndex: 1,
        explanation:
            'Datasets that are small today grow over time. Adding pagination later is a breaking change. Designing it in from the start limits response size, protects server resources, and gives clients predictable, manageable chunks of data.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the purpose of API versioning (/api/v1/, /api/v2/)?',
        options: [
          'To track how many times the API has been updated',
          'To allow breaking changes in v2 without breaking existing clients still using v1',
          'Versioning is only for documentation',
          'To add security to older API versions'
        ],
        correctIndex: 1,
        explanation:
            'API versioning lets you evolve your API (change field names, remove endpoints, change response structures) in v2 while existing clients that depend on v1\'s contract continue working unchanged until they migrate.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A mobile app sends GET /api/getAllProductsForCurrentUserBasedOnPreferences. What is wrong with this URL and how would you redesign it?',
        options: [
          'Nothing is wrong — descriptive names are good',
          'The URL uses verbs and is not resource-based. Redesign: GET /api/v1/products?user_id={id}&recommended=true — noun-based resource URL with filter parameters',
          'GET requests cannot have this many characters',
          'The URL needs more path segments'
        ],
        correctIndex: 1,
        explanation:
            'REST URLs identify resources, not operations. The verb-based name violates REST principles. /products is the resource; filtering, recommendation logic, and user context belong as query parameters or are implied by the authentication context.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your API currently returns {"name": "Alice", "email": "..."} for GET /users/42. You need to add a "full_name" field and remove "name". Existing mobile apps break. What should you have done?',
        options: [
          'Notify all users by email before changing',
          'Introduce API versioning: keep v1 unchanged, add the new schema in v2 — existing apps use v1, new apps use v2, migrate v1 clients on their timeline',
          'Change the response immediately — developers should update their apps',
          'Add full_name alongside name (never remove fields)'
        ],
        correctIndex: 1,
        explanation:
            'Removing or renaming fields is a breaking change. Proper versioning (v1 stays as-is, new schema in v2) lets you evolve the API without forcing immediate client updates. At minimum, add new fields without removing old ones for backward compatibility.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'RESTful Product API',
      goal:
          'Design and build a complete REST API for a product catalogue following all REST best practices.',
      steps: [
        'Build a FastAPI or Flask REST API with these endpoints: GET/POST /api/v1/products, GET/PATCH/DELETE /api/v1/products/{id}, GET /api/v1/products/{id}/reviews',
        'Implement pagination on the list endpoint with page and limit query parameters',
        'Implement filtering by category and price range, and sorting by price or created_at',
        'Use consistent JSON response structure with a "data" key for success and an "error" object for errors',
        'Return correct HTTP status codes: 200 for GET, 201 for POST, 204 for DELETE, 404 when not found, 422 for validation errors',
        'Write an OpenAPI-compatible docstring or YAML spec documenting at least 3 endpoints',
      ],
      expectedOutput:
          'GET /api/v1/products?page=1&limit=3&category=electronics&sort=price\n→ 200 OK\n{\n  "data": [product1, product2, product3],\n  "pagination": {"total": 47, "page": 1, "limit": 3, "total_pages": 16}\n}\n\nPOST /api/v1/products (missing name field)\n→ 422 Unprocessable Entity\n{"success": false, "error": {"code": "VALIDATION_ERROR", "message": "name is required"}}',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'sep_l8_json',
    topicTitle: 'JSON',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 185,
    emoji: '📄',
    intro:
        'JSON (JavaScript Object Notation) is the universal data interchange format of the modern web. APIs, configuration files, databases, and log files all use JSON. Understanding JSON deeply — including parsing, serialisation, schema validation, and common pitfalls — is a foundational skill for every software engineer.',
    concepts: [
      ConceptLesson(
        title: 'JSON Syntax and Data Types',
        definition:
            'JSON is a lightweight text format with 6 data types: string, number, boolean, null, array, and object. It is human-readable, language-independent, and easy for machines to parse.',
        analogy:
            'JSON is like a universal shipping label format that all couriers worldwide agreed to use — every company (programming language) can read and write it without translation, making it the de facto standard for data exchange.',
        example:
            '{\n  "id": 42,\n  "name": "Alice Kumar",\n  "age": 25,\n  "is_active": true,\n  "balance": 1234.56,\n  "address": null,\n  "tags": ["developer", "python", "backend"],\n  "profile": {\n    "avatar_url": "https://example.com/alice.jpg",\n    "bio": "Software engineer at TechCorp"\n  }\n}\n\nJSON types:\n  string:  "text in quotes"\n  number:  42, 3.14, -7 (no integer/float distinction)\n  boolean: true, false (lowercase)\n  null:    null (lowercase)\n  array:   [1, "two", true, null]\n  object:  {"key": "value"}',
        keyTakeaway:
            'JSON has NO date type — dates must be strings (ISO 8601: "2024-06-15T10:30:00Z" is the universal standard). JSON numbers have no integer/float distinction — "42" and "42.0" are both "number".',
      ),
      ConceptLesson(
        title: 'Parsing and Serialising JSON in Python',
        definition:
            'Parsing converts a JSON string into a Python object. Serialising (dumping) converts a Python object into a JSON string. Python\'s built-in json module handles both.',
        analogy:
            'Parsing JSON is like translating a letter from French to English. Serialising is translating from English to French. The json module is the bilingual translator that works in both directions.',
        example:
            'import json\n\n# Parse JSON string → Python object\njson_string = \'{"name": "Alice", "age": 25}\'\ndata = json.loads(json_string)\nprint(data["name"])  # Alice\nprint(type(data))    # <class \'dict\'>\n\n# Serialise Python object → JSON string\nuser = {"name": "Bob", "scores": [95, 87, 91], "active": True}\njson_output = json.dumps(user, indent=2)\nprint(json_output)\n\n# Read JSON file\nwith open("config.json") as f:\n    config = json.load(f)  # note: load not loads\n\n# Write JSON file\nwith open("output.json", "w") as f:\n    json.dump(data, f, indent=2)',
        keyTakeaway:
            'json.loads() parses a STRING. json.load() parses a FILE. json.dumps() serialises to a STRING. json.dump() serialises to a FILE. The s stands for "string" — mix these up and you get TypeErrors.',
        codeSnippet:
            'import json\nfrom datetime import datetime\n\n# Custom serialiser for types JSON cannot handle natively\ndef custom_serialiser(obj):\n    if isinstance(obj, datetime):\n        return obj.isoformat()\n    raise TypeError(f"Object of type {type(obj)} is not serialisable")\n\ndata = {"name": "Alice", "created_at": datetime.now()}\njson.dumps(data, default=custom_serialiser)',
      ),
      ConceptLesson(
        title: 'Common JSON Pitfalls',
        definition:
            'The most common JSON mistakes: trailing commas (invalid JSON), single quotes instead of double quotes, undefined/NaN/Infinity (not valid JSON), and unhandled None/null differences between languages.',
        analogy:
            'JSON syntax is strict like formal English grammar — a misplaced comma, wrong quote type, or unsupported word breaks the entire document, even if a human would understand the intent.',
        example:
            '// INVALID JSON (common mistakes):\n{\n  "name": \'Alice\',    // single quotes not allowed\n  "value": undefined, // undefined is not JSON\n  "count": NaN,       // NaN is not valid JSON\n  "tags": [1, 2, 3,], // trailing comma not allowed\n}\n\n// VALID JSON:\n{\n  "name": "Alice",\n  "value": null,\n  "count": 0,\n  "tags": [1, 2, 3]\n}\n\n# Python: json.dumps(None) → "null" (correct)\n# Python: json.dumps(float("nan")) → raises ValueError (by default)',
        keyTakeaway:
            'Always validate JSON with a linter or json.loads() before sending it. A single trailing comma or single quote character makes the entire document unparseable — json.loads() raises a clear JSONDecodeError.',
      ),
      ConceptLesson(
        title: 'JSON Schema Validation',
        definition:
            'JSON Schema defines the expected structure, types, and constraints of a JSON document — used to validate API requests and responses before processing them.',
        analogy:
            'JSON Schema is like a customs form template — it defines exactly what fields are required, what type each field must be, and what valid values look like. Any package (JSON document) not matching the template is rejected at the border (API boundary).',
        example:
            'from jsonschema import validate, ValidationError\n\nschema = {\n    "type": "object",\n    "required": ["name", "email", "age"],\n    "properties": {\n        "name": {"type": "string", "minLength": 2, "maxLength": 50},\n        "email": {"type": "string", "format": "email"},\n        "age": {"type": "integer", "minimum": 0, "maximum": 150}\n    }\n}\n\ntry:\n    validate({"name": "Alice", "email": "alice@mail.com", "age": 25}, schema)\n    print("Valid!")\nexcept ValidationError as e:\n    print(f"Invalid: {e.message}")',
        keyTakeaway:
            'Validate all external JSON input (from users, third-party APIs, webhooks) against a schema before processing. Never assume untrusted JSON is well-formed or safe to use directly.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the correct JSON representation of a Python None value?',
        options: ['"None"', 'undefined', 'null', 'false'],
        correctIndex: 2,
        explanation:
            'JSON uses lowercase "null" for the absence of a value. Python\'s "None" and JavaScript\'s "null" both serialize to JSON "null". "undefined" does not exist in JSON.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why does JSON not have a native date type?',
        options: [
          'Dates are too complex for text format',
          'JSON was designed to be minimal and language-independent — dates are represented as ISO 8601 strings ("2024-06-15T10:30:00Z") since all languages can parse that format',
          'Dates were added in JSON version 2',
          'You must use Unix timestamps only'
        ],
        correctIndex: 1,
        explanation:
            'JSON\'s design deliberately excluded dates to remain simple and truly language-agnostic. The convention is ISO 8601 strings — a format all programming languages can parse and that is human-readable.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the difference between json.loads() and json.load() in Python?',
        options: [
          'loads() is faster than load()',
          'loads() parses a JSON string; load() parses from a file object',
          'load() works with nested objects; loads() does not',
          'They are identical — either can be used'
        ],
        correctIndex: 1,
        explanation:
            'json.loads(string) parses a JSON string ("s" for string). json.load(file_object) reads and parses JSON from a file. Using the wrong one causes a TypeError.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'import json\ndata = {"name": "Alice", "scores": [95, 87]}\njson_str = json.dumps(data)\ndata2 = json.loads(json_str)\nprint(data2["scores"][1])',
        options: ['95', '87', '"87"', 'IndexError'],
        correctIndex: 1,
        explanation:
            'json.dumps() serializes to string, json.loads() parses back to dict. scores is a list [95, 87]. Index [1] is the second element: 87.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A third-party webhook sends you JSON. Before processing the "amount" field for a payment, what should you always do?',
        options: [
          'Trust it and process immediately — third parties are reliable',
          'Validate the JSON against a schema first: check "amount" is a number, is positive, and exists — reject and log invalid payloads',
          'Convert it to a string first for safety',
          'Only validate if the amount is over ₹10,000'
        ],
        correctIndex: 1,
        explanation:
            'Never trust external JSON without validation — malformed payloads, missing fields, or wrong types can cause crashes or security issues. Schema validation at the entry point is the standard defence.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'JSON Configuration and Validation System',
      goal:
          'Build a system that reads, validates, transforms, and writes JSON configuration files.',
      steps: [
        'Create a config.json file with nested structure: app settings, database settings, feature flags, and a list of allowed IP addresses',
        'Write a load_config(path) function using json.load() with proper error handling for FileNotFoundError and json.JSONDecodeError',
        'Define a JSON Schema for the config file and validate loaded config against it using jsonschema',
        'Implement update_config(path, key_path, value) that modifies a nested key (e.g. "database.port" = 5433) and writes back',
        'Handle the datetime serialisation problem: add a last_updated field using datetime.now() with a custom serialiser',
        'Pretty-print the final config with json.dumps(indent=2, sort_keys=True)',
      ],
      expectedOutput:
          'config.json loaded ✓\nSchema validation: PASS\nUpdating database.port to 5433...\nConfig saved with last_updated: "2026-06-19T14:30:00.123456"\n\nFinal config:\n{\n  "app": {"name": "MyAPI", "debug": false},\n  "database": {"host": "localhost", "port": 5433},\n  "last_updated": "2026-06-19T14:30:00.123456"\n}',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'sep_l8_authentication',
    topicTitle: 'Authentication',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 38,
    totalXp: 240,
    emoji: '🪪',
    intro:
        'Authentication is how software systems verify identity — "who are you?" Every login flow, every API key, every JWT token is authentication in action. Getting authentication wrong is one of the most costly security mistakes a company can make. This course teaches you to implement it correctly from the ground up.',
    concepts: [
      ConceptLesson(
        title: 'Authentication vs Authorization — The Crucial Difference',
        definition:
            'Authentication answers "Who are you?" (verifying identity). Authorization answers "What are you allowed to do?" (verifying permissions). These are separate steps that must both be implemented.',
        analogy:
            'Authentication is the passport control at an airport — verifying your identity. Authorization is the boarding gate check — verifying you have a ticket for this specific flight. You can be authenticated (valid passport) but not authorized (no ticket for that flight).',
        example:
            '# Without Authentication: anyone can call the API\nGET /api/users/42 → returns user data (no check!)\n\n# With Authentication only:\nGET /api/users/42 + JWT token → verified you are "Alice"\n\n# With Authentication + Authorization:\nGET /api/users/42 + JWT token (Alice)\n→ Alice can read her own profile (authorized)\n→ Alice cannot read Bob\'s profile (not authorized)\n→ Admin can read any profile (authorized for all)',
        keyTakeaway:
            '401 Unauthorized actually means "not authenticated" (confusing name). 403 Forbidden means "authenticated but not authorized." This naming is a historical mistake in HTTP, but the distinction matters enormously in security design.',
      ),
      ConceptLesson(
        title: 'Password Hashing — Never Store Plain Text',
        definition:
            'Passwords must NEVER be stored in plain text or with reversible encryption — only as hashed values using a slow, salted algorithm like bcrypt, Argon2, or scrypt.',
        analogy:
            'Hashing a password is like turning a secret message into a unique fingerprint — you can verify "is this the same message?" by comparing fingerprints, but you cannot reconstruct the original message from the fingerprint alone.',
        example:
            'import bcrypt\n\n# When user registers:\npassword = "SecretPassword123"\nhashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt(rounds=12))\n# Store hashed in database — NEVER the plain password\n\n# When user logs in:\nentered_password = "SecretPassword123"\nif bcrypt.checkpw(entered_password.encode(), hashed):\n    print("Login successful")\nelse:\n    print("Invalid password")\n\n# Why bcrypt is slow (rounds=12):\n# Deliberate slowness prevents brute-force attacks\n# 12 rounds ≈ 0.3 seconds per hash check — acceptable for login\n# but too slow for an attacker checking millions of passwords',
        keyTakeaway:
            'If your database is ever breached, hashed passwords with bcrypt (cost factor 12+) mean attackers cannot recover plain passwords within a useful timeframe. MD5 and SHA-1 hashed passwords are recoverable in seconds — never use them for passwords.',
      ),
      ConceptLesson(
        title: 'Session-Based Authentication',
        definition:
            'Session-based auth stores session data server-side after login, giving the client an opaque session ID cookie. Each request the server looks up the session ID to find who is logged in.',
        analogy:
            'Session auth is like a coat check at a restaurant. You give your coat (credentials) at the door, they give you a numbered token (session cookie). On each return visit you show the token — they look up your coat — no need to verify your identity again on every visit.',
        example:
            '# Login flow:\nPOST /login  {email, password}\n→ Server: verifies credentials, creates session in Redis/DB\n→ Server: SET-Cookie: session_id=abc123xyz; HttpOnly; Secure\n→ Client: stores cookie automatically\n\n# Subsequent requests:\nGET /api/profile\nCookie: session_id=abc123xyz\n→ Server: looks up "abc123xyz" in session store\n→ Finds: {user_id: 42, role: "admin"}\n→ Processes request as user 42\n\n# Logout:\nDELETE /logout\n→ Server: deletes session from store\n→ Cookie becomes invalid immediately',
        keyTakeaway:
            'Session cookies must have HttpOnly (not accessible to JavaScript — prevents XSS theft) and Secure (only sent over HTTPS) flags. SameSite=Strict or Lax prevents CSRF attacks.',
      ),
      ConceptLesson(
        title: 'JWT — Token-Based Authentication',
        definition:
            'JSON Web Tokens (JWTs) are self-contained tokens that encode user information and are cryptographically signed — the server can verify them without a database lookup, making them ideal for stateless APIs and microservices.',
        analogy:
            'A JWT is like a signed government identity card — it contains your information (user ID, role, expiry) and a cryptographic seal that anyone holding the government\'s public key can verify is genuine. No need to call the government\'s office to verify it each time.',
        example:
            'JWT Structure: header.payload.signature\n\nHeader (base64): {"alg": "HS256", "typ": "JWT"}\nPayload (base64): {\n  "sub": "42",         # user ID\n  "name": "Alice",\n  "role": "admin",\n  "iat": 1719000000,   # issued at\n  "exp": 1719086400    # expires at\n}\nSignature: HMACSHA256(base64(header) + "." + base64(payload), secret)\n\nimport jwt\ntoken = jwt.encode({"sub": "42", "exp": ...}, SECRET_KEY, algorithm="HS256")\ndecoded = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])',
        keyTakeaway:
            'JWT payload is BASE64 ENCODED, not encrypted — anyone can decode and read it. Never put sensitive data (passwords, credit card numbers) in a JWT payload. Sign with a strong secret and always verify the signature.',
      ),
      ConceptLesson(
        title: 'OAuth 2.0 and Social Login',
        definition:
            'OAuth 2.0 is an authorization framework that lets users grant third-party applications limited access to their accounts on another service — the foundation of "Sign in with Google/GitHub/Facebook".',
        analogy:
            'OAuth is like giving a valet your car key. You hand over a special "valet key" (access token) that only allows driving within the car park (limited scope) — you never give them your master key (your password) and can revoke the valet key any time.',
        example:
            '"Sign in with Google" OAuth flow:\n1. User clicks "Sign in with Google"\n2. Your app redirects to Google\'s OAuth server\n3. User approves: "Allow MyApp to access your email?"\n4. Google redirects back with authorization code\n5. Your server exchanges code for access token (server-to-server)\n6. Your server uses access token to call Google API: "who is this?"\n7. Google returns: {id, email, name, picture}\n8. Your server creates/finds local user account\n9. Your server issues YOUR app\'s session/JWT',
        keyTakeaway:
            'With OAuth social login, you NEVER see the user\'s Google/Facebook password — you only get a token with limited scope. This reduces your security surface area dramatically. Use a library (python-social-auth, Auth0, Firebase Auth) rather than implementing OAuth from scratch.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why must passwords be hashed with bcrypt instead of MD5 or SHA-256?',
        options: [
          'bcrypt produces longer hashes',
          'bcrypt is intentionally slow and salted, making brute-force attacks computationally infeasible — MD5/SHA-256 are too fast, making them unsuitable for password hashing',
          'MD5 and SHA-256 are not supported in Python',
          'bcrypt does not require a secret key'
        ],
        correctIndex: 1,
        explanation:
            'bcrypt\'s deliberate slowness (configurable rounds) means checking millions of passwords takes impractically long. MD5/SHA-256 can hash billions of passwords per second on modern GPUs — making brute-force and rainbow table attacks trivially fast.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the HttpOnly flag on a session cookie prevent?',
        options: [
          'The cookie from being sent over HTTP',
          'JavaScript from accessing the cookie — preventing Cross-Site Scripting (XSS) attacks from stealing the session token',
          'The cookie from expiring',
          'Third-party websites from reading it'
        ],
        correctIndex: 1,
        explanation:
            'HttpOnly cookies are inaccessible to JavaScript (document.cookie cannot read them). This means even if an XSS vulnerability exists, malicious scripts cannot steal the session token — it can only be sent automatically by the browser with HTTP requests.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A JWT payload contains {"user_id": 42, "role": "admin"}. Is this data secret?',
        options: [
          'Yes — JWTs are fully encrypted',
          'No — JWT payloads are base64 encoded (not encrypted) and can be decoded by anyone. Only the SIGNATURE is cryptographically protected',
          'Yes — only the server can read it',
          'No — JWTs contain no real data'
        ],
        correctIndex: 1,
        explanation:
            'JWT payloads are base64 encoded, not encrypted — paste any JWT into jwt.io and you can read the payload immediately. The signature only proves the payload has not been TAMPERED with, not that it is confidential.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A developer stores passwords as MD5(password) in the database. The database is breached. How quickly can an attacker recover the passwords?',
        options: [
          'Never — MD5 is a one-way hash',
          'Very quickly — MD5 can hash billions of passwords per second on a GPU, and rainbow tables pre-compute MD5 hashes for millions of common passwords',
          'Only if they know the original passwords',
          'In about 100 years using brute force'
        ],
        correctIndex: 1,
        explanation:
            'MD5 was designed for speed — GPUs can check billions of MD5 hashes per second. Most common passwords are recovered within minutes using precomputed rainbow tables or a dictionary attack. MD5 for passwords is a critical security vulnerability.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your JWT has exp (expiry) set 30 days in the future. A user\'s account is compromised and you need to invalidate their token immediately. Can you?',
        options: [
          'Yes — just delete the JWT from the database',
          'No — JWTs are stateless. Since the server has no session store to check, a valid JWT with a future expiry date cannot be individually revoked without adding a token blacklist or switching to short-lived tokens',
          'Yes — rotate the signing secret',
          'Yes — call a JWT invalidation API'
        ],
        correctIndex: 1,
        explanation:
            'This is the core JWT trade-off: no server-side state means no revocation. Solutions: use short-lived JWTs (15 min) with refresh tokens, maintain a token blacklist in Redis, or switch to session-based auth for scenarios requiring immediate revocation.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Secure Authentication System',
      goal:
          'Build a complete authentication system with registration, login, JWT tokens, and protected routes.',
      steps: [
        'Create POST /api/auth/register: accept email+password, validate, hash password with bcrypt (rounds=12), save user to database',
        'Create POST /api/auth/login: verify credentials with bcrypt.checkpw(), issue a JWT token with user_id, role, iat, exp (24h)',
        'Create GET /api/profile: protected endpoint — verify JWT from Authorization header, return user data if valid, 401 if missing/invalid',
        'Implement a middleware/decorator that extracts and validates the JWT for protected routes',
        'Return proper error responses: 400 for validation errors, 401 for bad credentials, 422 for missing fields',
        'Demonstrate: register, login (get token), use token for profile, use expired/invalid token (expect 401)',
      ],
      expectedOutput:
          'POST /register: {"email": "alice@mail.com", "password": "..."}\n→ 201 Created: {"message": "User created"}\n\nPOST /login: {"email": "alice@mail.com", "password": "..."}\n→ 200 OK: {"token": "eyJhbGci..."}\n\nGET /profile (with token)\n→ 200 OK: {"id": 1, "email": "alice@mail.com", "role": "user"}\n\nGET /profile (no token)\n→ 401 Unauthorized: {"error": "Authentication required"}',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'sep_l8_authorization',
    topicTitle: 'Authorization',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 32,
    totalXp: 230,
    emoji: '🛡️',
    intro:
        'Authentication tells you WHO someone is. Authorization controls WHAT they can do. Without proper authorization, every authenticated user can access everything — a catastrophic security failure. This course covers Role-Based Access Control, permission systems, and the principle of least privilege that guides every serious security implementation.',
    concepts: [
      ConceptLesson(
        title: 'Role-Based Access Control (RBAC)',
        definition:
            'RBAC assigns permissions to roles, then assigns roles to users. Instead of granting individual permissions to each user, you define roles (admin, manager, customer) and each role has a set of allowed actions.',
        analogy:
            'RBAC is like job titles in a company — the "Finance Manager" role has access to accounting systems by default. You do not configure each finance manager\'s access individually; you assign the role and they inherit all its permissions automatically.',
        example:
            'Roles and permissions:\n\nrole: "customer"\n  permissions: [read_own_profile, read_products,\n                create_own_orders, read_own_orders]\n\nrole: "support_agent"\n  permissions: [read_any_customer_profile,\n                read_any_order, update_order_status]\n\nrole: "admin"\n  permissions: [* -- all permissions]\n\nUser assignment:\n  Alice → role: "admin"\n  Bob   → role: "support_agent"\n  Carol → role: "customer"',
        keyTakeaway:
            'RBAC makes permission management scalable — when you add a new "vendor" feature, you just update the "vendor" role\'s permission list. All vendors automatically gain or lose access without individual changes.',
      ),
      ConceptLesson(
        title: 'The Principle of Least Privilege',
        definition:
            'Every user, service, and process should have only the minimum permissions needed to perform its function — nothing more. This limits the damage from breaches, mistakes, and compromised accounts.',
        analogy:
            'Least privilege is like giving a delivery person only the key to the mailroom, not the master key to the entire building. If that key is copied or lost, the damage is limited to the mailroom — not every room in the building.',
        example:
            'Violating least privilege:\n  Customer can read ALL users\' orders (should only read their own)\n  Reporting service has write access to the production database\n  All developers have admin access to production\n\nFollowing least privilege:\n  Customer can only read WHERE customer_id = their own ID\n  Reporting service has read-only access to a replica database\n  Developers have read-only production access; only deploy pipeline writes\n  API service account can only read/write specific tables it needs',
        keyTakeaway:
            'The principle of least privilege is why database roles, API scopes, and file permissions exist. Design every access control with "what is the minimum needed?" as the first question.',
      ),
      ConceptLesson(
        title: 'Resource-Level Authorization',
        definition:
            'Authorization must be checked not just at the route level ("can this user access /orders") but at the resource level ("can this user access THIS specific order") — preventing Insecure Direct Object Reference (IDOR) vulnerabilities.',
        analogy:
            'Route-level authorization is like checking if someone has a library card. Resource-level authorization is checking if THAT specific card has borrowing rights for THIS specific book in THIS specific restricted collection.',
        example:
            '# Route-level check (not enough!):\n@require_auth  # checks: is user logged in?\ndef get_order(order_id):\n    return Order.get(order_id)  # BUG: any logged-in user can get any order!\n\n# Resource-level check (correct):\n@require_auth\ndef get_order(order_id, current_user):\n    order = Order.get(order_id)\n    if order is None:\n        return 404\n    # KEY: verify this user owns this specific order\n    if order.customer_id != current_user.id and current_user.role != "admin":\n        return 403  # authenticated but not authorized for THIS resource\n    return order',
        keyTakeaway:
            'IDOR (Insecure Direct Object Reference) is in the OWASP Top 10 every year — it is one of the most common API vulnerabilities. Always verify that the authenticated user is allowed to access the SPECIFIC resource they are requesting.',
      ),
      ConceptLesson(
        title: 'JWT Claims for Authorization',
        definition:
            'JWT tokens can carry authorization information (role, permissions, scopes) as claims in the payload — allowing stateless authorization checks without a database lookup on every request.',
        analogy:
            'JWT claims for authorization are like an access badge that has all your permissions printed on it — instead of calling HR on every door swipe, the badge reader checks the badge directly for the specific permission needed.',
        example:
            '# JWT payload with authorization claims:\n{\n  "sub": "42",         # user ID\n  "email": "alice@example.com",\n  "role": "admin",\n  "permissions": ["read:users", "write:users", "delete:users"],\n  "exp": 1719086400\n}\n\n# Authorization middleware:\ndef require_permission(permission):\n    def decorator(func):\n        def wrapper(current_user, *args):\n            if permission not in current_user.get("permissions", []):\n                return {"error": "Forbidden"}, 403\n            return func(current_user, *args)\n        return wrapper\n    return decorator\n\n@require_permission("delete:users")\ndef delete_user(user_id, current_user):\n    User.delete(user_id)',
        keyTakeaway:
            'Including role/permissions in JWTs enables fully stateless authorization — no database call needed per request. Trade-off: permission changes only take effect when the token expires and a new one is issued.',
      ),
      ConceptLesson(
        title: 'Common Authorization Vulnerabilities',
        definition:
            'The most common authorization failures: missing authorization checks entirely, horizontal privilege escalation (accessing another user\'s data), vertical privilege escalation (gaining higher role than granted), and mass assignment (updating fields you should not control).',
        analogy:
            'Authorization vulnerabilities are like security gaps in a building: a missing check is an unlocked door; horizontal escalation is using your keycard to open your neighbour\'s hotel room; vertical escalation is somehow gaining a master key; mass assignment is filling in fields on a form that should not be user-editable.',
        example:
            '# Mass assignment vulnerability:\n# User sends: {"name": "Alice", "role": "admin"}\n# Vulnerable code:\nuser.update(**request.json)  # sets role: "admin"!\n\n# Fix: whitelist allowed fields:\nallowed_fields = {"name", "email", "bio"}  # NOT "role"\nupdate_data = {k: v for k, v in request.json.items()\n               if k in allowed_fields}\nuser.update(**update_data)',
        keyTakeaway:
            'Never blindly update a model from user-submitted JSON. Always whitelist the fields that users are permitted to update. "role", "is_admin", "balance", and "id" should never be user-settable fields.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the difference between route-level and resource-level authorization?',
        options: [
          'They are the same thing',
          'Route-level checks if the user can access a type of endpoint; resource-level verifies the user is allowed to access THIS SPECIFIC resource (e.g. their own order, not any order)',
          'Route-level is for admins; resource-level is for regular users',
          'Route-level is checked at the database; resource-level at the API'
        ],
        correctIndex: 1,
        explanation:
            'Route-level alone is insufficient — it lets any authenticated user access any resource of that type. Resource-level authorization verifies ownership or permission for the specific item being accessed, preventing IDOR vulnerabilities.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is "mass assignment" vulnerability?',
        options: [
          'Assigning roles to many users at once',
          'When an API blindly applies all user-submitted JSON fields to a model, allowing users to set fields they should not control (like "role" or "is_admin")',
          'Assigning too many permissions to one role',
          'A type of DDoS attack on authorization systems'
        ],
        correctIndex: 1,
        explanation:
            'Mass assignment happens when code like model.update(**request.body) applies all submitted fields without filtering. A user can submit {"role": "admin"} and gain admin rights. Whitelisting updatable fields is the fix.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the principle of least privilege?',
        options: [
          'New users should start with no permissions at all',
          'Every user, service, and process should have only the minimum permissions needed for their specific function — nothing more',
          'Admin users should have limited privileges',
          'Privileges should be assigned randomly for security'
        ],
        correctIndex: 1,
        explanation:
            'Least privilege limits blast radius — a compromised account or buggy service can only damage what it has permission to access. If a service only needs to read one table, it should have read access to only that table.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'GET /api/orders/1234 is called by User Bob (user_id=99). Order 1234 belongs to Alice (user_id=42). Bob is authenticated but NOT an admin. What should the response be?',
        options: [
          '200 OK — Bob is authenticated, so he can read any order',
          '403 Forbidden — Bob is authenticated but not authorized to access Alice\'s specific order',
          '404 Not Found — hide the existence of the order',
          '401 Unauthorized — Bob needs to log in again'
        ],
        correctIndex: 1,
        explanation:
            '403 Forbidden is correct — Bob is authenticated (401 would be wrong) but not authorized to access this specific resource. Some security-conscious APIs return 404 to hide that the resource exists, but 403 is the semantic standard.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A user submits: PATCH /api/users/42 with body {"name": "New Name", "role": "admin", "balance": 99999}. Your code does user.update(**request.json). What is the security risk?',
        options: [
          'No risk — PATCH is safe by definition',
          'Mass assignment vulnerability — the user can set their own role to "admin" and balance to ₹99,999, gaining unauthorized privileges and resources',
          'The request is too large',
          'PATCH cannot update multiple fields at once'
        ],
        correctIndex: 1,
        explanation:
            'Without field whitelisting, the user writes arbitrary fields to their profile including sensitive fields like "role" and "balance". Always filter user input to only the fields they are explicitly permitted to change.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Role-Based Access Control System',
      goal:
          'Implement a complete RBAC authorization system on top of the authentication system from the previous course.',
      steps: [
        'Define 3 roles with permissions: customer (read own orders, read products), support (read any order, update order status), admin (all permissions)',
        'Store role in the JWT token payload and implement require_role(role) and require_permission(permission) decorators',
        'Apply resource-level authorization: customers can only GET /orders/{id} for orders belonging to them',
        'Implement whitelist-based PATCH for user profile — only allow name, bio, avatar fields to be updated (block role, balance, id)',
        'Test all authorization cases: correct access, horizontal escalation attempt, vertical escalation attempt, mass assignment attempt',
        'Return consistent 401/403 responses with clear error messages',
      ],
      expectedOutput:
          'Customer reads own order → 200 OK ✓\nCustomer reads another\'s order → 403 Forbidden ✓\nCustomer tries role="admin" → 403 Forbidden (whitelist blocks it) ✓\nSupport reads any order → 200 OK ✓\nSupport deletes order (no permission) → 403 Forbidden ✓\nAdmin does everything → 200 OK ✓\nAll 6 authorization cases pass ✓',
      xpReward: 60,
    ),
  ),
];
