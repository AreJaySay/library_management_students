import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:students/models/borrows.dart';
import 'package:students/models/reservations.dart';
import '../../models/users.dart';

class BorrowsApis{
  FirebaseDatabase database = FirebaseDatabase.instance;

  // GET BORROWS
  Future get() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('borrow');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          borrowsModel.update(data: data.values.toList().where((s) => s["borrower"]["email"] == usersModel.loggedUser.value["email"]).toList());
          print("BORROWS ${data.values.toList()}");
        } else if (data is List) {
          borrowsModel.update(data: data);
        }
      } else {
        borrowsModel.update(data: []);
      }
    });
  }

  Future borrow({required Map details, required String status})async{
    DatabaseReference usersRef = database.ref('borrow');
    await usersRef.push().set({
      "id": "${10000 + Random().nextInt(90000)}",
      "borrower": {
        "name": usersModel.valueLogged["name"],
        "age": usersModel.valueLogged["age"],
        "email": usersModel.valueLogged["email"],
        "school_id": usersModel.valueLogged["school_id"],
        "department": usersModel.valueLogged["department"],
        "year": usersModel.valueLogged["year"],
        "section": usersModel.valueLogged["section"],
      },
      "book_information": jsonEncode(details),
      "borrow_details": {
        "borrow_date": "",
        "end_date": "",
      },
      "status": status,
      "created_at": details["created_at"],
      "accepted_at": "${DateTime.now()}",
    });
  }
}