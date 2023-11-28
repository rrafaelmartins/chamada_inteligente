import 'dart:convert';
import 'package:chamada_inteligente/view/home_aluno.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:chamada_inteligente/view/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MockClient extends Mock implements http.Client {
  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return super.noSuchMethod(
      Invocation.method(#post, [url], {#headers: headers, #body: body, #encoding: encoding}),
      returnValue: Future.value(http.Response('[[1, "Amara", "Paz", 1001, "senha1", 1]]', 200)),
      returnValueForMissingStub: Future.value(http.Response('Error', 404)),
    );
  }
}
void main() {

  group('Login Page Tests', () {
    testWidgets('Successful login navigates to HomeAluno', (WidgetTester tester) async {
      final client = MockClient();


      var url = Uri.http('192.168.0.105:5000', '/LoginAluno');
      // Configuração do mock
      when(client.post(
        url,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('[[1, "Amara", "Paz", 1001, "senha1", 1]]', 200));

      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      
      await tester.enterText(find.widgetWithText(FormInput, 'Usuário:'), '2001');
      await tester.enterText(find.widgetWithText(FormInput, 'Senha:'), 'senha1');

      
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      
      // Checar se navegou para HomeAluno, que tem Icons
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('Unsuccessful login shows error', (WidgetTester tester) async {
      // Mock the HTTP client
      final client = MockClient();

      var url = Uri.http('192.168.0.105:5000', '/LoginAluno');
      // Mock failed login response
      when(client.post(
        url,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"error": "Invalid credentials"}', 401));

      // Render the LoginPage
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      // Enter credentials
      await tester.enterText(find.widgetWithText(FormInput, 'Usuário:'), 'wrongUser');
      await tester.enterText(find.widgetWithText(FormInput, 'Senha:'), 'wrongPassword');

      // Tap the login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check if error dialog is shown
      expect(find.text('Login Inválido!\n\nVerifique Usuário e Senha!'), findsOneWidget);
    });
  });
}