// import 'package:flutter/material.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:quotes/utils/db_helper.dart';
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//     DBHelper.dbHelper.initDB(); // Initialize the database
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quotes'),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: DBHelper.dbHelper.getQuotes(), // Fetch quotes from the database
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//                 child: Text('Error: ${snapshot.error}')); // Handle errors
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//                 child: Text('No quotes available')); // Show message if no data
//           } else {
//             List<Map<String, dynamic>> quotes = snapshot.data!;
//
//             return ListView.separated(
//               separatorBuilder: (context, index) {
//                 return Divider();
//               },
//               itemCount: quotes.length,
//               itemBuilder: (context, index) {
//                 // Extract the data from each quote
//                 String author = quotes[index]['author'];
//                 String category = quotes[index]['category'];
//                 String quote = quotes[index]['quote'];
//
//                 // Return a ListTile for each quote
//                 return ListTile(
//                   title: Text(quote),
//                   subtitle: Text('$author - $category'),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:quotes/utils/api_helper.dart';
import 'package:quotes/utils/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All';
  late Future<Map?> quotesData;

  @override
  void initState() {
    super.initState();
    DBHelper.dbHelper.initDB();
    quotesData = APIHelper.apiHelper.quotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Quotes'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Dropdown
          Row(
            children: [
              const SizedBox(width: 15),
              DropdownButton(
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                dropdownColor: Colors.grey,
                focusColor: Colors.red,
                icon: const Icon(Icons.category),
                value: selectedCategory,
                items: ['All', 'Motivational', 'Love']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
            ],
          ),

          Expanded(
            child: FutureBuilder(
              future: quotesData,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  Map? data = snapshot.data;
                  List quotes = data?['quotes'] ?? [];

                  if (quotes.isEmpty) {
                    return const Center(
                      child: Text("No quotes available"),
                    );
                  }

                  return ListView.builder(
                    itemCount: quotes.length,
                    itemBuilder: (context, index) {
                      final quote = quotes[index];
                      return ListTile(
                          title: Text(quote['body']),
                          subtitle: Text(quote['author']),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite_border)));
                    },
                  );
                }
                return const Center(child: Text("No data available"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
