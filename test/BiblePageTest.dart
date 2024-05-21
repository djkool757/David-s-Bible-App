
import 'package:bible_with/BibleChapterService';
import 'package:test/test.dart';
import 'dart:developer';

void main() {
  test('Bible json should be displayed', () async {
    final bibleService = BibleChapterService();
    final chapterText = await bibleService.getBibleChapter(
      translation: 'en-kjv',
      book: '2john',
      chapter: '1',
      verse: '1',
    );
    log(chapterText);
    expect(chapterText, isNotEmpty);
  });
}
