import 'package:expense_tracker/services/database_helper.dart';
import 'package:expense_tracker/services/precerence_service.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});
  @override
  State<StatefulWidget> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Usiamo Future.wait per aspettare sia il saldo che l'obiettivo
      future: Future.wait([
        DatabaseHelper.instance.getBalance(),
        PrecerenceService.getGoal(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        // 2. Controlla se c'è stato un errore (es. query scritta male)
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return Text("Errore: ${snapshot.error}");
        }
        if (!snapshot.hasData) return const CircularProgressIndicator();

        double currentBalance = snapshot.data![0];
        double goal = snapshot.data![1];
        double progress =
            (goal > 0) ? (currentBalance / goal).clamp(0.0, 1.0) : 0.0;

        return Column(
          children: [
            const Text("Obiettivo Risparmio"),
            LinearProgressIndicator(value: progress), // Barra di caricamento
            Text("${(progress * 100).toStringAsFixed(1)}% raggiunto"),
            Text("Mancano: € ${(goal - currentBalance).toStringAsFixed(2)}"),
          ],
        );
      },
    );
  }
}
