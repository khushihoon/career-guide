/// Career Guide — Company Verification Queue
///
/// This file centralizes the relationship-layer companies that have NOT yet
/// been promoted to the verified company registry.
///
/// PURPOSE:
/// - Preserve the whole relationship-layer scope across verification batches
///   so nothing is silently lost.
/// - Make it explicit which companies still require official-source evidence.
///
/// AUTHORITY (locked):
/// - `verified_company_data.dart` is the authoritative registry for canonical
///   company identity and verified reference intelligence.
/// - This queue is WORKFLOW data only. It never overrides the registry and is
///   never used to decide what is shown as verified.
/// - On any conflict, the registry wins and this queue is reconciled to it.
/// - `sourceChecked` in `company_reference_registry.dart` is evidence metadata,
///   not an authority. A company with `sourceChecked: true` can still be
///   pending here until its details are promoted to the verified registry.
///
/// RULES:
/// - Membership in this queue means PENDING_VERIFICATION, not verified.
/// - Do not add skills/technologies/roles for queued companies.
/// - Do not create fake profiles to "complete" the queue.
/// - Move an entry out of this queue only when official evidence has been
///   verified and the company has been added to verified_company_data.dart.
///
/// REGISTRY CONSISTENCY:
/// - This file must NOT contain any company that already exists in
///   verified_company_data.dart.
/// - Every Home / relationship-layer company that does NOT resolve to a
///   verified profile must appear here.
///
/// COUNTS (Home directory = 101 relationship-layer companies):
/// - 33 resolve to a verified profile: OpenAI, Google DeepMind, Cursor,
///   Replit, Cognition AI, Salesforce Einstein, ServiceNow AI, Anthropic,
///   LangChain, Gamma, Typeface, Synthesia, Together AI, Cerebras Systems,
///   SambaNova Systems, AI21 Labs, Groq, Replicate, Tempus AI, Recursion
///   Pharmaceuticals, Insilico Medicine, Cleanlab, Sarvam AI, Sakana AI,
///   DataRobot, Microsoft AI, Luma AI, Letta (MemGPT), Harvey AI, Pinecone,
///   and (via approved aliases, 2026-10-08) Notion AI, Meta AI, Suno AI.
/// - 68 are pending (this list).
/// - The verified registry also holds profiles for Microsoft, NVIDIA, Amazon
///   and Apple, which are not Home directory entries.
///
/// This file is REFERENCE data about verification status.
/// It is NOT skill evidence and NOT live hiring data.
class CompanyVerificationQueue {
  CompanyVerificationQueue._();

  /// Relationship-layer companies still awaiting official-source verification.
  ///
  /// Re-queued companies (previously claimed as verified with sources that
  /// were not actually reviewed):
  ///   - Scale AI
  ///   - Tabnine
  ///   - Codeium
  ///   - ElevenLabs
  ///   - Mistral AI
  ///   - xAI
  static const List<String> pending = <String>[
    // -----------------------------------------------------------------------
    // Relationship-layer companies awaiting verification
    // -----------------------------------------------------------------------
    // Approved product aliases whose PARENT has no verified profile yet
    // (GitHub (Copilot) → GitHub, Adobe Firefly → Adobe, Canva AI → Canva,
    //  Duolingo Max → Duolingo, Khanmigo → Khan Academy, Tesla AI → Tesla):
    // they stay pending until the parent company is verified.
    'GitHub (Copilot)',
    'Adobe Firefly', // relationship-only; Adobe NOT registered (no evidence)
    'Canva AI',
    'Grammarly',
    'Hugging Face',
    'LlamaIndex',
    'Perplexity AI',
    'You.com',
    'Writer',
    'Jasper AI',
    'Tome',
    'Udio',
    'Descript',
    'Cohere',
    'Aleph Alpha',
    'DeepSeek',
    'Baidu AI',
    'Alibaba DAMO',
    'Zhipu AI',
    'Moonshot AI',
    'Krutrim',
    'Weights & Biases',
    'Modal',
    'Casetext',
    'Ayasdi',
    'Gong.io',
    'Sprinklr AI',
    'Fireflies.ai',
    'Neets AI',
    'Figure AI',
    '1X Technologies',
    'Boston Dynamics',
    'Runway',
    'Twelve Labs',
    'CrewAI',
    'Dust.tt',
    'Imbue',
    'Inflection AI',
    'Adept AI',
    'Khanmigo (Khan Academy)',
    'Duolingo Max',
    'Moveworks',
    'Darktrace',
    'CrowdStrike',
    'SentinelOne',
    'Otter.ai',
    'Weaviate',
    'Chroma',
    'Coreweave',
    'Kensho Technologies',
    'Alphasense',
    'Tesla AI',
    'Waymo',
    'Midjourney',
    'Stability AI',
    'Pika Labs',
    'Glean',
    'Abridge',
    'Haptik',
    'Vernacular.ai',
    'Yellow.ai',
    'Observe.AI',

    // -----------------------------------------------------------------------
    // Re-queued: previously claimed as verified with sources not reviewed
    // -----------------------------------------------------------------------
    'Scale AI',
    'Tabnine',
    'Codeium',
    'ElevenLabs',
    'Mistral AI',
    'xAI',
  ];

  static int get pendingCount => pending.length;

  static bool isPending(String name) {
    final normalized = _normalize(name);
    for (final item in pending) {
      if (_normalize(item) == normalized) return true;
    }
    return false;
  }

  static String _normalize(String value) => value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
}
