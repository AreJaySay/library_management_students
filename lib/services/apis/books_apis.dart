import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:students/services/streams/books_streams.dart';
import '../../utils/network_util.dart';

class BlogServices{
  final NetworkUtility _networkUtility = new NetworkUtility();

  Future getBooks()async{
    try {
      return await http.get(Uri.parse("https://gutendex.com/books"),
        headers: {
          "Accept": "application/json"
        },
      ).then((respo) async {
        var data = json.decode(respo.body);
        print("BOOKS ${data}");
        if (respo.statusCode == 200 || respo.statusCode == 201){
          booksStreams.update(data: data["results"]);
        }else{
          return null;
        }
      });
    } catch (e) {
      print("ERROR GET BOOKS $e");
    }
  }
}
final BlogServices blogServices = new BlogServices();