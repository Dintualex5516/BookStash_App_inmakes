import 'package:firebase_auth/firebase_auth.dart';


class AuthServiceHelper {

  static Future<String> cteateAccountWithEmail(String email,String password)async{
try{
  await FirebaseAuth.instance.createUserWithEmailAndPassword(email:email,password:password);
  return "Account Created";
  } on FirebaseAuthException catch(e){
 return e.message.toString();
  }
catch(e){
  return e.toString();
}

}

// login

static Future <String> loginWIthEmail(String email,String password) async {
try{
  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  return "login Sucessfull";
}on FirebaseAuthException catch(e)
{
  return e.message.toString();

}
catch(e)
{
  return e.toString();

}

}

// logout


static Future logout () async {
try{
  await FirebaseAuth.instance.signOut();
  
}on FirebaseAuthException catch(e)
{
  return e.message.toString();

}
catch(e)
{
  return e.toString();

}

}

// check user
static Future<bool>isUserLoggedIn()async{
  var currentUser=FirebaseAuth.instance.currentUser;
  return currentUser!=null? true:false;


}





}