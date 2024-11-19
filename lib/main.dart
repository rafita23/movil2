import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAFAEL NINA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  void _onItemTapped(int index) {
    if (index == 3) {
      setState(() {
        _isDarkMode = !_isDarkMode;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _pages[index]),
      );
    }
  }

  List<Widget> get _pages => [
        const ConversionScreen(),
        const CurrencyConversionScreen(),
        const PrimeScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: Scaffold(
        appBar: AnimatedTitle(),
        body: Center(
          child: Text(
            'Selecciona una opción abajo',
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: _isDarkMode ? Colors.white : Colors.deepPurple,
          unselectedItemColor: _isDarkMode ? Colors.grey : Colors.black54,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.transform),
              label: 'Conversión',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_exchange),
              label: 'Moneda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.numbers),
              label: 'Primo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.brightness_6),
              label: 'Modo',
            ),
          ],
        ),
      ),
    );
  }
}

// Título animado
class AnimatedTitle extends StatefulWidget implements PreferredSizeWidget {
  const AnimatedTitle({super.key});

  @override
  State<AnimatedTitle> createState() => _AnimatedTitleState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _AnimatedTitleState extends State<AnimatedTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          if (_controller.status == AnimationStatus.completed) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
        },
        child: ScaleTransition(
          scale: _animation,
          child: const Text('RAFAEL NINA'),
        ),
      ),
    );
  }
}

// Pantalla de conversión
class ConversionScreen extends StatefulWidget {
  const ConversionScreen({super.key});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  Color _backgroundColor = Colors.white;
  String _selectedSourceBase = '10'; // Base decimal por defecto
  String _selectedTargetBase = '2'; // Base binaria por defecto
  final TextEditingController _valueController = TextEditingController();

  void _convertBase() {
    int? value = int.tryParse(_valueController.text, radix: int.parse(_selectedSourceBase));
    if (value == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Por favor ingrese un número válido.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    String result = value.toRadixString(int.parse(_selectedTargetBase)).toUpperCase();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resultado'),
        content: Text('El resultado es: $result'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AnimatedTitle(),
      body: Container(
        color: _backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: _selectedSourceBase,
              items: const [
                DropdownMenuItem(value: '2', child: Text('Binario')),
                DropdownMenuItem(value: '8', child: Text('Octal')),
                DropdownMenuItem(value: '10', child: Text('Decimal')),
                DropdownMenuItem(value: '16', child: Text('Hexadecimal')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSourceBase = value!;
                });
              },
              isExpanded: true,
              hint: const Text('Seleccione la base origen'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(labelText: 'Valor a convertir'),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedTargetBase,
              items: const [
                DropdownMenuItem(value: '2', child: Text('Binario')),
                DropdownMenuItem(value: '8', child: Text('Octal')),
                DropdownMenuItem(value: '10', child: Text('Decimal')),
                DropdownMenuItem(value: '16', child: Text('Hexadecimal')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedTargetBase = value!;
                });
              },
              isExpanded: true,
              hint: const Text('Seleccione la base destino'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertBase,
              child: const Text('Convertir a Base'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() {
                    _backgroundColor = Colors.blue;
                  }),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Azul'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() {
                    _backgroundColor = Colors.yellow;
                  }),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                  child: const Text('Amarillo'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() {
                    _backgroundColor = Colors.red;
                  }),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Rojo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Pantallas siguientes se mantienen igual
class CurrencyConversionScreen extends StatelessWidget {
  const CurrencyConversionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AnimatedTitle(),
      body: const Center(child: Text('Pantalla de conversión de moneda')),
    );
  }
}

class PrimeScreen extends StatelessWidget {
  const PrimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AnimatedTitle(),
      body: const Center(child: Text('Pantalla de números primos')),
    );
  }
}
