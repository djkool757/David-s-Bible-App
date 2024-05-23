import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bible_with/BibleChapterService'; // Corrected the import statement
import 'package:bible_with/BooksMap.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  _BiblePageState createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  final _bibleService = BibleChapterService();
  String currentBook = 'matthew';
  int currentChapter = 1;

  Future<String> loadBibleChapter() async {
    final chapterData = await _bibleService.getBibleChapter(
      translation: 'en-kjv',
      book: currentBook.toLowerCase(),
      chapter: currentChapter.toString(),
    );

    // Parse the JSON response
    final jsonResponse = jsonDecode(chapterData);

    // Extract the "data" array
    final data = jsonResponse['data'] as List;

    // Extract the "verse" and "text" properties of each object in the array and join them into a single string
    final chapterText =
        data.map((verse) => '${verse['verse']}. ${verse['text']}').join('\n');

    return chapterText;
  }

  void goToNextChapterOrBook() {
    setState(() {
      if (currentChapter < bookChapters[currentBook]!) {
        // Move to the next chapter in the current book
        currentChapter++;
      } else {
        // Move to the first chapter of the next book
        int currentBookIndex = bookChapters.keys.toList().indexOf(currentBook);
        if (currentBookIndex < bookChapters.length - 1) {
          currentBook = bookChapters.keys.toList()[currentBookIndex + 1];
          currentChapter = 1;
        }
      }
    });
  }

  void goToPrevChapterOrBook() {
    setState(() {
      if (currentChapter > 1) {
        // Move to the previous chapter in the current book
        currentChapter--;
      } else {
        // Move to the last chapter of the previous book
        int currentBookIndex = bookChapters.keys.toList().indexOf(currentBook);
        if (currentBookIndex > 0) {
          currentBook = bookChapters.keys.toList()[currentBookIndex - 1];
          currentChapter = bookChapters[currentBook]!;
        }
      }
    });
  }

  List<String> getBooks() {
    return bookChapters.keys.toList();
  }

  List<Widget> displayBooksAsButtons() {
    List<String> books = getBooks();
    return books.map((book) {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            currentBook = book;
            currentChapter = 1;
          });
        },
        child: Text(formatBookName(book)),
      );
    }).toList();
  }

  String formatBookName(String bookName) {
    // Capitalize the book name
    String capitalizedBookName =
        bookName[0].toUpperCase() + bookName.substring(1);

    // Add a space between the number and the first letter if it contains a number
    final regex = RegExp(r'(\d+)(\D+)');
    String formattedBookName =
        capitalizedBookName.replaceAllMapped(regex, (match) {
      return '${match.group(1)} ${match.group(2)}';
    });

    return formattedBookName;
  }

  void showBooksDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Book'),
          content: SingleChildScrollView(
            child: ListBody(
              children: displayBooksAsButtons(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showChapterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Chapter'),
          content: SingleChildScrollView(
            child: ListBody(
              children: List.generate(bookChapters[currentBook]!, (index) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentChapter = index + 1;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('${index + 1}'),
                );
              }),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                showBooksDialog();
              },
              child: Text(formatBookName(currentBook)),
            ),
            const SizedBox(width: 13),
            ElevatedButton(
              onPressed: () {
                showChapterDialog();
              },
              child: Text('$currentChapter'),
            ),
          ],
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: FutureBuilder<String>(
            future: loadBibleChapter(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(snapshot.data ?? ''),
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 174, 173, 173),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bible',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Discover',
            backgroundColor: Color.fromARGB(255, 174, 173, 173),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: goToPrevChapterOrBook,
              child: const Icon(Icons.arrow_back_ios_rounded),
            ),
            FloatingActionButton(
              onPressed: goToNextChapterOrBook,
              child: const Icon(Icons.arrow_forward_ios_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
