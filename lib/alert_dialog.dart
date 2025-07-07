import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fast Food AlertDialog',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.orange.shade50,
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          bodyLarge: const TextStyle(fontSize: 20),
          bodyMedium: const TextStyle(fontSize: 18),
          titleLarge: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? lastResult;

  Future<void> _showAlertDialog() async {
    final formKey = GlobalKey<FormState>();
    String food = '';
    double rating = 5;
    bool isFav = false;
    Color color = Colors.red;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.orange.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Add Fast Food',
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Food name'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter food name' : null,
                        onSaved: (v) => food = v!,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Rating: ${rating.toInt()}',
                            style: GoogleFonts.poppins(fontSize: 18),
                          ),
                          Expanded(
                            child: Slider(
                              value: rating,
                              min: 1,
                              max: 10,
                              divisions: 9,
                              label: rating.toInt().toString(),
                              activeColor: Colors.deepOrange,
                              onChanged: (v) => setState(() => rating = v),
                            ),
                          ),
                        ],
                      ),
                      CheckboxListTile(
                        title: Text('Favorite?', style: GoogleFonts.poppins()),
                        value: isFav,
                        onChanged: (v) => setState(() => isFav = v ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      DropdownButtonFormField<Color>(
                        value: color,
                        decoration: const InputDecoration(labelText: 'Color'),
                        items: _colorDropdownItems(),
                        onChanged: (v) {
                          if (v != null) setState(() => color = v);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel', style: GoogleFonts.poppins(fontSize: 16)),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ),
                  child: Text('Submit', style: GoogleFonts.poppins(fontSize: 16)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      Navigator.pop(context, {
                        'food': food,
                        'rating': rating.toInt(),
                        'favorite': isFav,
                        'color': color,
                      });
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        lastResult = result;
      });
    }
  }

  List<DropdownMenuItem<Color>> _colorDropdownItems() {
    return [
      DropdownMenuItem(value: Colors.red, child: Text('Red')),
      DropdownMenuItem(value: Colors.green, child: Text('Green')),
      DropdownMenuItem(value: Colors.blue, child: Text('Blue')),
      DropdownMenuItem(value: Colors.pink, child: Text('Pink')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fast Food AlertDialog',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: lastResult == null
            ? Text(
                'Tap the button to add a fast food!',
                style: GoogleFonts.poppins(fontSize: 20),
              )
            : Card(
                color: lastResult!['color'] as Color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  title: Text(
                    lastResult!['food'],
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Rating: ${lastResult!['rating']}, Favorite: ${lastResult!['favorite']}',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: _showAlertDialog,
        child: const Icon(Icons.fastfood),
      ),
    );
  }
}
