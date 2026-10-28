import '../../models/course_content_data.dart';

const List<TopicCourse> computerVisionEngineerLevel1 = [
  TopicCourse(
    id: 'intro_to_computer_vision_l1',
    topicTitle: 'What is Computer Vision?',
    careerId: 'computer_vision_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '👁️',
    intro:
        'Computer Vision is the technology that lets machines "see" — powering self-driving cars, face unlock on your phone, medical scan analysis, and Instagram filters. In this very first lesson, you will understand exactly what Computer Vision is, why it is genuinely hard for computers, the core tasks it solves, and the full 10-level roadmap you are about to walk through.',
    concepts: [
      ConceptLesson(
        title: 'What is Computer Vision?',
        definition:
            'Computer Vision (CV) is a field of Artificial Intelligence that trains computers to interpret and understand visual information from the world — images and videos — the same way humans use their eyes and brain.',
        analogy:
            'Think of your eyes as a camera and your brain as the processor. Your eyes capture light (the raw image), and your brain instantly understands "that is a cat," "that is my friend," "that car is close." Computer Vision tries to give a computer this exact same capability: capture pixels, then understand what they mean.',
        example:
            'Examples you already use every day:\n• Face unlock on your phone (recognizing a face)\n• Google Photos searching "beach" and finding your beach pictures (image classification)\n• A self-driving car detecting pedestrians (object detection)\n• Instagram filters that put dog ears on your face (facial landmark detection)',
        keyTakeaway:
            'Computer Vision is not just "looking at images" — it is teaching a computer to extract meaning, make decisions, and take action based on what it "sees". This roadmap will take you from raw pixels to building real, working CV systems.',
      ),
      ConceptLesson(
        title: 'Why is Vision Hard for Computers?',
        definition:
            'While humans recognize objects instantly and effortlessly, a computer only ever sees a giant grid of numbers. Turning that grid of numbers into meaning ("this is a dog") is a genuinely difficult problem called the semantic gap.',
        analogy:
            'Imagine someone hands you a massive spreadsheet of 500,000 numbers and asks "what animal is this?" with zero other context. That is exactly the problem a computer faces every time it looks at an image — there are no labels, no obvious edges, just numbers. Computer Vision is the science of closing this gap.',
        example:
            'The same object can look completely different in pixel terms:\n• A cat in bright sunlight vs a cat in shadow (different pixel values, same cat)\n• A cat facing left vs facing right (completely different pixel arrangement)\n• A cat partially hidden behind a sofa (occlusion)\n\nA human effortlessly recognizes "cat" in all three cases. A computer must be specifically trained to handle this variation.',
        keyTakeaway:
            'The core challenge of Computer Vision is variation: lighting, angle, occlusion, scale, and background all change the raw pixels while the actual object stays the same. Every technique in this roadmap exists to help a model handle this variation robustly.',
      ),
      ConceptLesson(
        title: 'The Core Tasks of Computer Vision',
        definition:
            'Computer Vision problems generally fall into a few core task types, each answering a different question about an image.',
        analogy:
            'Think of a security guard watching a camera feed. "Is there a person in this frame at all?" is classification. "Where exactly is the person standing?" is detection. "Trace the exact outline of that person\'s body" is segmentation. Different questions need different tools.',
        example:
            'Image Classification: "Is this a cat or a dog?" → one label for the whole image\nObject Detection: "Where are the cats AND dogs, with boxes around each?" → multiple labelled boxes\nImage Segmentation: "Which exact pixels belong to the cat?" → pixel-level outline\nFace Recognition: "Whose face is this specifically?" → identity matching',
        keyTakeaway:
            'This roadmap builds up through these tasks in order of complexity: classification (Levels 3-6), detection (Level 7), and segmentation (Level 8) — each level giving you the tools for a harder, more specific question about an image.',
      ),
      ConceptLesson(
        title: 'Where Computer Vision Engineers Actually Work',
        definition:
            'Computer Vision Engineers build the systems behind autonomous vehicles, medical imaging diagnostics, retail checkout automation, agricultural crop monitoring, security and surveillance, manufacturing quality inspection, and augmented reality — a genuinely wide range of industries all depending on the exact same underlying skills.',
        analogy:
            'Learning Computer Vision is like learning to be an electrician — the core wiring skills stay the same whether you end up wiring a hospital, a house, or a factory. The exact same convolution and detection skills you build in this roadmap apply whether you later work on self-driving cars, cancer detection, or warehouse robots.',
        example:
            'Healthcare: detecting tumors in X-rays and MRIs\nAutomotive: detecting lanes, pedestrians, and traffic signs\nRetail: automatic checkout systems that recognize products\nAgriculture: drones detecting crop disease from aerial photos\nManufacturing: spotting defective products on an assembly line',
        keyTakeaway:
            'The specific industry you end up working in does not change the fundamental skill progression this roadmap teaches — pixels, filters, neural networks, detection, and segmentation are universal building blocks used across every single one of these fields.',
      ),
      ConceptLesson(
        title: 'How This Roadmap is Structured',
        definition:
            'Over 10 levels, you will progress from raw pixels to a complete, deployable Computer Vision system — exactly the skill progression a working CV Engineer uses on the job.',
        analogy:
            'Learning Computer Vision is like learning to build a house: first you learn what bricks and cement actually are (pixels, this level), then you learn basic construction tools (image processing, Level 2), then simple structures (classical ML, Level 3), then modern building techniques (deep learning and CNNs, Levels 4-6), then specialized rooms (detection and segmentation, Levels 7-8), and finally how to make the house liveable for real people (deployment, Level 9) and how to explain your work to a client (interviews, Level 10).',
        example:
            'Level 1 (now): pixels, images, basic operations, datasets\nLevel 2: filters and convolution\nLevel 3: classical ML on images\nLevels 4-6: neural networks, CNNs, transfer learning\nLevel 7: object detection\nLevel 8: segmentation and generative vision\nLevel 9: production deployment\nLevel 10: interview mastery',
        keyTakeaway:
            'Every level builds directly on the one before it — you cannot skip ahead. The convolution you learn in Level 2 becomes the building block of the CNNs in Level 5, which become the backbone of the object detectors in Level 7. Master each level fully before moving on.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is Computer Vision?',
        options: [
          'A field of AI that trains computers to interpret and understand images and videos',
          'A type of camera hardware',
          'A programming language for graphics',
          'A method for compressing image files'
        ],
        correctIndex: 0,
        explanation:
            'Computer Vision is a field of Artificial Intelligence focused on giving computers the ability to interpret and understand visual information — images and video — the way humans do with their eyes and brain.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the "semantic gap" in Computer Vision?',
        options: [
          'The gap in file size between two images',
          'The difficulty of turning raw pixel numbers into meaningful understanding',
          'The distance between a camera and its subject',
          'A missing update in computer vision software'
        ],
        correctIndex: 1,
        explanation:
            'The semantic gap refers to the fact that a computer only sees a grid of numbers (pixel values), and there is a genuine difficulty in bridging that gap to arrive at meaning, like "this is a dog".',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which task answers the question: "Which exact pixels in this image belong to the cat?"',
        options: [
          'Image Classification',
          'Object Detection',
          'Image Segmentation',
          'Image Compression'
        ],
        correctIndex: 2,
        explanation:
            'Image Segmentation assigns a label to every individual pixel, producing a precise outline of an object — exactly what is needed to answer "which exact pixels belong to the cat".',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why does this roadmap teach the same core skills (pixels, convolution, neural networks) regardless of which industry you eventually work in?',
        options: [
          'Because every industry secretly uses identical software',
          'Because Computer Vision\'s fundamental building blocks are universal, applying equally whether the end application is healthcare, automotive, retail, or manufacturing',
          'Because industries never actually use Computer Vision in practice',
          'Because only one industry actually needs Computer Vision skills'
        ],
        correctIndex: 1,
        explanation:
            'The fundamental Computer Vision building blocks — pixels, filters, neural networks, detection, segmentation — are universal. The specific industry only changes the application, not the underlying skill progression this roadmap teaches.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A company wants to build a system that draws a box around every car in a parking lot photo, labelling each one. Which core CV task is this?',
        options: [
          'Image Classification',
          'Object Detection',
          'Image Segmentation',
          'Face Recognition'
        ],
        correctIndex: 1,
        explanation:
            'Drawing a box around each individual car and labelling it is the definition of Object Detection — finding and localizing multiple objects within one image.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Why does this roadmap teach convolution (Level 2) BEFORE Convolutional Neural Networks (Level 5)?',
        options: [
          'The order does not matter at all',
          'Because CNNs are built directly on top of the convolution operation, so understanding it first makes CNNs make sense rather than feel like magic',
          'Because Level 2 has nothing to do with Level 5',
          'Because convolution is only used in Level 2 and never again'
        ],
        correctIndex: 1,
        explanation:
            'Convolutional Neural Networks are literally built from stacked convolution operations. Understanding convolution deeply in Level 2 means Level 5\'s CNNs will feel like a natural, understandable extension rather than an unexplained black box.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'My Computer Vision Journey Map',
      goal:
          'Create a personal roadmap document identifying 3 real-world Computer Vision applications you want to be able to build by the end of this 10-level path.',
      steps: [
        'List 3 Computer Vision applications you personally find interesting (e.g., a plant disease detector, a parking space counter, a sign-language translator)',
        'For each application, identify which core CV task it needs: classification, detection, segmentation, or a combination',
        'Look at the Level 1-10 structure and note which level(s) will teach you the skills for each application',
        'Identify which real-world industry (healthcare, automotive, retail, agriculture, manufacturing) each application would belong to',
        'Write 2-3 sentences on why Computer Vision specifically excites you compared to other areas of AI',
      ],
      expectedOutput:
          'Application 1: Plant disease detector -> Classification (Level 3-6), Agriculture industry\nApplication 2: Parking space counter -> Object Detection (Level 7), Retail/Smart City industry\nApplication 3: Background remover app -> Segmentation (Level 8), Consumer app industry\n\nReflection: I am excited about Computer Vision because...',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'digital_image_basics_l1',
    topicTitle: 'Digital Image Fundamentals',
    careerId: 'computer_vision_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '🖼️',
    intro:
        'Before you can build any Computer Vision system, you must understand exactly what a digital image actually is at its core. In this lesson, you will learn about pixels, resolution, color channels, and bit depth — the raw building blocks every single CV technique in this roadmap is built on top of.',
    concepts: [
      ConceptLesson(
        title: 'What is a Pixel?',
        definition:
            'A pixel (short for "picture element") is the smallest single unit of a digital image — a tiny square that holds one color value. An image is simply a grid made up of thousands or millions of these tiny squares.',
        analogy:
            'Think of a pixel like a single tile in a huge mosaic artwork. One tile alone means very little, but arrange thousands of small colored tiles together in a grid, and a complete picture emerges. A digital image works exactly the same way — thousands of tiny colored squares combining to form what you see.',
        example:
            'A "1920x1080" HD photo means the image is a grid of 1920 pixels wide and 1080 pixels tall.\n\nTotal pixels = 1920 × 1080 = 2,073,600 pixels — over 2 million tiny colored squares making up just one photo.',
        keyTakeaway:
            'Every operation in Computer Vision, no matter how advanced, ultimately works on this grid of pixels. Understanding that an "image" is really just organized numbers is the single most important mental shift for this entire roadmap.',
      ),
      ConceptLesson(
        title: 'Resolution: Image Width and Height',
        definition:
            'Resolution describes the dimensions of an image in pixels — how many pixels wide and how many pixels tall. Higher resolution means more pixels, which generally means more visual detail, but also more data to process.',
        analogy:
            'Resolution is like the grid size of a puzzle. A 100-piece puzzle (low resolution) shows a rough picture. A 5000-piece puzzle (high resolution) shows the exact same picture but with far more fine detail — at the cost of needing far more pieces (data) to assemble.',
        example:
            'Common resolutions:\n• Thumbnail: 128x128 = 16,384 pixels\n• Standard web photo: 640x480 = 307,200 pixels\n• Full HD: 1920x1080 = 2,073,600 pixels\n• 4K: 3840x2160 = 8,294,400 pixels',
        keyTakeaway:
            'Higher resolution is not always better for Computer Vision — models in this roadmap often deliberately resize images DOWN (e.g., to 224x224) before processing, trading some detail for dramatically faster and more efficient computation.',
      ),
      ConceptLesson(
        title: 'Color Channels: How Color is Stored',
        definition:
            'A color image is typically stored as three separate grids of numbers — one each for Red, Green, and Blue (RGB) — stacked together. Each pixel\'s final color is created by combining its value from all three channels.',
        analogy:
            'Think of RGB channels like three colored spotlights (a red light, a green light, and a blue light) all pointed at the exact same spot on a stage. By adjusting the brightness of each individual spotlight, you can produce any color at all — that is exactly how RGB pixel values combine.',
        example:
            'A pixel value of (255, 0, 0) means: full Red, no Green, no Blue → pure red.\nA pixel value of (255, 255, 255) means: full Red, full Green, full Blue → white.\nA pixel value of (0, 0, 0) means: no Red, no Green, no Blue → black.\nA pixel value of (128, 128, 128) → a mid-grey.',
        keyTakeaway:
            'A single color image is really THREE grids of numbers stacked together, not one. A grayscale image, by contrast, needs only ONE grid, since it has no color information — just brightness. This distinction matters throughout this entire roadmap.',
      ),
      ConceptLesson(
        title: 'Bit Depth: How Much Detail Per Pixel',
        definition:
            'Bit depth determines how many different values a single pixel channel can hold. The most common standard, 8-bit, allows 256 possible values (0 to 255) per channel.',
        analogy:
            'Bit depth is like how many notches are on a volume dial. An 8-bit channel is like a dial with 256 possible notches — plenty of fine control for most purposes. Fewer bits would mean fewer notches, and a rougher, more limited range of values.',
        example:
            '8-bit per channel (standard):\n• Red: 0-255\n• Green: 0-255\n• Blue: 0-255\n• Total possible colors: 256 × 256 × 256 = 16,777,216 (over 16 million colors)\n\nThis is why 8-bit RGB is often called "24-bit color" (8+8+8 = 24 bits total).',
        keyTakeaway:
            'When you later work with these pixel values in code (Level 2 onward), remember they typically range from 0 to 255 for 8-bit images. Many CV techniques normalize these values (e.g., dividing by 255 to get a 0-to-1 range) before feeding them into a model.',
      ),
      ConceptLesson(
        title: 'Common Image File Formats',
        definition:
            'Images are stored on disk using specific file formats — most commonly JPEG (lossy compression, small file size), PNG (lossless compression, supports transparency), and BMP (uncompressed, very large files) — each making a different trade-off between file size and quality.',
        analogy:
            'Choosing an image format is like choosing how to pack for a trip. JPEG is like vacuum-sealing your clothes — much smaller, but you lose a little bit of quality (some wrinkles). PNG is like folding carefully — takes more space, but nothing is lost or degraded. BMP is like just throwing everything in loose — maximum space used, zero compression at all.',
        example:
            'A 1920x1080 photo might be:\n• 200 KB as JPEG (compressed, some quality loss)\n• 2 MB as PNG (lossless, larger file)\n• 6 MB as BMP (completely uncompressed)\n\nJPEG is used for photos (where slight quality loss is invisible). PNG is used for screenshots, logos, and anything needing transparency.',
        keyTakeaway:
            'When collecting or saving training images throughout this roadmap, JPEG is usually fine for photographs, but PNG is preferred when you need pixel-perfect accuracy (like segmentation masks in Level 8, where every single pixel value matters and cannot be approximated).',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is a pixel?',
        options: [
          'A type of camera lens',
          'The smallest single unit of a digital image, holding one color value',
          'A file format for saving images',
          'A measurement of image file size in megabytes'
        ],
        correctIndex: 1,
        explanation:
            'A pixel (picture element) is the smallest single unit that makes up a digital image — a tiny square holding one color value. Millions of pixels arranged in a grid form a complete image.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'A "1920x1080" resolution image has how many total pixels?',
        options: ['1920', '1080', '2,073,600', '3,000'],
        correctIndex: 2,
        explanation:
            'Total pixels = width × height = 1920 × 1080 = 2,073,600 pixels.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'How many separate number grids (channels) does a standard color RGB image use?',
        options: ['1', '2', '3', '4'],
        correctIndex: 2,
        explanation:
            'A standard RGB color image uses 3 separate channels — one each for Red, Green, and Blue — stacked together to produce the final color at every pixel.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why might PNG be preferred over JPEG for saving a segmentation mask, where every pixel value matters?',
        options: [
          'PNG files are always smaller than JPEG files',
          'PNG uses lossless compression, so no pixel values are altered or approximated, unlike JPEG\'s lossy compression',
          'JPEG cannot store any image at all',
          'PNG and JPEG are exactly identical formats with no differences'
        ],
        correctIndex: 1,
        explanation:
            'PNG uses lossless compression, meaning every pixel value is preserved exactly. JPEG\'s lossy compression can subtly alter pixel values to save space — acceptable for photos, but risky for segmentation masks where exact pixel values carry meaning.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A pixel has the RGB value (0, 255, 0). What color does this represent?',
        options: ['Pure Red', 'Pure Green', 'Pure Blue', 'White'],
        correctIndex: 1,
        explanation:
            '(0, 255, 0) means zero Red, full Green, and zero Blue — this combination produces pure green.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Pixel Detective: Analyze an Image\'s Structure',
      goal:
          'Practice reasoning about an image\'s underlying pixel structure and file format without writing any code yet, building the mental model this entire roadmap depends on.',
      steps: [
        'Pick any photo on your phone or computer and check its resolution and file format (usually visible in the file properties/details)',
        'Calculate the total number of pixels in that photo (width × height)',
        'Determine whether the photo is color (3 channels) or grayscale (1 channel)',
        'Estimate the total number of individual numbers needed to represent this image (pixels × channels)',
        'Write 2-3 sentences explaining, in your own words, why a computer sees this photo as "just numbers" rather than as a picture',
      ],
      expectedOutput:
          'Photo resolution: 3024 x 4032, Format: JPEG\nTotal pixels: 12,192,768\nChannels: 3 (RGB color)\nTotal numbers representing this image: 36,578,304\n\nReflection: A computer has no concept of "seeing" a picture the way I do — it only processes this enormous grid of numbers, and every computer vision technique exists to extract meaning from that grid...',
      xpReward: 50,
    ),
  ),
  TopicCourse(
    id: 'images_as_arrays_l1',
    topicTitle: 'Images as Numbers: Arrays & NumPy',
    careerId: 'computer_vision_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 140,
    emoji: '🔢',
    intro:
        'Now that you understand pixels conceptually, it is time to see them in actual code. NumPy is the foundational Python library that represents images as arrays of numbers, and it is the tool every single library in this roadmap — OpenCV, PyTorch, and beyond — is built on top of.',
    concepts: [
      ConceptLesson(
        title: 'NumPy Arrays: The Language of Computer Vision',
        definition:
            'NumPy is a Python library for working with multi-dimensional arrays of numbers, extremely efficiently. In Computer Vision, every single image is represented and manipulated as a NumPy array.',
        analogy:
            'If pixels are the individual tiles in a mosaic, a NumPy array is the labelled grid tray that holds all those tiles in perfect rows and columns, letting you instantly grab any tile by its row and column position, or grab entire rows and columns at once.',
        example:
            'import numpy as np\n\n# A tiny 2x2 grayscale image\nimage = np.array([\n    [0, 255],\n    [128, 64]\n])\nprint(image.shape)  # (2, 2) — 2 rows, 2 columns',
        keyTakeaway:
            'Learning to think in NumPy arrays is non-negotiable for Computer Vision — every image you load, resize, filter, or feed into a neural network throughout this entire roadmap will be a NumPy array (or a very similar tensor) under the hood.',
        codeSnippet:
            'import numpy as np\n\nimage = np.array([[0, 255], [128, 64]])\nprint(image)\nprint("Shape:", image.shape)\nprint("Data type:", image.dtype)',
      ),
      ConceptLesson(
        title: 'Image Shape: Height, Width, and Channels',
        definition:
            'When you load a color image as a NumPy array, its "shape" tells you three numbers: height (rows), width (columns), and channels (usually 3 for RGB). This order — (height, width, channels) — is a critical convention to remember.',
        analogy:
            'Think of shape like a shipping label on a box: it tells you exactly how the contents are organized before you even open it. Knowing an image\'s shape is (480, 640, 3) immediately tells you: 480 rows tall, 640 columns wide, and 3 color channels — no guessing required.',
        example:
            'A colour photo loaded into NumPy might have shape (480, 640, 3):\n• 480 = height (number of rows / pixels top-to-bottom)\n• 640 = width (number of columns / pixels left-to-right)\n• 3 = channels (Red, Green, Blue)\n\nA grayscale version of the same photo would have shape (480, 640) — no channel dimension at all.',
        keyTakeaway:
            'Getting the shape order wrong (confusing height and width, or forgetting the channel dimension) is one of the most common beginner bugs in Computer Vision. Always check image.shape first whenever something looks visually wrong.',
        codeSnippet:
            'import numpy as np\n\n# Simulate a small color image: 4 rows, 5 columns, 3 channels\nimage = np.zeros((4, 5, 3), dtype=np.uint8)\nprint(image.shape)  # (4, 5, 3)',
      ),
      ConceptLesson(
        title: 'Indexing and Slicing: Accessing Pixels and Regions',
        definition:
            'NumPy indexing lets you access a single pixel, an entire row, an entire column, or a rectangular region (a "slice") of an image using square-bracket notation.',
        analogy:
            'NumPy indexing is like giving map coordinates to zoom into any part of a city map — you can point to one exact building (a single pixel), an entire street (a row), or draw a rectangle to select a whole neighbourhood (a region of the image) using the same simple coordinate system.',
        example:
            'image[0, 0]        # the pixel at row 0, column 0 (top-left corner)\nimage[10, 20]      # the pixel at row 10, column 20\nimage[0:50, 0:50]  # a 50x50 region from the top-left corner\nimage[:, :, 0]     # only the Red channel of the entire image',
        keyTakeaway:
            'This exact slicing pattern — image[row_start:row_end, col_start:col_end] — is how you crop images throughout this roadmap. Mastering it now means cropping, cutting patches for CNNs (Level 5), and extracting detected regions (Level 7) will all feel completely natural.',
        codeSnippet:
            'import numpy as np\n\nimage = np.arange(25).reshape(5, 5)\nprint(image)\nprint("Top-left pixel:", image[0, 0])\nprint("Top-left 2x2 region:\\n", image[0:2, 0:2])',
      ),
      ConceptLesson(
        title: 'Data Types: uint8 vs Float',
        definition:
            'Image arrays are usually stored as uint8 (unsigned 8-bit integers, range 0-255) for storage and display, but are often converted to float32 (decimal numbers, often scaled to 0.0-1.0) before being fed into machine learning models.',
        analogy:
            'Think of uint8 as a simple whole-number ruler used for everyday measuring (fine for showing a picture on screen), while float32 is like a much more precise scientific instrument needed for the delicate mathematical calculations neural networks perform internally.',
        example:
            'Original pixel (uint8): 200\nNormalized pixel (float32): 200 / 255 = 0.784\n\nThis normalization step — converting uint8 pixels to a 0.0-1.0 float range — is one of the most common and important preprocessing steps you will repeat throughout this entire roadmap, starting in Level 4.',
        keyTakeaway:
            'A very common beginner bug is feeding raw uint8 pixel values (0-255) directly into a neural network without normalizing first — this often makes training unstable or fail entirely. Always check your data type and range before training any model.',
        codeSnippet:
            'import numpy as np\n\npixel_uint8 = np.array([200], dtype=np.uint8)\npixel_float = pixel_uint8.astype(np.float32) / 255.0\nprint(pixel_float)  # [0.78431373]',
      ),
      ConceptLesson(
        title: 'Basic Array Math on Images',
        definition:
            'Because images are just NumPy arrays, ordinary math operations (addition, subtraction, multiplication) can be applied directly to entire images at once — for example, adding a number to every pixel brightens an image, without needing any special "image editing" function.',
        analogy:
            'This is like being able to instantly adjust the brightness of every single tile in a giant mosaic at once with one simple command, rather than manually repainting each tile individually one by one — NumPy applies the same operation to every pixel simultaneously.',
        example:
            'import numpy as np\n\nimage = np.array([[100, 150], [200, 50]], dtype=np.uint8)\nbrighter = image + 30      # Adds 30 to every pixel\ndarker = image - 30        # Subtracts 30 from every pixel\nprint(brighter)',
        keyTakeaway:
            'This "apply one operation to the whole array at once" pattern, called vectorization, is exactly why NumPy is so fast, and it is the exact same principle behind the far more complex operations (like convolution in Level 2) you will learn very soon.',
        codeSnippet:
            'import numpy as np\n\nimage = np.array([[100, 150], [200, 50]], dtype=np.uint8)\nbrighter = np.clip(image.astype(int) + 30, 0, 255).astype(np.uint8)\nprint("Original:\\n", image)\nprint("Brighter:\\n", brighter)',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'In Computer Vision, what is an image represented as in Python?',
        options: [
          'A plain text string',
          'A NumPy array of numbers',
          'A single integer',
          'An audio waveform'
        ],
        correctIndex: 1,
        explanation:
            'Images in Computer Vision are represented as NumPy arrays — multi-dimensional grids of numbers representing pixel values, which every CV library in this roadmap builds on top of.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'A color image has shape (480, 640, 3). What does the 3 represent?',
        options: [
          '3 rows',
          '3 columns',
          '3 color channels (RGB)',
          '3 different images'
        ],
        correctIndex: 2,
        explanation:
            'The third number in an image\'s shape represents the number of color channels — 3 for a standard RGB color image (Red, Green, Blue).',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does the NumPy slice image[0:50, 0:50] extract?',
        options: [
          'A single pixel at position (0, 50)',
          'A 50x50 pixel region from the top-left corner of the image',
          'The entire image resized to 50x50',
          'Every 50th pixel in the image'
        ],
        correctIndex: 1,
        explanation:
            'image[0:50, 0:50] slices rows 0 through 49 and columns 0 through 49, extracting a 50x50 pixel region from the top-left corner of the image.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is it useful that NumPy can apply a math operation (like adding 30) to an entire image array at once?',
        options: [
          'It is not actually useful and is rarely done in practice',
          'This vectorized operation is extremely fast and avoids manually looping over every individual pixel, and it is the same underlying principle behind more advanced operations like convolution',
          'It only works on grayscale images, never color images',
          'It permanently deletes the original image data'
        ],
        correctIndex: 1,
        explanation:
            'Vectorized operations let NumPy apply the same calculation to every pixel simultaneously, extremely efficiently. This exact principle — operating on the whole array at once — underlies more advanced techniques like convolution, taught in Level 2.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You load a grayscale image and check its shape. It prints (300, 400). What does this tell you?',
        options: [
          'The image is 300 pixels wide and 400 pixels tall, in color',
          'The image is 300 pixels tall and 400 pixels wide, with no color channel dimension (grayscale)',
          'The image has 300 color channels',
          'This shape is invalid for any image'
        ],
        correctIndex: 1,
        explanation:
            'A shape of (300, 400) with only two numbers means 300 rows (height) by 400 columns (width), and the absence of a third number confirms this is a grayscale image with no separate color channel dimension.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You want to darken an entire image slightly. Which approach directly uses this lesson\'s vectorization concept?',
        options: [
          'Write a for-loop that visits every single pixel one at a time and manually subtracts a value',
          'Subtract a number directly from the whole NumPy array at once (with np.clip to stay in range), letting NumPy apply the operation to every pixel simultaneously',
          'Darkening an image is not possible using NumPy',
          'Delete every third pixel from the image'
        ],
        correctIndex: 1,
        explanation:
            'Subtracting a value from the whole array at once is the vectorized approach — NumPy applies the operation to every pixel simultaneously, which is dramatically faster than manually looping over each pixel one at a time.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build a Tiny Image from Scratch with NumPy',
      goal:
          'Use NumPy to construct a small synthetic image from pure numbers, directly practicing the array-thinking skill this entire roadmap depends on.',
      steps: [
        'Import numpy and create an 8x8 NumPy array of zeros with dtype=np.uint8, representing a small black grayscale image',
        'Use slicing to set a 4x4 region in the center of the array to the value 255 (creating a white square in the middle of a black image)',
        'Print the array\'s shape and confirm it matches your expectation',
        'Create a second 8x8x3 array (a color version) and set the same center region to (255, 0, 0) to make the square red instead of white',
        'Use basic array math to brighten the entire grayscale array by adding 20 to every pixel (using np.clip to stay within 0-255)',
        'Print all arrays and write 1-2 sentences describing, in plain words, what each array of numbers represents visually',
      ],
      expectedOutput:
          'Grayscale image shape: (8, 8)\n[[  0   0   0   0   0   0   0   0]\n [  0   0   0   0   0   0   0   0]\n [  0   0 255 255 255 255   0   0]\n ...]\n\nColor image shape: (8, 8, 3)\nBrightened grayscale image (max value now 255, min value now 20)\n\nReflection: This grid of numbers represents a black image with a white (or red) square in the exact center, built entirely using array slicing with no image file involved...',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'opencv_pillow_basics_l1',
    topicTitle: 'Reading & Writing Images with OpenCV and Pillow',
    careerId: 'computer_vision_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 140,
    emoji: '📷',
    intro:
        'You now understand images as arrays conceptually — this lesson makes it real by teaching you the two most widely used Python libraries for actually loading, viewing, and saving images: OpenCV and Pillow. These two tools will appear in nearly every project throughout this entire roadmap.',
    concepts: [
      ConceptLesson(
        title: 'OpenCV: The Industry-Standard CV Library',
        definition:
            'OpenCV (Open Source Computer Vision Library) is the most widely used library for Computer Vision tasks — reading, writing, and processing images and video, and provides highly optimized, fast implementations of classical CV algorithms.',
        analogy:
            'If Computer Vision were a workshop, OpenCV is the fully-stocked professional toolbox every working engineer keeps at their bench — it does not just hold one tool, it holds hundreds of ready-made, battle-tested tools for nearly every classical image operation you could need.',
        example:
            'import cv2\n\nimage = cv2.imread("photo.jpg")     # Load an image\nprint(image.shape)                 # (height, width, 3)\ncv2.imwrite("output.jpg", image)   # Save an image',
        keyTakeaway:
            'OpenCV loads images as NumPy arrays automatically, directly connecting to what you just learned — meaning everything you know about slicing and indexing arrays applies immediately to any image you load with OpenCV.',
        codeSnippet:
            'import cv2\n\n# Load an image from disk\nimage = cv2.imread("photo.jpg")\n\nif image is None:\n    print("Error: image not found")\nelse:\n    print("Image loaded! Shape:", image.shape)\n    cv2.imwrite("copy.jpg", image)',
      ),
      ConceptLesson(
        title: 'The BGR vs RGB Trap',
        definition:
            'A critical and very common beginner trap: OpenCV loads color images in BGR (Blue, Green, Red) channel order by default, NOT the more standard RGB order most other tools and libraries expect.',
        analogy:
            'This is like two countries driving on opposite sides of the road — both are internally consistent systems, but mixing them up without realizing it causes real, confusing accidents. If you display or process an OpenCV-loaded image assuming RGB order, your colors will appear strangely swapped (reds turn blue, blues turn red).',
        example:
            'import cv2\n\nimage_bgr = cv2.imread("photo.jpg")           # Loaded as BGR\nimage_rgb = cv2.cvtColor(image_bgr, cv2.COLOR_BGR2RGB)  # Convert to RGB\n\n# Now image_rgb is safe to display with libraries expecting RGB (like matplotlib)',
        keyTakeaway:
            'ALWAYS remember: OpenCV = BGR by default. Whenever you see oddly-colored images (skin looking blue, sky looking orange) while working with OpenCV, the BGR/RGB mismatch is very often the culprit. This single fact will save you hours of confused debugging throughout this roadmap.',
        codeSnippet:
            'import cv2\n\nimage_bgr = cv2.imread("photo.jpg")\nimage_rgb = cv2.cvtColor(image_bgr, cv2.COLOR_BGR2RGB)\nprint("BGR pixel:", image_bgr[0, 0])\nprint("RGB pixel:", image_rgb[0, 0])',
      ),
      ConceptLesson(
        title: 'Pillow (PIL): The Simpler Image Library',
        definition:
            'Pillow (often imported as PIL) is a simpler, more beginner-friendly Python library for basic image loading, saving, and light editing, and it loads images in standard RGB order by default — avoiding OpenCV\'s BGR trap entirely.',
        analogy:
            'If OpenCV is the professional workshop\'s heavy-duty toolbox, Pillow is the simple, reliable everyday hand tool — not as powerful for heavy-duty classical CV algorithms, but wonderfully quick and intuitive for simple tasks like opening, resizing, and saving an image.',
        example:
            'from PIL import Image\n\nimg = Image.open("photo.jpg")\nprint(img.size)     # (width, height) — note: PIL uses (width, height), not (height, width)!\nimg.save("copy.png")',
        keyTakeaway:
            'Notice Pillow reports size as (width, height), the OPPOSITE order of NumPy/OpenCV\'s (height, width, channels) convention. Always double-check which convention a specific library uses — this exact kind of mismatch is a very common source of subtle bugs.',
        codeSnippet:
            'from PIL import Image\nimport numpy as np\n\nimg = Image.open("photo.jpg")\nprint("PIL size (width, height):", img.size)\n\nimg_array = np.array(img)\nprint("NumPy shape (height, width, channels):", img_array.shape)',
      ),
      ConceptLesson(
        title: 'Handling File Errors Gracefully',
        definition:
            'Real-world image loading code must handle the case where a file does not exist, is corrupted, or is an unsupported format — OpenCV returns None instead of raising an error when a file fails to load, which must be explicitly checked for.',
        analogy:
            'This is like always double-checking a door actually opened before walking through it, rather than assuming it always will — a program that blindly assumes every image loads successfully will crash unpredictably the very first time it encounters a missing or corrupted file in a real dataset.',
        example:
            'import cv2\n\nimage = cv2.imread("does_not_exist.jpg")\nprint(image)   # None — no error is raised, just None returned!\n\nif image is None:\n    print("Warning: could not load image, skipping...")',
        keyTakeaway:
            'Throughout this roadmap, especially when processing large datasets (Level 3 onward), always check if image is None immediately after loading. Skipping this single check is one of the most common causes of confusing crashes when a real dataset contains even one bad file.',
        codeSnippet:
            'import cv2\n\ndef safe_load(path):\n    image = cv2.imread(path)\n    if image is None:\n        print(f"Warning: failed to load {path}")\n        return None\n    return image\n\nresult = safe_load("missing_file.jpg")',
      ),
      ConceptLesson(
        title: 'Choosing Between OpenCV and Pillow',
        definition:
            'In practice, professional Computer Vision Engineers often use BOTH libraries in the same project — Pillow for simple, quick image handling, and OpenCV for heavier classical CV algorithms (which you will learn starting in Level 2).',
        analogy:
            'This is like a professional carpenter who owns both a simple hand screwdriver AND a heavy-duty power drill — neither tool is universally "better"; the right choice depends entirely on the specific task at hand.',
        example:
            'Use Pillow when: quickly opening/resizing/saving images, working with web frameworks, simple format conversions.\n\nUse OpenCV when: applying filters (Level 2), detecting edges (Level 2), working with video streams (Level 9), or using any classical CV algorithm.',
        keyTakeaway:
            'You do not need to pick a single "favorite" library forever — professional CV code frequently converts between OpenCV arrays, Pillow images, and plain NumPy arrays within the very same script, depending on which specific tool needs which specific format.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'What color channel order does OpenCV use by DEFAULT when loading a color image?',
        options: [
          'RGB (Red, Green, Blue)',
          'BGR (Blue, Green, Red)',
          'GRB (Green, Red, Blue)',
          'CMYK'
        ],
        correctIndex: 1,
        explanation:
            'OpenCV loads color images in BGR (Blue, Green, Red) order by default — a very common and important beginner trap, since most other tools expect RGB order.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which OpenCV function converts a BGR image to RGB?',
        options: [
          'cv2.imread()',
          'cv2.cvtColor(image, cv2.COLOR_BGR2RGB)',
          'cv2.imwrite()',
          'cv2.resize()'
        ],
        correctIndex: 1,
        explanation:
            'cv2.cvtColor(image, cv2.COLOR_BGR2RGB) converts an image from OpenCV\'s default BGR channel order to standard RGB order.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does cv2.imread() return if the specified file cannot be found or loaded?',
        options: [
          'It raises an exception immediately',
          'It returns None, without raising an error',
          'It returns a black image automatically',
          'It automatically searches for a similarly named file'
        ],
        correctIndex: 1,
        explanation:
            'cv2.imread() silently returns None when a file cannot be loaded, rather than raising an error — which is exactly why explicitly checking "if image is None" after every load is essential, especially when processing large datasets.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What order does Pillow\'s img.size property report image dimensions in?',
        options: [
          '(height, width)',
          '(width, height)',
          '(channels, height, width)',
          'It does not report dimensions'
        ],
        correctIndex: 1,
        explanation:
            'Pillow\'s img.size reports dimensions as (width, height) — the opposite order of NumPy/OpenCV\'s (height, width, channels) convention, an important distinction to remember.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You load a photo with OpenCV and display it using a library that expects RGB order, without converting first. The sky (which should be blue) appears orange instead. What is the most likely cause?',
        options: [
          'The camera that took the photo was broken',
          'The BGR vs RGB channel order mismatch — the Blue and Red channels are effectively swapped',
          'The image file is corrupted',
          'OpenCV cannot load photos of the sky'
        ],
        correctIndex: 1,
        explanation:
            'This is the classic BGR/RGB mismatch bug: OpenCV loaded the image in BGR order, but the display library interpreted the channels as RGB, effectively swapping the Blue and Red channels and turning blue skies orange.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'Your script processes 5,000 images in a folder using cv2.imread() in a loop, but crashes with an AttributeError on the 47th image. What is the most likely cause, based on this lesson?',
        options: [
          'Python can only process 46 images before crashing permanently',
          'Image 47 likely failed to load (returned None), and the code tried to call a method like .shape on None without checking for it first',
          'cv2.imread() has a hidden limit of 46 images per script',
          'The computer ran out of electricity'
        ],
        correctIndex: 1,
        explanation:
            'This is exactly the "check for None" lesson in practice — cv2.imread() silently returns None on failure, and calling any method on None (like .shape) raises an AttributeError. Always check "if image is None" before using a loaded image.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Load, Convert, and Save Pipeline',
      goal:
          'Build a small script that loads an image with OpenCV, correctly handles the BGR/RGB conversion and missing-file errors, and saves a processed copy — directly practicing this lesson\'s core skills.',
      steps: [
        'Find or save any .jpg image on your computer',
        'Write a safe_load(path) function that loads an image with cv2.imread() and returns None with a printed warning if loading fails',
        'Test your function on both a valid image path and a deliberately incorrect path, confirming the warning prints correctly',
        'For the valid image, convert it from BGR to RGB using cv2.cvtColor()',
        'Save a copy of the image using cv2.imwrite()',
        'Also open the same image with Pillow\'s Image.open() and print its .size, comparing it to the OpenCV shape you printed earlier',
      ],
      expectedOutput:
          'Testing valid path: Image loaded! Shape: (600, 800, 3)\nTesting invalid path: Warning: failed to load missing_file.jpg\n\nOpenCV shape (height, width, channels): (600, 800, 3)\nPillow size (width, height): (800, 600)\n\nBoth report the same image dimensions, just in a different order and format — confirming the same underlying image data, accessed through two different libraries.',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'basic_image_operations_l1',
    topicTitle: 'Basic Image Operations',
    careerId: 'computer_vision_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 30,
    totalXp: 140,
    emoji: '✂️',
    intro:
        'This lesson makes everything you have learned practical: resizing, cropping, rotating, flipping, and converting colors are the most common operations you will perform on nearly every image in every project throughout this entire roadmap, from preprocessing training data in Level 4 to preparing frames for real-time detection in Level 9.',
    concepts: [
      ConceptLesson(
        title: 'Resizing Images',
        definition:
            'Resizing changes an image\'s width and height, either to make it smaller (for faster processing) or to match the exact input size a specific model expects.',
        analogy:
            'Resizing an image is like photocopying a document at a different zoom percentage — the actual content stays the same, but its physical size on the page changes. Just as a photocopier might slightly blur very small text when shrinking a page, resizing images can lose fine detail when shrinking significantly.',
        example:
            'import cv2\n\nimage = cv2.imread("photo.jpg")\nresized = cv2.resize(image, (224, 224))   # Resize to exactly 224x224\nprint(resized.shape)   # (224, 224, 3)',
        keyTakeaway:
            'Almost every neural network in this roadmap (starting Level 4) expects a FIXED input size (very commonly 224x224). Resizing every image to match this exact expected size is one of the most frequent preprocessing steps in all of Computer Vision.',
        codeSnippet:
            'import cv2\n\nimage = cv2.imread("photo.jpg")\nprint("Original shape:", image.shape)\n\nresized = cv2.resize(image, (224, 224))\nprint("Resized shape:", resized.shape)',
      ),
      ConceptLesson(
        title: 'Cropping Images',
        definition:
            'Cropping extracts a specific rectangular region from an image, discarding everything outside that region. Since images are NumPy arrays, cropping is done using simple array slicing.',
        analogy:
            'Cropping is exactly like using scissors to cut out one specific photo from a larger printed sheet of many photos — everything outside your cut lines is simply discarded, leaving only the exact region you wanted.',
        example:
            'import cv2\n\nimage = cv2.imread("photo.jpg")\n# Crop a region: rows 50-250, columns 100-400\ncropped = image[50:250, 100:400]\nprint(cropped.shape)   # (200, 300, 3)',
        keyTakeaway:
            'This is the exact same slicing technique from the NumPy lesson, now applied directly to real photos — cropping is simply image[row_start:row_end, col_start:col_end], no special function needed at all.',
        codeSnippet:
            'import cv2\n\nimage = cv2.imread("photo.jpg")\ncropped = image[50:250, 100:400]\ncv2.imwrite("cropped_photo.jpg", cropped)',
      ),
      ConceptLesson(
        title: 'Rotating and Flipping Images',
        definition:
            'Rotating turns an image around a center point by a chosen angle, while flipping mirrors an image horizontally or vertically. Both are extremely common for data augmentation — artificially creating more varied training examples from existing images.',
        analogy:
            'Rotating and flipping an image is like turning a photograph in your hands or holding it up to a mirror — the actual subject in the photo has not changed at all, only its orientation. This is exactly why these operations are so useful: they create "new" training examples without needing any new real photos.',
        example:
            'import cv2\n\nimage = cv2.imread("photo.jpg")\nflipped_horizontal = cv2.flip(image, 1)   # 1 = horizontal flip\nflipped_vertical = cv2.flip(image, 0)     # 0 = vertical flip\nrotated_90 = cv2.rotate(image, cv2.ROTATE_90_CLOCKWISE)',
        keyTakeaway:
            'This lesson\'s rotating and flipping directly previews "data augmentation," a technique you will use heavily starting in Level 6 — artificially expanding a training dataset by creating rotated, flipped, and otherwise altered copies of existing images.',
        codeSnippet:
            'import cv2\n\nimage = cv2.imread("photo.jpg")\nflipped = cv2.flip(image, 1)\nrotated = cv2.rotate(image, cv2.ROTATE_90_CLOCKWISE)\ncv2.imwrite("flipped.jpg", flipped)\ncv2.imwrite("rotated.jpg", rotated)',
      ),
      ConceptLesson(
        title: 'Color Space Conversion',
        definition:
            'Color space conversion changes how color information is represented — for example, converting a color image to grayscale (removing color, keeping only brightness), which is often used to simplify a task or reduce computation.',
        analogy:
            'Converting to grayscale is like watching a movie in black-and-white instead of color — you lose the color information, but the shapes, edges, and overall content of every scene remain completely intact and recognizable.',
        example:
            'import cv2\n\nimage = cv2.imread("photo.jpg")\ngray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)\nprint(image.shape)   # (h, w, 3) — color\nprint(gray.shape)    # (h, w) — grayscale, no channel dimension',
        keyTakeaway:
            'Converting to grayscale reduces an image\'s data by two-thirds (from 3 channels down to 1), which is why many classical CV algorithms in Level 2 (like edge detection) operate on grayscale images by default — less data to process for tasks where color is not actually needed.',
        codeSnippet:
            'import cv2\n\nimage = cv2.imread("photo.jpg")\ngray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)\nprint("Color shape:", image.shape)\nprint("Grayscale shape:", gray.shape)',
      ),
      ConceptLesson(
        title: 'Combining Operations into a Preprocessing Pipeline',
        definition:
            'In real projects, these individual operations (resize, crop, flip, color-convert) are almost always chained together into a single reusable preprocessing function, applied consistently to every image before it reaches a model or algorithm.',
        analogy:
            'This is like an assembly line at a factory, where every single item passes through the exact same sequence of stations in the exact same order — one image preprocessing function ensures every photo, no matter its original size or source, ends up perfectly consistent before the next stage of your CV pipeline.',
        example:
            'def preprocess(path):\n    image = cv2.imread(path)\n    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)\n    image = cv2.resize(image, (224, 224))\n    return image\n\nEvery image, regardless of its original size or color order, now goes through the exact same consistent transformation.',
        keyTakeaway:
            'Building this exact kind of reusable preprocess() function now is direct, practical preparation for Level 4 onward, where you will feed thousands of images through an identical pipeline before training any neural network — consistency here prevents subtle bugs later.',
        codeSnippet:
            'import cv2\n\ndef preprocess(path, size=(224, 224)):\n    image = cv2.imread(path)\n    if image is None:\n        return None\n    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)\n    image = cv2.resize(image, size)\n    return image\n\nresult = preprocess("photo.jpg")\nprint(result.shape if result is not None else "Failed to load")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Why is resizing images to a fixed size (like 224x224) such a common preprocessing step?',
        options: [
          'It makes images look more artistic',
          'Most neural networks expect a fixed input size, so images must be resized to match before being fed into a model',
          'Resizing is required by law for all digital images',
          'It permanently deletes the original image file'
        ],
        correctIndex: 1,
        explanation:
            'Neural networks (starting from Level 4 in this roadmap) are typically built to expect a fixed input size. Resizing every image to that exact size is a necessary and extremely common preprocessing step.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'How is cropping typically performed on an image loaded as a NumPy array?',
        options: [
          'Using a special crop() function that does not use array indexing',
          'Using array slicing, e.g., image[row_start:row_end, col_start:col_end]',
          'Cropping is not possible on NumPy arrays',
          'By deleting the entire image and creating a new one from scratch'
        ],
        correctIndex: 1,
        explanation:
            'Cropping is done using standard NumPy array slicing — exactly the same technique used to access any region of an array, applied here to extract a specific rectangular portion of an image.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why are rotating and flipping images useful techniques in Computer Vision?',
        options: [
          'They are only useful for artistic photo editing, with no practical CV use',
          'They are commonly used for data augmentation, creating varied training examples from existing images',
          'They permanently fix blurry images',
          'They convert color images into 3D models'
        ],
        correctIndex: 1,
        explanation:
            'Rotating and flipping are core data augmentation techniques — they create new, varied training examples from existing images without needing to collect any new real photos, a technique used heavily starting in Level 6.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is it good practice to combine resize, color conversion, and other operations into a single reusable preprocessing function?',
        options: [
          'It is not good practice; each operation should always be applied inconsistently',
          'It ensures every image is transformed consistently in the exact same way, preventing subtle bugs when the same pipeline is later applied to thousands of images before training a model',
          'Combining operations makes the code run slower on purpose',
          'A single function can only ever process one image in the entire program'
        ],
        correctIndex: 1,
        explanation:
            'A single, reusable preprocessing function guarantees every image passes through the exact same consistent sequence of transformations, which is essential when processing large datasets throughout this roadmap, starting from Level 3-4 onward.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You need to prepare 10,000 training photos of different sizes for a neural network that requires exactly 224x224 input images. What is the correct first step?',
        options: [
          'Delete all photos that are not already exactly 224x224',
          'Resize every photo to 224x224 using cv2.resize() before feeding them into the model',
          'Convert all photos to grayscale first, then resize',
          'Manually crop each photo by hand using an image editor'
        ],
        correctIndex: 1,
        explanation:
            'The standard, scalable approach is to programmatically resize every photo to the model\'s required input size using cv2.resize() — this is a routine, automatable preprocessing step, not something requiring manual editing or deletion of valid data.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You flip every training photo horizontally to create additional training examples for an object classifier. Is this always a safe technique?',
        options: [
          'Yes, horizontal flipping is always perfectly safe for every single CV task with no exceptions',
          'Usually safe for general object classification (a flipped cat is still a cat), but NOT safe for tasks where left/right orientation carries meaning, such as reading text or classifying left vs right hand X-rays',
          'No, flipping images is never a valid technique in Computer Vision',
          'Flipping only works on grayscale images, never color images'
        ],
        correctIndex: 1,
        explanation:
            'While flipping is a very common augmentation, it is not universally safe — for tasks where orientation carries meaning (text, left/right medical scans, traffic direction), flipping could create incorrect or misleading training examples.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build a Complete Image Preprocessing Pipeline',
      goal:
          'Combine every technique from this lesson into a single, reusable preprocessing function — directly practicing the exact kind of preprocessing pipeline you will build and reuse throughout this entire roadmap.',
      steps: [
        'Write a Python function called preprocess_image(path) that loads an image using cv2.imread(), returning None with a warning if loading fails',
        'Inside the function, convert the image from BGR to RGB',
        'Resize the image to 224x224',
        'Convert a SECOND copy of the image to grayscale (keep both the color and grayscale versions)',
        'Return both the resized color image and the grayscale image from the function',
        'Test your function on 3 different photos of different original sizes, printing the shape of each output to confirm all color outputs are exactly (224, 224, 3) regardless of original size',
      ],
      expectedOutput:
          'Testing photo 1 (original size 1200x900): Resized shape (224, 224, 3), Grayscale shape (900, 1200)\nTesting photo 2 (original size 640x480): Resized shape (224, 224, 3), Grayscale shape (480, 640)\nTesting photo 3 (original size 3000x2000): Resized shape (224, 224, 3), Grayscale shape (2000, 3000)\n\nAll resized outputs match the required (224, 224, 3) shape regardless of original image size, confirming the preprocessing function works correctly.',
      xpReward: 60,
    ),
  ),
  TopicCourse(
    id: 'datasets_and_labels_l1',
    topicTitle: 'Understanding Datasets and Labels in Computer Vision',
    careerId: 'computer_vision_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '📁',
    intro:
        'Every Computer Vision model, from the simplest classifier to the most advanced detector, is only as good as the dataset it learns from. This final Level 1 lesson teaches you how CV datasets are organized and labelled — the essential groundwork for classical ML (Level 3) and deep learning (Level 4 onward).',
    concepts: [
      ConceptLesson(
        title: 'What is a Computer Vision Dataset?',
        definition:
            'A Computer Vision dataset is a structured collection of images paired with labels — the "correct answers" a model learns to predict, such as a category name, a bounding box location, or a pixel-level mask.',
        analogy:
            'A CV dataset is like a stack of flashcards used to teach a student: one side shows a picture (the image), and the other side shows the correct answer (the label) — "this is a cat," "the dog is located here," or "these exact pixels are the sky." The model studies thousands of these flashcards to learn the underlying pattern.',
        example:
            'A simple image classification dataset might be organized as folders:\ndataset/\n  cats/\n    cat001.jpg\n    cat002.jpg\n  dogs/\n    dog001.jpg\n    dog002.jpg\n\nHere, the folder name itself IS the label for every image inside it.',
        keyTakeaway:
            'Every technique from Level 3 onward assumes you already have a properly organized, labelled dataset. Understanding how datasets are structured now means you will never be confused about where "the answers" come from when a model starts learning.',
      ),
      ConceptLesson(
        title: 'Labels for Different CV Tasks',
        definition:
            'Different Computer Vision tasks require fundamentally different types of labels: classification needs one category label per image, detection needs bounding box coordinates plus a category for each object, and segmentation needs a full pixel-level mask.',
        analogy:
            'This is like the difference between labelling a whole box "fruit" (classification), drawing a circle around each individual fruit inside a photo of a fruit bowl and naming each one (detection), and precisely tracing the exact outline of every single fruit with a pen (segmentation) — each task requires progressively more detailed labelling effort.',
        example:
            'Classification label: "cat" (one word for the whole image)\nDetection label: {class: "cat", box: [x=50, y=30, width=120, height=100]}\nSegmentation label: a full-size mask image where every pixel belonging to the cat is marked, and every other pixel is marked as background',
        keyTakeaway:
            'This directly maps to the roadmap ahead: Level 3-6 use classification-style labels (Level 3-6), Level 7 uses detection-style labels, and Level 8 uses segmentation-style labels — the labelling format always matches the specific task complexity.',
      ),
      ConceptLesson(
        title: 'Training, Validation, and Test Splits',
        definition:
            'A dataset is typically divided into three separate parts before training any model: a training set (the model learns from this), a validation set (used to tune the model during development), and a test set (used only once, at the very end, for a final honest evaluation).',
        analogy:
            'Training data is like textbook exercises with worked-out answers — you learn from these. Validation data is like a practice exam with no official grade — you use it to check your progress and adjust your study approach. Test data is like the actual final exam — you only see it once, and it tells you how well you genuinely learned, not how well you memorized the practice materials.',
        example:
            'A typical split for a dataset of 10,000 images:\n• Training set: 7,000 images (70%) — the model learns from these\n• Validation set: 1,500 images (15%) — used to tune settings during development\n• Test set: 1,500 images (15%) — used only once, for final evaluation',
        keyTakeaway:
            'Never let a model see the test set during training or tuning — this "data leakage" would give a falsely optimistic sense of how well the model actually performs on genuinely new, unseen images, a mistake that will be explicitly addressed again during evaluation topics in Level 3.',
      ),
      ConceptLesson(
        title: 'Common Public Computer Vision Datasets',
        definition:
            'Several large, publicly available datasets are used throughout the Computer Vision field for learning, benchmarking, and pretraining models — knowing their names and purposes is genuinely useful foundational knowledge.',
        analogy:
            'These public datasets are like standardized practice exam papers used across an entire school system — everyone studies from the SAME well-known material, making it possible to fairly compare how well different students (or in this case, different models) actually perform.',
        example:
            'MNIST: 70,000 small images of handwritten digits (0-9) — the classic beginner dataset\nCIFAR-10: 60,000 small color images across 10 categories (planes, cars, birds, etc.)\nImageNet: over 14 million images across 20,000+ categories — the dataset that launched the deep learning revolution in Computer Vision\nCOCO: a large dataset with detection AND segmentation labels for everyday objects',
        keyTakeaway:
            'You will use MNIST and CIFAR-10 for hands-on practice starting in Level 4-5, and ImageNet-pretrained models will become central to "transfer learning" in Level 6 — recognizing these dataset names now means you will immediately understand their significance later.',
      ),
      ConceptLesson(
        title: 'Common Dataset Quality Problems',
        definition:
            'Real-world datasets are rarely perfect — common problems include class imbalance (far more examples of one category than another), mislabelled images, and duplicate images, all of which can quietly hurt a model\'s performance if not identified early.',
        analogy:
            'This is like a cooking recipe where one ingredient is measured incorrectly, or a key ingredient is missing entirely — even if the rest of the technique is flawless, a flawed set of "ingredients" (the dataset) will always produce a flawed final dish (the trained model), no matter how good the chef.',
        example:
            'Class imbalance: a medical dataset with 9,900 "healthy" images and only 100 "disease" images — a model could get 99% accuracy by simply always predicting "healthy," while being completely useless.\nMislabelled images: a "cat" folder that accidentally contains a few dog photos, confusing the model during training.',
        keyTakeaway:
            'Always visually inspect a sample of your dataset before training anything. This exact class imbalance problem will be revisited in depth during Level 3\'s evaluation metrics lesson, where you will learn specifically why accuracy alone can be a dangerously misleading metric.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is a Computer Vision dataset?',
        options: [
          'A single very large image file',
          'A structured collection of images paired with labels representing the correct answers',
          'A type of camera used only for research',
          'A software tool for editing photos'
        ],
        correctIndex: 1,
        explanation:
            'A Computer Vision dataset is a structured collection of images paired with labels — the correct answers (category, bounding box, or pixel mask) a model learns to predict from the images.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'Which type of label does an Object Detection task require?',
        options: [
          'A single category label for the whole image',
          'Bounding box coordinates plus a category label for each object',
          'A full pixel-level mask for the entire image',
          'No labels are needed for detection'
        ],
        correctIndex: 1,
        explanation:
            'Object Detection requires bounding box coordinates (location and size) plus a category label for each individual object present in an image, since it must both locate AND classify multiple objects.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why should a test set only be used once, at the very end of model development?',
        options: [
          'Test sets can only physically be opened one time',
          'Using it repeatedly during development would cause data leakage, giving a falsely optimistic sense of how the model performs on genuinely new data',
          'Test sets contain no useful information at all',
          'It is a legal requirement with no technical reason behind it'
        ],
        correctIndex: 1,
        explanation:
            'Repeatedly using test data during development is a form of data leakage — it lets your development choices indirectly "peek" at data meant to represent genuinely unseen examples, resulting in a falsely optimistic final performance estimate.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is class imbalance (e.g., 9,900 healthy images vs 100 disease images) a dangerous dataset problem?',
        options: [
          'It has no real effect on model training or evaluation',
          'A model could achieve high accuracy by always predicting the majority class, while being completely useless at detecting the rare, important minority class',
          'Class imbalance always makes a dataset physically too large to use',
          'This problem only ever occurs in audio datasets, never image datasets'
        ],
        correctIndex: 1,
        explanation:
            'With severe class imbalance, a model can achieve deceptively high accuracy by simply always predicting the majority class, while completely failing at the minority class — often the exact case that matters most, like detecting disease.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are building a system to trace the exact outline of tumors in medical scans, pixel by pixel. Which type of dataset label do you need?',
        options: [
          'Classification labels (one word per image)',
          'Detection labels (bounding boxes)',
          'Segmentation labels (pixel-level masks)',
          'No labels are needed for this task'
        ],
        correctIndex: 2,
        explanation:
            'Tracing the exact outline of an object pixel by pixel is precisely what Segmentation labels provide — a full mask marking exactly which pixels belong to the tumor versus everything else.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Design a Dataset Plan for a Real CV Problem',
      goal:
          'Plan out a complete, properly-structured dataset for a real-world Computer Vision problem, directly practicing the dataset-design thinking this entire roadmap depends on.',
      steps: [
        'Choose one CV application idea (e.g., classifying fruit as ripe/unripe, detecting potholes in road photos, or segmenting clouds in sky photos)',
        'Decide which label type your task needs: classification, detection, or segmentation, and justify why',
        'Sketch a folder/label structure for your dataset (e.g., folder names for classification, or a description of what a bounding-box label file would contain for detection)',
        'Propose a train/validation/test split percentage for your dataset and briefly justify your reasoning',
        'Identify one realistic dataset quality risk for your specific idea (e.g., class imbalance between "ripe" and "unripe" fruit) and describe how you would check for it',
      ],
      expectedOutput:
          'Application: Classifying fruit as ripe or unripe\nLabel type: Classification (one label per image) - justified because we only need one answer per photo, not location or pixel detail\nFolder structure: dataset/ripe/... and dataset/unripe/...\nSplit: 70% train, 15% validation, 15% test\nQuality risk: Class imbalance if far more "ripe" photos were collected than "unripe" - would check by counting images in each folder before training',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'video_and_frames_l1',
    topicTitle: 'Introduction to Video and Frames',
    careerId: 'computer_vision_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 25,
    totalXp: 130,
    emoji: '🎥',
    intro:
        'Not every Computer Vision system works on a single still photo — self-driving cars, security cameras, and sports analytics all process live VIDEO. This lesson introduces how video is fundamentally just a sequence of images, directly extending everything you have learned about pixels and arrays into the time dimension.',
    concepts: [
      ConceptLesson(
        title: 'A Video is Just a Sequence of Images',
        definition:
            'A digital video is fundamentally a rapid sequence of individual still images, called frames, displayed one after another fast enough that human eyes perceive smooth motion.',
        analogy:
            'This is exactly like an old flip-book animation — each page is a slightly different still drawing, and flipping through the pages quickly creates the illusion of smooth movement. A video file is the exact same idea, just with photographic frames instead of hand-drawn pages.',
        example:
            'A typical video might have a "frame rate" of 30 FPS (frames per second), meaning:\n1 second of video = 30 individual still images shown in rapid sequence\n1 minute of video = 30 × 60 = 1,800 individual still images',
        keyTakeaway:
            'Since a video is just a sequence of images, and every image is a NumPy array (as you already know), a video is really just a sequence of NumPy arrays — everything you have learned about processing a single image directly applies to processing each individual frame.',
      ),
      ConceptLesson(
        title: 'Frame Rate (FPS) and Its Trade-offs',
        definition:
            'Frame Rate, measured in Frames Per Second (FPS), determines how many individual images are captured or displayed every second. Higher FPS gives smoother motion but requires processing far more images per second.',
        analogy:
            'Think of FPS like the number of photographs a rapid-fire camera takes every second of a moving object. More photographs per second capture motion more smoothly, but a Computer Vision system processing this video must now analyze that many more images every single second — a real computational cost.',
        example:
            'Common frame rates:\n• 24 FPS: standard cinema film\n• 30 FPS: standard web/TV video\n• 60 FPS: smooth gaming and sports footage\n\nA real-time object detector (Level 7, Level 9) processing 30 FPS video must fully analyze one frame in under 1/30th of a second (about 33 milliseconds) to keep up.',
        keyTakeaway:
            'This exact FPS-vs-processing-speed trade-off becomes critically important in Level 9\'s real-time inference lesson — a highly accurate but slow model may be technically useless for a live video application if it cannot process frames fast enough.',
      ),
      ConceptLesson(
        title: 'Reading Video with OpenCV',
        definition:
            'OpenCV provides a VideoCapture object that lets you read a video file or a live webcam feed frame-by-frame, returning each frame as the exact same kind of NumPy array you have already been working with.',
        analogy:
            'This is like being handed a flip-book and being able to request "give me the next page" one page at a time, rather than needing the entire book at once — VideoCapture lets your code process one frame, then request the next, in a simple loop.',
        example:
            'import cv2\n\ncap = cv2.VideoCapture("video.mp4")\nwhile True:\n    ret, frame = cap.read()   # ret = success flag, frame = the image\n    if not ret:\n        break   # No more frames\n    print(frame.shape)   # Same shape format as a single image!\ncap.release()',
        keyTakeaway:
            'Notice that cap.read() returns a ret (success/failure flag) exactly like the "check for None" pattern from the OpenCV lesson — always check ret before using a frame, since the very last read naturally fails once the video ends.',
        codeSnippet:
            'import cv2\n\ncap = cv2.VideoCapture("video.mp4")\nframe_count = 0\nwhile True:\n    ret, frame = cap.read()\n    if not ret:\n        break\n    frame_count += 1\ncap.release()\nprint(f"Total frames read: {frame_count}")',
      ),
      ConceptLesson(
        title: 'Reading a Live Webcam Feed',
        definition:
            'The exact same VideoCapture object can read a live webcam feed instead of a saved file, simply by passing a camera index (usually 0 for the default webcam) instead of a file path.',
        analogy:
            'This is like the difference between watching a pre-recorded flip-book versus watching someone draw new pages live, one at a time, as fast as they can — the reading mechanism (requesting "the next frame") stays exactly the same in both cases; only the source changes.',
        example:
            'import cv2\n\ncap = cv2.VideoCapture(0)   # 0 = default webcam\nwhile True:\n    ret, frame = cap.read()\n    if not ret:\n        break\n    cv2.imshow("Webcam", frame)\n    if cv2.waitKey(1) == ord("q"):\n        break\ncap.release()\ncv2.destroyAllWindows()',
        keyTakeaway:
            'This exact live-capture pattern is the direct foundation for every real-time CV application in this roadmap — a real-time face detector, a live object counter, or a video-based security system (Level 9) all begin with precisely this webcam-reading loop.',
        codeSnippet:
            'import cv2\n\ncap = cv2.VideoCapture(0)\nret, frame = cap.read()\nif ret:\n    print("Captured one frame, shape:", frame.shape)\ncap.release()',
      ),
      ConceptLesson(
        title: 'Extracting and Saving Individual Frames',
        definition:
            'It is often useful to extract specific individual frames from a video and save them as standalone images — for example, to build a labelled training dataset from recorded video footage.',
        analogy:
            'This is exactly like pausing a movie at a specific interesting moment and taking a screenshot of that single frame — instead of working with the whole flowing video, you now have one still photograph you can label, crop, or feed into a model exactly like any other image.',
        example:
            'import cv2\n\ncap = cv2.VideoCapture("video.mp4")\nframe_number = 0\nwhile True:\n    ret, frame = cap.read()\n    if not ret:\n        break\n    if frame_number % 30 == 0:   # Save every 30th frame (roughly once per second at 30 FPS)\n        cv2.imwrite(f"frame_{frame_number}.jpg", frame)\n    frame_number += 1\ncap.release()',
        keyTakeaway:
            'This technique — extracting one frame every N frames rather than every single frame — is exactly how many real-world CV training datasets (Level 3 onward) are actually built from recorded video footage, since saving and labelling EVERY frame would be extremely wasteful and repetitive.',
        codeSnippet:
            'import cv2\n\ncap = cv2.VideoCapture("video.mp4")\nsaved = 0\nframe_number = 0\nwhile True:\n    ret, frame = cap.read()\n    if not ret:\n        break\n    if frame_number % 30 == 0:\n        cv2.imwrite(f"frame_{saved}.jpg", frame)\n        saved += 1\n    frame_number += 1\ncap.release()\nprint(f"Saved {saved} frames")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is a video, fundamentally, at the pixel/array level?',
        options: [
          'A single very large image',
          'A rapid sequence of individual still images (frames), each one a NumPy array',
          'A type of audio file with no visual content',
          'A 3D model that has no relationship to 2D images'
        ],
        correctIndex: 1,
        explanation:
            'A video is fundamentally a rapid sequence of individual still frames, each one exactly the same kind of NumPy array you have already learned to work with for single images.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does a frame rate of 30 FPS mean?',
        options: [
          '30 total frames exist in the entire video, no matter its length',
          '30 individual frames are shown for every second of video',
          'The video is 30 seconds long',
          'The video file is 30 megabytes in size'
        ],
        correctIndex: 1,
        explanation:
            '30 FPS (Frames Per Second) means 30 individual still images are captured or displayed for every single second of video playback.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What does cv2.VideoCapture(0) do?',
        options: [
          'Opens a video file named "0"',
          'Opens the default webcam for a live video feed',
          'Deletes all previously opened videos',
          'Converts a video to grayscale'
        ],
        correctIndex: 1,
        explanation:
            'Passing 0 (instead of a file path) to cv2.VideoCapture() opens the default connected webcam, allowing frames to be read from a live feed rather than a saved video file.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why might a real-world CV project extract only every 30th frame from a video, rather than saving every single frame?',
        options: [
          'OpenCV is physically incapable of reading every frame',
          'Consecutive frames are usually extremely similar, so saving every single one would be wasteful and repetitive when building a labelled training dataset',
          'Saving every frame is illegal',
          'Videos only actually contain every 30th frame to begin with'
        ],
        correctIndex: 1,
        explanation:
            'Since consecutive video frames captured at 30 FPS are typically very similar to each other, sampling every Nth frame (rather than every single one) avoids wasteful redundancy when building a training dataset from video footage.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A real-time pedestrian detection system needs to process a live 30 FPS video feed without falling behind. What is the maximum time budget it has to process each individual frame?',
        options: [
          'Approximately 1 full second per frame',
          'Approximately 33 milliseconds per frame (1 second ÷ 30 frames)',
          'Approximately 1 minute per frame',
          'There is no time limit at all'
        ],
        correctIndex: 1,
        explanation:
            'To keep up with a 30 FPS feed in real time, a system must process each frame in roughly 1/30th of a second, which is about 33 milliseconds — otherwise, frames will pile up and the system falls behind the live feed.',
        xpReward: 15,
      ),
      MiniChallenge(
        prompt:
            'You call cap.read() in a loop to process a video file, but forget to check the ret value before using each frame. What will eventually happen?',
        options: [
          'Nothing; the loop will run forever safely',
          'When the video ends, read() will fail and frame will be invalid, likely causing an error when your code tries to process it',
          'The webcam will turn on automatically instead',
          'The video file will be permanently deleted'
        ],
        correctIndex: 1,
        explanation:
            'Just like checking "if image is None" after cv2.imread(), checking the ret flag after cap.read() is essential — once a video ends, read() returns False and an unusable frame, and skipping this check will cause errors.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build a Video Frame Extractor',
      goal:
          'Build a script that reads a video file and extracts a labelled sample of frames as individual images — directly practicing the exact technique used to build real-world video-based training datasets.',
      steps: [
        'Find or record a short video file (even a 10-20 second clip from your phone works)',
        'Write a script using cv2.VideoCapture() to open the video',
        'Loop through the video, checking ret on every read, and count the total number of frames',
        'Print the video\'s frame rate using cap.get(cv2.CAP_PROP_FPS)',
        'Save every 15th frame as a separate JPG file, numbering them sequentially',
        'Print a summary: total frames in the video, frame rate, and how many frames were saved',
      ],
      expectedOutput:
          'Video frame rate: 30.0 FPS\nTotal frames in video: 450\nFrames saved (every 15th): 30\n\nSaved files: frame_0.jpg, frame_1.jpg, ... frame_29.jpg',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'coordinates_and_annotations_l1',
    topicTitle: 'Coordinate Systems and Image Annotations',
    careerId: 'computer_vision_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 120,
    emoji: '📐',
    intro:
        'Every bounding box, keypoint, and mask you will work with from Level 7 onward depends on a solid understanding of how image coordinate systems work. This short but essential lesson makes sure that foundation is completely solid before you build anything more advanced.',
    concepts: [
      ConceptLesson(
        title: 'The Image Coordinate System',
        definition:
            'Unlike standard math graphs where the origin (0,0) is at the bottom-left and y increases upward, image coordinate systems place the origin (0,0) at the TOP-LEFT corner, with y increasing DOWNWARD.',
        analogy:
            'Think of reading a page of a book: you start at the top-left corner and read downward and rightward. Image coordinates follow this exact same "reading" convention — top-left is the starting point (0,0), moving right increases x, and moving down increases y.',
        example:
            'In a 640x480 image:\n• Top-left corner: (x=0, y=0)\n• Top-right corner: (x=639, y=0)\n• Bottom-left corner: (x=0, y=479)\n• Bottom-right corner: (x=639, y=479)\n• Exact center: (x=320, y=240)',
        keyTakeaway:
            'This top-left-origin, y-increases-downward convention is completely universal across OpenCV, most annotation tools, and nearly every CV library you will use — but it is the OPPOSITE of standard school math graphs, so it is worth deliberately re-training your intuition now.',
      ),
      ConceptLesson(
        title: 'Bounding Box Formats',
        definition:
            'A bounding box marks a rectangular region in an image (typically around a detected object), and can be represented in several different but equivalent numeric formats depending on the tool or dataset being used.',
        analogy:
            'This is like giving directions to a rectangular field in different but equally valid ways: "start here and go this far in each direction" versus "here is one corner and here is the opposite corner" — both describe the exact same rectangle, just using different reference points.',
        example:
            'Common bounding box formats:\n• (x_min, y_min, width, height): top-left corner plus size — e.g., (50, 30, 120, 100)\n• (x_min, y_min, x_max, y_max): top-left corner plus bottom-right corner — e.g., (50, 30, 170, 130)\n• Normalized (0 to 1): coordinates divided by image width/height, useful when image size varies',
        keyTakeaway:
            'You will encounter ALL of these formats across different datasets and libraries starting in Level 7\'s object detection lessons — recognizing that they describe the exact same rectangle, just measured differently, prevents a huge amount of beginner confusion.',
        codeSnippet:
            'def xywh_to_xyxy(x, y, w, h):\n    x_max = x + w\n    y_max = y + h\n    return x, y, x_max, y_max\n\nprint(xywh_to_xyxy(50, 30, 120, 100))   # (50, 30, 170, 130)',
      ),
      ConceptLesson(
        title: 'Drawing Annotations on Images',
        definition:
            'OpenCV provides simple functions for drawing shapes (rectangles, circles, lines) and text directly onto an image, which is exactly how bounding boxes and labels are visually displayed on top of detection results.',
        analogy:
            'This is like using a red marker pen directly on top of a printed photograph to circle an object and write its name next to it — cv2.rectangle() and cv2.putText() do exactly this, programmatically, in code.',
        example:
            'import cv2\n\nimage = cv2.imread("photo.jpg")\n# Draw a rectangle from (50,30) to (170,130), green color, thickness 2\ncv2.rectangle(image, (50, 30), (170, 130), (0, 255, 0), 2)\ncv2.putText(image, "cat", (50, 25), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)',
        keyTakeaway:
            'This exact drawing technique is precisely how you will visualize your object detection model\'s predictions starting in Level 7 — being comfortable with cv2.rectangle() and cv2.putText() now means visualizing detection results later will feel completely natural.',
        codeSnippet:
            'import cv2\nimport numpy as np\n\nimage = np.zeros((200, 200, 3), dtype=np.uint8)\ncv2.rectangle(image, (50, 30), (170, 130), (0, 255, 0), 2)\ncv2.putText(image, "object", (50, 25), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)\ncv2.imwrite("annotated.jpg", image)',
      ),
      ConceptLesson(
        title: 'Annotation File Formats',
        definition:
            'Labels for detection and segmentation datasets are usually stored in separate structured files (commonly JSON, XML, or plain text) alongside the images, following standard formats like COCO JSON or Pascal VOC XML, rather than being embedded inside the image file itself.',
        analogy:
            'This is like keeping a separate answer key document next to a stack of exam papers, rather than writing the answers directly onto each exam page — the label information stays cleanly separated from the raw image data, making it easy for different tools to read the exact same labels consistently.',
        example:
            'A simple COCO-style annotation for one image (simplified):\n{\n  "image": "cat001.jpg",\n  "annotations": [\n    {"category": "cat", "bbox": [50, 30, 120, 100]}\n  ]\n}\n\nThis JSON file lives separately from cat001.jpg, but references it by filename.',
        keyTakeaway:
            'Recognizing standard annotation formats like COCO JSON now means that when Level 7 introduces real object detection datasets, the label files will already look familiar rather than being a completely new, confusing format to decode.',
      ),
      ConceptLesson(
        title: 'Why Coordinate Mistakes Are a Common Source of Bugs',
        definition:
            'A very common category of Computer Vision bugs comes specifically from coordinate confusion — mixing up (x, y) with (row, column), mixing up different bounding box formats, or forgetting that image coordinates start at the top-left rather than the bottom-left.',
        analogy:
            'This is exactly like giving someone GPS directions using latitude/longitude in the wrong order — every individual number might be completely correct, but swapping their order sends someone to a completely wrong location. The exact same kind of subtle swap causes a huge share of real Computer Vision bugs.',
        example:
            'A very common bug: NumPy array indexing uses image[row, column] which is (y, x), but many CV functions expect coordinates as (x, y) — accidentally swapping these two conventions in the same script is one of the single most common sources of confusing, silent Computer Vision bugs.',
        keyTakeaway:
            'Whenever a bounding box, detection, or drawn shape appears in the completely wrong place in an image, the very first thing to check is whether an (x, y) vs (row, column) mixup, or a bounding box format mismatch, is the actual cause — a lesson that will save real debugging time throughout this entire roadmap.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Where is the origin (0,0) located in a standard image coordinate system?',
        options: [
          'Bottom-left corner',
          'Top-left corner',
          'Exact center',
          'Bottom-right corner'
        ],
        correctIndex: 1,
        explanation:
            'Image coordinate systems place the origin (0,0) at the TOP-LEFT corner, with x increasing to the right and y increasing DOWNWARD — the opposite of standard school math graphs.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What do the two bounding box formats (x_min, y_min, width, height) and (x_min, y_min, x_max, y_max) have in common?',
        options: [
          'They describe completely different, unrelated rectangles',
          'They describe the exact same rectangle, just measured using different reference points',
          'Only one of these formats is ever actually valid',
          'They can only be used with grayscale images'
        ],
        correctIndex: 1,
        explanation:
            'Both formats describe the exact same rectangular region — one measures using a width/height size, the other using an opposite-corner coordinate — and they can be mathematically converted between each other.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Which OpenCV function is used to draw a rectangle (like a bounding box) onto an image?',
        options: [
          'cv2.imread()',
          'cv2.resize()',
          'cv2.rectangle()',
          'cv2.VideoCapture()'
        ],
        correctIndex: 2,
        explanation:
            'cv2.rectangle() draws a rectangle directly onto an image array, which is exactly how bounding boxes are visually displayed on top of detection results.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is confusing (x, y) with (row, column) considered such a common source of Computer Vision bugs?',
        options: [
          'This confusion never actually happens in real projects',
          'NumPy indexing uses (row, column) which corresponds to (y, x), while many CV functions expect (x, y) — accidentally mixing these conventions silently swaps horizontal and vertical positions',
          'Computers cannot distinguish between rows and columns at all',
          'This confusion only affects audio processing, never images'
        ],
        correctIndex: 1,
        explanation:
            'NumPy array indexing follows (row, column), equivalent to (y, x), while many CV drawing and annotation functions expect (x, y) order — mixing these two conventions is a genuinely common, often silent, source of misplaced boxes and shapes.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'A bounding box is given as (x=50, y=30, width=120, height=100). What is its bottom-right corner in (x, y) coordinates?',
        options: ['(50, 30)', '(120, 100)', '(170, 130)', '(70, 70)'],
        correctIndex: 2,
        explanation:
            'The bottom-right corner is calculated as (x + width, y + height) = (50 + 120, 30 + 100) = (170, 130).',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build a Simple Bounding Box Visualizer',
      goal:
          'Write a script that draws a bounding box and label on an image from raw coordinates, directly practicing the annotation skills that Level 7\'s object detection work depends on.',
      steps: [
        'Create or load any image using OpenCV',
        'Manually define a bounding box in (x_min, y_min, width, height) format for any object or region in the image',
        'Write a function that converts this to (x_min, y_min, x_max, y_max) format',
        'Use cv2.rectangle() to draw the box using the converted coordinates',
        'Use cv2.putText() to add a label above the box',
        'Save and inspect the annotated image, confirming the box appears in the exact expected location',
      ],
      expectedOutput:
          'Original box (x, y, w, h): (100, 80, 150, 120)\nConverted box (x_min, y_min, x_max, y_max): (100, 80, 250, 200)\n\nSaved image "annotated_output.jpg" showing a green rectangle with the label "object" correctly positioned around the intended region.',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'cv_dev_environment_l1',
    topicTitle: 'Setting Up Your Computer Vision Development Environment',
    careerId: 'computer_vision_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 120,
    emoji: '🛠️',
    intro:
        'This final Level 1 lesson makes sure your actual development environment is properly set up — the right libraries installed, the right project structure in place — so that every future level in this roadmap can focus purely on Computer Vision concepts, without fighting your setup.',
    concepts: [
      ConceptLesson(
        title: 'Core Python Libraries for Computer Vision',
        definition:
            'A working Computer Vision environment needs a specific core set of Python libraries: NumPy (arrays), OpenCV (image/video processing), Pillow (simple image handling), and Matplotlib (visualizing images and results) form the essential foundation used throughout this entire roadmap.',
        analogy:
            'This is like a chef setting up their kitchen before cooking a single dish — the knives (NumPy), the stove (OpenCV), the mixing bowls (Pillow), and the plating tools (Matplotlib) all need to be in place BEFORE any real cooking (coding) can happen smoothly.',
        example:
            'pip install numpy opencv-python pillow matplotlib\n\nThese four libraries alone are enough to complete every single exercise in this Level 1, and they remain the foundation even as Levels 4+ add PyTorch and other deep learning libraries on top.',
        keyTakeaway:
            'Installing these libraries once, correctly, at the very start of this roadmap prevents dozens of small, frustrating setup interruptions later — treat this initial setup step as seriously as any of the conceptual lessons in this level.',
        codeSnippet:
            'import numpy as np\nimport cv2\nfrom PIL import Image\nimport matplotlib.pyplot as plt\n\nprint("NumPy version:", np.__version__)\nprint("OpenCV version:", cv2.__version__)\nprint("All core libraries imported successfully!")',
      ),
      ConceptLesson(
        title: 'Using Virtual Environments',
        definition:
            'A virtual environment is an isolated Python installation for a single project, keeping that project\'s specific library versions separate from other projects on the same computer, preventing version conflicts.',
        analogy:
            'A virtual environment is like giving each of your projects its own separate, clearly labelled toolbox, rather than throwing every tool from every project into one giant shared pile — when Project A needs an older screwdriver and Project B needs a newer one, having separate toolboxes avoids the two projects interfering with each other.',
        example:
            '# Create a virtual environment\npython -m venv cv_env\n\n# Activate it (Mac/Linux)\nsource cv_env/bin/activate\n\n# Activate it (Windows)\ncv_env\\Scripts\\activate\n\n# Now install libraries only inside this isolated environment\npip install numpy opencv-python',
        keyTakeaway:
            'As this roadmap progresses into Level 4\'s PyTorch and Level 7-9\'s more complex libraries, having a clean, isolated virtual environment specifically for this roadmap prevents version conflicts with any other Python projects you may already have on your computer.',
      ),
      ConceptLesson(
        title: 'Organizing a Computer Vision Project Folder',
        definition:
            'A well-organized CV project typically separates raw data, processing scripts, and outputs into distinct folders, making the project easy to navigate as it grows across the many hands-on projects in this roadmap.',
        analogy:
            'This is like organizing a real physical workshop with clearly labelled shelves — raw materials on one shelf, tools on another, finished products on a third — rather than piling everything randomly on the floor. A well-organized folder structure saves real time and confusion as a project grows.',
        example:
            'my_cv_project/\n  data/\n    raw_images/\n    processed_images/\n  scripts/\n    preprocess.py\n    train.py\n  outputs/\n    models/\n    results/\n  README.md',
        keyTakeaway:
            'Adopting this kind of consistent folder structure now, in Level 1, means your Level 7 detection capstone and Level 8 segmentation capstone projects will already have a natural, scalable home for their (much larger) datasets and outputs.',
      ),
      ConceptLesson(
        title: 'Using Jupyter Notebooks for CV Experimentation',
        definition:
            'Jupyter Notebooks are an interactive coding environment that let you run small chunks of code one at a time and immediately see results (including displayed images) inline — extremely useful for the kind of visual experimentation Computer Vision requires.',
        analogy:
            'A Jupyter Notebook is like a lab notebook where a scientist can run one small experiment, immediately see and record the visual result, and then decide on the next experiment — rather than needing to write, and re-run, an entire program from scratch every single time just to check one small change.',
        example:
            'In a Jupyter cell:\n\nimport cv2\nimport matplotlib.pyplot as plt\n\nimage = cv2.imread("photo.jpg")\nimage_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)\nplt.imshow(image_rgb)\nplt.show()   # The image displays directly inside the notebook',
        keyTakeaway:
            'Throughout this roadmap, Jupyter Notebooks are ideal for quickly experimenting with a single filter, testing one preprocessing function, or visually inspecting a model\'s prediction — while plain Python scripts remain better for final, production-style code (Level 9).',
        codeSnippet:
            '# Typical Jupyter Notebook cell for visually checking an image\nimport cv2\nimport matplotlib.pyplot as plt\n\nimg = cv2.cvtColor(cv2.imread("photo.jpg"), cv2.COLOR_BGR2RGB)\nplt.figure(figsize=(6, 6))\nplt.imshow(img)\nplt.axis("off")\nplt.title("My First CV Image")\nplt.show()',
      ),
      ConceptLesson(
        title: 'Verifying Your Setup with a Test Script',
        definition:
            'Before moving on to Level 2, it is good practice to run one small test script that imports every core library, loads a sample image, performs a basic operation, and confirms everything works correctly together.',
        analogy:
            'This is exactly like a pilot running through a pre-flight checklist before takeoff — confirming every single system works correctly individually, and together, BEFORE relying on all of them during the actual flight (in this case, before relying on your setup throughout the rest of this roadmap).',
        example:
            'A good test script should: 1) import all 4 core libraries without error, 2) load a real sample image, 3) print its shape, 4) perform one operation (like resizing), 5) display or save the result successfully.',
        keyTakeaway:
            'Running this exact verification now, at the true start of your journey, means every future level can assume a working environment and focus entirely on new Computer Vision concepts — exactly the mindset a professional CV Engineer brings to any new project setup.',
        codeSnippet:
            'import numpy as np\nimport cv2\nfrom PIL import Image\nimport matplotlib.pyplot as plt\n\ndef verify_setup(sample_image_path):\n    image = cv2.imread(sample_image_path)\n    assert image is not None, "Failed to load sample image"\n    resized = cv2.resize(image, (224, 224))\n    assert resized.shape == (224, 224, 3), "Resize did not work as expected"\n    print("Environment verified successfully! Ready for Level 2.")\n\nverify_setup("photo.jpg")',
      ),
    ],
    quiz: [
      QuizQuestion(
        question:
            'Which four core Python libraries form the essential foundation for this Computer Vision roadmap?',
        options: [
          'NumPy, OpenCV, Pillow, and Matplotlib',
          'Only OpenCV, with no other libraries needed',
          'Microsoft Word, Excel, PowerPoint, and Outlook',
          'HTML, CSS, JavaScript, and PHP'
        ],
        correctIndex: 0,
        explanation:
            'NumPy (arrays), OpenCV (image/video processing), Pillow (simple image handling), and Matplotlib (visualization) form the essential core library foundation used throughout this entire Computer Vision roadmap.',
        xpReward: 10,
      ),
      QuizQuestion(
        question: 'What is the main purpose of a virtual environment?',
        options: [
          'To make your code run inside a video game',
          'To keep a project\'s specific library versions isolated from other projects, preventing version conflicts',
          'To automatically write code for you',
          'To permanently delete unused Python libraries'
        ],
        correctIndex: 1,
        explanation:
            'A virtual environment creates an isolated Python installation for a single project, keeping its library versions separate from other projects and preventing version conflicts between them.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why are Jupyter Notebooks particularly well-suited for Computer Vision experimentation?',
        options: [
          'They cannot display images at all',
          'They let you run small chunks of code interactively and immediately see visual results (like displayed images) inline',
          'They only support the Java programming language',
          'They are exclusively used for writing essays, never code'
        ],
        correctIndex: 1,
        explanation:
            'Jupyter Notebooks allow interactive, chunk-by-chunk code execution with immediate visual feedback (including displaying images inline), making them ideal for the kind of visual experimentation Computer Vision work often requires.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is it valuable to run a small verification script confirming your setup BEFORE starting Level 2?',
        options: [
          'It has no real value and is a waste of time',
          'It confirms your environment works correctly now, so future levels can focus entirely on new Computer Vision concepts rather than debugging setup issues later',
          'Verification scripts are required by Python itself to run any code',
          'It permanently prevents any future errors of any kind'
        ],
        correctIndex: 1,
        explanation:
            'Verifying your environment works correctly at the start means you can trust your foundation throughout the rest of the roadmap, allowing every future level to focus purely on new Computer Vision concepts rather than unexpected setup problems.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You are about to start Level 4, which introduces PyTorch for the first time. Based on this lesson, what is the recommended practice before installing PyTorch?',
        options: [
          'Install PyTorch directly into your computer\'s global Python installation with no isolation',
          'Install PyTorch inside a dedicated virtual environment, keeping it isolated from other projects\' library versions',
          'Uninstall all previously installed libraries first',
          'PyTorch does not require any installation process at all'
        ],
        correctIndex: 1,
        explanation:
            'Following this lesson\'s virtual environment practice, new libraries like PyTorch (introduced in Level 4) should be installed inside a dedicated virtual environment, keeping this roadmap\'s dependencies cleanly isolated from other projects.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Set Up and Verify Your Complete CV Environment',
      goal:
          'Set up a properly isolated, organized Computer Vision development environment and confirm it works correctly with a verification script — the essential final step of Level 1 before moving on to Level 2.',
      steps: [
        'Create a new virtual environment specifically for this Computer Vision roadmap',
        'Activate the virtual environment and install numpy, opencv-python, pillow, and matplotlib inside it',
        'Create an organized project folder structure: data/, scripts/, and outputs/ subfolders',
        'Place one sample image inside data/',
        'Write a verify_setup() script (placed in scripts/) that imports all 4 libraries, loads the sample image, resizes it, and prints a success message',
        'Run the script and confirm it completes without any errors, printing "Environment verified successfully!"',
      ],
      expectedOutput:
          'my_cv_project/\n  data/sample.jpg\n  scripts/verify_setup.py\n  outputs/\n\nRunning verify_setup.py:\nEnvironment verified successfully! Ready for Level 2.',
      xpReward: 55,
    ),
  ),
  TopicCourse(
    id: 'image_noise_quality_l1',
    topicTitle: 'Understanding Image Noise and Quality',
    careerId: 'computer_vision_engineer',
    categoryId: 'ai_data',
    difficulty: 'Easy',
    estimatedMinutes: 20,
    totalXp: 120,
    emoji: '📶',
    intro:
        'This closing Level 1 lesson introduces image noise and quality — the real-world imperfections every CV Engineer must account for, directly setting up Level 2\'s filtering techniques, which exist specifically to clean up the kinds of noise you will learn to recognize here.',
    concepts: [
      ConceptLesson(
        title: 'What is Image Noise?',
        definition:
            'Image noise refers to random, unwanted variations in pixel brightness or color that do not represent the actual scene — tiny speckles or graininess introduced during capture, often caused by low light, cheap sensors, or high ISO camera settings.',
        analogy:
            'Noise is like static on an old radio broadcast — the actual music (the real image content) is still there underneath, but it is mixed with random crackling interference that has nothing to do with the song itself. Removing that static without ruining the music is exactly the challenge of denoising an image.',
        example:
            'A photo taken in a dark room with a phone camera often shows visible "grain" — small random light and dark speckles scattered across otherwise smooth areas like a wall or the sky. This speckling is classic image noise, not real detail.',
        keyTakeaway:
            'Noise is not "wrong" data to simply delete — it is unwanted random variation layered on top of real signal. Level 2\'s blurring filters are specifically designed to reduce this kind of noise while preserving the genuine underlying image content.',
      ),
      ConceptLesson(
        title: 'Common Causes of Poor Image Quality',
        definition:
            'Beyond noise, several other factors commonly degrade image quality for Computer Vision purposes: motion blur (from camera or subject movement), poor lighting (too dark or overexposed), and low resolution (not enough pixels to capture fine detail).',
        analogy:
            'This is like trying to read a book under different bad conditions: motion blur is like trying to read while the book is shaking, poor lighting is like reading in a dim room or with a light shining directly in your eyes, and low resolution is like trying to read text that is printed far too small and blurry to make out clearly.',
        example:
            'Motion blur: a photo of a moving car where the car appears streaked rather than sharp\nPoor lighting: a security camera photo taken at night, almost entirely black with no visible detail\nLow resolution: a heavily zoomed-in photo where individual pixels become visibly blocky',
        keyTakeaway:
            'A CV Engineer must recognize these real-world quality issues early, since a model trained only on clean, perfect images may perform poorly when deployed against genuinely messy, real-world camera footage — a concern that becomes especially important in Level 9\'s production deployment lessons.',
      ),
      ConceptLesson(
        title: 'Visually Inspecting Image Quality with Histograms',
        definition:
            'A histogram is a chart showing how many pixels in an image have each possible brightness value, and it is one of the simplest, fastest tools for spotting quality problems like poor lighting at a glance.',
        analogy:
            'A histogram is like a quick health check-up chart for an image — rather than needing to inspect every single pixel individually, one glance at the overall brightness distribution instantly reveals whether a photo is too dark (values clustered near 0), too bright (values clustered near 255), or has good contrast (values spread across the full range).',
        example:
            'A very dark, underexposed photo will have a histogram with most pixel values clustered near 0 (black).\nA very bright, overexposed photo will have most values clustered near 255 (white).\nA well-exposed photo typically shows values spread more evenly across the full 0-255 range.',
        keyTakeaway:
            'This histogram-based quality check directly previews Level 2\'s dedicated histogram and thresholding lesson, where you will learn to not just visualize but actively fix poor lighting and contrast problems using these exact same brightness distributions.',
        codeSnippet:
            'import cv2\nimport matplotlib.pyplot as plt\n\nimage = cv2.imread("photo.jpg", cv2.IMREAD_GRAYSCALE)\nplt.hist(image.ravel(), bins=256, range=(0, 255))\nplt.title("Pixel Brightness Distribution")\nplt.xlabel("Pixel Value")\nplt.ylabel("Count")\nplt.show()',
      ),
      ConceptLesson(
        title: 'Why Quality Matters for Model Training',
        definition:
            'Poor-quality images in a training dataset (excessive noise, blur, or bad lighting) can genuinely hurt a model\'s ability to learn correct patterns, since the model may accidentally learn to associate noise artifacts with a label rather than the true underlying object features.',
        analogy:
            'This is like trying to teach a student to recognize handwriting using photocopies that are so blurry and smudged that even a human struggles to read them — no matter how smart the student is, teaching from consistently poor-quality examples makes genuine learning significantly harder.',
        example:
            'If every single "night-time" labelled photo in a dataset happens to also be extremely noisy and dark, a model might partially learn "noisy and dark = night-time" as a shortcut — which could fail badly on a genuinely clean, well-lit night photo taken with better equipment.',
        keyTakeaway:
            'This concern connects directly to Level 3\'s discussion of dataset quality and Level 6\'s data augmentation techniques — recognizing quality issues now, in Level 1, builds the habit of always inspecting your data before assuming any model performance problem is purely about the model architecture itself.',
      ),
      ConceptLesson(
        title: 'A Simple Quality-Checking Workflow',
        definition:
            'Before using any collected images in a Computer Vision project, a simple manual and programmatic quality check — looking for extreme noise, blur, very poor lighting, or unusually low resolution — helps catch bad data early, before it silently affects the results of later training or evaluation stages.',
        analogy:
            'This is exactly like a quality-control inspector on an assembly line, checking each incoming batch of raw materials for obvious defects BEFORE they are used to build a finished product — catching problems at this early stage is always far cheaper and easier than discovering them after a huge amount of work has already been done downstream.',
        example:
            'A simple automated quality check might: 1) flag any image below a minimum resolution threshold, 2) compute a basic blur score (using image sharpness detection, introduced further in Level 2), 3) check the histogram for extreme over/under-exposure, and 4) generate a report listing suspicious images for manual review.',
        keyTakeaway:
            'This exact "inspect before you trust the data" workflow is a professional habit that pays off across this ENTIRE roadmap — from Level 3\'s classical ML datasets through Level 9\'s live production camera feeds, quality-checking incoming data early is a recurring, essential engineering discipline.',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'What is image noise?',
        options: [
          'The sound a camera makes when taking a photo',
          'Random, unwanted variations in pixel brightness or color that do not represent the actual scene',
          'A type of image file format',
          'The correct label assigned to an image'
        ],
        correctIndex: 1,
        explanation:
            'Image noise refers to random, unwanted pixel variations that do not represent genuine scene content — small speckles or graininess often introduced during capture, especially in low light.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'What does a histogram with most pixel values clustered near 0 typically indicate about a photo?',
        options: [
          'The photo is extremely overexposed and too bright',
          'The photo is underexposed and too dark',
          'The photo has perfect, ideal lighting',
          'The photo contains no pixels at all'
        ],
        correctIndex: 1,
        explanation:
            'A histogram with pixel values clustered near 0 (black) indicates most of the image is very dark, meaning the photo is likely underexposed.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why can poor-quality training images (excessive noise, blur, bad lighting) genuinely hurt a Computer Vision model\'s learning?',
        options: [
          'Poor-quality images always improve model performance',
          'The model may accidentally learn to associate noise or quality artifacts with a label, rather than the true underlying object features',
          'Model training completely ignores image quality by design',
          'Image quality only matters for human viewers, never for models'
        ],
        correctIndex: 1,
        explanation:
            'A model can inadvertently pick up on consistent quality artifacts (like noise or poor lighting) as a shortcut pattern associated with a label, rather than learning the genuine, generalizable object features — hurting real-world performance.',
        xpReward: 10,
      ),
      QuizQuestion(
        question:
            'Why is checking data quality early in a project considered good professional practice?',
        options: [
          'It has no real benefit and wastes time',
          'Catching data quality problems early is far cheaper and easier than discovering them after significant downstream work (training, evaluation) has already been done',
          'Quality checking is only relevant after a model has already been fully trained',
          'Data quality can only ever be checked manually, never programmatically'
        ],
        correctIndex: 1,
        explanation:
            'Just like a quality-control inspection on an assembly line, catching data problems early — before they propagate into training and evaluation — saves significant time and prevents wasted downstream effort.',
        xpReward: 10,
      ),
    ],
    challenges: [
      MiniChallenge(
        prompt:
            'You inspect a batch of security camera photos and notice a histogram with almost all pixel values clustered near 255. What does this most likely indicate?',
        options: [
          'The photos are underexposed and too dark',
          'The photos are overexposed and too bright, likely washed out',
          'The photos have perfect exposure',
          'The camera captured no image data at all'
        ],
        correctIndex: 1,
        explanation:
            'Pixel values clustered near 255 (white) indicate the image is overexposed — too bright, likely washed out with lost detail in the brighter regions.',
        xpReward: 15,
      ),
    ],
    finalProject: FinalProject(
      title: 'Build a Basic Image Quality Checker',
      goal:
          'Write a script that programmatically flags potential quality issues in a folder of images, directly practicing the quality-control workflow this lesson introduces.',
      steps: [
        'Gather 5-10 sample images, deliberately including at least one that is very dark, very bright, or low resolution',
        'Write a function that loads each image and checks its resolution against a minimum threshold (e.g., flag anything below 200x200)',
        'For each image, compute a grayscale histogram and check what percentage of pixels fall in the very dark (0-20) or very bright (235-255) range',
        'Flag any image where more than 60% of pixels fall into either extreme range as "possible exposure problem"',
        'Print a summary report listing each image and any flags raised for it',
      ],
      expectedOutput:
          'Checking 8 images...\nphoto_01.jpg: OK\nphoto_02.jpg: FLAGGED - possible exposure problem (78% dark pixels)\nphoto_03.jpg: FLAGGED - below minimum resolution (150x150)\nphoto_04.jpg: OK\n...\n\nSummary: 6 images passed, 2 images flagged for review.',
      xpReward: 55,
    ),
  ),
];
