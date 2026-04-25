import 'package:firebase_database/firebase_database.dart';
import 'package:students/models/users.dart';

class UsersApi{
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future getUsers() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');
      ref.onValue.listen((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;
        if (dataSnapshot.exists) {
          final data = dataSnapshot.value;
          if (data is Map) {
            usersModel.update(data: data.values.toList());
          } else if (data is List) {
            usersModel.update(data: data);
          }
        } else {
          usersModel.update(data: []);
        }
    });
  }

  Future edit({required String id,required Map payload})async{
    DatabaseReference usersRef = database.ref('users');
    FirebaseDatabase.instance.ref().child('users').orderByChild("id").equalTo(id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/name": payload["name"],
        "${event.snapshot.key!}/age": payload["age"],
        "${event.snapshot.key!}/email": payload["email"],
        "${event.snapshot.key!}/school_id": payload["school_id"],
        "${event.snapshot.key!}/department": payload["department"],
        "${event.snapshot.key!}/course": payload["course"],
        "${event.snapshot.key!}/year": payload["year"],
        "${event.snapshot.key!}/section": payload["section"],
        "${event.snapshot.key!}/base64Image": payload["base64Image"],
      });
    });
  }

  Future changePassword({required String id,required String password})async{
    DatabaseReference usersRef = database.ref('users');
    FirebaseDatabase.instance.ref().child('users').orderByChild("id").equalTo(id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/password": password,
      });
    });
  }
}

