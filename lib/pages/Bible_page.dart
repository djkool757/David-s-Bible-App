import 'package:flutter/material.dart';
import 'package:bible_with/BibleChapterService';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  _BiblePageState createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  final _bibleService = BibleChapterService();
  String currentBook = 'jude';
  int currentChapter = 1;

  Future<String> loadBibleChapter() async {
      final chapterText = await _bibleService.getBibleChapter(
        translation: 'en-kjv',
        book: currentBook.toLowerCase(),
        chapter: currentChapter.toString(),
      );
      return chapterText;
    }

    final Map<String, int> bookChapters = {
      'genesis': 50,
      'exodus': 40,
      'leviticus': 27,
      'numbers': 36,
      'deuteronomy': 34,
      'joshua': 24,
      'judges': 21,
      'ruth': 4,
      '1samuel': 31,
      '2samuel': 24,
      '1kings': 22,
      '2kings': 25,
      '1chronicles': 29,
      '2chronicles': 36,
      'ezra': 10,
      'nehemiah': 13,
      'esther': 10,
      'job': 42,
      'psalms': 150,
      'proverbs': 31,
      'ecclesiastes': 12,
      'song of solomon': 8,
      'isaiah': 66,
      'jeremiah': 52,
      'lamentations': 5,
      'ezekiel': 48,
      'daniel': 12,
      'hosea': 14,
      'joel': 3,
      'amos': 9,
      'obadiah': 1,
      'jonah': 4,
      'micah': 7,
      'nahum': 3,
      'habakkuk': 3,
      'zephaniah': 3,
      'haggai': 2,
      'zechariah': 14,
      'malachi': 4,
      'matthew': 28,
      'mark': 16,
      'luke': 24,
      'john': 21,
      'acts': 28,
      'romans': 16,
      '1corinthians': 16,
      '2corinthians': 13,
      'galatians': 6,
      'ephesians': 6,
      'philippians': 4,
      'colossians': 4,
      '1thessalonians': 5,
      '2thessalonians': 3,
      '1timothy': 6,
      '2timothy': 4,
      'titus': 3,
      'philemon': 1,
      'hebrews': 13,
      'james': 5,
      '1peter': 5,
      '2peter': 3,
      '1john': 5,
      '2john': 1,
      '3john': 1,
      'jude': 1,
      'revelation': 22,
    };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible'),
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder<String>(
            future: loadBibleChapter(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Center(child: Text(snapshot.data ?? ''));
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
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
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0), // adjust as needed
              child: FloatingActionButton.small(
                onPressed: () {
                  _bibleService.getBibleChapter(book: getCurrentBook(), chapter: currentChapter.toString());
                  goToPrevChapterOrBook();
                },
                backgroundColor: Colors.grey,
                child: const Icon(Icons.arrow_back_ios_rounded),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0), // adjust as needed
              child: FloatingActionButton.small(
                onPressed: () {
                  // go to next chapter
                    _bibleService.getBibleChapter(book: getCurrentBook(), chapter: currentChapter.toString());
                    goToNextChapterOrBook();
                },
                backgroundColor: Colors.grey,
                child: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          ),
        ],
      ),
    );
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

String getCurrentBook() {
    return currentBook;
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
}
