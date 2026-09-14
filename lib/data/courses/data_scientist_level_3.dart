import '../../models/course_content_data.dart';

const List<TopicCourse> dataScientistLevel3 = [

  TopicCourse(
    id: 'descriptive_statistics_ds3',
    topicTitle: 'Descriptive Statistics',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 140,
    emoji: '📐',
    intro: 'Before any model, any chart, any insight — there is description. Descriptive statistics summarize a dataset\'s central tendency, spread, and shape in a handful of numbers. Every data scientist reaches for these first, on every new dataset, before doing anything else.',
    concepts: [
      ConceptLesson(
        title: 'What Descriptive Statistics Actually Describe',
        definition: 'Descriptive statistics summarize the main features of a dataset — where its values are centered, how spread out they are, and what shape the distribution takes — without drawing conclusions beyond the data itself.',
        analogy: 'Descriptive statistics are like a weather report for a city: "average 28°C, ranges from 18-38°C, mostly clear." It does not predict tomorrow\'s weather (that is inference) — it just honestly summarizes what has already happened, condensing thousands of daily readings into a few numbers a person can hold in their head.',
        example: 'Given 10,000 customer order values, you cannot read every value. Descriptive statistics compress this into: mean ₹2,450, median ₹1,800, std dev ₹1,900, min ₹50, max ₹45,000. Immediately you know most orders are moderate, but a few large ones pull the average up — insight from six numbers instead of ten thousand.',
        keyTakeaway: 'Descriptive statistics answer "what does the data look like" — they never claim to explain "why" or predict "what next." That distinction (description vs inference) is the foundation every other statistics topic in this level builds on.',
        codeSnippet: 'import pandas as pd\n\norders = pd.Series([1200, 800, 45000, 1500, 2200, 950, 1800, 3200])\nprint(orders.describe())\n# count, mean, std, min, 25%, 50%, 75%, max — one line, full summary',
      ),
      ConceptLesson(
        title: 'Measures of Central Tendency at a Glance',
        definition: 'Central tendency measures — mean, median, mode — each answer "what is typical?" differently: mean is the arithmetic balance point, median is the middle value, mode is the most frequent value.',
        analogy: 'Three people trying to describe the "typical" house price on a street will disagree if one mansion sits among modest homes: the mean is dragged toward the mansion, the median ignores it, the mode reports whichever price repeats most (often none, for continuous prices).',
        example: 'Salaries at a 20-person startup: 19 earn ₹8L, the founder earns ₹80L. Mean ≈ ₹11.6L (misleading — no one earns close to that). Median = ₹8L (accurately typical). This single example is why median is preferred for skewed data like income and property prices.',
        keyTakeaway: 'When mean and median diverge significantly, the data is skewed — investigate before reporting either number alone. Reporting mean salary without mentioning this gap is a common way statistics mislead, even unintentionally.',
        codeSnippet: 'salaries = [800000]*19 + [8000000]\nimport statistics\nprint(statistics.mean(salaries))    # ~1,160,000 - misleading\nprint(statistics.median(salaries))  # 800,000 - typical',
      ),
      ConceptLesson(
        title: 'Shape of a Distribution: Skewness and Kurtosis',
        definition: 'Skewness measures asymmetry (which tail is longer); kurtosis measures "tailedness" (how often extreme values occur compared to a normal distribution). Together they describe a distribution\'s shape beyond center and spread.',
        analogy: 'Skewness is like a seesaw with a long plank on one side — the distribution leans and stretches toward the heavier tail. Kurtosis is like comparing a mountain\'s peak sharpness — a sharp narrow peak with fat edges (high kurtosis) versus a smooth, evenly rounded hill (low kurtosis).',
        example: 'House prices are almost always right-skewed (skewness > 0): most houses cluster at moderate prices, a few mansions stretch the right tail far out. Test scores capped at 100 are often left-skewed if the test was easy — most students near 100, a few far below.',
        keyTakeaway: 'Positive skew (right tail): mean > median. Negative skew (left tail): mean < median. Recognizing skew before modeling tells you whether to transform the data (e.g., log transform) or use robust statistics like the median.',
        codeSnippet: 'import pandas as pd\ndata = pd.Series([10,12,11,13,12,14,80,11,13,12])\nprint(f"Skew: {data.skew():.2f}")       # positive - right-skewed\nprint(f"Kurtosis: {data.kurt():.2f}")   # heavy tail from the 80',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A dataset has mean = ₹95,000 and median = ₹62,000. What does this gap most likely indicate?',
        options: [
          'The data is perfectly symmetric',
          'The distribution is right-skewed — a few very large values are pulling the mean above the median',
          'The dataset contains an error and should be discarded',
          'The mean is always wrong when it differs from the median'
        ],
        correctIndex: 1,
        explanation: 'Mean noticeably above median is the classic signature of right skew — a handful of large outlier values inflate the mean while the median stays representative of the "typical" value.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is the mode less commonly used than mean or median for continuous numeric data (like height or income)?',
        options: [
          'Mode cannot be calculated for numeric data at all',
          'Continuous data rarely has exact repeated values, so the mode is often undefined or uninformative unless the data is binned into ranges first',
          'Mode is only valid for negative numbers',
          'Mode always equals the mean for continuous data'
        ],
        correctIndex: 1,
        explanation: 'With continuous measurements, exact repeats are rare (two people rarely have the exact same height to the decimal), so the mode is more meaningful for categorical or binned/discrete data than raw continuous values.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A retailer\'s daily revenue has mean ₹50,000, median ₹48,000, and low skewness (~0.1). What can you reasonably conclude?',
        options: [
          'The data is heavily right-skewed with major outliers',
          'The distribution is fairly symmetric — mean and median are close, and skewness near 0 confirms no strong tail pulling values in either direction',
          'The median is calculated incorrectly',
          'There is no way to draw any conclusion from this'
        ],
        correctIndex: 1,
        explanation: 'Mean and median close together, plus skewness near zero, both point to a roughly symmetric distribution — daily revenue values are fairly evenly spread around the center without a dominant tail.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Descriptive Statistics Report Generator',
      goal: 'Build a function that generates a complete descriptive statistics report for any numeric dataset.',
      steps: [
        'Create a simulated dataset of 100 e-commerce order values using NumPy, with a few deliberate large outliers.',
        'Write describe_dataset(data) that returns mean, median, mode (via binning), std dev, min, max, skewness, and kurtosis.',
        'Compare mean vs median and print an automatic interpretation ("right-skewed" / "left-skewed" / "roughly symmetric").',
        'Visualize the distribution with a histogram, marking mean and median as vertical lines.',
        'Print a plain-language summary of what the statistics reveal about typical order value.',
      ],
      expectedOutput: 'All statistics computed correctly. Automatic skew interpretation matches the actual skewness value. Histogram clearly shows mean/median lines and the outlier tail.',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'probability_fundamentals_ds3',
    topicTitle: 'Probability Fundamentals',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 140,
    emoji: '🎲',
    intro: 'Probability is the mathematics of uncertainty — and every prediction, every confidence interval, every machine learning classifier is fundamentally a statement about probability. This lesson builds the core vocabulary: events, sample spaces, conditional probability, and independence.',
    concepts: [
      ConceptLesson(
        title: 'Sample Spaces, Events and Basic Probability',
        definition: 'A sample space is the set of all possible outcomes of a random process. An event is any subset of outcomes we care about. Probability assigns a number between 0 and 1 to each event, representing how likely it is.',
        analogy: 'The sample space is like the complete menu at a restaurant — every dish that could possibly be ordered. An event is a category you care about, like "vegetarian dishes." Probability is the fraction of the menu (weighted by how often each dish is actually ordered) that falls into that category.',
        example: 'For a fair six-sided die, the sample space is {1,2,3,4,5,6}. The event "rolling an even number" is {2,4,6} — probability 3/6 = 0.5. In data science, the sample space might be "all possible customer actions" and the event "customer churns this month."',
        keyTakeaway: 'Every probability model starts by clearly defining the sample space and the event of interest — vague definitions here cause errors in every downstream calculation, no matter how sophisticated the math that follows.',
        codeSnippet: 'import random\nrandom.seed(42)\ntrials = [random.randint(1, 6) for _ in range(10000)]\nprob_even = sum(1 for x in trials if x % 2 == 0) / len(trials)\nprint(f"P(even) ≈ {prob_even:.3f}")  # approaches 0.5',
      ),
      ConceptLesson(
        title: 'Conditional Probability: Updating Beliefs with New Information',
        definition: 'Conditional probability P(A|B) is the probability of event A occurring given that event B has already occurred — it updates our probability estimate when we gain new relevant information.',
        analogy: 'Conditional probability is like adjusting your estimate of rain today after learning it is currently cloudy. Your baseline estimate ("probability of rain on any given day") changes once you condition on new evidence ("given that it is cloudy right now").',
        example: 'P(customer churns) might be 5% overall. But P(customer churns | had 3+ support complaints last month) might be 40%. This conditional probability is far more actionable for a retention team than the unconditional baseline rate.',
        keyTakeaway: 'P(A|B) = P(A and B) / P(B). Conditioning on the right variable is often more valuable in data science than any single unconditional statistic — it is the foundation of every predictive model, which is essentially computing P(outcome | features).',
        codeSnippet: 'import pandas as pd\ndf = pd.DataFrame({\n    "complaints": [0,3,1,4,0,2,0,5],\n    "churned":    [0,1,0,1,0,0,0,1]\n})\nhigh_complaints = df[df["complaints"] >= 3]\np_churn_given_complaints = high_complaints["churned"].mean()\nprint(f"P(churn | complaints>=3) = {p_churn_given_complaints:.2f}")',
      ),
      ConceptLesson(
        title: 'Independence and the Multiplication Rule',
        definition: 'Two events are independent if the occurrence of one does not affect the probability of the other — P(A|B) = P(A). For independent events, P(A and B) = P(A) × P(B).',
        analogy: 'Independence is like two separate coin flips in different rooms — the outcome of one has zero effect on the other. Contrast this with drawing two cards from a deck without replacement, where the first draw changes the probabilities for the second (dependent events).',
        example: 'Assuming website conversion and time-of-day are independent (they might not be!) would let you multiply their probabilities. Checking independence assumptions — rather than blindly assuming them — is a frequent, important step before applying simplified probability formulas.',
        keyTakeaway: 'Never assume independence without checking — falsely assuming independence is one of the most common sources of incorrect probability calculations in real analyses, especially with correlated business metrics.',
        codeSnippet: 'p_click = 0.10\np_purchase_given_click = 0.20\n# NOT independent - purchase depends on click, so multiply conditionally\np_click_and_purchase = p_click * p_purchase_given_click\nprint(f"P(click and purchase) = {p_click_and_purchase:.3f}")  # 0.02',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'P(rain) = 0.3. P(rain | cloudy morning) = 0.7. What does this comparison tell you?',
        options: [
          'The two probabilities should always be equal',
          'A cloudy morning is informative — it substantially raises the probability of rain compared to the baseline, meaning cloud cover and rain are not independent',
          'The calculation must contain an error since conditional probability cannot exceed unconditional probability',
          'Cloudy mornings cause rain with certainty'
        ],
        correctIndex: 1,
        explanation: 'Conditional probability CAN differ substantially from unconditional probability — that difference is exactly what makes conditioning valuable. Here, cloud cover is clearly informative about rain likelihood.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Two events A and B are independent. What is the correct formula for P(A and B)?',
        options: [
          'P(A) + P(B)',
          'P(A) × P(B)',
          'P(A) / P(B)',
          'P(A) - P(B)'
        ],
        correctIndex: 1,
        explanation: 'For independent events, the multiplication rule applies directly: P(A and B) = P(A) × P(B). This only holds under independence — dependent events require conditional probability instead.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You want to know P(customer buys premium plan | customer is on a free trial > 14 days). Which approach is correct?',
        options: [
          'Multiply the overall premium purchase rate by 14',
          'Filter the dataset to only customers with trial > 14 days, then compute the fraction of THAT subset who bought premium',
          'Use the unconditional premium purchase rate for all customers regardless of trial length',
          'Assume the two events are independent and skip conditioning entirely'
        ],
        correctIndex: 1,
        explanation: 'Conditional probability requires restricting the analysis to the conditioning subset first (trial > 14 days), then computing the rate of the event of interest within that subset — not applying the overall rate.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Conditional Probability Analyzer for Customer Behavior',
      goal: 'Analyze a simulated customer dataset to compute and compare conditional probabilities of churn under different conditions.',
      steps: [
        'Simulate 500 customers with: tenure_months, support_tickets, plan_type, and churned (0/1) using NumPy with realistic correlations built in.',
        'Compute the unconditional churn rate for the full dataset.',
        'Compute conditional churn rates: P(churn | support_tickets >= 3), P(churn | tenure < 3 months), P(churn | plan_type == "Basic").',
        'Check whether support_tickets and churn appear independent by comparing conditional vs unconditional probabilities.',
        'Print a ranked report of which condition is most predictive of churn.',
      ],
      expectedOutput: 'Unconditional and all conditional probabilities computed correctly. Clear ranking of which factor most strongly predicts churn, with an independence check explained in plain language.',
      xpReward: 55,
    ),
  ),

  TopicCourse(
    id: 'probability_distributions_ds3',
    topicTitle: 'Probability Distributions',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 35,
    totalXp: 150,
    emoji: '📈',
    intro: 'A probability distribution describes how likely each possible outcome is for a random variable. From the normal distribution underlying natural measurements to the binomial distribution underlying yes/no outcomes, these mathematical shapes appear everywhere in real data.',
    concepts: [
      ConceptLesson(
        title: 'Random Variables: Discrete vs Continuous',
        definition: 'A random variable maps outcomes of a random process to numbers. Discrete random variables take countable values (number of defects, customer count). Continuous random variables take any value in a range (height, temperature, revenue).',
        analogy: 'A discrete random variable is like counting whole coins in a jar — you get 0, 1, 2, 3 coins, never 2.5. A continuous random variable is like measuring the exact water level in that jar — it can be any value along a continuous scale, including infinitely many decimal points.',
        example: 'Number of support tickets a customer files this month is discrete (0, 1, 2, 3...). Time between website visits is continuous (2.347 hours). The distinction determines which distribution family and which visualization (bar chart for discrete, histogram/density for continuous) is appropriate.',
        keyTakeaway: 'Confusing discrete and continuous variables leads to using the wrong distribution and wrong statistical tests. Always identify this first before choosing a probability model for your data.',
      ),
      ConceptLesson(
        title: 'The Normal Distribution: The Bell Curve',
        definition: 'The normal (Gaussian) distribution is a symmetric, bell-shaped continuous distribution defined by its mean (center) and standard deviation (spread) — it appears naturally whenever a measurement is the sum of many small independent effects.',
        analogy: 'The normal distribution is like the natural spread of arrow shots at a target by a skilled but imperfect archer — most arrows cluster near the bullseye (the mean), with fewer landing further away in a symmetric pattern, and almost none landing extremely far off.',
        example: 'Adult human heights, measurement errors, standardized test scores, and many financial returns approximately follow a normal distribution. The 68-95-99.7 rule states: 68% of values fall within 1 std dev of the mean, 95% within 2, and 99.7% within 3 — a rule of thumb used constantly for quick sanity checks.',
        keyTakeaway: 'The normal distribution is the foundation of countless statistical methods (confidence intervals, hypothesis tests, many ML algorithms assume it). Always visually verify normality with a histogram before assuming it — many real-world business metrics are NOT normal (revenue, wait times).',
        codeSnippet: 'import numpy as np\nheights = np.random.normal(loc=170, scale=8, size=1000)  # mean=170cm, std=8cm\nwithin_1std = np.mean((heights > 162) & (heights < 178))\nprint(f"Within 1 std dev: {within_1std:.2%}")  # ~68%',
      ),
      ConceptLesson(
        title: 'Binomial and Poisson: Distributions for Counts',
        definition: 'The binomial distribution models the number of successes in a fixed number of independent yes/no trials. The Poisson distribution models the number of events occurring in a fixed interval of time or space, given a known average rate.',
        analogy: 'Binomial is like counting how many out of 100 coin flips land heads — a fixed number of trials, each with the same success probability. Poisson is like counting how many customers walk into a store in an hour — no fixed "number of trials," just events happening at some average rate over a continuous interval.',
        example: 'Binomial: out of 200 emails sent, how many get opened (assuming a fixed open rate)? Poisson: how many customer support tickets arrive per hour, given they average 4.5 per hour? Both are common models for count data in business analytics and A/B testing.',
        keyTakeaway: 'Use binomial when you have a fixed number of independent trials with constant success probability. Use Poisson when you are counting rare events over a continuous interval with a known average rate. Choosing the wrong one produces confidently wrong probability estimates.',
        codeSnippet: 'from scipy import stats\n# Binomial: 200 emails, 15% open rate, P(exactly 35 opens)\np_35 = stats.binom.pmf(35, n=200, p=0.15)\nprint(f"P(exactly 35 opens) = {p_35:.4f}")\n\n# Poisson: average 4.5 tickets/hour, P(exactly 6 tickets)\np_6 = stats.poisson.pmf(6, mu=4.5)\nprint(f"P(exactly 6 tickets) = {p_6:.4f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Which scenario is best modeled with a Poisson distribution rather than a binomial distribution?',
        options: [
          'The number of heads in 50 coin flips',
          'The number of website crashes occurring in a 24-hour period, given they happen randomly at an average rate of 2 per day',
          'The number of correct answers on a 20-question multiple choice test',
          'The number of defective items in a batch of exactly 100 units'
        ],
        correctIndex: 1,
        explanation: 'Poisson fits events occurring over a continuous interval (time) at a known average rate with no natural "fixed number of trials" — website crashes over a day fit this perfectly. The other options all have a clear fixed number of discrete trials, fitting binomial instead.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'According to the 68-95-99.7 rule for a normal distribution, approximately what percentage of values fall within 2 standard deviations of the mean?',
        options: [
          '68%',
          '95%',
          '99.7%',
          '50%'
        ],
        correctIndex: 1,
        explanation: 'The empirical rule states 68% of values fall within 1 std dev, 95% within 2 std devs, and 99.7% within 3 std devs of the mean for a normal distribution — a widely used quick reference in data science.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'A dataset of daily customer complaint counts is discrete, non-negative, and mostly small values (0-5) with occasional spikes. Which distribution family is most appropriate to model it?',
        options: [
          'Normal distribution, since all data can be approximated as normal',
          'Poisson distribution — it is specifically designed for count data representing the number of events in a fixed interval',
          'Binomial distribution, because complaints are binary yes/no events',
          'Uniform distribution, since all counts are equally likely'
        ],
        correctIndex: 1,
        explanation: 'Count data — non-negative integers representing events over a time interval — is the textbook use case for the Poisson distribution, not normal (which is continuous and can be negative) or uniform (which assumes equal likelihood, rarely true for real counts).',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Distribution Fitting and Simulation Tool',
      goal: 'Build a tool that generates, visualizes, and analyzes data from multiple probability distributions relevant to a business scenario.',
      steps: [
        'Simulate daily website visitor counts using a Poisson distribution (average 150/day) for 90 days.',
        'Simulate A/B test conversion outcomes using a binomial distribution (1000 trials, 12% conversion rate) run 500 times to build a sampling distribution of conversion counts.',
        'Simulate customer session durations using a normal distribution (mean 8 min, std 3 min).',
        'For each simulated dataset, plot a histogram overlaid with the theoretical distribution curve.',
        'Verify the 68-95-99.7 rule empirically on the normal data and print the actual percentages found.',
      ],
      expectedOutput: 'Three distributions simulated correctly with appropriate parameters. Histograms match theoretical shapes. Empirical 68-95-99.7 percentages closely match theoretical values.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'mean_median_mode_ds3',
    topicTitle: 'Mean, Median & Mode',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '⚖️',
    intro: 'Central tendency seems simple — until real, messy data reveals how differently mean, median, and mode behave. This lesson goes deeper than definitions into when each measure lies to you and how to choose the right one for the story you need to tell.',
    concepts: [
      ConceptLesson(
        title: 'The Mean: Powerful but Fragile',
        definition: 'The arithmetic mean sums all values and divides by count — it uses every data point, making it statistically efficient, but also makes it highly sensitive to extreme outliers.',
        analogy: 'The mean is like a see-saw balance point — every single value, no matter how far out, pulls on that balance point. One person of enormous weight sitting far out on one side dramatically shifts the entire balance point, just as one extreme outlier dramatically shifts the mean.',
        example: 'Average household wealth in a neighborhood with one billionaire resident can show ₹50 crore average, even though every other household has typical middle-class wealth — the billionaire single-handedly distorts the "average" beyond usefulness for describing a typical household.',
        keyTakeaway: 'Use the mean when data is roughly symmetric and outliers are rare or meaningful to include. Avoid the mean as your headline statistic for skewed data like income, house prices, or transaction values without also reporting the median.',
        codeSnippet: 'wealth = [500000]*99 + [500000000]  # 99 typical + 1 billionaire\nimport statistics\nprint(statistics.mean(wealth))    # distorted upward\nprint(statistics.median(wealth))  # accurately typical',
      ),
      ConceptLesson(
        title: 'The Median: Robust to Outliers',
        definition: 'The median is the middle value when data is sorted — it is a "robust statistic," meaning extreme outliers have little to no effect on it, unlike the mean which every value influences proportionally.',
        analogy: 'The median is like asking "who is the middle person in a line of 101 people sorted by height?" — it does not matter if the tallest person is 2 meters or 20 meters tall, the middle person\'s height (the median) stays exactly the same either way.',
        example: 'Median household income is the standard government statistic (not mean) precisely because a small number of extremely wealthy households would otherwise distort a national "average" income figure into something unrepresentative of typical households.',
        keyTakeaway: 'The median is preferred whenever outliers or skew are present, and it is often paired with the interquartile range (rather than standard deviation) for a fully robust summary of spread — both resist distortion from extreme values.',
        codeSnippet: 'import numpy as np\ndata = np.array([20, 22, 21, 23, 19, 500])  # one big outlier\nprint(f"Mean: {data.mean():.1f}")     # pulled toward 500\nprint(f"Median: {np.median(data):.1f}")  # stays near typical values',
      ),
      ConceptLesson(
        title: 'The Mode and Multimodal Distributions',
        definition: 'The mode is the most frequently occurring value. A distribution can have one mode (unimodal), two (bimodal), or more (multimodal) — multiple modes often signal that the data actually contains multiple distinct underlying groups mixed together.',
        analogy: 'A bimodal distribution is like a photo of two separate mountain ranges taken from far away and mistaken for one landscape — what looks like one dataset with a strange dip in the middle is actually two different populations (e.g., weekday vs weekend behavior) combined into one chart.',
        example: 'Website session durations often show bimodal distributions: a cluster of very short "bounce" sessions (under 10 seconds) and a separate cluster of engaged sessions (5+ minutes) — treating this as one unimodal distribution and reporting a single mean misses the real story entirely.',
        keyTakeaway: 'Spotting bimodal or multimodal shapes in a histogram is often more valuable than any single summary statistic — it suggests segmenting the data by a hidden variable (device type, user type, day of week) rather than analyzing it as one homogeneous group.',
        codeSnippet: 'import matplotlib.pyplot as plt\nimport numpy as np\nnp.random.seed(1)\nbounces = np.random.exponential(5, 300)\nengaged = np.random.normal(300, 60, 200)\nsessions = np.concatenate([bounces, engaged])\nplt.hist(sessions, bins=40)  # reveals two humps - bimodal',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A histogram of customer ages shows two distinct peaks — one around 22 and another around 45. What does this bimodal shape suggest?',
        options: [
          'The data contains an error and one peak should be removed',
          'The dataset likely contains two distinct underlying customer groups (e.g., students and mid-career professionals) that should probably be analyzed separately rather than as one combined population',
          'The mean will accurately represent the "typical" customer in this case',
          'Bimodal distributions are impossible in real data and indicate a plotting bug'
        ],
        correctIndex: 1,
        explanation: 'Bimodal shapes are a strong visual signal of a hidden segmenting variable. Reporting one overall mean or median for a genuinely bimodal population is misleading — neither peak group is well represented by a single central statistic.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is the median described as a "robust" statistic while the mean is not?',
        options: [
          'The median is always a whole number while the mean is not',
          'The median depends only on the middle-ranked value(s) and is largely unaffected by how extreme the outlier values are, while the mean is directly pulled by the magnitude of every value including outliers',
          'The median is easier to calculate by hand',
          'Robust statistics are simply the ones taught first in statistics courses'
        ],
        correctIndex: 1,
        explanation: 'Robustness refers to insensitivity to outliers. Because the median only depends on rank order (which value is in the middle position), an outlier can be made arbitrarily large without changing the median — but it directly shifts the mean proportionally to its magnitude.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You are reporting "typical" house price for a news article, and the price distribution is heavily right-skewed with some ultra-luxury mansions included. Which statistic should headline the article?',
        options: [
          'The mean, because it uses all the data points',
          'The median, because it is robust to the small number of extreme luxury mansions and better represents what a typical buyer would encounter',
          'The mode, because prices repeat exactly across many houses',
          'The maximum, to show the most impressive figure'
        ],
        correctIndex: 1,
        explanation: 'For right-skewed price data with extreme high-end outliers, the median gives a far more representative "typical" figure than the mean, which would be inflated by the mansions and misleading to readers thinking about a typical home purchase.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Central Tendency Comparison Dashboard',
      goal: 'Build a tool that computes and visually compares mean, median, and mode across multiple simulated business datasets to demonstrate when each measure should be trusted.',
      steps: [
        'Simulate three datasets: (1) roughly symmetric employee ages, (2) right-skewed transaction amounts with outliers, (3) bimodal session durations.',
        'For each dataset, compute mean, median, and mode (using binning for continuous data).',
        'Plot histograms for all three with mean and median marked as vertical lines.',
        'Write an automatic interpretation function that flags when mean and median diverge significantly and recommends which statistic to headline.',
        'Print a summary table comparing all three datasets\' central tendency measures side by side.',
      ],
      expectedOutput: 'Three datasets correctly simulated and visualized. Automatic interpretation correctly identifies the skewed dataset and recommends median. Summary table clearly compares all measures.',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'variance_std_deviation_ds3',
    topicTitle: 'Variance & Standard Deviation',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 25,
    totalXp: 120,
    emoji: '📏',
    intro: 'Knowing the center of your data is only half the story — you also need to know how spread out it is. Variance and standard deviation quantify this spread, and understanding them deeply is essential before you can properly interpret confidence intervals, hypothesis tests, or model uncertainty.',
    concepts: [
      ConceptLesson(
        title: 'Variance: Average Squared Distance from the Mean',
        definition: 'Variance measures the average squared deviation of each data point from the mean — squaring ensures negative and positive deviations do not cancel out, and it heavily weights larger deviations.',
        analogy: 'Variance is like measuring how far, on average, arrows land from the bullseye — but instead of averaging raw distances, you average the SQUARED distances, which means arrows that land very far away count disproportionately more than arrows landing just slightly off target.',
        example: 'Two delivery services both average 30 minutes delivery time. Service A\'s times range 25-35 minutes (low variance) — highly predictable. Service B\'s times range 5-60 minutes (high variance) — same average, but wildly unpredictable. Variance captures this critical difference that the mean alone hides completely.',
        keyTakeaway: 'Variance is expressed in squared units (squared minutes, squared rupees) which makes it hard to interpret directly — this is exactly why standard deviation (its square root) is almost always reported instead for interpretability.',
        codeSnippet: 'import numpy as np\nservice_a = np.array([28, 30, 32, 29, 31])\nservice_b = np.array([5, 55, 10, 50, 30])\nprint(f"A variance: {service_a.var():.1f}")   # low\nprint(f"B variance: {service_b.var():.1f}")   # high, same mean',
      ),
      ConceptLesson(
        title: 'Standard Deviation: Variance in Original Units',
        definition: 'Standard deviation is the square root of variance, bringing the spread measure back into the same units as the original data — making it directly interpretable and comparable to the mean.',
        analogy: 'If variance is like a distorted map measured in "squared kilometers of confusion," standard deviation converts that back into an honest "kilometers" figure you can actually compare against real distances — the mean and standard deviation now speak the same language.',
        example: 'Reporting "average delivery time is 30 minutes with a standard deviation of 8 minutes" is immediately interpretable — most deliveries fall roughly between 22-38 minutes. Reporting "variance is 64 squared-minutes" conveys the same information but is far less intuitive to a non-technical audience.',
        keyTakeaway: 'Always report standard deviation (not variance) when communicating spread to stakeholders — it is in the same units as the mean, making direct comparison and interpretation immediate and natural.',
        codeSnippet: 'import numpy as np\ndelivery_times = np.array([28, 35, 22, 40, 25, 33, 30])\nmean = delivery_times.mean()\nstd = delivery_times.std()\nprint(f"Mean: {mean:.1f} min, Std Dev: {std:.1f} min")\nprint(f"Typical range: {mean-std:.1f} to {mean+std:.1f} min")',
      ),
      ConceptLesson(
        title: 'Population vs Sample: The N-1 Correction',
        definition: 'When calculating variance from a sample (rather than an entire population), dividing by n-1 instead of n corrects for a systematic bias — this is called Bessel\'s correction and produces an unbiased estimate of the true population variance.',
        analogy: 'Using n instead of n-1 when working from a sample is like measuring a room with a slightly-too-short ruler — it consistently underestimates the true spread. The n-1 correction is a mathematically derived adjustment that fixes this systematic underestimation, giving a more honest estimate of the population\'s true variability.',
        example: 'If you survey 30 customers out of a company\'s 10,000 total customers and compute variance to estimate satisfaction spread across ALL customers, you should use n-1 (sample variance, ddof=1 in NumPy). If you have data on literally every customer (the full population), use n (ddof=0).',
        keyTakeaway: 'By default, NumPy\'s .var() and .std() use ddof=0 (population formula) — for sample-based estimates (which is nearly always the case in real analysis), explicitly pass ddof=1. Pandas defaults to ddof=1 automatically, which is the more common correct choice in practice.',
        codeSnippet: 'import numpy as np\nsample = np.array([23, 25, 21, 27, 24])\nprint(f"Population formula (ddof=0): {sample.std(ddof=0):.3f}")\nprint(f"Sample formula (ddof=1):     {sample.std(ddof=1):.3f}")\n# Sample formula (ddof=1) is larger - correcting for underestimation',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why is standard deviation preferred over variance when communicating results to a non-technical audience?',
        options: [
          'Standard deviation is always a smaller, easier number',
          'Standard deviation is expressed in the same units as the original data (e.g., minutes, rupees), making it directly comparable and interpretable, while variance is in squared units',
          'Variance cannot be computed for real business data',
          'Standard deviation is always exactly half of the variance'
        ],
        correctIndex: 1,
        explanation: 'Variance\'s squared units (squared rupees, squared minutes) have no intuitive real-world meaning. Standard deviation returns to the original units by taking the square root, making it directly comparable to the mean and immediately interpretable.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'You have survey data from 200 customers out of a company\'s 50,000 total customers, and want to estimate the true variance across ALL customers. Which formula should you use?',
        options: [
          'Population variance (divide by n) — because you have a large enough sample',
          'Sample variance (divide by n-1) — Bessel\'s correction is needed whenever computing variance from a sample intended to estimate a larger population\'s true variance',
          'It does not matter which formula is used for large samples',
          'Multiply the population formula result by 50,000/200'
        ],
        correctIndex: 1,
        explanation: 'Whenever the data represents a sample used to estimate a larger population\'s characteristics (which is nearly always the case in real analysis), the n-1 sample variance formula should be used to correct for the systematic underestimation bias.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Two manufacturing lines both produce parts averaging 100mm in length. Line A has std dev 0.5mm; Line B has std dev 4mm. Which line has more consistent, predictable quality?',
        options: [
          'Line B, because higher standard deviation means more precise manufacturing',
          'Line A — lower standard deviation means parts cluster tightly around the 100mm target, indicating more consistent, predictable manufacturing quality',
          'Both lines are equally consistent since they share the same mean',
          'It is impossible to compare consistency using standard deviation'
        ],
        correctIndex: 1,
        explanation: 'Lower standard deviation directly indicates tighter clustering around the mean — Line A\'s parts vary far less from the 100mm target, making it the more consistent and predictable production line despite sharing the same average with Line B.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Quality Consistency Analyzer',
      goal: 'Build a tool comparing variability across multiple simulated production lines or business processes to identify the most consistent performer.',
      steps: [
        'Simulate measurement data for 4 manufacturing lines using NumPy, all with the same target mean (100mm) but deliberately different standard deviations.',
        'Compute mean, variance, and standard deviation (with correct ddof) for each line.',
        'Rank the lines from most to least consistent based on standard deviation.',
        'Visualize all 4 distributions as overlaid histograms or box plots to visually confirm the ranking.',
        'Print a quality control report recommending which line needs process improvement.',
      ],
      expectedOutput: 'All 4 lines correctly simulated with matching means but different spreads. Ranking by standard deviation is accurate. Visualization clearly shows the spread differences. Report gives a clear, correct recommendation.',
      xpReward: 50,
    ),
  ),

  TopicCourse(
    id: 'correlation_covariance_ds3',
    topicTitle: 'Correlation & Covariance',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 140,
    emoji: '🔗',
    intro: 'Do two variables move together? Correlation and covariance quantify relationships between variables — the foundation for feature selection, understanding multicollinearity, and building intuition before any predictive model. This lesson also covers correlation\'s most dangerous trap: mistaking it for causation.',
    concepts: [
      ConceptLesson(
        title: 'Covariance: Direction of a Relationship',
        definition: 'Covariance measures whether two variables tend to increase together (positive covariance), move oppositely (negative covariance), or show no consistent relationship (near-zero covariance) — but its magnitude is not directly interpretable because it depends on the variables\' units and scale.',
        analogy: 'Covariance is like noticing that when one dance partner steps left, the other tends to step left too (positive covariance) or steps right instead (negative covariance) — it tells you the DIRECTION of coordinated movement, but not how tightly synchronized the dance actually is.',
        example: 'Ice cream sales and temperature typically show positive covariance — as temperature rises, sales rise too. Umbrella sales and sunshine hours typically show negative covariance — more sunshine, fewer umbrellas sold. The sign tells the story; the raw number does not tell you strength.',
        keyTakeaway: 'Covariance\'s scale-dependence (covariance between rupees and kilometers is not comparable to covariance between two rupee variables) is precisely why correlation — a standardized version of covariance — is used far more often in practice.',
        codeSnippet: 'import numpy as np\ntemp = np.array([28, 32, 35, 25, 30])\nsales = np.array([200, 350, 420, 150, 300])\ncov_matrix = np.cov(temp, sales)\nprint(f"Covariance: {cov_matrix[0,1]:.1f}")  # positive - move together',
      ),
      ConceptLesson(
        title: 'Pearson Correlation: A Standardized, Interpretable Measure',
        definition: 'Pearson correlation coefficient (r) standardizes covariance to always fall between -1 and +1, making relationship strength directly comparable across any pair of variables regardless of their original units or scale.',
        analogy: 'Pearson correlation is like converting every currency in the world to a single universal scale from -1 to +1 before comparing "how tightly linked" any two things are — whether comparing rainfall and crop yield, or stock prices and interest rates, the -1 to +1 scale means the same thing everywhere.',
        example: 'r = 0.95 between advertising spend and sales indicates an extremely strong positive linear relationship. r = 0.15 between employee age and typing speed indicates almost no linear relationship. r = -0.80 between price and demand indicates a strong negative relationship — all directly comparable numbers.',
        keyTakeaway: 'r near +1 or -1 = strong linear relationship. r near 0 = weak or no LINEAR relationship (a strong non-linear relationship can still exist with r near 0 — always plot the scatter to check). |r| > 0.7 is generally considered strong in most business contexts.',
        codeSnippet: 'import numpy as np\nad_spend = np.array([1000, 2000, 3000, 4000, 5000])\nsales = np.array([12000, 22000, 35000, 41000, 52000])\ncorrelation = np.corrcoef(ad_spend, sales)[0, 1]\nprint(f"Correlation: {correlation:.3f}")  # ~0.99 - very strong',
      ),
      ConceptLesson(
        title: 'Correlation Is Not Causation',
        definition: 'A strong correlation between two variables never proves that one causes the other — the relationship could be coincidental, driven by a hidden confounding variable, or even reversed in causal direction.',
        analogy: 'Ice cream sales and drowning deaths are strongly correlated — but ice cream does not cause drowning. Both are driven by a hidden confounder: hot summer weather increases both ice cream purchases AND swimming activity (and therefore drowning risk). Mistaking this for direct causation would lead to absurd policy (banning ice cream to prevent drownings).',
        example: 'A company observes that employees who use the internal wellness app have 20% higher performance ratings. This could mean: the app improves performance (causal), OR high-performing employees are simply more likely to adopt new tools (reverse causation), OR a third factor like general conscientiousness drives both app usage and performance (confounding).',
        keyTakeaway: 'Establishing true causation requires controlled experiments (A/B tests) or careful causal inference methods — never business decisions based on correlation alone, no matter how strong or intuitive the relationship appears. Always ask "what else could explain this pattern?"',
        codeSnippet: '# Classic spurious correlation example - always visualize AND question\nimport numpy as np\nyears = np.arange(2010, 2020)\nnicolas_cage_films = [2,3,1,4,2,3,1,2,3,2]\npool_drownings = [98,102,95,110,99,105,94,100,108,101]\n# High correlation despite obviously having no causal link\ncorr = np.corrcoef(nicolas_cage_films, pool_drownings)[0,1]\nprint(f"Spurious correlation: {corr:.2f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A dataset shows correlation r = 0.05 between two variables. What is the MOST accurate interpretation?',
        options: [
          'The two variables definitely have no relationship of any kind',
          'There is no strong LINEAR relationship, but a strong non-linear relationship (e.g., U-shaped) could still exist and would not be captured by Pearson correlation — always plot the scatter to check',
          'The correlation calculation must be incorrect since real variables always correlate strongly',
          'r = 0.05 indicates a strong negative relationship'
        ],
        correctIndex: 1,
        explanation: 'Pearson correlation only measures LINEAR relationships. A near-zero r can occur even when a strong non-linear relationship (like a U-shape or exponential curve) exists between the variables — this is exactly why visualization alongside correlation is essential.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A study finds that towns with more fire trucks also have more fire damage, with a strong positive correlation. What is the most likely explanation?',
        options: [
          'Fire trucks cause fires by attracting them to the scene',
          'A confounding variable — larger fires (bigger blazes) simultaneously require dispatching more fire trucks AND cause more damage; town size or fire severity likely drives both variables',
          'This proves fire trucks should be reduced to lower fire damage',
          'The correlation must be a calculation error'
        ],
        correctIndex: 1,
        explanation: 'This is a classic confounding variable scenario — fire severity (or town size) independently drives both the number of trucks dispatched and the resulting damage. The correlation is real but the naive causal interpretation (fewer trucks = less damage) would be dangerously wrong.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You find r = 0.85 between two features in your dataset that you plan to use in a regression model. What should you consider?',
        options: [
          'Nothing — high correlation between features is always beneficial for models',
          'This indicates strong multicollinearity — the two features carry largely redundant information, which can make regression coefficients unstable; consider dropping one or combining them',
          'Automatically delete both features from the dataset',
          'The correlation must be recalculated using covariance instead'
        ],
        correctIndex: 1,
        explanation: 'High correlation (r=0.85) between two predictor features indicates multicollinearity, a known issue for regression models that can destabilize coefficient estimates and hurt interpretability — a common next step is to drop or combine one of the redundant features.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Feature Relationship Explorer',
      goal: 'Build a correlation analysis tool that identifies strong relationships, flags multicollinearity, and warns against causal over-interpretation.',
      steps: [
        'Simulate a business dataset with 6 numeric features, deliberately building in some strongly correlated pairs and some independent ones.',
        'Compute the full correlation matrix and visualize it as a Seaborn heatmap.',
        'Write a function flag_multicollinearity(corr_matrix, threshold=0.8) that identifies and lists all feature pairs above the threshold.',
        'Create scatter plots for the 3 strongest relationships (positive and negative) with regression lines.',
        'Print a report that states each strong correlation found, along with a mandatory caution note that correlation does not imply causation and lists plausible confounding explanations.',
      ],
      expectedOutput: 'Correlation matrix and heatmap generated correctly. Multicollinearity pairs correctly flagged above threshold. Scatter plots with regression lines for top relationships. Report includes proper causation caveats for every relationship found.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'sampling_clt_ds3',
    topicTitle: 'Sampling & Central Limit Theorem',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 145,
    emoji: '🎯',
    intro: 'You almost never have access to an entire population — you have a sample. Understanding how samples relate to populations, and the remarkable Central Limit Theorem that makes statistical inference possible at all, is the conceptual bridge between descriptive statistics and everything that follows: confidence intervals and hypothesis testing.',
    concepts: [
      ConceptLesson(
        title: 'Population vs Sample: Why We Sample at All',
        definition: 'A population is the complete set of items you want to understand. A sample is a subset actually collected and measured. Sampling exists because measuring an entire population is usually impossible, too expensive, or too slow.',
        analogy: 'Sampling is like tasting a spoonful of soup to judge the whole pot\'s seasoning — you do not need to drink the entire pot to know if it needs more salt, as long as the spoonful is a fair, well-mixed representation of the whole pot.',
        example: 'A company cannot survey all 5 million users about a new feature, but can survey a random 2,000 and confidently generalize the findings to all 5 million — provided the sample was selected properly (randomly, without systematic bias toward certain user types).',
        keyTakeaway: 'The value of a sample depends entirely on HOW it was collected, not just its size. A large but biased sample (e.g., only surveying app power-users) can be far less useful than a smaller, truly random sample of the whole population.',
      ),
      ConceptLesson(
        title: 'Sampling Bias and Random Sampling',
        definition: 'Sampling bias occurs when the sample is not representative of the population — often because the sampling method systematically favors certain kinds of individuals or excludes others, leading to conclusions that do not generalize.',
        analogy: 'Sampling bias is like judging a city\'s average income by only interviewing people at a luxury shopping mall — you will systematically overestimate typical income because you have excluded everyone who does not shop there, not because your math is wrong but because your sample was never representative to begin with.',
        example: 'A famous historical case: a 1936 US election poll surveyed people via telephone and car registration lists, systematically oversampling wealthier respondents (who could afford phones/cars during the Depression) — producing a wildly wrong prediction despite a huge sample size of 2 million people.',
        keyTakeaway: 'A truly random sample, even if small, generally beats a huge but biased sample. Always ask "who was excluded from this sample, and could that exclusion have skewed the results?" before trusting any survey or dataset\'s conclusions.',
        codeSnippet: 'import numpy as np\nnp.random.seed(42)\npopulation = np.random.normal(50000, 15000, 100000)  # true population\nrandom_sample = np.random.choice(population, size=200, replace=False)\nprint(f"Population mean: {population.mean():.0f}")\nprint(f"Random sample mean: {random_sample.mean():.0f}")  # close estimate',
      ),
      ConceptLesson(
        title: 'The Central Limit Theorem: Why Averages Become Normal',
        definition: 'The Central Limit Theorem (CLT) states that the sampling distribution of the sample mean approaches a normal distribution as sample size increases, REGARDLESS of the original population\'s distribution shape — even if the population itself is heavily skewed.',
        analogy: 'The CLT is like discovering that no matter how oddly shaped individual puzzle pieces are (skewed, weird distributions), if you repeatedly assemble groups of many pieces and measure each group\'s "average shape," those group averages settle into the same predictable bell-curve pattern every time.',
        example: 'Individual customer purchase amounts might be heavily right-skewed (many small purchases, occasional huge ones). But if you repeatedly take samples of 50 customers and compute each sample\'s AVERAGE purchase, those sample averages will form a nearly normal distribution — this is what makes confidence intervals and hypothesis tests valid even for skewed underlying data.',
        keyTakeaway: 'The CLT is arguably the single most important theorem in applied statistics — it is why we can build confidence intervals and run hypothesis tests on sample means even when we know nothing about the original population\'s shape, as long as the sample size is reasonably large (typically n ≥ 30 as a rule of thumb).',
        codeSnippet: 'import numpy as np\nnp.random.seed(42)\n# Skewed population (exponential)\npopulation = np.random.exponential(scale=1000, size=100000)\n\n# Take 1000 samples of size 40, record each sample mean\nsample_means = [np.random.choice(population, 40).mean() for _ in range(1000)]\n# sample_means is approximately normal, even though population was skewed\nimport scipy.stats as stats\nprint(f"Skew of population: {stats.skew(population):.2f}")\nprint(f"Skew of sample means: {stats.skew(sample_means):.2f}")  # much closer to 0',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A survey of a new product feature only collects responses from customers who opted into a "beta tester" email list. What is the primary statistical concern with this sample?',
        options: [
          'The sample size is definitely too small to matter',
          'Sampling bias — beta testers are self-selected and likely differ systematically from the general customer base (e.g., more tech-savvy, more engaged), so results may not generalize to all customers',
          'The survey should have used a larger population instead of a sample',
          'There is no concern as long as at least 30 people responded'
        ],
        correctIndex: 1,
        explanation: 'Self-selected beta testers are a textbook example of sampling bias — they systematically differ from the average customer, meaning their opinions may not generalize to the broader customer base, regardless of how large the beta tester sample is.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'The Central Limit Theorem states that the distribution of sample means approaches normal as sample size grows. What is remarkable about this?',
        options: [
          'It only works when the original population is already normally distributed',
          'It holds true regardless of the original population\'s distribution shape — even for heavily skewed or unusual populations, the distribution of sample means still tends toward normal as sample size increases',
          'It only applies to sample sizes smaller than 10',
          'The CLT is a rule of thumb with no mathematical basis'
        ],
        correctIndex: 1,
        explanation: 'The remarkable and powerful part of the CLT is its universality — it applies regardless of the shape of the original population distribution, which is exactly why statistical inference methods built on the normal distribution work broadly across so many real-world scenarios.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You want to estimate average customer satisfaction across a company\'s entire user base of 1 million. Which sampling approach is statistically soundest?',
        options: [
          'Survey the first 5,000 customers who signed up, since that is a large sample',
          'Randomly select customers using a random number generator across the entire customer database, ensuring every customer has an equal chance of selection',
          'Survey only customers who have contacted support, since they have strong opinions',
          'Survey employees\' friends and family since they are easy to reach'
        ],
        correctIndex: 1,
        explanation: 'True random sampling — where every member of the population has an equal chance of being selected — is the gold standard for producing a representative sample and avoiding the systematic bias present in convenience samples like early signups or support contacts.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Central Limit Theorem Simulator',
      goal: 'Build an interactive simulation demonstrating the Central Limit Theorem across multiple non-normal population distributions.',
      steps: [
        'Create three skewed/unusual population distributions using NumPy: exponential, uniform, and a bimodal mixture — each with 100,000 values.',
        'For each population, plot its raw distribution shape (confirming it is NOT normal).',
        'For each population, repeatedly draw samples of varying sizes (n=5, 30, 100) and record the sample mean each time (1000 repetitions per size).',
        'Plot the distribution of sample means for each sample size, showing how it becomes increasingly normal-shaped as n increases.',
        'Print skewness values for each sample-mean distribution to quantitatively confirm convergence toward normality.',
      ],
      expectedOutput: 'Three non-normal populations correctly simulated. Sample mean distributions visibly converge toward bell-curve shape as sample size increases from 5 to 100. Skewness values numerically confirm the convergence.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'confidence_intervals_ds3',
    topicTitle: 'Confidence Intervals',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 145,
    emoji: '📶',
    intro: 'A single number estimate (like "average satisfaction is 7.2") hides uncertainty. A confidence interval communicates a plausible range, honestly expressing how much trust to place in an estimate given the sample it came from. This is one of the most misunderstood — and most important — tools in applied statistics.',
    concepts: [
      ConceptLesson(
        title: 'What a Confidence Interval Actually Means',
        definition: 'A confidence interval gives a range of plausible values for a population parameter, along with a confidence level (typically 95%) describing how often such intervals, if the sampling process were repeated many times, would contain the true population value.',
        analogy: 'A 95% confidence interval is like a fisherman casting a net repeatedly to catch a fish whose true location is fixed but unknown — 95% of the time the net (interval) successfully contains the fish (the true population value), but the fish itself never moves; the uncertainty is in the net\'s placement, not in the fish\'s true location.',
        example: 'Reporting "average customer satisfaction is 7.2, with a 95% CI of [6.9, 7.5]" tells stakeholders far more than the single number alone — it honestly communicates that the true population average is plausibly anywhere in that range, not exactly pinned at 7.2.',
        keyTakeaway: 'A common misinterpretation is "there is a 95% probability the true value is in this specific interval" — this is subtly wrong. The correct interpretation is about the LONG-RUN reliability of the method: 95% of intervals constructed this way, across repeated sampling, would contain the true value.',
      ),
      ConceptLesson(
        title: 'Constructing a Confidence Interval for the Mean',
        definition: 'A confidence interval for a sample mean is constructed as: sample mean ± (critical value × standard error), where standard error = sample standard deviation / √(sample size) — this formula directly incorporates both the spread of the data and the sample size.',
        analogy: 'Building a confidence interval is like drawing an error bar of uncertainty around a dart that landed on a target — the more consistent your throws (lower variability) and the more throws you have taken (larger sample), the tighter and more confident that error bar becomes.',
        example: 'A sample of 100 customers has mean satisfaction 7.2 with std dev 1.5. Standard error = 1.5/√100 = 0.15. A 95% CI uses roughly ±1.96 standard errors: 7.2 ± (1.96 × 0.15) = [6.91, 7.49] — the plausible range for the true average customer satisfaction across all customers.',
        keyTakeaway: 'Larger sample sizes produce narrower (more precise) confidence intervals because standard error shrinks as sample size grows — this is the mathematical reason "more data" genuinely means "more certainty" in statistics.',
        codeSnippet: 'import numpy as np\nfrom scipy import stats\n\nsample = np.array([7,8,6,7,9,7,8,6,7,8,9,7,6,8,7])\nmean = sample.mean()\nse = sample.std(ddof=1) / np.sqrt(len(sample))\nci = stats.t.interval(0.95, df=len(sample)-1, loc=mean, scale=se)\nprint(f"Mean: {mean:.2f}, 95% CI: [{ci[0]:.2f}, {ci[1]:.2f}]")',
      ),
      ConceptLesson(
        title: 'Sample Size and Interval Width Tradeoffs',
        definition: 'Confidence interval width shrinks as sample size grows (more precision) but grows as the confidence level increases (more certainty) — there is a fundamental tradeoff between how confident you want to be and how precise (narrow) your interval can be.',
        analogy: 'Choosing a confidence level is like choosing how wide a net to cast when trying to guarantee you catch a specific fish — a 99% confidence net must be cast wider to be almost certain of success, while a 90% confidence net can be narrower but risks missing the target more often.',
        example: 'For the same dataset, a 90% CI might be [7.0, 7.4] (narrower, less certain), a 95% CI might be [6.9, 7.5], and a 99% CI might be [6.75, 7.65] (wider, more certain). Choosing the right confidence level depends on how costly it would be to be wrong in your specific business decision.',
        keyTakeaway: 'Quadrupling the sample size only halves the confidence interval width (because standard error involves a square root) — this diminishing return means there is often a practical limit to how much precision more data collection can economically buy.',
        codeSnippet: 'import numpy as np\nfrom scipy import stats\n\nsample = np.array([7,8,6,7,9,7,8,6,7,8,9,7,6,8,7])\nmean, se = sample.mean(), sample.std(ddof=1)/np.sqrt(len(sample))\n\nfor conf in [0.90, 0.95, 0.99]:\n    ci = stats.t.interval(conf, df=len(sample)-1, loc=mean, scale=se)\n    print(f"{conf:.0%} CI: [{ci[0]:.2f}, {ci[1]:.2f}]  width={ci[1]-ci[0]:.2f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A 95% confidence interval for average delivery time is [28, 34] minutes. What is the CORRECT interpretation?',
        options: [
          'There is a 95% chance the true average delivery time is between 28 and 34 minutes for this specific interval',
          'If this sampling and interval-construction process were repeated many times, approximately 95% of the resulting intervals would contain the true population average delivery time',
          'Exactly 95% of all individual deliveries take between 28 and 34 minutes',
          'The sample mean itself has a 95% probability of being correct'
        ],
        correctIndex: 1,
        explanation: 'The technically correct interpretation of a confidence interval is about the long-run reliability of the METHOD across repeated sampling, not a probability statement about this one fixed interval containing a fixed true value — a subtle but important distinction.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'If you increase your sample size from 100 to 400 (4x), what happens to the width of your confidence interval, all else being equal?',
        options: [
          'The interval becomes 4 times narrower',
          'The interval becomes 2 times narrower, because standard error involves dividing by the square root of sample size, and √4 = 2',
          'The interval width stays exactly the same',
          'The interval becomes wider with more data'
        ],
        correctIndex: 1,
        explanation: 'Standard error = std dev / √n. Quadrupling n means dividing by √4 = 2, so standard error (and thus interval width) is halved, not quartered — this square-root relationship explains the diminishing returns of collecting more data.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Your company needs to decide whether average order value has genuinely increased above ₹500. A 95% CI from recent data is [510, 540]. What can you conclude?',
        options: [
          'Nothing can be concluded from a confidence interval',
          'Since the entire interval [510, 540] lies above 500, there is reasonably strong evidence that the true average order value now exceeds ₹500',
          'The average order value is definitely exactly ₹525 (the midpoint)',
          'The confidence interval is irrelevant to this business question'
        ],
        correctIndex: 1,
        explanation: 'When an entire confidence interval falls on one side of a reference value (here, entirely above ₹500), it provides reasonably strong statistical evidence that the true population value differs from that reference point in that direction.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Confidence Interval Business Decision Tool',
      goal: 'Build a tool that computes confidence intervals for business metrics and translates them into actionable recommendations.',
      steps: [
        'Simulate 3 business scenarios with sample data: average order value (n=150), customer satisfaction score (n=80), and website conversion rate (n=500 binary outcomes).',
        'Write compute_ci(sample, confidence=0.95) that returns the mean, standard error, and confidence interval bounds for continuous data.',
        'Write compute_ci_proportion(successes, n, confidence=0.95) for the conversion rate (proportion) case.',
        'For each scenario, compute CIs at 90%, 95%, and 99% confidence, and visualize how interval width changes.',
        'Write an automatic interpretation function that compares each CI against a specified business benchmark and states whether the evidence supports "above," "below," or "inconclusive relative to" the benchmark.',
      ],
      expectedOutput: 'All three CIs computed correctly at multiple confidence levels. Widening pattern from 90% to 99% clearly visualized. Automatic interpretation correctly classifies each result relative to its benchmark.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'hypothesis_testing_ds3',
    topicTitle: 'Hypothesis Testing',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 35,
    totalXp: 155,
    emoji: '🧪',
    intro: 'Is that difference between two groups real, or just random noise? Hypothesis testing is the formal framework data scientists use to answer this question with statistical rigor — powering every A/B test, every "is this change significant" decision, and every scientific claim about data.',
    concepts: [
      ConceptLesson(
        title: 'Null and Alternative Hypotheses',
        definition: 'The null hypothesis (H0) represents "no effect" or "no difference" — the default assumption. The alternative hypothesis (H1) represents the effect or difference you suspect exists. Hypothesis testing evaluates whether your data provides enough evidence to reject H0 in favor of H1.',
        analogy: 'Hypothesis testing mirrors a criminal trial: the null hypothesis is "innocent until proven guilty" (the defendant did nothing different). The alternative hypothesis is "guilty" (something changed). You only reject the null (convict) if the evidence is strong enough — "beyond reasonable doubt" — not simply because some difference was observed.',
        example: 'Testing a new checkout button color: H0 = "the new button color has no effect on conversion rate." H1 = "the new button color changes conversion rate." You run an A/B test and only conclude the new color matters if the data provides sufficiently strong statistical evidence against H0.',
        keyTakeaway: 'You never "prove" the null hypothesis true — you either reject it (sufficient evidence against "no effect") or fail to reject it (insufficient evidence, which is NOT the same as proving there is no effect at all).',
      ),
      ConceptLesson(
        title: 'P-values: Quantifying the Evidence',
        definition: 'A p-value is the probability of observing data as extreme as (or more extreme than) what was actually observed, assuming the null hypothesis is true. A small p-value suggests the observed data would be unusual if H0 were true, providing evidence against it.',
        analogy: 'A p-value is like asking "if this coin were truly fair, how surprising would it be to see 18 heads out of 20 flips?" If that outcome would be extremely rare under a fair coin assumption (small p-value), you start suspecting the coin actually is not fair — the surprise itself is the evidence.',
        example: 'An A/B test comparing checkout conversion produces p = 0.02. This means: if there truly were no difference between the two button colors, there would only be a 2% chance of seeing a conversion gap this large or larger purely by random sampling variation — fairly strong evidence the colors genuinely differ.',
        keyTakeaway: 'p < 0.05 is the most common (but arbitrary) threshold for "statistical significance" — a small p-value is evidence against H0, NOT proof, and it says nothing about the practical importance or size of the effect, only its statistical unlikeliness under the null.',
        codeSnippet: 'from scipy import stats\nimport numpy as np\n\nnp.random.seed(1)\ngroup_a = np.random.normal(100, 15, 200)  # control\ngroup_b = np.random.normal(105, 15, 200)  # treatment\n\nt_stat, p_value = stats.ttest_ind(group_a, group_b)\nprint(f"t-statistic: {t_stat:.3f}")\nprint(f"p-value: {p_value:.4f}")\nif p_value < 0.05:\n    print("Statistically significant difference detected")',
      ),
      ConceptLesson(
        title: 'Type I and Type II Errors, and Statistical Power',
        definition: 'A Type I error (false positive) rejects a true null hypothesis — concluding there is an effect when there is not. A Type II error (false negative) fails to reject a false null hypothesis — missing a real effect. Statistical power is the probability of correctly detecting a true effect.',
        analogy: 'Type I error is like a smoke alarm going off when there is no fire (false alarm) — wasted resources reacting to nothing. Type II error is like a smoke alarm staying silent during an actual fire (missed detection) — a dangerous failure to act when action was needed. Every test design balances the cost of each error type.',
        example: 'Launching a marketing campaign based on a false positive test result (Type I error) wastes budget on a change that does not actually work. Failing to detect a genuinely effective new feature because the test lacked statistical power (Type II error) means missing out on real business value.',
        keyTakeaway: 'Reducing Type I error risk (a stricter significance threshold) generally increases Type II error risk, and vice versa — there is no free lunch. Increasing sample size is the primary way to reduce BOTH error types simultaneously, which is why adequately powered sample sizes matter before running any test.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'An A/B test produces p = 0.03 for a new website design. What is the CORRECT interpretation?',
        options: [
          'There is a 3% probability the null hypothesis is true',
          'If there were truly no difference between designs, there would only be a 3% chance of observing a difference this large or larger due to random sampling variation alone — this is evidence against the null hypothesis',
          'The new design definitely improves conversion by exactly 3%',
          'The test should be discarded because the p-value is too small'
        ],
        correctIndex: 1,
        explanation: 'A p-value is a statement about how surprising the observed data would be UNDER the assumption the null hypothesis is true — it is not the probability that the null hypothesis itself is true, a very common and important misinterpretation to avoid.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A company concludes a new feature significantly improves engagement (rejecting H0), but the feature actually has no real effect. What type of error occurred?',
        options: [
          'Type II error (false negative)',
          'Type I error (false positive) — incorrectly rejecting a true null hypothesis, concluding there is an effect when there truly is none',
          'This is not an error since the test procedure was followed correctly',
          'Sampling error, which is unrelated to hypothesis testing'
        ],
        correctIndex: 1,
        explanation: 'Rejecting a null hypothesis that was actually true (concluding an effect exists when it does not) is precisely the definition of a Type I error, or "false positive" — a costly mistake commonly guarded against with significance thresholds like p < 0.05.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'An A/B test comparing two email subject lines gets p = 0.35. What is the correct conclusion?',
        options: [
          'The two subject lines are definitely equally effective, proven by the data',
          'Fail to reject the null hypothesis — the data does not provide sufficient evidence of a real difference between the two subject lines, but this does not prove they are truly identical in effect',
          'The test should be rerun immediately with the same sample size',
          'Subject line A is proven better because it was tested first'
        ],
        correctIndex: 1,
        explanation: 'A large p-value (0.35) means insufficient evidence to reject the null hypothesis — this is a "fail to reject," not a proof of equivalence. The true effect could still exist but be too small or the sample too limited to detect it confidently.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'A/B Test Analysis Framework',
      goal: 'Build a complete, reusable A/B test analysis tool that runs hypothesis tests and produces clear, correct business recommendations.',
      steps: [
        'Simulate an A/B test: control group (n=500) and treatment group (n=500) conversion outcomes, with treatment having a genuine small improvement built in.',
        'Write run_ab_test(control, treatment, alpha=0.05) that performs an appropriate statistical test, returns the test statistic, p-value, and a significance decision.',
        'Extend the tool to also test for a continuous metric (e.g., average order value) using an independent samples t-test.',
        'Compute and report the observed effect size (not just significance) alongside the p-value — statistical significance without practical significance should be flagged.',
        'Print a full report explaining the decision in plain business language, including a caveat about Type I/Type II error risk.',
      ],
      expectedOutput: 'Both proportion-based and continuous A/B tests correctly implemented. P-values and effect sizes both reported. Report clearly distinguishes statistical significance from practical importance, with appropriate caveats.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'linear_algebra_basics_ds3',
    topicTitle: 'Linear Algebra Basics',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 35,
    totalXp: 150,
    emoji: '➗',
    intro: 'Every machine learning model — from linear regression to deep neural networks — is fundamentally linear algebra at scale. Vectors, matrices, and their operations are the mathematical language that data, features, and model weights are all expressed in. This lesson demystifies the core operations you will see constantly.',
    concepts: [
      ConceptLesson(
        title: 'Vectors: Data Points as Directions and Magnitudes',
        definition: 'A vector is an ordered list of numbers representing both a direction and magnitude in space — in data science, a single data record with multiple features (e.g., a customer\'s age, income, purchases) is naturally represented as a vector.',
        analogy: 'A vector is like a set of GPS directions: "go 3 blocks east, 4 blocks north" — it has both a magnitude (how far, the total distance traveled) and a direction (which way). A customer\'s feature vector [age=25, income=50000, purchases=12] similarly encodes a specific "location" for that customer in an abstract feature space.',
        example: 'Every row in a Pandas DataFrame used for machine learning is effectively a vector — a single customer, product, or transaction represented as a list of numbers. Similarity between two customers can be measured by the distance between their feature vectors — this is literally how recommendation systems find "similar" users.',
        keyTakeaway: 'Thinking of data records as vectors in a multi-dimensional space (not just rows in a spreadsheet) unlocks intuition for distance-based algorithms (k-nearest neighbors, clustering) and is the essential first mental shift toward understanding how machine learning actually works internally.',
        codeSnippet: 'import numpy as np\ncustomer_a = np.array([25, 50000, 12])   # age, income, purchases\ncustomer_b = np.array([27, 52000, 15])\n\n# Euclidean distance = how "similar" these customers are\ndistance = np.linalg.norm(customer_a - customer_b)\nprint(f"Distance between customers: {distance:.2f}")',
      ),
      ConceptLesson(
        title: 'Matrices: Datasets and Transformations',
        definition: 'A matrix is a rectangular grid of numbers — in data science, an entire dataset (rows = observations, columns = features) is a matrix. Matrices can also represent transformations that map one set of vectors to another.',
        analogy: 'A matrix is like a full spreadsheet of data, but it is also simultaneously a "machine" that can transform vectors — feeding a vector into a matrix (via multiplication) is like passing an input through a black-box process that produces a new, transformed output vector.',
        example: 'A dataset of 1000 customers with 5 features is a 1000×5 matrix. A linear regression model\'s weights form a matrix that "transforms" the feature matrix into a vector of predictions. Every layer of a neural network is literally a matrix multiplication followed by a non-linear transformation.',
        keyTakeaway: 'The shape of a matrix (rows × columns) determines what operations are valid — mismatched matrix shapes cause the majority of errors when building machine learning pipelines. Always track and mentally verify shapes at every step of a data processing pipeline.',
        codeSnippet: 'import numpy as np\n# Dataset matrix: 5 customers, 3 features\nX = np.array([\n    [25, 50000, 12],\n    [32, 65000, 8],\n    [45, 90000, 20],\n    [29, 55000, 15],\n    [38, 72000, 10]\n])\nprint(f"Shape: {X.shape}")   # (5, 3) - 5 rows, 3 columns',
      ),
      ConceptLesson(
        title: 'Matrix Multiplication: The Engine of Machine Learning',
        definition: 'Matrix multiplication combines two matrices by taking dot products of rows and columns — this single operation is the computational core of linear regression, neural network forward passes, and virtually every ML algorithm\'s prediction step.',
        analogy: 'Matrix multiplication is like a weighted voting system: each output value is computed by taking every input value, multiplying it by its assigned weight, and summing — exactly like a school combining a student\'s scores across subjects (inputs) using each subject\'s credit weight (weights) to compute a final GPA (output).',
        example: 'Linear regression prediction is literally: predictions = X @ weights, where X is the (samples × features) data matrix and weights is a (features,) vector. This single matrix multiplication computes every prediction for every sample simultaneously — the same operation, scaled up, powers every layer of a neural network.',
        keyTakeaway: 'For matrix multiplication A @ B to work, the number of columns in A must equal the number of rows in B — this shape compatibility rule is the single most common source of errors ("shape mismatch") when building models, and checking shapes before multiplying prevents hours of debugging.',
        codeSnippet: 'import numpy as np\nX = np.array([[25, 50000, 12], [32, 65000, 8], [45, 90000, 20]])  # (3,3)\nweights = np.array([0.5, 0.0001, 2.0])   # (3,)\n\npredictions = X @ weights   # (3,3) @ (3,) = (3,) predictions\nprint(f"Predictions: {predictions}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'Why is representing a customer record as a vector useful for machine learning algorithms like k-nearest neighbors?',
        options: [
          'Vectors are only useful for storing text data',
          'Vectors allow mathematical distance calculations between records — treating customers as points in a multi-dimensional feature space enables measuring how "similar" two customers are using standard distance formulas',
          'Vectors are required by Python and have no mathematical significance',
          'Vector representation eliminates the need for any data cleaning'
        ],
        correctIndex: 1,
        explanation: 'Representing records as vectors enables geometric operations like distance and similarity calculations — the foundation of algorithms like k-nearest neighbors, clustering, and recommendation systems that all rely on measuring "closeness" between data points.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'You have a data matrix X of shape (500, 10) and want to multiply it by a weights vector to get predictions. What shape must the weights vector have?',
        options: [
          '(500,) — matching the number of rows',
          '(10,) — matching the number of columns in X, so that X @ weights produces a valid (500,) prediction vector',
          '(500, 10) — matching X exactly',
          'Shape does not matter for matrix multiplication'
        ],
        correctIndex: 1,
        explanation: 'For X @ weights to be valid, weights must have shape (10,) to match X\'s 10 columns — the multiplication then produces one prediction per row, resulting in a (500,) output vector. This shape-matching rule is fundamental to all matrix operations in ML.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You get a "shapes not aligned" error when computing X @ weights, where X has shape (200, 5) and weights has shape (4,). What is the fix?',
        options: [
          'Ignore the error and force the computation with a try/except block',
          'weights must be reshaped or corrected to have shape (5,) to match X\'s number of columns — the mismatch (4 vs 5) is exactly what breaks the matrix multiplication rule',
          'X should be reshaped to (200, 4) by dropping the last column',
          'Matrix multiplication does not require shape matching in NumPy'
        ],
        correctIndex: 1,
        explanation: 'The rule for A @ B is that A\'s number of columns must equal B\'s number of rows (or length for a 1D vector). Since X has 5 columns, weights needs exactly 5 elements — the fix is correcting weights to shape (5,), not altering X or ignoring the error.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Linear Algebra Prediction Engine',
      goal: 'Build a simple linear prediction system entirely from NumPy vectors and matrices, demonstrating core linear algebra operations in an ML context.',
      steps: [
        'Create a feature matrix X of shape (100, 4) representing 100 houses with features: sqft, bedrooms, bathrooms, age (use NumPy random generation).',
        'Create a weights vector of shape (4,) representing the "importance" of each feature toward price.',
        'Compute predictions using matrix multiplication: predictions = X @ weights + bias.',
        'Use np.linalg.norm() to compute the Euclidean distance between the first 5 houses (pairwise) to identify the two most similar houses.',
        'Print a report showing predictions, distances, and the shapes of every array involved at each step (to reinforce shape-tracking habits).',
      ],
      expectedOutput: 'Feature matrix, weights, and predictions all correctly computed with matching shapes. Pairwise distances correctly identify the most similar house pair. Shape-tracking report printed at each computational step.',
      xpReward: 60,
    ),
  ),

  TopicCourse(
    id: 'calculus_basics_ml_ds3',
    topicTitle: 'Calculus Basics for Machine Learning',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 30,
    totalXp: 145,
    emoji: '📉',
    intro: 'How does a machine learning model actually "learn"? The answer is calculus — specifically derivatives and gradients, which tell an algorithm which direction to adjust its parameters to reduce error. You do not need to solve calculus by hand, but understanding what a gradient represents transforms machine learning from a black box into an intuitive process.',
    concepts: [
      ConceptLesson(
        title: 'Derivatives: The Rate of Change',
        definition: 'A derivative measures how a function\'s output changes as its input changes by a tiny amount — it is the instantaneous slope of the function at a given point, telling you the direction and steepness of change.',
        analogy: 'A derivative is like a speedometer reading at a specific instant during a car trip — while your average speed over the whole journey is one number, the speedometer tells you your EXACT rate of change (speed) at this precise moment, which might be very different from the trip average.',
        example: 'If a model\'s error (loss) is a function of one weight parameter, the derivative of loss with respect to that weight tells you: "if I nudge this weight up slightly, does the error increase or decrease, and how fast?" This is exactly the information needed to improve the model.',
        keyTakeaway: 'A positive derivative means the function is increasing at that point; a negative derivative means it is decreasing. Machine learning training algorithms use this sign and magnitude to decide which direction and how far to adjust each parameter.',
        codeSnippet: 'import numpy as np\n\ndef loss(w):\n    return (w - 5) ** 2  # minimum at w=5\n\n# Numerical derivative approximation\ndef numerical_derivative(f, w, h=1e-5):\n    return (f(w + h) - f(w - h)) / (2 * h)\n\nfor w in [0, 3, 5, 8]:\n    print(f"At w={w}: derivative = {numerical_derivative(loss, w):.2f}")\n# Negative before 5, zero at 5, positive after 5',
      ),
      ConceptLesson(
        title: 'Gradients: Derivatives in Multiple Dimensions',
        definition: 'A gradient is the vector of partial derivatives for a function with multiple inputs — it points in the direction of steepest increase, and its negative points in the direction of steepest decrease, which is exactly the direction machine learning models move during training.',
        analogy: 'A gradient is like standing on a hillside and feeling which direction is steepest uphill — your body naturally senses this multi-dimensional "slope" instinctively. Gradient descent algorithms do the mathematical equivalent: computing the steepest uphill direction, then deliberately stepping the opposite way (downhill) to reduce error.',
        example: 'A linear regression model with 10 features has a loss function depending on 10 weights simultaneously. The gradient is a 10-dimensional vector — each component tells you how much that specific weight should change to reduce the model\'s error, computed all at once.',
        keyTakeaway: 'Every "training" process in machine learning — from simple linear regression to deep neural networks with billions of parameters — is fundamentally repeated gradient computation followed by small steps in the negative gradient direction. This is called gradient descent.',
        codeSnippet: 'import numpy as np\n\ndef loss(w1, w2):\n    return (w1 - 3)**2 + (w2 - 5)**2  # minimum at (3, 5)\n\ndef gradient(w1, w2, h=1e-5):\n    dw1 = (loss(w1+h, w2) - loss(w1-h, w2)) / (2*h)\n    dw2 = (loss(w1, w2+h) - loss(w1, w2-h)) / (2*h)\n    return np.array([dw1, dw2])\n\ngrad = gradient(0, 0)\nprint(f"Gradient at (0,0): {grad}")   # points toward increasing loss\nprint("Move opposite direction to reduce loss")',
      ),
      ConceptLesson(
        title: 'Gradient Descent: How Models Learn',
        definition: 'Gradient descent is an iterative optimization algorithm that repeatedly computes the gradient of a loss function and takes small steps in the negative gradient direction, gradually converging toward parameter values that minimize error.',
        analogy: 'Gradient descent is like descending a foggy mountain in the dark with only a slope-detector at your feet — you cannot see the valley bottom (optimal solution) directly, but by repeatedly checking which direction is downhill and taking a small step that way, you eventually reach the bottom, one careful step at a time.',
        example: 'Training a linear regression model: start with random weights (high error). Compute the gradient (which direction reduces error fastest). Take a small step in that direction (controlled by "learning rate"). Repeat hundreds or thousands of times until the error stops meaningfully decreasing — you have found the model\'s learned weights.',
        keyTakeaway: 'The "learning rate" controls step size — too large and the algorithm can overshoot and diverge (never settling); too small and training takes an impractically long time to converge. Choosing an appropriate learning rate is one of the most common practical tuning decisions in machine learning.',
        codeSnippet: 'import numpy as np\n\ndef loss(w): return (w - 5) ** 2\ndef gradient(w, h=1e-5): return (loss(w+h) - loss(w-h)) / (2*h)\n\nw = 0.0            # random starting point\nlearning_rate = 0.1\n\nfor step in range(20):\n    grad = gradient(w)\n    w = w - learning_rate * grad     # step opposite the gradient\n    if step % 5 == 0:\n        print(f"Step {step}: w={w:.3f}, loss={loss(w):.4f}")\nprint(f"Converged near w=5: final w={w:.3f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A model\'s loss function has a derivative of -4.2 with respect to a weight at its current value. What does this tell the training algorithm?',
        options: [
          'The weight should be decreased to reduce loss further, since a negative derivative here means increasing the weight moves toward lower loss and gradient descent steps in the negative gradient direction',
          'The model has already found the optimal weight and training should stop',
          'The derivative value has no practical meaning for training',
          'The loss function is incorrectly defined'
        ],
        correctIndex: 0,
        explanation: 'A negative derivative means the loss is decreasing as the weight increases — gradient descent moves in the negative gradient direction, meaning it will increase this weight (opposite the negative sign) to continue reducing loss, moving toward the minimum.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'During gradient descent training, the loss value oscillates wildly and never settles down, getting worse over time. What is the most likely cause?',
        options: [
          'The dataset is too large for gradient descent to work',
          'The learning rate is too high, causing the algorithm to overshoot the minimum repeatedly instead of smoothly converging toward it',
          'The gradient was computed incorrectly and calculus does not apply here',
          'This is normal behavior and training should continue indefinitely'
        ],
        correctIndex: 1,
        explanation: 'Wild oscillation and worsening loss during gradient descent is the classic symptom of a learning rate set too high — the algorithm takes steps so large it repeatedly overshoots past the minimum in each direction rather than smoothly converging.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You are implementing gradient descent and need to choose a learning rate. Training is currently far too slow to converge in a reasonable number of steps. What is the most direct fix?',
        options: [
          'Decrease the learning rate further to slow down training even more',
          'Increase the learning rate so each step moves further toward the minimum, speeding up convergence — while monitoring for oscillation as a sign it has become too large',
          'Learning rate has no effect on convergence speed',
          'Switch to a completely different loss function'
        ],
        correctIndex: 1,
        explanation: 'A learning rate that is too small causes slow convergence — increasing it allows larger steps toward the minimum on each iteration, speeding up training. The right approach is to increase it while watching for oscillation, which signals it has become too large.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Gradient Descent from Scratch',
      goal: 'Implement a working gradient descent optimizer from scratch to fit a simple linear regression model, visualizing the learning process.',
      steps: [
        'Generate synthetic data: 100 points following y = 3x + 7 with added random noise, using NumPy.',
        'Define a mean squared error loss function comparing predictions (w*x + b) against true y values.',
        'Implement numerical gradient computation for both weight (w) and bias (b) parameters.',
        'Implement a training loop that runs gradient descent for 200 iterations, recording loss at each step.',
        'Plot the loss curve over iterations (should decrease and flatten) and plot the final fitted line against the data points, along with a comparison of learned vs true parameters (3 and 7).',
      ],
      expectedOutput: 'Loss curve shows clear decreasing and flattening pattern. Final learned w and b values are close to the true values (3 and 7). Fitted line visually matches the data well.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'statistics_with_python_ds3',
    topicTitle: 'Statistics with Python',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 35,
    totalXp: 155,
    emoji: '🐍',
    intro: 'Theory becomes practice here — this lesson consolidates everything from descriptive statistics through hypothesis testing into a fluent, practical Python statistical workflow using SciPy, NumPy, Pandas, and statsmodels — the toolkit you will actually reach for on the job every single day.',
    concepts: [
      ConceptLesson(
        title: 'SciPy.stats: The Statistical Toolkit',
        definition: 'scipy.stats provides implementations of every major probability distribution, statistical test, and descriptive function needed for professional statistical analysis — it is the single most important library for applied statistics in Python.',
        analogy: 'scipy.stats is like a fully-stocked statistical laboratory in a single Python import — instead of manually deriving formulas for t-tests, chi-square tests, or distribution probabilities, you have precise, well-tested instruments ready to use immediately, the way a chemist reaches for calibrated lab equipment instead of building it from raw materials each time.',
        example: 'Nearly every hypothesis test covered in this level has a direct scipy.stats function: stats.ttest_ind() for comparing two group means, stats.chi2_contingency() for categorical association, stats.pearsonr() for correlation with a p-value, stats.shapiro() for testing normality — all with rigorous, peer-reviewed implementations.',
        keyTakeaway: 'Learning to navigate scipy.stats\'s documentation and choose the right test for a given data type and question is a more valuable long-term skill than memorizing statistical formulas — the library handles the computation correctly; your job is choosing the right tool.',
        codeSnippet: 'from scipy import stats\nimport numpy as np\n\ndata = np.array([23, 45, 12, 67, 34, 29, 51, 38])\nprint(f"Mean: {stats.tmean(data):.2f}")\nprint(f"Std: {stats.tstd(data):.2f}")\nprint(f"Skewness: {stats.skew(data):.2f}")\nprint(f"Normality test p-value: {stats.shapiro(data).pvalue:.3f}")',
      ),
      ConceptLesson(
        title: 'Choosing the Right Statistical Test',
        definition: 'Test selection depends on data type (continuous vs categorical) and structure (one group vs two groups vs more than two, related vs independent samples) — using the wrong test produces technically-computable but statistically invalid results.',
        analogy: 'Choosing a statistical test is like choosing the right medical diagnostic tool for a symptom — an X-ray, blood test, and MRI each answer different questions and are appropriate for different situations. Using an X-ray to diagnose a blood condition would produce a confident but completely wrong answer, just as using the wrong statistical test produces confidently wrong conclusions.',
        example: 'Comparing two independent groups\' means (continuous data) → independent t-test. Comparing more than two groups\' means → ANOVA. Testing association between two categorical variables → chi-square test. Comparing before/after measurements on the SAME subjects → paired t-test, not independent t-test.',
        keyTakeaway: 'A simple decision framework: (1) What data type — continuous or categorical? (2) How many groups — one, two, or more? (3) Are samples independent or paired/related? Answering these three questions almost always points to the correct test.',
        codeSnippet: 'from scipy import stats\nimport numpy as np\n\n# Before/after weight loss program - PAIRED data (same people)\nbefore = np.array([80, 92, 75, 88, 95, 70])\nafter  = np.array([78, 89, 74, 85, 91, 68])\n\n# Correct: paired t-test, not independent t-test\nt_stat, p_value = stats.ttest_rel(before, after)\nprint(f"Paired t-test p-value: {p_value:.4f}")',
      ),
      ConceptLesson(
        title: 'A Complete Statistical Workflow in Python',
        definition: 'A professional statistical analysis in Python follows a consistent sequence: load and inspect data, check assumptions (normality, independence), compute descriptive statistics, visualize, run the appropriate test, and interpret results in business context.',
        analogy: 'A statistical workflow is like following a structured investigation checklist rather than jumping straight to a conclusion — a good detective examines the scene (descriptive stats), checks assumptions (is this evidence reliable?), gathers evidence (runs tests), and only then presents a well-supported conclusion, never skipping steps even when the answer seems obvious.',
        example: 'Analyzing whether a new website layout improves time-on-page: load session data, check for outliers and missing values, visualize the distributions of both groups, test for normality (informing test choice), run the appropriate test (t-test or its non-parametric alternative), and report both statistical significance AND effect size with business interpretation.',
        keyTakeaway: 'Skipping the assumption-checking step is the most common mistake in applied statistics — running a t-test on heavily skewed data with small sample size, without checking normality, can produce unreliable p-values; a non-parametric alternative (like Mann-Whitney U) may be more appropriate.',
        codeSnippet: 'from scipy import stats\nimport numpy as np\n\nnp.random.seed(0)\ngroup_a = np.random.normal(50, 10, 40)\ngroup_b = np.random.normal(55, 10, 40)\n\n# Step 1: Check normality\nprint(f"A normal? p={stats.shapiro(group_a).pvalue:.3f}")\nprint(f"B normal? p={stats.shapiro(group_b).pvalue:.3f}")\n\n# Step 2: Check equal variance\nlevene_p = stats.levene(group_a, group_b).pvalue\nprint(f"Equal variance? p={levene_p:.3f}")\n\n# Step 3: Run appropriate test based on checks\nt_stat, p_val = stats.ttest_ind(group_a, group_b, equal_var=(levene_p > 0.05))\nprint(f"t-test p-value: {p_val:.4f}")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'You want to compare average test scores between two SEPARATE classes (different students in each). Which SciPy function is appropriate?',
        options: [
          'stats.ttest_rel() — for paired/related samples',
          'stats.ttest_ind() — for independent samples, since the two classes contain entirely different students with no natural pairing between them',
          'stats.pearsonr() — for correlation between two variables',
          'stats.chi2_contingency() — for categorical association'
        ],
        correctIndex: 1,
        explanation: 'Two separate classes with different students are independent samples — there is no natural one-to-one pairing between a student in class A and a student in class B, making the independent samples t-test (ttest_ind) the correct choice.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Before running an independent t-test, why is it good practice to check normality and equal variance assumptions first?',
        options: [
          'These checks are purely a formality with no effect on results',
          'Violating these assumptions (especially with small samples) can make the t-test\'s p-value unreliable — checking first helps decide whether to use a standard t-test, a Welch\'s t-test (unequal variance), or a non-parametric alternative',
          'Python will throw an error if assumptions are not checked first',
          'Assumption checking is only required for chi-square tests'
        ],
        correctIndex: 1,
        explanation: 'Statistical tests rely on underlying assumptions to guarantee valid results. Checking normality and variance equality first lets you select the correctly adapted version of the test (or a different test entirely), avoiding unreliable conclusions from violated assumptions.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You measure the SAME group of 30 employees\' productivity before and after a training program. Which test correctly accounts for the paired structure of this data?',
        options: [
          'stats.ttest_ind() treating before and after as two independent groups',
          'stats.ttest_rel() — a paired t-test, which correctly accounts for the fact that before/after measurements come from the same individuals rather than treating them as unrelated groups',
          'stats.chi2_contingency(), since productivity is a categorical variable',
          'Any test works equally well since sample size is the only thing that matters'
        ],
        correctIndex: 1,
        explanation: 'Because the before and after measurements come from the exact same employees, this is paired (related) data — using ttest_rel() properly accounts for the natural correlation between each employee\'s two measurements, which ttest_ind() would incorrectly ignore.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Complete Statistical Analysis Pipeline',
      goal: 'Build an end-to-end Python statistical analysis pipeline that automatically selects and runs the appropriate test for different business questions.',
      steps: [
        'Simulate three datasets: (1) two independent groups (control/treatment conversion rates), (2) paired before/after employee performance scores, (3) a contingency table of customer segment vs product category.',
        'Write check_normality(data) using stats.shapiro and check_variance_equality(a, b) using stats.levene.',
        'Write auto_select_test(data_type, groups, paired) that selects and runs the correct test based on the answers, returning the test name, statistic, and p-value.',
        'Run the pipeline on all three simulated datasets, printing which test was chosen and why.',
        'Write a final summary report interpreting all three results in plain business language, including effect size where relevant.',
      ],
      expectedOutput: 'Correct test automatically selected for each of the three data scenarios (independent t-test, paired t-test, chi-square). All results computed correctly with clear plain-language interpretation.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'practical_statistical_analysis_ds3',
    topicTitle: 'Practical Statistical Analysis',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 35,
    totalXp: 155,
    emoji: '🧮',
    intro: 'Real analyses rarely fit textbook examples cleanly. This lesson works through the messy realities of practical statistical analysis: handling outliers responsibly, dealing with small samples, choosing between parametric and non-parametric tests, and communicating statistical findings honestly to non-technical stakeholders.',
    concepts: [
      ConceptLesson(
        title: 'Outlier Detection and Responsible Handling',
        definition: 'Outliers are extreme values that deviate substantially from the rest of the data — they can be genuine (a real large transaction) or errors (a data entry mistake). Responsible handling requires investigating the cause before deciding to keep, transform, or remove them.',
        analogy: 'Handling outliers is like a doctor investigating an unusual lab result — before dismissing it as a "lab error" or treating it as a serious medical finding, the doctor investigates the context. Automatically deleting every unusual result without investigation risks missing genuinely important information; automatically trusting every unusual result risks reacting to noise.',
        example: 'A single ₹50 lakh transaction in a dataset of typical ₹5,000 purchases could be: a data entry error (extra zero typed), a legitimate wholesale/bulk order, or fraud. Each explanation demands a completely different response — correction, keeping as valid data, or flagging for investigation — and only domain investigation can distinguish them.',
        keyTakeaway: 'The IQR method (values beyond 1.5×IQR from the quartiles) and z-score method (values beyond 3 standard deviations) are common statistical outlier flags — but flagging is only the first step; the decision to remove, cap, transform, or keep requires business context, not just a statistical rule applied blindly.',
        codeSnippet: 'import numpy as np\n\ndata = np.array([45, 52, 48, 51, 47, 500, 49, 53, 46])\nQ1, Q3 = np.percentile(data, [25, 75])\nIQR = Q3 - Q1\nlower, upper = Q1 - 1.5*IQR, Q3 + 1.5*IQR\noutliers = data[(data < lower) | (data > upper)]\nprint(f"Flagged outliers: {outliers}")  # [500] - investigate before acting',
      ),
      ConceptLesson(
        title: 'Non-Parametric Tests: When Assumptions Fail',
        definition: 'Non-parametric tests make fewer assumptions about the underlying data distribution (no normality requirement) — they are the appropriate choice when data is heavily skewed, contains outliers, or comes from small samples where normality cannot be verified.',
        analogy: 'Non-parametric tests are like using a universal tool that works reliably in almost any situation, versus a specialized precision tool that only works perfectly under ideal conditions. Parametric tests (like the t-test) are the precision tool — powerful but require the "ideal conditions" of roughly normal data; non-parametric tests sacrifice a little power for much broader applicability.',
        example: 'The Mann-Whitney U test is the non-parametric alternative to the independent t-test, comparing rank-order rather than raw means — appropriate for comparing two skewed distributions of transaction values. The Wilcoxon signed-rank test replaces the paired t-test under the same non-normal conditions.',
        keyTakeaway: 'When in doubt about normality — especially with small samples (n < 30) or visibly skewed data — non-parametric tests are the statistically safer choice. They are slightly less powerful when normality assumptions truly hold, but far more robust when those assumptions are violated.',
        codeSnippet: 'from scipy import stats\nimport numpy as np\n\n# Skewed transaction data - t-test assumptions likely violated\ngroup_a = np.array([120, 95, 800, 110, 105, 98, 115])\ngroup_b = np.array([140, 130, 125, 900, 135, 128, 145])\n\n# Non-parametric alternative to independent t-test\nstat, p_value = stats.mannwhitneyu(group_a, group_b)\nprint(f"Mann-Whitney U p-value: {p_value:.4f}")',
      ),
      ConceptLesson(
        title: 'Effect Size: Beyond Statistical Significance',
        definition: 'Effect size quantifies the MAGNITUDE of a difference or relationship, independent of sample size — unlike p-values, which can show "significance" for even tiny, practically meaningless effects if the sample is large enough.',
        analogy: 'Statistical significance tells you "this difference is probably real, not just noise" — but effect size tells you "and here is how big and meaningful that real difference actually is." A doctor confirming a new drug "significantly" lowers blood pressure by 0.3 mmHg (statistically real, clinically meaningless) is very different from a 15 mmHg reduction (both real AND important).',
        example: 'With a sample of 1 million users, even a conversion rate difference of 0.01% can be "statistically significant" (p < 0.05) — but this tiny effect size may have negligible business impact. Cohen\'s d for continuous outcomes and odds ratios for categorical outcomes are standard effect size measures reported alongside p-values.',
        keyTakeaway: 'Always report effect size alongside p-value. A large sample can make trivial differences "statistically significant," while a small sample can make substantial, important differences fail to reach significance — effect size is what tells you whether a finding actually matters practically.',
        codeSnippet: 'import numpy as np\n\ndef cohens_d(group1, group2):\n    n1, n2 = len(group1), len(group2)\n    pooled_std = np.sqrt(((n1-1)*group1.var(ddof=1) + (n2-1)*group2.var(ddof=1)) / (n1+n2-2))\n    return (group1.mean() - group2.mean()) / pooled_std\n\ngroup_a = np.array([50, 52, 48, 51, 49])\ngroup_b = np.array([55, 57, 53, 56, 54])\nd = cohens_d(group_a, group_b)\nprint(f"Cohen\'s d: {d:.2f}")  # ~0.2 small, ~0.5 medium, ~0.8+ large effect',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A dataset has one transaction of ₹50,00,000 among typical ₹5,000 purchases. What is the RESPONSIBLE first step before handling this outlier?',
        options: [
          'Immediately delete the value without investigation',
          'Investigate the underlying business context — check if it is a data entry error, a legitimate bulk order, or potential fraud — before deciding whether to remove, cap, or keep the value',
          'Automatically replace it with the mean of all other values',
          'Ignore it since one value cannot affect a large dataset'
        ],
        correctIndex: 1,
        explanation: 'Responsible outlier handling always starts with investigation into WHY the value is extreme — the appropriate action (remove, correct, keep, or flag for review) depends entirely on the underlying cause, which cannot be determined from the statistics alone.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A test shows a statistically significant result (p = 0.001) with a very large sample size, but the effect size (Cohen\'s d) is only 0.02. What should you conclude?',
        options: [
          'This is an extremely important, actionable finding because p is very small',
          'While statistically significant, the effect size is negligible — the practical, real-world importance of this difference is likely minimal despite the small p-value, which is heavily influenced by the large sample size',
          'The p-value and effect size must be contradictory and one is wrong',
          'Effect size does not matter if the p-value is significant'
        ],
        correctIndex: 1,
        explanation: 'Large samples can produce statistically significant p-values even for practically trivial effects. A tiny Cohen\'s d (0.02) indicates the actual difference between groups is negligible in real-world terms, regardless of how small the p-value is — significance and importance are separate questions.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'You need to compare median delivery times between two couriers, but the data is heavily right-skewed with several extreme delays. Which test is most appropriate?',
        options: [
          'Independent samples t-test, since it is the standard test for comparing two groups',
          'Mann-Whitney U test — the non-parametric alternative that does not assume normality and is more robust to the skew and outliers present in this delivery time data',
          'Chi-square test, since delivery times are numeric',
          'No test is possible with skewed data'
        ],
        correctIndex: 1,
        explanation: 'Heavily skewed data with outliers violates the t-test\'s normality assumption. The Mann-Whitney U test compares distributions using ranks rather than raw means, making it far more robust and appropriate for this skewed, outlier-prone delivery time scenario.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Robust Statistical Analysis of Real-World Messy Data',
      goal: 'Perform a complete, defensible statistical analysis on a deliberately messy, realistic dataset, handling outliers and choosing appropriate tests responsibly.',
      steps: [
        'Simulate a customer transaction dataset (n=300) with realistic right-skew and several deliberate outliers (some plausible bulk orders, some clearly data-entry errors like negative amounts).',
        'Write detect_outliers(data) using the IQR method, then investigate and classify each flagged outlier (as "likely error" or "plausible legitimate value") based on defined business rules.',
        'Compare average transaction value between two customer segments using BOTH a t-test and a Mann-Whitney U test — compare and discuss why results might differ.',
        'Compute Cohen\'s d for the segment comparison and interpret the practical significance alongside the p-value.',
        'Write a final decision memo (in plain language) recommending how outliers should be handled and which statistical test result should be trusted, with justification.',
      ],
      expectedOutput: 'Outliers correctly flagged and classified with justification. Both parametric and non-parametric tests run and compared. Effect size computed and interpreted correctly. Clear, well-justified final recommendation memo.',
      xpReward: 65,
    ),
  ),

  TopicCourse(
    id: 'real_world_ds_case_study_ds3',
    topicTitle: 'Real-world Data Science Case Study',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Intermediate',
    estimatedMinutes: 60,
    totalXp: 210,
    emoji: '🏆',
    intro: 'This is your Level 3 capstone — a complete statistical investigation of a realistic business problem, applying every concept from this level: descriptive statistics, probability, distributions, correlation, sampling theory, confidence intervals, and hypothesis testing, woven into one coherent, portfolio-worthy analysis.',
    concepts: [
      ConceptLesson(
        title: 'Framing a Business Question Statistically',
        definition: 'Translating a vague business question ("is our new pricing working?") into a precise, testable statistical question ("has average revenue per user increased significantly since the pricing change, controlling for seasonality?") is the essential first skill of applied data science.',
        analogy: 'Framing a business question statistically is like a lawyer translating a client\'s complaint ("they wronged me") into a specific, provable legal claim with clear evidence requirements — vague grievances cannot be resolved in court, just as vague business questions cannot be resolved with data until they are made precise and testable.',
        example: '"Is the new checkout flow better?" is too vague. The statistically precise version: "Is the conversion rate for the new checkout flow significantly higher than the old flow, based on a properly randomized A/B test with adequate sample size, measured over a comparable time period?" This precision determines exactly what data to collect and which test to run.',
        keyTakeaway: 'Every strong data science project starts with writing down the precise, testable version of the business question BEFORE touching any data — this prevents the common trap of fishing through data for any significant-looking pattern (p-hacking) after the fact.',
      ),
      ConceptLesson(
        title: 'Connecting Descriptive, Inferential, and Business Insight',
        definition: 'A complete statistical analysis moves through three connected layers: descriptive statistics (what does the data show), inferential statistics (does this generalize beyond the sample, and how confident can we be), and business insight (what should we actually do about it).',
        analogy: 'These three layers are like a news story\'s structure: descriptive statistics are the raw facts ("sales were 12% higher"), inferential statistics are the fact-checking ("is this a real trend or random noise, and how sure are we"), and business insight is the editorial takeaway ("here is what this means for the reader and what should happen next").',
        example: 'Descriptive: "Average order value in the treatment group is ₹850 vs ₹790 in control." Inferential: "This ₹60 difference has a 95% CI of [₹35, ₹85] and p=0.002 — statistically significant with a moderate effect size." Business insight: "Rolling out this change company-wide would plausibly increase revenue by 6-8%, worth an estimated ₹2 crore annually — recommend full rollout."',
        keyTakeaway: 'Never present descriptive statistics alone as if they were conclusive, and never present a p-value alone without translating it into what it means for decision-making — connecting all three layers is what separates a genuinely useful analysis from a report full of disconnected numbers.',
      ),
      ConceptLesson(
        title: 'Communicating Statistical Findings Honestly',
        definition: 'Honest statistical communication means reporting uncertainty (confidence intervals, not just point estimates), acknowledging limitations (sample size, potential confounders, non-random sampling), and avoiding overstated causal claims from observational or correlational data.',
        analogy: 'Honest statistical communication is like a weather forecaster who says "70% chance of rain" rather than falsely promising "it will rain" or "it will not rain" — acknowledging genuine uncertainty builds more trust and leads to better decisions than false confidence, even when the honest answer is less satisfying to deliver.',
        example: 'Instead of "the new feature increases revenue" (overclaiming certainty), honest communication states: "based on a 4-week A/B test with 10,000 users per group, the new feature shows a statistically significant 8% revenue increase (95% CI: 4-12%), though longer-term effects and interactions with seasonality were not tested."',
        keyTakeaway: 'Stakeholders generally respect honest uncertainty far more than they initially seem to want false certainty — and honest communication protects both the business (from bad decisions) and the analyst\'s credibility (from findings that do not replicate) far better than overselling results.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'A business stakeholder asks "is our new feature good?" What is the FIRST step a data scientist should take before touching any data?',
        options: [
          'Immediately pull all available data and look for any interesting patterns',
          'Translate the vague question into a precise, testable statistical question — defining the specific metric, comparison groups, and success criteria before any analysis begins',
          'Run every possible statistical test on the data and report whichever shows significance',
          'Assume the feature is good since the business built it intentionally'
        ],
        correctIndex: 1,
        explanation: 'Precisely framing the business question first — before any data exploration — prevents p-hacking (fishing for any significant pattern) and ensures the eventual analysis actually answers the question that matters, rather than an accidental, uninterpretable one.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Why is reporting a confidence interval alongside a point estimate considered more honest than reporting the point estimate alone?',
        options: [
          'Confidence intervals are always required by law for business reports',
          'A confidence interval communicates the genuine uncertainty in the estimate, giving stakeholders an honest sense of the plausible range rather than false precision from a single number',
          'Point estimates are always mathematically incorrect',
          'Confidence intervals eliminate all uncertainty from an estimate'
        ],
        correctIndex: 1,
        explanation: 'A single point estimate ("revenue increased by 8%") implies false precision. Adding the confidence interval ("8%, 95% CI: 4-12%") honestly communicates the genuine statistical uncertainty behind that estimate, supporting better-informed decision-making.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt: 'Your analysis finds a statistically significant correlation between a marketing campaign and sales growth, but the campaign was not randomly assigned (all high-potential regions received it). What must your report include?',
        options: [
          'A confident claim that the campaign directly caused the sales growth',
          'A clear caveat that this is an observational, non-randomized comparison — the correlation could partly or fully reflect the fact that high-potential regions were deliberately chosen, not a true causal effect of the campaign',
          'No caveat is needed since the correlation is statistically significant',
          'The analysis should be discarded entirely as worthless'
        ],
        correctIndex: 1,
        explanation: 'Non-random assignment (campaign given specifically to high-potential regions) introduces a confounding variable that could fully explain the observed correlation without any real campaign effect — honest reporting must flag this critical limitation rather than implying unproven causation.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Full Statistical Case Study: Retail Pricing Strategy Analysis',
      goal: 'Conduct a complete, portfolio-quality statistical investigation of a simulated retail pricing experiment, applying every technique from Level 3 in one integrated analysis.',
      steps: [
        'BUSINESS FRAMING: Write a precise problem statement — "Did the new dynamic pricing strategy significantly increase average revenue per transaction, and is the effect large enough to justify company-wide rollout?"',
        'DATA SIMULATION: Generate a realistic dataset (n=1200) of transactions split between control (old pricing) and treatment (new dynamic pricing) groups, with realistic right-skew and a genuine moderate effect built in, plus some data quality issues (outliers, a few missing values).',
        'DESCRIPTIVE ANALYSIS: Compute and visualize mean, median, std dev, and distribution shape for both groups; identify and responsibly handle outliers.',
        'INFERENTIAL ANALYSIS: Check normality assumptions; run the appropriate hypothesis test (parametric or non-parametric based on the check); compute a 95% confidence interval for the difference in means; compute Cohen\'s d effect size.',
        'CORRELATION CHECK: Examine whether a confounding variable (e.g., day of week or customer segment) correlates with pricing group assignment in a way that could bias results.',
        'FINAL REPORT: Write a complete business report with: executive summary, methodology, key statistics (with CIs), effect size interpretation, honest limitations section, and a clear go/no-go recommendation for company-wide rollout.',
      ],
      expectedOutput: '=== RETAIL PRICING STRATEGY — STATISTICAL CASE STUDY ===\nSample: 1200 transactions (control vs treatment)\nDescriptive Stats: [mean, median, std dev for both groups]\nOutliers: [count identified and handling decision]\nNormality Check: [result and test choice justification]\nHypothesis Test: [test used, statistic, p-value]\n95% CI for difference: [range]\nEffect Size (Cohen\'s d): [value and interpretation]\nConfounder Check: [result]\n\nRecommendation: [Clear go/no-go with full justification]\n\nLevel 3 Complete — Statistics & Mathematics for Data Science Mastered.\nReady for Level 4.',
      xpReward: 110,
    ),
  ),

];