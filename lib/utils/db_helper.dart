// import 'dart:convert';
//
// import 'package:flutter/services.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class DBHelper {
//   DBHelper._();
//   static final DBHelper dbHelper = DBHelper._();
//
//   Database? db;
//
//   Future<void> initDB() async {
//     String directorypath = await getDatabasesPath();
//
//     String path = join(directorypath, 'quotes.db');
//
//     db = await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         String query =
//             "CREATE TABLE  IF NOT EXIST quotes(quotes_id INTEGER PRIMARY KEY AUTOINCREMENT, ) ";
//
//         await db.execute(query);
//
//
//         String jsondata =await rootBundle.loadString('assets/json/quotes.json');
//         Map
//       },
//     );
//   }
//
//
//   Future<void> addquotes() async {}
// }
//
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class DBHelper {
//   DBHelper._();
//   static final DBHelper dbHelper = DBHelper._();
//
//   Database? db;
//
//   // Initialize the database
//   Future<void> initDB() async {
//     String directoryPath = await getDatabasesPath();
//     String path = join(directoryPath, 'quotes.db');
//
//     db = await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         String query = """
//           CREATE TABLE IF NOT EXISTS quotes (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             author TEXT,
//             category TEXT,
//             quote TEXT
//           )
//         """;
//         await db.execute(query);
//
//         String jsonData =
//             await rootBundle.loadString('assets/json/quotes.json');
//         Map quotesData = jsonDecode(jsonData);
//         List quotesList = quotesData['quotes'];
//
//         for (var quoteData in quotesList) {
//           String insertQuery = """
//             INSERT INTO quotes (id, author, category, quote)
//             VALUES (${quoteData['id']}, "${quoteData['author']}", "${quoteData['category']}", "${quoteData['quote']}")
//           """;
//
//           // Execute the raw SQL query
//           await db.execute(insertQuery);
//         }
//       },
//     );
//   }
//
//   // Fetch all quotes from the database
//   Future<List<Map<String, dynamic>>> getQuotes() async {
//     return await db!.query('quotes');
//   }
// }

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper dbHelper = DBHelper._();

  Database? db;

  Future initDB() async {
    String directoryPath = await getDatabasesPath();
    String path = join(directoryPath, 'quotes.db');

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        String query = """
          CREATE TABLE IF NOT EXISTS quotes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            author TEXT NOT NULL,
            category TEXT NOT NULL,
            quote TEXT NOT NULL
          )
        """;
        await db.execute(query);

        String jsonData =
            await rootBundle.loadString('assets/json/quotes.json');
        Map quotesData = jsonDecode(jsonData);
        List quotesList = quotesData['quotes'];

        for (var quoteData in quotesList) {
          String insertQuery = """
            INSERT INTO quotes (id, author, category, quote) 
            VALUES (${quoteData['id']}, "${quoteData['author']}", "${quoteData['category']}", "${quoteData['quote']}")
          """;
          await db.execute(insertQuery);
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> getQuotes() async {
    return await db!.query('quotes');
  }

  Future<List<Map<String, dynamic>>> getQuotesByCategory(
      String category) async {
    if (category == 'All') {
      return await db!.query('quotes');
    } else {
      return await db!
          .query('quotes', where: 'category = ?', whereArgs: [category]);
    }
  }
}
