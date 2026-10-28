// ══════════════════════════════════════════════════════════════════════
// lib/models/software_courses_level10.dart
// Software Engineering Learning Path — LEVEL 10: Professional Engineering & Interview Mastery
// ══════════════════════════════════════════════════════════════════════
import '../../models/course_content_data.dart';

const List<TopicCourse> softwareCoursesLevel10 = [
  TopicCourse(
    id: 'sep_l10_advanced_dsa',
    topicTitle: 'Advanced DSA for Interviews',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 45,
    totalXp: 280,
    emoji: '🧠',
    intro:
        'Cracking FAANG and top product company interviews requires mastering advanced problem-solving patterns beyond basic data structures. Trie optimisations, segment trees, union-find, monotonic stacks, and bit manipulation are the patterns that appear in senior-level rounds at Google, Amazon, Microsoft, and top Indian unicorns like Swiggy, Zepto, and CRED.',
    concepts: [
      ConceptLesson(
        title: 'Problem Pattern Recognition',
        definition:
            'Top interview performers do not memorise solutions — they recognise PATTERNS. Given a problem, identifying the right pattern (sliding window, two pointer, BFS, DP, greedy) determines the solution path in seconds.',
        analogy:
            'A chess grandmaster does not calculate every move from scratch — they recognise board patterns and apply known strategies instantly. Pattern recognition in DSA works exactly the same way.',
        example:
            'Pattern signals to look for:\n\n"Subarray/substring with condition" → Sliding Window\n"Pair in sorted array" → Two Pointers\n"Shortest path unweighted" → BFS\n"All paths / combinations" → Backtracking\n"Optimal substructure" → DP\n"Greedy local choice works" → Greedy\n"Hierarchy / cycles" → Graph DFS\n"Range queries" → Segment Tree / BIT\n"Disjoint sets / connected components" → Union-Find',
        keyTakeaway:
            'Before writing a single line of code in an interview, spend 3-5 minutes identifying the pattern. State it aloud: "This looks like a sliding window problem because we need a subarray satisfying a condition." Interviewers reward this structured thinking.',
      ),
      ConceptLesson(
        title: 'Monotonic Stack — O(n) Solutions',
        definition:
            'A monotonic stack maintains elements in either strictly increasing or decreasing order. It solves "next greater element", "largest rectangle in histogram", and "trapping rain water" in O(n) instead of O(n²).',
        analogy:
            'A monotonic stack is like a queue at a concert where shorter people leave when a taller person arrives — you always maintain a "view" from the back without rescanning everyone.',
        example:
            '# Next Greater Element — O(n) with monotonic stack\ndef next_greater(arr):\n    result = [-1] * len(arr)\n    stack = []  # stores indices, decreasing order of values\n    for i, val in enumerate(arr):\n        while stack and arr[stack[-1]] < val:\n            idx = stack.pop()\n            result[idx] = val   # val is next greater for idx\n        stack.append(i)\n    return result\n\n# arr = [2, 1, 5, 3, 4]\n# result = [5, 5, -1, 4, -1]',
        keyTakeaway:
            'Monotonic stack turns O(n²) brute force solutions into O(n). Whenever you see "find next/previous greater/smaller element" in an interview, monotonic stack is the answer.',
        codeSnippet:
            '# Largest Rectangle in Histogram — classic FAANG problem\ndef largest_rectangle(heights):\n    stack, max_area = [], 0\n    heights.append(0)  # sentinel\n    for i, h in enumerate(heights):\n        start = i\n        while stack and stack[-1][1] > h:\n            idx, ht = stack.pop()\n            max_area = max(max_area, ht * (i - idx))\n            start = idx\n        stack.append((start, h))\n    return max_area',
      ),
      ConceptLesson(
        title: 'Union-Find (Disjoint Set Union)',
        definition:
            'Union-Find maintains a collection of disjoint sets with near-O(1) union and find operations using path compression and union by rank — essential for cycle detection, Kruskal\'s MST, and connected component problems.',
        analogy:
            'Union-Find is like tracking which sports teams are in the same league — you can instantly check if two teams share a league, and merge leagues when they combine, without rebuilding the entire structure.',
        example:
            'class UnionFind:\n    def __init__(self, n):\n        self.parent = list(range(n))\n        self.rank = [0] * n\n\n    def find(self, x):  # path compression\n        if self.parent[x] != x:\n            self.parent[x] = self.find(self.parent[x])\n        return self.parent[x]\n\n    def union(self, x, y):  # union by rank\n        px, py = self.find(x), self.find(y)\n        if px == py: return False  # already connected\n        if self.rank[px] < self.rank[py]: px, py = py, px\n        self.parent[py] = px\n        if self.rank[px] == self.rank[py]:\n            self.rank[px] += 1\n        return True',
        keyTakeaway:
            'With path compression and union by rank, both find() and union() run in near O(1) amortized time. Union-Find is the go-to structure for any "connected components" or "cycle detection" interview problem.',
      ),
      ConceptLesson(
        title: 'Bit Manipulation Tricks',
        definition:
            'Bit manipulation solves problems directly on binary representations — finding single numbers, counting set bits, checking powers of 2, and generating subsets, all in O(1) or O(n) with zero extra space.',
        analogy:
            'Bit manipulation is like reading a barcode directly instead of scanning the product — you work with the raw binary information, bypassing all layers of abstraction for maximum speed.',
        example:
            '# Common bit tricks:\nn & (n-1)  # clears the lowest set bit (check power of 2: n & (n-1) == 0)\nn & (-n)   # isolates the lowest set bit\nn ^ n == 0 # XOR with itself is 0\na ^ b ^ a == b  # XOR is its own inverse\n\n# Find single number (all others appear twice) — O(n) O(1)\ndef single_number(nums):\n    result = 0\n    for n in nums: result ^= n\n    return result\n\n# Count set bits\ndef count_bits(n):\n    count = 0\n    while n:\n        n &= (n - 1)  # clear lowest set bit\n        count += 1\n    return count',
        keyTakeaway:
            'Bit manipulation is a force multiplier — problems that seem to require O(n) space can often be solved in O(1) using XOR, AND, OR operations. Appearing in Google, Amazon, and Microsoft interviews regularly.',
      ),
      ConceptLesson(
        title: 'Interview Strategy: Think, Code, Verify',
        definition:
            'A structured interview approach: understand the problem (2 min), design the approach aloud (3 min), code while narrating (10-15 min), verify with examples and edge cases (3 min), discuss complexity (2 min).',
        analogy:
            'A surgeon follows a pre-operation checklist not because they are unsure, but because the structured approach prevents errors and demonstrates mastery. An interview is the same — structure signals experience.',
        example:
            'Interview framework:\n\n1. CLARIFY (2 min):\n   "Can input be empty? Can values be negative?\n    Is the array sorted? What is the expected output format?"\n\n2. EXAMPLE (1 min):\n   Walk through a small example to confirm understanding\n\n3. APPROACH (3 min):\n   "I am thinking sliding window because we need\n    a contiguous subarray. Brute force is O(n²).\n    Sliding window gets us O(n). Here is why..."\n\n4. CODE (10-15 min):\n   Narrate while coding: "I initialise left pointer here..."\n\n5. VERIFY (3 min):\n   Trace through your example + edge cases\n\n6. COMPLEXITY (1 min):\n   "Time: O(n), Space: O(1)"',
        keyTakeaway:
            'Interviewers evaluate PROCESS as much as correctness. A candidate who thinks aloud, handles edge cases, and discusses complexity beats a silent candidate who writes a perfect solution.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'You see a problem: "Find the longest substring without repeating characters." Which pattern fits?',
        options: [
          'Dynamic Programming — optimal substructure',
          'Sliding Window — contiguous subarray/substring with a condition',
          'BFS — shortest path',
          'Union-Find — connected components'
        ],
        correctIndex: 1,
        explanation:
            '"Substring with condition" (no repeating characters) is the classic sliding window signal. Two pointers define the window boundaries, expanding right and shrinking left when the condition breaks.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does n & (n-1) compute and what classic problem does it solve?',
        options: [
          'Doubles n — used in hash table resizing',
          'Clears the lowest set bit of n — used to check if n is a power of 2 (result == 0) and to count set bits',
          'Adds 1 to n — used in overflow detection',
          'Reverses bits — used in endianness conversion'
        ],
        correctIndex: 1,
        explanation:
            'n & (n-1) clears the rightmost set bit. If n is a power of 2, it has exactly one set bit, so n & (n-1) == 0. Repeatedly applying it counts set bits (Brian Kernighan\'s algorithm).',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'In a coding interview, when should you start writing code?',
        options: [
          'Immediately — speed shows competence',
          'After clarifying the problem, walking through an example, and explaining your approach aloud — then code',
          'Only after the interviewer explicitly says to start',
          'After silently solving it in your head'
        ],
        correctIndex: 1,
        explanation:
            'Starting immediately without clarification is a red flag. Interviewers want to see structured thinking: clarify → example → approach → code → verify. This process demonstrates engineering maturity.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'XOR trick: nums = [4, 1, 2, 1, 2]. Every number appears twice except one. Find the single number in O(n) time and O(1) space.',
        options: [
          'Use a hash set to track seen numbers — O(n) space',
          '4 ^ 1 ^ 2 ^ 1 ^ 2 = 4 — XOR all numbers, pairs cancel out leaving the single number',
          'Sort the array and find the element without a pair — O(n log n)',
          'Use a frequency counter dictionary — O(n) space'
        ],
        correctIndex: 1,
        explanation:
            'XOR is self-inverse: a ^ a = 0. XOR all elements — paired numbers cancel to 0, leaving only the single number. 4^1^2^1^2 = 4^(1^1)^(2^2) = 4^0^0 = 4.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Union-Find: You have 5 nodes (0-4) and edges [(0,1),(1,2),(3,4)]. How many connected components exist?',
        options: [
          '1 — all nodes are connected',
          '2 — {0,1,2} and {3,4}',
          '3 — {0,1,2}, {3}, {4}',
          '5 — each node is separate'
        ],
        correctIndex: 1,
        explanation:
            'After union(0,1) and union(1,2): {0,1,2} form one component. After union(3,4): {3,4} form another. Node counts: 5, minus 2 successful unions = 3 initial - ... = 2 components.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Interview Pattern Mastery Set',
      goal:
          'Solve 10 problems across 5 patterns using the full interview framework — pattern recognition, approach, code, complexity.',
      steps: [
        'Solve 2 Sliding Window problems: longest substring without repeating chars + minimum window substring',
        'Solve 2 Monotonic Stack problems: next greater element + largest rectangle in histogram',
        'Solve 2 Union-Find problems: number of provinces + detect cycle in graph',
        'Solve 2 Bit Manipulation problems: single number + count bits for 0 to n',
        'For each solution: write the pattern name, time complexity, space complexity, and one edge case handled',
        'Record yourself explaining one solution as if in an interview — use the Think-Code-Verify framework',
      ],
      expectedOutput:
          'Pattern Mastery Report:\n  Sliding Window: 2/2 ✓ | O(n) time | O(k) space\n  Monotonic Stack: 2/2 ✓ | O(n) time | O(n) space\n  Union-Find: 2/2 ✓ | O(α(n)) amortized\n  Bit Manipulation: 2/2 ✓ | O(n) time | O(1) space\n\nInterview walkthrough recorded:\n  Pattern identified in < 2 min ✓\n  Complexity stated correctly ✓\n  2 edge cases handled ✓',
      xpReward: 70,
    ),
  ),
  TopicCourse(
    id: 'sep_l10_system_design',
    topicTitle: 'System Design Fundamentals',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 42,
    totalXp: 265,
    emoji: '🏗️',
    intro:
        'System design interviews test whether you can architect real-world systems at scale. Designing URL shorteners, social feeds, ride-sharing backends, and payment systems are the canonical questions at senior-level rounds. This course gives you the vocabulary, mental models, and structured approach to tackle any system design question confidently.',
    concepts: [
      ConceptLesson(
        title: 'The System Design Interview Framework',
        definition:
            'A structured approach to any system design question: clarify requirements, estimate scale, design high-level architecture, dive deep into critical components, identify bottlenecks, and discuss trade-offs.',
        analogy:
            'An architect designing a hospital does not start drawing rooms immediately — they first understand capacity (how many patients?), critical requirements (emergency rooms first), and constraints (budget, location). System design interviews reward the same structured thinking.',
        example:
            'Framework for any system design question:\n\n1. REQUIREMENTS (5 min)\n   Functional: "What does it do?"\n   Non-functional: "Scale? Latency? Availability? Consistency?"\n\n2. SCALE ESTIMATION (3 min)\n   DAU, QPS, storage needed\n   "100M users, 1% active/day = 1M DAU\n    1M * 10 reads/day = ~116 reads/second"\n\n3. HIGH-LEVEL DESIGN (10 min)\n   Draw: clients → load balancer → servers → DB\n\n4. DEEP DIVE (15 min)\n   Focus on hardest component\n   Database schema, caching strategy, sharding\n\n5. BOTTLENECKS & TRADE-OFFS (5 min)\n   "Single points of failure? How to scale further?"',
        keyTakeaway:
            'System design interviews are open-ended by design — there is no single correct answer. Interviewers assess your ability to ask the right questions, make informed trade-offs, and reason about scale. The framework keeps you structured under pressure.',
      ),
      ConceptLesson(
        title: 'Scale Estimation — Back of the Envelope',
        definition:
            'Back-of-the-envelope calculations estimate system requirements: daily active users, queries per second, storage needs, and bandwidth. These numbers drive every subsequent design decision.',
        analogy:
            'Before building a bridge, engineers estimate the weight it must bear. Back-of-the-envelope calculations are the software equivalent — rough but directionally correct estimates that determine whether you need one server or ten thousand.',
        example:
            'Design Instagram — scale estimation:\n\nUsers: 500M total, 50M DAU\nReads: 50M * 20 views/day = 1B reads/day = ~11,600 RPS\nWrites: 50M * 2 uploads/day = 100M writes/day = ~1,160 WPS\nStorage per photo: 3MB compressed\nStorage per day: 100M * 3MB = 300TB/day\nStorage per year: 300TB * 365 = ~100 PB/year\n\n→ Need distributed storage (S3-equivalent)\n→ Read-heavy: 10:1 ratio → aggressive caching\n→ CDN essential for photo delivery',
        keyTakeaway:
            'Learn these numbers: SSD read ~0.1ms, network round trip ~1ms, read from RAM ~0.1μs. QPS = requests/86400 (seconds in a day). Storage: 1TB = 10^12 bytes. These anchor all estimations.',
      ),
      ConceptLesson(
        title: 'Horizontal vs Vertical Scaling',
        definition:
            'Vertical scaling adds more resources to one machine (bigger CPU, more RAM). Horizontal scaling adds more machines. Real production systems use horizontal scaling for most workloads — it is cheaper, more resilient, and virtually unlimited.',
        analogy:
            'Vertical scaling is feeding one elephant more — it gets bigger but there is a physical limit. Horizontal scaling is adding more horses to pull the cart — no upper limit, and if one horse falls, the others continue.',
        example:
            'Vertical scaling:\n  Server: 8 core → 64 core, 32GB → 256GB RAM\n  Limit: most powerful single machine is still finite\n  Cost: exponentially expensive beyond a point\n  Failure: single point of failure\n\nHorizontal scaling:\n  10 servers → 100 servers → 10,000 servers\n  Each server is identical and replaceable\n  Cost: linear with commodity hardware\n  Failure: losing one server is non-critical\n\nReal examples:\n  Facebook runs millions of commodity servers\n  Vertical: database servers still benefit from\n  large RAM for in-memory operations',
        keyTakeaway:
            'In system design interviews, always choose horizontal scaling as the default. Then explain statelessness (servers share no state, so any server can handle any request), which is required for horizontal scaling to work.',
      ),
      ConceptLesson(
        title: 'Database Sharding and Replication',
        definition:
            'Replication creates copies of data across multiple servers for read scaling and fault tolerance. Sharding splits data across multiple servers for write scaling — each shard owns a subset of the data.',
        analogy:
            'Replication is photocopying a book so many people can read it simultaneously. Sharding is splitting the book into chapters and giving each chapter to a different librarian — the collection scales beyond any single librarian\'s capacity.',
        example:
            'Replication strategies:\n  Primary-Replica: one primary handles writes,\n  replicas handle reads (read-heavy workloads)\n\nSharding strategies:\n  Range-based: users A-M → Shard 1, N-Z → Shard 2\n  Hash-based: user_id % num_shards → even distribution\n  Directory-based: lookup table maps key → shard\n\nSharding challenges:\n  Cross-shard queries are expensive\n  Hotspot shards (celebrity accounts on social media)\n  Re-sharding when adding new shards\n  Joins across shards impossible at scale',
        keyTakeaway:
            'In interviews: "We will start with replication for read scaling. If writes become a bottleneck, we will shard by user_id using consistent hashing to avoid hot spots." This shows you understand when and why to shard.',
      ),
      ConceptLesson(
        title: 'Caching Strategies',
        definition:
            'Caching stores frequently accessed data in fast memory (Redis, Memcached) to reduce database load and response latency. Key decisions: what to cache, when to invalidate, and which eviction policy to use.',
        analogy:
            'Caching is like a chef keeping the most-ordered ingredients on the countertop instead of the storeroom — 90% of orders are fulfilled in seconds without walking to storage. The 10% that need storeroom access are acceptable.',
        example:
            'Cache-Aside (most common):\n  1. Check cache first\n  2. On miss: fetch from DB, store in cache\n  3. On next request: cache hit → instant response\n\nCache strategies:\n  Write-Through: write to cache AND DB simultaneously\n  Write-Back: write to cache only, sync to DB later\n  Read-Through: cache handles DB reads automatically\n\nEviction policies:\n  LRU (Least Recently Used) — most common\n  LFU (Least Frequently Used) — for popularity-based\n  TTL (Time-to-Live) — time-based expiry\n\nRedis for:\n  Session storage, leaderboards (sorted sets),\n  rate limiting (atomic increment), pub/sub',
        keyTakeaway:
            'Cache invalidation is famously hard. In interviews: "We will use cache-aside with TTL expiry. For critical data like user balances, we will invalidate on write. For less critical data like user profiles, TTL of 1 hour is acceptable."',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'In a system design interview for "Design Twitter", what is the FIRST thing you should do?',
        options: [
          'Draw the database schema immediately',
          'Clarify functional and non-functional requirements: what features, expected scale, latency targets, and consistency needs',
          'Choose the tech stack',
          'Design the API endpoints'
        ],
        correctIndex: 1,
        explanation:
            'Without requirements, any design is guessing. Does "Design Twitter" mean just tweets? DMs? Trends? At what scale? For a startup or for 500M users? Clarifying first shows senior engineering instinct.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            '100M users, each makes 10 requests per day. What is the approximate requests per second (RPS)?',
        options: ['1,000 RPS', '11,600 RPS', '100,000 RPS', '1,000,000 RPS'],
        correctIndex: 1,
        explanation:
            '100M * 10 = 1B requests/day. 1B / 86,400 seconds ≈ 11,574 RPS ≈ 11,600 RPS. This level of traffic typically requires multiple application servers, a load balancer, and aggressive caching.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the key challenge introduced by database sharding?',
        options: [
          'Sharding reduces read performance',
          'Cross-shard queries become expensive or impossible, and re-sharding when adding nodes is complex',
          'Sharding only works with NoSQL databases',
          'Sharding eliminates the need for indexes'
        ],
        correctIndex: 1,
        explanation:
            'Sharding splits data across nodes, so queries involving data on multiple shards require cross-shard joins — extremely expensive. This forces application-level joins and careful data modeling to keep related data on the same shard.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Design a URL shortener like bit.ly. A user pastes a long URL and gets a short 6-character code. What is the correct high-level design?',
        options: [
          'Store full URL in the path of the short URL',
          'Hash or Base62-encode a unique ID → store mapping in DB → on redirect, lookup short code → 301/302 to original URL. Cache hot URLs in Redis.',
          'Use MD5 of the URL as the short code',
          'Store everything in browser localStorage'
        ],
        correctIndex: 1,
        explanation:
            'Core flow: generate unique ID (auto-increment or distributed ID), Base62-encode to 6 chars (62^6 = ~56B URLs), store {short_code: long_url} in DB, cache popular codes in Redis. 301 for permanent redirect, 302 for click tracking.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your read:write ratio is 100:1. Users complain about slow reads. What is the FIRST optimisation to implement?',
        options: [
          'Add more database servers immediately',
          'Add a caching layer (Redis) in front of the database — 100:1 read heavy means a high cache-hit rate will eliminate most DB load instantly',
          'Migrate to a NoSQL database',
          'Shard the database'
        ],
        correctIndex: 1,
        explanation:
            'With 100:1 read:write, most reads are for the same popular data. A cache with even 80% hit rate eliminates 80 of every 100 DB reads. Caching is always the first optimization for read-heavy systems before adding more database hardware.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Design Instagram — Complete System Design',
      goal:
          'Produce a complete system design document for Instagram covering all components from client to storage.',
      steps: [
        'Requirements: list 5 functional (upload, feed, follow, search, stories) and 4 NFRs (500M users, < 200ms feed load, 99.99% uptime, eventual consistency acceptable)',
        'Scale estimation: calculate DAU, photo upload RPS, feed read RPS, and storage per year',
        'High-level design: draw client → CDN → load balancer → API servers → cache → primary DB → object storage',
        'Deep dive: design the news feed generation system (push vs pull vs hybrid model for different user types)',
        'Database schema: users table, posts table, follows table, feed table — with appropriate indexes',
        'Bottlenecks: identify top 3 bottlenecks and propose solutions (sharding strategy, cache invalidation, CDN for media)',
      ],
      expectedOutput:
          'System Design: Instagram\n\nScale: 500M users, 50M DAU, ~1,200 photo uploads/sec, ~12,000 feed reads/sec\n\nArchitecture:\n  CDN → Load Balancer → 50 API Servers\n  Redis Cache (feed + sessions)\n  PostgreSQL (sharded by user_id)\n  S3-equivalent object storage\n\nFeed: Hybrid push/pull (push for < 1000 followers, pull for celebrities)\nSharding: user_id % 64 shards\nCache: LRU, TTL 24h for feeds\nBottlenecks + solutions documented ✓',
      xpReward: 75,
    ),
  ),
  TopicCourse(
    id: 'sep_l10_scalability',
    topicTitle: 'Scalability, Load Balancing & Caching',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 38,
    totalXp: 250,
    emoji: '⚖️',
    intro:
        'Every production system eventually hits scale problems. Knowing how to design for 10x, 100x, and 1000x growth — using load balancers, CDNs, message queues, and distributed caches — is the core competency of senior backend engineers and the central theme of principal/staff engineer interviews.',
    concepts: [
      ConceptLesson(
        title: 'Load Balancers — Algorithms and Types',
        definition:
            'Load balancers distribute incoming traffic across multiple servers. Algorithms include Round Robin, Weighted Round Robin, Least Connections, and Consistent Hashing. Types include L4 (transport layer) and L7 (application layer).',
        analogy:
            'A load balancer is like a smart traffic cop at a busy intersection — directing cars to the least-congested lane, remembering which driver is going where, and rerouting instantly if a lane closes.',
        example:
            'Load balancing algorithms:\n\nRound Robin: req1→Server1, req2→Server2, req3→Server1...\n  Simple, equal distribution, ignores server load\n\nLeast Connections: route to server with fewest active\n  Better for variable request lengths (file uploads)\n\nConsistent Hashing: hash(user_id) → same server\n  Ensures session affinity, minimises re-routing on\n  server add/remove (only K/n keys remapped)\n\nL4 Load Balancer: routes based on IP+port (fast)\nL7 Load Balancer: routes based on URL, headers,\n  cookies — can do SSL termination, content routing',
        keyTakeaway:
            'Consistent hashing is the answer for distributed caches — when a cache server is added or removed, only a fraction of keys need remapping instead of all keys. This prevents the cache stampede that kills systems during scaling events.',
      ),
      ConceptLesson(
        title: 'CDN — Content Delivery Networks',
        definition:
            'A CDN is a globally distributed network of servers that caches static content close to users — reducing latency from 200ms (cross-continent) to 5ms (nearest CDN node).',
        analogy:
            'A CDN is like a chain of local warehouses. Instead of shipping every product from one central warehouse in Mumbai, you stock warehouses in Delhi, Bengaluru, Chennai, and Kolkata. Orders ship from the nearest warehouse in hours, not days.',
        example:
            'CDN flow for a static asset:\n\n1. User in Delhi requests image from youapp.com\n2. DNS resolves to nearest CDN edge node (Delhi POP)\n3. CDN checks: is this image cached?\n   YES → serve in ~5ms\n   NO  → fetch from origin server (Mumbai),\n          cache it, serve it (~150ms first time)\n4. Next Delhi user gets it in ~5ms from CDN\n\nWhat belongs on CDN:\n  Images, videos, CSS, JS, fonts, HTML\n  Static API responses (product catalog)\n\nWhat does NOT belong on CDN:\n  Dynamic API responses\n  Authenticated/personalised content',
        keyTakeaway:
            'CDNs reduce origin server load by 80-90% for media-heavy applications. In system design, always propose CDN for any global-scale system serving static assets. CloudFront (AWS), Cloudflare, Akamai are the real-world tools.',
      ),
      ConceptLesson(
        title: 'Message Queues for Async Processing',
        definition:
            'Message queues (Kafka, RabbitMQ, AWS SQS) decouple producers from consumers — allowing async processing, buffering traffic spikes, and enabling reliable at-least-once delivery of work.',
        analogy:
            'A message queue is like a restaurant\'s order ticket rail. The waiter (producer) clips the order and moves on. The kitchen (consumer) processes orders at its own pace. The rail buffers demand spikes — a rush of customers does not crash the kitchen.',
        example:
            'Without message queue:\n  Upload video → wait for transcoding (30 min) → response\n  User waits 30 minutes! Timeout. Poor experience.\n\nWith message queue:\n  Upload video → push message to queue → immediate 200 OK\n  Worker pool pulls from queue → transcodes async\n  User gets notification when done\n\nKafka use cases:\n  Event streaming, log aggregation, real-time analytics\n  Ordered, replayable, high-throughput (millions/sec)\n\nRabbitMQ use cases:\n  Task queues, work distribution, retry logic\n  More complex routing, acknowledgement patterns',
        keyTakeaway:
            'Message queues are the answer to three system design problems: "How do you handle traffic spikes?" (buffer them), "How do you handle slow downstream services?" (async), "How do you ensure reliability?" (at-least-once delivery with retry).',
      ),
      ConceptLesson(
        title: 'Rate Limiting and API Throttling',
        definition:
            'Rate limiting prevents abuse by restricting how many requests a client can make in a time window. Algorithms include Fixed Window, Sliding Window, Token Bucket, and Leaky Bucket.',
        analogy:
            'Rate limiting is like a nightclub bouncer with a clicker — after 100 people enter (request limit), the door closes until some leave (time window resets). Fair for everyone, prevents overwhelming the venue.',
        example:
            'Token Bucket algorithm:\n  Bucket holds up to N tokens\n  Tokens added at rate R per second\n  Each request consumes 1 token\n  Request rejected if bucket is empty\n\n  Allows bursting up to N then throttles to R/sec\n\nRedis implementation of rate limiting:\n  key = "rate:user_id:window"\n  count = INCR key\n  if count == 1: EXPIRE key 60  # set TTL on first req\n  if count > 100: return 429 Too Many Requests\n\nResponse headers:\n  X-RateLimit-Limit: 100\n  X-RateLimit-Remaining: 43\n  X-RateLimit-Reset: 1719086400',
        keyTakeaway:
            'Rate limiting protects backend services from abuse and ensures fair usage. In interviews, Redis atomic INCR + EXPIRE is the standard implementation. Always return 429 status with Retry-After header when throttling.',
      ),
      ConceptLesson(
        title: 'Database Connection Pooling',
        definition:
            'Connection pooling maintains a pool of pre-established database connections that are reused across requests — avoiding the overhead of creating a new connection (50-200ms) for every database query.',
        analogy:
            'Connection pooling is like a taxi company with a fleet always ready at the airport — instead of calling a manufacturer to build a new taxi for each passenger, you reuse the existing fleet. Passengers get cars instantly.',
        example:
            'Without connection pooling:\n  Every request: open TCP → authenticate → query → close\n  Cost: 50-200ms just for connection overhead\n  At 1000 RPS: 1000 new connections/sec → DB collapses\n\nWith connection pooling:\n  Pool: 20 persistent connections maintained\n  Request: borrow connection → query → return\n  Cost: microseconds to acquire from pool\n\nConfiguration:\n  pool_size: 20     # persistent connections\n  max_overflow: 10  # burst capacity\n  pool_timeout: 30  # wait for available connection\n  pool_recycle: 3600  # recycle connections hourly\n\nTools: PgBouncer (PostgreSQL), HikariCP (Java),\n       SQLAlchemy pool (Python)',
        keyTakeaway:
            'Without a connection pool, high-traffic applications will exhaust database connection limits. A pool of 20 connections can serve thousands of concurrent requests because most requests hold connections for only milliseconds.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why is Consistent Hashing preferred over simple modulo hashing for distributing cache keys across servers?',
        options: [
          'Consistent hashing is faster to compute',
          'When a server is added or removed, only K/n keys need remapping instead of all keys — preventing a cache stampede',
          'Consistent hashing produces better randomness',
          'Simple modulo does not work with strings'
        ],
        correctIndex: 1,
        explanation:
            'With simple modulo (key % n), adding or removing one server invalidates nearly all cached keys — causing a massive DB hit. Consistent hashing remaps only the keys that belonged to the affected server segment.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What HTTP status code should a rate-limited API return?',
        options: [
          '403 Forbidden',
          '429 Too Many Requests',
          '503 Service Unavailable',
          '400 Bad Request'
        ],
        correctIndex: 1,
        explanation:
            '429 Too Many Requests is the correct status for rate limiting, typically accompanied by a Retry-After header indicating when the client can retry. 403 is for authorization failures, 503 for service unavailability.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'When should you use a message queue instead of a synchronous API call?',
        options: [
          'Always — message queues are always better',
          'When the operation is slow (video encoding, email sending), can tolerate eventual completion, or needs to handle traffic spikes without dropping requests',
          'Only for logging and analytics',
          'When the result must be returned in the same HTTP response'
        ],
        correctIndex: 1,
        explanation:
            'Message queues shine for: slow async operations (return immediately, process later), traffic spike buffering (absorb bursts without overwhelming downstream), and reliability (retry failed jobs). Bad choice when the caller needs an immediate result.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your service gets 1000 RPS normally but spikes to 50,000 RPS during a product launch. What architecture handles this without crashing?',
        options: [
          'Scale the server vertically to handle 50k RPS at all times',
          'Auto-scaling group behind a load balancer + message queue to buffer spikes + CDN for static assets — absorbs spikes gracefully, scales down after',
          'Add a single larger server permanently',
          'Block traffic above 1000 RPS with a firewall'
        ],
        correctIndex: 1,
        explanation:
            'Auto-scaling handles compute spikes. Message queues buffer requests that cannot be processed immediately. CDN handles static asset spikes without hitting origin. Together these absorb 50x traffic spikes without crashing or over-provisioning.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A user\'s news feed requires data from 5 different database tables. The feed loads in 800ms — too slow. What is the MOST impactful optimisation?',
        options: [
          'Rewrite the database in C++',
          'Pre-compute and cache the feed in Redis when new posts are created — serve cached feed in < 5ms instead of joining 5 tables on every request',
          'Add more database indexes',
          'Use a faster programming language'
        ],
        correctIndex: 1,
        explanation:
            'Real-time feed generation from 5 tables is inherently slow at scale. Pre-computing feeds (fan-out on write) or caching generated feeds in Redis eliminates the expensive join on every read. Twitter, Instagram, and Facebook all use feed caching.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Scalability Architecture for 10M Users',
      goal:
          'Design and document a complete scalability plan taking a simple app from 1K to 10M users in stages.',
      steps: [
        'Stage 1 (1K users): single server, single DB, no cache — document the simple architecture',
        'Stage 2 (100K users): add load balancer + 3 app servers, add Redis cache for sessions and hot data, add DB read replica',
        'Stage 3 (1M users): add CDN for static assets, implement message queue for async tasks (email, notifications), add database connection pooling',
        'Stage 4 (10M users): database sharding by user_id, Kafka for event streaming, auto-scaling groups, rate limiting on all APIs',
        'At each stage: document what broke, what was added, and the key trade-off made',
        'Calculate cost estimate for Stage 4 using approximate cloud pricing',
      ],
      expectedOutput:
          'Stage 1 → Stage 4 Evolution:\n  1K:  1 server, 1 DB — cost ~\$50/month\n  100K: LB + 3 servers + Redis + replica — \$500/month\n  1M:  CDN + queue + pooling — \$3,000/month\n  10M: sharding + Kafka + auto-scale — \$15,000/month\n\nKey decisions documented at each stage ✓\nBottleneck that forced each upgrade identified ✓\nTrade-offs (consistency vs availability) stated ✓',
      xpReward: 70,
    ),
  ),
  TopicCourse(
    id: 'sep_l10_concurrency',
    topicTitle: 'Concurrency & Async Programming',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 35,
    totalXp: 240,
    emoji: '⚙️',
    intro:
        'Production systems handle thousands of concurrent users. Understanding threads, processes, race conditions, deadlocks, and async I/O is what separates engineers who write code that works on one machine from engineers who build systems that serve millions simultaneously. Concurrency questions appear in senior interviews at every major tech company.',
    concepts: [
      ConceptLesson(
        title: 'Threads vs Processes vs Async',
        definition:
            'A process is an independent program with its own memory. Threads share memory within a process. Async/coroutines handle concurrency on a single thread using cooperative task switching — ideal for I/O-bound work.',
        analogy:
            'Processes are separate kitchens. Threads are chefs sharing one kitchen — they can hand each other ingredients but can also collide. Async is one chef who starts a dish, switches to another while the oven heats, and switches back — appearing to do many things simultaneously.',
        example:
            'Python concurrency options:\n\nthreading (I/O-bound tasks):\n  import threading\n  t = threading.Thread(target=fetch_url, args=(url,))\n  t.start()\n  # GIL limits true CPU parallelism\n\nmultiprocessing (CPU-bound tasks):\n  from multiprocessing import Pool\n  with Pool(4) as p:\n      results = p.map(cpu_heavy_func, data_list)\n  # True parallelism, separate memory spaces\n\nasyncio (I/O-bound, thousands of connections):\n  async def fetch(url):\n      async with aiohttp.ClientSession() as session:\n          async with session.get(url) as response:\n              return await response.text()',
        keyTakeaway:
            'Python GIL means threads cannot achieve true CPU parallelism for compute-heavy work — use multiprocessing. For I/O-bound work (web requests, DB queries), asyncio handles thousands of concurrent operations on a single thread.',
      ),
      ConceptLesson(
        title: 'Race Conditions and Locks',
        definition:
            'A race condition occurs when two threads access shared data simultaneously and the outcome depends on execution order. Locks (mutex) prevent simultaneous access, but introduce deadlock risk if acquired in inconsistent order.',
        analogy:
            'Two people editing the same Google Doc paragraph simultaneously without waiting — whoever saves last wins, potentially losing the other\'s changes. A lock is the "only one editor at a time" rule that prevents this.',
        example:
            '# Race condition — DANGEROUS:\nbalance = 1000\ndef withdraw(amount):  # called from 2 threads\n    global balance\n    if balance >= amount:    # Thread 1 reads 1000\n        # Thread 2 also reads 1000 here!\n        balance -= amount   # Both withdraw 700 — bank loses money\n\n# Fixed with lock:\nimport threading\nlock = threading.Lock()\n\ndef withdraw_safe(amount):\n    with lock:  # only one thread at a time\n        if balance >= amount:\n            balance -= amount\n\n# Async equivalent — avoid shared state:\nasync def withdraw_async(account_id, amount):\n    async with db.transaction():\n        balance = await db.get_balance(account_id)\n        if balance >= amount:\n            await db.update_balance(account_id, balance - amount)',
        keyTakeaway:
            'Race conditions are silent bugs — they occur intermittently under load and are nearly impossible to reproduce in development. Always use atomic database transactions or locks for any financial or inventory operations.',
      ),
      ConceptLesson(
        title: 'Python asyncio — Practical Async Patterns',
        definition:
            'asyncio enables single-threaded concurrency using event loops, async/await syntax, and coroutines — efficiently handling thousands of simultaneous I/O operations without threads.',
        analogy:
            'asyncio is like a highly efficient single receptionist who does not wait on hold — they place a call, work on something else while waiting, and pick up the moment it connects. Thousands of "calls" handled by one person.',
        example:
            'import asyncio\nimport aiohttp\n\nasync def fetch_user(session, user_id):\n    url = f"https://api.example.com/users/{user_id}"\n    async with session.get(url) as response:\n        return await response.json()\n\nasync def fetch_all_users(user_ids):\n    async with aiohttp.ClientSession() as session:\n        tasks = [\n            fetch_user(session, uid)\n            for uid in user_ids\n        ]\n        # Run ALL requests concurrently:\n        results = await asyncio.gather(*tasks)\n    return results\n\n# Sequential: 100 users * 200ms each = 20 seconds\n# Concurrent: max(200ms for all) = ~200ms total',
        keyTakeaway:
            'asyncio.gather() is the power tool — it runs all coroutines concurrently and collects results. 100 HTTP requests sequentially takes 100x longer than running them concurrently with gather().',
      ),
      ConceptLesson(
        title: 'Database Transactions and Isolation',
        definition:
            'Concurrent database access requires careful transaction management. Optimistic locking (version numbers) and pessimistic locking (SELECT FOR UPDATE) prevent race conditions in high-concurrency database operations.',
        analogy:
            'Optimistic locking is like two people editing a shared document who check if anyone else edited since they started — if yes, merge or retry. Pessimistic locking is reserving the document exclusively before starting — blocking others until done.',
        example:
            '# Pessimistic locking — lock row during transaction\nBEGIN;\nSELECT balance FROM accounts\nWHERE id = 42 FOR UPDATE;  -- locks this row\n-- No other transaction can modify row 42 until COMMIT\nUPDATE accounts SET balance = balance - 500 WHERE id = 42;\nCOMMIT;\n\n# Optimistic locking — version column\nCREATE TABLE accounts (\n    id INTEGER PRIMARY KEY,\n    balance DECIMAL(12,2),\n    version INTEGER DEFAULT 0\n);\n\n-- Check version matches what we read:\nUPDATE accounts\nSET balance = 500, version = version + 1\nWHERE id = 42 AND version = 7;  -- fails if someone else updated\n-- If 0 rows updated → retry with fresh read',
        keyTakeaway:
            'For high-contention resources (inventory, tickets, bank accounts), pessimistic locking prevents double-spending. For low-contention updates, optimistic locking avoids the overhead of row locks and scales better.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'When should you use asyncio over threading in Python?',
        options: [
          'For CPU-intensive computation like image processing',
          'For I/O-bound operations (HTTP requests, DB queries, file I/O) where the program spends most time waiting — asyncio handles thousands of concurrent waits on one thread',
          'asyncio is always faster than threading',
          'Only for web servers, not other applications'
        ],
        correctIndex: 1,
        explanation:
            'asyncio excels at I/O-bound work — while waiting for a network response, it processes other tasks. For CPU-bound work, Python\'s GIL and asyncio\'s single-thread make multiprocessing the better choice.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Two threads both read a bank balance of ₹1000 and both withdraw ₹700. The final balance is ₹300. What is this bug called?',
        options: [
          'Integer overflow',
          'Race condition — both threads passed the balance check before either completed the withdrawal, allowing overdraft',
          'Deadlock',
          'Stack overflow'
        ],
        correctIndex: 1,
        explanation:
            'A race condition: Thread 1 reads ₹1000, Thread 2 reads ₹1000, both pass the ₹700 check, both withdraw — resulting in ₹300 instead of ₹300 (correct) or a rejection for the second withdrawal (desired). Fix: use a lock or database transaction.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does asyncio.gather(*tasks) do?',
        options: [
          'Runs tasks one after another sequentially',
          'Runs all coroutines concurrently on the event loop and collects results when all complete',
          'Creates new threads for each task',
          'Cancels all running tasks'
        ],
        correctIndex: 1,
        explanation:
            'gather() submits all coroutines to the event loop simultaneously. While one waits for a network response, others run. Total time ≈ the slowest single task, not the sum of all — the key benefit of async concurrency.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You need to fetch data from 50 external APIs to build a user dashboard. Sequential calls take 10 seconds. How do you reduce this to under 1 second?',
        options: [
          'Use 50 threads — one per API call',
          'Use asyncio.gather() with 50 coroutines — all 50 HTTP requests run concurrently, total time ≈ slowest single request',
          'Cache the API responses — but first load still takes 10 seconds',
          'Reduce the number of APIs called'
        ],
        correctIndex: 1,
        explanation:
            'asyncio.gather() with aiohttp sends all 50 requests simultaneously. If each takes 200ms, the total is ~200ms (not 50*200ms=10s). This is the exact pattern used in API aggregation services and BFF (Backend for Frontend) layers.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'An e-commerce flash sale: 1000 users try to buy the last item simultaneously. How do you ensure exactly ONE purchase succeeds?',
        options: [
          'Check inventory in application code before each purchase',
          'Use SELECT FOR UPDATE (pessimistic lock) in a database transaction — only one transaction can hold the lock; others wait and then see inventory = 0',
          'Use a Redis counter and decrement before the DB write',
          'Use a queue and process purchases sequentially'
        ],
        correctIndex: 1,
        explanation:
            'SELECT FOR UPDATE acquires a row-level lock. The first transaction to get the lock deducts inventory and commits. All waiting transactions then read the updated inventory (now 0) and fail gracefully. Atomicity guaranteed at the DB level.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Concurrent Web Scraper and Task Processor',
      goal:
          'Build an async concurrent system demonstrating real-world concurrency patterns.',
      steps: [
        'Build an async URL fetcher using aiohttp + asyncio.gather() that fetches 20 URLs concurrently and reports total time vs sequential',
        'Implement a rate-limited async fetcher that limits to 5 concurrent requests at a time using asyncio.Semaphore',
        'Build a task queue simulation: producer adds 50 tasks, 5 async workers process them concurrently using asyncio.Queue',
        'Add a shared counter with asyncio.Lock to track completed tasks safely across coroutines',
        'Implement retry logic with exponential backoff for failed requests using asyncio',
        'Benchmark and report: sequential time vs concurrent time vs rate-limited time',
      ],
      expectedOutput:
          'Concurrent URL Fetcher:\n  Sequential (20 URLs): 4.2 seconds\n  Concurrent (gather): 0.3 seconds (14x faster)\n  Rate-limited (5 at a time): 0.8 seconds\n\nTask Queue:\n  50 tasks processed by 5 workers: 2.1 seconds\n  Sequential would take: 10 seconds\n  Speedup: 4.7x\n\nShared counter (with lock): 50 — no race condition ✓\nRetry logic: 3 failed URLs retried successfully ✓',
      xpReward: 65,
    ),
  ),
  TopicCourse(
    id: 'sep_l10_cicd_docker',
    topicTitle: 'CI/CD, Docker & Deployment',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 35,
    totalXp: 230,
    emoji: '🚀',
    intro:
        'Modern software is not just written — it is packaged, tested automatically, and deployed continuously. Docker makes applications portable and reproducible. CI/CD pipelines automate the path from code commit to production deployment. These skills are required at every serious engineering role and transform how you deliver software.',
    concepts: [
      ConceptLesson(
        title: 'Docker — Containers vs Virtual Machines',
        definition:
            'Docker packages an application and its dependencies into a portable container that runs identically in any environment. Containers share the host OS kernel — faster and lighter than VMs which each run a full OS.',
        analogy:
            'A Docker container is like a shipping container — standardised, self-contained, runs identically whether on a ship, truck, or port. VMs are like shipping entire factories — capable but massive overhead.',
        example:
            '# Dockerfile for a Python FastAPI application:\nFROM python:3.11-slim\n\nWORKDIR /app\n\n# Install dependencies first (cache layer)\nCOPY requirements.txt .\nRUN pip install --no-cache-dir -r requirements.txt\n\n# Copy application code\nCOPY . .\n\n# Run as non-root user (security)\nRUN adduser --disabled-password appuser\nUSER appuser\n\nEXPOSE 8000\nCMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]\n\n# Build and run:\n# docker build -t myapp:1.0 .\n# docker run -p 8000:8000 myapp:1.0',
        keyTakeaway:
            'Order Dockerfile instructions from least-to-most frequently changing — dependencies before code. This maximises Docker layer caching, so rebuilds after code changes take seconds instead of minutes (no reinstalling all packages).',
      ),
      ConceptLesson(
        title: 'Docker Compose — Multi-Container Applications',
        definition:
            'Docker Compose orchestrates multiple containers (app, database, cache, queue) with a single YAML file — defining services, networks, and volumes for local development and testing.',
        analogy:
            'Docker Compose is like a stage director coordinating all actors (services) — ensuring the database is ready before the app starts, they can talk to each other, and data persists across restarts.',
        example:
            '# docker-compose.yml\nversion: "3.9"\nservices:\n  api:\n    build: .\n    ports:\n      - "8000:8000"\n    environment:\n      - DATABASE_URL=postgresql://user:pass@db:5432/myapp\n      - REDIS_URL=redis://cache:6379\n    depends_on:\n      - db\n      - cache\n\n  db:\n    image: postgres:15\n    volumes:\n      - postgres_data:/var/lib/postgresql/data\n    environment:\n      - POSTGRES_DB=myapp\n      - POSTGRES_USER=user\n      - POSTGRES_PASSWORD=pass\n\n  cache:\n    image: redis:7-alpine\n\nvolumes:\n  postgres_data:\n\n# Start everything: docker compose up\n# Stop everything: docker compose down',
        keyTakeaway:
            'Docker Compose eliminates "works on my machine" problems for entire development stacks. New team members clone the repo and run one command to get a fully functioning local environment with all services.',
      ),
      ConceptLesson(
        title: 'CI/CD Pipeline Design',
        definition:
            'CI (Continuous Integration) automatically builds and tests every code change. CD (Continuous Delivery/Deployment) automatically deploys passing builds to staging or production. Together they reduce deployment risk and feedback time from weeks to minutes.',
        analogy:
            'CI/CD is like a car assembly line with quality checkpoints — every part is checked as it is added (CI), and the completed car goes through final inspection before leaving the factory (CD). Issues are caught immediately, not after shipping.',
        example:
            '# .github/workflows/ci-cd.yml\nname: CI/CD Pipeline\n\non:\n  push:\n    branches: [main, develop]\n  pull_request:\n    branches: [main]\n\njobs:\n  test:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v4\n      - name: Run tests\n        run: |\n          pip install -r requirements.txt\n          pytest --cov=app --cov-report=xml\n      - name: Lint check\n        run: flake8 app/\n\n  deploy:\n    needs: test  # only runs if tests pass\n    if: runs-only-on-main-branch\n    runs-on: ubuntu-latest\n    steps:\n      - name: Deploy to production\n        run: |\n          docker build -t myapp:GIT_SHA .\n          docker push registry/myapp:GIT_SHA\n          # Update Kubernetes deployment\n          # (use GITHUB_SHA env var in real workflow)',
        keyTakeaway:
            'The CI/CD pipeline is the gatekeeper — no code reaches production without passing all tests. Aim for a pipeline under 5 minutes: slow pipelines get skipped. Stage gates (test → staging → production) prevent deploying broken code.',
      ),
      ConceptLesson(
        title: 'Deployment Strategies',
        definition:
            'Different deployment strategies balance risk vs speed: Blue-Green (instant rollback), Canary (gradual rollout), Rolling (zero downtime), and Feature Flags (code deployed but hidden until enabled).',
        analogy:
            'Blue-Green deployment is like keeping a spare tyre always ready — if the new tyre (green) fails, you immediately switch back to the old one (blue) with zero delay. Canary is testing new tyres on 5% of cars first before fitting the whole fleet.',
        example:
            'Blue-Green Deployment:\n  Blue: current production (v1.0)\n  Green: new version (v1.1) deployed and tested\n  Switch load balancer: blue → green\n  If issues: switch back instantly\n  Zero downtime, instant rollback\n\nCanary Deployment:\n  v1.1 deployed to 5% of servers\n  Monitor error rates and latency\n  Gradual increase: 5% → 25% → 50% → 100%\n  Roll back if metrics degrade at any stage\n\nFeature Flags:\n  Code in production but feature disabled\n  Enable for 1% of users → test → expand\n  Allows A/B testing in real production',
        keyTakeaway:
            'Canary deployments are the gold standard for risk management at scale. Companies like Google and Netflix deploy hundreds of times per day using canary releases — catching issues before they affect all users.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why should Docker COPY requirements.txt and RUN pip install be done BEFORE COPY . . in a Dockerfile?',
        options: [
          'It is a security requirement',
          'Docker caches layers — dependencies rarely change, so they can be cached. If code changes but requirements do not, pip install is skipped, rebuilding in seconds instead of minutes',
          'pip install does not work after copying all files',
          'The order does not matter for Docker'
        ],
        correctIndex: 1,
        explanation:
            'Docker caches each layer. By copying requirements first and installing dependencies, that layer is cached. When you change only application code, Docker reuses the cached dependency layer and only re-copies the code — much faster rebuilds.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the key advantage of Blue-Green deployment over a standard update?',
        options: [
          'It requires less infrastructure',
          'Instant rollback — if the new version (green) has issues, you switch the load balancer back to the old version (blue) in seconds with zero downtime',
          'It deploys faster than other strategies',
          'It eliminates the need for testing'
        ],
        correctIndex: 1,
        explanation:
            'Standard updates (rolling) take time to rollback — you must redeploy the old version. Blue-Green keeps the old version (blue) running and simply switches the load balancer. Rollback is instantaneous and zero-downtime.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is a Feature Flag and why is it powerful?',
        options: [
          'A Docker configuration for feature branches',
          'Code deployed to production but hidden behind a toggle — enables gradual rollout, A/B testing, and instant disable without redeployment',
          'A CI pipeline step that enables features',
          'A Git branch protection rule'
        ],
        correctIndex: 1,
        explanation:
            'Feature flags decouple deployment from release. You can deploy code on Monday, turn it on for 1% of users Wednesday, and if something breaks, toggle it off instantly — no redeployment, no downtime.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your Docker image is 2.3GB. Build times are 8 minutes. How do you optimise?',
        options: [
          'Delete the Dockerfile and use a ZIP file',
          'Use python:3.11-slim base (not full), add .dockerignore to exclude node_modules/tests/docs, and use multi-stage build to separate build and runtime layers',
          'Remove the application code from the image',
          'Upgrade the build server'
        ],
        correctIndex: 1,
        explanation:
            'Three techniques: slim base images (python:3.11-slim vs python:3.11 saves ~700MB), .dockerignore to exclude unnecessary files, and multi-stage builds that copy only the final artifact into a minimal runtime image.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You deploy a new feature. After 5 minutes, error rate jumps from 0.1% to 15%. What do you do with a Blue-Green deployment?',
        options: [
          'Investigate the logs for 30 minutes before deciding',
          'Immediately switch load balancer back to Blue (old version) — restore production to healthy state first, investigate cause with zero user impact',
          'Roll forward with a hot fix',
          'Disable the database to stop errors'
        ],
        correctIndex: 1,
        explanation:
            'Blue-Green golden rule: restore first, investigate second. Switch back to Blue instantly (seconds), error rate drops to 0.1%, then investigate root cause with logs and staging environment safely.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Production Docker + CI/CD Pipeline',
      goal:
          'Containerise a Python REST API and build a complete CI/CD pipeline that tests, builds, and deploys automatically.',
      steps: [
        'Write a production-quality Dockerfile for a FastAPI app: slim base, non-root user, layered caching, health check endpoint',
        'Create docker-compose.yml with app + PostgreSQL + Redis, environment variables via .env file, volume for DB persistence',
        'Write .dockerignore excluding: __pycache__, .env, tests/, .git, *.pyc',
        'Create .github/workflows/ci.yml: on push to main → checkout → run pytest → build Docker image → push to GitHub Container Registry',
        'Add a deploy stage that only runs on main branch after tests pass — simulates deploying to a server via SSH',
        'Document the full pipeline: commit → CI runs tests → Docker image built and pushed → deployment triggered',
      ],
      expectedOutput:
          'Docker Image: myapp:latest (145MB with slim base)\n\nCI/CD Pipeline (on push to main):\n  ✓ Checkout code (5s)\n  ✓ Run pytest 28 tests (34s)\n  ✓ Coverage 89% — above 80% threshold\n  ✓ Docker build (45s, cached deps layer)\n  ✓ Push to ghcr.io/username/myapp:abc1234\n  ✓ Deploy to staging\nTotal pipeline: 2m 14s\n\ndocker compose up → full stack running locally ✓',
      xpReward: 65,
    ),
  ),
  TopicCourse(
    id: 'sep_l10_monitoring',
    topicTitle: 'Production Monitoring & Observability',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 215,
    emoji: '📊',
    intro:
        'You cannot fix what you cannot see. Production monitoring and observability are what separate engineers who deploy and pray from engineers who deploy with confidence. Metrics, logs, traces, and alerts are the four pillars that let you understand system behaviour, detect problems before users do, and debug production issues in minutes.',
    concepts: [
      ConceptLesson(
        title: 'The Three Pillars of Observability',
        definition:
            'Observability rests on three pillars: Metrics (aggregated numerical measurements over time), Logs (structured records of events), and Traces (end-to-end request journey across services). Each answers different questions.',
        analogy:
            'Metrics are your car\'s dashboard (speed, fuel, temperature — numeric summaries). Logs are the black box recorder (exactly what happened and when). Traces are the GPS journey replay (which roads, in what order, where it slowed).',
        example:
            'Three pillars and the questions they answer:\n\nMETRICS: "What is happening right now?"\n  CPU usage 87%, error rate 2.3%, P95 latency 450ms\n  Tools: Prometheus, Datadog, CloudWatch\n\nLOGS: "What exactly happened?"\n  2024-06-15 14:32:01 ERROR user_id=42 payment failed:\n    stripe timeout after 30s, retry 1 of 3\n  Tools: ELK Stack, Loki, CloudWatch Logs\n\nTRACES: "Where in the system did it slow down?"\n  Request abc123: total 450ms\n    Auth middleware: 5ms\n    DB query: 380ms ← BOTTLENECK\n    Response serialisation: 15ms\n  Tools: Jaeger, Zipkin, AWS X-Ray',
        keyTakeaway:
            'Metrics tell you THAT something is wrong. Logs tell you WHAT happened. Traces tell you WHERE it is slow. You need all three to effectively debug production — each layer reveals something the others cannot.',
      ),
      ConceptLesson(
        title: 'SLIs, SLOs, and SLAs',
        definition:
            'SLI (Service Level Indicator) is a measured metric (actual uptime). SLO (Service Level Objective) is the internal target (99.9% uptime). SLA (Service Level Agreement) is the contractual promise to customers with penalty for breach.',
        analogy:
            'SLI is the actual test score. SLO is the minimum passing grade you aim for. SLA is the grade you promised your university would accept — if you fall below it, there are consequences.',
        example:
            'Example SLIs and SLOs:\n\nAvailability:\n  SLI: successful requests / total requests\n  SLO: >= 99.9% (allows 8.7 hours downtime/year)\n  SLA: >= 99.5% (customer receives credit if breached)\n\nLatency:\n  SLI: P95 response time\n  SLO: P95 < 200ms\n  SLA: P95 < 500ms (customers notified if breached)\n\nError Rate:\n  SLI: 5xx errors / total requests\n  SLO: < 0.1% error rate\n\nError Budget:\n  If SLO is 99.9%, you have 0.1% error budget\n  = 43.2 minutes per month to "spend" on incidents\n  Burn through budget → freeze new deployments',
        keyTakeaway:
            'Error budgets make SRE and product teams objective about reliability vs velocity. When error budget is healthy, ship new features. When it is depleted, focus on reliability. This data-driven trade-off removes political arguments.',
      ),
      ConceptLesson(
        title: 'Alerting Best Practices',
        definition:
            'Good alerts fire when users are affected and require human action. Bad alerts are too noisy (alert fatigue) or too silent (miss real incidents). Alert on symptoms (high error rate) not causes (high CPU) where possible.',
        analogy:
            'Good alerting is like a hospital alarm system — it rings when a patient needs immediate attention, not when a nurse walks past a sensor. Alert fatigue from false alarms causes staff to ignore all alarms, including real emergencies.',
        example:
            'Alert on symptoms, not causes:\n\nGOOD alerts (user-impacting):\n  Error rate > 1% for 5 minutes\n  P95 latency > 500ms for 10 minutes\n  Availability < 99% for 1 minute\n  Payment failure rate > 0.5%\n\nBAD alerts (noisy, not actionable):\n  CPU > 70% (normal for healthy servers)\n  Memory > 80% (may be normal caching)\n  Individual slow queries (might be temporary)\n\nPager rules:\n  On-call engineer must respond within 5 minutes\n  Alert must be actionable — if no action possible, not an alert\n  Alert must be urgent — if can wait until morning, use a ticket',
        keyTakeaway:
            'The goal of alerting is zero false positives and zero missed incidents. Every alert that fires and requires no action erodes trust and causes engineers to ignore alerts — including real ones that cause outages.',
      ),
      ConceptLesson(
        title: 'Structured Logging and Log Levels',
        definition:
            'Structured logs use JSON format with consistent fields — making them searchable and aggregatable. Log levels (DEBUG, INFO, WARNING, ERROR, CRITICAL) control verbosity and filter noise in production.',
        analogy:
            'Structured logging is like a hospital admissions form with consistent fields for every patient — vs. a free-text note where each doctor writes differently. Structured logs let you query "all failed payments in the last hour" in seconds.',
        example:
            'import logging\nimport json\n\n# Structured logging setup:\nclass JSONFormatter(logging.Formatter):\n    def format(self, record):\n        return json.dumps({\n            "timestamp": self.formatTime(record),\n            "level": record.levelname,\n            "service": "payment-service",\n            "message": record.getMessage(),\n            "user_id": getattr(record, "user_id", None),\n            "request_id": getattr(record, "request_id", None),\n        })\n\n# Output:\n{"timestamp":"2024-06-15T14:32:01","level":"ERROR",\n "service":"payment-service",\n "message":"Payment failed: Stripe timeout",\n "user_id":42,"request_id":"req-abc123"}\n\n# Log level guidelines:\nDEBUG: detailed diagnostic (dev only)\nINFO: normal operations (request received, payment processed)\nWARNING: unexpected but not failing (retry attempt)\nERROR: operation failed (payment failed, DB error)\nCRITICAL: system-wide failure (DB unreachable)',
        keyTakeaway:
            'Always include request_id, user_id, and service name in every log entry. These three fields let you trace a single user\'s request across all services — invaluable when debugging production issues.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'A user reports that checkout is slow. Which observability tool helps you find WHERE in the request the slowness occurs?',
        options: [
          'Metrics — check CPU graphs',
          'Distributed tracing — shows the timeline breakdown of each service and operation in the request path',
          'Logs — search for "slow"',
          'Alert dashboards'
        ],
        correctIndex: 1,
        explanation:
            'Distributed tracing shows the exact breakdown of a request: Auth 5ms, DB query 380ms, external API 50ms, serialisation 10ms. Without tracing, you would have to guess where the 450ms total was spent.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is an "error budget" in the context of SLOs?',
        options: [
          'The money budgeted for fixing bugs',
          'The allowable downtime or error rate before the SLO is breached — teams can spend this budget on risky deployments, and must stop if it is depleted',
          'The number of alerts per month',
          'The cost of each production incident'
        ],
        correctIndex: 1,
        explanation:
            'An error budget quantifies acceptable unreliability. 99.9% SLO means 0.1% error budget — 43.2 minutes/month. When budget is healthy, teams ship fast. When depleted, reliability work takes priority. Data-driven velocity vs reliability decisions.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is "CPU > 70%" a poor alert condition?',
        options: [
          'CPU metrics are inaccurate',
          'High CPU may be normal (batch jobs, healthy load) and does not directly indicate user impact — alert on symptoms (error rate, latency) not causes',
          'Alerts should only trigger at 100%',
          'CPU alerts require special tooling'
        ],
        correctIndex: 1,
        explanation:
            'Alert on user-impacting symptoms. High CPU might cause slow responses (symptom) — alert on the latency, not the CPU. A batch job can use 90% CPU without any user impact. Cause-based alerts produce false positives that cause alert fatigue.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your on-call phone fires 47 alerts in one hour. Engineers start ignoring them. Root cause: 45 are "CPU > 70%" alerts on healthy servers. What should you do?',
        options: [
          'Hire more on-call engineers to handle the volume',
          'Delete the CPU > 70% alerts — replace with latency > 400ms and error rate > 1% alerts that directly indicate user impact',
          'Increase the CPU threshold to 95%',
          'Mute alerts during business hours'
        ],
        correctIndex: 1,
        explanation:
            'Alert fatigue is more dangerous than too few alerts — engineers stop responding to all alerts including critical ones. Remove alerts that do not require action. Replace with symptom-based alerts (latency, error rate) that always require a human decision.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A critical payment bug occurred at 2:47 AM. Your logs show only: "2:47 AM ERROR: payment failed". What crucial information is missing?',
        options: [
          'The date',
          'user_id, request_id, error details (which payment gateway, error code, amount), and correlation ID to trace across services — without these the bug is nearly impossible to reproduce',
          'The server hostname',
          'The log level'
        ],
        correctIndex: 1,
        explanation:
            'Minimal logs are useless during incidents. Every log entry needs: user_id (who), request_id (which request), operation (what), error details (why it failed), and context (amount, gateway). Missing these turns a 5-minute debug into a 5-hour investigation.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Production Monitoring Setup',
      goal:
          'Add comprehensive observability to the REST API from the CI/CD course — metrics, structured logging, and health checks.',
      steps: [
        'Add structured JSON logging to every API endpoint with: request_id, user_id, endpoint, method, status_code, response_time_ms',
        'Implement a /health endpoint returning: status, uptime, DB connection status, Redis connection status',
        'Add Prometheus metrics using prometheus_client: request_count (counter), request_latency (histogram), active_connections (gauge)',
        'Define 3 SLOs for your API: availability >= 99.9%, P95 latency < 200ms, error rate < 0.5%',
        'Write 3 alert conditions (as code/config) that would trigger based on your SLOs being breached',
        'Create a runbook for the most critical alert: what to check first, second, third when the alert fires',
      ],
      expectedOutput:
          'Structured log example:\n{"timestamp":"2024-06-15T14:32:01","request_id":"req-abc","user_id":42,"endpoint":"/api/orders","method":"POST","status":201,"latency_ms":87}\n\n/health response:\n{"status":"healthy","uptime_seconds":86400,"db":"connected","redis":"connected"}\n\nSLOs defined:\n  Availability: 99.9%\n  P95 Latency: 200ms\n  Error Rate: 0.5%\n\nPrometheus metrics exposed at /metrics ✓\n3 alert rules configured ✓\nRunbook for high error rate documented ✓',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'sep_l10_behavioral_interview',
    topicTitle: 'Behavioral Interviews (STAR Method)',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 210,
    emoji: '🎯',
    intro:
        'At FAANG and top product companies, behavioral interviews carry equal weight to technical rounds. "Tell me about a time you failed", "Describe a conflict with a teammate", "How did you handle a tight deadline?" — these questions test leadership, ownership, and communication. The STAR method transforms vague answers into compelling, structured narratives.',
    concepts: [
      ConceptLesson(
        title: 'The STAR Method',
        definition:
            'STAR structures behavioral answers: Situation (context), Task (your responsibility), Action (what YOU specifically did), Result (quantified outcome). Each answer should take 90-120 seconds.',
        analogy:
            'A STAR story is like a mini movie pitch — setup the scene (Situation), introduce the conflict (Task), show the hero solving it (Action), and close with the impact (Result). Without structure, you ramble. With STAR, you tell a tight, compelling story.',
        example:
            'Question: "Tell me about a time you solved a difficult technical problem."\n\nSituation:\n  "At my previous company, our payment service was experiencing\n   a 3% failure rate during peak hours — costing ₹2L/day in\n   failed transactions."\n\nTask:\n  "I was the backend engineer on-call and took ownership\n   of diagnosing and fixing the issue within 24 hours."\n\nAction:\n  "I used distributed tracing to identify that 80% of failures\n   originated from a specific Stripe API endpoint during load\n   spikes. I implemented a circuit breaker pattern with\n   exponential backoff and a fallback to a secondary payment\n   provider. I also added Redis-based request deduplication\n   to prevent duplicate charges during retries."\n\nResult:\n  "Payment failure rate dropped from 3% to 0.1% within\n   2 hours of deployment. We recovered ₹1.8L/day in revenue\n   and I documented the circuit breaker pattern which was\n   later adopted by 3 other services."',
        keyTakeaway:
            'Quantify results wherever possible: %, ₹, time saved, users impacted. "We improved performance" is weak. "We reduced P95 latency from 800ms to 120ms, increasing checkout conversion by 12%" is compelling and memorable.',
      ),
      ConceptLesson(
        title: 'Amazon Leadership Principles — The Gold Standard',
        definition:
            'Amazon\'s 16 Leadership Principles (Customer Obsession, Ownership, Invent and Simplify, Bias for Action, etc.) are the framework behind most FAANG behavioral questions — explicitly or implicitly.',
        analogy:
            'Amazon Leadership Principles are the scoring rubric for behavioral interviews — even if a company does not use Amazon\'s exact principles, most top companies evaluate the same underlying qualities: customer focus, ownership, data-driven decisions, and delivery.',
        example:
            'Key principles and example questions:\n\nOwnership: "Tell me about a time you went beyond\n  your job description to fix a problem."\n\nBias for Action: "Describe a situation where you had\n  to make a decision without complete information."\n\nDeep Dive: "Tell me about a time you used data to\n  make a decision others were skeptical of."\n\nConflict Resolution: "Describe a time you disagreed\n  with your manager. How did you handle it?"\n\nFail & Learn: "Tell me about your biggest professional\n  failure and what you learned."',
        keyTakeaway:
            'Prepare 6-8 versatile STAR stories covering: technical problem solving, conflict resolution, leadership/ownership, failure/learning, cross-team collaboration, and exceeding expectations. Most questions can be answered with one of these stories.',
      ),
      ConceptLesson(
        title: 'Preparing Your Story Bank',
        definition:
            'A story bank is a curated collection of 6-8 strong STAR stories prepared before interviews — each demonstrating a key competency and adaptable to different question framings.',
        analogy:
            'A story bank is like a musician\'s setlist — pre-selected, rehearsed songs that can be played in any order based on the audience. You do not improvise under pressure; you select the right story and deliver it confidently.',
        example:
            'Essential story bank categories:\n\n1. TECHNICAL ACHIEVEMENT\n   "A complex system I designed or fixed"\n   Demonstrates: engineering depth, problem-solving\n\n2. CONFLICT/DISAGREEMENT\n   "When I disagreed with a decision and handled it well"\n   Demonstrates: communication, professional maturity\n\n3. LEADERSHIP WITHOUT AUTHORITY\n   "When I drove something without being the manager"\n   Demonstrates: influence, ownership\n\n4. FAILURE & LEARNING\n   "My biggest mistake and what I changed"\n   Demonstrates: self-awareness, growth mindset\n\n5. CROSS-TEAM COLLABORATION\n   "Working with non-engineering teams to deliver"\n   Demonstrates: communication, empathy\n\n6. AMBIGUITY/INITIATIVE\n   "Starting something nobody asked me to"\n   Demonstrates: bias for action, innovation',
        keyTakeaway:
            'Write all 6 stories in full STAR format before your first interview. Practice saying each aloud until they take 90-120 seconds naturally. Reviewing your stories the morning of an interview dramatically improves recall under pressure.',
      ),
      ConceptLesson(
        title: 'Questions to Ask the Interviewer',
        definition:
            'Asking thoughtful questions at the end of an interview signals genuine interest, cultural fit evaluation, and strategic thinking. Weak questions (salary, vacation) leave a poor impression. Strong questions demonstrate preparation and engineering depth.',
        analogy:
            'Asking questions is the last impression you make — like the final handshake of a business meeting. Thoughtful questions leave interviewers thinking "this person is already thinking like a team member." Weak questions say "I just want any job."',
        example:
            'Strong questions to ask interviewers:\n\nEngineering culture:\n  "What does a typical on-call rotation look like?\n   How many incidents per week on average?"\n\nGrowth:\n  "What does the path look like from senior engineer\n   to staff engineer here?"\n\nTech strategy:\n  "What is the biggest technical challenge the team\n   is working through right now?"\n\nTeam health:\n  "How does the team handle technical debt vs feature work?\n   What is the current ratio?"\n\nOnboarding:\n  "What would success look like for the first 90 days\n   in this role?"',
        keyTakeaway:
            'Prepare 3-5 questions for each interviewer (different questions for engineers vs managers). Asking zero questions signals low interest and often tanks an otherwise strong interview.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'In a STAR behavioral answer, what should the "Result" component always include where possible?',
        options: [
          'Technical implementation details',
          'Quantified outcomes — percentages, money, time saved, users impacted — that show the concrete impact of your actions',
          'What you would do differently next time',
          'The names of team members involved'
        ],
        correctIndex: 1,
        explanation:
            'Quantified results transform weak answers into memorable ones. "Improved performance" is forgettable. "Reduced page load by 65%, increasing conversion by 8% and generating ₹20L additional monthly revenue" is specific, credible, and impressive.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which of these is a STRONG question to ask at the end of a technical interview?',
        options: [
          '"What is the salary for this role?"',
          '"What is the biggest technical challenge the team faces right now?"',
          '"How many vacation days do I get?"',
          '"When will I hear back?"'
        ],
        correctIndex: 1,
        explanation:
            'Asking about technical challenges shows genuine interest in the work, opens a collaborative conversation, and positions you as someone thinking about contributing — not just collecting a paycheck. Compensation questions are for the recruiter, not the technical interviewer.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'How many STAR stories should you prepare before an interview, and why?',
        options: [
          '1-2 stories — focus on depth over breadth',
          '6-8 versatile stories covering different competencies — most questions can be answered from this bank, adapted to the specific question',
          '20+ stories — one for every possible question',
          'No preparation — authentic spontaneous answers are better'
        ],
        correctIndex: 1,
        explanation:
            '6-8 well-prepared stories cover the full range of behavioral questions. Fewer and you will be caught without a relevant story. More and you cannot rehearse them all well. Versatile stories can be adapted: the same "failure" story can answer "tell me about a challenge", "tell me about handling pressure", and "tell me what you learned".',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Interview question: "Tell me about a conflict with a teammate." A candidate says: "My teammate was wrong about the database choice, I argued with them, eventually my manager sided with me." Rate this answer and identify what is missing.',
        options: [
          'Good answer — clear and direct',
          'Weak answer — no STAR structure, no empathy shown, "I argued" sounds aggressive, no quantified result, no learning demonstrated',
          'Perfect answer — conflict and resolution are clear',
          'Good but too short — needs more technical detail'
        ],
        correctIndex: 1,
        explanation:
            'Strong conflict answers show: the specific disagreement (Task), the professional approach taken — data gathered, listened to their perspective (Action), the outcome for the PRODUCT not just "I won" (Result), and what the working relationship looked like after (learning/relationship).',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You are asked "Tell me about your greatest weakness." Which is the BEST response strategy?',
        options: [
          '"I work too hard — I am a perfectionist"',
          'Name a real, specific weakness you have actively worked to improve, describe the steps you took, and show measurable progress — authentic and growth-focused',
          '"I have no significant weaknesses"',
          'Deflect with "I am still learning everything"'
        ],
        correctIndex: 1,
        explanation:
            '"Perfectionist" and "work too hard" are seen as evasions. A genuine weakness (e.g. "I used to struggle with saying no, which led to overcommitment") with a concrete improvement story (saying no framework, result: on-time delivery improved) shows self-awareness and growth mindset.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Personal Story Bank and Mock Behavioral Interview',
      goal:
          'Build a complete story bank and conduct a recorded mock behavioral interview.',
      steps: [
        'Write 6 full STAR stories (300-400 words each) covering: technical achievement, conflict, leadership, failure, collaboration, initiative',
        'For each story, add: the Amazon Leadership Principle it best demonstrates, 3 alternative questions it can answer, and the key metrics/numbers',
        'Record yourself answering 3 behavioral questions using your story bank — target 90-120 seconds each',
        'Review recordings: does each answer have clear STAR structure? Are results quantified? Is the pacing comfortable?',
        'Prepare 5 questions to ask interviewers — one for each: engineering culture, growth path, technical challenge, team dynamics, success definition',
        'Write a one-paragraph personal pitch: "Tell me about yourself" covering background, key achievements, and why this role',
      ],
      expectedOutput:
          'Story Bank: 6 stories documented with STAR structure ✓\nEach story: LP identified, 3 alternate questions noted, results quantified ✓\n\nRecorded mock answers:\n  Story 1 (Technical): 1m 45s — within range ✓\n  Story 2 (Conflict): 2m 10s — slightly long, trim Action section\n  Story 3 (Failure): 1m 30s — strong quantified result ✓\n\n5 interviewer questions prepared ✓\nPersonal pitch (60 seconds): recorded and reviewed ✓',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'sep_l10_technical_interview',
    topicTitle: 'Technical Interview Preparation',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 38,
    totalXp: 255,
    emoji: '💻',
    intro:
        'Technical interviews at product companies test coding ability, problem-solving process, and communication simultaneously. Knowing the algorithms is necessary but not sufficient — you must also communicate your thinking, handle edge cases gracefully, and write clean readable code under pressure. This course builds the complete technical interview skillset.',
    concepts: [
      ConceptLesson(
        title: 'The Technical Interview Process at Product Companies',
        definition:
            'Product company technical interviews typically have 4-6 rounds: online assessment (2 coding problems, 90 min), phone screen (1-2 problems with interviewer), technical phone/video (data structures + algorithms), system design (senior+), and a bar raiser round.',
        analogy:
            'The interview process is like a marathon with multiple checkpoints — each round filters differently, and you must conserve energy and strategy for each stage. Burning all your preparation on online assessments while neglecting system design is like sprinting the first 5km and walking the rest.',
        example:
            'Typical interview pipeline:\n\nOnline Assessment (OA):\n  LeetCode-style, 2 problems, 90 minutes\n  Auto-graded, no interviewer present\n  Strategy: pass test cases first, optimise second\n\nPhone Screen:\n  45 minutes, 1-2 medium problems\n  Coding in shared editor (CoderPad, HackerRank)\n  Interviewer observes and can hint\n\nTechnical Interview (Virtual Onsite):\n  4-5 rounds, 45-60 min each\n  Mix of: coding, system design, behavioral\n\nBar Raiser (Amazon) / Cross-functional:\n  Ensures hiring bar across the company\n  Often harder than regular rounds',
        keyTakeaway:
            'Most candidates fail OA because they optimise prematurely. Pass all test cases first with any working solution, then optimise. A brute-force solution scoring 8/10 test cases beats a TLE optimal solution scoring 0/10.',
      ),
      ConceptLesson(
        title: 'Time and Space Complexity Communication',
        definition:
            'Stating complexity clearly and confidently is a distinct interview skill. "The time complexity is O(n log n) because we sort once and then do a linear scan" demonstrates understanding better than just stating "O(n log n)".',
        analogy:
            'Stating complexity is like a doctor explaining a diagnosis — "Your blood pressure is 140/90 which is Stage 1 hypertension, caused by the elevated systolic reading" is more credible than just "Your blood pressure is high." The explanation proves understanding.',
        example:
            'How to state complexity in interviews:\n\nNOT this:\n  "The time complexity is O(n²)"\n\nDO this:\n  "The time complexity is O(n²) because we have nested\n   loops — for each of the n elements we scan the\n   remaining n elements. The space complexity is O(1)\n   because we only use a fixed number of variables\n   regardless of input size."\n\nCommon complexities to know cold:\n  O(1): hash lookup, array access\n  O(log n): binary search, balanced BST\n  O(n): linear scan, sum of array\n  O(n log n): sorting, merge sort, heap operations\n  O(n²): nested loops, bubble sort\n  O(2^n): recursive subset generation\n  O(n!): permutation generation',
        keyTakeaway:
            'Always state both time AND space complexity. Many candidates forget space. If you use a hash map, that is O(n) space — mention it. Interviewers notice when you forget and it suggests incomplete analysis.',
      ),
      ConceptLesson(
        title: 'Writing Clean Interview Code',
        definition:
            'Interview code should be readable, use meaningful variable names, handle edge cases visibly, and include brief comments for non-obvious logic — even under time pressure. Clean code signals professional experience.',
        analogy:
            'Interview code is like a live cooking demonstration — not just about the result but the technique. A chef who narrates, keeps the workspace tidy, and handles unexpected situations gracefully impresses more than one who produces the same dish sloppily.',
        example:
            '# POOR interview code:\ndef f(a, b, n):\n    r = []\n    for i in range(len(a)):\n        for j in range(len(b)):\n            if a[i] + b[j] == n:\n                r.append([a[i], b[j]])\n    return r\n\n# GOOD interview code:\ndef find_pairs_summing_to_target(arr1, arr2, target):\n    """Find all pairs (x, y) where x in arr1, y in arr2, x+y=target."""\n    lookup = set(arr1)  # O(n) space for O(1) lookup\n    pairs = []\n\n    for num in arr2:           # O(m) iterations\n        complement = target - num\n        if complement in lookup:  # O(1) lookup\n            pairs.append((complement, num))\n\n    return pairs\n    # Time: O(n+m), Space: O(n)',
        keyTakeaway:
            'In interviews, use full variable names — num not n, target not t, pairs not p. You can type fast enough. Meaningful names prevent you from getting confused mid-solution and help interviewers follow your logic.',
      ),
      ConceptLesson(
        title: 'Handling Edge Cases in Interviews',
        definition:
            'Before writing code, enumerate edge cases aloud: empty input, single element, all identical elements, negative numbers, integer overflow, duplicate values. Handling them proactively impresses interviewers far more than being prompted.',
        analogy:
            'Handling edge cases in interviews is like a pilot going through the pre-flight checklist — not because they expect every warning to fire, but because methodically covering all possibilities is what separates professionals from amateurs.',
        example:
            'Edge case checklist to verbalize:\n\nFor array problems:\n  "What if the array is empty? I will return [] / 0 / None"\n  "What if it has one element? My algorithm still works because..."\n  "What if all elements are the same?"\n  "What if the target is not present?"\n\nFor string problems:\n  "What if the string is empty?"\n  "Is the input case-sensitive?"\n  "Can it contain spaces or special characters?"\n\nFor tree problems:\n  "What if the root is None?"\n  "What if it is a single node with no children?"\n\nFor number problems:\n  "Can values be negative?"\n  "Can integers overflow? (use Python: unlimited precision)"',
        keyTakeaway:
            'State edge cases BEFORE coding, handle them as you code, and test against them at the end. An interviewer who needs to prompt "what about an empty array?" will rate you lower than one who brought it up unprompted.',
      ),
      ConceptLesson(
        title: 'LeetCode Study Plan for 8 Weeks',
        definition:
            'A structured 8-week study plan covers the highest-frequency patterns in order of importance: arrays/strings, hash maps, two pointers, sliding window, binary search, trees, BFS/DFS, dynamic programming.',
        analogy:
            'An 8-week study plan is like a gym training programme — you do not train every muscle randomly. You focus on foundational strength first, build specific skills week by week, and track progress with clear targets.',
        example:
            'Week 1-2: Arrays, Strings, Hash Maps\n  Two Sum, Valid Anagram, Group Anagrams\n  Product of Array Except Self\n  Target: 20 Easy + 10 Medium\n\nWeek 3-4: Two Pointers, Sliding Window, Binary Search\n  3Sum, Container With Most Water\n  Longest Substring Without Repeating\n  Target: 15 Medium\n\nWeek 5-6: Trees, Graphs, BFS/DFS\n  Level Order Traversal, Path Sum\n  Number of Islands, Clone Graph\n  Target: 15 Medium + 5 Hard\n\nWeek 7-8: Dynamic Programming + Review\n  Coin Change, Longest Common Subsequence\n  House Robber, Edit Distance\n  Target: 10 Medium DP + 5 Hard',
        keyTakeaway:
            'Quality beats quantity. Solving 100 problems you understand deeply beats solving 300 by looking at solutions immediately. For each problem: solve it yourself, compare to optimal, identify the pattern, and revisit similar problems.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'In an online assessment with 2 problems and 90 minutes, your first solution passes 8/10 test cases. You still have 40 minutes and problem 2 is untouched. What should you do?',
        options: [
          'Keep optimising until problem 1 passes all 10 test cases',
          'Move to problem 2 immediately — a partial score on problem 1 plus a complete solution on problem 2 likely beats 10/10 on one problem with 0 on the other',
          'Submit what you have and leave early',
          'Spend 10 more minutes on problem 1 then switch'
        ],
        correctIndex: 1,
        explanation:
            'Most OA scoring systems give partial credit per test case. An 8/10 + 7/10 = 15/20 beats 10/10 + 0/10 = 10/20. Time allocation across problems is a critical OA strategy that many candidates miss.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What should you say when you do not immediately know the solution to an interview problem?',
        options: [
          'Stay silent and think for 5 minutes',
          '"Let me think through this out loud. A brute force approach would be O(n²) nested loops. I think we can do better — let me see if a hash map can help us get O(n)..."',
          'Ask the interviewer to give you a hint',
          'Say "I do not know this problem"'
        ],
        correctIndex: 1,
        explanation:
            'Thinking aloud shows your problem-solving process — which interviewers value highly. Starting with brute force demonstrates understanding of the problem. Reasoning toward an optimisation shows algorithmic thinking. Silence gives interviewers nothing to evaluate.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'You finish coding your solution in 20 minutes with 15 minutes left. What should you do next?',
        options: [
          'Submit and say you are done',
          'Trace through your code with the example input, check edge cases, state the time and space complexity, then ask if the interviewer wants you to optimise further',
          'Start optimising immediately without tracing',
          'Wait quietly for the interviewer to respond'
        ],
        correctIndex: 1,
        explanation:
            'After coding: trace through an example (often catches bugs before the interviewer does), handle edge cases, state complexity. Then offer to optimise — this shows initiative. Submitting without review often means submitting with bugs.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Two Sum problem: find indices of two numbers that sum to target. Your first instinct is nested loops. What is the optimal approach?',
        options: [
          'Sort the array — O(n log n)',
          'Use a hash map: for each number, check if (target - number) is already in the map. O(n) time, O(n) space — one pass through the array',
          'Binary search for the complement — O(n log n)',
          'Two pointer approach — requires sorting first'
        ],
        correctIndex: 1,
        explanation:
            'Hash map: as you scan, store {value: index}. For each new number, check if complement (target - num) exists in the map. If yes, return both indices. O(n) time — the canonical hash map optimization pattern.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You solve a problem in O(n²). The interviewer asks "can you do better?" You are not sure of the O(n log n) approach. What do you say?',
        options: [
          '"No, O(n²) is optimal"',
          '"Let me think — O(n²) is the nested loop approach. For better complexity I would consider: sorting (O(n log n)), a hash map for O(1) lookup (O(n) total), or a two-pointer approach on sorted data. Let me explore the two-pointer..." — think aloud toward the answer',
          '"I do not know a better approach"',
          'Ask for a hint immediately'
        ],
        correctIndex: 1,
        explanation:
            'Thinking aloud about possible approaches shows structured thinking even when you do not know the answer immediately. Interviewers want to see the process. Mentioning the standard optimisation paths (hash map, sort+two pointer, binary search) often leads you to the right answer.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Mock Technical Interview Session',
      goal:
          'Complete a full simulated technical interview: 2 coding problems with full interview protocol including complexity analysis and edge cases.',
      steps: [
        'Set a 45-minute timer and solve: "Given an array, find the maximum profit from buying and selling a stock once" — follow the full Think-Code-Verify-Complexity framework',
        'Set another 45-minute timer and solve: "Given a matrix, find the number of islands (connected groups of 1s)" — use BFS with a queue',
        'For each solution: document the pattern used, brute force approach, optimal approach, time complexity, space complexity, and 3 edge cases',
        'Write the code as if in an interview — meaningful variable names, brief comments, handle edge cases explicitly in code',
        'Record yourself explaining problem 2 (islands) — narrate your thought process as if to an interviewer',
        'Self-evaluate: did you verbalize your approach before coding? Did you state complexity? Did you handle edge cases?',
      ],
      expectedOutput:
          'Problem 1: Max Stock Profit\n  Pattern: Sliding Window / One Pass\n  Brute force: O(n²), Optimal: O(n)\n  Space: O(1)\n  Edge cases: empty, all decreasing, single element\n  Time taken: 18 minutes ✓\n\nProblem 2: Number of Islands\n  Pattern: BFS / DFS on Grid\n  Time: O(m*n), Space: O(min(m,n)) for BFS queue\n  Edge cases: empty grid, all water, all land\n  Time taken: 24 minutes ✓\n\nSelf-eval: verbalized approach ✓ | complexity stated ✓ | edge cases handled ✓',
      xpReward: 70,
    ),
  ),
  TopicCourse(
    id: 'sep_l10_salary_career',
    topicTitle: 'Salary Negotiation & Career Paths',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 28,
    totalXp: 200,
    emoji: '💼',
    intro:
        'The difference between accepting the first offer and negotiating can be ₹3-10 lakhs per year — over a career that compounds to crores. Understanding how to evaluate offers, negotiate confidently, and choose between freelancing, startups, and product companies shapes your entire engineering career trajectory.',
    concepts: [
      ConceptLesson(
        title: 'Salary Negotiation Fundamentals',
        definition:
            'Salary negotiation is expected by employers — making a counter-offer does not cost you the offer. The goal is to provide market data for your counter, not just "I want more money." Your leverage is highest between offer and acceptance.',
        analogy:
            'Salary negotiation is like buying a car — the sticker price is a starting point, not a final offer. The seller expects negotiation. Paying sticker price without asking is leaving money on the table that the seller was prepared to give.',
        example:
            'Negotiation framework:\n\n1. GET THE OFFER IN WRITING first\n\n2. RESEARCH market rate:\n   Glassdoor, Levels.fyi, LinkedIn Salary\n   "Senior Backend Engineer in Bengaluru: ₹30-45 LPA"\n\n3. EXPRESS GRATITUDE then COUNTER:\n   "Thank you for the offer — I am very excited about\n    this role. Based on my research and my experience\n    with distributed systems, I was expecting something\n    closer to ₹40 LPA. Is there flexibility there?"\n\n4. JUSTIFY with SPECIFICS:\n   "I have direct experience with the Kafka/Kubernetes\n    stack you use, which means I can contribute\n    immediately without ramp-up time."\n\n5. NEGOTIATE TOTAL COMP:\n   Base salary + equity (ESOPs) + signing bonus\n   + joining date flexibility + remote work',
        keyTakeaway:
            'Never be the first to name a number in early conversations. "What is your expected CTC?" — respond: "I am more interested in finding the right fit. Could you share the budget for this role?" This preserves negotiating leverage.',
      ),
      ConceptLesson(
        title: 'Freelancing vs Startup vs Product Company',
        definition:
            'Each path offers fundamentally different trade-offs in compensation, learning, stability, autonomy, and career trajectory. Understanding these trade-offs helps you make deliberate career decisions instead of reactive ones.',
        analogy:
            'Choosing between freelancing, startups, and product companies is like choosing between owning your own taxi, driving for a growth-stage Ola, or working for Indian Railways — wildly different in risk, reward, structure, and day-to-day experience.',
        example:
            'Comparison:\n\nFreelancing:\n  + Highest hourly rate (₹2000-8000/hr senior)\n  + Complete autonomy\n  - No equity, no team, no stability\n  - Self-marketing, accounting, finding clients\n  Best for: 5+ years experience, strong network\n\nEarly Startup (< Series B):\n  + Significant equity (0.1%-1% ESOP possible)\n  + Rapid learning, wear many hats\n  - Low base salary, high risk (80% fail)\n  - Long hours, unclear processes\n  Best for: risk-tolerant, entrepreneurial mindset\n\nProduct Company (Series C+ / FAANG):\n  + High base + good equity + benefits\n  + Structured career path, best practices\n  - Slower growth, more processes\n  - May not see your equity vest (4-year cliff)\n  Best for: financial stability with growth',
        keyTakeaway:
            'In your first 2-3 years: prioritise learning over compensation. A lower salary at a company where you will learn systems, scale, and best practices from senior engineers is worth more than higher pay at a company where you will stagnate.',
      ),
      ConceptLesson(
        title: 'Evaluating Job Offers Beyond Base Salary',
        definition:
            'Total compensation includes base salary, equity (ESOPs/RSUs), signing bonus, annual bonus, and benefits. Understanding equity value, vesting schedules, and strike prices is essential to comparing offers accurately.',
        analogy:
            'A job offer is like a multi-ingredient recipe — judging it by one ingredient (base salary) gives a completely wrong picture. An offer with lower base but significant equity at a pre-IPO company might be worth 10x more than a higher-salary offer at a mature company.',
        example:
            'Evaluating equity:\n\nPublic company RSUs:\n  500 RSUs * ₹4000/share = ₹20L over 4 years\n  Vesting: 25% year 1, monthly thereafter\n  Real value: known at grant time\n\nPre-IPO ESOPs:\n  0.1% of company at ₹200Cr valuation = ₹20L\n  But company fails 80% of the time\n  IF it 10x to ₹2000Cr valuation at exit: ₹2Cr\n  Strike price + tax implications matter\n\nOffer comparison checklist:\n  Total annual cash (base + bonus)\n  Equity value at current valuation\n  Equity vesting schedule (cliff period)\n  Benefits: health insurance, WFH policy\n  Learning opportunities\n  Team and manager quality',
        keyTakeaway:
            'Ask about the last 409A valuation and strike price for private company ESOPs. High ESOP count is meaningless if the strike price equals current valuation — there is no upside. Real upside requires options granted below current market price.',
      ),
      ConceptLesson(
        title: 'Building a Long-Term Engineering Career',
        definition:
            'A deliberate engineering career has clear milestones: Junior (0-2y), Mid-level (2-5y), Senior (5-8y), Staff (8-12y), Principal/Architect (12y+). Each level requires different skills — technical depth early, then technical breadth and influence.',
        analogy:
            'An engineering career is like climbing a mountain range — each peak gives you a view of the next peak. Junior engineers solve well-defined problems. Seniors own solutions. Staff engineers define what problems to solve. Principals define the mountain range itself.',
        example:
            'Level expectations (approximate):\n\nJunior (0-2 years):\n  Solves defined tasks, learns from seniors\n  Output: working code with guidance\n\nMid-Level (2-5 years):\n  Owns features end-to-end independently\n  Mentors juniors, reviews code\n\nSenior (5-8 years):\n  Designs systems, makes architectural decisions\n  Defines engineering standards for the team\n\nStaff (8-12 years):\n  Cross-team technical leadership\n  Drives multi-quarter technical strategy\n\nPrincipal (12+ years):\n  Company-wide technical direction\n  Defines engineering culture',
        keyTakeaway:
            'Moving from Senior to Staff is the hardest transition — it requires shifting from "delivering code" to "multiplying the team." If you cannot describe how your work made other engineers more effective, you are not yet operating at Staff level.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'An employer asks "What is your expected CTC?" in an early screening call. What is the best response?',
        options: [
          'Give your exact current CTC',
          '"I am focused on finding the right fit — could you share the budgeted range for this role so I know if we are aligned?"',
          '"₹50 LPA minimum"',
          'Decline to answer'
        ],
        correctIndex: 1,
        explanation:
            'Whoever names a number first is at a disadvantage. Asking for the range reveals their budget without committing you to a number. If the range is ₹35-50 LPA and you said ₹35, you left money on the table. Knowing their range lets you anchor at the top.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A startup offers ₹12 LPA base + 0.5% ESOP at ₹100Cr valuation. A product company offers ₹20 LPA + no equity. How should you compare these?',
        options: [
          'Product company is clearly better — higher base',
          'You must evaluate both total comp and risk: the 0.5% ESOP is worth ₹50L IF the startup succeeds at current valuation — but 80% of startups fail. Factor in learning quality, team, and personal financial situation',
          'Always choose equity over salary',
          'ESOP always has no value'
        ],
        correctIndex: 1,
        explanation:
            'ESOP is high-variance: could be worth ₹0 (company fails) or crores (successful exit). The ₹8 LPA salary difference is certain money. The right choice depends on your financial situation, risk tolerance, the startup\'s stage and team, and how much you value the learning.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the most important factor in your first engineering job?',
        options: [
          'Highest salary available',
          'Learning quality — a lower-paying job where you learn scalable systems from great engineers is worth more long-term than higher pay in a stagnant environment',
          'Brand name of the company',
          'Work from home policy'
        ],
        correctIndex: 1,
        explanation:
            'Early career learning compounds. Engineers who learn distributed systems, CI/CD, and code review culture in their first job earn ₹5-10 LPA more by their third year than those who did not. Optimising for learning in years 1-3 maximises lifetime earnings.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You receive an offer of ₹28 LPA. Your research shows market rate is ₹32-38 LPA for your skills. How do you respond?',
        options: [
          'Accept immediately — any offer is good',
          '"Thank you for the offer. I am very excited about this opportunity. Based on my research and skills in distributed systems and Python, I was expecting ₹35 LPA. Is there flexibility to get closer to that range?"',
          '"Your offer is too low. I need ₹40 LPA"',
          'Ask for 1 week to decide without countering'
        ],
        correctIndex: 1,
        explanation:
            'Express enthusiasm (you want the role), provide market data (not just desire), name a specific target (₹35, not "more"), and ask if there is flexibility (not a demand). This professional approach rarely costs you the offer and often gets 5-15% more.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You are 3 years into your career at a service company writing CRUD apps. You want to grow faster. What is the most impactful career move?',
        options: [
          'Ask for a promotion at the same company',
          'Join a product company or growth-stage startup where you will work on scale problems, distributed systems, and be surrounded by engineers who have solved harder problems — the learning will compound your career',
          'Start freelancing immediately',
          'Get a master\'s degree'
        ],
        correctIndex: 1,
        explanation:
            'Environment is the most impactful career accelerant. CRUD apps at a service company rarely expose you to the scale, architecture, and engineering culture that accelerates growth. Moving to a product company or startup engineering culture changes your ceiling significantly.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Career Strategy Document',
      goal:
          'Create a complete personal career strategy document covering the next 5 years.',
      steps: [
        'Current state audit: list your technical skills, domain experience, and gaps compared to senior engineers in your target role',
        'Research 3 target companies and their tech stacks, engineering culture, and typical compensation ranges (use Glassdoor, Levels.fyi)',
        'Write a 5-year career plan with milestones: 1 year (mid-level), 3 years (senior), 5 years (staff/lead)',
        'Document your negotiation strategy: research market rate for your target role, write a 3-sentence counter-offer script',
        'Evaluate one hypothetical offer using the full checklist: base, equity, vesting, benefits, learning, team quality, growth path',
        'Define your personal non-negotiables (remote work, tech stack, product vs service) and why',
      ],
      expectedOutput:
          'Career Strategy Document:\n\nCurrent gaps identified: system design depth, distributed systems experience, leadership experience\n\n3 target companies researched with compensation ranges ✓\n\n5-year milestones:\n  Year 1: Senior Engineer at product company\n  Year 3: Tech Lead / Staff Engineer\n  Year 5: Engineering Manager or Principal Engineer\n\nNegotiation script written ✓\nOffer evaluation: ₹32 LPA + 0.2% ESOP analysed correctly ✓\n3 personal non-negotiables defined ✓',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'sep_l10_portfolio_capstone',
    topicTitle: 'Production Portfolio & Final Capstone',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 50,
    totalXp: 350,
    emoji: '🏆',
    intro:
        'This is the final capstone — where everything from all 10 levels comes together. You will design, build, and deploy a production-grade full-stack application with scalable architecture, authentication, REST APIs, comprehensive testing, CI/CD pipeline, Docker, monitoring, and complete documentation. This project becomes the centrepiece of your engineering portfolio.',
    concepts: [
      ConceptLesson(
        title: 'What Makes a Portfolio Project Stand Out',
        definition:
            'Hiring managers see hundreds of to-do apps and weather apps. A standout portfolio project solves a real problem, demonstrates production-level thinking (auth, error handling, tests, docs), and can be explained in 2 minutes with technical depth.',
        analogy:
            'A standout portfolio project is like a chef\'s signature dish in a job application — not just any dish, but one that shows technique, creativity, and understanding of why each ingredient matters. It is the conversation piece that defines you.',
        example:
            'Portfolio project evaluation checklist:\n\nProblem: Does it solve something real/interesting?\nCode quality: Would it pass a senior code review?\nTesting: Is there a meaningful test suite?\nDocumentation: Can a new developer run it in < 5 min?\nArchitecture: Is the design intentional and explained?\nDeployment: Is it live and accessible?\nGitHub: Is the commit history clean and descriptive?\nExplainability: Can you explain every decision made?\n\nStrong project ideas:\n  Real-time collaborative document editor\n  Job application tracker with analytics\n  API rate limiting service (demonstrates infra knowledge)\n  Code snippet sharing platform\n  Personal finance tracker with ML categorisation',
        keyTakeaway:
            'One excellent, deeply built project is worth more than ten surface-level projects. Interviewers can tell the difference between a project built in a weekend vs. one built with production-level care. Quality over quantity.',
      ),
      ConceptLesson(
        title: 'GitHub Portfolio Best Practices',
        definition:
            'A professional GitHub profile has a pinned README, clean commit history, meaningful PR descriptions, proper project documentation, and consistent contribution activity that signals engineering discipline.',
        analogy:
            'Your GitHub profile is like a live CV that updates in real time — hiring managers review it the same day they read your resume. A green contribution graph, clean commit messages, and well-documented repos signal professional habits.',
        example:
            'GitHub profile checklist:\n\nProfile README.md:\n  - 2-sentence bio\n  - Current tech stack (Python, FastAPI, PostgreSQL, Docker)\n  - Top 3 projects with one-line descriptions\n  - Link to portfolio/LinkedIn\n\nEach pinned repo:\n  - Clear README: What, Why, How to run in < 5 commands\n  - Architecture diagram or explanation\n  - Screenshots or demo GIF\n  - Tech stack badges\n  - Tests and CI status badge\n\nCommit discipline:\n  "feat: add JWT authentication with refresh tokens"\n  "fix: resolve race condition in inventory deduction"\n  "test: add integration tests for payment flow"\n  NOT: "fix", "update", "asdf", "final final v3"',
        keyTakeaway:
            'Commit message discipline is immediately visible in interviews. A repository with 200 commits all saying "update" tells an interviewer you do not care about engineering craft. Conventional Commits format (feat:, fix:, docs:) signals professionalism.',
      ),
      ConceptLesson(
        title: 'The Architecture of Your Capstone Project',
        definition:
            'The capstone project follows production architecture: React/Flutter frontend → FastAPI backend → PostgreSQL + Redis → Docker Compose for local dev → GitHub Actions CI/CD → Deployed on cloud with monitoring.',
        analogy:
            'Building the capstone project is like building a model city — every infrastructure element (roads, utilities, zoning) represents a real production concept (load balancer, cache, auth). The city must be functional end-to-end, not just pretty buildings.',
        example:
            'Capstone project architecture:\n\nFrontend: React or Flutter (already your specialty)\nBackend: FastAPI with:\n  - JWT authentication (access + refresh tokens)\n  - RBAC authorization\n  - Pagination, filtering, sorting\n  - Request validation with Pydantic\n  - Comprehensive error handling\nDatabase: PostgreSQL with:\n  - Proper schema with indexes\n  - Migration management (Alembic)\nCache: Redis for:\n  - Session management\n  - Rate limiting\n  - Hot data caching\nInfrastructure:\n  - Docker + docker-compose.yml\n  - GitHub Actions CI/CD\n  - Deployed to Render/Railway/EC2\n  - Structured logging + /health endpoint',
        keyTakeaway:
            'Each layer of the architecture should be justifiable in an interview. "I used Redis for rate limiting because Redis supports atomic INCR operations which are perfect for counters without race conditions" — this level of explanation wins interviews.',
      ),
      ConceptLesson(
        title: 'Documenting and Presenting Your Project',
        definition:
            'Project documentation is the bridge between your code and your interviewer\'s understanding. A great README, architecture diagram, and 5-minute demo video make your project 10x more accessible and memorable.',
        analogy:
            'Documentation is like a product\'s instruction manual — the best products are intuitive, but great documentation ensures even a first-time user succeeds. A brilliant project without documentation is like a restaurant with no menu.',
        example:
            'README structure for capstone:\n\n# Project Name — One-line description\n\n## Demo\n[Link to live app] | [Link to demo video (2-3 min)]\n\n## Features\n- JWT auth with refresh token rotation\n- RBAC (admin, user, moderator)\n- Real-time notifications via WebSockets\n- Full-text search with PostgreSQL\n- Rate limiting (100 req/min per user)\n\n## Architecture\n[Architecture diagram image]\n\n## Getting Started (< 5 commands)\ngit clone ...\ncp .env.example .env\ndocker compose up\n# API at localhost:8000, docs at /docs\n\n## Tech Stack + Rationale\nFastAPI: async performance, auto-generated OpenAPI docs\nPostgreSQL: ACID transactions for financial operations\n\n## Testing\npytest --cov=app → 87% coverage\n\n## API Documentation\nhttps://your-app.com/docs (Swagger UI)',
        keyTakeaway:
            'A demo video walkthrough (2-3 minutes on Loom) is extremely powerful — interviewers can quickly understand your project without running it locally. Keep it focused: architecture decision → one feature end-to-end → code walkthrough.',
      ),
      ConceptLesson(
        title: 'Explaining Your Project in Interviews',
        definition:
            'The ability to explain your project clearly at three levels — executive summary (30 seconds), technical overview (2 minutes), and deep dive (10+ minutes) — is a critical interview skill that most candidates do not prepare for.',
        analogy:
            'Explaining your project at different levels is like a doctor explaining a diagnosis — to the patient (simple, outcome-focused), to a GP (clinical overview), and to a specialist (full technical detail). Context determines depth.',
        example:
            '30-second summary (to non-technical interviewer):\n  "I built a job application tracker that lets users\n   manage their job search pipeline, get analytics on\n   their application patterns, and receive AI-powered\n   resume suggestions. It is used by 200 beta users."\n\n2-minute technical overview (to senior engineer):\n  "The backend is FastAPI with PostgreSQL for persistence\n   and Redis for caching and rate limiting. I implemented\n   JWT auth with refresh token rotation, RBAC for three\n   user roles, and built a CI/CD pipeline with GitHub\n   Actions that runs 42 tests and deploys Docker containers\n   to Render on every main branch push."\n\n10-minute deep dive:\n  Walk through architecture decisions, specific\n  trade-offs, interesting bugs you solved, and\n  what you would change if starting over.',
        keyTakeaway:
            'Prepare all three levels and practice until they are fluid. Most interviews will start with "tell me about a project you are proud of" — having a sharp, practiced answer makes a strong first impression.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What distinguishes an interview-ready portfolio project from a tutorial project?',
        options: [
          'The programming language used',
          'Production-level thinking: authentication, error handling, tests, CI/CD, documentation, meaningful commit history, and ability to explain every architectural decision made',
          'The number of features implemented',
          'The use of the latest framework versions'
        ],
        correctIndex: 1,
        explanation:
            'Interviewers probe: "Why did you choose PostgreSQL over MongoDB?", "How does your auth handle token refresh?", "What does your test suite cover?". Tutorial projects cannot answer these. Production-level thinking anticipates and answers them before being asked.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Your README says "run the app with python app.py". What is missing?',
        options: [
          'Nothing — that is clear enough',
          'Prerequisites (Python version, pip), environment setup (cp .env.example .env), dependency installation, database setup, and ideally a docker-compose option for one-command startup',
          'Screenshots should be added',
          'The license should be specified first'
        ],
        correctIndex: 1,
        explanation:
            'A new developer should be able to run your project in under 5 minutes following your README. Missing prerequisites, env setup, or database migration steps means the README fails its primary purpose — and signals you do not think about other people\'s experience.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'An interviewer asks "Why did you use Redis instead of storing sessions in PostgreSQL?" You chose Redis just because tutorials use it. What should you say?',
        options: [
          '"Because everyone uses Redis for sessions"',
          'Be honest but informed: "I initially followed common practice, but I learned that Redis\' in-memory storage gives sub-millisecond session lookups versus PostgreSQL\'s ~10ms, and atomic INCR for rate limiting avoids race conditions — these are the concrete reasons Redis fits better."',
          '"Redis is more modern"',
          'Change the subject'
        ],
        correctIndex: 1,
        explanation:
            'Honesty plus learning signals maturity. You started with convention but researched the "why" — sub-millisecond lookup, atomic operations, built-in TTL for session expiry. Interviewers respect engineers who understand their tools rather than copying them blindly.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your portfolio project is a to-do app. An interviewer seems unimpressed. How do you make even a simple project interview-worthy?',
        options: [
          'Abandon it and build something more impressive immediately',
          'Depth over novelty: add JWT auth with refresh tokens, RBAC for shared lists, WebSocket real-time updates, comprehensive test suite (85%+ coverage), Docker setup, CI/CD, monitoring endpoints, and document architectural decisions — the same "to-do app" becomes a system design showcase',
          'Add more features quickly',
          'Rename it to something impressive-sounding'
        ],
        correctIndex: 1,
        explanation:
            'A simple domain with production depth beats a complex domain with surface implementation. Interviewers care about HOW you built it, not WHAT you built. Production patterns (auth, tests, CI/CD, docs) on a to-do app demonstrate more than a complex app with no auth, no tests, and "works on my machine."',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You have 3 months before your target interview. How do you allocate your preparation time?',
        options: [
          '100% on LeetCode',
          '40% DSA practice (LeetCode patterns), 30% building capstone project with production standards, 20% system design study and mock interviews, 10% behavioral story bank preparation',
          '50% building projects, 50% studying frameworks',
          '100% on system design'
        ],
        correctIndex: 1,
        explanation:
            'Balanced preparation wins. Pure LeetCode without projects means you cannot answer "tell me about a system you built." Pure projects without DSA means you fail coding rounds. The 40/30/20/10 split covers all interview dimensions proportional to their weight in most companies.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Final Engineering Mastery Capstone',
      goal:
          'Design, build, test, deploy, and document a complete production-grade application that serves as the centrepiece of your engineering portfolio.',
      steps: [
        'Choose your domain: job tracker, expense manager, collaborative notes, or API analytics dashboard — something you can demo enthusiastically',
        'Build backend with FastAPI: user auth (JWT + refresh), RBAC (2-3 roles), 5+ REST endpoints with pagination/filtering, input validation, structured logging, and /health endpoint',
        'Database: PostgreSQL with proper schema, foreign keys, indexes, and Alembic migrations. Redis for rate limiting and session caching',
        'Testing: pytest suite with fixtures, 40+ tests covering unit, integration, and auth flows — achieve > 80% coverage with pytest-cov',
        'Docker: Dockerfile with slim base, non-root user, layer caching. docker-compose.yml with app + postgres + redis. .dockerignore configured',
        'CI/CD: GitHub Actions pipeline running tests + building Docker image + deploying to Render/Railway/EC2 on every main branch push',
        'Documentation: Professional README with architecture diagram, 5-command quickstart, API documentation (Swagger auto-generated), and 3-minute Loom demo video',
        'Deploy: live accessible URL. Monitor with structured logs, /health endpoint, and 3 defined SLOs',
        'Portfolio: pin on GitHub with status badges (CI: passing, coverage: 87%), clean commit history using Conventional Commits',
        'Interview prep: prepare 30-second summary, 2-minute technical overview, and deep-dive explanations for 5 architectural decisions made in the project',
      ],
      expectedOutput:
          '🏆 Capstone Complete:\n\nProject: JobTrackr — Job application pipeline manager\nLive URL: https://jobtrackr.onrender.com\nGitHub: github.com/yourname/jobtrackr (87% coverage badge)\n\nTech Stack:\n  FastAPI + PostgreSQL + Redis + Docker + GitHub Actions\n\nTest Suite: 47 tests | 87% coverage | CI: passing ✓\n\nAPI endpoints: 12 endpoints with auth, RBAC, pagination ✓\nCI/CD: push to main → tests → Docker build → deploy in 3m 20s ✓\n\nDocumentation:\n  README with architecture diagram ✓\n  Swagger UI at /docs ✓\n  3-minute Loom demo video ✓\n  5 architectural decisions documented ✓\n\nInterview readiness:\n  30-sec pitch: rehearsed ✓\n  2-min technical overview: rehearsed ✓\n  Can answer: "Why FastAPI?", "How does your auth work?",\n  "What would you scale first at 100k users?" ✓\n\nYou are interview-ready. Go get that offer. 🚀',
      xpReward: 100,
    ),
  ),
];
