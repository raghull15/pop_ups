import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MovieApp());

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Bottom Sheet',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.purple[50],
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
      ),
      home: MovieHomePage(),
    );
  }
}

class MovieHomePage extends StatefulWidget {
  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  final List<Map<String, dynamic>> movies = [];

  void _showAddMovieSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String title = '';
    double rating = 5.0;
    bool isFavorite = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 16,
            right: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Add a Movie',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Movie Title',
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 18),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Enter a title' : null,
                        onChanged: (value) => title = value,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Rating: ${rating.toStringAsFixed(1)}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Slider(
                        value: rating,
                        min: 0,
                        max: 10,
                        divisions: 20,
                        activeColor: Colors.purple,
                        label: rating.toStringAsFixed(1),
                        onChanged: (value) =>
                            setModalState(() => rating = value),
                      ),
                      CheckboxListTile(
                        title: Text('Favorite', style: TextStyle(fontSize: 18)),
                        value: isFavorite,
                        activeColor: Colors.purple,
                        onChanged: (value) =>
                            setModalState(() => isFavorite = value ?? false),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              movies.add({
                                'title': title,
                                'rating': rating,
                                'favorite': isFavorite,
                              });
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'Add Movie',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movies List',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: movies.isEmpty
          ? Center(
              child: Text(
                'No movies added yet.',
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (ctx, index) {
                final movie = movies[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      movie['favorite'] ? Icons.star : Icons.movie,
                      color: movie['favorite'] ? Colors.amber : Colors.purple,
                      size: 30,
                    ),
                    title: Text(
                      movie['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Rating: ${movie['rating']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMovieSheet(context),
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }
}
