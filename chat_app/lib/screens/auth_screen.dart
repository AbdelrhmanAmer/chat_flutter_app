import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLogin = true;
  String _enteredEmail = '';
  String _enteredPassword = '';

  void _summit()async{
    bool isValid = _formKey.currentState!.validate();
    if(!isValid){
      return ;
    }
    _formKey.currentState!.save();
    if(_isLogin){

    }else{
      try{
        final UserCredential  userCredential = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail,
            password: _enteredPassword
        );
      }on FirebaseAuthException catch(e){
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message ?? 'Authentication failed.')
        ),
        );
      }
    }
    log(_enteredEmail);
    log(_enteredPassword);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.7),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: 200,
                child: Image.asset('assets/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Email Address"
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            onSaved: (value) =>  _enteredEmail = value!,
                            validator: (value){
                              if( value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@'))
                              {
                                return 'Please enter a valid email.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15,),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Password",
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            onSaved: (value) =>  _enteredPassword = value! ,
                            validator: (value){
                              if( value == null ||
                                  value.trim().length<6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10,),
                          ElevatedButton(
                              onPressed: _summit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer
                            ),
                              child: Text(_isLogin ? 'Login': 'Sign Up'),
                          ),
                          TextButton(
                            onPressed: (){
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? 'Create an account?'
                                  : 'I already have an account?',
                              style: const TextStyle(fontSize: 13),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        
              )
            ],
          ),
        ),
      ),
    );
  }
}
