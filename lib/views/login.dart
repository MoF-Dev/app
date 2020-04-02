// with guide from https://medium.com/flutterpub/flutter-how-to-do-user-login-with-firebase-a6af760b14d5
import 'package:flutter/material.dart';
import 'package:mof_friends/views/appview.dart';

class LoginSignupPage extends AppWidget {
  final VoidCallback loginCallback;

  LoginSignupPage({app, this.loginCallback}) : super(app: app);

  @override
  State<StatefulWidget> createState() => new _LoginSignupPage();
}

class _LoginSignupPage extends State<LoginSignupPage> {
  bool _isLoading = false;
  String _errorMessage = "";
  bool _isLoginForm = true;
  String _email = "";
  String _password = "";

  final _formKey = new GlobalKey<FormState>();

  final formPadding = EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0);

  String _username = "";

  bool _usernameTaken = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          showForm(),
          showCircularProgress(),
        ],
      ),
    );
  }

  void facebookSignIn() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    try {
      var userId = await widget.app.auth.signInWithFacebook();
      if (userId.length > 0 && userId != null && _isLoginForm) {
        widget.loginCallback();
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  void googleSignIn() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    try {
      var userId = await widget.app.auth.signInWithGoogle();
      if (userId.length > 0 && userId != null && _isLoginForm) {
        widget.loginCallback();
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  Widget showCircularProgress() => _isLoading
      ? Center(child: CircularProgressIndicator())
      : Container(
          height: 0,
          width: 0,
        );

  Widget showConfirmPasswordInput() {
    return Padding(
      padding: formPadding,
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Confirm Password',
            icon: new Icon(
              Icons.lock,
              color: Theme.of(context).hintColor,
            )),
        validator: (value) =>
            value.trim() != _password ? 'Passwords must match' : null,
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: formPadding,
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Theme.of(context).hintColor,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Theme.of(context).errorColor,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showForm() {
    var children = <Widget>[showLogo()];
    if (!_isLoginForm) {
      children.add(_usernameInput());
    }
    children.addAll([
      showEmailInput(),
      showPasswordInput(),
    ]);
    if (!_isLoginForm) {
      children.add(showConfirmPasswordInput());
    }
    children.add(showPrimaryButton());
    if (_isLoginForm) {
      children.add(_googleSignInButton());
      children.add(_facebookSignInButton());
    }
    children.addAll([
      showSecondaryButton(),
      showErrorMessage(),
    ]);
    return new Container(
        padding: EdgeInsets.all(20.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: children,
          ),
        ));
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 32, 0, 32),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/images/beautiful_logo_2.png'),
        ),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: formPadding,
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Theme.of(context).hintColor,
            )),
        validator: (value) => value.trim().length < 6
            ? 'Password must be at least 6 characters long'
            : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: formPadding,
        child: SizedBox(
          height: 40.0,
          child: new OutlineButton(
            splashColor: Theme.of(context).accentColor,
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: Theme.of(context).primaryColor,
            child: new Text(_isLoginForm ? 'Login' : 'Create Account',
                style: new TextStyle(
                    fontSize: 20.0, color: Theme.of(context).accentColor)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget showSecondaryButton() {
    return Padding(
      padding: formPadding,
      child: new FlatButton(
          child: new Text(
              _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
              style:
                  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
          onPressed: toggleFormMode),
    );
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.app.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.app.auth.signUp(_username, _email, _password);
          widget.app.auth.sendEmailVerification();
          // _showVerifyEmailSentDialog();
          print('Signed up user: $userId');
          setState(() {
            _isLoginForm = true;
            _errorMessage = "Log in with your new password";
            resetForm();
          });
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _facebookSignInButton() {
    return Padding(
      padding: formPadding,
      child: OutlineButton(
        splashColor: Theme.of(context).accentColor,
        onPressed: facebookSignIn,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Theme.of(context).accentColor),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/images/fb_logo_blue.png"),
                  height: 28.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Facebook',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _googleSignInButton() {
    return Padding(
      padding: formPadding,
      child: OutlineButton(
        splashColor: Theme.of(context).accentColor,
        onPressed: googleSignIn,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Theme.of(context).accentColor),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/images/google_logo.png"),
                  height: 28.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _usernameInput() {
    return Padding(
      padding: formPadding,
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Username',
            icon: new Icon(
              Icons.person,
              color: Theme.of(context).hintColor,
            )),
        validator: _validateUsername,
        autovalidate: true,
        onSaved: (value) => _username = value.trim(),
      ),
    );
  }

  String _validateUsername(String value) {
    value = value.trim();
    if (value.isEmpty) return null;
    if (value.length < 4) {
      return "Username must be at least 4 characters";
    }
    RegExp exp = new RegExp(r"^[a-z0-9][a-z0-9_]+$", caseSensitive: false);
    if (!exp.hasMatch(value)) {
      return "Username can contain only alphabets and digits";
    }
    widget.app.auth.usernameAvailable(value).then((avail) {
      _usernameTaken = !avail;
    }).catchError((e) => print(e));
    if (_usernameTaken) {
      return "Username is already taken";
    }
    return null;
  }
}
