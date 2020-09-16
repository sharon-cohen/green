
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home/Home.dart';
import 'globalfunc.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'global.dart' as globals;
//final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
final databaseReference = Firestore.instance;
class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String name;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,

                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(

                textAlign: TextAlign.center,
                onChanged: (value) {
                  name = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your name'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Register',
                colour: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      FirebaseUser user=newUser.user;
                      String t=user.uid;
                      databaseReference
                          .collection('user')
                          .document(t)
                          .updateData({'name': name});
                     globals.name=name;
                      bool menag=await doesNameAlreadyExist(email);
                      print(menag);
                       if(menag==true){
                         globals.isMeneger = true;
                         print(globals.isMeneger);
                         await databaseservice(uid: user.uid).updateUserData(name,'menager');
                         Navigator.pushNamed(context,BottomNavigationBarController.id,arguments:ScreenArguments_m(
                             t,name,'menager'
                         ));
                       }

                       else{
                         globals.isMeneger =false;
                         await databaseservice(uid: user.uid).updateUserData(name,'regular');
                         Navigator.pushNamed(context,BottomNavigationBarController.id,arguments:ScreenArguments(
                           t,name,'regular'
                       ));}



//                      var document = await Firestore.instance.collection('users').document('ENsyb4kmVkUbDvNS8ILNARKN49m1'
//                      ).get();
//                          print(document.data['name']);
                      // Navigator.pushNamed(context, BasicGridView.id);
                    }

                    setState(()async {

                      showSpinner = false;
                    });
                  } catch (e) {
                    print('error');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class databaseservice{
  final String uid;
  databaseservice({this.uid});
  final CollectionReference userCollection=Firestore.instance.collection('users');
  Future updateUserData(String name,String role)async{
    return await  userCollection.document(uid).setData({
      'name':name,
      'role':role,

    });

  }



}
class RoundedButton extends StatelessWidget {
  RoundedButton({this.title, this.colour, @required this.onPressed});

  final Color colour;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
Future<bool> doesNameAlreadyExist(String email) async {
  final QuerySnapshot result = await Firestore.instance
      .collection('manegar')
      .where('email', isEqualTo: email)
      .limit(1)
      .getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  return documents.length == 1;
}
