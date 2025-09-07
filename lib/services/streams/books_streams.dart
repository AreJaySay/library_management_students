import 'package:rxdart/rxdart.dart';

class BooksStreams{
  final BehaviorSubject<List> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  List get currentdata => subject.value;

  update({required List data}){
    subject.add(data);
  }
}
final BooksStreams booksStreams = new BooksStreams();