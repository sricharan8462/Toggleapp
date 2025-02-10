import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Image Toggle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Image Toggle App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  int _imageIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<String> _images = [
    "https://upload.wikimedia.org/wikipedia/en/1/13/One_Piece_Anime_Logo_International.png", // First Image
    "https://upload.wikimedia.org/wikipedia/en/a/a4/Roronoa_Zoro.jpg",             // Second Image
    "https://upload.wikimedia.org/wikipedia/en/a/aa/Sanji_%28One_Piece%29.jpg"    // Third Image
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.value = 1.0;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _toggleImage() {
    _controller.forward(from: 0.0);
    setState(() {
      _imageIndex = (_imageIndex + 1) % _images.length;
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
      _imageIndex = 0;
    });
  }

  /// This function shows a confirmation dialog. If the user presses "Yes",
  /// it calls [_reset]. Otherwise, it just dismisses the dialog.
  void _confirmReset() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Reset"),
          content: const Text("Are you sure you want to reset?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _reset();                    // Perform the reset
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.network(
                _images[_imageIndex],
                height: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 50, color: Colors.red);
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleImage,
              child: const Text("Toggle Image"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmReset, // Show the confirmation dialog instead
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 252, 252, 252),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Reset"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
