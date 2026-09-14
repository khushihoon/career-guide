// ════════════════════════════════════════════════════════════════════
// SALARY EXPLORER SCREEN - Compare salaries worldwide
// Keep existing navigation structure
// ════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../salary_data.dart';
import '../extended_models.dart';

class SalaryExplorerScreen extends StatefulWidget {
  const SalaryExplorerScreen({Key? key}) : super(key: key);

  @override
  State<SalaryExplorerScreen> createState() => _SalaryExplorerScreenState();
}

class _SalaryExplorerScreenState extends State<SalaryExplorerScreen> {
  late List<String> countries;
  late List<String> roles;
  String? selectedCountry;
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    countries = getSalaryCountries();
    roles = getSalaryRoles();
    selectedCountry = countries.first;
    selectedRole = roles.first;
  }

  @override
  Widget build(BuildContext context) {
    final salaryByCountry = getSalaryByCountry();
    final currentSalaries = salaryByCountry[selectedCountry] ?? [];
    final filteredSalaries = selectedRole == null
        ? currentSalaries
        : currentSalaries.where((s) => s.role == selectedRole).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0F0F1A),
        title: const Text('Salary Explorer'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Selector
            _buildSelectorSection(
              title: 'Select Country',
              items: countries,
              selectedItem: selectedCountry,
              onChanged: (value) {
                setState(() => selectedCountry = value);
              },
            ),

            const SizedBox(height: 20),

            // Role Selector
            _buildSelectorSection(
              title: 'Select Role',
              items: roles,
              selectedItem: selectedRole,
              onChanged: (value) {
                setState(() => selectedRole = value);
              },
            ),

            const SizedBox(height: 24),

            // Salary Cards
            Text(
              'Salary Range in $selectedCountry',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (filteredSalaries.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: const Text(
                  'No salary data available',
                  style: TextStyle(
                    color: Color(0xFF888899),
                    fontSize: 14,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredSalaries.length,
                itemBuilder: (context, index) {
                  final salary = filteredSalaries[index];
                  return _buildSalaryCard(salary);
                },
              ),

            const SizedBox(height: 24),

            // Comparison Table
            _buildComparisonSection(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorSection({
    required String title,
    required List<String> items,
    required String? selectedItem,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF2A2A40)),
          ),
          child: DropdownButton<String>(
            value: selectedItem,
            isExpanded: true,
            underline: Container(),
            dropdownColor: const Color(0xFF1A1A2E),
            style: const TextStyle(color: Colors.white),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSalaryCard(SalaryInfo salary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                salary.role,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${salary.currency}${_formatNumber(salary.medianSalary)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Min',
                    style: TextStyle(
                      color: Color(0xFF888899),
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    '${salary.currency}${_formatNumber(salary.minSalary)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Range',
                      style: TextStyle(
                        color: Color(0xFF888899),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        minHeight: 6,
                        backgroundColor: const Color(0xFF2A2A40),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getSalaryColor(salary.medianSalary, salary.minSalary, salary.maxSalary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Max',
                    style: TextStyle(
                      color: Color(0xFF888899),
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    '${salary.currency}${_formatNumber(salary.maxSalary)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonSection() {
    final salaryByRole = getSalaryByRole();
    final roleData = salaryByRole[selectedRole] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Global Comparison',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A40)),
          ),
          child: Column(
            children: roleData
                .map((salary) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            salary.country,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${salary.currency}${_formatNumber(salary.medianSalary)}',
                                style: const TextStyle(
                                  color: Color(0xFF7C3AED),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 60,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A40),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: _getNormalizedValue(salary.medianSalary, roleData),
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _getSalaryColor(salary.medianSalary, 0, 1000000),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Color _getSalaryColor(int value, int min, int max) {
    if (value >= (min + max) / 1.5) return const Color(0xFF4ADE80);
    if (value >= (min + max) / 2) return const Color(0xFF7C3AED);
    return const Color(0xFFA78BFA);
  }

  double _getNormalizedValue(int value, List<SalaryInfo> all) {
    if (all.isEmpty) return 0;
    final max = all.map((s) => s.maxSalary).reduce((a, b) => a > b ? a : b);
    return (value / max).clamp(0, 1);
  }
}