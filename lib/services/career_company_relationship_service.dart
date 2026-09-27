import '../models/home_market_models.dart';

/// Step 6D — Career ↔ Company relationship layer.
///
/// These are curated REFERENCE relationships between a career family and
/// companies that are relevant to that career. They are not live hiring
/// signals. Current openings, verified skills, and salary remain separate
/// data concerns and must come from verified sources later.
class CareerCompanyRelationshipService {
  const CareerCompanyRelationshipService();

  static const Map<String, List<String>> _careerToCompanyNames = {
    'software engineer': ['Google', 'Microsoft', 'Amazon', 'Apple', 'Adobe'],
    'web developer': ['Google', 'Microsoft', 'Amazon', 'Adobe'],
    'ai engineer': ['Google', 'Microsoft', 'Amazon', 'NVIDIA', 'OpenAI', 'Meta'],
    'ml engineer': ['Google', 'Microsoft', 'Amazon', 'NVIDIA', 'OpenAI', 'Meta'],
    'data scientist': ['Google', 'Microsoft', 'Amazon', 'Adobe', 'Uber'],
    'nlp engineer': ['Google', 'Microsoft', 'Amazon', 'OpenAI', 'Meta'],
    'computer vision engineer': ['Google', 'NVIDIA', 'Tesla', 'Amazon'],
    'prompt engineer': ['OpenAI', 'Microsoft', 'Google', 'Amazon'],
    'ai researcher': ['OpenAI', 'Google', 'Microsoft', 'NVIDIA', 'Meta'],
    'ai product manager': ['Google', 'Microsoft', 'Amazon', 'Adobe', 'OpenAI'],
    'llm engineer': ['OpenAI', 'Google', 'Microsoft', 'NVIDIA', 'Meta', 'Amazon'],
    'robotics engineer': ['Amazon', 'NVIDIA', 'Tesla', 'Google'],
    'mlops / ai infrastructure': ['Google', 'Microsoft', 'Amazon', 'NVIDIA', 'OpenAI'],
    'ai security': ['Microsoft', 'Google', 'Amazon', 'Apple', 'NVIDIA'],
    'data engineer': ['Google', 'Microsoft', 'Amazon', 'Adobe', 'Uber'],
  };

  List<HomeCompany> companiesForCareer(
    HomeCareer career,
    List<HomeCompany> companies,
  ) {
    final wanted = _careerToCompanyNames[_key(career.title)] ?? const <String>[];
    return _resolveCompanies(wanted, companies);
  }

  List<HomeCareer> careersForCompany(
    HomeCompany company,
    List<HomeCareer> careers,
  ) {
    final companyKey = _key(company.name);
    final result = <HomeCareer>[];

    for (final career in careers) {
      final names = _careerToCompanyNames[_key(career.title)] ?? const <String>[];
      if (names.any((name) => _key(name) == companyKey)) {
        result.add(career);
      }
    }

    return result;
  }

  static List<HomeCompany> _resolveCompanies(
    List<String> wanted,
    List<HomeCompany> companies,
  ) {
    final wantedKeys = wanted.map(_key).toSet();
    final result = <HomeCompany>[];

    for (final company in companies) {
      if (wantedKeys.contains(_key(company.name)) &&
          !result.any((item) => _key(item.name) == _key(company.name))) {
        result.add(company);
      }
    }

    return result;
  }

  static String _key(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}
