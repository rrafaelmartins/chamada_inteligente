import 'package:chamada_inteligente/view/home_aluno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:chamada_inteligente/view/login.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('Login Functionality', () {
    testWidgets('Successful login for student', (WidgetTester tester) async {
      final client = MockClient();

      // Mock the HTTP response for successful login

      when(client.post(
        Uri.parse('http://127.0.0.1/LoginAluno'), // Replace with actual URL
        headers: anyNamed('headers'),
        body: anyNamed('body')
      )).thenAnswer((_) async =>
          http.Response('[["studentId", "studentName", ...]]', 200)); // Mock response format

      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      // Simulate user input
      await tester.enterText(find.byKey(const Key('matriculaField')), '2001');
      await tester.enterText(find.byKey(const Key('passwordField')), 'senha1');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      // Verify navigation
      expect(find.byType(HomeAluno), findsOneWidget); // Verify that it navigates to the student home page
    });

    testWidgets('Failed login attempt', (WidgetTester tester) async {
      final client = MockClient();
      const loginPage = LoginPage();

      // Mock the HTTP response for failed login
      when(client.post(
        Uri.parse('http://127.0.0.1/LoginAluno'), // Replace with actual URL
        headers: anyNamed('headers'),
        body: anyNamed('body')
      )).thenAnswer((_) async =>
          http.Response('[]', 200)); // Empty response indicating failed login

      await tester.pumpWidget(MaterialApp(home: loginPage));

      // Simulate user input
      await tester.enterText(find.byKey(const Key('matriculaField')), '5555');
      await tester.enterText(find.byKey(const Key('passwordField')), 'wrongPassword');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      // Verify that it does not navigate to the student home page
      expect(find.byType(HomeAluno), findsNothing);
    });
  });
}
