// ══════════════════════════════════════════════════════════════════════
// lib/models/software_courses_level6.dart
// Software Engineering Learning Path — LEVEL 6: Databases
// ══════════════════════════════════════════════════════════════════════

import '../../models/course_content_data.dart';

const List<TopicCourse> softwareCoursesLevel6 = [
  TopicCourse(
    id: 'sep_l6_sql_fundamentals',
    topicTitle: 'SQL Fundamentals',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Easy',
    estimatedMinutes: 35,
    totalXp: 220,
    emoji: '🗄️',
    intro:
        'SQL — Structured Query Language — is spoken by every serious database in the world. MySQL, PostgreSQL, SQLite, Oracle, SQL Server all understand it. Whether you are building a web app, analyzing data, or designing a backend API, SQL is the skill you will reach for every single day. This course takes you from zero to writing real queries on real data.',
    concepts: [
      ConceptLesson(
        title: 'What is a Database and Why SQL?',
        definition:
            'A relational database organises data into tables (rows and columns), enforces relationships between tables, and uses SQL to insert, query, update, and delete data reliably at scale.',
        analogy:
            'A relational database is like an extremely well-organised Excel workbook — but one that can handle millions of rows, multiple related sheets, concurrent access by thousands of users, and guarantees that no data is lost even if the server crashes mid-write.',
        example:
            'Table: users\n+----+-------+-----+--------------------+\n| id | name  | age | email              |\n+----+-------+-----+--------------------+\n|  1 | Alice |  25 | alice@example.com  |\n|  2 | Bob   |  30 | bob@example.com    |\n|  3 | Carol |  22 | carol@example.com  |\n+----+-------+-----+--------------------+',
        keyTakeaway:
            'SQL is not just for DBAs — every backend developer writes SQL daily. Understanding SQL deeply separates engineers who can build scalable data layers from those who fight performance problems they do not understand.',
      ),
      ConceptLesson(
        title: 'SELECT — Querying Data',
        definition:
            'SELECT retrieves data from one or more tables. You specify WHAT columns to return, FROM which table, with optional WHERE filtering, ORDER BY sorting, and LIMIT on row count.',
        analogy:
            'SELECT is like asking a librarian: "Give me the title and author (columns) of all books (FROM table) published after 2020 (WHERE condition), sorted by author name (ORDER BY), but only the first 10 (LIMIT)."',
        example:
            '-- All columns, all rows\nSELECT * FROM users;\n\n-- Specific columns with filter\nSELECT name, email FROM users WHERE age > 25;\n\n-- Sort and limit\nSELECT name, age FROM users\nORDER BY age DESC\nLIMIT 5;\n\n-- Computed column\nSELECT name, age, age * 12 AS age_in_months FROM users;',
        keyTakeaway:
            'SELECT is the most used SQL statement. Master WHERE conditions (=, !=, >, <, BETWEEN, LIKE, IN, IS NULL) and you can answer almost any question about your data.',
        codeSnippet:
            '-- Find users with gmail addresses, sorted by name\nSELECT name, email\nFROM users\nWHERE email LIKE "%@gmail.com"\nORDER BY name ASC;',
      ),
      ConceptLesson(
        title: 'INSERT, UPDATE, DELETE',
        definition:
            'INSERT adds new rows. UPDATE modifies existing rows. DELETE removes rows. Together with SELECT, these four statements form the CRUD operations (Create, Read, Update, Delete) that power every application.',
        analogy:
            'INSERT is adding a new entry to an address book. UPDATE is crossing out an old phone number and writing the new one. DELETE is tearing out an entire page. SELECT is reading any entry.',
        example:
            '-- INSERT a new user\nINSERT INTO users (name, age, email)\nVALUES ("Dave", 28, "dave@example.com");\n\n-- UPDATE age for a specific user\nUPDATE users\nSET age = 29\nWHERE name = "Dave";\n\n-- DELETE a user (ALWAYS use WHERE!)\nDELETE FROM users\nWHERE id = 4;',
        keyTakeaway:
            'NEVER run UPDATE or DELETE without a WHERE clause in production — without it, you update or delete EVERY ROW in the table. Always test on a copy first, always back up before bulk changes.',
      ),
      ConceptLesson(
        title: 'Filtering with WHERE — Advanced Conditions',
        definition:
            'WHERE filters rows using conditions combined with AND, OR, NOT — with operators =, !=, >, <, BETWEEN, LIKE (pattern), IN (list), and IS NULL for missing values.',
        analogy:
            'WHERE conditions are like a search filter panel on a shopping website — you can combine "price between ₹500 and ₹2000 AND brand is Samsung OR Apple AND in stock is true" to get exactly the products you want.',
        example:
            '-- Multiple conditions\nSELECT * FROM products\nWHERE price BETWEEN 100 AND 500\n  AND category IN ("Electronics", "Accessories")\n  AND stock > 0;\n\n-- Pattern matching\nSELECT * FROM users\nWHERE name LIKE "A%";  -- names starting with A\n\n-- NULL check (cannot use = for NULL)\nSELECT * FROM orders\nWHERE delivered_at IS NULL;  -- undelivered orders',
        keyTakeaway:
            'IS NULL and IS NOT NULL are the correct way to check for missing values — "column = NULL" never works in SQL because NULL = NULL is itself NULL (not TRUE).',
      ),
      ConceptLesson(
        title: 'Aggregate Functions & GROUP BY',
        definition:
            'Aggregate functions (COUNT, SUM, AVG, MIN, MAX) compute a single result from multiple rows. GROUP BY splits rows into groups and applies aggregates per group.',
        analogy:
            'GROUP BY is like a pivot table in Excel — instead of seeing every individual sale, you see total sales PER region, or average order value PER customer, summarising many rows into one meaningful row per group.',
        example:
            '-- Count users per age group\nSELECT age, COUNT(*) AS user_count\nFROM users\nGROUP BY age\nORDER BY user_count DESC;\n\n-- Total and average order value per customer\nSELECT customer_id,\n       COUNT(*) AS total_orders,\n       SUM(amount) AS total_spent,\n       AVG(amount) AS avg_order\nFROM orders\nGROUP BY customer_id\nHAVING SUM(amount) > 10000;  -- HAVING filters GROUPS (not rows)',
        keyTakeaway:
            'HAVING filters AFTER grouping (on aggregate results). WHERE filters BEFORE grouping (on individual rows). Mixing them up is one of the most common SQL beginner errors.',
      ),
      ConceptLesson(
        title: 'Creating Tables — DDL',
        definition:
            'Data Definition Language (DDL) creates and modifies the database structure: CREATE TABLE defines columns and constraints, ALTER TABLE modifies existing structure, DROP TABLE removes it.',
        analogy:
            'DDL is like architecture — CREATE TABLE is drawing the blueprint for a room (its dimensions and features), ALTER TABLE is renovating it, and DROP TABLE is demolishing it entirely.',
        example:
            'CREATE TABLE products (\n    id          INTEGER PRIMARY KEY AUTOINCREMENT,\n    name        VARCHAR(100) NOT NULL,\n    price       DECIMAL(10, 2) NOT NULL,\n    category    VARCHAR(50),\n    stock       INTEGER DEFAULT 0,\n    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP\n);\n\n-- Add a column later\nALTER TABLE products ADD COLUMN description TEXT;\n\n-- Remove a table (irreversible!)\nDROP TABLE IF EXISTS old_products;',
        keyTakeaway:
            'PRIMARY KEY uniquely identifies every row. NOT NULL prevents missing values. DEFAULT sets a fallback value. These constraints are what enforce data quality at the database level, not just application level.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the correct way to check for NULL values in a WHERE clause?',
        options: [
          'WHERE column = NULL',
          'WHERE column IS NULL',
          'WHERE column == NULL',
          'WHERE NULL(column)'
        ],
        correctIndex: 1,
        explanation:
            'NULL represents unknown/missing — comparing with = returns NULL (not TRUE), so WHERE column = NULL never finds any rows. IS NULL is the correct operator for NULL checks.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the difference between WHERE and HAVING?',
        options: [
          'They are identical — use either one',
          'WHERE filters individual rows BEFORE grouping; HAVING filters groups AFTER aggregation',
          'HAVING is faster than WHERE',
          'WHERE only works with SELECT; HAVING works with all statements'
        ],
        correctIndex: 1,
        explanation:
            'WHERE is applied to rows before GROUP BY runs. HAVING is applied to the resulting groups after aggregation — you can use HAVING SUM(amount) > 1000 but not WHERE SUM(amount) > 1000.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What happens if you run DELETE FROM users without a WHERE clause?',
        options: [
          'Deletes nothing — WHERE is required',
          'Deletes only the first row',
          'Deletes ALL rows in the users table',
          'Drops the entire table'
        ],
        correctIndex: 2,
        explanation:
            'DELETE without WHERE removes every single row in the table — leaving an empty table structure. This is one of the most dangerous mistakes in SQL and is why production databases require careful access control.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Write a query to find the total revenue per product category, but only show categories with total revenue above ₹50,000, sorted highest first.',
        options: [
          'SELECT category, SUM(price) FROM orders WHERE SUM(price) > 50000 GROUP BY category',
          'SELECT category, SUM(revenue) AS total FROM orders GROUP BY category HAVING SUM(revenue) > 50000 ORDER BY total DESC',
          'SELECT category, total_revenue FROM orders HAVING revenue > 50000',
          'SELECT * FROM orders WHERE category_revenue > 50000'
        ],
        correctIndex: 1,
        explanation:
            'GROUP BY category groups the rows. SUM(revenue) aggregates per group. HAVING filters groups by aggregate result. ORDER BY total DESC sorts the output. WHERE cannot be used here because SUM is an aggregate.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You want all users whose name starts with "A" or ends with "n". Which WHERE clause is correct?',
        options: [
          'WHERE name = "A%" OR name = "%n"',
          'WHERE name LIKE "A%" OR name LIKE "%n"',
          'WHERE name STARTS "A" OR name ENDS "n"',
          'WHERE name IN ("A%", "%n")'
        ],
        correctIndex: 1,
        explanation:
            'LIKE uses % as a wildcard (matches any sequence of characters). "A%" matches names starting with A. "%n" matches names ending in n. IN does not support wildcards.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'E-Commerce Database Query Suite',
      goal:
          'Write a complete set of SQL queries to analyse an e-commerce database with users, products, and orders tables.',
      steps: [
        'CREATE tables: users (id, name, email, city), products (id, name, price, category, stock), orders (id, user_id, product_id, quantity, amount, created_at)',
        'INSERT at least 5 users, 8 products across 3 categories, and 10 orders',
        'SELECT the top 3 most expensive products per category using GROUP BY and ORDER BY',
        'Find all users who have placed more than 2 orders using GROUP BY and HAVING',
        'Calculate total revenue, average order value, and number of orders per month',
        'Find products with zero stock (IS NULL or stock = 0) and list them with their category',
      ],
      expectedOutput:
          'Top products by category:\n  Electronics: Laptop ₹55,000\n  Clothing: Jacket ₹3,500\n  Books: Programming Guide ₹850\n\nHigh-value customers: Alice (4 orders), Bob (3 orders)\nMonthly revenue: June ₹1,24,500 | May ₹89,200\nOut of stock: [Headphones, Running Shoes]',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'sep_l6_database_design',
    topicTitle: 'Database Design',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 35,
    totalXp: 225,
    emoji: '📐',
    intro:
        'Good database design is what separates a system that scales to millions of users from one that collapses under load. Bad schema design causes data inconsistencies, query performance nightmares, and refactoring costs that can sink entire projects. This course teaches you to design databases that are correct, efficient, and maintainable from the start.',
    concepts: [
      ConceptLesson(
        title: 'Entity-Relationship (ER) Modelling',
        definition:
            'ER modelling identifies the main entities (things) in a system, their attributes (properties), and the relationships between them — before writing a single line of SQL.',
        analogy:
            'ER modelling is like drawing a map of a city before building it — identifying the districts (entities), what makes each district unique (attributes), and which roads connect them (relationships). Building without the map leads to dead-end streets and traffic jams.',
        example:
            'For an online bookstore:\nEntities: Book, Author, Customer, Order\nAttributes:\n  Book: isbn (PK), title, price, year\n  Author: id (PK), name, country\n  Customer: id (PK), name, email, address\nRelationships:\n  Book WRITTEN_BY Author (many-to-many)\n  Customer PLACES Order (one-to-many)\n  Order CONTAINS Book (many-to-many)',
        keyTakeaway:
            'Always design your ER diagram BEFORE writing SQL. Discovering that you need a junction table for a many-to-many relationship AFTER building the system costs 10x more to fix than catching it in the design phase.',
      ),
      ConceptLesson(
        title: 'Primary Keys, Foreign Keys & Referential Integrity',
        definition:
            'A Primary Key uniquely identifies every row. A Foreign Key in one table references a Primary Key in another — enforcing referential integrity (no order can reference a non-existent customer).',
        analogy:
            'A Primary Key is like your Aadhaar number — uniquely yours. A Foreign Key is like writing your Aadhaar number on a bank account application — it links your account to YOUR specific identity record, and the bank verifies that ID actually exists before creating the account.',
        example:
            'CREATE TABLE orders (\n    id          INTEGER PRIMARY KEY,\n    customer_id INTEGER NOT NULL,\n    total       DECIMAL(10,2),\n    FOREIGN KEY (customer_id) REFERENCES customers(id)\n        ON DELETE RESTRICT    -- prevent deleting customers with orders\n        ON UPDATE CASCADE     -- update order\'s FK if customer id changes\n);\n\n-- This INSERT would FAIL — customer 999 does not exist\nINSERT INTO orders (customer_id, total)\nVALUES (999, 5000);  -- Referential integrity violation',
        keyTakeaway:
            'Foreign key constraints are enforced by the database, not your application — they catch bugs that application-level validation might miss, especially when data is modified directly in the database.',
      ),
      ConceptLesson(
        title: 'Relationships: 1-1, 1-N, and M-N',
        definition:
            'One-to-one (1:1): one row in A relates to exactly one in B. One-to-many (1:N): one row in A relates to many in B. Many-to-many (M:N): many rows in A relate to many in B — requires a junction table.',
        analogy:
            'One-to-one: each person has exactly one passport. One-to-many: one teacher teaches many students. Many-to-many: students enrol in many courses AND courses have many students — you need a separate enrolments table to represent this.',
        example:
            '-- 1:1 — user profile\nCREATE TABLE user_profiles (\n    user_id INTEGER PRIMARY KEY,\n    bio TEXT,\n    FOREIGN KEY (user_id) REFERENCES users(id)\n);\n\n-- 1:N — posts belong to one user\nCREATE TABLE posts (\n    id INTEGER PRIMARY KEY,\n    user_id INTEGER,\n    content TEXT,\n    FOREIGN KEY (user_id) REFERENCES users(id)\n);\n\n-- M:N — students enrol in courses\nCREATE TABLE enrolments (\n    student_id INTEGER,\n    course_id  INTEGER,\n    enrolled_at TIMESTAMP,\n    PRIMARY KEY (student_id, course_id),  -- composite PK\n    FOREIGN KEY (student_id) REFERENCES students(id),\n    FOREIGN KEY (course_id)  REFERENCES courses(id)\n);',
        keyTakeaway:
            'Every many-to-many relationship requires a junction (bridge) table — you cannot store M:N directly in either original table without data duplication or array-stuffing, both of which cause serious problems.',
      ),
      ConceptLesson(
        title: 'Choosing the Right Data Types',
        definition:
            'Choosing appropriate data types directly affects storage size, query performance, and data validity — using VARCHAR(255) for everything is a common beginner mistake.',
        analogy:
            'Data types are like choosing the right container for different groceries — you would not carry water in a paper bag (wrong type causes errors), nor would you use a 100-litre drum for 100ml of medicine (wasteful VARCHAR(255) for a 2-char country code).',
        example:
            '-- Good type choices\nCREATE TABLE products (\n    id          SERIAL PRIMARY KEY,          -- auto-incrementing integer\n    name        VARCHAR(100) NOT NULL,       -- bounded text\n    description TEXT,                        -- unbounded text\n    price       DECIMAL(10, 2) NOT NULL,     -- exact decimal for money\n    is_active   BOOLEAN DEFAULT TRUE,\n    created_at  TIMESTAMP WITH TIME ZONE,   -- always store timezone\n    category    VARCHAR(50),\n    weight_kg   NUMERIC(6, 3)               -- 3 decimal places\n);\n\n-- Common mistakes:\n-- price FLOAT  → floating-point errors: 19.99 stored as 19.9899999...\n-- age   VARCHAR → cannot do age > 18 comparison correctly',
        keyTakeaway:
            'NEVER use FLOAT for money — use DECIMAL/NUMERIC. Always store timestamps with timezone. Use appropriate string lengths. These choices are nearly impossible to change cheaply after production data exists.',
      ),
      ConceptLesson(
        title: 'Database Constraints',
        definition:
            'Constraints enforce data rules at the database level: NOT NULL (no missing values), UNIQUE (no duplicates), CHECK (custom validation), DEFAULT (fallback value), and PRIMARY KEY/FOREIGN KEY.',
        analogy:
            'Database constraints are like the physical properties built into forms — a form field labelled "Age" that only accepts numbers between 0 and 150, required to be filled in, with a default of 18. The form itself enforces these rules, not just the person reviewing it.',
        example:
            'CREATE TABLE users (\n    id       SERIAL PRIMARY KEY,\n    email    VARCHAR(255) UNIQUE NOT NULL,   -- no duplicate emails\n    age      INTEGER CHECK (age >= 0 AND age <= 150),\n    role     VARCHAR(20) DEFAULT "customer"\n              CHECK (role IN ("customer", "admin", "vendor")),\n    balance  DECIMAL(12,2) DEFAULT 0\n              CHECK (balance >= 0)            -- no negative balance\n);',
        keyTakeaway:
            'Constraints in the database are your last line of defence — even if application code has a bug and tries to insert negative balance, the database rejects it. Defence in depth.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What type of table is required to represent a many-to-many relationship in a relational database?',
        options: [
          'A view',
          'A junction (bridge) table that holds foreign keys to both related tables',
          'A stored procedure',
          'An additional column in either original table'
        ],
        correctIndex: 1,
        explanation:
            'A many-to-many relationship cannot be stored directly — you need a junction table with foreign keys to both tables, plus any attributes specific to the relationship (like enrolled_at for a student-course enrolment).',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why should you NEVER use FLOAT for storing monetary values?',
        options: [
          'FLOAT is too large for money values',
          'Floating-point representation causes tiny rounding errors that accumulate, making exact financial calculations incorrect',
          'FLOAT cannot store negative numbers',
          'Databases do not support FLOAT type'
        ],
        correctIndex: 1,
        explanation:
            'FLOAT uses binary floating-point, which cannot exactly represent most decimal fractions. 19.99 might be stored as 19.989999999... — small errors that compound across millions of financial transactions into significant discrepancies.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does ON DELETE CASCADE on a foreign key constraint mean?',
        options: [
          'Prevent deletion if referenced rows exist',
          'Automatically delete all referencing rows when the referenced row is deleted',
          'Set foreign key to NULL when referenced row is deleted',
          'Raise an error and do nothing'
        ],
        correctIndex: 1,
        explanation:
            'ON DELETE CASCADE means: if a parent row is deleted, all rows in the child table that reference it are also automatically deleted. Useful for order items when an order is deleted, but dangerous if used carelessly.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A student can enrol in many courses, and each course can have many students. You need to also store when they enrolled and their current grade. Where does the grade column go?',
        options: [
          'In the students table',
          'In the courses table',
          'In the junction table (enrolments), alongside enrolled_at',
          'Grade should be stored in both tables for redundancy'
        ],
        correctIndex: 2,
        explanation:
            'Grade is a property of the RELATIONSHIP between a specific student and a specific course — not of the student alone (different grades in different courses) or the course alone. It belongs in the junction table (enrolments).',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You design a users table with email VARCHAR(255). Later you realize two users signed up with the same email (a data quality bug). Which constraint would have prevented this at the database level?',
        options: [
          'NOT NULL',
          'CHECK (email LIKE "%@%")',
          'UNIQUE constraint on the email column',
          'DEFAULT constraint'
        ],
        correctIndex: 2,
        explanation:
            'A UNIQUE constraint prevents any two rows from having the same value in that column — the database would have rejected the second registration with the duplicate email, regardless of whether application code checked for it.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Hospital Management Database Design',
      goal:
          'Design and implement a normalized hospital database schema from an ER diagram.',
      steps: [
        'Draw an ER diagram identifying entities: Patient, Doctor, Department, Appointment, Prescription, Medicine',
        'Identify all relationships: Doctor belongs to Department (N:1), Patient has many Appointments (1:N), Appointment has many Prescriptions (1:N), Prescription includes many Medicines (M:N)',
        'CREATE all tables with appropriate data types, PRIMARY KEYs, FOREIGN KEYs, NOT NULL, UNIQUE, and CHECK constraints',
        'Insert sample data: 3 departments, 5 doctors, 10 patients, 15 appointments',
        'Write queries: find all upcoming appointments for a specific doctor, average wait time per department, most prescribed medicine',
        'Document the ON DELETE behaviour choice for each foreign key and justify it',
      ],
      expectedOutput:
          'Schema created: 7 tables with 18 constraints\nDr. Sharma\'s appointments this week: 8\nAverage wait time: Cardiology 12 min | Orthopedics 18 min\nMost prescribed: Paracetamol (47 prescriptions)\nAll foreign keys with documented ON DELETE behaviour ✓',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'sep_l6_normalization',
    topicTitle: 'Normalization',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 35,
    totalXp: 230,
    emoji: '📊',
    intro:
        'Normalization is the systematic process of organizing a database to eliminate redundancy and prevent update anomalies. It is the difference between a database that stays consistent as data changes versus one that slowly drifts into contradictions and data corruption. Every database design interview at serious companies tests normalization knowledge.',
    concepts: [
      ConceptLesson(
        title: 'Why Normalization Matters: Update Anomalies',
        definition:
            'Unnormalized tables cause three types of anomalies: insertion anomalies (cannot add data without unrelated data), deletion anomalies (deleting a row loses unrelated data), and update anomalies (updating one fact requires changing many rows).',
        analogy:
            'An unnormalized database is like a shared Google Doc where everyone writes their phone number next to every task they own — when someone changes their number, you must find and update it in 50 places, and missing even one creates contradictions.',
        example:
            '-- BAD: customer info repeated in every order row\norders_bad:\norder_id | customer_name | customer_email    | product | amount\n    1    | Alice         | alice@mail.com    | Laptop  | 55000\n    2    | Alice         | alice@mail.com    | Mouse   |  800\n    3    | Alice         | alice_new@mail.com| Monitor | 12000  -- EMAIL MISMATCH!\n\n-- Update anomaly: changing Alice\'s email requires finding every row\n-- Deletion anomaly: delete all Alice\'s orders → lose her contact details',
        keyTakeaway:
            'The core goal of normalization is: every fact should be stored EXACTLY ONCE. If you store the same fact in multiple places, it can become inconsistent — and inconsistent data is worse than no data.',
      ),
      ConceptLesson(
        title: 'First Normal Form (1NF)',
        definition:
            '1NF requires: each column holds atomic (indivisible) values, no repeating groups, and a primary key that uniquely identifies every row.',
        analogy:
            '1NF is like a proper spreadsheet where each cell holds exactly ONE value — not "Alice, Bob, Carol" in a single cell labelled "attendees". Split multiple values into separate rows.',
        example:
            '-- VIOLATES 1NF: multiple values in one cell\norders_bad:\nid | products          | amounts\n1  | "Laptop, Mouse"   | "55000, 800"\n\n-- SATISFIES 1NF: each cell is atomic\norder_items:\norder_id | product | amount\n    1    | Laptop  | 55000\n    1    | Mouse   |   800',
        keyTakeaway:
            'Storing comma-separated lists in a single column (like "tag1, tag2, tag3") is the most common 1NF violation in practice. It makes querying, filtering, and updating individual values very painful.',
      ),
      ConceptLesson(
        title: 'Second Normal Form (2NF)',
        definition:
            '2NF applies to tables with composite primary keys: every non-key column must depend on the ENTIRE primary key, not just part of it. No partial dependencies.',
        analogy:
            '2NF is like a billing form where each item listed depends entirely on both "your account number" AND "the specific invoice" — if a column only depends on your account number alone, it belongs on the account page, not on every invoice item.',
        example:
            '-- VIOLATES 2NF: student_name depends only on student_id, not on course_id\nenrolments_bad:\nstudent_id | course_id | student_name | course_name | grade\n\n-- FIXED: separate tables, each non-key depends on whole PK\nstudents: student_id (PK), student_name\ncourses:  course_id (PK), course_name\nenrolments: student_id + course_id (composite PK), grade',
        keyTakeaway:
            '2NF is only relevant when the primary key is composite (multiple columns). If every table has a single-column primary key (which is common good practice), 2NF is automatically satisfied.',
      ),
      ConceptLesson(
        title: 'Third Normal Form (3NF)',
        definition:
            '3NF requires no transitive dependencies — non-key columns must depend DIRECTLY on the primary key, not on other non-key columns.',
        analogy:
            '3NF is like an employee ID card: your department phone number should not be on YOUR card (because it depends on department, not on you). If you change departments, all copies of your card need updating — that is a transitive dependency.',
        example:
            '-- VIOLATES 3NF: zip_code → city (zip determines city, not customer_id)\ncustomers_bad:\ncustomer_id | name  | zip_code | city\n    1       | Alice | 110001   | Delhi\n    2       | Bob   | 110001   | Delhi   -- city repeated for same zip!\n    3       | Carol | 400001   | Mumbai\n\n-- FIXED: separate the transitive dependency\ncustomers: customer_id, name, zip_code\nzip_codes: zip_code (PK), city',
        keyTakeaway:
            'The test for 3NF: "Does column X depend on the primary key, or does it depend on some other non-key column?" If the latter, move X and its determinant to a separate table.',
      ),
      ConceptLesson(
        title: 'Denormalization — When to Break the Rules',
        definition:
            'Denormalization deliberately introduces redundancy to improve read performance — acceptable when normalized queries are too slow for the required throughput, and the redundancy cost is managed.',
        analogy:
            'Normalization is like a reference book that stores each fact once (efficient storage, slow to look up). Denormalization is like a quick-reference cheat sheet that repeats key facts (redundant, but instant lookup). The right choice depends on how often you read vs write.',
        example:
            '-- Normalized: requires JOIN to get product name in order summary\nSELECT o.id, p.name, oi.amount\nFROM orders o\nJOIN order_items oi ON o.id = oi.order_id\nJOIN products p ON oi.product_id = p.id;\n\n-- Denormalized: store product_name in order_items for speed\norder_items: id, order_id, product_id, product_name, amount\n-- Trade-off: faster reads, but must update product_name in order_items\n-- if the product is renamed (write complexity)',
        keyTakeaway:
            'Start fully normalized. Denormalize ONLY when you have measured a specific performance problem, understand the trade-offs, and have a plan for keeping redundant data consistent.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the core goal of database normalization?',
        options: [
          'Make queries run faster always',
          'Ensure every fact is stored exactly once, eliminating redundancy and preventing update anomalies',
          'Reduce the number of tables in the database',
          'Enforce password security'
        ],
        correctIndex: 1,
        explanation:
            'Normalization ensures each piece of information lives in exactly one place — eliminating the inconsistencies that arise when the same fact is stored in multiple locations and updated in only some of them.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Storing "tag1, tag2, tag3" as a comma-separated list in one database column violates which normal form?',
        options: [
          '2NF',
          '3NF',
          '1NF — values must be atomic (indivisible)',
          'No normal form — this is acceptable'
        ],
        correctIndex: 2,
        explanation:
            '1NF requires each column to hold atomic (single, indivisible) values. A comma-separated list contains multiple values in one cell, violating atomicity and making it impossible to query or update individual tags efficiently.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'When is denormalization a legitimate design choice?',
        options: [
          'Always — normalization should never be used in production',
          'When a specific, measured query performance problem exists and the redundancy trade-off is explicitly managed',
          'When the database has more than 5 tables',
          'Whenever joins are needed'
        ],
        correctIndex: 1,
        explanation:
            'Denormalization is a performance optimisation — valid only when you have identified a real bottleneck through measurement, understand the consistency trade-offs, and have a strategy for managing the redundant data.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'Table: orders(order_id, customer_id, customer_name, customer_email, product_id, product_name, quantity). Which normal form is violated and what is the fix?',
        options: [
          '1NF — atomic values needed',
          '2NF and 3NF — customer info depends only on customer_id; product_name depends only on product_id. Fix: separate customers, products, and orders tables',
          '3NF only — move product_name to a separate table',
          'No violation — this is acceptable'
        ],
        correctIndex: 1,
        explanation:
            'customer_name/email depend on customer_id (not the full PK — 2NF violation if composite PK). product_name depends on product_id (3NF violation — transitive dependency). Fix: separate customers and products tables, keep only IDs as foreign keys in orders.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'An e-commerce site shows product name on every order summary page, requiring a JOIN each time. With 10M requests/day, this JOIN is slow. What is the appropriate response?',
        options: [
          'Normalize further to eliminate the JOIN',
          'Measure first; if JOIN is genuinely the bottleneck, consider denormalizing by caching product_name in order_items, with a documented strategy for keeping it updated',
          'Delete the products table to remove the need for JOINs',
          'Switch to a NoSQL database immediately'
        ],
        correctIndex: 1,
        explanation:
            'Denormalization is a valid response to a measured performance problem — but only after confirming the JOIN is the actual bottleneck, and with an explicit plan for consistency (e.g. update product_name in order_items when a product is renamed).',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Normalization Refactoring Exercise',
      goal:
          'Take a heavily denormalized "god table" and normalize it to 3NF, identifying and fixing each violation.',
      steps: [
        'Start with: sales(id, date, salesperson_name, salesperson_email, salesperson_dept, dept_phone, customer_name, customer_city, zip_code, city_region, product_name, category, unit_price, quantity)',
        'Identify 1NF violations (none here, but document your check)',
        'Identify 2NF violations: which columns depend on only part of the primary key (if composite)?',
        'Identify 3NF violations: salesperson_email → salesperson_name? dept_phone → dept? zip_code → customer_city → city_region?',
        'Create normalised tables: salespeople, departments, customers, zip_codes, products, categories, sales (junction)',
        'Verify: update salesperson email in ONE place and confirm it reflects correctly everywhere without inconsistency',
      ],
      expectedOutput:
          'Original: 1 table, 14 columns, heavy redundancy\nNormalized: 7 tables\n  salespeople(id, name, email, dept_id)\n  departments(id, name, phone)\n  customers(id, name, zip_code)\n  zip_codes(code, city, region)\n  products(id, name, category_id, unit_price)\n  categories(id, name)\n  sales(id, date, salesperson_id, customer_id, product_id, quantity)\nUpdate anomaly test: PASS — email updated in 1 place ✓',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'sep_l6_joins',
    topicTitle: 'Joins',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 215,
    emoji: '🔗',
    intro:
        'Joins are the superpower of relational databases — they let you combine data from multiple tables in a single query, answering questions that no single table could answer alone. "Which customers have never placed an order?" "What products are in every order this month?" These questions require joins, and mastering them is what makes SQL truly powerful.',
    concepts: [
      ConceptLesson(
        title: 'INNER JOIN — Only Matching Rows',
        definition:
            'INNER JOIN returns only rows where the join condition matches in BOTH tables — rows with no match in either table are excluded.',
        analogy:
            'INNER JOIN is like a guest list that only includes people who both RSVP\'d AND actually showed up — neither group alone, only those present in both.',
        example:
            'SELECT customers.name, orders.amount, orders.created_at\nFROM customers\nINNER JOIN orders ON customers.id = orders.customer_id;\n\n-- Only customers who HAVE at least one order appear\n-- Customers with no orders are excluded\n-- Orders with invalid customer_id are excluded',
        keyTakeaway:
            'INNER JOIN is the most used join — it implicitly filters to only meaningful matching rows. Use it when you only want rows that have a corresponding record in both tables.',
        codeSnippet:
            '-- Join 3 tables\nSELECT c.name, p.name AS product, oi.quantity\nFROM customers c\nINNER JOIN orders o ON c.id = o.customer_id\nINNER JOIN order_items oi ON o.id = oi.order_id\nINNER JOIN products p ON oi.product_id = p.id;',
      ),
      ConceptLesson(
        title: 'LEFT JOIN — All Left, Matching Right',
        definition:
            'LEFT JOIN returns ALL rows from the LEFT table, and matching rows from the right table — non-matching right rows show as NULL.',
        analogy:
            'LEFT JOIN is like a school attendance register showing ALL enrolled students, with their test score if they took the test, and NULL in the score column if they were absent.',
        example:
            '-- All customers, even those with no orders\nSELECT c.name, COUNT(o.id) AS order_count\nFROM customers c\nLEFT JOIN orders o ON c.id = o.customer_id\nGROUP BY c.id, c.name;\n\n-- Customers with no orders will show order_count = 0\n\n-- Find customers who have NEVER ordered (NULL trick)\nSELECT c.name\nFROM customers c\nLEFT JOIN orders o ON c.id = o.customer_id\nWHERE o.id IS NULL;  -- no matching order exists',
        keyTakeaway:
            'The "LEFT JOIN ... WHERE right.column IS NULL" pattern is the standard way to find rows in one table that have NO corresponding record in another — one of the most useful query patterns.',
      ),
      ConceptLesson(
        title: 'RIGHT JOIN & FULL OUTER JOIN',
        definition:
            'RIGHT JOIN returns all rows from the RIGHT table with matching left rows (NULL where no match). FULL OUTER JOIN returns all rows from BOTH tables, with NULLs where no match exists on either side.',
        analogy:
            'FULL OUTER JOIN is like a complete attendance comparison showing ALL employees from both the "attended" list and the "registered" list — with gaps marked wherever someone appears on one list but not the other.',
        example:
            '-- All products, whether or not they appear in any order\nSELECT p.name, COUNT(oi.id) AS times_ordered\nFROM products p\nLEFT JOIN order_items oi ON p.id = oi.product_id\nGROUP BY p.id, p.name;\n\n-- FULL OUTER JOIN (not supported in MySQL but in PostgreSQL/SQLite)\nSELECT c.name, o.id\nFROM customers c\nFULL OUTER JOIN orders o ON c.id = o.customer_id;',
        keyTakeaway:
            'RIGHT JOIN is rare in practice — you can always rewrite a RIGHT JOIN as a LEFT JOIN by swapping the table order. FULL OUTER JOIN is useful for finding ALL unmatched rows in both directions simultaneously.',
      ),
      ConceptLesson(
        title: 'Self JOIN — Joining a Table to Itself',
        definition:
            'A self join joins a table to itself, using aliases to distinguish the two "copies" — useful for hierarchical data (manager-employee) or comparing rows within the same table.',
        analogy:
            'A self join is like having a conversation between two photocopies of the same org chart — one represents "employees", the other represents "their managers", even though they come from the same employee table.',
        example:
            '-- Find each employee and their manager\'s name\nSELECT e.name AS employee, m.name AS manager\nFROM employees e\nLEFT JOIN employees m ON e.manager_id = m.id;\n\n-- Find pairs of products in the same category\nSELECT a.name, b.name, a.category\nFROM products a\nJOIN products b ON a.category = b.category\n                AND a.id < b.id;  -- avoid duplicate pairs',
        keyTakeaway:
            'Self joins are essential for hierarchical data (organisational charts, category trees, bill of materials) stored in a single table where a foreign key references the same table.',
      ),
      ConceptLesson(
        title: 'JOIN Performance: Understanding Execution',
        definition:
            'Joins on large tables can be slow without proper indexes. The database builds an intermediate result set for each join — understanding this helps you write more efficient queries.',
        analogy:
            'A join without an index is like searching for matching receipts between two shoe boxes of unsorted paper — you must compare every receipt in box 1 against every receipt in box 2. An index is like having both boxes sorted alphabetically — matching is vastly faster.',
        example:
            '-- This query on large tables is slow without the right index:\nSELECT * FROM orders o\nJOIN customers c ON c.id = o.customer_id\nWHERE c.city = "Mumbai";\n\n-- Solution: index on orders.customer_id AND customers.city\nCREATE INDEX idx_orders_customer ON orders(customer_id);\nCREATE INDEX idx_customers_city ON customers(city);\n\n-- After indexing: same query runs in milliseconds instead of seconds',
        keyTakeaway:
            'Always index foreign key columns and any column used in a JOIN condition. Unindexed joins on tables with millions of rows are one of the most common causes of production performance incidents.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What is the result of an INNER JOIN when a row in the left table has no matching row in the right table?',
        options: [
          'The left row appears with NULL values for right columns',
          'The left row is excluded from the result entirely',
          'An error is raised',
          'The right table\'s first row is used instead'
        ],
        correctIndex: 1,
        explanation:
            'INNER JOIN only returns rows where the join condition matches in BOTH tables. If a customer has no orders, they will not appear in an INNER JOIN between customers and orders.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'How do you find all customers who have NEVER placed an order using a JOIN?',
        options: [
          'INNER JOIN orders and filter WHERE orders.amount = 0',
          'LEFT JOIN orders ON customer_id, then WHERE orders.id IS NULL',
          'RIGHT JOIN customers and filter WHERE customers.id IS NULL',
          'Use COUNT(*) = 0 with GROUP BY'
        ],
        correctIndex: 1,
        explanation:
            'LEFT JOIN keeps all customers. Customers with no orders will have NULL in the orders columns. WHERE orders.id IS NULL filters to only those "unmatched" customers — the classic "find rows with no corresponding record" pattern.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why do JOIN operations become slow on large tables without proper indexes?',
        options: [
          'SQL does not support joins on large tables',
          'Without indexes, the database must compare every row in one table against every row in the other — a full table scan for each join',
          'JOINs are inherently slow regardless of indexes',
          'Large tables must be split before they can be joined'
        ],
        correctIndex: 1,
        explanation:
            'Without indexes on join columns, the database performs a nested loop comparing all rows — O(n×m) comparisons for two tables of sizes n and m. Indexes reduce this dramatically by enabling direct lookup.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'SELECT p.name, COUNT(oi.id) AS sales_count\nFROM products p\nLEFT JOIN order_items oi ON p.id = oi.product_id\nGROUP BY p.id, p.name\nORDER BY sales_count;\n\nWhat does this query return for a product that has never been ordered?',
        options: [
          'The product is excluded from results',
          'The product appears with sales_count = 0',
          'An error: cannot count NULL values',
          'sales_count shows NULL for that product'
        ],
        correctIndex: 1,
        explanation:
            'LEFT JOIN keeps all products. For products with no matching order_items, the oi.id values are NULL. COUNT(oi.id) counts non-NULL values only — so it returns 0 for products with no orders.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You have an employees table where manager_id is a foreign key to the same table. To get "employee name → manager name", which join type do you need?',
        options: [
          'INNER JOIN between employees and a separate managers table',
          'A self join: JOIN employees e ON employees.manager_id = e.id',
          'A CROSS JOIN of employees with itself',
          'A subquery — self joins are not valid SQL'
        ],
        correctIndex: 1,
        explanation:
            'A self join joins the employees table to itself using different aliases — one alias represents "the employee", the other represents "their manager". This is the standard approach for hierarchical data in a single table.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Sales Analytics Dashboard Queries',
      goal:
          'Write complex multi-table JOIN queries to power a real sales analytics dashboard.',
      steps: [
        'Set up tables: customers, orders, order_items, products, categories, salespeople',
        'Write INNER JOIN: list all orders with customer name, product name, quantity, and total amount',
        'Write LEFT JOIN: show all customers with their total order value (0 for customers who never ordered)',
        'Write LEFT JOIN with IS NULL: find all products that have never been ordered',
        'Write SELF JOIN on employees: show each employee with their manager\'s name',
        'Write a complex query joining 4 tables: top 5 salesperson performance by total revenue this month',
      ],
      expectedOutput:
          'All orders with details: 15 rows (inner join)\nCustomer order totals: 10 rows (includes 2 with ₹0 — never ordered)\nProducts never ordered: [Keyboard Stand, Screen Wipe] (left join IS NULL)\nEmployee → Manager: Alice → Director Patel, Bob → Alice...\nTop salespeople: [Rahul ₹2.1L, Priya ₹1.8L, ...]',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'sep_l6_indexing',
    topicTitle: 'Indexing',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 32,
    totalXp: 225,
    emoji: '⚡',
    intro:
        'A query that takes 30 seconds on an unindexed table can take 3 milliseconds with the right index — a 10,000x difference. Indexing is the single most impactful performance tool available to a database developer. Understanding when and how to add indexes (and what they cost) is a fundamental production engineering skill.',
    concepts: [
      ConceptLesson(
        title: 'What is a Database Index?',
        definition:
            'A database index is a separate data structure (usually a B-tree) that maintains a sorted copy of one or more columns, enabling the database to find rows matching a condition in O(log n) instead of O(n) full table scan.',
        analogy:
            'A database index is exactly like the index at the back of a textbook — instead of reading every page to find "binary search", you look up B in the alphabetical index and jump directly to the right pages. The book itself (table) is unchanged.',
        example:
            '-- Without index: reads EVERY row\nSELECT * FROM users WHERE email = "alice@example.com";\n-- Database checks: row 1? No. Row 2? No. Row 3? No... all 1M rows\n\n-- With index on email: finds in O(log n) steps\nCREATE INDEX idx_users_email ON users(email);\n-- Database: binary search index → page 47 → row found. Done.',
        keyTakeaway:
            'A full table scan on a table with 1 million rows checks 1,000,000 rows. A B-tree index on the same table finds any value in about 20 steps. This difference is why indexing is the first tool to reach for on slow queries.',
      ),
      ConceptLesson(
        title: 'Creating and Using Indexes',
        definition:
            'Indexes are created with CREATE INDEX. The database uses them automatically when a query filters, sorts, or joins on indexed columns — you do not explicitly "call" an index in your SQL.',
        analogy:
            'Using an index is automatic — like a library database that automatically uses its catalogue to find books. You just ask "find Python Crash Course" without specifying "use the title catalogue to search". The library decides the best lookup strategy.',
        example:
            '-- Single column index\nCREATE INDEX idx_orders_customer ON orders(customer_id);\n\n-- Composite (multi-column) index\nCREATE INDEX idx_orders_date_status ON orders(created_at, status);\n\n-- Unique index (also enforces uniqueness)\nCREATE UNIQUE INDEX idx_users_email ON users(email);\n\n-- Check which index a query uses (PostgreSQL/MySQL)\nEXPLAIN SELECT * FROM orders WHERE customer_id = 5;',
        keyTakeaway:
            'EXPLAIN (or EXPLAIN ANALYZE) shows whether the database is using an index or doing a full scan. Run EXPLAIN on every slow query before and after adding an index to confirm it is being used.',
      ),
      ConceptLesson(
        title: 'When Indexes Help vs When They Do Not',
        definition:
            'Indexes help on high-cardinality columns (many unique values) in WHERE, JOIN, and ORDER BY clauses. They do NOT help for low-cardinality columns (few unique values) or for full table reads.',
        analogy:
            'An index on a "gender" column (2 unique values) is like a phone book sorted by "male/female" — useless for finding one person. An index on "name" (millions of unique values) is genuinely useful.',
        example:
            'GOOD index candidates:\n  users.email          — high cardinality, frequent lookup\n  orders.customer_id   — foreign key, used in joins\n  orders.created_at    — date range queries\n  products.price       — ORDER BY and range filters\n\nPOOR index candidates:\n  users.gender         — only 2-3 values (low cardinality)\n  orders.status        — only 4-5 values\n  users.is_active      — boolean, only 2 values',
        keyTakeaway:
            'A rule of thumb: index columns that appear in WHERE, JOIN ON, or ORDER BY clauses AND have high cardinality (many distinct values). Low-cardinality indexes can actually be SLOWER than full scans.',
      ),
      ConceptLesson(
        title: 'The Cost of Indexes: Write Performance',
        definition:
            'Every index must be maintained on every INSERT, UPDATE, and DELETE — adding write overhead. Tables with many indexes have fast reads but slower writes.',
        analogy:
            'Maintaining a table index is like updating every index in every copy of a textbook each time you add a new chapter — more indexes means more update work for every single write.',
        example:
            'A table with 10 indexes:\n  READ: extremely fast — can use any of 10 indexes\n  INSERT: must update 10 index structures — 10x slower than no indexes\n  UPDATE: if indexed column changes, must update that index\n  DELETE: must remove entry from all relevant indexes\n\nReal-world trade-off: a write-heavy logging table should have FEWER indexes\nA read-heavy product catalogue should have MORE indexes',
        keyTakeaway:
            'Never blindly index every column. Measure: what queries are slow? Which columns do those queries filter on? Add targeted indexes only for proven bottlenecks. Over-indexing is a real production problem.',
      ),
      ConceptLesson(
        title: 'Composite Indexes & Index Column Order',
        definition:
            'A composite index on (A, B) can be used for queries filtering on A alone or A+B together, but NOT on B alone. Column order in a composite index matters significantly.',
        analogy:
            'A phone book sorted by (last_name, first_name) lets you quickly find all Sharmas, or specifically Rahul Sharma — but not quickly find all people named "Rahul" regardless of last name (you would have to scan everything).',
        example:
            '-- Composite index on (customer_id, created_at)\nCREATE INDEX idx_orders_cust_date ON orders(customer_id, created_at);\n\n-- USES index: filters on the leftmost column\nSELECT * FROM orders WHERE customer_id = 5;\nSELECT * FROM orders WHERE customer_id = 5 AND created_at > "2024-01-01";\n\n-- DOES NOT USE index efficiently:\nSELECT * FROM orders WHERE created_at > "2024-01-01";\n-- (created_at is not the leftmost column)',
        keyTakeaway:
            'The leftmost prefix rule: always put the column with the highest selectivity (most filtering power) first in a composite index, and match your WHERE clause column order to the index definition.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What data structure do most relational databases use for indexes?',
        options: [
          'Hash table',
          'B-tree (balanced tree)',
          'Linked list',
          'Array'
        ],
        correctIndex: 1,
        explanation:
            'B-trees are the default index structure — they maintain sorted order, support range queries (>, <, BETWEEN), and find any value in O(log n) steps. Hash indexes exist but only support exact equality lookups.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is indexing a boolean "is_active" column (values: true/false only) generally a poor choice?',
        options: [
          'Databases cannot index boolean columns',
          'Low cardinality (only 2 values) means the index points to roughly half the table — often slower than a full scan',
          'Boolean indexes corrupt data',
          'It is always a good choice — index all columns'
        ],
        correctIndex: 1,
        explanation:
            'With only 2 possible values, each index entry points to ~50% of the table. The database often finds it faster to just scan the whole table than to follow index pointers to half the rows scattered across disk.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A composite index on (city, age). Which query CANNOT efficiently use this index?',
        options: [
          'WHERE city = "Mumbai"',
          'WHERE city = "Mumbai" AND age > 25',
          'WHERE age > 25 (without city filter)',
          'ORDER BY city, age'
        ],
        correctIndex: 2,
        explanation:
            'The leftmost prefix rule: a composite index (city, age) can be used when city is in the filter (with or without age). When only age is filtered (without city), the index cannot be used efficiently because city is the leftmost, leading column.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A query SELECT * FROM orders WHERE customer_id = 5 AND status = "pending" takes 8 seconds on a table of 5 million rows. What is the FIRST step to investigate?',
        options: [
          'Rewrite the entire application in a faster language',
          'Run EXPLAIN on the query to see if it is doing a full table scan and which indexes (if any) are used',
          'Add an index on every column immediately',
          'Move the database to a larger server'
        ],
        correctIndex: 1,
        explanation:
            'EXPLAIN shows the query execution plan — whether an index is used, how many rows are scanned, and the estimated cost. This is ALWAYS step one in performance investigation, before making any changes.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A table has 12 indexes. INSERTs are taking 400ms each, causing timeouts. What is the most likely cause and fix?',
        options: [
          'The table has too many rows — delete some',
          'Too many indexes: each INSERT must update 12 index structures. Audit and remove indexes that are not actively used by any query',
          'Add more RAM to the server',
          'Switch to a NoSQL database'
        ],
        correctIndex: 1,
        explanation:
            'Each index adds overhead to every write operation. 12 indexes on a write-heavy table is excessive. Using EXPLAIN on read queries to identify which indexes are actually used, and dropping unused ones, directly reduces INSERT time.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Query Optimization Lab',
      goal:
          'Benchmark queries before and after indexing, and use EXPLAIN to understand execution plans.',
      steps: [
        'Create a table with 100,000 rows (use a loop or generate script): orders(id, customer_id, product_id, status, amount, created_at)',
        'Run EXPLAIN on: SELECT * FROM orders WHERE customer_id = 5 — document the plan (full scan expected)',
        'Add index on customer_id and re-run EXPLAIN — document the plan change',
        'Time the query before and after indexing and record the difference',
        'Test the composite index scenario: add index on (status, created_at) and verify it helps this query: WHERE status = "pending" AND created_at > "2024-01-01"',
        'Identify one query that does NOT benefit from your indexes and explain why in a comment',
      ],
      expectedOutput:
          'BEFORE index:\n  EXPLAIN: Full table scan, 100,000 rows examined\n  Query time: 0.45s\n\nAFTER index on customer_id:\n  EXPLAIN: Index scan, 12 rows examined\n  Query time: 0.002s (225x faster)\n\nComposite index (status, created_at): helps WHERE status+date query ✓\nQuery NOT helped: WHERE amount > 500 (no index on amount) — documented ✓',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'sep_l6_transactions',
    topicTitle: 'Transactions',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Hard',
    estimatedMinutes: 32,
    totalXp: 225,
    emoji: '🔐',
    intro:
        'A transaction is what separates a reliable system from a system that randomly loses money, double-charges customers, or corrupts data when two people click at the same time. Every banking system, payment processor, and e-commerce platform depends on transactions. ACID properties — the guarantee behind every reliable database — are tested in every serious backend engineering interview.',
    concepts: [
      ConceptLesson(
        title: 'What is a Transaction?',
        definition:
            'A transaction is a sequence of SQL operations that are treated as a single atomic unit — either ALL operations succeed (COMMIT) or ALL are reversed (ROLLBACK), leaving the database as if the transaction never happened.',
        analogy:
            'A bank transfer is the classic transaction: debit Alice\'s account AND credit Bob\'s account. If the system crashes after debiting Alice but before crediting Bob, the transaction rolls back — Alice gets her money back, Bob gets nothing. No half-completed state.',
        example:
            'BEGIN;\n\n-- Debit Alice\nUPDATE accounts SET balance = balance - 5000 WHERE owner = "Alice";\n\n-- Credit Bob\nUPDATE accounts SET balance = balance + 5000 WHERE owner = "Bob";\n\nCOMMIT;  -- both changes finalized together\n\n-- If anything goes wrong between BEGIN and COMMIT:\n-- ROLLBACK;  -- reverses BOTH changes, as if they never happened',
        keyTakeaway:
            'Without transactions, a system crash between two related updates creates permanently inconsistent data — money deducted from one account but never added to another. Transactions guarantee this cannot happen.',
      ),
      ConceptLesson(
        title: 'ACID Properties',
        definition:
            'ACID stands for Atomicity (all or nothing), Consistency (transitions between valid states only), Isolation (concurrent transactions do not interfere), and Durability (committed data survives crashes).',
        analogy:
            'ACID properties are like the rules of a reliable vending machine: it either dispenses the product AND takes the money (Atomicity), never dispenses without taking money or takes money without dispensing (Consistency), handles two people pressing buttons simultaneously without confusion (Isolation), and remembers the transaction even if the power blinks (Durability).',
        example:
            'Atomicity: transfer debit + credit = one unit, all or nothing\nConsistency: total money in system before = total money after transfer\nIsolation: simultaneous transfer requests do not corrupt each other\nDurability: after COMMIT confirmation, the data survives power outage',
        keyTakeaway:
            'When an interviewer asks "how does a bank handle concurrent transfers?", the answer is ACID transactions. Understanding each property is what distinguishes backend engineers who understand reliability from those who do not.',
      ),
      ConceptLesson(
        title: 'Isolation Levels and Concurrency Problems',
        definition:
            'Isolation levels control how much concurrent transactions can "see" each other\'s uncommitted changes. Lower isolation = better performance but more concurrency anomalies. Higher isolation = fewer anomalies but more contention.',
        analogy:
            'Isolation levels are like different levels of a library\'s "quiet zone" policy — the strictest zone has no talking at all (Serializable: slowest, most correct), while a relaxed zone allows whispering and noise (Read Uncommitted: fastest, most problems).',
        example:
            'Concurrency problems:\n1. Dirty Read: reading another transaction\'s uncommitted (possibly rolled-back) data\n2. Non-repeatable Read: same query returns different results within one transaction\n3. Phantom Read: new rows appear between two reads in the same transaction\n\nIsolation levels (weakest to strongest):\nRead Uncommitted → Read Committed → Repeatable Read → Serializable',
        keyTakeaway:
            'Most production databases default to "Read Committed" — it prevents dirty reads while maintaining reasonable performance. Use Serializable isolation only for operations that MUST be completely isolated, as it causes the most lock contention.',
      ),
      ConceptLesson(
        title: 'Deadlocks',
        definition:
            'A deadlock occurs when two transactions each hold a lock that the other needs — both wait forever, and neither can proceed. Databases detect and resolve deadlocks by killing one transaction (the victim).',
        analogy:
            'A deadlock is like two cars meeting on a one-lane bridge from opposite ends — each waits for the other to reverse, and neither can move. The resolution is for one driver to reverse (transaction killed and rolled back) so the other can proceed.',
        example:
            '-- Transaction 1: locks A, then waits for B\nBEGIN;\nUPDATE accounts SET balance = balance - 100 WHERE id = 1;  -- LOCKS row 1\n-- ... waiting ...\nUPDATE accounts SET balance = balance + 100 WHERE id = 2;  -- WAITS for lock on row 2\n\n-- Transaction 2: locks B, then waits for A (deadlock!)\nBEGIN;\nUPDATE accounts SET balance = balance - 100 WHERE id = 2;  -- LOCKS row 2\nUPDATE accounts SET balance = balance + 100 WHERE id = 1;  -- WAITS for lock on row 1',
        keyTakeaway:
            'The best deadlock prevention strategy: always acquire locks in a consistent ORDER across all transactions (always lock lower IDs before higher IDs). If you cannot control order, implement retry logic when deadlocks are detected.',
      ),
      ConceptLesson(
        title: 'Savepoints and Nested Transactions',
        definition:
            'Savepoints let you mark a point within a transaction to partially roll back to, without rolling back the entire transaction — useful for complex multi-step operations.',
        analogy:
            'A savepoint is like a checkpoint in a video game — if you fail after the checkpoint, you restart from there, not from the beginning of the entire level. You preserve the progress made before the checkpoint.',
        example:
            'BEGIN;\nUPDATE inventory SET stock = stock - 1 WHERE product_id = 1;\nSAVEPOINT after_inventory;\n\nINSERT INTO orders (product_id, customer_id) VALUES (1, 5);\nSAVEPOINT after_order;\n\nINSERT INTO payments (order_id, amount) VALUES (LAST_INSERT_ID(), 5000);\n-- If payment fails, roll back only the payment:\nROLLBACK TO after_order;\n-- Inventory deduction and order remain, payment attempt undone\n\nCOMMIT;  -- commit what remains',
        keyTakeaway:
            'Savepoints are powerful for complex workflows where some steps failing should not undo everything — order creation might succeed even if the automated payment fails, allowing the user to retry payment separately.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What does ROLLBACK do in a transaction?',
        options: [
          'Saves all changes made in the transaction',
          'Reverses all changes made since BEGIN, leaving the database as if the transaction never happened',
          'Creates a backup of the database',
          'Moves to the next transaction'
        ],
        correctIndex: 1,
        explanation:
            'ROLLBACK undoes all changes made within the current transaction, restoring the database to its state at the time BEGIN was called. This is the "all nothing" part of Atomicity.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the "D" in ACID (Durability) guarantee?',
        options: [
          'Data is deleted safely',
          'Once a transaction is committed, the changes persist even if the server crashes immediately after',
          'All data is backed up automatically',
          'Data cannot be modified after commit'
        ],
        correctIndex: 1,
        explanation:
            'Durability means a COMMIT is permanent — the database writes changes to disk (or write-ahead log) before confirming the commit. Even an immediate power failure after COMMIT does not lose the data.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is a deadlock in database transactions?',
        options: [
          'A transaction that takes too long to complete',
          'Two transactions each waiting for a lock held by the other, creating a permanent standstill',
          'A corrupted database that cannot be read',
          'A transaction that cannot be rolled back'
        ],
        correctIndex: 1,
        explanation:
            'A deadlock is a circular wait: Transaction A holds lock 1 and waits for lock 2; Transaction B holds lock 2 and waits for lock 1. Neither can proceed — the database resolves this by forcibly rolling back one of them.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A user purchases a product. The system must: (1) deduct stock, (2) create an order, (3) charge the payment. If the payment fails, what should happen to stock and the order?',
        options: [
          'Leave stock deducted and order created — user can pay later',
          'Roll back all three steps — wrap them in one transaction so either all succeed or none do',
          'Only roll back the payment step',
          'Delete the user account'
        ],
        correctIndex: 1,
        explanation:
            'All three steps are logically one operation — either the purchase completes fully or nothing changes. Wrapping all three in a single transaction with ROLLBACK on payment failure ensures no orphaned stock deductions or phantom orders.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Two transactions both try to update row id=1 simultaneously. Transaction A updates it first. Under READ COMMITTED isolation, what does Transaction B see before Transaction A commits?',
        options: [
          'Transaction B sees A\'s uncommitted changes immediately',
          'Transaction B sees the original value before A\'s transaction — A\'s changes are invisible until committed',
          'Transaction B is blocked forever',
          'Both transactions see a random value'
        ],
        correctIndex: 1,
        explanation:
            'READ COMMITTED prevents dirty reads — Transaction B sees only the last committed state of row id=1. Transaction A\'s uncommitted changes are invisible to B until A explicitly COMMITs.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Banking Transfer System with Full ACID Guarantees',
      goal:
          'Build a complete bank transfer system demonstrating all ACID properties with transaction management.',
      steps: [
        'Create accounts table and insert 5 accounts with different balances',
        'Implement transfer(from_id, to_id, amount) using a transaction: check sufficient funds, debit, credit, log the transfer',
        'Demonstrate Atomicity: force a failure after debit but before credit — verify ROLLBACK leaves both accounts unchanged',
        'Demonstrate the deadlock scenario with two simultaneous transfers (A→B and B→A) and show how the database resolves it',
        'Implement retry logic that detects deadlock errors and retries the transaction up to 3 times',
        'Use a savepoint to partially roll back a failed multi-step transaction while preserving earlier successful steps',
      ],
      expectedOutput:
          'Transfer ₹5000 Alice→Bob: SUCCESS\n  Alice: ₹45,000 → ₹40,000\n  Bob: ₹30,000 → ₹35,000\n\nForced failure test:\n  Alice debited... FORCED CRASH\n  ROLLBACK applied\n  Alice: ₹40,000 (unchanged) — Atomicity ✓\n\nDeadlock detected and resolved — victim rolled back, winner committed ✓\nRetry logic: succeeded on attempt 2 after deadlock ✓',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'sep_l6_postgresql',
    topicTitle: 'PostgreSQL Fundamentals',
    careerId: 'software_engineer',
    categoryId: 'software_dev',
    difficulty: 'Medium',
    estimatedMinutes: 32,
    totalXp: 215,
    emoji: '🐘',
    intro:
        'PostgreSQL is the world\'s most advanced open-source relational database — used by Instagram, Spotify, Reddit, GitHub, and thousands of other serious engineering teams. It goes beyond standard SQL with powerful features like JSON support, full-text search, window functions, and advanced indexing. This course gives you the production PostgreSQL knowledge that sets you apart.',
    concepts: [
      ConceptLesson(
        title: 'Why PostgreSQL Over Other Databases?',
        definition:
            'PostgreSQL (Postgres) is ACID-compliant, supports advanced SQL features (CTEs, window functions, JSON, full-text search), has excellent concurrency with MVCC, and is free and open source.',
        analogy:
            'Choosing PostgreSQL over a simpler database is like choosing a Swiss Army knife over a kitchen knife — it does everything the simple tool does, plus far more, without significantly more complexity for standard tasks.',
        example:
            'PostgreSQL advantages over MySQL:\n✓ Full ACID compliance (MySQL InnoDB is ACID, but less thorough)\n✓ Better standards compliance (SQL standard features)\n✓ Advanced data types: JSONB, ARRAY, UUID, HSTORE\n✓ Window functions: LAG(), LEAD(), RANK(), ROW_NUMBER()\n✓ Partial indexes, expression indexes, GIN/GiST indexes\n✓ Table inheritance\n✓ Better parallel query execution',
        keyTakeaway:
            'PostgreSQL is the default choice for new serious projects. If a job posting mentions "PostgreSQL experience", that is exactly what this course covers.',
      ),
      ConceptLesson(
        title: 'JSONB — Flexible Schema Within PostgreSQL',
        definition:
            'PostgreSQL\'s JSONB type stores JSON data in a binary format that can be indexed and queried efficiently — giving you NoSQL-style flexibility within a relational database.',
        analogy:
            'JSONB is like having a flexible "notes" field in a well-organised filing cabinet — most data lives in structured, typed columns (fast, relational), but the notes field can hold any shape of information without requiring a new column for every edge case.',
        example:
            'CREATE TABLE products (\n    id SERIAL PRIMARY KEY,\n    name VARCHAR(100),\n    price DECIMAL(10,2),\n    attributes JSONB  -- flexible extra data\n);\n\nINSERT INTO products VALUES\n  (1, "Laptop", 55000, \'{"ram":"16GB","storage":"512GB","color":"Silver"}\'),\n  (2, "Shirt",  1200,  \'{"size":"L","material":"Cotton","color":"Blue"}\');\n\n-- Query JSONB fields\nSELECT name, attributes->>\'color\' AS color\nFROM products\nWHERE attributes->>\'ram\' = \'16GB\';\n\n-- Index JSONB for fast lookups\nCREATE INDEX idx_product_attrs ON products USING GIN(attributes);',
        keyTakeaway:
            'JSONB gives you the best of both worlds: relational structure where appropriate, flexible JSON where schema varies between records. Use it for product attributes, user preferences, or event metadata.',
      ),
      ConceptLesson(
        title: 'Window Functions — Analytics Without Subqueries',
        definition:
            'Window functions perform calculations across a set of rows related to the current row (a "window"), without collapsing rows like GROUP BY does — enabling rankings, running totals, and comparisons to previous rows.',
        analogy:
            'A window function is like a spreadsheet formula that can look at the entire column context while filling in each cell — "what is the running total so far?", "what was the previous row\'s value?", "what rank does this value have?"',
        example:
            '-- Rank products by price within each category\nSELECT name, category, price,\n       RANK() OVER (PARTITION BY category ORDER BY price DESC) AS price_rank\nFROM products;\n\n-- Running total of orders over time\nSELECT created_at, amount,\n       SUM(amount) OVER (ORDER BY created_at) AS running_total\nFROM orders;\n\n-- Compare each sale to the previous day\nSELECT date, revenue,\n       LAG(revenue, 1) OVER (ORDER BY date) AS prev_day_revenue\nFROM daily_sales;',
        keyTakeaway:
            'Window functions (RANK, ROW_NUMBER, LAG, LEAD, SUM OVER, AVG OVER) replace complex self-joins and subqueries with clean, readable analytics. They are tested in senior SQL interviews regularly.',
      ),
      ConceptLesson(
        title: 'CTEs — WITH Queries for Readable SQL',
        definition:
            'Common Table Expressions (CTEs) let you define named temporary result sets at the top of a query using WITH, making complex queries dramatically more readable by breaking them into named steps.',
        analogy:
            'A CTE is like assigning intermediate results to clearly named variables in a complex calculation — instead of one incomprehensible formula, you have a series of named steps that are each readable on their own.',
        example:
            '-- WITHOUT CTE: hard to read nested subqueries\nSELECT name FROM customers\nWHERE id IN (SELECT customer_id FROM orders\n             WHERE amount > (SELECT AVG(amount) FROM orders));\n\n-- WITH CTE: much cleaner\nWITH avg_order AS (\n    SELECT AVG(amount) AS avg_amt FROM orders\n),\nhigh_value_orders AS (\n    SELECT customer_id FROM orders, avg_order\n    WHERE orders.amount > avg_order.avg_amt\n)\nSELECT c.name\nFROM customers c\nINNER JOIN high_value_orders h ON c.id = h.customer_id;',
        keyTakeaway:
            'CTEs do not improve performance (they often compile to the same plan as subqueries), but they dramatically improve READABILITY — and readable queries are maintained correctly by teams over years.',
      ),
      ConceptLesson(
        title: 'EXPLAIN ANALYZE — Reading Execution Plans',
        definition:
            'EXPLAIN ANALYZE actually runs the query and shows the full execution plan with real timing, row counts, and which indexes were used — the essential tool for understanding and fixing slow queries.',
        analogy:
            'EXPLAIN ANALYZE is like a sports performance tracker — it does not just predict how fast you SHOULD run (EXPLAIN), it actually runs the race and records exactly where every second was spent, revealing where you slowed down.',
        example:
            'EXPLAIN ANALYZE\nSELECT c.name, COUNT(o.id)\nFROM customers c\nJOIN orders o ON c.id = o.customer_id\nGROUP BY c.id;\n\n-- Output includes:\n-- Hash Join (actual time=15.2..89.3 rows=1247)\n--   Seq Scan on orders (actual time=0.01..4.2 rows=5000)\n--   Hash on customers (actual time=1.1..1.1 rows=200)\n-- Planning time: 0.8 ms\n-- Execution time: 91.4 ms\n-- (tells you: full scan on orders — needs an index!)',
        keyTakeaway:
            'Learn to read EXPLAIN ANALYZE output: "Seq Scan" means full table scan (often slow), "Index Scan" means an index is being used (fast), "Hash Join" vs "Nested Loop" tells you the join strategy chosen.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is PostgreSQL\'s JSONB type primarily useful for?',
        options: [
          'Storing only JSON arrays',
          'Storing flexible, semi-structured data that can be indexed and queried efficiently alongside relational data',
          'Replacing all relational tables with JSON documents',
          'Compressing regular string data'
        ],
        correctIndex: 1,
        explanation:
            'JSONB stores JSON in binary format that supports indexing (with GIN indexes) and efficient querying — giving NoSQL flexibility for variable-schema data while keeping it within the relational database.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What makes window functions different from GROUP BY aggregations?',
        options: [
          'Window functions are faster',
          'Window functions compute across related rows WITHOUT collapsing them — each original row remains in the output with the computed value added',
          'Window functions only work on numeric data',
          'GROUP BY and window functions are identical'
        ],
        correctIndex: 1,
        explanation:
            'GROUP BY collapses multiple rows into one summary row per group. Window functions add a computed column to each row based on a "window" of related rows, preserving all original rows in the output.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'In EXPLAIN ANALYZE output, what does "Seq Scan" indicate?',
        options: [
          'An index was used efficiently',
          'A full sequential table scan is being performed — often a performance concern on large tables',
          'The query was cached from a previous run',
          'The table is being sorted before scanning'
        ],
        correctIndex: 1,
        explanation:
            '"Seq Scan" (sequential scan) means the database is reading every row in the table from beginning to end — necessary when no suitable index exists. On large tables, this is typically slow and signals a missing index.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You need to find the top 3 best-selling products PER CATEGORY, not the top 3 overall. Which SQL feature handles this most elegantly?',
        options: [
          'Multiple separate queries, one per category',
          'RANK() OVER (PARTITION BY category ORDER BY sales DESC) window function, then filter WHERE rank <= 3',
          'GROUP BY category and LIMIT 3',
          'A stored procedure with a cursor'
        ],
        correctIndex: 1,
        explanation:
            'RANK() OVER (PARTITION BY category ORDER BY sales DESC) assigns a rank within each category. Filtering WHERE rank <= 3 (via a CTE or subquery) returns exactly the top 3 per category — impossible with a simple GROUP BY + LIMIT.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'A complex query has 4 nested subqueries and is impossible to read or debug. What PostgreSQL feature directly solves this readability problem?',
        options: [
          'Window functions',
          'CTEs (Common Table Expressions using WITH) — name each subquery as a readable intermediate step',
          'JSONB columns',
          'Creating a new table for intermediate results'
        ],
        correctIndex: 1,
        explanation:
            'CTEs let you name each intermediate result set at the top of the query (WITH step1 AS (...), step2 AS (...)) and reference them by name below — transforming a nest of subqueries into a readable, step-by-step query.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Advanced Analytics Dashboard with PostgreSQL',
      goal:
          'Build a complete analytics suite using PostgreSQL-specific features: window functions, CTEs, JSONB, and EXPLAIN ANALYZE.',
      steps: [
        'Create a sales table with a JSONB metadata column storing channel, discount_code, and device type',
        'Query JSONB: find total sales for each unique discount code stored in the metadata field',
        'Use ROW_NUMBER() OVER (PARTITION BY salesperson_id ORDER BY amount DESC) to rank each salesperson\'s top deals',
        'Write a CTE-based query finding customers whose monthly spending is above average for 3+ consecutive months',
        'Use LAG() to compare each week\'s revenue to the previous week and flag weeks with > 20% decline',
        'Run EXPLAIN ANALYZE on your most complex query, identify any Seq Scans, add appropriate indexes, and re-run to show improvement',
      ],
      expectedOutput:
          'JSONB discount analysis: SAVE10 → ₹2.4L | WELCOME → ₹1.1L\nTop deals per salesperson: Alice #1 ₹85K, Bob #1 ₹72K...\nConsistent high-spenders: [Alice, Carol, Rahul]\nRevenue decline alerts: Week 23 (-25%), Week 41 (-31%)\nEXPLAIN ANALYZE: Seq Scan → Index Scan after optimization (12x faster) ✓',
      xpReward: 60,
    ),
  ),
];
