import '../../models/course_content_data.dart';

const List<TopicCourse> dataScientistLevel4 = [

  TopicCourse(
    id: 'advanced_pandas_ds4',
    topicTitle: 'Advanced Pandas',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 40,
    totalXp: 165,
    emoji: '🐼',
    intro: 'Level 3 gave you Pandas fundamentals. Now you go deeper — multi-indexing, pivot tables, window functions, and method chaining are what separate a beginner script from a professional data pipeline. These are the exact tools you will use daily once you touch a real company dataset.',
    concepts: [
      ConceptLesson(
        title: 'MultiIndex: Hierarchical Data Organization',
        definition: 'A MultiIndex allows a DataFrame to have multiple levels of row or column labels — enabling you to represent naturally hierarchical data (region > city > store) without flattening it into repetitive columns.',
        analogy: 'A MultiIndex is like a filing cabinet with drawers inside drawers — "Sales" drawer, then "2024" drawer inside it, then "Q1" folder inside that. You can grab the whole "Sales" drawer, or drill down to exactly one folder, without reorganizing anything.',
        example: 'A sales dataset indexed by (region, product) lets you slice "all North region sales" in one line, or drill down to "North region, Electronics" specifically — without repeatedly filtering with boolean conditions.',
        keyTakeaway: 'Use .set_index() with a list of columns to create a MultiIndex, and .loc[] with tuples to slice it. groupby() with multiple columns automatically produces a MultiIndex result — recognizing this prevents confusion when the output looks "different" from a normal DataFrame.',
        codeSnippet: 'import pandas as pd\n\ndf = pd.DataFrame({\n    "region": ["North", "North", "South", "South"],\n    "product": ["A", "B", "A", "B"],\n    "sales": [100, 150, 200, 90]\n})\n\nmi = df.set_index(["region", "product"])\nprint(mi.loc["North"])          # all North rows\nprint(mi.loc[("North", "A")])   # exact match',
      ),
      ConceptLesson(
        title: 'Pivot Tables and Cross-Tabulation',
        definition: 'pivot_table() reshapes long-format data into a wide, summarized grid — rows and columns become categories, cell values become aggregated statistics. crosstab() does the same specifically for frequency counts.',
        analogy: 'A pivot table is like turning a receipt log into an Excel-style summary sheet — instead of scrolling through thousands of individual transaction rows, you see one clean grid: rows = products, columns = months, cells = total revenue.',
        example: 'df.pivot_table(index="region", columns="product", values="sales", aggfunc="sum") instantly produces a region × product revenue grid — the single most common output requested in business reporting.',
        keyTakeaway: 'pivot_table() handles duplicate index/column combinations by aggregating (unlike pivot(), which requires unique combinations and errors otherwise). Always specify aggfunc explicitly ("sum", "mean", "count") rather than relying on the default.',
        codeSnippet: 'import pandas as pd\n\ndf = pd.DataFrame({\n    "region": ["North","North","South","South"],\n    "product": ["A","B","A","B"],\n    "sales": [100,150,200,90]\n})\n\npivot = df.pivot_table(index="region", columns="product",\n                        values="sales", aggfunc="sum")\nprint(pivot)',
      ),
      ConceptLesson(
        title: 'Window Functions: rolling, expanding and shift',
        definition: 'Window functions compute values over a sliding or expanding subset of rows — rolling() for fixed-size moving windows, expanding() for growing cumulative windows, and shift() for accessing previous/next row values.',
        analogy: 'A rolling window is like a 7-day weather forecast card that slides forward one day at a time — each day\'s "weekly average" only looks at the 7 days immediately before it, not the entire year\'s history.',
        example: 'df["revenue"].rolling(7).mean() computes a 7-day moving average — smoothing daily noise to reveal the underlying trend. df["revenue"].shift(1) gives yesterday\'s value alongside today\'s, enabling day-over-day change calculations.',
        keyTakeaway: 'Rolling windows are essential for time series smoothing and trend detection. shift() combined with subtraction (df["value"] - df["value"].shift(1)) is the standard pattern for computing period-over-period change.',
        codeSnippet: 'import pandas as pd\n\nrevenue = pd.Series([100,120,90,150,130,170,160,200])\nrolling_avg = revenue.rolling(3).mean()\nprint("3-day rolling avg:\\n", rolling_avg)\n\nchange = revenue - revenue.shift(1)\nprint("\\nDay-over-day change:\\n", change)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is the key difference between pivot() and pivot_table() in Pandas?',
        options: [
          'They are identical functions with different names',
          'pivot_table() can aggregate duplicate index/column combinations using a function like sum or mean, while pivot() requires unique combinations and raises an error on duplicates',
          'pivot() is faster for all dataset sizes',
          'pivot_table() only works with numeric data'
        ],
        correctIndex: 1,
        explanation: 'pivot_table() handles duplicates by aggregating them (default mean, or a specified aggfunc). pivot() has no aggregation logic and will error if multiple rows map to the same row/column combination.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'You want to calculate the day-over-day change in daily revenue. Which combination of Pandas operations achieves this?',
        options: [
          'df["revenue"].rolling(1).sum()',
          'df["revenue"] - df["revenue"].shift(1)',
          'df["revenue"].expanding().mean()',
          'df["revenue"].cumsum()'
        ],
        correctIndex: 1,
        explanation: 'shift(1) moves each value down one row, aligning "yesterday\'s value" next to "today\'s value" — subtracting gives the exact day-over-day change. This is the standard Pandas idiom for period-over-period comparisons.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You need a grid showing average order value broken down by both customer_segment (rows) and quarter (columns). Which function is the right tool?',
        options: [
          'df.groupby("customer_segment").mean()',
          'df.pivot_table(index="customer_segment", columns="quarter", values="order_value", aggfunc="mean")',
          'df.rolling(4).mean()',
          'df.set_index("customer_segment")'
        ],
        correctIndex: 1,
        explanation: 'pivot_table() is designed exactly for this two-dimensional summary — one categorical variable as rows, another as columns, with an aggregated numeric value in each cell.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Regional Sales Reporting Dashboard (Pandas-only)',
      goal: 'Build a multi-level sales reporting tool using MultiIndex, pivot tables, and window functions on simulated data.',
      steps: [
        'Simulate 2 years of daily sales data (region, product, date, revenue) using NumPy/Pandas.',
        'Create a MultiIndex on (region, product) and demonstrate slicing at both levels.',
        'Build a pivot table: region (rows) x product (columns), showing total revenue.',
        'Compute a 30-day rolling average of total daily revenue and a month-over-month percentage change using shift().',
        'Print a formatted summary report combining all three analyses.',
      ],
      expectedOutput: 'MultiIndex correctly created and sliced. Pivot table shows correct region x product totals. Rolling average and month-over-month change computed correctly. Clean formatted report printed.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'time_series_basics_ds4',
    topicTitle: 'Time Series Analysis Basics',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 35,
    totalXp: 155,
    emoji: '📅',
    intro: 'Revenue over months, website traffic over days, sensor readings over seconds — time series data is everywhere in business. This lesson teaches you to handle dates properly, spot trends and seasonality, and build the foundation for forecasting.',
    concepts: [
      ConceptLesson(
        title: 'Working with Datetime in Pandas',
        definition: 'Pandas\' datetime functionality (pd.to_datetime, DatetimeIndex) converts string dates into proper datetime objects, enabling date arithmetic, resampling, and time-based indexing — essential before any time series analysis.',
        analogy: 'Treating dates as plain strings is like trying to do math with words instead of numbers — you cannot compute "how many days between these two dates" from text. Converting to datetime is like converting word-numbers into actual numbers your calculator can use.',
        example: 'A sales dataset with a "date" column loaded from CSV as strings must be converted with pd.to_datetime(df["date"]) before you can extract the month, compute date differences, or resample by week/month.',
        keyTakeaway: 'Setting a datetime column as the index (df.set_index("date")) unlocks powerful time-based slicing like df["2024-01"] (all January 2024 rows) and resampling operations — this is the standard first step in any time series workflow.',
        codeSnippet: 'import pandas as pd\n\ndf = pd.DataFrame({\n    "date": ["2024-01-01","2024-01-02","2024-01-03"],\n    "revenue": [1200, 1500, 1100]\n})\ndf["date"] = pd.to_datetime(df["date"])\ndf = df.set_index("date")\nprint(df.index.dayofweek)   # day of week for each date',
      ),
      ConceptLesson(
        title: 'Resampling: Changing Time Granularity',
        definition: 'Resampling aggregates time series data to a different frequency — converting daily data to weekly/monthly summaries (downsampling) or filling in finer intervals (upsampling).',
        analogy: 'Resampling is like converting a detailed hour-by-hour diary into a weekly summary — you lose the fine detail but gain a clearer view of the overall pattern, which is often exactly what a business report needs.',
        example: 'df.resample("M").sum() converts daily revenue records into monthly totals in one line — the standard way to produce a "monthly revenue report" from raw daily transaction data.',
        keyTakeaway: 'Common resample codes: "D" (daily), "W" (weekly), "M" (monthly), "Q" (quarterly), "Y" (yearly). Choose sum() for totals (revenue), mean() for averages (temperature), and last() for point-in-time values (inventory level).',
        codeSnippet: 'import pandas as pd\nimport numpy as np\n\ndates = pd.date_range("2024-01-01", periods=90, freq="D")\nrevenue = pd.Series(np.random.randint(800, 2000, 90), index=dates)\n\nmonthly = revenue.resample("M").sum()\nprint(monthly)',
      ),
      ConceptLesson(
        title: 'Trend, Seasonality and Decomposition',
        definition: 'Time series decomposition separates a series into trend (long-term direction), seasonality (repeating patterns at fixed intervals), and residual (leftover noise) — revealing the structure hidden in raw fluctuating data.',
        analogy: 'Decomposition is like separating a song into its bassline (trend), repeating chorus (seasonality), and background noise (residual) — each layer tells a different part of the story, and mixing them together makes the pattern hard to see.',
        example: 'Retail sales typically show a rising trend (business growth), strong monthly seasonality (holiday spikes every December), and residual noise (random daily fluctuations) — separating these three lets you forecast the trend and seasonality separately from the noise.',
        keyTakeaway: 'statsmodels\' seasonal_decompose() automates this separation. Always check for seasonality before building any forecasting model — ignoring a strong seasonal pattern (like December retail spikes) produces systematically wrong predictions.',
        codeSnippet: 'from statsmodels.tsa.seasonal import seasonal_decompose\nimport pandas as pd\nimport numpy as np\n\ndates = pd.date_range("2022-01-01", periods=365*2, freq="D")\ntrend = np.linspace(100, 200, len(dates))\nseason = 20 * np.sin(np.arange(len(dates)) * 2*np.pi/365)\nnoise = np.random.normal(0, 5, len(dates))\nseries = pd.Series(trend + season + noise, index=dates)\n\nresult = seasonal_decompose(series, model="additive", period=365)\nprint(result.trend.dropna().head())',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why must date strings be converted with pd.to_datetime() before performing time series analysis?',
        options: [
          'Pandas cannot display string dates at all',
          'Datetime objects enable date arithmetic, proper chronological sorting, and time-based operations like resampling — string dates are just text and cannot support these operations correctly',
          'CSV files cannot contain date columns',
          'It is purely a cosmetic formatting choice with no functional benefit'
        ],
        correctIndex: 1,
        explanation: 'String dates sort alphabetically (which can be wrong for some formats) and cannot support date arithmetic or resampling. Converting to datetime unlocks all of Pandas\' time series functionality.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A retail company\'s sales show a clear rising trend and a spike every December. What does time series decomposition help you do with this pattern?',
        options: [
          'It removes the December spike entirely from the data',
          'It separates the data into trend, seasonality, and residual components, letting you analyze the underlying growth trend separately from the predictable seasonal spike',
          'It converts daily data into monthly data automatically',
          'Decomposition has no practical use for business data'
        ],
        correctIndex: 1,
        explanation: 'Decomposition explicitly separates the long-term growth trend from the repeating December seasonal pattern and random noise — allowing each component to be understood and forecasted on its own terms.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You have daily website visit data for 2 years and need to produce a report showing total visits per month. Which operation is correct?',
        options: [
          'df.groupby("month").first()',
          'df.resample("M").sum() — after setting a datetime index, this correctly aggregates daily visits into monthly totals',
          'df.rolling(30).mean()',
          'df.shift(30).sum()'
        ],
        correctIndex: 1,
        explanation: 'resample("M").sum() is the correct tool for converting daily data to monthly totals with a proper datetime index. rolling(30) gives a moving average window, not fixed calendar-month totals.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Website Traffic Time Series Analyzer',
      goal: 'Build a complete time series analysis tool for simulated website traffic data, revealing trend and seasonal patterns.',
      steps: [
        'Simulate 2 years of daily website visits with an upward trend, weekly seasonality (higher on weekdays), and random noise.',
        'Set a proper DatetimeIndex and resample the data to weekly and monthly totals.',
        'Compute a 7-day and 30-day rolling average to smooth out daily noise.',
        'Use seasonal_decompose() to separate trend, seasonality, and residual components, and plot all three.',
        'Print a summary identifying the overall trend direction and the strongest seasonal pattern (which day of week performs best).',
      ],
      expectedOutput: 'Datetime index correctly set. Weekly/monthly resampling correct. Rolling averages smooth the noise visibly. Decomposition correctly separates trend/seasonality/residual with clear plots.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'ab_testing_practice_ds4',
    topicTitle: 'A/B Testing in Practice',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 35,
    totalXp: 155,
    emoji: '🔬',
    intro: 'You already know hypothesis testing from Level 3. Now you apply it to the real, messy operational challenge of running an A/B test end-to-end: sample size planning, avoiding common pitfalls, and communicating results that drive real product decisions.',
    concepts: [
      ConceptLesson(
        title: 'Planning an A/B Test: Sample Size and MDE',
        definition: 'Before running a test, you must determine the required sample size based on the baseline conversion rate, the Minimum Detectable Effect (MDE) you care about, and your desired statistical power — running an underpowered test wastes time and produces unreliable conclusions.',
        analogy: 'Planning sample size is like deciding how many photos you need to reliably detect a small crack in a wall — too few photos (too small a sample) and you might miss a real crack; a power calculation tells you exactly how many photos you need to confidently spot it if it exists.',
        example: 'A checkout page with 5% baseline conversion wants to detect a 1% absolute improvement (to 6%) with 80% power. A sample size calculator reveals this needs roughly 3,000+ users per group — running the test with only 200 users per group would almost certainly fail to detect a real effect.',
        keyTakeaway: 'Always calculate required sample size BEFORE launching a test, not after. Stopping a test early just because results "look significant" (peeking) inflates false positive rates dramatically — this is one of the most common and costly A/B testing mistakes.',
        codeSnippet: 'from statsmodels.stats.power import NormalIndPower\nfrom statsmodels.stats.proportion import proportion_effectsize\n\neffect_size = proportion_effectsize(0.06, 0.05)  # 5% -> 6%\nanalysis = NormalIndPower()\nsample_size = analysis.solve_power(effect_size, power=0.8, alpha=0.05)\nprint(f"Required sample size per group: {sample_size:.0f}")',
      ),
      ConceptLesson(
        title: 'Common A/B Testing Pitfalls',
        definition: 'Real A/B tests fail for reasons beyond statistics: peeking at results early and stopping when significant (p-hacking), running tests during unrepresentative periods (holidays, outages), and testing too many metrics without correction (multiple comparisons problem).',
        analogy: 'Peeking at an A/B test repeatedly and stopping when it looks good is like flipping a coin 100 times and stopping the moment you get 3 heads in a row to declare "this coin is biased toward heads" — random noise will eventually look significant if you keep checking.',
        example: 'A team tests a new feature and checks results daily, stopping on day 3 when p=0.04 appears — but if they had continued, the p-value often bounces back above 0.05. Pre-registering the sample size and test duration, then checking results only once at the end, prevents this trap.',
        keyTakeaway: 'Decide your sample size and test duration BEFORE starting, and only look at results once the predetermined sample size is reached. If you must check periodically, use a sequential testing method designed for it (not standard p-value peeking).',
      ),
      ConceptLesson(
        title: 'From Statistical Result to Business Decision',
        definition: 'A statistically significant A/B test result is not automatically a "ship it" decision — you must weigh statistical significance, practical effect size, implementation cost, and risk of unintended consequences before recommending a rollout.',
        analogy: 'A statistically confirmed 0.1% conversion lift is like confirming a car\'s new paint job objectively makes it 0.1% more aerodynamic — technically true, but you would want to know if the paint job costs more than the fuel savings before recommending it company-wide.',
        example: 'A new checkout flow shows p=0.01 with a 0.3% conversion lift — statistically real, but the engineering cost of maintaining two checkout systems long-term, plus the small absolute revenue gain, may not justify a full rollout compared to other initiatives.',
        keyTakeaway: 'Always translate statistical results into business terms: "this change would generate an estimated ₹X additional revenue per month, with Y% confidence, against Z implementation cost" — this framing is what actually drives decisions, not the p-value alone.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A team checks their A/B test results every day and stops the test on day 3 because p < 0.05 appears. Why is this problematic?',
        options: [
          'Checking results daily is always the correct professional practice',
          'Repeatedly checking and stopping as soon as significance appears (peeking) inflates the true false positive rate far above the intended 5% — the test should run for its pre-planned duration/sample size before being evaluated',
          'p-values become more accurate the more often they are checked',
          'This practice has no effect on the validity of the results'
        ],
        correctIndex: 1,
        explanation: 'Peeking dramatically increases the chance of a false positive because random fluctuation will eventually cross the significance threshold if checked often enough — pre-registering sample size and checking only once avoids this inflation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A test shows a statistically significant 0.05% conversion improvement (p=0.001) from a change that would cost significant engineering effort to maintain. What is the appropriate next step?',
        options: [
          'Ship it immediately since p < 0.05',
          'Weigh the tiny practical effect size and its revenue impact against the implementation and maintenance cost before deciding — statistical significance alone does not justify the decision',
          'Ignore the result entirely since it is statistically significant',
          'Rerun the test with a smaller sample to get a bigger effect'
        ],
        correctIndex: 1,
        explanation: 'Statistical significance confirms the effect is likely real, but the business decision depends on whether the (tiny) practical benefit outweighs the real-world cost — these are two separate questions that must both be answered.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Before launching an A/B test on a checkout page, what should you determine FIRST?',
        options: [
          'Nothing — just launch the test and check results whenever convenient',
          'The required sample size based on baseline conversion rate, minimum detectable effect, and desired statistical power — to ensure the test can reliably detect the effect you care about',
          'The exact final p-value the test will produce',
          'How to peek at results daily for early signs of success'
        ],
        correctIndex: 1,
        explanation: 'Sample size and power planning must happen BEFORE launch — this determines how long the test needs to run and prevents both underpowered tests (missing real effects) and premature stopping.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'End-to-End A/B Test Planning and Analysis Tool',
      goal: 'Build a complete A/B testing workflow tool covering pre-test planning, simulated execution, and post-test business recommendation.',
      steps: [
        'Write calculate_sample_size(baseline_rate, mde, power=0.8, alpha=0.05) using statsmodels.',
        'Simulate an A/B test with the calculated sample size: control and treatment conversion outcomes, with a genuine small effect built in.',
        'Run the statistical test, compute p-value, effect size, and a 95% confidence interval for the difference.',
        'Write translate_to_business(result, revenue_per_conversion, monthly_traffic) that converts the statistical result into an estimated monthly revenue impact.',
        'Print a full recommendation report: statistical significance, effect size, business impact estimate, and a go/no-go recommendation with reasoning.',
      ],
      expectedOutput: 'Sample size correctly calculated before test. Test executed with proper statistics. Business impact translation is clear and correctly derived. Final recommendation is well-justified.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'data_wrangling_scale_ds4',
    topicTitle: 'Data Wrangling at Scale',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 35,
    totalXp: 155,
    emoji: '🧹',
    intro: 'Real company data rarely comes as one clean CSV. It arrives as multiple files, inconsistent formats, and datasets too large to comfortably fit your intuition. This lesson covers combining, reshaping, and efficiently processing data at a scale beyond simple single-table exercises.',
    concepts: [
      ConceptLesson(
        title: 'Combining Data from Multiple Sources',
        definition: 'Real projects require combining data from several files or systems: concatenating similar files (multiple months of logs), merging related tables (customers + orders + products), and reconciling mismatched schemas (different column names for the same concept).',
        analogy: 'Combining scattered data sources is like assembling a jigsaw puzzle where the pieces came from three different boxes — some pieces fit together immediately, some need careful matching by shape (join keys), and some pieces from different boxes turn out to be duplicates.',
        example: 'A real analysis might require: concatenating 12 monthly CSV exports into one yearly dataset, merging that with a separate customer master table, and reconciling that "city" is spelled differently ("Mumbai" vs "Bombay") across the two sources before joining reliably.',
        keyTakeaway: 'Always verify row counts and check for unexpected duplicates immediately after every concat or merge operation — silent data multiplication or loss during combination is one of the most common sources of incorrect downstream analysis.',
        codeSnippet: 'import pandas as pd\n\njan = pd.DataFrame({"id":[1,2], "sales":[100,200]})\nfeb = pd.DataFrame({"id":[3,4], "sales":[150,250]})\nyearly = pd.concat([jan, feb], ignore_index=True)\nprint(f"Combined rows: {len(yearly)}")  # verify count matches expectation',
      ),
      ConceptLesson(
        title: 'Reshaping Data: Wide vs Long Format',
        definition: 'melt() converts wide-format data (one column per category) into long format (one row per observation) — the format most plotting and modeling tools expect. pivot()/unstack() do the reverse, converting long to wide.',
        analogy: 'Wide format is like a spreadsheet with a separate column for each month\'s sales — easy for humans to read at a glance. Long format is like a database log with one row per (month, sales) pair — easier for computers to filter, group, and plot programmatically. melt() converts between these two "views" of the same data.',
        example: 'A wide dataset with columns Jan_sales, Feb_sales, Mar_sales must be melted into long format (columns: month, sales) before Seaborn can plot a proper trend line — most visualization and modeling libraries expect long format, not wide.',
        keyTakeaway: 'When a plotting function or groupby operation seems awkward with your current data shape, ask whether melt() (wide→long) or pivot() (long→wide) would make the operation natural — reshaping is often the missing step, not a more complex function.',
        codeSnippet: 'import pandas as pd\n\nwide = pd.DataFrame({\n    "product": ["A", "B"],\n    "Jan": [100, 150], "Feb": [120, 130], "Mar": [110, 160]\n})\n\nlong = wide.melt(id_vars="product", var_name="month", value_name="sales")\nprint(long)',
      ),
      ConceptLesson(
        title: 'Efficient Processing for Larger Datasets',
        definition: 'When datasets grow large, techniques like reading in chunks (chunksize parameter), choosing efficient dtypes (category instead of object for repeated strings), and using vectorized operations instead of loops become essential for keeping analysis fast and memory-manageable.',
        analogy: 'Processing a huge file in chunks is like eating a large meal in manageable bites instead of trying to swallow it whole — you process what fits comfortably, handle it, then move to the next portion, rather than choking your system by loading everything into memory at once.',
        example: 'A 5GB CSV that won\'t fit in memory can be processed with pd.read_csv(file, chunksize=100000), aggregating results chunk by chunk. Converting a "city" column with only 50 unique values (repeated a million times) from object to category dtype can cut memory usage dramatically.',
        keyTakeaway: 'Before reaching for distributed tools like Spark, try: reducing dtype memory footprint (category, smaller int types), reading only needed columns (usecols), and processing in chunks — these often solve "my data is too big" problems without new infrastructure.',
        codeSnippet: 'import pandas as pd\n\n# Memory-efficient dtype for repeated categorical strings\ndf = pd.DataFrame({"city": ["Mumbai","Delhi","Mumbai","Delhi"]*250000})\nprint(f"object dtype: {df.memory_usage(deep=True).sum()/1e6:.1f} MB")\n\ndf["city"] = df["city"].astype("category")\nprint(f"category dtype: {df.memory_usage(deep=True).sum()/1e6:.1f} MB")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'After concatenating 12 monthly CSV files, the resulting DataFrame has fewer rows than the sum of all individual files. What should you investigate?',
        options: [
          'Nothing — this is completely normal and expected',
          'Whether ignore_index=True was used correctly, and check for accidental deduplication or a filtering step that removed rows unexpectedly — row counts should be verified after every combination operation',
          'The CSV files must be corrupted beyond use',
          'Pandas always drops 10% of rows during concatenation'
        ],
        correctIndex: 1,
        explanation: 'Unexpected row count changes after combining data always warrant investigation — silent row loss (or duplication) is a common and dangerous source of incorrect downstream results, and verifying counts is a standard sanity check.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A dataset has columns Jan_sales, Feb_sales, Mar_sales (one column per month) and you need to create a line plot of sales over time using Seaborn. What should you do first?',
        options: [
          'Plot directly — Seaborn handles wide format automatically for time trends',
          'Use melt() to reshape the wide-format data into long format (columns: month, sales) — most plotting libraries expect one row per observation',
          'Delete two of the three month columns to simplify the data',
          'Convert all values to strings before plotting'
        ],
        correctIndex: 1,
        explanation: 'Seaborn and most plotting/modeling tools expect long-format data (one row per observation). melt() converts the wide monthly columns into a single "month" and "sales" column pair suitable for a proper trend line plot.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You need to join a 2GB "orders" file with a "customers" reference table, but the orders file does not fit comfortably in memory. What is a reasonable first approach?',
        options: [
          'Give up and request more expensive hardware immediately',
          'Read the orders file in chunks with chunksize, process/aggregate each chunk against the (smaller) customers table, and combine partial results — avoiding loading the entire file at once',
          'Delete random rows from the orders file until it fits',
          'Convert the entire orders file to a Python list before processing'
        ],
        correctIndex: 1,
        explanation: 'Chunked reading lets you process a large file incrementally against a smaller reference table without ever holding the full dataset in memory — a standard, low-cost first solution before reaching for distributed computing tools.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Multi-Source Data Consolidation Pipeline',
      goal: 'Build a data wrangling pipeline that combines multiple simulated data sources, reshapes them, and optimizes memory usage.',
      steps: [
        'Simulate 4 monthly CSV-like DataFrames (orders) with slightly inconsistent column naming, plus one separate "customers" reference DataFrame.',
        'Write a function to standardize column names across all 4 monthly files before concatenating them into one yearly dataset, verifying row counts at each step.',
        'Merge the combined orders data with the customers reference table (left join), checking for row count changes.',
        'Reshape a wide-format monthly summary (one column per month) into long format using melt() and produce a trend visualization.',
        'Measure and report memory usage before and after converting appropriate columns to category dtype.',
      ],
      expectedOutput: 'All 4 monthly files correctly combined with row-count verification at each step. Merge completed without unexpected row multiplication. Reshaping and visualization correct. Memory savings clearly reported.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'sql_for_data_scientists_ds4',
    topicTitle: 'SQL for Data Scientists',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 40,
    totalXp: 165,
    emoji: '🗄️',
    intro: 'Company data almost always lives in a database, not a CSV on your laptop. SQL is the language you use to pull exactly the data you need before Python analysis even begins — it is a non-negotiable skill for every professional data scientist and a guaranteed interview topic.',
    concepts: [
      ConceptLesson(
        title: 'SELECT, WHERE, GROUP BY: The Core Query Pattern',
        definition: 'The foundational SQL query structure — SELECT chooses columns, FROM specifies the table, WHERE filters rows, GROUP BY aggregates by category, and ORDER BY sorts results — covers the vast majority of everyday data-pulling needs.',
        analogy: 'A SQL query reads almost like an English sentence describing exactly what you want: "SELECT the customer name and total spend, FROM the orders table, WHERE the order date is this year, GROUP BY customer, ORDER BY total spend descending" — SQL was deliberately designed to be readable this way.',
        example: 'SELECT region, SUM(revenue) as total_revenue FROM sales WHERE order_date >= \'2024-01-01\' GROUP BY region ORDER BY total_revenue DESC — this single query answers "which regions generated the most revenue this year?" directly from a database with millions of rows.',
        keyTakeaway: 'SQL\'s logical execution order is FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY, even though you write SELECT first. Understanding this order explains why you cannot use a SELECT alias inside a WHERE clause, but often can in ORDER BY.',
        codeSnippet: '-- Top 5 highest-spending customers this year\nSELECT customer_id, SUM(amount) AS total_spend\nFROM orders\nWHERE order_date >= \'2024-01-01\'\nGROUP BY customer_id\nORDER BY total_spend DESC\nLIMIT 5;',
      ),
      ConceptLesson(
        title: 'JOINs: Combining Data Across Tables',
        definition: 'JOINs combine rows from two or more tables based on a related column. INNER JOIN keeps only matching rows; LEFT JOIN keeps all rows from the left table with NULLs where no match exists — the SQL equivalent of Pandas merge().',
        analogy: 'A database rarely stores everything in one giant table — customer info lives in one table, orders in another, products in a third — exactly like separate filing cabinets. A JOIN is the act of physically laying documents from two cabinets side by side, matched by a shared reference number (the key).',
        example: 'SELECT c.name, o.order_date, o.amount FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id retrieves each customer\'s name alongside their orders — impossible from either table alone, since names and orders live in separate places.',
        keyTakeaway: 'Use INNER JOIN when you only want records that exist in both tables (customers who have placed orders). Use LEFT JOIN when you want to keep all records from the primary table regardless of a match (all customers, including those with zero orders) — choosing the wrong join type silently drops or duplicates rows.',
        codeSnippet: '-- All customers, including those with no orders yet\nSELECT c.name, COUNT(o.order_id) AS order_count\nFROM customers c\nLEFT JOIN orders o ON c.customer_id = o.customer_id\nGROUP BY c.name\nORDER BY order_count ASC;',
      ),
      ConceptLesson(
        title: 'Window Functions in SQL',
        definition: 'SQL window functions (ROW_NUMBER, RANK, LAG, LEAD, SUM() OVER) perform calculations across a set of related rows without collapsing them into a single aggregated row — enabling running totals, rankings, and period comparisons directly in the database.',
        analogy: 'A regular GROUP BY aggregation is like handing back one summary card per group and throwing away the individual details. A window function is like keeping every individual record AND writing a calculated note on each one ("this is rank #3 within your region") — you get both the detail and the calculated context.',
        example: 'SELECT customer_id, order_date, amount, SUM(amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total computes each customer\'s cumulative spend over time, row by row, without collapsing the individual order rows — essential for cohort and retention analysis.',
        keyTakeaway: 'PARTITION BY in a window function is like GROUP BY, but it does not collapse rows — it just defines which rows are "grouped together" for the calculation while keeping every original row intact. This is the key mental distinction from regular aggregation.',
        codeSnippet: '-- Rank customers by spend within each region\nSELECT customer_id, region, total_spend,\n       RANK() OVER (PARTITION BY region ORDER BY total_spend DESC) AS regional_rank\nFROM customer_totals;',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'You want a report showing ALL customers, including those who have never placed an order (with 0 or NULL order data). Which JOIN type is correct?',
        options: [
          'INNER JOIN, since it combines matching rows from both tables',
          'LEFT JOIN with customers as the left table — this keeps every customer row even when there is no matching order, filling in NULLs where no match exists',
          'RIGHT JOIN with orders as the left table',
          'No JOIN is needed for this query'
        ],
        correctIndex: 1,
        explanation: 'LEFT JOIN (with customers as the left/primary table) preserves every customer row regardless of whether a matching order exists — INNER JOIN would incorrectly exclude customers who have never ordered.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the key difference between a regular GROUP BY aggregation and a SQL window function like SUM() OVER (PARTITION BY ...)?',
        options: [
          'They produce identical results in every case',
          'GROUP BY collapses each group into a single summary row, while a window function keeps every original row intact and adds a calculated value alongside each one',
          'Window functions can only be used with COUNT()',
          'GROUP BY is only valid in NoSQL databases'
        ],
        correctIndex: 1,
        explanation: 'This is the defining distinction — GROUP BY reduces data to one row per group, losing row-level detail. Window functions compute the same kind of aggregation but preserve every individual row, adding the calculated context as a new column.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You need to find the top 3 highest-spending customers in EACH region (not overall). Which SQL approach correctly achieves this?',
        options: [
          'ORDER BY total_spend DESC LIMIT 3 — applied to the whole table',
          'Use RANK() OVER (PARTITION BY region ORDER BY total_spend DESC) as a window function, then filter to rows where the rank is 3 or less',
          'GROUP BY region alone, since grouping automatically limits to 3 per group',
          'This cannot be done in SQL and requires exporting to Python'
        ],
        correctIndex: 1,
        explanation: 'PARTITION BY region resets the ranking separately for each region, giving each region its own top-3 ranking — a simple LIMIT 3 on the whole table would only capture the global top 3, likely all from one region.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'SQL Business Reporting Query Set',
      goal: 'Write a complete set of SQL queries answering realistic business questions against a simulated e-commerce schema (customers, orders, products tables).',
      steps: [
        'Define the schema conceptually: customers(customer_id, name, city), orders(order_id, customer_id, product_id, order_date, amount), products(product_id, name, category).',
        'Write a query for total revenue by product category, sorted descending.',
        'Write a query using LEFT JOIN to list all customers and their total order count, including customers with zero orders.',
        'Write a query using a window function to compute each customer\'s running total spend over time (ordered by date).',
        'Write a query using RANK() to find the top 3 customers by spend within each city.',
        'Document each query with a one-line comment explaining the business question it answers.',
      ],
      expectedOutput: 'Five well-documented SQL queries correctly answering: category revenue, all-customer order counts (including zero), running totals per customer, and top-3-per-city rankings — each syntactically correct and using the appropriate JOIN/window function.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'apis_web_data_ds4',
    topicTitle: 'Working with APIs & Web Data',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 145,
    emoji: '🌐',
    intro: 'Not all data comes pre-packaged in a file. Live weather feeds, social media metrics, stock prices, and countless other sources are accessed through APIs. This lesson teaches you to pull structured data from the web programmatically — a common real-world data acquisition skill.',
    concepts: [
      ConceptLesson(
        title: 'REST APIs and JSON Responses',
        definition: 'A REST API is a standardized way for programs to request data over the internet — you send an HTTP request to a specific URL (endpoint), and receive structured data back, almost always in JSON format.',
        analogy: 'Calling an API is like ordering from a restaurant menu over the phone — you specify exactly what you want (the endpoint and parameters), the kitchen (server) prepares it, and you receive a package (JSON response) with exactly the data you ordered, structured in a predictable format.',
        example: 'A weather API endpoint like api.weather.com/v1/current?city=Mumbai returns a JSON response with fields like temperature, humidity, and conditions — this same request pattern applies whether you are pulling weather, stock prices, or social media metrics.',
        keyTakeaway: 'JSON responses map naturally to Python dictionaries and lists — response.json() in the requests library converts the API\'s text response directly into a usable Python object, ready for further processing into a DataFrame.',
        codeSnippet: 'import requests\n\nresponse = requests.get("https://api.example.com/v1/data",\n                        params={"city": "Mumbai"})\nif response.status_code == 200:\n    data = response.json()\n    print(data)\nelse:\n    print(f"Request failed: {response.status_code}")',
      ),
      ConceptLesson(
        title: 'Authentication, Rate Limits and Error Handling',
        definition: 'Most real APIs require authentication (API keys or tokens) to identify who is making requests, enforce rate limits (a maximum number of requests per time period), and return error status codes when something goes wrong — all of which must be handled gracefully in production code.',
        analogy: 'API rate limits are like a library that allows you to check out only 10 books per day — you can still get all the books you need, but you must plan your requests over time rather than trying to grab everything at once, or the library (API) will simply refuse further requests.',
        example: 'A common pattern: send an API key in request headers, check response.status_code (200 = success, 401 = unauthorized, 429 = rate limited), and add time.sleep() between requests to respect rate limits when pulling data for hundreds of items in a loop.',
        keyTakeaway: 'Always check the response status code before assuming success, and wrap API calls in try/except to handle network failures gracefully. Never hardcode API keys directly in shared code — use environment variables or config files kept out of version control.',
        codeSnippet: 'import requests\nimport time\n\napi_key = "YOUR_KEY_HERE"  # in practice, load from environment variable\nheaders = {"Authorization": f"Bearer {api_key}"}\n\nfor city in ["Mumbai", "Delhi", "Bangalore"]:\n    response = requests.get("https://api.example.com/weather",\n                            headers=headers, params={"city": city})\n    if response.status_code == 429:\n        print("Rate limited - waiting...")\n        time.sleep(5)\n    time.sleep(1)   # respect rate limits between calls',
      ),
      ConceptLesson(
        title: 'Converting API Responses into a DataFrame',
        definition: 'API responses (nested JSON) must be flattened and structured into a Pandas DataFrame before analysis — pd.json_normalize() handles nested structures automatically, converting a list of JSON records into clean tabular rows and columns.',
        analogy: 'A raw API response is like a folder of nested sub-folders containing the information you need — json_normalize() is like an assistant who unpacks every sub-folder and lays everything out flat on one desk (a DataFrame), so you can work with it using familiar Pandas tools.',
        example: 'An API returning [{"city": "Mumbai", "weather": {"temp": 32, "humidity": 70}}, ...] has a nested "weather" object inside each record — pd.json_normalize() automatically flattens this into columns like weather.temp and weather.humidity, ready for analysis.',
        keyTakeaway: 'After pulling data from an API, always immediately convert it to a DataFrame and inspect with .head() and .info() — treating API data with the same scrutiny as any CSV (checking types, nulls, unexpected values) prevents downstream surprises.',
        codeSnippet: 'import pandas as pd\n\napi_data = [\n    {"city": "Mumbai", "weather": {"temp": 32, "humidity": 70}},\n    {"city": "Delhi", "weather": {"temp": 28, "humidity": 45}},\n]\n\ndf = pd.json_normalize(api_data)\nprint(df.columns.tolist())   # [\'city\', \'weather.temp\', \'weather.humidity\']\nprint(df)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'An API call returns status_code 429. What does this typically indicate and what is the appropriate response?',
        options: [
          'The request succeeded perfectly and no action is needed',
          'You have hit the API\'s rate limit — the appropriate response is to wait (often using the retry-after header or a fixed delay) before sending further requests',
          'The API key is permanently invalid and must be replaced',
          'The server has crashed and will never respond again'
        ],
        correctIndex: 1,
        explanation: '429 specifically means "Too Many Requests" — the standard, correct response is to slow down and wait before retrying, respecting the API provider\'s rate limits rather than hammering the endpoint with more requests.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is pd.json_normalize() particularly useful when converting API responses to a DataFrame?',
        options: [
          'It automatically deletes any missing values from the API response',
          'It automatically flattens nested JSON structures (objects within objects) into flat DataFrame columns, which manual dictionary parsing would require significant custom code to achieve',
          'It converts API responses into a graphical chart directly',
          'It is required for every DataFrame regardless of the data source'
        ],
        correctIndex: 1,
        explanation: 'API responses are frequently nested (objects inside objects). json_normalize() automatically handles this flattening into clean tabular columns, saving substantial manual parsing effort compared to writing custom flattening logic.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You are pulling data for 500 different product IDs from an API that allows only 60 requests per minute. What is the correct approach?',
        options: [
          'Send all 500 requests as fast as possible in a tight loop',
          'Add appropriate delays (e.g., time.sleep()) between requests to stay within the 60-per-minute limit, and handle 429 responses gracefully if they occur despite pacing',
          'Only pull data for the first 60 products and skip the rest',
          'Rate limits do not apply to data science use cases'
        ],
        correctIndex: 1,
        explanation: 'Respecting the stated rate limit by pacing requests (roughly 1 per second for 60/minute) is the correct, professional approach — combined with handling any 429 responses that occur as a safety net.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'API Data Collection and Analysis Pipeline',
      goal: 'Build a robust pipeline that simulates pulling paginated data from an API, handles errors gracefully, and converts results into an analysis-ready DataFrame.',
      steps: [
        'Simulate an API response function (in Python, no real network call needed) that returns nested JSON data for a list of "products" with occasional simulated errors (rate limit, timeout).',
        'Write fetch_with_retry(product_id, max_retries=3) that handles simulated failures gracefully with retry logic and delays.',
        'Loop through 50 simulated product IDs, collecting successful responses and logging failures separately.',
        'Use pd.json_normalize() to flatten the nested API responses into a clean DataFrame.',
        'Print a summary report: total records collected, records failed after retries, and basic descriptive statistics on the collected data.',
      ],
      expectedOutput: 'Retry logic correctly handles simulated failures. All successful responses correctly flattened into a DataFrame. Summary report accurately reflects collection success/failure counts.',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'feature_engineering_fundamentals_ds4',
    topicTitle: 'Feature Engineering Fundamentals',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 35,
    totalXp: 160,
    emoji: '🛠️',
    intro: 'Raw data rarely feeds directly into a model well. Feature engineering — creating, transforming, and encoding variables — is often what separates a mediocre model from an excellent one. This lesson builds the practical toolkit you will use before every machine learning project starting in Level 5.',
    concepts: [
      ConceptLesson(
        title: 'Encoding Categorical Variables',
        definition: 'Machine learning models require numeric input, so categorical variables (city, product category, plan type) must be converted to numbers — one-hot encoding creates binary columns per category, while label/ordinal encoding assigns integer codes, each appropriate for different situations.',
        analogy: 'One-hot encoding is like giving each category its own dedicated light switch (on/off) — no category is treated as "greater than" another. Label encoding is like assigning each category a rank number — appropriate only when categories have a genuine natural order (like "Low, Medium, High"), otherwise it wrongly implies a mathematical relationship that does not exist.',
        example: 'Encoding a "city" column (no natural order) with label encoding (Mumbai=0, Delhi=1, Bangalore=2) would incorrectly imply Bangalore > Delhi > Mumbai in a mathematical sense — one-hot encoding avoids this by creating separate is_Mumbai, is_Delhi, is_Bangalore columns instead.',
        keyTakeaway: 'Use one-hot encoding for unordered categories (nominal data). Use ordinal/label encoding only for genuinely ordered categories (Low/Medium/High, or Bronze/Silver/Gold). Applying the wrong encoding type introduces a false numeric relationship that can mislead many ML models.',
        codeSnippet: 'import pandas as pd\n\ndf = pd.DataFrame({"city": ["Mumbai", "Delhi", "Mumbai", "Bangalore"]})\none_hot = pd.get_dummies(df, columns=["city"])\nprint(one_hot)\n\n# Ordinal - only for genuinely ordered categories\nsize_map = {"Small": 0, "Medium": 1, "Large": 2}\ndf2 = pd.DataFrame({"size": ["Small", "Large", "Medium"]})\ndf2["size_encoded"] = df2["size"].map(size_map)\nprint(df2)',
      ),
      ConceptLesson(
        title: 'Scaling and Normalizing Numeric Features',
        definition: 'Feature scaling transforms numeric variables onto a comparable range — standardization (mean 0, std 1) or normalization (fixed range like 0-1) — necessary because many ML algorithms are sensitive to the different scales and units of raw features.',
        analogy: 'Comparing "income in rupees" (ranging in lakhs) directly against "age in years" (ranging 18-80) without scaling is like judging a race where one runner\'s distance is measured in kilometers and another\'s in millimeters — the numbers are wildly different scales that need to be put on common footing before fair comparison.',
        example: 'A dataset with income (₹15,000 to ₹500,000) and age (18 to 70) fed directly into a distance-based algorithm like k-nearest neighbors would let income completely dominate the distance calculation simply because its numbers are larger — scaling both to a comparable range fixes this.',
        keyTakeaway: 'StandardScaler (mean 0, std 1) is the most common default choice. Always fit the scaler on TRAINING data only, then apply (transform) the same fitted scaler to test data — fitting separately on train and test data leaks information and produces overly optimistic results.',
        codeSnippet: 'from sklearn.preprocessing import StandardScaler\nimport numpy as np\n\nX_train = np.array([[15000, 25], [45000, 40], [500000, 35]])\nscaler = StandardScaler()\nX_train_scaled = scaler.fit_transform(X_train)   # fit + transform on train\nprint(X_train_scaled)\n\n# For new/test data, only transform (using train-fitted scaler)\nX_test = np.array([[30000, 28]])\nX_test_scaled = scaler.transform(X_test)\nprint(X_test_scaled)',
      ),
      ConceptLesson(
        title: 'Creating New Features from Existing Data',
        definition: 'Feature creation derives new, more informative variables from existing ones — extracting date components (day of week, month), creating interaction terms (combining two features), and building domain-specific ratios (like customer lifetime value / tenure) that capture patterns raw columns miss.',
        analogy: 'Feature creation is like a chef preparing ingredients before cooking — raw flour and eggs (raw features) are useful, but combining and transforming them into dough (engineered features) unlocks what the model can actually "taste" and learn from, often far more than the raw ingredients alone.',
        example: 'A raw "signup_date" column alone tells a model little, but extracting "days_since_signup", "signup_day_of_week", and "signup_month" from it gives the model concrete, learnable signals — customers signing up on weekends might behave differently than weekday signups, a pattern invisible in the raw date.',
        keyTakeaway: 'Good feature engineering usually requires domain knowledge — understanding the business context reveals which derived features (ratios, differences, date components) are likely to be predictive, more so than any purely automated technique.',
        codeSnippet: 'import pandas as pd\n\ndf = pd.DataFrame({\n    "signup_date": pd.to_datetime(["2024-01-15","2024-03-22","2024-06-01"]),\n    "total_spend": [4500, 12000, 800],\n    "num_orders": [3, 15, 1]\n})\n\ndf["signup_month"] = df["signup_date"].dt.month\ndf["signup_dayofweek"] = df["signup_date"].dt.dayofweek\ndf["avg_order_value"] = df["total_spend"] / df["num_orders"]\nprint(df)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'You are encoding a "customer_satisfaction" column with values "Low", "Medium", "High". Which encoding approach is most appropriate?',
        options: [
          'One-hot encoding, since it works for all categorical data equally well',
          'Ordinal/label encoding (Low=0, Medium=1, High=2), because this category genuinely has a natural, meaningful order that the numeric encoding should preserve',
          'Leave it as text since models can process strings directly',
          'Random numeric assignment for each category'
        ],
        correctIndex: 1,
        explanation: 'Satisfaction levels have a genuine natural order (Low < Medium < High), making ordinal encoding appropriate — it correctly preserves this meaningful ranking, unlike one-hot encoding which would treat them as unrelated categories.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why must a feature scaler be fit ONLY on training data, then applied (not re-fit) to test data?',
        options: [
          'Fitting on test data is computationally more expensive',
          'Fitting the scaler on test data would leak information about the test set\'s distribution into the scaling process, producing overly optimistic and unrealistic model evaluation results',
          'Scalers can only be fit once per Python session',
          'This rule only applies to StandardScaler, not other scalers'
        ],
        correctIndex: 1,
        explanation: 'Fitting on test data allows information from the "unseen" evaluation set to influence the transformation applied to training — this data leakage produces evaluation metrics that look better than the model would actually perform on truly new, unseen data.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You have a "product_category" column with 8 unrelated categories (Electronics, Clothing, Food, etc.) for a model that has no natural ranking among them. Which encoding is correct?',
        options: [
          'Ordinal encoding with arbitrary numbers 0-7',
          'One-hot encoding — creating 8 binary columns, since these categories have no natural order and label encoding would falsely imply a ranking',
          'Leave the column as raw text strings',
          'Convert each category name to its string length as a number'
        ],
        correctIndex: 1,
        explanation: 'Unordered categories with no natural ranking should use one-hot encoding to avoid implying a false numeric relationship (like "Food" being mathematically greater than "Electronics") that ordinal encoding would introduce.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Feature Engineering Pipeline for Customer Data',
      goal: 'Build a complete feature engineering pipeline that prepares a raw customer dataset for machine learning, ready for Level 5.',
      steps: [
        'Simulate a raw customer dataset (n=300) with: signup_date, city (5 categories), plan_type (Low/Medium/High - ordered), monthly_spend, num_support_tickets.',
        'Apply one-hot encoding to city and ordinal encoding to plan_type, explaining the reasoning for each choice.',
        'Create 3 new engineered features: tenure_days (from signup_date), spend_per_ticket (ratio), and signup_quarter (from date).',
        'Apply StandardScaler to all numeric features, correctly fitting only on a simulated "training" subset (80%) and transforming a "test" subset (20%).',
        'Print a before/after comparison showing the original raw dataset and the final model-ready feature set.',
      ],
      expectedOutput: 'Categorical encoding correctly applied with justified choices. New features correctly derived. Scaling correctly fit only on training data and applied to test data without leakage. Clear before/after comparison printed.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'dimensionality_reduction_pca_ds4',
    topicTitle: 'Dimensionality Reduction (PCA)',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 150,
    emoji: '🔻',
    intro: 'What happens when your dataset has 50 features and you cannot visualize or intuitively understand it anymore? Dimensionality reduction compresses many correlated features into fewer, information-dense ones — Principal Component Analysis (PCA) is the most widely used technique, and understanding it unlocks visualization and preprocessing for high-dimensional data.',
    concepts: [
      ConceptLesson(
        title: 'The Curse of Dimensionality',
        definition: 'As the number of features grows, data becomes increasingly sparse in the high-dimensional space, distances between points become less meaningful, and models require exponentially more data to generalize well — a phenomenon called the curse of dimensionality.',
        analogy: 'Imagine trying to find your friend in a straight hallway (1 dimension) versus a football field (2 dimensions) versus an entire 3D building (3 dimensions) — as the space grows more dimensions, "nearby" becomes a much weaker concept, and finding meaningful patterns requires exponentially more data points to fill the same relative density.',
        example: 'A dataset with 500 samples and 5 features might have plenty of data density for reliable patterns. The same 500 samples spread across 200 features become extremely sparse — most distance-based and many statistical methods start behaving unpredictably in such high-dimensional, sparse spaces.',
        keyTakeaway: 'More features are not automatically better — beyond a point, adding features without adding proportionally more data hurts model performance and interpretability. Dimensionality reduction directly addresses this by compressing information into fewer, denser dimensions.',
      ),
      ConceptLesson(
        title: 'Principal Component Analysis: Finding the Directions of Maximum Variance',
        definition: 'PCA finds new axes (principal components) that are linear combinations of the original features, ordered so that the first component captures the most variance in the data, the second captures the next most (while being uncorrelated with the first), and so on.',
        analogy: 'PCA is like photographing a 3D object from the single best camera angle that reveals the most detail about its shape — instead of needing all possible angles (dimensions) to understand the object, a few well-chosen "best angle" photos (principal components) capture most of what matters visually.',
        example: 'A dataset with 10 correlated financial indicators (revenue, profit, assets, etc.) might be well-summarized by just 2-3 principal components that capture "overall company size" and "profitability efficiency" — compressing 10 columns into 2-3 while retaining most of the meaningful variation.',
        keyTakeaway: 'PCA requires features to be scaled first (StandardScaler) since it is sensitive to the different scales of raw features — a feature with naturally larger numbers would otherwise dominate the "variance" calculation regardless of its actual importance.',
        codeSnippet: 'from sklearn.decomposition import PCA\nfrom sklearn.preprocessing import StandardScaler\nimport numpy as np\n\nnp.random.seed(42)\nX = np.random.randn(200, 10)   # 200 samples, 10 correlated features\nX_scaled = StandardScaler().fit_transform(X)\n\npca = PCA(n_components=3)\nX_reduced = pca.fit_transform(X_scaled)\nprint(f"Original shape: {X.shape}, Reduced shape: {X_reduced.shape}")\nprint(f"Variance explained: {pca.explained_variance_ratio_}")',
      ),
      ConceptLesson(
        title: 'Choosing the Number of Components',
        definition: 'The explained variance ratio tells you how much of the original data\'s total variance each principal component captures — plotting cumulative explained variance (a "scree plot") helps you choose how many components to keep while retaining most of the meaningful signal.',
        analogy: 'Choosing components is like deciding how many ingredients to keep in a simplified recipe — you want to keep enough (say, the top 5 ingredients contributing 90% of the flavor) while discarding the minor ones that add little, striking a balance between simplicity and fidelity to the original.',
        example: 'If the first 5 principal components out of 20 original features already explain 92% of total variance, reducing to those 5 components loses only 8% of information while dramatically simplifying the dataset for visualization or downstream modeling.',
        keyTakeaway: 'A common rule of thumb is to keep enough components to explain 90-95% of total variance, though the right threshold depends on the specific use case — visualization often uses just 2 components regardless of variance explained, purely for the ability to plot on a 2D chart.',
        codeSnippet: 'from sklearn.decomposition import PCA\nfrom sklearn.preprocessing import StandardScaler\nimport numpy as np\n\nnp.random.seed(42)\nX = np.random.randn(200, 20)\nX_scaled = StandardScaler().fit_transform(X)\n\npca = PCA().fit(X_scaled)\ncumulative_variance = np.cumsum(pca.explained_variance_ratio_)\nn_components_90 = np.argmax(cumulative_variance >= 0.90) + 1\nprint(f"Components needed for 90% variance: {n_components_90}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why must features be scaled (e.g., with StandardScaler) before applying PCA?',
        options: [
          'Scaling is optional and has no real effect on PCA results',
          'PCA identifies directions of maximum variance — without scaling, a feature with naturally larger raw numbers (like income in rupees vs age in years) would dominate the variance calculation regardless of its true importance',
          'PCA only accepts values between 0 and 1',
          'Scaling is only needed for categorical features, which PCA does not use anyway'
        ],
        correctIndex: 1,
        explanation: 'PCA is inherently sensitive to feature scale because it is based on variance — an unscaled feature with large raw values would appear to have disproportionately high "importance" simply due to its units, not its actual informativeness.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'The first 4 principal components of a 15-feature dataset explain 88% of total variance. What does this suggest?',
        options: [
          'The remaining 11 components must be discarded entirely with no consideration',
          'Most of the meaningful variation in the original 15 features can be captured using just 4 compressed dimensions — a substantial reduction in complexity while retaining most of the information',
          'The dataset has no usable patterns at all',
          '88% variance means the PCA computation contains an error'
        ],
        correctIndex: 1,
        explanation: 'Explaining 88% of variance with just 4 out of 15 original dimensions indicates strong redundancy/correlation among the original features — PCA successfully compresses this into far fewer dimensions while retaining most of the meaningful signal.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You want to visualize a dataset with 50 features on a standard 2D scatter plot to look for natural groupings. What is an appropriate approach?',
        options: [
          'Plot 50 separate 2D charts, one for every possible pair of features',
          'Apply PCA to reduce the 50 features to 2 principal components, then create a single 2D scatter plot of those components — a standard technique for visualizing high-dimensional data',
          'Randomly select 2 of the 50 original features and ignore the rest',
          'Visualization is impossible for datasets with more than 3 features'
        ],
        correctIndex: 1,
        explanation: 'Reducing to 2 principal components via PCA is the standard approach for visualizing high-dimensional data — it captures the most important directions of variation into exactly 2 plottable dimensions, unlike arbitrarily picking 2 original features which may miss the most informative patterns.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'PCA-Based Data Compression and Visualization Tool',
      goal: 'Build a tool that applies PCA to a simulated high-dimensional dataset, determines an appropriate number of components, and visualizes the compressed result.',
      steps: [
        'Simulate a dataset with 200 samples and 25 correlated numeric features using NumPy (build in genuine correlation structure, not pure randomness).',
        'Scale the features using StandardScaler before applying PCA.',
        'Fit PCA with all components and plot the cumulative explained variance curve (scree plot).',
        'Determine and print the minimum number of components needed to explain at least 90% of variance.',
        'Reduce the dataset to exactly 2 components and create a scatter plot to visually inspect for any natural groupings.',
      ],
      expectedOutput: 'PCA correctly applied after proper scaling. Scree plot clearly shows cumulative variance curve. Component count for 90% variance correctly identified. 2D visualization successfully created from the high-dimensional data.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'data_storytelling_reporting_ds4',
    topicTitle: 'Data Storytelling & Business Reporting',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 145,
    emoji: '📢',
    intro: 'The best analysis in the world is worthless if no one understands or acts on it. Data storytelling is the skill of translating numbers into a clear narrative that drives decisions — the difference between a data scientist whose work gets ignored and one whose work reshapes the business.',
    concepts: [
      ConceptLesson(
        title: 'Know Your Audience',
        definition: 'The same analysis must be presented completely differently depending on the audience — executives want the bottom-line business impact in seconds, while a fellow data scientist wants methodology and statistical rigor. Matching the depth and language to your audience is the first storytelling decision.',
        analogy: 'Explaining a car\'s engine problem differently to a mechanic (technical detail: "the timing belt is worn") versus to the car owner ("your car needs a repair that costs ₹8,000 and will take 2 days") — same underlying issue, completely different framing based on what the listener actually needs to act on it.',
        example: 'For a CEO: "The new pricing strategy increased revenue by 8%, worth an estimated ₹2 crore annually — recommend full rollout." For a fellow analyst: "We ran a two-sample t-test (n=1200, p=0.002, Cohen\'s d=0.3) after confirming normality via Shapiro-Wilk..." Both describe the same finding at completely different levels of technical depth.',
        keyTakeaway: 'Before writing any report or presentation, explicitly ask: who is reading this, what decision are they trying to make, and what is the minimum detail they need to make it confidently? Answering this reshapes every subsequent communication choice.',
      ),
      ConceptLesson(
        title: 'Structuring a Data Narrative',
        definition: 'An effective data story follows a clear arc: context (why does this matter), finding (what did we discover), evidence (how do we know), and recommendation (what should happen next) — mirroring how humans naturally process and remember information.',
        analogy: 'A data narrative structure mirrors a good news article: the headline states the key finding upfront (not buried at the end), the body provides supporting evidence, and it closes with implications — readers should be able to stop after the first paragraph and still understand the main point.',
        example: 'Weak structure: "We analyzed 50,000 transactions using multiple statistical tests including..." (buries the point). Strong structure: "Customer churn increased 15% this quarter, driven primarily by support wait times exceeding 24 hours — we recommend hiring 3 additional support agents." (leads with the finding and action).',
        keyTakeaway: 'Lead with the conclusion, not the methodology. Executives and stakeholders decide within the first 10 seconds whether to keep reading — put your main finding and recommendation in the very first sentence, then support it with evidence for those who want more.',
      ),
      ConceptLesson(
        title: 'Choosing Honest, Effective Visuals for Communication',
        definition: 'Communication visuals differ from exploratory analysis visuals — they should be simplified, focused on one clear message per chart, properly labeled, and never manipulated (like truncated y-axes) to make an effect look more dramatic than it genuinely is.',
        analogy: 'An exploratory chart is like a messy engineer\'s whiteboard full of every possible idea — useful for your own thinking. A communication chart is like a polished road sign — stripped down to exactly one clear message that a passing driver can absorb in two seconds without confusion.',
        example: 'A bar chart with a y-axis starting at 95 (not 0) can make a 2% difference look like a massive gap visually — this is a common, sometimes unintentional way charts mislead. Honest communication either starts bar charts at zero or clearly annotates the axis truncation.',
        keyTakeaway: 'One chart, one message. Remove gridlines, excess decimal places, and chart clutter that do not serve the specific point you are making. Always label axes and units clearly — a chart that requires a paragraph of explanation to understand has failed at its communication job.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A data scientist is preparing the SAME analysis findings for both a company CEO and a fellow data science colleague. What should differ between the two presentations?',
        options: [
          'Nothing — the exact same technical report should be sent to both audiences',
          'The level of technical depth and framing should adapt to each audience — the CEO needs the bottom-line business impact and recommendation quickly, while the colleague may want full methodology and statistical detail',
          'Only the colleague needs to see any charts or visuals',
          'The CEO should receive false, simplified numbers different from the true results'
        ],
        correctIndex: 1,
        explanation: 'The underlying facts stay identical, but the framing, depth, and language should be tailored to what each audience needs to understand and act on — this is not about changing the truth, only its presentation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is it considered misleading to create a bar chart where the y-axis starts at 95 instead of 0, when comparing values that are, say, 96 vs 98?',
        options: [
          'It is a standard and completely acceptable data visualization practice with no concerns',
          'Truncating the y-axis visually exaggerates the difference between the bars, making a small 2-point difference look dramatically larger than it actually is — potentially misleading the viewer',
          'Charts must always include every possible number from 0 to infinity',
          'This technique is required by all professional style guides'
        ],
        correctIndex: 1,
        explanation: 'A truncated y-axis can make small differences look visually dramatic, potentially misleading viewers about the true magnitude of a difference — honest visualization either starts at zero or clearly flags the axis truncation to the viewer.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A report opens with: "We conducted a comprehensive multi-week analysis using seventeen different statistical techniques across four data sources before determining..." What is the primary storytelling issue with this opening?',
        options: [
          'The opening is perfect and should be used as-is',
          'It buries the actual finding and recommendation, forcing the reader to wade through methodology before reaching the point that actually matters to them — the key finding should lead, not trail',
          'The opening does not mention enough technical detail',
          'Reports should never mention methodology anywhere'
        ],
        correctIndex: 1,
        explanation: 'Effective data storytelling leads with the finding and recommendation, then supports it with methodology for those who want depth — burying the actual conclusion under process description loses the reader\'s attention before the point is even made.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Two-Audience Business Report',
      goal: 'Take a single set of analysis findings and produce two distinctly tailored reports — one for executives, one for a technical peer — demonstrating audience-aware data storytelling.',
      steps: [
        'Simulate an analysis result: a marketing campaign A/B test showing a statistically significant 12% conversion lift (p=0.01, 95% CI: 6-18%, n=2000 per group).',
        'Write a 4-6 sentence EXECUTIVE summary: lead with the business impact and recommendation, minimal statistical jargon, clear next step.',
        'Write a 2-paragraph TECHNICAL summary: methodology, statistical test used, assumptions checked, full results with confidence interval and effect size.',
        'Design one simple, honestly-labeled bar chart appropriate for the executive audience (properly zero-based y-axis, single clear message).',
        'Write a short reflection (3-4 sentences) explaining the specific framing and detail-level choices made for each audience.',
      ],
      expectedOutput: 'Two clearly distinct reports for the two audiences, both accurately representing the same underlying results. Executive summary leads with impact/recommendation. Technical summary includes full statistical rigor. Chart is honest and audience-appropriate.',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'capstone_eda_project_ds4',
    topicTitle: 'Capstone: End-to-End EDA Project',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 70,
    totalXp: 220,
    emoji: '🏆',
    intro: 'This is your Level 4 capstone — take a realistic, messy, multi-source dataset all the way from raw files to a polished business report, using every skill from this level: advanced Pandas, SQL-style joins, feature engineering, dimensionality reduction, and audience-aware storytelling. This is exactly the kind of project that belongs in a professional portfolio.',
    concepts: [
      ConceptLesson(
        title: 'The Full Analyst Workflow, End to End',
        definition: 'A complete real-world analysis moves through distinct phases in sequence: acquire and combine data, clean and validate it, engineer useful features, explore and visualize patterns, and finally communicate findings as a business report — each phase builds directly on the previous one.',
        analogy: 'This workflow is like renovating a house: you cannot install furniture (visualization/reporting) before the walls are built (feature engineering), and you cannot build walls before the foundation is properly laid and inspected (data cleaning and validation) — skipping or reordering steps causes problems downstream.',
        example: 'A real capstone-style project: combine 3 months of sales files with a customer master table (data wrangling), clean inconsistent city names and handle missing ages (cleaning), create tenure and spend-ratio features (feature engineering), find the top revenue-driving segments (EDA), and present a 1-page recommendation to a hypothetical VP of Sales (reporting).',
        keyTakeaway: 'Professional data science is rarely about one clever technique — it is about executing this complete pipeline reliably, end to end, on real messy data. Employers evaluate portfolio projects on whether this full workflow was followed rigorously, not just on the sophistication of any single step.',
      ),
      ConceptLesson(
        title: 'Documenting Your Analysis Process',
        definition: 'A professional analysis includes clear documentation of decisions made along the way — why certain outliers were kept or removed, why a particular encoding was chosen, what assumptions were made — so that another data scientist (or your future self) can understand and trust the work.',
        analogy: 'Documenting your analysis is like a scientist keeping a detailed lab notebook — not just recording the final result, but every meaningful decision and reasoning along the way, so the experiment could be understood, questioned, or reproduced by someone else entirely.',
        example: 'A well-documented notebook includes markdown cells like: "Dropped 12 rows with negative revenue values, likely data entry errors — verified these represented <0.5% of total records" — this single sentence saves a future reader from having to reverse-engineer why the row count changed.',
        keyTakeaway: 'Every non-obvious decision in your pipeline (dropping data, choosing an encoding, picking a threshold) deserves a one-sentence justification. This habit is what separates a portfolio project that impresses a hiring manager from one that raises unanswered questions.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'In a complete end-to-end analysis workflow, why must data cleaning happen BEFORE feature engineering rather than after?',
        options: [
          'The order does not actually matter for the final result',
          'Feature engineering builds new columns (like ratios or date extractions) from existing ones — if the underlying data still contains errors or missing values, those problems propagate into and corrupt the newly engineered features as well',
          'Feature engineering is always optional and can be skipped entirely',
          'Cleaning is only needed for categorical columns, not numeric ones'
        ],
        correctIndex: 1,
        explanation: 'Engineered features are derived from raw columns — uncleaned errors (bad values, missing data) in the raw data would directly corrupt any features built on top of them, making the cleaning step a necessary prerequisite, not an optional later step.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is documenting the reasoning behind analysis decisions (like why certain rows were dropped) considered a professional best practice?',
        options: [
          'It has no real value and just adds unnecessary extra work',
          'It allows another data scientist (or your future self) to understand, trust, question, or reproduce the analysis, rather than having to reverse-engineer undocumented decisions later',
          'Documentation is only required for government projects',
          'It is only useful for very small datasets'
        ],
        correctIndex: 1,
        explanation: 'Clear documentation of reasoning builds trust and reproducibility into an analysis — without it, anyone reviewing the work (including the original analyst months later) cannot verify whether decisions were sound or arbitrary.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You are building a portfolio project to show potential employers. Which approach makes the strongest impression?',
        options: [
          'A single complex model with no explanation of the data preparation that preceded it',
          'A complete, well-documented workflow showing data acquisition, cleaning decisions with reasoning, feature engineering, exploratory findings, and a clear business-facing summary at the end',
          'Just the final chart with no supporting code or explanation',
          'Raw, unprocessed data with no analysis at all'
        ],
        correctIndex: 1,
        explanation: 'Employers evaluating portfolio projects want to see the complete, well-reasoned analytical process — not just a final polished result — because it demonstrates real-world readiness across the entire data science workflow, not just one narrow skill.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Retail Business Intelligence Capstone',
      goal: 'Execute a complete end-to-end EDA project on a simulated multi-source retail dataset, producing a portfolio-quality analysis and business report.',
      steps: [
        'DATA ACQUISITION: Simulate 3 monthly transaction files (with slightly inconsistent formatting) plus a separate customer master table and a product reference table.',
        'DATA WRANGLING: Combine the monthly files (verifying row counts), merge with customer and product tables (appropriate join types), and standardize inconsistent categorical values.',
        'DATA CLEANING: Identify and handle missing values, duplicates, and outliers, documenting the reasoning for each decision made.',
        'FEATURE ENGINEERING: Create at least 4 new features (e.g., tenure, spend ratios, date components, customer segment flags) with appropriate encoding for any categorical variables.',
        'EXPLORATORY ANALYSIS: Compute descriptive statistics, correlation analysis, and apply PCA to visualize customer segments in 2D if using many numeric features.',
        'BUSINESS REPORT: Write a two-part report — a short executive summary with the top 3 actionable insights and recommendations, plus a technical appendix documenting methodology and key decisions.',
      ],
      expectedOutput: '=== RETAIL BUSINESS INTELLIGENCE CAPSTONE ===\nData Sources Combined: 3 monthly files + customer + product tables\nRows After Cleaning: [count] (X% removed, with documented reasoning)\nFeatures Engineered: 4+ new columns created\nKey EDA Findings: [correlation insights, PCA visualization]\n\nExecutive Summary:\n1. [Top insight with business recommendation]\n2. [Second insight with business recommendation]\n3. [Third insight with business recommendation]\n\nLevel 4 Complete — Data Analysis & Statistical Thinking Mastered.\nReady for Level 5: Machine Learning Foundations.',
      xpReward: 120,
    ),
  ),

];