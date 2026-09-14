import 'extended_models.dart';

final List<SalaryInfo> _salaryData = [
  const SalaryInfo(
    country: 'India',
    role: 'AI Engineer',
    minSalary: 600000,
    medianSalary: 1200000,
    maxSalary: 2500000,
    currency: '₹',
  ),
  const SalaryInfo(
    country: 'USA',
    role: 'AI Engineer',
    minSalary: 100000,
    medianSalary: 150000,
    maxSalary: 250000,
    currency: '\$',
  ),
];

List<String> getSalaryCountries() {
  return _salaryData.map((e) => e.country).toSet().toList();
}

List<String> getSalaryRoles() {
  return _salaryData.map((e) => e.role).toSet().toList();
}

Map<String, List<SalaryInfo>> getSalaryByCountry() {
  final Map<String, List<SalaryInfo>> data = {};

  for (final salary in _salaryData) {
    data.putIfAbsent(salary.country, () => []);
    data[salary.country]!.add(salary);
  }

  return data;
}

Map<String, List<SalaryInfo>> getSalaryByRole() {
  final Map<String, List<SalaryInfo>> data = {};

  for (final salary in _salaryData) {
    data.putIfAbsent(salary.role, () => []);
    data[salary.role]!.add(salary);
  }

  return data;
}