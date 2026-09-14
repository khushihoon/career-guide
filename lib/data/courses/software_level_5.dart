// ══════════════════════════════════════════════════════════════════════
// lib/models/software_courses_level5.dart
// Software Engineering Learning Path — LEVEL 5: Object Oriented Programming
// ══════════════════════════════════════════════════════════════════════

import '../../models/course_content_data.dart'; 

const List<TopicCourse> softwareCoursesLevel5 = [

  TopicCourse(
    id: 'sep_l5_classes_objects',
    topicTitle: 'Classes & Objects',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 200,
    emoji: '🏗️',
    intro: 'Classes and objects are the foundation of Object-Oriented Programming — the paradigm behind Android, enterprise banking systems, game engines, and virtually every large software system ever built. Once you understand what a class truly IS and how objects relate to it, every advanced OOP concept clicks naturally.',
    concepts: [
      ConceptLesson(
        title: 'What is a Class?',
        definition: 'A class is a blueprint or template that defines a type of object — specifying what DATA (attributes) it holds and what BEHAVIOUR (methods) it can perform.',
        analogy: 'A class is like an architectural blueprint. The blueprint itself is not a building — it defines the structure. Every actual building constructed from it (each object) is real, independent, and holds its own state.',
        example: 'class BankAccount:\n    def __init__(self, owner, balance):\n        self.owner = owner\n        self.balance = balance\n\n    def deposit(self, amount):\n        self.balance += amount\n\n    def get_balance(self):\n        return self.balance',
        keyTakeaway: 'A class defines WHAT an object looks like and CAN DO. The actual objects are independent instances — changing one account\'s balance does not affect any other account.',
      ),
      ConceptLesson(
        title: 'What is an Object?',
        definition: 'An object is a specific instance created from a class — it has its own unique copy of the class\'s attributes and can invoke the class\'s methods.',
        analogy: 'If a class is a cookie cutter, an object is each individual cookie stamped out. Every cookie has the same shape (methods) but holds its own dough, its own icing, its own state.',
        example: 'account1 = BankAccount("Alice", 5000)\naccount2 = BankAccount("Bob", 3000)\n\naccount1.deposit(1000)\nprint(account1.get_balance())  # 6000\nprint(account2.get_balance())  # 3000 — unchanged',
        keyTakeaway: 'Objects are INDEPENDENT — modifying one object\'s state never affects another object of the same class. This independence is what makes classes safe to reuse at scale.',
      ),
      ConceptLesson(
        title: 'The __init__ Method (Constructor)',
        definition: '__init__ is a special method called automatically when an object is created. It initialises the object\'s attributes with values passed during creation.',
        analogy: '__init__ is like the registration form you fill out when you first join a gym — it sets up your initial profile (weight, name, membership type) at the moment of joining, not later.',
        example: 'class Student:\n    def __init__(self, name, age, grade):\n        self.name = name      # instance attribute\n        self.age = age\n        self.grade = grade\n        self.courses = []     # default attribute\n\ns = Student("Priya", 20, "A")\nprint(s.name)    # Priya\nprint(s.courses) # []',
        keyTakeaway: 'self refers to the specific object being created — it is how Python distinguishes "this object\'s name" from any other object\'s name. Never forget to pass self as the first parameter of instance methods.',
      ),
      ConceptLesson(
        title: 'Instance Attributes vs Class Attributes',
        definition: 'Instance attributes belong to EACH specific object and can differ between objects. Class attributes are shared by ALL objects of that class.',
        analogy: 'Instance attributes are like personal locker contents — different for every student. Class attributes are like the school name printed on every student\'s ID — the same for everyone in that school.',
        example: 'class Employee:\n    company = "TechCorp"     # CLASS attribute — shared\n\n    def __init__(self, name, salary):\n        self.name = name         # INSTANCE attribute — unique\n        self.salary = salary\n\ne1 = Employee("Alice", 90000)\ne2 = Employee("Bob", 75000)\nprint(e1.company)  # TechCorp\nprint(e2.company)  # TechCorp\nprint(e1.name)     # Alice\nprint(e2.name)     # Bob',
        keyTakeaway: 'Changing a class attribute affects ALL instances simultaneously. Changing an instance attribute affects only that one object. Understanding this distinction prevents a very common subtle bug.',
      ),
      ConceptLesson(
        title: 'Methods: Instance, Class, and Static',
        definition: 'Instance methods (def method(self)) operate on a specific object. Class methods (@classmethod, cls) operate on the class itself. Static methods (@staticmethod) are utility functions with no access to self or cls.',
        analogy: 'Instance method: a specific employee submitting their own expense report. Class method: the HR department generating a company-wide headcount report. Static method: a tax calculation utility that works on numbers alone, needing no knowledge of employees.',
        example: 'class Circle:\n    pi = 3.14159\n\n    def __init__(self, radius):\n        self.radius = radius\n\n    def area(self):                    # instance method\n        return Circle.pi * self.radius ** 2\n\n    @classmethod\n    def from_diameter(cls, diameter):  # class method — alternate constructor\n        return cls(diameter / 2)\n\n    @staticmethod\n    def is_valid_radius(r):            # static method — utility\n        return r > 0',
        keyTakeaway: '@classmethod is commonly used as an "alternate constructor" (e.g. create from diameter instead of radius). @staticmethod organises related utility functions inside a class namespace without needing object state.',
      ),
      ConceptLesson(
        title: 'The __str__ and __repr__ Methods',
        definition: '__str__ defines how an object is displayed when printed (user-friendly). __repr__ defines how it is shown in the interpreter (developer-friendly, should ideally be unambiguous).',
        analogy: '__str__ is the polished bio you put on LinkedIn — readable and friendly for external audiences. __repr__ is the detailed debug log entry — precise enough for a developer to reconstruct what they are looking at.',
        example: 'class Point:\n    def __init__(self, x, y):\n        self.x = x\n        self.y = y\n\n    def __str__(self):\n        return f"Point ({self.x}, {self.y})"\n\n    def __repr__(self):\n        return f"Point(x={self.x}, y={self.y})"\n\np = Point(3, 4)\nprint(p)       # Point (3, 4)  ← uses __str__\nprint(repr(p)) # Point(x=3, y=4) ← uses __repr__',
        keyTakeaway: 'Always implement at least __repr__ for any class you create — it makes debugging dramatically easier because objects display meaningfully instead of "<__main__.Point object at 0x7f...>".',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the relationship between a class and an object?',
        options: [
          'They are exactly the same thing',
          'A class is a blueprint; an object is a specific instance created from it',
          'An object is more powerful than a class',
          'A class can only create one object'
        ],
        correctIndex: 1,
        explanation: 'A class defines the structure and behaviour. An object is a concrete, independent instance built from that class — with its own unique attribute values.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does "self" refer to inside an instance method?',
        options: [
          'The class itself',
          'The specific object on which the method is being called',
          'The parent class',
          'The Python interpreter'
        ],
        correctIndex: 1,
        explanation: '"self" is a reference to the particular object instance calling the method — it distinguishes "this object\'s data" from any other object\'s data of the same class.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'If you change a CLASS attribute, what happens to all instances?',
        options: [
          'Only the first instance is affected',
          'No instances are affected — class attributes are read-only',
          'All instances that have not overridden it with an instance attribute see the new value',
          'Python raises an error'
        ],
        correctIndex: 2,
        explanation: 'Class attributes are shared — changing one changes what all instances see, unless a specific instance has set its own instance attribute of the same name (which would shadow the class attribute for that one object).',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'class Dog:\n    species = "Canis lupus"\n    def __init__(self, name):\n        self.name = name\n\nd1 = Dog("Rex")\nd2 = Dog("Luna")\nDog.species = "Canis familiaris"\nprint(d1.species)\nprint(d2.species)',
        options: [
          '"Canis lupus" for both — class attribute does not change after creation',
          '"Canis familiaris" for both — class attribute changed affects all instances',
          '"Canis lupus" for d1, "Canis familiaris" for d2',
          'An error is raised'
        ],
        correctIndex: 1,
        explanation: 'Changing the class attribute changes what ALL instances see (that have not overridden it). Both d1 and d2 print "Canis familiaris".',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Which method type should you use for a utility function that takes two numbers and returns their sum, but belongs logically inside a MathHelper class?',
        options: [
          'Instance method — always use self',
          'Class method — use cls',
          'Static method — no self or cls needed, just a utility',
          'A standalone function outside the class'
        ],
        correctIndex: 2,
        explanation: 'A utility that does not need any instance or class state is a static method (@staticmethod). It belongs inside the class for organisation but does not need self or cls.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Bank Account System',
      goal: 'Build a fully-featured BankAccount class demonstrating all class concepts covered.',
      steps: [
        'Create BankAccount class with instance attributes: owner, balance, account_number, and a transactions list',
        'Add class attribute: bank_name = "PyBank" and interest_rate = 0.05',
        'Implement deposit(amount), withdraw(amount) with validation (cannot overdraw), and get_statement() printing all transactions',
        'Implement @classmethod create_savings(cls, owner) that creates an account with a starting bonus of 500',
        'Implement @staticmethod validate_amount(amount) returning True if amount > 0',
        'Implement __str__ and __repr__ for clean display',
      ],
      expectedOutput: 'PyBank Account\nOwner: Alice | Balance: ₹6500\nTransactions: [+500 bonus, +6000 deposit, -1000 withdrawal]\nvalidate_amount(-50): False\nSavings account created via classmethod ✓',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l5_encapsulation',
    topicTitle: 'Encapsulation',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 28,
    totalXp: 195,
    emoji: '🔒',
    intro: 'Encapsulation is one of the four pillars of OOP — and the one that most directly prevents bugs in large codebases. By hiding internal state and controlling access through methods, you protect objects from being put into invalid states. Every well-designed class you will ever encounter in production code uses encapsulation deliberately.',
    concepts: [
      ConceptLesson(
        title: 'What is Encapsulation?',
        definition: 'Encapsulation bundles data (attributes) and the methods that operate on it together, while restricting direct external access to the internal state — forcing interaction through a defined interface.',
        analogy: 'A capsule medicine tablet is a perfect analogy — the active ingredients (data) are sealed inside, protected from contamination. You interact with the medicine through its defined interface (swallowing it), not by opening it and adding your own chemicals.',
        example: '# WITHOUT encapsulation — dangerous\nclass BadAccount:\n    def __init__(self):\n        self.balance = 0\n\nacc = BadAccount()\nacc.balance = -99999  # invalid! nothing stops this\n\n# WITH encapsulation — safe\nclass GoodAccount:\n    def __init__(self):\n        self.__balance = 0  # private\n\n    def deposit(self, amount):\n        if amount > 0:\n            self.__balance += amount  # controlled access',
        keyTakeaway: 'Encapsulation prevents objects from ending up in invalid states (like a negative bank balance) by forcing all modifications to go through methods that validate the change.',
      ),
      ConceptLesson(
        title: 'Access Modifiers in Python',
        definition: 'Python uses naming conventions to signal access levels: public (name), protected (_name — convention only), and private (__name — name-mangled by Python to prevent accidental external access).',
        analogy: 'Public is the front door — anyone can knock. Protected (_) is the staff entrance — colleagues know to use it carefully. Private (__) is the safe room — name-mangled so outsiders cannot even find the lock.',
        example: 'class Person:\n    def __init__(self, name, age, salary):\n        self.name = name          # public — freely accessible\n        self._age = age           # protected — use carefully\n        self.__salary = salary    # private — name-mangled\n\np = Person("Alice", 25, 90000)\nprint(p.name)       # Alice — fine\nprint(p._age)       # 25 — works but signals "be careful"\n# print(p.__salary) # AttributeError!\nprint(p._Person__salary)  # 90000 — mangled name (avoid this)',
        keyTakeaway: 'Python does not ENFORCE access modifiers like Java/C++ — it uses a convention-based "honour system". The __ prefix is the strongest signal: "this is internal, do not touch directly."',
      ),
      ConceptLesson(
        title: 'Getters and Setters',
        definition: 'Getters (accessors) return the value of a private attribute. Setters (mutators) validate and set its value. They provide controlled, validated access to internal state.',
        analogy: 'Getters and setters are like the front desk of a secure building — you cannot access the rooms directly, but the front desk (getter) can tell you the room number, and the key system (setter) validates your credentials before letting you in.',
        example: 'class Temperature:\n    def __init__(self, celsius):\n        self.__celsius = celsius\n\n    def get_celsius(self):\n        return self.__celsius\n\n    def set_celsius(self, value):\n        if value < -273.15:  # absolute zero\n            raise ValueError("Temperature below absolute zero!")\n        self.__celsius = value\n\nt = Temperature(25)\nt.set_celsius(100)\nprint(t.get_celsius())  # 100',
        keyTakeaway: 'Setters are where you enforce business rules. "Balance cannot be negative", "temperature cannot be below absolute zero", "username must be 3+ characters" — all go in setters.',
      ),
      ConceptLesson(
        title: 'Python Properties — The Pythonic Way',
        definition: 'Python\'s @property decorator creates getter/setter/deleter behaviour that looks like direct attribute access but runs method logic behind the scenes.',
        analogy: 'A @property is like a smart thermostat display — touching the display to read or change the temperature feels exactly like touching a simple dial, but internally it validates your input and controls a complex heating system.',
        example: 'class Temperature:\n    def __init__(self, celsius):\n        self._celsius = celsius\n\n    @property\n    def celsius(self):\n        return self._celsius\n\n    @celsius.setter\n    def celsius(self, value):\n        if value < -273.15:\n            raise ValueError("Below absolute zero!")\n        self._celsius = value\n\n    @property\n    def fahrenheit(self):\n        return self._celsius * 9/5 + 32\n\nt = Temperature(25)\nt.celsius = 100     # calls setter — looks like attribute access!\nprint(t.fahrenheit) # 212.0 — computed on demand',
        keyTakeaway: '@property is the Pythonic way to add validation and computation to attribute access without changing the calling code — you can upgrade a plain attribute to a property without breaking any existing code that uses it.',
      ),
      ConceptLesson(
        title: 'Why Encapsulation Matters at Scale',
        definition: 'In large codebases with many developers, encapsulation prevents accidental misuse, makes internal refactoring safe (callers use the interface, not internals), and enforces invariants automatically.',
        analogy: 'Encapsulation in a large team is like having a clearly signed "staff only" door in a busy restaurant — it prevents well-meaning customers from accidentally wandering into the kitchen and disrupting operations, without any need for guards watching every moment.',
        example: 'Without encapsulation: if a class exposes raw data, every caller that modifies it directly must also be updated if you change the internal representation.\n\nWith encapsulation: change the internal representation freely — as long as the public interface (getters/setters) returns the same results, zero callers break.',
        keyTakeaway: 'Encapsulation is the foundation of the "open/closed" principle in SOLID — you can change internals freely without breaking anything that depends on your class, as long as the interface stays stable.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the main purpose of encapsulation?',
        options: [
          'To make code run faster',
          'To bundle data and methods together while restricting direct access to protect internal state',
          'To allow multiple classes to share the same methods',
          'To convert one data type to another'
        ],
        correctIndex: 1,
        explanation: 'Encapsulation protects an object\'s internal state by requiring interaction through defined methods — preventing invalid states like a negative balance that would occur with unrestricted direct access.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'In Python, what does the double underscore prefix (__name) do to an attribute?',
        options: [
          'Makes it completely inaccessible even within the class',
          'Triggers name-mangling, making it harder to access from outside the class accidentally',
          'Makes it a class attribute instead of an instance attribute',
          'Deletes the attribute after first access'
        ],
        correctIndex: 1,
        explanation: 'Double underscore triggers Python\'s name mangling — __balance becomes _ClassName__balance. This prevents accidental access from subclasses or external code, while still being technically accessible if you know the mangled name.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the advantage of Python\'s @property decorator over explicit get/set methods?',
        options: [
          '@property runs faster than regular methods',
          'It provides getter/setter logic while keeping the caller\'s syntax looking like simple attribute access',
          '@property automatically validates all data types',
          'There is no real advantage'
        ],
        correctIndex: 1,
        explanation: '@property lets callers write obj.celsius = 100 (attribute-style) while internally running validation logic — giving the best of both worlds: clean syntax and controlled access.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'class Counter:\n    def __init__(self):\n        self.__count = 0\n\n    def increment(self):\n        self.__count += 1\n\n    def get_count(self):\n        return self.__count\n\nc = Counter()\nc.increment()\nc.increment()\nprint(c.get_count())\nprint(c.__count)',
        options: [
          '2, then 0',
          '2, then AttributeError — __count is name-mangled and inaccessible directly',
          '0, then 2',
          'Both print 2'
        ],
        correctIndex: 1,
        explanation: 'get_count() returns 2. c.__count raises AttributeError because __count is mangled to _Counter__count internally — you cannot access it as c.__count from outside the class.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You have a User class with a raw email attribute. You want to add validation (must contain "@") without changing how existing code accesses user.email. What is the best approach?',
        options: [
          'Rename the attribute to get_email() and set_email()',
          'Convert email to a @property with a setter that validates the "@" constraint',
          'Add a separate validate() method callers must call manually',
          'Make email a class attribute'
        ],
        correctIndex: 1,
        explanation: '@property lets you add validation behind the scenes while keeping user.email = "..." syntax intact — zero changes needed in any code that currently accesses the attribute.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Encapsulated User Profile System',
      goal: 'Build a User class demonstrating full encapsulation with validation, properties, and controlled access.',
      steps: [
        'Create a User class with private __username, __email, __age, and __password_hash attributes',
        'Implement @property and @setter for username (3-20 chars), email (must contain "@"), and age (0-120)',
        'Implement set_password(plain_text) that stores only a hash (use hash() for simplicity), never the plain text',
        'Implement check_password(plain_text) that verifies against the stored hash',
        'Implement a @property full_info that returns a safe summary (username, email) but never the password hash',
        'Demonstrate: try setting an invalid email/age and show the ValueError is raised with a clear message',
      ],
      expectedOutput: 'User created: Priya / priya@mail.com\nAge set to 22 ✓\nInvalid email "notvalid" → ValueError: must contain "@"\nInvalid age 150 → ValueError: age must be 0-120\ncheck_password("secret123"): True\ncheck_password("wrong"): False',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l5_inheritance',
    topicTitle: 'Inheritance',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 210,
    emoji: '🧬',
    intro: 'Inheritance lets you build on existing classes without rewriting them — the core idea of code reuse in OOP. Every Android Activity, every React Component, every Django Model uses inheritance. Understanding when to use it (and when NOT to) is what separates clean architecture from spaghetti code.',
    concepts: [
      ConceptLesson(
        title: 'What is Inheritance?',
        definition: 'Inheritance lets a child class (subclass) automatically acquire all the attributes and methods of a parent class (superclass), and then add or override what it needs.',
        analogy: 'Inheritance is like a smartphone inheriting from a phone — it automatically gets all phone capabilities (calling, texting) without rewriting them, and adds its own (apps, camera, touchscreen).',
        example: 'class Animal:\n    def __init__(self, name):\n        self.name = name\n\n    def speak(self):\n        return "Some sound"\n\n    def eat(self):\n        return f"{self.name} is eating"\n\nclass Dog(Animal):    # Dog INHERITS from Animal\n    def speak(self):  # OVERRIDES speak\n        return f"{self.name} says Woof!"\n\ndog = Dog("Rex")\nprint(dog.speak())  # Rex says Woof!  (overridden)\nprint(dog.eat())    # Rex is eating   (inherited)',
        keyTakeaway: 'Inheritance is an "is-a" relationship. A Dog IS AN Animal. A Cat IS AN Animal. Use it when this relationship is genuinely true — not just because two classes happen to share some code.',
      ),
      ConceptLesson(
        title: 'The super() Function',
        definition: 'super() gives access to the parent class\'s methods from within the child class — essential for extending (not completely replacing) the parent\'s __init__ or other methods.',
        analogy: 'super() is like a new employee calling the standard company onboarding process (parent __init__) and then adding their department-specific setup on top — instead of writing the entire onboarding from scratch.',
        example: 'class Animal:\n    def __init__(self, name, sound):\n        self.name = name\n        self.sound = sound\n\nclass Dog(Animal):\n    def __init__(self, name, breed):\n        super().__init__(name, "Woof")  # call parent first\n        self.breed = breed              # then add dog-specific\n\nrex = Dog("Rex", "Labrador")\nprint(rex.name)   # Rex\nprint(rex.sound)  # Woof\nprint(rex.breed)  # Labrador',
        keyTakeaway: 'ALWAYS call super().__init__() in a child\'s __init__ unless you have a specific reason not to. Forgetting it means the parent\'s setup code never runs, leaving the object in an incomplete state.',
      ),
      ConceptLesson(
        title: 'Method Overriding',
        definition: 'Method overriding lets a child class provide its own implementation of a method that is already defined in the parent — the child\'s version is called instead of the parent\'s.',
        analogy: 'Method overriding is like a franchised restaurant using the corporate recipe for most dishes (inherited methods) but creating their own regional speciality dish (overridden method) that replaces the standard one for that location.',
        example: 'class Shape:\n    def area(self):\n        raise NotImplementedError("Subclass must implement area()")\n\nclass Circle(Shape):\n    def __init__(self, radius):\n        self.radius = radius\n    def area(self):\n        return 3.14159 * self.radius ** 2\n\nclass Rectangle(Shape):\n    def __init__(self, w, h):\n        self.w = w; self.h = h\n    def area(self):\n        return self.w * self.h\n\nshapes = [Circle(5), Rectangle(4, 6)]\nfor s in shapes:\n    print(s.area())  # Each calls its own overridden version',
        keyTakeaway: 'Overriding a method to raise NotImplementedError in the parent is a common pattern for defining an interface — it forces all subclasses to provide their own implementation or crash clearly.',
      ),
      ConceptLesson(
        title: 'isinstance() and type() for Type Checking',
        definition: 'isinstance(obj, Class) returns True if obj is an instance of Class OR any subclass of it. type(obj) == Class returns True only for the exact class, not subclasses.',
        analogy: 'isinstance is like checking whether someone is an "employee" — a manager (subclass of Employee) IS an Employee. type() is like checking their exact job title — a manager is NOT type() Employee.',
        example: 'dog = Dog("Rex", "Lab")\n\nprint(isinstance(dog, Dog))     # True — is a Dog\nprint(isinstance(dog, Animal))  # True — Dog is a subclass of Animal\nprint(type(dog) == Dog)         # True\nprint(type(dog) == Animal)      # False — type() checks exact class',
        keyTakeaway: 'In production code, prefer isinstance() over type() == — it correctly handles subclasses and makes code more flexible as class hierarchies evolve.',
      ),
      ConceptLesson(
        title: 'Multiple Inheritance and MRO',
        definition: 'Python supports multiple inheritance (a class can inherit from multiple parents). The Method Resolution Order (MRO) determines which parent\'s method is used when multiple parents define the same method.',
        analogy: 'MRO is like deciding whose family recipe to use when a child has two parents who both make "grandma\'s lasagna" — Python follows a clear, left-to-right, depth-first rule (C3 linearisation) to always pick the same parent consistently.',
        example: 'class A:\n    def greet(self): return "Hello from A"\n\nclass B(A):\n    def greet(self): return "Hello from B"\n\nclass C(A):\n    def greet(self): return "Hello from C"\n\nclass D(B, C):  # inherits from BOTH B and C\n    pass\n\nprint(D().greet())   # "Hello from B" — B comes before C in MRO\nprint(D.__mro__)     # shows the resolution order',
        keyTakeaway: 'Multiple inheritance in Python follows the C3 linearisation algorithm — use D.__mro__ to see the exact resolution order. Avoid deep multiple inheritance unless necessary; it creates "diamond problems" that confuse readers.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does inheritance allow a child class to do automatically?',
        options: [
          'Create a copy of the parent class',
          'Acquire all parent attributes and methods without rewriting them, while adding or overriding what it needs',
          'Run faster than the parent class',
          'Access private attributes of the parent'
        ],
        correctIndex: 1,
        explanation: 'Inheritance gives the child class the full set of parent attributes and methods for free, while allowing it to selectively override or extend them.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the purpose of calling super().__init__() in a child class constructor?',
        options: [
          'It is optional — never necessary',
          'It runs the parent class\'s __init__ to properly set up the inherited portion of the object',
          'It prevents the child\'s __init__ from running',
          'It makes the child class identical to the parent'
        ],
        correctIndex: 1,
        explanation: 'Without super().__init__(), the parent\'s setup code never runs — attributes defined in the parent\'s __init__ won\'t exist on the child object, causing AttributeError on access.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the key difference between isinstance() and type() == for type checking?',
        options: [
          'isinstance is slower',
          'isinstance returns True for subclasses; type() == only returns True for the exact class',
          'type() works with multiple classes; isinstance does not',
          'There is no difference'
        ],
        correctIndex: 1,
        explanation: 'isinstance(dog, Animal) is True because Dog is a subclass of Animal. type(dog) == Animal is False because dog\'s exact class is Dog, not Animal. isinstance is almost always the right choice.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'class Vehicle:\n    def __init__(self, speed):\n        self.speed = speed\n    def describe(self):\n        return f"Speed: {self.speed}"\n\nclass Car(Vehicle):\n    def __init__(self, speed, brand):\n        super().__init__(speed)\n        self.brand = brand\n    def describe(self):\n        return f"{self.brand} — {super().describe()}"\n\nc = Car(120, "Toyota")\nprint(c.describe())',
        options: [
          '"Speed: 120"',
          '"Toyota — Speed: 120"',
          '"Toyota — 120"',
          'AttributeError'
        ],
        correctIndex: 1,
        explanation: 'Car.describe() builds "Toyota — " then calls super().describe() which returns "Speed: 120". Combined: "Toyota — Speed: 120".',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'When should you use inheritance vs composition?',
        options: [
          'Always use inheritance — it is faster',
          'Use inheritance for "is-a" relationships (Dog IS AN Animal). Use composition for "has-a" relationships (Car HAS AN Engine)',
          'Always use composition — inheritance is deprecated',
          'Use whichever requires less code'
        ],
        correctIndex: 1,
        explanation: '"Is-a" = inheritance. "Has-a" = composition. A Dog IS AN Animal (inherit). A Car HAS AN Engine (compose — store an Engine object as an attribute). This distinction prevents many OOP design mistakes.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Employee Management System with Inheritance',
      goal: 'Build a class hierarchy demonstrating inheritance, super(), overriding, and isinstance() correctly.',
      steps: [
        'Create base class Employee with __init__(name, base_salary) and methods get_pay() and describe()',
        'Create Manager(Employee) that adds a bonus attribute and overrides get_pay() = base_salary + bonus',
        'Create Engineer(Employee) that adds an hourly_rate and hours_worked, overrides get_pay() = base_salary + hourly_rate * hours_worked',
        'Create Director(Manager) that adds a stock_options value, overrides get_pay() = super().get_pay() + stock_options',
        'Create a payroll(employees) function that loops through a mixed list and calls get_pay() on each',
        'Use isinstance() to print "Director" / "Manager" / "Engineer" / "Employee" label for each person',
      ],
      expectedOutput: 'Payroll Report:\n[Director]  Alice: ₹2,50,000\n[Manager]   Bob:   ₹1,20,000\n[Engineer]  Carol: ₹95,000\n[Employee]  Dave:  ₹60,000\nTotal payroll: ₹5,25,000',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l5_polymorphism',
    topicTitle: 'Polymorphism',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 30,
    totalXp: 205,
    emoji: '🎭',
    intro: 'Polymorphism — "many forms" — is what lets you write code that works on ANY object that has the right interface, without caring about the exact type. It is the feature that makes plugin systems, payment processors, and game engines extensible without rewriting their core logic every time you add something new.',
    concepts: [
      ConceptLesson(
        title: 'What is Polymorphism?',
        definition: 'Polymorphism allows objects of different classes to be treated through the same interface — each responding to the same method call in its own appropriate way.',
        analogy: 'Press "play" on a music player, a video player, or a podcast app — the same button, the same word "play", but each app does something completely different internally. The caller never needs to know which specific player it is addressing.',
        example: 'class Cat:\n    def speak(self): return "Meow"\n\nclass Dog:\n    def speak(self): return "Woof"\n\nclass Duck:\n    def speak(self): return "Quack"\n\nanimals = [Cat(), Dog(), Duck()]\nfor animal in animals:\n    print(animal.speak())  # each calls its own version\n# Meow, Woof, Quack',
        keyTakeaway: 'The loop does not care what specific type each object is — it just calls speak() and trusts each object to do the right thing. This is polymorphism in its purest form.',
      ),
      ConceptLesson(
        title: 'Duck Typing in Python',
        definition: '"If it walks like a duck and quacks like a duck, it is a duck." Python does not require formal inheritance — any object with the right method can be used polymorphically.',
        analogy: 'Duck typing is like an international driving license — it says you can drive, regardless of which car manufacturer taught you. Python asks only "can this object do the thing?" not "is it officially certified as the right class?"',
        example: 'class FileLogger:\n    def log(self, msg): print(f"FILE: {msg}")\n\nclass DatabaseLogger:\n    def log(self, msg): print(f"DB: {msg}")\n\nclass ConsoleLogger:\n    def log(self, msg): print(f"CONSOLE: {msg}")\n\ndef process(logger):  # accepts ANY object with a .log() method\n    logger.log("Processing started")\n\nprocess(FileLogger())      # FILE: Processing started\nprocess(DatabaseLogger())  # DB: Processing started',
        keyTakeaway: 'Python\'s duck typing means polymorphism works without any shared base class — just having the right method is enough. This is more flexible than Java/C++ which require formal interface declarations.',
      ),
      ConceptLesson(
        title: 'Operator Overloading',
        definition: 'Operator overloading lets you define what +, -, *, ==, <, and other operators mean for your custom class by implementing special "dunder" methods (__add__, __eq__, etc.).',
        analogy: 'Operator overloading is like teaching a new language to know what "combine" means for new data types — in English "combine" means "add together" for numbers; for your Vector class you teach Python the same word means "add the x and y components".',
        example: 'class Vector:\n    def __init__(self, x, y):\n        self.x = x\n        self.y = y\n\n    def __add__(self, other):\n        return Vector(self.x + other.x, self.y + other.y)\n\n    def __eq__(self, other):\n        return self.x == other.x and self.y == other.y\n\n    def __str__(self):\n        return f"Vector({self.x}, {self.y})"\n\nv1 = Vector(1, 2)\nv2 = Vector(3, 4)\nprint(v1 + v2)  # Vector(4, 6) — uses __add__\nprint(v1 == v2) # False — uses __eq__',
        keyTakeaway: 'Python\'s numeric types, strings, and lists all use operator overloading internally — "hello" + " world" works because str.__add__ is defined. Implementing these for your own classes makes them feel like natural Python citizens.',
      ),
      ConceptLesson(
        title: 'Polymorphism with Abstract Base Classes',
        definition: 'Abstract Base Classes (ABCs) formally declare a set of methods that ALL subclasses MUST implement — combining polymorphism with compile-like enforcement of the interface contract.',
        analogy: 'An ABC is like a legal contract — you must implement all required methods before your class is "valid". Try to instantiate an incomplete implementation and Python raises a TypeError immediately, before any runtime surprises.',
        example: 'from abc import ABC, abstractmethod\n\nclass PaymentMethod(ABC):\n    @abstractmethod\n    def pay(self, amount): pass\n\n    @abstractmethod\n    def refund(self, amount): pass\n\nclass CreditCard(PaymentMethod):\n    def pay(self, amount):\n        return f"Charged ₹{amount} to credit card"\n    def refund(self, amount):\n        return f"Refunded ₹{amount} to credit card"\n\n# PaymentMethod()  # TypeError — cannot instantiate abstract class\ncard = CreditCard()  # fine — implements all abstract methods',
        keyTakeaway: 'ABCs catch missing implementations at the moment of instantiation rather than when the missing method is first called at runtime — often much later, in production.',
      ),
      ConceptLesson(
        title: 'Real-World Polymorphism: The Strategy Pattern',
        definition: 'The Strategy Pattern uses polymorphism to swap algorithms or behaviours at runtime — a classic design pattern that makes systems highly extensible.',
        analogy: 'The Strategy Pattern is like a GPS app that can switch between "fastest route", "shortest route", and "avoid tolls" — all use the same "calculate_route" interface but implement completely different algorithms internally.',
        example: 'class Sorter:\n    def sort(self, data): raise NotImplementedError\n\nclass BubbleSortStrategy(Sorter):\n    def sort(self, data): return bubble_sort(data)\n\nclass MergeSortStrategy(Sorter):\n    def sort(self, data): return merge_sort(data)\n\nclass DataProcessor:\n    def __init__(self, sorter: Sorter):\n        self.sorter = sorter\n\n    def process(self, data):\n        return self.sorter.sort(data)  # polymorphic call\n\nprocessor = DataProcessor(MergeSortStrategy())\nresult = processor.process([3,1,2])',
        keyTakeaway: 'The Strategy Pattern makes DataProcessor completely independent of sorting implementation — you can add QuickSortStrategy or RadixSortStrategy without changing DataProcessor at all.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does polymorphism allow you to do?',
        options: [
          'Make one class run multiple times',
          'Treat objects of different classes through the same interface, each responding in its own way',
          'Store multiple values in one variable',
          'Create classes without attributes'
        ],
        correctIndex: 1,
        explanation: 'Polymorphism lets the same code (e.g. a loop calling speak()) work correctly with any object that has that method — regardless of the specific class, without needing if/else type checks.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is "duck typing" in Python?',
        options: [
          'A typing module for duck-related data',
          'Python checks whether an object has the required method, not whether it is an officially declared subclass',
          'A strict type system requiring interface declarations',
          'An error that occurs when wrong types are used'
        ],
        correctIndex: 1,
        explanation: '"If it has the right method, it works" — Python\'s duck typing allows polymorphism without formal inheritance or interface declarations, purely based on whether the required methods exist.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What happens if you try to instantiate a class that inherits from ABC but doesn\'t implement all abstract methods?',
        options: [
          'Python silently ignores the missing methods',
          'A TypeError is raised immediately at instantiation',
          'The abstract methods return None by default',
          'The class is treated as an interface automatically'
        ],
        correctIndex: 1,
        explanation: 'Python raises TypeError the moment you try to instantiate an abstract class (or a subclass that hasn\'t implemented all abstract methods), catching the error far earlier than runtime method calls would.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'class Discount:\n    def apply(self, price): return price\n\nclass TenPercent(Discount):\n    def apply(self, price): return price * 0.9\n\nclass HalfPrice(Discount):\n    def apply(self, price): return price * 0.5\n\ndiscounts = [Discount(), TenPercent(), HalfPrice()]\nfor d in discounts:\n    print(d.apply(1000))',
        options: [
          '1000, 900, 500',
          '1000, 1000, 1000',
          '900, 900, 500',
          'TypeError'
        ],
        correctIndex: 0,
        explanation: 'Polymorphism at work: Discount.apply returns 1000 (no discount), TenPercent.apply returns 900 (10% off), HalfPrice.apply returns 500 (50% off). Each calls its own overridden version.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You add a new payment method "Cryptocurrency" to a system built with the Strategy/Polymorphism pattern. How many existing classes need to change?',
        options: [
          'All existing classes must be updated',
          'Zero — you just create CryptocurrencyPayment implementing the existing interface, and the rest of the system works without changes',
          'Only the main processing class changes',
          'The abstract base class must be rewritten'
        ],
        correctIndex: 1,
        explanation: 'This is the Open/Closed Principle in action — open for extension (add CryptocurrencyPayment), closed for modification (no existing class needs to change). Polymorphism makes this possible.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Polymorphic Notification System',
      goal: 'Build an extensible notification system using polymorphism, ABCs, and operator overloading.',
      steps: [
        'Create an abstract base class Notifier with abstract method send(recipient, message)',
        'Implement EmailNotifier, SMSNotifier, and PushNotifier — each with a send() printing in a different format',
        'Create a NotificationService that accepts a list of Notifiers and calls send() on each (polymorphic dispatch)',
        'Implement a Message class with __add__ (combine two messages) and __len__ (return character count)',
        'Add a __lt__ to Message to allow sorting by message length',
        'Test: create a mixed list of notifiers, send a combined message, sort a list of messages by length',
      ],
      expectedOutput: 'EMAIL to alice@mail.com: "Server alert: CPU at 95%"\nSMS to +91-9876543210: "Server alert: CPU at 95%"\nPUSH to device_id_42: "Server alert: CPU at 95%"\n\nCombined message length: 30 chars\nMessages sorted by length: ["Hi", "Hello there", "Server alert: CPU at 95%"]',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l5_abstraction',
    topicTitle: 'Abstraction',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 28,
    totalXp: 200,
    emoji: '🎨',
    intro: 'Abstraction is the art of hiding complexity behind simple interfaces. Every API you have ever called, every library you have ever used, every SDK you have ever integrated — they all work because abstraction lets you USE something powerful without needing to understand every detail of HOW it works internally.',
    concepts: [
      ConceptLesson(
        title: 'What is Abstraction?',
        definition: 'Abstraction means exposing only the ESSENTIAL features of an object or system while hiding complex implementation details — letting users interact with a simplified interface.',
        analogy: 'A car\'s steering wheel, pedals, and gear shift are an abstraction of thousands of mechanical components. You drive the car by interacting with the simple interface — you do not need to understand fuel injection, camshaft timing, or differential gear ratios.',
        example: '# Users of this class see only simple methods\nclass DatabaseConnection:\n    def connect(self, host, port): pass    # hides socket management\n    def query(self, sql): pass             # hides query parsing, caching\n    def disconnect(self): pass             # hides connection pool handling\n\n# The CALLER only needs to know: connect, query, disconnect\n# Not: connection pooling, retry logic, cursor management, encoding...',
        keyTakeaway: 'Abstraction is not about hiding information for security — it is about reducing cognitive load. Users of your class should not need to understand your implementation to use it correctly.',
      ),
      ConceptLesson(
        title: 'Abstract Classes vs Interfaces',
        definition: 'An abstract class can have both abstract methods (must be overridden) and concrete methods (can be used as-is). An interface (in Python, approximated via ABCs) declares only what methods must exist.',
        analogy: 'An abstract class is like a partially-filled-in form template — some sections are pre-filled (concrete methods) and some must be filled in (abstract methods). An interface is a blank checklist of what must be completed.',
        example: 'from abc import ABC, abstractmethod\n\nclass DataProcessor(ABC):\n    # Abstract — MUST be implemented by subclasses\n    @abstractmethod\n    def process(self, data): pass\n\n    # Concrete — provided, usable as-is\n    def validate(self, data):\n        return data is not None and len(data) > 0\n\n    def run(self, data):\n        if self.validate(data):\n            return self.process(data)  # calls subclass version',
        keyTakeaway: 'Abstract classes share code via concrete methods while still requiring subclasses to implement their unique behaviour. This is more powerful than a pure interface — it provides shared infrastructure.',
      ),
      ConceptLesson(
        title: 'Levels of Abstraction in Real Systems',
        definition: 'Real software is built in layers of abstraction — each layer hides the complexity of the one below and exposes a simpler interface to the one above.',
        analogy: 'You type on a keyboard (Layer 7), the OS reads keystrokes (Layer 6), the database driver converts them (Layer 5), SQL runs (Layer 4), the storage engine reads bytes (Layer 3), the file system manages sectors (Layer 2), and the physical disk spins (Layer 1). Each layer is blissfully ignorant of layers beyond its immediate neighbors.',
        example: 'Layer 5 — Your Code:   orders = Order.objects.filter(status="pending")\nLayer 4 — Django ORM:  converts to SQL: SELECT * FROM orders WHERE status=\'pending\'\nLayer 3 — PostgreSQL:  executes query, reads pages from disk\nLayer 2 — OS:          manages file I/O, disk buffers\nLayer 1 — Hardware:    physical disk read operations',
        keyTakeaway: 'Each layer of abstraction you add reduces complexity for the next layer up. The art is choosing where to draw abstraction boundaries so each layer is independently understandable and replaceable.',
      ),
      ConceptLesson(
        title: 'Abstraction vs Encapsulation — The Difference',
        definition: 'Encapsulation is about PROTECTING data (hiding implementation details to prevent misuse). Abstraction is about SIMPLIFYING interfaces (hiding complexity to reduce cognitive load).',
        analogy: 'Encapsulation is like a vault keeping things safe from tampering. Abstraction is like a lobby receptionist — they hide the building\'s complexity behind a simple "who are you here to see?" interface.',
        example: 'Encapsulation: __balance is private — prevents invalid states\n→ PROTECTION from misuse\n\nAbstraction: database.query(sql) hides connection pooling, retries, caching\n→ SIMPLIFICATION of complex internals\n\nA class can do both: private internals (encapsulation) behind simple methods (abstraction)',
        keyTakeaway: 'These concepts are complementary and often coexist, but they answer different questions. Encapsulation: "How do we prevent misuse?" Abstraction: "How do we reduce complexity for callers?"',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the primary goal of abstraction in software design?',
        options: [
          'To make code run faster',
          'To hide complex implementation details behind simple interfaces, reducing cognitive load for users of the code',
          'To protect data from being modified',
          'To enable multiple inheritance'
        ],
        correctIndex: 1,
        explanation: 'Abstraction reduces the knowledge a caller needs — they interact with a simple, clean interface without needing to understand the complex implementation behind it.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What can an abstract class have that a pure interface cannot?',
        options: [
          'Abstract methods',
          'Concrete (pre-implemented) methods that subclasses can inherit and use without overriding',
          'More than one abstract method',
          'Access to private attributes'
        ],
        correctIndex: 1,
        explanation: 'An abstract class can provide both abstract methods (must be overridden) and concrete methods (shared implementation that subclasses inherit). A pure interface only declares what must be implemented.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the key difference between abstraction and encapsulation?',
        options: [
          'They are the same concept',
          'Encapsulation protects data from misuse; abstraction simplifies complexity for callers',
          'Abstraction is faster than encapsulation',
          'Encapsulation only works with inheritance'
        ],
        correctIndex: 1,
        explanation: 'Encapsulation is about protection and controlling access to internal state. Abstraction is about presenting a simplified view of complex functionality. They complement each other.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'from abc import ABC, abstractmethod\nclass Shape(ABC):\n    @abstractmethod\n    def area(self): pass\n    def describe(self):\n        return f"I am a shape with area {self.area():.2f}"\n\nclass Square(Shape):\n    def __init__(self, side): self.side = side\n    def area(self): return self.side ** 2\n\nprint(Square(5).describe())',
        options: [
          'TypeError — cannot call describe on a subclass',
          '"I am a shape with area 25.00"',
          '"I am a shape with area 5.00"',
          'AttributeError'
        ],
        correctIndex: 1,
        explanation: 'Square implements area() returning 25. Shape.describe() is a concrete method that calls self.area() — which polymorphically calls Square\'s version. Result: "I am a shape with area 25.00".',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You are writing a StorageManager class that users will use to save files. Users should not need to know if files go to local disk, S3, or Google Drive. Which OOP concept most directly achieves this?',
        options: [
          'Encapsulation — hide the storage type in a private attribute',
          'Abstraction — expose a simple save(filename, data) interface, hiding which storage backend is used',
          'Inheritance — make StorageManager inherit from all backends',
          'Polymorphism — not needed here'
        ],
        correctIndex: 1,
        explanation: 'Abstraction gives callers a simple save() interface without exposing whether it writes to disk, S3, or Google Drive. The complexity is hidden behind the abstraction boundary.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Abstracted Storage System',
      goal: 'Build a layered storage abstraction where callers never know or care which backend is used.',
      steps: [
        'Create abstract class Storage(ABC) with abstract methods save(key, data), load(key), delete(key), and exists(key)',
        'Implement LocalStorage(Storage) using a Python dictionary to simulate local file storage',
        'Implement CacheStorage(Storage) simulating an in-memory cache with a max_size limit that evicts oldest entries',
        'Create class DataService that accepts any Storage object and provides high-level save_user() and load_user() methods',
        'Demonstrate swapping LocalStorage for CacheStorage in DataService without changing ANY code in DataService',
        'Add a concrete method list_all_keys() to the abstract Storage class using only the abstract exists() and a stored internal list',
      ],
      expectedOutput: 'DataService with LocalStorage:\n  Saved user Alice ✓\n  Loaded user Alice: {name: Alice, age: 25} ✓\n\nSwapped to CacheStorage (no DataService changes):\n  Saved user Bob ✓\n  Loaded user Bob: {name: Bob, age: 30} ✓\n  Cache evicted oldest entry after reaching max_size',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'sep_l5_solid_principles',
    topicTitle: 'SOLID Principles',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 40,
    totalXp: 245,
    emoji: '🏛️',
    intro: 'SOLID is the set of 5 principles that separate junior developers who write code from senior engineers who design systems. These principles — battle-tested over decades — prevent the most common causes of unmaintainable, brittle codebases. Every senior engineering interview at top companies tests your ability to recognise and fix SOLID violations.',
    concepts: [
      ConceptLesson(
        title: 'S — Single Responsibility Principle',
        definition: 'A class should have ONE reason to change — it should do one thing and do it well. Multiple unrelated responsibilities mean multiple reasons to change, and changes to one risk breaking the other.',
        analogy: 'A chef should cook, not also manage payroll. A payroll system should calculate pay, not also send marketing emails. Mixing responsibilities creates a class that is fragile, hard to test, and impossible to reuse independently.',
        example: '# VIOLATION — too many responsibilities\nclass UserManager:\n    def create_user(self): pass\n    def send_welcome_email(self): pass  # email concern\n    def save_to_database(self): pass    # storage concern\n    def generate_report(self): pass     # reporting concern\n\n# FIXED — single responsibilities\nclass UserService:\n    def create_user(self): pass\n\nclass EmailService:\n    def send_welcome_email(self): pass\n\nclass UserRepository:\n    def save(self): pass',
        keyTakeaway: 'A fast test for SRP: if describing your class requires the word "and" ("it manages users AND sends emails AND generates reports"), you probably have an SRP violation.',
      ),
      ConceptLesson(
        title: 'O — Open/Closed Principle',
        definition: 'Software entities should be OPEN for extension but CLOSED for modification. Add new behaviour by creating new classes, not by modifying existing working code.',
        analogy: 'A power strip is open for extension (you can add as many appliances as you want) but closed for modification (you never need to open the power strip itself to add a new appliance). New plugs, not new internal wiring.',
        example: '# VIOLATION — must modify existing code to add new shape\nclass AreaCalculator:\n    def area(self, shape):\n        if isinstance(shape, Circle): return 3.14 * shape.r**2\n        elif isinstance(shape, Square): return shape.side**2\n        # adding Triangle requires MODIFYING this class\n\n# FIXED — extend without modifying\nclass Shape:\n    def area(self): raise NotImplementedError\n\nclass Triangle(Shape):    # just ADD this class\n    def area(self): return 0.5 * self.base * self.height',
        keyTakeaway: 'The "if isinstance..." pattern in a method that handles multiple types is almost always an OCP violation — replace it with polymorphism and let each class handle its own logic.',
      ),
      ConceptLesson(
        title: 'L — Liskov Substitution Principle',
        definition: 'Anywhere you use a parent class, you must be able to substitute a subclass without breaking the program. Subclasses must honour the parent\'s contract — not weaken it.',
        analogy: 'If you can drive any "Vehicle", a "Car" should be substitutable without any surprises. But a "VehicleWithNoBrakes" that breaks when you press the brake pedal violates LSP — even though it IS a Vehicle technically.',
        example: '# VIOLATION — subclass breaks parent\'s contract\nclass Bird:\n    def fly(self): return "flying"\n\nclass Penguin(Bird):\n    def fly(self):\n        raise Exception("Penguins cannot fly!")  # breaks parent contract\n\n# FIXED — restructure the hierarchy\nclass Bird:\n    def eat(self): pass\n\nclass FlyingBird(Bird):\n    def fly(self): pass\n\nclass Penguin(Bird): pass  # no fly() — does not promise it',
        keyTakeaway: 'LSP violations are often found by asking: "Would code that works with the parent class BREAK if I passed in this subclass?" If yes, the inheritance hierarchy is wrong.',
      ),
      ConceptLesson(
        title: 'I — Interface Segregation Principle',
        definition: 'No class should be forced to implement methods it does not need. Split large interfaces into smaller, more specific ones — clients depend only on what they actually use.',
        analogy: 'A Swiss Army knife is "full featured" but terrible if you only ever use the scissors — you carry the weight of all other tools. ISP says: offer a scissors-only tool if that is all someone needs.',
        example: '# VIOLATION — forced to implement irrelevant methods\nclass MultifunctionPrinter:\n    def print(self): pass\n    def scan(self): pass\n    def fax(self): pass\n\nclass SimplePrinter(MultifunctionPrinter):\n    def print(self): pass\n    def scan(self): raise NotImplementedError  # forced — does not have scan\n    def fax(self): raise NotImplementedError   # forced — does not have fax\n\n# FIXED — segregated interfaces\nclass Printable:\n    def print(self): pass\n\nclass Scannable:\n    def scan(self): pass\n\nclass SimplePrinter(Printable): pass  # only what it needs',
        keyTakeaway: 'Watch for "raise NotImplementedError" scattered across subclasses that have to implement methods they do not need — that is the ISP violation signal.',
      ),
      ConceptLesson(
        title: 'D — Dependency Inversion Principle',
        definition: 'High-level modules should not depend on low-level modules. Both should depend on abstractions. Depend on interfaces (what), not concrete implementations (how).',
        analogy: 'A lamp should not be hardwired to a specific power plant — it plugs into a standard socket (abstraction). Power can come from coal, solar, or nuclear (concrete implementations). The lamp works regardless, because it depends on the socket standard, not the generator.',
        example: '# VIOLATION — high-level depends on specific low-level\nclass OrderService:\n    def __init__(self):\n        self.db = MySQLDatabase()  # hardwired to MySQL\n\n# FIXED — both depend on abstraction\nclass Database(ABC):\n    @abstractmethod\n    def save(self, data): pass\n\nclass OrderService:\n    def __init__(self, db: Database):  # inject any Database\n        self.db = db\n\nservice = OrderService(MySQLDatabase())\nservice = OrderService(PostgreSQLDatabase())  # swap freely',
        keyTakeaway: 'DIP enables dependency injection — passing dependencies in from outside rather than creating them internally. This makes testing trivially easy: inject a MockDatabase in tests instead of needing a real database.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A class manages users, sends emails, AND generates reports. Which SOLID principle does this violate?',
        options: [
          'Open/Closed Principle',
          'Single Responsibility Principle',
          'Liskov Substitution Principle',
          'Interface Segregation Principle'
        ],
        correctIndex: 1,
        explanation: 'SRP: a class should have only ONE reason to change. User management, email sending, and report generation are three independent concerns — three reasons to change — violating SRP.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'The best fix for an "if isinstance(shape, Circle)... elif isinstance(shape, Square)..." pattern is:',
        options: [
          'Add more elif branches as new shapes are needed',
          'Use polymorphism — each shape implements its own area() so the caller never needs type checks',
          'Delete the isinstance checks',
          'Make shape a string parameter instead'
        ],
        correctIndex: 1,
        explanation: 'The isinstance chain violates OCP — each new shape requires modifying existing code. Polymorphism (each shape has its own area() method) lets you add Triangle by just creating a new class, with zero changes to existing code.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the Dependency Inversion Principle primarily enable?',
        options: [
          'Faster code execution',
          'Dependency injection — swapping concrete implementations freely without changing high-level code, and easy testing with mocks',
          'Preventing all bugs automatically',
          'Making all methods static'
        ],
        correctIndex: 1,
        explanation: 'When high-level code depends on abstractions (not concrete classes), you can inject any concrete implementation — including test mocks — without changing the high-level code. This is the foundation of testable design.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'class Penguin(Bird):\n    def fly(self):\n        raise Exception("Cannot fly")\n\nWhich SOLID principle does this violate?',
        options: [
          'Single Responsibility',
          'Liskov Substitution Principle — Penguin cannot be substituted for Bird wherever Bird.fly() is expected',
          'Open/Closed',
          'Dependency Inversion'
        ],
        correctIndex: 1,
        explanation: 'LSP says subclasses must honour the parent\'s contract. If code expects a Bird and calls fly(), substituting a Penguin crashes it. The fix is to restructure: Penguin should inherit from Bird (not FlyingBird).',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'Which change makes a class most easily testable with a mock/fake dependency?',
        options: [
          'Making all methods static',
          'Injecting dependencies through the constructor (Dependency Inversion) so a mock can be passed in tests',
          'Using global variables',
          'Hard-coding the database connection inside the class'
        ],
        correctIndex: 1,
        explanation: 'If a class creates its own dependencies internally (MySQL = MySQLDatabase()), tests need a real MySQL database. If dependencies are injected, tests can pass a lightweight FakeDatabase object instead — dramatically simpler.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'SOLID Refactoring Exercise',
      goal: 'Identify and fix all 5 SOLID violations in a provided "bad" codebase.',
      steps: [
        'Start with a "bad" OrderProcessor class that: validates orders, saves to MySQL, sends emails, generates PDF receipts, and logs to a file — all in one class',
        'Extract OrderValidator (SRP: validation only)',
        'Extract OrderRepository with an abstract base — then MySQLRepository and InMemoryRepository implementations (OCP + DIP)',
        'Create Notifier abstract class with EmailNotifier and SMSNotifier (OCP + ISP)',
        'Restructure a "Vehicle" hierarchy so ElectricCar and FuelCar do not break any Vehicle method contracts (LSP)',
        'Demonstrate dependency injection: OrderProcessor now accepts any Validator, Repository, and Notifier via constructor',
      ],
      expectedOutput: 'BEFORE: 1 god class, 0 tests possible without real MySQL and SMTP\nAFTER:\n  OrderValidator: ✓ validates order\n  InMemoryRepository (injected): ✓ saves order\n  SMSNotifier (injected): ✓ sends notification\n  All 5 SOLID principles honoured ✓\n  OrderProcessor fully testable with mocks ✓',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'sep_l5_design_patterns',
    topicTitle: 'Design Patterns',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 40,
    totalXp: 250,
    emoji: '📐',
    intro: 'Design patterns are the vocabulary of senior software engineering. When an experienced engineer says "use a Factory here" or "that\'s a classic Observer pattern", they are referencing 30 years of accumulated wisdom about solving recurring design problems. Knowing the 10 most important patterns makes you significantly more effective in both interviews and production system design.',
    concepts: [
      ConceptLesson(
        title: 'What are Design Patterns?',
        definition: 'Design patterns are proven, reusable solutions to commonly occurring software design problems — categorised as Creational (how objects are created), Structural (how objects are composed), and Behavioural (how objects communicate).',
        analogy: 'Design patterns are like architectural blueprints for common building types — "school", "hospital", "shopping mall". You do not invent the floor plan from scratch each time; you adapt a proven blueprint to your specific situation.',
        example: 'Creational: Singleton, Factory, Abstract Factory, Builder, Prototype\nStructural: Adapter, Decorator, Facade, Proxy, Composite\nBehavioural: Observer, Strategy, Command, Iterator, Template Method\n\nYou will recognise these in frameworks: Django uses Template Method, React uses Observer, Python\'s logging uses Singleton.',
        keyTakeaway: 'Patterns are not copy-paste code — they are CONCEPTS and trade-offs. Knowing when to apply (and when NOT to apply) a pattern is the real skill.',
      ),
      ConceptLesson(
        title: 'Singleton Pattern',
        definition: 'Singleton ensures only ONE instance of a class ever exists — all code that asks for an instance gets the same one.',
        analogy: 'A Singleton is like a country\'s central bank — there is exactly one, and every bank in the country interacts with that same single institution. Creating a second central bank would break the system.',
        example: 'class Singleton:\n    _instance = None\n\n    def __new__(cls):\n        if cls._instance is None:\n            cls._instance = super().__new__(cls)\n        return cls._instance\n\na = Singleton()\nb = Singleton()\nprint(a is b)  # True — same object\n\n# Common uses: config manager, database connection pool, logger',
        keyTakeaway: 'Singleton is often overused and can make testing hard (shared state between tests). Use it only when truly ONE instance makes sense — like a global configuration or a connection pool.',
      ),
      ConceptLesson(
        title: 'Factory Pattern',
        definition: 'Factory provides a method for creating objects without specifying the exact class — the factory decides which subclass to instantiate based on the input.',
        analogy: 'A Factory is like a car dealership that builds the exact vehicle you describe ("family car with 7 seats") without you needing to know which assembly line or model number to order directly from the manufacturer.',
        example: 'class ShapeFactory:\n    @staticmethod\n    def create(shape_type, **kwargs):\n        if shape_type == "circle":\n            return Circle(kwargs["radius"])\n        elif shape_type == "rectangle":\n            return Rectangle(kwargs["width"], kwargs["height"])\n        elif shape_type == "triangle":\n            return Triangle(kwargs["base"], kwargs["height"])\n        raise ValueError(f"Unknown shape: {shape_type}")\n\nshape = ShapeFactory.create("circle", radius=5)\nprint(shape.area())  # caller never touches Circle() directly',
        keyTakeaway: 'Factory decouples the caller from the concrete class — the caller asks for "a shape" and the factory handles the rest. Adding a new shape type requires changing only the factory, not every caller.',
      ),
      ConceptLesson(
        title: 'Observer Pattern',
        definition: 'Observer defines a one-to-many dependency — when one object (Subject) changes state, all dependent objects (Observers) are automatically notified and updated.',
        analogy: 'Observer is like a YouTube subscription — subscribe once and get notified automatically whenever the channel uploads a video. The channel does not know or care who specifically is subscribed.',
        example: 'class EventSystem:\n    def __init__(self):\n        self._listeners = {}\n\n    def subscribe(self, event, listener):\n        self._listeners.setdefault(event, []).append(listener)\n\n    def publish(self, event, data=None):\n        for listener in self._listeners.get(event, []):\n            listener(data)\n\nevents = EventSystem()\nevents.subscribe("user_login", lambda d: print(f"Email: Welcome {d}!"))\nevents.subscribe("user_login", lambda d: print(f"Log: {d} logged in"))\nevents.publish("user_login", "Alice")',
        keyTakeaway: 'Observer decouples the Subject from its Observers — the Subject does not import or directly call any Observer. New Observers can be added with zero changes to the Subject.',
      ),
      ConceptLesson(
        title: 'Decorator Pattern (Structural)',
        definition: 'The Decorator pattern adds behaviour to objects DYNAMICALLY without changing their class — wrapping them in a sequence of decorator objects, each adding one layer of functionality.',
        analogy: 'Decorator is like customising a coffee order: start with espresso (base), add milk (decorator 1), add vanilla (decorator 2), add extra shot (decorator 3). Each addition wraps the previous without changing it.',
        example: 'class Coffee:\n    def cost(self): return 50\n    def description(self): return "Coffee"\n\nclass MilkDecorator:\n    def __init__(self, coffee): self._coffee = coffee\n    def cost(self): return self._coffee.cost() + 20\n    def description(self): return self._coffee.description() + ", Milk"\n\nclass VanillaDecorator:\n    def __init__(self, coffee): self._coffee = coffee\n    def cost(self): return self._coffee.cost() + 30\n    def description(self): return self._coffee.description() + ", Vanilla"\n\ncoffee = VanillaDecorator(MilkDecorator(Coffee()))\nprint(coffee.description())  # Coffee, Milk, Vanilla\nprint(coffee.cost())          # 100',
        keyTakeaway: 'Python\'s @decorator syntax is a language-level implementation of the Decorator pattern applied to functions. The structural Decorator pattern does the same for objects.',
      ),
      ConceptLesson(
        title: 'Builder Pattern',
        definition: 'Builder separates the construction of a complex object from its representation — lets you build objects step by step, especially when the object has many optional configuration parameters.',
        analogy: 'A Builder is like ordering a custom laptop: you specify RAM (step 1), storage (step 2), display (step 3), and click "build" at the end. Much cleaner than one enormous constructor call with 15 parameters in a fixed order.',
        example: 'class QueryBuilder:\n    def __init__(self):\n        self._table = ""\n        self._conditions = []\n        self._limit = None\n\n    def from_table(self, table):\n        self._table = table\n        return self  # enables chaining\n\n    def where(self, condition):\n        self._conditions.append(condition)\n        return self\n\n    def limit(self, n):\n        self._limit = n\n        return self\n\n    def build(self):\n        sql = f"SELECT * FROM {self._table}"\n        if self._conditions:\n            sql += " WHERE " + " AND ".join(self._conditions)\n        if self._limit:\n            sql += f" LIMIT {self._limit}"\n        return sql\n\nquery = QueryBuilder().from_table("users").where("age > 18").limit(10).build()',
        keyTakeaway: 'Builder with method chaining (each method returns self) produces extremely readable, self-documenting configuration code. SQLAlchemy, Django ORM QuerySets, and many testing frameworks use this pattern.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What problem does the Singleton pattern solve?',
        options: [
          'Allows multiple instances for parallel processing',
          'Ensures exactly one instance of a class exists globally and provides a single access point to it',
          'Creates objects without specifying their class',
          'Adds behaviour to objects without changing their class'
        ],
        correctIndex: 1,
        explanation: 'Singleton guarantees exactly one instance — useful for shared resources like configuration, logging, or connection pools where multiple instances would cause conflicts or waste.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What makes the Observer pattern valuable for extensibility?',
        options: [
          'It makes the Subject run faster',
          'New observers can be added without modifying the Subject — the Subject does not know who is listening',
          'It prevents all objects from communicating',
          'Observers must be created before the Subject'
        ],
        correctIndex: 1,
        explanation: 'The Subject only knows it should notify "whoever is subscribed" — adding a new Observer (like a new EmailService) requires zero changes to the Subject, making the system open for extension.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'When is the Builder pattern most appropriate?',
        options: [
          'When a class has exactly one attribute',
          'When constructing a complex object with many optional parameters, building it step by step',
          'When exactly one instance is needed',
          'When objects need to notify each other of changes'
        ],
        correctIndex: 1,
        explanation: 'Builder shines when an object has many configuration options (some required, some optional) — avoiding huge constructors with 15 parameters, making object creation readable and self-documenting.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'db1 = DatabaseConnectionPool()\ndb2 = DatabaseConnectionPool()\nprint(db1 is db2)\n\nFor this to print True, which pattern must DatabaseConnectionPool implement?',
        options: [
          'Factory Pattern',
          'Singleton Pattern',
          'Observer Pattern',
          'Builder Pattern'
        ],
        correctIndex: 1,
        explanation: 'db1 is db2 returns True only if both variables reference the exact same object. Only the Singleton pattern guarantees this — __new__ returns the same instance every time the class is "instantiated".',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt: 'You are building a report generator that currently creates PDF reports. Next month you will add Excel and HTML reports. Which pattern best handles this without modifying the existing report generation logic?',
        options: [
          'Singleton — only one report can exist at a time',
          'Factory — a ReportFactory creates the right report type based on the format requested',
          'Observer — all report types are notified simultaneously',
          'Decorator — wrap the PDF with Excel formatting'
        ],
        correctIndex: 1,
        explanation: 'A ReportFactory.create("pdf") / create("excel") / create("html") decouples the caller from specific report classes. Adding HTMLReport requires adding a new class and one line in the factory — no existing code changes.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'E-Commerce System Using 4 Design Patterns',
      goal: 'Build a mini e-commerce order system demonstrating Singleton, Factory, Observer, and Builder patterns together.',
      steps: [
        'Implement ConfigManager as a Singleton holding store config (currency, tax rate, name)',
        'Implement an OrderBuilder with methods for adding items, setting shipping, applying discounts — returning self for chaining, plus a build() that creates the final Order object',
        'Implement NotificationService as an Observer system — subscribe email, SMS, and logging observers to the "order_placed" event',
        'Implement PaymentFactory that creates the right payment processor (CreditCardProcessor, UPIProcessor, NetBankingProcessor) based on payment method string',
        'Wire everything: build an order with OrderBuilder, process payment via PaymentFactory, then trigger "order_placed" to notify all subscribers',
        'Verify ConfigManager is truly a singleton across multiple access points in the system',
      ],
      expectedOutput: 'Config: TechShop | Tax: 18% | Currency: INR (Singleton ✓)\n\nOrder built:\n  Items: [Laptop ₹55000, Mouse ₹800]\n  Shipping: Express\n  Discount: 10%\n  Total: ₹50,220\n\nPayment: UPI processed ✓ (Factory created UPIProcessor)\n\nOrder placed — observers notified:\n  EMAIL: Order #1001 confirmed for alice@mail.com\n  SMS: Order confirmed, track at...\n  LOG: [2026-06-19] Order #1001 placed',
      xpReward: 65,
    ),
  ),
];