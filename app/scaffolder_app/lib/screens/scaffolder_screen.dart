import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/app_config.dart';

class ScaffolderScreen extends StatefulWidget {
  const ScaffolderScreen({super.key});

  @override
  State<ScaffolderScreen> createState() => _ScaffolderScreenState();
}

class _ScaffolderScreenState extends State<ScaffolderScreen> {
  static const _steps = [
    'Project Basics',
    'Core Features',
    'Review & Generate',
  ];

  static const _featureOptions = [
    _FeatureOption(
      key: 'state_management',
      title: 'State Management',
      description: 'Ship a starter setup for scaling screens and shared state.',
      icon: Icons.hub_outlined,
    ),
    _FeatureOption(
      key: 'api_client',
      title: 'API Client',
      description: 'Add a networking layer with service and model structure.',
      icon: Icons.cloud_sync_outlined,
    ),
    _FeatureOption(
      key: 'local_storage',
      title: 'Local Storage',
      description: 'Prepare persistence for tokens, settings, and cached data.',
      icon: Icons.sd_storage_outlined,
    ),
    _FeatureOption(
      key: 'notifications',
      title: 'Notifications',
      description:
          'Set up push notification hooks and app messaging entry points.',
      icon: Icons.notifications_active_outlined,
    ),
    _FeatureOption(
      key: 'analytics',
      title: 'Analytics',
      description:
          'Create places to track funnels, screens, and engagement events.',
      icon: Icons.insights_outlined,
    ),
    _FeatureOption(
      key: 'testing_setup',
      title: 'Testing Setup',
      description:
          'Start with widget and unit testing folders plus sample coverage.',
      icon: Icons.rule_folder_outlined,
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Set<String> _selectedFeatures = {'state_management', 'api_client'};

  bool _authEnabled = true;
  bool _darkModeEnabled = true;
  bool _isGenerating = false;
  int _currentStep = 0;
  String? _generatedProject;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  AppConfig get _config => AppConfig(
    name: _nameController.text.trim(),
    description: _descriptionController.text.trim(),
    auth: _authEnabled,
    darkMode: _darkModeEnabled,
    selectedFeatures: _selectedFeatures.toList()..sort(),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF4F1EA), Color(0xFFF8FBF8), Color(0xFFE3F0EC)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 920;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 1180,
                      minHeight: constraints.maxHeight - 48,
                    ),
                    child: compact
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeroPanel(theme, compact: true),
                              const SizedBox(height: 20),
                              _buildWorkspaceCard(theme),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: _buildHeroPanel(theme, compact: false),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 6,
                                child: _buildWorkspaceCard(theme),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeroPanel(ThemeData theme, {required bool compact}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF10362E),
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2610362E),
                blurRadius: 28,
                offset: Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x26FFFFFF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Flutter AI Scaffolder',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Build a cleaner starter app before you write the first screen.',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Set the app basics, choose the foundations you want included, and generate a project with a clearer starting point.',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFFDCEAE5),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  _HighlightChip(label: 'Guided 3-step flow'),
                  _HighlightChip(label: 'Feature-ready config'),
                  _HighlightChip(label: 'Clean project handoff'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFD8E6E0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Options worth adding next',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF163A33),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'These are strong additions for a more production-ready starter.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF50655F),
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _featureOptions
                    .map(
                      (option) => Chip(
                        label: Text(option.title),
                        avatar: Icon(
                          option.icon,
                          size: 18,
                          color: const Color(0xFF0E6B5C),
                        ),
                        backgroundColor: const Color(0xFFF4FAF7),
                        side: const BorderSide(color: Color(0xFFD6E8E1)),
                      ),
                    )
                    .toList(),
              ),
              if (!compact) ...[
                const SizedBox(height: 18),
                const Divider(color: Color(0xFFE4ECE8)),
                const SizedBox(height: 18),
                Text(
                  'Good follow-ups after this UI pass: app icon generation, environment flavors, localization, CI/CD, and package architecture presets.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF5E736D),
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkspaceCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.93),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 30,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Builder',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF17342F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A cleaner scaffold setup with better defaults and clearer option review.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF5E726C),
            ),
          ),
          const SizedBox(height: 24),
          _buildStepIndicator(theme),
          const SizedBox(height: 28),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _buildCurrentStep(theme),
          ),
          const SizedBox(height: 28),
          _buildFooterActions(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(ThemeData theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(_steps.length, (index) {
        final active = index == _currentStep;
        final completed = index < _currentStep;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF10362E)
                : completed
                ? const Color(0xFFE4F2ED)
                : const Color(0xFFF4F5F3),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: active ? const Color(0xFF10362E) : const Color(0xFFE0E7E3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: active
                    ? const Color(0xFFFFF3D6)
                    : completed
                    ? const Color(0xFF0E6B5C)
                    : Colors.white,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: active
                        ? const Color(0xFF7A4A00)
                        : completed
                        ? Colors.white
                        : const Color(0xFF6D7F7A),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _steps[index],
                style: theme.textTheme.titleSmall?.copyWith(
                  color: active ? Colors.white : const Color(0xFF17342F),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCurrentStep(ThemeData theme) {
    return KeyedSubtree(
      key: ValueKey(_currentStep),
      child: switch (_currentStep) {
        0 => _buildBasicsStep(theme),
        1 => _buildFeaturesStep(theme),
        _ => _buildReviewStep(theme),
      },
    );
  }

  Widget _buildBasicsStep(ThemeData theme) {
    final packageName = _formatPackageName(_nameController.text);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Start with the app identity',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF17342F),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'We will use this info to label the scaffold and prepare the generated project metadata.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF5E726C),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'App name',
              hintText: 'Expense Pilot',
            ),
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'App name is required.';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText:
                  'A modern finance tracker with authentication and analytics.',
            ),
            minLines: 3,
            maxLines: 4,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAF8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE1EAE6)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF0E6B5C)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Package preview: ${packageName.isEmpty ? 'your_app_name' : packageName}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF29453F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesStep(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 700;
        final selectedTitles = _featureOptions
            .where((option) => _selectedFeatures.contains(option.key))
            .map((option) => option.title)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose the starter foundations',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF17342F),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Core switches control the current scaffold. The add-ons below help us shape what the generator can support next.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF5E726C),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            if (stacked) ...[
              _buildToggleCard(
                title: 'Authentication',
                subtitle: 'Start with a login flow and guarded app entry points.',
                value: _authEnabled,
                icon: Icons.lock_outline_rounded,
                onChanged: (value) => setState(() => _authEnabled = value),
              ),
              const SizedBox(height: 16),
              _buildToggleCard(
                title: 'Dark Mode',
                subtitle:
                    'Prepare theme structure for light and dark presentation.',
                value: _darkModeEnabled,
                icon: Icons.dark_mode_outlined,
                onChanged: (value) => setState(() => _darkModeEnabled = value),
              ),
            ] else
              Row(
                children: [
                  Expanded(
                    child: _buildToggleCard(
                      title: 'Authentication',
                      subtitle:
                          'Start with a login flow and guarded app entry points.',
                      value: _authEnabled,
                      icon: Icons.lock_outline_rounded,
                      onChanged: (value) => setState(() => _authEnabled = value),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildToggleCard(
                      title: 'Dark Mode',
                      subtitle:
                          'Prepare theme structure for light and dark presentation.',
                      value: _darkModeEnabled,
                      icon: Icons.dark_mode_outlined,
                      onChanged: (value) =>
                          setState(() => _darkModeEnabled = value),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Suggested add-ons',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF17342F),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F7F5),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFD7E5DF)),
                  ),
                  child: Text(
                    '${selectedTitles.length} selected',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF245149),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Users can select extra options like State Management, API Client, Local Storage, Notifications, Analytics, and Testing Setup.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF5E726C),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: _featureOptions
                  .map(
                    (option) => _buildFeatureOptionCard(
                      option: option,
                      selected: _selectedFeatures.contains(option.key),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAF9),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2EBE7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected add-ons',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF17342F),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (selectedTitles.isEmpty)
                    Text(
                      'No add-ons selected yet. Pick the foundations you want in the generated app.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6A7D78),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: selectedTitles
                          .map(
                            (title) => Chip(
                              label: Text(title),
                              backgroundColor: const Color(0xFFEAF6F1),
                              side: const BorderSide(
                                color: Color(0xFFCFE5DA),
                              ),
                              labelStyle: const TextStyle(
                                color: Color(0xFF1E4A42),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReviewStep(ThemeData theme) {
    final config = _config;
    final description = config.description.isEmpty
        ? 'No description added yet.'
        : config.description;
    final selectedTitles = _featureOptions
        .where((option) => config.selectedFeatures.contains(option.key))
        .map((option) => option.title)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review before generating',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF17342F),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'This is the final snapshot we send to the generator.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF5E726C),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAF9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2EBE7)),
          ),
          child: Column(
            children: [
              _SummaryRow(
                label: 'App name',
                value: config.name.isEmpty ? 'Not set' : config.name,
              ),
              const SizedBox(height: 14),
              _SummaryRow(label: 'Description', value: description),
              const SizedBox(height: 14),
              _SummaryRow(
                label: 'Authentication',
                value: config.auth ? 'Enabled' : 'Disabled',
              ),
              const SizedBox(height: 14),
              _SummaryRow(
                label: 'Dark mode',
                value: config.darkMode ? 'Enabled' : 'Disabled',
              ),
              const SizedBox(height: 14),
              _SummaryRow(
                label: 'Add-ons',
                value: selectedTitles.isEmpty
                    ? 'None selected'
                    : selectedTitles.join(', '),
              ),
            ],
          ),
        ),
        if (_generatedProject != null) ...[
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F6EE),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFC7E7D5)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF0E6B5C),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Project generated successfully: $_generatedProject',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF17443C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFooterActions() {
    final onLastStep = _currentStep == _steps.length - 1;

    return Row(
      children: [
        if (_currentStep > 0)
          OutlinedButton(
            onPressed: _isGenerating ? null : _goBack,
            child: const Text('Back'),
          ),
        if (_currentStep > 0) const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: _isGenerating
                ? null
                : onLastStep
                ? _generateProject
                : _goNext,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: _isGenerating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    )
                  : Text(onLastStep ? 'Generate Project' : 'Continue'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: value ? const Color(0xFFF3FBF7) : const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: value ? const Color(0xFFB8DEC8) : const Color(0xFFE2EBE7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: value ? const Color(0xFFDFF2E8) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFF0E6B5C)),
              ),
              const Spacer(),
              Switch(value: value, onChanged: onChanged),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF17342F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF5E726C), height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureOptionCard({
    required _FeatureOption option,
    required bool selected,
  }) {
    return SizedBox(
      width: 250,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          setState(() {
            if (selected) {
              _selectedFeatures.remove(option.key);
            } else {
              _selectedFeatures.add(option.key);
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF10362E) : const Color(0xFFF7FAF8),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected
                  ? const Color(0xFF10362E)
                  : const Color(0xFFE1EAE6),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0x26FFFFFF) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      option.icon,
                      color: selected ? Colors.white : const Color(0xFF0E6B5C),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    selected ? Icons.check_circle : Icons.add_circle_outline,
                    color: selected
                        ? const Color(0xFFFFD67B)
                        : const Color(0xFF84A198),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                option.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : const Color(0xFF17342F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                option.description,
                style: TextStyle(
                  color: selected
                      ? const Color(0xFFDCEAE5)
                      : const Color(0xFF5E726C),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goNext() {
    if (_currentStep == 0 && !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _currentStep += 1;
      _generatedProject = null;
    });
  }

  void _goBack() {
    setState(() {
      _currentStep -= 1;
      _generatedProject = null;
    });
  }

  Future<void> _generateProject() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _currentStep = 0);
      _formKey.currentState?.validate();
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_config.toJson()),
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (!mounted) {
        return;
      }

      if (response.statusCode >= 400) {
        throw Exception(body['error'] ?? 'Unable to generate project.');
      }

      setState(() {
        _generatedProject = body['project'] as String?;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project generated successfully.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Generation failed: $error')));
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  String _formatPackageName(String input) {
    final normalized = input
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    return normalized;
  }
}

class _FeatureOption {
  const _FeatureOption({
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String key;
  final String title;
  final String description;
  final IconData icon;
}

class _HighlightChip extends StatelessWidget {
  const _HighlightChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF68807A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF17342F),
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
