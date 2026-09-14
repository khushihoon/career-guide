// ══════════════════════════════════════════════════════════════════════
// lib/models/software_courses_level4.dart
// Software Engineering Learning Path — LEVEL 4: Algorithms
// ══════════════════════════════════════════════════════════════════════

import '../../models/course_content_data.dart'; 

const List<TopicCourse> softwareCoursesLevel4 = [

  TopicCourse(
    id: 'sep_l4_searching',
    topicTitle: 'Searching Algorithms',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 210,
    emoji: '🔎',
    intro: 'Searching is the act of finding a specific element in a collection. Whether you are finding a user in a database of millions, looking up a contact on your phone, or locating a package in a warehouse system — a searching algorithm is running under the hood. This course covers the two essential strategies: linear and binary search.',
    concepts: [
      ConceptLesson(
        title: 'Linear Search — O(n)',
        definition: 'Linear search scans every element from start to end, checking each one until the target is found or the list is exhausted.',
        analogy: 'Linear search is like looking for a specific book in a completely unsorted pile — you pick up each book and check its title one by one until you find the right one.',
        example: 'def linear_search(arr, target):\n    for i, val in enumerate(arr):\n        if val == target:\n            return i  # return index where found\n    return -1  # not found\n\nprint(linear_search([3, 1, 8, 5, 2], 8))  # 2 (index)',
        keyTakeaway: 'Linear search works on ANY list (sorted or unsorted). Its O(n) worst case means for 1 million elements you might check all 1 million — acceptable for small lists, problematic at scale.',
      ),
      ConceptLesson(
        title: 'Binary Search — O(log n)',
        definition: 'Binary search works ONLY on sorted data. It repeatedly compares the target to the MIDDLE element and discards half the remaining elements each time.',
        analogy: 'Binary search is like finding a name in a phone book: open to the middle, determine which half the name is in, discard the other half, repeat — finding any name in ~20 steps for a million-entry book.',
        example: 'def binary_search(arr, target):\n    low, high = 0, len(arr) - 1\n    while low <= high:\n        mid = (low + high) // 2\n        if arr[mid] == target: return mid\n        elif arr[mid] < target: low = mid + 1  # target in right half\n        else: high = mid - 1                    # target in left half\n    return -1',
        keyTakeaway: 'Binary search on 1 million elements takes at most 20 comparisons (log2 of 1,000,000 ≈ 20). This exponential efficiency difference over linear search is the reason sorted data is so valuable.',
        codeSnippet: '# Recursive version\ndef binary_search_recursive(arr, target, low, high):\n    if low > high: return -1\n    mid = (low + high) // 2\n    if arr[mid] == target: return mid\n    elif arr[mid] < target:\n        return binary_search_recursive(arr, target, mid+1, high)\n    else:\n        return binary_search_recursive(arr, target, low, mid-1)',
      ),
      ConceptLesson(
        title: 'When to Use Linear vs Binary Search',
        definition: 'Use linear search when data is unsorted (or very small). Use binary search when data is sorted — the O(log n) advantage only applies when the sorting prerequisite is satisfied.',
        analogy: 'Choosing the wrong search is like using a GPS to navigate a route that doesn\'t exist in the map yet — the GPS is sophisticated but useless if the data (road) isn\'t available in the right form.',
        example: 'Unsorted list of 1000 items:\n→ Linear search: up to 1000 comparisons, average 500\n→ Binary search: CANNOT APPLY (data must be sorted first)\n\nSorted list of 1000 items:\n→ Binary search: up to 10 comparisons\n→ Linear search: up to 1000 comparisons, average 500',
        keyTakeaway: 'If data changes frequently (unsorted inserts), the cost of maintaining sorted order may outweigh the binary search benefit. If data is static or pre-sorted, binary search is almost always better.',
      ),
      ConceptLesson(
        title: 'Jump Search & Interpolation Search (Overview)',
        definition: 'Jump search blocks ahead by fixed steps then linearly scans backward — O(√n). Interpolation search estimates position mathematically for uniformly distributed data — O(log log n) best case.',
        analogy: 'Jump search is like scanning a sorted list by jumping every 10 pages and then reading backward when you overshoot. Interpolation search is like a librarian who guesses which shelf a book is on based on how far through the alphabet the title falls.',
        example: 'Jump search: divide into blocks of size √n (100 for 10,000 items)\n→ Jump forward by 100 until you overshoot the target\n→ Linear search backward through the last block\n→ At most √10000 + √10000 = 200 comparisons',
        keyTakeaway: 'These are rarely implemented from scratch in production — they are conceptually important to know exist and to understand the trade-off space between search algorithms.',
      ),
      ConceptLesson(
        title: 'Binary Search on Answer (Advanced Pattern)',
        definition: 'A powerful interview pattern: when you need to find the minimum/maximum value satisfying a condition, binary search on the ANSWER SPACE rather than a pre-existing sorted array.',
        analogy: 'Binary search on the answer is like finding the minimum ticket price that makes a concert profitable — you don\'t scan each possible price one by one; you try the midpoint price and logically determine whether the real answer must be higher or lower.',
        example: '# Find minimum speed to eat all bananas in H hours\ndef min_eating_speed(piles, H):\n    low, high = 1, max(piles)\n    while low < high:\n        mid = (low + high) // 2\n        hours = sum(-(-p // mid) for p in piles)  # ceil division\n        if hours <= H: high = mid  # can go slower\n        else: low = mid + 1        # need to go faster\n    return low',
        keyTakeaway: 'This "binary search on the answer" pattern appears in many medium-hard LeetCode problems. Recognising it requires seeing that the answer space itself is monotonic (increasing one way, decreasing the other).',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the key prerequisite for binary search to work?',
        options: [
          'The list must contain only integers',
          'The list must be sorted',
          'The list must have an even number of elements',
          'The target must be in the middle'
        ],
        correctIndex: 1,
        explanation: 'Binary search relies on the sorted property to safely discard half the elements each step — on unsorted data, this logic breaks and the algorithm produces incorrect results.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Binary search on a sorted list of 1 million elements takes at most how many comparisons?',
        options: ['500,000', '1,000', '20', '1'],
        correctIndex: 2,
        explanation: 'log2(1,000,000) ≈ 20. Binary search halves the remaining elements each step — 20 halvings reduces 1 million elements to 1.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the time complexity of linear search in the worst case?',
        options: ['O(1)', 'O(log n)', 'O(n)', 'O(n²)'],
        correctIndex: 2,
        explanation: 'In the worst case (target is last or not present), linear search checks every element — O(n) comparisons proportional to list size.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Binary search on arr=[1,3,5,7,9,11] for target=7:\nWhat is mid on the first iteration? What happens next?',
        options: [
          'mid=2 (value 5), target > 5, search right half [7,9,11]',
          'mid=2 (value 5), target < 5, search left half [1,3]',
          'mid=3 (value 7), target found immediately',
          'mid=0, start from the beginning'
        ],
        correctIndex: 0,
        explanation: 'low=0, high=5, mid=(0+5)//2=2, arr[2]=5. Since 7>5, low becomes mid+1=3. Next iteration searches [7,9,11] and finds 7 at mid=3.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You have an unsorted list of 50 elements and need to search it once. Which is the best approach?',
        options: [
          'Sort then binary search',
          'Linear search directly',
          'Convert to a hash set first',
          'Use interpolation search'
        ],
        correctIndex: 1,
        explanation: 'For a single search on a small unsorted list, linear search O(n) is ideal. Sorting first costs O(n log n) — far more expensive than the O(n) linear search for just one lookup.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Search Algorithm Benchmark',
      goal: 'Implement both linear and binary search, benchmark them on various list sizes, and apply the binary-search-on-answer pattern.',
      steps: [
        'Implement linear_search(arr, target) returning the index or -1',
        'Implement binary_search(arr, target) iteratively returning the index or -1',
        'Generate sorted lists of sizes 100, 10,000, and 1,000,000 and time both algorithms searching for the last element',
        'Print a comparison table of times across sizes',
        'Implement the "minimum eating speed" problem using binary search on the answer space',
        'Verify both search implementations agree on results for a shared test dataset',
      ],
      expectedOutput: 'Size 100:       Linear 0.00001s  Binary 0.000001s\nSize 10,000:    Linear 0.001s    Binary 0.000002s\nSize 1,000,000: Linear 0.05s     Binary 0.000003s\nMin eating speed for piles=[3,6,7,11], H=8: 4',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l4_sorting',
    topicTitle: 'Sorting Algorithms',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 40,
    totalXp: 245,
    emoji: '🔢',
    intro: 'Sorting is the most studied problem in computer science. Every database ORDER BY, every "sort by price" button, every recommendation engine ranking results — sorting runs underneath. Understanding HOW sorting algorithms work at the level of swaps and comparisons is what makes Big-O notation click, and it is tested in virtually every senior engineering interview.',
    concepts: [
      ConceptLesson(
        title: 'Bubble Sort — O(n²)',
        definition: 'Bubble sort repeatedly compares adjacent elements and swaps them if they are in the wrong order — "bubbling" the largest unsorted element to the end in each pass.',
        analogy: 'Bubble sort is like sorting a row of people by height — repeatedly walk down the row swapping adjacent pairs who are out of order. After each full walk, the tallest remaining unsorted person is at the end.',
        example: 'def bubble_sort(arr):\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n    return arr\n\nprint(bubble_sort([5,3,8,1,2]))  # [1,2,3,5,8]',
        keyTakeaway: 'Bubble sort is simple to understand and implement but terrible for real use — O(n²) comparisons make it impractical for large lists. It is taught primarily to build intuition for why better algorithms matter.',
      ),
      ConceptLesson(
        title: 'Selection Sort — O(n²)',
        definition: 'Selection sort repeatedly finds the minimum element from the unsorted portion and moves it to its correct position at the front.',
        analogy: 'Selection sort is like sorting a hand of cards by always finding the lowest card, moving it to the front of your hand, and repeating with the remaining cards.',
        example: 'def selection_sort(arr):\n    n = len(arr)\n    for i in range(n):\n        min_idx = i\n        for j in range(i+1, n):\n            if arr[j] < arr[min_idx]:\n                min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr',
        keyTakeaway: 'Selection sort makes exactly n swaps (one per pass) — fewer than bubble sort. But still O(n²) comparisons, making it slow for large lists. Useful only for minimising swaps when writes are expensive.',
      ),
      ConceptLesson(
        title: 'Insertion Sort — O(n²) worst, O(n) best',
        definition: 'Insertion sort builds a sorted section at the front, one element at a time — taking each new element and inserting it into its correct position among the already-sorted elements.',
        analogy: 'Insertion sort is how you naturally sort a hand of cards as you pick them up — hold sorted cards in your left hand, pick up each new card, and slide it into its correct position.',
        example: 'def insertion_sort(arr):\n    for i in range(1, len(arr)):\n        key = arr[i]\n        j = i - 1\n        while j >= 0 and arr[j] > key:\n            arr[j+1] = arr[j]\n            j -= 1\n        arr[j+1] = key\n    return arr',
        keyTakeaway: 'Insertion sort is O(n) for nearly sorted data — making it actually better than merge/quick sort for small or nearly-sorted lists. Python\'s Timsort uses insertion sort for small sub-arrays exactly for this reason.',
      ),
      ConceptLesson(
        title: 'Merge Sort — O(n log n)',
        definition: 'Merge sort divides the array in half recursively until single elements remain, then merges pairs of sorted sub-arrays back together — producing a fully sorted array.',
        analogy: 'Merge sort is like sorting a deck of cards by splitting it in half repeatedly until you have single cards, then merging pairs of sorted piles back together — two sorted piles of 4 merge into one sorted pile of 8 very efficiently.',
        example: 'def merge_sort(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr) // 2\n    left = merge_sort(arr[:mid])\n    right = merge_sort(arr[mid:])\n    return merge(left, right)\n\ndef merge(left, right):\n    result, i, j = [], 0, 0\n    while i < len(left) and j < len(right):\n        if left[i] <= right[j]: result.append(left[i]); i += 1\n        else: result.append(right[j]); j += 1\n    return result + left[i:] + right[j:]',
        keyTakeaway: 'Merge sort is O(n log n) ALWAYS — no bad cases. It uses O(n) extra space. It is stable (preserves relative order of equal elements). Preferred when stability and guaranteed performance matter.',
      ),
      ConceptLesson(
        title: 'Quick Sort — O(n log n) avg, O(n²) worst',
        definition: 'Quick sort picks a "pivot" element, partitions all other elements into those smaller (left) and larger (right) than the pivot, then recursively sorts both partitions.',
        analogy: 'Quick sort is like organising a large team event: pick one person as the reference (pivot), split everyone into "younger than them" and "older than them", then repeat the process on each group independently.',
        example: 'def quick_sort(arr):\n    if len(arr) <= 1: return arr\n    pivot = arr[len(arr) // 2]\n    left = [x for x in arr if x < pivot]\n    mid  = [x for x in arr if x == pivot]\n    right = [x for x in arr if x > pivot]\n    return quick_sort(left) + mid + quick_sort(right)',
        keyTakeaway: 'Quick sort is O(n log n) on average and O(1) extra space (in-place version) — making it faster in practice than merge sort despite the worst-case risk. Python\'s built-in sort uses Timsort, a hybrid of merge and insertion sort.',
      ),
      ConceptLesson(
        title: 'Choosing the Right Sort & Python\'s Built-In',
        definition: 'Different sorting algorithms excel in different scenarios. Python\'s sorted() and list.sort() use Timsort (adaptive merge sort) which is O(n log n) worst-case and O(n) for already-sorted data.',
        analogy: 'Choosing a sorting algorithm is like choosing a vehicle — a motorcycle (quick sort) is fast and efficient in good conditions but risky in the worst case; a train (merge sort) is guaranteed consistent speed but uses more infrastructure.',
        example: '# Always use Python\'s built-in for production:\nnums = [3, 1, 4, 1, 5, 9]\nsorted_nums = sorted(nums)           # returns new list\nnums.sort()                           # sorts in-place\nnums.sort(key=lambda x: -x)           # sort descending\nstudents.sort(key=lambda s: s.grade)  # sort by attribute',
        keyTakeaway: 'In production, always use the language\'s built-in sort. In interviews, implementing merge sort or quick sort demonstrates algorithmic understanding. Know the trade-offs so you can justify your choice.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why is bubble sort rarely used in real applications?',
        options: [
          'It is too complicated to implement',
          'Its O(n²) time complexity makes it impractical for large datasets',
          'It only works on strings',
          'It requires extra memory'
        ],
        correctIndex: 1,
        explanation: 'Bubble sort requires O(n²) comparisons — for 100,000 elements that is 10 billion comparisons, compared to ~1.7 million for an O(n log n) algorithm. The difference is catastrophic at scale.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the time complexity of merge sort in the WORST case?',
        options: ['O(n)', 'O(n log n)', 'O(n²)', 'O(log n)'],
        correctIndex: 1,
        explanation: 'Merge sort is always O(n log n) — unlike quick sort, it has no bad cases because it always divides evenly and merges all sub-arrays regardless of input order.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'When is insertion sort a GOOD choice despite its O(n²) worst case?',
        options: [
          'Never — it should always be replaced by merge sort',
          'For small lists or nearly-sorted data, where it achieves close to O(n)',
          'Only for string data',
          'Only when memory is unlimited'
        ],
        correctIndex: 1,
        explanation: 'Insertion sort is O(n) for nearly-sorted data (very few swaps needed). Python\'s Timsort uses insertion sort for small sub-arrays (typically < 64 elements) because of this efficiency advantage.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Quick sort\'s worst case (O(n²)) occurs when which scenario repeatedly happens?',
        options: [
          'The array is sorted in random order',
          'The pivot is always the smallest or largest element, creating maximally uneven partitions',
          'The array contains duplicate values',
          'The array has an odd number of elements'
        ],
        correctIndex: 1,
        explanation: 'When the pivot is always the minimum or maximum, one partition has 0 elements and the other has n-1 — meaning n recursive calls of decreasing size, giving O(n²) total comparisons.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You need to sort a list of 10 million user records for a one-time report export. Which approach makes most sense?',
        options: [
          'Implement bubble sort manually',
          'Use Python\'s built-in sorted(), which uses the optimised Timsort algorithm',
          'Use selection sort to minimise the number of swaps',
          'Avoid sorting — it is always too slow for 10 million records'
        ],
        correctIndex: 1,
        explanation: 'Python\'s sorted() uses Timsort — O(n log n) worst case, highly optimised in C under the hood. Reimplementing a sorting algorithm in Python for production data is almost never the right move.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Sorting Algorithm Visualiser & Benchmark',
      goal: 'Implement 4 sorting algorithms, benchmark them, and demonstrate understanding of their trade-offs.',
      steps: [
        'Implement bubble_sort, selection_sort, insertion_sort, and merge_sort, each returning a sorted list',
        'Verify all 4 produce identical output on the same random test array',
        'Benchmark all 4 on a list of 5,000 random integers and print each algorithm\'s execution time',
        'Generate a nearly-sorted list of 5,000 elements and benchmark insertion_sort vs merge_sort to demonstrate insertion sort\'s advantage',
        'Implement a sort_students function using Python\'s built-in sorted() with a custom key (sort by grade then by name)',
        'Write a comment summarising when you would choose each algorithm and why',
      ],
      expectedOutput: 'All 4 algorithms: identical output ✓\n5,000 random elements:\n  Bubble:    2.1s   Selection: 0.9s   Insertion: 0.8s   Merge: 0.003s\n5,000 nearly-sorted:\n  Insertion: 0.001s (near O(n)!)  Merge: 0.003s\nStudents sorted by grade then name: ✓',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'sep_l4_recursion',
    topicTitle: 'Recursion',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 35,
    totalXp: 225,
    emoji: '🪞',
    intro: 'Recursion is the programming equivalent of a mirror placed in front of a mirror — a function that solves a problem by calling a smaller version of itself. It powers tree traversals, divide-and-conquer algorithms, and parsing nested structures. Once the "click" moment happens, you will see recursive solutions everywhere.',
    concepts: [
      ConceptLesson(
        title: 'What is Recursion?',
        definition: 'Recursion is when a function calls itself to solve a smaller version of the same problem, continuing until it reaches a "base case" that can be solved directly without another call.',
        analogy: 'Recursion is like Russian nesting dolls — open a doll and find a smaller doll, open that and find an even smaller one, until you reach the smallest solid doll that cannot be opened further (the base case).',
        example: 'def countdown(n):\n    if n == 0:           # BASE CASE — stop here\n        print("Blast off!")\n        return\n    print(n)\n    countdown(n - 1)    # RECURSIVE CALL — smaller problem\n\ncountdown(5)  # 5, 4, 3, 2, 1, Blast off!',
        keyTakeaway: 'Every recursive function MUST have a base case (the stopping condition) — without it, the function calls itself forever, causing a stack overflow.',
      ),
      ConceptLesson(
        title: 'Factorial & Fibonacci — Classic Examples',
        definition: 'Factorial (n!) multiplies all integers from 1 to n. Fibonacci generates a sequence where each number is the sum of the previous two. Both have elegant recursive definitions.',
        analogy: 'Computing factorial(5) is like asking "what is 5 times factorial(4)?" — and factorial(4) asks "what is 4 times factorial(3)?" — delegating to a smaller version until factorial(1) = 1, the base case.',
        example: 'def factorial(n):\n    if n <= 1: return 1      # base case\n    return n * factorial(n-1)  # recursive case\n\ndef fibonacci(n):\n    if n <= 1: return n      # base cases: fib(0)=0, fib(1)=1\n    return fibonacci(n-1) + fibonacci(n-2)\n\nprint(factorial(5))   # 120\nprint(fibonacci(7))   # 13',
        keyTakeaway: 'Naive recursive Fibonacci is O(2^n) — exponentially slow! Each call branches into two more calls, creating a huge redundant tree. This motivates memoisation (covered in Dynamic Programming).',
      ),
      ConceptLesson(
        title: 'The Call Stack During Recursion',
        definition: 'Each recursive call pushes a new frame onto the call stack. When the base case is reached, frames pop off one by one — this is exactly why deep recursion causes stack overflow errors.',
        analogy: 'Recursive calls are like stacking to-do notes on your desk — each new call adds a note saying "come back here when the smaller version is done." When the base case finishes, you work back through the pile in reverse order.',
        example: 'factorial(3) call trace:\n  factorial(3) → pushes frame, calls factorial(2)\n    factorial(2) → pushes frame, calls factorial(1)\n      factorial(1) → returns 1 (base case, pops)\n    factorial(2) → gets 1, returns 2×1=2 (pops)\n  factorial(3) → gets 2, returns 3×2=6 (pops)',
        keyTakeaway: 'Understanding the call stack during recursion is the key to debugging recursive functions — draw out the call stack for small inputs to build intuition.',
      ),
      ConceptLesson(
        title: 'Recursion vs Iteration',
        definition: 'Any recursive algorithm can be rewritten iteratively (using loops and an explicit stack), and vice versa. Recursion is often more readable; iteration is often more memory-efficient.',
        analogy: 'Recursion vs iteration is like climbing a staircase by stepping upward one floor at a time (iteration) versus teleporting to the top and working backward (recursion) — both reach the same destination, just different paths.',
        example: '# Recursive factorial — elegant, readable\ndef factorial_recursive(n):\n    if n <= 1: return 1\n    return n * factorial_recursive(n-1)\n\n# Iterative factorial — more memory efficient\ndef factorial_iterative(n):\n    result = 1\n    for i in range(2, n+1):\n        result *= i\n    return result',
        keyTakeaway: 'Python has a default recursion limit of ~1000 levels. For very deep recursion (e.g. large n), iterative solutions avoid stack overflow. Use recursion when it makes the logic significantly clearer.',
      ),
      ConceptLesson(
        title: 'Thinking Recursively: The Template',
        definition: 'The key to writing recursive solutions is: identify the base case(s), identify how to reduce the problem to a SMALLER version of itself, and trust that the recursive call returns the correct answer for the smaller version.',
        analogy: '"Trust the recursion" is like trusting a professional to handle their part of a delegated task — you don\'t need to micromanage every step they take; you just pass them the smaller problem and use their result.',
        example: '# Template for recursive thinking:\n# 1. What is the smallest version that has a direct answer?\n# 2. How does the answer for size n relate to the answer for size n-1?\n\n# Example: sum of a list\ndef list_sum(lst):\n    if not lst: return 0          # base case: empty list\n    return lst[0] + list_sum(lst[1:])  # first element + sum of rest',
        keyTakeaway: 'The hardest part of recursion is NOT the syntax — it is trusting that the smaller recursive call works correctly and focusing only on "what does the current level need to do?"',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What MUST every recursive function have to avoid infinite recursion?',
        options: [
          'At least two recursive calls',
          'A base case — a condition that stops the recursion without making another call',
          'A return value of exactly 0',
          'An external loop wrapping it'
        ],
        correctIndex: 1,
        explanation: 'Without a base case, a recursive function calls itself endlessly, growing the call stack until Python raises a RecursionError (stack overflow).',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the time complexity of the naive recursive Fibonacci implementation?',
        options: ['O(n)', 'O(log n)', 'O(2^n)', 'O(n²)'],
        correctIndex: 2,
        explanation: 'Each fibonacci(n) call makes two recursive calls, creating an exponentially growing call tree. fibonacci(50) makes roughly 2^50 calls — completely impractical.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What happens when Python exceeds its default recursion depth limit?',
        options: [
          'Python automatically converts to an iterative approach',
          'A RecursionError (stack overflow) is raised',
          'The function returns None',
          'Python increases the limit automatically'
        ],
        correctIndex: 1,
        explanation: 'Python\'s default recursion limit is ~1000 frames. Exceeding it raises a RecursionError, indicating the call stack has grown larger than allowed.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'def mystery(n):\n    if n == 0: return 0\n    return n + mystery(n - 1)\n\nprint(mystery(4))\n\nWhat is printed?',
        options: ['4', '10', '24', '0'],
        correctIndex: 1,
        explanation: 'mystery(4) = 4 + mystery(3) = 4 + 3 + mystery(2) = 4+3+2+mystery(1) = 4+3+2+1+mystery(0) = 4+3+2+1+0 = 10. This is the sum of 1 to n.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You need to compute fibonacci(45). The naive recursive version is too slow. What is the fundamental problem?',
        options: [
          'Python\'s recursion limit is too low',
          'The same sub-problems are recomputed exponentially many times',
          'Fibonacci is impossible to compute recursively',
          'Python does not support integer arithmetic at this scale'
        ],
        correctIndex: 1,
        explanation: 'fibonacci(45) repeatedly recomputes fibonacci(44), fibonacci(43), etc. thousands of times each. This redundant recomputation makes it O(2^n). Memoisation or iteration eliminates this waste.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Recursive Algorithm Collection',
      goal: 'Implement 5 classic recursive algorithms, tracing the call stack for one of them.',
      steps: [
        'Implement factorial(n) recursively and verify against iterative version',
        'Implement power(base, exp) using recursion: power(x, n) = x * power(x, n-1)',
        'Implement is_palindrome(s) recursively: compare first and last characters, recurse on middle',
        'Implement sum_nested(lst) that sums integers in an arbitrarily nested list of lists',
        'Implement flatten(lst) that converts a nested list into a flat list recursively',
        'Write a step-by-step trace of the call stack for factorial(4) in comments',
      ],
      expectedOutput: 'factorial(5): 120 (matches iterative)\npower(2, 10): 1024\nis_palindrome("racecar"): True\nsum_nested([1,[2,[3]],4]): 10\nflatten([1,[2,[3,4]],5]): [1,2,3,4,5]',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l4_divide_and_conquer',
    topicTitle: 'Divide & Conquer',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 35,
    totalXp: 230,
    emoji: '⚔️',
    intro: 'Divide and conquer is one of the most powerful algorithm design strategies in computer science. Merge sort, binary search, fast multiplication, and fast Fourier transforms all use it. The core idea — split into smaller independent sub-problems, solve each, combine results — is elegant and broadly applicable.',
    concepts: [
      ConceptLesson(
        title: 'The Divide and Conquer Pattern',
        definition: 'Divide and conquer has three steps: DIVIDE the problem into smaller sub-problems, CONQUER each sub-problem recursively, and COMBINE the sub-problem results to solve the original.',
        analogy: 'Divide and conquer is like a general splitting an army into three independent units — divide the front into sections, send each unit to conquer its section independently, then regroup and combine the controlled territory.',
        example: 'Merge Sort as D&C:\n1. DIVIDE: split array in half → [left], [right]\n2. CONQUER: merge_sort(left), merge_sort(right) recursively\n3. COMBINE: merge the two sorted halves together\n\nThe combine step does the real work in merge sort.',
        keyTakeaway: 'The power of divide and conquer comes from reducing a problem exponentially — each level of division roughly halves the problem size, producing the log n factor in O(n log n) algorithms.',
      ),
      ConceptLesson(
        title: 'Maximum Subarray (Kadane\'s Algorithm vs D&C)',
        definition: 'The maximum subarray problem asks for the contiguous sub-array with the largest sum. The D&C approach splits the array and considers sums crossing the midpoint as a third case.',
        analogy: 'Finding the maximum crossing subarray is like finding the peak of a hill that spans a valley floor — you search both sides of the center and the peak necessarily crosses it.',
        example: 'def max_crossing(arr, low, mid, high):\n    left_sum = float("-inf")\n    s = 0\n    for i in range(mid, low-1, -1):\n        s += arr[i]\n        left_sum = max(left_sum, s)\n    right_sum = float("-inf")\n    s = 0\n    for i in range(mid+1, high+1):\n        s += arr[i]\n        right_sum = max(right_sum, s)\n    return left_sum + right_sum',
        keyTakeaway: 'D&C gives O(n log n) for maximum subarray. Kadane\'s algorithm achieves O(n) with a single pass — but understanding the D&C approach builds the mental model for the COMBINE step.',
      ),
      ConceptLesson(
        title: 'The Master Theorem (Intuition)',
        definition: 'The Master Theorem provides a formula for analysing the time complexity of divide-and-conquer algorithms: T(n) = aT(n/b) + f(n), where a = sub-problems, b = problem size reduction factor, f(n) = combine cost.',
        analogy: 'The Master Theorem is like a pricing formula for a delivery system — given how many packages you split into (a), how small each sub-package is (1/b), and the cost to repackage at the end (f(n)), it calculates the total cost.',
        example: 'Merge Sort: T(n) = 2T(n/2) + O(n)\n  a=2, b=2, f(n)=O(n)\n  → O(n log n)\n\nBinary Search: T(n) = 1T(n/2) + O(1)\n  a=1, b=2, f(n)=O(1)\n  → O(log n)',
        keyTakeaway: 'You do not need to memorise the Master Theorem formally, but recognising T(n) = 2T(n/2) + O(n) → O(n log n) is enough to handle most interview questions about D&C algorithm complexity.',
      ),
      ConceptLesson(
        title: 'Closest Pair of Points (Classic D&C Problem)',
        definition: 'Given n points, find the pair with the smallest distance. Brute force is O(n²). D&C achieves O(n log n) by splitting points into left/right halves and cleverly handling pairs spanning the boundary.',
        analogy: 'Finding the closest pair by brute force is measuring every possible pair of people\'s distances in a crowd. D&C is like splitting the crowd in two, finding the closest pair on each side, then only checking a narrow boundary strip in the middle.',
        example: 'High-level D&C closest pair:\n1. DIVIDE: sort points by x, split at median\n2. CONQUER: recursively find closest pair in left and right halves\n3. COMBINE: d = min(d_left, d_right); check points within d of the dividing line\n   (At most 8 other points can be within d of any boundary point)',
        keyTakeaway: 'The "strip" boundary check in closest pair is the most elegant part — the mathematical guarantee that only a constant number of points need checking in the strip is what gives D&C its O(n log n) advantage over brute force.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What are the three steps of a divide-and-conquer algorithm?',
        options: [
          'Loop, recurse, return',
          'Divide into sub-problems, conquer (solve) each recursively, combine results',
          'Sort, search, insert',
          'Read input, process, write output'
        ],
        correctIndex: 1,
        explanation: 'All D&C algorithms share this structure: divide the problem, solve each piece recursively (or directly for base cases), then combine the results into the final answer.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Merge sort has the recurrence T(n) = 2T(n/2) + O(n). What is its time complexity?',
        options: ['O(n)', 'O(log n)', 'O(n log n)', 'O(n²)'],
        correctIndex: 2,
        explanation: 'a=2 sub-problems, each of size n/2 (b=2), with O(n) combine cost — the Master Theorem gives O(n log n).',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why does divide and conquer often produce O(n log n) algorithms rather than O(n²)?',
        options: [
          'Recursion is inherently faster than iteration',
          'Each division reduces problem size by half, producing a logarithmic depth of recursion that multiplies the O(n) combine work',
          'D&C skips comparisons entirely',
          'It always requires fewer operations than O(n²)'
        ],
        correctIndex: 1,
        explanation: 'The log n factor comes from the depth of recursive division (halving the problem log n times). Each level of the recursion tree does O(n) total work — giving O(n log n) overall.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'For merge_sort, which step actually does the COMPARISON work?',
        options: [
          'The divide step (splitting the array)',
          'The combine step (merging two sorted halves)',
          'The base case check',
          'No comparisons are needed — just splitting'
        ],
        correctIndex: 1,
        explanation: 'Splitting the array in merge sort requires no comparisons — it just calculates a midpoint. All the comparison work happens in the merge step, where elements from two sorted halves are compared to produce one sorted output.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Binary search has recurrence T(n) = T(n/2) + O(1). What complexity does this give?',
        options: ['O(n)', 'O(log n)', 'O(n log n)', 'O(1)'],
        correctIndex: 1,
        explanation: 'One sub-problem of size n/2 with constant combine cost. The Master Theorem gives O(log n) — exactly the binary search complexity you already know.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Divide & Conquer Problem Set',
      goal: 'Implement three D&C algorithms and analyse their complexity, culminating in a complete merge sort with performance measurement.',
      steps: [
        'Implement merge_sort(arr) as a full D&C solution and verify on at least 5 test arrays including edge cases',
        'Implement count_inversions(arr) — pairs (i,j) where i<j but arr[i]>arr[j] — using a modified merge sort',
        'Implement power(base, exp) using D&C: power(x,n) = power(x, n//2)² for even n (fast exponentiation)',
        'Benchmark merge_sort against Python\'s built-in sorted() on 100,000 elements',
        'Write the recurrence relation and resulting Big-O for each of the three algorithms',
        'Comment explaining why count_inversions can be solved in O(n log n) by piggy-backing on merge sort',
      ],
      expectedOutput: 'merge_sort([3,1,4,1,5]): [1,1,3,4,5] ✓\ncount_inversions([3,1,2]): 2\npower(2,10): 1024 (O(log n) fast exponentiation)\nmerge_sort 100k elements: 0.2s  Built-in sorted: 0.05s',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'sep_l4_greedy',
    topicTitle: 'Greedy Algorithms',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 215,
    emoji: '🤑',
    intro: 'Greedy algorithms make the locally best choice at each step, hoping to reach a global optimum. They are fast, simple, and work beautifully for the right problems — scheduling systems, data compression (Huffman coding), and network routing all use greedy strategies. Knowing when greedy works (and when it fails) is the critical skill.',
    concepts: [
      ConceptLesson(
        title: 'The Greedy Strategy',
        definition: 'A greedy algorithm always makes the choice that seems best AT THE MOMENT — the locally optimal choice — without reconsidering past decisions or looking ahead.',
        analogy: 'A greedy strategy is like always taking the biggest slice of pizza when the plate comes around, without thinking about what slices will remain for the next round. Sometimes it leads to the best outcome; sometimes it doesn\'t.',
        example: 'Making change for 67 cents with coins [25, 10, 5, 1]:\nGreedy: always use the largest coin that fits\n67 → use 25c (42 remaining)\n42 → use 25c (17 remaining)\n17 → use 10c (7 remaining)\n7  → use 5c  (2 remaining)\n2  → use 1c twice\nResult: 2+1+1+1+2 = 6 coins (optimal!)',
        keyTakeaway: 'Greedy works for coin change WITH standard denominations because coins are carefully designed to be "greedy-friendly". With unusual denominations (e.g. [1, 3, 4]) greedy may give the wrong answer.',
      ),
      ConceptLesson(
        title: 'Activity Selection (Interval Scheduling)',
        definition: 'Given n activities with start and end times, select the maximum number of non-overlapping activities. Greedy: always pick the activity that finishes earliest.',
        analogy: 'Activity selection is like booking as many non-overlapping rooms as possible in a hotel with finite meeting rooms — by always booking the room that finishes soonest, you leave maximum room for future bookings.',
        example: 'Activities: [(1,4), (3,5), (0,6), (5,7), (3,9), (5,9), (6,10)]\nSorted by end time: [(1,4), (3,5), (0,6), (5,7), ...]\n\nGreedy picks:\n(1,4) ← first\n(5,7) ← starts after 4 ✓\n(6,10) ← wait, 6 < 7, skip\n→ Max non-overlapping = 4 activities',
        keyTakeaway: '"Always finish earliest" is provably optimal for activity selection — this is a case where the greedy choice can be formally proved to achieve the global optimum.',
        codeSnippet: 'def activity_selection(activities):\n    activities.sort(key=lambda x: x[1])  # sort by end time\n    selected = [activities[0]]\n    for start, end in activities[1:]:\n        if start >= selected[-1][1]:      # no overlap\n            selected.append((start, end))\n    return selected',
      ),
      ConceptLesson(
        title: 'Fractional Knapsack',
        definition: 'A knapsack problem where you can take FRACTIONS of items. Greedy: sort items by value/weight ratio and take as much of the highest-ratio item as possible.',
        analogy: 'Fractional knapsack is like filling a backpack with valuable materials — gold dust, silver shavings, bronze chips — where you can take any partial amount. Always grab the most valuable-per-gram material first.',
        example: 'Items: (value, weight) → ratio\n(60, 10) → 6.0 per kg\n(100, 20) → 5.0 per kg\n(120, 30) → 4.0 per kg\nKnapsack capacity: 50 kg\n\nGreedy: take all 10kg of item1 (60), all 20kg of item2 (100), take 20/30 of item3 (80)\nTotal value: 60 + 100 + 80 = 240',
        keyTakeaway: 'Greedy works perfectly for FRACTIONAL knapsack. The 0/1 knapsack (items cannot be split) requires dynamic programming — this is a key distinction to understand.',
      ),
      ConceptLesson(
        title: 'When Greedy Fails — Counter Examples',
        definition: 'Greedy fails when locally optimal choices do not lead to globally optimal solutions. Dynamic programming is typically needed instead.',
        analogy: 'Greedy failing is like a hiker who always takes the steepest upward path — they might reach a local hilltop but miss the actually tallest mountain because the path to it initially goes downhill.',
        example: 'Coin change with coins [1, 3, 4], target = 6:\nGreedy: 4 + 1 + 1 = 3 coins\nOptimal: 3 + 3 = 2 coins (greedy FAILED)\n\n0/1 Knapsack (items cannot be split):\nGreedy by ratio is not guaranteed optimal — need dynamic programming.',
        keyTakeaway: 'The key question for any greedy approach: "Can I prove that always making the locally optimal choice leads to a globally optimal solution?" If you cannot prove it, greedy might fail.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does a greedy algorithm always do?',
        options: [
          'Try every possible combination',
          'Make the locally optimal choice at each step without looking ahead',
          'Use dynamic programming internally',
          'Backtrack when a choice proves suboptimal'
        ],
        correctIndex: 1,
        explanation: 'Greedy algorithms commit to the best available choice at each step without reconsidering or looking ahead — which is fast and works well when local optima chain to global optima.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'For the activity selection problem, the greedy rule is:',
        options: [
          'Always pick the activity that starts earliest',
          'Always pick the activity that FINISHES earliest',
          'Always pick the longest activity',
          'Pick activities randomly'
        ],
        correctIndex: 1,
        explanation: 'Picking the activity finishing earliest leaves the maximum remaining time for future activities — this greedy rule is provably optimal for maximising the number of non-overlapping activities.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Greedy works for FRACTIONAL knapsack but not 0/1 knapsack. Why?',
        options: [
          'The math is identical; greedy works for both',
          'With fractions you can always take partial items, so the highest-ratio item is always beneficial; with 0/1 items, taking a high-ratio item might block better combinations',
          'Greedy is always slower',
          '0/1 knapsack is unsolvable'
        ],
        correctIndex: 1,
        explanation: 'Fractional knapsack: taking part of any item is always safe (no wasted capacity). 0/1 knapsack: taking a whole item might prevent better combinations. Greedy ignores future consequences, so it can fail.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Coins [1, 3, 4], target = 6. Greedy gives 4+1+1=3 coins. Optimal is 3+3=2 coins. What does this demonstrate?',
        options: [
          'Greedy is broken and should never be used',
          'Greedy can fail when coin denominations are not designed to be greedy-compatible',
          'The optimal solution is wrong',
          'You should always use the largest coin first'
        ],
        correctIndex: 1,
        explanation: 'Standard coin denominations (1,5,10,25) are designed to be greedy-compatible. Unusual denominations can produce cases where taking the largest coin first leads to a suboptimal total count.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Which of these problems is NOT naturally solved with a greedy algorithm?',
        options: [
          'Activity selection (maximum non-overlapping intervals)',
          'Fractional knapsack (items can be split)',
          '0/1 Knapsack (items cannot be split, must be whole)',
          'Making change with standard coin denominations'
        ],
        correctIndex: 2,
        explanation: '0/1 Knapsack requires dynamic programming because greedy cannot determine globally optimal inclusion/exclusion combinations — you must consider all possible subsets, which greedy\'s myopic strategy cannot handle correctly.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Greedy Scheduling System',
      goal: 'Implement classic greedy algorithms and identify where greedy succeeds and fails.',
      steps: [
        'Implement activity_selection(activities) sorting by end time and picking non-overlapping activities',
        'Implement fractional_knapsack(items, capacity) sorting by value/weight ratio',
        'Implement make_change(amount, coins) using greedy and test it with both standard and unusual coin sets',
        'Demonstrate greedy failure: use coins [1,3,4] and target=6, showing greedy gives 3 coins but optimal is 2',
        'Implement a job_scheduling function that schedules jobs on a single machine to maximise total profit (each job has a deadline and profit)',
        'Print a summary table comparing greedy results vs brute-force optimal for the coin change counterexample',
      ],
      expectedOutput: 'Activity selection: [(1,4), (5,7), (8,11)] — 3 activities\nFractional knapsack (50kg): value=240\nMake change (67 cents, standard): 6 coins ✓\nMake change (6, coins=[1,3,4]): Greedy=3, Optimal=2 ← greedy FAILED',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l4_dynamic_programming',
    topicTitle: 'Dynamic Programming',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 40,
    totalXp: 250,
    emoji: '📐',
    intro: 'Dynamic programming (DP) is the technique that separates good engineers from great ones in interviews at FAANG companies. It transforms exponentially slow recursive solutions into polynomial-time ones by storing and reusing results of sub-problems instead of recomputing them. Every experienced interviewer considers DP fluency a strong signal of algorithmic maturity.',
    concepts: [
      ConceptLesson(
        title: 'What is Dynamic Programming?',
        definition: 'Dynamic programming solves problems by breaking them into overlapping sub-problems, solving each ONCE, and storing the result — avoiding the exponential recomputation that naive recursion causes.',
        analogy: 'DP is like a student who writes down the answer to every homework sub-problem as they solve it, so when the same sub-problem appears in the next question they look it up instantly instead of redoing all the work.',
        example: 'Fibonacci without DP: O(2^n)\nfib(5) calls fib(4) and fib(3)\nfib(4) calls fib(3) and fib(2) — fib(3) computed TWICE!\nfib(3) calls fib(2) and fib(1) — fib(2) computed THREE times!\n\nWith DP (store results): O(n)\nCompute fib(0), fib(1), fib(2)... each ONCE, store in a table.',
        keyTakeaway: 'DP applies when a problem has OVERLAPPING SUB-PROBLEMS (same sub-problems recur) and OPTIMAL SUBSTRUCTURE (optimal solution built from optimal solutions to sub-problems).',
      ),
      ConceptLesson(
        title: 'Top-Down DP: Memoisation',
        definition: 'Memoisation adds caching to a recursive function — if we have already computed the answer for a given input, return the cached result immediately instead of recomputing.',
        analogy: 'Memoisation is like a recursive researcher who writes each answer on a sticky note before returning it. The next time anyone asks the same question, they check the wall of sticky notes first before doing any new research.',
        example: 'def fib(n, memo={}):\n    if n in memo: return memo[n]\n    if n <= 1: return n\n    memo[n] = fib(n-1, memo) + fib(n-2, memo)\n    return memo[n]\n\n# Or with Python\'s built-in decorator:\nfrom functools import lru_cache\n@lru_cache(maxsize=None)\ndef fib(n):\n    if n <= 1: return n\n    return fib(n-1) + fib(n-2)',
        keyTakeaway: '@lru_cache (or @cache in Python 3.9+) is a one-line way to add memoisation to any pure recursive function — extremely useful in interviews and production code.',
      ),
      ConceptLesson(
        title: 'Bottom-Up DP: Tabulation',
        definition: 'Tabulation fills a DP table iteratively from the smallest sub-problems up to the original problem — no recursion, no stack overflow risk.',
        analogy: 'Bottom-up DP is like filling out a crossword puzzle starting with the short 3-letter words and using those to fill in progressively longer words — building up from simpler to complex.',
        example: 'def fib_table(n):\n    if n <= 1: return n\n    dp = [0] * (n + 1)\n    dp[0] = 0\n    dp[1] = 1\n    for i in range(2, n + 1):\n        dp[i] = dp[i-1] + dp[i-2]\n    return dp[n]\n\n# Even more memory-efficient (only need last 2 values):\ndef fib_optimal(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a + b\n    return a',
        keyTakeaway: 'Bottom-up DP avoids recursion entirely, eliminating stack overflow risk and often being faster in practice due to no function call overhead. When memory matters, identify if you only need the last k rows of the DP table.',
      ),
      ConceptLesson(
        title: 'Classic DP: 0/1 Knapsack',
        definition: 'Given n items with weights and values, and a knapsack of capacity W, find the maximum value achievable without exceeding the weight limit (each item is either included or excluded).',
        analogy: 'The knapsack problem is exactly like packing a suitcase for a strict weight-limit flight — each item is either in the suitcase (full value, full weight) or not. You want maximum total value without busting the weight limit.',
        example: 'def knapsack(weights, values, capacity):\n    n = len(weights)\n    dp = [[0]*(capacity+1) for _ in range(n+1)]\n    for i in range(1, n+1):\n        for w in range(capacity+1):\n            if weights[i-1] <= w:\n                dp[i][w] = max(dp[i-1][w],\n                               values[i-1] + dp[i-1][w-weights[i-1]])\n            else:\n                dp[i][w] = dp[i-1][w]\n    return dp[n][capacity]',
        keyTakeaway: 'The knapsack DP table entry dp[i][w] means "max value using items 1..i with capacity exactly w". The recurrence captures the binary choice: include item i or skip it.',
      ),
      ConceptLesson(
        title: 'Classic DP: Longest Common Subsequence (LCS)',
        definition: 'LCS finds the longest sequence of characters present in the same order (not necessarily contiguous) in both of two given strings.',
        analogy: 'LCS is like finding the longest storyline that appears in BOTH of two movie franchises — characters, events, and relationships must appear in the same order in both, even if separated by different scenes.',
        example: 'def lcs(s1, s2):\n    m, n = len(s1), len(s2)\n    dp = [[0]*(n+1) for _ in range(m+1)]\n    for i in range(1, m+1):\n        for j in range(1, n+1):\n            if s1[i-1] == s2[j-1]:\n                dp[i][j] = dp[i-1][j-1] + 1\n            else:\n                dp[i][j] = max(dp[i-1][j], dp[i][j-1])\n    return dp[m][n]\n\nprint(lcs("ABCBDAB", "BDCABA"))  # 4 (BCBA)',
        keyTakeaway: 'LCS is the algorithm behind diff tools (git diff), DNA sequence alignment in bioinformatics, and spell-checking. The recurrence is elegant: if characters match, extend; otherwise take the best of skipping one or the other.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What are the two key properties a problem must have for dynamic programming to apply?',
        options: [
          'Must be a sorting and searching problem',
          'Overlapping sub-problems and optimal substructure',
          'Must involve arrays and strings only',
          'Must have O(n²) brute force and require O(n) space'
        ],
        correctIndex: 1,
        explanation: 'DP applies when: (1) the same sub-problems recur multiple times (overlapping) so caching saves work, and (2) the optimal answer to the full problem can be built from optimal answers to sub-problems (optimal substructure).',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the difference between memoisation and tabulation?',
        options: [
          'They are identical approaches',
          'Memoisation is top-down (recursive with caching); tabulation is bottom-up (iterative table filling)',
          'Tabulation uses more memory',
          'Memoisation only works for Fibonacci'
        ],
        correctIndex: 1,
        explanation: 'Memoisation is recursive — it starts from the original problem and caches sub-problem results as they are encountered. Tabulation is iterative — it fills a table from the smallest sub-problem up to the original.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'In the 0/1 Knapsack problem, why can\'t we use greedy?',
        options: [
          'Greedy is faster and should always be used',
          'Items cannot be split, so the highest value/weight ratio item might not lead to the globally optimal subset',
          'Greedy only works when there are fewer than 10 items',
          'There is no difference; greedy gives the same result'
        ],
        correctIndex: 1,
        explanation: 'With 0/1 items, taking a high-ratio item uses capacity that might be better used by a combination of other items. Greedy cannot account for this — DP considers all combinations via its recurrence.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: '@lru_cache(maxsize=None)\ndef fib(n):\n    if n <= 1: return n\n    return fib(n-1) + fib(n-2)\n\nprint(fib(50))\n\nIs this fast enough? What does @lru_cache do here?',
        options: [
          'Still O(2^50) — @lru_cache does nothing useful',
          'O(n) — @lru_cache caches each result so each unique n is computed only once',
          'O(1) — it pre-computes all values',
          'It causes a stack overflow on n=50'
        ],
        correctIndex: 1,
        explanation: '@lru_cache memoises the function — the first call to fib(k) computes and caches the result; all future calls for the same k return instantly. This reduces fib(50) from 2^50 calls to exactly 50.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You are computing LCS of two strings of length 100. What is the time and space complexity of the standard DP solution?',
        options: [
          'O(n) time and O(1) space',
          'O(n²) time and O(n²) space for the full table',
          'O(2^n) time — must try all combinations',
          'O(n log n) time like merge sort'
        ],
        correctIndex: 1,
        explanation: 'The standard LCS DP fills an n×m table with one entry per character pair — O(n×m) = O(n²) time and O(n²) space. An optimised version needs only O(min(m,n)) space by only keeping the last 2 rows.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'DP Problem Collection',
      goal: 'Implement 4 classic DP problems using both memoisation and tabulation.',
      steps: [
        'Implement fib(n) using @lru_cache (memoisation) and dp-table (tabulation), verify they match',
        'Implement coin_change(coins, amount) returning the minimum number of coins using bottom-up DP',
        'Implement knapsack(weights, values, capacity) using the 2D DP table approach',
        'Implement lcs(s1, s2) returning the length of the longest common subsequence',
        'For each problem, write the recurrence relation as a comment',
        'Compare the naive recursive version vs DP version for fibonacci(35) to demonstrate the speed difference',
      ],
      expectedOutput: 'fib(35): 9227465\nMemo time: 0.0001s  Table time: 0.0001s  Naive time: 3.2s\ncoin_change([1,5,10,25], 67): 6 coins\nknapsack([2,3,4,5],[3,4,5,6], 5): 7\nlcs("ABCBDAB","BDCABA"): 4',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'sep_l4_backtracking',
    topicTitle: 'Backtracking',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 35,
    totalXp: 230,
    emoji: '↩️',
    intro: 'Backtracking is the art of "trying everything systematically, but only as needed." Sudoku solvers, N-Queens problems, generating all permutations, and maze solving all use backtracking. It is exhaustive search made efficient by pruning dead-end branches early.',
    concepts: [
      ConceptLesson(
        title: 'What is Backtracking?',
        definition: 'Backtracking is an algorithmic technique that builds a solution incrementally, abandoning ("backtracking from") a partial solution the moment it determines that this path cannot lead to a valid complete solution.',
        analogy: 'Backtracking is like navigating a maze with a pen — you draw your path as you go, and the instant you hit a dead end, you erase back to the last junction and try the next available path instead of starting over from scratch.',
        example: '# General backtracking template\ndef backtrack(state):\n    if is_solution(state):\n        record_solution(state)\n        return\n    for choice in get_choices(state):\n        if is_valid(choice, state):\n            make_choice(state, choice)\n            backtrack(state)  # recurse deeper\n            undo_choice(state, choice)  # BACKTRACK',
        keyTakeaway: 'The "undo_choice" step is what makes backtracking — without undoing, you accumulate invalid state across branches instead of cleanly exploring each path independently.',
      ),
      ConceptLesson(
        title: 'Generating All Permutations',
        definition: 'Generating all permutations of a list places each element in the current position and recursively generates permutations of the remaining elements.',
        analogy: 'Generating permutations is like seating n people at n chairs — for each chair, try each remaining person, seat them, fill the rest of the chairs with the remaining people, then unseat and try the next person.',
        example: 'def permutations(nums, current=[]):\n    if not nums:\n        print(current)\n        return\n    for i in range(len(nums)):\n        current.append(nums[i])\n        remaining = nums[:i] + nums[i+1:]\n        permutations(remaining, current)\n        current.pop()  # BACKTRACK — unseat this person\n\npermutations([1, 2, 3])\n# [1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,1,2], [3,2,1]',
        keyTakeaway: 'n! permutations exist for n elements — backtracking is the standard approach to generate all of them without missing any.',
      ),
      ConceptLesson(
        title: 'N-Queens Problem',
        definition: 'Place N queens on an N×N chessboard so no two queens attack each other (no shared row, column, or diagonal).',
        analogy: 'N-Queens is like placing N powerful executives in N offices so none can "see" each other through windows or corridors — the constraint is placement, not personality.',
        example: 'def solve_n_queens(n, row=0, cols=set(), diag1=set(), diag2=set(), board=[]):\n    if row == n:\n        print(board)\n        return\n    for col in range(n):\n        if col in cols or (row-col) in diag1 or (row+col) in diag2:\n            continue  # PRUNE — invalid placement\n        cols.add(col); diag1.add(row-col); diag2.add(row+col)\n        board.append(col)\n        solve_n_queens(n, row+1, cols, diag1, diag2, board)\n        cols.remove(col); diag1.remove(row-col); diag2.remove(row+col)\n        board.pop()  # BACKTRACK',
        keyTakeaway: 'The pruning (checking cols, diag1, diag2 sets before recursing) is what makes this efficient — we never recurse into positions we already know are invalid.',
      ),
      ConceptLesson(
        title: 'Sudoku Solver',
        definition: 'Sudoku solving via backtracking finds the next empty cell, tries digits 1-9, validates against row/column/box constraints, and backtracks when no digit works.',
        analogy: 'Backtracking sudoku is like a careful detective filling in suspects one at a time — if at any point the evidence contradicts itself, immediately undo the last guess and try the next possibility.',
        example: 'def solve_sudoku(board):\n    for i in range(9):\n        for j in range(9):\n            if board[i][j] == ".":\n                for c in "123456789":\n                    if is_valid_sudoku(board, i, j, c):\n                        board[i][j] = c\n                        if solve_sudoku(board): return True\n                        board[i][j] = "."  # BACKTRACK\n                return False  # no digit works — backtrack higher\n    return True  # all cells filled',
        keyTakeaway: 'Sudoku backtracking on its own is not fast enough for 16x16 or expert puzzles — real solvers add "constraint propagation" (eliminating candidates based on rules) before attempting backtracking.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the essential "undo" step in backtracking and why is it necessary?',
        options: [
          'It is optional — backtracking works fine without it',
          'It reverses the most recent choice so the state is clean for trying the next option',
          'It restarts the algorithm from the beginning',
          'It only applies to sudoku problems'
        ],
        correctIndex: 1,
        explanation: 'Without undoing, the partial state accumulated from one branch bleeds into the next branch, making it impossible to explore each path independently and correctly.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is "pruning" in backtracking?',
        options: [
          'Removing elements from an array',
          'Detecting early that a partial solution cannot lead to a valid complete solution and skipping that branch',
          'Sorting the choices before trying them',
          'A memory optimisation technique'
        ],
        correctIndex: 1,
        explanation: 'Pruning cuts off branches of the search tree early when they are already invalid — dramatically reducing the number of states explored compared to pure exhaustive search.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'How many permutations does a backtracking algorithm generate for a list of 4 elements?',
        options: ['4', '8', '16', '24'],
        correctIndex: 3,
        explanation: '4! = 4 × 3 × 2 × 1 = 24 permutations exist for 4 elements, and backtracking systematically generates all of them.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'In the N-Queens backtracking solution, what specifically does "pruning" mean?',
        options: [
          'Removing queens from the board after placing them',
          'Skipping column positions that share a row, column, or diagonal with an already-placed queen, before recursing',
          'Sorting columns before trying them',
          'Stopping after finding the first valid solution'
        ],
        correctIndex: 1,
        explanation: 'Before placing a queen at (row, col), we check if col, (row-col), or (row+col) are already "taken" by previously placed queens. If any are, we skip that column entirely without recursing deeper.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Without backtracking, solving a 9×9 Sudoku by pure brute force would try how many combinations in the worst case?',
        options: [
          '9 × 81 = 729',
          '9^81 — roughly 10^77 combinations',
          '81! combinations',
          'Exactly 81 combinations'
        ],
        correctIndex: 1,
        explanation: 'Each of the 81 cells could theoretically hold any of 9 digits — 9^81 ≈ 10^77 total combinations. Backtracking with pruning reduces this to a manageable number by eliminating invalid branches immediately.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Backtracking Problem Suite',
      goal: 'Implement 3 classic backtracking problems and measure how pruning improves performance.',
      steps: [
        'Implement permutations(nums) generating all permutations of a list using backtracking',
        'Implement subsets(nums) generating all possible subsets (power set) of a list',
        'Implement solve_n_queens(n) printing all valid N-Queens solutions for n=4 and n=8',
        'Count how many N-Queens solutions exist for n=8 (should be 92)',
        'For N-Queens: implement a version WITHOUT diagonal pruning and measure how many states it explores vs the pruned version',
        'Implement a basic sudoku solver for a given 9x9 board',
      ],
      expectedOutput: 'permutations([1,2,3]): 6 solutions\nsubsets([1,2,3]): 8 subsets\nN-Queens n=4: 2 solutions\nN-Queens n=8: 92 solutions\nN-Queens n=8 (no pruning): ~40x more states explored\nSudoku: solved ✓',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'sep_l4_graph_algorithms',
    topicTitle: 'Graph Algorithms',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 40,
    totalXp: 250,
    emoji: '🗺️',
    intro: 'This is where everything from Level 3 (Graphs) meets the algorithm design patterns from this level. Dijkstra\'s shortest path, topological sorting, and minimum spanning trees are algorithms that real GPS systems, package managers, and network infrastructure software run daily. Mastering these puts you in the top tier of software engineering candidates.',
    concepts: [
      ConceptLesson(
        title: 'Dijkstra\'s Shortest Path — O((V+E) log V)',
        definition: 'Dijkstra\'s algorithm finds the shortest path from a source node to all other nodes in a WEIGHTED graph with non-negative edge weights, using a priority queue (min-heap).',
        analogy: 'Dijkstra\'s is like a GPS that always expands to the closest unexplored location first — adding up distances as it goes, and updating estimated distances whenever a shorter route is found.',
        example: 'import heapq\n\ndef dijkstra(graph, start):\n    dist = {node: float("inf") for node in graph}\n    dist[start] = 0\n    heap = [(0, start)]\n    while heap:\n        d, u = heapq.heappop(heap)\n        if d > dist[u]: continue  # stale entry\n        for v, weight in graph[u]:\n            if dist[u] + weight < dist[v]:\n                dist[v] = dist[u] + weight\n                heapq.heappush(heap, (dist[v], v))\n    return dist',
        keyTakeaway: 'Dijkstra CANNOT handle negative edge weights — use Bellman-Ford for those. The priority queue ensures we always process the closest unfinished node, guaranteeing correctness.',
      ),
      ConceptLesson(
        title: 'Topological Sort (DAG Ordering)',
        definition: 'Topological sort of a Directed Acyclic Graph (DAG) produces a linear ordering of nodes such that every directed edge goes from "earlier" to "later" in the ordering — used for dependency resolution.',
        analogy: 'Topological sort is like ordering university courses by prerequisites — Calculus 1 before Calculus 2, Mathematics before Physics — so that every course comes after all courses it depends on.',
        example: '# Kahn\'s algorithm (BFS-based)\nfrom collections import deque\n\ndef topo_sort(graph):\n    in_degree = {u: 0 for u in graph}\n    for u in graph:\n        for v in graph[u]:\n            in_degree[v] += 1\n    queue = deque([u for u in in_degree if in_degree[u] == 0])\n    order = []\n    while queue:\n        u = queue.popleft()\n        order.append(u)\n        for v in graph[u]:\n            in_degree[v] -= 1\n            if in_degree[v] == 0:\n                queue.append(v)\n    return order if len(order) == len(graph) else []  # [] = cycle detected',
        keyTakeaway: 'If topological sort cannot complete (output smaller than total nodes), a cycle exists — this is how npm and pip detect circular dependency errors.',
      ),
      ConceptLesson(
        title: 'Minimum Spanning Tree — Kruskal\'s Algorithm',
        definition: 'A Minimum Spanning Tree (MST) connects all nodes with minimum total edge weight and no cycles. Kruskal\'s sorts edges by weight and greedily adds the cheapest edge that does not create a cycle.',
        analogy: 'Kruskal\'s is like building the cheapest road network connecting all cities — always build the cheapest available road as long as it does not create a loop (redundant route).',
        example: 'Kruskal\'s steps:\n1. Sort all edges by weight (ascending)\n2. For each edge (u,v,w):\n   If u and v are in DIFFERENT connected components:\n     Add this edge to MST\n     Merge the components (Union-Find)\n   Else: skip (would create a cycle)\n3. Stop when n-1 edges have been added',
        keyTakeaway: 'Kruskal\'s uses a Union-Find (Disjoint Set Union) data structure to efficiently check if adding an edge would create a cycle — the most important supporting data structure for MST algorithms.',
        codeSnippet: '# Union-Find for cycle detection in Kruskal\'s\nparent = {i: i for i in range(n)}\n\ndef find(x):\n    if parent[x] != x: parent[x] = find(parent[x])  # path compression\n    return parent[x]\n\ndef union(x, y):\n    px, py = find(x), find(y)\n    if px == py: return False  # cycle detected\n    parent[px] = py\n    return True',
      ),
      ConceptLesson(
        title: 'Bellman-Ford — Handles Negative Weights',
        definition: 'Bellman-Ford finds shortest paths from a source in O(V×E) time and handles NEGATIVE edge weights — also detecting negative cycles (cycles whose total weight is negative, making shortest path undefined).',
        analogy: 'Bellman-Ford is like a more thorough but slower GPS that checks every possible route a fixed number of times — catching cases where a "negative toll road" (negative edge) makes some routes cheaper than Dijkstra\'s would find.',
        example: 'def bellman_ford(graph, start, n):\n    dist = {i: float("inf") for i in range(n)}\n    dist[start] = 0\n    for _ in range(n - 1):  # relax all edges n-1 times\n        for u, v, w in graph:  # graph as list of (u,v,weight)\n            if dist[u] + w < dist[v]:\n                dist[v] = dist[u] + w\n    # One more pass to detect negative cycles\n    for u, v, w in graph:\n        if dist[u] + w < dist[v]:\n            return None  # negative cycle detected\n    return dist',
        keyTakeaway: 'Dijkstra fails with negative edges because it commits to "this is the shortest path" too early. Bellman-Ford\'s repeated relaxation correctly handles negative edges by reconsidering all edges multiple times.',
      ),
      ConceptLesson(
        title: 'Choosing the Right Graph Algorithm',
        definition: 'Different graph problems need different algorithms. Matching problem to algorithm is an essential skill for both interviews and real engineering.',
        analogy: 'Choosing a graph algorithm is like choosing a route-planning strategy: Dijkstra is a car GPS (fast, non-negative roads), Bellman-Ford is a thorough but slower planner (handles toll credits), Kruskal\'s is an infrastructure planner (minimum network cost).',
        example: 'Shortest path, no negative weights: Dijkstra O((V+E)logV)\nShortest path, negative weights: Bellman-Ford O(VE)\nAll-pairs shortest path: Floyd-Warshall O(V³)\nOrdering with dependencies: Topological Sort O(V+E)\nMinimum connection cost: Kruskal\'s/Prim\'s O(E log E)\nCycle detection: DFS with colour marking',
        keyTakeaway: 'In interviews, when given a graph problem, the first 3 questions are: directed or undirected? weighted or unweighted? can weights be negative? The answers immediately narrow down the right algorithm.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why can Dijkstra\'s algorithm NOT be used with negative edge weights?',
        options: [
          'Dijkstra\'s does not work on any weighted graphs',
          'Dijkstra\'s marks nodes as "settled" assuming the current path is shortest — negative edges can later provide a shorter path, violating this assumption',
          'Negative weights make priority queues crash',
          'Dijkstra\'s only works with integer weights'
        ],
        correctIndex: 1,
        explanation: 'Dijkstra\'s core assumption is that once a node is popped from the priority queue, its shortest distance is finalised. A negative edge from a later-processed node could provide a shorter path, breaking this assumption.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does topological sort detect if it cannot produce an ordering for all nodes?',
        options: [
          'A disconnected graph',
          'A cycle in the directed graph',
          'A missing edge',
          'A node with no children'
        ],
        correctIndex: 1,
        explanation: 'Topological sort is only defined for DAGs (Directed Acyclic Graphs). If a cycle exists, no valid linear ordering can place all nodes "before" their dependencies — topo sort detects this when it cannot process all nodes.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'In Kruskal\'s MST algorithm, why do we skip an edge if both endpoints are already in the same component?',
        options: [
          'It would create a duplicate node',
          'Adding it would create a cycle — the spanning tree must be acyclic',
          'Kruskal\'s only handles trees with one root',
          'The edge weight would be recalculated incorrectly'
        ],
        correctIndex: 1,
        explanation: 'If both nodes are already connected (in the same component), adding the edge between them creates a cycle — and a spanning TREE must be acyclic. Union-Find efficiently checks this.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A graph has these edges: A→B (weight 5), A→C (weight 2), C→B (weight 1). Dijkstra from A: what is shortest distance to B?',
        options: ['5 (direct path A→B)', '3 (via A→C→B: 2+1=3)', '7 (adding both paths)', '2'],
        correctIndex: 1,
        explanation: 'Direct A→B costs 5. The path A→C→B costs 2+1=3, which is shorter. Dijkstra discovers this by exploring C first (cost 2), then updating B\'s distance from infinity to 2+1=3.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'A dependency graph has: install A requires B, B requires C, C requires A. What does topological sort tell you?',
        options: [
          'Install order: A, B, C',
          'Install order: C, B, A',
          'A cycle exists — these dependencies can never be resolved',
          'Install A first (it has the most dependents)'
        ],
        correctIndex: 2,
        explanation: 'A→B→C→A is a cycle. Topological sort detects this by failing to produce an ordering for all 3 nodes — exactly how package managers like npm detect circular dependency errors.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Navigation & Dependency System',
      goal: 'Implement Dijkstra\'s shortest path, topological sort, and Kruskal\'s MST on practical problems.',
      steps: [
        'Build a weighted city graph and implement dijkstra(graph, start) finding shortest distances to all cities',
        'Print the shortest paths from one source city to all others',
        'Build a course prerequisite system and implement topo_sort(graph) to find a valid course ordering',
        'Detect and report if a circular dependency exists in the prerequisite graph',
        'Implement kruskal_mst(edges, n) finding the minimum cost to connect all cities using Union-Find',
        'Print MST edges and total cost, comparing to the total cost of all edges',
      ],
      expectedOutput: 'Dijkstra from Mumbai:\n  Delhi: 1400km   Agra: 1230km   Jaipur: 1070km\n\nValid course order: [Math, Physics, Chemistry, Biology]\nCircular dependency test: detected cycle → error reported\n\nMST total cost: 3200km (vs all edges: 8500km)',
      xpReward: 65,
    ),
  ),
];