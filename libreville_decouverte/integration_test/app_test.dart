import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:libreville_decouverte/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'L application démarre et affiche l écran de connexion',
    (tester) async {
      app.main();

      await tester.pumpAndSettle(
        const Duration(seconds: 5),
      );

      expect(find.text('Se connecter'), findsOneWidget);

      await tester.tap(find.text('Se connecter'));

      await tester.pumpAndSettle();

      expect(find.text('Entre ton email'), findsOneWidget);
    },
  );
}