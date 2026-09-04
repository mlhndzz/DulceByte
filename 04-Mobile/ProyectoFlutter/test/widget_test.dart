import 'package:dulcebyte_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DulceByte inicia correctamente', (tester) async {
    await tester.pumpWidget(const DulceByteApp());
    expect(find.text('DulceByte'), findsWidgets);
    expect(find.text('Panel principal'), findsOneWidget);
  });
}
