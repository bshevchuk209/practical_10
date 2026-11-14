import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorSchemeSeed: const Color(0xff345d87),
      useMaterial3: true,
    ),
    home: const EditorPage(),
  );
}

enum PreviewResult { ok, cancel }

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});
  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final formKey = GlobalKey<FormState>();
  final text = TextEditingController(text: 'Шевчук Богдан, 32-IST');
  final size = TextEditingController(text: '24');
  @override
  void dispose() {
    text.dispose();
    size.dispose();
    super.dispose();
  }

  Future<void> preview() async {
    if (!formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result = await Navigator.push<PreviewResult>(
      context,
      MaterialPageRoute(
        builder: (_) => PreviewPage(
          text: text.text,
          size: double.parse(size.text.replaceAll(',', '.')),
        ),
      ),
    );
    if (!mounted) return;
    final message = switch (result) {
      PreviewResult.ok => 'Cool!',
      PreviewResult.cancel => 'Let’s try something else.',
      null => "Don't know what to say.",
    };
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Результат перегляду'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрити'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Практична №10 • Навігація')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Текст для перегляду',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                key: const ValueKey('text'),
                controller: text,
                minLines: 2,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Текст',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Введіть текст'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const ValueKey('size'),
                controller: size,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Розмір шрифту',
                  helperText: 'Від 8 до 96',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final number = double.tryParse(
                    (value ?? '').replaceAll(',', '.'),
                  );
                  return number == null ||
                          !number.isFinite ||
                          number < 8 ||
                          number > 96
                      ? 'Введіть число від 8 до 96'
                      : null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const ValueKey('open'),
                onPressed: preview,
                child: const Text('Попередній перегляд'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key, required this.text, required this.size});
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Попередній перегляд')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    text,
                    key: const ValueKey('previewText'),
                    style: TextStyle(fontSize: size),
                  ),
                ),
              ),
            ),
            Text('Розмір шрифту: $size'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, PreviewResult.ok),
                    child: const Text('Ok'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.pop(context, PreviewResult.cancel),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
