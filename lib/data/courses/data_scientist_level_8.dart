import '../../models/course_content_data.dart';

const List<TopicCourse> dataScientistLevel8 = [
  TopicCourse(
    id: 'text_preprocessing_tokenization_ds8',
    topicTitle: 'Text Preprocessing & Tokenization',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 30,
    totalXp: 150,
    emoji: '✂️',
    intro:
        'Welcome to Level 8 — NLP & Generative AI. Before any language model can process text, that text must be broken down and cleaned into a structured, numeric form. Tokenization and preprocessing are the unglamorous but essential first step behind every chatbot, translator, and sentiment classifier you will ever build.',
    concepts: [
      ConceptLesson(
        title: 'Tokenization: Breaking Text into Units',
        definition:
            'Tokenization splits raw text into smaller units (tokens) — words, subwords, or characters — that a model can process. Modern NLP models typically use subword tokenization (like Byte-Pair Encoding), splitting rare or unfamiliar words into smaller, more common word-piece fragments.',
        analogy:
            'Tokenization is like breaking a sentence into individual LEGO bricks before building something with it — word-level tokenization uses whole-word bricks, while subword tokenization uses smaller, reusable bricks that can be combined to build even words the model has never seen whole before.',
        example:
            'Word-level tokenization splits "unbelievable" into one token: "unbelievable". Subword tokenization might split it into ["un", "##believ", "##able"] — allowing the model to understand the word by combining familiar smaller pieces, even if it never saw the exact full word during training.',
        keyTakeaway:
            'Subword tokenization (used by virtually all modern transformer models) elegantly solves the "out of vocabulary" problem — a model never needs to give up on an unfamiliar word entirely, since it can almost always be broken into smaller, previously-seen subword pieces.',
        codeSnippet:
            'from transformers import AutoTokenizer\n\ntokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")\ntext = "Unbelievable performance improvements"\ntokens = tokenizer.tokenize(text)\nprint(tokens)   # subword pieces\nprint(tokenizer.encode(text))   # numeric token IDs',
      ),
      ConceptLesson(
        title: 'Classic Text Cleaning: Stopwords, Stemming and Lemmatization',
        definition:
            'Traditional NLP preprocessing removes stopwords (common low-information words like "the," "is," "and"), and reduces words to a base form via stemming (crude suffix chopping) or lemmatization (proper dictionary-based root form) — reducing vocabulary size and noise for simpler, classical models.',
        analogy:
            'Removing stopwords is like filtering out filler words ("um," "like," "you know") from a transcript before analyzing its actual content. Lemmatization is like recognizing that "running," "ran," and "runs" are all just different forms of the same core concept "run" — grouping them together rather than treating each as a completely separate word.',
        example:
            'Stemming might crudely reduce "running" to "runn" (chopping the suffix without checking correctness), while lemmatization correctly reduces it to "run" (a real, valid dictionary word) — lemmatization is more linguistically accurate but computationally slower than stemming.',
        keyTakeaway:
            'Modern transformer-based models (Level 7-8\'s main focus) generally do NOT need this classical preprocessing — they learn directly from raw or lightly-cleaned text via subword tokenization. Stopword removal and stemming remain relevant primarily for simpler classical models like the Naive Bayes text classifier from Level 5.',
        codeSnippet:
            'import nltk\nfrom nltk.corpus import stopwords\nfrom nltk.stem import WordNetLemmatizer\n\nstop_words = set(stopwords.words("english"))\nlemmatizer = WordNetLemmatizer()\n\nwords = ["running", "the", "quickly", "dogs", "is"]\ncleaned = [lemmatizer.lemmatize(w) for w in words if w not in stop_words]\nprint(cleaned)   # [\'running\'->\'running\', \'quickly\', \'dog\']',
      ),
      ConceptLesson(
        title: 'Building a Text Preprocessing Pipeline',
        definition:
            'A complete text preprocessing pipeline combines lowercasing, punctuation/special character removal, tokenization, and (depending on the downstream model) stopword removal or lemmatization — applied consistently to every piece of text before it enters a model, whether classical ML or a modern transformer.',
        analogy:
            'A text preprocessing pipeline is like a standardized intake process at a hospital — every patient, regardless of how they initially describe their symptoms, goes through the same consistent set of intake steps (measuring vitals, recording history in a standard format) before their case reaches the actual diagnostic stage.',
        example:
            'A pipeline for training a classical Naive Bayes spam classifier: lowercase text, remove punctuation and numbers, tokenize into words, remove stopwords, lemmatize — while a pipeline feeding text into a pretrained BERT model might skip most of these steps, applying only the model\'s own specific subword tokenizer.',
        keyTakeaway:
            'Always match your preprocessing pipeline to your downstream model — over-cleaning text before a modern transformer (removing punctuation or case information it was actually trained to use) can hurt performance, while under-cleaning text before a classical bag-of-words model can leave in unhelpful noise.',
        codeSnippet:
            'import re\n\ndef preprocess_classical(text):\n    text = text.lower()\n    text = re.sub(r"[^a-z\\s]", "", text)   # remove punctuation/numbers\n    tokens = text.split()\n    return tokens\n\nsample = "Win FREE money now!!! Call 1-800-555-0000"\nprint(preprocess_classical(sample))',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why do modern transformer-based models typically use subword tokenization rather than simple word-level tokenization?',
        options: [
          'Subword tokenization is only used for languages other than English',
          'Subword tokenization elegantly handles rare or unseen words by breaking them into smaller, more common word-piece fragments, avoiding the "out of vocabulary" problem that pure word-level tokenization faces',
          'Subword tokenization always produces exactly one token per sentence',
          'Word-level tokenization is always superior and subword tokenization has no advantages'
        ],
        correctIndex: 1,
        explanation:
            'Subword tokenization solves the out-of-vocabulary problem by ensuring almost any word — even one never seen during training — can be represented as a combination of smaller, familiar subword pieces, which pure word-level tokenization cannot handle as gracefully.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is heavy classical preprocessing (stopword removal, aggressive lowercasing, punctuation stripping) often unnecessary or even harmful before feeding text into a modern pretrained transformer model like BERT?',
        options: [
          'Classical preprocessing is always required for every NLP model without exception',
          'Modern transformers were trained on text that includes natural punctuation, casing, and stopwords, and their subword tokenizers already handle raw text effectively — stripping this information can actually remove signal the model was trained to use',
          'Transformers cannot process any text that has been preprocessed at all',
          'Classical preprocessing techniques do not exist for the English language'
        ],
        correctIndex: 1,
        explanation:
            'Pretrained transformers learned from large amounts of naturally-formatted text (including casing, punctuation, and stopwords) — removing this information before feeding text to the model can strip away signal the model actually relies on, unlike classical bag-of-words approaches.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are building a classical Naive Bayes spam classifier (Level 5 style) using word counts as features. Which preprocessing steps are most appropriate to include?',
        options: [
          'No preprocessing at all — feed completely raw text directly into the model',
          'Lowercasing, removing punctuation, tokenizing into words, removing stopwords, and applying lemmatization — reducing noise and vocabulary size for a classical word-count-based model',
          'Only apply subword tokenization designed specifically for transformer models',
          'Convert all text into images before processing'
        ],
        correctIndex: 1,
        explanation:
            'Classical word-count-based models (like Naive Bayes with a bag-of-words representation) benefit from this full classical cleaning pipeline, which reduces noise and vocabulary size — unlike modern transformers, which handle raw text more directly via their own tokenizers.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Text Preprocessing Pipeline Comparison',
      goal:
          'Build and compare classical and modern tokenization approaches on a simulated text dataset, understanding when each is appropriate.',
      steps: [
        'Create a simulated dataset of 20 short text samples containing a mix of common words, rare/unusual words, and some intentional typos.',
        'Write a classical preprocessing pipeline (lowercase, remove punctuation, tokenize, remove stopwords, lemmatize) and apply it to all samples.',
        'Use a pretrained subword tokenizer (e.g., from Hugging Face\'s transformers library) to tokenize the same raw samples, and compare token counts and handling of rare words.',
        'Identify at least 2 words in your dataset that the subword tokenizer splits into multiple pieces, and explain why.',
        'Write a short summary of when you would choose each preprocessing approach for a real project.',
      ],
      expectedOutput:
          'Both preprocessing pipelines correctly implemented and applied. Clear comparison showing how each handles rare words differently. Summary correctly reasons about appropriate use cases for each approach.',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'word_embeddings_ds8',
    topicTitle: 'Word Embeddings (Word2Vec, GloVe)',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 30,
    totalXp: 155,
    emoji: '🔤',
    intro:
        'How does a model understand that "king" and "queen" are related, or that "Paris" is to "France" as "Tokyo" is to "Japan"? Word embeddings capture the meaning of words as dense numeric vectors — a foundational representation technique that predates and underlies even modern transformer models.',
    concepts: [
      ConceptLesson(
        title: 'From One-Hot Encoding to Dense Embeddings',
        definition:
            'One-hot encoding (Level 4) represents each word as a huge, mostly-zero vector with no notion of similarity between words. Word embeddings instead represent each word as a dense, lower-dimensional vector — learned so that words with similar meanings end up close together in this vector space.',
        analogy:
            'One-hot encoding words is like giving every person in a city a completely unrelated random ID number — knowing two people\'s ID numbers tells you nothing about whether they are similar. Word embeddings are like plotting every person on a map based on their actual interests and personality — people with similar interests naturally end up positioned near each other, and the DISTANCE itself becomes meaningful.',
        example:
            'One-hot encoded "cat" and "dog" are mathematically just as different from each other as "cat" and "spreadsheet" — there is no built-in notion of relatedness. Word embeddings correctly place "cat" and "dog" much closer together in vector space than either is to "spreadsheet," because they learned this similarity from how the words are actually used in real text.',
        keyTakeaway:
            'Embeddings are typically 50-300 dimensions (compared to one-hot\'s tens of thousands of dimensions for a large vocabulary) — this dense, compact representation is both more computationally efficient and captures genuine semantic meaning, unlike sparse one-hot vectors.',
      ),
      ConceptLesson(
        title: 'Word2Vec: Learning Meaning from Context',
        definition:
            'Word2Vec learns word embeddings by training a simple neural network to predict a word from its surrounding context (or vice versa) — the core insight, called the "distributional hypothesis," is that words appearing in similar contexts tend to have similar meanings.',
        analogy:
            'Word2Vec learns word meaning the way you might infer an unfamiliar word\'s meaning from repeatedly seeing it used in similar sentences — if a mystery word consistently appears in contexts like "I drank my ___ this morning" alongside "coffee" and "tea," you would reasonably infer it refers to some kind of beverage, purely from its surrounding context.',
        example:
            'Word2Vec famously captures analogical relationships through simple vector arithmetic: the vector for "king" minus "man" plus "woman" lands very close to the vector for "queen" — demonstrating that the learned embedding space captures genuine, meaningful semantic relationships, not just arbitrary numbers.',
        keyTakeaway:
            'Word2Vec embeddings are "static" — each word gets exactly ONE fixed vector regardless of context, which is a real limitation (the word "bank" gets the same vector whether it means a riverbank or a financial institution) — this limitation is precisely what contextual embeddings from transformers (next lesson) solve.',
        codeSnippet:
            'from gensim.models import Word2Vec\n\nsentences = [["the","cat","sat","on","the","mat"],\n             ["the","dog","sat","on","the","rug"],\n             ["a","king","rules","a","kingdom"]]\n\nmodel = Word2Vec(sentences, vector_size=50, window=3, min_count=1)\nprint(model.wv["cat"].shape)   # (50,) dense vector\nprint(model.wv.most_similar("cat", topn=2))',
      ),
      ConceptLesson(
        title: 'Using Pretrained Embeddings',
        definition:
            'Rather than training embeddings from scratch (which requires enormous amounts of text), most projects use pretrained embeddings like GloVe or Word2Vec trained on massive general text corpora — similar in spirit to the transfer learning approach from Level 7, reusing general semantic knowledge for your specific task.',
        analogy:
            'Using pretrained embeddings is like borrowing a comprehensive, professionally-compiled thesaurus and relationship map of the English language rather than building your own understanding of every word\'s meaning from scratch — you get immediate access to rich, well-established semantic knowledge without needing your own massive text corpus.',
        example:
            'A sentiment classifier trained on only 500 labeled movie reviews can still leverage GloVe embeddings pretrained on billions of words from Wikipedia and news articles — giving the small model access to rich semantic knowledge about word relationships that 500 reviews alone could never teach it.',
        keyTakeaway:
            'Pretrained embeddings are especially valuable for small labeled datasets — much like Level 7\'s transfer learning insight, borrowing general knowledge learned from massive external data compensates for having limited task-specific labeled examples.',
        codeSnippet:
            'import numpy as np\n\n# Conceptual: loading pretrained GloVe embeddings\nembeddings_index = {}\n# with open("glove.6B.100d.txt") as f:\n#     for line in f:\n#         values = line.split()\n#         word = values[0]\n#         vector = np.array(values[1:], dtype="float32")\n#         embeddings_index[word] = vector\n\nprint("Pretrained embeddings loaded: word -> 100-dim vector mapping")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What key limitation of one-hot encoding do word embeddings specifically solve?',
        options: [
          'One-hot encoding uses too little memory compared to embeddings',
          'One-hot encoded words have no inherent notion of similarity to each other — any two different words are equally "different" mathematically — while embeddings position semantically similar words close together in vector space',
          'One-hot encoding can only represent numbers, not words',
          'Embeddings and one-hot encoding are mathematically identical representations'
        ],
        correctIndex: 1,
        explanation:
            'The core advantage of embeddings is capturing genuine semantic similarity as spatial closeness in a dense vector space — one-hot encoding treats every pair of distinct words as equally unrelated, discarding all notion of meaning-based similarity.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is a key limitation of Word2Vec embeddings, and how do modern contextual embeddings (from transformers) address it?',
        options: [
          'Word2Vec embeddings require no training data at all, unlike transformers',
          'Word2Vec assigns each word a single, fixed vector regardless of context — meaning a word like "bank" gets the same representation whether referring to a river or finance; transformer-based contextual embeddings instead generate a different representation depending on the surrounding sentence',
          'Word2Vec embeddings can only represent exactly 10 words total',
          'This is not actually a real limitation of Word2Vec'
        ],
        correctIndex: 1,
        explanation:
            'Word2Vec\'s static, one-vector-per-word limitation means it cannot distinguish between different meanings of the same word based on context — this is exactly the gap that transformer-based contextual embeddings fill by generating context-dependent representations.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You have only 400 labeled customer reviews to train a sentiment classifier, but want the model to have rich general knowledge of word relationships despite this small dataset. What is an effective approach based on this lesson?',
        options: [
          'Train Word2Vec embeddings entirely from scratch using only the 400 reviews',
          'Use pretrained embeddings (like GloVe) trained on a massive external text corpus, giving the small model access to rich general semantic knowledge it could not learn from 400 reviews alone',
          'Word embeddings are irrelevant to sentiment classification tasks',
          'Convert all reviews to one-hot encoded vectors instead of using any embedding approach'
        ],
        correctIndex: 1,
        explanation:
            'This mirrors the transfer learning principle from Level 7 — leveraging pretrained embeddings trained on massive external text gives a small dataset access to rich semantic knowledge that would be impossible to learn from such limited labeled data alone.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Word Embedding Similarity Explorer',
      goal:
          'Train Word2Vec embeddings on a simulated text corpus and explore the semantic relationships captured in the resulting vector space.',
      steps: [
        'Create a simulated text corpus of at least 50 short sentences covering a few related themes (e.g., animals, food, technology) with deliberately overlapping context words.',
        'Preprocess the corpus (tokenize into lists of words per sentence) and train a Word2Vec model on it.',
        'For 5 chosen words, print their most similar words according to the trained embeddings, checking whether the results make intuitive sense given your corpus themes.',
        'Compute and print the cosine similarity between 3 pairs of words you expect to be related, and 3 pairs you expect to be unrelated, comparing the resulting scores.',
        'Write a short reflection on whether the learned embeddings captured meaningful relationships, and how corpus size might affect embedding quality.',
      ],
      expectedOutput:
          'Word2Vec model correctly trained on the simulated corpus. Similarity queries produce intuitively reasonable results given the corpus themes. Cosine similarity comparison correctly distinguishes related vs unrelated word pairs. Thoughtful reflection provided.',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'sentiment_analysis_ds8',
    topicTitle: 'Sentiment Analysis',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 30,
    totalXp: 155,
    emoji: '😊',
    intro:
        'Sentiment analysis — automatically determining whether text expresses positive, negative, or neutral opinion — is one of the most common, business-valuable NLP applications, powering everything from product review analysis to social media brand monitoring. This lesson brings together tokenization, embeddings, and classification into a complete pipeline.',
    concepts: [
      ConceptLesson(
        title: 'Sentiment Analysis as a Classification Problem',
        definition:
            'At its core, sentiment analysis is simply text classification (like the Naive Bayes spam detection from Level 5) applied to opinion — mapping text input to sentiment labels (positive/negative, or a finer-grained scale) using any of the classification techniques learned throughout Levels 5-8.',
        analogy:
            'Sentiment analysis is like training a reader to quickly categorize letters into a mail sorting system — "complaint," "compliment," or "neutral inquiry" — based purely on reading the tone and word choice of each letter, without needing to know anything else about the sender.',
        example:
            'A restaurant chain analyzing 50,000 online reviews doesn\'t need a human to read each one — a sentiment classifier can automatically flag which reviews are strongly negative (requiring urgent follow-up) versus overwhelmingly positive (potential testimonials), dramatically scaling up what a small team could review manually.',
        keyTakeaway:
            'The SAME classification techniques from Level 5 (logistic regression, Naive Bayes) and Level 8 (deep learning with embeddings) all apply to sentiment analysis — what differs is the TEXT REPRESENTATION used as input features, which is the focus of this lesson.',
      ),
      ConceptLesson(
        title: 'From Bag-of-Words to Embedding-Based Sentiment Models',
        definition:
            'Simple sentiment models use bag-of-words or TF-IDF representations (Level 5) fed into classical classifiers. More sophisticated models use word embeddings (previous lesson) or full contextual transformer representations (next lesson) fed into deep learning classifiers, capturing more nuanced meaning and word order.',
        analogy:
            'A bag-of-words sentiment model is like judging a restaurant review purely by counting positive versus negative-sounding words present, ignoring their order. An embedding-based model is like actually reading and understanding the review\'s full meaning and context, correctly interpreting a phrase like "not bad at all" as genuinely positive despite containing the word "not," which pure word-counting would likely miss.',
        example:
            'The sentence "The food was not amazing" contains the individually positive word "amazing" — a naive bag-of-words model might misclassify this as positive, while a model that understands word ORDER and context (embeddings + sequence modeling) correctly captures the negation and classifies it as negative.',
        keyTakeaway:
            'Negation handling ("not good," "never disappoints") is one of the clearest illustrations of why more sophisticated, context-aware representations often outperform simple bag-of-words approaches for sentiment analysis — word order and local context genuinely matter for correct interpretation.',
        codeSnippet:
            'from sklearn.feature_extraction.text import TfidfVectorizer\nfrom sklearn.linear_model import LogisticRegression\nfrom sklearn.pipeline import Pipeline\n\ntexts = ["great product love it", "not bad at all", "terrible waste of money", "not amazing honestly"]\nlabels = [1, 1, 0, 0]\n\npipeline = Pipeline([("tfidf", TfidfVectorizer(ngram_range=(1,2))), ("lr", LogisticRegression())])\npipeline.fit(texts, labels)\nprint(pipeline.predict(["not terrible"]))   # bigrams help capture negation somewhat',
      ),
      ConceptLesson(
        title: 'Fine-Grained Sentiment and Aspect-Based Analysis',
        definition:
            'Beyond simple positive/negative classification, fine-grained sentiment analysis predicts a scale (1-5 stars) or intensity, while aspect-based sentiment analysis identifies sentiment toward SPECIFIC aspects mentioned within the same text (e.g., "great food but slow service" expresses positive sentiment about food and negative sentiment about service simultaneously).',
        analogy:
            'Simple sentiment analysis is like giving a restaurant a single overall thumbs up or down. Aspect-based sentiment analysis is like a detailed inspection report that separately rates the food, service, ambiance, and value — recognizing that a single review can genuinely express different opinions about different specific aspects of the same experience.',
        example:
            'The review "The food was outstanding but the wait staff was incredibly rude" would be difficult to classify as simply "positive" or "negative" overall — aspect-based analysis correctly identifies positive sentiment toward "food" and negative sentiment toward "service" as two separate, valid conclusions from the same text.',
        keyTakeaway:
            'Choosing between simple binary sentiment, fine-grained scales, or aspect-based analysis depends entirely on the business question — a quick brand health check might only need simple positive/negative, while a detailed product improvement analysis benefits enormously from aspect-level granularity.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why might a simple bag-of-words sentiment model incorrectly classify the sentence "The service was not amazing" as positive?',
        options: [
          'Bag-of-words models are always more accurate than any other approach',
          'Bag-of-words representations ignore word order, so the model may key strongly on the individually positive word "amazing" without correctly capturing that "not" negates it in this specific context',
          'The word "amazing" is always removed during preprocessing regardless of the model used',
          'This sentence cannot be processed by any sentiment analysis approach'
        ],
        correctIndex: 1,
        explanation:
            'Because bag-of-words representations discard word order and only track word presence/frequency, negation words like "not" can fail to properly flip the sentiment of nearby positive/negative words — a well-known limitation that more context-aware representations help address.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A company wants to understand specifically which aspects of their product (packaging, price, quality, customer service) customers are unhappy about from mixed reviews. Which technique is most appropriate?',
        options: [
          'Simple binary positive/negative sentiment classification applied to the whole review',
          'Aspect-based sentiment analysis, which identifies sentiment toward specific mentioned aspects within the same text, rather than assigning just one overall sentiment label per review',
          'Word embeddings alone, without any classification step',
          'This level of granular analysis is not possible with NLP techniques'
        ],
        correctIndex: 1,
        explanation:
            'Aspect-based sentiment analysis is specifically designed for exactly this business need — extracting sentiment toward individual mentioned aspects within a single piece of text, rather than collapsing everything into one overall sentiment label.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are building a sentiment classifier and notice it performs poorly on sentences containing negation ("not good," "never disappoints"). Which representation change from this lesson would likely help most?',
        options: [
          'Removing all negation words during preprocessing to simplify the text',
          'Using a representation that captures word order and local context (like bigrams/trigrams in TF-IDF, or embedding-based sequence models) rather than a pure single-word bag-of-words approach',
          'Switching to one-hot encoding for each word',
          'Negation handling cannot be improved through representation choice'
        ],
        correctIndex: 1,
        explanation:
            'Representations that capture some notion of word order or local context (like n-grams, or embedding/sequence-based models) can much better handle negation patterns than a pure single-word bag-of-words approach, which loses all ordering information.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Complete Sentiment Analysis System with Negation Handling',
      goal:
          'Build and compare sentiment classifiers with different text representations, specifically evaluating negation-handling capability.',
      steps: [
        'Create a simulated dataset of 40 short reviews, including at least 10 examples with negation patterns ("not bad," "never disappoints," "not amazing") with correct labels.',
        'Build a Pipeline with simple unigram TF-IDF (single words only) + LogisticRegression, train on the dataset, and specifically test its accuracy on the negation examples.',
        'Build a second Pipeline with TF-IDF using ngram_range=(1,2) (including bigrams) + LogisticRegression, and compare negation-handling performance.',
        'Print a side-by-side comparison of both models\' predictions specifically on the negation test examples.',
        'Write a conclusion explaining why bigrams likely improved (or did not improve) negation handling, connecting back to the lesson concepts.',
      ],
      expectedOutput:
          'Both models correctly built and trained. Negation-specific comparison clearly shows any performance difference between unigram and bigram representations. Conclusion correctly reasons about the observed results.',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'named_entity_recognition_ds8',
    topicTitle: 'Named Entity Recognition',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 25,
    totalXp: 145,
    emoji: '🏷️',
    intro:
        'Named Entity Recognition (NER) automatically identifies and categorizes real-world entities within text — people, organizations, locations, dates, monetary amounts — turning unstructured text into structured, extractable information that can populate databases and drive automated workflows.',
    concepts: [
      ConceptLesson(
        title: 'What NER Extracts and Why It Matters',
        definition:
            'NER scans text and labels spans of words with entity types like PERSON, ORGANIZATION, LOCATION, DATE, and MONEY — converting free-form text into structured data that can be directly queried, aggregated, or fed into downstream systems, unlike raw unstructured text.',
        analogy:
            'NER is like a highlighter that automatically marks up a document — highlighting every person\'s name in yellow, every company name in blue, every date in green — turning a wall of plain text into a clearly organized, categorized document where key information jumps out immediately and can be systematically extracted.',
        example:
            'Given the sentence "Reliance Industries acquired a stake in JioMart for ₹4,500 crore in March 2024," NER extracts: ORGANIZATION="Reliance Industries", ORGANIZATION="JioMart", MONEY="₹4,500 crore", DATE="March 2024" — structured facts automatically pulled from a single unstructured sentence.',
        keyTakeaway:
            'NER is a foundational building block for many downstream applications: automatically populating a database of company mentions from news articles, extracting key dates and amounts from legal contracts, or building a knowledge graph connecting entities mentioned across thousands of documents.',
      ),
      ConceptLesson(
        title: 'NER as Sequence Labeling',
        definition:
            'Unlike sentiment analysis (which classifies an entire text), NER is a sequence labeling task — assigning a label to EVERY individual token in the text (whether it is part of an entity, and which type), making it naturally well-suited to the sequence architectures (RNN/LSTM, transformers) from Level 7.',
        analogy:
            'NER is like reading through a document and tagging each individual word with a small colored sticky note indicating its role — most words get a plain "not an entity" note, but certain sequences of words get consistent colored notes marking them as part of a person\'s name, a location, or an organization spanning multiple consecutive words.',
        example:
            'For "New York City is beautiful in spring," a NER system labels "New" as B-LOCATION (beginning of a location entity), "York" and "City" as I-LOCATION (inside/continuing the same location entity), and all other words as O (not part of any entity) — this token-by-token labeling scheme (called BIO tagging) is standard in NER systems.',
        keyTakeaway:
            'This per-token labeling structure is exactly why sequence-aware architectures (LSTMs, transformers) from Level 7 handle NER naturally — the model needs to consider each word\'s context within the sequence to correctly determine whether it continues, begins, or falls outside an entity span.',
        codeSnippet:
            'import spacy\n\nnlp = spacy.load("en_core_web_sm")\ntext = "Reliance Industries acquired a stake in JioMart for 4500 crore in March 2024"\ndoc = nlp(text)\n\nfor ent in doc.ents:\n    print(f"{ent.text:25} -> {ent.label_}")',
      ),
      ConceptLesson(
        title: 'Using Pretrained NER Models vs Custom Training',
        definition:
            'Pretrained NER models (from spaCy, Hugging Face) handle common entity types (PERSON, ORG, LOCATION, DATE) well out-of-the-box, but many real business applications need CUSTOM entity types (e.g., "PRODUCT_MODEL," "MEDICAL_CONDITION") that require fine-tuning a model on domain-specific labeled examples.',
        analogy:
            'Using a pretrained NER model is like hiring a generalist office assistant who already knows how to recognize common things like names, dates, and companies immediately. Training a custom NER model is like additionally training that same assistant on your company\'s specific internal jargon and product codes — general skills plus specialized domain knowledge combined.',
        example:
            'A general pretrained NER model correctly identifies "Dr. Sarah Chen" as a PERSON and "March 15" as a DATE in a medical report, but would completely miss identifying "Stage 3 melanoma" as a MEDICAL_CONDITION entity — this custom entity type requires additional training on domain-specific labeled medical text.',
        keyTakeaway:
            'Start with a pretrained NER model for common entity types, and only invest in custom NER training (requiring labeled examples of your specific domain entities) when your application genuinely needs entity types that general-purpose models do not already cover.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What fundamentally distinguishes Named Entity Recognition from a text classification task like sentiment analysis?',
        options: [
          'NER and sentiment analysis are mathematically identical tasks with no real difference',
          'NER assigns a label to EVERY individual token in the text (identifying entity spans and types), while sentiment analysis assigns a single label to the entire piece of text as a whole',
          'NER can only process numbers, never words',
          'Sentiment analysis requires more labeled training data than NER in every case'
        ],
        correctIndex: 1,
        explanation:
            'This is the key structural distinction — NER is a sequence labeling task operating at the individual token level, while sentiment analysis (a standard classification task) produces one label for the entire input text as a whole.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A company wants to extract mentions of "Stage 3 melanoma" and similar specific medical condition phrases from clinical notes, but a general pretrained NER model does not recognize this as an entity type at all. What is the appropriate next step?',
        options: [
          'Give up, since pretrained models can never be extended for new entity types',
          'Train or fine-tune a custom NER model on labeled examples containing this specific domain entity type (like MEDICAL_CONDITION), since general pretrained models only cover common entity types out-of-the-box',
          'Use a sentiment analysis model instead, since it accomplishes the same task',
          'This task is impossible to accomplish with any NLP technique'
        ],
        correctIndex: 1,
        explanation:
            'When your application requires entity types beyond what general pretrained models cover, custom training/fine-tuning on domain-specific labeled examples is the standard, appropriate approach to extend NER capability to your specific needs.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You need to automatically extract company names, deal amounts, and dates from thousands of news articles to populate a structured database. Which NLP technique is most directly suited to this task?',
        options: [
          'Sentiment analysis, since it processes text and produces useful output',
          'Named Entity Recognition, since it is specifically designed to identify and extract structured entities like organizations, monetary amounts, and dates from unstructured text',
          'Word embeddings alone, without any downstream extraction step',
          'This task cannot be automated using any NLP approach'
        ],
        correctIndex: 1,
        explanation:
            'NER is precisely the technique designed for this exact use case — automatically identifying and categorizing structured entities like organization names, monetary amounts, and dates from unstructured news text.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Business Entity Extraction Pipeline',
      goal:
          'Build a complete NER-based extraction pipeline that processes simulated news text and produces structured, queryable output.',
      steps: [
        'Create 10 simulated short news-style sentences mentioning company names, monetary amounts, dates, and locations.',
        'Apply a pretrained NER model (e.g., spaCy) to extract all entities from each sentence, printing the entity text and type for each.',
        'Organize the extracted entities into a structured Pandas DataFrame with columns: sentence_id, entity_text, entity_type.',
        'Write a groupby analysis (Level 4 skill) showing the count of each entity type found across all sentences.',
        'Identify at least one entity the pretrained model likely misses or mislabels, and explain what a custom-trained NER model might additionally need to capture correctly.',
      ],
      expectedOutput:
          'Entities correctly extracted from all 10 sentences into a structured DataFrame. GroupBy analysis correctly summarizes entity type counts. Written analysis correctly identifies a limitation and reasons about custom NER training needs.',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'transformers_deep_dive_ds8',
    topicTitle: 'Transformers Deep Dive (BERT, GPT)',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 35,
    totalXp: 170,
    emoji: '🤖',
    intro:
        'Level 7 introduced the transformer\'s core attention mechanism conceptually. Now you go deeper into the two dominant transformer families — BERT (understanding-focused) and GPT (generation-focused) — and learn how to practically use them for real NLP tasks via Hugging Face.',
    concepts: [
      ConceptLesson(
        title: 'BERT: Bidirectional Understanding',
        definition:
            'BERT (Bidirectional Encoder Representations from Transformers) reads text in both directions simultaneously — considering the full context both before AND after each word — making it exceptionally strong at understanding tasks like classification, NER, and question answering, though it does not naturally generate new text.',
        analogy:
            'BERT reading a sentence is like a careful editor reviewing a full paragraph at once, considering how each word relates to everything both before AND after it in the sentence, before forming a complete judgment about the paragraph\'s overall meaning — rather than reading strictly left-to-right and forming conclusions only from what came before.',
        example:
            'To understand the word "bank" in "I sat by the river bank to read," BERT considers BOTH the preceding words ("I sat by the river") AND the following words ("to read") simultaneously — this bidirectional context makes it very effective at disambiguating meaning for understanding tasks like classification and NER.',
        keyTakeaway:
            'BERT excels at tasks that require deeply UNDERSTANDING existing text (classification, NER, extractive question answering) precisely because of its bidirectional context — but its architecture is not naturally suited to generating new, coherent text word by word, which is GPT\'s specialty.',
        codeSnippet:
            'from transformers import pipeline\n\nclassifier = pipeline("sentiment-analysis", model="distilbert-base-uncased-finetuned-sst-2-english")\nresult = classifier("This product exceeded all my expectations!")\nprint(result)   # [{\'label\': \'POSITIVE\', \'score\': 0.999...}]',
      ),
      ConceptLesson(
        title: 'GPT: Autoregressive Text Generation',
        definition:
            'GPT (Generative Pre-trained Transformer) processes text left-to-right, at each step predicting the next word based only on the words that came before it — this "autoregressive" generation process, applied repeatedly, is what allows GPT models to generate fluent, coherent, extended text one word at a time.',
        analogy:
            'GPT generating text is like an improvisational storyteller who continues a story one word at a time, always basing their next word choice purely on everything said so far in the story — never looking ahead, but building a coherent narrative through this continuous, forward-only prediction process, one word leading naturally into the next.',
        example:
            'Given the prompt "The best way to learn data science is," GPT predicts the most likely next word ("to"), then adds that to the context and predicts the next word again ("practice"), continuing this process repeatedly to generate an entire coherent continuation — this is fundamentally how ChatGPT and similar tools generate their responses.',
        keyTakeaway:
            'GPT\'s forward-only (unidirectional) architecture is precisely what makes it naturally suited for text GENERATION tasks — while BERT\'s bidirectional architecture makes it naturally suited for text UNDERSTANDING tasks — this architectural difference explains why different models excel at different NLP applications.',
        codeSnippet:
            'from transformers import pipeline\n\ngenerator = pipeline("text-generation", model="gpt2")\nresult = generator("The best way to learn data science is", max_length=30, num_return_sequences=1)\nprint(result[0]["generated_text"])',
      ),
      ConceptLesson(
        title: 'Choosing the Right Transformer for the Task',
        definition:
            'The choice between BERT-style (encoder, understanding-focused) and GPT-style (decoder, generation-focused) models — or hybrid encoder-decoder models like T5 for tasks like translation and summarization — depends entirely on whether your task requires understanding existing text, generating new text, or transforming text from one form to another.',
        analogy:
            'Choosing a transformer family is like choosing the right professional for a specific job — an experienced editor (BERT) is ideal for carefully analyzing and categorizing existing documents, while a skilled writer (GPT) is ideal for drafting brand-new content, and a professional translator (encoder-decoder models) is specifically suited for converting content from one form into another.',
        example:
            'Sentiment classification and NER (understanding existing text) → BERT-style models. Chatbots and creative text generation (producing new text) → GPT-style models. Machine translation and summarization (transforming text from one form to another) → encoder-decoder models like T5 or BART.',
        keyTakeaway:
            'This task-to-architecture matching mirrors the data-type-to-architecture principle from Level 7\'s capstone — always start by clearly identifying whether your task is fundamentally about understanding, generating, or transforming text, before choosing which transformer family to use.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why is BERT particularly well-suited for tasks like sentiment classification and NER, while GPT is particularly well-suited for text generation?',
        options: [
          'BERT and GPT are functionally identical with no meaningful architectural difference',
          'BERT reads text bidirectionally, considering full context in both directions, making it strong at understanding existing text; GPT processes text left-to-right autoregressively, making it naturally suited to generating new text one word at a time',
          'GPT can only process single words, never full sentences',
          'BERT can only be used for image classification, not text tasks'
        ],
        correctIndex: 1,
        explanation:
            'This bidirectional-vs-autoregressive architectural distinction directly explains why BERT excels at understanding-focused tasks (leveraging full context) while GPT excels at generation-focused tasks (predicting the next word based on everything so far).',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A company needs to build a system that translates customer support tickets from English to Spanish. Which type of transformer architecture is most naturally suited to this text-transformation task?',
        options: [
          'A pure BERT-style encoder model, since it is always the correct choice regardless of task type',
          'An encoder-decoder model (like T5 or BART), which is specifically designed for tasks that transform text from one form into another, such as translation or summarization',
          'Architecture choice is irrelevant for translation tasks',
          'A pure GPT-style decoder model is the only architecture capable of any text processing'
        ],
        correctIndex: 1,
        explanation:
            'Translation is fundamentally a text-transformation task (converting text from one form/language into another), which is exactly what encoder-decoder architectures like T5 or BART are specifically designed to handle well.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You need to build a system that extracts the answer to a specific question directly from a given paragraph of text (extractive question answering). Which transformer family is most naturally suited to this task?',
        options: [
          'GPT-style models, since generation is always the correct approach regardless of task',
          'BERT-style models, since extractive question answering fundamentally requires deeply understanding the relationship between a question and a given passage of existing text, which is BERT\'s architectural strength',
          'Neither BERT nor GPT can be used for question answering tasks',
          'Architecture choice has no relevance to this task'
        ],
        correctIndex: 1,
        explanation:
            'Extractive question answering (finding an answer span WITHIN existing text) is fundamentally an understanding task requiring deep bidirectional context comprehension — exactly BERT\'s architectural strength, unlike GPT\'s generation-focused design.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Multi-Task Transformer Application Comparison',
      goal:
          'Use pretrained BERT-style and GPT-style models via Hugging Face pipelines to solve different NLP tasks, comparing their suitability.',
      steps: [
        'Use a Hugging Face sentiment-analysis pipeline (BERT-style) to classify 5 simulated customer review sentences, printing the label and confidence score for each.',
        'Use a Hugging Face text-generation pipeline (GPT-style) to generate a continuation for 3 different starting prompts related to a business scenario, printing the generated text.',
        'Use a Hugging Face question-answering pipeline (BERT-style) to extract an answer to a specific question from a short given paragraph of context text.',
        'Write a summary table matching each of these 3 tasks to the transformer architecture family used, explaining why that architecture was appropriate for each specific task.',
        'Identify one additional NLP task not covered above, and reason through which transformer family would be most appropriate for it.',
      ],
      expectedOutput:
          'All 3 pipeline tasks correctly executed using appropriate Hugging Face pipelines. Summary table correctly matches tasks to architecture families with sound reasoning. Additional task reasoning is well-justified.',
      xpReward: 65,
    ),
  ),
  TopicCourse(
    id: 'huggingface_ecosystem_ds8',
    topicTitle: 'Hugging Face Ecosystem',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 30,
    totalXp: 155,
    emoji: '🤗',
    intro:
        'Hugging Face has become the de facto standard toolkit for modern NLP — a combination of pretrained models, datasets, and a consistent, easy-to-use API that has democratized access to state-of-the-art transformer models. This lesson makes you fluent in navigating and using this essential ecosystem.',
    concepts: [
      ConceptLesson(
        title: 'The Hugging Face Hub: Models and Datasets',
        definition:
            'The Hugging Face Hub is a central repository hosting tens of thousands of pretrained models (for classification, generation, translation, and more) and datasets, contributed by both the company and the broader research community — making state-of-the-art NLP models accessible with just a few lines of code.',
        analogy:
            'The Hugging Face Hub is like a massive, well-organized public library specifically for AI models — instead of building a model from scratch (writing your own book), you can browse and borrow from thousands of already-written, professionally-vetted "books" (pretrained models) covering nearly any NLP task you could need.',
        example:
            'Searching the Hub for "sentiment analysis" reveals dozens of pretrained models fine-tuned specifically for that task, each with documentation, performance benchmarks, and example usage — allowing you to pick one appropriate for your specific language, domain, or accuracy/speed tradeoff needs.',
        keyTakeaway:
            'Before training any NLP model from scratch, always check the Hugging Face Hub first — there is a strong chance someone has already trained and shared a model well-suited to your task, saving enormous time and computational resources compared to starting fresh.',
      ),
      ConceptLesson(
        title: 'The pipeline() API: Instant Task-Specific Models',
        definition:
            'Hugging Face\'s pipeline() function provides an extremely simple, high-level interface for common NLP tasks — sentiment analysis, text generation, translation, summarization, question answering — automatically handling tokenization, model loading, and output formatting behind a single, consistent function call.',
        analogy:
            'The pipeline() API is like a universal vending machine for NLP tasks — you simply select the task you want ("sentiment-analysis," "translation," "summarization") and insert your text, and it automatically handles all the internal complexity (loading the right model, tokenizing correctly, formatting output) to hand you a ready result.',
        example:
            'summarizer = pipeline("summarization") followed by summarizer(long_article_text, max_length=100) instantly produces a concise summary — without needing to manually handle model loading, tokenization, or any of the underlying transformer mechanics covered in earlier lessons.',
        keyTakeaway:
            'pipeline() is an excellent starting point for quickly prototyping and testing NLP capabilities — for production use cases requiring more control (custom fine-tuning, specific preprocessing, performance optimization), you eventually work with the underlying tokenizer and model objects directly, but pipeline() remains ideal for rapid experimentation.',
        codeSnippet:
            'from transformers import pipeline\n\n# Same simple API pattern works across many different NLP tasks\nsummarizer = pipeline("summarization")\ntranslator = pipeline("translation_en_to_fr")\nqa = pipeline("question-answering")\n\nsummary = summarizer("Long article text here...", max_length=50, min_length=10)\nprint(summary[0]["summary_text"])',
      ),
      ConceptLesson(
        title: 'Fine-Tuning with the Transformers and Datasets Libraries',
        definition:
            'Beyond using models out-of-the-box, Hugging Face\'s Transformers library (for models) combined with the Datasets library (for efficiently loading and processing data) provides the full toolkit for fine-tuning a pretrained model on your own custom, labeled dataset — extending Level 7\'s transfer learning concept directly to NLP.',
        analogy:
            'Fine-tuning with Hugging Face is like taking a highly experienced, professionally trained consultant (a pretrained transformer) and giving them a focused, structured onboarding program specific to your company\'s exact needs — rather than either using their general expertise completely unchanged, or training a brand new consultant from absolute zero.',
        example:
            'A company wanting a sentiment classifier specifically tuned to their industry\'s jargon (e.g., financial services terminology) can start with a general pretrained BERT model and fine-tune it on a few thousand labeled examples of their own domain-specific text, using Hugging Face\'s Trainer API to handle the training loop.',
        keyTakeaway:
            'The Hugging Face fine-tuning workflow directly parallels the feature-extraction-vs-fine-tuning distinction from Level 7\'s transfer learning lesson — you can freeze most of the pretrained model and only train a new task-specific head, or allow deeper layers to adapt, depending on your dataset size and task similarity.',
        codeSnippet:
            '# Conceptual fine-tuning workflow with Hugging Face\nfrom transformers import AutoModelForSequenceClassification, Trainer, TrainingArguments\n\nmodel = AutoModelForSequenceClassification.from_pretrained("distilbert-base-uncased", num_labels=2)\n\ntraining_args = TrainingArguments(\n    output_dir="./results", num_train_epochs=3,\n    per_device_train_batch_size=16, evaluation_strategy="epoch"\n)\n# trainer = Trainer(model=model, args=training_args, train_dataset=..., eval_dataset=...)\n# trainer.train()\nprint("Fine-tuning setup ready - reuses pretrained BERT knowledge for a custom task")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why should you generally check the Hugging Face Hub before training an NLP model from scratch for a common task like sentiment analysis?',
        options: [
          'The Hub only contains outdated, low-quality models',
          'The Hub hosts tens of thousands of pretrained models contributed by the community and researchers, often already fine-tuned for common tasks — reusing one can save enormous time and computational resources compared to training from scratch',
          'Using pretrained models from the Hub is illegal for commercial projects',
          'The Hub can only be accessed by Hugging Face employees'
        ],
        correctIndex: 1,
        explanation:
            'The Hub\'s vast collection of freely available, often high-quality pretrained models means there is a strong chance a suitable model already exists for common NLP tasks — checking first can save substantial development time and computational cost.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the primary benefit of Hugging Face\'s pipeline() API for a data scientist prototyping NLP capabilities quickly?',
        options: [
          'pipeline() requires writing custom tokenization and model-loading code for every task',
          'pipeline() provides a simple, consistent, high-level interface across many different NLP tasks, automatically handling tokenization, model loading, and output formatting behind a single function call',
          'pipeline() only works for image classification tasks, not NLP',
          'pipeline() can only be used with models you have trained yourself'
        ],
        correctIndex: 1,
        explanation:
            'The pipeline() API\'s core value is abstracting away the underlying complexity (tokenization, model loading, formatting) behind a simple, consistent interface — making rapid prototyping and testing of various NLP capabilities dramatically faster.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A company has 3,000 labeled examples of their own industry-specific customer feedback and wants a sentiment classifier tuned specifically to their domain\'s language patterns, rather than using a general pretrained model as-is. What is the appropriate Hugging Face-based approach?',
        options: [
          'Only use pipeline() with a general pretrained model, with no further adaptation',
          'Fine-tune a pretrained model (like BERT) on their 3,000 labeled domain-specific examples using the Transformers library\'s Trainer API, adapting the general model to their specific domain',
          'Hugging Face tools cannot be used for domain-specific fine-tuning',
          'Train a completely new transformer architecture entirely from scratch'
        ],
        correctIndex: 1,
        explanation:
            'With a moderate amount of labeled domain-specific data (3,000 examples), fine-tuning a pretrained model using Hugging Face\'s Transformers library is the standard, appropriate approach — leveraging general pretrained knowledge while adapting to the specific domain.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Multi-Pipeline NLP Application',
      goal:
          'Build a small application demonstrating multiple Hugging Face pipeline() capabilities working together on a realistic business scenario.',
      steps: [
        'Simulate a scenario: a company receives customer support emails and wants to (1) summarize long emails, (2) classify their sentiment, and (3) answer a specific question about the email content.',
        'Create 3 simulated longer customer email texts (a few sentences each).',
        'Use a summarization pipeline to condense each email, printing the summaries.',
        'Use a sentiment-analysis pipeline to classify the sentiment of each original email.',
        'Use a question-answering pipeline to extract a specific piece of information (e.g., "What product is the customer asking about?") from each email, given the email as context.',
        'Print a combined report for each email showing: original text, summary, sentiment, and extracted answer.',
      ],
      expectedOutput:
          'All 3 pipelines correctly used on the simulated emails. Combined report clearly presents summary, sentiment, and extracted information for each email, demonstrating a realistic multi-task NLP application workflow.',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'llm_prompting_rag_ds8',
    topicTitle: 'LLM Prompting & RAG Basics',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 35,
    totalXp: 170,
    emoji: '💬',
    intro:
        'Large Language Models like GPT-4 and Claude can be used without any training at all — simply by crafting the right prompt. This lesson covers effective prompting techniques and Retrieval-Augmented Generation (RAG), the key technique for grounding LLM responses in your own specific, up-to-date data.',
    concepts: [
      ConceptLesson(
        title: 'Prompt Engineering: Guiding LLM Behavior Through Instructions',
        definition:
            'Prompt engineering is the practice of crafting input text (the prompt) to reliably elicit useful, accurate output from a large language model — including techniques like providing clear instructions, giving examples (few-shot prompting), and specifying the desired output format explicitly.',
        analogy:
            'Prompt engineering is like giving detailed, clear instructions to a brilliant but very literal new employee on their first day — the employee has enormous general capability, but the QUALITY and specificity of the instructions you provide directly determines whether they produce exactly what you actually need, or something subtly off-target.',
        example:
            'A vague prompt like "summarize this" might produce an inconsistent, variable-length result. A well-engineered prompt like "Summarize the following article in exactly 3 bullet points, each under 15 words, focusing only on financial impact" produces far more consistent, precisely targeted output.',
        keyTakeaway:
            'Few-shot prompting (providing 2-3 example input-output pairs directly in the prompt before your actual request) often dramatically improves output quality and consistency compared to zero-shot prompting (no examples) — especially for tasks with a specific desired format or style.',
        codeSnippet:
            '# Few-shot prompting example structure\nprompt = """Classify the sentiment of each review as Positive or Negative.\n\nReview: "Amazing quality, highly recommend!"\nSentiment: Positive\n\nReview: "Broke after one day, terrible."\nSentiment: Negative\n\nReview: "Decent for the price but nothing special."\nSentiment:"""\nprint("This few-shot structure guides the model toward consistent classification format")',
      ),
      ConceptLesson(
        title: 'Why LLMs Alone Are Not Enough: Knowledge Limitations',
        definition:
            'LLMs have a fixed "knowledge cutoff" (they know nothing about events after their training data ends), can "hallucinate" (confidently generate plausible-sounding but factually incorrect information), and have no built-in access to your organization\'s private, proprietary data — three significant limitations that motivate Retrieval-Augmented Generation.',
        analogy:
            'An LLM without RAG is like an extremely well-read expert who has not read any news since a fixed date months or years ago, occasionally makes confident-sounding but incorrect claims when uncertain, and has never seen your company\'s internal documents — brilliant general knowledge, but with real, specific gaps that matter for practical business use.',
        example:
            'Asking a base LLM "What is our company\'s current return policy?" would either produce a generic, made-up answer (hallucination) or an honest admission of not knowing — since the model was never trained on your company\'s specific internal policy documents, which is exactly the gap RAG is designed to fill.',
        keyTakeaway:
            'Recognizing these specific limitations — knowledge cutoff, hallucination risk, and no access to private data — is what motivates RAG as a practical solution, rather than simply hoping a more powerful base model will eventually solve all three problems on its own.',
      ),
      ConceptLesson(
        title: 'Retrieval-Augmented Generation: Grounding LLMs in Real Data',
        definition:
            'RAG combines a retrieval step (searching a knowledge base — often using vector embeddings from earlier lessons — for relevant documents given a user query) with a generation step (feeding those retrieved documents INTO the LLM\'s prompt as context) — allowing the model to answer based on real, specific, up-to-date information rather than relying solely on its training data.',
        analogy:
            'RAG is like giving an extremely knowledgeable expert consultant instant access to your company\'s specific filing cabinet right before they answer any question — rather than relying purely on their general background knowledge (which might be outdated or simply not cover your specific situation), they first quickly pull the most relevant actual documents, then base their answer directly on that real, current information.',
        example:
            'A customer support RAG system: a user asks "What is your return policy for electronics?" → the system searches a vector database of company policy documents for the most relevant sections → those specific policy excerpts are inserted into the LLM\'s prompt as context → the LLM generates an answer GROUNDED in the actual retrieved policy text, not its own possibly-outdated or hallucinated assumptions.',
        keyTakeaway:
            'The retrieval step in RAG typically uses embedding-based similarity search (connecting directly back to this level\'s word/document embedding concepts) — converting both the user\'s query and all knowledge base documents into vectors, then finding the documents whose vectors are closest to the query\'s vector.',
        codeSnippet:
            '# Conceptual RAG retrieval step using embeddings\nimport numpy as np\n\ndef find_relevant_docs(query_embedding, doc_embeddings, doc_texts, top_k=2):\n    similarities = [np.dot(query_embedding, doc_emb) for doc_emb in doc_embeddings]\n    top_indices = np.argsort(similarities)[-top_k:][::-1]\n    return [doc_texts[i] for i in top_indices]\n\n# Retrieved docs are then inserted into the LLM prompt as grounding context\nprint("Retrieved relevant context would be injected into the final LLM prompt")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why does few-shot prompting (providing example input-output pairs in the prompt) often improve LLM output quality compared to zero-shot prompting?',
        options: [
          'Few-shot prompting always requires retraining the entire model',
          'Providing concrete examples directly in the prompt helps the model understand the desired output format, style, and pattern more precisely, often producing more consistent and accurate results than a bare instruction alone',
          'Few-shot prompting has no measurable effect on output quality',
          'Few-shot prompting only works for image generation tasks, not text'
        ],
        correctIndex: 1,
        explanation:
            'Concrete examples give the model a clear pattern to follow for format, style, and reasoning approach — this demonstration-based guidance often produces more consistent, well-targeted output compared to relying purely on an abstract instruction with no examples.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What specific problem does Retrieval-Augmented Generation (RAG) directly address that a base LLM alone cannot solve?',
        options: [
          'RAG has no meaningful advantage over using a base LLM alone',
          'RAG grounds LLM responses in retrieved, relevant, and potentially private or up-to-date documents — addressing the base LLM\'s fixed knowledge cutoff, hallucination risk, and lack of access to organization-specific data',
          'RAG only works for image-based tasks, not text generation',
          'RAG eliminates the need for any prompt engineering whatsoever'
        ],
        correctIndex: 1,
        explanation:
            'RAG directly addresses the three key limitations discussed in this lesson — knowledge cutoff, hallucination, and lack of private data access — by grounding the model\'s response in specifically retrieved, relevant, real documents at generation time.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are building a customer support chatbot that must answer questions accurately based on your company\'s specific, frequently-updated internal policy documents, which change monthly. Which approach is most appropriate?',
        options: [
          'Use a base LLM with no additional context, relying entirely on its general training knowledge',
          'Implement RAG — retrieving the most relevant, current policy document excerpts at query time and providing them as context to the LLM, ensuring answers reflect your actual, up-to-date internal documentation',
          'Retrain an entirely new LLM from scratch every single month when policies change',
          'This use case cannot be addressed with any LLM-based approach'
        ],
        correctIndex: 1,
        explanation:
            'RAG is specifically well-suited to this scenario — frequently-updated, organization-specific documents are exactly the kind of information a base LLM cannot reliably know, and RAG\'s retrieval step naturally handles updates without requiring any model retraining.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Simple RAG System for Company FAQ Answering',
      goal:
          'Build a simplified RAG pipeline that retrieves relevant document context and constructs a grounded prompt for answering user questions.',
      steps: [
        'Create a simulated knowledge base of 8 short company policy/FAQ documents (a few sentences each) covering topics like returns, shipping, and warranty.',
        'Convert each document (and later, each incoming query) into a simple numeric representation (e.g., using TF-IDF vectors from Level 5, as a simplified stand-in for embeddings).',
        'Write a function retrieve_relevant_docs(query, top_k=2) that computes similarity between the query and all documents, returning the top-k most relevant document texts.',
        'For 3 simulated user questions, retrieve the relevant documents and construct a final prompt combining the retrieved context and the user question in a clear, well-structured format.',
        'Print each constructed final prompt, explaining how it would ground an LLM\'s response in the actual retrieved company policy text rather than the model\'s own general assumptions.',
      ],
      expectedOutput:
          'Retrieval function correctly identifies relevant documents for each query. Final constructed prompts correctly combine retrieved context with the user question in a clear, well-structured format demonstrating the RAG pattern.',
      xpReward: 70,
    ),
  ),
  TopicCourse(
    id: 'fine_tuning_llms_ds8',
    topicTitle: 'Fine-tuning LLMs',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 30,
    totalXp: 165,
    emoji: '🎛️',
    intro:
        'RAG grounds an LLM\'s responses in external documents without changing the model itself. Fine-tuning takes a different approach: actually adjusting the model\'s own weights on your specific data — the right choice when you need the model to adopt a specific style, tone, or specialized skill, not just new factual knowledge.',
    concepts: [
      ConceptLesson(
        title: 'Fine-Tuning vs RAG: Choosing the Right Approach',
        definition:
            'Fine-tuning adjusts a model\'s internal weights to change its BEHAVIOR (tone, style, specialized task performance), while RAG provides external KNOWLEDGE without changing the model at all — these solve different problems, and many production systems actually combine both techniques together.',
        analogy:
            'Fine-tuning is like sending an employee through specialized skills training that permanently changes how they approach and perform their work. RAG is like giving that same employee a reference manual to consult before answering specific questions — the employee\'s core skills and behavior remain unchanged, but they now have access to specific factual information they did not have memorized.',
        example:
            'A legal firm wanting an LLM to consistently write in formal legal language with proper citation formatting would benefit from FINE-TUNING (changing the model\'s writing STYLE/BEHAVIOR). The same firm wanting the LLM to accurately reference their specific, frequently-updated case files would benefit from RAG (providing current FACTUAL KNOWLEDGE).',
        keyTakeaway:
            'A common decision rule: use RAG when the problem is "the model does not KNOW this specific information," and use fine-tuning when the problem is "the model does not BEHAVE the way I need it to" (wrong tone, wrong format, missing a specialized skill) — many real systems use both together.',
      ),
      ConceptLesson(
        title: 'Parameter-Efficient Fine-Tuning: LoRA',
        definition:
            'Full fine-tuning updates ALL of a large model\'s parameters (extremely computationally expensive for billion-parameter LLMs). LoRA (Low-Rank Adaptation) instead freezes the original model and trains only small, additional "adapter" layers — achieving comparable results at a small fraction of the computational and memory cost.',
        analogy:
            'Full fine-tuning is like renovating an entire skyscraper from the foundation up to adapt it for a new purpose — extremely expensive and disruptive. LoRA is like adding a few carefully designed new floors and fixtures on top of the existing, otherwise-unchanged skyscraper — achieving most of the needed adaptation with dramatically less cost, time, and disruption to the original structure.',
        example:
            'Fully fine-tuning a 7-billion-parameter LLM might require multiple high-end GPUs and days of training. The same adaptation using LoRA might train only a few million additional adapter parameters, fitting on a single consumer GPU and completing in hours — a massive practical accessibility improvement.',
        keyTakeaway:
            'LoRA and similar parameter-efficient fine-tuning techniques are precisely what made LLM customization accessible beyond only the largest, best-resourced tech companies — this is directly analogous to the feature-extraction efficiency benefit from Level 7\'s transfer learning lesson, taken even further.',
        codeSnippet:
            '# Conceptual LoRA fine-tuning setup\nfrom peft import LoraConfig, get_peft_model\n\nlora_config = LoraConfig(\n    r=8,                    # rank of the small adapter matrices\n    lora_alpha=16,\n    target_modules=["q_proj", "v_proj"],   # which parts of the model to adapt\n    lora_dropout=0.1\n)\n# model = get_peft_model(base_model, lora_config)\n# Only a small fraction of total parameters are actually trained\nprint("LoRA trains a small adapter, keeping the large base model frozen")',
      ),
      ConceptLesson(
        title: 'Preparing Data for Fine-Tuning',
        definition:
            'Fine-tuning an LLM requires a dataset of input-output examples demonstrating the desired behavior — for instruction-following or chat-style fine-tuning, this typically means pairs of (prompt, ideal response) examples, formatted consistently, and generally requiring far fewer examples than training a model from scratch would need.',
        analogy:
            'Preparing fine-tuning data is like assembling a curated set of "model answer" examples for a new employee to study — rather than needing thousands of examples covering every possible scenario (since the employee already has strong general capability), a smaller, well-chosen set of high-quality examples demonstrating the SPECIFIC desired behavior is often sufficient.',
        example:
            'Fine-tuning an LLM to respond in a specific customer-service tone might require just a few hundred to a few thousand carefully curated (customer_question, ideal_branded_response) pairs — far less than the billions of examples the base model originally trained on, since fine-tuning only needs to ADJUST existing broad capability, not build it from nothing.',
        keyTakeaway:
            'Data QUALITY matters enormously more than quantity for LLM fine-tuning — a smaller set of carefully curated, consistent, high-quality examples typically produces better results than a much larger set of noisy, inconsistent examples, since the model is already broadly capable and mainly needs clear behavioral guidance.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'A company wants their LLM assistant to always respond using a very specific, consistent formal tone and formatting style across every interaction. Is this problem better addressed with RAG or fine-tuning?',
        options: [
          'RAG, since providing more documents will automatically change the model\'s writing style',
          'Fine-tuning, since this is fundamentally a BEHAVIOR/style change (how the model writes and responds), which fine-tuning is designed to address — rather than a knowledge gap, which RAG addresses',
          'Neither approach can influence an LLM\'s response style in any way',
          'This requires training a completely new LLM architecture from scratch'
        ],
        correctIndex: 1,
        explanation:
            'Since the goal is changing HOW the model responds (tone, style, format) rather than giving it new factual knowledge, this is a behavior-change problem best addressed through fine-tuning, following the RAG-vs-fine-tuning decision rule from this lesson.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What is the key practical advantage of LoRA (parameter-efficient fine-tuning) over full fine-tuning of a large language model?',
        options: [
          'LoRA always produces a completely different, unrelated model with no connection to the original',
          'LoRA freezes the original large model and trains only small additional adapter layers, achieving comparable adaptation results at a dramatically lower computational and memory cost than updating all of the model\'s original parameters',
          'LoRA requires more computational resources than full fine-tuning',
          'LoRA can only be used for image models, never language models'
        ],
        correctIndex: 1,
        explanation:
            'LoRA\'s core efficiency advantage comes from training only a small set of additional adapter parameters while keeping the massive original model frozen — dramatically reducing the computational and memory resources needed compared to updating every parameter in a full fine-tune.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A team has limited computational resources (a single consumer-grade GPU) but wants to adapt a large pretrained LLM to a specialized internal writing style. Which fine-tuning approach is most practical for their situation?',
        options: [
          'Full fine-tuning of every parameter in the large model',
          'Parameter-efficient fine-tuning (like LoRA), which trains only a small number of additional adapter parameters and can feasibly run on more limited hardware, unlike full fine-tuning of a large model',
          'Fine-tuning is impossible without access to a large GPU cluster',
          'They should abandon the LLM approach entirely and use only classical NLP methods'
        ],
        correctIndex: 1,
        explanation:
            'Given limited hardware resources, LoRA or similar parameter-efficient fine-tuning methods are specifically designed to make LLM customization feasible on more modest hardware, unlike full fine-tuning which typically requires substantial computational resources.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'RAG vs Fine-Tuning Decision Framework',
      goal:
          'Build a decision-making framework and prepare a simulated fine-tuning dataset for a realistic business LLM customization scenario.',
      steps: [
        'Define 5 different realistic business scenarios requiring LLM customization (e.g., "needs up-to-date pricing info," "must always respond in a specific brand voice," "needs access to private legal documents," "must follow a strict formal citation format," "needs current inventory data").',
        'For each scenario, write a decision (RAG, fine-tuning, or both) with a 1-2 sentence justification based on the RAG-vs-fine-tuning framework from this lesson.',
        'For the ONE scenario you identified as requiring fine-tuning, create a simulated fine-tuning dataset of 10 (prompt, ideal_response) example pairs demonstrating the desired style/behavior consistently.',
        'Write a short explanation of why data quality and consistency matter for this simulated dataset, referencing the lesson\'s guidance on fine-tuning data preparation.',
        'Summarize your complete decision framework as a simple table for future reference.',
      ],
      expectedOutput:
          'All 5 scenarios correctly analyzed with sound RAG/fine-tuning/both decisions and justification. Fine-tuning dataset of 10 consistent example pairs correctly created. Explanation of data quality importance is clear and accurate.',
      xpReward: 65,
    ),
  ),
  TopicCourse(
    id: 'building_ai_applications_ds8',
    topicTitle: 'Building AI Applications',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 30,
    totalXp: 160,
    emoji: '🏗️',
    intro:
        'You now know the individual pieces — embeddings, transformers, RAG, fine-tuning. This lesson brings them together into the practical architecture of a real AI application, covering the full pipeline from user input to a reliable, safe, monitored production response.',
    concepts: [
      ConceptLesson(
        title: 'The Anatomy of an LLM-Powered Application',
        definition:
            'A typical production LLM application combines several components: an input handling/validation layer, optionally a RAG retrieval step, prompt construction (combining system instructions, retrieved context, and user input), the LLM call itself, and output post-processing/validation before returning a response to the user.',
        analogy:
            'An LLM application architecture is like a well-organized customer service desk workflow — a receptionist first validates and routes the incoming request (input handling), a researcher pulls any relevant background files if needed (RAG retrieval), a manager combines all this information into clear instructions for the expert (prompt construction), the expert provides their response (LLM call), and a quality checker reviews the response before it goes out (output validation).',
        example:
            'A customer support AI assistant: (1) validate the user\'s question is appropriate and well-formed, (2) retrieve relevant company policy documents via RAG, (3) construct a prompt combining a system instruction ("be helpful and professional"), retrieved policy context, and the user question, (4) call the LLM, (5) check the response for any policy violations or hallucinated claims before displaying it to the user.',
        keyTakeaway:
            'Treating "call the LLM" as just ONE step in a larger, carefully engineered pipeline — rather than the entire application — is the key mindset shift from experimenting with prompts to building a genuinely reliable, production-quality AI application.',
      ),
      ConceptLesson(
        title: 'Handling LLM Unreliability: Validation and Guardrails',
        definition:
            'LLM outputs are inherently probabilistic and can occasionally be malformed, off-topic, or factually wrong — production applications need guardrails: output format validation (does the response match the expected structure?), content filtering, and fallback behavior when the LLM output fails these checks.',
        analogy:
            'Guardrails around an LLM are like quality control inspectors on a manufacturing line — even with an excellent, well-trained production process, an occasional defective item still comes through, and the inspection step catches and handles these cases (rejecting, flagging, or fixing them) before they ever reach the customer, rather than assuming every single output is automatically correct.',
        example:
            'An application expecting the LLM to always return valid JSON should explicitly validate the output actually parses as JSON before using it — if validation fails, the application might retry the request, fall back to a simpler rule-based response, or clearly flag the failure rather than crashing or silently passing through malformed data.',
        keyTakeaway:
            'Never assume an LLM call will always succeed and return exactly the expected format — building explicit validation and fallback logic around every LLM call is standard, essential production practice, not an optional extra.',
        codeSnippet:
            'import json\n\ndef safe_llm_json_call(llm_response_text, fallback=None):\n    try:\n        parsed = json.loads(llm_response_text)\n        return parsed\n    except json.JSONDecodeError:\n        print("LLM output was not valid JSON - using fallback")\n        return fallback\n\nresult = safe_llm_json_call(\'{"sentiment": "positive"}\')\nprint(result)\nbad_result = safe_llm_json_call("not valid json at all", fallback={"sentiment": "unknown"})\nprint(bad_result)',
      ),
      ConceptLesson(
        title: 'Cost, Latency and Evaluation Considerations',
        definition:
            'Production LLM applications must balance response quality against real API costs (charged per token) and latency (response time) — while also needing a systematic evaluation approach to measure whether the application is actually performing well, since traditional accuracy metrics do not directly apply to open-ended generated text.',
        analogy:
            'Balancing LLM application tradeoffs is like running a restaurant kitchen that must balance food quality, cost of ingredients, and how quickly dishes reach customers — using the most premium ingredients (largest, most capable model) for every single dish might produce excellent quality but at unsustainable cost and slower service, requiring thoughtful tradeoffs based on what each specific dish actually needs.',
        example:
            'A simple sentiment classification task might work perfectly well and far more cheaply with a smaller, faster model, while a complex creative writing task might genuinely require a larger, more expensive model — using the largest available model for every single task in an application wastes cost and increases latency unnecessarily.',
        keyTakeaway:
            'Evaluating LLM application quality often requires a combination of automated checks (format validation, keyword presence) and human review of sample outputs, since traditional precision/recall metrics from Level 5 do not directly apply to evaluating open-ended, generated natural language responses.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why is it important to think of an LLM call as just ONE step within a larger application pipeline, rather than the entire application itself?',
        options: [
          'The LLM call is always the only component that matters in any AI application',
          'A production-quality application requires additional steps around the LLM call — input validation, possibly retrieval, careful prompt construction, and output validation — to be reliable; treating the LLM call alone as "the application" ignores these essential surrounding components',
          'LLM calls should never be part of any real application',
          'This distinction has no practical relevance to building AI applications'
        ],
        correctIndex: 1,
        explanation:
            'This is the key mindset shift emphasized in this lesson — a reliable production application requires careful engineering around the LLM call (input handling, prompt construction, output validation), not just the LLM call in isolation.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'An application expects an LLM to always return a specific structured format (like JSON), but occasionally the LLM returns malformed output. What is the appropriate production-quality response to this reality?',
        options: [
          'Assume this will never happen and write no handling code for it',
          'Build explicit output validation with fallback behavior (retry, default response, or clear error flagging) for when the LLM output does not match the expected format, since LLM outputs are inherently probabilistic and occasionally imperfect',
          'Immediately abandon the entire application if this occurs even once',
          'LLM outputs are always perfectly formatted and require no validation'
        ],
        correctIndex: 1,
        explanation:
            'Because LLM outputs are inherently probabilistic and can occasionally be malformed, building explicit validation and fallback handling around every LLM call is standard, essential practice for any production-quality application.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are designing an AI application with both a simple task (classifying support ticket urgency) and a complex task (drafting detailed technical responses). How should you approach model selection for cost and latency optimization?',
        options: [
          'Always use the single largest, most expensive available model for every task in the application regardless of complexity',
          'Match model size/cost to task complexity — use a smaller, faster, cheaper model for the simple classification task, and reserve a larger, more capable model for the genuinely complex drafting task',
          'Model selection has no effect on cost or latency in any application',
          'Always use the smallest possible model for every task regardless of quality needs'
        ],
        correctIndex: 1,
        explanation:
            'Thoughtfully matching model capability to actual task complexity — rather than uniformly using the most expensive option everywhere — is the standard approach to balancing quality, cost, and latency across a real application with tasks of varying difficulty.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'End-to-End AI Application Architecture',
      goal:
          'Design and implement a complete, guardrail-protected AI application pipeline combining multiple concepts from this level.',
      steps: [
        'Design a customer support AI assistant application: define the input (user question), and simulate a small knowledge base of 6 policy documents.',
        'Implement an input validation function that checks the user question is non-empty and reasonably formed before proceeding.',
        'Implement a simplified retrieval step (using TF-IDF similarity from earlier work) to find relevant documents given the user question.',
        'Construct a well-structured final prompt combining a system instruction, retrieved context, and the user question.',
        'Implement an output validation function that checks a simulated LLM response meets basic quality criteria (non-empty, reasonable length, does not contain any specified problematic phrases), with a clear fallback response if validation fails.',
        'Run the complete pipeline on 3 simulated user questions, printing each step\'s output to demonstrate the full architecture working end to end.',
      ],
      expectedOutput:
          'Complete pipeline correctly implemented with input validation, retrieval, prompt construction, and output validation all functioning together. All 3 test questions processed through the full pipeline with clear, step-by-step output demonstrating the architecture.',
      xpReward: 70,
    ),
  ),
  TopicCourse(
    id: 'capstone_nlp_genai_project_ds8',
    topicTitle: 'Capstone: NLP/GenAI Project',
    careerId: 'data_scientist',
    categoryId: 'ai_data',
    difficulty: 'Advanced',
    estimatedMinutes: 75,
    totalXp: 245,
    emoji: '🏆',
    intro:
        'This is your Level 8 capstone — build a complete, portfolio-defining NLP/GenAI application combining text preprocessing, embeddings, pretrained transformers, and RAG into one coherent, realistic business system, demonstrating mastery of the entire modern NLP toolkit.',
    concepts: [
      ConceptLesson(
        title: 'Combining Classical NLP with Modern LLM Techniques',
        definition:
            'The strongest real-world NLP systems often combine classical techniques (TF-IDF for fast retrieval, rule-based validation) with modern transformer-based components (pretrained classifiers, LLM generation) — choosing the simplest effective tool for each sub-task rather than defaulting to the most complex option everywhere.',
        analogy:
            'Building a complete NLP system is like assembling a well-equipped toolbox for a renovation project — you use a simple, fast hand tool (classical TF-IDF) for quick, straightforward tasks, and reserve the more powerful, sophisticated power tool (a large transformer model) for tasks that genuinely require its additional capability — using the right tool for each specific job rather than only the most impressive one available.',
        example:
            'A complete document search-and-answer system might use fast TF-IDF similarity for initial document retrieval (efficient at scale), then a more powerful transformer-based model only for the final answer generation step — balancing speed/cost against the deeper language understanding needed for the final response.',
        keyTakeaway:
            'A well-engineered NLP system is judged by whether it reliably solves the actual business problem end to end — not by whether it uses the most cutting-edge model at every single step; matching tool complexity to task requirements is a hallmark of mature, professional system design.',
      ),
      ConceptLesson(
        title: 'Evaluating a Complete NLP System',
        definition:
            'Evaluating an end-to-end NLP application requires checking multiple layers: does retrieval find genuinely relevant documents, does the final generated output correctly use that retrieved information, and does the overall system handle edge cases (irrelevant queries, missing information) gracefully rather than confidently producing wrong answers.',
        analogy:
            'Evaluating a complete NLP pipeline is like conducting a full quality audit of a multi-stage restaurant kitchen — checking not just whether the final dish tastes good, but whether each individual stage (ingredient sourcing, preparation, cooking, plating) is working correctly, since a failure at any single stage can produce a disappointing final result even if other stages are excellent.',
        example:
            'A RAG-based question-answering system might generate fluent, confident-sounding responses even when its retrieval step failed to find any genuinely relevant documents — evaluating retrieval quality SEPARATELY from generation quality is essential to correctly diagnose where a system\'s failures are actually occurring.',
        keyTakeaway:
            'A complete evaluation checks each pipeline stage somewhat independently (is retrieval finding the right documents? is generation faithful to that retrieved context?) rather than only judging the final end-to-end output — this stage-by-stage diagnostic approach mirrors the model-diagnosis principle from Level 7\'s capstone.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why might a well-designed NLP system use simple TF-IDF for document retrieval rather than a more complex transformer-based approach for that specific step?',
        options: [
          'TF-IDF is always strictly better than any transformer-based approach for every possible NLP task',
          'For fast, large-scale retrieval, a simpler, faster, cheaper technique like TF-IDF may be perfectly adequate and more efficient — reserving the more powerful (and expensive) transformer models for the tasks that genuinely benefit from their additional capability, like final answer generation',
          'Transformers cannot be used for any retrieval-related tasks under any circumstances',
          'This kind of mixed-technique approach never occurs in real production NLP systems'
        ],
        correctIndex: 1,
        explanation:
            'Matching tool complexity to what each specific sub-task actually requires — using simpler, faster techniques where sufficient and reserving more powerful models for tasks that genuinely need them — is a hallmark of mature, well-engineered production system design.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A RAG-based question-answering system produces fluent, confident answers, but investigation reveals its retrieval step is frequently failing to find genuinely relevant documents. What does this scenario illustrate about evaluating complete NLP pipelines?',
        options: [
          'Since the final output sounds fluent and confident, the system must be working correctly overall',
          'Evaluating each pipeline stage somewhat independently (checking retrieval quality separately from generation quality) is essential — a fluent final output can mask an underlying failure at an earlier stage like retrieval',
          'Retrieval quality is irrelevant to a RAG system\'s overall performance',
          'This kind of failure pattern is impossible in any real RAG system'
        ],
        correctIndex: 1,
        explanation:
            'This scenario directly illustrates why stage-by-stage evaluation matters — a fluent-sounding final generated response can completely mask an underlying retrieval failure, which only becomes apparent when each pipeline stage is checked somewhat independently.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are designing a complete NLP system with multiple stages (retrieval, classification, generation) and want to ensure it is genuinely reliable, not just impressive-looking on a few cherry-picked examples. What evaluation approach is most appropriate?',
        options: [
          'Test only the single most impressive-looking example and assume the system works correctly overall',
          'Systematically evaluate each pipeline stage somewhat independently (does retrieval find relevant content? does generation faithfully use that content?), test with a variety of realistic and edge-case inputs, and check the full end-to-end output quality',
          'Evaluation is unnecessary once a system produces any fluent-sounding output',
          'Only evaluate the final output text length, ignoring content quality entirely'
        ],
        correctIndex: 1,
        explanation:
            'A thorough, stage-by-stage evaluation approach combined with testing across varied and edge-case inputs is essential for genuinely assessing system reliability — relying on a single impressive example or surface-level fluency alone risks missing real underlying failures.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Complete NLP/GenAI Capstone: Intelligent Document Q&A System',
      goal:
          'Build a complete, evaluated, portfolio-quality document question-answering system combining classical retrieval, pretrained NLP models, and RAG-based prompt construction.',
      steps: [
        'KNOWLEDGE BASE: Simulate a company knowledge base of 15 short documents covering a few related business topics (policies, product info, procedures).',
        'PREPROCESSING: Apply appropriate text preprocessing to the knowledge base documents.',
        'RETRIEVAL: Build a TF-IDF-based retrieval function that finds the most relevant documents for a given user query.',
        'CLASSIFICATION LAYER: Use a pretrained sentiment or classification pipeline to categorize incoming user queries (e.g., "complaint," "question," "compliment") to demonstrate a secondary NLP task integrated into the same system.',
        'PROMPT CONSTRUCTION: For 5 varied test queries (including at least one query with NO good matching document, to test edge-case handling), construct final grounded prompts combining retrieved context and the query.',
        'EVALUATION: For each of the 5 test queries, assess and document: was retrieval relevant? was the query correctly classified? did the system handle the no-good-match case gracefully rather than confidently fabricating an answer?',
        'REPORT: Write a summary covering system architecture, evaluation findings across all 5 test cases, and identified limitations or areas for improvement.',
      ],
      expectedOutput:
          '=== LEVEL 8 CAPSTONE: NLP/GENAI DOCUMENT Q&A SYSTEM ===\nKnowledge base: 15 documents, preprocessed and indexed\nRetrieval: [correctly implemented and tested across 5 queries]\nClassification layer: [query categories correctly assigned]\nEdge case handling: [no-match query correctly identified and handled gracefully]\nEvaluation summary: [stage-by-stage assessment across all 5 test cases]\n\nLevel 8 Complete — NLP & Generative AI Mastered.\nReady for Level 9: MLOps & Production Data Science.',
      xpReward: 140,
    ),
  ),
];
