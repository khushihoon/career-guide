// ══════════════════════════════════════════════════════════════════════
// lib/data/courses/cyber_security_level_2.dart
// Cyber Security Engineer Path — LEVEL 2: Computer Networking &
// Network Security (10 lessons)
// ══════════════════════════════════════════════════════════════════════
import '../../models/course_content_data.dart';

const List<TopicCourse> cyberSecurityLevel2 = [
  // ────────────────────────────────────────────────────────────────────
  // LESSON 1
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l2_net_fundamentals',
    topicTitle: 'Networking Fundamentals & Network Types',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 185,
    emoji: '🌐',
    intro:
        'Almost every attack travels over a network, and every defence you will build sits on one. Before you can secure a network you must know what it is made of and how data moves through it. This lesson builds that map.',
    concepts: [
      ConceptLesson(
        title: 'What is a Computer Network?',
        definition:
            'A computer network is a group of devices connected so they can share data and resources. Devices communicate by sending small chunks of data called packets.',
        analogy:
            'A network is like a postal system. Every house (device) has an address, letters (packets) are sent in envelopes, and sorting offices (routers and switches) decide where each letter goes next.',
        example:
            'What a network lets you do:\n\nShare files and printers in an office\nBrowse websites and stream video\nRun cloud applications\nSend UPI payments and messages\n\nBasic parts:\n  Hosts: laptops, phones, servers\n  Network devices: switches, routers, access points\n  Media: cables, Wi-Fi radio\n  Protocols: shared rules for talking',
        keyTakeaway:
            'Networks move packets between hosts using agreed rules (protocols). Every extra device and connection is also another place an attacker can look for weakness.',
      ),
      ConceptLesson(
        title: 'Network Types by Size: PAN, LAN, MAN, WAN',
        definition:
            'Networks are classified by the area they cover: PAN (personal), LAN (local), MAN (metropolitan), and WAN (wide area). The internet is the largest WAN.',
        analogy:
            'Think of conversation ranges: whispering to a friend (PAN), talking in a room (LAN), a city announcement (MAN), and a national broadcast (WAN).',
        example:
            'Network types:\n\nPAN: Bluetooth earbuds paired to your phone\nLAN: office or home network, one building\nMAN: a city-wide network, such as a metro Wi-Fi project\nWAN: connects far-apart sites, such as branch offices in Delhi and Bengaluru\n\nSecurity view:\n  LAN: threats from inside (infected laptop, rogue device)\n  WAN / internet: threats from anywhere in the world',
        keyTakeaway:
            'The bigger and more open the network, the less you can trust it. Security controls change depending on where traffic travels.',
      ),
      ConceptLesson(
        title: 'Network Topologies and Client-Server Model',
        definition:
            'Topology is the layout of how devices connect (bus, star, ring, mesh). Most networks today use a star layout and follow the client-server model, where clients request services from servers.',
        analogy:
            'A star topology is like a hub-and-spoke airport: every flight goes through the central hub. Convenient, but if the hub fails, everything stops.',
        example:
            'Common topologies:\n\nStar: all devices connect to a central switch (most common)\nMesh: devices have multiple paths (high redundancy, used in the internet backbone)\nBus and ring: mostly historical\n\nClient-server:\n  Client: your browser requests a page\n  Server: the web server responds\n\nPeer-to-peer: devices share directly with each other',
        keyTakeaway:
            'Central points such as switches and servers are efficient but are also single points of failure and attractive targets, so they need extra protection and redundancy.',
      ),
      ConceptLesson(
        title: 'Journey of a Request Across the Internet',
        definition:
            'When you open a website, your device resolves the name to an IP address, sends packets through your router and your ISP, across several networks, to the destination server, and the reply returns the same way.',
        analogy:
            'It is like a courier delivery: look up the address in a directory (DNS), hand the parcel to the local depot (router), pass through sorting hubs (ISPs), and finally reach the destination.',
        example:
            'Simplified flow for opening a website:\n\n1. Browser asks DNS: what is the IP of example.com?\n2. Your device sends a packet to your home router (default gateway)\n3. Router forwards it to your ISP\n4. ISP routers pass it across the internet\n5. The server receives it and replies\n6. The reply travels back to your device\n\nUseful command (on your own machine):\n  traceroute example.com   (Windows: tracert)',
        keyTakeaway:
            'Your data passes through many devices you do not control. This is exactly why encryption in transit (HTTPS, VPN) matters.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which network type typically covers a single office building?',
        options: ['PAN', 'LAN', 'WAN', 'MAN'],
        correctIndex: 1,
        explanation:
            'A Local Area Network (LAN) connects devices within a limited area such as a home, office, or campus.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why can the central switch in a star topology be a security and reliability concern?',
        options: [
          'It makes the cables heavier',
          'It is a single point of failure and an attractive target',
          'It cannot forward packets',
          'It only works with Wi-Fi'
        ],
        correctIndex: 1,
        explanation:
            'All traffic passes through the central device, so if it fails or is compromised, the whole network is affected.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Your data crosses many networks you do not own when visiting a website. What is the best protection for the content in transit?',
        options: [
          'A longer cable',
          'Encryption such as HTTPS or a VPN',
          'Turning off the router',
          'Using a bigger monitor'
        ],
        correctIndex: 1,
        explanation:
            'Encryption keeps data unreadable to anyone along the path, even if they can see the packets.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A company links its Mumbai and Hyderabad offices over leased lines and VPN tunnels. What kind of network is this?',
        options: ['PAN', 'LAN', 'WAN', 'None of these'],
        correctIndex: 2,
        explanation:
            'Connecting geographically separate sites forms a Wide Area Network (WAN).',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'In the client-server model, what is your web browser acting as when it loads a page?',
        options: ['The server', 'The client', 'The router', 'The firewall'],
        correctIndex: 1,
        explanation:
            'The browser is the client making a request. The website host is the server that answers it.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Map Your Home or Lab Network',
      goal:
          'Document every device on a network you own and trace how a request leaves it.',
      steps: [
        'List every device connected to your home network (phones, laptops, TV, smart devices)',
        'Draw a simple diagram: devices -> router -> ISP -> internet',
        'Identify your default gateway IP and your device IP (use ipconfig or ip a on your own machine)',
        'Run traceroute (tracert on Windows) to any website and record the first 5 hops',
        'Classify your network as PAN, LAN, or WAN for each part of the diagram',
        'Note 3 possible weak points (default router password, old devices, open guest access) and one fix for each',
      ],
      expectedOutput:
          'Home Network Map\n\nDevices: 2 phones, 1 laptop, TV, smart speaker\nGateway: 192.168.1.1 | My IP: 192.168.1.23\nTraceroute: 8 hops to example.com\n\nWeak points:\n  Router still has default admin password -> change it\n  Old smart bulb with no updates -> move to guest network\n  WPS enabled -> disable ✓',
      xpReward: 45,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 2
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l2_osi_tcpip',
    topicTitle: 'OSI and TCP/IP Models',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 190,
    emoji: '📚',
    intro:
        'The OSI and TCP/IP models are the shared vocabulary of every network and security professional. When someone says "that is a Layer 7 attack" or "the problem is at Layer 2", this is what they mean.',
    concepts: [
      ConceptLesson(
        title: 'Why Layered Models Exist',
        definition:
            'A layered model splits network communication into separate layers, each with one job. A layer only talks to the layers directly above and below it.',
        analogy:
            'Sending a parcel involves many separate roles: packing, labelling, sorting, transport. Nobody needs to know how the others do their job, which makes the whole system easier to build, fix, and secure.',
        example:
            'Benefits of layering:\n\nTroubleshooting: find which layer is failing\nInteroperability: different vendors follow the same rules\nSecurity: place the right control at the right layer\n\nExample: replacing Wi-Fi with a cable changes the lower layers but does not change how your browser works.',
        keyTakeaway:
            'Layers let you reason about problems and attacks one piece at a time. Always ask: at which layer is this happening?',
      ),
      ConceptLesson(
        title: 'The OSI Model — 7 Layers',
        definition:
            'The OSI model has seven layers: Physical, Data Link, Network, Transport, Session, Presentation, and Application. It is a reference model used for teaching and troubleshooting.',
        analogy:
            'Think of a letter: you write the message (Application), put it in the right format (Presentation), keep a conversation going (Session), choose reliable or fast delivery (Transport), address it (Network), hand it to the local carrier (Data Link), and the vehicle physically carries it (Physical).',
        example:
            '7 Application   — HTTP, DNS, SMTP     PDU: data\n6 Presentation  — TLS, encoding        PDU: data\n5 Session       — session control      PDU: data\n4 Transport     — TCP, UDP, ports      PDU: segment / datagram\n3 Network       — IP, routing          PDU: packet\n2 Data Link     — MAC, switches        PDU: frame\n1 Physical      — cables, radio        PDU: bits\n\nMemory aid (7 to 1): All People Seem To Need Data Processing',
        keyTakeaway:
            'Remember the key pairs: Layer 2 = MAC addresses and switches, Layer 3 = IP addresses and routers, Layer 4 = ports and TCP/UDP.',
      ),
      ConceptLesson(
        title: 'The TCP/IP Model',
        definition:
            'The TCP/IP model is the practical model the internet actually uses. It has four layers: Network Access, Internet, Transport, and Application.',
        analogy:
            'If OSI is the detailed textbook, TCP/IP is the short field manual used by people doing the real job.',
        example:
            'Mapping:\n\nTCP/IP Application   = OSI Application + Presentation + Session\nTCP/IP Transport     = OSI Transport (TCP, UDP)\nTCP/IP Internet      = OSI Network (IP, ICMP)\nTCP/IP Network Access= OSI Data Link + Physical (Ethernet, Wi-Fi)\n\nIn practice people use OSI numbers (Layer 2, Layer 3, Layer 7) even when talking about TCP/IP.',
        keyTakeaway:
            'Learn OSI for the vocabulary and TCP/IP for how things really work. Security teams use both.',
      ),
      ConceptLesson(
        title: 'Encapsulation and Security by Layer',
        definition:
            'Encapsulation means each layer wraps the data from the layer above with its own header before passing it down. The receiver unwraps it in reverse order. Different attacks and controls belong to different layers.',
        analogy:
            'It is like putting a letter in an envelope, then in a courier bag, then in a delivery truck. At the destination each wrapper is removed in reverse.',
        example:
            'Attacks and defences by layer:\n\nLayer 1: cable tapping, jamming -> physical security\nLayer 2: ARP spoofing, MAC flooding -> port security, DHCP snooping\nLayer 3: IP spoofing, ICMP floods -> ACLs, anti-spoofing filters\nLayer 4: SYN flood, port scanning -> firewalls, rate limiting\nLayer 7: SQL injection, phishing, XSS -> WAF, secure coding, email filtering\n\nSending data: Data -> Segment -> Packet -> Frame -> Bits',
        keyTakeaway:
            'Use the layer model as a diagnostic tool: identify the layer, then choose the control that works at that layer.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'At which OSI layer do MAC addresses and switches operate?',
        options: ['Layer 1', 'Layer 2', 'Layer 3', 'Layer 4'],
        correctIndex: 1,
        explanation:
            'The Data Link layer (Layer 2) uses MAC addresses and frames, and switches forward traffic based on them.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A SYN flood primarily targets which layer?',
        options: [
          'Layer 7, Application',
          'Layer 4, Transport',
          'Layer 1, Physical',
          'Layer 6, Presentation'
        ],
        correctIndex: 1,
        explanation:
            'A SYN flood abuses the TCP handshake, which is a Transport layer (Layer 4) mechanism.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the unit of data (PDU) at the Network layer?',
        options: ['Frame', 'Segment', 'Packet', 'Bit'],
        correctIndex: 2,
        explanation:
            'Layer 3 data is called a packet. Layer 4 uses segments (TCP) or datagrams (UDP), Layer 2 uses frames, and Layer 1 uses bits.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Users cannot reach a website, but they can ping its IP address successfully. Which layer is the problem most likely at?',
        options: [
          'Layer 1, the cable is cut',
          'Application level, such as DNS or the web service',
          'Layer 2, the switch is off',
          'Layer 3, IP routing is broken'
        ],
        correctIndex: 1,
        explanation:
            'If ping works, lower layers (physical, link, IP) are fine. The failure is higher up, often name resolution (DNS) or the web application itself.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Which control best matches an ARP spoofing attack on a local network?',
        options: [
          'Web Application Firewall',
          'Dynamic ARP Inspection and port security on switches',
          'Email spam filter',
          'Password manager'
        ],
        correctIndex: 1,
        explanation:
            'ARP spoofing is a Layer 2 attack, so Layer 2 controls on the switch are the right defence.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'OSI Layer Cheat Sheet and Attack Map',
      goal:
          'Build a one-page reference that maps layers, protocols, devices, attacks, and defences.',
      steps: [
        'Create a table with the 7 OSI layers and their PDU names',
        'For each layer add 2 protocols or technologies and the typical network device',
        'Add one common attack and one defence for every layer',
        'Map the OSI layers to the 4 TCP/IP layers',
        'Write 3 troubleshooting stories (for example: ping works but website does not) and name the layer',
        'Explain encapsulation in your own words with a simple diagram for opening a web page',
      ],
      expectedOutput:
          'OSI Cheat Sheet\n\nL7 Application | HTTP, DNS | Data | SQLi, phishing | WAF, secure coding\nL4 Transport | TCP, UDP | Segment | SYN flood | rate limiting, firewall\nL3 Network | IP, ICMP | Packet | IP spoofing | ACLs\nL2 Data Link | Ethernet | Frame | ARP spoofing | DAI, port security\nL1 Physical | cables, Wi-Fi | Bits | tapping | physical security\n\nTroubleshooting: ping OK but site fails -> L7 (DNS) ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 3
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l2_ip_subnet_nat',
    topicTitle: 'IP Addressing, Subnetting & NAT',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 34,
    totalXp: 205,
    emoji: '🔢',
    intro:
        'IP addresses are how devices are found on a network. Subnetting divides a network into smaller, safer parts, and NAT lets many devices share one public address. You will use these ideas daily in firewall rules, scans, and incident investigations.',
    concepts: [
      ConceptLesson(
        title: 'IPv4 Addresses and MAC Addresses',
        definition:
            'An IPv4 address is a 32-bit number written as four decimal parts, such as 192.168.1.10. A MAC address is a hardware identifier used on the local network. IP is logical and can change; MAC is tied to the network card.',
        analogy:
            'A MAC address is like your name, fixed and used locally. An IP address is like your current postal address, which changes when you move to another network.',
        example:
            'Examples:\n\nIPv4: 192.168.1.10 (4 octets, each 0 to 255)\nMAC: 3C:52:82:AB:19:F4\nIPv6: 2001:db8::1 (128-bit, much larger space)\n\nPublic vs private IPs:\n  Private ranges (not routed on the internet):\n    10.0.0.0/8\n    172.16.0.0/12\n    192.168.0.0/16\n  Everything else is generally public\n\nSpecial: 127.0.0.1 = localhost (your own machine)',
        keyTakeaway:
            'Private addresses are used inside networks, public addresses on the internet. Knowing which is which helps you read logs and write correct firewall rules.',
      ),
      ConceptLesson(
        title: 'Subnet Masks and CIDR',
        definition:
            'A subnet mask (or CIDR prefix) splits an IP address into a network part and a host part. CIDR notation such as /24 says how many leading bits identify the network.',
        analogy:
            'In a phone number, the area code identifies the region and the remaining digits identify the person. The subnet mask tells you where the area code ends.',
        example:
            'Common CIDR sizes:\n\n/24 = 255.255.255.0   -> 254 usable hosts\n/25 = 255.255.255.128 -> 126 usable hosts\n/26 = 255.255.255.192 -> 62 usable hosts\n/30 = 255.255.255.252 -> 2 usable hosts (point-to-point links)\n\nFormula: usable hosts = 2^(host bits) - 2\n  (minus network address and broadcast address)\n\nExample: 192.168.1.0/24\n  Network: 192.168.1.0\n  Hosts: 192.168.1.1 to 192.168.1.254\n  Broadcast: 192.168.1.255',
        keyTakeaway:
            'A bigger prefix number means a smaller network. Learn /24, /26, and /30 well, and you can read most real-world network diagrams.',
      ),
      ConceptLesson(
        title: 'Subnetting for Security (Segmentation)',
        definition:
            'Subnetting lets you divide one large network into several smaller ones. Security teams use this to separate groups of devices so a problem in one area does not easily spread to another.',
        analogy:
            'A ship has watertight compartments. A leak in one compartment does not sink the whole ship. Subnets are compartments for your network.',
        example:
            'Example office layout:\n\n10.10.10.0/24  -> Employees\n10.10.20.0/24  -> Servers\n10.10.30.0/26  -> Guest Wi-Fi\n10.10.40.0/27  -> CCTV and IoT devices\n\nSecurity rules between subnets:\n  Guests: internet only, no access to internal subnets\n  IoT: cannot talk to servers\n  Employees: access only required server ports',
        keyTakeaway:
            'Segmentation limits lateral movement. If one device is infected, the attacker should not automatically reach everything else.',
      ),
      ConceptLesson(
        title: 'NAT and Default Gateway',
        definition:
            'Network Address Translation (NAT) lets many private devices share one public IP by rewriting addresses at the router. The default gateway is the router address devices use to reach other networks.',
        analogy:
            'NAT is like a company reception desk: many employees make outside calls through a single company number, and the receptionist keeps track of who called whom.',
        example:
            'How NAT works:\n\nLaptop 192.168.1.23 -> sends request to web server\nRouter replaces source with public IP 203.0.113.5 and records the mapping\nReply returns to the router, which forwards it to 192.168.1.23\n\nTypes:\n  Source NAT / PAT: many private to one public\n  Port forwarding: expose a specific internal service\n\nImportant: NAT is not a firewall. It hides internal addresses but does not replace proper security rules.',
        keyTakeaway:
            'NAT gives some incidental privacy but is not security by itself. Port forwarding deliberately exposes an internal service, so treat it carefully.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which of these is a private IPv4 address?',
        options: ['8.8.8.8', '172.20.5.9', '203.0.113.5', '1.1.1.1'],
        correctIndex: 1,
        explanation:
            '172.16.0.0 to 172.31.255.255 is a private range. 8.8.8.8 and 1.1.1.1 are public DNS servers, and 203.0.113.5 is a public documentation address.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'How many usable host addresses does a /24 network have?',
        options: ['256', '254', '255', '62'],
        correctIndex: 1,
        explanation:
            'A /24 has 8 host bits, giving 256 addresses. Subtract the network and broadcast addresses and 254 are usable.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the main security benefit of subnetting and segmentation?',
        options: [
          'It makes the internet faster',
          'It limits how far an attacker or malware can move inside the network',
          'It removes the need for passwords',
          'It increases the number of IP addresses'
        ],
        correctIndex: 1,
        explanation:
            'Segmentation restricts lateral movement and lets you apply different rules to different groups of devices.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A point-to-point link between two routers needs exactly 2 usable addresses. Which prefix is the most efficient?',
        options: ['/24', '/28', '/30', '/16'],
        correctIndex: 2,
        explanation:
            'A /30 has 2 host bits giving 4 addresses, of which 2 are usable. It wastes the fewest addresses for a two-device link.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A manager says: "We use NAT, so we do not need a firewall." What is the best response?',
        options: [
          'Correct, NAT blocks all attacks',
          'NAT hides internal addresses but does not filter traffic or stop threats, so a firewall is still needed',
          'NAT is the same as encryption',
          'Firewalls only work without NAT'
        ],
        correctIndex: 1,
        explanation:
            'NAT is an addressing function. It does not inspect traffic, enforce policy, or stop malicious connections that are allowed through.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Design a Segmented Network for a Small Company',
      goal:
          'Plan an IP addressing scheme and segmentation rules for a 60-person company.',
      steps: [
        'Scenario: 40 employees, 8 servers, guest Wi-Fi for visitors, 15 CCTV cameras and printers',
        'Choose a private range (for example 10.20.0.0/16) and carve out 4 subnets with correct CIDR sizes',
        'For each subnet list network address, usable range, broadcast address, and number of usable hosts',
        'Write 6 allow or deny rules between subnets (for example: guests cannot reach servers)',
        'Explain where NAT happens and which ports, if any, would be forwarded',
        'List 2 risks that remain even after segmentation',
      ],
      expectedOutput:
          'Addressing Plan\n\nEmployees 10.20.10.0/26  hosts 62  (10.20.10.1 - .62)\nServers   10.20.20.0/28  hosts 14\nGuests    10.20.30.0/26  hosts 62\nIoT       10.20.40.0/27  hosts 30\n\nRules:\n  Guests -> internet only\n  IoT -> deny servers\n  Employees -> servers on 443 and 22 only\n\nNAT at edge router; no port forwarding\nRemaining risks: phishing, compromised employee laptop ✓',
      xpReward: 55,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 4
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l2_core_protocols',
    topicTitle: 'Core Protocols: DNS, DHCP, ARP, HTTP/HTTPS',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 200,
    emoji: '📡',
    intro:
        'Four protocols quietly run almost every network: DHCP gives you an address, ARP finds neighbours, DNS finds websites, and HTTP/HTTPS carries the content. Each one has a classic weakness that attackers have used for decades.',
    concepts: [
      ConceptLesson(
        title: 'DHCP — Getting an Address Automatically',
        definition:
            'DHCP (Dynamic Host Configuration Protocol) automatically assigns an IP address, subnet mask, default gateway, and DNS server to devices when they join a network.',
        analogy:
            'DHCP is like a hotel reception giving you a room number and key card when you arrive, instead of you choosing a room yourself.',
        example:
            'DHCP process (DORA):\n\nDiscover: client asks "is there a DHCP server?"\nOffer: server proposes an address\nRequest: client accepts the offer\nAcknowledge: server confirms the lease\n\nPorts: UDP 67 (server) and 68 (client)\n\nSecurity risks:\n  Rogue DHCP server hands out a malicious gateway or DNS\n  DHCP starvation exhausts the address pool\nDefence: DHCP snooping on switches',
        keyTakeaway:
            'DHCP trusts whoever answers first. A rogue server can redirect victims silently, so enable DHCP snooping on managed switches.',
      ),
      ConceptLesson(
        title: 'ARP — Finding the Local Neighbour',
        definition:
            'ARP (Address Resolution Protocol) maps an IP address to a MAC address on the local network so frames can be delivered. It has no built-in authentication.',
        analogy:
            'You shout in a room, "who has IP 192.168.1.1?" and the owner replies with their MAC. The problem: anyone can shout a false answer, and ARP believes it.',
        example:
            'Normal ARP:\n\nLaptop: who has 192.168.1.1?\nRouter: I do, my MAC is AA:BB:CC:11:22:33\n\nARP spoofing (concept):\n  An attacker on the same LAN sends false replies\n  Victims send traffic to the attacker instead of the router\n  This enables eavesdropping or man-in-the-middle\n\nDefences:\n  Dynamic ARP Inspection (DAI)\n  Port security and static entries for critical devices\n  Encrypted protocols so intercepted data is useless',
        keyTakeaway:
            'ARP spoofing only works on the same local network, which is why public Wi-Fi is risky and why HTTPS or a VPN protects you even there.',
      ),
      ConceptLesson(
        title: 'DNS — The Internet Phonebook',
        definition:
            'DNS (Domain Name System) translates names like example.com into IP addresses. It mostly uses UDP and TCP port 53.',
        analogy:
            'DNS is the contacts list on your phone. You type a name, and the list gives you the number to dial.',
        example:
            'Common DNS record types:\n\nA: name to IPv4 address\nAAAA: name to IPv6 address\nCNAME: alias to another name\nMX: mail servers for a domain\nTXT: text data, used for SPF, DKIM, verification\nNS: authoritative name servers\n\nSecurity risks:\n  DNS spoofing / cache poisoning: fake answers send users to a malicious site\n  DNS tunnelling: hiding data inside DNS queries\n  Domain hijacking and typosquatting\n\nDefences: DNSSEC, trusted resolvers, DNS filtering, monitoring unusual query patterns',
        keyTakeaway:
            'If an attacker controls DNS answers, they control where users end up. DNS logs are also a goldmine for spotting malware talking to its controller.',
      ),
      ConceptLesson(
        title: 'HTTP vs HTTPS',
        definition:
            'HTTP transfers web content in plain text. HTTPS is HTTP wrapped in TLS, which encrypts the traffic and verifies the server identity. HTTP uses port 80, HTTPS uses port 443.',
        analogy:
            'HTTP is a postcard that anyone handling it can read. HTTPS is a sealed, tamper-evident envelope.',
        example:
            'Common HTTP methods:\n\nGET: request data\nPOST: send data (forms, logins)\nPUT / DELETE: update or remove\n\nStatus code groups:\n  2xx success (200 OK)\n  3xx redirect (301, 302)\n  4xx client error (403 Forbidden, 404 Not Found)\n  5xx server error (500)\n\nSecurity features:\n  HSTS forces HTTPS\n  Secure and HttpOnly cookie flags\n  Never send passwords over plain HTTP',
        keyTakeaway:
            'Always use HTTPS. On plain HTTP, anyone on the path can read or change the content, including passwords and session cookies.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which DHCP attack hands victims a malicious gateway or DNS server?',
        options: [
          'DHCP starvation',
          'Rogue DHCP server',
          'Port scanning',
          'SQL injection'
        ],
        correctIndex: 1,
        explanation:
            'A rogue DHCP server responds before the real one and gives clients attacker-controlled settings. DHCP snooping blocks it.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why does ARP spoofing only work on the same local network?',
        options: [
          'ARP packets are not routed beyond the local network segment',
          'ARP uses very long cables',
          'ARP only works at night',
          'ARP needs a VPN'
        ],
        correctIndex: 0,
        explanation:
            'ARP is a Layer 2 protocol limited to the local broadcast domain, so the attacker must be on the same segment.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which port does HTTPS use by default?',
        options: ['80', '22', '443', '53'],
        correctIndex: 2,
        explanation:
            'HTTPS uses TCP 443. HTTP uses 80, SSH uses 22, and DNS uses 53.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'On public Wi-Fi, an attacker poisons ARP entries so your traffic flows through their laptop. You only visit HTTPS sites. What is the likely result?',
        options: [
          'They can read all your passwords in clear text',
          'They can see that traffic exists, but the HTTPS content stays encrypted',
          'Your device is instantly formatted',
          'HTTPS stops working permanently'
        ],
        correctIndex: 1,
        explanation:
            'TLS protects content even if the path is intercepted. Metadata such as destination IP may still be visible, and users must not click through certificate warnings.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You notice a workstation sending thousands of unusually long DNS queries to one strange domain. What might this indicate?',
        options: [
          'Normal browsing',
          'Possible DNS tunnelling or malware communication',
          'A broken keyboard',
          'A printer update'
        ],
        correctIndex: 1,
        explanation:
            'Large volumes of long, random-looking DNS queries to a single domain are a classic sign of data exfiltration or command-and-control over DNS.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Protocol Behaviour Investigation',
      goal:
          'Observe DHCP, DNS, and HTTP behaviour on your own machine and document the security lessons.',
      steps: [
        'Run ipconfig /all (Windows) or ip a and resolvectl status (Linux) and record your IP, gateway, DNS, and DHCP lease details',
        'Use nslookup or dig to query A, MX, and TXT records for a domain you own or a well-known public domain',
        'View your ARP table with arp -a and identify your gateway MAC',
        'Use browser developer tools (Network tab) to compare an HTTP and an HTTPS request, and record the status code and headers',
        'Check which security headers a site sends (for example Strict-Transport-Security)',
        'Write a one-page summary: one weakness and one defence for each of DHCP, ARP, DNS, and HTTP',
      ],
      expectedOutput:
          'Protocol Report\n\nDHCP: lease 192.168.1.23, gateway 192.168.1.1, DNS 192.168.1.1\nDNS: example.com A record 93.184.x.x; MX and TXT recorded\nARP: gateway MAC AA:BB:CC:11:22:33\nHTTP vs HTTPS: HTTPS shows TLS, HSTS header present\n\nWeakness/Defence:\n  DHCP: rogue server / DHCP snooping\n  ARP: spoofing / DAI\n  DNS: poisoning / DNSSEC\n  HTTP: plain text / HTTPS + HSTS ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 5
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l2_tcp_udp_ports',
    topicTitle: 'TCP vs UDP, Ports & Services',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 195,
    emoji: '🚪',
    intro:
        'Ports are the doors of a server, and TCP and UDP decide how traffic moves through them. Open ports are what attackers scan for first and what defenders must account for. This lesson makes ports and services second nature.',
    concepts: [
      ConceptLesson(
        title: 'TCP — Reliable and Connection-Oriented',
        definition:
            'TCP establishes a connection with a three-way handshake, numbers every segment, confirms delivery, and resends lost data. It is used when accuracy matters more than speed.',
        analogy:
            'TCP is registered courier service: you confirm the address first, get a receipt for each parcel, and lost parcels are re-sent.',
        example:
            'Three-way handshake:\n\n1. Client -> Server: SYN   (can we talk?)\n2. Server -> Client: SYN-ACK (yes, can we?)\n3. Client -> Server: ACK   (yes, connected)\n\nTCP used by: HTTP/HTTPS, SSH, FTP, SMTP, databases\n\nSecurity note:\n  SYN flood: attacker sends many SYNs and never completes the handshake, exhausting server resources\n  Defence: SYN cookies, rate limiting, firewalls',
        keyTakeaway:
            'TCP trades speed for reliability. Its handshake is also what port scanners and some DoS attacks abuse.',
      ),
      ConceptLesson(
        title: 'UDP — Fast and Connectionless',
        definition:
            'UDP sends datagrams without a handshake or delivery guarantee. It has low overhead and suits real-time applications that tolerate some loss.',
        analogy:
            'UDP is like shouting an announcement through a megaphone: quick, no confirmation, and if someone misses a word, nobody repeats it.',
        example:
            'UDP used by:\n\nDNS queries\nDHCP\nVoice and video calls\nOnline gaming\nStreaming and VoIP\nNTP (time sync)\nQUIC (basis of HTTP/3)\n\nSecurity notes:\n  Easy to spoof source addresses because there is no handshake\n  Used in amplification DDoS (small request produces a big reply aimed at a victim)\n  Defence: ingress filtering, disable open resolvers, rate limiting',
        keyTakeaway:
            'No handshake means no built-in proof of who is really sending. That makes UDP convenient for attackers who want to spoof traffic.',
      ),
      ConceptLesson(
        title: 'Ports and Common Services',
        definition:
            'A port is a 16-bit number (0 to 65535) that identifies a specific service on a host. Well-known ports run from 0 to 1023. A socket is the combination of IP address and port.',
        analogy:
            'An IP address is the building, and the port is the flat number. The same building can host many services, each at its own door.',
        example:
            'Ports to memorise:\n\n20/21 FTP        22 SSH         23 Telnet (insecure)\n25 SMTP         53 DNS         67/68 DHCP\n80 HTTP         110 POP3       143 IMAP\n443 HTTPS       445 SMB        3306 MySQL\n3389 RDP        5432 PostgreSQL 6379 Redis\n\nRisky when exposed to the internet:\n  Telnet 23, SMB 445, RDP 3389, databases, Redis',
        keyTakeaway:
            'Any port that does not need to be reachable should be closed. Management and database ports should never be open to the whole internet.',
      ),
      ConceptLesson(
        title: 'Port States and Why Attackers Scan',
        definition:
            'A port can be open (service listening), closed (reachable but nothing listening), or filtered (a firewall blocks the probe). Attackers scan to discover what is running, and defenders scan to find exposure first.',
        analogy:
            'Walking through a street and checking which doors are open, which are locked, and which have a guard turning you away. Both burglars and security inspectors do this.',
        example:
            'Port states:\n\nOpen: service responds\nClosed: host replies, nothing is listening\nFiltered: no reply, firewall dropping packets\n\nEthical use (only on systems you own or have written permission to test):\n  Audit your own servers for unintended open ports\n  Verify firewall rules actually work\n\nCheck listening ports on your own machine:\n  netstat -ano   (Windows)\n  ss -tuln       (Linux)',
        keyTakeaway:
            'Scan your own systems before attackers do. Scanning systems you do not own or have no permission to test may be illegal.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which step is missing in the TCP three-way handshake: SYN, ___, ACK?',
        options: ['FIN', 'SYN-ACK', 'RST', 'PUSH'],
        correctIndex: 1,
        explanation:
            'The handshake is SYN, SYN-ACK, ACK. It establishes a reliable connection before data is sent.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which protocol is most suitable for a live video call where speed matters more than perfect delivery?',
        options: ['TCP', 'UDP', 'Telnet', 'FTP'],
        correctIndex: 1,
        explanation:
            'UDP has lower latency and no retransmission delays, which suits real-time media.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which exposed port is most dangerous to leave open to the whole internet?',
        options: [
          '443 on a public website',
          '3389 (RDP) on an internal server',
          '53 on a public DNS server that is meant to serve queries',
          '80 redirecting to 443'
        ],
        correctIndex: 1,
        explanation:
            'Remote Desktop exposed to the internet is a very common entry point for brute force attacks and ransomware. It should sit behind a VPN or gateway.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A server logs thousands of half-open connections (SYN received, handshake never completed) from random sources. What attack is likely?',
        options: ['SQL injection', 'SYN flood', 'Phishing', 'ARP spoofing'],
        correctIndex: 1,
        explanation:
            'Many incomplete handshakes exhaust the server connection table, which is a SYN flood denial-of-service attack.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'On your own server, a port check shows MySQL (3306) reachable from the internet. What should you do?',
        options: [
          'Leave it, databases are meant to be public',
          'Restrict it to the application server or private network and verify with a re-check',
          'Rename the database',
          'Open more ports to hide it'
        ],
        correctIndex: 1,
        explanation:
            'Databases should only be reachable by the systems that need them. Restrict with firewall rules or private networking, then confirm the change.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Port Exposure Audit of Your Own Machine',
      goal:
          'Find which services listen on your own computer and decide which should be closed or restricted.',
      steps: [
        'Run netstat -ano (Windows) or ss -tuln (Linux) on your own computer and record all listening ports',
        'For each port identify the service and whether TCP or UDP is used',
        'Classify each as needed or unnecessary and explain why',
        'Write a firewall rule list that would allow only the needed ports',
        'Optional (own machine only): use Nmap against 127.0.0.1 to compare its output with your netstat results',
        'Write a table of 12 well-known ports with protocol and risk when exposed',
      ],
      expectedOutput:
          'Port Audit\n\nListening: 135 TCP (RPC), 445 TCP (SMB), 5040 TCP, 49664 TCP...\nNeeded: browsing needs outbound only; no inbound required\nUnnecessary: SMB 445 (file sharing off) -> block inbound\n\nFirewall plan: default deny inbound, allow established\n\nPort table: 22 SSH, 80 HTTP, 443 HTTPS, 3389 RDP (high risk), ... ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 6
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l2_devices_segmentation',
    topicTitle: 'Network Devices, Segmentation & VLANs',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 195,
    emoji: '🔌',
    intro:
        'Hubs, switches, routers, and access points each play a different part, and each can be configured securely or carelessly. VLANs and segmentation let you build internal walls so a single infected laptop cannot reach the whole company.',
    concepts: [
      ConceptLesson(
        title: 'Hubs, Switches, and Routers',
        definition:
            'A hub repeats data to every port. A switch learns MAC addresses and sends frames only to the intended port. A router connects different networks and forwards packets using IP addresses.',
        analogy:
            'A hub is someone shouting a message to the entire hall. A switch is a receptionist who directly hands the message to the right person. A router is the post office connecting different cities.',
        example:
            'Comparison:\n\nHub (Layer 1): broadcasts to all, easy to sniff, obsolete\nSwitch (Layer 2): MAC table, targeted delivery\nL3 switch / Router (Layer 3): routes between subnets\nAccess point: connects wireless clients to the wired network\nModem: converts signals for the ISP link\n\nSecurity: unmanaged switches have no security features, managed switches support port security, VLANs, and logging.',
        keyTakeaway:
            'Switches limit what each device can see, which is already safer than hubs. Managed switches add the controls security teams need.',
      ),
      ConceptLesson(
        title: 'Security Controls on Switches and Routers',
        definition:
            'Managed network devices can enforce port security, disable unused ports, filter traffic with ACLs, and log activity. Hardening these devices is as important as hardening servers.',
        analogy:
            'A building with many doors needs locks on every door and a log of who goes through, not just a strong front gate.',
        example:
            'Hardening checklist:\n\nChange default admin passwords immediately\nDisable unused ports\nPort security: limit MAC addresses per port\nDisable insecure management (Telnet, HTTP); use SSH and HTTPS\nKeep firmware updated\nUse ACLs to control traffic between subnets\nSend logs to a central server\nUse 802.1X to authenticate devices before they join the network',
        keyTakeaway:
            'Default credentials and outdated firmware on network devices are among the most common real-world weaknesses.',
      ),
      ConceptLesson(
        title: 'VLANs — Virtual Separation',
        definition:
            'A VLAN (Virtual LAN) divides a single physical switch into several logical networks. Devices in different VLANs cannot talk to each other unless traffic is routed and permitted.',
        analogy:
            'Imagine one office floor divided by glass partitions into separate departments. Same floor, but each department has its own space and rules for crossing.',
        example:
            'Example VLAN design:\n\nVLAN 10: Employees\nVLAN 20: Servers\nVLAN 30: Guests\nVLAN 40: CCTV / IoT\nVLAN 99: Management (admins only)\n\nStandard: IEEE 802.1Q tagging\nTrunk port: carries multiple VLANs between switches\nAccess port: belongs to one VLAN\n\nTraffic between VLANs passes through a router or firewall, where rules are enforced.',
        keyTakeaway:
            'VLANs are the practical way to implement segmentation. Always enforce rules between VLANs, because separation without filtering protects very little.',
      ),
      ConceptLesson(
        title: 'DMZ and Zero Trust Thinking',
        definition:
            'A DMZ (demilitarised zone) is a separate network segment for public-facing servers, isolated from the internal network. Zero trust goes further: never trust any device or user automatically, even inside the network.',
        analogy:
            'A DMZ is the reception lobby of a company: visitors can enter the lobby but need extra checks to go deeper. Zero trust is checking ID at every door inside the building as well.',
        example:
            'Typical layout:\n\nInternet -> Firewall -> DMZ (web server, mail gateway)\n                  -> Firewall -> Internal network (employees, databases)\n\nRules:\n  Internet can reach DMZ on 80/443 only\n  DMZ cannot freely initiate connections to the internal network\n  Internal users can reach the DMZ as needed\n\nZero trust ideas:\n  Verify identity and device health every time\n  Least privilege access\n  Assume breach and monitor everything',
        keyTakeaway:
            'If the public web server is compromised, the DMZ design keeps the attacker away from internal databases. Segmentation turns one breach into a contained incident.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main advantage of a switch over a hub?',
        options: [
          'It sends frames only to the intended port instead of every port',
          'It is cheaper',
          'It works without electricity',
          'It encrypts all traffic'
        ],
        correctIndex: 0,
        explanation:
            'Switches learn MAC addresses and deliver frames to the correct port, which reduces traffic exposure and improves performance.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does a VLAN do?',
        options: [
          'Creates multiple logical networks on one physical switch',
          'Encrypts all Wi-Fi traffic',
          'Replaces antivirus',
          'Increases internet speed'
        ],
        correctIndex: 0,
        explanation:
            'VLANs logically separate groups of devices on shared hardware, forming the basis of segmentation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why are public-facing servers usually placed in a DMZ?',
        options: [
          'So they run faster',
          'So that if they are compromised, the attacker is still separated from the internal network',
          'So that they do not need patches',
          'So that users do not need passwords'
        ],
        correctIndex: 1,
        explanation:
            'A DMZ isolates exposed systems, limiting the blast radius if one is breached.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A company puts guest Wi-Fi in the same flat network as its file server. A visitor laptop is infected. What is the biggest design flaw?',
        options: [
          'Wi-Fi is too fast',
          'No segmentation: guest devices can reach internal servers',
          'The guests used HTTPS',
          'The router has too many ports'
        ],
        correctIndex: 1,
        explanation:
            'Guests should be on an isolated VLAN with internet-only access. A flat network lets problems spread freely.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You just installed a new managed switch. Which action should be done FIRST?',
        options: [
          'Leave the default admin password for easy access',
          'Change default credentials, disable unused ports, and enable secure management (SSH)',
          'Enable Telnet so that everyone can log in',
          'Connect it to the internet directly'
        ],
        correctIndex: 1,
        explanation:
            'Default credentials and insecure management are the most common weaknesses. Harden first, then deploy.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'VLAN and DMZ Design with a Hardening Checklist',
      goal:
          'Design a segmented network with VLANs and a DMZ, and write a device hardening checklist.',
      steps: [
        'Scenario: a 100-person company with a public website, internal ERP, guest Wi-Fi, CCTV, and a management team',
        'Define 6 VLANs with numbers, names, and purpose',
        'Draw (or describe) the layout: Internet, firewall, DMZ, internal network',
        'Write 8 inter-VLAN firewall rules (allow and deny) with reasons',
        'Write a 10-point hardening checklist for switches and routers',
        'Describe 2 ways zero trust ideas would improve this design',
      ],
      expectedOutput:
          'Design Document\n\nVLANs: 10 Employees, 20 Servers, 30 Guests, 40 IoT, 50 DMZ, 99 Management\n\nRules:\n  Guests -> internet only\n  IoT -> no access to servers\n  Internet -> DMZ 443 only\n  DMZ -> internal: deny by default\n  Management VLAN -> SSH to devices only\n\nHardening: change defaults, SSH only, disable unused ports, firmware updates, central logs, 802.1X...\n\nZero trust: device checks, per-app access ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 7
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l2_network_attacks',
    topicTitle: 'Common Network Attacks',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 200,
    emoji: '💥',
    intro:
        'Defenders must understand how network attacks work to detect and stop them. This lesson explains the concepts and warning signs of the most common attacks. It focuses on recognition and defence, not on carrying them out.',
    concepts: [
      ConceptLesson(
        title: 'Reconnaissance and Sniffing',
        definition:
            'Reconnaissance is the information-gathering stage of an attack: discovering hosts, services, and weaknesses. Sniffing means capturing network traffic to read what passes through.',
        analogy:
            'A burglar first studies the street, noting which houses are empty and which windows are open. Sniffing is listening to conversations through the wall.',
        example:
            'Passive vs active recon:\n\nPassive: public information, DNS records, search engines, social media\nActive: port scans and probes that touch the target directly\n\nSniffing:\n  Works easily on unencrypted protocols (HTTP, FTP, Telnet)\n  Much less useful against HTTPS, SSH, and VPN traffic\n\nDefence:\n  Encrypt everything in transit\n  Use switches, not hubs\n  Detect scans with IDS and firewall logs',
        keyTakeaway:
            'Repeated probes from one source are often the first visible sign of an attack. Encryption makes sniffed data worthless.',
      ),
      ConceptLesson(
        title: 'Spoofing and Man-in-the-Middle (MITM)',
        definition:
            'Spoofing is pretending to be another device or user by forging identifiers such as IP, MAC, or DNS answers. In a man-in-the-middle attack, the attacker secretly sits between two parties, reading or altering their communication.',
        analogy:
            'A dishonest courier who opens your letters, reads them, maybe changes them, and seals them again before delivering. Both sender and receiver think the exchange is private.',
        example:
            'Common forms:\n\nARP spoofing: local network redirection\nDNS spoofing: fake name resolution\nEvil twin Wi-Fi: fake hotspot with a familiar name\nSSL stripping: forcing a downgrade from HTTPS to HTTP\n\nSigns:\n  Certificate warnings in the browser\n  Duplicate or changing gateway MAC\n  Unknown Wi-Fi networks with the same name\n\nDefences:\n  HSTS and HTTPS everywhere\n  Never ignore certificate warnings\n  VPN on untrusted networks\n  DAI and port security on switches',
        keyTakeaway:
            'The most important user behaviour: never click through a certificate warning. It is often the only visible sign of a MITM attempt.',
      ),
      ConceptLesson(
        title: 'Denial of Service (DoS) and DDoS',
        definition:
            'A DoS attack tries to make a service unavailable by overwhelming it. A DDoS uses many sources, often a botnet, making it harder to block.',
        analogy:
            'Imagine thousands of people calling a restaurant at once so real customers cannot get through. Nobody stole anything, but the business cannot operate.',
        example:
            'Types:\n\nVolumetric: flood the link with traffic (UDP floods, amplification)\nProtocol: exhaust connection tables (SYN flood)\nApplication layer: heavy requests to expensive pages (HTTP flood)\n\nDefences:\n  CDN and DDoS protection services\n  Rate limiting and connection limits\n  Over-provisioned bandwidth and auto-scaling\n  Blackhole or scrubbing during attacks\n  Incident plan for who to call (ISP, provider)\n\nThis is an Availability attack in the CIA Triad.',
        keyTakeaway:
            'You cannot out-bandwidth every attack alone. Plan with your provider, use DDoS protection, and prepare a response runbook before it happens.',
      ),
      ConceptLesson(
        title: 'Password, Wireless, and DNS-Based Attacks',
        definition:
            'Attackers also target weak authentication on network services, insecure Wi-Fi, and DNS. Brute force and credential stuffing hit exposed logins, rogue access points trick users, and DNS can be abused for redirection or hidden communication.',
        analogy:
            'If the front door is strong but the side door uses a simple padlock, attackers will try the side door. Every network service is a door.',
        example:
            'Examples and defences:\n\nBrute force on SSH or RDP:\n  Defence: MFA, account lockout, key-based SSH, VPN, rate limiting\n\nRogue access point / evil twin:\n  Defence: WPA3 / WPA2-Enterprise, user training, wireless IDS\n\nDNS tunnelling / poisoning:\n  Defence: DNS filtering, DNSSEC, monitoring query patterns\n\nWarning signs in logs:\n  Hundreds of failed logins from one address\n  Unusual outbound connections at night\n  A sudden spike in DNS queries',
        keyTakeaway:
            'Logs tell the story. Failed logins, strange outbound connections, and DNS spikes are among the earliest signs of an attack in progress.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why is sniffing much less useful to an attacker when traffic uses HTTPS?',
        options: [
          'HTTPS hides the network cable',
          'The content is encrypted, so captured packets cannot be read without the key',
          'HTTPS blocks all packets',
          'Sniffing only works on mobile phones'
        ],
        correctIndex: 1,
        explanation:
            'Encryption makes captured data unreadable. Some metadata may still be visible, but passwords and page content are protected.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A browser shows a certificate warning on a website you normally use at a cafe. What is the best action?',
        options: [
          'Click proceed, it is probably nothing',
          'Stop, do not log in, and switch to a trusted network or VPN',
          'Turn off the browser warnings',
          'Type your password faster'
        ],
        correctIndex: 1,
        explanation:
            'A sudden certificate warning on a familiar site can mean someone is intercepting the connection. Do not continue.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which CIA Triad property does a DDoS attack mainly target?',
        options: [
          'Confidentiality',
          'Integrity',
          'Availability',
          'Non-repudiation'
        ],
        correctIndex: 2,
        explanation:
            'DDoS aims to make a service unavailable to legitimate users.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Your server auth log shows 5,000 failed SSH logins in an hour from one IP address. What is the best response?',
        options: [
          'Ignore, failures are harmless',
          'Block or rate-limit the source, enforce key-based login or MFA, and restrict SSH exposure',
          'Disable logging to save space',
          'Share the server password with the team'
        ],
        correctIndex: 1,
        explanation:
            'That is a brute force pattern. Block the source, harden authentication, and avoid exposing SSH publicly if possible.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A hotspot named like your office Wi-Fi appears with no password and a stronger signal. What might it be?',
        options: [
          'A free upgrade from the ISP',
          'An evil twin access point set up to capture traffic and credentials',
          'A faster router firmware',
          'A printer'
        ],
        correctIndex: 1,
        explanation:
            'Look-alike open networks are a classic evil twin technique. Connect only to verified networks.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Network Attack Recognition Playbook',
      goal:
          'Create a defender playbook that links each attack to its warning signs and countermeasures.',
      steps: [
        'List 8 attacks: port scan, sniffing, ARP spoofing, DNS spoofing, evil twin, SYN flood, DDoS, brute force',
        'For each, write the layer it targets and the CIA property affected',
        'Write 2 warning signs you would see in logs or user reports',
        'Write 2 preventive controls and 1 response action',
        'Read about one real DDoS or MITM incident and summarise what happened and what defence worked',
        'Create a one-page "if you suspect an attack" checklist for a non-technical colleague',
      ],
      expectedOutput:
          'Attack Playbook\n\nSYN flood\n  Layer 4 | Availability\n  Signs: many half-open connections, high CPU on server\n  Prevent: SYN cookies, rate limiting\n  Respond: enable provider scrubbing, block sources\n\nARP spoofing\n  Layer 2 | Confidentiality, Integrity\n  Signs: gateway MAC changes\n  Prevent: DAI, port security\n...\n\nCase study summarised ✓\nColleague checklist: disconnect, do not click through warnings, report ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 8
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l2_network_defence',
    topicTitle: 'Network Defence: Firewall Rules, IDS/IPS & DMZ',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 200,
    emoji: '🛡️',
    intro:
        'You know how the network works and how it is attacked. Now you will learn how to defend it: writing firewall rules that actually protect, detecting attacks with IDS and IPS, and monitoring the traffic that crosses your network.',
    concepts: [
      ConceptLesson(
        title: 'Writing Good Firewall Rules',
        definition:
            'A firewall rule specifies source, destination, port, protocol, and an action (allow or deny). Rules are checked in order, and the first match applies. A final default-deny rule catches everything else.',
        analogy:
            'A rule list is like a guard checklist: check names from top to bottom, let in whoever is on the list, and turn away everyone else.',
        example:
            'Example rule table:\n\n1 ALLOW  Any      -> Web server  TCP 443\n2 ALLOW  Office IP -> Web server  TCP 22\n3 ALLOW  App server -> DB server  TCP 5432\n4 DENY   Any      -> DB server   any (log)\n5 DENY   Any      -> Any         any (default deny)\n\nBest practices:\n  Least privilege: smallest source, destination, and port range needed\n  Order matters: specific rules first\n  Log denied traffic\n  Review and remove old rules regularly\n  Document the reason and owner for each rule',
        keyTakeaway:
            'The most dangerous firewall rule is "allow any any". Every rule should have a clear reason, and old unused rules should be removed.',
      ),
      ConceptLesson(
        title: 'Stateless vs Stateful Filtering and ACLs',
        definition:
            'A stateless filter judges each packet alone. A stateful firewall tracks connections, so reply traffic for an allowed outbound request is automatically permitted. ACLs (Access Control Lists) apply similar rules on routers and switches.',
        analogy:
            'A stateless guard checks each person by the list every time. A stateful guard remembers that you left with a visitor and lets that visitor return with you.',
        example:
            'Stateful example:\n\nInternal PC -> web server (allowed outbound)\nThe firewall records this connection\nThe web server reply is allowed back automatically\nAn unsolicited inbound connection from the same server is blocked\n\nACL example (concept):\n  permit tcp 10.10.10.0/24 host 10.10.20.5 eq 443\n  deny   ip  any any log\n\nNGFW adds: application awareness, user identity, TLS inspection, threat feeds',
        keyTakeaway:
            'Stateful inspection is the standard. It allows return traffic only for connections that were legitimately started from inside.',
      ),
      ConceptLesson(
        title: 'IDS and IPS',
        definition:
            'An Intrusion Detection System (IDS) monitors traffic and alerts on suspicious activity. An Intrusion Prevention System (IPS) sits in the traffic path and can block it. Both use signatures and anomaly detection.',
        analogy:
            'An IDS is a CCTV system with an alarm: it tells you something is wrong. An IPS is a CCTV system connected to an automatic gate: it can stop the intruder as well.',
        example:
            'Comparison:\n\nIDS: passive, out of band, alerts only\nIPS: inline, can drop or reset malicious traffic\n\nTypes:\n  NIDS/NIPS: watch network traffic (Snort, Suricata)\n  HIDS: watch one host (file changes, logins)\n\nDetection methods:\n  Signature: known attack patterns\n  Anomaly: deviation from normal baseline\n\nChallenges:\n  False positives: normal traffic flagged\n  False negatives: real attacks missed\n  Tuning is ongoing work',
        keyTakeaway:
            'No detection system is perfect. Good teams tune rules, review alerts, and combine several data sources.',
      ),
      ConceptLesson(
        title: 'Monitoring, Logging, and Honeypots',
        definition:
            'Defence depends on visibility. Firewall, DNS, authentication, and device logs collected centrally let you spot attacks and investigate them afterwards. Honeypots are decoy systems that attract attackers so their behaviour can be studied.',
        analogy:
            'Logs are your security camera footage. A honeypot is a decoy safe that is left unlocked to see who tries to open it.',
        example:
            'What to log and watch:\n\nFirewall: allowed and denied connections\nDNS: unusual domains and volumes\nAuthentication: failed and successful logins\nNetwork flows (NetFlow): who talks to whom and how much\nDevice changes: config changes on routers and switches\n\nCentralise logs in a SIEM so events from many sources can be correlated.\n\nHoneypot value:\n  Any connection to it is suspicious by definition, so alerts are high quality',
        keyTakeaway:
            'You cannot defend what you cannot see. Centralised logging and clear alerting turn raw data into early warnings.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What should be the LAST rule in a well-designed firewall rule list?',
        options: [
          'Allow any any',
          'Deny any any (default deny), ideally with logging',
          'Allow all from the internet',
          'Disable the firewall'
        ],
        correctIndex: 1,
        explanation:
            'A default-deny final rule ensures that anything not explicitly allowed is blocked.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the key difference between an IDS and an IPS?',
        options: [
          'IDS blocks traffic, IPS only alerts',
          'IDS detects and alerts, while IPS sits inline and can also block',
          'They are identical',
          'IDS only works on Wi-Fi'
        ],
        correctIndex: 1,
        explanation:
            'IDS observes and raises alerts. IPS is positioned in the traffic path so it can prevent malicious traffic.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is a stateful firewall preferred over a purely stateless one?',
        options: [
          'It tracks connections so legitimate return traffic is allowed without opening broad inbound rules',
          'It is cheaper',
          'It removes the need for logs',
          'It works without rules'
        ],
        correctIndex: 0,
        explanation:
            'Connection tracking lets the firewall safely permit replies while still blocking unsolicited inbound traffic.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A firewall has this rule at the top: ALLOW any -> any any. Below it are 40 carefully written deny rules. What happens?',
        options: [
          'The deny rules still work',
          'The first match wins, so everything is allowed and the deny rules never apply',
          'The firewall crashes',
          'Only HTTPS is allowed'
        ],
        correctIndex: 1,
        explanation:
            'Rules are evaluated top-down and the first match applies. A broad allow at the top overrides everything below it.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your IDS generates 500 alerts a day, mostly harmless, and analysts start ignoring them. What is the best fix?',
        options: [
          'Turn the IDS off',
          'Tune rules, suppress known-benign patterns, and prioritise high-risk alerts',
          'Hire people to read all 500 alerts manually forever',
          'Delete the logs'
        ],
        correctIndex: 1,
        explanation:
            'Alert fatigue hides real attacks. Tuning and prioritisation keep the signal useful.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Firewall Policy and Detection Plan',
      goal:
          'Write a firewall rule set and a detection and logging plan for a small company network.',
      steps: [
        'Use the segmented design from earlier lessons: Employees, Servers, Guests, IoT, DMZ',
        'Write a 10-rule firewall policy in correct order, ending with default deny and logging',
        'Mark where an IDS or IPS would sit and justify inline vs passive placement',
        'List 8 log sources you would centralise and what you would alert on for each',
        'Describe one honeypot idea and what an alert from it would mean',
        'Review your rule list and mark any rule that is too broad, then tighten it',
      ],
      expectedOutput:
          'Firewall Policy\n\n1 ALLOW Internet -> DMZ web 443\n2 ALLOW Employees -> Servers 443, 22\n3 ALLOW Servers -> DB 5432 only from App\n4 DENY  Guests -> Internal (log)\n5 DENY  IoT -> Servers (log)\n...\n10 DENY Any -> Any (log)\n\nIDS: inline IPS at the internet edge, passive IDS on server VLAN\nLogs: firewall, DNS, auth, VPN, switches, endpoints...\nHoneypot: fake file server in server VLAN; any access = high alert ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 9
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l2_vpn_wireless',
    topicTitle: 'VPNs, Secure Protocols & Wireless Security',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 195,
    emoji: '📶',
    intro:
        'Remote work, public Wi-Fi, and cloud services all mean traffic leaves the safe office network. VPNs, secure protocols, and strong wireless settings keep that traffic private and trustworthy. This lesson covers the choices you will configure and recommend in real jobs.',
    concepts: [
      ConceptLesson(
        title: 'How VPNs Work',
        definition:
            'A Virtual Private Network (VPN) creates an encrypted tunnel between your device and a VPN gateway across an untrusted network such as the internet.',
        analogy:
            'A VPN is like travelling through a sealed, private tunnel instead of an open public road. People outside can see that a vehicle entered the tunnel, but not who is inside or what it carries.',
        example:
            'VPN types:\n\nRemote access VPN: employee laptop to company network\nSite-to-site VPN: connects two office networks\n\nCommon technologies:\n  IPsec: widely used for site-to-site\n  OpenVPN: flexible, TLS-based\n  WireGuard: modern, fast, simple\n  SSL/TLS VPN: browser or client based\n\nWhat a VPN does: encrypts traffic and hides content from the local network\nWhat it does not do: make you anonymous, stop malware, or protect a compromised device',
        keyTakeaway:
            'A VPN protects data in transit between two points. It moves trust to the VPN provider or company gateway, so choose and configure it carefully.',
      ),
      ConceptLesson(
        title: 'Secure vs Insecure Protocols',
        definition:
            'Many older protocols send data, including passwords, in plain text. Modern replacements add encryption and authentication. Replacing insecure protocols is a basic hardening step.',
        analogy:
            'Replacing Telnet with SSH is like replacing a postcard with a sealed letter, using the same address and the same message.',
        example:
            'Replace this    ->  with this\n\nTelnet (23)      ->  SSH (22)\nHTTP (80)        ->  HTTPS (443)\nFTP (21)         ->  SFTP or FTPS\nSMTP / POP3 / IMAP plain -> SMTPS / IMAPS / POP3S (TLS)\nSNMP v1 / v2c    ->  SNMP v3\nWEP / WPA        ->  WPA2 / WPA3\nLDAP plain       ->  LDAPS\n\nAlso: disable old TLS (1.0, 1.1) and weak ciphers; prefer TLS 1.2 and 1.3.',
        keyTakeaway:
            'If a protocol sends credentials in clear text, treat it as a finding to fix. Secure alternatives exist for almost every service.',
      ),
      ConceptLesson(
        title: 'Wireless Security Standards',
        definition:
            'Wi-Fi security has evolved from WEP (broken) through WPA and WPA2 to WPA3. Enterprise networks use 802.1X authentication so each user has their own credentials instead of a shared password.',
        analogy:
            'WEP is a flimsy lock that anyone can pick. WPA3 is a modern deadbolt. WPA2-Enterprise is giving each employee their own personal key card instead of one shared key for the whole office.',
        example:
            'Wi-Fi standards:\n\nWEP: broken, never use\nWPA: obsolete\nWPA2-Personal (AES/CCMP): acceptable with a strong passphrase\nWPA3-Personal: stronger handshake, better protection against offline guessing\nWPA2/WPA3-Enterprise: 802.1X with RADIUS, individual credentials\n\nGood practices:\n  Long random Wi-Fi passphrase\n  Disable WPS\n  Change default router admin credentials\n  Separate guest network\n  Update router firmware',
        keyTakeaway:
            'Use WPA3 where available, otherwise WPA2 with AES and a long passphrase. Disable WPS and keep guests separate.',
      ),
      ConceptLesson(
        title: 'Securing Remote Access and Public Wi-Fi',
        definition:
            'Remote access should be authenticated, encrypted, and limited. On public Wi-Fi, assume the network is hostile and rely on encryption and good habits.',
        analogy:
            'When travelling, you do not leave valuables unattended in a hotel lobby. You keep them with you and locked, whatever the lobby looks like.',
        example:
            'Remote access checklist:\n\nRequire MFA for VPN and remote desktop access\nDo not expose RDP or SSH directly to the internet\nUse least privilege access to internal resources\nKeep VPN clients and gateways patched\nLog and review remote sessions\n\nPublic Wi-Fi habits:\n  Prefer mobile data for sensitive tasks\n  Use a trusted VPN\n  Verify the exact network name with staff\n  Do not ignore certificate warnings\n  Turn off auto-connect to open networks',
        keyTakeaway:
            'Exposed remote access services are a top entry point for attackers. Put them behind a VPN with MFA, and patch them promptly.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which Wi-Fi security standard should never be used because it is easily broken?',
        options: ['WPA3', 'WPA2-AES', 'WEP', 'WPA2-Enterprise'],
        correctIndex: 2,
        explanation:
            'WEP has fundamental design flaws and can be cracked in minutes. Use WPA3 or WPA2 with AES.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which secure protocol should replace Telnet for remote administration?',
        options: ['FTP', 'SSH', 'HTTP', 'SNMP v1'],
        correctIndex: 1,
        explanation:
            'SSH provides encrypted, authenticated remote command-line access, which Telnet lacks.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does a VPN NOT do?',
        options: [
          'Encrypt traffic between your device and the VPN gateway',
          'Protect you from malware already running on your device',
          'Hide the content of traffic from the local Wi-Fi owner',
          'Connect two office networks securely'
        ],
        correctIndex: 1,
        explanation:
            'A VPN protects traffic in transit. It does not clean an infected device or guarantee anonymity.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A company exposes Remote Desktop (3389) directly to the internet for staff working from home. What is the best improvement?',
        options: [
          'Change the port number only',
          'Remove direct exposure, require a VPN with MFA, and restrict access by role',
          'Add a longer welcome banner',
          'Allow everyone in the company the admin role'
        ],
        correctIndex: 1,
        explanation:
            'RDP should not face the internet. A VPN with MFA adds encryption, authentication, and a controllable access point.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A small office has one shared Wi-Fi password used by 50 employees and several ex-employees. Which improvement is strongest?',
        options: [
          'Make the password shorter so it is easier to remember',
          'Move to WPA2/WPA3-Enterprise (802.1X) with individual credentials, and separate guests',
          'Hide the network name only',
          'Turn off Wi-Fi security'
        ],
        correctIndex: 1,
        explanation:
            'Individual credentials mean you can revoke one person without changing everyone password, and they improve accountability.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Secure Remote Work and Wi-Fi Baseline',
      goal:
          'Create a secure configuration baseline for remote access and wireless for a small company.',
      steps: [
        'List all protocols in use at a fictional company: Telnet, FTP, HTTP admin pages, WPA2 shared password, RDP exposed',
        'For each insecure item, write the secure replacement and the reason',
        'Design a remote access plan: VPN type, MFA, who gets access, logging',
        'Write a Wi-Fi baseline: standard, guest network, WPS, admin credentials, firmware updates',
        'Audit your own home router: check the Wi-Fi standard, change the default admin password if needed, disable WPS, and note the firmware version',
        'Write a half-page "travel and public Wi-Fi" guide for employees',
      ],
      expectedOutput:
          'Security Baseline\n\nReplace: Telnet -> SSH, FTP -> SFTP, HTTP admin -> HTTPS, RDP exposed -> VPN + MFA\n\nRemote access: WireGuard or IPsec VPN, MFA required, access by role, logs kept 90 days\n\nWi-Fi: WPA3 / WPA2-Enterprise, guest VLAN, WPS off, firmware current\n\nHome router audit: WPA2-AES, WPS disabled, admin password changed ✓\n\nTravel guide: use mobile data or VPN, heed certificate warnings ✓',
      xpReward: 50,
    ),
  ),

  // ────────────────────────────────────────────────────────────────────
  // LESSON 10
  // ────────────────────────────────────────────────────────────────────
  TopicCourse(
    id: 'cse_l2_traffic_analysis',
    topicTitle: 'Traffic Analysis Basics with Wireshark and Nmap',
    careerId: 'cyber_security_engineer',
    categoryId: 'cyber_security',
    difficulty: 'Medium',
    estimatedMinutes: 36,
    totalXp: 210,
    emoji: '🔍',
    intro:
        'Wireshark lets you see the packets themselves, and Nmap shows you what a network exposes. Together they turn the theory in this level into something you can observe. Use them only on your own devices and lab networks, or where you have written permission.',
    concepts: [
      ConceptLesson(
        title: 'Ethics and Rules for Network Tools',
        definition:
            'Packet capture and scanning tools are legitimate and essential, but using them on networks or systems you do not own or have permission to test can be illegal and harmful.',
        analogy:
            'A doctor uses a stethoscope on patients who consent. The same instrument used secretly on strangers would be a violation. Tools are neutral, but authorisation decides whether use is ethical.',
        example:
            'Safe practice:\n\nCapture only on your own network or a lab you control\nScan only your own devices or targets covered by written permission\nNever capture traffic on public or shared networks you do not manage\nProtect captured files because they may hold sensitive data\nUse safe lab environments: virtual machines, home lab, or intentionally vulnerable practice systems built for learning',
        keyTakeaway:
            'Authorisation comes first, every time. Build a home lab so you can practise freely and legally.',
      ),
      ConceptLesson(
        title: 'Wireshark — Reading Packets',
        definition:
            'Wireshark is a packet analyser that captures network traffic and displays it layer by layer so you can inspect protocols, find problems, and investigate suspicious activity.',
        analogy:
            'Wireshark is a microscope for network traffic. Instead of seeing that "the internet is slow", you see the individual packets and what happened to them.',
        example:
            'Useful display filters:\n\nip.addr == 192.168.1.23     traffic to or from one host\ntcp.port == 443             HTTPS traffic\ndns                          DNS queries and answers\nhttp                         plain HTTP requests\ntcp.flags.syn == 1 && tcp.flags.ack == 0   new connection attempts\narp                          ARP messages\n\nUseful features:\n  Follow TCP Stream: reassemble a conversation\n  Statistics > Conversations: who talks most\n  Colour rules to spot resets and errors',
        keyTakeaway:
            'Learn a handful of filters and the Follow Stream feature. Seeing readable passwords in plain-text HTTP in your own lab is the clearest lesson on why HTTPS matters.',
      ),
      ConceptLesson(
        title: 'Nmap — Discovering Hosts and Services',
        definition:
            'Nmap is a network scanner that discovers live hosts, open ports, and service versions. Defenders use it to audit their own exposure and verify firewall rules.',
        analogy:
            'Nmap is a building inspector walking around your own premises, checking which doors and windows are open and what is behind them, so you can fix problems before a burglar finds them.',
        example:
            'Common scan types (run only against your own lab or authorised targets):\n\nnmap 192.168.56.0/24         discover hosts and common ports\nnmap -sV 192.168.56.10       detect service versions\nnmap -p 1-1024 192.168.56.10 scan a specific port range\nnmap -sn 192.168.56.0/24     host discovery only, no port scan\n\nReading results:\n  open: a service is listening\n  closed: reachable, nothing listening\n  filtered: probably blocked by a firewall\n\nLab idea: scan a VM you control before and after changing its firewall rules and compare.',
        keyTakeaway:
            'Nmap results are only useful if you act on them: close unneeded ports, patch outdated services, and re-scan to confirm.',
      ),
      ConceptLesson(
        title: 'Turning Observations into Findings',
        definition:
            'Security work is not finished when you have captured data. You must interpret it, decide whether it is a risk, and communicate the finding clearly with evidence and a recommendation.',
        analogy:
            'A lab test result is only useful when a doctor interprets it and explains what to do. The same applies to scan and capture results.',
        example:
            'Finding template:\n\nTitle: Telnet service exposed on internal switch\nEvidence: Nmap shows 23/tcp open on 10.10.40.2\nImpact: credentials sent in clear text and can be captured\nSeverity: High\nRecommendation: disable Telnet, enable SSH, restrict management to the management VLAN\nVerification: re-scan to confirm port 23 is closed\n\nGood findings are specific, evidence-based, and actionable.',
        keyTakeaway:
            'Every finding needs evidence, impact, and a fix. This habit separates a useful security engineer from someone who just runs tools.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'When is it acceptable to scan a network with Nmap?',
        options: [
          'Any network that is reachable from the internet',
          'Only your own systems or those where you have explicit written permission',
          'Your neighbour network if you are curious',
          'Any company network if you do not change anything'
        ],
        correctIndex: 1,
        explanation:
            'Authorisation is required. Scanning without permission can be illegal even if you cause no damage.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which Wireshark display filter shows only DNS traffic?',
        options: ['dns', 'ip.dns', 'port.dns', 'show dns only'],
        correctIndex: 0,
        explanation:
            'Typing the protocol name dns in the display filter bar shows only DNS packets.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does a "filtered" port state in an Nmap result usually suggest?',
        options: [
          'The service is open and secure',
          'A firewall or filter is probably blocking the probe',
          'The host does not exist in any form',
          'The port is used for printing'
        ],
        correctIndex: 1,
        explanation:
            'Filtered means no clear response was received, usually because a firewall is dropping or blocking the packets.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'In your own lab, you capture traffic from a test web app that uses plain HTTP and can read the submitted password in Wireshark. What is the correct conclusion?',
        options: [
          'Wireshark is a hacking tool and should be banned',
          'The application must use HTTPS, because plain HTTP exposes credentials to anyone on the path',
          'Passwords do not need protection in labs',
          'HTTP is secure if the password is long'
        ],
        correctIndex: 1,
        explanation:
            'Plain HTTP sends data readable by anyone who can capture it. The fix is to enforce HTTPS and HSTS.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'An authorised scan of your office server shows ports 22, 80, 443, and 3306 open to the internet. Which is the most urgent concern?',
        options: [
          '443, because it is encrypted',
          '3306 (MySQL), which should not be exposed publicly',
          '80, because it exists',
          'None of them'
        ],
        correctIndex: 1,
        explanation:
            'Database ports should be restricted to the application tier. SSH should also be limited, but a public database is the most urgent finding here.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Home Lab: Capture, Scan, Report',
      goal:
          'Use Wireshark and Nmap in a safe lab you control and write a professional finding report.',
      steps: [
        'Set up a safe lab: install VirtualBox or VMware and create one or two virtual machines on a host-only network',
        'Install Wireshark and capture traffic while you browse a test site or visit a lab VM web page; save the capture',
        'Apply filters for dns, http, and tcp.port == 443, and write what each shows',
        'Use Follow TCP Stream on an HTTP request in your lab and note what readable data appears',
        'Run Nmap against your own lab VM, record open ports and service versions, then change the VM firewall and re-scan',
        'Write one finding using the template: title, evidence, impact, severity, recommendation, verification',
      ],
      expectedOutput:
          'Lab Report\n\nLab: 2 VMs on host-only network 192.168.56.0/24\n\nWireshark:\n  dns: queries to lab domain\n  http: login form submitted in clear text\n  tcp.port == 443: encrypted, content unreadable\n\nNmap (before): 22, 80 open | (after firewall change): 22 only\n\nFinding: Login over plain HTTP\n  Evidence: password visible in Follow TCP Stream\n  Impact: credential theft by anyone on the network path\n  Severity: High\n  Fix: enforce HTTPS + HSTS\n  Verification: re-capture shows encrypted traffic ✓',
      xpReward: 60,
    ),
  ),
];
