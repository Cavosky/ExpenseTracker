import 'package:flutter/material.dart';
import 'package:expense_tracker/services/precerence_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentGoal(); // Carichiamo il valore salvato all'avvio
  }

  void _loadCurrentGoal() async {
    double savedGoal = await PrecerenceService.getGoal();
    setState(() {
      _controller.text = savedGoal.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Impostazioni")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Obiettivo di risparmio (€)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                double val = double.tryParse(_controller.text) ?? 0.0;
                await PrecerenceService.saveGoal(val);

                // Feedback all'utente (come un MessageBox)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Obiettivo salvato!")),
                );
              },
              child: const Text("Salva Preferenza"),
            ),
          ],
        ),
      ),
    );
  }
}
