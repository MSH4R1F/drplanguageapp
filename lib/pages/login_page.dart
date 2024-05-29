import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Login to Bloom"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/bloom.png'),
                child: Text('logo', style: TextStyle(color: Colors.black))),
            // App Name
            const Text(
              'Bloom',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            // Login Button
            const SizedBox(height: 20),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 40)),
            ElevatedButton(
              onPressed: () {
                // Navigate to homepage
                Navigator.pushNamed(context, '/dashboard');
              },
              child: const Text('Login'),
            ),
            // Register Button
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Respond to button press
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text('Register'),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}