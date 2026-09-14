// ══════════════════════════════════════════════════════════════════════
// lib/models/software_courses_level3.dart
// Software Engineering Learning Path — LEVEL 3: Data Structures
// ══════════════════════════════════════════════════════════════════════

import '../../models/course_content_data.dart'; 

const List<TopicCourse> softwareCoursesLevel3 = [

  TopicCourse(
    id: 'sep_l3_arrays_advanced',
    topicTitle: 'Arrays Advanced',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 35,
    totalXp: 220,
    emoji: '🧮',
    intro: 'You already know how to create and loop through arrays. Now we go deeper — multi-dimensional arrays, the two-pointer and sliding window techniques, and the memory-level reasons arrays behave the way they do. These patterns alone solve a huge share of coding interview questions at top companies.',
    concepts: [
      ConceptLesson(
        title: 'How Arrays Are Stored in Memory',
        definition: 'An array stores elements in one contiguous block of memory. This is exactly why index-based access is O(1) — the computer calculates any element\'s address instantly using: address = base + (index × element_size).',
        analogy: 'An array is like a row of identical lockers bolted together in a single strip. If you know locker 0\'s position and each locker is the same size, you calculate where locker 50 is without walking past all others.',
        example: 'Array of integers, each 4 bytes, starting at address 1000:\nindex 0 → address 1000\nindex 1 → address 1004\nindex 5 → address 1020  (1000 + 5×4)\n\nThis formula is why array[i] is instant regardless of size.',
        keyTakeaway: 'This contiguous layout also explains WHY inserting in the middle is O(n) — every element after the insertion point must physically shift to maintain the unbroken block.',
      ),
      ConceptLesson(
        title: 'Multi-Dimensional Arrays (Grids/Matrices)',
        definition: 'A 2D array is an array of arrays — used to represent tables, game boards, images, and spatial data. You need TWO indices (row, column) to access any element.',
        analogy: 'A 2D array is exactly like a spreadsheet — you identify any cell by its row AND column number, just like "row 3, column 5" on a grid.',
        example: 'grid = [\n    [1, 2, 3],\n    [4, 5, 6],\n    [7, 8, 9]\n]\nprint(grid[1][2])  # 6 — row 1, column 2\n\nfor row in grid:\n    for val in row:\n        print(val, end=" ")',
        keyTakeaway: 'Iterating a 2D array of size n×m uses nested loops — O(n×m) time. Common in image processing, game boards, and pathfinding grids.',
        codeSnippet: 'rows, cols = 3, 3\ngrid = [[0]*cols for _ in range(rows)]\ngrid[1][1] = "X"\nprint(grid)  # [[0,0,0],[0,"X",0],[0,0,0]]',
      ),
      ConceptLesson(
        title: 'The Two-Pointer Technique',
        definition: 'Two-pointer uses two index variables moving through an array — often from opposite ends — to solve problems in one pass instead of nested loops.',
        analogy: 'Two pointers are like two people searching a hallway from opposite ends, meeting in the middle — far faster than one person walking the entire hallway twice.',
        example: 'def is_palindrome(arr):\n    left, right = 0, len(arr) - 1\n    while left < right:\n        if arr[left] != arr[right]:\n            return False\n        left += 1\n        right -= 1\n    return True',
        keyTakeaway: 'Two pointers turn many O(n²) nested-loop problems into O(n) single-pass solutions. Works especially well on SORTED arrays.',
        codeSnippet: 'def two_sum_sorted(arr, target):\n    left, right = 0, len(arr) - 1\n    while left < right:\n        s = arr[left] + arr[right]\n        if s == target: return [left, right]\n        elif s < target: left += 1\n        else: right -= 1',
      ),
      ConceptLesson(
        title: 'The Sliding Window Technique',
        definition: 'Sliding window maintains a contiguous sub-section of an array, expanding or shrinking as you scan — avoiding redundant recalculation for sub-array problems.',
        analogy: 'A sliding window is like looking through a moving picture frame over a long mural — you slide the frame and only update what is newly visible or hidden, instead of re-examining everything from scratch.',
        example: 'def max_window_sum(arr, k):\n    window_sum = sum(arr[:k])\n    max_sum = window_sum\n    for i in range(k, len(arr)):\n        window_sum += arr[i] - arr[i-k]  # add new, remove old\n        max_sum = max(max_sum, window_sum)\n    return max_sum',
        keyTakeaway: 'Sliding window turns O(n×k) brute force into O(n) by incrementally updating a running result instead of recomputing the entire window every step.',
      ),
      ConceptLesson(
        title: 'In-Place Array Modification',
        definition: 'In-place modification changes an array\'s contents directly without allocating a new array — saving memory, which matters enormously for large datasets.',
        analogy: 'In-place is like rearranging furniture within the same room versus building an entirely new room and moving everything over — same result, far less memory.',
        example: 'def reverse_in_place(arr):\n    left, right = 0, len(arr) - 1\n    while left < right:\n        arr[left], arr[right] = arr[right], arr[left]\n        left += 1\n        right -= 1\n\nnums = [1, 2, 3, 4, 5]\nreverse_in_place(nums)\nprint(nums)  # [5, 4, 3, 2, 1]',
        keyTakeaway: 'Many interview problems ask for "in-place with O(1) extra space" — a strong signal that two pointers or index swapping is the intended approach.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why is accessing array[5] an O(1) operation regardless of array size?',
        options: [
          'Computers are simply fast',
          'Arrays store elements in contiguous memory so any address is calculated directly',
          'Arrays cache the 5th element automatically',
          'It is actually O(n)'
        ],
        correctIndex: 1,
        explanation: 'The address of any index computes instantly as (start_address + index × element_size) — no searching required, regardless of array length.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What problem does the two-pointer technique most efficiently solve?',
        options: [
          'Sorting algorithms only',
          'Pair/comparison problems across an array, reducing O(n²) to O(n)',
          'Only string reversal',
          'It has no performance benefit over loops'
        ],
        correctIndex: 1,
        explanation: 'Moving two pointers strategically allows many comparison-based problems to be solved in a single linear pass instead of nested loops.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the sliding window technique avoid?',
        options: [
          'Using arrays entirely',
          'Recalculating overlapping sub-array results from scratch on every step',
          'Using loops',
          'Using more than one variable'
        ],
        correctIndex: 1,
        explanation: 'Sliding window incrementally updates a running result by adding the new element and removing the old one — no full recomputation per window position.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'grid = [[1,2],[3,4],[5,6]]\nprint(grid[2][0])\n\nWhat is printed?',
        options: ['1', '4', '5', '6'],
        correctIndex: 2,
        explanation: 'grid[2] is the third row [5,6]. grid[2][0] is the first element of that row: 5.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You need to find two numbers in a SORTED array that sum to a target, using O(1) extra space and better than O(n²). What technique fits best?',
        options: [
          'Nested loops checking every pair',
          'Two-pointer from both ends of the sorted array',
          'Sorting the array again',
          'Converting to a dictionary first'
        ],
        correctIndex: 1,
        explanation: 'On a sorted array, two pointers from both ends solve this in O(n) time and O(1) space — moving inward based on whether the sum is too high or too low.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Array Pattern Toolkit',
      goal: 'Implement and test two-pointer, sliding window, and in-place techniques on classic problems plus a 2D grid task.',
      steps: [
        'Implement is_palindrome(arr) using the two-pointer technique',
        'Implement max_subarray_sum_of_size_k(arr, k) using sliding window',
        'Implement reverse_in_place(arr) demonstrating in-place modification with O(1) space',
        'Create a 3x3 grid and write a function returning sum of each row and each column',
        'Test all functions against edge cases: empty arrays, single elements, and k larger than array length',
        'Document time and space complexity of each function in comments',
      ],
      expectedOutput: 'is_palindrome([1,2,3,2,1]): True\nmax_window_sum([2,1,5,1,3,2], 3): 9\nreverse_in_place([1,2,3]): [3,2,1]\nRow sums: [6, 15, 24]  Column sums: [12, 15, 18]',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l3_linked_lists',
    topicTitle: 'Linked Lists',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 35,
    totalXp: 225,
    emoji: '🔗',
    intro: 'Linked lists are where data structures stop being simple and start requiring real understanding of pointer relationships. They underpin browser history, music playlists, and undo systems — and "reverse a linked list" remains one of the most asked interview questions in tech.',
    concepts: [
      ConceptLesson(
        title: 'What is a Linked List?',
        definition: 'A linked list is a sequence of nodes where each node stores data plus a pointer to the next node, rather than sitting in contiguous memory like an array.',
        analogy: 'A linked list is like a treasure hunt with clues scattered across a city — each clue tells you the data AND exactly where the next clue is. You cannot jump to clue #50 directly; you must follow the chain from the start.',
        example: 'class Node:\n    def __init__(self, data):\n        self.data = data\n        self.next = None\n\nhead = Node(5)\nhead.next = Node(10)\nhead.next.next = Node(15)\n# Chain: 5 -> 10 -> 15 -> None',
        keyTakeaway: 'Unlike arrays, linked list nodes can live ANYWHERE in memory — they do not need to be contiguous, because each node carries the address of the next node.',
      ),
      ConceptLesson(
        title: 'Singly vs Doubly Linked Lists',
        definition: 'Singly linked list nodes point only forward (next). Doubly linked list nodes point both forward (next) and backward (prev), enabling traversal in either direction.',
        analogy: 'A singly linked list is a one-way street. A doubly linked list is a two-way street — you can travel forward or backward at will.',
        example: 'class DoublyNode:\n    def __init__(self, data):\n        self.data = data\n        self.next = None\n        self.prev = None\n\n# Doubly linked: A <-> B <-> C\nnode_b.prev = node_a\nnode_b.next = node_c',
        keyTakeaway: 'Doubly linked lists use more memory per node but enable efficient backward traversal — useful for browser back/forward navigation.',
      ),
      ConceptLesson(
        title: 'Insertion & Deletion — O(1) at Head',
        definition: 'Inserting or deleting at the HEAD of a linked list is O(1) — dramatically faster than an array\'s O(n) for the same operation, because no shifting is needed.',
        analogy: 'Inserting at the start is like adding a new first link to a paper chain — you just connect it and point to the old first link. No other link needs to move.',
        example: 'def insert_at_head(head, data):\n    new_node = Node(data)\n    new_node.next = head\n    return new_node\n\nhead = Node(10)\nhead = insert_at_head(head, 5)  # 5 -> 10',
        keyTakeaway: 'O(1) head insertion is the #1 practical advantage over arrays — but it comes at the cost of losing O(1) random access by index.',
        codeSnippet: 'def delete_value(head, target):\n    if head and head.data == target:\n        return head.next\n    current = head\n    while current and current.next:\n        if current.next.data == target:\n            current.next = current.next.next\n            return head\n        current = current.next\n    return head',
      ),
      ConceptLesson(
        title: 'Traversal & the Dummy Node Pattern',
        definition: 'Traversal walks the chain one node at a time using a pointer variable. A dummy node placed before the real head simplifies edge cases when modifying the start of the list.',
        analogy: 'A dummy node is like an extra placeholder page before chapter 1 — it gives you something stable to hold so you never need special-case logic just for "is this the very first page?"',
        example: 'def print_list(head):\n    current = head\n    while current:\n        print(current.data, end=" -> ")\n        current = current.next\n    print("None")\n\n# Dummy node pattern\ndummy = Node(None)\ndummy.next = head\n# ... operate on dummy.next instead of head\nhead = dummy.next',
        keyTakeaway: 'The dummy node pattern is a widely-used professional technique that eliminates a whole class of "what if the head changes?" bugs in linked list code.',
      ),
      ConceptLesson(
        title: 'Reversing a Linked List (Classic Interview Question)',
        definition: 'Reversing a linked list makes every node point to its PREVIOUS node instead of the next — done by carefully tracking three pointers as you traverse once.',
        analogy: 'Reversing is like turning a one-way line of people to face the opposite direction, one person at a time — each person needs to know who was behind them before they turn, or the chain breaks.',
        example: 'def reverse_list(head):\n    prev = None\n    current = head\n    while current:\n        next_node = current.next   # 1. save next\n        current.next = prev        # 2. reverse pointer\n        prev = current              # 3. advance prev\n        current = next_node         # 4. advance current\n    return prev  # new head',
        keyTakeaway: 'This exact pattern is one of the most frequently asked coding interview questions — practice it until the three-pointer dance is automatic.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does each node in a singly linked list store?',
        options: [
          'Only data, with no connection to other nodes',
          'Data plus a pointer to the next node',
          'A fixed memory address shared by all nodes',
          'Only a pointer, with no data'
        ],
        correctIndex: 1,
        explanation: 'Each node bundles its own data with a reference to the next node, maintaining the sequence without needing contiguous memory.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is head insertion O(1) for a linked list but O(n) for an array?',
        options: [
          'Linked lists are always faster',
          'A linked list just updates one pointer; an array must shift every existing element',
          'Arrays cannot support head insertion',
          'No real difference'
        ],
        correctIndex: 1,
        explanation: 'Linked list nodes do not need contiguous memory — adding a new head just points the new node at the old head. Arrays must shift every element to make room, which is O(n).',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'In the reversal algorithm, why must next_node be saved BEFORE setting current.next = prev?',
        options: [
          'Order is irrelevant',
          'Overwriting current.next first permanently loses the reference to the rest of the list',
          'Python requires alphabetical variable order',
          'Only needed for doubly linked lists'
        ],
        correctIndex: 1,
        explanation: 'If you reverse the pointer first, you lose your only reference to the remainder of the list — there is no way to continue traversing forward.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You need fast insertion/removal at the front and never access by index. Which is better?',
        options: ['An array', 'A linked list', 'Neither works', 'A 2D array'],
        correctIndex: 1,
        explanation: 'A linked list provides O(1) head insertion/removal. Without the need for index access, its main disadvantage (no random access) does not apply.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'After reversing 1->2->3->None, what does the list look like?',
        options: ['1->2->3->None', '3->2->1->None', '2->1->3->None', 'None->1->2->3'],
        correctIndex: 1,
        explanation: 'Reversing flips every pointer. The original tail (3) becomes the new head, so the result is 3->2->1->None.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Custom Linked List Library',
      goal: 'Build a singly linked list class supporting core operations including the classic reversal.',
      steps: [
        'Create a Node class and a LinkedList class tracking a head reference',
        'Implement insert_at_head(data) and insert_at_tail(data)',
        'Implement delete_value(target) removing the first matching node',
        'Implement print_list() visualizing as "5 -> 10 -> 15 -> None"',
        'Implement reverse() using the 3-pointer technique in-place',
        'Test full lifecycle: build, insert, delete, reverse, and print at each stage',
      ],
      expectedOutput: 'Initial: 5 -> 10 -> 15 -> None\nAfter delete(10): 5 -> 15 -> None\nAfter insert_at_tail(20): 5 -> 15 -> 20 -> None\nAfter reverse(): 20 -> 15 -> 5 -> None',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l3_stacks',
    topicTitle: 'Stacks',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 185,
    emoji: '📚',
    intro: 'Every time you press Ctrl+Z, every time a function calls another function, every time your browser goes back — a stack is silently at work. Despite being one of the simplest data structures, stacks are foundational to how programming languages actually execute code.',
    concepts: [
      ConceptLesson(
        title: 'LIFO: Last In, First Out',
        definition: 'A stack only allows adding (push) and removing (pop) from one end — the top. The most recently added item is always the first removed.',
        analogy: 'A stack is exactly like a stack of plates in a cafeteria. You always add a new plate on top and always take a plate from the top — you never reach into the middle.',
        example: 'stack = []\nstack.append(1)    # push → [1]\nstack.append(2)    # push → [1, 2]\nstack.append(3)    # push → [1, 2, 3]\nprint(stack.pop())  # 3 — last in, first out\nprint(stack)         # [1, 2]',
        keyTakeaway: 'The defining feature is the LIFO ACCESS RULE — you can only ever touch the top. The implementation (array or linked list) is secondary.',
      ),
      ConceptLesson(
        title: 'Core Stack Operations',
        definition: 'A stack supports 4 essential operations: push (add to top), pop (remove and return top), peek (view top without removing), and is_empty.',
        analogy: 'These match the only allowed actions at a card-draw pile: look at the top card (peek), take the top card (pop), add a card on top (push), or check if the pile is empty.',
        example: 'class Stack:\n    def __init__(self): self.items = []\n    def push(self, item): self.items.append(item)\n    def pop(self): return self.items.pop() if not self.is_empty() else None\n    def peek(self): return self.items[-1] if not self.is_empty() else None\n    def is_empty(self): return len(self.items) == 0',
        keyTakeaway: 'All 4 core operations run in O(1) — this constant-time guarantee is part of what makes stacks so useful.',
      ),
      ConceptLesson(
        title: 'The Call Stack — How Functions Really Work',
        definition: 'Every programming language maintains an internal call stack — each function call pushes a frame, returning pops it. Infinite recursion causes a "stack overflow" by exhausting this stack.',
        analogy: 'The call stack is like a pile of sticky notes tracking "where to return." Calling function B from A adds a note "return to A here." When B finishes, that note is removed.',
        example: 'def a():\n    print("Start A")\n    b()\n    print("End A")\ndef b():\n    print("Start B")\n    print("End B")\na()\n# Call stack: a() pushed -> b() pushed -> b() pops -> a() pops\n# Output: Start A, Start B, End B, End A',
        keyTakeaway: 'A "stack overflow" happens specifically because the call stack fills up with unpopped frames — typically caused by infinite or excessively deep recursion.',
      ),
      ConceptLesson(
        title: 'Real Application: Balanced Parentheses',
        definition: 'A classic stack application: push opening brackets, then pop and match against closing ones. A mismatch or non-empty stack at the end means unbalanced input.',
        analogy: 'Checking brackets with a stack is like a bouncer tracking building entries — every exit must match the most recent entry still waiting, exactly LIFO.',
        example: 'def is_balanced(expr):\n    stack = []\n    pairs = {")": "(", "]": "[", "}": "{"}\n    for c in expr:\n        if c in "([{": stack.append(c)\n        elif c in ")]}":  \n            if not stack or stack.pop() != pairs[c]: return False\n    return len(stack) == 0\n\nprint(is_balanced("{[()]}"))  # True\nprint(is_balanced("{[)}"))    # False',
        keyTakeaway: 'This push-openers / pop-match-closers pattern appears in real compilers verifying that code syntax (matching braces) is valid.',
      ),
      ConceptLesson(
        title: 'Real Application: Undo/Redo Functionality',
        definition: 'Undo/redo is typically implemented with two stacks: one tracking past actions (undo stack) and one tracking undone actions (redo stack).',
        analogy: 'Undo is like a stack of receipts — pressing undo pulls the most recent receipt off the top and reverses exactly that action, setting it aside in case you want to redo.',
        example: 'undo_stack = []\nredo_stack = []\n\ndef perform_action(action):\n    undo_stack.append(action)\n    redo_stack.clear()  # new action clears redo history\n\ndef undo():\n    if undo_stack:\n        action = undo_stack.pop()\n        redo_stack.append(action)',
        keyTakeaway: 'LIFO perfectly matches undo behaviour: the MOST RECENT action is always reversed first, never an older one out of order.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does LIFO mean?',
        options: [
          'Last In, First Out — the most recently added item is removed first',
          'Last In, Final Output — items processed in input order',
          'Linear Input, Function Output',
          'List In, File Out'
        ],
        correctIndex: 0,
        explanation: 'LIFO: the last item pushed is always the first popped — exactly like a stack of plates.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What causes a stack overflow error?',
        options: [
          'Too many variables',
          'The call stack grows too large, typically from infinite or excessively deep recursion',
          'A syntax error',
          'Running out of disk space'
        ],
        correctIndex: 1,
        explanation: 'Each function call pushes a frame. Infinite recursion keeps pushing without popping, eventually exhausting the memory reserved for the call stack.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which operation views the top item WITHOUT removing it?',
        options: ['push', 'pop', 'peek', 'is_empty'],
        correctIndex: 2,
        explanation: 'peek (or top) returns the top value without modifying the stack — unlike pop, which removes and returns it.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'stack = []\nstack.append(1)\nstack.append(2)\nstack.append(3)\nstack.pop()\nstack.append(4)\nprint(stack)',
        options: ['[1, 2, 3, 4]', '[1, 2, 4]', '[4, 2, 1]', '[1, 2, 3]'],
        correctIndex: 1,
        explanation: 'Push 1,2,3 → [1,2,3]. pop() removes 3 → [1,2]. Append 4 → [1,2,4].',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Is "(a + [b * c)]" balanced?',
        options: [
          'Yes, balanced',
          'No — closing order does not match opening order',
          'Cannot be determined',
          'Balance only applies to parentheses'
        ],
        correctIndex: 1,
        explanation: '"(" opens, "[" opens, then ")" closes — but the stack expects "]" first (LIFO). The order is wrong, so it is unbalanced.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Syntax Validator & Undo System',
      goal: 'Build a stack-based bracket validator and a simple undo/redo text editor simulation.',
      steps: [
        'Implement a Stack class with push, pop, peek, and is_empty',
        'Implement is_balanced(expression) validating (), [], {} using your Stack class',
        'Test with at least 4 expressions including nested and broken cases',
        'Build a TextEditor class with undo_stack and redo_stack',
        'Implement type_word(word), undo(), and redo() methods',
        'Demonstrate: type 3 words, undo twice, redo once, print state after each step',
      ],
      expectedOutput: 'is_balanced("{[()()]}"): True\nis_balanced("{[(])}"): False\n\nTyped: "Hello World Today"\nAfter 2 undos: "Hello"\nAfter 1 redo: "Hello World"',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sep_l3_queues',
    topicTitle: 'Queues',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 185,
    emoji: '🎟️',
    intro: 'Queues model one of the most universal real-world experiences: waiting in line. Print jobs, customer support tickets, task scheduling, and breadth-first search all rely on the queue\'s simple fair rule — first come, first served.',
    concepts: [
      ConceptLesson(
        title: 'FIFO: First In, First Out',
        definition: 'A queue adds at the rear and removes from the front — the first item added is always the first removed.',
        analogy: 'A queue is exactly like a line at a coffee shop — the first person in line is served first. New people join at the back, never jumping ahead.',
        example: 'from collections import deque\nqueue = deque()\nqueue.append(1)     # enqueue → [1]\nqueue.append(2)     # enqueue → [1, 2]\nqueue.append(3)     # enqueue → [1, 2, 3]\nprint(queue.popleft())  # 1 — first in, first out\nprint(queue)              # deque([2, 3])',
        keyTakeaway: 'Use collections.deque, not a plain list. list.pop(0) is O(n) because every element shifts. deque.popleft() is O(1).',
      ),
      ConceptLesson(
        title: 'Core Queue Operations',
        definition: 'Enqueue (add to rear), dequeue (remove from front), peek (view front item), is_empty — all O(1) with a deque-backed implementation.',
        analogy: 'These match a ticket counter: new people join the back (enqueue), the front person is served and leaves (dequeue), you see who is next without serving them (peek).',
        example: 'from collections import deque\nclass Queue:\n    def __init__(self): self.items = deque()\n    def enqueue(self, item): self.items.append(item)\n    def dequeue(self): return self.items.popleft() if not self.is_empty() else None\n    def peek(self): return self.items[0] if not self.is_empty() else None\n    def is_empty(self): return len(self.items) == 0',
        keyTakeaway: 'deque is specifically optimised for O(1) operations at both ends — the right tool for any queue implementation.',
      ),
      ConceptLesson(
        title: 'Queue vs Stack: Choosing Correctly',
        definition: 'Use a stack (LIFO) when the MOST RECENT item should be processed first. Use a queue (FIFO) when the OLDEST item should be processed first to preserve arrival order.',
        analogy: 'A stack is "last call wins" voicemail — newest message heard first. A queue is a support callback system — calls returned in the order received.',
        example: 'Use STACK: undo/redo, call tracking, DFS graph traversal\nUse QUEUE: print jobs, customer tickets, BFS graph traversal, task scheduling',
        keyTakeaway: 'Stack for DFS, queue for BFS — this single choice determines traversal order for graphs and is one of the most important algorithm decisions you will make.',
      ),
      ConceptLesson(
        title: 'BFS Using a Queue — Preview',
        definition: 'Breadth-first search explores a graph level by level using a queue to track which nodes to visit next in discovery order.',
        analogy: 'BFS is like exploring a building floor by floor — you fully explore floor 1, add all discovered rooms from floor 2 to your visit queue, and never jump to floor 3 before finishing floor 2.',
        example: 'from collections import deque\ndef bfs(graph, start):\n    visited = {start}\n    queue = deque([start])\n    order = []\n    while queue:\n        node = queue.popleft()\n        order.append(node)\n        for neighbor in graph[node]:\n            if neighbor not in visited:\n                visited.add(neighbor)\n                queue.append(neighbor)\n    return order',
        keyTakeaway: 'The queue\'s FIFO order is exactly what produces the "level by level" exploration pattern in BFS — the algorithm would not work correctly with a stack.',
      ),
      ConceptLesson(
        title: 'Priority Queues (Introduction)',
        definition: 'A priority queue dequeues the HIGHEST priority item first, regardless of insertion order — typically implemented using a heap.',
        analogy: 'A hospital emergency room is a priority queue — a patient with a life-threatening injury is treated before someone who arrived earlier with a minor issue.',
        example: 'import heapq\npq = []\nheapq.heappush(pq, (2, "Routine checkup"))\nheapq.heappush(pq, (0, "Heart attack"))   # priority 0 = most urgent\nheapq.heappush(pq, (1, "Broken arm"))\nprint(heapq.heappop(pq))  # (0, "Heart attack")',
        keyTakeaway: 'Priority queues are implemented using Heaps (covered later this level). This is a conceptual preview — the data structure connection is important to understand.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does FIFO mean?',
        options: [
          'The first item added is the first removed',
          'The last item added is the first removed',
          'Items are removed randomly',
          'Only the largest item is removed'
        ],
        correctIndex: 0,
        explanation: 'FIFO (First In, First Out): items are processed in the exact order they were added — the oldest item in the queue is always removed first.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is collections.deque preferred over a plain list for queues?',
        options: [
          'Lists cannot store multiple items',
          'deque provides O(1) at both ends while list.pop(0) is O(n)',
          'deque is simpler to type',
          'No real performance difference'
        ],
        correctIndex: 1,
        explanation: 'list.pop(0) shifts every remaining element, making it O(n). deque is optimised for O(1) operations at both the front and back.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What determines which item leaves a priority queue first?',
        options: [
          'The order it was added',
          'Its assigned priority value, regardless of when it was added',
          'A random selection',
          'Alphabetical order'
        ],
        correctIndex: 1,
        explanation: 'A priority queue always removes the highest-priority item first, overriding simple arrival-order like a regular queue.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'from collections import deque\nq = deque()\nq.append("A")\nq.append("B")\nq.append("C")\nprint(q.popleft())\nq.append("D")\nprint(list(q))',
        options: ["['A', 'B', 'C', 'D']", "['B', 'C', 'D']", "['D', 'C', 'B']", "['C', 'D']"],
        correctIndex: 1,
        explanation: 'After A,B,C pushed: deque([A,B,C]). popleft() removes A (FIFO) → [B,C]. Append D → [B,C,D].',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Print jobs should be printed in the exact order submitted. Which structure fits?',
        options: ['A stack', 'A queue', 'A set', 'A 2D array'],
        correctIndex: 1,
        explanation: 'A queue\'s FIFO behaviour exactly matches "process in order received" — the first job submitted is the first printed.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Customer Service Ticket Queue',
      goal: 'Build a queue-based ticket system with a priority queue extension for urgent tickets.',
      steps: [
        'Implement a Queue class using deque with enqueue, dequeue, peek, is_empty',
        'Simulate 5 customers submitting support tickets and enqueue each',
        'Process tickets in FIFO order, printing which customer is served at each step',
        'Extend with a PriorityQueue using heapq where urgent tickets (priority 0) are served before normal (priority 1)',
        'Submit a mix of normal and urgent tickets and show urgent ones served first',
        'Print a final summary showing total tickets and the order they were handled',
      ],
      expectedOutput: 'FIFO Queue: Customer1, Customer2, Customer3, Customer4, Customer5\n\nPriority Queue: [URGENT] Customer4, [URGENT] Customer2, Customer1, Customer3, Customer5\nTotal: 5 tickets processed',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'sep_l3_hash_tables',
    topicTitle: 'Hash Tables',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 35,
    totalXp: 230,
    emoji: '🔑',
    intro: 'You have used dictionaries. Now we open the hood — hash functions, collisions, load factor, and resizing. Understanding hash tables at this depth separates "I can use a dictionary" from "I know why it is fast," a distinction senior interviewers actively probe.',
    concepts: [
      ConceptLesson(
        title: 'From Dictionary to Hash Table',
        definition: 'A hash table stores key-value pairs in an array of "buckets", using a hash function to decide which bucket each key belongs in — giving near-instant lookup.',
        analogy: 'A hash table is a filing cabinet where a formula tells you EXACTLY which drawer your file belongs in — no searching, no scanning all drawers.',
        example: 'Conceptually:\nbuckets = [[], [], [], [], []]  # 5 buckets\n\n# Storing "apple": 50\nindex = hash("apple") % 5\nbuckets[index].append(("apple", 50))',
        keyTakeaway: 'The hash table is the IMPLEMENTATION; the dictionary is the INTERFACE. Understanding this separation explains performance characteristics.',
      ),
      ConceptLesson(
        title: 'Hash Functions: Properties',
        definition: 'A good hash function converts a key to an integer, always returning the SAME output for the SAME input, and spreading different keys evenly across buckets.',
        analogy: 'A good hash function is like a fair lottery — same ticket number always lands on the same slot, and across many tickets, slots fill roughly evenly instead of clustering.',
        example: 'def simple_hash(key, num_buckets):\n    total = sum(ord(c) for c in key)\n    return total % num_buckets\n\n# Deterministic: always same output for same input\nprint(simple_hash("cat", 10))  # consistent value\nprint(simple_hash("cat", 10))  # SAME value',
        keyTakeaway: 'A poorly designed hash function that clusters many keys into the same few buckets destroys O(1) performance — quality of the hash function matters enormously.',
      ),
      ConceptLesson(
        title: 'Collisions & Resolution: Chaining',
        definition: 'A collision occurs when two keys hash to the same bucket. Chaining resolves this by storing multiple items per bucket as a list; open addressing finds another empty slot.',
        analogy: 'Chaining is like letting two people assigned the same locker share it, each keeping their own labelled bag inside. Open addressing moves the second person to the next available locker.',
        example: '# With chaining, bucket 3 can hold multiple entries:\nbuckets[3] = [("apple", 50), ("grape", 30)]\n\n# Lookup "grape": go to bucket 3, scan the short list\nfor key, value in buckets[3]:\n    if key == "grape":\n        return value  # 30',
        keyTakeaway: 'Even with collisions, lookup stays close to O(1) as long as buckets stay small — which is why hash tables resize when buckets get crowded.',
      ),
      ConceptLesson(
        title: 'Load Factor & Resizing',
        definition: 'Load factor = items / buckets. When too high, the table resizes (more buckets, re-hash everything) to maintain fast performance.',
        analogy: 'Load factor is how full a parking garage is. At 95% capacity, finding a space is painful — building a bigger garage (resizing) and re-parking everyone restores quick access.',
        example: '10 items in 10 buckets → load factor 1.0 (crowded)\n10 items in 100 buckets → load factor 0.1 (spacious)\n\nMost implementations resize when load factor exceeds ~0.7',
        keyTakeaway: 'Resizing is O(n) but happens rarely, so the AVERAGE insertion cost remains O(1) — this is called "amortized" constant time.',
      ),
      ConceptLesson(
        title: 'When Hash Tables Are NOT the Right Choice',
        definition: 'Hash tables give fast lookup by key but do NOT maintain sorted order. Use sorted structures (balanced trees) when order matters or range queries are needed.',
        analogy: 'A hash table is a fast unordered junk drawer — great for instantly finding one specific item by name, terrible if you need items in sorted order.',
        example: 'Use hash table: "does this exist?", key-based lookup, caching, counting\nUse sorted structure: "items in ascending order", "closest value to X", range queries',
        keyTakeaway: 'Always choose a data structure based on WHICH OPERATIONS matter most — hash tables trade away ordering to gain raw lookup speed.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the relationship between a dictionary and a hash table?',
        options: [
          'They are unrelated',
          'A hash table is the underlying implementation powering a dictionary\'s interface',
          'A dictionary is faster',
          'Hash tables only store numbers'
        ],
        correctIndex: 1,
        explanation: 'A dictionary is the user-facing interface; internally it is implemented as a hash table with buckets, a hash function, and collision handling.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is a hash collision?',
        options: [
          'When a program crashes',
          'When two different keys produce the same bucket index',
          'When a table runs out of memory',
          'When a key is used twice'
        ],
        correctIndex: 1,
        explanation: 'A collision happens when the hash function maps two distinct keys to the same bucket — handled gracefully through chaining or open addressing.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'When is a hash table NOT ideal?',
        options: [
          'When you need fast key-based lookup',
          'When you need to retrieve items in sorted order',
          'When counting occurrences',
          'When checking existence quickly'
        ],
        correctIndex: 1,
        explanation: 'Hash tables sacrifice ordering for speed. If sorted access or range queries are needed, a different structure like a balanced tree is more appropriate.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: '"cat" and "act" both hash to bucket index 3. With chaining, what happens?',
        options: [
          'The second key overwrites the first',
          'Both pairs coexist in bucket 3 as a list; lookup scans within it',
          'The table crashes',
          'Collisions are impossible in a well-designed table'
        ],
        correctIndex: 1,
        explanation: 'Chaining stores multiple entries in the same bucket as a list. Both "cat" and "act" coexist safely, and lookup scans the short list for an exact match.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'A hash table\'s load factor reaches 0.9. What happens if it does NOT resize?',
        options: [
          'Performance improves',
          'Collisions increase, degrading lookup time from O(1)',
          'It becomes a sorted list',
          'Nothing changes'
        ],
        correctIndex: 1,
        explanation: 'High load factor means crowded buckets and more collisions, degrading average lookup time — which is why tables automatically resize to keep load factor low.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Hash Table from Scratch',
      goal: 'Implement a hash table from first principles with a hash function and collision handling via chaining.',
      steps: [
        'Write a simple hash function converting string keys to bucket indices using character codes and modulo',
        'Create a HashTable class with fixed buckets, each initialized as an empty list (for chaining)',
        'Implement put(key, value) appending to the appropriate bucket, handling collisions',
        'Implement get(key) finding the correct bucket and scanning for a matching key',
        'Implement a method to calculate and print the current load factor',
        'Test with at least 8 key-value pairs, including 2 intentional collisions, verifying both retrieve correctly',
      ],
      expectedOutput: 'Stored 8 items across 5 buckets.\nLoad factor: 1.6\nget("apple"): 50 ✓\nget("grape"): 30 ✓ (collided with "apple" in bucket 3, resolved via chaining)',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l3_trees',
    topicTitle: 'Trees',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 35,
    totalXp: 220,
    emoji: '🌳',
    intro: 'File systems, HTML/DOM structure, org charts, decision-making AI — all trees in disguise. Trees introduce hierarchical, branching thinking rather than the linear sequences you have worked with so far.',
    concepts: [
      ConceptLesson(
        title: 'What is a Tree?',
        definition: 'A tree is a hierarchical structure of nodes where each node has a value and references to child nodes, starting from a single root with no parent.',
        analogy: 'A tree mirrors a company org chart — one person at the top (CEO/root), branching down into departments, teams, and individuals, with no cycles back up.',
        example: 'Root: CEO\n├── VP Engineering\n│   ├── Backend Team\n│   └── Frontend Team\n└── VP Sales\n    ├── Domestic\n    └── International',
        keyTakeaway: 'Unlike a linked list (one chain), a tree BRANCHES — each node can have multiple children, creating the hierarchical non-linear structure that defines a tree.',
      ),
      ConceptLesson(
        title: 'Tree Terminology',
        definition: 'Root (top, no parent), parent/child (direct connection), leaf (no children), depth (distance from root), height (longest path from a node to a leaf).',
        analogy: 'An actual tree growing upside down: root is the trunk at top, branches split into smaller branches, and leaves are the very tips with nothing growing further.',
        example: '        A  (root, depth 0)\n       / \\\n      B   C  (depth 1)\n     /\n    D  (depth 2, leaf)\n\nHeight of tree = 2',
        keyTakeaway: 'These terms (root, leaf, depth, height) are used constantly in tree algorithm discussions — getting comfortable with them now makes everything else easier.',
      ),
      ConceptLesson(
        title: 'Tree Node Implementation',
        definition: 'A general tree node stores a value and a LIST of children — unlike a linked list node which has exactly one "next".',
        analogy: 'A tree node is like a manager\'s profile card listing ALL direct reports, however many there are — not just one fixed "next employee".',
        example: 'class TreeNode:\n    def __init__(self, value):\n        self.value = value\n        self.children = []\n\n    def add_child(self, child):\n        self.children.append(child)\n\nroot = TreeNode("CEO")\nvp = TreeNode("VP Engineering")\nroot.add_child(vp)',
        keyTakeaway: 'Binary trees (next course) constrain this to AT MOST 2 children, enabling powerful algorithmic properties.',
      ),
      ConceptLesson(
        title: 'Depth-First Traversal (DFS)',
        definition: 'Depth-first traversal explores as far down one branch as possible before backtracking — naturally implemented with recursion (using the call stack).',
        analogy: 'DFS is exploring a maze by always taking the first available path as deep as possible, only backtracking when you hit a dead end.',
        example: 'def dfs_print(node, depth=0):\n    if node is None: return\n    print("  " * depth + str(node.value))\n    for child in node.children:\n        dfs_print(child, depth + 1)\n\ndfs_print(root)\n# CEO\n#   VP Engineering\n#     Backend Team',
        keyTakeaway: 'DFS uses recursion (the call stack) naturally — directly connecting what you learned about stacks.',
      ),
      ConceptLesson(
        title: 'Breadth-First Traversal (BFS)',
        definition: 'Breadth-first traversal explores level by level — all depth-1 nodes before any depth-2 node — implemented with a queue.',
        analogy: 'BFS is inspecting a building floor by floor — fully checking every room on floor 1 before moving to floor 2.',
        example: 'from collections import deque\n\ndef bfs_print(root):\n    if not root: return\n    queue = deque([root])\n    while queue:\n        node = queue.popleft()\n        print(node.value)\n        for child in node.children:\n            queue.append(child)',
        keyTakeaway: 'DFS pairs with a STACK (or recursion); BFS pairs with a QUEUE. This pairing is one of the most important takeaways from this entire level.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the "root" of a tree?',
        options: [
          'Any node with children',
          'The single top-level node with no parent',
          'A node with no children',
          'The deepest node'
        ],
        correctIndex: 1,
        explanation: 'The root is the single starting node with no parent — every other node is reachable from it by following child connections downward.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is a leaf node?',
        options: [
          'The root',
          'A node with no children',
          'A node with exactly one child',
          'Only the deepest node'
        ],
        correctIndex: 1,
        explanation: 'A leaf is any node with zero children — it sits at the end of a branch with nothing growing further from it.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which data structure does BFS tree traversal naturally rely on?',
        options: ['A stack', 'A queue', 'A hash table', 'A linked list'],
        correctIndex: 1,
        explanation: 'BFS processes nodes level by level. A queue (FIFO) ensures all nodes at the current depth are visited before any nodes at the next depth.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Node X has 2 children, and one child has 0 children. What is that child?',
        options: ['The root', 'A leaf node', 'Must have exactly 1 child', 'Cannot exist in a valid tree'],
        correctIndex: 1,
        explanation: 'Any node with zero children is a leaf by definition, regardless of its position or depth in the tree.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Print a company org chart strictly level by level (all VPs first, then all directors, etc.). Which traversal?',
        options: ['Depth-first with stack', 'Breadth-first with queue', 'Neither works', 'Sort the tree first'],
        correctIndex: 1,
        explanation: 'BFS visits all nodes at one depth before moving to the next — naturally producing level-by-level output, exactly matching this requirement.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'File System Tree Explorer',
      goal: 'Model a simplified file system as a tree and implement both DFS and BFS traversal.',
      steps: [
        'Create a TreeNode class for folders and files, with name and children list',
        'Build a sample file system: root containing 2 sub-folders, each with 2-3 files',
        'Implement dfs_print(node) printing structure with indentation showing depth',
        'Implement bfs_print(root) printing all items level by level',
        'Implement count_files(node) using recursion counting only leaf nodes (files)',
        'Print both traversal outputs and total file count',
      ],
      expectedOutput: 'DFS:\nroot/\n  Documents/\n    resume.pdf\n    notes.txt\n  Photos/\n    vacation.jpg\n\nBFS:\nroot, Documents, Photos, resume.pdf, notes.txt, vacation.jpg\nTotal files: 3',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l3_binary_trees',
    topicTitle: 'Binary Trees',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 35,
    totalXp: 220,
    emoji: '🌲',
    intro: 'Binary trees — where every node has at most 2 children — are the most heavily tested tree variant in interviews. Mastering the three classic traversal orders (pre-order, in-order, post-order) directly unlocks Binary Search Trees and Heaps in the next courses.',
    concepts: [
      ConceptLesson(
        title: 'What Makes a Tree Binary?',
        definition: 'A binary tree restricts every node to AT MOST two children, conventionally called "left" and "right".',
        analogy: 'A binary tree is like a strict decision tree where every question has exactly two possible answers: left or right — never more branches.',
        example: 'class BinaryNode:\n    def __init__(self, value):\n        self.value = value\n        self.left = None\n        self.right = None\n\nroot = BinaryNode(10)\nroot.left = BinaryNode(5)\nroot.right = BinaryNode(15)',
        keyTakeaway: 'The 2-children constraint is what makes binary trees mathematically elegant and enables the powerful traversal patterns and search structures built upon them.',
      ),
      ConceptLesson(
        title: 'In-Order Traversal (Left → Node → Right)',
        definition: 'In-order visits the left subtree, THEN the current node, THEN the right subtree — recursively. For a BST, this produces SORTED output.',
        analogy: 'In-order is like reading a bookshelf left to right: check everything to the left first, read the current book, then everything to the right.',
        example: 'def in_order(node):\n    if node is None: return\n    in_order(node.left)\n    print(node.value, end=" ")\n    in_order(node.right)\n\n#      10\n#     /  \\\n#    5    15\nin_order(root)  # 5 10 15',
        keyTakeaway: 'In-order is the most critical traversal to memorise — for a BST it always produces values in sorted ascending order.',
      ),
      ConceptLesson(
        title: 'Pre-Order & Post-Order Traversal',
        definition: 'Pre-order: current node FIRST, then left, then right. Post-order: left, then right, then current node LAST.',
        analogy: 'Pre-order announces a manager before introducing the team. Post-order introduces every team member before finally announcing the manager.',
        example: 'def pre_order(node):\n    if not node: return\n    print(node.value, end=" ")  # FIRST\n    pre_order(node.left)\n    pre_order(node.right)\n\ndef post_order(node):\n    if not node: return\n    post_order(node.left)\n    post_order(node.right)\n    print(node.value, end=" ")  # LAST',
        keyTakeaway: 'Pre-order is useful for COPYING a tree structure. Post-order is useful for DELETING a tree safely (children before parent).',
      ),
      ConceptLesson(
        title: 'Recursive Tree Algorithms',
        definition: 'Most binary tree algorithms follow: solve for left subtree, solve for right subtree, combine results at current node.',
        analogy: '"How tall is this branch?" — ask each child the same question about their descendants, take the max, add 1 for yourself.',
        example: 'def tree_height(node):\n    if node is None: return -1\n    return max(tree_height(node.left), tree_height(node.right)) + 1\n\ndef count_nodes(node):\n    if node is None: return 0\n    return 1 + count_nodes(node.left) + count_nodes(node.right)',
        keyTakeaway: 'This "solve for children then combine" recursive template is reusable for almost any binary tree problem you will encounter.',
      ),
      ConceptLesson(
        title: 'Balanced vs Unbalanced Trees',
        definition: 'A balanced binary tree keeps left and right subtree heights roughly equal at every node — giving O(log n) height. Unbalanced trees can degrade to O(n) height, behaving like a linked list.',
        analogy: 'A balanced tree is a well-organised hierarchy with equal-depth reporting chains. Unbalanced is one department with 20 levels deep while another has just 1.',
        example: 'Balanced (height ~ log n):    Unbalanced (height = n):\n        10                         10\n       /  \\                          \\\n      5    15                         15\n     / \\   / \\                          \\\n    3   7 12 20                         20',
        keyTakeaway: 'A balanced tree searches in O(log n). Unbalanced degrades to O(n) — effectively a slow linked list in the worst case.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What defines a binary tree?',
        options: [
          'Every node has exactly 2 children',
          'Every node has AT MOST 2 children, called left and right',
          'The tree must have exactly 2 levels',
          'Only numeric values are allowed'
        ],
        correctIndex: 1,
        explanation: 'A binary tree allows each node 0, 1, or 2 children — never more than 2 — distinguishing it from general trees.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What makes in-order traversal special for a BST?',
        options: [
          'It is the fastest traversal',
          'It produces values in sorted ascending order',
          'It only visits leaf nodes',
          'It is identical to pre-order'
        ],
        correctIndex: 1,
        explanation: 'Because a BST maintains left < node < right at every level, visiting left-node-right produces values in sorted order.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What height can an unbalanced BST with n nodes degrade to?',
        options: ['O(1)', 'O(log n)', 'O(n)', 'O(n²)'],
        correctIndex: 2,
        explanation: 'In the worst case (sorted insertions), an unbalanced tree becomes a single chain with height O(n) — behaving like a linked list.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'For tree:\n      10\n     /  \\\n    5    15\nWhat is the in-order output?',
        options: ['10, 5, 15', '5, 10, 15', '15, 10, 5', '10, 15, 5'],
        correctIndex: 1,
        explanation: 'In-order: left (5), current (10), right (15) → 5, 10, 15.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You must delete an entire tree safely, freeing each node only after its children are freed. Which traversal?',
        options: ['Pre-order', 'In-order', 'Post-order', 'Breadth-first'],
        correctIndex: 2,
        explanation: 'Post-order visits children BEFORE the current node — by the time you process a node, both its children are already handled.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Binary Tree Toolkit',
      goal: 'Build a binary tree class with all 3 traversals and recursive analysis functions.',
      steps: [
        'Create BinaryNode class with value, left, and right attributes',
        'Build a sample tree with at least 7 nodes across 3 levels',
        'Implement in_order(), pre_order(), post_order() each returning a list of values',
        'Implement tree_height(node) and count_nodes(node) using the recursive combine pattern',
        'Implement is_balanced(node) checking that height difference between subtrees is at most 1',
        'Print all traversal outputs plus height, node count, and balance status',
      ],
      expectedOutput: 'In-order: [3, 5, 7, 10, 12, 15, 20]\nPre-order: [10, 5, 3, 7, 15, 12, 20]\nPost-order: [3, 7, 5, 12, 20, 15, 10]\nHeight: 2  Nodes: 7  Balanced: True',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l3_bst',
    topicTitle: 'BST',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 35,
    totalXp: 230,
    emoji: '🔍',
    intro: 'A Binary Search Tree combines branching tree power with binary search speed — giving O(log n) search, insert, and delete when balanced. BSTs are the backbone of database indexes and are extremely common in interviews.',
    concepts: [
      ConceptLesson(
        title: 'The BST Property',
        definition: 'At EVERY node: all values in the left subtree are smaller, and all values in the right subtree are larger than that node.',
        analogy: 'A BST is like a perfectly organised filing system where at every single drawer, everything to the left is "before" it and everything to the right is "after" — consistently at every level.',
        example: '        50\n       /  \\\n      30    70\n     /  \\   /  \\\n    20  40 60   80\n\nEvery left child < parent, every right child > parent, at EVERY node.',
        keyTakeaway: 'This single ordering rule enables O(log n) search — exactly like binary search on a sorted array, but with flexible insertion.',
      ),
      ConceptLesson(
        title: 'Searching in a BST',
        definition: 'Start at the root: go left if target is smaller, right if larger, return found if equal. Each comparison eliminates an entire subtree.',
        analogy: 'Searching a BST is like playing "higher or lower" — the friend always tells you exactly which direction to look next, never wasting time on irrelevant branches.',
        example: 'def search(node, target):\n    if node is None: return False\n    if node.value == target: return True\n    elif target < node.value: return search(node.left, target)\n    else: return search(node.right, target)',
        keyTakeaway: 'Each comparison eliminates half the remaining nodes in a balanced BST — delivering O(log n) time, same logarithmic behaviour as binary search on arrays.',
      ),
      ConceptLesson(
        title: 'Inserting into a BST',
        definition: 'Follow the same left/right comparison as search until you reach an empty spot (None) where the new node is attached.',
        analogy: 'Inserting is like a new employee finding their correct seat in an alphabetically organised office — moving left or right until they find their correctly-ordered empty spot.',
        example: 'def insert(node, value):\n    if node is None: return BinaryNode(value)\n    if value < node.value: node.left = insert(node.left, value)\n    elif value > node.value: node.right = insert(node.right, value)\n    return node',
        keyTakeaway: 'Insertion always places the new value in the one position that preserves the BST property — by definition no violation is possible.',
      ),
      ConceptLesson(
        title: 'Deleting from a BST',
        definition: 'Deleting a leaf is simple. One child — replace with that child. Two children — replace with the in-order successor (smallest in right subtree).',
        analogy: 'Deleting a two-child node is like a manager leaving — you promote the most junior person from the right side of the team who logically fits the vacated spot.',
        example: 'def find_min(node):\n    while node.left: node = node.left\n    return node\n\ndef delete(node, value):\n    if not node: return None\n    if value < node.value: node.left = delete(node.left, value)\n    elif value > node.value: node.right = delete(node.right, value)\n    else:\n        if not node.left: return node.right\n        if not node.right: return node.left\n        s = find_min(node.right)\n        node.value = s.value\n        node.right = delete(node.right, s.value)\n    return node',
        keyTakeaway: 'The two-children deletion case using the in-order successor is the most commonly tested BST interview question — practice it specifically.',
      ),
      ConceptLesson(
        title: 'BST Degradation & Self-Balancing Trees',
        definition: 'Inserting already-sorted values into a naive BST creates a straight chain — O(n) height, no speed advantage. Self-balancing trees (AVL, Red-Black) automatically restructure to guarantee O(log n).',
        analogy: 'Inserting sorted data is like seating employees always "you are the most senior so far" — one long single-file line instead of a branching structure.',
        example: 'Inserting 1,2,3,4,5 into a naive BST:\n1\n \\\n  2\n   \\\n    3  ... (O(n) chain)\n\nAVL/Red-Black trees rotate nodes automatically to prevent this.',
        keyTakeaway: 'Self-balancing BST variants power real database indexes and language standard libraries, guaranteeing O(log n) even in worst-case insertion order.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the core BST property?',
        options: [
          'Every node has exactly 2 children',
          'At every node, left subtree values are smaller and right subtree values are larger',
          'All values must be unique integers',
          'The tree must always be perfectly balanced'
        ],
        correctIndex: 1,
        explanation: 'The BST property — left smaller, right larger, maintained at EVERY node — enables fast binary-search-like lookups throughout the entire tree.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What happens if values are inserted in sorted order into a naive BST?',
        options: [
          'Stays O(log n)',
          'Can degrade to O(n), behaving like a linked list',
          'Becomes O(1)',
          'BST refuses sorted insertions'
        ],
        correctIndex: 1,
        explanation: 'Inserting strictly sorted values creates a single chain with no branching — height becomes O(n), eliminating the logarithmic advantage.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'When deleting a BST node with TWO children, what replaces it?',
        options: [
          'The node is simply removed',
          'Its in-order successor (smallest in its right subtree)',
          'A random child node',
          'The root of the tree'
        ],
        correctIndex: 1,
        explanation: 'The in-order successor is the smallest value greater than the deleted node — placing it in that spot preserves the BST property correctly.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Search for 35 in:\n        50\n       /  \\\n      30    70\n     /  \\\n    20    40\nWhich path does the algorithm take?',
        options: [
          '50 -> 70',
          '50 -> 30 -> 40 (then would go left of 40)',
          '50 -> 30 -> 20',
          'Checks every node'
        ],
        correctIndex: 1,
        explanation: '35 < 50 → go left to 30. 35 > 30 → go right to 40. 35 < 40 → would go left of 40 (None). Not found. Visited only 50, 30, 40.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Why do databases use self-balancing BSTs instead of naive BSTs?',
        options: [
          'Less memory',
          'Guarantee O(log n) height even in worst-case insertion patterns',
          'Simpler to implement',
          'Naive BSTs cannot store more than 100 items'
        ],
        correctIndex: 1,
        explanation: 'Self-balancing trees automatically restructure to maintain O(log n) height — protecting against the worst-case degradation risk of a naive BST.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'BST Implementation',
      goal: 'Build a complete BST with insert, search, delete, and in-order traversal for sorted output.',
      steps: [
        'Create a BST class wrapping a root BinaryNode reference',
        'Implement insert(value) maintaining the BST property',
        'Implement search(value) returning True/False',
        'Implement delete(value) handling all 3 cases: leaf, one child, two children (in-order successor)',
        'Implement in_order_traversal() returning sorted values, proving BST property holds',
        'Test: insert 8 values, search existing and non-existing, delete a two-child node, print sorted output',
      ],
      expectedOutput: 'Inserted: [50,30,70,20,40,60,80]\nSearch(40): True\nSearch(45): False\nDeleted 30 (replaced with in-order successor 40)\nSorted: [20, 40, 50, 60, 70, 80]',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'sep_l3_heaps',
    topicTitle: 'Heaps',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 35,
    totalXp: 230,
    emoji: '⛰️',
    intro: 'Heaps power priority queues, scheduling algorithms, and heap sort — and they answer one question better than any other structure: "what is the minimum or maximum element right now, instantly?" Understanding heaps makes several advanced algorithms in the next level click immediately.',
    concepts: [
      ConceptLesson(
        title: 'What is a Heap?',
        definition: 'A heap is a specialised binary tree maintaining the heap property: in a MIN-heap every parent is smaller than its children; in a MAX-heap every parent is larger.',
        analogy: 'A min-heap is an org chart where every manager is guaranteed to have a LOWER salary number than their direct reports — not fully sorted, but the smallest is always at the very top.',
        example: 'Min-Heap:\n        5\n       / \\\n      10   8\n     / \\\n    20  15\n\n5 < 10 and 5 < 8 (parent smaller than children).\n10 and 8 are NOT directly compared — only parent-child matters.',
        keyTakeaway: 'A heap is NOT fully sorted like a BST — it only guarantees minimum/maximum at the root, which is exactly what priority queues need.',
      ),
      ConceptLesson(
        title: 'Heaps Are Stored as Arrays',
        definition: 'Heaps are implemented as arrays where parent at index i has children at 2i+1 and 2i+2 — no pointers needed, just index arithmetic.',
        analogy: 'Storing a heap as an array is like numbering pyramid seats predictably — you calculate which seats are "below" any given seat using arithmetic, no directional signs needed.',
        example: 'heap = [5, 10, 8, 20, 15]\n# Index: 0   1  2   3   4\n\n# Children of index 1 (value 10): indices 3 (20) and 4 (15)\n# Parent of index 3: (3-1)//2 = 1',
        keyTakeaway: 'This array-based representation is far more memory-efficient than node-and-pointer trees — no left/right pointers needed at all.',
      ),
      ConceptLesson(
        title: 'Insertion: Bubble Up',
        definition: 'Insert at the end of the array, then swap upward with parent while the heap property is violated.',
        analogy: 'Bubbling up is a new, very low-valued employee joining at the bottom and being promoted upward, swapping with each manager above them until landing where they belong.',
        example: 'def bubble_up(heap, i):\n    parent = (i - 1) // 2\n    while i > 0 and heap[i] < heap[parent]:\n        heap[i], heap[parent] = heap[parent], heap[i]\n        i = parent\n        parent = (i - 1) // 2',
        keyTakeaway: 'Heap height is O(log n), so bubbling up takes at most O(log n) swaps — giving heap insertion its O(log n) time complexity.',
      ),
      ConceptLesson(
        title: 'Extraction: Bubble Down',
        definition: 'Remove the root (minimum), replace it with the last element, then swap downward with the smaller child while the heap property is violated.',
        analogy: 'Bubbling down is temporarily promoting the most junior employee into the top spot, then immediately demoting them step by step until they land at an appropriate level.',
        example: 'def extract_min(heap):\n    min_val = heap[0]\n    heap[0] = heap[-1]\n    heap.pop()\n    # bubble_down(heap, 0) — compare with children, swap with smaller\n    return min_val',
        keyTakeaway: 'Like insertion, extraction is O(log n) — this, combined with O(1) access to minimum/maximum, is why heaps are the standard priority queue implementation.',
      ),
      ConceptLesson(
        title: 'Python heapq & Real Applications',
        definition: 'Python\'s heapq module provides a production-ready min-heap. Heaps also power Heap Sort — O(n log n) sorting by repeatedly extracting the minimum.',
        analogy: 'Using heapq is like having a professionally built priority triage board — you never need to build one from scratch in production code.',
        example: 'import heapq\n\ntasks = []\nheapq.heappush(tasks, (3, "Write report"))\nheapq.heappush(tasks, (1, "Fix critical bug"))\nheapq.heappush(tasks, (2, "Review code"))\n\nwhile tasks:\n    priority, task = heapq.heappop(tasks)\n    print(f"Doing: {task}")  # Always most urgent first',
        keyTakeaway: 'In production code, use heapq. In interviews, understand bubble_up and bubble_down conceptually — both may be tested.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does a min-heap guarantee?',
        options: [
          'All elements are fully sorted',
          'Every parent is smaller than its children, so the minimum is always at the root',
          'Every node has exactly 2 children',
          'Elements stored alphabetically'
        ],
        correctIndex: 1,
        explanation: 'A min-heap guarantees parent ≤ children at every level — this ensures the minimum value is always instantly accessible at index 0.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'How are heaps typically stored in memory?',
        options: [
          'Doubly linked list',
          'Array, using index arithmetic for parent/child relationships',
          'Hash table',
          'They cannot be stored'
        ],
        correctIndex: 1,
        explanation: 'Heaps are stored as arrays where index relationships (parent at (i-1)//2, children at 2i+1 and 2i+2) replace explicit pointers.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the time complexity of heap insertion and extraction?',
        options: ['O(1)', 'O(log n)', 'O(n)', 'O(n²)'],
        correctIndex: 1,
        explanation: 'Both bubble_up and bubble_down traverse at most the heap\'s height, which is O(log n) — giving O(log n) for both operations.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'In min-heap [3, 8, 5, 20, 15, 10], what is guaranteed to be the minimum?',
        options: ['20', '8', '3', '10'],
        correctIndex: 2,
        explanation: 'In a min-heap the minimum is ALWAYS at index 0 (the root) — this is the core guarantee that makes heaps valuable.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'A job scheduler must always process the most urgent job next, regardless of arrival order. Best data structure?',
        options: ['Sorted array, re-sorted each time', 'Heap (priority queue)', 'Stack', 'Plain list'],
        correctIndex: 1,
        explanation: 'A heap-based priority queue gives O(log n) insertion and O(log n) extraction of the most urgent item without re-sorting everything each time.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Task Scheduler Using a Min-Heap',
      goal: 'Build a priority-based task scheduling system demonstrating both heapq and manual bubble_up.',
      steps: [
        'Use Python\'s heapq to create a min-heap of (priority, task_name) tuples',
        'Add at least 6 tasks with varying priority levels (lower number = more urgent)',
        'Process all tasks by repeatedly extracting the minimum, printing each in order handled',
        'Implement a custom bubble_up(heap, index) from scratch demonstrating the mechanism',
        'Implement parent/children index calculation functions for an array-based heap',
        'Compare custom output against heapq to verify correctness',
      ],
      expectedOutput: 'Processing order: Fix critical bug (P1), Review code (P2), Write report (P3)...\nCustom bubble_up matches heapq: True',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'sep_l3_graphs',
    topicTitle: 'Graphs',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 40,
    totalXp: 240,
    emoji: '🕸️',
    intro: 'Social networks, GPS navigation, the internet itself, recommendation engines — all graphs. Graphs are the most general data structure you will learn, generalising trees by allowing cycles and arbitrary connections between any nodes.',
    concepts: [
      ConceptLesson(
        title: 'What is a Graph?',
        definition: 'A graph is a set of nodes (vertices) connected by edges — which can be directed (one-way) or undirected (two-way), and weighted (with a cost) or unweighted.',
        analogy: 'A graph is like a flight route map — cities are nodes, available flights are edges. Some routes are one-way (directed) with different costs (weighted).',
        example: 'Undirected unweighted: Facebook friendships\nDirected unweighted: Instagram follows\nDirected weighted: Flight routes with distances\nUndirected weighted: Road network with distances',
        keyTakeaway: 'A tree is just a special restricted graph — one with no cycles and exactly one path between any two nodes. Graphs allow far more flexible structures.',
      ),
      ConceptLesson(
        title: 'Adjacency List vs Adjacency Matrix',
        definition: 'Adjacency list: each node stores a list of its connected neighbors. Adjacency matrix: 2D grid where [i][j] indicates edge existence.',
        analogy: 'Adjacency list: each person keeps their own contact list. Adjacency matrix: a massive spreadsheet with every possible pair having a "yes/no" cell.',
        example: '# Adjacency List\ngraph = {\n    "A": ["B", "C"],\n    "B": ["A", "D"],\n    "C": ["A"],\n    "D": ["B"]\n}\n\n# Matrix: row i, col j = 1 if edge exists between i and j',
        keyTakeaway: 'Adjacency lists are preferred for sparse graphs (few connections relative to total possible). Matrices waste memory with mostly-empty cells for sparse graphs.',
      ),
      ConceptLesson(
        title: 'DFS on Graphs (With Cycle Protection)',
        definition: 'Graph DFS explores as far as possible down each branch before backtracking — but unlike trees, graphs can have cycles, so you MUST track visited nodes.',
        analogy: 'DFS on a graph with cycles is like exploring a maze with loops — without marking where you have been, you could walk in circles forever.',
        example: 'def dfs(graph, node, visited=None):\n    if visited is None: visited = set()\n    visited.add(node)\n    print(node, end=" ")\n    for neighbor in graph[node]:\n        if neighbor not in visited:\n            dfs(graph, neighbor, visited)',
        keyTakeaway: 'The "visited" set is NON-NEGOTIABLE for graph traversal — forgetting it causes infinite loops when cycles exist.',
      ),
      ConceptLesson(
        title: 'BFS on Graphs — Shortest Path',
        definition: 'BFS explores neighbors level by level using a queue, and finds the SHORTEST PATH in an unweighted graph because it reaches any node via the minimum number of edges.',
        analogy: 'BFS finding shortest path is like ripples in water — the ripple reaches every node at distance 1 before distance 2, guaranteeing the FIRST time you reach a target is via the shortest route.',
        example: 'from collections import deque\n\ndef bfs_path(graph, start, target):\n    visited = {start}\n    queue = deque([(start, [start])])\n    while queue:\n        node, path = queue.popleft()\n        if node == target: return path\n        for nb in graph[node]:\n            if nb not in visited:\n                visited.add(nb)\n                queue.append((nb, path + [nb]))\n    return None',
        keyTakeaway: 'BFS guarantees shortest path ONLY for unweighted graphs. Weighted shortest paths need Dijkstra\'s algorithm (covered in Level 4).',
      ),
      ConceptLesson(
        title: 'Cycle Detection',
        definition: 'Cycle detection identifies whether following edges can lead back to a previously visited node in the current traversal path — critical for deadlock detection and dependency validation.',
        analogy: 'Cycle detection is like checking task dependencies for contradictions — if A depends on B, B depends on C, and C depends on A, nothing can ever start. That\'s a cycle.',
        example: 'def has_cycle(graph, node, visited, path_set):\n    visited.add(node)\n    path_set.add(node)\n    for nb in graph[node]:\n        if nb not in visited:\n            if has_cycle(graph, nb, visited, path_set): return True\n        elif nb in path_set:\n            return True\n    path_set.remove(node)\n    return False',
        keyTakeaway: 'This technique underlies real systems: circular dependency detection in npm/pip, and deadlock detection in operating systems.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the key difference between a tree and a general graph?',
        options: [
          'Trees can have cycles; graphs cannot',
          'Graphs can have cycles and multiple paths; trees cannot',
          'Trees always have more nodes',
          'No real difference'
        ],
        correctIndex: 1,
        explanation: 'A tree is a restricted acyclic graph. General graphs allow cycles and multiple paths between nodes, which trees explicitly forbid.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is tracking "visited" nodes essential in graph traversal?',
        options: [
          'Optional — just a performance optimisation',
          'Without it, cycles cause infinite loops',
          'Only needed for weighted graphs',
          'It slows traversal on purpose'
        ],
        correctIndex: 1,
        explanation: 'Unlike trees, graphs can contain cycles. Without tracking visited nodes, a traversal can revisit the same nodes indefinitely.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which traversal guarantees shortest path in an UNWEIGHTED graph?',
        options: ['DFS', 'BFS', 'Neither', 'In-order traversal'],
        correctIndex: 1,
        explanation: 'BFS explores level by level — the first time it reaches any target, it has done so via the minimum number of edges.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A social network has 10M users, each with ~200 friends. Which representation is more memory-efficient?',
        options: [
          'Adjacency matrix (10M × 10M = 100 trillion cells)',
          'Adjacency list (storing only actual connections)',
          'Identical memory usage',
          'Neither handles this scale'
        ],
        correctIndex: 1,
        explanation: 'This sparse graph has ~200 connections per user out of 10M possible. An adjacency list stores only those ~200 connections; a matrix would require 100 trillion cells, mostly empty.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'A build system: A depends on B, B depends on C, C depends on A. What does cycle detection reveal?',
        options: [
          'Normal — build A first',
          'A cycle exists — these dependencies can never be resolved; flag as error',
          'Build in random order',
          'Cycle detection is irrelevant here'
        ],
        correctIndex: 1,
        explanation: 'A→B→C→A is a cycle — no valid build order exists to satisfy all dependencies simultaneously. Real build tools and package managers detect and report exactly this.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Social Network Path Finder',
      goal: 'Model a social network as a graph with BFS shortest-path finding and cycle detection.',
      steps: [
        'Represent a social network of 8+ people as an adjacency list (dictionary of lists)',
        'Implement dfs(graph, start) returning full traversal order, handling cycles with visited set',
        'Implement bfs_shortest_path(graph, start, target) returning the shortest connection path',
        'Test shortest path on at least 2 different start/target pairs',
        'Implement has_cycle(graph) detecting if any cycle exists',
        'Print degrees of separation between several pairs, like a real social network feature',
      ],
      expectedOutput: 'DFS from Alice: [Alice, Bob, Carol, Dave, Eve, Frank]\nAlice -> Frank: [Alice, Bob, Eve, Frank] (3 degrees)\nAlice -> Carol: [Alice, Carol] (1 degree)\nCycle detected: True',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'sep_l3_tries',
    topicTitle: 'Tries',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 35,
    totalXp: 225,
    emoji: '🔠',
    intro: 'How does Google autocomplete instantly suggest searches as you type? How does your phone\'s keyboard predict the next word? The answer is almost always a Trie — a specialised tree built for lightning-fast prefix-based string operations.',
    concepts: [
      ConceptLesson(
        title: 'What is a Trie?',
        definition: 'A trie (from "retrieval") is a tree where each node represents a single character, and paths from root to marked nodes spell out complete words.',
        analogy: 'A trie is like a tree-shaped autocomplete system — typing "c" branches to all words starting with "c", typing "ca" narrows to "cat", "car", "cap" — each letter narrows the branch.',
        example: 'Trie containing "cat", "car", "card":\n        root\n         |\n         c\n         |\n         a\n        / \\\n       t   r\n           |\n           d (end of "card")\n\n"cat" and "car" share the "ca" prefix path.',
        keyTakeaway: 'Words sharing a common prefix share the same path in the trie — exactly what makes prefix-based operations so efficient.',
      ),
      ConceptLesson(
        title: 'Trie Node Structure',
        definition: 'Each node stores a dictionary mapping child characters to child nodes, plus an is_end_of_word flag marking complete words.',
        analogy: 'Each node is a signpost listing every possible next letter you could take, with a flag saying "a complete valid word also ends right here" if applicable.',
        example: 'class TrieNode:\n    def __init__(self):\n        self.children = {}  # char -> TrieNode\n        self.is_end = False\n\nclass Trie:\n    def __init__(self):\n        self.root = TrieNode()',
        keyTakeaway: 'is_end_of_word distinguishes "car" being a valid word from "ca" being just an intermediate path toward longer words.',
      ),
      ConceptLesson(
        title: 'Inserting a Word',
        definition: 'Walk character by character from root, creating new nodes for any missing characters, and mark the final node as end-of-word.',
        analogy: 'Inserting a word is like walking a building creating new doors for missing rooms and putting a "destination reached" sign on the final door.',
        example: 'def insert(self, word):\n    node = self.root\n    for char in word:\n        if char not in node.children:\n            node.children[char] = TrieNode()\n        node = node.children[char]\n    node.is_end = True\n\ntrie.insert("cat")\ntrie.insert("car")  # reuses the shared "c" -> "a" path',
        keyTakeaway: 'Insertion is O(L) where L is word length — independent of how many words are already in the trie.',
      ),
      ConceptLesson(
        title: 'Search & Prefix Matching',
        definition: 'Search checks exact word existence by verifying is_end at the final node. Prefix matching just checks the path exists, regardless of is_end.',
        analogy: 'Searching for an exact word checks the path AND the "destination" sign. Checking a prefix just confirms the hallway exists — no sign needed.',
        example: 'def search(self, word):\n    node = self.root\n    for c in word:\n        if c not in node.children: return False\n        node = node.children[c]\n    return node.is_end  # must be complete word\n\ndef starts_with(self, prefix):\n    node = self.root\n    for c in prefix:\n        if c not in node.children: return False\n        node = node.children[c]\n    return True  # path exists, words may continue',
        keyTakeaway: 'This difference (checking is_end vs just path existence) is the distinction between "is this a valid word?" and "could autocomplete suggest something?"',
      ),
      ConceptLesson(
        title: 'Autocomplete — Getting All Suggestions',
        definition: 'Starting from the prefix\'s endpoint node, a DFS collects all complete words reachable from that point — efficiently returning all autocomplete candidates.',
        analogy: 'Autocomplete is a librarian who, given the first few letters, instantly points to the shelf section with every matching title — without scanning the entire library.',
        example: 'def get_suggestions(self, prefix):\n    node = self.root\n    for c in prefix:\n        if c not in node.children: return []\n        node = node.children[c]\n    results = []\n    self._dfs_collect(node, prefix, results)\n    return results\n\ndef _dfs_collect(self, node, current, results):\n    if node.is_end: results.append(current)\n    for c, child in node.children.items():\n        self._dfs_collect(child, current + c, results)',
        keyTakeaway: 'Compare to checking every word\'s prefix in a list: O(n×L). A trie navigates to the prefix node in O(L) regardless of total word count — far more scalable.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does each path from root to a marked node in a trie represent?',
        options: [
          'A single character',
          'A sequence of characters spelling a complete word or prefix',
          'A sorted array',
          'A random number'
        ],
        correctIndex: 1,
        explanation: 'Each path character by character spells out a word or prefix — the defining structural idea of a trie.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why does a trie node need an is_end_of_word flag?',
        options: [
          'Not necessary',
          'To distinguish a complete valid word from just being a prefix of a longer word',
          'Marks the root only',
          'Indicates how many children the node has'
        ],
        correctIndex: 1,
        explanation: 'Without this flag you cannot tell whether "ca" is a valid standalone word or just an intermediate path toward "cat" and "car".',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the time complexity of inserting a word of length L into a trie?',
        options: ['O(1)', 'O(L), independent of how many words exist', 'O(n) where n = total words', 'O(L²)'],
        correctIndex: 1,
        explanation: 'Insertion only depends on L (the word length) — walking/creating L nodes regardless of how many other words are stored.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A trie contains "car" and "card" but NOT "ca". What does search("ca") return?',
        options: [
          'True — "ca" path exists',
          'False — the "ca" node exists but is_end is False',
          'Error',
          'True — because "car" exists'
        ],
        correctIndex: 1,
        explanation: 'Even though the "ca" path exists (traversed by "car" and "card"), is_end at the "a" node is False since "ca" was never inserted as a complete word.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Why is a trie better than scanning every word for prefix matching with 1M words?',
        options: [
          'Tries always use less memory',
          'A trie reaches the prefix node in O(L) time regardless of word count; scanning is O(n×L)',
          'No real advantage',
          'Lists cannot store strings'
        ],
        correctIndex: 1,
        explanation: 'A trie navigates directly to the prefix\'s position in O(L) time — whether the dictionary has 100 or 1 million words does not matter, unlike O(n×L) linear scanning.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Autocomplete Engine',
      goal: 'Build a complete Trie-based autocomplete system with insertion, search, prefix check, and suggestions.',
      steps: [
        'Create TrieNode and Trie classes with insert(word) and search(word)',
        'Insert at least 15 words with several sharing common prefixes (cat, car, card, care...)',
        'Implement starts_with(prefix) checking if any words match',
        'Implement get_suggestions(prefix) returning ALL words starting with that prefix using DFS',
        'Test get_suggestions with at least 3 prefixes of varying specificity',
        'Comment explaining the trie vs naive-scan efficiency difference',
      ],
      expectedOutput: 'Inserted 15 words.\nsearch("card"): True\nsearch("ca"): False (valid prefix, not a complete word)\nget_suggestions("car"): ["car", "card", "care"]\nget_suggestions("do"): ["dog", "door"]',
      xpReward: 60,
    ),
  ),
];